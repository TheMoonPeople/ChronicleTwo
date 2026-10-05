#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "actionchara.hpp"
#include "scene.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "cameracontrol.hpp"
#include "sphida.hpp"
#include "scenesnd.hpp"
#include "collision.hpp"
#include "intersection.hpp"
#include "automap.hpp"
#include "savedata.hpp"
#include "mainloop.hpp"

extern char at_1088[];
extern char at_1089__2[];
extern char at_1221__5[];
#include <cstring>
#include <cstdio>
#include <cstdlib>

// Code (.text)
GOLF_CLUB_DEF *GetSphidaClubDef(int club) {
    if (club < 9 || club > 14) {
        return 0;
    }
    return &GolfClubDef[club - 9];
}
void DPrimEnterSprite(mgCDrawPrim *prim, int u, int v, int tex_width, int tex_height, float x, float y,
                      float width, float height) {
    float half_height;
    float half_width;

    prim->TextureCrd(u, v);
    half_width = width / 2.0f;
    half_height = height / 2.0f;
    prim->Vertex(x - half_width, y - half_height, 0.0f);
    prim->TextureCrd(u + tex_width, v + tex_height);
    prim->Vertex(x + half_width, y + half_height, 0.0f);
}
void CPowGage::Initialize(void) {
    pos_y = 0.0f;
    pos_x = 0.0f;
    texture = NULL;
    power = 0.0f;
    safe_level = 2;
    code = -10;
    state = -1;
    reverse = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", Step__8CPowGageFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", Draw__8CPowGageFv);
void InitSphida(void) {
    Sphida = 0;
}
CSphida *GetSphidaPtr(void) {
    return Sphida;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", __ct__7CSphidaFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", Initialize__7CSphidaFv);
void CSphida::SetUp(int arg) {
    CMapParts *parts[128];
    float dists[128];
    float chara_pos[4];
    CCPoly polys[128];
    mgVu0FBOX box;
    float from[4];
    float to[4];
    float hit[4];
    CTreasureBoxManager *boxes;
    int count;
    int dng_no;
    CSaveData *save;
    float navi;

    DngMainScene->GetCharacter(DngMainScene->player_chara)->GetPosition(chara_pos);
    boxes = DngMainScene->battle_area.treasure_box;
    SearchMapEventParts(1, parts, dists, 0x80);

    do {
    } while (!SearchMapFlatPosition(this->pin_pos, &AutoMapGen) ||
             !boxes->CheckArea(this->pin_pos, 60.0f) || !RandomCircle.CheckArea(this->pin_pos, 60.0f) ||
             mgDistVector(chara_pos, this->pin_pos) < 60.0f);
    this->pin_pos[1] += 30.0f;

    do {
    } while (
        !SearchMapFlatPosition(this->ball_pos, &AutoMapGen) ||
        !boxes->CheckArea(this->ball_pos, 40.0f) ||

        !RandomCircle.CheckArea(this->pin_pos, 60.0f) ||
        mgDistVector(this->pin_pos, this->ball_pos) < 200.0f);

    box.max[0] = 20.0f + this->ball_pos[0];
    box.min[0] = this->ball_pos[0] - 20.0f;
    box.max[1] = 20.0f + this->ball_pos[1];
    box.min[1] = this->ball_pos[1] - 20.0f;
    box.max[2] = 20.0f + this->ball_pos[2];
    box.min[2] = this->ball_pos[2] - 20.0f;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;

    *(u_long128 *)from = *(u_long128 *)this->ball_pos;
    *(u_long128 *)to = *(u_long128 *)this->ball_pos;
    from[1] += 18.0f;
    to[1] -= 18.0f;
    count = DngMainScene->GetColPoly(polys, box, 0x80);
    if (CheckHit(polys, count, from, to, hit, 1, 0xC) >= 0) {
        *(u_long128 *)this->ball_pos = *(u_long128 *)hit;
    }

    this->ball_pos[1] += 3.0f;
    this->pin_col = (int)(2.0f * (float)rand() / 2147483648.0f);
    this->ball_col = (int)(2.0f * (float)rand() / 2147483648.0f);

    dng_no = -1;
    save = GetSaveData();
    if (save != NULL) {
        int *number = &save->save_dungeon.stage_id;
        if (number != NULL) {
            dng_no = *number;
        }
    }

    switch (dng_no) {
        case 0:
        case 3:
        case 4:
        case 5:
        case 6:
            AutoMapGen.UpdateNaviMap(this->ball_pos, 0x28);
            navi = AutoMapGen.GetNaviDistance(this->pin_pos);
            if (navi < 0.0f) {
                this->par_count = (int)(mgDistVector(this->pin_pos, this->ball_pos) / 600.0f) + 1;
                printf(at_1088, this->par_count);
            } else {
                this->par_count = (int)(navi / 1000.0f) + 1;
                printf(at_1089__2, this->par_count);
            }
            break;
        case 1:
        case 2:
        default:
            this->par_count = (int)(mgDistVector(this->pin_pos, this->ball_pos) / 800.0f) + 1;
            break;
    }

    if (this->par_count > 99) {
        this->par_count = 99;
    }

    if (RedMarkModel != NULL) {
        memcpy(&this->red_mark, RedMarkModel, 0x90);
    }

    this->tex_bank = arg;
    this->InitStatusSprite();
    this->play_flag = 1;
}
void CSphida::s17_SetUp(int arg) {
    this->pin_pos[0] = -1.09f;
    this->pin_pos[1] = 201.0f;
    this->pin_pos[2] = -478.03f;
    this->pin_pos[3] = 1.0f;
    this->ball_pos[0] = 0.0f;
    this->ball_pos[1] = 65.57f;
    this->ball_pos[2] = 1305.04f;
    this->ball_pos[3] = 1.0f;
    this->pin_col = 1;
    this->ball_col = 0;

    this->par_count = (int)(mgDistVector(this->pin_pos, this->ball_pos) / 800.0f) + 1;
    if (this->par_count > 99) {
        this->par_count = 99;
    }

    if (RedMarkModel != NULL) {
        memcpy(&this->red_mark, RedMarkModel, 0x90);
    }

    this->tex_bank = arg;
    this->InitStatusSprite();
    this->play_flag = 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", Omake_SetUp__7CSphidaFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", Step__7CSphidaFv);
void CSphida::InitStatusSprite() {
    mgCTexture *texture = mgTexManager.GetTexture((char *)at_1221__5, -1);

    pow_gage.pos_x = 256.0f;
    pow_gage.pos_y = 406.4f;
    pow_gage.texture = texture;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", DrawStatusSprite__7CSphidaFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", DrawParCounter__7CSphidaFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", Draw__7CSphidaFv);
int CSphida::SetCollisionModel(MDS_HEADER *header, mgCMemory *memory) {
    col_model = LoadCollisionFile(header, memory);
    return col_model != 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", PickupCollision__7CSphidaFPfP6CCPoly9mgVu0FBOXi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", DrawMiniMapSymbol__7CSphidaFP14CMiniMapSymbol);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sphida", GolfClubDef__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sphida", at_940__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sphida", at_1088__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sphida", at_1089__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sphida", at_1090__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sphida", at_1138__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sphida", at_1221__5__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(Sphida, 0x4);
