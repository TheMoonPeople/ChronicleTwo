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
#include "gamepad.hpp"
#include "dng_main.hpp"
#include "event.hpp"

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
CSphida::CSphida() {
    memset(unk_198, 0x80, sizeof(unk_198));
    Initialize();
}
void CSphida::Initialize() {
    play_flag = 0;
    minimap_flag = 0;
    mm_line_flag = 0;
    status_flag = 0;
    for (int index = 0; index < 5; index++) {
        mgZeroVector(mm_line_pos[index]);
    }
    mgZeroVector(pin_pos);
    mgZeroVector(ball_pos);
    pin_col = 0;
    ball_col = 0;
    par_count = 0;
    col_model = NULL;
    last_challenge = 0;
    omake_mode = 0;
    for (int index = 0; index < 9; index++) {
        unk_210[index] = 0;
    }
}
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
void CSphida::Omake_SetUp(int course, int tex_bank) {
    switch (course) {
        case 0:
            pin_pos[0] = 0.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 0.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 640.0f;
            ball_pos[1] = 3.0f;
            ball_pos[2] = 1280.0f;
            ball_pos[3] = 1.0f;
            par_count = 3;
            break;
        case 1:
            pin_pos[0] = 960.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 960.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 640.0f;
            ball_pos[1] = 3.0f;
            ball_pos[2] = 1920.0f;
            ball_pos[3] = 1.0f;
            par_count = 3;
            break;
        case 2:
            pin_pos[0] = 1600.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 960.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 1600.0f;
            ball_pos[1] = 5.0f;
            ball_pos[2] = 2880.0f;
            ball_pos[3] = 1.0f;
            par_count = 3;
            break;
        case 3:
            pin_pos[0] = 1280.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 0.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 1280.0f;
            ball_pos[1] = 3.0f;
            ball_pos[2] = 3840.0f;
            ball_pos[3] = 1.0f;
            par_count = 4;
            break;
        case 4:
            pin_pos[0] = 2800.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 800.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 1600.0f;
            ball_pos[1] = 3.0f;
            ball_pos[2] = 5600.0f;
            ball_pos[3] = 1.0f;
            par_count = 15;
            break;
        case 5:
            pin_pos[0] = 0.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 4000.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 2800.0f;
            ball_pos[1] = 3.0f;
            ball_pos[2] = 800.0f;
            ball_pos[3] = 1.0f;
            par_count = 6;
            break;
        case 6:
            pin_pos[0] = 1600.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 1600.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 2800.0f;
            ball_pos[1] = 3.0f;
            ball_pos[2] = 2800.0f;
            ball_pos[3] = 1.0f;
            par_count = 10;
            break;
        case 7:
            pin_pos[0] = 1280.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 2560.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 1280.0f;
            ball_pos[1] = 3.0f;
            ball_pos[2] = 3200.0f;
            ball_pos[3] = 1.0f;
            par_count = 7;
            break;
        case 8:
            pin_pos[0] = 0.0f;
            pin_pos[1] = 30.0f;
            pin_pos[2] = 4480.0f;
            pin_pos[3] = 1.0f;
            ball_pos[0] = 4160.0f;
            ball_pos[1] = 3.0f;
            ball_pos[2] = 4480.0f;
            ball_pos[3] = 1.0f;
            par_count = 7;
            break;
        default:
            return;
    }
    AutoMapGen.MinimapAllVisible();
    pin_col = (int)(2.0f * (float)rand() / 2147483648.0f);
    ball_col = (int)(2.0f * (float)rand() / 2147483648.0f);
    if (RedMarkModel != NULL) {
        memcpy(&red_mark, RedMarkModel, sizeof(red_mark));
    }
    this->tex_bank = tex_bank;
    InitStatusSprite();
    play_flag = 1;
    omake_mode = 1;
}

int CSphida::Step() {
    float character_position[4];
    CCharacter2 *character;
    int event_no;

    if (play_flag == 0) {
        return 0;
    }
    character = DngMainScene->GetCharacter(DngMainScene->player_chara);
    character->GetPosition(character_position);
    pow_gage.Step();
    if (((CActionChara *)character)->CheckRunEvent() == 0) {
        red_mark.draw_request = 0;
        return 0;
    }
    if (DngStatus.eye_view != 0) {
        red_mark.draw_request = 0;
        return 0;
    }
    DNG_BATTLE_AREA *area = &DngMainScene->battle_area;
    if (area != NULL && area->script.event_no != -1) {
        red_mark.draw_request = 0;
        return 0;
    }
    if (DngMainScene->event_run != 0) {
        red_mark.draw_request = 0;
        return 0;
    }
    if (mgDistVector(character_position, ball_pos) <= 40.0f) {
        red_mark.SetPosition(character_position);
        red_mark.draw_request = 1;
        red_mark.Step();
        if (PadCtrl.Btn(0) != 0 && DngStatus.mode == DNG_STATUS_FIELD) {
            memcpy(&EventCamera__2, &MainCamera, sizeof(mgCCameraFollow));
            DngMainScene->active_camera = 1;
            InitEvent(DngMainScene);
            if (RunEvent(SPHIDA_EVENT_SHOT, DngMainScene) != 0) {
                int map_level;
                DngStatus.debug_window = 0;
                DngStatus.mode = DNG_STATUS_EVENT;
                DngMainScene->before_camera = 0;
                sceVu0CopyVector(map_view_pos, ball_pos);
                map_level = DngSaveData->GetConfig()->map;
                if (map_level != 0) {
                    mini_level = map_level;
                }
                spin_mark_pos_y = 0.0f;
                spin_mark_pos_x = 0.0f;
                ((CActionChara *)character)->RemoveThrowItem();
                red_mark.draw_request = 0;
                return 1;
            }
        }
    } else {
        red_mark.draw_request = 0;
    }
    if (GamePad__2.Down(PAD_SQUARE) != 0) {
        if (DngStatus.mode == DNG_STATUS_FIELD) {
            event_no = -1;
            if (DebugFlag != 0) {
                event_no = SPHIDA_EVENT_NEAR_BALL;
            } else if (mgDistVector(character_position, ball_pos) <= 160.0f && last_challenge == 0) {
                if (par_count < 2) {
                    event_no = SPHIDA_EVENT_NEAR_BALL_LAST;
                } else {
                    event_no = SPHIDA_EVENT_NEAR_BALL;
                }
            } else if (omake_mode == 1) {
                event_no = SPHIDA_EVENT_OMAKE_AWAY;
            }
            if (event_no >= 0) {
                memcpy(&EventCamera__2, &MainCamera, sizeof(mgCCameraFollow));
                DngMainScene->active_camera = 1;
                InitEvent(DngMainScene);
                if (RunEvent(event_no, DngMainScene) != 0) {
                    DngStatus.debug_window = 0;
                    DngStatus.mode = DNG_STATUS_EVENT;
                    DngMainScene->before_camera = 0;
                    ((CActionChara *)character)->RemoveThrowItem();
                    red_mark.draw_request = 0;
                    return 1;
                }
            }
        }
    }
    return 0;
}

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
int CSphida::PickupCollision(float *position, CCPoly *polygons, mgVu0FBOX box, int capacity) {
    if (play_flag == 0 || col_model == NULL) {
        return 0;
    }
    int count = 0;
    if (mgDistVector(pin_pos, position) < 80.0f) {
        col_model->SetPosition(pin_pos);
        count += col_model->PickUpNearPoly(polygons, box, capacity);
    }
    return count;
}
void CSphida::DrawMiniMapSymbol(CMiniMapSymbol *symbol) {
    if (play_flag == 0) {
        return;
    }
    if (pin_col == 0) {
        symbol->DrawSymbol(pin_pos, MINIMAP_SYMBOL_SPHIDA_4);
    } else {
        symbol->DrawSymbol(pin_pos, MINIMAP_SYMBOL_SPHIDA_5);
    }
    if (ball_col == 0) {
        symbol->DrawSymbol(ball_pos, MINIMAP_SYMBOL_SPHIDA_6);
    } else {
        symbol->DrawSymbol(ball_pos, MINIMAP_SYMBOL_SPHIDA_7);
    }
    if (mm_line_flag == 1) {
        for (int index = 0; index < 5; index++) {
            symbol->DrawSymbol(mm_line_pos[index], MINIMAP_SYMBOL_MONSTER);
        }
    }
}

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
