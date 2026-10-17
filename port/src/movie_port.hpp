#pragma once

#include <filesystem>

std::filesystem::path MoviePortPath(const char *name);

// The most host texels per retail texel a replacement movie is shown at: 2048x1664 for the 512x416 retail movies.
inline constexpr int kMoviePortMaxScale = 4;

/**
 * Size a movie picture is shown at, in pixels, and the host texels per retail texel it fills the movie texture with.
 */
struct MoviePortPicture {
    int width = 0;  /**< Picture width after fitting. */
    int height = 0; /**< Picture height after fitting. */
    int scale = 1;  /**< 1, 2 or 4. */
};

/**
 * Fits a decoded picture to the retail size the game gives Load times 1, 2 or 4: an exact multiple is kept, any other
 * size is resampled to the largest multiple it covers (the retail size when it covers none). Without a retail size
 * the picture is kept at scale 1.
 */
MoviePortPicture MoviePortFit(int retail_width, int retail_height, int width, int height);

// Driver port 5: GetCSndPortNo never maps a game port to it, so no sequence or sound effect plays there during a movie.
inline constexpr int kMoviePortAudioPort = 5;
