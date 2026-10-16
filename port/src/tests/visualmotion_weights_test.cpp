#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstring>

#include "mg_drawprim.hpp"
#include "mg_visual_port.hpp"
#include "visualmotion.hpp"

namespace {

struct AssignmentFixture {
    std::array<u_long128, 1024> storage{};
    std::array<u_long128, 1024> scratch{};
    mgCMemory                   memory;
    mgCMemory                   work;
    sceVu0FVECTOR               positions[3] = {
        {0, 0, 0, 1},
        {1, 0, 0, 1},
        {0, 1, 0, 1}
    };
    int indices[3] = {0, 1, 2};

    AssignmentFixture() {
        memory.stSetBuffer(storage.data(), storage.size());
        work.stSetBuffer(scratch.data(), scratch.size());
    }

    int Assign(mgCVisualMotionMDT &visual, int frame) {
        visual.vertex = positions;
        visual.vertex_num = visual.weight_num = 3;
        visual.weight = new (memory.Alloc((3 * sizeof(mgVertexWeight) + 15) / 16 + 2)) mgVertexWeight[3];
        visual.bone[0] = frame == 1 ? 4 : 9;
        visual.bone[1] = frame == 1 ? 7 : -1;
        for (int vertex = 0; vertex < 3; ++vertex) {
            visual.weight[vertex].matrix[0] = 0;
            visual.weight[vertex].matrix[1] = 4;
            visual.weight[vertex].weight[0] = frame == 1 ? .25f : 1.0f;
            visual.weight[vertex].weight[1] = frame == 1 ? .75f : 0;
        }
        auto *face = new (memory.Alloc((sizeof(mgCFace) + 15) / 16 + 2)) mgCFace{};
        face->type = static_cast<u_int>(MG_PRIM_TRIANGLE) | MG_FACE_NO_NORMAL | MG_FACE_NO_TEXTURE;
        face->index_stride = 1;
        face->index_num = face->vertex_num = 3;
        face->index = indices;
        auto *group = new (memory.Alloc((sizeof(mgFACE_GROUP) + 15) / 16 + 2)) mgFACE_GROUP{};
        group->face = face;
        visual.face_group = group;
        mgVisualPortRefreshFace(&visual, face);
        return 1;
    }
};

gfx::Prog0Skin SkinAt(const mgVisualFaceMesh &mesh, int vertex) {
    gfx::Prog0Skin skin{};
    std::memcpy(&skin, &mesh.vertices[2 * vertex + 1], sizeof(skin));
    return skin;
}

} // namespace

TEST(VisualMotion, SharedWorkStackPreservesAssignedWeights) {
    AssignmentFixture  fixture;
    mgCVisualMotionMDT first;
    mgCVisualMotionMDT second;
    ASSERT_EQ(fixture.Assign(first, 1), 1);
    std::array<mgVertexWeight, 3> saved;
    std::memcpy(saved.data(), first.weight, sizeof(saved));
    ASSERT_EQ(fixture.Assign(second, 2), 1);

    const auto *assigned_mesh = mgVisualPortFaceMesh(first.face_group->face);
    ASSERT_NE(assigned_mesh, nullptr);
    ASSERT_EQ(assigned_mesh->vertices.size(), 6u);
    EXPECT_FLOAT_EQ(SkinAt(*assigned_mesh, 0).weight[0], 0.25f);
    EXPECT_FLOAT_EQ(SkinAt(*assigned_mesh, 0).weight[1], 0.75f);
    EXPECT_NE(first.weight, second.weight);
    EXPECT_EQ(std::memcmp(first.weight, saved.data(), sizeof(saved)), 0);
    fixture.work.stReset();
    std::memset(fixture.work.stack, 0, fixture.work.stack_size * 16);

    int     indices[3] = {0, 1, 2};
    mgCFace face{};
    face.type = static_cast<u_int>(MG_PRIM_TRIANGLE) | MG_FACE_NO_NORMAL | MG_FACE_NO_TEXTURE;
    face.index_stride = 1;
    face.index_num = face.vertex_num = 3;
    face.index = indices;
    const auto first_mesh = mgVisualPortBuildFace(first, face, true);
    const auto second_mesh = mgVisualPortBuildFace(second, face, true);
    ASSERT_EQ(first_mesh.vertices.size(), 6u);
    ASSERT_EQ(second_mesh.vertices.size(), 6u);
    for (int vertex = 0; vertex < 3; ++vertex) {
        const auto first_skin = SkinAt(first_mesh, vertex);
        const auto second_skin = SkinAt(second_mesh, vertex);
        EXPECT_FLOAT_EQ(first_skin.weight[0], 0.25f);
        EXPECT_FLOAT_EQ(first_skin.weight[1], 0.75f);
        EXPECT_EQ(first_skin.bone[1], 1);
        EXPECT_FLOAT_EQ(second_skin.weight[0], 1.0f);
        EXPECT_FLOAT_EQ(second_skin.weight[1], 0.0f);
    }
}
