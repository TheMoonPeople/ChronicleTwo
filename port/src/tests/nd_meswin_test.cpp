#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <span>
#include <vector>

#include "drawwin.hpp"
#include "gfx/gfx.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "nd_meswin.hpp"

namespace {

struct Batch {
    gfx::Primitive             primitive;
    std::vector<gfx::Vertex2D> vertices;
    gfx::TextureBinding        texture;
    gfx::DrawState             state;
};

// FillRect initialises its builder with NULL, so it binds to the global draw manager and packet.
class GlobalDrawRig {
public:
    GlobalDrawRig() : saved_render_info_(mgDrawManager.render_info), saved_packet_(mgVif1Packet) {
        mgDrawManager.render_info = &render_info_;
        mgVif1Packet = &vif_packet_;
        mgPortSetPrimSink([this](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &texture, const gfx::DrawState &state) {
            batches.push_back({
                .primitive = primitive, .vertices = {vertices.begin(), vertices.end()},
                     .texture = texture, .state = state
            });
        });
    }

    ~GlobalDrawRig() {
        mgPortSetPrimSink({});
        mgDrawManager.render_info = saved_render_info_;
        mgVif1Packet = saved_packet_;
    }

    GlobalDrawRig(const GlobalDrawRig &) = delete;
    GlobalDrawRig &operator=(const GlobalDrawRig &) = delete;

    std::vector<Batch> batches;

private:
    mgRENDER_INFO  render_info_{};
    sceVif1Packet  vif_packet_{};
    mgRENDER_INFO *saved_render_info_;
    sceVif1Packet *saved_packet_;
};

int Gs(float pixels) {
    return static_cast<int>(pixels * 16.0f);
}

void ExpectAt(const gfx::Vertex2D &v, float x, float y) {
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(Gs(x)));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(Gs(y)));
}

std::array<uint8_t, 4> Rgba(const gfx::Vertex2D &v) {
    return {v.color[0], v.color[1], v.color[2], v.color[3]};
}

} // namespace

TEST(MesWinFillRect, BackingCoversFrameOpening) {
    GlobalDrawRig rig;

    FillRect(159, 346, 197, 47, 0, 0, 0, 54);

    ASSERT_EQ(rig.batches.size(), 1u);
    const Batch &batch = rig.batches[0];
    EXPECT_EQ(batch.primitive, gfx::Primitive::Quads);
    EXPECT_EQ(batch.texture.texture, gfx::kNullTexture);
    EXPECT_TRUE(batch.state.blend);

    ASSERT_EQ(batch.vertices.size(), 4u);
    ExpectAt(batch.vertices[0], 158.0f, 345.0f);
    ExpectAt(batch.vertices[1], 356.0f, 345.0f);
    ExpectAt(batch.vertices[2], 356.0f, 393.0f);
    ExpectAt(batch.vertices[3], 158.0f, 393.0f);
    for (const gfx::Vertex2D &v : batch.vertices) {
        EXPECT_EQ(Rgba(v), (std::array<uint8_t, 4>{0, 0, 0, 54}));
    }

    // Every physical pixel centre in the opening must hit the single translucent backing,
    // including the last row and column at non-integral display scales.
    for (float scale : {1.25f, 2.5f, 3.75f}) {
        const int physical_left = static_cast<int>(159 * scale);
        const int physical_top = static_cast<int>(346 * scale);
        const int physical_right = static_cast<int>(356 * scale);
        const int physical_bottom = static_cast<int>(393 * scale);
        for (int px : {physical_left, physical_right - 1}) {
            for (int py : {physical_top, physical_bottom - 1}) {
                const float x = (static_cast<float>(px) + 0.5f) / scale;
                const float y = (static_cast<float>(py) + 0.5f) / scale;
                EXPECT_GE(x, batch.vertices[0].x);
                EXPECT_LT(x, batch.vertices[2].x);
                EXPECT_GE(y, batch.vertices[0].y);
                EXPECT_LT(y, batch.vertices[2].y);
            }
        }
    }
}

TEST(MesWinFillRect, SelectedLineFrameKeepsTopSideAndBackingToBand) {
    GlobalDrawRig rig;
    mgCDrawPrim   prim;
    RGBAQ_TYPE    color{.r = 128, .g = 128, .b = 128, .a = 96};
    const int     saved_abs_draw_off = MesAbsDrawOff;
    MesAbsDrawOff = 0;
    DrawVersatileWin_3(&prim, {.x = 100, .y = 100, .width = 180, .height = 120}, 170, &color, 96, 0);
    MesAbsDrawOff = saved_abs_draw_off;

    const Batch *left_side = nullptr;
    const Batch *backing = nullptr;
    for (const Batch &batch : rig.batches) {
        if (batch.vertices.size() != 4) {
            continue;
        }
        if (batch.vertices[0].x == 100.0f && batch.vertices[0].y == 125.0f) {
            left_side = &batch;
        }
        if (batch.vertices[0].x == 112.0f && batch.vertices[0].y == 115.0f) {
            backing = &batch;
        }
    }
    ASSERT_NE(left_side, nullptr);
    ASSERT_NE(backing, nullptr);
    ExpectAt(left_side->vertices[2], 123.0f, 163.0f);
    ExpectAt(backing->vertices[2], 269.0f, 167.0f);
    EXPECT_EQ(Rgba(backing->vertices[0]), (std::array<uint8_t, 4>{0, 0, 0, 40}));
}

TEST(MesWinFillRect, CollapsedSelectedLineFrameDoesNotInvertSideTiles) {
    GlobalDrawRig rig;
    mgCDrawPrim   prim;
    RGBAQ_TYPE    color{.r = 128, .g = 128, .b = 128, .a = 32};
    const int     saved_abs_draw_off = MesAbsDrawOff;
    MesAbsDrawOff = 0;
    DrawVersatileWin_3(&prim, {.x = 100, .y = 100, .width = 180, .height = 20}, 110, &color, 32, 0);
    DrawVersatileWin_3(&prim, {.x = 100, .y = 100, .width = 20, .height = 120}, 170, &color, 32, 0);
    MesAbsDrawOff = saved_abs_draw_off;

    for (const Batch &batch : rig.batches) {
        ASSERT_EQ(batch.vertices.size(), 4u);
        EXPECT_LE(batch.vertices[0].x, batch.vertices[2].x);
        EXPECT_LE(batch.vertices[0].y, batch.vertices[2].y);
    }
}

TEST(MesWinFillRect, ZeroHeightSelectedSideStillDrawsPositiveBacking) {
    GlobalDrawRig rig;
    mgCDrawPrim   prim;
    RGBAQ_TYPE    color{.r = 128, .g = 128, .b = 128, .a = 32};
    const int     saved_abs_draw_off = MesAbsDrawOff;
    MesAbsDrawOff = 0;
    DrawVersatileWin_3(&prim, {.x = 100, .y = 100, .width = 180, .height = 120}, 132, &color, 32, 0);
    MesAbsDrawOff = saved_abs_draw_off;

    const Batch *backing = nullptr;
    for (const Batch &batch : rig.batches) {
        if (batch.vertices.size() == 4 && batch.vertices[0].x == 112.0f && batch.vertices[0].y == 115.0f) {
            backing = &batch;
        }
    }
    ASSERT_NE(backing, nullptr);
    ExpectAt(backing->vertices[2], 269.0f, 129.0f);
}
