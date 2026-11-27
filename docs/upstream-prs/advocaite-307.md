# advocaite/TrinityCore#307: Shaman totems: each totem casts its own rank's spell; names lose the old prefix

Karrz1, 2026-11-07, commit d9d47f9c51. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Strength of Earth, Stoneskin, Windfury, Mana Spring and most other totems did nothing: a totem casts its
`creature_template_spell` row and there were rows only for Earthbind, Tremor, Grounding, Searing, Magma and Healing
Stream. Searing, Magma and Healing Stream cast rank 1 at every rank; Grounding cast its magnet directly (once). Old-rank
totem names carried `zzOLD` (frFR `[VIEUX]`).

**Check.**
- Before (TDB 2026-10-14 + our world SQL since): the 64 totem entries had 17 rows: Searing 3606, Magma 8188 and Healing
  Stream 5672 at every rank, Grounding 8178 twice (index 0 and 1). True as claimed.
- All 64 new rows checked against the 70862 client data: for each totem the summon spell (`SPELL_EFFECT_SUMMON` with
  that creature) and the cast spell have the same name and rank, and the right effect (area aura for the buff totems,
  periodic trigger for Stoneclaw, Magma, Poison / Disease Cleansing and Grounding Totem Passive 8179, which triggers the
  magnet 8178 every 10 s). Every spell exists in the client. No row disagrees.
- The old ranks are reachable: their summon spells are trainer spells (`trainer_spell` has e.g. 8154, 10408, 10438).
- Names: before, 103 totem templates and 733 totem locale rows had the prefix; after the three name files, 0 and 0.
- Data only. Nothing in TrinityCore `master` to compare (retail totems).

**Test.** All four files applied to a scratch MySQL 8.0 world (TDB 2026-10-14 + our world SQL since), no errors; check
queries: `creature_template_spell` has exactly 64 rows for the 64 entries; `creature_template` / `creature_template_locale`
have no `zzOLD%` / `[VIEUX]%` totem name left. PTR: Strength of Earth Totem II gives its rank 2 Strength; Searing Totem
VI hits with 10436, not 3606; Grounding Totem takes a spell and takes another 10 s later.

**Verdict:** take.
