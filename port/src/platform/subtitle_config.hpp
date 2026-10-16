#pragma once

#include <string>
#include <string_view>
#include <vector>

namespace subtitle_config {
/**
 * Holds one caption in native game time and character encoding.
 */
struct Cue {
    int         start_frame = 0; /**< First boundary of the caption's display interval. */
    int         clear_frame = 0; /**< Last boundary of the caption's display interval. */
    std::string text;            /**< Caption text encoded for the game's fonts. */
};

/**
 * Reads a movie's captions from converted JSON through datapack priority.
 */
bool Load(std::string_view source, int chapter, std::vector<Cue> &cues, std::string &error);
/**
 * Decodes captions directly from a bounded native JSON buffer.
 */
bool Decode(std::string_view json, int chapter, std::vector<Cue> &cues, std::string &error);
} // namespace subtitle_config
