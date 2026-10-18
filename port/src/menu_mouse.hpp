#pragma once

#include <cstdint>
#include <span>
#include <vector>

#include "gfx/gfx.hpp"

struct MenuMouseRect {
    float              x, y, w, h;
    [[nodiscard]] bool Contains(float px, float py) const;
};

struct MenuMouseSample {
    float         x = 256, y = 224, wheel = 0;
    bool          pointing = false, moved = false;
    std::uint32_t clicked = 0, released = 0, held = 0;
};

// The part of a hit rectangle inside a list's scissor; empty when none of it is.
MenuMouseRect MenuMouseClip(MenuMouseRect rect, MenuMouseRect clip);

struct MenuMouseView {
    int top = 0, selected = 0;
};

// Wheel notches scroll a list by whole rows. The cursor takes the row that comes under the pointer
// (hovered, counted from the first shown row, or -1), or else stays in view.
MenuMouseView MenuMouseScroll(float wheel, MenuMouseView view, int count, int visible, int hovered);

// Relative window pixels map through the same logical extent as the menu art.
float MenuMouseUnits(float scale, float pixels, float window);
int   MenuMouseHit(std::span<const MenuMouseRect> rows, float x, float y);
int   MenuMouseChoose(const MenuMouseSample &mouse, std::span<const MenuMouseRect> rows, int selected, int wheel_step = 1);
// Whole wheel notches move selected by wheel_step per notch, clamped to [0, count).
int MenuMouseWheelStep(int selected, float wheel, int count, int wheel_step = 1);
class CMenuPosDataForm;
struct MENUFORMPARTS_TYPE;
// The form's part called name, or null. Unlike GetPartInfo this skips freed parts,
// whose names are null, so it is safe for a name the form does not have.
MENUFORMPARTS_TYPE *MenuMouseFindPart(CMenuPosDataForm *form, const char *name);
// A drawn form part's rectangle; empty when the form or the part is hidden or missing.
MenuMouseRect MenuMousePart(CMenuPosDataForm *form, const char *name);
class ClsMes;
std::vector<MenuMouseRect> MenuMouseMessageRows(ClsMes &message, int count);
// The pad button a drawn message line's leading symbol shows, or 0, and the bounds of that placed line.
int           MenuMouseLabelButton(const ClsMes &message, int line);
MenuMouseRect MenuMouseLabelRect(const ClsMes &message, int line);
// Mouse1 confirms and Mouse2 cancels in the retail layout for the language: Japanese swaps Cross and Circle.
int  MenuMouseLanguageButtons(int buttons, int language);
void MenuMouseLanguageClicks();

void                   MenuMouseEnable(bool enabled);
const MenuMouseSample &MenuMouseTake();
int                    MenuMouseButtons();
void                   MenuMousePress(int buttons);
void                   MenuMouseMove(int *cursor, int selected);
// The retail cursor-move sound for an adapter that sets a retail cursor itself, at most once a tick.
// Cursors moved through MenuMouseMove or a synthesized D-pad press sound in the retail key step.
void MenuMouseCursorSound();
// How many cursor sounds the mouse has played, for tests.
int MenuMouseCursorSounds();
// How many cursor sounds any menu has played through MenuSePlay, retail or mouse, for tests.
int MenuCursorSounds();
// Drawn choice geometry is copied, never a retained pointer to game storage.
void MenuMouseNoteChoices(const void *owner, int message, std::span<const MenuMouseRect> rows,
                          int selected, bool horizontal);
// Claims this frame's clicks. A left click outside every row cannot confirm.
int MenuMouseRows(std::span<const MenuMouseRect> rows, int selected, int wheel_step = 1);
// Keep a click through a retail list's cursor-settling delay.
void             MenuMouseDelayConfirm(const void *owner, int selected, int target, int ticks);
void             MenuMouseDraw();
inline constexpr gfx::InterpKey kMenuMouseHandKey = 0x4d454e5548414e44;
bool                            MenuMousePointerVisible();
MenuMouseSample                 MenuMouseDisplaySample();
// The pointer keeps one facing, so a mirrored retail hand (Max on the Character page) passes no facing.
gfx::InterpKey MenuMouseNoteHand(const gfx::TextureBinding &texture, gfx::LogicalRect uv,
                                 float rotation = 0, int alpha = 128, float scale = 1);

// Exclusive adapters translate this sampled frame into retail buttons.
void MenuMouseSetButtons(int buttons);
// Like MenuMouseSetButtons, for a screen drawn over choice windows: it also drops the target and
// confirmation this tick's sample gave them, so nothing acts on them once the screen closes.
void MenuMouseClaimButtons(int mask);

class CSaveMenuClass;
void MenuMouseSave(CSaveMenuClass &save);

gfx::InterpKey MenuMouseNextHandKey();
gfx::InterpKey MenuMouseReplacedHandKey();
class CMenuOption;
class CMenuPosDataForm;
// Retail Options targets are drawn buttons inside the list's clip form (clip0), when given.
bool MenuMouseOption(CMenuOption &menu, CMenuPosDataForm *form, const CMenuPosDataForm *clip = nullptr);
// Hover moves the retail Options cursor to a row or button; the wheel scrolls its rows.
void MenuMouseOptionHover(CMenuOption &menu, CMenuPosDataForm *form, const CMenuPosDataForm *clip);
// Character page portraits: hover selects, a click on a portrait confirms.
int MenuMouseCharaSelect(CMenuPosDataForm &form, unsigned party, int npc_no, int select);
// What the mouse drives on the Character page in a retail state.
enum class MenuMouseCharaInput {
    Retail,      // Any-button waits and drawn message choices keep the shared mouse.
    Portraits,   // Hover selects a portrait; only a portrait click confirms.
    Locked,      // A character change is loading; left clicks do nothing.
    RepairBoard, // Cedric's item board: hover and wheel select; only an item click confirms.
};
MenuMouseCharaInput MenuMouseCharaInputFor(int mode, int sub_menu, int page, int step, int change_phase, int open_wait);
void                MenuMouseRepairBoard(CMenuPosDataForm *board, int &select, int &top, int count);
class CMenuChrCngMenu;
void MenuMouseChara(CMenuChrCngMenu &menu);
// Help: entries follow hover and scroll with the wheel; the wheel turns picture pages.
class CManualMenu;
void MenuMouseManual(CManualMenu &menu, CMenuPosDataForm *background, const CMenuPosDataForm *clip);
