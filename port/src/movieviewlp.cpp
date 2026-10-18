// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <optional>
#include <string>
#include <vector>

#include "config_bridges.hpp"
#include "movieviewlp.hpp"

namespace {

/**
 * One movie of a movie_list document.
 */
struct MovieRecord {
    std::optional<std::string> title;  /**< CP932 title, or none when the operand was not text. */
    std::optional<std::string> file;   /**< Movie file name, or none when the operand was not text. */
    int                        bgm_no; /**< Music played alongside, or -1 when the list names none. */
};

/**
 * Movies of the last movie list read, which the entries handed out point into.
 */
std::vector<MovieRecord> movie_records;

/**
 * Entries handed to the movie viewer for movie_records.
 */
std::vector<PortMovieEntry> movie_entries;

/**
 * Parses a movie_list document.
 */
std::vector<MovieRecord> ParseMovieList(const native_config::Json &document) {
    using namespace native_config;
    std::vector<MovieRecord> movies;
    for (const auto &movie : Array(document, "movies")) {
        movies.push_back({.title = OptionalText(movie, "title"), .file = OptionalText(movie, "file"), .bgm_no = OptionalInt(movie, "bgm").value_or(-1)});
    }
    return movies;
}

/**
 * Gives a stored string's text, or null for none.
 */
const char *TextOf(const std::optional<std::string> &text) {
    return text ? text->c_str() : nullptr;
}

} // namespace

int PortReadMovieList(const PortMovieEntry **entries) {
    movie_records.clear();
    movie_entries.clear();
    if (auto movies = native_config::ReadGame<std::vector<MovieRecord> >("mv.cfg.json", "movie_list", ParseMovieList)) {
        movie_records = std::move(*movies);
    }
    for (const auto &movie : movie_records) {
        movie_entries.push_back({.title = TextOf(movie.title), .file = TextOf(movie.file), .bgm_no = movie.bgm_no});
    }
    *entries = movie_entries.data();
    return static_cast<int>(movie_entries.size());
}

PORT_OVERRIDE void MovieViewInit(INIT_LOOP_ARG argument) { PortInitializeMovieViewer(argument); }
