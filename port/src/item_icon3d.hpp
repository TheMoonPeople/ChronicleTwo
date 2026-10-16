#pragma once

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
