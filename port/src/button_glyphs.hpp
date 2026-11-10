#pragma once

#include <string>
#include <string_view>

#include "platform/datapacks.hpp"

/**
 * Reports whether a native texture contains replaceable button-symbol cells.
 */
bool ButtonGlyphsTarget(std::string_view texture_name);
/**
 * Stamps shared glyph atlas regions into mutable native texture mip canvases.
 */
void ButtonGlyphsApply(std::string_view texture_name, int logical_width, int logical_height,
                       datapacks::DecodedTexture &decoded);
/**
 * Returns the selected glyph style and relevant keyboard binding identity.
 */
std::string ButtonGlyphsStyle();
/**
 * Releases the shared glyph index and atlas pixels for a subsequent reload.
 */
void ButtonGlyphsReset();
