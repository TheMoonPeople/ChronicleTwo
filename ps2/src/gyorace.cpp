#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "dataread.hpp"
#include "gyorace.hpp"
#include "gyoracesim.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
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

extern RaceVector  at_1765__2;
extern RaceVector  at_1766__3;
extern RaceVector  at_1775;
extern RaceVector  at_1776;
extern float       ras_off_1762;
extern signed char init_1763;

struct CHitEffectImage;

/**
 *
 * Texture flags stored in a race frame's image data.
 *
 */

extern int              EffectTexb;
extern u_char           water_cam;
extern CHitEffectImage *battle_effect;
extern mgCMemory        BuffTextureData;

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

#ifndef NONMATCHING
extern unsigned int gyore_snd_id;
extern int          hero_no;
extern int          cam_no;
extern int          old_cam_no;
extern float        win_alpha;
extern int          rank_count;
extern int          mes_count;
extern int          jyunkai_flg;
extern int          fish_rank[6];
extern int          old_fish_rank[6];
#endif

#ifdef NONMATCHING
#include <cstring>

#include "character.hpp"
#include "dng_effect.hpp"
#include "dng_main.hpp"
#include "menuaqua.hpp"
#include "userdata.hpp"

static unsigned int     gyore_snd_id;
float                   race_cnt;
int                     race_proc_cnt;
int                     race_mode;
int                     time_max;
static int              rank_count;
static mgCTexture      *EffectTex;
static mgCTexture      *EffectTex2;
static int              hero_no;
static u_char           water_cam;
static int              cam_no;
static float            win_alpha;
static int              effect_cnt;
static int              mes_count;
static int              jyunkai_flg;
static int              hantei_flg;
static int              goal_cnt;
static CHitEffectImage *battle_effect;
static BattleEffectPrim (*battle_EffectPara)[32];
int                   camera_id;
int                   race_rank[2];
ClsMes               *gyo_mes;
static int            CharaTexb;
static int            EffectTexb;
static float          raster_offset;
static bool           raster_initialized;
GYORACE_RESULT        fish_game_data[6];
grRACE_INFO           RaceInfo;
grRACE_PROGRESS       old_prog[6];
static int            fish_rank[6];
static int            old_fish_rank[6];
static CGameDataUsed *game_data[8];
static float          old_ambient[4];
GYORACE_FISH_INF      fish_inf[6];
static int            old_cam_no = -1;
#endif

// Code (.text)
#ifdef NONMATCHING
int sgInitGyoRace(SubGameInfo *info) {
    extern char        at_1373__3__DATA[];
    extern char        at_1374__2__DATA[];
    extern char        at_1375__2__DATA[];
    extern char        at_1376__2__DATA[];
    extern char        at_1377__4__DATA[];
    extern char        at_1378__3__DATA[];
    extern char        at_1379__3__DATA[];
    extern char        at_1380__2__DATA[];
    extern char        at_1381__DATA[];
    extern char        at_1382__2__DATA[];
    extern char        at_1383__3__DATA[];
    extern char        at_1384__2__DATA[];
    extern RaceVector  at_1027__4;
    extern RaceVector  at_1028__9;
    mgCTextureManager *textures;
    CScene            *scene = info->scene;
    scene->AssignStack(5);
    mgCMemory *memory = scene->GetStack(5);
    BuffTextureData.stSetBuffer(memory->stAlloc64(0x88B8), 0x88B8);
    BuffTextureData.stReset();
    BuffWorkData.stSetBuffer(memory->stAlloc64(0x7530), 0x7530);
    BuffWorkData.stReset();
    u_long128 *buffer = scene->read_buff;
    int        size;
    sndInitPort(5);
    LoadFile2(at_1373__3__DATA, buffer, &size, 0);
    gyore_snd_id = sndLoadSound((int) SND_PORT_ENEMY, (unsigned int *) buffer, memory);
    ChangeDir(at_1374__2__DATA);
    CGyoraceFishData fish_data;
    fish_data.LoadData(memory, buffer);
    u_long128 *texture_buffer = BuffTextureData.stack;
    char       path[0x100];
    sprintf(path, at_1375__2__DATA, LanguageCode);
    LoadFile2(path, texture_buffer, &size, 0);
    gyo_mes = new (memory->Alloc(0x298)) ClsMes;
    gyo_mes->SetBuff((short *) texture_buffer);
    gyo_mes->SetBuff_system(GetSystemMesBuffer());
    gyo_mes->Init();
    gyo_mes->Preset(0);
    gyo_mes->SetWindowMode(7);
    gyo_mes->draw_speed = 3.8f;
    gyo_mes->draw_speed_def = 3.8f;
    gyo_mes->push_button = 0;
    gyo_mes->MakeMesWin(0);
    texture_buffer += (size / 16) + 1;
    race_mode = 0;
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
    battle_EffectPara = new (memory->Alloc(0x3C02)) BattleEffectPrim[96][32];
    battle_effect = new (memory->Alloc(0x242)) CHitEffectImage[96];
    for (int effect = 0; effect < 96; effect++) {
        CHitEffectImage *image = &battle_effect[effect];
        image->spark = battle_EffectPara[effect];
        image->spark_max = 32;
        image->live_num = 0;
        image->spark_num = 0;
        image->kind = 0;
    }
    race_rank[0] = GetGyoRaceClass();
    race_rank[1] = GetGyoRaceNo();
    int chosen[6];
    int chosen_num = 0;
    int fish = 0;
    do {
        fish_inf[fish].fish_no = -1;
        int &number_slot = fish_inf[fish].fish_no;
        if (OmakeFlag != 0) {
            CGameDataUsed  *race_fish = GetOmakeGyoracer2(fish);
            CGameDataUsed **item = &game_data[fish];
            *item = race_fish;
            if (*item == NULL) {
                chosen[chosen_num] = race_rank[1] * 18 + (int) (17.0f * mgRnd());
                do {
                    int old;
                    for (old = 0; old < chosen_num; old++) {
                        if (chosen[old] == chosen[chosen_num]) {
                            break;
                        }
                    }
                    if (chosen_num == old) {
                        break;
                    }
                    chosen[chosen_num] = race_rank[1] * 18 + (int) (17.0f * mgRnd());
                } while (1);
                *item = fish_data.GetRaceFish(race_rank[0], chosen[chosen_num]);
                chosen_num++;
            }
        } else if (fish == 0) {
            game_data[fish] = GetGyoRaceFish();
        } else {
            chosen[chosen_num] = race_rank[1] * 18 + (int) (17.0f * mgRnd());
            do {
                int old;
                for (old = 0; old < chosen_num; old++) {
                    if (chosen[old] == chosen[chosen_num]) {
                        break;
                    }
                }
                if (chosen_num == old) {
                    break;
                }
                chosen[chosen_num] = race_rank[1] * 18 + (int) (17.0f * mgRnd());
            } while (1);
            int            number = chosen[chosen_num];
            CGameDataUsed *race_fish = fish_data.GetRaceFish(race_rank[0], number);
            chosen_num++;
            game_data[fish] = race_fish;
            number_slot = number;
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
        lane = (int) (6.0f * mgRnd());
        if (lane > 5) {
            lane = 5;
        }
    }
    memset(&RaceInfo, 0, sizeof(RaceInfo));
    RaceInfo.seed = 0;
    printf(at_1376__2__DATA, RaceInfo.seed);
    RaceInfo.fish_num = 6;
    RaceInfo.step_max = 1000;
    RaceInfo.after_goal_step = 20;
    int racer = 0;
    do {
        RaceInfo.progress[racer] = new (memory->Alloc(0x5DE)) grRACE_PROGRESS[1000];
        if (OmakeFlag == 0 && racer == 0) {
            RaceInfo.fish[racer].tactics = GetGyoRaceAquariumNo();
        } else if (OmakeFlag != 0) {
            RaceInfo.fish[racer].tactics = GetOmakeGyoracerTactics(racer);
        } else {
            RaceInfo.fish[racer].tactics = (int) (6.0f * mgRnd());
            if (RaceInfo.fish[racer].tactics > 5) {
                RaceInfo.fish[racer].tactics = 5;
            }
        }
        int             fatigue;
        CGameDataUsed **item = &game_data[racer];
        grRACE_INFO    *entry = &RaceInfo;
        char           *name = entry->fish[racer].name;
        strcpy(name, (*item)->data.fish.name);
        CGameDataUsed *fish_item = *item;
        entry->fish[racer].bonus_type = fish_item->data.fish.kind;
        entry->fish[racer].power = fish_item->data.fish.param[BREEDFISH_STAT_BATTLE];
        BREEDFISH_USED *data = &fish_item->data.fish;
        if (OmakeFlag == 0 && racer == 0) {
            if (race_rank[1] == 0) {
                data->fatigue++;
            }
            fish_item = *item;
            BREEDFISH_USED *stamina_data = &fish_item->data.fish;
            fatigue = (unsigned short) fish_item->data.fish.fatigue;
            entry->fish[racer].stamina = (int) ((float) stamina_data->param[BREEDFISH_STAT_STAMINA] - (0.1f * (float) (fatigue - 1) * (float) fish_item->data.fish.param[BREEDFISH_STAT_STAMINA]));
            printf(at_1377__4__DATA, fatigue);
        } else {
            entry->fish[racer].stamina = data->param[BREEDFISH_STAT_STAMINA];
        }
        fish_item = *item;
        entry->fish[racer].speed[0] = fish_item->data.fish.param[BREEDFISH_STAT_BOOST];
        entry->fish[racer].speed[1] = fish_item->data.fish.param[BREEDFISH_STAT_ENDURANCE];
        entry->fish[racer].speed[2] = fish_item->data.fish.param[BREEDFISH_STAT_TENACITY];
        entry->fish[racer].affinity = fish_item->data.fish.color;
        entry->fish[racer].fish_no = fish_item->item_no;
        entry->fish[racer].lane = lane;
        fish_inf[racer].lane = lane;
        lane++;
        if (lane >= 6) {
            lane = 0;
        }
        printf(at_1378__3__DATA, name, entry->fish[racer].tactics);
        racer++;
    } while (racer < 6);
    time_max = grGyoRaceSimulate(&RaceInfo);
    for (int racer_no = 0; racer_no < 6; racer_no++) {
        scene->GetCharacter(fish_inf[racer_no].chara_no);
        grGetFishProgress(&RaceInfo, racer_no, race_cnt, &old_prog[racer_no]);
    }
    CharaTexb = info->texb;
    CGameDataUsed **item;
    int             fish_index = 0;
    do {
        grRACE_PROGRESS *progress = &old_prog[fish_index];
        grGetFishProgress(&RaceInfo, fish_index, 0.0f, progress);
        textures = &mgTexManager;
        textures->DeleteBlock(CharaTexb);
        item = &game_data[fish_index];
        int kind = (*item)->item_no - 0x140;
        if (kind < 0) {
            kind = 17;
        }
        if (LoadFile2(fish_name[kind], buffer, NULL, 0) == 0) {
            return 0;
        }
        GYORACE_FISH_INF *state = &fish_inf[fish_index];
        state->chara_no = fish_index + 0x40;
        state->lap = 0;
        state->unk_14 = 0;
        state->lap_start = 0.0f;
        state->time = 0.0f;
        state->rank = 1;
        int *character_no = &state->chara_no;
        scene->LoadChara(state->chara_no, (unsigned int *) buffer, at_1379__3__DATA, memory, memory, memory, CharaTexb, 0);
        scene->SetActive(SCENE_DATA_CHARA, *character_no);
        scene->SetCharaTexb(*character_no, CharaTexb);
        CCharacter2 *character = scene->GetCharacter(*character_no);
        RaceVector   position = at_1027__4;
        position.f[0] = 190.0f + 15.0f * (float) progress->lane;
        position.f[2] = character->body_height / 4.0f;
        RaceVector      rotation = at_1028__9;
        CGameDataUsed  *fish_item = *item;
        BREEDFISH_USED *data = &fish_item->data.fish;
        CDataBreedFish *breed = GetBreedFishInfoData(fish_item->item_no);
        float           scale = (float) data->size / breed->size;
        if (!(scale <= 2.0f)) {
            scale = 2.0f;
        }
        character->SetScale(scale, scale, scale);
        character->SetRotation(rotation.f);
        character->SetPosition(position.f);
        character->SetMotion(at_1380__2__DATA, 0);
        character->SetStep(0.3f);
        FishIMGReplace(buffer, character, (*item)->item_no, &(*item)->data.fish);
        fish_index++;
        CharaTexb++;
    } while (fish_index < 6);
    if (texture_buffer != NULL) {
        WindowTexb = CharaTexb;
        char image_path[0x20];
        if (LanguageCode > 0) {
            sprintf(image_path, at_1381__DATA, LanguageCode);
        } else {
            sprintf(image_path, at_1382__2__DATA, LanguageCode);
        }
        textures->DeleteBlock(WindowTexb);
        LoadFile(image_path, texture_buffer, &size);
        textures->EnterIMGFile((unsigned char *) texture_buffer, WindowTexb, &BuffTextureData, NULL);
        EffectTex2 = textures->GetTexture(at_1383__3__DATA, -1);
        EffectTexb = WindowTexb + 1;
        textures->DeleteBlock(EffectTexb);
        textures->EnterIMGFile((unsigned char *) texture_buffer, EffectTexb, &BuffTextureData, NULL);
        TEX_SystemEffect1 = EffectTex = textures->GetTexture(at_1384__2__DATA, -1);
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgInitGyoRace__FP11SubGameInfo);
#endif
#ifdef NONMATCHING
int sgLoopGyoRace(SubGameInfo *info) {
    extern const unsigned char at_1380__2__DATA[];
    extern const unsigned char at_1696__2__DATA[];
    extern const unsigned char at_1697__3__DATA[];
    extern const unsigned char at_1698__3__DATA[];
    extern const unsigned char at_1699__3__DATA[];
    extern const unsigned char at_1700__2__DATA[];
    extern const unsigned char at_1701__DATA[];
    extern const unsigned char at_1702__DATA[];
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
                character->SetMotion((char *) at_1380__2__DATA, 0);
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
            mgCFrame *gate = scene->GetMap(scene->active_map)->GetParts((char *) at_1696__2__DATA)->SearchPiece((char *) at_1697__3__DATA)->frame;
            mgCFrame *left = gate->SearchFrame((char *) at_1698__3__DATA);
            left->SetRotType(2);
            float rotation[4];
            left->GetRotation(rotation);
            rotation[1] += 0.20943952f;
            if (!(rotation[1] <= 1.5707964f)) {
                rotation[1] = 1.5707964f;
            }
            left->SetRotation(rotation[0], rotation[1], rotation[2]);
            mgCFrame *right = gate->SearchFrame((char *) at_1699__3__DATA);
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
                if ((unsigned char) progress.state != 3) {
                    for (int other = 0; other < 6; other++) {
                        if (other != fish) {
                            grRACE_PROGRESS other_progress;
                            grGetFishProgress(&RaceInfo, other, race_cnt, &other_progress);
                            if ((unsigned char) other_progress.state != 3) {
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
                CCharacter2      *character = scene->GetCharacter(state->chara_no);
                grRACE_PROGRESS   progress;
                grGetFishProgress(&RaceInfo, fish, race_cnt, &progress);
                if ((unsigned char) progress.state == 3) {
                    unfinished--;
                }
                if (!(progress.pos < 8.0f)) {
                    unsigned int  lap = (unsigned int) (progress.pos / 8.0f);
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
                    if ((unsigned char) progress.state != 3) {
                        state->time = 20.0f * race_cnt;
                        state->lap_time[fish_inf[hero].lap] = state->time - 20.0f * state->lap_start;
                    } else if ((unsigned char) progress.state == 3) {
                        float *total;
                        *(total = &state->time) = 20.0f * RaceInfo.goal_time[(int) fish];
                        float time = state->lap_time[0];
                        float minutes = 3600.0f * (float) (int) (time / 3600.0f);
                        time -= minutes;
                        float seconds = 60.0f * (float) (int) (time / 60.0f);
                        state->lap_time[1] = *total - ((60.0f * (float) (int) ((100.0f * (time - seconds)) / 60.0f)) / 100.0f + (minutes + seconds));
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
                if ((unsigned char) progress.state == 2) {
                    image->SethitEffect(position, direction.f, 150.0f, 30.0f, 0.4f, -0.05f, 20, 32);
                    image->sprite_size = 1.2f + 0.1f * (10.0f * mgRnd());
                    character->SetMotion((char *) at_1700__2__DATA, 0);
                } else {
                    image->SethitEffect(position, direction.f, 10.0f, 30.0f, 0.4f, -0.1f, 20, (int) mgDistVector(position, previous));
                    image->sprite_size = 0.6f + 0.1f * (10.0f * mgRnd());
                    character->SetMotion((char *) at_1380__2__DATA, 0);
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
                rotation[1] = mgAngleInterpolate(rotation[1], atan2f(forward[0], forward[2]), 0.034906585f, 0);
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
                CCharacter2 *character = scene->GetCharacter(fish_inf[fish].chara_no);
                textures->DeleteBlock(character->texture_block);
                strcpy(fish_game_data[RaceInfo.rank[fish] - 1].name, (char *) at_1701__DATA);
                char *name = game_data[fish]->data.fish.name;
                strncpy(fish_game_data[RaceInfo.rank[fish] - 1].name, name, strlen(name));
                fish_game_data[RaceInfo.rank[fish] - 1].time = 20.0f * RaceInfo.goal_time[fish];
                fish_game_data[RaceInfo.rank[fish] - 1].fish_no = fish_inf[fish].fish_no;
                fish_game_data[RaceInfo.rank[fish] - 1].race_class = race_rank[0];
                sndSeStop(gyore_snd_id, fish + 3, fish + 3);
                sndSeStop(gyore_snd_id, fish + 9, fish + 9);
            }
            for (int place = 0; place < 6; place++) {
                printf((char *) at_1702__DATA, place + 1, fish_game_data[place].name);
            }
            sndSeStop(gyore_snd_id, 2, 0);
            textures->DeleteBlock(WindowTexb);
            textures->DeleteBlock(EffectTexb);
            mgSetAmbient(old_ambient);
            scene->SetActive(SCENE_DATA_CHARA, 0);
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
    CScene      *scene = info->scene;
    CCharacter2 *hero = scene->GetCharacter(fish_inf[hero_no].chara_no);
    float        hero_pos[4];
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
    int              j = 0;
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
#ifdef NONMATCHING
#pragma global_optimizer on

int sgSysDrawGyoRace(SubGameInfo *info) {
    extern char        at_1384__2[];
    extern int         lap_inf_1798[2][5];
    extern int         lap_inf2_1799[5];
    mgRect<int>        sp80;
    mgRect<int>        sp90;
    grRACE_PROGRESS    spA0;
    mgRect<int>        spC0;
    mgRect<int>        spD0;
    mgRect<int>        spE0;
    mgRect<int>        spF0;
    mgRect<int>        sp100;
    mgRect<int>        sp110;
    mgRect<int>        sp120;
    mgRect<int>        sp130;
    mgRect<int>        sp140;
    mgRect<int>        sp150;
    mgRect<int>        sp160;
    mgRect<int>        sp170;
    mgRect<int>        sp180;
    mgRect<int>        sp190;
    mgRect<int>        sp1A0;
    mgRect<int>        sp1B0;
    mgRect<int>        sp1C0;
    mgRect<int>        sp1D0;
    mgRect<int>        sp1E0;
    mgRect<int>        sp1F0;
    mgRect<int>        sp200;
    mgRect<int>        sp210;
    mgRect<int>        sp220;
    mgRect<int>        sp230;
    mgRect<int>        sp240;
    mgRect<int>        sp250;
    mgRect<int>        sp260;
    mgRect<int>        sp270;
    mgRect<int>        sp280;
    mgRect<int>        sp290;
    mgRect<int>        sp2A0;
    mgRect<int>        sp2B0;
    mgRect<int>        sp2C0;
    mgRect<int>        sp2D0;
    mgRect<int>        sp2E0;
    mgRect<int>        sp2F0;
    mgRect<int>        sp300;
    mgRect<int>        sp310;
    mgRect<int>        sp320;
    mgRect<int>        sp330;
    mgRect<int>        sp340;
    mgRect<int>        sp350;
    mgRect<int>        sp360;
    mgRect<int>        sp370;
    mgRect<int>        sp380;
    mgRect<int>        sp390;
    mgRect<int>        sp3A0;
    mgRect<int>        sp3B0;
    mgRect<int>        sp3C0;
    mgRect<int>        sp3D0;
    mgRect<int>        sp3E0;
    mgRect<int>        sp3F0;
    mgRect<int>        sp400;
    mgRect<int>        sp410;
    mgRect<int>        sp420;
    mgRect<int>        sp430;
    mgRect<int>        sp440;
    grRACE_PROGRESS    sp450;
    mgRect<int>        sp470;
    mgRect<int>        sp480;
    mgRect<int>        sp490;
    mgRect<int>        sp4A0;
    mgRect<int>        sp4B0;
    mgRect<int>        sp4C0;
    mgRect<int>        sp4D0;
    mgRect<int>        sp4E0;
    CScene            *scene;
    float              lap_frames;
    float              lap_seconds_frames;
    float              total_frames;
    float              total_seconds_frames;
    float              bar_done;
    int                total_centi_tens;
    int                lap_second_tens;
    int                lap_centi_tens;
    int                total_minutes;
    int                total_seconds;
    int                total_centi;
    int                total_second_tens;
    int                mode;
    int                var_16;
    int                row_index;
    int                var_17;
    int                var_18;
    int                var_19;
    int               *lap;
    mgCTextureManager *textures = &mgTexManager;
    scene = info->scene;
    textures->ReloadTexture(GetSystemMessage()->texture_block, (sceVif1Packet *) 0);
    Jikkyou(info);
    gyo_mes->Step();
    gyo_mes->DrawMesWin();
    win_alpha -= 0.5f;
    if (win_alpha < 0.0f) {
        win_alpha = 0.0f;
    }
    textures->ReloadTexture(WindowTexb, (sceVif1Packet *) 0);
    wind_tex = textures->GetTexture(at_1384__2, -1);
    sp80.Set(0x15, 0x13, 0x1D6, 0x54);
    sp90.Set(0, 0, 0x1D6, 0x54);
    PrimQuad(wind_tex, sp80, sp90, 0x80, 0x80, 0x80, 0x80);
    var_16 = 0;
    do {
        grGetFishProgress(&RaceInfo, var_16, race_cnt, &spA0);
        float limit = 16.0f;
        if (!(spA0.pos <= limit)) {
            spA0.pos = limit;
        }
        bar_done = 326.0f * (spA0.pos / 16.0f);
        float bar_y = 35.0f + 10.0f * (float) RaceInfo.fish[var_16].lane;
        DrawMenuFillBox(41.0f + bar_done, bar_y, 326.0f - bar_done, 2.0f, 0x4A, 0x70, 0xD9, 0x8B);
        float filled = 326.0f * (spA0.pos / 16.0f);
        DrawMenuFillBox(41.0f, (float) ((RaceInfo.fish[var_16].lane * 0xA) + 0x23), filled, 2.0f, 0x54, 0xE5, 0x8B, 0x29);
        spC0.Set((int) (31.0f + (float) (int) (326.0f * (spA0.pos / 16.0f))), (RaceInfo.fish[var_16].lane * 0xA) + 0x1C, 0x12, 0xC);
        if ((var_16 == hero_no) && (OmakeFlag == 0)) {
            spD0.Set(0x1EE, 0xC, 0x12, 0xC);
            if ((u_char) spA0.state != 3) {
                PrimQuad(wind_tex, spC0, spD0, 0x80, 0x80, 0x80, 0x80);
            } else {
                PrimQuad(wind_tex, spC0, spD0, 0x80, 0x80, 0x80, 0);
            }
        } else {
            spE0.Set(0x1EE, 0, 0x12, 0xC);
            if ((u_char) spA0.state != 3) {
                PrimQuad(wind_tex, spC0, spE0, 0x80, 0x80, 0x80, 0x80);
            } else {
                PrimQuad(wind_tex, spC0, spE0, 0x80, 0x80, 0x80, 0);
            }
        }
        var_16 += 1;
    } while (var_16 < 6);
    mode = race_mode;
    row_index = 0;
    if ((mode == 0) || (mode == 1)) {
        var_17 = 0;
        var_18 = 0;
        do {
            spF0.Set(var_18 + 0x1A2, var_17 + 0x41, 0xC, 0xC);
            sp100.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, spF0, sp100, 0x80, 0x80, 0x80, 0x80);
            sp110.Set(var_18 + 0x1B0, var_17 + 0x41, 0xC, 0xC);
            sp120.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, sp110, sp120, 0x80, 0x80, 0x80, 0x80);
            sp130.Set(var_18 + 0x1BA, var_17 + 0x41, 0xC, 0xC);
            sp140.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, sp130, sp140, 0x80, 0x80, 0x80, 0x80);
            sp150.Set(var_18 + 0x1C9, var_17 + 0x41, 0xC, 0xC);
            sp160.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, sp150, sp160, 0x80, 0x80, 0x80, 0x80);
            sp170.Set(var_18 + 0x1D3, var_17 + 0x41, 0xC, 0xC);
            sp180.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, sp170, sp180, 0x80, 0x80, 0x80, 0x80);
            row_index += 1;
            var_17 += 0x10;
            var_18 += 2;
        } while (row_index < 2);
        sp190.Set(0x1CB, 0x1B, 0x18, 0x20);
        sp1A0.Set(0xA8, 0x54, 0x18, 0x20);
        PrimQuad(wind_tex, sp190, sp1A0, 0x80, 0x80, 0x80, 0x80);
        sp1B0.Set(0x176, 0x2B, 0x10, 0xE);
        sp1C0.Set(0x160, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp1B0, sp1C0, 0x80, 0x80, 0x80, 0x80);
        sp1D0.Set(0x189, 0x2B, 0x10, 0xE);
        sp1E0.Set(0x160, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp1D0, sp1E0, 0x80, 0x80, 0x80, 0x80);
        sp1F0.Set(0x197, 0x2B, 0x10, 0xE);
        sp200.Set(0x160, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp1F0, sp200, 0x80, 0x80, 0x80, 0x80);
        sp210.Set(0x1AB, 0x2B, 0x10, 0xE);
        sp220.Set(0x160, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp210, sp220, 0x80, 0x80, 0x80, 0x80);
        sp230.Set(0x1B9, 0x2B, 0x10, 0xE);
        sp240.Set(0x160, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp230, sp240, 0x80, 0x80, 0x80, 0x80);
    } else {
        lap_frames = fish_inf[hero_no].lap_time[var_19 = (int) fish_inf[hero_no].lap];
        var_16 = (int) (lap_frames / 3600.0f);
        float minute_frames = 3600.0f;
        lap_seconds_frames = lap_frames - minute_frames * (float) var_16;
        float second_base = 60.0f;
        var_17 = (int) (lap_seconds_frames / second_base);
        float second_frames = 60.0f;
        float centi = 100.0f;
        var_18 = (int) (centi * (lap_seconds_frames - second_frames * (float) var_17) / second_frames);
        lap_inf_1798[var_19][0] = var_16;
        lap_second_tens = (int) (0.1f * (float) var_17);
        lap_inf_1798[var_19][1] = lap_second_tens;
        lap_inf_1798[var_19][2] = var_17 - (lap_second_tens * 0xA);
        lap_centi_tens = (lap_inf_1798[var_19][3] = (int) (0.1f * (float) var_18));
        lap_inf_1798[var_19][4] = var_18 - lap_centi_tens * 10;
        var_16 = 0;
        int lap_y = 0;
        int lap_x = 0;
        var_19 = 0;
        do {
            if ((int) fish_inf[hero_no].lap < var_16) {
                sp250.Set(lap_x + 0x1A2, lap_y + 0x41, 0xC, 0xC);
                sp260.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp250, sp260, 0x80, 0x80, 0x80, 0x80);
                sp270.Set(lap_x + 0x1B0, lap_y + 0x41, 0xC, 0xC);
                sp280.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp270, sp280, 0x80, 0x80, 0x80, 0x80);
                sp290.Set(lap_x + 0x1BA, lap_y + 0x41, 0xC, 0xC);
                sp2A0.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp290, sp2A0, 0x80, 0x80, 0x80, 0x80);
                sp2B0.Set(lap_x + 0x1C9, lap_y + 0x41, 0xC, 0xC);
                sp2C0.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp2B0, sp2C0, 0x80, 0x80, 0x80, 0x80);
                sp2D0.Set(lap_x + 0x1D3, lap_y + 0x41, 0xC, 0xC);
                sp2E0.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp2D0, sp2E0, 0x80, 0x80, 0x80, 0x80);
            } else {
                sp2F0.Set(lap_x + 0x1A2, lap_y + 0x41, 0xC, 0xC);
                lap = lap_inf_1798[var_19];
                sp300.Set((lap[0] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp2F0, sp300, 0x80, 0x80, 0x80, 0x80);
                sp310.Set(lap_x + 0x1B0, lap_y + 0x41, 0xC, 0xC);
                sp320.Set((lap[1] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp310, sp320, 0x80, 0x80, 0x80, 0x80);
                sp330.Set(lap_x + 0x1BA, lap_y + 0x41, 0xC, 0xC);
                sp340.Set((lap[2] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp330, sp340, 0x80, 0x80, 0x80, 0x80);
                sp350.Set(lap_x + 0x1C9, lap_y + 0x41, 0xC, 0xC);
                sp360.Set((lap[3] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp350, sp360, 0x80, 0x80, 0x80, 0x80);
                sp370.Set(lap_x + 0x1D3, lap_y + 0x41, 0xC, 0xC);
                sp380.Set((lap[4] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp370, sp380, 0x80, 0x80, 0x80, 0x80);
            }
            var_16 += 1;
            lap_y += 0x10;
            lap_x += 2;
            var_19++;
        } while (var_16 < 2);
        total_frames = fish_inf[hero_no].time;
        total_minutes = (int) (total_frames / 3600.0f);
        total_seconds_frames = total_frames - (3600.0f * (float) total_minutes);
        total_seconds = (int) (total_seconds_frames / 60.0f);
        total_centi = (int) ((100.0f * (total_seconds_frames - (60.0f * (float) total_seconds))) / 60.0f);
        lap_inf2_1799[0] = total_minutes;
        total_second_tens = (int) (0.1f * (float) total_seconds);
        lap_inf2_1799[1] = total_second_tens;
        lap_inf2_1799[2] = (int) (total_seconds - (total_second_tens * 0xA));
        total_centi_tens = (int) (0.1f * (float) total_centi);
        lap_inf2_1799[3] = total_centi_tens;
        lap_inf2_1799[4] = (int) (total_centi - (total_centi_tens * 0xA));
        sp390.Set(0x176, 0x2B, 0x10, 0xE);
        sp3A0.Set((lap_inf2_1799[0] * 0x10) + 0xC0, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp390, sp3A0, 0x80, 0x80, 0x80, 0x80);
        sp3B0.Set(0x189, 0x2B, 0x10, 0xE);
        sp3C0.Set((lap_inf2_1799[1] * 0x10) + 0xC0, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp3B0, sp3C0, 0x80, 0x80, 0x80, 0x80);
        sp3D0.Set(0x197, 0x2B, 0x10, 0xE);
        sp3E0.Set((lap_inf2_1799[2] * 0x10) + 0xC0, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp3D0, sp3E0, 0x80, 0x80, 0x80, 0x80);
        sp3F0.Set(0x1AB, 0x2B, 0x10, 0xE);
        sp400.Set((lap_inf2_1799[3] * 0x10) + 0xC0, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp3F0, sp400, 0x80, 0x80, 0x80, 0x80);
        sp410.Set(0x1B9, 0x2B, 0x10, 0xE);
        sp420.Set((lap_inf2_1799[4] * 0x10) + 0xC0, 0x54, 0x10, 0xE);
        PrimQuad(wind_tex, sp410, sp420, 0x80, 0x80, 0x80, 0x80);
        sp430.Set(0x1CB, 0x1B, 0x18, 0x20);
        sp440.Set(fish_inf[hero_no].rank * 0x18, 0x54, 0x18, 0x20);
        PrimQuad(wind_tex, sp430, sp440, 0x80, 0x80, 0x80, 0x80);
    }
    scene->GetCharacter(fish_inf[hero_no].chara_no);
    grGetFishProgress(&RaceInfo, hero_no, race_cnt, &sp450);
    if ((u_char) sp450.state == 3) {
        sp470.Set(0x178, 0x1C, 0xC, 0xC);
        sp480.Set(0xD8, 0x62, 0xC, 0xC);
        PrimQuad(wind_tex, sp470, sp480, 0x80, 0x80, 0x80, 0x80);
        sp490.Set(0x187, 0x1C, 0xC, 0xC);
        sp4A0.Set(0xD8, 0x62, 0xC, 0xC);
        PrimQuad(wind_tex, sp490, sp4A0, 0x80, 0x80, 0x80, 0x80);
    } else {
        sp4B0.Set(0x178, 0x1C, 0xC, 0xC);
        sp4C0.Set(((int) fish_inf[hero_no].lap * 0xC) + 0xC0, 0x62, 0xC, 0xC);
        PrimQuad(wind_tex, sp4B0, sp4C0, 0x80, 0x80, 0x80, 0x80);
        sp4D0.Set(0x187, 0x1C, 0xC, 0xC);
        sp4E0.Set(0xD8, 0x62, 0xC, 0xC);
        PrimQuad(wind_tex, sp4D0, sp4E0, 0x80, 0x80, 0x80, 0x80);
    }
    return 0;
}

#pragma global_optimizer reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgSysDrawGyoRace__FP11SubGameInfo);
#endif
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

                if ((u_char) fish.state == 2) {
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

// Static initialiser (.init)

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
#endif
mgCMemory        BuffTextureData;
static mgCMemory BuffWorkData;
mgCCamera        camera0(8.0f);
#ifndef NONMATCHING
INCLUDE_BSS(fish_inf, 0x110);
INCLUDE_BSS(at_1765__2, 0x10);
INCLUDE_BSS(at_1775, 0x10);
INCLUDE_BSS(at_1776, 0x10);
INCLUDE_BSS(lap_inf_1798, 0x30);
INCLUDE_BSS(lap_inf2_1799, 0x50);
#endif
