#pragma once

#include <optional>
#include <unordered_set>

#include "gfx/gfx.hpp"

class CActionChara;
class CMenuPosDataForm;
struct MENU_INIT_ARG;

namespace gfx {
struct DisplayList;
}

/**
 * The paused world behind the Item pages. The town and dungeon main menus capture it once as they open: the full
 * picture, and a copy with the player left out, both rendered from the same recorded frame. The Items page uses
 * that capture as its backdrop, and the orb transitions into and out of Items are driven from here.
 */
namespace menuworld {

/**
 * Interpolation key that tags the 2D draws of the player's effects on the dungeon pause frame.
 */
inline constexpr gfx::InterpKey kPlayerEffectKey = 0x504C415945464643;

/**
 * What the playerless picture leaves out of the recorded frame.
 */
struct PlayerlessFilter {
    std::unordered_set<gfx::InterpKey> keys;                               /**< Meshes of the player, its shadows, outlines and effect scripts. */
    std::unordered_set<gfx::InterpKey> trailing_run_keys;                  /**< Meshes left out only as the last contiguous run they form. */
    gfx::TextureHandle                 outline_target = gfx::kNullTexture; /**< Render target the outline composites sample, or none. */
};

/**
 * Writes the replay that renders the captured frame without the player: the entries that survive the filter, a copy
 * of the picture into clean, then every entry of the frame as it was recorded.
 */
void BuildPlayerlessReplay(const gfx::DisplayList &source, const PlayerlessFilter &filter, gfx::TextureHandle clean,
                           gfx::DisplayList &replay);

/**
 * Tags the 2D draws made while it is alive as the player's effects when the dungeon pause frame is recorded.
 */
class PlayerEffectScope {
public:
    explicit PlayerEffectScope(bool player_owned);
    PlayerEffectScope(const PlayerEffectScope &) = delete;
    PlayerEffectScope &operator=(const PlayerEffectScope &) = delete;

private:
    std::optional<gfx::Interp2DScope> tag; /**< Tag of the draws, present only on the dungeon pause frame. */
};

/**
 * True on the dungeon frame that opens the main menu, while its world is still being recorded.
 */
bool PausingDungeonFrame();

/**
 * The player whose effects are drawn on the dungeon pause frame, or null on any other frame.
 */
const CActionChara *PausingPlayer();

/**
 * Renders the captured frame once with the player's meshes omitted, then the full frame it was recorded from.
 */
bool RenderPauseFrame(const gfx::DisplayList &source);

/**
 * Captures the paused world when the town or dungeon main menu opens; other menus leave the world alone.
 */
void MenuOpening(const MENU_INIT_ARG *arg);

/**
 * Keeps the framed world at window resolution, once per menu, and returns the frame the retail grab copies: the
 * world as the menu was asked for at that first grab, the frame just finished otherwise.
 */
gfx::TextureHandle TakeMenuGrab();

/**
 * Discards the captured world and restores the camera and the player as the main menu closes.
 */
void MenuClosed();

/**
 * Starts the orb close transition as the main menu opens the Item page, and fades the menu character in unless the page is reopened.
 */
void ItemOpening();

/**
 * While alive, a poly form's menu character draws with the fade-in opacity the Item page has reached.
 */
class CharacterFadeScope {
public:
    explicit CharacterFadeScope(const CMenuPosDataForm &form);
    ~CharacterFadeScope();
    CharacterFadeScope(const CharacterFadeScope &) = delete;
    CharacterFadeScope &operator=(const CharacterFadeScope &) = delete;

private:
    CActionChara *chara = nullptr; /**< Character whose parts were given the fade opacity; null when none was. */
};

/**
 * Chooses the orb open transition when the Item page returns to the main menu.
 */
int FrameMode(int requested);

/**
 * Tracks the orb's progress after each native frame step, and ends the entry once the orb has closed.
 */
void FrameStepped();

/**
 * True while the Item page shows the captured world behind its panels.
 */
bool ItemBackdrop();

/**
 * While alive, an Item page draw spreads its panels and draws the captured world in place of its black fill.
 */
class ItemDrawScope {
public:
    ItemDrawScope();
    ~ItemDrawScope();
    ItemDrawScope(const ItemDrawScope &) = delete;
    ItemDrawScope &operator=(const ItemDrawScope &) = delete;

private:
    std::optional<gfx::UiAnchorScope> anchor; /**< The spread of the page's draws. */
};

/**
 * True while a cursor form draws, whose pieces are not clipped to the logical frame.
 */
bool CursorDrawing();

/**
 * While alive, the Item page's cursor forms draw, so their selection frame keeps the cursor's shift rather than its side.
 */
class CursorDrawScope {
public:
    CursorDrawScope();
    ~CursorDrawScope();
    CursorDrawScope(const CursorDrawScope &) = delete;
    CursorDrawScope &operator=(const CursorDrawScope &) = delete;
};

/**
 * Draws the captured world for the Item page's black fill; false for any other fill.
 */
bool FillWithBackdrop();

/**
 * Draws the orb miniature of the captured world while the Item page is entering; false leaves the retail orb to draw.
 */
bool DrawOrbPicture();

/**
 * Opacity, out of 128, at which the player is still drawn over the captured world as the orb closes into Items.
 */
int PlayerDissolveAlpha();

/**
 * Sets the view the menu character is drawn through; false leaves it to the menu's own camera.
 */
bool ViewMenuCharacter();

/**
 * True for the Item page's retail backdrop forms, which the captured world replaces.
 */
bool HidesForm(const CMenuPosDataForm &form);

/**
 * The fixed split between the Item page's character and bag panels.
 */
float ItemPanelSplit(const CMenuPosDataForm *board);

/**
 * The side a form occupies at its inward action's resting position.
 */
int ItemPanelSide(const CMenuPosDataForm &form, float split);

/**
 * True for common menu forms that retain their own coordinates as the Item page closes.
 */
bool RootChromeUnanchored(const CMenuPosDataForm &form);

/**
 * The anchor an Item page form is drawn with, or none outside the spread Item page.
 */
std::optional<gfx::UiAnchor> FormAnchor(const CMenuPosDataForm &form);

/**
 * The anchor of the Item page's selection frame, which moves whole with the panel it is on; none within a cursor form.
 */
std::optional<gfx::UiAnchor> SelectionAnchor();

/**
 * True for the Item page's cursor forms, which move with the cursor across the spread.
 */
bool CursorForm(const CMenuPosDataForm &form);

/**
 * False while the Item page's cursor waits for the orb and the panels to settle, or while the orb returns.
 */
bool CursorShown();

/**
 * The x shift the Item page's cursor forms are drawn with at retail x, easing from the left panels' shift to the right's.
 */
float CursorShift(float x);

/**
 * The x shift every cursor piece is drawn with, taken from the selection frame so the hand and frame move as one.
 */
float CursorFrameShift();

/**
 * The retail layout's x under a pointer at logical x on the spread Item page.
 */
float RetailPointerX(float x);

/**
 * Maps a pointer x on the spread Item page, with the left panels moved by shift (zero or negative) and the
 * right ones by -shift about split, back to the retail layout; the gap between them is off the layout, or the
 * bag's first column while an item is held.
 */
float SpreadPointerX(float x, float shift, float split, bool holding);

/**
 * Where a retail layout x of the Item page is shown once its panels spread.
 */
float SpreadX(float retail_x);

} // namespace menuworld
