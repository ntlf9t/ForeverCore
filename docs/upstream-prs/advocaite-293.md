# advocaite/TrinityCore#293: Loot: a corpse holding only free-for-all items can be looted

Karrz1, 2026-11-06, commit 3072b1ea6f. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** `Loot::hasItemFor` counted a player's free-for-all items only once they were looted, so a corpse with no gold
and only multi-drop items (Ukor's Lost Pack on Ukorsbane, Halikor's Hoof) was never lootable.

**Check.** True, and the same inverted test is in TrinityCore `master`: `any_of(ffaItems, &NotNormalLootItem::is_looted)`
returns true when one is already looted, false while they are all still there. Callers: `Player::isAllowedToLoot`
(three paths) and the chest check in `GameObject`. Any loot where the free-for-all items were the only thing for the
player was refused or showed no sparkle. The fix checks `!is_looted`, matching the quest-item loop above it.

**Test.** None in `tests/`: `hasItemFor` takes a `Player` and the free-for-all list is filled by `FillNotNormalLootFor`, which
needs one. In-game test for the PTR realm: kill Ukorsbane with the quest that drops Ukor's Lost Pack. Expected: the
corpse sparkles and opens with the pack in it.

**Verdict:** take.
