#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "dng_effect.hpp"
#include "fishing.hpp"
#include "gyorace.hpp"
#include "gyoracesim.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "menuaqua.hpp"
#include "menudraw.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "subgame.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

/**
 *
 * Race vector viewed as floats, integers or a quadword.
 *
 */
union RaceVector {
    float     f[4]; /**< Floating point components. */
    int       v[4]; /**< Integer components. */
    u_long128 q;    /**< The same components as a quadword. */
};

extern RaceVector at_1775;
extern RaceVector at_1776;

/**
 *
 * Angular phase of the underwater raster effect.
 *
 */
static float ras_off_1762;

/**
 *
 * Whether the underwater raster phase has been initialized.
 *
 */
static signed char init_1763;

/**
 *
 * Stack memory holding fish-race commentary and texture resources.
 *
 */
static mgCMemory BuffTextureData;

/**
 *
 * Stack memory holding fish-race work data.
 *
 */
static mgCMemory BuffWorkData;

/**
 *
 * Texture atlas used by the fish-race window and time display.
 *
 */
static mgCTexture *wind_tex;

/**
 *
 * Texture block containing the fish-race window atlas.
 *
 */
static int WindowTexb;

/**
 *
 * Character model files selected for each racing fish species.
 *
 */
char *fish_name[18] = {
    "f1a.chr",
    "f2a.chr",
    "f3a.chr",
    "f4a.chr",
    "f5a.chr",
    "f6a.chr",
    "f7a.chr",
    "f8a.chr",
    "f10a.chr",
    "f11a.chr",
    "f12a.chr",
    "f13a.chr",
    "f14a.chr",
    "f15a.chr",
    "f16a.chr",
    "f17a.chr",
    "f18a.chr",
    "f19a.chr",
};

/**
 *
 * Fixed race camera positions around the fish course.
 *
 */
sceVu0FVECTOR cam_pos[5] = {
    {275.0f, 58.0f, -167.0f, 1.0f},
    {255.0f, -18.0f, 267.0f, 1.0f},
    {66.0f, 100.0f, -666.0f, 1.0f},
    {-180.0f, -18.0f, 100.0f, 1.0f},
    {-66.0f, 80.0f, 666.0f, 1.0f},
};

/**
 *
 * Previously selected fixed race camera, or -1 before selection.
 *
 */
static int old_cam_no = -1;

/**
 *
 * Sound identifier used for fish-race effects.
 *
 */
static unsigned int gyore_snd_id;

/**
 *
 * Current replay time of the simulated fish race.
 *
 */
float race_cnt;

/**
 *
 * Frame counter for the current race stage.
 *
 */
int race_proc_cnt;

/**
 *
 * Current fish-race stage.
 *
 */
int race_mode;

/**
 *
 * Number of steps produced by the race simulation.
 *
 */
int time_max;

/**
 *
 * Rank being announced by the race commentary.
 *
 */
static int rank_count;

/**
 *
 * Primary texture of the fish-race splash effects.
 *
 */
static mgCTexture *EffectTex;

/**
 *
 * Secondary texture of the fish-race splash effects.
 *
 */
static mgCTexture *EffectTex2;

/**
 *
 * Index of the player's entrant in the fish race.
 *
 */
static int hero_no;

/**
 *
 * Whether the race camera is underwater.
 *
 */
static u_char water_cam;

/**
 *
 * Fixed race camera point currently selected.
 *
 */
static int cam_no;

/**
 *
 * Opacity of the race display window.
 *
 */
static float win_alpha;

/**
 *
 * Next slot in the race splash-effect ring.
 *
 */
static int effect_cnt;

/**
 *
 * Frames remaining before race commentary can advance.
 *
 */
static int mes_count;

/**
 *
 * Whether battle commentary has been scanned during the current commentary cycle.
 *
 */
static int jyunkai_flg;

/**
 *
 * Race initialization flag reset before playback.
 *
 */
static int hantei_flg;

/**
 *
 * Race initialization counter reset before playback.
 *
 */
static int goal_cnt;

/**
 *
 * Race splash effects used when fish battle.
 *
 */
static CHitEffectImage *battle_effect;

/**
 *
 * Primitive work blocks used by each race splash effect.
 *
 */
static BattleEffectPrim (*battle_EffectPara)[32];

/**
 *
 * Scene camera identifier assigned to the fish race.
 *
 */
int camera_id;

/**
 *
 * Race class and race number selected for this run.
 *
 */
int race_rank[2];

/**
 *
 * Message window used for fish-race commentary.
 *
 */
ClsMes *gyo_mes;

/**
 *
 * First texture block allocated for the racing fish.
 *
 */
static int CharaTexb;

/**
 *
 * Texture block allocated for the race splash effects.
 *
 */
static int EffectTexb;

/**
 *
 * Ordered results retained from the most recent fish race.
 *
 */
GYORACE_RESULT fish_game_data[6];

/**
 *
 * Entrants and recorded progress of the simulated race.
 *
 */
grRACE_INFO RaceInfo;

/**
 *
 * Previous displayed progress of every racing fish.
 *
 */
grRACE_PROGRESS old_prog[6];

/**
 *
 * Entrant indices ordered by current place.
 *
 */
static int fish_rank[6];

/**
 *
 * Entrant order from the previous race update.
 *
 */
static int old_fish_rank[6];

/**
 *
 * Game inventory records selected for the race entrants.
 *
 */
static CGameDataUsed *game_data[6];

/**
 *
 * Scene ambient colour saved before entering the fish race.
 *
 */
static float old_ambient[4];

/**
 *
 * Display, lap and result state of every racing fish.
 *
 */
GYORACE_FISH_INF fish_inf[6];

// Code (.text)
int sgInitGyoRace(SubGameInfo *info) {
    mgCTextureManager *textures;
    CScene *scene = info->scene;
    scene->AssignStack(5);
    mgCMemory *memory = scene->GetStack(5);
    BuffTextureData.stSetBuffer(memory->stAlloc64(0x88B8), 0x88B8);
    BuffTextureData.stReset();
    BuffWorkData.stSetBuffer(memory->stAlloc64(0x7530), 0x7530);
    BuffWorkData.stReset();
    u_long128 *buffer = scene->read_buff;
    int size;
    sndInitPort(SND_PORT_ENEMY);
    LoadFile2("snd2/mon/EN_902.snd", buffer, &size, 0);
    gyore_snd_id = sndLoadSound(SND_PORT_ENEMY, (unsigned int *)buffer, memory);
    ChangeDir("/sg/gyo/");
    CGyoraceFishData fish_data;
    fish_data.LoadData(memory, buffer);
    u_long128 *texture_buffer = BuffTextureData.stack;
    char path[0x100];
    sprintf(path, "gyore%d.mes", LanguageCode);
    LoadFile2(path, texture_buffer, &size, 0);
    gyo_mes = new(memory->Alloc((sizeof(ClsMes) + 15) / 16 + 2)) ClsMes;
    gyo_mes->SetBuff((short *)texture_buffer);
    gyo_mes->SetBuff_system(GetSystemMesBuffer());
    gyo_mes->Init();
    gyo_mes->Preset(MES_PRESET_FUKIDASHI);
    gyo_mes->SetWindowMode(MES_WIN_BOTTOM);
    gyo_mes->draw_speed = 3.8f;
    gyo_mes->draw_speed_def = 3.8f;
    gyo_mes->push_button = 0;
    gyo_mes->MakeMesWin(0);
    texture_buffer += (size / 16) + 1;
    race_mode = GYORACE_MODE_READY;
    hero_no = 0;
    race_cnt = 0.0f;
    race_proc_cnt = 75;
    old_cam_no = -1;
    mgGetAmbient(old_ambient);
    win_alpha = 128.0f;
    jyunkai_flg = 0;
    hantei_flg = 0;
    goal_cnt = 0;
    mes_count = 0;
    rank_count = 0;
    battle_EffectPara = new(memory->Alloc((sizeof(BattleEffectPrim) * 96 * 32 + 15) / 16 + 2)) BattleEffectPrim[96][32];
    battle_effect = new(memory->Alloc((sizeof(CHitEffectImage) * 96 + 15) / 16 + 2)) CHitEffectImage[96];
    for (int effect = 0; effect < 96; effect++) {
        CHitEffectImage *image = &battle_effect[effect];
        image->spark = battle_EffectPara[effect];
        image->spark_max = 32;
        image->live_num = 0;
        image->spark_num = 0;
        image->kind = HIT_EFFECT_BOARD;
    }
    race_rank[0] = GetGyoRaceClass();
    race_rank[1] = GetGyoRaceNo();
    int chosen[6];
    int chosen_num = 0;
    int fish = 0;
    do {
        fish_inf[fish].fish_no = -1;
        if (OmakeFlag != 0) {
            CGameDataUsed *race_fish = GetOmakeGyoracer2(fish);
            CGameDataUsed **item = &game_data[fish];
            *item = race_fish;
            if (*item == NULL) {
                chosen[chosen_num] = race_rank[1] * 18 + (int)(17.0f * mgRnd());
                do {
                    int selection;
                    for (selection = 0; selection < chosen_num; selection++) {
                        if (chosen[selection] == chosen[chosen_num]) break;
                    }
                    if (chosen_num == selection) break;
                    chosen[chosen_num] = race_rank[1] * 18 + (int)(17.0f * mgRnd());
                } while (1);
                *item = fish_data.GetRaceFish(race_rank[0], chosen[chosen_num]);
                chosen_num++;
            }
        } else if (fish == 0) {
            game_data[fish] = GetGyoRaceFish();
        } else {
            int selection;
            chosen[chosen_num] = race_rank[1] * 18 + (int)(17.0f * mgRnd());
            do {
                for (selection = 0; selection < chosen_num; selection++) {
                    if (chosen[selection] == chosen[chosen_num]) break;
                }
                if (chosen_num == selection) break;
                chosen[chosen_num] = race_rank[1] * 18 + (int)(17.0f * mgRnd());
            } while (1);
            selection = chosen[chosen_num];
            CGameDataUsed *race_fish = fish_data.GetRaceFish(race_rank[0], selection);
            chosen_num++;
            game_data[fish] = race_fish;
            fish_inf[fish].fish_no = selection;
        }
        fish++;
    } while (fish < 6);
    if (race_rank[1] > 0) {
        if (OmakeFlag == 0) {
            int slot = 1;
            for (int place = 0; place < race_rank[1]; place++) {
                GYORACE_RESULT *result = &fish_game_data[place];
                if (result->fish_no != -1) {
                    game_data[slot] = fish_data.GetRaceFish(result->race_class, result->fish_no);
                    slot++;
                }
            }
        }
    } else {
        for (int place = 0; place < 6; place++) {
            fish_game_data[place].fish_no = -1;
            fish_game_data[place].race_class = 0;
        }
    }
    int lane = 0;
    if (OmakeFlag == 0) {
        lane = (int)(6.0f * mgRnd());
        if (lane > 5) lane = 5;
    }
    memset(&RaceInfo, 0, sizeof(RaceInfo));
    RaceInfo.seed = 0;
    printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>GYO RACE RndSeed=%d \n", RaceInfo.seed);
    RaceInfo.fish_num = 6;
    RaceInfo.step_max = 1000;
    RaceInfo.after_goal_step = 20;
    int racer = 0;
    do {
        RaceInfo.progress[racer] = new(memory->Alloc((sizeof(grRACE_PROGRESS) * 1000 + 15) / 16 + 2)) grRACE_PROGRESS[1000];
        if (OmakeFlag == 0 && racer == 0) {
            RaceInfo.fish[racer].tactics = GetGyoRaceAquariumNo();
        } else if (OmakeFlag != 0) {
            RaceInfo.fish[racer].tactics = GetOmakeGyoracerTactics(racer);
        } else {
            RaceInfo.fish[racer].tactics = (int)(6.0f * mgRnd());
            if (RaceInfo.fish[racer].tactics > 5) RaceInfo.fish[racer].tactics = 5;
        }
        int fatigue;
        CGameDataUsed **item = &game_data[racer];
        char *name = RaceInfo.fish[racer].name;
        strcpy(name, (*item)->data.fish.name);
        CGameDataUsed *fish_item = *item;
        RaceInfo.fish[racer].bonus_type = fish_item->data.fish.kind;
        RaceInfo.fish[racer].power = fish_item->data.fish.param[4];
        BREEDFISH_USED *data = &fish_item->data.fish;
        if (OmakeFlag == 0 && racer == 0) {
            if (race_rank[1] == 0) data->fatigue++;
            fish_item = *item;
            data = &fish_item->data.fish;
            fatigue = fish_item->data.fish.fatigue;
            RaceInfo.fish[racer].stamina = (int)((float)data->param[3] - (0.1f * (float)(fatigue - 1) * (float)fish_item->data.fish.param[3]));
            printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>MY_FISH TUKARE=%d \n", fatigue);
        } else {
            RaceInfo.fish[racer].stamina = data->param[3];
        }
        fish_item = *item;
        RaceInfo.fish[racer].speed[0] = fish_item->data.fish.param[0];
        RaceInfo.fish[racer].speed[1] = fish_item->data.fish.param[1];
        RaceInfo.fish[racer].speed[2] = fish_item->data.fish.param[2];
        RaceInfo.fish[racer].affinity = fish_item->data.fish.color;
        RaceInfo.fish[racer].fish_no = fish_item->item_no;
        RaceInfo.fish[racer].lane = lane;
        fish_inf[racer].lane = lane;
        lane++;
        if (lane >= 6) lane = 0;
        printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>GYO RACE info GYO_NAME=%s  Operation=%d \n", name, RaceInfo.fish[racer].tactics);
        racer++;
    } while (racer < 6);
    time_max = grGyoRaceSimulate(&RaceInfo);
    for (int racer_no = 0; racer_no < 6; racer_no++) {
        scene->GetCharacter(fish_inf[racer_no].chara_no);
        grGetFishProgress(&RaceInfo, racer_no, race_cnt, &old_prog[racer_no]);
    }
    CharaTexb = info->texb;
    CGameDataUsed **item;
    int fish_index = 0;
    do {
        grRACE_PROGRESS *progress = &old_prog[fish_index];
        grGetFishProgress(&RaceInfo, fish_index, 0.0f, progress);
        textures = &mgTexManager;
        textures->DeleteBlock(CharaTexb);
        item = &game_data[fish_index];
        int kind = (*item)->item_no - FISH_ITEM_BOUBOU;
        if (kind < 0) kind = 17;
        if (LoadFile2(fish_name[kind], buffer, NULL, 0) == 0) return 0;
        GYORACE_FISH_INF *state = &fish_inf[fish_index];
        state->chara_no = fish_index + 0x40;
        state->lap = 0;
        state->unk_14 = 0;
        state->lap_start = 0.0f;
        state->time = 0.0f;
        state->rank = 1;
        int *character_no = &state->chara_no;
        scene->LoadChara(state->chara_no, (unsigned int *)buffer, "info.cfg", memory, memory, memory, CharaTexb, 0);
        scene->SetActive(SCENE_DATA_CHARA, *character_no);
        scene->SetCharaTexb(*character_no, CharaTexb);
        CCharacter2 *character = scene->GetCharacter(*character_no);
        sceVu0FVECTOR position = {0.0f, -15.0f, 0.0f, 1.0f};
        position[0] = 190.0f + 15.0f * (float)progress->lane;
        position[2] = character->body_height / 4.0f;
        sceVu0FVECTOR rotation = {0.0f, 3.1415927f, 0.0f, 1.0f};
        BREEDFISH_USED *data = &(*item)->data.fish;
        CDataBreedFish *breed = GetBreedFishInfoData((*item)->item_no);
        float scale = (float)data->size / breed->size;
        if (!(scale <= 2.0f)) scale = 2.0f;
        character->SetScale(scale, scale, scale);
        character->SetRotation(rotation);
        character->SetPosition(position);
        character->SetMotion("\x92\xCA\x8F\xED", 0);
        character->SetStep(0.3f);
        FishIMGReplace(buffer, character, (*item)->item_no, &(*item)->data.fish);
        fish_index++;
        CharaTexb++;
    } while (fish_index < 6);
    if (texture_buffer != NULL) {
        WindowTexb = CharaTexb;
        char image_path[0x20];
        if (LanguageCode > LANG_JAPANESE) sprintf(image_path, "grttex_new6_%d.img", LanguageCode);
        else sprintf(image_path, "grttex_new6.img", LanguageCode);
        textures->DeleteBlock(WindowTexb);
        LoadFile(image_path, texture_buffer, &size);
        textures->EnterIMGFile((unsigned char *)texture_buffer, WindowTexb, &BuffTextureData, NULL);
        EffectTex2 = textures->GetTexture("grt_moji", -1);
        EffectTexb = WindowTexb + 1;
        textures->DeleteBlock(EffectTexb);
        textures->EnterIMGFile((unsigned char *)texture_buffer, EffectTexb, &BuffTextureData, NULL);
        TEX_SystemEffect1 = EffectTex = textures->GetTexture("grt1", -1);
        ChangeDir(NULL);
    }
    camera_id = scene->AssignCamera(-1, &camera0, NULL);
    int id = camera_id;
    scene->before_camera = scene->active_camera;
    scene->active_camera = id;
    camera0.SetPos(225.0f, 38.0f, 168.0f);
    camera0.SetNextPos(225.0f, 38.0f, 168.0f);
    camera0.SetSpeed(0.0f, 0.0f);
    camera0.SetRef(222.0f, 0.0f, 0.0f);
    camera0.SetNextRef(222.0f, 0.0f, 0.0f);
    scene->ResetActive(SCENE_DATA_CHARA, 0);
    sndSeAllStop(2);
    scene->fade.FadeIn(30);
    return 1;
}

#ifdef NONMATCHING
int sgLoopGyoRace(SubGameInfo *info) {
    extern char                at_1380__2__DATA[];
    extern char                at_1696__2__DATA[];
    extern char                at_1697__3__DATA[];
    extern char                at_1698__3__DATA[];
    extern char                at_1699__3__DATA[];
    extern char                at_1700__2__DATA[];
    extern char                at_1701__DATA[];
    extern char                at_1702__DATA[];
    extern RaceVector          at_1481__4;
    extern RaceVector          at_1524__2;
    extern RaceVector          at_1547;
    extern RaceVector          at_1548;
    CScene                    *scene = info->scene;
    switch ((unsigned int) race_mode) {
        case 0:
            scene->active_camera = camera_id;
            camera0.SetPos(225.0f, 38.0f, 168.0f);
            camera0.SetNextPos(225.0f, 38.0f, 168.0f);
            camera0.SetRef(222.0f, 0.0f, 0.0f);
            camera0.SetNextRef(222.0f, 0.0f, 0.0f);
            camera0.SetSpeed(0.0f, 0.0f);
            for (int fish = 0; fish < 6; fish++) {
                CCharacter2 *character = scene->GetCharacter(fish_inf[fish].chara_no);
                character->SetMotion(at_1380__2__DATA, 0);
                character->SetStep(0.3f);
            }
            race_proc_cnt--;
            if (race_proc_cnt <= 0) {
                race_proc_cnt = 15;
                race_mode = 1;
                sndSePlay(gyore_snd_id, 0, 0);
                sndSePlayV(gyore_snd_id, 3, 0, 3);
                sndSePlayV(gyore_snd_id, 4, 0, 4);
                sndSePlayV(gyore_snd_id, 5, 0, 5);
                sndSePlayV(gyore_snd_id, 6, 0, 6);
                sndSePlayV(gyore_snd_id, 7, 0, 7);
                sndSePlayV(gyore_snd_id, 8, 0, 8);
                sndSePlayV(gyore_snd_id, 9, 0, 9);
                sndSePlayV(gyore_snd_id, 10, 0, 10);
                sndSePlayV(gyore_snd_id, 11, 0, 11);
                sndSePlayV(gyore_snd_id, 12, 0, 12);
                sndSePlayV(gyore_snd_id, 13, 0, 13);
                sndSePlayV(gyore_snd_id, 14, 0, 14);
                sndSePlayV(gyore_snd_id, 2, 0, 0);
            }
            break;
        case 1: {
            scene->active_camera = camera_id;
            camera0.SetPos(225.0f, 38.0f, 168.0f);
            camera0.SetNextPos(225.0f, 38.0f, 168.0f);
            camera0.SetRef(222.0f, 0.0f, 0.0f);
            camera0.SetNextRef(222.0f, 0.0f, 0.0f);
            camera0.SetSpeed(0.0f, 0.0f);
            mgCFrame *gate = scene->GetMap(scene->active_map)->GetParts(at_1696__2__DATA)->SearchPiece(at_1697__3__DATA)->frame;
            mgCFrame *left = gate->SearchFrame(at_1698__3__DATA);
            left->SetRotType(2);
            float rotation[4];
            left->GetRotation(rotation);
            rotation[1] += 0.20943952f;
            if (!(rotation[1] <= 1.5707964f)) {
                rotation[1] = 1.5707964f;
            }
            left->SetRotation(rotation[0], rotation[1], rotation[2]);
            mgCFrame *right = gate->SearchFrame(at_1699__3__DATA);
            right->SetRotType(2);
            right->GetRotation(rotation);
            rotation[1] -= 0.20943952f;
            if (rotation[1] < -1.5707964f) {
                rotation[1] = -1.5707964f;
            }
            right->SetRotation(rotation[0], rotation[1], rotation[2]);
            race_proc_cnt--;
            if (race_proc_cnt <= 0) {
                race_proc_cnt = 0;
                race_mode = 2;
            }
            break;
        }
        case 2:
        case 3: {
            int fish;
            for (int i = 0; i < 6; i++) {
                scene->GetCharacter(fish_inf[i].chara_no);
                grGetFishProgress(&RaceInfo, i, race_cnt, &old_prog[i]);
            }
            race_cnt += 0.1f;
            for (fish = 0; fish < 6; fish++) {
                grRACE_PROGRESS progress;
                grGetFishProgress(&RaceInfo, fish, race_cnt, &progress);
                int rank = 1;
                if (progress.state != GR_RACE_STATE_GOAL) {
                    for (int other = 0; other < 6; other++) {
                        if (other != fish) {
                            grRACE_PROGRESS other_progress;
                            grGetFishProgress(&RaceInfo, other, race_cnt, &other_progress);
                            if (other_progress.state != GR_RACE_STATE_GOAL) {
                                if (progress.pos < other_progress.pos) {
                                    rank++;
                                }
                            } else {
                                rank++;
                            }
                        }
                    }
                    fish_inf[fish].rank = rank;
                    fish_rank[rank - 1] = fish;
                }
            }
            int unfinished = 6;
            if (OmakeFlag != 0) {
                hero_no = fish_rank[0];
            }
            for (fish = 0; fish < 6; fish++) {
                GYORACE_FISH_INF *state = &fish_inf[fish];
                CCharacter2      *character = scene->GetCharacter(fish_inf[fish].chara_no);
                grRACE_PROGRESS   progress;
                grGetFishProgress(&RaceInfo, fish, race_cnt, &progress);
                if (progress.state == GR_RACE_STATE_GOAL) {
                    unfinished--;
                }
                if (!(progress.pos < 8.0f)) {
                    unsigned int lap = (unsigned int) (progress.pos / 8.0f);
                    unsigned int *lap_no = &state->lap;
                    if (*lap_no < lap) {
                        *lap_no = lap;
                        if ((int) *lap_no > 1) {
                            *lap_no = 1;
                        } else {
                            state->unk_14 = 1;
                            GetSaveData();
                            state->lap_start = race_cnt;
                        }
                    }
                }
                GetSaveData();
                int hero = hero_no;
                if (fish == hero) {
                    float *total;
                    if (progress.state != GR_RACE_STATE_GOAL) {
                        total = &state->time;
                        *total = 20.0f * race_cnt;
                        state->lap_time[fish_inf[hero].lap] = *total - 20.0f * state->lap_start;
                    } else if (progress.state == GR_RACE_STATE_GOAL) {
                        state->time = 20.0f * RaceInfo.goal_time[fish];
                        total = &state->time;
                        float time = state->lap_time[0];
                        int count = time / 3600.0f;
                        float minutes = 3600.0f * count;
                        time -= minutes;
                        count = time / 60.0f;
                        float seconds = 60.0f * count;
                        count = (100.0f * (time - seconds)) / 60.0f;
                        state->lap_time[1] = *total - ((60.0f * count) / 100.0f + (minutes + seconds));
                    }
                }
                float distance = progress.pos;
                if (!(distance < 8.0f)) {
                    distance -= 8.0f * (float) ((unsigned int) distance >> 3);
                }
                float position[4];
                float matrix[4][4];
                position[1] = 0.0f;
                if (distance >= 0.0 && distance < 1.0) {
                    position[0] = 190.0f + 15.0f * progress.lane_pos;
                    position[2] = -345.0f * distance;
                }
                if (distance >= 3.0 && distance < 4.0) {
                    position[0] = -190.0f - 15.0f * progress.lane_pos;
                    position[2] = -345.0f * (1.0f - (distance - 3.0f));
                }
                if (distance >= 4.0 && distance < 5.0) {
                    position[0] = -190.0f - 15.0f * progress.lane_pos;
                    position[2] = 345.0f * (distance - 4.0f);
                }
                if (distance >= 7.0 && distance < 8.0) {
                    position[0] = 190.0f + 15.0f * progress.lane_pos;
                    position[2] = 345.0f * (1.0f - (distance - 7.0f));
                }
                if (!(distance < 1.0f) && distance < 3.0f) {
                    position[0] = 190.0f + 15.0f * progress.lane_pos;
                    position[2] = 0.0f;
                    sceVu0UnitMatrix(matrix);
                    sceVu0RotMatrixY(matrix, matrix, 1.5707964f * (distance - 1.0f));
                    sceVu0ApplyMatrix(position, matrix, position);
                    position[2] -= 345.0f;
                }
                if (!(distance < 5.0f) && distance < 7.0f) {
                    position[0] = -190.0f - 15.0f * progress.lane_pos;
                    position[2] = 0.0f;
                    sceVu0UnitMatrix(matrix);
                    sceVu0RotMatrixY(matrix, matrix, 1.5707964f * (distance - 5.0f));
                    sceVu0ApplyMatrix(position, matrix, position);
                    position[2] += 345.0f;
                }
                position[1] = -15.0f;
                float delta[4];
                float forward[4];
                float rotation[4];
                float previous[4];
                float hit_dir[4];
                character->GetRotation(rotation);
                character->GetPosition(previous);
                RaceVector       direction = at_1481__4;
                CHitEffectImage *image = &battle_effect[effect_cnt];
                sceVu0SubVector(hit_dir, previous, position);
                sceVu0Normalize(hit_dir, hit_dir);
                direction.f[0] = hit_dir[0];
                direction.f[2] = hit_dir[2];
                if (progress.state == GR_RACE_STATE_BATTLE) {
                    image->SethitEffect(position, direction.f, 150.0f, 30.0f, 0.4f, -0.05f, 20, 32);
                    image->sprite_size = 1.2f + 0.1f * (10.0f * mgRnd());
                    character->SetMotion(at_1700__2__DATA, 0);
                } else {
                    image->SethitEffect(position, direction.f, 10.0f, 30.0f, 0.4f, -0.1f, 20, (int) mgDistVector(position, previous));
                    image->sprite_size = 0.6f + 0.1f * (10.0f * mgRnd());
                    character->SetMotion(at_1380__2__DATA, 0);
                }
                image->kind = 0;
                image->tex_rect = mgRect<int>(425, 85, 42, 42);
                effect_cnt++;
                if (effect_cnt >= 96) {
                    effect_cnt = 0;
                }
                CMap *map = scene->GetMap(scene->active_map);
                map->water->frame->Shake(position[0], position[2], 0.05f * (4.0f * mgRnd() - 2.0f));
                character->SetPosition(position);
                sceVu0SubVector(delta, position, previous);
                sceVu0Normalize(forward, delta);
                float angle = atan2f(forward[0], forward[2]);
                rotation[1] = mgAngleInterpolate(rotation[1], angle, 0.034906585f, 0);
                character->SetRotation(rotation);
                character->SetStep(0.3f + mgDistVector(position, previous) / 3.0f);
            }
            if (race_mode == 3) {
                race_proc_cnt--;
                if (race_proc_cnt == 30) {
                    scene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
                }
                if (race_proc_cnt <= 0) {
                    race_mode = 5;
                    break;
                }
            }
            if (race_mode == 2 && unfinished == 0) {
                race_mode = 3;
                race_proc_cnt = 120;
            }
            AutoCam(info);
            break;
        }
        case 4: {
            scene->active_camera = camera_id;
            camera0.SetPos(270.0f, -40.0f, -10.0f);
            camera0.SetNextPos(270.0f, -40.0f, -10.0f);
            camera0.SetRef(192.0f, 0.0f, 0.0f);
            camera0.SetNextRef(192.0f, 0.0f, 0.0f);
            camera0.SetSpeed(0.0f, 0.0f);
            for (int fish = 0; fish < 6; fish++) {
                CCharacter2    *character = scene->GetCharacter(fish_inf[fish].chara_no);
                grRACE_PROGRESS progress;
                grGetFishProgress(&RaceInfo, fish, RaceInfo.goal_time[fish_rank[0]], &progress);
                float distance = progress.pos;
                if (!(distance < 8.0f)) {
                    distance -= 8.0f * (float) ((unsigned int) distance >> 3);
                }
                float position[4];
                float matrix[4][4];
                position[1] = 0.0f;
                if (distance >= 0.0 && distance < 1.0) {
                    position[0] = 190.0f + 15.0f * progress.lane_pos;
                    position[2] = -345.0f * distance;
                }
                if (distance >= 3.0 && distance < 4.0) {
                    position[0] = -190.0f - 15.0f * progress.lane_pos;
                    position[2] = -345.0f * (1.0f - (distance - 3.0f));
                }
                if (distance >= 4.0 && distance < 5.0) {
                    position[0] = -190.0f - 15.0f * progress.lane_pos;
                    position[2] = 345.0f * (distance - 4.0f);
                }
                if (distance >= 7.0 && distance < 8.0) {
                    position[0] = 190.0f + 15.0f * progress.lane_pos;
                    position[2] = 345.0f * (1.0f - (distance - 7.0f));
                }
                if (!(distance < 1.0f) && distance < 3.0f) {
                    position[0] = 190.0f + 15.0f * progress.lane_pos;
                    position[2] = 0.0f;
                    sceVu0UnitMatrix(matrix);
                    sceVu0RotMatrixY(matrix, matrix, 1.5707964f * (distance - 1.0f));
                    sceVu0ApplyMatrix(position, matrix, position);
                    position[2] -= 345.0f;
                }
                if (!(distance < 5.0f) && distance < 7.0f) {
                    position[0] = -190.0f - 15.0f * progress.lane_pos;
                    position[2] = 0.0f;
                    sceVu0UnitMatrix(matrix);
                    sceVu0RotMatrixY(matrix, matrix, 1.5707964f * (distance - 5.0f));
                    sceVu0ApplyMatrix(position, matrix, position);
                    position[2] += 345.0f;
                }
                position[1] = -15.0f;
                character->SetPosition(position);
                RaceVector rotation = at_1524__2;
                character->SetRotation(rotation.f);
                character->SetRotation(rotation.f);
                character->SetStep(0.0f);
            }
            race_proc_cnt--;
            if (race_proc_cnt <= 0) {
                race_mode = 3;
                race_proc_cnt = 120;
            }
            break;
        }
        case 5: {
            scene->active_camera = camera_id;
            race_mode = 2;
            race_proc_cnt = 0;
            SetGyoRaceRanking(RaceInfo.rank[hero_no] - 1);
            mgCTextureManager *textures = &mgTexManager;
            for (int fish = 0; fish < 6; fish++) {
                CCharacter2      *character = scene->GetCharacter(fish_inf[fish].chara_no);
                textures->DeleteBlock(character->texture_block);
                strcpy(fish_game_data[RaceInfo.rank[fish] - 1].name, at_1701__DATA);
                char *name = game_data[fish]->data.fish.name;
                strncpy(fish_game_data[RaceInfo.rank[fish] - 1].name, name, strlen(name));
                fish_game_data[RaceInfo.rank[fish] - 1].time = 20.0f * RaceInfo.goal_time[fish];
                fish_game_data[RaceInfo.rank[fish] - 1].fish_no = fish_inf[fish].fish_no;
                fish_game_data[RaceInfo.rank[fish] - 1].race_class = race_rank[0];
                sndSeStop(gyore_snd_id, fish + 3, fish + 3);
                sndSeStop(gyore_snd_id, fish + 9, fish + 9);
            }
            for (int place = 0; place < 6; place++) {
                printf(at_1702__DATA, place + 1, fish_game_data[place].name);
            }
            sndSeStop(gyore_snd_id, 2, 0);
            textures->DeleteBlock(WindowTexb);
            textures->DeleteBlock(EffectTexb);
            mgSetAmbient(old_ambient);
            scene->SetActive(1, 0);
            scene->active_camera = scene->before_camera;
            union {
                CSceneEventData data;
            };
            memset(&data, 0, sizeof(data));
            if (OmakeFlag != 0) {
                scene->RunEvent(352, &data);
            } else {
                scene->RunEvent(350, &data);
            }
            return 1;
        }
    }
    for (int fish = 0; fish < 6; fish++) {
        scene->GetCharacter(fish_inf[fish].chara_no)->Step();
    }
    RaceVector ambient = at_1547;
    float      camera_matrix[4][4];
    RaceVector camera_pos = at_1548;
    camera0.Step(1);
    camera0.GetCameraMatrix(camera_matrix);
    camera0.GetPos(camera_pos.f);
    if (camera_pos.f[1] < 0.0f) {
        mgSetAmbient(ambient.f);
        water_cam = 1;
    } else {
        mgSetAmbient(old_ambient);
        water_cam = 0;
    }
    mgSetViewMatrix(camera_matrix, camera_pos.f);
    for (int fish = 0; fish < 6; fish++) {
        CCharacter2 *character = scene->GetCharacter(fish_inf[fish].chara_no);
        float        position[4];
        float        camera_pos[4];
        float        camera_ref[4];
        float        volume;
        float        pan;
        camera0.GetPos(camera_pos);
        camera0.GetRef(camera_ref);
        sceVu0SubVector(camera_ref, camera_ref, camera_pos);
        sndSetMicPos(camera_pos, camera_ref);
        character->GetPosition(position);
        sndGetVolPan(&volume, &pan, position, 20.0f, 1600.0f);
        if (camera_pos[1] < 0.0f) {
            sndSetSeVolf(gyore_snd_id, fish + 9, volume, fish + 9);
            sndSetSePanf(gyore_snd_id, fish + 9, pan, fish + 9);
            sndSetSeVolf(gyore_snd_id, fish + 3, 0.0f, fish + 3);
        } else {
            sndSetSeVolf(gyore_snd_id, fish + 3, volume, fish + 3);
            sndSetSePanf(gyore_snd_id, fish + 3, pan, fish + 3);
            sndSetSeVolf(gyore_snd_id, fish + 9, 0.0f, fish + 9);
        }
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgLoopGyoRace__FP11SubGameInfo);
#endif

void AutoCam(SubGameInfo *info) {
    CScene *scene = info->scene;
    CCharacter2 *hero = scene->GetCharacter(fish_inf[hero_no].chara_no);
    float hero_pos[4];
    hero->GetPosition(hero_pos);
    float nearest = 9999.0f;
    cam_no = 0;
    int camera = 0;
    do {
        float distance = mgDistVector(hero_pos, cam_pos[camera]);
        if (distance < nearest) {
            nearest = distance;
            cam_no = camera;
        }
        camera++;
    } while (camera < 5);
    if (old_cam_no != cam_no) {
        if (cam_pos[cam_no][1] < 0.0f) {
            sndSetSeVol(gyore_snd_id, 2, sndGetSeDefVol(gyore_snd_id, 2), 0);
        } else {
            sndSetSeVol(gyore_snd_id, 2, 0, 0);
        }
        camera0.SetPos(cam_pos[cam_no]);
        camera0.SetNextPos(cam_pos[cam_no]);
        mgDistVector(hero_pos, cam_pos[cam_no]);
        scene->active_camera = camera_id;
        camera0.SetRef(hero_pos);
        camera0.SetNextRef(hero_pos);
        camera0.SetSpeed(0.0f, 0.0f);
        win_alpha = 128.0f;
    } else {
        camera0.SetSpeed(9999.0f, 20.0f);
        mgDistVector(hero_pos, cam_pos[cam_no]);
        camera0.SetNextRef(hero_pos);
    }
    old_cam_no = cam_no;
}

int sgMapDrawGyoRace(SubGameInfo *info) {
    return 0;
}

int sgCharaDrawGyoRace(SubGameInfo *info) {
    CScene *scene;
    int     i;
    scene = info->scene;
    i = 0;

    do {
        scene->DrawChara(fish_inf[i].chara_no, 1);
        i++;
    } while (i < 6);

    mgTexManager.ReloadTexture(EffectTexb, (sceVif1Packet *) NULL);
    int j = 0;
    CHitEffectImage *effect;

    do {
        effect = &battle_effect[j];

        if (effect != 0) {
            effect->Step();
            effect->Draw();
        }

        j++;
    } while (j < 0x60);

    return 0;
}

/**
 *
 * Draws the race screen texture as rotated horizontal strips.
 *
 */
static void DivSpriteScreen(mgCDrawPrim &prim) {
    int strip_height;
    int screen_width;
    int y;
    int y16;
    int x;
    int x16;
    int height16;
    int width16;

    if (!init_1763) {
        ras_off_1762 = 0.0f;
        init_1763 = 1;
    }

    prim.BeginPrim2(4, 0x43, 0, 2);
    int origin[4] = {mgScreenOffx << 4, mgScreenOffy << 4, 0, 0};
    screen_width = mgScreenWidth;
    int screen_height = mgScreenHeight;
    strip_height = screen_height / 48;
    float step[4] = {0, 0, 0, 1};
    step[1] = (float) ((strip_height / 3) << 4);
    float matrix[4][4];
    sceVu0UnitMatrix(matrix);
    x = 0;
    x16 = 0;
    width16 = screen_width << 4;

    while (x < mgScreenWidth) {
        y = 0;
        y16 = 0;
        height16 = strip_height << 4;

        while (y < mgScreenHeight) {
            sceVu0RotMatrixZ(matrix, matrix, ras_off_1762);
            sceVu0ApplyMatrix(step, matrix, step);
            RaceVector uv;
            uv = at_1775;
            RaceVector xy;
            xy = at_1776;
            uv = *(RaceVector *) origin;
            xy.v[0] = x16;
            int *xy_y = &xy.v[1];
            *xy_y = y16;
            prim.Data(xy.v);
            uv.v[0] = xy.v[0] + origin[0] - (int) step[0];
            uv.v[1] = *xy_y + origin[1];
            prim.Data(uv.v);
            xy.v[0] = (x + screen_width) << 4;
            *xy_y = (y + strip_height) << 4;
            prim.Data(xy.v);
            uv.v[0] = (int) step[0] + (xy.v[0] + origin[0]);
            uv.v[1] = *xy_y + origin[1];
            prim.Data(uv.v);
            y += strip_height;
            y16 += height16;
        }

        x += screen_width;
        x16 += width16;
    }

    ras_off_1762 += 0.0004363323f;

    if (!(ras_off_1762 <= 6.2831855f)) {
        ras_off_1762 = -6.2831855f;
    }

    prim.EndPrim2();
}

int sgEffectDrawGyoRace(SubGameInfo *info) {
    if (!water_cam) {
        return 0;
    }

    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    mgCTexture frame;
    mgGetFrameBuffer(&frame);
    frame.tex0.bits.tcc = 0;
    prim.DepthTestEnable(0);
    prim.AlphaTestEnable(0);
    prim.AlphaBlendEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.TextureMapEnable(1);
    prim.Begin2();
    prim.BeginPrim2(MG_PRIM_SPRITE);
    prim.Texture(&frame);
    prim.Direct(SCE_GS_TEXA, 0x8000008080ULL);
    prim.Color(128, 128, 128, 128);
    prim.EndPrim2();
    DivSpriteScreen(prim);
    prim.End2();
    return 0;
}

int sgSysDrawGyoRace(SubGameInfo *info) {
    static int lap_inf[2][5];
    static int lap_inf2[5];
    CScene *scene;
    float lap_frames;
    float lap_seconds_frames;
    float total_frames;
    float total_seconds_frames;
    float bar_done;
    int total_centi_tens;
    int lap_second_tens;
    int lap_centi_tens;
    int total_minutes;
    int total_seconds;
    int total_centi;
    int total_second_tens;
    int mode;
    int i;
    int row;
    int j;
    int k;
    int lap;
    mgCTextureManager *textures = &mgTexManager;
    scene = info->scene;
    textures->ReloadTexture(GetSystemMessage()->texture_block, (sceVif1Packet *) NULL);
    Jikkyou(info);
    gyo_mes->Step();
    gyo_mes->DrawMesWin();
    win_alpha -= 0.5f;
    if (win_alpha < 0.0f) {
        win_alpha = 0.0f;
    }
    textures->ReloadTexture(WindowTexb, (sceVif1Packet *) NULL);
    wind_tex = textures->GetTexture("grt1", -1);
    {
        mgRect<int> screen;
        mgRect<int> texture;
        screen.Set(0x15, 0x13, 0x1D6, 0x54);
        texture.Set(0, 0, 0x1D6, 0x54);
        PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
    }
    grRACE_PROGRESS progress;
    i = 0;
    do {
        grGetFishProgress(&RaceInfo, i, race_cnt, &progress);
        if (progress.pos > 16.0f) {
            progress.pos = 16.0f;
        }
        bar_done = 326.0f * (progress.pos / 16.0f);
        float bar_y = 35.0f + 10.0f * (float) RaceInfo.fish[i].lane;
        DrawMenuFillBox(41.0f + bar_done, bar_y, 326.0f - bar_done, 2.0f, 0x4A, 0x70, 0xD9, 0x8B);
        float filled = 326.0f * (progress.pos / 16.0f);
        DrawMenuFillBox(41.0f, (float) ((RaceInfo.fish[i].lane * 10) + 35), filled, 2.0f, 0x54, 0xE5, 0x8B, 0x29);
        mgRect<int> icon((int) (31.0f + (float) (int) (326.0f * (progress.pos / 16.0f))), (RaceInfo.fish[i].lane * 10) + 28, 0x12, 0xC);
        if ((i == hero_no) && (OmakeFlag == 0)) {
            mgRect<int> hero_icon(0x1EE, 0xC, 0x12, 0xC);
            if (progress.state != GR_RACE_STATE_GOAL) {
                PrimQuad(wind_tex, icon, hero_icon, 0x80, 0x80, 0x80, 0x80);
            } else {
                PrimQuad(wind_tex, icon, hero_icon, 0x80, 0x80, 0x80, 0);
            }
        } else {
            mgRect<int> rival_icon(0x1EE, 0, 0x12, 0xC);
            if (progress.state != GR_RACE_STATE_GOAL) {
                PrimQuad(wind_tex, icon, rival_icon, 0x80, 0x80, 0x80, 0x80);
            } else {
                PrimQuad(wind_tex, icon, rival_icon, 0x80, 0x80, 0x80, 0);
            }
        }
        i += 1;
    } while (i < 6);
    mode = race_mode;
    if ((mode == GYORACE_MODE_READY) || (mode == GYORACE_MODE_GATE_OPEN)) {
        row = 0;
        j = 0;
        k = 0;
        do {
            {
                mgRect<int> screen;
                mgRect<int> texture;
                screen.Set(k + 0x1A2, j + 0x41, 0xC, 0xC);
                texture.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
            }
            {
                mgRect<int> screen;
                mgRect<int> texture;
                screen.Set(k + 0x1B0, j + 0x41, 0xC, 0xC);
                texture.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
            }
            {
                mgRect<int> screen;
                mgRect<int> texture;
                screen.Set(k + 0x1BA, j + 0x41, 0xC, 0xC);
                texture.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
            }
            {
                mgRect<int> screen;
                mgRect<int> texture;
                screen.Set(k + 0x1C9, j + 0x41, 0xC, 0xC);
                texture.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
            }
            {
                mgRect<int> screen;
                mgRect<int> texture;
                screen.Set(k + 0x1D3, j + 0x41, 0xC, 0xC);
                texture.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
            }
            row += 1;
            j += 0x10;
            k += 2;
        } while (row < 2);
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x1CB, 0x1B, 0x18, 0x20);
            texture.Set(0xA8, 0x54, 0x18, 0x20);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x176, 0x2B, 0x10, 0xE);
            texture.Set(0x160, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x189, 0x2B, 0x10, 0xE);
            texture.Set(0x160, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x197, 0x2B, 0x10, 0xE);
            texture.Set(0x160, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x1AB, 0x2B, 0x10, 0xE);
            texture.Set(0x160, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x1B9, 0x2B, 0x10, 0xE);
            texture.Set(0x160, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
    } else {
        lap_frames = fish_inf[hero_no].lap_time[lap = fish_inf[hero_no].lap];
        i = (int) (lap_frames / 3600.0f);
        lap_seconds_frames = lap_frames - 3600.0f * (float) i;
        j = (int) (lap_seconds_frames / 60.0f);
        k = (int) (100.0f * (lap_seconds_frames - 60.0f * (float) j) / 60.0f);
        lap_inf[lap][0] = i;
        lap_second_tens = (int) (0.1f * (float) j);
        lap_inf[lap][1] = lap_second_tens;
        lap_inf[lap][2] = j - (lap_second_tens * 10);
        lap_centi_tens = (lap_inf[lap][3] = (int) (0.1f * (float) k));
        lap_inf[lap][4] = k - lap_centi_tens * 10;
        int lap_no = 0;
        int lap_y = 0;
        int lap_x = 0;
        do {
            if ((int) fish_inf[hero_no].lap < lap_no) {
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1A2, lap_y + 0x41, 0xC, 0xC);
                    texture.Set(0x138, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1B0, lap_y + 0x41, 0xC, 0xC);
                    texture.Set(0x138, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1BA, lap_y + 0x41, 0xC, 0xC);
                    texture.Set(0x138, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1C9, lap_y + 0x41, 0xC, 0xC);
                    texture.Set(0x138, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1D3, lap_y + 0x41, 0xC, 0xC);
                    texture.Set(0x138, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
            } else {
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1A2, lap_y + 0x41, 0xC, 0xC);
                    texture.Set((lap_inf[lap_no][0] * 12) + 0xC0, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1B0, lap_y + 0x41, 0xC, 0xC);
                    texture.Set((lap_inf[lap_no][1] * 12) + 0xC0, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1BA, lap_y + 0x41, 0xC, 0xC);
                    texture.Set((lap_inf[lap_no][2] * 12) + 0xC0, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1C9, lap_y + 0x41, 0xC, 0xC);
                    texture.Set((lap_inf[lap_no][3] * 12) + 0xC0, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
                {
                    mgRect<int> screen;
                    mgRect<int> texture;
                    screen.Set(lap_x + 0x1D3, lap_y + 0x41, 0xC, 0xC);
                    texture.Set((lap_inf[lap_no][4] * 12) + 0xC0, 0x62, 0xC, 0xC);
                    PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
                }
            }
            lap_y += 0x10;
            lap_x += 2;
            lap_no += 1;
        } while (lap_no < 2);
        total_frames = fish_inf[hero_no].time;
        total_minutes = (int) (total_frames / 3600.0f);
        total_seconds_frames = total_frames - (3600.0f * (float) total_minutes);
        total_seconds = (int) (total_seconds_frames / 60.0f);
        total_centi = (int) ((100.0f * (total_seconds_frames - (60.0f * (float) total_seconds))) / 60.0f);
        lap_inf2[0] = total_minutes;
        total_second_tens = (int) (0.1f * (float) total_seconds);
        lap_inf2[1] = total_second_tens;
        lap_inf2[2] = total_seconds - (total_second_tens * 10);
        total_centi_tens = (int) (0.1f * (float) total_centi);
        lap_inf2[3] = total_centi_tens;
        lap_inf2[4] = total_centi - (total_centi_tens * 10);
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x176, 0x2B, 0x10, 0xE);
            texture.Set((lap_inf2[0] * 16) + 0xC0, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x189, 0x2B, 0x10, 0xE);
            texture.Set((lap_inf2[1] * 16) + 0xC0, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x197, 0x2B, 0x10, 0xE);
            texture.Set((lap_inf2[2] * 16) + 0xC0, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x1AB, 0x2B, 0x10, 0xE);
            texture.Set((lap_inf2[3] * 16) + 0xC0, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x1B9, 0x2B, 0x10, 0xE);
            texture.Set((lap_inf2[4] * 16) + 0xC0, 0x54, 0x10, 0xE);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x1CB, 0x1B, 0x18, 0x20);
            texture.Set(fish_inf[hero_no].rank * 0x18, 0x54, 0x18, 0x20);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
    }
    grRACE_PROGRESS hero_progress;
    scene->GetCharacter(fish_inf[hero_no].chara_no);
    grGetFishProgress(&RaceInfo, hero_no, race_cnt, &hero_progress);
    if (hero_progress.state == GR_RACE_STATE_GOAL) {
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x178, 0x1C, 0xC, 0xC);
            texture.Set(0xD8, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x187, 0x1C, 0xC, 0xC);
            texture.Set(0xD8, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
    } else {
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x178, 0x1C, 0xC, 0xC);
            texture.Set(((int) fish_inf[hero_no].lap * 12) + 0xC0, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
        {
            mgRect<int> screen;
            mgRect<int> texture;
            screen.Set(0x187, 0x1C, 0xC, 0xC);
            texture.Set(0xD8, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
        }
    }
    return 0;
}

int Jikkyou(SubGameInfo *info) {
    CFont           font;
    grRACE_PROGRESS lead;
    grRACE_PROGRESS progress[6];
    grRACE_PROGRESS fish;
    float           position;
    int             index;
    int             fish_no;
    char           *name;
    ClsMes         *message;

    font.Init();
    font.Preset(4);
    font.SetFuchi(3);
    font.SetDrawSize(16, 20);
    const float race_time = race_cnt;

    if ((double) race_time <= 0.0) {
        return -1;
    }

    mes_count--;

    if (mes_count < 0) {
        mes_count = 0;
    }

    if (mes_count > 0) {
        return -1;
    }

    grGetFishProgress(&RaceInfo, fish_rank[0], race_time, &lead);
    position = lead.pos;

    if (!(position <= 0.0f) && position <= 1.0f) {
        gyo_mes->MakeMesWin(5);
        mes_count = 60;
        return 0;
    }

    if (!(position <= 1.0f) && position <= 2.0f) {
        grGetFishProgress(&RaceInfo, fish_rank[0], 0.5f, &progress[0]);
        grGetFishProgress(&RaceInfo, fish_rank[5], 0.5f, &progress[1]);

        if (!(progress[0].pos - progress[1].pos <= 0.01f)) {
            gyo_mes->MakeMesWin(6);
            mes_count = 60;
            return 0;
        }

        gyo_mes->MakeMesWin(7);
        mes_count = 60;
        return 0;
    }

    if ((!(position <= 2.0f) && position < 8.0f) || (!(position <= 9.0f) && position < 16.0f)) {
        if (!jyunkai_flg) {
            jyunkai_flg = 1;
            index = 0;

            do {
                grGetFishProgress(&RaceInfo, index, race_cnt, &fish);

                if (fish.state == GR_RACE_STATE_BATTLE) {
                    int lane = RaceInfo.fish[index].lane + 1;
                    message = gyo_mes;
                    message->values[0] = lane;
                    message->value_width[0] = 0;
                    name = RaceInfo.fish[index].name;
                    ClsMes *name_mes = gyo_mes;

                    if (name != NULL) {
                        strcpy(name_mes->name[0], name);
                    }

                    gyo_mes->MakeMesWin(29);
                    mes_count = 60;
                    jyunkai_flg = 0;
                    sndSePlay(gyore_snd_id, 0x16, 0);
                    break;
                }

                index++;
            } while (index < 6);

            return 0;
        }

        fish_no = fish_rank[rank_count];
        int lane = RaceInfo.fish[fish_no].lane + 1;
        message = gyo_mes;
        message->values[0] = lane;
        message->value_width[0] = 0;
        name = RaceInfo.fish[fish_no].name;
        ClsMes *name_mes = gyo_mes;

        if (name != NULL) {
            strcpy(name_mes->name[0], name);
        }

        if (rank_count == 0) {
            gyo_mes->MakeMesWin(RaceInfo.fish[fish_no].bonus_type + 9);
        } else if (rank_count < 5) {
            if (fish_rank[rank_count] == old_fish_rank[rank_count - 1]) {
                fish_no = fish_rank[rank_count - 1];
                int lane = RaceInfo.fish[fish_no].lane + 1;
                message = gyo_mes;
                message->values[0] = lane;
                message->value_width[0] = 0;
                name = RaceInfo.fish[fish_no].name;
                ClsMes *name_mes = gyo_mes;

                if (name != NULL) {
                    strcpy(name_mes->name[0], name);
                }

                gyo_mes->MakeMesWin(RaceInfo.fish[fish_no].bonus_type + 13);
            } else {
                gyo_mes->MakeMesWin(RaceInfo.fish[fish_no].bonus_type + 17);
            }
        } else {
            gyo_mes->MakeMesWin(RaceInfo.fish[fish_no].bonus_type + 21);
        }

        old_fish_rank[rank_count] = fish_rank[rank_count];
        rank_count++;

        if (!(position <= 9.0f)) {
            if (rank_count > 1) {
                rank_count = 0;
            }
        } else if (rank_count > 5) {
            rank_count = 0;
        }

        mes_count = 60;
        return 0;
    }

    if (!(position <= 8.0f) && position <= 9.0f) {
        jyunkai_flg = 0;
        rank_count = 0;
        gyo_mes->MakeMesWin(30);
        sndSePlay(gyore_snd_id, 0x16, 0);
        mes_count = 60;
        return 0;
    }

    if (!(position < 16.0f)) {
        message = gyo_mes;
        message->values[0] = 1;
        message->value_width[0] = 0;
        name = RaceInfo.fish[fish_rank[0]].name;
        ClsMes *name_mes = gyo_mes;

        if (name != NULL) {
            strcpy(name_mes->name[0], name);
        }

        gyo_mes->MakeMesWin(31);
        mes_count = 6000;
        sndSePlay(gyore_snd_id, 0x16, 0);
        sndSePlay(gyore_snd_id, 0x17, 0);
    }

    return 0;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1481__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1524__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1547__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1548__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1380__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1696__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1697__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1698__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1699__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1700__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1701__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1702__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1703__DATA);

// Uninitialised data (.bss)
/**
 *
 * Camera the fish race scene is viewed through.
 *
 */
mgCCamera camera0(8.0f);
#ifndef NONMATCHING
INCLUDE_BSS(at_1775, 0x10);
INCLUDE_BSS(at_1776, 0x10);
#endif
