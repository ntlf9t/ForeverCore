# TrinityCore 1b205ac647: polygon area triggers spawned at orientation 0 build their vertices

F03SD, 2026-11-09, TrinityCore#32126. Reviewed 2026-11-10 against `everlake` 134d3d8b17. Data: Forever's
`forever-tdb-2026-10-14` release (`areatrigger_create_properties`) and the wago.tools export of the 1.60.1.70862 client
(SpellEffect).

**Claim.** `AreaTrigger::UpdatePolygonVertices` skipped the work when the rotation had not changed since the last
update. On the first call `_verticesUpdatePreviousRotation` still holds its initial value, which equals the rotation of
a trigger spawned at orientation 0, so such a polygon trigger never got its vertices and no unit was ever inside it.

**Check.** True for TrinityCore. **Already fixed in `everlake` another way:** Karrz1's 36fe3975d0 (advocaite/TrinityCore#286, 2026-11-04, "polygon
triggers facing north never got their corners, so nobody could enter them (Secure the Mountain)") initialises
`_verticesUpdatePreviousRotation` to (0, 0, 0, 0), which is not a rotation, so the first call always builds the
vertices. TrinityCore's fix (also require `!_polygonVertices.empty()` before skipping) covers the same case; with both,
behaviour is unchanged. Taken so the function matches TrinityCore and later changes to it apply. Forever data: 14 of
the 407 rows in Forever's world release are polygons (shape 3): two custom rows (one for Temple of Kotmogu), the retail
Guardian's Breath triggers (9352-9360) and three other retail rows; none is made by a spell in the 70862 client. The
Secure the Mountain quest trigger (Forever custom SQL) is why Karrz fixed it.

**Test.** None in `tests/`: needs an area trigger on a map. Built in the batch K local UBSan build.

**Verdict:** take (same fix already in `everlake` as 36fe3975d0; no change in behaviour).
