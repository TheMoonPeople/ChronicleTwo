#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mg_visual.hpp"
#include "mg_visual_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/window.hpp"

using namespace dc::test;

namespace {

struct FaceSpec {
    u_int             type;
    std::vector<int> corners;
};

struct ModelSpec {
    std::vector<std::array<float, 3>> vertices;
    std::array<float, 4>              diffuse = {1.0f, 1.0f, 1.0f, 1.0f};
    std::vector<FaceSpec>             faces;
};

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
        const float normal[4] = {0.0f, 0.0f, 1.0f, 0.0f};
        std::memcpy(base + vertex_ofs + 16 * i, position, sizeof position);
        std::memcpy(base + normal_ofs + 16 * i, normal, sizeof normal);
    }

    MDT_MATERIAL_ material = {};
    std::memcpy(material.diffuse, model.diffuse.data(), sizeof material.diffuse);
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

class MemoryPool {
public:
    MemoryPool() : words_(1 << 14) {
        memory_.stSetBuffer(words_.data(), static_cast<int>(words_.size()));
    }

    mgCMemory &memory() {
        return memory_;
    }

private:
    std::vector<u_long128> words_;
    mgCMemory              memory_;
};

class VisualRenderer {
public:
    VisualRenderer() {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{640, 480, true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle visual mesh cache tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 4.0f / 3.0f;
        config.validation = true;
        config.offscreen = true;
        config.prog0_meshes = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("visual_mesh_cache_" + std::to_string(ProcessId()) + ".bin");
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
constexpr u_int kUntextured = MG_FACE_NO_TEXTURE;

ModelSpec CentreTriangle() {
    ModelSpec model;
    model.vertices = {{-50.0f, -50.0f, 100.0f}, {150.0f, -50.0f, 100.0f}, {-50.0f, 150.0f, 100.0f}};
    model.faces.push_back({kPrimTriangle | kUntextured, {0, 1, 2}});
    return model;
}

mgCFace *LoadFixFace() {
    MdtFile         file(CentreTriangle());
    static MemoryPool model;
    static mgCVisualFixMDT visual;
    static bool       loaded = false;
    if (!loaded) {
        // Fix MDT DataAssign already builds face packets (retail CreateFacePacket per face).
        EXPECT_EQ(visual.DataAssignMDT(file.header(), &model.memory(), nullptr), 1);
        loaded = true;
    }
    return visual.face_group->face;
}

} // namespace

TEST(VisualMeshCache, MeshUploadCountStartsAtZero) {
    VisualRenderer renderer;
    mgVisualPortResetMeshUploadCountForTest();
    EXPECT_EQ(mgVisualPortMeshUploadCountForTest(), 0);
}

TEST(VisualMeshCache, RepeatedFaceMeshLookupUploadsOnce) {
    VisualRenderer renderer;
    mgVisualPortResetMeshUploadCountForTest();
    mgCFace *face = LoadFixFace();

    const mgVisualFaceMesh *first = mgVisualPortFaceMesh(face);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(first->mesh, gfx::kNullMesh);
    EXPECT_EQ(mgVisualPortMeshUploadCountForTest(), 1u);

    const mgVisualFaceMesh *second = mgVisualPortFaceMesh(face);
    ASSERT_EQ(second, first);
    EXPECT_EQ(mgVisualPortMeshUploadCountForTest(), 1u);
}

TEST(VisualMeshCache, SweepRunsOncePerFrameAtEndFrame) {
    VisualRenderer renderer;
    mgVisualPortResetSweepPassCountForTest();
    mgCFace *face = LoadFixFace();

    mgBeginFrame(nullptr);
    mgVisualPortFaceMesh(face);
    mgVisualPortFaceMesh(face);
    EXPECT_EQ(mgVisualPortSweepPassCountForTest(), 0);
    mgEndFrame(nullptr);
    EXPECT_EQ(mgVisualPortSweepPassCountForTest(), 1);

    mgBeginFrame(nullptr);
    mgVisualPortFaceMesh(face);
    mgEndFrame(nullptr);
    EXPECT_EQ(mgVisualPortSweepPassCountForTest(), 2);
}
