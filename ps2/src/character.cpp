#include "common.h"
#include "mglib.hpp"
#include "dataread.hpp"
#include "swordeffect.hpp"
#include "snd_mngr.hpp"
#include "dng_event.hpp"
#include "effscript.hpp"
#include "colprim.hpp"
#include "mg_math.hpp"
#include "mg_camera.hpp"
#include "sceneload.hpp"
#include "scene.hpp"
#include "sound.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "savedata.hpp"
#include "actscript.hpp"
#include <cstring>
#include <cstdio>
#include <cmath>
#include "dynamicanime.hpp"
#include "effect.hpp"
#include "gameutil.hpp"
#include "map.hpp"
#include "mg_dataset.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "object.hpp"
#include "outline.hpp"
#include "scriptinterpreter.hpp"
#include "visualmotion.hpp"
#include "character.hpp"

extern CCharacter2 *nowChr;
extern u32 *pack_file;
extern mgCMemory *base_stack;
extern int set_imgblock;
extern char *skin_name_ptr;
extern mgCFrame *root_skin_frame;
extern mgCFrame *skin_frame;
extern SPI_TAG_PARAM skin_tag[];
extern char skin_mds_name[64];
extern unsigned char *load_img_ptr;
extern int load_img_size;
extern mgCMemory *img_stack;
extern mgIMG_FILE_HEADER *img_ptr[CHARA_IMAGE_MAX];
extern int outline_tex_id;
extern mgCMemory *now_stack;
extern CHRINFO_SEQ *now_seq_ptr;
extern CHRINFO_SEQ_HEADER *now_seqhd_ptr;
extern unsigned int *eff_pack_ptr;
extern int eff_pack_size;
extern mgCTextureManager mgTexManager;
extern int alloc_vertex_num;
extern char alloc_vertex[25][16];
extern char at_1395[14];
extern mgCMemory *ext_stack;
extern int outline_flag;
extern CCharacter2 *parent_chr;
extern int outline_start;
extern mgCTexture *outline_start_tex;
extern int alloc_shadow_vertex_num;
extern int now_cloth_id;
extern int now_motion_id;
extern CHRINFO_KEY_SET *now_key_ptr;

extern int outline_num_1499;
extern s8 init_1500;
extern char at_1522[];
extern char at_1570[];
extern char at_1571[];
extern "C" CObject &__as__7CObjectFRC7CObject(CObject *, const CObject *);
extern CHRINFO_SE *now_se_header;
union VisualTypeData {
    mgCreateVisualType type[2];
    u_long128 qw;
};

extern VisualTypeData at_1575;
static inline u32 DynAnimeAlign16Blocks(u32 n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }
    return n >> 4;
}

extern SPI_TAG_PARAM tag[];
void ScanInfoFile(CCharacter2 *chara, u32 *pack_file, char *info_name, mgCMemory *memory,
                  mgCMemory *ext_memory, mgCMemory *img_memory, int texture_block, CCharacter2 *parent,
                  int with_line);
int _V2(SPI_STACK *stack, int argc);
int _NAME(SPI_STACK *stack, int argc);
int _BODY_SIZE(SPI_STACK *stack, int argc);
int _SCALE(SPI_STACK *stack, int argc);
int _MATERIAL_ANIME(SPI_STACK *stack, int argc);
int _POLY_NUM(SPI_STACK *stack, int argc);
int _IMG(SPI_STACK *stack, int argc);
int _IMG_END(SPI_STACK *stack, int argc);
int _OUTLINE(SPI_STACK *stack, int argc);
int _SHADOW_MODEL(SPI_STACK *stack, int argc);
int _OBJECT_NAME(SPI_STACK *stack, int argc);
int _OBJECT_NAME2(SPI_STACK *stack, int argc);
int _MOTION(SPI_STACK *stack, int argc);
int _SHADOW_MOTION(SPI_STACK *stack, int argc);
int _VERTEX_ANIME(SPI_STACK *stack, int argc);
int _SHAPE_ANIME(SPI_STACK *stack, int argc);
int _KEY_START(SPI_STACK *stack, int argc);
int _KEY(SPI_STACK *stack, int argc);
int _KEY_END(SPI_STACK *stack, int argc);
int _SEQ(SPI_STACK *stack, int argc);
int _SEQ_END(SPI_STACK *stack, int argc);
int _CLOTH_START(SPI_STACK *stack, int argc);
int _CLOTH(SPI_STACK *stack, int argc);
int _CLOTH_END(SPI_STACK *stack, int argc);
int _POSITION(SPI_STACK *stack, int argc);
int _ROTATION(SPI_STACK *stack, int argc);
int _SE_START(SPI_STACK *stack, int argc);
int _SE(SPI_STACK *stack, int argc);
int _SELP(SPI_STACK *stack, int argc);
int _SE_END(SPI_STACK *stack, int argc);
int _MOTION_END(SPI_STACK *stack, int argc);
int _EFFECT_START(SPI_STACK *stack, int argc);
int _EFFECT_END(SPI_STACK *stack, int argc);
void ScanInfoSkinFile(CCharacter2 *chara, u32 *pack_file, char *info_name, char *skin_name,
                      mgCMemory *memory, int texture_block);
int _SKIN_IMG(SPI_STACK *stack, int argc);
int _SKIN_IMG_END(SPI_STACK *stack, int argc);
int _SKIN_MODEL(SPI_STACK *stack, int argc);
int _LOD_MODEL_START(SPI_STACK *stack, int argc);
int _LOD_MODEL_END(SPI_STACK *stack, int argc);
#include "character.hpp"

#include <cmath>
#include <cstdio>
#include <cstring>
#include <libvu0.h>

#include "dataread.hpp"
#include "dynamicanime.hpp"
#include "effect.hpp"
#include "gameutil.hpp"
#include "mg_dataset.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "outline.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "swordeffect.hpp"
#include "visualmotion.hpp"



// Code (.text)
void CCharacter2::SetPosition(float *pos) {
    mgCObject::SetPosition(pos);
}
void CCharacter2::AddOutLine(char *name, COutLineDraw *line) {
    mgCFrame *target;
    COutLineDraw *p;
    COutLineDraw *last;
    COutLineDraw *q;
    if (name != NULL) {
        target = this->CObjectFrame::frame;
        if (*(s8 *)name != 0) {
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
    int enabled;

    if (other == NULL) {
        return;
    }
    if (other->outline == NULL) {
        return;
    }
    enabled = (int)other->outline->texture;
    if (enabled == 0) {
        return;
    }
    for (line = outline; line != NULL; line = line->next) {
        line->texture = (mgCTexture *)enabled;
    }
}

int CCharacter2::Draw() {
    sceVu0FVECTOR  world_position;
    float          draw_alpha;
    float          clip_alpha;
    int            count;
    int            i;

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
    sceVu0FVECTOR  max;
    sceVu0FVECTOR  min;
    int            i;

    for (i = 0; i < deform_frame_num; i++) {
        if (deform_frame[i] != NULL) {
            deform_frame[i]->RemakeBBox(max, min);
        }
    }
}

void CCharacter2::DrawStep() {
    float  clip_alpha;

    FarClip(GetCameraDist(), &clip_alpha);
}

float CCharacter2::GetCameraDist() {
    sceVu0FVECTOR  head_position;
    sceVu0FVECTOR  camera_position;
    sceVu0FVECTOR  closest_position;
    float          height;

    height = body_height;
    if (height < 1.0f) {
        height = 34.0f;
    }
    *(u_long128 *)head_position = *(u_long128 *)position;
    head_position[1] += height;
    mgGetCameraPos(camera_position);
    return mgDistLinePoint(camera_position, position, head_position, closest_position);
}
int CCharacter2::DrawDirect() {
    float world_pos[4];
    struct OutlineCopy {
        COutLineDraw *next;
        u_long128 box[2];
        int enabled;
        mgCFrame *frame;
        float width;
        int depth;
        float pos[4];
        float color[4];
        int enable;
        int hide;
    };
    OutlineCopy lod_line;
    float entry_pos[4];
    float view_pos[4];
    float step_alpha;
    COutLineDraw *line;
    CCharaLOD *lod_entry;
    mgCFrame *lod_frame;
    float alpha;
    float camera_dist;
    float fade;
    int lod_no;
    int count;
    int i;
    int j;

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
        lod_line = *(OutlineCopy *)line;
        lod_line.next = NULL;
        ((COutLineDraw *)&lod_line)->SetFrame(lod_frame);
        line = (COutLineDraw *)&lod_line;
    }
    SetDeformMesh();
    count = 0;
    if (line != NULL) {
        fade = 1.0f;
        if (entry_frame[0] != NULL) {
            GetEntryObjectPos(0, entry_pos);
        } else {
            *(u_long128 *)entry_pos = *(u_long128 *)world_pos;
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
    int  i;

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
        range = (float)(now_key->end_frame - now_key->start_frame);
        SetNowFrame((float)now_key->start_frame + range * weight);
    }
}

#ifdef NONMATCHING
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
        if (sequence != NULL) {
            next_seq = sequence;
            seq_mode = 1;
            seq_flags = flags;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", SetMotionPara__11CCharacter2FPcii);
#endif

void CCharacter2::SetDAnimeEnable(int enable) {
    if (enable != 0) {
        dynamic_anime_flags &= ~CHARA_DYNAMIC_ANIME_DISABLE;
    } else {
        dynamic_anime_flags |= CHARA_DYNAMIC_ANIME_DISABLE;
    }
}
CHRINFO_SE *CCharacter2::GetSoundInfoCopy(mgCMemory *memory) {
    u32 bytes;
    u32 blocks;
    void *block;
    void *copy;

    if (se_num[0] <= 0) {
        return NULL;
    }
    bytes = se_num[0] * (int)sizeof(CHRINFO_SE);
    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }
    block = memory->Alloc(blocks + 2);
    copy = operator new[](se_num[0] * (int)sizeof(CHRINFO_SE), (u_long128 *)block);
    memcpy(copy, se_list[0], se_num[0] * (int)sizeof(CHRINFO_SE));
    return (CHRINFO_SE *)copy;
}

int CCharacter2::CheckFootEffect() {
    if (foot_effect_wait <= 0) {
        return -1;
    }
    return foot_sound_id;
}
void CCharacter2::SePlay() {
    CHRINFO_SE *key;
    float pos[4];
    float passed;
    float low;
    float high;
    int i;

    if (foot_effect_wait > 0) {
        foot_effect_wait--;
    }
    float now = frame;
    passed = 1.6f * (1.2f * step);
    key = (CHRINFO_SE *)se_list[now_set];
    low = now - passed;
    high = now + passed;
    if (key == NULL) {
        return;
    }
    se_volume = 1.0f;
    se_pan = 0.0f;
    i = 0;
    if (se_positional == 1) {
        GetEntryObjectPos(0, pos);
        float far_dist = 1200.0f;
        float near_dist = 160.0f;
        sndGetVolPan(&se_volume, &se_pan, pos, 160.0f, 1200.0f);
    }
    for (i = 0; i < se_num[now_set]; key++, i++) {
        if (key->loop_slot > 0) {
            if (!(frame < key->frame) && frame <= key->end_frame) {
                if (key->kind == 2) {
                    if (loop_se != NULL) {
                        loop_se->SeLoopPlayStop(se_bank, key->se_no, key->loop_slot,
                                                      13);
                    }
                }
                if (key->kind == 3) {
                    if (loop_se != NULL) {
                        loop_se->SeLoopPlayStop(se_bank_2, key->se_no, key->loop_slot,
                                                      13);
                    }
                }
            }
            key->wait = 0;
        } else if (low < key->frame && !(high <= key->frame) && key->wait == 0) {
            if (key->kind < 2 && foot_sound_enable != 0) {
                if (foot_sound_id >= 0) {
                    sndSePlayVPf(foot_se_bank, key->kind + foot_sound_id * 2, se_volume, se_pan, 0);
                }
                foot_effect_wait = 1;
                key->wait = 6;
            }
            if (key->kind == 2) {
                sndSePlayVPf(se_bank, key->se_no, se_volume, se_pan, 0);
                key->wait = 6;
            }
            if (key->kind == 4) {
                sndSePlayVPf(se_bank, key->se_no, se_volume, se_pan, 0);
                key->wait = 6;
                foot_effect_wait = 1;
            }
            if (key->kind == 3) {
                sndSePlayVPf(se_bank_2, key->se_no, se_volume, se_pan, 0);
                key->wait = 6;
            }
        }
        if (key->wait > 0) {
            key->wait--;
        }
    }
}
void CCharacter2::Step() {
    float matrix[4][4];
    int sequence_done;
    int reset_dynamic_anime;
    int motion_state;
    int now_flags;
    float entry_angle;
    CHRINFO_SEQ *playing;
    float *entry_pos;

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
            seq_state = 0;
            if (now_seq != NULL) {
                seq_step = now_seq->seq;
                if (seq_step != NULL) {
                    seq_state = 1;
                    now_flags = seq_flags;
                    switch (seq_step->type) {
                        case 1:
                            seq_loop = seq_step->loop_count;
                            break;
                        default:
                        case 0:
                        case 2:
                            now_flags |= 2;
                            break;
                        case 3:
                        case 7:
                            break;
                    }
                    SetMotionPara((char *)seq_step, now_flags, 1);
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
        seq_state = 2;
        sequence_done = 0;
        motion_state = ((CCharacter2 *)this)->GetMotionStatus();
        switch (seq_step->type) {
            case 0:
                if (motion_state == 4) {
                    sequence_done = 1;
                }
                break;
            case 1:
                if (motion_state == 4) {
                    seq_loop--;
                    if (seq_loop <= 0) {
                        sequence_done = 1;
                    }
                }
                break;
            case 2:
            case 7:
                if (motion_state == 4) {
                    seq_state = 3;
                    if (seq_advance != 0) {
                        sequence_done = 1;
                    }
                }
                break;
            case 3:
                seq_state = 3;
                if (seq_advance != 0) {
                    sequence_done = 1;
                }
                break;
        }
        if (sequence_done != 0) {
            playing = seq_step;

            if (*((s8 *)playing + sizeof(CHRINFO_SEQ)) == 0) {
                seq_state = 4;
                return;
            }
            seq_step = playing + 1;
            seq_loop = 0;
            seq_advance = 0;
            if (seq_step != NULL) {
                now_flags = 0;
                switch (seq_step->type) {
                    case 1:
                        seq_loop = seq_step->loop_count;
                        break;
                    case 0:
                    case 2:
                        now_flags = 2;
                        break;
                    case 3:
                    case 7:
                        break;
                }
                SetMotionPara((char *)seq_step, now_flags, 1);
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
    *(u_long128 *)entry_matrix[0] = *(u_long128 *)matrix[0];
    *(u_long128 *)entry_matrix[1] = *(u_long128 *)matrix[1];
    *(u_long128 *)entry_matrix[2] = *(u_long128 *)matrix[2];
    *(u_long128 *)entry_matrix[3] = *(u_long128 *)entry_pos;
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
    int  index;

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].SetWind(power, dir);
    }
}

void CCharacter2::ResetWind() {
    int  index;

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].ResetWind();
    }
}

void CCharacter2::SetFloor(float y) {
    int  index;

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].SetFloor(y);
    }
}

void CCharacter2::ResetFloor() {
    int  index;

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].ResetFloor();
    }
}

#ifdef NONMATCHING
void CCharacter2::NormalDrive() {
    float  frame_step;

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
        frame_step = step * 1.2f;
        if ((now_flags & CHARA_MOTION_PAUSE) != 0) {
            frame_step = 0.0f;
        }
        frame += frame_step;
        if (!(frame_step <= 0.0f)) {
            motion_status = CHARA_MOTION_STATUS_PLAY;
        }
        if (frame < now_key->start_frame + step * 1.2f && !(frame < now_key->start_frame)) {
            frame = now_key->start_frame;
            motion_status = CHARA_MOTION_STATUS_START;
        }
        if (!(frame + step * 1.2f <= now_key->end_frame)) {
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
    ChangeMotion(CObjectFrame::frame, &motion[now_set], (int)(0.9f + frame), now_key->start_frame, blend, NULL);
    blend += blend_speed;
    if (!(blend < 1.0f)) {
        posed_key = now_key;
        frame = now_key->start_frame;
        motion_status = CHARA_MOTION_STATUS_START;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", NormalDrive__11CCharacter2Fv);
#endif
void CCharacter2::ShadowStep() {
    int i;
    mgCFrame *source;
    mgCFrame *root;
    mgCFrame *shadow;
    float matrix[4][4];
    float scale_vec[4];

    if (shadow_frame != NULL && CheckDraw() != 0 && motion_enable != 0 && now_key != NULL) {
        root = CObjectFrame::frame;
        for (i = 0; i < shadow_link_num; i++) {
            source = root->GetFrame(shadow_link_model[i]);
            if (source != NULL) {
                shadow = shadow_frame->GetFrame(shadow_link_shadow[i]);
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
    int number;
    int list;
    int i;
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
    int list = 0;
    int i;

    do {
        entry = key_list[list];
        if (entry != 0) {
            for (i = 0; i < key_num[list]; i++) {
                if (entry->name[0] == 0) {
                    break;
                }
                if (strcmp((char *)entry->name, name) == 0) {
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
    int list = 0;

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
    int i;
    CHRINFO_KEY_SET *first;
    mgCTextureManager *tex;
    int group;
    mgIMG_HEADER *image;
    int j;
    u32 k;
    int offset;
    mgIMG_FILE_HEADER **slot;
    mgIMG_FILE_HEADER *images;
    for (i = 1; i < 8; i++) {
        motion[i].frame_info = NULL;
        shadow_motion[i].frame_info = NULL;
        key_list[i] = 0;
        key_num[i] = 0;
        seq_list[i] = 0;
        first = GetKeyListIndexPtr(0, 0);
        if (first != 0) {
            SetMotion((char *)first, 4);
        }
        if (next_key != 0) {
            posed_key = next_key;
            frame = (float)next_key->start_frame;
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
        slot = (mgIMG_FILE_HEADER **)((u8 *)this + offset + 0x2C4);
        images = *slot;
        if (images != 0) {
            image = (mgIMG_HEADER *)(images + 1);
            for (k = 0; k < images->num3; k++) {
                if (*(u8 *)image->name != '#') {
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
    int group_count;
    int group;
    mgIMG_HEADER *image;
    u32 i;
    mgIMG_FILE_HEADER *images;

    tex->GetGroupNameList(texture_block, &group_count);
    group = tex_anime_group_start;
    if (group > 0) {
        for (; group < tex_anime_group_num; group++) {
            tex->DeleteTexAnimeGroup(texture_block, group);
        }
    }
    images = this->images[0];

    image = (mgIMG_HEADER *)(images + 1);
    if (images != NULL) {
        i = 0;
        while (i < images->num3) {

            if (*(u8 *)image->name != '#') {
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
    float position[4];
    float rotation[4];

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
    int offset;

    GetPosition(out);
    if (nth < 0 || nth > 0x18) {
        return 0;
    }
    found = -1;
    i = 0;
    offset = 0;
    for (; i < 0x18; i++, offset += 0x10) {
        u8 *base = (u8 *)this + offset;
        if (*(mgCFrame **)(base + 0x140) != 0 && *(int *)(base + 0x148) == id) {
            found++;
        }
        if (found == nth) {
            int at = i * 0x10;
            (*(mgCFrame **)(at + (int)this + 0x140))->GetWorldPosition0(out);
            return &entry_object[i];
        }
    }
    return 0;
}
float CCharacter2::GetWaitToFrame(char *name, float wait) {
    float frame = 0.0f;

    CHRINFO_KEY_SET *motion = nowChr->GetKeyListPtr(name, NULL);
    if (motion != NULL) {
        frame = (float)motion->start_frame + wait * ((float)motion->end_frame - (float)motion->start_frame);
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
            SetMotion((char *)first, 4);
        }
        if (next_key != 0) {
            posed_key = next_key;
            frame = (float)next_key->start_frame;
            step = next_key->step;
        }
    }
}
void CCharacter2::Initialize() {
    int j;
    int i;
    u8 *raw = (u8 *)this;

    CObjectFrame::Initialize();
    *(int *)(raw + 0x88) = 0;
    *(int *)(raw + 0x84) = 0;
    *(int *)(raw + 0x80) = 0;
    *(int *)(raw + 0x8C) = 0x3F800000;
    base_scale[3] = 1.0f;
    base_scale[2] = 1.0f;
    base_scale[1] = 1.0f;
    base_scale[0] = 1.0f;
    *(int *)(raw + 0xA0) = 0;
    *(int *)&alpha = 0x3F800000;
    mgUnitMatrix((float(*)[4])(raw + 0xB0));
    this->CObjectFrame::frame = 0;
    this->load_size = 0;
    this->copy_size = 0;
    this->poly_num[1] = 0;
    this->poly_num[0] = 0;
    this->dynamic_anime_flags = 0;
    this->outline = 0;
    this->shadow_frame = 0;
    frame = 0;
    *(int *)(raw + 0x500) = 0;
    this->motion_status = 0;
    this->shape_anime = 0;
    this->foot_sound_id = -1;
    this->foot_sound_enable = 1;
    this->se_positional = 1;
    this->se_volume = 1.0f;
    this->se_pan = 0;
    this->foot_effect_wait = -1;
    this->loop_se = 0;
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
        *(int *)&this->entry_object[i].unk_04 = 0;
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
    memset(this->motion, 0, 0xA0);
    memset(this->shadow_motion, 0, 0xA0);
    this->now_set = 0;
    this->next_set = 0;
    this->next_key = 0;
    this->now_key = 0;
    this->posed_key = 0;
    this->next_seq = 0;
    this->now_seq = 0;
    *(int *)(raw + 0x3AC) = 0;
    *(int *)(raw + 0x500) = 0;
    this->shadow_frame_info = 0;
    this->lod_num = 0;
    this->lod = 0;
    this->lod_no = -1;
    this->motion_enable = 1;
    this->shadow_link_num = 0;
    this->shadow_link_shadow = 0;
    this->shadow_link_model = 0;
    this->InitEffect();
}
void ScanInfoFile(CCharacter2 *chara, u32 *pack_file, char *info_name, mgCMemory *memory,
                  mgCMemory *ext_memory, mgCMemory *img_memory, int texture_block, CCharacter2 *parent,
                  int with_line) {
    int size;
    char *script;
    int free_blocks = memory->stack_size - memory->stack_used;
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
    script = (char *)GetPackFile(pack_file, info_name, &size);
    if (script == 0) {
        printf(at_1395, info_name);
        return;
    }
    interp.SetTag((SPI_TAG_PARAM *)tag);
    interp.SetScript(script, size);
    now_motion_id = 0;
    now_stack = memory;
    interp.Run();
    free_blocks -= memory->stack_size - memory->stack_used;
    chara->load_size = free_blocks;
}
int _V2(SPI_STACK *stack, int argc) {
    return 1;
}
int _NAME(SPI_STACK *stack, int argc) {
    return 1;
}
int _BODY_SIZE(SPI_STACK *stack, int argc) {
    SPI_STACK *next = stack + 1;

    if (nowChr == 0) {
        return 0;
    }

    nowChr->body_height = (float)spiGetStackInt(stack);
    nowChr->body_width = (float)spiGetStackInt(next++);
    nowChr->body_depth = (float)spiGetStackInt(next);
    return 1;
}
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
        ((mgCFrame *)nowChr->shadow_frame)->SetScale(nowChr->base_scale);
    }
    return 1;
}
int _MATERIAL_ANIME(SPI_STACK *stack, int argc) {
    return 1;
}
int _POLY_NUM(SPI_STACK *stack, int argc) {
    nowChr->poly_num[0] = 0;
    nowChr->poly_num[1] = 0;
    if (argc > 0) {
        nowChr->poly_num[0] += spiGetStackInt(stack++);
    }
    if (argc == 2) {
        nowChr->poly_num[1] += spiGetStackInt(stack);
    }
    return 1;
}
int _IMG(SPI_STACK *stack, int argc) {
    int index;
    SPI_STACK *name_arg = stack + 1;
    int size;
    char *data;

    if (img_stack == 0) {
        return 0;
    }
    index = spiGetStackInt(stack);
    if (index < 0 || index >= CHARA_IMAGE_MAX) {
        return 0;
    }
    data = (char *)GetPackFile(pack_file, spiGetStackString(name_arg), &size);
    if (data == 0) {
        return 0;
    }
    img_ptr[index] = (mgIMG_FILE_HEADER *)img_stack->stAlloc64(size / 16 + 1);
    memcpy(img_ptr[index], data, size);
    return 1;
}
int _IMG_END(SPI_STACK *stack, int argc) {
    int i;
    mgCTextureManager *tex;
    char **name_list;

    tex = &mgTexManager;
    nowChr->texture_block = set_imgblock;
    for (i = 0; i < CHARA_IMAGE_MAX; i++) {
        if (img_ptr[i] != 0) {
            nowChr->images[i] = (mgIMG_FILE_HEADER *)img_ptr[i];
            outline_tex_id = tex->EnterIMGFile((u8 *)img_ptr[i], set_imgblock, img_stack, 0);
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
int _OUTLINE(SPI_STACK *stack, int argc) {
    char name[0x40];
    char texture_name[0x20];
    SPI_STACK *arg = stack + 1;
    float width;
    mgCTextureManager *tex_manager;
    COutLineDraw *outline;
    mgCTexture *texture;

    if (outline_flag == 0) {
        return 1;
    }
    strcpy(name, spiGetStackString(stack));
    width = spiGetStackFloat(arg);
    tex_manager = &mgTexManager;
    if (tex_manager == 0 || set_imgblock == -1) {
        return 0;
    }
    if ((outline = (COutLineDraw *)operator new(0x70, (u_long128 *)base_stack->Alloc(9))) != 0) {
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
            if (init_1500 == 0) {
                outline_num_1499 = 1;
                init_1500 = 1;
            }
            outline_num_1499 += 1;
            sprintf(texture_name, at_1522, outline_num_1499);
            nowChr->outline_tex_no = outline_num_1499;
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
 * Loads the model with the visual classes needed by its animated vertices.
 */
static int _MODEL(SPI_STACK *stack, int count) {
    char                weight_name[64];
    char               *model_name;
    MDS_HEADER         *model;
    u_int              *weight;
    mgCreateVisualType  visual_type[26];
    mgLoadData          load;
    u_long128           work_buffer[6400];
    mgCFrame           *deform_frame;
    int                 index;
    char byte;

    model_name = spiGetStackString(stack);
    model = (MDS_HEADER *)GetPackFile(pack_file, model_name, NULL);
    if (model == NULL) {
        printf(at_1395, model_name);
        return 0;
    }
    for (index = 0; (byte = model_name[index]) != '\0' && byte != '.'; index++) {
        weight_name[index] = byte;
    }
    weight_name[index] = '\0';
    strcat(weight_name, at_1570);
    weight = GetPackFile(pack_file, weight_name, NULL);
    if (alloc_vertex_num > 0) {
        char *empty_name = at_1571;
        mgCreateVisualType *visual = visual_type;
        int vertex_index = 0;
        int vertex_offset = 0;
        for (; vertex_index < alloc_vertex_num; vertex_index++) {
            if (nowChr->shape_anime == 0) {
                visual->type = MG_VISUAL_CREATE_MOTION_MDT;
            } else {
                visual->type = MG_VISUAL_CREATE_MDT;
            }
            visual->name = (char *)alloc_vertex + vertex_offset;
            vertex_offset += 16;
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
    int frame_offset = 0;
    for (; frame_index < alloc_vertex_num; frame_offset += 16, frame_index++) {
        if (nowChr->CObjectFrame::frame != NULL) {
            deform_frame = nowChr->CObjectFrame::frame->SearchFrame((char *)alloc_vertex + frame_offset);
            if (deform_frame != NULL) {
                nowChr->deform_frame[nowChr->deform_frame_num] = deform_frame;
                nowChr->deform_frame_num++;
            }
        }
    }
    return 1;
}
int _SHADOW_MODEL(SPI_STACK *stack, int argc) {
    VisualTypeData visual_type;
    char *name;
    int **shadow_table;
    int pairs;
    u32 bytes;
    int i;
    mgCFrame *frame;
    int count;
    u8 *model;
    int *frame_names;
    int *model_names;
    char *pack;

    visual_type = at_1575;
    name = spiGetStackString(stack);
    pack = (char *)GetPackFile(pack_file, name, 0);
    if (pack == 0) {
        printf(at_1395, name);
        return 0;
    }
    nowChr->shadow_frame =
        mgLoadMDSFile(
            (MDS_HEADER *)pack, base_stack, visual_type.type, 0);
    frame = (mgCFrame *)nowChr->CObjectFrame::frame;
    shadow_table = (int **)&nowChr->shadow_link_num;
    model = (u8 *)nowChr->shadow_frame;
    while (model != 0 && frame != 0) {
        count = *(int *)(model + 0x64);
        frame_names = (int *)frame->frame_list;
        model_names = *(int **)(model + 0x68);
        if (count != 0) {
            bytes = count * 4;
            shadow_table[1] = (int *)operator new[](
                bytes, (u_long128 *)base_stack->Alloc(DynAnimeAlign16Blocks(bytes) + 2));
            shadow_table[2] = (int *)operator new[](
                bytes, (u_long128 *)base_stack->Alloc(DynAnimeAlign16Blocks(bytes) + 2));
            if (shadow_table[1] != 0) {
                if (shadow_table[2] != 0) {
                    pairs = 0;
                    for (i = 0; i < count; i++) {
                        u8 *sub = (u8 *)model_names[i];
                        if (sub != 0 && frame_names[i] != 0) {
                            char *sub_name = *(char **)(sub + 0x50);
                            if (sub_name != 0) {
                                int id = frame->SearchFrameID(sub_name);
                                if (id >= 0) {
                                    shadow_table[1][pairs] = id;
                                    shadow_table[2][pairs] = i;
                                    pairs++;
                                }
                            }
                        }
                    }
                    *(int *)shadow_table = pairs;
                }
            }
        }
        break;
    }
    return 1;
}
int _OBJECT_NAME(SPI_STACK *stack, int argc) {
    char name[0x40];
    int frame_slot = -1;
    int object_slot;
    int n;
    int i;
    int offset;
    mgCFrame *root;
    mgCFrame *found;

    i = 0;
    offset = 0;
    do {
        if (((CCharacter2 *)((u8 *)nowChr + offset))->entry_frame[0] == 0) {
            frame_slot = i;
            break;
        }
        i++;
        offset += 4;
    } while (i < 2);
    object_slot = -1;
    if (frame_slot == -1) {
        return 0;
    }
    i = 0;
    offset = 0;
    do {
        if (((CCharacter2 *)((u8 *)nowChr + offset))->entry_object[0].frame == 0) {
            object_slot = i;
            break;
        }
        i++;
        offset += 0x10;
    } while (i < 0x18);
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
            *(int *)&nowChr->entry_object[object_slot].unk_04 = 0;
            nowChr->entry_object[object_slot].group = object_slot;
            nowChr->entry_object[object_slot++].enable = 1;
        }
    }
    return 1;
}
int _OBJECT_NAME2(SPI_STACK *stack, int argc) {
    char name[0x40];
    int object_slot = -1;
    int id;
    mgCFrame *root;
    int pair_count;
    int n;
    mgCFrame *found;
    float value;
    int i;
    int offset;

    i = 0;
    offset = 0;
    do {
        if (nowChr->entry_object[i].frame == 0) {
            object_slot = i;
            break;
        }
        i++;
        offset += 0x10;
    } while (i < 0x18);
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
            nowChr->entry_object[object_slot].unk_04 = value;
            nowChr->entry_object[object_slot].group = id;
            nowChr->entry_object[object_slot++].enable = 1;
        }
    }
    return 1;
}
int _MOTION(SPI_STACK *stack, int argc) {
    tagMOTION_TYPE *motion;
    char *first_name;
    mgCFrame *root;
    SPI_STACK *arg;
    char *second_name;
    char *third_name;
    MOTION_FILE_INFO entry[3];
    int *source;
    int *dest;

    root = nowChr->CObjectFrame::frame;
    arg = stack + 1;
    if (root == 0) {
        return 0;
    }
    now_motion_id = spiGetStackInt(stack);
    if (now_motion_id < 0 || now_motion_id >= 8) {
        return 0;
    }
    motion = (tagMOTION_TYPE *)((u8 *)nowChr + (now_motion_id * 5 << 2) + 0x3C0);
    memset(motion, 0, 0x14);
    first_name = spiGetStackString(arg++);
    second_name = spiGetStackString(arg++);
    third_name = spiGetStackString(arg);
    entry[1].name = first_name;
    entry[0].name = second_name;
    entry[2].name = third_name;
    entry[0].size = 0;
    entry[1].size = 0;
    entry[2].size = 0;
    entry[0].data = (char *)GetPackFile(pack_file, second_name, &entry[0].size);
    entry[1].data = (char *)GetPackFile(pack_file, first_name, &entry[1].size);
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
        source = (int *)&nowChr->shadow_motion[0];
        dest = (int *)&nowChr->shadow_motion[now_motion_id];
        dest[0] = source[0];
        dest[1] = source[1];
        dest[2] = source[2];
        dest[3] = source[3];
    }
    return 1;
}
int _SHADOW_MOTION(SPI_STACK *stack, int argc) {
    tagMOTION_TYPE *motion;
    char *first_name;
    char *second_name;
    char *third_name;
    MOTION_FILE_INFO entry[3];

    if (nowChr->shadow_frame == 0) {
        return 0;
    }
    if (now_motion_id < 0 || now_motion_id >= 8) {
        return 0;
    }
    motion = (tagMOTION_TYPE *)((u8 *)nowChr + now_motion_id * 0x14 + 0x460);
    memset(motion, 0, 0x14);
    first_name = spiGetStackString(stack++);
    second_name = spiGetStackString(stack++);
    third_name = spiGetStackString(stack);
    entry[0].size = 0;
    entry[1].size = 0;
    entry[2].size = 0;
    entry[1].name = first_name;
    entry[0].name = second_name;
    entry[2].name = third_name;
    entry[0].data = (char *)GetPackFile(pack_file, second_name, &entry[0].size);
    entry[1].data = (char *)GetPackFile(pack_file, first_name, &entry[1].size);
    entry[2].data = (char *)GetPackFile(pack_file, third_name, &entry[2].size);
    if (*(s8 *)second_name == 0) {
        entry[0].name = 0;
    }
    if (*(s8 *)third_name == 0) {
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
            (mgCFrame *)nowChr->shadow_frame, motion, base_stack, &nowChr->shadow_frame_info);
    }
    *(tagFRAME_INF **)((u8 *)motion + 0x10) = nowChr->shadow_frame_info;
    return 1;
}
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
int _SHAPE_ANIME(SPI_STACK *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    nowChr->shape_anime = spiGetStackInt(stack);
    return 1;
}
int _KEY_START(SPI_STACK *stack, int argc) {
    now_key_ptr = (CHRINFO_KEY_SET *)(now_stack->stack + now_stack->stack_used);
    nowChr->key_list[now_motion_id] = now_key_ptr;
    nowChr->key_num[now_motion_id] = 0;
    return 1;
}
int _KEY(SPI_STACK *stack, int argc) {
    SPI_STACK *arg;
    if (argc < 4) {
        return 0;
    }
    arg = stack + 1;
    if (now_key_ptr == 0) {
        return 0;
    }
    strcpy((char *)now_key_ptr, spiGetStackString(stack));
    now_key_ptr->start_frame = spiGetStackInt(arg++);
    now_key_ptr->end_frame = spiGetStackInt(arg++);
    now_key_ptr->step = spiGetStackFloat(arg);
    now_key_ptr++;
    nowChr->key_num[now_motion_id]++;
    return 1;
}
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

#ifdef NONMATCHING

static int _SEQ_START(SPI_STACK *stack, int count) {
    CHRINFO_SEQ_HEADER *previous;

    if (count <= 0) {
        return 0;
    }
    if (now_stack == NULL) {
        return 0;
    }
    previous = now_seqhd_ptr;
    now_seqhd_ptr = (CHRINFO_SEQ_HEADER *)now_stack->stAlloc64(4);
    now_seq_ptr = (CHRINFO_SEQ *)&now_stack->stack[now_stack->stack_used];
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", _SEQ_START__FP9SPI_STACKi);
#endif
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
int _CLOTH_START(SPI_STACK *stack, int argc) {
    int count = spiGetStackInt(stack);
    if (count <= 0) {
        return 0;
    }
    void *block = (void *)now_stack->Alloc(DynAnimeAlign16Blocks((u32)count * 0x90) + 2);
    nowChr->dynamic_anime = new ((u_long128 *)block) CDynamicAnime[count];
    if (nowChr->dynamic_anime == 0) {
        return 0;
    }
    nowChr->dynamic_anime_num = count;
    return 1;
}
CDynamicAnime::CDynamicAnime() {
    Initialize();
}
int _CLOTH(SPI_STACK *stack, int argc) {
    int i;
    char *name;
    char *data;
    int size;
    CCharacter2 *chara;
    int index;
    mgCFrame *model_frame;
    mgCFrame *shadow_frame;
    int *pairs;
    int j;
    mgCFrame *source;
    mgCFrame *frame;
    int offset;
    mgCFrame *target;

    for (i = 0; i < argc; i++) {
        if (now_cloth_id >= nowChr->dynamic_anime_num) {
            return 0;
        }
        name = spiGetStackString(stack++);
        if (name != 0) {
            data = (char *)GetPackFile(pack_file, name, &size);
            if (data != 0) {
                chara = nowChr;
                model_frame = chara->CObjectFrame::frame;
                index = now_cloth_id++;
                chara->dynamic_anime[index].Load(data, size, model_frame, now_stack);
            }
        }
    }
    j = 0;
    offset = 0;
    frame = nowChr->CObjectFrame::frame;
    shadow_frame = (mgCFrame *)nowChr->shadow_frame;
    pairs = &nowChr->shadow_link_num;
    while (j < pairs[0]) {
        source = frame->GetFrame(*(int *)((u8 *)((int **)pairs)[1] + offset));
        if (source != 0) {
            target = shadow_frame->GetFrame(*(int *)((u8 *)((int **)pairs)[2] + offset));
            if (target != 0 && source->parent == NULL && target->parent != NULL) {
                target->DeleteParent();
            }
        }
        offset += 4;
        j++;
    }
    return 1;
}
int _CLOTH_END(SPI_STACK *stack, int argc) {
    return 1;
}
int _POSITION(SPI_STACK *stack, int argc) {
    float x = spiGetStackFloat(stack++);
    float y = spiGetStackFloat(stack++);
    float z = spiGetStackFloat(stack);
    nowChr->SetPosition(x, y, z);
    return 1;
}
int _ROTATION(SPI_STACK *stack, int argc) {
    float x = spiGetStackFloat(stack++);
    float y = spiGetStackFloat(stack++);
    float z = spiGetStackFloat(stack);
    nowChr->SetRotation(x, y, z);
    return 1;
}
int _SE_START(SPI_STACK *stack, int argc) {
    now_se_header = 0;
    nowChr->se_num[now_motion_id] = 0;
    if (argc != 1) {
        return 0;
    }
    nowChr->se_num[now_motion_id] = spiGetStackInt(stack);
    nowChr->se_list[now_motion_id] = (CHRINFO_SE *)operator new[](
        nowChr->se_num[now_motion_id] * 16,
        (u_long128 *)now_stack->Alloc(DynAnimeAlign16Blocks(nowChr->se_num[now_motion_id] * 16) + 2));
    now_se_header = (CHRINFO_SE *)nowChr->se_list[now_motion_id];
    return 1;
}
int _SE(SPI_STACK *stack, int argc) {
    char *name;
    SPI_STACK *arg;
    int se_no;
    int bank;
    float frame;

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
int _SELP(SPI_STACK *stack, int argc) {
    char *name;
    SPI_STACK *arg;
    int se_no;
    int bank;
    float start;
    float end;
    int loop_flag;
    float start_time;
    float end_time;

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
int _SE_END(SPI_STACK *stack, int argc) {
    return 1;
}
int _MOTION_END(SPI_STACK *stack, int argc) {
    return 1;
}
int _EFFECT_START(SPI_STACK *stack, int argc) {
    eff_pack_ptr = (unsigned int *)GetPackFile(pack_file, spiGetStackString(stack), &eff_pack_size);
    return eff_pack_ptr != 0;
}

static int _EFFECT(SPI_STACK *stack, int count) {
    char                   *script;
    CHRINFO_EFFECT         *entry;
    CHARA_EFFECT_MANAGER   *manager;
    CHRINFO_EFFECT         *last;
    unsigned char          *image;
    CHRINFO_EFFECT_IMAGE  **image_entry;
    char                   *file_name;
    char                   *effect_name;
    char                   *frame_name;
    char                   *motion_name;
    sceVu0FVECTOR           offset;
    float                   start_ratio;
    int                     local_draw;
    int                     script_size;
    int                     particle_count;
    int                     emitter_count;
    int                     image_size;
    int                     enter_image;
    int                     index;

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
    script = (char *)GetPackFile(eff_pack_ptr, file_name, &script_size);
    if (script == NULL) {
        return 0;
    }
    entry = (CHRINFO_EFFECT *)now_stack->stAlloc64(3);
    manager = (CHARA_EFFECT_MANAGER *)now_stack->stAlloc64(32);
    manager->Initialize();
    manager->GetBufferNums(script, script_size, &particle_count, &emitter_count);
    manager->particle_pool = (CEffect *)now_stack->Alloc(particle_count * sizeof(CEffect) / 16 + 1);
    for (index = 0; index < particle_count; index++) {
        manager->particle_pool[index].Initialize();
    }
    manager->emitter_pool = (CEffectCtrl *)now_stack->Alloc(emitter_count * sizeof(CEffectCtrl) / 16 + 1);
    for (index = 0; index < emitter_count; index++) {
        manager->emitter_pool[index].Initialize();
    }
    manager->EntryEffCtrls(manager->particle_pool, particle_count, manager->emitter_pool, emitter_count);
    manager->Load(script, script_size);
    if (nowChr->effect_image_load != 0) {
        image = (unsigned char *)GetPackFile(eff_pack_ptr, manager->img_name, &image_size);
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
                *image_entry = (CHRINFO_EFFECT_IMAGE *)now_stack->stAlloc64(40);
                (*image_entry)->next = NULL;
                strcpy((*image_entry)->name, manager->img_name);
                (*image_entry)->data = (unsigned char *)img_stack->Alloc(image_size / 16 + 1);
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
        strcpy(manager->frame_name, at_1571);
    }
    if (motion_name != NULL) {
        strcpy(manager->motion_name, motion_name);
    } else {
        strcpy(manager->motion_name, at_1571);
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
int _EFFECT_END(SPI_STACK *stack, int argc) {
    if (eff_pack_ptr == 0) {
        return 0;
    }
    eff_pack_ptr = 0;
    eff_pack_size = 0;
    return 1;
}

void CCharacter2::InitEffect() {
    int  index;

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
    int i;
    int count;
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

        if (strcmp((char *)node->effect + 0x1BC, (char *)now_key) == 0) {
            entry_effect[count].effect = node->effect;
            entry_effect[count].active = 1;
            count++;
        }
        node = node->next;
    }
}
void CCharacter2::CtrlEffect() {
    for (int i = 0; i < 8; i++) {
        if (entry_effect[i].active == 0)
            continue;
        if (entry_effect[i].running != 0)
            continue;
        CEffectManager *manager = entry_effect[i].effect;
        CHRINFO_KEY_SET *motion = now_key;
        float progress = (frame - (float)motion->start_frame) /
                       ((float)motion->end_frame - (float)motion->start_frame);

        if (progress > *(float *)((u8 *)manager + 0x1DC)) {
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
    CHRINFO_EFFECT  *effect;
    mgCFrame        *effect_frame;
    int              index;

    for (index = 0; index < CHARA_SWORD_EFFECT_MAX; index++) {
        if (sword_effect[index] != NULL) {
            sword_effect[index]->Draw();
        }
    }
    for (effect = effect_list; effect != NULL; effect = effect->next) {
        mgC3DSprite sprite;
        sceVu0FMATRIX world_matrix;
        sceVu0FVECTOR world_position;
        mgUnitMatrix(world_matrix);
        world_position[3] = 0.0f;
        world_position[2] = 0.0f;
        world_position[1] = 0.0f;
        world_position[0] = 0.0f;
        if (strcmp(effect->effect->frame_name, at_1571) != 0) {
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
void ScanInfoSkinFile(CCharacter2 *chara, u32 *pack_file, char *info_name, char *skin_name,
                      mgCMemory *memory, int texture_block) {
    CScriptInterpreter interp;
    int size;
    char *script;

    base_stack = memory;
    ::pack_file = pack_file;
    set_imgblock = texture_block;
    nowChr = chara;
    skin_name_ptr = skin_name;
    root_skin_frame = 0;
    skin_frame = 0;
    script = (char *)GetPackFile(pack_file, info_name, &size);
    if (script == NULL) {
        printf(at_1395, info_name);
        return;
    }
    interp.SetTag((SPI_TAG_PARAM *)skin_tag);
    interp.SetScript(script, size);
    interp.Run();
}
int _SKIN_IMG(SPI_STACK *stack, int argc) {
    SPI_STACK *name = stack + 1;

    if (base_stack == 0) {
        return 0;
    }
    spiGetStackInt(stack);
    load_img_ptr = (unsigned char *)GetPackFile(pack_file, spiGetStackString(name), &load_img_size);
    return load_img_ptr != 0;
}
int _SKIN_IMG_END(SPI_STACK *stack, int argc) {
    return 1;
}
int _SKIN_MODEL(SPI_STACK *stack, int argc) {
    char *name;

    if (argc != 1) {
        return 0;
    }
    name = spiGetStackString(stack);
    if (GetPackFile(pack_file, name, NULL) == 0) {
        printf(at_1395, name);
        return 0;
    }
    strcpy(skin_mds_name, name);
    return 1;
}
mgCFrame *CreateChangeFrame(mgLoadData *data, mgCFrame *target) {
    mgCFrame *source = (mgCFrame *)mgLoadMDSFile(data);
    char **name;
    int target_id;
    mgCVisual *motion;
    mgCFrame **frame_list;
    float(*matrix)[4][4];
    int offset;
    mgCreateVisualType *list;
    mgCFrame *found;
    mgCreateVisualType *entry;
    int source_id;

    if (source == 0) {
        return 0;
    }
    list = data->visual_type;
    offset = 0;
    for (;;) {
        entry = (mgCreateVisualType *)((u8 *)list + offset);
        if (entry->type == -1) {
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
                        memcpy(matrix[target_id], data->matrix[source_id], 0x40);
                    }
                    ((mgCVisualMotionMDT *)motion)->ChangeWeight(frame_list, matrix, target_id);
                }
            }
        }
        offset += 8;
    }
    return source;
}

#ifdef NONMATCHING

static int _SKIN_MOTION(SPI_STACK *stack, int count) {
    mgCMemory           work_memory;
    mgCreateVisualType  visual_type[64];
    mgIMG_HEADER        image_header;
    mgLoadData          load;
    u_long128           work_buffer[6400];
    sceVu0FVECTOR       box_max;
    sceVu0FVECTOR       box_min;
    mgCFrame           *root;
    mgCFrame           *source_frame;
    mgCFrame           *dest_frame;
    mgCVisualMDT       *visual;
    char               *matrix_name;
    char               *weight_name;
    unsigned char      *weight_file;
    unsigned char      *matrix_file;
    unsigned char      *model_file;
    unsigned char      *image;
    char              **group_names;
    int                 index;
    int                 visual_count;
    int                 deform_index;
    int                 image_count;

    if (nowChr->CObjectFrame::frame == NULL) {
        return 0;
    }
    now_motion_id = spiGetStackInt(stack++);
    spiGetStackString(stack++);
    matrix_name = spiGetStackString(stack++);
    weight_name = spiGetStackString(stack++);
    weight_file = (unsigned char *)GetPackFile(pack_file, weight_name, NULL);
    matrix_file = (unsigned char *)GetPackFile(pack_file, matrix_name, NULL);
    if (weight_file == NULL) {
        printf("not found %s\n", weight_name);
        return 0;
    }
    if (nowChr->shape_anime == 0) {
        model_file = (unsigned char *)GetPackFile(pack_file, skin_mds_name, NULL);
        visual_count = 0;
        deform_index = 0;
        for (index = 0; index < nowChr->deform_frame_num; index++) {
            if (nowChr->deform_frame[deform_index] != NULL) {
                visual_type[visual_count].type = MG_VISUAL_CREATE_MOTION_MDT;
                visual_type[visual_count].name = nowChr->deform_frame[deform_index]->name;
                visual_count++;
                deform_index++;
            }
        }
        visual_type[visual_count].type = MG_VISUAL_CREATE_END;
        visual_type[visual_count].name = NULL;
        if (load_img_ptr != NULL) {
            image = (unsigned char *)base_stack->stAlloc64(load_img_size / 16 + 1);
            memcpy(image, load_img_ptr, load_img_size);
            image_count = mgGetIMGHeaderNum((char *)image);
            for (index = 0; index < image_count; index++) {
                image_header = mgGetIMGHeader((char *)image, index);
                mgTexManager.DeleteTexture(image_header.name, set_imgblock);
            }
            mgTexManager.EnterIMGFile(image, set_imgblock, base_stack, NULL);
            group_names = mgTexManager.GetGroupNameList(set_imgblock, &nowChr->tex_anime_group_num);
            if (group_names != NULL) {
                nowChr->tex_anime_group_start = 0;
                while (group_names[nowChr->tex_anime_group_start] != NULL) {
                    nowChr->tex_anime_group_start++;
                }
            }
        }
        memset(&load, 0, sizeof(load));

        work_memory.stSetBuffer(work_buffer, 6400);
        load.mds = (MDS_HEADER *)model_file;
        load.weight = (unsigned int *)weight_file;
        load.work_memory = &work_memory;
        load.matrix = (float (*)[4][4])matrix_file;
        load.visual_type = visual_type;
        load.memory = base_stack;
        root_skin_frame = CreateChangeFrame(&load, nowChr->CObjectFrame::frame);
        if (root_skin_frame == NULL) {
            return 0;
        }
        root = nowChr->CObjectFrame::frame;
        for (index = 0; index < root_skin_frame->frame_num; index++) {
            source_frame = root_skin_frame->frame_list[index];
            if (source_frame != NULL && source_frame->visual != NULL) {
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
                visual = (mgCVisualMDT *)skin_frame->visual;
                ChangeWeight(nowChr->motion[0].skin_list, base_stack, weight_file, root->SearchFrameID(skin_name_ptr), nowChr->motion[0].frame_info, visual, root, root_skin_frame);
                dest_frame = root->SearchFrame(skin_name_ptr);
                if (dest_frame != NULL) {
                    dest_frame->SetVisual(visual);
                }
            }
        }
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", _SKIN_MOTION__FP9SPI_STACKi);
#endif
int _LOD_MODEL_START(SPI_STACK *stack, int argc) {
    int count = spiGetStackInt(stack);
    if (count <= 0) {
        return 0;
    }
    void *block = (void *)base_stack->Alloc(DynAnimeAlign16Blocks((u32)count * 0x18) + 2);
    nowChr->lod = new ((u_long128 *)block) CCharaLOD[count];
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

static int _LOD_MODEL(SPI_STACK *stack, int count) {
    mgCreateVisualType  visual_type[64];
    mgLoadData          load;
    u_long128           work_buffer[6400];
    CCharaLOD          *level;
    int                 index;
    mgCFrame           *source_frame;
    char               *model_name;
    MDS_HEADER         *model_file;
    unsigned int       *weight_file;
    int               (*link)[2];
    float             (*matrix_file)[4][4];
    int                 frame_index;
    int                 frame_count;
    int                 visual_count;
    mgCFrame           *root;
    mgCFrame          **frame_list;
    char               *weight_name;
    char               *matrix_name;
    int                 level_index;
    int                 deform_index;
    int                 quadwords;

    level_index = spiGetStackInt(stack++);
    if (level_index < 0 || level_index >= nowChr->lod_num) {
        return 0;
    }
    level = &nowChr->lod[level_index];
    model_name = spiGetStackString(stack++);
    weight_name = spiGetStackString(stack++);
    matrix_name = spiGetStackString(stack++);
    level->distance = spiGetStackFloat(stack++);
    model_file = (MDS_HEADER *)GetPackFile(pack_file, model_name, NULL);
    weight_file = (unsigned int *)GetPackFile(pack_file, weight_name, NULL);
    matrix_file = (float (*)[4][4])GetPackFile(pack_file, matrix_name, NULL);
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
int _LOD_MODEL_END(SPI_STACK *stack, int argc) {
    nowChr->lod_no = -1;
    return 1;
}
mgCFrame *CCharacter2::ChangeLOD(int index) {
    CCharaLOD *lod;
    mgCFrame *root;
    mgCFrame *lod_frame;
    mgCFrame **root_frames;
    int (*pair)[2];
    int i;
    mgCFrame *target;
    mgCFrame *source;
    mgCVisual *motion;
    float box_min[4];
    float box_max[4];

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
                    ((mgCVisualMotionMDT *)motion)->frame = root_frames;
                }
                target->SetVisual(motion);
                source->GetBBox(box_min, box_max);
                target->SetBBox(box_min, box_max);
            }
        }
    }
    return 0;
}

#ifdef NONMATCHING
void CCharacter2::Copy(CCharacter2 &dest, mgCMemory *memory) {
    COutLineDraw *source_outline;
    COutLineDraw *dest_outline;
    CHRINFO_SE   *sounds;
    int           free_space;
    int           quadwords;
    int           index;
    int           component;
    int           row;

    free_space = memory->stack_size - memory->stack_used;
    (CObject &)dest = *this;
    dest.CObjectFrame::frame = CObjectFrame::frame;
    for (component = 0; component < 4; component++) {
        dest.velocity[component] = velocity[component];
        dest.base_scale[component] = base_scale[component];
    }
    dest.move_accel = move_accel;
    for (row = 0; row < 4; row++) {
        for (component = 0; component < 4; component++) {
            dest.entry_matrix[row][component] = entry_matrix[row][component];
        }
    }
    for (index = 0; index < 16; index++) {
        dest.name[index] = name[index];
    }
    dest.alpha = alpha;
    dest.poly_num[0] = poly_num[0];
    dest.poly_num[1] = poly_num[1];
    dest.body_width = body_width;
    dest.body_height = body_height;
    dest.body_depth = body_depth;
    dest.load_size = load_size;
    dest.copy_size = copy_size;
    dest.dynamic_anime_flags = dynamic_anime_flags;
    dest.outline = outline;
    dest.outline_tex_no = outline_tex_no;
    dest.dynamic_anime_num = dynamic_anime_num;
    dest.dynamic_anime = dynamic_anime;
    dest.shape_anime = shape_anime;
    for (index = 0; index < CHARA_ENTRY_FRAME_MAX; index++) {
        dest.entry_frame[index] = entry_frame[index];
    }
    for (index = 0; index < CHARA_ENTRY_OBJECT_MAX; index++) {
        dest.entry_object[index] = entry_object[index];
    }
    dest.shadow_frame = shadow_frame;
    for (index = 0; index < CHARA_IMAGE_MAX; index++) {
        dest.images[index] = images[index];
    }
    dest.tex_anime_group_num = tex_anime_group_num;
    dest.tex_anime_group_start = tex_anime_group_start;
    dest.texture_block = texture_block;
    for (index = 0; index < CHARA_DEFORM_FRAME_MAX; index++) {
        dest.deform_frame[index] = deform_frame[index];
    }
    dest.deform_frame_num = deform_frame_num;
    dest.lod_num = lod_num;
    dest.lod = lod;
    dest.lod_no = lod_no;
    dest.motion_enable = motion_enable;
    dest.shadow_link_num = shadow_link_num;
    dest.shadow_link_model = shadow_link_model;
    dest.shadow_link_shadow = shadow_link_shadow;
    dest.next_key = next_key;
    dest.next_flags = next_flags;
    dest.next_set = next_set;
    dest.now_key = now_key;
    dest.seq_mode = seq_mode;
    dest.now_flags = now_flags;
    dest.now_set = now_set;
    dest.motion_status = motion_status;
    dest.frame = frame;
    dest.frame_ratio = frame_ratio;
    dest.step = step;
    dest.posed_key = posed_key;
    dest.prev_flags = prev_flags;
    dest.prev_set = prev_set;
    dest.prev_frame = prev_frame;
    dest.next_seq = next_seq;
    dest.now_seq = now_seq;
    dest.seq_step = seq_step;
    dest.seq_flags = seq_flags;
    dest.seq_loop = seq_loop;
    dest.seq_state = seq_state;
    dest.seq_advance = seq_advance;
    for (index = 0; index < CHARA_MOTION_SET_MAX; index++) {
        dest.motion[index] = motion[index];
        dest.shadow_motion[index] = shadow_motion[index];
    }
    dest.unk_500 = unk_500;
    dest.shadow_frame_info = shadow_frame_info;
    dest.blend = blend;
    dest.blend_speed = blend_speed;
    for (index = 0; index < CHARA_MOTION_SET_MAX; index++) {
        dest.key_list[index] = key_list[index];
        dest.key_num[index] = key_num[index];
        dest.seq_list[index] = seq_list[index];
    }
    for (index = 0; index < CHARA_SWORD_EFFECT_MAX; index++) {
        dest.sword_effect[index] = sword_effect[index];
    }
    dest.foot_se_bank = foot_se_bank;
    dest.foot_sound_id = foot_sound_id;
    dest.foot_sound_enable = foot_sound_enable;
    dest.se_bank = se_bank;
    dest.se_bank_2 = se_bank_2;
    dest.se_positional = se_positional;
    dest.se_volume = se_volume;
    dest.se_pan = se_pan;
    dest.foot_effect_wait = foot_effect_wait;
    dest.loop_se = loop_se;
    for (index = 0; index < CHARA_MOTION_SET_MAX; index++) {
        dest.se_list[index] = se_list[index];
        dest.se_num[index] = se_num[index];
    }
    dest.effect_image_load = effect_image_load;
    dest.effect_list = effect_list;
    for (index = 0; index < CHARA_ENTRY_EFFECT_MAX; index++) {
        dest.entry_effect[index] = entry_effect[index];
    }
    dest.effect_image_list = effect_image_list;
    dest.effect_enable = effect_enable;
    if (memory != NULL) {
        dest.CObjectFrame::frame = mgCopyFrame(CObjectFrame::frame, memory, 1);
        if (dest.CObjectFrame::frame != NULL) {
            dest.shadow_frame = shadow_frame;
            if (outline_tex_no > 0 && outline != NULL) {
                dest.outline = NULL;
                dest.outline_tex_no = 0;
                for (source_outline = outline; source_outline != NULL; source_outline = source_outline->next) {
                    dest_outline = new (memory->Alloc(9)) COutLineDraw;
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
                quadwords = (dynamic_anime_num * sizeof(CDynamicAnime) + 15) / 16;
                dest.dynamic_anime = new (memory->Alloc(quadwords + 2)) CDynamicAnime[dynamic_anime_num];
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
                    dest.entry_object[index].unk_04 = entry_object[index].unk_04;
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
                quadwords = (lod_num * sizeof(CCharaLOD) + 15) / 16;
                dest.lod = new (memory->Alloc(quadwords + 2)) CCharaLOD[lod_num];
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
            for (index = 0; index < CHARA_SWORD_EFFECT_MAX; index++) {
                if (sword_effect[index] != NULL) {
                    dest.sword_effect[index] = new (memory->Alloc(12)) CSWordAfterEffect;
                    sword_effect[index]->Copy(*dest.sword_effect[index], memory);
                }
            }
            copy_size = free_space - (memory->stack_size - memory->stack_used);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", Copy__11CCharacter2FR11CCharacter2P9mgCMemory);
#endif


extern "C" CObject &__as__7CObjectFRC7CObject(CObject *destination, const CObject *source) {
    *destination = *source;
    return *destination;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", skin_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_1575__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_281__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_282__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_283__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_284__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_285__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_286__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_287__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_288__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_289__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_290__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_291__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_292__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_293__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_294__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_295__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_296__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_297__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_298__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_299__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_300__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_301__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_302__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_303__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_304__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_305__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_306__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_307__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_308__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_309__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_310__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_311__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_312__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_313__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_314__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_315__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_316__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_317__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_318__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_319__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_1395__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_1522__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_1570__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", at_1571__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/character", __vt__11CCharacter2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(root_skin_frame, 0x4);
INCLUDE_BSS(skin_frame, 0x4);
INCLUDE_BSS(skin_name_ptr, 0x4);
INCLUDE_BSS(nowChr, 0x4);
INCLUDE_BSS(parent_chr, 0x4);
INCLUDE_BSS(outline_flag, 0x4);
INCLUDE_BSS(now_motion_id, 0x4);
INCLUDE_BSS(now_key_ptr, 0x4);
INCLUDE_BSS(now_seqhd_ptr, 0x4);
INCLUDE_BSS(now_seq_ptr, 0x4);
INCLUDE_BSS(now_cloth_id, 0x4);
INCLUDE_BSS(outline_start, 0x4);
INCLUDE_BSS(outline_start_tex, 0x4);
INCLUDE_BSS(outline_tex_id, 0x4);
INCLUDE_BSS(alloc_vertex_num, 0x4);
INCLUDE_BSS(alloc_shadow_vertex_num, 0x4);
INCLUDE_BSS(base_stack, 0x4);
INCLUDE_BSS(ext_stack, 0x4);
INCLUDE_BSS(img_stack, 0x4);
INCLUDE_BSS(now_stack, 0x4);
INCLUDE_BSS(set_imgblock, 0x4);
INCLUDE_BSS(pack_file, 0x4);
INCLUDE_BSS(outline_num_1499, 0x4);
INCLUDE_BSS(init_1500, 0x4);
INCLUDE_BSS(now_se_header, 0x4);
INCLUDE_BSS(eff_pack_ptr, 0x4);
INCLUDE_BSS(eff_pack_size, 0x4);
INCLUDE_BSS(load_img_ptr, 0x4);
INCLUDE_BSS(load_img_size, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(alloc_vertex, 0x190);
INCLUDE_BSS(img_ptr, 0x20);
INCLUDE_BSS(skin_mds_name, 0x40);
