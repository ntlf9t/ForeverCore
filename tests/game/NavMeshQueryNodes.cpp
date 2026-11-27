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

#include "MMapDefines.h"
#include "MMapManager.h"
#include "dtQueryFilterTC.h"
#include <DetourNode.h>
#include <cstdio>
#include <filesystem>
#include <random>
#include <string>

namespace
{
    // A temp dir holding mmaps/0000.mmap with a valid header and no tiles: enough for MMapManager to create the dtNavMesh
    // and the per-instance dtNavMeshQuery.
    struct TempMmapDir
    {
        std::filesystem::path root;

        TempMmapDir()
        {
            root = std::filesystem::temp_directory_path() / ("navmesh_query_nodes_" + std::to_string(std::random_device{}()));
            std::filesystem::create_directories(root / "mmaps");
            MmapNavMeshHeader header;
            header.params.tileWidth = 533.33333f;
            header.params.tileHeight = 533.33333f;
            header.params.maxTiles = 64 * 64;
            header.params.maxPolys = 1 << 10;   // tile + poly bits must leave room for the salt
            FILE* f = std::fopen((root / "mmaps" / "0000.mmap").string().c_str(), "wb");
            REQUIRE(f);
            REQUIRE(std::fwrite(&header, sizeof(header), 1, f) == 1);
            std::fclose(f);
        }

        ~TempMmapDir()
        {
            std::error_code ec;
            std::filesystem::remove_all(root, ec);
        }

        std::string BasePath() const { return root.string() + "/"; }
    };

    int QueryNodes(MMAP::MMapManager& mgr, std::string const& basePath, uint32 instanceId)
    {
        REQUIRE(mgr.loadMapInstance(basePath, 0, 0, instanceId));
        dtNavMeshQuery const* query = mgr.GetNavMeshQuery(0, 0, instanceId);
        REQUIRE(query);
        return query->getNodePool()->getMaxNodes();
    }
}

TEST_CASE("Open-world navmesh queries get a 32768-node pool by default, instances keep 8192", "[NavMeshQueryNodes]")
{
    TempMmapDir dir;
    MMAP::MMapManager mgr;
    mgr.InitializeThreadUnsafe({ { 0u, {} } });

    CHECK(mgr.GetWorldQueryNodes() == 32768);
    CHECK(QueryNodes(mgr, dir.BasePath(), 0) == 32768);
    CHECK(QueryNodes(mgr, dir.BasePath(), 7) == MMAP::MMapManager::INSTANCE_QUERY_NODES);
}

TEST_CASE("Pathfinding.NavMeshQueryNodes sets the open-world pool only", "[NavMeshQueryNodes]")
{
    TempMmapDir dir;
    MMAP::MMapManager mgr;
    mgr.InitializeThreadUnsafe({ { 0u, {} } });

    mgr.SetWorldQueryNodes(65535);
    CHECK(QueryNodes(mgr, dir.BasePath(), 0) == 65535);
    CHECK(QueryNodes(mgr, dir.BasePath(), 7) == 8192);
}

TEST_CASE("The world node pool is clamped to what Detour can index", "[NavMeshQueryNodes]")
{
    MMAP::MMapManager mgr;
    mgr.SetWorldQueryNodes(1024);
    CHECK(mgr.GetWorldQueryNodes() == 8192);     // never below the instance pool (the old value)
    mgr.SetWorldQueryNodes(100000);
    CHECK(mgr.GetWorldQueryNodes() == 65535);    // dtNodePool indexes with 16 bits
    mgr.SetWorldQueryNodes(40000);
    CHECK(mgr.GetWorldQueryNodes() == 40000);
}

TEST_CASE("Path stats count searches that ran out of nodes or hit the polygon cap", "[NavMeshQueryNodes]")
{
    dtQueryFilterTC::ResetStats();
    dtQueryFilterTC::TallyPath(nullptr, nullptr, 0, false, 1.0f, false, 0, /*outOfNodes*/ true, /*polyCapHit*/ false);
    dtQueryFilterTC::TallyPath(nullptr, nullptr, 0, false, 1.0f, false, 0, false, true);
    dtQueryFilterTC::TallyPath(nullptr, nullptr, 0, false, 1.0f, false, 1);

    dtQueryFilterTC::RoadStats const all = dtQueryFilterTC::SampleStats();
    CHECK(all.pathsRun == 3);
    CHECK(all.pathsOutOfNodes == 1);
    CHECK(all.pathsPolyCapHit == 1);

    dtQueryFilterTC::RoadStats const ek = dtQueryFilterTC::SampleStatsForMap(0);
    CHECK(ek.pathsRun == 2);
    CHECK(ek.pathsOutOfNodes == 1);
    CHECK(ek.pathsPolyCapHit == 1);
    CHECK(dtQueryFilterTC::SampleStatsForMap(1).pathsOutOfNodes == 0);
    dtQueryFilterTC::ResetStats();
}
