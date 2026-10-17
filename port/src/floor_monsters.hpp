#pragma once

#include <functional>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace config_catalog {
struct Document;
}

class CMenuTreeMap;

// The floor information's monster page: Triangle on a floor's information (after its Georama materials, when it
// lists them) shows the monsters the floor's placement list puts down, how many of each, their drop chances and
// which kind carries the gate key. Names come from the disc's message files in the current language.
namespace floor_monsters {

// key_arg_no of the tree map while the monster page is open; retail's step has no keys for it.
constexpr short kScreenMonsters = 3;

// One kind of monster from a floor's placement list (dungeon/cfg_file/mos_place<n>.cfg), in list order.
struct Species {
    int  id = -1;     // BASE_MONSTER_TBL::id
    int  count = 0;   // entries AutoSetMonster places
    bool key = false; // the list's first entry, which AutoSetMonster gives the floor's gate key
};

// The kinds of monster that floor's FLS block lists, as retail's FLS, FL and FLE tags read them. Live monsters past
// spawn_cap entries are not placed; mimics become treasure boxes whatever their position and never carry the key.
std::vector<Species> FloorSpecies(const config_catalog::Document &document, int floor, int spawn_cap);

// An item a defeated monster drops, with its chance in percent.
struct Drop {
    int item = 0;
    int percent = 0;
};

// _SET_DEAD_START's drops for a monster's three slots: nothing without reward money; one roll of 100 whose
// multiples of 6 drop slot 0, or slot 1 below 20 (13% and 4%, or 17% for a lone slot); slot 2 on its own 25% roll,
// certain while Borneo is with the player (third_certain).
std::vector<Drop> DropChances(std::span<const short, 3> slots, int reward_money, bool third_certain);

// "Name x6" and "Item 13%" in the game's font encoding.
std::string CountText(std::string_view name, int count);
std::string DropText(std::string_view item, int percent);

// What one kind of monster shows: its name with the count, the gate key's name if it carries it, its drops.
struct Entry {
    std::string              name;
    std::string              key;
    std::vector<std::string> drops;
};

// A piece of text at x (from the list's left edge) on a row of a page; key is the gate key's name.
struct Text {
    std::string text;
    int         x = 0;
    int         row = 0;
    bool        key = false;
};

using Page = std::vector<Text>;

// Each entry takes a row for its name, with the key's name against the right edge, then its drops flowed from
// indent across rows of the given width. A page holds rows rows; an entry is not split across pages.
std::vector<Page> Layout(std::span<const Entry> entries, int width, int indent, int gap, int rows,
                         const std::function<int(const std::string &)> &measure);

// The rows a page uses.
int PageRows(const Page &page);

// What the tree map's keys do to the monster page this frame.
enum class Action {
    kNone,
    kOpen,     // from the floor's information (no Georama materials), or the materials list's last page
    kNextPage, // Triangle with another page of monsters after this one
    kClose,    // Triangle on the last page, or Cancel: back to the floor's information
};

// The tree map's state that decides it.
struct View {
    short key_arg_no = 0;          // CBaseMenuClass::key_arg_no
    bool  info_view = false;       // dngfloor_infoview
    bool  asking = false;          // DngAskMessageDrawFlag set
    int   materials = 0;           // GeoramaMateriaNum
    int   materials_page = 0;      // GeoramaMateriaInfoDrawPage
    bool  materials_drawn = false; // GeoramaMateriaInfoDrawFlag
    bool  has_monsters = false;
    int   page = 0;
    int   pages = 1;
};

Action Decide(const View &view, int push_button);

// The materials list shows its last page: retail's Triangle there goes back to the information.
bool LastMaterialsPage(const View &view);

// The prompt "Triangle: See monster info" shows: under the floor's information when it lists no materials (retail's
// prompt then has no Triangle line), and under the materials list's last page.
bool HintShown(const View &view);

// The floor map's mouse: a left click on the hint as last drawn opens the page, as the hint's Triangle does.
bool ClickHint();

// What the list changes in retail's floor information.
struct RetailInfo {
    short key_arg_no = 0;    // CBaseMenuClass::key_arg_no
    bool  info_view = false; // dngfloor_infoview
    int   draw_alpha = 0;    // DngInfoDrawAlpha
    int   prompt_y = 0;      // y of the first line of retail's prompt (MenuDCMsg[3])
};

// What the list has changed in the information that is open.
struct Changes {
    bool prompt_moved = false;
    int  prompt_y = 0; // the prompt's own y
};

// Moves retail's first prompt up a row for the hint, keeping its own y.
void MovePrompt(RetailInfo &info, Changes &changed, int screen_height);
// Puts back what the list changed, as when the setting is turned off: an open list goes back to retail's
// information, and the prompt to its own y.
void Restore(RetailInfo &info, Changes &changed);

// The tree map step's seam: Before reads the keys before retail's step, After applies the action once it has run.
Action BeforeStep(CMenuTreeMap &menu);
void   AfterStep(CMenuTreeMap &menu, Action action);
// Draws the monster page and the Triangle prompt that leads to it, after retail's draw.
void Draw(CMenuTreeMap &menu);

} // namespace floor_monsters
