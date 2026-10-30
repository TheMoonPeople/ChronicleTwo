#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <memory>
#include <stdexcept>
#include <vector>

#include "actionchara.hpp"
#include "charasetup.hpp"
#include "editmenu.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "menuchr.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menushop.hpp"
#include "menusys.hpp"
#include "platform/arena.hpp"
#include "platform/game_loop_state.hpp"
#include "savedata.hpp"
#include "snd_mngr.hpp"
#include "stubs/inventmn.hpp"
#include "userdata.hpp"

TEST(MenuMemory, InventoryRejectsMissingShortLockedAndRetiredWorkspacesBeforeAllocation) {
    EXPECT_THROW(MenuItemInit(nullptr, nullptr, 0), std::invalid_argument);
    EXPECT_THROW(MenuItemSelectInit(nullptr, nullptr, 0), std::invalid_argument);
    static char short_key;
    auto       *short_storage = reinterpret_cast<u_long128 *>(ArenaBlock(&short_key, 128 * sizeof(u_long128)));
    mgCMemory   short_memory;
    short_memory.stSetBuffer(short_storage, 128);
    ASSERT_EQ(short_memory.stack_size, 128);
    EXPECT_THROW(MenuItemInit(&short_memory, nullptr, 0), std::length_error);
    EXPECT_EQ(short_memory.stack_used, 0);

    std::array<u_long128, 512> storage{};
    mgCMemory                  owner;
    owner.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    owner.stSetLocked(true);
    EXPECT_THROW(MenuItemInit(&owner, nullptr, 0), std::length_error);
    EXPECT_EQ(owner.stack_used, 0);
    owner.stSetLocked(false);
    mgCMemory borrowed;
    ASSERT_TRUE(borrowed.stShareStack(owner));
    owner.stReset();
    EXPECT_THROW(MenuItemInit(&borrowed, nullptr, 0), std::length_error);
    EXPECT_EQ(borrowed.stack_used, 0);
}

TEST(MenuMemory, ShopControllerRejectsAnExactShortWorkspaceBeforeAllocating) {
    mgCMemory memory;
    auto     *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&memory, 4 * sizeof(u_long128)));
    memory.stSetBuffer(storage, 4);
    EXPECT_THROW(MenuShopInit(&memory, nullptr, 0), std::length_error);
    EXPECT_EQ(memory.stGetUsed(), 0);
}

TEST(MenuMemory, ShopAndQuestMenusRejectAbsentWorkspaces) {
    EXPECT_THROW(MenuShopInit(nullptr, nullptr, 0), std::invalid_argument);
    EXPECT_THROW(MenuNPCQuestViewInit(nullptr, nullptr, 0), std::invalid_argument);
}

TEST(MenuMemory, ShopObjectsInitializePreviouslyPoisonedStorage) {
    constexpr auto bytes = sizeof(CShop) + sizeof(CShopMenu) + 4 * sizeof(u_long128);
    constexpr auto quads = (bytes + sizeof(u_long128) - 1) / sizeof(u_long128);
    mgCMemory      memory;
    auto          *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&memory, quads * sizeof(u_long128)));
    memory.stSetBuffer(storage, static_cast<int>(quads));
    std::memset(storage, 0xA5, quads * sizeof(u_long128));

    const auto *shop = dc2::memory::NewObject<CShop>(memory);
    const auto *menu = dc2::memory::NewObject<CShopMenu>(memory);
    ASSERT_NE(shop, nullptr);
    ASSERT_NE(menu, nullptr);
    EXPECT_EQ(shop->shop_id, 0);
    EXPECT_EQ(shop->item_num, 0);
    for (const auto &price : shop->price) {
        EXPECT_EQ(price.buy, 0);
        EXPECT_EQ(price.sell, 0);
    }
    EXPECT_EQ(menu->scrl_bar_step, 0.0f);
    EXPECT_EQ(menu->bgm_status.state, 0);
    EXPECT_EQ(menu->bgm_status.master_volf, 0.0f);
    EXPECT_EQ(menu->error, -1);
    EXPECT_EQ(menu->cursor_reset, 1);
}

TEST(MenuMemory, TailEndsAtParentBoundaryAfterAlignment) {
    constexpr int capacity = 0x20000;
    static char   key;
    auto         *base = reinterpret_cast<u_long128 *>(ArenaBlock(&key, (capacity + 4) * sizeof(u_long128)));
    for (int character : {USER_CHARA_MAX, USER_CHARA_MONICA, USER_CHARA_ROBO, USER_CHARA_MONSTER}) {
        for (int offset = 0; offset < 4; ++offset) {
            for (int used = 0; used < 4; ++used) {
                SCOPED_TRACE(testing::Message() << character << ":" << offset << ":" << used);
                mgCMemory parent;
                parent.stSetBuffer(base, capacity + 4);
                auto *allocation = parent.Alloc(capacity + 3);
                ASSERT_NE(allocation, nullptr);
                mgCMemory pool;
                mgCMemory tail;
                mgCMemory buffers[MENU_CHARA_LOAD_MAX];
                pool.stSetChildBuffer(parent, allocation + offset, capacity);
                if (used > 0) {
                    ASSERT_NE(pool.Alloc(used), nullptr);
                }
                MenuMemoryAdjust(&pool, &tail, buffers, character);
                EXPECT_EQ(tail.stack + tail.stack_size, pool.stack + pool.stack_size);
                EXPECT_EQ(tail.stack_used, 0);
                EXPECT_EQ(tail.lock, 0);
                EXPECT_EQ(reinterpret_cast<std::uintptr_t>(buffers[0].stack) % 64, 0u);
                EXPECT_GE(tail.stack, pool.stack + used);
                EXPECT_LE(tail.stack, pool.stack + pool.stack_size);
                if (character == USER_CHARA_ROBO) {
                    EXPECT_EQ(buffers[5].stGetTop(), nullptr);
                    EXPECT_EQ(buffers[6].stGetTop(), nullptr);
                }
            }
        }
    }
}

TEST(MenuMemory, DestroyingAnOwnedMonsterBookRevokesItsModelWorkspace) {
    std::array<u_long128, 64> storage{};
    mgCMemory                 parent;
    parent.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *allocation = parent.Alloc(4);
    ASSERT_NE(allocation, nullptr);
    auto book = std::make_unique<CMosBookMenu>();
    book->stack.stSetChildBuffer(parent, allocation, 4);
    const auto lease = dc2::memory::ArenaBuffer::Bind(book->stack, dc2::memory::RemainingBytes(book->stack), &parent);
    ASSERT_EQ(lease.Bytes().size(), 4 * sizeof(u_long128));
    book.reset();
    EXPECT_TRUE(lease.Bytes().empty());
    dc2::menu::ResetMonsterBook();
    dc2::menu::ResetMonsterBook();
    EXPECT_EQ(MonsterBookKey(), 0);
    MonsterBookDraw();
}

TEST(MenuMemory, ExhaustedMonsterBookDoesNotPublishAPartialMenu) {
    std::array<u_long128, 1> storage{};
    mgCMemory                memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    std::array<int, 4> blocks{};
    MonsterBookInit(&memory, blocks.data(), 0);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(MonsterBookKey(), 0);
    MonsterBookDraw();
}

TEST(MenuMemory, OwnedGeoramaControllersRetireTheirMemberArenasOnReplacementAndForcedExit) {
    static char root_key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&root_key, 0x4000 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(storage, 0x4000);

    struct Cleanup {
        ~Cleanup() { dc2::menu::ResetGeoramaMenus(); }
    } cleanup;

    auto *georama = dc2::menu::CreateGeoramaController(memory);
    ASSERT_NE(georama, nullptr);
    auto part_storage = dc2::memory::ArenaBuffer::Bind(georama->parts_stack,
                                                       dc2::memory::RemainingBytes(georama->parts_stack), &memory);
    ASSERT_EQ(part_storage.Bytes().size(), 0x2580 * sizeof(u_long128));

    auto *removal = dc2::menu::CreateRemovalController(memory);
    ASSERT_NE(removal, nullptr);
    EXPECT_TRUE(part_storage.Bytes().empty());
    auto form_storage = dc2::memory::ArenaBuffer::Bind(removal->data_stack,
                                                       dc2::memory::RemainingBytes(removal->data_stack), &memory);
    ASSERT_EQ(form_storage.Bytes().size(), 0x1180 * sizeof(u_long128));
    EXPECT_EQ(dc2::menu::CreateGeoramaController(memory), nullptr);
    EXPECT_FALSE(form_storage.Bytes().empty());
    dc2::menu::ResetGeoramaMenus();
    EXPECT_TRUE(form_storage.Bytes().empty());
    dc2::menu::ResetGeoramaMenus();
    EXPECT_EQ(MenuGeoramaKey(), 1);
    EXPECT_EQ(MenuRemovalKey(), 1);
}

TEST(MenuMemory, GeoramaControllersRejectTinyAndLockedWorkspacesWithoutPublishingThem) {
    static char root_key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&root_key, 4 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(storage, 4);
    dc2::menu::ResetGeoramaMenus();
    EXPECT_EQ(dc2::menu::CreateGeoramaController(memory), nullptr);
    EXPECT_EQ(dc2::menu::CreateRemovalController(memory), nullptr);
    EXPECT_EQ(memory.stGetUsed(), 0);
    memory.stSetLocked(true);
    EXPECT_EQ(dc2::menu::CreateGeoramaController(memory), nullptr);
    EXPECT_EQ(dc2::menu::CreateRemovalController(memory), nullptr);
    EXPECT_EQ(memory.stGetUsed(), 0);
    EXPECT_EQ(MenuGeoramaInit(nullptr, 0), 1);
    MenuRemovalInit(nullptr, nullptr);
    EXPECT_EQ(MenuGeoramaKey(), 1);
    EXPECT_EQ(MenuRemovalKey(), 1);
}

TEST(MenuMemory, OwnedInventionControllerRetiresItsMemberArenasOnReplacementAndForcedExit) {
    struct Cleanup {
        ~Cleanup() { dc2::menu::ResetInventionMenu(); }
    } cleanup;

    auto &first = dc2::menu::CreateInventionMenu();
    auto *root = reinterpret_cast<u_long128 *>(ArenaBlock(&first.data_stack, 8 * sizeof(u_long128)));
    first.data_stack.stSetBuffer(root, 8);
    auto *allocation = first.data_stack.Alloc(2);
    ASSERT_NE(allocation, nullptr);
    auto previous = dc2::memory::ArenaBuffer::Bind(first.data_stack, std::span(reinterpret_cast<u8 *>(allocation), 2 * sizeof(u_long128)));
    ASSERT_FALSE(previous.Bytes().empty());
    auto &replacement = dc2::menu::CreateInventionMenu();
    EXPECT_EQ(CMenuInventPt, &replacement);
    EXPECT_TRUE(previous.Bytes().empty());
    root = reinterpret_cast<u_long128 *>(ArenaBlock(&replacement.data_stack, 8 * sizeof(u_long128)));
    replacement.data_stack.stSetBuffer(root, 8);
    allocation = replacement.data_stack.Alloc(2);
    ASSERT_NE(allocation, nullptr);
    auto current = dc2::memory::ArenaBuffer::Bind(replacement.data_stack, std::span(reinterpret_cast<u8 *>(allocation), 2 * sizeof(u_long128)));
    ASSERT_FALSE(current.Bytes().empty());
    dc2::menu::ResetInventionMenu();
    EXPECT_EQ(CMenuInventPt, nullptr);
    EXPECT_TRUE(current.Bytes().empty());
    dc2::menu::ResetInventionMenu();
    EXPECT_EQ(MenuInventKey(), 0);
    MenuInventDraw();
}

TEST(MenuMemory, InventoryObjectsRejectAbsentShortLockedAndRetiredWorkspacesBeforePublishing) {
    CMenuItemInfo menu;
    EXPECT_THROW(menu.MenuModeMalloc(nullptr), std::invalid_argument);
    std::array<u_long128, 4> short_storage{};
    mgCMemory                short_memory;
    short_memory.stSetBuffer(short_storage.data(), static_cast<int>(short_storage.size()));
    EXPECT_THROW(menu.MenuModeMalloc(&short_memory), std::length_error);
    EXPECT_EQ(short_memory.stGetUsed(), 0);

    std::vector<u_long128> storage(0x4000);
    mgCMemory              owner;
    owner.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    owner.stSetLocked(true);
    EXPECT_THROW(menu.MenuModeMalloc(&owner), std::length_error);
    EXPECT_EQ(owner.stGetUsed(), 0);
    owner.stSetLocked(false);
    mgCMemory borrowed;
    ASSERT_TRUE(borrowed.stShareStack(owner));
    owner.stReset();
    EXPECT_THROW(menu.MenuModeMalloc(&borrowed), std::length_error);
    EXPECT_EQ(borrowed.stGetUsed(), 0);
}

TEST(MenuMemory, InventoryRepairReplacementAndExitRetirementRevokeEveryMemberWorkspace) {
    struct Cleanup {
        ~Cleanup() { dc2::menu::ResetInventoryRepairManager(); }
    } cleanup;

    std::array<u_long128, 64> storage{};
    mgCMemory                 owner;
    owner.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *allocation = owner.Alloc(40);
    ASSERT_NE(allocation, nullptr);
    const auto workspace = std::span(allocation, 40);
    auto      &first = dc2::menu::CreateInventoryRepairManager();
    EXPECT_EQ(MenuRepairMan, &first);
    EXPECT_EQ(first.bg_load, 0);
    EXPECT_EQ(first.data_ready, 0);
    std::array<dc2::memory::ArenaBuffer, 9> leases;
    for (std::size_t index = 0; index < std::size(first.effect_stack); ++index) {
        auto &effect = first.effect_stack[index];
        ASSERT_TRUE(effect.stShareBuffer(owner, workspace.subspan(index * 4, 4)));
        leases[index] = dc2::memory::ArenaBuffer::Bind(effect, dc2::memory::RemainingBytes(effect), &owner);
        ASSERT_EQ(leases[index].Bytes().size(), 4 * sizeof(u_long128));
    }
    ASSERT_TRUE(first.model_stack.stShareBuffer(owner, workspace.subspan(32, 4)));
    leases.back() = dc2::memory::ArenaBuffer::Bind(first.model_stack, dc2::memory::RemainingBytes(first.model_stack), &owner);
    ASSERT_EQ(leases.back().Bytes().size(), 4 * sizeof(u_long128));

    auto &replacement = dc2::menu::CreateInventoryRepairManager();
    EXPECT_EQ(MenuRepairMan, &replacement);
    for (const auto &lease : leases) {
        EXPECT_TRUE(lease.Bytes().empty());
    }
    ASSERT_TRUE(replacement.model_stack.stShareBuffer(owner, workspace.first(4)));
    const auto replacement_lease = dc2::memory::ArenaBuffer::Bind(replacement.model_stack, dc2::memory::RemainingBytes(replacement.model_stack), &owner);
    ASSERT_FALSE(replacement_lease.Bytes().empty());
    dc2::menu::ResetInventoryRepairManager();
    EXPECT_EQ(MenuRepairMan, nullptr);
    EXPECT_TRUE(replacement_lease.Bytes().empty());
    dc2::menu::ResetInventoryRepairManager();
}

TEST(MenuMemory, BuildUpStreaksRejectInvalidCountsLockedAndStrictEndStorageWithoutWriting) {
    struct Cleanup {
        ~Cleanup() { InitBuildUpInfoEffect(nullptr, nullptr, 0, 0.0f); }
    } cleanup;

    constexpr auto blocks = dc2::memory::ArrayQuadwords<CEffVerticalLine>(2).value_or(0);
    static_assert(blocks > 0);
    mgCMemory owner;
    auto     *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&owner, (blocks + 1) * sizeof(u_long128)));
    owner.stSetBuffer(storage, blocks + 1);
    mgCMemory memory;
    ASSERT_TRUE(memory.stShareBuffer(owner, std::span(storage, blocks)));
    ASSERT_EQ(memory.stack_size, blocks);
    const auto           *bytes = reinterpret_cast<const u8 *>(storage);
    const std::vector<u8> original(bytes, bytes + (blocks + 1) * sizeof(u_long128));
    for (int count : {0, -1, std::numeric_limits<int>::max(), 2}) {
        InitBuildUpInfoEffect(&memory, nullptr, count, 20.0f);
        EXPECT_EQ(memory.stGetUsed(), 0);
        EXPECT_EQ(std::memcmp(storage, original.data(), original.size()), 0);
        StepBuildUpInfoEffect();
    }
    ASSERT_TRUE(memory.stShareBuffer(owner, std::span(storage, blocks + 1)));
    memory.stSetLocked(true);
    InitBuildUpInfoEffect(&memory, nullptr, 2, 20.0f);
    EXPECT_EQ(memory.stGetUsed(), 0);
    EXPECT_EQ(std::memcmp(storage, original.data(), original.size()), 0);
    memory.stSetLocked(false);
    InitBuildUpInfoEffect(&memory, nullptr, 2, 20.0f);
    EXPECT_EQ(memory.stGetUsed(), blocks);
    const std::vector<u8> generated(bytes, bytes + original.size());
    memory.stSetLocked(true);
    InitBuildUpInfoEffect(&memory, nullptr, 2, 20.0f);
    EXPECT_EQ(memory.stGetUsed(), blocks);
    owner.stReset();
    StepBuildUpInfoEffect();
    EXPECT_EQ(std::memcmp(storage, generated.data(), generated.size()), 0);
}

TEST(MenuMemory, InventoryObjectsConstructInSharedOwnerTailsAndRetireWithTheirOwner) {
    ASSERT_EXIT(
        {
            std::vector<u_long128> storage(0x4000);
            mgCMemory              owner;
            owner.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
            ASSERT_NE(owner.Alloc(3), nullptr);
            const int          original_used = owner.stGetUsed();
            CMenuPosDataManage layout{};
            MenuPosData = &layout;
            CMenuItemInfo menu;
            menu.MenuModeMalloc(&owner);
            EXPECT_EQ(owner.stGetUsed(), original_used);
            EXPECT_EQ(MenuItemMemory2.stack, owner.stack + original_used);
            EXPECT_EQ(MenuItemMemory2.stack + MenuItemMemory2.stack_size, owner.stack + owner.stack_size);
            EXPECT_EQ(MenuItemMemory.stack + MenuItemMemory.stack_size, owner.stack + owner.stack_size);
            for (auto *character : MenuActionChara) {
                ASSERT_NE(character, nullptr);
                EXPECT_GE(dc2::memory::AllocationBytes(MenuItemMemory2, character).size(), sizeof(CActionChara));
            }
            ASSERT_NE(MenuMoveItemPtr, nullptr);
            EXPECT_GE(dc2::memory::AllocationBytes(MenuItemMemory2, MenuMoveItemPtr).size(), sizeof(CMenuMoveItem));
            for (auto *effect : std::span(MenuEffect, 2)) {
                ASSERT_NE(effect, nullptr);
                EXPECT_GE(dc2::memory::AllocationBytes(MenuItemMemory2, effect).size(), sizeof(CMenuEffect));
                EXPECT_EQ(effect->run, 0);
            }
            ASSERT_NE(MenuRepairMan, nullptr);
            ASSERT_TRUE(dc2::memory::ArenaStorageLive(MenuItemMemory));
            dc2::menu::ResetInventoryRepairManager();
            InitBuildUpInfoEffect(nullptr, nullptr, 0, 0.0f);
            owner.stReset();
            EXPECT_FALSE(dc2::memory::ArenaStorageLive(MenuItemMemory));
            EXPECT_TRUE(dc2::memory::RemainingBytes(MenuItemMemory2).empty());
            EXPECT_TRUE(dc2::memory::RemainingBytes(MenuItemMemory).empty());
            std::_Exit(testing::Test::HasFailure() ? 1 : 0);
        },
        testing::ExitedWithCode(0), "");
}

TEST(MenuMemory, ForcedMenuExitRetiresTheInventoryRepairModelWorkspace) {
    ASSERT_EXIT(
        {
            auto save = std::make_unique<CSaveData>();
            PortActiveSaveData = save.get();
            MenuUserDataManPtr = &save->user_data;
            MenuUserDataManPtr->active_chr_no = USER_CHARA_MONICA;
            CMenuKeyFunc common{};
            common.user_data = MenuUserDataManPtr;
            common.tex_block[0] = -1;
            MenuCommonInfo = &common;
            CMenuPosDataManage layout{};
            MenuPosData = &layout;
            MENU_DRAW_ENV draw{};
            MenuDrawEnv = &draw;
            MenuMainScene = nullptr;
            MenuSePlayUsedFlag = 0;
            GetMainScene()->active_camera = -1;
            std::vector<u_long128> storage(16);
            mgCMemory              owner;
            owner.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
            auto *allocation = owner.Alloc(4);
            ASSERT_NE(allocation, nullptr);
            auto &repair = dc2::menu::CreateInventoryRepairManager();
            ASSERT_TRUE(repair.model_stack.stShareBuffer(owner, std::span(allocation, 4)));
            const auto lease = dc2::memory::ArenaBuffer::Bind(repair.model_stack, dc2::memory::RemainingBytes(repair.model_stack), &owner);
            ASSERT_FALSE(lease.Bytes().empty());
            EXPECT_EQ(MenuMainExit(), 1);
            EXPECT_EQ(MenuRepairMan, nullptr);
            EXPECT_TRUE(lease.Bytes().empty());
            std::_Exit(testing::Test::HasFailure() ? 1 : 0);
        },
        testing::ExitedWithCode(0), "");
}

TEST(MenuMemory, UnitPreviewRetainsOnlyTheExplicitPersistentLoopSoundOwner) {
    auto character = std::make_unique<CActionChara>();
    auto user_data = std::make_unique<CUserDataManager>();
    auto sounds = std::make_unique<CLoopSeMngr>();
    {
        std::array<CCharacter2 *, 1> parts{character.get()};
        dc2::character::SetupUnit(parts, user_data.get(), USER_CHARA_MONSTER, nullptr, sounds.get());
    }
    ASSERT_EQ(character->sound_info.loop_se, sounds.get());
    character->sound_info.loop_se->Clear();
    std::array<CCharacter2 *, 1> parts{character.get()};
    dc2::character::SetupUnit(parts, user_data.get(), USER_CHARA_MONSTER, nullptr, nullptr);
    EXPECT_EQ(character->sound_info.loop_se, nullptr);
    dc2::character::SetupUnit({}, user_data.get(), USER_CHARA_MONSTER, nullptr, sounds.get());
    EXPECT_EQ(character->sound_info.loop_se, nullptr);
}

TEST(MenuMemory, EffectsConstructAndResetEveryFieldInPoisonedStorage) {
    constexpr auto quadwords = (sizeof(CMenuEffect) + sizeof(u_long128) - 1) / sizeof(u_long128);
    mgCMemory      memory;
    auto          *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&memory, (quadwords + 1) * sizeof(u_long128)));
    memory.stSetBuffer(storage, static_cast<int>(quadwords + 1));
    std::memset(storage, 0xA5, (quadwords + 1) * sizeof(u_long128));
    auto *effect = dc2::memory::NewObject<CMenuEffect>(memory);
    ASSERT_NE(effect, nullptr);
    for (int iteration = 0; iteration < 2; ++iteration) {
        EXPECT_EQ(effect->tex_block, 0);
        EXPECT_EQ(effect->tex, nullptr);
        EXPECT_EQ(effect->end, 0);
        EXPECT_EQ(effect->type, MENU_EFFECT_TYPE_NONE);
        EXPECT_EQ(effect->run, 0);
        EXPECT_EQ(effect->info_num, 0);
        EXPECT_EQ(effect->info, nullptr);
        for (const auto value : effect->base_info) {
            EXPECT_EQ(value, 0);
        }
        EXPECT_EQ(effect->alpha, 128);
        EXPECT_EQ(effect->counter, 0);
        effect->end = 1;
        effect->counter = 12;
        effect->base_info[15] = 99;
        effect->Initialize();
    }
    const auto used = memory.stGetUsed();
    EXPECT_EQ(dc2::memory::NewObject<CMenuEffect>(memory), nullptr);
    EXPECT_EQ(memory.stGetUsed(), used);
}
