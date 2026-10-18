#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <functional>
#include <initializer_list>
#include <iterator>
#include <memory>
#include <optional>
#include <print>
#include <span>
#include <string>
#include <vector>

#include "audio/mixer.hpp"
#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
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

// ctest runs from the build directory, so search upward from the test executable for data/movie/.
std::optional<fs::path> MovieFile(const char *name) {
    fs::path relative = name;
    relative.replace_extension(".mp4");
    if (const char *root = std::getenv("KZ_MOVIE_OUTPUT")) {
        const auto path = fs::path(root) / "data/movie" / relative;
        if (fs::is_regular_file(path)) {
            return path;
        }
    }
    fs::path dir = PathsExecutable().parent_path();
    for (int up = 0; up < 6 && !dir.empty(); up++, dir = dir.parent_path()) {
        std::error_code error;
        fs::path        path = dir / "data" / "movie" / relative;
        if (fs::is_regular_file(path, error)) {
            return path;
        }
    }
    return std::nullopt;
}

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
        GTEST_SKIP() << "no extracted data/movie/l5logo.mp4 within 6 levels above the test executable";
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

    std::println("L5 logo: {} pictures shown, ended at {:.2f} s, mean RGB at 3 s {:.2f}",
                 static_cast<long long>(player.PicturesShown()), static_cast<double>(elapsed) / k_clock,
                 mean_at_three_seconds);
}

TEST(MoviePlayer, CatchUpSkipsIntermediatePictures) {
    const std::optional<fs::path> path = MovieFile("l5logo.mp4");
    if (!path) {
        GTEST_SKIP() << "no extracted data/movie/l5logo.mp4 within 6 levels above the test executable";
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
    RestoreDataRoot restore_data{.root = PathsDataRoot()};
    if (!fs::is_regular_file(datapacks::Root() / MoviePortPath("L5LOGO.MP4"))) {
        const std::optional<fs::path> found = MovieFile("l5logo.mp4");
        if (!found) {
            GTEST_SKIP() << "no extracted data/movie/l5logo.mp4 within 6 levels above the test executable";
        }
        PathsSetDataRoot(found->parent_path().parent_path().parent_path() / "data");
        datapacks::Load(found->parent_path().parent_path());
    }

    // Two ticks a game frame at 50 Hz is 25 game frames a second, the movie's rate.
    RestoreClock restore_clock{.rate = ClockTickRate(), .unbounded = ClockUnbounded()};
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
    std::println("L5 logo through MovieGlue: {} game frames", frames);
}

namespace {

class OffscreenRenderer {
public:
    OffscreenRenderer() {
        dc::test::SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{.width = 640, .height = 480, .headless = true};
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

// Global storage: the manager keeps pointers into it, and MovieUpload reads them on any later movie.
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
    RestoreDataRoot restore_data{.root = PathsDataRoot()};
    if (!fs::is_regular_file(datapacks::Root() / MoviePortPath("L5LOGO.MP4"))) {
        const std::optional<fs::path> found = MovieFile("l5logo.mp4");
        if (!found) {
            GTEST_SKIP() << "no extracted data/movie/l5logo.mp4 within 6 levels above the test executable";
        }
        PathsSetDataRoot(found->parent_path().parent_path().parent_path() / "data");
        datapacks::Load(found->parent_path().parent_path());
    }
    const fs::path movie_file = datapacks::Root() / MoviePortPath("L5LOGO.MP4");

    RestoreClock       restore_clock{.rate = ClockTickRate(), .unbounded = ClockUnbounded()};
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
    EXPECT_TRUE(std::ranges::adjacent_find(rgba, std::not_equal_to<>()) != rgba.end());

    const fs::path png = fs::temp_directory_path() / "movie_l5logo_30.png";
    ASSERT_TRUE(gfx::WritePng(png, rgba.data(), width, height));
    std::println("frame {} written to {}", k_frames, png.string());

    // The logical frame sits letterboxed inside the window, so the picture's rect comes from the mapping, not from
    // scaling 512x480 to the readback size.
    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    EXPECT_EQ(mapping.pixel_width, width);
    EXPECT_EQ(mapping.pixel_height, height);
    const auto     x0 = static_cast<uint32_t>(std::floor(mapping.offset_x));
    const auto     y0 = static_cast<uint32_t>(std::floor(mapping.offset_y));
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

    std::println("L5 logo frame {}: readback mean RGB {:.2f}, picture mean RGB {:.2f} at {} ticks", k_frames,
                 readback_mean, picture_mean, static_cast<long long>(picture_elapsed));
    EXPECT_NEAR(readback_mean, picture_mean, 3.0);
}

TEST(MoviePlayer, FitKeepsRetailMultiplesAndResamplesOtherSizes) {
    const auto fit = [](int width, int height) {
        const video::PictureFit picture = video::FitPicture(512, 416, width, height);
        return std::array{picture.width, picture.height, picture.scale};
    };
    EXPECT_EQ(fit(512, 416), (std::array{512, 416, 1}));
    EXPECT_EQ(fit(1024, 832), (std::array{1024, 832, 2}));
    EXPECT_EQ(fit(2048, 1664), (std::array{2048, 1664, 4}));
    // Other sizes shrink to the largest multiple they cover, past 4x too; smaller ones grow to the retail size.
    EXPECT_EQ(fit(1920, 1560), (std::array{1024, 832, 2}));
    EXPECT_EQ(fit(768, 624), (std::array{512, 416, 1}));
    EXPECT_EQ(fit(4096, 3328), (std::array{2048, 1664, 4}));
    EXPECT_EQ(fit(1024, 416), (std::array{512, 416, 1}));
    EXPECT_EQ(fit(256, 208), (std::array{512, 416, 1}));
    const video::PictureFit unsized = video::FitPicture(0, 0, 640, 480);
    EXPECT_EQ((std::array{unsized.width, unsized.height, unsized.scale}), (std::array{640, 480, 1}));
}

TEST(MoviePlayer, RetailSizeResamplesEveryPictureAndKeepsTheSourceSize) {
    const fs::path     fixture = fs::path(__FILE__).parent_path() / "fixtures/movie.mp4";
    video::MoviePlayer plain;
    ASSERT_TRUE(plain.Open(fixture, false));
    EXPECT_EQ(plain.SourceWidth(), 16);
    EXPECT_EQ(plain.Scale(), 1);

    video::MoviePlayer kept;
    kept.SetRetailSize(16, 16);
    ASSERT_TRUE(kept.Open(fixture, false));
    EXPECT_EQ(kept.Rgba(), plain.Rgba());

    // 16x16 is twice 8x4 wide, but only four times as tall, so it shows at 2x: 16x8.
    video::MoviePlayer fitted;
    fitted.SetRetailSize(8, 4);
    ASSERT_TRUE(fitted.Open(fixture, false));
    for (int picture = 0; picture < 3; picture++) {
        EXPECT_EQ(fitted.Width(), 16);
        EXPECT_EQ(fitted.Height(), 8);
        EXPECT_EQ(fitted.Scale(), 2);
        EXPECT_EQ(fitted.SourceWidth(), 16);
        EXPECT_EQ(fitted.SourceHeight(), 16);
        EXPECT_EQ(fitted.Rgba().size(), static_cast<size_t>(16 * 8 * 4));
        fitted.Advance(int64_t{3600} * (picture + 1));
    }
    EXPECT_EQ(fitted.PicturesShown(), 3);
}

TEST(MoviePlayer, ResamplingShrinksOneSideWithAreaAveraging) {
    const fs::path     fixture = fs::path(__FILE__).parent_path() / "fixtures/movie.mp4";
    video::MoviePlayer plain;
    ASSERT_TRUE(plain.Open(fixture, false));
    video::MoviePlayer halved;
    halved.SetRetailSize(16, 8);
    ASSERT_TRUE(halved.Open(fixture, false));
    ASSERT_EQ(halved.Width(), 16);
    ASSERT_EQ(halved.Height(), 8);
    // Each row is the mean of the two it replaces, as area averaging gives; bicubic would ring at the bars' edges.
    const auto pixel = [](const video::MoviePlayer &player, int x, int y, int c) {
        return static_cast<int>(player.Rgba().at((static_cast<size_t>(y) * player.Width() + x) * 4 + c));
    };
    int worst = 0;
    for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 16; x++) {
            for (int c = 0; c < 3; c++) {
                const int mean = (pixel(plain, x, y * 2, c) + pixel(plain, x, (y * 2) + 1, c) + 1) / 2;
                worst = std::max(worst, std::abs(pixel(halved, x, y, c) - mean));
            }
        }
    }
    EXPECT_LE(worst, 2);
}

TEST(MoviePlayer, ThreadedDecodingShowsTheSamePicturesInOrder) {
    // 24 pictures with B-frames, more than the decoder thread cap; picture N's top-left pixel is grey 9.31 * N.
    const fs::path    fixture = fs::path(__FILE__).parent_path() / "fixtures/movie_h264_bframes.mp4";
    constexpr int64_t picture_ticks = 3600;
    constexpr int     picture_count = 24;
    // Every picture boundary, a jump over five pictures, the rest, then past the end to drain the decoder.
    std::vector<int> shown;
    for (int n = 1; n < picture_count; n++) {
        if (n < 10 || n > 14) {
            shown.push_back(n);
        }
    }
    // The stream is the retail size of one player and twice that of the other, which decodes on FFmpeg's threads;
    // the third is resampled from its threads to 120x72.
    video::MoviePlayer single;
    video::MoviePlayer threaded;
    video::MoviePlayer resampled;
    single.SetRetailSize(160, 96);
    threaded.SetRetailSize(80, 48);
    resampled.SetRetailSize(60, 36);
    // The second pass reopens the same players.
    for (int pass = 0; pass < 2; pass++) {
        ASSERT_TRUE(single.Open(fixture, false));
        ASSERT_TRUE(threaded.Open(fixture, false));
        ASSERT_TRUE(resampled.Open(fixture, false));
        const auto expect_picture = [&](int n) {
            ASSERT_EQ(threaded.Width(), 160);
            ASSERT_EQ(resampled.Width(), 120);
            EXPECT_EQ(single.Rgba(), threaded.Rgba()) << "picture " << n;
            EXPECT_NEAR(threaded.Rgba()[0], 9.31 * n, 4.0) << "picture " << n;
            EXPECT_NEAR(resampled.Rgba()[0], 9.31 * n, 4.0) << "picture " << n;
        };
        expect_picture(0);
        for (const int n : shown) {
            EXPECT_TRUE(single.Advance(n * picture_ticks));
            EXPECT_TRUE(threaded.Advance(n * picture_ticks));
            EXPECT_TRUE(resampled.Advance(n * picture_ticks));
            expect_picture(n);
        }
        EXPECT_FALSE(single.Advance(30 * picture_ticks));
        EXPECT_FALSE(threaded.Advance(30 * picture_ticks));
        EXPECT_FALSE(resampled.Advance(30 * picture_ticks));
        expect_picture(picture_count - 1);
        EXPECT_TRUE(single.Ended());
        EXPECT_TRUE(threaded.Ended());
        EXPECT_EQ(threaded.PicturesShown(), static_cast<int64_t>(shown.size()) + 1);
    }
}

namespace {

// A data root holding the 16x16 fixture as movie/hd.mp4, so a CMovie can load it by its game name.
struct FixtureMovieRoot {
    fs::path root = fs::temp_directory_path() / ("dc2_movie_hd_" + std::to_string(dc::test::ProcessId()));

    FixtureMovieRoot() {
        fs::create_directories(root / "movie");
        fs::copy_file(fs::path(__FILE__).parent_path() / "fixtures/movie.mp4", root / "movie/hd.mp4",
                      fs::copy_options::overwrite_existing);
        datapacks::Load(root);
    }

    FixtureMovieRoot(const FixtureMovieRoot &) = delete;
    FixtureMovieRoot &operator=(const FixtureMovieRoot &) = delete;

    ~FixtureMovieRoot() {
        std::error_code error;
        fs::remove_all(root, error);
    }
};

struct HdMovieResult {
    MgTextureExtent      physical;
    uint32_t             image_width = 0;
    uint32_t             image_height = 0;
    std::vector<uint8_t> drawn; // RGB on screen at each picture pixel's cell, row by row.
    std::vector<uint8_t> picture;
    int                  picture_width = 0;
    int                  picture_height = 0;
    std::string          log;
};

// Plays hd.mp4 once for each retail size, as a movie of that size, through one texture_size x texture_size
// "moviework", and draws the texture's retail texels over a 256x256 square, as the game draws the movie.
void PlayHdMovies(int texture_size, std::initializer_list<int> retails, std::vector<HdMovieResult> &results) {
    RestoreDataRoot    restore_data{.root = PathsDataRoot()};
    FixtureMovieRoot   movie_root;
    RestoreClock       restore_clock{.rate = ClockTickRate(), .unbounded = ClockUnbounded()};
    OffscreenRenderer  renderer;
    GlobalTextureTable texture_table;
    ClockSetUnbounded(true);
    ClockReset();

    char texture_name[] = "moviework";
    mgTexManager.DeleteBlock(0x43);
    ASSERT_NE(mgTexManager.EnterTexture(0x43, texture_name, nullptr, texture_size, texture_size, 32, nullptr, 0, 0),
              nullptr);
    mgCTexture *texture = mgTexManager.GetTexture(texture_name, -1);
    ASSERT_NE(texture, nullptr);
    ASSERT_NE(mgPortFindTexture(texture).texture, gfx::kNullTexture);

    for (const int retail : retails) {
        HdMovieResult  &result = results.emplace_back();
        auto            movie = std::make_unique<CMovie>();
        MovieTermOnExit term_on_exit{movie.get()};
        char            name[] = "HD.MP4";
        testing::internal::CaptureStderr();
        movie->Load(name, static_cast<mgCMemory **>(nullptr), retail, retail, false, false, true);
        movie->Play(texture_name);
        movie->SwitchThread();
        result.log = testing::internal::GetCapturedStderr();

        mgBeginFrame(nullptr);
        movie->SwitchThread();
        gfx::TextureBinding binding = mgPortBinding(texture);
        ASSERT_NE(binding.texture, gfx::kNullTexture);
        binding.filter = gfx::Filter::Nearest;
        const auto quad = dc::test::Quad(0.0f, 0.0f, 256.0f, 256.0f, {0x80, 0x80, 0x80, 0x80}, 0.0f, 0.0f,
                                         static_cast<float>(retail), static_cast<float>(retail));
        mgPortDraw2D(gfx::Primitive::Quads, quad, binding, mgPortDrawState());
        mgEndFrame(nullptr);

        result.physical = MgTexturePhysicalExtent(texture);
        const gfx::TextureInfo info = gfx::GetTextureInfo(mgPortFindTexture(texture).texture).value_or(gfx::TextureInfo{});
        ASSERT_NE(info.pixel_width, 0u);
        result.image_width = info.pixel_width;
        result.image_height = info.pixel_height;

        std::vector<uint8_t> rgba;
        uint32_t             width = 0;
        uint32_t             height = 0;
        ASSERT_TRUE(mgPortReadColor(gfx::kMainTarget, rgba, width, height));
        const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(gfx::kMainTarget);

        video::MoviePlayer picture;
        picture.SetRetailSize(retail, retail);
        ASSERT_TRUE(picture.Open(movie_root.root / "movie/hd.mp4", false));
        result.picture = picture.Rgba();
        result.picture_width = picture.Width();
        result.picture_height = picture.Height();
        // The quad spans retail texels, which hold physical / (1 << TW) picture pixels each.
        const float cell = 256.0f * static_cast<float>(1u << texture->tex0.TW) /
                           (static_cast<float>(retail) * static_cast<float>(result.physical.width));
        for (int y = 0; y < picture.Height(); y++) {
            for (int x = 0; x < picture.Width(); x++) {
                const float lx = (static_cast<float>(x) + 0.5f) * cell;
                const float ly = (static_cast<float>(y) + 0.5f) * cell;
                const auto  px = static_cast<uint32_t>(mapping.offset_x + (lx * mapping.scale_x));
                const auto  py = static_cast<uint32_t>(mapping.offset_y + (ly * mapping.scale_y));
                ASSERT_LT(px, width);
                ASSERT_LT(py, height);
                const size_t at = ((static_cast<size_t>(py) * width) + px) * 4;
                result.drawn.insert(result.drawn.end(), rgba.begin() + static_cast<std::ptrdiff_t>(at),
                                    rgba.begin() + static_cast<std::ptrdiff_t>(at + 3));
            }
        }
    }
}

// Largest RGB difference between a picture pixel and its cell on screen.
int MaxPictureDifference(const HdMovieResult &result) {
    int worst = 0;
    for (size_t i = 0; i < static_cast<size_t>(result.picture_width) * result.picture_height; i++) {
        for (size_t c = 0; c < 3; c++) {
            worst = std::max(worst, std::abs(result.drawn.at((i * 3) + c) - result.picture.at((i * 4) + c)));
        }
    }
    return worst;
}

} // namespace

TEST(MovieTextureGpu, DoubleSizeReplacementFillsTheMovieTextureAtTwoTexelsPerTexel) {
    std::vector<HdMovieResult> results;
    PlayHdMovies(8, {8}, results);
    if (HasFatalFailure()) {
        return;
    }
    const HdMovieResult &result = results.at(0);
    EXPECT_EQ(result.physical.width, 16u);
    EXPECT_EQ(result.physical.height, 16u);
    EXPECT_EQ(result.image_width, 16u);
    EXPECT_EQ(result.image_height, 16u);
    EXPECT_EQ(result.picture_width, 16);
    EXPECT_EQ(result.log.find("movie:"), std::string::npos) << result.log;
    // Every picture pixel reaches the screen, not only the top-left 8x8.
    EXPECT_LE(MaxPictureDifference(result), 2);
}

TEST(MovieTextureGpu, OneTextureTakesFourTimesTwiceAndRetailMoviesInTurn) {
    std::vector<HdMovieResult> results;
    // On a 16x16 texture the 16x16 fixture is 4x a 4x4 movie, 2x an 8x8 one and the retail size of a 16x16 one.
    PlayHdMovies(16, {4, 8, 16}, results);
    if (HasFatalFailure()) {
        return;
    }
    ASSERT_EQ(results.size(), 3u);
    const std::array<uint32_t, 3> canvases{64, 32, 16};
    for (size_t i = 0; i < results.size(); i++) {
        EXPECT_EQ(results[i].physical.width, canvases.at(i)) << i;
        EXPECT_EQ(results[i].image_width, canvases.at(i)) << i;
        EXPECT_EQ(results[i].image_height, canvases.at(i)) << i;
        EXPECT_EQ(results[i].picture_width, 16) << i;
        EXPECT_EQ(results[i].log.find("movie:"), std::string::npos) << results[i].log;
        EXPECT_LE(MaxPictureDifference(results[i]), 2) << i;
    }
}

TEST(MovieTextureGpu, OtherSizesAreResampledToAMultipleWithOneDiagnostic) {
    std::vector<HdMovieResult> results;
    // 16x16 over a 6x6 retail size: 2x is 12x12, which the 6x6 texture's 8x8 canvas holds at 16x16.
    PlayHdMovies(6, {6}, results);
    if (HasFatalFailure()) {
        return;
    }
    const HdMovieResult &result = results.at(0);
    EXPECT_EQ(result.picture_width, 12);
    EXPECT_EQ(result.picture_height, 12);
    EXPECT_EQ(result.physical.width, 16u);
    EXPECT_EQ(result.image_width, 16u);
    const size_t first = result.log.find("resampled to 12x12");
    ASSERT_NE(first, std::string::npos) << result.log;
    EXPECT_EQ(result.log.find("movie:", first), std::string::npos) << result.log;
    EXPECT_LE(MaxPictureDifference(result), 2);
}
