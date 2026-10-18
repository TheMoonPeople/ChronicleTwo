// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <cstring>
#include <numbers>
#include <optional>
#include <string>
#include <vector>

#include "mapsky.hpp"
#include "stubs/mapsky.hpp"

namespace {

/**
 * Number of time bands a sky has.
 */
constexpr int kSkyBands = 4;

/**
 * Number of turning frames each kind of sky model can hold.
 */
constexpr int kSkyAnimations = 16;

/**
 * Bytes of every name field of MAP_SKY_INFO.
 */
constexpr std::size_t kSkyName = sizeof(MAP_SKY_INFO::bg_mds_name);

/**
 * One row of a sky table: a band, a file or frame name and, for models and animations, degrees.
 */
struct SkyRow {
    int                        band;    /**< Time band; unused for the background. */
    std::optional<std::string> name;    /**< File or frame name, CP932. */
    float                      degrees; /**< Turn per frame in degrees, for models and animations. */
};

/**
 * Typed contents of a sky document, each table in script order.
 */
struct SkyDocument {
    std::vector<SkyRow> images;          /**< SKY_IMG rows. */
    std::vector<SkyRow> models;          /**< SKY_MDS rows. */
    std::vector<SkyRow> animations;      /**< SKY_ANIME rows. */
    std::vector<SkyRow> suns;            /**< SUN_MDS rows. */
    std::vector<SkyRow> back_models;     /**< SKYB_MDS rows. */
    std::vector<SkyRow> back_animations; /**< SKYB_ANIME rows. */
    std::vector<SkyRow> backgrounds;     /**< SKY_BG rows. */
};

/**
 * Parses one sky table; the name key is "file" or "frame" and the degree key is optional.
 */
std::vector<SkyRow> Rows(const native_config::Json &document, const char *key, const char *name_key, const char *degree_key, bool band) {
    using namespace native_config;
    std::vector<SkyRow> rows;
    for (const auto &row : Array(document, key)) {
        SkyRow parsed{.band = band ? Int(row, "band") : 0, .name = OptionalText(row, name_key), .degrees = degree_key != nullptr ? Float(row, degree_key) : 0.0f};
        // The sky's fields hold 31 bytes and a terminator.
        if (parsed.name && parsed.name->size() >= kSkyName) {
            throw std::runtime_error(std::string(key) + " name is longer than the sky holds");
        }
        rows.push_back(std::move(parsed));
    }
    return rows;
}

/**
 * Parses a sky document.
 */
SkyDocument ParseSky(const native_config::Json &document) {
    return {.images = Rows(document, "images", "file", nullptr, true),
            .models = Rows(document, "models", "file", "rotation_degrees", true),
            .animations = Rows(document, "animations", "frame", "speed_degrees", true),
            .suns = Rows(document, "suns", "file", nullptr, true),
            .back_models = Rows(document, "back_models", "file", "rotation_degrees", true),
            .back_animations = Rows(document, "back_animations", "frame", "speed_degrees", true),
            .backgrounds = Rows(document, "backgrounds", "file", nullptr, false)};
}

/**
 * Copies a sky name when the row gave one.
 */
void CopyName(char *destination, const std::optional<std::string> &name) {
    if (name) {
        std::strcpy(destination, name->c_str());
    }
}

/**
 * Whether a band names one of the sky's time bands.
 */
bool Band(int band) {
    return band >= 0 && band < kSkyBands;
}

/**
 * Adds the turning frames of one kind of sky model, as SKY_ANIME and SKYB_ANIME do.
 */
void Animations(const std::vector<SkyRow> &rows, int *ids, char (*names)[32], float *speeds) {
    int count = 0;
    for (const auto &row : rows) {
        if (count >= kSkyAnimations || !Band(row.band)) {
            continue;
        }
        ids[count] = row.band;
        CopyName(names[count], row.name);
        speeds[count] = std::numbers::pi_v<float> * row.degrees / 180.0f;
        ++count;
    }
}

} // namespace

void PortLoadSkyInfo(MAP_SKY_INFO *info, char *script, int size) {
    if (script == nullptr || size == 0) {
        return;
    }
    const auto sky = native_config::ReadBuffer<SkyDocument>(script, "sky", ParseSky);
    if (!sky) {
        return;
    }
    for (const auto &row : sky->images) {
        if (Band(row.band)) {
            CopyName(info->img_name[row.band], row.name);
        }
    }
    for (const auto &row : sky->models) {
        if (Band(row.band)) {
            CopyName(info->sky_mds_name[row.band], row.name);
            info->sky_rot_speed[row.band] = row.degrees * std::numbers::pi_v<float> / 180.0f;
        }
    }
    for (const auto &row : sky->suns) {
        if (Band(row.band)) {
            CopyName(info->sun_mds_name[row.band], row.name);
        }
    }
    for (const auto &row : sky->back_models) {
        if (Band(row.band)) {
            CopyName(info->skyb_mds_name[row.band], row.name);
            info->skyb_rot_speed[row.band] = row.degrees * std::numbers::pi_v<float> / 180.0f;
        }
    }
    for (const auto &row : sky->backgrounds) {
        CopyName(info->bg_mds_name, row.name);
    }
    Animations(sky->animations, info->sky_anime_id, info->sky_anime_name, info->sky_anime_speed);
    Animations(sky->back_animations, info->skyb_anime_id, info->skyb_anime_name, info->skyb_anime_speed);
}
