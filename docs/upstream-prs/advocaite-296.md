# advocaite/TrinityCore#296: PvP: honor is paid as the Honor currency (1792), so the PvP quartermasters work

Karrz1, 2026-11-01, commit dcba863b17. Reviewed 2026-11-08 against `everlake` dab8f8aa45, together with #182 and #321.

**Claim.** Honor only went into the retail honor level bar (`AddHonorXP`), never into currency 1792, so nothing at the PvP
quartermasters (ItemExtendedCost 11575-11706: Honor 1792 plus marks) could be bought.

**Check.** True: in `everlake` nothing adds currency 1792 (CurrencyTypes 1792 "Honor Points", MaxQty 25000 in the client).
`Player::RewardHonor` now also adds the honor to 1792, after all its gates (arena, Inactive, same team, grey level, rate),
for every honor source: kills (with #182), battleground objectives and wins, quest honor, `.honor add`. The For Great Honor
perk (SPELL_AURA_MOD_CURRENCY_GAIN on 1792) moves from a hand-made multiplier on kill honor to `ModifyCurrency`, which
applies it to every gain. So: the perk now counts for objective and quest honor too (as the aura says), and the PvPCredit
number and the honor bar no longer include the perk bonus; only the currency does. Not paid twice: no quest in the world
release rewards both honor and currency 1792, and nothing else adds 1792. The 25000 cap is enforced by `ModifyCurrency`.
#321's rank points are a separate track (faction 2800), not honor.

**Test.** None in `tests/`: it needs a Player with currencies and auras. PTR: `.honor add 100`: the currency window shows
Honor +100. With For Great Honor: +the perk's percent on the currency. Buy something from Lady Palanseer (12792) with
enough honor and marks.

**Verdict:** take.
