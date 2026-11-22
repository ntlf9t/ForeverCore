/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "tc_catch2.h"

#include "../../src/modules/PlayerbotV2/Bot/BotConversation.h"

#include <set>

using namespace Playerbot::V2;

namespace {

ConversationContext Ctx()
{
    ConversationContext c;
    c.self_name = "Aron";
    c.sender_name = "Karrz";
    c.class_name = "mage";
    c.zone = "Elwynn Forest";
    c.activity = "out questing";
    c.level = 23;
    c.bot_seed = 12345;
    return c;
}

std::string Lower(std::string s)
{
    for (char& ch : s)
        ch = char(std::tolower(static_cast<unsigned char>(ch)));
    return s;
}

ConvIntent Cls(char const* line, std::string* slot = nullptr)
{
    return ConvClassify(ConvNormalize(line), slot);
}

std::string Say(ConversationContext const& c, char const* line, uint32_t sel = 0, bool addressed = true)
{
    std::string out;
    REQUIRE(ConvReply(c, ConvNormalize(line), line, sel, addressed, out));
    return out;
}

} // namespace

TEST_CASE("BotConversation: lines are classified to the right intent", "[botconversation]")
{
    CHECK(Cls("how are you?") == ConvIntent::HowAreYou);
    CHECK(Cls("how's it going") == ConvIntent::HowAreYou);
    CHECK(Cls("how u doing") == ConvIntent::HowAreYou);
    CHECK(Cls("where are you from?") == ConvIntent::WhereFrom);
    CHECK(Cls("where are you") == ConvIntent::WhereAreYou);
    CHECK(Cls("what level are you") == ConvIntent::Level);
    CHECK(Cls("what class are you?") == ConvIntent::ClassSpec);
    CHECK(Cls("what are you doing") == ConvIntent::WhatDoing);
    CHECK(Cls("wyd") == ConvIntent::WhatDoing);
    CHECK(Cls("want to group?") == ConvIntent::GroupInvite);
    CHECK(Cls("lfg deadmines?") == ConvIntent::GroupInvite);
    CHECK(Cls("can you help me with a quest") == ConvIntent::QuestHelp);
    CHECK(Cls("what profession do you have") == ConvIntent::Trade);
    CHECK(Cls("are you in a guild") == ConvIntent::Guild);
    CHECK(Cls("what's your name") == ConvIntent::Name);
    CHECK(Cls("tell me a joke") == ConvIntent::Joke);
    CHECK(Cls("you suck") == ConvIntent::Insult);
    CHECK(Cls("you are awesome") == ConvIntent::Compliment);
    CHECK(Cls("ok bye, gtg") == ConvIntent::Goodbye);
    CHECK(Cls("blorp") == ConvIntent::Unknown);
    CHECK(Cls("") == ConvIntent::Unknown);
}

TEST_CASE("BotConversation: ordinary words are not mistaken for intents", "[botconversation]")
{
    // "how do you do that" is not a wellbeing question, "the quest is called" is not a name question, "levelling" is not "level".
    CHECK(Cls("how do you pull that off") == ConvIntent::Unknown);
    CHECK(Cls("whats the quest called") != ConvIntent::Name);
    CHECK(Cls("wanna trade") == ConvIntent::WantTrade);   // a question now (GitHub #12), answered with "what are you after?"
    CHECK(Cls("trade chat is quiet today") == ConvIntent::Unknown);
    CHECK(Cls("pull now") == ConvIntent::Unknown);
}

TEST_CASE("BotConversation: directions find the destination", "[botconversation]")
{
    std::string slot;
    CHECK(Cls("how do i get to ironforge?", &slot) == ConvIntent::Directions);
    CHECK(slot == "ironforge");
    CHECK(Cls("where is thunder bluff", &slot) == ConvIntent::Directions);
    CHECK(slot == "thunder bluff");
    CHECK(Cls("where's stormwind", &slot) == ConvIntent::Directions);
    CHECK(slot == "stormwind");
    // A place we do not know is not a direction we can give.
    CHECK(Cls("how do i get to the moon", &slot) == ConvIntent::Unknown);

    // Casual bots type in lower case, so compare without case.
    CHECK(Lower(Say(Ctx(), "how do i get to ironforge", 0)).find("dun morogh") != std::string::npos);
    CHECK(Lower(Say(Ctx(), "how do i get to darnassus", 1)).find("auberdine") != std::string::npos);
}

TEST_CASE("BotConversation: directions to the zone the bot stands in say so", "[botconversation]")
{
    ConversationContext c = Ctx();
    c.zone = "Elwynn Forest";
    std::string const r = Say(c, "where is elwynn forest", 0);
    CHECK(Lower(r).find("dun morogh") == std::string::npos);
    std::string const l = Lower(r);
    CHECK((l.find("here") != std::string::npos || l.find("zone") != std::string::npos || l.find("where") != std::string::npos));
}

TEST_CASE("BotConversation: replies carry the bot's real state", "[botconversation]")
{
    ConversationContext c = Ctx();
    c.length = ConvLength::Normal;
    // Over many selectors every phrasing for level names the level, every one for the zone names the zone.
    for (uint32_t sel = 0; sel < 40; ++sel)
    {
        CHECK(Say(c, "what level are you", sel).find("23") != std::string::npos);
    }
    std::string zone_reply;
    for (uint32_t sel = 0; sel < 40; ++sel)
    {
        zone_reply = Say(c, "where are you", sel);
        bool const has = zone_reply.find("lwynn") != std::string::npos;   // survives lower-casing and capitalisation
        CHECK(has);
    }
}

TEST_CASE("BotConversation: group answer follows whether the bot is grouped", "[botconversation]")
{
    ConversationContext c = Ctx();
    c.in_group = false;
    std::set<std::string> free_set, busy_set;
    for (uint32_t sel = 0; sel < 40; ++sel)
        free_set.insert(Say(c, "want to group?", sel));
    c.in_group = true;
    for (uint32_t sel = 0; sel < 40; ++sel)
        busy_set.insert(Say(c, "want to group?", sel));
    for (auto const& f : free_set)
        for (auto const& b : busy_set)
            CHECK(f != b);
    CHECK(free_set.size() > 1);   // several phrasings, not one canned line
}

TEST_CASE("BotConversation: group answer says what the bot will do with the invite", "[botconversation]")
{
    ConversationContext c = Ctx();
    auto answers = [&](GroupAnswer g, bool ru)
    {
        c.group = g;
        c.russian = ru;
        std::set<std::string> out;
        for (uint32_t sel = 0; sel < 64; ++sel)
            out.insert(Lower(Say(c, ru ? "\xD1\x85\xD0\xBE\xD1\x87\xD0\xB5\xD1\x88\xD1\x8C \xD0\xB2 \xD0\xB3\xD1\x80\xD1\x83\xD0\xBF\xD0\xBF\xD1\x83?"   // хочешь в группу?
                                       : "want to group?", sel)));
        return out;
    };
    for (bool ru : { false, true })
    {
        INFO("russian " << ru);
        std::set<std::string> const yes = answers(GroupAnswer::Yes, ru);
        std::set<std::string> const high = answers(GroupAnswer::TooHigh, ru);
        std::set<std::string> const later = answers(GroupAnswer::NotNow, ru);
        CHECK(yes.size() > 1);
        for (std::string const& s : high)
            CHECK(yes.count(s) == 0);
        for (std::string const& s : later)
            CHECK(yes.count(s) == 0);
        if (!ru)
        {
            for (std::string const& s : high)
                CHECK((s.find("level") != std::string::npos || s.find("lvl") != std::string::npos || s.find("low") != std::string::npos
                       || s.find("ahead") != std::string::npos || s.find("higher") != std::string::npos));
            for (std::string const& s : later)
                CHECK(s.find("invite") == std::string::npos);
        }
        // Grouped: the "in a group" answer, whatever the rest says.
        c.in_group = true;
        std::set<std::string> const busy = answers(GroupAnswer::Yes, ru);
        c.in_group = false;
        for (std::string const& s : busy)
            CHECK(yes.count(s) == 0);
    }
}

TEST_CASE("BotConversation: quest, profession and guild answers use the data when there is some", "[botconversation]")
{
    ConversationContext c = Ctx();
    c.tone = ConvTone::Polite;
    c.quest_title = "The Fargodeep Mine";
    c.professions = { "mining", "blacksmithing" };
    c.guild_name = "Night Owls";
    bool quest_named = false, prof_named = false, guild_named = false;
    for (uint32_t sel = 0; sel < 40; ++sel)
    {
        quest_named |= Say(c, "can you help with a quest", sel).find("argodeep") != std::string::npos;
        prof_named |= Say(c, "what professions do you have", sel).find("mining") != std::string::npos;
        guild_named |= Say(c, "are you in a guild", sel).find("ight") != std::string::npos;
    }
    CHECK(quest_named);
    CHECK(prof_named);
    CHECK(guild_named);

    // Without data the reply must not contain a hole or an unreplaced placeholder.
    ConversationContext n = Ctx();
    for (uint32_t sel = 0; sel < 40; ++sel)
        for (char const* line : { "can you help with a quest", "what professions do you have", "are you in a guild", "how are you",
                                  "where are you from", "what are you doing", "whats your name", "tell me a joke", "you suck",
                                  "bye", "you are awesome", "what class are you", "how do i get to org" })
        {
            std::string const r = Say(n, line, sel);
            CHECK(r.find('{') == std::string::npos);
            CHECK(r.find("  ") == std::string::npos);
            CHECK(r.size() > 0);
        }
}

TEST_CASE("BotConversation: tone and length shape the reply", "[botconversation]")
{
    ConversationContext rude = Ctx(), polite = Ctx();
    rude.tone = ConvTone::Rude;
    polite.tone = ConvTone::Polite;
    std::set<std::string> a, b;
    for (uint32_t sel = 0; sel < 60; ++sel)
    {
        a.insert(Say(rude, "how are you", sel));
        b.insert(Say(polite, "how are you", sel));
    }
    for (auto const& x : a)
        CHECK(b.count(x) == 0);

    ConversationContext terse = Ctx(), chatty = Ctx();
    terse.length = ConvLength::Terse;
    chatty.length = ConvLength::Chatty;
    std::set<std::string> t, ch;
    for (uint32_t sel = 0; sel < 200; ++sel)
    {
        t.insert(Say(terse, "how are you", sel));
        ch.insert(Say(chatty, "how are you", sel));
    }
    CHECK(t.size() < ch.size());
}

TEST_CASE("BotConversation: two bots asked alike do not always answer alike, one bot is stable", "[botconversation]")
{
    ConversationContext a = Ctx(), b = Ctx();
    a.bot_seed = 1;
    b.bot_seed = 2;
    int differ = 0;
    for (uint32_t sel = 0; sel < 50; ++sel)
        if (Say(a, "how are you", sel) != Say(b, "how are you", sel))
            ++differ;
    CHECK(differ > 10);
    CHECK(Say(a, "what level are you", 7) == Say(a, "what level are you", 7));
}

TEST_CASE("BotConversation: writing style is a stable per-bot trait", "[botconversation]")
{
    // Casual bots never capitalise or use apostrophes; the others always capitalise the first letter.
    int casual = 0, proper = 0;
    for (uint32_t seed = 0; seed < 200; ++seed)
    {
        ConversationContext c = Ctx();
        c.bot_seed = seed;
        std::string const first = Say(c, "how are you", 0);
        bool const upper = std::isupper(static_cast<unsigned char>(first[0])) != 0;
        for (uint32_t sel = 1; sel < 6; ++sel)
            CHECK((std::isupper(static_cast<unsigned char>(Say(c, "how are you", sel)[0])) != 0) == upper);
        (upper ? proper : casual)++;
    }
    CHECK(casual > 0);
    CHECK(proper > 0);
    CHECK(casual > proper);
}

TEST_CASE("BotConversation: only unknown lines reach a provider, and only when addressed", "[botconversation]")
{
    struct Echo : ReplyProvider
    {
        int calls = 0;
        bool TryReply(ConversationContext const&, std::string const& m, std::string& out) override
        {
            ++calls;
            out = "model says: " + m;
            return true;
        }
    };
    auto p = std::make_shared<Echo>();
    ConvSetProvider(p);

    std::string out;
    CHECK(ConvReply(Ctx(), ConvNormalize("what do you think of the weather"), "what do you think of the weather", 0, true, out));
    CHECK(out == "model says: what do you think of the weather");
    CHECK(p->calls == 1);

    // Not addressed: the provider stays out of party chatter.
    CHECK_FALSE(ConvReply(Ctx(), ConvNormalize("what do you think of the weather"), "what do you think of the weather", 0, false, out));
    // A known intent never reaches the provider.
    CHECK(ConvReply(Ctx(), ConvNormalize("how are you"), "how are you", 0, true, out));
    CHECK(out.find("model says") == std::string::npos);
    CHECK(p->calls == 1);

    // No provider: an unknown question is asked back (no more "dunno"), an unknown statement falls through to the caller.
    ConvSetProvider(nullptr);
    CHECK(ConvReply(Ctx(), ConvNormalize("what do you think of the weather"), "what do you think of the weather", 0, true, out));
    CHECK(out.find("model says") == std::string::npos);
    CHECK_FALSE(ConvReply(Ctx(), ConvNormalize("the weather is nice"), "the weather is nice", 0, true, out));
}

TEST_CASE("BotConversation: a repeated line gets a different answer, never silence", "[botconversation]")
{
    ConversationContext c = Ctx();
    for (uint32_t repeat = 1; repeat < 6; ++repeat)
        for (uint32_t sel = 0; sel < 20; ++sel)
            CHECK_FALSE(ConvRepeatReply(c, sel, repeat).empty());
    std::set<std::string> seen;
    for (uint32_t sel = 0; sel < 60; ++sel)
        seen.insert(ConvRepeatReply(c, sel, 1));
    CHECK(seen.size() > 1);
    // a third repeat uses the stronger pool
    std::set<std::string> second, later;
    for (uint32_t sel = 0; sel < 60; ++sel)
    {
        second.insert(Lower(ConvRepeatReply(c, sel, 1)));
        later.insert(Lower(ConvRepeatReply(c, sel, 3)));
    }
    for (auto const& x : second)
        CHECK(later.count(x) == 0);
}

TEST_CASE("BotConversation: intent names for the log are stable", "[botconversation]")
{
    CHECK(std::string(ConvIntentName(ConvIntent::HowAreYou)) == "how_are_you");
    CHECK(std::string(ConvIntentName(ConvIntent::Unknown)) == "unknown");
    CHECK(std::string(ConvIntentName(Cls("how do i get to org") )) == "directions");
}

TEST_CASE("BotConversation: a hello is answered here only for someone the bot knows", "[botconversation]")
{
    CHECK(Cls("hi") == ConvIntent::Greeting);
    CHECK(Cls("hey Aron") == ConvIntent::Greeting);
    CHECK(Cls("hi how are you") == ConvIntent::HowAreYou);   // a real question wins over the opener
    CHECK(Cls("hello there my friend how goes it") == ConvIntent::Unknown);   // too long to be just a hello

    ConversationContext stranger = Ctx();
    std::string out;
    CHECK_FALSE(ConvReply(stranger, ConvNormalize("hi"), "hi", 0, true, out));   // falls through to the ike3 hello pool

    ConversationContext owner = Ctx();
    owner.knows_sender = true;
    std::set<std::string> seen;
    for (uint32_t sel = 0; sel < 40; ++sel)
    {
        std::string const r = Say(owner, "hi", sel);
        CHECK(Lower(r).find("know you") == std::string::npos);
        seen.insert(r);
    }
    CHECK(seen.size() > 1);
}

TEST_CASE("BotConversation: duel, trade, thanks, bot, like and help questions", "[botconversation]")
{
    // GitHub #12 (2026-11-17): "duel?", "do you wanna trade", "do you like wow forever" got "i dont know" / "how should i know".
    CHECK(Cls("duel?") == ConvIntent::Duel);
    CHECK(Cls("wanna duel") == ConvIntent::Duel);
    CHECK(Cls("do you wanna trade") == ConvIntent::WantTrade);
    CHECK(Cls("trade?") == ConvIntent::WantTrade);
    CHECK(Cls("thanks!") == ConvIntent::Thanks);
    CHECK(Cls("ty") == ConvIntent::Thanks);
    CHECK(Cls("are you a bot?") == ConvIntent::AreYouBot);
    CHECK(Cls("r u a real person") == ConvIntent::AreYouBot);
    CHECK(Cls("do you like wow forever") == ConvIntent::LikeIt);
    CHECK(Cls("can you help me") == ConvIntent::Help);
    CHECK(Cls("help me with this quest") == ConvIntent::QuestHelp);
    // An offer to do a quest together is an offer to group up (cyborgx5, GitHub #12: "hi do you wanna do [quest] quest?").
    CHECK(Cls("hi do you wanna do |cffffff00|Hquest:54:5|h[The Fargodeep Mine]|h|r quest?") == ConvIntent::GroupInvite);
    CHECK(Cls("want to do this quest together?") == ConvIntent::GroupInvite);
    CHECK(Cls("wanna help me with this quest?") == ConvIntent::QuestHelp);
    CHECK(Cls("where is the quest giver") != ConvIntent::GroupInvite);
    CHECK(Cls("\xD0\xB3\xD0\xBE \xD0\xB2\xD0\xBC\xD0\xB5\xD1\x81\xD1\x82\xD0\xB5 \xD0\xBA\xD0\xB2\xD0\xB5\xD1\x81\xD1\x82?") == ConvIntent::GroupInvite);   // го вместе квест?
    CHECK(Cls("\xD0\xBF\xD0\xBE\xD0\xBC\xD0\xBE\xD0\xB3\xD0\xB8 \xD1\x81 \xD0\xBA\xD0\xB2\xD0\xB5\xD1\x81\xD1\x82\xD0\xBE\xD0\xBC") == ConvIntent::QuestHelp);   // помоги с квестом
    CHECK(Cls("do you wanna group") == ConvIntent::GroupInvite);
    CHECK(Cls("you are a stupid bot") == ConvIntent::Insult);

    ConversationContext c = Ctx();
    for (uint32_t sel = 0; sel < 40; ++sel)
    {
        std::string const bot = Lower(Say(c, "are you a bot?", sel));
        CHECK(bot.find("yes") == std::string::npos);
        CHECK(bot.find("i am a bot") == std::string::npos);
        CHECK(bot.find("im a bot") == std::string::npos);
    }
}

TEST_CASE("BotConversation: the duel answer is what the bot will do", "[botconversation]")
{
    ConversationContext c = Ctx();
    c.tone = ConvTone::Neutral;
    std::set<std::string> yes, far;
    for (uint32_t sel = 0; sel < 64; ++sel)
    {
        c.duel = DuelAnswer::Yes;
        yes.insert(Lower(Say(c, "duel?", sel)));
        c.duel = DuelAnswer::TooFar;
        far.insert(Lower(Say(c, "duel?", sel)));
    }
    for (std::string const& s : yes)
        CHECK((s.find("sure") != std::string::npos || s.find("send") != std::string::npos || s.find("on") != std::string::npos));
    for (std::string const& s : far)
        CHECK((s.find("level") != std::string::npos || s.find("fair") != std::string::npos));
}

TEST_CASE("BotConversation: a Russian player gets Russian answers", "[botconversation]")
{
    // \xD0..\xD1 bytes: the answer is Cyrillic
    auto cyrillic = [](std::string const& s) { return s.find('\xD0') != std::string::npos || s.find('\xD1') != std::string::npos; };
    ConversationContext c = Ctx();
    c.russian = true;
    c.duel = DuelAnswer::Yes;
    char const* lines[] = {
        "\xD0\xBA\xD0\xB0\xD0\xBA \xD0\xB4\xD0\xB5\xD0\xBB\xD0\xB0?",                                   // как дела?
        "\xD1\x87\xD1\x82\xD0\xBE \xD0\xB4\xD0\xB5\xD0\xBB\xD0\xB0\xD0\xB5\xD1\x88\xD1\x8C?",           // что делаешь?
        "\xD0\xBA\xD0\xB0\xD0\xBA\xD0\xBE\xD0\xB9 \xD1\x83 \xD1\x82\xD0\xB5\xD0\xB1\xD1\x8F \xD1\x83\xD1\x80\xD0\xBE\xD0\xB2\xD0\xB5\xD0\xBD\xD1\x8C?",   // какой у тебя уровень?
        "\xD1\x85\xD0\xBE\xD1\x87\xD0\xB5\xD1\x88\xD1\x8C \xD0\xB2 \xD0\xB3\xD1\x80\xD1\x83\xD0\xBF\xD0\xBF\xD1\x83?",                                     // хочешь в группу?
        "\xD0\xB4\xD1\x83\xD1\x8D\xD0\xBB\xD1\x8C?",                                                      // дуэль?
        "\xD1\x81\xD0\xBF\xD0\xB0\xD1\x81\xD0\xB8\xD0\xB1\xD0\xBE",                                      // спасибо
        "\xD1\x82\xD1\x8B \xD0\xB1\xD0\xBE\xD1\x82?",                                                     // ты бот?
        "\xD0\x93\xD0\xB4\xD0\xB5 \xD0\x9C\xD0\xB5\xD1\x80\xD1\x82\xD0\xB2\xD1\x8B\xD0\xB5 \xD0\xBA\xD0\xBE\xD0\xBF\xD0\xB8?",                           // Где Мертвые копи?
        "\xD1\x82\xD0\xB5\xD0\xB1\xD0\xB5 \xD0\xBD\xD1\x80\xD0\xB0\xD0\xB2\xD0\xB8\xD1\x82\xD1\x81\xD1\x8F wow forever?",                                  // тебе нравится wow forever?
    };
    ConvIntent const want[] = { ConvIntent::HowAreYou, ConvIntent::WhatDoing, ConvIntent::Level, ConvIntent::GroupInvite, ConvIntent::Duel,
                                ConvIntent::Thanks, ConvIntent::AreYouBot, ConvIntent::Directions, ConvIntent::LikeIt };
    for (size_t i = 0; i < std::size(lines); ++i)
    {
        INFO(lines[i]);
        CHECK(Cls(lines[i]) == want[i]);
        for (uint32_t sel = 0; sel < 8; ++sel)
        {
            std::string const s = Say(c, lines[i], sel);
            CHECK(cyrillic(s));
            CHECK(s.find('{') == std::string::npos);
        }
    }
    // the class and the activity come in Russian, not "mage" / "out questing"
    for (uint32_t sel = 0; sel < 16; ++sel)
    {
        CHECK(Say(c, "\xD0\xBA\xD0\xB0\xD0\xBA\xD0\xBE\xD0\xB9 \xD1\x83 \xD1\x82\xD0\xB5\xD0\xB1\xD1\x8F \xD1\x83\xD1\x80\xD0\xBE\xD0\xB2\xD0\xB5\xD0\xBD\xD1\x8C?", sel).find("mage") == std::string::npos);
        CHECK(Say(c, "\xD1\x87\xD1\x82\xD0\xBE \xD0\xB4\xD0\xB5\xD0\xBB\xD0\xB0\xD0\xB5\xD1\x88\xD1\x8C?", sel).find("questing") == std::string::npos);
    }
}

TEST_CASE("BotConversation: an unknown question asks back instead of \"dunno\"", "[botconversation]")
{
    ConversationContext c = Ctx();
    std::string out;
    CHECK(ConvReply(c, ConvNormalize("what about the blue thing?"), "what about the blue thing?", 3, true, out));
    CHECK_FALSE(out.empty());
    CHECK(Lower(out).find("dunno") == std::string::npos);
    // a statement is left to the caller's own lines, and an unaddressed line too
    CHECK_FALSE(ConvReply(c, ConvNormalize("the blue thing is nice"), "the blue thing is nice", 3, true, out));
    CHECK_FALSE(ConvReply(c, ConvNormalize("what about the blue thing?"), "what about the blue thing?", 3, false, out));
}
