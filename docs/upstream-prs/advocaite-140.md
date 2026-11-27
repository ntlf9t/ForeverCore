# advocaite/TrinityCore#140: DB/Conditions: gossip option conditions on Zephras menus use the option index

krakenunbound, 2026-10-27, commit dc74e09f71. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** 16 gossip option conditions (source type 15) on seven Zephras menus use the option's `GossipOptionID` as
`SourceEntry`, but `ConditionMgr::addToGossipMenuItems` matches the option index, so they are dropped at startup and the
options show for everyone. Also: Ayessa's and Elaadrin's Desperate Times (92640) recruit options should wait for "Speak
with Valennia Stormfist".

**Check.**
- Code: `addToGossipMenuItems` compares `gossipMenuItem.OrderIndex` (`gossip_menu_option.OptionID`) with `SourceEntry`.
  The claim is right for the code.
- Already fixed on `everlake`: 2026_10_27_07_world_jorel_windsinger_gossip.sql re-keys the same seven menus. On the
  release brought to `everlake`, no source type 15 condition matches a `GossipOptionID` any more, so the pull request's
  UPDATE changes 0 rows here. It is a join on `gossip_menu_option`, not limited to these menus, but it only changes rows
  whose `SourceEntry` equals an option's `GossipOptionID` in the same menu; there are none.
- The second part is new and right. Quest 92640's objectives on `everlake` and live (EG Link 70862): 465840 Speak with
  Valennia (order 0), 465809 and 465810 the recruits (flags 34 = sequenced). `CONDITION_QUEST_OBJECTIVE_PROGRESS` (48)
  compares the objective's stored value with `ConditionValue3`, so (465840, value 1) means "Valennia spoken to". The two
  menus already have "quest in progress" (47) and "not recruited yet" (48 = 0) conditions in the same else group, so all
  three must hold.

**Test.** SQL. Load test (as in advocaite-123.md): UPDATE 0 rows, 2 conditions inserted, no error; same result in
fresh-world order. PTR check: on 92640, Ayessa's and Elaadrin's recruit options are hidden until Valennia has been spoken
to, then shown until that recruit is done.

**Verdict:** take (the re-key is already on `everlake`; the Valennia conditions are new).
