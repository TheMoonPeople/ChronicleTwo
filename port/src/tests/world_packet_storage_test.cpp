#include <gtest/gtest.h>

#include <cstddef>
#include <limits>
#include <span>
#include <stdexcept>

#include "character.hpp"
#include "charasetup.hpp"
#include "map.hpp"
#include "object/world/data_packets.hpp"
#include "platform/arena.hpp"
#include "scene.hpp"
#include "userdata.hpp"

TEST(WorldPacketStorage, ReloadingEveryPartyLayoutPreservesTheTownMapProducer) {
    const int character_quads = GetCharaMemAllocSize() + CHARA_MEM_STACK_NUM * 4;
    const int parent_quads = character_quads + 4096;
    mgCMemory parent;
    parent.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&parent,
                                                                static_cast<std::size_t>(parent_quads) * sizeof(u_long128))),
                       parent_quads);
    mgCMemory characters;
    dc2::world::BindCharacterPrefix(parent, characters, character_quads);
    parent.Align64();
    const int reserved = parent.stGetUsed();
    parent.stSetLocked(true);
    mgCMemory map_storage;
    map_storage.stSetBorrowedBuffer(parent,
                                    std::span(parent.stGetTop(), static_cast<std::size_t>(parent.stGetRest())));
    auto *map = dc2::memory::NewObject<CMap>(map_storage);
    ASSERT_NE(map, nullptr);
    CScene scene;
    scene.map_num = 1;
    char name[] = "persistent";
    ASSERT_EQ(scene.map[0].AssignData(map, name), 1);
    scene.map[0].stack = &map_storage;
    const auto map_lifetime = dc2::memory::ArenaLifetime::Capture(map_storage);
    scene.map[0].BindResources(map_lifetime);
    const auto               parent_generation = dc2::memory::ArenaGeneration(parent);
    mgCMemory                parts[CHARA_MEM_STACK_NUM];
    dc2::memory::ArenaBuffer previous_frame;
    const int                types[] = {USER_CHARA_MAX, USER_CHARA_MONICA, USER_CHARA_ROBO, USER_CHARA_MONSTER};
    for (int cycle = 0; cycle < 2; ++cycle) {
        for (const int type : types) {
            const int town = type == USER_CHARA_MAX || type == USER_CHARA_MONICA;
            ASSERT_TRUE(GetCharaMemAllocPtr(&characters, parts, type, town));
            EXPECT_TRUE(previous_frame.Bytes().empty());
            EXPECT_EQ(dc2::memory::ArenaGeneration(parent), parent_generation);
            EXPECT_EQ(parent.stGetUsed(), reserved);
            EXPECT_TRUE(map_lifetime.IsLive());
            EXPECT_EQ(scene.GetMap(0), map);
            auto *frame = dc2::memory::NewObject<mgCFrame>(parts[0]);
            ASSERT_NE(frame, nullptr);
            previous_frame = dc2::memory::ArenaBuffer::Bind(parts[0],
                                                            std::span(reinterpret_cast<u8 *>(frame), sizeof(*frame)));
            EXPECT_FALSE(previous_frame.Bytes().empty());
            EXPECT_LE(parts[0].stack + parts[0].stack_size, map_storage.stack);
        }
    }
}

TEST(WorldPacketStorage, MapAndGeoramaLayoutsPreserveCharacterProducers) {
    static char root_key;
    mgCMemory   characters;
    characters.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&root_key, 256 * sizeof(u_long128))), 256);
    auto *prefix = characters.Alloc(64);
    ASSERT_NE(prefix, nullptr);
    mgCMemory model;
    model.stSetChildBuffer(characters, prefix, 64);
    auto *frame = dc2::memory::NewObject<mgCFrame>(model);
    ASSERT_NE(frame, nullptr);
    CCharacter2 character;
    character.CObjectFrame::frame = frame;
    ASSERT_TRUE(dc2::character::CaptureModelResources(character, model));
    characters.stSetLocked(true);
    const auto                    generation = dc2::memory::ArenaGeneration(characters);
    dc2::world::DataPacketStorage packets;

    auto ordinary = packets.Prepare(dc2::world::DataPacketMode::Map, characters, 80);
    EXPECT_TRUE(ordinary.changed);
    EXPECT_EQ(characters.stack_used, 80);
    EXPECT_NE(characters.lock, 0);
    EXPECT_EQ(dc2::memory::ArenaGeneration(characters), generation);
    ASSERT_TRUE(dc2::character::ResourcesLive(character));
    EXPECT_EQ(character.GetFrame(), frame);
    ASSERT_EQ(ordinary.buffers[0].stack_size, 70000);
    auto *packet = ordinary.buffers[0].Alloc(1);
    ASSERT_NE(packet, nullptr);
    const auto old_packet = dc2::memory::ArenaBuffer::Bind(ordinary.buffers[0],
                                                           std::span(reinterpret_cast<u8 *>(packet), sizeof(u_long128)));
    const auto packet_generation = dc2::memory::ArenaGeneration(ordinary.buffers[0]);
    auto       unchanged = packets.Prepare(dc2::world::DataPacketMode::Map, characters, 80);
    EXPECT_FALSE(unchanged.changed);
    EXPECT_EQ(dc2::memory::ArenaGeneration(unchanged.buffers[0]), packet_generation);
    EXPECT_FALSE(old_packet.Bytes().empty());

    auto georama = packets.Prepare(dc2::world::DataPacketMode::Georama, characters, 80);
    EXPECT_TRUE(georama.changed);
    EXPECT_EQ(georama.buffers[0].stack_size, 115000);
    EXPECT_TRUE(old_packet.Bytes().empty());
    EXPECT_EQ(characters.stack_used, 80);
    EXPECT_EQ(dc2::memory::ArenaGeneration(characters), generation);
    EXPECT_TRUE(dc2::character::ResourcesLive(character));

    model.stReset();
    EXPECT_FALSE(dc2::character::ResourcesLive(character));
}

TEST(WorldPacketStorage, InvalidPrefixLeavesCharacterAndPacketStorageUnchanged) {
    static char root_key;
    mgCMemory   characters;
    characters.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&root_key, 64 * sizeof(u_long128))), 64);
    ASSERT_NE(characters.Alloc(8), nullptr);
    characters.stSetLocked(true);
    const auto                    generation = dc2::memory::ArenaGeneration(characters);
    dc2::world::DataPacketStorage packets;
    auto                          prepared = packets.Prepare(dc2::world::DataPacketMode::Map, characters, 8);
    const auto                    packet_generation = dc2::memory::ArenaGeneration(prepared.buffers[0]);
    EXPECT_THROW(static_cast<void>(packets.Prepare(dc2::world::DataPacketMode::Georama, characters,
                                                   std::numeric_limits<std::size_t>::max())),
                 std::length_error);
    EXPECT_EQ(characters.stack_used, 8);
    EXPECT_NE(characters.lock, 0);
    EXPECT_EQ(dc2::memory::ArenaGeneration(characters), generation);
    EXPECT_EQ(dc2::memory::ArenaGeneration(prepared.buffers[0]), packet_generation);
}

TEST(WorldPacketStorage, BootstrapStorageDoesNotBorrowTheCharacterOrReadBuffer) {
    mgCMemory                     unbound;
    dc2::world::DataPacketStorage packets;
    auto                          prepared = packets.Prepare(dc2::world::DataPacketMode::Bootstrap, unbound, 0);
    EXPECT_TRUE(prepared.changed);
    EXPECT_EQ(unbound.stack, nullptr);
    EXPECT_EQ(unbound.stack_used, 0);
    for (auto &buffer : prepared.buffers) {
        EXPECT_EQ(buffer.stack_size, 5000);
        EXPECT_NE(buffer.Alloc(4999), nullptr);
    }
}

TEST(WorldPacketStorage, RepeatedLayoutChangesRetirePacketsWithoutBorrowingThePreviousExtent) {
    mgCMemory characters;
    characters.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&characters, 256 * sizeof(u_long128))), 256);
    ASSERT_NE(characters.Alloc(80), nullptr);
    characters.stSetLocked(true);
    const auto                              character_generation = dc2::memory::ArenaGeneration(characters);
    dc2::world::DataPacketStorage           packets;
    std::array<dc2::memory::ArenaBuffer, 2> previous;
    for (const auto mode : {dc2::world::DataPacketMode::Georama, dc2::world::DataPacketMode::Map,
                            dc2::world::DataPacketMode::Bootstrap, dc2::world::DataPacketMode::Map,
                            dc2::world::DataPacketMode::Georama, dc2::world::DataPacketMode::Map,
                            dc2::world::DataPacketMode::Georama}) {
        const auto prepared = packets.Prepare(mode, characters, 80);
        ASSERT_TRUE(prepared.changed);
        for (std::size_t index = 0; index < previous.size(); ++index) {
            EXPECT_TRUE(previous[index].Bytes().empty());
            auto     &buffer = prepared.buffers[index];
            const int expected = mode == dc2::world::DataPacketMode::Georama ? 115000 : mode == dc2::world::DataPacketMode::Map ? 70000
                                                                                                                                : 5000;
            EXPECT_EQ(buffer.stGetSize(), expected);
            auto *allocation = buffer.Alloc(expected - 1);
            ASSERT_NE(allocation, nullptr);
            previous[index] = dc2::memory::ArenaBuffer::Bind(buffer,
                                                             std::span(reinterpret_cast<u8 *>(allocation), static_cast<std::size_t>(expected - 1) * sizeof(u_long128)));
            EXPECT_FALSE(previous[index].Bytes().empty());
        }
        EXPECT_EQ(characters.stGetUsed(), 80);
        EXPECT_NE(characters.lock, 0);
        EXPECT_EQ(dc2::memory::ArenaGeneration(characters), character_generation);
    }
}
