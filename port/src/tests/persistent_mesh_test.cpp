#include "common.h"

#include <gtest/gtest.h>

#include <array>

#include "gfx_fixture.hpp"
#include "mg_visual.hpp"
#include "mg_visual_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"

namespace {
/**
 * Supplies native face arrays with one usable GPU slot after the null sentinel.
 */
class PersistentMesh : public testing::Test {
protected:
    dc::test::GfxFixture renderer{
        64, 64, 1.0f, dc::test::GfxOptions{.offscreen = true, .prog0_meshes = true, .mesh_slots = 2}
    };
    mgCVisualFixMDT visual;
    mgCFace         face{};
    float           positions[3][4]{
        {-1, 0, 0, 1},
        {1,  0, 0, 1},
        {0,  1, 0, 1}
    };
    int indices[3]{0, 1, 2};

    void SetUp() override {
        ClockSetUnbounded(true);
        mgInit(MG_SCREEN_MODE_512X480, 3);
        visual.vertex = positions;
        visual.vertex_num = 3;
        face.type = static_cast<unsigned>(MG_PRIM_TRIANGLE) | MG_FACE_NO_NORMAL | MG_FACE_NO_TEXTURE;
        face.vertex_num = 3;
        face.index_stride = 1;
        face.index = indices;
    }

    void TearDown() override {
        for (int frame = 0; frame < 1801; ++frame) {
            mgEndFrame(nullptr);
        }
        mgVisualPortSweep();
    }
};
} // namespace

TEST_F(PersistentMesh, IdleGpuEvictionKeepsCpuGeometryAndReuploadsOnReuse) {
    mgVisualPortRefreshFace(&visual, &face);
    const auto *geometry = mgVisualPortFaceMesh(&face);
    ASSERT_NE(geometry, nullptr);
    ASSERT_NE(geometry->mesh, gfx::kNullMesh);
    for (int frame = 0; frame < 1800; ++frame) {
        mgEndFrame(nullptr);
    }
    mgVisualPortSweep();
    EXPECT_NE(geometry->mesh, gfx::kNullMesh);
    mgEndFrame(nullptr);
    mgVisualPortSweep();
    EXPECT_EQ(geometry->mesh, gfx::kNullMesh);
    ASSERT_EQ(geometry->vertices.size(), 3u);
    EXPECT_FLOAT_EQ(geometry->vertices[0].position[0], -1);
    EXPECT_EQ(geometry->indices, (std::vector<uint32_t>{0, 1, 2}));
    EXPECT_EQ(mgVisualPortFaceMesh(&face), geometry);
    EXPECT_NE(geometry->mesh, gfx::kNullMesh);
}

TEST_F(PersistentMesh, FailedGpuUploadRetainsCpuGeometryAndRetriesWhenCapacityReturns) {
    const std::array<gfx::Vertex3D, 3> occupied_vertices{};
    const std::array<uint32_t, 3>      occupied_indices{0, 1, 2};
    const auto                         occupied = gfx::CreateMesh(occupied_vertices, occupied_indices);
    ASSERT_NE(occupied, gfx::kNullMesh);
    mgVisualPortRefreshFace(&visual, &face);
    const auto *geometry = mgVisualPortFaceMesh(&face);
    ASSERT_NE(geometry, nullptr);
    EXPECT_EQ(geometry->mesh, gfx::kNullMesh);
    ASSERT_EQ(geometry->vertices.size(), 3u);
    EXPECT_EQ(geometry->indices.size(), 3u);
    EXPECT_FLOAT_EQ(geometry->vertices[1].position[0], 1);
    gfx::DestroyMesh(occupied);
    EXPECT_EQ(mgVisualPortFaceMesh(&face), geometry);
    EXPECT_NE(geometry->mesh, gfx::kNullMesh);
    EXPECT_EQ(geometry->indices, (std::vector<uint32_t>{0, 1, 2}));
}
