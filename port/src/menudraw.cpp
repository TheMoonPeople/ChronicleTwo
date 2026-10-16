#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <cmath>
#include <optional>
#include <limits>

#include "menu_mouse_item.hpp"
#include "menuchr.hpp"
#include "menudraw.hpp"
#include "menudraw_port.hpp"
#include "menumain.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/paths.hpp"
#include "present.hpp"
#include "stubs/menusys.hpp"

#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

PORT_OVERRIDE void MenuReloadCLUT(int index) {
    MgTextureSetDrawVariant(MenuCharaChangeBase_Tex, index == 0 ? MenuCharaChangeCLUT_Tex : nullptr);
}

bool MenuItemUsesWorldBackdrop();
int  MenuItemWakuSide();
float MenuPortVisibleLeft();
extern float MenuItemAnchorSplit;
extern int MenuItemPopupSide;
bool MenuMouseHeldItemAt(float &x, float &y);
extern void PortRetailDrawMenuFillBox(int alpha, int red, int green, int blue);

PORT_OVERRIDE void DrawMenuFillBox(int alpha, int red, int green, int blue) {
    if (MenuItemUsesWorldBackdrop()) {
        return;
    }
    PortRetailDrawMenuFillBox(alpha, red, green, blue);
}

PORT_OVERRIDE void DrawMenuWakuRect(mgCTexture *texture, mgRect<float> rect, mgRect<int> uv,
                                    int alpha, int red, int green, int blue) {
    if (texture == nullptr || uv.right <= 0) {
        return;
    }

    // Over the paused world the item page's panels split left and right. The dashed frame is many small
    // sprites clipped to its own box; anchored one by one, a frame moving between the panels split apart and
    // its dashes were clipped away in the gap. It moves as one instead, unanchored, with a shift that eases
    // towards the side of the panel the selection is on, so it travels visibly across the gap.
    std::optional<gfx::UiAnchorScope> plain;
    if (MenuItemUsesWorldBackdrop()) {
        static float shift = 0.0f;
        static int   shift_tick = -1;
        const float  edge = -MenuPortVisibleLeft();
        const float  target = MenuItemWakuSide() > 0 ? edge : -edge;
        if (shift_tick != MenuItemCommandCounter) {
            if (shift_tick < 0 || MenuItemCommandCounter - shift_tick > 2) {
                shift = target;
            }
            shift_tick = MenuItemCommandCounter;
            shift += (target - shift) * 0.25f;
            if (std::fabs(target - shift) < 0.5f) {
                shift = target;
            }
        }
        rect.left += shift;
        plain.emplace(gfx::UiAnchor{});
    }
    const mgRect<int> outer(static_cast<int>(rect.left), static_cast<int>(rect.top),
                            static_cast<int>(rect.left + rect.right + uv.bottom),
                            static_cast<int>(rect.top + rect.bottom + uv.right));
    auto              scissor = outer;
    MenuClipRectCheck(scissor);
    if (scissor.right <= 1) {
        return;
    }
    auto *prim = GetMenuPrim();
    SetMenuScissor(scissor);
    SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(texture);
    prim->Color(red, green, blue, alpha);
    float     sign = 1.0f;
    const int horizontal_count = static_cast<int>(3.0f + rect.right / uv.right);
    for (int edge = 0; edge < 2; ++edge) {
        float       x = (edge == 0 ? outer.right - 3 : outer.left) + PortMenuWakuPosition[0] * sign;
        const float y = edge == 0 ? outer.top - 5 : outer.bottom - 8;
        for (int tile = 0; tile < horizontal_count; ++tile) {
            prim->TextureCrd(uv.left, uv.top);
            prim->Vertex(x, y, 0.0f);
            prim->TextureCrd(uv.left + uv.right, uv.top + uv.bottom);
            prim->Vertex(x + uv.right, y + uv.bottom, 0.0f);
            x -= uv.right * sign;
        }
        sign = -sign;
    }
    prim->End();

    SetMenuScissor({0, scissor.top + 1, mgScreenWidth - 1, scissor.bottom - 1});
    SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
    prim->Begin(MG_PRIM_TRIANGLE_FAN);
    // Initialize clears the builder descriptor. Retail retains TEX0/RGBAQ in the GS;
    // explicitly bind both again for the rotated bands on the host.
    prim->Texture(texture);
    prim->Color(red, green, blue, alpha);
    const int vertical_count = static_cast<int>(3.0f + rect.bottom / uv.right);
    for (int edge = 0; edge < 2; ++edge) {
        const float x = edge == 0 ? outer.left - 5 : outer.right - 8;
        float       y = (edge == 0 ? outer.top - 13 : outer.bottom) + PortMenuWakuPosition[1] * sign;
        for (int tile = 0; tile < vertical_count; ++tile) {
            prim->TextureCrd(uv.left, uv.top + uv.bottom);
            prim->Vertex(x, y, 0.0f);
            prim->TextureCrd(uv.left, uv.top);
            prim->Vertex(x + uv.bottom, y, 0.0f);
            prim->TextureCrd(uv.left + uv.right, uv.top);
            prim->Vertex(x + uv.bottom, y + uv.right, 0.0f);
            prim->TextureCrd(uv.left + uv.right, uv.top + uv.bottom);
            prim->Vertex(x, y + uv.right, 0.0f);
            prim->Flush();
            y += uv.right * sign;
        }
        sign = -sign;
    }
    prim->End();
    ResetMenuScissor();
}

// Left edge of what the window shows, in logical pixels (negative when wider than 4:3).
float MenuPortVisibleLeft() {
    // The inventory layout stops at a centred 16:9 area (see its UiAnchor::max_aspect); logical frames are
    // shown at 4:3, so 16:9 spans 4/3 of the logical width.
    const float sixteen_nine_left = mgScreenWidth * 0.5f - mgScreenWidth * (16.0f / 9.0f) / (4.0f / 3.0f) * 0.5f;
    return std::max(mgPortVisibleExtent().left, sixteen_nine_left);
}

// The window-resolution picture taken at the menu's grab, kept in a texture of its own: the game reuses
// the grab texture's slot while the menus load, which drops the GPU copy behind it.
static gfx::TextureHandle menu_display_copy = gfx::kNullTexture;
static uint32_t           menu_display_w = 0;
static uint32_t           menu_display_h = 0;

// The last outdoor picture, kept as the location's scene for menus opened where the live picture does not
// work (inside buildings, under fixed cameras). Set by ps2/src/menumain.cpp for the menu being opened.
extern bool               MenuSnapshotFallback;
static gfx::TextureHandle menu_fallback_copy = gfx::kNullTexture;
static uint32_t           menu_fallback_w = 0;
static uint32_t           menu_fallback_h = 0;

bool MenuPortFallbackValid() {
    return menu_fallback_copy != gfx::kNullTexture && menu_fallback_w > 0 && menu_fallback_h > 0;
}

static gfx::TextureHandle MenuPortUpload(const std::vector<uint8_t> &rgba, uint32_t width, uint32_t height);

// The pixels of the last outdoor picture, kept so the scene can be written to the save folder.
static std::vector<uint8_t> menu_fallback_rgba;

// One file per area in the save folder: a header with the camera and the character's spot, then the
// picture's RGBA rows.
struct MenuSceneHeader {
    char     magic[8];
    uint32_t width;
    uint32_t height;
    float    world_matrix[16];
    float    camera_pos[4];
    float    projection;
    float    position[4];
    float    rotation[4];
};

static std::filesystem::path MenuScenePath(int area) {
    return PathsSaveRoot() / "menu_scenes" / ("area" + std::to_string(area) + ".scene");
}

void MenuPortStoreScene(int area, const float *world_matrix, const float *camera_pos, float projection,
                        const float *position, const float *rotation) {
    if (menu_fallback_rgba.empty() || menu_fallback_w == 0 || menu_fallback_h == 0) {
        return;
    }
    MenuSceneHeader header{};
    std::memcpy(header.magic, "CTSCENE1", 8);
    header.width = menu_fallback_w;
    header.height = menu_fallback_h;
    std::memcpy(header.world_matrix, world_matrix, sizeof(header.world_matrix));
    std::memcpy(header.camera_pos, camera_pos, sizeof(header.camera_pos));
    header.projection = projection;
    std::memcpy(header.position, position, sizeof(header.position));
    std::memcpy(header.rotation, rotation, sizeof(header.rotation));

    std::error_code error;
    const auto      path = MenuScenePath(area);
    std::filesystem::create_directories(path.parent_path(), error);
    std::ofstream file(path, std::ios::binary | std::ios::trunc);
    if (!file) {
        return;
    }
    file.write(reinterpret_cast<const char *>(&header), sizeof(header));
    file.write(reinterpret_cast<const char *>(menu_fallback_rgba.data()),
               static_cast<std::streamsize>(menu_fallback_rgba.size()));
}

bool MenuPortLoadScene(int area, float *world_matrix, float *camera_pos, float *projection, float *position,
                       float *rotation) {
    std::ifstream file(MenuScenePath(area), std::ios::binary);
    MenuSceneHeader header{};
    if (!file || !file.read(reinterpret_cast<char *>(&header), sizeof(header)) ||
        std::memcmp(header.magic, "CTSCENE1", 8) != 0 || header.width == 0 || header.height == 0 ||
        header.width > 16384 || header.height > 16384) {
        return false;
    }
    std::vector<uint8_t> rgba(static_cast<size_t>(header.width) * header.height * 4);
    if (!file.read(reinterpret_cast<char *>(rgba.data()), static_cast<std::streamsize>(rgba.size()))) {
        return false;
    }

    if (menu_fallback_copy != gfx::kNullTexture) {
        gfx::DestroyTexture(menu_fallback_copy);
    }
    menu_fallback_copy = MenuPortUpload(rgba, header.width, header.height);
    if (menu_fallback_copy == gfx::kNullTexture) {
        menu_fallback_w = menu_fallback_h = 0;
        return false;
    }
    menu_fallback_w = header.width;
    menu_fallback_h = header.height;
    menu_fallback_rgba = std::move(rgba);
    std::memcpy(world_matrix, header.world_matrix, sizeof(header.world_matrix));
    std::memcpy(camera_pos, header.camera_pos, sizeof(header.camera_pos));
    *projection = header.projection;
    std::memcpy(position, header.position, sizeof(header.position));
    std::memcpy(rotation, header.rotation, sizeof(header.rotation));
    return true;
}

static gfx::TextureHandle MenuPortUpload(const std::vector<uint8_t> &rgba, uint32_t width, uint32_t height) {
    gfx::TextureDesc desc;
    desc.width = width;
    desc.height = height;
    desc.has_alpha = false;
    const gfx::TextureHandle texture = gfx::CreateTexture(desc);
    if (texture != gfx::kNullTexture && !gfx::UpdateTextureNow(texture, 0, 0, 0, width, height, rgba.data())) {
        gfx::DestroyTexture(texture);
        return gfx::kNullTexture;
    }
    return texture;
}

// Paints that picture (or the location's stored scene) over everything the window shows; false when there
// is none.
bool MenuPortDrawWorldCopy() {
    gfx::TextureHandle source = menu_display_copy;
    uint32_t           source_w = menu_display_w;
    uint32_t           source_h = menu_display_h;
    if (MenuSnapshotFallback) {
        source = menu_fallback_copy;
        source_w = menu_fallback_w;
        source_h = menu_fallback_h;
    }
    if (source == gfx::kNullTexture || source_w == 0 || source_h == 0) {
        return false;
    }

    const mgPortExtent extent = mgPortVisibleExtent();
    const float        u_right = static_cast<float>(source_w);
    const float        v_bottom = static_cast<float>(source_h);
    const float        xy[4][4] = {
        {extent.left,  extent.top,    0.0f,    0.0f    },
        {extent.right, extent.top,    u_right, 0.0f    },
        {extent.left,  extent.bottom, 0.0f,    v_bottom},
        {extent.right, extent.bottom, u_right, v_bottom},
    };
    std::vector<gfx::Vertex2D> strip;
    for (const auto &corner : xy) {
        gfx::Vertex2D vertex{};
        vertex.x = corner[0];
        vertex.y = corner[1];
        vertex.u = corner[2];
        vertex.v = corner[3];
        vertex.color[0] = 0x80;
        vertex.color[1] = 0x80;
        vertex.color[2] = 0x80;
        vertex.color[3] = 0x80;
        strip.push_back(vertex);
    }

    gfx::DrawState state = mgPortDrawState();
    state.blend = false;
    state.depth_test = gfx::DepthTest::Always;
    state.depth_write = false;
    state.screen_space = true;
    state.alpha_test = false;
    state.cull = gfx::CullMode::None;
    gfx::TextureBinding binding;
    binding.texture = source;
    binding.ignore_alpha = true;
    mgPortDraw2D(gfx::Primitive::TriangleStrip, strip, binding, state);
    return true;
}

// The window-resolution paused-world picture (or its stored scene) replaces the retail half-size grab
// while the Item page is open.
void MenuMainFrameWorldDraw(int &loaded_tex_no) {
    if (MenuFrameTex == NULL) {
        return;
    }
    if (MenuPortDrawWorldCopy()) {
        return;
    }

    MenuReloadTexture(loaded_tex_no, MenuFrameTex->block);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_OPAQUE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(MenuFrameTex);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    mgRect<int> screen(0, 0, mgScreenWidth, mgScreenHeight);
    mgRect<int> source(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    PrimQuad(prim, screen, source);
    prim->End();
}

PORT_OVERRIDE int MenuCapture(int block, mgCMemory *stack, int draw) {
    u8                *dst;
    mgCTextureManager *tex_manager;
    int                half_w;
    int                half_h;
    int                tex_w;
    int                tex_h;
    int                pad_w;
    int                pad_h;
    mgCDrawPrim       *prim;

    stack->Align64();
    tex_manager = &mgTexManager;
    dst = stack->stack_bytes + (stack->stack_used << 4);
    half_w = mgScreenWidth >> 1;
    half_h = mgScreenHeight >> 1;
    tex_w = half_w;
    MenuBGTextureBlock = block;
    tex_h = half_h;
    pad_w = half_w % 64;
    pad_h = half_h % 64;

    if (pad_w != 0) {
        tex_w += 64 - pad_w;
    }

    if (pad_h != 0) {
        tex_h += 64 - pad_h;
    }

    static char frame_name[] = "menuwork2";
    tex_manager->DeleteBlock(block);
    MenuFrameTex = tex_manager->EnterTexture(block, frame_name, NULL, tex_w, tex_h, 32, NULL, 0, 0);

    if (MenuFrameTex != NULL) {
        MenuFrameTex->tex0.bits.tcc = 0;
        MenuFrameTex->image[0] = (u_long128 *) dst;
        stack->Alloc(half_w * half_h * 4 / 16 + 1);
    }

    // The grab costs a frame on PS2 too: the tick that just ended is gfx::kPreviousFrame in the next one.
    mgEndFrame(NULL);

    // The tick's own image is the PS2's resolution; the picture on screen is drawn again at the window's.
    // Take that display picture so the paused world behind the menus matches the current resolution.
    std::vector<uint8_t> display_rgba;
    uint32_t             display_w = 0;
    uint32_t             display_h = 0;
    const bool           have_display = MenuFrameTex != NULL &&
                                        PresentScreenshotDisplay(1.0f, display_rgba, display_w, display_h) &&
                                        display_w > 0 && display_h > 0 &&
                                        display_rgba.size() >= static_cast<size_t>(display_w) * display_h * 4;

    if (MenuFrameTex != NULL) {
        // Reloads upload the stack image whenever the GPU target is not bound, so it must hold the frame too.
        // Outside a frame the read is synchronous; the 2x2 box filter matches retail.
        std::vector<uint8_t> rgba;
        uint32_t             src_w = 0;
        uint32_t             src_h = 0;
        const bool read = mgPortReadColor(gfx::kMainTarget, rgba, src_w, src_h) && src_w > 0 && src_h > 0 &&
                          rgba.size() >= static_cast<size_t>(src_w) * src_h * 4;

        for (int y = 0; y < half_h; ++y) {
            for (int x = 0; x < half_w; ++x) {
                u8 *out = dst + (static_cast<size_t>(y) * half_w + x) * 4;
                if (!read) {
                    out[0] = out[1] = out[2] = 0;
                    out[3] = 0x80;
                    continue;
                }
                int sum[3] = {0, 0, 0};
                for (int k = 0; k < 4; ++k) {
                    const uint32_t sx = ((2u * x + (k & 1)) * src_w) / (2u * half_w);
                    const uint32_t sy = ((2u * y + (k >> 1)) * src_h) / (2u * half_h);
                    const uint8_t *p = &rgba[(static_cast<size_t>(sy) * src_w + sx) * 4];
                    sum[0] += p[0];
                    sum[1] += p[1];
                    sum[2] += p[2];
                }
                out[0] = static_cast<u8>(sum[0] >> 2);
                out[1] = static_cast<u8>(sum[1] >> 2);
                out[2] = static_cast<u8>(sum[2] >> 2);
                out[3] = 0x80;
            }
        }
    }

    mgBeginFrame(NULL);

    if (MenuFrameTex != NULL) {
        // Frame target: the window's sides past the logical frame are copied in and carried by the full-frame draw.
        // Registered before the copy: until a target exists under its TBP0 the texture binds its stack image.
        // Linear at 2:1 samples each 2x2 block's midpoint, which is the box filter retail ran on the CPU.
        const gfx::TextureHandle target = mgPortRenderTarget(MenuFrameTex, true);
        gfx::BlitTexture(gfx::kPreviousFrame, gfx::Rect{0, 0, mgScreenWidth, mgScreenHeight}, target,
                         gfx::Rect{0, 0, half_w, half_h}, gfx::Filter::Linear);

        // The window-resolution picture, in a texture of its own, for the Item page's paused world
        // (MenuPortDrawWorldCopy).
        if (menu_display_copy != gfx::kNullTexture) {
            gfx::DestroyTexture(menu_display_copy);
            menu_display_copy = gfx::kNullTexture;
        }
        menu_display_w = 0;
        menu_display_h = 0;
        if (have_display && !MenuSnapshotFallback) {
            menu_display_copy = MenuPortUpload(display_rgba, display_w, display_h);
            if (menu_display_copy != gfx::kNullTexture) {
                menu_display_w = display_w;
                menu_display_h = display_h;

                // Outdoors, this framed picture also becomes the location's stored scene.
                if (menu_fallback_copy != gfx::kNullTexture) {
                    gfx::DestroyTexture(menu_fallback_copy);
                }
                menu_fallback_copy = MenuPortUpload(display_rgba, display_w, display_h);
                menu_fallback_w = menu_fallback_copy != gfx::kNullTexture ? display_w : 0;
                menu_fallback_h = menu_fallback_copy != gfx::kNullTexture ? display_h : 0;
                menu_fallback_rgba = display_rgba;
            }
        }
    }

    if (draw != 0 && MenuFrameTex != NULL) {
        tex_manager->ReloadTexture(block, (sceVif1Packet *) NULL);
        prim = GetMenuPrim();
        prim->Initialize(NULL, NULL);
        prim->TextureMapEnable(1);
        prim->Bilinear(1);
        prim->AlphaTestEnable(0);
        prim->DepthTestEnable(0);
        prim->ZMask(MG_Z_MASK_MASKED);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(MenuFrameTex);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        prim->TextureCrd(0, 0);
        prim->Vertex(0, 0, 0);
        prim->TextureCrd(half_w, half_h);
        prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim->End();
    }

    return true;
}

// Move by whole tiles so integer sprite coordinates cover the visible leading edge.
float MenuTilePatternFirst(float phase, int size, float minimum) {
    if (size <= 0) {
        return phase;
    }
    return phase - std::ceil((phase - minimum) / size) * size;
}

// Count of grid positions first, first + size, ... that do not pass limit.
int MenuTilePatternCount(float first, int size, float limit) {
    int   count = 0;
    float pos = first;

    if (size <= 0) {
        return 0;
    }

    while (pos <= limit) {
        count++;
        pos += (float) size;
    }

    return count;
}

PORT_OVERRIDE void DrawMenuTilePattern(mgCDrawPrim *prim, mgCTexture *tex, float x, float y, mgRect<int> tex_rect,
                                       int unused, u8 *rgba) {
    mgRect<int> dest(0, 0, 0, 0);
    float       column_first;
    float       row_first;
    int         column_count;
    int         row_count;
    int         column;
    int         row;

    if (tex_rect.right <= 0 || tex_rect.bottom <= 0) {
        return;
    }

    const auto extent = mgPortVisibleExtent();
    // One logical pixel protects negative fractional origins from truncation toward zero.
    column_first = MenuTilePatternFirst(x, tex_rect.right, std::floor(extent.left) - 1.0f);
    row_first = MenuTilePatternFirst(y - tex_rect.bottom, tex_rect.bottom, std::floor(extent.top) - 1.0f);
    column_count = MenuTilePatternCount(column_first, tex_rect.right, std::ceil(extent.right));
    row_count = MenuTilePatternCount(row_first, tex_rect.bottom, std::ceil(extent.bottom));

    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(tex);

    if (rgba != NULL) {
        prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
    } else {
        prim->Color(0x80, 0x80, 0x80, 0x80);
    }

    for (column = 0; column < column_count; column++) {
        dest.Set((int) (column_first + (float) (column * tex_rect.right)), (int) row_first, tex_rect.right,
                 tex_rect.bottom);

        for (row = 0; row < row_count; row++) {
            PrimQuad(prim, dest, tex_rect);
            dest.top += dest.bottom;
        }
    }

    prim->End();
}

namespace {

bool MenuPanelOutsideFrame(const CMenuPosDataForm &form) {
    if (form.dtype != MENUFORM_DTYPE_NORMAL && form.dtype != MENUFORM_DTYPE_LIST) {
        return false;
    }
    const auto extent = mgPortVisibleExtent();
    if (extent.left >= 0 && extent.right <= mgScreenWidth) {
        return false;
    }

    float left = std::numeric_limits<float>::infinity();
    float right = -left;
    for (int i = 0; i < form.parts_num; ++i) {
        const auto &part = form.parts[i];
        if (!part.active || !part.draw_flag || part.dtype == MENUFORMPARTS_DTYPE_FUNCINFO) {
            continue;
        }
        // Compositors and special drawing routines do not have panel bounds.
        // Preserve their drawing and side effects when an extent is unknown.
        if (part.w >= mgScreenWidth && part.h >= mgScreenHeight) {
            return false;
        }
        float x0 = part.x, x1 = part.x + part.w;
        switch (part.dtype) {
            case MENUFORMPARTS_DTYPE_NORMAL:
            case MENUFORMPARTS_DTYPE_SQ_BETA:
            case MENUFORMPARTS_DTYPE_TRS:
                break;
            case MENUFORMPARTS_DTYPE_NORMAL2:
                x0 += std::min(0, part.etc_info[0]);
                x1 += std::max(0, part.etc_info[0]);
                break;
            case MENUFORMPARTS_DTYPE_NUMBER1:
            case MENUFORMPARTS_DTYPE_NUMBER2: {
                if (!MenuPosData) {
                    return false;
                }
                const auto *info = MenuPosData->GetTexGetInfo(part.tex_info_no);
                if (!info) {
                    return false;
                }
                int digits = 1;
                for (int value = part.etc_info[1]; value >= 10; value /= 10) {
                    ++digits;
                }
                if (part.dtype == MENUFORMPARTS_DTYPE_NUMBER2) {
                    digits = std::max(digits, part.etc_info[0]);
                }
                // Conservative for all three alignments, including negative spacing.
                const float span = digits * std::abs(info->rect.right + part.w) + info->rect.right;
                x0 -= span;
                x1 = part.x + span;
                break;
            }
            default:
                return false;
        }
        // Item-icon effects use their own storage layout in DrawOneItem.
        if (part.dtype != MENUFORMPARTS_DTYPE_SQ_BETA && part.dtype != MENUFORMPARTS_DTYPE_TRS) {
            for (int effect = 0; part.effect && effect < part.effect_num; ++effect) {
                const int type = part.effect[effect].type;
                if (type != 0 && type != MENU_PARTS_EFFECT_FILLBOX && type != MENU_PARTS_EFFECT_BLINK) {
                    return false;
                }
            }
        }
        const float sway = part.vibe_cnt[0] ? part.viber[0] + 1.0f : 0.0f;
        const float shadow = part.shadow ? std::abs(static_cast<int>(part.shadow_offset)) : 0;
        left = std::min(left, std::min(x0, x1) - sway - shadow);
        right = std::max(right, std::max(x0, x1) + sway + shadow);
    }
    const float sway = form.vibe_cnt[0] ? 10.0f : 0.0f;
    return std::isfinite(left) && (fptosi(form.x) + right + sway <= 0 ||
                                   fptosi(form.x) + left - sway >= mgScreenWidth);
}

} // namespace

PORT_OVERRIDE void CMenuPosDataForm::MenuFormDraw(int &state) {
    // Retail parks unused panels wholly outside its logical frame (SPECHECK,
    // for example, at x=-260). Hide that panel, not the entire page's flanks.
    // As soon as it overlaps the frame, draw its complete entering geometry.
    if (MenuPanelOutsideFrame(*this)) {
        return;
    }

    if (MenuItemUsesWorldBackdrop()) {
        CMenuPosDataForm *main_frame = MenuPosData != NULL ? MenuPosData->GetFormInfo("main_bg_img") : NULL;
        CMenuPosDataForm *menu_fill = MenuPosData != NULL ? MenuPosData->GetFormInfo("mainform_fill") : NULL;
        CMenuPosDataForm *character_fill = CMenuItemInfoPt != NULL ? CMenuItemInfoPt->fill_form : NULL;
        if (this == main_frame || this == menu_fill || this == character_fill ||
            dtype == MENUFORM_DTYPE_MAINFRM || dtype == MENUFORM_DTYPE_MAINIMG) {
            return;
        }

        float held_x = 0.0f;
        float held_y = 0.0f;
        if (MenuCommonInfo != NULL && this == MenuCommonInfo->cursor_form &&
            MenuMouseHeldItemAt(held_x, held_y)) {
            float tip_x = 0.0f;
            float tip_y = 0.0f;
            GetPutPosXY(const_cast<char *>("cursor0"), tip_x, tip_y);
            const float old_x = x;
            const float old_y = y;
            x += held_x - 26.0f - tip_x;
            y += held_y - 14.0f - tip_y;
            {
                gfx::UiAnchorScope plain(gfx::UiAnchor{});
                int draw_x = fptosi(x), draw_y = fptosi(y);
                MenuFormDraw(draw_x, draw_y, state);
            }
            x = old_x;
            y = old_y;
            return;
        }

        if (CMenuItemInfoPt != NULL && CMenuItemInfoPt->mode != MENU_ASK_MODE_NONE &&
            this == CMenuItemInfoPt->ask_para.form) {
            gfx::UiAnchor popup_anchor = gfx::UiAnchor::Side(MenuItemPopupSide, 0, true);
            popup_anchor.max_aspect = 16.0f / 9.0f;
            gfx::UiAnchorScope popup_layout(popup_anchor);
            int draw_x = fptosi(x), draw_y = fptosi(y);
            MenuFormDraw(draw_x, draw_y, state);
            return;
        }

        float form_x = 0.0f;
        float form_y = 0.0f;
        GetPutPosXY(NULL, form_x, form_y);
        gfx::UiAnchor form_anchor = gfx::UiAnchor::Side(form_x >= MenuItemAnchorSplit - 40.0f ? 1 : -1, 0, true);
        form_anchor.max_aspect = 16.0f / 9.0f;
        gfx::UiAnchorScope form_layout(form_anchor);
        int draw_x = fptosi(x), draw_y = fptosi(y);
        MenuFormDraw(draw_x, draw_y, state);
        return;
    }

    int draw_x = fptosi(x), draw_y = fptosi(y);
    MenuFormDraw(draw_x, draw_y, state);
}

PORT_OVERRIDE void MenuCursorDraw(mgCTexture *texture, float *position, float rotation,
                                  int reverse, int alpha, float scale) {
    if (!texture) {
        return;
    }
    const auto hand_key = MenuMouseNoteHand(mgPortBinding(texture),
                                            {float(menu_long_hand.left), float(menu_long_hand.top),
                                             float(menu_long_hand.right), float(menu_long_hand.bottom)},
                                            rotation, reverse, alpha, scale);
    // The canonical image retains the selection hand. A displayed mouse pointer
    // replaces this tagged group without changing screenshots or grab textures.
    gfx::Interp2DScope tag({hand_key, static_cast<uint64_t>(mgPortFrameCount())});
    auto              *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Bilinear(1);
    prim->Begin(MG_PRIM_TRIANGLE_STRIP);
    prim->Texture(texture);
    prim->Color(128, 128, 128, alpha);
    const float c = std::cos(rotation), s = std::sin(rotation);
    for (int i = 0; i < 4; ++i) {
        const float x = (i & 1 ? 40 : 0) * scale * (reverse ? -1 : 1);
        const float y = (i & 2 ? 24 : 0) * scale;
        prim->TextureCrd(menu_long_hand.left + (i & 1 ? menu_long_hand.right : 0),
                         menu_long_hand.top + (i & 2 ? menu_long_hand.bottom : 0));
        const float px = i == 0 ? 3.0f + position[0] : 3.0f + (position[0] + (x * c - y * s));
        const float py = i == 0 ? 3.0f + position[1] : i & 1 ? position[1] + (x * s + y * c)
                                                             : 3.0f + (position[1] + (x * s + y * c));
        prim->Vertex(px, py, 0.0f);
    }
    prim->End();
}
