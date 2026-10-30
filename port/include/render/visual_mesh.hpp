#pragma once

#include <cstdint>
#include <vector>

#include "gfx/gfx.hpp"
#include "mg_drawenv.hpp"

class mgCFace;
struct mgFACE_GROUP;
class mgCVisualMDT;

// One face's triangles, kept on the CPU; the face group's batch is built from them.
struct mgVisualFaceMesh {
    std::vector<gfx::Vertex3D> vertices;
    std::vector<uint32_t>      indices;
    uint32_t                   index_count = 0;
    bool                       skinned = false;
    uint16_t                   type = 0;
};

// A stretch of consecutive faces of a group with the same prog0 face flags, drawn as one index range.
struct mgVisualGroupRun {
    uint32_t first_index = 0;
    uint32_t index_count = 0;
    uint32_t face_flags = 0; // the faces' MG_FACE_NO_TEXTURE, MG_FACE_COLOUR and MG_FACE_NO_NORMAL bits
};

// The faces of consecutive face groups that share a material and microprogram, concatenated in draw order, so
// they draw once per run instead of once per face.
struct mgVisualGroupMesh {
    gfx::MeshHandle               mesh = gfx::kNullMesh;
    std::vector<gfx::Vertex3D>    vertices;
    std::vector<uint32_t>         indices;
    std::vector<mgVisualGroupRun> runs;
    bool                          skinned = false;
};

mgVisualFaceMesh        mgVisualPortBuildFace(const mgCVisualMDT &visual, const mgCFace &face, bool skinned);
void                    mgVisualPortRefreshFace(mgCVisualMDT *visual, mgCFace *face);
const mgVisualFaceMesh *mgVisualPortFaceMesh(const mgCFace *face);
// The batch of the current face meshes of the groups from first up to end (exclusive), rebuilt when a face was
// refreshed and uploaded when it can be.
const mgVisualGroupMesh *mgVisualPortGroupMesh(const mgFACE_GROUP *first, const mgFACE_GROUP *end);
void                     mgVisualPortSweep();

mgCDrawEnv mgVisualPortDrawEnv(const mgCVisualAttr &attr, const mgCDrawEnv &base);

// The current visual's record is a file static in mg_visual.cpp; the motion visual writes its bones to the palette.
gfx::Prog0Constants &mgVisualPortCurrentProg0();
// The bones of the current record's skinned draw; only kProg0Skinned records read them.
gfx::Prog0Palette &mgVisualPortCurrentPalette();

// The object a visual is drawn under (the mgCFrame whose Draw is running), or nullptr. Mesh draws key their
// interpolation by it; it is never dereferenced.
const void *mgVisualPortObject();
void        mgVisualPortSetObject(const void *object);

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
