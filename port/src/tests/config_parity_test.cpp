#include <fastgltf/core.hpp>
#include <gtest/gtest.h>
#include <nlohmann/json.hpp>
#include <stb_image.h>

#include <algorithm>
#include <bit>
#include <cctype>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <map>
#include <optional>
#include <set>
#include <stdexcept>
#include <string>
#include <string_view>
#include <type_traits>
#include <vector>

#include "platform/config_catalog.hpp"
#include "platform/datapacks.hpp"
#include "scriptinterpreter.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;
/** Callback observations collected during one parity execution. */
Json observations;

/**
 * Captures exact native types, integer values, float bits, and game-encoded string bytes.
 */
int CaptureParity(SPI_STACK *stack, int count) {
    Json arguments = Json::array();
    for (int index = 0; index < std::min(count, static_cast<int>(SPI_STACK_SIZE)); ++index) {
        const auto &argument = stack[index];
        Json        value{
            {"type", argument.type}
        };
        if (argument.type == SPI_STACK_TYPE_INT) {
            value["integer"] = argument.value.integer;
        }
        if (argument.type == SPI_STACK_TYPE_FLOAT) {
            value["float_bits"] = std::bit_cast<uint32_t>(argument.value.real);
        }
        if (argument.type == SPI_STACK_TYPE_STRING) {
            Json bytes = Json::array();
            if (argument.value.string) {
                for (auto *text = reinterpret_cast<const unsigned char *>(argument.value.string); *text; ++text) {
                    bytes.push_back(*text);
                }
            }
            value["string_bytes"] = std::move(bytes);
            value["null"] = !argument.value.string;
        }
        arguments.push_back(std::move(value));
    }
    observations.push_back({
        {"count",     count               },
        {"arguments", std::move(arguments)}
    });
    return 0;
}

/**
 * Limits dynamic test tags to the ASCII identifiers used by real callback tables.
 */
bool TagName(const std::string &name) {
    if (name.empty() || (name.front() != '_' && (name.front() < 'A' || name.front() > 'Z'))) {
        return false;
    }
    return std::all_of(name.begin(), name.end(), [](unsigned char value) {
        return (value >= 'A' && value <= 'Z') || (value >= 'a' && value <= 'z') ||
               (value >= '0' && value <= '9') || value == '_';
    });
}

/**
 * Executes one script and records the callback-table index of every observed command.
 */
Json Execute(char *script, int size, std::vector<SPI_TAG_PARAM> &tags) {
    observations = Json::array();
    CScriptInterpreter interpreter;
    interpreter.SetTag(tags.data());
    interpreter.SetScript(script, size);
    for (;;) {
        const auto previous = observations.size();
        const auto index = interpreter.GetNextTAG(1);
        if (observations.size() > previous) {
            observations.back()["tag"] = index;
        }
        if (index < 0) {
            break;
        }
    }
    return observations;
}

/**
 * Identifies the character resource slots interpreted by the native profile dispatcher.
 */
std::string ResourceKind(const std::string &command, std::size_t argument) {
    if ((command == "MODEL" || command == "SHADOW_MODEL") && argument == 0) {
        return "model";
    }
    if (command == "IMG" && argument == 1) {
        return "texture_set";
    }
    if (command == "MOTION") {
        if (argument == 1) {
            return "animation";
        }
        if (argument == 2) {
            return "bind_pose";
        }
        if (argument == 3) {
            return "weights";
        }
    }
    if (command == "SHADOW_MOTION") {
        if (argument == 1) {
            return "bind_pose";
        }
        if (argument == 2) {
            return "weights";
        }
    }
    if (command == "LOD_MODEL") {
        if (argument == 1) {
            return "model";
        }
        if (argument == 2) {
            return "weights";
        }
        if (argument == 3) {
            return "bind_pose";
        }
    }
    if (command == "CLOTH") {
        return "cloth";
    }
    if (command == "EFFECT_START" && argument == 0) {
        return "character";
    }
    if (command == "EFFECT" && argument == 0) {
        return "script";
    }
    return {};
}

/**
 * Limits generic filename changes to resource-bearing fields in actual retail CFG consumers.
 */
bool FilenameSlot(const std::string &command, std::size_t argument, bool map) {
    if (command == "IMG" && map) {
        return argument == 0;
    }
    if (command == "CHARA") {
        return argument <= 1;
    }
    if (command == "MDS" || command == "MODEL" || command == "SHADOW_MODEL" || command == "SKY_BG" || command == "WATER_PARTS_NAME" || command == "PIECE") {
        return argument == 0;
    }
    if (command == "IMG" || command == "MOVIE" || command == "SKYB_MDS" || command == "SKY_IMG" || command == "SKY_MDS" || command == "SUN_MDS" || command == "MASK_PARTS_NAME") {
        return argument == 1;
    }
    if (command == "MOTION") {
        return argument >= 1 && argument <= 3;
    }
    if (command == "SHADOW_MOTION") {
        return argument == 1 || argument == 2;
    }
    return command == "RIVER_PARTS_NAME" && argument == 2;
}

/**
 * Reads captured native string bytes without applying a Unicode conversion.
 */
std::string CapturedString(const Json &argument) {
    std::string result;
    for (const auto &byte : argument.at("string_bytes")) {
        result.push_back(static_cast<char>(byte.get<unsigned char>()));
    }
    return result;
}

/**
 * Normalizes an ASCII resource identity for the extraction inventory comparison.
 */
std::string Lower(std::string value) {
    std::replace(value.begin(), value.end(), '\\', '/');
    std::transform(value.begin(), value.end(), value.begin(), [](unsigned char character) { return static_cast<char>(std::tolower(character)); });
    return value;
}

/**
 * Computes the permitted direct native filename for one documented resource operand.
 */
std::string NativeFilename(std::string original, bool profile) {
    std::replace(original.begin(), original.end(), '\\', '/');
    const auto dot = original.rfind('.');
    if (dot == std::string::npos) {
        return original;
    }
    const auto extension = Lower(original.substr(dot));
    if (profile) {
        return extension == ".cfg" ? original.substr(0, dot) : original;
    }
    std::string replacement;
    if (extension == ".chr" || extension == ".mds" || extension == ".mdt" || extension == ".mot" || extension == ".wgt" || extension == ".bbp") {
        replacement = ".gltf";
    }
    if (extension == ".cfg") {
        replacement = ".cfg.json";
    }
    if (extension == ".map") {
        replacement = ".map.json";
    }
    if (extension == ".img" || extension == ".tm2") {
        replacement = ".json";
    }
    if (extension == ".snd") {
        replacement = ".sound.json";
    }
    if (extension == ".pss") {
        replacement = ".mp4";
    }
    return replacement.empty() ? original : original.substr(0, dot) + replacement;
}

/**
 * Reads asserted gameplay fields without building unrelated geometry and motion payloads.
 */
Json ReadParityGameplay(std::ifstream &input) {
    input.seekg(0, std::ios::end);
    const auto size = input.tellg();
    input.seekg(0);
    std::string bytes(static_cast<std::size_t>(size), char{});
    input.read(bytes.data(), static_cast<std::streamsize>(bytes.size()));
    return Json::parse(bytes, [](int, Json::parse_event_t event, Json &value) {
        if (event != Json::parse_event_t::key) {
            return true;
        }
        const auto &key = value.get_ref<const Json::string_t &>();
        return key != "channels" && key != "matrices" && key != "frames" && key != "meshes" && key != "images" && key != "rotation_nodes";
    });
}

/**
 * Stores one decoded raster for byte-exact comparisons across PNG encodings.
 */
struct ParityRaster {
    int                        width = 0;  /**< Pixel width. */
    int                        height = 0; /**< Pixel height. */
    std::vector<unsigned char> pixels;     /**< RGBA pixels in row order. */
};

/**
 * Decodes PNG bytes without consulting active datapacks.
 */
ParityRaster DecodeParityRaster(const std::vector<unsigned char> &bytes) {
    ParityRaster raster;
    int          components = 0;
    auto        *pixels = stbi_load_from_memory(bytes.data(), static_cast<int>(bytes.size()), &raster.width, &raster.height, &components, 4);
    if (!pixels) {
        throw std::runtime_error("texture parity PNG decode failed");
    }
    raster.pixels.assign(pixels, pixels + static_cast<std::size_t>(raster.width) * raster.height * 4);
    stbi_image_free(pixels);
    return raster;
}

/**
 * Compares every semantic field and every mip or variant raster to the original IMG-derived oracle.
 */
void CompareTextureOracle(const Json &actual, const Json &expected, const fastgltf::Asset &asset,
                          const std::filesystem::path &directory, std::map<std::size_t, ParityRaster> &images,
                          std::map<std::string, ParityRaster> &originals, std::string_view field = {}) {
    if (field == "levels") {
        ASSERT_TRUE(actual.is_array());
        ASSERT_TRUE(expected.is_array());
        ASSERT_EQ(actual.size(), expected.size());
        for (std::size_t level = 0; level < actual.size(); ++level) {
            SCOPED_TRACE("mip " + std::to_string(level));
            const auto reference = actual.at(level).get<std::string>();
            ASSERT_TRUE(reference.starts_with("#/images/"));
            const auto image = std::stoul(reference.substr(9));
            ASSERT_LT(image, asset.images.size());
            if (!images.contains(image)) {
                std::vector<unsigned char> bytes;
                std::visit([&](const auto &source) {
                    using T = std::decay_t<decltype(source)>;
                    if constexpr (std::is_same_v<T, fastgltf::sources::Array> || std::is_same_v<T, fastgltf::sources::Vector> || std::is_same_v<T, fastgltf::sources::ByteView>) {
                        bytes.resize(source.bytes.size());
                        std::memcpy(bytes.data(), source.bytes.data(), bytes.size());
                    }
                },
                           asset.images.at(image).data);
                ASSERT_FALSE(bytes.empty());
                images.emplace(image, DecodeParityRaster(bytes));
            }
            const auto path = directory / expected.at(level).get<std::string>();
            const auto key = path.generic_string();
            if (!originals.contains(key)) {
                std::ifstream input(path, std::ios::binary);
                ASSERT_TRUE(input.good()) << path;
                const std::vector<unsigned char> bytes((std::istreambuf_iterator<char>(input)), {});
                originals.emplace(key, DecodeParityRaster(bytes));
            }
            const auto &raster = images.at(image);
            const auto &original = originals.at(key);
            EXPECT_EQ(raster.width, original.width);
            EXPECT_EQ(raster.height, original.height);
            EXPECT_TRUE(raster.pixels == original.pixels) << "embedded image " << image << " differs from " << path;
        }
        return;
    }
    ASSERT_EQ(actual.type(), expected.type());
    if (expected.is_object()) {
        ASSERT_EQ(actual.size(), expected.size());
        for (const auto &[key, value] : expected.items()) {
            SCOPED_TRACE(key);
            ASSERT_TRUE(actual.contains(key));
            CompareTextureOracle(actual.at(key), value, asset, directory, images, originals, key);
        }
    } else if (expected.is_array()) {
        ASSERT_EQ(actual.size(), expected.size());
        for (std::size_t index = 0; index < expected.size(); ++index) {
            SCOPED_TRACE("entry " + std::to_string(index));
            CompareTextureOracle(actual.at(index), expected.at(index), asset, directory, images, originals);
        }
    } else {
        EXPECT_EQ(actual, expected);
    }
}

} // namespace

TEST(NativeConfigParity, MatchesEveryOfflineOriginalInManifest) {
    const auto *manifest_name = std::getenv("CT_CFG_PARITY_MANIFEST");
    if (!manifest_name || !*manifest_name) {
        GTEST_SKIP() << "set CT_CFG_PARITY_MANIFEST to the offline audit manifest";
    }
    Json manifest;
    std::ifstream(manifest_name) >> manifest;
    const std::filesystem::path root = manifest.at("port_data").get<std::string>();
    datapacks::Load(root);
    std::set<std::string> identities, leaf_names;
    for (const auto &identity : manifest.at("identities")) {
        const auto normalized = Lower(identity.get<std::string>());
        identities.insert(normalized);
        leaf_names.insert(std::filesystem::path(normalized).filename().generic_string());
    }
    std::size_t                         count = 0, subtitles = 0, bindings = 0, renamed = 0;
    std::string                         cached_character;
    Json                                game;
    std::optional<fastgltf::Asset>      gltf;
    std::map<std::size_t, ParityRaster> image_rasters;
    std::map<std::string, ParityRaster> original_rasters;
    std::map<std::string, Json>         oracle_documents;
    for (const auto &source : manifest.at("sources")) {
        const auto alias = source.at("alias").get<std::string>();
        SCOPED_TRACE(alias);
        const bool character = source.contains("game");
        Json       document;
        if (character) {
            const auto path = source.at("gltf").get<std::string>();
            if (cached_character != path) {
                std::ifstream input(root / source.at("game").get<std::string>());
                ASSERT_TRUE(input.good());
                game = ReadParityGameplay(input);
                auto bytes = fastgltf::GltfDataBuffer::FromPath(root / path);
                ASSERT_EQ(bytes.error(), fastgltf::Error::None);
                fastgltf::Parser parser;
                auto             parsed = parser.loadGltf(bytes.get(), (root / path).parent_path(), fastgltf::Options::None,
                                                          fastgltf::Category::Scenes | fastgltf::Category::Images | fastgltf::Category::Asset);
                ASSERT_EQ(parsed.error(), fastgltf::Error::None);
                gltf = std::move(parsed.get());
                cached_character = path;
                image_rasters.clear();
                original_rasters.clear();
                oracle_documents.clear();
            }
            ASSERT_EQ(game.at("schema_version"), 1);
            document = game.at("profiles").at(source.at("profile").get<std::string>());
            document["schema_version"] = 1;
        } else {
            std::ifstream input(root / source.at("json").get<std::string>());
            ASSERT_TRUE(input.good());
            input >> document;
        }
        if (document.value("kind", "") == "movie_subtitles") {
            ++subtitles;
            continue;
        }
        std::set<std::string>     names;
        int                       max_index = -1;
        std::vector<const Json *> executed;
        for (const auto &command : document.at("commands")) {
            if (command.contains("tag_index")) {
                max_index = std::max(max_index, command.at("tag_index").get<int>());
            } else if (TagName(command.at("command").get<std::string>())) {
                names.insert(command.at("command").get<std::string>());
            }
            if (command.contains("tag_index") || TagName(command.at("command").get<std::string>())) {
                executed.push_back(&command);
            }
        }
        ASSERT_LT(max_index, 4096);
        std::vector<std::string> strings(names.begin(), names.end());
        if (max_index >= 0) {
            strings.clear();
            for (int index = 0; index <= max_index; ++index) {
                strings.push_back("TAG_" + std::to_string(index));
            }
        }
        std::vector<SPI_TAG_PARAM> tags;
        for (auto &name : strings) {
            tags.push_back({name.data(), CaptureParity});
        }
        tags.push_back({nullptr, nullptr});
        std::ifstream input(source.at("original").get<std::string>(), std::ios::binary);
        ASSERT_TRUE(input.good());
        std::vector<char> bytes((std::istreambuf_iterator<char>(input)), {});
        const auto        size = static_cast<int>(bytes.size());
        bytes.push_back(0);
        const auto original = Execute(bytes.data(), size, tags);
        Json       sanitized = document;
        for (auto &command : sanitized.at("commands")) {
            for (auto &arg : command.at("args")) {
                if (arg.at("type") == "resource") {
                    arg = {
                        {"type",  "invalid"},
                        {"value", nullptr  }
                    };
                }
            }
        }
        auto       text = sanitized.dump();
        const auto native = Execute(text.data(), static_cast<int>(text.size()), tags);
        ASSERT_EQ(native.size(), original.size());
        ASSERT_EQ(native.size(), executed.size());
        const auto container = alias.substr(0, alias.rfind('/'));
        auto       effect_container = container;
        for (std::size_t row = 0; row < native.size(); ++row) {
            const auto &command = *executed.at(row);
            const auto  name = command.value("command", std::string{});
            SCOPED_TRACE(name + " row " + std::to_string(row));
            ASSERT_EQ(native.at(row).at("tag"), original.at(row).at("tag"));
            ASSERT_EQ(native.at(row).at("count"), original.at(row).at("count"));
            ASSERT_EQ(native.at(row).at("arguments").size(), command.at("args").size());
            for (std::size_t arg = 0; arg < command.at("args").size(); ++arg) {
                const auto &converted = command.at("args").at(arg);
                const auto &baseline = original.at(row).at("arguments").at(arg);
                const auto &actual = native.at(row).at("arguments").at(arg);
                SCOPED_TRACE("argument " + std::to_string(arg));
                if (converted.at("type") == "resource") {
                    ASSERT_TRUE(character);
                    ASSERT_EQ(baseline.at("type"), SPI_STACK_TYPE_STRING);
                    ASSERT_EQ(actual.at("type"), SPI_STACK_TYPE_INVALID);
                    const auto kind = ResourceKind(name, arg);
                    ASSERT_FALSE(kind.empty());
                    ASSERT_EQ(converted.at("kind"), kind);
                    const auto operand = CapturedString(baseline);
                    const auto resource_alias = (name == "EFFECT" ? effect_container : container) + "/" + operand;
                    if (converted.at("index").is_null()) {
                        EXPECT_FALSE(identities.contains(Lower(resource_alias))) << "present resource dropped: " << resource_alias;
                    } else {
                        const auto  key = kind == "animation" ? "animations" : kind == "bind_pose" ? "bind_poses"
                                                                           : kind == "weights"     ? "weights"
                                                                           : kind == "texture_set" ? "texture_sets"
                                                                           : kind == "cloth"       ? "cloths"
                                                                           : kind == "character"   ? "children"
                                                                                                   : "scripts";
                        const auto &resources = kind == "model" ? game.at("models") : game.at("resources").at(key);
                        const auto  index = converted.at("index").get<std::size_t>();
                        ASSERT_LT(index, resources.size());
                        if (kind == "model") {
                            EXPECT_EQ(std::string(gltf->scenes.at(resources.at(index).at("scene").get<std::size_t>()).name), std::filesystem::path(operand).stem().string());
                        } else if (kind != "texture_set") {
                            EXPECT_EQ(Lower(manifest.at("character_resources").at(container).at(kind).at(index).get<std::string>()), Lower(resource_alias));
                        } else {
                            ASSERT_TRUE(manifest.contains("texture_documents")) << "regenerate fixture with --texture-oracle";
                            const auto &documents = manifest.at("texture_documents");
                            ASSERT_TRUE(documents.contains(Lower(resource_alias))) << "missing original IMG oracle: " << resource_alias;
                            const auto path = documents.at(Lower(resource_alias)).get<std::string>();
                            if (!oracle_documents.contains(path)) {
                                std::ifstream input(path);
                                ASSERT_TRUE(input.good()) << path;
                                input >> oracle_documents[path];
                            }
                            CompareTextureOracle(resources.at(index).at("document"), oracle_documents.at(path), *gltf,
                                                 std::filesystem::path(path).parent_path(), image_rasters, original_rasters);
                        }
                        EXPECT_TRUE(identities.contains(Lower(resource_alias))) << resource_alias;
                    }
                    if (name == "EFFECT_START") {
                        effect_container = resource_alias;
                    }
                    ++bindings;
                    continue;
                }
                if (actual == baseline) {
                    continue;
                }
                ASSERT_FALSE(character) << "gameplay profile argument changed";
                ASSERT_TRUE(FilenameSlot(name, arg, alias.ends_with(".map"))) << "non-resource argument changed";
                ASSERT_EQ(baseline.at("type"), SPI_STACK_TYPE_STRING);
                ASSERT_EQ(actual.at("type"), SPI_STACK_TYPE_STRING);
                ASSERT_EQ(baseline.at("null"), actual.at("null"));
                const auto old_name = CapturedString(baseline), new_name = CapturedString(actual);
                const auto expected = NativeFilename(old_name, name == "CHARA" && arg == 1);
                ASSERT_NE(expected, old_name);
                EXPECT_EQ(new_name, expected);
                if (!(name == "CHARA" && arg == 1)) {
                    const auto normalized = Lower(old_name);
                    const auto basename = std::filesystem::path(normalized).filename().generic_string();
                    const bool exists = identities.contains(normalized) || identities.contains(Lower(container + "/" + old_name)) || leaf_names.contains(basename);
                    EXPECT_TRUE(exists) << old_name;
                }
                ++renamed;
            }
        }
        ++count;
    }
    std::printf("CFG parity: %zu scripts; %zu resource bindings; %zu native filename changes; %zu subtitle documents\n", count, bindings, renamed, subtitles);
    datapacks::Clear();
}
