#include "common.h"

#include <cstdio>
#include <cstring>
#include <string>

#include "dataread.hpp"
#include "maintex.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "platform/model_assets.hpp"
#include "snd_mngr.hpp"
#include "sound_port.hpp"
#include "swordeffect.hpp"

PORT_OVERRIDE int CMonsterMan::LoadReferMonsterFile(int id, BASE_MONSTER_TBL *table, mgCMemory *memory) {
    const int slot = SearchReferBlock();
    if (slot < 0 || !table || !memory) {
        return false;
    }
    auto             &entry = refer[slot];
    const std::string model_path = "dungeon/monster/" + std::string(table->model) + ".gltf";
    const int         texture_block = slot + MONSTER_TEXB_REFER;
    model_assets::DeleteCharacterTextures(entry.chara, 0, CHARA_IMAGE_MAX - 1);
    mgTexManager.DeleteBlock(texture_block);
    std::strcpy(mgTexManager.name_suffix, "_m");
    entry.chara.Initialize();
    model_assets::CharacterLoadOptions options{memory, memory, memory, &mgTexManager, nullptr, texture_block};
    options.outline = std::strcmp(table->model, "b11a") != 0 && std::strcmp(table->model, "b05a") != 0 && std::strcmp(table->model, "b07a") != 0 && std::strcmp(table->model, "b02a") != 0;
    std::string error;
    const bool  loaded = model_assets::LoadCharacter(entry.chara, model_path, table->model, options, error);
    mgTexManager.name_suffix[0] = 0;
    if (!loaded) {
        std::fprintf(stderr, "monster: %s\n", error.c_str());
        return false;
    }
    entry.chara.tbl = table;
    int sound = -1;
    if (table->sound_no > 0) {
        char path[64];
        std::snprintf(path, sizeof(path), "snd2/mon/en_%03d.sound.json", table->sound_no);
        sound = static_cast<int>(SoundLoadBundlePath(SND_PORT_ENEMY, path, memory));
    }
    entry.chara.sound_info.se_bank = sound;
    for (int index = 0; index < table->sw_effect_num; ++index) {
        entry.chara.sword_effect[index] = new (memory->Alloc(0xC)) CSWordAfterEffect;
        entry.chara.sword_effect[index]->Initialize(memory, 0xC, 8);
        entry.chara.sword_effect[index]->SetTexture(0x4A, TEX_SystemEffectSw, 0, 0x20, 0x40, 0x20);
    }
    std::string script_path = "dungeon/monster/" + std::string(table->script) + ".stb";
    int         size = 0;
    if (!LoadFile2(script_path.data(), nullptr, &size, LOAD_FILE_SIZE) || size <= 0) {
        return false;
    }
    const int sectors = size / 2048 + (size % 2048 != 0);
    entry.script = reinterpret_cast<char *>(memory->stAlloc64(sectors * 128));
    if (!entry.script || !LoadFile2(script_path.data(), entry.script, nullptr, LOAD_FILE_READ)) {
        return false;
    }
    entry.id = id;
    return true;
}
