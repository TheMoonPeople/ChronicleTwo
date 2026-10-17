#include "bench_spawn.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdio>

#include "character.hpp"
#include "dng_main.hpp"
#include "effscript.hpp"
#include "mainloop.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "port_monster_limit.hpp"
#include "scenesnd.hpp"

namespace {

int  g_requested = 0;
int  g_monster_id = 0;
int  g_spawn_after_vsync = 2800;
bool g_done = false;

bool PrepareMonsterType(int monster_id) {
    if (ActiveMonster == nullptr || DngMainScene == nullptr) {
        return false;
    }

    mgCMemory *stack = DngMainScene->GetStack(3);
    if (stack == nullptr) {
        return false;
    }

    FxScriptMan->AllClearEffSpt();
    BuffEffectScriptData.ClearHeapMem();
    ActiveMonster->Initialize(DngMainScene);
    DngMainScene->AssignStack(3);
    DngMainScene->ClearStack(3);
    stack = DngMainScene->GetStack(3);

    u8       *manager = reinterpret_cast<u8 *>(ActiveMonster);
    int       offset = 0;
    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        u_long128 *buffer = stack->stAlloc64(0xFA0);
        mgCMemory *memory =
            reinterpret_cast<mgCMemory *>(manager + offset + offsetof(CMonsterMan, memory));
        memory->stSetBuffer(buffer, 0xFA0);
        memory->stack_used = 0;
        offset += static_cast<int>(sizeof(mgCMemory));
        memory->lock = false;
    }

    sndInitPort(SND_PORT_ENEMY);

    if (ActiveMonster->SearchBaseIndex(monster_id) < 0) {
        ActiveMonster->EntryRefer(monster_id, stack);
    }

    return ActiveMonster->SearchBaseIndex(monster_id) >= 0;
}

void SpawnOne(int refer_index, float dx, float dz) {
    CCharacter2 *player = DngMainScene->GetCharacter(0);
    if (player == nullptr) {
        return;
    }

    float spawn_position[4];
    float spawn_direction[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    player->GetPosition(spawn_position);
    spawn_position[0] += dx;
    spawn_position[2] += dz;
    ActiveMonster->SetActiveMonster(refer_index, spawn_position, spawn_direction, -1);
}

} // namespace

void GameSetBenchSpawnEnemies(int count, int monster_id, int after_vsync) {
    g_requested = std::max(0, count);
    g_monster_id = monster_id;
    g_spawn_after_vsync = std::max(0, after_vsync);
    g_done = false;
}

void GameBenchTrySpawnEnemies(int loop_mode) {
    if (g_done || g_requested <= 0 || loop_mode != LOOP_DUNGEON) {
        return;
    }
    if (DngStatus.mode != DNG_STATUS_FIELD) {
        return;
    }
    if (mgGetVSyncCount() < g_spawn_after_vsync) {
        return;
    }

    const int cap = PortMonsterActiveLimit();
    const int count = std::min(g_requested, cap);
    if (g_requested > cap) {
        std::fprintf(stderr,
                     "bench: --bench-spawn-enemies %d capped to %d (active monster limit); "
                     "enable Expanded dungeon monsters in PC settings for 60\n",
                     g_requested, cap);
    }

    if (!PrepareMonsterType(g_monster_id)) {
        std::fprintf(stderr, "bench: could not load monster id %d for spawn\n", g_monster_id);
        g_done = true;
        return;
    }

    const int refer = ActiveMonster->SearchBaseIndex(g_monster_id);
    constexpr int   columns = 6;
    constexpr float spacing = 2.5f;
    for (int i = 0; i < count; ++i) {
        const int   col = i % columns;
        const int   row = i / columns;
        const float dx = (static_cast<float>(col) - (columns - 1) * 0.5f) * spacing;
        const float dz = (static_cast<float>(row) - 1.5f) * spacing;
        SpawnOne(refer, dx, dz);
    }

    std::fprintf(stderr, "bench: spawned %d monsters (id %d) in a tight grid near the player\n", count, g_monster_id);
    g_done = true;
}
