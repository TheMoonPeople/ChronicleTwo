#include "common.h"

#include "quick_loadout.hpp"

#include "actionchara.hpp"
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
#include "platform/paths.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "photo.hpp"
#include "prespr.hpp"
#include "subgame.hpp"
#include "userdata.hpp"
#include "font.hpp"

#include "gfx/gfx.hpp"

#include <cmath>
#include <cstdio>
#include <cstring>
#include <map>
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
constexpr int  kPanelX = 38;
constexpr int  kPanelOffsetY = 72;
constexpr Rect kBox = {0, 8, 176, 134};
constexpr Rect kTitleBar = {46, 0, 84, 22};
// Square, Triangle, Cross, Circle.
constexpr Rect kSlotRect[kSlots] = {{11, 26, 76, 52}, {89, 26, 76, 52}, {11, 82, 76, 52}, {89, 82, 76, 52}};
constexpr int  kDiscSize = 24;
constexpr int  kDiscOffset = -3; // the disc over the slot's top left corner
constexpr int  kGlyphSize = 16;

// In the system frame texture: the EXP gauge's box, its gold border 10 across and 9 down to the black inside...
constexpr int kBoxU0 = 288, kBoxU1 = 373, kBoxUMiddle = 340, kBoxV0 = 154, kBoxV1 = 182, kBoxVMiddle = 172;
constexpr int kBoxSide = 10, kBoxEdge = 9;
constexpr int kBlackU = 298, kBlackV = 165;
// ...and the active item circles, 40 across: the left half of the first, the right half of the last (their other
// halves hold the joints between them).
constexpr int kCircleLeftU = 236, kCircleLeftV = 55, kCircleRightU = 364, kCircleRightV = 96, kCircleHalf = 20;
// The buttons in the font's own picture of them ("gaiji"): Square, Triangle, Cross, Circle.
constexpr int kGlyphUV[kSlots][2] = {{44, 22}, {22, 22}, {66, 22}, {0, 22}};
constexpr int kGlyphTexels = 22;

// Model pictures: the dungeon's texture table ends at 0xAE; the effect scripts take 0x8C to 0xAB and the geostone 0xAD.
// 0xAC takes the model's own pictures while it is drawn, 0xAE the scratch picture it is drawn into.
constexpr int kModelBlock = 0xAC;
constexpr int kIconBlock = 0xAE;
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

    // The box: its inside a see-through black, then its border.
    const Rect box = {left + kBox.x, top + kBox.y, kBox.w, kBox.h};
    const int  side = kBoxSide, edge = kBoxEdge;
    sprite.Color(0x80, 0x80, 0x80, alpha * 0x4C / 0x80);
    Piece(sprite, box.x + side, box.y + edge, box.w - 2 * side, box.h - 2 * edge, kBlackU, kBlackV, 1, 1);
    sprite.Color(0x80, 0x80, 0x80, alpha);
    Piece(sprite, box.x, box.y, side, edge, kBoxU0, kBoxV0, side, edge);
    Piece(sprite, box.x + box.w - side, box.y, side, edge, kBoxU1, kBoxV0, side, edge);
    Piece(sprite, box.x, box.y + box.h - edge, side, edge, kBoxU0, kBoxV1, side, edge);
    Piece(sprite, box.x + box.w - side, box.y + box.h - edge, side, edge, kBoxU1, kBoxV1, side, edge);
    Piece(sprite, box.x + side, box.y, box.w - 2 * side, edge, kBoxUMiddle, kBoxV0, 1, edge);
    Piece(sprite, box.x + side, box.y + box.h - edge, box.w - 2 * side, edge, kBoxUMiddle, kBoxV1, 1, edge);
    Piece(sprite, box.x, box.y + edge, side, box.h - 2 * edge, kBoxU0, kBoxVMiddle, side, 1);
    Piece(sprite, box.x + box.w - side, box.y + edge, side, box.h - 2 * edge, kBoxU1, kBoxVMiddle, side, 1);

    for (const Rect &slot : kSlotRect) {
        Rounded(sprite, {left + slot.x, top + slot.y, slot.w, slot.h}, kCircleHalf);
    }
    sprite.End();

    // The smaller pieces, shrunk from the circles: the title bar and each button's disc, the circle's two halves.
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Bilinear(1);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(0x80, 0x80, 0x80, alpha);
    Rounded(sprite, {left + kTitleBar.x, top + kTitleBar.y, kTitleBar.w, kTitleBar.h}, kTitleBar.h / 2);
    for (const Rect &slot : kSlotRect) {
        const int x = left + slot.x + kDiscOffset, y = top + slot.y + kDiscOffset, half = kDiscSize / 2;
        Piece(sprite, x, y, half, kDiscSize, kCircleLeftU, kCircleLeftV, kCircleHalf, 2 * kCircleHalf);
        Piece(sprite, x + half, y, half, kDiscSize, kCircleRightU, kCircleRightV, kCircleHalf, 2 * kCircleHalf);
    }
    sprite.End();

    // The buttons on the discs, as the game's text shows them.
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

// "QUICK LOADOUT" in the game's own font, white with its black outline, in the middle of the title bar.
void DrawTitle(float x, float y, uint8_t alpha) {
    static char title[] = "QUICK LOADOUT";
    CFont font;
    font.Init();
    // The game's own size for its menu text, letters a pixel further apart than its usual 15.
    constexpr int kLetterWidth = 16;
    constexpr int kLetterAdvance = 16;
    font.SetDrawSize(kLetterWidth, 20);
    font.SetClearance(kLetterAdvance, 20);
    font.SetFuchi(FUCHI_OUTLINE);
    font.SetColor(0x80, 0x80, 0x80, alpha);
    int w = 0, h = 0;
    font.CalcDrawWH(title, &w, &h);
    font.DrawDirect(title, (int) (x - w * 0.5f + 0.5f), (int) (y - h * 0.5f + 0.5f));
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

// The game's own rotating cursor round the active item (DrawActiveItemCursor), drawn round the slot in use: the same
// picture from the system frame texture, added, turning a degree a frame on an angle of its own (PortQuickLoadoutDraw turns it). size is its width.
float halo_angle = -PI;

void DrawHalo(float x, float y, float size, float alpha) {
    if (TEX_SystenFrame == nullptr) {
        return;
    }
    CPreSprite sprite;
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Bilinear(1);
    sprite.Begin(MG_PRIM_TRIANGLE);
    sprite.Texture(TEX_SystenFrame);
    sprite.SetAlphaBlend(MG_ALPHA_BLEND_ADD);
    sprite.Color(0x80, 0x80, 0x80, (int) (128.0f * alpha));
    const float k = size / 55.0f, sn = sinf(halo_angle), cs = cosf(halo_angle);
    // Two triangles over the 55x55 picture at (0x84, 0xCA), as retail lays them out.
    static const float kCorner[6][4] = {{-28, -28, 0x84, 0xCA}, {-28, 27, 0xB9, 0xCA}, {27, -28, 0x84, 0xFF},
                                        {-28, 27, 0xB9, 0xCA},  {27, -28, 0x84, 0xFF}, {27, 27, 0xB9, 0xFF}};
    for (const auto &c : kCorner) {
        const float u = c[0] * k, v = c[1] * k;
        float       corner[4] = {x + (u * sn - v * cs), y + (v * sn + u * cs), 0.0f, 0.0f};
        sprite.TextureCrd((int) c[2], (int) c[3]);
        sprite.Vertex(corner);
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
        if (ItemIcon3DRenderTo(entry.item_no, target, kIconSize, kModelBlock, kIconBlock)) {
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
    const int     chara = ActiveChara();
    const uint8_t alpha = static_cast<uint8_t>(0x80 * fade / kFadeTicks);
    const int     top = (int) (80.0f * statusbar_rate) - 72 + kPanelOffsetY;
    DrawPanel(kPanelX, top, alpha);
    DrawTitle(kPanelX + kTitleBar.x + kTitleBar.w * 0.5f, top + kTitleBar.y + kTitleBar.h * 0.5f, alpha);
    if (chara < USER_CHARA_MAX || chara > USER_CHARA_ROBO) {
        return;
    }

    halo_angle += DEG_TO_RAD;
    if (halo_angle > PI) {
        halo_angle -= 2.0f * PI;
    }
    for (int slot = 0; slot < kSlots; slot++) {
        const Rect  &r = kSlotRect[slot];
        const float  x0 = (float) (kPanelX + r.x), y0 = (float) (top + r.y);
        const float  w = (float) r.w, h = (float) r.h;
        const Entry &entry = slots[chara][slot];
        if (entry.item_no > 0) {
            const gfx::TextureHandle handle = ItemPicture(entry.item_no);
            if (handle != gfx::kNullTexture) {
                // Clear of the button's disc in the slot's top left corner.
                const float size = h * 0.92f;
                const float cx = x0 + w * 0.5f + h * 0.14f, cy = y0 + h * 0.5f + h * 0.02f;
                CGameDataUsed *equipped = RowEquip(chara, slot / 2);
                const bool     have = (equipped != nullptr && Matches(entry, equipped)) || FindOwned(entry) != nullptr;
                DrawQuad(handle, cx - size * 0.5f, cy - size * 0.5f, size, size, kIconSize, kIconSize,
                         have ? alpha : alpha / 3, have ? 0x80 : 0x50);
            }
            // The slot whose item is equipped now wears the active item's cursor round its picture.
            CGameDataUsed *equipped = RowEquip(chara, slot / 2);
            if (equipped != nullptr && Matches(entry, equipped)) {
                const float cx = x0 + w * 0.5f + h * 0.14f, cy = y0 + h * 0.5f + h * 0.02f;
                DrawHalo(cx, cy, h * 1.2f, (float) fade / kFadeTicks);
            }
        }
    }
}

void PortQuickLoadoutReset() {
    Close();
    fade = 0;
    pictures.clear();
    reloading = false;
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
