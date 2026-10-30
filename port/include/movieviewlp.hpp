#pragma once

#include "common.h"

#include "mainloop.hpp"

/**
 * @file
 * Declares the movie viewer, a debug main-loop mode that lists the movies named in "mv.cfg" and plays the chosen one.
 */

/**
 *
 * One movie of the viewer's list, as given by a MOVIE tag of "mv.cfg".
 *
 */
struct MOVIE_LIST_ENTRY {
    char *name;      /**< Title shown in the list; "promo" and "promo_tv" select the promotional movie sequences. */
    char *file_name; /**< Name of the movie file to play. */
    int   bgm_no;    /**< Music played alongside the movie, or 0 or below (-1 when the tag omits it) for none. */
};

STATIC_ASSERT(sizeof(MOVIE_LIST_ENTRY) == 0xC);

/**
 *
 * What the movie viewer is doing on the current frame.
 *
 */
enum MOVIE_VIEW_MODE {
    MOVIE_VIEW_MODE_SELECT = 0, /**< Showing the list of movies and taking the player's choice. */
    MOVIE_VIEW_MODE_PLAY = 1,   /**< Playing the chosen movie. */
};

/**
 *
 * Sequence of promotional movies the viewer plays one after another, if any.
 *
 */
enum MOVIE_SPECIAL_MODE {
    MOVIE_SPECIAL_MODE_NONE = 0,     /**< A single movie from the list. */
    MOVIE_SPECIAL_MODE_PROMO = 1,    /**< The "PROMO<n>.PSS" sequence. */
    MOVIE_SPECIAL_MODE_PROMO_TV = 2, /**< The "PROMO<n>TV.PSS" sequence. */
};

/**
 *
 * Prepares the movie viewer when the main loop enters it: sets up its buffers and textures and reads the movie list.
 *
 * @mangled MovieViewInit__F13INIT_LOOP_ARG
 * @address 0x2CB810
 * @size 0x3C0
 */
void MovieViewInit(INIT_LOOP_ARG arg);

/**
 *
 * Releases the movie viewer when the main loop leaves it, stopping its sounds and restoring the performance meter.
 *
 * @mangled MovieViewExit__Fv
 * @address 0x2CBBD0
 * @size 0x30
 */
void MovieViewExit();

/**
 *
 * Runs one frame of the movie viewer, and returns 1 when the player leaves it from the list.
 *
 * @mangled MovieViewLoop__Fv
 * @address 0x2CBC00
 * @size 0x760
 */
int MovieViewLoop();
