#include "common.h"
#include "mw_runtime.h"

#include <cstring>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "effscript.hpp"
#include "map.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "runscript_opcodes.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"

/**
 *
 * Effect vector viewed as four floats or a quadword.
 *
 */
union EffectVector {
    u_long128 quad;      /**< The vector as a quadword. */
    float     values[4]; /**< Floating point components. */
};

#include <cmath>
#include <cstdio>
#include <cstdlib>

#include "character.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "snd_mngr.hpp"

extern "C" _EFF_SCRIPT *now_script;
extern "C" int (*ext_func__4[256])(RS_STACKDATA *, int);
extern CColPrimMan     ColPrimMan;
EFF_SPT_BASE_DEF      *GetEffSptBaseDefPtr(int index);
int                    SetEffectScript(CRunScript *script, char *program, mgCMemory *memory);
void                   SetEffectScriptFunc();
static void            DrawEffSptSprite(_EFF_SCRIPT *script, mgCTexture *texture, float *offset, mgC3DSprite *renderer, CMapLightingInfo *lighting);
extern RS_EXTFUNC_INFO ext_func_info__4[];
extern char            at_3644[];
extern char            at_3645[];

extern float at_2311[];

extern float at_2498__2[];

extern char at_943__3[];

extern char at_1127__2[];

extern char at_1128__3[];

extern char at_1129__2[];

extern char at_1143[];

extern char at_1144[];

extern char at_1145[];

extern char at_1336__2[];

extern char at_1337__2[];

extern char at_1338__2[];

extern char at_1339__3[];

extern char at_1340__2[];

extern char at_1341__2[];

extern char at_1655__5[];

extern char at_1705[];

extern char at_2025__3[];

extern char at_3398[];

extern char at_3495[];

extern char at_3536[];

/**
 *
 * Rounds a byte count up to a number of 16-byte blocks.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 0xF) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

extern char at_3303__2[];

// Code (.text)
void CEffectScriptMan::Initialize(mgCMemory *memory, int texb_start, int texb_num) {
    int                i;
    int                j;
    mgCTextureManager *manager;
    int                bank;

    this->memory = memory;
    load_buffer = 0;
    work_memory = 0;
    level = 0;

    for (i = 0; i < EFF_SPT_BASE_MAX; i++) {
        base[i] = 0;
    }

    base_num = 0;

    for (i = 0; i < EFF_SPT_OWNER_MAX; i++) {
        for (j = 0; j < EFF_SPT_OWNER_SLOT_MAX; j++) {
            slot[i][j] = 0;
        }
    }

    now = 0;
    this->texb_start = texb_start;
    this->texb_num = texb_num;
    texb_used = 0;
    tail = 0;
    head = 0;
    now_scene = GetMainScene();
    SetEffectScriptFunc();
    level_texb_used[0] = 0;
    level_texb_used[1] = 0;
    level_texb_used[2] = 0;
    level_texb_used[3] = 0;
    manager = &mgTexManager;

    for (bank = this->texb_start; bank < this->texb_start + this->texb_num; bank++) {
        manager->DeleteBlock(bank);
    }
}

void CEffectScriptMan::SetWorkBuffer(mgCMemory *memory) {
    if (memory != NULL) {
        work_memory = memory;
    }
}

int CEffectScriptMan::SearchBaseNo(char *name) {
    int index = 0;

    while (true) {
        EFF_SPT_BASE_DEF *base = GetEffSptBaseDefPtr(index);

        if (base == 0) {
            return -1;
        }

        if (strcmp(base->name, name) == 0) {
            return index;
        }

        index++;
    }
}

int CEffectScriptMan::LoadBaseEffSpt(int base_no, mgCMemory *memory, int level) {
    char path[0x80];
    char pack[0x80];
    int  path_size;
    int  pack_size;
    int  path_buffer;
    int  pack_buffer;

    for (int i = 0; i < EFF_SPT_BASE_MAX; i++) {
        if (base[i] != 0 && base[i]->base_no == base_no) {
            return 0;
        }
    }

    path_buffer = (int) load_buffer;

    if (path_buffer == 0) {
        return -1;
    }

    if (GetNeedFilePath(base_no, path, pack) == 0) {
        return -1;
    }

    if (LoadFile2(path, (void *) path_buffer, &path_size, 0) == 0) {
        path_size = 0;
        pack_buffer = (int) load_buffer;
        path_buffer = 0;
    } else {
        int rest = path_size & 0x3F;
        int pad = rest != 0 ? 0x40 - rest : 0;
        pack_buffer = path_buffer + ((path_size + pad) & -0x10);
    }

    if (LoadFile2(pack, (void *) pack_buffer, &pack_size, 0) == 0) {
        return -1;
    }

    return BuildBase(base_no, (u_long128 *) path_buffer, path_size, (u_long128 *) pack_buffer, pack_size, memory,
                     level);
}

int CEffectScriptMan::LoadBaseEffSpt(char *name, mgCMemory *memory, int level) {
    return LoadBaseEffSpt(SearchBaseNo(name), memory, level);
}

void CEffectScriptMan::ClearBaseFromLevel(int level, int *cleared, int max) {
    int count;
    ClearEffectFromLevel(level);
    count = 0;

    for (int i = 0; i < EFF_SPT_BASE_MAX; i++) {
        if (base[i] != 0 && base[i]->level == level) {
            if (cleared != 0 && base[i]->texb_owned != 0 && count < max) {
                cleared[count++] = base[i]->texb;
            }

            if (base[i]->texb_owned != 0) {
                texb_used--;
            }

            base[i] = 0;
        }
    }

    if (level > 0 && level < 4) {
        texb_used -= level_texb_used[level];
        level_texb_used[level] = 0;
    }

    if (texb_used < 0) {
        texb_used = 0;
    }

    if (cleared != 0 && count < max) {
        cleared[count] = -1;
    } else if (cleared != 0) {
        printf(at_943__3);
        cleared[count - 1] = -1;
    }
}

CCharacter2 *CEffectScriptMan::GetBaseChara(int base_no) {
    for (int i = 0; i < EFF_SPT_BASE_MAX; i++) {
        if (base[i] != 0) {
            EFF_SPT_BASE_DEF *current = GetEffSptBaseDefPtr(base[i]->base_no);

            if (current == 0) {
                return 0;
            }

            EFF_SPT_BASE_DEF *wanted = GetEffSptBaseDefPtr(base_no);

            if (wanted == 0) {
                return 0;
            }

            if (current->type == 0 && strcmp(current->file, wanted->file) == 0) {
                return base[i]->chara;
            }
        }
    }

    return 0;
}

CCharacter2 *CEffectScriptMan::GetBaseChara(char *name) {
    return GetBaseChara(SearchBaseNo(name));
}

int CEffectScriptMan::GetNotUsedTexb() {
    int used = texb_used;

    if (used >= texb_num) {
        return -1;
    }

    return texb_start + used;
}

void CEffectScriptMan::AddTexb() {
    int count = texb_used;

    if (count < texb_num) {
        texb_used = count + 1;
        level_texb_used[level] = level_texb_used[level] + 1;
    }
}

extern char at_1099__2[];
extern char at_1100[];
extern char at_1101[];
extern char at_1102__2[];
extern char at_1103__5[];
extern char at_1104__7[];

#ifdef NONMATCHING
int CEffectScriptMan::BuildBase(int base_no, u_long128 *data, int data_size, u_long128 *script, int script_size, mgCMemory *work, int texb) {
    mgCMemory *memory;

    if (work == NULL) {
        memory = this->memory;
    } else {
        memory = work;
    }

    if (memory == NULL) {
        printf(at_1099__2);
        return -1;
    }

    for (int i = 0; i < EFF_SPT_BASE_MAX; i++) {
        if (base[i] != NULL && base[i]->base_no == base_no) {
            return 0;
        }
    }

    EFF_SPT_BASE_DEF *definition = GetEffSptBaseDefPtr(base_no);

    if (definition == NULL) {
        printf(at_1100, base_no);
        return -1;
    }

    int index;

    for (index = 0; index < EFF_SPT_BASE_MAX; index++) {
        if (base[index] == NULL) {
            break;
        }
    }

    if (index >= EFF_SPT_BASE_MAX) {
        printf(at_1101);
        return -1;
    }

    int texture_block = texb;

    if (texb <= -1) {
        if (texb_used >= texb_num) {
            printf(at_1102__2);
            return -1;
        }

        texture_block = texb_start + texb_used;
    }

    if (texture_block < texb_start || texture_block >= texb_start + texb_num) {
        printf(at_1103__5, texb_start, texb_num, texture_block);
        return -1;
    }

    mgCTextureManager *textures = &mgTexManager;
    memory->lock = 0;
    memory->Align64();
    base[index] = new (memory->Alloc(4)) EFF_SPT_BASE;

    if (base[index] != NULL) {
        base[index]->base_no = base_no;
        base[index]->work_size = 0x7D;
        base[index]->work_size += 0x24;
        base[index]->texb_owned = 0;

        switch (definition->type) {
            case EFF_SPT_BASE_CHR:
                base[index]->chara = NULL;

                if (data != NULL) {
                    CCharacter2 *source = GetBaseChara(base_no);
                    CCharacter2 *model;

                    model = new (memory->Alloc(0x68)) CCharacter2;

                    base[index]->chara = model;
                    base[index]->chara->Initialize();

                    if (source != NULL) {
                        source->Copy(*base[index]->chara, memory);
                        base[index]->texb = source->texture_block;
                        base[index]->texb_owned = 0;
                    } else {
                        base[index]->texb = texture_block;

                        if (texb <= -1) {
                            textures->DeleteBlock(base[index]->texb);
                        }

                        base[index]->chara->LoadPackNoLine((u_int *) data, at_1104__7, memory, memory, memory, base[index]->texb, NULL);

                        if (texb <= -1) {
                            texb_used++;
                            base[index]->texb_owned = 1;
                        }

                        CCharacter2 copy;
                        mgCMemory   copy_memory;
                        copy_memory.stSetBuffer(load_buffer, 300000);
                        base[index]->chara->Copy(copy, &copy_memory);
                    }

                    base[index]->work_size += base[index]->chara->GetCopySize();
                }

                break;
            case EFF_SPT_BASE_IMG:
                base[index]->chara = NULL;
                mgCTexture *texture = textures->GetTexture(definition->file, -1);

                if (texture != NULL) {
                    base[index]->texb = texture->block;
                    base[index]->texb_owned = 0;
                } else {
                    base[index]->texb = texture_block;

                    if (texb <= -1) {
                        textures->DeleteBlock(base[index]->texb);
                    }

                    int        size = data_size / 16 + 1;
                    u_long128 *image = memory->stAllocTest(size);

                    if (image != NULL) {
                        memory->stAlloc64(size);
                        memcpy(image, data, data_size);
                        textures->EnterIMGFile((u_char *) image, base[index]->texb, memory, NULL);

                        if (texb <= -1) {
                            texb_used++;
                            base[index]->texb_owned = 1;
                        }
                    } else {
                        base[index]->texb = -1;
                        base[index]->texb_owned = 0;
                        return 0;
                    }
                }

                break;
        }
    }

    base[index]->script = (char *) memory->stAlloc64(script_size / 16 + 1);

    if (base[index]->script != NULL) {
        memcpy(base[index]->script, script, script_size);
    }

    base[index]->level = level;
    base_num++;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effscript", BuildBase__16CEffectScriptManFiP1iP1iP9mgCMemoryi);
#endif

int CEffectScriptMan::BuildBase(char *name, u_long128 *path_file, int path_size, u_long128 *pack_file,
                                int pack_size, mgCMemory *memory, int level) {
    return BuildBase(SearchBaseNo(name), path_file, path_size, pack_file, pack_size, memory, level);
}

int CEffectScriptMan::BuildPack(int base_no, u_int *pack, mgCMemory *memory, int level) {
    char              path[0x20];
    char              pack_path[0x20];
    int               path_size;
    int               pack_size;
    EFF_SPT_BASE_DEF *base = GetEffSptBaseDefPtr(base_no);

    if (base == 0) {
        return -1;
    }

    switch (base->type) {
        case 0:
            sprintf(path, at_1127__2, base->file);
            break;
        case 1:
            sprintf(path, at_1128__3, base->file);
            break;
    }

    sprintf(pack_path, at_1129__2, base->script);
    u_int *path_file = GetPackFile(pack, path, &path_size);
    u_int *pack_file = GetPackFile(pack, pack_path, &pack_size);
    return BuildBase(base_no, (u_long128 *) path_file, path_size, (u_long128 *) pack_file, pack_size, memory, level);
}

int CEffectScriptMan::BuildPack(char *name, u_int *pack, mgCMemory *memory, int level) {
    return BuildPack(SearchBaseNo(name), pack, memory, level);
}

int CEffectScriptMan::GetNeedFilePath(int base_no, char *path, char *pack) {
    EFF_SPT_BASE_DEF *base = GetEffSptBaseDefPtr(base_no);

    if (base == 0) {
        return 0;
    }

    switch (base->type) {
        case 0:
            sprintf(path, at_1143, base->file);
            break;
        case 1:
            sprintf(path, at_1144, base->file);
            break;
    }

    sprintf(pack, at_1145, base->script);
    return 1;
}

int CEffectScriptMan::GetNeedFilePath(char *name, char *path, char *pack) {
    return GetNeedFilePath(SearchBaseNo(name), path, pack);
}

#ifdef NONMATCHING
_EFF_SCRIPT *CEffectScriptMan::CreateEffSpt(int base_no, int group, int register_in_group) {
    EFF_SPT_BASE *base;
    int           slot;
    _EFF_SCRIPT  *script;
    u_long128    *token;
    base = NULL;

    if (base_num <= 0) {
        printf(at_1336__2);
        return NULL;
    }

    for (int i = 0; i < EFF_SPT_BASE_MAX; i++) {
        if (this->base[i] != NULL && this->base[i]->base_no == base_no) {
            base = this->base[i];
            break;
        }
    }

    if (base == NULL) {
        printf(at_1337__2);
        now = NULL;
        return NULL;
    }

    if (work_memory == NULL) {
        printf(at_1338__2);
        now = NULL;
        return NULL;
    }

    slot = -1;

    if (register_in_group == 1) {
        slot = 0;

        if (group <= -1) {
            return NULL;
        }

        for (; slot < EFF_SPT_OWNER_SLOT_MAX; slot++) {
            if (this->slot[group][slot] == NULL) {
                break;
            }
        }

        if (slot == EFF_SPT_OWNER_SLOT_MAX) {
            printf(at_1339__3);
            now = NULL;
            return NULL;
        }
    }

    token = work_memory->StartStackMode((int) MG_STACK_MODE_FIT, base->work_size);

    if (token == 0) {
        printf(at_1340__2, work_memory->stack_size - work_memory->stack_used);
        now = NULL;
        return NULL;
    }

    script = new (work_memory->Alloc(0x17)) _EFF_SCRIPT;

    script->work = token;
    script->texb = base->texb;
    script->level = base->level;
    script->sprite = NULL;
    script->sprite_num = 0;
    strcpy(script->tex_name, at_1341__2);
    script->chara_work = NULL;

    if (base->chara != NULL) {
        CCharacter2 *chara;

        chara = new (work_memory->Alloc(0x68)) CCharacter2;

        script->chara = chara;
        script->chara->Initialize();
        base->chara->Copy(*script->chara, work_memory);
        base->work_size = base->chara->GetCopySize();
        base->work_size = base->work_size + 0x7D;
        base->work_size = base->work_size + 0x24;
        ((CCharacter2 *) script->chara)->SetPosition(0.0f, -10000.0f, 0.0f);
        ((CCharacter2 *) script->chara)->SetRotation(0.0f, 0.0f, 0.0f);
    } else {
        script->chara = NULL;
    }

    ((&script->run))->ext_func(ext_func__4, 0x100);
    SetEffectScript(&script->run, base->script, (mgCMemory *) work_memory);
    script->prog_no = 200;
    script->user_id = group;
    script->slot = slot;
    script->work_vect1[0] = 0.0f;
    script->work_vect1[1] = 0.0f;
    script->work_vect1[2] = 0.0f;
    script->work_vect1[3] = 1.0f;
    script->work_vect2[0] = 0.0f;
    script->work_vect2[1] = 0.0f;
    script->work_vect2[2] = 0.0f;
    script->work_vect2[3] = 1.0f;
    script->target_id = -1;
    script->origin[0] = 0.0f;
    script->origin[1] = 0.0f;
    script->origin[2] = 0.0f;
    script->origin[3] = 0.0f;
    script->auto_offset = 0;
    memset(script->offset_frame, 0, sizeof(script->offset_frame));

    for (int i = 0; i < EFF_SPT_VALUE_MAX; i++) {
        script->value[i].i = 0;
    }

    script->sub_chara[0] = NULL;
    script->sub_chara[1] = NULL;
    script->sub_chara[2] = NULL;
    script->sub_chara[3] = NULL;
    script->sub_chara_work = NULL;
    script->colprim = NULL;
    script->light_flag = 0;
    script->state = 0;
    script->next = NULL;
    script->prev = NULL;
    work_memory->stAlign64();
    work_memory->EndStackMode();

    if (register_in_group == 1) {
        this->slot[group][slot] = script;
    }

    _EFF_SCRIPT *cursor = head;

    if (cursor == NULL) {
        head = script;
        tail = script;
        tail->next = NULL;
        tail->prev = NULL;
        head->next = NULL;
        head->prev = NULL;
    } else if (cursor != NULL) {
        do {
            if (cursor->texb > script->texb) {
                script->prev = cursor->prev;
                script->next = cursor;

                if (cursor->prev != NULL) {
                    cursor->prev->next = script;
                } else {
                    head = script;
                }

                cursor->prev = script;
                break;
            } else {
                _EFF_SCRIPT *following = cursor->next;

                if (following == NULL) {
                    cursor->next = script;
                    script->prev = cursor;
                    tail = script;
                    break;
                }

                cursor = following;
            }
        } while (cursor != NULL);
    }

    now = script;
    return script;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effscript", CreateEffSpt__16CEffectScriptManFiii);
#endif

int CEffectScriptMan::CreateEffSpt(char *name, int user_id, int use_slot) {
    _EFF_SCRIPT *effect = CreateEffSpt(SearchBaseNo(name), user_id, use_slot);

    if (effect != NULL) {
        return effect->slot;
    }

    return -1;
}

void CEffectScriptMan::ClearEffectFromChrid(int chrid) {
    _EFF_SCRIPT *script = head;

    if (script != 0) {
        do {
            if (script->user_id == chrid) {
                _EFF_SCRIPT *doomed = script;
                script = script->next;
                DeleteEffSpt(doomed);
            } else {
                script = script->next;
            }
        } while (script != 0);
    }
}

void CEffectScriptMan::ClearEffectFromLevel(int level) {
    _EFF_SCRIPT *script = head;

    if (script != 0) {
        do {
            if (script->level == level) {
                _EFF_SCRIPT *doomed = script;
                script = script->next;
                DeleteEffSpt(doomed);
            } else {
                script = script->next;
            }
        } while (script != 0);
    }
}

void CEffectScriptMan::DeleteEffSpt(_EFF_SCRIPT *script) {
    if (script == 0 || work_memory == 0) {
        return;
    }

    if (script->prev != 0) {
        script->prev->next = script->next;
    } else {
        head = script->next;

        if (head != 0) {
            head->prev = 0;
        }
    }

    if (script->next != 0) {
        script->next->prev = script->prev;
    } else {
        tail = script->prev;

        if (tail != 0) {
            tail->next = 0;
        }
    }

    if (now != 0 && script->work == now->work) {
        now = 0;
    }

    if (script->slot >= 0) {
        slot[script->user_id][script->slot] = 0;
    }

    if (script->colprim != 0) {
        script->colprim->Delete(script->user_id);
    }

    DeleteSprite(script->sprite);

    if (script->sub_chara_work != 0) {
        work_memory->Free(script->sub_chara_work);
    }

    if (script->chara_work != 0) {
        work_memory->Free(script->chara_work);
    }

    work_memory->Free(script->work);
}

int CEffectScriptMan::DeleteEffSpt(int group, int slot) {
    if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot < 0 || slot >= EFF_SPT_OWNER_SLOT_MAX) {
        return 0;
    }

    DeleteEffSpt(this->slot[group][slot]);
    return 1;
}

void CEffectScriptMan::AllClearEffSpt() {
    _EFF_SCRIPT *script = tail;

    if (script != 0) {
        while (script->prev != 0) {
            _EFF_SCRIPT *prev = script->prev;
            script = prev;
            DeleteEffSpt(prev->next);
        }

        DeleteEffSpt(script);
        tail = 0;
        head = 0;

        for (int group = 0; group < EFF_SPT_OWNER_MAX; group++) {
            for (int slot = 0; slot < EFF_SPT_OWNER_SLOT_MAX; slot++) {
                this->slot[group][slot] = 0;
            }
        }

        now = 0;
    }
}

void CEffectScriptMan::Step() {
    _EFF_SCRIPT *script = head;
    EffScriptMan = this;

    if (script != NULL) {
        do {
            now_script = script;

            if (script->state == EFF_SPT_STATE_HIDE_STOP || script->state == EFF_SPT_STATE_STOP) {
                script = script->next;
                continue;
            }

            if (script->state != EFF_SPT_STATE_SCRIPT_PAUSE) {
                if (script->prog_no != -1) {
                    if (script->run.check_program(script->prog_no)) {
                        if (script->run.run(script->prog_no) == 0) {
                            if (script->next == NULL) {
                                DeleteEffSpt(script);
                                script = NULL;
                            } else {
                                script = script->next;
                                DeleteEffSpt(script->prev);
                            }

                            continue;
                        }

                        script->prog_no = -1;
                    }
                } else {
                    script->run.resume();
                }
            }

            if (script->chara != NULL) {
                script->chara->Step();

                for (int character_index = 0; character_index < EFF_SPT_SUB_CHARA_MAX; character_index++) {
                    if (script->sub_chara[character_index] != NULL) {
                        script->sub_chara[character_index]->Step();
                    }
                }
            }

            if (script->sprite != NULL) {
                for (int sprite_index = 0; sprite_index < script->sprite_num; sprite_index++) {
                    _ES_SPRITE *sprite = &script->sprite[sprite_index];
                    sceVu0AddVector(sprite->pos, sprite->pos, sprite->velo_pos);
                    sceVu0AddVector(sprite->velo_pos, sprite->velo_pos, sprite->acc_pos);
                    sprite->rotz += sprite->velo_rotz;
                    sprite->rotz = mgAngleLimit(sprite->rotz);
                    sprite->velo_rotz += sprite->acc_rotz;

                    if (!(sprite->velo_rotz <= 6.2831855f)) {
                        sprite->velo_rotz = 6.2831855f;
                    }

                    sceVu0AddVector(sprite->color, sprite->color, sprite->velo_col);
                    sceVu0AddVector(sprite->velo_col, sprite->velo_col, sprite->acc_col);

                    if (sprite->color_conv_div > 0.0) {
                        sprite->color[0] += (sprite->color_target[0] - sprite->color[0]) / sprite->color_conv_div;
                        sprite->color[1] += (sprite->color_target[1] - sprite->color[1]) / sprite->color_conv_div;
                        sprite->color[2] += (sprite->color_target[2] - sprite->color[2]) / sprite->color_conv_div;
                        sprite->color[3] += (sprite->color_target[3] - sprite->color[3]) / sprite->color_conv_div;
                    }

                    sprite->scale[0] += sprite->velo_scl[0];
                    sprite->scale[1] += sprite->velo_scl[1];
                    sprite->velo_scl[0] += sprite->acc_scl[0];
                    sprite->velo_scl[1] += sprite->acc_scl[1];

                    if (sprite->scale_conv_div > 0.0) {
                        sprite->scale[0] += (sprite->scale_target[0] - sprite->scale[0]) / sprite->scale_conv_div;
                        sprite->scale[1] += (sprite->scale_target[1] - sprite->scale[1]) / sprite->scale_conv_div;
                    }
                }
            }

            if (script->run.end) {
                if (script->next == NULL) {
                    DeleteEffSpt(script);
                    script = NULL;
                } else {
                    script = script->next;
                    DeleteEffSpt(script->prev);
                }
            } else {
                script = script->next;
            }
        } while (script != NULL);
    }

    now_script = NULL;
    now = NULL;
}

void CEffectScriptMan::Draw() {
    _EFF_SCRIPT       *script = head;
    mgCTextureManager *textures = &mgTexManager;
    CMap              *map = now_scene->GetMap(now_scene->active_map);
    CMapLightingInfo   lighting;

    if (map != NULL) {
        map->GetLightInfo(&lighting);
    }

    if (script != NULL) {
        do {
            if (script->state == EFF_SPT_STATE_HIDE_STOP || script->state == EFF_SPT_STATE_HIDE) {
                script = script->next;
                continue;
            }

            if (script->chara != NULL) {
                sceVu0FVECTOR offset;

                if (script->auto_offset && (script->target_id >= 0 || script->target_id < 128)) {
                    CCharacter2 *character = now_scene->GetCharacter(script->target_id);

                    if (character != NULL) {
                        sceVu0FVECTOR character_position;
                        character->GetPosition(character_position);

                        if (strcmp(script->offset_frame, at_1341__2) != 0) {
                            mgCFrame *frame = character->CObjectFrame::frame;

                            if (frame != NULL) {
                                frame = frame->SearchFrame(script->offset_frame);

                                if (frame != NULL) {
                                    sceVu0FVECTOR frame_position;
                                    frame->GetWorldPosition0(frame_position);
                                    *(u_long128 *) character_position = *(u_long128 *) frame_position;
                                }
                            }
                        }

                        *(u_long128 *) offset = *(u_long128 *) character_position;
                    } else {
                        offset[0] = 0.0f;
                        offset[1] = 0.0f;
                        offset[2] = 0.0f;
                        offset[3] = 0.0f;
                    }
                } else {
                    offset[0] = 0.0f;
                    offset[1] = 0.0f;
                    offset[2] = 0.0f;
                    offset[3] = 0.0f;
                }

                sceVu0AddVector(offset, offset, script->origin);
                offset[3] = 0.0f;
                textures->ReloadTexture(script->texb, (sceVif1Packet *) NULL);
                sceVu0FVECTOR position;
                script->chara->GetPosition(position);
                sceVu0AddVector(position, position, offset);
                position[3] = 1.0f;
                script->chara->SetPosition(position);
                script->chara->DrawDirect();
                sceVu0SubVector(position, position, offset);
                position[3] = 1.0f;
                script->chara->SetPosition(position);

                for (int character_index = 0; character_index < EFF_SPT_SUB_CHARA_MAX; character_index++) {
                    if (script->sub_chara[character_index] != NULL) {
                        sceVu0FVECTOR sub_position;
                        script->sub_chara[character_index]->GetPosition(sub_position);
                        sceVu0AddVector(sub_position, sub_position, offset);
                        sub_position[3] = 1.0f;
                        script->sub_chara[character_index]->SetPosition(sub_position);
                        script->sub_chara[character_index]->DrawDirect();
                        sceVu0SubVector(sub_position, sub_position, offset);
                        sub_position[3] = 1.0f;
                        script->sub_chara[character_index]->SetPosition(sub_position);
                    }
                }
            }

            script = script->next;
        } while (script != NULL);
    }

    script = head;

    if (script != NULL) {
        do {
            if (script->state == EFF_SPT_STATE_HIDE_STOP || script->state == EFF_SPT_STATE_HIDE) {
                script = script->next;
                continue;
            }

            if (script->sprite != NULL) {
                sceVu0FVECTOR offset;

                if (script->auto_offset && (script->target_id >= 0 || script->target_id < 128)) {
                    CCharacter2 *character = now_scene->GetCharacter(script->target_id);

                    if (character != NULL) {
                        sceVu0FVECTOR character_position;
                        character->GetPosition(character_position);

                        if (strcmp(script->offset_frame, at_1341__2) != 0) {
                            mgCFrame *frame = character->CObjectFrame::frame;

                            if (frame != NULL) {
                                frame = frame->SearchFrame(script->offset_frame);

                                if (frame != NULL) {
                                    sceVu0FVECTOR frame_position;
                                    frame->GetWorldPosition0(frame_position);
                                    *(u_long128 *) character_position = *(u_long128 *) frame_position;
                                }
                            }
                        }

                        *(u_long128 *) offset = *(u_long128 *) character_position;
                    } else {
                        offset[0] = 0.0f;
                        offset[1] = 0.0f;
                        offset[2] = 0.0f;
                        offset[3] = 0.0f;
                    }
                } else {
                    offset[0] = 0.0f;
                    offset[1] = 0.0f;
                    offset[2] = 0.0f;
                    offset[3] = 0.0f;
                }

                sceVu0AddVector(offset, offset, script->origin);
                offset[3] = 0.0f;
                textures->ReloadTexture(script->texb, (sceVif1Packet *) NULL);
                mgCTexture *texture = textures->GetTexture(script->tex_name, script->texb);

                if (texture != NULL) {
                    sprite.Initialize();
                    sprite.BeginCreatePacket(1, NULL);
                    DrawEffSptSprite(script, texture, offset, &sprite, &lighting);
                    sprite.EndCreatePacket();
                    sceVu0FMATRIX matrix;
                    mgUnitMatrix(matrix);
                    mgDrawDirect(&sprite, matrix);
                }
            }

            script = script->next;
        } while (script != NULL);
    }
}

_ES_SPRITE *CEffectScriptMan::AssignSprite(int count) {
    if (work_memory == 0) {
        return 0;
    }

    u_int size = count * sizeof(_ES_SPRITE);
    u_int blocks = align16_blocks(size) + 3;

    if (work_memory->StartStackMode((int) MG_STACK_MODE_FIT, blocks) == 0) {
        printf(at_1655__5, blocks);
        return 0;
    }

    _ES_SPRITE *sprite = (_ES_SPRITE *) operator new[](
        size, work_memory->Alloc(align16_blocks(size) + 2));

    memset(sprite, 0, blocks);
    work_memory->stAlign64();
    work_memory->EndStackMode();
    return sprite;
}

void CEffectScriptMan::DeleteSprite(_ES_SPRITE *sprite) {
    mgCMemory *memory = work_memory;

    if (memory == 0 || sprite == 0) {
        return;
    }

    memory->Free((u_long128 *) sprite);
}

#ifdef NONMATCHING
int CEffectScriptMan::AssignCharacter(_EFF_SCRIPT *script, int count) {
    if (count > EFF_SPT_SUB_CHARA_MAX) {
        return 0;
    }

    int        size = count * (script->chara->GetCopySize() + 0x68);
    u_long128 *token = work_memory->StartStackMode((int) MG_STACK_MODE_FIT, size);

    if (token == 0) {
        printf(at_1705, size);
        return 0;
    }

    for (int i = 0; i < count; i++) {
        CCharacter2 *chara;

        chara = new (work_memory->Alloc(0x68)) CCharacter2;

        script->sub_chara[i] = chara;
        script->chara->Copy(*script->sub_chara[i], work_memory);
    }

    script->sub_chara_work = token;
    work_memory->stAlign64();
    work_memory->EndStackMode();
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effscript", AssignCharacter__16CEffectScriptManFP11_EFF_SCRIPTi);
#endif

int CEffectScriptMan::SetScriptProgNo(int prog_no, int group, int slot) {
    if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot < 0 || slot >= EFF_SPT_OWNER_SLOT_MAX) {
        return 0;
    }

    _EFF_SCRIPT *script = this->slot[group][slot];

    if (script == 0) {
        return 0;
    }

    script->prog_no = prog_no;
    return 1;
}

int CEffectScriptMan::Pause(int state, int group, int slot) {
    if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot < 0 || slot >= EFF_SPT_OWNER_SLOT_MAX) {
        return 0;
    }

    _EFF_SCRIPT *script = this->slot[group][slot];

    if (script == 0) {
        return 0;
    }

    script->state = state;
    return 1;
}

void CEffectScriptMan::PauseFromLevel(int level, int state) {
    _EFF_SCRIPT *script = head;

    if (script != NULL) {
        do {
            if (script->level == level) {
                script->state = state;
            }

            script = script->next;
        } while (script != NULL);
    }
}

int CEffectScriptMan::SetScriptVect1(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        *(u_long128 *) script->work_vect1 = *(u_long128 *) vect;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        *(u_long128 *) first->work_vect1 = *(u_long128 *) vect;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::GetScriptVect1(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        *(u_long128 *) vect = *(u_long128 *) script->work_vect1;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        *(u_long128 *) vect = *(u_long128 *) first->work_vect1;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetScriptVect2(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        *(u_long128 *) script->work_vect2 = *(u_long128 *) vect;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        *(u_long128 *) first->work_vect2 = *(u_long128 *) vect;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::GetScriptVect2(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        *(u_long128 *) vect = *(u_long128 *) script->work_vect2;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        *(u_long128 *) vect = *(u_long128 *) first->work_vect2;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetScriptTargetId(int target_id, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        script->target_id = target_id;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        first->target_id = target_id;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::GetScriptTargetId(int &target_id, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        target_id = script->target_id;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        target_id = first->target_id;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetScriptUserId(int user_id, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        script->user_id = user_id;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        first->user_id = user_id;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::GetScriptUserId(int &user_id, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        user_id = script->user_id;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        user_id = first->user_id;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetColPrim(CColPrim *colprim, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        script->colprim = colprim;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        first->colprim = colprim;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetValue(int index, int value, int group, int slot) {
    if (index < 0 || index >= EFF_SPT_VALUE_MAX) {
        return 0;
    }

    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        script->value[index].i = value;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        first->value[index].i = value;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetValue(int index, float value, int group, int slot) {
    if (index < 0 || index >= EFF_SPT_VALUE_MAX) {
        return 0;
    }

    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        script->value[index].f = value;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        first->value[index].f = value;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetOrigin(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        *(u_long128 *) script->origin = *(u_long128 *) vect;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        *(u_long128 *) first->origin = *(u_long128 *) vect;
        return 1;
    }

    return 0;
}

CCharacter2 *CEffectScriptMan::GetCharacter(int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script != 0) {
            return script->chara;
        }

        return 0;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        return first->chara;
    }

    return 0;
}

#ifdef NONMATCHING
int CEffectScriptMan::SetCharacter(CCharacter2 *source, int group, int slot) {
    int        chara_blocks = (source)->GetCopySize() + 0x68;
    u_long128 *token = work_memory->StartStackMode((int) MG_STACK_MODE_FIT, chara_blocks);

    if (token == 0) {
        printf(at_2025__3);
        return 0;
    }

    CCharacter2 *chara;

    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT **entry = (_EFF_SCRIPT **) ((slot << 2) + ((group << 5) + (int) this) + 0x184);

        if (*entry == 0) {
            return 0;
        }

        chara = new (work_memory->Alloc(0x68)) CCharacter2;

        (*entry)->chara = chara;
        source->Copy(*(*entry)->chara, work_memory);
        (*entry)->chara_work = token;
    } else {
        if (now != 0) {
            chara = new (work_memory->Alloc(0x68)) CCharacter2;

            now->chara = chara;
            source->Copy(*now->chara, work_memory);
            now->chara_work = token;
        } else {
            return 0;
        }
    }

    work_memory->stAlign64();
    work_memory->EndStackMode();
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/effscript", SetCharacter__16CEffectScriptManFP11CCharacter2ii);
#endif

int CEffectScriptMan::SetTexb(int texb, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == 0) {
            return 0;
        }

        script->texb = texb;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != 0) {
        first->texb = texb;
        return 1;
    }

    return 0;
}

/**
 *
 * Returns a nonempty effect script base definition by index.
 *
 */
EFF_SPT_BASE_DEF *GetEffSptBaseDefPtr(int index) {
    if (index < 0) {
        return 0;
    }

    EFF_SPT_BASE_DEF *base = eff_spt_base_def + index;
    return strcmp(base->name, at_1341__2) == 0 ? 0 : base;
}

extern EffectVector at_2067;

/**
 *
 * Draws visible effect sprites with their color, lighting, and alpha settings.
 *
 */
static void DrawEffSptSprite(_EFF_SCRIPT *script, mgCTexture *texture, sceVu0FVECTOR offset, mgC3DSprite *renderer, CMapLightingInfo *lighting) {
    _ES_SPRITE *sprites = script->sprite;
    int         count = script->sprite_num;
    int         alpha = sprites->alpha;
    mgCDrawEnv  environment(*mgGetpDrawEnv(0));
    sceGsTest  *test = &environment.test;
    int         component;
    test->bits.zte = 1;
    test->bits.ztst = 2;
    environment.SetZBuf(MG_ZBUF_NO_WRITE);
    environment.SetAlpha(alpha);
    renderer->CPSetDrawEnv(&environment);
    renderer->CPSetTexture(texture);
    renderer->BeginCPSprite();

    for (int i = 0; i < count; i++) {
        if (sprites[i].draw_flag != 0) {
            _ES_SPRITE *sprite = &sprites[i];

            if (alpha != sprite->alpha) {
                alpha = sprite->alpha;
                renderer->EndCPSprite();
                mgCDrawEnv next_environment(*mgGetpDrawEnv(0));
                sceGsTest *next_test = &next_environment.test;
                next_test->bits.zte = 1;
                next_test->bits.ztst = 2;
                next_environment.SetZBuf(MG_ZBUF_NO_WRITE);
                next_environment.SetAlpha(alpha);
                renderer->CPSetDrawEnv(&next_environment);
                renderer->CPSetTexture(texture);
                renderer->BeginCPSprite();
            }

            EffectVector  size = at_2067;
            sceVu0FVECTOR uv0, uv1, position;
            sceVu0FVECTOR color;
            mgZeroVector(uv0);
            mgZeroVector(uv1);
            sceVu0AddVector(position, sprite->pos, offset);
            position[3] = 1.0f;
            *(u_long128 *) color = *(u_long128 *) sprite->color;

            if (0.0f != sprite->blink_speed) {
                for (component = 0; component < 4; component++) {
                    color[component] += sinf(sprite->blink_phase) * sprite->blink_amp[component];

                    if (color[component] < 0.0f) {
                        color[component] = 0.0f;
                    }

                    if (color[component] > 255.0f) {
                        color[component] = 255.0f;
                    }
                }

                sprite->blink_phase += sprite->blink_speed;
                sprite->blink_phase = mgAngleLimit(sprite->blink_phase);
            } else {
                for (int component = 0; component < 4; component++) {
                    if (color[component] < 0.0f) {
                        color[component] = 0.0f;
                    }

                    if (color[component] > 255.0f) {
                        color[component] = 255.0f;
                    }
                }
            }

            if (script->light_flag) {
                sceVu0FMATRIX light_direction, light_color;
                sceVu0FVECTOR ambient;
                mgGetLight(light_direction, light_color);
                mgGetAmbient(ambient);
                color[0] = 0.3 * light_color[0][0] + ambient[0];
                color[1] = light_color[0][1] * 0.3 + ambient[1];
                color[2] = light_color[0][2] * 0.3 + ambient[2];
            }

            size.values[0] = sprite->put_size[0] * sprite->scale[0];
            size.values[1] = sprite->put_size[1] * sprite->scale[1];
            size.values[2] = mgAngleLimit(sprite->rotz);
            uv0[0] = sprite->uv[0];
            uv0[1] = sprite->uv[1];
            uv1[0] = sprite->uv[0] + sprite->uv[2];
            uv1[1] = sprite->uv[1] + sprite->uv[3];
            renderer->CPSetSprite(position, size.values, color, uv0, uv1);
        }
    }

    renderer->EndCPSprite();
}

/**
 *
 * Returns an effect sprite at a valid slot index.
 *
 */
static _ES_SPRITE *GetSpritePtr(_EFF_SCRIPT *script, int index) {
    if (script == 0 || index >= script->sprite_num) {
        return 0;
    }

    return &script->sprite[index];
}

/**
 *
 * Reads an effect script argument as an integer.
 *
 */
static int GetStackInt(RS_STACKDATA *slot) {
    if (slot->type == 1) {
        return fptosi(*(float *) &slot->val.i);
    }

    return slot->val.i;
}

/**
 *
 * Reads an effect script argument as a float.
 *
 */
static float GetStackFloat(RS_STACKDATA *slot) {
    if (slot->type == 0) {
        return (float) slot->val.i;
    }

    return *(float *) &slot->val.i;
}

/**
 *
 * Reads three effect script values into a homogeneous vector.
 *
 */
static void GetStackVector(float *vector, RS_STACKDATA *slot) {
    vector[0] = GetStackFloat(slot++);
    vector[1] = GetStackFloat(slot++);
    vector[2] = GetStackFloat(slot);
    vector[3] = 1.0f;
}

/**
 *
 * Returns the string address stored in an effect script slot.
 *
 */
static char *GetStackString(RS_STACKDATA *slot) {
    return reinterpret_cast<char *>(slot->val.i);
}

/**
 *
 * Writes an integer through an effect script reference slot.
 *
 */
static void SetStack(RS_STACKDATA *slot, int value) {
    if (slot->type == 3) {
        slot->val.p->val.i = value;
    }
}

/**
 *
 * Writes a float through an effect script reference slot.
 *
 */
static void SetStack(RS_STACKDATA *slot, float value) {
    if (slot->type == 3) {
        slot->val.p->val.f = value;
    }
}

/**
 *
 * Writes a zero vector to three effect script outputs.
 *
 */
static int _ZERO_VECTOR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    SetStack(stack++, 0.0f);
    SetStack(stack++, 0.0f);
    SetStack(stack, 0.0f);
    return 1;
}

/**
 *
 * Normalizes a vector stored in three effect script outputs.
 *
 */
static int _NORMAL_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float vector[4];

    if (argument_count != 3) {
        return 0;
    }

    vector[0] = stack->val.p->val.f;
    vector[1] = (stack + 1)->val.p->val.f;
    vector[2] = (stack + 2)->val.p->val.f;
    vector[3] = 1.0f;
    sceVu0Normalize(vector, vector);
    SetStack(stack++, vector[0]);
    SetStack(stack++, vector[1]);
    SetStack(stack, vector[2]);
    return 1;
}

/**
 *
 * Copies three script vector components to output slots.
 *
 */
static int _COPY_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float vector[4];

    if (argument_count != 6) {
        return 0;
    }

    GetStackVector(vector, stack + 3);
    SetStack(stack++, vector[0]);
    SetStack(stack++, vector[1]);
    SetStack(stack, vector[2]);
    return 1;
}

/**
 *
 * Adds a script vector to three output components.
 *
 */
static int _ADD_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float vector[4];

    if (argument_count != 6) {
        return 0;
    }

    GetStackVector(vector, stack + 3);
    SetStack(stack, stack->val.p->val.f + vector[0]);
    SetStack(stack + 1, (stack + 1)->val.p->val.f + vector[1]);
    SetStack(stack + 2, (stack + 2)->val.p->val.f + vector[2]);
    return 1;
}

/**
 *
 * Subtracts a script vector from three output components.
 *
 */
static int _SUB_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float vector[4];

    if (argument_count != 6) {
        return 0;
    }

    GetStackVector(vector, stack + 3);
    SetStack(stack, stack->val.p->val.f - vector[0]);
    SetStack(stack + 1, (stack + 1)->val.p->val.f - vector[1]);
    SetStack(stack + 2, (stack + 2)->val.p->val.f - vector[2]);
    return 1;
}

/**
 *
 * Scales three output vector components by a script value.
 *
 */
static int _SCALE_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float scale;

    if (argument_count != 4) {
        return 0;
    }

    scale = GetStackFloat(stack + 3);
    SetStack(stack, stack->val.p->val.f * scale);
    SetStack(stack + 1, (stack + 1)->val.p->val.f * scale);
    SetStack(stack + 2, (stack + 2)->val.p->val.f * scale);
    return 1;
}

/**
 *
 * Divides three output vector components by a nonzero script value.
 *
 */
static int _DIV_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float divisor;

    if (argument_count != 4) {
        return 0;
    }

    divisor = GetStackFloat(stack + 3);

    if (divisor == 0.0f) {
        return 0;
    }

    SetStack(stack, stack->val.p->val.f / divisor);
    SetStack(stack + 1, (stack + 1)->val.p->val.f / divisor);
    SetStack(stack + 2, (stack + 2)->val.p->val.f / divisor);
    return 1;
}

/**
 *
 * Returns the length of a script vector.
 *
 */
static int _DIST_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float vector[3];

    if (argument_count != 4) {
        return 0;
    }

    GetStackVector(vector, stack);
    stack += 3;
    SetStack(stack++, mgDistVector(vector));
    return 1;
}

/**
 *
 * Returns the distance between two script vectors.
 *
 */
static int _DIST_VECTOR2(RS_STACKDATA *stack, int argument_count) {
    float from[3];
    float to[3];

    if (argument_count != 7) {
        return 0;
    }

    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);
    stack += 6;
    SetStack(stack++, mgDistVector(from, to));
    return 1;
}

/**
 *
 * Returns the square root of a script value.
 *
 */
static int _SQRT(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    float value = GetStackFloat(stack++);
    SetStack(stack, (float) sqrt(value));
    return 1;
}

/**
 *
 * Returns the angle of two script values using atan2.
 *
 */
static int _ATAN2F(RS_STACKDATA *stack, int argument_count) {
    float y;
    float x;

    if (argument_count != 3) {
        return 0;
    }

    y = GetStackFloat(stack++);
    x = GetStackFloat(stack++);
    SetStack(stack, atan2f(y, x));
    return 1;
}

/**
 *
 * Compares two script angles with a supplied tolerance.
 *
 */
static int _ANGLE_CMP(RS_STACKDATA *stack, int argument_count) {
    float a;
    float b;
    float c;

    if (argument_count != 4) {
        return 0;
    }

    a = GetStackFloat(stack++);
    b = GetStackFloat(stack++);
    c = GetStackFloat(stack++);
    SetStack(stack, mgAngleCmp(a, b, c));
    return 1;
}

/**
 *
 * Wraps a script angle into the engine angle range.
 *
 */
static int _ANGLE_LIMIT(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    SetStack(stack, mgAngleLimit(stack->val.p->val.f));
    return 1;
}

/**
 *
 * Returns a random integer or float within a script range.
 *
 */
static int _GET_RAND(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    if (stack->type == 1) {
        float range = GetStackFloat(stack++);
        SetStack(stack, range * (float) rand() / 2147483648.0f);
        return 1;
    }

    int range = GetStackInt(stack++);
    int value = fptosi((float) range * (float) rand() / 2147483648.0f);
    SetStack(stack, value);
    return 1;
}

/**
 *
 * Returns the yaw or full rotation from one script position to another.
 *
 */
static int _GET_REF_ROT(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 7 && argument_count != 9) {
        return 0;
    }

    float from[4];
    float dir[4];
    GetStackVector(from, stack);
    GetStackVector(dir, stack + 3);
    stack += 6;
    sceVu0SubVector(dir, dir, from);
    sceVu0Normalize(dir, dir);
    float *z = &dir[2];
    float  yaw = atan2f(dir[0], *z);
    float  pitch = -atan2f(dir[1], sqrtf(dir[0] * dir[0] + *z * *z));

    switch (argument_count) {
        case 7:
            SetStack(stack, yaw);
            break;
        case 9:
            SetStack(stack++, pitch);
            SetStack(stack++, yaw);
            SetStack(stack, 0.0f);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Returns a direction vector from scripted rotation angles.
 *
 */
int _GET_DIR_VECTOR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 6) {
        return 0;
    }

    float matrix[4][4];
    float rot[4];
    float dir[4];
    *(EffectVector *) dir = *(EffectVector *) at_2311;
    GetStackVector(rot, stack);
    stack += 3;
    rot[0] = mgAngleLimit(rot[0]);
    float *y = &rot[1];
    *y = mgAngleLimit(*y);
    float *z = &rot[2];
    *z = mgAngleLimit(*z);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixX(matrix, matrix, rot[0]);
    sceVu0RotMatrixY(matrix, matrix, *y);
    sceVu0ApplyMatrix(dir, matrix, dir);
    SetStack(stack++, dir[0]);
    SetStack(stack++, dir[1]);
    SetStack(stack, dir[2]);
    return 1;
}

/**
 *
 * Sets the origin offset of the current effect script.
 *
 */
int _SET_ORIGIN(RS_STACKDATA *stack, int argument_count) {
    now_script->origin[0] = GetStackFloat(stack++);
    now_script->origin[1] = GetStackFloat(stack++);
    now_script->origin[2] = GetStackFloat(stack);
    now_script->origin[3] = 0.0f;
    return 1;
}

/**
 *
 * Returns the origin offset of the current effect script.
 *
 */
int _GET_ORIGIN(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    SetStack(stack++, now_script->origin[0]);
    SetStack(stack++, now_script->origin[1]);
    SetStack(stack, now_script->origin[2]);
    return 1;
}

/**
 *
 * Configures automatic effect offset from a named frame.
 *
 */
int _AUTO_SET_OFFSET(RS_STACKDATA *stack, int argument_count) {
    char *name = 0;
    int   offset = GetStackInt(stack++);

    if (argument_count >= 2) {
        name = GetStackString(stack);
    }

    now_script->auto_offset = offset;

    if (name != 0) {
        strcpy(now_script->offset_frame, name);
    } else {
        strcpy(now_script->offset_frame, at_1341__2);
    }

    return 1;
}

/**
 *
 * Returns the first work vector of the current effect script.
 *
 */
int _GET_WORK_VECT1(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    SetStack(stack++, now_script->work_vect1[0]);
    SetStack(stack++, now_script->work_vect1[1]);
    SetStack(stack, now_script->work_vect1[2]);
    return 1;
}

/**
 *
 * Returns the second work vector of the current effect script.
 *
 */
int _GET_WORK_VECT2(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    SetStack(stack++, now_script->work_vect2[0]);
    SetStack(stack++, now_script->work_vect2[1]);
    SetStack(stack, now_script->work_vect2[2]);
    return 1;
}

/**
 *
 * Returns the target character identifier of the current effect script.
 *
 */
int _GET_TARGET_ID(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    SetStack(stack, now_script->target_id);
    return 1;
}

/**
 *
 * Returns the user identifier of the current effect script.
 *
 */
int _GET_USER_ID(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    SetStack(stack, now_script->user_id);
    return 1;
}

/**
 *
 * Returns a typed value from the current effect script.
 *
 */
int _GET_VALUE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    RS_STACKDATA *result_slot = stack + 1;
    int           index = GetStackInt(stack);

    if (result_slot->type != 3) {
        return 0;
    }

    switch (result_slot->val.p->type) {
        case 0: {
            _EFF_SCRIPT *script = now_script;
            SetStack(result_slot, script->value[index].i);
            break;
        }
        case 1: {
            _EFF_SCRIPT *script = now_script;
            SetStack(result_slot, script->value[index].f);
            break;
        }
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Stores a typed value in the current effect script.
 *
 */
int _SET_VALUE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int           index;
    RS_STACKDATA *value_slot = stack + 1;
    index = GetStackInt(stack);

    if (value_slot->type == 3) {
        return 0;
    }

    switch (value_slot->type) {
        case 0: {
            int          int_value = GetStackInt(value_slot);
            _EFF_SCRIPT *script = now_script;
            script->value[index].i = int_value;
            break;
        }
        case 1: {
            float        float_value = GetStackFloat(value_slot);
            _EFF_SCRIPT *script = now_script;
            script->value[index].f = float_value;
            break;
        }
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Changes primary effect character visibility with optional fading.
 *
 */
int _CHR_SET_SHOW(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    int           show;
    int           fade = 0;
    RS_STACKDATA *next = stack + 1;
    show = GetStackInt(stack);

    if (argument_count >= 2) {
        fade = GetStackInt(next++);

        if (argument_count == 3) {
            GetStackFloat(next);
        }
    }

    now_script->chara->Show(show);
    now_script->chara->fade = 1;
    now_script->chara->fade_speed = 0.1f;

    if (fade == 1 && show == 1) {
        now_script->chara->fade_alpha = 0.0001f;
    } else if (fade == 1 && show == 0) {
        now_script->chara->fade_alpha = 1.0f;
    }

    return 1;
}

/**
 *
 * Returns primary effect character visibility and fade state.
 *
 */
int _CHR_GET_SHOW(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1 && argument_count != 2) {
        return 0;
    }

    if (now_script->chara == 0) {
        return 0;
    }

    SetStack(stack++, now_script->chara->GetShow());

    if (argument_count == 2) {
        SetStack(stack, now_script->chara->fade);
    }

    return 1;
}

/**
 *
 * Sets the primary effect character position.
 *
 */
int _CHR_SET_POS(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    float vector[4];
    GetStackVector(vector, stack);
    now_script->chara->SetPosition(vector);
    return 1;
}

/**
 *
 * Returns the primary effect character position.
 *
 */
int _CHR_GET_POS(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    if (now_script->chara == 0) {
        return 0;
    }

    float pos[4];
    now_script->chara->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Turns the primary effect character toward a rotation over optional steps.
 *
 */
int _CHR_SET_ROT(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    float rot[4];
    float current[4];
    int   steps = 1;
    GetStackVector(rot, stack);
    stack += 3;

    if (argument_count >= 4) {
        steps = GetStackInt(stack++);
    }

    now_script->chara->GetRotation(current);
    sceVu0SubVector(rot, rot, current);
    rot[0] = mgAngleLimit(rot[0]);
    float *y = &rot[1];
    *y = mgAngleLimit(*y);
    float *z = &rot[2];
    *z = mgAngleLimit(*z);
    sceVu0DivVector(rot, rot, (float) steps);
    sceVu0AddVector(rot, rot, current);
    rot[0] = mgAngleLimit(rot[0]);
    *y = mgAngleLimit(*y);
    *z = mgAngleLimit(*z);
    rot[3] = 1.0f;
    now_script->chara->SetRotation(rot);
    return 1;
}

/**
 *
 * Returns the primary effect character rotation.
 *
 */
int _CHR_GET_ROT(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    if (now_script->chara == 0) {
        return 0;
    }

    float rot[4];
    now_script->chara->GetRotation(rot);
    SetStack(stack++, rot[0]);
    SetStack(stack++, rot[1]);
    SetStack(stack, rot[2]);
    return 1;
}

/**
 *
 * Sets the primary effect character scale.
 *
 */
int _CHR_SET_SCALE(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    float vector[4];
    GetStackVector(vector, stack);
    now_script->chara->SetScale(vector);
    return 1;
}

/**
 *
 * Returns the primary effect character scale.
 *
 */
int _CHR_GET_SCALE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    if (now_script->chara == 0) {
        return 0;
    }

    float scale[4];
    now_script->chara->GetScale(scale);
    SetStack(stack++, scale[0]);
    SetStack(stack++, scale[1]);
    SetStack(stack, scale[2]);
    return 1;
}

/**
 *
 * Starts a named motion on the primary effect character.
 *
 */
int _CHR_SET_MOTION(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    int   mode = 0;
    float step = -1.0f;
    char *name = GetStackString(stack++);

    if (argument_count >= 2) {
        step = GetStackFloat(stack++);
    }

    if (argument_count >= 3) {
        mode = GetStackInt(stack);
    }

    now_script->chara->SetMotion(name, mode);

    if (step >= 0.0f) {
        now_script->chara->SetStep(step);
    }

    return 1;
}

/**
 *
 * Sets primary effect character motion playback speed.
 *
 */
int _CHR_SET_MOT_STEP(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    (now_script)->chara->SetStep(GetStackFloat(stack));
    return 1;
}

/**
 *
 * Returns the current motion frame wait of the primary effect character.
 *
 */
int _CHR_GET_MOT_WAIT(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    CCharacter2 *chara = now_script->chara;

    if (chara == 0) {
        return 0;
    }

    SetStack(stack, chara->GetNowFrameWait());
    return 1;
}

/**
 *
 * Returns the primary effect character facing direction.
 *
 */
int _CHR_GET_DIR_VECTOR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    if (now_script->chara == 0) {
        return 0;
    }

    float matrix[4][4];
    float rot[4];
    float dir[4];
    *(EffectVector *) dir = *(EffectVector *) at_2498__2;
    sceVu0UnitMatrix(matrix);
    now_script->chara->GetRotation(rot);
    sceVu0RotMatrixX(matrix, matrix, rot[0]);
    sceVu0RotMatrixY(matrix, matrix, rot[1]);
    sceVu0ApplyMatrix(dir, matrix, dir);
    SetStack(stack++, dir[0]);
    SetStack(stack++, dir[1]);
    SetStack(stack, dir[2]);
    return 1;
}

/**
 *
 * Returns rotation toward a point from the primary effect character.
 *
 */
int _CHR_GET_REF_ROT(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 4 && argument_count != 6) {
        return 0;
    }

    if (now_script->chara == 0) {
        return 0;
    }

    float dir[4];
    float pos[4];
    GetStackVector(dir, stack);
    stack += 3;
    now_script->chara->GetPosition(pos);
    sceVu0SubVector(dir, dir, pos);
    sceVu0Normalize(dir, dir);
    float *z = &dir[2];
    float  yaw = atan2f(dir[0], *z);
    float  pitch = -atan2f(dir[1], sqrtf(dir[0] * dir[0] + *z * *z));

    switch (argument_count) {
        case 4:
            SetStack(stack, yaw);
            break;
        case 6:
            SetStack(stack++, pitch);
            SetStack(stack++, yaw);
            SetStack(stack, 0.0f);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Offsets the primary effect character position.
 *
 */
int _CHR_ADD_POS(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    float offset[4];
    float pos[4];
    GetStackVector(offset, stack);
    now_script->chara->GetPosition(pos);
    sceVu0AddVector(pos, pos, offset);
    now_script->chara->SetPosition(pos);
    return 1;
}

/**
 *
 * Offsets the primary effect character rotation.
 *
 */
int _CHR_ADD_ROT(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    float offset[4];
    float rot[4];
    GetStackVector(offset, stack);
    now_script->chara->GetRotation(rot);
    sceVu0AddVector(rot, rot, offset);
    rot[0] = mgAngleLimit(rot[0]);
    float *y = &rot[1];
    *y = mgAngleLimit(*y);
    float *z = &rot[2];
    *z = mgAngleLimit(*z);
    rot[3] = 1.0f;
    now_script->chara->SetRotation(rot);
    return 1;
}

/**
 *
 * Calculates and discards a primary effect character scale offset.
 *
 */
int _CHR_ADD_SCALE(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    float offset[4];
    float scale[4];
    GetStackVector(offset, stack);
    now_script->chara->GetScale(scale);
    sceVu0AddVector(scale, scale, offset);

    now_script->chara->GetScale(scale);
    return 1;
}

/**
 *
 * Assigns the primary character to another effect script slot.
 *
 */
int _CHR_COPY_CHARA(RS_STACKDATA *stack, int argument_count) {
    if (now_script->chara == 0) {
        return 0;
    }

    return EffScriptMan->AssignCharacter(now_script, GetStackInt(stack));
}

/**
 *
 * Sets a secondary effect character position.
 *
 */
int _CHR_SET_POS2(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt(stack++);

    if (now_script->sub_chara[index] == 0) {
        return 0;
    }

    float vector[4];
    GetStackVector(vector, stack);
    now_script->sub_chara[index]->SetPosition(vector);
    return 1;
}

/**
 *
 * Sets a secondary effect character rotation.
 *
 */
int _CHR_SET_ROT2(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt(stack++);

    if (now_script->sub_chara[index] == 0) {
        return 0;
    }

    float vector[4];
    GetStackVector(vector, stack);
    now_script->sub_chara[index]->SetRotation(vector);
    return 1;
}

/**
 *
 * Sets a secondary effect character scale.
 *
 */
int _CHR_SET_SCALE2(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt(stack++);

    if (now_script->sub_chara[index] == 0) {
        return 0;
    }

    float vector[4];
    GetStackVector(vector, stack);
    now_script->sub_chara[index]->SetScale(vector);
    return 1;
}

/**
 *
 * Starts a named motion on a secondary effect character.
 *
 */
int _CHR_SET_MOTION2(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt(stack++);

    if (now_script->sub_chara[index] == 0) {
        return 0;
    }

    int   mode = 0;
    float step = -1.0f;
    char *name = GetStackString(stack++);

    if (argument_count >= 2) {
        step = GetStackFloat(stack++);
    }

    if (argument_count >= 3) {
        mode = GetStackInt(stack);
    }

    now_script->sub_chara[index]->SetMotion(name, mode);

    if (step >= 0.0f) {
        now_script->sub_chara[index]->SetStep(step);
    }

    return 1;
}

/**
 *
 * Offsets a secondary effect character position.
 *
 */
int _CHR_ADD_POS2(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt(stack++);

    if (now_script->sub_chara[index] == 0) {
        return 0;
    }

    float offset[4];
    float pos[4];
    GetStackVector(offset, stack);
    now_script->sub_chara[index]->GetPosition(pos);
    sceVu0AddVector(pos, pos, offset);
    now_script->sub_chara[index]->SetPosition(pos);
    return 1;
}

/**
 *
 * Offsets a secondary effect character rotation.
 *
 */
int _CHR_ADD_ROT2(RS_STACKDATA *stack, int argument_count) {
    int           index;
    RS_STACKDATA *next = stack + 1;
    index = GetStackInt(stack);

    if (now_script->sub_chara[index] == 0) {
        return 0;
    }

    float delta[4];
    float rot[4];
    GetStackVector(delta, next);
    now_script->sub_chara[index]->GetRotation(rot);
    sceVu0AddVector(rot, rot, delta);
    rot[0] = mgAngleLimit(rot[0]);
    float *y = &rot[1];
    *y = mgAngleLimit(*y);
    float *z = &rot[2];
    *z = mgAngleLimit(*z);
    rot[3] = 1.0f;
    now_script->sub_chara[index]->SetRotation(rot);
    return 1;
}

/**
 *
 * Offsets a secondary effect character scale.
 *
 */
int _CHR_ADD_SCALE2(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt(stack++);

    if (now_script->sub_chara[index] == 0) {
        return 0;
    }

    float offset[4];
    float scale[4];
    GetStackVector(offset, stack);
    now_script->sub_chara[index]->GetScale(scale);
    sceVu0AddVector(scale, scale, offset);
    now_script->sub_chara[index]->SetScale(scale);
    return 1;
}

/**
 *
 * Changes secondary effect character visibility with optional fading.
 *
 */
int _CHR_SET_SHOW2(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt(stack++);

    if (now_script->sub_chara[index] == 0) {
        return 0;
    }

    int show;
    int fade = 0;
    show = GetStackInt(stack++);

    if (argument_count >= 3) {
        fade = GetStackInt(stack++);

        if (argument_count == 4) {
            GetStackFloat(stack);
        }
    }

    now_script->sub_chara[index]->Show(show);
    now_script->sub_chara[index]->fade = 1;
    now_script->sub_chara[index]->fade_speed = 0.1f;

    if (fade == 1 && show == 1) {
        now_script->sub_chara[index]->fade_alpha = 0.0001f;
    } else if (fade == 1 && show == 0) {
        now_script->sub_chara[index]->fade_alpha = 1.0f;
    }

    return 1;
}

/**
 *
 * Returns the world position of a named primary character frame.
 *
 */
int _CHR_GET_FRAME_POS(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 4) {
        return 0;
    }

    if (now_script->chara == 0) {
        return 0;
    }

    RS_STACKDATA *result_slot = stack + 1;
    mgCFrame     *character_frame;
    mgCFrame     *frame;
    char         *name = GetStackString(stack);

    if ((character_frame = ((CObjectFrame *) now_script->chara)->frame) == 0) {
        return 0;
    }

    if ((frame = character_frame->SearchFrame(name)) == 0) {
        return 0;
    }

    float pos[4];
    frame->GetWorldPosition0(pos);
    SetStack(result_slot++, pos[0]);
    SetStack(result_slot++, pos[1]);
    SetStack(result_slot, pos[2]);
    return 1;
}

/**
 *
 * Changes the draw state of a named primary character frame.
 *
 */
int _CHR_SET_FRAME_SHOW(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    char     *name = GetStackString(stack++);
    int       show = GetStackInt(stack++);
    int       attr_mask = GetStackInt(stack);
    mgCFrame *character_frame = ((CObjectFrame *) now_script->chara)->frame;

    if (character_frame == 0) {
        return 0;
    }

    mgCFrame *frame;

    if ((frame = character_frame->SearchFrame(name)) == 0) {
        return 0;
    }

    mgCFrameAttr attr;
    attr.draw = show;
    frame->SetAttrParam(attr, attr_mask, 1);
    return 1;
}

/**
 *
 * Reports whether the primary effect character motion has ended.
 *
 */
int _CHR_CHK_MOT_END(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    CCharacter2 *chara = now_script->chara;

    if (chara == 0) {
        return 0;
    }

    SetStack(stack, chara->CheckMotionEnd());
    return 1;
}

/**
 *
 * Sets lighting color and optional lighting bypass on the primary character.
 *
 */
int _CHR_SET_LIGHT_COLOR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 5 && argument_count != 4) {
        return 0;
    }

    mgCFrameAttr attr;

    if (now_script == 0) {
        return 0;
    }

    int       flags;
    mgCFrame *frame = ((CObjectFrame *) now_script->chara)->frame;

    if (frame == 0) {
        return 0;
    }

    float red = GetStackFloat(stack++);
    float green = GetStackFloat(stack++);
    float blue = GetStackFloat(stack++);
    float alpha = GetStackFloat(stack++);
    attr.color[0] = red;
    attr.color[1] = green;
    attr.color[2] = blue;
    attr.color[3] = alpha;
    flags = MG_FRAME_ATTR_COLOR;

    if (argument_count == 5) {
        flags |= MG_FRAME_ATTR_NO_LIGHT;
        attr.no_light = GetStackInt(stack);
    }

    frame->SetAttrParam(attr, 1, flags);
    return 1;
}

/**
 *
 * Allocates sprite slots for the current effect script.
 *
 */
int _SPT_ASSIGN_SPRITE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1 && argument_count != 2) {
        return 0;
    }

    int count = GetStackInt(stack++);

    if (now_script->sprite != 0) {
        return 0;
    }

    _ES_SPRITE *sprite = EffScriptMan->AssignSprite(count);

    if (sprite == 0) {
        if (argument_count >= 2) {
            SetStack(stack, 0);
        }

        return 0;
    }

    if (argument_count >= 2) {
        SetStack(stack, 1);
    }

    now_script->sprite = sprite;
    now_script->sprite_num = count;
    return 1;
}

/**
 *
 * Releases sprite slots owned by the current effect script.
 *
 */
int _SPT_DELETE_SPRITE(RS_STACKDATA *stack, int argument_count) {
    _ES_SPRITE *sprite = now_script->sprite;

    if (sprite == NULL) {
        return 0;
    }

    EffScriptMan->DeleteSprite(sprite);
    now_script->sprite = NULL;
    now_script->sprite_num = 0;
    return 1;
}

/**
 *
 * Sets the texture name used by effect sprites.
 *
 */
int _SPT_SET_TEXNAME(RS_STACKDATA *stack, int argument_count) {
    strcpy(now_script->tex_name, GetStackString(stack));
    return 1;
}

/**
 *
 * Sets alpha blend mode for a range of effect sprites.
 *
 */
int _SPT_SET_ALPHAB(RS_STACKDATA *stack, int argument_count) {
    int         first;
    int         alpha;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    alpha = GetStackInt(stack++);

    if (argument_count >= 3) {
        count = GetStackInt(stack);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->alpha = alpha;
    }

    return 1;
}

/**
 *
 * Restores default values for a range of effect sprites.
 *
 */
int _SPT_INIT_SPRITE(RS_STACKDATA *stack, int argument_count) {
    int         first;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);

    if (argument_count >= 2) {
        count = GetStackInt(stack);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->draw_flag = 0;
        sprite->alpha = 1;
        sprite->pos[0] = 0;
        sprite->pos[1] = 0;
        sprite->pos[2] = 0;
        sprite->pos[3] = 1.0f;
        sprite->uv[0] = 0;
        sprite->uv[1] = 0;
        sprite->uv[2] = 0;
        sprite->uv[3] = 0;
        sprite->color[0] = 128.0f;
        sprite->color[1] = 128.0f;
        sprite->color[2] = 128.0f;
        sprite->color[3] = 128.0f;
        sprite->scale[1] = 1.0f;
        sprite->scale[0] = 1.0f;
        sprite->put_size[1] = 0;
        sprite->put_size[0] = 0;
        sprite->rotz = 0;
        sprite->velo_pos[0] = 0;
        sprite->velo_pos[1] = 0;
        sprite->velo_pos[2] = 0;
        sprite->velo_pos[3] = 0;
        sprite->acc_pos[0] = 0;
        sprite->acc_pos[1] = 0;
        sprite->acc_pos[2] = 0;
        sprite->acc_pos[3] = 0;
        sprite->velo_col[0] = 0;
        sprite->velo_col[1] = 0;
        sprite->velo_col[2] = 0;
        sprite->velo_col[3] = 0;
        sprite->acc_col[0] = 0;
        sprite->acc_col[1] = 0;
        sprite->acc_col[2] = 0;
        sprite->acc_col[3] = 0;
        sprite->color_target[0] = 0;
        sprite->color_target[1] = 0;
        sprite->color_target[2] = 0;
        sprite->color_target[3] = 0;
        sprite->color_conv_div = -1.0f;
        sprite->acc_rotz = 0;
        sprite->velo_rotz = 0;
        sprite->velo_scl[1] = 0;
        sprite->velo_scl[0] = 0;
        sprite->acc_scl[1] = 0;
        sprite->acc_scl[0] = 0;
        sprite->scale_target[1] = 0;
        sprite->scale_target[0] = 0;
        sprite->scale_conv_div = -1.0f;
        sprite->blink_amp[0] = 0;
        sprite->blink_amp[1] = 0;
        sprite->blink_amp[2] = 0;
        sprite->blink_amp[3] = 0;
        sprite->blink_speed = 0;
        sprite->blink_phase = 0;
    }

    return 1;
}

/**
 *
 * Sets visibility for a range of effect sprites.
 *
 */
int _SPT_SET_DRAW_FLAG(RS_STACKDATA *stack, int argument_count) {
    int         first;
    int         draw_flag;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    draw_flag = GetStackInt(stack++);

    if (argument_count >= 3) {
        count = GetStackInt(stack);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->draw_flag = draw_flag;
    }

    return 1;
}

/**
 *
 * Returns the visibility flag of an effect sprite.
 *
 */
int _SPT_GET_DRAW_FLAG(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    RS_STACKDATA *result_slot = stack + 1;
    _ES_SPRITE   *sprite = GetSpritePtr(now_script, GetStackInt(stack));

    if (sprite == 0) {
        return 0;
    }

    SetStack(result_slot, sprite->draw_flag);
    return 1;
}

/**
 *
 * Sets texture origin and size for a range of effect sprites.
 *
 */
int _SPT_SET_UV_SIZE(RS_STACKDATA *stack, int argument_count) {
    int         first;
    float       value[4];
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    value[0] = GetStackFloat(stack++);
    value[1] = GetStackFloat(stack++);
    value[2] = GetStackFloat(stack++);
    value[3] = GetStackFloat(stack++);

    if (argument_count >= 6) {
        count = GetStackInt(stack);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        *(u_long128 *) sprite->uv = *(u_long128 *) value;
    }

    return 1;
}

/**
 *
 * Sets rendered size for a range of effect sprites.
 *
 */
int _SPT_SET_PUT_SIZE(RS_STACKDATA *stack, int argument_count) {
    int         first;
    float       put_size[2];
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    put_size[0] = GetStackFloat(stack++);
    put_size[1] = GetStackFloat(stack++);

    if (argument_count >= 4) {
        count = GetStackInt(stack);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->put_size[0] = put_size[0];
        sprite->put_size[1] = put_size[1];
    }

    return 1;
}

/**
 *
 * Sets position for a range of effect sprites.
 *
 */
int _SPT_SET_POS(RS_STACKDATA *stack, int argument_count) {
    int         first;
    float       value[4];
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    GetStackVector(value, stack);
    stack += 3;

    if (argument_count >= 5) {
        count = GetStackInt(stack++);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        *(u_long128 *) sprite->pos = *(u_long128 *) value;
    }

    return 1;
}

/**
 *
 * Returns an effect sprite position.
 *
 */
int _SPT_GET_POS(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 4) {
        return 0;
    }

    _ES_SPRITE *sprite = GetSpritePtr(now_script, GetStackInt(stack++));

    if (sprite == 0) {
        return 0;
    }

    SetStack(stack++, sprite->pos[0]);
    SetStack(stack++, sprite->pos[1]);
    SetStack(stack, sprite->pos[2]);
    return 1;
}

/**
 *
 * Sets rotation around the screen normal for a range of sprites.
 *
 */
int _SPT_SET_ROTZ(RS_STACKDATA *stack, int argument_count) {
    int         first;
    float       rotz;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    rotz = GetStackFloat(stack++);

    if (argument_count >= 3) {
        count = GetStackInt(stack);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->rotz = rotz;
    }

    return 1;
}

/**
 *
 * Returns an effect sprite rotation around the screen normal.
 *
 */
int _SPT_GET_ROTZ(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    RS_STACKDATA *result_slot = stack + 1;
    _ES_SPRITE   *sprite = GetSpritePtr(now_script, GetStackInt(stack));

    if (sprite == 0) {
        return 0;
    }

    SetStack(result_slot, sprite->rotz);
    return 1;
}

/**
 *
 * Sets two-dimensional scale for a range of effect sprites.
 *
 */
int _SPT_SET_SCALE(RS_STACKDATA *stack, int argument_count) {
    int         first;
    float       scale[2];
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    scale[0] = GetStackFloat(stack++);
    scale[1] = GetStackFloat(stack++);

    if (argument_count >= 4) {
        count = GetStackInt(stack);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->scale[0] = scale[0];
        sprite->scale[1] = scale[1];
    }

    return 1;
}

/**
 *
 * Returns an effect sprite two-dimensional scale.
 *
 */
int _SPT_GET_SCALE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    _ES_SPRITE *sprite = GetSpritePtr(now_script, GetStackInt(stack++));

    if (sprite == 0) {
        return 0;
    }

    SetStack(stack++, sprite->scale[0]);
    SetStack(stack, sprite->scale[1]);
    return 1;
}

/**
 *
 * Sets RGBA color for a range of effect sprites.
 *
 */
int _SPT_SET_COLOR(RS_STACKDATA *stack, int argument_count) {
    int         first;
    float       value[4];
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    value[0] = GetStackFloat(stack++);
    value[1] = GetStackFloat(stack++);
    value[2] = GetStackFloat(stack++);
    value[3] = GetStackFloat(stack++);

    if (argument_count >= 6) {
        count = GetStackInt(stack);
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        *(u_long128 *) sprite->color = *(u_long128 *) value;
    }

    return 1;
}

/**
 *
 * Returns an effect sprite RGBA color.
 *
 */
int _SPT_GET_COLOR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 5) {
        return 0;
    }

    _ES_SPRITE *sprite = GetSpritePtr(now_script, GetStackInt(stack++));

    if (sprite == 0) {
        return 0;
    }

    SetStack(stack++, sprite->color[0]);
    SetStack(stack++, sprite->color[1]);
    SetStack(stack++, sprite->color[2]);
    SetStack(stack, sprite->color[3]);
    return 1;
}

/**
 *
 * Assigns successive sprite positions using velocity and acceleration.
 *
 */
int _SPT_VAN_SET_POS(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       position[4];
    float       velocity[4];
    float       acceleration[4];
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    GetStackVector(position, stack);
    GetStackVector(velocity, stack + 3);
    GetStackVector(acceleration, stack + 6);
    stack = (RS_STACKDATA *) ((u8 *) stack + 9 * sizeof(*stack));

    if (argc >= 11) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        *(u_long128 *) sprite->pos = *(u_long128 *) position;
        sceVu0AddVector(position, position, velocity);
        position[3] = 1.0f;
        sceVu0AddVector(velocity, velocity, acceleration);
        velocity[3] = 1.0f;
    }

    return 1;
}

/**
 *
 * Assigns successive sprite rotations using angular velocity and acceleration.
 *
 */
int _SPT_VAN_SET_ROT(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       angle;
    float       velocity;
    float       acceleration;
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    angle = GetStackFloat(stack++);
    velocity = GetStackFloat(stack++);
    acceleration = GetStackFloat(stack++);

    if (argc >= 5) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        angle = mgAngleLimit(angle);
        sprite->rotz = angle;
        angle += velocity;
        velocity += acceleration;
    }

    return 1;
}

/**
 *
 * Assigns successive sprite colors using velocity and acceleration.
 *
 */
int _SPT_VAN_SET_COL(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       color[4];
    float       velocity[4];
    float       acceleration[4];
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);
    color[3] = GetStackFloat(stack++);
    velocity[0] = GetStackFloat(stack++);
    velocity[1] = GetStackFloat(stack++);
    velocity[2] = GetStackFloat(stack++);
    velocity[3] = GetStackFloat(stack++);
    acceleration[0] = GetStackFloat(stack++);
    acceleration[1] = GetStackFloat(stack++);
    acceleration[2] = GetStackFloat(stack++);
    acceleration[3] = GetStackFloat(stack++);

    if (argc >= 11) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        *(u_long128 *) sprite->color = *(u_long128 *) color;
        sceVu0AddVector(color, color, velocity);
        sceVu0AddVector(velocity, velocity, acceleration);
    }

    return 1;
}

/**
 *
 * Assigns successive sprite scales using velocity and acceleration.
 *
 */
int _SPT_VAN_SET_SCL(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       x;
    float       y;
    float       velocity_x;
    float       velocity_y;
    float       acceleration_x;
    float       acceleration_y;
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    x = GetStackFloat(stack++);
    y = GetStackFloat(stack++);
    velocity_x = GetStackFloat(stack++);
    velocity_y = GetStackFloat(stack++);
    acceleration_x = GetStackFloat(stack++);
    acceleration_y = GetStackFloat(stack++);

    if (argc >= 8) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        sprite->scale[0] = x;
        sprite->scale[1] = y;
        x += velocity_x;
        y += velocity_y;
        velocity_x += acceleration_x;
        velocity_y += acceleration_y;
    }

    return 1;
}

/**
 *
 * Offsets positions of a range of effect sprites.
 *
 */
int _SPT_ADD_POS(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       offset[4];
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    GetStackVector(offset, stack);
    stack = (RS_STACKDATA *) ((u8 *) stack + 3 * sizeof(*stack));

    if (argc >= 5) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < sprite_count + first_sprite; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        sceVu0AddVector(sprite->pos, sprite->pos, offset);
    }

    return 1;
}

/**
 *
 * Offsets rotations of a range of effect sprites.
 *
 */
int _SPT_ADD_ROTZ(RS_STACKDATA *stack, int argc) {
    int         first;
    float       angle;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    angle = GetStackFloat(stack++);

    if (argc >= 3) {
        count = GetStackInt(stack);
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->rotz += angle;
        sprite->rotz = mgAngleLimit(sprite->rotz);
    }

    return 1;
}

/**
 *
 * Offsets and clamps colors of a range of effect sprites.
 *
 */
int _SPT_ADD_COLOR(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       color_delta[4];
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color_delta[0] = GetStackFloat(stack++);
    color_delta[1] = GetStackFloat(stack++);
    color_delta[2] = GetStackFloat(stack++);
    color_delta[3] = GetStackFloat(stack++);

    if (argc >= 6) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < sprite_count + first_sprite; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        sceVu0AddVector(sprite->color, sprite->color, color_delta);

        if (sprite->color[0] <= 0.0f) {
            sprite->color[0] = 0.0f;
        } else if (!(sprite->color[0] < 255.0f)) {
            sprite->color[0] = 255.0f;
        }

        if (sprite->color[1] <= 0.0f) {
            sprite->color[1] = 0.0f;
        } else if (!(sprite->color[1] < 255.0f)) {
            sprite->color[1] = 255.0f;
        }

        if (sprite->color[2] <= 0.0f) {
            sprite->color[2] = 0.0f;
        } else if (!(sprite->color[2] < 255.0f)) {
            sprite->color[2] = 255.0f;
        }

        if (sprite->color[3] <= 0.0f) {
            sprite->color[3] = 0.0f;
        } else if (!(sprite->color[3] < 255.0f)) {
            sprite->color[3] = 255.0f;
        }
    }

    return 1;
}

/**
 *
 * Rotates positions of a range of sprites around the world Y axis.
 *
 */
int _SPT_WORLD_ROT(RS_STACKDATA *stack, int argc) {
    int         first;
    float       angle;
    int         count;
    int         i;
    _ES_SPRITE *sprite;
    float       matrix[4][4];

    count = 1;
    first = GetStackInt(stack++);
    angle = GetStackFloat(stack++);

    if (argc >= 3) {
        count = GetStackInt(stack);
    }

    sceVu0UnitMatrix(matrix);
    mgRotMatrixY(matrix, angle);

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sceVu0ApplyMatrix(sprite->pos, matrix, sprite->pos);
    }

    return 1;
}

/**
 *
 * Rejects the unsupported sprite lifetime command.
 *
 */
int _SPT_SET_LIFE(RS_STACKDATA *stack, int argument_count) {
    return 0;
}

/**
 *
 * Sets position velocity for a range of effect sprites.
 *
 */
int _SPT_SET_VELO_POS(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       velocity[4];
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    GetStackVector(velocity, stack);
    velocity[3] = 0.0f;
    stack = (RS_STACKDATA *) ((u8 *) stack + 3 * sizeof(*stack));

    if (argc >= 5) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        *(u_long128 *) sprite->velo_pos = *(u_long128 *) velocity;
    }

    return 1;
}

/**
 *
 * Sets position acceleration for a range of effect sprites.
 *
 */
int _SPT_SET_ACC_POS(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       acceleration[4];
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    GetStackVector(acceleration, stack);
    acceleration[3] = 0.0f;
    stack = (RS_STACKDATA *) ((u8 *) stack + 3 * sizeof(*stack));

    if (argc >= 5) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        *(u_long128 *) sprite->acc_pos = *(u_long128 *) acceleration;
    }

    return 1;
}

/**
 *
 * Sets angular velocity for a range of effect sprites.
 *
 */
int _SPT_SET_VELO_ROTZ(RS_STACKDATA *stack, int argc) {
    int         first;
    float       value;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    value = GetStackFloat(stack++);

    if (argc >= 3) {
        count = GetStackInt(stack);
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->velo_rotz = value;
    }

    return 1;
}

/**
 *
 * Sets angular acceleration for a range of effect sprites.
 *
 */
int _SPT_SET_ACC_ROTZ(RS_STACKDATA *stack, int argc) {
    int         first;
    float       value;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    value = GetStackFloat(stack++);

    if (argc >= 3) {
        count = GetStackInt(stack);
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->acc_rotz = value;
    }

    return 1;
}

/**
 *
 * Sets color velocity for a range of effect sprites.
 *
 */
int _SPT_SET_VELO_COL(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       color_velocity[4];
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color_velocity[0] = GetStackFloat(stack++);
    color_velocity[1] = GetStackFloat(stack++);
    color_velocity[2] = GetStackFloat(stack++);
    color_velocity[3] = GetStackFloat(stack++);

    if (argc >= 6) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        *(u_long128 *) sprite->velo_col = *(u_long128 *) color_velocity;
    }

    return 1;
}

/**
 *
 * Sets color acceleration for a range of effect sprites.
 *
 */
int _SPT_SET_ACC_COL(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       color_acceleration[4];
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color_acceleration[0] = GetStackFloat(stack++);
    color_acceleration[1] = GetStackFloat(stack++);
    color_acceleration[2] = GetStackFloat(stack++);
    color_acceleration[3] = GetStackFloat(stack++);

    if (argc >= 6) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        *(u_long128 *) sprite->acc_col = *(u_long128 *) color_acceleration;
    }

    return 1;
}

/**
 *
 * Sets color blinking amplitude and speed for effect sprites.
 *
 */
int _SPT_SET_BLINKING(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       color[4];
    float       speed;
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);
    color[3] = GetStackFloat(stack++);
    speed = GetStackFloat(stack++);

    if (argc >= 7) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        *(u_long128 *) sprite->blink_amp = *(u_long128 *) color;
        sprite->blink_speed = speed;
        sprite->blink_phase = 0;
    }

    return 1;
}

/**
 *
 * Sets scale velocity for a range of effect sprites.
 *
 */
int _SPT_SET_VELO_SCL(RS_STACKDATA *stack, int argc) {
    int         first;
    float       x;
    float       y;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    x = GetStackFloat(stack++);
    y = GetStackFloat(stack++);

    if (argc >= 4) {
        count = GetStackInt(stack);
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->velo_scl[0] = x;
        sprite->velo_scl[1] = y;
    }

    return 1;
}

/**
 *
 * Sets scale acceleration for a range of effect sprites.
 *
 */
int _SPT_SET_ACC_SCL(RS_STACKDATA *stack, int argc) {
    int         first;
    float       x;
    float       y;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    x = GetStackFloat(stack++);
    y = GetStackFloat(stack++);

    if (argc >= 4) {
        count = GetStackInt(stack);
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->acc_scl[0] = x;
        sprite->acc_scl[1] = y;
    }

    return 1;
}

/**
 *
 * Sets target scale and convergence divisor for effect sprites.
 *
 */
int _SPT_SCALE_CONV(RS_STACKDATA *stack, int argc) {
    int         first;
    float       time;
    float       target_x;
    float       target_y;
    int         count;
    int         i;
    _ES_SPRITE *sprite;

    count = 1;
    first = GetStackInt(stack++);
    target_x = GetStackFloat(stack++);
    target_y = GetStackFloat(stack++);
    time = GetStackFloat(stack++);

    if (argc >= 5) {
        count = GetStackInt(stack);
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == 0) {
            return 0;
        }

        sprite->scale_target[0] = target_x;
        sprite->scale_target[1] = target_y;
        sprite->scale_conv_div = time;
    }

    return 1;
}

/**
 *
 * Sets target color and convergence divisor for effect sprites.
 *
 */
int _SPT_COLOR_CONV(RS_STACKDATA *stack, int argc) {
    int         first_sprite;
    float       color[4];
    float       divisor;
    int         sprite_count;
    int         sprite_index;
    _ES_SPRITE *sprite;

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);
    color[3] = GetStackFloat(stack++);
    divisor = GetStackFloat(stack++);

    if (argc >= 7) {
        sprite_count = GetStackInt(stack);
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == NULL) {
            return 0;
        }

        *(u_long128 *) sprite->color_target = *(u_long128 *) color;
        sprite->color_conv_div = divisor;
    }

    return 1;
}

/**
 *
 * Returns the position of a scene character.
 *
 */
int _SCN_GET_CHR_POS(RS_STACKDATA *stack, int argc) {
    float        pos[3];
    CCharacter2 *chara;

    if (argc != 4) {
        return 0;
    }

    chara = now_scene->GetCharacter(GetStackInt(stack++));

    if (chara == NULL) {
        return 0;
    }

    chara->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Returns the yaw or full rotation of a scene character.
 *
 */
int _SCN_GET_CHR_ROT(RS_STACKDATA *stack, int argc) {
    float        rot[3];
    CCharacter2 *chara;

    if (argc != 2 && argc != 4) {
        return 0;
    }

    chara = now_scene->GetCharacter(GetStackInt(stack++));

    if (chara == NULL) {
        return 0;
    }

    chara->GetRotation(rot);

    switch (argc) {
        case 2:
            SetStack(stack, rot[1]);
            break;
        case 4:
            SetStack(stack++, rot[0]);
            SetStack(stack++, rot[1]);
            SetStack(stack, rot[2]);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Returns the world position of a named scene character frame.
 *
 */
int _SCN_GET_CHR_FRM_POS(RS_STACKDATA *stack, int argc) {
    float        pos[4];
    int          chara_slot;
    char        *frame_name;
    CCharacter2 *chara;
    mgCFrame    *frame;

    if (argc != 5) {
        return 0;
    }

    chara_slot = GetStackInt(stack++);
    frame_name = GetStackString(stack++);
    chara = now_scene->GetCharacter(chara_slot);

    if (chara == NULL) {
        return 0;
    }

    if (((CObjectFrame *) chara)->frame == NULL) {
        return 0;
    }

    frame = ((CObjectFrame *) chara)->frame->SearchFrame(frame_name);

    if (frame == NULL) {
        return 0;
    }

    frame->GetWorldPosition0(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Returns the world direction of a named scene character frame.
 *
 */
int _SCN_GET_CHR_FRM_DIR(RS_STACKDATA *stack, int argc) {
    float        direction[4];
    int          chara_slot;
    char        *frame_name;
    CCharacter2 *character;
    mgCFrame    *frame;

    chara_slot = GetStackInt(stack++);
    frame_name = GetStackString(stack++);
    character = now_scene->GetCharacter(chara_slot);

    if (character == NULL) {
        return 0;
    }

    if (character->CObjectFrame::frame == NULL) {
        return 0;
    }

    frame = character->CObjectFrame::frame->SearchFrame(frame_name);

    if (frame == NULL) {
        return 0;
    }

    direction[0] = 0.0f;
    direction[1] = 0.0f;
    direction[2] = 1.0f;
    direction[3] = 0.0f;
    frame->GetWorldDir(direction, direction);
    SetStack(stack++, direction[0]);
    SetStack(stack++, direction[1]);
    SetStack(stack, direction[2]);
    return 1;
}

/**
 *
 * Returns pitch and yaw from a named scene character frame.
 *
 */
int _SCN_GET_CHR_FRM_ROT(RS_STACKDATA *stack, int argc) {
    float        direction[4];
    float        origin[4];
    float        yaw;
    int          chara_slot;
    char        *frame_name;
    CCharacter2 *character;
    mgCFrame    *frame;

    chara_slot = GetStackInt(stack++);
    frame_name = GetStackString(stack++);
    character = now_scene->GetCharacter(chara_slot);

    if (character == NULL) {
        return 0;
    }

    if (character->CObjectFrame::frame == NULL) {
        return 0;
    }

    frame = character->CObjectFrame::frame->SearchFrame(frame_name);

    if (frame == NULL) {
        return 0;
    }

    direction[0] = 0.0f;
    direction[1] = 0.0f;
    direction[2] = 1.0f;
    direction[3] = 0.0f;
    origin[0] = 0.0f;
    origin[1] = 0.0f;
    origin[2] = 0.0f;
    origin[3] = 1.0f;
    frame->GetWorldDir(direction, direction);
    sceVu0SubVector(direction, direction, origin);
    sceVu0Normalize(direction, direction);
    yaw = atan2f(direction[0], direction[2]);
    SetStack(stack++, -atan2f(direction[1],
                              sqrtf(direction[0] * direction[0] + direction[2] * direction[2])));
    SetStack(stack++, yaw);
    SetStack(stack, 0.0f);
    return 1;
}

/**
 *
 * Returns the position of a scene character entry object.
 *
 */
int _SCN_GET_ENTRY_OBJ_POS(RS_STACKDATA *stack, int argc) {
    float pos[3];
    int   chara_slot;
    int   entry_index;

    if (argc != 5) {
        return 0;
    }

    chara_slot = GetStackInt(stack++);
    entry_index = GetStackInt(stack++);

    if (entry_index < 0 || entry_index > 1) {
        return 0;
    }

    CCharacter2 *chara = now_scene->GetCharacter(chara_slot);

    if (chara == NULL) {
        return 0;
    }

    chara->GetEntryObjectPos(entry_index, pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Tests a segment against scene collision polygons and returns hit details to the script.
 *
 */
int _INTERSECTION_POINT(RS_STACKDATA *stack, int argc) {
    sceVu0FVECTOR start;
    sceVu0FVECTOR end;
    sceVu0FVECTOR hit;
    sceVu0FVECTOR reflection;
    mgVu0FBOX     box;
    CCPoly        poly[0x80];
    sceVu0FVECTOR normal;

    if (argc != 8 && argc != 9 && argc != 10 && argc != 11 && argc != 12 && argc != 13 && argc != 14 && argc != 15 && argc != 16) {
        return 0;
    }

    int ignore_mask = GetStackInt(stack++);
    GetStackVector(start, stack);
    GetStackVector(end, stack + 3);
    stack += 6;
    float range = 10.0f + mgDistVector(start, end);
    box.max[0] = range + start[0];
    box.min[0] = start[0] - range;
    box.max[1] = range + start[1];
    box.min[1] = start[1] - range;
    box.max[2] = range + start[2];
    box.min[2] = start[2] - range;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    int poly_num = now_scene->GetColPoly(poly, box, 0x80);

    if (poly_num >= 0x80) {
        printf(at_3303__2, poly_num);
        return 0;
    }

    CCPoly *hit_poly = poly;
    int     hit_no = CheckHit(hit_poly, poly_num, start, end, hit, 1, ignore_mask);
    int     foot_sound;
    int     area_kind;

    if (hit_no >= 0) {
        hit_poly = &hit_poly[hit_no];
        sceVu0Normalize(normal, hit_poly->normal);
        mgReflectionPlane(normal, hit, start, reflection);
        sceVu0Normalize(reflection, reflection);
        foot_sound = hit_poly->foot_sound;
        area_kind = hit_poly->area_kind;

        if (foot_sound == 0) {
            CMap *map = now_scene->GetMap(now_scene->active_map);

            if (map != NULL) {
                foot_sound = map->map_info.def_foot;
            }
        }
    }

    switch (argc) {
        case 8:
        case 9:
        case 10:
            SetStack(stack++, hit_no);

            if (argc >= 9) {
                SetStack(stack++, area_kind);
            }

            if (argc == 10) {
                SetStack(stack, foot_sound);
            }

            break;
        case 11:
        case 12:
        case 13:
            SetStack(stack++, hit[0]);
            SetStack(stack++, hit[1]);
            SetStack(stack++, hit[2]);
            SetStack(stack++, hit_no);

            if (argc >= 12) {
                SetStack(stack++, area_kind);
            }

            if (argc == 13) {
                SetStack(stack, foot_sound);
            }

            break;
        case 14:
        case 15:
        case 16:
            SetStack(stack++, hit[0]);
            SetStack(stack++, hit[1]);
            SetStack(stack++, hit[2]);
            SetStack(stack++, reflection[0]);
            SetStack(stack++, reflection[1]);
            SetStack(stack++, reflection[2]);
            SetStack(stack++, hit_no);

            if (argc >= 15) {
                SetStack(stack++, area_kind);
            }

            if (argc == 16) {
                SetStack(stack, foot_sound);
            }

            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Plays a sound from the current effect owner character.
 *
 */
int _MON_SE_PLAY(RS_STACKDATA *stack, int argc) {
    float        position[4];
    float        pad[2];
    float        volume;
    float        pan;
    CCharacter2 *owner;
    int          se_id;
    u_int        se_handle;
    int          slot = now_script->user_id;

    if (slot <= -1) {
        return 0;
    }

    owner = now_scene->GetCharacter(slot);

    if (owner == NULL) {
        return 0;
    }

    se_handle = owner->sound_info.se_bank;
    se_id = GetStackInt(stack++);

    switch (argc) {
        case 1:
            sndSePlay(se_handle, se_id, 0);
            break;
        case 4:
            GetStackVector(position, stack);
            sndGetVolPan(&volume, &pan, position, 160.0f, 1200.0f);
            sndSePlayVPf(se_handle, se_id, volume, pan, 0);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Stops a sound from the current effect owner character.
 *
 */
int _MON_SE_STOP(RS_STACKDATA *stack, int argc) {
    CCharacter2 *owner;
    int          slot = now_script->user_id;

    if (slot <= -1) {
        return 0;
    }

    owner = now_scene->GetCharacter(slot);

    if (owner == NULL) {
        return 0;
    }

    u_int se_handle = owner->sound_info.se_bank;
    sndSeStop(se_handle, GetStackInt(stack), 0);
    return 1;
}

/**
 *
 * Plays a sound from the scene battle sound bank.
 *
 */
int _BTL_SE_PLAY(RS_STACKDATA *stack, int argc) {
    float position[4];
    float pad[2];
    float volume;
    float pan;
    float near_distance = 160.0f;
    float far_distance = 1200.0f;
    int   se_id;
    u_int se_handle = now_scene->se_battle_id;
    se_id = GetStackInt(stack++);

    switch (argc) {
        case 1:
            sndSePlay(se_handle, se_id, 0);
            break;
        case 4:
            GetStackVector(position, stack);
            sndGetVolPan(&volume, &pan, position, near_distance, far_distance);
            sndSePlayVPf(se_handle, se_id, volume, pan, 0);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Stops a sound from the scene battle sound bank.
 *
 */
int _BTL_SE_STOP(RS_STACKDATA *stack, int argc) {
    u_int se_handle;

    se_handle = now_scene->se_battle_id;
    sndSeStop(se_handle, GetStackInt(stack), 0);
    return 1;
}

/**
 *
 * Plays a sound from the scene base sound bank.
 *
 */
int _BSE_SE_PLAY(RS_STACKDATA *stack, int argc) {
    u_int se_handle;

    se_handle = now_scene->se_base_id;
    sndSePlay(se_handle, GetStackInt(stack), 0);
    return 1;
}

/**
 *
 * Stops a sound from the scene base sound bank.
 *
 */
int _BSE_SE_STOP(RS_STACKDATA *stack, int argc) {
    u_int se_handle;

    se_handle = now_scene->se_base_id;
    sndSeStop(se_handle, GetStackInt(stack), 0);
    return 1;
}

/**
 *
 * Plays a sound from a selected scene character.
 *
 */
int _MON_SE_PLAY2(RS_STACKDATA *stack, int argc) {
    float        position[4];
    float        pad[2];
    float        volume;
    float        pan;
    float        near_distance = 160.0f;
    float        far_distance = 1200.0f;
    CCharacter2 *owner;
    int          se_id;
    u_int        se_handle;

    if (argc != 2 && argc != 5) {
        return 0;
    }

    owner = now_scene->GetCharacter(GetStackInt(stack++));

    if (owner == NULL) {
        return 0;
    }

    se_handle = owner->sound_info.se_bank;
    se_id = GetStackInt(stack++);

    switch (argc) {
        case 2:
            sndSePlay(se_handle, se_id, 0);
            break;
        case 5:
            GetStackVector(position, stack);
            sndGetVolPan(&volume, &pan, position, near_distance, far_distance);
            sndSePlayVPf(se_handle, se_id, volume, pan, 0);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Stops a sound from a selected scene character.
 *
 */
int _MON_SE_STOP2(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *second = stack + 1;
    CCharacter2  *owner;
    u_int         se_handle;
    owner = now_scene->GetCharacter(GetStackInt(stack));

    if (owner == NULL) {
        return 0;
    }

    se_handle = owner->sound_info.se_bank;
    sndSeStop(se_handle, GetStackInt(second), 0);
    return 1;
}

/**
 *
 * Sets whether effect sprites use scene lighting.
 *
 */
int _SET_LIGHT_FLAG(RS_STACKDATA *stack, int argc) {
    now_script->light_flag = GetStackInt(stack);
    return 1;
}

/**
 *
 * Returns the position of a selected scene character entry object.
 *
 */
int _SCN_GET_CHR_ENTOBJ_POS(RS_STACKDATA *stack, int argc) {
    float        pos[3];
    int          chara_slot;
    int          entry_index;
    CCharacter2 *chara;

    if (argc != 5) {
        return 0;
    }

    chara_slot = GetStackInt(stack++);
    entry_index = GetStackInt(stack++);
    chara = now_scene->GetCharacter(chara_slot);

    if (chara == NULL) {
        return 0;
    }

    chara->GetEntryObjectPos(entry_index, pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Rejects creation of a standalone damage object.
 *
 */
int _CREATE_DAMAGE(RS_STACKDATA *stack, int argc) {
    printf((const char *) &at_3398);
    return 0;
}

/**
 *
 * Rejects deletion of a standalone damage object.
 *
 */
int _DELETE_DAMAGE(RS_STACKDATA *stack, int argument_count) {
    return 0;
}

/**
 *
 * Rejects positioning of a standalone damage object.
 *
 */
int _DMG_SET_POS(RS_STACKDATA *stack, int argument_count) {
    return 0;
}

/**
 *
 * Rejects setting a standalone damage direction.
 *
 */
int _DMG_SET_FRONT_VECT(RS_STACKDATA *stack, int argument_count) {
    return 0;
}

/**
 *
 * Rejects setting standalone damage.
 *
 */
int _DMG_SET_DAMAGE(RS_STACKDATA *stack, int argc) {
    printf((const char *) &at_3398);
    return 0;
}

/**
 *
 * Creates a collision primitive for the current effect script.
 *
 */
int _COLPRIM_CREATE(RS_STACKDATA *stack, int argc) {
    CColPrim *colprim;
    int       owner;
    char     *damage_name;

    if (now_script->colprim != NULL) {
        now_script->colprim->Delete(now_script->user_id);
    }

    colprim = ColPrimMan.GetPrim();
    now_script->colprim = colprim;

    if (colprim == NULL) {
        return 0;
    }

    owner = now_script->user_id;
    damage_name = GetStackString(stack++);

    if (argc >= 2) {
        owner = GetStackInt(stack);
    }

    now_script->colprim->SetDamage(damage_name, owner);
    return 1;
}

/**
 *
 * Sets collision primitive coordinates from positions or named frames.
 *
 */
int _COLPRIM_SET_COORD(RS_STACKDATA *stack, int argc) {
    float     start[4];
    float     end[4];
    float     radius;
    mgCFrame *root;
    mgCFrame *frame;
    char     *start_name;
    char     *end_name;

    if (now_script->colprim == NULL) {
        return 0;
    }

    switch (argc) {
        case 4:
            GetStackVector(start, stack);
            radius = GetStackFloat(stack += 3);
            now_script->colprim->SetCoord(start, radius);
            break;
        case 7:
            GetStackVector(start, stack);
            GetStackVector(end, stack + 3);
            radius = GetStackFloat(stack += 6);
            now_script->colprim->SetCoord(start, end, radius);
            break;
        case 2:
            if (now_script->chara == NULL) {
                return 0;
            }

            start_name = GetStackString(stack++);
            radius = GetStackFloat(stack);
            root = ((CObjectFrame *) now_script->chara)->frame;

            if (root == NULL) {
                return 0;
            }

            frame = root->SearchFrame(start_name);

            if (frame == NULL) {
                return 0;
            }

            now_script->colprim->SetCoord(frame, radius);
            break;
        case 3:
            if (now_script->chara == NULL) {
                return 0;
            }

            start_name = GetStackString(stack++);
            end_name = GetStackString(stack++);
            radius = GetStackFloat(stack);
            root = ((CObjectFrame *) now_script->chara)->frame;

            if (root == NULL) {
                return 0;
            }

            mgCFrame *first_frame;
            mgCFrame *second_frame;

            if ((first_frame = root->SearchFrame(start_name)) == NULL) {
                return 0;
            }

            if ((second_frame = root->SearchFrame(end_name)) == NULL) {
                return 0;
            }

            now_script->colprim->SetCoord(first_frame, second_frame, radius);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Deletes the collision primitive owned by the current effect script.
 *
 */
int _COLPRIM_DELETE(RS_STACKDATA *stack, int argc) {
    CColPrim *colprim;

    if (now_script == NULL) {
        return 0;
    }

    GetStackInt(stack);
    colprim = now_script->colprim;

    if (colprim == NULL) {
        return 0;
    }

    colprim->Delete(-1);
    now_script->colprim = NULL;
    return 1;
}

/**
 *
 * Returns the hit count of the current collision primitive.
 *
 */
int _COLPRIM_GET_HITCNT(RS_STACKDATA *stack, int argc) {
    CColPrim *colprim;

    if (argc != 1) {
        return 0;
    }

    colprim = now_script->colprim;

    if (colprim == NULL) {
        return 0;
    }

    SetStack(stack, colprim->hit_num);
    return 1;
}

/**
 *
 * Assigns a gift item, count, and rate to the current collision primitive.
 *
 */
int _COLPRIM_GET_GIFT(RS_STACKDATA *stack, int argc) {
    int           item_id;
    int           count;
    int           rate;
    RS_STACKDATA *next_slot;
    CColPrim     *colprim;

    if (argc != 3) {
        return 0;
    }

    next_slot = stack + 1;

    if (now_script->colprim == NULL) {
        return 0;
    }

    item_id = GetStackInt(stack);
    count = GetStackInt(next_slot++);
    rate = GetStackInt(next_slot);
    colprim = now_script->colprim;
    colprim->gift[0] = item_id;
    colprim->gift[1] = count;
    colprim->gift[2] = rate;
    colprim->has_gift = 1;
    printf(at_3495, item_id, count, rate);
    return 1;
}

/**
 *
 * Returns the collision primitive reversal count and optional vector.
 *
 */
int _COLPRIM_GET_REVCNT(RS_STACKDATA *stack, int argc) {
    if (argc != 4 && argc != 1) {
        return 0;
    }

    if (now_script->colprim == NULL) {
        return 0;
    }

    SetStack(stack++, now_script->colprim->reversed);

    if (argc == 4) {
        SetStack(stack++, now_script->colprim->revers_vec[0]);
        SetStack(stack++, now_script->colprim->revers_vec[1]);
        SetStack(stack, now_script->colprim->revers_vec[2]);
    }

    return 1;
}

/**
 *
 * Sets the damage value of the current collision primitive.
 *
 */
int _COLPRIM_SET_DAMAGE(RS_STACKDATA *stack, int argc) {
    if (now_script->colprim == NULL) {
        return 0;
    }

    now_script->colprim->damage = GetStackInt(stack);
    return 1;
}

/**
 *
 * Returns the last hit position of the current collision primitive.
 *
 */
int _COLPRIM_GET_HIT_POS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    if (now_script->colprim == NULL) {
        return 0;
    }

    SetStack(stack++, now_script->colprim->hit_pos[0]);
    SetStack(stack++, now_script->colprim->hit_pos[1]);
    SetStack(stack, now_script->colprim->hit_pos[2]);
    return 1;
}

/**
 *
 * Creates a child effect script for the current effect owner.
 *
 */
int _ES_CREATE(RS_STACKDATA *stack, int argc) {
    int   handle = -1;
    char *name = GetStackString(stack++);

    switch (argc) {
        case 1:
            EffScriptMan->CreateEffSpt(name, now_script->user_id, 0);
            break;
        case 2: {
            int user_id = now_script->user_id;

            if (user_id >= 0) {
                handle = EffScriptMan->CreateEffSpt(name, user_id, 1);
            }

            SetStack(stack, handle);

            if (handle <= -1) {
                printf(at_3536, name, now_script->user_id);
            }

            break;
        }
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Sets the first work vector of a child effect script.
 *
 */
int _ES_SET_VECT1(RS_STACKDATA *stack, int argc) {
    float vect[4];
    int   target_id;

    switch (argc) {
        case 3:
            GetStackVector(vect, stack);
            EffScriptMan->SetScriptVect1(vect, now_script->user_id, -1);
            break;
        case 4:
            target_id = GetStackInt(stack++);
            GetStackVector(vect, stack);
            EffScriptMan->SetScriptVect1(vect, now_script->user_id, target_id);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Sets the second work vector of a child effect script.
 *
 */
int _ES_SET_VECT2(RS_STACKDATA *stack, int argc) {
    float vect[4];
    int   target_id;

    switch (argc) {
        case 3:
            GetStackVector(vect, stack);
            EffScriptMan->SetScriptVect2(vect, now_script->user_id, -1);
            break;
        case 4:
            target_id = GetStackInt(stack++);
            GetStackVector(vect, stack);
            EffScriptMan->SetScriptVect2(vect, now_script->user_id, target_id);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Sets the target identifier of a child effect script.
 *
 */
int _ES_SET_TARGET_ID(RS_STACKDATA *stack, int argc) {
    switch (argc) {
        case 1:
            EffScriptMan->SetScriptTargetId(GetStackInt(stack), now_script->user_id, -1);
            break;
        case 2: {
            int source_id = GetStackInt(stack++);
            EffScriptMan->SetScriptTargetId(GetStackInt(stack),
                                            now_script->user_id,
                                            source_id);
            break;
        }
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Sets a typed value in a child effect script.
 *
 */
int _ES_SET_VALUE(RS_STACKDATA *stack, int argc) {
    int target_id = -1;
    int index;

    switch (argc) {
        case 2:
            break;
        case 3:
            target_id = GetStackInt(stack++);
            break;
        default:
            return 0;
    }

    index = GetStackInt(stack++);

    switch (stack->type) {
        case 0:
            EffScriptMan->SetValue(index, GetStackInt(stack), now_script->user_id, target_id);
            break;
        case 1:
            EffScriptMan->SetValue(index, GetStackFloat(stack), now_script->user_id, target_id);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Associates the current collision primitive with a child effect script.
 *
 */
int _ES_SET_COLPRIM(RS_STACKDATA *stack, int argc) {
    CColPrim *colprim;

    colprim = now_script->colprim;

    if (colprim == NULL) {
        return 0;
    }

    EffScriptMan->SetColPrim(colprim,
                             now_script->user_id, -1);
    return 1;
}

/**
 *
 * Returns the position of an event object handle.
 *
 */
int _GET_EOH_POS(RS_STACKDATA *stack, int argc) {
    float pos[3];

    if (argc != 4) {
        return 0;
    }

    EventObjHandleMother.GetPos(GetStackInt(stack++), pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Loads an effect program with script stack and call data.
 *
 */
int SetEffectScript(CRunScript *script, char *program, mgCMemory *memory) {
    RS_STACKDATA *stack = (RS_STACKDATA *) memory->Alloc(0x20);
    RS_CALLDATA  *call_data = (RS_CALLDATA *) memory->Alloc(1);
    script->load((RS_PROG_HEADER *) program, stack, 0x40, call_data, 2);
    script->ext_func(ext_func__4, 0x100);
    return 1;
}

/**
 *
 * Builds the effect script external function table.
 *
 */
void SetEffectScriptFunc() {
    int function_index;
    int previous_index;

    for (function_index = 0; function_index < 256; function_index++) {
        ext_func__4[function_index] = NULL;
    }

    for (function_index = 0;; function_index++) {
        if (ext_func_info__4[function_index].func == NULL) {
            break;
        }

        if (0 < function_index) {
            previous_index = 0;

            do {
                if (ext_func_info__4[function_index].no == ext_func_info__4[previous_index].no) {
                    printf(at_3644, ext_func_info__4[previous_index].no);

                    while (1) {
                    }
                }

                previous_index++;
            } while (previous_index < function_index);
        }

        if (ext_func_info__4[function_index].no < 0 || ext_func_info__4[function_index].no >= 256) {
            printf(at_3645);
        } else {
            ext_func__4[ext_func_info__4[function_index].no] = ext_func_info__4[function_index].func;
        }
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", eff_spt_base_def__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_2311__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_2498__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", ext_func_info__4__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_943__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1099__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1100__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1101__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1102__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1103__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1104__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1127__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1128__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1129__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1143__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1144__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1145__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1336__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1337__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1338__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1339__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1340__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1341__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1655__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_1705__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_2025__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_3303__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_3304__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_3398__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_3495__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_3536__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_3644__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/effscript", at_3645__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(now_scene, 0x4);
INCLUDE_BSS(EffScriptMan, 0x4);
INCLUDE_BSS(now_script, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(ext_func__4, 0x400);
INCLUDE_BSS(at_2067, 0x10);
