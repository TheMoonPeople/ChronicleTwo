extern "C" void *__ct__11mgCDrawPrimFv(void *);
#include "common.h"
#include "mg_drawprim.hpp"
#include "automap.hpp"
#include "maintex.hpp"
#include "monster.hpp"
#include "font.hpp"
#include "cameracontrol.hpp"
#include "event_func.hpp"
#include "event.hpp"
#include "menucommon.hpp"
#include "mglib.hpp"
#include "dng_object.hpp"
#include "mainloop.hpp"
#include "quest.hpp"
#include "water.hpp"
#include "mapload.hpp"
#include "editevent.hpp"
#include "snd_mngr.hpp"
#include "effscript.hpp"
#include <cmath>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "snd_seseq.hpp"
#include "mg_drawenv.hpp"
#include "mg_texture.hpp"
#include "mg_math.hpp"
#include "dng_effect.hpp"
#include "dng_status.hpp"
#include "dng_debug.hpp"
#include "dng_main.hpp"
#include "mg_frame.hpp"
#include "prespr.hpp"
#include "scenesnd.hpp"
#include "dng_hud.hpp"
#include "userdata.hpp"
#include "character.hpp"
#include "nd_meswin.hpp"

extern "C" int fptosi(float);
extern int gekirin_anim[16];
extern "C" const char at_1221__2[];

// Code (.text)
void CLevelupInfo::SetLevelUpInfo(int screen_x, int screen_y, int source, int value) {
    unk_00 = 0;
    unk_04 = 0;
    unk_08 = 0;
    unk_0c = 0;
    unk_10 = 0;
    unk_14 = 0;
    unk_18 = 0;
    unk_1c = 0;
    progress = 0.0f;
    phase = LEVELUP_INFO_PHASE_APPEAR;
    x = screen_x - 0x23;
    y = screen_y - 6;
    unk_30 = source;
    unk_34 = value;
}
void CLevelupInfo::Draw(void) {
    int i;

    if (phase != LEVELUP_INFO_PHASE_NONE) {

        CPreSprite sprite;
        sprite.Initialize(NULL, NULL);
        sprite.Preset2D();
        sprite.Begin(6);
        sprite.Texture(TEX_SystenFrame);
        switch (phase) {
            case LEVELUP_INFO_PHASE_APPEAR: {
                int rise = fptosi(32.0f * sinf(4.712389f * progress - 1.5707964f));
                sprite.Color(0x80, 0x80, 0x80, fptosi(128.0f * progress));
                sprite.SetIRect(x, y - rise, 70, 12, 0, 0xA2);
                sprite.SetIRect(x - 0x10, y - rise - 3, 0x10, 0x10, 0x30, 0x40);
                break;
            }
            case LEVELUP_INFO_PHASE_FLASH: {
                float pulse;
                sprite.Color(0x80, 0x80, 0x80, 0x80);
                sprite.SetIRect(x, y, 70, 12, 0, 0xA2);
                sprite.SetIRect(x - 0x10, y - 3, 0x10, 0x10, 0x30, 0x40);
                pulse = sinf(3.1415927f * progress);
                sprite.SetAlphaBlend(2);
                sprite.Color(0x80, 0x80, 0x80, fptosi(32.0f * pulse));
                for (i = 0; i < 4; i++) {
                    sprite.SetIStretch(x - i, y - i, i * 2 + 70, i * 2 + 12, 0,
                                       0xA2, 70, 12);
                    sprite.SetIStretch(x - i - 0x10, y - i - 3, i * 2 + 0x10, i * 2 + 0x10, 0x30,
                                       0x40, 0x10, 0x10);
                }
                break;
            }
            case LEVELUP_INFO_PHASE_HOLD:
                sprite.Color(0x80, 0x80, 0x80, 0x80);
                sprite.SetIRect(x, y, 70, 12, 0, 0xA2);
                sprite.SetIRect(x - 0x10, y - 3, 0x10, 0x10, 0x30, 0x40);
                break;
            case LEVELUP_INFO_PHASE_FADE:

                sinf(4.712389f * progress - 1.5707964f);
                sprite.Color(0x80, 0x80, 0x80, 0x80 - fptosi(128.0f * progress));
                sprite.SetIRect(x, y, 70, 12, 0, 0xA2);
                sprite.SetIRect(x - 0x10, y - 3, 0x10, 0x10, 0x30, 0x40);
                break;
        }
        sprite.End();
    }
}
void CLevelupInfo::Step(void) {
    if (phase != LEVELUP_INFO_PHASE_NONE) {
        switch (phase) {
            case LEVELUP_INFO_PHASE_APPEAR:
            case LEVELUP_INFO_PHASE_FLASH:
            case LEVELUP_INFO_PHASE_HOLD:
                if (progress < 0.9f) {
                    progress += 0.1f;
                } else {
                    progress = 0.0f;
                    phase += 1;
                }
                break;
            case LEVELUP_INFO_PHASE_FADE:
                if (progress < 0.9f) {
                    progress += 0.1f;
                } else {
                    phase = LEVELUP_INFO_PHASE_NONE;
                }
                break;
        }
    }
}
void CPiyori::Initialize(void) {
    target = NULL;
}
void CPiyori::Reset(void) {
    target = NULL;
    time = 0;
}
void CPiyori::Set(mgCObject *object, float height, float radius, s16 life) {
    int i;

    if (object != NULL) {
        target = (CCharacter2 *)object;
        this->height = height;
        this->radius = radius;
        this->time = life;
        circle_angle = 0.0f;
        for (i = 0; i < 3; i++) {
            star_angle[i] = fRand(6.2831855f) - 3.1415927f;
        }
        se_wait = 0;
    }
}
void CPiyori::Set(mgCObject *target, s16 time) {
    if (target != NULL) {
        CCharacter2 *character = reinterpret_cast<CCharacter2 *>(target);
        this->Set(target, 2.0f * character->body_height, 2.0f * character->body_width, time);
    }
}
void CPiyori::Draw(void) {
    float char_pos[4];
    struct {
        float v[3];
        int w;
    } pos;
    union { CPreSprite prim; };
    int quad_a[4];
    int quad_b[4];
    int i;
    int alpha;
    int draw_time;
    float draw_angle;
    float draw_radius;

    if (this->target != NULL) {
        this->target->GetPosition(char_pos);
        alpha = 0x80;
        char_pos[1] += this->height;
        draw_time = this->time;
        draw_radius = this->radius;
        draw_angle = this->circle_angle;
        if (draw_time < 16) {
            alpha = draw_time * 8;

            draw_radius = this->radius / 24.0 * draw_time;
        }

        __ct__11mgCDrawPrimFv(&prim);
        prim.Initialize(NULL, NULL);
        prim.Preset2D();
        prim.Coord(1);
        prim.DepthTestEnable(1);
        prim.ZMask(-1);
        prim.Bilinear(1);
        prim.TextureMapEnable(1);
        prim.Begin(6);
        prim.Color(0x80, 0x80, 0x80, alpha);
        prim.Texture(TEX_SystemEffect1);
        i = 0;
        pos.w = 0x3F800000;
        for (i = 0; i < 3; i++) {
            pos.v[0] = char_pos[0] + draw_radius * cosf(draw_angle);
            pos.v[1] = char_pos[1] + sinf(this->star_angle[i]);
            pos.v[2] = char_pos[2] + draw_radius * sinf(draw_angle);
            if (mgTransWorldPrim3DSprite(quad_a, quad_b, pos.v, 4.0f, 4.0f, 0) != 0) {
                prim.TextureCrd(0xC1, 0x61);
                prim.Vertex4(quad_a);
                prim.TextureCrd(0xDF, 0x7F);
                prim.Vertex4(quad_b);
            }
            draw_angle += 2.0943952f;
        }
        prim.End();
    }
}
void CPiyori::Step(void) {
    float pos[4];
    float vol;
    float pan;
    int i;

    if (target != NULL) {
        time -= 1;
        if (time <= 0) {
            target = NULL;
            return;
        }
        se_wait -= 1;
        if (se_wait <= 0) {
            ((CCharacter2 *)target)->GetEntryObjectPos(0, pos);
            sndGetVolPan(&vol, &pan, pos, 160.0f, 1200.0f);
            sndSePlayVPf(GetMainScene()->se_battle_id, 0x24, vol, pan, 0);
            se_wait = 13;
        }
        {
            float a = circle_angle;
            a += 0.10471976f;
            circle_angle = a;
            if (a > 3.1415927f) {
                circle_angle = a - 6.2831855f;
            }
        }
        for (i = 0; i < 3; i++) {
            float a = star_angle[i];
            a += 0.20943952f;
            star_angle[i] = a;
            if (a > 3.1415927f) {
                star_angle[i] = a - 6.2831855f;
            }
        }
    }
}
void CGiftMark::Set(CCharacter2 *character, float character_scale) {
    Initialize();
    chara = character;
    height = character_scale;
    active = 1;
}
void CGiftMark::Draw(void) {
    struct {
        float v[3];
        int w;
    } pos;
    union { CPreSprite prim; };
    int quad_a[4];
    int quad_b[4];
    int i;

    if (active != 0) {
        if (chara != NULL) {
            chara->GetEntryObjectPos(0, pos.v);
            pos.v[1] += 10.0f + 2.0f * height;
            pos.v[1] += 5.0f * sinf(angle);

            __ct__11mgCDrawPrimFv(&prim);
        prim.Initialize(NULL, NULL);
            prim.Preset2D();
            prim.Coord(1);
            prim.DepthTestEnable(1);
            prim.ZMask(-1);
            prim.Bilinear(1);
            prim.TextureMapEnable(1);
            prim.Begin(6);
            prim.Color(0x80, 0x80, 0x80, 0x80);
            prim.Texture(TEX_SystemEffect1);
            i = 0;
            pos.w = 0x3F800000;
            do {
                if (mgTransWorldPrim3DSprite(quad_a, quad_b, pos.v, 8.0f, 8.0f, 0) != 0) {
                    prim.TextureCrd(0xE1, 0x41);
                    prim.Vertex4(quad_a);
                    prim.TextureCrd(0xFC, 0x62);
                    prim.Vertex4(quad_b);
                }
                i += 1;
            } while (i < 3);
            prim.End();
        }
    }
}
void CGiftMark::Step(void) {
    if (active != 0) {
        angle += 0.1308997f;
        if (angle > 3.1415927f) {
            angle -= 3.1415927f;
        }
        time += 1;
        if (time > 240) {
            active = 0;
        }
    }
}
void CGiftMark::Initialize(void) {
    chara = NULL;
    active = 0;
    angle = 0.0f;
    time = 0;
}
void CEnemyGekirin::Draw(CPreSprite *sprite, int x, int y) {
    if (state != GEKIRIN_STATE_NONE) {
        sprite->SetAlphaBlend(0);
        sprite->Color(0x80, 0x80, 0x80, 0x80);
        sprite->SetIRect(x, y - gekirin_anim[frame] * 4, 8, 8, 0x78, 0xCA);
        if (state == GEKIRIN_STATE_BREAK) {
            sprite->SetAlphaBlend(2);
            sprite->Color(0x80, 0x80, 0x80, 0x40);
            sprite->SetIStretch(x - 4, y - gekirin_anim[frame] * 4 - 4, 0x10, 0x10, 0x78, 0xCA, 8,
                                8);
        }
    }
}
void CEnemyGekirin::Step(void) {
    if (state == GEKIRIN_STATE_BREAK) {
        frame += 1;
        if (gekirin_anim[frame] == 0) {
            state = GEKIRIN_STATE_NONE;
        }
    }
}
void CEnemyLifeGage::SetView(int visible) {
    if (visible != 0) {
        if (view == 0) {
            scale = 0.5f;
        }
    } else {
        if (view != 0) {
            scale = 1.0f;
        }
    }
    view = visible;
}
void CEnemyLifeGage::Set(float *position, int new_max_life, int new_life, int count, int new_pinned) {
    int i;

    sceVu0CopyVector(pos, position);
    max_hp = new_max_life;
    hp = new_life;
    screen = new_pinned;
    for (i = 0; i < ENEMY_LIFE_GAGE_GEKIRIN_MAX; i++) {
        if (i > count - 1 && gekirin[i].state == GEKIRIN_STATE_SHOW) {
            gekirin[i].frame = 0;
            gekirin[i].state = GEKIRIN_STATE_BREAK;
        }
    }
}
void CEnemyLifeGage::Draw(int hide_gekirin) {
    if (!(scale <= 0.0f) && (max_hp != 0 || hp != 0)) {
        int i;
        CPreSprite sprite;
        if (screen != 0) {
            CPreSprite frame;
            CPreSprite fill;
            frame.Initialize(NULL, NULL);
            frame.Preset2D();
            frame.Begin(6);
            frame.Bilinear(0);
            frame.Texture(TEX_SystenFrame);
            int y = mgScreenHeight - 44;
            frame.Color(128, 128, 128, 128);
            frame.SetIRect(16, y, 34, 34, 210, 146);
            for (int i = 0; i < 15; i++) {
                frame.SetIRect(50 + i * 10, y, 10, 34, 244, 146);
            }
            frame.SetIRect(200, y, 34, 34, 254, 146);
            frame.End();
            frame.Initialize(NULL, NULL);
            frame.Preset2D();
            frame.Coord(0);
            frame.TextureMapEnable(0);
            frame.Shading(1);
            frame.Begin(4);
            float hp_width = 170.0f * ((float)hp / max_hp);
            int width = (int)(hp_width * scale);
            y = mgScreenHeight - 39;
            frame.Color(255, 96, 0, 128);
            frame.Vertex(48, y + 12, 0);
            frame.Color(255, 255, 0, 128);
            frame.Vertex(width + 48, y + 12, 0);
            y = mgScreenHeight - 35;
            frame.Color(255, 96, 0, 128);
            frame.Vertex(48, y + 12, 0);
            frame.Color(255, 255, 0, 128);
            frame.Vertex(width + 48, y + 12, 0);
            frame.End();
            return;
        }
        int position[4];
        if (mgTransWorldScreen(position, pos) != 0) {
            sprite.Initialize(NULL, NULL);
            sprite.Preset2D();
            sprite.Coord(0);
            sprite.TextureMapEnable(0);
            sprite.Shading(1);
            sprite.Begin(3);
            sprite.Color(30, 20, 30, 128);
            position[0] /= 16;
            position[1] /= 16;
            position[1] -= 24;
            if (position[1] < 89) {
                position[1] = 88;
            }
            int half_width = (int)(34.0f * scale);
            int left = position[0] - half_width + 2;
            u32 top = position[1];
            int right = position[0] + half_width + 2;
            int bottom = top + 4;
            sprite.Vertex(left, top, 0);
            sprite.Vertex(right, top, 0);
            sprite.Vertex(left, bottom, 0);
            sprite.Vertex(left, bottom, 0);
            sprite.Vertex(right, bottom, 0);
            sprite.Vertex(right, top, 0);
            top = position[1] - 2;
            left = position[0] - half_width;
            float hp_half_width = (float)half_width * ((float)hp / (float)max_hp);
            right = (int)(2.0f * hp_half_width) + left;
            bottom = position[1] + 2;
            sprite.Color(255, 96, 0, 128);
            sprite.Vertex(left, top, 0);
            sprite.Color(255, 255, 0, 128);
            sprite.Vertex(right, top, 0);
            sprite.Color(255, 96, 0, 128);
            sprite.Vertex(left, bottom, 0);
            sprite.Color(255, 96, 0, 128);
            sprite.Vertex(left, bottom, 0);
            sprite.Color(255, 255, 0, 128);
            sprite.Vertex(right, bottom, 0);
            sprite.Color(255, 255, 0, 128);
            sprite.Vertex(right, top, 0);
            sprite.End();
            if (hide_gekirin == 0) {
                sprite.Initialize(NULL, NULL);
                sprite.Preset2D();
                sprite.Coord(0);
                sprite.TextureMapEnable(1);
                sprite.Begin(6);
                sprite.Color(128, 128, 128, 128);
                sprite.Texture(TEX_SystenFrame);
                int x = position[0] - half_width;
                top = position[1] - 12;
                for (i = 0; i < 16; i += 1) {
                    gekirin[i].Draw(&sprite, x, top);
                    x += 8;
                }
                sprite.End();
            }
        }
    }
}


void CEnemyLifeGage::Step(void) {
    int i;

    if (screen != 0) {
        scale = 1.0f;
        return;
    }
    if (view != 0) {
        if (scale < 1.0f) {
            scale += 0.005f + scale / 3.0f;
        }
        if (!(scale < 1.0f)) {
            scale = 1.0f;
        }
    } else {
        if (scale > 0.0f) {
            scale -= 0.01f + scale / 2.0f;
        }
        if (scale <= 0.1f) {
            scale = 0.0f;
        }
    }
    for (i = 0; i < ENEMY_LIFE_GAGE_GEKIRIN_MAX; i++) {
        gekirin[i].Step();
    }
}
void CEnemyLifeGage::ResetGekirin(int gekirin_count) {
    int i;

    for (i = 0; i < ENEMY_LIFE_GAGE_GEKIRIN_MAX; i++) {
        gekirin[i].frame = 0;
        if (i < gekirin_count) {
            gekirin[i].state = GEKIRIN_STATE_SHOW;
        } else {
            gekirin[i].state = GEKIRIN_STATE_NONE;
        }
    }
}
void CEnemyLifeGage::Initialize(int gekirin_num) {
    this->ResetGekirin(gekirin_num);
    hp = 0;
    max_hp = 0;
    view = 0;
    scale = 0.0f;
}
void CDamageScore::SetValue(float *pos, int value) {
    sceVu0CopyVector(this->pos, pos);
    alpha = 0;
    phase = 0;
    active = 1;
    sprite = 0;
    sprintf(text, at_1221__2, value);
    length = strlen(text);
    for (int i = 0; i < length; i++) {
        bounce[i] = 3.1415927f;
    }
}
void CDamageScore::SetColor(s16 red, s16 green, s16 blue) {
    color[0] = red;
    color[1] = green;
    color[2] = blue;
}
void CDamageScore::SetSprite(float *pos, int u0, int v0, int u1, int v1) {
    sceVu0CopyVector(this->pos, pos);
    alpha = 0;
    phase = 0;
    active = 1;
    sprite = 1;
    bounce[0] = 3.1415927f;
    sprite_w = u1;
    sprite_h = v1;
    sprite_u = u0;
    sprite_v = v0;
}
void CDamageScore::Draw() {
    if (active == 0) {
        return;
    }
    if (sprite != 0) {
        CPreSprite prim;
        int screen[4];
        prim.Initialize(NULL, NULL);
        prim.Preset2D();
        prim.Coord(1);
        prim.Begin(6);
        prim.Texture(TEX_SystenFrame);
        prim.AlphaTestEnable(1);
        pos[3] = 1.0f;
        if (mgTransWorldPrim(screen, pos)) {
            prim.Color(0x80, 0x80, 0x80, alpha);
            screen[1] += (int)(12.0f * sinf(bounce[0])) << 4;
            prim.TextureCrd(sprite_u, sprite_v);
            prim.Vertex4(screen[0], screen[1], 0);
            prim.TextureCrd(sprite_u + sprite_w, sprite_v + sprite_h);
            prim.Vertex4(screen[0] + (sprite_w << 4), screen[1] + (sprite_h << 4), 0);
        }
        prim.End();
    }
    if (sprite == 0) {
        CPreSprite prim;
        int screen[4];
        prim.Initialize(NULL, NULL);
        prim.Preset2D();
        prim.Coord(1);
        prim.Begin(6);
        prim.Texture(TEX_SystenFrame);
        prim.AlphaTestEnable(1);
        pos[3] = 1.0f;
        for (int i = 0; text[i] > 0; i++) {
            if (mgTransWorldPrim(screen, pos)) {
                prim.Color(color[0], color[1], color[2], alpha);
                screen[0] -= (length * digit_w) << 3;
                screen[0] += (i * digit_w) << 4;
                screen[1] += (int)(48.0f * sinf(bounce[i])) << 4;
                int digit = text[i] - '0';
                prim.TextureCrd(digit_u + digit * digit_w, digit_v);
                prim.Vertex4(screen[0], screen[1], 0);
                prim.TextureCrd(digit_w + (digit_u + digit * digit_w), digit_v + digit_h);
                prim.Vertex4(screen[0] + (digit_w << 4), screen[1] + (digit_h << 4), 0);
            }
        }
        prim.End();
    }
}
void CDamageScore::Step() {
    if (active != 0) {
        if (sprite != 0) {
            if (phase == 0) {
                bounce[0] = bounce[0] - 0.3926991f;
                if (bounce[0] < -3.1415927f) {
                    bounce[0] = -3.1415927f;
                    phase = 1;
                }
                if (alpha < 0x80) {
                    alpha = alpha + 0xC;
                }
            }
            if (phase == 1) {
                alpha -= 4;
                if (alpha < 0) {
                    active = 0;
                }
            }
        }
        if (sprite == 0) {
            if (phase == 0) {
                for (int i = 0; i < length; i++) {
                    bounce[i] = bounce[i] - (3.1415927f / (10.0f + (2.0f * (float)i)));
                    if (bounce[i] < -3.1415927f) {
                        bounce[i] = -3.1415927f;
                        if (i == length - 1) {
                            phase = 1;
                        }
                    }
                }
                if (alpha < 0x80) {
                    alpha = alpha + 6;
                }
            }
            if (phase == 1) {
                alpha -= 6;
                if (alpha < 0) {
                    active = 0;
                }
            }
        }
    }
}
void CDamageScore2::SetValue(int slot, int value, float height) {
    chara_no = slot;
    alpha = 0;
    this->value = value;
    phase = 1;
    offset_y = 0;
    this->height = 2.0f * height;
    progress = 0;
    sprintf(text, at_1221__2, this->value);
    length = strlen(text);
}
void CDamageScore2::Draw(CScene *scene) {
    if (phase != DAMAGE_SCORE2_PHASE_NONE && length > 0) {
        CCharacter2 *character = scene->GetCharacter(chara_no);
        if (character != NULL) {
            mgCFrame *frame = character->GetFrame();
            if (frame != NULL) {
                CPreSprite sprite;
                int screen[4];
                sceVu0FVECTOR position;
                sprite.Initialize(NULL, NULL);
                sprite.Preset2D();
                sprite.Coord(1);
                sprite.Begin(6);
                sprite.Texture(TEX_SystenFrame);
                sprite.AlphaTestEnable(1);
                frame->GetWorldPosition0(position);
                position[1] += height;
                position[3] = 1.0f;
                for (int index = 0; text[index] > 0; index++) {
                    if (mgTransWorldPrim(screen, position)) {
                        screen[0] -= (length * 14 / 2) << 4;
                        screen[0] += (index * 14) << 4;
                        screen[1] += (int)offset_y << 4;
                        int digit = text[index] - '0';
                        sprite.Color(220, 96, 96, (int)(128.0f * alpha));
                        sprite.TextureCrd(digit * 12 + 78, 162);
                        sprite.Vertex4(screen[0], screen[1], 0);
                        sprite.TextureCrd(digit * 12 + 90, 179);
                        sprite.Vertex4(screen[0] + 224, screen[1] + 304, 0);
                    }
                }
                sprite.End();
            }
        }
    }
}
void CDamageScore2::Step() {
    if (phase != DAMAGE_SCORE2_PHASE_NONE) {
        if (phase == DAMAGE_SCORE2_PHASE_JUMP) {
            progress += 0.1f;
            alpha += 0.1f;
            offset_y = (int)(64.0f * sinf(-2.3561945f * progress));
            if (progress > 1.0f) {
                phase = DAMAGE_SCORE2_PHASE_HOLD;
                progress = 0.0f;
                alpha = 1.0f;
            }
        }
        if (phase == DAMAGE_SCORE2_PHASE_HOLD) {
            progress += 0.05f;
            if (progress > 1.0f) {
                phase = DAMAGE_SCORE2_PHASE_FADE;
                progress = 0.0f;
            }
        }
        if (phase == DAMAGE_SCORE2_PHASE_FADE) {
            progress += 0.125f;
            alpha -= 0.125f;
            offset_y += (int)(8.0f * progress);
            if (progress > 1.0f) {
                phase = DAMAGE_SCORE2_PHASE_NONE;
                alpha = 0.0f;
            }
        }
    }
}
void CLockOnModel::Draw() {
    float target_pos[4];
    int top_left[4];
    int bottom_right[4];

    CActionChara *player = (CActionChara *)scene->GetCharacter(0);
    if (player == NULL) {
        return;
    }
    name = NULL;
    if (player->target_no == -1) {
        return;
    }
    CActiveMonster *target = (CActiveMonster *)scene->GetCharacter(player->target_no);
    if (target == NULL) {
        return;
    }
    float size;
    float height = target->body_height;
    if (!(target->target_dist <= target->clip_dist)) {
        return;
    }
    if (target->alpha <= 0.0f) {
        return;
    }
    CHARA_ENTRY_OBJECT *entry = target->GetEntryObjectPos(0, 0, target_pos);
    if (entry == NULL) {
        return;
    }
    size = entry->unk_04;
    sceVu0CopyVector(pos, target_pos);
    if (!(height <= 85.0f)) {
        height = 85.0f;
    }
    pos[1] += height;
    name = target->tbl->name;
    int monster_id = -1;
    if (DngUserData->active_chr_no == USER_CHARA_MONSTER) {
        monster_id = DngUserData->monster_id;
    }
    if (target->monster_id == monster_id) {
        int message = target->unk_134c;
        if (message >= 0) {
            message += 5000;
        }
        unk_90 = message;
    } else {
        unk_90 = -1;
    }
    if (player->lock_on == 0) {
        target_pos[1] += 5.0f + 10.0f * size;
        SetRotation(0.0f, angle, 0.0f);
        SetPosition(target_pos);
        CObjectFrame::DrawDirect();
        return;
    }
    CPreSprite prim;
    prim.Initialize(NULL, NULL);
    prim.Preset2D();
    prim.Coord(1);
    prim.Begin(6);
    prim.Texture(TEX_SystenFrame);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    if (mgTransWorldPrim3DSprite(top_left, bottom_right, target_pos, 20.0f * size, 20.0f * size, 0) != 0) {
        bottom_right[0] -= 0x120;
        bottom_right[1] -= 0x120;
        prim.TextureCrd(0xC0, 0x16);
        prim.Vertex4(top_left[0], top_left[1], 0);
        prim.TextureCrd(0xD2, 0x28);
        prim.Vertex4(top_left[0] + 0x120, top_left[1] + 0x120, 0);
        prim.TextureCrd(0xD2, 0x16);
        prim.Vertex4(bottom_right[0], top_left[1], 0);
        prim.TextureCrd(0xE4, 0x28);
        prim.Vertex4(bottom_right[0] + 0x120, top_left[1] + 0x120, 0);
        prim.TextureCrd(0xC0, 0x26);
        prim.Vertex4(top_left[0], bottom_right[1], 0);
        prim.TextureCrd(0xD2, 0x3A);
        prim.Vertex4(top_left[0] + 0x120, bottom_right[1] + 0x120, 0);
        prim.TextureCrd(0xD2, 0x28);
        prim.Vertex4(bottom_right[0], bottom_right[1], 0);
        prim.TextureCrd(0xE4, 0x3A);
        prim.Vertex4(bottom_right[0] + 0x120, bottom_right[1] + 0x120, 0);
    }
    prim.End();
}

void CLockOnModel::DrawMess(int tex_block) {
    if (name != NULL) {
        if (mes->MakeAnd3DPosSet(name, pos, 0, -48) == 0) {
            ClsMes *message = mes;
            message->draw_speed = message->GetDrawSpeedDef();
            message->mes_no = -1;
            message->unk_1e40 = 0;
            message->open = 0;
            message->fade = 0.0f;
            message->fukidashi_centre_x = -1;
            message->fukidashi_centre_y = -1;
        }
        mes->Step();
        mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *)NULL);
        mes->DrawMesWin();
    }
}
void CLockOnModel::Step() {
    angle += 0.06981317f;
    if (angle > 3.1415927f) {
        angle -= 6.2831855f;
    }
}
void CWarningGage2::Step() {
    time += 1;
    if (time >= 0x28) {
        time = 0;
    }
}
void CWarningGage2::Draw() {
    if (time >= 20 && layout != WARNING_GAGE_LAYOUT_NONE) {
        CPreSprite prim;
        prim.Initialize(NULL, NULL);
        prim.Preset2D();
        prim.Begin(6);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        if (layout == WARNING_GAGE_LAYOUT_MAIN) {
            for (int i = 0; i < 3; i++) {
                if (warning[i] == 0) {
                    continue;
                }
                if (rate[i] == 0.0f) {
                    switch (i) {
                        case 0:
                            prim.SetIRect(0xB7, 0x29, 0x44, 0x14, 0x13C, 0xEC);
                            prim.SetIRect(0xAA, 0x10, 0x1C, 0x24, 0xD2, 0xE2);
                            break;
                        case 1:
                            prim.SetIRect(0x112, 0x40, 0x44, 0x14, 0x13C, 0xD8);
                            prim.SetIRect(0x12E, 0xF, 0x1A, 0x36, 0x108, 0xCA);
                            break;
                        case 2:
                            prim.SetIRect(0x19B, 0x49, 0x44, 0x14, 0x13C, 0xD8);
                            prim.SetIRect(0x1B7, 0x38, 0x1A, 0x16, 0xEE, 0xD4);
                            break;
                    }
                } else {
                    switch (i) {
                        case 0:
                            prim.SetIRect(0xB7, 0x29, 0x44, 0x14, 0x13C, 0xEC);
                            prim.SetIRect(0xAA, 0x10, 0x1C, 0x24, 0xD2, 0xE2);
                            break;
                        case 1:
                            prim.SetIRect(0x112, 0x40, 0x44, 0x14, 0x13C, 0xEC);
                            prim.SetIRect(0x12E, 0xF, 0x1A, 0x36, 0x122, 0xCA);
                            break;
                        case 2:
                            prim.SetIRect(0x19B, 0x49, 0x44, 0x14, 0x13C, 0xEC);
                            prim.SetIRect(0x1B7, 0x38, 0x1A, 0x16, 0xEE, 0xEA);
                            break;
                    }
                }
            }
        }
        if (layout == WARNING_GAGE_LAYOUT_ROBO) {
            for (int i = 0; i < 2; i++) {
                if (warning[i] == 0) {
                    continue;
                }
                if (rate[i] == 0.0f) {
                    switch (i) {
                        case 0:
                            break;
                        case 1:
                            prim.SetIRect(0x140, 0x21, 0x44, 0x14, 0x13C, 0xD8);
                            prim.SetIRect(0x15C, 0x10, 0x1A, 0x16, 0xEE, 0xD4);
                            break;
                    }
                } else {
                    switch (i) {
                        case 0:
                            prim.SetIRect(0x92, 0x26, 0x44, 0x14, 0x13C, 0xEC);
                            prim.SetIRect(0x85, 0xD, 0x1C, 0x24, 0xD2, 0xE2);
                            break;
                        case 1:
                            prim.SetIRect(0x140, 0x21, 0x44, 0x14, 0x13C, 0xEC);
                            prim.SetIRect(0x15C, 0x10, 0x1A, 0x16, 0xEE, 0xEA);
                            break;
                    }
                }
            }
        }
        prim.End();
    }
}

void CLockOnModel::Initialize(CScene *scene) {
    this->scene = scene;
    name = NULL;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_hud", gekirin_anim__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_hud", at_1221__2__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_hud", __vt__12CLockOnModel__DATA);
