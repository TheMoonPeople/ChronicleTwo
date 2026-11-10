#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <initializer_list>
#include <memory>
#include <set>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "menu_mouse.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object/menu/menu_presentation.hpp"
#include "options/screen.hpp"
#include "platform/clock.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/input.hpp"
#include "platform/window.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "scoped_global_object.hpp"

// dngmenu.hpp and font.hpp bring libgraph.h, whose register macros must follow the host and test headers.
// clang-format off
#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "font.hpp"
// clang-format on

using namespace dc::test;

namespace {

class AspectRenderer {
public:
    AspectRenderer(int width, int height) {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{.width = width, .height = height, .headless = true};
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

/**
 * Writes a captured canonical frame for a failed graphics assertion.
 */
void WriteFailureFrame(const std::string &suffix, const std::vector<uint8_t> &rgba, uint32_t width, uint32_t height) {
    const char *capture = std::getenv("DC2_CAPTURE_DIR");
    const auto  directory = capture ? std::filesystem::path(capture) : std::filesystem::path("Testing/Temporary/metal-pixels");
    std::filesystem::create_directories(directory);
    const auto *test = testing::UnitTest::GetInstance()->current_test_info();
    const auto  name = std::string(test->name()) + "_" + suffix + ".png";
    EXPECT_TRUE(gfx::WritePng(directory / name, rgba.data(), width, height));
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
    const double              tol_x = std::max<double>(1.0, 1.0 / mapping.scale_x);
    const double              tol_y = std::max<double>(1.0, 1.0 / mapping.scale_y);

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
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    ASSERT_EQ(width, 1920u);
    ASSERT_EQ(height, 1080u);
    // Both 4:3 frame boundaries are interior pixels of the expanded scene.
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    for (float edge : {0.0f, 511.0f}) {
        const int x = static_cast<int>(mapping.offset_x + edge * mapping.scale_x);
        for (int dx = -2; dx <= 2; ++dx) {
            const auto index = (static_cast<size_t>(height / 2) * width + x + dx) * 4;
            EXPECT_GT(rgba[index], 190) << "black seam at " << x + dx;
        }
    }
}

namespace {
// The menu backdrop is 704 pixels wide and slides left by 192 pixels for the
// item page. Its lens at texture x=350 must land at logical x=158, alongside
// the model, even though the backdrop covers the entire logical frame.
void ExpectMenuLensAtRetailPosition(int window_width, int window_height) {
    AspectRenderer         renderer(window_width, window_height);
    std::vector<u_long128> arena(4096);
    std::vector<u_long128> pixels(1024 * 512 * 4 / 16);
    std::vector<u_long128> ornament(64 * 64 * 4 / 16);
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
    char       background_name[] = "bg16";
    char       ornament_name[] = "mnmain";
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
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, image, width, height));
    uint32_t min_x = width;
    uint32_t max_x = 0;
    uint32_t min_y = height;
    uint32_t max_y = 0;
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
} // namespace

TEST(MglibAspect, ItemMenuLensStaysWithModelAtSixteenNine) {
    ExpectMenuLensAtRetailPosition(1920, 1080);
}

TEST(MglibAspect, ItemMenuLensStaysWithModelAtFourThree) {
    ExpectMenuLensAtRetailPosition(640, 480);
}

TEST(MglibAspect, MenuFormsHideParkedStatsWithoutClippingEnteringPanel) {
    AspectRenderer                             renderer(1920, 1080);
    dc2::test::ScopedGlobalObject<MenuPosData> layout_owner;
    auto                                      &layout = layout_owner.Get();
    MENU_BASETEXINFO                           texture_info{};
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
        auto             a = QuadCorner(-75, 50);
        auto             b = QuadCorner(-50, 50);
        auto             c = QuadCorner(-50, 75);
        auto             d = QuadCorner(-75, 75);
        const std::array outside{a, b, c, d};
        gfx::DrawState   outside_state{};
        outside_state.depth_test = gfx::DepthTest::Always;
        outside_state.depth_write = false;
        mgPortDraw2D(gfx::Primitive::Quads, outside, {}, outside_state);
        mgEndFrame(nullptr);
        std::vector<uint8_t> rgba;
        uint32_t             width = 0;
        uint32_t             height = 0;
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
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    EXPECT_GT(rgba[(static_cast<size_t>(height / 2) * width + 100) * 4 + 1], 200);
}

TEST(MglibAspect, MenuFormsKeepParkedBackdropSliverToScreen) {
    AspectRenderer                             renderer(1920, 1080);
    dc2::test::ScopedGlobalObject<MenuPosData> layout_owner;
    auto                                      &layout = layout_owner.Get();
    MENU_BASETEXINFO                           texture_info{};
    layout.tex_info = &texture_info;
    layout.tex_info_num = 1;
    MENU_PARTS_EFFECT_STRUCT1 fill{};
    fill.param[1] = 220;
    fill.param[3] = 128;
    MENUFORMPARTS_TYPE part{};
    part.active = part.draw_flag = 1;
    part.dtype = MENUFORMPARTS_DTYPE_SQ_BETA;
    // The character page's backdrop is 513 wide and rests at x=-512 until it slides in.
    part.w = 513;
    part.h = 480;
    part.effect = &fill;
    CMenuPosDataForm form{};
    form.active = form.draw_flag = 1;
    form.rgba[3] = 128;
    form.dtype = MENUFORM_DTYPE_NORMAL;
    form.parts = &part;
    form.parts_num = 1;
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    for (float x : {-512.0f, -400.0f}) {
        form.x = x;
        mgSetBackGround(200, 150, 100, 128);
        mgBeginFrame(nullptr);
        int state = -1;
        form.MenuFormDraw(state);
        mgEndFrame(nullptr);
        std::vector<uint8_t> rgba;
        uint32_t             width = 0;
        uint32_t             height = 0;
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
        const auto pixel = [&](float px, float py, int channel) {
            const int sx = static_cast<int>(mapping.offset_x + px * mapping.scale_x);
            const int sy = static_cast<int>(mapping.offset_y + py * mapping.scale_y);
            return rgba[(static_cast<size_t>(sy) * width + sx) * 4 + channel];
        };
        if (x == -512) {
            EXPECT_GT(pixel(-50, 200, 0), 190) << "parked backdrop leaks into the side";
            EXPECT_GT(pixel(0.5f, 200, 1), 200) << "retail's sliver inside the screen lost";
        } else {
            EXPECT_GT(pixel(-50, 200, 1), 200) << "entering backdrop clipped to the screen";
        }
    }
}

namespace {

// A menu message window that draws its frame and choice cursor without any text.
void PrepareMessageForm(CDC2Mes &message, int preset, CMenuPosDataForm &form) {
    static short buffer[4] = {};
    message.MsgPreset(preset);
    message.SetBuff(dc2::text::MessageTable::Parse(std::as_bytes(std::span(buffer))));
    // StepMsg lays out no message, and DrawMesWin still draws the window.
    message.CDC2Mes::mes_no = -1;
    message.ClsMes::mes_no = 0;
    message.fade_speed = 0.0f;
    message.push_button = 0;
    message.line_indent_on = 0;
    message.abs_win.width = 236;
    message.abs_win.height = 82;
    message.text_off_x = 28;
    message.text_off_y = 16;
    form = {};
    form.active = form.draw_flag = 1;
    form.rgba[3] = 128;
    form.dtype = MENUFORM_DTYPE_MSGFORM;
    form.sub_no = 0;
    form.y = 200;
}

// Lays the window out and puts it as the form's draw does, then classifies it.
bool MessageParkedAt(CDC2Mes &message, int x, int y = 200) {
    message.StepMsg();
    int put[2] = {x, y};
    message.SetPutPos(put);
    return MenuMessageParked(message);
}

// Enters an opaque green "gaiji" texture, which message frames, cursors and gaiji draw from.
class OpaqueGaiji {
public:
    OpaqueGaiji() : arena(4096), pixels(256 * 256 * 4 / 16) {
        memory.stSetBuffer(arena.data(), static_cast<int>(arena.size()));
        mgTexManager.SetTableBuffer(16, 4, &memory);
        mgTexManager.Initialize(0x1000, -1);
        auto *bytes = reinterpret_cast<uint8_t *>(pixels.data());
        for (int i = 0; i < 256 * 256; ++i) {
            bytes[i * 4 + 1] = 255;
            bytes[i * 4 + 3] = 255;
        }
        u_long128 *levels[MG_TEXTURE_LEVEL_MAX] = {pixels.data()};
        char       gaiji[] = "gaiji";
        texture_entered = mgTexManager.EnterTexture(0, gaiji, levels, 256, 256, 32, nullptr, 0, 0) != nullptr;
    }

    ~OpaqueGaiji() {
        mgTexManager.Initialize(0x1000, -1);
    }

    OpaqueGaiji(const OpaqueGaiji &) = delete;
    OpaqueGaiji &operator=(const OpaqueGaiji &) = delete;

    [[nodiscard]] bool entered() const {
        return texture_entered;
    }

private:
    std::vector<u_long128> arena;
    std::vector<u_long128> pixels;
    mgCMemory              memory;
    bool                   texture_entered = false;
};

// Lays out half-width ASCII through a synthetic font lookup table, which is game state, not disc
// assets: each character's entry is its code followed by a space.
class AsciiFontTable {
public:
    AsciiFontTable() {
        auto *header = reinterpret_cast<FONT_TBL_BIN *>(GetYoyakuTblTop() - 8);
        std::memcpy(saved.data(), header, saved.size());
        std::memset(header, 0, sizeof(*header));
        header->half_font_num = header->yoyaku_num = 94;
        header->kanji_top_no = 0xffff;
        for (int i = 0; i < 94; ++i) {
            const std::ptrdiff_t entry = static_cast<std::ptrdiff_t>(i) * 2;
            GetYoyakuTblTop()[entry] = static_cast<u8>(i + 0x20);
            GetYoyakuTblTop()[entry + 1] = 0x20;
        }
    }

    ~AsciiFontTable() {
        std::memcpy(GetYoyakuTblTop() - 8, saved.data(), saved.size());
    }

    AsciiFontTable(const AsciiFontTable &) = delete;
    AsciiFontTable &operator=(const AsciiFontTable &) = delete;

private:
    std::array<unsigned char, FONT_TBL_BIN_SIZE> saved{};
};

// Draws one message form on a background of (200, 150, 100) and reads back the frame.
std::vector<uint8_t> DrawMessageForm(CMenuPosDataForm &form, CDC2Mes &message, uint32_t &width) {
    mgSetBackGround(200, 150, 100, 128);
    mgBeginFrame(nullptr);
    int state = message.texture_block;
    form.MenuFormDraw(state);
    mgEndFrame(nullptr);
    std::vector<uint8_t> rgba;
    uint32_t             height = 0;
    EXPECT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    return rgba;
}

} // namespace

TEST(MglibAspect, MenuFormsParkMessageWindowsAndInventCards) {
    AspectRenderer   renderer(1920, 1080);
    CDC2Mes          message;
    CMenuPosDataForm form{};
    PrepareMessageForm(message, MENU_SCRIPT_MES_GENERAL, form);
    // The item description rests at x=570 off the main menu and slides in through x=477.
    EXPECT_TRUE(MessageParkedAt(message, 570, 354));
    EXPECT_FALSE(MessageParkedAt(message, 477, 354));
    EXPECT_FALSE(MessageParkedAt(message, 510)) << "the frame starts at x=510, rounded down to 509";
    EXPECT_TRUE(MessageParkedAt(message, 511));
    EXPECT_FALSE(MessageParkedAt(message, -250)) << "a window put left of the screen sits at its default place";
    message.abs_win.width = 0;
    EXPECT_TRUE(MessageParkedAt(message, 570)) << "past the right side, the right edge is not needed";
    message.abs_win.width = 236;
    message.draw_off_x = -60.0f;
    EXPECT_FALSE(MessageParkedAt(message, 570)) << "the drawing offset moves every draw";
    message.draw_off_x = 0.0f;
    message.equip_on[2] = 1;
    message.equip_x[2] = 500;
    EXPECT_FALSE(MessageParkedAt(message, 570)) << "a mark at its line's place reaches x=500";
    message.equip_x[2] = 600;
    EXPECT_TRUE(MessageParkedAt(message, 570));
    message.equip_on[2] = 0;

    // The choice cursor's goal is 40 pixels and half a character left of the text, and it sways 6.
    message.cursor = 0;
    EXPECT_FALSE(MessageParkedAt(message, 535)) << "the cursor reaches x=535+28-40-7-6=510";
    message.cursor_time = 0;
    EXPECT_TRUE(MessageParkedAt(message, 536));
    message.cursor_time = 3;
    message.cursor_x = 400;
    EXPECT_FALSE(MessageParkedAt(message, 536)) << "the cursor is still easing in from x=400";
    message.cursor_on = 0;
    message.cursor_x = 900;
    EXPECT_FALSE(MessageParkedAt(message, 536)) << "a hidden cursor eases from x=-1000";

    // A floating window's tail reaches 13 pixels past its frame.
    PrepareMessageForm(message, MENU_SCRIPT_MES_ITEMCMD, form);
    EXPECT_FALSE(MessageParkedAt(message, 523));
    EXPECT_TRUE(MessageParkedAt(message, 524));
    message.put_centering = 1;
    EXPECT_FALSE(MessageParkedAt(message, 570)) << "a centred window is put on the screen";
    message.put_centering = 0;
    message.window_mode = MES_WIN_FUKIDASHI;
    EXPECT_FALSE(MessageParkedAt(message, 570)) << "a speech bubble places itself";

    // The Make menu's invention card rows rest at x=-262 and are 231 wide.
    form.dtype = MENUFORM_DTYPE_INV_CARD;
    form.y = 70;
    form.x = -262;
    EXPECT_TRUE(MenuFormParked(form));
    form.x = -200;
    EXPECT_FALSE(MenuFormParked(form));
}

// Draws message forms with an opaque gaiji texture: a cursor or tail that reaches the screen
// draws whole, and a window past the screen's right edge stays off the side.
TEST(MglibAspect, MenuFormsKeepMessageCursorAndTailWhole) {
    AspectRenderer renderer(1920, 1080);
    OpaqueGaiji    gaiji;
    ASSERT_TRUE(gaiji.entered());
    auto *const saved_message = MenuDCMsg[0];
    CDC2Mes     message;
    MenuDCMsg[0] = &message;
    const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);

    struct Case {
        int   preset;
        float x;
        int   cursor, point_x, point_y;
        float sample_x, sample_dy;
        bool  drawn;
    };

    // A plain window's cursor goal is x+28-40-7, drawn 5 further right on its first frame. A
    // floating window's tail sits left of its frame, level with a pointer 20 pixels down. Both
    // are sampled between the screen's edge and the frame.
    for (const Case c : {
             Case{.preset = MENU_SCRIPT_MES_GENERAL, .x = 520, .cursor = 0,  .point_x = 0,   .point_y = 0,  .sample_x = 515, .sample_dy = 12, .drawn = true },
             Case{.preset = MENU_SCRIPT_MES_GENERAL, .x = 560, .cursor = 0,  .point_x = 0,   .point_y = 0,  .sample_x = 550, .sample_dy = 12, .drawn = false},
             Case{.preset = MENU_SCRIPT_MES_ITEMCMD, .x = 520, .cursor = -1, .point_x = -30, .point_y = 20, .sample_x = 515, .sample_dy = 20, .drawn = true },
             Case{.preset = MENU_SCRIPT_MES_ITEMCMD, .x = 560, .cursor = -1, .point_x = -30, .point_y = 20, .sample_x = 550, .sample_dy = 20, .drawn = false},
    }) {
        SCOPED_TRACE(c.x);
        SCOPED_TRACE(c.preset);
        CMenuPosDataForm form{};
        PrepareMessageForm(message, c.preset, form);
        form.x = c.x;
        message.cursor = c.cursor;
        message.point_x = c.point_x;
        message.point_y = c.point_y;
        uint32_t   width = 0;
        const auto rgba = DrawMessageForm(form, message, width);
        ASSERT_FALSE(rgba.empty());
        const auto pixel = [&](float px, float py, int channel) {
            const int sx = static_cast<int>(mapping.offset_x + px * mapping.scale_x);
            const int sy = static_cast<int>(mapping.offset_y + py * mapping.scale_y);
            return rgba[(static_cast<size_t>(sy) * width + sx) * 4 + channel];
        };
        if (c.cursor >= 0) {
            ASSERT_EQ(message.cursor_x, static_cast<int>(c.x) + 28 - 40 - 15 / 2);
        }
        const float sample_y = (c.cursor >= 0 ? message.cursor_y : form.y) + c.sample_dy;
        if (c.drawn) {
            EXPECT_GT(pixel(c.sample_x, sample_y, 1), 200) << "cut off at the screen's edge";
            EXPECT_LT(pixel(c.sample_x, sample_y, 0), 100) << "cut off at the screen's edge";
            if (pixel(c.sample_x, sample_y, 1) <= 200 || pixel(c.sample_x, sample_y, 0) >= 100) {
                WriteFailureFrame(std::to_string(c.preset) + "_" + std::to_string(c.x), rgba, width,
                                  static_cast<uint32_t>(rgba.size() / 4 / width));
            }
        } else {
            EXPECT_GT(pixel(c.sample_x, sample_y, 0), 190) << "parked window shows at the side";
        }
        // The frame's left edge.
        EXPECT_EQ(pixel(c.x + 2, form.y + 30, 0) < 100, c.drawn);
    }
    MenuDCMsg[0] = saved_message;
}

// Draws a window past the screen whose text reaches left of where the window's text starts and
// crosses the screen's edge, so the window is not parked and the glyph draws on both sides of
// that edge: a line placed on its own at x=512 whose gaiji 0xFD21 starts 6 left of it; a number
// padded to fewer digits than it has, which moves the pen left of the text's start (123456 in a
// one-digit field leaves the pen 48 left of it, so the following 0xFD21 covers x=510..521); and
// 0xFD29, 30 tall on a 24-pixel line placed at y=480, which starts 7 above it.
TEST(MglibAspect, MenuFormsKeepLaidOutTextWhole) {
    struct Case {
        int         window_width, window_height;
        float       x, y;
        int         line_x, line_y;
        int         number, number_width;
        const char *text;
        float       inside_x, inside_y, outside_x, outside_y;
        bool        parked_unplaced;
    };

    for (const Case c : {
             Case{.window_width = 1920, .window_height = 1080, .x = 570, .y = 200, .line_x = 512, .line_y = 300, .number = 0,      .number_width = 0, .text = "[bulb]",          .inside_x = 508, .inside_y = 309, .outside_x = 515, .outside_y = 309, .parked_unplaced = true },
             Case{.window_width = 1920, .window_height = 1080, .x = 536, .y = 200, .line_x = -1,  .line_y = 0,   .number = 123456, .number_width = 1, .text = "[Number1][bulb]", .inside_x = 511, .inside_y = 224, .outside_x = 519, .outside_y = 224, .parked_unplaced = false},
             Case{.window_width = 800,  .window_height = 1200, .x = 100, .y = 500, .line_x = 200, .line_y = 480, .number = 0,      .number_width = 0, .text = "(L)",             .inside_x = 210, .inside_y = 476, .outside_x = 210, .outside_y = 495, .parked_unplaced = false},
    }) {
        SCOPED_TRACE(c.text);
        AspectRenderer renderer(c.window_width, c.window_height);
        OpaqueGaiji    gaiji;
        ASSERT_TRUE(gaiji.entered());
        AsciiFontTable font_table;
        auto *const    saved_message = MenuDCMsg[0];
        CDC2Mes        message;
        MenuDCMsg[0] = &message;
        CMenuPosDataForm form{};
        PrepareMessageForm(message, MENU_SCRIPT_MES_GENERAL, form);
        EXPECT_EQ(message.font_h, 24);
        EXPECT_EQ(message.font_w, 15);
        message.cursor = -1;
        message.value_half = 1;
        message.value_space = 0;
        int number = c.number;
        int number_width = c.number_width;
        message.SetMsgVolumeNo(&number, &number_width, 1);
        std::string text = c.text;
        message.MakeMsg(text.data());
        form.x = c.x;
        form.y = c.y;
        if (c.line_x >= 0) {
            // Text in the window parks with it sideways; no message window parks vertically.
            EXPECT_EQ(MessageParkedAt(message, static_cast<int>(c.x), static_cast<int>(c.y)), c.parked_unplaced);
            message.line_pos_on[0] = 1;
            message.line_pos[0][0] = c.line_x;
            message.line_pos[0][1] = c.line_y;
        }
        EXPECT_FALSE(MessageParkedAt(message, static_cast<int>(c.x), static_cast<int>(c.y)));
        uint32_t   width = 0;
        const auto rgba = DrawMessageForm(form, message, width);
        MenuDCMsg[0] = saved_message;
        ASSERT_FALSE(rgba.empty());
        const auto mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
        const auto pixel = [&](float px, float py, int channel) {
            const int sx = static_cast<int>(mapping.offset_x + px * mapping.scale_x);
            const int sy = static_cast<int>(mapping.offset_y + py * mapping.scale_y);
            return rgba[(static_cast<size_t>(sy) * width + sx) * 4 + channel];
        };
        EXPECT_GT(pixel(c.inside_x, c.inside_y, 1), 200) << "glyph not drawn";
        EXPECT_GT(pixel(c.outside_x, c.outside_y, 1), 200) << "glyph cut off at the screen's edge";
        EXPECT_LT(pixel(c.outside_x, c.outside_y, 0), 100) << "glyph cut off at the screen's edge";
    }
}

TEST(MglibAspect, MenuFormsNeverParkAtFourThree) {
    AspectRenderer   renderer(640, 480);
    CMenuPosDataForm form{};
    form.active = form.draw_flag = 1;
    form.dtype = MENUFORM_DTYPE_INV_CARD;
    form.x = -262;
    EXPECT_FALSE(MenuFormParked(form)) << "the 4:3 picture is already the screen";
    CDC2Mes message;
    PrepareMessageForm(message, MENU_SCRIPT_MES_GENERAL, form);
    EXPECT_FALSE(MessageParkedAt(message, 570));
}

namespace {

// One filled part form at (x, y), parked or entering, then an independent white quad drawn with
// the GS state, whose draw must not be held to the screen. A ui form's fill takes the form's
// alpha and draws in UI units like a menu sprite; otherwise it is depth-tested and drawn in the
// target's logical units, as SetSpriteEnv's MENU_SPRITE_ENV_COLOR leaves it. Samples are in the
// fill's units, the quad in UI units.
struct PartFormCase {
    float x{}, y{};
    int   w{}, h{};
    float sample_x{}, sample_y{};
    bool  drawn{};
    float quad_x{}, quad_y{};
    float sliver_x = -1000.0f; // a point inside the screen the parked form still covers
};

void ExpectPartForms(int window_width, int window_height, float ui_scale, bool ui, std::initializer_list<PartFormCase> cases) {
    AspectRenderer renderer(window_width, window_height);
    gfx::SetFrameLayout({.aspect = gfx::AspectMode::Fill, .ui_scale = ui_scale});
    dc2::test::ScopedGlobalObject<MenuPosData> layout_owner;
    auto                                      &layout = layout_owner.Get();
    MENU_BASETEXINFO                           texture_info{};
    layout.tex_info = &texture_info;
    layout.tex_info_num = 1;
    MENU_PARTS_EFFECT_STRUCT1 fill{};
    fill.param[0] = 20;
    fill.param[1] = 220;
    fill.param[2] = 30;
    fill.param[3] = 128;
    MENUFORMPARTS_TYPE part{};
    part.active = part.draw_flag = 1;
    part.dtype = MENUFORMPARTS_DTYPE_SQ_BETA;
    part.effect = &fill;
    CMenuPosDataForm form{};
    form.active = form.draw_flag = 1;
    form.rgba[3] = 128;
    form.rgba_bit = ui ? MENUFORM_RGBA_BIT_ALPHA : 0;
    form.dtype = MENUFORM_DTYPE_NORMAL;
    form.parts = &part;
    form.parts_num = 1;
    const auto ui_mapping = gfx::GetUiMapping(gfx::kMainTarget);
    const auto fill_mapping = ui ? ui_mapping : gfx::GetLogicalMapping(gfx::kMainTarget);
    for (const PartFormCase &c : cases) {
        SCOPED_TRACE(testing::Message() << "form at " << c.x << ", " << c.y);
        form.x = c.x;
        form.y = c.y;
        part.w = c.w;
        part.h = c.h;
        mgSetBackGround(200, 150, 100, 128);
        mgBeginFrame(nullptr);
        int state = -1;
        form.MenuFormDraw(state);
        const std::array quad = {QuadCorner(c.quad_x, c.quad_y), QuadCorner(c.quad_x + 25, c.quad_y),
                                 QuadCorner(c.quad_x + 25, c.quad_y + 25), QuadCorner(c.quad_x, c.quad_y + 25)};
        gfx::DrawState   quad_state = mgPortDrawState();
        quad_state.depth_test = gfx::DepthTest::Always;
        quad_state.depth_write = false;
        mgPortDraw2D(gfx::Primitive::Quads, quad, {}, quad_state);
        mgEndFrame(nullptr);
        std::vector<uint8_t> rgba;
        uint32_t             width = 0;
        uint32_t             height = 0;
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
        const auto pixel = [&](const gfx::LogicalMapping &mapping, float px, float py, int channel) {
            const int sx = static_cast<int>(mapping.offset_x + px * mapping.scale_x);
            const int sy = static_cast<int>(mapping.offset_y + py * mapping.scale_y);
            EXPECT_TRUE(sx >= 0 && sy >= 0 && std::cmp_less(sx, width) && std::cmp_less(sy, height));
            return rgba[(static_cast<size_t>(std::clamp<int>(sy, 0, height - 1)) * width + std::clamp<int>(sx, 0, width - 1)) * 4 + channel];
        };
        if (c.drawn) {
            EXPECT_GT(pixel(fill_mapping, c.sample_x, c.sample_y, 1), 200) << "entering form clipped to the screen";
        } else {
            EXPECT_GT(pixel(fill_mapping, c.sample_x, c.sample_y, 0), 190) << "parked form shows past the screen";
            EXPECT_LT(pixel(fill_mapping, c.sample_x, c.sample_y, 1), 200) << "parked form shows past the screen";
        }
        if (c.sliver_x > -1000.0f) {
            EXPECT_GT(pixel(fill_mapping, c.sliver_x, c.sample_y, 1), 200) << "retail's sliver inside the screen lost";
        }
        EXPECT_GT(pixel(ui_mapping, c.quad_x + 12, c.quad_y + 12, 0), 240) << "form clip leaked to a following draw";
        EXPECT_GT(pixel(ui_mapping, c.quad_x + 12, c.quad_y + 12, 2), 240) << "form clip leaked to a following draw";
        if (pixel(ui_mapping, c.quad_x + 12, c.quad_y + 12, 0) <= 240 ||
            pixel(ui_mapping, c.quad_x + 12, c.quad_y + 12, 2) <= 240) {
            WriteFailureFrame(std::to_string(c.x) + "_" + std::to_string(c.y), rgba, width, height);
        }
    }
    gfx::SetFrameLayout({.aspect = gfx::AspectMode::Fill, .ui_scale = 1.0f});
}

} // namespace

// UI scale 0.5 shows the UI from x=-256 to x=768 on a 4:3 window, so menu sprites parked past
// the screen would show at its sides, though its logical units show only the screen.
TEST(MglibAspect, MenuFormsParkPastHalfScaleUi) {
    ExpectPartForms(1024, 768, 0.5f, true,
                    {
                        {.x = -512, .y = 0, .w = 513, .h = 480, .sample_x = -50, .sample_y = 200, .drawn = false, .quad_x = -75, .quad_y = 40, .sliver_x = 0.5f},
                        {.x = -400, .y = 0, .w = 513, .h = 480, .sample_x = -50, .sample_y = 200, .drawn = true, .quad_x = -75, .quad_y = 40},
                        {.x = 530, .y = 296, .w = 236, .h = 164, .sample_x = 550, .sample_y = 350, .drawn = false, .quad_x = 560, .quad_y = 40},
                        {.x = 470, .y = 296, .w = 236, .h = 164, .sample_x = 550, .sample_y = 350, .drawn = true, .quad_x = 560, .quad_y = 40},
    });
}

// UI scale 1.5 at 32:9 shows the UI from about x=-199 to x=711 and y=80 to y=400.
TEST(MglibAspect, MenuFormsParkPastOneAndAHalfScaleUi) {
    ExpectPartForms(3840, 1080, 1.5f, true,
                    {
                        {.x = -512, .y = 0, .w = 513, .h = 480, .sample_x = -50, .sample_y = 200, .drawn = false, .quad_x = -75, .quad_y = 100, .sliver_x = 0.5f},
                        {.x = -400, .y = 0, .w = 513, .h = 480, .sample_x = -50, .sample_y = 200, .drawn = true, .quad_x = -75, .quad_y = 100},
                        {.x = 530, .y = 296, .w = 236, .h = 164, .sample_x = 550, .sample_y = 350, .drawn = false, .quad_x = 560, .quad_y = 100},
                        {.x = 470, .y = 296, .w = 236, .h = 164, .sample_x = 550, .sample_y = 350, .drawn = true, .quad_x = 560, .quad_y = 100},
    });
}

// At UI scale 1.5 a 1600x1080 window shows the UI only from about x=66 to x=445, but its logical
// units from x=-28 to x=540, where depth-tested fills parked past the screen would show.
TEST(MglibAspect, MenuFormsParkFillsPastOneAndAHalfScaleUi) {
    ExpectPartForms(1600, 1080, 1.5f, false,
                    {
                        {.x = -512, .y = 0, .w = 513, .h = 480, .sample_x = -20, .sample_y = 200, .drawn = false, .quad_x = 300, .quad_y = 100, .sliver_x = 0.5f},
                        {.x = -400, .y = 0, .w = 513, .h = 480, .sample_x = -20, .sample_y = 200, .drawn = true, .quad_x = 300, .quad_y = 100},
                        {.x = 530, .y = 296, .w = 236, .h = 164, .sample_x = 535, .sample_y = 350, .drawn = false, .quad_x = 300, .quad_y = 100},
                        {.x = 470, .y = 296, .w = 236, .h = 164, .sample_x = 535, .sample_y = 350, .drawn = true, .quad_x = 300, .quad_y = 100},
    });
}

// An 800x1200 window shows from y=-144 to y=624: panels parked below or above the screen are
// clipped to it, and ones entering it draw whole.
TEST(MglibAspect, MenuFormsParkVerticallyOnTallWindow) {
    ExpectPartForms(800, 1200, 1.0f, false,
                    {
                        {.x = 100, .y = 490,  .w = 236, .h = 164, .sample_x = 200, .sample_y = 550, .drawn = false, .quad_x = 300, .quad_y = 560},
                        {.x = 100, .y = 400,  .w = 236, .h = 164, .sample_x = 200, .sample_y = 550, .drawn = true,  .quad_x = 300, .quad_y = 560},
                        {.x = 100, .y = -170, .w = 236, .h = 164, .sample_x = 200, .sample_y = -50, .drawn = false, .quad_x = 300, .quad_y = -60},
                        {.x = 100, .y = -100, .w = 236, .h = 164, .sample_x = 200, .sample_y = -50, .drawn = true,  .quad_x = 300, .quad_y = -60},
    });
}

namespace {
void ExpectMenuBackdropContinuation(int window_width, int window_height, int page = 0, std::initializer_list<int> y_offsets = {0}) {
    const bool             character = page == 1;
    const bool             invent = page == 2;
    const bool             options = page == 3;
    AspectRenderer         renderer(window_width, window_height);
    std::vector<u_long128> arena(4096);
    std::vector<u_long128> pixels(1024 * 1024 * 4 / 16);
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
    char       name[] = "bg16";
    char       character_name[] = "chr_bg";
    char       invent_name[] = "inv_bg";
    char       options_name[] = "op_bg";
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
            uint32_t             width = 0;
            uint32_t             height = 0;
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
} // namespace

TEST(MglibAspect, MenuBackdropContinuesArtworkAt1920x1080) {
    ExpectMenuBackdropContinuation(1920, 1080);
}

TEST(MglibAspect, MenuBackdropContinuesArtworkAt3840x2160) {
    ExpectMenuBackdropContinuation(3840, 2160);
}

TEST(MglibAspect, CharacterBackdropContinuesArtworkAt1920x1080) {
    ExpectMenuBackdropContinuation(1920, 1080, 1);
}

TEST(MglibAspect, CharacterBackdropContinuesArtworkAt3840x2160) {
    ExpectMenuBackdropContinuation(3840, 2160, 1);
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
    prim.write_buffer = {};
    prim.Coord(1);
    for (float scroll : {-1.0f, -127.5f, -255.0f, 40.5f}) {
        float left = 1e9f;
        float top = 1e9f;
        float right = -1e9f;
        float bottom = -1e9f;
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

namespace {
struct FreeDeleter {
    void operator()(void *p) const {
        std::free(p);
    }
};

using FloorMap = std::unique_ptr<CDngFreeMap, FreeDeleter>;

// A zeroed map is in menu mode with no textures, user or marks.
FloorMap ZeroFloorMap() {
    return FloorMap(static_cast<CDngFreeMap *>(std::calloc(1, sizeof(CDngFreeMap))));
}

// Binds the menu's shared builder to a draw manager, as the dungeon menu does, for the scope.
class MenuPrimScope {
public:
    MenuPrimScope() {
        manager.render_info = &info;
        prim->draw_manager = &manager;
        prim->Initialize(&memory, &packet);
        prim->write_buffer = {};
    }

    ~MenuPrimScope() {
        prim->Initialize(nullptr, nullptr);
        prim->draw_manager = nullptr;
    }

    MenuPrimScope(const MenuPrimScope &) = delete;
    MenuPrimScope &operator=(const MenuPrimScope &) = delete;

private:
    mgCMemory      memory;
    sceVif1Packet  packet{};
    mgRENDER_INFO  info{};
    mgCDrawManager manager;
    mgCDrawPrim   *prim = GetMenuPrim();
};

struct CellVertices {
    std::size_t room = 0;
    std::size_t root = 0;
};

// Vertices the floor map's room and passage draws emit for a cell at logical (x, y).
CellVertices FloorMapCellVertices(float x, float y) {
    MenuPrimScope    scope;
    FloorMap         map = ZeroFloorMap();
    DNGMAP_ROOM_INFO room{};
    DNGMAP_ROOT_INFO root{};
    std::size_t      count = 0;
    mgPortSetPrimSink([&](gfx::Primitive, std::span<const gfx::Vertex2D> vertices, const gfx::TextureBinding &,
                          const gfx::DrawState &) { count += vertices.size(); });
    const mgRect<float> cell(x, y, 52.0f, 20.0f);
    CellVertices        out;
    map->DrawRoomOne(cell, &room, 0, 128, 1.0f);
    out.room = count;
    count = 0;
    map->DrawRoot(cell, &root, 0, 0, 128);
    out.root = count;
    mgPortSetPrimSink({});
    return out;
}

// Retail draws a room up to 20 units and a passage up to 0 units past the screen's right edge, and
// 30 and 20 units past its bottom. Each must hold at the given edges.
void ExpectFloorMapCullsAt(float right, float bottom) {
    const mgPortExtent extent = mgPortVisibleUiExtent(gfx::kMainTarget);
    EXPECT_NEAR(extent.right, right, 0.5f);
    EXPECT_NEAR(extent.bottom, bottom, 0.5f);
    EXPECT_GT(FloorMapCellVertices(right + 19.0f, 200.0f).room, 0u);
    EXPECT_EQ(FloorMapCellVertices(right + 21.0f, 200.0f).room, 0u);
    EXPECT_GT(FloorMapCellVertices(right - 1.0f, 200.0f).root, 0u);
    EXPECT_EQ(FloorMapCellVertices(right + 1.0f, 200.0f).root, 0u);
    EXPECT_GT(FloorMapCellVertices(200.0f, bottom + 29.0f).room, 0u);
    EXPECT_EQ(FloorMapCellVertices(200.0f, bottom + 31.0f).room, 0u);
    EXPECT_GT(FloorMapCellVertices(200.0f, bottom + 19.0f).root, 0u);
    EXPECT_EQ(FloorMapCellVertices(200.0f, bottom + 21.0f).root, 0u);
}
} // namespace

TEST(MglibAspect, FloorMapCullsAtTheFourThreeScreen) {
    AspectRenderer renderer(1024, 768);
    ExpectFloorMapCullsAt(512.0f, 480.0f);
}

TEST(MglibAspect, FloorMapDrawsCellsInWideFlanks) {
    AspectRenderer renderer(1280, 720);
    ExpectFloorMapCullsAt(256.0f + 256.0f * (16.0f / 9.0f) / (4.0f / 3.0f), 480.0f);
}

TEST(MglibAspect, FloorMapDrawsCellsBelowANarrowScreen) {
    AspectRenderer renderer(800, 1200);
    ExpectFloorMapCullsAt(512.0f, 240.0f + 240.0f * (4.0f / 3.0f) / (800.0f / 1200.0f));
}

// UI scale 0.5 halves the floor map's 2D about the centre, so twice its extent is on screen.
TEST(MglibAspect, FloorMapDrawsCellsUncoveredByUiScale) {
    AspectRenderer renderer(1024, 768);
    gfx::SetFrameLayout({.aspect = gfx::AspectMode::Fill, .ui_scale = 0.5f});
    ExpectFloorMapCullsAt(256.0f + 512.0f, 240.0f + 480.0f);
    gfx::SetFrameLayout({.aspect = gfx::AspectMode::Fill, .ui_scale = 1.0f});
}

namespace {
// Draws with the menu builder into a cleared frame and reads the main target back.
template <typename Draw>
std::vector<uint8_t> DrawFrame(Draw draw, uint32_t &width, uint32_t &height) {
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    mgBeginFrame(nullptr);
    {
        MenuPrimScope scope;
        draw();
    }
    mgEndFrame(nullptr);
    std::vector<uint8_t> rgba;
    EXPECT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    return rgba;
}

// Counts the split strokes: two lit runs, each thinner than a logical pixel, with a gap of at most a
// logical pixel between them, across every column and row. A solid band has none; retail's notches
// between passage segments are bounded by full-width bands and do not count.
int SplitStrokes(const std::vector<uint8_t> &rgba, uint32_t width, uint32_t height) {
    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    const auto                lit = [&](uint32_t x, uint32_t y) { return rgba[(static_cast<size_t>(y) * width + x) * 4] > 64; };
    int                       found = 0;
    const auto                scan = [&](uint32_t lines, uint32_t length, float unit, auto at) {
        for (uint32_t line = 0; line < lines; ++line) {
            int previous_start = -1;
            int previous_end = -1;
            int start = -1;
            for (uint32_t i = 0; i <= length; ++i) {
                const bool on = i < length && at(line, i);
                if (on && start < 0) {
                    start = static_cast<int>(i);
                } else if (!on && start >= 0) {
                    const int end = static_cast<int>(i) - 1;
                    if (previous_end >= 0 && start - previous_end - 1 <= unit &&
                        previous_end - previous_start + 1 < unit && end - start + 1 < unit) {
                        ++found;
                    }
                    previous_start = start;
                    previous_end = end;
                    start = -1;
                }
            }
        }
    };
    scan(width, height, mapping.scale_y, [&](uint32_t x, uint32_t y) { return lit(x, y); });
    scan(height, width, mapping.scale_x, [&](uint32_t y, uint32_t x) { return lit(x, y); });
    return found;
}

void ExpectSolidPassages() {
    uint32_t width = 0;
    uint32_t height = 0;
    // The detector sees retail's three 1-pixel lines, drawn without bands, as split.
    const std::vector<uint8_t> plain = DrawFrame(
        [] {
            mgCDrawPrim *prim = GetMenuPrim();
            SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR_AA);
            prim->Begin(MG_PRIM_LINE);
            prim->Color(212, 192, 144, 128);
            for (int i = 0; i < 3; ++i) {
                prim->Vertex(100.0f + i, 100.0f, 0.0f);
                prim->Vertex(84.0f + i, 120.0f, 0.0f);
                prim->Vertex(100.0f - i, 150.0f + i, 0.0f);
                prim->Vertex(152.0f - i, 150.0f + i, 0.0f);
            }
            prim->End();
        },
        width, height);
    EXPECT_GT(SplitStrokes(plain, width, height), 0);

    for (int shape = 0; shape < 10; ++shape) {
        const std::vector<uint8_t> rgba = DrawFrame(
            [shape] {
                FloorMap         map = ZeroFloorMap();
                DNGMAP_ROOT_INFO root{};
                root.shape = static_cast<u8>(shape);
                map->DrawRoot(mgRect<float>(230.0f, 200.0f, 52.0f, 20.0f), &root, 0, 0, 128);
            },
            width, height);
        std::size_t count = 0;
        for (std::size_t i = 0; i < rgba.size(); i += 4) {
            count += rgba[i] > 64;
        }
        EXPECT_GT(count, 0u) << "shape " << shape;
        EXPECT_EQ(SplitStrokes(rgba, width, height), 0) << "shape " << shape;
    }

    // At half opacity a one-group passage blends each pixel once: every lit pixel has one colour.
    for (int shape : {0, 1, 6, 7, 8, 9}) {
        const std::vector<uint8_t> rgba = DrawFrame(
            [shape] {
                FloorMap         map = ZeroFloorMap();
                DNGMAP_ROOT_INFO root{};
                root.shape = static_cast<u8>(shape);
                map->DrawRoot(mgRect<float>(230.0f, 200.0f, 52.0f, 20.0f), &root, 0, 0, 64);
            },
            width, height);
        std::set<uint8_t> reds;
        for (std::size_t i = 0; i < rgba.size(); i += 4) {
            if (rgba[i] > 16) {
                reds.insert(rgba[i]);
            }
        }
        EXPECT_EQ(reds.size(), 1u) << "shape " << shape;
    }
}
} // namespace

// Every passage shape is one solid stroke above 512x480.
TEST(MglibAspect, FloorMapPassagesAreSolidAt1920x1080) {
    AspectRenderer renderer(1920, 1080);
    ExpectSolidPassages();
}

TEST(MglibAspect, FloorMapPassagesAreSolidAt3840x2160) {
    AspectRenderer renderer(3840, 2160);
    ExpectSolidPassages();
}

// At 4:3 and UI 150% the PC SETTINGS entry would sit above the window. Clicks where the fitted view
// draws the entry and the page's Back reach them through the menu pointer.
TEST(MglibAspect, PcSettingsClicksReachTheFittedEntryAndBackAt150Percent) {
    AspectRenderer renderer(1920, 1080);
    gfx::SetFrameLayout({.aspect = gfx::AspectMode::Letterbox, .ui_scale = 1.5f});
    MenuMouseEnable(true);
    options::g_screen = {};
    const auto tick = [] {
        mgBeginFrame(nullptr);
        mgEndFrame(nullptr);
        options::Run();
    };
    const auto click = [&](options::Point page) {
        const auto view = options::CurrentView(options::g_screen);
        ASSERT_LT(view.scale, 1.0f);
        const auto                at = view.ToUi(page);
        const auto                from = MenuMouseTake();
        const gfx::LogicalMapping ui = gfx::GetUiMapping(gfx::kMainTarget);
        InputSetScriptedDevices({.mouse_dx = (at.x - from.x) * ui.scale_x, .mouse_dy = (at.y - from.y) * ui.scale_y});
        tick();
        EXPECT_NEAR(MenuMouseTake().x, at.x, 1e-2f);
        EXPECT_NEAR(MenuMouseTake().y, at.y, 1e-2f);
        InputSetScriptedDevices({.mouse_buttons = 1});
        tick();
        InputSetScriptedDevices({});
        tick();
    };
    click({.x = 364, .y = 63});
    EXPECT_TRUE(options::g_screen.open);
    click({.x = options::kLeft + 50, .y = 356});
    EXPECT_FALSE(options::g_screen.open);
    MenuMouseEnable(false);
}
