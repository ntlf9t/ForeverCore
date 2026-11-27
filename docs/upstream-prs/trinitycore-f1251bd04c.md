# TrinityCore f1251bd04c: area trigger fixes: zero curve time, box height, movement with no duration

Shauren, 2026-10-02. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** (1) An override curve with `TimeToTarget` 0 is at its end (progress 1), not its start; (2) box area triggers
use their full Z extent as half-height like X and Y, not half of it; (3) spline or orbit movement with a duration of 0
no longer divides by zero (crash).

**Check.** Forever data used below: the world release `forever-tdb-2026-10-14` (`areatrigger_create_properties`: 407 rows) and the wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect). Forever's player spells that make area triggers and have a row are Flare, Volley, Blizzard, Flamestrike and Rain of Fire (20 rows): all spheres (shape 0), no rotation, no movement, no scale curve.
- (1) Only two-point override curves set by scripts depend on progress; the radius-mod scale and the extra scale (1.0)
  that every area trigger gets are constant curves. No Forever spell trigger and no Forever script uses two-point
  curves (`SetOverrideScaleCurve` / `SetOverrideMoveCurve` with points: none in `src/server/scripts/Custom`).
- (2) Forever's spell triggers are spheres; 123 of the 407 rows are boxes, none of them made by a Forever player spell.
  Not checked against the client which height is right; taken as TrinityCore has it.
- (3) Real crash, reached only by triggers that move; none of Forever's spell triggers move.

**Test.** None: nothing a unit test can reach without a map; no Forever spell trigger changes.

**Verdict:** take.
