#define MGLIB_IMPLICIT_TEX0_ASSIGNMENT
#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <map>
#include <optional>
#include <set>
#include <string>
#include <utility>
#include <vector>

#include "dng_main.hpp"
#include "exitcodes.hpp"
#include "gfx/gfx.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_math.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/paths.hpp"
#include "present.hpp"
#include "scenesnd.hpp"
#include "stubs/mglib.hpp"

namespace {

// Bitfield structs are read and written as their 64-bit register image. The field order is the
// little-endian LP64 layout the PS2 headers describe.
template <typename T>
T FromRaw(uint64_t raw) {
    static_assert(sizeof(T) == sizeof(uint64_t));
    T value{};
    std::memcpy(&value, &raw, sizeof value);
    return value;
}

template <typename T>
uint64_t ToRaw(const T &value) {
    static_assert(sizeof(T) == sizeof(uint64_t));
    uint64_t raw = 0;
    std::memcpy(&raw, &value, sizeof value);
    return raw;
}

constexpr int kExitScreenshotFailed = 1;
constexpr uint64_t kClampBoth = 1 | (1 << 2);
constexpr int kDepthSlotCount = static_cast<int>(gfx::kDepthQueryCount);
// mgStoreZBuffImage's query slot. Slot 4 is outside the per-frame allocator, which starts above it.
constexpr int kStoreDepthSlot = 4;
constexpr int kFirstAllocatedDepthSlot = 5;

struct RenderTargetEntry {
    gfx::TextureHandle handle;
    int width;
    int height;
    int psm;
    bool frame_target;
    float texture_scale = 1.0f; /**< Physical canvas texels per retail texture texel. */
};

bool ready = false;
bool frame_open = false;
bool gfx_open = false;
bool recording = false;
bool cut_next_tick = true;
bool cut_camera_next_tick = true;
unsigned long long      camera_generation = 0;
gfx::DisplayListRef last_list;
gfx::DisplayListRef previous_list;
int frame_count = 0;
int exit_frames = 0;
std::filesystem::path screenshot_path;
mgPortScreenshotOptions screenshot_options;
int store_count = 0;

mgPortGsState gs_state;
gfx::TextureHandle current_target = gfx::kMainTarget;
std::map<uint32_t, RenderTargetEntry> render_targets; // by TBP0
std::map<const mgCTexture *, uint32_t> texture_targets; // by texture, the TBP0 of its entry

// Seeded from the registry image, which a reload replaces; a recreated target loses its pixels, so
// its record goes with it.
struct RegisteredTarget {
    uint32_t           tbp0;
    gfx::TextureHandle seeded_from;
};
std::map<const mgCTexture *, RegisteredTarget> registered_targets;

mgPortTextureLookup lookup_texture = nullptr;
mgPortTex0Lookup lookup_tex0 = nullptr;

mgCTexture frame_tex;
int frame_buf0 = 0;
int frame_buf1 = 0;
int dbuff_id = 0;

// mgCDrawPrim disables primitives when mgVif1Packet is null, so the sentinel must stay addressable.
sceVif1Packet vif_packet{};
// Non-null selects the immediate Draw path; NULL selects the deferred one. Nothing on PC writes through it.
u_int direct_tag[4] = {};
int data_id = 0;
mgCMemory data_buf[2];

int old_vcount = 0;
int now_prog_id = -1;
u_long128 *prog_adr[MG_VU_PROG_BUILTIN_NUM] = {Vu_prog0, Vu_prog_sdw, Vu_prog_3dsp};
u_long128 **user_prog_adr = nullptr;
int user_prog_num = 0;

struct ColorImage {
    std::vector<uint8_t> rgba;
    uint32_t width = 0;
    uint32_t height = 0;
};

struct DepthRect {
    int x = 0;
    int y = 0;
    int width = 0;
    int height = 0;
    bool operator==(const DepthRect &) const = default;
};

std::optional<float> depth_answer[gfx::kDepthQueryCount];
bool depth_pending[gfx::kDepthQueryCount] = {};
int depth_next = kFirstAllocatedDepthSlot;
DepthRect depth_queued_rect;
DepthRect depth_answered_rect;

std::map<gfx::TextureHandle, ColorImage> color_cache;
std::set<gfx::TextureHandle> color_marks;

bool in_shadow = false;

int ScreenSizeForMode(int mode, int *width, int *height) {
    switch (mode) {
        case MG_SCREEN_MODE_640X448:
            *width = 640;
            *height = 448;
            break;
        case MG_SCREEN_MODE_512X480:
            *width = 512;
            *height = 480;
            break;
        case MG_SCREEN_MODE_512X416:
            *width = 512;
            *height = 416;
            break;
        case MG_SCREEN_MODE_512X448:
        default:
            mode = MG_SCREEN_MODE_512X448;
            *width = 512;
            *height = 448;
            break;
    }

    return mode;
}

int CeilLog2(int value) {
    int shift = 0;

    while ((1 << shift) < value) {
        ++shift;
    }

    return shift;
}

float DepthRange() {
    return mgScreenZDepth == 16 ? 65000.0f : 1.67e7f;
}

void SetIdentity(float matrix[16]) {
    std::memset(matrix, 0, 16 * sizeof(float));
    matrix[0] = matrix[5] = matrix[10] = matrix[15] = 1.0f;
}

// out = a * b, column-major.
void MultiplyColumnMajor(const float a[16], const float b[16], float out[16]) {
    float result[16];

    for (int column = 0; column < 4; ++column) {
        for (int row = 0; row < 4; ++row) {
            float sum = 0.0f;

            for (int k = 0; k < 4; ++k) {
                sum += a[k * 4 + row] * b[column * 4 + k];
            }

            result[column * 4 + row] = sum;
        }
    }

    std::memcpy(out, result, sizeof result);
}

uint8_t BackColorByte(int channel) {
    return static_cast<uint8_t>(static_cast<int>(mgBackColor[channel]));
}

int DrawFbp() {
    return dbuff_id == 0 ? frame_buf0 : frame_buf1;
}

int DisplayFbp() {
    return dbuff_id == 0 ? frame_buf1 : frame_buf0;
}

bool VuProgIdValid(int id) {
    if (id < MG_VU_PROG_USER) {
        return id >= 0 && id < MG_VU_PROG_BUILTIN_NUM;
    }

    const int index = id - MG_VU_PROG_USER;
    return index < user_prog_num && user_prog_adr != nullptr && user_prog_adr[index] != nullptr;
}

gfx::TextureBinding BindingFor(mgPortTexture found, uint64_t tex0, uint64_t tex1) {
    gfx::TextureBinding binding;
    binding.texture = found.texture;
    binding.palette = found.palette;
    binding.filter = mgPortFilter(tex1);
    binding.wrap_u = mgPortWrapU(gs_state.clamp);
    binding.wrap_v = mgPortWrapV(gs_state.clamp);
    binding.ignore_alpha = FromRaw<sceGsTex0>(tex0).TCC == 0;
    return binding;
}

// The renderer refuses a draw that samples the target it renders into, and the frame moves on within a
// tick, so a frame sampled into another target is grabbed at the binding: the snapshot is recorded
// here and holds the frame as it stands at this draw.
mgPortTexture GrabFrameIfSampled(mgPortTexture found) {
    if (found.texture != gfx::kMainTarget || current_target == gfx::kMainTarget || !gfx_open) {
        return found;
    }

    const gfx::TextureHandle grab = mgPortSnapshotFrame();
    if (grab == gfx::kNullTexture) {
        return found;
    }

    return {grab, found.palette};
}

gfx::TextureHandle RenderTargetHandle(uint32_t tbp0) {
    const auto it = render_targets.find(tbp0);
    return it != render_targets.end() ? it->second.handle : gfx::kNullTexture;
}

int BytesPerTexel(int psm) {
    switch (psm) {
        case SCE_GS_PSMCT32:
            return 4;
        case SCE_GS_PSMCT24:
            return 3;
        case SCE_GS_PSMCT16:
        case SCE_GS_PSMCT16S:
            return 2;
        default:
            return 0;
    }
}

// rgba is the renderer's units (0xFF opaque); the 16-bit formats keep one alpha bit.
void WriteTexel(uint8_t *out, int psm, const uint8_t *rgba) {
    const int r = rgba[0];
    const int g = rgba[1];
    const int b = rgba[2];
    const int a = rgba[3];

    switch (psm) {
        case SCE_GS_PSMCT32:
            out[0] = static_cast<uint8_t>(r);
            out[1] = static_cast<uint8_t>(g);
            out[2] = static_cast<uint8_t>(b);
            out[3] = static_cast<uint8_t>((a * 0x80 + 127) / 0xFF);
            break;
        case SCE_GS_PSMCT24:
            out[0] = static_cast<uint8_t>(r);
            out[1] = static_cast<uint8_t>(g);
            out[2] = static_cast<uint8_t>(b);
            break;
        default: {
            const int texel = (r >> 3) | ((g >> 3) << 5) | ((b >> 3) << 10) | (a >= 0x80 ? 1 << 15 : 0);
            out[0] = static_cast<uint8_t>(texel & 0xFF);
            out[1] = static_cast<uint8_t>(texel >> 8);
            break;
        }
    }
}

// Outside a recording and a frame. After a canonical render kPreviousFrame is the tick's image; the
// presented frame is only the fallback.
bool ReadNow(gfx::TextureHandle target, std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height) {
    if (target == gfx::kMainTarget) {
        return gfx::ReadbackTexture(gfx::kPreviousFrame, rgba, width, height) ||
               gfx::ReadbackFrame(rgba, width, height);
    }

    return gfx::ReadbackTexture(target, rgba, width, height);
}

bool WriteScreenshotDisplayFrames() {
    if (PresentGetSettings().interpolation && mgPortPreviousList() == nullptr) {
        std::fprintf(stderr, "mglib: frame %d has no previous list, display frames skipped\n", frame_count);
        return true;
    }

    const int count = screenshot_options.display_frames;
    bool      written = true;

    for (int k = 0; k < count && written; ++k) {
        std::vector<uint8_t> rgba;
        uint32_t             width = 0;
        uint32_t             height = 0;
        std::filesystem::path name = screenshot_path.stem();
        name += "-display-" + std::to_string(k) + ".png";
        const std::filesystem::path path = screenshot_path.parent_path() / name;
        const float alpha = static_cast<float>(k) / static_cast<float>(count);
        written = PresentScreenshotDisplay(alpha, rgba, width, height) && gfx::WritePng(path, rgba.data(), width, height);

        if (written) {
            std::fprintf(stderr, "mglib: display frame %d of frame %d written to %s\n", k, frame_count,
                         PathsDisplay(path).c_str());
        } else {
            std::fprintf(stderr, "mglib: display frame %d of frame %d could not be written to %s\n", k, frame_count,
                         PathsDisplay(path).c_str());
        }
    }

    return written;
}

// Runs after the tick's canonical render, outside a recording, so the readbacks see the finished image.
void CacheMarkedColors() {
    for (const gfx::TextureHandle target : color_marks) {
        ColorImage image;
        const bool read = ReadNow(target, image.rgba, image.width, image.height);

        if (read) {
            color_cache[target] = std::move(image);
        }
    }

    color_marks.clear();
}

void AnswerDepthQueries() {
    for (int slot = kStoreDepthSlot; slot < kDepthSlotCount; ++slot) {
        if (!depth_pending[slot]) {
            continue;
        }

        depth_pending[slot] = false;
        depth_answer[slot] = gfx::DepthResult(static_cast<uint32_t>(slot));

        if (slot == kStoreDepthSlot) {
            depth_answered_rect = depth_queued_rect;
        }
    }
}

// Rect edges are 12.4 and inclusive, as mgRect defines them.
bool InclusiveLogicalRect(const mgRect<int> &rect, gfx::Rect &out) {
    if (rect.right - rect.left + 1 <= 0 || rect.bottom - rect.top + 1 <= 0) {
        return false;
    }

    const int left = rect.left / 16;
    const int top = rect.top / 16;
    out = gfx::Rect{left, top, rect.right / 16 - left + 1, rect.bottom / 16 - top + 1};
    return true;
}

/**
 * Finds the texel scale of a converted texture image or its animation target.
 */
float TextureScale(gfx::TextureHandle handle) {
    for (const auto &[key, target] : render_targets) {
        if (target.handle == handle) return target.texture_scale;
    }
    return MgTextureImageScale(handle);
}

/**
 * Maps a retail texture rectangle onto its physical canvas.
 */
gfx::Rect ScaleRectangle(gfx::Rect rect, float scale) {
    return {static_cast<int>(rect.x * scale), static_cast<int>(rect.y * scale),
            static_cast<int>(rect.w * scale), static_cast<int>(rect.h * scale)};
}

/**
 * Applies the current animation target's physical scale to the draw scissor.
 */
gfx::DrawState TargetDrawState(gfx::DrawState state) {
    const float scale = TextureScale(current_target);
    auto &rect = state.scissor_rect;
    rect = {rect.x * scale, rect.y * scale, rect.w * scale, rect.h * scale};
    return state;
}

void CopyRectangle(gfx::TextureHandle src, const mgRect<int> &rect, gfx::TextureHandle dst, int dst_x, int dst_y) {
    if (src == gfx::kNullTexture || dst == gfx::kNullTexture) {
        return;
    }

    gfx::Rect source;
    if (InclusiveLogicalRect(rect, source)) {
        const float src_scale = TextureScale(src);
        const float dst_scale = TextureScale(dst);
        const gfx::Rect destination{dst_x >> 4, dst_y >> 4, source.w, source.h};
        gfx::BlitTexture(src, ScaleRectangle(source, src_scale), dst,
                         ScaleRectangle(destination, dst_scale), gfx::Filter::Nearest);
    }
}

// A draw into a texture whose frame grab is registered goes to the grab: replacing it would drop the
// window's width and the grab's contents, which the same frame still samples.
gfx::TextureHandle FrameGrabAt(uint32_t tbp0) {
    const auto it = render_targets.find(tbp0);
    return it != render_targets.end() && it->second.frame_target ? it->second.handle : gfx::kNullTexture;
}

// The copy is retail's 1:1 texel copy in logical units; the frame target's mapping brings the window's sides.
void GrabFrame(gfx::TextureHandle frame, const gfx::Rect &source, int32_t dst_x, int32_t dst_y,
               gfx::TextureHandle target) {
    if (target == gfx::kNullTexture) {
        return;
    }

    gfx::BlitTexture(frame, source, target, gfx::Rect{dst_x, dst_y, source.w, source.h}, gfx::Filter::Nearest);
}

void CopyFrameInto(gfx::TextureHandle frame, const mgRect<int> &rect, int dst_x, int dst_y,
                   gfx::TextureHandle target) {
    gfx::Rect source;

    if (target != gfx::kNullTexture && InclusiveLogicalRect(rect, source)) {
        GrabFrame(frame, source, dst_x >> 4, dst_y >> 4, target);
    }
}

// Registers carry no size; the texture they resolve to is the only source of one.
gfx::TextureHandle FrameTargetFor(const sceGsTex0 &dst) {
    const std::optional<gfx::TextureInfo> info = gfx::GetTextureInfo(mgPortFindTexture(ToRaw(dst)).texture);

    if (!info) {
        return gfx::kNullTexture;
    }

    return mgPortRenderTarget(static_cast<uint32_t>(dst.TBP0), static_cast<int>(info->width),
                              static_cast<int>(info->height), static_cast<int>(dst.PSM), true);
}

// Frame-buffer globals are set as retail does; the copy is a plain blit, so the caller's draw
// environment does not apply to it.
void StretchInto(gfx::TextureHandle src, const mgRect<int> &src_rect, const sceGsTex0 &dst_tex0, int dst_height,
                 const mgRect<int> &dst_rect, const mgCTexture *dst_texture) {
    if (src == gfx::kNullTexture) {
        return;
    }

    const int width = static_cast<int>(dst_tex0.TBW) * 64;
    mgSetPkFrameBuffer(static_cast<int>(dst_tex0.TBP0 / 32), width, (dst_height + 63) & ~63,
                       static_cast<int>(dst_tex0.PSM));

    const gfx::TextureHandle dst = dst_texture != nullptr ? mgPortFindTexture(dst_texture).texture
                                                          : mgPortFindTexture(ToRaw(dst_tex0)).texture;

    // Sprite corners: right and bottom are the far edge, exclusive.
    const auto to_rect = [](const mgRect<int> &rect) {
        return gfx::Rect{rect.left / 16, rect.top / 16, rect.right / 16 - rect.left / 16,
                         rect.bottom / 16 - rect.top / 16};
    };
    const auto is_empty = [](const mgRect<int> &rect) {
        return rect.right <= rect.left || rect.bottom <= rect.top;
    };

    if (dst != gfx::kNullTexture && !is_empty(src_rect) && !is_empty(dst_rect)) {
        const gfx::Rect from = ScaleRectangle(to_rect(src_rect), TextureScale(src));
        const gfx::Rect to = ScaleRectangle(to_rect(dst_rect), TextureScale(dst));
        gfx::BlitTexture(src, from, dst, to, gfx::Filter::Linear);
    }

    mgSetPkFrameBuffer(-1, -1, -1, -1);
}

mgPortExtent ExtentOf(float left, float top, float right, float bottom) {
    const float centre_x = static_cast<float>(mgScreenWidth) / 2.0f;
    const float centre_y = static_cast<float>(mgScreenHeight) / 2.0f;

    mgPortExtent extent;
    extent.left = left;
    extent.top = top;
    extent.right = right;
    extent.bottom = bottom;
    extent.half_width = std::max(centre_x - left, right - centre_x);
    extent.half_height = std::max(centre_y - top, bottom - centre_y);
    extent.gs_left = static_cast<float>(mgScreenOffx) + left;
    extent.gs_top = static_cast<float>(mgScreenOffy) + top;
    extent.gs_right = static_cast<float>(mgScreenOffx) + right;
    extent.gs_bottom = static_cast<float>(mgScreenOffy) + bottom;
    return extent;
}

// Only x and y follow the visible extent; the depth components stay retail's.
void ApplyVisibleBox(mgRENDER_INFO &info) {
    const mgPortExtent extent = mgPortVisibleExtent();
    const float centre_x = 0.5f * static_cast<float>(mgScreenWidth);
    const float centre_y = 0.5f * static_cast<float>(mgScreenHeight);
    info.screen_box_min[0] = extent.left - centre_x;
    info.screen_box_min[1] = extent.top - centre_y;
    info.screen_box_max[0] = extent.right - centre_x;
    info.screen_box_max[1] = extent.bottom - centre_y;
}

} // namespace

// Frame

bool mgPortRendererReady() {
    return ready;
}

bool mgPortFrameOpen() {
    return frame_open;
}

int mgPortFrameCount() {
    return frame_count;
}

void mgPortExitAfterFrames(int frames, const std::filesystem::path &screenshot) {
    exit_frames = frames;
    screenshot_path = screenshot;
}

void mgPortSetScreenshotOptions(const mgPortScreenshotOptions &options) {
    screenshot_options = options;
}

// Projection

mgPortProjection mgPortCurrentProjection() {
    mgPortProjection projection;
    projection.eye = mgRenderInfo.projection;
    projection.near_z = mgRenderInfo.clip_min[2];
    projection.far_z = mgRenderInfo.clip_max[2];
    projection.aspect_y = mgRenderInfo.aspect[1][1];
    projection.width = static_cast<float>(mgScreenWidth);
    projection.height = static_cast<float>(mgScreenHeight);
    return projection;
}

void mgPortEyeToClip(const mgPortProjection &projection, gfx::TextureHandle target, float out[16]) {
    gfx::LogicalMapping mapping = gfx::GetLogicalMapping(target);
    const float scale = TextureScale(target);
    mapping.scale_x *= scale;
    mapping.scale_y *= scale;

    if (!(projection.eye > 0.0f) || !(projection.far_z > projection.near_z) || mapping.pixel_width == 0 ||
        mapping.pixel_height == 0) {
        SetIdentity(out);
        return;
    }

    const float pixel_width = static_cast<float>(mapping.pixel_width);
    const float pixel_height = static_cast<float>(mapping.pixel_height);
    const float depth_span = projection.far_z - projection.near_z;

    std::memset(out, 0, 16 * sizeof(float));
    out[0] = 2.0f * mapping.scale_x * projection.eye / pixel_width;
    out[8] = 2.0f * mapping.scale_x * (projection.width / 2.0f) / pixel_width +
             2.0f * mapping.offset_x / pixel_width - 1.0f;
    out[5] = 2.0f * mapping.scale_y * projection.aspect_y * projection.eye / pixel_height;
    out[9] = 2.0f * mapping.scale_y * (projection.height / 2.0f) / pixel_height +
             2.0f * mapping.offset_y / pixel_height - 1.0f;
    out[10] = -projection.near_z / depth_span;
    out[14] = projection.near_z * projection.far_z / depth_span;
    out[11] = 1.0f;
}

void mgPortWorldToClip(float out[16]) {
    float eye_to_clip[16];
    mgPortEyeToClip(mgPortCurrentProjection(), mgPortCurrentTarget(), eye_to_clip);

    float view[16];
    std::memcpy(view, mgRenderInfo.view, sizeof view);
    MultiplyColumnMajor(eye_to_clip, view, out);
}

gfx::MeshTransform mgPortMeshTransform(const float model[16]) {
    gfx::MeshTransform transform = gfx::IdentityMeshTransform();
    mgPortEyeToClip(mgPortCurrentProjection(), mgPortCurrentTarget(), transform.projection);
    std::memcpy(transform.view, mgRenderInfo.view, sizeof transform.view);
    std::memcpy(transform.model, model, sizeof transform.model);
    return transform;
}

float mgPortDepth(uint32_t gs_z) {
    return std::clamp(static_cast<float>(gs_z) / DepthRange(), 0.0f, 1.0f);
}

uint32_t mgPortGsDepth(float depth) {
    return static_cast<uint32_t>(std::lround(std::clamp(depth, 0.0f, 1.0f) * DepthRange()));
}

float mgPortLogicalX(int gs_x) {
    return static_cast<float>(gs_x) / 16.0f - static_cast<float>(mgScreenOffx);
}

float mgPortLogicalY(int gs_y) {
    return static_cast<float>(gs_y) / 16.0f - static_cast<float>(mgScreenOffy);
}

// Visible extent

// mgPortLogicalX/Y are the identity once the screen offset is removed, so renderer logical units are
// the game's screen units.
mgPortExtent mgPortVisibleExtent(gfx::TextureHandle target) {
    if (mgPortRendererReady()) {
        const gfx::LogicalRect rect = gfx::VisibleLogicalRect(target);

        if (rect.w > 0.0f && rect.h > 0.0f) {
            const float scale = TextureScale(target);
            return ExtentOf(rect.x / scale, rect.y / scale, (rect.x + rect.w) / scale,
                            (rect.y + rect.h) / scale);
        }
    }

    return ExtentOf(0.0f, 0.0f, static_cast<float>(mgScreenWidth), static_cast<float>(mgScreenHeight));
}

mgPortExtent mgPortVisibleExtent() {
    return mgPortVisibleExtent(mgPortCurrentTarget());
}

// GS state

mgPortGsState &mgPortGs() {
    return gs_state;
}

// The state My_dma_start0 leaves the GS in (docs/vu1/dma_start0.md, 8.1).
void mgPortResetGs() {
    gs_state.test = 0x5000B;
    gs_state.zbuf = ToRaw(mgZBUF_1);
    gs_state.alpha = 0x44;
    gs_state.texa = 0x0000008000008080ULL;
    gs_state.clamp = 0;
    gs_state.tex1 = 0x61;
    gs_state.scissor[0] = 0;
    gs_state.scissor[1] = 0;
    gs_state.scissor[2] = 639;
    gs_state.scissor[3] = 223;
    gs_state.fog_color[0] = 200;
    gs_state.fog_color[1] = 200;
    gs_state.fog_color[2] = 200;
}

gfx::DrawState mgPortDrawState(const mgPortGsState &state) {
    gfx::DrawState draw;
    mgPortApplyTest(draw, state.test);
    mgPortApplyZbuf(draw, state.zbuf);
    mgPortApplyAlpha(draw, state.alpha);
    mgPortApplyTexa(draw, state.texa);
    mgPortApplyScissor(draw, state.scissor);

    for (int channel = 0; channel < 3; ++channel) {
        draw.fog_color[channel] = state.fog_color[channel];
    }

    return draw;
}

gfx::DrawState mgPortDrawState() {
    return mgPortDrawState(gs_state);
}

void mgPortApplyTest(gfx::DrawState &state, uint64_t test) {
    const sceGsTest reg = FromRaw<sceGsTest>(test);
    state.alpha_test = reg.ATE != 0;
    state.alpha_func = static_cast<gfx::AlphaFunc>(reg.ATST);
    state.alpha_ref = static_cast<uint8_t>(reg.AREF);
    state.depth_test = reg.ZTE != 0 ? static_cast<gfx::DepthTest>(reg.ZTST) : gfx::DepthTest::Always;
}

void mgPortApplyZbuf(gfx::DrawState &state, uint64_t zbuf) {
    state.depth_write = FromRaw<sceGsZbuf>(zbuf).ZMSK == 0;
}

void mgPortApplyAlpha(gfx::DrawState &state, uint64_t alpha) {
    const sceGsAlpha reg = FromRaw<sceGsAlpha>(alpha);
    state.alpha.a = static_cast<uint8_t>(reg.A);
    state.alpha.b = static_cast<uint8_t>(reg.B);
    state.alpha.c = static_cast<uint8_t>(reg.C);
    state.alpha.d = static_cast<uint8_t>(reg.D);
    state.alpha.fix = static_cast<uint8_t>(reg.FIX);
}

void mgPortApplyTexa(gfx::DrawState &state, uint64_t texa) {
    const sceGsTexa reg = FromRaw<sceGsTexa>(texa);
    state.texa_aem = reg.AEM != 0;
    state.texa_ta0 = static_cast<uint8_t>(reg.TA0);
}

void mgPortApplyScissor(gfx::DrawState &state, const int scissor[4]) {
    if (scissor[0] <= 0 && scissor[1] <= 0 && scissor[2] >= mgScreenWidth - 1 &&
        scissor[3] >= mgScreenHeight - 1) {
        state.scissor = false;
        return;
    }

    state.scissor = true;
    state.scissor_rect = {static_cast<float>(scissor[0]), static_cast<float>(scissor[1]),
                          static_cast<float>(scissor[2] - scissor[0] + 1),
                          static_cast<float>(scissor[3] - scissor[1] + 1)};
}

void mgPortApplyDrawEnv(gfx::DrawState &state, const mgCDrawEnv &env) {
    mgPortApplyTest(state, ToRaw(env.test));
    mgPortApplyZbuf(state, ToRaw(env.zbuf));
    mgPortApplyAlpha(state, ToRaw(env.alpha));
}

gfx::Wrap mgPortWrapU(uint64_t clamp) {
    return FromRaw<sceGsClamp>(clamp).WMS == 0 ? gfx::Wrap::Repeat : gfx::Wrap::Clamp;
}

gfx::Wrap mgPortWrapV(uint64_t clamp) {
    return FromRaw<sceGsClamp>(clamp).WMT == 0 ? gfx::Wrap::Repeat : gfx::Wrap::Clamp;
}

gfx::Filter mgPortFilter(uint64_t tex1) {
    return FromRaw<sceGsTex1>(tex1).MMAG != 0 ? gfx::Filter::Linear : gfx::Filter::Nearest;
}

// Textures

void mgPortSetTextureLookup(mgPortTextureLookup by_texture, mgPortTex0Lookup by_tex0) {
    lookup_texture = by_texture;
    lookup_tex0 = by_tex0;
}

mgPortTexture mgPortFindTexture(uint64_t tex0) {
    const uint32_t tbp0 = static_cast<uint32_t>(FromRaw<sceGsTex0>(tex0).TBP0);

    if (tbp0 == static_cast<uint32_t>(DrawFbp()) << 5) {
        return {gfx::kMainTarget, gfx::kNullTexture};
    }

    if (tbp0 == static_cast<uint32_t>(DisplayFbp()) << 5) {
        return {gfx::kPreviousFrame, gfx::kNullTexture};
    }

    if (const gfx::TextureHandle target = RenderTargetHandle(tbp0); target != gfx::kNullTexture) {
        return {target, gfx::kNullTexture};
    }

    if (lookup_tex0 != nullptr) {
        return lookup_tex0(tex0);
    }

    return {};
}

mgPortTexture mgPortFindTexture(const mgCTexture *texture) {
    if (texture == nullptr) {
        return {};
    }

    if (texture == &frame_tex) {
        return mgPortFindTexture(ToRaw(frame_tex.tex0));
    }

    // A reload is only noticed on lookup: the registry image it left behind no longer seeds this target.
    if (const auto record = registered_targets.find(texture);
        record != registered_targets.end() && lookup_texture != nullptr &&
        lookup_texture(texture).texture != record->second.seeded_from) {
        registered_targets.erase(record);
        texture_targets.erase(texture);
    }

    if (const auto it = texture_targets.find(texture); it != texture_targets.end()) {
        if (const gfx::TextureHandle target = RenderTargetHandle(it->second); target != gfx::kNullTexture) {
            return {target, gfx::kNullTexture};
        }
    }

    if (lookup_texture != nullptr) {
        const mgPortTexture found = lookup_texture(texture);

        if (found.texture != gfx::kNullTexture) {
            return found;
        }
    }

    return mgPortFindTexture(ToRaw(texture->tex0));
}

gfx::TextureBinding mgPortBinding(const mgCTexture *texture) {
    if (texture == nullptr) {
        return BindingFor({}, 0, 0);
    }

    return BindingFor(GrabFrameIfSampled(mgPortFindTexture(texture)), ToRaw(texture->tex0), ToRaw(texture->tex1));
}

gfx::TextureBinding mgPortBinding(uint64_t tex0, uint64_t tex1) {
    return BindingFor(GrabFrameIfSampled(mgPortFindTexture(tex0)), tex0, tex1);
}

void mgPortAdoptColorVariant(const mgCTexture *src, mgCTexture *dst) {
    if (src != nullptr && dst != nullptr) {
        MgTextureSelectVariant(dst, MgTexturePaletteSource(src));
    }
}

// Render targets

gfx::TextureHandle mgPortSnapshotFrame() {
    if (!gfx_open) {
        return gfx::kNullTexture;
    }
    int width = 0;
    int height = 0;
    ScreenSizeForMode(mgScreenMode, &width, &height);
    const gfx::TextureHandle grab = gfx::NamedRenderTarget("mglib frame grab", static_cast<uint32_t>(width),
                                                           static_cast<uint32_t>(height), false, false, true);
    return grab != gfx::kNullTexture && gfx::SnapshotFrame(grab) ? grab : gfx::kNullTexture;
}

gfx::TextureHandle mgPortCurrentTarget() {
    return current_target;
}

float mgPortTextureScale(gfx::TextureHandle texture) {
    return TextureScale(texture);
}

gfx::TextureHandle mgPortRenderTarget(uint32_t tbp0, int width, int height, int psm, bool frame_target) {
    if (const auto it = render_targets.find(tbp0); it != render_targets.end()) {
        const RenderTargetEntry &entry = it->second;

        if (entry.width == width && entry.height == height && entry.psm == psm &&
            entry.frame_target == frame_target) {
            return entry.handle;
        }

        gfx::DestroyTexture(entry.handle);
        std::erase_if(registered_targets, [tbp0](const auto &record) { return record.second.tbp0 == tbp0; });
    }

    const gfx::TextureHandle handle =
        gfx::CreateRenderTarget(static_cast<uint32_t>(width), static_cast<uint32_t>(height),
                                psm != SCE_GS_PSMCT24, false, frame_target);
    render_targets[tbp0] = RenderTargetEntry{handle, width, height, psm, frame_target};
    return handle;
}

// Keyed by the texture's TBP0 rather than holding the handle, so a size or format change that
// recreates the target does not leave the texture with a destroyed handle.
gfx::TextureHandle mgPortRenderTarget(const mgCTexture *texture, bool frame_target) {
    if (texture == nullptr) {
        return gfx::kNullTexture;
    }

    const uint32_t tbp0 = static_cast<uint32_t>(texture->tex0.TBP0);
    texture_targets[texture] = tbp0;
    const auto physical = MgTexturePhysicalExtent(texture);
    const float scale = static_cast<float>(physical.width) / (1u << texture->tex0.TW);
    const int width = !frame_target && scale > 1 ? physical.width : texture->width;
    const int height = !frame_target && scale > 1 ? physical.height : texture->height;
    const auto handle = mgPortRenderTarget(tbp0, width, height, static_cast<int>(texture->tex0.PSM), frame_target);
    render_targets[tbp0].texture_scale = frame_target ? 1.0f : scale;
    return handle;
}

void mgPortReleaseTextureTarget(uint32_t tbp0) {
    if (const auto it = render_targets.find(tbp0); it != render_targets.end()) {
        gfx::DestroyTexture(it->second.handle);
        render_targets.erase(it);
    }
    std::erase_if(texture_targets, [tbp0](const auto &record) { return record.second == tbp0; });
    std::erase_if(registered_targets, [tbp0](const auto &record) { return record.second.tbp0 == tbp0; });
}

// Submission

void mgPortDraw2D(gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                  const gfx::TextureBinding &texture, const gfx::DrawState &state,
                  const gfx::Presentation2D *presentation) {
    if (!ready || !gfx_open) {
        return;
    }

    const float source_scale = TextureScale(texture.texture);
    const float target_scale = TextureScale(current_target);
    if (source_scale == 1.0f && target_scale == 1.0f) {
        gfx::Draw2D(primitive, vertices, texture, state, presentation);
        return;
    }
    std::vector<gfx::Vertex2D> scaled(vertices.begin(), vertices.end());
    for (auto &vertex : scaled) {
        vertex.x *= target_scale;
        vertex.y *= target_scale;
        vertex.u *= source_scale;
        vertex.v *= source_scale;
    }
    gfx::DrawState scaled_state = state;
    scaled_state.scissor_rect = {state.scissor_rect.x * target_scale, state.scissor_rect.y * target_scale,
                                  state.scissor_rect.w * target_scale, state.scissor_rect.h * target_scale};
    std::vector<gfx::Vertex2D> presentation_vertices;
    gfx::Presentation2D scaled_presentation;
    if (presentation) {
        presentation_vertices.assign(presentation->vertices.begin(), presentation->vertices.end());
        for (auto &vertex : presentation_vertices) {
            vertex.x *= target_scale; vertex.y *= target_scale;
            vertex.u *= source_scale; vertex.v *= source_scale;
        }
        scaled_presentation.vertices = presentation_vertices;
        scaled_presentation.state = presentation->state;
        auto &rect = scaled_presentation.state.scissor_rect;
        rect = {rect.x * target_scale, rect.y * target_scale, rect.w * target_scale, rect.h * target_scale};
    }
    gfx::Draw2D(primitive, scaled, texture, scaled_state, presentation ? &scaled_presentation : nullptr);
}

void mgPortDrawMesh(gfx::MeshHandle mesh, uint32_t first_index, uint32_t index_count,
                    const gfx::MeshConstants &constants, const gfx::TextureBinding &texture,
                    const gfx::DrawState &state, const gfx::MeshTransform *transform) {
    if (!ready || !gfx_open) {
        return;
    }

    gfx::DrawMesh(mesh, first_index, index_count, constants, texture, TargetDrawState(state), transform);
}

void mgPortDrawMeshImmediate(std::span<const gfx::Vertex3D> vertices, std::span<const uint32_t> indices,
                             const gfx::MeshConstants &constants, const gfx::TextureBinding &texture,
                             const gfx::DrawState &state, const gfx::MeshTransform *transform) {
    if (!ready || !gfx_open) {
        return;
    }

    gfx::DrawMeshImmediate(vertices, indices, constants, texture, TargetDrawState(state), transform);
}

void mgPortDrawMeshProg0(gfx::MeshHandle mesh, uint32_t first_index, uint32_t index_count,
                         const gfx::MeshConstants &constants, const gfx::Prog0Constants &prog0,
                         const gfx::TextureBinding &texture, const gfx::DrawState &state,
                         const gfx::MeshTransform *transform) {
    if (!ready || !gfx_open) {
        return;
    }

    gfx::DrawMeshProg0(mesh, first_index, index_count, constants, prog0, texture, TargetDrawState(state), transform);
}

void mgPortDrawMeshImmediateProg0(std::span<const gfx::Vertex3D> vertices, std::span<const uint32_t> indices,
                                  const gfx::MeshConstants &constants, const gfx::Prog0Constants &prog0,
                                  const gfx::TextureBinding &texture, const gfx::DrawState &state,
                                  const gfx::MeshTransform *transform) {
    if (!ready || !gfx_open) {
        return;
    }

    gfx::DrawMeshImmediateProg0(vertices, indices, constants, prog0, texture, TargetDrawState(state), transform);
}

int mgPortVuProg() {
    return now_prog_id;
}

// Display lists

mgPortInterpScope::mgPortInterpScope(const void *object, float teleport_distance, bool blend_vertices,
                                     bool no_interpolation)
    : previous_key_(gfx::CurrentInterpKey()), previous_no_interpolation_(gfx::CurrentNoInterpolation()) {
    gfx::SetInterpKey(static_cast<gfx::InterpKey>(reinterpret_cast<uintptr_t>(object)), no_interpolation,
                      teleport_distance, blend_vertices);
}

mgPortInterpScope::~mgPortInterpScope() {
    gfx::SetInterpKey(previous_key_, previous_no_interpolation_);
}

void mgPortCutInterpolation() {
    ++camera_generation;
    if (recording) {
        gfx::CutInterpolation();
    } else {
        cut_next_tick = true;
    }
}

unsigned long long mgPortCameraGeneration() { return camera_generation; }

void mgPortCutCameraInterpolation() {
    ++camera_generation;
    if (recording) {
        gfx::CutCameraInterpolation();
    } else {
        cut_camera_next_tick = true;
    }
}

bool mgPortRecording() {
    return recording;
}

const gfx::DisplayList *mgPortLastList() {
    return last_list.get();
}

const gfx::DisplayList *mgPortPreviousList() {
    return previous_list.get();
}

// Readback

bool mgPortCanonicalReadColor(gfx::TextureHandle target, std::vector<uint8_t> &rgba, uint32_t &width,
                              uint32_t &height) {
    if (!ready || target == gfx::kNullTexture) {
        return false;
    }

    if (!frame_open) {
        return ReadNow(target, rgba, width, height);
    }

    color_marks.insert(target);
    const auto it = color_cache.find(target);

    if (it == color_cache.end()) {
        return false;
    }

    rgba = it->second.rgba;
    width = it->second.width;
    height = it->second.height;
    return true;
}

bool mgPortReadColor(gfx::TextureHandle target, std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height) {
    return mgPortCanonicalReadColor(target, rgba, width, height);
}

int mgPortQueueDepthRead(float x, float y, float width, float height) {
    if (depth_next >= kDepthSlotCount) {
        return -1;
    }

    const int slot = depth_next++;
    depth_answer[slot].reset();

    if (gfx_open) {
        gfx::ReadDepth(static_cast<uint32_t>(slot), x, y, width, height);
        depth_pending[slot] = true;
    }

    return slot;
}

std::optional<float> mgPortDepthResult(int query) {
    if (query < 0 || query >= kDepthSlotCount) {
        return std::nullopt;
    }

    return depth_answer[query];
}

// Shadows

gfx::TextureHandle mgPortShadowTarget() {
    return in_shadow ? gfx::kMainTarget : gfx::kNullTexture;
}

bool mgPortInShadow() {
    return in_shadow;
}

// PORT_OVERRIDE definitions replacing ps2/src/mglib.cpp

PORT_OVERRIDE void mgInit(int screen_mode, int video_mode) {
    mgScreenMode = ScreenSizeForMode(screen_mode, &mgScreenWidth, &mgScreenHeight);
    mgScreenNX = -(mgScreenWidth >> 1);
    mgScreenNY = -(mgScreenHeight >> 1);
    mgScreenMX = mgScreenWidth + mgScreenNX;
    mgScreenMY = mgScreenHeight + mgScreenNY;
    mgScreenOffx = 0x800 - mgScreenWidth / 2;
    mgScreenOffy = 0x800 - mgScreenHeight / 2;
    mgScreenLeft = mgScreenOffx;
    mgScreenRight = mgScreenOffx + mgScreenWidth;
    mgScreenTop = mgScreenOffy;
    mgScreenBottom = mgScreenOffy + mgScreenHeight;
    mgScreenDepth = 32;
    mgScreenZDepth = 32;

    mgAntialiasing = 1;
    mgClearBackFlag = 1;
    mgFrameRate = 2;
    mgBackColor[0] = 0.0f;
    mgBackColor[1] = 0.0f;
    mgBackColor[2] = 0.0f;
    mgBackColor[3] = 128.0f;

    std::memset(static_cast<void *>(&mgRenderInfo), 0, sizeof(mgRenderInfo));
    mgRenderInfo.Initialize();
    mgDrawManager.texture_manager = &mgTexManager;
    mgDrawManager.render_info = &mgRenderInfo;

    const int aligned_height = (mgScreenHeight + 31) & ~31;
    frame_buf0 = 0;
    frame_buf1 = mgScreenWidth * aligned_height / 2048;
    dbuff_id = 0;

    mgTEX1_1 = FromRaw<sceGsTex1>(0x261);
    mgTEX1_2 = mgTEX1_1;
    mgTEST_1 = FromRaw<sceGsTest>(0x5000B);
    mgTEST_2 = mgTEST_1;
    mgALPHA_1 = FromRaw<sceGsAlpha>(0x44);
    mgALPHA_2 = mgALPHA_1;
    mgTEXA_1 = FromRaw<sceGsTexa>(0x100400000ULL);
    mgTEXA_2 = mgTEXA_1;
    mgZBUF_1 = FromRaw<sceGsZbuf>(static_cast<uint64_t>(frame_buf1 * 2) |
                                  (static_cast<uint64_t>(SCE_GS_PSMZ24 & 0xF) << 24));
    mgZBUF_2 = mgZBUF_1;
    mgRenderInfo.draw_env[0].zbuf = mgZBUF_1;
    mgRenderInfo.draw_env[1].zbuf = mgZBUF_2;

    mgVif1Packet = &vif_packet;
    data_id = 0;
    mgCreateSinTable();
    mgPortResetGs();
    ClockSetTickCallback(VSyncCallBack);
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    cut_next_tick = true;
    cut_camera_next_tick = true;
    ready = true;
}

PORT_OVERRIDE void mgInitVif1Packet(u_long128 *, u_long128 *, int) {
}

PORT_OVERRIDE void mgSetPacketBuffer(mgCMemory *, mgCMemory *) {
}

PORT_OVERRIDE void mgSetDataBuffer(mgCMemory *pool_a, mgCMemory *pool_b, int skip_header) {
    u_char *base = (u_char *) pool_a->stAllocTest(1);
    int     size = pool_a->stack_size - pool_a->stack_used;

    if (skip_header != 0) {
        base += 0x4000;
        size -= 0x800;
    }

    data_buf[0].stSetBuffer((u_long128 *) base, size);
    base = (u_char *) pool_b->stAllocTest(1);
    size = pool_b->stack_size - pool_b->stack_used;

    if (skip_header != 0) {
        base += 0x4000;
        size -= 0x800;
    }

    data_buf[1].stSetBuffer((u_long128 *) base, size);
    data_buf[0].stack_used = 0;
    data_buf[0].lock = 0;
    data_buf[1].stack_used = 0;
    data_buf[1].lock = 0;
}

PORT_OVERRIDE mgCMemory *mgGetDataBuffer() {
    return &data_buf[data_id];
}

PORT_OVERRIDE void mgSetRenderInfo(float fov, float clip_near, float clip_far) {
    mgRenderInfo.SetRenderInfo(fov, mgScreenWidth, mgScreenHeight, clip_near, clip_far,
                               mgScreenZDepth, 2096.0f / (3.0f * (float) mgScreenWidth));
    ApplyVisibleBox(mgRenderInfo);
}

PORT_OVERRIDE void mgBeginFrame(mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    manager->texture_manager = &mgTexManager;
    manager->render_info = &mgRenderInfo;
    mgTimeFrameBegin();
    static const CScene    *last_scene = nullptr;
    static const mgCCamera *last_camera = nullptr;
    static int              last_event = 0;
    static const CMap      *last_map = nullptr;
    static bool             last_dungeon_eye = false;
    CScene                 *scene = GetNowLoopNo() == LOOP_DUNGEON ? DngMainScene : GetNowLoopNo() == LOOP_EDIT ? GetMainScene()
                                                                                                                : nullptr;
    auto                   *camera = scene ? scene->GetCamera(scene->active_camera) : nullptr;
    const int               event = scene ? scene->event_run : 0;
    const auto             *map = scene ? scene->GetMap(scene->active_map) : nullptr;
    const bool              dungeon_eye = GetNowLoopNo() == LOOP_DUNGEON && DngStatus.eye_view;
    if (scene != last_scene || camera != last_camera || event != last_event || map != last_map || (dungeon_eye && !last_dungeon_eye)) {
        mgPortCutCameraInterpolation();
        last_scene = scene;
        last_camera = camera;
        last_event = event;
        last_map = map;
    }
    // Entry takes its eye pose on the following logic tick. Exit cuts at the
    // native ResetEyeView seam in the tick that restores the follow pose.
    last_dungeon_eye = dungeon_eye;

    if (!frame_open) {
        if (ready && !gfx::InFrame()) {
            gfx::BeginRecording();
            recording = true;
            gfx_open = true;

            if (cut_next_tick) {
                gfx::CutInterpolation();
                cut_next_tick = false;
            }

            if (cut_camera_next_tick) {
                gfx::CutCameraInterpolation();
                cut_camera_next_tick = false;
            }
        }

        frame_open = true;
    }

    mgBeginPacket(manager);
    mgSetPkTextureRepeat(1);
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    // The window can change shape between ticks; SetRenderInfo only runs once per scene.
    if (manager->render_info != NULL) {
        ApplyVisibleBox(*manager->render_info);
    }

    mgSetPkClearScreen(BackColorByte(0), BackColorByte(1), BackColorByte(2), BackColorByte(3));
}

PORT_OVERRIDE void mgBeginPacket(mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    mgVif1Packet = &vif_packet;
    // Every manager uses the same per-frame data arena. Reset its callbacks with the packet quadwords,
    // releasing their face owners before an address can name another mode's packet.
    mgPortClearPacketDraws();
    data_buf[data_id].stack_used = 0;
    data_buf[data_id].lock = 0;
    // BeginDraw falls back to packet_memory when handed no memory; the PC packet has none of its own.
    manager->packet_memory = &data_buf[data_id];
    manager->data_memory = &data_buf[data_id];
    manager->SetSortTable(1);
}

PORT_OVERRIDE void mgEndFrame(mgCDrawManager *manager) {
    bool queued[4] = {};

    for (int slot = 0; slot < 4; ++slot) {
        MG_PICKZ &pick = mgPickZBuff[slot];

        if (pick.enable == 0) {
            continue;
        }

        if (pick.x < 4 || pick.x > mgScreenWidth - 4 || pick.y < 4 || pick.y > mgScreenHeight - 4) {
            pick.z = -1;
        } else if (gfx_open) {
            gfx::ReadDepth(static_cast<uint32_t>(slot), static_cast<float>(pick.x - 4),
                           static_cast<float>(pick.y - 4), 8.0f, 8.0f);
            queued[slot] = true;
        } else {
            pick.z = -1;
        }
    }

    if (gfx_open) {
        gfx::SetRenderTarget(gfx::kMainTarget);
        gfx::DisplayListRef list = gfx::EndRecording();
        recording = false;

        if (list) {
            gfx::RenderList(*list, 1.0f, gfx::RenderOptions{.canonical = true});
        }

        previous_list = std::move(last_list);
        last_list = std::move(list);
        PresentTickRendered();

        CacheMarkedColors();
        AnswerDepthQueries();
    }

    gfx_open = false;

    for (int slot = 0; slot < 4; ++slot) {
        if (!queued[slot]) {
            continue;
        }

        const auto depth = gfx::DepthResult(static_cast<uint32_t>(slot));
        mgPickZBuff[slot].z = depth ? static_cast<int>(mgPortGsDepth(*depth)) : -1;
    }

    depth_next = kFirstAllocatedDepthSlot;
    frame_open = false;
    ++frame_count;

    if (exit_frames > 0 && frame_count == exit_frames) {
        int status = kExitOk;

        if (!screenshot_path.empty()) {
            std::vector<uint8_t> rgba;
            uint32_t             width = 0;
            uint32_t             height = 0;
            bool written = screenshot_options.fps ? PresentScreenshotFps(rgba, width, height)
                                                  : ReadNow(gfx::kMainTarget, rgba, width, height);
            written = written && gfx::WritePng(screenshot_path, rgba.data(), width, height);

            if (written) {
                std::fprintf(stderr, "mglib: frame %d written to %s\n", frame_count,
                             PathsDisplay(screenshot_path).c_str());
            } else {
                std::fprintf(stderr, "mglib: frame %d could not be written to %s\n", frame_count,
                             PathsDisplay(screenshot_path).c_str());
                status = kExitScreenshotFailed;
            }

            if (written && screenshot_options.display_frames > 0 && !WriteScreenshotDisplayFrames()) {
                status = kExitScreenshotFailed;
            }
        }

        std::exit(status);
    }

    PresentWaitFrame(old_vcount, mgFrameRate);
    old_vcount = mgGetVSyncCount();
    PresentTickEnd();
    mgNowFrameRate = mgTimeFrameFields();

    if (!(mgNowFrameRate - (float) mgFrameRate <= 1.0f)) {
        mgNowFrameRate = 1.0f + (float) mgFrameRate;
    }

    mgSendPacket(manager);
    dbuff_id ^= 1;
}

PORT_OVERRIDE void mgSendPacket(mgCDrawManager *manager) {
    data_id ^= 1;
}

PORT_OVERRIDE void mgEndPacket(mgCDrawManager *manager) {
}

PORT_OVERRIDE void mgWaitFrame() {
}

PORT_OVERRIDE void mgFlushRenderInfo() {
}

PORT_OVERRIDE int mgDrawDirect(mgCFrame *frame) {
    if (frame == NULL) {
        return 0;
    }

    return frame->Draw(direct_tag);
}

PORT_OVERRIDE int mgDrawDirect(mgCVisual *visual, float (*matrix)[4]) {
    if (visual == NULL) {
        return 0;
    }

    return visual->Draw(direct_tag, matrix, nullptr);
}

PORT_OVERRIDE void mgDrawDirectStart() {
    ddraw_size = 0;
}

PORT_OVERRIDE int mgDrawDirect2(mgCFrame *frame) {
    if (frame == NULL) {
        return 0;
    }

    const int size = frame->Draw(direct_tag);
    ddraw_size += size;
    return size;
}

PORT_OVERRIDE void mgDrawDirectEnd() {
}

PORT_OVERRIDE void StoreImage(int front_buffer) {
    if (frame_open) {
        return;
    }

    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;

    if (!ReadNow(gfx::kMainTarget, rgba, width, height)) {
        return;
    }

    char name[32];
    std::snprintf(name, sizeof name, "i%05d.png", store_count++);
    gfx::WritePng(PathsSaveRoot() / name, rgba.data(), width, height);
}

PORT_OVERRIDE void mgSetPkTextureRepeat(int mode) {
    mgPortGs().clamp = mode == 0 ? kClampBoth : 0;
}

PORT_OVERRIDE void mgSetPkTextureRepeat(sceGsClamp clamp) {
    mgPortGs().clamp = ToRaw(clamp);
}

namespace {

gfx::TextureHandle RegisteredFrameTarget(const mgCTexture *texture) {
    if (lookup_texture == nullptr) {
        return gfx::kNullTexture;
    }

    const gfx::TextureHandle image = lookup_texture(texture).texture;

    if (image == gfx::kNullTexture) {
        return gfx::kNullTexture;
    }

    const std::optional<gfx::TextureInfo> info = gfx::GetTextureInfo(image);

    if (!info) {
        return gfx::kNullTexture;
    }

    if (info->render_target) {
        return image;
    }

    if (info->format != gfx::TextureFormat::Rgba8) {
        return gfx::kNullTexture;
    }

    if (const gfx::TextureHandle grab = FrameGrabAt(static_cast<uint32_t>(texture->tex0.TBP0));
        grab != gfx::kNullTexture) {
        return grab;
    }

    const gfx::TextureHandle target = mgPortRenderTarget(texture);
    const auto record = registered_targets.find(texture);

    if (record == registered_targets.end() || record->second.seeded_from != image) {
        const int scale = MgTexturePhysicalExtent(texture).width / (1u << texture->tex0.TW);
        const gfx::Rect whole{0, 0, texture->width * scale, texture->height * scale};
        gfx::BlitTexture(image, whole, target, whole, gfx::Filter::Nearest);
        registered_targets[texture] = RegisteredTarget{static_cast<uint32_t>(texture->tex0.TBP0), image};
    }

    return target;
}

// tbp0 is the frame's key: the frame address shifted up, or a registered texture's full registry key.
// target_override, when set, is drawn into instead of the target the frame address selects.
void SetFrameBuffer(uint32_t tbp0, int width, int height, int psm, gfx::TextureHandle target_override) {
    int screen_width = 0;
    int screen_height = 0;
    ScreenSizeForMode(mgScreenMode, &screen_width, &screen_height);

    if (width < 0) {
        width = screen_width;
    }

    if (height < 0) {
        height = screen_height;
    }

    mgScreenWidth = width;
    mgScreenHeight = height;
    mgScreenNX = -width / 2;
    mgScreenNY = -height / 2;
    mgScreenMX = mgScreenNX + width;
    mgScreenMY = mgScreenNY + height;
    mgScreenOffx = 0x800 - width / 2;
    mgScreenOffy = 0x800 - height / 2;

    const int aligned_width = (width + 63) & ~63;
    sceGsFrame frame = FromRaw<sceGsFrame>(0);
    frame.FBP = tbp0 >> 5;
    frame.FBW = aligned_width / 64;
    frame.PSM = psm;
    frame.bits.fbmsk = 0;
    mgFRAME_1 = frame;

    gs_state.scissor[0] = 0;
    gs_state.scissor[1] = 0;
    gs_state.scissor[2] = width - 1;
    gs_state.scissor[3] = height - 1;

    int bpp = 0;

    switch (psm) {
        case SCE_GS_PSMCT32:
            bpp = 32;
            break;
        case SCE_GS_PSMCT24:
            bpp = 24;
            break;
        case SCE_GS_PSMCT16:
        case SCE_GS_PSMCT16S:
            bpp = 16;
            break;
        default:
            break;
    }

    frame_tex.Initialize();
    frame_tex.width = static_cast<short>(width);
    frame_tex.height = static_cast<short>(height);
    frame_tex.bpp = static_cast<short>(bpp);
    frame_tex.vram_size = bpp * (width * height) / 8 / 256;
    frame_tex.clut_size = 0;
    frame_tex.image_blocks = frame_tex.vram_size;
    frame_tex.tex0 = FromRaw<sceGsTex0>(0);
    frame_tex.tex0.TBP0 = tbp0;
    frame_tex.tex0.TBW = width / 64;
    frame_tex.tex0.PSM = psm;
    frame_tex.tex0.TW = CeilLog2(width);
    frame_tex.tex0.TH = CeilLog2(height);
    frame_tex.tex0.TCC = 1;
    frame_tex.tex0.TFX = 0;
    frame_tex.tex1 = FromRaw<sceGsTex1>(SCE_GS_SET_TEX1(1, 0, 1, 1, 1, 0, 0));

    if (target_override != gfx::kNullTexture) {
        current_target = target_override;
    } else if (tbp0 == static_cast<uint32_t>(DrawFbp()) << 5) {
        current_target = gfx::kMainTarget;
    } else if (const gfx::TextureHandle grab = FrameGrabAt(tbp0); grab != gfx::kNullTexture) {
        current_target = grab;
    } else {
        current_target = mgPortRenderTarget(tbp0, width, height, psm);
    }

    if (gfx_open) {
        gfx::SetRenderTarget(current_target);
    }
}

} // namespace

// A registered texture is keyed by its full TBP0; the frame-address key drops the low five bits and
// would collide with other keys.
PORT_OVERRIDE void mgSetPkFrameBuffer(mgCTexture *texture) {
    if (texture == NULL) {
        mgSetPkFrameBuffer(-1, -1, -1, -1);
        return;
    }

    const int psm = static_cast<int>(texture->tex0.PSM);

    if (const gfx::TextureHandle target = RegisteredFrameTarget(texture); target != gfx::kNullTexture) {
        SetFrameBuffer(static_cast<uint32_t>(texture->tex0.TBP0), texture->width, texture->height, psm, target);
        return;
    }

    mgSetPkFrameBuffer(static_cast<int>(texture->tex0.TBP0 / 32), static_cast<int>(texture->tex0.TBW << 6),
                       texture->height, psm);
}

PORT_OVERRIDE void mgSetPkFrameBuffer(int fbp, int width, int height, int psm) {
    if (fbp < 0) {
        fbp = DrawFbp();
    }

    if (psm < 0) {
        psm = SCE_GS_PSMCT32;
    }

    SetFrameBuffer(static_cast<uint32_t>(fbp) << 5, width, height, psm, gfx::kNullTexture);
}

PORT_OVERRIDE void mgGetFrameBuffer(mgCTexture *texture) {
    *texture = frame_tex;
}

PORT_OVERRIDE void mgGetFrameBackBuffer(mgCTexture *texture) {
    *texture = frame_tex;
    texture->tex0.TBP0 = DisplayFbp() << 5;
}

PORT_OVERRIDE void mgSetPkClearScreen(u_char red, u_char green, u_char blue, u_char alpha) {
    if (!gfx_open) {
        return;
    }

    const uint8_t color[4] = {red, green, blue, alpha};
    gfx::Clear(true, color, true, 0.0f, nullptr);
}

PORT_OVERRIDE u_long128 *mgGetVuProgPacket(int id) {
    if (!VuProgIdValid(id)) {
        return NULL;
    }

    if (id < MG_VU_PROG_USER) {
        return prog_adr[id];
    }

    return user_prog_adr[id - MG_VU_PROG_USER];
}

PORT_OVERRIDE int mgSendVuProg(u_int *tag, int id) {
    now_prog_id = VuProgIdValid(id) ? id : -1;
    return 0;
}

PORT_OVERRIDE void mgSetUserVuProg(u_long128 **table, int count) {
    user_prog_adr = table;
    user_prog_num = count;
}

PORT_OVERRIDE void mgSetUserVuProgAdr(int index, u_long128 *adr) {
    if (index < 0 || index >= user_prog_num) {
        return;
    }

    user_prog_adr[index] = adr;
}

PORT_OVERRIDE int mgInitFont() {
    return 0;
}

PORT_OVERRIDE void mgCloseFont() {
}

PORT_OVERRIDE void mgSetPkMoveImage(mgCTexture *source, mgRect<int> rect, mgCTexture *destination, int dst_x,
                                    int dst_y, int direction) {
    if (source == NULL || destination == NULL) {
        return;
    }

    const gfx::TextureHandle frame = mgPortFindTexture(source).texture;
    // Pause captures the completed display buffer; both buffers need the wide frame mapping.
    if (frame == gfx::kMainTarget || frame == gfx::kPreviousFrame) {
        CopyFrameInto(frame, rect, dst_x, dst_y, mgPortRenderTarget(destination, true));
        return;
    }

    CopyRectangle(mgPortFindTexture(source).texture, rect, mgPortFindTexture(destination).texture, dst_x, dst_y);
}

PORT_OVERRIDE void mgSetPkMoveImage(sceGsTex0 *src, mgRect<int> src_rect, sceGsTex0 *dst, int dst_x, int dst_y,
                                    int direction) {
    if (src == NULL || dst == NULL) {
        return;
    }

    const gfx::TextureHandle frame = mgPortFindTexture(ToRaw(*src)).texture;
    if (frame == gfx::kMainTarget || frame == gfx::kPreviousFrame) {
        CopyFrameInto(frame, src_rect, dst_x, dst_y, FrameTargetFor(*dst));
        return;
    }

    CopyRectangle(mgPortFindTexture(ToRaw(*src)).texture, src_rect, mgPortFindTexture(ToRaw(*dst)).texture, dst_x,
                  dst_y);
}

PORT_OVERRIDE void mgSetPkMoveImage(mgCTexture *source, mgRect<int> source_rect, mgCTexture *destination,
                                    mgRect<int> destination_rect, mgCDrawEnv *draw_env) {
    if (source == NULL || destination == NULL) {
        return;
    }

    StretchInto(mgPortFindTexture(source).texture, source_rect, destination->tex0, destination->height,
                destination_rect, destination);
}

PORT_OVERRIDE void mgSetPkMoveImage(sceGsTex0 *src, mgRect<int> src_rect, sceGsTex0 *dst, int dst_height,
                                    mgRect<int> dst_rect, mgCDrawEnv *env) {
    if (src == NULL || dst == NULL) {
        return;
    }

    StretchInto(mgPortFindTexture(ToRaw(*src)).texture, src_rect, *dst, dst_height, dst_rect, nullptr);
}

PORT_OVERRIDE int mgStoreImage(mgCTexture *texture, u_long128 *buffer) {
    if (texture == NULL || buffer == NULL) {
        return 0;
    }

    const int width = texture->width;
    const int height = texture->height;
    const int psm = static_cast<int>(texture->tex0.PSM);
    const int bytes_per_texel = BytesPerTexel(psm);
    const int bytes = width * height * bytes_per_texel;
    uint8_t *out = reinterpret_cast<uint8_t *>(buffer);

    if (bytes > 0) {
        std::memset(out, 0, static_cast<size_t>(bytes));
    }

    std::vector<uint8_t> rgba;
    uint32_t src_width = 0;
    uint32_t src_height = 0;
    const auto source = mgPortFindTexture(texture).texture;
    const bool has_source = bytes > 0 &&
                            mgPortReadColor(source, rgba, src_width, src_height) &&
                            src_width > 0 && src_height > 0 &&
                            rgba.size() >= static_cast<size_t>(src_width) * src_height * 4;

    if (has_source) {
        uint32_t content_width = src_width;
        uint32_t content_height = src_height;
        const auto info = gfx::GetTextureInfo(source);
        const float scale = TextureScale(source);
        if (info && scale > 1.0f) {
            content_width = static_cast<uint32_t>(width * scale * src_width / info->width);
            content_height = static_cast<uint32_t>(height * scale * src_height / info->height);
        }
        for (int y = 0; y < height; ++y) {
            const uint32_t sy = (2u * y + 1) * content_height / (2u * height);

            for (int x = 0; x < width; ++x) {
                const uint32_t sx = (2u * x + 1) * content_width / (2u * width);
                const uint8_t *pixel = &rgba[(static_cast<size_t>(sy) * src_width + sx) * 4];
                WriteTexel(out + (static_cast<size_t>(y) * width + x) * bytes_per_texel, psm, pixel);
            }
        }
    }

    return texture->bpp * (texture->width * texture->height);
}

PORT_OVERRIDE int mgStoreZBuffImage(mgRect<int> &rect, u_long128 *buffer) {
    int width = rect.right - rect.left + 1;
    int height = rect.bottom - rect.top + 1;
    width = width / 8 * 8;
    height = height / 8 * 8;

    if (width <= 0 || height <= 0) {
        return 0;
    }

    const DepthRect query{rect.left, rect.top, width, height};
    const std::optional<float> depth = query == depth_answered_rect ? depth_answer[kStoreDepthSlot] : std::nullopt;
    const uint32_t value = depth ? mgPortGsDepth(*depth) : 0;

    if (gfx_open) {
        gfx::ReadDepth(static_cast<uint32_t>(kStoreDepthSlot), static_cast<float>(rect.left),
                       static_cast<float>(rect.top), static_cast<float>(width), static_cast<float>(height));
        depth_pending[kStoreDepthSlot] = true;
        depth_queued_rect = query;
    }

    u_int *out = reinterpret_cast<u_int *>(buffer);

    for (int pixel = 0; pixel < width * height; ++pixel) {
        out[pixel] = value;
    }

    return width * height / 4;
}

PORT_OVERRIDE void mgBeginDrawShadow(mgCTexture *shadow, mgCTexture *unused) {
    if (shadow == NULL) {
        return;
    }

    // The counts live in the main target's stencil, which the renderer does not clear per frame.
    if (gfx_open) {
        gfx::ClearStencil(0, nullptr);
    }

    in_shadow = true;
}

PORT_OVERRIDE void mgEndDrawShadow(mgCTexture *shadow, mgCTexture *unused) {
    if (shadow == NULL || !in_shadow) {
        return;
    }

    // Any non-zero count darkens the pixel once and zeroes it: union, as retail's AEM composite.
    gfx::DrawState state = mgPortDrawState();
    state.blend = true;
    state.alpha = gfx::GsBlend{2, 1, 0, 1, 0x80};
    state.depth_test = gfx::DepthTest::Always;
    state.depth_write = false;
    state.alpha_test = false;
    state.cull = gfx::CullMode::None;
    state.stencil_test = true;
    const gfx::StencilFace composite_face{gfx::CompareOp::NotEqual, gfx::StencilOp::Keep,
                                          gfx::StencilOp::Zero, gfx::StencilOp::Keep};
    state.stencil_front = composite_face;
    state.stencil_back = composite_face;
    state.color_write_mask = gfx::kWriteRgba;

    // Alpha 48 is retail's TEXA TA0 for the composite.
    const uint8_t colour[4] = {0, 0, 0, 48};
    const mgPortExtent extent = mgPortVisibleExtent();
    const float corners[4][2] = {{extent.left, extent.top},
                                 {extent.right, extent.top},
                                 {extent.right, extent.bottom},
                                 {extent.left, extent.bottom}};
    gfx::Vertex2D quad[4]{};
    for (int i = 0; i < 4; ++i) {
        quad[i].x = corners[i][0];
        quad[i].y = corners[i][1];
        std::memcpy(quad[i].color, colour, sizeof colour);
    }
    mgPortDraw2D(gfx::Primitive::Quads, quad, gfx::TextureBinding{}, state);

    sceGsTexa texa = FromRaw<sceGsTexa>(0);
    texa.TA0 = 0;
    texa.TA1 = 128;
    texa.AEM = 1;
    gs_state.texa = ToRaw(texa);

    in_shadow = false;
}
