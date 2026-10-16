#include "dungeon_monster_pool.hpp"

#include "character.hpp"
#include "dng_main.hpp"
#include "monster.hpp"
#include "scene.hpp"

namespace {

CActiveMonster *g_pool = nullptr;

} // namespace

void PortSetDungeonMonsterPool(CActiveMonster *pool) { g_pool = pool; }

void PortReconnectDungeonMonsterSlots(CScene *scene) {
    if (scene == nullptr || g_pool == nullptr) {
        return;
    }

    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        const int idx = DNG_CHARA_SLOT_MONSTER + i;
        if (scene->GetCharacter(idx) != nullptr) {
            continue;
        }
        scene->AssignChara(idx, &g_pool[i], nullptr);
        scene->SetType(SCENE_DATA_CHARA, idx, SCENE_CHARA_TYPE_MONSTER);
    }
}
