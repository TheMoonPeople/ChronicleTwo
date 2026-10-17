#pragma once

#include <cstdint>
#include <span>
#include <vector>

#include "gfx/gfx.hpp"

struct MenuMouseRect {
    float x, y, w, h;
    bool  Contains(float px, float py) const;
};

struct MenuMouseSample {
    float         x = 256, y = 224, wheel = 0;
    bool          pointing = false, moved = false;
    std::uint32_t clicked = 0, released = 0, held = 0;
};

// Relative window pixels map through the same logical extent as the menu art.
float MenuMouseUnits(float scale, float pixels, float window);
int   MenuMouseHit(std::span<const MenuMouseRect> rows, float x, float y);
int   MenuMouseChoose(const MenuMouseSample &mouse, std::span<const MenuMouseRect> rows, int selected, int wheel_step = 1);
// Whole wheel notches move selected by wheel_step per notch, clamped to [0, count).
int MenuMouseWheelStep(int selected, float wheel, int count, int wheel_step = 1);
class CMenuPosDataForm;
// A drawn form part's rectangle; empty when the form or the part is hidden or missing.
MenuMouseRect MenuMousePart(CMenuPosDataForm *form, const char *name);
class ClsMes;
std::vector<MenuMouseRect> MenuMouseMessageRows(ClsMes &message, int count);

void                   MenuMouseEnable(bool enabled);
const MenuMouseSample &MenuMouseTake();
int                    MenuMouseButtons();
void                   MenuMousePress(int buttons);
void                   MenuMouseMove(int *cursor, int selected);
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
gfx::InterpKey                  MenuMouseNoteHand(const gfx::TextureBinding &texture, gfx::LogicalRect uv,
                                                  float rotation = 0, int reverse = 0, int alpha = 128, float scale = 1);

// Exclusive adapters translate this sampled frame into retail buttons.
void MenuMouseSetButtons(int buttons);
bool MenuMouseActive();

class CSaveMenuClass;
void MenuMouseSave(CSaveMenuClass &save);

gfx::InterpKey MenuMouseNextHandKey();
gfx::InterpKey MenuMouseReplacedHandKey();
class CMenuOption;
class CMenuPosDataForm;
bool MenuMouseOption(CMenuOption &menu, CMenuPosDataForm *form);
