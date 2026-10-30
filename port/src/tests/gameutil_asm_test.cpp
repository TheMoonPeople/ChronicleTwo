#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <limits>
#include <memory>
#include <stdexcept>

#include "gameutil.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_visual.hpp"
#include "platform/arena.hpp"
#include "stubs/gameutil.hpp"

namespace {

void SetPoint(float *dst, float x, float y, float z) {
    dst[0] = x;
    dst[1] = y;
    dst[2] = z;
    dst[3] = 1.0f;
}

// Horizontal triangle at height y that contains (0, y, 0).
CCPoly Floor(float y) {
    CCPoly poly = {};
    SetPoint(poly.vertex[0], -10.0f, y, -10.0f);
    SetPoint(poly.vertex[1], 10.0f, y, -10.0f);
    SetPoint(poly.vertex[2], 0.0f, y, 10.0f);
    SetPoint(poly.normal, 0.0f, 1.0f, 0.0f);
    return poly;
}

CollisionInfo MakeInfo(CCPoly *polys, int count) {
    CollisionInfo info = {};
    info.count = count;
    info.polys = polys;
    return info;
}

} // namespace

TEST(GameUtilAsm, TestVUnewWeightsTransformedVertexIntoAccumulator) {
    float matrix[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 1.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f},
    };
    float vertex[4] = {1.0f, 2.0f, 3.0f, 1.0f};
    float weight[4] = {0.5f, 0.0f, 0.0f, 0.0f};
    float accum[4] = {10.0f, 20.0f, 30.0f, 1.0f};
    float out[4] = {};

    testVUnew(matrix, vertex, weight, accum, out);

    EXPECT_FLOAT_EQ(accum[0], 10.5f);
    EXPECT_FLOAT_EQ(accum[1], 21.0f);
    EXPECT_FLOAT_EQ(accum[2], 31.5f);
    EXPECT_FLOAT_EQ(accum[3], 1.0f);
    EXPECT_FLOAT_EQ(out[0], 10.5f);
    EXPECT_FLOAT_EQ(out[1], 21.0f);
    EXPECT_FLOAT_EQ(out[2], 31.5f);
    EXPECT_FLOAT_EQ(out[3], 1.0f);
}

TEST(GameUtilAsm, TestVUnewTakesTranslationRowAsRowVectorTimesMatrix) {
    float matrix[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 1.0f, 0.0f},
        {5.0f, 6.0f, 7.0f, 1.0f},
    };
    float vertex[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float weight[4] = {1.0f, 0.0f, 0.0f, 0.0f};
    float accum[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float out[4] = {};

    testVUnew(matrix, vertex, weight, accum, out);

    EXPECT_FLOAT_EQ(out[0], 5.0f);
    EXPECT_FLOAT_EQ(out[1], 6.0f);
    EXPECT_FLOAT_EQ(out[2], 7.0f);
    EXPECT_FLOAT_EQ(out[3], 1.0f);
}

TEST(GameUtilAsm, TestVUnewAddsRowTwoLastColumnToAccumulatorW) {
    float matrix[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f },
        {0.0f, 1.0f, 0.0f, 0.0f },
        {0.0f, 0.0f, 1.0f, 0.25f},
        {0.0f, 0.0f, 0.0f, 1.0f },
    };
    float vertex[4] = {2.0f, 2.0f, 2.0f, 1.0f};
    float weight[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float accum[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float out[4] = {};

    testVUnew(matrix, vertex, weight, accum, out);

    EXPECT_FLOAT_EQ(out[0], 0.0f);
    EXPECT_FLOAT_EQ(out[1], 0.0f);
    EXPECT_FLOAT_EQ(out[2], 0.0f);
    EXPECT_FLOAT_EQ(out[3], 1.25f);
}

TEST(GameUtilAsm, MotionProc3HandlesSkinBeyondRetailFixedBuffers) {
    constexpr int vertex_count = 900;
    auto          vertices = std::make_unique<sceVu0FVECTOR[]>(vertex_count);
    auto          normals = std::make_unique<sceVu0FVECTOR[]>(vertex_count);
    auto          base_vertices = std::make_unique<sceVu0FVECTOR[]>(vertex_count);
    auto          base_normals = std::make_unique<sceVu0FVECTOR[]>(vertex_count);
    base_vertices[vertex_count - 1][0] = 3.0f;
    base_vertices[vertex_count - 1][3] = 1.0f;
    base_normals[0][0] = 1.0f;
    base_normals[vertex_count - 1][1] = 1.0f;

    mgCFrame     frame;
    mgCFrame    *frames[] = {&frame};
    mgCFrameAttr attr;
    mgCVisualMDT visual;
    visual.vertex_num = visual.normal_num = vertex_count;
    visual.vertex = vertices.get();
    visual.normal = normals.get();
    frame.frame_num = 0;
    frame.frame_list = frames;
    frame.visual = &visual;
    frame.attr = &attr;
    frame.changed = 0;

    tagFRAME_INF frame_info{};
    frame_info.vertex_count = frame_info.normal_count = vertex_count;
    frame_info.base_vertices = base_vertices.get();
    frame_info.base_normals = base_normals.get();
    sceVu0FMATRIX base_matrix;
    sceVu0UnitMatrix(base_matrix);
    sceVu0FVECTOR values[] = {
        {100.0f, 0.0f, 0.0f, 0.0f},
        {100.0f, 0.0f, 0.0f, 0.0f}
    };
    u32      key_frames[] = {0, vertex_count - 1};
    Mot_List list{};
    list.frame = list.target = 0;
    list.type = MOTION_KEY_SKIN_WEIGHTED;
    list.key_count = 2;
    list.values = values;
    list.key_frames = key_frames;
    tagMOTION_TYPE motion{};
    motion.base_matrices = &base_matrix;
    motion.skin_list = &list;

    ASSERT_EQ(MotionProc3(&frame, &motion, std::span(&frame_info, 1), &list), nullptr);
    EXPECT_FLOAT_EQ(vertices[vertex_count - 1][0], 3.0f);
    EXPECT_FLOAT_EQ(normals[0][0], 1.0f);
    EXPECT_FLOAT_EQ(normals[vertex_count - 1][1], 1.0f);
    key_frames[1] = vertex_count;
    EXPECT_EQ(MotionProc3(&frame, &motion, std::span(&frame_info, 1), &list), nullptr);
    EXPECT_FLOAT_EQ(vertices[vertex_count - 1][0], 3.0f);
}

TEST(GameUtilAsm, AnimeDataInitAcceptsMoreThanElevenNormalReferencesWithoutScratchLinks) {
    u_long128 storage[64]{};
    mgCMemory memory;
    memory.stSetBuffer(storage, 64);

    sceVu0FVECTOR vertex[] = {
        {1.0f, 2.0f, 3.0f, 1.0f}
    };
    sceVu0FVECTOR normal[] = {
        {0.0f, 1.0f, 0.0f, 0.0f}
    };
    int indices[26]{};
    for (int corner = 0; corner < 13; ++corner) {
        indices[corner * 2] = 0;
        indices[corner * 2 + 1] = 0;
    }
    mgCFace face{};
    face.vertex_num = 13;
    face.index_stride = 2;
    face.index_num = 26;
    face.index = indices;
    mgFACE_GROUP group{};
    group.face = &face;
    mgCVisualMDT visual;
    visual.vertex_num = visual.normal_num = 1;
    visual.vertex = vertex;
    visual.normal = normal;
    visual.face_group = &group;
    mgCFrame  frame;
    mgCFrame *frames[] = {&frame};
    frame.frame_num = 0;
    frame.frame_list = frames;
    frame.visual = &visual;
    Mot_List skin{};
    skin.type = MOTION_KEY_SKIN_WEIGHTED;
    skin.frame = 0;
    tagMOTION_TYPE motion{};
    motion.skin_list = &skin;
    tagFRAME_INF info[1]{};

    ASSERT_TRUE(AnimeDataInit(&frame, &motion, &memory, info));
    EXPECT_EQ(info[0].vertex_count, 1u);
    EXPECT_EQ(info[0].normal_count, 1u);
    const auto mesh_bytes = (static_cast<std::size_t>(info[0].vertex_count) + info[0].normal_count) * sizeof(sceVu0FVECTOR);
    EXPECT_EQ(static_cast<std::size_t>(memory.stack_used) * sizeof(u_long128), mesh_bytes);
    EXPECT_FLOAT_EQ(info[0].base_vertices[0][0], 1.0f);
    EXPECT_FLOAT_EQ(info[0].base_normals[0][1], 1.0f);
}

TEST(GameUtilAsm, AnimeFrameTableRejectsCountAndCapacityOverflowBeforeAllocation) {
    const auto one_frame = dc2::animation::FrameInfoQuadwords(1);
    ASSERT_TRUE(one_frame);
    EXPECT_EQ(*one_frame, (11 * sizeof(tagFRAME_INF)) / sizeof(u_long128) + 1);
    EXPECT_FALSE(dc2::animation::FrameInfoQuadwords(std::numeric_limits<std::size_t>::max()));
    EXPECT_FALSE(dc2::animation::FrameInfoQuadwords(static_cast<std::size_t>(std::numeric_limits<int>::max())));

    alignas(u_long128) u_long128 storage[2]{};
    mgCMemory                    memory;
    memory.stSetBuffer(storage, 1);
    mgCFrame       frame;
    tagMOTION_TYPE motion{};
    tagFRAME_INF  *info = nullptr;
    EXPECT_THROW(AnimeDataInit(&frame, &motion, &memory, &info), std::length_error);
    EXPECT_EQ(info, nullptr);
    EXPECT_EQ(memory.stGetUsed(), 0);
}

TEST(GameUtilAsm, CheckHitReturnsMinusOneWhenNoPolygonIsCrossed) {
    CCPoly        polys[1] = {Floor(0.0f)};
    CollisionInfo info = MakeInfo(polys, 1);
    float         from[4] = {50.0f, 10.0f, 50.0f, 1.0f};
    float         to[4] = {50.0f, -10.0f, 50.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 1, 0), -1);
}

TEST(GameUtilAsm, GetFootPolyCopiesSurfaceAndAttributeValue) {
    CCPoly poly = Floor(0.0f);
    poly.ground_kind = 2;
    poly.foot_sound = 3;
    poly.area_kind = 4;
    poly.attr = 5;
    poly.attr_value = 1.25f;
    float  position[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float  ground[4] = {};
    CCPoly found{};

    ASSERT_TRUE(GetFootPoly(position, 20.0f, &found, ground, &poly, 1, 0));
    EXPECT_EQ(found.ground_kind, 2);
    EXPECT_EQ(found.foot_sound, 3);
    EXPECT_EQ(found.area_kind, 4);
    EXPECT_EQ(found.attr, 5);
    EXPECT_FLOAT_EQ(found.attr_value, 1.25f);
}

TEST(GameUtilAsm, CheckHitReturnsFloorIntersectionForCrossingSegment) {
    CCPoly        polys[1] = {Floor(0.0f)};
    CollisionInfo info = MakeInfo(polys, 1);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 1, 0), 0);
    EXPECT_FLOAT_EQ(hit[0], 0.0f);
    EXPECT_FLOAT_EQ(hit[1], 0.0f);
    EXPECT_FLOAT_EQ(hit[2], 0.0f);
}

TEST(GameUtilAsm, CheckHitClosestPicksNearestPolygonToOrigin) {
    CCPoly        polys[2] = {Floor(0.0f), Floor(5.0f)};
    CollisionInfo info = MakeInfo(polys, 2);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 1, 0), 1);
    EXPECT_FLOAT_EQ(hit[1], 5.0f);
}

TEST(GameUtilAsm, CheckHitNotClosestTakesFirstCrossedPolygon) {
    CCPoly        polys[2] = {Floor(0.0f), Floor(5.0f)};
    CollisionInfo info = MakeInfo(polys, 2);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 0, 0), 0);
    EXPECT_FLOAT_EQ(hit[1], 0.0f);
}

TEST(GameUtilAsm, CheckHitSkipsPolygonWhoseIgnoreMaskMatches) {
    CCPoly polys[2] = {Floor(0.0f), Floor(5.0f)};
    polys[0].ignore_mask = 1;
    CollisionInfo info = MakeInfo(polys, 2);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 1, 1), 1);
}

TEST(GameUtilAsm, CheckHitMissesSegmentThatStaysAbovePlane) {
    CCPoly        polys[1] = {Floor(0.0f)};
    CollisionInfo info = MakeInfo(polys, 1);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, 5.0f, 0.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 1, 0), -1);
}

TEST(GameUtilAsm, CheckHitNullCollisionReturnsZero) {
    float from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    float hit[4] = {};

    EXPECT_EQ(CheckHit(nullptr, from, to, hit, 1, 0), 0);
}

TEST(GameUtilAsm, CheckHitEmptyCollisionReturnsMinusOne) {
    CollisionInfo info = MakeInfo(nullptr, 0);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 1, 0), -1);
}

TEST(GameUtilAsm, CheckHitsReturnsEveryCrossedPolygonInArrayOrder) {
    CCPoly        polys[3] = {Floor(0.0f), Floor(5.0f), Floor(20.0f)};
    CollisionInfo info = MakeInfo(polys, 3);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    int           hit_polys[8] = {};
    float         hit_points[8][4] = {};

    EXPECT_EQ(CheckHits(&info, from, to, 8, hit_polys, hit_points, 0, 0), 2);
    EXPECT_EQ(hit_polys[0], 0);
    EXPECT_EQ(hit_polys[1], 1);
    EXPECT_FLOAT_EQ(hit_points[0][3], 10.0f);
    EXPECT_FLOAT_EQ(hit_points[1][3], 5.0f);
}

TEST(GameUtilAsm, CheckHitsPositiveSortOrdersByDistanceFromOrigin) {
    CCPoly        polys[3] = {Floor(0.0f), Floor(5.0f), Floor(20.0f)};
    CollisionInfo info = MakeInfo(polys, 3);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    int           hit_polys[8] = {};
    float         hit_points[8][4] = {};

    EXPECT_EQ(CheckHits(&info, from, to, 8, hit_polys, hit_points, 1, 0), 2);
    EXPECT_EQ(hit_polys[0], 1);
    EXPECT_EQ(hit_polys[1], 0);
    EXPECT_FLOAT_EQ(hit_points[0][3], 5.0f);
    EXPECT_FLOAT_EQ(hit_points[1][3], 10.0f);
}

TEST(GameUtilAsm, CheckHitsNegativeSortAlsoSortsAscending) {
    CCPoly        polys[3] = {Floor(0.0f), Floor(5.0f), Floor(20.0f)};
    CollisionInfo info = MakeInfo(polys, 3);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    int           hit_polys[8] = {};
    float         hit_points[8][4] = {};

    EXPECT_EQ(CheckHits(&info, from, to, 8, hit_polys, hit_points, -1, 0), 2);
    EXPECT_EQ(hit_polys[0], 1);
    EXPECT_EQ(hit_polys[1], 0);
    EXPECT_FLOAT_EQ(hit_points[0][3], 5.0f);
    EXPECT_FLOAT_EQ(hit_points[1][3], 10.0f);
}

TEST(GameUtilAsm, CheckHitsStopsAtMaxHits) {
    CCPoly        polys[2] = {Floor(0.0f), Floor(5.0f)};
    CollisionInfo info = MakeInfo(polys, 2);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    int           hit_polys[8] = {};
    float         hit_points[8][4] = {};

    EXPECT_EQ(CheckHits(&info, from, to, 1, hit_polys, hit_points, 0, 0), 1);
    EXPECT_EQ(hit_polys[0], 0);
}

TEST(GameUtilAsm, TestVUnewZeroMatrixLeavesAccumulatorUnchanged) {
    float matrix[4][4] = {};
    float vertex[4] = {1.0f, 2.0f, 3.0f, 1.0f};
    float weight[4] = {0.5f, 0.0f, 0.0f, 0.0f};
    float accum[4] = {10.0f, 20.0f, 30.0f, 1.0f};
    float out[4] = {};

    testVUnew(matrix, vertex, weight, accum, out);

    EXPECT_FLOAT_EQ(accum[0], 10.0f);
    EXPECT_FLOAT_EQ(accum[1], 20.0f);
    EXPECT_FLOAT_EQ(accum[2], 30.0f);
    EXPECT_FLOAT_EQ(accum[3], 1.0f);
    EXPECT_FLOAT_EQ(out[0], 10.0f);
    EXPECT_FLOAT_EQ(out[1], 20.0f);
    EXPECT_FLOAT_EQ(out[2], 30.0f);
    EXPECT_FLOAT_EQ(out[3], 1.0f);
}

TEST(GameUtilAsm, CheckHitReturnsMinusOneForSegmentLyingInPlane) {
    CCPoly        polys[1] = {Floor(0.0f)};
    CollisionInfo info = MakeInfo(polys, 1);
    float         from[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float         to[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 1, 0), -1);
}

TEST(GameUtilAsm, CheckHitZeroLengthSegmentAboveFloorReturnsMinusOne) {
    CCPoly        polys[1] = {Floor(0.0f)};
    CollisionInfo info = MakeInfo(polys, 1);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         hit[4] = {};

    EXPECT_EQ(CheckHit(&info, from, to, hit, 1, 0), -1);
}

TEST(GameUtilAsm, CheckHitsEmptyPolygonListReturnsZeroForSort) {
    CCPoly        polys[1] = {Floor(0.0f)};
    CollisionInfo info = MakeInfo(polys, 0);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    int           hit_polys[8] = {};
    float         hit_points[8][4] = {};

    EXPECT_EQ(CheckHits(&info, from, to, 8, hit_polys, hit_points, 1, 0), 0);
}

TEST(GameUtilAsm, CheckHitsZeroMaxHitsReturnsZero) {
    CCPoly        polys[2] = {Floor(0.0f), Floor(5.0f)};
    CollisionInfo info = MakeInfo(polys, 2);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    int           hit_polys[8] = {};
    float         hit_points[8][4] = {};

    EXPECT_EQ(CheckHits(&info, from, to, 0, hit_polys, hit_points, 0, 0), 0);
}

TEST(GameUtilAsm, CheckHitsSortKeepsArrayOrderForTiedDistances) {
    CCPoly        polys[3] = {Floor(0.0f), Floor(5.0f), Floor(0.0f)};
    CollisionInfo info = MakeInfo(polys, 3);
    float         from[4] = {0.0f, 10.0f, 0.0f, 1.0f};
    float         to[4] = {0.0f, -10.0f, 0.0f, 1.0f};
    int           hit_polys[8] = {};
    float         hit_points[8][4] = {};

    EXPECT_EQ(CheckHits(&info, from, to, 8, hit_polys, hit_points, 1, 0), 3);
    EXPECT_EQ(hit_polys[0], 1);
    EXPECT_EQ(hit_polys[1], 0);
    EXPECT_EQ(hit_polys[2], 2);
    EXPECT_FLOAT_EQ(hit_points[0][3], 5.0f);
    EXPECT_FLOAT_EQ(hit_points[1][3], 10.0f);
    EXPECT_FLOAT_EQ(hit_points[2][3], 10.0f);
}

TEST(GameUtilAsm, MotionProc2ZeroKeyListReturnsNextWithoutFrameData) {
    Mot_List next = {};
    Mot_List list = {};
    list.key_count = 0;
    list.next = &next;
    tagMOTION_TYPE motion = {};
    motion.skin_list = &list;

    EXPECT_EQ(MotionProc2(nullptr, &motion, {}, &list), &next);
}

TEST(GameUtilAsm, AnimeDataInitRejectsInvalidChannelAndMeshBeforeWriting) {
    std::array<u_long128, 8> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto original = storage;
    mgCMemory  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    mgCFrame  frame;
    mgCFrame *frames[]{&frame};
    frame.frame_list = frames;
    frame.frame_num = 0;
    mgCVisualMDT mesh;
    frame.visual = &mesh;
    mesh.vertex_num = -1;
    mesh.normal_num = 0;
    Mot_List channel{};
    channel.type = MOTION_KEY_SKIN_WEIGHTED;
    tagMOTION_TYPE motion{};
    motion.skin_list = &channel;
    tagFRAME_INF info[1]{};
    info[0].parent = 42;
    for (const int index : {-1, 1, 0}) {
        channel.frame = index;
        EXPECT_FALSE(AnimeDataInit(&frame, &motion, &memory, info));
        EXPECT_EQ(info[0].parent, 42);
        EXPECT_EQ(memory.stack_used, 0);
        EXPECT_EQ(storage, original);
    }
}

TEST(GameUtilAsm, AnimeDataInitChecksTotalMeshCapacityAndResolvesParentsByIdentity) {
    std::array<u_long128, 8> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto  original = storage;
    mgCMemory   memory;
    static char key;
    auto       *root = reinterpret_cast<u_long128 *>(ArenaBlock(&key, sizeof(storage)));
    std::memcpy(root, storage.data(), sizeof(storage));
    memory.stSetBuffer(root, static_cast<int>(storage.size()));
    ASSERT_EQ(memory.stack_size, static_cast<int>(storage.size()));
    mgCFrame  frame;
    mgCFrame  unrelated_parent;
    mgCFrame *frames[]{&frame};
    frame.frame_list = frames;
    frame.frame_num = 0;
    frame.parent = &unrelated_parent;
    sceVu0FVECTOR vertices[8]{};
    mgCVisualMDT  mesh;
    mesh.vertex_num = 8;
    mesh.vertex = vertices;
    mesh.normal_num = 0;
    mesh.normal = nullptr;
    frame.visual = &mesh;
    Mot_List channel{};
    channel.type = MOTION_KEY_SKIN_WEIGHTED;
    tagMOTION_TYPE motion{};
    motion.skin_list = &channel;
    tagFRAME_INF info[1]{};
    info[0].parent = 42;
    EXPECT_FALSE(AnimeDataInit(&frame, &motion, &memory, info));
    EXPECT_EQ(info[0].parent, 42);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(std::memcmp(root, original.data(), sizeof(original)), 0);
    mesh.vertex_num = 1;
    EXPECT_TRUE(AnimeDataInit(&frame, &motion, &memory, info));
    EXPECT_EQ(info[0].parent, -1);
    EXPECT_EQ(info[0].vertex_count, 1u);
    EXPECT_EQ(info[0].normal_count, 0u);
    EXPECT_EQ(info[0].base_normals, nullptr);
}

TEST(GameUtilAsm, AnimeFrameViewExcludesTheAllocationPadding) {
    std::array<u_long128, 128> storage{};
    mgCMemory                  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    mgCFrame  frame;
    mgCFrame *frames[]{&frame};
    frame.frame_list = frames;
    frame.frame_num = 0;
    tagMOTION_TYPE motion{};
    tagFRAME_INF  *info = nullptr;
    AnimeDataInit(&frame, &motion, &memory, &info);
    ASSERT_NE(info, nullptr);
    EXPECT_EQ(motion.frame_info, info);
    EXPECT_EQ(motion.frame_info_view.size(), 1u);
    EXPECT_GT(dc2::memory::AllocationBytes(memory, info).size(), motion.frame_info_view.size_bytes());
    Mot_List next{};
    Mot_List channel{};
    channel.next = &next;
    channel.type = MOTION_KEY_SKIN_WEIGHTED;
    channel.frame = 1;
    EXPECT_EQ(MotionProc3(&frame, &motion, motion.frame_info_view, &channel), &next);
}
