#include "common.h"

#include <cmath>
#include <cstdio>

#include "collision_assets.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "monster_memory.hpp"
#include "runscript.hpp"
#include "scene.hpp"
#include "snd_mngr.hpp"

PORT_OVERRIDE void CTreasureBoxManager::SetCollisionModel(u32 *model, mgCMemory *memory) {
    const auto path = DataReadBufferPath(model);
    col_frame = path ? LoadCollisionModel(*path, memory, "tbox_a") : nullptr;
}

void PrepareMonsterMemory(CMonsterMan &manager, mgCMemory &memory) {
    // Preserve the retail model budget and account for the two script arrays' wider entries.
    constexpr int extra_bytes = 128 * (sizeof(RS_STACKDATA) - 8) + 512 * (sizeof(RS_CALLDATA) - 12);
    constexpr int quadwords = 4000 + (extra_bytes + 15) / 16;
    for (auto &slot : manager.memory) {
        slot.stSetBuffer(memory.stAlloc64(quadwords), quadwords);
        slot.stReset();
        slot.lock = 0;
    }
}

PORT_OVERRIDE void LoadMonsterFile() {
    if (!ActiveMonster) {
        return;
    }
    ActiveMonster->Initialize(DngMainScene);
    DngMainScene->AssignStack(3);
    DngMainScene->ClearStack(3);
    auto *memory = DngMainScene->GetStack(3);
    if (!memory) {
        return;
    }
    PrepareMonsterMemory(*ActiveMonster, *memory);
    sndInitPort(5);
    auto &locate = ActiveMonster->locate;
    locate.num = locate.put_num = locate.put_flag = 0;
    for (int i = 0; i < MONSTER_LOCATE_MAX; ++i) {
        locate.param[i] = -1;
        locate.monster_id[i] = -1;
    }
    char path[76];
    std::snprintf(path, sizeof path, "dungeon/cfg_file/mos_place%d.cfg.json", DngSaveDataDungeon->stage_id);
    int size = 0;
    LoadFile(path, BuffReadData, &size);
    CreatMonsterFloorInfo(reinterpret_cast<char *>(BuffReadData), size);
    for (int i = 0; i < locate.num; ++i) {
        const int id = locate.monster_id[i];
        if (ActiveMonster->SearchBaseIndex(id) < 0) {
            ActiveMonster->EntryRefer(id, memory);
        }
    }
}

PORT_OVERRIDE void LoadMonsterFile(int monster_id, int initialize) {
    CScene      *scene = DngMainScene;
    CMonsterMan *manager = ActiveMonster;

    if (manager == nullptr) {
        return;
    }

    if (initialize != 0) {
        manager->Initialize(scene);
        scene->AssignStack(3);
        scene->ClearStack(3);
    }

    mgCMemory *memory = scene->GetStack(3);
    if (memory == nullptr) {
        return;
    }

    if (initialize != 0) {
        // Retail places these at +4 with a 0x30 stride; host pointers enlarge both fields.
        PrepareMonsterMemory(*manager, *memory);
        sndInitPort(5);
    }

    if (manager->SearchBaseIndex(monster_id) < 0) {
        manager->EntryRefer(monster_id, memory);
    }
}

// Retail's definition returns void against the fixed-up declaration (scripts/port/header_fixups.py).
PORT_OVERRIDE int CRedMarkModel::Draw() {
    float position[4];
    float saved_position[4];

    if (draw_request != 0) {
        GetPosition(position);
        GetPosition(saved_position);
        position[1] += 2.0f * sinf(angle);
        SetPosition(position);
        CObjectFrame::DrawDirect();
        SetPosition(saved_position);
        draw_request = false;
    }

    return 0;
}
