# Playerbot V2 - Multi-library build (matches V1's architecture).
#
# We split the module into subsystem-scoped STATIC libraries to dodge MSVC's
# 4 GB COFF-archive ceiling AND drastically improve incremental link times.
# A single OBJECT library was the previous approach — it works, but it forces
# `link.exe` to ingest every .obj on every worldserver re-link, eating
# minutes per build and ~5 GB of resident link.exe memory.
#
# Each subsystem becomes its own STATIC archive. The umbrella `playerbot-v2`
# is an INTERFACE library that link-propagates all sub-libs to the dependent
# (worldserver, scripts). The dependent links one target; CMake transitively
# pulls every sub-lib onto the link line, so circular references between
# sub-libs are resolved naturally by the multi-archive symbol search.

option(BUILD_PLAYERBOT_V2 "Build the WoW Forever Bots module (Playerbot V2)" 0)
if(NOT BUILD_PLAYERBOT_V2)
  return()
endif()

option(PLAYERBOT_V2_UNITY_BUILD "Batch Playerbot V2 sources into unity translation units for faster builds" 1)

# ---------------------------------------------------------------------------
# Helper: apply the shared compile/link settings to a sub-library. Keeps the
# per-subsystem section short and ensures every lib has identical compile
# flags so cross-lib symbol matching never trips on ABI mismatch.
# ---------------------------------------------------------------------------
function(playerbot_v2_configure_sublib target_name)
  target_include_directories(${target_name}
    PUBLIC
      ${CMAKE_CURRENT_SOURCE_DIR}
      ${CMAKE_CURRENT_SOURCE_DIR}/Api
    PRIVATE
      ${CMAKE_SOURCE_DIR}/src/server
      ${CMAKE_SOURCE_DIR}/src/server/shared
      ${CMAKE_SOURCE_DIR}/src/server/database
      ${CMAKE_SOURCE_DIR}/src/server/game
      ${CMAKE_SOURCE_DIR}/src/common
  )
  target_link_libraries(${target_name}
    PUBLIC
      trinity-core-interface
      game-interface
    PRIVATE
      shared
      common
  )
  target_compile_definitions(${target_name}
    PUBLIC
      TRINITY_PLAYERBOT_V2=1
  )
  set_target_properties(${target_name}
    PROPERTIES
      CXX_STANDARD 20
      CXX_STANDARD_REQUIRED ON
      CXX_EXTENSIONS OFF
      FOLDER "src/modules/PlayerbotV2"
  )
  # A function that calls itself on every path never returns and the compiler turns it into a bare jump to itself (a static wrapper
  # named like the function it forwards to did this, and froze the world thread): that warning is an error here.
  if(MSVC)
    target_compile_options(${target_name} PRIVATE /W4 /we4717)
  else()
    target_compile_options(${target_name} PRIVATE -Wall -Wextra -Wpedantic)
    # -Wpedantic also fires on core headers the module includes: `, ##__VA_ARGS__` in the log and assert macros, and the
    # anonymous structs inside GameObjectData / ObjectMgr unions. That was over 11,000 warnings per clang build, all from core.
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
      target_compile_options(${target_name} PRIVATE -Wno-gnu-zero-variadic-macro-arguments -Wno-nested-anon-types)
    endif()
    # -Winfinite-recursion exists from GCC 12 / Clang 4; GCC 11 stops on an unknown -Werror= option, so ask first
    include(CheckCXXCompilerFlag)
    check_cxx_compiler_flag(-Winfinite-recursion PLAYERBOT_V2_HAS_WINFINITE_RECURSION)
    if(PLAYERBOT_V2_HAS_WINFINITE_RECURSION)
      target_compile_options(${target_name} PRIVATE -Werror=infinite-recursion)
    endif()
  endif()
  if(USE_COREPCH)
    if(target_name STREQUAL "playerbot-v2-bot")
      target_precompile_headers(${target_name} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/PCH.h)
    else()
      target_precompile_headers(${target_name} REUSE_FROM playerbot-v2-bot)
    endif()
  endif()
  if(PLAYERBOT_V2_UNITY_BUILD AND target_name STREQUAL "playerbot-v2-bot")
    get_target_property(target_sources ${target_name} SOURCES)
    foreach(source ${target_sources})
      set_source_files_properties(${source} PROPERTIES SKIP_UNITY_BUILD_INCLUSION ON)
      if(source MATCHES "/Bot/(Dungeon|Battleground)/Scripts/.*\\.cpp$")
        set_source_files_properties(${source} PROPERTIES SKIP_UNITY_BUILD_INCLUSION OFF)
      endif()
    endforeach()
    set_target_properties(${target_name} PROPERTIES
      UNITY_BUILD ON
      UNITY_BUILD_BATCH_SIZE 8
    )
  endif()
endfunction()

# ---------------------------------------------------------------------------
# Sub-library: Bot — top-level bot logic (state machine, snapshot/builder/view,
# personality, RNG, command parser, intent emitter/executor, registries,
# class tables, recipe difficulty), plus the State_* files under Bot/States/.
# This is the bot logic core; it's referenced by Combat / Group / Session.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-bot STATIC)
CollectAndAddSourceFiles(playerbot-v2-bot ${CMAKE_CURRENT_SOURCE_DIR}/Bot)
playerbot_v2_configure_sublib(playerbot-v2-bot)

# ---------------------------------------------------------------------------
# Sub-library: Combat — class tables, APL rule infrastructure, the 39
# (class, spec) rotation files under Combat/Apl/, and the combat event bus.
# Largest of the sub-libs (~41 .cpp files, including all spec rotations).
# Stays comfortably under the 4 GB COFF limit because each rotation file
# is small (<1 MB .obj).
# ---------------------------------------------------------------------------
add_library(playerbot-v2-combat STATIC)
CollectAndAddSourceFiles(playerbot-v2-combat ${CMAKE_CURRENT_SOURCE_DIR}/Combat)
playerbot_v2_configure_sublib(playerbot-v2-combat)

# ---------------------------------------------------------------------------
# Sub-library: Fleet — multi-bot fleet identity / spawn / management.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-fleet STATIC)
CollectAndAddSourceFiles(playerbot-v2-fleet ${CMAKE_CURRENT_SOURCE_DIR}/Fleet)
playerbot_v2_configure_sublib(playerbot-v2-fleet)

# ---------------------------------------------------------------------------
# Sub-library: Group — group / raid snapshot + builder.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-group STATIC)
CollectAndAddSourceFiles(playerbot-v2-group ${CMAKE_CURRENT_SOURCE_DIR}/Group)
playerbot_v2_configure_sublib(playerbot-v2-group)

# ---------------------------------------------------------------------------
# Sub-library: Session — bot session lifecycle, packet relay, login flow.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-session STATIC)
CollectAndAddSourceFiles(playerbot-v2-session ${CMAKE_CURRENT_SOURCE_DIR}/Session)
playerbot_v2_configure_sublib(playerbot-v2-session)

# ---------------------------------------------------------------------------
# Sub-library: Threading — bot worker pool, snapshot publisher, tick scheduler,
# lock hierarchy. The hot path; small but heavily used.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-threading STATIC)
CollectAndAddSourceFiles(playerbot-v2-threading ${CMAKE_CURRENT_SOURCE_DIR}/Threading)
playerbot_v2_configure_sublib(playerbot-v2-threading)

# ---------------------------------------------------------------------------
# Sub-library: Travel — quest hub database + cluster pathing.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-travel STATIC)
CollectAndAddSourceFiles(playerbot-v2-travel ${CMAKE_CURRENT_SOURCE_DIR}/Travel)
playerbot_v2_configure_sublib(playerbot-v2-travel)

# ---------------------------------------------------------------------------
# Sub-library: Persistence — playerbot DB migrations / character DB access
# wrappers specific to V2.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-persistence STATIC)
CollectAndAddSourceFiles(playerbot-v2-persistence ${CMAKE_CURRENT_SOURCE_DIR}/Persistence)
playerbot_v2_configure_sublib(playerbot-v2-persistence)

# ---------------------------------------------------------------------------
# Sub-library: Diagnostics — perf counters, inspect/history dumps.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-diagnostics STATIC)
CollectAndAddSourceFiles(playerbot-v2-diagnostics ${CMAKE_CURRENT_SOURCE_DIR}/Diagnostics)
playerbot_v2_configure_sublib(playerbot-v2-diagnostics)

# ---------------------------------------------------------------------------
# Sub-library: Util — small-value helpers (config reader, etc).
# ---------------------------------------------------------------------------
add_library(playerbot-v2-util STATIC)
CollectAndAddSourceFiles(playerbot-v2-util ${CMAKE_CURRENT_SOURCE_DIR}/Util)
playerbot_v2_configure_sublib(playerbot-v2-util)

# ---------------------------------------------------------------------------
# Sub-library: World — operator-curated world knowledge (roads, cities,
# crossroads, danger zones, vendors, mailboxes, innkeepers). Backed by
# characters.playerbot_v2_world_metadata. Two consumers: mmaps_generator
# (reads road kind at regen time to tag NAV_AREA_ROAD polygons; closes
# the Teldrassil classifier gap) and BotSnapshotBuilder (loads at start;
# bots query via WorldMetadataView for situational awareness).
# ---------------------------------------------------------------------------
add_library(playerbot-v2-world STATIC)
CollectAndAddSourceFiles(playerbot-v2-world ${CMAKE_CURRENT_SOURCE_DIR}/World)
playerbot_v2_configure_sublib(playerbot-v2-world)

# ---------------------------------------------------------------------------
# Sub-library: Api — PlayerbotAPI (the bot's hands on the game: move, cast,
# loot, trade, queue), bot movement, item scoring and the Classic class/spec,
# supplies and talent tables.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-api STATIC)
CollectAndAddSourceFiles(playerbot-v2-api ${CMAKE_CURRENT_SOURCE_DIR}/Api)
playerbot_v2_configure_sublib(playerbot-v2-api)

# ---------------------------------------------------------------------------
# Sub-library: Hire — hired bots: the Sellsword Captains, Veteran Recruiters and black-market brokers, their prices, upkeep,
# grade gear and health (Playerbot.Hire.* in playerbot.conf). The rest of the module asks it only through HireHooks.h, so it can
# be left out (-DPLAYERBOT_V2_HIRE=0): companions are then always free and the broker NPCs have no script. See Hire/README.md.
# ---------------------------------------------------------------------------
option(PLAYERBOT_V2_HIRE "Build hired bots (the hire brokers, Playerbot.Hire.*) into the bot module" 1)
if(PLAYERBOT_V2_HIRE AND NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Hire/HireModule.cpp)
  message(STATUS "Playerbot V2: Hire/ not found, hired bots are left out")
  set(PLAYERBOT_V2_HIRE 0)
endif()
if(PLAYERBOT_V2_HIRE)
  add_library(playerbot-v2-hire STATIC)
  CollectAndAddSourceFiles(playerbot-v2-hire ${CMAKE_CURRENT_SOURCE_DIR}/Hire)
  playerbot_v2_configure_sublib(playerbot-v2-hire)
endif()

# ---------------------------------------------------------------------------
# Sub-library: Core — module entry point, script registration, the commands
# (.playerbot, .bot, .w) and the Services aggregator.
# ---------------------------------------------------------------------------
add_library(playerbot-v2-core STATIC
  ${CMAKE_CURRENT_SOURCE_DIR}/PlayerbotV2.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/PlayerbotV2Scripts.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/LfgBotFill.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/DungeonFinder.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Services.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/HireHooks.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Commands/cs_playerbot_v2.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Commands/cs_selftest.cpp
)
target_sources(playerbot-v2-core
  PUBLIC
    FILE_SET headers_root TYPE HEADERS BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
    FILES
      ${CMAKE_CURRENT_SOURCE_DIR}/PlayerbotV2.h
      ${CMAKE_CURRENT_SOURCE_DIR}/LfgBotFill.h
      ${CMAKE_CURRENT_SOURCE_DIR}/Services.h
      ${CMAKE_CURRENT_SOURCE_DIR}/HireHooks.h
      ${CMAKE_CURRENT_SOURCE_DIR}/HireTypes.h
      ${CMAKE_CURRENT_SOURCE_DIR}/PCH.h
)
playerbot_v2_configure_sublib(playerbot-v2-core)
if(PLAYERBOT_V2_HIRE)
  set_property(SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/PlayerbotV2Scripts.cpp APPEND
    PROPERTY COMPILE_DEFINITIONS PLAYERBOT_V2_HIRE=1)
endif()

# ---------------------------------------------------------------------------
# Umbrella INTERFACE library. The single name dependents reference; CMake
# transitively links every sub-lib onto the dependent's link line, so
# circular references between subsystems (Bot ↔ Combat, Bot ↔ Session, etc)
# resolve via the multi-archive symbol search the linker performs.
#
# `playerbot-v2-core` is listed last to mirror the load-order of the module
# entry point (it depends on every other sub-lib's symbols).
# ---------------------------------------------------------------------------
add_library(playerbot-v2 INTERFACE)

# The sub-libs have circular references between subsystems (Bot <-> Combat,
# Bot <-> Session, core <-> everything). MSVC's link.exe rescans archives
# until all symbols resolve, so a plain list works there. GNU ld / LLD do a
# single left-to-right pass, so circular archive refs must be wrapped in a
# link group (--start-group/--end-group) via the RESCAN feature.
set(PLAYERBOT_V2_SUBLIBS
  playerbot-v2-bot
  playerbot-v2-combat
  playerbot-v2-fleet
  playerbot-v2-group
  playerbot-v2-session
  playerbot-v2-threading
  playerbot-v2-travel
  playerbot-v2-persistence
  playerbot-v2-world
  playerbot-v2-diagnostics
  playerbot-v2-util
  playerbot-v2-api
  playerbot-v2-core
)
if(PLAYERBOT_V2_HIRE)
  list(APPEND PLAYERBOT_V2_SUBLIBS playerbot-v2-hire)
endif()
if(MSVC OR APPLE)
  # Apple's ld64 also searches every archive until all symbols resolve, and CMake has no RESCAN link group for it
  target_link_libraries(playerbot-v2 INTERFACE ${PLAYERBOT_V2_SUBLIBS} game)
else()
  # game calls the module through PlayerbotHooks and the module calls back into game (PlayerbotAPI.cpp, ClassicSpec.cpp,
  # BotItemScorer.cpp), so game belongs in the same group; otherwise an executor that lists game before this
  # interface (tests) cannot resolve those symbols.
  target_link_libraries(playerbot-v2 INTERFACE
    "$<LINK_GROUP:RESCAN,${PLAYERBOT_V2_SUBLIBS},game>")
endif()

trinity_add_module(playerbot-v2 AddSC_playerbot_v2
  CONFIGS
    ${CMAKE_CURRENT_SOURCE_DIR}/conf/playerbot.conf.dist
    ${CMAKE_CURRENT_SOURCE_DIR}/conf/zz-0-playerbot-defaults.conf)

# Default settings (world bots, auction house bot, bot logging) as an active file in worldserver.conf.d, so the bots work
# out of the box. An existing copy is never overwritten.
set(PLAYERBOT_V2_DEFAULT_CONF ${CMAKE_CURRENT_SOURCE_DIR}/conf/zz-forever-bots.conf)
set(PLAYERBOT_V2_COPY_IF_MISSING ${CMAKE_CURRENT_SOURCE_DIR}/conf/CopyIfMissing.cmake)
if(COPY_CONF)
  if(UNIX)
    set(_pbv2_build_conf_dir ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../etc/worldserver.conf.d)
    set(_pbv2_install_conf_dir ${CONF_DIR}/worldserver.conf.d)
  elseif(WIN32)
    set(_pbv2_build_conf_dir ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/worldserver.conf.d)
    set(_pbv2_install_conf_dir ${CMAKE_INSTALL_PREFIX}/worldserver.conf.d)
  endif()
  if(_pbv2_build_conf_dir)
    # The Looking-for-group settings are a file of their own (zz-forever-lfg.conf), copied the same way.
    set(PLAYERBOT_V2_LFG_CONF ${CMAKE_CURRENT_SOURCE_DIR}/conf/zz-forever-lfg.conf)
    # The classic script loggers (zz-forever-classic-log.conf) likewise, so an install that already has zz-forever-bots.conf gets them.
    set(PLAYERBOT_V2_CLASSIC_LOG_CONF ${CMAKE_CURRENT_SOURCE_DIR}/conf/zz-forever-classic-log.conf)
    add_custom_target(playerbot-v2-default-conf ALL
      COMMAND ${CMAKE_COMMAND} -DSRC=${PLAYERBOT_V2_DEFAULT_CONF} -DDST_DIR=${_pbv2_build_conf_dir}
              -P ${PLAYERBOT_V2_COPY_IF_MISSING}
      COMMAND ${CMAKE_COMMAND} -DSRC=${PLAYERBOT_V2_LFG_CONF} -DDST_DIR=${_pbv2_build_conf_dir}
              -P ${PLAYERBOT_V2_COPY_IF_MISSING}
      COMMAND ${CMAKE_COMMAND} -DSRC=${PLAYERBOT_V2_CLASSIC_LOG_CONF} -DDST_DIR=${_pbv2_build_conf_dir}
              -P ${PLAYERBOT_V2_COPY_IF_MISSING})
    install(CODE "execute_process(COMMAND \"${CMAKE_COMMAND}\" \"-DSRC=${PLAYERBOT_V2_DEFAULT_CONF}\" \"-DDST_DIR=\$ENV{DESTDIR}${_pbv2_install_conf_dir}\" -P \"${PLAYERBOT_V2_COPY_IF_MISSING}\")")
    install(CODE "execute_process(COMMAND \"${CMAKE_COMMAND}\" \"-DSRC=${PLAYERBOT_V2_LFG_CONF}\" \"-DDST_DIR=\$ENV{DESTDIR}${_pbv2_install_conf_dir}\" -P \"${PLAYERBOT_V2_COPY_IF_MISSING}\")")
    install(CODE "execute_process(COMMAND \"${CMAKE_COMMAND}\" \"-DSRC=${PLAYERBOT_V2_CLASSIC_LOG_CONF}\" \"-DDST_DIR=\$ENV{DESTDIR}${_pbv2_install_conf_dir}\" -P \"${PLAYERBOT_V2_COPY_IF_MISSING}\")")
  endif()
endif()

message(STATUS "Playerbot V2 module enabled (multi-library: 13 sub-libs; hired bots: ${PLAYERBOT_V2_HIRE}; unity build: ${PLAYERBOT_V2_UNITY_BUILD})")
