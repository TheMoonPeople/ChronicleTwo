#include "common.h"

#include <cstdio>
#include <cstring>

#include "character.hpp"
#include "dataread.hpp"
#include "editmap.hpp"
#include "map.hpp"
#include "mapsky.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"

static int         LoadMapData(SCN_LOADMAP_INFO2 &info, int deferred);
extern char        at_958__2[];
static const u_int timer0_count = 0x10000000;
extern char        at_959__2[];

// Code (.text)
/**
 *
 * Loads each enabled map file into the scene stack, optionally through background I/O.
 *
 */
static int LoadMapData(SCN_LOADMAP_INFO2 &info, int deferred) {
    char       path[0x80];
    mgCMemory *stack = info.stack;
    u8        *load_buf = info.load_buf;
    int        result = 1;
    int        i;
    info.data_ready = 1;

    if (deferred != 0) {
        StartReadBG();
    }

    for (i = 0; i < SCN_LOADMAP_FILES_MAX; i++) {
        SCN_LOADMAP_INFO2::MapFiles *files = &info.files[i];
        int                          mpk_size;
        int                          sky_size;
        int                          ipk_size;
        int                          efp_size;
        int                          size;

        if (files->enable == 0) {
            break;
        }

        files->map_data = (char *) load_buf;
        strcpy(path, files->dir);
        strcat(path, files->map_name);
        strcat(path, ".map");

        if (deferred != 0) {
            result = LoadFileBG(path, (u_long128 *) files->map_data, &files->map_size);
        } else {
            result = LoadFile2(path, files->map_data, &files->map_size, 0);
        }

        size = files->map_size;
        int map_rest = size % 64;

        if (map_rest != 0) {
            size += 64 - map_rest;
        }

        load_buf += size / 16 * 16;
        files->cfg_data = (char *) load_buf;
        strcpy(path, files->dir);
        strcat(path, files->cfg_name);
        strcat(path, ".cfg");
        files->cfg_size = 0;

        if (deferred != 0) {
            LoadFileBG(path, (u_long128 *) files->cfg_data, &files->cfg_size);
        } else {
            LoadFile2(path, files->cfg_data, &files->cfg_size, 0);
        }

        size = files->cfg_size;
        int cfg_rest = size % 64;

        if (cfg_rest != 0) {
            size += 64 - cfg_rest;
        }

        load_buf += size / 16 * 16;
        files->mpk_data = (u_int *) load_buf;
        strcpy(path, files->dir);
        strcat(path, files->mpk_name);
        strcat(path, ".mpk");

        if (deferred != 0) {
            result &= LoadFileBG(path, (u_long128 *) files->mpk_data, &mpk_size);
        } else {
            result &= LoadFile2(path, files->mpk_data, &mpk_size, 0);
        }

        size = mpk_size;

        if (size % 64 != 0) {
            size += 64 - size % 64;
        }

        load_buf += size / 16 * 16;
        sky_size = 0;
        files->sky_data = (u_int *) load_buf;

        if (info.load_sky != 0) {
            strcpy(path, files->dir);
            strcat(path, files->sky_name);
            strcat(path, ".sky");
            char def_sky_path[0x20] = "map/";
            strcat(def_sky_path, files->def_sky_name);
            strcat(def_sky_path, ".sky");

            if (deferred != 0) {
                if (LoadFileBG(path, (u_long128 *) files->sky_data, &sky_size) == 0) {
                    files->sky_data = NULL;
                }
            } else if (LoadFile2(path, files->sky_data, &sky_size, 0) == 0 &&
                       LoadFile2(def_sky_path, files->sky_data, &sky_size, 0) == 0) {
                files->sky_data = NULL;
            }
        }

        size = sky_size;

        if (size % 64 != 0) {
            size += 64 - size % 64;
        }

        load_buf += size / 16 * 16;
        stack->Align64();
        strcpy(path, files->dir);
        strcat(path, files->ipk_name);
        strcat(path, ".ipk");
        files->ipk_data = (u_int *) stack->stGetTop();

        if (deferred != 0) {
            if (LoadFileBG(path, (u_long128 *) files->ipk_data, &ipk_size) != 0) {
                stack->Alloc(((u_int) ipk_size & 0xF) != 0 ? ((u_int) ipk_size >> 4) + 1 : (u_int) ipk_size >> 4);
            } else {
                files->ipk_data = NULL;
                result = 0;
            }
        } else if (LoadFile2(path, files->ipk_data, &ipk_size, 0) != 0) {
            stack->Alloc(((u_int) ipk_size & 0xF) != 0 ? ((u_int) ipk_size >> 4) + 1 : (u_int) ipk_size >> 4);
        } else {
            files->ipk_data = NULL;
            result = 0;
        }

        stack->Align64();
        strcpy(path, files->dir);
        strcat(path, files->efp_name);
        strcat(path, ".efp");
        files->efp_data = (u_int *) stack->stGetTop();

        if (deferred != 0) {
            if (LoadFileBG(path, (u_long128 *) files->efp_data, &efp_size) != 0) {
                stack->Alloc(((u_int) efp_size & 0xF) != 0 ? ((u_int) efp_size >> 4) + 1 : (u_int) efp_size >> 4);
            } else {
                files->efp_data = NULL;
            }
        } else if (LoadFile2(path, files->efp_data, &efp_size, 0) != 0) {
            stack->Alloc(((u_int) efp_size & 0xF) != 0 ? ((u_int) efp_size >> 4) + 1 : (u_int) efp_size >> 4);
        } else {
            files->efp_data = NULL;
        }
    }

    if (result == 0) {
        return 0;
    }

    return (int) load_buf;
}

void SCN_LOADMAP_INFO2::Initialize() {
    memset(this, 0, sizeof(*this));
}


#ifdef NONMATCHING
int CScene::LoadChara(int index, u_int *pack, char *name, mgCMemory *model_stack, mgCMemory *motion_stack, mgCMemory *image_stack, int image_block, int no_outline) {
    u_int       *files[1];
    int          sizes[1];
    CCharacter2 *chara = new (model_stack->Alloc(0x68)) CCharacter2;

    if (chara == NULL) {
        return -1;
    }

    DeleteChara(index);
    int slot = AssignChara(index, chara, at_958__2);

    if (slot < 0) {
        return -1;
    }

    CSceneCharacter *scene_chara = GetSceneCharacter(slot);

    if (scene_chara == NULL) {
        return -1;
    }

    scene_chara->status |= 1;

    if (name == NULL) {
        GetPackFileExt(pack, at_959__2, files, 1, sizes, &name);
    }

    chara->Initialize();

    if (no_outline != 0) {
        chara->LoadPackNoLine(pack, name, model_stack, motion_stack, image_stack, image_block, NULL);
    } else {
        chara->LoadPack(pack, name, model_stack, motion_stack, image_stack, image_block, NULL);
    }

    SetCharaTexb(slot, image_block);
    chara->sound_info.foot_se_bank = se_base_id;
    chara->sound_info.foot_sound_id = 0;
    return slot;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneload", LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii);
#endif

void CScene::DeleteChara(int index) {
    CSceneCharacter *chara;

    chara = GetSceneCharacter(index);

    if (chara != NULL) {
        chara->Initialize();
    }
}

#ifdef NONMATCHING
int CScene::CopyChara(int index, int source_index, mgCMemory *memory) {
    float        position[4];
    float        rotation[4];
    float        scale[4];
    CCharacter2 *chara;

    chara = new (memory->Alloc(0x68)) CCharacter2;

    if (chara == NULL) {
        return -1;
    }

    chara->Initialize();
    DeleteChara(index);
    int slot = AssignChara(index, chara, at_958__2);

    if (slot < 0) {
        return -1;
    }

    CSceneCharacter *scene_chara = GetSceneCharacter(slot);
    CSceneCharacter *source = GetSceneCharacter(source_index);

    if (scene_chara == NULL || source == NULL) {
        return slot;
    }

    scene_chara->status |= 1;
    scene_chara->texb = source->texb;
    CCharacter2 *original = source->chara;

    if (original == NULL) {
        return slot;
    }

    original->GetPosition(position);
    original->GetRotation(rotation);
    original->GetScale(scale);
    original->SetPosition(0.0f, 0.0f, 0.0f);
    original->SetRotation(0.0f, 0.0f, 0.0f);
    original->SetScale(1.0f, 1.0f, 1.0f);
    original->Copy(*chara, memory);
    original->SetPosition(position);
    original->SetRotation(rotation);
    original->SetScale(scale);
    return slot;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneload", CopyChara__6CSceneFiiP9mgCMemory);
#endif

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
int CScene::LoadMapFromMemory(int map_no, int step, SCN_LOADMAP_INFO2 *info) {
    CMap                        *map;
    mgCMemory                   *stack = info->stack;
    int                          tex_block = info->tex_block;
    SCN_LOADMAP_INFO2::MapFiles *add_files;
    u_int                        start_count;
    if (step == SCN_LOADMAP_STEP_CREATE) {
        CEditMap *edit_map;
        if (info->data_ready == 0) {
            return -1;
        }
        u8 *buf = info->load_buf;
        if (stack == NULL || buf == NULL) {
            return -1;
        }
        edit_map = new (stack->Alloc(0x111)) CEditMap;
        if (edit_map == NULL) {
            return -1;
        }
        edit_map->mds_list_set = &mds_list_set;
        return GetSceneMap(AssignMap(map_no, edit_map, info->name)) != NULL ? 1 : -1;
    }
    if (step == SCN_LOADMAP_STEP_MAP_INFO) {
        SCN_LOADMAP_INFO2::MapFiles *files;
        map = GetMap(map_no);
        files = &info->files[0];
        add_files = NULL;
        if (info->files[1].enable != 0) {
            add_files = &info->files[1];
        }
        map->map_info.LoadMapInfo(files->map_data, files->map_size, stack);
        if (add_files != NULL) {
            map->map_info.AddMapInfo(add_files->map_data, add_files->map_size, stack);
        }
        return SCN_LOADMAP_STEP_DATA;
    }
    if (step == SCN_LOADMAP_STEP_DATA) {
        CMap *map;
        SCN_LOADMAP_INFO2::MapFiles *files;
        int                          add_block_num;
        *(volatile u_int *) timer0_count;
        map = GetMap(map_no);
        files = &info->files[0];
        add_files = NULL;
        if (info->files[1].enable != 0) {
            add_files = &info->files[1];
        }
        int block = tex_block;
        add_block_num = 0;
        if (add_files != NULL) {
            map->LoadData(add_files->mpk_data, add_files->ipk_data, &block, stack);
            add_block_num += block;
            tex_block += block;
        }
        block = tex_block;
        map->LoadData(files->mpk_data, files->ipk_data, &block, stack);
        add_block_num += block;
        info->tex_block_num = add_block_num;
        return SCN_LOADMAP_STEP_EFFECT;
    }
    if (step == SCN_LOADMAP_STEP_EFFECT) {
        SCN_LOADMAP_INFO2::MapFiles *files;
        unsigned int                *efp_data;
        mgCTextureManager           *tex_manager;
        map = GetMap(map_no);
        files = &info->files[0];
        efp_data = files->efp_data;
        if (efp_data != NULL) {
            map->CreateEffect(efp_data, info->efp_tex_block, stack);
        }
        strcpy((tex_manager = &mgTexManager)->name_suffix, "1");
        if (map->map_info.sky_info != 0 && files->sky_data != NULL && info->sky_tex_block > 0) {
            CMapSky *sky;
            DeleteSky(0);
            if ((sky = (CMapSky *)operator new(sizeof(CMapSky), stack->Alloc(0x13))) != NULL) {
                sky->Initialize();
            }
            if (sky != NULL) {
                sky->LoadPack(files->sky_data, info->sky_tex_block, stack);
                AssignSky(0, sky, NULL);
            }
        }
        tex_manager->name_suffix[0] = 0;
        return SCN_LOADMAP_STEP_CREATE_MAP;
    }
    if (step == SCN_LOADMAP_STEP_CREATE_MAP) {
        start_count = *(volatile u_int *) timer0_count;
        map = GetMap(map_no);
        if (info->place_parts_max > 0) {
            map->SetPlacePartsBuff(stack, info->place_parts_max);
        }
        map->CreateMap(&mds_list_set, stack);
        printf("5:%d\n", *(volatile u_int *) timer0_count - start_count);
        return SCN_LOADMAP_STEP_FUNC_POINT;
    }
    if (step == SCN_LOADMAP_STEP_FUNC_POINT) {
        GetMap(map_no)->AssignFuncPoint(stack);
        return SCN_LOADMAP_STEP_CFG;
    }
    if (step == SCN_LOADMAP_STEP_CFG) {
        CMap *map;
        CSceneMap                   *slot;
        SCN_LOADMAP_INFO2::MapFiles *files;
        map = GetMap(map_no);
        slot = GetSceneMap(map_no);
        files = &info->files[0];
        if (files->cfg_size > 0) {
            map->LoadCfgFile(files->cfg_data, files->cfg_size, stack);
        }
        int num = info->tex_block_num;
        slot->tex_block = info->tex_block;
        slot->tex_block_num = num;
        slot->stack = stack;
        slot->status |= SCENE_DATA_LOADED;
        map->PlacePartsEnd();
        printf("remain %dkByte\n", stack->stGetRest() * 16 / 1024);
        return SCN_LOADMAP_STEP_CFG;
    }
    return -1;
}
template <>
void mgCObjectStack<CList<EMAP_MESSAGE> >::Initialize() {
    unk_8 = 0;
}
CMap::CMap() {
    Initialize();
}
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

#pragma inline_depth(0)

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

#pragma inline_depth reset

int CScene::DeleteMap(int map_index, int clear_stack) {
    mgCTextureManager *textures = &mgTexManager;
    CSceneMap         *slot;
    int                texture_count;
    int                index;
    CMap              *loaded_map;
    mgCMemory         *memory;
    int                texture_block;
    char              *file_name;
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
        file_name = loaded_map->map_info.GetImgName(index);

        if (file_name == NULL) {
            break;
        }

        if (CheckIMGName(map_index, file_name) == 0) {
            mds_list_set.DeleteIMG(file_name);
        }
    }

    for (index = 0;; index++) {
        file_name = loaded_map->map_info.GetPCPName(index);

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

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_958__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneload", at_959__2__DATA);
