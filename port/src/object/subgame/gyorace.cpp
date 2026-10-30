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
#include "log/game_output.hpp"
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
#include "text/bounded.hpp"
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

static RaceVector at_1775;
static RaceVector at_1776;

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
char *fish_name[GR_FISH_KIND_NUM] = {
    "f1a.gltf",
    "f2a.gltf",
    "f3a.gltf",
    "f4a.gltf",
    "f5a.gltf",
    "f6a.gltf",
    "f7a.gltf",
    "f8a.gltf",
    "f10a.gltf",
    "f11a.gltf",
    "f12a.gltf",
    "f13a.gltf",
    "f14a.gltf",
    "f15a.gltf",
    "f16a.gltf",
    "f17a.gltf",
    "f18a.gltf",
    "f19a.gltf",
};

/**
 *
 * Fixed race camera positions around the fish course.
 *
 */
sceVu0FVECTOR cam_pos[5] = {
    {275.0f,  58.0f,  -167.0f, 1.0f},
    {255.0f,  -18.0f, 267.0f,  1.0f},
    {66.0f,   100.0f, -666.0f, 1.0f},
    {-180.0f, -18.0f, 100.0f,  1.0f},
    {-66.0f,  80.0f,  666.0f,  1.0f},
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
static BattleEffectPrim (*battle_EffectPara)[GYORACE_EFFECT_SPARK_NUM];

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
GYORACE_RESULT fish_game_data[GR_FISH_MAX];

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
grRACE_PROGRESS old_prog[GR_FISH_MAX];

/**
 *
 * Entrant indices ordered by current place.
 *
 */
static int fish_rank[GR_FISH_MAX];

/**
 *
 * Entrant order from the previous race update.
 *
 */
static int old_fish_rank[GR_FISH_MAX];

/**
 *
 * Game inventory records selected for the race entrants.
 *
 */
static CGameDataUsed *game_data[GR_FISH_MAX];

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
GYORACE_FISH_INF fish_inf[GR_FISH_MAX];

int sgInitGyoRace(SubGameInfo *info) {
    if (info == nullptr || info->scene == nullptr) {
        return 0;
    }
    mgCTextureManager *textures = {};
    CScene            *scene = info->scene;
    scene->AssignStack(5);
    mgCMemory *memory = scene->GetStack(5);
    if (memory == nullptr || memory->lock != 0) {
        return 0;
    }
    const auto remaining = dc2::memory::RemainingBytes(*memory);
    const auto misalignment = reinterpret_cast<std::uintptr_t>(remaining.data()) % 64;
    const auto padding = misalignment == 0 ? 0 : (64 - misalignment) / sizeof(u_long128);
    if (remaining.size() / sizeof(u_long128) <= 0x88B8 + 0x7530 + padding) {
        return 0;
    }
    BuffTextureData.stSetChildBuffer(*memory, memory->stAlloc64(0x88B8), 0x88B8);
    BuffTextureData.stReset();
    BuffWorkData.stSetChildBuffer(*memory, memory->stAlloc64(0x7530), 0x7530);
    BuffWorkData.stReset();
    const auto read_storage = scene->GetReadBufferBytes();
    auto      *buffer = reinterpret_cast<u_long128 *>(read_storage.data());
    int        size = {};
    sndInitPort(SND_PORT_ENEMY);
    LoadFile2("snd2/mon/EN_902.sound.json", read_storage, &size, LOAD_FILE_READ);
    gyore_snd_id = sndLoadSound(SND_PORT_ENEMY, reinterpret_cast<unsigned int *>(buffer), memory);
    ChangeDir("/sg/gyo/");
    CGyoraceFishData fish_data{};
    fish_data.LoadData(memory, buffer);
    u_long128 *texture_buffer = BuffTextureData.stack;
    char       path[0x100];
    std::snprintf(path, sizeof(path), "gyore%d.mes", LanguageCode);
    const auto message_destination = dc2::memory::AvailableFrom(BuffTextureData, texture_buffer);
    if (LoadFile2(path, message_destination, &size, LOAD_FILE_READ) == 0 || size <= 0 ||
        static_cast<std::size_t>(size) > message_destination.size()) {
        return 0;
    }
    const auto message_table = dc2::text::MessageTable::Parse(std::as_bytes(message_destination.first(static_cast<std::size_t>(size))));
    if (!message_table) {
        return 0;
    }
    gyo_mes = dc2::memory::NewObject<ClsMes>(*memory);
    if (gyo_mes == nullptr) {
        return 0;
    }
    gyo_mes->SetBuff(message_table);
    gyo_mes->SetBuff_system(GetSystemMesBuffer());
    gyo_mes->Init();
    gyo_mes->Preset(MES_PRESET_FUKIDASHI);
    gyo_mes->SetWindowMode(MES_WIN_BOTTOM);
    gyo_mes->draw_speed = 3.8f;
    gyo_mes->draw_speed_def = 3.8f;
    gyo_mes->push_button = 0;
    gyo_mes->MakeMesWin(GYORACE_MES_INTRO);
    race_mode = GYORACE_MODE_READY;
    hero_no = 0;
    race_cnt = 0.0f;
    race_proc_cnt = 75;
    old_cam_no = -1;
    mgGetAmbient(old_ambient);
    win_alpha = 128.0f;
    jyunkai_flg = false;
    hantei_flg = false;
    goal_cnt = 0;
    mes_count = 0;
    rank_count = 0;
    battle_EffectPara = new (memory->Alloc((sizeof(BattleEffectPrim) * GYORACE_EFFECT_NUM * GYORACE_EFFECT_SPARK_NUM + 15) / 16 + 2)) BattleEffectPrim[GYORACE_EFFECT_NUM][GYORACE_EFFECT_SPARK_NUM];
    battle_effect = new (memory->Alloc((sizeof(CHitEffectImage) * GYORACE_EFFECT_NUM + 15) / 16 + 2)) CHitEffectImage[GYORACE_EFFECT_NUM];

    for (int effect = 0; effect < GYORACE_EFFECT_NUM; effect++) {
        CHitEffectImage *image = &battle_effect[effect];
        image->spark = battle_EffectPara[effect];
        image->spark_max = GYORACE_EFFECT_SPARK_NUM;
        image->live_num = 0;
        image->spark_num = 0;
        image->kind = HIT_EFFECT_BOARD;
    }

    race_rank[0] = GetGyoRaceClass();
    race_rank[1] = GetGyoRaceNo();
    int chosen[GR_FISH_MAX];
    int chosen_num = 0;
    int fish = 0;

    do {
        fish_inf[fish].fish_no = -1;

        if (OmakeFlag != 0) {
            CGameDataUsed  *race_fish = GetOmakeGyoracer2(fish);
            CGameDataUsed **item = &game_data[fish];
            *item = race_fish;

            if (*item == nullptr) {
                chosen[chosen_num] = race_rank[1] * 18 + static_cast<int>(17.0f * mgRnd());

                do {
                    int selection = {};

                    for (selection = 0; selection < chosen_num; selection++) {
                        if (chosen[selection] == chosen[chosen_num]) {
                            break;
                        }
                    }

                    if (chosen_num == selection) {
                        break;
                    }

                    chosen[chosen_num] = race_rank[1] * 18 + static_cast<int>(17.0f * mgRnd());
                } while (1);

                *item = fish_data.GetRaceFish(race_rank[0], chosen[chosen_num]);
                chosen_num++;
            }
        } else if (fish == 0) {
            game_data[fish] = GetGyoRaceFish();
        } else {
            int selection = {};
            chosen[chosen_num] = race_rank[1] * 18 + static_cast<int>(17.0f * mgRnd());

            do {
                for (selection = 0; selection < chosen_num; selection++) {
                    if (chosen[selection] == chosen[chosen_num]) {
                        break;
                    }
                }

                if (chosen_num == selection) {
                    break;
                }

                chosen[chosen_num] = race_rank[1] * 18 + static_cast<int>(17.0f * mgRnd());
            } while (1);

            selection = chosen[chosen_num];
            CGameDataUsed *race_fish = fish_data.GetRaceFish(race_rank[0], selection);
            chosen_num++;
            game_data[fish] = race_fish;
            fish_inf[fish].fish_no = selection;
        }

        fish++;
    } while (fish < GR_FISH_MAX);

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
        for (int place = 0; place < GR_FISH_MAX; place++) {
            fish_game_data[place].fish_no = -1;
            fish_game_data[place].race_class = 0;
        }
    }

    int lane = 0;

    if (OmakeFlag == 0) {
        lane = static_cast<int>(6.0f * mgRnd());

        if (lane > GR_FISH_MAX - 1) {
            lane = GR_FISH_MAX - 1;
        }
    }

    memset(&RaceInfo, 0, sizeof(RaceInfo));
    RaceInfo.seed = 0;
    dc2::log::PrintGame(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>GYO RACE RndSeed=%u \n", RaceInfo.seed);
    RaceInfo.fish_num = GR_FISH_MAX;
    RaceInfo.step_max = GYORACE_STEP_MAX;
    RaceInfo.after_goal_step = 20;
    int racer = 0;

    do {
        RaceInfo.progress[racer] = new (memory->Alloc((sizeof(grRACE_PROGRESS) * GYORACE_STEP_MAX + 15) / 16 + 2)) grRACE_PROGRESS[GYORACE_STEP_MAX];

        if (OmakeFlag == 0 && racer == 0) {
            RaceInfo.fish[racer].tactics = GetGyoRaceAquariumNo();
        } else if (OmakeFlag != 0) {
            RaceInfo.fish[racer].tactics = GetOmakeGyoracerTactics(racer);
        } else {
            RaceInfo.fish[racer].tactics = static_cast<int>(6.0f * mgRnd());

            if (RaceInfo.fish[racer].tactics > 5) {
                RaceInfo.fish[racer].tactics = 5;
            }
        }

        int             fatigue = {};
        CGameDataUsed **item = &game_data[racer];
        dc2::text::Copy(RaceInfo.fish[racer].name, (*item)->data.fish.name);
        CGameDataUsed *fish_item = *item;
        RaceInfo.fish[racer].bonus_type = fish_item->data.fish.kind;
        RaceInfo.fish[racer].power = fish_item->data.fish.param[BREEDFISH_STAT_BATTLE];
        BREEDFISH_USED *data = &fish_item->data.fish;

        if (OmakeFlag == 0 && racer == 0) {
            if (race_rank[1] == 0) {
                data->fatigue++;
            }

            fish_item = *item;
            data = &fish_item->data.fish;
            fatigue = fish_item->data.fish.fatigue;
            RaceInfo.fish[racer].stamina = static_cast<int>(static_cast<float>(data->param[BREEDFISH_STAT_STAMINA]) - (0.1f * static_cast<float>(fatigue - 1) * static_cast<float>(fish_item->data.fish.param[BREEDFISH_STAT_STAMINA])));
            dc2::log::PrintGame(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>MY_FISH TUKARE=%d \n", fatigue);
        } else {
            RaceInfo.fish[racer].stamina = data->param[BREEDFISH_STAT_STAMINA];
        }

        fish_item = *item;
        RaceInfo.fish[racer].speed[0] = fish_item->data.fish.param[BREEDFISH_STAT_BOOST];
        RaceInfo.fish[racer].speed[1] = fish_item->data.fish.param[BREEDFISH_STAT_ENDURANCE];
        RaceInfo.fish[racer].speed[2] = fish_item->data.fish.param[BREEDFISH_STAT_TENACITY];
        RaceInfo.fish[racer].affinity = fish_item->data.fish.color;
        RaceInfo.fish[racer].fish_no = fish_item->item_no;
        RaceInfo.fish[racer].lane = lane;
        fish_inf[racer].lane = lane;
        lane++;

        if (lane >= GR_FISH_MAX) {
            lane = 0;
        }

        dc2::log::PrintGame(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>GYO RACE info GYO_NAME=%s  Operation=%d \n", RaceInfo.fish[racer].name, RaceInfo.fish[racer].tactics);
        racer++;
    } while (racer < GR_FISH_MAX);

    time_max = grGyoRaceSimulate(&RaceInfo);

    for (int racer_no = 0; racer_no < GR_FISH_MAX; racer_no++) {
        scene->GetCharacter(fish_inf[racer_no].chara_no);
        grGetFishProgress(&RaceInfo, racer_no, race_cnt, &old_prog[racer_no]);
    }

    CharaTexb = info->texb;
    CGameDataUsed **item = {};
    int             fish_index = 0;

    do {
        grRACE_PROGRESS *progress = &old_prog[fish_index];
        grGetFishProgress(&RaceInfo, fish_index, 0.0f, progress);
        textures = &mgTexManager;
        textures->DeleteBlock(CharaTexb);
        item = &game_data[fish_index];
        int kind = (*item)->item_no - FISH_ITEM_BOUBOU;

        if (kind < 0) {
            kind = GR_FISH_KIND_NUM - 1;
        }

        if (LoadFile2(fish_name[kind], read_storage, nullptr, LOAD_FILE_READ) == 0) {
            return 0;
        }

        GYORACE_FISH_INF *state = &fish_inf[fish_index];
        state->chara_no = fish_index + 0x40;
        state->lap = 0;
        state->second_lap = 0;
        state->lap_start = 0.0f;
        state->time = 0.0f;
        state->rank = 1;
        int *character_no = &state->chara_no;
        scene->LoadChara(state->chara_no, reinterpret_cast<unsigned int *>(buffer), "info", memory, memory, memory, CharaTexb, 0);
        scene->SetActive(SCENE_DATA_CHARA, *character_no);
        scene->SetCharaTexb(*character_no, CharaTexb);
        CCharacter2  *character = scene->GetCharacter(*character_no);
        sceVu0FVECTOR position = {0.0f, -15.0f, 0.0f, 1.0f};
        position[0] = 190.0f + 15.0f * static_cast<float>(progress->lane);
        position[2] = character->body_height / 4.0f;
        sceVu0FVECTOR   rotation = {0.0f, PI, 0.0f, 1.0f};
        BREEDFISH_USED *data = &(*item)->data.fish;
        CDataBreedFish *breed = GetBreedFishInfoData((*item)->item_no);
        float           scale = static_cast<float>(data->size) / breed->size;

        if (!(scale <= 2.0f)) {
            scale = 2.0f;
        }

        character->SetScale(scale, scale, scale);
        character->SetRotation(rotation);
        character->SetPosition(position);
        character->SetMotion("\x92\xCA\x8F\xED", 0);
        character->SetStep(0.3f);
        FishIMGReplace(buffer, character, (*item)->item_no, &(*item)->data.fish);
        fish_index++;
        CharaTexb++;
    } while (fish_index < GR_FISH_MAX);

    if (texture_buffer != nullptr) {
        WindowTexb = CharaTexb;
        char image_path[0x40];

        if (LanguageCode > LANG_JAPANESE) {
            std::snprintf(image_path, sizeof(image_path), "/textures/sg/gyo/grttex_new6_%d.json", LanguageCode);
        } else {
            dc2::text::Copy(image_path, "/textures/sg/gyo/grttex_new6.json");
        }

        textures->DeleteBlock(WindowTexb);
        LoadFile(image_path, dc2::memory::AvailableFrom(BuffTextureData, texture_buffer), &size);
        textures->EnterIMGFile(reinterpret_cast<unsigned char *>(texture_buffer), WindowTexb, &BuffTextureData, nullptr);
        EffectTex2 = textures->GetTexture("grt_moji", -1);
        EffectTexb = WindowTexb + 1;
        textures->DeleteBlock(EffectTexb);
        textures->EnterIMGFile(reinterpret_cast<unsigned char *>(texture_buffer), EffectTexb, &BuffTextureData, nullptr);
        TEX_SystemEffect1 = EffectTex = textures->GetTexture("grt1", -1);
        ChangeDir(nullptr);
    }

    camera_id = scene->AssignCamera(-1, &camera0, nullptr);
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

int sgLoopGyoRace(SubGameInfo *info);

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
    CScene *scene = {};
    int     i = {};
    scene = info->scene;
    i = 0;

    do {
        scene->DrawChara(fish_inf[i].chara_no, 1);
        i++;
    } while (i < GR_FISH_MAX);

    mgTexManager.ReloadTexture(EffectTexb, (sceVif1Packet *) nullptr);
    int              j = 0;
    CHitEffectImage *effect = {};

    do {
        effect = &battle_effect[j];

        if (effect != nullptr) {
            effect->Step();
            effect->Draw();
        }

        j++;
    } while (j < GYORACE_EFFECT_NUM);

    return 0;
}

/**
 *
 * Draws the race screen texture as rotated horizontal strips.
 *
 */
static void DivSpriteScreen(mgCDrawPrim &prim) {
    int strip_height = {};
    int screen_width = {};
    int y = {};
    int y16 = {};
    int x = {};
    int x16 = {};
    int height16 = {};
    int width16 = {};

    if (!init_1763) {
        ras_off_1762 = 0.0f;
        init_1763 = true;
    }

    prim.BeginPrim2(4, 0x43, 0, 2);
    int origin[4] = {mgScreenOffx << 4, mgScreenOffy << 4, 0, 0};
    screen_width = mgScreenWidth;
    int screen_height = mgScreenHeight;
    strip_height = screen_height / 48;
    float step[4] = {0, 0, 0, 1};
    step[1] = static_cast<float>((strip_height / 3) << 4);
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
            RaceVector uv{};
            uv = at_1775;
            RaceVector xy{};
            xy = at_1776;
            uv = *reinterpret_cast<RaceVector *>(origin);
            xy.v[0] = x16;
            int *xy_y = &xy.v[1];
            *xy_y = y16;
            prim.Data(xy.v);
            uv.v[0] = xy.v[0] + origin[0] - static_cast<int>(step[0]);
            uv.v[1] = *xy_y + origin[1];
            prim.Data(uv.v);
            xy.v[0] = (x + screen_width) << 4;
            *xy_y = (y + strip_height) << 4;
            prim.Data(xy.v);
            uv.v[0] = static_cast<int>(step[0]) + (xy.v[0] + origin[0]);
            uv.v[1] = *xy_y + origin[1];
            prim.Data(uv.v);
            y += strip_height;
            y16 += height16;
        }

        x += screen_width;
        x16 += width16;
    }

    ras_off_1762 += 0.0004363323f;

    if (!(ras_off_1762 <= TWO_PI)) {
        ras_off_1762 = -TWO_PI;
    }

    prim.EndPrim2();
}

int sgEffectDrawGyoRace(SubGameInfo *info) {
    if (!water_cam) {
        return 0;
    }

    mgCDrawPrim prim;
    prim.Initialize(nullptr, nullptr);
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
    static int         lap_inf[2][5];
    static int         lap_inf2[5];
    CScene            *scene = {};
    float              lap_frames = {};
    float              lap_seconds_frames = {};
    float              total_frames = {};
    float              total_seconds_frames = {};
    float              bar_done = {};
    int                total_centi_tens = {};
    int                lap_second_tens = {};
    int                lap_centi_tens = {};
    int                total_minutes = {};
    int                total_seconds = {};
    int                total_centi = {};
    int                total_second_tens = {};
    int                mode = {};
    int                i = {};
    int                row = {};
    int                j = {};
    int                k = {};
    int                lap = {};
    mgCTextureManager *textures = &mgTexManager;
    scene = info->scene;
    textures->ReloadTexture(GetSystemMessage()->texture_block, (sceVif1Packet *) nullptr);
    Jikkyou(info);
    gyo_mes->Step();
    gyo_mes->DrawMesWin();
    win_alpha -= 0.5f;

    if (win_alpha < 0.0f) {
        win_alpha = 0.0f;
    }

    textures->ReloadTexture(WindowTexb, (sceVif1Packet *) nullptr);
    wind_tex = textures->GetTexture("grt1", -1);
    {
        mgRect<int> screen;
        mgRect<int> texture;
        screen.Set(0x15, 0x13, 0x1D6, 0x54);
        texture.Set(0, 0, 0x1D6, 0x54);
        PrimQuad(wind_tex, screen, texture, 0x80, 0x80, 0x80, 0x80);
    }
    grRACE_PROGRESS progress{};
    i = 0;

    do {
        grGetFishProgress(&RaceInfo, i, race_cnt, &progress);

        if (progress.pos > 16.0f) {
            progress.pos = 16.0f;
        }

        bar_done = 326.0f * (progress.pos / 16.0f);
        float bar_y = 35.0f + 10.0f * static_cast<float>(RaceInfo.fish[i].lane);
        DrawMenuFillBox(41.0f + bar_done, bar_y, 326.0f - bar_done, 2.0f, 0x4A, 0x70, 0xD9, 0x8B);
        float filled = 326.0f * (progress.pos / 16.0f);
        DrawMenuFillBox(41.0f, static_cast<float>((RaceInfo.fish[i].lane * 10) + 35), filled, 2.0f, 0x54, 0xE5, 0x8B, 0x29);
        mgRect<int> icon(static_cast<int>(31.0f + static_cast<float>(static_cast<int>(326.0f * (progress.pos / 16.0f)))), (RaceInfo.fish[i].lane * 10) + 28, 0x12, 0xC);

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
    } while (i < GR_FISH_MAX);

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
        i = static_cast<int>(lap_frames / 3600.0f);
        lap_seconds_frames = lap_frames - 3600.0f * static_cast<float>(i);
        j = static_cast<int>(lap_seconds_frames / 60.0f);
        k = static_cast<int>(100.0f * (lap_seconds_frames - 60.0f * static_cast<float>(j)) / 60.0f);
        lap_inf[lap][0] = i;
        lap_second_tens = static_cast<int>(0.1f * static_cast<float>(j));
        lap_inf[lap][1] = lap_second_tens;
        lap_inf[lap][2] = j - (lap_second_tens * 10);
        lap_centi_tens = (lap_inf[lap][3] = static_cast<int>(0.1f * static_cast<float>(k)));
        lap_inf[lap][4] = k - lap_centi_tens * 10;
        int lap_no = 0;
        int lap_y = 0;
        int lap_x = 0;

        do {
            if (static_cast<int>(fish_inf[hero_no].lap) < lap_no) {
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
        total_minutes = static_cast<int>(total_frames / 3600.0f);
        total_seconds_frames = total_frames - (3600.0f * static_cast<float>(total_minutes));
        total_seconds = static_cast<int>(total_seconds_frames / 60.0f);
        total_centi = static_cast<int>((100.0f * (total_seconds_frames - (60.0f * static_cast<float>(total_seconds)))) / 60.0f);
        lap_inf2[0] = total_minutes;
        total_second_tens = static_cast<int>(0.1f * static_cast<float>(total_seconds));
        lap_inf2[1] = total_second_tens;
        lap_inf2[2] = total_seconds - (total_second_tens * 10);
        total_centi_tens = static_cast<int>(0.1f * static_cast<float>(total_centi));
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

    grRACE_PROGRESS hero_progress{};
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
            texture.Set((static_cast<int>(fish_inf[hero_no].lap) * 12) + 0xC0, 0x62, 0xC, 0xC);
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
    grRACE_PROGRESS lead{};
    grRACE_PROGRESS progress[GR_FISH_MAX];
    grRACE_PROGRESS fish{};
    float           position = {};
    int             index = {};
    int             fish_no = {};
    char           *name = {};
    ClsMes         *message = {};

    font.Init();
    font.Preset(4);
    font.SetFuchi(3);
    font.SetDrawSize(16, 20);
    const float race_time = race_cnt;

    if (static_cast<double>(race_time) <= 0.0) {
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
        gyo_mes->MakeMesWin(GYORACE_MES_START);
        mes_count = 60;
        return 0;
    }

    if (!(position <= 1.0f) && position <= 2.0f) {
        grGetFishProgress(&RaceInfo, fish_rank[0], 0.5f, &progress[0]);
        grGetFishProgress(&RaceInfo, fish_rank[GR_FISH_MAX - 1], 0.5f, &progress[1]);

        if (!(progress[0].pos - progress[1].pos <= 0.01f)) {
            gyo_mes->MakeMesWin(GYORACE_MES_SHAKY_START);
            mes_count = 60;
            return 0;
        }

        gyo_mes->MakeMesWin(GYORACE_MES_GOOD_START);
        mes_count = 60;
        return 0;
    }

    if ((!(position <= 2.0f) && position < 8.0f) || (!(position <= 9.0f) && position < 16.0f)) {
        if (!jyunkai_flg) {
            jyunkai_flg = true;
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

                    if (name != nullptr) {
                        dc2::text::Copy(name_mes->name[0], dc2::text::View(name));
                    }

                    gyo_mes->MakeMesWin(GYORACE_MES_BATTLE);
                    mes_count = 60;
                    jyunkai_flg = false;
                    sndSePlay(gyore_snd_id, 0x16, 0);
                    break;
                }

                index++;
            } while (index < GR_FISH_MAX);

            return 0;
        }

        fish_no = fish_rank[rank_count];
        int lane = RaceInfo.fish[fish_no].lane + 1;
        message = gyo_mes;
        message->values[0] = lane;
        message->value_width[0] = 0;
        name = RaceInfo.fish[fish_no].name;
        ClsMes *name_mes = gyo_mes;

        if (name != nullptr) {
            dc2::text::Copy(name_mes->name[0], dc2::text::View(name));
        }

        if (rank_count == 0) {
            gyo_mes->MakeMesWin(RaceInfo.fish[fish_no].bonus_type + GYORACE_MES_LEADER);
        } else if (rank_count < 5) {
            if (fish_rank[rank_count] == old_fish_rank[rank_count - 1]) {
                fish_no = fish_rank[rank_count - 1];
                int lane = RaceInfo.fish[fish_no].lane + 1;
                message = gyo_mes;
                message->values[0] = lane;
                message->value_width[0] = 0;
                name = RaceInfo.fish[fish_no].name;
                ClsMes *name_mes = gyo_mes;

                if (name != nullptr) {
                    dc2::text::Copy(name_mes->name[0], dc2::text::View(name));
                }

                gyo_mes->MakeMesWin(RaceInfo.fish[fish_no].bonus_type + GYORACE_MES_CLOSE_SECOND);
            } else {
                gyo_mes->MakeMesWin(RaceInfo.fish[fish_no].bonus_type + GYORACE_MES_THIRD);
            }
        } else {
            gyo_mes->MakeMesWin(RaceInfo.fish[fish_no].bonus_type + GYORACE_MES_LAST);
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
        jyunkai_flg = false;
        rank_count = 0;
        gyo_mes->MakeMesWin(GYORACE_MES_FINAL_LAP);
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

        if (name != nullptr) {
            dc2::text::Copy(name_mes->name[0], dc2::text::View(name));
        }

        gyo_mes->MakeMesWin(GYORACE_MES_FINISHED);
        mes_count = 6000;
        sndSePlay(gyore_snd_id, 0x16, 0);
        sndSePlay(gyore_snd_id, 0x17, 0);
    }

    return 0;
}

/**
 *
 * Camera the fish race scene is viewed through.
 *
 */
mgCCamera camera0(8.0f);

#include "common.h"

#include "gyorace.hpp"

int sgLoopGyoRace(SubGameInfo * /*info*/) {
    Ps2Unimplemented(__func__, __FILE__, __LINE__);
}
