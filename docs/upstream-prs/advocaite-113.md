# advocaite/TrinityCore#113: Hunter pets: pet trainers sell training spells the hunter keeps (and pet start spells, held)

dqhoang (Duy Hoang), 2026-10-21, commits 71a13f6fda and 06c88152e1. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** (1) Buying a pet training spell at a pet trainer (4195 Great Stamina, which teaches the pet 4187) cast it on the
spot instead of putting it in the hunter's spellbook, so the Beast Training window stayed empty and no other pet could be
trained. (2) A tamed hunter pet knows no active ability at all, so the vanilla loop where the pet's use of an ability
teaches the hunter that ability never starts. The second commit gives every hunter pet Growl and its family's combat
abilities at the highest rank its level allows (at tame and on every load), and a 10% chance per use that the pet teaches
its owner the training spell (`Pet::CheckLearning`).

**Check, commit 1 (trainer).** True. In the Forever client (build 70862) 4195 has one effect, LEARN_SPELL (36) of 4187 at
TARGET_UNIT_PET; every hunter pet ability on a family skill line has exactly one such training spell, on skill line 261
Beast Training. `Trainer::Spell::IsCastable()` treats every LEARN_SPELL spell as "cast to teach", so `TeachSpell` cast 4195:
the summoned pet learned 4187 once and the hunter never got 4195. `GetSpellState` checks `HasSpell(4195)` first, so the
trainer kept offering it and took the money again. The fix (learn it when the trigger is a pet ability) is right and
leaves profession ranks and class spells alone. TrinityCore `master` has the same `IsCastable` rule (retail has no pet
training). `SpellMgr::LoadPetTeachSpells` builds the pet ability set from the CreatureFamily skill lines; the map from
ability to training spell it also builds is only used by the held commit 2.

**Check, commit 2 (start spells), held.**
- It hands every tamed pet the whole family's combat set at the top rank for its level, not the tamed creature's own
  abilities. The comment cites vanilla `petcreateinfo_spell`, but that table is per creature: in vanilla a hunter tamed a
  particular beast to learn Bite 3. With this commit, and `CheckLearning`, the hunter learns the top rank of every family
  ability for free.
- Ranks come from SkillLineAbility `SupercedesSpell` chains, and some Forever chains are broken: simulated on the client
  data, a level 60 Boar gets two Charge spells (26201 and 27685 are separate chains) and a level 60 Bat gets all five
  Sonic Blast ranks (1264478-1264482, no chain).
- It hands out the Forever-only abilities too (Swipe 1264502 for bears, Dismember, Pinch, Thunderstomp, Mine!, Sonic
  Blast, Lava Breath 444681), whatever way Forever really teaches them.
- `LearnClassicStartSpells` also runs on every load, so existing pets change on the next login.
- `PetAI` calls `CheckLearning` whether or not `prepare` succeeded.
How Forever hands out pet abilities is a design decision; this needs a source first.

**Our change on top.** The rule moves into `Trainer::IsPetTrainingSpell` / `Trainer::IsCastToTeach` (Trainer.h), which take
the SpellInfo and a pet ability check, so a test can call them without SpellMgr. Same rule as the pull request.
`Trainer::TeachAvailableSpellsFree` (the bot trainer kit; Beast Training 261 is a class skill line, so pet trainers count
as hunter trainers there) still cast every LEARN_SPELL spell; it now uses the same rule.

**Test.** `tests/game/TrainerPetTraining.cpp` (`[TrainerPetTraining]`): 4195-, 1853- and 2949-shaped spells are learned,
a LEARN_SPELL of a non-pet spell is cast, a pet ability as a TRIGGER_SPELL trigger does not count. Against the old rule
(`IsCastable` alone decides), the 4195 and 1853 cases are cast and fail. PTR: buy Great Stamina at a pet trainer; it must
stay in the spellbook, show as known at the trainer, and train a second pet from the Beast Training window.

**Verdict:** commit 1 taken (merged as 71a13f6fda alone), with our change on top. Commit 2 held: whole-family top ranks
instead of the tamed creature's own, broken rank chains in the Forever data, and Forever-only abilities handed out. Needs a
decision on how Forever pets get their abilities.
