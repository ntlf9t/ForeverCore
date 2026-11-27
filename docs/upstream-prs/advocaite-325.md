# advocaite/TrinityCore#325: Classic: weapon imbues, Grave Touch, Reckoning, Missile Barrage and 22 talent procs that fired on every hit

MShkolenko (MAXIMUS), 2026-11-08, commits 3e4f8b7ba4 + d57ef26029. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Found with 250 bots on a live realm: (1) dummy proc auras with no trigger spell did nothing: Flametongue
Weapon 436519, Windfury Weapon 439431, the Undead racial 1260189 / 1260201, Reckoning 20177, Nightfall 18094; (2) 22
talents whose chance is an effect amount (trait rank) while `ProcChance` is 100 fired on every event (Arcane
Concentration 200 of 200); (3) Missile Barrage's two effects both fired on every harmful spell.

**Check** (spell data: wago.tools export of the 1.60.1.70862 client).
- Flametongue and Windfury: true. Each rank's enchantment applies the one aura (Windfury: 283, 284, 525, 1669, 7569,
  8293 -> 439431, `ProcChance` 20, 1.5 s recovery). Rank tables match the client, and so does the damage formula (see
  #127). One gap: the rank's points were read without a caster, which drops their per-level growth (8026: 19 per level,
  10 to 16; 16344: 78 per level, 56 to 64). The tooltip's `$8026m1` includes it; fixed on top. Windfury's rank spells
  give `$8233s2` = 2 extra attacks (70862 data); the script doesn't hard-code it, and the "attacks it granted don't grant
  more" check is the same one the core makes for proc trigger spells.
- The Undead racial (named "Touch of the Grave" in 70862): 20% / 30% chance, 15 s recovery, effect amount 5 = "up to 5%
  of your maximum Health"; the script leeches that through 1260198 (`HEALTH_LEECH`). Matches.
- Reckoning: matches the tooltip ($m1% after a block, $m1 x 2.5% after a non-periodic critical hit, at most once per
  1.5 s from blocks, up to 4 stored attacks on 1326084). The `spell_proc` row only changes the cooldown: the other zero
  columns give the same entry the core generates for these taken-hit proc flags.
- Missile Barrage: the five SpellClassOptions masks are exact matches in 70862. The one #325 calls "Arcane Surge" is
  Arcane Wrath (1326079-1326082), as the tooltip says; comment fixed. Effect 0 is 40: 40% / 20%.
- The 22 talents and Nightfall: the chance effect per talent is right for all 25 (each tooltip's `$m1` / `$m2` / `$s2`).
  **But the client data has no spell filter on any of them**: their proc effects have no SpellClassMask and the world
  database has no `spell_proc` row, so the core lets every event of the proc flags through. #325 makes them roll the
  right chance on every event: Improved Kick (100% at full rank) still silences on every Sinister Strike, Improved
  Shield Bash on every ability, Shield Specialization on every hit taken (not blocks), Searing Light on Holy Fire's direct
  hit, and Nightfall, which did nothing before, gives Shadow Trance from Shadow Bolt, Immolate and every DoT.
- The SQL deletes by spell id; none of these spells had a script binding or `spell_proc` row in the world database (TDB
  2026-10-14 + our SQL since), so nothing else goes. Every id exists in the client.
- Text conflict with #122 (both add a script at the same place): kept both.

**Our change on top.**
1. d43f0b65e7: the decisions move into `src/server/game/Spells/ClassicProcRules.h` (rank tables, Flametongue damage,
   chance effect, Missile Barrage and Reckoning chances), same behaviour.
2. c9421cf285: each talent names what its tooltip names, by the 70862 masks: one spell (Kick, Shield Bash, Hamstring,
   Concussive Shot, Wing Clip, Starfire, Conflagrate, Backstab; Ambush / Garrote / Cheap Shot; Frostbolt), a hit result
   (block: both Shield Specializations; critical: Martyrdom, Illumination with Flash of Light / Holy Light / Holy Shock /
   Light's Vigil), a school (Shadow Weaving, Blackout, Impact, Elemental Focus), Holy Fire's periodic damage (Searing
   Light), finishing moves by combo point cost (Ruthlessness), mage Chill effects (Frostbite, as the existing Fingers of
   Frost script), mage damage spells (Arcane Concentration); Nightfall: Corruption, Drain Life, Drain Soul, Wrack.
   Unbridled Wrath and Spirit Tap need no filter (melee swings, kills). Flametongue computes the points with the shaman
   as caster.

   Known approximations: Winter's Chill counts Frostbolt only (an Ice Lance empowered by Fingers of Frost can't be told
   apart at hit time); the Starfire bit is shared with three Starfall spells, Kick's with the rogue Rebuke rune, Wrack's
   with Haunt; Elemental Focus counts on the hit, not the cast.

**Test.** `tests/game/ClassicProcRules.cpp` (`[ClassicProcRules]`, 10 cases): rank tables, Flametongue damage at 1.3 s /
4.0 s (4 / 13, the tooltip) and with level-16 points, chance effects, each talent filter with its spell and a spell it
must ignore (Kick vs Sinister Strike, Corruption vs Shadow Bolt, block vs plain hit...), Missile Barrage per spell,
Reckoning's block cooldown and crit chance. The file needs only the header, so it was compiled and run on 2026-11-08 with
a stand-in for Catch2 (no core build): 88 checks pass; against the header of d43f0b65e7 (#325's rules) 24 fail, every one
a filter check that must refuse an event, and the other 64 pass. CI runs it under Catch2. The per-level Flametongue points
are in the script (needs a caster), so PTR: a level 16 shaman with Flametongue rank 1 on a 2.6 s weapon hits for 11 Fire
damage plus spell power (8 at level 10). Also PTR: Windfury procs about 1 in 5 hits with 2 extra swings; a rogue with
Improved Kick silences only with Kick; a warlock with Nightfall gets Shadow Trance from Corruption ticks, never from
Shadow Bolt; Reckoning stores up to 4 attacks.

**Verdict:** take, with our change on top. Replaces #127.
