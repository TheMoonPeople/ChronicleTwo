#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "dataread.hpp"
#include "dng_debug.hpp"
#include "dng_effect.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "editexception.hpp"
#include "editriver.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "gameutil.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapinfo.hpp"
#include "mapjump.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mapselect.hpp"
#include "menucommon.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "object.hpp"
#include "pot.hpp"
#include "quest.hpp"
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "userdata.hpp"
#include "water.hpp"

extern int                     FLS_FLOOR_ID;
extern char                    at_1082__2[];
extern char                    at_1248[];
extern char                    at_1274__2[];
extern char                    at_1279__2[];
extern int                     gatekey_index[7];
extern int                     keydoor_key_index[7];
extern char                    at_1466__5[];
extern char                    at_1467__5[];
extern char                    at_1468__5[];
extern int                     counter_1489;
extern float                   xchg_rot_list[4];
extern char                    at_1645[];
extern char                    at_1732__2[];
extern TRESURE_BOX_FLOOR_INFO *nowTbFloor;
extern int                     nowTboxGroup;
extern int                     nowTboxItemCnt;
extern char                    at_1905__2[];
extern "C" float               at_1936__2[4];
extern "C" char                at_1965__2[];
extern SPI_TAG_PARAM           tag__5[];
extern SPI_TAG_PARAM           tag2[];
extern char                    at_1348[];
extern char                    at_2529[];
static MapJumpMapInfo          MainMapInfo;

// Code (.text)
void CStartupEpisodeTitle::DrawEpisode(int mes_tex_block, int frame_tex_block) {
    if (mes == NULL || state == 0) {
        return;
    }
    mgTexManager.ReloadTexture(mes_tex_block, (sceVif1Packet *) NULL);
    mes->DrawMesWin();
    mgTexManager.ReloadTexture(frame_tex_block, (sceVif1Packet *) NULL);
    CPreSprite sprite;
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Coord(0);
    sprite.TextureMapEnable(1);
    sprite.Begin(6);
    sprite.Texture(TEX_SystenFrame2);
    int y = mgScreenHeight - 0x38;
    sprite.Color(0x80, 0x80, 0x80, (int) (128.0f * alpha));
    sprite.SetIRect(0x16, y, 10, 8, 0x62, 0x38);
    int x = (int) ((float) width * alpha);
    sprite.SetIStretch(0x20, y, x, 8, 0x6C, 0x38, 10, 8);
    sprite.SetIRect(x + 0x20, y, 10, 8, 0x76, 0x38);
    int title_y = mgScreenHeight - 0x34;
    if (LanguageCode == 3) {
        x = width / 2 - 8;
        int revealed = (int) (154.0f * reveal);
        sprite.SetScirror(x + 154 - revealed, title_y, revealed, 0xE);
        sprite.SetIRect(x, title_y, 0x48, 0xE, 0, 0x24);
    } else {
        x = width / 2 - 0x31;
        int revealed = (int) (154.0f * reveal);
        sprite.SetScirror(x + 154 - revealed, title_y, revealed, 0xE);
        sprite.SetIRect(x, title_y, 0x48, 0xE, 0, 0x24);
        sprite.SetIRect(x + 0x48, title_y, 0x52, 0xE, 0, 0x32);
    }
    sprite.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    sprite.End();
}
void CStartupEpisodeTitle::Switch(int on) {
    char   *title;
    ClsMes *current;
    int     title_width;
    u8     *floor_manager;
    int     floor_id;

    floor_manager = (u8 *) &DngMainScene->battle_area + 0x14;
    floor_id = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];

    if (on != 0) {
        mes->abs_win.x = 0x22;
        mes->abs_win.y = 0x154;
        mes->font_w = 0x12;
        title = ((CDngFloorManager *) floor_manager)->GetFloorTitle(floor_id);
        mes->MakeMesWin(title, 1, 1);
        title_width = (s16) mes->GetStrWidth(title);
        width = title_width - 2;

        if (width < 0x9A) {
            width = 0x9A;
        }

        mes->abs_win.x = (width / 2 + 0x24) - title_width / 2;
        mes->open = 1;
        alpha = 0;
        reveal = 0;
        slide = 0;
        wait = 0x3C;
    } else if (state != 0) {
        current = mes;
        current->draw_speed = current->GetDrawSpeedDef();
        current->mes_no = -1;
        current->text_ptr = 0;
        current->open = 0;
        current->fade = 0.0f;
        current->fukidashi_centre_x = -1;
        current->fukidashi_centre_y = -1;
    }

    state = on;
}

void CStartupEpisodeTitle::Step() {
    ClsMes *mes_win;
    int     top;

    if (mes == NULL || !state) {
        return;
    }

    if (state == 1) {
        alpha += 0.033333335f;

        if (!(alpha < 1.0f)) {
            alpha = 1.0f;
        }

        reveal += 0.033333335f;

        if (!(reveal < 1.0f)) {
            reveal = 1.0f;
        }

        if (!(alpha < 0.2f)) {
            slide += 0.025f;

            if (!(slide < 1.0f)) {
                slide = 1.0f;
                wait = 0x3C;
                state = 2;
            }
        }
    }

    if (state == 2) {
        wait -= 1;

        if (wait < 0) {
            state = 3;
        }
    }

    if (state == 3) {
        reveal -= 0.05f;

        if (reveal <= 0.0f) {
            reveal = 0.0f;
        }

        slide -= 0.05f;

        if (slide <= 0.0f) {
            slide = 0.0f;
        }

        if (reveal < 0.5f) {
            alpha -= 0.04f;

            if (alpha <= 0.0f) {
                mes_win = mes;
                mes_win->draw_speed = mes_win->GetDrawSpeedDef();
                mes_win->mes_no = -1;
                mes_win->text_ptr = 0;
                mes_win->open = 0;
                mes_win->fade = 0.0f;
                mes_win->fukidashi_centre_x = -1;
                mes_win->fukidashi_centre_y = -1;
                state = 0;
            }
        }
    }

    top = mgScreenHeight - 0x4C;
    mes->abs_win.y = (top + 0x15) - fptosi(22.0f * slide);
    mes_win = mes;
    mes_win->scissor_on = 2;
    mes_win->scissor.x = 1;
    mes_win->scissor.y = top - 2;
    mes_win->scissor.width = 0x1A0;
    mes_win->scissor.height = 0x15;
    mes->Step();
}

void CStartupEpisodeTitle::Initialize() {
    mes = NULL;
    state = 0;
    wait = 0;
}

void MessageTaskManager::Draw() {
    ClsMes *current;

    current = mes;

    if (current != NULL) {
        current->DrawMesWin();
    }
}

void MessageTaskManager::Step() {
    ClsMes       *current;
    MESSAGE_TASK *line;

    current = this->mes;

    if (current != NULL && !(this->flag & 1)) {
        line = this->top;

        if (line != NULL) {
            if (line->count <= 0) {
                current->fukidashi_pos = line->slot;
                this->mes->MakeMesWin(this->top->message,
                                      1, 1);
                this->mes->open = 1;
            }

            this->top->count += 1;
            this->top->time -= 1;

            if (this->top->time <= 0) {
                current = this->mes;
                current->draw_speed = current->GetDrawSpeedDef();
                current->mes_no = -1;
                current->text_ptr = 0;
                current->open = 0;
                current->fade = 0.0f;
                current->fukidashi_centre_x = -1;
                current->fukidashi_centre_y = -1;
                this->top->message = NULL;
                this->top = this->top->next;
            }

            this->mes->Step();
        }
    }
}

void MessageTaskManager::Print(char *message, int time, int slot, int priority) {
    MESSAGE_TASK *node;
    MESSAGE_TASK *head;
    MESSAGE_TASK *prev;
    MESSAGE_TASK *next;
    int           i;

    if (this->mes != NULL) {
        node = NULL;
        i = 0;

        do {
            if (task[i].message == NULL) {
                node = &task[i];
                break;
            }

            i += 1;
        } while (i < 6);

        if (node != NULL) {
            strcpy(node->text, message);
            node->message = node->text;
            node->priority = priority;
            node->slot = slot;
            node->time = time;
            node->count = 0;
            head = this->top;

            if (head == NULL) {
                this->top = node;
                node->next = NULL;
            } else if (priority < head->priority) {
                node->next = head;
                this->top = node;
            } else {
                prev = head;

                while ((next = prev->next) != NULL) {
                    if (priority < next->priority) {
                        node->next = next;
                        prev->next = node;
                        return;
                    }

                    prev = next;
                }

                prev->next = node;
                node->next = NULL;
            }
        }
    }
}

void MessageTaskManager::Clear() {
    ClsMes       *current;
    MESSAGE_TASK *line;

    current = this->mes;

    if (current != NULL) {
        line = this->top;

        if (line != NULL) {
            if (line->time > 0) {
                current->draw_speed = current->GetDrawSpeedDef();
                current->mes_no = -1;
                current->text_ptr = 0;
                current->open = 0;
                current->fade = 0.0f;
                current->fukidashi_centre_x = -1;
                current->fukidashi_centre_y = -1;
                this->mes->Step();
            }

            this->task[0].message = 0;
            this->task[0].message = 0;
            this->task[0].message = 0;
            this->task[0].message = 0;
            this->task[0].message = 0;
            this->task[0].message = 0;
            this->top = 0;
            this->flag = 0;
        }
    }
}

void MessageTaskManager::Initialize() {
    mes = NULL;
    top = NULL;
    flag = 0;
    task[0].message = NULL;
    task[0].priority = 0;
    task[0].time = 0;
    task[0].slot = 8;
    task[0].next = NULL;
    task[1].message = NULL;
    task[1].priority = 0;
    task[1].time = 0;
    task[1].slot = 8;
    task[1].next = NULL;
    task[2].message = NULL;
    task[2].priority = 0;
    task[2].time = 0;
    task[2].slot = 8;
    task[2].next = NULL;
    task[3].message = NULL;
    task[3].priority = 0;
    task[3].time = 0;
    task[3].slot = 8;
    task[3].next = NULL;
    task[4].message = NULL;
    task[4].priority = 0;
    task[4].time = 0;
    task[4].slot = 8;
    task[4].next = NULL;
    task[5].message = NULL;
    task[5].priority = 0;
    task[5].time = 0;
    task[5].slot = 8;
    task[5].next = NULL;
}

void CRedMarkModel::Draw() {
    float position[4];
    float saved_position[4];

    if (draw_request != 0) {
        GetPosition(position);
        GetPosition(saved_position);
        position[1] += 2.0f * sinf(angle);
        SetPosition(position);
        CObjectFrame::DrawDirect();
        SetPosition(saved_position);
        draw_request = 0;
    }
}

void CRedMarkModel::Step() {
    float next;

    angle += 0.19634955f;
    next = angle;

    if (!(next <= 0.0f)) {
        angle = next - 3.1415927f;
    }
}

void CGeoStone::GeoDraw(float *view_pos) {
    float home_position[4];
    float draw_position[4];

    if (this->flag != 0) {
        GetPosition(home_position);
        GetPosition(draw_position);

        if (mgDistVector(view_pos, draw_position) < 1000.0f || this->anime == 0) {
            if (this->anime != 0) {
                draw_position[1] += 3.0f * sinf(this->angle);
            }

            SetPosition(draw_position);
            CCharacter2::DrawDirect();
        }

        SetPosition(home_position);
    }
}

void CGeoStone::DrawMiniMapSymbol(CMiniMapSymbol *symbol_drawer) {
    float position[4];

    if (this->flag != 0) {
        GetPosition(position);
        (symbol_drawer)->DrawSymbol(position, 3);
    }
}

void CGeoStone::SetFlag(int flag) {
    float      query[4];
    CMapParts *object;

    this->flag = flag;

    if (this->flag == 0 && (object = AutoMapGen.gio_parts) != NULL) {
        *(u_long128 *) query = *(u_long128 *) at_1082__2;
        object->SetPosition(query);
    }
}

void CGeoStone::GeoStep() {
    float next;

    if (this->flag != 0) {
        CCharacter2::Step();
        this->angle += 0.05235988f;
        next = this->angle;

        if (!(next <= 3.1415927f)) {
            this->angle = next - 6.2831855f;
        }
    }
}

int CGeoStone::CheckEvent(float *pos) {
    float position[4];

    if (this->flag == 0) {
        return 0;
    }

    GetPosition(position);
    position[1] -= 20.0f;

    if (mgDistVector(pos, position) <= 30.0f) {
        return 1;
    }

    return 0;
}

void CGeoStone::Initialize() {
    CCharacter2::Initialize();
    this->flag = 0;
}

void CRandomCircle::Draw(float *view_pos) {
    int id;

    id = 0;

    do {
        if (active[id] != 0 && mgDistVector(view_pos, this->pos[id]) < 1000.0f) {
            model.SetPosition(this->pos[id]);
            model.SetRotation(0.0f, 0.0f, 0.0f);
            model.DrawDirect();
        }

        id += 1;
    } while (id < 3);
}

void CRandomCircle::Step() {
    model.Step();
}

void CRandomCircle::DrawSymbol(CMiniMapSymbol *mini_map) {
    int id;

    id = 0;

    do {
        if (active[id] != 0) {
            mini_map->DrawSymbol(this->pos[id], 2);
        }

        id += 1;
    } while (id < 3);
}

int CRandomCircle::CheckArea(float *pos, float radius) {
    int id;

    id = 0;
loop:
    if (active[id] != 0 && mgDistVector(this->pos[id], pos) < radius) {
        return 0;
    }
    id += 1;

    if (id >= 3) {
        return 1;
    }

    goto loop;
}

int CRandomCircle::GetPosition(float *out_pos, int index) {
    if (index == -1) {
        if (this->hit == -1) {
            return 0;
        }

        sceVu0CopyVector(out_pos, this->pos[this->hit]);
        return 1;
    }

    if (index < 0 || index >= 3) {
        return 0;
    }

    sceVu0CopyVector(out_pos, this->pos[index]);
    return 1;
}

int CRandomCircle::CheckEvent(float *pos) {
    int id;

    id = 0;
next_circle:
    if (active[id] != 0 && mgDistVector(this->pos[id], pos) <= 20.0f) {
        hit = id;
        return id;
    }
    id += 1;

    if (id >= 3) {
        hit = -1;
        return -1;
    }

    goto next_circle;
}

int CRandomCircle::SetCircle(float *pos) {
    int id;

    id = 0;
loop:
    if (active[id] == 0) {
        sceVu0CopyVector(this->pos[id], pos);
        this->pos[id][3] = 1.0f;
        this->active[id] = 1;
        return id;
    }
    id += 1;

    if (id >= 3) {
        return -1;
    }

    goto loop;
}

void CRandomCircle::Clear() {
    active[0] = 0;
    active[1] = 0;
    active[2] = 0;
    hit = -1;
}

void CRandomCircle::Initialize() {
    model.Initialize();
    this->active[0] = 0;
    this->active[1] = 0;
    this->active[2] = 0;
    this->hit = -1;
}

void CTreasureBox::Draw(float *view_pos) {
    float position[4];
    float rotation[4];

    if (this->frame != NULL) {
        this->GetPosition(position);
        this->GetRotation(rotation);
        this->lid_frame->SetRotation(45.0f * (-3.1415927f * this->lid_open / 180.0f), 0.0f, 0.0f);
        this->lid_frame->SetPosition(0.0f, 9.0f, -7.4f);

        if (mgDistVector(view_pos, position) < 1000.0f) {
            this->model->SetPosition(position);
            this->model->SetRotation(rotation);
            this->model->DrawDirect();
        }
    }
}

void CTreasureBox::DrawShadow(float *view_pos, float *light_direction) {
    float position[4];
    float shadow_position[4];
    float rotation[4];
    float up[4];

    if (this->model != NULL) {
        *(DngEventVector *) up = *(DngEventVector *) at_1248;
        this->GetPosition(shadow_position);
        shadow_position[1] -= 20.0f;
        mgSetDropShadowMatrix(light_direction, shadow_position, up);
        this->GetPosition(position);
        position[1] += 2.0f;
        this->GetRotation(rotation);

        if (mgDistVector(view_pos, position) < 1000.0f) {
            this->model->SetPosition(position);
            this->model->SetRotation(rotation);
            this->model->DrawShadowDirect();
        }
    }
}

void CTreasureBoxManager::SetLargeModel(CCharacter2 *model, int value) {
    mgCFrame     *frame;
    mgCFrame     *found;
    CTreasureBox *entry;
    int           i;

    this->tex_block = value;
    this->model = model;
    frame = model->CObjectFrame::frame;

    if (frame != NULL) {
        found = frame->SearchFrame(at_1274__2);

        if (found != NULL) {
            entry = box;

            for (i = 0; i < 0x18; i++) {
                entry->lid_frame = found;
                entry->frame = frame;
                entry->model = model;
                entry++;
            }
        }
    }
}

void CTreasureBoxManager::SetCollisionModel(u32 *pack, mgCMemory *memory) {
    col_frame = LoadCollisionFile((MDS_HEADER *) GetPackFile(pack, at_1279__2, NULL), memory);
}

void CTreasureBoxManager::PutTreasureBox(int index, float *pos, float rot_y, int flags, int item0, int num0, int item1, int num1) {
    int           i;
    CTreasureBox *chest;

    if (index == -1) {
        i = 0;

        do {
            chest = &this->box[i];

            if (chest->state == 0) {
                index = i;
                break;
            }

            i += 1;
        } while (i < 0x18);
    }

    if (index < 0 || index >= 0x18) {
        return;
    }

    chest = &this->box[index];
    chest->state = 1;
    chest->SetPosition(pos);
    chest->SetRotation(0.0f, rot_y, 0.0f);
    chest->flags = flags;
    chest->item[0] = item0;
    chest->item[1] = item1;
    chest->num[0] = num0;
    chest->num[1] = num1;
}

int CTreasureBoxManager::CheckArea(float *pos, float radius) {
    float         chest_pos[4];
    int           i;
    CTreasureBox *slot;

    i = 0;
loop:
    slot = &this->box[i];

    if (slot->state != 0) {
        slot->GetPosition(chest_pos);

        if (mgDistVector(chest_pos, pos) < radius) {
            return 0;
        }
    }

    i += 1;

    if (i >= 0x18) {
        return 1;
    }

    goto loop;
}

void CTreasureBoxManager::DrawMiniMapSymbol(CMiniMapSymbol *symbol_drawer) {
    float         chest_pos[4];
    int           i;
    CTreasureBox *slot;

    i = 0;

    do {
        slot = &this->box[i];

        if (slot->state == 1) {
            slot->GetPosition(chest_pos);
            (symbol_drawer)->DrawSymbol(chest_pos, 1);
        }

        i += 1;
    } while (i < 0x18);
}

void CTreasureBoxManager::Draw(float *view_pos) {
    int           i;
    CTreasureBox *slot;

    i = 0;

    do {
        slot = &this->box[i];

        if (slot->state != 0) {
            (slot)->Draw(view_pos);
        }

        i += 1;
    } while (i < 0x18);
}

void CTreasureBoxManager::DrawShadow(float *view_pos) {
    float light_direction[4][4];
    float light_color[4][4];
    mgGetLight(light_direction, light_color);
    float shadow_direction[4] = {light_direction[0][0], light_direction[1][0], light_direction[2][0]};
    shadow_direction[1] = shadow_direction[1] < 0.0f ? -shadow_direction[1] : shadow_direction[1];

    if (shadow_direction[1] < 0.8f) {
        shadow_direction[1] = 0.8f;
    }

    int           i;
    CTreasureBox *slot;

    i = 0;

    do {
        slot = &this->box[i];

        if (slot->state != 0) {
            slot->DrawShadow(view_pos, shadow_direction);
        }

        i += 1;
    } while (i < 0x18);
}

int CTreasureBoxManager::PickupCollision(float *pos, CCPoly *polys, mgVu0FBOX box, int flag) {
    int           count;
    int           i;
    CTreasureBox *slot;
    float         chest_pos[4];
    float         rotation[4];

    i = 0;
    count = 0;

    do {
        slot = &this->box[i];

        if (slot->state != 0) {
            slot->GetPosition(chest_pos);

            if (mgDistVector(chest_pos, pos) <= 40.0f) {
                this->col_frame->SetPosition(chest_pos);
                slot->GetRotation(rotation);
                this->col_frame->SetRotation(rotation);
                count += this->col_frame->PickUpNearPoly(polys + count, *(&box), flag);
            }
        }

        i += 1;
    } while (i < 0x18);

    return count;
}

int CTreasureBoxManager::MimicCount() {
    int           count;
    int           i;
    CTreasureBox *slot;

    count = 0;
    i = 0;

    do {
        slot = &this->box[i];

        if (slot->state == 1 && (slot->flags & 0x100)) {
            count += 1;
        }

        i += 1;
    } while (i < 0x18);

    return count;
}

int CTreasureBoxManager::CheckEvent(float *pos, float dist) {
    float         chest_pos[4];
    float         nearest;
    int           i;
    CTreasureBox *slot;
    float         distance;

    this->near_box = -1;
    nearest = 9999.0f;
    i = 0;

    do {
        slot = &this->box[i];

        if (slot->state == 1) {
            slot->GetPosition(chest_pos);
            distance = mgDistVector(chest_pos, pos);

            if (distance < dist && nearest > distance) {
                nearest = distance;
                this->near_box = i;
            }
        }

        i += 1;
    } while (i < 0x18);

    return this->near_box;
}

int GetGateKeyIndex(int floor, int level) {
    if (floor == 4 && level >= 0x11) {
        return 0x159;
    }

    return gatekey_index[floor];
}

int GetKeyDoorIndex(int floor, int level) {
    if (floor == 4 && level >= 0x11) {
        return 0x15B;
    }

    return keydoor_key_index[floor];
}

int Lamb2WolfManager() {
    CBattleCharaInfo *info;
    int               form;
    CActionChara     *chara;
    mgCFrame         *wolf;
    mgCFrame         *lamb;
    mgCFrame         *object;
    float             rotation[4];

    info = GetBattleCharaInfo();

    if (info->chr_no != 1) {
        return -1;
    }

    form = *(s16 *) ((u8 *) info->equip + 2);

    if (form != 0x38 && form != 0x58) {
        return -1;
    }

    chara = (CActionChara *) DngMainScene->GetCharacter(0);

    if (chara == NULL) {
        return -1;
    }

    if (form == 0x58) {
        object = chara->SearchObject(at_1466__5);

        if (object != NULL) {
            object->GetRotation(rotation);
            rotation[1] += 0.27925268f;
            rotation[1] = mgAngleLimit(rotation[1]);
            object->SetRotation(rotation);
        }

        return 0;
    }

    lamb = chara->SearchObject(at_1467__5);
    wolf = chara->SearchObject(at_1468__5);

    if (lamb == NULL || wolf == NULL) {
        return -1;
    }

    if (GetTimeBand(DngMainScene->time) == 2) {
        lamb->SetAttrParamDraw(0, 0);
        wolf->SetAttrParamDraw(1, 0);
        return 1;
    }

    lamb->SetAttrParamDraw(1, 0);
    wolf->SetAttrParamDraw(0, 0);
    return 0;
}

void LoopSoundManager(int sound_id) {
    (void) sound_id;
}

void BattleSoundManager() {
    BattleAreaBGMCtrl();
    StatusWarningSnd();
}

void StatusWarningSnd() {
    CBattleCharaInfo *info;
    float             ratio;

    if (!(DngMainScene->battle_area.pause_flag & 0x400)) {
        if (counter_1489 < 0x14) {
            counter_1489 += 1;
        } else {
            counter_1489 = 0;
            info = GetBattleCharaInfo();
            ratio = (float) info->GetNowHp_i();
            ratio /= (float) info->GetMaxHp_i();

            if (ratio > 0.0f && ratio < 0.3f) {
                sndSePlay(((CScene *) DngMainScene)->se_battle_id, 10, 0);

                if (ratio < 0.15f) {
                    counter_1489 = 10;
                }
            }
        }
    }
}

void BattleAreaBGMCtrl() {
    void            *player;
    DNG_BATTLE_AREA *state;
    float            distance;
    int              phase;
    float            fade;
    float            rate;
    CScene          *scene;

    state = (&DngMainScene->battle_area);
    player = DngMainScene->GetCharacter(0);

    if (dngGetDebugInfo()->sound_flag == 0) {
        sndSeStop(EdEventInfo.snd_id[4], 0, 0);
        return;
    }

    distance = 9999999.0f;

    if (ActiveMonster != NULL) {
        distance = ActiveMonster->IsBattleStyleDist();
    }

    if (distance <= 340.0f) {
        *(s16 *) ((u8 *) player + 0x75E) = 1;
    } else {
        *(s16 *) ((u8 *) player + 0x75E) = 0;
    }

    if (!(state->pause_flag & 0x4000) && state->boss_map == 0) {
        phase = state->battle_bgm_state;
        fade = state->battle_bgm_vol;

        if (phase == 0) {
            if (!(340.0f < distance)) {
                state->battle_bgm_state = 1;
            }
        }

        if (phase == 2) {
            if (400.0f <= distance) {
                state->battle_bgm_state = 3;
            }
        }

        switch (phase) {
            case 1:
                fade += 0.05f;

                if (!(fade < 1.0f)) {
                    state->battle_bgm_state = 2;
                    fade = 1.0f;
                    sndSePlay(EdEventInfo.snd_id[4], 0, 0);
                    DngMainScene->PauseBGM();
                }

                scene = DngMainScene;
                DngMainScene->GetActiveBgmInfo()->master_volf = 1.0f - fade;
                scene->SetVolfBGM(scene->GetActiveBgmInfo()->volf);
                state->battle_bgm_vol = fade;
                return;
            case 3:
                fade -= 0.016666668f;

                if (fade <= 0.0f) {
                    state->battle_bgm_state = 4;
                    fade = 0.0f;
                    sndSeStop(EdEventInfo.snd_id[4], 0, 0);
                    DngMainScene->RePlayBGM();
                    scene = DngMainScene;
                    DngMainScene->GetActiveBgmInfo()->master_volf = 0.0f;
                    scene->SetVolfBGM(scene->GetActiveBgmInfo()->volf);
                } else {
                    sndSetSeVolf(EdEventInfo.snd_id[4], 0, fade, 0);
                }

                state->battle_bgm_vol = fade;
                return;
            case 4:
                rate = DngMainScene->GetActiveBgmInfo()->master_volf;
                rate += 0.033333335f;

                if (!(rate < 1.0f)) {
                    state->battle_bgm_state = 0;
                    rate = 1.0f;
                }

                scene = DngMainScene;
                DngMainScene->GetActiveBgmInfo()->master_volf = rate;
                scene->SetVolfBGM(scene->GetActiveBgmInfo()->volf);
                break;
        }
    }
}

void ScriptDebugCommand(int command) {
    CBattleCharaInfo *info;

    info = GetBattleCharaInfo();

    switch (command) {
        case 0:
            info->AddHp_Point(512.0f, -1.0f);
            info->ForceSet();
            break;
    }
}

void XChgMapLighting() {
    int       saved[0x74];
    int       i;
    CMapInfo *map;
    int       byte_offset;

    map = (CMapInfo *) DngMainScene->GetMap(DngMainScene->active_map);

    if ((map != NULL) && (map != NULL) && (map->lighting_info_num >= 0x10)) {
        memset(saved, 0, 0x1D0);
        i = 0;
        byte_offset = 0;

        do {
            memcpy(saved, (u8 *) map->lighting_info + byte_offset, 0x1D0);
            memcpy((u8 *) map->lighting_info + byte_offset,
                   (u8 *) map->lighting_info + byte_offset + 0xE80, 0x1D0);
            memcpy((u8 *) map->lighting_info + byte_offset + 0xE80, saved, 0x1D0);
            i += 1;
            byte_offset += 0x1D0;
        } while (i < 8);
    }
}

float XChgMapRotation(int index) {
    if (index < 0 || index > 3) {
        return 0.0f;
    }

    return xchg_rot_list[index];
}

int SearchMapEventParts(int kind, CMapParts **parts, float *rotation, int unused) {
    char       name[0x40];
    int        result;
    CMap      *map;
    CMapParts *found;
    int        i;

    result = 0;

    if ((map = DngMainScene->GetMap(DngMainScene->active_map)) == NULL) {
        return 0;
    }

    switch (kind) {
        case 0:
            for (i = 0; i < 4; i++) {
                sprintf(name, at_1645, i + 0x20);
                found = (CMapParts *) (map)->GetPlaceParts(name);

                if (found != NULL) {
                    parts[0] = found;
                    *rotation = XChgMapRotation(i);
                    result = 1;
                    parts[1] = NULL;
                    break;
                }
            }

            break;
        case 2:
            for (i = 0; i < 0x10; i++) {
                sprintf(name, at_1645, i + 0x24);
                found = (CMapParts *) (map)->GetPlaceParts(name);

                if (found != NULL) {
                    parts[0] = found;
                    *rotation = XChgMapRotation(i);
                    result = 1;
                    parts[1] = NULL;
                    break;
                }
            }

            break;
        case 1:
            break;
    }

    return result;
}
int SearchMapFlatPosition(sceVu0FVECTOR out_pos, CAutoMapGen *map_gen) {
    float center[4];
    float from[4];
    float to[4];
    CCPoly polys[128];
    mgVu0FBOX box;
    int hit_polys[32];
    float hit_points[32][4];
    float found[4];
    CMapParts *parts;
    int place_num;
    int poly_num;
    CMapParts *place_parts;
    int tries_left;
    int attempt;
    CMap *map;
    int hit_num;
    int attr;
    int axis;
    CMap *const scene_map = DngMainScene->GetMap(DngMainScene->active_map);
    if ((map = scene_map) == NULL) {
        return 0;
    }
    place_parts = scene_map->GetPlacPartsTable(&place_num);
    if (place_parts == NULL) {
        return 0;
    }
    if (place_num <= 0) {
        return 0;
    }
    CMapParts *placed = place_parts;
    place_num = 0;
    while ((placed->name[0] == 0) == 0) {
        placed++;
        place_num++;
    }
    tries_left = 999;
    box.min[3] = box.max[3] = center[3] = from[3] = to[3] = 1.0f;
    while (1) {
        parts = &place_parts[iRand(place_num)];
        attr = 0;
        if (map_gen != NULL) {
            CAutoMapParts *cell = map_gen->grid;
            for (int i = 0; i < map_gen->grid_w * map_gen->grid_h; i++) {
                if (cell->parts_no >= 0 && cell->parts == parts) {
                    attr = cell->attr;
                    break;
                }
                cell++;
            }
        }
        if (attr & AUTOMAP_ATTR_HIDE) {
            continue;
        }
        parts->GetPosition(center);
        for (axis = 0; axis < 3; axis++) {
            if (axis == 1) {
                box.max[axis] = 4160.0f + center[axis];
                box.min[axis] = center[axis] - 4160.0f;
            } else {
                box.max[axis] = 100.0f + center[axis];
                box.min[axis] = center[axis] - 100.0f;
            }
        }
        poly_num = map->GetColPoly(polys, box, 0x80);
        for (attempt = 0; attempt < 16; attempt++) {
            sceVu0CopyVector(from, center);
            from[0] += fRand(320.0f) - 160.0f;
            from[2] += fRand(320.0f) - 160.0f;
            sceVu0CopyVector(to, from);
            from[1] += 4200.0f;
            to[1] -= 4200.0f;
            hit_num = CheckHits(polys, poly_num, from, to, 0x20, hit_polys, hit_points, 0, 0);
            for (int i = 0; i < hit_num; i++) {
                short area_kind = polys[hit_polys[i]].area_kind;
                if (area_kind == 0xB) {
                    break;
                }
                if (area_kind == 5) {
                    sceVu0CopyVector(from, hit_points[i]);
                    sceVu0CopyVector(to, hit_points[i]);
                    from[1] += 10.0f;
                    to[1] -= 10.0f;
                    if (CheckHit(polys, poly_num, from, to, found, 1, 1) >= 0) {
                        sceVu0CopyVector(out_pos, found);
                        out_pos[3] = 1.0f;
                        return 1;
                    }
                }
            }
        }
        if (tries_left < 0) {
            printf(at_1732__2);
            return 0;
        }
        tries_left--;
    }
}
int GetDungeonEventPoint(float *out_pos, float *out_rot, int kind) {
    float euler[4];
    if (kind == DUNGEON_EVENT_POINT_PLAYER) {
        CCharacter2 *player = DngMainScene->GetCharacter(0);
        if (player == NULL) {
            return 0;
        }
        player->GetPosition(out_pos);
        out_pos[0] = (int)((80.0f + out_pos[0]) / 160.0f) * 160;
        out_pos[1] = 0;
        out_pos[2] = (int)((80.0f + out_pos[2]) / 160.0f) * 160;
        *out_rot = 0;
    }
    if (kind == DUNGEON_EVENT_POINT_WAY_20) {
        CMapParts *parts[8];
        float rotation[8];
        CMap *map = DngMainScene->GetMap(DngMainScene->active_map);
        if (map == NULL) {
            return 0;
        }
        if (SearchMapEventParts(0, parts, rotation, 8) <= 0) {
            return 0;
        }
        CMapParts *found = parts[0];
        found->GetPosition(out_pos);
        *out_rot = rotation[0];
        CSceneEventData *event = &DngMainScene->event_data;
        event->map_event.parts_no = map->ConvertParts(found);
        EdEventInfo.dng_event_parts = found;
        EdEventInfo.dng_event_found = 1;
    }
    if (kind == DUNGEON_EVENT_POINT_WAY_24) {
        CMapParts *parts[16];
        float rotation[16];
        CMap *map = DngMainScene->GetMap(DngMainScene->active_map);
        if (map == NULL) {
            return 0;
        }
        if (SearchMapEventParts(2, parts, rotation, 0x10) <= 0) {
            return 0;
        }
        CMapParts *found = parts[0];
        found->GetPosition(out_pos);
        *out_rot = rotation[0];
        CSceneEventData *event = &DngMainScene->event_data;
        event->map_event.parts_no = map->ConvertParts(found);
        EdEventInfo.dng_event_parts = found;
        EdEventInfo.dng_event_found = 1;
    }
    if (kind == DUNGEON_EVENT_POINT_TREASURE_BOX) {
        DNG_BATTLE_AREA *area = &DngMainScene->battle_area;
        if (area == NULL) {
            return 0;
        }
        CTreasureBoxManager *boxes = area->treasure_box;
        if (boxes == NULL) {
            return 0;
        }
        int near_box = boxes->near_box;
        int box_no = near_box;
        CTreasureBox *box = &boxes->box[box_no];
        if (box == NULL) {
            return 0;
        }
        box->GetPosition(out_pos);
        box->GetRotation(euler);
        *out_rot = euler[1];
    }
    return 1;
}
/**
 *
 * Begins a treasure box group list for the current floor.
 *
 */
int _GROUP_START(SPI_STACK *stack, int argc) {
    spiGetStackInt(stack);
    nowTbFloor->group_num = -1;
    return 1;
}

/**
 *
 * Adds a treasure box item group to the current floor.
 *
 */
int _GROUP(SPI_STACK *stack, int argc) {
    int first;
    int second;

    first = spiGetStackInt(stack++);
    second = spiGetStackInt(stack);
    nowTbFloor->group_num += 1;
    nowTbFloor->group[nowTbFloor->group_num].group_id = first;
    nowTbFloor->group[nowTbFloor->group_num].item_num = second;
    nowTboxGroup = nowTbFloor->group_num;
    nowTboxItemCnt = 0;
    return 1;
}

/**
 *
 * Adds weighted items to the current treasure box group.
 *
 */
int _ITEM(SPI_STACK *stack, int argc) {
    int i;
    int id;
    int value;
    int weight;

    for (i = 0; i < argc / 3; i++) {
        id = spiGetStackInt(stack++);
        value = spiGetStackInt(stack++);
        weight = spiGetStackInt(stack++);
        nowTbFloor->group[nowTboxGroup].item[nowTboxItemCnt].item_no = id;
        nowTbFloor->group[nowTboxGroup].item[nowTboxItemCnt].rank = value;
        nowTbFloor->group[nowTboxGroup].item[nowTboxItemCnt].num = weight;
        nowTboxItemCnt += 1;
    }

    return 1;
}

/**
 *
 * Sets the first floor number for treasure box information.
 *
 */
int _FLOOR_START(SPI_STACK *stack, int argc) {
    nowTbFloor->floor_start = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Assigns treasure box groups to a dungeon floor.
 *
 */
int _FLOOR(SPI_STACK *stack, int argc) {
    int count;
    int i;
    int floor;

    floor = spiGetStackInt(stack++);
    count = spiGetStackInt(stack++);
    nowTbFloor->floor[floor].group_num = count;

    for (i = 0; i < count; i++) {
        nowTbFloor->floor[floor].group_id[i] = spiGetStackInt(stack++);
    }

    return 1;
}

void CreatTresuarBoxInfo(TRESURE_BOX_FLOOR_INFO *table, char *script, int length) {
    table->group_num = 0;
    table->floor_start = 0;
    table->rank_max = 0;
    table->rank_min = 100;
    nowTbFloor = table;
    CScriptInterpreter interpreter;

    (interpreter).SetTag(tag__5);
    (interpreter).SetScript(script, length);
    (interpreter).Run();
    table->group_num += 1;
}

void PickupRandomItemCheckMax(TRESURE_BOX_FLOOR_INFO *table, int floor_index) {
    TRESURE_BOX_GROUP *group;
    int                count;
    int                i;
    int                j;
    int                id;
    TRESURE_BOX_ITEM  *entry;
    table->rank_max = 0;
    table->rank_min = 0;
    count = table->floor[floor_index].group_num;

    for (i = 0; i < count; i++) {
        id = table->floor[floor_index].group_id[i];
        group = table->group;

        while (1) {
            if (group->group_id == id) {
                break;
            }

            group++;
        }

        for (j = 0; j < group->item_num; j++) {
            if (group->item[j].rank > table->rank_max) {
                table->rank_max = group->item[j].rank;
            }

            if (group->item[j].rank < table->rank_min) {
                table->rank_min = group->item[j].rank;
            }
        }
    }
}

TRESURE_BOX_ITEM *PickupRandomItem(TRESURE_BOX_FLOOR_INFO *table, int floor_index, int value) {
    int                want_higher;
    TRESURE_BOX_GROUP *group;
    TRESURE_BOX_ITEM  *entry;
    int                i;
    int                id;

    want_higher = 1;

    if (value < 0) {
        want_higher = 0;
        value = -value;
    }

    if (table->rank_max < value) {
        value = table->rank_max;
    }

    if (value < table->rank_min) {
        value = table->rank_min;
    }

    while (1) {
        id = table->floor[floor_index].group_id[iRand(table->floor[floor_index].group_num)];
        group = table->group;
        i = 0;

        do {
            if (group->group_id == id) {
                goto found;
            }

            i++;
            group++;
        } while (i < table->group_num);

        printf(at_1905__2, i);

        while (1) {
        }

    found:
        entry = &group->item[iRand(group->item_num)];

        if (want_higher) {
            if (entry->rank >= value) {
                return entry;
            }
        } else if (entry->rank <= value) {
            return entry;
        }
    }
}

int CheckObjectPutArea(float *pos) {
    float      position[4];
    CMapParts *object;

    if (!DngMainScene->battle_area.treasure_box->CheckArea(pos, 40.0f)) {
        return 0;
    }

    if (!RandomCircle.CheckArea(pos, 40.0f)) {
        return 0;
    }

    if ((object = AutoMapGen.gio_parts) != NULL) {
        object->GetPosition(position);
        position[3] = 1.0f;

        if (mgDistVector(position, pos) < 40.0f) {
            return 0;
        }
    }

    return (AutoMapGen.SearchRandomStone(pos, 40.0f) != NULL) ^ 1;
}

float ScanEyePoint(float *eye_pos) {
    float     position[4];
    float     hit[4];
    CCPoly    polys[0x80];
    mgVu0FBOX box;
    float     direction[4];
    float     rotated[4];
    float     rotation[4][4];
    float     identity[4][4];
    float     angle;
    CMap     *map;
    int       poly_count;
    int       i;
    float     z;

    angle = 0.0f;
    sceVu0CopyVector(position, eye_pos);
    position[1] += 20.0f;
    map = DngMainScene->GetMap(DngMainScene->active_map);

    if (map == NULL) {
        return angle;
    }

    box.max[0] = 200.0f + position[0];
    box.min[0] = position[0] - 200.0f;
    box.max[1] = 200.0f + position[1];
    box.min[1] = position[1] - 200.0f;
    z = position[2];
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    box.max[2] = 200.0f + z;
    box.min[2] = z - 200.0f;
    poly_count = map->GetColPoly(polys, box, 0x80);
    *(DngEventVector *) direction = *(DngEventVector *) at_1936__2;
    sceVu0UnitMatrix(identity);
    i = 0;

    while (1) {
        sceVu0RotMatrixY(rotation, identity, angle);
        sceVu0ApplyMatrix(rotated, rotation, direction);
        rotated[0] += position[0];
        rotated[2] += position[2];

        if (CheckHit(polys, poly_count, position, rotated, hit, 0, 0) < 0) {
            return angle;
        }

        printf(at_1965__2, position[0], position[2]);
        angle += 0.3926991f;
        angle = mgAngleLimit(angle);
        i++;

        if (i >= 0x10) {
            return angle;
        }
    }
}

void AutoSetTreasureBox(int id, float *position, float power) {
    (DngMainScene->battle_area.treasure_box)->PutTreasureBox(-1, position, power, 0x41, id, 1, -1, 0);
}

extern char at_2159[];
void AutoSetTreasureBox(void) {
    DNG_BATTLE_AREA *area = &DngMainScene->battle_area;
    CTreasureBoxManager *manager = DngMainScene->battle_area.treasure_box;
    int stage = DngSaveDataDungeon->stage_id;
    u32 floor = DngSaveDataDungeon->floor_id[stage];
    float event_pos[4];
    float event_rot;
    float angle;
    int box;
    int i;

    GetDungeonEventPoint(event_pos, &event_rot, 2);
    event_pos[3] = 1.0f;
    mgCMemory stack;
    char path[0x40];
    float pos[4];
    float mimic_pos[4];
    int size;
    sprintf(path, at_2159, stage + 1);
    LoadFile(path, BuffReadData, &size);
    stack.stSetBuffer(BuffReadData + size / 16 + 1, 0x4000);
    TRESURE_BOX_FLOOR_INFO *info = new (stack.Alloc(0x1A43)) TRESURE_BOX_FLOOR_INFO;
    CreatTresuarBoxInfo(info, (char *)BuffReadData, size);
    PickupRandomItemCheckMax(info, floor);

    for (box = 0; box < 8; box++) {
        int searching = 1;
        while (searching) {
            if (SearchMapFlatPosition(pos, &AutoMapGen) && !(mgDistVector(event_pos, pos) <= 320.0f) &&
                manager->CheckArea(pos, 60.0f)) {
                angle = (2.0f * (3.1415927f * (float)rand())) / 2.1474836e9f - 3.1415927f;
                int flags;
                int num0 = 1;
                int item0 = 0;
                int item1 = -1;
                int num1 = 1;
                if (box < 2) {
                    if (box == 0) {
                        item0 = 0x132;
                    }
                    if (box == 1) {
                        item0 = 0x131;
                    }
                    flags = 0x41;
                } else {
                    int roll = iRand(100);
                    flags = 1;
                    if (roll > 92) {
                        flags = 2;
                    }
                    if (roll > 96) {
                        flags = 4;
                    }
                    switch (iRand(3)) {
                    default:
                        flags |= 8;
                        break;
                    case 1:
                        flags |= 0x10;
                        break;
                    case 2:
                        flags |= 0x20;
                        break;
                    }
                    roll = iRand(100);
                    int kind = 0x40;
                    if (roll > 94) {
                        kind = 0x200;
                    }
                    if (roll > 96) {
                        kind = 0x80;
                    }
                    flags |= kind;
                    if (flags & 0x80) {
                        TRESURE_BOX_ITEM *item = PickupRandomItem(info, floor, 60);
                        item0 = item->item_no;
                        num0 = item->num;
                        item = PickupRandomItem(info, floor, -50);
                        item1 = item->item_no;
                        num1 = item->num;
                        angle = ScanEyePoint(pos);
                    } else {
                        TRESURE_BOX_ITEM *item;
                        if (flags & 2) {
                            item = PickupRandomItem(info, floor, -30);
                        } else {
                            item = PickupRandomItem(info, floor, (iRand(100) + iRand(100)) / 2);
                        }
                        item0 = item->item_no;
                        num0 = item->num;
                    }
                }
                if (num0 >= 3 && num0 < 10) {
                    num0 += iRand(3) - 1;
                }
                if (num0 >= 10) {
                    num0 = (int)(0.8f * (float)num0 + fRand(0.4f * (float)num0) + 0.5f);
                }
                if (num1 >= 3 && num1 < 10) {
                    num1 += iRand(3) - 1;
                }
                if (num1 >= 10) {
                    num1 = (int)(0.8f * (float)num1 + fRand(0.4f * (float)num1) + 0.5f);
                }
                manager->PutTreasureBox(-1, pos, angle, flags, item0, num0, item1, num1);
                searching = 0;
            }
        }
    }

    for (i = 0; i < ActiveMonster->locate.num; i++) {
        int monster_id = ActiveMonster->locate.monster_id[i];
        if (monster_id >= 0xF5 && monster_id < 0x10D) {
            int placed = 0;
            int param = ActiveMonster->locate.param[i];
            do {
                if (SearchMapFlatPosition(mimic_pos, &AutoMapGen) && !(mgDistVector(event_pos, mimic_pos) <= 320.0f) &&
                    CheckObjectPutArea(mimic_pos)) {
                    manager->PutTreasureBox(-1, mimic_pos,
                                            (2.0f * (3.1415927f * (float)rand())) / 2.1474836e9f - 3.1415927f,
                                            0x101, monster_id, param, -1, 0);
                    placed = 1;
                }
            } while (placed == 0);
        }
    }

    int circle_num = 0;
    if (iRand(100) > 75) {
        circle_num++;
    }
    if (iRand(100) > 80) {
        circle_num++;
    }
    if (iRand(100) > 90) {
        circle_num++;
    }
    for (int circle = 0; circle < circle_num; circle++) {
        int retry = 0;
        while (1) {
            if (!SearchMapFlatPosition(pos, &AutoMapGen)) {
                break;
            }
            if (mgDistVector(event_pos, pos) <= 320.0f) {
                continue;
            }
            if (CheckObjectPutArea(pos)) {
                RandomCircle.SetCircle(pos);
                break;
            }
            retry++;
            if (retry > 100) {
                break;
            }
        }
    }

    int geo_stone = area->floor_manager.IsGeoStone(floor);
    if (geo_stone && (DngSaveDataDungeon->GetFloorInfoPtr(stage, floor)->flag & DNG_FLOOR_FLAG_GEOSTONE_FOUND)) {
        geo_stone = 0;
    }
    while (geo_stone) {
        if (!SearchMapFlatPosition(pos, &AutoMapGen)) {
            break;
        }
        if (CheckObjectPutArea(pos) && !(mgDistVector(event_pos, pos) <= 320.0f)) {
            pos[1] += 20.0f;
            pos[3] = 1.0f;
            CGeoStone *stone = &GeoStone;
            stone->SetPosition(pos);
            stone->angle = 0.0f;
            stone->flag = 1;
            stone->anime = 1;
            if (AutoMapGen.gio_parts != NULL) {
                AutoMapGen.gio_parts->SetPosition(pos);
            }
            break;
        }
    }

    for (int stone_no = 0; stone_no < 12 && AutoMapGen.random_stone[stone_no] != NULL;) {
        if (!SearchMapFlatPosition(pos, &AutoMapGen)) {
            break;
        }
        if (CheckObjectPutArea(pos) && !(mgDistVector(event_pos, pos) <= 320.0f)) {
            AutoMapGen.random_stone[stone_no]->SetPosition(pos);
            stone_no++;
        }
    }

    while (AutoMapGen.door_room >= 0) {
        if (!SearchMapFlatPosition(pos, &AutoMapGen)) {
            break;
        }
        if (CheckObjectPutArea(pos) && !(mgDistVector(event_pos, pos) <= 320.0f)) {
            AUTOMAP_ROOM *room = &AutoMapGen.room[AutoMapGen.door_room];
            int x = (int)((pos[0] + 0.5f * AutoMapGen.cell_w) / AutoMapGen.cell_w);
            int y = (int)((pos[2] + 0.5f * AutoMapGen.cell_d) / AutoMapGen.cell_d);
            if (room->x > x || x >= room->x + room->w || room->y > y || room->y + room->h <= y) {
                manager->PutTreasureBox(-1, pos, 0.0f, 1, GetKeyDoorIndex(stage, floor), 1, -1, 0);
                break;
            }
        }
    }
}
int _FLS(SPI_STACK *stack, int argc) {
    FLS_FLOOR_ID = spiGetStackInt(stack++);
    spiGetStackInt(stack);
    int current_floor = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
    int floor = current_floor;
    if (FLS_FLOOR_ID == floor) {
        ((CMonsterMan *)ActiveMonster)->locate.num = 0;
    }
    return 1;
}
int _FL(SPI_STACK *stack, int argc) {
    int i;
    int entry;
    int current_floor = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
    int floor = current_floor;
    if (FLS_FLOOR_ID != floor) {
        return 1;
    }
    {
        for (i = 0; i < argc / 2; i++) {
            entry = ((CMonsterMan *)ActiveMonster)->locate.num;
            ((CMonsterMan *)ActiveMonster)->locate.monster_id[entry] = spiGetStackInt(stack++);
            ((CMonsterMan *)ActiveMonster)->locate.param[entry] = spiGetStackInt(stack++);
            ((CMonsterMan *)ActiveMonster)->locate.num++;
        }
    }
    return 1;
}
/**
 *
 * Ends the scripted monster placement floor.
 *
 */
int _FLE(SPI_STACK *stack, int argc) {
    FLS_FLOOR_ID = -1;
    return 1;
}

void CreatMonsterFloorInfo(char *script, int length) {
    FLS_FLOOR_ID = -1;
    CScriptInterpreter interpreter;

    (interpreter).SetTag(tag2);
    (interpreter).SetScript(script, length);
    (interpreter).Run();
}

void AutoSetMonster() {
    float           event_point[4];
    float           position[4];
    float           direction[4];
    float           event_extra[4];
    int             i;
    int             placed;
    CActiveMonster *monster;
    int             floor_no;
    int             floor_id;
    int             spawn_count;
    int             base_id;
    int             gate_key;

    if (ActiveMonster != NULL) {
        DngMainScene->battle_area.battle_clear = 0;
        floor_no = DngSaveDataDungeon->stage_id;
        spawn_count = ((CMonsterMan *) ActiveMonster)->locate.num;
        floor_id = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];

        if (spawn_count > 0x18) {
            spawn_count = 0x18;
        }

        GetDungeonEventPoint(event_point, &event_extra[3], 2);
        event_point[3] = 1.0f;

        for (i = 0; i < spawn_count; i++) {
            placed = 0;

            do {
                if (SearchMapFlatPosition(position, &AutoMapGen) != 0) {
                    rand();
                    direction[3] = 0.0f;
                    direction[2] = 0.0f;
                    direction[1] = 0.0f;
                    direction[0] = 0.0f;

                    if (!(mgDistVector(event_point, position) <= 520.0f) &&
                        CheckObjectPutArea(position) != 0) {
                        base_id = ((CMonsterMan *) ActiveMonster)->locate.monster_id[i];

                        if (base_id >= 0xF5 && base_id < 0x10D) {
                            placed = 1;
                        } else {
                            monster = ActiveMonster->SetActiveMonster(ActiveMonster->SearchBaseIndex(base_id), position, direction, -1);

                            if (monster != NULL) {
                                placed = 1;
                                monster->locate_param = ((CMonsterMan *) ActiveMonster)->locate.param[i];

                                if (i == 0) {
                                    gate_key = GetGateKeyIndex(floor_no, floor_id);

                                    if (gate_key != -1) {
                                        monster->gate_key = gate_key;
                                    }
                                }
                            }
                        }
                    }
                }
            } while (placed == 0);
        }
    }
}

void AutoSetMonster(int base_index, float *position, float *direction, int option) {
    int             index;
    CActiveMonster *monster;

    if (ActiveMonster != NULL) {
        DngMainScene->battle_area.battle_clear = 0;
        index = (ActiveMonster)->SearchBaseIndex(base_index);

        if (index != -1) {
            monster = (ActiveMonster)->SetActiveMonster(index, position, direction, -1);

            if (monster != NULL) {
                monster->locate_param = option;
            }
        }
    }
}

void DungeonFloorInit() {
}

void DungeonFloorFinish() {
}
extern char at_2446[];
extern char at_2447[];
extern char at_2448[];
extern char at_2449[];
extern char at_2450__2[];
extern char at_2451[];
extern char at_2452[];
extern char at_2453[];
extern char at_2454[];
extern char at_2455__2[];
extern char at_2456[];
void LoadDungeonMapFile(char *map_name, char *cfg_name, int gen_flag) {
    mgCMemory *stack;
    u_long128 *image;
    mgCTextureManager *textures;
    int new_map;
    int image_size;
    CMap *map;
    int box;
    mgCCamera *camera;
    int map_no;
    CTreasureBoxManager *boxes;
    int cell;
    int snd_id;
    int stage_size;
    int seal;
    int step;
    int bgm_no;
    int room_size;
    u_long128 *stage_image;
    int room;

    DNG_BATTLE_AREA *area = &DngMainScene->battle_area;
    DngMainScene->battle_area.battle_clear = 1;
    area->battle_clear = 1;
    area->battle_bgm_state = 0;
    area->battle_bgm_vol = 0.0f;
    area->camera_mode = 0;
    area->pause_flag = 0;
    area->timer = 0;
    area->minimap_reveal = 0;
    area->quake_count = 0;
    area->script.running = 0;
    area->subject_counter = 0;
    area->practice_actions = 0;
    area->floor_status = 0;
    area->weather = 0;
    area->lock_on_mode = 0;
    area->pause_flag |= 0x400;
    CheckItemDngKey();
    mgInitLighting();
    DngMainScene->AutoChangeEnvOffset(0);
    CommonStageClassInit();
    ReEquipFishingGameWeapon();
    int stage = DngSaveDataDungeon->stage_id;
    int floor = DngSaveDataDungeon->floor_id[stage];
    NowFloorInfoPtr = DngSaveDataDungeon->GetFloorInfoPtr(stage, floor);
    seal = area->floor_manager.IsSealFloor(floor);
    if (0 < seal) {
        area->floor_status |= 1 << (seal - 1);
    }
    area->pause_flag |= 0x100;
    if (cfg_name != NULL) {
        area->pause_flag &= ~0x100;
        if (GetBattleCharaInfo()->GetNowNPC() == 9) {
            area->minimap_reveal |= 1;
        }
    }
    DngMainScene->StopSeSrc();
    sndSeAllStop(-1);
    sndStopVoice(1);
    snd_id = GetMapSndDataID(SearchMapNo(map_name));
    DngMainScene->LoadSound(snd_id, BuffReadData);
    if (DngMainScene->skip_load_bgm == 0) {
        bgm_no = DngMainScene->GetDefBgmNo(snd_id);
        if (bgm_no == -1) {
            DngMainScene->StopBGM(0);
        }
        if (DngMainScene->CheckLoadBGM(bgm_no) == 0 || bgm_no == 9999) {
            DngMainScene->PlayBGM(0, -1, 1.0f);
        } else {
            DngMainScene->StopBGM(0);
            sndStep(2.0f);
            if (DngMainScene->LoadBGM(bgm_no, BuffReadData)) {
                DngMainScene->PlayBGM(0, -1, 1.0f);
                if (bgm_no == 0) {
                    DngMainScene->AutoChangeBGMVol(1);
                    DngMainScene->StepSnd();
                    sndStep(2.0f);
                }
            }
        }
    } else {
        DngMainScene->skip_load_bgm = 0;
    }
    if (strcmp(area->map_name, map_name) == 0) {
        new_map = 0;
    } else {
        strcpy(area->map_name, map_name);
        new_map = 1;
    }
    if (new_map) {
        map_no = SearchMapNo(map_name);
        if (map_no < 0) {
            printf(at_2446, map_name);
        }
        SCN_LOADMAP_INFO2 load_info;
        MainMapInfo.map_no = 0;
        MainMapInfo.stack_no = 1;
        MainMapInfo.efp_tex_block = 0xF;
        MainMapInfo.tex_block = 0;
        MainMapInfo.load_buf = (u8 *)BuffReadData;
        SetMainMapInfo(&MainMapInfo);
        GetLoadMapInfo(&load_info, map_no);
        load_info.sky_tex_block = 0x4C;
        load_info.load_sky = 1;
        load_info.place_parts_max = 400;
        DngMainScene->DeleteMap(0, 1);
        DngMainScene->LoadMap(0, &load_info, 0);
        DngMainScene->SetNowMapNo(map_no);
        DngMainScene->SetActive(2, 0);
        DngMainMap = DngMainScene->GetMap(DngMainScene->active_map);
        stack = DngMainScene->GetStack(1);
        if (stack != NULL && cfg_name != NULL) {
            stack->lock = 0;
            stack->Align64();
            image = (u_long128 *)stack->stAllocTest(1);
            if (image != NULL) {
                textures = &mgTexManager;
                textures->DeleteBlock(0x66);
                char image_path[0x40];
                sprintf(image_path, at_2447, map_name);
                if (LoadFile2(image_path, image, &image_size, 0)) {
                    stack->Alloc(image_size / 16 + 1);
                    textures->EnterIMGFile((u_char *)image, 0x66, stack, NULL);
                }
            }
        }
        map_effect.type = MAP_EFFECT_NONE;
        if (strcmp(map_name, at_2448) == 0) {
            map_effect.type = MAP_EFFECT_D01;
        }
        if (strcmp(map_name, at_2449) == 0) {
            map_effect.type = MAP_EFFECT_D02;
        }
        if (strcmp(map_name, at_2450__2) == 0) {
            map_effect.type = MAP_EFFECT_D03;
        }
        if (strcmp(map_name, at_2451) == 0) {
            map_effect.type = MAP_EFFECT_D03;
        }
        if (strcmp(map_name, at_2452) == 0) {
            map_effect.type = MAP_EFFECT_D03;
        }
        if (map_effect.type >= 0) {
            map_effect.Init_LightBoll(stack, 0x30);
            camera = DngMainScene->GetCamera(0);
            if (camera != NULL) {
                for (step = 0; step < 16; step++) {
                    map_effect.Step(camera);
                }
            }
        }
        stack->lock = 0;
        stack->Align64();
        stage_image = (u_long128 *)stack->stAllocTest(1);
        if (stage_image != NULL) {
            char stage_path[0x30];
            if (stage != 4) {
                sprintf(stage_path, at_2453, stage + 1);
            } else if (floor < 16) {
                sprintf(stage_path, at_2454);
            } else {
                sprintf(stage_path, at_2455__2);
            }
            LoadFile(stage_path, stage_image, &stage_size);
            stack->Alloc(stage_size / 16 + 1);
            mgTexManager.DeleteBlock(0x6A);
            mgTexManager.EnterIMGFile((u_char *)stage_image, 0x6A, stack, NULL);
        }
        stack->lock = 1;
    }
    if (AutoMapGen.grid != NULL) {
        for (cell = 0; cell < AutoMapGen.grid_w * AutoMapGen.grid_h; cell++) {
            AutoMapGen.grid[cell].Initialize();
        }
    }
    for (room = 0; room < 8; room++) {
        AutoMapGen.room[room].unk_0 = 0;
    }
    AutoMapGen.healing_point.enable = 0;
    AutoMapGen.healing_point.timer = 0;
    AutoMapGen.room_info = NULL;
    AutoMapGen.room_info_num = 0;
    AutoMapGen.gio_parts = NULL;
    for (int stone = 0; stone < 12; stone++) {
        AutoMapGen.random_stone[stone] = NULL;
    }
    AutoMapGen.pot_parts = NULL;
    AutoMapGen.gen_flag = 0;
    AutoMapGen.door_room = -1;
    AutoMapGen.navi_valid = 0;
    AutoMapGen.navi_enable = 0;
    AutoMapGen.random_map = 0;
    AutoMapGen.minimap_enable = 0;
    if (cfg_name != NULL) {
        char room_path[0x80];
        sprintf(room_path, at_2456, cfg_name);
        mgCMemory room_stack;
        LoadFile(room_path, BuffReadData, &room_size);
        room_stack.stSetBuffer(BuffReadData + room_size / 16 + 1, 0x8000);
        AutoMapGen.SetupRoomInfo((char *)BuffReadData, room_size, &room_stack);
        AutoMapGen.gen_flag |= gen_flag;
        AutoMapGen.Build();
    }
    area->boss_map = 0;
    BTsubo.Init(0);
    BTsubo2.Init();
    BTsuboCol = NULL;
    EdEventMapInit();
    if (ActiveMonster != NULL) {
        ActiveMonster->Initialize(DngMainScene);
    }
    map = DngMainScene->GetMap(DngMainScene->active_map);
    AutoMapGen.mini_map.map = NULL;
    AutoMapGen.mini_map.parts_table = NULL;
    AutoMapGen.mini_map.grid = NULL;
    AutoMapGen.mini_map.blink_cnt = 0;
    AutoMapGen.mini_map.parts_num = 0;
    AutoMapGen.mini_map.large = 0;
    AutoMapGen.mini_map.SetMapInfo(map, AutoMapGen.grid, AutoMapGen.grid_w, AutoMapGen.grid_h, AutoMapGen.cell_w,
                                   AutoMapGen.cell_d);
    boxes = area->treasure_box;
    for (box = 0; box < TREASURE_BOX_MAX; box++) {
        boxes->box[box].Initialize();
    }
    RandomCircle.Clear();
    GeoStone.SetFlag(0);
    PullItemMan.Clear();
    ColPrimMan.Initialize(DngMainScene);
    FxScriptMan->AllClearEffSpt();
    InitS51Thunder();
}
void MinimapDoorEnable(float *pos) {
    AutoMapGen.MinimapDoorOpen(pos);
    AutoMapGen.UpdateNaviMap(pos, 4);
}

void LoadMonsterFile() {
    CScene *scene = DngMainScene;

    if (ActiveMonster != NULL) {
        ActiveMonster->Initialize(scene);
        DngMainScene->AssignStack(3);
        DngMainScene->ClearStack(3);
        mgCMemory   *memory = DngMainScene->GetStack(3);
        int          slot_index;
        CMonsterMan *manager = ActiveMonster;

        for (slot_index = 0; slot_index < MONSTER_ACTIVE_MAX; slot_index++) {
            u_long128 *buffer = memory->stAlloc64(4000);
            mgCMemory *slot = &manager->memory[slot_index];
            slot->stSetBuffer(buffer, 4000);
            slot->stack_used = 0;
            slot->lock = 0;
        }

        sndInitPort(5);
        int                 locate_index;
        int                 stage_id = DngSaveDataDungeon->stage_id;
        CMonsterLocateInfo *locate = &ActiveMonster->locate;
        locate->num = 0;
        locate->put_num = 0;
        locate->put_flag = 0;

        for (locate_index = 0; locate_index < MONSTER_LOCATE_MAX; locate_index++) {
            locate->param[locate_index] = -1;
            locate->monster_id[locate_index] = -1;
        }

        char path[76];
        int  size;
        sprintf(path, at_2529, stage_id);
        LoadFile(path, BuffReadData, &size);
        CreatMonsterFloorInfo((char *) BuffReadData, size);
        int monster_count = ActiveMonster->locate.num;

        for (int entry = 0; entry < monster_count; entry++) {
            int monster_id = ActiveMonster->locate.monster_id[entry];

            if (ActiveMonster->SearchBaseIndex(monster_id) < 0) {
                ActiveMonster->EntryRefer(monster_id, memory);
            }
        }
    }
}

void LoadMonsterFile(int monster_id, int initialize) {
    mgCMemory *memory;
    CScene    *scene = DngMainScene;

    if (ActiveMonster != NULL) {
        if (initialize != 0) {
            ActiveMonster->Initialize(scene);
            DngMainScene->AssignStack(3);
            DngMainScene->ClearStack(3);
            memory = (mgCMemory *) DngMainScene->GetStack(3);

            if (memory != NULL) {
                int i = 0;
                u8 *monster_man = (u8 *) ActiveMonster;
                int offset = 0;

                for (; i < MONSTER_ACTIVE_MAX; i++) {

                    void      *buffer = memory->stAlloc64(0xFA0);
                    mgCMemory *slot = (mgCMemory *) (monster_man + offset + 4);
                    (slot)->stSetBuffer((u_long128 *) buffer, 0xFA0);
                    slot->stack_used = 0;
                    offset += 0x30;
                    slot->lock = 0;
                }

                sndInitPort(5);

                goto entry;
            }
        } else {
            memory = (mgCMemory *) scene->GetStack(3);

            if (memory != NULL) {
            entry:
                if (ActiveMonster->SearchBaseIndex(monster_id) < 0) {
                    ActiveMonster->EntryRefer(monster_id, memory);
                }
            }
        }
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1082__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1248__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", gatekey_index__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", keydoor_key_index__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", xchg_rot_list__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", tag__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1936__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", tag2__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1274__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1279__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1466__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1467__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1468__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1645__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1732__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1825__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1826__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1827__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1828__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1829__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1905__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_1965__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2159__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2198__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2199__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2200__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2446__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2447__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2448__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2449__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2450__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2451__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2452__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2453__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2454__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2455__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2456__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", at_2529__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", __vt__9CGeoStone__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", __vt__13CRedMarkModel__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(counter_1489, 0x4);
INCLUDE_BSS(nowTbFloor, 0x4);
INCLUDE_BSS(nowTboxGroup, 0x4);
INCLUDE_BSS(nowTboxItemCnt, 0x4);
INCLUDE_BSS(FLS_FLOOR_ID, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_1348, 0x10);
