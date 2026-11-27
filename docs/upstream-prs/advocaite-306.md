# advocaite/TrinityCore#306: Commands: the .ahbot add message fills in its number

Karrz1, 2026-11-07, commit 3d77fc7266. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The `.ahbot raise` answer showed "{}" instead of the number, because `PSendSysMessage` takes printf style.

**Check.** True: `ChatHandler::PSendSysMessage(char const*, ...)` formats with `fmt::make_printf_args`, so `{}` is printed as
is. The command is `.ahbot add [n]` (`HandleAHBotAddCommand`), not "raise". `%u` fits the `uint32`. **Same bug
elsewhere:** 19 `PSendSysMessage` calls in `src/modules/PlayerbotV2/Commands/cs_playerbot_v2.cpp` use `{}` (for example
"Player '{}' not online.", the meta stats lines); not in this pull request, worth a follow-up.

**Test.** None in `tests/`: one format string. In-game: `.ahbot add 100`. Expected: "every active quality target raised by 100".

**Verdict:** take.
