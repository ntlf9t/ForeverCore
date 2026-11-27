# TrinityCore 270f1397ac: mirror timer (breath, fatigue, feign death) rewrite

Warlockbugs with Shauren, 2026-09-28. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools
export of the 1.60.1.70862 client (SpellEffect, SpellName).

**Claim.** `Player::HandleDrowning` and its `int32` array give way to a `MirrorTimer` class per bar (value, max, scale,
spell id, paused). The bars follow liquid and auras as they change: `SPELL_AURA_MOD_WATER_BREATHING` (155) changes the
breath bar's length while it runs, `SPELL_AURA_FORCE_BREATH_BAR` (164) and `SPELL_AURA_WATER_BREATHING` (82) switch it
between running out and refilling, a feign death bar (timer 2) shows the feign death aura's time. Damage still comes
once a second once a bar is empty.

**Check.**
- Packets: `SMSG_START_MIRROR_TIMER` and `SMSG_STOP_MIRROR_TIMER` keep their writers; the struct fields of
  `StartMirrorTimer` are only reordered, `Write()` sends the same bytes in the same order. `SMSG_PAUSE_MIRROR_TIMER` gets
  a sender, but nothing ever pauses a timer (only `SetScale(0)` would, and the scale is always -1 or 10), so it is
  never sent. Message numbers: retail 0x1BB / 0x1BD fall in the 0x17E..0x1C0 range that `ClassicOpcodes` moves one down
  (the comment there names the mirror timers among the signature-aligned messages); unchanged by this commit.
- Values: breath 3 minutes (times the aura 155 multiplier, now at least 1 ms), fatigue 1 minute, damage 20% of max
  health per second for drowning and fatigue, 10% for lava: all the same as `everlake` before. Refill at 10x speed, as
  before. Not checked: what live Forever uses for the breath bar. Classic Era's bar is commonly given as 1 minute;
  Everlake has had 3 minutes all along, this commit does not change it.
- Auras in 70862: 155 on 12 spells (Undead Underwater Breathing 5227 +300%, Water Breathing 11789 +50%, and boss or zone
  debuffs down to Embrine -200%; the new code never makes the bar shorter than 1 ms); 82 on 17 (Unending Breath,
  Aquatic Form, Water Breathing potions); 164 on 4 (Devour, Drowning Shallows, Embrine, a test spell); 66 (feign death)
  on 5: Feign Death 5384, Left for Dead 8359, Fake Death 8226, Play Dead 19822, Diseased 1223009.
- New on Everlake: a feign death bar (timer type 2, with the spell id) while a feign death aura is on. Whether the
  Forever client draws it is not known; it already reads the message for types 0 and 1.
- `LFGMgr::TeleportPlayer` uses the renamed `MIRROR_TIMER_FATIGUE`. No Forever code used the old names (only comments
  in `PlayerbotAPI.cpp`).

**Test.** `tests/game/MirrorTimer.cpp` ([MirrorTimer], our commit): the breath bar drains, ticks damage once a second
after it is empty, refills at scale 10 and stops when full; it does not start under water breathing; a longer max keeps
the air already used; fatigue ends after a minute. It pins the new class; there is no "fails without", the class is
new. PTR checks: dive until drowning (bar, then a damage tick a second), surface (bar refills and goes); swim into the
open sea past the edge (fatigue bar, damage); drink a Water Breathing potion while the breath bar runs (bar refills);
Undead: breath bar four times as long; hunter Feign Death: a bar or nothing, no Lua error.

**Verdict:** take.
