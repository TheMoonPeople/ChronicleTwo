#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <span>
#include <vector>

#include "drawwin.hpp"
#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "menudraw.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "nd_meswin.hpp"

namespace {

constexpr uint32_t kTextureWidth = 64;
constexpr uint32_t kTextureHeight = 8;
constexpr uint32_t kHalfWidth = 32;

class PrimSinkReset {
public:
    ~PrimSinkReset() {
        mgPortSetPrimSink({});
    }
};

void DrawTexturedSprite(mgCDrawPrim &prim, mgCTexture &source, std::array<float, 4> dest,
                        std::array<int, 4> uv) {
    prim.Coord(1);
    prim.TextureMapEnable(1);
    prim.Bilinear(0);
    prim.Texture(&source);
    prim.Begin(MG_PRIM_SPRITE);
    prim.TextureCrd(uv[0], uv[1]);
    prim.Vertex(dest[0], dest[1], 0.0f);
    prim.TextureCrd(uv[2], uv[3]);
    prim.Vertex(dest[2], dest[3], 0.0f);
    prim.End2();
}

} // namespace

TEST(MgDrawPrimRender, HelpWindowTranslucentTilesHaveContinuousCoverage) {
    dc::test::GfxFixture gfx(320, 240, 1.0f, true, 128, 96);
    const auto           mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    ASSERT_FLOAT_EQ(mapping.scale_x, 2.5f);
    ASSERT_FLOAT_EQ(mapping.scale_y, 2.5f);

    constexpr uint32_t       atlas_size = 256;
    std::vector<uint32_t>    atlas(static_cast<size_t>(atlas_size) * atlas_size, dc::test::Rgba(0, 0, 0, 128));
    const gfx::TextureHandle texture = gfx::CreateTexture({.width = atlas_size, .height = atlas_size, .format = gfx::TextureFormat::Rgba8});
    ASSERT_NE(texture, gfx::kNullTexture);
    ASSERT_TRUE(gfx::UpdateTextureNow(texture, 0, 0, 0, atlas_size, atlas_size, atlas.data()));

    mgCMemory      memory;
    sceVif1Packet  packet{};
    mgRENDER_INFO  info{};
    mgCDrawManager manager;
    mgCDrawPrim    prim;
    mgCTexture     source;
    prim.draw_manager = &manager;
    manager.render_info = &info;
    prim.Initialize(&memory, &packet);
    prim.write = nullptr;
    prim.AlphaBlendEnable(1);
    prim.TextureMapEnable(1);
    prim.Bilinear(0);
    prim.Texture(&source);

    PrimSinkReset sink_reset;
    int           tiles = 0;
    mgPortSetPrimSink([&](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                          const gfx::TextureBinding &binding, const gfx::DrawState &state) {
        gfx::TextureBinding bound = binding;
        bound.texture = texture;
        bound.ignore_alpha = false;
        gfx::Draw2D(primitive, vertices, bound, state);
        tiles += static_cast<int>(vertices.size() / 4);
    });
    const int saved_abs_draw_off = MesAbsDrawOff;
    MesAbsDrawOff = 0;
    gfx.Frame({255, 255, 255, 255}, [&] {
        MyMenuHelpWinDraw(&prim, {.x = 11, .y = 10, .width = 80, .height = 72}, 128);
    });
    MesAbsDrawOff = saved_abs_draw_off;

    EXPECT_EQ(tiles, 9);
    const auto centre = gfx.Pixel(100, 100);
    for (int seam_x : {11 + 24, 11 + 80 - 24}) {
        for (int dx = -1; dx <= 1; ++dx) {
            const auto pixel = gfx.Pixel(static_cast<uint32_t>(seam_x * 2.5f) + dx, 100);
            EXPECT_EQ(pixel, centre) << "vertical join " << seam_x << " offset " << dx;
        }
    }
    for (int seam_y : {10 + 22, 10 + 72 - 22}) {
        for (int dy = -1; dy <= 1; ++dy) {
            const auto pixel = gfx.Pixel(100, static_cast<uint32_t>(seam_y * 2.5f) + dy);
            EXPECT_EQ(pixel, centre) << "horizontal join " << seam_y << " offset " << dy;
        }
    }
    gfx::DestroyTexture(texture);
}

// Two 1:1 nearest tiles meet at logical x 47, where a 2.5x window puts a pixel centre on the seam. The left
// half of the texture is red, so any red pixel is a texel the seam sampled from the wrong side.
TEST(MgDrawPrimRender, TileSeamHasNoForeignTexel) {
    dc::test::GfxFixture gfx(1600, 1200);

    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    ASSERT_FLOAT_EQ(mapping.scale_x, 2.5f);
    ASSERT_FLOAT_EQ(mapping.offset_x, 0.0f);

    const gfx::TextureHandle texture = gfx::CreateTexture({.width = kTextureWidth, .height = kTextureHeight, .format = gfx::TextureFormat::Rgba8});
    ASSERT_NE(texture, gfx::kNullTexture);
    std::vector<uint8_t> texels(static_cast<size_t>(kTextureWidth) * kTextureHeight * 4);
    for (uint32_t y = 0; y < kTextureHeight; ++y) {
        for (uint32_t x = 0; x < kTextureWidth; ++x) {
            uint8_t *p = &texels[(static_cast<size_t>(y) * kTextureWidth + x) * 4];
            const bool left = x < kHalfWidth;
            p[0] = left ? 0xFF : 0x00;
            p[1] = left ? 0x00 : 0xFF;
            p[2] = 0x00;
            p[3] = 0xFF;
        }
    }
    ASSERT_TRUE(gfx::UpdateTextureNow(texture, 0, 0, 0, kTextureWidth, kTextureHeight, texels.data()));

    mgCMemory        memory;
    sceVif1Packet    vif_packet{};
    mgRENDER_INFO    render_info{};
    mgCDrawManager   manager;
    mgCDrawPrim      prim;
    mgCTexture       source;
    prim.draw_manager = &manager;
    manager.render_info = &render_info;
    prim.Initialize(&memory, &vif_packet);
    prim.write = nullptr;

    PrimSinkReset sink_reset;
    int           sprites = 0;
    mgPortSetPrimSink([texture, &sprites](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                          const gfx::TextureBinding &binding, const gfx::DrawState &state) {
        EXPECT_EQ(binding.filter, gfx::Filter::Nearest);
        gfx::TextureBinding bound = binding;
        bound.texture = texture;
        gfx::Draw2D(primitive, vertices, bound, state);
        sprites++;
    });

    gfx.Frame({0x00, 0x00, 0x00, 0xFF}, [&] {
        DrawTexturedSprite(prim, source, {15.0f, 0.0f, 47.0f, 8.0f}, {32, 0, 64, 8});
        DrawTexturedSprite(prim, source, {47.0f, 0.0f, 79.0f, 8.0f}, {32, 0, 64, 8});
    });

    ASSERT_EQ(sprites, 2);

    uint32_t green = 0;
    uint32_t red = 0;
    uint32_t first_red_x = 0;
    uint32_t first_red_y = 0;
    for (uint32_t y = 0; y < gfx.height; ++y) {
        for (uint32_t x = 0; x < gfx.width; ++x) {
            const std::array<uint8_t, 4> p = gfx.Pixel(x, y);
            if (p[0] >= 0x80 && p[1] < 0x80) {
                if (red++ == 0) {
                    first_red_x = x;
                    first_red_y = y;
                }
            } else if (p[1] >= 0x80 && p[0] < 0x80) {
                green++;
            }
        }
    }
    EXPECT_EQ(red, 0u) << "first red pixel at window " << first_red_x << "," << first_red_y;
    EXPECT_GT(green, 0u);
}

TEST(MgDrawPrimRender, LinearAtlasCellsKeepTopOutlinesWithoutSamplingTheNextCell) {
    dc::test::GfxFixture gfx(160, 120, 1.0f, true, 64, 48);
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    ASSERT_FLOAT_EQ(mapping.scale_x, 2.5f);
    ASSERT_FLOAT_EQ(mapping.scale_y, 2.5f);

    constexpr uint32_t            width = 16;
    constexpr uint32_t            height = 64;
    const std::array<uint32_t, 4> palette = {
        dc::test::Rgba(0, 0, 0, 0), dc::test::Rgba(0, 0, 0),
        dc::test::Rgba(255, 0, 0), dc::test::Rgba(0, 255, 0),
    };
    std::vector<uint8_t> indices(width * height);
    std::vector<uint32_t> rgba(width * height);
    for (int top : {2, 22, 42}) {
        for (int y = top + 1; y <= top + 9; ++y) {
            for (int x = 2; x < 10; ++x) {
                // One transparent row before the outline, three after the artwork,
                // then a bright sentinel representing the next cell's outline.
                indices[y * width + x] = y == top + 1 ? 1 : y <= top + 5 ? 2 : y == top + 9 ? 3 : 0;
            }
        }
    }
    for (size_t i = 0; i < indices.size(); ++i) {
        rgba[i] = palette[indices[i]];
    }
    const auto color = gfx::CreateTexture({.width = width, .height = height, .format = gfx::TextureFormat::Rgba8});
    const auto index = gfx::CreateTexture({.width = width, .height = height, .format = gfx::TextureFormat::Index8});
    const auto clut = gfx::CreatePalette();
    ASSERT_NE(color, gfx::kNullTexture);
    ASSERT_NE(index, gfx::kNullTexture);
    ASSERT_NE(clut, gfx::kNullTexture);
    ASSERT_TRUE(gfx::UpdateTextureNow(color, 0, 0, 0, width, height, rgba.data()));
    ASSERT_TRUE(gfx::UpdateTextureNow(index, 0, 0, 0, width, height, indices.data()));
    ASSERT_TRUE(gfx::UpdatePalette(clut, palette.data(), 0, palette.size()));

    mgCMemory memory;
    sceVif1Packet packet{};
    mgRENDER_INFO info{};
    mgCDrawManager manager;
    mgCDrawPrim prim;
    prim.draw_manager = &manager;
    manager.render_info = &info;
    prim.Initialize(&memory, &packet);
    prim.write = nullptr;
    prim.Coord(1);
    prim.TextureMapEnable(1);
    prim.Bilinear(1);
    mgCTexture source;
    prim.Texture(&source);
    PrimSinkReset reset;

    for (int top : {2, 22, 42}) {
        std::vector<uint8_t> reference;
        for (bool indexed : {false, true}) {
            mgPortSetPrimSink([&](gfx::Primitive kind, std::span<const gfx::Vertex2D> vertices,
                                  const gfx::TextureBinding &binding, const gfx::DrawState &) {
                EXPECT_EQ(binding.filter, gfx::Filter::Linear);
                gfx::TextureBinding texture = binding;
                texture.texture = indexed ? index : color;
                texture.palette = indexed ? clut : gfx::kNullTexture;
                texture.ignore_alpha = false;
                gfx::DrawState state;
                state.blend = true;
                state.depth_test = gfx::DepthTest::Always;
                state.depth_write = false;
                gfx::Draw2D(kind, vertices, texture, state);
            });
            gfx.Frame({255, 255, 255, 255}, [&] {
                prim.Begin(MG_PRIM_SPRITE);
                prim.Color(128, 128, 128, 128);
                PrimQuad(&prim, 3.0f, 4.0f, {2, top, 8, 8});
                prim.End2();
            });
            SCOPED_TRACE(testing::Message() << "atlas row " << top << ", indexed " << indexed);
            EXPECT_TRUE(gfx.PixelNear(17, 13, 153, 153, 153, 3)); // GS integer-location top outline
            EXPECT_TRUE(gfx.PixelNear(17, 20, 255, 0, 0, 3)); // artwork
            EXPECT_TRUE(gfx.PixelNear(17, 29, 255, 255, 255, 3)); // transparent bottom gutter
            if (!indexed) {
                reference = gfx.pixels;
            } else {
                ASSERT_EQ(gfx.pixels.size(), reference.size());
                for (size_t i = 0; i < reference.size(); ++i) {
                    ASSERT_LE(std::abs(int(gfx.pixels[i]) - int(reference[i])), 2) << "byte " << i;
                }
            }
        }
    }
    gfx::DestroyTexture(color);
    gfx::DestroyTexture(index);
    gfx::DestroyTexture(clut);
}
