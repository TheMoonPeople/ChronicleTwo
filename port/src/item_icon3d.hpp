#pragma once

#include "gfx/gfx.hpp"

class mgCTexture;

// The menu's item icons drawn as the item's own 3D model instead of the picture on the icon sheet. Off unless
// DC2_ITEM_ICONS_3D is set. Returns a 32x32 texture that holds the model rendered small, or null where the item has no
// model of its own (then the sheet's picture is used) or the renderer cannot draw one now (outside a frame).
bool        ItemIcons3DEnabled();
mgCTexture *ItemIcon3DTexture(int item_no);

// The item's model drawn into target, a size x size render target the caller keeps (the dungeon's quick loadout),
// whatever DC2_ITEM_ICONS_3D says. model_block is emptied and used while drawing; scratch_block holds the scratch
// picture the model is drawn into first. False where the item has no model or the renderer cannot draw now (outside a
// frame). Leaves the camera and lights as found.
bool ItemIcon3DRenderTo(int item_no, gfx::TextureHandle target, int size, int model_block, int scratch_block);

// With DC2_ITEM_ICONS_3D_SHEET=<png path>, every item's icon is drawn at four times its size into one sheet, as the
// first icon is asked for, and this writes it (and a list of the items in its order, beside it) at the screenshot.
void ItemIcons3DDumpSheet();
