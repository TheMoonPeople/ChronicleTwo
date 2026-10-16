#pragma once

#include <cstdint>
#include <vector>

#include "gfx/gfx.hpp"
#include "mg_drawenv.hpp"

class mgCFace;
class mgCVisualMDT;

struct mgVisualFaceMesh {
    gfx::MeshHandle mesh = gfx::kNullMesh;
    std::vector<gfx::Vertex3D> vertices;
    std::vector<uint32_t> indices;
    uint32_t index_count = 0;
    bool skinned = false;
    uint16_t type = 0;
};

mgVisualFaceMesh mgVisualPortBuildFace(const mgCVisualMDT &visual, const mgCFace &face, bool skinned);
void mgVisualPortRefreshFace(mgCVisualMDT *visual, mgCFace *face);
const mgVisualFaceMesh *mgVisualPortFaceMesh(const mgCFace *face);
void mgVisualPortSweep();

// Test hooks for mesh upload and face-table sweep (not used in retail paths).
int mgVisualPortMeshUploadCountForTest();
void mgVisualPortResetMeshUploadCountForTest();
int mgVisualPortSweepPassCountForTest();
void mgVisualPortResetSweepPassCountForTest();

mgCDrawEnv mgVisualPortDrawEnv(const mgCVisualAttr &attr, const mgCDrawEnv &base);

// The motion visual writes its bones here: CreateRenderInfoPacket's record is a file static in mg_visual.cpp.
gfx::Prog0Constants &mgVisualPortCurrentProg0();

// The object a visual is drawn under (the mgCFrame whose Draw is running), or nullptr. Mesh draws key their
// interpolation by it; it is never dereferenced.
const void *mgVisualPortObject();
void mgVisualPortSetObject(const void *object);

class mgVisualPortObjectScope {
public:
    explicit mgVisualPortObjectScope(const void *object) : previous_(mgVisualPortObject()) {
        mgVisualPortSetObject(object);
    }
    ~mgVisualPortObjectScope() {
        mgVisualPortSetObject(previous_);
    }
    mgVisualPortObjectScope(const mgVisualPortObjectScope &) = delete;
    mgVisualPortObjectScope &operator=(const mgVisualPortObjectScope &) = delete;

private:
    const void *previous_;
};
