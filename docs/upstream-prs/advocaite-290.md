# advocaite/TrinityCore#290: Weapon masters: learning a weapon opens its weapon skill

Karrz1, 2026-10-31, commit 6560a0e40b. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A Dwarf Shaman who learned Two-Handed Maces (199) at a weapon master still could not equip a two-handed mace:
the skill stayed at 0.

**Check.** True, and the data agrees. Spell 199 is on skill line 160 (SkillLineAbility AcquireMethod 1, not
AutomaticCharLevel), and the shaman rows of SkillRaceClassInfo for 160 and 172 (rows 702 and 701) have availability 0, so
the skill is not given at creation. `Player::AddSpell` only opened a skill line for AcquireMethod AutomaticCharLevel
spells (and Runeforging). The fix opens the skill of a learned spell on a weapon skill line when the race and class have a
SkillRaceClassInfo row, through `LearnDefaultSkill` (level skills start at 1 of the level cap). Checked every spell on a
weapon skill line in the client: besides the weapon spells themselves they are Shoot Bow/Gun/Crossbow and Throw (learned
with the skill), Parry and the Defensive States (Defense, which everyone has), and Dual Wield; none opens a weapon the
class should not have. Characters who already learned the spell get the skill at their next login, when their spells are
added again. TrinityCore `master` does the same as `everlake` did before (retail has no weapon skills).

**Test.** None in `tests/`: it needs a Player. PTR: a Dwarf Shaman learns Two-Handed Maces at a weapon master: the skill
shows 1/x and a two-handed mace can be equipped. A shaman who learned it before this change: log in, the skill is there.

**Verdict:** take.
