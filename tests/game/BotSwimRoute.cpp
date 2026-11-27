#include "tc_catch2.h"
#include "../../src/modules/PlayerbotV2/Api/BotSwim.h"

using namespace Playerbot::BotMovement::Swim;

// A lake with its surface at z 20 and its bed at z 10; a human's collision height 2.03 swims at 20 - 1.218 = 18.782.
TEST_CASE("A bot's route point on the water surface goes down to its swim z", "[BotSwim]")
{
    float const level = 20.0f;
    float const height = 2.03f;
    float const swim_z = SwimZ(level, height);
    REQUIRE(swim_z == Catch::Approx(18.782f));
    REQUIRE(IsDeep(level, 10.0f, height));

    // the navmesh's water polygon lies on the surface: that point is lowered
    REQUIRE(RoutePointNeedsLowering(level, swim_z));
    // a point a little over the surface (the mesh's height error) as well
    REQUIRE(RoutePointNeedsLowering(level + 0.4f, swim_z));
    // between the surface and the swim z: still too high, the head would be all that is under
    REQUIRE(RoutePointNeedsLowering(swim_z + 0.5f, swim_z));
}

TEST_CASE("A route point at or under the swim z keeps its depth", "[BotSwim]")
{
    float const swim_z = SwimZ(20.0f, 2.03f);
    // already at the swim z (a goal MoveTo put there, a point lowered before): not moved, so a second pass changes nothing
    REQUIRE_FALSE(RoutePointNeedsLowering(swim_z, swim_z));
    REQUIRE_FALSE(RoutePointNeedsLowering(swim_z + kRouteLowerSlack, swim_z));
    // a dive to something on the floor, and the lake bed itself, are never lifted
    REQUIRE_FALSE(RoutePointNeedsLowering(swim_z - 3.0f, swim_z));
    REQUIRE_FALSE(RoutePointNeedsLowering(10.0f, swim_z));
}

TEST_CASE("Shallow water and points over the water are not swum", "[BotSwim]")
{
    float const height = 2.03f;
    // wading water: the floor 1.5 under the surface is shallower than the bot is tall, so SwimLevel says no swim there
    REQUIRE_FALSE(IsDeep(20.0f, 18.5f, height));
    // a bridge or a pier 5 y over the surface is asked from above the water: SwimLevel leaves it alone
    REQUIRE(AskedFromAbove(25.0f, 20.0f));
    REQUIRE_FALSE(AskedFromAbove(20.0f, 20.0f));
    REQUIRE_FALSE(AskedFromAbove(20.0f + kAboveSurfaceAsk, 20.0f));
}

TEST_CASE("The swim depth keeps the head out for every body size", "[BotSwim]")
{
    // a gnome, a human and a tauren: over half the body under, never deeper than kSwimMaxDepth, so the route does not drown them
    for (float height : { 1.1f, 2.03f, 2.9f })
    {
        float const depth = 20.0f - SwimZ(20.0f, height);
        REQUIRE(depth >= kSwimMinDepth);
        REQUIRE(depth <= kSwimMaxDepth + 1e-4f);   // 20 - (20 - 1.6) is 1.6000004 in floats
        REQUIRE(depth < height);
    }
}
