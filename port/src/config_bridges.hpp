#pragma once

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
