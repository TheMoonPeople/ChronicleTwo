#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstring>
#include <iterator>
#include <limits>
#include <memory>
#include <stdexcept>
#include <vector>

#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "platform/arena.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"

namespace {

constexpr int kStorageQuads = 1024;
constexpr int kGroupCount = 40;

std::vector<u_long128> Storage(int quadwords, uint8_t fill) {
    std::vector<u_long128> storage(quadwords);
    std::memset(storage.data(), fill, storage.size() * sizeof(u_long128));
    return storage;
}

using SceneHandle = std::unique_ptr<CScene>;

SceneHandle EmptyScene() {
    return std::make_unique<CScene>();
}

} // namespace

TEST(StrideFix, DrawManagerTablesHoldPointers) {
    // Filled before stSetBuffer so stale bytes show up in every table a 4-byte stride would miss.
    std::vector<u_long128> storage = Storage(kStorageQuads, 0xFF);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), kStorageQuads);

    mgCTextureManager texture_manager;
    texture_manager.block_max = kGroupCount;

    mgCDrawManager manager;
    manager.texture_manager = &texture_manager;
    // Retail ctor leaves render_info unset; the game's instance is zero-initialised, so match that default.
    manager.render_info = nullptr;
    manager.SetSortTable(2);
    manager.BeginDraw(&memory, {});

    ASSERT_EQ(manager.group_num, kGroupCount);
    for (int i = 0; i < kGroupCount; i++) {
        EXPECT_EQ(manager.packet_list[i], nullptr) << "group " << i;
        EXPECT_EQ(manager.packet_num[i], 0) << "group " << i;
    }
    for (int j = 0; j < manager.sort_num; j++) {
        EXPECT_EQ(manager.sort_table[j], nullptr) << "bucket " << j;
    }

    u_long128 commons[4] = {};
    u_long128 packets[4] = {};
    // Groups past 8 are the ones a 4-byte stride would collide with.
    const int groups[] = {0, 3, 9, 12, 39, 12};
    for (std::size_t i = 0; i < std::size(groups); i++) {
        manager.AddPacket(groups[i], &commons[i % 4], &packets[i % 4], 0);
    }

    std::vector<mgSORT_PACKET *> chain;
    for (mgSORT_PACKET *node = manager.sort_table[0]; node != nullptr; node = node->next) {
        chain.push_back(node);
    }
    ASSERT_EQ(chain.size(), std::size(groups));

    manager.PreEndDraw();

    for (int group = 0; group < kGroupCount; group++) {
        std::vector<mgSORT_PACKET *> expected;
        for (mgSORT_PACKET *node : chain) {
            if (node->group == group) {
                expected.push_back(node);
            }
        }

        ASSERT_EQ(manager.packet_num[group], static_cast<int>(expected.size())) << "group " << group;
        if (expected.empty()) {
            continue;
        }

        ASSERT_NE(manager.packet_list[group], nullptr) << "group " << group;
        for (std::size_t k = 0; k < expected.size(); k++) {
            EXPECT_EQ(manager.packet_list[group][k], expected[k]) << "group " << group << " slot " << k;
        }
    }
}

TEST(StrideFix, ClearStackWalksPointerArray) {
    constexpr int kStackCount = 5;
    constexpr int kNullSlot = 3;
    constexpr int kStackQuads = 64;

    std::vector<std::vector<u_long128>> buffers;
    std::vector<mgCMemory>              memories(kStackCount);
    for (int i = 0; i < kStackCount; i++) {
        buffers.push_back(Storage(kStackQuads, 0));
        memories[i].stSetBuffer(buffers[i].data(), kStackQuads);
        memories[i].Alloc(3);
        memories[i].lock = 1;
    }

    SceneHandle scene = EmptyScene();
    scene->stack_num = kStackCount;
    for (int i = 0; i < kStackCount; i++) {
        scene->stack[i] = &memories[i];
    }
    scene->stack[kNullSlot] = nullptr;

    const int size_at_index = memories[1].stack_size;
    scene->ClearStack(1);

    EXPECT_EQ(memories[0].stack_used, 3);
    EXPECT_EQ(memories[0].lock, 1);

    // The entry at the index keeps its buffer; only the entries after it release theirs.
    EXPECT_EQ(memories[1].stack_used, 0);
    EXPECT_EQ(memories[1].lock, 0);
    EXPECT_NE(memories[1].stack, nullptr);
    EXPECT_EQ(memories[1].stack_size, size_at_index);

    for (int i : {2, 4}) {
        EXPECT_EQ(memories[i].stack_used, 0) << "stack " << i;
        EXPECT_EQ(memories[i].lock, 0) << "stack " << i;
        EXPECT_EQ(memories[i].stack, nullptr) << "stack " << i;
        EXPECT_EQ(memories[i].stack_size, 0) << "stack " << i;
    }

    EXPECT_EQ(scene->stack[kNullSlot], nullptr);
}

TEST(StrideFix, TexAnimeGroupAppends) {
    constexpr int          kStackQuads = 256;
    std::vector<u_long128> storage = Storage(kStackQuads, 0);
    mgCMemory              stack;
    stack.stSetBuffer(storage.data(), kStackQuads);

    mgCTextureAnime         anime;
    CList<mgCTexAnimeData> *first = anime.NewTexAnimeGroupData(2, &stack);
    CList<mgCTexAnimeData> *second = anime.NewTexAnimeGroupData(2, &stack);

    ASSERT_NE(first, nullptr);
    ASSERT_NE(second, nullptr);
    EXPECT_NE(first, second);
    EXPECT_EQ(anime.list[2], first);
    EXPECT_EQ(anime.now[2], first);
    EXPECT_EQ(first->next, second);
    EXPECT_EQ(second->prev, first);
    EXPECT_EQ(second->next, nullptr);
    EXPECT_EQ(anime.list[0], nullptr);
    EXPECT_EQ(anime.list[1], nullptr);
}

TEST(StrideFix, DrawOrderRejectsMissingTerminatorAndOutOfRangeIdsBeforeAllocation) {
    std::array<u_long128, 64> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto original = storage;
    mgCMemory  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    mgCTextureManager textures;
    textures.block_max = 2;
    mgCDrawManager manager;
    manager.texture_manager = &textures;
    manager.SetSortTable(2);
    const int unterminated[]{0, 1};
    const int invalid[]{2, -1};
    EXPECT_THROW(manager.BeginDraw(&memory, unterminated), std::invalid_argument);
    EXPECT_THROW(manager.BeginDraw(&memory, invalid), std::invalid_argument);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(storage, original);
}

TEST(StrideFix, DrawTablesRejectShortArenaBeforeAnyAllocationOrWrite) {
    std::array<u_long128, 4> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto  original = storage;
    mgCMemory   memory;
    static char key;
    auto       *root = reinterpret_cast<u_long128 *>(ArenaBlock(&key, sizeof(storage)));
    std::memcpy(root, storage.data(), sizeof(storage));
    memory.stSetBuffer(root, static_cast<int>(storage.size()));
    ASSERT_EQ(memory.stack_size, static_cast<int>(storage.size()));
    mgCTextureManager textures;
    textures.block_max = 2;
    mgCDrawManager manager;
    manager.texture_manager = &textures;
    manager.SetSortTable(2);
    EXPECT_THROW(manager.BeginDraw(&memory, {}), std::length_error);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(std::memcmp(root, original.data(), sizeof(original)), 0);
}

TEST(StrideFix, NegativePacketGroupUsesTheFirstDrawnGroupAndEmptyOrdersAcceptNoPackets) {
    std::array<u_long128, 128> storage{};
    mgCMemory                  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    mgCTextureManager textures;
    textures.block_max = 2;
    mgCDrawManager manager;
    manager.texture_manager = &textures;
    manager.SetSortTable(2);
    const int order[]{1, -1};
    manager.BeginDraw(&memory, order);
    manager.AddPacket(-1, nullptr, nullptr, 0);
    ASSERT_NE(manager.sort_table[0], nullptr);
    EXPECT_EQ(manager.sort_table[0]->group, 0);
    EXPECT_EQ(manager.packet_num[0], 1);
    memory.stReset();
    const int empty[]{-1};
    manager.BeginDraw(&memory, empty);
    const int used = memory.stack_used;
    manager.AddPacket(-1, nullptr, nullptr, 0);
    EXPECT_EQ(memory.stack_used, used);
    EXPECT_EQ(manager.sort_table[0], nullptr);
}

TEST(StrideFix, FrameTablesRejectTheirOwnersResetBeforeAnyPacketAccess) {
    std::array<u_long128, 128> storage{};
    mgCMemory                  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    mgCTextureManager textures;
    textures.block_max = 2;
    mgCDrawManager manager;
    manager.texture_manager = &textures;
    manager.SetSortTable(2);
    manager.BeginDraw(&memory, {});
    ASSERT_FALSE(manager.frame_tables.Bytes().empty());
    memory.stReset();
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto original = storage;
    manager.AddPacket(0, nullptr, nullptr, 0);
    manager.ClearTable();
    manager.PreEndDraw();
    EXPECT_EQ(manager.Draw(0, nullptr), 0);
    EXPECT_EQ(manager.ReloadTexture(0, nullptr), 0);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(storage, original);
}

TEST(StrideFix, FrameMutationRejectsHeapStackTransitionsAndFreedTableAddressReuse) {
    std::array<u_long128, 128> storage{};
    mgCMemory                  memory;
    memory.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
    auto *first = memory.StartStackMode(MG_STACK_MODE_FIRST, 0);
    ASSERT_NE(first, nullptr);
    mgCTextureManager textures;
    textures.block_max = 1;
    mgCDrawManager manager;
    manager.texture_manager = &textures;
    manager.SetSortTable(2);
    manager.BeginDraw(&memory, {});
    manager.AddPacket(0, nullptr, nullptr, 0);
    manager.PreEndDraw();
    ASSERT_TRUE(manager.packets_prepared);
    const int first_used = memory.stack_used;
    memory.EndStackMode();
    auto *second = memory.StartStackMode(MG_STACK_MODE_FIRST, 0);
    ASSERT_NE(second, nullptr);
    ASSERT_NE(second, first);
    manager.AddPacket(0, nullptr, nullptr, 0);
    manager.PreEndDraw();
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_TRUE(manager.packets_prepared);
    EXPECT_EQ(manager.packet_num[0], 1);
    memory.Free(second);
    EXPECT_FALSE(manager.frame_tables.Bytes().empty());
    EXPECT_EQ(manager.Draw(0, nullptr), 1);
    memory.Free(first);
    ASSERT_EQ(memory.StartStackMode(MG_STACK_MODE_FIRST, 0), first);
    std::memset(first, 0xA5, static_cast<std::size_t>(first_used) * sizeof(u_long128));
    const auto before = std::vector<u_long128>(first, first + first_used);
    manager.AddPacket(0, nullptr, nullptr, 0);
    manager.PreEndDraw();
    EXPECT_EQ(manager.Draw(0, nullptr), 0);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_TRUE(std::equal(before.begin(), before.end(), first));
}

TEST(StrideFix, SceneClearStackRejectsInvalidStartsAndClampsTheCountToItsPhysicalSlots) {
    std::array<u_long128, 32> first_storage{};
    std::array<u_long128, 32> last_storage{};
    mgCMemory                 first;
    mgCMemory                 last;
    first.stSetBuffer(first_storage.data(), static_cast<int>(first_storage.size()));
    last.stSetBuffer(last_storage.data(), static_cast<int>(last_storage.size()));
    auto scene = std::make_unique<CScene>();
    ASSERT_NE(first.Alloc(1), nullptr);
    ASSERT_NE(last.Alloc(1), nullptr);
    std::ranges::fill(scene->stack, nullptr);
    scene->stack_num = static_cast<int>(std::size(scene->stack));
    scene->stack[0] = &first;
    scene->stack[std::size(scene->stack) - 1] = &last;
    scene->ClearStack(-1);
    scene->ClearStack(scene->stack_num);
    EXPECT_EQ(first.stack_used, 1);
    EXPECT_EQ(last.stack_used, 1);
    scene->stack_num = std::numeric_limits<int>::max();
    scene->ClearStack(0);
    EXPECT_EQ(first.stack_used, 0);
    EXPECT_EQ(last.stack_used, 0);
    EXPECT_EQ(last.stack, nullptr);
    scene->stack_num = static_cast<int>(std::size(scene->stack));
}
