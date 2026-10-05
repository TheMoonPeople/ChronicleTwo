#include "common.h"
#include "mglib.hpp"
#include <cstring>
#include <cstdlib>
#include "mdslist.hpp"
#include "mapparts.hpp"
#include "mapload.hpp"
#include "dataread.hpp"
#include "sound.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "editevent.hpp"
#include "photo.hpp"
#include "funcpoint.hpp"
#include "mg_texture.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "character.hpp"
#include "scene.hpp"
#include "editexception.hpp"

extern "C" int fptosi(float value);

extern char at_1084__2[];
extern char at_1085[];
extern char at_1086[];
extern char at_1385__4[];
extern char at_1386__3[];

extern int fade_cnt;
extern int next_thunder_cnt;
extern int rea_chara_id;
extern int rea_mtn_step;
extern int sound_cnt;
extern int sound_flag;
extern int start_thunder;
extern int thunder_count;
extern CGeyserEffect *GeyserEffect;
extern u32 GeyserEffectFlag;
extern int FirePowderFlag;
extern FirePowder *fire_powder;
extern mgCTextureManager mgTexManager;
extern int GeyserEffectTexb;
extern mgCFrame *GeyserFrame;
extern int GeyserRndSeed;

static inline u32 align16_blocks(u32 bytes) {
    if (bytes & 0xF) {
        return (bytes >> 4) + 1;
    }
    return bytes >> 4;
}

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editexception", EditExceptionStep__FiP6CScene);
void InitNpcCameraReaction(void) {
    rea_mtn_step = 0;
    rea_chara_id = -1;
}
void InitS51Thunder(void) {
    thunder_count = 0;
    start_thunder = 0;
    next_thunder_cnt = 60;
    fade_cnt = 0;
    sound_cnt = 0;
    sound_flag = 0;
}
void S51Thunder(CScene *scene) {
    float ratio[2];
    CMapLightingInfo info;
    char *map_name = scene->GetMapName(scene->active_map);
    if (map_name != NULL) {
        switch (strcmp(map_name, at_1084__2)) {
            case 0:
                break;
            default:
                return;
        }
        if (next_thunder_cnt == 0) {
            fade_cnt = 40;
            thunder_count = 4;
            next_thunder_cnt = rand() % 150 + 10;
            sound_flag = 1;
            sound_cnt = rand() % 20;
            if (next_thunder_cnt < sound_cnt) {
                sound_cnt = 1;
            }
        }
        if (sound_flag != 0) {
            sound_cnt--;
            if (sound_cnt <= 0) {
                sound_cnt = 0;
                sound_flag = 0;
                sndSePlay(EdEventInfo.snd_id[4], rand() % 4 + 0x15, 0);
            }
        }
        thunder_count--;
        next_thunder_cnt--;
        fade_cnt--;
        if (fade_cnt < 0) {
            fade_cnt = 0;
        }
        float fade = (float)fade_cnt / 40.0f;
        CMap *map = scene->GetMap(scene->active_map);
        if (map != NULL && map->GetTimeLightingRatio(ratio) >= 2) {
            ratio[0] = 1.0f - fade;
            ratio[1] = fade;
            memset(&info, 0, sizeof(CMapLightingInfo));
            map->GetLightInfo(&info, ratio, 2);
            mgSetLight(info.light_dir, info.light_color);
            mgSetAmbient(info.ambient);
            for (int i = 0; i < 2; i++) {
                CMapParts *parts = NULL;
                if (i == 0) {
                    parts = map->GetPlaceParts(at_1085);
                }
                if (i == 1) {
                    parts = map->GetPlaceParts(at_1086);
                }
                if (parts != NULL) {
                    parts->show = 1;

                    for (CList<CMapPiece> *node = parts->piece_list; node != NULL;
                         node = node->next) {
                        CObject *piece = (CObject *)&node->data;
                        piece->fade = 1;
                        piece->fade_alpha = fade;
                    }
                }
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editexception", InitFirePowder__FiP6CSceneiP9mgCMemory);
void StepFirePowder(CScene *scene) {
    int i;
    if (FirePowderFlag != 0) {
        for (i = 0; i < 0x100; i++) {
            FirePowder *particle = &fire_powder[i];
            particle->pos[1] += particle->fall_speed;
            if (particle->pos[1] < -300.0f) {
                particle->pos[1] = 300.0f;
            }
            particle->pos[3] += particle->phase_speed;
            if (!(particle->pos[3] <= 3.1415927f)) {
                particle->pos[3] -= 6.2831855f;
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editexception", DrawFirePowder__FP6CScene);
void CGeyserEffect::Create(void) {
    if (wait <= 0) {
        if (wait == 0) {
            erupting = 1;
        }
        wait = fptosi(150.0f * mgRnd()) + 0x64;
        erupt_frame = 0;
        erupt_count = fptosi(32.0f * mgRnd()) + 0x30;
    }
    wait -= 1;
    if (erupting != 0) {
        if ((erupt_frame % 12) != 0) {
            erupt_count -= 1;
            CreatePoint();
        }
        erupt_frame += 1;
        if (erupt_count <= 0) {
            erupting = 0;
        }
    }
}
void CGeyserEffect::Step(void) {
    Create();
    if (point != NULL) {
        for (int i = 0; i < point_num; i++) {
            CGeyserEffectPoint *particle = &point[i];
            if (particle->active != 0) {
                particle->alpha -= 0.02f;
                particle->pos[1] += particle->rise_speed;
                particle->scale += 0.1f;
                particle->pos[3] += particle->phase_speed;
                if (!(particle->pos[3] <= 3.1415927f)) {
                    particle->pos[3] -= 6.2831855f;
                }
                if (particle->alpha < 0.0f) {
                    particle->active = 0;
                }
            }
        }
    }
}
CGeyserEffectPoint *CGeyserEffect::GetEmpty(void) {
    if (point == 0)
        return 0;
    int i = 0;
    while (i < point_num) {
        if (point[i].active == 0)
            return &point[i];
        i++;
    }
    return 0;
}
void CGeyserEffect::CreatePoint(void) {
    CGeyserEffectPoint *particle = GetEmpty();
    if (particle != NULL) {
        particle->active = 1;
        particle->alpha = 1.0f;
        particle->rise_speed = 2.6f + 0.4f * mgRnd();
        particle->scale = 1.0f;
        particle->sway_x = 2.0f * (2.0f * (mgRnd() - 0.5f));
        particle->sway_z = 2.0f * (2.0f * (mgRnd() - 0.5f));
        particle->phase_speed = 0.1f + 0.1f * mgRnd();
        mgZeroVectorW(particle->pos);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editexception", CreatePacket__13CGeyserEffectFv);
void InitGeyserEffect(int scene_no, CScene *scene, int texb, mgCMemory *memory) {
    int size;
    u8 *copy;
    GeyserEffectFlag = 0;
    if (scene_no == 3) {
        u8 *buffer = (u8 *)scene->read_buff;
        if (LoadFile2(at_1385__4, buffer, &size, 0) != 0) {
            copy = (u8 *)memory->Alloc(align16_blocks(size));
            memcpy(copy, buffer, size);
            mgCTextureManager *textures = &mgTexManager;
            GeyserEffectFlag = 1;
            GeyserEffectTexb = texb;
            textures->DeleteBlock(texb);
            textures->EnterIMGFile(copy, GeyserEffectTexb, NULL, NULL);
            GeyserFrame = new ((u_long128 *)memory->Alloc(0x13)) mgCFrame;
            mgCFrameAttr *attr = new ((u_long128 *)memory->Alloc(0xB)) mgCFrameAttr;
            GeyserFrame->attr = attr;
            attr->fog = 2;
            attr->z_write = -1;
            GeyserEffect = new ((u_long128 *)memory->Alloc(0x22)) CGeyserEffect[4];
            for (int i = 0; i < 4; i++) {
                CGeyserEffectPoint *pool =
                    new ((u_long128 *)memory->Alloc(0x92)) CGeyserEffectPoint[0x30];
                GeyserEffect[i].point_num = 0x30;
                GeyserEffect[i].point = pool;
                GeyserEffect[i].texture = textures->GetTexture(at_1386__3, -1);
            }
            GeyserRndSeed = rand();
        }
    }
}
CGeyserEffectPoint::CGeyserEffectPoint(void) {
    active = 0;
}
CGeyserEffect::CGeyserEffect() {
    point_num = 0;
    point = 0;
    sprite.Initialize();
    wait = -1;
    erupting = 0;
}
void StepGeyserEffect(CScene *scene) {
    int i = 0;
    if (GeyserEffectFlag != 0) {
        do {
            GeyserEffect[i].Step();
            i += 1;
        } while (i < 4);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editexception", DrawGeyserEffect__FP6CScene);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1175__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1176__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1177__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1178__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1184__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1327__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1329__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1330__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_917__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_918__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_919__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_920__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_921__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1084__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1085__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1086__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1143__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1259__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1385__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editexception", at_1386__3__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(rea_chara_id, 0x4);
INCLUDE_BSS(rea_mtn_step, 0x4);
INCLUDE_BSS(thunder_count, 0x4);
INCLUDE_BSS(start_thunder, 0x4);
INCLUDE_BSS(next_thunder_cnt, 0x4);
INCLUDE_BSS(fade_cnt, 0x4);
INCLUDE_BSS(sound_flag, 0x4);
INCLUDE_BSS(sound_cnt, 0x4);
INCLUDE_BSS(FirePowderFlag, 0x4);
INCLUDE_BSS(FirePowderTexb, 0x4);
INCLUDE_BSS(SpriteVis, 0x4);
INCLUDE_BSS(FirePowFrame, 0x4);
INCLUDE_BSS(fire_powder, 0x4);
INCLUDE_BSS(GeyserEffectFlag, 0x4);
INCLUDE_BSS(GeyserEffectTexb, 0x4);
INCLUDE_BSS(GeyserFrame, 0x4);
INCLUDE_BSS(GeyserRndSeed, 0x4);
INCLUDE_BSS(GeyserEffect, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_1328__2, 0x10);
