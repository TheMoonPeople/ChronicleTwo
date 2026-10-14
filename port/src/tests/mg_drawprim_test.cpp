#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <span>
#include <vector>

#include "gfx/gfx.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"

namespace {

struct Batch {
    gfx::Primitive             primitive;
    std::vector<gfx::Vertex2D> vertices;
    gfx::TextureBinding        texture;
    gfx::DrawState             state;
};

class PrimRig {
public:
    PrimRig() {
        prim.draw_manager = &manager;
        manager.render_info = &render_info;
        prim.Initialize(&memory, &vif_packet);
        // The PC builder never sets write, so Data must find it null and skip the retail copy.
        prim.write = nullptr;
        mgPortSetPrimSink([this](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &texture, const gfx::DrawState &state) {
            batches.push_back({primitive, {vertices.begin(), vertices.end()}, texture, state});
        });
    }

    ~PrimRig() {
        mgPortSetPrimSink({});
    }

    PrimRig(const PrimRig &) = delete;
    PrimRig &operator=(const PrimRig &) = delete;

    mgCMemory          memory;
    sceVif1Packet      vif_packet{};
    mgRENDER_INFO      render_info{};
    mgCDrawManager     manager;
    mgCDrawPrim        prim;
    std::vector<Batch> batches;
};

class GsReset {
public:
    GsReset() = default;
    ~GsReset() {
        mgPortResetGs();
    }
    GsReset(const GsReset &) = delete;
    GsReset &operator=(const GsReset &) = delete;
};

class PacketRegistryReset {
public:
    PacketRegistryReset(const void *a, const void *b) : a_(a), b_(b) {}
    ~PacketRegistryReset() {
        mgPortClearPacketDraw(a_);
        mgPortClearPacketDraw(b_);
    }
    PacketRegistryReset(const PacketRegistryReset &) = delete;
    PacketRegistryReset &operator=(const PacketRegistryReset &) = delete;

private:
    const void *a_;
    const void *b_;
};

struct Corner {
    float x;
    float y;
};

// Four corners of a 10-pixel square; the expected batches below name them by index.
constexpr std::array<Corner, 4> kCorners = {{{0.0f, 0.0f}, {10.0f, 0.0f}, {0.0f, 10.0f}, {10.0f, 10.0f}}};

int Gs(float pixels) {
    return static_cast<int>(pixels * 16.0f);
}

float LogicalX(float pixels) {
    return mgPortLogicalX(Gs(pixels));
}

float LogicalY(float pixels) {
    return mgPortLogicalY(Gs(pixels));
}

void ExpectAt(const gfx::Vertex2D &v, float x, float y) {
    EXPECT_FLOAT_EQ(v.x, LogicalX(x));
    EXPECT_FLOAT_EQ(v.y, LogicalY(y));
}

void ExpectCornerOrder(const std::vector<gfx::Vertex2D> &out, const std::vector<int> &order) {
    ASSERT_EQ(out.size(), order.size());

    for (std::size_t i = 0; i < order.size(); ++i) {
        ExpectAt(out[i], kCorners[order[i]].x, kCorners[order[i]].y);
    }
}

std::array<uint8_t, 4> Rgba(const gfx::Vertex2D &v) {
    return {v.color[0], v.color[1], v.color[2], v.color[3]};
}

std::vector<gfx::Vertex2D> DrawTexturedSprite(PrimRig &rig, int bilinear, std::array<float, 4> dest,
                                              std::array<int, 4> uv) {
    rig.prim.Coord(1);
    rig.prim.TextureMapEnable(1);
    rig.prim.Bilinear(bilinear);
    mgCTexture source;
    rig.prim.Texture(&source);
    rig.prim.Begin(MG_PRIM_SPRITE);
    rig.prim.TextureCrd(uv[0], uv[1]);
    rig.prim.Vertex(dest[0], dest[1], 0.0f);
    rig.prim.TextureCrd(uv[2], uv[3]);
    rig.prim.Vertex(dest[2], dest[3], 0.0f);
    rig.prim.End2();

    EXPECT_EQ(rig.batches.size(), 1u);
    if (rig.batches.size() != 1u) {
        return {};
    }
    EXPECT_EQ(rig.batches[0].texture.filter, bilinear != 0 ? gfx::Filter::Linear : gfx::Filter::Nearest);
    return rig.batches[0].vertices;
}

// Corners are in quad order: (x0,y0), (x1,y0), (x1,y1), (x0,y1).
void ExpectQuadUv(const std::vector<gfx::Vertex2D> &q, float u0, float u1, float v0, float v1) {
    ASSERT_EQ(q.size(), 4u);
    EXPECT_FLOAT_EQ(q[0].u, u0);
    EXPECT_FLOAT_EQ(q[1].u, u1);
    EXPECT_FLOAT_EQ(q[2].u, u1);
    EXPECT_FLOAT_EQ(q[3].u, u0);
    EXPECT_FLOAT_EQ(q[0].v, v0);
    EXPECT_FLOAT_EQ(q[1].v, v0);
    EXPECT_FLOAT_EQ(q[2].v, v1);
    EXPECT_FLOAT_EQ(q[3].v, v1);
}

} // namespace

TEST(MgDrawPrim, SpriteBecomesQuadWithSecondVertexColour) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.Begin(MG_PRIM_SPRITE);
    rig.prim.Color(10, 20, 30, 40);
    rig.prim.TextureCrd(0, 0);
    rig.prim.Vertex(10.0f, 20.0f, 0.0f);
    rig.prim.Color(200, 100, 50, 255);
    rig.prim.TextureCrd(32, 16);
    rig.prim.Vertex(42.0f, 36.0f, 0.0f);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Quads);
    const std::vector<gfx::Vertex2D> &q = rig.batches[0].vertices;
    ASSERT_EQ(q.size(), 4u);

    ExpectAt(q[0], 10.0f, 20.0f);
    ExpectAt(q[1], 42.0f, 20.0f);
    ExpectAt(q[2], 42.0f, 36.0f);
    ExpectAt(q[3], 10.0f, 36.0f);
    EXPECT_FLOAT_EQ(q[1].x - q[0].x, 32.0f);
    EXPECT_FLOAT_EQ(q[2].y - q[0].y, 16.0f);

    EXPECT_FLOAT_EQ(q[0].u, 0.0f);
    EXPECT_FLOAT_EQ(q[0].v, 0.0f);
    EXPECT_FLOAT_EQ(q[1].u, 32.0f);
    EXPECT_FLOAT_EQ(q[1].v, 0.0f);
    EXPECT_FLOAT_EQ(q[2].u, 32.0f);
    EXPECT_FLOAT_EQ(q[2].v, 16.0f);
    EXPECT_FLOAT_EQ(q[3].u, 0.0f);
    EXPECT_FLOAT_EQ(q[3].v, 16.0f);

    for (const gfx::Vertex2D &v : q) {
        EXPECT_EQ(Rgba(v), (std::array<uint8_t, 4>{200, 100, 50, 255}));
    }
}

TEST(MgDrawPrim, TriangleStripExpandsToTriangles) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.Begin(MG_PRIM_TRIANGLE_STRIP);
    rig.prim.Vertex(0.0f, 0.0f, 0.0f);
    rig.prim.Vertex(10.0f, 0.0f, 0.0f);
    rig.prim.Vertex(0.0f, 10.0f, 0.0f);
    rig.prim.Vertex(10.0f, 10.0f, 0.0f);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Triangles);
    ExpectCornerOrder(rig.batches[0].vertices, {0, 1, 2, 1, 2, 3});
}

TEST(MgDrawPrim, TriangleFanExpandsToTriangles) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.Begin(MG_PRIM_TRIANGLE_FAN);
    rig.prim.Vertex(0.0f, 0.0f, 0.0f);
    rig.prim.Vertex(10.0f, 0.0f, 0.0f);
    rig.prim.Vertex(0.0f, 10.0f, 0.0f);
    rig.prim.Vertex(10.0f, 10.0f, 0.0f);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Triangles);
    ExpectCornerOrder(rig.batches[0].vertices, {0, 1, 2, 0, 2, 3});
}

TEST(MgDrawPrim, FlatShadingUsesLastVertexColour) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.Shading(0);
    rig.prim.Begin(MG_PRIM_TRIANGLE);
    rig.prim.Color(255, 0, 0, 255);
    rig.prim.Vertex(0.0f, 0.0f, 0.0f);
    rig.prim.Color(0, 255, 0, 255);
    rig.prim.Vertex(10.0f, 0.0f, 0.0f);
    rig.prim.Color(0, 0, 255, 255);
    rig.prim.Vertex(0.0f, 10.0f, 0.0f);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Triangles);
    ASSERT_EQ(rig.batches[0].vertices.size(), 3u);
    for (const gfx::Vertex2D &v : rig.batches[0].vertices) {
        EXPECT_EQ(Rgba(v), (std::array<uint8_t, 4>{0, 0, 255, 255}));
    }
}

TEST(MgDrawPrim, LineStripExpandsToLines) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.Begin(MG_PRIM_LINE_STRIP);
    rig.prim.Color(255, 0, 0, 255);
    rig.prim.Vertex(0.0f, 0.0f, 0.0f);
    rig.prim.Color(0, 255, 0, 255);
    rig.prim.Vertex(10.0f, 0.0f, 0.0f);
    rig.prim.Color(0, 0, 255, 255);
    rig.prim.Vertex(0.0f, 10.0f, 0.0f);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Lines);
    const std::vector<gfx::Vertex2D> &l = rig.batches[0].vertices;
    ExpectCornerOrder(l, {0, 1, 1, 2});
    EXPECT_EQ(Rgba(l[0]), (std::array<uint8_t, 4>{0, 255, 0, 255}));
    EXPECT_EQ(Rgba(l[1]), (std::array<uint8_t, 4>{0, 255, 0, 255}));
    EXPECT_EQ(Rgba(l[2]), (std::array<uint8_t, 4>{0, 0, 255, 255}));
    EXPECT_EQ(Rgba(l[3]), (std::array<uint8_t, 4>{0, 0, 255, 255}));
}

TEST(MgDrawPrim, PackedDataIsIgnored) {
    PrimRig rig;
    rig.prim.Begin2();
    rig.prim.BeginPrim2(MG_PRIM_SPRITE, 0x43, 0, 2);
    int uv0[4] = {0, 0, 0, 0};
    int xyz0[4] = {Gs(10.0f), Gs(20.0f), 0, 0};
    int uv1[4] = {512, 256, 0, 0};
    int xyz1[4] = {Gs(42.0f), Gs(36.0f), 0, 0};
    rig.prim.Data(uv0);
    rig.prim.Data(xyz0);
    rig.prim.Data(uv1);
    rig.prim.Data(xyz1);
    rig.prim.EndPrim2();
    rig.prim.End2();

    EXPECT_TRUE(rig.batches.empty());
}

TEST(MgDrawPrim, DirectScissorUpdatesGsState) {
    GsReset reset;
    mgCDrawPrim prim;
    const uint64_t scax0 = 10;
    const uint64_t scax1 = 100;
    const uint64_t scay0 = 20;
    const uint64_t scay1 = 200;
    prim.Direct(SCE_GS_SCISSOR_1, scax0 | (scax1 << 16) | (scay0 << 32) | (scay1 << 48));

    const int *scissor = mgPortGs().scissor;
    EXPECT_EQ(scissor[0], 10);
    EXPECT_EQ(scissor[1], 20);
    EXPECT_EQ(scissor[2], 100);
    EXPECT_EQ(scissor[3], 200);
}

TEST(MgDrawPrim, TextureChangeFlushesBatch) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.TextureMapEnable(1);
    mgCTexture source;
    rig.prim.Begin(MG_PRIM_SPRITE);
    rig.prim.Vertex(0.0f, 0.0f, 0.0f);
    rig.prim.Vertex(10.0f, 10.0f, 0.0f);
    rig.prim.Texture(&source);
    rig.prim.Vertex(20.0f, 20.0f, 0.0f);
    rig.prim.Vertex(30.0f, 30.0f, 0.0f);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 2u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 4u);
    ASSERT_EQ(rig.batches[1].vertices.size(), 4u);
    ExpectAt(rig.batches[0].vertices[0], 0.0f, 0.0f);
    ExpectAt(rig.batches[1].vertices[0], 20.0f, 20.0f);
}

TEST(MgDrawPrim, BlendAndFogFollowPrimBits) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.AlphaBlendEnable(1);
    rig.prim.FogEnable(1);
    rig.prim.Begin(MG_PRIM_POINT);
    rig.prim.Vertex(10.0f, 10.0f, 0.0f);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_TRUE(rig.batches[0].state.blend);
    EXPECT_TRUE(rig.batches[0].state.fog);
}

TEST(MgDrawPrim, DrawManagerReplaysRegisteredPackets) {
    int first_key = 0;
    int second_key = 0;
    int unknown_key = 0;
    int first_draws = 0;
    int second_draws = 0;

    PacketRegistryReset cleanup(&first_key, &second_key);
    mgPortSetPacketDraw(&first_key, [&first_draws] { ++first_draws; });
    mgPortSetPacketDraw(&second_key, [&second_draws] { ++second_draws; });

    EXPECT_TRUE(mgPortPacketDraw(&first_key));
    EXPECT_EQ(first_draws, 1);
    EXPECT_EQ(second_draws, 0);

    EXPECT_TRUE(mgPortPacketDraw(&second_key));
    EXPECT_EQ(first_draws, 1);
    EXPECT_EQ(second_draws, 1);

    EXPECT_FALSE(mgPortPacketDraw(&unknown_key));
    EXPECT_FALSE(mgPortPacketDraw(nullptr));

    mgPortClearPacketDraw(&first_key);
    EXPECT_FALSE(mgPortPacketDraw(&first_key));
    EXPECT_EQ(first_draws, 1);
    EXPECT_TRUE(mgPortPacketDraw(&second_key));
    EXPECT_EQ(second_draws, 2);
}

TEST(MgDrawPrim, PrimVertexAddsBuilderOffsetAfterGsScale) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.offset_x = 32;
    rig.prim.offset_y = 16;
    const uint8_t rgba[4] = {1, 2, 3, 4};

    const gfx::Vertex2D v = mgPortPrimVertex(rig.prim, 10.0f, 20.0f, 0.0f, 0.0f, 0.0f, rgba);
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(Gs(10.0f) + 32));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(Gs(20.0f) + 16));
}

TEST(MgDrawPrim, HostTextureFlushesInOrderWithoutChangingRetailBinding) {
    GsReset reset;
    PrimRig rig;
    rig.prim.TextureMapEnable(0);
    rig.prim.AlphaBlendEnable(1);
    rig.prim.Begin(MG_PRIM_SPRITE);
    rig.prim.Vertex(1, 2, 0);
    rig.prim.Vertex(11, 12, 0);
    EXPECT_TRUE(rig.batches.empty());
    const gfx::TextureBinding          texture{.texture = 123};
    const std::array<gfx::Vertex2D, 4> quad{};
    mgPortPrimSubmitTexture(rig.prim, quad, texture);
    ASSERT_EQ(rig.batches.size(), 2u);
    EXPECT_EQ(rig.batches[0].texture.texture, gfx::kNullTexture);
    EXPECT_EQ(rig.batches[1].texture.texture, 123u);
    EXPECT_TRUE(rig.batches[1].state.blend);
    rig.prim.Vertex(21, 22, 0);
    rig.prim.Vertex(31, 32, 0);
    rig.prim.End();
    ASSERT_EQ(rig.batches.size(), 3u);
    EXPECT_EQ(rig.batches[2].texture.texture, gfx::kNullTexture);
    rig.prim.disabled = 1;
    mgPortPrimSubmitTexture(rig.prim, quad, texture);
    EXPECT_EQ(rig.batches.size(), 3u);
}

TEST(MgDrawPrim, PrimVertexAtRawCoordinateMatchesLogicalMapping) {
    PrimRig rig;
    rig.prim.Coord(1);
    const uint8_t rgba[4] = {0, 0, 0, 0};

    const gfx::Vertex2D v = mgPortPrimVertex(rig.prim, 10.0f, 20.0f, 0.0f, 0.0f, 0.0f, rgba);
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(Gs(10.0f)));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(Gs(20.0f)));
}

TEST(MgDrawPrim, PrimVertexScreenOffsetCancelsInLogicalSpace) {
    PrimRig rig;
    const uint8_t rgba[4] = {0, 0, 0, 0};

    const gfx::Vertex2D v = mgPortPrimVertex(rig.prim, 10.0f, 20.0f, 0.0f, 0.0f, 0.0f, rgba);
    EXPECT_FLOAT_EQ(v.x, 10.0f);
    EXPECT_FLOAT_EQ(v.y, 20.0f);
}

TEST(MgDrawPrim, PrimVertexMapsZLikeDepthAndClamps) {
    PrimRig rig;
    const uint8_t rgba[4] = {0, 0, 0, 0};

    EXPECT_FLOAT_EQ(mgPortPrimVertex(rig.prim, 0.0f, 0.0f, 1000.0f, 0.0f, 0.0f, rgba).z, mgPortDepth(1000));
    EXPECT_FLOAT_EQ(mgPortPrimVertex(rig.prim, 0.0f, 0.0f, -5.0f, 0.0f, 0.0f, rgba).z, 0.0f);
    EXPECT_FLOAT_EQ(mgPortPrimVertex(rig.prim, 0.0f, 0.0f, 1e12f, 0.0f, 0.0f, rgba).z, 1.0f);
}

TEST(MgDrawPrim, PrimColorReturnsLastColourCall) {
    PrimRig rig;
    rig.prim.Begin2();
    rig.prim.Color(10, 20, 30, 40);

    uint8_t rgba[4] = {};
    mgPortPrimColor(rig.prim, rgba);
    EXPECT_EQ(rgba[0], 10);
    EXPECT_EQ(rgba[1], 20);
    EXPECT_EQ(rgba[2], 30);
    EXPECT_EQ(rgba[3], 40);
}

TEST(MgDrawPrim, HudBarKeepsColourAcrossBatches) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.Begin(MG_PRIM_TRIANGLE_STRIP);
    rig.prim.Color(0x80, 0x70, 0x60, 0x40);
    rig.prim.End();

    // The ABS bar and secondary WHP bar begin without repeating the preceding colour.
    rig.prim.Begin(MG_PRIM_TRIANGLE_STRIP);
    for (const Corner &corner : kCorners) {
        rig.prim.Vertex(corner.x, corner.y, 0.0f);
    }
    rig.prim.End();
    ASSERT_EQ(rig.batches.size(), 1u);
    for (const auto &vertex : rig.batches[0].vertices) {
        EXPECT_EQ(Rgba(vertex), (std::array<uint8_t, 4>{0x80, 0x70, 0x60, 0x40}));
    }
}

TEST(MgDrawPrim, ColourPersistsAcrossBuildersAndReinitialization) {
    PrimRig rig;
    rig.prim.Begin(MG_PRIM_POINT);
    rig.prim.Color(12, 34, 56, 0x80);
    rig.prim.End();
    mgCDrawPrim next;
    next.draw_manager = &rig.manager;
    next.Initialize(&rig.memory, &rig.vif_packet);
    next.Coord(1);
    next.Begin(MG_PRIM_POINT);
    next.Vertex(1.0f, 1.0f, 0.0f);
    next.End();
    rig.prim.Initialize(&rig.memory, &rig.vif_packet);
    rig.prim.Begin(MG_PRIM_POINT);
    rig.prim.Vertex(2.0f, 2.0f, 0.0f);
    rig.prim.End();
    ASSERT_EQ(rig.batches.size(), 2u);
    for (const auto &batch : rig.batches) {
        for (const auto &vertex : batch.vertices) {
            EXPECT_EQ(Rgba(vertex), (std::array<uint8_t, 4>{12, 34, 56, 0x80}));
        }
    }
}

// Retail keeps TEX0 in the GS: the second weapon's synth gauge re-Initializes its builder and binds nothing.
TEST(MgDrawPrim, TextureSurvivesReinitialization) {
    GsReset reset;
    mgPortGs().inherit_prim_texture = true;
    PrimRig    rig;
    mgCTexture source;
    source.Initialize();
    source.tex0.value = SCE_GS_SET_TEX0(0x3F00, 4, SCE_GS_PSMCT32, 8, 8, 1, 0, 0, 0, 0, 0, 0);
    rig.prim.Texture(&source);
    rig.prim.Initialize(&rig.memory, &rig.vif_packet);
    EXPECT_EQ(rig.prim.texture.tex0_bits, 0u);
    rig.prim.TextureMapEnable(1);
    rig.prim.Begin(MG_PRIM_TRIANGLE_STRIP);
    EXPECT_EQ(rig.prim.texture.tex0_bits, source.tex0_bits);
    rig.prim.End();
}

// Another builder whose Texture() got null keeps drawing without one rather than with the last builder's texture.
TEST(MgDrawPrim, RetainedTextureStaysWithItsBuilder) {
    GsReset reset;
    mgPortGs().inherit_prim_texture = true;
    PrimRig    rig;
    mgCTexture source;
    source.Initialize();
    source.tex0.value = SCE_GS_SET_TEX0(0x3F00, 4, SCE_GS_PSMCT32, 8, 8, 1, 0, 0, 0, 0, 0, 0);
    rig.prim.Texture(&source);
    mgCDrawPrim other;
    other.draw_manager = &rig.manager;
    other.Initialize(&rig.memory, &rig.vif_packet);
    other.TextureMapEnable(1);
    other.Begin(MG_PRIM_SPRITE);
    other.Texture(nullptr);
    EXPECT_EQ(other.texture.tex0_bits, 0u);
    other.End();
}

TEST(MgDrawPrim, PrimSubmitFlushesPendingBatchFirst) {
    PrimRig rig;
    rig.prim.Coord(1);
    rig.prim.Begin(MG_PRIM_POINT);
    rig.prim.Vertex(10.0f, 10.0f, 0.0f);

    const uint8_t white[4] = {255, 255, 255, 255};
    const std::vector<gfx::Vertex2D> tri = {
        mgPortPrimVertex(rig.prim, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, white),
        mgPortPrimVertex(rig.prim, 10.0f, 0.0f, 0.0f, 0.0f, 0.0f, white),
        mgPortPrimVertex(rig.prim, 0.0f, 10.0f, 0.0f, 0.0f, 0.0f, white),
    };
    mgPortPrimSubmit(rig.prim, gfx::Primitive::Triangles, tri);

    ASSERT_EQ(rig.batches.size(), 2u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Quads);
    EXPECT_EQ(rig.batches[1].primitive, gfx::Primitive::Triangles);
    EXPECT_EQ(rig.batches[1].vertices.size(), 3u);

    rig.prim.End2();
    EXPECT_EQ(rig.batches.size(), 2u);
}

TEST(MgDrawPrim, PrimSubmitUsesLastColourForFlatTriangles) {
    PrimRig rig;
    rig.prim.Begin2();
    rig.prim.Shading(0);

    const uint8_t red[4] = {255, 0, 0, 255};
    const uint8_t blue[4] = {0, 0, 255, 255};
    const std::vector<gfx::Vertex2D> tri = {
        mgPortPrimVertex(rig.prim, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, red),
        mgPortPrimVertex(rig.prim, 10.0f, 0.0f, 0.0f, 0.0f, 0.0f, red),
        mgPortPrimVertex(rig.prim, 0.0f, 10.0f, 0.0f, 0.0f, 0.0f, blue),
    };
    mgPortPrimSubmit(rig.prim, gfx::Primitive::Triangles, tri);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 3u);
    for (const gfx::Vertex2D &v : rig.batches[0].vertices) {
        EXPECT_EQ(Rgba(v), (std::array<uint8_t, 4>{0, 0, 255, 255}));
    }
}

TEST(MgDrawPrim, PrimSubmitKeepsVertexColoursWhenShaded) {
    PrimRig rig;
    rig.prim.Begin2();
    rig.prim.Shading(1);

    const uint8_t red[4] = {255, 0, 0, 255};
    const uint8_t blue[4] = {0, 0, 255, 255};
    const std::vector<gfx::Vertex2D> tri = {
        mgPortPrimVertex(rig.prim, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, red),
        mgPortPrimVertex(rig.prim, 10.0f, 0.0f, 0.0f, 0.0f, 0.0f, red),
        mgPortPrimVertex(rig.prim, 0.0f, 10.0f, 0.0f, 0.0f, 0.0f, blue),
    };
    mgPortPrimSubmit(rig.prim, gfx::Primitive::Triangles, tri);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(Rgba(rig.batches[0].vertices[0]), (std::array<uint8_t, 4>{255, 0, 0, 255}));
    EXPECT_EQ(Rgba(rig.batches[0].vertices[2]), (std::array<uint8_t, 4>{0, 0, 255, 255}));
}

TEST(MgDrawPrim, PrimSubmitDrawsNothingWhileDisabled) {
    PrimRig rig;
    const uint8_t white[4] = {255, 255, 255, 255};
    const std::vector<gfx::Vertex2D> tri = {
        mgPortPrimVertex(rig.prim, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, white),
        mgPortPrimVertex(rig.prim, 10.0f, 0.0f, 0.0f, 0.0f, 0.0f, white),
        mgPortPrimVertex(rig.prim, 0.0f, 10.0f, 0.0f, 0.0f, 0.0f, white),
    };
    mgPortPrimSubmit(rig.prim, gfx::Primitive::Triangles, tri);

    EXPECT_TRUE(rig.batches.empty());
}

TEST(MgDrawPrim, StripTrianglesFollowAssemblyOrder) {
    std::vector<gfx::Vertex2D> strip(4);
    for (std::size_t i = 0; i < strip.size(); ++i) {
        strip[i].x = static_cast<float>(i);
    }

    std::vector<gfx::Vertex2D> out;
    mgPortStripTriangles(strip, out);

    ASSERT_EQ(out.size(), 6u);
    const float expected[6] = {0.0f, 1.0f, 2.0f, 1.0f, 2.0f, 3.0f};
    for (std::size_t i = 0; i < out.size(); ++i) {
        EXPECT_FLOAT_EQ(out[i].x, expected[i]);
    }
}

TEST(MgDrawPrim, FontCellUvOneTexelWiderMapsToCell) {
    PrimRig rig;
    const std::vector<gfx::Vertex2D> q = DrawTexturedSprite(rig, 0, {136.0f, 248.0f, 144.0f, 268.0f}, {0, 0, 9, 21});

    ExpectQuadUv(q, kMgPortNearestTexelBias, 8.0f + kMgPortNearestTexelBias, kMgPortNearestTexelBias,
                 20.0f + kMgPortNearestTexelBias);
}

TEST(MgDrawPrim, FullWidthFontCellUvOneTexelWiderMapsToCell) {
    PrimRig rig;
    const std::vector<gfx::Vertex2D> q = DrawTexturedSprite(rig, 0, {136.0f, 248.0f, 152.0f, 268.0f}, {0, 0, 17, 21});

    ExpectQuadUv(q, kMgPortNearestTexelBias, 16.0f + kMgPortNearestTexelBias, kMgPortNearestTexelBias,
                 20.0f + kMgPortNearestTexelBias);
}

TEST(MgDrawPrim, NearestTileSeamSamplesTheTileTexel) {
    PrimRig rig;
    const std::vector<gfx::Vertex2D> q = DrawTexturedSprite(rig, 0, {47.0f, 0.0f, 303.0f, 8.0f}, {256, 0, 512, 8});

    ExpectQuadUv(q, 256.0f + kMgPortNearestTexelBias, 512.0f + kMgPortNearestTexelBias, kMgPortNearestTexelBias,
                 8.0f + kMgPortNearestTexelBias);
}

TEST(MgDrawPrim, OneToOneSpriteUvIsUnchanged) {
    PrimRig rig;
    const std::vector<gfx::Vertex2D> q = DrawTexturedSprite(rig, 0, {100.0f, 50.0f, 123.0f, 75.0f}, {0, 0, 23, 25});

    ExpectQuadUv(q, kMgPortNearestTexelBias, 23.0f + kMgPortNearestTexelBias, kMgPortNearestTexelBias,
                 25.0f + kMgPortNearestTexelBias);
}

TEST(MgDrawPrim, StretchedTwoTexelStripUvIsUnchanged) {
    PrimRig rig;
    const std::vector<gfx::Vertex2D> q = DrawTexturedSprite(rig, 0, {0.0f, 0.0f, 175.0f, 8.0f}, {231, 0, 233, 8});

    ExpectQuadUv(q, 231.0f + kMgPortNearestTexelBias, 233.0f + kMgPortNearestTexelBias, kMgPortNearestTexelBias,
                 8.0f + kMgPortNearestTexelBias);
}

TEST(MgDrawPrim, FlippedSpriteUvMapsToTexelEdges) {
    PrimRig rig;
    const std::vector<gfx::Vertex2D> q = DrawTexturedSprite(rig, 0, {0.0f, 0.0f, 16.0f, 10.0f}, {16, 0, 0, 10});

    ExpectQuadUv(q, 17.0f + kMgPortNearestTexelBias, 1.0f + kMgPortNearestTexelBias, kMgPortNearestTexelBias,
                 10.0f + kMgPortNearestTexelBias);
}

TEST(MgDrawPrim, EqualUvSpriteCoversOneTexel) {
    PrimRig rig;
    const std::vector<gfx::Vertex2D> q = DrawTexturedSprite(rig, 0, {0.0f, 0.0f, 10.0f, 10.0f}, {5, 5, 5, 5});

    ExpectQuadUv(q, 5.0f + kMgPortNearestTexelBias, 6.0f + kMgPortNearestTexelBias, 5.0f + kMgPortNearestTexelBias,
                 6.0f + kMgPortNearestTexelBias);
    EXPECT_FLOAT_EQ(mgPortSpriteTexelSpan(0.0f, 10.0f, 5.5f, 5.5f).first, 5.0f);
    EXPECT_FLOAT_EQ(mgPortSpriteTexelSpan(0.0f, 10.0f, 5.5f, 5.5f).second, 6.0f);
}

TEST(MgDrawPrim, LinearFontSpriteSamplesAtGsIntegerPixelLocations) {
    PrimRig rig;
    const std::vector<gfx::Vertex2D> q = DrawTexturedSprite(rig, 1, {136.0f, 248.0f, 144.0f, 268.0f}, {0, 0, 9, 21});

    ExpectQuadUv(q, -0.5625f, 8.4375f, -0.525f, 20.475f);
}

TEST(MgDrawPrim, LinearSpriteOffsetFollowsScaledAndFlippedUvSlopes) {
    PrimRig rig;
    const auto q = DrawTexturedSprite(rig, 1, {10, 20, 42, 28}, {24, 40, 8, 72});
    // Half a destination pixel corresponds to -0.25 U and +2 V here.
    ExpectQuadUv(q, 24.25f, 8.25f, 38, 70);
}

// The same builder asking for a texture that is not loaded drops the one Begin filled in.
TEST(MgDrawPrim, NullTextureDropsInheritedTexture) {
    GsReset reset;
    mgPortGs().inherit_prim_texture = true;
    PrimRig    rig;
    mgCTexture source;
    source.Initialize();
    source.tex0.value = SCE_GS_SET_TEX0(0x3F00, 4, SCE_GS_PSMCT32, 8, 8, 1, 0, 0, 0, 0, 0, 0);
    rig.prim.Texture(&source);
    rig.prim.Initialize(&rig.memory, &rig.vif_packet);
    rig.prim.TextureMapEnable(1);
    rig.prim.Begin(MG_PRIM_SPRITE);
    EXPECT_EQ(rig.prim.texture.tex0_bits, source.tex0_bits);
    rig.prim.Texture(nullptr);
    EXPECT_EQ(rig.prim.texture.tex0_bits, 0u);
    rig.prim.End();
}

// Outside the status board an Initialized builder draws without the retained texture, as before.
TEST(MgDrawPrim, TextureNotInheritedOutsideStatusBoard) {
    GsReset    reset;
    PrimRig    rig;
    mgCTexture source;
    source.Initialize();
    source.tex0.value = SCE_GS_SET_TEX0(0x3F00, 4, SCE_GS_PSMCT32, 8, 8, 1, 0, 0, 0, 0, 0, 0);
    rig.prim.Texture(&source);
    rig.prim.Initialize(&rig.memory, &rig.vif_packet);
    rig.prim.TextureMapEnable(1);
    rig.prim.Begin(MG_PRIM_TRIANGLE_STRIP);
    EXPECT_EQ(rig.prim.texture.tex0_bits, 0u);
    rig.prim.End();
}
