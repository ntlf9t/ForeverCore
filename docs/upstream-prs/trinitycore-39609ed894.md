# TrinityCore 39609ed894: summoned creatures and objects get their phase before their terrain status

Shauren, 2026-10-22. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** A creature or game object that is not a database spawn got its phase only after `Create`, but `Create`
already reads the terrain (liquid, floor, area) for its position, which depends on the phase (terrain swaps). The
initial phase is now an argument of `Creature::Create`, `GameObject::Create` / `CreateGameObject` and the summon
paths, set first.

**Check.**
- The new `InitialPhaseShift` is none, a database spawn (same `InitDbPhaseShift` / `InitDbVisibleMapId` calls as
  before), or an object to inherit from (same `InheritPhaseShift` as before, earlier). Each changed call passes the
  object it inherited from afterwards before, so the phase ends up the same, only set earlier.
- Everlake: matters wherever a phase or terrain swap changes the ground under a summon. Not checked which Forever
  zones use terrain swaps, and the old behaviour was not reproduced.
- **Forever's own calls, fixed on top** (code TrinityCore doesn't have; would not build): the Warsong Gulch dropped flag
  and two Ruins of Ahn'Qiraj objects took no phase before and get `InitialPhaseShift()` (none); the Tauren herb
  cultivation twin inherited the caster's phase right after `CreateGameObject` and now gets it at creation. No other
  caller in `src/server/scripts/Custom` or `src/modules` (grep for `CreateGameObject(`, `CreateCreature(`,
  `->Create(` with a map).

**Test.** None in `tests/`: it needs a map with terrain. PTR check: summon a pet or totem and drop a Warsong Gulch flag
in a battleground; they appear where they should. Cultivate a herb as a Tauren: the twin is visible only to that
player, as before.

**Verdict:** take, with our call-site commit.
