#include <gtest/gtest.h>

#include <span>
#include <vector>

#include "gfx/gfx.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mglib.hpp"

void DivSpriteScreen(mgCDrawPrim &prim);
void DivSpriteScreen(mgCDrawPrim &prim, int left, int right, int jagged_left);

namespace {

struct Batch {
    gfx::Primitive             primitive;
    std::vector<gfx::Vertex2D> vertices;
};

class Harness {
public:
    Harness()
        : saved_width_(mgScreenWidth), saved_height_(mgScreenHeight), saved_offx_(mgScreenOffx),
          saved_offy_(mgScreenOffy) {
        prim.draw_manager = &manager;
        manager.render_info = &render_info;
        prim.Initialize(&memory, &vif_packet);
        prim.write = nullptr;
        mgPortSetPrimSink([this](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &, const gfx::DrawState &) {
            batches.push_back({
                .primitive = primitive, .vertices = {vertices.begin(), vertices.end()}
            });
        });
    }

    ~Harness() {
        mgPortSetPrimSink({});
        mgScreenWidth = saved_width_;
        mgScreenHeight = saved_height_;
        mgScreenOffx = saved_offx_;
        mgScreenOffy = saved_offy_;
    }

    Harness(const Harness &) = delete;
    Harness &operator=(const Harness &) = delete;

    static void Screen(int width, int height, int offx, int offy) {
        mgScreenWidth = width;
        mgScreenHeight = height;
        mgScreenOffx = offx;
        mgScreenOffy = offy;
    }

    mgCMemory          memory;
    sceVif1Packet      vif_packet{};
    mgRENDER_INFO      render_info{};
    mgCDrawManager     manager;
    mgCDrawPrim        prim;
    std::vector<Batch> batches;

private:
    int saved_width_;
    int saved_height_;
    int saved_offx_;
    int saved_offy_;
};

} // namespace

TEST(EffectListDraw, SpriteFadeIsOneBatchOfScreenQuads) {
    Harness h;
    Harness::Screen(512, 480, 77, 13);
    h.prim.Begin2();
    h.prim.Color(10, 20, 30, 40);
    DivSpriteScreen(h.prim);
    h.prim.End2();

    ASSERT_EQ(h.batches.size(), 1u);
    EXPECT_EQ(h.batches[0].primitive, gfx::Primitive::Quads);
    const std::vector<gfx::Vertex2D> &v = h.batches[0].vertices;
    ASSERT_EQ(v.size(), 480u);

    // Quads run down each 64-pixel column before the next column, so quad 1 is the block at (0, 32).
    EXPECT_FLOAT_EQ(v[4].x, 0.0f);
    EXPECT_FLOAT_EQ(v[4].y, 32.0f);
    EXPECT_FLOAT_EQ(v[6].x, 64.0f);
    EXPECT_FLOAT_EQ(v[6].y, 64.0f);
    EXPECT_FLOAT_EQ(v[4].u, 0.0f);
    EXPECT_FLOAT_EQ(v[4].v, 32.0f);

    // The last quad closes the screen at (512, 480).
    EXPECT_FLOAT_EQ(v[478].x, 512.0f);
    EXPECT_FLOAT_EQ(v[478].y, 480.0f);

    for (const gfx::Vertex2D &corner : v) {
        EXPECT_EQ(corner.color[0], 10);
        EXPECT_EQ(corner.color[1], 20);
        EXPECT_EQ(corner.color[2], 30);
        EXPECT_EQ(corner.color[3], 40);
    }
}

TEST(EffectListDraw, EdgeStripAlternatesLeftAndRightEdges) {
    Harness h;
    Harness::Screen(512, 480, 77, 13);
    h.prim.Begin2();
    DivSpriteScreen(h.prim, 100, 300, 0);
    h.prim.End2();

    ASSERT_EQ(h.batches.size(), 1u);
    EXPECT_EQ(h.batches[0].primitive, gfx::Primitive::Triangles);
    const std::vector<gfx::Vertex2D> &v = h.batches[0].vertices;
    ASSERT_EQ(v.size(), 96u);

    // Rows are 480 / 16 = 30 pixels apart. Without jagging only the right edge takes the row's +-10 offset.
    EXPECT_FLOAT_EQ(v[0].x, 100.0f);
    EXPECT_FLOAT_EQ(v[0].y, 0.0f);
    EXPECT_FLOAT_EQ(v[1].x, 290.0f);
    EXPECT_FLOAT_EQ(v[1].y, 0.0f);
    EXPECT_FLOAT_EQ(v[2].x, 100.0f);
    EXPECT_FLOAT_EQ(v[2].y, 30.0f);
    EXPECT_FLOAT_EQ(v[5].x, 310.0f);
    EXPECT_FLOAT_EQ(v[5].y, 30.0f);
}

TEST(EffectListDraw, JaggedStripOffsetsLeftEdgeByRowParity) {
    Harness h;
    Harness::Screen(512, 480, 77, 13);
    h.prim.Begin2();
    DivSpriteScreen(h.prim, 100, 300, 1);
    h.prim.End2();

    ASSERT_EQ(h.batches.size(), 1u);
    const std::vector<gfx::Vertex2D> &v = h.batches[0].vertices;
    ASSERT_EQ(v.size(), 96u);

    EXPECT_FLOAT_EQ(v[0].x, 90.0f);
    EXPECT_FLOAT_EQ(v[1].x, 300.0f);
    EXPECT_FLOAT_EQ(v[2].x, 110.0f);
    EXPECT_FLOAT_EQ(v[2].y, 30.0f);
}
