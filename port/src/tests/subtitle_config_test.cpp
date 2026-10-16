#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>

#include "nd_meswin.hpp"
#include "platform/config_catalog.hpp"
#include "platform/datapacks.hpp"
#include "platform/subtitle_config.hpp"
#include "texture_source.hpp"

namespace {
class NativeSubtitles : public testing::Test {
protected:
    std::filesystem::path root = std::filesystem::temp_directory_path() /
                                 ("ct_subtitles_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));

    void Write(const std::filesystem::path &path, const std::string &text) {
        std::filesystem::create_directories(path.parent_path());
        std::ofstream(path) << text;
    }

    void TearDown() override {
        config_catalog::Clear();
        datapacks::Clear();
        TextureSourceClear();
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }
};

/**
 * Captures the retired caption reader's exact boundaries and line-feed decoding for parity.
 */
std::vector<subtitle_config::Cue> Original(std::vector<char> text, int chapter) {
    const int length = static_cast<int>(text.size());
    text.push_back('\n');
    text.push_back('\0');
    auto                             *cursor = GetTopAddress(text.data(), length, chapter);
    std::vector<subtitle_config::Cue> cues(MOVIE_CC_MAX);
    std::size_t                       slot = 0;
    while (cursor && cursor < text.data() + length) {
        if (std::strncmp(cursor, "_STA ", 5) == 0) {
            cursor += 5;
            cues.at(slot).start_frame = static_cast<int>(30 * std::atof(cursor));
            GetNextLineTop(&cursor);
        } else if (std::strncmp(cursor, "_CLR ", 5) == 0) {
            cursor += 5;
            cues.at(slot).clear_frame = static_cast<int>(30 * std::atof(cursor));
            GetNextLineTop(&cursor);
        } else if (std::strncmp(cursor, "_STR ", 5) == 0) {
            cursor += 5;
            std::vector<char> decoded(text.size());
            MyStrCpyLineFeed(decoded.data(), cursor);
            cues.at(slot++).text = decoded.data();
            GetNextLineTop(&cursor);
        } else if (std::strncmp(cursor, "_END", 4) == 0) {
            break;
        } else {
            ++cursor;
        }
    }
    return cues;
}
} // namespace

TEST_F(NativeSubtitles, UsesTypedTimesAndTextWithInvalidOverlayFallback) {
    Write(root / "port_data/configs/help.json", R"({"schema_version":1,"kind":"movie_subtitles","chapters":[{"id":901,"entries":[{"start_seconds":1.65,"clear_seconds":9.55,"text":"Line one\nLine two"}]}]})");
    Write(root / "datapacks/datapacks.json", R"({"schema_version":1,"load_order":["broken"]})");
    Write(root / "datapacks/broken/configs/help.json", R"({"schema_version":1,"kind":"movie_subtitles","chapters":"invalid"})");
    datapacks::Load(root / "port_data");
    std::string                       error;
    std::vector<subtitle_config::Cue> cues;
    ASSERT_TRUE(subtitle_config::Load("configs/help.json", 901, cues, error)) << error;
    std::ifstream input(root / "port_data/configs/help.json");
    std::string   bytes{std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>()};
    MovieCCAnalyze(bytes.data(), static_cast<int>(bytes.size()), 1);
    EXPECT_EQ(MovieCCStart[0], 49);
    EXPECT_EQ(MovieCCClear[0], 286);
    EXPECT_STREQ(MovieCCStr[0], "Line one\nLine two");
}

TEST_F(NativeSubtitles, MatchesEveryOfflineSubtitleChapter) {
    const auto *manifest_name = std::getenv("CT_CFG_PARITY_MANIFEST");
    if (!manifest_name || !*manifest_name) {
        GTEST_SKIP() << "set CT_CFG_PARITY_MANIFEST to the offline CFG audit manifest";
    }
    nlohmann::json manifest;
    std::ifstream(manifest_name) >> manifest;
    const auto expected = std::count_if(manifest.at("sources").begin(), manifest.at("sources").end(), [](const auto &source) {
        const auto alias = source.at("alias").template get<std::string>();
        for (int language = 1; language <= 5; ++language) {
            if (alias == "menu/" + std::to_string(language) + "/help.cfg") {
                return true;
            }
        }
        return false;
    });
    if (expected == 0) {
        GTEST_SKIP() << "the selected fixture has no retail movie subtitle sources";
    }
    const std::filesystem::path port = manifest.at("port_data").get<std::string>();
    datapacks::Load(port);
    std::string error;
    std::size_t documents = 0, chapters = 0;
    for (const auto &source : manifest.at("sources")) {
        const auto alias = source.at("alias").get<std::string>();
        if (!source.contains("json")) {
            continue;
        }
        const auto     path = source.at("json").get<std::string>();
        nlohmann::json document;
        std::ifstream(port / path) >> document;
        if (document.value("kind", "") != "movie_subtitles") {
            continue;
        }
        ++documents;
        std::ifstream           input(source.at("original").get<std::string>(), std::ios::binary);
        const std::vector<char> original((std::istreambuf_iterator<char>(input)), {});
        for (const auto &track : document.at("chapters")) {
            const int chapter = track.at("id");
            SCOPED_TRACE(alias + " chapter " + std::to_string(chapter));
            const auto                        baseline = Original(original, chapter);
            std::vector<subtitle_config::Cue> native;
            ASSERT_TRUE(subtitle_config::Load(path, chapter, native, error)) << error;
            native.resize(MOVIE_CC_MAX);
            ASSERT_EQ(native.size(), baseline.size());
            for (std::size_t index = 0; index < native.size(); ++index) {
                EXPECT_EQ(native[index].start_frame, baseline[index].start_frame);
                EXPECT_EQ(native[index].clear_frame, baseline[index].clear_frame);
                EXPECT_EQ(native[index].text, baseline[index].text);
            }
            ++chapters;
        }
    }
    EXPECT_EQ(documents, expected);
    EXPECT_GT(chapters, 0);
    std::printf("Compared %zu native subtitle chapters across %zu documents.\n", chapters, documents);
}
