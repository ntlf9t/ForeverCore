#pragma once

#include "Define.h"

#include <string>
#include <string_view>

class WorldSession;

namespace Playerbot::V2::AccountBot {

struct LinkResult
{
    bool ok = false;
    uint32 guid_low = 0;
    std::string character_name;
    std::string message;
};

LinkResult LinkAndLogin(WorldSession* owner_session, std::string_view account_name,
                        std::string_view password, std::string_view character_name);

} // namespace Playerbot::V2::AccountBot
