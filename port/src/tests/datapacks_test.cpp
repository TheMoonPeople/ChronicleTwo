#include <gtest/gtest.h>

#include <algorithm>
#include <atomic>
#include <chrono>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <mutex>
#include <set>
#include <span>
#include <string>
#include <thread>
#include <vector>

#include "button_glyphs.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "platform/settings.hpp"

namespace {

void WritePng(const std::filesystem::path &path, uint32_t width, uint32_t height,
              const std::vector<uint8_t> &rgba, bool rgb = false) {
    auto big = [](std::vector<uint8_t> &out, uint32_t value) {
        out.push_back(static_cast<uint8_t>(value >> 24));
        out.push_back(static_cast<uint8_t>(value >> 16));
        out.push_back(static_cast<uint8_t>(value >> 8));
        out.push_back(static_cast<uint8_t>(value));
    };
    auto chunk = [&big](std::vector<uint8_t> &out, const char *name, const std::vector<uint8_t> &payload) {
        big(out, static_cast<uint32_t>(payload.size()));
        const size_t first = out.size();
        out.insert(out.end(), name, name + 4);
        out.insert(out.end(), payload.begin(), payload.end());
        uint32_t crc = ~uint32_t{0};
        for (size_t i = first; i < out.size(); ++i) {
            crc ^= out[i];
            for (int bit = 0; bit < 8; ++bit) {
                crc = (crc >> 1) ^ (crc & 1 ? 0xEDB88320u : 0);
            }
        }
        big(out, ~crc);
    };
    std::vector<uint8_t> raw;
    for (uint32_t y = 0; y < height; ++y) {
        raw.push_back(0);
        for (uint32_t x = 0; x < width; ++x) {
            const auto offset = (static_cast<size_t>(y) * width + x) * 4;
            raw.insert(raw.end(), rgba.begin() + offset, rgba.begin() + offset + (rgb ? 3 : 4));
        }
    }
    std::vector<uint8_t> compressed{0x78, 0x01};
    for (size_t pos = 0; pos < raw.size();) {
        const size_t count = std::min<size_t>(raw.size() - pos, 65535);
        compressed.push_back(pos + count == raw.size() ? 1 : 0);
        compressed.push_back(static_cast<uint8_t>(count));
        compressed.push_back(static_cast<uint8_t>(count >> 8));
        compressed.push_back(static_cast<uint8_t>(~count));
        compressed.push_back(static_cast<uint8_t>(~count >> 8));
        compressed.insert(compressed.end(), raw.begin() + pos, raw.begin() + pos + count);
        pos += count;
    }
    uint32_t a = 1;
    uint32_t b = 0;
    for (uint8_t value : raw) {
        a = (a + value) % 65521;
        b = (b + a) % 65521;
    }
    big(compressed, (b << 16) | a);
    std::vector<uint8_t> png{137, 80, 78, 71, 13, 10, 26, 10};
    std::vector<uint8_t> header;
    big(header, width);
    big(header, height);
    header.insert(header.end(), {8, static_cast<uint8_t>(rgb ? 2 : 6), 0, 0, 0});
    chunk(png, "IHDR", header);
    chunk(png, "IDAT", compressed);
    chunk(png, "IEND", {});
    std::ofstream file(path, std::ios::binary);
    file.write(reinterpret_cast<const char *>(png.data()), static_cast<std::streamsize>(png.size()));
    ASSERT_TRUE(file.good());
}

class DatapacksTest : public ::testing::Test {
protected:
    std::filesystem::path  directory = std::filesystem::temp_directory_path() /
                                       ("ct_datapacks_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path  retail = directory / "data";
    texture_catalog::Entry entry;

    void SetUp() override {
        std::filesystem::create_directories(retail);
        entry.type = "texture";
        entry.name = "color";
        entry.bpp = 32;
        entry.width = 3;
        entry.height = 2;
        entry.variants.push_back({
            .selector = "color", .levels = {{.path = "textures/base.png", .file = vfs::HostFile(retail / "textures/base.png")}, {.path = "textures/mip.png", .file = vfs::HostFile(retail / "textures/mip.png")}}
        });
        Png(retail / "textures/base.png", 3, 2, 20);
        Png(retail / "textures/mip.png", 1, 1, 30);
    }

    void TearDown() override {
        datapacks::Clear();
        std::error_code error;
        std::filesystem::remove_all(directory, error);
    }

    static void Png(const std::filesystem::path &path, uint32_t width, uint32_t height, uint8_t color, bool rgb = false) {
        std::filesystem::create_directories(path.parent_path());
        std::vector<uint8_t> pixels(static_cast<std::size_t>(width) * height * 4, color);
        for (std::size_t i = 3; i < pixels.size(); i += 4) {
            pixels[i] = 255;
        }
        WritePng(path, width, height, pixels, rgb);
    }

    std::filesystem::path Pack(const std::string &name, const std::string &file = "textures/base.png") {
        return directory / "datapacks" / std::filesystem::path(std::u8string(name.begin(), name.end())) / file;
    }

    void Config(const std::string &text) {
        std::filesystem::create_directories(directory / "datapacks");
        std::ofstream(directory / "datapacks/datapacks.json") << text;
        datapacks::Load(retail);
    }

    datapacks::DecodedTexture Decode() {
        datapacks::DecodedTexture result;
        std::string               error;
        EXPECT_TRUE(datapacks::Decode(entry, 0, result, error)) << error;
        return result;
    }
};

TEST_F(DatapacksTest, MissingConfigurationUsesPaddedRetailAndExplicitMips) {
    datapacks::Load(retail);
    const auto decoded = Decode();
    ASSERT_EQ(decoded.levels.size(), 2u);
    EXPECT_EQ(decoded.width, 4u);
    EXPECT_EQ(decoded.height, 2u);
    EXPECT_EQ(decoded.levels[0].size(), 32u);
    EXPECT_EQ(decoded.levels[0][0], 20);
    EXPECT_EQ(decoded.levels[0][12], 0);
    EXPECT_EQ(decoded.levels[0][15], 0);
    EXPECT_EQ(decoded.levels[1][0], 30);
    EXPECT_EQ(decoded.levels[1][4], 0);
    EXPECT_EQ(entry.width, 3);
    EXPECT_EQ(entry.height, 2);
}

TEST_F(DatapacksTest, LaterFoldersWinAndReorderingChangesWinner) {
    Png(Pack("First pack"), 3, 2, 80);
    Png(Pack("日本語 pack"), 3, 2, 160);
    Config(R"({"schema_version":1,"load_order":["First pack","日本語 pack"]})");
    EXPECT_EQ(Decode().levels[0][0], 160);
    Config(R"({"schema_version":1,"load_order":["日本語 pack","First pack"]})");
    EXPECT_EQ(Decode().levels[0][0], 80);
    EXPECT_EQ(Decode().levels[1][0], 30);
}

TEST_F(DatapacksTest, CorruptAndInvalidScaleFallBackThroughLowerPacks) {
    Png(Pack("low"), 6, 4, 80);
    Png(Pack("high"), 9, 6, 160);
    Config(R"({"schema_version":1,"load_order":["low","high"]})");
    auto decoded = Decode();
    EXPECT_EQ(decoded.width, 8u);
    EXPECT_EQ(decoded.height, 4u);
    EXPECT_EQ(decoded.levels[0][0], 80);
    std::ofstream(Pack("high"), std::ios::binary | std::ios::trunc) << "corrupt";
    EXPECT_EQ(Decode().levels[0][0], 80);
    std::ofstream(Pack("low"), std::ios::binary | std::ios::trunc) << "corrupt";
    EXPECT_EQ(Decode().levels[0][0], 20);
}

TEST_F(DatapacksTest, UpscaleGeneratesMissingMipsAndAcceptsMatchingExplicitLevel) {
    Png(Pack("upscaled"), 6, 4, 80);
    Png(Pack("upscaled", "textures/mip.png"), 2, 2, 160);
    Config(R"({"schema_version":1,"load_order":["upscaled"]})");
    auto decoded = Decode();
    ASSERT_EQ(decoded.levels.size(), 2u);
    EXPECT_EQ(decoded.levels[1].size(), 4u * 2 * 4);
    EXPECT_EQ(decoded.levels[1][0], 80);
    Png(Pack("upscaled", "textures/mip.png"), 3, 2, 160);
    decoded = Decode();
    EXPECT_EQ(decoded.levels[1][0], 160);
    EXPECT_EQ(decoded.levels[1][12], 0);
}

TEST_F(DatapacksTest, ThinUpscaledTextureNeverExceedsPhysicalMipCanvas) {
    entry.width = 1;
    entry.height = 4;
    Png(retail / "textures/base.png", 1, 4, 20);
    Png(retail / "textures/mip.png", 1, 2, 30);
    Png(Pack("thin"), 2, 8, 80);
    Png(Pack("thin", "textures/mip.png"), 2, 4, 160);
    Config(R"({"schema_version":1,"load_order":["thin"]})");
    auto decoded = Decode();
    EXPECT_EQ(decoded.levels[1].size(), 1u * 4 * 4);
    EXPECT_EQ(decoded.levels[1][0], 80);
    Png(Pack("thin", "textures/mip.png"), 1, 4, 160);
    decoded = Decode();
    EXPECT_EQ(decoded.levels[1][0], 160);
}

TEST_F(DatapacksTest, OrdinaryRgbPngOverlayIsConvertedToRgba) {
    Png(Pack("rgb"), 3, 2, 80, true);
    Config(R"({"schema_version":1,"load_order":["rgb"]})");
    const auto decoded = Decode();
    EXPECT_EQ(decoded.levels[0][0], 80);
    EXPECT_EQ(decoded.levels[0][3], 255);
}

TEST_F(DatapacksTest, InvalidConfigurationDisablesAllPacks) {
    Png(Pack("valid"), 3, 2, 80);
    for (const auto *config : {
             R"({"schema_version":2,"load_order":["valid"]})",
             R"({"schema_version":1.0,"load_order":["valid"]})",
             R"({"schema_version":1,"load_order":["valid","../escape"]})",
             R"({"schema_version":1,"load_order":["valid","a/b"]})",
             R"({"schema_version":1,"load_order":["valid","C:escape"]})",
             R"({"schema_version":1,"load_order":["valid",""]})",
             R"({"schema_version":1,"load_order":["valid",false]})",
             "invalid JSON"}) {
        Config(R"({"schema_version":1,"load_order":["valid"]})");
        EXPECT_EQ(Decode().levels[0][0], 80);
        Config(config);
        EXPECT_EQ(Decode().levels[0][0], 20) << config;
    }
}

TEST_F(DatapacksTest, GenericOverridesIgnoreCaseAndRejectTraversal) {
    const auto path = Pack("files", "Chara/Hero.dat");
    std::filesystem::create_directories(path.parent_path());
    std::ofstream(path) << "replacement";
    Config(R"({"schema_version":1,"load_order":["files"]})");
    const auto resolved = datapacks::Resolve("chara/hero.DAT");
    ASSERT_TRUE(resolved);
    EXPECT_EQ(std::filesystem::weakly_canonical(*vfs::HostPath(*resolved)), std::filesystem::weakly_canonical(path));
    EXPECT_FALSE(datapacks::Resolve("../Chara/Hero.dat"));
    EXPECT_FALSE(datapacks::Resolve("/Chara/Hero.dat"));
    EXPECT_FALSE(datapacks::Resolve("C:Chara/Hero.dat"));
    datapacks::Clear();
    EXPECT_FALSE(datapacks::Resolve("chara/hero.dat"));
}

TEST_F(DatapacksTest, InvalidEntriesFailWithoutPartialOutput) {
    datapacks::Load(retail);
    datapacks::DecodedTexture decoded;
    std::string               error;
    EXPECT_FALSE(datapacks::Decode(entry, 1, decoded, error));
    EXPECT_FALSE(error.empty());
    entry.width = 0;
    EXPECT_FALSE(datapacks::Decode(entry, 0, decoded, error));
    EXPECT_TRUE(decoded.levels.empty());
    entry.width = 3;
    std::ofstream(retail / "textures/base.png", std::ios::binary | std::ios::trunc) << "corrupt";
    EXPECT_FALSE(datapacks::Decode(entry, 0, decoded, error));
    EXPECT_TRUE(decoded.levels.empty());
    EXPECT_EQ(decoded.width, 0u);
}

TEST_F(DatapacksTest, FourTimesUpscaleIsAcceptedAndNonuniformScaleFallsBack) {
    Png(Pack("large"), 12, 8, 80);
    Png(Pack("nonuniform"), 12, 4, 160);
    Config(R"({"schema_version":1,"load_order":["large","nonuniform"]})");
    const auto decoded = Decode();
    EXPECT_EQ(decoded.width, 16u);
    EXPECT_EQ(decoded.height, 8u);
    EXPECT_EQ(decoded.levels[0][0], 80);
    EXPECT_EQ(decoded.levels[1].size(), 8u * 4 * 4);
}

TEST_F(DatapacksTest, UnlistedAndMissingFoldersDoNotOverrideRetail) {
    Png(Pack("unlisted"), 3, 2, 80);
    Config(R"({"schema_version":1,"load_order":["missing"]})");
    EXPECT_EQ(Decode().levels[0][0], 20);
    Config(R"({"schema_version":1,"load_order":[]})");
    EXPECT_EQ(Decode().levels[0][0], 20);
}

TEST_F(DatapacksTest, OversizedPngHeaderFallsBackBeforePixelAllocation) {
    const auto path = Pack("oversized");
    Png(path, 3, 2, 80);
    {
        std::fstream file(path, std::ios::binary | std::ios::in | std::ios::out);
        file.seekp(16);
        const unsigned char width[4] = {0, 0, 64, 1};
        file.write(reinterpret_cast<const char *>(width), 4);
    }
    Config(R"({"schema_version":1,"load_order":["oversized"]})");
    EXPECT_EQ(Decode().levels[0][0], 20);
}

TEST_F(DatapacksTest, SharedImageCacheRetainsIndependentPixelsAndClearsWithRoots) {
    int  calls = 0;
    auto provider = [&](datapacks::DecodedTexture &out, std::string &) {
        ++calls;
        out = {.levels = {{10, 20, 30, 255}}, .width = 1, .height = 1};
        return true;
    };
    datapacks::DecodedTexture first;
    datapacks::DecodedTexture second;
    std::string               error;
    ASSERT_TRUE(datapacks::DecodeCached("embedded-model:image:0", provider, first, error));
    first.levels[0][0] = 99;
    ASSERT_TRUE(datapacks::DecodeCached("embedded-model:image:0", provider, second, error));
    EXPECT_EQ(calls, 1);
    EXPECT_EQ(second.levels[0][0], 10);
    datapacks::Load(retail);
    ASSERT_TRUE(datapacks::DecodeCached("embedded-model:image:0", provider, second, error));
    EXPECT_EQ(calls, 2);
}

TEST_F(DatapacksTest, ImageCacheKeysTrackMissingAndEditedHigherPriorityInputs) {
    const auto            replacement = retail / "replacement.png";
    std::vector<vfs::Ref> paths{vfs::HostFile(replacement), vfs::HostFile(retail / "textures/base.png")};
    const auto            original = datapacks::ImageDecodeKey("model:image:0:overlay", paths);
    std::ofstream(replacement) << "candidate";
    const auto created = datapacks::ImageDecodeKey("model:image:0:overlay", paths);
    EXPECT_NE(original, created);
    std::ofstream(replacement, std::ios::trunc) << "edited candidate";
    EXPECT_NE(created, datapacks::ImageDecodeKey("model:image:0:overlay", paths));
    EXPECT_NE(original, datapacks::ImageDecodeKey("model:image:1:overlay", paths));
    EXPECT_NE(original, datapacks::ImageDecodeKey("model:image:0:logical", paths));
}

TEST_F(DatapacksTest, ReadFileBytesReadsWholeFilesWithinTheLimit) {
    const auto path = directory / "bytes.bin";
    std::ofstream(path, std::ios::binary) << std::string("abc\0def", 7);
    std::vector<uint8_t> bytes{1, 2, 3};
    ASSERT_TRUE(datapacks::ReadFileBytes(path, bytes));
    EXPECT_EQ(bytes, (std::vector<uint8_t>{'a', 'b', 'c', 0, 'd', 'e', 'f'}));
    EXPECT_TRUE(datapacks::ReadFileBytes(path, bytes, 7));
    EXPECT_FALSE(datapacks::ReadFileBytes(path, bytes, 6));
    EXPECT_TRUE(bytes.empty());
    EXPECT_FALSE(datapacks::ReadFileBytes(directory / "missing.bin", bytes));
    std::ofstream(directory / "empty.bin", std::ios::binary).close();
    EXPECT_TRUE(datapacks::ReadFileBytes(directory / "empty.bin", bytes));
    EXPECT_TRUE(bytes.empty());
}

TEST_F(DatapacksTest, PrefetchCachesResultsAndSkipsCachedIdentities) {
    std::atomic<int> calls = 0;
    auto             job = [&](std::string identity, uint8_t value) {
        return datapacks::DecodeJob{.identity = std::move(identity), .decoder = [&calls, value](datapacks::DecodedTexture &out, std::string &) {
                                        ++calls;
                                        out = {.levels = {{value, value, value, 255}}, .width = 1, .height = 1};
                                        return true;
                                    }};
    };
    std::vector<datapacks::DecodeJob> jobs{job("prefetch:a", 10), job("prefetch:b", 20), job("", 30)};
    datapacks::Prefetch(jobs);
    EXPECT_EQ(calls, 2);
    auto unexpected = [](datapacks::DecodedTexture &, std::string &error) {
        error = "decoded again";
        return false;
    };
    datapacks::DecodedTexture decoded;
    std::string               error;
    ASSERT_TRUE(datapacks::DecodeCached("prefetch:a", unexpected, decoded, error)) << error;
    EXPECT_EQ(decoded.levels[0][0], 10);
    ASSERT_TRUE(datapacks::DecodeCached("prefetch:b", unexpected, decoded, error)) << error;
    EXPECT_EQ(decoded.levels[0][0], 20);
    datapacks::Prefetch(jobs);
    EXPECT_EQ(calls, 2);
    const auto shared = datapacks::DecodeShared("prefetch:a", unexpected, error);
    ASSERT_TRUE(shared);
    EXPECT_EQ(shared, datapacks::DecodeShared("prefetch:a", unexpected, error));
    EXPECT_EQ(shared->levels[0][0], 10);
}

TEST_F(DatapacksTest, PrefetchDoesNotCacheFailuresAndDecodesDuplicatesOnce) {
    std::atomic<int>                  failures = 0;
    std::atomic<int>                  successes = 0;
    std::vector<datapacks::DecodeJob> jobs;
    for (int copy = 0; copy < 4; ++copy) {
        jobs.push_back({.identity = "prefetch:failing", .decoder = [&](datapacks::DecodedTexture &out, std::string &error) {
                            ++failures;
                            out.levels = {
                                {1, 2, 3, 4}
                            };
                            error = "broken";
                            return false;
                        }});
        jobs.push_back({.identity = "prefetch:duplicate", .decoder = [&](datapacks::DecodedTexture &out, std::string &) {
                            ++successes;
                            out = {.levels = {{40, 40, 40, 255}}, .width = 1, .height = 1};
                            return true;
                        }});
    }
    datapacks::Prefetch(jobs);
    EXPECT_EQ(failures, 1);
    EXPECT_EQ(successes, 1);
    datapacks::DecodedTexture decoded;
    std::string               error;
    EXPECT_FALSE(datapacks::DecodeCached("prefetch:failing", jobs[0].decoder, decoded, error));
    EXPECT_EQ(error, "broken");
    EXPECT_EQ(failures, 2);
    EXPECT_FALSE(datapacks::DecodeShared("prefetch:failing", jobs[0].decoder, error));
    EXPECT_EQ(failures, 3);
    ASSERT_TRUE(datapacks::DecodeCached("prefetch:duplicate", jobs[1].decoder, decoded, error));
    EXPECT_EQ(successes, 1);
    EXPECT_EQ(decoded.levels[0][0], 40);
}

TEST_F(DatapacksTest, PrefetchDecodesCatalogTexturesConcurrently) {
    Png(Pack("concurrent"), 6, 4, 80);
    Config(R"({"schema_version":1,"load_order":["concurrent"]})");
    std::mutex                        mutex;
    std::set<std::thread::id>         threads;
    std::vector<datapacks::DecodeJob> jobs;
    jobs.reserve(64);
    for (int index = 0; index < 64; ++index) {
        jobs.push_back({.identity = "prefetch:catalog:" + std::to_string(index), .decoder = [&, index](datapacks::DecodedTexture &out, std::string &error) {
                            {
                                const std::scoped_lock lock(mutex);
                                threads.insert(std::this_thread::get_id());
                            }
                            const auto key = datapacks::ImageDecodeKey("prefetch", datapacks::Candidates("textures/base.png"));
                            if (key.empty() || !datapacks::Decode(entry, 0, out, error)) {
                                return false;
                            }
                            out.levels[0][1] = static_cast<uint8_t>(index);
                            return true;
                        }});
    }
    datapacks::Prefetch(jobs);
    EXPECT_GE(threads.size(), 1u);
    for (int index = 0; index < 64; ++index) {
        datapacks::DecodedTexture decoded;
        std::string               error;
        ASSERT_TRUE(datapacks::DecodeCached(
            jobs[index].identity, [](datapacks::DecodedTexture &, std::string &) { return false; }, decoded, error));
        EXPECT_EQ(decoded.width, 8u);
        EXPECT_EQ(decoded.levels[0][0], 80);
        EXPECT_EQ(decoded.levels[0][1], index);
        EXPECT_EQ(decoded.levels[1][0], 80);
    }
}

TEST_F(DatapacksTest, StampScopeHoldsSourceStampsUntilItEnds) {
    const auto            source = retail / "stamped.png";
    std::vector<vfs::Ref> paths{vfs::HostFile(source)};
    std::ofstream(source) << "first";
    std::string scoped;
    {
        const datapacks::StampScope outer;
        scoped = datapacks::ImageDecodeKey("stamped", paths);
        {
            const datapacks::StampScope inner;
        }
        std::ofstream(source, std::ios::trunc) << "second edit";
        EXPECT_EQ(scoped, datapacks::ImageDecodeKey("stamped", paths));
    }
    EXPECT_NE(scoped, datapacks::ImageDecodeKey("stamped", paths));
}

TEST_F(DatapacksTest, MissingGlyphAtlasPreservesEveryOriginalMipPixel) {
    const auto previous_root = PathsSaveRoot();
    const auto previous_settings = SettingsGet();

    struct Cleanup {
        std::filesystem::path root;
        HostSettings          settings;

        ~Cleanup() {
            SettingsChange(settings);
            PathsSetSaveRoot(root);
            ButtonGlyphsReset();
        }
    } cleanup{.root = previous_root, .settings = previous_settings};

    PathsSetSaveRoot(directory / "save");
    std::filesystem::create_directories(PathsSaveRoot() / "glyphs");
    std::ofstream(PathsSaveRoot() / "glyphs/glyphs.json") << R"({"styles":{"ps3":{"atlas":"missing.png","glyphs":{"cross":[0,0,1,1]}}}})";
    auto selected = previous_settings;
    selected.glyphs_new = true;
    selected.glyph_device = ConfigGlyphDevice::Ps3;
    ASSERT_TRUE(SettingsChange(selected));
    ButtonGlyphsReset();
    datapacks::DecodedTexture decoded;
    decoded.width = decoded.height = 256;
    decoded.levels = {std::vector<uint8_t>(256 * 256 * 4, 73), std::vector<uint8_t>(128 * 128 * 4, 97)};
    const auto originals = decoded.levels;
    ButtonGlyphsApply("gaiji", 256, 256, decoded);
    EXPECT_EQ(decoded.levels, originals);
}

} // namespace

TEST(DatapacksPng, DecodesRgbaAndRejectsTruncatedData) {
    // A 2x1 RGBA PNG holding (10, 20, 30, 40) and (50, 60, 70, 80).
    const std::vector<uint8_t> png{
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00,
        0x02, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0xF4, 0x22, 0x7F, 0x8A, 0x00, 0x00, 0x00, 0x11, 0x49,
        0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0xE0, 0x12, 0x91, 0xD3, 0x30, 0xB2, 0x71, 0x0B, 0x00, 0x00, 0x04, 0xB9, 0x01,
        0x69, 0x03, 0x9D, 0x56, 0x37, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82};
    uint32_t             width = 0;
    uint32_t             height = 0;
    std::vector<uint8_t> rgba;
    std::string          error;
    ASSERT_TRUE(datapacks::DecodePng(png, width, height, rgba, error)) << error;
    EXPECT_EQ(width, 2u);
    EXPECT_EQ(height, 1u);
    EXPECT_EQ(rgba, (std::vector<uint8_t>{10, 20, 30, 40, 50, 60, 70, 80}));
    EXPECT_FALSE(datapacks::DecodePng(std::span(png).first(40), width, height, rgba, error));
    EXPECT_FALSE(datapacks::DecodePng(std::span(png).first(20), width, height, rgba, error));
}
