#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <span>
#include <vector>

#include "gfx/gfx.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_sprite.hpp"
#include "mg_sprite_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "prespr.hpp"

namespace {

struct Batch {
    gfx::Primitive             primitive;
    std::vector<gfx::Vertex2D> vertices;
    gfx::TextureBinding        texture;
    gfx::DrawState             state;
    gfx::Interp2D              tag{}; /**< Interpolation tag current at the draw; billboard rigs only. */
};

class SinkRig {
public:
    SinkRig() {
        mgPortSetPrimSink([this](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &texture, const gfx::DrawState &state) {
            batches.push_back({
                .primitive = primitive, .vertices = {vertices.begin(), vertices.end()},
                     .texture = texture, .state = state
            });
        });
    }

    ~SinkRig() {
        mgPortSetPrimSink({});
    }

    SinkRig(const SinkRig &) = delete;
    SinkRig &operator=(const SinkRig &) = delete;

    std::vector<Batch> batches;
};

class ScreenOffsetScope {
public:
    ScreenOffsetScope(int x, int y) : saved_x_(mgScreenOffx), saved_y_(mgScreenOffy) {
        mgScreenOffx = x;
        mgScreenOffy = y;
    }

    ~ScreenOffsetScope() {
        mgScreenOffx = saved_x_;
        mgScreenOffy = saved_y_;
    }

    ScreenOffsetScope(const ScreenOffsetScope &) = delete;
    ScreenOffsetScope &operator=(const ScreenOffsetScope &) = delete;

private:
    int saved_x_;
    int saved_y_;
};

class VifPacketScope {
public:
    explicit VifPacketScope(sceVif1Packet *packet) : saved_(mgVif1Packet) {
        mgVif1Packet = packet;
    }

    ~VifPacketScope() {
        mgVif1Packet = saved_;
    }

    VifPacketScope(const VifPacketScope &) = delete;
    VifPacketScope &operator=(const VifPacketScope &) = delete;

private:
    sceVif1Packet *saved_;
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

std::array<uint8_t, 4> Rgba(const gfx::Vertex2D &v) {
    return {v.color[0], v.color[1], v.color[2], v.color[3]};
}

} // namespace

TEST(MgSprite, UntexturedSpriteSubmitsOneQuad) {
    const int offset = 0x800;
    ScreenOffsetScope screen_offset(offset, offset);
    sceVif1Packet vif_packet{};
    VifPacketScope vif(&vif_packet);
    SinkRig rig;

    mgRENDER_INFO render_info{};
    mgCDrawManager manager;
    manager.render_info = &render_info;

    mgCSprite sprite;
    sprite.screen.Set(16 * 10, 16 * 20, 16 * 42, 16 * 36);
    sprite.SetColor(1, 2, 3, 4);
    sprite.CreatePacket(&manager);

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Quads);
    const std::vector<gfx::Vertex2D> &q = rig.batches[0].vertices;
    ASSERT_EQ(q.size(), 4u);

    const auto logical_x = [](int gs_x) { return mgPortLogicalX(gs_x + (offset << 4)); };
    const auto logical_y = [](int gs_y) { return mgPortLogicalY(gs_y + (offset << 4)); };

    EXPECT_FLOAT_EQ(q[0].x, logical_x(16 * 10));
    EXPECT_FLOAT_EQ(q[0].y, logical_y(16 * 20));
    EXPECT_FLOAT_EQ(q[2].x, logical_x(16 * 42));
    EXPECT_FLOAT_EQ(q[2].y, logical_y(16 * 36));
    EXPECT_FLOAT_EQ(q[1].x - q[0].x, 32.0f);

    for (const gfx::Vertex2D &v : q) {
        EXPECT_EQ(Rgba(v), (std::array<uint8_t, 4>{1, 2, 3, 4}));
    }
}

TEST(MgSprite, DrawSubmitsSameQuadAndWritesNoDmaChain) {
    const int offset = 0x800;
    ScreenOffsetScope screen_offset(offset, offset);
    sceVif1Packet vif_packet{};
    VifPacketScope vif(&vif_packet);
    SinkRig rig;

    mgRENDER_INFO render_info{};
    mgCDrawManager manager;
    manager.render_info = &render_info;

    mgCSprite sprite;
    sprite.screen.Set(16 * 10, 16 * 20, 16 * 42, 16 * 36);
    sprite.SetColor(1, 2, 3, 4);

    u_int tag[8] = {0xDEADBEEF, 0xDEADBEEF, 0xDEADBEEF, 0xDEADBEEF, 0xDEADBEEF, 0xDEADBEEF, 0xDEADBEEF, 0xDEADBEEF};
    const int qwords = sprite.Draw(tag, nullptr, &manager);

    EXPECT_EQ(qwords, 0);
    for (u_int word : tag) {
        EXPECT_EQ(word, 0xDEADBEEFu);
    }
    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Quads);
    EXPECT_EQ(rig.batches[0].vertices.size(), 4u);
}

TEST(MgSprite, PreSpriteSetScirorWritesScissorEdges) {
    GsReset reset;
    CPreSprite sprite;
    sprite.SetScirror(10, 20, 30, 40);

    const int *scissor = mgPortGs().scissor;
    EXPECT_EQ(scissor[0], 10);
    EXPECT_EQ(scissor[1], 20);
    EXPECT_EQ(scissor[2], 40);
    EXPECT_EQ(scissor[3], 60);
}

TEST(MgSprite, PreSpriteSetAlphaBlendWritesAddEquation) {
    GsReset reset;
    CPreSprite sprite;
    sprite.SetAlphaBlend(2);
    EXPECT_EQ(mgPortGs().alpha, 0x48u);
}

TEST(MgSprite, PreSpriteSetAlphaBlendModeZeroWritesNothing) {
    GsReset reset;
    CPreSprite sprite;
    sprite.SetAlphaBlend(2);
    const uint64_t before = mgPortGs().alpha;
    sprite.SetAlphaBlend(0);
    EXPECT_EQ(mgPortGs().alpha, before);
}

namespace {

class BillboardRig {
public:
    BillboardRig() {
        mgPortSet3DSpriteSink([this](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                     const gfx::TextureBinding &texture, const gfx::DrawState &state) {
            batches.push_back({
                .primitive = primitive, .vertices = {vertices.begin(), vertices.end()},
                     .texture = texture, .state = state, .tag = gfx::CurrentInterp2D()
            });
        });
    }

    ~BillboardRig() {
        mgPortSet3DSpriteSink({});
    }

    BillboardRig(const BillboardRig &) = delete;
    BillboardRig &operator=(const BillboardRig &) = delete;

    std::vector<Batch> batches;
};

// A camera whose origin projects to the GS centre (2048, 2048) with w = depth_w; 8 and 6 units of size make 4 and 3 pixels.
void SetOriginCamera(mgRENDER_INFO &render_info, float depth_w, float near_dist, float far_dist) {
    render_info.world_screen[0][0] = 2.0f;
    render_info.world_screen[1][1] = 2.0f;
    render_info.world_screen[2][2] = 1.0f;
    render_info.world_screen[3][0] = 2048.0f * depth_w;
    render_info.world_screen[3][1] = 2048.0f * depth_w;
    render_info.world_screen[3][2] = 10.0f * depth_w;
    render_info.world_screen[3][3] = depth_w;
    render_info.view_screen[0][0] = 2.0f;
    render_info.view_screen[1][1] = 2.0f;
    render_info.guard_min[3] = near_dist;
    render_info.guard_max[3] = far_dist;
    render_info.fog.offset = 0.5f;
    render_info.fog.near_value = 1.0f;
    render_info.fog.far_value = 0.0f;
    render_info.fog.scale = 8.0f;
    render_info.fog.r = 10;
    render_info.fog.g = 20;
    render_info.fog.b = 30;
}

float kIdentity[4][4] = {{1.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 1.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 1.0f, 0.0f}, {0.0f, 0.0f, 0.0f, 1.0f}};

void AddBillboard(mgC3DSprite &sprite, float angle) {
    float pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float size[4] = {8.0f, 6.0f, angle, 0.0f};
    float colour[4] = {128.0f, 128.0f, 128.0f, 96.0f};
    float uv0[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float uv1[4] = {16.0f, 16.0f, 0.0f, 0.0f};
    sprite.CPSetSprite(pos, size, colour, uv0, uv1);
}

} // namespace

TEST(MgSprite, SpriteAtOriginLandsAtCentre) {
    const int offset = 0x800;
    ScreenOffsetScope screen_offset(offset, offset);
    BillboardRig rig;

    mgRENDER_INFO render_info{};
    SetOriginCamera(render_info, 4.0f, 1.0f, 200.0f);
    mgCFrameAttr attr;
    attr.Initialize();
    attr.fog = MG_FOG_OFF;
    render_info.attr = &attr;
    mgCDrawManager manager;
    manager.render_info = &render_info;

    mgC3DSprite sprite;
    sprite.BeginCreatePacket(MG_3DSPRITE_MODE_UPRIGHT, &manager);
    sprite.BeginCPSprite();
    AddBillboard(sprite, 0.0f);
    sprite.EndCPSprite();
    sprite.EndCreatePacket();

    u_int tag[4] = {0xDEADBEEF, 0xDEADBEEF, 0xDEADBEEF, 0xDEADBEEF};
    EXPECT_EQ(sprite.Draw(tag, kIdentity, &manager), 0);
    for (u_int word : tag) {
        EXPECT_EQ(word, 0xDEADBEEFu);
    }

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Quads);
    const std::vector<gfx::Vertex2D> &q = rig.batches[0].vertices;
    ASSERT_EQ(q.size(), 4u);

    const float centre_x = (q[0].x + q[2].x) * 0.5f;
    const float centre_y = (q[0].y + q[2].y) * 0.5f;
    EXPECT_NEAR(centre_x, mgPortLogicalX(2048 << 4), 0.5f);
    EXPECT_NEAR(centre_y, mgPortLogicalY(2048 << 4), 0.5f);
    EXPECT_FLOAT_EQ(q[1].x - q[0].x, 4.0f);
    EXPECT_FLOAT_EQ(q[3].y - q[0].y, 3.0f);
}

TEST(MgSprite, RotatedModeEmitsTriangles) {
    const int offset = 0x800;
    ScreenOffsetScope screen_offset(offset, offset);
    BillboardRig rig;

    mgRENDER_INFO render_info{};
    SetOriginCamera(render_info, 4.0f, 1.0f, 200.0f);
    mgCDrawManager manager;
    manager.render_info = &render_info;

    mgC3DSprite sprite;
    sprite.BeginCreatePacket(MG_3DSPRITE_MODE_ROTATE, &manager);
    sprite.BeginCPSprite();
    AddBillboard(sprite, 1.5707963f);
    sprite.EndCPSprite();
    sprite.EndCreatePacket();
    sprite.Draw(nullptr, kIdentity, &manager);

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].primitive, gfx::Primitive::Triangles);
    EXPECT_EQ(rig.batches[0].vertices.size(), 6u);
}

TEST(MgSprite, FogColourZeroForAdditive) {
    const int offset = 0x800;
    ScreenOffsetScope screen_offset(offset, offset);
    BillboardRig rig;

    mgRENDER_INFO render_info{};
    SetOriginCamera(render_info, 4.0f, 1.0f, 200.0f);
    mgCFrameAttr attr;
    attr.Initialize();
    attr.fog = MG_FOG_OFF;
    render_info.attr = &attr;
    mgCDrawManager manager;
    manager.render_info = &render_info;

    mgCDrawEnv env;
    env.SetAlpha(MG_ALPHA_MACRO_ADD);

    mgC3DSprite sprite;
    sprite.BeginCreatePacket(MG_3DSPRITE_MODE_UPRIGHT, &manager);
    sprite.CPSetDrawEnv(&env);
    sprite.BeginCPSprite();
    AddBillboard(sprite, 0.0f);
    sprite.EndCPSprite();
    sprite.EndCreatePacket();
    sprite.Draw(nullptr, kIdentity, &manager);

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].state.fog_color[0], 0);
    EXPECT_EQ(rig.batches[0].state.fog_color[1], 0);
    EXPECT_EQ(rig.batches[0].state.fog_color[2], 0);
}

TEST(MgSprite, FogColourKeptForOpaque) {
    const int offset = 0x800;
    ScreenOffsetScope screen_offset(offset, offset);
    BillboardRig rig;

    mgRENDER_INFO render_info{};
    SetOriginCamera(render_info, 4.0f, 1.0f, 200.0f);
    mgCFrameAttr attr;
    attr.Initialize();
    attr.fog = MG_FOG_OFF;
    render_info.attr = &attr;
    mgCDrawManager manager;
    manager.render_info = &render_info;

    mgCDrawEnv env;
    env.SetAlpha(MG_ALPHA_MACRO_OPAQUE);

    mgC3DSprite sprite;
    sprite.BeginCreatePacket(MG_3DSPRITE_MODE_UPRIGHT, &manager);
    sprite.CPSetDrawEnv(&env);
    sprite.BeginCPSprite();
    AddBillboard(sprite, 0.0f);
    sprite.EndCPSprite();
    sprite.EndCreatePacket();
    sprite.Draw(nullptr, kIdentity, &manager);

    ASSERT_EQ(rig.batches.size(), 1u);
    EXPECT_EQ(rig.batches[0].state.fog_color[0], 10);
    EXPECT_EQ(rig.batches[0].state.fog_color[1], 20);
    EXPECT_EQ(rig.batches[0].state.fog_color[2], 30);
}

TEST(MgSprite, BehindNearPlaneIsNotDrawn) {
    const int offset = 0x800;
    ScreenOffsetScope screen_offset(offset, offset);
    BillboardRig rig;

    mgRENDER_INFO render_info{};
    SetOriginCamera(render_info, 0.5f, 1.0f, 200.0f);
    mgCDrawManager manager;
    manager.render_info = &render_info;

    mgC3DSprite sprite;
    sprite.BeginCreatePacket(MG_3DSPRITE_MODE_UPRIGHT, &manager);
    sprite.BeginCPSprite();
    AddBillboard(sprite, 0.0f);
    sprite.EndCPSprite();
    sprite.EndCreatePacket();
    sprite.Draw(nullptr, kIdentity, &manager);

    EXPECT_TRUE(rig.batches.empty());
}

TEST(MgSprite, DrawWithoutBuiltPacketSubmitsNothing) {
    BillboardRig rig;

    mgRENDER_INFO render_info{};
    SetOriginCamera(render_info, 4.0f, 1.0f, 200.0f);
    mgCDrawManager manager;
    manager.render_info = &render_info;

    mgC3DSprite sprite;
    EXPECT_EQ(sprite.Draw(nullptr, kIdentity, &manager), 0);
    EXPECT_TRUE(rig.batches.empty());
}

TEST(MgSprite, TaggedBatchDrawsUnderItsTagAndOthersUnderTheCurrentOne) {
    ScreenOffsetScope screen_offset(0x800, 0x800);
    BillboardRig      rig;

    mgRENDER_INFO render_info{};
    SetOriginCamera(render_info, 4.0f, 1.0f, 200.0f);
    mgCDrawManager manager;
    manager.render_info = &render_info;

    const gfx::Interp2D own{.key = 73, .generation = 4, .world_corners = true, .teleport_distance = 50.0f};
    mgC3DSprite         sprite;
    sprite.BeginCreatePacket(MG_3DSPRITE_MODE_ROTATE, &manager);
    mgPortTag3DSpriteBatch(&sprite, own); // No batch is open yet, so this tags nothing.
    sprite.BeginCPSprite();
    mgPortTag3DSpriteBatch(&sprite, own);
    AddBillboard(sprite, 0.0f);
    sprite.EndCPSprite();
    sprite.BeginCPSprite();
    AddBillboard(sprite, 0.5f);
    sprite.EndCPSprite();
    sprite.EndCreatePacket();
    {
        const gfx::Interp2DScope outer({.key = 9, .generation = 2});
        sprite.Draw(nullptr, kIdentity, &manager);
        EXPECT_EQ(gfx::CurrentInterp2D().key, 9u);
    }

    ASSERT_EQ(rig.batches.size(), 2u);
    EXPECT_EQ(rig.batches[0].tag.key, 73u);
    EXPECT_EQ(rig.batches[0].tag.generation, 4u);
    EXPECT_TRUE(rig.batches[0].tag.world_corners);
    EXPECT_EQ(rig.batches[0].tag.teleport_distance, 50.0f);
    EXPECT_EQ(rig.batches[1].tag.key, 9u);
    EXPECT_EQ(rig.batches[1].tag.generation, 2u);
    EXPECT_FALSE(rig.batches[1].tag.world_corners);
}
