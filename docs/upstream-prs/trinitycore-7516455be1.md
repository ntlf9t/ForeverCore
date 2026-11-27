# TrinityCore 7516455be1: loot for The Stockade bosses

Naddley, 2026-10-12, closes TrinityCore issue #30868. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. World data: Forever
world DB release `forever-tdb-2026-10-14` (file not in its `updates` table, so it would be applied). Client data:
wago.tools export of 1.60.1.70862 (Item). NPC list: QuestieDB's Forever NPC data.

**Claim.** Loot and gold for the Cataclysm-era Stockade bosses Randolph Moloch (46383), Lord Overheat (46264) and Hogger
(46254) through new reference loot 350000-350002; their `DifficultyID` 0 rows are deleted; `StaticFlags1` (Amphibious,
CanSwim), level scaling and `VerifiedBuild` updated on 24 Stockade creatures and on Summon Enabler Stalker (53488).

**Check.** The Stockade in Forever is the Classic one. The release spawns 95 creatures on map 34: the Classic bosses
Targorr the Dread (1696), Kam Deepfury (1666), Hamhock (1717), Bazil Thredd (1716), Dextren Ward (1663) and Bruegal
Ironknuckle (1720) and the Classic Defias trash (1706-1715). It spawns **none** of the 28 entries this file touches
(0 `creature` rows), and QuestieDB's Forever NPC list has none of the three Cataclysm bosses. 53488 is not spawned,
not summoned by any 70862 spell (`SpellEffect` misc values) and not used by `smart_scripts`.
Forever's own boss loot is untouched: the Classic bosses keep `LootID` = their entry (7, 7, 57, 78, 9 and 6
`creature_loot_template` rows), and the before/after diff shows no change to any of them.
Of the 15 new loot items, only the six Classic ones (4676, 1929, 5967, 2168, 1934, 1959) are in the 70862 `Item`
table; the Cataclysm/Legion/BfA ones (63344-63346, 62305, 132569, 132570, 151074-151077) are not.
Applied on a scratch MySQL 8.0 with the release's tables: 4 `creature_loot_template` rows and 15
`reference_loot_template` rows added (350000-350002 were unused in the release and in our `sql/custom`), 3
`DifficultyID` 0 rows deleted, the `creature_template_difficulty` rows changed as claimed; 53488's ContentTuning
2884 -> 2951 and `StaticFlags1` 0x20000100 -> 0x100. Nothing else changes.

**Test.** None: no code. Before/after diff as above.

**Verdict:** take. It does not replace or add to Forever's Stockade loot; it only fills in rows for unspawned
Cataclysm creatures. Inert on Everlake; keeps `sql/updates/world` in line with TrinityCore.
