#include <gtest/gtest.h>

#include <cstdlib>
#include <memory>
#include <vector>

#include "dng_event.hpp"
#include "dng_main.hpp"
#include "effscript.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "port_monster_limit.hpp"
#include "runscript.hpp"
#include "scene.hpp"

TEST(MonsterMemory, SingleMonsterLoadInitializesEveryHostArena) {
    // Exercise the scripted loader without loading a reference model (-1 is an empty kind).
    auto                                          manager = std::make_unique<CMonsterMan>();
    auto                                          monsters = std::make_unique<CActiveMonster[]>(MONSTER_ACTIVE_MAX);
    std::unique_ptr<CScene, decltype(&std::free)> scene(
        static_cast<CScene *>(std::calloc(1, sizeof(CScene))), &std::free);
    ASSERT_NE(scene, nullptr);
    scene->chara_num = 2 * MONSTER_ACTIVE_MAX;
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        scene->chara[MONSTER_CHARA_INDEX(i)].status = 1;
        scene->chara[MONSTER_CHARA_INDEX(i)].chara = &monsters[i];
    }

    constexpr int          kExtraBytes = 128 * (sizeof(RS_STACKDATA) - 8) + 512 * (sizeof(RS_CALLDATA) - 12);
    constexpr int          kSlotQuads = 4000 + (kExtraBytes + 15) / 16;
    std::vector<u_long128> storage(MONSTER_ACTIVE_MAX * (kSlotQuads + 4) + 16);
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
    u_long128 *previous_end = memory.stack;
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        mgCMemory &slot = manager->memory[i];
        EXPECT_EQ(slot.stack_size, kSlotQuads) << i;
        EXPECT_EQ(slot.stack_used, 0) << i;
        EXPECT_EQ(slot.lock, 0) << i;
        ASSERT_NE(slot.stack, nullptr) << i;
        EXPECT_GE(slot.stack, previous_end) << i;
        EXPECT_LE(slot.stack + kSlotQuads, memory.stack + memory.stack_size) << i;
        EXPECT_EQ(slot.Alloc(38), slot.stack) << i;
        EXPECT_EQ(slot.stack_used, 38) << i;
        const int active_limit = PortMonsterActiveLimit();
        if (i < active_limit) {
            EXPECT_EQ(manager->active[i], &monsters[i]) << i;
        } else {
            EXPECT_EQ(manager->active[i], nullptr) << i;
        }
        previous_end = slot.stack + kSlotQuads;
    }
}
