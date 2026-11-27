# advocaite/TrinityCore#289: Trainers: a class trainer shows its train option to its own class only

Karrz1, 2026-11-04, commit 798e7e41b8. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Every class saw the train option at every class trainer and got an empty or refused list; in Classic another
class sees only the trainer's text.

**Check.** True: the Trainer gossip option had no class check, and `everlake`'s own "Train me." option (added when a
trainer NPC has no gossip option for it) was added for everyone. The fix hides both when `Trainer::GetClassMask()` and the
player's class mask share nothing, taking the trainer from the gossip option first and the creature second, as picking
the option does (`GetCreatureTrainerForGossipOption`). `GetClassMask` is the union of the classes owning a class skill line
of any of its spells, or every class when none is a class line, so profession, weapon and riding trainers are unchanged.
Pet trainers sell Beast Training (skill line 261, a class line, hunter only), so they now show training to hunters only,
as in Classic. Bots do not use the gossip (they call `TeachAvailableSpellsFree`). TrinityCore `master` has no such check.

**Test.** None in `tests/`: the gossip menu needs a creature and a player. PTR: a warrior talks to a mage trainer: no
train option, only the text. The mage sees the option. Both see the option at a cooking trainer; only a hunter sees it at
a pet trainer.

**Verdict:** take.
