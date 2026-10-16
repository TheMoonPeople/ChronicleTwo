#include <gtest/gtest.h>

#include <cmath>
#include <cstdint>
#include <cstring>
#include <vector>

#include "gfx/gfx.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_visual.hpp"
#include "mg_visual_port.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"
#include "visualmotion.hpp"

namespace {

constexpr float kTol = 1e-4f;

// mgMulMatrix stores right * left, so products are taken in algebra order through this wrapper.
void Product(float (*out)[4], float (*a)[4], float (*b)[4]) {
    float result[4][4];
    mgMulMatrix(result, b, a);
    std::memcpy(out, result, sizeof result);
}

void SetIdentity(float (*m)[4]) {
    std::memset(m, 0, sizeof(float[4][4]));
    m[0][0] = m[1][1] = m[2][2] = m[3][3] = 1.0f;
}

void SetTranslation(float (*m)[4], float x, float y, float z) {
    SetIdentity(m);
    m[3][0] = x;
    m[3][1] = y;
    m[3][2] = z;
}

void SetRotationX(float (*m)[4], float angle) {
    SetIdentity(m);
    const float c = std::cos(angle);
    const float s = std::sin(angle);
    m[1][1] = c;
    m[1][2] = s;
    m[2][1] = -s;
    m[2][2] = c;
}

void SetRotationY(float (*m)[4], float angle) {
    SetIdentity(m);
    const float c = std::cos(angle);
    const float s = std::sin(angle);
    m[0][0] = c;
    m[0][2] = -s;
    m[2][0] = s;
    m[2][2] = c;
}

void SetRotationZ(float (*m)[4], float angle) {
    SetIdentity(m);
    const float c = std::cos(angle);
    const float s = std::sin(angle);
    m[0][0] = c;
    m[0][1] = s;
    m[1][0] = -s;
    m[1][1] = c;
}

// The palette stores each bone transposed, so its row r is column r of the matrix.
void ExpectSlotMatches(int slot, const float (*expected)[4]) {
    const float (*bone)[4] = mgVisualPortCurrentProg0().bones[slot];
    for (int row = 0; row < 3; ++row) {
        for (int col = 0; col < 4; ++col) {
            EXPECT_NEAR(bone[row][col], expected[col][row], kTol)
                << "slot " << slot << " row " << row << " column " << col;
        }
    }
}

// CreateRenderInfoPacket resets the palette to identity before CreateExtRenderInfoPacket writes it. Unused and
// NULL-frame rows keep that reset, so each test starts from the same state.
void ResetPalette() {
    gfx::Prog0Constants &prog0 = mgVisualPortCurrentProg0();
    for (auto &bone : prog0.bones) {
        for (int row = 0; row < 3; ++row) {
            for (int col = 0; col < 4; ++col) {
                bone[row][col] = row == col ? 1.0f : 0.0f;
            }
        }
    }
}

void PlaceFrame(mgCFrame &frame, float (*world)[4]) {
    frame.SetTransMatrix(world);
}

// The bone's local transform is applied before the object's, so its world matrix is local * object.
void PoseBone(mgCFrame &bone, float (*local)[4], float (*object)[4]) {
    float world[4][4];
    Product(world, local, object);
    PlaceFrame(bone, world);
}

} // namespace

TEST(VisualMotion, SkinnedFaceInterleavesSkin) {
    sceVu0FVECTOR positions[3] = {{0.0f, 0.0f, 0.0f, 1.0f}, {1.0f, 0.0f, 0.0f, 1.0f}, {0.0f, 1.0f, 0.0f, 1.0f}};
    sceVu0FVECTOR normals[1] = {{0.0f, 0.0f, 1.0f, 0.0f}};
    sceVu0FVECTOR uvs[3] = {{0.0f, 0.0f, 0.0f, 0.0f}, {1.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 1.0f, 0.0f, 0.0f}};

    mgVertexWeight weights[3];
    for (int p = 0; p < 3; ++p) {
        for (int k = 0; k < 4; ++k) {
            weights[p].matrix[k] = 4 * (4 * p + k);
            weights[p].weight[k] = 0.1f * static_cast<float>(p + 1) + 0.01f * static_cast<float>(k);
        }
    }

    mgCVisualMotionMDT visual;
    visual.vertex = positions;
    visual.vertex_num = 3;
    visual.normal = normals;
    visual.normal_num = 1;
    visual.uv = uvs;
    visual.uv_num = 3;
    visual.weight = weights;
    visual.weight_num = 3;

    // Per corner: position, normal, texture coordinate.
    int corner_streams[9] = {2, 0, 0, 0, 0, 1, 1, 0, 2};
    mgCFace face{};
    face.type = static_cast<u_short>(MG_PRIM_TRIANGLE);
    face.index_stride = 3;
    face.index_num = 9;
    face.vertex_num = 3;
    face.index = corner_streams;

    const mgVisualFaceMesh mesh = mgVisualPortBuildFace(visual, face, true);

    EXPECT_TRUE(mesh.skinned);
    EXPECT_EQ(mesh.type, face.type);
    EXPECT_EQ(mesh.index_count, 3u);
    EXPECT_EQ(mesh.indices, (std::vector<uint32_t>{0, 1, 2}));
    ASSERT_EQ(mesh.vertices.size(), 6u);

    for (size_t c = 0; c < 3; ++c) {
        const int position = corner_streams[3 * c];
        for (int i = 0; i < 3; ++i) {
            EXPECT_FLOAT_EQ(mesh.vertices[2 * c].position[i], positions[position][i]);
        }

        gfx::Prog0Skin skin;
        std::memcpy(&skin, &mesh.vertices[2 * c + 1], sizeof skin);
        for (int k = 0; k < 4; ++k) {
            EXPECT_EQ(static_cast<int>(skin.bone[k]), 4 * position + k);
            EXPECT_FLOAT_EQ(skin.weight[k], weights[position].weight[k]);
        }
    }
}

TEST(VisualMotion, PaletteIsModelSpace) {
    float base[2][4][4];
    SetIdentity(base[0]);
    SetIdentity(base[1]);

    float bone_local[4][4];
    SetTranslation(bone_local, 0.0f, 2.0f, 0.0f);

    float root_world[4][4];
    SetTranslation(root_world, 5.0f, 0.0f, 0.0f);
    mgCFrame root;
    PlaceFrame(root, root_world);
    mgCFrame bone;
    mgCFrame *frames[2] = {&root, &bone};

    mgCVisualMotionMDT visual;
    visual.frame = frames;
    visual.frame_id = 0;
    visual.base_matrix = base;
    visual.bone[0] = 1;

    float rotation[4][4];
    float translation[4][4];

    float object_a[4][4];
    SetRotationZ(rotation, 0.6f);
    SetTranslation(translation, 10.0f, 0.0f, 0.0f);
    Product(object_a, rotation, translation);

    float object_b[4][4];
    SetRotationX(rotation, -0.9f);
    SetTranslation(translation, -7.0f, 5.0f, 3.0f);
    Product(object_b, rotation, translation);

    PoseBone(bone, bone_local, object_a);
    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, object_a, &mgRenderInfo);
    ExpectSlotMatches(0, bone_local);
    EXPECT_NEAR(mgVisualPortCurrentProg0().bones[0][1][3], 2.0f, kTol);

    PoseBone(bone, bone_local, object_b);
    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, object_b, &mgRenderInfo);
    ExpectSlotMatches(0, bone_local);

    float saved_view[4][4];
    std::memcpy(saved_view, mgRenderInfo.view, sizeof saved_view);
    float saved_camera[4];
    std::memcpy(saved_camera, mgRenderInfo.camera_pos, sizeof saved_camera);

    SetRotationY(mgRenderInfo.view, 1.2f);
    mgRenderInfo.camera_pos[0] = 42.0f;
    mgRenderInfo.camera_pos[1] = -3.0f;
    mgRenderInfo.camera_pos[2] = 9.0f;
    mgRenderInfo.camera_pos[3] = 1.0f;

    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, object_b, &mgRenderInfo);
    ExpectSlotMatches(0, bone_local);

    std::memcpy(mgRenderInfo.view, saved_view, sizeof saved_view);
    std::memcpy(mgRenderInfo.camera_pos, saved_camera, sizeof saved_camera);
}

TEST(VisualMotion, UnusedSlotsAreIdentity) {
    float base[2][4][4];
    SetIdentity(base[0]);
    SetIdentity(base[1]);

    float bone_local[4][4];
    SetTranslation(bone_local, 0.0f, 2.0f, 0.0f);
    float object[4][4];
    SetTranslation(object, 10.0f, 0.0f, 0.0f);
    float bone_world[4][4];
    Product(bone_world, bone_local, object);

    float identity[4][4];
    SetIdentity(identity);
    mgCFrame root;
    PlaceFrame(root, identity);
    mgCFrame bone;
    PlaceFrame(bone, bone_world);
    mgCFrame *frames[3] = {&root, &bone, nullptr};

    mgCVisualMotionMDT visual;
    visual.frame = frames;
    visual.frame_id = 0;
    visual.base_matrix = base;
    visual.bone[0] = 1;
    visual.bone[1] = 2;

    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, object, &mgRenderInfo);

    ExpectSlotMatches(0, bone_local);
    for (int slot = 1; slot < 32; ++slot) {
        ExpectSlotMatches(slot, identity);
    }
}

TEST(VisualMotion, MatchesRetailAlgebra) {
    float rotation[4][4];
    float translation[4][4];

    float root_world[4][4];
    SetRotationZ(rotation, 0.4f);
    SetTranslation(translation, 1.0f, 2.0f, 3.0f);
    Product(root_world, rotation, translation);

    float base[2][4][4];
    SetRotationX(rotation, 0.7f);
    SetTranslation(translation, 0.0f, 1.0f, 0.0f);
    Product(base[0], rotation, translation);
    SetRotationY(rotation, -0.5f);
    SetTranslation(translation, 0.5f, 0.0f, -1.0f);
    Product(base[1], rotation, translation);

    float bone_world[4][4];
    SetRotationX(rotation, -0.3f);
    SetTranslation(translation, 2.0f, -1.0f, 0.5f);
    Product(bone_world, rotation, translation);

    float object[4][4];
    SetRotationZ(rotation, 1.1f);
    SetTranslation(translation, 10.0f, 0.0f, 0.0f);
    Product(object, rotation, translation);

    mgCFrame root;
    PlaceFrame(root, root_world);
    mgCFrame bone;
    PlaceFrame(bone, bone_world);
    mgCFrame *frames[2] = {&root, &bone};

    mgCVisualMotionMDT visual;
    visual.frame = frames;
    visual.frame_id = 0;
    visual.base_matrix = base;
    visual.bone[0] = 1;

    float bone_base_inverse[4][4];
    mgInversMatrix(bone_base_inverse, base[1]);
    float object_inverse[4][4];
    mgInversMatrix(object_inverse, object);

    // base[frame_id] * inverse(base[slot]) * bone_world * inverse(object), the palette's model-space algebra.
    float step[4][4];
    Product(step, bone_base_inverse, bone_world);
    Product(step, step, object_inverse);
    float expected[4][4];
    Product(expected, base[0], step);

    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, object, &mgRenderInfo);
    ExpectSlotMatches(0, expected);
}

TEST(VisualMotion, MatchesRetailAlgebraAttachedFrame) {
    float rotation[4][4];
    float translation[4][4];

    float root_world[4][4];
    SetIdentity(root_world);
    SetTranslation(translation, 1.0f, 0.0f, 0.0f);
    Product(root_world, root_world, translation);

    float attach_world[4][4];
    SetRotationZ(rotation, 0.25f);
    SetTranslation(translation, 4.0f, 0.0f, 1.0f);
    Product(attach_world, rotation, translation);
    Product(attach_world, attach_world, root_world);

    float base[3][4][4];
    SetIdentity(base[0]);
    SetRotationX(rotation, 0.5f);
    SetTranslation(translation, 0.0f, 0.5f, 0.0f);
    Product(base[1], rotation, translation);
    SetRotationY(rotation, -0.35f);
    SetTranslation(translation, 0.0f, 0.0f, 0.75f);
    Product(base[2], rotation, translation);

    float foot_world[4][4];
    SetRotationX(rotation, -0.2f);
    SetTranslation(translation, 0.0f, -1.5f, 0.25f);
    Product(foot_world, rotation, translation);
    Product(foot_world, foot_world, attach_world);

    mgCFrame root;
    PlaceFrame(root, root_world);
    mgCFrame attach;
    PlaceFrame(attach, attach_world);
    mgCFrame foot;
    PlaceFrame(foot, foot_world);
    mgCFrame *frames[3] = {&root, &attach, &foot};

    mgCVisualMotionMDT visual;
    visual.frame = frames;
    visual.frame_id = 1;
    visual.base_matrix = base;
    visual.bone[0] = 2;

    float bone_base_inverse[4][4];
    mgInversMatrix(bone_base_inverse, base[2]);
    float object_inverse[4][4];
    mgInversMatrix(object_inverse, attach_world);

    float step[4][4];
    Product(step, bone_base_inverse, foot_world);
    Product(step, step, object_inverse);
    float expected[4][4];
    Product(expected, base[1], step);

    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, attach_world, &mgRenderInfo);
    ExpectSlotMatches(0, expected);
}

TEST(VisualMotion, FootJointMotionUpdatesPalette) {
    float base[3][4][4];
    SetIdentity(base[0]);
    SetIdentity(base[1]);
    SetIdentity(base[2]);

    float root_world[4][4];
    SetIdentity(root_world);
    float attach_world[4][4];
    SetTranslation(attach_world, 3.0f, 0.0f, 0.0f);

    float foot_a[4][4];
    SetTranslation(foot_a, 3.0f, 0.0f, 0.0f);
    float foot_b[4][4];
    SetTranslation(foot_b, 3.0f, 1.25f, -0.5f);

    mgCFrame root;
    PlaceFrame(root, root_world);
    mgCFrame attach;
    PlaceFrame(attach, attach_world);
    mgCFrame foot;
    PlaceFrame(foot, foot_a);
    mgCFrame *frames[3] = {&root, &attach, &foot};

    mgCVisualMotionMDT visual;
    visual.frame = frames;
    visual.frame_id = 1;
    visual.base_matrix = base;
    visual.bone[0] = 2;

    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, attach_world, &mgRenderInfo);
    float saved[3][4];
    std::memcpy(saved, mgVisualPortCurrentProg0().bones[0], sizeof saved);

    PlaceFrame(foot, foot_b);
    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, attach_world, &mgRenderInfo);
    const float (*palette)[4] = mgVisualPortCurrentProg0().bones[0];
    float max_delta = 0.0f;
    for (int row = 0; row < 3; ++row) {
        for (int col = 0; col < 4; ++col) {
            max_delta = std::max(max_delta, std::fabs(palette[row][col] - saved[row][col]));
        }
    }
    EXPECT_GT(max_delta, 0.1f);
}

TEST(VisualMotion, BaseMatrixUsesRetailPathDespiteInverseBinds) {
    mgVertexWeight weights[1]{};

    float rotation[4][4];
    float translation[4][4];

    float root_world[4][4];
    SetRotationZ(rotation, 0.4f);
    SetTranslation(translation, 1.0f, 2.0f, 3.0f);
    Product(root_world, rotation, translation);

    float base[2][4][4];
    SetRotationX(rotation, 0.7f);
    SetTranslation(translation, 0.0f, 1.0f, 0.0f);
    Product(base[0], rotation, translation);
    SetRotationY(rotation, -0.5f);
    SetTranslation(translation, 0.5f, 0.0f, -1.0f);
    Product(base[1], rotation, translation);

    float bone_world[4][4];
    SetRotationX(rotation, -0.3f);
    SetTranslation(translation, 2.0f, -1.0f, 0.5f);
    Product(bone_world, rotation, translation);

    float object[4][4];
    SetRotationZ(rotation, 1.1f);
    SetTranslation(translation, 10.0f, 0.0f, 0.0f);
    Product(object, rotation, translation);

    mgCFrame root;
    PlaceFrame(root, root_world);
    mgCFrame bone;
    PlaceFrame(bone, bone_world);
    mgCFrame *frames[2] = {&root, &bone};

    mgCVisualMotionMDT visual;
    visual.frame = frames;
    visual.frame_id = 0;
    visual.base_matrix = base;
    visual.bone[0] = 1;
    visual.weight = weights;

    float identity_bind[1][4][4];
    SetIdentity(identity_bind[0]);
    model_assets::RegisterInverseBindsForTest(weights, identity_bind, 1);

    float bone_base_inverse[4][4];
    mgInversMatrix(bone_base_inverse, base[1]);
    float object_inverse[4][4];
    mgInversMatrix(object_inverse, object);
    float step[4][4];
    Product(step, bone_base_inverse, bone_world);
    Product(step, step, object_inverse);
    float expected[4][4];
    Product(expected, base[0], step);

    float apply_skin_only[4][4];
    Product(apply_skin_only, object_inverse, bone_world);

    ResetPalette();
    visual.CreateExtRenderInfoPacket(nullptr, object, &mgRenderInfo);
    ExpectSlotMatches(0, expected);
    EXPECT_GT(std::fabs(expected[3][0] - apply_skin_only[3][0]), 0.01f);

    model_assets::ClearInverseBindsForTest();
}
