#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <cstring>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "render/renderer.hpp"
#include "render/texture_runtime.hpp"

namespace {

using Quads = std::vector<u_long128>;
using Levels = std::array<u_long128 *, MG_TEXTURE_LEVEL_MAX>;

constexpr int      kTextureCount = 16;
constexpr int      kBlockCount = 2;
constexpr size_t   kStorageQuads = 4096;
constexpr int      kSide = 16;
constexpr int      kCopySide = 8;
constexpr int      kCopyOrigin = 4;
constexpr uint64_t kRetailTexa = 0x0000008000000080ULL;

Quads Pack(const std::vector<uint8_t> &bytes) {
    Quads quads((bytes.size() + 15) / 16 + 1, 0);
    std::memcpy(quads.data(), bytes.data(), bytes.size());
    return quads;
}

std::vector<uint8_t> RgbaPixels(uint8_t value) {
    std::vector<uint8_t> pixels(kSide * kSide * 4);
    for (size_t i = 0; i < pixels.size(); i += 4) {
        pixels[i] = value;
        pixels[i + 1] = static_cast<uint8_t>(255 - value);
        pixels[i + 2] = 0x30;
        pixels[i + 3] = 0xff;
    }
    return pixels;
}

class Harness {
public:
    Harness() {
        memory.stSetBuffer(storage.data(), static_cast<int>(kStorageQuads));
        manager.SetTableBuffer(kTextureCount, kBlockCount, &memory);
        manager.Initialize(0x1000, -1);
    }

    ~Harness() {
        manager.Initialize(0x1000, -1);
    }

    Harness(const Harness &) = delete;
    Harness &operator=(const Harness &) = delete;

    Quads             storage = Quads(kStorageQuads, 0);
    mgCMemory         memory;
    mgCTextureManager manager;
};

// Restores the process-wide state a case may leave behind.
class StateReset {
public:
    StateReset() = default;

    ~StateReset() {
        mgPortResetGs();
        mgCTextureAnime::stop_anime = 0;
    }

    StateReset(const StateReset &) = delete;
    StateReset &operator=(const StateReset &) = delete;
};

mgCTexture *Enter32(Harness &h, std::string name, u_long128 *pixels) {
    Levels levels{};
    levels[0] = pixels;
    return h.manager.EnterTexture(0, name.data(), levels.data(), kSide, kSide, 32, nullptr, 0, 0);
}

void SetCopy(mgCTexAnimeData &data, mgCTexture *src, mgCTexture *dest, int wait) {
    data.type = static_cast<signed char>(MG_TEX_ANIME_TYPE_COPY);
    data.src_tex = src;
    data.dest_tex = dest;
    data.src_x = 0;
    data.src_y = 0;
    data.src_w = kCopySide * MG_TEX_ANIME_SUBTEXEL;
    data.src_h = kCopySide * MG_TEX_ANIME_SUBTEXEL;
    data.dest_x = kCopyOrigin * MG_TEX_ANIME_SUBTEXEL;
    data.dest_y = kCopyOrigin * MG_TEX_ANIME_SUBTEXEL;
    data.dest_w = kCopySide * MG_TEX_ANIME_SUBTEXEL;
    data.dest_h = kCopySide * MG_TEX_ANIME_SUBTEXEL;
    data.wait = static_cast<short>(wait);
    data.bug_patch = 0;
}

} // namespace

TEST(MgTanime, CopyRecordHoldsTwoCallsThenAdvances) {
    StateReset  reset;
    Harness     h;
    Quads       src_px = Pack(RgbaPixels(0x21));
    Quads       dst_px = Pack(RgbaPixels(0x55));
    mgCTexture *src = Enter32(h, "tanime_src", src_px.data());
    mgCTexture *dst = Enter32(h, "tanime_dst", dst_px.data());
    ASSERT_NE(src, nullptr);
    ASSERT_NE(dst, nullptr);

    CList<mgCTexAnimeData> first;
    CList<mgCTexAnimeData> second;
    SetCopy(first.data, src, dst, 2);
    SetCopy(second.data, src, dst, 1);
    first.next = &second;
    second.prev = &first;

    mgCTextureAnime anime;
    anime.list[0] = &first;
    anime.now[0] = &first;
    anime.enable[0] = 1;

    anime.TexAnime(0, nullptr);
    EXPECT_EQ(anime.frame[0], 1);
    EXPECT_EQ(anime.now[0], &first);

    anime.TexAnime(0, nullptr);
    EXPECT_EQ(anime.frame[0], 2);
    EXPECT_EQ(anime.now[0], &first);

    anime.TexAnime(0, nullptr);
    EXPECT_EQ(anime.frame[0], 0);
    EXPECT_EQ(anime.now[0], &second);

    anime.TexAnime(0, nullptr);
    EXPECT_EQ(anime.frame[0], 1);
    EXPECT_EQ(anime.now[0], &second);

    anime.TexAnime(0, nullptr);
    EXPECT_EQ(anime.frame[0], 0);
    EXPECT_EQ(anime.now[0], &first);
}

TEST(MgTanime, StopAnimeFreezesGroup) {
    StateReset  reset;
    Harness     h;
    Quads       src_px = Pack(RgbaPixels(0x21));
    Quads       dst_px = Pack(RgbaPixels(0x55));
    mgCTexture *src = Enter32(h, "tanime_stop_src", src_px.data());
    mgCTexture *dst = Enter32(h, "tanime_stop_dst", dst_px.data());
    ASSERT_NE(src, nullptr);
    ASSERT_NE(dst, nullptr);

    CList<mgCTexAnimeData> first;
    CList<mgCTexAnimeData> second;
    SetCopy(first.data, src, dst, 0);
    SetCopy(second.data, src, dst, 0);
    first.next = &second;
    second.prev = &first;

    mgCTextureAnime anime;
    anime.list[0] = &first;
    anime.now[0] = &first;
    anime.enable[0] = 1;

    mgCTextureAnime::stop_anime = 1;
    for (int call = 0; call < 3; call++) {
        anime.TexAnime(0, nullptr);
    }

    EXPECT_EQ(anime.frame[0], 0);
    EXPECT_EQ(anime.now[0], &first);
}

TEST(MgTanime, TexAnimeWritesRetailTexa) {
    StateReset reset;
    mgPortGs().texa = 0;

    mgCTextureAnime anime;
    anime.TexAnime(0, nullptr);

    EXPECT_EQ(mgPortGs().texa, kRetailTexa);
}

namespace {

class MgTanimeGpu : public testing::Test {
protected:
    dc::test::GfxFixture gfx_;
    Harness              h_;
};

} // namespace

TEST_F(MgTanimeGpu, TrueColourRecordDrawsIntoRegisteredTexture) {
    StateReset reset;
    // mgInit arms the port so the tick records and renders; unbounded so mgEndFrame does not wait for vsync.
    ClockSetUnbounded(true);
    mgInit(MG_SCREEN_MODE_512X480, 3);
    std::vector<uint8_t> src_bytes(kSide * kSide * 4);
    for (size_t i = 0; i < src_bytes.size(); i += 4) {
        src_bytes[i] = 0x10;
        src_bytes[i + 1] = 0x90;
        src_bytes[i + 2] = 0x40;
        src_bytes[i + 3] = 0xFF;
    }
    std::vector<uint8_t> dst_bytes(kSide * kSide * 4);
    for (size_t i = 0; i < dst_bytes.size(); i++) {
        dst_bytes[i] = static_cast<uint8_t>(i * 5 + 1);
    }
    Quads src_px = Pack(src_bytes);
    Quads dst_px = Pack(dst_bytes);

    mgCTexture *src = Enter32(h_, "tanime_tc_src", src_px.data());
    mgCTexture *dst = Enter32(h_, "tanime_tc_dst", dst_px.data());
    ASSERT_NE(src, nullptr);
    ASSERT_NE(dst, nullptr);
    const MgTextureHandles src_handles = MgTextureLookup(src);
    const MgTextureHandles dst_handles = MgTextureLookup(dst);
    ASSERT_NE(src_handles.texture, gfx::kNullTexture);
    ASSERT_NE(dst_handles.texture, gfx::kNullTexture);

    CList<mgCTexAnimeData> node;
    SetCopy(node.data, src, dst, -1);
    node.data.r = node.data.g = node.data.b = node.data.a = 0x80;
    node.data.bilinear = 0;
    node.data.alpha_blend = static_cast<signed char>(MG_TEX_ANIME_ALPHA_BLEND_OFF);
    node.data.alpha_test = static_cast<signed char>(MG_TEX_ANIME_ALPHA_TEST_OFF);

    mgCTextureAnime anime;
    anime.list[0] = &node;
    anime.now[0] = &node;
    anime.enable[0] = 1;

    mgBeginFrame(nullptr);
    anime.TexAnime(0, nullptr);
    mgEndFrame(nullptr);

    const gfx::TextureHandle target = mgPortFindTexture(dst).texture;
    ASSERT_NE(target, gfx::kNullTexture);
    ASSERT_NE(target, dst_handles.texture);

    std::vector<uint8_t> target_px;
    std::vector<uint8_t> image_px;
    std::vector<uint8_t> source_px;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortReadColor(target, target_px, width, height));
    ASSERT_EQ(width, static_cast<uint32_t>(kSide));
    ASSERT_EQ(height, static_cast<uint32_t>(kSide));
    ASSERT_TRUE(gfx::ReadbackTexture(dst_handles.texture, image_px, width, height));
    ASSERT_TRUE(gfx::ReadbackTexture(src_handles.texture, source_px, width, height));

    for (int y = 0; y < kSide; y++) {
        for (int x = 0; x < kSide; x++) {
            const bool     inside = x >= kCopyOrigin && x < kCopyOrigin + kCopySide && y >= kCopyOrigin &&
                                    y < kCopyOrigin + kCopySide;
            const uint8_t *got = &target_px[(static_cast<size_t>(y) * kSide + x) * 4];
            const uint8_t *want = inside ? source_px.data() : &image_px[(static_cast<size_t>(y) * kSide + x) * 4];
            for (int c = 0; c < 3; c++) {
                EXPECT_EQ(got[c], want[c]) << "channel " << c << " texel " << x << "," << y;
            }
        }
    }
}

TEST(MgTextureAnime, InitializeClearsEveryRectangleAndWaveDimension) {
    mgCTexAnimeData data;
    data.src_x = 1;
    data.src_y = 2;
    data.src_w = 3;
    data.src_h = 4;
    data.dest_x = 5;
    data.dest_y = 6;
    data.dest_w = 7;
    data.dest_h = 8;
    data.period_x = 9;
    data.period_y = 10;
    data.amplitude_x = 11;
    data.amplitude_y = 12;
    data.Initialize();
    EXPECT_EQ(data.src_x, 0);
    EXPECT_EQ(data.src_y, 0);
    EXPECT_EQ(data.src_w, 0);
    EXPECT_EQ(data.src_h, 0);
    EXPECT_EQ(data.dest_x, 0);
    EXPECT_EQ(data.dest_y, 0);
    EXPECT_EQ(data.dest_w, 0);
    EXPECT_EQ(data.dest_h, 0);
    EXPECT_EQ(data.period_x, 0);
    EXPECT_EQ(data.period_y, 0);
    EXPECT_EQ(data.amplitude_x, 0);
    EXPECT_EQ(data.amplitude_y, 0);
}
