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

#include "BoundingIntervalHierarchyWrapper.h"
#include <cstring>
#include <limits>
#include <vector>

// The dynamic collision tree (game object models, one tree per grid cell of a map) is rebuilt from the objects' bounds on the
// map update thread. BIH::build loops for ever on an infinite bound and can throw std::logic_error ("invalid node overlap") on
// NaN or low-above-high bounds; nothing caught the throw, so the world server aborted. BIHWrap::balance() now leaves such
// objects out of the tree. These cases fail (throw, or never return) without that.

namespace
{
    struct BoxObject
    {
        G3D::AABox Bounds;
    };

    struct BoxObjectBounds
    {
        void operator()(BoxObject const* obj, G3D::AABox& out) const { out = obj->Bounds; }
    };

    using Tree = BIHWrap<BoxObject, BoxObjectBounds>;

    // G3D only debug-asserts on NaN or low-above-high bounds, so a release build stores them as given; write them directly so
    // the test does the same in every build type.
    BoxObject MakeBox(float lx, float ly, float lz, float hx, float hy, float hz)
    {
        static_assert(sizeof(G3D::AABox) == 2 * sizeof(G3D::Vector3));
        G3D::Vector3 const corners[2] = { { lx, ly, lz }, { hx, hy, hz } };
        BoxObject obj;
        std::memcpy(static_cast<void*>(&obj.Bounds), corners, sizeof(corners));
        return obj;
    }

    BoxObject MakeCube(float x, float y, float z)
    {
        return MakeBox(x, y, z, x + 1.0f, y + 1.0f, z + 1.0f);
    }

    struct PointHits
    {
        std::size_t Count = 0;
        void operator()(G3D::Vector3 const& point, BoxObject const& obj)
        {
            if (obj.Bounds.contains(point))
                ++Count;
        }
    };

    std::size_t CountHits(Tree& tree, G3D::Vector3 const& point)
    {
        PointHits hits;
        tree.intersectPoint(point, hits);
        return hits.Count;
    }

    bool InTree(Tree const& tree, BoxObject const& obj)
    {
        for (BoxObject const* member : tree.getObjects())
            if (member == &obj)
                return true;
        return false;
    }
}

TEST_CASE("BIHWrap builds a tree of usable bounds", "[BIHWrap]")
{
    BoxObject a = MakeCube(0.0f, 0.0f, 0.0f);
    BoxObject b = MakeCube(10.0f, 10.0f, 10.0f);

    Tree tree;
    tree.insert(a);
    tree.insert(b);

    REQUIRE_NOTHROW(tree.balance());
    REQUIRE(tree.getObjects().size() == 2);
    REQUIRE(CountHits(tree, G3D::Vector3(0.5f, 0.5f, 0.5f)) == 1);
    REQUIRE(CountHits(tree, G3D::Vector3(10.5f, 10.5f, 10.5f)) == 1);
}

TEST_CASE("BIHWrap leaves out bounds that make the build throw", "[BIHWrap]")
{
    float const inf = std::numeric_limits<float>::infinity();
    float const nan = std::numeric_limits<float>::quiet_NaN();

    // Smallest set found by a fuzzer for which BIH::build throws "invalid node overlap" (three of the five are unusable).
    BoxObject badA = MakeBox(-953.0f, -inf, -319.0f, -911.0f, -422.0f, -299.0f);
    BoxObject badB = MakeBox(-224.0f, -80.0f, 277.0f, -176.0f, inf, 289.0f);
    BoxObject good = MakeBox(-428.0f, 262.0f, 761.0f, -397.0f, 306.0f, 809.0f);
    BoxObject badC = MakeBox(323.0f, -965.0f, 420.0f, 356.0f, -927.0f, nan);
    BoxObject badD = MakeBox(387.0f, -556.0f, -667.0f, 393.0f, -598.0f, -630.0f);   // low above high on y

    Tree tree;
    for (BoxObject const* obj : { &badA, &badB, &good, &badC, &badD })
        tree.insert(*obj);

    REQUIRE_NOTHROW(tree.balance());
    REQUIRE(tree.getObjects().size() == 1);
    REQUIRE(InTree(tree, good));
    REQUIRE(CountHits(tree, G3D::Vector3(-410.0f, 280.0f, 780.0f)) == 1);
}

TEST_CASE("BIHWrap leaves out infinite bounds that the build never returned from", "[BIHWrap]")
{
    float const inf = std::numeric_limits<float>::infinity();

    // Smallest set found by a fuzzer on which BIH::build loops for ever: without the check this case does not finish.
    BoxObject tall = MakeBox(-486.0f, 154.0f, -533.0f, -471.0f, 187.0f, inf);
    BoxObject a = MakeBox(321.0f, 777.0f, 871.0f, 356.0f, 821.0f, 871.0f);
    BoxObject b = MakeBox(-862.0f, -962.0f, -224.0f, -824.0f, -951.0f, -206.0f);
    BoxObject deep = MakeBox(435.0f, 845.0f, -inf, 448.0f, 841.0f, -583.0f);

    Tree tree;
    for (BoxObject const* obj : { &tall, &a, &b, &deep })
        tree.insert(*obj);

    REQUIRE_NOTHROW(tree.balance());
    REQUIRE(tree.getObjects().size() == 2);
    REQUIRE(!InTree(tree, tall));
    REQUIRE(!InTree(tree, deep));
    REQUIRE(CountHits(tree, G3D::Vector3(330.0f, 800.0f, 871.0f)) == 1);
    REQUIRE(CountHits(tree, G3D::Vector3(-850.0f, -955.0f, -215.0f)) == 1);

    // Taken out and put back with usable bounds, it is in the next tree.
    tree.remove(tall);
    tall = MakeCube(5.0f, 5.0f, 5.0f);
    tree.insert(tall);
    REQUIRE_NOTHROW(tree.balance());
    REQUIRE(InTree(tree, tall));
    REQUIRE(CountHits(tree, G3D::Vector3(5.5f, 5.5f, 5.5f)) == 1);
}
