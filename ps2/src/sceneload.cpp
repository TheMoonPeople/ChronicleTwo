#include "common.h"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "sceneload.hpp"
#include <cstring>
#include "dataread.hpp"
#include "map.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

int LoadMapData(SCN_LOADMAP_INFO2 &info, int deferred);

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneload", LoadMapData__FR17SCN_LOADMAP_INFO2i);
void SCN_LOADMAP_INFO2::Initialize(void) {
    memset(this, 0, sizeof(*this));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneload", LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii);
void CScene::DeleteChara(int index) {
    CSceneCharacter *chara;

    chara = GetSceneCharacter(index);
    if (chara != NULL) {
        chara->Initialize();
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneload", CopyChara__6CSceneFiiP9mgCMemory);
int CScene::LoadMapFromMemory(int map_no, SCN_LOADMAP_INFO2 *info) {
    int step = 0;
    int next;

    while (1) {
        next = LoadMapFromMemory(map_no, step, info);
        if (next < 0) {
            return -1;
        }
        if (next == step) {
            break;
        }
        step = next;
    }
    return map_no;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneload", LoadMapFromMemory__6CSceneFiiP17SCN_LOADMAP_INFO2);
template <>
void mgCObjectStack<CList<EMAP_MESSAGE> >::Initialize() {
    unk_8 = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneload", __ct__4CMapFv);
int CScene::LoadMapBGStep(SCN_LOADMAP_INFO2 *info) {
    int step;
    int result;

    if (bg_load_step == 0) {
        return 1;
    }
    if (ReadBGSync() != 0) {
        return 0;
    }
    if (bg_load_info.data_ready != 0) {
        step = bg_load_step - 1;
        result = LoadMapFromMemory(bg_load_info.map_no, step, &bg_load_info);
        if (result < 0) {
            return 0;
        }
        if (result == step) {
            bg_load_step = 0;
            return 1;
        }
        bg_load_step = result + 1;
        return 0;
    }
    return 1;
}
int CScene::LoadMap(int map_no, SCN_LOADMAP_INFO2 *info, int deferred) {
    ClearStack(info->stack_no);
    AssignStack(info->stack_no);
    info->stack = GetStack(info->stack_no);
    info->data_ready = 1;
    info->map_no = map_no;
    if (deferred != 0) {
        if (LoadMapData(*info, 1) != 0) {
            bg_load_info = *info;
            bg_load_step = 1;
            return 0;
        }
    } else {
        if (LoadMapData(*info, 0) != 0) {
            return LoadMapFromMemory(map_no, info);
        }
    }
    return -1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneload", __as__17SCN_LOADMAP_INFO2FRC17SCN_LOADMAP_INFO2);
int CScene::DeleteMap(int map_index, int clear_stack) {
    mgCTextureManager *textures = &mgTexManager;
    CSceneMap *slot;
    int texture_count;
    int index;
    CMap *loaded_map;
    mgCMemory *memory;
    int texture_block;
    char *file_name;
    slot = GetSceneMap(map_index);
    if (slot == NULL) {
        return 0;
    }
    loaded_map = GetMap(map_index);
    if (loaded_map == NULL) {
        return 0;
    }
    memory = slot->stack;
    memory->stack_used = 0;
    memory->lock = 0;
    texture_block = slot->tex_block;
    texture_count = slot->tex_block_num;
    if (texture_block >= 0 && texture_count > 0) {
        for (index = 0; index < texture_count; index++) {
            textures->DeleteBlock(texture_block + index);
        }
    }
    if (loaded_map->effect_list.block >= 0) {
        textures->DeleteBlock(loaded_map->effect_list.block);
    }
    for (index = 0;; index++) {
        file_name = loaded_map->GetImgName(index);
        if (file_name == NULL) {
            break;
        }
        if (CheckIMGName(map_index, file_name) == 0) {
            mds_list_set.DeleteIMG(file_name);
        }
    }
    for (index = 0;; index++) {
        file_name = loaded_map->GetPCPName(index);
        if (file_name == NULL) {
            break;
        }
        if (CheckMDSName(map_index, file_name) == 0) {
            mds_list_set.DeleteMdsList(file_name);
        }
    }
    slot->Initialize();
    loaded_map->Initialize();
    if (clear_stack == 0) {
        return 1;
    }
    for (index = 0; index < map_num; index++) {
        CSceneMap *other_slot = GetSceneMap(index);
        if (other_slot != NULL && other_slot->stack == memory) {
            DeleteMap(index, 0);
        }
    }
    return 1;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_820__6__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_885__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_886__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_887__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_888__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_889__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_890__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_958__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_959__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_1116__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_1117__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_1118__2__DATA);
