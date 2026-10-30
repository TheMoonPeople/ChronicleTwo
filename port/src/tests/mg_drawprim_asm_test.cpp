#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <cstring>
#include <limits>
#include <span>
#include <vector>

#include "gfx/gfx.hpp"
#include "mg_drawprim.hpp"
#include "mglib.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"

namespace {

void ReadLanes(const u_long128 *quad, int *lanes) {
    memcpy(lanes, quad, sizeof(int) * 4);
}

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
        prim.write_buffer = {};
        mgPortSetPrimSink([this](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &texture, const gfx::DrawState &state) {
            batches.push_back({
                .primitive = primitive, .vertices = {vertices.begin(), vertices.end()},
                     .texture = texture, .state = state
            });
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

} // namespace

TEST(MgDrawPrimAsm, Data0TruncatesEachLaneTowardZero) {
    mgCDrawPrim           prim;
    alignas(16) u_long128 buffer[2] = {};
    prim.write_buffer = buffer;

    float data[4] = {1.5f, -2.75f, 100.9f, 0.0f};
    prim.Data0(data);

    int lanes[4];
    ReadLanes(buffer, lanes);
    EXPECT_EQ(lanes[0], 1);
    EXPECT_EQ(lanes[1], -2);
    EXPECT_EQ(lanes[2], 100);
    EXPECT_EQ(lanes[3], 0);
}

TEST(MgDrawPrimAsm, Data0AdvancesWriteByOneQuadword) {
    mgCDrawPrim           prim;
    alignas(16) u_long128 buffer[2] = {};
    prim.write_buffer = buffer;

    float data[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    prim.Data0(data);

    EXPECT_EQ(prim.write_buffer.data(), buffer + 1);
}

TEST(MgDrawPrimAsm, Data0SaturatesPerSign) {
    mgCDrawPrim           prim;
    alignas(16) u_long128 buffer[1] = {};
    prim.write_buffer = buffer;

    float data[4] = {3.0e10f, -3.0e10f, 2147483520.0f, 2147483648.0f};
    prim.Data0(data);

    int lanes[4];
    ReadLanes(buffer, lanes);
    EXPECT_EQ(lanes[0], std::numeric_limits<int>::max());
    EXPECT_EQ(lanes[1], std::numeric_limits<int>::min());
    EXPECT_EQ(lanes[2], 2147483520);
    EXPECT_EQ(lanes[3], std::numeric_limits<int>::max());
}

TEST(MgDrawPrimAsm, Data0ZeroAndNegativeZeroGiveZero) {
    mgCDrawPrim           prim;
    alignas(16) u_long128 buffer[1] = {};
    prim.write_buffer = buffer;

    float data[4] = {0.0f, -0.0f, -0.0f, 0.0f};
    prim.Data0(data);

    int lanes[4];
    ReadLanes(buffer, lanes);
    EXPECT_EQ(lanes[0], 0);
    EXPECT_EQ(lanes[1], 0);
    EXPECT_EQ(lanes[2], 0);
    EXPECT_EQ(lanes[3], 0);
}

TEST(MgDrawPrimAsm, Data4ScalesBy16BeforeTruncating) {
    mgCDrawPrim           prim;
    alignas(16) u_long128 buffer[1] = {};
    prim.write_buffer = buffer;

    float data[4] = {1.5f, -2.75f, 0.0625f, 3.9f};
    prim.Data4(data);

    int lanes[4];
    ReadLanes(buffer, lanes);
    EXPECT_EQ(lanes[0], 24);
    EXPECT_EQ(lanes[1], -44);
    EXPECT_EQ(lanes[2], 1);
    EXPECT_EQ(lanes[3], 62);
}

TEST(MgDrawPrimAsm, Data4SaturatesPerSignAfterScaling) {
    mgCDrawPrim           prim;
    alignas(16) u_long128 buffer[1] = {};
    prim.write_buffer = buffer;

    float data[4] = {134217728.0f, -134217728.0f, 0.0f, 0.0f};
    prim.Data4(data);

    int lanes[4];
    ReadLanes(buffer, lanes);
    EXPECT_EQ(lanes[0], std::numeric_limits<int>::max());
    EXPECT_EQ(lanes[1], std::numeric_limits<int>::min());
    EXPECT_EQ(lanes[2], 0);
    EXPECT_EQ(lanes[3], 0);
}

TEST(MgDrawPrimAsm, Data4ZeroAndNegativeZeroGiveZero) {
    mgCDrawPrim           prim;
    alignas(16) u_long128 buffer[1] = {};
    prim.write_buffer = buffer;

    float data[4] = {-0.0f, 0.0f, -0.0f, 0.0f};
    prim.Data4(data);

    int lanes[4];
    ReadLanes(buffer, lanes);
    EXPECT_EQ(lanes[0], 0);
    EXPECT_EQ(lanes[1], 0);
    EXPECT_EQ(lanes[2], 0);
    EXPECT_EQ(lanes[3], 0);
}

TEST(MgDrawPrimAsm, VertexConvertsXYInSixteenthsAndZ) {
    PrimRig rig;
    rig.prim.coord = 1;
    rig.prim.offset_x = 0;
    rig.prim.offset_y = 0;
    rig.prim.Begin(MG_PRIM_POINT);

    float pos[4] = {10.25f, 3.5f, 7.75f, 1.0f};
    rig.prim.Vertex(pos);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 4u);
    const gfx::Vertex2D &v = rig.batches[0].vertices[0];
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(164));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(56));
    EXPECT_FLOAT_EQ(v.z, mgPortDepth(7));
}

TEST(MgDrawPrimAsm, VertexAddsScreenOffsetInSixteenths) {
    PrimRig rig;
    rig.prim.coord = 1;
    rig.prim.offset_x = 8;
    rig.prim.offset_y = 16;
    rig.prim.Begin(MG_PRIM_POINT);

    float pos[4] = {10.25f, 3.5f, 7.75f, 1.0f};
    rig.prim.Vertex(pos);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 4u);
    const gfx::Vertex2D &v = rig.batches[0].vertices[0];
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(172));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(72));
    EXPECT_FLOAT_EQ(v.z, mgPortDepth(7));
}

TEST(MgDrawPrimAsm, VertexZeroPositionKeepsOnlyTheBuilderOffset) {
    PrimRig rig;
    rig.prim.coord = 1;
    rig.prim.offset_x = 8;
    rig.prim.offset_y = 16;
    rig.prim.Begin(MG_PRIM_POINT);

    float pos[4] = {-0.0f, -0.0f, -0.0f, 1.0f};
    rig.prim.Vertex(pos);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 4u);
    const gfx::Vertex2D &v = rig.batches[0].vertices[0];
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(8));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(16));
    EXPECT_FLOAT_EQ(v.z, mgPortDepth(0));
}

TEST(MgDrawPrimAsm, VertexNegativeZKeepsSign) {
    PrimRig rig;
    rig.prim.coord = 1;
    rig.prim.offset_x = 0;
    rig.prim.offset_y = 0;
    rig.prim.Begin(MG_PRIM_POINT);

    float pos[4] = {10.25f, 3.5f, -3.5f, 1.0f};
    rig.prim.Vertex(pos);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 4u);
    const gfx::Vertex2D &v = rig.batches[0].vertices[0];
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(164));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(56));
    EXPECT_FLOAT_EQ(v.z, mgPortDepth(static_cast<uint32_t>(-3)));
}

TEST(MgDrawPrimAsm, VertexScreenOffsetPathAddsScreenThenBuilderOffset) {
    ScreenOffsetScope screen_offset(3, 5);

    PrimRig rig;
    rig.prim.coord = 0;
    rig.prim.offset_x = 8;
    rig.prim.offset_y = 16;
    rig.prim.Begin(MG_PRIM_POINT);

    float pos[4] = {10.25f, 3.5f, 7.75f, 1.0f};
    rig.prim.Vertex(pos);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 4u);
    const gfx::Vertex2D &v = rig.batches[0].vertices[0];
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(220));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(152));
    EXPECT_FLOAT_EQ(v.z, mgPortDepth(7));
}

TEST(MgDrawPrimAsm, ColorConvertsComponentsToBytes) {
    PrimRig rig;
    rig.prim.coord = 1;
    rig.prim.offset_x = 0;
    rig.prim.offset_y = 0;
    rig.prim.Begin(MG_PRIM_POINT);

    float color[4] = {128.0f, 64.5f, 255.0f, 0.0f};
    rig.prim.Color(color);
    float pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    rig.prim.Vertex(pos);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 4u);
    const uint8_t *bytes = rig.batches[0].vertices[0].color;
    EXPECT_EQ(bytes[0], 128);
    EXPECT_EQ(bytes[1], 64);
    EXPECT_EQ(bytes[2], 255);
    EXPECT_EQ(bytes[3], 0);
}

TEST(MgDrawPrimAsm, ColorZeroAndNegativeZeroGiveZeroComponents) {
    PrimRig rig;
    rig.prim.coord = 1;
    rig.prim.offset_x = 0;
    rig.prim.offset_y = 0;
    rig.prim.Begin(MG_PRIM_POINT);

    float color[4] = {-0.0f, 0.0f, -0.0f, 0.0f};
    rig.prim.Color(color);
    float pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    rig.prim.Vertex(pos);
    rig.prim.End2();

    ASSERT_EQ(rig.batches.size(), 1u);
    ASSERT_EQ(rig.batches[0].vertices.size(), 4u);
    const uint8_t *bytes = rig.batches[0].vertices[0].color;
    EXPECT_EQ(bytes[0], 0);
    EXPECT_EQ(bytes[1], 0);
    EXPECT_EQ(bytes[2], 0);
    EXPECT_EQ(bytes[3], 0);
}

TEST(MgDrawPrimAsm, Data0AndData4WithNullWriteDoNotCrash) {
    mgCDrawPrim prim;
    prim.write_buffer = {};

    float data[4] = {1.5f, -2.75f, 0.0625f, 3.9f};
    prim.Data0(data);
    prim.Data4(data);

    EXPECT_TRUE(prim.write_buffer.empty());
}

TEST(MgDrawPrimAsm, PacketWritesStopAtTheExplicitBufferExtent) {
    mgCDrawPrim              prim;
    std::array<u_long128, 3> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto sentinel = storage[1];
    prim.write_buffer = std::span(storage).first(1);
    float first[4]{1.0f, 2.0f, 3.0f, 4.0f};
    prim.Data0(first);
    ASSERT_TRUE(prim.write_buffer.empty());
    const auto written = storage[0];
    prim.Data0(first);
    prim.Data4(first);
    int lanes[4]{5, 6, 7, 8};
    prim.Data(lanes);
    EXPECT_EQ(storage[0], written);
    EXPECT_EQ(storage[1], sentinel);
    EXPECT_EQ(storage[2], sentinel);
}

TEST(MgDrawPrimAsm, DefaultBuildersHaveNoPacketOrFrameState) {
    mgCDrawPrim prim;
    EXPECT_TRUE(prim.write_buffer.empty());
    EXPECT_EQ(prim.packet_start, nullptr);
    EXPECT_EQ(prim.packet_top, nullptr);
    EXPECT_EQ(prim.packed, 0);
    prim.Data0(nullptr);
    prim.Data4(nullptr);
    prim.Data(nullptr);
    mgCDrawManager manager;
    EXPECT_EQ(manager.render_info, nullptr);
    EXPECT_EQ(manager.packet_num, nullptr);
    EXPECT_EQ(manager.group_num, 0);
    EXPECT_EQ(manager.sort_max, -1);
}
