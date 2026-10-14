#pragma once
#include <cstdint>
#include <string_view>
#include "gfx/gfx.hpp"
#include "texture_color.hpp"
class mgCTexture;
struct MgTextureHandles {
    gfx::TextureHandle texture = gfx::kNullTexture;
    gfx::TextureHandle palette = gfx::kNullTexture;
};
// TBP0 and CBP of a registered texture hold its registry key, not a VRAM address. Keys are handed out
// downward from the top of the 14-bit field so they stay clear of the frame buffers' addresses.
inline constexpr uint32_t kMgTextureKeyFirst = 0x3FFF;
inline constexpr uint32_t kMgTextureKeyLast = 0x2800;
// Uploads on first use and again once a texture's RGBA pixels change; null handles before RendererInit.
MgTextureHandles MgTextureLookup(const mgCTexture *texture);
// RGBA image from TBP0's texture.
MgTextureHandles MgTextureLookupTex0(uint64_t tex0);
// Refreshes CPU RGBA images changed in place without changing the registry key.
void MgTexturePixelsChanged(const mgCTexture *texture);
// Selects a pre-baked RGBA variant by the palette source name from catalog metadata.
bool MgTextureSelectVariant(mgCTexture *texture, std::string_view palette_source);
std::string_view MgTexturePaletteSource(const mgCTexture *texture);
int MgTextureSourceBpp(const mgCTexture *texture);
/**
 * Describes a padded texture canvas in texels.
 */
struct MgTextureExtent {
    uint32_t width = 0; /**< Padded canvas width. */
    uint32_t height = 0; /**< Padded canvas height. */
};
/**
 * Returns the host canvas while game dimensions and TEX0 retain retail units.
 */
MgTextureExtent MgTexturePhysicalExtent(const mgCTexture *texture);
/**
 * Gives a non-catalog texture scale x scale host texels per retail texel (the camera's capture target).
 */
void MgTextureSetPhysicalScale(const mgCTexture *texture, uint32_t scale);
/**
 * Returns the retail padded canvas encoded by TEX0.
 */
MgTextureExtent MgTextureLogicalExtent(uint64_t tex0);
/**
 * Returns the host canvas associated with a registered TEX0 key.
 */
MgTextureExtent MgTexturePhysicalExtent(uint64_t tex0);
/**
 * Returns the physical scale of a registered image relative to its retail texels.
 */
float MgTextureImageScale(gfx::TextureHandle image);
/**
 * Copies or clears a logical rectangle while preserving high-resolution RGBA detail.
 */
bool MgTextureCopyRegion(const mgCTexture *source, int sx, int sy, mgCTexture *destination,
                         int dx, int dy, int width, int height);
/**
 * Gives an empty animation destination enough physical texels to retain source detail.
 */
void MgTexturePrepareAnimationDestination(const mgCTexture *source, mgCTexture *destination);
