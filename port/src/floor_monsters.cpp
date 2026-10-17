#include "common.h"

#include <algorithm>
#include <cstdio>
#include <memory>
#include <optional>
#include <variant>

#include "dataread_port.hpp"
#include "dng_event.hpp"
#include "dngmenu.hpp"
#include "floor_monsters.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "monster.hpp"
#include "platform/config.hpp"
#include "platform/config_catalog.hpp"
#include "snd_mngr.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

extern u8    dngfloor_infoview asm("MenuMouse_FloorInfoView");
extern s8    DngAskMessageDrawFlag asm("MenuMouse_FloorAsk");
extern int   DngInfoDrawAlpha asm("MenuMouse_FloorDrawAlpha");
extern u8    GeoramaMateriaInfoDrawFlag asm("MenuMouse_FloorMateriaShown");
extern s8    GeoramaMateriaInfoDrawPage asm("MenuMouse_FloorMateriaPage");
extern short GeoramaMateriaNum asm("MenuMouse_FloorMateriaNum");

namespace floor_monsters {
namespace {

// The materials list's board (DrawGeoramaMateria): 430 wide at y 94, its top 0x46 high, the floor's title at 0x26.
constexpr int kBoardWidth = 0x1AE;
constexpr int kBoardTop = 94;
constexpr int kBoardHead = 0x46;
constexpr int kTitleY = 0x26;
constexpr int kListY = 0x47;
constexpr int kMinHeight = 0x118;
// Opaque, unlike the materials list's 0x59, so the map's labels do not show through the smaller text.
constexpr int kFill = 0x80;
// The list sits 20 in from the board's sides; drops are indented under their monster's name.
constexpr int kMargin = 20;
constexpr int kIndent = 16;
constexpr int kGap = 14;
constexpr int kRowHeight = 18;
constexpr int kRows = 12;
// Room below the last row for the page number, as the materials list leaves it.
constexpr int kFoot = 0x118 - 0xEF;
// A slightly smaller menu font, so a monster's three drops usually fit one row.
constexpr int kFontW = 14;
constexpr int kFontH = 18;

// Retail's dngboardbrdtbl and dngboardbrdtbl_2 (dngmenu.cpp): the board's top and middle, and its bottom edge.
short kBoardPieces[6][4] = {
    {0,  0, 24, 70},
    {24, 0, 8,  70},
    {32, 0, 24, 70},
    {58, 2, 24, 4 },
    {82, 2, 8,  4 },
    {90, 2, 24, 4 },
};
short kBoardBottom[3][4] = {
    {58, 22, 24, 36},
    {82, 22, 8,  36},
    {90, 22, 24, 36},
};

// "{FD07}: {FBFE}": Triangle, then the first inserted system message, as the floor information's prompts set it out.
// The inserted message is the Monster Notes item's command, "See monster info" (system_<language>.mes).
constexpr int kHintMessage = 1;
const u16     kHintTable[] = {1, 0, kHintMessage, 2, 0xFD07, ':' - 0x20, 0xFF02, 0xFBFE, 0xFF01};
// The party member _SET_DEAD_START makes the third drop slot certain with (GetNowNPC() == 2).
constexpr int kBorneo = 2;

// The floor the page last laid out, and its pages.
struct Floor {
    int                  dungeon = -1;
    int                  floor = -1;
    int                  language = -1;
    std::vector<Species> species;
    std::vector<Page>    pages;
    int                  rows = 0;
    bool                 borneo = false;
};

Floor current;
int   page = 0;
bool  play_open_se = false;
// The hint as drawn last, for the floor map's mouse: a click on it is the hint's Triangle.
MenuMouseRect hint_rect;
int           hint_frame = -2;
bool          hint_clicked = false;
// What the list has changed in the information that is open, to put back when the setting is turned off.
Changes changes;

void SetFont(CMenuFont &font) {
    font.SetDrawSize(kFontW, kFontH);
    font.SetClearance(kFontW, kFontH);
}

int Measure(const std::string &text) {
    CMenuFont font;
    SetFont(font);
    std::string copy = text;
    int         w = 0;
    int         h = 0;
    font.CalcDrawWH(copy.data(), &w, &h);
    return w;
}

std::vector<Species> LoadSpecies(int dungeon, int floor) {
    char name[0x40];
    std::snprintf(name, sizeof name, "dungeon/cfg_file/mos_place%d.cfg.json", dungeon);
    std::string error;
    const auto  document = config_catalog::Find(DataReadAssetPath(name).value_or(name), error);
    if (!document) {
        std::fprintf(stderr, "floor monsters: %s\n", error.c_str());
        return {};
    }
    return FloorSpecies(*document, floor, MONSTER_ACTIVE_MAX);
}

std::string ItemName(int item) {
    const char *name = item > 0 ? GetItemMessage(item) : NULL;
    return name ? name : "";
}

const Floor &Refresh(const CMenuTreeMap &menu) {
    const int dungeon = menu.dng_no;
    const int floor = menu.select_glid ? menu.select_glid->room.floor_id : -1;
    // The drops shown follow the party member with the player now, as the death handler reads it.
    const bool borneo = GetBattleCharaInfo()->GetNowNPC() == kBorneo;
    if (current.dungeon == dungeon && current.floor == floor && current.language == LanguageCode &&
        current.borneo == borneo) {
        return current;
    }
    current = Floor{dungeon, floor, LanguageCode};
    current.borneo = borneo;
    if (floor < 0) {
        return current;
    }
    current.species = LoadSpecies(dungeon, floor);
    const std::string  key = ItemName(GetGateKeyIndex(dungeon, floor));
    std::vector<Entry> entries;
    for (const Species &species : current.species) {
        const BASE_MONSTER_TBL *table = GetMonsterTable(species.id);
        if (table == NULL) {
            continue;
        }
        Entry entry{CountText(table->name, species.count), species.key ? key : "", {}};
        for (const Drop &drop : DropChances(table->drop_item, table->reward_money, borneo)) {
            const std::string item = ItemName(drop.item);
            if (!item.empty()) {
                entry.drops.push_back(DropText(item, drop.percent));
            }
        }
        entries.push_back(std::move(entry));
    }
    current.pages = Layout(entries, kBoardWidth - 2 * kMargin, kIndent, kGap, kRows, Measure);
    for (const Page &laid : current.pages) {
        current.rows = std::max(current.rows, PageRows(laid));
    }
    return current;
}

bool HasMonsters(const CMenuTreeMap &menu) {
    return !Refresh(menu).pages.empty();
}

View ViewOf(const CMenuTreeMap &menu) {
    View view;
    view.key_arg_no = menu.key_arg_no;
    view.info_view = dngfloor_infoview != 0;
    view.asking = DngAskMessageDrawFlag != DNG_TREE_MAP_ASK_NONE;
    view.materials = GeoramaMateriaNum;
    view.materials_page = GeoramaMateriaInfoDrawPage;
    view.materials_drawn = GeoramaMateriaInfoDrawFlag != 0;
    // The map screen moves between floors without reading their lists; turned off, the page only closes.
    view.has_monsters =
        ConfigGet().floor_info_monsters && menu.key_arg_no != DNG_TREE_MAP_SCREEN_MAP && HasMonsters(menu);
    view.page = page;
    view.pages = static_cast<int>(current.pages.size());
    return view;
}

// The prompt's left column: retail's for the materials prompt in Italian and Spanish, 0x46 otherwise.
int PromptX() {
    return LanguageCode == LANG_ITALIAN || LanguageCode == LANG_SPANISH ? 0x2E : 0x46;
}

void DrawHint(int x, int y) {
    static std::unique_ptr<CDC2Mes> hint;
    if (!hint) {
        hint = std::make_unique<CDC2Mes>();
        hint->Init();
        hint->MsgPreset(MENU_SCRIPT_MES_NO_WIN);
    }
    int      label[1] = {ITEM_MENU_COMMAND_MSG_BASE + ITEM_MENU_COMMAND_OPEN_MONSTER_BOOK};
    CDC2Mes &mes = *hint;
    mes.texture_block = MenuArg.mes_tex_block;
    mes.SetMessData(GetSystemMesBuffer(), (short *) kHintTable);
    mes.SetAbsPos(-1);
    mes.cursor_on = false;
    mes.window_mode = MES_WIN_NONE;
    mes.fuchi = FUCHI_OUTLINE_THICK;
    mes.font_w = LanguageCode > LANG_JAPANESE ? 17 : 15;
    mes.fade_speed = 1.0f;
    mes.fade = 1.0f;
    mes.select_top = -1;
    mes.SetMsgCursor(-1);
    mes.SetMsgItemNo(label, 1);
    mes.MakeMsg(kHintMessage);
    mes.StepMsg();
    mes.SetMovePosGyou(0, x, y);
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
    mes.StepMsg();
    mes.DrawMsg();
    // As the floor map's mouse measures its labels: the line where DrawFont puts it, a little padded.
    hint_rect = {float(mes.line_pos[0][0] + mes.draw_off_x - 2), float(mes.line_pos[0][1] + mes.draw_off_y - 6),
                 float(mes.line_w[0] + 4), float(mes.font_h + 12)};
    hint_frame = mgPortFrameCount();
}

void PutText(CMenuFont &font, const std::string &text, int x, int y) {
    std::string copy = text;
    font.SetStr(copy.data());
    font.SetPos(x, y);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
}

void DrawPage(const CMenuTreeMap &menu) {
    const Floor &floor = Refresh(menu);
    char         board_name[] = "dngfibrd";
    mgCTexture  *board = mgTexManager.GetTexture(board_name, -1);
    if (board == NULL || floor.pages.empty() || menu.select_glid == NULL) {
        return;
    }
    const int    left = (mgScreenWidth - kBoardWidth) >> 1;
    const int    top = kBoardTop;
    const int    height = std::max(kMinHeight, kListY + floor.rows * kRowHeight + kFoot);
    mgCDrawPrim *prim = GetMenuPrim();
    mgTexManager.ReloadTexture(board->block, (sceVif1Packet *) NULL);
    DrawMenuFillBox((float) (left + 6), (float) (top + 6), (float) (kBoardWidth - 8), (float) (height - 8), kFill, 0xC,
                    0xC, 0xC);
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(board);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top, kBoardWidth, kBoardHead), kBoardPieces[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top + kBoardHead, kBoardWidth, height - kBoardHead - kBoardPieces[3][3]),
                           kBoardPieces[3], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top + height - kBoardBottom[0][3], kBoardWidth, kBoardBottom[0][3]),
                           kBoardBottom[0], 1);
    PrimQuad(prim, (float) ((mgScreenWidth >> 1) - (Floor_Info.right >> 1)) - 1.0f, (float) top + 10.0f, Floor_Info);
    prim->End();

    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
    CMenuFont title;
    if (menu.select_glid->room.title != NULL) {
        int w = 0;
        int h = 0;
        title.SetStr(menu.select_glid->room.title);
        title.CalcDrawWH(title.str, &w, &h);
        title.SetPos((mgScreenWidth - w) >> 1, top + kTitleY);
        title.DrawDirect(title.str, title.pos_x, title.pos_y);
    }

    const int shown = std::clamp(page, 0, static_cast<int>(floor.pages.size()) - 1);
    const int list_x = left + kMargin;
    const int list_y = top + kListY;
    CMenuFont font;
    SetFont(font);
    for (const Text &text : floor.pages[shown]) {
        if (text.key) {
            font.SetColor(0x80, 0x68, 0x28, 0x80);
        } else if (text.x == 0) {
            font.SetColor(0x80, 0x80, 0x80, 0x80);
        } else {
            font.SetColor(0x80686A6BU);
        }
        PutText(font, text.text, list_x + text.x, list_y + text.row * kRowHeight);
    }
    if (floor.pages.size() > 1) {
        char number[32];
        std::snprintf(number, sizeof number, "%d/%d", shown + 1, static_cast<int>(floor.pages.size()));
        CMenuFont counter;
        PutText(counter, number, left + 0x186, top + height - kFoot);
    }
}

} // namespace

std::vector<Species> FloorSpecies(const config_catalog::Document &document, int floor, int spawn_cap) {
    std::vector<int> ids;
    int              listing = -1;
    for (const auto &command : document.commands) {
        std::vector<int> values;
        for (const auto &argument : command.arguments) {
            const int *value = std::get_if<int>(&argument.value);
            values.push_back(value ? *value : -1);
        }
        if (command.name == "FLS" && !values.empty()) {
            listing = values[0];
            if (listing == floor) {
                ids.clear();
            }
        } else if (command.name == "FL" && listing == floor) {
            for (std::size_t i = 0; i + 1 < values.size(); i += 2) {
                ids.push_back(values[i]);
            }
        } else if (command.name == "FLE") {
            listing = -1;
        }
    }
    std::vector<Species> species;
    for (std::size_t i = 0; i < ids.size(); ++i) {
        const int  id = ids[i];
        const bool mimic = id >= MONSTER_ID_MIMIC_FIRST && id <= MONSTER_ID_MIMIC_LAST;
        if (!mimic && static_cast<int>(i) >= spawn_cap) {
            continue;
        }
        auto found = std::ranges::find(species, id, &Species::id);
        if (found == species.end()) {
            species.push_back({id, 0, false});
            found = species.end() - 1;
        }
        ++found->count;
        if (i == 0 && !mimic) {
            found->key = true;
        }
    }
    return species;
}

std::vector<Drop> DropChances(std::span<const short, 3> slots, int reward_money, bool third_certain) {
    std::vector<Drop> drops;
    if (reward_money <= 0) {
        return drops;
    }
    if (slots[0] > 0 && slots[1] > 0) {
        drops.push_back({slots[0], 13});
        drops.push_back({slots[1], 4});
    } else if (slots[0] > 0 || slots[1] > 0) {
        drops.push_back({slots[0] > 0 ? slots[0] : slots[1], 17});
    }
    if (slots[2] > 0) {
        drops.push_back({slots[2], third_certain ? 100 : 25});
    }
    return drops;
}

std::string CountText(std::string_view name, int count) {
    return std::string(name) + " x" + std::to_string(count);
}

std::string DropText(std::string_view item, int percent) {
    return std::string(item) + " " + std::to_string(percent) + "%";
}

std::vector<Page> Layout(std::span<const Entry> entries, int width, int indent, int gap, int rows,
                         const std::function<int(const std::string &)> &measure) {
    std::vector<Page> pages;
    Page              laid;
    int               used = 0;
    for (const Entry &entry : entries) {
        std::vector<Text> block{
            {entry.name, 0, 0, false}
        };
        if (!entry.key.empty()) {
            block.push_back({entry.key, std::max(0, width - measure(entry.key)), 0, true});
        }
        int row = 0;
        int x = width;
        for (const std::string &drop : entry.drops) {
            const int w = measure(drop);
            if (x > indent && x + w > width) {
                ++row;
                x = indent;
            }
            block.push_back({drop, x, row, false});
            x += w + gap;
        }
        const int height = row + 1;
        if (used > 0 && used + height > rows) {
            pages.push_back(std::move(laid));
            laid.clear();
            used = 0;
        }
        for (Text &text : block) {
            text.row += used;
            laid.push_back(std::move(text));
        }
        used += height;
    }
    if (!laid.empty()) {
        pages.push_back(std::move(laid));
    }
    return pages;
}

int PageRows(const Page &laid) {
    int rows = 0;
    for (const Text &text : laid) {
        rows = std::max(rows, text.row + 1);
    }
    return rows;
}

bool HintShown(const View &view) {
    if (!view.has_monsters) {
        return false;
    }
    if (view.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR) {
        // Retail's prompt has no Triangle line without materials; asked from the dungeon menu it shows no prompt.
        return view.info_view && view.asking && view.materials <= 0;
    }
    return view.key_arg_no == DNG_TREE_MAP_SCREEN_MATERIALS && view.materials_drawn && LastMaterialsPage(view);
}

bool LastMaterialsPage(const View &view) {
    return !(view.materials > DNG_TREE_MAP_MATERIA_PAGE && view.materials_page == 0);
}

Action Decide(const View &view, int push_button) {
    const bool triangle = (push_button & MENU_PUSH_BUTTON_TRIANGLE) != 0;
    const bool cancel = (push_button & MENU_PUSH_BUTTON_CANCEL) != 0;
    switch (view.key_arg_no) {
        case DNG_TREE_MAP_SCREEN_FLOOR:
            if (triangle && view.info_view && view.asking && view.materials <= 0 && view.has_monsters) {
                return Action::kOpen;
            }
            break;
        case DNG_TREE_MAP_SCREEN_MATERIALS:
            if (triangle && view.has_monsters && LastMaterialsPage(view)) {
                return Action::kOpen;
            }
            break;
        case kScreenMonsters:
            if (triangle && view.page + 1 < view.pages) {
                return Action::kNextPage;
            }
            if (triangle || cancel) {
                return Action::kClose;
            }
            break;
    }
    return Action::kNone;
}

bool ClickHint() {
    if (hint_frame < mgPortFrameCount() - 1) {
        return false;
    }
    const auto &mouse = MenuMouseTake();
    if (!mouse.pointing || !(mouse.clicked & 1) || !hint_rect.Contains(mouse.x, mouse.y)) {
        return false;
    }
    // Not a list row, so the click is no Cross; AfterStep opens the page as the hint's Triangle would.
    MenuMouseRows({}, 0);
    hint_clicked = true;
    return true;
}

void MovePrompt(RetailInfo &info, Changes &changed, int screen_height) {
    if (!changed.prompt_moved) {
        changed.prompt_moved = true;
        changed.prompt_y = info.prompt_y;
    }
    info.prompt_y = screen_height - 0x46;
}

void Restore(RetailInfo &info, Changes &changed) {
    if (info.key_arg_no == kScreenMonsters) {
        // Where the list leaves to: retail's information, as its own Triangle and Cancel leave the materials list.
        info.key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
        info.info_view = true;
        info.draw_alpha = 128;
    }
    if (changed.prompt_moved) {
        info.prompt_y = changed.prompt_y;
        changed.prompt_moved = false;
    }
}

namespace {

RetailInfo ReadInfo(const CMenuTreeMap &menu) {
    RetailInfo info;
    info.key_arg_no = menu.key_arg_no;
    info.info_view = dngfloor_infoview != 0;
    info.draw_alpha = DngInfoDrawAlpha;
    info.prompt_y = MenuDCMsg[3] != NULL ? MenuDCMsg[3]->line_pos[0][1] : 0;
    return info;
}

void WriteInfo(CMenuTreeMap &menu, const RetailInfo &info) {
    menu.key_arg_no = info.key_arg_no;
    dngfloor_infoview = info.info_view;
    DngInfoDrawAlpha = info.draw_alpha;
    if (MenuDCMsg[3] != NULL && MenuDCMsg[3]->line_pos[0][1] != info.prompt_y) {
        MenuDCMsg[3]->SetMovePosGyou(0, MenuDCMsg[3]->line_pos[0][0], info.prompt_y);
    }
}

// Turned off: the screen goes back to retail's, as a run with the setting off shows it, and the hint is gone.
void TurnedOff(CMenuTreeMap &menu) {
    hint_frame = -2;
    hint_clicked = false;
    page = 0;
    if (menu.key_arg_no != kScreenMonsters && !changes.prompt_moved) {
        return;
    }
    RetailInfo info = ReadInfo(menu);
    Restore(info, changes);
    WriteInfo(menu, info);
}

} // namespace

Action BeforeStep(CMenuTreeMap &menu) {
    if (!ConfigGet().floor_info_monsters) {
        TurnedOff(menu);
        return Action::kNone;
    }
    if (menu.mode != MENU_ASK_MODE_NONE || !MenuCommonInfo->key_enable || menu.select_glid == NULL) {
        return Action::kNone;
    }
    const Action action = Decide(ViewOf(menu), MenuCheckPushButton());
    play_open_se = action == Action::kOpen && menu.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR;
    return action;
}

void AfterStep(CMenuTreeMap &menu, Action action) {
    if (hint_clicked) {
        hint_clicked = false;
        if (action == Action::kNone && menu.select_glid != NULL && HintShown(ViewOf(menu))) {
            action = Action::kOpen;
            play_open_se = true;
        }
    }
    switch (action) {
        case Action::kNone:
            break;
        case Action::kOpen:
            // Retail's step has left the information open (Triangle on the materials list has just gone back to it),
            // or a click on the materials list's hint opens the page from the list itself.
            if ((menu.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR && dngfloor_infoview) ||
                menu.key_arg_no == DNG_TREE_MAP_SCREEN_MATERIALS) {
                dngfloor_infoview = false;
                GeoramaMateriaInfoDrawFlag = false;
                DngInfoDrawAlpha = 0;
                menu.key_arg_no = kScreenMonsters;
                page = 0;
                if (play_open_se) {
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
            }
            break;
        case Action::kNextPage:
            ++page;
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
        case Action::kClose:
            DngInfoDrawAlpha = 128;
            menu.key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
            dngfloor_infoview = true;
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
    }
    // Without materials retail sets out its two prompts on one row; the hint takes the row below, as Triangle's
    // line does in the materials prompt, so the first prompt moves up to where that prompt has it.
    if (menu.key_arg_no == DNG_TREE_MAP_SCREEN_MAP) {
        // Retail sets the prompts out afresh when it next opens a floor's information.
        changes.prompt_moved = false;
    }
    if (ConfigGet().floor_info_monsters && menu.select_glid != NULL && menu.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR &&
        HintShown(ViewOf(menu)) && MenuDCMsg[3] != NULL) {
        RetailInfo info = ReadInfo(menu);
        MovePrompt(info, changes, mgScreenHeight);
        WriteInfo(menu, info);
    }
}

void Draw(CMenuTreeMap &menu) {
    if (!ConfigGet().floor_info_monsters) {
        TurnedOff(menu);
        return;
    }
    if (((menu.mode & 2) && menu.draw_hidden == 1) || menu.select_glid == NULL) {
        return;
    }
    if (menu.key_arg_no == kScreenMonsters) {
        DrawPage(menu);
        return;
    }
    if (!HintShown(ViewOf(menu))) {
        return;
    }
    if (menu.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR && MenuDCMsg[3] != NULL) {
        DrawHint(MenuDCMsg[3]->line_pos[0][0], mgScreenHeight - 0x2C);
    } else {
        DrawHint(PromptX(), mgScreenHeight - 0x2C);
    }
}

} // namespace floor_monsters
