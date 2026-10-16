#include "common.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <limits>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

#include "audio_assets.hpp"
#include "dataread_port.hpp"
#include "scenesnd.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Reads a bounded integer field from a semantic scene sound table.
 */
s16 SceneInteger(const Json &value) {
    if (!value.is_number_integer()) {
        throw std::runtime_error("scene audio field requires an integer");
    }
    if (value.is_number_unsigned() && value.get<std::uint64_t>() > static_cast<std::uint64_t>(std::numeric_limits<s16>::max())) {
        throw std::runtime_error("scene audio unsigned integer exceeds its range");
    }
    const auto integer = value.get<std::int64_t>();
    if (integer < std::numeric_limits<s16>::min() || integer > std::numeric_limits<s16>::max()) {
        throw std::runtime_error("scene audio integer exceeds its range");
    }
    return static_cast<s16>(integer);
}

/**
 * Tries complete scene sound documents before committing any gameplay table rows.
 */
template <typename Record, typename Decode>
std::optional<std::vector<Record> > SceneRows(char *source, int size, const char *kind, std::size_t capacity, Decode decode) {
    std::vector<std::string> candidates;
    if (const auto path = DataReadBufferPath(source)) {
        candidates = AudioDocuments(*path);
    } else if (source && size > 0) {
        candidates.emplace_back(source, static_cast<std::size_t>(size));
    }
    std::string error = "scene sound document missing";
    for (const auto &text : candidates) {
        try {
            const auto document = Json::parse(text);
            if (document.at("schema_version") != 1 || document.at("kind") != kind || !document.at("rows").is_array() || document.at("rows").size() > capacity) {
                throw std::runtime_error("unsupported scene sound table schema");
            }
            std::vector<Record> rows;
            for (const auto &row : document.at("rows")) {
                rows.push_back(decode(row));
            }
            return rows;
        } catch (const std::exception &exception) {
            error = exception.what();
        }
    }
    std::fprintf(stderr, "scene audio: %s\n", error.c_str());
    return std::nullopt;
}

/**
 * Copies a fixed-size numeric routing field from its JSON array.
 */
template <std::size_t Count>
void SceneArray(const Json &row, const char *name, s16 (&destination)[Count]) {
    const auto &values = row.at(name);
    if (!values.is_array() || values.size() != Count) {
        throw std::runtime_error("invalid scene sound routing array");
    }
    for (std::size_t index = 0; index < Count; ++index) {
        destination[index] = SceneInteger(values[index]);
    }
}

/**
 * Formats a sound resource number with the game's leading zero convention.
 */
void SoundNumber(char *out, int number) {
    std::sprintf(out, "%s%d", number < 10 ? "00" : number < 100 ? "0"
                                                                : "",
                 number);
}
} // namespace

PORT_OVERRIDE void CScene::GetBgmFile(char *path, int number) {
    char digits[16];
    SoundNumber(digits, number);
    std::sprintf(path, "snd2/bgm/bg_%s.sound.json", digits);
}

PORT_OVERRIDE void CScene::GetSeSrcFile(char *path, int number) {
    char digits[16];
    SoundNumber(digits, number);
    std::sprintf(path, "snd2/ob/ob_%s.sound.json", digits);
}

PORT_OVERRIDE void CScene::GetSeEnvFile(char *path, int number) {
    char digits[16];
    SoundNumber(digits, number);
    std::sprintf(path, "snd2/env/sr_%s.sound.json", digits);
}

PORT_OVERRIDE void CScene::GetSeBaseFile(char *path, int number) {
    char digits[16];
    SoundNumber(digits, number);
    std::sprintf(path, "snd2/bs/bs_%s.sound.json", digits);
}

PORT_OVERRIDE void CScene::GetSeBattleFile(char *path, int number) {
    char digits[16];
    SoundNumber(digits, number);
    std::sprintf(path, "snd2/fg/fg_%s.sound.json", digits);
}

PORT_OVERRIDE int CScene::GetDefEventSeFile(int id, char *path) {
    const auto *entry = SearchSndDataID(id);
    if (!entry) {
        return 0;
    }
    char bank_digits[16], number_digits[16];
    SoundNumber(bank_digits, entry->event_se[0]);
    SoundNumber(number_digits, entry->event_se[1]);
    std::sprintf(path, "snd2/event/ev_%s_%s.sound.json", bank_digits, number_digits);
    return 1;
}

PORT_OVERRIDE void CScene::LoadSndRevInfo(char *source, int size) {
    const auto rows = SceneRows<SND_REV_INFO>(source, size, "scene_reverb", std::size(snd_rev), [](const Json &row) {
        SND_REV_INFO record{};
        record.id = SceneInteger(row.at("id"));
        record.type = SceneInteger(row.at("type"));
        record.depth = SceneInteger(row.at("depth"));
        return record;
    });
    if (rows) {
        std::copy(rows->begin(), rows->end(), std::begin(snd_rev));
        snd_rev_num = static_cast<int>(rows->size());
    }
}

PORT_OVERRIDE void CScene::LoadSndFileInfo(char *source, int size) {
    const auto rows = SceneRows<SND_FILE_INFO>(source, size, "scene_sound_routes", std::size(snd_file), [this](const Json &row) {
        SND_FILE_INFO record{};
        record.id = SceneInteger(row.at("id"));
        record.bgm_no = SceneInteger(row.at("bgm_no"));
        record.se_base = SceneInteger(row.at("se_base"));
        record.se_battle = SceneInteger(row.at("se_battle"));
        record.se_env = SceneInteger(row.at("se_env"));
        record.env_bgm = SceneInteger(row.at("env_bgm"));
        record.env_vol = SceneInteger(row.at("env_vol"));
        SceneArray(row, "se_src", record.se_src);
        SceneArray(row, "event_se", record.event_se);
        const auto reverb_id = SceneInteger(row.at("reverb_id"));
        for (int index = 0; index < snd_rev_num; ++index) {
            if (snd_rev[index].id == reverb_id) {
                record.reverb_type = static_cast<u8>(snd_rev[index].type);
                record.reverb_depth = static_cast<u8>(snd_rev[index].depth);
                break;
            }
        }
        return record;
    });
    if (rows) {
        std::copy(rows->begin(), rows->end(), std::begin(snd_file));
        snd_file_num = static_cast<int>(rows->size());
    }
}
