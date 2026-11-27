// Everlake bot surnames. Race IDs follow RaceMask.h; unknown races use traveller names.
#pragma once
#include <algorithm>
#include <cstdint>
#include <random>
#include <sstream>
#include <string>
#include <vector>

namespace Playerbot::V2::Fleet::BotSurnames
{
inline std::vector<std::string> Candidates(std::uint8_t race)
{
    char const* first;
    char const* last;
    switch (race)
    {
        case 1: case 22: case 32:
            first = "Ash Alder Brook Fen Grey Hawthorn Marsh Oak Reed Rowan Vale West";
            last = "brook field ford grove hill mere stone vale ward well wick wood";
            break;
        case 2: case 36:
            first = "Ash Black Blood Ember Flint Iron Red Rock Steel Storm Thunder Wolf";
            last = "axe blade fang fist hand heart hide scar spear stride tusk ward";
            break;
        case 3: case 34: case 84: case 85:
            first = "Amber Anvil Bronze Copper Deep Ember Flint Granite Iron Slate Steel Stone";
            last = "beard brow delver forge guard hammer hearth helm mantle pick shield vein";
            break;
        case 4: case 27: case 29: case 86: case 91:
            first = "Amber Ash Dawn Dusk Fern Leaf Moon Moss Night Rain Star Willow";
            last = "bloom branch dew glade grove leaf moon root shade song thorn whisper";
            break;
        case 5:
            first = "Ash Black Briar Cold Dusk Grey Hollow Pale Raven Thorn Winter Wither";
            last = "borne brook field ford grave grove hart hollow mere vale ward wood";
            break;
        case 6: case 28:
            first = "Autumn Cloud Dawn Earth High Mist Rain River Sky Stone Sun Wind";
            last = "bloom caller feather hoof horn meadow path runner song stride walker whisper";
            break;
        case 7: case 37:
            first = "Brass Bright Copper Fizz Gear Glimmer Quick Silver Spark Spring Steam Whistle";
            last = "bolt cog crank dial gear lever pin rivet socket spark spindle spring";
            break;
        case 8: case 31:
            first = "Ash Dusk Ember Fern Jade Jungle Mist Moss Reed River Shade Swift";
            last = "caller dancer fang feather hunter leaf runner shadow song spear tusk watcher";
            break;
        case 9:
            first = "Brass Copper Fizz Flash Gold Quick Silver Spark Steam Tin Twitch Wizzle";
            last = "bolt cash cog fuse gear grin lever pocket rocket spark sprocket wire";
            break;
        case 10:
            first = "Amber Bright Dawn Ember Fire Gold Light Ruby Silver Star Sun Warm";
            last = "bloom brook flame gleam glimmer leaf mantle ray song spell veil whisper";
            break;
        case 11: case 30:
            first = "Amber Azure Bright Crystal Dawn Gleam Light Moon Opal Silver Star Sun";
            last = "borne crest gleam heart keeper mantle seeker shine song walker ward weaver";
            break;
        case 24: case 25: case 26:
            first = "Amber Autumn Bamboo Cloud Dew Green Jade Mist Plum River Spring Willow";
            last = "blossom branch brew brook cloud cup leaf paw reed song staff wind";
            break;
        case 35:
            first = "Amber Dune Dust Ember Gold Red Sand Silt Soft Sun Swift Warm";
            last = "ear foot fur paw runner scarf seeker shade step tail trail whisper";
            break;
        case 52: case 70: case 95: case 96:
            first = "Azure Cloud Dawn Ember Gale Mist Rain Sky Star Storm Sun Wind";
            last = "borne caller crest dancer feather flight gale glider plume song walker wing";
            break;
        default:
            first = "Amber Dawn Dusk Far Mist River Sky Star Stone Sun Swift Wind";
            last = "borne brook caller heart path rover seeker song stride trail walker ward";
            break;
    }
    std::vector<std::string> result;
    std::istringstream prefixes(first);
    for (std::string prefix; prefixes >> prefix;)
    {
        std::istringstream suffixes(last);
        for (std::string suffix; suffixes >> suffix;)
            result.push_back(prefix + suffix);
    }
    return result;
}

// Check every candidate once, in random order. No unchecked or numeric fallback.
template<class Random, class Available>
std::string Pick(std::uint8_t race, Random& random, Available&& available)
{
    auto candidates = Candidates(race);
    std::shuffle(candidates.begin(), candidates.end(), random);
    for (auto const& surname : candidates)
        if (available(surname))
            return surname;
    return {};
}
}
