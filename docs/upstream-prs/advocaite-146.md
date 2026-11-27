# advocaite/TrinityCore#146: DB/Creature: Windsong Standing Stones apprentices and wind sprites stop killing each other

krakenunbound, 2026-10-27, commit 1c73431c2e. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** At the Windsong Standing Stones, High Order Apprentices (257521, faction 3673) and Wind Sprites (252481, faction
634) fight and kill each other with no player around, and the sprites cast Fly Away! (1253200) on every reset, so they
vanish. Sets `UNIT_FLAG_IMMUNE_TO_NPC` on both and removes the sprites' reset cast (their only SmartAI row).

**Check.**
- On `everlake`: as described. 257521 SmartAI: Frostbolt (9672) on the victim in combat, "[DNT] Can't Be Healed"
  (1309170) on reset. 252481: one row, Fly Away! on reset. Spell 1253200 in the 70862 client: aura 18 (invisibility) and
  aura 7 (fear) on self, as claimed. 12 apprentices and 7 sprites are spawned.
- The sprites have `HealthModifier` 100.35 (live Forever's creature answer, EG Link, has the same 100.35): practice
  targets. The apprentices are the kill objective of quest 94411 ("High Order Apprentice defeated"), so dead apprentices
  with no player around do cost players. 0x200 is `UNIT_FLAG_IMMUNE_TO_NPC`; OR-ed in, other flags kept.
- What can't be checked: whether live has the apprentices practising on the sprites (a scene) and the sprites fly away on
  purpose. The SmartAI rows come from the sniff AI file (2026_10_02_00), whose event guesses aren't certain. The change
  loses the scene, if there is one, and keeps the quest working.

**Test.** SQL. Load test (as in advocaite-123.md): 2 templates changed, 1 SmartAI row deleted, AIName cleared, no error;
same result in fresh-world order. PTR check: at the stones (around 3518, 1657 on Zephras Isle) apprentices and sprites stand
side by side without fighting and stay alive; the apprentices still fight players.

**Verdict:** take.
