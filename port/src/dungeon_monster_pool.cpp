#include "dungeon_monster_pool.hpp"

#include "character.hpp"
#include "dng_main.hpp"
#include "effscript.hpp"
#include "monster.hpp"
#include "scene.hpp"

#ifdef PORT
#include "arena_root.hpp"
#endif

namespace {

CActiveMonster *g_pool = nullptr;

#ifdef PORT
constexpr unsigned Align16Quadwords(unsigned bytes) {
    unsigned quads = bytes >> 4;
    if (bytes & 15) {
        quads += 1;
    }
    return quads + 2;
}

constexpr unsigned kMonsterPoolQuads = Align16Quadwords(static_cast<unsigned>(sizeof(CActiveMonster) * MONSTER_ACTIVE_MAX));
constexpr unsigned kFxScriptManQuads = Align16Quadwords(static_cast<unsigned>(sizeof(CEffectScriptMan)));
constexpr unsigned kMonsterManQuads = Align16Quadwords(static_cast<unsigned>(sizeof(CMonsterMan)));

static u_long128 g_monster_pool_storage[kMonsterPoolQuads];
static u_long128 g_fx_script_man_storage[kFxScriptManQuads];
static u_long128 g_monster_man_storage[kMonsterManQuads];

CEffectScriptMan *g_fx_script_man = nullptr;
CMonsterMan      *g_monster_man = nullptr;
#endif

} // namespace

#ifdef PORT
CActiveMonster *PortDungeonMonsterPool() {
    if (g_pool != nullptr) {
        return g_pool;
    }
    void *const mem = ArenaRoot(g_monster_pool_storage, kMonsterPoolQuads, "DungeonMonsterPool");
    g_pool = new (mem) CActiveMonster[MONSTER_ACTIVE_MAX];
    PortSetDungeonMonsterPool(g_pool);
    return g_pool;
}

CEffectScriptMan *PortDungeonFxScriptMan() {
    if (g_fx_script_man != nullptr) {
        return g_fx_script_man;
    }
    void *const mem = ArenaRoot(g_fx_script_man_storage, kFxScriptManQuads, "DungeonFxScriptMan");
    g_fx_script_man = new (mem) CEffectScriptMan;
    return g_fx_script_man;
}

CMonsterMan *PortDungeonMonsterMan() {
    if (g_monster_man != nullptr) {
        return g_monster_man;
    }
    void *const mem = ArenaRoot(g_monster_man_storage, kMonsterManQuads, "DungeonMonsterMan");
    g_monster_man = new (mem) CMonsterMan;
    return g_monster_man;
}
#endif

void PortSetDungeonMonsterPool(CActiveMonster *pool) { g_pool = pool; }

void PortReconnectDungeonMonsterSlots(CScene *scene) {
    if (scene == nullptr || g_pool == nullptr) {
        return;
    }

    for (int i = 0; i < MONSTER_ACTIVE_MAX; ++i) {
        const int idx = DNG_CHARA_SLOT_MONSTER + i;
        if (scene->GetCharacter(idx) == &g_pool[i]) {
            continue;
        }
        scene->AssignChara(idx, &g_pool[i], nullptr);
        scene->SetType(SCENE_DATA_CHARA, idx, SCENE_CHARA_TYPE_MONSTER);
    }
}
