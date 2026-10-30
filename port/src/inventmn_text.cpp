#include "common.h"

#include <array>
#include <string>
#include <string_view>

#include "font.hpp"
#include "inventmn.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mglib.hpp"
#include "stubs/inventmn.hpp"
#include "text/bounded.hpp"

namespace {

/**
 *
 * Bytes a menu or photo title holds, matching CFont::SetStr and the photo title.
 *
 */
constexpr std::size_t kTitleCapacity = 0x80;

/**
 *
 * Gives the icon an idea name is shown with in the invention memo.
 *
 */
std::string_view MemoPrefix(short neta_id) {
    if (neta_id < INVENT_NETA_ID_SCOOP) {
        return dc2::text::View(gaiji_table_4737[0]);
    }
    if (neta_id < INVENT_NETA_ID_SCOOP_END) {
        return dc2::text::View(gaiji_table_4737[1]);
    }
    return dc2::text::View(gaiji_table_4737[2]);
}

} // namespace

// Retail builds the icon and idea name in 33 bytes, which Spanish idea names overran. The result keeps
// the whole name up to the photo title's 128 bytes.
char *GetPhotoNameCheck(USER_PICTURE_INFO *info) {
    static std::array<char, kTitleCapacity> title;
    const char                             *name = GetPhotoName(info);
    if (name == nullptr) {
        return nullptr;
    }

    std::string text;
    if (info->neta_id > 0) {
        text = dc2::text::View(addstringtable_1722[info->neta_id >= INVENT_NETA_ID_SCOOP ? 1 : 0]);
    }
    text += name;
    dc2::text::Copy(title, text);
    return title.data();
}

// Retail formats each memo row into 32 bytes, which the icon and a Spanish idea name overran; rows are
// formatted to the font's 128-byte limit instead.
void MenuInventNetaMemoDraw(float *origin, int &loaded_tex) {
    if (Tex_Hatsumei == nullptr || origin[0] < -200.0f) {
        return;
    }

    mgRect<int> clip_rect;
    mgRect<int> row_rect;
    mgRect<int> bar_rect;

    const float top = 76.0f + origin[1];
    const int   clip_top = static_cast<int>(top);
    const int   clip_bottom = static_cast<int>(240.0f + top);
    clip_rect.Set(0, clip_top, mgScreenWidth, clip_bottom);
    MenuClipRectCheck(clip_rect);
    SetMenuScissor(clip_rect);
    MenuReloadTexture(loaded_tex, Tex_Hatsumei->block);
    row_rect.Set(0x144, 0x180, 0xBC, 6);
    const float left = 16.0f + origin[0];
    float       row_y = 2.0f + (24.0f + CMenuInventPt->memo_scroll);
    auto       *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_Hatsumei);
    prim->Color(0x80, 0x80, 0x80, 0x80);

    for (int i = 0; i < 512; ++i, row_y += 26.0f) {
        if (row_y < static_cast<float>(clip_top - 0x28)) {
            continue;
        }
        if (static_cast<float>(clip_bottom) < row_y) {
            break;
        }
        PrimQuad(prim, left, row_y, row_rect);
    }

    prim->End();
    ResetMenuScissor();
    bar_rect.Set(0x90, 0x166, 8, 0x1C);
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_Hatsumei);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    PrimQuad(prim, 209.0f + origin[0], CMenuInventPt->memo_bar, bar_rect);
    prim->End();
    SetMenuScissor(clip_rect);
    MenuReloadTexture(loaded_tex, MenuArg.mes_tex_block);

    const int text_x = static_cast<int>(6.0f + left);
    int       text_y = static_cast<int>(4.0f + CMenuInventPt->memo_scroll);

    CMenuFont                        menu_font;
    std::array<char, kTitleCapacity> text{};
    menu_font.SetClearance(0xE, 0x18);

    for (int i = 0; i < pic_name_info_num && i < 512; ++i, text_y += 26) {
        if (text_y < clip_top - 0x28) {
            continue;
        }
        if (clip_bottom < text_y) {
            break;
        }

        if (NetaMemoStr[i] != nullptr) {
            std::string row{MemoPrefix(NetaMemoID[i])};
            row += NetaMemoStr[i];
            dc2::text::Copy(text, row);
            menu_font.SetStr(text.data());
        } else {
            menu_font.SetStr(GetHatena());
        }
        menu_font.SetPos(text_x, text_y);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
    }

    ResetMenuScissor();
}
