# advocaite/TrinityCore#139: DB/Quest: The Anchors of Zephras - Halaan's Gift shows the anchor pylon and completes the objective

krakenunbound, 2026-10-27, commit fb52acfcbc. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The Anchors of Zephras (94414), objective 468541 "View the Anchor Pylon": Halaan Hawk-Eye's (257554) gossip
option makes the player cast Halaan's Gift (1272014), but nothing shows, because the far sight has no destination. With one
added, the objective (criteria tree 221135, gain aura 1272014) still doesn't complete. Adds a `spell_target_position`, turns
the objective into a hidden kill credit for Halaan given by the gossip option, and adds a whisper.

**Check.**
- Spell data (70862 client): 1272014 effect 0 is `SPELL_EFFECT_ADD_FARSIGHT` (72) on `TARGET_DEST_DB` (17), effect 1 a
  dummy aura on the caster. With no `spell_target_position` row the far sight has no destination: true. The client's
  effect facing is 5.70; the pull request uses 5.94 picked in game. The position is not sniffed.
- `everlake` has 2026_10_02_04_world_halaan_gift.sql: the gossip condition and SmartAI rows 0-1 (option 0 -> invoker casts
  1272014, close gossip). This pull request adds rows 2-3 on the same event (`SMART_EVENT_GOSSIP_SELECT`, menu 41842, option
  0; `NPCHandler` passes `OrderIndex`, so option 0 is right). 2026_10_02_04 deletes all of 257554's rows, but it sorts
  first in both a fresh and an existing world, so the result is the same.
- Why the criteria tree doesn't complete could not be checked (no live log). The workaround moves away from live Forever:
  live's quest answer (EG Link 70862) still has 468541 as type 14 on tree 221135. The world import's corrections file must
  not turn it back into a criteria tree without fixing the cause.
- Text 257554 group 0 is new (no row on `everlake`), type 42 = raid boss whisper.

**Test.** SQL. Load test (as in advocaite-123.md): no error; 1 target position, 1 objective changed, 2 SmartAI rows and 1
text inserted; same result in fresh-world order. Author tested in game (70450). PTR check: on 94414 choose "Halaan, please
lend me your gift": the view moves over the pylon, the whisper shows, the objective completes, no "slain" message.

**Verdict:** take. Note for the world import: 468541 is deliberately not live's criteria-tree objective.
