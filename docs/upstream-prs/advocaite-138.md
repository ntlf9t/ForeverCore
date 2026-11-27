# advocaite/TrinityCore#138: Character creation: the random name dice fills both the name and the surname

krakenunbound, 2026-10-27, commit d3e204e9f7. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The dice on the 1.60 character create screen fills only the first name. The client's `NameChoiceMixin`
(Blizzard_CharacterCreate.lua, 70450) generates a name and a surname from its own NameGen data when the server answers
`Success = false`; with a server name the surname box stays empty.

**Check.**
- True of our code: `HandleRandomizeCharNameOpcode` sends `Success = true` and one name from
  `DB2Manager::GetNameGenEntry`, which picks from all NameGen rows of the race and sex. In Classic NameGen also holds
  surnames (NameType 1), so about a third of the "first names" the server sends are surnames.
- The change answers `Success = false`, so the client fills both boxes itself from the right lists. The author tested it
  on 70450 (e.g. "Berle Youngfield"); not seen on 70862.
- **Overlaps Everlake patch 0009** (random surname): 0009 keeps `Success = true`, picks the first name and the surname from
  their own NameType lists and writes the surname after the name with a 9 bit length taken from EmuForever; its commit
  says that layout is not proven in game. #138's author tried sending a surname "with a few bit layouts" and the client
  ignored it. The two change the same lines: when Everlake moves to the fork, drop 0009's handler and packet hunks
  (its NameGen-by-NameType index is then unused: nothing else calls `GetNameGenEntry`).
- TrinityCore `master` sends a server name (retail has no surname).

**Test.** In-game, PTR realm (70862 client): on character create press the dice ten times for two races and both sexes.
Expected: both boxes filled each time, the first name never a surname, and the name passes the availability check.

**Verdict:** take.
