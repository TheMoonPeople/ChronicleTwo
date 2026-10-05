#include "common.h"
#include "gyoracesim.hpp"
#include <cstring>

struct FISH_STATS {
    float pace;
    float low;
    float mid;
    float high;
    float unknownA;
    float unknownB;
};

extern "C" int fptosi(float value);
extern int jrand;
extern int ia[56];
extern grFISH_DATA fish_data[18];
static void irn55();
void init_rnd(u_int seed);
int StepGyoRace(RACE_FISH_PARAM *fish, grRACE_INFO *race);
int GetRaceDivision(float distance);
float GetCourseR(float pos, float unused);
float GetRandomNumber(float offset, float spread);
void SetRaceFishParam(RACE_FISH_PARAM *fish, grRACE_INFO *race);
void FishModifyParam(grFISH_PARAM *param, float *out, float average);
void CharacterBonus(grFISH_PARAM *param, RACE_FISH_PARAM *fish, int count);
void RndFishParam(RACE_FISH_PARAM *fish);

// Code (.text)
int grGyoRaceSimulate(grRACE_INFO *race) {
    RACE_FISH_PARAM fish[6];
    u_int hash = 0;
    int i;
    int state = 0x3526D02F;
    for (i = 0; i < race->fish_num; i++) {
        grFISH_PARAM *entry = &race->fish[i];
        int length = strlen(entry->name);
        int j;
        for (j = 0; j < length; j++) {
            state = state * 0x5D588B65 + 1;
            signed char c = entry->name[j];
            hash += c * state;
        }

        state = state * 0x5D588B65 + 1;
        hash += entry->fish_no * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->affinity * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->bonus_type * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->power * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->stamina * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->speed[0] * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->speed[1] * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->speed[2] * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->tactics * state;
        state = state * 0x5D588B65 + 1;
        hash += entry->lane * state;
    }
    if (race->seed == 0) {
        init_rnd(hash);
    } else {
        init_rnd(race->seed);
    }
    SetRaceFishParam(fish, race);
    return StepGyoRace(fish, race);
}
int grGetFishProgress(grRACE_INFO *race, int fish, float time, grRACE_PROGRESS *out) {
    grRACE_PROGRESS *progress;
    int index;
    int next;
    float frac;
    if (fish < 0 || fish >= race->fish_num) {
        return 0;
    }
    progress = race->progress[fish];
    if (progress == 0) {
        return 0;
    }
    index = fptosi(time);
    next = index + 1;
    frac = time - (float)index;
    if (next >= race->step_max) {
        return 0;
    }
    *out = progress[index];
    if ((u_char)out->state == 0) {
        return 0;
    }
    out->pos += frac * (progress[next].pos - out->pos);
    out->lane_pos += frac * (progress[next].lane_pos - out->lane_pos);
    return 1;
}
float FishDist(RACE_FISH_PARAM *fish, RACE_FISH_PARAM *other) {
    return (fish->pos + fish->velocity) - (other->pos + other->velocity);
}
int StepFish(int index, RACE_FISH_PARAM *fish) {
    grRACE_PROGRESS *sample;
    int division;
    float pace_b;
    float target;
    float accel;
    float slope;
    if (fish->progress == 0 || index >= fish->progress_num) {
        return 1;
    }
    sample = fish->progress + index;
    division = GetRaceDivision(fish->pos);
    if (division < 0) {
        fish->velocity -= 0.01f;
        if (fish->velocity < 0.0f) {
            fish->velocity = 0.01f;
        }
        fish->pos += fish->velocity;
    } else {
        pace_b = fish->accel[division];
        target = 0.1f + 0.00020000001f * fish->speed[division];
        if (fish->rank > 0 && fish->rank < 7) {
            target *= fish->rank_ratio[fish->rank - 1];
        }
        accel = pace_b - (fish->velocity - target) / 0.016f;
        if (!(fish->boost <= 1.0f)) {
            fish->boost = 1.0f;
        }
        if (fish->boost < -1.0f) {
            fish->boost = -1.0f;
        }
        accel += 1.25f * fish->boost;
        slope = GetCourseR(fish->pos, sample->lane_pos);
        fish->velocity += 0.0016000001f * accel;
        if (fish->velocity < 0.01f) {
            fish->velocity = 0.01f;
        }
        fish->pos += fish->velocity * slope;
        if (!(fish->boost <= 0.0f)) {
            fish->boost -= 0.05f;
            if (fish->boost < 0.0f) {
                fish->boost = 0.0f;
            }
        } else if (fish->boost < 0.0f) {
            fish->boost += 0.05f;
            if (!(fish->boost <= 0.0f)) {
                fish->boost = 0.0f;
            }
        }
    }
    sample->pos = fish->pos;
    sample->state = fish->state;
    sample->battle = fish->battle;
    sample->battle_target = fish->battle_target;
    sample->battle_hits = fish->battle_hits;
    sample->lane = fish->lane;
    sample->lane_pos = fish->lane;
    if (!(sample->pos < 16.0f)) {
        sample->state = 3;
        return 1;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", LaneBattleStep__FP15RACE_FISH_PARAMi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", CollisionFish__FP15RACE_FISH_PARAMi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", StepGyoRace__FP15RACE_FISH_PARAMP11grRACE_INFO);
int GetRaceDivision(float distance) {
    int division;

    if (distance < 2.0f) {
        return 0;
    }
    if (distance < 6.0f) {
        return 1;
    }
    if (distance < 10.0f) {
        return 2;
    }
    if (distance < 14.0f) {
        return 3;
    }
    division = -1;
    if (!(distance < 16.0f)) {
        return division;
    }
    division = 4;

    return division;
}
static float GetRaceDivisionLength(int division) {
    if (division < 0) {
        return 0.0f;
    }
    if (division == 0) {
        return 2.0f;
    }
    if (division == 4) {
        return 2.0f;
    }
    return 4.0f;
}
float GetCourseR(float pos, float unused) {
    int phase = fptosi(pos) % 8;
    if (phase == 1 || phase == 2 || phase == 5 || phase == 6) {
        return 1.0f;
    }
    return 1.0f;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", FishModifyParam__FP12grFISH_PARAMPff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", CharacterBonus__FP12grFISH_PARAMP15RACE_FISH_PARAMi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", RndFishParam__FP15RACE_FISH_PARAM);
static void GetPaseRatio(int unused, float *ratio) {
    float first;
    float total = 0.0f;
    ratio[0] = 1.0f;
    ratio[1] = 1.0f;
    ratio[2] = 1.0f;
    ratio[3] = 1.0f;
    ratio[4] = 1.0f;
    first = ratio[0];
    total += first;
    total += ratio[1];
    total += ratio[2];
    total += ratio[3];
    total += ratio[4];
    ratio[0] = first / total;
    ratio[1] = ratio[1] / total;
    ratio[2] = ratio[2] / total;
    ratio[3] = ratio[3] / total;
    ratio[4] = ratio[4] / total;
}
void SetRaceFishParam(RACE_FISH_PARAM *fish, grRACE_INFO *race) {
    float average;
    RACE_FISH_PARAM *slot;
    int i;
    int k;

    average = 0.0f;
    for (i = 0; i < race->fish_num; i++) {
        average += (float)race->fish[i].stamina;
        average += (float)race->fish[i].speed[0];
        average += (float)race->fish[i].speed[1];
        average += (float)race->fish[i].speed[2];
    }
    average /= 4.0f * (float)race->fish_num;
    for (i = 0; i < race->fish_num; i++) {
        slot = &fish[i];
        memset(slot, 0, sizeof(RACE_FISH_PARAM));
        grFISH_PARAM param = race->fish[i];
        float pace[5];
        FISH_STATS stats;
        grFISH_PARAM *param_ptr = &param;
        FishModifyParam(param_ptr, &stats.pace, average);
        CharacterBonus(param_ptr, slot, race->fish_num);
        float low = stats.low;
        float mid = stats.mid;
        float speed = stats.pace;
        float high = stats.high;
        float half = 0.5f * mid;
        slot->speed[0] = low;
        slot->speed[1] = (low + half) / 1.5f;
        slot->speed[2] = mid;
        slot->speed[3] = (high + half) / 1.5f;
        slot->speed[4] = high;
        GetPaseRatio(param.tactics, pace);
        for (k = 0; k < 5; k++) {
            float scaled = speed * pace[k];
            slot->accel[k] = scaled / (10.0f * GetRaceDivisionLength(k));
        }
        slot->power = stats.unknownA;
        slot->aggression = stats.unknownB;
        RndFishParam(slot);
        slot->boost = 0;
        slot->velocity = GetRandomNumber(0.02f, 0.02f);
        if (slot->velocity < 0.0f) {
            slot->velocity = 0.0f;
        }
        slot->battle_urge = 0;
        slot->battle_time = 0;
        slot->pos = 0;
        slot->lane = param_ptr->lane;
        slot->state = 1;
        slot->battle = 0;
        slot->progress_num = race->step_max;
        slot->progress = race->progress[i];
        memset(slot->progress, 0, race->step_max * sizeof(grRACE_PROGRESS));
    }
}
grFISH_DATA *GetFishData(int fish_no) {
    for (int i = 0; i < 18; i++) {
        if (fish_data[i].fish_no == fish_no) {
            return &fish_data[i];
        }
    }
    return 0;
}
static void irn55(void) {
    int i;
    for (i = 1; i <= 24; i++) {
        int v = ia[i] - ia[i + 31];
        if (v < 0)
            v += 1000000000;
        ia[i] = v;
    }
    for (i = 25; i <= 55; i++) {
        int v = ia[i] - ia[i - 24];
        if (v < 0)
            v += 1000000000;
        ia[i] = v;
    }
}
void init_rnd(u_int seed) {
    int i;
    int j;
    for (i = 0; i < 56; i++) {
        ia[i] = 0;
    }
    ia[55] = seed;
    j = 1;
    for (i = 1; i <= 54; i++) {
        ia[21 * i % 55] = j;
        j = seed - j;
        if (j < 0) {
            j += 1000000000;
        }
        seed = ia[21 * i % 55];
    }
    irn55();
    irn55();
    irn55();
    jrand = 55;
}
static int irnd(void) {
    int next = jrand + 1;
    jrand = next;
    if (next > 55) {
        irn55();
        jrand = 1;
    }
    return ia[jrand];
}
static float rnd(void) {
    return (float)irnd() / 1e9f;
}
static float nrnd(void) {
    float sum = 0.0f;
    int i = 0;
    do {
        sum += rnd();
        i++;
    } while (i < 12);
    return sum - 6.0f;
}
float GetRandomNumber(float offset, float spread) {
    float n = nrnd();
    float scale = spread / 3.0f;
    n *= scale;
    return offset + n;
}
int rand_prob(int percent) {
    return (irnd() >> 12) % 100 < percent;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyoracesim", fish_data__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyoracesim", at_1059__3__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyoracesim", at_483__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(jrand, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(ia, 0xE0);
