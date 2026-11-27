# TrinityCore 200d8d1336: rectangle and line targets: half the width, no farther than the destination

Shauren, 2026-10-25. Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** Rect and line target selection used the spell's full width as the half-width (twice too wide), targets
128-130 (`TARGET_UNIT_RECT_CASTER*`) were selected as cones, and lines to a destination hit units beyond it.
`TARGET_SELECT_CATEGORY_LINE` becomes `TARGET_SELECT_CATEGORY_RECT`, 133-135 are renamed `..._RECT_CASTER_TO_DEST_...`.

**Check.** Only one spell in 70862 uses any of targets 128-130 or 133-135: Gnomeregan Smash (431720, target 129), a
boss ability. No Forever code uses the renamed names (`src/server/scripts/Custom`, `src/modules`). The area check now
used for lines (`WorldObjectSpellAreaTargetCheck`) is the one cones and areas already use.

**Test.** None: one boss spell in Forever data.

**Verdict:** take.
