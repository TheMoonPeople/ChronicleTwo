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
#include <cstdlib>
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
#include "dng_debug.hpp"
#include "runscript_opcodes.hpp"
#include "maintex.hpp"
#include "mapparts.hpp"
#include "mapinfo.hpp"
#include "gameutil.hpp"

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
extern char at_2588[];
extern char at_2589[];
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
void CActiveMonster::Copy(CActiveMonster &dest, mgCMemory *memory) {
    dest = *this;
    if (memory != NULL) {
        CActionChara::Copy(dest, memory);
    }
}
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
    last_hit_kind = 0;
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

#ifdef NONMATCHING
void CMonsterMan::Initialize(CScene *scene) {
    mgCTextureManager *textures;
    int i;
    DNG_BATTLE_AREA *area = &scene->battle_area;
    int texb;

    SetMonsterExtendTable();
    textures = &mgTexManager;
    this->scene = scene;
    effect_man = FxScriptMan;
    priority_limit = 5;
    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        active[i] = (CActiveMonster *)scene->GetCharacter(i + MONSTER_ACTIVE_MAX);
        active[i]->Initialize();
    }
    for (i = 0; i < MONSTER_REFER_MAX; i++) {
        textures->DeleteBlock(i + 0x28);
        refer[i].id = -1;
    }
    for (i = 0; i < MONSTER_SHARE_MAX; i++) {
        share_var[i].i = 0;
    }
    FxScriptMan->ClearBaseFromLevel(3, NULL, -1);
    for (texb = area->free_texb; texb < 0xAA; texb++) {
        textures->DeleteBlock(texb);
    }
    boss_life_gage.Initialize(0);
    boss_max_life = 0;
    locate.num = 0;
    locate.put_num = 0;
    locate.put_flag = 0;
    for (i = 0; i < MONSTER_LOCATE_MAX; i++) {
        locate.param[i] = -1;
        locate.monster_id[i] = -1;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", Initialize__11CMonsterManFP6CScene);
#endif

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




#ifdef NONMATCHING
int CMonsterMan::CheckMonsterTolk(float *pos) {
    CActiveMonster *monster;
    int found;
    int i;
    float nearest;

    if (dbinfo.monster_talk != 0) {
        found = -1;
        nearest = 90.0f;
        i = 0;
        do {
            monster = active[i];
            if (monster != NULL && monster->IsDraw(1)) {
                monster = active[i];
                if (monster->tbl->boss == 0 && monster->locate_param != -1 && nearest > monster->target_dist) {
                    nearest = monster->target_dist;
                    found = i;
                }
            }
            i++;
        } while (i < MONSTER_ACTIVE_MAX);
        return found;
    }
    if (DngUserData->active_chr_no != 3) {
        return -1;
    }
    int mons_base = GetBattleCharaInfo()->unk_2;
    if (mons_base == -1) {
        return -1;
    }
    found = -1;
    i = 0;
    nearest = 90.0f;
    do {
        monster = active[i];
        if (monster != NULL && monster->IsDraw(1)) {
            monster = active[i];
            if (monster->tbl->user_mons_id == mons_base && monster->tbl->boss == 0 &&
                monster->locate_param != -1 && monster->gekirin > 0.0f && nearest > monster->target_dist) {
                nearest = monster->target_dist;
                found = i;
            }
        }
        i++;
    } while (i < MONSTER_ACTIVE_MAX);
    return found;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", CheckMonsterTolk__11CMonsterManFPf);
#endif

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
#ifdef NONMATCHING
extern char at_1421__2[];
extern char at_1422__2[];
extern char at_1423[];
extern char at_1424[];
extern char at_1425[];
extern char at_1426[];
extern char at_1427__2[];
extern char at_1428__3[];
extern char at_1429__2[];
extern char at_1430__2[];
extern char at_1431__2[];
int CMonsterMan::LoadReferMonsterFile(int id, BASE_MONSTER_TBL *tbl, mgCMemory *memory) {
    char path[0x40];
    char config_path[0x40];
    int size;
    int slot = SearchReferBlock();
    MONSTER_REFER *entry;
    int sound;
    int i;
    int blocks;
    mgCTextureManager *textures;

    if (slot == -1) {
        return 0;
    }
    entry = &refer[slot];
    if (entry == NULL) {
        return 0;
    }
    sprintf(config_path, at_1421__2, tbl->model);
    sprintf(path, at_1422__2, tbl->model);
    textures = &mgTexManager;
    textures->DeleteBlock(slot + 0x28);
    LoadFile(path, BuffReadData, &size);
    strcpy(textures->name_suffix, at_1423);
    entry->chara.Initialize();
    if (strcmp(tbl->model, at_1424) == 0 || strcmp(tbl->model, at_1425) == 0 ||
        strcmp(tbl->model, at_1426) == 0 || strcmp(tbl->model, at_1427__2) == 0) {
        entry->chara.LoadPackNoLine((unsigned int *)BuffReadData, config_path, memory, memory, memory, slot + 0x28, NULL);
    } else {
        entry->chara.LoadPack((unsigned int *)BuffReadData, config_path, memory, memory, memory, slot + 0x28, NULL);
    }
    textures->name_suffix[0] = 0;
    entry->chara.tbl = tbl;
    sound = -1;
    if (tbl->sound_no > 0) {
        if (tbl->sound_no < 10) {
            sprintf(path, at_1428__3, tbl->sound_no);
        } else if (tbl->sound_no < 100) {
            sprintf(path, at_1429__2, tbl->sound_no);
        } else {
            sprintf(path, at_1430__2, tbl->sound_no);
        }
        LoadFile(path, BuffReadData, &size);
        sound = sndLoadSound(5, (unsigned int *)BuffReadData, memory);
    }
    entry->chara.sound_info.se_bank = sound;
    for (i = 0; i < tbl->sw_effect_num; i++) {
        entry->chara.sword_effect[i] = new ((u_long128 *)memory->Alloc(0xC)) CSWordAfterEffect;
        entry->chara.sword_effect[i]->Initialize(memory, 0xC, 8);
        entry->chara.sword_effect[i]->SetTexture(0x4A, TEX_SystemEffectSw, 0, 0x20, 0x40, 0x20);
    }
    sprintf(path, at_1431__2, tbl->script);
    LoadFile(path, BuffReadData, &size);
    blocks = size / 16;
    entry->script = (char *)memory->stAlloc64(blocks + 1);
    if (entry->script == NULL) {
        return 0;
    }
    memcpy(entry->script, BuffReadData, size);
    entry->id = id;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", LoadReferMonsterFile__11CMonsterManFiP16BASE_MONSTER_TBLP9mgCMemory);
#endif
#ifdef NONMATCHING
CActiveMonster *CMonsterMan::SetActiveMonster(int refer_no, float *pos, float *rot, int param) {
    if (refer_no < 0 || refer_no >= MONSTER_REFER_MAX) {
        return NULL;
    }
    if (refer[refer_no].chara.GetFrame() == NULL) {
        return NULL;
    }
    int slot = SearchActiveMonsterBlock();
    if (slot < 0) {
        return NULL;
    }
    DNG_BATTLE_AREA *area = &scene->battle_area;
    int npc = GetBattleCharaInfo()->GetNowNPC();
    active[slot] = (CActiveMonster *)scene->GetCharacter(slot + MONSTER_ACTIVE_MAX);
    if (active[slot] == NULL) {
        return NULL;
    }
    memory[slot].stReset();
    locate.SetPutFlag(slot, 1);
    CActiveMonster *monster = active[slot];
    MONSTER_REFER *source = &refer[refer_no];
    BASE_MONSTER_TBL *tbl = GetReferPtr2(source->id);
    if (tbl->unk_b4 == 0) {
        source->chara.SetPosition(0.0f, 0.0f, 0.0f);
        source->chara.SetRotation(0.0f, 0.0f, 0.0f);
        source->chara.Copy(*monster, &memory[slot]);
    } else {
        *monster = source->chara;
        monster->unk_500 = (s32)monster->motion[0].frame_info;
        monster->shadow_frame_info = monster->shadow_motion[0].frame_info;
        monster->now_key = 0;
    }
    if (tbl->boss) {
        area->boss_map = 1;
    }
    monster->ResetMotion();
    monster->SetPosition(pos);
    monster->SetRotation(rot);
    monster->UpdatePosition();
    sceVu0CopyVector(monster->place_pos, pos);
    monster->param = *tbl;
    monster->base_tbl = tbl;
    monster->tbl = &monster->param;
    monster->monster_id = source->id;
    monster->chara_type = slot + MONSTER_ACTIVE_MAX;
    monster->chara_kind = 2;
    monster->Show(1, 1);
    monster->refer_no = refer_no;
    monster->view_state = MONSTER_VIEW_INIT;
    monster->view_alpha = 0.0f;
    monster->camera_alpha = 1.0f;
    monster->next_pos[0] = 0.0f;
    monster->next_pos[1] = 0.0f;
    monster->next_pos[2] = 0.0f;
    monster->next_pos[3] = 1.0f;
    monster->move_speed = 0.0f;
    monster->max_life = monster->life = tbl->life;
    monster->reward_exp = tbl->unk_56;
    monster->reward_money = tbl->unk_58;
    monster->unk_1322 = tbl->unk_5a;
    monster->whp = tbl->whp;
    monster->attack = tbl->attack;
    monster->defense = tbl->defense;
    monster->gekirin_num = tbl->gekirin_num;
    if (npc == 8) {
        monster->gekirin_num += 2;
    }
    if (tbl->boss) {
        monster->gekirin = -1.0f;
        monster->life_gage.Initialize(0);
        boss_max_life += monster->max_life;
    } else {
        monster->gekirin = monster->gekirin_num;
        monster->life_gage.Initialize(fptosi(monster->gekirin));
    }
    monster->gekirin_time = 0;
    monster->piyori.Initialize();
    monster->gift_mark.Initialize();
    monster->drop_badge = 0;
    monster->sound_info.loop_se = &scene->loop_se;
    monster->unk_134c = param;
    monster->locate_param = -1;
    monster->attrib = 0;
    monster->state = ACTIVE_MONSTER_LIVE;
    monster->target_no = 0;
    monster->target_dist = 999999.0f;
    monster->camera_dist = 999999.0f;
    monster->clip_dist = 800.0f;
    monster->alpha = 1.0f;
    monster->unk_1300 = 400.0f;
    monster->unk_1304 = 300.0f;
    monster->unk_1308 = 180;
    monster->stagger = 0;
    monster->stagger_time = 0;
    monster->target_dist = 0.0f;
    monster->priority = -1;
    for (int i = 0; i < MONSTER_VAR_MAX; i++) {
        monster->var[i].i = 0;
    }
    for (int i = 0; i < MONSTER_VAR2_MAX; i++) {
        monster->var2[i].i = 0;
    }
    SetMonsterScript(&monster->mons_script, source->script, &memory[slot]);
    monster->req_prog = MONSTER_PROG_INIT;
    RunScript(slot);
    monster->req_prog = MONSTER_PROG_MAIN;
    return active[slot];
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", SetActiveMonster__11CMonsterManFiPfPfi);
#endif
void CMonsterMan::DrawMiniMapSymbol(CMiniMapSymbol *symbol) {
    CBattleCharaInfo *battle_info;
    int show_all;
    int i;
    int symbol_no;
    CActiveMonster *monster;
    float pos[4];

    if (symbol != NULL) {
        show_all = 0;
        if (scene->battle_area.minimap_reveal & MINIMAP_REVEAL_SYMBOLS) {
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
    float power;

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
        float speed = 60.0f;
        float spread = 30.0f;
        float gravity = 0.1f;
        power = 0.2f;
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
    float speed = 30.0f;
    float power_value = 0.0f;
    const float &power = power_value;
    float spread = 50.0f;
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
#ifdef NONMATCHING
extern MONSTER_REACT react_tbl[];
extern s16 vs_attk_index[];
extern CFireAfterHit fireAfterHit[];
extern CChillAfterHit chillAfterHit[];
extern CThunder thunder[];
extern CTornado tornado[];
extern char at_2485[];
extern char at_2486[];
extern char at_2487[];
extern char at_2488[];
#pragma divbyzerocheck on
void CMonsterMan::CheckDamage() {
    CScene *now_scene = scene;
    DNG_BATTLE_AREA *area = &now_scene->battle_area;
    u_int se_id = now_scene->se_battle_id;
    CActionChara *player = (CActionChara *)now_scene->GetCharacter(0);
    CBattleCharaInfo *chara_info = GetBattleCharaInfo();
    int gift_pack_num = GetUserItemHaveNum(0x134);

    for (int i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        CActiveMonster *monster = active[i];
        if (monster == NULL || monster->state != ACTIVE_MONSTER_LIVE) {
            continue;
        }
        BASE_MONSTER_TBL *tbl = monster->tbl;
        if (monster->damage_time > 0) {
            continue;
        }
        if (monster->attrib & MONSTER_ATTRIB_NO_DAMAGE) {
            continue;
        }
        if (monster->catch_state != 0) {
            continue;
        }
        CColPrim *prim = ColPrimMan.CheckHit(i + 0x18);
        if (prim != NULL) {
            if (prim->has_gift) {
                if (CheckGiftPack(monster, prim) && gift_pack_num != 0) {
                    monster->gift_mark.Set(monster, monster->body_height);
                    monster->drop_badge = 1;
                } else {
                    GuardEffectSet(scene, prim->hit_pos, 1);
                }
                continue;
            }
            if (prim->param->kind == DAMAGE_KIND_CHECK) {
                continue;
            }
            monster->att_type = prim->param->kind;
            MONSTER_REACT *react = react_tbl;
            while (react->kind != prim->param->kind) {
                react++;
                if (react->kind == -1) {
                    react = react_tbl;
                    break;
                }
            }
            area->unk_98 |= react->flag;
            int melee = 0;
            if (prim->param->kind == DAMAGE_KIND_MAX_MELEE || prim->param->kind == DAMAGE_KIND_MONICA_MELEE) {
                melee = 1;
            }
            float damage = prim->damage - monster->defense;
            if (prim->status & 0x1000) {
                damage = (float)monster->max_life * (0.01f * (float)prim->param->damage) *
                         (0.01f * (float)monster->tbl->unk_ae);
            }
            if (prim->status & 0x40000) {
                if (monster->tbl->user_mons_id != 9) {
                    damage = 0.0f;
                }
                printf(at_2485, prim->status);
            }
            float element_rate[8] = {0.6f, 1.2f, 1.4f, 0.8f, 1.0f, 1.0f, 1.0f, 1.0f};
            float element_damage = 0.0f;
            damage *= 0.01f * (float)tbl->ext_param[vs_attk_index[prim->param->kind]];
            BASE_MONSTER_TBL *resist_tbl = monster->tbl;
            for (int e = 0; e < 8; e++) {
                float power = 0.007843138f * (float)prim->element[e];
                float resist = 0.01f * (float)resist_tbl->unk_6c[e];
                if (area->unk_8c != 2) {
                    element_damage += resist * (damage * power);
                } else {
                    element_damage += resist * (damage * power) * element_rate[e];
                }
            }
            damage += element_damage;
            int element = -1;
            int element_power = 0;
            for (int e = 0; e < 4; e++) {
                if (element_power < prim->element[e] && prim->element[e] > 16) {
                    element_power = prim->element[e];
                    element = e;
                }
            }
            if (resist_tbl->user_mons_id == 4 && chara_info->GetNowNPC() == 3) {
                damage *= 1.2f;
            }
            if (monster->tbl->user_mons_id == 9 && chara_info->GetNowNPC() == 0x13) {
                damage *= 1.2f;
            }
            if (prim->param->hit_count > 1) {
                damage /= (float)prim->param->hit_count;
            }
            float dist = mgDistVector(prim->pos[0], prim->origin);
            printf(at_2486, dist, prim->range);
            float half_range = prim->range / 2.0f;
            if (!(dist <= half_range)) {
                float rate;
                if (!(dist <= prim->range)) {
                    rate = 0.0f;
                } else {
                    rate = 1.0f - (dist - half_range) / half_range;
                }
                damage *= rate;
                printf(at_2487, rate);
            }
            if (!(damage < 0.0f)) {
                damage = GetDispVolumeForFloat(damage);
            }
            if ((int)damage <= 0) {
                damage = 0.0f;
                monster->no_damage_cnt++;
            }
            if (monster->muteki_time > 0) {
                damage = 0.0f;
            }
            if (monster->status.attr & (MONSTER_STATUS_UNK_8 | MONSTER_STATUS_UNK_20)) {
                monster->status.grey_time -= 0x5A;
                if (monster->status.grey_time <= 0) {
                    monster->status.grey_time = 0;
                    monster->status.attr &= ~(MONSTER_STATUS_UNK_8 | MONSTER_STATUS_UNK_20);
                }
            }
            int greyed = 0;
            BASE_MONSTER_TBL *status_tbl = monster->tbl;
            s16 status_rate = status_tbl->unk_ac / prim->param->hit_count;
            int hit_damage = (int)damage;
            if (hit_damage > 0) {
                if ((prim->status & 0x4) && !(status_tbl->resist_attr & 0x4) && status_rate >= iRand(100)) {
                    monster->status.attr |= MONSTER_STATUS_POISON;
                    monster->status.poison_count = 0x78;
                }
                if ((prim->status & 0x8) && !(monster->status.attr & (MONSTER_STATUS_UNK_8 | MONSTER_STATUS_UNK_20)) &&
                    !(monster->tbl->resist_attr & 0x8) && status_rate >= iRand(100)) {
                    greyed = 1;
                    monster->status.attr |= MONSTER_STATUS_UNK_8;
                    monster->status.grey_time = 300;
                }
                if ((prim->status & 0x8000) && !(monster->status.attr & MONSTER_STATUS_UNK_20) &&
                    !(monster->tbl->resist_attr & 0x8000) && status_rate >= iRand(100)) {
                    greyed = 1;
                    monster->status.attr |= MONSTER_STATUS_UNK_20;
                    monster->status.grey_time = 900;
                }
                if ((prim->status & 0x10000) && !(monster->tbl->resist_attr & 0x10000) && status_rate >= iRand(100)) {
                    monster->status.attr |= MONSTER_STATUS_SLOW;
                    monster->status.slow_time = 1800;
                }
            }
            if (hit_damage > 0 && (prim->status & 0x200) && (prim->attacker == 0 || prim->attacker == 1)) {
                damage *= 1.5f;
                if (chara_info->GetNowHp_i() > 1) {
                    chara_info->AddHp_Point(-(0.01f * (float)chara_info->GetMaxHp_i()), 0.0f);
                }
            }
            if ((int)damage > 0 && (prim->status & 0x400) && iRand(10) == 0) {
                damage *= 1.8f;
            }
            int final_damage = (int)damage;
            if (final_damage > 0 && (prim->status & 0x80) && prim->attacker == chara_info->chr_no) {
                int drain_rate = 25 / prim->param->hit_count;
                if (drain_rate <= 1) {
                    drain_rate = 1;
                }
                if (drain_rate >= iRand(100)) {
                    chara_info->AddHp_Point(0.02f * damage, 0.0f);
                }
            }
            if (final_damage > 0 && (prim->status & 0x10)) {
                int steal_rate = 12 / prim->param->hit_count;
                if (steal_rate <= 1) {
                    steal_rate = 1;
                }
                int roll = (iRand(100) + iRand(100)) / 2;
                printf(at_2488, steal_rate, roll);
                if (steal_rate >= roll && (monster->tbl->drop_item[0] > 0 || monster->tbl->drop_item[1] > 0)) {
                    int slot = 0;
                    if (iRand(100) < 20 && monster->tbl->drop_item[1] > 0) {
                        slot = 1;
                    }
                    if (monster->tbl->drop_item[0] <= 0) {
                        slot = 1;
                    }
                    if (CheckGetItemLimmitOver(monster->tbl->drop_item[slot], 1) > 0) {
                        CPullItem *item = PullItemMan.GetList(2);
                        if (item != NULL) {
                            float velocity[4] = {0.0f, 2.0f, 0.0f, 1.0f};
                            float item_pos[4];
                            monster->GetEntryObjectPos(0, item_pos);
                            item_pos[1] += 20.0f;
                            item->SetItem(item_pos, velocity, 7);
                            item->item_no = monster->tbl->drop_item[slot];
                            monster->tbl->drop_item[0] = 0;
                            monster->tbl->drop_item[1] = 0;
                        }
                    }
                }
            }
            int guard = 0;
            if (iRand(100) < tbl->guard_rate) {
                guard = 1;
            }
            if (monster->mask_flag & 1) {
                guard = 0;
            }
            if (monster->guard_flag != 0) {
                guard = 1;
            }
            if (monster->piyori_time > 0) {
                guard = 0;
            }
            if (prim->param->hit_flags & 8) {
                guard = 0;
            }
            if (guard) {
                damage *= 0.01f * (float)prim->param->critical_rate;
            }
            calcWeaponParamWhp(monster, prim);
            int dealt = (int)damage;
            monster->life -= dealt;
            if (monster->life <= 0) {
                monster->life = 0;
            }
            if (dealt <= 0) {
                monster->no_damage_cnt++;
                GuardEffectSet(scene, prim->hit_pos, 0);
                sndSePlay(se_id, 0x26, 0);
                if (guard) {
                    HitScoreSet(prim->hit_pos, 2, 0);
                    monster->req_prog = MONSTER_PROG_GUARD;
                } else {
                    HitScoreSet(prim->hit_pos, 1, 0);
                }
                if (melee) {
                    player->unk_bec = 1;
                }
                continue;
            }
            if (!(monster->attrib & MONSTER_ATTRIB_UNK_80) && react->blow != 0) {
                float monster_pos[4];
                monster->GetPosition(monster_pos);
                sceVu0SubVector(monster->blow_vec, monster_pos, prim->hit_pos);
                sceVu0CopyVector(monster->blow_vec, monster->blow_vec);
                monster->blow_vec[1] = 0.0f;
                sceVu0Normalize(monster->blow_vec, monster->blow_vec);
                monster->blow_speed = 2.0f;
                monster->blow_rate = 1.0f;
                monster->blow_decel = 0.0f;
                monster->blow_time = 3;
            }
            monster->damage_time = prim->param->stun_time;
            switch (element) {
            case 2:
                monster->pallet[0].SetAnim(0xB4, 0xB4, 0, 4, 0x18, 0);
                break;
            case 0:
                monster->pallet[0].SetAnim(0xFF, 0x60, 0, 1, 0x18, 0);
                break;
            case 3:
                monster->pallet[0].SetAnim(0x60, 0xA0, 0x60, 1, 0x18, 0);
                break;
            case 1:
                monster->pallet[0].SetAnim(0, 0xB4, 0xFF, 1, 0x18, 0);
                break;
            case -1:
            default:
                monster->pallet[0].SetAnim(0xFF, 0xB4, 0x80, 2, 0xA, 0);
                break;
            }
            monster->shake.time = 4;
            int se_no = -1;
            switch (prim->param->kind) {
            case DAMAGE_KIND_MONSTER:
            case 21:
            case DAMAGE_KIND_ITEM:
            case DAMAGE_KIND_MAX_MELEE:
                se_no = 0x1C;
                break;
            case DAMAGE_KIND_MAX_GUN:
                se_no = 0x1A;
                break;
            case DAMAGE_KIND_MONICA_MELEE:
            case DAMAGE_KIND_RIDEPOD_SWORD:
                se_no = 0x1B;
                break;
            case DAMAGE_KIND_RIDEPOD_PUNCH:
                se_no = 0x19;
                break;
            case 14:
            case DAMAGE_KIND_RIDEPOD_GUN:
            case DAMAGE_KIND_MONICA_MAGIC:
            case DAMAGE_KIND_LASER_GUN:
            case DAMAGE_KIND_GRENADE:
                break;
            }
            if (se_no >= 0) {
                sndSePlay(se_id, se_no, 0);
            }
            HitEffectSet(scene, prim->hit_pos, (s16)prim->param->hit_flags);
            if (element >= 0 || dbinfo.effect_id > 0) {
                float power = prim->element[element];
                if (dbinfo.effect_id > 0) {
                    element = dbinfo.effect_id - 1;
                    power = dbinfo.effect_vol;
                }
                CWeaponElement *effect = GetWeaponEffect();
                if (effect != NULL) {
                    effect->Set(&monster->center_pos, monster->center_pos, power, element, 2.0f * monster->body_width);
                }
                int contact;
                if (prim->param->kind != DAMAGE_KIND_RIDEPOD_SWORD && prim->param->kind != DAMAGE_KIND_RIDEPOD_PUNCH &&
                    prim->param->kind != DAMAGE_KIND_MONICA_MELEE && prim->param->kind != DAMAGE_KIND_MAX_MELEE) {
                    contact = 0;
                } else {
                    contact = 1;
                }
                if (contact) {
                    switch (element) {
                    case 0:
                        fireAfterHit[0].SetPos(monster->center_pos, 5.0f * monster->body_width, (int)power);
                        break;
                    case 1:
                        chillAfterHit[0].SetPos(monster->center_pos, 5.0f * monster->body_width, (int)power);
                        break;
                    case 2:
                        thunder[0].SetPos(monster->center_pos, 5.0f * monster->body_width, power);
                        break;
                    case 3: {
                        float tornado_pos[4];
                        monster->GetPosition(tornado_pos);
                        tornado[0].SetPos(tornado_pos, 5.0f * monster->body_width, power);
                        break;
                    }
                    }
                }
            }
            HitScoreSet(prim->hit_pos, 0, dealt);
            int reaction = 2;
            if (prim->param->hit_flags & 2) {
                reaction = 4;
            }
            if (prim->param->hit_flags & 4) {
                reaction = 1;
            }
            if (greyed) {
                reaction = 3;
            }
            if (monster->status.attr & (MONSTER_STATUS_UNK_8 | MONSTER_STATUS_UNK_20)) {
                reaction = 3;
            }
            if (monster->life <= 0) {
                monster->last_hit_kind = prim->param->kind;
                monster->last_hit_chara = prim->attacker;
                monster->last_hit_source = prim->param->source_type;
                monster->last_hit_attr = prim->status;
                reaction = 6;
                if (gift_pack_num != 0) {
                    if (monster->monster_id >= 0xB0 && monster->monster_id < 0xB5 && (prim->status & 0x40000)) {
                        monster->drop_badge = 1;
                    }
                    if (monster->monster_id == 0xDC && (prim->status & 0x80000)) {
                        monster->drop_badge = 1;
                    }
                }
            }
            if (dealt > 0 && !(monster->gekirin <= 0.0f)) {
                monster->gekirin -= 1.0f / (float)prim->param->hit_count;
                if (monster->gekirin <= 0.0f) {
                    monster->gekirin = 0.0f;
                    monster->gekirin_time = 900;
                    monster->pallet[1].SetAnim(0xC8, 0xC8, 0x80, 1, 0x1E, -1);
                    if (monster->tbl->boss == 0) {
                        monster->attack = 1.3f * (u16)monster->tbl->attack;
                    }
                }
            }
            switch (reaction) {
            case 3:
                monster->req_prog = MONSTER_PROG_STATUS;
                sndSePlay(monster->sound_info.se_bank, 0xB, 0);
                break;
            case 2:
                if (guard) {
                    monster->req_prog = MONSTER_PROG_GUARD;
                    break;
                }
                if ((tbl->unk_94 & 1) || monster->piyori_time > 0) {
                    break;
                }
                if (monster->tbl->stagger > 0) {
                    monster->stagger += prim->param->stagger;
                    monster->stagger_time = 60;
                    if (monster->stagger < monster->tbl->stagger) {
                        break;
                    }
                }
                monster->req_prog = MONSTER_PROG_DAMAGE;
                sndSePlay(monster->sound_info.se_bank, 0xB, 0);
                break;
            case 4:
                if (tbl->unk_94 & 4) {
                    break;
                }
                monster->req_prog = MONSTER_PROG_KNOCK;
                monster->piyori.Reset();
                monster->stagger = 0;
                monster->stagger_time = 0;
                break;
            case 1:
                break;
            case 6:
                monster->req_prog = MONSTER_PROG_DEAD;
                monster->piyori.Reset();
                break;
            }
        }
        if ((monster->req_prog == MONSTER_PROG_DAMAGE || monster->req_prog == MONSTER_PROG_KNOCK) && prim != NULL &&
            (prim->param->hit_flags & 1)) {
            monster->req_prog = MONSTER_PROG_PIYORI;
            monster->piyori_time = 0x78;
        }
    }
}
#pragma divbyzerocheck reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", CheckDamage__11CMonsterManFv);
#endif
void CMonsterMan::MoveUnit(CActiveMonster *monster, CCPoly *poly, int poly_num) {
    float position[4];
    float rotation[4];
    float move[4];
    float new_position[4];
    float wanted[4];
    float toward[4];
    float ray_from[4];
    float ray_to[4];
    float ray_hit[4];
    float effect_position[4];
    float matrix[4][4];
    int i;
    u32 sound_bank = scene->se_battle_id;

    monster->GetPosition(position);
    monster->GetRotation(rotation);
    sceVu0CopyVector(wanted, monster->velocity);
    sceVu0SubVector(toward, monster->next_pos, position);
    sceVu0Normalize(toward, toward);
    sceVu0ScaleVectorXYZ(toward, toward, monster->move_speed);
    if (!(monster->attrib & MONSTER_ATTRIB_SET_VELOCITY)) {
        sceVu0AddVector(wanted, wanted, toward);
    } else {
        sceVu0CopyVector(wanted, toward);
    }
    if (monster->state == ACTIVE_MONSTER_LIVE) {
        if (!(monster->attrib & MONSTER_ATTRIB_NO_BODY_HIT)) {
            CollisionCheck(monster, position, wanted, move);
        } else {
            sceVu0CopyVector(move, wanted);
        }
    } else {
        sceVu0CopyVector(move, wanted);
    }
    monster->height = 0.0f;
    sceVu0CopyVector(ray_from, position);
    sceVu0CopyVector(ray_to, position);
    ray_from[1] += 5.0f;
    ray_to[1] -= 1000.0f;
    if (CheckHit(poly, poly_num, ray_from, ray_to, ray_hit, 1, 2) >= 0) {
        monster->height = position[1] - ray_hit[1];
    }
    if (!(monster->attrib & MONSTER_ATTRIB_NO_MAP_HIT)) {
        monster->mons_move_check.radius = monster->body_width;
        if (monster->catch_state != 0) {
            monster->mons_move_check.radius = 5.0f + 2.5f * monster->mons_move_check.radius;
        }
        monster->mons_move_check.skip_ground = 0;
        if (monster->attrib & MONSTER_ATTRIB_SKIP_GROUND) {
            monster->mons_move_check.skip_ground = 1;
        }
        MoveCheck(position, move, new_position, &monster->mons_move_check, poly, poly_num, 2);
    } else {
        sceVu0AddVector(new_position, position, move);
        monster->mons_move_check.landed = 0;
    }
    if (!(monster->attrib & MONSTER_ATTRIB_SET_VELOCITY)) {
        if (monster->mons_move_check.landed != 0) {
            if (monster->catch_state == 2) {
                monster->req_prog = MONSTER_PROG_LAND;
                int ground = -1;
                if (monster->mons_move_check.landed != 0) {
                    ground = monster->mons_move_check.ground_poly.foot_sound;
                    if (ground == 0) {
                        CMap *map = scene->GetMap(scene->active_map);
                        if (map != NULL) {
                            ground = map->def_foot;
                        }
                    }
                    if (ground != 0xB && ground != 0x12) {
                        ground = -1;
                    }
                }
                if (ground == -1) {
                    FxScriptMan->CreateEffSpt(at_2588, 0, 0);
                    FxScriptMan->SetScriptVect1(monster->mons_move_check.ground_point, 0, -1);
                    sndSePlay(sound_bank, 30, 0);
                } else {
                    for (i = 0; i < 4; i++) {
                        sceVu0CopyVector(effect_position, monster->mons_move_check.ground_point);
                        effect_position[0] += fRand(40.0f) - 20.0f;
                        effect_position[2] += fRand(40.0f) - 20.0f;
                        FxScriptMan->CreateEffSpt(at_2589, 0, 0);
                        FxScriptMan->SetScriptVect1(effect_position, 0, -1);
                    }
                    sndSePlay(sound_bank, 30, 0);
                }
            }
            if (move[1] < -0.6f) {
                move[1] *= -0.6f;
            }
        } else {
            move[1] -= 0.6f;
            if (move[1] <= -3.5f) {
                move[1] = -3.5f;
            }
        }
    }
    if (scene->GetCharacter(monster->target_no) != NULL && monster->move_speed != 0.0f &&
        mgDistVector(monster->next_pos, new_position) < monster->arrive_dist) {
        monster->move_speed = 0.0f;
    }
    if (monster->rot_speed != 0.0f) {
        rotation[1] = mgAngleInterpolate(rotation[1], monster->next_rot, monster->rot_speed, 0);
        if (mgAngleCmp(rotation[1], monster->next_rot, 0.049087387f) == 0) {
            monster->rot_speed = 0.0f;
        }
    } else {
        monster->GetRotation(rotation);
    }
    monster->SetPosition(new_position);
    monster->SetRotation(rotation);
    sceVu0CopyVector(monster->velocity, move);
    if (monster->link_piece != NULL && monster->link_type == MONSTER_LINK_PIECE) {
        monster->link_parts->GetLWMatrix(matrix);
        monster->link_piece->GetPosition(position);
        sceVu0ApplyMatrix(position, matrix, position);
        monster->SetPosition(position);
        monster->link_piece->SetRotation(rotation);
    }
    if (monster->link_parts != NULL && monster->link_type == MONSTER_LINK_PARTS) {
        monster->link_parts->SetPosition(new_position);
        monster->link_parts->SetRotation(rotation);
    }
}
#ifdef NONMATCHING
extern EffectVector at_2699;
void CMonsterMan::ThinkHost() {
    sceVu0FVECTOR monster_pos;
    CCPoly polys[0x80];
    sceVu0FVECTOR camera_pos;
    sceVu0FVECTOR target_pos;
    sceVu0FVECTOR own_pos;
    mgVu0FBOX box;
    sceVu0FVECTOR item_pos;
    CMap *map = scene->GetMap(scene->active_map);
    if (map == NULL) {
        return;
    }
    CCameraControl *camera = GetCamera__6CSceneFi(scene, scene->active_camera);
    if (camera != NULL) {
        camera->GetPos(camera_pos);
    }
    int user_monster = -1;
    if (DngUserData->active_chr_no == 3) {
        user_monster = GetBattleCharaInfo()->unk_2;
    }
    for (int i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        CActiveMonster *monster = active[i];
        if (monster == NULL || monster->state == ACTIVE_MONSTER_NONE) {
            continue;
        }
        monster->GetEntryObjectPos(0, 0, monster->center_pos);
        monster->scoop.ok = 0;
        MONSTER_SCOOP *scoop = &monster->scoop;
        if (monster->scoop.type & MONSTER_SCOOP_ALWAYS) {
            scoop->ok = 1;
        }
        if (monster->scoop.type != 0 && (monster->scoop.type & MONSTER_SCOOP_MOTION)) {
            char *motion = monster->GetNowMotionName();
            if (motion != NULL && strcmp(motion, scoop->motion) == 0) {
                float frame = monster->GetNowFrameWait(NULL);
                if (!(frame < scoop->start) && frame < scoop->end) {
                    scoop->ok = 1;
                }
            }
        }
        if (scene->battle_area.pause_flag & 0x1000) {
            if (monster->tbl->user_mons_id == user_monster) {
                monster->Step();
            }
            continue;
        }
        if (monster->catch_state == 1) {
            RunScript(i);
            monster->SetPosition(0.0f, -2.0f, 0.0f);
            monster->Step();
            ACTION_DAMAGE *damage = monster->damage;
            for (int n = 0; n < 11; n++) {
                if (damage->use != 0) {
                    if (damage->prim != NULL) {
                        damage->prim->Delete(-1);
                        damage->prim = NULL;
                    }
                    damage++;
                }
            }
            continue;
        }
        monster->CheckStatusAttr();
        monster->GetPosition(monster_pos);
        BASE_MONSTER_TBL *tbl = monster->tbl;
        CActionChara *target = NULL;
        if (monster->target_no != -1) {
            target = (CActionChara *)scene->GetCharacter(monster->target_no);
        }
        if (target != NULL) {
            target->GetPosition(target_pos);
            monster->GetPosition(own_pos);
            monster->target_dist = mgDistVector(target_pos, own_pos);
            if (AutoMapGen.GetNaviDistance(own_pos) < 0.0f) {
                monster->target_dist = 9999999.0f;
            }
            if (camera != NULL) {
                monster->camera_dist = mgDistVector(camera_pos, own_pos);
            }
            if (monster->state != ACTIVE_MONSTER_DEAD && monster->CheckView(priority_limit) == MONSTER_VIEW_OUT) {
                continue;
            }
        }
        box.max[3] = 1.0f;
        box.min[3] = 1.0f;
        box.max[0] = monster_pos[0] + 40.0f;
        box.min[0] = monster_pos[0] - 40.0f;
        box.max[2] = monster_pos[2] + 40.0f;
        box.min[2] = monster_pos[2] - 40.0f;
        box.max[1] = monster_pos[1] + 200.0f;
        box.min[1] = monster_pos[1] - 200.0f;
        CTreasureBoxManager *treasure = scene->battle_area.treasure_box;
        int poly_num = map->GetPoly(0, polys, box, 0x80);
        if (treasure != NULL) {
            poly_num += treasure->PickupCollision(monster_pos, &polys[poly_num], box, 0x80 - poly_num);
        }
        if (target != NULL && monster->state == ACTIVE_MONSTER_LIVE && target->murderous_time > 0 &&
            target->target_no == i + MONSTER_ACTIVE_MAX) {
            int chance = fptosi(100.0f * (float)rand() / 2147483648.0f);
            if (monster->mask_flag & 2) {
                chance = 100;
            }
            if (target->murderous == 0 && chance < tbl->escape_rate[0]) {
                monster->req_prog = MONSTER_PROG_ESCAPE_0;
            }
            if (target->murderous == 1 && chance < tbl->escape_rate[1]) {
                monster->req_prog = MONSTER_PROG_ESCAPE_1;
            }
            target->murderous_time = 0;
        }
        if (monster->damage_req == 4) {
            monster->req_prog = MONSTER_PROG_DEAD;
            monster->damage_req = 0;
        }
        RunScript(i);
        MoveUnit(monster, polys, poly_num);
        for (int n = 0; n < 11; n++) {
            ACTION_DAMAGE *damage = &monster->damage[n];
            if (monster->damage[n].use == 0) {
                continue;
            }
            float frame = monster->GetNowFrame(damage->chara);
            if (damage->prim == NULL) {
                if (!(frame < damage->start_frame) && frame < damage->end_frame) {
                    damage->prim = ColPrimMan.GetPrim();
                    if (damage->prim != NULL) {
                        damage->prim->SetDamage(damage->damage, monster->chara_type);
                        damage->prim->SetCoord(damage->frame0, damage->frame1, damage->radius);
                        damage->prim->unk_8c = monster->attack;
                    }
                }
            } else if (frame < damage->start_frame || !(frame <= damage->end_frame)) {
                damage->prim->Delete(-1);
                damage->prim = NULL;
            }
        }
        if (monster->state == ACTIVE_MONSTER_DEAD && monster->dead_alpha > 0) {
            monster->dead_alpha -= 3;
            monster->alpha = (float)monster->dead_alpha / 128.0f;
            monster->damage_time = 0;
            if (monster->attrib & MONSTER_ATTRIB_QUICK_DEAD) {
                monster->alpha = 0.0f;
                monster->dead_alpha = 0;
                monster->damage_time = 0;
            }
            if (monster->dead_alpha <= 0) {
                KillMonsterCount(monster->tbl->id, 1);
                monster->dead_alpha = 0;
                monster->state = ACTIVE_MONSTER_NONE;
                monster->chara_kind = 0;
                if (NowFloorInfoPtr != NULL) {
                    NowFloorInfoPtr->kill_count++;
                }
                if (monster->gate_key > 0) {
                    CPullItem *item = PullItemMan.GetList(0);
                    if (item != NULL) {
                        EffectVector velocity = at_2699;
                        monster->GetEntryObjectPos(0, item_pos);
                        item_pos[1] += 20.0f;
                        item->SetItem(item_pos, velocity.f, 2);
                        item->item_no = monster->gate_key;
                    }
                }
            }
        }
        monster->piyori.Step();
        monster->gift_mark.Step();
        if (monster->piyori_mark > 0) {
            monster->piyori_mark--;
            if (monster->piyori_mark <= 0) {
                monster->piyori_time = 0;
            }
        }
        if (monster->gekirin_time > 0) {
            monster->gekirin_time--;
            if (monster->gekirin_time <= 0) {
                monster->gekirin = monster->gekirin_num;
                monster->life_gage.ResetGekirin(monster->gekirin_num);
                monster->pallet[1].duration = 0;
                if (monster->tbl->boss == 0) {
                    monster->attack = monster->tbl->attack;
                }
            }
        }
        if (monster->camera_dist < 4.0f * monster->body_width) {
            if (!(monster->camera_alpha <= 0.0f)) {
                monster->camera_alpha -= 1.0f / 12.0f;
                if (monster->camera_alpha <= 0.0f) {
                    monster->camera_alpha = 0.0f;
                }
            }
        } else if (monster->camera_alpha < 1.0f) {
            monster->camera_alpha += 1.0f / 12.0f;
            if (!(monster->camera_alpha < 1.0f)) {
                monster->camera_alpha = 1.0f;
            }
        }
        if (monster->view_state == MONSTER_VIEW_FADE_OUT) {
            monster->view_alpha -= 0.05f;
            if (monster->view_alpha <= 0.0f) {
                monster->view_alpha = 0.0f;
                monster->view_state = MONSTER_VIEW_OUT;
            }
        }
        if (monster->view_state == MONSTER_VIEW_FADE_IN) {
            monster->view_alpha += 0.05f;
            if (!(monster->view_alpha < 1.0f)) {
                monster->view_alpha = 1.0f;
                monster->view_state = MONSTER_VIEW_IN;
            }
        }
        float step = monster->GetDefaultStep();
        if (monster->status.attr & MONSTER_STATUS_SLOW) {
            monster->SetStep(0.5f * step);
        } else {
            monster->SetStep(step);
        }
        monster->Step();
    }
    PriorityLevelCheck();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/monster", ThinkHost__11CMonsterManFv);
#endif
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
