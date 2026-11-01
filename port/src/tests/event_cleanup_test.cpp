#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <memory>
#include <optional>
#include <string>
#include <type_traits>
#include <vector>

#include "dng_main.hpp"
#include "editmap.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "mapjump.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
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
static_assert(!std::is_copy_constructible_v<CScene>);
static_assert(!std::is_copy_assignable_v<CScene>);
static_assert(!std::is_move_constructible_v<CScene>);
static_assert(!std::is_move_assignable_v<CScene>);

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

TEST(SceneMapLifetime, DeletingJumpMapsClearsTextureAnimationsInTheMapArena) {
    std::vector<u_long128> table_storage(0x1000);
    mgCMemory              tables;
    tables.SetHeapMem(table_storage.data(), table_storage.size());
    tables.StartStackMode(MG_STACK_MODE_FIT, table_storage.size());
    mgTexManager.SetTableBuffer(16, 8, &tables);
    mgTexManager.Initialize(0x1000, -1);
    std::array<u_long128, 256> storage{};
    mgCMemory                  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    mgTexManager.GetTextureBlock(3)->anime = dc2::memory::NewObject<mgCTextureAnime>(memory);
    ASSERT_NE(mgTexManager.GetTexAnime(3), nullptr);

    CMap loaded_map;
    auto scene = std::make_unique<CScene>();
    scene->map_num = 2;
    scene->map[0].AssignData(&loaded_map, const_cast<char *>("map"));
    scene->map[0].stack = &memory;
    scene->map[0].tex_block = 0;
    scene->map[0].tex_block_num = 4;
    MapJumpMapInfo main_map;
    main_map.map_no = 0;
    SetMainMapInfo(&main_map);
    MapJumpMapInfo sub_map;
    sub_map.map_no = 1;
    SetSubMapInfo(&sub_map);

    DeleteJumpMaps(scene.get());

    EXPECT_EQ(mgTexManager.GetTexAnime(3), nullptr);
    EXPECT_EQ(scene->GetMap(0), nullptr);
    EXPECT_EQ(memory.stack_used, 0);
    mgTexManager.Initialize(0x1000, -1);
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

TEST(SceneAssignmentViews, SceneResetAndDestructionRevokeViewsWithoutRevivingOldLifetimes) {
    auto scene = std::make_unique<CScene>();
    EXPECT_EQ(scene->GetCharacterView(-1).Get(), nullptr);
    EXPECT_EQ(scene->GetCharacterView(128).Get(), nullptr);
    EXPECT_EQ(scene->GetCharacterView(0).Get(), nullptr);
    auto actor = std::make_shared<CCharacter2>();
    ASSERT_EQ(scene->AssignChara(0, dc2::scene::CharacterResource::FromOwned(actor)), 0);
    const auto old_scene = scene->GetSceneView();
    const auto old_character = scene->GetCharacterView(0);
    EXPECT_EQ(old_scene.Get(), scene.get());
    EXPECT_EQ(old_character.Get(), actor.get());
    scene->Initialize();
    EXPECT_EQ(old_scene.Get(), nullptr);
    EXPECT_EQ(old_character.Get(), nullptr);
    ASSERT_EQ(scene->AssignChara(0, dc2::scene::CharacterResource::FromOwned(actor)), 0);
    const auto new_scene = scene->GetSceneView();
    const auto new_character = scene->GetCharacterView(0);
    EXPECT_EQ(new_scene.Get(), scene.get());
    EXPECT_EQ(new_character.Get(), actor.get());
    EXPECT_EQ(old_scene.Get(), nullptr);
    EXPECT_EQ(old_character.Get(), nullptr);
    scene.reset();
    EXPECT_EQ(new_scene.Get(), nullptr);
    EXPECT_EQ(new_character.Get(), nullptr);
}

TEST(SceneAssignmentViews, FailedAssignmentPreservesViewsAndSameResourceAssignmentRevokesThem) {
    CSceneCharacter slot;
    auto            actor = std::make_shared<CCharacter2>();
    const auto      resource = dc2::scene::CharacterResource::FromOwned(actor);
    ASSERT_TRUE(slot.AssignData(resource, "first"));
    const auto first = slot.GetCharacterView();
    ASSERT_EQ(first.Get(), actor.get());
    EXPECT_FALSE(slot.AssignData({}, "missing"));
    EXPECT_FALSE(slot.AssignData(resource, std::string(32, 'x')));
    EXPECT_EQ(first.Get(), actor.get());
    ASSERT_TRUE(slot.AssignData(resource, "second"));
    EXPECT_EQ(first.Get(), nullptr);
    const auto second = slot.GetCharacterView();
    EXPECT_EQ(second.Get(), actor.get());
    slot.Initialize();
    EXPECT_EQ(second.Get(), nullptr);
}

TEST(SceneAssignmentViews, CopyAndMoveKeepAssignmentIdentitiesIndependent) {
    auto            actor = std::make_shared<CCharacter2>();
    CSceneCharacter source;
    ASSERT_TRUE(source.AssignData(dc2::scene::CharacterResource::FromOwned(actor), "source"));
    const auto      source_view = source.GetCharacterView();
    CSceneCharacter copy(source);
    const auto      copy_view = copy.GetCharacterView();
    EXPECT_EQ(source_view.Get(), actor.get());
    EXPECT_EQ(copy_view.Get(), actor.get());
    CSceneCharacter destination;
    ASSERT_TRUE(destination.AssignData(dc2::scene::CharacterResource::FromOwned(actor), "destination"));
    const auto previous_destination = destination.GetCharacterView();
    destination = source;
    EXPECT_EQ(previous_destination.Get(), nullptr);
    EXPECT_EQ(source_view.Get(), actor.get());
    const auto      copied_destination = destination.GetCharacterView();
    CSceneCharacter moved(std::move(copy));
    EXPECT_EQ(copy_view.Get(), nullptr);
    EXPECT_EQ(copy.status, 0U);
    const auto moved_view = moved.GetCharacterView();
    EXPECT_EQ(moved_view.Get(), actor.get());
    destination = std::move(moved);
    EXPECT_EQ(copied_destination.Get(), nullptr);
    EXPECT_EQ(moved_view.Get(), nullptr);
    EXPECT_EQ(moved.status, 0U);
    EXPECT_EQ(destination.GetCharacterView().Get(), actor.get());
    EXPECT_EQ(source_view.Get(), actor.get());
}

TEST(SceneAssignmentViews, CharacterSlotDestructionAndInactiveStatusRejectViews) {
    auto actor = std::make_shared<CCharacter2>();
    auto slot = std::make_unique<CSceneCharacter>();
    ASSERT_TRUE(slot->AssignData(dc2::scene::CharacterResource::FromOwned(actor), "actor"));
    const auto view = slot->GetCharacterView();
    slot->status = 0;
    EXPECT_EQ(view.Get(), nullptr);
    EXPECT_EQ(slot->GetCharacterView().Get(), nullptr);
    slot->status = SCENE_DATA_ASSIGNED;
    EXPECT_EQ(view.Get(), actor.get());
    slot.reset();
    EXPECT_EQ(view.Get(), nullptr);
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
    const auto view = scene->GetCharacterView(0);
    ASSERT_EQ(view.Get(), actor);
    ASSERT_EQ(scene->GetCharacter(0), actor);
    memory.stReset();
    auto *reused = memory.Alloc(static_cast<int>(dc2::memory::ArrayQuadwords<CCharacter2>(1).value()));
    ASSERT_EQ(static_cast<void *>(reused), static_cast<void *>(actor));
    std::memset(reused, 0xA5, sizeof(CCharacter2));
    EXPECT_EQ(view.Get(), nullptr);
    EXPECT_NE(scene->chara[0].status, 0U);
    EXPECT_EQ(scene->AssignChara(0, {}), -1);
    EXPECT_TRUE(scene->chara[0].Resource().HasValue());
    EXPECT_NE(scene->chara[0].status, 0U);
    EXPECT_EQ(scene->GetCharacter(0), nullptr);
    EXPECT_EQ(scene->chara[0].status, 0);
}

TEST(SceneResourceLifetime, NativeOwnedCharactersRequireExplicitScopesToBeLive) {
    auto       actor = std::make_shared<CCharacter2>();
    const auto unscoped = dc2::scene::CharacterResource::FromOwned(actor);
    EXPECT_EQ(unscoped.Get(), actor.get());
    EXPECT_EQ(unscoped.Producer(), nullptr);
    EXPECT_FALSE(dc2::scene::CharacterResource::FromOwned(actor, dc2::memory::ArenaLifetime{}).HasValue());
    mgCMemory unbound;
    EXPECT_FALSE(dc2::scene::CharacterResource::FromOwned(actor, dc2::memory::ArenaLifetime::Capture(unbound)).HasValue());
    std::array<u_long128, 16> storage{};
    mgCMemory                 memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    const auto scope = dc2::memory::ArenaLifetime::Capture(memory);
    ASSERT_TRUE(scope.IsLive());
    memory.stReset();
    EXPECT_FALSE(dc2::scene::CharacterResource::FromOwned(actor, scope).HasValue());
    const auto rebound = dc2::scene::CharacterResource::FromOwned(actor, dc2::memory::ArenaLifetime::Capture(memory));
    ASSERT_EQ(rebound.Get(), actor.get());
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    EXPECT_EQ(rebound.Get(), nullptr);
    EXPECT_TRUE(rebound.HasValue());
    EXPECT_EQ(unscoped.Get(), actor.get());
}

TEST(SceneResourceLifetime, LogicalScopeResetRejectsRetainedHeapCharactersAndPredictsOnlyItsProducer) {
    std::array<u_long128, 16> storage{};
    std::array<u_long128, 16> other_storage{};
    mgCMemory                 memory;
    mgCMemory                 other;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    other.stSetBuffer(other_storage.data(), static_cast<int>(other_storage.size()));
    auto                             actor = std::make_shared<CCharacter2>();
    const std::weak_ptr<CCharacter2> retained = actor;
    auto                            *address = actor.get();
    auto                             resource = dc2::scene::CharacterResource::FromOwned(std::move(actor), dc2::memory::ArenaLifetime::Capture(memory));
    ASSERT_EQ(resource.Get(), address);
    EXPECT_EQ(resource.Producer(), nullptr);
    EXPECT_TRUE(resource.WouldRetireOnReset(memory, dc2::memory::ArenaResetKind::Stack));
    EXPECT_TRUE(resource.WouldRetireOnReset(memory, dc2::memory::ArenaResetKind::Rebind));
    EXPECT_FALSE(resource.WouldRetireOnReset(other, dc2::memory::ArenaResetKind::Stack));
    EXPECT_FALSE(resource.WouldRetireOnReset(other, dc2::memory::ArenaResetKind::Rebind));
    other.stReset();
    ASSERT_EQ(resource.Get(), address);
    memory.stReset();
    EXPECT_EQ(resource.Get(), nullptr);
    EXPECT_TRUE(resource.HasValue());
    EXPECT_FALSE(retained.expired());
    resource = {};
    EXPECT_TRUE(retained.expired());
}

TEST(SceneResourceLifetime, ScopedHeapCharactersFollowModelReplacementWithinTheirLogicalLifetime) {
    constexpr auto                     model_words = dc2::memory::ArrayQuadwords<mgCFrame>(1).value() + 16;
    std::array<u_long128, model_words> model_storage{};
    std::array<u_long128, 16>          scope_storage{};
    mgCMemory                          models;
    mgCMemory                          scope;
    models.stSetBuffer(model_storage.data(), static_cast<int>(model_storage.size()));
    scope.stSetBuffer(scope_storage.data(), static_cast<int>(scope_storage.size()));
    auto  actor = std::make_shared<CCharacter2>();
    auto *model = dc2::memory::NewObject<mgCFrame>(models);
    ASSERT_NE(model, nullptr);
    actor->CObjectFrame::frame = model;
    ASSERT_TRUE(dc2::character::CaptureModelResources(*actor, models));
    const auto resource = dc2::scene::CharacterResource::FromOwned(actor, dc2::memory::ArenaLifetime::Capture(scope));
    ASSERT_EQ(resource.Get(), actor.get());
    EXPECT_TRUE(resource.WouldRetireOnReset(models, dc2::memory::ArenaResetKind::Stack));
    models.stReset();
    EXPECT_EQ(resource.Get(), nullptr);
    auto *replacement = dc2::memory::NewObject<mgCFrame>(models);
    ASSERT_EQ(replacement, model);
    actor->CObjectFrame::frame = replacement;
    ASSERT_TRUE(dc2::character::CaptureModelResources(*actor, models));
    EXPECT_EQ(resource.Get(), actor.get());
    scope.stReset();
    EXPECT_TRUE(dc2::character::ResourcesLive(*actor));
    EXPECT_EQ(resource.Get(), nullptr);
}

TEST(SceneResourceLifetime, LogicalScopeControllerDestructionAndSameAddressReuseCannotReviveResources) {
    std::array<u_long128, 16> storage{};
    std::optional<mgCMemory>  memory(std::in_place);
    memory->stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto       actor = std::make_shared<CCharacter2>();
    const auto resource = dc2::scene::CharacterResource::FromOwned(actor, dc2::memory::ArenaLifetime::Capture(*memory));
    ASSERT_EQ(resource.Get(), actor.get());
    const auto *producer_address = &*memory;
    memory.reset();
    EXPECT_EQ(resource.Get(), nullptr);
    memory.emplace();
    ASSERT_EQ(&*memory, producer_address);
    memory->stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    EXPECT_EQ(resource.Get(), nullptr);
    const auto replacement = dc2::scene::CharacterResource::FromOwned(actor, dc2::memory::ArenaLifetime::Capture(*memory));
    EXPECT_EQ(replacement.Get(), actor.get());
    EXPECT_EQ(resource.Get(), nullptr);
    memory->stReset();
    EXPECT_EQ(replacement.Get(), nullptr);
    EXPECT_EQ(resource.Get(), nullptr);
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
    EXPECT_FALSE(scene->chara[1].Resource().HasValue());
    parent.stReset();
    EXPECT_EQ(scene->GetCharacter(0), nullptr);
}

TEST(SceneResourceLifetime, FailedCharacterCandidatesPreserveThePublishedSlotAndRestoreSourceTransforms) {
    mgCMemory      models;
    constexpr auto model_words = dc2::memory::ArrayQuadwords<mgCFrame>(1).value() + 16;
    models.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&models, model_words * sizeof(u_long128))), model_words);
    auto *frame = dc2::memory::NewObject<mgCFrame>(models);
    ASSERT_NE(frame, nullptr);
    auto source = std::make_shared<CCharacter2>();
    source->CObjectFrame::frame = frame;
    ASSERT_TRUE(dc2::character::CaptureModelResources(*source, models));
    source->SetPosition(3.0f, 4.0f, 5.0f);
    source->SetRotation(0.1f, 0.2f, 0.3f);
    source->SetScale(2.0f, 3.0f, 4.0f);
    auto                                      previous = std::make_shared<CCharacter2>();
    dc2::test::ScopedGlobalObject<EventScene> scene;
    scene->chara_num = 2;
    ASSERT_EQ(scene->AssignChara(0, dc2::scene::CharacterResource::FromOwned(source)), 0);
    ASSERT_EQ(scene->AssignChara(1, dc2::scene::CharacterResource::FromOwned(previous)), 1);
    scene->chara[1].texb = 43;
    const auto     previous_status = scene->chara[1].status;
    mgCMemory      copies;
    constexpr auto copy_words = dc2::memory::ArrayQuadwords<CCharacter2>(1).value() + 1;
    copies.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&copies, copy_words * sizeof(u_long128))), copy_words);
    scene->stack_num = 1;
    scene->stack[0] = &copies;
    EXPECT_EQ(scene->CopyChara(1, 0, &copies), -1);
    EXPECT_EQ(scene->GetCharacter(1), previous.get());
    EXPECT_EQ(scene->chara[1].status, previous_status);
    EXPECT_EQ(scene->chara[1].texb, 43);
    float position[4];
    float rotation[4];
    float scale[4];
    source->GetPosition(position);
    source->GetRotation(rotation);
    source->GetScale(scale);
    EXPECT_FLOAT_EQ(position[0], 3.0f);
    EXPECT_FLOAT_EQ(position[1], 4.0f);
    EXPECT_FLOAT_EQ(position[2], 5.0f);
    EXPECT_FLOAT_EQ(rotation[0], 0.1f);
    EXPECT_FLOAT_EQ(rotation[1], 0.2f);
    EXPECT_FLOAT_EQ(rotation[2], 0.3f);
    EXPECT_FLOAT_EQ(scale[0], 2.0f);
    EXPECT_FLOAT_EQ(scale[1], 3.0f);
    EXPECT_FLOAT_EQ(scale[2], 4.0f);
    copies.stReset();
    CRunScript callbacks;
    SetEventFunc(&callbacks);
    std::array<RS_STACKDATA, 3> arguments{};
    for (auto &argument : arguments) {
        argument.type = RS_INT;
    }
    arguments[2].val.i = 1;
    EXPECT_FALSE(InvokeNativeExternal(callbacks.ext_func_table[EVENT_EXT_COPY_CHARA], arguments));
    EXPECT_GT(copies.stGetUsed(), 0);
    EXPECT_EQ(scene->GetCharacter(1), previous.get());
    EXPECT_EQ(scene->chara[1].status, previous_status);
    EXPECT_EQ(scene->chara[1].texb, 43);
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
    ASSERT_TRUE(source->Copy(*copy, &copies));
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
    ASSERT_TRUE(entry->AssignName(models, part_name));
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
    ASSERT_TRUE(entry->AssignName(models, part_name));
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
