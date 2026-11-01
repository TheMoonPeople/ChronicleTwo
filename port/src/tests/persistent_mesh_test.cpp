#include "common.h"

#include <gtest/gtest.h>

#include <array>

#include "gfx_fixture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "render/renderer.hpp"
#include "render/visual_mesh.hpp"

namespace {
/**
 * Supplies native face arrays in one face group, with one usable GPU slot after the null sentinel.
 */
class PersistentMesh : public testing::Test {
protected:
    dc::test::GfxFixture renderer{
        64, 64, 1.0f, dc::test::GfxOptions{.offscreen = true, .prog0_meshes = true, .mesh_slots = 2}
    };
    mgCVisualFixMDT visual;
    mgCFace         face{};
    mgFACE_GROUP    group{};
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
        group.face = &face;
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
    const auto *geometry = mgVisualPortGroupMesh(&group, nullptr);
    ASSERT_NE(geometry, nullptr);
    EXPECT_EQ(geometry->mesh, gfx::kNullMesh);
    mgVisualPortFlushUploads();
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
    EXPECT_EQ(mgVisualPortGroupMesh(&group, nullptr), geometry);
    EXPECT_EQ(geometry->mesh, gfx::kNullMesh);
    mgVisualPortFlushUploads();
    EXPECT_NE(geometry->mesh, gfx::kNullMesh);
}

TEST_F(PersistentMesh, FailedGpuUploadRetainsCpuGeometryAndRetriesWhenCapacityReturns) {
    const std::array<gfx::Vertex3D, 3> occupied_vertices{};
    const std::array<uint32_t, 3>      occupied_indices{0, 1, 2};
    const auto                         occupied = gfx::CreateMesh(occupied_vertices, occupied_indices);
    ASSERT_NE(occupied, gfx::kNullMesh);
    mgVisualPortRefreshFace(&visual, &face);
    const auto *geometry = mgVisualPortGroupMesh(&group, nullptr);
    ASSERT_NE(geometry, nullptr);
    mgVisualPortFlushUploads();
    EXPECT_EQ(geometry->mesh, gfx::kNullMesh);
    ASSERT_EQ(geometry->vertices.size(), 3u);
    EXPECT_EQ(geometry->indices.size(), 3u);
    EXPECT_FLOAT_EQ(geometry->vertices[1].position[0], 1);
    gfx::DestroyMesh(occupied);
    EXPECT_EQ(mgVisualPortGroupMesh(&group, nullptr), geometry);
    mgVisualPortFlushUploads();
    EXPECT_NE(geometry->mesh, gfx::kNullMesh);
    EXPECT_EQ(geometry->indices, (std::vector<uint32_t>{0, 1, 2}));
}

// Faces only keep CPU geometry; the group batch alone takes a mesh slot.
TEST_F(PersistentMesh, FaceRefreshTakesNoGpuMesh) {
    mgVisualPortRefreshFace(&visual, &face);
    const std::array<gfx::Vertex3D, 3> vertices{};
    const std::array<uint32_t, 3>      slot_indices{0, 1, 2};
    const auto                         free_slot = gfx::CreateMesh(vertices, slot_indices);
    ASSERT_NE(free_slot, gfx::kNullMesh);
    gfx::DestroyMesh(free_slot);
}

// Consecutive groups batch into one mesh: indices are rebased per face, and consecutive faces with the same face
// flags share one run.
TEST_F(PersistentMesh, ConsecutiveGroupsBatchIntoRunsByFaceFlags) {
    float normals[1][4]{
        {0, 0, 1, 0}
    };
    int     lit_indices[6]{0, 0, 1, 0, 2, 0};
    mgCFace second = face;
    mgCFace lit{};
    lit.type = static_cast<unsigned>(MG_PRIM_TRIANGLE) | MG_FACE_NO_TEXTURE;
    lit.vertex_num = 3;
    lit.index_stride = 2;
    lit.index = lit_indices;
    second.next = &lit;
    mgFACE_GROUP next{};
    next.face = &second;
    group.next = &next;
    visual.normal = normals;

    mgVisualPortRefreshFace(&visual, &face);
    mgVisualPortRefreshFace(&visual, &second);
    mgVisualPortRefreshFace(&visual, &lit);
    const auto *batch = mgVisualPortGroupMesh(&group, nullptr);
    ASSERT_NE(batch, nullptr);
    EXPECT_EQ(batch->vertices.size(), 9u);
    EXPECT_EQ(batch->indices, (std::vector<uint32_t>{0, 1, 2, 3, 4, 5, 6, 7, 8}));
    ASSERT_EQ(batch->runs.size(), 2u);
    EXPECT_EQ(batch->runs[0].first_index, 0u);
    EXPECT_EQ(batch->runs[0].index_count, 6u);
    EXPECT_EQ(batch->runs[0].face_flags, static_cast<uint32_t>(MG_FACE_NO_NORMAL | MG_FACE_NO_TEXTURE));
    EXPECT_EQ(batch->runs[1].first_index, 6u);
    EXPECT_EQ(batch->runs[1].index_count, 3u);
    EXPECT_EQ(batch->runs[1].face_flags, static_cast<uint32_t>(MG_FACE_NO_TEXTURE));
    EXPECT_FLOAT_EQ(batch->vertices[6].normal[2], 1);

    // A refreshed face is a new mesh, so the batch is rebuilt from it.
    int reversed[3]{2, 1, 0};
    second.index = reversed;
    mgVisualPortRefreshFace(&visual, &second);
    batch = mgVisualPortGroupMesh(&group, nullptr);
    ASSERT_NE(batch, nullptr);
    EXPECT_FLOAT_EQ(batch->vertices[3].position[0], 0);
    EXPECT_FLOAT_EQ(batch->vertices[5].position[0], -1);
}
