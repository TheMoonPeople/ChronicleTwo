#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <string>

#include "dataread_port.hpp"
#include "platform/datapacks.hpp"
#include "scenesnd.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Supplies scene sound tables without loading game state or proprietary resources.
 */
class SceneAudio : public testing::Test {
protected:
    std::unique_ptr<CScene> scene = std::make_unique<CScene>();

    static Json Reverbs() {
        return {
            {"schema_version", 1                                                     },
            {"kind",           "scene_reverb"                                        },
            {"rows",           Json::array({{{"id", 7}, {"type", 4}, {"depth", 23}}})}
        };
    }

    static Json Routes() {
        return {
            {"schema_version", 1                                                                                                                                                                                                                      },
            {"kind",           "scene_sound_routes"                                                                                                                                                                                                   },
            {"rows",           Json::array({{{"id", 1000}, {"bgm_no", 12}, {"se_base", -2}, {"se_battle", 3}, {"se_env", 8}, {"env_bgm", -1}, {"env_vol", 91}, {"se_src", {-2, -1, -1, -1, -1, -1, -1, -1}}, {"event_se", {4, 9}}, {"reverb_id", 7}}})}
        };
    }

    void Reverb(const Json &document) {
        auto text = document.dump(2);
        TextureSourceForget(text.data());
        scene->LoadSndRevInfo(text.data(), static_cast<int>(text.size()));
    }

    void Route(const Json &document) {
        auto text = document.dump(2);
        TextureSourceForget(text.data());
        scene->LoadSndFileInfo(text.data(), static_cast<int>(text.size()));
    }
};
} // namespace

TEST_F(SceneAudio, DirectTablesPreserveMapRoutingAndResolveReverbOverrides) {
    Reverb(Reverbs());
    Route(Routes());
    ASSERT_EQ(scene->snd_rev_num, 1);
    ASSERT_EQ(scene->snd_file_num, 1);
    const auto &route = scene->snd_file[0];
    EXPECT_EQ(route.id, 1000);
    EXPECT_EQ(scene->GetDefBgmNo(1000), 12);
    EXPECT_EQ(route.se_base, -2);
    EXPECT_EQ(route.se_battle, 3);
    EXPECT_EQ(route.se_env, 8);
    EXPECT_EQ(route.env_bgm, -1);
    EXPECT_EQ(route.env_vol, 91);
    EXPECT_EQ(route.se_src[0], -2);
    EXPECT_EQ(route.se_src[7], -1);
    EXPECT_EQ(route.reverb_type, 4);
    EXPECT_EQ(route.reverb_depth, 23);
    char path[128]{};
    ASSERT_EQ(scene->GetDefEventSeFile(1000, path), 1);
    EXPECT_STREQ(path, "snd2/event/ev_004_009.sound.json");
    auto override = Reverbs();
    override["rows"][0]["depth"] = 77;
    Reverb(override);
    Route(Routes());
    EXPECT_EQ(scene->snd_file[0].reverb_depth, 77);
}

TEST_F(SceneAudio, MalformedAndOversizedDocumentsDoNotPartiallyReplaceTables) {
    Reverb(Reverbs());
    Route(Routes());
    auto malformed = Routes();
    malformed["rows"][0]["bgm_no"] = 42;
    malformed["rows"].push_back(malformed["rows"][0]);
    malformed["rows"][1]["se_src"] = {1, 2};
    Route(malformed);
    EXPECT_EQ(scene->snd_file_num, 1);
    EXPECT_EQ(scene->snd_file[0].bgm_no, 12);
    auto oversized = Routes();
    oversized["rows"] = Json::array();
    for (int index = 0; index < 513; ++index) {
        oversized["rows"].push_back(Routes()["rows"][0]);
    }
    Route(oversized);
    EXPECT_EQ(scene->snd_file_num, 1);
    auto invalid = Reverbs();
    invalid["rows"][0]["depth"] = std::numeric_limits<std::uint64_t>::max();
    Reverb(invalid);
    EXPECT_EQ(scene->snd_rev_num, 1);
    EXPECT_EQ(scene->snd_rev[0].depth, 23);
}

TEST_F(SceneAudio, MalformedDatapackFallsThroughToValidBaseTable) {
    const auto previous = datapacks::Root();
    const auto root = std::filesystem::temp_directory_path() / ("scene_audio_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::create_directories(root / "data/snd2");
    std::filesystem::create_directories(root / "datapacks/test/snd2");
    std::ofstream(root / "data/snd2/rev.json") << Reverbs().dump(2);
    std::ofstream(root / "datapacks/test/snd2/rev.json") << "invalid JSON";
    std::ofstream(root / "datapacks/datapacks.json") << Json({
                                                                 {"schema_version", 1       },
                                                                 {"load_order",     {"test"}}
    })
                                                            .dump(2);
    datapacks::Load(root / "data");
    std::string text = "invalid JSON";
    DataReadRegisterAsset(text.data(), "snd2/rev.json", text.size());
    scene->LoadSndRevInfo(text.data(), static_cast<int>(text.size()));
    EXPECT_EQ(scene->snd_rev_num, 1);
    EXPECT_EQ(scene->snd_rev[0].depth, 23);
    DataReadRegisterBuffer(text.data(), 0);
    TextureSourceForget(text.data());
    if (previous.empty()) {
        datapacks::Clear();
    } else {
        datapacks::Load(previous);
    }
    std::error_code error;
    std::filesystem::remove_all(root, error);
}
