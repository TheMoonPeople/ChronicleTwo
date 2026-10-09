#pragma once

#include "common.h"

#include <libvu0.h>

#include "gyoracesim.hpp"
#include "mg_camera.hpp"

/**
 * @file
 * Declares the fish race (gyorace) sub game: the six racing fish shown swimming two laps of the
 * course, the race camera, the commentary window and the results kept for the event scripts.
 */

class ClsMes;
struct SubGameInfo;

/**
 *
 * Stages of the fish race, as race_mode holds them.
 *
 */
enum GYORACE_MODE {
    GYORACE_MODE_READY = 0,     /**< The fish wait at the start until race_proc_cnt runs out. */
    GYORACE_MODE_GATE_OPEN = 1, /**< The start gates swing open over race_proc_cnt frames. */
    GYORACE_MODE_RACE = 2,      /**< The fish swim the course until every fish has reached the goal. */
    GYORACE_MODE_FINISH = 3,    /**< The race goes on behind a fade out until race_proc_cnt runs out. */
    GYORACE_MODE_GOAL_VIEW = 4, /**< Every fish is shown where it is at the winner's goal time from a fixed camera. */
    GYORACE_MODE_END = 5,       /**< Stores the results, frees the race and runs the closing event. */
};

/**
 *
 * State of one racing fish that the race keeps beside the simulation.
 *
 */
struct GYORACE_FISH_INF {
    int   lane;     /**< Lane of the fish, from 0; also its number in the commentary less one. */
    int   chara_no; /**< Scene character slot that shows the fish. */
    int   fish_no;  /**< Race fish of CGyoraceFishData that races; -1 for a fish not taken from it. */
    int   rank;     /**< Place of the fish in the race, from 1. */
    u_int lap;      /**< Lap that the fish swims, from 0. */
    int   unk_14;
    float lap_start; /**< Value of race_cnt at which the fish started its second lap. */
    int   unk_1c;
    float time;        /**< Race time of the fish, in sixtieths of a second. */
    float lap_time[2]; /**< Time that the fish took over each lap, in sixtieths of a second. */
};

STATIC_ASSERT(sizeof(GYORACE_FISH_INF) == 0x2C);

/**
 *
 * Result of one place of the last fish race, read back by the event scripts.
 *
 */
struct GYORACE_RESULT {
    char  name[0x18]; /**< Name of the fish that took the place. */
    float time;       /**< Goal time of the fish, in sixtieths of a second. */
    int   fish_no;    /**< Race fish of CGyoraceFishData that took the place; -1 for one not taken from it. */
    int   race_class; /**< Race class in which the place was taken. */
};

STATIC_ASSERT(sizeof(GYORACE_RESULT) == 0x24);

/**
 *
 * Loads the fish race: its sounds, messages, textures and fish, simulates the whole race and
 * places the race camera.
 *
 * @mangled sgInitGyoRace__FP11SubGameInfo
 * @address 0x309A00
 * @size 0x1200
 */
int sgInitGyoRace(SubGameInfo *info);

/**
 *
 * Steps the fish race by a frame; gives 1 once the race has ended and its event has been run.
 *
 * @mangled sgLoopGyoRace__FP11SubGameInfo
 * @address 0x30AC00
 * @size 0x1A30
 */
int sgLoopGyoRace(SubGameInfo *info);

/**
 *
 * Moves the race camera to the fixed camera point nearest the player's fish.
 *
 * @mangled AutoCam__FP11SubGameInfo
 * @address 0x30C630
 * @size 0x240
 */
void AutoCam(SubGameInfo *info);

/**
 *
 * Draws the map of the fish race, which needs nothing beyond the scene's own drawing.
 *
 * @mangled sgMapDrawGyoRace__FP11SubGameInfo
 * @address 0x30C870
 * @size 0x10
 */
int sgMapDrawGyoRace(SubGameInfo *info);

/**
 *
 * Draws the racing fish and the splashes that they raise.
 *
 * @mangled sgCharaDrawGyoRace__FP11SubGameInfo
 * @address 0x30C880
 * @size 0xC0
 */
int sgCharaDrawGyoRace(SubGameInfo *info);

/**
 *
 * Draws the rippling screen shown while the camera is under the water.
 *
 * @mangled sgEffectDrawGyoRace__FP11SubGameInfo
 * @address 0x30CC20
 * @size 0x120
 */
int sgEffectDrawGyoRace(SubGameInfo *info);

/**
 *
 * Draws the race display: the commentary window, the progress bar of each fish, the lap times,
 * the race time and the player's place.
 *
 * @mangled sgSysDrawGyoRace__FP11SubGameInfo
 * @address 0x30CD40
 * @size 0x1244
 */
int sgSysDrawGyoRace(SubGameInfo *info);

/**
 *
 * Opens the commentary message that fits how the race stands; gives 0 when one is opened or
 * none fits, -1 while the last one is still shown.
 *
 * @mangled Jikkyou__FP11SubGameInfo
 * @address 0x30DF90
 * @size 0x630
 */
int Jikkyou(SubGameInfo *info);

/**
 *
 * Character files of the race fish, by fish number from 0x140.
 *
 * @address 0x362150
 * @size 0x48
 */
extern char *fish_name[18];

/**
 *
 * Fixed camera points around the course, of which the race camera takes the nearest.
 *
 * @address 0x3621A0
 * @size 0x50
 */
extern sceVu0FVECTOR cam_pos[5];

/**
 *
 * Simulation time that the fish are shown at; a twentieth of the race time in sixtieths of a second.
 *
 * @address 0x37E7BC
 * @size 0x4
 */
extern float race_cnt;

/**
 *
 * Frames left in the current stage of the race. @see GYORACE_MODE
 *
 * @address 0x37E7C0
 * @size 0x4
 */
extern int race_proc_cnt;

/**
 *
 * Current stage of the race. @see GYORACE_MODE
 *
 * @address 0x37E7C4
 * @size 0x4
 */
extern int race_mode;

/**
 *
 * Length of the simulated race, as grGyoRaceSimulate gives it.
 *
 * @address 0x37E7C8
 * @size 0x4
 */
extern int time_max;

/**
 *
 * Scene camera slot of the race camera.
 *
 * @address 0x37E808
 * @size 0x4
 */
extern int camera_id;

/**
 *
 * Race class, then race number within the class, of the race being run.
 *
 * @address 0x37E810
 * @size 0x8
 */
extern int race_rank[2];

/**
 *
 * Commentary message window of the race.
 *
 * @address 0x37E818
 * @size 0x4
 */
extern ClsMes *gyo_mes;

/**
 *
 * Results of the last race, by place.
 *
 * @address 0x1F593B0
 * @size 0xD8
 */
extern GYORACE_RESULT fish_game_data[6];

/**
 *
 * Fish and simulation of the race being run.
 *
 * @address 0x1F59490
 * @size 0x1DC
 */
extern grRACE_INFO RaceInfo;

/**
 *
 * Progress records from the previous displayed race frame, used to detect changes in place.
 *
 * @address 0x1F59670
 * @size 0x90
 */
extern grRACE_PROGRESS old_prog[6];

/**
 *
 * Camera that films the race.
 *
 * @address 0x1F597D0
 * @size 0x70
 */
extern mgCCamera camera0;

/**
 *
 * State of each racing fish beside the simulation.
 *
 * @address 0x1F59840
 * @size 0x108
 */
extern GYORACE_FISH_INF fish_inf[6];
