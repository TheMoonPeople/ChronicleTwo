#include "common.h"

#include <array>
#include <cstring>
#include <memory>
#include <unordered_map>
#include <vector>

#include "mg_dataset.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mg_visual_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "visualmotion.hpp"

namespace {

constexpr int kFaceUnusedFrameLimit = 600;
// Persistent faces retain CPU geometry while idle GPU meshes release their slots.
constexpr int kPersistentMeshUnusedFrameLimit = 1800;

// The GS guard band reaches 10% past the screen on each side; the six-plane clip keeps what lies inside it.
constexpr float kGuardScale = 1.1f;

constexpr u_int kPrmodeFog = 0x20;
constexpr u_int kPrmodeBlend = 0x40;
// Gouraud shading, texture mapping and blending: the PRMODE every visual starts from.
constexpr u_int kPrmodeDefault = 0x58;

// The retail material's specular exponent (mat_pw).
constexpr uint32_t kMaterialPower = 3;

// mesh_prog0.vert reads the byte as byte / 255 and multiplies by 255 / 128, so 0x80 is the VU's 1.0 and
// the largest representable VU colour is 255 / 128.
constexpr uint8_t kVuUnitColour = 0x80;

uint8_t VuColourByte(float value) {
    const float scaled = value * 128.0f;
    if (!(scaled > 0.0f)) {
        return 0;
    }
    if (scaled >= 255.0f) {
        return 255;
    }
    return static_cast<uint8_t>(scaled + 0.5f);
}

struct CornerStreams {
    int position;
    int normal;
    int uv;
    int colour;
};

CornerStreams CornerOf(const mgCFace &face, int corner) {
    const int    *cursor = face.index + corner * face.index_stride;
    CornerStreams streams = {cursor[0], -1, -1, -1};
    int           next = 1;

    if ((face.type & MG_FACE_NO_NORMAL) == 0) {
        streams.normal = cursor[next++];
    }
    if ((face.type & MG_FACE_NO_TEXTURE) == 0) {
        streams.uv = cursor[next++];
    }
    if ((face.type & MG_FACE_COLOUR) != 0) {
        streams.colour = cursor[next++];
    }
    return streams;
}

gfx::Vertex3D CornerVertex(const mgCVisualMDT &visual, const CornerStreams &streams) {
    gfx::Vertex3D vertex = {};
    const float  *position = visual.vertex[streams.position];

    for (int i = 0; i < 3; i++) {
        vertex.position[i] = position[i];
    }
    if (streams.normal >= 0) {
        const float *normal = visual.normal[streams.normal];
        for (int i = 0; i < 3; i++) {
            vertex.normal[i] = normal[i];
        }
    }
    if (streams.uv >= 0) {
        const float *uv = visual.uv[streams.uv];
        vertex.uv[0] = uv[0];
        vertex.uv[1] = uv[1];
    }
    for (int i = 0; i < 4; i++) {
        vertex.color[i] = streams.colour >= 0 ? VuColourByte(visual.colour[streams.colour][i]) : kVuUnitColour;
    }
    return vertex;
}

gfx::Vertex3D SkinSlot(const mgVertexWeight &weight) {
    gfx::Prog0Skin skin = {};
    for (int i = 0; i < 4; i++) {
        skin.weight[i] = weight.weight[i];
        skin.bone[i] = static_cast<uint8_t>(weight.matrix[i] / 4);
    }

    gfx::Vertex3D slot = {};
    std::memcpy(&slot, &skin, sizeof slot);
    return slot;
}

struct FaceEntry {
    std::shared_ptr<mgVisualFaceMesh> mesh;
    bool                              persistent = false;
    int                               last_frame = 0;
};

std::unordered_map<const mgCFace *, FaceEntry> &FaceTable() {
    static std::unordered_map<const mgCFace *, FaceEntry> table;
    return table;
}

void ReleaseMesh(mgVisualFaceMesh &mesh) {
    if (mesh.mesh != gfx::kNullMesh) {
        gfx::DestroyMesh(mesh.mesh);
        mesh.mesh = gfx::kNullMesh;
    }
}

// The CPU copy supports reupload after eviction and immediate draws when no mesh slot is free.
void UploadIfReady(FaceEntry &entry) {
    mgVisualFaceMesh &mesh = *entry.mesh;
    if (!entry.persistent || mesh.mesh != gfx::kNullMesh || mesh.indices.empty() ||
        !mgPortRendererReady()) {
        return;
    }

    mesh.mesh = gfx::CreateMesh(mesh.vertices, mesh.indices);
}

} // namespace

mgVisualFaceMesh mgVisualPortBuildFace(const mgCVisualMDT &visual, const mgCFace &face, bool skinned) {
    mgVisualFaceMesh out;
    out.skinned = skinned;
    out.type = face.type;

    const int corner_count = face.vertex_num;
    if (corner_count <= 0) {
        return out;
    }

    const mgVertexWeight *weights = nullptr;
    if (skinned) {
        // Skin is carried only by a mgCVisualMotionMDT. When its bones overflow, retail leaves the weights
        // NULL and then reads through them, so such a face has no geometry here.
        const mgCVisualMotionMDT &motion = static_cast<const mgCVisualMotionMDT &>(visual);
        if (motion.weight == nullptr) {
            return out;
        }
        weights = motion.weight;
    }

    for (int corner = 0; corner < corner_count; corner++) {
        const CornerStreams streams = CornerOf(face, corner);
        out.vertices.push_back(CornerVertex(visual, streams));
        if (skinned) {
            out.vertices.push_back(SkinSlot(weights[streams.position]));
        }
    }

    if ((face.type & MG_FACE_PRIM_MASK) == MG_PRIM_TRIANGLE_STRIP) {
        // Retail restarts the winding parity at each VU1 batch; that is a batching artefact and is not
        // reproduced, so the whole strip keeps one winding.
        for (int t = 0; t + 2 < corner_count; t++) {
            const bool odd = (t & 1) != 0;
            out.indices.push_back(static_cast<uint32_t>(odd ? t + 1 : t));
            out.indices.push_back(static_cast<uint32_t>(odd ? t : t + 1));
            out.indices.push_back(static_cast<uint32_t>(t + 2));
        }
    } else {
        for (int corner = 0; corner + 2 < corner_count; corner += 3) {
            out.indices.push_back(static_cast<uint32_t>(corner));
            out.indices.push_back(static_cast<uint32_t>(corner + 1));
            out.indices.push_back(static_cast<uint32_t>(corner + 2));
        }
    }

    out.index_count = static_cast<uint32_t>(out.indices.size());
    return out;
}

void mgVisualPortRefreshFace(mgCVisualMDT *visual, mgCFace *face) {
    const int kind = visual->Iam();

    // A plain visual is rebuilt on every CreateFacePacket and would churn GPU meshes if uploaded, so it stays
    // on the CPU.
    FaceEntry &entry = FaceTable()[face];
    // Address reuse replaces the table's owner. Queued draws keep the previous geometry alive until their
    // packet arena is reset; the last owner releases its GPU mesh, including during display-list recording.
    entry.mesh = std::shared_ptr<mgVisualFaceMesh>(
        new mgVisualFaceMesh(mgVisualPortBuildFace(*visual, *face, kind == MG_VISUAL_KIND_MOTION_MDT)),
        [](mgVisualFaceMesh *mesh) {
            ReleaseMesh(*mesh);
            delete mesh;
        });
    entry.persistent = kind == MG_VISUAL_KIND_FIX_MDT || kind == MG_VISUAL_KIND_MOTION_MDT;
    entry.last_frame = mgPortFrameCount();
    UploadIfReady(entry);
}

namespace {

std::shared_ptr<const mgVisualFaceMesh> FaceMesh(const mgCFace *face) {
    auto &table = FaceTable();
    auto  found = table.find(face);
    if (found == table.end()) {
        return nullptr;
    }

    FaceEntry &entry = found->second;
    entry.last_frame = mgPortFrameCount();
    UploadIfReady(entry);
    mgVisualPortSweep();
    return entry.mesh;
}

} // namespace

const mgVisualFaceMesh *mgVisualPortFaceMesh(const mgCFace *face) {
    return FaceMesh(face).get();
}

void mgVisualPortSweep() {
    static int swept_frame = -1;
    const int  frame = mgPortFrameCount();
    if (frame == swept_frame) {
        return;
    }
    swept_frame = frame;

    auto &table = FaceTable();
    for (auto it = table.begin(); it != table.end();) {
        const int unused = frame - it->second.last_frame;
        if (it->second.persistent) {
            if (unused > kPersistentMeshUnusedFrameLimit) {
                ReleaseMesh(*it->second.mesh);
            }
            ++it;
            continue;
        }
        if (unused <= kFaceUnusedFrameLimit) {
            ++it;
            continue;
        }
        // A queued draw may still own this CPU geometry after the table forgets it.
        it = table.erase(it);
    }
}

PORT_OVERRIDE u_int *GetScrPad() {
    PS2_UNIMPLEMENTED();
}

PORT_OVERRIDE int mgCVisualMDT::CreateFacePacket(u_int *packet, mgCFace *face) {
    if (face != NULL) {
        mgVisualPortRefreshFace(this, face);
    }
    return 0;
}

// Retail's body carries 128-bit GS literals the host compiler cannot represent. Only the retail packet builders
// call it, and CreatePacket is overridden.
PORT_OVERRIDE int mgCVisualMDT::SetMaterialRef(u_long128 *packet, mgMaterial *material, int flags) {
    return 0;
}

namespace {

struct RenderRecord {
    gfx::MeshConstants  mesh;
    gfx::Prog0Constants prog0;
    gfx::MeshTransform  transform;
    gfx::DrawState      state;
    bool                drawn = false;
};

RenderRecord &CurrentRecord() {
    static RenderRecord record;
    return record;
}

const void *current_object = nullptr;

// A draw owns its immutable geometry independently of the face address in the load arena.
struct FaceDraw {
    std::shared_ptr<const mgVisualFaceMesh> geometry;
    gfx::TextureBinding                     binding;
    uint32_t                                face_flags;
};

struct GroupDraw {
    gfx::MeshConstants  mesh;
    gfx::Prog0Constants prog0;
    gfx::MeshTransform  transform;
    gfx::DrawState      state;
    const void         *object;
};

// Both prog0 submissions. Every call goes through here, so the renderer and frame checks mgPortDrawMesh makes
// apply to all of them.
void SubmitFaces(const GroupDraw &group, const std::vector<FaceDraw> &faces) {
    if (!mgPortRendererReady() || !mgPortFrameOpen()) {
        return;
    }

    mgPortInterpScope   scope(group.object, kMgPortFrameTeleportDistance);
    gfx::Prog0Constants prog0 = group.prog0;

    for (const FaceDraw &face : faces) {
        prog0.face = face.face_flags;

        if (face.geometry->mesh != gfx::kNullMesh) {
            mgPortDrawMeshProg0(face.geometry->mesh, 0, face.geometry->index_count, group.mesh, prog0, face.binding,
                                group.state, &group.transform);
        } else {
            mgPortDrawMeshImmediateProg0(face.geometry->vertices, face.geometry->indices, group.mesh, prog0,
                                         face.binding, group.state, &group.transform);
        }
    }
}

// Maps the clip space of the guard band onto the visible extent: the extent's centre and half sizes sit inside
// the guard, so at a 4:3 window the matrix is the identity.
void VisibleClipFit(float (*fit)[4]) {
    const mgPortExtent extent = mgPortVisibleExtent();
    const float        half_screen_w = 0.5f * static_cast<float>(mgScreenWidth);
    const float        half_screen_h = 0.5f * static_cast<float>(mgScreenHeight);
    const float        half_w = 0.5f * (extent.right - extent.left);
    const float        half_h = 0.5f * (extent.bottom - extent.top);
    const float        centre_x = 0.5f * (extent.left + extent.right) - half_screen_w;
    const float        centre_y = 0.5f * (extent.top + extent.bottom) - half_screen_h;

    std::memset(fit, 0, 16 * sizeof(float));
    fit[0][0] = half_screen_w / half_w;
    fit[3][0] = -centre_x / (kGuardScale * half_w);
    fit[1][1] = half_screen_h / half_h;
    fit[3][1] = -centre_y / (kGuardScale * half_h);
    fit[2][2] = 1.0f;
    fit[3][3] = 1.0f;
}

// Retail scales the screen matrix's z translation by 1.005; that term is projection[14] scaled by the same
// factor, so the bias is a multiply on the clip-space translation.
void ApplyDepthBias(gfx::MeshTransform &transform) {
    transform.projection[14] *= 1.005f;
}

} // namespace

// The base environment with the face's test, alpha and depth-write attributes applied. Retail packs the
// same result into a GIF tag; the port keeps the register state as the mgCDrawEnv itself.
mgCDrawEnv mgVisualPortDrawEnv(const mgCVisualAttr &attr, const mgCDrawEnv &base) {
    mgCDrawEnv env = base;

    if (attr.alpha_ref >= 0) {
        env.test.bits.aref = attr.alpha_ref;
    }

    if (attr.z_test != 0) {
        env.test.bits.zte = 1;
        switch (attr.z_test) {
            case -1:
                env.test.bits.ztst = 1;
                break;
            case 1:
                env.test.bits.ztst = 2;
                break;
            case 2:
                env.test.bits.ztst = 3;
                break;
        }
    }

    if (attr.alpha_test > 0) {
        env.test.bits.ate = 1;
        env.test.bits.atst = attr.alpha_test;
    } else if (attr.alpha_test == -1) {
        env.test.bits.ate = 0;
    }

    switch (attr.dest_alpha_test) {
        case -1:
            env.test.bits.date = 0;
            break;
        case 1:
            env.test.bits.date = 1;
            env.test.bits.datm = 0;
            break;
        case 2:
            env.test.bits.date = 1;
            env.test.bits.datm = 1;
            break;
    }

    if (attr.alpha_blend != 0) {
        env.SetAlpha(attr.alpha_blend);
    }

    env.SetZBuf(attr.z_write);
    return env;
}

const void *mgVisualPortObject() {
    return current_object;
}

void mgVisualPortSetObject(const void *object) {
    current_object = object;
}

gfx::Prog0Constants &mgVisualPortCurrentProg0() {
    return CurrentRecord().prog0;
}

PORT_OVERRIDE int mgCVisualMDT::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) {
    RenderRecord &record = CurrentRecord();
    record.drawn = info->attr != NULL;

    if (!record.drawn) {
        return 0;
    }

    const mgCFrameAttr  &attr = *info->attr;
    mgLIGHT_INFO        *lighting = info->GetpLightInfo();
    gfx::Prog0Constants &prog0 = record.prog0;

    std::memset(&prog0, 0, sizeof prog0);
    for (auto &bone : prog0.bones) {
        for (int row = 0; row < 3; row++) {
            for (int col = 0; col < 4; col++) {
                bone[row][col] = row == col ? 1.0f : 0.0f;
            }
        }
    }

    record.transform = mgPortMeshTransform(&matrix[0][0]);
    if (attr.depth_bias > 1.0f) {
        ApplyDepthBias(record.transform);
    }

    float (*projection)[4] = reinterpret_cast<float (*)[4]>(record.transform.projection);
    float (*view)[4] = reinterpret_cast<float (*)[4]>(record.transform.view);
    float (*model)[4] = reinterpret_cast<float (*)[4]>(record.transform.model);
    sceVu0FMATRIX view_model;
    sceVu0FMATRIX mvp;
    mgMulMatrix(view_model, view, model);
    mgMulMatrix(mvp, projection, view_model);
    record.mesh = gfx::MeshConstants();
    std::memcpy(record.mesh.mvp, mvp, sizeof mvp);

    std::memcpy(prog0.model_world, matrix, sizeof prog0.model_world);
    for (int k = 0; k < 3; k++) {
        std::memcpy(prog0.light_direction[k], lighting->light_dir[k], sizeof prog0.light_direction[k]);
    }
    std::memcpy(prog0.light_color, lighting->light_color, sizeof prog0.light_color);
    std::memcpy(prog0.ambient, lighting->ambient, sizeof prog0.ambient);
    prog0.ambient[3] *= attr.obj_alpha;

    if (attr.ambient_boost != 0) {
        for (int i = 0; i < 3; i++) {
            prog0.object_color[i] = 0.3f * lighting->light_color[0][i] + lighting->ambient[i];
        }
        prog0.object_color[3] = info->object_color[3];
    } else {
        std::memcpy(prog0.object_color, info->object_color, sizeof prog0.object_color);
    }
    prog0.object_color[3] *= attr.obj_alpha;

    if (attr.program_mode != 0) {
        sceVu0FVECTOR eye = {info->camera_pos[0], info->camera_pos[1], info->camera_pos[2], 1.0f};
        sceVu0FMATRIX inverse;
        sceVu0CopyMatrix(inverse, matrix);
        sceVu0InversMatrix(inverse, inverse);
        sceVu0ApplyMatrix(eye, inverse, eye);
        std::memcpy(prog0.eye, eye, sizeof prog0.eye);
    }

    float (*clip_or_view)[4] = reinterpret_cast<float (*)[4]>(prog0.clip_or_view);
    if (info->scissor != 0) {
        sceVu0FMATRIX model_clip;
        sceVu0FMATRIX fit;
        mgMulMatrix(model_clip, info->world_clip, matrix);
        VisibleClipFit(fit);
        mgMulMatrix(clip_or_view, fit, model_clip);
    }

    if (attr.program_mode & 0x2) {
        mgMulMatrix(clip_or_view, info->view, matrix);
    }

    if (info->plight_hit != 0 && info->lighting_enabled != 0) {
        for (int i = 0; i < 4; i++) {
            const mgPOINT_LIGHT &light = lighting->point_light[i];
            for (int k = 0; k < 3; k++) {
                prog0.point_light[i][k] = light.pos[k] - matrix[3][k];
            }
            prog0.point_light[i][3] = light.power;
            std::memcpy(prog0.point_color[i], light.color, sizeof prog0.point_color[i]);
        }
    }

    prog0.fog[0] = info->fog.offset;
    prog0.fog[1] = info->fog.near_value;
    prog0.fog[2] = info->fog.far_value;
    prog0.fog[3] = info->fog.scale;

    uint32_t flags = 0;
    if ((info->clip | info->scissor) != 0) {
        flags |= gfx::kProg0Clip;
    }
    if (info->scissor != 0) {
        flags |= gfx::kProg0Scissor;
    }
    if (attr.program_mode & 0x1) {
        flags |= gfx::kProg0Real;
    }
    if (attr.program_mode & 0x2) {
        flags |= gfx::kProg0RefSphere;
    }
    if (attr.program_option != 0) {
        flags |= gfx::kProg0Cull;
    }
    if (info->plight_hit != 0) {
        flags |= gfx::kProg0PointLights;
    }
    if (info->motion != 0) {
        flags |= gfx::kProg0Skinned;
    }
    if (attr.no_light != 0 || info->lighting_enabled == 0 || attr.ambient_boost != 0) {
        flags |= gfx::kProg0Unlit;
    }
    if (attr.unk_84 == 1) {
        flags |= gfx::kProg0ColorAdd;
    }
    prog0.flags = flags;

    const bool fogged = attr.fog != 0 && info->fog_enable != 0;
    this->prmode = (fogged ? kPrmodeFog : 0) | kPrmodeDefault;

    const mgCDrawEnv env = mgVisualPortDrawEnv(attr, draw_env != NULL ? *draw_env : info->draw_env[0]);

    record.state = mgPortDrawState();
    mgPortApplyDrawEnv(record.state, env);
    record.state.blend = (this->prmode & kPrmodeBlend) != 0;
    record.state.fog = fogged;

    uint8_t fog_rgb[3] = {info->fog.r, info->fog.g, info->fog.b};
    if (attr.fog > MG_FOG_SCENE) {
        const uint8_t value = attr.fog == MG_FOG_WHITE ? 0xFF : 0x00;
        fog_rgb[0] = fog_rgb[1] = fog_rgb[2] = value;
    }
    for (int c = 0; c < 3; c++) {
        record.state.fog_color[c] = fog_rgb[c];
    }

    record.drawn = true;
    CreateExtRenderInfoPacket(NULL, matrix, info);
    return 0;
}

PORT_OVERRIDE uptr mgCVisualMDT::CreatePacket(mgCDrawManager *manager) {
    for (mgFACE_GROUP *group = face_group; group != NULL; group = group->next) {
        for (mgCFace *face = group->face; face != NULL; face = face->next) {
            CreateFacePacket(NULL, face);
        }
    }
    return 0;
}

PORT_OVERRIDE uptr mgCVisualFixMDT::CreatePacket(mgCDrawManager *manager) {
    return 0;
}

PORT_OVERRIDE int mgCVisualMDT::Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *draw_manager) {
    if (draw_manager == NULL) {
        draw_manager = &mgDrawManager;
    }

    mgRENDER_INFO *info = draw_manager->render_info;
    texture_manager = draw_manager->texture_manager;
    prev_tex = 0;
    // A shadow model's CreateRenderInfoPacket leaves the record alone, so the previous visual's record must not
    // send the shadow faces down as lit meshes in that visual's place.
    CurrentRecord().drawn = false;
    CreateRenderInfoPacket(NULL, matrix, info);
    CreatePacket(draw_manager);

    const RenderRecord &record = CurrentRecord();
    if (!record.drawn) {
        return 0;
    }

    const void *object = mgVisualPortObject();
    if (object == nullptr) {
        object = this;
    }

    u_long128 *common = NULL;
    if (tag == NULL) {
        common = draw_manager->data_memory->Alloc(1);
        if (common == NULL) {
            return 0;
        }
        // This common packet is empty; its reused address may still hold an earlier face draw.
        mgPortClearPacketDraw(common);
    }

    for (mgFACE_GROUP *group = face_group; group != NULL; group = group->next) {
        mgMaterial         *mat = material + group->material;
        gfx::TextureBinding binding = mgPortBinding(mat->texture);
        // Retail SetMaterialRef writes this texture's CLAMP for every material.
        // Record it with the mesh instead of inheriting another draw's wrap state.
        if (mat->texture != nullptr) {
            binding.wrap_u = mgPortWrapU(mat->texture->clamp_bits);
            binding.wrap_v = mgPortWrapV(mat->texture->clamp_bits);
        }

        GroupDraw draw;
        draw.mesh = record.mesh;
        draw.prog0 = record.prog0;
        std::memcpy(draw.prog0.diffuse, mat->diffuse, sizeof draw.prog0.diffuse);
        std::memcpy(draw.prog0.specular, mat->unk_10, sizeof draw.prog0.specular);
        draw.prog0.specular_power = kMaterialPower;
        draw.transform = record.transform;
        draw.state = record.state;
        draw.state.cull = gfx::Prog0CullMode(draw.prog0);
        draw.object = object;

        std::vector<FaceDraw> faces;
        for (mgCFace *face = group->face; face != NULL; face = face->next) {
            const auto geometry = FaceMesh(face);
            if (geometry == NULL || (geometry->mesh == gfx::kNullMesh && geometry->indices.empty())) {
                continue;
            }

            FaceDraw entry;
            entry.geometry = geometry;
            entry.face_flags = face->type & (gfx::kProg0FaceNoTexture | gfx::kProg0FaceColor | gfx::kProg0FaceNoNormal);
            entry.binding = (face->type & MG_FACE_NO_TEXTURE) != 0 ? gfx::TextureBinding() : binding;
            faces.push_back(entry);
        }

        if (tag != NULL) {
            SubmitFaces(draw, faces);
            continue;
        }

        u_long128 *packet = draw_manager->data_memory->Alloc(1);
        if (packet == NULL) {
            break;
        }

        mgPortSetPacketDraw(packet, [draw, faces = std::move(faces)]() {
            SubmitFaces(draw, faces);
        });

        const int block = mat->texture != NULL ? mat->texture->block : -1;
        draw_manager->AddPacket(block, common, packet, group->vu_program);
    }

    return 0;
}
