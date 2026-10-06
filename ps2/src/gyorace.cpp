#define sceVu0ApplyMatrix sceVu0ApplyMatrixSdk
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
#include "nd_meswin.hpp"
#include "gyoracesim.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mainloop.hpp"
#include "dataread.hpp"
#include "snd_seseq.hpp"
#include "snd_mngr.hpp"
#include <cstdio>
#include <cmath>

#undef sceVu0ApplyMatrix
extern "C" void sceVu0ApplyMatrix(float *, float *, float *);

union RaceVector {
    float f[4];
    int v[4];
    u_long128 q;
};
extern RaceVector at_1765__2;
extern RaceVector at_1766__3;
extern RaceVector at_1775;
extern RaceVector at_1776;
extern float ras_off_1762;
extern signed char init_1763;

struct CHitEffectImage;
struct RaceFrameTexture {
    u_char pad_00[0x3C];
    u_char low : 2;
    u_char swizzled : 1;
    u_char high : 5;
    u_char pad_3D[0x33];
};

extern int EffectTexb;
extern u_char water_cam;
extern CHitEffectImage *battle_effect;
extern "C" void __ct__11mgCDrawPrimFv(void *);
extern "C" void __ct__10mgCTextureFv(void *);
extern mgCMemory BuffTextureData;
extern mgCMemory BuffWorkData;
#ifndef NONMATCHING
extern unsigned int gyore_snd_id;
extern int hero_no;
extern int cam_no;
extern int old_cam_no;
extern float win_alpha;
extern int rank_count;
extern int mes_count;
extern int jyunkai_flg;
extern int fish_rank[6];
extern int old_fish_rank[6];
#endif

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
static u_char water_cam;
static int cam_no;
static float win_alpha;
static int effect_cnt;
static int mes_count;
static int jyunkai_flg;
static int hantei_flg;
static int goal_cnt;
static CHitEffectImage *battle_effect;
static BattleEffectPrim (*battle_EffectPara)[32];
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
GYORACE_FISH_INF fish_inf[6];
static int old_cam_no = -1;
#endif

// Code (.text)
#ifdef NONMATCHING
int sgInitGyoRace(SubGameInfo *info) {
    extern short *GetSystemMesBuffer();
    extern mgCTexture *TEX_SystemEffect1;
    extern const unsigned char at_1373__3__DATA[];
    extern const unsigned char at_1374__2__DATA[];
    extern const unsigned char at_1375__2__DATA[];
    extern const unsigned char at_1376__2__DATA[];
    extern const unsigned char at_1377__4__DATA[];
    extern const unsigned char at_1378__3__DATA[];
    extern const unsigned char at_1379__3__DATA[];
    extern const unsigned char at_1380__2__DATA[];
    extern const unsigned char at_1381__DATA[];
    extern const unsigned char at_1382__2__DATA[];
    extern const unsigned char at_1383__3__DATA[];
    extern const unsigned char at_1384__2__DATA[];
    extern RaceVector at_1027__4;
    extern RaceVector at_1028__9;
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
    sndInitPort(5);
    LoadFile2((char *)at_1373__3__DATA, buffer, &size, 0);
    gyore_snd_id = sndLoadSound(5, (unsigned int *)buffer, memory);
    ChangeDir((char *)at_1374__2__DATA);
    CGyoraceFishData fish_data;
    fish_data.LoadData(memory, buffer);
    u_long128 *texture_buffer = BuffTextureData.stack;
    char path[0x100];
    sprintf(path, (char *)at_1375__2__DATA, LanguageCode);
    LoadFile2(path, texture_buffer, &size, 0);
    gyo_mes = new(memory->Alloc(0x298)) ClsMes;
    gyo_mes->SetBuff((short *)texture_buffer);
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
    battle_EffectPara = new(memory->Alloc(0x3C02)) BattleEffectPrim[96][32];
    battle_effect = new(memory->Alloc(0x242)) CHitEffectImage[96];
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
    int state_offset = 0;
    int item_offset = 0;
    do {
        GYORACE_FISH_INF *state = (GYORACE_FISH_INF *)((unsigned char *)fish_inf + state_offset);
        state->fish_no = -1;
        int &number_slot = state->fish_no;
        if (OmakeFlag != 0) {
            CGameDataUsed *race_fish = GetOmakeGyoracer2(fish);
            CGameDataUsed **item = (CGameDataUsed **)((unsigned char *)game_data + item_offset);
            *item = race_fish;
            if (*item == NULL) {
                chosen[chosen_num] = race_rank[1] * 18 + (int)(17.0f * mgRnd());
                do {
                    int old;
                    for (old = 0; old < chosen_num; old++) {
                        if (chosen[old] == chosen[chosen_num]) break;
                    }
                    if (old == chosen_num) break;
                    chosen[chosen_num] = race_rank[1] * 18 + (int)(17.0f * mgRnd());
                } while (1);
                *item = fish_data.GetRaceFish(race_rank[0], chosen[chosen_num]);
                chosen_num++;
            }
        } else if (fish == 0) {
            *(CGameDataUsed **)((unsigned char *)game_data + item_offset) = GetGyoRaceFish();
        } else {
            chosen[chosen_num] = race_rank[1] * 18 + (int)(17.0f * mgRnd());
            do {
                int old;
                for (old = 0; old < chosen_num; old++) {
                    if (chosen[old] == chosen[chosen_num]) break;
                }
                if (old == chosen_num) break;
                chosen[chosen_num] = race_rank[1] * 18 + (int)(17.0f * mgRnd());
            } while (1);
            int number = chosen[chosen_num];
            CGameDataUsed *race_fish = fish_data.GetRaceFish(race_rank[0], number);
            chosen_num++;
            *(CGameDataUsed **)((unsigned char *)game_data + item_offset) = race_fish;
            number_slot = number;
        }
        fish++;
        state_offset += sizeof(GYORACE_FISH_INF);
        item_offset += sizeof(CGameDataUsed *);
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
        if (lane >= 6) lane = 5;
    }
    memset(&RaceInfo, 0, sizeof(RaceInfo));
    RaceInfo.seed = 0;
    printf((char *)at_1376__2__DATA, RaceInfo.seed);
    RaceInfo.fish_num = 6;
    RaceInfo.step_max = 1000;
    RaceInfo.after_goal_step = 20;
    fish = 0;
    int progress_offset = 0;
    int param_offset = 0;
    int info_offset = 0;
    do {
        ((grRACE_INFO *)((unsigned char *)&RaceInfo + progress_offset))->progress[0] = new(memory->Alloc(0x5DE)) grRACE_PROGRESS[1000];
        if (OmakeFlag == 0 && fish == 0) {
            ((grRACE_INFO *)((unsigned char *)&RaceInfo + param_offset))->fish[0].tactics = GetGyoRaceAquariumNo();
        } else if (OmakeFlag != 0) {
            ((grRACE_INFO *)((unsigned char *)&RaceInfo + param_offset))->fish[0].tactics = GetOmakeGyoracerTactics(fish);
        } else {
            ((grRACE_INFO *)((unsigned char *)&RaceInfo + param_offset))->fish[0].tactics = (int)(6.0f * mgRnd());
            if (((grRACE_INFO *)((unsigned char *)&RaceInfo + param_offset))->fish[0].tactics >= 6) ((grRACE_INFO *)((unsigned char *)&RaceInfo + param_offset))->fish[0].tactics = 5;
        }
        CGameDataUsed **item = (CGameDataUsed **)((unsigned char *)game_data + progress_offset);
        grRACE_INFO *entry = (grRACE_INFO *)((unsigned char *)&RaceInfo + param_offset);
        char *name = entry->fish[0].name;
        strcpy(name, (*item)->data.fish.name);
        CGameDataUsed *fish_item = *item;
        entry->fish[0].bonus_type = fish_item->data.fish.unk_16;
        entry->fish[0].power = fish_item->data.fish.param[4];
        BREEDFISH_USED *data = &fish_item->data.fish;
        if (OmakeFlag == 0 && fish == 0) {
            if (race_rank[1] == 0) (*(unsigned short *)&data->fatigue)++;
            fish_item = *item;
            BREEDFISH_USED *stamina_pointer = &fish_item->data.fish;
            BREEDFISH_USED *const &stamina_data = stamina_pointer;
            int fatigue = (unsigned short)fish_item->data.fish.fatigue;
            entry->fish[0].stamina = (int)((float)stamina_data->param[3] - (0.1f * (float)(fatigue - 1) * (float)fish_item->data.fish.param[3]));
            printf((char *)at_1377__4__DATA, fatigue);
        } else {
            entry->fish[0].stamina = data->param[3];
        }
        fish_item = *item;
        entry->fish[0].speed[0] = fish_item->data.fish.param[0];
        entry->fish[0].speed[1] = fish_item->data.fish.param[1];
        entry->fish[0].speed[2] = fish_item->data.fish.param[2];
        entry->fish[0].affinity = fish_item->data.fish.unk_3a;
        entry->fish[0].fish_no = fish_item->item_no;
        entry->fish[0].lane = lane;
        ((GYORACE_FISH_INF *)((unsigned char *)fish_inf + info_offset))->lane = lane;
        lane++;
        if (lane >= 6) lane = 0;
        printf((char *)at_1378__3__DATA, name, entry->fish[0].tactics);
        fish++;
        progress_offset += sizeof(grRACE_PROGRESS *);
        param_offset += sizeof(grFISH_PARAM);
        info_offset += sizeof(GYORACE_FISH_INF);
    } while (fish < 6);
    time_max = grGyoRaceSimulate(&RaceInfo);
    for (fish = 0; fish < 6; fish++) {
        scene->GetCharacter(fish_inf[fish].chara_no);
        grGetFishProgress(&RaceInfo, fish, race_cnt, &old_prog[fish]);
    }
    CharaTexb = info->texb;
    fish = 0;
    progress_offset = 0;
    int game_offset = 0;
    info_offset = 0;
    do {
        grRACE_PROGRESS *progress = (grRACE_PROGRESS *)((unsigned char *)old_prog + progress_offset);
        grGetFishProgress(&RaceInfo, fish, 0.0f, progress);
        textures = &mgTexManager;
        textures->DeleteBlock(CharaTexb);
        CGameDataUsed **item = (CGameDataUsed **)((unsigned char *)game_data + game_offset);
        int kind = (*item)->item_no - 0x140;
        if (kind < 0) kind = 17;
        if (LoadFile2(fish_name[kind], buffer, NULL, 0) == 0) return 0;
        GYORACE_FISH_INF *state = (GYORACE_FISH_INF *)((unsigned char *)fish_inf + info_offset);
        state->chara_no = fish + 0x40;
        state->lap = 0;
        state->unk_14 = 0;
        state->lap_start = 0.0f;
        state->time = 0.0f;
        state->rank = 1;
        int *character_no = &state->chara_no;
        scene->LoadChara(state->chara_no, (unsigned int *)buffer, (char *)at_1379__3__DATA, memory, memory, memory, CharaTexb, 0);
        scene->SetActive(1, *character_no);
        scene->SetCharaTexb(*character_no, CharaTexb);
        CCharacter2 *character = scene->GetCharacter(*character_no);
        RaceVector position = at_1027__4;
        position.f[0] = 190.0f + 15.0f * (float)progress->lane;
        position.f[2] = character->body_height / 4.0f;
        RaceVector rotation = at_1028__9;
        CGameDataUsed *fish_item = *item;
        BREEDFISH_USED *data_pointer = &fish_item->data.fish;
        BREEDFISH_USED *const &data = data_pointer;
        CDataBreedFish *breed = GetBreedFishInfoData(fish_item->item_no);
        float scale = (float)data->size / breed->size;
        if (!(scale <= 2.0f)) scale = 2.0f;
        character->SetScale(scale, scale, scale);
        character->SetRotation(rotation.f);
        character->SetPosition(position.f);
        character->SetMotion((char *)at_1380__2__DATA, 0);
        character->SetStep(0.3f);
        FishIMGReplace(buffer, character, (*item)->item_no, &(*item)->data.fish);
        fish++;
        progress_offset += sizeof(grRACE_PROGRESS);
        game_offset += sizeof(CGameDataUsed *);
        info_offset += sizeof(GYORACE_FISH_INF);
        CharaTexb++;
    } while (fish < 6);
    if (texture_buffer != NULL) {
            WindowTexb = CharaTexb;
            char image_path[0x20];
            if (LanguageCode > 0) sprintf(image_path, (char *)at_1381__DATA, LanguageCode);
            else sprintf(image_path, (char *)at_1382__2__DATA, LanguageCode);
            textures->DeleteBlock(WindowTexb);
            LoadFile(image_path, texture_buffer, &size);
            textures->EnterIMGFile((unsigned char *)texture_buffer, WindowTexb, &BuffTextureData, NULL);
            EffectTex2 = textures->GetTexture((char *)at_1383__3__DATA, -1);
            EffectTexb = WindowTexb + 1;
            textures->DeleteBlock(EffectTexb);
            textures->EnterIMGFile((unsigned char *)texture_buffer, EffectTexb, &BuffTextureData, NULL);
            TEX_SystemEffect1 = EffectTex = textures->GetTexture((char *)at_1384__2__DATA, -1);
            ChangeDir(NULL);
    }
    camera_id = scene->AssignCamera(-1, &camera0, NULL);
    scene->before_camera = scene->active_camera;
    scene->active_camera = camera_id;
    camera0.SetPos(225.0f, 38.0f, 168.0f);
    camera0.SetNextPos(225.0f, 38.0f, 168.0f);
    camera0.SetSpeed(0.0f, 0.0f);
    camera0.SetRef(222.0f, 0.0f, 0.0f);
    camera0.SetNextRef(222.0f, 0.0f, 0.0f);
    scene->ResetActive(1, 0);
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
    extern RaceVector at_1481__4;
    extern RaceVector at_1524__2;
    extern RaceVector at_1547;
    extern RaceVector at_1548;
    CScene *scene = info->scene;
    switch ((unsigned int)race_mode) {
    case 0:
        *(int *)((u_char *)scene + 0x2E54) = camera_id;
        camera0.SetPos(225.0f, 38.0f, 168.0f);
        camera0.SetNextPos(225.0f, 38.0f, 168.0f);
        camera0.SetRef(222.0f, 0.0f, 0.0f);
        camera0.SetNextRef(222.0f, 0.0f, 0.0f);
        camera0.SetSpeed(0.0f, 0.0f);
        for (int fish = 0; fish < 6; fish++) {
            CCharacter2 *character = scene->GetCharacter(fish_inf[fish].chara_no);
            character->SetMotion((char *)at_1380__2__DATA, 0);
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
        *(int *)((u_char *)scene + 0x2E54) = camera_id;
        camera0.SetPos(225.0f, 38.0f, 168.0f);
        camera0.SetNextPos(225.0f, 38.0f, 168.0f);
        camera0.SetRef(222.0f, 0.0f, 0.0f);
        camera0.SetNextRef(222.0f, 0.0f, 0.0f);
        camera0.SetSpeed(0.0f, 0.0f);
        mgCFrame *gate = scene->GetMap(scene->active_map)->GetParts((char *)at_1696__2__DATA)->SearchPiece((char *)at_1697__3__DATA)->frame;
        mgCFrame *left = gate->SearchFrame((char *)at_1698__3__DATA);
        left->SetRotType(2);
        float rotation[4];
        left->GetRotation(rotation);
        rotation[1] += 0.20943952f;
        if (!(rotation[1] <= 1.5707964f)) rotation[1] = 1.5707964f;
        left->SetRotation(rotation[0], rotation[1], rotation[2]);
        mgCFrame *right = gate->SearchFrame((char *)at_1699__3__DATA);
        right->SetRotType(2);
        right->GetRotation(rotation);
        rotation[1] -= 0.20943952f;
        if (rotation[1] < -1.5707964f) rotation[1] = -1.5707964f;
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
        for (fish = 0; fish < 6; fish++) {
            scene->GetCharacter(fish_inf[fish].chara_no);
            grGetFishProgress(&RaceInfo, fish, race_cnt, &old_prog[fish]);
        }
        race_cnt += 0.1f;
        for (fish = 0; fish < 6; fish++) {
            grRACE_PROGRESS progress;
            grGetFishProgress(&RaceInfo, fish, race_cnt, &progress);
            int rank = 1;
            if ((unsigned char)progress.state != 3) {
                for (int other = 0; other < 6; other++) {
                    if (other != fish) {
                        grRACE_PROGRESS other_progress;
                        grGetFishProgress(&RaceInfo, other, race_cnt, &other_progress);
                        if ((unsigned char)other_progress.state != 3) {
                            if (progress.pos < other_progress.pos) rank++;
                        } else rank++;
                    }
                }
                fish_inf[fish].rank = rank;
                fish_rank[rank - 1] = fish;
            }
        }
        int unfinished = 6;
        if (OmakeFlag != 0) hero_no = fish_rank[0];
        for (fish = 0; fish < 6; fish++) {
            GYORACE_FISH_INF *state = &fish_inf[fish];
            CCharacter2 *character = scene->GetCharacter(state->chara_no);
            grRACE_PROGRESS progress;
            grGetFishProgress(&RaceInfo, fish, race_cnt, &progress);
            if ((unsigned char)progress.state == 3) unfinished--;
            if (!(progress.pos < 8.0f)) {
                unsigned int lap = (unsigned int)(progress.pos / 8.0f);
                if (state->lap < lap) {
                    state->lap = lap;
                    if ((int)state->lap >= 2) state->lap = 1;
                    else {
                        state->unk_14 = 1;
                        GetSaveData();
                        state->lap_start = race_cnt;
                    }
                }
            }
            GetSaveData();
            if (fish == hero_no) {
                if ((unsigned char)progress.state != 3) {
                    state->time = 20.0f * race_cnt;
                    state->lap_time[fish_inf[hero_no].lap] = state->time - 20.0f * state->lap_start;
                } else if ((unsigned char)progress.state == 3) {
                    state->time = 20.0f * RaceInfo.goal_time[fish];
                    float time = state->lap_time[0];
                    float minutes = 3600.0f * (float)(int)(time / 3600.0f);
                    time -= minutes;
                    float seconds = 60.0f * (float)(int)(time / 60.0f);
                    state->lap_time[1] = state->time - ((60.0f * (float)(int)((100.0f * (time - seconds)) / 60.0f)) / 100.0f + (minutes + seconds));
                }
            }
            float distance = progress.pos;
            if (!(distance < 8.0f)) distance -= 8.0f * (float)((unsigned int)distance >> 3);
            float position[4];
            float matrix[4][4];
            position[1] = 0.0f;
            if (distance >= 0.0 && distance < 1.0) {
                position[2] = -345.0f * distance;
                position[0] = 190.0f + 15.0f * progress.lane_pos;
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
                sceVu0ApplyMatrix(position, (float *)matrix, position);
                position[2] -= 345.0f;
            }
            if (!(distance < 5.0f) && distance < 7.0f) {
                position[0] = -190.0f - 15.0f * progress.lane_pos;
                position[2] = 0.0f;
                sceVu0UnitMatrix(matrix);
                sceVu0RotMatrixY(matrix, matrix, 1.5707964f * (distance - 5.0f));
                sceVu0ApplyMatrix(position, (float *)matrix, position);
                position[2] += 345.0f;
            }
            position[1] = -15.0f;
            float rotation[4];
            float previous[4];
            float hit_dir[4];
            character->GetRotation(rotation);
            character->GetPosition(previous);
            RaceVector direction = at_1481__4;
            CHitEffectImage *image = &battle_effect[effect_cnt];
            sceVu0SubVector(hit_dir, previous, position);
            sceVu0Normalize(hit_dir, hit_dir);
            direction.f[0] = hit_dir[0];
            direction.f[2] = hit_dir[2];
            if ((unsigned char)progress.state == 2) {
                image->SethitEffect(position, direction.f, 150.0f, 30.0f, 0.4f, -0.05f, 20, 32);
                image->sprite_size = 1.2f + 0.1f * (10.0f * mgRnd());
                character->SetMotion((char *)at_1700__2__DATA, 0);
            } else {
                image->SethitEffect(position, direction.f, 10.0f, 30.0f, 0.4f, -0.1f, 20, (int)mgDistVector(position, previous));
                image->sprite_size = 0.6f + 0.1f * (10.0f * mgRnd());
                character->SetMotion((char *)at_1380__2__DATA, 0);
            }
            image->kind = 0;
            union { mgRect<int> rect; };
            rect.Set(425, 85, 42, 42);
            RaceVector coords;
            coords.q = *(u_long128 *)&rect;
            image->tex_rect.left = coords.v[0];
            image->tex_rect.top = coords.v[1];
            image->tex_rect.right = coords.v[2];
            image->tex_rect.bottom = coords.v[3];
            effect_cnt++;
            if (effect_cnt >= 96) effect_cnt = 0;
            CMap *map = scene->GetMap(scene->active_map);
            map->water->frame->Shake(position[0], position[2], 0.05f * (4.0f * mgRnd() - 2.0f));
            character->SetPosition(position);
            float delta[4];
            float forward[4];
            sceVu0SubVector(delta, position, previous);
            sceVu0Normalize(forward, delta);
            rotation[1] = mgAngleInterpolate(rotation[1], atan2f(forward[0], forward[2]), 0.034906585f, 0);
            character->SetRotation(rotation);
            character->SetStep(0.3f + mgDistVector(position, previous) / 3.0f);
        }
        if (race_mode == 3) {
            race_proc_cnt--;
            if (race_proc_cnt == 30) scene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
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
        *(int *)((u_char *)scene + 0x2E54) = camera_id;
        camera0.SetPos(270.0f, -40.0f, -10.0f);
        camera0.SetNextPos(270.0f, -40.0f, -10.0f);
        camera0.SetRef(192.0f, 0.0f, 0.0f);
        camera0.SetNextRef(192.0f, 0.0f, 0.0f);
        camera0.SetSpeed(0.0f, 0.0f);
        for (int fish = 0; fish < 6; fish++) {
            CCharacter2 *character = scene->GetCharacter(fish_inf[fish].chara_no);
            grRACE_PROGRESS progress;
            grGetFishProgress(&RaceInfo, fish, RaceInfo.goal_time[fish_rank[0]], &progress);
            float distance = progress.pos;
            if (!(distance < 8.0f)) distance -= 8.0f * (float)((unsigned int)distance >> 3);
            float position[4];
            float matrix[4][4];
            position[1] = 0.0f;
            if (distance >= 0.0 && distance < 1.0) {
                position[2] = -345.0f * distance;
                position[0] = 190.0f + 15.0f * progress.lane_pos;
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
                sceVu0ApplyMatrix(position, (float *)matrix, position);
                position[2] -= 345.0f;
            }
            if (!(distance < 5.0f) && distance < 7.0f) {
                position[0] = -190.0f - 15.0f * progress.lane_pos;
                position[2] = 0.0f;
                sceVu0UnitMatrix(matrix);
                sceVu0RotMatrixY(matrix, matrix, 1.5707964f * (distance - 5.0f));
                sceVu0ApplyMatrix(position, (float *)matrix, position);
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
        *(int *)((u_char *)scene + 0x2E54) = camera_id;
        race_mode = 2;
        race_proc_cnt = 0;
        SetGyoRaceRanking(RaceInfo.rank[hero_no] - 1);
        for (int fish = 0; fish < 6; fish++) {
            GYORACE_FISH_INF *state = &fish_inf[fish];
            CCharacter2 *character = scene->GetCharacter(state->chara_no);
            mgTexManager.DeleteBlock(*(int *)((unsigned char *)character + 0x2E4));
            GYORACE_RESULT *result = &fish_game_data[RaceInfo.rank[fish] - 1];
            strcpy(result->name, (char *)at_1701__DATA);
            char *name = game_data[fish]->data.fish.name;
            strncpy(result->name, name, strlen(name));
            result->time = 20.0f * RaceInfo.goal_time[fish];
            result->fish_no = state->fish_no;
            result->race_class = race_rank[0];
            sndSeStop(gyore_snd_id, fish + 3, fish + 3);
            sndSeStop(gyore_snd_id, fish + 9, fish + 9);
        }
        for (int place = 0; place < 6; place++) printf((char *)at_1702__DATA, place + 1, fish_game_data[place].name);
        sndSeStop(gyore_snd_id, 2, 0);
        mgTexManager.DeleteBlock(WindowTexb);
        mgTexManager.DeleteBlock(EffectTexb);
        mgSetAmbient(old_ambient);
        scene->SetActive(1, 0);
        scene->active_camera = scene->before_camera;
        union { CSceneEventData data; };
        memset(&data, 0, sizeof(data));
        if (OmakeFlag != 0) scene->RunEvent(352, &data);
        else scene->RunEvent(350, &data);
        return 1;
    }
    }
    for (int fish = 0; fish < 6; fish++) scene->GetCharacter(fish_inf[fish].chara_no)->Step();
    RaceVector ambient = at_1547;
    RaceVector camera_pos = at_1548;
    float camera_matrix[4][4];
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
        float camera_pos[4];
        float camera_ref[4];
        float position[4];
        float volume;
        float pan;
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
    int offset = 0;
    do {
        float distance = mgDistVector(hero_pos, (float *)((u_char *)cam_pos + offset));
        if (distance < nearest) {
            nearest = distance;
            cam_no = camera;
        }
        camera++;
        offset += 0x10;
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
        *(int *)((u_char *)scene + 0x2E54) = camera_id;
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
            effect->Step();
            effect->Draw();
        }
        j++;
        offset += 0x60;
    } while (j < 0x60);
    return 0;
}
extern "C" int fptosi(float);
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
    step[1] = (float)((strip_height / 3) << 4);
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
            sceVu0ApplyMatrix(step, (float *)matrix, step);
            RaceVector uv;
            uv = at_1775;
            RaceVector xy;
            xy = at_1776;
            uv = *(RaceVector *)origin;
            xy.v[0] = x16;
            int *xy_y = &xy.v[1];
            *xy_y = y16;
            prim.Data(xy.v);
            uv.v[0] = xy.v[0] + origin[0] - (int)step[0];
            uv.v[1] = *xy_y + origin[1];
            prim.Data(uv.v);
            xy.v[0] = (x + screen_width) << 4;
            *xy_y = (y + strip_height) << 4;
            prim.Data(xy.v);
            uv.v[0] = (int)step[0] + (xy.v[0] + origin[0]);
            uv.v[1] = *xy_y + origin[1];
            prim.Data(uv.v);
            y += strip_height;
            y16 += height16;
        }
        x += screen_width;
        x16 += width16;
    }
    ras_off_1762 += 0.0004363323f;
    if (!(ras_off_1762 <= 6.2831855f)) ras_off_1762 = -6.2831855f;
    prim.EndPrim2();
}

int sgEffectDrawGyoRace(SubGameInfo *info) {
    u_char prim[sizeof(mgCDrawPrim)];
    if (water_cam == 0) {
        return 0;
    }
    __ct__11mgCDrawPrimFv(&prim);
    ((mgCDrawPrim *)prim)->Initialize(0, 0);
    RaceFrameTexture frame;
    __ct__10mgCTextureFv(&frame);
    mgGetFrameBuffer((mgCTexture *)&frame);
    frame.swizzled = 0;
    ((mgCDrawPrim *)prim)->DepthTestEnable(0);
    ((mgCDrawPrim *)prim)->AlphaTestEnable(0);
    ((mgCDrawPrim *)prim)->AlphaBlendEnable(0);
    ((mgCDrawPrim *)prim)->ZMask(-1);
    ((mgCDrawPrim *)prim)->TextureMapEnable(1);
    ((mgCDrawPrim *)prim)->Begin2();
    ((mgCDrawPrim *)prim)->BeginPrim2(6);
    ((mgCDrawPrim *)prim)->Texture((mgCTexture *)&frame);
    ((mgCDrawPrim *)prim)->Direct(0x3B, 0x8080 | ((unsigned long)0x80 << 32));
    ((mgCDrawPrim *)prim)->Color(0x80, 0x80, 0x80, 0x80);
    ((mgCDrawPrim *)prim)->EndPrim2();
    DivSpriteScreen(*(mgCDrawPrim *)prim);
    ((mgCDrawPrim *)prim)->End2();
    return 0;
}
#ifdef NONMATCHING
#pragma global_optimizer on
int sgSysDrawGyoRace(SubGameInfo *info) {
    extern ClsMes *GetSystemMessage();
    extern void PrimQuad(mgCTexture *, mgRect<int>, mgRect<int>, int, int, int, int);
    extern void DrawMenuFillBox(float, float, float, float, int, int, int, int);
    extern char at_1384__2[];
    extern int OmakeFlag;
    extern int lap_inf_1798[2][5];
    extern int lap_inf2_1799[5];
    mgRect<int> sp80;
    mgRect<int> sp90;
    grRACE_PROGRESS spA0;
    mgRect<int> spC0;
    mgRect<int> spD0;
    mgRect<int> spE0;
    mgRect<int> spF0;
    mgRect<int> sp100;
    mgRect<int> sp110;
    mgRect<int> sp120;
    mgRect<int> sp130;
    mgRect<int> sp140;
    mgRect<int> sp150;
    mgRect<int> sp160;
    mgRect<int> sp170;
    mgRect<int> sp180;
    mgRect<int> sp190;
    mgRect<int> sp1A0;
    mgRect<int> sp1B0;
    mgRect<int> sp1C0;
    mgRect<int> sp1D0;
    mgRect<int> sp1E0;
    mgRect<int> sp1F0;
    mgRect<int> sp200;
    mgRect<int> sp210;
    mgRect<int> sp220;
    mgRect<int> sp230;
    mgRect<int> sp240;
    mgRect<int> sp250;
    mgRect<int> sp260;
    mgRect<int> sp270;
    mgRect<int> sp280;
    mgRect<int> sp290;
    mgRect<int> sp2A0;
    mgRect<int> sp2B0;
    mgRect<int> sp2C0;
    mgRect<int> sp2D0;
    mgRect<int> sp2E0;
    mgRect<int> sp2F0;
    mgRect<int> sp300;
    mgRect<int> sp310;
    mgRect<int> sp320;
    mgRect<int> sp330;
    mgRect<int> sp340;
    mgRect<int> sp350;
    mgRect<int> sp360;
    mgRect<int> sp370;
    mgRect<int> sp380;
    mgRect<int> sp390;
    mgRect<int> sp3A0;
    mgRect<int> sp3B0;
    mgRect<int> sp3C0;
    mgRect<int> sp3D0;
    mgRect<int> sp3E0;
    mgRect<int> sp3F0;
    mgRect<int> sp400;
    mgRect<int> sp410;
    mgRect<int> sp420;
    mgRect<int> sp430;
    mgRect<int> sp440;
    grRACE_PROGRESS sp450;
    mgRect<int> sp470;
    mgRect<int> sp480;
    mgRect<int> sp490;
    mgRect<int> sp4A0;
    mgRect<int> sp4B0;
    mgRect<int> sp4C0;
    mgRect<int> sp4D0;
    mgRect<int> sp4E0;
    CScene *scene;
    float temp_f0;
    float temp_f20;
    float temp_f20_2;
    float temp_f20_3;
    float temp_f20_4;
    float temp_f3;
    int temp_2;
    int temp_2_10;
    int temp_2_4;
    int temp_2_5;
    int temp_2_6;
    int temp_2_7;
    int temp_2_8;
    int temp_2_9;
    int temp_3;
    int var_16;
    int var_16_2;
    int var_17;
    int var_17_2;
    int var_18;
    int var_19;
    int *lap;
    int *lane;

    mgCTextureManager *textures = &mgTexManager;
    scene = info->scene;
    textures->ReloadTexture( *(int *)((u_char *)GetSystemMessage() + 0x22A4), (sceVif1Packet *)0);
    Jikkyou(info);
    gyo_mes->Step();
    gyo_mes->DrawMesWin();
    win_alpha -= 0.5f;
    if (win_alpha < 0.0f) {
        win_alpha = 0.0f;
    }
    textures->ReloadTexture( WindowTexb, (sceVif1Packet *)0);
    wind_tex = textures->GetTexture(at_1384__2, -1);
    sp80.Set(0x15, 0x13, 0x1D6, 0x54);
    sp90.Set(0, 0, 0x1D6, 0x54);
    PrimQuad(wind_tex, sp80, sp90, 0x80, 0x80, 0x80, 0x80);
    var_16 = 0;
    var_17 = 0;
    do {
        grGetFishProgress(&RaceInfo, var_16, race_cnt, &spA0);
        float limit = 16.0f;
        if (!(spA0.pos <= limit)) {
            spA0.pos = limit;
        }
        float width = 326.0f;
        temp_f3 = width * (spA0.pos / 16.0f);
        lane = (int *)((u_char *)&RaceInfo + var_17 + 0x48);
        DrawMenuFillBox(41.0f + temp_f3, 35.0f + (10.0f * (float) *lane), width - temp_f3, 2.0f, 0x4A, 0x70, 0xD9, 0x8B);
        DrawMenuFillBox(41.0f, (float) ((*lane * 0xA) + 0x23), 326.0f * (spA0.pos / 16.0f), 2.0f, 0x54, 0xE5, 0x8B, 0x29);
        spC0.Set((int)(31.0f + (float) (int)(326.0f * (spA0.pos / 16.0f))), (*lane * 0xA) + 0x1C, 0x12, 0xC);
        if ((var_16 == hero_no) && (OmakeFlag == 0)) {
            spD0.Set(0x1EE, 0xC, 0x12, 0xC);
            if ((u_char)spA0.state != 3) {
                PrimQuad(wind_tex, spC0, spD0, 0x80, 0x80, 0x80, 0x80);
            } else {
                PrimQuad(wind_tex, spC0, spD0, 0x80, 0x80, 0x80, 0);
            }
        } else {
            spE0.Set(0x1EE, 0, 0x12, 0xC);
            if ((u_char)spA0.state != 3) {
                PrimQuad(wind_tex, spC0, spE0, 0x80, 0x80, 0x80, 0x80);
            } else {
                PrimQuad(wind_tex, spC0, spE0, 0x80, 0x80, 0x80, 0);
            }
        }
        var_16 += 1;
        var_17 += 0x40;
    } while (var_16 < 6);
    temp_3 = race_mode;
    var_16_2 = 0;
    if ((temp_3 == 0) || (temp_3 == 1)) {
        var_17_2 = 0;
        var_18 = 0;
        do {
            spF0.Set(var_18 + 0x1A2, var_17_2 + 0x41, 0xC, 0xC);
            sp100.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, spF0, sp100, 0x80, 0x80, 0x80, 0x80);
            sp110.Set(var_18 + 0x1B0, var_17_2 + 0x41, 0xC, 0xC);
            sp120.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, sp110, sp120, 0x80, 0x80, 0x80, 0x80);
            sp130.Set(var_18 + 0x1BA, var_17_2 + 0x41, 0xC, 0xC);
            sp140.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, sp130, sp140, 0x80, 0x80, 0x80, 0x80);
            sp150.Set(var_18 + 0x1C9, var_17_2 + 0x41, 0xC, 0xC);
            sp160.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, sp150, sp160, 0x80, 0x80, 0x80, 0x80);
            sp170.Set(var_18 + 0x1D3, var_17_2 + 0x41, 0xC, 0xC);
            sp180.Set(0x138, 0x62, 0xC, 0xC);
            PrimQuad(wind_tex, sp170, sp180, 0x80, 0x80, 0x80, 0x80);
            var_16_2 += 1;
            var_17_2 += 0x10;
            var_18 += 2;
        } while (var_16_2 < 2);
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
        temp_f20 = fish_inf[hero_no].lap_time[var_19 = (int)fish_inf[hero_no].lap];
        var_16 = (int)(temp_f20 / 3600.0f);
        float minute_frames = 3600.0f; temp_f20_2 = temp_f20 - minute_frames * (float)var_16;
        float second_base = 60.0f;
        var_17 = (int)(temp_f20_2 / second_base);
        float second_frames = 60.0f; float centi = 100.0f; var_18 = (int)(centi * (temp_f20_2 - second_frames * (float)var_17) / second_frames);
        var_19 = var_19 * 0x14;
        *(int *)((u_char *)&lap_inf_1798[0][0] + var_19) = var_16;
        temp_2_4 = (int)(0.1f * (float) var_17);
        *(int *)((u_char *)&lap_inf_1798[0][1] + var_19) = temp_2_4;
        *(int *)((u_char *)&lap_inf_1798[0][2] + var_19) = var_17 - (temp_2_4 * 0xA);
        temp_2_5 = (*(int *)((u_char *)&lap_inf_1798[0][3] + var_19) = (int)(0.1f * (float) var_18));
        int centi_units = var_18 - temp_2_5 * 10;
        var_16 = 0;
        var_17 = 0;
        var_18 = 0;
        *(int *)((u_char *)&lap_inf_1798[0][4] + var_19) = centi_units;
        var_19 = 0;
        do {
            if (*(int *)&fish_inf[hero_no].lap < var_16) {
                sp250.Set(var_18 + 0x1A2, var_17 + 0x41, 0xC, 0xC);
                sp260.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp250, sp260, 0x80, 0x80, 0x80, 0x80);
                sp270.Set(var_18 + 0x1B0, var_17 + 0x41, 0xC, 0xC);
                sp280.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp270, sp280, 0x80, 0x80, 0x80, 0x80);
                sp290.Set(var_18 + 0x1BA, var_17 + 0x41, 0xC, 0xC);
                sp2A0.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp290, sp2A0, 0x80, 0x80, 0x80, 0x80);
                sp2B0.Set(var_18 + 0x1C9, var_17 + 0x41, 0xC, 0xC);
                sp2C0.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp2B0, sp2C0, 0x80, 0x80, 0x80, 0x80);
                sp2D0.Set(var_18 + 0x1D3, var_17 + 0x41, 0xC, 0xC);
                sp2E0.Set(0x138, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp2D0, sp2E0, 0x80, 0x80, 0x80, 0x80);
            } else {
                sp2F0.Set(var_18 + 0x1A2, var_17 + 0x41, 0xC, 0xC);
                lap = (int *)((u_char *)lap_inf_1798 + var_19);
                sp300.Set((lap[0] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp2F0, sp300, 0x80, 0x80, 0x80, 0x80);
                sp310.Set(var_18 + 0x1B0, var_17 + 0x41, 0xC, 0xC);
                sp320.Set((lap[1] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp310, sp320, 0x80, 0x80, 0x80, 0x80);
                sp330.Set(var_18 + 0x1BA, var_17 + 0x41, 0xC, 0xC);
                sp340.Set((lap[2] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp330, sp340, 0x80, 0x80, 0x80, 0x80);
                sp350.Set(var_18 + 0x1C9, var_17 + 0x41, 0xC, 0xC);
                sp360.Set((lap[3] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp350, sp360, 0x80, 0x80, 0x80, 0x80);
                sp370.Set(var_18 + 0x1D3, var_17 + 0x41, 0xC, 0xC);
                sp380.Set((lap[4] * 0xC) + 0xC0, 0x62, 0xC, 0xC);
                PrimQuad(wind_tex, sp370, sp380, 0x80, 0x80, 0x80, 0x80);
            }
            var_16 += 1;
            var_17 += 0x10;
            var_18 += 2;
            var_19 += 0x14;
        } while (var_16 < 2);
        temp_f20_3 = fish_inf[hero_no].time;
        temp_2_6 = (int)(temp_f20_3 / 3600.0f);
        temp_f20_4 = temp_f20_3 - (3600.0f * (float) temp_2_6);
        temp_2_7 = (int)(temp_f20_4 / 60.0f);
        temp_2_8 = (int)((100.0f * (temp_f20_4 - (60.0f * (float) temp_2_7))) / 60.0f);
        lap_inf2_1799[0] = temp_2_6;
        temp_2_9 = (int)(0.1f * (float) temp_2_7);
        lap_inf2_1799[1] = temp_2_9;
        lap_inf2_1799[2] = (int) (temp_2_7 - (temp_2_9 * 0xA));
        temp_2_10 = (int)(0.1f * (float) temp_2_8);
        lap_inf2_1799[3] = temp_2_10;
        lap_inf2_1799[4] = (int) (temp_2_8 - (temp_2_10 * 0xA));
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
    scene->GetCharacter( fish_inf[hero_no].chara_no);
    grGetFishProgress(&RaceInfo, hero_no, race_cnt, &sp450);
    if ((u_char)sp450.state == 3) {
        sp470.Set(0x178, 0x1C, 0xC, 0xC);
        sp480.Set(0xD8, 0x62, 0xC, 0xC);
        PrimQuad(wind_tex, sp470, sp480, 0x80, 0x80, 0x80, 0x80);
        sp490.Set(0x187, 0x1C, 0xC, 0xC);
        sp4A0.Set(0xD8, 0x62, 0xC, 0xC);
        PrimQuad(wind_tex, sp490, sp4A0, 0x80, 0x80, 0x80, 0x80);
    } else {
        sp4B0.Set(0x178, 0x1C, 0xC, 0xC);
        sp4C0.Set(((int)fish_inf[hero_no].lap * 0xC) + 0xC0, 0x62, 0xC, 0xC);
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
    CFont font;
    grRACE_PROGRESS lead;
    grRACE_PROGRESS progress[6];
    grRACE_PROGRESS fish;
    float position;
    int index;
    int fish_no;
    char *name;
    ClsMes *message;

    font.Init();
    font.Preset(4);
    font.SetFuchi(3);
    font.SetDrawSize(16, 20);
    const float race_time = race_cnt;
    if ((double)race_time <= 0.0) {
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
                if ((u_char)fish.state == 2) {
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
#endif
mgCMemory BuffTextureData;
static mgCMemory BuffWorkData;
mgCCamera camera0(8.0f);
#ifndef NONMATCHING
INCLUDE_BSS(fish_inf, 0x110);
INCLUDE_BSS(at_1765__2, 0x10);
INCLUDE_BSS(at_1775, 0x10);
INCLUDE_BSS(at_1776, 0x10);
INCLUDE_BSS(lap_inf_1798, 0x30);
INCLUDE_BSS(lap_inf2_1799, 0x50);
#endif
