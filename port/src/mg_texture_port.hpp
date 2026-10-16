#pragma once
#include <cstddef>
#include <cstdint>
#include <functional>
#include <string>
#include <string_view>

#include "gfx/gfx.hpp"
#include "platform/texture_catalog.hpp"
#include "texture_color.hpp"
class mgCTexture;
class mgCTextureManager;
class mgCEnterIMGInfo;
class mgCMemory;

namespace datapacks {
struct DecodedTexture;
}

/** Decodes a native set's selected image into a host RGBA canvas. */
using MgTextureImageDecoder = std::function<bool(const texture_catalog::Entry &, std::size_t,
                                                 datapacks::DecodedTexture &, std::string &)>;
/** Names the exact pixels the decoder produces for an entry's variant, or returns an empty string when unknown. */
using MgTextureImageIdentity = std::function<std::string(const texture_catalog::Entry &, std::size_t)>;

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
/**
 * Selects the image associated with a logical animation identity.
 */
bool MgTextureSelectVariant(mgCTexture *texture, std::string_view selector);
/**
 * Returns the identity of the currently selected image.
 */
std::string_view MgTextureVariantSelector(const mgCTexture *texture);
/**
 * Refreshes loaded button glyphs when the selected style or active device changes.
 */
void MgTextureRefreshButtonGlyphs();
/**
 * Returns the update operation used by this animation destination.
 */
texture_catalog::AnimationMode MgTextureAnimationMode(const mgCTexture *texture);
/**
 * Enters a catalog picture into a texture manager using its retail block.
 */
mgCTexture *MgTextureEnterCatalog(mgCTextureManager *manager, int block, const texture_catalog::Entry &entry);
/**
 * Enters every picture and animation in a direct native JSON texture document.
 * Returns the last texture block's offset from the requested block; zero is valid.
 */
int MgTextureEnterDocument(mgCTextureManager *manager, std::string_view relative_json_path, int block,
                           mgCMemory *stack, mgCEnterIMGInfo *info);
/**
 * Enters an embedded texture set after decoding every variant for exact registration identity.
 * The caller keeps the source entries alive until the textures are deleted.
 * Identical native pictures reuse their header; changed content replaces it in place.
 * Variant switches reuse the validated decoded pixels.
 * When identity names every variant, a registered picture with the same semantics and identities is reused
 * without decoding.
 */
int MgTextureEnterNativeSet(mgCTextureManager *manager, int block, const texture_catalog::Source &source,
                            mgCMemory *stack, MgTextureImageDecoder decoder, MgTextureImageIdentity identity = {});

/**
 * Describes a padded texture canvas in texels.
 */
struct MgTextureExtent {
    uint32_t width = 0;  /**< Padded canvas width. */
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
