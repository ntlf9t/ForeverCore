#include "AccountBotLink.h"

#include "AccountMgr.h"
#include "Bot/BotTypes.h"
#include "CharacterCache.h"
#include "Commands/TypedName.h"
#include "Fleet/BotAccountMgr.h"
#include "Fleet/BotIdentityRegistry.h"
#include "Fleet/BotPopulationManager.h"
#include "Fleet/OwnerRegistry.h"
#include "ObjectAccessor.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "Services.h"
#include "Session/BotSessionMgr.h"
#include "Util/ConfigReader.h"
#include "WorldSession.h"

#include <algorithm>
#include <chrono>
#include <string>
#include <unordered_map>

namespace Playerbot::V2::AccountBot {
namespace {

constexpr size_t kMaxFailedAttempts = 5;
constexpr auto kFailureWindow = std::chrono::minutes(1);

struct FailureState
{
    std::chrono::steady_clock::time_point window_start{};
    size_t count = 0;
};

std::unordered_map<uint32, FailureState> g_failures;

std::string Trim(std::string_view text)
{
    size_t begin = 0;
    size_t end = text.size();
    while (begin < end && (text[begin] == ' ' || text[begin] == '\t'))
        ++begin;
    while (end > begin && (text[end - 1] == ' ' || text[end - 1] == '\t'))
        --end;
    return std::string(text.substr(begin, end - begin));
}

LinkResult Failure(std::string message)
{
    return { false, 0, {}, std::move(message) };
}

bool RateLimited(uint32 owner_account, bool failed)
{
    auto const now = std::chrono::steady_clock::now();
    FailureState& state = g_failures[owner_account];
    if (!state.window_start.time_since_epoch().count() ||
        now - state.window_start >= kFailureWindow)
    {
        state = { now, 0 };
    }

    if (!failed)
        return state.count >= kMaxFailedAttempts;

    ++state.count;
    return state.count >= kMaxFailedAttempts;
}

size_t ActiveLinkedBots(uint32 owner_account)
{
    size_t count = 0;
    for (BotId bot : Services::Owners().BotsOwnedBy(owner_account))
    {
        ObjectGuid const guid = ObjectGuid::Create<HighGuid::Player>(bot);
        uint32 const character_account =
            sCharacterCache->GetCharacterAccountIdByGuid(guid);
        if (character_account && !Services::Accounts().is_pool_account(character_account) &&
            Services::SessionMgr().IsHeadless(guid))
            ++count;
    }
    return count;
}

} // namespace

LinkResult LinkAndLogin(WorldSession* owner_session, std::string_view account_name,
                        std::string_view password, std::string_view character_name)
{
    if (!Services::Initialized())
        return Failure("PlayerbotV2 not initialized.");
    if (!owner_session || !owner_session->GetPlayer())
        return Failure("This command must be used by an in-game player.");

    std::string const account = Trim(account_name);
    std::string const pass(password);
    std::string name = TypedName::Pick(Trim(character_name), [](std::string first)
    {
        if (!normalizePlayerName(first))
            return std::string{};
        ObjectGuid const guid = sCharacterCache->GetCharacterGuidByName(first);
        return guid.IsEmpty() ? std::string{} :
            sCharacterCache->GetCharacterSurnameByGuid(guid);
    });
    if (!normalizePlayerName(name))
        return Failure("That character name is invalid.");
    if (account.empty() || pass.empty() || name.empty())
        return Failure("Usage: .playerbot account <account> <password> <character>.");
    if (account.size() > MAX_ACCOUNT_NAME_BYTES || pass.size() > MAX_PASS_STR)
        return Failure("Account or password is too long.");

    uint32 const owner_account = owner_session->GetAccountId();
    if (RateLimited(owner_account, false))
        return Failure("Too many failed password attempts. Try again in one minute.");

    uint32 const source_account = AccountMgr::GetId(account);
    if (!source_account || !AccountMgr::CheckPassword(source_account, pass))
    {
        if (RateLimited(owner_account, true))
            return Failure("Too many failed password attempts. Try again in one minute.");
        return Failure("Account name or password is invalid.");
    }

    if (Services::Accounts().is_pool_account(source_account))
        return Failure("Bot-pool accounts cannot be linked as player accounts.");

    CharacterCacheEntry const* character = sCharacterCache->GetCharacterCacheByName(name);
    if (!character || character->IsDeleted || character->AccountId != source_account)
        return Failure("That character does not belong to the supplied account.");
    if (character->Guid == owner_session->GetPlayer()->GetGUID())
        return Failure("That is your current character.");
    if (ObjectAccessor::FindConnectedPlayer(character->Guid))
        return Failure("That character is currently online.");

    BotId const bot(character->Guid.GetCounter());
    OwnerBinding const existing = Services::Owners().GetOwner(bot);
    if (existing.account_id && existing.account_id != owner_account)
        return Failure("That character is already linked to another player.");

    uint8 const cap = Services::Config().max_alts_as_bots();
    if (!cap)
        return Failure("Account-linked bots are disabled on this realm.");
    if (ActiveLinkedBots(owner_account) >= cap)
        return Failure("Your active linked-bot limit has been reached.");

    bool const newly_marked = !Services::Lifecycle().is_bot(bot);
    if (newly_marked)
        Services::Lifecycle().mark_as_bot(bot);
    Services::Owners().SetOwner(bot, owner_account, 0u);
    Services::Population().QueueCompanionSetup(
        bot, owner_session->GetPlayer()->GetGUID().GetCounter(),
        uint8(Playerbot::Role::Unknown));

    auto login = Services::SessionMgr().LoginBot(character->Guid);
    if (!login.ok)
    {
        if (newly_marked)
            Services::Lifecycle().unmark_as_bot(bot);
        if (!existing.account_id)
            Services::Owners().ClearOwner(bot);
        return Failure(std::string("Could not log in the linked character: ") + login.reason);
    }

    g_failures.erase(owner_account);
    return {
        true,
        uint32(character->Guid.GetCounter()),
        character->Name,
        "Linked character " + character->Name +
            " and started it as a bot. Only your account can control it."
    };
}

} // namespace Playerbot::V2::AccountBot
