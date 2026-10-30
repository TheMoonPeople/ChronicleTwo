#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <format>
#include <memory>
#include <vector>

#include "dng_event.hpp"
#include "dng_main.hpp"
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

    EXPECT_EQ(manager->scene, scene.get());
    const auto parent_begin = reinterpret_cast<std::uintptr_t>(memory.stack);
    const auto parent_end = parent_begin + static_cast<std::size_t>(memory.stack_size) * sizeof(u_long128);
    const int  parent_used = memory.stack_used;
    EXPECT_EQ(PortMonsterActiveLimit(), GetParam() ? MONSTER_ACTIVE_MAX : 24);
    // Every slot binds its scene character; only the floor's slots get script memory.
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        EXPECT_EQ(manager->active[i], monsters[i].get()) << i;
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
        EXPECT_EQ(manager->active[i], monsters[i].get()) << i;
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
        source->Copy(*destination, &slot);
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

TEST(MonsterConstruction, ReusedStorageStartsWithDefinedControllerAndInactiveMonsterFields) {
    alignas(CActiveMonster) std::array<std::byte, sizeof(CActiveMonster)> monster_storage{};
    std::ranges::fill(monster_storage, std::byte{0xA5});
    auto *monster = std::construct_at(reinterpret_cast<CActiveMonster *>(monster_storage.data()));
    EXPECT_EQ(monster->base_tbl, nullptr);
    EXPECT_EQ(monster->tbl, nullptr);
    EXPECT_EQ(monster->link_piece, nullptr);
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
    EXPECT_EQ(controller->scene, nullptr);
    EXPECT_EQ(controller->effect_man, nullptr);
    EXPECT_EQ(controller->boss_max_life, 0);
    for (const auto *active : controller->active) {
        EXPECT_EQ(active, nullptr);
    }
    for (auto &memory : controller->memory) {
        EXPECT_EQ(memory.stGetTop(), nullptr);
    }
    std::destroy_at(controller);
}
