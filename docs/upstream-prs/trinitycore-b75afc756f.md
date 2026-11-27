# TrinityCore b75afc756f: conversation ScriptName values restored after 5a58175f49

Naddley, 2026-11-07 (no pull request number). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools export of 1.60.1.70862 (Map). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables batch I's SQL touches) with every batch I world file applied in TrinityCore order and the tables dumped before and after.

**Claim.** Re-inserts the 250 `conversation_template` rows of TrinityCore's world database with their correct
ScriptName, undoing 5a58175f49's UPDATE without WHERE.

**Check.** Forever's release has 248 `conversation_template` rows. All 248 are in b75afc756f's list with the same
FirstLineId, TextureKitId, Flags, ScriptName and VerifiedBuild (compared row by row: 0 differ); the other two are 25326
and 25327 from dc5955decd and 5a58175f49. No Everlake custom world file adds a conversation_template row, so nothing
of Forever's is left with the wrong ScriptName or is overwritten with other values. As committed it names the
database (`world`.`conversation_template`), which would fail on a world database with another name; bb3d6fd535 removes
that.

Taken together with dc5955decd, 5a58175f49, b75afc756f and bb3d6fd535 (the Earthen start-area chain): 5a58175f49 without b75afc756f breaks every conversation ScriptName.

**Test.** Scratch database: after 5a58175f49 + b75afc756f + bb3d6fd535 the table equals the release plus 25326 and
25327.

**Verdict:** take (with bb3d6fd535).
