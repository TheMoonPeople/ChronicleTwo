#include "common.h"
#include "mw_runtime.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <limits>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

#include "arena_root.hpp"
#include "assets/data_registry.hpp"
#include "audio_assets.hpp"
#include "dataread.hpp"
#include "log/game_output.hpp"
#include "log/log.hpp"
#include "map.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "scenesnd.hpp"
#include "sound.hpp"

namespace {
/**
 *
 * Gives an embedded sound scratch array an independent bounded native root.
 *
 */
template <std::size_t Count>
void BindSoundScratch(mgCMemory &memory, u_long128 (&identity)[Count], const char *name) {
    static_assert(Count > 0 && Count <= static_cast<std::size_t>(std::numeric_limits<int>::max() / kArenaHeadroom));
    auto *root = ArenaRoot(identity, static_cast<int>(Count), name);
    memory.stSetBuffer(root, static_cast<int>(Count) * kArenaHeadroom);
}

bool SoundDestinationAligned(std::span<u8> destination) {
    return destination.size() >= sizeof(u32) &&
           reinterpret_cast<std::uintptr_t>(destination.data()) % alignof(u32) == 0;
}
} // namespace

void CScene::BGM_INFO::Init() {
    snd_id = -1;
    load_no = -1;
    fade_speed = 0.0f;
    master_volf = 1.0f;
    time_vol = 0;
    fade_volf = 1.0f;
}

void CScene::InitSnd() {
    InitBGM();

    for (int i = 0; i < 2; i++) {
        bgm[i].Init();
    }

    bgm[0].port = 0;
    bgm[1].port = 0xB;
    InitSeBas();
    InitLooSeMngr();
    snd_file_id = -1;
    skip_load_bgm = 0;
    skip_load_sound = 0;

    skip_play_bgm = 0;
    bgm_no = 0;
}

void CScene::InitBGM() {
    BGM_INFO *info = GetActiveBgmInfo();
    info->Init();
    BindSoundScratch(info->stack, info->buff, "SceneBgm");
    sndInitPort(info->port);
}

void CScene::InitSeSrc() {
    StopSeSrc();
    sndSeAllStop(4);
    sndSeAllStop(1);
    sndDeletePort(4);
    sndDeletePort(1);

    for (int i = 0; i < 16; i++) {
        se_src_id[i] = -1;
        se_src_no[i] = -1;
    }

    BindSoundScratch(se_src_stack, se_src_buff, "SceneSourceSe");
    sndInitPort(4);
    sndInitPort(1);

    for (int i = 0; i < 4; i++) {
        se_src_play_no[i] = -1;
        se_src_play_flag[i] = 0;
    }

    PrePlaySeSrc();
}

void CScene::InitSeEnv() {
    StopEnvBGM();
    sndSeAllStop(2);
    sndDeletePort(2);
    InitSeSrc();
    se_env_id = -1;
    se_env_no = -1;
    BindSoundScratch(se_env_stack, se_env_buff, "SceneEnvironmentSe");
    sndInitPort(2);
    env_bgm_vol = 0.0f;
    unk_a480 = 0;
    env_bgm_volf = 1.0f;
    env_bgm_no = -1;
    env_bgm_auto = 0;
    env_bgm_offset = 0;
    InitSeSrc();
}

void CScene::InitSeBattle() {
    sndSeAllStop(9);
    sndDeletePort(9);
    se_battle_id = -1;
    se_battle_no = -1;
    BindSoundScratch(se_battle_stack, se_battle_buff, "SceneBattleSe");
    sndInitPort(9);
    InitSeEnv();
}

void CScene::InitSeBas() {
    sndSeAllStop(3);
    se_base_id = -1;
    se_base_no = -1;
    BindSoundScratch(se_base_stack, se_base_buff, "SceneBaseSe");
    sndDeletePort(3);
    sndInitPort(3);
    InitSeBattle();
}

void CScene::SeAllStop() {
    this->StopSeSrc();
    sndSeAllStop(-1);
    this->InitLooSeMngr();
}

void CScene::SoundAllStop() {
    this->StopBGM(0);
    this->InitBGM();
    this->SeAllStop();
}

void CScene::InitLooSeMngr() {
    BindSoundScratch(loop_se_stack, loop_se_buff, "SceneLoopSe");
    loop_se.Initialize();
    loop_se.Create(0x30, &loop_se_stack);
    loop_se.Clear();
}

CScene::BGM_INFO *CScene::GetActiveBgmInfo() {
    return &bgm[bgm_no];
}

void CScene::PlayBGM(int bgm_no, int vol, float volf) {
    if (skip_play_bgm != 0) {
        skip_play_bgm = 0;
    } else {
        BGM_INFO *info = GetActiveBgmInfo();

        if (info->play_no != bgm_no) {
            StopBGM(info->play_no);
        }

        info->vol = vol;
        info->volf = volf;

        if (info->vol < 0) {
            info->vol = sndGetSeDefVol(info->snd_id, bgm_no);
        }

        int play_vol = sndVolLimit(static_cast<int>(static_cast<float>(info->vol) * volf));

        if (play_vol < 0) {
            play_vol = 1;
        }

        sndSePlayV(info->snd_id, bgm_no, play_vol, 0);
        info->play_no = bgm_no;
        info->fade_speed = 0.0f;
    }
}

void CScene::PauseBGM() {
    BGM_INFO *info = GetActiveBgmInfo();

    if (info->play_no >= 0) {
        sndSePause(info->snd_id, info->play_no);
    }
}

void CScene::RePlayBGM() {
    BGM_INFO *info = GetActiveBgmInfo();

    if (info->play_no >= 0) {
        sndSePlay(info->snd_id, info->play_no, 0);
    }
}

void CScene::StopBGM(int play_no) {
    BGM_INFO *info = GetActiveBgmInfo();
    sndSeStop(info->snd_id, play_no, 0);
    sndStopVoice(0);
    info->play_no = play_no;
    info->fade_volf = 1.0f;
    info->fade_speed = 0.0f;
}

void CScene::SetVolBGM(int vol) {
    BGM_INFO *info = GetActiveBgmInfo();

    if (vol < 0) {
        vol = sndGetSeDefVol(info->snd_id, info->play_no);
    }

    if (vol != info->vol) {
        sndSetSeVol(info->snd_id, info->play_no, vol, 0);
        info->vol = vol;
        info->volf = 1.0f;
    }
}

int CScene::GetVolBGM() {
    return GetActiveBgmInfo()->vol;
}

int CScene::GetBGMState() {
    BGM_INFO *info = GetActiveBgmInfo();
    return sndGetSeStatus(info->snd_id, info->play_no);
}

void CScene::SetVolfBGM(float rate) {
    BGM_INFO *info = GetActiveBgmInfo();
    info->volf = rate;
    int vol = fptosi(info->fade_volf * (info->master_volf * (static_cast<float>(info->vol) * rate)));

    if (vol > 0x7F) {
        vol = 0x7F;
    }

    sndSetSeVol(info->snd_id, info->play_no, vol, 0);
}

float CScene::GetVolfBGM() {
    return GetActiveBgmInfo()->volf;
}

void CScene::FadeOutBGM(int frames) {
    BGM_INFO *info = GetActiveBgmInfo();
    info->fade_speed = -info->fade_volf / static_cast<float>(frames);
}

void CScene::FadeInBGM(int frames) {
    BGM_INFO *info = GetActiveBgmInfo();
    info->fade_speed = 1.0f / static_cast<float>(frames);
    info->fade_volf = 0.0f;
    SetVolfBGM(info->fade_volf * info->volf);
}

void CScene::AutoChangeBGMVol(int enabled) {
    GetActiveBgmInfo()->time_vol = enabled;
}

void CScene::GetActiveBgmStatus(BGM_STATUS *status) {

    CScene     *scene = this;
    BGM_STATUS *out = status;
    BGM_INFO   *info = scene->GetActiveBgmInfo();
    out->state = scene->GetBGMState();
    out->load_no = info->load_no;
    out->master_volf = info->master_volf;
    out->vol = info->vol;
    out->time_vol = info->time_vol;
    out->volf = info->volf;
    out->play_no = info->play_no;
}

void CScene::SetActiveBgmStatus(BGM_STATUS *status) {
    BGM_INFO   *info = GetActiveBgmInfo();
    BGM_STATUS *saved = status;
    info->play_no = saved->play_no;
    info->master_volf = saved->master_volf;
    info->vol = saved->vol;
    info->time_vol = saved->time_vol;
    info->volf = saved->volf;

    if (info->time_vol != 0) {
        info->volf = GetTimeBgmVolf();
    }

    if (saved->state == 1) {
        PlayBGM(info->play_no, info->vol, info->volf);
    }

    if (saved->state == 2) {
        PlayBGM(info->play_no, info->vol, info->volf);
        PauseBGM();
    }

    if (saved->state <= 0) {
        StopBGM(info->play_no);
    }

    SetVolfBGM(info->volf);
    StepSnd();
    sndStep(2.0f);
}

void CScene::PlayEnvBGM(int play_no, float vol) {
    if (env_bgm_no != play_no) {
        env_bgm_volf = vol;
        env_bgm_vol = env_bgm_volf;
        sndSePlayVf(se_env_id, play_no, env_bgm_vol, 0);
        env_bgm_no = play_no;
    }
}

void CScene::SetEnvBGMVol(float vol) {
    env_bgm_volf = vol;

    if (env_bgm_no >= 0 && env_bgm_vol != vol) {
        env_bgm_vol = vol;
        sndSetSeVolf(se_env_id, env_bgm_no, env_bgm_vol, 0);
    }
}

float CScene::GetEnvBGMVol() {
    return env_bgm_volf;
}

void CScene::StopEnvBGM() {
    int play_no = env_bgm_no;

    if (play_no >= 0) {
        sndSeStop(se_env_id, play_no, 0);
        env_bgm_no = -1;
    }
}

void CScene::AutoChangeEnvBGM(int enable) {
    env_bgm_auto = enable;
}

void CScene::AutoChangeEnvOffset(int offset) {
    env_bgm_offset = offset;
}

void CScene::PlayEnvBgm() {
    SND_FILE_INFO *entry = SearchSndDataID(snd_file_id);

    if (entry != nullptr) {
        s16 env_bgm = entry->env_bgm;

        if (env_bgm >= 0) {
            PlayEnvBGM(static_cast<int>(env_bgm), 1.0f);
            return;
        }

        AutoChangeEnvBGM(1);
        env_bgm_vol = -1.0f;
        SetEnvBGMVol(static_cast<float>(entry->env_vol) / 127.0f);
    }
}

int CScene::GetSeSrcID(int key) {
    for (int i = 0; i < 16; i++) {
        if (se_src_no[i] == key) {
            return se_src_id[i];
        }
    }

    return -1;
}

int CScene::CheckLoadBGM(int bgm_no) {
    BGM_INFO *info = GetActiveBgmInfo();

    if (bgm_no < 0) {
        return 0;
    }

    return bgm_no != info->load_no;
}

int CScene::CheckLoadSeSrc(int key) {
    if (key < 0) {
        return 0;
    }

    for (int i = 0; i < 16; i++) {
        if (se_src_no[i] == key) {
            return 0;
        }
    }

    return 1;
}

int CScene::CheckLoadSeEnv(int no) {
    if (no < 0) {
        return 0;
    }

    return se_env_no != no;
}

int CScene::CheckLoadSeBattle(int no) {
    if (no < 0) {
        return 0;
    }

    return se_battle_no != no;
}

int CScene::CheckLoadSeBase(int no) {
    if (no < 0) {
        return 0;
    }

    return se_base_no != no;
}

SND_FILE_INFO *CScene::SearchSndDataID(int id) {
    int low = 0;
    int high = snd_file_num - 1;

    while (low < high) {
        int mid = (low + high) / 2;

        if (snd_file[mid].id < id) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }

    if (snd_file[low].id != id) {
        return nullptr;
    }

    return &snd_file[low];
}

int CScene::GetDefBgmNo(int id) {
    SND_FILE_INFO *info = SearchSndDataID(id);

    if (info != nullptr) {
        return info->bgm_no;
    }

    return -1;
}

namespace {
int LoadSoundBanks(CScene *scene, int snd_file_id, std::span<u8> buff) {
    SND_FILE_INFO *entry = {};
    s16            se_base_no = {};
    s16            se_battle_no = {};
    s16            se_env_no = {};
    s16            first_se_src_no = {};
    s16            se_src = {};
    int            needs_reload = {};
    int            i = {};
    int            j = {};

    if (scene->skip_load_sound != 0) {
        scene->skip_load_sound = 0;
        return 0;
    }

    dc2::log::PrintGame("load sound %d\n", snd_file_id);
    entry = scene->SearchSndDataID(snd_file_id);

    if (entry == nullptr) {
        return 0;
    }

    se_base_no = entry->se_base;

    if (se_base_no < 0) {
        scene->InitSeBas();
    } else if (se_base_no != SND_FILE_NO_KEEP) {
        scene->LoadSeBase(se_base_no, buff);
    }

    se_battle_no = entry->se_battle;

    if (se_battle_no < 0) {
        scene->InitSeBattle();
    } else if (se_battle_no != SND_FILE_NO_KEEP) {
        scene->LoadSeBattle(se_battle_no, buff);
    }

    se_env_no = entry->se_env;

    if (se_env_no < 0) {
        scene->InitSeEnv();
    } else if (se_env_no != SND_FILE_NO_KEEP) {
        scene->LoadSeEnv(se_env_no, buff);
    }

    first_se_src_no = entry->se_src[0];

    if (first_se_src_no != SND_FILE_NO_KEEP) {
        if (first_se_src_no < 0) {
            scene->InitSeSrc();
        } else {

            needs_reload = 0;

            for (i = 0; i < 8; i++) {
                s16 no = entry->se_src[i];

                if ((no >= 0) && (no != scene->se_src_no[i])) {
                    needs_reload = 1;
                }
            }

            if (needs_reload != 0) {
                scene->InitSeSrc();

                for (j = 0; j < 8; j++) {
                    se_src = entry->se_src[j];

                    if (se_src >= 0) {
                        scene->LoadSeSrc(se_src, buff);
                    }
                }
            }
        }
    }

    sndSetReverb(1, static_cast<int>(entry->reverb_type), static_cast<int>(entry->reverb_depth));
    dc2::log::PrintGame("Reverb %d %d\n", entry->reverb_type, entry->reverb_depth);
    scene->snd_file_id = snd_file_id;
    scene->PlayEnvBgm();
    return 1;
}
} // namespace

int CScene::LoadSound(int snd_file_id, std::span<u8> buff) {
    if (!SoundDestinationAligned(buff)) {
        return 0;
    }
    return LoadSoundBanks(this, snd_file_id, buff);
}

int CScene::LoadBGM(int load_no, std::span<u8> buff) {
    if (skip_load_bgm != 0) {
        skip_load_bgm = 0;
        return 0;
    }
    if (CheckLoadBGM(load_no) == 0) {
        return 0;
    }
    if (!SoundDestinationAligned(buff)) {
        return 0;
    }
    std::string path = GetBgmFile(load_no);
    return LoadFile2(path.data(), buff, nullptr, LOAD_FILE_READ) != 0
               ? LoadBGMPack(load_no, reinterpret_cast<u32 *>(buff.data()))
               : 0;
}

int CScene::LoadSeSrc(int no, std::span<u8> buff) {
    if (CheckLoadSeSrc(no) == 0) {
        return 0;
    }
    if (!SoundDestinationAligned(buff)) {
        return 0;
    }
    std::string path = GetSeSrcFile(no);
    return LoadFile2(path.data(), buff, nullptr, LOAD_FILE_READ) != 0
               ? LoadSeSrcPack(no, reinterpret_cast<u32 *>(buff.data()))
               : 0;
}

int CScene::LoadSeEnv(int no, std::span<u8> buff) {
    if (CheckLoadSeEnv(no) == 0) {
        return 0;
    }
    if (!SoundDestinationAligned(buff)) {
        return 0;
    }
    std::string path = GetSeEnvFile(no);
    return LoadFile2(path.data(), buff, nullptr, LOAD_FILE_READ) != 0
               ? LoadSeEnvPack(no, reinterpret_cast<u32 *>(buff.data()))
               : 0;
}

int CScene::LoadSeBattle(int no, std::span<u8> buff) {
    if (CheckLoadSeBattle(no) == 0) {
        return 0;
    }
    if (!SoundDestinationAligned(buff)) {
        return 0;
    }
    std::string path = GetSeBattleFile(no);
    return LoadFile2(path.data(), buff, nullptr, LOAD_FILE_READ) != 0
               ? LoadSeBattlePack(no, reinterpret_cast<u32 *>(buff.data()))
               : 0;
}

int CScene::LoadSeBase(int no, std::span<u8> buff) {
    if (CheckLoadSeBase(no) == 0) {
        return 0;
    }
    if (!SoundDestinationAligned(buff)) {
        return 0;
    }
    std::string path = GetSeBaseFile(no);
    return LoadFile2(path.data(), buff, nullptr, LOAD_FILE_READ) != 0
               ? LoadSeBasePack(no, reinterpret_cast<u32 *>(buff.data()))
               : 0;
}

int CScene::LoadBGMPack(int load_no, u32 *buff) {
    BGM_INFO *info = GetActiveBgmInfo();

    if (CheckLoadBGM(load_no) == 0) {
        return 0;
    }

    StopBGM(0);
    InitBGM();
    info->stack.stReset();
    info->snd_id = sndLoadSound(info->port, buff, &info->stack);

    if (static_cast<int>(info->snd_id) < 0) {
        return 0;
    }

    info->load_no = load_no;
    return 1;
}

/**
 *
 * Returns the first free map object sound effect bank slot of a scene, or -1 when all are used.
 *
 */
static inline int SearchFreeSeSrc(CScene *scene) {
    for (int index = 0; index < 16; index++) {
        if (scene->se_src_no[index] < 0) {
            return index;
        }
    }

    return -1;
}

int CScene::LoadSeSrcPack(int pack_no, u32 *buffer) {
    if (CheckLoadSeSrc(pack_no) == 0) {
        return 0;
    }

    int slot = SearchFreeSeSrc(this);

    if (slot < 0) {
        return 0;
    }
    se_src_id[slot] = sndLoadSound(SND_PORT_OB, buffer, &se_src_stack);
    se_src_no[slot] = pack_no;
    return 1;
}

int CScene::LoadSeEnvPack(int pack_no, u32 *buffer) {
    if (CheckLoadSeEnv(pack_no) == 0) {
        return 0;
    }

    se_env_stack.stReset();
    InitSeEnv();
    se_env_id = sndLoadSound(SND_PORT_ENV, buffer, &se_env_stack);

    if (se_env_id < 0) {
        return 0;
    }

    se_env_no = pack_no;
    return 1;
}

int CScene::LoadSeBattlePack(int pack_no, u32 *buffer) {
    if (CheckLoadSeBattle(pack_no) == 0) {
        return 0;
    }

    InitSeBattle();
    se_battle_id = sndLoadSound(SND_PORT_BATTLE, buffer, &se_battle_stack);

    if (se_battle_id < 0) {
        return 0;
    }

    se_battle_no = pack_no;
    return 1;
}

int CScene::LoadSeBasePack(int pack_no, u32 *buffer) {
    if (CheckLoadSeBase(pack_no) == 0) {
        return 0;
    }

    InitSeBas();
    se_base_id = sndLoadSound(SND_PORT_BASE, buffer, &se_base_stack);

    if (se_base_id < 0) {
        return 0;
    }

    se_base_no = pack_no;
    return 1;
}

void CScene::PrePlaySeSrc() {
    se_src_play[0].se_no = -1;
    se_src_play[0].num = 0;
    se_src_play[1].se_no = -1;
    se_src_play[1].num = 0;
    se_src_play[2].se_no = -1;
    se_src_play[2].num = 0;
    se_src_play[3].se_no = -1;
    se_src_play[3].num = 0;
}

void CScene::PlaySeSrc(int no, float vol, float pan) {
    SE_SRC_PLAY_INFO *slot = {};
    int               i = {};

    if (!(vol <= 0.0)) {
        slot = nullptr;

        for (i = 0; i < 4; i++) {
            if (se_src_play[i].se_no == no) {
                slot = &se_src_play[i];
                break;
            }
        }

        if (slot == nullptr) {
            for (i = 0; i < 4; i++) {
                if (se_src_play[i].se_no < 0) {
                    slot = &se_src_play[i];
                    break;
                }
            }
        }

        if (slot != nullptr) {
            slot->se_no = no;

            if (slot->num < 16) {
                slot->vol[slot->num] = vol;
                slot->pan[slot->num] = pan;
                slot->num++;
            }
        }
    }
}

int CScene::check_se_play(int id) {
    int i = {};

    if (id < 0) {
        return 0;
    }

    for (i = 0; i < 4; i++) {
        if (id == se_src_play_no[i]) {
            se_src_play_flag[i] = 1;
            return 1;
        }
    }

    for (i = 0; i < 4; i++) {
        if (se_src_play_no[i] < 0) {
            se_src_play_no[i] = id;
            se_src_play_flag[i] = 1;
            return 0;
        }
    }

    return -1;
}

float CScene::GetTimeBgmVolf() {
    float ratio[4];
    CMap *map = GetMap(active_map);

    if (map != nullptr) {
        map->GetLightingRatio(ratio);

        if (ratio[2] <= 0.0f) {
            return 1.0f;
        }

        float vol = ratio[0];
        float other = ratio[1];

        if (vol > other) {
            vol = vol > ratio[3] ? vol : ratio[3];
        } else {
            vol = other > ratio[3] ? other : ratio[3];
        }

        return vol;
    }

    return 1.0f;
}

void CScene::StepSnd() {
    BGM_INFO *bgm_info = GetActiveBgmInfo();
    float     fade = bgm_info->fade_volf;

    if (bgm_info->fade_speed != 0.0f) {
        fade += bgm_info->fade_speed;

        if (!(fade <= 1.0f)) {
            bgm_info->fade_speed = 0.0f;
            fade = 1.0f;
        }

        if (fade < 0.0f) {
            bgm_info->fade_speed = 0.0f;
            fade = 0.0f;
        }

        bgm_info->fade_volf = fade;
        SetVolfBGM(GetVolfBGM());
    }

    if (bgm_info->time_vol != 0) {
        SetVolfBGM(GetTimeBgmVolf());
    }

    if (env_bgm_auto != 0) {
        CMap *map = GetMap(active_map);

        if (map != nullptr) {
            int env_no = env_bgm_offset + map->GetNowTimeBand();

            if (env_no != env_bgm_no) {
                StopEnvBGM();
                PlayEnvBGM(env_no, env_bgm_volf);
            }
        }
    }

    SetEnvBGMVol(env_bgm_volf);

    for (int i = 0; i < 4; i++) {
        se_src_play_flag[i] = 0;
    }

    for (int i = 0; i < 4; i++) {
        int se_no = se_src_play[i].se_no;

        if (se_no >= 0) {
            int playing = check_se_play(se_no);

            if (playing >= 0) {
                u32 snd_id = GetSeSrcID(se_no);

                if (playing == 0) {
                    sndSePlayV(snd_id, 0, 0, se_no);
                }

                int   n = {};
                float volume = 0.0f;

                for (n = 0; n < se_src_play[i].num; n++) {
                    volume += se_src_play[i].vol[n];
                }

                float pan = 0.0f;

                for (n = 0; n < se_src_play[i].num; n++) {
                    pan += se_src_play[i].pan[n] * se_src_play[i].vol[n] / volume;
                }

                if (!(volume <= 1.0f)) {
                    volume = 1.0f;
                }

                sndSetSeVolf(snd_id, 0, volume, se_no);

                if (!(pan <= 1.0f)) {
                    pan = 1.0f;
                }

                if (pan < -1.0f) {
                    pan = -1.0f;
                }

                sndSetSePanf(snd_id, 0, pan, se_no);
            }
        }
    }

    for (int i = 0; i < 4; i++) {
        if (se_src_play_flag[i] == 0 && se_src_play_no[i] >= 0) {
            u32 snd_id = GetSeSrcID(se_src_play_no[i]);
            sndSeStop(snd_id, 0, se_src_play_no[i]);
            se_src_play_no[i] = -1;
        }
    }

    loop_se.Step();
}

void CScene::StopSeSrc() {
    for (int i = 0; i < 4; i++) {
        int id = se_src_play[i].se_no;

        if (id >= 0) {
            int playing = check_se_play(id);

            if (playing >= 0) {
                u32 snd_id = GetSeSrcID(id);

                if (playing != 0) {
                    sndSeStop(snd_id, 0, id);
                }
            }
        }
    }

    PrePlaySeSrc();
}

void CScene::PlayMapSeSrc() {
    CMap *active_maps[4];
    int   keys[0x40];
    float volumes[0x40];
    float pans[0x40];
    int   active_map_count = GetActiveMap(active_maps, 4);

    for (int i = 0; i < active_map_count; i++) {
        CMap *map = active_maps[i];

        if (map != nullptr) {
            int count = map->GetSeSrcVolPan(keys, volumes, pans, 0x40);

            for (int j = 0; j < count; j++) {
                PlaySeSrc(keys[j], volumes[j], pans[j]);
            }
        }
    }
}

void CScene::SePlayOpenDoor(int door_type, float *pos) {
    door_type = door_type * 2 + 0x3C;
    sndSePlay(se_base_id, door_type, 0);
}

void CScene::SePlayCloseDoor(int door_type, float *pos) {
    door_type = door_type * 2 + 0x3D;
    sndSePlay(se_base_id, door_type, 0);
}

void CScene::SePlayFoot(int ground, int foot, float *position) {
    float volume = {};
    float pan = {};
    float far_distance = 1200.0f;
    float near_distance = 160.0f;
    sndGetVolPan(&volume, &pan, position, near_distance, far_distance);
    sndSePlayVPf(se_base_id, foot + ground * 2, volume, pan, 0);
}

namespace {
using Json = nlohmann::json;

/**
 * Reads a bounded integer field from a semantic scene sound table.
 */
s16 SceneInteger(const Json &value) {
    if (!value.is_number_integer()) {
        throw std::runtime_error("scene audio field requires an integer");
    }
    if (value.is_number_unsigned() && value.get<std::uint64_t>() > static_cast<std::uint64_t>(std::numeric_limits<s16>::max())) {
        throw std::runtime_error("scene audio unsigned integer exceeds its range");
    }
    const auto integer = value.get<std::int64_t>();
    if (integer < std::numeric_limits<s16>::min() || integer > std::numeric_limits<s16>::max()) {
        throw std::runtime_error("scene audio integer exceeds its range");
    }
    return static_cast<s16>(integer);
}

/**
 * Tries complete scene sound documents before committing any gameplay table rows.
 */
template <typename Record, typename Decode>
std::optional<std::vector<Record>> SceneRows(char *source, int size, const char *kind, std::size_t capacity, Decode decode) {
    std::vector<std::string> candidates;
    if (const auto path = DataReadBufferPath(source)) {
        candidates = AudioDocuments(*path);
    } else if (source && size > 0) {
        candidates.emplace_back(source, static_cast<std::size_t>(size));
    }
    std::string error = "scene sound document missing";
    for (const auto &text : candidates) {
        try {
            const auto document = Json::parse(text);
            if (document.at("schema_version") != 1 || document.at("kind") != kind || !document.at("rows").is_array() || document.at("rows").size() > capacity) {
                throw std::runtime_error("unsupported scene sound table schema");
            }
            std::vector<Record> rows;
            for (const auto &row : document.at("rows")) {
                rows.push_back(decode(row));
            }
            return rows;
        } catch (const std::exception &exception) {
            error = exception.what();
        }
    }
    CT_LOG_ERROR(Audio, "scene audio: {}", error);
    return std::nullopt;
}

/**
 * Copies a fixed-size numeric routing field from its JSON array.
 */
template <std::size_t Count>
void SceneArray(const Json &row, const char *name, s16 (&destination)[Count]) {
    const auto &values = row.at(name);
    if (!values.is_array() || values.size() != Count) {
        throw std::runtime_error("invalid scene sound routing array");
    }
    for (std::size_t index = 0; index < Count; ++index) {
        destination[index] = SceneInteger(values[index]);
    }
}

/**
 * Formats a sound resource number with the game's leading zero convention.
 */
std::string SoundNumber(int number) {
    const std::string digits = std::to_string(number);
    return (number < 10 ? "00" : number < 100 ? "0"
                                              : "") +
           digits;
}
} // namespace

std::string CScene::GetBgmFile(int number) {
    return "snd2/bgm/bg_" + SoundNumber(number) + ".sound.json";
}

std::string CScene::GetSeSrcFile(int number) {
    return "snd2/ob/ob_" + SoundNumber(number) + ".sound.json";
}

std::string CScene::GetSeEnvFile(int number) {
    return "snd2/env/sr_" + SoundNumber(number) + ".sound.json";
}

std::string CScene::GetSeBaseFile(int number) {
    return "snd2/bs/bs_" + SoundNumber(number) + ".sound.json";
}

std::string CScene::GetSeBattleFile(int number) {
    return "snd2/fg/fg_" + SoundNumber(number) + ".sound.json";
}

std::optional<std::string> CScene::GetDefEventSeFile(int id) {
    const auto *entry = SearchSndDataID(id);
    if (!entry) {
        return std::nullopt;
    }
    return "snd2/event/ev_" + SoundNumber(entry->event_se[0]) + "_" + SoundNumber(entry->event_se[1]) + ".sound.json";
}

void CScene::LoadSndRevInfo(char *source, int size) {
    const auto rows = SceneRows<SND_REV_INFO>(source, size, "scene_reverb", std::size(snd_rev), [](const Json &row) {
        SND_REV_INFO record{};
        record.id = SceneInteger(row.at("id"));
        record.type = SceneInteger(row.at("type"));
        record.depth = SceneInteger(row.at("depth"));
        return record;
    });
    if (rows) {
        std::copy(rows->begin(), rows->end(), std::begin(snd_rev));
        snd_rev_num = static_cast<int>(rows->size());
    }
}

void CScene::LoadSndFileInfo(char *source, int size) {
    const auto rows = SceneRows<SND_FILE_INFO>(source, size, "scene_sound_routes", std::size(snd_file), [this](const Json &row) {
        SND_FILE_INFO record{};
        record.id = SceneInteger(row.at("id"));
        record.bgm_no = SceneInteger(row.at("bgm_no"));
        record.se_base = SceneInteger(row.at("se_base"));
        record.se_battle = SceneInteger(row.at("se_battle"));
        record.se_env = SceneInteger(row.at("se_env"));
        record.env_bgm = SceneInteger(row.at("env_bgm"));
        record.env_vol = SceneInteger(row.at("env_vol"));
        SceneArray(row, "se_src", record.se_src);
        SceneArray(row, "event_se", record.event_se);
        const auto reverb_id = SceneInteger(row.at("reverb_id"));
        for (int index = 0; index < snd_rev_num; ++index) {
            if (snd_rev[index].id == reverb_id) {
                record.reverb_type = static_cast<u8>(snd_rev[index].type);
                record.reverb_depth = static_cast<u8>(snd_rev[index].depth);
                break;
            }
        }
        return record;
    });
    if (rows) {
        std::copy(rows->begin(), rows->end(), std::begin(snd_file));
        snd_file_num = static_cast<int>(rows->size());
    }
}
