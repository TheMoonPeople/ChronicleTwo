#pragma once

#include <optional>

#include "gfx/gfx.hpp"

class CMenuPosDataForm;
struct MENU_INIT_ARG;

/**
 * The paused world behind the Item pages: the main menu waits while the camera frames the player, the frame is
 * kept at window resolution, and the live menu character is drawn standing where the player stood.
 */
namespace menuworld {

/**
 * True while MenuMainInit must not run yet: a main menu is waiting for the camera to frame the player.
 */
bool HoldMenuInit(MENU_INIT_ARG *arg);

/**
 * Advances the framing once the world tick has drawn, and opens the waiting menu when the frame is ready.
 */
void AfterWorldDraw();

/**
 * Keeps the framed world at window resolution, once per menu, and returns the frame the retail grab copies: the
 * world as the menu was asked for at that first grab, the frame just finished otherwise.
 */
gfx::TextureHandle TakeMenuGrab();

/**
 * Restores the camera and the player as the main menu closes.
 */
void MenuClosed();

/**
 * True while the camera is held for the framing, whose depth of field would blur the whole picture.
 */
bool Framing();

/**
 * True while the Item page shows the paused world behind its panels.
 */
bool ItemBackdrop();

/**
 * While alive, an Item page draw spreads its panels and draws the paused world in place of its black fill.
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
 * Draws the paused world for the Item page's black fill; false for any other fill.
 */
bool FillWithBackdrop();

/**
 * Opacity of the paused world as the Item page's frame slides back to the main menu.
 */
int ItemBackdropAlpha();

/**
 * Sets the view the menu character is drawn through; false leaves it to the menu's own camera.
 */
bool ViewMenuCharacter();

/**
 * True for the Item page's retail backdrop forms, which the paused world replaces.
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
 * The anchor of the Item page's selection frame, which moves whole with the panel it is on.
 */
std::optional<gfx::UiAnchor> SelectionAnchor();

/**
 * The retail layout's x under a pointer at logical x on the spread Item page.
 */
float RetailPointerX(float x);

/**
 * Where a retail layout x of the Item page is shown once its panels spread.
 */
float SpreadX(float retail_x);

} // namespace menuworld
