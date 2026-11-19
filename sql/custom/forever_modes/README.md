# Forever modes SQL

These are manual, one-time setup scripts; the database updater does not apply
the complete package automatically. It does apply the current `character_modes`
schema repair from `sql/custom/characters` before the world starts. Back up the
affected databases before importing.

Run them in this order with `world` selected as the default database. They
write to `world`, `hotfixes`, `auth`, and `characters`; `item_score_ench_name.sql`
creates its table in the selected database.

1. `affix_pool.sql`
2. `affix_t4_pool.sql`
3. `affix_score_display.sql`
4. `item_score_ench_name.sql`
5. `creature_random_buff_data.sql`
6. `creature_buff_spells.sql`
7. `player_modes.sql`
8. `player_mode_auras.sql`
9. `rebirth_talent.sql`

`affix_pool.sql` drops and recreates `world.item_score_enchant`;
`item_score_ench_name.sql` drops and recreates `world.item_score_ench_name`.
Review those effects and back up existing data before importing. The dungeon
difficulty command permission is registered but not granted to the player
role; grant it separately if ordinary players should be allowed to use `.dungeon`.
