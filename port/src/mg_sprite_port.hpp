#pragma once

#include "gfx/gfx.hpp"
#include "mg_drawprim_port.hpp"

class mgC3DSprite;

// Replaces mgPortDraw2D as the destination of mgC3DSprite's billboards while set; an empty function restores it. For tests.
void mgPortSet3DSpriteSink(mgPortPrimSink sink);
// Draws the billboards of `sprite`'s open batch (since its last BeginCPSprite) under `interpolation` instead of the tag
// current when the packet is drawn. Without an open batch it does nothing.
void mgPortTag3DSpriteBatch(mgC3DSprite *sprite, const gfx::Interp2D &interpolation);
