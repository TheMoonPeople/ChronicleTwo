#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstddef>
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
#ifdef PORT
#include "port_memory_budget.hpp"
#endif
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

static int                     FLS_FLOOR_ID;
static int                     gatekey_index[7] = {337, 339, 341, 342, 344, 348, 350};
static int                     keydoor_key_index[7] = {338, 340, -1, 343, 346, 349, 351};
static int                     counter_1489;
static float                   xchg_rot_list[4] = {0.0f, -HALF_PI, PI, HALF_PI};
static TRESURE_BOX_FLOOR_INFO *nowTbFloor;
static int                     nowTboxGroup;
static int                     nowTboxItemCnt;
static float                   at_1936__2[4] = {0.0f, 20.0f, 80.0f, 1.0f};
static MapJumpMapInfo          MainMapInfo;

void CStartupEpisodeTitle::DrawEpisode(int mes_tex_block, int frame_tex_block) {
    if (mes == NULL || state == EPISODE_TITLE_OFF) {
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
    sprite.Begin(MG_PRIM_SPRITE);
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

    floor_manager = (u8 *) &DngMainScene->battle_area + offsetof(DNG_BATTLE_AREA, floor_manager);
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
        wait = 60;
    } else if (state != EPISODE_TITLE_OFF) {
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

    if (state == EPISODE_TITLE_FADE_IN) {
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
                wait = 60;
                state = EPISODE_TITLE_HOLD;
            }
        }
    }

    if (state == EPISODE_TITLE_HOLD) {
        wait -= 1;

        if (wait < 0) {
            state = EPISODE_TITLE_FADE_OUT;
        }
    }

    if (state == EPISODE_TITLE_FADE_OUT) {
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
                state = EPISODE_TITLE_OFF;
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
    state = EPISODE_TITLE_OFF;
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

    if (current != NULL && !(this->flag & MESSAGE_TASK_MANAGER_FLAG_HOLD)) {
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
        } while (i < MESSAGE_TASK_MAX);

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

            this->task[0].message = NULL;
            this->task[0].message = NULL;
            this->task[0].message = NULL;
            this->task[0].message = NULL;
            this->task[0].message = NULL;
            this->task[0].message = NULL;
            this->top = NULL;
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
        draw_request = false;
    }
}

void CRedMarkModel::Step() {
    float next;

    angle += PI / 16.0f;
    next = angle;

    if (!(next <= 0.0f)) {
        angle = next - PI;
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
        symbol_drawer->DrawSymbol(position, MINIMAP_SYMBOL_GEOSTONE);
    }
}

void CGeoStone::SetFlag(int flag) {
    CMapParts *object;

    this->flag = flag;

    if (this->flag == 0 && (object = AutoMapGen.gio_parts) != NULL) {
        sceVu0FVECTOR hidden_pos = {0.0f, -99999.0f, 0.0f, 1.0f};
        object->SetPosition(hidden_pos);
    }
}

void CGeoStone::GeoStep() {
    float next;

    if (this->flag != 0) {
        CCharacter2::Step();
        this->angle += 3.0f * DEG_TO_RAD;
        next = this->angle;

        if (!(next <= PI)) {
            this->angle = next - TWO_PI;
        }
    }
}

int CGeoStone::CheckEvent(float *pos) {
    float position[4];

    if (this->flag == 0) {
        return false;
    }

    GetPosition(position);
    position[1] -= 20.0f;

    if (mgDistVector(pos, position) <= 30.0f) {
        return true;
    }

    return false;
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
            mini_map->DrawSymbol(this->pos[id], MINIMAP_SYMBOL_RANDOM_CIRCLE);
        }

        id += 1;
    } while (id < 3);
}

int CRandomCircle::CheckArea(float *pos, float radius) {
    int id;

    for (id = 0; id < 3; id++) {
        if (active[id] != 0 && mgDistVector(this->pos[id], pos) < radius) {
            return 0;
        }
    }

    return 1;
}

int CRandomCircle::GetPosition(float *out_pos, int index) {
    if (index == -1) {
        if (this->hit == -1) {
            return false;
        }

        sceVu0CopyVector(out_pos, this->pos[this->hit]);
        return true;
    }

    if (index < 0 || index >= 3) {
        return false;
    }

    sceVu0CopyVector(out_pos, this->pos[index]);
    return true;
}

int CRandomCircle::CheckEvent(float *pos) {
    int id;

    for (id = 0; id < 3; id++) {
        if (active[id] != 0 && mgDistVector(this->pos[id], pos) <= 20.0f) {
            hit = id;
            return id;
        }
    }

    hit = -1;
    return -1;
}

int CRandomCircle::SetCircle(float *pos) {
    int id;

    for (id = 0; id < 3; id++) {
        if (active[id] == 0) {
            sceVu0CopyVector(this->pos[id], pos);
            this->pos[id][3] = 1.0f;
            this->active[id] = 1;
            return id;
        }
    }

    return -1;
}

void CRandomCircle::Clear() {
    active[0] = false;
    active[1] = false;
    active[2] = false;
    hit = -1;
}

void CRandomCircle::Initialize() {
    model.Initialize();
    this->active[0] = false;
    this->active[1] = false;
    this->active[2] = false;
    this->hit = -1;
}

void CTreasureBox::Draw(float *view_pos) {
    float position[4];
    float rotation[4];

    if (this->frame != NULL) {
        this->GetPosition(position);
        this->GetRotation(rotation);
        this->lid_frame->SetRotation(45.0f * (-PI * this->lid_open / 180.0f), 0.0f, 0.0f);
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

    if (this->model != NULL) {
        sceVu0FVECTOR up = {0.0f, 1.0f, 0.0f, 0.0f};
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

void CTreasureBoxManager::SetLargeModel(CCharacter2 *model, int tex_block) {
    mgCFrame     *frame;
    mgCFrame     *found;
    CTreasureBox *entry;
    int           i;

    this->tex_block = tex_block;
    this->model = model;
    frame = model->CObjectFrame::frame;

    if (frame != NULL) {
        found = frame->SearchFrame("tbox1");

        if (found != NULL) {
            entry = box;

            for (i = 0; i < TREASURE_BOX_MAX; i++) {
                entry->lid_frame = found;
                entry->frame = frame;
                entry->model = model;
                entry++;
            }
        }
    }
}

void CTreasureBoxManager::SetCollisionModel(u32 *pack, mgCMemory *memory) {
    col_frame = LoadCollisionFile((MDS_HEADER *) GetPackFile(pack, "tbox_a.mds", NULL), memory);
}

void CTreasureBoxManager::PutTreasureBox(int index, float *pos, float rot_y, int flags, int item0, int num0, int item1, int num1) {
    int           i;
    CTreasureBox *chest;

    if (index == -1) {
        i = 0;

        do {
            chest = &this->box[i];

            if (chest->state == TREASURE_BOX_STATE_NONE) {
                index = i;
                break;
            }

            i += 1;
        } while (i < TREASURE_BOX_MAX);
    }

    if (index < 0 || index >= TREASURE_BOX_MAX) {
        return;
    }

    chest = &this->box[index];
    chest->state = TREASURE_BOX_STATE_UNOPENED;
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

    for (i = 0; i < 0x18; i++) {
        slot = &this->box[i];

        if (slot->state != TREASURE_BOX_STATE_NONE) {
            slot->GetPosition(chest_pos);

            if (mgDistVector(chest_pos, pos) < radius) {
                return 0;
            }
        }
    }

    return 1;
}

void CTreasureBoxManager::DrawMiniMapSymbol(CMiniMapSymbol *symbol_drawer) {
    float         chest_pos[4];
    int           i;
    CTreasureBox *slot;

    i = 0;

    do {
        slot = &this->box[i];

        if (slot->state == TREASURE_BOX_STATE_UNOPENED) {
            slot->GetPosition(chest_pos);
            symbol_drawer->DrawSymbol(chest_pos, MINIMAP_SYMBOL_TREASURE_BOX);
        }

        i += 1;
    } while (i < TREASURE_BOX_MAX);
}

void CTreasureBoxManager::Draw(float *view_pos) {
    int           i;
    CTreasureBox *slot;

    i = 0;

    do {
        slot = &this->box[i];

        if (slot->state != TREASURE_BOX_STATE_NONE) {
            slot->Draw(view_pos);
        }

        i += 1;
    } while (i < TREASURE_BOX_MAX);
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

        if (slot->state != TREASURE_BOX_STATE_NONE) {
            slot->DrawShadow(view_pos, shadow_direction);
        }

        i += 1;
    } while (i < TREASURE_BOX_MAX);
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

        if (slot->state != TREASURE_BOX_STATE_NONE) {
            slot->GetPosition(chest_pos);

            if (mgDistVector(chest_pos, pos) <= 40.0f) {
                this->col_frame->SetPosition(chest_pos);
                slot->GetRotation(rotation);
                this->col_frame->SetRotation(rotation);
                count += this->col_frame->PickUpNearPoly(&polys[count], box, flag);
            }
        }

        i += 1;
    } while (i < TREASURE_BOX_MAX);

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

        if (slot->state == TREASURE_BOX_STATE_UNOPENED && (slot->flags & TREASURE_BOX_FLAG_MIMIC)) {
            count += 1;
        }

        i += 1;
    } while (i < TREASURE_BOX_MAX);

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

        if (slot->state == TREASURE_BOX_STATE_UNOPENED) {
            slot->GetPosition(chest_pos);
            distance = mgDistVector(chest_pos, pos);

            if (distance < dist && nearest > distance) {
                nearest = distance;
                this->near_box = i;
            }
        }

        i += 1;
    } while (i < TREASURE_BOX_MAX);

    return this->near_box;
}

int GetGateKeyIndex(int dungeon, int floor) {
    if (dungeon == 4 && floor >= 17) {
        return ITEM_ID_ROPE;
    }

    return gatekey_index[dungeon];
}

int GetKeyDoorIndex(int dungeon, int floor) {
    if (dungeon == 4 && floor >= 17) {
        return ITEM_ID_WHITE_WIND_VASE;
    }

    return keydoor_key_index[dungeon];
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

    if (info->chr_no != USER_CHARA_MONICA) {
        return -1;
    }

    form = info->equip[0].item_no;

    if (form != ITEM_ID_LAMBS_SWORD && form != ITEM_ID_ISLAND_KING) {
        return -1;
    }

    chara = (CActionChara *) DngMainScene->GetCharacter(0);

    if (chara == NULL) {
        return -1;
    }

    if (form == ITEM_ID_ISLAND_KING) {
        object = chara->SearchObject("parts01");

        if (object != NULL) {
            object->GetRotation(rotation);
            rotation[1] += 16.0f * DEG_TO_RAD;
            rotation[1] = mgAngleLimit(rotation[1]);
            object->SetRotation(rotation);
        }

        return 0;
    }

    lamb = chara->SearchObject("w15a");
    wolf = chara->SearchObject("w15b");

    if (lamb == NULL || wolf == NULL) {
        return -1;
    }

    if (GetTimeBand(DngMainScene->time) == MAP_TIME_BAND_NIGHT) {
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

    if (!(DngMainScene->battle_area.pause_flag & DNG_PAUSE_PLAYER_STATUS)) {
        if (counter_1489 < 20) {
            counter_1489 += 1;
        } else {
            counter_1489 = 0;
            info = GetBattleCharaInfo();
            ratio = (float) info->GetNowHp_i();
            ratio /= (float) info->GetMaxHp_i();

            if (ratio > 0.0f && ratio < 0.3f) {
                sndSePlay(DngMainScene->se_battle_id, 10, 0);

                if (ratio < 0.15f) {
                    counter_1489 = 10;
                }
            }
        }
    }
}

void BattleAreaBGMCtrl() {
    CActionChara    *player;
    DNG_BATTLE_AREA *state;
    float            distance;
    int              phase;
    float            fade;
    float            rate;
    CScene          *scene;

    state = &DngMainScene->battle_area;
    player = (CActionChara *) DngMainScene->GetCharacter(0);

    if (dngGetDebugInfo()->sound_flag == 0) {
        sndSeStop(EdEventInfo.snd_id[4], 0, 0);
        return;
    }

    distance = 9999999.0f;

    if (ActiveMonster != NULL) {
        distance = ActiveMonster->IsBattleStyleDist();
    }

    if (distance <= 340.0f) {
        player->battle_stance = true;
    } else {
        player->battle_stance = false;
    }

    if (!(state->pause_flag & DNG_PAUSE_BATTLE_MUSIC) && state->boss_map == 0) {
        phase = state->battle_bgm_state;
        fade = state->battle_bgm_vol;

        if (phase == DNG_BGM_MAP) {
            if (!(340.0f < distance)) {
                state->battle_bgm_state = DNG_BGM_FADE_OUT_MAP;
            }
        }

        if (phase == DNG_BGM_BATTLE) {
            if (400.0f <= distance) {
                state->battle_bgm_state = DNG_BGM_FADE_OUT_BATTLE;
            }
        }

        switch (phase) {
            case DNG_BGM_FADE_OUT_MAP:
                fade += 0.05f;

                if (!(fade < 1.0f)) {
                    state->battle_bgm_state = DNG_BGM_BATTLE;
                    fade = 1.0f;
                    sndSePlay(EdEventInfo.snd_id[4], 0, 0);
                    DngMainScene->PauseBGM();
                }

                scene = DngMainScene;
                DngMainScene->GetActiveBgmInfo()->master_volf = 1.0f - fade;
                scene->SetVolfBGM(scene->GetActiveBgmInfo()->volf);
                state->battle_bgm_vol = fade;
                return;
            case DNG_BGM_FADE_OUT_BATTLE:
                fade -= 0.016666668f;

                if (fade <= 0.0f) {
                    state->battle_bgm_state = DNG_BGM_FADE_IN_MAP;
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
            case DNG_BGM_FADE_IN_MAP:
                rate = DngMainScene->GetActiveBgmInfo()->master_volf;
                rate += 0.033333335f;

                if (!(rate < 1.0f)) {
                    state->battle_bgm_state = DNG_BGM_MAP;
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
        case SCRIPT_DEBUG_COMMAND_RESTORE_HP:
            info->AddHp_Point(512.0f, -1.0f);
            info->ForceSet();
            break;
    }
}

void XChgMapLighting() {
    int       saved[sizeof(CMapLightingInfo) / sizeof(int)];
    int       i;
    CMapInfo *map;
    int       byte_offset;

    map = (CMapInfo *) DngMainScene->GetMap(DngMainScene->active_map);

    if ((map != NULL) && (map != NULL) && (map->lighting_info_num >= 16)) {
        memset(saved, 0, sizeof(saved));
        i = 0;
        byte_offset = 0;

        do {
            memcpy(saved, (u8 *) map->lighting_info + byte_offset, sizeof(CMapLightingInfo));
            memcpy((u8 *) map->lighting_info + byte_offset,
                   (u8 *) map->lighting_info + byte_offset + 8 * sizeof(CMapLightingInfo), sizeof(CMapLightingInfo));
            memcpy((u8 *) map->lighting_info + byte_offset + 8 * sizeof(CMapLightingInfo), saved, sizeof(CMapLightingInfo));
            i += 1;
            byte_offset += sizeof(CMapLightingInfo);
        } while (i < 8);
    }
}

float XChgMapRotation(int index) {
    if (index < 0 || index > 3) {
        return 0.0f;
    }

    return xchg_rot_list[index];
}

int SearchMapEventParts(int kind, CMapParts **parts, float *rotation, int max) {
    char       name[64];
    int        result;
    CMap      *map;
    CMapParts *found;
    int        i;

    result = false;

    if ((map = DngMainScene->GetMap(DngMainScene->active_map)) == NULL) {
        return false;
    }

    switch (kind) {
        case MAP_EVENT_PARTS_WAY_32:
            for (i = 0; i < 4; i++) {
                sprintf(name, "way%d", i + 32);
                found = map->GetPlaceParts(name);

                if (found != NULL) {
                    parts[0] = found;
                    *rotation = XChgMapRotation(i);
                    result = true;
                    parts[1] = NULL;
                    break;
                }
            }

            break;
        case MAP_EVENT_PARTS_WAY_36:
            for (i = 0; i < 16; i++) {
                sprintf(name, "way%d", i + 36);
                found = map->GetPlaceParts(name);

                if (found != NULL) {
                    parts[0] = found;
                    *rotation = XChgMapRotation(i);
                    result = true;
                    parts[1] = NULL;
                    break;
                }
            }

            break;
        case MAP_EVENT_PARTS_NONE:
            break;
    }

    return result;
}

int SearchMapFlatPosition(sceVu0FVECTOR out_pos, CAutoMapGen *map_gen) {
    float       center[4];
    float       from[4];
    float       to[4];
    CCPoly      polys[128];
    mgVu0FBOX   box;
    int         hit_polys[32];
    float       hit_points[32][4];
    float       found[4];
    CMapParts  *parts;
    int         place_num;
    int         poly_num;
    CMapParts  *place_parts;
    int         tries_left;
    int         attempt;
    CMap       *map;
    int         hit_num;
    int         attr;
    int         axis;
    CMap *const scene_map = DngMainScene->GetMap(DngMainScene->active_map);

    if ((map = scene_map) == NULL) {
        return false;
    }

    place_parts = scene_map->GetPlacPartsTable(&place_num);

    if (place_parts == NULL) {
        return false;
    }

    if (place_num <= 0) {
        return false;
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

        poly_num = map->GetColPoly(polys, box, 128);

        for (attempt = 0; attempt < 16; attempt++) {
            sceVu0CopyVector(from, center);
            from[0] += fRand(320.0f) - 160.0f;
            from[2] += fRand(320.0f) - 160.0f;
            sceVu0CopyVector(to, from);
            from[1] += 4200.0f;
            to[1] -= 4200.0f;
            hit_num = CheckHits(polys, poly_num, from, to, 32, hit_polys, hit_points, 0, 0);

            for (int i = 0; i < hit_num; i++) {
                short area_kind = polys[hit_polys[i]].area_kind;

                if (area_kind == COL_AREA_NO_PLACE) {
                    break;
                }

                if (area_kind == COL_AREA_FLAT) {
                    sceVu0CopyVector(from, hit_points[i]);
                    sceVu0CopyVector(to, hit_points[i]);
                    from[1] += 10.0f;
                    to[1] -= 10.0f;

                    if (CheckHit(polys, poly_num, from, to, found, 1, 1) >= 0) {
                        sceVu0CopyVector(out_pos, found);
                        out_pos[3] = 1.0f;
                        return true;
                    }
                }
            }
        }

        if (tries_left < 0) {
            printf("flat put err\n");
            return false;
        }

        tries_left--;
    }
}

int GetDungeonEventPoint(float *out_pos, float *out_rot, int kind) {
    float euler[4];

    if (kind == DUNGEON_EVENT_POINT_PLAYER) {
        CCharacter2 *player = DngMainScene->GetCharacter(0);

        if (player == NULL) {
            return false;
        }

        player->GetPosition(out_pos);
        out_pos[0] = (int) ((80.0f + out_pos[0]) / 160.0f) * 160;
        out_pos[1] = 0.0f;
        out_pos[2] = (int) ((80.0f + out_pos[2]) / 160.0f) * 160;
        *out_rot = 0.0f;
    }

    if (kind == DUNGEON_EVENT_POINT_WAY_32) {
        CMapParts *parts[8];
        float      rotation[8];
        CMap      *map = DngMainScene->GetMap(DngMainScene->active_map);

        if (map == NULL) {
            return false;
        }

        if (SearchMapEventParts(MAP_EVENT_PARTS_WAY_32, parts, rotation, 8) <= 0) {
            return false;
        }

        CMapParts *found = parts[0];
        found->GetPosition(out_pos);
        *out_rot = rotation[0];
        CSceneEventData *event = &DngMainScene->event_data;
        event->map_event.parts_no = map->ConvertParts(found);
        EdEventInfo.dng_event_parts = found;
        EdEventInfo.dng_event_found = true;
    }

    if (kind == DUNGEON_EVENT_POINT_WAY_36) {
        CMapParts *parts[16];
        float      rotation[16];
        CMap      *map = DngMainScene->GetMap(DngMainScene->active_map);

        if (map == NULL) {
            return false;
        }

        if (SearchMapEventParts(MAP_EVENT_PARTS_WAY_36, parts, rotation, 16) <= 0) {
            return false;
        }

        CMapParts *found = parts[0];
        found->GetPosition(out_pos);
        *out_rot = rotation[0];
        CSceneEventData *event = &DngMainScene->event_data;
        event->map_event.parts_no = map->ConvertParts(found);
        EdEventInfo.dng_event_parts = found;
        EdEventInfo.dng_event_found = true;
    }

    if (kind == DUNGEON_EVENT_POINT_TREASURE_BOX) {
        DNG_BATTLE_AREA *area = &DngMainScene->battle_area;

        if (area == NULL) {
            return false;
        }

        CTreasureBoxManager *boxes = area->treasure_box;

        if (boxes == NULL) {
            return false;
        }

        int           near_box = boxes->near_box;
        int           box_no = near_box;
        CTreasureBox *box = &boxes->box[box_no];

        if (box == NULL) {
            return false;
        }

        box->GetPosition(out_pos);
        box->GetRotation(euler);
        *out_rot = euler[1];
    }

    return true;
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
    int group_id;
    int item_num;

    group_id = spiGetStackInt(stack++);
    item_num = spiGetStackInt(stack);
    nowTbFloor->group_num += 1;
    nowTbFloor->group[nowTbFloor->group_num].group_id = group_id;
    nowTbFloor->group[nowTbFloor->group_num].item_num = item_num;
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
    int item_no;
    int rank;
    int num;

    for (i = 0; i < argc / 3; i++) {
        item_no = spiGetStackInt(stack++);
        rank = spiGetStackInt(stack++);
        num = spiGetStackInt(stack++);
        nowTbFloor->group[nowTboxGroup].item[nowTboxItemCnt].item_no = item_no;
        nowTbFloor->group[nowTboxGroup].item[nowTboxItemCnt].rank = rank;
        nowTbFloor->group[nowTboxGroup].item[nowTboxItemCnt].num = num;
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

static SPI_TAG_PARAM tag__5[] = {
    {"GROUP_START", _GROUP_START},
    {"GROUP",       _GROUP      },
    {"ITEM",        _ITEM       },
    {"FLOOR_START", _FLOOR_START},
    {"FLOOR",       _FLOOR      },
    {NULL,          NULL        },
};

void CreatTresuarBoxInfo(TRESURE_BOX_FLOOR_INFO *table, char *script, int length) {
    table->group_num = 0;
    table->floor_start = 0;
    table->rank_max = 0;
    table->rank_min = 100;
    nowTbFloor = table;
    CScriptInterpreter interpreter;

    interpreter.SetTag(tag__5);
    interpreter.SetScript(script, length);
    interpreter.Run();
    table->group_num += 1;
}

void PickupRandomItemCheckMax(TRESURE_BOX_FLOOR_INFO *table, int floor_index) {
    TRESURE_BOX_GROUP *group;
    int                count;
    int                i;
    int                j;
    int                id;

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

        for (;;) {
            if (group->group_id == id) {
                break;
            }

            i++;
            group++;

            if (i >= table->group_num) {
                printf("ERR:GROUP_ID OVER!! %d\n", i);

                while (1) {
                }
            }
        }

        entry =&group->item[iRand(group->item_num)];

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
        return false;
    }

    if (!RandomCircle.CheckArea(pos, 40.0f)) {
        return false;
    }

    if ((object = AutoMapGen.gio_parts) != NULL) {
        object->GetPosition(position);
        position[3] = 1.0f;

        if (mgDistVector(position, pos) < 40.0f) {
            return false;
        }
    }

    return (AutoMapGen.SearchRandomStone(pos, 40.0f) != NULL) ^ 1;
}

float ScanEyePoint(float *eye_pos) {
    float     position[4];
    float     hit[4];
    CCPoly    polys[128];
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
    poly_count = map->GetColPoly(polys, box, 128);
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

        printf("-------------------------> hit %.2f,%.2f\n", position[0], position[2]);
        angle += PI / 8.0f;
        angle = mgAngleLimit(angle);
        i++;

        if (i >= 16) {
            return angle;
        }
    }
}

void AutoSetTreasureBox(int id, float *position, float power) {
    DngMainScene->battle_area.treasure_box->PutTreasureBox(-1, position, power, 0x41, id, 1, -1, 0);
}

void AutoSetTreasureBox() {
    DNG_BATTLE_AREA     *area = &DngMainScene->battle_area;
    CTreasureBoxManager *manager = DngMainScene->battle_area.treasure_box;
    int                  stage = DngSaveDataDungeon->stage_id;
    u32                  floor = DngSaveDataDungeon->floor_id[stage];
    float                event_pos[4];
    float                event_rot;
    float                angle;
    int                  box;
    int                  i;

    GetDungeonEventPoint(event_pos, &event_rot, DUNGEON_EVENT_POINT_WAY_32);
    event_pos[3] = 1.0f;
    mgCMemory stack;
    char      path[64];
    float     pos[4];
    float     mimic_pos[4];
    int       size;
    sprintf(path, "dungeon/cfg_file/tbox_d0%d.cfg", stage + 1);
    LoadFile(path, BuffReadData, &size);
    stack.stSetBuffer(BuffReadData + size / 16 + 1, 0x4000);
    TRESURE_BOX_FLOOR_INFO *info = new (stack.Alloc(0x1A43)) TRESURE_BOX_FLOOR_INFO;
    CreatTresuarBoxInfo(info, (char *) BuffReadData, size);
    PickupRandomItemCheckMax(info, floor);

    for (box = 0; box < 8; box++) {
        int searching = true;

        while (searching) {
            if (SearchMapFlatPosition(pos, &AutoMapGen) && !(mgDistVector(event_pos, pos) <= 320.0f) &&
                manager->CheckArea(pos, 60.0f)) {
                angle = (2.0f * (PI * (float) rand())) / 2.1474836e9f - PI;
                int flags;
                int num0 = 1;
                int item0 = 0;
                int item1 = -1;
                int num1 = 1;

                if (box < 2) {
                    if (box == 0) {
                        item0 = ITEM_ID_MAGIC_CRYSTAL;
                    }

                    if (box == 1) {
                        item0 = ITEM_ID_MAP;
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

                    if (flags & TREASURE_BOX_FLAG_TWO_ITEMS) {
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
                    num0 = (int) (0.8f * (float) num0 + fRand(0.4f * (float) num0) + 0.5f);
                }

                if (num1 >= 3 && num1 < 10) {
                    num1 += iRand(3) - 1;
                }

                if (num1 >= 10) {
                    num1 = (int) (0.8f * (float) num1 + fRand(0.4f * (float) num1) + 0.5f);
                }

                manager->PutTreasureBox(-1, pos, angle, flags, item0, num0, item1, num1);
                searching = false;
            }
        }
    }

    for (i = 0; i < ActiveMonster->locate.num; i++) {
        int monster_id = ActiveMonster->locate.monster_id[i];

        if (monster_id >= MONSTER_ID_MIMIC_FIRST && monster_id <= MONSTER_ID_MIMIC_LAST) {
            int placed = false;
            int param = ActiveMonster->locate.param[i];

            do {
                if (SearchMapFlatPosition(mimic_pos, &AutoMapGen) && !(mgDistVector(event_pos, mimic_pos) <= 320.0f) &&
                    CheckObjectPutArea(mimic_pos)) {
                    manager->PutTreasureBox(-1, mimic_pos,
                                            (2.0f * (PI * (float) rand())) / 2.1474836e9f - PI,
                                            TREASURE_BOX_FLAG_MIMIC | 1, monster_id, param, -1, 0);
                    placed = true;
                }
            } while (!placed);
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
            stone->flag = true;
            stone->anime = true;

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
            int           x = (int) ((pos[0] + 0.5f * AutoMapGen.cell_w) / AutoMapGen.cell_w);
            int           y = (int) ((pos[2] + 0.5f * AutoMapGen.cell_d) / AutoMapGen.cell_d);

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
        ActiveMonster->locate.num = 0;
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

    for (i = 0; i < argc / 2; i++) {
        entry = ActiveMonster->locate.num;
        ActiveMonster->locate.monster_id[entry] = spiGetStackInt(stack++);
        ActiveMonster->locate.param[entry] = spiGetStackInt(stack++);
        ActiveMonster->locate.num++;
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

static SPI_TAG_PARAM tag2[] = {
    {"FLS", _FLS},
    {"FL",  _FL },
    {"FLE", _FLE},
    {NULL,  NULL},
};

void CreatMonsterFloorInfo(char *script, int length) {
    FLS_FLOOR_ID = -1;
    CScriptInterpreter interpreter;

    interpreter.SetTag(tag2);
    interpreter.SetScript(script, length);
    interpreter.Run();
}

void AutoSetMonster() {
    float           event_point[4];
    float           position[4];
    float           direction[4];
    float           event_extra[4];
    int             i;
    int             placed;
    CActiveMonster *monster;
    int             dungeon;
    int             floor_id;
    int             spawn_count;
    int             base_id;
    int             gate_key;

    if (ActiveMonster != NULL) {
        DngMainScene->battle_area.battle_clear = false;
        dungeon = DngSaveDataDungeon->stage_id;
        spawn_count = ActiveMonster->locate.num;
        floor_id = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];

        if (spawn_count > MONSTER_ACTIVE_MAX) {
            spawn_count = MONSTER_ACTIVE_MAX;
        }

        GetDungeonEventPoint(event_point, &event_extra[3], DUNGEON_EVENT_POINT_WAY_32);
        event_point[3] = 1.0f;

        for (i = 0; i < spawn_count; i++) {
            placed = false;

            do {
                if (SearchMapFlatPosition(position, &AutoMapGen) != 0) {
                    rand();
                    direction[3] = 0.0f;
                    direction[2] = 0.0f;
                    direction[1] = 0.0f;
                    direction[0] = 0.0f;

                    if (!(mgDistVector(event_point, position) <= 520.0f) &&
                        CheckObjectPutArea(position) != 0) {
                        base_id = ActiveMonster->locate.monster_id[i];

                        if (base_id >= MONSTER_ID_MIMIC_FIRST && base_id <= MONSTER_ID_MIMIC_LAST) {
                            placed = true;
                        } else {
                            monster = ActiveMonster->SetActiveMonster(ActiveMonster->SearchBaseIndex(base_id), position, direction, -1);

                            if (monster != NULL) {
                                placed = true;
                                monster->locate_param = ActiveMonster->locate.param[i];

                                if (i == 0) {
                                    gate_key = GetGateKeyIndex(dungeon, floor_id);

                                    if (gate_key != -1) {
                                        monster->gate_key = gate_key;
                                    }
                                }
                            }
                        }
                    }
                }
            } while (!placed);
        }
    }
}

void AutoSetMonster(int base_index, float *position, float *direction, int option) {
    int             index;
    CActiveMonster *monster;

    if (ActiveMonster != NULL) {
        DngMainScene->battle_area.battle_clear = false;
        index = ActiveMonster->SearchBaseIndex(base_index);

        if (index != -1) {
            monster = ActiveMonster->SetActiveMonster(index, position, direction, -1);

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

void LoadDungeonMapFile(char *map_name, char *cfg_name, int gen_flag) {
    mgCMemory           *stack;
    u_long128           *image;
    mgCTextureManager   *textures;
    int                  new_map;
    int                  image_size;
    CMap                *map;
    int                  box;
    mgCCamera           *camera;
    int                  map_no;
    CTreasureBoxManager *boxes;
    int                  cell;
    int                  snd_id;
    int                  stage_size;
    int                  seal;
    int                  step;
    int                  bgm_no;
    int                  room_size;
    u_long128           *stage_image;
    int                  room;

    DNG_BATTLE_AREA *area = &DngMainScene->battle_area;
    DngMainScene->battle_area.battle_clear = true;
    area->battle_clear = true;
    area->battle_bgm_state = DNG_BGM_MAP;
    area->battle_bgm_vol = 0.0f;
    area->camera_mode = DNG_CAMERA_FOLLOW;
    area->pause_flag = 0;
    area->timer = 0;
    area->minimap_reveal = 0;
    area->quake_count = 0;
    area->script.running = 0;
    area->subject_counter = 0;
    area->practice_actions = 0;
    area->floor_status = 0;
    area->weather = DNG_WEATHER_NORMAL;
    area->lock_on_mode = DNG_LOCK_ON_NEAREST;
    area->pause_flag |= DNG_PAUSE_PLAYER_STATUS;
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

    area->pause_flag |= DNG_PAUSE_MINIMAP;

    if (cfg_name != NULL) {
        area->pause_flag &= ~DNG_PAUSE_MINIMAP;

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
        new_map = false;
    } else {
        strcpy(area->map_name, map_name);
        new_map = true;
    }

    if (new_map) {
        map_no = SearchMapNo(map_name);

        if (map_no < 0) {
            printf("NOT MAP ENTRY !! %s\n", map_name);
        }

        SCN_LOADMAP_INFO2 load_info;
        MainMapInfo.map_no = 0;
        MainMapInfo.stack_no = 1;
        MainMapInfo.efp_tex_block = 0xF;
        MainMapInfo.tex_block = 0;
        MainMapInfo.load_buf = (u8 *) BuffReadData;
        SetMainMapInfo(&MainMapInfo);
        GetLoadMapInfo(&load_info, map_no);
        load_info.sky_tex_block = 0x4C;
        load_info.load_sky = 1;
        load_info.place_parts_max = 400;
        DngMainScene->DeleteMap(0, 1);
        DngMainScene->LoadMap(0, &load_info, 0);
#ifdef PORT
        if (mgCMemory *map_stack = DngMainScene->GetStack(1)) {
            PortCheckDungeonStageRestAfterMap(map_stack);
        }
#endif
        DngMainScene->SetNowMapNo(map_no);
        DngMainScene->SetActive(SCENE_DATA_MAP, 0);
        DngMainMap = DngMainScene->GetMap(DngMainScene->active_map);
        stack = DngMainScene->GetStack(1);

        if (stack != NULL && cfg_name != NULL) {
            stack->lock = 0;
            stack->Align64();
            image = (u_long128 *) stack->stAllocTest(1);

            if (image != NULL) {
                textures = &mgTexManager;
                textures->DeleteBlock(0x66);
                char image_path[64];
                sprintf(image_path, "dungeon/minimap/%s.img", map_name);

                if (LoadFile2(image_path, image, &image_size, 0)) {
                    stack->Alloc(image_size / 16 + 1);
                    textures->EnterIMGFile((u_char *) image, 0x66, stack, NULL);
                }
            }
        }

        map_effect.type = MAP_EFFECT_NONE;

        if (strcmp(map_name, "d01f01") == 0) {
            map_effect.type = MAP_EFFECT_D01;
        }

        if (strcmp(map_name, "d02f01") == 0) {
            map_effect.type = MAP_EFFECT_D02;
        }

        if (strcmp(map_name, "d03f01") == 0) {
            map_effect.type = MAP_EFFECT_D03;
        }

        if (strcmp(map_name, "d03f02") == 0) {
            map_effect.type = MAP_EFFECT_D03;
        }

        if (strcmp(map_name, "d03f03") == 0) {
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
        stage_image = (u_long128 *) stack->stAllocTest(1);

        if (stage_image != NULL) {
            char stage_path[48];

            if (stage != 4) {
                sprintf(stage_path, "dungeon/articles/d0%detc.img", stage + 1);
            } else if (floor < 16) {
                sprintf(stage_path, "dungeon/articles/d05f01etc.img");
            } else {
                sprintf(stage_path, "dungeon/articles/d05f02etc.img");
            }

            LoadFile(stage_path, stage_image, &stage_size);
            stack->Alloc(stage_size / 16 + 1);
            mgTexManager.DeleteBlock(0x6A);
            mgTexManager.EnterIMGFile((u_char *) stage_image, 0x6A, stack, NULL);
        }

        stack->lock = 1;
    }

    if (AutoMapGen.grid != NULL) {
        for (cell = 0; cell < AutoMapGen.grid_w * AutoMapGen.grid_h; cell++) {
            AutoMapGen.grid[cell].Initialize();
        }
    }

    for (room = 0; room < 8; room++) {
        AutoMapGen.room[room].no_door = 0;
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
        char room_path[128];
        sprintf(room_path, "dungeon/cfg_file/%s.cfg", cfg_name);
        mgCMemory room_stack;
        LoadFile(room_path, BuffReadData, &room_size);
        room_stack.stSetBuffer(BuffReadData + room_size / 16 + 1, 0x8000);
        AutoMapGen.SetupRoomInfo((char *) BuffReadData, room_size, &room_stack);
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
        sprintf(path, "dungeon/cfg_file/mos_place%d.cfg", stage_id);
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
