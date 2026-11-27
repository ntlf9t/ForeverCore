# TrinityCore a24210deb8: Windfury Weapon's proc no longer reads a missing Unruly Winds aura

Kevin Xu, 2026-10-14, TrinityCore#32063. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** `WindfuryProcEvent::Trigger` read `unrulyWinds->GetAmount()` without checking that the shaman has Unruly
Winds (390288), so a shaman without the talent crashed the server on a Windfury proc.

**Check.** True for TrinityCore: the `if` has an initializer and no null check. On Everlake the code cannot run: its
only caller is the retail script `spell_sha_windfury_weapon_proc` (319773), and none of 319773, 25504, 334302, 390288,
466440, 466442, 466443 exists in the 1.60.1.70862 client's SpellName (wago.tools export), so the script fails its
`Validate` and is never bound. Forever's own Windfury Weapon (439431) is the Classic script from
advocaite/TrinityCore#325. Taken so `spell_shaman.cpp` stays in line with TrinityCore and later fixes to it apply.

**Test.** None: the code is unreachable with Forever's spell data. The fix is a null check.

**Verdict:** take.
