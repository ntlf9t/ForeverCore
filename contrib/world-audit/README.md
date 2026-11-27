# World script audit

`world_script_audit.py` lists creatures whose spawns should move or be scripted on Everlake but are not. It reads the
world the way the worldserver builds it (this fork's `sql/custom/world` plus the data repository's `sql/world`, by file
name) and compares it with VMaNGOS' 1.12 world and with the scripts this core registers.

```bash
# VMaNGOS' world database, SQLite build (GPL-2.0): release db_latest of github.com/vmangos/core
gh release download db_latest -R vmangos/core -p 'db-sqlite-*.zip' -D /tmp/vmangos && unzip -q /tmp/vmangos/db-sqlite-*.zip -d /tmp/vmangos

python3 contrib/world-audit/world_script_audit.py \
    --vmangos /tmp/vmangos/sqlite-dump/mangos.sqlite \
    --world-data ../wow-everlake-world-data \
    --spawns spawns.json \
    --out contrib/world-audit/results/$(date +%F)
```

`--spawns` is the ForeverTracker's Spawns list (`[{"kind": "npc", "entry": 15209, "name": "...", "state": "ready"}]`).
`--port-sql FILE` writes the SQL that gives each converted VMaNGOS spawn (guid = VMaNGOS guid + 20,000,000) the path it walks in
VMaNGOS, where Everlake has it at MovementType 2 with no `waypoint_path_node` rows. That is how
`sql/custom/world/2026_11_17_20_world_classic_event_spawn_paths.sql` was made.

## Checks

| Check | Meaning | What to do |
|---|---|---|
| Walk a path in VMaNGOS, stand on Everlake | Same creature within 15 yd on the same map, VMaNGOS has 2+ path points, Everlake has no path | Same guid: `--port-sql`. Otherwise read both spawns first |
| MovementType 2 without a path | The core logs it and the creature stands still | Give it a path or set MovementType 0/1 |
| Unknown ScriptName | No `*Script("name")` or `Register*(name)` in `src/` | Port the script or clear the name |
| Unknown AIName / SmartAI without rows | No AI factory of that name, or no `smart_scripts` rows | Add the rows or clear AIName |
| Summoned or event-only, offered as static spawns | VMaNGOS never spawns the creature, or spawns it only for a world event | Don't spawn it. Find the script, spell or event that brings it in |

The reader takes only literal rows. Statements built with `INSERT ... SELECT` or unknown variables are counted under
"not read". Template rows that come straight from TDB, which no file here changes, are not in the files and are not
checked.
