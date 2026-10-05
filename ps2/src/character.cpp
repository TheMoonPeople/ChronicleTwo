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
extern int root_skin_frame;
extern int skin_frame;
extern SPI_TAG_PARAM skin_tag[];
extern char skin_mds_name[64];
extern char *load_img_ptr;
extern int load_img_size;
extern mgCMemory *img_stack;
extern void *img_ptr[CHARA_IMAGE_MAX];
extern int outline_tex_id;
extern mgCMemory *now_stack;
extern CHRINFO_SEQ *now_seq_ptr;
extern CHRINFO_SEQ_HEADER *now_seqhd_ptr;
extern char *eff_pack_ptr;
extern int eff_pack_size;
extern mgCTextureManager mgTexManager;
extern int alloc_vertex_num;
extern char alloc_vertex[24][16];
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
extern CHRINFO_SE *now_se_header;
extern mgCreateVisualType at_1575[2];
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
int ScanInfoSkinFile(CCharacter2 *chara, u32 *pack_file, char *info_name, char *skin_name,
                      mgCMemory *memory, int texture_block);
int _SKIN_IMG(SPI_STACK *stack, int argc);
int _SKIN_IMG_END(SPI_STACK *stack, int argc);
int _SKIN_MODEL(SPI_STACK *stack, int argc);
int _LOD_MODEL_START(SPI_STACK *stack, int argc);
int _LOD_MODEL_END(SPI_STACK *stack, int argc);

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
            if (target->reference != 0) {
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
    enabled = other->outline->texture != NULL;
    if (enabled == 0) {
        return;
    }
    for (line = outline; line != NULL; line = line->next) {
        line->texture = other->outline->texture;
    }
}
int CCharacter2::Draw() {
    float step_alpha;
    float world_pos[4];
    float alpha;
    int count;
    int i;

    if (CheckDraw() == 0) {
        return 0;
    }
    alpha = this->alpha;
    if (FarClip(mgGetDistFromCamera(position), &step_alpha) == 0) {
        return 0;
    }
    alpha *= step_alpha;
    if (CObjectFrame::frame != NULL) {
        CObjectFrame::frame->SetPosition(position);
        CObjectFrame::frame->SetRotation(rotation);
        CObjectFrame::frame->SetScale(scale);
        CObjectFrame::frame->GetWorldPosition0(world_pos);
    }
    SetDeformMesh();
    count = 0;
    if (CObjectFrame::frame != NULL) {
        CObjectFrame::frame->SetAttrParamObjAlpha(alpha, 1);
    }
    count += mgDraw(CObjectFrame::frame);
    for (i = 0; i < dynamic_anime_num; i++) {
        count += dynamic_anime[i].DrawSub(0);
    }
    return count;
}
void CCharacter2::SetDeformMesh() {
    float box_min[4];
    float box_max[4];
    int i;

    for (i = 0; i < deform_frame_num; i++) {
        if (deform_frame[i] != NULL) {
            deform_frame[i]->RemakeBBox(box_min, box_max);
        }
    }
}
void CCharacter2::DrawStep() {
    float step_alpha;

    FarClip(GetCameraDist(), &step_alpha);
}
float CCharacter2::GetCameraDist() {
    float height;
    float top[4];
    float camera[4];
    float nearest[4];

    height = body_height;
    if (height < 1.0f) {
        height = 34.0f;
    }
    u_long128 q = *(u_long128 *)position;
    *(u_long128 *)top = q;
    top[1] += height;
    mgGetCameraPos(camera);
    return mgDistLinePoint(camera, position, top, nearest);
}
int CCharacter2::DrawDirect() {
    float world_pos[4];
    COutLineDraw lod_line;
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
        lod_line = *line;
        lod_line.next = NULL;
        lod_line.SetFrame(lod_frame);
        line = &lod_line;
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
    int list_no;

    if (show == 0) {
        return 0;
    }
    if (CheckDraw() == 0) {
        return 0;
    }
    if (shadow_frame == NULL) {
        return 0;
    }
    ShadowStep();
    shadow_frame->SetPosition(position);
    shadow_frame->SetRotation(rotation);
    shadow_frame->SetScale(scale);
    list_no = now_set;
    if (list_no >= 0 && list_no < 8) {
        DeformMesh(shadow_frame, &shadow_motion[list_no], shadow_frame_info, false);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", ResetDAPosition__11CCharacter2Fv);
float CCharacter2::GetDefaultStep() {
    CHRINFO_KEY_SET *motion = now_key;
    if (motion != NULL)
        return motion->step;
    return 0.0f;
}
void CCharacter2::SetStep(float new_step) {
    step = new_step;
}
void CCharacter2::ResetMotion() {
    now_key = NULL;
    next_key = NULL;
    now_seq = 0;
    next_seq = 0;
}
float CCharacter2::GetChgStepWait() {
    if (motion_status != 3) {
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
void CCharacter2::SetMotion(int motion_no, int param) {
    int index;
    CHRINFO_KEY_SET *motion;

    motion = GetKeyListIndexPtr(motion_no, &index);
    if (motion != NULL) {
        next_key = motion;
        next_flags = param;
        next_set = index;
        *(int *)&blend_speed = 0x3E4CCCCD;
        seq_mode = 0;
        now_seq = 0;
        seq_state = 0;
    }
}
void CCharacter2::SetMotion(char *name, int param) {
    SetMotionPara(name, param, -1);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", SetMotionPara__11CCharacter2FPcii);
void CCharacter2::SetDAnimeEnable(int enable) {
    if (enable != 0)
        dynamic_anime_flags = dynamic_anime_flags & ~1;
    else
        dynamic_anime_flags = dynamic_anime_flags | 1;
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
        sndGetVolPan(&se_volume, &se_pan, pos, near_dist, far_dist);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", StepDA__11CCharacter2Fi);
void CCharacter2::SetWind(float power, float *dir) {
    int i;

    for (i = 0; i < dynamic_anime_num; i++) {
        dynamic_anime[i].SetWind(power, dir);
    }
}
void CCharacter2::ResetWind() {
    int i;

    for (i = 0; i < dynamic_anime_num; i++) {
        dynamic_anime[i].ResetWind();
    }
}
void CCharacter2::SetFloor(float height) {
    int i;

    for (i = 0; i < dynamic_anime_num; i++) {
        dynamic_anime[i].SetFloor(height);
    }
}
void CCharacter2::ResetFloor() {
    int i;

    for (i = 0; i < dynamic_anime_num; i++) {
        dynamic_anime[i].ResetFloor();
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", NormalDrive__11CCharacter2Fv);
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
                    sceVu0CopyMatrix(matrix, source->lw_matrix);
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
            SetMotionPara(first->name, 4, 0);
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
                if (image->name[0] != '#') {
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

            if (image->name[0] != '#') {
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
int CCharacter2::LoadSkin(u32 *pack_file, char *info_name, char *skin_name, mgCMemory *memory,
                           int texture_block) {
    return ScanInfoSkinFile(this, pack_file, info_name, skin_name, memory, texture_block);
}
void CCharacter2::LoadPack(u32 *pack_file, char *name, mgCMemory *a, mgCMemory *b, mgCMemory *c,
                           int d, CCharacter2 *e) {
    LoadChrFile(pack_file, name, a, b, c, d, e, 1);
}
void CCharacter2::LoadPackNoLine(u32 *pack_file, char *name, mgCMemory *a, mgCMemory *b,
                                 mgCMemory *c, int d, CCharacter2 *e) {
    LoadChrFile(pack_file, name, a, b, c, d, e, 0);
}
void CCharacter2::LoadChrFile(u32 *pack_file, char *name, mgCMemory *a, mgCMemory *b, mgCMemory *c,
                              int d, CCharacter2 *e, int with_line) {
    CHRINFO_KEY_SET *had_motion = GetKeyListIndexPtr(0, 0);
    ScanInfoFile(this, pack_file, name, a, b, c, d, e, with_line);
    if (had_motion == 0) {
        CHRINFO_KEY_SET *first = GetKeyListIndexPtr(0, 0);
        if (first != 0) {
            SetMotionPara(first->name, 4, 0);
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
    img_ptr[index] = img_stack->stAlloc64(size / 16 + 1);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", _MODEL__FP9SPI_STACKi);
int _SHADOW_MODEL(SPI_STACK *stack, int argc) {
    mgCreateVisualType visual_type[2];
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

    memcpy(visual_type, at_1575, sizeof(visual_type));
    name = spiGetStackString(stack);
    pack = (char *)GetPackFile(pack_file, name, 0);
    if (pack == 0) {
        printf(at_1395, name);
        return 0;
    }
    nowChr->shadow_frame =
        mgLoadMDSFile(
            (MDS_HEADER *)pack, base_stack, visual_type, 0);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", _SEQ_START__FP9SPI_STACKi);
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
            if (target != 0 && source->reference == 0 && target->reference != 0) {
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
    eff_pack_ptr = (char *)GetPackFile(pack_file, spiGetStackString(stack), &eff_pack_size);
    return eff_pack_ptr != 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", _EFFECT__FP9SPI_STACKi);
int _EFFECT_END(SPI_STACK *stack, int argc) {
    if (eff_pack_ptr == 0) {
        return 0;
    }
    eff_pack_ptr = 0;
    eff_pack_size = 0;
    return 1;
}
void CCharacter2::InitEffect() {
    for (int i = 0; i < 8; i++) {
        entry_effect[i].effect = 0;
        entry_effect[i].active = 0;
        entry_effect[i].running = 0;
    }
    effect_list = 0;
    effect_enable = 1;
    effect_image_list = 0;
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
    for (int i = 0; i < 3; i++) {
        if (sword_effect[i] != NULL) {
            sword_effect[i]->Step();
            sword_effect[i]->CreatPointList();
        }
    }
    CHRINFO_EFFECT *node = effect_list;
    while (node != NULL) {
        node->effect->Ctrl();
        node->effect->Step(1);
        node = node->next;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", DrawEffect__11CCharacter2Fv);
int ScanInfoSkinFile(CCharacter2 *chara, u32 *pack_file, char *info_name, char *skin_name,
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
        return 0;
    }
    interp.SetTag((SPI_TAG_PARAM *)skin_tag);
    interp.SetScript(script, size);
    interp.Run();
    return 1;
}
int _SKIN_IMG(SPI_STACK *stack, int argc) {
    SPI_STACK *name = stack + 1;

    if (base_stack == 0) {
        return 0;
    }
    spiGetStackInt(stack);
    load_img_ptr = (char *)GetPackFile(pack_file, spiGetStackString(name), &load_img_size);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", _SKIN_MOTION__FP9SPI_STACKi);
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
CCharaLOD::CCharaLOD(void) {
    link_num = 0;
    link = 0;
    frame = 0;
    distance = 0;
    standalone = 0;
    motion = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", _LOD_MODEL__FP9SPI_STACKi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/character", Copy__11CCharacter2FR11CCharacter2P9mgCMemory);

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

CObject &CObject::operator=(const CObject &other) {
    *(u_long128 *)position = *(const u_long128 *)other.position;
    *(u_long128 *)rotation = *(const u_long128 *)other.rotation;
    *(u_long128 *)scale = *(const u_long128 *)other.scale;
    changed = other.changed;
    use_srt = other.use_srt;
    far_dist = other.far_dist;
    fade = other.fade;
    fade_alpha = other.fade_alpha;
    fade_speed = other.fade_speed;
    near_dist = other.near_dist;
    show = other.show;
    draw_off = other.draw_off;
    return *this;
}
