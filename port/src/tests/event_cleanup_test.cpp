#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <memory>

#include "dng_main.hpp"
#include "editmap.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "mg_memory.hpp"
#include "native_script_program.hpp"
#include "platform/arena.hpp"
#include "platform/game_loop_state.hpp"
#include "runscript.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"
#include "scoped_global_object.hpp"
#include "stubs/event.hpp"

namespace {
struct CleanupProgram {
    RS_PROG_HEADER header{};
    RS_PROGDATA    entry{.no = 100, .func = offsetof(CleanupProgram, function)};
    funcdata       function{};
    vmcode_t       code[3]{
        {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = EVENT_EXT_DNG_EFFECT_ALL_CLEAR},
        {.op = RS_OP_EXT,        .arg1 = 1,            .arg2 = 0                             },
        {.op = RS_OP_END,        .arg1 = 0,            .arg2 = 0                             }
    };

    CleanupProgram() {
        std::memcpy(header.magic, "SB2", 3);
        header.main = offsetof(CleanupProgram, function);
        header.code = offsetof(CleanupProgram, code);
        header.prog = offsetof(CleanupProgram, entry);
        header.prog_num = 1;
    }
};

class EventCleanup : public testing::Test {
protected:
    void SetUp() override {
        previous_mode = PortLoopNo;
        previous_effects = FxScriptMan;
        memory.stSetBuffer(storage, 1024);
        MachineGun.active[0] = 1;
        MachineGun.col_prim_id[0] = 42;
        MachineGun.index = 3;
    }

    void TearDown() override {
        SetEventScript({}, nullptr);
        FxScriptMan = previous_effects;
        PortLoopNo = previous_mode;
    }

    void RunCleanup() {
        SetEventScript(ProgramBytes(program), &memory);
        EXPECT_EQ(RunEvent(100, nullptr), 0);
        EXPECT_EQ(MachineGun.active[0], 0);
        EXPECT_EQ(MachineGun.col_prim_id[0], -1);
        EXPECT_EQ(MachineGun.index, 0);
    }

    int               previous_mode = 0;
    CEffectScriptMan *previous_effects = nullptr;
    alignas(64) u_long128 storage[1024]{};
    mgCMemory      memory;
    CleanupProgram program;
};
} // namespace

TEST_F(EventCleanup, TownClearWithNoDungeonManagerStillClearsGuns) {
    PortLoopNo = LOOP_EDIT;
    FxScriptMan = nullptr;
    RunCleanup();
}

TEST_F(EventCleanup, TownClearDoesNotUseAStaleDungeonManager) {
    PortLoopNo = LOOP_EDIT;
    FxScriptMan = reinterpret_cast<CEffectScriptMan *>(static_cast<std::uintptr_t>(0x123));
    RunCleanup();
}

TEST_F(EventCleanup, DungeonClearFreesItsLiveEffects) {
    PortLoopNo = LOOP_DUNGEON;
    static char key;
    auto       *buffer = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 4096 * sizeof(u_long128)));
    mgCMemory   work;
    work.SetHeapMem(buffer, 4096);
    NativeScriptProgram effect_program;
    EFF_SPT_BASE        base{};
    base.base_no = 7;
    base.work_size = 161;
    base.script = reinterpret_cast<char *>(&effect_program);
    base.script_size = sizeof effect_program;
    dc2::test::ScopedGlobalObject<FxScriptMan> effects_owner;
    auto                                      &effects = effects_owner.Get();
    effects.SetWorkBuffer(&work);
    effects.base[0] = &base;
    effects.base_num = 1;
    ASSERT_NE(effects.CreateEffSpt(7, 0, 1), nullptr);
    RunCleanup();
    EXPECT_EQ(effects.head, nullptr);
    EXPECT_EQ(effects.tail, nullptr);
    EXPECT_EQ(effects.slot[0][0], nullptr);
}

TEST_F(EventCleanup, SceneBindingsRetainTheSharedCheckedHandlers) {
    CRunScript retail;
    SetEventFunc(&retail);
    SetEventScript(ProgramBytes(program), &memory);
    ASSERT_EQ(EventScript.ext_func_num, retail.ext_func_num);
    for (int i = 0; i < retail.ext_func_num; ++i) {
        if (i == EVENT_EXT_DNG_EFFECT_ALL_CLEAR || i == EVENT_EXT_GET_FISHINGTOURNAMENT_ETC) {
            EXPECT_NE(EventScript.ext_func_table[i], retail.ext_func_table[i]);
        } else {
            EXPECT_EQ(EventScript.ext_func_table[i], retail.ext_func_table[i]) << i;
        }
    }
}

TEST(SceneMapLifetime, ResetAndReplacementReleaseOnlyOwnedControllers) {
    std::array<u_long128, 64> storage{};
    auto                      owned = std::make_unique<CEditMap>();
    owned->parts_heap.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *allocation = owned->parts_heap.Alloc(1);
    ASSERT_NE(allocation, nullptr);
    const auto lease = dc2::memory::ArenaBuffer::Bind(owned->parts_heap, {reinterpret_cast<u8 *>(allocation), sizeof(u_long128)});
    CSceneMap  slot;
    char       name[] = "owned map";
    auto      *address = owned.get();
    ASSERT_TRUE(slot.AssignData(address, name));
    ASSERT_TRUE(slot.OwnEditMap(std::move(owned)));
    ASSERT_TRUE(slot.AssignData(address, name));
    ASSERT_FALSE(lease.Bytes().empty());
    CEditMap borrowed;
    ASSERT_TRUE(slot.AssignData(&borrowed, name));
    EXPECT_TRUE(lease.Bytes().empty());
    borrowed.parts_heap.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    allocation = borrowed.parts_heap.Alloc(1);
    ASSERT_NE(allocation, nullptr);
    const auto borrowed_lease = dc2::memory::ArenaBuffer::Bind(borrowed.parts_heap, {reinterpret_cast<u8 *>(allocation), sizeof(u_long128)});
    slot.Initialize();
    EXPECT_FALSE(borrowed_lease.Bytes().empty());
    EXPECT_EQ(slot.map, nullptr);
}

TEST(SceneMapLifetime, DeleteSharedMapOwnersBeforeResettingTheirParentArena) {
    std::array<u_long128, 256> storage{};
    mgCMemory                  parent;
    parent.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto                                    scene = std::make_unique<CScene>();
    std::array<dc2::memory::ArenaBuffer, 2> leases;
    char                                    name[] = "map";
    for (int index = 0; index < 2; ++index) {
        auto  owned = std::make_unique<CEditMap>();
        auto *backing = parent.Alloc(16);
        ASSERT_NE(backing, nullptr);
        owned->parts_heap.stSetChildBuffer(parent, backing, 16);
        auto *allocation = owned->parts_heap.Alloc(1);
        ASSERT_NE(allocation, nullptr);
        leases[static_cast<std::size_t>(index)] = dc2::memory::ArenaBuffer::Bind(owned->parts_heap, {reinterpret_cast<u8 *>(allocation), sizeof(u_long128)});
        auto *slot = scene->GetSceneMap(scene->AssignMap(index, owned.get(), name));
        ASSERT_NE(slot, nullptr);
        ASSERT_TRUE(slot->OwnEditMap(std::move(owned)));
        slot->stack = &parent;
    }
    EXPECT_EQ(scene->DeleteMap(0, 0), 1);
    EXPECT_TRUE(leases[0].Bytes().empty());
    EXPECT_FALSE(leases[1].Bytes().empty());
    EXPECT_GT(parent.stack_used, 0);
    EXPECT_EQ(scene->DeleteMap(1, 1), 1);
    EXPECT_TRUE(leases[1].Bytes().empty());
    EXPECT_EQ(parent.stack_used, 0);
}

TEST(SceneMapLifetime, MovesTransferOwnershipAndLeaveEverySourceSlotEmpty) {
    std::array<u_long128, 64> storage{};
    auto                      owned = std::make_unique<CEditMap>();
    owned->parts_heap.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *allocation = owned->parts_heap.Alloc(1);
    ASSERT_NE(allocation, nullptr);
    const auto lease = dc2::memory::ArenaBuffer::Bind(owned->parts_heap, {reinterpret_cast<u8 *>(allocation), sizeof(u_long128)});
    CSceneMap  source;
    char       name[] = "owned";
    ASSERT_TRUE(source.AssignData(owned.get(), name));
    ASSERT_TRUE(source.OwnEditMap(std::move(owned)));
    CSceneMap moved(std::move(source));
    EXPECT_EQ(source.map, nullptr);
    EXPECT_EQ(source.status, 0);
    ASSERT_FALSE(lease.Bytes().empty());
    CSceneMap destination;
    destination = std::move(moved);
    EXPECT_EQ(moved.map, nullptr);
    EXPECT_EQ(moved.status, 0);
    ASSERT_FALSE(lease.Bytes().empty());
    destination.Initialize();
    EXPECT_TRUE(lease.Bytes().empty());
}

TEST(SceneResourceLifetime, CharacterObjectsAreRejectedBeforeReadingResetAndReusedStorage) {
    static char    key;
    constexpr auto words = dc2::memory::ArrayQuadwords<CCharacter2>(1).value() + 16;
    mgCMemory      memory;
    memory.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&key, words * sizeof(u_long128))), static_cast<int>(words));
    auto *actor = dc2::memory::NewObject<CCharacter2>(memory);
    ASSERT_NE(actor, nullptr);
    auto scene = std::make_unique<CScene>();
    ASSERT_EQ(scene->AssignChara(0, dc2::scene::CharacterResource::FromArena(memory, *actor)), 0);
    ASSERT_EQ(scene->GetCharacter(0), actor);
    memory.stReset();
    auto *reused = memory.Alloc(static_cast<int>(dc2::memory::ArrayQuadwords<CCharacter2>(1).value()));
    ASSERT_EQ(static_cast<void *>(reused), static_cast<void *>(actor));
    std::memset(reused, 0xA5, sizeof(CCharacter2));
    EXPECT_EQ(scene->GetCharacter(0), nullptr);
    EXPECT_EQ(scene->chara[0].status, 0);
}

TEST(SceneResourceLifetime, ClearStackRetiresOnlyCharactersDependingOnTheActualChild) {
    static char    key;
    constexpr auto actor_words = dc2::memory::ArrayQuadwords<CCharacter2>(1).value();
    constexpr auto words = actor_words * 2 + 32;
    mgCMemory      parent;
    parent.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&key, words * sizeof(u_long128))), static_cast<int>(words));
    auto *outer = dc2::memory::NewObject<CCharacter2>(parent);
    auto *child_storage = parent.Alloc(static_cast<int>(actor_words + 8));
    ASSERT_NE(outer, nullptr);
    ASSERT_NE(child_storage, nullptr);
    mgCMemory child;
    child.stSetChildBuffer(parent, child_storage, static_cast<int>(actor_words + 8));
    auto *inner = dc2::memory::NewObject<CCharacter2>(child);
    ASSERT_NE(inner, nullptr);
    auto scene = std::make_unique<CScene>();
    ASSERT_EQ(scene->AssignChara(0, dc2::scene::CharacterResource::FromArena(parent, *outer)), 0);
    ASSERT_EQ(scene->AssignChara(1, dc2::scene::CharacterResource::FromArena(child, *inner)), 1);
    scene->stack_num = 1;
    scene->stack[0] = &child;
    scene->chara[1].status = 0;
    scene->ClearStack(0);
    EXPECT_EQ(scene->GetCharacter(0), outer);
    EXPECT_EQ(scene->GetCharacter(1), nullptr);
    EXPECT_EQ(scene->chara[1].status, 0);
    EXPECT_FALSE(scene->chara[1].character.HasValue());
    parent.stReset();
    EXPECT_EQ(scene->GetCharacter(0), nullptr);
}

TEST(SceneResourceLifetime, CharacterCopiesKeepModelProducersWithoutRetainingTheSourceObject) {
    static char    actor_key;
    static char    model_key;
    static char    copy_key;
    constexpr auto actor_words = dc2::memory::ArrayQuadwords<CCharacter2>(1).value() + 16;
    constexpr auto model_words = dc2::memory::ArrayQuadwords<mgCFrame>(1).value() + 16;
    mgCMemory      actors;
    actors.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&actor_key, actor_words * sizeof(u_long128))), actor_words);
    mgCMemory models;
    models.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&model_key, model_words * sizeof(u_long128))), model_words);
    mgCMemory      copies;
    constexpr auto copy_words = actor_words + model_words + 128;
    copies.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&copy_key, copy_words * sizeof(u_long128))), copy_words);
    auto *source = dc2::memory::NewObject<CCharacter2>(actors);
    auto *model = dc2::memory::NewObject<mgCFrame>(models);
    auto *copy = dc2::memory::NewObject<CCharacter2>(copies);
    ASSERT_NE(source, nullptr);
    ASSERT_NE(model, nullptr);
    ASSERT_NE(copy, nullptr);
    source->CObjectFrame::frame = model;
    source->shadow_frame = model;
    ASSERT_TRUE(dc2::character::CaptureModelResources(*source, models));
    source->Copy(*copy, &copies);
    ASSERT_EQ(copy->shadow_frame, model);
    auto scene = std::make_unique<CScene>();
    ASSERT_EQ(scene->AssignChara(0, dc2::scene::CharacterResource::FromArena(copies, *copy)), 0);
    actors.stReset();
    auto *poison = actors.Alloc(static_cast<int>(dc2::memory::ArrayQuadwords<CCharacter2>(1).value()));
    ASSERT_EQ(static_cast<void *>(poison), static_cast<void *>(source));
    std::memset(poison, 0xA5, sizeof(CCharacter2));
    EXPECT_EQ(scene->GetCharacter(0), copy);
    EXPECT_EQ(copy->shadow_frame, model);
    scene->stack_num = 1;
    scene->stack[0] = &models;
    scene->ClearStack(0);
    EXPECT_EQ(scene->GetCharacter(0), nullptr);
    EXPECT_EQ(scene->chara[0].status, 0);
}

TEST(SceneResourceLifetime, OwnedMapsCaptureConsumedCatalogProducersBeforeTheirReset) {
    static char model_key;
    mgCMemory   models;
    models.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&model_key, 256 * sizeof(u_long128))), 256);
    auto *entry = dc2::memory::NewObject<CMdsInfo>(models);
    ASSERT_NE(entry, nullptr);
    char part_name[] = "part";
    entry->name = mgCopyString(part_name, &models);
    ASSERT_NE(entry->name, nullptr);
    entry->resource_lifetime = dc2::memory::ArenaLifetime::Capture(models);
    auto  scene = std::make_unique<CScene>();
    auto &list = scene->mds_list_set.mds_list[0];
    list.list = entry;
    list.num = 1;
    list.resource_lifetime = entry->resource_lifetime;
    auto map = std::make_unique<CEditMap>();
    map->mds_list_set = &scene->mds_list_set;
    char  name[] = "partial";
    auto *slot = scene->GetSceneMap(scene->AssignMap(0, map.get(), name));
    ASSERT_NE(slot, nullptr);
    ASSERT_TRUE(slot->OwnEditMap(std::move(map)));
    ASSERT_EQ(slot->map->SearchMDS(entry->name), entry);
    EXPECT_EQ(slot->map->resource_dependencies->size(), 1);
    ASSERT_EQ(slot->map->SearchMDS(entry->name), entry);
    EXPECT_EQ(slot->map->resource_dependencies->size(), 1);
    scene->stack_num = 1;
    scene->stack[0] = &models;
    scene->ClearStack(0);
    EXPECT_EQ(scene->GetMap(0), nullptr);
    EXPECT_EQ(scene->map[0].map, nullptr);
}

TEST(SceneResourceLifetime, PartiallyCreatedMapsAlreadyDependOnTheirProducerStack) {
    static char key;
    mgCMemory   memory;
    memory.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&key, 64 * sizeof(u_long128))), 64);
    auto *input = memory.Alloc(1);
    ASSERT_NE(input, nullptr);
    auto              scene = std::make_unique<CScene>();
    SCN_LOADMAP_INFO2 info;
    info.stack = &memory;
    info.load_buf = reinterpret_cast<u8 *>(input);
    info.data_ready = 1;
    std::memcpy(info.name, "partial", sizeof("partial"));
    ASSERT_EQ(scene->LoadMapFromMemory(0, SCN_LOADMAP_STEP_CREATE, &info), 1);
    ASSERT_NE(scene->GetMap(0), nullptr);
    EXPECT_EQ(scene->map[0].stack, &memory);
    EXPECT_TRUE(scene->map[0].resource_lifetime.IsLive());
    scene->map[0].status = 0;
    scene->stack_num = 1;
    scene->stack[0] = &memory;
    scene->ClearStack(0);
    EXPECT_EQ(scene->GetMap(0), nullptr);
    EXPECT_EQ(scene->map[0].status, 0);
    EXPECT_EQ(scene->map[0].map, nullptr);
}

TEST(SceneResourceLifetime, ClearingAnotherActiveHeapBlockPreservesCompletedCharacters) {
    static char    key;
    constexpr auto actor_words = dc2::memory::ArrayQuadwords<CCharacter2>(1).value();
    constexpr auto words = actor_words + 128;
    mgCMemory      heap;
    heap.SetHeapMem(reinterpret_cast<u_long128 *>(ArenaBlock(&key, words * sizeof(u_long128))), static_cast<int>(words));
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(actor_words + 8)), nullptr);
    auto *actor = dc2::memory::NewObject<CCharacter2>(heap);
    ASSERT_NE(actor, nullptr);
    auto scene = std::make_unique<CScene>();
    ASSERT_EQ(scene->AssignChara(0, dc2::scene::CharacterResource::FromArena(heap, *actor)), 0);
    heap.EndStackMode();
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    ASSERT_NE(heap.Alloc(4), nullptr);
    scene->stack_num = 1;
    scene->stack[0] = &heap;
    scene->ClearStack(0);
    EXPECT_EQ(scene->GetCharacter(0), actor);
    heap.EndStackMode();
    heap.Free(reinterpret_cast<u_long128 *>(actor));
    EXPECT_EQ(scene->GetCharacter(0), nullptr);
}

TEST(SceneResourceLifetime, MapsCheckCharacterChannelsAddedAfterConsumingTheCatalogEntry) {
    static char    model_key;
    static char    sword_key;
    constexpr auto words = dc2::memory::ArrayQuadwords<CCharacter2>(1).value() +
                           dc2::memory::ArrayQuadwords<mgCFrame>(1).value() + 64;
    mgCMemory      models;
    models.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&model_key, words * sizeof(u_long128))), static_cast<int>(words));
    mgCMemory sword;
    sword.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&sword_key, 16 * sizeof(u_long128))), 16);
    ASSERT_NE(sword.Alloc(1), nullptr);
    auto *entry = dc2::memory::NewObject<CMdsInfo>(models);
    auto *actor = dc2::memory::NewObject<CCharacter2>(models);
    auto *frame = dc2::memory::NewObject<mgCFrame>(models);
    ASSERT_NE(entry, nullptr);
    ASSERT_NE(actor, nullptr);
    ASSERT_NE(frame, nullptr);
    actor->CObjectFrame::frame = frame;
    ASSERT_TRUE(dc2::character::CaptureModelResources(*actor, models));
    char part_name[] = "character part";
    entry->name = mgCopyString(part_name, &models);
    entry->chara = actor;
    entry->resource_lifetime = dc2::memory::ArenaLifetime::Capture(models);
    entry->character_storage = dc2::memory::ArenaBuffer::Bind(models, std::span(reinterpret_cast<u8 *>(actor), sizeof(CCharacter2)));
    auto  scene = std::make_unique<CScene>();
    auto &list = scene->mds_list_set.mds_list[0];
    list.list = entry;
    list.num = 1;
    list.resource_lifetime = entry->resource_lifetime;
    auto map = std::make_unique<CEditMap>();
    map->mds_list_set = &scene->mds_list_set;
    char  name[] = "map";
    auto *slot = scene->GetSceneMap(scene->AssignMap(0, map.get(), name));
    ASSERT_NE(slot, nullptr);
    ASSERT_TRUE(slot->OwnEditMap(std::move(map)));
    ASSERT_EQ(slot->map->SearchMDS(part_name), entry);
    ASSERT_TRUE(dc2::character::RetainResource(*actor, dc2::character::ResourceChannel::Sword, 0, sword));
    ASSERT_NE(scene->GetMap(0), nullptr);
    sword.stReset();
    EXPECT_FALSE(entry->character_storage.Bytes().empty());
    EXPECT_EQ(scene->GetMap(0), nullptr);
}
