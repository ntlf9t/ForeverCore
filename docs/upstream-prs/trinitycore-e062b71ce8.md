# TrinityCore e062b71ce8: demon hunter spell scripts in alphabetical order

Aqua Deus, 2026-11-01, TrinityCore PR #32085. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** `spell_dh.cpp`: the `DemonHunterSpells` enum, the script classes and the `AddSC_` registrations put in
alphabetical order; the section comments (`// Havoc`, `/* Spells */` ...) and the blank lines between groups go. No
code change.

**Check.**
- Conflict: on `everlake` the file differs from TrinityCore's in two ways. (1) Our Soulmonger null-check in
  `spell_dh_soulmonger::CheckProc` (from fork PR #32, "no double effects with the Classic instance ports, and null
  checks in proc scripts"). (2) Three TrinityCore commits before this one are not on `everlake` yet: 6ebe044cbb
  (Swallowed Anger), 377af97d87 (Demon Muzzle update) and 761b1a2f5f (Burn It Out / Soul Cleanse). They are in batch
  G, another PR. This pick does **not** need them to make sense, but TrinityCore's reordered file contains them.
- Resolved against current `everlake`: TrinityCore's file after this commit, with those three commits' changes reversed
  (`patch -R` of each commit's own diff onto the reordered file: their scripts, enum values and registrations out, the
  old Demon Muzzle script back in), then our Soulmonger check put back. Result checked: as a multiset of lines it is
  exactly `everlake`'s file at the branch point minus the blank and comment lines TrinityCore dropped, so nothing was
  lost or added; `grep` confirms the Soulmonger check.
- After batch H the whole file differs from TrinityCore `master` (a766fe19ac) only by the three batch-G commits and
  our Soulmonger check (`diff`).
- Whichever of batch G / batch H merges second has to rebase: batch G's three commits will then go into the
  alphabetical file by hand.

**Test.** Pure reorder. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take (conflict resolved without batch G; our Soulmonger null check kept).
