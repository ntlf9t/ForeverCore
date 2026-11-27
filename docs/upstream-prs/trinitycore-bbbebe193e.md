# TrinityCore bbbebe193e: client-visible battleground instance numbers

Ilir Ivezaj, 2026-10-25 (TrinityCore issue 32051). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** `CreateClientVisibleInstanceId` (the "Warsong Gulch 3" number) never advanced its iterator, so it handed
out 1, then 2 for every later instance. It now returns the lowest free number. It is also keyed by the real
battleground type instead of the queue's type, the same key the delete in `BattlegroundMgr::Update` uses, so numbers of
matches the random queue made are freed again.

**Check.** Read the old loop: `for (itr = begin; itr != end;)` with no `++itr`; with {1} it returns 2, with {1, 2}
it returns 2 again. `Update` erases from `bgDataStore[bg->GetTypeID()]`, and `CreateNewBattleground` now inserts
with `bgTypeId` (the chosen real battleground), so both sides agree. Arenas still get 0 (see 868213670b).

**Test.** None in `tests/` (private member of `BattlegroundMgr`). PTR check: two Warsong Gulch matches at once show
as 1 and 2 in the PvP frame; a third after the first ended gets 1 again.

**Verdict:** take.
