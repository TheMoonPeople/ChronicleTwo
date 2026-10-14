#include "common.h"

#include <algorithm>
#include <climits>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <optional>
#include <span>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "platform/texture_catalog.hpp"
#include "platform/datapacks.hpp"
#include "photo_hd.hpp"
#include "texture_source.hpp"

// The rendering seam is installed only once the mglib stream has landed its header.
#if __has_include("mglib_port.hpp")
#include "mglib_port.hpp"
#define MG_TEXTURE_HAS_SEAM 1
#endif

namespace {

/**
 * Keeps physical RGBA detail alongside game-accessible retail-sized mip images.
 */
struct CatalogPixels {
    std::vector<std::vector<uint8_t>> levels; /**< Padded physical RGBA mip canvases. */
    const texture_catalog::Entry *record = nullptr; /**< Catalog entry supplying baked variants. */
    std::string palette_source; /**< Selected variant's palette source name. */
    uint32_t width = 0; /**< Physical base canvas width. */
    uint32_t height = 0; /**< Physical base canvas height. */
    std::vector<std::vector<uint8_t>> logical_levels; /**< Tightly packed retail-sized CPU mip images. */
    std::vector<std::vector<uint8_t>> baseline; /**< CPU mip values before direct game edits. */
};

std::unordered_map<const mgCTexture *, CatalogPixels> catalog_pixels;
bool entering_catalog = false;

struct Entry {
    const mgCTextureManager *owner = nullptr;
    uint32_t                 key = 0;
    gfx::TextureHandle       image = gfx::kNullTexture;
    u_long128               *levels[MG_TEXTURE_LEVEL_MAX] = {};
    int                      width = 0;
    int                      height = 0;
    int                      bpp = 0;
    int                      swizzled = 0;
    int                      tw = 0;
    int                      th = 0;
    bool                     uploaded = false;
    bool                     catalog = false;
    mgCTexture              *draw_variant = nullptr;
    std::vector<uint8_t>     memory16; /**< 16-bit RAM image last uploaded, to notice in-place rewrites. */
    uint32_t                 physical_scale = 1; /**< Host texels per retail texel outside the catalog. */
};

struct TextureRegistry {
    std::unordered_map<const mgCTexture *, Entry> entries;
    std::unordered_map<uint32_t, const mgCTexture *> textures_by_key;
    std::unordered_map<gfx::TextureHandle, const mgCTexture *> textures_by_image;
    std::vector<uint32_t> free_keys;
    uint32_t              next_key = kMgTextureKeyFirst;
};

// Function-local so that a manager initialised during static construction reaches a live registry.
TextureRegistry &Registry() {
    static TextureRegistry registry;
    return registry;
}

uint32_t AllocateKey() {
    TextureRegistry &registry = Registry();

    if (!registry.free_keys.empty()) {
        const uint32_t key = registry.free_keys.back();
        registry.free_keys.pop_back();
        return key;
    }

    if (registry.next_key < kMgTextureKeyLast) {
        return 0;
    }

    return registry.next_key--;
}

void DestroyHandle(gfx::TextureHandle &handle) {
    if (handle != gfx::kNullTexture) {
        gfx::DestroyTexture(handle);
        handle = gfx::kNullTexture;
    }
}

bool RendererUp() {
    return gfx::PipelineCount() != 0;
}

/**
 * Samples the physical canvases into tightly packed retail-sized CPU mip images.
 */
void MakeLogicalPixels(const mgCTexture *texture, CatalogPixels &pixels) {
    pixels.logical_levels.resize(pixels.levels.size());
    const uint32_t scale = pixels.width / (1u << texture->tex0.TW);
    for (size_t mip = 0; mip < pixels.levels.size(); ++mip) {
        const uint32_t width = std::max(1, texture->width >> mip);
        const uint32_t height = std::max(1, texture->height >> mip);
        const uint32_t physical_width = std::max(1u, pixels.width >> mip);
        const uint32_t physical_height = std::max(1u, pixels.height >> mip);
        auto &logical = pixels.logical_levels[mip];
        logical.resize(static_cast<size_t>(width) * height * 4);
        for (uint32_t y = 0; y < height; ++y) for (uint32_t x = 0; x < width; ++x) {
            const uint32_t px = std::min(physical_width - 1, x * scale + scale / 2);
            const uint32_t py = std::min(physical_height - 1, y * scale + scale / 2);
            std::memcpy(logical.data() + (static_cast<size_t>(y) * width + x) * 4,
                        pixels.levels[mip].data() + (static_cast<size_t>(py) * physical_width + px) * 4, 4);
        }
    }
    pixels.baseline = pixels.logical_levels;
}

/**
 * Associates the game's image pointers with the owned retail-sized mip buffers.
 */
void BindLogicalPixels(mgCTexture *texture, CatalogPixels &pixels) {
    for (int mip = 0; mip < MG_TEXTURE_LEVEL_MAX; ++mip) {
        texture->image[mip] = mip < static_cast<int>(pixels.logical_levels.size())
                               ? reinterpret_cast<u_long128 *>(pixels.logical_levels[mip].data()) : nullptr;
    }
}

u_long128 *AsQuadwords(const uint8_t *bytes) {
    return reinterpret_cast<u_long128 *>(const_cast<uint8_t *>(bytes));
}

const uint8_t *AsBytes(const u_long128 *quadwords) {
    return reinterpret_cast<const uint8_t *>(quadwords);
}

int Log2Ceil(int value) {
    int bits = 0;

    for (int power = 1; power < value; power <<= 1) {
        bits++;
    }

    return bits;
}

u_int QuadwordsFor(u_int bytes) {
    return (bytes + 15) / 16;
}

int PsmForBpp(int bpp) {
    switch (bpp) {
        case 4:
            return SCE_GS_PSMT4;
        case 8:
            return SCE_GS_PSMT8;
        case 16:
            return SCE_GS_PSMCT16;
        case 24:
            return SCE_GS_PSMCT24;
        case 32:
            return SCE_GS_PSMCT32;
        default:
            return -1;
    }
}

bool IsMemory16(const mgCTexture *texture, const Entry &entry) {
    return texture->image[0] != nullptr && !entry.catalog && texture->bpp == 16;
}

size_t Memory16Bytes(const mgCTexture *texture) {
    return static_cast<size_t>(std::max(0, static_cast<int>(texture->width))) *
           std::max(0, static_cast<int>(texture->height)) * 2;
}

/**
 * Expands a linear PSMCT16 RAM image (photos stored by mgStoreImage) into RGBA8. The game draws these with
 * TEXA TA0 = TA1 = 0x80, so every texel is opaque (0xFF in the renderer's units) whatever its alpha bit.
 */
std::vector<uint8_t> DecodeMemory16(const mgCTexture *texture) {
    const size_t texels = Memory16Bytes(texture) / 2;
    std::vector<uint8_t> rgba(texels * 4);
    const uint8_t *in = AsBytes(texture->image[0]);
    for (size_t i = 0; i < texels; ++i) {
        const uint32_t texel = in[i * 2] | (static_cast<uint32_t>(in[i * 2 + 1]) << 8);
        const uint32_t r = texel & 0x1F;
        const uint32_t g = (texel >> 5) & 0x1F;
        const uint32_t b = (texel >> 10) & 0x1F;
        rgba[i * 4 + 0] = static_cast<uint8_t>((r << 3) | (r >> 2));
        rgba[i * 4 + 1] = static_cast<uint8_t>((g << 3) | (g >> 2));
        rgba[i * 4 + 2] = static_cast<uint8_t>((b << 3) | (b >> 2));
        rgba[i * 4 + 3] = 0xFF; // The renderer's opaque (GS 0x80).
    }
    return rgba;
}

gfx::TextureHandle UploadMemory16(const mgCTexture *texture, Entry &entry) {
    const uint8_t *raw = AsBytes(texture->image[0]);
    const size_t   bytes = Memory16Bytes(texture);
    entry.memory16.assign(raw, raw + bytes);
    // A camera photo taken on PC also has a sharper copy, found again by its retail bytes.
    const std::vector<uint8_t> *hd = texture->width == 64 && texture->height == 64 ? PhotoHdFind(raw, bytes) : nullptr;
    entry.physical_scale = hd != nullptr ? kPhotoHdSize / 64 : 1;
    const auto extent = MgTexturePhysicalExtent(texture);
    auto handle = gfx::CreateTexture({extent.width, extent.height, gfx::TextureFormat::Rgba8, 1, true});
    if (handle == gfx::kNullTexture) {
        return handle;
    }
    if (hd != nullptr) {
        gfx::UpdateTexture(handle, 0, 0, 0, kPhotoHdSize, kPhotoHdSize, hd->data());
    } else {
        const auto rgba = DecodeMemory16(texture);
        gfx::UpdateTexture(handle, 0, 0, 0, texture->width, texture->height, rgba.data());
    }
    return handle;
}

gfx::TextureHandle UploadPixels(const mgCTexture *texture) {
    const auto extent = MgTexturePhysicalExtent(texture);
    const auto pixels = catalog_pixels.find(texture);
    const uint32_t canvas_width = extent.width;
    const uint32_t canvas_height = extent.height;
    uint32_t levels = 0;
    while (levels < MG_TEXTURE_LEVEL_MAX && texture->image[levels]) {
        ++levels;
    }
    if (levels == 0) {
        levels = 1; // Animation destinations and render targets start empty.
    }
    auto handle = gfx::CreateTexture({canvas_width, canvas_height,
                                      gfx::TextureFormat::Rgba8,
                                      levels, texture->bpp != 24});
    if (handle == gfx::kNullTexture) {
        return handle;
    }
    for (uint32_t mip = 0; mip < levels; ++mip) {
        if (!texture->image[mip]) {
            continue;
        }
        const uint32_t width = pixels != catalog_pixels.end() ? std::max(1u, canvas_width >> mip)
                                                             : std::max(1, texture->width >> mip);
        const uint32_t height = pixels != catalog_pixels.end() ? std::max(1u, canvas_height >> mip)
                                                              : std::max(1, texture->height >> mip);
        gfx::UpdateTexture(handle, mip, 0, 0, width, height,
                           pixels != catalog_pixels.end() ? pixels->second.levels[mip].data()
                                                          : static_cast<const void *>(texture->image[mip]));
    }
    return handle;
}

void TakeSnapshot(const mgCTexture *texture, Entry &entry) {
    for (int i = 0; i < MG_TEXTURE_LEVEL_MAX; i++) {
        entry.levels[i] = texture->image[i];
    }

    entry.width = texture->width;
    entry.height = texture->height;
    entry.bpp = texture->bpp;
    entry.swizzled = texture->swizzled;
    entry.tw = static_cast<int>(texture->tex0.TW);
    entry.th = static_cast<int>(texture->tex0.TH);
}

bool SnapshotChanged(const mgCTexture *texture, const Entry &entry) {
    for (int i = 0; i < MG_TEXTURE_LEVEL_MAX; i++) {
        if (entry.levels[i] != texture->image[i]) {
            return true;
        }
    }

    return entry.width != texture->width || entry.height != texture->height ||
           entry.bpp != texture->bpp || entry.swizzled != texture->swizzled ||
           entry.tw != static_cast<int>(texture->tex0.TW) || entry.th != static_cast<int>(texture->tex0.TH);
}

void Rebuild(const mgCTexture *texture, Entry &entry) {
#if MG_TEXTURE_HAS_SEAM
    if (entry.image != gfx::kNullTexture) mgPortReleaseTextureTarget(entry.key);
#endif
    Registry().textures_by_image.erase(entry.image);
    DestroyHandle(entry.image);
    TakeSnapshot(texture, entry);
    // A picture the decoder rejects is not retried until its pointers change; retrying would decode the
    // same bytes every frame.
    entry.uploaded = true;
    entry.memory16.clear();

    if (IsMemory16(texture, entry)) {
        entry.image = UploadMemory16(texture, entry);
        if (entry.image != gfx::kNullTexture) Registry().textures_by_image[entry.image] = texture;
        return;
    }

    if (texture->image[0] != nullptr && !entry.catalog && texture->bpp != 32) {
        std::fprintf(stderr, "texture: %s has unsupported non-RGBA memory pixels\n", texture->name);
        return;
    }
    entry.image = UploadPixels(texture);
    if (entry.image != gfx::kNullTexture) Registry().textures_by_image[entry.image] = texture;
}

void Resolve(const mgCTexture *texture, Entry &entry, bool) {
    if (!RendererUp()) {
        return;
    }

    if (!entry.uploaded || SnapshotChanged(texture, entry)) {
        Rebuild(texture, entry);
        return;
    }

    // Retail uploads RAM images on every reload; a photo slot is rewritten in place (new shot, sorting).
    if (IsMemory16(texture, entry) &&
        (entry.memory16.size() != Memory16Bytes(texture) ||
         std::memcmp(entry.memory16.data(), AsBytes(texture->image[0]), entry.memory16.size()) != 0)) {
        Rebuild(texture, entry);
    }
}

Entry &Register(const mgCTextureManager *owner, mgCTexture *texture) {
    Entry entry;
    entry.owner = owner;
    entry.catalog = entering_catalog;
    entry.key = AllocateKey();
    texture->tex0.TBP0 = entry.key;
    texture->tex0.CBP = entry.key;

    TextureRegistry &registry = Registry();

    if (entry.key != 0) {
        registry.textures_by_key[entry.key] = texture;
    }

    return registry.entries[texture] = entry;
}

void ReleaseTexture(const mgCTexture *texture) {
    TextureRegistry &registry = Registry();
    const auto       found = registry.entries.find(texture);

    if (found == registry.entries.end()) {
        return;
    }

    Entry &entry = found->second;
    for (auto &[other, registered] : registry.entries) {
        if (registered.draw_variant == texture) registered.draw_variant = nullptr;
    }
#if MG_TEXTURE_HAS_SEAM
    // A registry key can immediately name a different texture; its old rendered pixels cannot.
    mgPortReleaseTextureTarget(entry.key);
#endif
    registry.textures_by_image.erase(entry.image);
    DestroyHandle(entry.image);

    if (entry.key != 0) {
        const auto by_key = registry.textures_by_key.find(entry.key);

        if (by_key != registry.textures_by_key.end() && by_key->second == texture) {
            registry.textures_by_key.erase(by_key);
        }

        registry.free_keys.push_back(entry.key);
    }

    registry.entries.erase(found);
    catalog_pixels.erase(texture);
}

void ReleaseOwned(const mgCTextureManager *owner) {
    std::vector<const mgCTexture *> owned;

    for (const auto &[texture, entry] : Registry().entries) {
        if (entry.owner == owner) {
            owned.push_back(texture);
        }
    }

    for (const mgCTexture *texture : owned) {
        ReleaseTexture(texture);
    }
}

void ResolveTexture(const mgCTexture *texture, bool palette_changed) {
    TextureRegistry &registry = Registry();
    const auto       found = registry.entries.find(texture);

    if (found != registry.entries.end()) {
        Resolve(texture, found->second, palette_changed);
    }
}

void ResolveBlock(const mgCTextureBlock &block) {
    for (const mgCTexture *texture = block.texture; texture != nullptr; texture = texture->next) {
        ResolveTexture(texture, false);
    }
}

// Retail restores RAM images whenever it selects another block, before animating it.
// Persistent host textures only need that restoration for animation destinations: in particular,
// the open-eye record copies the face onto itself and relies on the upload undoing the last blink.
void RestoreAnimatedTextures(const mgCTextureBlock &block, int index) {
    if (block.anime == nullptr) {
        return;
    }

    std::unordered_set<const mgCTexture *> restored;
    for (int group = 0; group < block.anime->group_num; ++group) {
        // Disabled groups can have left an expression behind, so include their destinations too.
        for (auto *node = block.anime->list[group]; node != nullptr; node = node->next) {
            const mgCTexture *texture = node->data.dest_tex;
            if (texture == nullptr || texture->block != index || !restored.insert(texture).second) {
                continue;
            }

            if (texture->image[0] == nullptr) continue;

            MgTexturePixelsChanged(texture);
#ifdef MG_TEXTURE_HAS_SEAM
            // Sprite animations draw into a registered target rather than the decoded image.
            // Keep both handles stable, and seed that target again in the recorded draw order.
            const auto source = MgTextureLookup(texture).texture;
            const auto target = mgPortFindTexture(texture).texture;
            if (source != target) {
                const auto extent = MgTexturePhysicalExtent(texture);
                const int scale = extent.width / (1u << texture->tex0.TW);
                const gfx::Rect whole{0, 0, texture->width * scale, texture->height * scale};
                gfx::BlitTexture(source, whole, target, whole, gfx::Filter::Nearest);
            }
#endif
        }
    }
}

const mgCTexture *TextureForKey(uint32_t key) {
    const auto &by_key = Registry().textures_by_key;
    const auto  found = by_key.find(key);
    return found == by_key.end() ? nullptr : found->second;
}

#ifdef MG_TEXTURE_HAS_SEAM
mgPortTexture SeamTexture(const mgCTexture *texture) {
    const MgTextureHandles handles = MgTextureLookup(texture);
    return {handles.texture, handles.palette};
}

mgPortTexture SeamTex0(uint64_t tex0) {
    const MgTextureHandles handles = MgTextureLookupTex0(tex0);
    return {handles.texture, handles.palette};
}

void InstallSeam() {
    mgPortSetTextureLookup(SeamTexture, SeamTex0);
}
#else
void InstallSeam() {}
#endif

std::string DecodeName(const std::string &encoded);

mgCTexture *EnterCatalog(mgCTextureManager *manager, int block, const texture_catalog::Entry &record) {
    std::string error;
    datapacks::DecodedTexture decoded;
    if (!datapacks::Decode(record, 0, decoded, error)) {
        std::fprintf(stderr, "texture: %s: %s\n", record.name.c_str(), error.c_str());
        return nullptr;
    }
    CatalogPixels pixels{std::move(decoded.levels), &record, record.name, decoded.width, decoded.height};
    u_long128 *levels[MG_TEXTURE_LEVEL_MAX] = {};
    if (!record.no_image) {
        for (size_t mip = 0; mip < pixels.levels.size(); ++mip) {
            levels[mip] = reinterpret_cast<u_long128 *>(pixels.levels[mip].data());
        }
    }
    std::string name = DecodeName(record.name);
    if (record.picture > 0) {
        name += "#picture" + std::to_string(record.picture);
    }
    entering_catalog = true;
    mgCTexture *texture = manager->EnterTexture(block, const_cast<char *>(name.c_str()), levels,
                                                 record.width, record.height, record.bpp, nullptr,
                                                 record.tex1, record.swizzled);
    entering_catalog = false;
    if (texture != nullptr) {
        MakeLogicalPixels(texture, pixels);
        catalog_pixels.insert_or_assign(texture, std::move(pixels));
        BindLogicalPixels(texture, catalog_pixels.at(texture));
        texture->clamp_bits = record.clamp;
        ResolveTexture(texture, false);
    }
    return texture;
}

std::string DecodeName(const std::string &encoded) {
    std::string name;
    for (size_t i = 0; i < encoded.size(); ++i) {
        if (encoded[i] == '%' && i + 2 < encoded.size()) {
            auto hex = [](char c) -> int {
                if (c >= '0' && c <= '9') return c - '0';
                if (c >= 'A' && c <= 'F') return c - 'A' + 10;
                if (c >= 'a' && c <= 'f') return c - 'a' + 10;
                return -1;
            };
            const int hi = hex(encoded[i + 1]), lo = hex(encoded[i + 2]);
            if (hi >= 0 && lo >= 0) {
                name.push_back(static_cast<char>((hi << 4) | lo));
                i += 2;
                continue;
            }
        }
        name.push_back(encoded[i]);
    }
    return name;
}

void ApplyAnimation(mgCTextureManager *manager, const texture_catalog::Entry &entry, mgCMemory *stack) {
    if (!stack) {
        return;
    }
    mgCTexAnimeData data;
    std::string group_name;
    int enabled = 0, bug_patch = 0;
    std::unordered_map<mgCTextureAnime *, int> active_groups;
    for (const auto &command : entry.script) {
        const auto &args = command.args;
        auto number = [&args](size_t index, double fallback = 0) -> double {
            return index < args.size() && !args[index].text ? args[index].number : fallback;
        };
        auto named = [&args](size_t index) -> std::string {
            return index < args.size() && args[index].text ? DecodeName(*args[index].text) : std::string{};
        };
        const std::string &op = command.name;
        if (op == "TEX_ANIME") {
            group_name = named(0);
            enabled = static_cast<int>(number(1));
        } else if (op == "TEX_ANIME_DATA") {
            data.Initialize();
            data.type = static_cast<signed char>(number(0));
            data.bug_patch = bug_patch;
        } else if (op == "SRC_TEX") {
            std::string name = named(0);
            data.src_tex = manager->GetTexture(name.data(), -1);
            data.src_x = static_cast<short>(number(1) * 16);
            data.src_y = static_cast<short>(number(2) * 16);
            data.src_w = static_cast<short>(number(3) * 16);
            data.src_h = static_cast<short>(number(4) * 16);
        } else if (op == "DEST_TEX") {
            std::string name = named(0);
            data.dest_tex = manager->GetTexture(name.data(), -1);
            data.dest_x = static_cast<short>(number(1) * 16);
            data.dest_y = static_cast<short>(number(2) * 16);
            data.dest_w = args.size() > 3 ? static_cast<short>(number(3) * 16) : data.src_w;
            data.dest_h = args.size() > 4 ? static_cast<short>(number(4) * 16) : data.src_h;
            if (args.size() > 5) data.bilinear = static_cast<signed char>(number(5));
        } else if (op == "SCROLL") {
            if (data.type == MG_TEX_ANIME_TYPE_SCROLL) {
                const double sx = number(0) * 16;
                const double sy = number(1) * 16;
                data.period_x = sx == 0 ? 0 : static_cast<short>((data.dest_w - 16) / sx);
                data.period_y = sy == 0 ? 0 : static_cast<short>((data.dest_h - 16) / sy);
            } else if (data.type == MG_TEX_ANIME_TYPE_WAVE) {
                for (int axis = 0; axis < 2; ++axis) {
                    const double value = number(axis);
                    const int whole = static_cast<int>(value);
                    const double fraction = value - whole;
                    (axis == 0 ? data.period_x : data.period_y) = static_cast<short>(whole);
                    (axis == 0 ? data.amplitude_x : data.amplitude_y) =
                        static_cast<short>(std::abs(fraction) < 0.001 ? 10000 : static_cast<int>(fraction * 10000));
                }
            }
        } else if (op == "CLUT_COPY") {
            data.clut_copy = static_cast<signed char>(number(0));
        } else if (op == "COLOR") {
            if (args.size() > 0) data.r = static_cast<u_char>(number(0));
            if (args.size() > 1) data.g = static_cast<u_char>(number(1));
            if (args.size() > 2) data.b = static_cast<u_char>(number(2));
            if (args.size() > 3) data.a = static_cast<u_char>(number(3));
        } else if (op == "ALPHA_BLEND") {
            if (!args.empty()) data.alpha_blend = static_cast<signed char>(number(0));
        } else if (op == "ALPHA_TEST") {
            if (!args.empty()) data.alpha_test = static_cast<signed char>(number(0));
            if (args.size() > 1) data.alpha_ref = static_cast<u_char>(number(1));
        } else if (op == "WAIT") {
            data.wait = number(1) != 0 ? MG_TEX_ANIME_WAIT_FOREVER : static_cast<short>(number(0));
        } else if (op == "BUG_PATCH") {
            bug_patch = 1;
        } else if (op == "TEX_ANIME_END") {
            active_groups.clear();
        } else if (op == "TEX_ANIME_DATA_END") {
            mgCTexture *texture = data.src_tex ? data.src_tex : data.dest_tex;
            if (!texture || !data.src_tex || !data.dest_tex) continue;
            mgCTextureBlock *block = manager->GetTextureBlock(texture->block);
            if (!block) continue;
            if (!block->anime) block->anime = new (stack->Alloc(0x21)) mgCTextureAnime;
            auto *anime = block->anime;
            auto found = active_groups.find(anime);
            const bool new_group = found == active_groups.end();
            int group = new_group ? anime->GetEmptyGroup() : found->second;
            if (group < 0) continue;
            active_groups[anime] = group;
            data.group = static_cast<signed char>(group);
            if (new_group) {
                char *name = reinterpret_cast<char *>(stack->Alloc((group_name.size() + 1) / MG_TEX_ANIME_NAME_ALLOC_UNIT + 1));
                std::memcpy(name, group_name.c_str(), group_name.size() + 1);
                anime->SetGroupName(group, name);
                if (enabled) anime->Enable(group); else anime->Disable(group);
            }
            anime->EnterTexAnime(&data, stack);
        }
    }
}

} // namespace

void MgTexturePixelsChanged(const mgCTexture *texture) {
    const auto found = Registry().entries.find(texture);
    if (found == Registry().entries.end()) {
        return;
    }
    Entry &entry = found->second;
    if (auto stored = catalog_pixels.find(texture); stored != catalog_pixels.end()) {
        auto &pixels = stored->second;
        if (!pixels.logical_levels.empty() &&
            texture->image[0] != reinterpret_cast<u_long128 *>(pixels.logical_levels[0].data())) {
            // A game-owned RAM buffer replaces the converted image in full.
            pixels.width = 1u << texture->tex0.TW;
            pixels.height = 1u << texture->tex0.TH;
            pixels.levels.clear();
            for (int mip = 0; mip < MG_TEXTURE_LEVEL_MAX && texture->image[mip]; ++mip) {
                const uint32_t width = std::max(1, texture->width >> mip);
                const uint32_t height = std::max(1, texture->height >> mip);
                const uint32_t canvas_width = std::max(1u, pixels.width >> mip);
                auto &level = pixels.levels.emplace_back(static_cast<size_t>(canvas_width) *
                                                         std::max(1u, pixels.height >> mip) * 4);
                for (uint32_t y = 0; y < height; ++y) {
                    std::memcpy(level.data() + static_cast<size_t>(y) * canvas_width * 4,
                                AsBytes(texture->image[mip]) + static_cast<size_t>(y) * width * 4, width * 4);
                }
            }
            MakeLogicalPixels(texture, pixels);
            BindLogicalPixels(const_cast<mgCTexture *>(texture), pixels);
            entry.uploaded = false;
        } else {
            const uint32_t scale = pixels.width / (1u << texture->tex0.TW);
            for (size_t mip = 0; mip < pixels.logical_levels.size(); ++mip) {
                auto &logical = pixels.logical_levels[mip];
                auto &baseline = pixels.baseline[mip];
                const uint32_t width = std::max(1, texture->width >> mip);
                const uint32_t physical_width = std::max(1u, pixels.width >> mip);
                const uint32_t physical_height = std::max(1u, pixels.height >> mip);
                for (size_t offset = 0; offset < logical.size(); offset += 4) {
                    if (std::memcmp(logical.data() + offset, baseline.data() + offset, 4) == 0) continue;
                    const uint32_t x = (offset / 4 % width) * scale;
                    const uint32_t y = (offset / 4 / width) * scale;
                    for (uint32_t py = y; py < std::min(y + scale, physical_height); ++py)
                        for (uint32_t px = x; px < std::min(x + scale, physical_width); ++px)
                            std::memcpy(pixels.levels[mip].data() + (static_cast<size_t>(py) * physical_width + px) * 4,
                                        logical.data() + offset, 4);
                }
                baseline = logical;
            }
        }
    }
    if (!RendererUp()) {
        entry.uploaded = false;
        return;
    }
    if (!entry.uploaded || SnapshotChanged(texture, entry) || entry.image == gfx::kNullTexture) {
        Rebuild(texture, entry);
        return;
    }
    // Retain the handles already referenced by recorded draws. Updates are ordered in the
    // draw stream, so an equipment change cannot retire an earlier frame's icon texture.
    if (entry.catalog || texture->bpp == 32) {
        for (int mip = 0; mip < MG_TEXTURE_LEVEL_MAX && texture->image[mip]; ++mip) {
            const auto extent = MgTexturePhysicalExtent(texture);
            const bool padded = catalog_pixels.contains(texture);
            gfx::UpdateTexture(entry.image, mip, 0, 0,
                               padded ? std::max(1u, extent.width >> mip) : std::max(1, texture->width >> mip),
                               padded ? std::max(1u, extent.height >> mip) : std::max(1, texture->height >> mip),
                               padded ? static_cast<const void *>(catalog_pixels.at(texture).levels[mip].data())
                                      : static_cast<const void *>(texture->image[mip]));
        }
    }
}

mgCTexture *MgTextureCreateColorVariant(const mgCTexture *source, char *name, MgTextureColorMode mode) {
    if (!source || !source->image[0] || source->bpp != 32 || source->width <= 0 || source->height <= 0) {
        return nullptr;
    }
    const auto found = Registry().entries.find(source);
    if (found == Registry().entries.end()) return nullptr;
    auto *manager = const_cast<mgCTextureManager *>(found->second.owner);
    CatalogPixels pixels;
    const auto stored = catalog_pixels.find(source);
    if (stored != catalog_pixels.end()) {
        pixels.levels = stored->second.levels;
        pixels.width = stored->second.width;
        pixels.height = stored->second.height;
    } else {
        pixels.width = 1u << source->tex0.TW;
        pixels.height = 1u << source->tex0.TH;
        pixels.levels.emplace_back(static_cast<size_t>(pixels.width) * pixels.height * 4);
        for (int y = 0; y < source->height; ++y) {
            std::memcpy(pixels.levels[0].data() + static_cast<size_t>(y) * pixels.width * 4,
                        AsBytes(source->image[0]) + static_cast<size_t>(y) * source->width * 4,
                        source->width * 4);
        }
    }
    for (auto &mip_pixels : pixels.levels) {
        for (std::size_t i = 0; i < mip_pixels.size(); i += 4) {
            auto *color = mip_pixels.data() + i;
            const int grey = (color[0] + color[1] + color[2]) / 3;
            switch (mode) {
            case MgTextureColorMode::IconHighlight:
                if (grey > 8 && color[2] != 0) color[2] = 255;
                break;
            case MgTextureColorMode::Grey:
                color[0] = color[1] = color[2] = grey / 16 * 16;
                break;
            case MgTextureColorMode::Sepia: {
                const int level = grey / 16 + 1;
                color[0] = static_cast<u8>(30.0f + 12.2f * level);
                color[1] = static_cast<u8>(20.0f + 8.75f * level);
                color[2] = static_cast<u8>(20.0f + 6.75f * level);
                break;
            }
            case MgTextureColorMode::PartyLocked: {
                const int level = grey / 8 + 1;
                color[0] = static_cast<u8>(7.75f * level);
                color[1] = static_cast<u8>(5.625f * level);
                color[2] = static_cast<u8>(4.6875f * level);
                break;
            }
            }
        }
    }
    u_long128 *images[MG_TEXTURE_LEVEL_MAX] = {};
    for (size_t mip = 0; mip < pixels.levels.size(); ++mip) images[mip] = AsQuadwords(pixels.levels[mip].data());
    entering_catalog = true;
    auto *texture = manager->EnterTexture(source->block, name, images, source->width, source->height,
                                         32, nullptr, source->tex1_bits, 0);
    entering_catalog = false;
    if (texture) {
        MakeLogicalPixels(texture, pixels);
        catalog_pixels.insert_or_assign(texture, std::move(pixels));
        BindLogicalPixels(texture, catalog_pixels.at(texture));
        ResolveTexture(texture, false);
    }
    return texture;
}

void MgTextureSetDrawVariant(const mgCTexture *source, mgCTexture *variant) {
    const auto found = Registry().entries.find(source);
    if (found != Registry().entries.end()) found->second.draw_variant = variant;
}

mgCTexture *MgTextureDrawVariant(mgCTexture *source) {
    const auto found = Registry().entries.find(source);
    return found != Registry().entries.end() && found->second.draw_variant ? found->second.draw_variant : source;
}

bool MgTextureSelectVariant(mgCTexture *texture, std::string_view palette_source) {
    auto found = catalog_pixels.find(texture);
    if (found == catalog_pixels.end() || !found->second.record) return false;
    CatalogPixels &pixels = found->second;
    if (pixels.palette_source == palette_source) return true;
    std::string error;
    const auto &variants = pixels.record->variants;
    const auto variant = std::find_if(variants.begin(), variants.end(), [palette_source](const auto &value) {
        return value.palette_source == palette_source;
    });
    if (variant == variants.end()) return false;
    datapacks::DecodedTexture decoded;
    if (!datapacks::Decode(*pixels.record, static_cast<size_t>(variant - variants.begin()), decoded, error)) return false;
    pixels.levels = std::move(decoded.levels);
    pixels.width = decoded.width;
    pixels.height = decoded.height;
    Registry().entries.at(texture).uploaded = false;
    pixels.palette_source = palette_source;
    MakeLogicalPixels(texture, pixels);
    BindLogicalPixels(texture, pixels);
    MgTexturePixelsChanged(texture);
    return true;
}

std::string_view MgTexturePaletteSource(const mgCTexture *texture) {
    const auto found = catalog_pixels.find(texture);
    return found == catalog_pixels.end() ? std::string_view{} : std::string_view(found->second.palette_source);
}

int MgTextureSourceBpp(const mgCTexture *texture) {
    const auto found = catalog_pixels.find(texture);
    return found == catalog_pixels.end() || !found->second.record ? (texture ? texture->bpp : 0)
                                                               : found->second.record->source_bpp;
}

MgTextureExtent MgTexturePhysicalExtent(const mgCTexture *texture) {
    if (!texture) return {};
    const auto found = catalog_pixels.find(texture);
    if (found != catalog_pixels.end()) return {found->second.width, found->second.height};
    const auto entry = Registry().entries.find(texture);
    const uint32_t scale = entry != Registry().entries.end() ? entry->second.physical_scale : 1;
    return {(1u << texture->tex0.TW) * scale, (1u << texture->tex0.TH) * scale};
}

void MgTextureSetPhysicalScale(const mgCTexture *texture, uint32_t scale) {
    const auto found = Registry().entries.find(texture);
    if (found != Registry().entries.end() && !found->second.catalog) found->second.physical_scale = std::max(1u, scale);
}

MgTextureExtent MgTextureLogicalExtent(uint64_t tex0) {
    sceGsTex0 reg;
    reg.value = tex0;
    return {1u << reg.TW, 1u << reg.TH};
}

MgTextureExtent MgTexturePhysicalExtent(uint64_t tex0) {
    sceGsTex0 reg;
    reg.value = tex0;
    const auto *texture = TextureForKey(reg.TBP0);
    return texture ? MgTexturePhysicalExtent(texture) : MgTextureLogicalExtent(tex0);
}

float MgTextureImageScale(gfx::TextureHandle image) {
    const auto found = Registry().textures_by_image.find(image);
    if (found == Registry().textures_by_image.end()) return 1.0f;
    const auto *texture = found->second;
    return static_cast<float>(MgTexturePhysicalExtent(texture).width) / (1u << texture->tex0.TW);
}

bool MgTextureCopyRegion(const mgCTexture *source, int sx, int sy, mgCTexture *destination,
                         int dx, int dy, int width, int height) {
    if (!destination || destination->bpp != 32 || !destination->image[0] ||
        !Registry().entries.contains(destination) || width <= 0 || height <= 0 || dx < 0 || dy < 0 ||
        dx + width > destination->width || dy + height > destination->height ||
        (source && (source->bpp != 32 || !source->image[0] || sx < 0 || sy < 0 ||
                    sx + width > source->width || sy + height > source->height))) return false;
    const uint32_t source_scale = source ? MgTexturePhysicalExtent(source).width / (1u << source->tex0.TW) : 1;
    const auto previous = catalog_pixels.find(destination);
    const uint32_t old_scale = previous != catalog_pixels.end()
                                 ? previous->second.width / (1u << destination->tex0.TW) : 1;
    const uint32_t scale = std::max(source_scale, old_scale);
    const uint32_t physical_width = (1u << destination->tex0.TW) * scale;
    const uint32_t physical_height = (1u << destination->tex0.TH) * scale;
    constexpr uint64_t kCopyBudget = 256u * 1024u * 1024u;
    if (physical_width > 16384 || physical_height > 16384 ||
        (uint64_t{physical_width} * physical_height + uint64_t{width} * height * scale * scale) * 4 > kCopyBudget)
        return false;
    auto &pixels = catalog_pixels[destination];
    const auto source_pixels = catalog_pixels.find(source);
    if (pixels.levels.empty() || scale != old_scale) {
        std::vector<uint8_t> expanded(static_cast<size_t>(physical_width) * physical_height * 4);
        for (int y = 0; y < destination->height * static_cast<int>(scale); ++y)
            for (int x = 0; x < destination->width * static_cast<int>(scale); ++x) {
                const uint8_t *old = pixels.levels.empty()
                    ? AsBytes(destination->image[0]) + (static_cast<size_t>(y / scale) * destination->width + x / scale) * 4
                    : pixels.levels[0].data() + (static_cast<size_t>(y * old_scale / scale) * pixels.width + x * old_scale / scale) * 4;
                std::memcpy(expanded.data() + (static_cast<size_t>(y) * physical_width + x) * 4, old, 4);
            }
        pixels.levels = {std::move(expanded)};
        pixels.width = physical_width;
        pixels.height = physical_height;
        Registry().entries.at(destination).uploaded = false;
    }
    // Copy through a temporary so overlapping atlas regions have memmove semantics.
    std::vector<uint8_t> copied(static_cast<size_t>(width) * height * scale * scale * 4);
    if (source) {
        for (int y = 0; y < height * static_cast<int>(scale); ++y)
            for (int x = 0; x < width * static_cast<int>(scale); ++x) {
                const uint8_t *from = source_pixels == catalog_pixels.end()
                    ? AsBytes(source->image[0]) + (static_cast<size_t>(sy + y / scale) * source->width + sx + x / scale) * 4
                    : source_pixels->second.levels[0].data() +
                      (static_cast<size_t>(sy * source_scale + y * source_scale / scale) * source_pixels->second.width +
                       sx * source_scale + x * source_scale / scale) * 4;
                std::memcpy(copied.data() + (static_cast<size_t>(y) * width * scale + x) * 4, from, 4);
            }
    }
    for (int y = 0; y < height * static_cast<int>(scale); ++y) {
        std::memcpy(pixels.levels[0].data() + (static_cast<size_t>(dy * scale + y) * physical_width + dx * scale) * 4,
                    copied.data() + static_cast<size_t>(y) * width * scale * 4, width * scale * 4);
    }
    MakeLogicalPixels(destination, pixels);
    BindLogicalPixels(destination, pixels);
    MgTexturePixelsChanged(destination);
    return true;
}

void MgTexturePrepareAnimationDestination(const mgCTexture *source, mgCTexture *destination) {
    if (!source || !destination || destination->image[0] || !Registry().entries.contains(destination)) return;
    const uint32_t scale = MgTexturePhysicalExtent(source).width / (1u << source->tex0.TW);
    const auto previous = MgTexturePhysicalExtent(destination);
    if (scale <= previous.width / (1u << destination->tex0.TW)) return;
    const uint64_t width = uint64_t{1u << destination->tex0.TW} * scale;
    const uint64_t height = uint64_t{1u << destination->tex0.TH} * scale;
    if (width > 16384 || height > 16384 || width * height * 4 > 256u * 1024u * 1024u) return;
    auto &pixels = catalog_pixels[destination];
    pixels.width = static_cast<uint32_t>(width);
    pixels.height = static_cast<uint32_t>(height);
    Registry().entries.at(destination).uploaded = false;
}

MgTextureHandles MgTextureLookup(const mgCTexture *texture) {
    if (texture == nullptr) {
        return {};
    }

    TextureRegistry &registry = Registry();
    const auto       found = registry.entries.find(texture);

    if (found == registry.entries.end()) {
        return {};
    }

    Resolve(texture, found->second, false);
    return {found->second.image, gfx::kNullTexture};
}

MgTextureHandles MgTextureLookupTex0(uint64_t tex0) {
    sceGsTex0 reg;
    reg.value = tex0;

    MgTextureHandles handles;

    if (const mgCTexture *texture = TextureForKey(reg.TBP0)) {
        Entry &entry = Registry().entries.at(texture);
        Resolve(texture, entry, false);
        handles.texture = entry.image;
    }

    return handles;
}

PORT_OVERRIDE void mgCTextureManager::SetTableBuffer(int texture_count, int block_total, mgCMemory *memory) {
    int   slot;
    int   node;
    int   count;
    u_int bytes;
    block_max = block_total;
    count = block_max;
    bytes = count * sizeof(mgCTextureBlock);
    blocks = new (memory->Alloc(QuadwordsFor(bytes) + 2)) mgCTextureBlock[count];

    if (blocks == 0) {
        block_max = 0;
    }

    texture_max = texture_count;
    count = texture_max;
    bytes = count * sizeof(mgCTexture);
    texture_buf = new (memory->Alloc(QuadwordsFor(bytes) + 2)) mgCTexture[count];
    bytes = texture_max * sizeof(mgCTexture *);
    texture_stack = (mgCTexture **) memory->Alloc(QuadwordsFor(bytes) + 2);

    for (slot = 0; slot < texture_max; slot++) {
        texture_stack[slot] = &texture_buf[slot];
    }

    texture_num = 0;
    hash_max = texture_count;
    bytes = hash_max * sizeof(mgTEXTURE_HASH);
    hash_buf = (mgTEXTURE_HASH *) operator new[](
        hash_max * sizeof(mgTEXTURE_HASH), memory->Alloc(QuadwordsFor(bytes) + 2));
    bytes = hash_max * sizeof(mgTEXTURE_HASH *);
    hash_stack = (mgTEXTURE_HASH **) memory->Alloc(QuadwordsFor(bytes) + 2);

    for (node = 0; node < hash_max; node++) {
        hash_stack[node] = hash_buf + node;
    }

    hash_num = 0;
}

PORT_OVERRIDE void mgCTextureManager::Initialize(int start, int end) {
    ReleaseOwned(this);

    vram_top = start;
    vram_fix = end;

    if (vram_fix < 0) {
        vram_fix = MG_TEXTURE_VRAM_FIX_DEFAULT;
    }

    if (blocks != nullptr) {
        for (int i = 0; i < block_max; i++) {
            blocks[i].Initialize();
        }

        fix_block.Initialize();

        for (int slot = 0; slot < texture_max; slot++) {
            texture_stack[slot] = &texture_buf[slot];
        }

        texture_num = 0;

        for (int i = 0; i < block_max; i++) {
            blocks[i].unk_0 = vram_top;
            blocks[i].unk_4 = vram_top;
        }

        last_block = -1;
        name_suffix[0] = '\0';

        for (mgTEXTURE_HASH *&bucket : hash_table) {
            bucket = nullptr;
        }

        for (int node = 0; node < hash_max; node++) {
            hash_stack[node] = hash_buf + node;
        }

        hash_num = 0;
    }

    InstallSeam();
}

PORT_OVERRIDE mgCTexture *mgCTextureManager::EnterTexture(int block, char *name, u_long128 **image, int width,
                                                          int height, int bpp, u_long128 *clut, u_long tex1,
                                                          int swizzled) {
    if (name == nullptr) {
        return nullptr;
    }

    // Retail concatenated into the 0x20 buffer unchecked; a longer name is cut to fit instead.
    char full_name[0x20];
    std::snprintf(full_name, sizeof full_name, "%s%s", name, name_suffix);

    if (full_name[0] == '\0') {
        return nullptr;
    }

    mgCTextureBlock *texture_block = GetTextureBlock(block);

    if (texture_block == nullptr) {
        return nullptr;
    }

    const int psm = PsmForBpp(bpp);

    if (psm < 0) {
        return nullptr;
    }

    u_long128 *no_image[MG_TEXTURE_LEVEL_MAX] = {};

    if (image == nullptr) {
        image = no_image;
    }

    mgCTexture *texture = SearchTexture(full_name);

    if (texture == nullptr) {
        return nullptr;
    }

    // A pool slot can come back after Initialize without DeleteTexture; its old registration must not outlive it.
    ReleaseTexture(texture);
    texture->Initialize();

    const int tw = Log2Ceil(width);
    const int th = Log2Ceil(height);
    const int tbw = std::max(1, (width + 63) / 64);

    int level_blocks = bpp == 24 ? 32 : bpp;
    level_blocks = level_blocks * (width * height) / 256 / 8;

    int levels = 0;

    while (levels < MG_TEXTURE_LEVEL_MAX && image[levels] != nullptr) {
        levels++;
    }

    texture->image_blocks = levels == 0 ? level_blocks : 0;

    for (int i = 0; i < levels; i++) {
        texture->image[i] = image[i];
        texture->image_blocks += level_blocks;
        level_blocks /= 4;
    }

    texture->clut = nullptr;
    texture->clut_size = 0;
    texture->tex0.value = SCE_GS_SET_TEX0(0, tbw, psm, tw, th, 1, 0, 0, 0, 0, 0, 0);

    texture->vram_size = texture->image_blocks;

    if (const int rest = texture->vram_size % MG_TEXTURE_PAGE_BLOCKS; rest != 0) {
        texture->vram_size += MG_TEXTURE_PAGE_BLOCKS - rest;
    }

    std::memcpy(texture->name, full_name, sizeof full_name);
    texture->width = static_cast<short>(width);
    texture->height = static_cast<short>(height);
    texture->bpp = static_cast<short>(bpp);
    texture->block = static_cast<short>(block);
    texture->swizzled = swizzled;

    if (levels > 1) {
        // Retail's default mip setup fixes MXL at 2 whatever the level count; kept for parity.
        texture->tex1_bits = SCE_GS_SET_TEX1(0, 2, 1, 5, 1, 0, -120);

        if (tex1 != 0) {
            sceGsTex1 caller;
            std::memcpy(&caller, &tex1, sizeof caller);
            texture->tex1_bits = SCE_GS_SET_TEX1(0, levels - 1, 1, 5, 1, caller.L, caller.K);
        }
    } else {
        texture->tex1_bits = SCE_GS_SET_TEX1(0, 0, 1, 1, 1, 0, 0);
    }

    texture_block->Add(texture);
    AddHash(texture);

    Entry &registered = Register(this, texture);
    if (!entering_catalog) Resolve(texture, registered, false);

    if (mgGetPerformanceMeterFlag()) {
        std::printf("b = %d,%s vram = %d\n", block, texture->name, texture->vram_size);
    }

    return texture;
}

PORT_OVERRIDE mgCTexture *mgCTextureManager::EnterTexture(int id, char *name, TM2_head *head, int reload,
                                                          int no_image) {
    if (head == nullptr || name == nullptr) {
        return nullptr;
    }
    const auto source_name = TextureSourceLookup(head);
    const auto *source = source_name ? texture_catalog::Find(*source_name) : nullptr;
    if (!source) {
        std::fprintf(stderr, "texture: no catalog source for %s\n", name);
        return nullptr;
    }
    for (const auto &entry : source->entries) {
        if (entry.type == "texture" && (DecodeName(entry.name) == name || source->entries.size() == 1)) {
            return EnterCatalog(this, id, entry);
        }
    }
    std::fprintf(stderr, "texture: %s has no entry in %s\n", name, source_name->c_str());
    return nullptr;
}

PORT_OVERRIDE int mgCTextureManager::EnterIMGFile(u_char *img, int block, mgCMemory *stack,
                                                   mgCEnterIMGInfo *info) {
    if (img == nullptr) {
        return 0;
    }
    const auto source_name = TextureSourceLookup(img);
    const auto *source = source_name ? texture_catalog::Find(*source_name) : nullptr;
    if (!source) {
        std::fprintf(stderr, "texture: IMG pointer has no catalog source\n");
        return 0;
    }
    if (info) {
        for (int i = 0; i < MG_TEXTURE_IMG_GROUP_MAX; ++i) {
            info->block[i] = -1;
            info->block_num[i] = 0;
        }
    }
    std::vector<const texture_catalog::Entry *> entries;
    for (const auto &entry : source->entries) {
        entries.push_back(&entry);
    }
    int last_block = block;
    for (const auto *entry : entries) {
        if (entry->type == "cfg") {
            ApplyAnimation(this, *entry, stack);
            continue;
        }
        const int group = source->kind == "img3" ? std::max(0, entry->block) : 0;
        const int target = block + group;
        if (mgCTexture *texture = EnterCatalog(this, target, *entry)) {
            last_block = std::max(last_block, static_cast<int>(texture->block));
            if (info && group < MG_TEXTURE_IMG_GROUP_MAX && info->block[group] < 0) {
                info->block[group] = target;
                info->block_num[group] = 1;
            }
        }
    }
    if (info && source->kind != "img3") {
        info->block[0] = block;
        info->block_num[0] = 1;
    }
    return last_block - block;
}

PORT_OVERRIDE int mgGetIMGHeaderNum(char *img) {
    const auto source_name = TextureSourceLookup(img);
    const auto *source = source_name ? texture_catalog::Find(*source_name) : nullptr;
    if (!source) return 0;
    return static_cast<int>(std::count_if(source->entries.begin(), source->entries.end(), [](const auto &entry) {
        return entry.type == "cfg" || entry.picture == 0;
    }));
}

PORT_OVERRIDE mgIMG_HEADER mgGetIMGHeader(char *img, int index) {
    mgIMG_HEADER header{};
    const auto source_name = TextureSourceLookup(img);
    const auto *source = source_name ? texture_catalog::Find(*source_name) : nullptr;
    if (!source || index < 0) {
        return header;
    }
    const texture_catalog::Entry *selected = nullptr;
    for (const auto &entry : source->entries) {
        if (entry.type != "cfg" && entry.picture != 0) continue;
        if (index-- == 0) {
            selected = &entry;
            break;
        }
    }
    if (!selected) return header;
    const auto &entry = *selected;
    const std::string name = DecodeName(entry.name);
    std::snprintf(header.name, sizeof header.name, "%s", name.c_str());
    header.block = entry.block;
    header.swizzled = entry.swizzled;
    header.no_image = entry.no_image;
    header.clamp_bits = entry.clamp;
    return header;
}

PORT_OVERRIDE int mgCTextureManager::GetRemainVRAM(int block) {
    if (block < 0 || block >= block_max) {
        return 0;
    }

    return INT_MAX;
}

PORT_OVERRIDE int mgLoadImage(u_int *, int, int, int, u_long128 *, int, int, int, int, int) {
    return 0;
}

PORT_OVERRIDE void mgCTextureManager::ReloadTexture(int index, sceVif1Packet *packet) {
    if (index < 0 || index >= block_max) {
        last_block = -1;
        return;
    }

    ResolveBlock(blocks[index]);

    if (last_block != index && blocks[index].anime != nullptr) {
        RestoreAnimatedTextures(blocks[index], index);
        blocks[index].anime->TexAnime(index, packet != nullptr ? packet : mgVif1Packet);
    }

    last_block = index;
}

PORT_OVERRIDE int mgCTextureManager::ReloadTexture(int block, u_int *packet) {
    const bool in_range = block >= 0 && block < block_max;

    if (in_range) {
        ResolveBlock(blocks[block]);
        if (packet != nullptr && last_block != block) {
            RestoreAnimatedTextures(blocks[block], block);
        }
    }

    if (packet != nullptr) {
        last_block = in_range ? block : -1;
    }

    return 0;
}

PORT_OVERRIDE int mgCTextureManager::ReloadCLUT(mgCTexture *texture, u_int *) {
    // Retail palette uploads have no work to do: RGBA variants have their own texture keys.
    return 0;
}

PORT_OVERRIDE void mgCTextureManager::ReloadCLUT(mgCTexture *texture, sceVif1Packet *) {
}

PORT_OVERRIDE void mgCTextureManager::DeleteTexture(mgCTexture *texture) {
    if (texture == nullptr) {
        return;
    }

    ReleaseTexture(texture);

    mgCTextureBlock *texture_block = GetTextureBlock(texture->block);

    if (texture_block == nullptr) {
        return;
    }

    DelHash(texture);
    texture_block->Delete(texture);

    if (texture_num > 0) {
        texture_num--;
        texture_stack[texture_num] = texture;
    }

    texture->Initialize();
}
