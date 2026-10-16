#include "platform/subtitle_config.hpp"

#include <nlohmann/json.hpp>

#include <cmath>
#include <fstream>
#include <limits>
#include <stdexcept>

#include "nd_meswin.hpp"
#include "platform/config_catalog.hpp"
#include "platform/legacy_encoding.hpp"

namespace subtitle_config {
namespace {
/**
 * Converts a subtitle's second-based boundary to the native 30 Hz timeline.
 */
int Frame(const nlohmann::json &value) {
    const double frames = value.get<double>() * 30.0;
    if (!std::isfinite(frames) || frames < std::numeric_limits<int>::min() || frames > std::numeric_limits<int>::max()) {
        throw std::runtime_error("subtitle time is outside the native timeline");
    }
    return static_cast<int>(frames);
}

/**
 * Decodes readable caption text or an exceptional non-roundtrippable CP932 value.
 */
std::string Text(const nlohmann::json &entry) {
    if (!entry.contains("game_bytes")) {
        return legacy_encoding::GameText(entry.at("text").get<std::string>());
    }
    const auto hex = entry.at("game_bytes").get<std::string>();
    if (hex.size() % 2) {
        throw std::runtime_error("invalid subtitle byte fallback");
    }
    const auto digit = [](char value) {
        if (value >= '0' && value <= '9') {
            return value - '0';
        }
        if (value >= 'a' && value <= 'f') {
            return value - 'a' + 10;
        }
        if (value >= 'A' && value <= 'F') {
            return value - 'A' + 10;
        }
        throw std::runtime_error("invalid subtitle byte fallback");
    };
    std::string text;
    for (std::size_t index = 0; index < hex.size(); index += 2) {
        text.push_back(static_cast<char>((digit(hex[index]) << 4) | digit(hex[index + 1])));
    }
    return text;
}
} // namespace

bool Decode(std::string_view json, int chapter, std::vector<Cue> &cues, std::string &error) {
    cues.clear();
    error.clear();
    try {
        const auto document = nlohmann::json::parse(json);
        if (document.at("schema_version") != 1 || document.at("kind") != "movie_subtitles" || !document.at("chapters").is_array()) {
            throw std::runtime_error("invalid subtitle document");
        }
        for (const auto &track : document.at("chapters")) {
            if (track.at("id").get<int>() != chapter) {
                continue;
            }
            const auto &entries = track.at("entries");
            if (!entries.is_array() || entries.size() > MOVIE_CC_MAX) {
                throw std::runtime_error("too many native subtitle captions");
            }
            std::vector<Cue> decoded;
            for (const auto &entry : entries) {
                Cue cue{Frame(entry.at("start_seconds")), Frame(entry.at("clear_seconds")), Text(entry)};
                if (cue.text.size() >= MOVIE_CC_LEN || cue.text.find('\0') != std::string::npos) {
                    throw std::runtime_error("subtitle exceeds native text capacity");
                }
                decoded.push_back(std::move(cue));
            }
            cues = std::move(decoded);
            error.clear();
            return true;
        }
        error.clear();
        return false;
    } catch (const std::exception &exception) {
        error = exception.what();
    }
    return false;
}

bool Load(std::string_view source, int chapter, std::vector<Cue> &cues, std::string &error) {
    for (const auto &path : config_catalog::Paths(source)) {
        std::ifstream input(path, std::ios::binary);
        if (!input) {
            continue;
        }
        const std::string bytes{std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>()};
        if (Decode(bytes, chapter, cues, error)) {
            return true;
        }
        if (error.empty()) {
            return false;
        }
    }
    return false;
}
} // namespace subtitle_config
