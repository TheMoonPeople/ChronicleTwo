#include "common.h"
#include "gyoracesim.hpp"
#include <cstring>

struct FishEntryCopy { union { char name[24]; int words[6]; }; int values[10]; };

struct RaceProgressCopy { float pos; int lane; float lane_pos; s8 state; s8 battle; int detail[2]; };

struct FISH_STATS {
    float pace;
    float low;
    float mid;
    float high;
    float unknownA;
    float unknownB;
};

extern "C" float GetRandomNumber__Fff(float, float);
extern "C" int fptosi(float value);
extern int jrand;
extern int ia[56];
extern grFISH_DATA fish_data[18];
static void irn55();
static int irnd();
void init_rnd(u_int seed);
int StepGyoRace(RACE_FISH_PARAM *fish, grRACE_INFO *race);
int GetRaceDivision(float distance);
float GetCourseR(float pos, float unused);
void SetRaceFishParam(RACE_FISH_PARAM *fish, grRACE_INFO *race);
void FishModifyParam(grFISH_PARAM *param, float *out, float average);
void CharacterBonus(grFISH_PARAM *param, RACE_FISH_PARAM *fish, int count);
void RndFishParam(RACE_FISH_PARAM *fish);
#include "crandom.hpp"
#include <cstring>

extern grFISH_DATA fish_data[18];
extern int ia[56];
extern int jrand;

int GetRaceDivision(float distance);
float GetCourseR(float position, float lane);
float GetRandomNumber(float mean, float range);
void init_rnd(unsigned int seed);
void RndFishParam(RACE_FISH_PARAM *fish);
void CharacterBonus(grFISH_PARAM *source, RACE_FISH_PARAM *fish, int count);
void FishModifyParam(grFISH_PARAM *source, float *output, float average);
static void GetPaseRatio(int tactics, float *ratio);
void SetRaceFishParam(RACE_FISH_PARAM *fish, grRACE_INFO *info);
int StepGyoRace(RACE_FISH_PARAM *fish, grRACE_INFO *info);
static void CollisionFish(RACE_FISH_PARAM *fish, int count);
void LaneBattleStep(RACE_FISH_PARAM *fish, int count);
grFISH_DATA *GetFishData(int fish_no);
static float nrnd();

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
    *(RaceProgressCopy *)out = *(RaceProgressCopy *)&progress[index];
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
#ifdef NONMATCHING
void LaneBattleStep(RACE_FISH_PARAM *fish, int count) {
    int lane_count[6] = {0, 0, 0, 0, 0, 0};
    int lane_fish[6][6];
    int order[6];
    for (int i = 0; i < count; ++i) {
        order[i] = i;
        int lane = fish[i].lane;
        lane_fish[lane][lane_count[lane]++] = i;
    }
    for (int i = 0; i < 20; ++i) {
        int a = (irnd() >> 22) % count;
        int b = (irnd() >> 22) % count;
        int swap = order[a];
        order[a] = order[b];
        order[b] = swap;
    }
    for (int turn = 0; turn < count; ++turn) {
        int index = order[turn];
        RACE_FISH_PARAM &current = fish[index];
        int neighbor[2] = {-1, -1};
        bool crowded[2] = {false, false};
        float best_distance[2] = {-1.0f, -1.0f};
        for (int side = 0; side < 2; ++side) {
            int adjacent_lane = current.lane + (side == 0 ? -1 : 1);
            if (adjacent_lane < 0 || adjacent_lane >= 6) continue;
            for (int j = 0; j < lane_count[adjacent_lane]; ++j) {
                int other_index = lane_fish[adjacent_lane][j];
                RACE_FISH_PARAM &other = fish[other_index];
                float distance = FishDist(&other, &current);
                float magnitude = distance < 0.0f ? -distance : distance;
                if (magnitude < 0.075f) crowded[side] = true;
                if (magnitude < 0.05f && other.state != GR_RACE_STATE_BATTLE &&
                    (neighbor[side] < 0 || best_distance[side] < distance)) {
                    neighbor[side] = other_index;
                    best_distance[side] = distance;
                }
            }
        }
        bool fish_ahead = false;
        for (int j = 0; j < lane_count[current.lane]; ++j) {
            float distance = FishDist(&fish[lane_fish[current.lane][j]], &current);
            if (distance > 0.0f && distance < 0.1f) fish_ahead = true;
        }
        if (current.state == GR_RACE_STATE_BATTLE) {
            current.battle_time -= 1.0f;
            RACE_FISH_PARAM &other = fish[current.battle_target];
            float difference = current.power - other.power;
            if (difference > 30.0f) difference = 30.0f;
            if (difference < -30.0f) difference = -30.0f;
            int chance = (int)(((difference + 30.0f) / 60.0f) * 100.0f);
            if (chance < 1) chance = 1;
            if (chance > 100) chance = 100;
            if (rand_prob(chance)) ++current.battle_hits;
            if (current.battle_time < 0.0f) {
                RACE_FISH_PARAM *winner = rand_prob(chance) ? &current : &other;
                RACE_FISH_PARAM *loser = winner == &current ? &other : &current;
                winner->boost = 0.5f;
                loser->boost = -0.25f;
                current.battle_time = 0.0f;
                current.state = GR_RACE_STATE_SWIM;
                current.battle = 0;
                other.state = GR_RACE_STATE_SWIM;
                other.battle = 0;
                other.battle_time = 0.0f;
            }
        } else {
            float crowd_effect = 0.0f;
            float increment = 0.1f * GetRandomNumber__Fff(1.0f, 0.5f);
            if (!crowded[0] && !crowded[1]) crowd_effect = -increment;
            if (crowded[0]) crowd_effect += increment;
            if (crowded[1]) crowd_effect += increment;
            current.battle_urge += current.aggression * crowd_effect;
            if (current.battle_urge < 0.0f) current.battle_urge = 0.0f;
        }
        if (current.state == GR_RACE_STATE_BATTLE) continue;
        if (rand_prob(10) && !crowded[0]) {
            if (--current.lane < 0) current.lane = 0;
        } else if (fish_ahead && rand_prob(75)) {
            int change = 0;
            if (!crowded[0]) {
                if (!crowded[1]) change = rand_prob(80) ? 1 : -1;
                else change = -1;
            } else if (!crowded[1]) change = 1;
            current.lane += change;
            if (current.lane < 0) current.lane = 0;
            if (current.lane >= 6) current.lane = 5;
        } else if ((neighbor[0] >= 0 || neighbor[1] >= 0) && current.battle_urge > 1.0f) {
            int target = -1;
            if (crowded[0] && crowded[1]) target = rand_prob(50) ? neighbor[0] : neighbor[1];
            else if (crowded[0]) target = neighbor[0];
            else if (crowded[1]) target = neighbor[1];
            if (target >= 0) {
                RACE_FISH_PARAM &other = fish[target];
                float speed = current.velocity > other.velocity ? current.velocity : other.velocity;
                current.state = GR_RACE_STATE_BATTLE;
                current.battle = 1;
                current.battle_target = target;
                current.battle_hits = 0;
                current.battle_urge = 0.0f;
                current.battle_time = 5.0f;
                current.velocity = speed;
                other.state = GR_RACE_STATE_BATTLE;
                other.battle = 1;
                other.battle_target = index;
                other.battle_hits = 0;
                other.battle_urge = 0.0f;
                other.battle_time = 5.0f;
                other.velocity = speed;
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", LaneBattleStep__FP15RACE_FISH_PARAMi);
#endif
#ifdef NONMATCHING
static void CollisionFish(RACE_FISH_PARAM *fish, int count) {
    int i;
    int order[6];
    float distance[6];
    for (i = 0; i < count; ++i) {
        order[i] = i;
        distance[i] = fish[i].pos - fish[i].velocity;
    }
    int old_index;
    for (i = 0; i < count - 1; ++i) {
        for (int j = i + 1; j < count; ++j) {
            if (distance[i] < distance[j]) {
                float old_distance = distance[i];
                distance[i] = distance[j];
                distance[j] = old_distance;
                old_index = order[i];
                order[i] = order[j];
                order[j] = old_index;
            }
        }
    }
    int lane_fish[6][6];
    int lane_count[6];
    for (i = 0; i < 6; ++i) lane_count[i] = 0;
    for (i = 0; i < count; ++i) {
        int index = order[i];
        int lane = fish[index].lane;
        lane_fish[lane][lane_count[lane]++] = index;
    }
    for (int j = 0; j < 6; ++j) {
        RACE_FISH_PARAM *ahead = &fish[lane_fish[j][0]];
        for (i = 1; i < lane_count[j]; ++i) {
            RACE_FISH_PARAM *behind = &fish[lane_fish[j][i]];
            float limit = ahead->pos - 0.05f;
            if (limit < behind->pos) behind->pos = limit;
            ahead = behind;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", CollisionFish__FP15RACE_FISH_PARAMi);
#endif
#ifdef NONMATCHING
int StepGyoRace(RACE_FISH_PARAM *fish, grRACE_INFO *info) {
    int i;
    int step;
    for (i = 0; i < 6; ++i) {
        info->rank[i] = 0;
        info->goal_time[i] = 0.0f;
    }
    step = 0;
    for (; step < info->step_max; ++step) {
        int finished[6];
        for (i = 0; i < 6; ++i) finished[i] = 0;
        for (i = 0; i < info->fish_num; ++i) {
            finished[i] = StepFish(step, &fish[i]);
            if (finished[i] && info->goal_time[i] == 0.0f) {
                info->goal_time[i] = (float)step - (fish[i].pos - 16.0f) / fish[i].velocity;
            }
        }
        for (i = 0; i < info->fish_num; ++i) {
            int j;
            int rank = 0;
            for (j = 0; j < info->fish_num; ++j) {
                if (i != j && fish[i].pos < fish[j].pos) ++rank;
            }
            fish[i].rank = rank + 1;
        }
        CollisionFish(fish, info->fish_num);
        LaneBattleStep(fish, info->fish_num);
        int all_finished = 1;
        for (i = 0; i < info->fish_num; ++i) {
            if (!finished[i]) all_finished = 0;
        }
        if (all_finished) break;
    }
    for (i = 0; i < info->fish_num; ++i) {
        int number=info->fish_num;
        int rank = 0;
        for (unsigned int j = 0; (int)j < (int)number; ++j) {
            if (i != (int)j && info->goal_time[i] > info->goal_time[j]) ++rank;
        }
        info->rank[i] = rank + 1;
    }
    ++step;
    for (int extra = 0; extra < info->after_goal_step + 1; ++extra, ++step) {
        if (step >= info->step_max) break;
        for (i = 0; i < info->fish_num; ++i) StepFish(step, &fish[i]);
    }
    return step;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", StepGyoRace__FP15RACE_FISH_PARAMP11grRACE_INFO);
#endif

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
#ifdef NONMATCHING
void FishModifyParam(grFISH_PARAM *source, float *output, float average) {
    int i;
    output[0] = (float)source->stamina;
    for (i = 0; i < 3; ++i) output[i + 1] = (float)source->speed[i];
    output[4] = (float)source->power;
    output[5] = 0.5f;
    grFISH_DATA *kind = GetFishData(source->fish_no);
    if (kind != NULL) {
        output[0] *= kind->stamina / 100.0f;
        for (i = 0; i < 3; ++i) output[i + 1] *= kind->speed[i] / 100.0f;
        output[4] *= kind->power / 100.0f;
        if (kind->affinity == source->affinity) {
            for (i = 0; i < 5; ++i) output[i] *= 1.1f;
        }
    }
    float ratios[5];
    CRandom random;
    u32 seed = 1;
    int shift = 0;
    random.seed = seed;
    int length = strlen(source->name);
    for (i = 0; i < length; ++i) {
        signed char letter = source->name[i];
        seed += letter << shift;
        shift += 4;
        shift %= 28;
    }
    if (seed == 0) seed = 1;
    random.seed = seed;
    for (i = 0; i < 1000; ++i) random.seed = random.seed * 0x5D588B65 + 1;
    for(i=0;i<5;++i){float scale=float(.03);float one=float(1.0);float number=random.nget();float product=number*scale;float factor=one+product;ratios[i]=factor;}
    for (i = 0; i < 5; ++i) output[i] *= ratios[i];
    float noise = 25.0f * average / 100.0f;
    if (noise < 6.25f) noise = 6.25f;
    for (i = 0; i < 4; ++i) {
        float variation = noise * nrnd();
        if (variation < 0.0f) variation = -variation;
        output[i] += variation;
        if (output[i] < 0.0f) output[i] = 0.0f;
    }
    output[5] = GetRandomNumber(0.5f, 0.5f);
    switch (source->tactics) {
    case 0: {
        float factor = GetRandomNumber(1.0f, 0.1f);
        output[5] -= 0.5f;
        for (i = 1; i <= 3; ++i) output[i] *= factor;
        break;
    }
    case 1: {
        float factor = GetRandomNumber(1.0f, 0.2f);
        for (i = 1; i <= 3; ++i) output[i] *= factor;
        break;
    }
    case 2:
        output[5] -= 0.3f;
        output[1] *= GetRandomNumber(1.5f, 0.2f);
        output[2] *= 0.873f;
        output[3] *= 0.5f;
        break;
    case 3:
        output[5] += 0.2f;
        output[1] *= 0.8f;
        output[2] *= 0.8f;
        output[3] *= GetRandomNumber(1.8f, 0.4f);
        break;
    case 4: {
        float factor = GetRandomNumber(1.0f, 0.2f);
        output[5] += 0.5f;
        for (i = 1; i <= 3; ++i) output[i] *= factor;
        break;
    }
    case 5:
        output[5] += 0.1f;
        output[1] *= 0.8f;
        output[2] *= GetRandomNumber(1.3f, 0.3f);
        output[3] *= 0.8f;
        break;
    }
    for (i = 0; i < 4; ++i) if (output[i] < 0.0f) output[i] = 0.0f;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", FishModifyParam__FP12grFISH_PARAMPff);
#endif
#ifdef NONMATCHING
void CharacterBonus(grFISH_PARAM *source, RACE_FISH_PARAM *fish, int count) {
    int type = source->bonus_type;
    fish->rank_ratio[0] = 1.0f;
    float front = 1.0f;
    fish->rank_ratio[1] = 1.0f;
    fish->rank_ratio[2] = 1.0f;
    float back = front;
    fish->rank_ratio[3] = 1.0f;
    fish->rank_ratio[4] = 1.0f;
    fish->rank_ratio[5] = 1.0f;
    switch (type) {
    case GR_CHARA_BONUS_FRONT: {
        float amount = GetRandomNumber(0.0f, float(0.01));
        if (amount < 0.0f) amount = -amount;
        front = 1.0f + amount;
        back = 1.0f - amount;
        break;
    }
    case GR_CHARA_BONUS_BACK: {
        float amount = GetRandomNumber(0.0f, float(0.01));
        if (amount < 0.0f) amount = -amount;
        front = 1.0f - 0.2f * amount;
        back = 1.0f + amount;
        break;
    }
    case GR_CHARA_BONUS_NONE:
        break;
    case GR_CHARA_BONUS_RANDOM: {
        float mean = 1.0f;
        float range = 0.01f;
        front = GetRandomNumber(mean, range);
        back = GetRandomNumber(mean, range);
        break;
    }
    }
    for (int i = 0; i < count; ++i) {
        fish->rank_ratio[i] = front - ((float)i / (float)(count - 1)) * (front - back);
    }
    fish->rank_ratio[0] = 1.0f;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyoracesim", CharacterBonus__FP12grFISH_PARAMP15RACE_FISH_PARAMi);
#endif
void RndFishParam(RACE_FISH_PARAM *fish) {
    for (int i = 0; i < 5; ++i) {
        float mean = 1.0f;
        float range = 0.5f;
        fish->speed[i] *= GetRandomNumber(mean, range);
        if (fish->speed[i] < 0.0f) fish->speed[i] = 0.0f;
        fish->accel[i] *= GetRandomNumber(mean, range);
        if (fish->accel[i] < 0.0f) fish->accel[i] = 0.0f;
    }
}
static void GetPaseRatio(int tactics, float *ratio) {
    for (int division = 0; division < 5; ++division) {
        ratio[division] = 1.0f;
    }
    float total = 0.0f;
    for (int division = 0; division < 5; ++division) {
        total += ratio[division];
    }
    for (int division = 0; division < 5; ++division) {
        ratio[division] /= total;
    }
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
        FishEntryCopy param = *(FishEntryCopy *)&race->fish[i];
        float pace[5];
        FISH_STATS stats;
        grFISH_PARAM *param_ptr = (grFISH_PARAM *)&param;
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
        GetPaseRatio(param.values[8], pace);
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
        slot->lane = ((FishEntryCopy *)param_ptr)->values[9];
        slot->state = 1;
        slot->battle = 0;
        slot->progress_num = race->step_max;
        slot->progress = race->progress[i];
        memset(slot->progress, 0, race->step_max * sizeof(grRACE_PROGRESS));
    }
}
grFISH_DATA *GetFishData(int fish_no) {
    for (int fish_index = 0; fish_index < 18; ++fish_index) {
        if (fish_data[fish_index].fish_no == fish_no) {
            return &fish_data[fish_index];
        }
    }
    return NULL;
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
static float rnd() {
    return (float)irnd() / 1000000000.0f;
}
static float nrnd() {
    float total = 0.0f;
    for (int sample = 0; sample < 12; ++sample) {
        total += rnd();
    }
    return total - 6.0f;
}
float GetRandomNumber(float mean, float range) {
    float value = nrnd();
    float scale = range / 3.0f;
    value *= scale;
    return mean + value;
}
int rand_prob(int percent) {
    return ((irnd() >> 12) % 100) < percent;
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
