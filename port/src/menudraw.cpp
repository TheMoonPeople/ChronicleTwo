#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <limits>
#include <optional>
#include <print>
#include <string>
#include <utility>

#include "actionchara.hpp"
#include "asset_directory.hpp"
#include "dataread_port.hpp"
#include "menu_mouse_item.hpp"
#include "menu_world.hpp"
#include "menuchr.hpp"
#include "menudraw.hpp"
#include "menudraw_port.hpp"
#include "menumain.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/model_assets.hpp"
#include "platform/texture_bundle.hpp"
#include "stubs/menudraw.hpp"

PORT_OVERRIDE void MenuReloadCLUT(int index) {
    MgTextureSetDrawVariant(MenuCharaChangeBase_Tex, index == 0 ? MenuCharaChangeCLUT_Tex : nullptr);
}

PORT_OVERRIDE void DrawMenuFillBox(int alpha, int red, int green, int blue) {
    if (!menuworld::FillWithBackdrop()) {
        PortRetailDrawMenuFillBox(alpha, red, green, blue);
    }
}

PORT_OVERRIDE void DrawMenuWakuRect(mgCTexture *texture, mgRect<float> rect, mgRect<int> uv,
                                    int alpha, int red, int green, int blue) {
    if (texture == nullptr || uv.right <= 0) {
        return;
    }
    // The frame's many clipped pieces move together, or a frame between two spread panels comes apart.
    std::optional<gfx::UiAnchorScope> anchor;
    if (const auto selection = menuworld::SelectionAnchor()) {
        anchor.emplace(*selection);
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

PORT_OVERRIDE int MenuCapture(int block, mgCMemory *stack, int draw) {
    stack->Align64();
    u8       *dst = stack->stack_bytes + (stack->stack_used << 4);
    const int half_w = mgScreenWidth >> 1;
    const int half_h = mgScreenHeight >> 1;
    MenuBGTextureBlock = block;

    static char frame_name[] = "menuwork2";
    mgTexManager.DeleteBlock(block);
    MenuFrameTex = mgTexManager.EnterTexture(block, frame_name, nullptr, (half_w + 63) / 64 * 64, (half_h + 63) / 64 * 64,
                                             32, nullptr, 0, 0);

    if (MenuFrameTex != nullptr) {
        MenuFrameTex->tex0.bits.tcc = 0;
        MenuFrameTex->image[0] = reinterpret_cast<u_long128 *>(dst);
        stack->Alloc(half_w * half_h * 4 / 16 + 1);
    }

    // The grab costs a frame on PS2 too: the tick that just ended is gfx::kPreviousFrame in the next one.
    mgEndFrame(nullptr);
    mgBeginFrame(nullptr);

    const gfx::TextureHandle source = menuworld::TakeMenuGrab();
    if (MenuFrameTex != nullptr) {
        // Frame target: the window's sides past the logical frame are copied in and carried by the full-frame draw.
        const gfx::TextureHandle target = mgPortRenderTarget(MenuFrameTex, true);
        // Registered before the copy: until a target exists under its TBP0 the texture binds its stack image.
        // Linear at 2:1 samples each 2x2 block's midpoint, which is the box filter retail ran on the CPU.
        gfx::BlitTexture(source, gfx::Rect{.x = 0, .y = 0, .w = mgScreenWidth, .h = mgScreenHeight}, target,
                         gfx::Rect{.x = 0, .y = 0, .w = half_w, .h = half_h}, gfx::Filter::Linear);
    }

    if (draw != 0 && MenuFrameTex != nullptr) {
        mgTexManager.ReloadTexture(block, static_cast<sceVif1Packet *>(nullptr));
        auto *prim = GetMenuPrim();
        prim->Initialize(nullptr, nullptr);
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
    if (size <= 0) {
        return 0;
    }
    int count = 0;
    for (float pos = first; pos <= limit; pos += static_cast<float>(size)) {
        ++count;
    }
    return count;
}

PORT_OVERRIDE void DrawMenuTilePattern(mgCDrawPrim *prim, mgCTexture *tex, float x, float y, mgRect<int> tex_rect,
                                       int /*unused*/, u8 *rgba) {
    if (tex_rect.right <= 0 || tex_rect.bottom <= 0) {
        return;
    }

    const auto extent = mgPortVisibleExtent();
    // One logical pixel protects negative fractional origins from truncation toward zero.
    const float column_first = MenuTilePatternFirst(x, tex_rect.right, std::floor(extent.left) - 1.0f);
    const float row_first = MenuTilePatternFirst(y - tex_rect.bottom, tex_rect.bottom, std::floor(extent.top) - 1.0f);
    const int   column_count = MenuTilePatternCount(column_first, tex_rect.right, std::ceil(extent.right));
    const int   row_count = MenuTilePatternCount(row_first, tex_rect.bottom, std::ceil(extent.bottom));

    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(tex);

    if (rgba != nullptr) {
        prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
    } else {
        prim->Color(0x80, 0x80, 0x80, 0x80);
    }

    mgRect<int> dest(0, 0, 0, 0);
    for (int column = 0; column < column_count; ++column) {
        dest.Set(static_cast<int>(column_first + static_cast<float>(column * tex_rect.right)), static_cast<int>(row_first),
                 tex_rect.right, tex_rect.bottom);

        for (int row = 0; row < row_count; ++row) {
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
        float x0 = part.x;
        float x1 = part.x + part.w;
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
            for (int effect = 0; part.effect && std::cmp_less(effect, part.effect_num); ++effect) {
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

void MenuAlignCharacterSlot(CMenuPosDataForm &form) {
    if (form.name == nullptr || std::strcmp(form.name, "chr_bg") != 0) {
        return;
    }
    auto *backing = form.GetPartInfo(const_cast<char *>("fcb1"));
    auto *portrait = form.GetPartInfo(const_cast<char *>("fc1"));
    auto *upper_backing = form.GetPartInfo(const_cast<char *>("fcb0"));
    if (backing != nullptr && portrait != nullptr && upper_backing != nullptr &&
        backing->y == 158.0f && backing->h == 100.0f && portrait->y == 181.0f && upper_backing->h == 121.0f) {
        backing->y = portrait->y;
        backing->h = upper_backing->h;
    }
}

PORT_OVERRIDE void CMenuPosDataForm::MenuFormDraw(int &state) {
    if (MenuCommonInfo != nullptr && MenuCommonInfo->now_mode == MENU_MODE_CHARA_CHANGE) {
        MenuAlignCharacterSlot(*this);
    }
    // Retail parks unused panels wholly outside its logical frame (SPECHECK,
    // for example, at x=-260). Hide that panel, not the entire page's flanks.
    // As soon as it overlaps the frame, draw its complete entering geometry.
    if (MenuPanelOutsideFrame(*this) || menuworld::HidesForm(*this)) {
        return;
    }
    // An item the mouse carries is drawn at the pointer, unmoved by the spread panels.
    float held_x = 0.0f;
    float held_y = 0.0f;
    if (menuworld::ItemBackdrop() && this == MenuCommonInfo->cursor_form && MenuMouseHeldItemAt(held_x, held_y)) {
        float tip_x = 0.0f;
        float tip_y = 0.0f;
        GetPutPosXY(const_cast<char *>("cursor0"), tip_x, tip_y);
        const gfx::UiAnchorScope unanchored(gfx::UiAnchor{});
        int                      draw_x = fptosi(x + held_x - 26.0f - tip_x);
        int                      draw_y = fptosi(y + held_y - 14.0f - tip_y);
        MenuFormDraw(draw_x, draw_y, state);
        return;
    }
    std::optional<gfx::UiAnchorScope> anchor;
    if (const auto spread = menuworld::FormAnchor(*this)) {
        anchor.emplace(*spread);
    }
    int draw_x = fptosi(x);
    int draw_y = fptosi(y);
    MenuFormDraw(draw_x, draw_y, state);
}

PORT_OVERRIDE void MenuCursorDraw(mgCTexture *texture, float *position, float rotation,
                                  int reverse, int alpha, float scale) {
    if (!texture) {
        return;
    }
    const auto hand_key = MenuMouseNoteHand(mgPortBinding(texture),
                                            {.x = static_cast<float>(menu_long_hand.left), .y = static_cast<float>(menu_long_hand.top), .w = static_cast<float>(menu_long_hand.right), .h = static_cast<float>(menu_long_hand.bottom)},
                                            rotation, alpha, scale);
    // The canonical image retains the selection hand. A displayed mouse pointer
    // replaces this tagged group without changing screenshots or grab textures.
    gfx::Interp2DScope tag({.key = hand_key, .generation = static_cast<uint64_t>(mgPortFrameCount())});
    auto              *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Bilinear(1);
    prim->Begin(MG_PRIM_TRIANGLE_STRIP);
    prim->Texture(texture);
    prim->Color(128, 128, 128, alpha);
    const float c = std::cos(rotation);
    const float s = std::sin(rotation);
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

namespace {
/**
 * Selects the repair model by its actual bundle or ordinary asset-directory filename.
 */
std::optional<std::filesystem::path> RepairModelPath(const void *data) {
    const auto path = DataReadBufferPath(data);
    if (path && std::filesystem::path(*path).extension() == ".gltf") {
        return std::filesystem::path(*path).replace_extension(".assets") / "repair_powder.gltf";
    }
    if (const auto directory = AssetDirectoryPath(data)) {
        return std::filesystem::path(*directory) / "repair_powder.gltf";
    }
    return std::nullopt;
}

/**
 * Enters the repair sprites from an embedded native set or an ordinary texture document.
 */
bool EnterRepairTexture(const void *data, int block) {
    const auto path = DataReadBufferPath(data);
    if (!path) {
        return false;
    }
    std::strcpy(mgTexManager.name_suffix, "_2");
    bool loaded = false;
    if (std::filesystem::path(*path).extension() == ".gltf") {
        std::string error;
        loaded = texture_bundle::Enter(*path, "menueff0", mgTexManager, block, nullptr, error);
        if (!loaded) {
            std::println(stderr, "repair texture: {}", error);
        }
    } else if (const auto directory = AssetDirectoryPath(data)) {
        MgTextureEnterDocument(&mgTexManager, *directory + "/repair_powder2d.json", block, nullptr, nullptr);
        char texture_name[] = "menueff0";
        loaded = mgTexManager.GetTexture(texture_name, block) != nullptr;
    }
    mgTexManager.name_suffix[0] = 0;
    return loaded;
}
} // namespace

PORT_OVERRIDE void CRepairManager::CheckDataBG(int block) {
    if (data_ready) {
        return;
    }
    mgTexManager.DeleteBlock(block);
    tex_block = static_cast<s16>(block);
    tex = nullptr;
    if (!EnterRepairTexture(data, block)) {
        bg_load = false;
        return;
    }
    char texture_name[] = "menueff0_2";
    tex = mgTexManager.GetTexture(texture_name, -1);
    data_ready = tex != nullptr;
    bg_load = false;
}

PORT_OVERRIDE void CRepairManager::SetRepairData(mgCMemory *memory, int block, unsigned int *pack) {
    if (!memory) {
        return;
    }
    tex_block = static_cast<s16>(block);
    data = pack;
    tex = nullptr;
    data_ready = false;
    bg_load = false;
    keep = false;
    if (!EnterRepairTexture(data, block)) {
        return;
    }
    char texture_name[] = "menueff0_2";
    tex = mgTexManager.GetTexture(texture_name, -1);
    data_ready = tex != nullptr;
    if (data_ready) {
        SetStack(memory, 1);
        keep = true;
    }
}

PORT_OVERRIDE void CRepairManager::GeneratePoly(float *position, int block) {
    const auto path = RepairModelPath(data);
    if (!path || !position || !model_stack.stack) {
        return;
    }
    if (model) {
        model_assets::DeleteCharacterTextures(*model, 0, CHARA_IMAGE_MAX - 1);
    }
    model = nullptr;
    model_stack.stack_used = 0;
    model_stack.lock = 0;
    auto *character = new (model_stack.Alloc(static_cast<int>((sizeof(CActionChara) + 15) / 16 + 2))) CActionChara;
    model_assets::DeleteCharacterTextures(*character, 0, CHARA_IMAGE_MAX - 1);
    character->Initialize(nullptr);
    model_assets::CharacterLoadOptions options{.model_memory = &model_stack, .motion_memory = &model_stack, .image_memory = &model_stack, .textures = &mgTexManager, .parent = nullptr, .texture_block = block};
    std::string                        error;
    if (!model_assets::LoadCharacter(*character, *path, "info", options, error)) {
        model_assets::DeleteCharacterTextures(*character, 0, CHARA_IMAGE_MAX - 1);
        model_stack.stack_used = 0;
        model_stack.lock = 0;
        std::println(stderr, "repair model: {}", error);
        return;
    }
    model = character;
    model->SetScale(0.4f, 0.4f, 0.4f);
    model->SetPosition(position);
    model->SetMotion(const_cast<char *>("\x94\xad\x93\xae"), 0, 1);
    model->SetFadeFlag(1);
    model->Show(0, 1);
    auto *frame = model->CObjectFrame::frame;
    if (frame && frame->attr) {
        frame->attr->z_test = MG_DEPTH_TEST_ALWAYS;
        frame->SetAttrParam(*frame->attr, 1, MG_FRAME_ATTR_Z_TEST);
    }
    model->Show(1, 1);
    model_counter = 0;
}
