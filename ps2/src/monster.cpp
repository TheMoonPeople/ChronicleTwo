#include "common.h"
#include "menucommon.hpp"
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
#include "actionchara.hpp"
#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "dng_effect.hpp"
#include "map.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "userdata.hpp"
#include "monster.hpp"

extern mgCTextureManager mgTexManager;
extern short gift_item_tbl[][3];
extern int LanguageCode;
extern "C" int fptosi(float value);
extern char *dung_progtxt_notlift_mons[];
union EffectVector { float f[4]; u_long128 qw; };
struct HitRectangle { int left; int top; int right; int bottom; } __attribute__((aligned(16)));
extern EffectVector at_2031;
extern EffectVector at_1707;
extern EffectVector at_1724__2;
extern EffectVector at_2079__2;
extern char at_1999[];
extern char at_2100[];
extern char at_2809[];
extern int no_score_uv[][4];
extern int guard_score_uv[][4];
extern CDamageScore DamageScoreMons[8];
extern int dmg_sc_cnt_2104;
extern s8 init_2105;
extern SPI_TAG_PARAM mos_data_anlyze_tag[];
extern CUserDataManager *DngUserData;
extern CEffectScriptMan *FxScriptMan;
extern "C" int DrawSymbol__14CMiniMapSymbolFPfi(CMiniMapSymbol *, float *, int);
extern "C" CCameraControl *GetCamera__6CSceneFi(CScene *, int);
extern "C" void SethitEffect__15CHitEffectImageFPfPfffffii(CHitEffectImage *, float *, float *, float, float, float, float, int, int);
float SearchArea(CScene *scene, float *from, float *to, float range);
void HitEffectSet(CScene *scene, float *point, int flags);
void GuardEffectSet(CScene *scene, float *point, int play_script);
void HitScoreSet(float *pos, int type, int value);
int CheckGiftPack(CActiveMonster *monster, CColPrim *prim);
int _MONSTER_NAME(SPI_STACK *stack, int argument_count);
void LoadMonsterLanguage(int language);

// Code (.text)
int CActiveMonster::IsDraw(int view_state) {
    if (chara_kind != 2)
        return 0;
    if (life <= 0 && (view_state & 1))
        return 0;
    return 1;
}
void CActiveMonster::CheckStatusAttr() {
    float pos[4];
    int old_life;
    int damage;

    if (status.attr & 1) {
        status.poison_count++;
        if (status.poison_count >= 120) {
            status.poison_count = 0;
            pallet[0].SetAnim(0x60, 0x20, 0x60, 1, 30, 0);
            old_life = life;
            if (old_life > 0) {
                life = fptosi((float)old_life - 0.04f * (float)max_life);
                if (life <= 0) {
                    life = 1;
                }
                damage = old_life - life;
                if (damage > 0) {
                    ((CCharacter2 *)this)->GetEntryObjectPos(0, 0, pos);
                    pos[1] += body_height;
                    HitScoreSet(pos, 0, damage);
                }
            }
        }
    }
    if (status.attr & 0x28) {
        if (status.grey_time % 45 == 0) {
            pallet[0].SetAnim(0x20, 0x20, 0x20, 1, 45, 0);
        }
        status.grey_time--;
        if (status.grey_time <= 0) {
            status.grey_time = 0;
            status.attr &= ~0x28;
        }
    }
    if (status.attr & 2) {
        if (status.slow_time % 45 == 0) {
            pallet[0].SetAnim(0xA0, 0x40, 0xA0, 1, 45, 0);
        }
        status.slow_time--;
        if (status.slow_time <= 0) {
            status.slow_time = 0;
            status.attr &= ~2;
        }
    }
}
int CActiveMonster::CheckView(int rank_limit) {
    int rank;

    rank = priority;
    if (rank < 0) {
        rank = 99;
    }
    if (attrib & MONSTER_ATTRIB_ALWAYS_VIEW) {
        view_state = MONSTER_VIEW_IN;
        view_alpha = 1.0f;
        return view_state;
    }
    if (view_state == MONSTER_VIEW_INIT) {
        if (target_dist < clip_dist) {
            view_state = MONSTER_VIEW_IN;
            view_alpha = 1.0f;
        } else {
            view_state = MONSTER_VIEW_OUT;
            view_alpha = 1.0f;
        }
        return view_state;
    }
    if (view_state == MONSTER_VIEW_IN) {

        if (!(target_dist <= 30.0f + clip_dist) || rank >= rank_limit) {
            view_state = MONSTER_VIEW_FADE_OUT;
        }
    }
    if (view_state == MONSTER_VIEW_OUT && target_dist < clip_dist && rank < rank_limit) {
        view_state = MONSTER_VIEW_FADE_IN;
    }
    return view_state;
}
void CActiveMonster::Step(void) {
    CActionChara::Step();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", Copy__14CActiveMonsterFR14CActiveMonsterP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", __as__12CActionCharaFRC12CActionChara);
void CActiveMonster::Initialize(void) {
    int i;

    CActionChara::Initialize(NULL);
    refer_no = 0;
    monster_id = 0;
    req_prog = -1;
    now_prog = -1;
    target_no = 0;
    view_state = MONSTER_VIEW_INIT;
    view_alpha = 0;
    camera_alpha = 1.0f;
    priority = 999;
    clip_dist = 500.0f;
    unk_1300 = 400.0f;
    unk_1304 = 300.0f;
    unk_1308 = 180;
    att_type = -1;
    stagger = 0;
    stagger_time = 0;
    piyori_mark = 0;
    piyori_time = 0;
    event_no = -1;
    reserv_img[1] = NULL;
    reserv_img[0] = NULL;
    for (i = 0; i < 8; i++) {
        var[i].i = 0;
    }
    for (i = 0; i < 32; i++) {
        var2[i].i = 0;
    }
    max_life = 0;
    life = 0;
    state = 0;
    dead_alpha = 0;
    link_parts = 0;
    link_type = 0;
    unk_1208 = 0;
    attack = 0;
    life_gage.Initialize(0);
    scoop.type = 0;
    scoop.ok = -1;
    gekirin = 0;
    gekirin_time = 0;
    reward_exp = 0;
    reward_money = 0;
    unk_1322 = 0;
    whp = 0;
    defense = 0;
    unk_134c = -1;
    locate_param = 0;
    gate_key = -1;
    no_damage_cnt = 0;
    height = 0;
    status.attr = 0;
    drop_badge = 0;
    next_pos[2] = 0;
    next_pos[1] = 0;
    next_pos[0] = 0;
    next_pos[3] = 1.0f;
    move_speed = 0;
    arrive_dist = 0;
    unk_1488 = 0;
    unk_148c = 0;
    next_rot = 0;
    rot_speed = 0;
    attrib = 0;
}
BASE_MONSTER_TBL *GetMonsterTable(int monster_id) {
    BASE_MONSTER_TBL *entry = base_monster_define;

    while (((s8 *)entry->name)[0] != 0) {
        if (entry->id == monster_id) {
            return entry;
        }
        entry++;
    }
    return NULL;
}
void CMonsterLocateInfo::SetPutFlag(int slot, int put) {
    if (put != 0) {
        if (put_num < num) {
            put_flag |= 1 << slot;
            put_num += 1;
        }
    } else if (put_num > 0) {
        put_flag &= ~(1 << slot);
        put_num -= 1;
    }
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", Initialize__11CMonsterManFP6CScene);

void CMonsterMan::DrawEffectScript() {
    int i;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        if (active[i] != NULL) {
            active[i]->DrawEffect();
        }
    }
}
void CMonsterMan::StepEffectScript() {
    int i;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        if (active[i] != NULL) {
            active[i]->StepEffect();
        }
    }
}
float CMonsterMan::IsBattleStyleDist() {
    int i;
    int mons_base = GetBattleCharaInfo()->unk_2;
    CActiveMonster *found;
    float nearest;

    if (DngUserData->active_chr_no != 3 || mons_base == -1) {
        found = GetPriorityLevelIndex(0, NULL);
        if (found != NULL) {
            return found->target_dist;
        }
        return 999999.0f;
    }
    nearest = 999999.0f;
    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        if (active[i] != NULL && active[i]->IsDraw(1) &&
            active[i]->tbl->user_mons_id != mons_base &&
            nearest > active[i]->target_dist) {
            nearest = active[i]->target_dist;
        }
    }
    return nearest;
}




INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", CheckMonsterTolk__11CMonsterManFPf);

CActiveMonster *CMonsterMan::CheckThrowTarget(mgCFrame *frame) {
    float frame_pos[4];
    float monster_pos[4];
    int i;
    CActiveMonster *monster;

    if (frame == NULL) {
        return NULL;
    }
    frame->GetWorldPosition0(frame_pos);
    frame_pos[3] = 1.0f;
    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        if (active[i] != NULL && active[i]->IsDraw(1) &&
            active[i]->monster_id != 0x25A) {
            active[i]->GetPosition(monster_pos);
            monster_pos[3] = 1.0f;
            if (mgDistVector(monster_pos, frame_pos) <= 30.0f) {
                monster = active[i];
                if (monster->tbl->unk_98 & 1) {
                    MsgTaskMan.Print(dung_progtxt_notlift_mons[LanguageCode], 0x2D, 8, 0);
                    return NULL;
                }
                monster->CObjectFrame::frame->SetReference(frame);
                active[i]->catch_frame = frame;
                active[i]->catch_state = 1;
                active[i]->no_hit_time = 0;
                active[i]->req_prog = 1100;
                return active[i];
            }
        }
    }
    return NULL;
}
int CMonsterMan::SearchBaseIndex(int base_index) {
    int i;

    for (i = 0; i < MONSTER_REFER_MAX; i++) {
        if (refer[i].id == base_index) {
            return i;
        }
    }
    return -1;
}
int CMonsterMan::GetMonsterNum(float limit) {
    int count = 0;
    int i;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        if (active[i] != NULL && active[i]->chara_kind == 2 &&
            (active[i]->target_dist <= limit || limit < 0.0f)) {
            count++;
        }
    }
    return count;
}
BASE_MONSTER_TBL *CMonsterMan::GetReferPtr2(int monster_id) {
    BASE_MONSTER_TBL *entry = base_monster_define;

    while (((s8 *)entry->name)[0] != 0) {
        if (entry->id == monster_id) {
            return entry;
        }
        entry++;
    }
    return NULL;
}
int CMonsterMan::SearchActiveMonsterBlock() {
    int slot;
    CActiveMonster *monster;

    for (slot = 0; slot < MONSTER_ACTIVE_MAX; slot++) {
        monster = active[slot];
        if (monster == NULL) {
            return slot;
        }
        if (monster->state == 0) {
            return slot;
        }
    }
    return -1;
}
int CMonsterMan::SearchReferBlock() {
    int i;

    for (i = 0; i < MONSTER_REFER_MAX; i++) {
        if (refer[i].id == -1) {
            return i;
        }
    }
    return -1;
}
int CMonsterMan::EntryRefer(int monster_id, mgCMemory *memory) {
    BASE_MONSTER_TBL *entry;

    while (monster_id != -1) {
        entry = GetReferPtr2(monster_id);
        if (entry == NULL) {
            return 0;
        }
        if (!LoadReferMonsterFile(monster_id, entry, memory)) {
            return 0;
        }
        monster_id = entry->next_id;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", LoadReferMonsterFile__11CMonsterManFiP16BASE_MONSTER_TBLP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", SetActiveMonster__11CMonsterManFiPfPfi);
void CMonsterMan::DrawMiniMapSymbol(CMiniMapSymbol *symbol) {
    CBattleCharaInfo *battle_info;
    int show_all;
    int i;
    int symbol_no;
    CActiveMonster *monster;
    float pos[4];

    if (symbol != NULL) {
        show_all = 0;
        if (scene->battle_area.unk_64 & 2) {
            show_all = 1;
        }
        battle_info = GetBattleCharaInfo();
        for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
            monster = active[i];
            if (monster != NULL && monster->chara_kind == 2 && monster->catch_state != 1 &&
                (monster->target_dist <= monster->clip_dist || show_all)) {
                symbol_no = 0;
                if (monster->gate_key > 0 && battle_info->GetNowNPC() == 9) {
                    symbol_no = 8;
                }
                active[i]->GetPosition(pos);
                DrawSymbol__14CMiniMapSymbolFPfi(symbol, pos, symbol_no);
            }
        }
    }
}
void CMonsterMan::DrawLifeGage(int view, int mode) {
    float pos[4];
    float total_pos[4];
    CActionChara *player;
    CActiveMonster *monster;
    int total_life;
    int i;
    int target_no;

    if (mode != 0) {
        return;
    }
    player = (CActionChara *)scene->GetCharacter(0);
    if (player == NULL) {
        return;
    }
    target_no = -1;
    if (player->lock_on != 0) {
        target_no = player->target_no;
    }
    total_life = 0;
    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        monster = active[i];
        if (monster != NULL && monster->state != 0 &&
            monster->target_dist <= monster->clip_dist) {
            if (i + MONSTER_ACTIVE_MAX == target_no) {
                monster->life_gage.SetView(1);
            } else {
                monster->life_gage.SetView(0);
            }
            ((CCharacter2 *)active[i])->GetEntryObjectPos(0, 0, pos);
            pos[1] += active[i]->body_height;
            monster = active[i];
            if (monster->tbl->boss == 0) {

                s8 boss = monster->tbl->boss;
                monster->life_gage.Set(pos, monster->max_life, monster->life,
                                      fptosi(0.9f + monster->gekirin), (s8)boss);
                active[i]->life_gage.Step();
                active[i]->life_gage.Draw(view);
            } else {
                total_life += monster->life;
            }
        }
    }
    if (total_life > 0 && boss_max_life > 0) {
        boss_life_gage.Set(total_pos, boss_max_life, total_life, 0, 1);
        boss_life_gage.Step();
        boss_life_gage.Draw(0);
    }
}
void CMonsterMan::DrawPiyori() {
    int i;
    CActiveMonster *monster;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        monster = active[i];
        if (monster != NULL && monster->catch_state != 1 && monster->state != 0) {
            monster->piyori.Draw();
            active[i]->gift_mark.Draw();
        }
    }
}
void CMonsterMan::DrawActMonster() {
    mgCTextureManager *tex = &mgTexManager;
    CActiveMonster *monster;
    int i;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        monster = active[i];
        if (monster != NULL && monster->chara_kind == 2 && monster->view_state != 1 &&
            !(monster->alpha < 1.0f) && !(monster->view_alpha < 1.0f) &&
            !(monster->camera_alpha < 1.0f)) {
            tex->ReloadTexture(monster->refer_no + 0x28, (sceVif1Packet *)NULL);
            active[i]->DrawDirect();
        }
    }
}
void CMonsterMan::DrawInvisibleMonster() {
    mgCTextureManager *textures = &mgTexManager;
    int index;
    CActiveMonster *monster;
    float saved_alpha;

    for (index = 0; index < MONSTER_ACTIVE_MAX; index++) {
        monster = active[index];
        if (monster != NULL && monster->chara_kind == 2) {
            float &alpha = monster->alpha;
            saved_alpha = alpha;
            if ((saved_alpha < 1.0f || monster->view_alpha < 1.0f || monster->camera_alpha < 1.0f) &&
                !(monster->view_alpha <= 0.0f) && !(monster->camera_alpha <= 0.0f)) {
                if (!(saved_alpha < 1.0f)) {
                    alpha = monster->view_alpha;
                }
                active[index]->alpha *= active[index]->camera_alpha;
                textures->ReloadTexture(active[index]->refer_no + 0x28, (sceVif1Packet *)NULL);
                active[index]->DrawDirect();
                active[index]->alpha = saved_alpha;
            }
        }
    }
}

void CMonsterMan::PriorityLevelCheck() {
    int order[MONSTER_ACTIVE_MAX];
    int count = 0;
    int i;
    int j;
    int swapped;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        if (active[i] != NULL) {
            active[i]->priority = -1;
            if (active[i]->chara_kind == 2 && active[i]->state != 0) {
                order[count] = i;
                count++;
            }
        }
    }
    for (i = 0; i < count - 1; i++) {
        for (j = i + 1; j < count; j++) {
            if (!(active[order[i]]->target_dist <=
                  active[order[j]]->target_dist)) {
                swapped = order[i];
                order[i] = order[j];
                order[j] = swapped;
            }
        }
    }
    for (i = 0; i < count; i++) {
        active[order[i]]->priority = i;
    }
}
CActiveMonster *CMonsterMan::GetPriorityLevelIndex(int level, int *slot) {
    int i;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        if (active[i] != NULL && active[i]->chara_kind == 2 &&
            active[i]->priority == level) {
            if (slot != NULL) {
                *slot = i + MONSTER_ACTIVE_MAX;
            }
            return active[i];
        }
    }
    return NULL;
}

void CMonsterMan::SetNearAreaPiyori(float limit) {
    CActiveMonster *monster;
    int i;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        monster = active[i];
        if (monster != NULL && monster->chara_kind == 2 && monster->target_dist <= limit &&
            monster->catch_state == 0 && monster->damage_time <= 0 && !(monster->attrib & 0x20)) {
            monster->req_prog = MONSTER_PROG_PIYORI;
            monster->piyori_time = 120;
        }
    }
}
int CMonsterMan::IsRunEvent() {
    int i;
    CActiveMonster *monster;
    int event;

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        monster = active[i];
        if (monster != NULL && (event = monster->event_no) != -1) {
            monster->event_no = -1;
            return event;
        }
    }
    return -1;
}
void CMonsterMan::CollisionCheck(CActiveMonster *monster, float *pos, float *move, float *push) {
    float next[4];
    float center[4];
    float other_pos[4];
    float away[4];
    int i;
    CActiveMonster *other;
    u32 se_handle;
    float height_scale;
    float reach;
    float dist;
    float overlap;

    sceVu0CopyVector(push, move);
    next[0] = pos[0] + push[0];
    next[1] = pos[1] + push[1];
    next[2] = pos[2] + push[2];
    sceVu0CopyVector(center, next);
    center[1] = 0.0f;
    se_handle = scene->se_battle_id;
    if (monster->catch_state == 1) {
        return;
    }
    for (i = 0; i < MONSTER_ACTIVE_MAX + 1; i++) {
        if (i == 0) {
            other = (CActiveMonster *)scene->GetCharacter(0);
        }
        if (i != 0) {
            other = active[i - 1];
        }
        if (other == NULL || other == monster || other->chara_kind != 2 ||
            (monster->catch_state == 2 && i == 0)) {
            continue;
        }
        other->GetPosition(other_pos);
        height_scale = 1.0f;
        if (monster->catch_state == 2 && i != 0) {
            ((CCharacter2 *)other)->GetEntryObjectPos(0, other_pos);
            height_scale = 2.0f;
        }
        if (next[1] + monster->body_height * height_scale < other_pos[1] ||
            !(next[1] <= other_pos[1] + other->body_height * height_scale)) {
            continue;
        }
        other_pos[1] = 0.0f;
        reach = 2.0f * other->body_width + 2.0f * monster->body_width * height_scale;
        dist = mgDistVector(other_pos, center);
        if (dist < reach) {
            if (monster->catch_state == 2 && i != 0) {
                printf(at_1999);
                other->req_prog = MONSTER_PROG_PIYORI;
                other->piyori_time = 120;
                sceVu0ScaleVectorXYZ(push, push, -0.8f);
                sceVu0CopyVector(other->blow_vec, push);
                other->blow_vec[1] = 0.0f;
                sceVu0Normalize(other->blow_vec, other->blow_vec);
                sceVu0ScaleVectorXYZ(other->blow_vec, other->blow_vec, -1.0f);
                other->blow_speed = 2.0f;
                other->blow_rate = 1.0f;
                other->blow_decel = 0.0f;
                other->blow_time = 3;
                HitEffectSet(scene, pos, 0);
                sndSePlay(se_handle, 0x1C, 0);
                monster->req_prog = MONSTER_PROG_PIYORI;
                monster->piyori_time = 0x1E;
                monster->catch_state = 0;
            }
            if (i != 0) {
                overlap = reach - dist;
                away[0] = center[0] - other_pos[0];
                away[1] = center[1] - other_pos[1];
                away[2] = center[2] - other_pos[2];
                away[3] = 1.0f;
                sceVu0Normalize(away, away);
                push[0] = (push[0] + away[0] * overlap) / 2.0f;
                push[1] = (push[1] + away[1] * overlap) / 2.0f;
                push[2] = (push[2] + away[2] * overlap) / 2.0f;
                push[3] = 1.0f;
                sceVu0ScaleVector(push, push, 1.5f);
            } else {
                push[2] = 0.0f;
                push[1] = 0.0f;
                push[0] = 0.0f;
                push[3] = 1.0f;
            }
        }
    }
}
float SearchArea(CScene *scene, float *from, float *to, float range) {
    CCPoly polys[128];
    mgVu0FBOX box;
    float hit[4];
    CMap *map = scene->GetMap(scene->active_map);
    if (map == NULL) {
        return range;
    }
    float margin = 10.0f + range;
    box.max[0] = margin + from[0];
    box.min[0] = from[0] - margin;
    box.max[1] = margin + from[1];
    box.min[1] = from[1] - margin;
    box.max[2] = margin + from[2];
    box.min[2] = from[2] - margin;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    int count = map->GetColPoly(polys, box, 128);
    if (CheckHit(polys, count, from, to, hit, 1, 2) < 0) {
        return range;
    }
    return mgDistVector(hit, from);
}
void HitEffectSet(CScene *scene, float *point, int flags) {
    float to_camera[4];
    float pos[4];
    EffectVector dir;
    mgRect<int> rect;
    CCameraControl *camera;
    CHitEffectImage *hit;
    CFlushEffect *flush;

    camera = GetCamera__6CSceneFi(scene, scene->active_camera);
    if (camera == NULL) {
        return;
    }
    sceVu0CopyVector(pos, point);
    camera->GetPos(to_camera);
    sceVu0SubVector(to_camera, to_camera, pos);
    sceVu0Normalize(to_camera, to_camera);
    sceVu0ScaleVector(to_camera, to_camera, 20.0f);
    sceVu0AddVector(pos, pos, to_camera);
    dir = at_2031;

    if (BattleFX.hit == NULL) {
        hit = NULL;
    } else {
        hit = BattleFX.hit + BattleFX.hit_next;
        BattleFX.hit_next++;
        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }
    if (hit != NULL) {
        const float speed = 60.0f;
        float gravity = 0.1f;
        float spread = 30.0f;
        float power = 0.2f;
        SethitEffect__15CHitEffectImageFPfPfffffii(hit, pos, dir.f, spread, speed, power, gravity, 30, 32);
        hit->kind = 0;
        rect.Set(32, 0, 32, 32);
        HitRectangle copy = *(HitRectangle *)&rect;
        hit->tex_rect.left = copy.left;
        hit->tex_rect.top = copy.top;
        hit->tex_rect.right = copy.right;
        hit->tex_rect.bottom = copy.bottom;
    }

    if (BattleFX.flush == NULL) {
        flush = NULL;
    } else {
        flush = BattleFX.flush + BattleFX.flush_next;
        BattleFX.flush_next++;
        if (BattleFX.flush_next >= BattleFX.flush_num) {
            BattleFX.flush_next = 0;
        }
    }
    if (flags & 2) {
        if (flush != NULL) {
            sceVu0CopyVector(flush->pos, pos);
            flush->fade_speed = 8.0f;
            flush->alpha = 160;
            flush->active = 1;
            flush->size = 16.0f;
            flush->grow = 2.0f;
            flush->tex_u = 128;
            flush->tex_v = 128;
            flush->tex_size = 128;
            flush->follow = NULL;
        }
    } else if (flush != NULL) {
        sceVu0CopyVector(flush->pos, pos);
        flush->fade_speed = 10.0f;
        flush->alpha = 160;
        flush->active = 1;
        flush->size = 15.0f;
        flush->grow = 1.5f;
        flush->tex_u = 128;
        flush->tex_v = 128;
        flush->tex_size = 128;
        flush->follow = NULL;
    }
    if (BattleFX.hit == NULL) {
        hit = NULL;
    } else {
        hit = BattleFX.hit + BattleFX.hit_next;
        BattleFX.hit_next++;
        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }
    if (hit != NULL) {
        hit->SethitEffect(pos, dir.f, 60.0f, 45.0f, 0.0f, 0.0f, 15, 16);
        hit->kind = 2;
    }
}
void GuardEffectSet(CScene *scene, float *point, int play_script) {
    float to_camera[4];
    float pos[4];
    EffectVector dir;
    CCameraControl *camera;
    CHitEffectImage *hit;
    CFlushEffect *flush;

    camera = GetCamera__6CSceneFi(scene, scene->active_camera);
    if (camera == NULL) {
        return;
    }
    sceVu0CopyVector(pos, point);
    camera->GetPos(to_camera);
    sceVu0SubVector(to_camera, to_camera, pos);
    sceVu0Normalize(to_camera, to_camera);
    sceVu0ScaleVector(to_camera, to_camera, 20.0f);
    sceVu0AddVector(pos, pos, to_camera);
    dir = at_2079__2;

    if (BattleFX.hit == NULL) {
        hit = NULL;
    } else {
        hit = BattleFX.hit + BattleFX.hit_next;
        BattleFX.hit_next++;
        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }
    float spread = 50.0f;
    float power_value = 0.0f;
    const float &power = power_value;
    const float speed = 30.0f;
    float gravity = 0.1f;
    SethitEffect__15CHitEffectImageFPfPfffffii(hit, pos, dir.f, spread, speed, power, gravity, 30, 32);
    hit->kind = 1;

    if (BattleFX.flush == NULL) {
        flush = NULL;
    } else {
        flush = BattleFX.flush + BattleFX.flush_next;
        BattleFX.flush_next++;
        if (BattleFX.flush_next >= BattleFX.flush_num) {
            BattleFX.flush_next = 0;
        }
    }
    if (flush != NULL) {
        sceVu0CopyVector(flush->pos, pos);
        flush->fade_speed = 16.0f;
        flush->alpha = 160;
        flush->active = 1;
        flush->size = 10.0f;
        flush->grow = 3.0f;
        flush->tex_u = 64;
        flush->tex_v = 192;
        flush->tex_size = 64;
        flush->follow = NULL;
    }
    if (play_script != 0) {
        FxScriptMan->CreateEffSpt(at_2100, 0, 0);
        FxScriptMan->SetScriptVect1(pos, 0, -1);
    }
}
void HitScoreSet(float *pos, int type, int value) {
    int *no_score = no_score_uv[LanguageCode];
    int *guard_score = guard_score_uv[LanguageCode];

    if (!init_2105) {
        dmg_sc_cnt_2104 = 0;
        init_2105 = 1;
    }
    switch (type) {
        case 0:
            DamageScoreMons[dmg_sc_cnt_2104].SetValue(pos, value);
            break;
        case 1:
            DamageScoreMons[dmg_sc_cnt_2104].SetSprite(pos, no_score[0], no_score[1], no_score[2],
                                                       no_score[3]);
            break;
        case 2:
            DamageScoreMons[dmg_sc_cnt_2104].SetSprite(pos, guard_score[0], guard_score[1],
                                                       guard_score[2], guard_score[3]);
            break;
    }
    if (dmg_sc_cnt_2104 == 7) {
        dmg_sc_cnt_2104 = 0;
    } else {
        dmg_sc_cnt_2104++;
    }
}
int CheckGiftPack(CActiveMonster *monster, CColPrim *prim) {
    int key = monster->tbl->gift_type;
    int row = 0;
    int i;

    while (gift_item_tbl[row][0] != -1) {
        if (gift_item_tbl[row][0] == key) {
            break;
        }
        row++;
    }
    if (gift_item_tbl[row][0] == -1) {
        return 0;
    }
    for (i = 0; i < 3; i++) {
        if (prim->gift[i] != gift_item_tbl[row][1]) {
            return 0;
        }
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", CheckDamage__11CMonsterManFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", MoveUnit__11CMonsterManFP14CActiveMonsterP6CCPolyi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", ThinkHost__11CMonsterManFv);
int _MONSTER_NAME(SPI_STACK *stack, int argument_count) {
    char name[0x80];
    int monster_id;
    char *text;
    BASE_MONSTER_TBL *monster;

    monster_id = spiGetStackInt(stack++);
    text = spiGetStackString(stack);
    monster = GetMonsterTable(monster_id);
    if (monster == NULL) {
        return 0;
    }
    memset(name, 0, 0x80);

    if (LanguageCode >= 2 && LanguageCode < 6) {
        ConvertFontCode(text, name);
    } else {
        strcpy(name, text);
    }

    if (strlen(name) > 0x1F) {
        return 0;
    }
    strcpy(monster->name, name);
    return 1;
}
void LoadMonsterLanguage(int language) {
    char text[0x4000];
    char path[0x40];
    int size;
    char *script = text;

    sprintf(path, at_2809, language);
    if (LoadFile2(path, script, &size, 0)) {
        CScriptInterpreter interpreter;

        interpreter.SetTag(mos_data_anlyze_tag);
        interpreter.SetScript(script, size);
        interpreter.Run();
    }
}

void CMonsterMan::DrawShadowActMonster() {
    float light_direction[4][4];
    float light_color[4][4];
    int index;
    CActiveMonster *monster;

    if (scene->GetMap(scene->active_map) == NULL) {
        return;
    }
    mgGetLight(light_direction, light_color);
    float shadow_direction[4] = {light_direction[0][0], light_direction[1][0], light_direction[2][0]};
    shadow_direction[1] = shadow_direction[1] < 0.0f ? -shadow_direction[1] : shadow_direction[1];
    if (shadow_direction[1] < 0.8f) {
        shadow_direction[1] = 0.8f;
    }
    float shadow_normal[4];
    float shadow_position[4];
    *(EffectVector *)shadow_normal = at_1707;
    for (index = 0; index < MONSTER_ACTIVE_MAX; index++) {
        monster = active[index];
        if (monster != NULL && monster->chara_kind == 2 && monster->catch_state != 1 &&
            monster->target_dist <= 0.6f * monster->clip_dist && monster->priority < priority_limit &&
            !(monster->alpha < 0.6f)) {
            *(EffectVector *)shadow_position = at_1724__2;
            active[index]->GetEntryObjectPos(1, shadow_position);
            shadow_position[1] -= 20.0f;
            mgSetDropShadowMatrix(shadow_direction, shadow_position, shadow_normal);
            active[index]->ShadowStep();
            active[index]->DrawShadowDirect();
        }
    }
}

int CMonsterMan::CheckPhoto(CScene::InScreenCharaInfo *info) {
    float position[4];
    float rotation[4];
    float direction[4];
    float object_matrix[4][4];
    float photo_matrix[4][4];
    mgVu0FBOX box;
    float screen_max[4];
    float screen_min[4];
    int selected_index = -1;
    float nearest_distance = 0.0f;
    float distance;
    float radius;

    info->chara_no = -1;
    for (int index = 0; index < MONSTER_ACTIVE_MAX; index++) {
        if (active[index] == NULL || active[index]->chara_kind != 2 || active[index]->alpha < 1.0f) {
            continue;
        }
        active[index]->GetRotation(rotation);
        CHARA_ENTRY_OBJECT *entry = active[index]->GetEntryObjectPos(0, 0, position);
        radius = 5.0f * entry->unk_04;
        mgGetDirFromCamera(direction, position);
        distance = mgDistVector(direction);
        if (!(distance <= 300.0f) && active[index]->tbl->boss == 0) {
            continue;
        }
        sceVu0Normalize(direction, direction);
        mgUnitMatrix(object_matrix);
        mgUnitMatrix(photo_matrix);
        sceVu0RotMatrixY(object_matrix, object_matrix, rotation[1]);
        ((EffectVector *)object_matrix[3])->qw = ((EffectVector *)position)->qw;
        object_matrix[3][3] = 1.0f;
        ((EffectVector *)photo_matrix[3])->qw = ((EffectVector *)position)->qw;
        photo_matrix[3][3] = 1.0f;
        sceVu0InnerProduct(direction, object_matrix[2]);
        mgZeroVectorW(box.max);
        mgZeroVectorW(box.min);
        box.max[1] = radius;
        box.min[1] = -radius;
        box.max[0] = radius;
        box.min[0] = -radius;
        box.min[2] = -radius;
        box.max[2] = radius;
        if (mgInsideScreen(&box, photo_matrix, screen_max, screen_min) &&
            !(screen_max[0] < -50.0f) && screen_min[0] <= 50.0f &&
            !(screen_max[1] < -50.0f) && screen_min[1] <= 50.0f &&
            (selected_index < 0 || !(nearest_distance <= distance))) {
            selected_index = index;
            nearest_distance = distance;
        }
    }
    if (selected_index < 0) {
        return -1;
    }
    info->chara_no = active[selected_index]->tbl->id;
    info->dist = nearest_distance - 10.0f;
    if (active[selected_index]->scoop.ok != 0) {
        return active[selected_index]->scoop.no;
    }
    return -1;
}




// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", base_monster_define__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", dung_progtxt_notlift_mons__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1707__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1724__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2031__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2079__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", no_score_uv__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", guard_score_uv__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", vs_attk_index__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", gift_item_tbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", react_tbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2183__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2294__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2699__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", mos_data_anlyze_tag__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1200__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1201__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1202__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1203__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1204__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1205__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1421__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1422__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1423__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1424__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1425__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1426__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1427__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1428__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1429__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1430__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1431__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_1999__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2100__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2485__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2486__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2487__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2488__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2588__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2589__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2802__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", at_2809__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/monster", __vt__14CActiveMonster__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(dmg_sc_cnt_2104, 0x4);
INCLUDE_BSS(init_2105, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_1704, 0x10);
