#pragma once

#include "gfx/gfx.hpp"

class mgCTexture;

/**
 * Reports whether native model rendering is enabled for plain item icons.
 */
bool ItemIcons3DEnabled();
/**
 * Returns a cached model-rendered icon, or null when the original icon sheet should be used.
 */
mgCTexture *ItemIcon3DTexture(int item_no);
/**
 * Releases icon textures and cached results before changing gameplay mode or renderer lifetime.
 */
void ItemIcons3DReset();
/**
 * Draws the item's model into target, a size x size render target the caller keeps (the dungeon's quick loadout),
 * whatever DC2_ITEM_ICONS_3D says. False where the item has no model or the renderer cannot draw now (outside a frame).
 * Leaves the camera, projection and lights as found.
 */
bool ItemIcon3DRenderTo(int item_no, gfx::TextureHandle target, int size);
