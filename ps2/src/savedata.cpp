#include "common.h"
#include "savedata.hpp"
#include "menusystemdata.hpp"
#include "menuaqua.hpp"
#include <cstdlib>
#include <cstdio>
#include <cstring>

extern char at_453[0xB];

// Code (.text)
void InitSV_CONFIG_OPTION(SV_CONFIG_OPTION *config) {
    if (config != NULL) {
        memset(config, 0, sizeof(SV_CONFIG_OPTION));
        config->map = 1;
    }
}
void CSaveData::Initialize() {
    int i;
    printf(at_453, 0x40);
    memset(this, 0, sizeof(CSaveData));
    now_time = 12.0f;
    game_progress = 1;
    for (i = 0; i < 0x40; i++) {
        bit_flag[i] = 0;
    }
    for (i = 0; i < 0x80; i++) {
        short_flag[i] = 0;
    }
    map_no = -1;
    sub_map_no = -1;
    prev_map_no = -1;
    prev_sub_map_no = -1;
    area_no = -1;
    for (i = 0; i < 5; i++) {
        (&edit_data[i])->Initialize();
    }
    save_dungeon.Initialize();
    InitSV_CONFIG_OPTION(&config);
    user_data.Initialize();
    menu_system_data.MenuSystemDataInit();
    quest_data.Initialize();
    memset(&monster_book, 0, sizeof(monster_book));
    InitBitCtrl();
    memset(&tour, 0, sizeof(tour));
    tour.base_day = -1;
}
int CSaveData::CheckBitFlagNo(int bit) {
    if (bit < 0 || bit >= 0x800) {
        return 0;
    }
    return 1;
}
int CSaveData::SetBitFlag(int bit, int on) {
    if (CheckBitFlagNo(bit) == 0) {
        return 0;
    }
    int mask = 1;
    int index = bit / 32;
    mask <<= bit % 32;
    int old = bit_flag[index];
    int was_set = (mask & old) != 0;

    if (on) {
        bit_flag[index] = mask | old;
    } else {
        bit_flag[index] = ~mask & old;
    }
    return was_set;
}
int CSaveData::GetBitFlag(int bit) {
    if (CheckBitFlagNo(bit) == 0) {
        return 0;
    }
    int mask = 1;
    mask <<= bit % 32;
    u32 *word = &bit_flag[bit / 32];
    return (mask & *word) != 0;
}
s16 CSaveData::SetShortFlag(int index, short value) {
    if (index < 0 || index >= 0x80) {
        return 0;
    }
    int old = short_flag[index];
    short_flag[index] = value;
    return old;
}
short CSaveData::GetShortFlag(int index) {
    if (index < 0 || index >= 0x80) {
        return 0;
    }
    return short_flag[index];
}
void CSaveData::SetBuildPartsNum(int index, int value) {
    if (index < 0 || index >= 0x100) {
        return;
    }
    build_parts_num[index] = value;
    short *slot = &build_parts_num[index];
    if (*slot < 0) {
        *slot = 0;
    }
    if (*slot > 9999) {
        *slot = 9999;
    }
}
s16 CSaveData::GetBuildPartsNum(int index) {
    if (index < 0 || index >= 0x100) {
        return 0;
    }
    return build_parts_num[index];
}
short CSaveData::AddBuildPartsNum(int index, int delta) {
    if (index < 0 || index >= 0x100) {
        return 0;
    }
    build_parts_num[index] += delta;
    short *slot = &build_parts_num[index];
    if (*slot < 0) {
        *slot = 0;
    }
    if (*slot > 9999) {
        *slot = 9999;
    }
    return *slot;
}
CEditData *CSaveData::GetEditData(int index) {
    if (index < 0 || index >= 5) {
        return 0;
    }
    return &edit_data[index];
}
int CSaveData::GetPlaceEditPartsNum(int id) {
    int total = 0;
    for (int i = 0; i < 5; i++) {
        total += (&edit_data[i])->GetPartsNumID(id);
    }
    return total;
}
CMapFlagData *CSaveData::GetMapFlag(int index) {
    if (index < 0 || index >= 0x100) {
        return 0;
    }
    return &map_flag[index];
}
void CSaveData::InitBitCtrl() {
    bit_ctrl = 0;
}
u8 CSaveData::SetBitCtrl(int bits) {
    u8 previous = bit_ctrl;
    bit_ctrl |= bits & 0xFF;
    return previous;
}
void CSaveData::ResetBitCtrl(int bits) {
    bit_ctrl &= ~bits & 0xFF;
}
int CSaveData::GetBitCtrl() { return this->bit_ctrl; }
int CSaveData::GetItem(int a, int b) {
    return user_data.GetItem(a, b);
}
void CSaveData::ForceBootTour(int day, int type) {
    tour.base_day = day;
    tour.start_day = day;
    tour.finish_day = day - 0xA;
    tour.now_event = 1;
    tour.type = (signed char)type;
    tour.count = 0;
}
int CSaveData::CheckEventDay(int day) {
    if (tour.base_day < 0) {
        return -1;
    }
    return day - tour.base_day;
}
void CSaveData::CheckTourBoot(int day) {
    int next_type;
    int elapsed;
    if (tour.base_day >= 0) {
        elapsed = CheckEventDay(day);
        if (tour.now_event == 1) {
            if (elapsed % 10 > 2) {
                tour.now_event = 0;
                tour.finish_day = elapsed;
            }
            return;
        } else {
            if (elapsed % 10 > 2) {
                tour.now_event = 0;
                return;
            }
            if (0 <= tour.base_day) {
                int start = tour.start_day;
                int previous = tour.finish_day;
                if (start <= previous && previous < start + 3 && elapsed < start + 3) {
                    tour.now_event = 0;
                    return;
                }
            }
            tour.start_day = elapsed;
            tour.now_event = 1;
            tour.count = 0;
            next_type = tour.type + 1;
            if (GetBitFlag(0x1A8) != 0) {
                if (next_type >= 3) {
                    next_type = 1;
                }
            } else {
                next_type = 1;
                if (GetBitFlag(0x158) == 0) {
                    next_type = 0;
                }
            }
            tour.type = next_type;
            if (tour.type == 1) {
                CUserDataManager *user = &user_data;
                if (user != NULL) {
                    user->fish_tournament.ResetRecord();
                }
            }
            if (tour.type == 2) {
                AquaFishFatigueClear();
            }
        }
    }
}
int CSaveData::CheckNowTourEvent() {
    return tour.now_event;
}
int CSaveData::CheckNowTourType() {
    return (s8)tour.type;
}
s8 CSaveData::AddTourCountEtc(int delta) {
    tour.count += delta;
    if (tour.count < 0) {
        tour.count = 0;
    }
    if (tour.count > 100) {
        tour.count = 100;
    }
    return tour.count;
}
int CSaveData::GetTourCountEtc() {
    return tour.count;
}
void CSaveData::FinishTour() {
    tour.finish_day = day - tour.base_day;
    tour.now_event = 0;
    tour.count = 0;
}
void CSphidaData::Initialize() {
    memset(this, 0, sizeof(*this));
}
void CSphidaData::SetHorl(int hole) {
    now_hole = hole;
}
void CSphidaData::SetHorlScore(int total_score, int slot) {
    if (slot == -1) {
        slot = this->now_hole;
    }
    if (slot < 0 || slot > 8) {
        return;
    }
    this->hole_score[slot] = total_score;
}
int CSphidaData::GetNowHorl() {
    return now_hole;
}
int CSphidaData::GetHorlScore(int slot) {
    if (slot == -1) {
        int total = 0;
        for (int i = 0; i < SPHIDA_HOLE_MAX; i++) {
            total += hole_score[i];
        }
        return total;
    }
    if (slot > 8) {
        return 0;
    }
    return hole_score[slot];
}
void CSphidaData::ClearPlayerScore(int index) {
    if (index < 0 || index >= SPHIDA_PLAYER_MAX) {
        return;
    }
    memset(&player[index], 0, sizeof(SPHIDA_PLAYER_DATA));
    void *dst = GetPlayerData(index);
    void *src = GetPlayerData(index + 1);
    if (src != 0 && dst != 0) {
        memcpy(dst, src, sizeof(SPHIDA_PLAYER_DATA));
        ClearPlayerScore(index + 1);
    }
}
int CSphidaData::EnterScore() {
    int rank = -1;
    int i;
    int total_score = GetHorlScore(-1);
    SPHIDA_PLAYER_DATA *record;
    for (i = 0; i < 0x40; i++) {
        record = (SPHIDA_PLAYER_DATA *)GetPlayerData(i);
        if (record->total_score <= total_score) {
            for (int j = 0x3E; j >= i; j--) {
                SPHIDA_PLAYER_DATA *moved = (SPHIDA_PLAYER_DATA *)GetPlayerData(j);
                memcpy(moved + 1, moved, sizeof(SPHIDA_PLAYER_DATA));
            }
            rank = i;
            strcpy(record->name, player_name);
            record->unk_38 = 1;
            record->total_score = total_score;
            for (int k = 0; k < 9; k++) {
                record->hole_score[k] = hole_score[k];
            }
            record->password_key = rand() % 255;
            break;
        }
    }
    if (rank < 0) {
        return 0x64;
    }
    return rank;
}
SPHIDA_PLAYER_DATA *CSphidaData::GetPlayerData(int index) {
    if (index < 0 || index >= SPHIDA_PLAYER_MAX) {
        return 0;
    }
    return &player[index];
}
void CSphidaData::InitPlay() {
    now_hole = 0;
    memset(hole_score, 0, sizeof(hole_score) + sizeof(unk_145A));
    memset(player_name, 0, sizeof(player_name));
}
int GYORACE_DATA::IsUsed() {
    return (fish.item_no < 2) ^ 1;
}
void GYORACE_DATA::Init() {
    memset(this, 0, sizeof(*this));
}
void CGyoRaceData::Initialize() {
    memset(this, 0, sizeof(*this));
}
int CGyoRaceData::SearchSpace() {
    for (int i = 0; i < 0x40; i++) {
        if (!(0 < data[i].fish.item_no)) {
            return i;
        }
    }
    return -1;
}
GYORACE_DATA *CGyoRaceData::SearchSpaceData(int *out_index) {
    int index = SearchSpace();
    if (index < 0) {
        return 0;
    }
    if (out_index) {
        *out_index = index;
    }
    return &data[index];
}
GYORACE_DATA *CGyoRaceData::GetData(int index) {
    if (index < 0 || index >= 0x40) {
        return 0;
    }
    return &data[index];
}
CSubGameData::CSubGameData() {
    Initialize();
    sphida.Initialize();
    gyorace.Initialize();
}
void CSubGameData::Initialize() {
    memset(this, 0, sizeof(*this));
}
void CSubGameData::PlayEnable(int bits, int enable) {
    if (enable == 1) {
        play_enable |= bits;
        return;
    }
    play_enable &= ~bits;
}
CSphidaData *CSubGameData::GetSphidaData() {
    return &this->sphida;
}
CGyoRaceData *CSubGameData::GetGyoRaceData() {
    return &this->gyorace;
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/savedata", at_453__DATA);
