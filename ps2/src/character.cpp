#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "actscript.hpp"
#include "character.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "dynamicanime.hpp"
#include "effect.hpp"
#include "effscript.hpp"
#include "gameutil.hpp"
#include "map.hpp"
#include "mg_camera.hpp"
#include "mg_dataset.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "outline.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "swordeffect.hpp"
#include "visualmotion.hpp"

/**
 * Character whose model or info script is being loaded.
 */
static CCharacter2 *nowChr;
/**
 * Pack archive supplying character model files.
 */
static u32 *pack_file;
/**
 * Memory used for the character model and frame data.
 */
static mgCMemory *base_stack;
/**
 * Texture block receiving the character images.
 */
static int set_imgblock;
/**
 * Object name selected for the skin model.
 */
static char *skin_name_ptr;
/**
 * Root frame receiving the skin model.
 */
static mgCFrame *root_skin_frame;
/**
 * Skin-model frame currently being loaded.
 */
static mgCFrame *skin_frame;
/**
 * File name of the selected skin model.
 */
static char skin_mds_name[64];
/**
 * Image archive selected by the current image tag.
 */
static unsigned char *load_img_ptr;
/**
 * Size of the selected image archive.
 */
static int load_img_size;
/**
 * Memory used for character image archive copies.
 */
static mgCMemory *img_stack;
/**
 * Image archives loaded by the current character script.
 */
static mgIMG_FILE_HEADER *img_ptr[CHARA_IMAGE_MAX];
/**
 * Texture identifier used by character outlines.
 */
static int outline_tex_id;
/**
 * Memory used for the current motion or sequence records.
 */
static mgCMemory *now_stack;
/**
 * Sequence entry currently being parsed.
 */
static CHRINFO_SEQ *now_seq_ptr;
/**
 * Sequence header currently being parsed.
 */
static CHRINFO_SEQ_HEADER *now_seqhd_ptr;
/**
 * Effect pack selected by the character script.
 */
static unsigned int *eff_pack_ptr;
/**
 * Size of the selected effect pack.
 */
static int eff_pack_size;
/**
 * Number of model objects that need deformable vertices.
 */
static int alloc_vertex_num;
/**
 * Names of model objects that need deformable vertices.
 */
static char alloc_vertex[25][16];
/**
 * External memory available to the character loader.
 */
static mgCMemory *ext_stack;
/**
 * Whether the character loader creates outlines.
 */
static int outline_flag;
/**
 * Parent character supplying a shared outline texture.
 */
static CCharacter2 *parent_chr;
/**
 * Whether an outline texture has been selected.
 */
static int outline_start;
/**
 * Outline texture selected for the character.
 */
static mgCTexture *outline_start_tex;
/**
 * Number of shadow objects that need deformable vertices.
 */
static int alloc_shadow_vertex_num;
/**
 * Cloth record currently being parsed.
 */
static int now_cloth_id;
/**
 * Motion set currently being parsed.
 */
static int now_motion_id;
/**
 * Motion key currently being parsed.
 */
static CHRINFO_KEY_SET *now_key_ptr;

/**
 * Sound event array currently being parsed.
 */
static CHRINFO_SE *now_se_header;

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u32 DynAnimeAlign16Blocks(u32 n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

static void ScanInfoFile(CCharacter2 *chara, u32 *pack_file, char *info_name, mgCMemory *memory,
                         mgCMemory *ext_memory, mgCMemory *img_memory, int texture_block, CCharacter2 *parent,
                         int with_line);
static int  _V2(SPI_STACK *stack, int argc);
static int  _NAME(SPI_STACK *stack, int argc);
static int  _BODY_SIZE(SPI_STACK *stack, int argc);
static int  _SCALE(SPI_STACK *stack, int argc);
static int  _MATERIAL_ANIME(SPI_STACK *stack, int argc);
static int  _POLY_NUM(SPI_STACK *stack, int argc);
static int  _IMG(SPI_STACK *stack, int argc);
static int  _IMG_END(SPI_STACK *stack, int argc);
static int  _OUTLINE(SPI_STACK *stack, int argc);
static int  _SHADOW_MODEL(SPI_STACK *stack, int argc);
static int  _OBJECT_NAME(SPI_STACK *stack, int argc);
static int  _OBJECT_NAME2(SPI_STACK *stack, int argc);
static int  _MOTION(SPI_STACK *stack, int argc);
static int  _SHADOW_MOTION(SPI_STACK *stack, int argc);
static int  _VERTEX_ANIME(SPI_STACK *stack, int argc);
static int  _SHAPE_ANIME(SPI_STACK *stack, int argc);
static int  _KEY_START(SPI_STACK *stack, int argc);
static int  _KEY(SPI_STACK *stack, int argc);
static int  _KEY_END(SPI_STACK *stack, int argc);
static int  _SEQ(SPI_STACK *stack, int argc);
static int  _SEQ_END(SPI_STACK *stack, int argc);
static int  _CLOTH_START(SPI_STACK *stack, int argc);
static int  _CLOTH(SPI_STACK *stack, int argc);
static int  _CLOTH_END(SPI_STACK *stack, int argc);
static int  _POSITION(SPI_STACK *stack, int argc);
static int  _ROTATION(SPI_STACK *stack, int argc);
static int  _SE_START(SPI_STACK *stack, int argc);
static int  _SE(SPI_STACK *stack, int argc);
static int  _SELP(SPI_STACK *stack, int argc);
static int  _SE_END(SPI_STACK *stack, int argc);
static int  _MOTION_END(SPI_STACK *stack, int argc);
static int  _EFFECT_START(SPI_STACK *stack, int argc);
static int  _EFFECT_END(SPI_STACK *stack, int argc);
static void ScanInfoSkinFile(CCharacter2 *chara, u32 *pack_file, char *info_name, char *skin_name,
                             mgCMemory *memory, int texture_block);
static int  _SKIN_IMG(SPI_STACK *stack, int argc);
static int  _SKIN_IMG_END(SPI_STACK *stack, int argc);
static int  _SKIN_MODEL(SPI_STACK *stack, int argc);
static int  _LOD_MODEL_START(SPI_STACK *stack, int argc);
static int  _LOD_MODEL_END(SPI_STACK *stack, int argc);
#include <libvu0.h>

static int _MODEL(SPI_STACK *stack, int argument_count);
static int _SEQ_START(SPI_STACK *stack, int argument_count);
static int _EFFECT(SPI_STACK *stack, int argument_count);
static int _LOD_MODEL(SPI_STACK *stack, int argument_count);

/**
 * Tags accepted by the character model and motion parser.
 */
static SPI_TAG_PARAM tag[] = {
    {"V2",              _V2             },
    {"NAME",            _NAME           },
    {"IMG",             _IMG            },
    {"IMG_END",         _IMG_END        },
    {"BODY_SIZE",       _BODY_SIZE      },
    {"SCALE",           _SCALE          },
    {"MATERIAL_ANIME",  _MATERIAL_ANIME },
    {"POLY_NUM",        _POLY_NUM       },
    {"MODEL",           _MODEL          },
    {"SHADOW_MODEL",    _SHADOW_MODEL   },
    {"OBJECT_NAME",     _OBJECT_NAME    },
    {"OBJECT_NAME2",    _OBJECT_NAME2   },
    {"MOTION",          _MOTION         },
    {"SHADOW_MOTION",   _SHADOW_MOTION  },
    {"OUTLINE",         _OUTLINE        },
    {"VERTEX_ANIME",    _VERTEX_ANIME   },
    {"SHAPE_ANIME",     _SHAPE_ANIME    },
    {"KEY_START",       _KEY_START      },
    {"KEY",             _KEY            },
    {"KEY_END",         _KEY_END        },
    {"SEQ_START",       _SEQ_START      },
    {"SEQ",             _SEQ            },
    {"SEQ_END",         _SEQ_END        },
    {"CLOTH_START",     _CLOTH_START    },
    {"CLOTH",           _CLOTH          },
    {"CLOTH_END",       _CLOTH_END      },
    {"POSITION",        _POSITION       },
    {"ROTATION",        _ROTATION       },
    {"SE_START",        _SE_START       },
    {"SE",              _SE             },
    {"SELP",            _SELP           },
    {"SE_END",          _SE_END         },
    {"MOTION_END",      _MOTION_END     },
    {"EFFECT_START",    _EFFECT_START   },
    {"EFFECT",          _EFFECT         },
    {"EFFECT_END",      _EFFECT_END     },
    {"LOD_MODEL_START", _LOD_MODEL_START},
    {"LOD_MODEL",       _LOD_MODEL      },
    {"LOD_MODEL_END",   _LOD_MODEL_END  },
    {NULL,              NULL            },
};

static int _SKIN_MOTION(SPI_STACK *stack, int argument_count);

/**
 * Tags accepted by the character skin-model parser.
 */
static SPI_TAG_PARAM skin_tag[] = {
    {"IMG",     _SKIN_IMG    },
    {"IMG_END", _SKIN_IMG_END},
    {"MODEL",   _SKIN_MODEL  },
    {"MOTION",  _SKIN_MOTION },
    {NULL,      NULL         },
};

// Code (.text)
void CCharacter2::SetPosition(float *pos) {
    mgCObject::SetPosition(pos);
}

void CCharacter2::AddOutLine(char *name, COutLineDraw *line) {
    mgCFrame     *target;
    COutLineDraw *p;
    COutLineDraw *last;
    COutLineDraw *q;

    if (name != NULL) {
        target = this->CObjectFrame::frame;

        if (name[0] != 0) {
            target = target->SearchFrame(name);

            if (target == NULL) {
                for (p = outline; p != NULL; p = p->next) {
                    target = p->frame->SearchFrame(name);

                    if (target != NULL) {
                        break;
                    }
                }
            }
        }

        if (target != NULL) {
            if (target->parent != NULL) {
                mgCFrameAttr *attr = target->attr;

                if (attr != NULL) {
                    attr->draw |= 4;
                }
            }

            line->SetFrame(target);
            last = outline;

            if (last == NULL) {
                outline = line;
                return;
            }

            if (last != NULL) {
                do {
                    q = last->next;

                    if (q == NULL) {
                        break;
                    }

                    last = q;
                } while (q != NULL);
            }

            last->next = line;
        }
    }
}

void CCharacter2::CopyOutLine(CCharacter2 *other) {
    COutLineDraw *line;
    mgCTexture   *texture;

    if (other == NULL) {
        return;
    }

    if (other->outline == NULL) {
        return;
    }

    texture = other->outline->texture;

    if (texture == NULL) {
        return;
    }

    for (line = outline; line != NULL; line = line->next) {
        line->texture = texture;
    }
}

int CCharacter2::Draw() {
    sceVu0FVECTOR world_position;
    float         draw_alpha;
    float         clip_alpha;
    int           count;
    int           i;

    if (!CheckDraw()) {
        return 0;
    }

    draw_alpha = alpha;

    if (!FarClip(mgGetDistFromCamera(position), &clip_alpha)) {
        return 0;
    }

    draw_alpha *= clip_alpha;

    if (CObjectFrame::frame != NULL) {
        CObjectFrame::frame->SetPosition(position);
        CObjectFrame::frame->SetRotation(rotation);
        CObjectFrame::frame->SetScale(scale);
        CObjectFrame::frame->GetWorldPosition0(world_position);
    }

    SetDeformMesh();
    count = 0;

    if (CObjectFrame::frame != NULL) {
        CObjectFrame::frame->SetAttrParamObjAlpha(draw_alpha, 1);
    }

    count += mgDraw(CObjectFrame::frame);

    for (i = 0; i < dynamic_anime_num; i++) {
        count += dynamic_anime[i].DrawSub(0);
    }

    return count;
}

void CCharacter2::SetDeformMesh() {
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;
    int           i;

    for (i = 0; i < deform_frame_num; i++) {
        if (deform_frame[i] != NULL) {
            deform_frame[i]->RemakeBBox(max, min);
        }
    }
}

void CCharacter2::DrawStep() {
    float clip_alpha;

    FarClip(GetCameraDist(), &clip_alpha);
}

float CCharacter2::GetCameraDist() {
    sceVu0FVECTOR head_position;
    sceVu0FVECTOR camera_position;
    sceVu0FVECTOR closest_position;
    float         height;

    height = body_height;

    if (height < 1.0f) {
        height = 34.0f;
    }

    *(u_long128 *) head_position = *(u_long128 *) position;
    head_position[1] += height;
    mgGetCameraPos(camera_position);
    return mgDistLinePoint(camera_position, position, head_position, closest_position);
}

int CCharacter2::DrawDirect() {
    float world_pos[4];

    /**
     *
     * Outline state copied while drawing a character directly.
     *
     */
    struct OutlineCopy {
        COutLineDraw *next;
        u_long128     box[2];
        int           enabled;
        mgCFrame     *frame;
        float         width;
        int           depth;
        float         pos[4];
        float         color[4];
        int           enable;
        int           hide;
    };

    OutlineCopy   lod_line;
    float         entry_pos[4];
    float         view_pos[4];
    float         step_alpha;
    COutLineDraw *line;
    CCharaLOD    *lod_entry;
    mgCFrame     *lod_frame;
    float         alpha;
    float         camera_dist;
    float         fade;
    int           lod_no;
    int           count;
    int           i;
    int           j;

    alpha = this->alpha;
    camera_dist = GetCameraDist();

    if (FarClip(camera_dist, &step_alpha) == 0) {
        return 0;
    }

    alpha *= step_alpha;

    if (CheckDraw() == 0) {
        return 0;
    }

    if (CObjectFrame::frame != NULL) {
        CObjectFrame::frame->SetPosition(position);
        CObjectFrame::frame->SetRotation(rotation);
        CObjectFrame::frame->SetScale(scale);
        CObjectFrame::frame->GetWorldPosition0(world_pos);
    }

    lod_no = 0;

    for (j = 0; j < lod_num - 1; j++) {
        if (lod[j].distance < camera_dist) {
            lod_no = j + 1;
        }
    }

    if (lod_no >= lod_num) {
        lod_no = lod_num - 1;
    }

    lod_frame = ChangeLOD(lod_no);
    line = outline;

    if (lod_frame != NULL) {
        if (line == NULL) {
            return mgDrawDirect(lod_frame);
        }

        lod_line = *(OutlineCopy *) line;
        lod_line.next = NULL;
        ((COutLineDraw *) &lod_line)->SetFrame(lod_frame);
        line = (COutLineDraw *) &lod_line;
    }

    SetDeformMesh();
    count = 0;

    if (line != NULL) {
        fade = 1.0f;

        if (entry_frame[0] != NULL) {
            GetEntryObjectPos(0, entry_pos);
        } else {
            *(u_long128 *) entry_pos = *(u_long128 *) world_pos;
            entry_pos[3] = 1.0f;
        }

        mgTransWorldView(view_pos, entry_pos);

        if (!(view_pos[2] <= 10.0f)) {
            fade = 1.0f - (view_pos[2] - 10.0f) / 300.0f;

            if (fade < 0.0f) {
                fade = 0.0f;
            }
        }

        if (alpha < 1.0f) {
            COutLineDraw *walk = outline;

            while (walk != NULL) {
                if (walk->frame != NULL) {
                    mgCFrameAttr *attr = walk->frame->attr;

                    if (attr != NULL) {
                        attr->draw &= ~4;
                    }
                }

                walk = walk->next;
            }

            line = outline;
            count += line->Draw(position, fade, alpha);

            while (line != NULL) {
                if (line->frame != NULL) {
                    mgCFrameAttr *attr = line->frame->attr;

                    if (attr != NULL) {
                        attr->draw |= 4;
                    }
                }

                line = line->next;
            }
        } else {
            while (line != NULL) {
                count += line->Draw(position, fade, alpha);
                line = line->next;
            }
        }
    } else {
        if (CObjectFrame::frame != NULL) {
            CObjectFrame::frame->SetAttrParamObjAlpha(alpha, 1);
        }

        count += mgDrawDirect(CObjectFrame::frame);
    }

    for (i = 0; i < dynamic_anime_num; i++) {
        count += dynamic_anime[i].DrawSub(1);
    }

    return count;
}

int CCharacter2::DrawShadowDirect() {
    if (!show) {
        return 0;
    }

    if (!CheckDraw()) {
        return 0;
    }

    if (shadow_frame == NULL) {
        return 0;
    }

    CCharacter2::ShadowStep();
    shadow_frame->SetPosition(position);
    shadow_frame->SetRotation(rotation);
    shadow_frame->SetScale(scale);

    if (now_set >= 0 && now_set < CHARA_MOTION_SET_MAX) {
        DeformMesh(shadow_frame, &shadow_motion[now_set], shadow_frame_info, false);
    }

    return mgDrawDirect(shadow_frame);
}

void CCharacter2::UpdatePosition() {
    if (CObjectFrame::frame != NULL) {
        CObjectFrame::frame->SetPosition(position);
        CObjectFrame::frame->SetRotation(rotation);
        CObjectFrame::frame->SetScale(scale);
    }

    if (shadow_frame != NULL) {
        shadow_frame->SetPosition(position);
        shadow_frame->SetRotation(rotation);
        shadow_frame->SetScale(scale);
    }
}

void CCharacter2::ResetDAPosition() {
    int i;

    UpdatePosition();

    if (dynamic_anime_num == 0 || dynamic_anime == NULL) {
        return;
    }

    for (i = 0; i < dynamic_anime_num; i++) {
        dynamic_anime[i].ResetPosition();
    }
}

float CCharacter2::GetDefaultStep() {
    if (now_key != NULL) {
        return now_key->step;
    }

    return 0.0f;
}

void CCharacter2::SetStep(float frame_step) {
    step = frame_step;
}

void CCharacter2::ResetMotion() {
    now_key = NULL;
    next_key = NULL;
    now_seq = NULL;
    next_seq = NULL;
}

float CCharacter2::GetChgStepWait() {
    if (motion_status != CHARA_MOTION_STATUS_BLEND) {
        return -1.0f;
    }

    return blend;
}

int CCharacter2::CheckMotionEnd() {
    if (now_key == 0) {
        return 1;
    }

    float margin = 1.2f * step;

    if (frame <= now_key->end_frame && !(frame + 2.0f * margin < now_key->end_frame)) {
        return 1;
    }

    return 0;
}

void CCharacter2::SetMotion(int no, int flags) {
    CHRINFO_KEY_SET *key;
    int              set;

    key = GetKeyListIndexPtr(no, &set);

    if (key != NULL) {
        next_key = key;
        next_flags = flags;
        next_set = set;
        blend_speed = 0.2f;
        seq_mode = 0;
        now_seq = NULL;
        seq_state = CHARA_SEQ_STATE_NONE;
    }
}

void CCharacter2::SetMotion(char *name, int flags) {
    SetMotionPara(name, flags, -1);
}

void CCharacter2::SetNowFrameWeight(float weight) {
    float range;

    if (now_key != NULL) {
        if (weight < 0.0f) {
            weight = 0.0f;
        }

        if (weight > 1.0f) {
            weight = 1.0f;
        }

        range = (float) (now_key->end_frame - now_key->start_frame);
        SetNowFrame((float) now_key->start_frame + range * weight);
    }
}

void CCharacter2::SetMotionPara(char *name, int flags, int keep_seq) {
    CHRINFO_KEY_SET    *key;
    CHRINFO_SEQ_HEADER *sequence;
    int                 set;

    key = GetKeyListPtr(name, &set);

    if (key != NULL) {
        next_key = key;
        next_flags = flags;
        next_set = set;
        blend_speed = 0.2f;

        if (keep_seq == -1 || keep_seq == 0) {
            seq_mode = 0;
            now_seq = NULL;
            seq_state = CHARA_SEQ_STATE_NONE;
        }
    } else {
        sequence = GetSeqHeaderPtr(name, &set);

        switch ((int) sequence) {
            case 0:
                break;
            default:
                next_seq = sequence;
                seq_mode = 1;
                seq_flags = flags;
        }
    }
}

void CCharacter2::SetDAnimeEnable(int enable) {
    if (enable != 0) {
        dynamic_anime_flags &= ~CHARA_DYNAMIC_ANIME_DISABLE;
    } else {
        dynamic_anime_flags |= CHARA_DYNAMIC_ANIME_DISABLE;
    }
}

CHRINFO_SE *CCharacter2::GetSoundInfoCopy(mgCMemory *memory) {
    u32         bytes;
    u32         blocks;
    u_long128  *block;
    CHRINFO_SE *copy;

    if (se_num[0] <= 0) {
        return NULL;
    }

    bytes = se_num[0] * (int) sizeof(CHRINFO_SE);

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    block = memory->Alloc(blocks + 2);
    copy = new (block) CHRINFO_SE[se_num[0]];
    memcpy(copy, se_list[0], se_num[0] * (int) sizeof(CHRINFO_SE));
    return copy;
}

int CCharacter2::CheckFootEffect() {
    if (sound_info.foot_effect_wait <= 0) {
        return -1;
    }

    return sound_info.foot_sound_id;
}

void CCharacter2::SePlay() {
    CHRINFO_SE *key;
    float       pos[4];
    float       passed;
    float       low;
    float       high;
    int         i;

    if (sound_info.foot_effect_wait > 0) {
        sound_info.foot_effect_wait--;
    }

    float now = frame;
    passed = 1.6f * (1.2f * step);
    key = se_list[now_set];
    low = now - passed;
    high = now + passed;

    if (key == NULL) {
        return;
    }

    sound_info.se_volume = 1.0f;
    sound_info.se_pan = 0.0f;
    i = 0;

    if (sound_info.se_positional == 1) {
        GetEntryObjectPos(0, pos);
        float far_dist = 1200.0f;
        float near_dist = 160.0f;
        sndGetVolPan(&sound_info.se_volume, &sound_info.se_pan, pos, 160.0f, 1200.0f);
    }

    for (i = 0; i < se_num[now_set]; key++, i++) {
        if (key->loop_slot > 0) {
            if (!(frame < key->frame) && frame <= key->end_frame) {
                if (key->kind == 2) {
                    if (sound_info.loop_se != NULL) {
                        sound_info.loop_se->SeLoopPlayStop(sound_info.se_bank, key->se_no, key->loop_slot,
                                                           13);
                    }
                }

                if (key->kind == 3) {
                    if (sound_info.loop_se != NULL) {
                        sound_info.loop_se->SeLoopPlayStop(sound_info.se_bank_2, key->se_no, key->loop_slot,
                                                           13);
                    }
                }
            }

            key->wait = 0;
        } else if (low < key->frame && !(high <= key->frame) && key->wait == 0) {
            if (key->kind < 2 && sound_info.foot_sound_enable != 0) {
                if (sound_info.foot_sound_id >= 0) {
                    sndSePlayVPf(sound_info.foot_se_bank, key->kind + sound_info.foot_sound_id * 2, sound_info.se_volume, sound_info.se_pan, 0);
                }

                sound_info.foot_effect_wait = 1;
                key->wait = 6;
            }

            if (key->kind == 2) {
                sndSePlayVPf(sound_info.se_bank, key->se_no, sound_info.se_volume, sound_info.se_pan, 0);
                key->wait = 6;
            }

            if (key->kind == 4) {
                sndSePlayVPf(sound_info.se_bank, key->se_no, sound_info.se_volume, sound_info.se_pan, 0);
                key->wait = 6;
                sound_info.foot_effect_wait = 1;
            }

            if (key->kind == 3) {
                sndSePlayVPf(sound_info.se_bank_2, key->se_no, sound_info.se_volume, sound_info.se_pan, 0);
                key->wait = 6;
            }
        }

        if (key->wait > 0) {
            key->wait--;
        }
    }
}

void CCharacter2::Step() {
    float        matrix[4][4];
    int          sequence_done;
    int          reset_dynamic_anime;
    int          motion_state;
    int          now_flags;
    float        entry_angle;
    CHRINFO_SEQ *playing;
    float       *entry_pos;

    if (CheckDraw() == 0) {
        return;
    }

    UpdatePosition();

    if (motion_enable == 0) {
        return;
    }

    SePlay();

    if (seq_mode == 0) {
        NormalDrive();
    }

    if (seq_mode == 1) {
        if (next_seq != now_seq) {
            now_seq = next_seq;
            seq_step = NULL;
            seq_loop = 0;
            seq_advance = 0;
            seq_state = (int) CHARA_SEQ_STATE_NONE;

            if (now_seq != NULL) {
                seq_step = now_seq->seq;

                if (seq_step != NULL) {
                    seq_state = (int) CHARA_SEQ_STATE_START;
                    now_flags = seq_flags;

                    switch (seq_step->type) {
                        case CHRINFO_SEQ_LOOP:
                            seq_loop = seq_step->loop_count;
                            break;
                        default:
                        case CHRINFO_SEQ_ONCE:
                        case CHRINFO_SEQ_HOLD_WAIT:
                            now_flags |= (int) CHARA_MOTION_HOLD;
                            break;
                        case CHRINFO_SEQ_WAIT:
                        case CHRINFO_SEQ_LOOP_WAIT:
                            break;
                    }

                    SetMotionPara(seq_step->name, now_flags, 1);
                    blend_speed = seq_step->blend_speed;

                    if (!(blend_speed < 1.0f)) {
                        blend = 1.0f;
                    }

                    NormalDrive();
                    return;
                }
            }
        }

        if (now_seq == NULL) {
            return;
        }

        if (seq_step == NULL) {
            return;
        }

        seq_state = (int) CHARA_SEQ_STATE_PLAY;
        sequence_done = 0;
        motion_state = GetMotionStatus();

        switch (seq_step->type) {
            case CHRINFO_SEQ_ONCE:
                if (motion_state == (int) CHARA_MOTION_STATUS_END) {
                    sequence_done = 1;
                }

                break;
            case CHRINFO_SEQ_LOOP:
                if (motion_state == (int) CHARA_MOTION_STATUS_END) {
                    seq_loop--;

                    if (seq_loop <= 0) {
                        sequence_done = 1;
                    }
                }

                break;
            case CHRINFO_SEQ_HOLD_WAIT:
            case CHRINFO_SEQ_LOOP_WAIT:
                if (motion_state == (int) CHARA_MOTION_STATUS_END) {
                    seq_state = (int) CHARA_SEQ_STATE_WAIT;

                    if (seq_advance != 0) {
                        sequence_done = 1;
                    }
                }

                break;
            case CHRINFO_SEQ_WAIT:
                seq_state = (int) CHARA_SEQ_STATE_WAIT;

                if (seq_advance != 0) {
                    sequence_done = 1;
                }

                break;
        }

        if (sequence_done != 0) {
            playing = seq_step;

            if (playing[1].name[0] == 0) {
                seq_state = (int) CHARA_SEQ_STATE_END;
                return;
            }

            seq_step = playing + 1;
            seq_loop = 0;
            seq_advance = 0;

            if (seq_step != NULL) {
                now_flags = 0;

                switch (seq_step->type) {
                    case CHRINFO_SEQ_LOOP:
                        seq_loop = seq_step->loop_count;
                        break;
                    case CHRINFO_SEQ_ONCE:
                    case CHRINFO_SEQ_HOLD_WAIT:
                        now_flags = (int) CHARA_MOTION_HOLD;
                        break;
                    case CHRINFO_SEQ_WAIT:
                    case CHRINFO_SEQ_LOOP_WAIT:
                        break;
                }

                SetMotionPara(seq_step->name, now_flags, 1);
                blend_speed = seq_step->blend_speed;

                if (!(blend_speed < 1.0f)) {
                    blend = 1.0f;
                }
            }
        }

        NormalDrive();
    }

    reset_dynamic_anime = 0;
    GetEntryObjectPos(0, matrix);
    entry_pos = matrix[3];

    if (mgDistVector(entry_pos, entry_matrix[3]) > 20.0f) {
        reset_dynamic_anime = 1;
    }

    if (reset_dynamic_anime == 0) {
        entry_angle = atan2f(matrix[2][0], matrix[2][2]);

        if (mgAngleCmp(entry_angle, atan2f(entry_matrix[2][0], entry_matrix[2][2]), 0.7853982f) != 0) {
            reset_dynamic_anime = 1;
        }
    }

    *(u_long128 *) entry_matrix[0] = *(u_long128 *) matrix[0];
    *(u_long128 *) entry_matrix[1] = *(u_long128 *) matrix[1];
    *(u_long128 *) entry_matrix[2] = *(u_long128 *) matrix[2];
    *(u_long128 *) entry_matrix[3] = *(u_long128 *) entry_pos;

    if (reset_dynamic_anime != 0) {
        ResetDAPosition();
    }

    StepDA(1);
    CtrlEffect();
}

void CCharacter2::StepDA(int count) {
    int index;
    int iteration;

    if ((dynamic_anime_flags & CHARA_DYNAMIC_ANIME_DISABLE) != 0) {
        return;
    }

    if (dynamic_anime_num == 0 || dynamic_anime == NULL) {
        return;
    }

    for (index = 0; index < dynamic_anime_num; index++) {
        if (count < 0) {
            dynamic_anime[index].ResetPosition();
        } else {
            for (iteration = 0; iteration < count; iteration++) {
                dynamic_anime[index].Step();
            }
        }
    }
}

void CCharacter2::SetWind(float power, float *dir) {
    int index;

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].SetWind(power, dir);
    }
}

void CCharacter2::ResetWind() {
    int index;

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].ResetWind();
    }
}

void CCharacter2::SetFloor(float y) {
    int index;

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].SetFloor(y);
    }
}

void CCharacter2::ResetFloor() {
    int index;

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].ResetFloor();
    }
}

void CCharacter2::NormalDrive() {
    float frame_step;
    float motion_speed = 1.2f;

    if (next_key != now_key && next_key != NULL) {
        posed_key = now_key;
        prev_flags = now_flags;
        prev_set = now_set;
        prev_frame = frame;
        now_key = next_key;
        step = now_key->step;
        now_set = next_set;
        now_flags = next_flags;
        blend = 0.1f;
        motion_status = CHARA_MOTION_STATUS_START;

        if ((next_flags & CHARA_MOTION_RESTART) != 0) {
            posed_key = next_key;
            frame = now_key->start_frame;
        }

        ExecEntryEffect(now_key);
    } else if (now_flags != next_flags && next_key != NULL) {
        now_flags = next_flags;

        if ((next_flags & CHARA_MOTION_RESTART) != 0) {
            motion_status = CHARA_MOTION_STATUS_START;
            posed_key = next_key;
            frame = now_key->start_frame;
        }
    }

    if (now_key == NULL) {
        return;
    }

    if (posed_key == now_key) {
        frame_step = step * motion_speed;

        if ((now_flags & CHARA_MOTION_PAUSE) != 0) {
            frame_step = 0.0f;
        }

        frame += frame_step;

        if (!(frame_step <= 0.0f)) {
            motion_status = CHARA_MOTION_STATUS_PLAY;
        }

        if (frame < now_key->start_frame + step * motion_speed && !(frame < now_key->start_frame)) {
            frame = now_key->start_frame;
            motion_status = CHARA_MOTION_STATUS_START;
        }

        if (!(frame + step * motion_speed <= now_key->end_frame)) {
            if ((now_flags & CHARA_MOTION_HOLD) != 0) {
                frame = now_key->end_frame;
                motion_status = CHARA_MOTION_STATUS_END;
                step = 0.0f;
            } else {
                frame = now_key->start_frame;
                motion_status = CHARA_MOTION_STATUS_END;
                ExecEntryEffect(now_key);
            }
        }
    }

    if (posed_key == now_key) {
        frame_ratio = now_key->end_frame - now_key->start_frame;
        frame_ratio = (frame - now_key->start_frame) / frame_ratio;
        SetMotionTime(CObjectFrame::frame, &motion[now_set], frame, NULL);
        return;
    }

    if (!(blend < 1.0f)) {
        posed_key = now_key;
        frame = now_key->start_frame;
        motion_status = CHARA_MOTION_STATUS_START;
        return;
    }

    frame_ratio = 0.0f;
    motion_status = CHARA_MOTION_STATUS_BLEND;
    ChangeMotion(CObjectFrame::frame, &motion[now_set], (int) (0.9f + frame), now_key->start_frame, blend, NULL);
    blend += blend_speed;

    if (!(blend < 1.0f)) {
        posed_key = now_key;
        frame = now_key->start_frame;
        motion_status = CHARA_MOTION_STATUS_START;
    }
}

void CCharacter2::ShadowStep() {
    int       i;
    mgCFrame *source;
    mgCFrame *root;
    mgCFrame *shadow;
    float     matrix[4][4];
    float     scale_vec[4];

    if (shadow_frame != NULL && CheckDraw() != 0 && motion_enable != 0 && now_key != NULL) {
        root = CObjectFrame::frame;

        for (i = 0; i < shadow_link.num; i++) {
            source = root->GetFrame(shadow_link.src_frame[i]);

            if (source != NULL) {
                shadow = shadow_frame->GetFrame(shadow_link.dst_frame[i]);

                if (shadow != NULL) {
                    source->GetScale(scale_vec);
                    sceVu0CopyMatrix(matrix, source->trans_matrix);
                    shadow->SetTransMatrix(matrix);
                    shadow->SetScale(scale_vec);
                }
            }
        }
    }
}

CHRINFO_KEY_SET *CCharacter2::GetKeyListIndexPtr(int motion_no, int *out_list) {
    int              number;
    int              list;
    int              i;
    CHRINFO_KEY_SET *key;

    number = 0;
    list = 0;

    do {
        key = key_list[list];

        if (key != NULL) {
            for (i = 0; i < key_num[list]; i++) {
                if (key->name[0] == 0) {
                    break;
                }

                if (number == motion_no) {
                    if (out_list != NULL) {
                        *out_list = list;
                    }

                    return key;
                }

                key++;
                number++;
            }
        }

        list++;
    } while (list < 8);

    return NULL;
}

CHRINFO_KEY_SET *CCharacter2::GetKeyListPtr(char *name, int *out_list) {
    CHRINFO_KEY_SET *entry;
    int              list = 0;
    int              i;

    do {
        entry = key_list[list];

        if (entry != 0) {
            for (i = 0; i < key_num[list]; i++) {
                if (entry->name[0] == 0) {
                    break;
                }

                if (strcmp(entry->name, name) == 0) {
                    if (out_list != 0) {
                        *out_list = list;
                    }

                    return entry;
                }

                entry++;
            }
        }

        list++;
    } while (list < 8);

    return 0;
}

CHRINFO_SEQ_HEADER *CCharacter2::GetSeqHeaderPtr(char *name, int *out_list) {
    CHRINFO_SEQ_HEADER *seq_step;
    int                 list = 0;

    do {
        seq_step = seq_list[list];

        if (seq_step != 0) {
            while (seq_step != 0) {
                if (strcmp(seq_step->name, name) == 0) {
                    if (out_list != 0) {
                        *out_list = list;
                    }

                    return seq_step;
                }

                seq_step = seq_step->next;
            }
        }

        list++;
    } while (list < 8);

    return 0;
}

void CCharacter2::DeleteExtMotion() {
    int                 i;
    CHRINFO_KEY_SET    *first;
    mgCTextureManager  *tex;
    int                 group;
    mgIMG_HEADER       *image;
    int                 j;
    u32                 k;
    int                 offset;
    mgIMG_FILE_HEADER **slot;
    mgIMG_FILE_HEADER  *images;

    for (i = 1; i < 8; i++) {
        motion[i].frame_info = NULL;
        shadow_motion[i].frame_info = NULL;
        key_list[i] = 0;
        key_num[i] = 0;
        seq_list[i] = 0;
        first = GetKeyListIndexPtr(0, 0);

        if (first != 0) {
            SetMotion(first->name, 4);
        }

        if (next_key != 0) {
            posed_key = next_key;
            frame = (float) next_key->start_frame;
        }
    }

    tex = &mgTexManager;
    group = tex_anime_group_start;

    if (group > 0) {
        for (; group < tex_anime_group_num; group++) {
            tex->DeleteTexAnimeGroup(texture_block, group);
        }
    } else {
        tex->DeleteTexAnime(texture_block);
    }

    for (j = 1, offset = 4; j < CHARA_IMAGE_MAX; j++, offset += 4) {
        slot = (mgIMG_FILE_HEADER **) ((u8 *) this + offset + 0x2C4);
        images = *slot;

        if (images != 0) {
            image = (mgIMG_HEADER *) (images + 1);

            for (k = 0; k < images->num3; k++) {
                if ((u8) image->name[0] != '#') {
                    tex->DeleteTexture(image->name, texture_block);
                }

                image++;
            }

            *slot = 0;
        }
    }

    for (i = 1; i < 8; i++) {
        se_list[i] = 0;
        se_num[i] = 0;
    }
}

void CCharacter2::DeleteImage() {
    mgCTextureManager *tex = &mgTexManager;
    int                group_count;
    int                group;
    mgIMG_HEADER      *image;
    u32                i;
    mgIMG_FILE_HEADER *images;

    tex->GetGroupNameList(texture_block, &group_count);
    group = tex_anime_group_start;

    if (group > 0) {
        for (; group < tex_anime_group_num; group++) {
            tex->DeleteTexAnimeGroup(texture_block, group);
        }
    }

    images = this->images[0];

    image = (mgIMG_HEADER *) (images + 1);

    if (images != NULL) {
        i = 0;

        while (i < images->num3) {

            if ((u8) image->name[0] != '#') {
                tex->DeleteTexture(image->name, texture_block);
            }

            image++;
            i += 1;
        }

        this->images[0] = NULL;
    }
}

int CCharacter2::GetEntryObjectPos(int index, float *out) {
    mgCFrame *entry;

    GetPosition(out);

    if (index < 0 || index > 2) {
        return 0;
    }

    entry = entry_frame[index];

    if (entry == 0) {
        return 0;
    }

    entry->GetWorldPosition0(out);
    return 1;
}

int CCharacter2::GetEntryObjectPos(int index, float (*out)[4]) {
    mgCFrame *entry;
    float     position[4];
    float     rotation[4];

    if (index < 0 || index > 2) {
        index = 0;
    }

    entry = entry_frame[index];

    if (entry == 0) {
        GetPosition(position);
        GetRotation(rotation);
        mgCreateMatrixPY(out, position, rotation[1]);
        return 0;
    }

    entry->GetLWMatrix(out);
    return 1;
}

CHARA_ENTRY_OBJECT *CCharacter2::GetEntryObjectPos(int id, int nth, float *out) {
    int found;
    int i;

    GetPosition(out);

    if (nth < 0 || nth > 0x18) {
        return 0;
    }

    found = -1;
    i = 0;

    for (; i < 0x18; i++) {
        if (entry_object[i].frame != 0 && entry_object[i].group == id) {
            found++;
        }

        if (found == nth) {
            entry_object[i].frame->GetWorldPosition0(out);
            return &entry_object[i];
        }
    }

    return 0;
}

float CCharacter2::GetWaitToFrame(char *name, float wait) {
    float frame = 0.0f;

    CHRINFO_KEY_SET *motion = nowChr->GetKeyListPtr(name, NULL);

    if (motion != NULL) {
        frame = (float) motion->start_frame + wait * ((float) motion->end_frame - (float) motion->start_frame);
    }

    return frame;
}

void CCharacter2::LoadSkin(u32 *pack_file, char *info_name, char *skin_name, mgCMemory *memory,
                           int texture_block) {
    ScanInfoSkinFile(this, pack_file, info_name, skin_name, memory, texture_block);
}

void CCharacter2::LoadPack(unsigned int *pack, char *name, mgCMemory *model_stack, mgCMemory *motion_stack, mgCMemory *image_stack, int image_block, CCharacter2 *parent) {
    LoadChrFile(pack, name, model_stack, motion_stack, image_stack, image_block, parent, 1);
}

void CCharacter2::LoadPackNoLine(unsigned int *pack, char *name, mgCMemory *model_stack, mgCMemory *motion_stack, mgCMemory *image_stack, int image_block, CCharacter2 *parent) {
    LoadChrFile(pack, name, model_stack, motion_stack, image_stack, image_block, parent, 0);
}

void CCharacter2::LoadChrFile(u32 *pack_file, char *name, mgCMemory *a, mgCMemory *b, mgCMemory *c,
                              int d, CCharacter2 *e, int with_line) {
    CHRINFO_KEY_SET *had_motion = GetKeyListIndexPtr(0, 0);
    ScanInfoFile(this, pack_file, name, a, b, c, d, e, with_line);

    if (had_motion == 0) {
        CHRINFO_KEY_SET *first = GetKeyListIndexPtr(0, 0);

        if (first != 0) {
            SetMotion(first->name, 4);
        }

        if (next_key != 0) {
            posed_key = next_key;
            frame = (float) next_key->start_frame;
            step = next_key->step;
        }
    }
}

void CCharacter2::Initialize() {
    int j;
    int i;

    CObjectFrame::Initialize();
    velocity[2] = 0.0f;
    velocity[1] = 0.0f;
    velocity[0] = 0.0f;
    velocity[3] = 1.0f;
    base_scale[3] = 1.0f;
    base_scale[2] = 1.0f;
    base_scale[1] = 1.0f;
    base_scale[0] = 1.0f;
    move_accel = 0.0f;
    alpha = 1.0f;
    mgUnitMatrix(entry_matrix);
    this->CObjectFrame::frame = 0;
    this->load_size = 0;
    this->copy_size = 0;
    this->shadow_poly_num = 0;
    this->poly_num = 0;
    this->dynamic_anime_flags = 0;
    this->outline = 0;
    this->shadow_frame = 0;
    frame = 0;
    main_frame_info = NULL;
    this->motion_status = 0;
    this->shape_anime = 0;
    this->sound_info.foot_sound_id = -1;
    this->sound_info.foot_sound_enable = 1;
    this->sound_info.se_positional = 1;
    this->sound_info.se_volume = 1.0f;
    this->sound_info.se_pan = 0;
    this->sound_info.foot_effect_wait = -1;
    this->sound_info.loop_se = 0;

    for (i = 0; i < 8; i++) {
        this->se_list[i] = 0;
        this->se_num[i] = 0;
    }

    this->sword_effect[0] = 0;
    this->sword_effect[1] = 0;
    this->sword_effect[2] = 0;
    this->dynamic_anime_num = 0;
    this->dynamic_anime = 0;

    for (i = 0; i < CHARA_IMAGE_MAX; i++) {
        this->images[i] = 0;
    }

    this->tex_anime_group_num = 0;
    this->tex_anime_group_start = 0;
    this->entry_frame[0] = 0;
    this->entry_frame[1] = 0;

    for (i = 0; i < 0x18; i++) {
        this->entry_object[i].frame = NULL;
        this->entry_object[i].size = 0.0f;
        this->entry_object[i].group = -1;
        this->entry_object[i].enable = 0;
    }

    for (j = 0; j < 0x18; j++) {
        this->deform_frame[j] = 0;
    }

    this->deform_frame_num = 0;

    for (i = 0; i < 8; i++) {
        this->key_list[i] = 0;
        this->key_num[i] = 0;
        this->seq_list[i] = 0;
    }

    memset(this->motion, 0, sizeof(this->motion));
    memset(this->shadow_motion, 0, sizeof(this->shadow_motion));
    this->now_set = 0;
    this->next_set = 0;
    this->next_key = 0;
    this->now_key = 0;
    this->posed_key = 0;
    this->next_seq = 0;
    this->now_seq = 0;
    seq_step = 0;
    main_frame_info = NULL;
    this->shadow_frame_info = 0;
    this->lod_num = 0;
    this->lod = 0;
    this->lod_no = -1;
    this->motion_enable = 1;
    this->shadow_link.num = 0;
    this->shadow_link.dst_frame = 0;
    this->shadow_link.src_frame = 0;
    this->InitEffect();
}

/**
 *
 * Loads a character information script and builds its model resources.
 *
 */
void ScanInfoFile(CCharacter2 *chara, u32 *pack_file, char *info_name, mgCMemory *memory,
                  mgCMemory *ext_memory, mgCMemory *img_memory, int texture_block, CCharacter2 *parent,
                  int with_line) {
    int                size;
    char              *script;
    int                free_blocks = memory->stack_size - memory->stack_used;
    CScriptInterpreter interp;

    ext_stack = ext_memory;
    outline_flag = with_line;
    ::pack_file = pack_file;
    img_stack = img_memory;
    set_imgblock = texture_block;
    parent_chr = parent;
    base_stack = memory;
    nowChr = chara;
    now_seq_ptr = 0;
    now_seqhd_ptr = 0;
    now_key_ptr = 0;
    alloc_vertex_num = 0;
    alloc_shadow_vertex_num = 0;
    now_cloth_id = 0;
    outline_start = 0;
    outline_start_tex = 0;

    for (int i = 0; i < CHARA_IMAGE_MAX; i++) {
        img_ptr[i] = 0;
    }

    script = (char *) GetPackFile(pack_file, info_name, &size);

    if (script == 0) {
        printf("not found %s\n", info_name);
        return;
    }

    interp.SetTag(tag);
    interp.SetScript(script, size);
    now_motion_id = 0;
    now_stack = memory;
    interp.Run();
    free_blocks -= memory->stack_size - memory->stack_used;
    chara->load_size = free_blocks;
}

/**
 *
 * Accepts the character script version marker.
 *
 */
int _V2(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Accepts the character name script tag.
 *
 */
int _NAME(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Sets character body dimensions from script values.
 *
 */
int _BODY_SIZE(SPI_STACK *stack, int argc) {
    SPI_STACK *next = stack + 1;

    if (nowChr == 0) {
        return 0;
    }

    nowChr->body_height = (float) spiGetStackInt(stack);
    nowChr->body_width = (float) spiGetStackInt(next++);
    nowChr->body_depth = (float) spiGetStackInt(next);
    return 1;
}

/**
 *
 * Sets the base scale of the character model and shadow.
 *
 */
int _SCALE(SPI_STACK *stack, int argc) {
    SPI_STACK *arg = stack + 1;

    if (nowChr == 0) {
        return 0;
    }

    nowChr->base_scale[0] = spiGetStackFloat(stack);
    nowChr->base_scale[1] = spiGetStackFloat(arg++);
    nowChr->base_scale[2] = spiGetStackFloat(arg);
    nowChr->base_scale[3] = 1.0f;

    if (nowChr->CObjectFrame::frame != 0) {
        nowChr->SetScale(nowChr->base_scale);
    }

    if (nowChr->shadow_frame != 0) {
        nowChr->shadow_frame->SetScale(nowChr->base_scale);
    }

    return 1;
}

/**
 *
 * Accepts the material animation script tag.
 *
 */
int _MATERIAL_ANIME(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Sets polygon counts for the character model and shadow.
 *
 */
int _POLY_NUM(SPI_STACK *stack, int argc) {
    nowChr->poly_num = 0;
    nowChr->shadow_poly_num = 0;

    if (argc > 0) {
        nowChr->poly_num += spiGetStackInt(stack++);
    }

    if (argc == 2) {
        nowChr->shadow_poly_num += spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Copies a named character image from the resource pack.
 *
 */
int _IMG(SPI_STACK *stack, int argc) {
    int        index;
    SPI_STACK *name_arg = stack + 1;
    int        size;
    char      *data;

    if (img_stack == 0) {
        return 0;
    }

    index = spiGetStackInt(stack);

    if (index < 0 || index >= CHARA_IMAGE_MAX) {
        return 0;
    }

    data = (char *) GetPackFile(pack_file, spiGetStackString(name_arg), &size);

    if (data == 0) {
        return 0;
    }

    img_ptr[index] = (mgIMG_FILE_HEADER *) img_stack->stAlloc64(size / 16 + 1);
    memcpy(img_ptr[index], data, size);
    return 1;
}

/**
 *
 * Registers loaded character images in the texture manager.
 *
 */
int _IMG_END(SPI_STACK *stack, int argc) {
    int                i;
    mgCTextureManager *tex;
    char             **name_list;

    tex = &mgTexManager;
    nowChr->texture_block = set_imgblock;

    for (i = 0; i < CHARA_IMAGE_MAX; i++) {
        if (img_ptr[i] != 0) {
            nowChr->images[i] = img_ptr[i];
            outline_tex_id = tex->EnterIMGFile((u8 *) img_ptr[i], set_imgblock, img_stack, 0);

            if (i == 0) {
                name_list = tex->GetGroupNameList(set_imgblock, &nowChr->tex_anime_group_num);

                if (name_list != 0) {
                    nowChr->tex_anime_group_start = 0;

                    while (name_list[nowChr->tex_anime_group_start] != 0) {
                        nowChr->tex_anime_group_start += 1;
                    }
                }
            }
        }
    }

    return 1;
}

/**
 *
 * Loads and registers an outline effect for the character.
 *
 */
int _OUTLINE(SPI_STACK *stack, int argc) {
    char               name[0x40];
    char               texture_name[0x20];
    SPI_STACK         *arg = stack + 1;
    float              width;
    mgCTextureManager *tex_manager;
    COutLineDraw      *outline;
    mgCTexture        *texture;

    if (outline_flag == 0) {
        return 1;
    }

    strcpy(name, spiGetStackString(stack));
    width = spiGetStackFloat(arg);
    tex_manager = &mgTexManager;

    if (tex_manager == 0 || set_imgblock == -1) {
        return 0;
    }

    if ((outline = (COutLineDraw *) operator new(sizeof(COutLineDraw), base_stack->Alloc(9))) != 0) {
        outline->next = 0;
        outline->Initialize();
    }

    outline->Initialize();
    outline->width = width;

    if (outline_start == 0) {
        if (parent_chr != 0) {
            if (parent_chr->outline == 0) {
                return 0;
            }

            if ((outline_start_tex = parent_chr->outline->texture) == 0) {
                return 0;
            }
        } else {
            /**
             * Identifier assigned to each newly allocated outline texture.
             */
            static int outline_num = 1;
            outline_num += 1;
            sprintf(texture_name, "out_line2%d", outline_num);
            nowChr->outline_tex_no = outline_num;
            texture = tex_manager->EnterTexture(
                set_imgblock, texture_name, 0, mgScreenWidth, mgScreenHeight,
                mgScreenDepth, 0, 0, 0);
            outline_start_tex = texture;
            outline_start = 1;

            if (texture == 0) {
                return 0;
            }
        }
    }

    outline->texture = outline_start_tex;
    nowChr->AddOutLine(name, outline);
    return 1;
}

/**
 *
 * Loads the character model with visual classes for its animated vertices.
 *
 */
static int _MODEL(SPI_STACK *stack, int count) {
    char               weight_name[64];
    char              *model_name;
    MDS_HEADER        *model;
    u_int             *weight;
    mgCreateVisualType visual_type[26];
    mgLoadData         load;
    u_long128          work_buffer[6400];
    mgCFrame          *deform_frame;
    int                index;
    char               byte;

    model_name = spiGetStackString(stack);
    model = (MDS_HEADER *) GetPackFile(pack_file, model_name, NULL);

    if (model == NULL) {
        printf("not found %s\n", model_name);
        return 0;
    }

    for (index = 0; (byte = model_name[index]) != '\0' && byte != '.'; index++) {
        weight_name[index] = byte;
    }

    weight_name[index] = '\0';
    strcat(weight_name, ".wgt");
    weight = GetPackFile(pack_file, weight_name, NULL);

    if (alloc_vertex_num > 0) {
        char               *empty_name = "";
        mgCreateVisualType *visual = visual_type;
        int                 vertex_index = 0;

        for (; vertex_index < alloc_vertex_num; vertex_index++) {
            if (nowChr->shape_anime == 0) {
                visual->type = MG_VISUAL_CREATE_MOTION_MDT;
            } else {
                visual->type = MG_VISUAL_CREATE_MDT;
            }

            visual->name = alloc_vertex[vertex_index];
            visual++;
        }

        visual->type = MG_VISUAL_CREATE_END;
        visual->name = empty_name;
        memset(&load, 0, sizeof(load));
        mgCMemory work_memory;
        work_memory.stSetBuffer(work_buffer, 6400);
        load.mds = model;
        load.work_memory = &work_memory;
        load.weight = weight;
        load.visual_type = visual_type;
        load.memory = base_stack;
        nowChr->CObjectFrame::frame = mgLoadMDSFile(&load);
    } else {
        nowChr->CObjectFrame::frame = mgLoadMDSFile(model, base_stack, NULL, NULL);
    }

    nowChr->deform_frame_num = 0;
    int frame_index = 0;

    for (; frame_index < alloc_vertex_num; frame_index++) {
        if (nowChr->CObjectFrame::frame != NULL) {
            deform_frame = nowChr->CObjectFrame::frame->SearchFrame(alloc_vertex[frame_index]);

            if (deform_frame != NULL) {
                nowChr->deform_frame[nowChr->deform_frame_num] = deform_frame;
                nowChr->deform_frame_num++;
            }
        }
    }

    return 1;
}

/**
 *
 * Loads the shadow model and links its frames to the character model.
 *
 */
int _SHADOW_MODEL(SPI_STACK *stack, int argc) {
    mgCreateVisualType visual_type[2] = {
        {MG_VISUAL_CREATE_SHADOW_MDT, ""  },
        {MG_VISUAL_CREATE_END,        NULL}
    };
    char                *name;
    CCharaFrameMatching *shadow_link;
    int                  pairs;
    u32                  bytes;
    int                  i;
    mgCFrame            *frame;
    int                  count;
    mgCFrame            *model;
    mgCFrame           **frame_names;
    mgCFrame           **model_names;
    char                *pack;

    name = spiGetStackString(stack);
    pack = (char *) GetPackFile(pack_file, name, 0);

    if (pack == 0) {
        printf("not found %s\n", name);
        return 0;
    }

    nowChr->shadow_frame =
        mgLoadMDSFile(
            (MDS_HEADER *) pack, base_stack, visual_type, 0);
    frame = nowChr->CObjectFrame::frame;
    shadow_link = &nowChr->shadow_link;
    model = nowChr->shadow_frame;

    while (model != 0 && frame != 0) {
        count = model->frame_num;
        frame_names = frame->frame_list;
        model_names = model->frame_list;

        if (count != 0) {
            bytes = count * 4;
            shadow_link->src_frame = (s32 *) operator new[](
                bytes, base_stack->Alloc(DynAnimeAlign16Blocks(bytes) + 2));
            shadow_link->dst_frame = (s32 *) operator new[](
                bytes, base_stack->Alloc(DynAnimeAlign16Blocks(bytes) + 2));

            if (shadow_link->src_frame != NULL) {
                if (shadow_link->dst_frame != NULL) {
                    pairs = 0;

                    for (i = 0; i < count; i++) {
                        mgCFrame *sub = model_names[i];

                        if (sub != 0 && frame_names[i] != 0) {
                            char *sub_name = sub->name;

                            if (sub_name != 0) {
                                int id = frame->SearchFrameID(sub_name);

                                if (id >= 0) {
                                    shadow_link->src_frame[pairs] = id;
                                    shadow_link->dst_frame[pairs] = i;
                                    pairs++;
                                }
                            }
                        }
                    }

                    shadow_link->num = pairs;
                }
            }
        }

        break;
    }

    return 1;
}

/**
 *
 * Registers named model frames as character entry objects.
 *
 */
int _OBJECT_NAME(SPI_STACK *stack, int argc) {
    char      name[0x40];
    int       frame_slot = -1;
    int       object_slot;
    int       n;
    int       i;
    int       j;
    mgCFrame *root;
    mgCFrame *found;

    for (i = 0; i < CHARA_ENTRY_FRAME_MAX; i++) {
        if (nowChr->entry_frame[i] == 0) {
            frame_slot = i;
            break;
        }
    }

    object_slot = -1;

    if (frame_slot == -1) {
        return 0;
    }

    for (j = 0; j < CHARA_ENTRY_OBJECT_MAX; j++) {
        if (nowChr->entry_object[j].frame == 0) {
            object_slot = j;
            break;
        }
    }

    if (object_slot == -1) {
        return 0;
    }

    root = nowChr->CObjectFrame::frame;

    if (root == 0) {
        return 0;
    }

    for (n = 0; n < argc; n++) {
        if (frame_slot >= 2) {
            return 0;
        }

        strcpy(name, spiGetStackString(stack++));
        found = root->SearchFrame(name);

        if (found != 0) {
            nowChr->entry_frame[frame_slot++] = found;
            nowChr->entry_object[object_slot].frame = found;
            nowChr->entry_object[object_slot].size = 0.0f;
            nowChr->entry_object[object_slot].group = object_slot;
            nowChr->entry_object[object_slot++].enable = 1;
        }
    }

    return 1;
}

/**
 *
 * Registers grouped entry objects with frame values.
 *
 */
int _OBJECT_NAME2(SPI_STACK *stack, int argc) {
    char      name[0x40];
    int       object_slot = -1;
    int       id;
    mgCFrame *root;
    int       pair_count;
    int       n;
    mgCFrame *found;
    float     value;
    int       i;

    for (i = 0; i < CHARA_ENTRY_OBJECT_MAX; i++) {
        if (nowChr->entry_object[i].frame == 0) {
            object_slot = i;
            break;
        }
    }

    if (object_slot == -1) {
        return 0;
    }

    id = spiGetStackInt(stack++);
    root = nowChr->CObjectFrame::frame;

    if (root == 0) {
        return 0;
    }

    pair_count = (argc - 1) / 2;

    if (argc < 3) {
        pair_count = 1;
    }

    for (n = 0; n < pair_count; n++) {
        if (object_slot >= 0x18) {
            return 0;
        }

        strcpy(name, spiGetStackString(stack++));
        found = root->SearchFrame(name);
        value = 0.0f;

        if (id >= 2) {
            value = spiGetStackFloat(stack++);
        } else if (argc >= 3) {
            value = spiGetStackFloat(stack++);
        }

        if (found != 0) {
            if (id < 2) {
                nowChr->entry_frame[id] = found;
            }

            nowChr->entry_object[object_slot].frame = found;
            nowChr->entry_object[object_slot].size = value;
            nowChr->entry_object[object_slot].group = id;
            nowChr->entry_object[object_slot++].enable = 1;
        }
    }

    return 1;
}

/**
 *
 * Loads motion resources for a character motion slot.
 *
 */
int _MOTION(SPI_STACK *stack, int argc) {
    tagMOTION_TYPE  *motion;
    char            *first_name;
    mgCFrame        *root;
    SPI_STACK       *arg;
    char            *second_name;
    char            *third_name;
    MOTION_FILE_INFO entry[3];
    tagMOTION_TYPE  *source;
    tagMOTION_TYPE  *dest;

    root = nowChr->CObjectFrame::frame;
    arg = stack + 1;

    if (root == 0) {
        return 0;
    }

    now_motion_id = spiGetStackInt(stack);

    if (now_motion_id < 0 || now_motion_id >= CHARA_MOTION_SET_MAX) {
        return 0;
    }

    motion = &nowChr->motion[now_motion_id];
    memset(motion, 0, sizeof(*motion));
    first_name = spiGetStackString(arg++);
    second_name = spiGetStackString(arg++);
    third_name = spiGetStackString(arg);
    entry[1].name = first_name;
    entry[0].name = second_name;
    entry[2].name = third_name;
    entry[0].size = 0;
    entry[1].size = 0;
    entry[2].size = 0;
    entry[0].data = (char *) GetPackFile(pack_file, second_name, &entry[0].size);
    entry[1].data = (char *) GetPackFile(pack_file, first_name, &entry[1].size);
    entry[2].data = 0;

    if (entry[0].size == 0) {
        entry[0].name = 0;
    }

    if (entry[1].size == 0) {
        entry[1].name = 0;
    }

    if (entry[2].size == 0) {
        entry[2].name = 0;
    }

    if (entry[0].data != 0) {
        int count = root->frame_num;

        if (root->init_matrix != 0) {
            memcpy(root->init_matrix, entry[0].data, count << 6);
        }
    }

    CreateAnimeDataEX(motion, ext_stack, entry);

    if (now_motion_id > 0) {
        source = &nowChr->shadow_motion[0];
        dest = &nowChr->shadow_motion[now_motion_id];
        dest->base_matrices = source->base_matrices;
        dest->motion_list = source->motion_list;
        dest->skin_list = source->skin_list;
        dest->unk_0C = source->unk_0C;
    }

    return 1;
}

/**
 *
 * Loads shadow motion resources for the current motion slot.
 *
 */
int _SHADOW_MOTION(SPI_STACK *stack, int argc) {
    tagMOTION_TYPE  *motion;
    char            *first_name;
    char            *second_name;
    char            *third_name;
    MOTION_FILE_INFO entry[3];

    if (nowChr->shadow_frame == 0) {
        return 0;
    }

    if (now_motion_id < 0 || now_motion_id >= CHARA_MOTION_SET_MAX) {
        return 0;
    }

    motion = &nowChr->shadow_motion[now_motion_id];
    memset(motion, 0, sizeof(*motion));
    first_name = spiGetStackString(stack++);
    second_name = spiGetStackString(stack++);
    third_name = spiGetStackString(stack);
    entry[0].size = 0;
    entry[1].size = 0;
    entry[2].size = 0;
    entry[1].name = first_name;
    entry[0].name = second_name;
    entry[2].name = third_name;
    entry[0].data = (char *) GetPackFile(pack_file, second_name, &entry[0].size);
    entry[1].data = (char *) GetPackFile(pack_file, first_name, &entry[1].size);
    entry[2].data = (char *) GetPackFile(pack_file, third_name, &entry[2].size);

    if (second_name[0] == 0) {
        entry[0].name = 0;
    }

    if (third_name[0] == 0) {
        entry[2].name = 0;
    }

    if (entry[0].data == 0 && entry[1].data == 0 && entry[2].data == 0) {
        return 0;
    }

    entry[1].name = 0;
    entry[1].data = 0;
    CreateAnimeDataEX(motion, ext_stack, entry);

    if (nowChr->shadow_frame_info == 0) {
        AnimeDataInit(
            nowChr->shadow_frame, motion, base_stack, &nowChr->shadow_frame_info);
    }

    motion->frame_info = nowChr->shadow_frame_info;
    return 1;
}

/**
 *
 * Lists model frames whose vertices are animated.
 *
 */
int _VERTEX_ANIME(SPI_STACK *stack, int argc) {
    int i;

    for (i = 0; i < argc; i++) {
        if (alloc_vertex_num >= 24) {
            return 0;
        }

        strcpy(alloc_vertex[alloc_vertex_num++], spiGetStackString(stack++));
    }

    return 1;
}

/**
 *
 * Sets the character shape animation mode.
 *
 */
int _SHAPE_ANIME(SPI_STACK *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    nowChr->shape_anime = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Begins the key frame list for the current motion.
 *
 */
int _KEY_START(SPI_STACK *stack, int argc) {
    now_key_ptr = (CHRINFO_KEY_SET *) (now_stack->stack + now_stack->stack_used);
    nowChr->key_list[now_motion_id] = now_key_ptr;
    nowChr->key_num[now_motion_id] = 0;
    return 1;
}

/**
 *
 * Adds a named key frame interval to the current motion.
 *
 */
int _KEY(SPI_STACK *stack, int argc) {
    SPI_STACK *arg;

    if (argc < 4) {
        return 0;
    }

    arg = stack + 1;

    if (now_key_ptr == 0) {
        return 0;
    }

    strcpy(now_key_ptr->name, spiGetStackString(stack));
    now_key_ptr->start_frame = spiGetStackInt(arg++);
    now_key_ptr->end_frame = spiGetStackInt(arg++);
    now_key_ptr->step = spiGetStackFloat(arg);
    now_key_ptr++;
    nowChr->key_num[now_motion_id]++;
    return 1;
}

/**
 *
 * Ends and allocates the current motion key frame list.
 *
 */
int _KEY_END(SPI_STACK *stack, int argc) {
    if (now_key_ptr == 0) {
        return 0;
    }

    now_key_ptr->name[0] = 0;
    now_key_ptr->start_frame = -1;
    now_key_ptr->end_frame = -1;
    now_key_ptr->step = 0.0f;
    now_key_ptr++;
    nowChr->key_num[now_motion_id] += 1;
    now_stack->stAlloc64((nowChr->key_num[now_motion_id] * sizeof(CHRINFO_KEY_SET) >> 4) + 1);
    return 1;
}

/**
 *
 * Allocates a named motion sequence and links it to the current motion.
 *
 */
static int _SEQ_START(SPI_STACK *stack, int count) {
    if (count <= 0) {
        return 0;
    }

    if (now_stack == NULL) {
        return 0;
    }

    CHRINFO_SEQ_HEADER *previous = now_seqhd_ptr;
    now_seqhd_ptr = (CHRINFO_SEQ_HEADER *) now_stack->stAlloc64(4);
    now_seq_ptr = (CHRINFO_SEQ *) now_stack->stGetTop();

    if (previous == NULL) {
        nowChr->seq_list[now_motion_id] = now_seqhd_ptr;
    } else {
        previous->next = now_seqhd_ptr;
    }

    strcpy(now_seqhd_ptr->name, spiGetStackString(stack));
    now_seqhd_ptr->next = NULL;
    now_seqhd_ptr->seq = now_seq_ptr;
    now_seqhd_ptr->seq_num = 0;
    return 1;
}

/**
 *
 * Adds a named motion to the current sequence.
 *
 */
int _SEQ(SPI_STACK *stack, int argc) {
    if (now_seq_ptr == 0 || now_seqhd_ptr == 0) {
        return 0;
    }

    now_seq_ptr->type = 0;
    now_seq_ptr->loop_count = -1;
    now_seq_ptr->blend_speed = -1.0f;
    strcpy(now_seq_ptr->name, spiGetStackString(stack++));

    if (argc >= 2) {
        now_seq_ptr->blend_speed = spiGetStackFloat(stack++);
    }

    if (argc >= 3) {
        now_seq_ptr->type = spiGetStackInt(stack++);
    }

    if (argc == 4) {
        now_seq_ptr->loop_count = spiGetStackInt(stack);
    }

    now_seq_ptr++;
    now_seqhd_ptr->seq_num++;
    return 1;
}

/**
 *
 * Ends and allocates the current motion sequence.
 *
 */
int _SEQ_END(SPI_STACK *stack, int argc) {
    if (now_stack == 0) {
        return 0;
    }

    now_seq_ptr->name[0] = 0;
    now_seq_ptr->blend_speed = -1.0f;
    now_seq_ptr->type = 0;
    now_seq_ptr->loop_count = -1;
    now_seq_ptr++;
    now_seqhd_ptr->seq_num++;
    now_stack->stAlloc64((now_seqhd_ptr->seq_num * sizeof(CHRINFO_SEQ) >> 4) + 1);
    return 1;
}

/**
 *
 * Allocates dynamic animation objects for character cloth.
 *
 */
int _CLOTH_START(SPI_STACK *stack, int argc) {
    int count = spiGetStackInt(stack);

    if (count <= 0) {
        return 0;
    }

    u_long128 *block = now_stack->Alloc(DynAnimeAlign16Blocks((u32) count * 0x90) + 2);
    nowChr->dynamic_anime = new (block) CDynamicAnime[count];

    if (nowChr->dynamic_anime == 0) {
        return 0;
    }

    nowChr->dynamic_anime_num = count;
    return 1;
}

CDynamicAnime::CDynamicAnime() {
    Initialize();
}

/**
 *
 * Loads character cloth animations and updates linked shadow frames.
 *
 */
int _CLOTH(SPI_STACK *stack, int argc) {
    int                  i;
    char                *name;
    char                *data;
    int                  size;
    CCharacter2         *chara;
    int                  index;
    mgCFrame            *model_frame;
    mgCFrame            *shadow_frame;
    CCharaFrameMatching *shadow_link;
    int                  j;
    mgCFrame            *source;
    mgCFrame            *frame;
    mgCFrame            *target;

    for (i = 0; i < argc; i++) {
        if (now_cloth_id >= nowChr->dynamic_anime_num) {
            return 0;
        }

        name = spiGetStackString(stack++);

        if (name != 0) {
            data = (char *) GetPackFile(pack_file, name, &size);

            if (data != 0) {
                chara = nowChr;
                model_frame = chara->CObjectFrame::frame;
                index = now_cloth_id++;
                chara->dynamic_anime[index].Load(data, size, model_frame, now_stack);
            }
        }
    }

    j = 0;
    frame = nowChr->CObjectFrame::frame;
    shadow_frame = nowChr->shadow_frame;
    shadow_link = &nowChr->shadow_link;

    while (j < shadow_link->num) {
        source = frame->GetFrame(shadow_link->src_frame[j]);

        if (source != NULL) {
            target = shadow_frame->GetFrame(shadow_link->dst_frame[j]);

            if (target != 0 && source->parent == NULL && target->parent != NULL) {
                target->DeleteParent();
            }
        }

        j++;
    }

    return 1;
}

/**
 *
 * Accepts the end of the cloth animation list.
 *
 */
int _CLOTH_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Sets the initial character position from script values.
 *
 */
int _POSITION(SPI_STACK *stack, int argc) {
    float x = spiGetStackFloat(stack++);
    float y = spiGetStackFloat(stack++);
    float z = spiGetStackFloat(stack);
    nowChr->SetPosition(x, y, z);
    return 1;
}

/**
 *
 * Sets the initial character rotation from script values.
 *
 */
int _ROTATION(SPI_STACK *stack, int argc) {
    float x = spiGetStackFloat(stack++);
    float y = spiGetStackFloat(stack++);
    float z = spiGetStackFloat(stack);
    nowChr->SetRotation(x, y, z);
    return 1;
}

/**
 *
 * Allocates sound cue entries for the current motion.
 *
 */
int _SE_START(SPI_STACK *stack, int argc) {
    now_se_header = 0;
    nowChr->se_num[now_motion_id] = 0;

    if (argc != 1) {
        return 0;
    }

    nowChr->se_num[now_motion_id] = spiGetStackInt(stack);
    nowChr->se_list[now_motion_id] = new (now_stack->Alloc(DynAnimeAlign16Blocks(nowChr->se_num[now_motion_id] * 16) + 2))
        CHRINFO_SE[nowChr->se_num[now_motion_id]];
    now_se_header = nowChr->se_list[now_motion_id];
    return 1;
}

/**
 *
 * Adds a sound cue at a frame of a named motion.
 *
 */
int _SE(SPI_STACK *stack, int argc) {
    char      *name;
    SPI_STACK *arg;
    int        se_no;
    int        bank;
    float      frame;

    if (now_se_header == 0) {
        return 0;
    }

    arg = stack + 1;

    if (argc != 4) {
        return 0;
    }

    name = spiGetStackString(stack);
    se_no = spiGetStackInt(arg++);
    bank = spiGetStackInt(arg++);
    frame = spiGetStackFloat(arg);

    if (frame <= 1.0f) {
        frame = nowChr->GetWaitToFrame(name, frame);
    }

    if (frame <= 0.0f) {
        return 0;
    }

    now_se_header->frame = frame;
    now_se_header->end_frame = 0.0f;
    now_se_header->kind = se_no;
    now_se_header->se_no = bank;
    now_se_header->loop_slot = 0;
    now_se_header->wait = 0;
    now_se_header++;
    return 1;
}

/**
 *
 * Adds a timed loop sound cue to a named motion.
 *
 */
int _SELP(SPI_STACK *stack, int argc) {
    char      *name;
    SPI_STACK *arg;
    int        se_no;
    int        bank;
    float      start;
    float      end;
    int        loop_flag;
    float      start_time;
    float      end_time;

    if (now_se_header == 0) {
        return 0;
    }

    arg = stack + 1;

    if (argc != 6) {
        return 0;
    }

    name = spiGetStackString(stack);
    se_no = spiGetStackInt(arg++);
    bank = spiGetStackInt(arg++);
    start = spiGetStackFloat(arg++);
    end = spiGetStackFloat(arg++);
    loop_flag = spiGetStackInt(arg);

    if (start <= 1.0f) {
        start_time = nowChr->GetWaitToFrame(name, start);
    } else {
        start_time = start;
    }

    if (end <= 1.0f) {
        end_time = nowChr->GetWaitToFrame(name, end);
    } else {
        end_time = end;
    }

    if (start_time <= 0.0f || end_time <= 0.0f) {
        return 0;
    }

    now_se_header->frame = start_time;
    now_se_header->end_frame = end_time;
    now_se_header->kind = se_no;
    now_se_header->se_no = bank;
    now_se_header->loop_slot = loop_flag;
    now_se_header->wait = 0;
    now_se_header++;
    return 1;
}

/**
 *
 * Accepts the end of the motion sound cue list.
 *
 */
int _SE_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Accepts the end of a character motion definition.
 *
 */
int _MOTION_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Loads the effect pack named by the character script.
 *
 */
int _EFFECT_START(SPI_STACK *stack, int argc) {
    eff_pack_ptr = GetPackFile(pack_file, spiGetStackString(stack), &eff_pack_size);
    return eff_pack_ptr != 0;
}

/**
 *
 * Loads and registers a character effect from the effect pack.
 *
 */
static int _EFFECT(SPI_STACK *stack, int count) {
    char                  *script;
    CHRINFO_EFFECT        *entry;
    CHARA_EFFECT_MANAGER  *manager;
    CHRINFO_EFFECT        *last;
    unsigned char         *image;
    CHRINFO_EFFECT_IMAGE **image_entry;
    char                  *file_name;
    char                  *effect_name;
    char                  *frame_name;
    char                  *motion_name;
    sceVu0FVECTOR          offset;
    float                  start_ratio;
    int                    local_draw;
    int                    script_size;
    int                    particle_count;
    int                    emitter_count;
    int                    image_size;
    int                    enter_image;
    int                    index;

    if (eff_pack_ptr == NULL) {
        return 0;
    }

    file_name = spiGetStackString(stack++);
    effect_name = spiGetStackString(stack++);
    local_draw = spiGetStackInt(stack++);
    frame_name = spiGetStackString(stack++);
    offset[0] = spiGetStackFloat(stack++);
    offset[1] = spiGetStackFloat(stack++);
    offset[2] = spiGetStackFloat(stack++);
    offset[3] = 1.0f;
    motion_name = NULL;
    start_ratio = 0.0f;

    if (count >= 8) {
        motion_name = spiGetStackString(stack++);
        start_ratio = spiGetStackFloat(stack++);
    }

    script = (char *) GetPackFile(eff_pack_ptr, file_name, &script_size);

    if (script == NULL) {
        return 0;
    }

    entry = (CHRINFO_EFFECT *) now_stack->stAlloc64(3);
    manager = (CHARA_EFFECT_MANAGER *) now_stack->stAlloc64(32);
    manager->Initialize();
    manager->GetBufferNums(script, script_size, &particle_count, &emitter_count);
    manager->particle_pool = (CEffect *) now_stack->Alloc(particle_count * sizeof(CEffect) / 16 + 1);

    for (index = 0; index < particle_count; index++) {
        manager->particle_pool[index].Initialize();
    }

    manager->emitter_pool = (CEffectCtrl *) now_stack->Alloc(emitter_count * sizeof(CEffectCtrl) / 16 + 1);

    for (index = 0; index < emitter_count; index++) {
        manager->emitter_pool[index].Initialize();
    }

    manager->EntryEffCtrls(manager->particle_pool, particle_count, manager->emitter_pool, emitter_count);
    manager->Load(script, script_size);

    if (nowChr->effect_image_load != 0) {
        image = (unsigned char *) GetPackFile(eff_pack_ptr, manager->img_name, &image_size);

        if (image != NULL) {
            mgCTextureManager *textures = &mgTexManager;
            image_entry = &nowChr->effect_image_list;
            enter_image = 1;

            if (*image_entry != NULL) {
                while (*image_entry != NULL) {
                    if (strcmp((*image_entry)->name, manager->img_name) == 0) {
                        enter_image = 0;
                        break;
                    }

                    image_entry = &(*image_entry)->next;
                }
            }

            if (enter_image != 0) {
                *image_entry = (CHRINFO_EFFECT_IMAGE *) now_stack->stAlloc64(40);
                (*image_entry)->next = NULL;
                strcpy((*image_entry)->name, manager->img_name);
                (*image_entry)->data = (unsigned char *) img_stack->Alloc(image_size / 16 + 1);
                memcpy((*image_entry)->data, image, image_size);
                textures->EnterIMGFile(image, set_imgblock, img_stack, NULL);
            }
        }
    }

    manager->local_draw = local_draw;
    sceVu0CopyVector(manager->offset, offset);
    manager->start_ratio = start_ratio;

    if (frame_name != NULL) {
        strcpy(manager->frame_name, frame_name);
    } else {
        strcpy(manager->frame_name, "");
    }

    if (motion_name != NULL) {
        strcpy(manager->motion_name, motion_name);
    } else {
        strcpy(manager->motion_name, "");
    }

    entry->effect = manager;
    strcpy(entry->name, effect_name);
    entry->next = NULL;
    last = nowChr->effect_list;

    if (last != NULL) {
        while (last->next != NULL) {
            last = last->next;
        }

        last->next = entry;
    } else {
        nowChr->effect_list = entry;
    }

    return 1;
}

/**
 *
 * Ends registration of character effects.
 *
 */
int _EFFECT_END(SPI_STACK *stack, int argc) {
    if (eff_pack_ptr == 0) {
        return 0;
    }

    eff_pack_ptr = 0;
    eff_pack_size = 0;
    return 1;
}

void CCharacter2::InitEffect() {
    int index;

    for (index = 0; index < CHARA_ENTRY_EFFECT_MAX; index++) {
        entry_effect[index].effect = NULL;
        entry_effect[index].active = 0;
        entry_effect[index].running = 0;
    }

    effect_list = NULL;
    effect_enable = 1;
    effect_image_list = NULL;
    effect_image_load = 1;
}

void CCharacter2::ExecEntryEffect(CHRINFO_KEY_SET *key_set) {
    int             i;
    int             count;
    CHRINFO_EFFECT *node;

    for (i = 0; i < 8; i++) {
        if (entry_effect[i].active != 0 && entry_effect[i].running != 0) {
            entry_effect[i].effect->Stop();
        }

        entry_effect[i].effect = 0;
        entry_effect[i].active = 0;
        entry_effect[i].running = 0;
    }

    if (effect_enable == 0) {
        return;
    }

    node = effect_list;

    if (key_set == 0) {
        return;
    }

    count = 0;

    while (node != 0) {

        if (strcmp(node->effect->motion_name, now_key->name) == 0) {
            entry_effect[count].effect = node->effect;
            entry_effect[count].active = 1;
            count++;
        }

        node = node->next;
    }
}

void CCharacter2::CtrlEffect() {
    for (int i = 0; i < 8; i++) {
        if (entry_effect[i].active == 0) {
            continue;
        }

        if (entry_effect[i].running != 0) {
            continue;
        }

        CHARA_EFFECT_MANAGER *manager = entry_effect[i].effect;
        CHRINFO_KEY_SET      *motion = now_key;
        float                 progress = (frame - (float) motion->start_frame) /
                         ((float) motion->end_frame - (float) motion->start_frame);

        if (progress > manager->start_ratio) {
            manager->Run();
            entry_effect[i].running = 1;
        }
    }
}

void CCharacter2::StepEffect() {
    CHRINFO_EFFECT *effect;
    int             index;

    for (index = 0; index < CHARA_SWORD_EFFECT_MAX; index++) {
        if (sword_effect[index] != NULL) {
            sword_effect[index]->Step();
            sword_effect[index]->CreatPointList();
        }
    }

    for (effect = effect_list; effect != NULL; effect = effect->next) {
        effect->effect->Ctrl();
        effect->effect->Step(1);
    }
}

void CCharacter2::DrawEffect() {
    CHRINFO_EFFECT *effect;
    mgCFrame       *effect_frame;
    int             index;

    for (index = 0; index < CHARA_SWORD_EFFECT_MAX; index++) {
        if (sword_effect[index] != NULL) {
            sword_effect[index]->Draw();
        }
    }

    for (effect = effect_list; effect != NULL; effect = effect->next) {
        mgC3DSprite   sprite;
        sceVu0FMATRIX world_matrix;
        sceVu0FVECTOR world_position;
        mgUnitMatrix(world_matrix);
        world_position[3] = 0.0f;
        world_position[2] = 0.0f;
        world_position[1] = 0.0f;
        world_position[0] = 0.0f;

        if (strcmp(effect->effect->frame_name, "") != 0) {
            effect_frame = CObjectFrame::frame->SearchFrame(effect->effect->frame_name);

            if (effect_frame != NULL) {
                effect_frame->GetWorldPosition0(world_position);
                sceVu0TransMatrix(world_matrix, world_matrix, effect->effect->offset);
                sceVu0RotMatrix(world_matrix, world_matrix, rotation);
                sceVu0TransMatrix(world_matrix, world_matrix, world_position);
            }
        }

        if (effect->effect->local_draw != 0) {
            effect->effect->CreatePacket(&sprite);
            mgDrawDirect(&sprite, world_matrix);
        } else {
            effect->effect->SetOrigin(world_matrix[3]);
            effect->effect->Draw();
        }
    }
}

/**
 *
 * Loads and interprets a character skin information script.
 *
 */
void ScanInfoSkinFile(CCharacter2 *chara, u32 *pack_file, char *info_name, char *skin_name,
                      mgCMemory *memory, int texture_block) {
    CScriptInterpreter interp;
    int                size;
    char              *script;

    base_stack = memory;
    ::pack_file = pack_file;
    set_imgblock = texture_block;
    nowChr = chara;
    skin_name_ptr = skin_name;
    root_skin_frame = 0;
    skin_frame = 0;
    script = (char *) GetPackFile(pack_file, info_name, &size);

    if (script == NULL) {
        printf("not found %s\n", info_name);
        return;
    }

    interp.SetTag(skin_tag);
    interp.SetScript(script, size);
    interp.Run();
}

/**
 *
 * Loads an image resource for a character skin.
 *
 */
int _SKIN_IMG(SPI_STACK *stack, int argc) {
    SPI_STACK *name = stack + 1;

    if (base_stack == 0) {
        return 0;
    }

    spiGetStackInt(stack);
    load_img_ptr = (unsigned char *) GetPackFile(pack_file, spiGetStackString(name), &load_img_size);
    return load_img_ptr != 0;
}

/**
 *
 * Accepts the end of character skin image declarations.
 *
 */
int _SKIN_IMG_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Selects the model resource used for character skinning.
 *
 */
int _SKIN_MODEL(SPI_STACK *stack, int argc) {
    char *name;

    if (argc != 1) {
        return 0;
    }

    name = spiGetStackString(stack);

    if (GetPackFile(pack_file, name, NULL) == 0) {
        printf("not found %s\n", name);
        return 0;
    }

    strcpy(skin_mds_name, name);
    return 1;
}

/**
 *
 * Loads a frame model and rebinds its weighted visuals to a target model.
 *
 */
mgCFrame *CreateChangeFrame(mgLoadData *data, mgCFrame *target) {
    mgCFrame  *source = mgLoadMDSFile(data);
    char     **name;
    int        target_id;
    mgCVisual *motion;
    mgCFrame **frame_list;
    float(*matrix)[4][4];
    int                 i;
    mgCreateVisualType *list;
    mgCFrame           *found;
    mgCreateVisualType *entry;
    int                 source_id;

    if (source == 0) {
        return 0;
    }

    list = data->visual_type;
    i = 0;

    for (;;) {
        entry = &list[i];

        if (entry->type == MG_VISUAL_CREATE_END) {
            break;
        }

        name = &entry->name;

        if (target->SearchFrame(*name) != 0) {
            found = source->SearchFrame(*name);

            if (found != 0) {
                motion = found->visual;

                if (motion != 0 && motion->Iam() == 3) {
                    target_id = target->SearchFrameID(*name);
                    source_id = source->SearchFrameID(*name);
                    frame_list = target->frame_list;
                    matrix = target->init_matrix;

                    if (data->matrix != 0) {
                        memcpy(matrix[target_id], data->matrix[source_id], sizeof(matrix[target_id]));
                    }

                    ((mgCVisualMotionMDT *) motion)->ChangeWeight(frame_list, matrix, target_id);
                }
            }
        }

        i++;
    }

    return source;
}

static int _SKIN_MOTION(SPI_STACK *stack, int count) {
    int                deform_index;
    unsigned char     *matrix_file;
    int                frame_index;
    mgCVisualMDT      *visual;
    mgCFrame          *source_frame;
    char             **group_names;
    mgCFrame          *dest_frame;
    int                visual_count;
    mgCFrame          *root;
    unsigned char     *weight_file;
    mgCFrame         **frame_list;
    mgCTextureManager *tex_manager;
    int                image_count;
    unsigned char     *model_file;
    int                index;
    int                frame_num;
    CCharacter2       *chara;
    char              *matrix_name;
    char              *weight_name;
    int                image_index;
    unsigned char     *image;
    int                skin_id;

    if (nowChr->CObjectFrame::frame == NULL) {
        return 0;
    }

    now_motion_id = spiGetStackInt(stack++);
    spiGetStackString(stack++);
    matrix_name = spiGetStackString(stack++);
    weight_name = spiGetStackString(stack++);
    weight_file = (unsigned char *) GetPackFile(pack_file, weight_name, NULL);
    matrix_file = (unsigned char *) GetPackFile(pack_file, matrix_name, NULL);

    if (weight_file == NULL) {
        printf("not found %s\n", weight_name);
        return 0;
    }

    if (nowChr->shape_anime == 0) {
        model_file = (unsigned char *) GetPackFile(pack_file, skin_mds_name, NULL);
        mgCreateVisualType visual_type[64];
        chara = nowChr;
        visual_count = 0;
        deform_index = 0;

        for (index = 0; index < chara->deform_frame_num; index++) {
            if (nowChr->deform_frame[deform_index]) {
                visual_type[visual_count].type = MG_VISUAL_CREATE_MOTION_MDT;
                visual_type[visual_count].name = nowChr->deform_frame[deform_index]->name;
                deform_index++;
                visual_count++;
            }
        }

        visual_type[visual_count].type = MG_VISUAL_CREATE_END;
        visual_type[visual_count].name = NULL;

        if (load_img_ptr != NULL) {
            image = (unsigned char *) base_stack->stAlloc64(load_img_size / 16 + 1);
            memcpy(image, load_img_ptr, load_img_size);
            tex_manager = &mgTexManager;
            image_count = mgGetIMGHeaderNum((char *) image);

            for (image_index = 0; image_index < image_count; image_index++) {
                mgIMG_HEADER header = mgGetIMGHeader((char *) image, image_index);
                tex_manager->DeleteTexture(header.name, set_imgblock);
            }

            tex_manager->EnterIMGFile(image, set_imgblock, base_stack, NULL);
            group_names = tex_manager->GetGroupNameList(set_imgblock, &nowChr->tex_anime_group_num);

            if (group_names != NULL) {
                nowChr->tex_anime_group_start = 0;

                while (group_names[nowChr->tex_anime_group_start] != NULL) {
                    nowChr->tex_anime_group_start++;
                }
            }
        }

        mgLoadData load;
        memset(&load, 0, sizeof(load));
        u_long128 work_buffer[6400];
        mgCMemory work_memory;

        work_memory.stSetBuffer(work_buffer, 6400);
        load.mds = (MDS_HEADER *) model_file;
        load.work_memory = &work_memory;
        load.weight = (unsigned int *) weight_file;
        load.matrix = (float(*)[4][4]) matrix_file;
        load.visual_type = visual_type;
        load.memory = base_stack;
        root_skin_frame = CreateChangeFrame(&load, nowChr->CObjectFrame::frame);

        if (!root_skin_frame) {
            return 0;
        }

        root = nowChr->CObjectFrame::frame;
        frame_num = root_skin_frame->frame_num;
        frame_list = root_skin_frame->frame_list;

        for (frame_index = 0; frame_index < frame_num; frame_index++) {
            source_frame = frame_list[frame_index];

            if (source_frame != NULL && NULL != source_frame->visual) {
                sceVu0FVECTOR box_max;
                sceVu0FVECTOR box_min;

                source_frame->GetBBox(box_max, box_min);
                dest_frame = root->SearchFrame(source_frame->name);

                if (dest_frame != NULL) {
                    dest_frame->SetVisual(source_frame->visual);
                    dest_frame->SetBBox(box_max, box_min);
                }
            }
        }
    } else {
        if (skin_frame != NULL) {
            root = nowChr->CObjectFrame::frame;

            if (root != NULL) {
                skin_id = root->SearchFrameID(skin_name_ptr);
                visual = (mgCVisualMDT *) skin_frame->visual;
                ChangeWeight(nowChr->motion[0].skin_list, base_stack, weight_file, skin_id, nowChr->motion[0].frame_info, visual, root, root_skin_frame);
                dest_frame = root->SearchFrame(skin_name_ptr);

                if (dest_frame != NULL) {
                    dest_frame->SetVisual(visual);
                }
            }
        }
    }

    return 1;
}

/**
 *
 * Allocates level-of-detail model records for the character.
 *
 */
int _LOD_MODEL_START(SPI_STACK *stack, int argc) {
    int count = spiGetStackInt(stack);

    if (count <= 0) {
        return 0;
    }

    u_long128 *block = base_stack->Alloc(DynAnimeAlign16Blocks((u32) count * 0x18) + 2);
    nowChr->lod = new (block) CCharaLOD[count];

    if (nowChr->lod != 0) {
        nowChr->lod_num = count;
    }

    return 1;
}

CCharaLOD::CCharaLOD() {
    link_num = 0;
    link = NULL;
    frame = NULL;
    distance = 0.0f;
    standalone = 0;
    motion = 0;
}

/**
 *
 * Loads and configures a level-of-detail model for the character.
 *
 */
static int _LOD_MODEL(SPI_STACK *stack, int count) {
    mgCreateVisualType visual_type[64];
    mgLoadData         load;
    u_long128          work_buffer[6400];
    CCharaLOD         *level;
    int                index;
    mgCFrame          *source_frame;
    char              *model_name;
    MDS_HEADER        *model_file;
    unsigned int      *weight_file;
    int(*link)[2];
    float(*matrix_file)[4][4];
    int        frame_index;
    int        frame_count;
    int        visual_count;
    mgCFrame  *root;
    mgCFrame **frame_list;
    char      *weight_name;
    char      *matrix_name;
    int        level_index;
    int        deform_index;
    int        quadwords;

    level_index = spiGetStackInt(stack++);

    if (level_index < 0 || level_index >= nowChr->lod_num) {
        return 0;
    }

    level = &nowChr->lod[level_index];
    model_name = spiGetStackString(stack++);
    weight_name = spiGetStackString(stack++);
    matrix_name = spiGetStackString(stack++);
    level->distance = spiGetStackFloat(stack++);
    model_file = (MDS_HEADER *) GetPackFile(pack_file, model_name, NULL);
    weight_file = GetPackFile(pack_file, weight_name, NULL);
    matrix_file = (float(*)[4][4]) GetPackFile(pack_file, matrix_name, NULL);

    if (model_file == NULL) {
        return 0;
    }

    root = nowChr->CObjectFrame::frame;

    if (root == NULL) {
        return 0;
    }

    visual_count = 0;
    memset(&load, 0, sizeof(load));

    mgCMemory work_memory;
    work_memory.stSetBuffer(work_buffer, 6400);
    load.mds = model_file;
    load.work_memory = &work_memory;
    load.visual_type = visual_type;
    load.memory = base_stack;

    if (weight_file == NULL || matrix_file == NULL) {
        visual_type[0].name = NULL;
        visual_type[0].type = MG_VISUAL_CREATE_END;
        level->motion = 0;
        level->standalone = 1;
        level->frame = mgLoadMDSFile(&load);

        if (level->frame == NULL) {
            return 0;
        }

        return 1;
    }

    level->motion = 1;
    deform_index = 0;

    for (index = 0; index < nowChr->deform_frame_num; index++) {
        if (nowChr->deform_frame[deform_index] != NULL) {
            visual_type[visual_count].type = MG_VISUAL_CREATE_MOTION_MDT;
            visual_type[visual_count].name = nowChr->deform_frame[deform_index]->name;
            deform_index++;
            visual_count++;
        }
    }

    visual_type[visual_count].type = MG_VISUAL_CREATE_END;
    visual_type[visual_count].name = NULL;
    load.weight = weight_file;
    load.matrix = matrix_file;
    level->frame = CreateChangeFrame(&load, root);

    if (level->frame == NULL) {
        return 0;
    }

    frame_count = level->frame->frame_num;
    quadwords = DynAnimeAlign16Blocks(frame_count * sizeof(*level->link));
    level->link = new (base_stack->Alloc(quadwords + 2)) int[frame_count][2];
    level->link_num = 0;
    frame_list = level->frame->frame_list;

    if (frame_list == NULL) {
        return 0;
    }

    link = level->link;

    for (frame_index = 0; frame_index < frame_count; frame_index++) {
        source_frame = frame_list[frame_index];

        if (source_frame != NULL) {
            link[0][1] = frame_index;
            link[0][0] = root->SearchFrameID(source_frame->name);

            if (link[0][0] >= 0) {
                link++;
                level->link_num++;
            }
        }
    }

    return 1;
}

/**
 *
 * Clears the active level-of-detail selection.
 *
 */
int _LOD_MODEL_END(SPI_STACK *stack, int argc) {
    nowChr->lod_no = -1;
    return 1;
}

mgCFrame *CCharacter2::ChangeLOD(int index) {
    CCharaLOD *lod;
    mgCFrame  *root;
    mgCFrame  *lod_frame;
    mgCFrame **root_frames;
    int(*pair)[2];
    int        i;
    mgCFrame  *target;
    mgCFrame  *source;
    mgCVisual *motion;
    float      box_min[4];
    float      box_max[4];

    if (this->lod_no < 0 && index != 0) {
        ChangeLOD(0);
    }

    if (index < 0 || index >= this->lod_num) {
        return 0;
    }

    lod = this->lod + index;
    this->motion_enable = lod->motion;

    if (lod->standalone == 0 && index == this->lod_no) {
        return 0;
    }

    this->lod_no = index;
    root = this->CObjectFrame::frame;
    lod_frame = lod->frame;

    if (root == 0 || lod_frame == 0) {
        return 0;
    }

    lod_frame->SetPosition(this->position);
    lod_frame->SetRotation(this->rotation);
    lod_frame->SetScale(this->scale);

    if (lod->standalone != 0) {
        return lod_frame;
    }

    root_frames = root->frame_list;
    pair = lod->link;

    for (i = 0; i < lod->link_num; i++, pair++) {
        target = root->GetFrame((*pair)[0]);

        if (target != 0) {
            source = lod_frame->GetFrame((*pair)[1]);

            if (source != 0) {
                motion = source->visual;

                if (motion != 0 && motion->Iam() == 3) {
                    ((mgCVisualMotionMDT *) motion)->frame = root_frames;
                }

                target->SetVisual(motion);
                source->GetBBox(box_min, box_max);
                target->SetBBox(box_min, box_max);
            }
        }
    }

    return 0;
}

void CCharacter2::Copy(CCharacter2 &dest, mgCMemory *memory) {
    CHRINFO_SE   *sounds;
    int           free_space;
    int           index;
    int           sword;
    COutLineDraw *dest_outline;
    COutLineDraw *source_outline;

    free_space = memory->stack_size - memory->stack_used;
    dest = *this;

    if (memory != NULL) {
        dest.CObjectFrame::frame = mgCopyFrame(CObjectFrame::frame, memory, 1);

        if (dest.CObjectFrame::frame != NULL) {
            dest.shadow_frame = shadow_frame;

            if (outline_tex_no > 0 && (source_outline = outline) != NULL) {
                dest.outline = NULL;
                dest.outline_tex_no = 0;

                for (; source_outline != NULL; source_outline = source_outline->next) {
                    if ((dest_outline = (COutLineDraw *) operator new(sizeof(COutLineDraw), memory->Alloc(9))) != NULL) {
                        dest_outline->next = NULL;
                        dest_outline->Initialize();
                    }

                    if (dest_outline == NULL) {
                        break;
                    }

                    *dest_outline = *source_outline;
                    dest_outline->next = NULL;

                    if (source_outline->frame != NULL) {
                        dest.AddOutLine(source_outline->frame->name, dest_outline);
                    }
                }
            }

            if (dynamic_anime_num > 0 && dynamic_anime != NULL) {
                dest.dynamic_anime = new (memory->Alloc(DynAnimeAlign16Blocks(dynamic_anime_num * sizeof(CDynamicAnime)) + 2)) CDynamicAnime[dynamic_anime_num];

                for (index = 0; index < dynamic_anime_num; index++) {
                    dynamic_anime[index].Copy(dest.dynamic_anime[index], dest.CObjectFrame::frame, memory);
                }
            }

            for (index = 0; index < CHARA_ENTRY_FRAME_MAX; index++) {
                if (entry_frame[index] == NULL) {
                    dest.entry_frame[index] = NULL;
                } else {
                    dest.entry_frame[index] = dest.CObjectFrame::frame->SearchFrame(entry_frame[index]->name);
                }
            }

            for (index = 0; index < CHARA_ENTRY_OBJECT_MAX; index++) {
                if (entry_object[index].frame == NULL) {
                    dest.entry_object[index].frame = NULL;
                } else {
                    dest.entry_object[index].frame = dest.CObjectFrame::frame->SearchFrame(entry_object[index].frame->name);
                    dest.entry_object[index].size = entry_object[index].size;
                    dest.entry_object[index].group = entry_object[index].group;
                    dest.entry_object[index].enable = entry_object[index].enable;
                }
            }

            for (index = 0; index < deform_frame_num; index++) {
                if (deform_frame[index] == NULL) {
                    dest.deform_frame[index] = NULL;
                } else {
                    dest.deform_frame[index] = dest.CObjectFrame::frame->SearchFrame(deform_frame[index]->name);
                }
            }

            if (lod_num > 0) {
                dest.lod = new (memory->Alloc(DynAnimeAlign16Blocks(lod_num * sizeof(CCharaLOD)) + 2)) CCharaLOD[lod_num];

                if (dest.lod == NULL) {
                    return;
                }

                dest.lod_num = lod_num;

                for (index = 0; index < lod_num; index++) {
                    dest.lod[index] = lod[index];
                    dest.lod[index].frame = mgCopyFrame(lod[index].frame, memory, 1);
                }
            }

            lod_no = -1;
            sounds = GetSoundInfoCopy(memory);

            if (sounds != NULL) {
                dest.se_list[0] = sounds;
                dest.se_num[0] = se_num[0];
            }

            for (sword = 0; sword < CHARA_SWORD_EFFECT_MAX; sword++) {
                if (sword_effect[sword] != NULL) {
                    dest.sword_effect[sword] = new (memory->Alloc(12)) CSWordAfterEffect;
                    sword_effect[sword]->Copy(*dest.sword_effect[sword], memory);
                }
            }

            free_space -= memory->stack_size - memory->stack_used;
            copy_size = free_space;
        }
    }
}
