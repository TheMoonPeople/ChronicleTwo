#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <filesystem>
#include <initializer_list>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mainloop_port.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/window.hpp"

using namespace dc::test;

namespace {

class AspectRenderer {
public:
    AspectRenderer(int width, int height) {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{width, height, true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle aspect tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 4.0f / 3.0f;
        config.validation = true;
        config.offscreen = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("mglib_aspect_" + std::to_string(ProcessId()) + ".bin");
        gfx::RendererInit(WindowHandle(), config);

        ClockSetUnbounded(true);
        mgInit(MG_SCREEN_MODE_512X480, 3);
    }

    ~AspectRenderer() {
        gfx::RendererShutdown();
        WindowShutdown();
        EXPECT_EQ(gfx::ValidationMessageCount(), 0u);
    }
};

bool Inside(float x) {
    const mgPortExtent e = mgPortVisibleExtent();
    return x >= e.left && x <= e.right;
}

gfx::Vertex2D QuadCorner(float x, float y) {
    gfx::Vertex2D vertex = {};
    vertex.x = x;
    vertex.y = y;
    vertex.z = 1.0f;
    vertex.color[0] = 0xFF;
    vertex.color[1] = 0xFF;
    vertex.color[2] = 0xFF;
    vertex.color[3] = 0xFF;
    return vertex;
}

// Pixel-snapped edges can land one device pixel off, and a device pixel is 1 / scale logical units.
void ExpectQuadAtLogicalPlace(int width, int height) {
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    mgBeginFrame(nullptr);

    const std::array<gfx::Vertex2D, 4> quad = {
        QuadCorner(100.0f, 200.0f),
        QuadCorner(164.0f, 200.0f),
        QuadCorner(164.0f, 264.0f),
        QuadCorner(100.0f, 264.0f),
    };
    mgPortDraw2D(gfx::Primitive::Quads, quad, gfx::TextureBinding{}, mgPortDrawState());

    mgEndFrame(nullptr);

    std::vector<uint8_t> rgba;
    uint32_t             out_width = 0;
    uint32_t             out_height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, out_width, out_height));
    EXPECT_EQ(static_cast<int>(out_width), width);
    EXPECT_EQ(static_cast<int>(out_height), height);

    uint32_t min_x = out_width;
    uint32_t max_x = 0;
    uint32_t min_y = out_height;
    uint32_t max_y = 0;
    for (uint32_t y = 0; y < out_height; ++y) {
        for (uint32_t x = 0; x < out_width; ++x) {
            const uint8_t *p = &rgba[(static_cast<size_t>(y) * out_width + x) * 4];
            if (p[0] > 200 && p[1] > 200 && p[2] > 200) {
                min_x = std::min(min_x, x);
                max_x = std::max(max_x, x);
                min_y = std::min(min_y, y);
                max_y = std::max(max_y, y);
            }
        }
    }
    ASSERT_LE(min_x, max_x);
    ASSERT_LE(min_y, max_y);

    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    const double tol_x = std::max<double>(1.0, 1.0 / mapping.scale_x);
    const double tol_y = std::max<double>(1.0, 1.0 / mapping.scale_y);

    const double left = (static_cast<double>(min_x) - mapping.offset_x) / mapping.scale_x;
    const double right = (static_cast<double>(max_x + 1) - mapping.offset_x) / mapping.scale_x;
    const double top = (static_cast<double>(min_y) - mapping.offset_y) / mapping.scale_y;
    const double bottom = (static_cast<double>(max_y + 1) - mapping.offset_y) / mapping.scale_y;

    EXPECT_NEAR(left, 100.0, tol_x);
    EXPECT_NEAR(right, 164.0, tol_x);
    EXPECT_NEAR(top, 200.0, tol_y);
    EXPECT_NEAR(bottom, 264.0, tol_y);
}

} // namespace

TEST(MglibAspect, LogicalScreenAt640x480) {
    AspectRenderer renderer(640, 480);

    EXPECT_EQ(mgScreenWidth, 512);
    EXPECT_EQ(mgScreenHeight, 480);

    mgBeginFrame(nullptr);
    mgEndFrame(nullptr);

    EXPECT_EQ(mgScreenWidth, 512);
    EXPECT_EQ(mgScreenHeight, 480);
}

TEST(MglibAspect, LogicalScreenAt1280x720) {
    AspectRenderer renderer(1280, 720);

    EXPECT_EQ(mgScreenWidth, 512);
    EXPECT_EQ(mgScreenHeight, 480);

    mgBeginFrame(nullptr);
    mgEndFrame(nullptr);

    EXPECT_EQ(mgScreenWidth, 512);
    EXPECT_EQ(mgScreenHeight, 480);
}

TEST(MglibAspect, LogicalScreenAt800x1200) {
    AspectRenderer renderer(800, 1200);

    EXPECT_EQ(mgScreenWidth, 512);
    EXPECT_EQ(mgScreenHeight, 480);

    mgBeginFrame(nullptr);
    mgEndFrame(nullptr);

    EXPECT_EQ(mgScreenWidth, 512);
    EXPECT_EQ(mgScreenHeight, 480);
}

TEST(MglibAspect, ExtentIsScreenAtFourThree) {
    AspectRenderer renderer(1024, 768);

    const mgPortExtent e = mgPortVisibleExtent();
    EXPECT_NEAR(e.left, 0.0f, 0.01f);
    EXPECT_NEAR(e.right, 512.0f, 0.01f);
    EXPECT_NEAR(e.top, 0.0f, 0.01f);
    EXPECT_NEAR(e.bottom, 480.0f, 0.01f);
    EXPECT_NEAR(e.half_width, 256.0f, 0.01f);
    EXPECT_NEAR(e.half_height, 240.0f, 0.01f);

    EXPECT_EQ(mgScreenOffx, 2048 - 256);
    EXPECT_FLOAT_EQ(e.gs_left, static_cast<float>(mgScreenOffx));
    EXPECT_FLOAT_EQ(e.gs_right, static_cast<float>(mgScreenOffx) + 512.0f);
}

TEST(MglibAspect, ExtentIsWiderAtSixteenNine) {
    AspectRenderer renderer(1280, 720);

    const mgPortExtent e = mgPortVisibleExtent();
    EXPECT_LT(e.left, -40.0f);
    EXPECT_GT(e.right, 552.0f);
    EXPECT_NEAR(e.top, 0.0f, 0.5f);
    EXPECT_NEAR(e.bottom, 480.0f, 0.5f);
    EXPECT_GT(e.half_width, 296.0f);
    EXPECT_NEAR(e.half_height, 240.0f, 0.5f);

    EXPECT_TRUE(-40.0f >= e.left && -40.0f <= e.right);
}

TEST(MglibAspect, ExtentKeepsWidthWhenNarrow) {
    AspectRenderer renderer(800, 1200);

    const mgPortExtent e = mgPortVisibleExtent();
    EXPECT_NEAR(e.left, 0.0f, 0.5f);
    EXPECT_NEAR(e.right, 512.0f, 0.5f);
    EXPECT_LT(e.top, 0.0f);
    EXPECT_GT(e.bottom, 480.0f);
}

TEST(MglibAspect, CullAtMinusFortyWhenWider) {
    AspectRenderer renderer(1280, 720);

    EXPECT_TRUE(Inside(-40.0f));
}

TEST(MglibAspect, CullAtMinusFortyAtFourThree) {
    AspectRenderer renderer(1024, 768);

    EXPECT_FALSE(Inside(-40.0f));
}

TEST(MglibAspect, QuadAtSameLogicalPlaceAt1280x720) {
    AspectRenderer renderer(1280, 720);
    ExpectQuadAtLogicalPlace(1280, 720);
}

TEST(MglibAspect, QuadAtSameLogicalPlaceAt3840x2160) {
    AspectRenderer renderer(3840, 2160);
    ExpectQuadAtLogicalPlace(3840, 2160);
}

TEST(MglibAspect, QuadAtSameLogicalPlaceAt800x1200) {
    AspectRenderer renderer(800, 1200);
    ExpectQuadAtLogicalPlace(800, 1200);
}

TEST(MglibAspect, FrameBorderStaysAtVisibleEdges) {
    AspectRenderer renderer(1920, 1080);
    mgSetBackGround(200, 150, 100, 128);
    mgBeginFrame(nullptr);
    PortDrawFrameBorder();
    mgEndFrame(nullptr);
    std::vector<uint8_t> rgba;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    ASSERT_EQ(width, 1920u);
    ASSERT_EQ(height, 1080u);
    // Both old 4:3 boundaries are interior pixels of the expanded scene.
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    for (float edge : {0.0f, 511.0f}) {
        const int x = static_cast<int>(mapping.offset_x + edge * mapping.scale_x);
        for (int dx = -2; dx <= 2; ++dx) {
            const auto index = (static_cast<size_t>(height / 2) * width + x + dx) * 4;
            EXPECT_GT(rgba[index], 190) << "black seam at " << x + dx;
        }
    }
}

// The menu backdrop is 704 pixels wide and slides left by 192 pixels for the
// item page. Its lens at texture x=350 must land at logical x=158, alongside
// the model, even though the backdrop covers the entire logical frame.
static void ExpectMenuLensAtRetailPosition(int window_width, int window_height) {
    AspectRenderer         renderer(window_width, window_height);
    std::vector<u_long128> arena(4096), pixels(1024 * 512 * 4 / 16), ornament(64 * 64 * 4 / 16);
    mgCMemory              memory;
    memory.stSetBuffer(arena.data(), static_cast<int>(arena.size()));
    mgTexManager.SetTableBuffer(16, 4, &memory);
    mgTexManager.Initialize(0x1000, -1);
    auto *rgba = reinterpret_cast<uint8_t *>(pixels.data());
    for (int y = 0; y < 416; ++y) {
        for (int x = 0; x < 704; ++x) {
            rgba[(y * 1024 + x) * 4 + 3] = 255;
            if (x >= 600) {
                rgba[(y * 1024 + x) * 4 + 1] = 255;
            }
        }
    }
    for (int y = 204; y < 212; ++y) {
        for (int x = 346; x < 354; ++x) {
            rgba[(y * 1024 + x) * 4] = 255;
            rgba[(y * 1024 + x) * 4 + 3] = 255;
        }
    }
    u_long128 *levels[MG_TEXTURE_LEVEL_MAX] = {pixels.data()};
    char       background_name[] = "bg16", ornament_name[] = "mnmain";
    ASSERT_NE(mgTexManager.EnterTexture(0, background_name, levels, 1024, 512, 32, nullptr, 0, 0), nullptr);
    levels[0] = ornament.data();
    ASSERT_NE(mgTexManager.EnterTexture(0, ornament_name, levels, 64, 64, 32, nullptr, 0, 0), nullptr);
    MenuMainFrameModeSet(MENU_MAIN_FRAME_OPEN, 1);
    for (int i = 0; i < 30; ++i) {
        MenuMainFrameStep();
    }
    MenuMainFrameModeSet(MENU_MAIN_FRAME_SLIDE_LEFT, 1);
    for (int i = 0; i < 30; ++i) {
        MenuMainFrameStep();
    }
    ASSERT_EQ(MenuMainFrame_PutRect.left, -192);

    mgSetBackGround(0, 0, 0, 128);
    mgBeginFrame(nullptr);
    int loaded_texture = -1;
    MenuMainFrameDraw(loaded_texture, 128);
    mgEndFrame(nullptr);
    std::vector<uint8_t> image;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, image, width, height));
    uint32_t min_x = width, max_x = 0, min_y = height, max_y = 0;
    for (uint32_t y = 0; y < height; ++y) {
        for (uint32_t x = 0; x < width; ++x) {
            if (image[(static_cast<size_t>(y) * width + x) * 4] > 200) {
                min_x = std::min(min_x, x);
                max_x = std::max(max_x, x);
                min_y = std::min(min_y, y);
                max_y = std::max(max_y, y);
            }
        }
    }
    ASSERT_LE(min_x, max_x);
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    EXPECT_NEAR(((min_x + max_x + 1) * 0.5f - mapping.offset_x) / mapping.scale_x, 158.0f, 1.0f);
    EXPECT_NEAR(((min_y + max_y + 1) * 0.5f - mapping.offset_y) / mapping.scale_y, 240.0f, 1.0f);
    // The continuation uses the artwork near the right edge, while the lens
    // and all interior artwork stay in place.
    EXPECT_GT(image[(static_cast<size_t>(height / 2) * width + width - 2) * 4 + 1], 200);
    mgTexManager.Initialize(0x1000, -1);
}

TEST(MglibAspect, ItemMenuLensStaysWithModelAtSixteenNine) {
    ExpectMenuLensAtRetailPosition(1920, 1080);
}

TEST(MglibAspect, ItemMenuLensStaysWithModelAtFourThree) {
    ExpectMenuLensAtRetailPosition(640, 480);
}

TEST(MglibAspect, MenuFormsHideParkedStatsWithoutClippingEnteringPanel) {
    AspectRenderer     renderer(1920, 1080);
    CMenuPosDataManage layout{};
    auto              *saved_layout = MenuPosData;
    MenuPosData = &layout;
    MENU_BASETEXINFO texture_info{};
    layout.tex_info = &texture_info;
    layout.tex_info_num = 1;
    MENU_PARTS_EFFECT_STRUCT1 fill{};
    fill.param[0] = 20;
    fill.param[1] = 220;
    fill.param[2] = 30;
    fill.param[3] = 128;
    MENUFORMPARTS_TYPE parts[2]{};
    auto              &part = parts[0];
    part.active = part.draw_flag = 1;
    part.dtype = MENUFORMPARTS_DTYPE_SQ_BETA;
    // Retail SPECHECK comparison panel is 236x164, parked at -260 and shown at 7.
    part.w = 236;
    part.h = 164;
    part.effect = &fill;
    CMenuPosDataForm form{};
    form.active = form.draw_flag = 1;
    form.rgba[3] = 128;
    form.dtype = MENUFORM_DTYPE_NORMAL;
    form.y = 296;
    MENU_PARTS_EFFECT_STRUCT1 icon_effect{};
    icon_effect.type = MENU_PARTS_EFFECT_ICON_COUNTER;
    parts[1].active = parts[1].draw_flag = 1;
    parts[1].dtype = MENUFORMPARTS_DTYPE_TRS;
    parts[1].w = 28;
    parts[1].h = 35;
    parts[1].effect = &icon_effect;
    parts[1].effect_num = 1;
    form.parts = parts;
    form.parts_num = 2;
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    for (float x : {-260.0f, -80.0f, 7.0f, 470.0f, 530.0f}) {
        form.x = x;
        mgSetBackGround(200, 150, 100, 128);
        mgBeginFrame(nullptr);
        int state = -1;
        form.MenuFormDraw(state);
        // A following independent draw must still reach the wide flank.
        auto             a = QuadCorner(-75, 50), b = QuadCorner(-50, 50);
        auto             c = QuadCorner(-50, 75), d = QuadCorner(-75, 75);
        const std::array outside{a, b, c, d};
        gfx::DrawState   outside_state{};
        outside_state.depth_test = gfx::DepthTest::Always;
        outside_state.depth_write = false;
        mgPortDraw2D(gfx::Primitive::Quads, outside, {}, outside_state);
        mgEndFrame(nullptr);
        std::vector<uint8_t> rgba;
        uint32_t             width = 0, height = 0;
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
        const auto pixel = [&](float px, float py, int channel) {
            const int sx = static_cast<int>(mapping.offset_x + px * mapping.scale_x);
            const int sy = static_cast<int>(mapping.offset_y + py * mapping.scale_y);
            return rgba[(static_cast<size_t>(sy) * width + sx) * 4 + channel];
        };
        if (x == -260) {
            EXPECT_GT(pixel(-50, 350, 0), 190) << "parked panel leaks";
        }
        if (x == -80) {
            EXPECT_GT(pixel(-50, 350, 1), 200) << "entering panel clipped to logical frame";
        }
        if (x >= -80 && x <= 7) {
            EXPECT_GT(pixel(40, 350, 1), 200) << "active/entering panel lost";
        }
        if (x == 470) {
            EXPECT_GT(pixel(550, 350, 1), 200) << "entering panel clipped on right";
        }
        if (x == 530) {
            EXPECT_GT(pixel(550, 350, 0), 190) << "right parked panel leaks";
        }
        if (x == 7) {
            EXPECT_GT(pixel(8, 350, 1), 200);
            EXPECT_GT(pixel(242, 350, 1), 200);
        }
        EXPECT_GT(pixel(-60, 60, 0), 240) << "form clip leaked to following draw";
    }
    // The same form mechanism also carries full-screen fills: those still cover Fill's sides.
    form.x = form.y = 0;
    part.w = 512;
    part.h = 480;
    mgSetBackGround(200, 150, 100, 128);
    mgBeginFrame(nullptr);
    int state = -1;
    form.MenuFormDraw(state);
    mgEndFrame(nullptr);
    std::vector<uint8_t> rgba;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    EXPECT_GT(rgba[(static_cast<size_t>(height / 2) * width + 100) * 4 + 1], 200);
    MenuPosData = saved_layout;
}

static void ExpectMenuBackdropContinuation(int window_width, int window_height, int page = 0, std::initializer_list<int> y_offsets = {0}) {
    const bool             character = page == 1, invent = page == 2, options = page == 3;
    AspectRenderer         renderer(window_width, window_height);
    std::vector<u_long128> arena(4096), pixels(1024 * 1024 * 4 / 16);
    mgCMemory              memory;
    memory.stSetBuffer(arena.data(), static_cast<int>(arena.size()));
    mgTexManager.SetTableBuffer(16, 4, &memory);
    mgTexManager.Initialize(0x1000, -1);
    auto *bytes = reinterpret_cast<uint8_t *>(pixels.data());
    // Distinct interior columns distinguish real continuation from a stretched
    // edge texel. Black is the uncovered target, not part of this texture.
    const int artwork_width = page ? 512 : 700;
    const int uv_width = character ? 513 : (invent || options) ? 512
                                                               : 704;
    const int uv_height = character ? 768 : options ? 448
                                                    : 416;
    const int uv_top = invent ? 48 : options ? 46
                                             : 0;
    const int dest_width = invent ? 522 : uv_width;
    for (int y = uv_top; y < uv_top + uv_height; ++y) {
        for (int x = 0; x < artwork_width; ++x) {
            bytes[(y * 1024 + x) * 4] = 80;
            bytes[(y * 1024 + x) * 4 + 1] = 20 + x / 3;
            bytes[(y * 1024 + x) * 4 + 3] = 255;
        }
    }
    u_long128 *levels[MG_TEXTURE_LEVEL_MAX] = {pixels.data()};
    char       name[] = "bg16", character_name[] = "chr_bg", invent_name[] = "inv_bg", options_name[] = "op_bg";
    auto      *texture = mgTexManager.EnterTexture(0, character ? character_name : invent ? invent_name
                                                                               : options  ? options_name
                                                                                          : name,
                                                   levels, 1024, 1024, 32, nullptr, 0, 0);
    ASSERT_NE(texture, nullptr);
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    // Horizontal entrance/return poses, including both edges away from their settled sides.
    const std::vector<int> positions = character ? std::vector<int>{-400, -256, -80, -2, 0, 128, 400} : invent ? std::vector<int>{1}
                                                                                                    : options  ? std::vector<int>{-240, 0, 240}
                                                                                                               : std::vector<int>{0, -48, -96, -144, -192, 128, 400};
    for (int y_offset : y_offsets) {
        SCOPED_TRACE(y_offset);
        for (int left : positions) {
            SCOPED_TRACE(left);
            mgSetBackGround(0, 0, 0, 128);
            mgBeginFrame(nullptr);
            mgCDrawPrim prim;
            SetSpriteEnv(&prim, MENU_SPRITE_ENV_TEXTURE);
            prim.Bilinear(1);
            prim.Begin(MG_PRIM_SPRITE);
            prim.Texture(texture);
            prim.Color(128, 128, 128, 128);
            if (character) {
                PrimQuad(&prim, mgRect<float>(left, -315, 513, 883), mgRect<int>(0, 0, uv_width, uv_height));
            } else if (options) {
                PrimQuad(&prim, mgRect<float>(left, -8 + y_offset, 512, 502), mgRect<int>(0, uv_top, uv_width, uv_height));
            } else if (invent) {
                PrimQuad(&prim, mgRect<float>(left, 0, 522, 481), mgRect<int>(0, uv_top, uv_width, uv_height));
            } else {
                PrimQuad(&prim, mgRect<int>(left, 0, 704, 480), mgRect<int>(0, 0, uv_width, uv_height));
            }
            prim.End();
            mgEndFrame(nullptr);
            std::vector<uint8_t> rgba;
            uint32_t             width = 0, height = 0;
            ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
            for (float x : {-80.0f, -40.0f, 40.0f, 470.0f, 511.0f, 513.0f, 550.0f, 590.0f}) {
                const int   sx = static_cast<int>(mapping.offset_x + x * mapping.scale_x);
                const float logical_x = (sx + 0.5f - mapping.offset_x) / mapping.scale_x;
                float       u = (logical_x - left) * uv_width / dest_width;
                const auto  offset = (static_cast<size_t>(height / 2) * width + sx) * 4;
                if (options && (240 < -8 + y_offset || 240 >= 494 + y_offset)) {
                    EXPECT_EQ(rgba[offset], 0) << "vertical slide lost its current position at x=" << x;
                    continue;
                }
                // Reflection belongs only in the flanks: the field exposed inside
                // the retail frame during a horizontal slide must remain visible.
                if (logical_x >= 0 && logical_x < 512 && ((u < 0 && left > 2) || (u > uv_width && left + dest_width < 510))) {
                    EXPECT_EQ(rgba[offset], 0) << "reflection changed the retail slide at x=" << x;
                    continue;
                }
                if (u < 0) {
                    u = -u;
                }
                if (u > artwork_width) {
                    u = 2 * artwork_width - u;
                }
                EXPECT_NEAR(rgba[offset + 1], 20 + static_cast<int>(u) / 3, 2) << "x=" << x;
                EXPECT_GT(rgba[offset], 70) << "bare flank at x=" << x;
            }
            // Bilinear filtering at either join must not sample transparent padding.
            if (!options || (240 >= -8 + y_offset && 240 < 494 + y_offset)) {
                for (float edge : {static_cast<float>(left), left + static_cast<float>(artwork_width) * dest_width / uv_width}) {
                    const int sx = static_cast<int>(mapping.offset_x + edge * mapping.scale_x);
                    for (int dx = -2; dx <= 2; ++dx) {
                        if (sx + dx < 0 || sx + dx >= static_cast<int>(width)) {
                            continue;
                        }
                        const float join_x = (sx + dx + 0.5f - mapping.offset_x) / mapping.scale_x;
                        if (join_x >= 0 && join_x < 512 &&
                            (join_x < left || join_x > left + static_cast<float>(artwork_width) * dest_width / uv_width)) {
                            continue;
                        }
                        EXPECT_GT(rgba[(static_cast<size_t>(height / 2) * width + sx + dx) * 4], 70);
                    }
                }
            }
        }
    }
    mgTexManager.Initialize(0x1000, -1);
}

TEST(MglibAspect, MenuBackdropContinuesArtworkAt1920x1080) {
    ExpectMenuBackdropContinuation(1920, 1080);
}

TEST(MglibAspect, MenuBackdropContinuesArtworkAt3840x2160) {
    ExpectMenuBackdropContinuation(3840, 2160);
}

TEST(MglibAspect, CharacterBackdropContinuesArtworkAt1920x1080) {
    ExpectMenuBackdropContinuation(1920, 1080, true);
}

TEST(MglibAspect, CharacterBackdropContinuesArtworkAt3840x2160) {
    ExpectMenuBackdropContinuation(3840, 2160, true);
}

TEST(MglibAspect, InventBackdropContinuesArtworkAt1920x1080) {
    ExpectMenuBackdropContinuation(1920, 1080, 2);
}

TEST(MglibAspect, InventBackdropContinuesArtworkAt3840x2160) {
    ExpectMenuBackdropContinuation(3840, 2160, 2);
}

namespace {
void ExpectMenuTilesCoverWindow(int width, int height) {
    AspectRenderer renderer(width, height);
    const auto     extent = mgPortVisibleExtent();
    mgCMemory      memory;
    sceVif1Packet  packet{};
    mgRENDER_INFO  info{};
    mgCDrawManager manager;
    manager.render_info = &info;
    mgCDrawPrim prim;
    prim.draw_manager = &manager;
    prim.Initialize(&memory, &packet);
    prim.write = nullptr;
    prim.Coord(1);
    for (float scroll : {-1.0f, -127.5f, -255.0f, 40.5f}) {
        float left = 1e9f, top = 1e9f, right = -1e9f, bottom = -1e9f;
        mgPortSetPrimSink([&](gfx::Primitive, std::span<const gfx::Vertex2D> vertices,
                              const gfx::TextureBinding &, const gfx::DrawState &) {
            for (const auto &v : vertices) {
                left = std::min(left, v.x);
                right = std::max(right, v.x);
                top = std::min(top, v.y);
                bottom = std::max(bottom, v.y);
            }
        });
        DrawMenuTilePattern(&prim, nullptr, scroll, scroll, {0, 0, 128, 128}, 0, nullptr);
        mgPortSetPrimSink({});
        EXPECT_LE(left, extent.left) << scroll;
        EXPECT_LE(top, extent.top) << scroll;
        EXPECT_GE(right, extent.right) << scroll;
        EXPECT_GE(bottom, extent.bottom) << scroll;
        // Integral sprite coordinates retain the retail truncation of fractional scroll.
        EXPECT_LE(left, 0);
        EXPECT_LE(top, 0);
    }
}
} // namespace

TEST(MglibAspect, MenuTilesCoverThirtyTwoNineWithFractionalScroll) {
    ExpectMenuTilesCoverWindow(2560, 720);
}

TEST(MglibAspect, MenuTilesCoverNarrowPortraitWithFractionalScroll) {
    ExpectMenuTilesCoverWindow(320, 1280);
}

TEST(MglibAspect, MenuTilesKeepFourThreeCoverageWithFractionalScroll) {
    ExpectMenuTilesCoverWindow(640, 480);
}

TEST(MglibAspect, OptionsAndHelpBackdropContinueArtworkAt1920x1080) {
    ExpectMenuBackdropContinuation(1920, 1080, 3);
}

TEST(MglibAspect, OptionsAndHelpBackdropContinueArtworkAt3840x2160) {
    ExpectMenuBackdropContinuation(3840, 2160, 3);
}

TEST(MglibAspect, OptionsAndHelpFlanksFollowVerticalSlide) {
    ExpectMenuBackdropContinuation(1920, 1080, 3, {-480, -240, 80, 240, 480});
}
