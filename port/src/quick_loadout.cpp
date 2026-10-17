#include "common.h"

#include "quick_loadout.hpp"

#include "actionchara.hpp"
#include "actscript.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dng_object.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "item_icon3d.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "maintex.hpp"
#include "menumain.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "mg_texture.hpp"
#include "platform/config.hpp"
#include "platform/paths.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "photo.hpp"
#include "prespr.hpp"
#include "subgame.hpp"
#include "userdata.hpp"
#include "font.hpp"

#include "gfx/gfx.hpp"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <map>
#include <span>
#include <vector>

int PortRetailDngMainKey() asm("DngMain_DngMainKey");

namespace {

constexpr int kSlots = 4;
constexpr int kCharas = 3; // Max, Monica and the Ridepod; the monster form has no equipment.
constexpr int kNameSize = 0x20;

// Slot order is the panel's: Square and Triangle on the top row, Cross and Circle on the bottom one.
constexpr int kSlotButton[kSlots] = {PAD_SQUARE, PAD_TRIANGLE, PAD_CROSS, PAD_CIRCLE};
constexpr int kFaceButtons = PAD_TRIANGLE | PAD_SQUARE | PAD_CROSS | PAD_CIRCLE;

constexpr int kFadeTicks = 6;

// The panel is put together from the dungeon's own system frame texture (TEX_SystenFrame), as the active item board
// is, so it wears the same gold and plum: the EXP gauge's box round it, and the item circles' halves stretched into the
// slots, the title bar and the buttons' discs. Positions are on the status board's 640-wide frame, from the panel's
// top left corner, sliding with the board.
struct Rect {
    int x, y, w, h;
};
constexpr int  kPanelX = 52;   // under the active items' circles
constexpr int  kRidepodX = 42; // the Ridepod's board has none
constexpr int  kPanelOffsetY = 66;
constexpr int  kRidepodOffsetY = 54;
// The two title styles of PC settings: a bar shrunk from the item circles, over the box's top edge, or a plate like
// the EXP gauge's, standing on it, with the box a little lower to make room.
constexpr Rect kBox = {0, 8, 176, 134};
constexpr Rect kTitleBar = {20, -1, 136, 25};
constexpr Rect kPlateBox = {0, 16, 176, 126};
constexpr Rect kTitlePlate = {7, -1, 128, 18};
// Square, Triangle, Cross, Circle.
constexpr Rect kSlotRect[kSlots] = {{11, 26, 76, 50}, {89, 26, 76, 50}, {11, 80, 76, 50}, {89, 80, 76, 50}};
constexpr int  kDiscSize = 24;
constexpr int  kDiscOffset = -3; // the disc over the slot's top left corner
constexpr int  kGlyphSize = 22;

// In the system frame texture: the EXP gauge's box, its gold border 10 across and 9 down to the black inside...
constexpr int kBoxU0 = 288, kBoxUMiddle = 340, kBoxV0 = 154, kBoxVMiddle = 172;
constexpr int kBoxSide = 10, kBoxEdge = 9;
// The top corners come down a little further: the box's top left corner bends until three texels under its top edge.
constexpr int kBoxCorner = 12;
// How far the gold goes: across the sides, down the top, and across each row of the top left corner.
constexpr int kBoxGold = 6, kBoxGoldTop = 5;
constexpr int kBoxCornerGold[kBoxCorner] = {10, 10, 10, 10, 10, 10, 9, 8, 7, 7, 6, 6};
constexpr int kBoxJoinX = 6; // where the top left corner's first row turns into the bar above the box
// The bolts on the top right and bottom left corners.
constexpr int kBoxBolt = 6, kBoxBoltX = 2, kBoxBoltTopU = 375, kBoxBoltTopV = 155, kBoxBoltBottomU = 289,
              kBoxBoltBottomV = 182;
// A black texel in the middle of a black patch, so that stretching it never reaches a neighbour.
constexpr int kBlackU = 134, kBlackV = 204;
// The "EXP" plate above that box: its left and right sides, three texels each, a plain column between them past the
// engraved letters, three rows of top edge, the rows of plate between and the row that runs into the box.
constexpr int kPlateLeftU = 295, kPlateMiddleU = 298, kPlateRightU = 319, kPlateSide = 3;
constexpr int kPlateV0 = 146, kPlateTop = 3, kPlateMiddleV = 149, kPlateMiddle = 5, kPlateBottomV = 154;
// ...and the active item circles, 40 across: the left half of the first, the right half of the last (their other
// halves hold the joints between them).
constexpr int kCircleLeftU = 236, kCircleLeftV = 55, kCircleRightU = 364, kCircleRightV = 96, kCircleHalf = 20;
// The buttons in the font's own picture of them ("gaiji"): Square, Triangle, Cross, Circle.
constexpr int kGlyphUV[kSlots][2] = {{44, 22}, {22, 22}, {66, 22}, {0, 22}};
constexpr int kGlyphTexels = 22;

// The side of each item's picture.
constexpr int kIconSize = 128;

struct Entry {
    int  item_no = 0;
    char name[kNameSize] = {};
};

Entry slots[kCharas][kSlots];
bool  slots_loaded = false;

bool panel_open = false;
int  fade = 0;          // ticks of the panel's fade, 0 (hidden) to kFadeTicks
int  raw_previous = 0;  // the face buttons before this session took any away
int  swallowed = 0;     // buttons taken from the game, until they are let go
int  request_slot = -1;
bool reloading = false;
// The enemy the player was locked on to when a slot reloaded the character, given back once the floor runs again: the
// reload starts the character afresh, which would let go of it in the middle of a combo.
struct {
    bool pending = false;
    s16  target_no = -1;
    s16  lock_on = 0;
} kept_target;

// Each item's picture is a render target of its own, never a texture entered in the game's texture table: two of those
// in one block share GS memory, and the targets behind them with it.
struct Picture {
    gfx::TextureHandle texture = gfx::kNullTexture;
    bool               failed = false;
};
std::map<int, Picture> pictures; // by item number

std::filesystem::path SlotsPath() { return PathsSaveRoot() / "quick_loadout.txt"; }

void LoadSlots() {
    slots_loaded = true;
    std::FILE *file = std::fopen(SlotsPath().string().c_str(), "r");
    if (file == nullptr) {
        return;
    }
    char line[256];
    while (std::fgets(line, sizeof line, file) != nullptr) {
        int  chara = -1, slot = -1, item = 0;
        char hex[kNameSize * 2 + 1] = {};
        if (std::sscanf(line, "%d %d %d %64s", &chara, &slot, &item, hex) < 3 || chara < 0 || chara >= kCharas || slot < 0 ||
            slot >= kSlots) {
            continue;
        }
        Entry &entry = slots[chara][slot];
        entry = {};
        entry.item_no = item;
        for (int i = 0; i < kNameSize && hex[i * 2] != 0 && hex[i * 2 + 1] != 0; i++) {
            unsigned value = 0;
            std::sscanf(hex + i * 2, "%2x", &value);
            entry.name[i] = static_cast<char>(value);
        }
    }
    std::fclose(file);
}

void SaveSlots() {
    std::FILE *file = std::fopen(SlotsPath().string().c_str(), "w");
    if (file == nullptr) {
        std::fprintf(stderr, "quick loadout: cannot write %s\n", SlotsPath().string().c_str());
        return;
    }
    for (int chara = 0; chara < kCharas; chara++) {
        for (int slot = 0; slot < kSlots; slot++) {
            const Entry &entry = slots[chara][slot];
            if (entry.item_no <= 0) {
                continue;
            }
            std::fprintf(file, "%d %d %d ", chara, slot, entry.item_no);
            for (int i = 0; i < kNameSize && entry.name[i] != 0; i++) {
                std::fprintf(file, "%02x", static_cast<unsigned char>(entry.name[i]));
            }
            std::fprintf(file, "\n");
        }
    }
    std::fclose(file);
}

const char *ItemName(const CGameDataUsed *item) {
    return item->used_type == USED_ITEM_TYPE_ROBO_PART ? item->data.robopart.name : item->data.weapon.name;
}

void SetEntry(Entry &entry, const CGameDataUsed *item) {
    entry = {};
    entry.item_no = item->item_no;
    std::memcpy(entry.name, ItemName(item), kNameSize);
    entry.name[kNameSize - 1] = 0;
}

bool Matches(const Entry &entry, const CGameDataUsed *item) {
    return entry.item_no > 0 && item->item_no == entry.item_no && std::strncmp(ItemName(item), entry.name, kNameSize) == 0;
}

// The equipment a row of the active character's panel swaps: top, the melee weapon or the Ridepod's arm; bottom, the
// second weapon or its legs.
CGameDataUsed *RowEquip(int chara, int row) {
    if (chara == USER_CHARA_MAX || chara == USER_CHARA_MONICA) {
        CHARA_DATA *data = DngUserData->GetCharaDataPtr(chara);
        return data != nullptr ? &data->equip[row == 0 ? CHARA_EQUIP_MELEE : CHARA_EQUIP_SUB] : nullptr;
    }
    if (chara == USER_CHARA_ROBO) {
        return &DngUserData->robo_data.parts[row == 0 ? ROBO_PART_ARM : ROBO_PART_LEG];
    }
    return nullptr;
}

// The owned item a slot names, on the item board: the one with its name first, else one of its kind.
CGameDataUsed *FindOwned(const Entry &entry) {
    if (entry.item_no <= 0) {
        return nullptr;
    }
    CGameDataUsed *same_kind = nullptr;
    CGameDataUsed *item = DngUserData->GetUsedDataPtr(0);
    const int      count = GetNowBagMax(ITEM_BOARD_MAIN);
    for (int i = 0; i < count; i++, item++) {
        if (item->item_no != entry.item_no) {
            continue;
        }
        if (std::strncmp(ItemName(item), entry.name, kNameSize) == 0) {
            return item;
        }
        if (same_kind == nullptr) {
            same_kind = item;
        }
    }
    return same_kind;
}

int ActiveChara() { return DngUserData != nullptr ? DngUserData->active_chr_no : -1; }

bool Dead() {
    CBattleCharaInfo *info = GetBattleCharaInfo();
    return info != nullptr && info->GetNowHp_i() <= 0;
}

// The panel is only for the player walking the floor with the status board up.
bool Usable() {
    if (PortLoopNo != LOOP_DUNGEON || DngStatus.mode != DNG_STATUS_FIELD || DngStatus.eye_view || SubGameRunning() ||
        MainChara__2 == nullptr || BattleAreaScene == nullptr || DngUserData == nullptr) {
        return false;
    }
    const int chara = ActiveChara();
    if (chara < USER_CHARA_MAX || chara > USER_CHARA_ROBO) {
        return false;
    }
    return BattleAreaScene->statusbar_show && !(BattleAreaScene->pause_flag & DNG_PAUSE_PLAYER_CONTROL) &&
           MainChara__2->CheckRunEvent() && !Dead() && !NowTakePhoto();
}

void PlaySe(int se) { sndSePlay(SystemSND_ID, se, 0); }

void Close() {
    panel_open = false;
    request_slot = -1;
}

// The first time a character's panel opens with an empty row, the item equipped in that row takes its first slot.
void FillEmptyRows(int chara) {
    bool changed = false;
    for (int row = 0; row < 2; row++) {
        CGameDataUsed *equipped = RowEquip(chara, row);
        Entry         *pair = &slots[chara][row * 2];
        if (equipped != nullptr && equipped->item_no > 0 && pair[0].item_no <= 0 && pair[1].item_no <= 0) {
            SetEntry(pair[0], equipped);
            changed = true;
        }
    }
    if (changed) {
        SaveSlots();
    }
}

void Open() {
    if (!slots_loaded) {
        LoadSlots();
    }
    FillEmptyRows(ActiveChara());
    panel_open = true;
    PlaySe(SYSTEM_SE_PAGE);
}

// Whether the Ridepod has the capacity for a part in place of the one fitted in its slot, as the menu asks.
bool RidepodTakes(CGameDataUsed *part, CGameDataUsed *fitted) {
    int        capacity = 0;
    const int  used = CheckNowRoboUseCapacity(&DngUserData->robo_data, &capacity) - fitted->GetUseCapacity();
    const auto data = GameItemDataManage.GetRoboData(part->item_no);
    return data != nullptr && capacity - used >= data->use_capacity;
}

// Equips a slot's item and has the character loaded again with it, as a quick change loads the next one; the change's
// effect plays on it. Returns whether the dungeon is now in that load.
bool Equip(int slot) {
    const int chara = ActiveChara();
    if (!Usable()) {
        return false;
    }
    const Entry   &entry = slots[chara][slot];
    CGameDataUsed *equipped = RowEquip(chara, slot / 2);
    if (entry.item_no <= 0 || equipped == nullptr) {
        PlaySe(SYSTEM_SE_CANCEL);
        return false;
    }
    if (Matches(entry, equipped)) {
        PlaySe(SYSTEM_SE_CURSOR); // already in hand: the panel stays open
        return false;
    }
    CGameDataUsed *item = FindOwned(entry);
    if (item == nullptr || (chara == USER_CHARA_ROBO && !RidepodTakes(item, equipped)) ||
        !(DngUserData->CheckQuickChange(chara, nullptr) & QUICK_CHANGE_STATE_ENABLED)) {
        PlaySe(SYSTEM_SE_CANCEL);
        return false;
    }
    if (!DngUserData->SetChrEquip(chara, item)) {
        PlaySe(SYSTEM_SE_CANCEL);
        return false;
    }
    PlaySe(SYSTEM_SE_EQUIP);
    Close();
    fade = 0;
    reloading = true;
    kept_target = {true, MainChara__2->target_no, MainChara__2->lock_on};

    // As DngMainKey opens a quick change (L3, R3), for the character already in play.
    VoiceUnit.StopVoice(10);
    MenuArg.param[0] = chara;
    MenuArg.open_type = MENU_OPEN_MAIN_CHARA_BG_DUNGEON;
    DngStatus.mode = DNG_STATUS_MENU;
    DngMainScene->fade.ResetFade();
    BattleAreaScene->SetStatusBarNow(0);
    MainChara__2->RemoveThrowItem();
    WarningGage2.warning[0] = false;
    WarningGage2.warning[1] = false;
    WarningGage2.warning[2] = false;
    LockOnModel.pos[3] = 0.0f;
    return true;
}

// Stretches the texture's rectangle (u, v, tw, th) over (x, y, w, h).
void Piece(CPreSprite &sprite, int x, int y, int w, int h, int u, int v, int tw, int th) {
    if (w > 0 && h > 0) {
        sprite.SetIStretch(x, y, w, h, u, v, tw, th);
    }
}

// A rounded box in the item circles' plum and gold: their quarters in the corners, size across, and their middle
// rows and columns stretched between.
void Rounded(CPreSprite &sprite, const Rect &r, int size) {
    const int c = size, h = kCircleHalf;
    Piece(sprite, r.x, r.y, c, c, kCircleLeftU, kCircleLeftV, h, h);
    Piece(sprite, r.x, r.y + r.h - c, c, c, kCircleLeftU, kCircleLeftV + h, h, h);
    Piece(sprite, r.x + r.w - c, r.y, c, c, kCircleRightU, kCircleRightV, h, h);
    Piece(sprite, r.x + r.w - c, r.y + r.h - c, c, c, kCircleRightU, kCircleRightV + h, h, h);
    Piece(sprite, r.x + c, r.y, r.w - 2 * c, c, kCircleLeftU + h - 1, kCircleLeftV, 1, h);
    Piece(sprite, r.x + c, r.y + r.h - c, r.w - 2 * c, c, kCircleLeftU + h - 1, kCircleLeftV + h, 1, h);
    Piece(sprite, r.x, r.y + c, c, r.h - 2 * c, kCircleLeftU, kCircleLeftV + h - 1, h, 1);
    Piece(sprite, r.x + r.w - c, r.y + c, c, r.h - 2 * c, kCircleRightU, kCircleRightV + h - 1, h, 1);
    Piece(sprite, r.x + c, r.y + c, r.w - 2 * c, r.h - 2 * c, kCircleLeftU + h - 1, kCircleLeftV + h - 1, 1, 1);
}

bool TitlePlate() { return ConfigGet().quick_loadout_plate; }

void DrawPanel(int left, int top, uint8_t alpha) {
    if (TEX_SystenFrame == nullptr) {
        return;
    }
    CPreSprite sprite;
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Bilinear(0); // texel for texel, as the board is drawn
    sprite.Texture(TEX_SystenFrame);

    // The box: its inside a see-through black, then its border. The EXP box is lit from the top left and has a grey
    // bevel inside its gold, lighter on the right and bottom, which on a see-through inside reads as a frame that does
    // not close: only the gold is taken, its top left corner and top and left sides, mirrored into the other three,
    // and the see-through black runs right up to it.
    const bool plate_style = TitlePlate();
    const Rect frame = plate_style ? kPlateBox : kBox;
    const Rect box = {left + frame.x, top + frame.y, frame.w, frame.h};
    const int  side = kBoxSide, gold = kBoxGold, gold_top = kBoxGoldTop;
    const int  right = box.x + box.w - side;
    sprite.Color(0x80, 0x80, 0x80, alpha * 0x4C / 0x80);
    Piece(sprite, box.x + gold, box.y + gold_top, box.w - 2 * gold, box.h - 2 * gold_top, kBlackU, kBlackV, 1, 1);
    sprite.Color(0x80, 0x80, 0x80, alpha);
    // The corners row by row, as far as their gold goes; a mirrored piece starts on its last texel.
    for (int row = 0; row < kBoxCorner; row++) {
        const int width = kBoxCornerGold[row];
        for (const int y : {box.y + row, box.y + box.h - 1 - row}) {
            Piece(sprite, box.x, y, width, 1, kBoxU0, kBoxV0 + row, width, 1);
            Piece(sprite, right + side - width, y, width, 1, kBoxU0 + width - 1, kBoxV0 + row, -width, 1);
        }
    }
    Piece(sprite, box.x + side, box.y, box.w - 2 * side, gold_top, kBoxUMiddle, kBoxV0, 1, gold_top);
    Piece(sprite, box.x + side, box.y + box.h - gold_top, box.w - 2 * side, gold_top, kBoxUMiddle,
          kBoxV0 + gold_top - 1, 1, -gold_top);
    Piece(sprite, box.x, box.y + kBoxCorner, gold, box.h - 2 * kBoxCorner, kBoxU0, kBoxVMiddle, gold, 1);
    Piece(sprite, right + side - gold, box.y + kBoxCorner, gold, box.h - 2 * kBoxCorner, kBoxU0 + gold - 1,
          kBoxVMiddle, -gold, 1);
    // The top left corner's first row carries the join to the bar above the EXP box: the top side's shadow instead.
    // The title's plate stands there, as the EXP plate does.
    for (const int y : {box.y, box.y + box.h - 1}) {
        if (y != box.y || !plate_style) {
            Piece(sprite, box.x + kBoxJoinX, y, side - kBoxJoinX, 1, kBoxUMiddle, kBoxV0, 1, 1);
        }
        Piece(sprite, right, y, side - kBoxJoinX, 1, kBoxUMiddle, kBoxV0, 1, 1);
    }
    Piece(sprite, right + kBoxBoltX, box.y + 1, kBoxBolt, kBoxBolt + 1, kBoxBoltTopU, kBoxBoltTopV, kBoxBolt,
          kBoxBolt + 1);
    Piece(sprite, box.x + 1, box.y + box.h - kBoxEdge, kBoxBolt, kBoxBolt + 1, kBoxBoltBottomU, kBoxBoltBottomV, kBoxBolt,
          kBoxBolt + 1);
    for (const Rect &slot : kSlotRect) {
        Rounded(sprite, {left + slot.x, top + slot.y, slot.w, slot.h}, kCircleHalf);
    }

    if (plate_style) {
        // The title's plate, the EXP plate widened and heightened, texel for texel at its sides and top.
        const Rect plate = {left + kTitlePlate.x, top + kTitlePlate.y, kTitlePlate.w, kTitlePlate.h};
        const int  middle_h = plate.h - kPlateTop - 1, middle_w = plate.w - 2 * kPlateSide;
        const int  columns[3][3] = {{plate.x, kPlateSide, kPlateLeftU},
                                    {plate.x + kPlateSide, middle_w, kPlateMiddleU},
                                    {plate.x + plate.w - kPlateSide, kPlateSide, kPlateRightU}};
        for (const auto &c : columns) {
            const int tw = c[2] == kPlateMiddleU ? 1 : kPlateSide;
            Piece(sprite, c[0], plate.y, c[1], kPlateTop, c[2], kPlateV0, tw, kPlateTop);
            Piece(sprite, c[0], plate.y + kPlateTop, c[1], middle_h, c[2], kPlateMiddleV, tw, kPlateMiddle);
            Piece(sprite, c[0], plate.y + plate.h - 1, c[1], 1, c[2], kPlateBottomV, tw, 1);
        }
        sprite.End();
        return;
    }
    sprite.End();

    // The title bar, shrunk from the circles.
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Bilinear(1);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(0x80, 0x80, 0x80, alpha);
    Rounded(sprite, {left + kTitleBar.x, top + kTitleBar.y, kTitleBar.w, kTitleBar.h}, kTitleBar.h / 2);
    sprite.End();
}

// Each slot's button: a disc, the circle's two halves shrunk, with the button on it as the game's text shows it. Drawn
// last, over the pictures and the cursor.
void DrawButtons(int left, int top, uint8_t alpha) {
    if (TEX_SystenFrame == nullptr) {
        return;
    }
    CPreSprite sprite;
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Bilinear(1);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(0x80, 0x80, 0x80, alpha);
    for (const Rect &slot : kSlotRect) {
        const int x = left + slot.x + kDiscOffset, y = top + slot.y + kDiscOffset, half = kDiscSize / 2;
        Piece(sprite, x, y, half, kDiscSize, kCircleLeftU, kCircleLeftV, kCircleHalf, 2 * kCircleHalf);
        Piece(sprite, x + half, y, half, kDiscSize, kCircleRightU, kCircleRightV, kCircleHalf, 2 * kCircleHalf);
    }
    sprite.End();

    mgCTexture *gaiji = mgTexManager.GetTexture("gaiji", -1);
    if (gaiji == nullptr) {
        return;
    }
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Bilinear(1);
    sprite.Texture(gaiji);
    sprite.Color(0x80, 0x80, 0x80, alpha);
    for (int slot = 0; slot < kSlots; slot++) {
        const Rect &r = kSlotRect[slot];
        const int   inset = (kDiscSize - kGlyphSize) / 2;
        Piece(sprite, left + r.x + kDiscOffset + inset, top + r.y + kDiscOffset + inset, kGlyphSize, kGlyphSize,
              kGlyphUV[slot][0], kGlyphUV[slot][1], kGlyphTexels, kGlyphTexels);
    }
    sprite.End();
}

// "QUICK LOADOUT" in the game's own font, in the middle of the title bar or plate.
void DrawTitle(float x, float y, uint8_t alpha) {
    static const char kTitle[] = "QUICK LOADOUT";
    CFont font;
    font.Init();
    // The game's own size for its menu text, 16 by 20, which draws the font texel for texel (any other size stretches
    // its letters unevenly). The font is fixed width, so the letters are set one by one: a narrow I would otherwise
    // stand apart from its word.
    font.SetDrawSize(16, 20);
    font.SetClearance(16, 20);
    constexpr float kCell = 8.0f; // a half-width letter's cell
    auto advance = [](char c) { return c == 'I' ? 5.0f : c == ' ' ? 7.0f : 9.0f; };
    float width = 0.0f;
    for (const char *c = kTitle; *c != 0; c++) {
        width += c[1] != 0 ? advance(*c) : kCell;
    }
    int w = 0, h = 0;
    font.CalcDrawWH(const_cast<char *>("Q"), &w, &h);
    struct Pass {
        int     dx, dy;
        uint8_t r, g, b;
    };
    // On the bar, white with the font's black outline. On the plate, engraved as the EXP plate's letters: dark brown
    // and heavy, each stroke with a light gold edge under it and to its right; the light edge first, then the letters,
    // twice across.
    static const Pass kBarPasses[] = {{0, 0, 0x80, 0x80, 0x80}};
    static const Pass kPlatePasses[] = {
        {1, 1, 0x75, 0x6A, 0x58}, {2, 1, 0x75, 0x6A, 0x58}, {0, 0, 0x1F, 0x11, 0x08}, {1, 0, 0x1F, 0x11, 0x08}};
    const bool plate = TitlePlate();
    font.SetFuchi(plate ? FUCHI_NONE : FUCHI_OUTLINE);
    const std::span<const Pass> passes = plate ? std::span<const Pass>(kPlatePasses) : std::span<const Pass>(kBarPasses);
    for (const Pass &pass : passes) {
        font.SetColor(pass.r, pass.g, pass.b, alpha);
        float pen = x - (width + (plate ? 1.0f : 0.0f)) * 0.5f;
        for (const char *c = kTitle; *c != 0; c++) {
            char letter[2] = {*c, 0};
            // A narrow letter keeps to the middle of the room it is given.
            const float shift = (advance(*c) - kCell) * 0.5f;
            if (*c != ' ') {
                font.DrawDirect(letter, (int) (pen + (*c == 'I' ? shift : 0.0f) + 0.5f) + pass.dx,
                                (int) (y - h * 0.5f + 0.5f) + pass.dy);
            }
            pen += advance(*c);
        }
    }
}

gfx::TextureHandle ItemPicture(int item_no) {
    const auto found = pictures.find(item_no);
    return found != pictures.end() ? found->second.texture : gfx::kNullTexture;
}

gfx::Vertex2D Corner(float x, float y, float u, float v, uint8_t alpha, uint8_t bright = 0x80) {
    gfx::Vertex2D vertex{};
    vertex.x = x;
    vertex.y = y;
    vertex.z = 0.0f;
    vertex.u = u;
    vertex.v = v;
    vertex.color[0] = vertex.color[1] = vertex.color[2] = bright;
    vertex.color[3] = alpha;
    return vertex;
}

void DrawQuad(gfx::TextureHandle texture, float x, float y, float w, float h, float tw, float th, uint8_t alpha,
              uint8_t bright = 0x80) {
    gfx::DrawState state{};
    state.blend = true;
    gfx::TextureBinding binding;
    binding.texture = texture;
    binding.filter = gfx::Filter::Linear;
    const gfx::Vertex2D quad[4] = {Corner(x, y, 0, 0, alpha, bright), Corner(x + w, y, tw, 0, alpha, bright),
                                   Corner(x + w, y + h, tw, th, alpha, bright), Corner(x, y + h, 0, th, alpha, bright)};
    mgPortDraw2D(gfx::Primitive::Quads, quad, binding, state);
}

// The game's own rotating cursor round the active item (DrawActiveItemCursor), laid along the slot in use: its ring of
// eight dashes, from the system frame texture, is unrolled and its dashes follow the slot's rounded edge, bending
// round its corners, added, and travelling round it as the retail one turns, a degree of its ring a frame.
constexpr float kRingU = 0x84 + 27.5f, kRingV = 0xCA + 27.5f; // the ring's centre in the texture
constexpr float kRingRadius = 22.0f;                           // the middle of its dashes
constexpr float kRingInner = 18.0f, kRingOuter = 26.0f;        // what is taken across them
constexpr float kDashFrom = -135.0f * DEG_TO_RAD;               // one dash, the top left one, and the gap after it
constexpr float kDashArc = 45.0f * DEG_TO_RAD;
constexpr float kDashLength = kRingRadius * kDashArc;          // the length of a dash and its gap along the ring
constexpr int   kDashSlices = 8;
constexpr float kEdgeInset = 1.0f; // the dashes' middle line, just inside the slot's edge

float halo_travel = 0.0f; // how far the dashes have gone round, in dashes

// The point s along the slot's rounded edge, clockwise from the end of the top left corner, and the edge's direction
// there.
void EdgePoint(float x0, float y0, float x1, float y1, float r, float s, float *x, float *y, float *dir) {
    const float across = x1 - x0 - 2.0f * r, down = y1 - y0 - 2.0f * r, arc = 0.5f * PI * r;
    const float sides[4] = {across, down, across, down};
    // Where each side starts, where its corner turns about, and which way the side runs.
    const float start[4][2] = {{x0 + r, y0}, {x1, y0 + r}, {x1 - r, y1}, {x0, y1 - r}};
    const float centre[4][2] = {{x1 - r, y0 + r}, {x1 - r, y1 - r}, {x0 + r, y1 - r}, {x0 + r, y0 + r}};
    const float run[4][2] = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
    for (int side = 0; side < 4; side++) {
        if (s < sides[side]) {
            *x = start[side][0] + run[side][0] * s;
            *y = start[side][1] + run[side][1] * s;
            *dir = side * 0.5f * PI;
            return;
        }
        s -= sides[side];
        if (s < arc || side == 3) {
            const float a = (side - 1) * 0.5f * PI + s / r;
            *x = centre[side][0] + r * cosf(a);
            *y = centre[side][1] + r * sinf(a);
            *dir = a + 0.5f * PI;
            return;
        }
        s -= arc;
    }
}

void DrawHalo(float x0, float y0, float w, float h, float alpha) {
    if (TEX_SystenFrame == nullptr) {
        return;
    }
    const float left = x0 + kEdgeInset, top = y0 + kEdgeInset, right = x0 + w - kEdgeInset, bottom = y0 + h - kEdgeInset;
    const float radius = kCircleHalf - kEdgeInset;
    const float perimeter = 2.0f * (right - left - 2.0f * radius) + 2.0f * (bottom - top - 2.0f * radius) +
                            2.0f * PI * radius;
    const int   dashes = std::max(1, (int) lroundf(perimeter / kDashLength));
    const float length = perimeter / dashes;
    const float stretch = length / kDashLength;

    CPreSprite sprite;
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Bilinear(1);
    sprite.Begin(MG_PRIM_TRIANGLE);
    sprite.Texture(TEX_SystenFrame);
    sprite.SetAlphaBlend(MG_ALPHA_BLEND_ADD);
    sprite.Color(0x80, 0x80, 0x80, (int) (128.0f * alpha));
    // Each slice of a dash: its inner and outer corner on the screen and in the texture, in sixteenths of a texel.
    float screen[kDashSlices + 1][2][4] = {};
    int   texel[kDashSlices + 1][2][2] = {};
    for (int j = 0; j <= kDashSlices; j++) {
        const float a = kDashFrom + kDashArc * j / kDashSlices;
        const float radii[2] = {kRingInner, kRingOuter};
        for (int k = 0; k < 2; k++) {
            texel[j][k][0] = (int) lroundf((kRingU + radii[k] * cosf(a)) * 16.0f);
            texel[j][k][1] = (int) lroundf((kRingV + radii[k] * sinf(a)) * 16.0f);
        }
    }
    for (int dash = 0; dash < dashes; dash++) {
        for (int j = 0; j <= kDashSlices; j++) {
            float s = (dash + halo_travel) * length + length * j / kDashSlices;
            s = fmodf(s, perimeter);
            float x, y, dir;
            EdgePoint(left, top, right, bottom, radius, s, &x, &y, &dir);
            // Outward from the edge, as the ring's radius grows outward.
            const float nx = sinf(dir), ny = -cosf(dir);
            const float offsets[2] = {kRingInner - kRingRadius, kRingOuter - kRingRadius};
            for (int k = 0; k < 2; k++) {
                screen[j][k][0] = x + nx * offsets[k] * stretch;
                screen[j][k][1] = y + ny * offsets[k] * stretch;
            }
        }
        for (int j = 0; j < kDashSlices; j++) {
            const int corner[6][2] = {{j, 0}, {j, 1}, {j + 1, 0}, {j, 1}, {j + 1, 0}, {j + 1, 1}};
            for (const auto &c : corner) {
                sprite.TextureCrd4(texel[c[0]][c[1]][0], texel[c[0]][c[1]][1]);
                sprite.Vertex(screen[c[0]][c[1]]);
            }
        }
    }
    sprite.End();
}

} // namespace

// The request a tap leaves is acted on here, where the dungeon opens its menus, before anything else reads the pad.
PORT_OVERRIDE int DngMainKey() {
    if (request_slot >= 0) {
        const int slot = request_slot;
        request_slot = -1;
        if (Equip(slot)) {
            return 0;
        }
    }
    return PortRetailDngMainKey();
}

void PortQuickLoadoutPad() {
    if (kept_target.pending && !reloading && DngStatus.mode == DNG_STATUS_FIELD) {
        kept_target.pending = false;
        if (MainChara__2 != nullptr && kept_target.target_no >= 0 && nowScene__2 != nullptr &&
            nowScene__2->GetCharacter(kept_target.target_no) != nullptr) {
            MainChara__2->target_no = kept_target.target_no;
            MainChara__2->lock_on = kept_target.lock_on;
        }
    }
    const int raw = GamePad__2.pad[0].button;
    const int pressed = raw & ~raw_previous;
    raw_previous = raw;
    const int ticks = mgFrameRate > 0 ? mgFrameRate : 1;

    if (!Usable()) {
        if (panel_open) {
            Close();
        }
    } else if (pressed & PAD_DOWN) {
        if (panel_open) {
            Close();
            PlaySe(SYSTEM_SE_CANCEL);
        } else {
            Open();
        }
    }

    if (panel_open) {
        for (int slot = 0; slot < kSlots; slot++) {
            if (pressed & kSlotButton[slot]) {
                request_slot = slot;
            }
        }
        swallowed |= raw & kFaceButtons;
    }

    // A button the panel took stays away from the game until it is let go, so closing the panel never presses it.
    swallowed &= raw;
    GamePad__2.pad[0].button &= ~swallowed;

    fade += panel_open ? ticks : -ticks;
    fade = fade < 0 ? 0 : fade > kFadeTicks ? kFadeTicks : fade;
}

// The item's own model, drawn once into a texture of its own the first time a slot shows it (Jeffiest's 3D item icons).
// One new picture a frame at most, so opening the panel never stalls a frame for long.
void PortQuickLoadoutPrepare() {
    const int chara = ActiveChara();
    if (!panel_open || PortLoopNo != LOOP_DUNGEON || chara < USER_CHARA_MAX || chara > USER_CHARA_ROBO) {
        return;
    }
    for (const Entry &entry : slots[chara]) {
        if (entry.item_no <= 0 || pictures.count(entry.item_no) != 0) {
            continue;
        }
        Picture &picture = pictures[entry.item_no];
        char name[48];
        std::snprintf(name, sizeof name, "quick loadout item %d", entry.item_no);
        // An ordinary target: a frame target maps its width onto the widened frame, which moved the model aside.
        const gfx::TextureHandle target = gfx::NamedRenderTarget(name, kIconSize, kIconSize, true);
        if (ItemIcon3DRenderTo(entry.item_no, target, kIconSize)) {
            picture.texture = target;
        } else {
            picture.failed = true;
        }
        return;
    }
}

void PortQuickLoadoutDraw(float statusbar_rate) {
    if (fade <= 0 || PortLoopNo != LOOP_DUNGEON || DngUserData == nullptr) {
        return;
    }
    // The panel follows the status board while it is open. Once it closes it fades where it is, with what it showed:
    // a character change closes it while the board slides away and back with the other character.
    static int chara = -1, left = 0, top = 0;
    if (panel_open || chara < 0) {
        chara = ActiveChara();
        // The Ridepod's board has no active items, so its panel sits higher, under its numbers and clear of the
        // danger sign.
        const bool ridepod = chara == USER_CHARA_ROBO;
        left = ridepod ? kRidepodX : kPanelX;
        top = (int) (80.0f * statusbar_rate) - 72 + (ridepod ? kRidepodOffsetY : kPanelOffsetY);
    }
    const uint8_t alpha = static_cast<uint8_t>(0x80 * fade / kFadeTicks);
    DrawPanel(left, top, alpha);
    const Rect title = TitlePlate() ? kTitlePlate : kTitleBar;
    DrawTitle(left + title.x + title.w * 0.5f, top + title.y + title.h * 0.5f, alpha);
    if (chara < USER_CHARA_MAX || chara > USER_CHARA_ROBO) {
        DrawButtons(left, top, alpha);
        return;
    }

    // The retail cursor turns a degree a frame; a dash and its gap span 45 of them.
    halo_travel += DEG_TO_RAD / kDashArc;
    if (halo_travel >= 1.0f) {
        halo_travel -= 1.0f;
    }
    for (int slot = 0; slot < kSlots; slot++) {
        const Rect  &r = kSlotRect[slot];
        const float  x0 = (float) (left + r.x), y0 = (float) (top + r.y);
        const float  w = (float) r.w, h = (float) r.h;
        const Entry &entry = slots[chara][slot];
        if (entry.item_no > 0) {
            const gfx::TextureHandle handle = ItemPicture(entry.item_no);
            if (handle != gfx::kNullTexture) {
                // Clear of the button's disc in the slot's top left corner.
                const float size = h * 0.83f;
                const float cx = x0 + w * 0.5f + h * 0.14f, cy = y0 + h * 0.5f + h * 0.02f;
                CGameDataUsed *equipped = RowEquip(chara, slot / 2);
                const bool     have = (equipped != nullptr && Matches(entry, equipped)) || FindOwned(entry) != nullptr;
                DrawQuad(handle, cx - size * 0.5f, cy - size * 0.5f, size, size, kIconSize, kIconSize,
                         have ? alpha : alpha / 3, have ? 0x80 : 0x50);
            }
            // The slot whose item is equipped now wears the active item's cursor round its picture.
            CGameDataUsed *equipped = RowEquip(chara, slot / 2);
            if (equipped != nullptr && Matches(entry, equipped)) {
                DrawHalo(x0, y0, w, h, (float) fade / kFadeTicks);
            }
        }
    }
    DrawButtons(left, top, alpha);
}

void PortQuickLoadoutReset() {
    Close();
    fade = 0;
    pictures.clear();
    reloading = false;
    kept_target.pending = false;
}

bool PortQuickLoadoutReloading() { return reloading; }

void PortQuickLoadoutReloadDone() { reloading = false; }

bool PortQuickLoadoutTarget(const CGameDataUsed *item, int *chara, int *row) {
    if (item == nullptr || item->item_no <= 0) {
        return false;
    }
    switch (GetItemDataType(item->item_no)) {
    case ITEM_DATA_MAX_MELEE:
        *chara = USER_CHARA_MAX, *row = 0;
        break;
    case ITEM_DATA_MAX_GUN:
        *chara = USER_CHARA_MAX, *row = 1;
        break;
    case ITEM_DATA_MONICA_MELEE:
        *chara = USER_CHARA_MONICA, *row = 0;
        break;
    case ITEM_DATA_MONICA_MAGIC:
        *chara = USER_CHARA_MONICA, *row = 1;
        break;
    case ITEM_DATA_ROBO_ARM:
        *chara = USER_CHARA_ROBO, *row = 0;
        break;
    case ITEM_DATA_ROBO_LEG:
        *chara = USER_CHARA_ROBO, *row = 1;
        break;
    default:
        return false;
    }
    // The rods have their own way into Max's hand: fishing.
    return !const_cast<CGameDataUsed *>(item)->IsFishingRod();
}

bool PortQuickLoadoutAssign(const CGameDataUsed *item, int slot) {
    int chara, row;
    if (slot < 0 || slot >= kSlots || !PortQuickLoadoutTarget(item, &chara, &row) || slot / 2 != row) {
        return false;
    }
    if (!slots_loaded) {
        LoadSlots();
    }
    // One slot per item: the row's other slot lets go of it.
    Entry &other = slots[chara][slot ^ 1];
    if (Matches(other, item)) {
        other = {};
    }
    SetEntry(slots[chara][slot], item);
    SaveSlots();
    return true;
}
