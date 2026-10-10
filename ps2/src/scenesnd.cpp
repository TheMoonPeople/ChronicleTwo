#include "common.h"
#include "mw_runtime.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "dataread.hpp"
#include "map.hpp"
#include "mg_memory.hpp"
#include "scenesnd.hpp"
#include "sound.hpp"

/**
 *
 * Pair of characters used to break a line of scene text.
 *
 */
struct LineBreakPair {
    s8 chars[2]; /**< Line break characters. */
};

// Code (.text)
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
    info->stack.stSetBuffer(info->buff, 0x40);
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

    se_src_stack.stSetBuffer(se_src_buff, 0x40);
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
    se_env_stack.stSetBuffer(se_env_buff, 0x40);
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
    se_battle_stack.stSetBuffer(se_battle_buff, 0x200);
    sndInitPort(9);
    InitSeEnv();
}

void CScene::InitSeBas() {
    sndSeAllStop(3);
    se_base_id = -1;
    se_base_no = -1;
    se_base_stack.stSetBuffer(se_base_buff, 0x200);
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
    loop_se_stack.stSetBuffer(loop_se_buff, 0x200);
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

        int play_vol = sndVolLimit((int) ((float) info->vol * volf));

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
    int vol = fptosi(info->fade_volf * (info->master_volf * ((float) info->vol * rate)));

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
    info->fade_speed = -info->fade_volf / (float) frames;
}

void CScene::FadeInBGM(int frames) {
    BGM_INFO *info = GetActiveBgmInfo();
    info->fade_speed = 1.0f / (float) frames;
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

    if (entry != NULL) {
        s16 env_bgm = entry->env_bgm;

        if (env_bgm >= 0) {
            PlayEnvBGM((int) env_bgm, 1.0f);
            return;
        }

        AutoChangeEnvBGM(1);
        env_bgm_vol = -1.0f;
        SetEnvBGMVol((float) entry->env_vol / 127.0f);
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

/**
 *
 * Formats a number as at least three decimal digits for an audio file name.
 *
 */
void GetNumber3(char *out, int number) {
    char digits[8];
    out[0] = 0;

    if (number < 10) {
        strcat(out, "00");
    } else if (number < 100) {
        strcat(out, "0");
    }

    sprintf(digits, "%d", number);
    strcat(out, digits);
}

void CScene::GetBgmFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, "snd2/bgm/BG_%s.snd", digits);
}

void CScene::GetSeSrcFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, "snd2/ob/OB_%s.snd", digits);
}

void CScene::GetSeEnvFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, "snd2/env/SR_%s.snd", digits);
}

void CScene::GetSeBaseFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, "snd2/bs/BS_%s.snd", digits);
}

void CScene::GetSeBattleFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, "snd2/fg/FG_%s.snd", digits);
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
        return 0;
    }

    return &snd_file[low];
}

int CScene::GetDefBgmNo(int id) {
    SND_FILE_INFO *info = SearchSndDataID(id);

    if (info != NULL) {
        return info->bgm_no;
    }

    return -1;
}

int CScene::GetDefEventSeFile(int id, char *path) {
    SND_FILE_INFO *entry = SearchSndDataID(id);
    char           bank_digits[16];
    char           number_digits[16];

    if (entry == 0) {
        return 0;
    }

    GetNumber3(bank_digits, entry->event_se[0]);
    GetNumber3(number_digits, entry->event_se[1]);
    sprintf(path, "snd2/event/EV_%s_%s.snd", bank_digits, number_digits);
    return 1;
}

int CScene::LoadSound(int snd_file_id, u_long128 *buff) {

    CScene        *scene = this;
    SND_FILE_INFO *entry;
    s16            se_base_no;
    s16            se_battle_no;
    s16            se_env_no;
    s16            first_se_src_no;
    s16            se_src;
    int            needs_reload;
    int            i;
    int            j;

    if (scene->skip_load_sound != 0) {
        scene->skip_load_sound = 0;
        return 0;
    }

    printf("load sound %d\n");
    entry = scene->SearchSndDataID(snd_file_id);

    if (entry == NULL) {
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

    sndSetReverb(1, (int) entry->reverb_type, (int) entry->reverb_depth);
    printf("Reverb %d %d\n", entry->reverb_type, entry->reverb_depth);
    scene->snd_file_id = snd_file_id;
    scene->PlayEnvBgm();
    return 1;
}

int CScene::LoadBGM(int load_no, u_long128 *buff) {
    char path[0x40];

    if (skip_load_bgm != 0) {
        skip_load_bgm = 0;
        return 0;
    }

    if (CheckLoadBGM(load_no) == 0) {
        return 0;
    }

    GetBgmFile(path, load_no);

    if (LoadFile2(path, buff, 0, 0) != 0) {
        return LoadBGMPack(load_no, (u32 *) buff);
    }

    return 0;
}

int CScene::LoadSeSrc(int no, u_long128 *buff) {
    char path[0x40];

    if (CheckLoadSeSrc(no) == 0) {
        return 0;
    }

    GetSeSrcFile(path, no);

    if (LoadFile2(path, buff, 0, 0) != 0) {
        return LoadSeSrcPack(no, (u32 *) buff);
    }

    return 0;
}

int CScene::LoadSeEnv(int no, u_long128 *buff) {
    char path[0x40];

    if (CheckLoadSeEnv(no) == 0) {
        return 0;
    }

    GetSeEnvFile(path, no);

    if (LoadFile2(path, buff, 0, 0) != 0) {
        return LoadSeEnvPack(no, (u32 *) buff);
    }

    return 0;
}

int CScene::LoadSeBattle(int no, u_long128 *buff) {
    char path[0x40];

    if (CheckLoadSeBattle(no) == 0) {
        return 0;
    }

    GetSeBattleFile(path, no);

    if (LoadFile2(path, buff, 0, 0) != 0) {
        return LoadSeBattlePack(no, (u32 *) buff);
    }

    return 0;
}

int CScene::LoadSeBase(int no, u_long128 *buff) {
    char path[0x40];

    if (CheckLoadSeBase(no) == 0) {
        return 0;
    }

    GetSeBaseFile(path, no);

    if (LoadFile2(path, buff, 0, 0) != 0) {
        return LoadSeBasePack(no, (u32 *) buff);
    }

    return 0;
}

int CScene::LoadBGMPack(int load_no, u32 *buff) {
    BGM_INFO *info = GetActiveBgmInfo();

    if (CheckLoadBGM(load_no) == 0) {
        return 0;
    }

    StopBGM(0);
    InitBGM();
    info->stack.stack_used = 0;
    info->stack.lock = 0;
    info->snd_id = sndLoadSound(info->port, buff, &info->stack);

    if ((int) info->snd_id < 0) {
        return 0;
    }

    info->load_no = load_no;
    return 1;
}

int CScene::LoadSeSrcPack(int pack_no, u32 *buffer) {
    if (CheckLoadSeSrc(pack_no) == 0) {
        return 0;
    }

    int slot;
    int index;

    for (index = 0; index < 16; index++) {
        if (se_src_no[index] < 0) {
            slot = index;
            goto slot_found;
        }
    }

    slot = -1;
slot_found:
    if (slot < 0) {
        return 0;
    }
    se_src_id[slot] = sndLoadSound((int) SND_PORT_OB, buffer, &se_src_stack);
    se_src_no[slot] = pack_no;
    return 1;
}

int CScene::LoadSeEnvPack(int pack_no, u32 *buffer) {
    if (CheckLoadSeEnv(pack_no) == 0) {
        return 0;
    }

    se_env_stack.stack_used = 0;
    se_env_stack.lock = 0;
    InitSeEnv();
    se_env_id = sndLoadSound((int) SND_PORT_ENV, buffer, &se_env_stack);

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
    se_battle_id = sndLoadSound((int) SND_PORT_BATTLE, buffer, &se_battle_stack);

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
    se_base_id = sndLoadSound((int) SND_PORT_BASE, buffer, &se_base_stack);

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
    SE_SRC_PLAY_INFO *slot;
    int               i;

    if (!(vol <= 0.0)) {
        slot = 0;

        for (i = 0; i < 4; i++) {
            if (se_src_play[i].se_no == no) {
                slot = &se_src_play[i];
                break;
            }
        }

        if (slot == 0) {
            for (i = 0; i < 4; i++) {
                if (se_src_play[i].se_no < 0) {
                    slot = &se_src_play[i];
                    break;
                }
            }
        }

        if (slot != 0) {
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
    int i;

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

    if (map != 0) {
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

        if (map != NULL) {
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

                int   n;
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

        if (map != 0) {
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
    float volume;
    float pan;
    float far_distance = 1200.0f;
    float near_distance = 160.0f;
    sndGetVolPan(&volume, &pan, position, near_distance, far_distance);
    sndSePlayVPf(se_base_id, foot + ground * 2, volume, pan, 0);
}

/**
 *
 * Reads one line of sound configuration fields and returns the following position.
 *
 */
static char *GetLine(char **lines, char *cursor, char *end) {
    LineBreakPair line_break = {
        {'\r', '\n'}
    };
    int line_index;
    int length;

    if (cursor < end) {
        line_index = 0;

        do {
            if (memcmp(cursor, &line_break.chars[0], 2) == 0) {
                cursor += 2;
                break;
            } else if (memcmp(cursor, &line_break.chars[0], 1) == 0) {
                cursor += 1;
                break;
            } else if (memcmp(cursor, &line_break.chars[1], 1) == 0) {
                cursor += 1;
                break;
            } else {
                length = 0;

                while (cursor < end) {
                    if (memcmp(cursor, &line_break.chars[0], 2) == 0 ||
                        memcmp(cursor, &line_break.chars[0], 1) == 0 ||
                        memcmp(cursor, &line_break.chars[1], 1) == 0) {
                        break;
                    }

                    s8 ch = *cursor;

                    if (ch == 9) {
                        cursor += 1;

                        if (lines[line_index + 1] != 0) {
                            *lines[line_index + 1] = 0;
                        }

                        break;
                    }

                    if (ch != 0x20 && lines[line_index] != 0) {
                        lines[line_index][length] = ch;
                        length += 1;
                    }

                    cursor += 1;
                }

                char *line = lines[line_index];

                if (line != 0) {
                    line_index += 1;
                    line[length] = 0;
                }
            }
        } while (cursor < end);
    }

    return cursor;
}

void CScene::LoadSndRevInfo(char *src, int size) {

    snd_rev_num = (u32) size >> 3;
    memcpy(snd_rev, src, size);
}

void CScene::LoadSndFileInfo(char *src, int size) {
    char  buffer[64][64];
    char *columns[65];
    char *end = src + size;
    char *cursor = src;
    int   i;

    for (i = 0; i < 64; i++) {
        columns[i] = buffer[i];
    }

    columns[i] = NULL;
    snd_file_num = 0;

    while (cursor < end) {
        cursor = GetLine(columns, cursor, end);

        if ((s8) columns[0][0] >= '0' && (s8) columns[0][0] < ':') {
            int            id = atoi(columns[0]);
            SND_FILE_INFO *entry = &snd_file[snd_file_num++];

            if (id < 0) {
                break;
            }

            entry->id = id;
            int   column = 4;
            char *file;
            file = columns[column++];

            if (file[0] != 'B') {
                entry->bgm_no = -1;
            } else {
                entry->bgm_no = atoi(file + 3);
            }

            if (file[0] == '*') {
                entry->bgm_no = SND_FILE_NO_KEEP;
            }

            file = columns[column++];

            if (file[0] != 'B') {
                entry->se_base = -1;
            } else {
                entry->se_base = atoi(file + 3);
            }

            if (file[0] == '*') {
                entry->se_base = SND_FILE_NO_KEEP;
            }

            file = columns[column++];

            if (file[0] != 'F') {
                entry->se_battle = -1;
            } else {
                entry->se_battle = atoi(file + 3);
            }

            if (file[0] == '*') {
                entry->se_battle = SND_FILE_NO_KEEP;
            }

            file = columns[column++];

            if (file[0] != 'S') {
                entry->se_env = -1;
            } else {
                entry->se_env = atoi(file + 3);
            }

            if (file[0] == '*') {
                entry->se_env = SND_FILE_NO_KEEP;
            }

            char *prefix = "\x8e\x9e\x8a\xd4\x95\xcf\x89\xbb*";
            int   prefix_length = strlen(prefix);
            char *environment = columns[column++];
            entry->env_bgm = 0;

            if (environment[0] == 'S') {
                entry->env_bgm = atoi(environment + 7);
                entry->env_vol = 0;
            } else if (strncmp(prefix, environment, prefix_length) == 0) {
                entry->env_bgm = -1;
                int volume = (int) (127.0f * (float) atof(environment + prefix_length));

                if (volume > 127) {
                    volume = 127;
                }

                entry->env_vol = volume;
            }

            for (int i = 0; i < 8; i++) {
                entry->se_src[i] = -1;
            }

            for (int i = 0; i < 6; i++) {
                char *source = columns[column++];

                if (source[0] != 'O') {
                    entry->se_src[i] = -1;
                } else {
                    entry->se_src[i] = atoi(source + 3);
                }

                if (source[0] == '*') {
                    entry->se_src[0] = SND_FILE_NO_KEEP;
                    break;
                }
            }

            char first[16];
            char second[16];
            file = columns[column++];

            if (file[0] != 'E') {
                entry->event_se[0] = -1;
                entry->event_se[1] = -1;
            } else {
                strncpy(first, file + 3, 3);
                first[3] = 0;
                strncpy(second, file + 7, 3);
                second[3] = 0;
                entry->event_se[0] = atoi(first);
                entry->event_se[1] = atoi(second);
            }

            s16 reverb_type = 0;
            s16 reverb_depth = 0;
            column += 5;
            char *reverb = columns[column];

            if (reverb[0] == 'R') {
                int reverb_id = atoi(reverb + 3);

                for (int i = 0; i < snd_rev_num; i++) {
                    if (reverb_id == snd_rev[i].id) {
                        reverb_type = snd_rev[i].type;
                        reverb_depth = snd_rev[i].depth;
                        break;
                    }
                }
            }

            entry->reverb_type = reverb_type;
            entry->reverb_depth = reverb_depth;
        }
    }
}
