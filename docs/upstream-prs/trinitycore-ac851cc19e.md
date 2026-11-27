# TrinityCore ac851cc19e: allowed retail build 12.1.5.70783

Shauren, 2026-11-04. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** Retail client build 70783 can log in: `build_info` and `build_auth_key` rows (update file in
`sql/updates/auth/master`), and the same rows plus the realm's build in `sql/base/auth_database.sql`.

**Check.** Retail 12.1.5 builds, not Forever (Forever's are 1.60.1.x: 70009 ... 70862 in `sql/custom/auth`; no build
number is shared). On `everlake` the rows would be harmless but useless: the Forever realm accepts only its own build
and `Realm.AlsoAcceptBuilds`, and a retail client could not play on the Forever server anyway (other message numbers and
data layouts). The `sql/base` part conflicts with ours (it also moves the realm's build).

**Test.** None.

**Verdict:** hold for the retail realm's branch (TrinityCore `master`); not for `everlake`.
