#include <cstring>
#include "object.hpp"
#include "mglib.hpp"
#include "mg_math.hpp"
#include "common.h"
#include "character.hpp"
#include "collision.hpp"
#include "funcpoint.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mdslist.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "occlusion.hpp"
#include "mapparts.hpp"

struct SphereVec { float v[3]; float w; };
extern char at_244[];

// Code (.text)
void CMapParts::Initialize(void) {
    int i;

    piece_list = NULL;
    name[0] = 0;
    parts_name[0] = 0;
    frame.Initialize();
    in_screen = 1;
    lod_num = 0;
    unk_1dc = 0;
    lod_dist = NULL;
    lod_blend = 0;
    color_num = 4;
    func_point_mngr.Initialize();
    func_check.time = 0;
    no_plight = 0;
    no_light = 0;
    group_no = -1;
    move_flag = 0;
    anime_list = NULL;
    bound_valid = 0;
    mgZeroVectorW(bound_box.max);
    mgZeroVectorW(bound_box.min);
    mgZeroVector(bound_sphere);
    for (i = 0; i < color_num; i++) {
        mgZeroVector(color[i]);
    }
    col_bound_valid = 0;
    mgZeroVectorW(col_bound_box.max);
    mgZeroVectorW(col_bound_box.min);
    mgZeroVector(col_bound_sphere);
    need_step = 0;
    fixed_time = -1.0f;
    CObject::Initialize();
}
void CMapParts::SetName(char *newName) {
    if (newName == NULL || (u32)strlen(newName) > 0x1F) {
        return;
    }
    strcpy(name, newName);
}
void CMapParts::SetPartsName(char *newName) {
    if (newName == NULL || (u32)strlen(newName) > 0x1F) {
        return;
    }
    strcpy(parts_name, newName);
}
void CMapParts::AddPiece(CList<CMapPiece> *node) {
    if (node == NULL) {
        return;
    }
    if (node->data.type & 4) {
        need_step = 1;
    }
    CList<CMapPiece> *last = piece_list;
    if (last == NULL) {
        piece_list = node;
        return;
    }
    CList<CMapPiece> *next;
    if (last != NULL) {
        do {
            next = last->next;
            if (next == NULL)
                break;
            last = next;
        } while (next);
    }
    last->next = node;
    if (node != NULL) {
        node->prev = last;
    }
}
CMapPiece *CMapParts::SearchPiece(char *pieceName) {
    CMapPiece *piece;
    CList<CMapPiece> *node = piece_list;
    if (node == NULL || pieceName == NULL) {
        return NULL;
    }
    for (; node != NULL; node = node->next) {
        piece = &node->data;
        if (strcmp(pieceName, piece->name) == 0) {
            return piece;
        }
    }
    return NULL;
}
CMapPiece *CMapParts::SearchPieceColType(int colType) {
    CList<CMapPiece> *node = piece_list;
    if (node == NULL || name == NULL) {
        return NULL;
    }
    while (node != NULL) {
        CMapPiece *piece = &node->data;
        if (piece->col_type == colType) {
            return piece;
        }
        node = node->next;
    }
    return NULL;
}
int CMapParts::GetPoly(int kind, CCPoly *poly, mgVu0FBOX &box, int max) {
    CList<CMapPiece> *node;
    int total;
    CMapPiece *piece;
    mgCFrame *pieceFrame;
    int found;

    if (this->GetShow() == 0) {
        return 0;
    }
    node = piece_list;
    this->UpDatePosition();
    total = 0;
    if (node != NULL) {
        do {
            piece = &node->data;
            if (piece != NULL) {
                pieceFrame = piece->frame;
                if (pieceFrame != NULL) {
                    if (pieceFrame->parent == 0) {
                        pieceFrame->SetReference(&frame);
                        found = piece->GetPoly(kind, poly, box, max);
                        poly += found;
                        max -= found;
                        total += found;
                        pieceFrame->DeleteReference();
                        if (max <= 0) {
                            break;
                        }
                    }
                }
            }
            node = node->next;
        } while (node != NULL);
    }
    return total;
}
int CMapParts::GetColPoly(CCPoly *poly, mgVu0FBOX &box, int max) {
    return GetPoly(1, poly, box, max);
}
int CMapParts::GetCameraPoly(CCPoly *poly, mgVu0FBOX &box, int max) {
    return GetPoly(3, poly, box, max);
}
void CMapParts::UpDatePosition(void) {
    if (changed != 0) {
        frame.SetPosition(position);
        frame.SetRotation(rotation);
        frame.SetScale(scale);
        changed = 0;
    }
}
int CMapParts::SetColor(int index, float *color) {
    if (index < 0 || index >= color_num) {
        return 0;
    }
    *(u_long128 *)this->color[index] = *(u_long128 *)color;
    this->color[index][3] = 1.0f;
    return 1;
}
int CMapParts::GetColor(int index, float *color) {
    if (index < 0 || index >= color_num) {
        return 0;
    }
    *(u_long128 *)color = *(u_long128 *)this->color[index];
    return 1;
}
int CMapParts::GetDefColor(int id, float *outColor) {
    CList<CMapPiece> *node;
    int i;
    CMapPiece *piece;
    int materialCount;
    PieceMaterial *material;
    if (id < 0 || id >= color_num) {
        return 0;
    }
    for (node = piece_list; node != NULL; node = node->next) {
        piece = &node->data;
        materialCount = piece->material_num;
        for (i = 0; i < materialCount; i++) {
            material = piece->GetMaterial(i);
            if (material != NULL && material->material != 0 && id == material->unk_c) {
                sceVu0CopyVector(outColor, material->color);
                return 1;
            }
        }
    }
    return 0;
}
void CMapParts::UpdateColor(void) {
    int id;
    CList<CMapPiece> *node;
    int j;
    CMapPiece *piece;
    int materialCount;
    PieceMaterial *material;
    for (id = 0; id < color_num; id++) {
        node = piece_list;
        if (color[id][3] > 0.0f) {
            for (; node != NULL; node = node->next) {
                piece = &node->data;
                materialCount = piece->material_num;
                for (j = 0; j < materialCount; j++) {
                    material = piece->GetMaterial(j);
                    if (material != NULL && material->material != 0 && id == material->unk_c) {
                        sceVu0CopyVectorXYZ(material->color, color[id]);
                    }
                }
            }
        }
    }
}
int CMapParts::PreDraw(void) {
    float level;

    if (CObject::PreDraw() == 0) {
        return 0;
    }
    this->UpDatePosition();
    return this->FarClip(mgGetDistFromCamera(position), &level);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapparts", DrawSub__9CMapPartsFi);

void CMapParts::DrawStep(void) {
    CList<CMapPiece> *node;
    CMapPiece *piece;

    this->UpDatePosition();
    CObject::DrawStep();
    node = piece_list;
    if (node != NULL) {
        do {
            piece = &node->data;
            piece->UpDatePosition();
            piece->DrawStep();
            node = node->next;
        } while (node != NULL);
    }
}
int CMapParts::CreateBoundBox(void) {
    CList<CMapPiece> *node;
    int hasMain = 0;
    int hasShadow = 0;
    int firstMain = 1;
    int firstShadow = 1;
    CMapPiece *piece;
    mgVu0FBOX pieceBox;

    for (node = piece_list; node != NULL; node = node->next) {
        piece = &node->data;
        if (piece != NULL && piece->frame != NULL && piece->GetBoundBox(&pieceBox) != 0) {
            if (piece->type & 1) {
                if (firstShadow != 0) {
                    (col_bound_box = pieceBox);
                    firstShadow = 0;
                } else {
                    mgVectorMaxMin(col_bound_box.max, col_bound_box.min, col_bound_box.max,
                                   col_bound_box.min, pieceBox.max, pieceBox.min);
                }
                hasShadow = 1;
            } else {
                if (firstMain != 0) {
                    (bound_box = pieceBox);
                    firstMain = 0;
                } else {
                    mgVectorMaxMin(bound_box.max, bound_box.min, bound_box.max, bound_box.min, pieceBox.max,
                                   pieceBox.min);
                }
                hasMain = 1;
            }
        }
    }
    sceVu0AddVector(bound_sphere, bound_box.min, bound_box.max);
    sceVu0ScaleVector(bound_sphere, bound_sphere, 0.5f);
    bound_sphere[3] = 0.5f * mgDistVector(bound_box.min, bound_box.max);
    sceVu0AddVector(col_bound_sphere, col_bound_box.min, col_bound_box.max);
    sceVu0ScaleVector(col_bound_sphere, col_bound_sphere, 0.5f);
    col_bound_sphere[3] = 0.5f * mgDistVector(col_bound_box.min, col_bound_box.max);
    bound_valid = hasMain;
    col_bound_valid = hasShadow;
    return hasMain | hasShadow;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapparts", CheckColBox__9CMapPartsFP9mgVu0FBOX);
int CMapParts::GetBBox(mgVu0FBOX *box) {
    int hasBox;

    hasBox = bound_valid;
    if (hasBox == 0) {
        return hasBox;
    }
    (*box = bound_box);
    return bound_valid;
}
int CMapParts::GetBoundBox(mgVu0FBOX *box) {
    float matrix[4][4];
    if (bound_valid == 0) {
        return 0;
    }
    GetLWMatrix(matrix);
    mgApplyMatrix(box->max, box->min, matrix, bound_box.max, bound_box.min);
    return 1;
}
int CMapParts::GetBoundSphere(float *sphere) {
    float matrix[16];
    float sphereCenter[4];
    float radius;

    if (bound_valid == 0) {
        return 0;
    }
    GetLWMatrix((float(*)[4])matrix);
    *(u_long128 *)sphereCenter = *(u_long128 *)bound_sphere;
    radius = bound_sphere[3];
    sphereCenter[3] = 1.0f;
    sceVu0ApplyMatrix(sphere, (float (*)[4])matrix, sphereCenter);
    sphere[3] = radius;
    return bound_valid;
}
void CMapParts::GetLWMatrix(float (*matrix)[4]) {
    this->UpDatePosition();
    frame.GetLWMatrix(matrix);
}
int CMapParts::InsideScreen(void) {
    float matrix[4][4];
    float corner[4];
    float extent[4];

    if (bound_valid == 0) {
        return 0;
    }
    GetLWMatrix(matrix);
    return mgInsideScreen(&bound_box, matrix, corner, extent);
}
int CMapParts::InsideScreen(COcclusion *occluders, int count) {
    float matrix[16];
    SphereVec sphere;
    float radius;
    int i;

    if (bound_valid == 0) {
        return 0;
    }
    GetLWMatrix((float(*)[4])matrix);

    if (mgInsideScreen((mgVu0FBOX *)bound_box.max, (float(*)[4])matrix) == 0) {
        return 0;
    }
    if (count <= 0) {
        return 1;
    }
    mgMulMatrix((float(*)[4])matrix, mgRenderInfo.world_view,
                (float(*)[4])matrix);
    *(u_long128 *)&sphere = *(u_long128 *)bound_sphere;
    radius = bound_sphere[3];
    sphere.w = 1.0f;
    sceVu0ApplyMatrix(&sphere.v[0], (float (*)[4])matrix, &sphere.v[0]);
    sphere.w = radius;
    for (i = 0; i < count; i++) {
        if (occluders->CheckSphere(&sphere.v[0]) != 0) {
            return 0;
        }
        occluders++;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapparts", InScreenFunc__9CMapPartsFP16InScreenFuncInfo);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapparts", DrawScreenFunc__9CMapPartsFP8mgCFrame);
void CMapParts::Step(void) {
    CList<CMapPiece> *node;
    CMapPiece *piece;
    mgCFrame *pieceFrame;

    if (need_step == 0) {
        return;
    }
    node = piece_list;
    if (node != NULL)
        do {
            piece = &node->data;
            pieceFrame = piece->frame;
            if (pieceFrame != NULL) {
                pieceFrame->SetReference(&frame);
                piece->Step();
                pieceFrame->DeleteReference();
            }
            node = node->next;
        } while (node != NULL);
}
void CMapParts::AnimeStep(CFuncPointCheck *check, CObjAnimeEnv *env) {
    CList<CObjAnime> *node;
    void *anime;
    for (node = anime_list; node != NULL; node = node->next) {
        anime = &node->data;
        if (node->data.func_point != NULL) {
            if (node->data.func_point->Check(check)) {
                node->data.Step(env);
            }
        }
    }
}
void CMapParts::StepFuncPoint(CFuncPointCheck &check) {
    CopyFuncPointCheck(check);
    func_point_mngr.UpdateFlag(2, &func_check);
    func_point_mngr.UpdateFlag(3, &func_check);
    func_point_mngr.UpdateFlag(1, &func_check);
    func_point_mngr.Step(4, &func_check);
}
void CMapParts::CopyFuncPointCheck(CFuncPointCheck &source) {
    float override;

    func_check.time = source.time;
    func_check.anime_frame = source.anime_frame;
    override = fixed_time;
    if (!(override < 0.0f)) {
        func_check.time = override;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapparts", Copy__9CMapPartsFR9CMapPartsP9mgCMemory);
int CMapParts::AssignFuncAnime(mgCMemory *memory) { func_point_mngr.GetStart(5); CFuncPoint *point; while ((point = func_point_mngr.Get()) != NULL) { CList<CObjAnime> *node = new (memory->Alloc(7)) CList<CObjAnime>; if (node == NULL) return 0; node->Initialize(); CList<CObjAnime> *last = anime_list; if (last == NULL) anime_list = node; else { while (last->next != NULL) last = last->next; last->next = node; node->prev = last; } node->data.AssignFuncAnime(point, this); } return 1; }
void CMapTreasureBox::Initialize(void) {
    CCharacter2::Initialize();
    active = 0;
    flag_no = 0;
    item_no = -1;
    item_num = 0;
    floor_id = -1;
    func_point = NULL;
    parts = NULL;
}
int CMapTreasureBox::AssignFuncPoint(CFuncPoint *point, CMapParts *ownerParts) {
    if (point == NULL) {
        return 0;
    }
    active = 1;
    flag_no = point->event.flag;
    item_no = point->event.unk_28;
    item_num = point->event.unk_2c;
    if (item_num == 0) {
        item_num = 1;
    }
    floor_id = point->event.unk_30;
    func_point = point;
    parts = ownerParts;
    if (parts != 0) {
        if (CObjectFrame::frame != NULL) {
            CObjectFrame::frame->SetReference(&parts->frame);
        }
    }
    SetPosition(point->position);
    SetRotation(point->rotation);
    UpDatePosition();
    return 1;
}
void CMapTreasureBox::GetWorldPosition(float *out) {
    mgCFrame *chestFrame;

    mgZeroVectorW(out);
    chestFrame = CObjectFrame::frame;
    if (chestFrame != NULL) {
        chestFrame->GetWorldPosition0(out);
    }
}

void CCharacter2::SetPosition(float x, float y, float z) {
    float position[4];

    *(u_long128 *)position = *(u_long128 *)at_244;
    position[0] = x;
    position[1] = y;
    position[2] = z;
    SetPosition(position);
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapparts", at_244__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapparts", __vt__15CMapTreasureBox__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapparts", __vt__17CList_9CObjAnime___DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapparts", __vt__9CMapParts__DATA);

int CMapPiece::DrawDirect() { return DrawSub(1); }
int CMapPiece::Draw() { return DrawSub(0); }
