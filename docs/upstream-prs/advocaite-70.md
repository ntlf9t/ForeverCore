# advocaite/TrinityCore#70: Fix mail not sending because the recipient isn't being found

PixelCattt, 2026-10-17, commit d0078cd083. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Mail to "Name Surname" fails because the whole text is looked up as a name.

**Check.**
- The bug is real (see #275).
- The fix calls `CharacterCache::GetCharacterCacheByFullName`, which only #68 adds, so it does not build without #68
  (held).
- #275 fixes the same lookup without #68 and also drops the "-Realm" suffix the 70790 client adds. The two conflict in
  `MailHandler.cpp`. #275's author says so too: take #68 + #70 or #275, not both.

**Test.** None.

**Verdict:** drop, replaced by #275.
