# advocaite/TrinityCore#264: Dungeon: Ragefire Chasm new bosses loot

dqhoang, 2026-10-29, commit 4abb63a2db. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Oggleflint (11517) and Bazzalan (11519) have no boss gear (the VMaNGOS rows have none), unlike Jergosh and
Taragaman. Adds their three Forever items each in one group (GroupId 1, chance 0), so one drops per kill.

**Check.**
- On `everlake`: neither boss has a gear row or reference, only VMaNGOS trash and world-drop references. The DELETE matches
  nothing; 6 rows inserted. Nothing else changes.
- Wowhead's drop tables can't be read from here (they are in the page's script data; direct requests get 403), so the
  drops were checked against EG Link's public loot recordings from live Forever (builds 70790 and 70862):
  - Oggleflint, 3 encounter rolls: Bone Knuckles 272998 x2, Trogg Scepter 272996 x1, plus Pattern: Defender's Leather Armor
    252773 (a recipe, not boss gear); kills recorded 5: 272998 x2, 272996 x2.
  - Bazzalan, 3 rolls: Searing Dagger 273003, Satyrskin Cloak 273005, Chasm Walkers 273007, one each.
  - Barbaric Crossbow 272999 isn't in a recording yet; it is a valid item on live (EG Link item hotfixes) and on Wowhead
    Forever.
  One item per kill fits the recordings. All six are items our server knows (client ItemSparse or our hotfixes).

**Test.** SQL. Load test (as in advocaite-123.md): 0 deleted, 6 inserted, no error; same result in fresh-world order. PTR
check: kill both bosses a few times; each drops one of its three items.

**Verdict:** take.
