#include "common.h"
#include "mg_drawprim.hpp"
#include "effscript.hpp"
#include "maintex.hpp"
#include "monster.hpp"
#include "font.hpp"
#include "mainloop.hpp"
#include "cameracontrol.hpp"
#include "event_func.hpp"
#include "event.hpp"
#include "menucommon.hpp"
#include "gameutil.hpp"
#include "dataread.hpp"
#include "quest.hpp"
#include "mapload.hpp"
#include "mglib.hpp"
#include "water.hpp"
#include "editriver.hpp"
#include "snd_mngr.hpp"
#include <cmath>
#include <cstdlib>
#include <cstdio>
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "snd_seseq.hpp"
#include "mg_texture.hpp"
#include "mg_math.hpp"
#include "dng_effect.hpp"
#include "dng_status.hpp"
#include "dng_debug.hpp"
#include "dng_main.hpp"
#include "actionchara.hpp"
#include "automap.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "mapinfo.hpp"
#include "mapparts.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "nd_meswin.hpp"
#include "object.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "userdata.hpp"
#include "dng_event.hpp"
#include <cstring>

extern "C" int fptosi(float value);
extern int FLS_FLOOR_ID;
extern char at_1082__2[];
extern char at_1248[];
extern char at_1274__2[];
extern char at_1279__2[];
extern int gatekey_index[7];
extern int keydoor_key_index[7];
extern char at_1466__5[];
extern char at_1467__5[];
extern char at_1468__5[];
extern int counter_1489;
extern float xchg_rot_list[4];
extern char at_1645[];
extern TRESURE_BOX_FLOOR_INFO *nowTbFloor;
extern int nowTboxGroup;
extern int nowTboxItemCnt;
extern char at_1905__2[];
extern "C" float at_1936__2[4];
extern "C" char at_1965__2[];
extern SPI_TAG_PARAM tag__5[];
extern SPI_TAG_PARAM tag2[];
extern char at_1348[];
extern char at_2529[];

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", DrawEpisode__20CStartupEpisodeTitleFii);
void CStartupEpisodeTitle::Switch(int on) {
    char *title;
    ClsMes *current;
    int title_width;
    u8 *floor_manager;
    int floor_id;

    floor_manager = (u8 *)&DngMainScene->battle_area + 0x14;
    floor_id = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];

    if (on != 0) {
        mes->abs_win.x = 0x22;
        mes->abs_win.y = 0x154;
        mes->font_w = 0x12;
        title = ((CDngFloorManager *)floor_manager)->GetFloorTitle(floor_id);
        mes->MakeMesWin(title, 1, 1);
        title_width = (s16)mes->GetStrWidth(title);
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
        current->unk_1e40 = 0;
        current->open = 0;
        current->fade = 0.0f;
        current->fukidashi_centre_x = -1;
        current->fukidashi_centre_y = -1;
    }
    state = on;
}
void CStartupEpisodeTitle::Step(void) {
    ClsMes *mes_win;
    int top;

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
                mes_win->unk_1e40 = 0;
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
void CStartupEpisodeTitle::Initialize(void) {
    mes = NULL;
    state = 0;
    wait = 0;
}
void MessageTaskManager::Draw(void) {
    ClsMes *current;

    current = mes;
    if (current != NULL) {
        current->DrawMesWin();
    }
}
void MessageTaskManager::Step(void) {
    ClsMes *current;
    MESSAGE_TASK *line;

    current = this->mes;
    if (current != NULL && !(this->flag & 1)) {
        line = (MESSAGE_TASK *)this->top;
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
                current->unk_1e40 = 0;
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
void MessageTaskManager::Print(char *text, int count, int fukidashi_pos, int priority) {
    MESSAGE_TASK *node;
    MESSAGE_TASK *head;
    MESSAGE_TASK *prev;
    MESSAGE_TASK *next;
    int i;
    int byte_offset;

    if (this->mes != NULL) {
        node = NULL;
        i = 0;
        byte_offset = 0;
        do {
            if (*(char **)((u8 *)this + byte_offset + 8) == NULL) {
                node = (MESSAGE_TASK *)((u8 *)this + i * 0x90 + 8);
                break;
            }
            i += 1;
            byte_offset += 0x90;
        } while (i < 6);
        if (node != NULL) {
            strcpy(node->text, text);
            node->message = node->text;
            node->priority = priority;
            node->slot = fukidashi_pos;
            node->time = count;
            node->count = 0;
            head = (MESSAGE_TASK *)this->top;
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
void MessageTaskManager::Clear(void) {
    ClsMes *current;
    MESSAGE_TASK *line;

    current = this->mes;
    if (current != NULL) {
        line = (MESSAGE_TASK *)this->top;
        if (line != NULL) {
            if (line->time > 0) {
                current->draw_speed = current->GetDrawSpeedDef();
                current->mes_no = -1;
                current->unk_1e40 = 0;
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
void MessageTaskManager::Initialize(void) {
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
void CRedMarkModel::Draw(void) {
    float position[4];
    float saved_position[4];

    if (draw_request != 0) {
        ((CObjectFrame *)this)->GetPosition(position);
        ((CObjectFrame *)this)->GetPosition(saved_position);
        position[1] += 2.0f * sinf(angle);
        ((CObjectFrame *)this)->SetPosition(position);
        ((CObjectFrame *)this)->CObjectFrame::DrawDirect();
        ((CObjectFrame *)this)->SetPosition(saved_position);
        draw_request = 0;
    }
}
void CRedMarkModel::Step(void) {
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
        ((CObjectFrame *)this)->GetPosition(home_position);
        ((CObjectFrame *)this)->GetPosition(draw_position);
        if (mgDistVector(view_pos, draw_position) < 1000.0f || this->anime == 0) {
            if (this->anime != 0) {
                draw_position[1] += 3.0f * sinf(this->angle);
            }
            ((CObjectFrame *)this)->SetPosition(draw_position);
            ((CCharacter2 *)this)->CCharacter2::DrawDirect();
        }
        ((CObjectFrame *)this)->SetPosition(home_position);
    }
}
void CGeoStone::DrawMiniMapSymbol(CMiniMapSymbol *symbol_drawer) {
    float position[4];

    if (this->flag != 0) {
        ((CTreasureBox *)this)->GetPosition(position);
        (symbol_drawer)->DrawSymbol(position, 3);
    }
}
void CGeoStone::SetFlag(int flag) {
    float query[4];
    CMapParts *object;

    this->flag = flag;
    if (this->flag == 0 && (object = AutoMapGen.gio_parts) != NULL) {
        *(u_long128 *)query = *(u_long128 *)at_1082__2;
        object->SetPosition(query);
    }
}
void CGeoStone::GeoStep(void) {
    float next;

    if (this->flag != 0) {
        ((CCharacter2 *)this)->CCharacter2::Step();
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
    ((CTreasureBox *)this)->GetPosition(position);
    position[1] -= 20.0f;
    if (mgDistVector(pos, position) <= 30.0f) {
        return 1;
    }
    return 0;
}
void CGeoStone::Initialize(void) {
    CCharacter2::Initialize();
    this->flag = 0;
}
void CRandomCircle::Draw(float *view_pos) {
    int id;
    int flag_offset;
    int pos_offset;

    pos_offset = 0;
    flag_offset = 0;
    id = 0;
    do {
        if (*(int *)((u8 *)this + flag_offset + 0x30) != 0 &&
            mgDistVector(view_pos, (float *)((u8 *)this + pos_offset)) < 1000.0f) {
            ((CCharacter2 *)&this->model)->SetPosition((float *)((u8 *)this + pos_offset));
            ((CCharacter2 *)&this->model)->SetRotation(0.0f, 0.0f, 0.0f);
            ((CCharacter2 *)&this->model)->DrawDirect();
        }
        id += 1;
        flag_offset += 4;
        pos_offset += 0x10;
    } while (id < 3);
}
void CRandomCircle::Step() {
    ((CCharacter2 *)((u8 *)this + 0x40))->Step();
}
void CRandomCircle::DrawSymbol(CMiniMapSymbol *symbol_drawer) {
    int id;
    int flag_offset;
    int pos_offset;

    pos_offset = 0;
    flag_offset = 0;
    id = 0;
    do {
        if (*(int *)((u8 *)this + flag_offset + 0x30) != 0) {
            (symbol_drawer)->DrawSymbol((float *)((u8 *)this + pos_offset), 2);
        }
        id += 1;
        flag_offset += 4;
        pos_offset += 0x10;
    } while (id < 3);
}
int CRandomCircle::CheckArea(float *pos, float radius) {
    int id;
    int flag_offset;
    int pos_offset;

    pos_offset = 0;
    flag_offset = 0;
    id = 0;
loop:
    if (*(int *)((u8 *)this + flag_offset + 0x30) != 0 &&
        mgDistVector((float *)((u8 *)this + pos_offset), pos) < radius) {
        return 0;
    }
    id += 1;
    flag_offset += 4;
    pos_offset += 0x10;
    if (id >= 3) {
        return 1;
    }
    goto loop;
}
int CRandomCircle::GetPosition(float *out, int id) {
    if (id == -1) {
        if (this->hit == -1) {
            return 0;
        }
        sceVu0CopyVector(out, (float *)((u8 *)this + this->hit * 0x10));
        return 1;
    }
    if (id < 0 || id >= 3) {
        return 0;
    }
    sceVu0CopyVector(out, (float *)((u8 *)this + id * 0x10));
    return 1;
}
int CRandomCircle::CheckEvent(float *pos) {
    int id;
    int flag_offset;
    int pos_offset;

    pos_offset = 0;
    flag_offset = 0;
    id = 0;
next_circle:
    if ((*(int *)((u8 *)this + flag_offset + 0x30) != 0) &&
        (mgDistVector(((float *)((u8 *)this + pos_offset)), pos) <= 20.0f)) {
        hit = id;
        return id;
    }
    id += 1;
    flag_offset += 4;
    pos_offset += 0x10;
    if (id >= 3) {
        hit = -1;
        return -1;
    }
    goto next_circle;
}
int CRandomCircle::SetCircle(float *pos) {
    int flag_offset;
    int id;
    int pos_offset;

    flag_offset = 0;
    id = 0;
loop:
    if (*(int *)((u8 *)this + flag_offset + 0x30) == 0) {
        pos_offset = id << 4;
        sceVu0CopyVector((float *)((u8 *)this + pos_offset), pos);
        *(float *)((pos_offset + (int)this) + 0xC) = 1.0f;
        this->active[id] = 1;
        return id;
    }
    id += 1;
    flag_offset += 4;
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
    ((CCharacter2 *)((u8 *)this + 0x40))->Initialize();
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
        *(DngEventVector *)up = *(DngEventVector *)at_1248;
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
    mgCFrame *frame;
    mgCFrame *found;
    u8 *entry;
    int i;

    *(int *)this = value;
    *(CCharacter2 **)((u8 *)this + 0xA94) = model;
    frame = model->CObjectFrame::frame;
    if (frame != NULL) {
        found = frame->SearchFrame(at_1274__2);
        if (found != NULL) {
            entry = (u8 *)this + 0x10;
            for (i = 0; i < 0x18; i++) {
                *(mgCFrame **)(entry + 0x64) = found;
                *(mgCFrame **)(entry + 0x68) = frame;
                *(CCharacter2 **)(entry + 0x6C) = model;
                entry += 0x70;
            }
        }
    }
}
void CTreasureBoxManager::SetCollisionModel(u32 *pack, mgCMemory *memory) {
    col_frame = LoadCollisionFile((MDS_HEADER *)GetPackFile(pack, at_1279__2, NULL), memory);
}
void CTreasureBoxManager::PutTreasureBox(int index, float *position, float angle, int param, int value1, int value2, int value3, int value4) {
    int i;
    int byte_offset;
    CTreasureBox *chest;

    if (index == -1) {
        i = 0;
        byte_offset = 0;
        do {
            chest = (CTreasureBox *)((u8 *)this + byte_offset + 0x10);
            if (chest->state == 0) {
                index = i;
                break;
            }
            i += 1;
            byte_offset += 0x70;
        } while (i < 0x18);
    }
    if (index < 0 || index >= 0x18) {
        return;
    }
    chest = (CTreasureBox *)((u8 *)this + index * 0x70 + 0x10);
    chest->state = 1;
    chest->SetPosition(position);
    chest->SetRotation(0.0f, angle, 0.0f);
    chest->flags = param;
    chest->item[0] = value1;
    chest->item[1] = value3;
    chest->num[0] = value2;
    chest->num[1] = value4;
}
int CTreasureBoxManager::CheckArea(float *pos, float radius) {
    float chest_pos[4];
    int i;
    int byte_offset;
    CTreasureBox *slot;

    byte_offset = 0;
    i = 0;
loop:
    slot = (CTreasureBox *)((u8 *)this + byte_offset + 0x10);
    if (slot->state != 0) {
        slot->GetPosition(chest_pos);
        if (mgDistVector(chest_pos, pos) < radius) {
            return 0;
        }
    }
    i += 1;
    byte_offset += 0x70;
    if (i >= 0x18) {
        return 1;
    }
    goto loop;
}
void CTreasureBoxManager::DrawMiniMapSymbol(CMiniMapSymbol *symbol_drawer) {
    float chest_pos[4];
    int i;
    int byte_offset;
    CTreasureBox *slot;

    byte_offset = 0;
    i = 0;
    do {
        slot = (CTreasureBox *)((u8 *)this + byte_offset + 0x10);
        if (slot->state == 1) {
            slot->GetPosition(chest_pos);
            (symbol_drawer)->DrawSymbol(chest_pos, 1);
        }
        i += 1;
        byte_offset += 0x70;
    } while (i < 0x18);
}
void CTreasureBoxManager::Draw(float *view_pos) {
    int i;
    int byte_offset;
    CTreasureBox *slot;

    byte_offset = 0;
    i = 0;
    do {
        slot = (CTreasureBox *)((u8 *)this + byte_offset + 0x10);
        if (slot->state != 0) {
            (slot)->Draw(view_pos);
        }
        i += 1;
        byte_offset += 0x70;
    } while (i < 0x18);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", DrawShadow__19CTreasureBoxManagerFPf);
int CTreasureBoxManager::PickupCollision( float *pos, CCPoly *polys, mgVu0FBOX box, int flag) {
    int count;
    int i;
    CTreasureBox *slot;
    int byte_offset;
    float chest_pos[4];
    float rotation[4];

    byte_offset = 0;
    i = 0;
    count = 0;
    do {
        slot = (CTreasureBox *)((u8 *)this + byte_offset + 0x10);
        if (slot->state != 0) {
            slot->GetPosition(chest_pos);
            if (mgDistVector(chest_pos, pos) <= 40.0f) {
                this->col_frame->SetPosition(chest_pos);
                slot->GetRotation(rotation);
                this->col_frame->SetRotation(rotation);
                count += this->col_frame->PickUpNearPoly(polys + count, *(mgVu0FBOX *)&box, flag);
            }
        }
        i += 1;
        byte_offset += 0x70;
    } while (i < 0x18);
    return count;
}
int CTreasureBoxManager::MimicCount() {
    int count;
    int i;
    u8 *slot;
    u8 *entry;
    int byte_offset;

    count = 0;
    i = 0;
    byte_offset = 0;
    do {
        entry = (u8 *)this + byte_offset;
        slot = entry + 0x10;
        if (*(s8 *)(entry + 0x64) == 1 && (*(int *)(slot + 0x58) & 0x100)) {
            count += 1;
        }
        i += 1;
        byte_offset += 0x70;
    } while (i < 0x18);
    return count;
}
int CTreasureBoxManager::CheckEvent(float *pos, float radius) {
    float chest_pos[4];
    float nearest;
    int i;
    int byte_offset;
    CTreasureBox *slot;
    float distance;

    this->near_box = -1;
    nearest = 9999.0f;
    byte_offset = 0;
    i = 0;
    do {
        slot = (CTreasureBox *)((u8 *)this + byte_offset + 0x10);
        if (slot->state == 1) {
            slot->GetPosition(chest_pos);
            distance = mgDistVector(chest_pos, pos);
            if (distance < radius && nearest > distance) {
                nearest = distance;
                this->near_box = i;
            }
        }
        i += 1;
        byte_offset += 0x70;
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
int Lamb2WolfManager(void) {
    CBattleCharaInfo *info;
    int form;
    CActionChara *chara;
    mgCFrame *wolf;
    mgCFrame *lamb;
    mgCFrame *object;
    float rotation[4];

    info = GetBattleCharaInfo();
    if (info->chr_no != 1) {
        return -1;
    }
    form = *(s16 *)((u8 *)info->equip + 2);
    if (form != 0x38 && form != 0x58) {
        return -1;
    }
    chara = (CActionChara *)DngMainScene->GetCharacter(0);
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
    (void)sound_id;
}
void BattleSoundManager(void) {
    BattleAreaBGMCtrl();
    StatusWarningSnd();
}
void StatusWarningSnd(void) {
    CBattleCharaInfo *info;
    float ratio;

    if (!(DngMainScene->battle_area.pause_flag & 0x400)) {
        if (counter_1489 < 0x14) {
            counter_1489 += 1;
        } else {
            counter_1489 = 0;
            info = GetBattleCharaInfo();
            ratio = (float)info->GetNowHp_i();
            ratio /= (float)info->GetMaxHp_i();
            if (ratio > 0.0f && ratio < 0.3f) {
                sndSePlay(((CScene *)DngMainScene)->se_battle_id, 10, 0);
                if (ratio < 0.15f) {
                    counter_1489 = 10;
                }
            }
        }
    }
}
void BattleAreaBGMCtrl(void) {
    void *player;
    DNG_BATTLE_AREA *state;
    float distance;
    int phase;
    float fade;
    float rate;
    CScene *scene;

    state = (DNG_BATTLE_AREA *)&DngMainScene->battle_area;
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
        *(s16 *)((u8 *)player + 0x75E) = 1;
    } else {
        *(s16 *)((u8 *)player + 0x75E) = 0;
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
                DngMainScene->GetActiveBgmInfo()->unk_c = 1.0f - fade;
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
                    DngMainScene->GetActiveBgmInfo()->unk_c = 0.0f;
                    scene->SetVolfBGM(scene->GetActiveBgmInfo()->volf);
                } else {
                    sndSetSeVolf(EdEventInfo.snd_id[4], 0, fade, 0);
                }
                state->battle_bgm_vol = fade;
                return;
            case 4:
                rate = DngMainScene->GetActiveBgmInfo()->unk_c;
                rate += 0.033333335f;
                if (!(rate < 1.0f)) {
                    state->battle_bgm_state = 0;
                    rate = 1.0f;
                }
                scene = DngMainScene;
                DngMainScene->GetActiveBgmInfo()->unk_c = rate;
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
void XChgMapLighting(void) {
    int saved[0x74];
    int i;
    CMapInfo *map;
    int byte_offset;

    map = (CMapInfo *)DngMainScene->GetMap(DngMainScene->active_map);
    if ((map != NULL) && (map != NULL) && (map->lighting_info_num >= 0x10)) {
        memset(saved, 0, 0x1D0);
        i = 0;
        byte_offset = 0;
        do {
            memcpy(saved, (u8 *)map->lighting_info + byte_offset, 0x1D0);
            memcpy((u8 *)map->lighting_info + byte_offset,
                   (u8 *)map->lighting_info + byte_offset + 0xE80, 0x1D0);
            memcpy((u8 *)map->lighting_info + byte_offset + 0xE80, saved, 0x1D0);
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
    char name[0x40];
    int result;
    CMap *map;
    CMapParts *found;
    int i;

    result = 0;
    if ((map = DngMainScene->GetMap(DngMainScene->active_map)) == NULL) {
        return 0;
    }
    switch (kind) {
        case 0:
            for (i = 0; i < 4; i++) {
                sprintf(name, at_1645, i + 0x20);
                found = (CMapParts *)(map)->GetPlaceParts(name);
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
                found = (CMapParts *)(map)->GetPlaceParts(name);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", SearchMapFlatPosition__FPfP11CAutoMapGen);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", GetDungeonEventPoint__FPfPfi);
int _GROUP_START(SPI_STACK *stack, int argc) {
    spiGetStackInt(stack);
    nowTbFloor->group_num = -1;
    return 1;
}
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
int _FLOOR_START(SPI_STACK *stack, int argc) {
    nowTbFloor->floor_start = spiGetStackInt(stack);
    return 1;
}
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
    int count;
    int i;
    int j;
    int id;
    TRESURE_BOX_ITEM *entry;
    table->rank_max = 0;
    table->rank_min = 0;
    count = table->floor[floor_index].group_num;
    for (i = 0; i < count; i++) {
        id = table->floor[floor_index].group_id[i];
        group = table->group;
        while (1) {
            if (group->group_id == id)
                break;
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
    int want_higher;
    TRESURE_BOX_GROUP *group;
    TRESURE_BOX_ITEM *entry;
    int i;
    int id;

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
extern "C" int CheckArea__19CTreasureBoxManagerFPff(CTreasureBoxManager *manager, float *pos, float radius);

int CheckObjectPutArea(float *pos) {
    float position[4];
    CMapParts *object;

    if (!CheckArea__19CTreasureBoxManagerFPff(*(CTreasureBoxManager **)&DngMainScene->battle_area.treasure_box, pos, 40.0f)) {
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
    float position[4];
    float hit[4];
    CCPoly polys[0x80];
    mgVu0FBOX box;
    float direction[4];
    float rotated[4];
    float rotation[4][4];
    float identity[4][4];
    float angle;
    CMap *map;
    int poly_count;
    int i;
    float z;

    angle = 0.0f;
    sceVu0CopyVector(position, eye_pos);
    position[1] += 20.0f;
    map = (CMap *)DngMainScene->GetMap(DngMainScene->active_map);
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
    *(DngEventVector *)direction = *(DngEventVector *)at_1936__2;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", AutoSetTreasureBox__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", _FLS__FP9SPI_STACKi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", _FL__FP9SPI_STACKi);
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
void AutoSetMonster(void) {
    float event_point[4];
    float position[4];
    float direction[4];
    float event_extra[4];
    int i;
    int placed;
    CActiveMonster *monster;
    int floor_no;
    int floor_id;
    int spawn_count;
    int base_id;
    int gate_key;

    if (ActiveMonster != NULL) {
        *(int *)((u8 *)DngMainScene + 0x2FEC) = 0;
        floor_no = DngSaveDataDungeon->stage_id;
        spawn_count = ((CMonsterMan *)ActiveMonster)->locate.num;
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
                        base_id = ((CMonsterMan *)ActiveMonster)->locate.monster_id[i];
                        if (base_id >= 0xF5 && base_id < 0x10D) {
                            placed = 1;
                        } else {
                            monster = ActiveMonster->SetActiveMonster(ActiveMonster->SearchBaseIndex(base_id), position, direction, -1);
                            if (monster != NULL) {
                                placed = 1;
                                monster->locate_param = ((CMonsterMan *)ActiveMonster)->locate.param[i];
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
    int index;
    CActiveMonster *monster;

    if (ActiveMonster != NULL) {
        *(int *)((u8 *)DngMainScene + 0x2FEC) = 0;
        index = (ActiveMonster)->SearchBaseIndex(base_index);
        if (index != -1) {
            monster = (CActiveMonster *)((ActiveMonster)->SetActiveMonster(index, position, direction, -1));
            if (monster != NULL) {
                monster->locate_param = option;
            }
        }
    }
}
void DungeonFloorInit(void) {
}
void DungeonFloorFinish(void) {
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", LoadDungeonMapFile__FPcPci);
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
        mgCMemory *memory = DngMainScene->GetStack(3);
        int slot_index;
        CMonsterMan *manager = ActiveMonster;
        for (slot_index = 0; slot_index < MONSTER_ACTIVE_MAX; slot_index++) {
            u_long128 *buffer = memory->stAlloc64(4000);
            mgCMemory *slot = &manager->memory[slot_index];
            slot->stSetBuffer(buffer, 4000);
            slot->stack_used = 0;
            slot->lock = 0;
        }
        sndInitPort(5);
        int locate_index;
        int stage_id = DngSaveDataDungeon->stage_id;
        CMonsterLocateInfo *locate = &ActiveMonster->locate;
        locate->num = 0;
        locate->put_num = 0;
        locate->put_flag = 0;
        for (locate_index = 0; locate_index < MONSTER_LOCATE_MAX; locate_index++) {
            locate->param[locate_index] = -1;
            locate->monster_id[locate_index] = -1;
        }
        char path[76];
        int size;
        sprintf(path, at_2529, stage_id);
        LoadFile(path, BuffReadData, &size);
        CreatMonsterFloorInfo((char *)BuffReadData, size);
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
    CScene *scene = DngMainScene;
    if (ActiveMonster != NULL) {
        if (initialize != 0) {
            ActiveMonster->Initialize(scene);
            DngMainScene->AssignStack(3);
            DngMainScene->ClearStack(3);
            memory = (mgCMemory *)DngMainScene->GetStack(3);
            if (memory != NULL) {
                int i = 0;
                u8 *monster_man = (u8 *)ActiveMonster;
                int offset = 0;
                for (; i < MONSTER_ACTIVE_MAX; i++) {

                    void *buffer = memory->stAlloc64(0xFA0);
                    mgCMemory *slot = (mgCMemory *)(monster_man + offset + 4);
                    (slot)->stSetBuffer((u_long128 *)buffer, 0xFA0);
                    slot->stack_used = 0;
                    offset += 0x30;
                    slot->lock = 0;
                }
                sndInitPort(5);

                goto entry;
            }
        } else {
            memory = (mgCMemory *)scene->GetStack(3);
            if (memory != NULL) {
            entry:
                if (ActiveMonster->SearchBaseIndex(monster_id) < 0) {
                    ActiveMonster->EntryRefer(monster_id, memory);
                }
            }
        }
    }
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_event", __sinit_dng_event_cpp);

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

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_event", D_0037B044__DATA);

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
INCLUDE_BSS(MainMapInfo, 0x20);
