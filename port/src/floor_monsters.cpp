#include "common.h"

#include <algorithm>
#include <array>
#include <format>
#include <memory>
#include <string>
#include <utility>
#include <vector>

#include "dng_event.hpp"
#include "dngmenu.hpp"
#include "floor_monsters.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "object/dun/floor_monster_ids.hpp"
#include "platform/config.hpp"
#include "render/renderer.hpp"
#include "snd_mngr.hpp"
#include "stubs/dngmenu.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

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
// Distances from the bottom of the screen of the prompt's row and of retail's first prompt line once moved up.
constexpr int kHintBottom = 0x2C;
constexpr int kPromptBottom = 0x46;

// Retail's dngboardbrdtbl and dngboardbrdtbl_2 (dngmenu.cpp): the board's top and middle, and its bottom edge.
// Menu3DivideTextureDraw reads three rows from each pointer it is given.
short board_pieces[6][4] = {
    {0,  0, 24, 70},
    {24, 0, 8,  70},
    {32, 0, 24, 70},
    {58, 2, 24, 4 },
    {82, 2, 8,  4 },
    {90, 2, 24, 4 },
};
short board_bottom[3][4] = {
    {58, 22, 24, 36},
    {82, 22, 8,  36},
    {90, 22, 24, 36},
};

// The prompt's message, the first of a one-message buffer: "{Triangle}: {inserted message}", as the floor
// information's prompts set it out. The inserted message is the Monster Notes item's command, "See monster info".
constexpr int        kHintMessage = 1;
constexpr int        kGaijiTriangle = MES_CODE_GAIJI + 7;
std::array<short, 9> hint_table = {1,
                                   0,
                                   kHintMessage,
                                   2,
                                   static_cast<short>(kGaijiTriangle),
                                   ':' - 0x20,
                                   static_cast<short>(MES_CODE_SPACE),
                                   static_cast<short>(MES_CODE_ITEM_FIRST),
                                   static_cast<short>(MES_CODE_END)};
// The party member _SET_DEAD_START makes the third drop slot certain with (GetNowNPC() == 2).
constexpr int kBorneo = 2;

// The floor the page last laid out, and its pages.
struct Floor {
    int                  dungeon = -1;
    int                  floor = -1;
    int                  language = -1;
    bool                 borneo = false;
    std::vector<Species> species;
    std::vector<Page>    pages;
    int                  rows = 0;
};

Floor current;
int   page = 0;
bool  play_open_se = false;
// The prompt's message, and the frame it was last drawn on.
std::unique_ptr<CDC2Mes> hint;
int                      hint_frame = -2;
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

std::string ItemName(int item) {
    const char *name = item > 0 ? GetItemMessage(item) : nullptr;
    return name != nullptr ? name : "";
}

const Floor &Refresh(const CMenuTreeMap &menu) {
    const int dungeon = menu.dng_no;
    const int floor = menu.select_glid != nullptr ? menu.select_glid->room.floor_id : -1;
    // The drops shown follow the party member with the player now, as the death handler reads it.
    const bool borneo = GetBattleCharaInfo()->GetNowNPC() == kBorneo;
    if (current.dungeon == dungeon && current.floor == floor && current.language == LanguageCode &&
        current.borneo == borneo) {
        return current;
    }
    current = Floor{.dungeon = dungeon, .floor = floor, .language = LanguageCode, .borneo = borneo};
    if (floor < 0) {
        return current;
    }
    current.species = FloorSpecies(PortFloorMonsterIds(dungeon, floor), MONSTER_ACTIVE_MAX);
    const std::string  key = ItemName(GetGateKeyIndex(dungeon, floor));
    std::vector<Entry> entries;
    for (const Species &species : current.species) {
        const BASE_MONSTER_TBL *table = GetMonsterTable(species.id);
        if (table == nullptr) {
            continue;
        }
        Entry entry{.name = CountText(table->name, species.count), .key = species.key ? key : "", .drops = {}};
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

View ViewOf(const CMenuTreeMap &menu) {
    // The map screen moves between floors without reading their lists; turned off, the page only closes.
    const bool has_monsters = ConfigGet().floor_info_monsters && menu.key_arg_no != DNG_TREE_MAP_SCREEN_MAP &&
                              !Refresh(menu).pages.empty();
    return {.key_arg_no = menu.key_arg_no,
            .info_view = dngfloor_infoview != 0,
            .asking = DngAskMessageDrawFlag != DNG_TREE_MAP_ASK_NONE,
            .materials = GeoramaMateriaNum,
            .materials_page = GeoramaMateriaInfoDrawPage,
            .materials_drawn = GeoramaMateriaInfoDrawFlag != 0,
            .has_monsters = has_monsters,
            .page = page,
            .pages = static_cast<int>(current.pages.size())};
}

// The prompt's left column: retail's for the materials prompt in Italian and Spanish, 0x46 otherwise.
int PromptX() {
    return LanguageCode == LANG_ITALIAN || LanguageCode == LANG_SPANISH ? 0x2E : 0x46;
}

void DrawHint(int x, int y) {
    if (!hint) {
        hint = std::make_unique<CDC2Mes>();
        hint->Init();
        hint->MsgPreset(MENU_SCRIPT_MES_NO_WIN);
    }
    std::array<int, 1> label = {ITEM_MENU_COMMAND_MSG_BASE + ITEM_MENU_COMMAND_OPEN_MONSTER_BOOK};
    CDC2Mes           &mes = *hint;
    mes.texture_block = MenuArg.mes_tex_block;
    mes.SetMessData(GetSystemMesBuffer(), dc2::text::MessageTable::Parse(std::as_bytes(std::span(hint_table))));
    mes.SetAbsPos(-1);
    mes.cursor_on = false;
    mes.window_mode = MES_WIN_NONE;
    mes.fuchi = FUCHI_OUTLINE_THICK;
    mes.font_w = LanguageCode > LANG_JAPANESE ? 17 : 15;
    mes.fade_speed = 1.0f;
    mes.fade = 1.0f;
    mes.select_top = -1;
    mes.SetMsgCursor(-1);
    mes.SetMsgItemNo(label.data(), static_cast<int>(label.size()));
    mes.MakeMsg(kHintMessage);
    mes.StepMsg();
    mes.SetMovePosGyou(0, x, y);
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, static_cast<sceVif1Packet *>(nullptr));
    mes.StepMsg();
    mes.DrawMsg();
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
    if (board == nullptr || floor.pages.empty() || menu.select_glid == nullptr) {
        return;
    }
    const int    left = (mgScreenWidth - kBoardWidth) >> 1;
    const int    top = kBoardTop;
    const int    height = std::max(kMinHeight, kListY + floor.rows * kRowHeight + kFoot);
    mgCDrawPrim *prim = GetMenuPrim();
    mgTexManager.ReloadTexture(board->block, static_cast<sceVif1Packet *>(nullptr));
    DrawMenuFillBox(static_cast<float>(left + 6), static_cast<float>(top + 6), static_cast<float>(kBoardWidth - 8),
                    static_cast<float>(height - 8), kFill, 0xC, 0xC, 0xC);
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(board);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top, kBoardWidth, kBoardHead), board_pieces[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top + kBoardHead, kBoardWidth, height - kBoardHead - board_pieces[3][3]),
                           board_pieces[3], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top + height - board_bottom[0][3], kBoardWidth, board_bottom[0][3]),
                           board_bottom[0], 1);
    PrimQuad(prim, static_cast<float>((mgScreenWidth >> 1) - (Floor_Info.right >> 1)) - 1.0f,
             static_cast<float>(top) + 10.0f, Floor_Info);
    prim->End();

    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, static_cast<sceVif1Packet *>(nullptr));
    if (menu.select_glid->room.title != nullptr) {
        CMenuFont title;
        int       w = 0;
        int       h = 0;
        title.SetStr(menu.select_glid->room.title);
        title.CalcDrawWH(title.str, &w, &h);
        title.SetPos((mgScreenWidth - w) >> 1, top + kTitleY);
        title.DrawDirect(title.str, title.pos_x, title.pos_y);
    }

    const auto shown = static_cast<std::size_t>(std::clamp(page, 0, static_cast<int>(floor.pages.size()) - 1));
    const int  list_x = left + kMargin;
    const int  list_y = top + kListY;
    CMenuFont  font;
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
        CMenuFont counter;
        PutText(counter, std::format("{}/{}", shown + 1, floor.pages.size()), left + 0x186, top + height - kFoot);
    }
}

RetailInfo ReadInfo(const CMenuTreeMap &menu) {
    return {.key_arg_no = menu.key_arg_no,
            .info_view = dngfloor_infoview != 0,
            .draw_alpha = DngInfoDrawAlpha,
            .prompt_y = MenuDCMsg[3] != nullptr ? MenuDCMsg[3]->line_pos[0][1] : 0};
}

void WriteInfo(CMenuTreeMap &menu, const RetailInfo &info) {
    menu.key_arg_no = info.key_arg_no;
    dngfloor_infoview = info.info_view;
    DngInfoDrawAlpha = info.draw_alpha;
    if (MenuDCMsg[3] != nullptr && MenuDCMsg[3]->line_pos[0][1] != info.prompt_y) {
        MenuDCMsg[3]->SetMovePosGyou(0, MenuDCMsg[3]->line_pos[0][0], info.prompt_y);
    }
}

// Turned off: the screen goes back to retail's, as a run with the setting off shows it, and the hint is gone.
void TurnedOff(CMenuTreeMap &menu) {
    hint_frame = -2;
    page = 0;
    if (menu.key_arg_no != kScreenMonsters && !changes.prompt_moved) {
        return;
    }
    RetailInfo info = ReadInfo(menu);
    Restore(info, changes);
    WriteInfo(menu, info);
}

} // namespace

std::vector<Species> FloorSpecies(std::span<const int> ids, int spawn_cap) {
    std::vector<Species> species;
    for (std::size_t i = 0; i < ids.size(); ++i) {
        const int  id = ids[i];
        const bool mimic = id >= MONSTER_ID_MIMIC_FIRST && id <= MONSTER_ID_MIMIC_LAST;
        if (!mimic && std::cmp_greater_equal(i, spawn_cap)) {
            continue;
        }
        auto found = std::ranges::find(species, id, &Species::id);
        if (found == species.end()) {
            found = species.insert(species.end(), {.id = id, .count = 0, .key = false});
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
        drops.push_back({.item = slots[0], .percent = 13});
        drops.push_back({.item = slots[1], .percent = 4});
    } else if (slots[0] > 0 || slots[1] > 0) {
        drops.push_back({.item = slots[0] > 0 ? slots[0] : slots[1], .percent = 17});
    }
    if (slots[2] > 0) {
        drops.push_back({.item = slots[2], .percent = third_certain ? 100 : 25});
    }
    return drops;
}

std::string CountText(std::string_view name, int count) {
    return std::format("{} x{}", name, count);
}

std::string DropText(std::string_view item, int percent) {
    return std::format("{} {}%", item, percent);
}

std::vector<Page> Layout(std::span<const Entry> entries, int width, int indent, int gap, int rows,
                         const std::function<int(const std::string &)> &measure) {
    std::vector<Page> pages;
    Page              laid;
    int               used = 0;
    for (const Entry &entry : entries) {
        std::vector<Text> block{
            {.text = entry.name, .x = 0, .row = 0, .key = false}
        };
        if (!entry.key.empty()) {
            block.push_back({.text = entry.key, .x = std::max(0, width - measure(entry.key)), .row = 0, .key = true});
        }
        int row = 0;
        int x = width;
        for (const std::string &drop : entry.drops) {
            const int w = measure(drop);
            if (x > indent && x + w > width) {
                ++row;
                x = indent;
            }
            block.push_back({.text = drop, .x = x, .row = row, .key = false});
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

int PageRows(const Page &page) {
    int rows = 0;
    for (const Text &text : page) {
        rows = std::max(rows, text.row + 1);
    }
    return rows;
}

bool LastMaterialsPage(const View &view) {
    return view.materials <= DNG_TREE_MAP_MATERIA_PAGE || view.materials_page != 0;
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

Action Decide(const View &view, int push_button) {
    const bool triangle = (push_button & MENU_PUSH_BUTTON_TRIANGLE) != 0;
    const bool cancel = (push_button & MENU_PUSH_BUTTON_CANCEL) != 0;
    switch (view.key_arg_no) {
        case DNG_TREE_MAP_SCREEN_FLOOR:
            if (triangle && view.info_view && view.asking && view.materials <= 0 && view.has_monsters) {
                return Action::Open;
            }
            break;
        case DNG_TREE_MAP_SCREEN_MATERIALS:
            if (triangle && view.has_monsters && LastMaterialsPage(view)) {
                return Action::Open;
            }
            break;
        case kScreenMonsters:
            if (triangle && view.page + 1 < view.pages) {
                return Action::NextPage;
            }
            if (triangle || cancel) {
                return Action::Close;
            }
            break;
        default:
            break;
    }
    return Action::None;
}

const ClsMes *DrawnHint() {
    return hint && hint_frame >= mgPortFrameCount() - 1 ? hint.get() : nullptr;
}

void MovePrompt(RetailInfo &info, Changes &changed, int screen_height) {
    if (!changed.prompt_moved) {
        changed.prompt_moved = true;
        changed.prompt_y = info.prompt_y;
    }
    info.prompt_y = screen_height - kPromptBottom;
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

Action BeforeStep(CMenuTreeMap &menu) {
    if (!ConfigGet().floor_info_monsters) {
        TurnedOff(menu);
        return Action::None;
    }
    if (menu.mode != MENU_ASK_MODE_NONE || !MenuCommonInfo->key_enable || menu.select_glid == nullptr) {
        return Action::None;
    }
    const Action action = Decide(ViewOf(menu), MenuCheckPushButton());
    play_open_se = action == Action::Open && menu.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR;
    return action;
}

void AfterStep(CMenuTreeMap &menu, Action action) {
    switch (action) {
        case Action::None:
            break;
        case Action::Open:
            // Retail's step has left the information open; Triangle on the materials list has just gone back to it.
            if (menu.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR && dngfloor_infoview) {
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
        case Action::NextPage:
            ++page;
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
        case Action::Close:
            DngInfoDrawAlpha = 128;
            menu.key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
            dngfloor_infoview = true;
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
    }
    if (menu.key_arg_no == DNG_TREE_MAP_SCREEN_MAP) {
        // Retail sets the prompts out afresh when it next opens a floor's information.
        changes.prompt_moved = false;
    }
    // Without materials retail sets out its two prompts on one row; the hint takes the row below, as Triangle's
    // line does in the materials prompt, so the first prompt moves up to where that prompt has it.
    if (ConfigGet().floor_info_monsters && menu.select_glid != nullptr && menu.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR &&
        MenuDCMsg[3] != nullptr && HintShown(ViewOf(menu))) {
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
    if (((menu.mode & 2) && menu.draw_hidden == 1) || menu.select_glid == nullptr) {
        return;
    }
    if (menu.key_arg_no == kScreenMonsters) {
        DrawPage(menu);
        return;
    }
    if (!HintShown(ViewOf(menu))) {
        return;
    }
    const bool on_information = menu.key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR && MenuDCMsg[3] != nullptr;
    DrawHint(on_information ? MenuDCMsg[3]->line_pos[0][0] : PromptX(), mgScreenHeight - kHintBottom);
}

} // namespace floor_monsters
