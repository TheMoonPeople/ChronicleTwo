#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <filesystem>
#include <fstream>
#include <vector>

#include "audio_assets.hpp"
#include "mg_memory.hpp"
#include "platform/datapacks.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "sound.hpp"
#include "sound_port.hpp"
#include "tests/audio_bank_fixture.hpp"
#include "video/player.hpp"

namespace {
namespace fs = std::filesystem;

class AudioAssetsTest : public ::testing::Test {
protected:
    fs::path                 root = fs::temp_directory_path() / ("dc2_audio_assets_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    fs::path                 previous = datapacks::Root();
    std::vector<std::string> documents = std::vector<std::string>(8);

    void SetUp() override { fs::create_directories(root / "data/sound"); }

    void TearDown() override {
        if (previous.empty()) {
            datapacks::Clear();
        } else {
            datapacks::Load(previous);
        }
        std::error_code error;
        fs::remove_all(root, error);
    }

    void Document(const char *relative, const nlohmann::json &document, int token) {
        fs::create_directories((root / "data" / relative).parent_path());
        documents[token] = document.dump();
        std::ofstream(root / "data" / relative) << documents[token];
        datapacks::Load(root / "data");
    }

    void EnablePack(const std::string &name) {
        fs::create_directories(root / "datapacks" / name);
        std::ofstream(root / "datapacks/datapacks.json") << nlohmann::json({
                                                                               {"schema_version", 1                            },
                                                                               {"load_order",     nlohmann::json::array({name})}
        })
                                                                .dump();
        datapacks::Load(root / "data");
    }
};

TEST_F(AudioAssetsTest, SoundMappingsVolumesAndEffectEventsLoadFromBoundedJson) {
    Document("snd2/test.sound/config.json",
             {
                 {"schema_version", 1                                                                                                                                                                                               },
                 {"kind",           "sound_config"                                                                                                                                                                                  },
                 {"entry_count",    3                                                                                                                                                                                               },
                 {"entries",        nlohmann::json::array({{{"filename", "KeyOn"}, {"program", 4}, {"key", 60}, {"flag", true}}, {{"filename", "snd2/test.sound/effects/loop.json"}, {"program", 9}, {"key", 61}, {"flag", false}}})},
                 {"reverb",         nlohmann::json::array()                                                                                                                                                                         }
    },
             0);
    Document("snd2/test.sound/volume.json",
             {
                 {"schema_version", 1                                                      },
                 {"kind",           "sound_volume"                                         },
                 {"entries",        nlohmann::json::array({{{"index", 1}, {"volume", 91}}})},
                 {"reverb",         nlohmann::json::array()                                }
    },
             1);
    Document("snd2/test.sound/effects/loop.json",
             {
                 {"schema_version", 1                                                                                                                                                                                },
                 {"kind",           "effect_sequence"                                                                                                                                                                },
                 {"tick_rate",      1800                                                                                                                                                                             },
                 {"events",         nlohmann::json::array({{{"delta", 0}, {"status", 144}, {"data", nlohmann::json::array({60, 100})}}, {{"delta", 480}, {"status", 128}, {"data", nlohmann::json::array({60, 0})}}})}
    },
             2);
    alignas(16) u_long128 storage[512];
    mgCMemory             memory;
    memory.SetHeapMem(storage, 512);
    memory.StartStackMode(MG_STACK_MODE_FIT, 400);
    sndPortInfo info;
    info.port = 12;
    info.bank_num = 1;
    auto         &bank = info.bank[0];
    sndCSeSeqData sequence;
    sequence.name = const_cast<char *>("snd2/test.sound/effects/loop.json");
    bank.seseq = &sequence;
    bank.seseq_num = 1;
    sequence.LoadSMF(documents[2].data(), static_cast<int>(documents[2].size()), &memory);
    ASSERT_EQ(sequence.event_num, 3);
    EXPECT_EQ(sequence.tick_rate, 1800);
    EXPECT_EQ(sequence.event[1].delta, 480);
    EXPECT_EQ(sequence.event[2].status, 0);
    info.LoadSeInfoTxt(0, documents[0].data(), static_cast<int>(documents[0].size()), &memory);
    ASSERT_EQ(bank.se_num, 3);
    EXPECT_EQ(bank.se[0].type, SND_SE_TYPE_KEYON);
    EXPECT_EQ(bank.se[0].prog, 4);
    EXPECT_EQ(bank.se[0].key, 60);
    EXPECT_EQ(bank.se[0].unk_7, 1);
    EXPECT_EQ(bank.se[1].type, SND_SE_TYPE_SESEQ);
    EXPECT_EQ(bank.se[1].prog, 0);
    EXPECT_EQ(bank.se[1].def_vol, 64);
    info.LoadVolInfoTxt(0, documents[1].data(), static_cast<int>(documents[1].size()));
    EXPECT_EQ(bank.se[1].def_vol, 91);
}

TEST_F(AudioAssetsTest, DirectBundleLoadsExplicitDependenciesAndInvalidOverlayFallsBack) {
    const nlohmann::json config = {
        {"schema_version", 1                                                                                             },
        {"kind",           "sound_config"                                                                                },
        {"entry_count",    1                                                                                             },
        {"entries",        nlohmann::json::array({{{"filename", "KeyOn"}, {"program", 4}, {"key", 60}, {"flag", false}}})},
        {"reverb",         nlohmann::json::array()                                                                       }
    };
    const nlohmann::json volume = {
        {"schema_version", 1                                                      },
        {"kind",           "sound_volume"                                         },
        {"entries",        nlohmann::json::array({{{"index", 0}, {"volume", 91}}})},
        {"reverb",         nlohmann::json::array()                                }
    };
    Document("snd2/test.sound/config.json", config, 0);
    Document("snd2/test.sound/volume.json", volume, 1);
    const nlohmann::json bundle = {
        {"schema_version",   1                            },
        {"kind",             "sound_bundle"               },
        {"bank",             nullptr                      },
        {"sequences",        nlohmann::json::array()      },
        {"effect_sequences", nlohmann::json::array()      },
        {"config",           "snd2/test.sound/config.json"},
        {"volume",           "snd2/test.sound/volume.json"}
    };
    Document("snd2/test.sound.json", bundle, 2);
    EnablePack("custom");
    fs::create_directories(root / "datapacks/custom/snd2/test.sound");
    std::ofstream(root / "datapacks/custom/snd2/test.sound.json") << "malformed bundle";
    std::ofstream(root / "datapacks/custom/snd2/test.sound/config.json") << nlohmann::json({
                                                                                               {"schema_version", 1             },
                                                                                               {"kind",           "sound_config"}
    })
                                                                                .dump();
    alignas(16) u_long128 storage[1024];
    mgCMemory             memory;
    memory.SetHeapMem(storage, 1024);
    memory.StartStackMode(MG_STACK_MODE_FIT, 900);
    sndInitMngr();
    const auto id = SoundLoadBundlePath(SND_PORT_SYSTEM, "snd2/test.sound.json", &memory);
    ASSERT_NE(id, static_cast<unsigned>(-1));
    EXPECT_EQ(sndGetSeDefVol(id, 0), 91);
    sndInitPort(SND_PORT_SYSTEM);
    CSnd.Exit();
}

TEST_F(AudioAssetsTest, WaveOverrideWinsAndMalformedReplacementFallsBack) {
    const auto base = dc::test::SampleFile(48000);
    fs::copy_file(base, root / "data/sound/test.wav");
    const auto replacement = root / "datapacks/custom/sound/test.wav";
    fs::create_directories(replacement.parent_path());
    fs::copy_file(base, replacement);
    {
        std::fstream out(replacement, std::ios::binary | std::ios::in | std::ios::out);
        out.seekp(44);
        out.put(0x34);
        out.put(0x12);
    }
    EnablePack("custom");
    std::string error;
    auto        track = LoadAudioTrack("sound/test.wav", error);
    ASSERT_NE(track, nullptr);
    EXPECT_EQ(track->samples[0], 0x1234);
    EXPECT_EQ(track->source_channels, 1);
    std::ofstream(replacement, std::ios::binary) << "invalid WAV";
    track = LoadAudioTrack("sound/test.wav", error);
    ASSERT_NE(track, nullptr);
    EXPECT_EQ(track->samples[0], 28672);
}

TEST_F(AudioAssetsTest, SelfContainedH264AacMp4OverrideAndInvalidFallback) {
    const fs::path fixtures = fs::path(__FILE__).parent_path() / "fixtures";
    const auto     base = root / "data/movie/test.mp4";
    fs::create_directories(base.parent_path());
    fs::copy_file(fixtures / "movie.mp4", base);
    const auto replacement = root / "datapacks/custom/movie/test.mp4";
    fs::create_directories(replacement.parent_path());
    fs::copy_file(fixtures / "movie_h264_aac.mp4", replacement);
    EnablePack("custom");
    video::MoviePlayer reference;
    video::MoviePlayer player;
    ASSERT_TRUE(reference.Open(fixtures / "movie_h264_aac.mp4", true));
    ASSERT_TRUE(player.Open("movie/test.mp4", true));
    ASSERT_NE(player.Audio(), nullptr);
    EXPECT_EQ(player.Rgba(), reference.Rgba());
    EXPECT_EQ(player.Audio()->samples, reference.Audio()->samples);
    std::ofstream(replacement, std::ios::binary) << "invalid MP4";
    ASSERT_TRUE(reference.Open(fixtures / "movie.mp4", true));
    ASSERT_TRUE(player.Open("movie/test.mp4", true));
    EXPECT_EQ(player.Rgba(), reference.Rgba());
    EXPECT_EQ(player.Audio()->Frames(), 5760);
}
} // namespace
