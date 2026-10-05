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
#include "gyorace.hpp"
#include "subgame.hpp"
#include "scenesnd.hpp"

struct CHitEffectImage;
extern int EffectTexb;
extern u_char water_cam;
extern CHitEffectImage *battle_effect;
extern "C" void Step__15CHitEffectImageFv(CHitEffectImage *effect);
extern "C" void Draw__15CHitEffectImageFv(CHitEffectImage *effect);
extern "C" void DivSpriteScreen__FR11mgCDrawPrim__2(mgCDrawPrim *prim);
#ifdef NONMATCHING
#include "gyoracesim.hpp"
#include "subgame.hpp"
#include "scenesnd.hpp"
#include "character.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "dng_effect.hpp"
#include "nd_meswin.hpp"
#include "snd_mngr.hpp"
#include "menuaqua.hpp"
#include "userdata.hpp"
#include <cstring>

static unsigned int gyore_snd_id;
float race_cnt;
int race_proc_cnt;
int race_mode;
int time_max;
static int rank_count;
static mgCTexture *EffectTex;
static mgCTexture *EffectTex2;
static mgCTexture *wind_tex;
static int hero_no;
static char water_cam;
static int cam_no;
static float win_alpha;
static int effect_cnt;
static int mes_count;
static int jyunkai_flg;
static int hantei_flg;
static int goal_cnt;
static CHitEffectImage *battle_effect;
static BattleEffectPrim battle_EffectPara[96][32];
int camera_id;
int race_rank[2];
ClsMes *gyo_mes;
static int CharaTexb;
static int WindowTexb;
static int EffectTexb;
static float raster_offset;
static bool raster_initialized;
GYORACE_RESULT fish_game_data[6];
grRACE_INFO RaceInfo;
grRACE_PROGRESS old_prog[6];
static int fish_rank[6];
static int old_fish_rank[6];
static CGameDataUsed *game_data[8];
static float old_ambient[4];
static mgCMemory BuffTextureData;
static mgCMemory BuffWorkData;
mgCCamera camera0(8.0f);
GYORACE_FISH_INF fish_inf[6];
static int old_cam_no = -1;
#endif

// Code (.text)
#ifdef NONMATCHING
int sgInitGyoRace(SubGameInfo *info) {
    if (info == NULL || info->scene == NULL) return 0;
    race_rank[0] = GetGyoRaceClass();
    race_rank[1] = GetGyoRaceNo();
    race_mode = GYORACE_MODE_READY;
    race_proc_cnt = 75;
    race_cnt = 0.0f;
    hero_no = 0;
    goal_cnt = 0;
    rank_count = 0;
    mes_count = 0;
    jyunkai_flg = 0;
    hantei_flg = 0;
    old_cam_no = -1;
    win_alpha = 128.0f;
    CharaTexb = info->texb;
    WindowTexb = CharaTexb + 1;
    EffectTexb = WindowTexb + 1;
    RaceInfo.fish_num = 6;
    RaceInfo.seed = 0;
    CGameDataUsed *hero_fish = GetGyoRaceFish();
    for (int fish = 0; fish < 6; ++fish) {
        CGameDataUsed *entrant = fish == hero_no ? hero_fish : NULL;
        game_data[fish] = entrant;
        fish_inf[fish].lane = fish;
        fish_inf[fish].chara_no = 0x40 + fish;
        fish_inf[fish].fish_no = -1;
        fish_inf[fish].rank = fish + 1;
        fish_inf[fish].lap = 0;
        fish_inf[fish].time = 0.0f;
        RaceInfo.fish[fish].lane = fish;
        if (entrant != NULL) {
            RaceInfo.fish[fish].fish_no = entrant->item_no;
            strncpy(RaceInfo.fish[fish].name, entrant->data.fish.name, sizeof(RaceInfo.fish[fish].name));
        }
    }
    time_max = grGyoRaceSimulate(&RaceInfo);
    camera0.SetPos(270.0f, -40.0f, -10.0f);
    camera0.SetNextPos(270.0f, -40.0f, -10.0f);
    camera0.SetRef(192.0f, 0.0f, 0.0f);
    camera0.SetNextRef(192.0f, 0.0f, 0.0f);
    camera_id = info->scene->AssignCamera(0, &camera0, NULL);
    AutoCam(info);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgInitGyoRace__FP11SubGameInfo);
#endif
#ifdef NONMATCHING
int sgLoopGyoRace(SubGameInfo *info) {
    if (info == NULL || info->scene == NULL) return 0;
    switch (race_mode) {
    case GYORACE_MODE_READY:
        if (--race_proc_cnt <= 0) {
            race_mode = GYORACE_MODE_GATE_OPEN;
            race_proc_cnt = 15;
        }
        break;
    case GYORACE_MODE_GATE_OPEN:
        if (--race_proc_cnt <= 0) {
            race_mode = GYORACE_MODE_RACE;
            race_cnt = 0.0f;
        }
        break;
    case GYORACE_MODE_RACE:
    case GYORACE_MODE_FINISH:
        race_cnt += 0.1f;
        goal_cnt = 0;
        for (int fish = 0; fish < 6; ++fish) {
            grRACE_PROGRESS progress;
            if (!grGetFishProgress(&RaceInfo, fish, race_cnt, &progress)) continue;
            GYORACE_FISH_INF &state = fish_inf[fish];
            unsigned int lap = (unsigned int)(progress.pos / 8.0f);
            if (lap > state.lap && lap < 3) {
                state.lap = lap;
                state.lap_start = race_cnt;
            }
            if (progress.state == GR_RACE_STATE_GOAL) {
                ++goal_cnt;
                state.rank = RaceInfo.rank[fish];
                state.time = RaceInfo.goal_time[fish] * 20.0f;
            }
            old_prog[fish] = progress;
        }
        AutoCam(info);
        Jikkyou(info);
        if (race_mode == GYORACE_MODE_RACE && goal_cnt == 6) {
            race_mode = GYORACE_MODE_FINISH;
            race_proc_cnt = 120;
        }
        if (race_mode == GYORACE_MODE_FINISH && --race_proc_cnt <= 0) race_mode = GYORACE_MODE_END;
        break;
    case GYORACE_MODE_GOAL_VIEW:
        if (--race_proc_cnt <= 0) race_mode = GYORACE_MODE_FINISH;
        break;
    case GYORACE_MODE_END:
        for (int fish = 0; fish < 6; ++fish) {
            int place = RaceInfo.rank[fish] - 1;
            if (place < 0 || place >= 6) continue;
            GYORACE_RESULT &result = fish_game_data[place];
            memset(result.name, ' ', sizeof(result.name));
            memcpy(result.name, RaceInfo.fish[fish].name, sizeof(result.name));
            result.time = RaceInfo.goal_time[fish] * 20.0f;
            result.fish_no = fish_inf[fish].fish_no;
            result.race_class = race_rank[0];
        }
        return 1;
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgLoopGyoRace__FP11SubGameInfo);
#endif
#ifdef NONMATCHING
void AutoCam(SubGameInfo *info) {
    CCharacter2 *hero = info->scene->GetCharacter(fish_inf[hero_no].chara_no);
    if (hero == NULL) return;
    float hero_pos[4];
    hero->GetPosition(hero_pos);
    float nearest = 9999.0f;
    cam_no = 0;
    for (int camera = 0; camera < 5; ++camera) {
        float distance = mgDistVector(hero_pos, cam_pos[camera]);
        if (distance < nearest) {
            nearest = distance;
            cam_no = camera;
        }
    }
    if (old_cam_no == cam_no) {
        camera0.SetSpeed(9999.0f, 20.0f);
        camera0.SetNextRef(hero_pos);
    } else {
        sndSetSeVol(gyore_snd_id, 2, cam_pos[cam_no][1] < 0.0f ? sndGetSeDefVol(gyore_snd_id, 2) : 0, 0);
        camera0.SetPos(cam_pos[cam_no]);
        camera0.SetNextPos(cam_pos[cam_no]);
        camera0.SetRef(hero_pos);
        camera0.SetNextRef(hero_pos);
        camera0.SetSpeed(0.0f, 0.0f);
        win_alpha = 128.0f;
    }
    water_cam = cam_pos[cam_no][1] < 0.0f;
    old_cam_no = cam_no;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", AutoCam__FP11SubGameInfo);
#endif
int sgMapDrawGyoRace(SubGameInfo *info) {
    return 0;
}
int sgCharaDrawGyoRace(SubGameInfo *info) {
    CScene *scene;
    int i;
    int offset;
    scene = info->scene;
    i = 0;
    offset = 0;
    do {
        scene->DrawChara(*(int *)((u_char *)fish_inf + offset + 4), 1);
        i++;
        offset += 0x2C;
    } while (i < 6);
    mgTexManager.ReloadTexture(EffectTexb, (sceVif1Packet *)NULL);
    int j = 0;
    offset = 0;
    CHitEffectImage *effect;
    do {
        effect = (CHitEffectImage *)((u_char *)battle_effect + offset);
        if (effect != 0) {
            Step__15CHitEffectImageFv(effect);
            Draw__15CHitEffectImageFv(effect);
        }
        j++;
        offset += 0x60;
    } while (j < 0x60);
    return 0;
}
#ifdef NONMATCHING
static void DivSpriteScreen(mgCDrawPrim &prim) {
    if (!raster_initialized) {
        raster_offset = 0.0f;
        raster_initialized = true;
    }
    prim.BeginPrim2(MG_PRIM_TRIANGLE_STRIP, 0x43, 0, 2);
    int strip_height = mgScreenHeight / 48;
    if (strip_height < 1) strip_height = 1;
    for (int y = 0; y < mgScreenHeight; y += strip_height) {
        int upper[4] = { 0, y * 16, 0, 0 };
        int lower[4] = { mgScreenWidth * 16, (y + strip_height) * 16, 0, 0 };
        prim.Data(upper);
        prim.Data(lower);
    }
    raster_offset += 0.0004363323f;
    if (raster_offset > 6.2831855f) raster_offset = -6.2831855f;
    prim.EndPrim2();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", DivSpriteScreen__FR11mgCDrawPrim__2);
#endif
int sgEffectDrawGyoRace(SubGameInfo *info) {
    mgCDrawPrim prim;
    if (water_cam == 0) {
        return 0;
    }
    prim.Initialize(0, 0);
    mgCTexture frame;
    mgGetFrameBuffer(&frame);
    frame.swizzled = 0;
    prim.DepthTestEnable(0);
    prim.AlphaTestEnable(0);
    prim.AlphaBlendEnable(0);
    prim.ZMask(-1);
    prim.TextureMapEnable(1);
    prim.Begin2();
    prim.BeginPrim2(6);
    prim.Texture(&frame);
    prim.Direct(0x3B, 0x8080 | ((unsigned long)0x80 << 32));
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.EndPrim2();
    DivSpriteScreen__FR11mgCDrawPrim__2(&prim);
    prim.End2();
    return 0;
}
#ifdef NONMATCHING
int sgSysDrawGyoRace(SubGameInfo *info) {
    if (gyo_mes != NULL) {
        gyo_mes->Step();
        gyo_mes->DrawMesWin();
    }
    for (int fish = 0; fish < 6; ++fish) {
        grRACE_PROGRESS progress;
        if (!grGetFishProgress(&RaceInfo, fish, race_cnt, &progress)) continue;
        fish_inf[fish].lap = (unsigned int)(progress.pos / 8.0f);
        fish_inf[fish].rank = RaceInfo.rank[fish];
        if (fish_inf[fish].lap > 1) {
            float elapsed = race_cnt * 20.0f;
            fish_inf[fish].lap_time[1] = elapsed - fish_inf[fish].lap_time[0];
        }
    }
    if (win_alpha > 0.0f) win_alpha -= 0.5f;
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgSysDrawGyoRace__FP11SubGameInfo);
#endif
#ifdef NONMATCHING
int Jikkyou(SubGameInfo *info) {
    if (race_cnt <= 0.0f) return -1;
    if (mes_count > 0) {
        --mes_count;
        return -1;
    }
    if (gyo_mes == NULL) return 0;
    int leader = 0;
    float leading_position = -1.0f;
    for (int fish = 0; fish < 6; ++fish) {
        grRACE_PROGRESS progress;
        if (grGetFishProgress(&RaceInfo, fish, race_cnt, &progress) && progress.pos > leading_position) {
            leader = fish;
            leading_position = progress.pos;
        }
    }
    int message = 5;
    if (leading_position >= 16.0f) {
        message = 31;
        mes_count = 6000;
    } else if (leading_position >= 8.0f && !jyunkai_flg) {
        message = 30;
        jyunkai_flg = 1;
        mes_count = 60;
    } else if (leading_position >= 2.0f) {
        message = RaceInfo.fish[leader].bonus_type + 9;
        mes_count = 60;
    } else {
        mes_count = 60;
    }
    strcpy(gyo_mes->name[0], RaceInfo.fish[leader].name);
    gyo_mes->MakeMesWin(message);
    sndSePlay(gyore_snd_id, 0x16, 0);
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", Jikkyou__FP11SubGameInfo);
#endif

// Static initialiser (.init)
#ifndef NONMATCHING
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", __sinit_gyorace_cpp);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", fish_name__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", cam_pos__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1027__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1028__9__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1481__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1524__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1547__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1548__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1766__3__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_903__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_904__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_905__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_906__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_907__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_908__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_909__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_910__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_911__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_912__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_913__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_914__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_915__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_916__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_917__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_918__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_919__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_920__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1373__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1374__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1375__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1376__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1377__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1378__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1379__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1380__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1381__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1382__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1383__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1384__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1696__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1697__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1698__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1699__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1700__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1701__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1702__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1703__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", D_0037B07C__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", old_cam_no__DATA);

// Small uninitialised data (.sbss)
#ifndef NONMATCHING
INCLUDE_BSS(gyore_snd_id, 0x4);
INCLUDE_BSS(race_cnt, 0x4);
INCLUDE_BSS(race_proc_cnt, 0x4);
INCLUDE_BSS(race_mode, 0x4);
INCLUDE_BSS(time_max, 0x4);
INCLUDE_BSS(rank_count, 0x4);
INCLUDE_BSS(EffectTex, 0x4);
INCLUDE_BSS(EffectTex2, 0x4);
INCLUDE_BSS(wind_tex, 0x4);
INCLUDE_BSS(hero_no, 0x4);
INCLUDE_BSS(water_cam, 0x4);
INCLUDE_BSS(cam_no, 0x4);
INCLUDE_BSS(win_alpha, 0x4);
INCLUDE_BSS(effect_cnt, 0x4);
INCLUDE_BSS(mes_count, 0x4);
INCLUDE_BSS(jyunkai_flg, 0x4);
INCLUDE_BSS(hantei_flg, 0x4);
INCLUDE_BSS(goal_cnt, 0x4);
INCLUDE_BSS(battle_effect, 0x4);
INCLUDE_BSS(battle_EffectPara, 0x4);
INCLUDE_BSS(camera_id, 0x8);
INCLUDE_BSS(race_rank, 0x8);
INCLUDE_BSS(gyo_mes, 0x4);
INCLUDE_BSS(CharaTexb, 0x4);
INCLUDE_BSS(WindowTexb, 0x4);
INCLUDE_BSS(EffectTexb, 0x4);
INCLUDE_BSS(ras_off_1762, 0x4);
INCLUDE_BSS(init_1763, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(fish_game_data, 0xE0);
INCLUDE_BSS(RaceInfo, 0x1E0);
INCLUDE_BSS(old_prog, 0x90);
INCLUDE_BSS(fish_rank, 0x1C);
INCLUDE_BSS(D_01F5971C, 0x4);
INCLUDE_BSS(old_fish_rank, 0x20);
INCLUDE_BSS(game_data, 0x20);
INCLUDE_BSS(old_ambient, 0x10);
INCLUDE_BSS(BuffTextureData, 0x30);
static INCLUDE_BSS(BuffWorkData, 0x30);
INCLUDE_BSS(camera0, 0x70);
INCLUDE_BSS(fish_inf, 0x110);
INCLUDE_BSS(at_1765__2, 0x10);
INCLUDE_BSS(at_1775, 0x10);
INCLUDE_BSS(at_1776, 0x10);
INCLUDE_BSS(lap_inf_1798, 0x30);
INCLUDE_BSS(lap_inf2_1799, 0x50);
#endif
