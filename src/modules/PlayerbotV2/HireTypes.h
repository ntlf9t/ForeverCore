// HireTypes - the words the bot module and the hired bots share (grades and the realm's hire mode). No game types here, so the
// policy tests and any other hire module can use them. The hired bots themselves live in Hire/ (see Hire/README.md).

#pragma once

#include <cstdint>

namespace Playerbot::V2::Fleet::Hire {

enum class Grade : uint8_t { None = 0, Sellsword = 1, Veteran = 2, Legend = 3 };
constexpr uint8_t kGradeCount = 4;

// Playerbot.Hire.Mode: 0 off (bots are free, as before), 1 hired bots for everyone, 2 each player chooses (`.bot hire on|off`).
enum class Mode : uint8_t { Off = 0, Everyone = 1, PlayerChoice = 2 };

}  // namespace Playerbot::V2::Fleet::Hire
