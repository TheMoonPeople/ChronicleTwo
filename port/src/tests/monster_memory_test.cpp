#include <gtest/gtest.h>

#include <cstdint>
#include <cstdlib>
#include <filesystem>
#include <format>
#include <memory>
#include <type_traits>
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
#include "subgame.hpp"

namespace {

// Loads a floor with game.more_monsters set as given, in an isolated save root.
class MonsterMemory : public testing::TestWithParam<bool> {
protected:
    void SetUp() override {
        root = std::filesystem::temp_directory_path() / std::format("dc2_monster_memory_{}", dc::test::ProcessId());
        PathsSetSaveRoot(root);
        Config config;
        config.more_monsters = GetParam();
        ASSERT_TRUE(ConfigChange(config));
        PortMonsterLatchLimits();
    }

    void TearDown() override {
        ConfigChange(Config{});
        PortMonsterLatchLimits();
        std::filesystem::remove_all(root);
    }

    std::filesystem::path root;
};

TEST_P(MonsterMemory, SingleMonsterLoadInitializesEveryHostArena) {
    // Exercise the scripted loader without loading a reference model (-1 is an empty kind).
    auto                                          manager = std::make_unique<CMonsterMan>();
    auto                                          monsters = std::make_unique<CActiveMonster[]>(MONSTER_ACTIVE_MAX);
    std::unique_ptr<CScene, decltype(&std::free)> scene(
        static_cast<CScene *>(std::calloc(1, sizeof(CScene))), &std::free);
    ASSERT_NE(scene, nullptr);
    scene->chara_num = DNG_CHARA_SLOT_MONSTER_END;
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        scene->chara[DNG_CHARA_SLOT_MONSTER + i].status = 1;
        scene->chara[DNG_CHARA_SLOT_MONSTER + i].chara = &monsters[i];
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
        EXPECT_EQ(manager->active[i], &monsters[i]) << i;
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
        EXPECT_EQ(manager->active[i], &monsters[i]) << i;
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
        std::vector<mgCFrame>    frames(count);
        std::vector<mgCFrame *>  table(count);
        std::vector<std::string> names(count);
        for (int index = 0; index < count; ++index) {
            names[index] = "bone" + std::to_string(index);
            frames[index].SetName(names[index].data());
            table[index] = &frames[index];
        }
        frames[1].SetParent(frames.data());
        frames[0].frame_num = count;
        frames[0].frame_list = table.data();
        source->CObjectFrame::frame = frames.data();
        source->copy_size = 0;
        source->load_size = static_cast<int>((count * (sizeof(mgCFrame) + sizeof(mgCFrame *)) + 15) / 16 + 8);

        ActiveMonster = manager.get();
        source->Copy(*destination, &slot);
        ActiveMonster = saved_manager;
        mgCFrame *copy = destination->CObjectFrame::frame;
        ASSERT_NE(copy, nullptr);
        ASSERT_NE(copy, frames.data());
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

// Every dungeon entry clears the sub-game character slots (InitDungeonMain -> InitSubGame) after the monsters are
// bound and before the floor script's LoadDungeonMapFile binds them again, so no monster slot may lie among them.
TEST(MonsterSlots, SurviveTheSubGameClear) {
    auto                                          player = std::make_unique<CCharacter2>();
    auto                                          monsters = std::make_unique<CActiveMonster[]>(MONSTER_ACTIVE_MAX);
    std::unique_ptr<CScene, decltype(&std::free)> scene(
        static_cast<CScene *>(std::calloc(1, sizeof(CScene))), &std::free);
    ASSERT_NE(scene, nullptr);
    scene->chara_num = std::extent_v<decltype(CScene::chara)>;
    ASSERT_NE(scene->AssignChara(DNG_CHARA_SLOT_PARTY, player.get(), nullptr), -1);
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        ASSERT_NE(scene->AssignChara(DNG_CHARA_SLOT_MONSTER + i, &monsters[i], nullptr), -1) << i;
    }

    InitSubGame(scene.get());

    EXPECT_LE(DNG_CHARA_SLOT_MONSTER_END, SUBGAME_CHARA_BASE);
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        EXPECT_EQ(scene->GetCharacter(DNG_CHARA_SLOT_MONSTER + i), &monsters[i]) << i;
    }
}

INSTANTIATE_TEST_SUITE_P(MoreMonsters, MonsterMemory, testing::Bool(),
                         [](const testing::TestParamInfo<bool> &info) { return info.param ? "On" : "Off"; });

} // namespace
