# TrinityCore 7abb5096bc: corpse update fields behind getters and setters

Shauren, 2026-10-07. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of 70862.

**Claim.** Code outside `Corpse` stops touching `m_corpseData` directly; `CorpseFlags` gets flag helpers. Two changes in
behaviour come with it: (1) a new corpse gets the player's party and guild GUIDs (`PartyGUID`, `GuildGUID`); bones
already copied them from the corpse, but they were never set. (2) `SPELL_EFFECT_SKIN_PLAYER_CORPSE` checks the corpse's
`CORPSE_FLAG_SKINNABLE` instead of `HasDynamicFlag(CORPSE_DYNFLAG_LOOTABLE)`.

**Check.**
- (1) Forever's `CorpseData::WriteCreate` already writes `PartyGUID` and `GuildGUID` (between `Owner` and `DisplayID`),
  so the layout sent to the 70862 client is unchanged; they now carry values instead of empty GUIDs.
- (2) The old check read the object's dynamic flags (`m_objectData->DynamicFlags`) with a corpse dynamic flag value, and
  `CORPSE_DYNFLAG_LOOTABLE` is only set on the bones after the insignia is taken; `CreateCorpse` sets
  `CORPSE_FLAG_SKINNABLE` on corpses in battlegrounds "to be able to remove insignia". In 70862 the only spell with
  effect 116 is Remove Insignia (22027), so this is the insignia loot in battlegrounds:
  live on Everlake.
- No Forever code used `m_corpseData` outside `Corpse` or the removed `Corpse::ReplaceAllFlags` (grep of `src/`; the
  `ReplaceAllFlags` calls in the Uldaman scripts are on game objects).

**Test.** None in `tests/` (needs a map and a player). PTR check: in a battleground, kill an enemy player and use Remove
Insignia on the corpse: the insignia loot window opens.

**Verdict:** take.
