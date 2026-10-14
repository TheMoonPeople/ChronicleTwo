#include <gtest/gtest.h>

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <string>
#include <vector>

#include "common.h"
#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "menudraw.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"

using namespace dc::test;

namespace {

constexpr int    kBlock = 2;
constexpr size_t kStackQuads = 0x4000;
constexpr int    kTableTextures = 64;
constexpr int    kTableBlocks = 8;
constexpr size_t kTableQuads = 4096;

// Same bring-up as mglib_frame_test.cpp: a 512x480 logical frame on the offscreen renderer.
class OffscreenRenderer {
public:
    OffscreenRenderer() {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
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
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("menudraw_grab_" + std::to_string(ProcessId()) + ".bin");
        gfx::RendererInit(WindowHandle(), config);

        ClockSetUnbounded(true);
        mgInit(MG_SCREEN_MODE_512X480, 3);
    }

    ~OffscreenRenderer() {
        gfx::RendererShutdown();
        WindowShutdown();
        EXPECT_EQ(gfx::ValidationMessageCount(), 0u);
    }
};

// Declared after the renderer in each test so its textures are released while the renderer is still up.
class TextureTable {
public:
    TextureTable() : storage(kTableQuads, 0) {
        memory.stSetBuffer(storage.data(), static_cast<int>(kTableQuads));
        mgTexManager.SetTableBuffer(kTableTextures, kTableBlocks, &memory);
        mgTexManager.Initialize(0x1000, -1);
    }

    ~TextureTable() {
        mgTexManager.Initialize(0x1000, -1);
    }

    TextureTable(const TextureTable &) = delete;
    TextureTable &operator=(const TextureTable &) = delete;

private:
    std::vector<u_long128> storage;
    mgCMemory              memory;
};

} // namespace

TEST(MenuDrawGrab, GrabRoundTrip) {
    OffscreenRenderer renderer;
    TextureTable      table;

    std::vector<u_long128> storage(kStackQuads, 0);
    mgCMemory              stack;
    stack.stSetBuffer(storage.data(), static_cast<int>(kStackQuads));

    mgSetBackGround(64.0f, 128.0f, 192.0f, 128.0f);
    mgBeginFrame(nullptr);

    mgCDrawPrim prim;
    prim.Initialize(nullptr, nullptr);
    prim.TextureMapEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(200, 100, 50, 255);
    prim.Vertex(0.0f, 0.0f, 0.0f);
    prim.Vertex(128.0f, 120.0f, 0.0f);
    prim.End();

    EXPECT_TRUE(MenuCapture(kBlock, &stack, 0));
    ASSERT_NE(MenuFrameTex, nullptr);
    EXPECT_EQ(MenuFrameTex->width, 256);
    EXPECT_EQ(MenuFrameTex->height, 256);
    EXPECT_EQ(MenuFrameTex->tex0.bits.tcc, 0);

    // The stack image is only reserved; the fill happens on the GPU, so the bytes stay zero.
    const u8 *image = reinterpret_cast<const u8 *>(MenuFrameTex->image[0]);
    EXPECT_TRUE(std::all_of(image, image + 256 * 240 * 4, [](u8 byte) { return byte == 0; }));

    // Finishes the frame MenuCapture began, which holds the copy.
    mgEndFrame(nullptr);

    const gfx::TextureHandle target = mgPortRenderTarget(MenuFrameTex, true);
    ASSERT_NE(target, gfx::kNullTexture);
    ASSERT_EQ(mgPortFindTexture(MenuFrameTex).texture, target);

    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortReadColor(target, rgba, width, height));

    const auto pixel = [&](uint32_t x, uint32_t y) {
        return &rgba[(static_cast<size_t>(y) * width + x) * 4];
    };

    // The quad covers logical 0..128 x 0..120, which is target 0..64 x 0..60 after the 2:1 minification.
    const uint8_t *inside = pixel(32, 30);
    EXPECT_NEAR(inside[0], 200, 2);
    EXPECT_NEAR(inside[1], 100, 2);
    EXPECT_NEAR(inside[2], 50, 2);

    const uint8_t *outside = pixel(200, 200);
    EXPECT_NEAR(outside[0], 64, 2);
    EXPECT_NEAR(outside[1], 128, 2);
    EXPECT_NEAR(outside[2], 192, 2);
}

// The menus capture with draw set: the reload that draws the grab must keep the target, not the stale stack bytes.
TEST(MenuDrawGrab, DrawnGrabKeepsTarget) {
    OffscreenRenderer renderer;
    TextureTable      table;

    std::vector<u_long128> storage(kStackQuads);
    std::memset(storage.data(), 0xAB, storage.size() * sizeof(u_long128));
    mgCMemory stack;
    stack.stSetBuffer(storage.data(), static_cast<int>(kStackQuads));

    mgSetBackGround(64.0f, 128.0f, 192.0f, 128.0f);
    mgBeginFrame(nullptr);

    mgCDrawPrim prim;
    prim.Initialize(nullptr, nullptr);
    prim.TextureMapEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(200, 100, 50, 255);
    prim.Vertex(0.0f, 0.0f, 0.0f);
    prim.Vertex(128.0f, 120.0f, 0.0f);
    prim.End();

    EXPECT_TRUE(MenuCapture(kBlock, &stack, 1));
    ASSERT_NE(MenuFrameTex, nullptr);
    mgEndFrame(nullptr);

    const gfx::TextureHandle found = mgPortFindTexture(MenuFrameTex).texture;
    ASSERT_EQ(found, mgPortRenderTarget(MenuFrameTex, true));

    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortReadColor(found, rgba, width, height));

    const uint8_t *inside = &rgba[(static_cast<size_t>(30) * width + 32) * 4];
    EXPECT_NEAR(inside[0], 200, 2);
    EXPECT_NEAR(inside[1], 100, 2);
    EXPECT_NEAR(inside[2], 50, 2);
}
