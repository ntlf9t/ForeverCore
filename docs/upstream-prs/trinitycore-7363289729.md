# TrinityCore 7363289729: vendor data for Stone Guard Nargol (Orgrimmar)

Foldor1, 2026-10-01, TrinityCore#32034. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. World data: the Forever world DB
release `forever-tdb-2026-10-14` (its `updates` table does not list this file, so Everlake's worldserver would apply it).
Client data: wago.tools export of 1.60.1.70862 (Item, ItemSparse).

**Claim.** Stone Guard Nargol (50488, Orgrimmar Quartermaster) gets a new item, Earthen Storage Crate (253168), and the
other five rows get new slots, PlayerConditionIDs (12247, 12248) and `VerifiedBuild` 69933.

**Check.** In the Forever release 50488 has the template and the same five `npc_vendor` rows (45581, 64908, 64909,
64910, 67533), but **no spawn**: no `creature` row has id 50488 (the release has 365 spawns in a box around Orgrimmar on
map 1; Nargol is not one). None of the six items is in the 70862 `Item` table (253168 is a retail The War Within item; the others are
Wrath/Cataclysm reputation items). The file was applied to a scratch MySQL 8.0 holding the release's tables:
`npc_vendor` for 50488 changes exactly as claimed (slots shift by one, 253168 added at slot 1, conditions set on four
rows); nothing else changes.

**Test.** None: no code. Before/after diff of the scratch DB as above.

**Verdict:** take. Inert on Everlake (vendor not spawned, items not in the client); keeps `sql/updates/world` in line
with TrinityCore.
