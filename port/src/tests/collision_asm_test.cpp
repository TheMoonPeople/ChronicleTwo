#include <gtest/gtest.h>

#include <memory>

#include "collision.hpp"
#include "colprim.hpp"
#include "intersection.hpp"
#include "platform/arena.hpp"
#include "scenesnd.hpp"
#include "stubs/collision.hpp"

namespace {

void SetPoint(float *dst, float x, float y, float z) {
    dst[0] = x;
    dst[1] = y;
    dst[2] = z;
    dst[3] = 1.0f;
}

void SetIdentity(float (*matrix)[4]) {
    for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
            matrix[row][col] = row == col ? 1.0f : 0.0f;
        }
    }
}

} // namespace

TEST(CollisionAsm, SingleHitHistoryCoversEverySceneCharacterSlotAndResets) {
    auto           scene = std::make_unique<CScene>();
    auto           character = std::make_shared<CCharacter2>();
    static char    model_key;
    constexpr auto words = dc2::memory::ArrayQuadwords<mgCFrame>(1).value() + 8;
    mgCMemory      memory;
    memory.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&model_key, words * sizeof(u_long128))), words);
    auto *frame_storage = dc2::memory::NewObject<mgCFrame>(memory);
    ASSERT_NE(frame_storage, nullptr);
    auto &frame = *frame_storage;
    character->CObjectFrame::frame = &frame;
    ASSERT_TRUE(dc2::character::CaptureModelResources(*character, memory));
    character->entry_object[0] = {.frame = &frame,
                                  .size = 1.0f,
                                  .group = CHARA_ENTRY_GROUP_HIT,
                                  .enable = true};
    DAMAGE_PARAM damage{};
    damage.shape = DAMAGE_SHAPE_POINT;
    CColPrim primitive{};
    primitive.Initialize();
    primitive.param = &damage;
    float position[4]{0.0f, 0.0f, 0.0f, 1.0f};
    primitive.SetCoord(position, 1.0f);
    primitive.active = true;

    EXPECT_FALSE(primitive.IsHit(nullptr, 0));
    EXPECT_FALSE(primitive.IsHit(scene.get(), -1));
    EXPECT_FALSE(primitive.IsHit(scene.get(), 128));
    for (const int slot : {0, 31, 32, 63, 64, 127}) {
        scene->chara[slot].AssignData(dc2::scene::CharacterResource::FromOwned(character), "collision");
        scene->chara[slot].status = SCENE_DATA_LOADED;
        EXPECT_TRUE(primitive.IsHit(scene.get(), slot)) << slot;
        EXPECT_FALSE(primitive.IsHit(scene.get(), slot)) << slot;
    }

    primitive.Initialize();
    primitive.param = &damage;
    primitive.active = true;
    EXPECT_TRUE(primitive.IsHit(scene.get(), 127));
    damage.multi_hit = true;
    EXPECT_TRUE(primitive.IsHit(scene.get(), 64));
    EXPECT_TRUE(primitive.IsHit(scene.get(), 64));
}

TEST(CollisionAsm, BoxIntersectionAcceptsFloatAlignedVectorsAndSortsItsHits) {
    struct alignas(16) Storage {
        float prefix{};
        float from[4]{-2.0f, 0.0f, 0.0f, 1.0f};
        float to[4]{2.0f, 0.0f, 0.0f, 1.0f};
        float hits[2][4]{};
    } storage;

    static_assert(offsetof(Storage, from) == sizeof(float));
    mgVu0FBOX box{
        .max = {1.0f,  1.0f,  1.0f,  0.0f},
        .min = {-1.0f, -1.0f, -1.0f, 0.0f}
    };

    ASSERT_EQ(IntersectionBox(storage.from, storage.to, &box, storage.hits), 2);
    EXPECT_FLOAT_EQ(storage.hits[0][0], -1.0f);
    EXPECT_FLOAT_EQ(storage.hits[1][0], 1.0f);
    EXPECT_FLOAT_EQ(storage.hits[0][3], 1.0f);
    EXPECT_FLOAT_EQ(storage.hits[1][3], 3.0f);
}

TEST(CollisionAsm, BoxIntersectionCanReplaceItsInputEndpointsWithItsHits) {
    float endpoints[2][4]{
        {-2.0f, 0.0f, 0.0f, 1.0f},
        {2.0f,  0.0f, 0.0f, 1.0f}
    };
    mgVu0FBOX box{
        .max = {1.0f,  1.0f,  1.0f,  0.0f},
        .min = {-1.0f, -1.0f, -1.0f, 0.0f}
    };

    ASSERT_EQ(IntersectionBox(endpoints[0], endpoints[1], &box, endpoints), 2);
    EXPECT_FLOAT_EQ(endpoints[0][0], -1.0f);
    EXPECT_FLOAT_EQ(endpoints[1][0], 1.0f);
}

TEST(CollisionAsm, UnknownDamageNamesLeaveTheExistingPrimitiveUnchanged) {
    CColPrim primitive{};
    primitive.active = true;
    primitive.owner = 37;
    primitive.param_no = 11;
    primitive.damage = 91;
    primitive.step_count = 4;
    char unknown[] = "no-such-native-damage-parameter";

    EXPECT_EQ(primitive.SetDamage(unknown, 5), 0);
    EXPECT_EQ(primitive.SetDamage(nullptr, 5), 0);
    EXPECT_TRUE(primitive.active);
    EXPECT_EQ(primitive.owner, 37);
    EXPECT_EQ(primitive.param_no, 11);
    EXPECT_EQ(primitive.damage, 91);
    EXPECT_EQ(primitive.step_count, 4);
    EXPECT_EQ(primitive.param, nullptr);
}

TEST(CollisionAsm, TranceNormalIdentityKeepsCornersAndReturnsCrossProduct) {
    float matrix[4][4];
    SetIdentity(matrix);
    pre_trance_normal(matrix);

    float corners[12] = {};
    SetPoint(corners + 0, 0.0f, 0.0f, 0.0f);
    SetPoint(corners + 4, 0.0f, 0.0f, 1.0f);
    SetPoint(corners + 8, 1.0f, 0.0f, 0.0f);
    float normal[4] = {};

    trance_normal(corners, corners + 4, corners + 8, normal);

    EXPECT_FLOAT_EQ(corners[0], 0.0f);
    EXPECT_FLOAT_EQ(corners[2], 0.0f);
    EXPECT_FLOAT_EQ(corners[4 + 2], 1.0f);
    EXPECT_FLOAT_EQ(corners[8], 1.0f);
    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 1.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}

TEST(CollisionAsm, TranceNormalAppliesTranslationRowToCorners) {
    float matrix[4][4];
    SetIdentity(matrix);
    matrix[3][0] = 5.0f;
    matrix[3][1] = 6.0f;
    matrix[3][2] = 7.0f;
    pre_trance_normal(matrix);

    float corners[12] = {};
    SetPoint(corners + 0, 0.0f, 0.0f, 0.0f);
    SetPoint(corners + 4, 0.0f, 0.0f, 1.0f);
    SetPoint(corners + 8, 1.0f, 0.0f, 0.0f);
    float normal[4] = {};

    trance_normal(corners, corners + 4, corners + 8, normal);

    EXPECT_FLOAT_EQ(corners[0], 5.0f);
    EXPECT_FLOAT_EQ(corners[1], 6.0f);
    EXPECT_FLOAT_EQ(corners[2], 7.0f);
    EXPECT_FLOAT_EQ(corners[3], 1.0f);
    EXPECT_FLOAT_EQ(corners[4 + 2], 8.0f);
    EXPECT_FLOAT_EQ(corners[8], 6.0f);
    EXPECT_FLOAT_EQ(normal[1], 1.0f);
}

TEST(CollisionAsm, TranceNormalScalesNormalWithTransformedEdges) {
    float matrix[4][4] = {
        {2.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 3.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 4.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f},
    };
    pre_trance_normal(matrix);

    float corners[12] = {};
    SetPoint(corners + 0, 0.0f, 0.0f, 0.0f);
    SetPoint(corners + 4, 0.0f, 0.0f, 1.0f);
    SetPoint(corners + 8, 1.0f, 0.0f, 0.0f);
    float normal[4] = {};

    trance_normal(corners, corners + 4, corners + 8, normal);

    EXPECT_FLOAT_EQ(corners[4 + 2], 4.0f);
    EXPECT_FLOAT_EQ(corners[8], 2.0f);
    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 8.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}

TEST(CollisionAsm, PickUpNearPolyReturnsOnlyPolygonsInsideBox) {
    CCollisionMDT collision;
    collision.bbox.min[0] = -1000.0f;
    collision.bbox.min[1] = -1000.0f;
    collision.bbox.min[2] = -1000.0f;
    collision.bbox.max[0] = 1000.0f;
    collision.bbox.max[1] = 1000.0f;
    collision.bbox.max[2] = 1000.0f;

    CCPoly polys[2] = {};
    SetPoint(polys[0].vertex[0], 0.0f, 0.0f, 0.0f);
    SetPoint(polys[0].vertex[1], 10.0f, 0.0f, 0.0f);
    SetPoint(polys[0].vertex[2], 0.0f, 0.0f, 10.0f);
    SetPoint(polys[0].normal, 0.0f, 1.0f, 0.0f);
    polys[0].ground_kind = 7;
    SetPoint(polys[1].vertex[0], 500.0f, 0.0f, 500.0f);
    SetPoint(polys[1].vertex[1], 510.0f, 0.0f, 500.0f);
    SetPoint(polys[1].vertex[2], 500.0f, 0.0f, 510.0f);
    SetPoint(polys[1].normal, 0.0f, 1.0f, 0.0f);
    collision.poly = polys;
    collision.poly_count = 2;

    mgVu0FBOX box = {};
    box.min[0] = -5.0f;
    box.min[1] = -5.0f;
    box.min[2] = -5.0f;
    box.max[0] = 5.0f;
    box.max[1] = 5.0f;
    box.max[2] = 5.0f;

    CCPoly out[4] = {};
    EXPECT_EQ(collision.PickUpNearPoly(out, box, 4), 1);
    EXPECT_FLOAT_EQ(out[0].vertex[1][0], 10.0f);
    EXPECT_EQ(out[0].ground_kind, 7);
}

TEST(CollisionAsm, TranceNormalZeroMatrixGivesZeroNormal) {
    float matrix[4][4] = {};
    pre_trance_normal(matrix);

    float corners[12] = {};
    SetPoint(corners + 0, 0.0f, 0.0f, 0.0f);
    SetPoint(corners + 4, 0.0f, 0.0f, 1.0f);
    SetPoint(corners + 8, 1.0f, 0.0f, 0.0f);
    float normal[4] = {1.0f, 1.0f, 1.0f, 1.0f};

    trance_normal(corners, corners + 4, corners + 8, normal);

    EXPECT_FLOAT_EQ(corners[4 + 2], 0.0f);
    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 0.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}

TEST(CollisionAsm, TranceNormalCollinearCornersGiveZeroNormal) {
    float matrix[4][4];
    SetIdentity(matrix);
    pre_trance_normal(matrix);

    float corners[12] = {};
    SetPoint(corners + 0, 0.0f, 0.0f, 0.0f);
    SetPoint(corners + 4, 0.0f, 0.0f, 1.0f);
    SetPoint(corners + 8, 0.0f, 0.0f, 2.0f);
    float normal[4] = {1.0f, 1.0f, 1.0f, 1.0f};

    trance_normal(corners, corners + 4, corners + 8, normal);

    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 0.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}

TEST(CollisionAsm, TranceNormalUsesMatrixFromMostRecentPre) {
    float first[4][4];
    SetIdentity(first);
    first[3][0] = 5.0f;
    first[3][1] = 6.0f;
    first[3][2] = 7.0f;
    pre_trance_normal(first);

    float corners[12] = {};
    SetPoint(corners + 0, 0.0f, 0.0f, 0.0f);
    SetPoint(corners + 4, 0.0f, 0.0f, 1.0f);
    SetPoint(corners + 8, 1.0f, 0.0f, 0.0f);
    float normal[4] = {};
    trance_normal(corners, corners + 4, corners + 8, normal);

    float second[4][4];
    SetIdentity(second);
    second[0][0] = 2.0f;
    second[1][1] = 2.0f;
    second[2][2] = 2.0f;
    pre_trance_normal(second);

    trance_normal(corners, corners + 4, corners + 8, normal);

    EXPECT_FLOAT_EQ(corners[0], 10.0f);
    EXPECT_FLOAT_EQ(corners[1], 12.0f);
    EXPECT_FLOAT_EQ(corners[2], 14.0f);
    EXPECT_FLOAT_EQ(corners[3], 1.0f);
    EXPECT_FLOAT_EQ(corners[4 + 2], 16.0f);
    EXPECT_FLOAT_EQ(corners[8], 12.0f);
    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 4.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}

namespace {

void SetWideBounds(CCollisionMDT &collision) {
    collision.bbox.min[0] = -1000.0f;
    collision.bbox.min[1] = -1000.0f;
    collision.bbox.min[2] = -1000.0f;
    collision.bbox.max[0] = 1000.0f;
    collision.bbox.max[1] = 1000.0f;
    collision.bbox.max[2] = 1000.0f;
}

void SetFlatPoly(CCPoly &poly, float x, float z, int ground_kind) {
    SetPoint(poly.vertex[0], x, 0.0f, z);
    SetPoint(poly.vertex[1], x + 10.0f, 0.0f, z);
    SetPoint(poly.vertex[2], x, 0.0f, z + 10.0f);
    SetPoint(poly.normal, 0.0f, 1.0f, 0.0f);
    poly.ground_kind = ground_kind;
}

} // namespace

TEST(CollisionAsm, PickUpNearPolyZeroPolyCountReturnsZero) {
    CCollisionMDT collision;
    SetWideBounds(collision);
    CCPoly polys[1] = {};
    SetFlatPoly(polys[0], 0.0f, 0.0f, 7);
    collision.poly = polys;
    collision.poly_count = 0;

    mgVu0FBOX box = {};
    box.min[0] = -5.0f;
    box.min[1] = -5.0f;
    box.min[2] = -5.0f;
    box.max[0] = 5.0f;
    box.max[1] = 5.0f;
    box.max[2] = 5.0f;

    CCPoly out[1] = {};
    EXPECT_EQ(collision.PickUpNearPoly(out, box, 4), 0);
}

TEST(CollisionAsm, PickUpNearPolyStopsAfterMaxHits) {
    CCollisionMDT collision;
    SetWideBounds(collision);
    CCPoly polys[2] = {};
    SetFlatPoly(polys[0], 0.0f, 0.0f, 7);
    SetFlatPoly(polys[1], 0.0f, 0.0f, 9);
    collision.poly = polys;
    collision.poly_count = 2;

    mgVu0FBOX box = {};
    box.min[0] = -5.0f;
    box.min[1] = -5.0f;
    box.min[2] = -5.0f;
    box.max[0] = 5.0f;
    box.max[1] = 5.0f;
    box.max[2] = 5.0f;

    CCPoly out[2] = {};
    EXPECT_EQ(collision.PickUpNearPoly(out, box, 1), 1);
    EXPECT_EQ(out[0].ground_kind, 7);
    EXPECT_EQ(out[1].ground_kind, 0);
}

TEST(CollisionAsm, PickUpNearPolyBoxTouchingPolyBoundsCounts) {
    CCollisionMDT collision;
    SetWideBounds(collision);
    CCPoly polys[1] = {};
    SetFlatPoly(polys[0], 0.0f, 0.0f, 7);
    collision.poly = polys;
    collision.poly_count = 1;

    mgVu0FBOX box = {};
    box.min[0] = 10.0f;
    box.min[1] = -5.0f;
    box.min[2] = -5.0f;
    box.max[0] = 20.0f;
    box.max[1] = 5.0f;
    box.max[2] = 5.0f;

    CCPoly out[1] = {};
    EXPECT_EQ(collision.PickUpNearPoly(out, box, 4), 1);
    EXPECT_EQ(out[0].ground_kind, 7);
}
