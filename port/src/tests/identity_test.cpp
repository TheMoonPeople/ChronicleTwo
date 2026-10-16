#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <filesystem>
#include <fstream>

#include "identity.hpp"
#include "platform/datapacks.hpp"
#include "platform_fixture.hpp"

namespace {
/**
 * Creates a self-contained standard triangle icon with a selectable material colour.
 */
void WriteIcon(const std::filesystem::path &path, float red, float green) {
    using Json = nlohmann::json;
    const Json icon = {
        {"asset",       {{"version", "2.0"}}                                                                                                                 },
        {"buffers",     Json::array({{{"byteLength", 36}, {"uri", "data:application/octet-stream;base64,AACAvwAAgL8AAAAAAACAPwAAgL8AAAAAAAAAAAAAgD8AAAAA"}}})},
        {"bufferViews", Json::array({{{"buffer", 0}, {"byteLength", 36}}})                                                                                   },
        {"accessors",   Json::array({{{"bufferView", 0}, {"componentType", 5126}, {"count", 3}, {"type", "VEC3"}, {"min", {-1, -1, 0}}, {"max", {1, 1, 0}}}})},
        {"materials",   Json::array({{{"pbrMetallicRoughness", {{"baseColorFactor", {red, green, 0, 1}}}}}})                                                 },
        {"meshes",      Json::array({{{"primitives", Json::array({{{"attributes", {{"POSITION", 0}}}, {"material", 0}}})}}})                                 },
        {"nodes",       Json::array({{{"mesh", 0}}})                                                                                                         },
        {"scenes",      Json::array({{{"nodes", {0}}}})                                                                                                      },
        {"scene",       0                                                                                                                                    }
    };
    std::filesystem::create_directories(path.parent_path());
    std::ofstream(path) << icon.dump(2) << '\n';
}
} // namespace

TEST(NativeIcon, ActualTitleModelUsesValidDatapackThenRetailFallback) {
    namespace fs = std::filesystem;
    const auto root = fs::temp_directory_path() / ("dc2_native_icon_" + std::to_string(dc::test::ProcessId()));
    fs::remove_all(root);

    struct Cleanup {
        fs::path root;
        fs::path previous;

        ~Cleanup() {
            if (previous.empty()) {
                datapacks::Clear();
            } else {
                datapacks::Load(previous);
            }
            std::error_code error;
            fs::remove_all(root, error);
        }
    } cleanup{root, datapacks::Root()};

    WriteIcon(root / "port_data/title/dc2_ic.gltf", 1, 0);
    WriteIcon(root / "datapacks/icon/title/dc2_ic.gltf", 0, 1);
    const nlohmann::json config = {
        {"schema_version", 1       },
        {"load_order",     {"icon"}}
    };
    std::ofstream(root / "datapacks/datapacks.json") << config.dump(2) << '\n';
    datapacks::Load(root / "port_data");
    const auto source = GameDataIconSource();
    ASSERT_EQ(source.packs, std::vector<fs::path>{"title"});
    EXPECT_STREQ(source.member, "dc2_ic.gltf");
    auto pixels = GameIconFromData(datapacks::Root(), source, 32);
    ASSERT_EQ(pixels.size(), 32u * 32u * 4u);
    auto channel = [](const auto &rgba, int component) {
        unsigned total = 0;
        for (std::size_t at = component; at < rgba.size(); at += 4) {
            total += rgba[at];
        }
        return total;
    };
    EXPECT_GT(channel(pixels, 1), channel(pixels, 0));
    std::ofstream(root / "datapacks/icon/title/dc2_ic.gltf") << "invalid model";
    pixels = GameIconFromData(datapacks::Root(), source, 32);
    ASSERT_EQ(pixels.size(), 32u * 32u * 4u);
    EXPECT_GT(channel(pixels, 0), channel(pixels, 1));
    fs::remove(root / "port_data/title/dc2_ic.gltf");
    EXPECT_TRUE(GameIconFromData(datapacks::Root(), source, 32).empty());
}
