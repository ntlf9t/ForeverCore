# TrinityCore 8f89a34954: power after resurrect from PowerType flags

Shauren, 2026-10-06. Reviewed 2026-11-09 against `everlake` 481808222d. Spell and power data: wago.tools export of the 1.60.1.70862 client (SpellEffect, SpellName, PowerType, ChrClasses).

**Claim.** Instead of hard-coded rules (rage 0, energy and focus to the restore percent), each power after resurrect
follows its PowerType flags: `SetToMaxOnResurrect` -> full, else the default unless `NotSetToDefaultOnResurrect`.

**Check.** In 70862 Mana (flags 0x70c0) and Energy (0x7400) both have `SetToMaxOnResurrect` (0x4000), and the loop runs
after the mana line that applies `restore_percent`. So on Everlake every resurrection would give **full mana and
energy**: the corpse run, the spirit healer, a priest's Resurrection, a Soulstone. Today they give the restore percent.
The flag is in the Forever client's data, but whether live Forever gives full mana on resurrect is not known (no
public source checked, and we don't record on live).

**Test.** None.

**Verdict:** hold, until live Forever's behaviour is known or the user decides. If taken, it is a gameplay change for
every class with mana or energy.
