# advocaite/TrinityCore#145: DB/Creature: remove the duplicate Cirrusfly Queen spawn

krakenunbound, 2026-10-27, commit acbb46e3b1. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Two Cirrusfly Queens (251404, Thendal Grove, for The Cirrusfly Queen 92463) stand 11 yd apart: 21100464 with her
patrol path and 21100465 static with nothing referring to it. Deletes 21100465.

**Check.**
- On `everlake`: both spawns are from the 70124 sniff, 11 yd apart; 21100464 has `creature_addon` path 211004640
  (`MovementType` 2), 21100465 has random movement and no addon. Nothing else uses 21100465: no pool member, spawn group,
  formation or guid SmartAI.
- The DELETE is limited to guid 21100465 and `id` 251404; the addon delete matches nothing. Removes exactly what it says.
- Public data can't say how many queens live Forever has at once (EG Link has one kill recorded). A named quest target
  standing twice side by side is wrong either way, and the one kept is the one with the sniffed path.

**Test.** SQL. Load test (as in advocaite-123.md): 1 creature row deleted, no error; same result in fresh-world order. PTR
check: one Cirrusfly Queen at Thendal Grove, walking her path.

**Verdict:** take.
