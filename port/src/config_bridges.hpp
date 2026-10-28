#pragma once

#include <array>

class CCharacter2;
struct INIT_LOOP_ARG;

/**
 * Initializes movie viewing with the movies of the native movie list.
 */
void PortInitializeMovieViewer(INIT_LOOP_ARG argument);

/**
 * One movie of the native movie list.
 */
struct PortMovieEntry {
    const char *title;  /**< CP932 title shown in the list, or null when the list gives none. */
    const char *file;   /**< Name of the movie file, or null when the list gives none. */
    int         bgm_no; /**< Music played alongside the movie, or -1 when the list names none. */
};

/**
 * Reads the native movie list, giving its movies (valid until the next read) and their count.
 */
int PortReadMovieList(const PortMovieEntry **entries);

/**
 * Loads the development gyorace configuration from the host save directory.
 */
void PortLoadDebugGyoraceConfiguration();

/**
 * The fishing game's rod, float, lure, hook and bait models, each null until the game loads it.
 */
std::array<const CCharacter2 *, 6> PortFishingGear();
