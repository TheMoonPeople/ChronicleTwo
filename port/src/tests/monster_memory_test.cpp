#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <format>
#include <memory>
#include <vector>

#include "dng_event.hpp"
#include "dng_main.hpp"
#include "editmap.hpp"
#include "effscript.hpp"
#include "mg_dataset.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "monster_memory.hpp"
#include "platform/arena.hpp"
#include "platform/config.hpp"
#include "platform/paths.hpp"
#include "platform_fixture.hpp"
#include "runscript.hpp"
#include "scene.hpp"
#include "scoped_global_object.hpp"

namespace {

// Loads a floor with game.more_monsters set as given, in an isolated save root.
class MonsterMemory : public testing::TestWithParam<bool> {
protected:
    void SetUp() override {
        root = std::filesystem::temp_directory_path() / std::format("dc2_monster_memory_{}", dc::test::ProcessId());
        // config.json sits beside the save root, so each test process owns the one it writes.
        PathsSetSaveRoot(root / "save");
        Config config;
        config.more_monsters = GetParam();
        ASSERT_TRUE(ConfigChange(config));
        ASSERT_TRUE(ConfigSave());
        ASSERT_TRUE(std::filesystem::exists(root / "config.json"));
        PortMonsterLatchLimits();
    }

    void TearDown() override {
        ConfigChange(previous_config);
        PortMonsterLatchLimits();
        PathsSetSaveRoot(previous_save_root);
        std::filesystem::remove_all(root);
    }

    Config                previous_config = ConfigGet();
    std::filesystem::path previous_save_root = PathsSaveRoot();
    std::filesystem::path root;
};

TEST_P(MonsterMemory, SingleMonsterLoadInitializesEveryHostArena) {
    // Exercise the scripted loader without loading a reference model (-1 is an empty kind).
    auto                                                            manager = std::make_unique<CMonsterMan>();
    std::array<std::shared_ptr<CActiveMonster>, MONSTER_ACTIVE_MAX> monsters;
    std::unique_ptr<CScene>                                         scene = std::make_unique<CScene>();
    ASSERT_NE(scene, nullptr);
    scene->chara_num = DNG_CHARA_SLOT_MONSTER_END;
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        monsters[i] = std::make_shared<CActiveMonster>();
        ASSERT_EQ(scene->AssignChara(DNG_CHARA_SLOT_MONSTER + i, dc2::scene::CharacterResource::FromOwned(monsters[i])), DNG_CHARA_SLOT_MONSTER + i);
    }

    constexpr int          slot_quads = kMonsterScriptQuadwords + 4;
    std::vector<u_long128> storage(10000);
    mgCMemory              parent;
    mgCMemory              memory;
    parent.stSetBuffer(storage.data(), storage.size());
    scene->stack_num = 4;
    scene->stack[2] = &parent;
    scene->stack[3] = &memory;
    CEffectScriptMan effects;

    CScene           *saved_scene = DngMainScene;
    CMonsterMan      *saved_manager = ActiveMonster;
    CEffectScriptMan *saved_effects = FxScriptMan;
    DngMainScene = scene.get();
    ActiveMonster = manager.get();
    FxScriptMan = &effects;
    LoadMonsterFile(-1, 1);
    DngMainScene = saved_scene;
    ActiveMonster = saved_manager;
    FxScriptMan = saved_effects;

    EXPECT_EQ(manager->GetScene(), scene.get());
    const auto parent_begin = reinterpret_cast<std::uintptr_t>(memory.stack);
    const auto parent_end = parent_begin + static_cast<std::size_t>(memory.stack_size) * sizeof(u_long128);
    const int  parent_used = memory.stack_used;
    EXPECT_EQ(PortMonsterActiveLimit(), GetParam() ? MONSTER_ACTIVE_MAX : 24);
    // Every slot binds its scene character; only the floor's slots get script memory.
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        EXPECT_EQ(manager->GetActiveMonster(i), monsters[i].get()) << i;
        if (i >= PortMonsterActiveLimit()) {
            EXPECT_EQ(manager->memory[i].stack_size, 0) << i;
        }
    }
    for (int i = 0; i < PortMonsterActiveLimit(); ++i) {
        mgCMemory &slot = manager->memory[i];
        EXPECT_EQ(slot.stack_size, slot_quads) << i;
        EXPECT_EQ(slot.stack_used, 0) << i;
        EXPECT_EQ(slot.lock, 0) << i;
        ASSERT_NE(slot.stack, nullptr) << i;
        EXPECT_TRUE(ArenaContains(slot.stack)) << i;
        const auto begin = reinterpret_cast<std::uintptr_t>(slot.stack);
        const auto end = begin + static_cast<std::size_t>(slot_quads) * sizeof(u_long128);
        EXPECT_TRUE(end <= parent_begin || parent_end <= begin) << i;
        for (int other = 0; other < i; ++other) {
            const auto other_begin = reinterpret_cast<std::uintptr_t>(manager->memory[other].stack);
            const auto other_end = other_begin + static_cast<std::size_t>(slot_quads) * sizeof(u_long128);
            EXPECT_TRUE(end <= other_begin || other_end <= begin) << i << ", " << other;
        }
        // Shared models need only the interpreter stacks in each slot.
        ASSERT_EQ(slot.Alloc((128 * sizeof(RS_STACKDATA) + 15) / 16), slot.stack) << i;
        ASSERT_NE(slot.Alloc((512 * sizeof(RS_CALLDATA) + 15) / 16), nullptr) << i;
        EXPECT_EQ(slot.stack_used, kMonsterScriptQuadwords - 1) << i;
        EXPECT_EQ(manager->GetActiveMonster(i), monsters[i].get()) << i;
    }
    EXPECT_EQ(memory.stack_used, parent_used);
}

TEST_P(MonsterMemory, ModelCopySizesItsSlotBeforeAllocatingScriptStacks) {
    auto manager = std::make_unique<CMonsterMan>();
    auto source = std::make_unique<CActiveMonster>();
    auto destination = std::make_unique<CActiveMonster>();
    PrepareMonsterMemory(*manager);
    CMonsterMan *saved_manager = ActiveMonster;
    auto        &slot = manager->memory[PortMonsterActiveLimit() - 1];

    source->Initialize();
    auto copy_model = [&](int count, int &capacity) {
        source->Initialize();
        static char model_key;
        mgCMemory   model_memory;
        const auto  words = static_cast<int>((static_cast<std::size_t>(count) * (sizeof(mgCFrame) + sizeof(mgCFrame *)) + 15) / 16 + 8);
        model_memory.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&model_key, static_cast<std::size_t>(words) * sizeof(u_long128))), words);
        auto *frames = dc2::memory::NewArray<mgCFrame>(model_memory, static_cast<std::size_t>(count));
        auto *table = dc2::memory::NewArray<mgCFrame *>(model_memory, static_cast<std::size_t>(count));
        ASSERT_NE(frames, nullptr);
        ASSERT_NE(table, nullptr);
        std::vector<std::string> names(count);
        for (int index = 0; index < count; ++index) {
            names[index] = "bone" + std::to_string(index);
            frames[index].SetName(names[index].data());
            table[index] = &frames[index];
        }
        frames[1].SetParent(frames);
        frames[0].frame_num = count;
        frames[0].frame_list = table;
        source->CObjectFrame::frame = frames;
        ASSERT_TRUE(dc2::character::CaptureModelResources(*source, model_memory));
        source->copy_size = 0;
        source->load_size = static_cast<int>((count * (sizeof(mgCFrame) + sizeof(mgCFrame *)) + 15) / 16 + 8);

        ActiveMonster = manager.get();
        ASSERT_TRUE(source->Copy(*destination, &slot));
        ActiveMonster = saved_manager;
        mgCFrame *copy = destination->CObjectFrame::frame;
        ASSERT_NE(copy, nullptr);
        ASSERT_NE(copy, frames);
        ASSERT_NE(copy->frame_list, nullptr);
        EXPECT_EQ(copy->frame_num, count);
        EXPECT_EQ(copy->frame_list[1]->parent, copy);
        EXPECT_STREQ(copy->frame_list[count - 1]->name, names.back().c_str());

        const int copy_used = slot.stack_used;
        EXPECT_GT(copy_used + kMonsterScriptQuadwords, 4448);
        ASSERT_NE(slot.Alloc((128 * sizeof(RS_STACKDATA) + 15) / 16), nullptr);
        ASSERT_NE(slot.Alloc((512 * sizeof(RS_CALLDATA) + 15) / 16), nullptr);
        EXPECT_EQ(slot.stack_used, copy_used + kMonsterScriptQuadwords - 1);
        capacity = slot.stack_size;
    };

    int first_capacity = 0;
    copy_model(512, first_capacity);
    slot.stReset();
    int second_capacity = 0;
    copy_model(768, second_capacity);
    EXPECT_GT(second_capacity, first_capacity);
}

INSTANTIATE_TEST_SUITE_P(MoreMonsters, MonsterMemory, testing::Bool(),
                         [](const testing::TestParamInfo<bool> &info) { return info.param ? "On" : "Off"; });

} // namespace

TEST(MonsterViews, SparseBindingsRejectReplacementUntilExplicitInitialization) {
    auto manager = std::make_unique<CMonsterMan>();
    auto scene = std::make_unique<CScene>();
    scene->chara_num = DNG_CHARA_SLOT_MONSTER_END;
    auto first = std::make_shared<CActiveMonster>();
    auto last = std::make_shared<CActiveMonster>();
    ASSERT_EQ(scene->AssignChara(DNG_CHARA_SLOT_MONSTER, dc2::scene::CharacterResource::FromOwned(first)), DNG_CHARA_SLOT_MONSTER);
    constexpr int last_slot = MONSTER_ACTIVE_MAX - 1;
    ASSERT_EQ(scene->AssignChara(DNG_CHARA_SLOT_MONSTER + last_slot, dc2::scene::CharacterResource::FromOwned(last)), DNG_CHARA_SLOT_MONSTER + last_slot);
    dc2::test::ScopedGlobalObject<FxScriptMan> effects;
    manager->Initialize(scene.get());
    EXPECT_EQ(manager->GetActiveMonster(-1), nullptr);
    EXPECT_EQ(manager->GetActiveMonster(MONSTER_ACTIVE_MAX), nullptr);
    EXPECT_EQ(manager->GetActiveMonster(0), first.get());
    EXPECT_EQ(manager->GetActiveMonster(1), nullptr);
    EXPECT_EQ(manager->GetActiveMonster(last_slot), last.get());

    auto replacement = std::make_shared<CActiveMonster>();
    ASSERT_EQ(scene->AssignChara(DNG_CHARA_SLOT_MONSTER, dc2::scene::CharacterResource::FromOwned(replacement)), DNG_CHARA_SLOT_MONSTER);
    EXPECT_EQ(manager->GetActiveMonster(0), nullptr);
    EXPECT_EQ(manager->GetActiveMonster(last_slot), last.get());
    manager->Initialize(scene.get());
    EXPECT_EQ(manager->GetActiveMonster(0), replacement.get());
    scene->chara[DNG_CHARA_SLOT_MONSTER].Initialize();
    EXPECT_EQ(manager->GetActiveMonster(0), nullptr);
    EXPECT_EQ(manager->GetActiveMonster(last_slot), last.get());
    scene->Initialize();
    EXPECT_EQ(manager->GetScene(), nullptr);
    EXPECT_EQ(manager->GetActiveMonster(last_slot), nullptr);
}

TEST(MonsterViews, DestroyedSceneRevokesManagerWhileCharacterOwnerSurvives) {
    auto                                       manager = std::make_unique<CMonsterMan>();
    auto                                       monster = std::make_shared<CActiveMonster>();
    dc2::test::ScopedGlobalObject<FxScriptMan> effects;
    {
        auto scene = std::make_unique<CScene>();
        scene->chara_num = DNG_CHARA_SLOT_MONSTER_END;
        ASSERT_EQ(scene->AssignChara(DNG_CHARA_SLOT_MONSTER, dc2::scene::CharacterResource::FromOwned(monster)), DNG_CHARA_SLOT_MONSTER);
        manager->Initialize(scene.get());
        ASSERT_EQ(manager->GetActiveMonster(0), monster.get());
    }
    EXPECT_EQ(manager->GetScene(), nullptr);
    EXPECT_EQ(manager->GetActiveMonster(0), nullptr);
    EXPECT_EQ(manager->GetMonsterNum(-1.0f), 0);
    manager->ThinkHost();
    manager->DrawShadowActMonster();
    manager->RunScript(0);
}

TEST(MonsterConstruction, ReusedStorageStartsWithDefinedControllerAndInactiveMonsterFields) {
    alignas(CActiveMonster) std::array<std::byte, sizeof(CActiveMonster)> monster_storage{};
    std::ranges::fill(monster_storage, std::byte{0xA5});
    auto *monster = std::construct_at(reinterpret_cast<CActiveMonster *>(monster_storage.data()));
    EXPECT_EQ(monster->base_tbl, nullptr);
    EXPECT_EQ(monster->tbl, nullptr);
    std::array<float, 4> link_position{};
    std::array<float, 4> link_rotation{};
    EXPECT_FALSE(monster->map_link.UpdateLinkedPiece(link_position, link_rotation));
    EXPECT_EQ(monster->target_dist, 0.0f);
    EXPECT_EQ(monster->camera_dist, 0.0f);
    EXPECT_EQ(monster->last_hit_chara, 0);
    EXPECT_EQ(monster->last_hit_source, 0);
    EXPECT_EQ(monster->last_hit_attr, 0U);
    for (int size : monster->reserv_img_size) {
        EXPECT_EQ(size, 0);
    }
    std::destroy_at(monster);

    alignas(CMonsterMan) std::array<std::byte, sizeof(CMonsterMan)> controller_storage{};
    std::ranges::fill(controller_storage, std::byte{0xA5});
    auto *controller = std::construct_at(reinterpret_cast<CMonsterMan *>(controller_storage.data()));
    EXPECT_EQ(controller->GetScene(), nullptr);
    EXPECT_EQ(controller->effect_man, nullptr);
    EXPECT_EQ(controller->boss_max_life, 0);
    for (int index = 0; index < MONSTER_ACTIVE_MAX; ++index) {
        EXPECT_EQ(controller->GetActiveMonster(index), nullptr);
    }
    for (auto &memory : controller->memory) {
        EXPECT_EQ(memory.stGetTop(), nullptr);
    }
    std::destroy_at(controller);
}

namespace {
/**
 * Builds genuine scene-owned maps with independently resettable placement, piece and model producers.
 */
class MonsterMapLink : public testing::Test {
protected:
    std::vector<u_long128>  placement_storage = std::vector<u_long128>(32768);
    std::vector<u_long128>  piece_storage = std::vector<u_long128>(8192);
    std::vector<u_long128>  model_storage = std::vector<u_long128>(8192);
    mgCMemory               placements;
    mgCMemory               pieces;
    mgCMemory               models;
    std::unique_ptr<CScene> scene = std::make_unique<CScene>();
    CEditMap               *map = nullptr;
    CMapParts              *part = nullptr;
    CList<CMapPiece>       *node = nullptr;
    mgCFrame               *root_frame = nullptr;
    mgCFrame               *named_frame = nullptr;

    void SetUp() override {
        placements.stSetBuffer(placement_storage.data(), static_cast<int>(placement_storage.size()));
        pieces.stSetBuffer(piece_storage.data(), static_cast<int>(piece_storage.size()));
        models.stSetBuffer(model_storage.data(), static_cast<int>(model_storage.size()));
        auto owned = std::make_unique<CEditMap>();
        map = owned.get();
        ASSERT_TRUE(map->SetPlacePartsBuff(&placements, 2));
        part = &map->PlacedParts()[0];
        std::memcpy(part->name, "part", 5);
        map->place_parts_num = 1;
        root_frame = dc2::memory::NewObject<mgCFrame>(models);
        named_frame = dc2::memory::NewObject<mgCFrame>(models);
        ASSERT_NE(root_frame, nullptr);
        ASSERT_NE(named_frame, nullptr);
        auto *name = dc2::memory::NewArray<char>(models, 12);
        ASSERT_NE(name, nullptr);
        std::memcpy(name, "bone--flags", 12);
        named_frame->name = name;
        named_frame->SetParent(root_frame);
        named_frame->SetPosition(3, 0, 0);
        node = dc2::memory::NewObject<CList<CMapPiece>>(pieces);
        ASSERT_NE(node, nullptr);
        node->data.frame = root_frame;
        node->data.frame_graph = dc2::world::FrameGraph::Capture(models, root_frame);
        ASSERT_TRUE(node->data.frame_graph.IsLive());
        node->data.SetPosition(2, 0, 0);
        part->piece_list = node;
        ASSERT_TRUE(PublishPiece());
        part->SetPosition(10, 0, 0);
        char map_name[] = "map link";
        ASSERT_TRUE(scene->map[0].AssignData(map, map_name));
        ASSERT_TRUE(scene->map[0].OwnEditMap(std::move(owned)));
    }

    /**
     * Republishes the actual current piece assignment under its owned lookup name.
     */
    bool PublishPiece() {
        return part->PublishPieceBindings({
            {"piece", dc2::world::PieceView::Capture(pieces, *node)}
        });
    }

    /**
     * Issues the scene slot's genuine checked map view.
     */
    dc2::scene::MapView MapView() { return scene->map[0].GetMapView(); }
};
} // namespace

TEST_F(MonsterMapLink, FailedBindsPreserveCompleteLinksAndNamedQueriesValidateBeforeMutation) {
    dc2::scene::MapLink link;
    ASSERT_TRUE(link.BindPiece(MapView(), "part", "piece"));
    const std::array<float, 4> rotation{0, 0.25f, 0, 1};
    std::array<float, 4>       position{-1, -1, -1, -1};
    ASSERT_TRUE(link.GetFrameWorldPosition("bone--query", position));
    EXPECT_FLOAT_EQ(position[0], 15);
    ASSERT_FALSE(link.BindPiece(MapView(), "part", "missing"));
    ASSERT_FALSE(link.BindPiece(MapView(), "missing", "piece"));
    ASSERT_FALSE(link.BindPart({}, "part"));
    ASSERT_FALSE(link.BindPart(MapView(), ""));
    ASSERT_FALSE(link.BindPiece(MapView(), "part", ""));
    ASSERT_TRUE(link.UpdateLinkedPiece(position, rotation));
    EXPECT_FLOAT_EQ(position[0], 12);
    EXPECT_FLOAT_EQ(node->data.rotation[1], 0.25f);
    const auto root_position = root_frame->position[0];
    node->data.SetPosition(20, 0, 0);
    EXPECT_FALSE(link.GetFrameWorldPosition("missing", position));
    EXPECT_FLOAT_EQ(root_frame->position[0], root_position);
    ASSERT_TRUE(link.BindPart(MapView(), "part"));
    EXPECT_FALSE(link.UpdateLinkedPiece(position, rotation));
    EXPECT_FALSE(link.GetFrameWorldPosition("bone", position));
    ASSERT_TRUE(link.SetPartTransform(position, rotation));
    EXPECT_FLOAT_EQ(part->position[0], 12);
    link.Clear();
    EXPECT_FALSE(link.SetPartTransform(position, rotation));
}

TEST_F(MonsterMapLink, RepeatedMovementAllocatesNoArenaStorageAndInitializationClearsMonsterLinks) {
    auto monster = std::make_unique<CActiveMonster>();
    ASSERT_TRUE(monster->map_link.BindPiece(MapView(), "part", "piece"));
    const auto                 used = std::array{placements.stGetUsed(), pieces.stGetUsed(), models.stGetUsed()};
    std::array<float, 4>       position{};
    const std::array<float, 4> rotation{};
    for (int frame = 0; frame < 1000; ++frame) {
        ASSERT_TRUE(monster->map_link.UpdateLinkedPiece(position, rotation));
    }
    EXPECT_EQ((std::array{placements.stGetUsed(), pieces.stGetUsed(), models.stGetUsed()}), used);
    EXPECT_FLOAT_EQ(position[0], 12);
    monster->Initialize();
    EXPECT_FALSE(monster->map_link.UpdateLinkedPiece(position, rotation));
}

TEST_F(MonsterMapLink, RetiredModelsAndSameAddressModelReplacementCannotRedirectExistingLinks) {
    dc2::scene::MapLink link;
    ASSERT_TRUE(link.BindPiece(MapView(), "part", "piece"));
    const auto original_graph = node->data.frame_graph;
    node->data.frame_graph = dc2::world::FrameGraph::Capture(models, root_frame);
    std::array<float, 4>       position{91, 92, 93, 94};
    const std::array<float, 4> rotation{};
    EXPECT_FALSE(link.UpdateLinkedPiece(position, rotation));
    EXPECT_FLOAT_EQ(position[0], 91);
    ASSERT_TRUE(PublishPiece());
    ASSERT_TRUE(link.BindPiece(MapView(), "part", "piece"));
    models.stReset();
    auto *replacement = dc2::memory::NewObject<mgCFrame>(models);
    ASSERT_EQ(replacement, root_frame);
    node->data.frame = replacement;
    node->data.frame_graph = dc2::world::FrameGraph::Capture(models, replacement);
    ASSERT_TRUE(node->data.frame_graph.IsLive());
    EXPECT_FALSE(original_graph.IsLive());
    EXPECT_FALSE(link.UpdateLinkedPiece(position, rotation));
    EXPECT_FALSE(link.GetFrameWorldPosition("bone", position));
    EXPECT_FLOAT_EQ(position[0], 91);
    ASSERT_TRUE(PublishPiece());
    ASSERT_TRUE(link.BindPiece(MapView(), "part", "piece"));
    EXPECT_TRUE(link.UpdateLinkedPiece(position, rotation));
}

TEST_F(MonsterMapLink, PieceNodeRetirementAndSameAddressReplacementRequireExplicitRebinding) {
    dc2::scene::MapLink link;
    ASSERT_TRUE(link.BindPiece(MapView(), "part", "piece"));
    pieces.stReset();
    auto *replacement = dc2::memory::NewObject<CList<CMapPiece>>(pieces);
    ASSERT_EQ(replacement, node);
    replacement->data.frame = root_frame;
    replacement->data.frame_graph = dc2::world::FrameGraph::Capture(models, root_frame);
    std::array<float, 4>       position{91, 92, 93, 94};
    const std::array<float, 4> rotation{};
    EXPECT_FALSE(link.UpdateLinkedPiece(position, rotation));
    EXPECT_FLOAT_EQ(position[0], 91);
    ASSERT_TRUE(PublishPiece());
    ASSERT_TRUE(link.BindPiece(MapView(), "part", "piece"));
    EXPECT_TRUE(link.UpdateLinkedPiece(position, rotation));
}

TEST_F(MonsterMapLink, PartAndTableReplacementAndUnsafeExternalParentsRevokeTransforms) {
    dc2::scene::MapLink link;
    ASSERT_TRUE(link.BindPart(MapView(), "part"));
    const std::array<float, 4> position{1, 2, 3, 1};
    const std::array<float, 4> rotation{};
    mgCFrame                   outside;
    part->frame.parent = &outside;
    EXPECT_FALSE(link.SetPartTransform(position, rotation));
    part->frame.parent = nullptr;
    EXPECT_TRUE(link.SetPartTransform(position, rotation));
    part->Initialize();
    std::memcpy(part->name, "part", 5);
    EXPECT_FALSE(link.SetPartTransform(position, rotation));
    ASSERT_TRUE(link.BindPart(MapView(), "part"));
    ASSERT_TRUE(map->SetPlacePartsBuff(&placements, 2));
    part = &map->PlacedParts()[0];
    std::memcpy(part->name, "part", 5);
    map->place_parts_num = 1;
    EXPECT_FALSE(link.SetPartTransform(position, rotation));
    ASSERT_TRUE(link.BindPart(MapView(), "part"));
    EXPECT_TRUE(link.SetPartTransform(position, rotation));
    placements.stReset();
    EXPECT_FALSE(link.SetPartTransform(position, rotation));
}

TEST_F(MonsterMapLink, SceneResetAndDestructionRejectLinksEvenWhileExternalArenasSurvive) {
    dc2::scene::MapLink link;
    ASSERT_TRUE(link.BindPiece(MapView(), "part", "piece"));
    std::array<float, 4>       position{91, 92, 93, 94};
    const std::array<float, 4> rotation{};
    scene->Initialize();
    EXPECT_FALSE(link.UpdateLinkedPiece(position, rotation));
    EXPECT_FLOAT_EQ(position[0], 91);
    scene.reset();
    EXPECT_FALSE(link.GetFrameWorldPosition("bone", position));
    EXPECT_FLOAT_EQ(position[0], 91);
}

TEST_F(MonsterMapLink, ReplacingTheOwningMapSlotRevokesLinksBeforeReleasingTheOldMap) {
    dc2::scene::MapLink link;
    ASSERT_TRUE(link.BindPiece(MapView(), "part", "piece"));
    auto replacement = std::make_unique<CEditMap>();
    char map_name[] = "replacement";
    ASSERT_TRUE(scene->map[0].AssignData(replacement.get(), map_name));
    ASSERT_TRUE(scene->map[0].OwnEditMap(std::move(replacement)));
    std::array<float, 4>       position{91, 92, 93, 94};
    const std::array<float, 4> rotation{};
    EXPECT_FALSE(link.UpdateLinkedPiece(position, rotation));
    EXPECT_FALSE(link.GetFrameWorldPosition("bone", position));
    EXPECT_FLOAT_EQ(position[0], 91);
    EXPECT_FALSE(link.BindPiece(MapView(), "part", "piece"));
    EXPECT_FALSE(link.UpdateLinkedPiece(position, rotation));
}

TEST_F(MonsterMapLink, MoveUnitPreservesBothSuccessfulRelationshipModesAndOrdinaryMotionAfterRetirement) {
    dc2::test::ScopedGlobalObject<FxScriptMan> effects;
    auto                                       manager = std::make_unique<CMonsterMan>();
    manager->Initialize(scene.get());
    auto monster = std::make_unique<CActiveMonster>();
    monster->attrib = MONSTER_ATTRIB_NO_BODY_HIT | MONSTER_ATTRIB_NO_MAP_HIT | MONSTER_ATTRIB_SET_VELOCITY;
    monster->SetPosition(0, 0, 0);
    monster->SetRotation(0, 0.25f, 0);
    monster->next_pos[0] = 10;
    monster->next_pos[1] = monster->next_pos[2] = 0;
    monster->next_pos[3] = 1;
    monster->move_speed = 1;
    ASSERT_TRUE(monster->map_link.BindPart(MapView(), "part"));
    manager->MoveUnit(monster.get(), nullptr, 0);
    EXPECT_FLOAT_EQ(monster->position[0], 1);
    EXPECT_FLOAT_EQ(part->position[0], 1);
    EXPECT_FLOAT_EQ(part->rotation[1], 0.25f);
    part->SetPosition(10, 0, 0);
    part->SetRotation(0, 0, 0);
    ASSERT_TRUE(monster->map_link.BindPiece(MapView(), "part", "piece"));
    manager->MoveUnit(monster.get(), nullptr, 0);
    EXPECT_FLOAT_EQ(monster->position[0], 12);
    EXPECT_FLOAT_EQ(node->data.rotation[1], 0.25f);
    models.stReset();
    monster->move_speed = 0;
    manager->MoveUnit(monster.get(), nullptr, 0);
    EXPECT_FLOAT_EQ(monster->position[0], 12);
}
