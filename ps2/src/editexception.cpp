#include "common.h"
#include "mw_runtime.h"

#include <cstdlib>
#include <cstring>

#include "character.hpp"
#include "dataread.hpp"
#include "editevent.hpp"
#include "editexception.hpp"
#include "event_func.hpp"
#include "funcpoint.hpp"
#include "mainloop.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "photo.hpp"
#include "scene.hpp"
#include "sound.hpp"

/**
 * Character reacting to the camera.
 */
static int rea_chara_id;

/**
 * Current motion step of the camera reaction.
 */
static int rea_mtn_step;

/**
 * Frames remaining in the current thunder flash.
 */
static int thunder_count;

/**
 * Thunder-start state cleared when S51 lightning is initialized.
 */
static int start_thunder;

/**
 * Frames until the next thunder flash.
 */
static int next_thunder_cnt;

/**
 * Frames remaining in the current thunder fade.
 */
static int fade_cnt;

/**
 * Whether thunder sound has been scheduled.
 */
static int sound_flag;

/**
 * Delay before the thunder sound.
 */
static int sound_cnt;

/**
 * Whether fire-powder rendering is enabled.
 */
static int FirePowderFlag;

/**
 * Texture block used by fire-powder sprites.
 */
static int FirePowderTexb;

/**
 * Sprite visual used for fire-powder rendering.
 */
static mgC3DSprite *SpriteVis;

/**
 * Frame that owns the fire-powder sprite visual.
 */
static mgCFrame *FirePowFrame;

/**
 * Fire-powder particles active in the scene.
 */
static FirePowder *fire_powder;

/**
 * Whether geyser rendering is enabled.
 */
static int GeyserEffectFlag;

/**
 * Texture block used by geyser particles.
 */
static int GeyserEffectTexb;

/**
 * Frame that owns the geyser particle visual.
 */
static mgCFrame *GeyserFrame;

/**
 * Random seed stored when geyser effects are initialized.
 */
static int GeyserRndSeed;

/**
 * Array of geyser emitters shared by placed geyser parts.
 */
static CGeyserEffect *GeyserEffect;

/**
 *
 * GS TEST register fields used by the edit map effects.
 *
 */
struct EditGsTest {
    u_long ate : 1;   /**< Alpha test enable. */
    u_long atst : 3;  /**< Alpha test mode. */
    u_long aref : 8;  /**< Alpha reference value. */
    u_long afail : 2; /**< Action when alpha test fails. */
    u_long date : 1;  /**< Destination alpha test enable. */
    u_long datm : 1;  /**< Destination alpha test mode. */
    u_long zte : 1;   /**< Depth test enable. */
    u_long ztst : 2;  /**< Depth test mode. */
    u_long rest : 45;
};

STATIC_ASSERT(sizeof(EditGsTest) == 8);

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u32 align16_blocks(u32 bytes) {
    if (bytes & 0xF) {
        return (bytes >> 4) + 1;
    }

    return bytes >> 4;
}

#include <cmath>

#include "editmap.hpp"
#include "editparts.hpp"
#include "map.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_tanime.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"

// Code (.text)
void EditExceptionStep(int map_no, CScene *scene) {
    int quarter;
    int frame;

    if (scene == NULL) {
        return;
    }

    mgCTextureManager *textures = &mgTexManager;
    CMap              *map = scene->GetMap(scene->active_map);

    if (map == NULL) {
        return;
    }

    mgCCamera *camera = scene->GetCamera(scene->active_camera);

    if (camera == NULL) {
        return;
    }

    float camera_pos[4];
    camera->GetPos(camera_pos);

    switch (map_no) {
        case 2:
        case 9: {
            CMapParts *parts = map->GetPlaceParts("p07_g0301");

            if (parts == NULL) {
                return;
            }

            CMapPiece *piece07 = parts->SearchPiece("g0301_07-m");
            CMapPiece *piece08 = parts->SearchPiece("g0301_08-m");

            if (piece07 == NULL) {
                return;
            }

            if (piece08 == NULL) {
                return;
            }

            mgCFrame *frame07 = piece07->frame;
            mgCFrame *frame08 = piece08->frame;

            if (frame07 == NULL) {
                return;
            }

            if (frame08 == NULL) {
                return;
            }

            mgCFrame *fade_frame = frame07->SearchFrame("na");

            if (fade_frame == NULL) {
                return;
            }

            mgCFrameAttr *attr = fade_frame->attr;

            if (attr == NULL) {
                return;
            }

            mgCTexture *texture = textures->GetTexture("g0301_21", -1);

            if (texture == NULL) {
                return;
            }

            mgCTextureAnime *anime = textures->GetTexAnime(texture->block);

            if (anime == NULL) {
                return;
            }

            CList<mgCTexAnimeData> *list = anime->GetAnimeList(anime->SearchGroupName("na"));

            if (list == NULL) {
                return;
            }

            mgCTexAnimeData *data = &list->data;
            quarter = data->period_y / 4;
            frame = data->phase_y - 20;

            if (frame < 0) {
                frame = 0;
            }

            float alpha = 0.0f;

            if (frame < quarter) {
                alpha = (float) frame / (float) quarter;
            } else if (frame < quarter * 3) {
                alpha = 1.0f - (float) (frame - quarter) / (float) (quarter * 2);
            }

            attr->obj_alpha = alpha;
            frame08->SetAttrParamObjAlpha((1.0f + sinf(6.2831855f * ((float) data->phase_y / (float) data->period_y))) / 0.5f, 1);
            break;
        }
    }
}

void InitNpcCameraReaction() {
    rea_mtn_step = 0;
    rea_chara_id = -1;
}

void InitS51Thunder() {
    thunder_count = 0;
    start_thunder = 0;
    next_thunder_cnt = 60;
    fade_cnt = 0;
    sound_cnt = 0;
    sound_flag = 0;
}

void S51Thunder(CScene *scene) {
    float ratio[2];

    char *map_name = scene->GetMapName(scene->active_map);

    if (map_name != NULL) {
        switch (strcmp(map_name, "s51")) {
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

        float fade = (float) fade_cnt / 40.0f;
        CMap *map = scene->GetMap(scene->active_map);

        if (map != NULL && map->GetTimeLightingRatio(ratio) >= 2) {
            ratio[0] = 1.0f - fade;
            ratio[1] = fade;
            CMapLightingInfo info;
            map->GetLightInfo(&info, ratio, 2);
            mgSetLight(info.light_dir, info.light_color);
            mgSetAmbient(info.ambient);

            for (int i = 0; i < 2; i++) {
                CMapParts *parts = NULL;

                if (i == 0) {
                    parts = map->GetPlaceParts("p05_s5102-0");
                }

                if (i == 1) {
                    parts = map->GetPlaceParts("p11_s5102-0");
                }

                if (parts != NULL) {
                    parts->show = 1;

                    for (CList<CMapPiece> *node = parts->piece_list; node != NULL;
                         node = node->next) {
                        CObject *piece = &node->data;
                        piece->fade = 1;
                        piece->fade_alpha = fade;
                    }
                }
            }
        }
    }
}

void InitFirePowder(int map_no, CScene *scene, int texb, mgCMemory *memory) {
    int         i;
    FirePowder *particle;
    int         size;
    u_char     *image;
    FirePowderFlag = 0;

    if (map_no != 3 && map_no != 0x57 && map_no != 0x55) {
        return;
    }

    if (GetSaveData()->GetBitFlag((int) SAVE_FLAG_EDIT_BLOCKED) != 0) {
        return;
    }

    u_char *buffer = (u_char *) scene->read_buff;

    if (LoadFile2("effect/firerain.img", buffer, &size, LOAD_FILE_READ) == 0) {
        return;
    }

    image = (u_char *) memory->Alloc(align16_blocks(size));
    memcpy(image, buffer, size);
    FirePowderFlag = 1;
    FirePowderTexb = texb;
    mgTexManager.DeleteBlock(texb);
    mgTexManager.EnterIMGFile(image, FirePowderTexb, NULL, NULL);

    SpriteVis = new (memory->Alloc(7)) mgC3DSprite;
    fire_powder = new (memory->Alloc(0x202)) FirePowder[FIRE_POWDER_NUM];
    FirePowFrame = new (memory->Alloc(0x13)) mgCFrame;
    mgCFrameAttr *attr = new (memory->Alloc(0xB)) mgCFrameAttr;
    FirePowFrame->attr = attr;
    attr->fog = 2;
    attr->z_write = MG_ZBUF_NO_WRITE;
    FirePowFrame->SetVisual(SpriteVis);

    for (i = 0; i < FIRE_POWDER_NUM; ++i) {
        particle = &fire_powder[i];
        particle->pos[0] = 2.0f * (200.0f * (mgRnd() - 0.5f));
        particle->pos[1] = 2.0f * (300.0f * (mgRnd() - 0.5f));
        particle->pos[2] = 2.0f * (200.0f * (mgRnd() - 0.5f));
        particle->pos[3] = 0.0f;
        particle->phase_speed = 0.1f + 0.1f * mgRnd();
        particle->sway_x = 2.0f * (2.0f * (mgRnd() - 0.5f));
        particle->sway_z = 2.0f * (2.0f * (mgRnd() - 0.5f));
        particle->fall_speed = -(0.1f + 0.5f * mgRnd());
    }
}

void StepFirePowder(CScene *scene) {
    if (!FirePowderFlag) {
        return;
    }

    for (int particle_index = 0; particle_index < FIRE_POWDER_NUM; ++particle_index) {
        FirePowder &particle = fire_powder[particle_index];
        particle.pos[1] += particle.fall_speed;

        if (particle.pos[1] < -300.0f) {
            particle.pos[1] = 300.0f;
        }

        particle.pos[3] += particle.phase_speed;

        if (particle.pos[3] > 3.1415927f) {
            particle.pos[3] -= 6.2831855f;
        }
    }
}

void DrawFirePowder(CScene *scene) {
    int i;

    if (!FirePowderFlag) {
        return;
    }

    mgTexManager.ReloadTexture(FirePowderTexb, (sceVif1Packet *) NULL);
    SpriteVis->Initialize();
    mgC3DSprite *draw_sprite = SpriteVis;
    mgCDrawEnv   draw_env = *mgGetpDrawEnv(0);
    ((EditGsTest *) &draw_env.test)->zte = 1;
    ((EditGsTest *) &draw_env.test)->ztst = 2;
    draw_env.SetZBuf(MG_ZBUF_NO_WRITE);
    draw_env.SetAlpha(MG_ALPHA_MACRO_ADD);
    draw_sprite->BeginCreatePacket(0, NULL);
    draw_sprite->CPSetDrawEnv(&draw_env);
    draw_sprite->CPSetTexture(mgTexManager.GetTexture("firerain", -1));
    draw_sprite->BeginCPSprite();
    sceVu0FVECTOR size = {5.0f, 5.0f, 0.0f, 0.0f};
    sceVu0FMATRIX uv0 = {
        {0.0f,  0.0f,  0.0f, 0.0f},
        {32.0f, 0.0f,  0.0f, 0.0f},
        {0.0f,  32.0f, 0.0f, 0.0f},
        {32.0f, 32.0f, 0.0f, 0.0f}
    };
    sceVu0FMATRIX uv1 = {
        {32.0f, 32.0f, 0.0f, 0.0f},
        {64.0f, 32.0f, 0.0f, 0.0f},
        {32.0f, 64.0f, 0.0f, 0.0f},
        {64.0f, 64.0f, 0.0f, 0.0f}
    };
    sceVu0FVECTOR color = {128.0f, 128.0f, 128.0f, 50.0f};

    for (i = 0; i < FIRE_POWDER_NUM; ++i) {
        FirePowder   &particle = fire_powder[i];
        sceVu0FVECTOR pos;
        pos[0] = particle.pos[0] + particle.sway_x * sinf(particle.pos[3]);
        pos[1] = particle.pos[1];
        pos[2] = particle.pos[2] + particle.sway_x * sinf(particle.pos[3]);
        pos[3] = 1.0f;
        int uv_id = i % 4;
        draw_sprite->CPSetSprite(pos, size, color, uv0[uv_id], uv1[uv_id]);
    }

    draw_sprite->EndCPSprite();
    draw_sprite->EndCreatePacket();
    mgCCamera    *camera = scene->GetCamera(scene->active_camera);
    sceVu0FVECTOR camera_pos, camera_dir;
    sceVu0FMATRIX camera_matrix;
    mgUnitMatrix(camera_matrix);
    camera->GetPos(camera_pos);
    camera->GetDir(camera_dir);
    mgNormalizeVector(camera_dir, camera_dir, 200.0f);
    mgAddVector(camera_pos, camera_dir);
    *(u_long128 *) camera_matrix[3] = *(u_long128 *) camera_pos;
    camera_matrix[3][3] = 1.0f;
    int         old_fog = mgGetFogEnable();
    mgFOG_PARAM old_fog_param;
    mgGetFogParam(&old_fog_param);
    sceVu0FVECTOR old_guard;
    *(u_long128 *) old_guard = *(u_long128 *) mgRenderInfo.guard_max;
    mgRenderInfo.guard_max[3] = 600.0f;
    mgFogEnable(1);
    mgSetFogParam(50.0f, 400.0f, 100, 0, 0, 255.0f, 0.0f);
    mgFlushRenderInfo();
    sceVu0FVECTOR centre;
    sceVu0FVECTOR half_extent = {200.0f, 300.0f, 200.0f, 0.0f};

    for (int axis = 0; axis < 3; ++axis) {
        int cell = (int) (camera_pos[axis] / half_extent[axis]);

        if (cell >= 0) {
            cell++;
        } else {
            cell--;
        }

        centre[axis] = (float) (cell / 2) * half_extent[axis] * 2.0f;
    }

    int x, z, y;

    for (x = -1; x <= 1; ++x) {
        for (z = -1; z <= 1; ++z) {
            for (y = -1; y <= 1; ++y) {
                sceVu0FVECTOR pos;
                *(u_long128 *) pos = *(u_long128 *) centre;
                pos[0] += (float) x * half_extent[0] * 2.0f;
                pos[1] += (float) y * half_extent[1] * 2.0f;
                pos[2] += (float) z * half_extent[2] * 2.0f;
                FirePowFrame->SetPosition(pos);
                mgDrawDirect(FirePowFrame);
            }
        }
    }

    mgFogEnable(old_fog);
    *(u_long128 *) mgRenderInfo.guard_max = *(u_long128 *) old_guard;
    mgSetFogParam(&old_fog_param);
    mgFlushRenderInfo();
}

void CGeyserEffect::Create() {
    if (wait <= 0) {
        if (wait == 0) {
            erupting = 1;
        }

        wait = static_cast<int>(150.0f * mgRnd()) + 100;
        erupt_frame = 0;
        erupt_count = static_cast<int>(32.0f * mgRnd()) + 48;
    }

    --wait;

    if (erupting) {
        if (erupt_frame % 12 != 0) {
            --erupt_count;
            CreatePoint();
        }

        ++erupt_frame;

        if (erupt_count <= 0) {
            erupting = 0;
        }
    }
}

void CGeyserEffect::Step() {
    Create();

    if (!point) {
        return;
    }

    for (int point_index = 0; point_index < point_num; ++point_index) {
        CGeyserEffectPoint &effect_point = point[point_index];

        if (!effect_point.active) {
            continue;
        }

        effect_point.alpha -= 0.02f;
        effect_point.pos[1] += effect_point.rise_speed;
        effect_point.scale += 0.1f;
        effect_point.pos[3] += effect_point.phase_speed;

        if (effect_point.pos[3] > 3.1415927f) {
            effect_point.pos[3] -= 6.2831855f;
        }

        if (effect_point.alpha < 0.0f) {
            effect_point.active = 0;
        }
    }
}

CGeyserEffectPoint *CGeyserEffect::GetEmpty() {
    if (!point) {
        return NULL;
    }

    for (int point_index = 0; point_index < point_num; ++point_index) {
        if (!point[point_index].active) {
            return &point[point_index];
        }
    }

    return NULL;
}

void CGeyserEffect::CreatePoint() {
    CGeyserEffectPoint *effect_point = GetEmpty();

    if (!effect_point) {
        return;
    }

    effect_point->active = 1;
    effect_point->alpha = 1.0f;
    effect_point->rise_speed = 2.6f + 0.4f * mgRnd();
    effect_point->scale = 1.0f;
    effect_point->sway_x = 2.0f * (2.0f * (mgRnd() - 0.5f));
    effect_point->sway_z = 2.0f * (2.0f * (mgRnd() - 0.5f));
    effect_point->phase_speed = 0.1f + 0.1f * mgRnd();
    mgZeroVectorW(effect_point->pos);
}

void CGeyserEffect::CreatePacket() {
    int i;

    if (point_num == 0 || point == NULL) {
        return;
    }

    sprite.Initialize();
    mgC3DSprite *draw_sprite = &sprite;
    mgCDrawEnv   draw_env = *mgGetpDrawEnv(0);
    ((EditGsTest *) &draw_env.test)->zte = 1;
    ((EditGsTest *) &draw_env.test)->ztst = 2;
    draw_env.SetZBuf(MG_ZBUF_NO_WRITE);
    draw_env.SetAlpha(MG_ALPHA_MACRO_ADD);
    draw_sprite->BeginCreatePacket(0, NULL);
    draw_sprite->CPSetDrawEnv(&draw_env);
    draw_sprite->CPSetTexture(texture);
    draw_sprite->BeginCPSprite();
    mgVec4 size = {
        {5.0f, 5.0f, 0.0f, 0.0f}
    };
    mgVec4 uv0 = {
        {0.0f, 0.0f, 0.0f, 0.0f}
    };
    mgVec4 uv1 = {
        {64.0f, 64.0f, 0.0f, 0.0f}
    };
    mgVec4 color = {
        {128.0f, 128.0f, 128.0f, 50.0f}
    };

    for (i = 0; i < point_num; ++i) {
        CGeyserEffectPoint &particle = point[i];

        if (!particle.active) {
            continue;
        }

        float pos[4];
        pos[0] = particle.pos[0] + particle.scale * particle.sway_x * sinf(particle.pos[3]);
        pos[1] = particle.pos[1];
        pos[2] = particle.pos[2] + particle.scale * particle.sway_z * sinf(particle.pos[3]);
        pos[3] = 1.0f;
        color.v[3] = 64.0f * particle.alpha;
        size.v[1] = size.v[0] = 15.0f * particle.scale;
        draw_sprite->CPSetSprite(pos, size.v, color.v, uv0.v, uv1.v);
    }

    draw_sprite->EndCPSprite();
    draw_sprite->EndCreatePacket();
}

void InitGeyserEffect(int scene_no, CScene *scene, int texb, mgCMemory *memory) {
    int size;
    u8 *copy;
    GeyserEffectFlag = 0;

    if (scene_no == 3) {
        u8 *buffer = (u8 *) scene->read_buff;

        if (LoadFile2("effect/geyser.img", buffer, &size, 0) != 0) {
            copy = (u8 *) memory->Alloc(align16_blocks(size));
            memcpy(copy, buffer, size);
            mgCTextureManager *textures = &mgTexManager;
            GeyserEffectFlag = 1;
            GeyserEffectTexb = texb;
            textures->DeleteBlock(texb);
            textures->EnterIMGFile(copy, GeyserEffectTexb, NULL, NULL);
            GeyserFrame = new (memory->Alloc(0x13)) mgCFrame;
            mgCFrameAttr *attr = new (memory->Alloc(0xB)) mgCFrameAttr;
            GeyserFrame->attr = attr;
            attr->fog = 2;
            attr->z_write = -1;
            GeyserEffect = new (memory->Alloc(0x22)) CGeyserEffect[4];

            for (int i = 0; i < 4; i++) {
                CGeyserEffectPoint *pool =
                    new (memory->Alloc(0x92)) CGeyserEffectPoint[0x30];
                GeyserEffect[i].point_num = 0x30;
                GeyserEffect[i].point = pool;
                GeyserEffect[i].texture = textures->GetTexture("geyser_eff", -1);
            }

            GeyserRndSeed = rand();
        }
    }
}

CGeyserEffectPoint::CGeyserEffectPoint() {
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
    if (!GeyserEffectFlag) {
        return;
    }

    for (int emitter_index = 0; emitter_index < GEYSER_EFFECT_NUM; ++emitter_index) {
        GeyserEffect[emitter_index].Step();
    }
}

void DrawGeyserEffect(CScene *scene) {
    int       count;
    int       i;
    CEditMap *map;

    if (!GeyserEffectFlag) {
        return;
    }

    map = (CEditMap *) scene->GetMap(scene->active_map);

    if (map == NULL) {
        return;
    }

    int ids[20];
    count = map->GetePlacePartsAtInfoID(0x4C, ids, 20);

    if (count <= 0) {
        return;
    }

    mgGetDataBuffer();
    mgTexManager.ReloadTexture(GeyserEffectTexb, (sceVif1Packet *) NULL);

    for (i = 0; i < GEYSER_EFFECT_NUM; ++i) {
        GeyserEffect[i].CreatePacket();
    }

    for (i = 0; i < count; ++i) {
        CEditParts *parts = map->GetePlaceParts(ids[i]);

        if (parts == NULL) {
            continue;
        }

        int   emitter = ((ids[i] * 0x10DE8 + 1) >> 16) % GEYSER_EFFECT_NUM;
        float pos[4];
        parts->GetPosition(pos);
        GeyserFrame->SetVisual(&GeyserEffect[emitter % GEYSER_EFFECT_NUM].sprite);
        GeyserFrame->SetPosition(pos);
        mgDrawDirect(GeyserFrame);
    }
}
