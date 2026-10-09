#pragma once

#include "common.h"

/**
 * @file
 * Declares the fish race simulation (gyoracesim), which runs the whole race ahead of time and
 * records, for every fish and every simulation step, where it swims, so that the race can be shown
 * afterwards by reading the record back.
 */

/**
 *
 * What a racing fish is doing at one simulation step.
 *
 */
enum grRACE_STATE {
    GR_RACE_STATE_NONE = 0,   /**< No step is recorded. */
    GR_RACE_STATE_SWIM = 1,   /**< The fish swims the course. */
    GR_RACE_STATE_BATTLE = 2, /**< The fish pushes against a fish in the next lane. */
    GR_RACE_STATE_GOAL = 3,   /**< The fish has reached the goal. */
};

/**
 *
 * How the speed of a racing fish changes with its place in the race.
 *
 */
enum grCHARA_BONUS_TYPE {
    GR_CHARA_BONUS_FRONT = 0,  /**< The nearer the front, the faster the fish swims. */
    GR_CHARA_BONUS_BACK = 1,   /**< The nearer the back, the faster the fish swims. */
    GR_CHARA_BONUS_NONE = 2,   /**< The place makes no difference. */
    GR_CHARA_BONUS_RANDOM = 3, /**< The front and the back each gain or lose a little at random. */
};

/**
 *
 * Racing figures of one entrant, as the race is given them.
 *
 */
struct grFISH_PARAM {
    char name[0x18]; /**< Name of the fish. */
    int  fish_no;    /**< Item number of the kind of fish. */
    int  affinity;   /**< Value that, matching the affinity of the fish's kind, raises every figure by a tenth. */
    int  bonus_type; /**< How the place in the race changes the speed of the fish. @see grCHARA_BONUS_TYPE */
    int  power;      /**< Strength of the fish when it pushes against another fish. */
    int  stamina;    /**< Acceleration of the fish, shared out over the divisions of the course. */
    int  speed[3];   /**< Top speed of the fish over the start, the middle and the end of the course. */
    int  tactics;    /**< How the fish runs its race, from 0 to 5. */
    int  lane;       /**< Lane that the fish starts in, from 0. */
};

STATIC_ASSERT(sizeof(grFISH_PARAM) == 0x40);

/**
 *
 * Where one racing fish is at one simulation step.
 *
 */
struct grRACE_PROGRESS {
    float  pos;      /**< Distance swum along the course; the goal is at 16. */
    int    lane;     /**< Lane that the fish swims in, from 0. */
    float  lane_pos; /**< Lane that the fish swims in, as a value that moves smoothly between lanes. */
    u8     state;    /**< What the fish is doing. @see grRACE_STATE */
    s8     battle;   /**< 1 while the fish pushes against another fish. */
    u_char unk_e[2];
    int    battle_target; /**< Entrant that the fish pushes against. */
    int    battle_hits;   /**< Number of times the fish has gained the upper hand in its push. */
};

STATIC_ASSERT(sizeof(grRACE_PROGRESS) == 0x18);

/**
 *
 * Entrants, limits and results of one fish race.
 *
 */
struct grRACE_INFO {
    u_int            seed; /**< Seed of the race's random numbers; 0 takes one made from the entrants. */
    int              unk_4;
    int              fish_num;        /**< Number of entrants. */
    grFISH_PARAM     fish[6];         /**< Racing figures of each entrant. */
    int              step_max;        /**< Number of simulation steps that each progress record holds. */
    grRACE_PROGRESS *progress[6];     /**< Progress record of each entrant, step_max steps long. */
    int              after_goal_step; /**< Last extra step index after every fish reaches the goal, counted from zero. */
    int              rank[6];         /**< Place of each entrant in the race, from 1. */
    float            goal_time[6];    /**< Simulation step, with its fraction, at which each entrant reached the goal. */
};

STATIC_ASSERT(sizeof(grRACE_INFO) == 0x1DC);

/**
 *
 * State of one racing fish while the race is simulated.
 *
 */
struct RACE_FISH_PARAM {
    float            speed[5]; /**< Top speed of the fish over each division of the course. */
    float            accel[5]; /**< Acceleration of the fish over each division of the course. */
    u_char           unk_28[0x28];
    float            velocity; /**< Distance that the fish swims in one step. */
    float            pos;      /**< Distance swum along the course; the goal is at 16. */
    int              lane;     /**< Lane that the fish swims in, from 0 to 5. */
    s8               state;    /**< What the fish is doing. @see grRACE_STATE */
    s8               battle;   /**< 1 while the fish pushes against another fish. */
    u_char           unk_5e[2];
    int              battle_target; /**< Entrant that the fish pushes against. */
    int              battle_hits;   /**< Number of times the fish has gained the upper hand in its push. */
    float            power;         /**< Strength of the fish when it pushes against another fish. */
    float            aggression;    /**< How readily the fish starts to push against a fish beside it. */
    float            battle_urge;   /**< Urge to push, which grows with fish alongside; above 1 a push starts. */
    float            battle_time;   /**< Steps left in the current push. */
    float            boost;         /**< Speed gained or lost from the last push, from -1 to 1, fading each step. */
    int              rank;          /**< Place of the fish in the race, from 1. */
    float            rank_ratio[6]; /**< Factor on the top speed of the fish at each place in the race. */
    int              progress_num;  /**< Number of steps that the progress record holds. */
    grRACE_PROGRESS *progress;      /**< Progress record of the fish, filled step by step. */
};

STATIC_ASSERT(sizeof(RACE_FISH_PARAM) == 0xA0);

/**
 *
 * Figures of one kind of racing fish, as percentages of an entrant's own figures.
 *
 */
struct grFISH_DATA {
    int   fish_no;  /**< Item number of the kind of fish. */
    float power;    /**< Percentage applied to the power of the fish. */
    float stamina;  /**< Percentage applied to the stamina of the fish. */
    float speed[3]; /**< Percentage applied to each top speed of the fish. */
    int   affinity; /**< Affinity of the kind; an entrant with the same affinity has every figure raised by a tenth. */
};

STATIC_ASSERT(sizeof(grFISH_DATA) == 0x1C);

/**
 *
 * Simulates the whole fish race, filling every entrant's progress record, places and goal
 * times; gives the number of steps that were simulated.
 *
 * @mangled grGyoRaceSimulate__FP11grRACE_INFO
 * @address 0x321B90
 * @size 0x2A0
 */
int grGyoRaceSimulate(grRACE_INFO *race);

/**
 *
 * Gives where an entrant is at a simulation time between two steps; gives 1 when the step has
 * been recorded, 0 for an entrant or a time without one.
 *
 * @mangled grGetFishProgress__FP11grRACE_INFOifP15grRACE_PROGRESS
 * @address 0x321E30
 * @size 0x140
 */
int grGetFishProgress(grRACE_INFO *race, int fish, float time, grRACE_PROGRESS *out);

/**
 *
 * Gives 1 with the given chance, in percent, from the race's random numbers.
 *
 * @mangled rand_prob__Fi
 * @address 0x324A80
 * @size 0x40
 */
int rand_prob(int percent);
