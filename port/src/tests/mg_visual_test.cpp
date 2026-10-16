#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <string>
#include <vector>

#include "gfx/displaylist.hpp"
#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_frame.hpp"
#include "mg_shadow.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mg_visual_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/window.hpp"

using namespace dc::test;

namespace {

using Vec3 = std::array<float, 3>;

struct FaceSpec {
    u_int             type;
    std::vector<int> corners;
};

struct ModelSpec {
    std::vector<Vec3>     vertices;
    Vec3                  normal = {0.0f, 0.0f, 1.0f};
    std::array<float, 4>  diffuse = {1.0f, 1.0f, 1.0f, 1.0f};
    std::string           texture;
    std::vector<FaceSpec> faces;
};

// Lays out an MDT the way CopyMDTData and CreateFace read it. Every face is NO_TEXTURE, so each corner is a
// position index followed by a normal index; normal i belongs to vertex i.
class MdtFile {
public:
    explicit MdtFile(const ModelSpec &model) {
        Build(model);
    }

    MDT_HEADER *header() {
        return reinterpret_cast<MDT_HEADER *>(words_.data());
    }

private:
    void Build(const ModelSpec &model);

    std::vector<u_long128> words_;
};

void MdtFile::Build(const ModelSpec &model) {
    const int vertex_count = static_cast<int>(model.vertices.size());

    size_t faces_bytes = sizeof(MDT_FACES);
    for (const FaceSpec &face : model.faces) {
        faces_bytes += 3 * sizeof(u_int) + 2 * face.corners.size() * sizeof(int);
    }

    const size_t vertex_ofs = sizeof(MDT_HEADER);
    const size_t normal_ofs = vertex_ofs + 16 * static_cast<size_t>(vertex_count);
    const size_t material_ofs = normal_ofs + 16 * static_cast<size_t>(vertex_count);
    const size_t faces_ofs = material_ofs + sizeof(MDT_MATERIAL_);
    const size_t total = faces_ofs + faces_bytes;

    words_.assign((total + 15) / 16, u_long128(0));
    uint8_t *base = reinterpret_cast<uint8_t *>(words_.data());

    MDT_HEADER header = {};
    std::memcpy(header.magic, "MDT", 3);
    header.header_size = sizeof(MDT_HEADER);
    header.vertex_num = vertex_count;
    header.vertex_ofs = static_cast<int>(vertex_ofs);
    header.normal_num = vertex_count;
    header.normal_ofs = static_cast<int>(normal_ofs);
    header.faces_size = static_cast<int>(faces_bytes);
    header.faces_ofs = static_cast<int>(faces_ofs);
    header.material_num = 1;
    header.material_ofs = static_cast<int>(material_ofs);
    std::memcpy(base, &header, sizeof header);

    for (int i = 0; i < vertex_count; i++) {
        const float position[4] = {model.vertices[i][0], model.vertices[i][1], model.vertices[i][2], 1.0f};
        const float normal[4] = {model.normal[0], model.normal[1], model.normal[2], 0.0f};
        std::memcpy(base + vertex_ofs + 16 * i, position, sizeof position);
        std::memcpy(base + normal_ofs + 16 * i, normal, sizeof normal);
    }

    MDT_MATERIAL_ material = {};
    std::memcpy(material.diffuse, model.diffuse.data(), sizeof material.diffuse);
    std::strncpy(material.texture, model.texture.c_str(), sizeof material.texture - 1);
    std::memcpy(base + material_ofs, &material, sizeof material);

    MDT_FACES faces = {};
    faces.header_size = sizeof(MDT_FACES);
    faces.prim_num = static_cast<int>(model.faces.size());
    std::memcpy(base + faces_ofs, &faces, sizeof faces);

    size_t cursor = faces_ofs + sizeof(MDT_FACES);
    for (const FaceSpec &face : model.faces) {
        const u_int vertex_num = static_cast<u_int>(face.corners.size());
        const u_int material_index = 0;
        std::memcpy(base + cursor, &face.type, sizeof(u_int));
        std::memcpy(base + cursor + 4, &vertex_num, sizeof(u_int));
        std::memcpy(base + cursor + 8, &material_index, sizeof(u_int));
        cursor += 3 * sizeof(u_int);

        for (int corner : face.corners) {
            const int pair[2] = {corner, corner};
            std::memcpy(base + cursor, pair, sizeof pair);
            cursor += sizeof pair;
        }
    }
}

// The pool is the stack a DataAssign allocates from: every visual and face it creates lives here.
class MemoryPool {
public:
    MemoryPool() : words_(kQuadwords) {
        memory_.stSetBuffer(words_.data(), kQuadwords);
    }

    mgCMemory &memory() {
        return memory_;
    }

private:
    static constexpr int kQuadwords = 1 << 14;

    std::vector<u_long128> words_;
    mgCMemory              memory_;
};

class VisualRenderer {
public:
    VisualRenderer(int width, int height) {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{width, height, true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle visual tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 4.0f / 3.0f;
        config.validation = true;
        config.offscreen = true;
        config.prog0_meshes = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("mg_visual_" + std::to_string(ProcessId()) + ".bin");
        gfx::RendererInit(WindowHandle(), config);

        ClockSetUnbounded(true);
        mgInit(MG_SCREEN_MODE_512X480, 3);
    }

    ~VisualRenderer() {
        gfx::RendererShutdown();
        WindowShutdown();
        EXPECT_EQ(gfx::ValidationMessageCount(), 0u);
    }
};

constexpr u_int kPrimTriangle = MG_PRIM_TRIANGLE;
constexpr u_int kPrimStrip = MG_PRIM_TRIANGLE_STRIP;
constexpr u_int kUntextured = MG_FACE_NO_TEXTURE;

ModelSpec CentreTriangle(bool reversed, std::array<float, 4> diffuse = {1.0f, 1.0f, 1.0f, 1.0f}) {
    ModelSpec model;
    model.vertices = {{-50.0f, -50.0f, 100.0f}, {150.0f, -50.0f, 100.0f}, {-50.0f, 150.0f, 100.0f}};
    model.diffuse = diffuse;
    model.faces.push_back({kPrimTriangle | kUntextured, reversed ? std::vector<int>{0, 2, 1} : std::vector<int>{0, 1, 2}});
    return model;
}

void SetCamera() {
    mgSetRenderInfo(400.0f, 10.0f, 10000.0f);
    float identity[4][4] = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    float eye[4] = {0, 0, 0, 0};
    mgSetViewMatrix(identity, eye);
}

void Identity(float (&matrix)[4][4]) {
    std::memset(matrix, 0, sizeof matrix);
    matrix[0][0] = matrix[1][1] = matrix[2][2] = matrix[3][3] = 1.0f;
}

void SetColour(mgCFrameAttr &attr, const std::array<float, 4> &colour) {
    for (int i = 0; i < 4; i++) {
        attr.color[i] = colour[i];
    }
}

// What mgCFrame::Draw leaves in the render info for the object it is drawing.
void PrepareObject(mgCFrameAttr &attr) {
    mgRenderInfo.attr = &attr;
    sceVu0CopyVector(mgRenderInfo.object_color, attr.color);
    mgRenderInfo.plight_hit = 0;
}

void DrawTickImmediate(mgCVisualMDT &visual, mgCFrameAttr &attr) {
    float matrix[4][4];
    Identity(matrix);
    PrepareObject(attr);
    u_int tag[4] = {};

    mgBeginFrame(nullptr);
    visual.Draw(tag, matrix, nullptr);
    mgEndFrame(nullptr);
}

bool CentrePixel(std::array<uint8_t, 3> &out) {
    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;
    if (!mgPortReadColor(gfx::kMainTarget, rgba, width, height)) {
        return false;
    }
    const size_t centre = (static_cast<size_t>(height / 2) * width + width / 2) * 4;
    out = {rgba[centre], rgba[centre + 1], rgba[centre + 2]};
    return true;
}

void ExpectCentre(int r, int g, int b) {
    std::array<uint8_t, 3> pixel = {};
    ASSERT_TRUE(CentrePixel(pixel));
    EXPECT_NEAR(pixel[0], r, 1);
    EXPECT_NEAR(pixel[1], g, 1);
    EXPECT_NEAR(pixel[2], b, 1);
}

uint64_t KeyOf(const void *object) {
    return static_cast<uint64_t>(reinterpret_cast<uintptr_t>(object));
}

} // namespace

TEST(MgVisual, FaceMeshListAndStrip) {
    ModelSpec model;
    model.vertices = {{0, 0, 0}, {1, 0, 0}, {2, 0, 0}, {3, 0, 0}, {4, 0, 0}};
    model.faces.push_back({kPrimTriangle | kUntextured, {0, 1, 2}});
    model.faces.push_back({kPrimStrip | kUntextured, {0, 1, 2, 3, 4}});

    MdtFile file(model);
    MemoryPool pool;
    mgCVisualMDT visual;
    ASSERT_EQ(visual.DataAssignMDT(file.header(), &pool.memory(), nullptr), 1);

    std::vector<mgCFace *> faces;
    for (mgFACE_GROUP *group = visual.face_group; group != nullptr; group = group->next) {
        for (mgCFace *face = group->face; face != nullptr; face = face->next) {
            faces.push_back(face);
        }
    }
    ASSERT_EQ(faces.size(), 2u);

    // A plain visual builds its face meshes when its packet is created, not at load.
    for (mgCFace *face : faces) {
        visual.CreateFacePacket(nullptr, face);
    }

    const mgVisualFaceMesh *list = mgVisualPortFaceMesh(faces[0]);
    ASSERT_NE(list, nullptr);
    EXPECT_EQ(list->index_count, 3u);
    EXPECT_EQ(list->indices, (std::vector<uint32_t>{0, 1, 2}));
    EXPECT_FALSE(list->skinned);

    const mgVisualFaceMesh *strip = mgVisualPortFaceMesh(faces[1]);
    ASSERT_NE(strip, nullptr);
    EXPECT_EQ(strip->index_count, 9u);
    EXPECT_EQ(strip->indices, (std::vector<uint32_t>{0, 1, 2, 2, 1, 3, 2, 3, 4}));
}

// prog0.md 10.1
TEST(MgVisual, LightingOffVector) {
    VisualRenderer renderer(640, 480);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetCamera();

    MdtFile file(CentreTriangle(false, {0.5f, 0.5f, 0.5f, 1.0f}));
    MemoryPool pool;
    mgCVisualMDT visual;
    ASSERT_EQ(visual.DataAssignMDT(file.header(), &pool.memory(), nullptr), 1);

    mgCFrameAttr attr;
    attr.no_light = 1;
    SetColour(attr, {128.0f, 64.0f, 32.0f, 128.0f});
    DrawTickImmediate(visual, attr);

    ExpectCentre(64, 32, 16);
}

// prog0.md 10.2
TEST(MgVisual, OneLightVector) {
    VisualRenderer renderer(640, 480);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetCamera();

    float direction[4] = {0.0f, 0.0f, 1.0f, 0.0f};
    float light_colour[4] = {128.0f, 64.0f, 0.0f, 0.0f};
    float ambient[4] = {32.0f, 32.0f, 32.0f, 128.0f};
    mgSetLight(0, direction, light_colour);
    mgSetAmbient(ambient);

    MdtFile file(CentreTriangle(false));
    MemoryPool pool;
    mgCVisualMDT visual;
    ASSERT_EQ(visual.DataAssignMDT(file.header(), &pool.memory(), nullptr), 1);

    mgCFrameAttr attr;
    SetColour(attr, {128.0f, 128.0f, 128.0f, 128.0f});
    DrawTickImmediate(visual, attr);

    ExpectCentre(160, 96, 32);
}

// The retail sequence (title.cpp, dng_main.cpp): a draw order ends the list with -1, so a material without a
// texture (block -1) maps to the first ordered group through AddPacket. Without a draw order the -1 group
// reaches PreEndDraw unmapped.
TEST(MgVisual, DrawManagerPathMatchesDirect) {
    VisualRenderer renderer(640, 480);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetCamera();

    mgCTextureManager &textures = mgTexManager;
    MemoryPool         texture_table;
    textures.SetTableBuffer(16, 8, &texture_table.memory());
    textures.Initialize(0x1000, -1);

    std::vector<u_long128> pixels(64, 0);
    u_long128 *levels[MG_TEXTURE_LEVEL_MAX] = {pixels.data(), nullptr, nullptr, nullptr};
    char       name[] = "vis_tex";
    ASSERT_NE(textures.EnterTexture(0, name, levels, 16, 16, 32, nullptr, 0, 0), nullptr);

    ModelSpec model = CentreTriangle(false, {0.5f, 0.5f, 0.5f, 1.0f});
    model.texture = "vis_tex";
    MdtFile file(model);
    MemoryPool pool;
    mgCVisualMDT visual;
    ASSERT_EQ(visual.DataAssignMDT(file.header(), &pool.memory(), nullptr), 1);

    mgCFrameAttr attr;
    attr.no_light = 1;
    SetColour(attr, {128.0f, 64.0f, 32.0f, 128.0f});
    DrawTickImmediate(visual, attr);
    ExpectCentre(64, 32, 16);

    MemoryPool data_a;
    MemoryPool data_b;
    MemoryPool buffers;
    mgSetDataBuffer(&data_a.memory(), &data_b.memory(), 0);

    int draw_order[2] = {0, -1};
    float matrix[4][4];
    Identity(matrix);
    PrepareObject(attr);

    mgBeginFrame(nullptr);
    mgBeginDraw(&buffers.memory(), draw_order, nullptr);
    visual.Draw(nullptr, matrix, nullptr);
    mgPreEndDraw(nullptr);
    for (int i = 0; draw_order[i] >= 0; i++) {
        mgEndDrawReloadTexture(draw_order[i], nullptr);
        mgEndDraw(draw_order[i], nullptr);
    }
    mgEndFrame(nullptr);

    ExpectCentre(64, 32, 16);
}

TEST(MgVisual, FacingFlagCullsBackFaces) {
    VisualRenderer renderer(640, 480);
    mgSetBackGround(64.0f, 128.0f, 192.0f, 128.0f);
    SetCamera();

    const std::array<uint8_t, 3> background = {64, 128, 192};
    const auto draw = [&](bool reversed, int program_option) {
        MdtFile file(CentreTriangle(reversed));
        MemoryPool pool;
        mgCVisualMDT visual;
        EXPECT_EQ(visual.DataAssignMDT(file.header(), &pool.memory(), nullptr), 1);

        mgCFrameAttr attr;
        attr.no_light = 1;
        attr.program_option = program_option;
        SetColour(attr, {200.0f, 200.0f, 200.0f, 128.0f});
        DrawTickImmediate(visual, attr);

        std::array<uint8_t, 3> pixel = {};
        EXPECT_TRUE(CentrePixel(pixel));
        return pixel;
    };

    const auto forward_flagged = draw(false, 4);
    const auto reversed_flagged = draw(true, 4);
    EXPECT_NE(forward_flagged == background, reversed_flagged == background)
        << "exactly one winding must be culled with the flag set";

    const auto forward_plain = draw(false, 0);
    const auto reversed_plain = draw(true, 0);
    EXPECT_NE(forward_plain, background);
    EXPECT_NE(reversed_plain, background);
}

TEST(MgVisual, RecordedDrawIsKeyedByFrame) {
    VisualRenderer renderer(64, 48);
    SetCamera();

    MdtFile file(CentreTriangle(false));
    MemoryPool pool;
    mgCVisualMDT visual;
    ASSERT_EQ(visual.DataAssignMDT(file.header(), &pool.memory(), nullptr), 1);

    mgCFrameAttr attr;
    attr.no_light = 1;
    SetColour(attr, {200.0f, 200.0f, 200.0f, 128.0f});

    mgCFrame frame;
    frame.SetVisual(&visual);
    frame.attr = &attr;

    u_int tag[4] = {};
    mgBeginFrame(nullptr);
    ASSERT_TRUE(mgPortRecording());
    frame.Draw(tag);
    mgEndFrame(nullptr);

    const gfx::DisplayList *list = mgPortLastList();
    ASSERT_NE(list, nullptr);
    ASSERT_EQ(list->records.size(), 1u);
    EXPECT_EQ(list->records[0].key, KeyOf(&frame));
    EXPECT_NE(list->records[0].key, KeyOf(&visual));
}

namespace {

// A visual whose box sits at logical x = -40, outside the 4:3 screen and inside the 16:9 one.
size_t DrawBoxRecords() {
    ModelSpec model;
    model.vertices = {{-76.0f, -2.0f, 98.0f}, {-72.0f, -2.0f, 98.0f}, {-72.0f, 2.0f, 98.0f}};
    model.faces.push_back({kPrimTriangle | kUntextured, {0, 1, 2}});

    MdtFile file(model);
    MemoryPool pool;
    mgCVisualMDT visual;
    EXPECT_EQ(visual.DataAssignMDT(file.header(), &pool.memory(), nullptr), 1);

    mgCFrame::BoundInfo bound = {};
    const float          lo[3] = {-76.0f, -2.0f, 98.0f};
    const float          hi[3] = {-72.0f, 2.0f, 102.0f};
    for (int corner = 0; corner < 8; corner++) {
        for (int axis = 0; axis < 3; axis++) {
            bound.corner[corner][axis] = (corner >> axis) & 1 ? hi[axis] : lo[axis];
        }
        bound.corner[corner][3] = 1.0f;
    }
    for (int axis = 0; axis < 3; axis++) {
        bound.max[axis] = hi[axis];
        bound.min[axis] = lo[axis];
        bound.center[axis] = 0.5f * (lo[axis] + hi[axis]);
    }
    bound.radius = 5.0f;

    mgCFrameAttr attr;
    attr.no_light = 1;
    SetColour(attr, {200.0f, 200.0f, 200.0f, 128.0f});

    mgCFrame frame;
    frame.SetVisual(&visual);
    frame.SetBound(&bound);
    frame.attr = &attr;

    u_int tag[4] = {};
    mgBeginFrame(nullptr);
    frame.Draw(tag);
    mgEndFrame(nullptr);

    const gfx::DisplayList *list = mgPortLastList();
    EXPECT_NE(list, nullptr);
    return list == nullptr ? 0 : list->records.size();
}

} // namespace

TEST(MgVisual, VisibleExtentKeepsBoxAtSixteenNine) {
    VisualRenderer renderer(1280, 720);
    SetCamera();

    EXPECT_GE(DrawBoxRecords(), 1u);
}

TEST(MgVisual, VisibleExtentCullsBoxAtFourThree) {
    VisualRenderer renderer(1024, 768);
    SetCamera();

    EXPECT_EQ(DrawBoxRecords(), 0u);
}

TEST(MgVisual, ReusedCommonPacketDoesNotReplayPreviousDraw) {
    VisualRenderer renderer(640, 480);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetCamera();
    MemoryPool texture_table;
    mgTexManager.SetTableBuffer(16, 8, &texture_table.memory());
    mgTexManager.Initialize(0x1000, -1);

    MdtFile      file(CentreTriangle(false));
    MemoryPool   model;
    mgCVisualMDT visual;
    ASSERT_EQ(visual.DataAssignMDT(file.header(), &model.memory(), nullptr), 1);

    MemoryPool data_a;
    MemoryPool data_b;
    MemoryPool buffers;
    mgSetDataBuffer(&data_a.memory(), &data_b.memory(), 0);
    mgCFrameAttr attr;
    attr.no_light = 1;
    SetColour(attr, {64.0f, 128.0f, 32.0f, 128.0f});
    float matrix[4][4];
    Identity(matrix);
    PrepareObject(attr);
    int draw_order[2] = {0, -1};

    mgBeginFrame(nullptr);
    mgBeginDraw(&buffers.memory(), draw_order, nullptr);
    const void *common = mgDrawManager.data_memory->stGetTop();
    int         stale_draws = 0;
    // A previous face packet occupied the quadword now reused for an empty common packet.
    mgPortSetPacketDraw(common, [&stale_draws] { ++stale_draws; });
    visual.Draw(nullptr, matrix, nullptr);
    mgPreEndDraw(nullptr);
    mgEndDrawReloadTexture(0, nullptr);
    mgEndDraw(0, nullptr);
    mgEndFrame(nullptr);
    mgPortClearPacketDraw(common);

    EXPECT_EQ(stale_draws, 0);
    ExpectCentre(64, 128, 32);
}

// A mode load reuses the model arena while a draw still owns the previous face's geometry.
TEST(MgVisual, QueuedFixFaceSurvivesFaceAddressReuse) {
    VisualRenderer renderer(640, 480);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetCamera();
    MemoryPool texture_table;
    mgTexManager.SetTableBuffer(16, 8, &texture_table.memory());
    mgTexManager.Initialize(0x1000, -1);

    MdtFile         first_file(CentreTriangle(false, {1.0f, 0.0f, 0.0f, 1.0f}));
    MdtFile         next_file(CentreTriangle(false, {0.0f, 1.0f, 0.0f, 1.0f}));
    MemoryPool      model;
    mgCVisualFixMDT first;
    ASSERT_EQ(first.DataAssignMDT(first_file.header(), &model.memory(), nullptr), 1);
    const mgCFace *face = first.face_group->face;
    const auto    *geometry = mgVisualPortFaceMesh(face);
    ASSERT_NE(geometry, nullptr);
    const gfx::MeshHandle previous = geometry->mesh;
    ASSERT_NE(previous, gfx::kNullMesh);

    MemoryPool data_a;
    MemoryPool data_b;
    MemoryPool buffers;
    mgSetDataBuffer(&data_a.memory(), &data_b.memory(), 0);
    mgCFrameAttr attr;
    attr.no_light = 1;
    SetColour(attr, {128.0f, 128.0f, 128.0f, 128.0f});
    float matrix[4][4];
    Identity(matrix);
    PrepareObject(attr);
    int draw_order[2] = {0, -1};

    mgBeginFrame(nullptr);
    mgBeginDraw(&buffers.memory(), draw_order, nullptr);
    first.Draw(nullptr, matrix, nullptr);

    model.memory().stReset();
    mgCVisualFixMDT next;
    ASSERT_EQ(next.DataAssignMDT(next_file.header(), &model.memory(), nullptr), 1);
    ASSERT_EQ(next.face_group->face, face);
    ASSERT_NE(mgVisualPortFaceMesh(face)->mesh, previous);

    mgPreEndDraw(nullptr);
    mgEndDraw(0, nullptr);
    mgEndFrame(nullptr);
    ExpectCentre(128, 0, 0);

    DrawTickImmediate(next, attr);
    ExpectCentre(0, 128, 0);
}

// Native models refresh shadow faces at load; outside the shadow pass they draw nothing, even straight after a
// lit visual.
TEST(MgVisual, ShadowModelAfterLitVisualDrawsNoMesh) {
    VisualRenderer renderer(640, 480);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetCamera();

    MdtFile      lit_file(CentreTriangle(false));
    MemoryPool   pool;
    mgCVisualMDT lit;
    ASSERT_EQ(lit.DataAssignMDT(lit_file.header(), &pool.memory(), nullptr), 1);

    float positions[3][4] = {
        {-50, -50, 100, 1},
        {150, -50, 100, 1},
        {-50, 150, 100, 1}
    };
    int     indices[] = {0, 1, 2};
    mgCFace face{};
    face.type = kPrimTriangle | kUntextured | MG_FACE_NO_NORMAL;
    face.vertex_num = 3;
    face.index_stride = 1;
    face.index_num = 3;
    face.index = indices;
    mgFACE_GROUP group{};
    group.face = &face;
    mgMaterial material{};
    mgCShadowMDT shadow;
    shadow.vertex = positions;
    shadow.vertex_num = 3;
    shadow.face_group = &group;
    shadow.material = &material;
    shadow.material_num = 1;
    mgVisualPortRefreshFace(&shadow, &face);
    ASSERT_NE(mgVisualPortFaceMesh(&face), nullptr);

    mgCFrameAttr attr;
    attr.no_light = 1;
    SetColour(attr, {128.0f, 128.0f, 128.0f, 128.0f});
    float matrix[4][4];
    Identity(matrix);
    PrepareObject(attr);
    u_int tag[4] = {};

    mgBeginFrame(nullptr);
    lit.Draw(tag, matrix, nullptr);
    shadow.Draw(tag, matrix, nullptr);
    mgEndFrame(nullptr);

    const auto *list = mgPortLastList();
    ASSERT_NE(list, nullptr);
    EXPECT_EQ(list->records.size(), 1u);
}

// Packet quadwords are transient even when their faces were uploaded persistently.
TEST(MgVisual, BeginPacketDropsPreviousFixFaceDraw) {
    VisualRenderer renderer(640, 480);
    SetCamera();
    MemoryPool texture_table;
    mgTexManager.SetTableBuffer(16, 8, &texture_table.memory());
    mgTexManager.Initialize(0x1000, -1);
    MdtFile         file(CentreTriangle(false));
    MemoryPool      model;
    mgCVisualFixMDT visual;
    ASSERT_EQ(visual.DataAssignMDT(file.header(), &model.memory(), nullptr), 1);

    MemoryPool data_a;
    MemoryPool data_b;
    MemoryPool buffers;
    mgSetDataBuffer(&data_a.memory(), &data_b.memory(), 0);
    mgCFrameAttr attr;
    attr.no_light = 1;
    float matrix[4][4];
    Identity(matrix);
    PrepareObject(attr);
    int draw_order[2] = {0, -1};
    mgBeginFrame(nullptr);
    mgBeginDraw(&buffers.memory(), draw_order, nullptr);
    const auto *common = mgDrawManager.data_memory->stGetTop();
    visual.Draw(nullptr, matrix, nullptr);
    const void *packet = common + 1;
    ASSERT_TRUE(mgPortPacketDraw(packet));
    mgEndFrame(nullptr);

    mgBeginFrame(nullptr);
    EXPECT_FALSE(mgPortPacketDraw(packet));
    mgEndFrame(nullptr);
}

namespace {
void CheckMaterialWrap(bool queued) {
    VisualRenderer renderer(640, 480);
    SetCamera();
    MemoryPool table;
    mgTexManager.SetTableBuffer(16, 8, &table.memory());
    mgTexManager.Initialize(0x1000, -1);
    // Repeating (1.25, 1.25) samples green; clamping it samples red.
    alignas(16) uint8_t pixels[16] = {0, 255, 0, 255, 0, 0, 255, 255,
                                      0, 0, 255, 255, 255, 0, 0, 255};
    u_long128          *levels[MG_TEXTURE_LEVEL_MAX] = {reinterpret_cast<u_long128 *>(pixels)};
    char                name[] = "material_wrap";
    auto               *texture = mgTexManager.EnterTexture(0, name, levels, 2, 2, 32, nullptr, 0, 0);
    ASSERT_NE(texture, nullptr);
    texture->Bilinear(0);
    float positions[3][4] = {
        {-50, -50, 100, 1},
        {150, -50, 100, 1},
        {-50, 150, 100, 1}
    };
    float uv[1][4] = {
        {1.25f, 1.25f, 0, 0}
    };
    int     indices[] = {0, 0, 1, 0, 2, 0};
    mgCFace face{};
    face.type = static_cast<u_int>(MG_PRIM_TRIANGLE) | MG_FACE_NO_NORMAL;
    face.vertex_num = 3;
    face.index_stride = 2;
    face.index_num = 6;
    face.index = indices;
    mgFACE_GROUP group{};
    group.face = &face;
    mgMaterial material{};
    material.texture = texture;
    for (float &component : material.diffuse) {
        component = 1.0f;
    }
    mgCVisualMDT visual;
    visual.vertex = positions;
    visual.vertex_num = 3;
    visual.uv = uv;
    visual.uv_num = 1;
    visual.face_group = &group;
    visual.material = &material;
    visual.material_num = 1;
    mgCFrameAttr attr;
    attr.no_light = 1;
    SetColour(attr, {128, 128, 128, 128});
    MemoryPool data_a, data_b, packets;
    mgSetDataBuffer(&data_a.memory(), &data_b.memory(), 0);
    for (int repeat = 0; repeat < 2; ++repeat) {
        texture->clamp.WMS = texture->clamp.WMT = repeat ? 0 : 1;
        mgPortGs().clamp = repeat ? 5 : 0; // The preceding draw uses the opposite wrap.
        float matrix[4][4];
        Identity(matrix);
        PrepareObject(attr);
        mgBeginFrame(nullptr);
        u_int tag[4]{};
        int   order[2] = {0, -1};
        if (queued) {
            mgBeginDraw(&packets.memory(), order, nullptr);
        }
        visual.Draw(queued ? nullptr : tag, matrix, nullptr);
        if (queued) {
            // A subsequent draw changes global state before the mesh packet executes.
            mgPortGs().clamp = repeat ? 5 : 0;
            mgPreEndDraw(nullptr);
            mgEndDraw(0, nullptr);
        }
        mgEndFrame(nullptr);
        const auto *list = mgPortLastList();
        ASSERT_NE(list, nullptr);
        ASSERT_EQ(list->records.size(), 1u);
        const auto &mesh = std::get<gfx::detail::MeshEntry>(list->entries[list->records[0].entry]);
        EXPECT_EQ(mesh.binding.wrap_u, repeat ? gfx::Wrap::Repeat : gfx::Wrap::Clamp);
        EXPECT_EQ(mesh.binding.wrap_v, repeat ? gfx::Wrap::Repeat : gfx::Wrap::Clamp);
        ExpectCentre(repeat ? 0 : 255, repeat ? 255 : 0, 0);
    }
    mgPortGs().clamp = 0;
}
} // namespace

TEST(MgVisual, DirectMaterialUsesItsOwnTextureWrap) { CheckMaterialWrap(false); }

TEST(MgVisual, QueuedMaterialRetainsItsOwnTextureWrap) { CheckMaterialWrap(true); }
