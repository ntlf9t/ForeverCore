# advocaite/TrinityCore#184: Pets: dying outside PvP costs one happiness level

dqhoang (Duy Hoang), 2026-10-27, commit 2668544b33. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** In Classic a hunter pet that dies loses a level of happiness, except in battlegrounds and arenas (VMaNGOS
`Pet::SetDeathState`). Nothing did that.

**Check.** True: `everlake` has Forever happiness (`Pet::Update` loses 670 every 7.5 s, loyalty ticks by happiness state)
but no loss on death. The penalty sits where `Pet::setDeathState` sees CORPSE. `Creature::setDeathState(JUST_DIED)` sets
CORPSE itself (`Unit::setDeathState(CORPSE)`), so it runs once per death. `HAPPINESS_MAX / 3` = 333333, one third of
the bar (VMaNGOS `HAPPINESS_LEVEL_SIZE` 333000; `everlake` defines both). `IsInWorld()` keeps it off the load path:
`LoadPetFromDB` revives a pet saved dead with `setDeathState(JUST_DIED)` before `AddToMap`. `HasHappiness()` is hunter
pets only, and bot hunters' pets are reset to full happiness each update anyway. Duels can't kill. A pet killed in a
dungeon loses happiness, as in VMaNGOS.

**Test.** None in `tests/`: it needs a pet that dies on a map. PTR: let a happy hunter pet die in the open world: the
happiness icon drops one step (happy to content). Let it die in Warsong Gulch: no change. Log out with a dead pet and back
in: no change.

**Verdict:** take.
