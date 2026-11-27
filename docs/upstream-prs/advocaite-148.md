# advocaite/TrinityCore#148: Spells/Skyborne: Read Ley Line at a ley line completes Reading the Ley Lines

krakenunbound, 2026-10-27, commit fc3f710b56. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The objective of "Reading the Ley Lines" (92597) never completes: its criteria needs the caster to have aura
1271952 "Leyline Convergence" when casting Read Ley Line 1259705, and nothing applies that aura. The racial script now
casts it next to a ley line and counts the cast again.

**Check.**
- True in the 70862 client data: criteria tree 218373 "Read Leyline" -> 218374 -> criteria 109629 (type 29, cast spell
  1259705, modifier tree 426346); 426346 -> 426347 = type 8 (has aura) 1271952. No spell effect in the client triggers
  1271952, and the world database has no SmartAI, `spell_area` or creature addon that applies it.
- Order is right: `Spell::_cast` updates the cast-spell criteria (Spell.cpp:3903) before the launch phase (3935), where
  the script's `OnEffectLaunchTarget` runs. The first update fails without the aura; the script's own update with the aura
  counts. The criteria amount is 1, so a second count (aura still up from an earlier cast) changes nothing.
- Only near a ley line focus (2246 within 50 yd); Skysight (2271) is unchanged.
- The comment above the class still says Energized 1259691 completes the quest; that is wrong (it's the aura), left as
  upstream wrote it.
- Custom Classic script, nothing in TrinityCore `master` to compare.

**Test.** No unit test (criteria and a spell focus in a live world). PTR: a Skyborne character on quest 92597 casts Read
Ley Line at the Thendal Grove ley line: the objective completes and the quest can be turned in; away from it, nothing
changes.

**Verdict:** take.
