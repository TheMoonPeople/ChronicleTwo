#pragma once

#include <functional>
#include <span>
#include <string>
#include <string_view>
#include <vector>

class ClsMes;
class CMenuTreeMap;

/**
 * The floor information's monster page: Triangle on a floor's information (after its Georama materials, when it
 * lists them) shows the monsters the floor's placement list puts down, how many of each, their drop chances and which
 * kind carries the gate key. Names come from the game's message data in the current language.
 */
namespace floor_monsters {

/** key_arg_no of the tree map while the monster page is open; retail's step has no keys for it. */
constexpr short kScreenMonsters = 3;

/**
 * One kind of monster from a floor's placement list, in list order.
 */
struct Species {
    int  id = -1;     /**< BASE_MONSTER_TBL::id. */
    int  count = 0;   /**< Entries AutoSetMonster places. */
    bool key = false; /**< The list's first entry, which AutoSetMonster gives the floor's gate key. */
};

/**
 * Groups a floor's placement list by kind. Live monsters past spawn_cap entries are not placed; mimics become treasure
 * boxes whatever their position and never carry the key.
 */
std::vector<Species> FloorSpecies(std::span<const int> ids, int spawn_cap);

/**
 * An item a defeated monster drops, with its chance in percent.
 */
struct Drop {
    int item = 0;    /**< Item number. */
    int percent = 0; /**< Chance of the drop. */
};

/**
 * _SET_DEAD_START's drops for a monster's three slots: nothing without reward money; one roll of 100 whose multiples
 * of 6 drop slot 0, or slot 1 below 20 (13% and 4%, or 17% for a lone slot); slot 2 on its own 25% roll, certain
 * while Borneo is with the player (third_certain).
 */
std::vector<Drop> DropChances(std::span<const short, 3> slots, int reward_money, bool third_certain);

/**
 * "Name x6" in the game's font encoding.
 */
std::string CountText(std::string_view name, int count);

/**
 * "Item 13%" in the game's font encoding.
 */
std::string DropText(std::string_view item, int percent);

/**
 * What one kind of monster shows.
 */
struct Entry {
    std::string              name;  /**< Its name with the count. */
    std::string              key;   /**< The gate key's name if it carries it, else empty. */
    std::vector<std::string> drops; /**< Its drops with their chances. */
};

/**
 * A piece of text on a row of a page.
 */
struct Text {
    std::string text;        /**< What is drawn. */
    int         x = 0;       /**< Offset from the list's left edge. */
    int         row = 0;     /**< Row of the page. */
    bool        key = false; /**< The gate key's name. */
};

using Page = std::vector<Text>;

/**
 * Lays out entries: each takes a row for its name, with the key's name against the right edge, then its drops flowed
 * from indent across rows of the given width. A page holds rows rows; an entry is not split across pages.
 */
std::vector<Page> Layout(std::span<const Entry> entries, int width, int indent, int gap, int rows,
                         const std::function<int(const std::string &)> &measure);

/**
 * The rows a page uses.
 */
int PageRows(const Page &page);

/**
 * What the tree map's keys do to the monster page this frame.
 */
enum class Action {
    None,
    Open,     /**< From the floor's information (no Georama materials), or the materials list's last page. */
    NextPage, /**< Triangle with another page of monsters after this one. */
    Close,    /**< Triangle on the last page, or Cancel: back to the floor's information. */
};

/**
 * The tree map's state that decides the page's action.
 */
struct View {
    short key_arg_no = 0;          /**< CBaseMenuClass::key_arg_no. */
    bool  info_view = false;       /**< dngfloor_infoview. */
    bool  asking = false;          /**< DngAskMessageDrawFlag set. */
    int   materials = 0;           /**< GeoramaMateriaNum. */
    int   materials_page = 0;      /**< GeoramaMateriaInfoDrawPage. */
    bool  materials_drawn = false; /**< GeoramaMateriaInfoDrawFlag. */
    bool  has_monsters = false;    /**< The setting is on and the floor lists monsters. */
    int   page = 0;                /**< Monster page shown. */
    int   pages = 1;               /**< Monster pages. */
};

/**
 * The action push_button takes in view.
 */
Action Decide(const View &view, int push_button);

/**
 * Whether the materials list shows its last page, where retail's Triangle goes back to the information.
 */
bool LastMaterialsPage(const View &view);

/**
 * Whether the prompt "Triangle: See monster info" shows: under the floor's information when it lists no materials
 * (retail's prompt then has no Triangle line), and under the materials list's last page.
 */
bool HintShown(const View &view);

/**
 * The Triangle prompt as drawn on the last frame, for the floor map's mouse, or null.
 */
const ClsMes *DrawnHint();

/**
 * What the list changes in retail's floor information.
 */
struct RetailInfo {
    short key_arg_no = 0;    /**< CBaseMenuClass::key_arg_no. */
    bool  info_view = false; /**< dngfloor_infoview. */
    int   draw_alpha = 0;    /**< DngInfoDrawAlpha. */
    int   prompt_y = 0;      /**< y of the first line of retail's prompt (MenuDCMsg[3]). */
};

/**
 * What the list has changed in the information that is open.
 */
struct Changes {
    bool prompt_moved = false; /**< Retail's first prompt line is moved up. */
    int  prompt_y = 0;         /**< That line's own y. */
};

/**
 * Moves retail's first prompt up a row for the hint, keeping its own y.
 */
void MovePrompt(RetailInfo &info, Changes &changed, int screen_height);

/**
 * Puts back what the list changed, as when the setting is turned off: an open list goes back to retail's information,
 * and the prompt to its own y.
 */
void Restore(RetailInfo &info, Changes &changed);

/**
 * The tree map step's seam before retail's step: the keys' action on the page.
 */
Action BeforeStep(CMenuTreeMap &menu);

/**
 * The tree map step's seam after retail's step: applies the action.
 */
void AfterStep(CMenuTreeMap &menu, Action action);

/**
 * Draws the monster page and the Triangle prompt that leads to it, after retail's draw.
 */
void Draw(CMenuTreeMap &menu);

} // namespace floor_monsters
