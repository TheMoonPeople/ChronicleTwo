#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <stdexcept>

#include "platform/texture_bundle.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Builds a texture-set row with an authored native image name.
 */
Json TextureSet(const char *name) {
    return {
        {"document", {{"entries", Json::array({{{"name", name}}})}}}
    };
}
} // namespace

TEST(TextureBundle, SelectsAuthoredNamesAcrossReorderedSets) {
    Json game{
        {"resources", {{"texture_sets", Json::array({TextureSet("effect00"), TextureSet("frame")})}}}
    };
    EXPECT_EQ(texture_bundle::FindSet(game, "frame"), 1);
    EXPECT_EQ(texture_bundle::FindSet(game, "effect00"), 0);
    EXPECT_FALSE(texture_bundle::FindSet(game, "missing"));
    std::swap(game["resources"]["texture_sets"][0], game["resources"]["texture_sets"][1]);
    EXPECT_EQ(texture_bundle::FindSet(game, "frame"), 0);
    game["resources"]["texture_sets"][0]["document"]["entries"].push_back({
        {"name", "frame"}
    });
    EXPECT_EQ(texture_bundle::FindSet(game, "frame"), 0);
}

TEST(TextureBundle, RejectsAmbiguousNamesAcrossDistinctSets) {
    const Json game{
        {"texture_sets", Json::array({TextureSet("frame"), TextureSet("frame")})}
    };
    EXPECT_THROW(texture_bundle::FindSet(game, "frame"), std::runtime_error);
}

TEST(TextureBundleRetail, EveryDungeonLanguageContainsTheExpectedSharedAtlases) {
    const auto *manifest_path = std::getenv("CT_CFG_PARITY_MANIFEST");
    if (!manifest_path || !*manifest_path) {
        GTEST_SKIP() << "CT_CFG_PARITY_MANIFEST selects the converted retail asset root";
    }
    Json manifest;
    std::ifstream(manifest_path) >> manifest;
    const std::filesystem::path root = manifest.at("port_data").get<std::string>();
    for (int language = 0; language < 7; ++language) {
        SCOPED_TRACE(language);
        Json          game;
        std::ifstream input(root / ("dungeon/articles/tex01_" + std::to_string(language) + ".game.json"));
        ASSERT_TRUE(input.good());
        input >> game;
        for (const auto *entry : std::array{"frame", "effect00", "sweff", "potbeam", "ref", "fire_wrk"}) {
            EXPECT_TRUE(texture_bundle::FindSet(game, entry)) << entry;
        }
        EXPECT_EQ(texture_bundle::FindSet(game, "bteffe_chi").has_value(), language != 0);
    }
}
