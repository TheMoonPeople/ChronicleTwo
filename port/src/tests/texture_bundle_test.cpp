#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <cstdint>
#include <cstdlib>
#include <filesystem>
#include <stdexcept>
#include <vector>

#include "platform/archive_mount.hpp"
#include "platform/texture_bundle.hpp"
#include "platform/vfs.hpp"

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
    const auto *data_path = std::getenv("DC2_DATA");
    if (!data_path || !*data_path) {
        GTEST_SKIP() << "DC2_DATA selects the published retail asset root";
    }
    const auto root = std::filesystem::u8path(data_path);
    const auto archive = root.parent_path() / "data.zip";
    const auto mount = std::filesystem::is_regular_file(archive) ? ArchiveMountOpen(archive) : vfs::OpenDirectory(root);
    for (int language = 0; language < 7; ++language) {
        SCOPED_TRACE(language);
        const auto index = mount->Find("dungeon/articles/tex01_" + std::to_string(language) + ".game.json");
        if (!index) {
            FAIL() << "missing dungeon texture metadata for language " << language;
        }
        std::vector<std::uint8_t> bytes;
        ASSERT_TRUE(vfs::Read(vfs::Ref(mount, *index), bytes));
        const auto game = Json::parse(bytes);
        for (const auto *entry : std::array{"frame", "effect00", "sweff", "potbeam", "ref", "fire_wrk"}) {
            EXPECT_TRUE(texture_bundle::FindSet(game, entry)) << entry;
        }
        EXPECT_EQ(texture_bundle::FindSet(game, "bteffe_chi").has_value(), language != 0);
    }
}
