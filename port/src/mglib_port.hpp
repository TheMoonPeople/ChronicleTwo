#pragma once

// The seam between the mglib replacement (port/src/mglib.cpp) and the Phase-4 units.
// Frozen: later changes are additive only.
//
// Conventions: matrices are column-major float[16] (the sceVu0FMATRIX memory layout), mapping to Vulkan
// clip space with y down and reverse-Z (near 1, far 0). GS register values are the raw 64-bit words.
// Logical coordinates are the current target's, as gfx defines them.

#include <cstdint>
#include <filesystem>
#include <optional>
#include <span>
#include <vector>

#include "gfx/gfx.hpp"

class mgCTexture;
class mgCDrawEnv;

// Frame

// False until mgInit has run on an initialised renderer. Code that can draw from the now-loading
// fiber checks it before drawing.
bool mgPortRendererReady();
bool mgPortFrameOpen();
int mgPortFrameCount();
// mgEndFrame of frame `frames` writes `screenshot` (if not empty) and exits the process with kExitOk.
void mgPortExitAfterFrames(int frames, const std::filesystem::path &screenshot);

struct mgPortScreenshotOptions {
    int  display_frames = 0;
    bool fps = false;
};
// Applies to the screenshot of mgPortExitAfterFrames; set it before that call.
void mgPortSetScreenshotOptions(const mgPortScreenshotOptions &options);

// Projection

struct mgPortProjection {
    float eye = 0.0f;       // mgRENDER_INFO::projection: screen-plane distance in target pixels
    float near_z = 0.0f;
    float far_z = 0.0f;
    float aspect_y = 1.0f;  // retail vertical pixel scale, mgRENDER_INFO::aspect[1][1]
    float width = 0.0f;     // target size the 2048-centred screen matrix is centred on
    float height = 0.0f;
};

mgPortProjection mgPortCurrentProjection();
// View space (mgRENDER_INFO::view output) to clip space on `target`, pixel-matched to retail's
// 2048-centred screen matrix inside the logical frame.
void mgPortEyeToClip(const mgPortProjection &projection, gfx::TextureHandle target, float out[16]);
// World to clip on the current target with mgRenderInfo.view.
void mgPortWorldToClip(float out[16]);
gfx::MeshTransform mgPortMeshTransform(const float model[16]);
float mgPortDepth(uint32_t gs_z);
uint32_t mgPortGsDepth(float depth);
// GS primitive coordinates (12.4, XYOFFSET applied) to logical coordinates on the current target.
float mgPortLogicalX(int gs_x);
float mgPortLogicalY(int gs_y);

// Visible extent

// What the current target shows, in the game's screen units: x/y relative to the top-left of the
// game's screen (0..mgScreenWidth, 0..mgScreenHeight at 4:3); half_* centred on the screen centre
// (what retail's 256/240 half extents become); gs_* the 2048-centred GS pixel coordinates
// (mgScreenOffx + x). Wider than the screen on a wider window under AspectMode::Fill.
struct mgPortExtent {
    float left = 0.0f;
    float top = 0.0f;
    float right = 0.0f;
    float bottom = 0.0f;
    float half_width = 0.0f;
    float half_height = 0.0f;
    float gs_left = 0.0f;
    float gs_top = 0.0f;
    float gs_right = 0.0f;
    float gs_bottom = 0.0f;
};

mgPortExtent mgPortVisibleExtent();
mgPortExtent mgPortVisibleExtent(gfx::TextureHandle target);

// GS state (context 1) for draws whose packets are replaced

struct mgPortGsState {
    uint64_t test = 0;
    uint64_t zbuf = 0;
    uint64_t alpha = 0;
    uint64_t texa = 0;
    uint64_t clamp = 0;
    uint64_t tex1 = 0;
    int scissor[4] = {};    // SCAX0, SCAY0, SCAX1, SCAY1, inclusive target pixels
    uint8_t fog_color[3] = {};
    // Colour survives primitive and packet boundaries until another Color call.
    uint8_t prim_color[4] = {0xFF, 0xFF, 0xFF, 0xFF};
    // TEX0/TEX1 as the last mgCDrawPrim::Texture wrote them; Initialize clears a builder, not the GS.
    uint64_t    prim_tex0 = 0;
    uint64_t    prim_tex1 = 0;
    const void *prim_tex_owner = nullptr; // the builder that wrote them
    // Builders inherit them only while set: the dungeon status board is the one caller that relies on it.
    bool inherit_prim_texture = false;
};

mgPortGsState &mgPortGs();
// Back to the state My_dma_start0 leaves the GS in.
void mgPortResetGs();
gfx::DrawState mgPortDrawState();
gfx::DrawState mgPortDrawState(const mgPortGsState &state);
void mgPortApplyTest(gfx::DrawState &state, uint64_t test);
void mgPortApplyZbuf(gfx::DrawState &state, uint64_t zbuf);
void mgPortApplyAlpha(gfx::DrawState &state, uint64_t alpha);
void mgPortApplyTexa(gfx::DrawState &state, uint64_t texa);
void mgPortApplyScissor(gfx::DrawState &state, const int scissor[4]);
void mgPortApplyDrawEnv(gfx::DrawState &state, const mgCDrawEnv &env);
gfx::Wrap mgPortWrapU(uint64_t clamp);
gfx::Wrap mgPortWrapV(uint64_t clamp);
gfx::Filter mgPortFilter(uint64_t tex1);

// Textures. The texture registry (mg_texture.cpp) installs the lookups; render targets and the frame
// buffers resolve here first.

struct mgPortTexture {
    gfx::TextureHandle texture = gfx::kNullTexture;
    gfx::TextureHandle palette = gfx::kNullTexture;
};

using mgPortTextureLookup = mgPortTexture (*)(const mgCTexture *texture);
using mgPortTex0Lookup = mgPortTexture (*)(uint64_t tex0);

void mgPortSetTextureLookup(mgPortTextureLookup by_texture, mgPortTex0Lookup by_tex0);
mgPortTexture mgPortFindTexture(const mgCTexture *texture);
mgPortTexture mgPortFindTexture(uint64_t tex0);
// Current CLAMP and the texture's TEX1/TCC applied.
gfx::TextureBinding mgPortBinding(const mgCTexture *texture);
gfx::TextureBinding mgPortBinding(uint64_t tex0, uint64_t tex1);
// Adopt the source's baked colour variant for a texture animation destination.
void mgPortAdoptColorVariant(const mgCTexture *src, mgCTexture *dst);

// Render targets

gfx::TextureHandle mgPortCurrentTarget();
/**
 * Returns the host texel scale of a registered image or animation target.
 */
float mgPortTextureScale(gfx::TextureHandle texture);
// Records a grab of the main frame at this point in the draw stream, including Fill's sides.
// A draw into the main frame must sample this handle rather than the main target itself.
gfx::TextureHandle mgPortSnapshotFrame();
// The target mgSetPkFrameBuffer draws into for this texture or frame address; created on first use.
// frame_target: a grab of the frame, as wide as the window under AspectMode::Fill (gfx frame target).
gfx::TextureHandle mgPortRenderTarget(const mgCTexture *texture, bool frame_target = false);
gfx::TextureHandle mgPortRenderTarget(uint32_t tbp0, int width, int height, int psm, bool frame_target = false);
// Retires any target aliases owned by a released registry key before that key is reused.
void mgPortReleaseTextureTarget(uint32_t tbp0);
// The share_main_depth target between mgBeginDrawShadow and mgEndDrawShadow.
gfx::TextureHandle mgPortShadowTarget();
bool mgPortInShadow();

// Submission. Dropped outside a frame and before mgPortRendererReady().

void mgPortDraw2D(gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                  const gfx::TextureBinding &texture, const gfx::DrawState &state,
                  const gfx::Presentation2D *presentation = nullptr);
void mgPortDrawMesh(gfx::MeshHandle mesh, uint32_t first_index, uint32_t index_count,
                    const gfx::MeshConstants &constants, const gfx::TextureBinding &texture,
                    const gfx::DrawState &state, const gfx::MeshTransform *transform = nullptr);
void mgPortDrawMeshImmediate(std::span<const gfx::Vertex3D> vertices, std::span<const uint32_t> indices,
                             const gfx::MeshConstants &constants, const gfx::TextureBinding &texture,
                             const gfx::DrawState &state, const gfx::MeshTransform *transform = nullptr);
void mgPortDrawMeshProg0(gfx::MeshHandle mesh, uint32_t first_index, uint32_t index_count,
                         const gfx::MeshConstants &constants, const gfx::Prog0Constants &prog0,
                         const gfx::TextureBinding &texture, const gfx::DrawState &state,
                         const gfx::MeshTransform *transform = nullptr);
void mgPortDrawMeshImmediateProg0(std::span<const gfx::Vertex3D> vertices, std::span<const uint32_t> indices,
                                  const gfx::MeshConstants &constants, const gfx::Prog0Constants &prog0,
                                  const gfx::TextureBinding &texture, const gfx::DrawState &state,
                                  const gfx::MeshTransform *transform = nullptr);
// The VU program mgSendVuProg selected last, -1 for none.
int mgPortVuProg();

// Display lists

// Chronicle's kDraw3DTeleportDistance: an mgCFrame that moved further than this in one tick snaps.
inline constexpr float kMgPortFrameTeleportDistance = 200.0f;

// Tags the mesh draws made during its lifetime with `object` (the mgCFrame they are drawn under, or
// the visual's own record outside a frame) so a display frame matches them with the previous tick's;
// puts back the key it replaced.
class mgPortInterpScope {
public:
    mgPortInterpScope(const void *object, float teleport_distance, bool blend_vertices = false,
                      bool no_interpolation = false);
    ~mgPortInterpScope();
    mgPortInterpScope(const mgPortInterpScope &) = delete;
    mgPortInterpScope &operator=(const mgPortInterpScope &) = delete;

private:
    gfx::InterpKey previous_key_;
    bool           previous_no_interpolation_;
};

// The tick being recorded (or the next one, outside a tick) is not interpolated from its predecessor.
void mgPortCutInterpolation();
// Its camera is not; objects still are.
void mgPortCutCameraInterpolation();
unsigned long long mgPortCameraGeneration();
// True between mgBeginFrame and mgEndFrame while the tick is recorded as a display list.
bool mgPortRecording();
// The tick's list and the one before it (null until two ticks were recorded), for the present driver.
const gfx::DisplayList *mgPortLastList();
const gfx::DisplayList *mgPortPreviousList();

// Readback

// Contents of `target` as of the last finished frame.
bool mgPortReadColor(gfx::TextureHandle target, std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height);
// Contents of `target` as of the last canonical render (the tick's image, never a display frame's).
bool mgPortCanonicalReadColor(gfx::TextureHandle target, std::vector<uint8_t> &rgba, uint32_t &width,
                              uint32_t &height);
// Farthest depth over a logical rect of the main target, answered at the end of the frame.
// Returns -1 when no query slot is free; slots 0-3 are mgPickZBuff's.
int mgPortQueueDepthRead(float x, float y, float width, float height);
std::optional<float> mgPortDepthResult(int query);
