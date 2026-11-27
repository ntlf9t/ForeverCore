#!/usr/bin/env python3
"""World script audit: creatures that should move or be scripted on Everlake but are not.

    python3 contrib/world-audit/world_script_audit.py \
        --vmangos mangos.sqlite                      # VMaNGOS world, SQLite build (github.com/vmangos/core release db_latest)
        [--world-data ../wow-everlake-world-data]    # its sql/world files are applied with the fork's own, by file name
        [--spawns spawns.json]                       # the ForeverTracker's Spawns list: [{"kind": "npc", "entry": 1, "state": "ready"}, ...]
        [--out report]                               # writes report.md and report.json (default: print the summary)

The world is read the way the worldserver builds it: the fork's sql/custom/world files (baseline 01/02 first, which
replace the creature, creature_addon, waypoint_path_node, smart_scripts and gameobject tables whole) and the data
repository's sql/world files, in file-name order. Only literal rows are read: a statement built with INSERT ... SELECT or
an expression the reader does not know is counted as "not read", so the report says how much it could not see. Rows of
TDB that the baseline does not replace (creature_template and gameobject_template rows nobody changed) are not in these
files: their ScriptName and AIName are TDB's own and are not checked.

Checks
  1. movement     a creature VMaNGOS moves along a path (creature_movement, creature_movement_template, movement_type 2),
                  spawned at the same place on Everlake (same entry, same map, within --radius yards) without a path:
                  MovementType is not 2, or it is 2 and its creature_addon PathId has no waypoint_path_node rows.
                  Also every Everlake MovementType 2 spawn whose path is missing (the core logs it and stands it still).
  2. scripts      creature and gameobject templates (and creature spawns) whose ScriptName no script of the core
                  registers, AIName that names no AI factory, and SmartAI / SmartGameObjectAI without smart_scripts rows.
  3. summoned     creatures Everlake does not spawn that VMaNGOS knows but never spawns either (any patch): a script,
                  a spell or an event brings them in. With --spawns, the ones the tracker offers as static spawns.

VMaNGOS is GPL-2.0 (github.com/vmangos/core); its database is only read here.
"""
import argparse
import json
import math
import os
import re
import sqlite3
import sys
from collections import Counter, defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
VMANGOS_PATCH = 10      # 1.12
MOVE_WAYPOINT = 2

# TrinityCore column orders, for rows written without a column list (the baseline writes them so)
COLUMNS = {
    'creature': ['guid', 'id', 'map', 'zoneId', 'areaId', 'spawnDifficulties', 'phaseUseFlags', 'PhaseId', 'PhaseGroup',
                 'terrainSwapMap', 'modelid', 'equipment_id', 'position_x', 'position_y', 'position_z', 'orientation',
                 'spawntimesecs', 'wander_distance', 'currentwaypoint', 'curHealthPct', 'MovementType', 'npcflag',
                 'unit_flags', 'unit_flags2', 'unit_flags3', 'ScriptName', 'StringId', 'VerifiedBuild'],
    'creature_addon': ['guid', 'PathId'],
    'waypoint_path_node': ['PathId', 'NodeId', 'PositionX', 'PositionY', 'PositionZ', 'Orientation', 'Delay'],
    'waypoint_path': ['PathId', 'MoveType', 'Flags'],
    'smart_scripts': ['entryorguid', 'source_type'],
    'gameobject': ['guid', 'id'],
}
KEYS = {'creature': ('guid',), 'creature_addon': ('guid',), 'waypoint_path_node': ('PathId', 'NodeId'),
        'waypoint_path': ('PathId',), 'smart_scripts': None, 'creature_template': ('entry',),
        'gameobject_template': ('entry',), 'gameobject': ('guid',)}
KEEP = {'creature': ('id', 'map', 'position_x', 'position_y', 'MovementType', 'ScriptName'),
        'creature_addon': ('PathId',), 'waypoint_path_node': (), 'waypoint_path': (), 'smart_scripts': ('entryorguid', 'source_type'),
        'creature_template': ('name', 'AIName', 'ScriptName'), 'gameobject_template': ('name', 'AIName', 'ScriptName'),
        'gameobject': ('id',)}
TABLES = set(KEYS)
INTS = {'guid', 'id', 'map', 'MovementType', 'PathId', 'NodeId', 'entryorguid', 'source_type', 'entry'}
FLOATS = {'position_x', 'position_y'}


def number(column, value):
    """The baseline quotes numbers in some tables ('15209'): the same type whichever way a file wrote it."""
    if value is None or (column not in INTS and column not in FLOATS):
        return value
    try:
        return int(value) if column in INTS else float(value)
    except (TypeError, ValueError):
        return value

STATEMENT = re.compile(r'\b(INSERT(?:\s+IGNORE)?|REPLACE)\s+INTO\s+`?(\w+)`?\s*(\([^)]*\))?\s*VALUES\s*', re.I)
OTHER = re.compile(r'\b(UPDATE|DELETE\s+FROM)\s+`?(\w+)`?\s+', re.I)
SETVAR = re.compile(r'\bSET\s+(@\w+)\s*:?=\s*(-?\d+)\s*;', re.I)


class Reader:
    """Literal SQL rows of the tracked tables, applied in order."""

    def __init__(self):
        self.rows = {t: {} for t in TABLES}
        self.smart = Counter()          # (entryorguid, source_type) -> rows
        self.unread = Counter()         # table -> statements not read
        self.files = 0

    # -- values
    @staticmethod
    def scalar(token, variables):
        token = token.strip()
        if token.upper() == 'NULL':
            return None
        if token[:1] == "'":
            return token[1:-1].replace("\\'", "'").replace("''", "'")
        expr = re.fullmatch(r'(@\w+)\s*([+-])\s*(\d+)|(@\w+)', token)
        if expr:
            name = expr.group(1) or expr.group(4)
            if name not in variables:
                raise ValueError(token)
            base = variables[name]
            if expr.group(2):
                base = base + int(expr.group(3)) if expr.group(2) == '+' else base - int(expr.group(3))
            return base
        try:
            return int(token)
        except ValueError:
            return float(token)

    @staticmethod
    def tuples(text, pos):
        """Yields the raw fields of each (...) tuple from pos to the statement's end; returns at ';'."""
        n = len(text)
        while pos < n:
            while pos < n and text[pos] in ' \t\r\n,':
                pos += 1
            if pos >= n or text[pos] != '(':
                return
            pos += 1
            fields, start, depth, quote = [], pos, 0, False
            while pos < n:
                c = text[pos]
                if quote:
                    if c == '\\':
                        pos += 2
                        continue
                    if c == "'":
                        if pos + 1 < n and text[pos + 1] == "'":
                            pos += 2
                            continue
                        quote = False
                elif c == "'":
                    quote = True
                elif c == '(':
                    depth += 1
                elif c == ')':
                    if depth == 0:
                        fields.append(text[start:pos])
                        pos += 1
                        break
                    depth -= 1
                elif c == ',' and depth == 0:
                    fields.append(text[start:pos])
                    start = pos + 1
                pos += 1
            yield fields

    # -- statements
    def read(self, path):
        with open(path, encoding='utf-8', errors='replace') as handle:
            text = handle.read()
        text = re.sub(r'/\*.*?\*/', ' ', text, flags=re.S)
        text = re.sub(r'(?m)^\s*--[^\n]*$', ' ', text)
        self.files += 1
        variables = {}
        events = [(m.start(), 'var', m) for m in SETVAR.finditer(text)]
        events += [(m.start(), 'ins', m) for m in STATEMENT.finditer(text) if m.group(2).lower() in TABLES]
        events += [(m.start(), 'oth', m) for m in OTHER.finditer(text) if m.group(2).lower() in TABLES]
        for _pos, kind, m in sorted(events, key=lambda e: e[0]):
            if kind == 'var':
                variables[m.group(1)] = int(m.group(2))
            elif kind == 'ins':
                self.insert(text, m, variables)
            else:
                end = text.find(';', m.end())
                self.other(m.group(1).upper().split()[0], m.group(2).lower(), text[m.end():end if end >= 0 else len(text)], variables)

    def insert(self, text, m, variables):
        table = m.group(2).lower()
        replace = m.group(1).upper() == 'REPLACE'
        columns = [c.strip().strip('`') for c in m.group(3)[1:-1].split(',')] if m.group(3) else COLUMNS.get(table)
        if not columns:
            self.unread[table] += 1
            return
        for fields in self.tuples(text, m.end()):
            try:
                values = [self.scalar(f, variables) for f in fields[:len(columns)]]
            except ValueError:
                self.unread[table] += 1
                continue
            row = {c: number(c, v) for c, v in zip(columns, values)}
            if table == 'smart_scripts':
                self.smart[(row.get('entryorguid'), row.get('source_type'))] += 1
                continue
            key = tuple(row.get(k) for k in KEYS[table])
            if None in key:
                self.unread[table] += 1
                continue
            store = self.rows[table]
            if key in store and not replace and m.group(1).upper().startswith('INSERT'):
                if 'IGNORE' in m.group(1).upper():
                    continue
            keep = {c: row[c] for c in KEEP[table] if c in row}
            if key in store and not replace:
                store[key].update(keep)     # INSERT on an existing key fails in MySQL; keep what was there, add what is new
            else:
                store[key] = keep

    WHERE = re.compile(r'WHERE\s+`?(\w+)`?\s*(=\s*(\S+?)|IN\s*\(([^)]*)\)|BETWEEN\s+(\S+)\s+AND\s+(\S+?))\s*(?:;|$)', re.I | re.S)

    def keys_of(self, body, variables):
        where = self.WHERE.search(body)
        if not where:
            return None, None
        column = where.group(1)
        try:
            if where.group(3) is not None:
                values = [number(column, self.scalar(where.group(3), variables))]
            elif where.group(4) is not None:
                values = [number(column, self.scalar(v, variables)) for v in where.group(4).split(',') if v.strip()]
            else:
                low, high = self.scalar(where.group(5), variables), self.scalar(where.group(6), variables)
                values = list(range(int(low), int(high) + 1))
        except ValueError:
            return None, None
        return column, values

    def other(self, verb, table, body, variables):
        if verb == 'DELETE' and not body.strip().upper().startswith('WHERE'):
            self.rows[table].clear()
            if table == 'smart_scripts':
                self.smart.clear()
            return
        column, values = self.keys_of(body, variables)
        if column is None:
            self.unread[table] += 1
            return
        if table == 'smart_scripts':
            if verb == 'DELETE' and column == 'entryorguid':
                source = re.search(r'source_type`?\s*=\s*(\d+)', body)
                for key in [k for k in self.smart if k[0] in values and (not source or k[1] == int(source.group(1)))]:
                    del self.smart[key]
            elif verb == 'DELETE':
                self.unread[table] += 1
            return
        keycols = KEYS[table]
        store = self.rows[table]
        if column not in keycols:
            self.unread[table] += 1
            return
        index = keycols.index(column)
        wanted = set(values)
        hits = [k for k in store if k[index] in wanted]
        if verb == 'DELETE':
            for k in hits:
                del store[k]
            return
        sets = body[:body.upper().find('WHERE')]
        assigned = {}
        for c, v in re.findall(r"`?(\w+)`?\s*=\s*('(?:[^'\\]|\\.|'')*'|[^,\s]+)", sets.replace('SET', '', 1) if sets.upper().lstrip().startswith('SET') else sets):
            if c in KEEP[table]:
                try:
                    assigned[c] = number(c, self.scalar(v, variables))
                except ValueError:
                    self.unread[table] += 1
                    return
        for k in hits:
            store[k].update(assigned)
        if len(keycols) == 1 and not hits and assigned:
            # an UPDATE of a template row the files never wrote: TDB holds it; remember the new value anyway
            for v in wanted:
                store[(v,)] = dict(assigned)


def sql_files(world_data):
    files = {}
    folder = os.path.join(ROOT, 'sql', 'custom', 'world')
    for name in os.listdir(folder):
        if name.endswith('.sql'):
            files[name] = os.path.join(folder, name)
    if world_data:
        folder = os.path.join(world_data, 'sql', 'world')
        for name in os.listdir(folder):
            if name.endswith('.sql'):
                files.setdefault(name, os.path.join(folder, name))
    return [files[n] for n in sorted(files)]


SCRIPT_CTOR = re.compile(r'\b\w*(?:Script|ScriptLoader\w*)(?:<[^;{}()]*?>)?\s*\(\s*"([^"]+)"')
REGISTER = re.compile(r'\bRegister\w*?(?:AI|Script)\w*\s*\(\s*(\w+)')
AI_FACTORY = re.compile(r'AIFactory<[^>]*>\s*\(\s*"(\w+)"')


def core_scripts():
    """(script names the core registers, AI names its factories register)."""
    names, ais = set(), set()
    for base, _dirs, files in os.walk(os.path.join(ROOT, 'src')):
        for name in files:
            if not name.endswith(('.cpp', '.h')):
                continue
            with open(os.path.join(base, name), encoding='utf-8', errors='replace') as handle:
                text = handle.read()
            if 'scripts' in base.split(os.sep) or 'Script' in text:
                names.update(SCRIPT_CTOR.findall(text))
                names.update(REGISTER.findall(text))
            ais.update(AI_FACTORY.findall(text))
    return names, ais


def vmangos(path):
    db = sqlite3.connect(f'file:{path}?mode=ro', uri=True)
    db.row_factory = sqlite3.Row
    inpatch = f'patch_min <= {VMANGOS_PATCH} AND patch_max >= {VMANGOS_PATCH}'
    names = {r['entry']: r['name'] for r in db.execute(f'SELECT entry, name FROM creature_template GROUP BY entry')}
    paths_guid = {r[0]: r[1] for r in db.execute('SELECT id, COUNT(*) FROM creature_movement GROUP BY id')}
    paths_entry = {r[0]: r[1] for r in db.execute('SELECT entry, COUNT(*) FROM creature_movement_template GROUP BY entry')}
    spawns, ever_spawned = [], set()
    for r in db.execute('SELECT guid, id, id2, id3, id4, id5, map, position_x x, position_y y, movement_type, patch_min, patch_max FROM creature'):
        entries = [e for e in (r['id'], r['id2'], r['id3'], r['id4'], r['id5']) if e]
        ever_spawned.update(entries)
        if not (r['patch_min'] <= VMANGOS_PATCH <= r['patch_max']):
            continue
        nodes = paths_guid.get(r['guid']) or max((paths_entry.get(e, 0) for e in entries), default=0)
        spawns.append({'guid': r['guid'], 'entries': entries, 'map': r['map'], 'x': r['x'], 'y': r['y'],
                       'moves': r['movement_type'] == MOVE_WAYPOINT and nodes >= 2, 'nodes': nodes})
    # creatures whose every VMaNGOS spawn belongs to a world event (game_event_creature, event > 0): they stand only
    # while that event runs, never all year
    events = defaultdict(set)
    plain = set()
    linked = {r[0]: r[1] for r in db.execute('SELECT guid, event FROM game_event_creature')}
    for r in db.execute('SELECT guid, id FROM creature'):
        event = linked.get(r[0])
        if event and event > 0:
            events[r[1]].add(event)
        else:
            plain.add(r[1])
    event_only = {e: sorted(v) for e, v in events.items() if e not in plain}
    event_names = {r[0]: r[1] for r in db.execute('SELECT entry, description FROM game_event')}
    return {'names': names, 'spawns': spawns, 'ever_spawned': ever_spawned, 'event_only': event_only, 'event_names': event_names}


def audit(args):
    reader = Reader()
    for path in sql_files(args.world_data):
        reader.read(path)
    rows = reader.rows
    names = {k[0]: (v.get('name') or '') for k, v in rows['creature_template'].items()}
    vm = vmangos(args.vmangos)
    for entry, name in vm['names'].items():
        names.setdefault(entry, name)

    nodes_by_path = Counter(k[0] for k in rows['waypoint_path_node'])
    spawns = []
    by_entry_map = defaultdict(list)
    for (guid,), r in rows['creature'].items():
        if r.get('id') is None:
            continue
        path = (rows['creature_addon'].get((guid,)) or {}).get('PathId') or 0
        s = {'guid': guid, 'entry': int(r['id']), 'map': r.get('map'), 'x': r.get('position_x') or 0.0, 'y': r.get('position_y') or 0.0,
             'move': r.get('MovementType') or 0, 'path': path, 'nodes': nodes_by_path.get(path, 0), 'script': r.get('ScriptName') or ''}
        spawns.append(s)
        by_entry_map[(s['entry'], s['map'])].append(s)
    spawned = {s['entry'] for s in spawns}

    # ---- 1. movement
    missing, matched_ok, not_here = [], 0, 0
    for v in vm['spawns']:
        if not v['moves']:
            continue
        near = []
        for e in v['entries']:
            near += [s for s in by_entry_map.get((e, v['map']), []) if math.hypot(s['x'] - v['x'], s['y'] - v['y']) <= args.radius]
        if not near:
            not_here += 1
            continue
        best = min(near, key=lambda s: math.hypot(s['x'] - v['x'], s['y'] - v['y']))
        if best['move'] == MOVE_WAYPOINT and best['nodes'] >= 2:
            matched_ok += 1
        else:
            missing.append({'entry': best['entry'], 'name': names.get(best['entry'], ''), 'guid': best['guid'], 'map': best['map'],
                            'vmangos_guid': v['guid'], 'vmangos_nodes': v['nodes'], 'everlake_move': best['move'],
                            'everlake_path': best['path'], 'everlake_nodes': best['nodes']})
    broken = [{'entry': s['entry'], 'name': names.get(s['entry'], ''), 'guid': s['guid'], 'path': s['path'], 'nodes': s['nodes']}
              for s in spawns if s['move'] == MOVE_WAYPOINT and s['nodes'] < 2]

    # ---- 2. scripts
    registered, ais = core_scripts()
    smart_entries = {k[0] for k, n in reader.smart.items() if n}
    bad_script, bad_ai, smart_empty = [], [], []
    for table, kind, smart_ai, source in (('creature_template', 'npc', 'SmartAI', 0), ('gameobject_template', 'go', 'SmartGameObjectAI', 1)):
        for (entry,), r in rows[table].items():
            script, ai = r.get('ScriptName') or '', r.get('AIName') or ''
            label = {'kind': kind, 'entry': entry, 'name': r.get('name') or names.get(entry, '') if kind == 'npc' else r.get('name') or ''}
            if script and script not in registered:
                bad_script.append(dict(label, script=script))
            if ai and ai not in ais:
                bad_ai.append(dict(label, ai=ai))
            if ai == smart_ai and reader.smart.get((entry, source), 0) == 0:
                smart_empty.append(dict(label, ai=ai))
    for s in spawns:
        if s['script'] and s['script'] not in registered:
            bad_script.append({'kind': 'npc spawn', 'entry': s['entry'], 'guid': s['guid'], 'name': names.get(s['entry'], ''), 'script': s['script']})

    # ---- 3. summoned
    templates = {k[0] for k in rows['creature_template']} | set(vm['names'])
    summon_only = sorted(e for e in set(vm['names']) if e not in vm['ever_spawned'] and e not in spawned)
    offered = []
    if args.spawns:
        with open(args.spawns, encoding='utf-8') as handle:
            listed = json.load(handle)
        for item in listed:
            entry = int(item['entry'])
            if item.get('kind', 'npc') != 'npc':
                continue
            why = ''
            if entry in set(summon_only):
                why = 'VMaNGOS never spawns it: a script, a spell or an event summons it'
            elif entry in vm['event_only']:
                why = 'VMaNGOS spawns it only for world event ' + ', '.join(f"{e} {vm['event_names'].get(e, '')}".strip() for e in vm['event_only'][entry])
            if why:
                offered.append({'entry': entry, 'name': item.get('name') or names.get(entry, ''), 'state': item.get('state', ''), 'why': why})

    result = {
        'inputs': {'files': reader.files, 'not_read': dict(reader.unread), 'spawns': len(spawns), 'templates_known': len(templates),
                   'vmangos_waypoint_spawns': sum(1 for v in vm['spawns'] if v['moves'])},
        'movement': {'vmangos_paths_matched_and_moving': matched_ok, 'vmangos_paths_not_spawned_here': not_here,
                     'missing_path': missing, 'broken_path': broken},
        'scripts': {'unknown_script_name': bad_script, 'unknown_ai_name': bad_ai, 'smart_ai_without_rows': smart_empty,
                    'registered_names': len(registered)},
        'summoned': {'vmangos_never_spawns': len(summon_only), 'vmangos_event_only': len(vm['event_only']), 'offered_as_static': offered},
    }
    if args.port_sql:
        result['ported'] = port_paths(args, spawns, nodes_by_path, names)
    return result


GUID_OFFSET = 20000000          # converted VMaNGOS creature guids (baseline, 2026_10_17_53 event spawns)
SPAWN_PATH = 800000000          # baseline: PathId of a VMaNGOS spawn path = 800000000 + (guid - 20000000) * 10
ENTRY_PATH = 810000000          # baseline: PathId of a VMaNGOS entry path = 810000000 + entry * 10


def port_paths(args, spawns, nodes_by_path, names):
    """SQL giving a VMaNGOS path to each Everlake spawn converted from the same VMaNGOS spawn (guid - 20,000,000) that
    walks it there but has none here: MovementType 2 with no waypoint_path_node rows. Written the way the baseline wrote
    its own paths (ids, comments, orientation 100 = none). Waypoint scripts (script_id) are not carried."""
    db = sqlite3.connect(f'file:{args.vmangos}?mode=ro', uri=True)
    vm = {r[0]: r for r in db.execute('SELECT guid, id, movement_type FROM creature')}
    picked, paths = [], {}
    for s in sorted(spawns, key=lambda s: s['guid']):
        if s['move'] != MOVE_WAYPOINT or s['nodes'] >= 2 or not GUID_OFFSET < s['guid'] < GUID_OFFSET + 10000000:
            continue
        row = vm.get(s['guid'] - GUID_OFFSET)
        if not row or row[1] != s['entry'] or row[2] != MOVE_WAYPOINT:
            continue
        nodes = db.execute('SELECT point, position_x, position_y, position_z, orientation, waittime FROM creature_movement WHERE id = ? ORDER BY point', (row[0],)).fetchall()
        path, comment = SPAWN_PATH + (s['guid'] - GUID_OFFSET) * 10, 'VMaNGOS 1.12 spawn path'
        if len(nodes) < 2:
            nodes = db.execute('SELECT point, position_x, position_y, position_z, orientation, waittime FROM creature_movement_template WHERE entry = ? ORDER BY point', (s['entry'],)).fetchall()
            path, comment = ENTRY_PATH + s['entry'] * 10, 'VMaNGOS 1.12 entry path'
        if len(nodes) < 2:
            continue
        if path not in paths and nodes_by_path.get(path, 0) < 2:
            paths[path] = (comment, nodes)
        picked.append({'guid': s['guid'], 'entry': s['entry'], 'name': names.get(s['entry'], ''), 'path': path, 'nodes': len(nodes)})
    if not picked:
        return []
    def num(v):
        return f'{v:g}' if isinstance(v, float) else str(v)
    out = ['-- VMaNGOS paths for the world-event spawns that walk one in VMaNGOS (creature_movement, else creature_movement_template)',
           '-- and stood still here: MovementType 2 with no waypoint_path_node rows, since 2026_10_17_53_world_classic_game_event_spawns.sql',
           '-- brought the spawns without their paths. Made by contrib/world-audit/world_script_audit.py --port-sql from VMaNGOS db_latest',
           '-- (github.com/vmangos/core, GPL-2.0). Path ids and comments as the baseline writes them; orientation 100 (none) is NULL.',
           '-- Waypoint scripts (VMaNGOS creature_movement.script_id) are not carried: the spawn walks without them.',
           '-- ' + ', '.join(sorted({f"{p['name']} ({p['entry']})" for p in picked})), '']
    ids = ', '.join(str(p) for p in sorted(paths))
    if paths:
        out.append(f'DELETE FROM `waypoint_path_node` WHERE `PathId` IN ({ids});')
        out.append(f'DELETE FROM `waypoint_path` WHERE `PathId` IN ({ids});')
        out.append('INSERT INTO `waypoint_path` (`PathId`, `MoveType`, `Flags`, `Velocity`, `Comment`) VALUES')
        out.append(',\n'.join(f"({p}, 0, 0, NULL, '{paths[p][0]}')" for p in sorted(paths)) + ';')
        rows = []
        for p in sorted(paths):
            for point, x, y, z, o, wait in paths[p][1]:
                rows.append(f"({p}, {point}, {num(x)}, {num(y)}, {num(z)}, {'NULL' if o == 100 else num(o)}, {wait})")
        out.append('INSERT INTO `waypoint_path_node` (`PathId`, `NodeId`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`, `Delay`) VALUES')
        out.append(',\n'.join(rows) + ';')
    out.append('INSERT INTO `creature_addon` (`guid`, `PathId`) VALUES')
    out.append(',\n'.join(f"({p['guid']}, {p['path']})" for p in picked))
    out.append('ON DUPLICATE KEY UPDATE `PathId` = VALUES(`PathId`);')
    with open(args.port_sql, 'w', encoding='utf-8') as handle:
        handle.write('\n'.join(out) + '\n')
    return picked


def markdown(result):
    i, m, s, u = result['inputs'], result['movement'], result['scripts'], result['summoned']
    out = ['# World script audit', '',
           f"Read {i['files']} SQL files: {i['spawns']} creature spawns. Statements not read: "
           + (', '.join(f'{t} {n}' for t, n in sorted(i['not_read'].items())) or 'none') + '.', '',
           '| Check | Count |', '|---|---|',
           f"| VMaNGOS spawns that walk a path | {i['vmangos_waypoint_spawns']} |",
           f"| ... matched on Everlake and moving | {m['vmangos_paths_matched_and_moving']} |",
           f"| ... matched on Everlake, no path | {len(m['missing_path'])} |",
           f"| ... no Everlake spawn of that creature there | {m['vmangos_paths_not_spawned_here']} |",
           f"| Everlake MovementType 2 without a path | {len(m['broken_path'])} |",
           f"| ScriptName no core script registers | {len(s['unknown_script_name'])} |",
           f"| AIName no AI factory registers | {len(s['unknown_ai_name'])} |",
           f"| SmartAI without smart_scripts rows | {len(s['smart_ai_without_rows'])} |",
           f"| Creatures VMaNGOS never spawns (summoned) | {u['vmangos_never_spawns']} |",
           f"| Creatures VMaNGOS spawns only for a world event | {u['vmangos_event_only']} |",
           f"| Summoned or event-only creatures the tracker offers as static spawns | {len(u['offered_as_static'])} |", '']

    def section(title, rows, cols):
        if not rows:
            return
        out.extend([f'## {title} ({len(rows)})', '', '| ' + ' | '.join(cols) + ' |', '|' + '---|' * len(cols)])
        out.extend('| ' + ' | '.join(str(r.get(c, '')) for c in cols) + ' |' for r in rows)
        out.append('')
    if result.get('ported'):
        out.extend([f"Ported with --port-sql: {len(result['ported'])} spawns get their VMaNGOS path.", ''])
    by_entry = defaultdict(list)
    for r in m['missing_path']:
        by_entry[(r['entry'], r['name'])].append(r)
    grouped = [{'entry': e, 'name': n, 'spawns': len(rs), 'guids': ' '.join(str(r['guid']) for r in rs[:6]) + (' ...' if len(rs) > 6 else '')}
               for (e, n), rs in sorted(by_entry.items(), key=lambda kv: (-len(kv[1]), kv[0][0]))]
    section('Walk a path in VMaNGOS, stand on Everlake', grouped, ['entry', 'name', 'spawns', 'guids'])
    section('MovementType 2 without a path', m['broken_path'], ['entry', 'name', 'guid', 'path', 'nodes'])
    section('Unknown ScriptName', s['unknown_script_name'], ['kind', 'entry', 'name', 'script'])
    section('Unknown AIName', s['unknown_ai_name'], ['kind', 'entry', 'name', 'ai'])
    section('SmartAI without rows', s['smart_ai_without_rows'], ['kind', 'entry', 'name', 'ai'])
    section('Offered by the tracker as static spawns, summoned or event-only in VMaNGOS', u['offered_as_static'], ['entry', 'name', 'state', 'why'])
    return '\n'.join(out)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    parser.add_argument('--vmangos', required=True, help='VMaNGOS world database, SQLite (mangos.sqlite)')
    parser.add_argument('--world-data', help='a wow-everlake-world-data checkout')
    parser.add_argument('--spawns', help="the tracker's Spawns list as JSON")
    parser.add_argument('--radius', type=float, default=15.0, help='yards between a VMaNGOS and an Everlake spawn that count as the same')
    parser.add_argument('--out', help='write <out>.md and <out>.json')
    parser.add_argument('--port-sql', help='write the SQL that gives converted VMaNGOS spawns their missing paths')
    args = parser.parse_args()
    result = audit(args)
    text = markdown(result)
    if args.out:
        with open(args.out + '.md', 'w', encoding='utf-8') as handle:
            handle.write(text + '\n')
        with open(args.out + '.json', 'w', encoding='utf-8') as handle:
            json.dump(result, handle, indent=1)
    print('\n'.join(text.split('\n')[:20]))


if __name__ == '__main__':
    sys.exit(main())
