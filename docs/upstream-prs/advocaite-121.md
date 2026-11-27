# advocaite/TrinityCore#121: Classic 1.60.1.70532: preliminary support

hordekle, 2026-10-24, commit b55e79095a. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A `build_info` row for client 70532 and realms 70-73 moved from 70450 to 70532.

**Check.**
- Obsolete. Our auth updates already end at 70862 (`2026_11_07_00_auth_classic_70862.sql`), and Everlake runs 70862.
- Applied after our `sql/custom/auth` chain on a scratch MySQL 8.0: the 70532 row is already there (DELETE + INSERT gives
  the same row) and the realm update matches no realm (none is on 70450). Harmless, no clash, and nothing to gain.
- A 70532 client can't join a 70862 realm anyway (70790 moved message numbers).

**Test.** SQL applied to a scratch auth database: no error, no change.

**Verdict:** drop, obsolete.
