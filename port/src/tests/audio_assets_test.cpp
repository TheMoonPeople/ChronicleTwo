#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <vector>

#include "audio/sound_runtime.hpp"
#include "audio_assets.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "platform/datapacks.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "sound.hpp"
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

TEST_F(AudioAssetsTest, SoundConfigRejectsOversizedTableBeforeChangingBankOrArena) {
    alignas(u_long128) u_long128 storage[32]{};
    mgCMemory                    memory;
    memory.stSetBuffer(storage, 32);
    sndPortInfo info;
    info.bank_num = 1;
    auto                &bank = info.bank[0];
    const nlohmann::json huge = {
        {"schema_version", 1                      },
        {"kind",           "sound_config"         },
        {"entry_count",    1048576                },
        {"entries",        nlohmann::json::array()},
        {"reverb",         nlohmann::json::array()}
    };
    auto text = huge.dump();
    info.LoadSeInfoTxt(0, text, &memory);
    EXPECT_EQ(bank.se, nullptr);
    EXPECT_EQ(bank.se_num, 0);
    EXPECT_EQ(memory.stGetUsed(), 0);
}

TEST_F(AudioAssetsTest, PoisonedSceneAudioStartsWithNoLoadedBanksOrRequests) {
    /**
     * Holds poisoned scene storage with the scene's required alignment.
     */
    struct alignas(CScene) SceneStorage {
        std::array<std::byte, sizeof(CScene)> bytes; /**< Uninitialized scene representation. */
    };

    auto bytes = std::make_unique<SceneStorage>();
    bytes->bytes.fill(std::byte{0xA5});
    const auto                                 destroy = [](CScene *scene) { std::destroy_at(scene); };
    std::unique_ptr<CScene, decltype(destroy)> owner(std::construct_at(reinterpret_cast<CScene *>(bytes->bytes.data())), destroy);
    auto                                      *scene = owner.get();
    ASSERT_EQ(scene->bgm_no, 0);
    EXPECT_EQ(scene->GetActiveBgmInfo(), &scene->bgm[0]);
    for (const auto &music : scene->bgm) {
        EXPECT_EQ(music.snd_id, -1);
        EXPECT_EQ(music.load_no, -1);
        EXPECT_EQ(music.play_no, -1);
        EXPECT_FLOAT_EQ(music.master_volf, 1.0f);
        EXPECT_FLOAT_EQ(music.fade_volf, 1.0f);
    }
    EXPECT_EQ(scene->env_bgm_no, -1);
    EXPECT_EQ(scene->se_env_id, -1);
    EXPECT_EQ(scene->se_base_id, -1);
    EXPECT_EQ(scene->se_battle_id, -1);
    EXPECT_EQ(scene->snd_file_num, 0);
    EXPECT_EQ(scene->snd_rev_num, 0);
    for (const auto id : scene->se_src_id) {
        EXPECT_EQ(id, std::numeric_limits<u32>::max());
    }
    for (const auto &request : scene->se_src_play) {
        EXPECT_EQ(request.se_no, -1);
        EXPECT_EQ(request.num, 0);
    }
}

TEST_F(AudioAssetsTest, SoundConfigRejectsNonIntegralAndWideFieldsBeforeAllocation) {
    alignas(u_long128) u_long128 storage[32]{};
    mgCMemory                    memory;
    memory.stSetBuffer(storage, 32);
    sndPortInfo info;
    info.bank_num = 1;
    for (const auto &bad : {nlohmann::json(1.0e100), nlohmann::json(std::numeric_limits<std::uint64_t>::max()), nlohmann::json(128)}) {
        nlohmann::json config{
            {"schema_version", 1                                                                                               },
            {"kind",           "sound_config"                                                                                  },
            {"entry_count",    1                                                                                               },
            {"entries",        nlohmann::json::array({{{"filename", "KeyOn"}, {"program", bad}, {"key", 60}, {"flag", false}}})},
            {"reverb",         nlohmann::json::array()                                                                         }
        };
        auto text = config.dump();
        info.LoadSeInfoTxt(0, text, &memory);
        EXPECT_EQ(info.bank[0].se, nullptr);
        EXPECT_EQ(info.bank[0].se_num, 0);
        EXPECT_EQ(memory.stGetUsed(), 0);
    }
}

TEST_F(AudioAssetsTest, FailedBundleAllocationDoesNotPublishABankForTheNextLoad) {
    Document("sound/config.json", {
                                      {"schema_version", 1                      },
                                      {"kind",           "sound_config"         },
                                      {"entry_count",    0                      },
                                      {"entries",        nlohmann::json::array()},
                                      {"reverb",         nlohmann::json::array()}
    },
             0);
    Document("sound/volume.json", {
                                      {"schema_version", 1                      },
                                      {"kind",           "sound_volume"         },
                                      {"entries",        nlohmann::json::array()},
                                      {"reverb",         nlohmann::json::array()}
    },
             1);
    Document("sound/effect.json", {
                                      {"schema_version", 1                      },
                                      {"kind",           "effect_sequence"      },
                                      {"tick_rate",      1800                   },
                                      {"events",         nlohmann::json::array()}
    },
             2);
    const nlohmann::json bundle{
        {"schema_version",   1                      },
        {"kind",             "sound_bundle"         },
        {"bank",             nullptr                },
        {"sequences",        nlohmann::json::array()},
        {"effect_sequences", {"sound/effect.json"}  },
        {"config",           "sound/config.json"    },
        {"volume",           "sound/volume.json"    }
    };
    const auto  text = bundle.dump();
    const auto  bytes = std::as_bytes(std::span(text));
    static char identity;
    const auto  array_quadwords = dc2::memory::ArrayQuadwords<sndCSeSeqData>(1);
    ASSERT_TRUE(array_quadwords);
    const auto count = *array_quadwords + 1;
    mgCMemory  short_memory;
    short_memory.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&identity, static_cast<std::size_t>(count) * sizeof(u_long128))), count);
    sndInitMngr();
    EXPECT_EQ(SoundLoadBundleData(SND_PORT_SYSTEM, bytes, &short_memory), static_cast<unsigned>(-1));
    EXPECT_EQ(short_memory.stGetUsed(), 0);
    alignas(u_long128) u_long128 roomy_storage[1024]{};
    mgCMemory                    roomy_memory;
    roomy_memory.stSetBuffer(roomy_storage, 1024);
    const auto id = SoundLoadBundleData(SND_PORT_SYSTEM, bytes, &roomy_memory);
    ASSERT_NE(id, static_cast<unsigned>(-1));
    EXPECT_EQ((id >> 16) & 255U, 0U);
    sndInitPort(SND_PORT_SYSTEM);
    CSnd.Exit();
}

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
    auto &bank = info.bank[0];
    bank.seseq = dc2::memory::NewArray<sndCSeSeqData>(memory, 1);
    ASSERT_NE(bank.seseq, nullptr);
    bank.seseq_num = 1;
    bank.seseq_storage = dc2::memory::ArenaBuffer::Bind(memory,
                                                        {reinterpret_cast<u8 *>(bank.seseq), sizeof(sndCSeSeqData)});
    auto &sequence = bank.seseq[0];
    sequence.name = dc2::memory::ArenaText::Copy(bank.seseq_storage, "snd2/test.sound/effects/loop.json");
    sequence.LoadSMF(documents[2], &memory);
    ASSERT_EQ(sequence.event_num, 3);
    EXPECT_EQ(sequence.tick_rate, 1800);
    const auto events = dc2::audio::SequenceEvents(sequence);
    ASSERT_EQ(events.size(), 3u);
    EXPECT_EQ(events[1].delta, 480);
    EXPECT_EQ(events[2].status, 0);
    info.LoadSeInfoTxt(0, documents[0], &memory);
    ASSERT_EQ(bank.se_num, 3);
    EXPECT_EQ(bank.se[0].type, SND_SE_TYPE_KEYON);
    EXPECT_EQ(bank.se[0].prog, 4);
    EXPECT_EQ(bank.se[0].key, 60);
    EXPECT_EQ(bank.se[0].unk_7, 1);
    EXPECT_EQ(bank.se[1].type, SND_SE_TYPE_SESEQ);
    EXPECT_EQ(bank.se[1].prog, 0);
    EXPECT_EQ(bank.se[1].def_vol, 64);
    info.LoadVolInfoTxt(0, documents[1]);
    EXPECT_EQ(bank.se[1].def_vol, 91);
    const auto *next = memory.Alloc(1);
    ASSERT_NE(next, nullptr);
    EXPECT_GE(reinterpret_cast<std::uintptr_t>(next),
              reinterpret_cast<std::uintptr_t>(bank.se + bank.se_num));
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
    Document("gameplay/snd2/test.sound/config.json", config, 0);
    Document("gameplay/snd2/test.sound/volume.json", volume, 1);
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
    const fs::path fixtures = fs::absolute(fs::path(__FILE__)).parent_path().lexically_normal() / "fixtures";
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
