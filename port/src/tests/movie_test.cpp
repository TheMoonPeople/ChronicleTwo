#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <functional>
#include <iterator>
#include <memory>
#include <optional>
#include <span>
#include <vector>

#include "audio/mixer.hpp"
#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "movie.hpp"
#include "movie_port.hpp"
#include "platform/clock.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "video/player.hpp"

namespace fs = std::filesystem;

namespace {

using Bytes = std::vector<uint8_t>;

// ctest runs from the build directory, so search upward from the test executable for port_data/movie/.
std::optional<fs::path> MovieFile(const char *name) {
    fs::path relative = name;
    relative.replace_extension(".mp4");
    if (const char *root = std::getenv("KZ_MOVIE_OUTPUT")) {
        const auto path = fs::path(root) / "port_data/movie" / relative;
        if (fs::is_regular_file(path)) {
            return path;
        }
    }
    fs::path dir = PathsExecutable().parent_path();
    for (int up = 0; up < 6 && !dir.empty(); up++, dir = dir.parent_path()) {
        std::error_code error;
        fs::path        path = dir / "port_data" / "movie" / relative;
        if (fs::is_regular_file(path, error)) {
            return path;
        }
    }
    return std::nullopt;
}

} // namespace

namespace {

double MeanRgb(const std::vector<uint8_t> &rgba) {
    double sum = 0;
    size_t count = 0;
    for (size_t i = 0; i < rgba.size(); i++) {
        if (i % 4 != 3) {
            sum += rgba[i];
            count++;
        }
    }
    return count == 0 ? 0.0 : sum / static_cast<double>(count);
}

} // namespace

TEST(MoviePlayer, MissingFileDoesNotOpen) {
    video::MoviePlayer player;
    EXPECT_FALSE(player.Open("no/such/file.mp4", true));
    EXPECT_FALSE(player.IsOpen());
    EXPECT_FALSE(player.HasPicture());
}

TEST(MoviePlayer, GarbageFileDoesNotOpen) {
    const fs::path path = fs::temp_directory_path() / "dc2_movie_player_GarbageFileDoesNotOpen.mp4";
    {
        std::ofstream out(path, std::ios::binary);
        const Bytes   garbage(64 * 1024, 0xAB);
        out.write(reinterpret_cast<const char *>(garbage.data()), static_cast<std::streamsize>(garbage.size()));
    }

    video::MoviePlayer player;
    EXPECT_FALSE(player.Open(path, true));
    EXPECT_FALSE(player.IsOpen());

    std::error_code error;
    fs::remove(path, error);
}

TEST(MoviePlayer, L5LogoPlaysEveryPictureAtTwentyFiveFramesASecond) {
    const std::optional<fs::path> path = MovieFile("l5logo.mp4");
    if (!path) {
        GTEST_SKIP() << "no extracted port_data/movie/l5logo.mp4 within 6 levels above the test executable";
    }

    video::MoviePlayer player;
    ASSERT_TRUE(player.Open(*path, true));
    EXPECT_EQ(player.Width(), 512);
    EXPECT_EQ(player.Height(), 416);
    EXPECT_TRUE(player.HasPicture());
    EXPECT_EQ(player.PicturesShown(), 1);
    ASSERT_NE(player.Audio(), nullptr);
    EXPECT_EQ(player.Audio()->rate, 48000);
    EXPECT_EQ(player.Audio()->Frames(), 288512);
    EXPECT_FALSE(player.Audio()->loop);

    constexpr int64_t k_tick = 1800;
    constexpr int64_t k_clock = 90000;
    constexpr int64_t k_three_seconds = 3 * k_clock;
    constexpr int64_t k_limit = 20 * k_clock;

    int64_t elapsed = 0;
    int64_t changes = 0;
    bool    previous_changed = false;
    bool    consecutive_changes = false;
    bool    sampled = false;
    double  mean_at_three_seconds = 0.0;

    while (!player.Ended() && elapsed < k_limit) {
        elapsed += k_tick;
        const bool changed = player.Advance(elapsed);
        if (changed) {
            changes++;
        }
        consecutive_changes = consecutive_changes || (changed && previous_changed);
        previous_changed = changed;
        if (!sampled && elapsed >= k_three_seconds) {
            mean_at_three_seconds = MeanRgb(player.Rgba());
            sampled = true;
        }
    }

    EXPECT_TRUE(player.Ended());
    EXPECT_EQ(changes, player.PicturesShown() - 1);
    EXPECT_GT(player.PicturesShown(), 140);
    EXPECT_FALSE(consecutive_changes);
    EXPECT_TRUE(sampled);
    EXPECT_EQ(player.Rgba().size(), static_cast<size_t>(512 * 416 * 4));
    EXPECT_GT(mean_at_three_seconds, 0.0);

    std::printf("L5 logo: %lld pictures shown, ended at %.2f s, mean RGB at 3 s %.2f\n",
                static_cast<long long>(player.PicturesShown()), static_cast<double>(elapsed) / k_clock,
                mean_at_three_seconds);
}

TEST(MoviePlayer, CatchUpSkipsIntermediatePictures) {
    const std::optional<fs::path> path = MovieFile("l5logo.mp4");
    if (!path) {
        GTEST_SKIP() << "no extracted port_data/movie/l5logo.mp4 within 6 levels above the test executable";
    }

    video::MoviePlayer player;
    ASSERT_TRUE(player.Open(*path, false));
    EXPECT_TRUE(player.Advance(90000 * 3));
    EXPECT_EQ(player.PicturesShown(), 2);
}

namespace {

struct RestoreDataRoot {
    fs::path root;
    fs::path packs = datapacks::Root();

    ~RestoreDataRoot() {
        PathsSetDataRoot(root);
        if (packs.empty()) {
            datapacks::Clear();
        } else {
            datapacks::Load(packs);
        }
    }
};

struct RestoreClock {
    double rate;
    bool   unbounded;

    ~RestoreClock() {
        ClockSetTickRate(rate);
        ClockSetUnbounded(unbounded);
    }
};

} // namespace

TEST(MovieGlue, PathMapsGameNamesToPublishedMp4) {
    const fs::path movie = "movie";
    EXPECT_EQ(MoviePortPath("L5LOGO.MP4"), movie / "l5logo.mp4");
    EXPECT_EQ(MoviePortPath("TUTO2\\VTUTO1.MP4"), movie / "tuto2" / "vtuto1.mp4");
    EXPECT_EQ(MoviePortPath("cdrom0:\\RUSH.MP4;1"), movie / "rush.mp4");
    EXPECT_EQ(MoviePortPath("/TUTO/X.MP4"), movie / "tuto" / "x.mp4");
}

TEST(MoviePlayer, StandardMp4ContainsVideoAndEmbeddedLosslessAudio) {
    video::MoviePlayer player;
    const fs::path     fixture = fs::path(__FILE__).parent_path() / "fixtures/movie.mp4";
    ASSERT_TRUE(player.Open(fixture, true));
    EXPECT_EQ(player.Width(), 16);
    EXPECT_EQ(player.Height(), 16);
    ASSERT_NE(player.Audio(), nullptr);
    EXPECT_EQ(player.Audio()->rate, 48000);
    EXPECT_EQ(player.Audio()->Frames(), 5760);
    EXPECT_FALSE(player.Audio()->loop);
    const auto first = player.Rgba();
    EXPECT_TRUE(player.Advance(3600));
    EXPECT_EQ(player.PicturesShown(), 2);
    EXPECT_TRUE(player.Advance(7200));
    EXPECT_EQ(player.PicturesShown(), 3);
    EXPECT_FALSE(player.Ended());
    player.Advance(10800);
    EXPECT_TRUE(player.Ended());
    player.Close();
    EXPECT_FALSE(player.IsOpen());
    ASSERT_TRUE(player.Open(fixture, false));
    EXPECT_EQ(player.Audio(), nullptr);
}

TEST(MovieGlue, MissingMovieStartsAndEndsAtOnce) {
    auto movie = std::make_unique<CMovie>();
    char name[] = "NOSUCH.MP4";
    char texture[] = "moviework";
    movie->Load(name, static_cast<mgCMemory **>(nullptr), 0x200, 0x1A0, true, false, false);
    movie->Play(texture);
    EXPECT_EQ(movie->IsStarted(), 1);
    EXPECT_EQ(movie->EndCheck(), 1);
    movie->Term();
    EXPECT_FALSE(movie->is_playing);
    EXPECT_EQ(movie->EndCheck(), 1);
}

TEST(MovieGlue, L5LogoPlaysOnTheClockWithItsSoundtrack) {
    RestoreDataRoot restore_data{PathsDataRoot()};
    if (!fs::is_regular_file(datapacks::Root() / MoviePortPath("L5LOGO.MP4"))) {
        const std::optional<fs::path> found = MovieFile("l5logo.mp4");
        if (!found) {
            GTEST_SKIP() << "no extracted port_data/movie/l5logo.mp4 within 6 levels above the test executable";
        }
        PathsSetDataRoot(found->parent_path().parent_path().parent_path() / "data");
        datapacks::Load(found->parent_path().parent_path());
    }

    // Two ticks a game frame at 50 Hz is 25 game frames a second, the movie's rate.
    RestoreClock restore_clock{ClockTickRate(), ClockUnbounded()};
    ClockSetUnbounded(true);
    ClockSetTickRate(50.0);
    ClockReset();

    auto movie = std::make_unique<CMovie>();
    char name[] = "L5LOGO.MP4";
    char texture[] = "moviework";
    movie->Load(name, static_cast<mgCMemory **>(nullptr), 512, 416, true, false, true);
    movie->Play(texture);
    EXPECT_EQ(movie->IsStarted(), 1);
    EXPECT_TRUE(audio::DefaultMixer().IsPlaying(kMoviePortAudioPort));

    int frames = 0;
    while (frames < 1000) {
        movie->SwitchThread();
        if (movie->EndCheck() != 0) {
            break;
        }
        ClockPump();
        ClockPump();
        frames++;
    }
    EXPECT_GE(frames, 145);
    EXPECT_LE(frames, 155);
    EXPECT_LT(frames, 1000);

    movie->Term();
    EXPECT_FALSE(audio::DefaultMixer().IsPlaying(kMoviePortAudioPort));
    EXPECT_FALSE(movie->is_playing);
    std::printf("L5 logo through MovieGlue: %d game frames\n", frames);
}

namespace {

class OffscreenRenderer {
public:
    OffscreenRenderer() {
        dc::test::SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{640, 480, true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 4.0f / 3.0f;
        config.validation = true;
        config.offscreen = true;
        config.pipeline_cache = fs::temp_directory_path() / "dc_gfx_test" /
                                ("movie_glue_" + std::to_string(dc::test::ProcessId()) + ".bin");
        gfx::RendererInit(WindowHandle(), config);
        mgInit(MG_SCREEN_MODE_512X480, 3);
    }

    ~OffscreenRenderer() {
        gfx::RendererShutdown();
        WindowShutdown();
        EXPECT_EQ(gfx::ValidationMessageCount(), 0u);
    }
};

constexpr int    kTextureTableCount = 0x140;
constexpr int    kTextureTableBlocks = 0xAF;
constexpr size_t kTextureTableQuads = size_t{1} << 16;

// Static: the global manager keeps pointers into this storage, and MovieUpload reads them on any later movie.
std::vector<u_long128> g_texture_table_storage(kTextureTableQuads);
mgCMemory              g_texture_table_memory;

class GlobalTextureTable {
public:
    GlobalTextureTable() {
        g_texture_table_memory.stSetBuffer(g_texture_table_storage.data(), static_cast<int>(kTextureTableQuads));
        mgTexManager.SetTableBuffer(kTextureTableCount, kTextureTableBlocks, &g_texture_table_memory);
        mgTexManager.Initialize(0x1000, -1);
    }

    ~GlobalTextureTable() { mgTexManager.Initialize(0x1000, -1); }
};

struct MovieTermOnExit {
    CMovie *movie;

    ~MovieTermOnExit() { movie->Term(); }
};

} // namespace

TEST(MovieGlue, ThirtyFramesOfL5LogoThroughTheMovieTexture) {
    RestoreDataRoot restore_data{PathsDataRoot()};
    if (!fs::is_regular_file(datapacks::Root() / MoviePortPath("L5LOGO.MP4"))) {
        const std::optional<fs::path> found = MovieFile("l5logo.mp4");
        if (!found) {
            GTEST_SKIP() << "no extracted port_data/movie/l5logo.mp4 within 6 levels above the test executable";
        }
        PathsSetDataRoot(found->parent_path().parent_path().parent_path() / "data");
        datapacks::Load(found->parent_path().parent_path());
    }
    const fs::path movie_file = datapacks::Root() / MoviePortPath("L5LOGO.MP4");

    RestoreClock       restore_clock{ClockTickRate(), ClockUnbounded()};
    OffscreenRenderer  renderer;
    GlobalTextureTable texture_table;

    ClockSetUnbounded(true);
    ClockSetTickRate(50.0);
    ClockReset();

    char texture_name[] = "moviework";
    mgTexManager.DeleteBlock(0x43);
    ASSERT_NE(mgTexManager.EnterTexture(0x43, texture_name, nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth,
                                        nullptr, 0, 0),
              nullptr);

    auto            movie = std::make_unique<CMovie>();
    MovieTermOnExit term_on_exit{movie.get()};
    char            name[] = "L5LOGO.MP4";
    movie->Load(name, static_cast<mgCMemory **>(nullptr), 512, 416, true, false, true);
    movie->Play(texture_name);
    const int64_t start_tick = ClockTickCount();
    EXPECT_EQ(movie->IsStarted(), 1);

    constexpr int        k_frames = 30;
    const gfx::DrawState state = mgPortDrawState();
    int64_t              picture_elapsed = 0;
    for (int frame = 0; frame < k_frames; frame++) {
        mgBeginFrame(nullptr);
        // SwitchThread samples the clock itself, so the picture it uploads is the one at this tick.
        const int64_t switch_tick = ClockTickCount();
        movie->SwitchThread();
        picture_elapsed = std::llround(static_cast<double>(switch_tick - start_tick) * 90000.0 / ClockTickRate());

        mgCTexture *texture = mgTexManager.GetTexture(texture_name, -1);
        ASSERT_NE(texture, nullptr);
        gfx::TextureBinding binding = mgPortBinding(texture);
        ASSERT_NE(binding.texture, gfx::kNullTexture);
        binding.filter = gfx::Filter::Nearest;
        const auto quad = dc::test::Quad(0.0f, 0.0f, 512.0f, 416.0f, {0x80, 0x80, 0x80, 0x80}, 0.0f, 0.0f, 512.0f,
                                         416.0f);
        mgPortDraw2D(gfx::Primitive::Quads, quad, binding, state);
        mgEndFrame(nullptr);
        ClockPump();
        ClockPump();
    }
    EXPECT_EQ(mgPortFrameCount(), k_frames);
    EXPECT_TRUE(movie->is_playing);

    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortReadColor(gfx::kMainTarget, rgba, width, height));
    EXPECT_TRUE(std::adjacent_find(rgba.begin(), rgba.end(), std::not_equal_to<>()) != rgba.end());

    const fs::path png = fs::temp_directory_path() / "movie_l5logo_30.png";
    ASSERT_TRUE(gfx::WritePng(png, rgba.data(), width, height));
    std::printf("frame %d written to %s\n", k_frames, png.string().c_str());

    // The logical frame sits letterboxed inside the window, so the picture's rect comes from the mapping, not from
    // scaling 512x480 to the readback size.
    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    EXPECT_EQ(mapping.pixel_width, width);
    EXPECT_EQ(mapping.pixel_height, height);
    const uint32_t x0 = static_cast<uint32_t>(std::floor(mapping.offset_x));
    const uint32_t y0 = static_cast<uint32_t>(std::floor(mapping.offset_y));
    const uint32_t x1 = std::min(width, static_cast<uint32_t>(std::ceil(mapping.offset_x + 512.0f * mapping.scale_x)));
    const uint32_t y1 = std::min(height, static_cast<uint32_t>(std::ceil(mapping.offset_y + 416.0f * mapping.scale_y)));
    double         readback_sum = 0.0;
    size_t         readback_count = 0;
    for (uint32_t y = y0; y < y1; y++) {
        for (uint32_t x = x0; x < x1; x++) {
            const uint8_t *px = &rgba[(static_cast<size_t>(y) * width + x) * 4];
            readback_sum += px[0] + px[1] + px[2];
            readback_count += 3;
        }
    }
    ASSERT_GT(readback_count, 0u);
    const double readback_mean = readback_sum / static_cast<double>(readback_count);

    movie->Term();
    EXPECT_FALSE(audio::DefaultMixer().IsPlaying(kMoviePortAudioPort));
    EXPECT_FALSE(movie->is_playing);

    video::MoviePlayer picture;
    ASSERT_TRUE(picture.Open(movie_file, false));
    picture.Advance(picture_elapsed);
    ASSERT_EQ(picture.Rgba().size(), static_cast<size_t>(512 * 416 * 4));
    const double picture_mean = MeanRgb(picture.Rgba());

    std::printf("L5 logo frame %d: readback mean RGB %.2f, picture mean RGB %.2f at %lld ticks\n", k_frames,
                readback_mean, picture_mean, static_cast<long long>(picture_elapsed));
    EXPECT_NEAR(readback_mean, picture_mean, 3.0);
}
