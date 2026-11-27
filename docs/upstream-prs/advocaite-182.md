# advocaite/TrinityCore#182: PvP: honorable kills pay honor in the open world and in battlegrounds

dqhoang (Duy Hoang), 2026-10-27, commit ba745a3cbe. Reviewed 2026-11-08 against `everlake` dab8f8aa45, together with #296
and #321.

**Claim.** No honor came from killing players, anywhere.

**Check.** True, in both places, and TrinityCore `master` has the same gaps.
- Open world: `Unit::Kill` only fills its reward list (`tappers`) from a creature's tap list, so a player victim had no
  one to reward: no honor, no HK, no PvPCredit. The pull request adds the killer (already the owner for a pet or totem)
  when the victim is a player outside a battleground or arena. `KillRewarder` then rewards the killer's group in range,
  honor split by their number, no XP or reputation for a player victim. Same-faction victims and grey levels are refused in
  `Player::RewardHonor`.
- Battleground: `Battleground::RewardXPAtKill` ran `KillRewarder` only with `Battleground.GiveXPForKills` on (default
  off), and `KillRewarder::_RewardPlayer` skipped honor in a battleground anyway. The pull request always runs it, pays
  honor there, and gives the kill XP only with the setting on.
- Not paid twice: battleground victims are left out of the `Unit::Kill` path and arena kills pay no honor
  (`RewardHonor` returns early in an arena). The other `RewardHonor` callers (battleground objective honor, duel honor
  setting, quest honor, `.honor add`) are unrelated to a kill.
- Not covered by the pull request: `KillRewarder::Reward` and `_RewardGroup` still skip everyone in a battleground when
  the kill XP is 0 ("battleground rewards only XP"). That XP is 0 with `Rate.XP.BattlegroundKill = 0`, so that setting would
  have turned battleground kill honor off.

**Our change on top.** In a battleground a player victim always goes on to `_RewardPlayer` (`!_isBattleGround || _isPvP
|| _xp`); creature kills in a battleground keep the XP-only rule.

**Test.** None in `tests/`: `KillRewarder` needs players, groups and a map. PTR (two accounts, opposite factions, level
60, not grey to each other): (1) kill in the open world: PvPCredit floating honor, HK count +1, honor currency up (#296);
(2) the same in a group of two: honor split; (3) in Warsong Gulch: honor per kill once, not twice, and no XP with
`Battleground.GiveXPForKills = 0`; (4) an arena kill: no honor.

**Verdict:** take, with our change on top.
