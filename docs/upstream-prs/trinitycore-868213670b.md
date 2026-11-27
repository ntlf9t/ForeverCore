# TrinityCore 868213670b: arena check from BattlemasterList instead of a list of ids

Ilir Ivezaj, 2026-10-24 (TrinityCore issue 32052). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** `BattlegroundMgr::IsArenaType` returned true for the six retail arena ids (4, 5, 6, 8, 10, 11); it now
returns true when the BattlemasterList row's `PvpType` is Arena.

**Check.** 70862 BattlemasterList has 9 rows: 1 Alterac Valley, 2 Warsong Gulch, 3 Arathi Basin, 32 Random
Battleground, 901 Random Epic Battleground, 1122 Battle for Blackrock, 1157 Darkspear Islands, 1159 Battle for Gilneas
(all `PvpType` 0) and 1169 "Mak'gora Arena" (`PvpType` 1). None of the six old ids exists in 70862. The only caller is
`CreateClientVisibleInstanceId` (arenas get client id 0). Forever's `battleground_template` has rows for 1, 2, 3, 32 and
retail ids, not 1169, so on Everlake today the answer is false for every battleground that can be made, as before.

**Test.** None (one DB2 lookup).

**Verdict:** take.
