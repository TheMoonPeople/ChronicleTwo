#include "common.h"
#include "map.hpp"
#include "mg_memory.hpp"
#include "scenesnd.hpp"
#include <cstring>
#include <cstdio>
#include "sound.hpp"
#include "dataread.hpp"

extern "C" int fptosi(float value);
extern char at_1011__3[];
extern char at_1012__3[];
extern char at_1013__3[];
extern char at_1018__6[];
extern char at_1023__3[];
extern char at_1028__6[];
extern char at_1033__5[];
extern char at_1038__4[];
extern char at_1132__4[];
extern char at_1194[];
extern char at_1195[];
extern char at_1766__2[];
struct LineBreakPair {
    s8 chars[2];
};
extern LineBreakPair at_1615__2;

// Code (.text)
void CScene::BGM_INFO::Init() {
    snd_id = -1;
    load_no = -1;
    fade_speed = 0.0f;
    unk_c = 1.0f;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenesnd", InitSeSrc__6CSceneFv);
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
void CScene::SeAllStop(void) {
    this->StopSeSrc();
    sndSeAllStop(-1);
    this->InitLooSeMngr();
}
void CScene::SoundAllStop(void) {
    this->StopBGM(0);
    this->InitBGM();
    this->SeAllStop();
}
void CScene::InitLooSeMngr() {
    loop_se_stack.stSetBuffer((u_long128 *)loop_se_buff, 0x200);
    loop_se.Initialize();
    loop_se.Create(0x30, &loop_se_stack);
    loop_se.Clear();
}
CScene::BGM_INFO *CScene::GetActiveBgmInfo() {
    return &bgm[bgm_no];
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenesnd", PlayBGM__6CSceneFiif);
void CScene::PauseBGM(void) {
    BGM_INFO *info = GetActiveBgmInfo();
    if (info->play_no >= 0) {
        sndSePause(info->snd_id, info->play_no);
    }
}
void CScene::RePlayBGM(void) {
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
    if (vol < 0)
        vol = sndGetSeDefVol(info->snd_id, info->play_no);
    if (vol != info->vol) {
        sndSetSeVol(info->snd_id, info->play_no, vol, 0);
        info->vol = vol;
        info->volf = 1.0f;
    }
}
int CScene::GetVolBGM(void) {
    return GetActiveBgmInfo()->vol;
}
int CScene::GetBGMState(void) {
    BGM_INFO *info = GetActiveBgmInfo();
    return sndGetSeStatus(info->snd_id, info->play_no);
}
void CScene::SetVolfBGM(float rate) {
    BGM_INFO *info = GetActiveBgmInfo();
    info->volf = rate;
    int vol = fptosi(info->fade_volf * (info->unk_c * ((float)info->vol * rate)));
    if (vol > 0x7F)
        vol = 0x7F;
    sndSetSeVol(info->snd_id, info->play_no, vol, 0);
}
float CScene::GetVolfBGM(void) {
    return GetActiveBgmInfo()->volf;
}
void CScene::FadeOutBGM(int frames) {
    BGM_INFO *info = GetActiveBgmInfo();
    info->fade_speed = -info->fade_volf / (float)frames;
}
void CScene::FadeInBGM(int frames) {
    BGM_INFO *info = GetActiveBgmInfo();
    info->fade_speed = 1.0f / (float)frames;
    info->fade_volf = 0.0f;
    SetVolfBGM(info->fade_volf * info->volf);
}
void CScene::AutoChangeBGMVol(int enabled) {
    GetActiveBgmInfo()->time_vol = enabled;
}
void CScene::GetActiveBgmStatus(BGM_STATUS *status) {

    CScene *scene = (CScene *)this;
    BGM_STATUS *out = status;
    BGM_INFO *info = scene->GetActiveBgmInfo();
    out->state = scene->GetBGMState();
    out->load_no = info->load_no;
    out->unk_c = info->unk_c;
    out->vol = info->vol;
    out->time_vol = info->time_vol;
    out->volf = info->volf;
    out->play_no = info->play_no;
}
void CScene::SetActiveBgmStatus(BGM_STATUS *status) {
    BGM_INFO *info = GetActiveBgmInfo();
    BGM_STATUS *saved = status;
    info->play_no = saved->play_no;
    info->unk_c = saved->unk_c;
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
            PlayEnvBGM((int)env_bgm, 1.0f);
            return;
        }
        AutoChangeEnvBGM(1);
        env_bgm_vol = -1.0f;
        SetEnvBGMVol((float)entry->env_vol / 127.0f);
    }
}
int CScene::GetSeSrcID(int key) {
    for (int i = 0; i < 16; i++) {
        if (se_src_no[i] == key)
            return se_src_id[i];
    }
    return -1;
}
void GetNumber3(char *out, int number) {
    char digits[8];
    out[0] = 0;
    if (number < 10) {
        strcat(out, at_1011__3);
    } else if (number < 100) {
        strcat(out, at_1012__3);
    }
    sprintf(digits, at_1013__3, number);
    strcat(out, digits);
}
void CScene::GetBgmFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, at_1018__6, digits);
}
void CScene::GetSeSrcFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, at_1023__3, digits);
}
void CScene::GetSeEnvFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, at_1028__6, digits);
}
void CScene::GetSeBaseFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, at_1033__5, digits);
}
void CScene::GetSeBattleFile(char *path, int number) {
    char digits[16];
    GetNumber3(digits, number);
    sprintf(path, at_1038__4, digits);
}
int CScene::CheckLoadBGM(int bgm_no) {
    BGM_INFO *info = GetActiveBgmInfo();
    if (bgm_no < 0) {
        return 0;
    }
    return bgm_no != info->load_no;
}
int CScene::CheckLoadSeSrc(int key) {
    if (key < 0)
        return 0;
    for (int i = 0; i < 16; i++) {
        if (se_src_no[i] == key)
            return 0;
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
        if (snd_file[mid].id < id)
            low = mid + 1;
        else
            high = mid;
    }

    if (snd_file[low].id != id)
        return 0;
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
    char bank_digits[16];
    char number_digits[16];
    if (entry == 0)
        return 0;
    GetNumber3(bank_digits, entry->event_se[0]);
    GetNumber3(number_digits, entry->event_se[1]);
    sprintf(path, at_1132__4, bank_digits, number_digits);
    return 1;
}
int CScene::LoadSound(int snd_file_id, u_long128 *buff) {

    CScene *scene = this;
    SND_FILE_INFO *entry;
    s16 se_base_no;
    s16 se_battle_no;
    s16 se_env_no;
    s16 firstSeSrcNo;
    s16 se_src;
    int needs_reload;
    int i;
    int j;

    if (scene->skip_load_sound != 0) {
        scene->skip_load_sound = 0;
        return 0;
    }
    printf(at_1194);
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
    firstSeSrcNo = entry->se_src[0];
    if (firstSeSrcNo != SND_FILE_NO_KEEP) {
        if (firstSeSrcNo < 0) {
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
    sndSetReverb(1, (int)entry->reverb_type, (int)entry->reverb_depth);
    printf(at_1195, entry->reverb_type, entry->reverb_depth);
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
    if (CheckLoadBGM(load_no) == 0)
        return 0;
    GetBgmFile(path, load_no);
    if (LoadFile2(path, buff, 0, 0) != 0)
        return LoadBGMPack(load_no, (u32 *)buff);
    return 0;
}
int CScene::LoadSeSrc(int no, u_long128 *buff) {
    char path[0x40];
    if (CheckLoadSeSrc(no) == 0) {
        return 0;
    }
    GetSeSrcFile(path, no);
    if (LoadFile2(path, buff, 0, 0) != 0) {
        return LoadSeSrcPack(no, (u32 *)buff);
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
        return LoadSeEnvPack(no, (u32 *)buff);
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
        return LoadSeBattlePack(no, (u32 *)buff);
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
        return LoadSeBasePack(no, (u32 *)buff);
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
    if ((int)info->snd_id < 0) {
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
    se_src_id[slot] = sndLoadSound(1, buffer, &se_src_stack);
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
    se_env_id = sndLoadSound(2, buffer, &se_env_stack);
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
    se_battle_id = sndLoadSound(9, buffer, &se_battle_stack);
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
    se_base_id = sndLoadSound(3, buffer, &se_base_stack);
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
    int i;
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
    if (id < 0)
        return 0;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenesnd", StepSnd__6CSceneFv);
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
    int keys[0x40];
    float volumes[0x40];
    float pans[0x40];
    int active_map_count = GetActiveMap(active_maps, 4);
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
extern "C" char *GetLine__FPPcPcPc__2(char **lines, char *cursor, char *end) {
    LineBreakPair line_break = at_1615__2;
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

    snd_rev_num = (u32)size >> 3;
    memcpy(snd_rev, src, size);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenesnd", LoadSndFileInfo__6CSceneFPci);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1011__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1012__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1013__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1018__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1023__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1028__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1033__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1038__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1132__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1194__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1195__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1766__2__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenesnd", at_1615__2__DATA);
