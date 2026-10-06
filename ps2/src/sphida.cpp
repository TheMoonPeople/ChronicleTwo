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
#include <cmath>

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
void CPowGage::Step() {
    switch (state) {
        case POWGAGE_STATE_IDLE:
            break;
        case POWGAGE_STATE_START:
            state = POWGAGE_STATE_IDLE;
            reverse = 0;
            count = 0;
            power = 0.0f;
            code = POWGAGE_CODE_NONE;
            state = POWGAGE_STATE_CHARGE;
        case POWGAGE_STATE_CHARGE:
            if (reverse == 0) {
                count++;
            } else {
                count--;
            }
            power = (float)count / 40.0f;
            if (count >= 40) {
                reverse = 1;
            }
            if (reverse == 1 && count <= 0) {
                code = POWGAGE_CODE_NO_POWER;
                state = POWGAGE_STATE_IDLE;
            }
            break;
        case POWGAGE_STATE_CHARGE_SET:
            if (reverse == 1) {
                state = POWGAGE_STATE_IMPACT;
            } else {
                count++;
                if (count >= 40) {
                    reverse = 1;
                }
                break;
            }
        case POWGAGE_STATE_IMPACT:
            count--;
            if (count < -7) {
                code = POWGAGE_CODE_LATE;
                state = POWGAGE_STATE_IDLE;
            }
            break;
        case POWGAGE_STATE_JUDGE: {
            float offset = (float)count;
            float outer = 1.5f * (float)safe_level;
            if (!(offset <= outer)) {
                code = -3;
            }
            if (offset < outer) {
                code = 3;
            }
            if (!(offset <= 0.0f) && offset <= outer) {
                code = -2;
            }
            if (offset < 0.0f && !(offset < -outer)) {
                code = 2;
            }
            float inner = 0.5f * (float)safe_level;
            if (!(offset <= 0.0f) && offset <= inner) {
                code = -1;
            }
            if (offset < 0.0f && !(offset < -inner)) {
                code = 1;
            }
            if (count == 0) {
                code = 0;
            }
            state = POWGAGE_STATE_IDLE;
            break;
        }
    }
}
#ifdef NONMATCHING
void CPowGage::Draw() {
    if (texture == NULL) {
        return;
    }
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AlphaTestEnable(1);
    prim.AlphaTest(1, 0);
    prim.Bilinear(0);
    prim.Coord(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(texture);
    prim.Color(128, 128, 128, 128);
    DPrimEnterSprite(&prim, 22, 28, 2, 10, pos_x, pos_y, 325.0f, 10.0f);
    float bar_width = 260.0f * power;
    float bar_x = 104.0f + pos_x - bar_width / 2.0f;
    if (state == POWGAGE_STATE_CHARGE) {
        DPrimEnterSprite(&prim, 28, 28, 2, 10, bar_x, pos_y, bar_width, 10.0f);
    } else {
        DPrimEnterSprite(&prim, 40, 28, 2, 10, bar_x, pos_y, bar_width, 10.0f);
    }
    float safe_width = 19.5f * (float)safe_level;
    float safe_x = 104.0f + pos_x;
    DPrimEnterSprite(&prim, 20, 38, 14, 6, safe_x, 10.0f + pos_y, safe_width, 10.0f);
    DPrimEnterSprite(&prim, 32, 28, 6, 10, 104.0f + pos_x, pos_y, 6.0f, 10.0f);
    DPrimEnterSprite(&prim, 32, 0, 18, 28, pos_x + 156.0f, pos_y, 18.0f, 28.0f);
    DPrimEnterSprite(&prim, 0, 0, 18, 28, pos_x - 156.0f, pos_y, 18.0f, 28.0f);
    for (int index = 0; index < 23; index++) {
        DPrimEnterSprite(&prim, 18, 0, 13, 28, 143.0f + pos_x - 13.0f * (float)index, pos_y, 13.0f, 28.0f);
    }
    DPrimEnterSprite(&prim, 0, 28, 12, 22, 104.0f + pos_x, pos_y, 12.0f, 22.0f);
    DPrimEnterSprite(&prim, 12, 28, 8, 22, pos_x - 26.0f, pos_y, 8.0f, 22.0f);
    DPrimEnterSprite(&prim, 52, 0, 12, 30, 104.0f + pos_x - 6.5f * (float)count, pos_y, 12.0f, 30.0f);
    prim.End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", Draw__8CPowGageFv);
#endif
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
#ifdef NONMATCHING
void CSphida::DrawStatusSprite() {
    int index;
    if (status_flag == 0) {
        return;
    }
    InitStatusSprite();
    mgTexManager.ReloadTexture(tex_bank, (sceVif1Packet *)NULL);
    pow_gage.Draw();
    mgCTexture *texture = mgTexManager.GetTexture(at_1221__5, -1);
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AlphaTestEnable(1);
    prim.AlphaTest(1, 0);
    prim.Bilinear(0);
    prim.Coord(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(texture);
    prim.Color(128, 128, 128, 128);
    if (LanguageCode == LANG_JAPANESE) {
        DPrimEnterSprite(&prim, 96, 0, 24, 24, 383.0f, 34.0f, 24.0f, 24.0f);
        DPrimEnterSprite(&prim, 196, 0, 36, 20, 413.0f, 34.0f, 36.0f, 20.0f);
        int par = par_count;
        int par_tens = par / 10;
        int par_ones = par - par_tens * 10;
        if (par_tens != 0) {
            DPrimEnterSprite(&prim, par_tens * 18 + 332, 212, 18, 20, 438.0f, 33.0f, 18.0f, 20.0f);
        }
        DPrimEnterSprite(&prim, par_ones * 18 + 332, 212, 18, 20, 454.0f, 33.0f, 18.0f, 20.0f);
        DPrimEnterSprite(&prim, 232, 0, 24, 20, 474.0f, 34.0f, 24.0f, 20.0f);
        DPrimEnterSprite(&prim, 150, 20, 84, 22, 380.0f, 60.0f, 84.0f, 22.0f);
        int pin_distance = (int)(mgDistVector(pin_pos, ball_pos) / 20.0f);
        if (pin_distance > 999) {
            pin_distance = 999;
        }
        int pin_digits[3];
        pin_digits[0] = pin_distance / 100;
        pin_digits[1] = (pin_distance - pin_digits[0] * 100) / 10;
        pin_digits[2] = pin_distance - pin_digits[1] * 10 - pin_digits[0] * 100;
        int pin_shown = 0;
        for (index = 0; index < 3; index++) {
            if (pin_digits[index] != 0 || pin_shown == 1) {
                pin_shown = 1;
                DPrimEnterSprite(&prim, pin_digits[index] * 16 + 352, 192, 16, 20,
                                 430.0f + (float)(index * 14), 60.0f, 16.0f, 20.0f);
            }
        }
        DPrimEnterSprite(&prim, 234, 20, 22, 22, 474.0f, 60.0f, 22.0f, 22.0f);
        DPrimEnterSprite(&prim, 0, 50, 80, 80, 60.0f, 344.0f, 80.0f, 80.0f);
        DPrimEnterSprite(&prim, 330, 88, 54, 16, 60.0f, 304.0f, 54.0f, 16.0f);
        DPrimEnterSprite(&prim, 454, 88, 58, 16, 60.0f, 384.0f, 58.0f, 16.0f);
        DPrimEnterSprite(&prim, 384, 88, 40, 16, 40.0f, 336.0f, 40.0f, 16.0f);
        DPrimEnterSprite(&prim, 424, 88, 30, 16, 85.0f, 336.0f, 30.0f, 16.0f);
        DPrimEnterSprite(&prim, 68, 130, 10, 10, 60.0f + 32.0f * spin_mark_pos_x, 344.0f + 32.0f * spin_mark_pos_y,
                         10.0f, 10.0f);
        DPrimEnterSprite(&prim, 278, 88, 52, 16, 460.0f, 382.4f, 52.0f, 16.0f);
        DPrimEnterSprite(&prim, 0, 130, 68, 28, 460.0f, 406.4f, 68.0f, 28.0f);
        int carry_distance = 0;
        GOLF_CLUB_DEF *club = GetSphidaClubDef(club_no);
        if (club != NULL) {
            float landing[4];
            float velocity[4];
            mgZeroVector(landing);
            mgZeroVector(velocity);
            landing[1] += 3.0f;
            velocity[0] = (float)((double)(club->power - club->power * carry) * cos((double)carry));
            velocity[1] = (float)((double)(club->power - club->power * carry) * sin((double)carry));
            for (int step = 0; step < 600; step++) {
                velocity[0] *= 0.999f;
                velocity[1] += -0.0045f * (float)(step + 1);
                sceVu0AddVector(landing, landing, velocity);
                if (landing[1] <= 3.0f) {
                    break;
                }
            }
            landing[3] = 0.0f;
            landing[2] = 0.0f;
            landing[1] = 0.0f;
            carry_distance = (int)(mgDistVector(landing) / 20.0f);
        }
        if (carry_distance > 999) {
            carry_distance = 999;
        }
        int carry_digits[3];
        carry_digits[0] = carry_distance / 100;
        carry_digits[1] = (carry_distance - carry_digits[0] * 100) / 10;
        carry_digits[2] = carry_distance - carry_digits[1] * 10 - carry_digits[0] * 100;
        int carry_shown = 0;
        for (index = 0; index < 3; index++) {
            if (carry_digits[index] != 0 || carry_shown == 1 || index == 2) {
                carry_shown = 1;
                DPrimEnterSprite(&prim, carry_digits[index] * 16 + 352, 192, 16, 20,
                                 438.0f + 14.0f * (float)index, 406.4f, 16.0f, 20.0f);
            }
        }
        DPrimEnterSprite(&prim, 234, 20, 22, 22, 482.0f, 406.4f, 22.0f, 22.0f);
    } else {
        DPrimEnterSprite(&prim, 96, 0, 24, 24, 334.0f, 34.0f, 24.0f, 24.0f);
        DPrimEnterSprite(&prim, 150, 54, 102, 20, 430.0f, 34.0f, 102.0f, 20.0f);
        int par = par_count;
        int par_tens = par / 10;
        int par_ones = par - par_tens * 10;
        if (par_tens != 0) {
            DPrimEnterSprite(&prim, par_tens * 18 + 332, 212, 18, 20, 355.0f, 33.0f, 18.0f, 20.0f);
        }
        DPrimEnterSprite(&prim, par_ones * 18 + 332, 212, 18, 20, 371.0f, 33.0f, 18.0f, 20.0f);
        DPrimEnterSprite(&prim, 178, 74, 74, 22, 442.0f, 60.0f, 74.0f, 22.0f);
        int pin_distance = (int)(mgDistVector(pin_pos, ball_pos) / 20.0f);
        if (pin_distance > 999) {
            pin_distance = 999;
        }
        int pin_digits[3];
        pin_digits[0] = pin_distance / 100;
        pin_digits[1] = (pin_distance - pin_digits[0] * 100) / 10;
        pin_digits[2] = pin_distance - pin_digits[1] * 10 - pin_digits[0] * 100;
        int pin_shown = 0;
        for (index = 0; index < 3; index++) {
            if (pin_digits[index] != 0 || pin_shown == 1) {
                pin_shown = 1;
                DPrimEnterSprite(&prim, pin_digits[index] * 16 + 352, 192, 16, 20,
                                 430.0f + (float)(index * 14) - 60.0f, 60.0f, 16.0f, 20.0f);
            }
        }
        DPrimEnterSprite(&prim, 0, 50, 80, 80, 60.0f, 344.0f, 80.0f, 80.0f);
        DPrimEnterSprite(&prim, 330, 88, 54, 16, 60.0f, 304.0f, 54.0f, 16.0f);
        DPrimEnterSprite(&prim, 454, 88, 58, 16, 60.0f, 384.0f, 58.0f, 16.0f);
        DPrimEnterSprite(&prim, 384, 88, 34, 16, 40.0f, 336.0f, 34.0f, 16.0f);
        DPrimEnterSprite(&prim, 418, 88, 36, 16, 85.0f, 336.0f, 36.0f, 16.0f);
        DPrimEnterSprite(&prim, 68, 130, 10, 10, 60.0f + 32.0f * spin_mark_pos_x, 344.0f + 32.0f * spin_mark_pos_y,
                         10.0f, 10.0f);
        DPrimEnterSprite(&prim, 264, 88, 66, 16, 460.0f, 382.4f, 66.0f, 16.0f);
        DPrimEnterSprite(&prim, 0, 130, 68, 28, 460.0f, 406.4f, 68.0f, 28.0f);
        int carry_distance = 0;
        GOLF_CLUB_DEF *club = GetSphidaClubDef(club_no);
        if (club != NULL) {
            float landing[4];
            float velocity[4];
            mgZeroVector(landing);
            mgZeroVector(velocity);
            landing[1] += 3.0f;
            velocity[0] = (float)((double)(club->power - club->power * carry) * cos((double)carry));
            velocity[1] = (float)((double)(club->power - club->power * carry) * sin((double)carry));
            for (int step = 0; step < 600; step++) {
                velocity[0] *= 0.999f;
                velocity[1] += -0.0045f * (float)(step + 1);
                sceVu0AddVector(landing, landing, velocity);
                if (landing[1] <= 3.0f) {
                    break;
                }
            }
            landing[3] = 0.0f;
            landing[2] = 0.0f;
            landing[1] = 0.0f;
            carry_distance = (int)(mgDistVector(landing) / 20.0f);
        }
        if (carry_distance > 999) {
            carry_distance = 999;
        }
        int carry_digits[3];
        carry_digits[0] = carry_distance / 100;
        carry_digits[1] = (carry_distance - carry_digits[0] * 100) / 10;
        carry_digits[2] = carry_distance - carry_digits[1] * 10 - carry_digits[0] * 100;
        int carry_shown = 0;
        for (index = 0; index < 3; index++) {
            if (carry_digits[index] != 0 || carry_shown == 1 || index == 2) {
                carry_shown = 1;
                DPrimEnterSprite(&prim, carry_digits[index] * 16 + 352, 192, 16, 20,
                                 438.0f + 14.0f * (float)index, 406.4f, 16.0f, 20.0f);
            }
        }
        DPrimEnterSprite(&prim, 178, 74, 22, 22, 482.0f, 406.4f, 22.0f, 22.0f);
    }
    prim.End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sphida", DrawStatusSprite__7CSphidaFv);
#endif
#pragma divbyzerocheck on
void CSphida::DrawParCounter() {
    mgTexManager.ReloadTexture(tex_bank, (sceVif1Packet *)NULL);
    mgCTexture *texture = mgTexManager.GetTexture(at_1221__5, -1);
    int digits[5];
    int digit;
    int divisor = 10000;
    int remaining = par_count;
    int digit_count = 0;
    for (int index = 4; index >= 0; index--) {
        digit = remaining / divisor;
        if (index == 0 || digit > 0 || digit_count > 0) {
            digits[index] = digit;
            digit_count++;
            remaining -= digit * divisor;
        } else {
            digits[index] = -1;
        }
        divisor /= 10;
    }
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AlphaTestEnable(1);
    prim.AlphaTest(1, 0);
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(0);
    prim.TextureMapEnable(1);
    prim.Coord(1);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(texture);
    prim.Color(128, 128, 128, 128);
    float position[4];
    int top_left[4];
    int bottom_right[4];
    ball_pos[3] = 1.0f;
    sceVu0CopyVector(position, ball_pos);
    position[1] += 6.0f;
    for (int index = 4; index >= 0; index--) {
        digit = digits[index];
        if (digit != -1 && mgTransWorldPrim3DSprite(top_left, bottom_right, position, 3.6f, 5.0f, 1)) {
            int width = (bottom_right[0] - top_left[0]) >> 4;
            top_left[0] -= (width * index) << 4;
            bottom_right[0] -= (width * index) << 4;
            top_left[0] += (width / 2 * (digit_count - 1)) << 4;
            bottom_right[0] += (width / 2 * (digit_count - 1)) << 4;
            prim.TextureCrd(digit * 18 + 332, 212);
            prim.Vertex4(top_left);
            prim.TextureCrd(digit * 18 + 350, 232);
            prim.Vertex4(bottom_right);
        }
    }
    prim.End();
}
#pragma divbyzerocheck reset
void CSphida::Draw() {
    if (play_flag == 0) {
        return;
    }
    DrawStatusSprite();
    mgCTextureManager *tex_man = &mgTexManager;
    SV_CONFIG_OPTION *config = DngSaveData->GetConfig();
    if (DngStatus.mode != DNG_STATUS_FIELD && minimap_flag == 1) {
        if (config->map != 0) {
            tex_man->ReloadTexture(0x66, (sceVif1Packet *)NULL);
            CCharacter2 *player = DngMainScene->GetCharacter(0);
            if (config->map == 1) {
                AutoMapGen.mini_map.x = 420;
                AutoMapGen.mini_map.y = 160;
                AutoMapGen.mini_map.w = 144;
                AutoMapGen.mini_map.h = 144;
            }
            if (config->map == 2) {
                AutoMapGen.mini_map.x = 256;
                AutoMapGen.mini_map.y = 230;
                AutoMapGen.mini_map.w = 320;
                AutoMapGen.mini_map.h = 280;
            }
            if (GamePad__2.On(PAD_RIGHT)) {
                map_view_pos[0] -= 120.0f;
                float limit = ball_pos[0] - 10.0f * AutoMapGen.cell_w;
                if (map_view_pos[0] < limit) {
                    map_view_pos[0] = limit;
                }
            } else if (GamePad__2.On(PAD_LEFT)) {
                map_view_pos[0] += 120.0f;
                float limit = ball_pos[0] + 10.0f * AutoMapGen.cell_w;
                if (!(map_view_pos[0] <= limit)) {
                    map_view_pos[0] = limit;
                }
            }
            if (GamePad__2.On(PAD_UP)) {
                map_view_pos[2] += 120.0f;
                float limit = ball_pos[2] + 10.0f * AutoMapGen.cell_w;
                if (!(map_view_pos[2] <= limit)) {
                    map_view_pos[2] = limit;
                }
            } else if (GamePad__2.On(PAD_DOWN)) {
                map_view_pos[2] -= 120.0f;
                float limit = ball_pos[2] - 10.0f * AutoMapGen.cell_w;
                if (map_view_pos[2] < limit) {
                    map_view_pos[2] = limit;
                }
            }
            AutoMapGen.mini_map.Draw(map_view_pos);
            tex_man->ReloadTexture(0x48, (sceVif1Packet *)NULL);
            AutoMapGen.mini_map.DrawSymbolOpen();
            DrawMiniMapSymbol(&AutoMapGen.mini_map);
            AutoMapGen.mini_map.DrawSymbolClose();
            AutoMapGen.mini_map.DrawSymbol_Chara(player);
        }
        if (DngStatus.mode != DNG_STATUS_FIELD && GamePad__2.Down(PAD_SELECT)) {
            config->map++;
            if (config->map > 2) {
                config->map = 0;
            }
        }
        mini_level = config->map;
    } else if (omake_mode == 1 && DngStatus.mode == DNG_STATUS_FIELD) {
        DNG_BATTLE_AREA *area = &DngMainScene->battle_area;
        if (!area->script.running && !(area->pause_flag & 0x100) && config->map != 0) {
            float player_pos[4];
            tex_man->ReloadTexture(0x66, (sceVif1Packet *)NULL);
            CCharacter2 *player = DngMainScene->GetCharacter(0);
            player->GetPosition(player_pos);
            if (config->map == 1) {
                AutoMapGen.mini_map.large = 0;
                AutoMapGen.mini_map.x = 436;
                AutoMapGen.mini_map.y = 144;
                AutoMapGen.mini_map.w = 112;
                AutoMapGen.mini_map.h = 112;
            }
            if (config->map == 2) {
                AutoMapGen.mini_map.x = 336;
                AutoMapGen.mini_map.y = 212;
                AutoMapGen.mini_map.w = 320;
                AutoMapGen.mini_map.h = 280;
                AutoMapGen.mini_map.large = 1;
            }
            AutoMapGen.mini_map.Draw(player_pos);
            tex_man->ReloadTexture(0x48, (sceVif1Packet *)NULL);
            AutoMapGen.mini_map.DrawSymbolOpen();
            DrawMiniMapSymbol(&AutoMapGen.mini_map);
            AutoMapGen.mini_map.DrawSymbolClose();
            AutoMapGen.mini_map.DrawSymbol_Chara(player);
        }
    }
    if (DngStatus.mode == DNG_STATUS_FIELD) {
        red_mark.Draw();
        DrawParCounter();
    }
}
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
