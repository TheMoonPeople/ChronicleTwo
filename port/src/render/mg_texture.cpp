#include "common.h"
#include "mw_runtime.h"

#include <libgraph.h>
#include <libpkt.h>

#include <algorithm>
#include <climits>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <memory>
#include <optional>
#include <print>
#include <ranges>
#include <span>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "button_glyphs.hpp"
#include "log/game_output.hpp"
#include "log/log.hpp"
#include "memory/tracked_copy.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "photo_hd.hpp"
#include "platform/datapacks.hpp"
#include "platform/texture_catalog.hpp"
#include "profile.hpp"
#include "render/renderer.hpp"
#include "render/texture_runtime.hpp"
#include "text/bounded.hpp"
#include "texture_source.hpp"

/**
 *
 * Gives the quadwords a buffer of the given bytes takes, rounded up.
 *
 */
#define QWORDS(bytes) ((bytes) % 16 == 0 ? (bytes) / 16 : (bytes) / 16 + 1)

/**
 *
 * Words of the DMA tags, VIF codes and GIF tags the upload chains are
 * built from.
 *
 */
enum {
    DMA_ID_CNT = 0x10000000,   /**< DMA tag transferring the quadwords that follow it. */
    DMA_ID_REF = 0x30000000,   /**< DMA tag transferring quadwords from the address it holds. */
    VIF_DIRECT = 0x50000000,   /**< VIF code passing the quadwords that follow it to the GIF. */
    GIF_EOP = 0x8000,          /**< GIF tag lower word: last tag of the packet. */
    GIF_NREG_1 = 0x10000000,   /**< GIF tag upper word: one register descriptor. */
    GIF_FLG_IMAGE = 0x08000000 /**< GIF tag upper word: image data. */
};

/**
 *
 * DMA chain flushing the GS texture cache.
 *
 */
static u_char texflush_dma[48] __attribute__((aligned(16))) = {
    0x02,
    0x00,
    0x00,
    0x10,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x02,
    0x00,
    0x00,
    0x50,
    0x01,
    0x80,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x10,
    0x0E,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x3F,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
};

static inline u_int align16_blocks(u_int n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

/**
 *
 * Gives the VRAM block address of the Z buffer and stores the GS blocks
 * it spans, which 8-bit textures can borrow while it holds nothing.
 *
 */
static int GetZBufVram(int *size) {
    mgCTexture frame;

    mgGetTextureZ(0);
    mgGetFrameBuffer(&frame);
    *size = frame.width * frame.width * 4 / 256;
    return mgZBUF_1.bits.zbp << 5;
}

/**
 *
 * Tells whether a texture can be placed in the Z buffer's VRAM, which
 * holds unswizzled 8-bit textures only, and stores the blocks it needs.
 *
 */
static int CheckCopyToZBufVram(mgCTexture *texture, int *size) {
    *size = 0;

    if (texture->swizzled == 0 && texture->bpp == 8 && texture->image[0] != nullptr) {
        *size = texture->vram_size * 4;
        return 1;
    }

    return 0;
}

mgCTexture::mgCTexture() {
    Initialize();
}

void mgCTexture::Initialize() {
    name[0] = '\0';
    block = -1;

    for (int i = 0; i < MG_TEXTURE_LEVEL_MAX; i++) {
        image[i] = nullptr;
    }

    clut = nullptr;
    clamp = {};
    tex1 = {};
    tex0.value = 0;
    clamp.WMS = 1;
    clamp.WMT = 1;
    bpp = 0;
    height = 0;
    width = 0;
    swizzled = 0;
    vram_size = 0;
    image_blocks = 0;
    clut_size = 0;
    next = nullptr;
}

void mgCTexture::Bilinear(int mode) {
    if (tex1.MXL == 0) {
        switch (mode) {
            case 0:
                tex1.MMAG = 0;
                tex1.MMIN = 0;
                break;
            case 1:
            case 2:
                tex1.MMAG = 1;
                tex1.MMIN = 1;
                break;
        }
    } else {
        switch (mode) {
            case 0:
                tex1.MMAG = 0;
                tex1.MMIN = 2;
                break;
            case 1:
                tex1.MMAG = 1;
                tex1.MMIN = 4;
            case 2:
                tex1.MMAG = 1;
                tex1.MMIN = 5;
                break;
        }
    }
}

mgCTextureBlock::mgCTextureBlock() {
    Initialize();
}

void mgCTextureBlock::Initialize() {
    unk_4 = 0;
    unk_0 = 0;
    anime = nullptr;
    texture = nullptr;
}

void mgCTextureBlock::Add(mgCTexture *texture) {
    texture->next = nullptr;
    mgCTexture *node = {};

    if (this->texture == nullptr) {
        this->texture = texture;
    } else {
        node = this->texture;

        while (node != nullptr) {
            mgCTexture *next = node->next;

            if (next == nullptr) {
                node->next = texture;
                break;
            }

            node = next;
        }
    }
}

void mgCTextureBlock::Delete(mgCTexture *texture) {
    mgCTexture *node = this->texture;
    mgCTexture *prev = nullptr;

    while (node != nullptr) {
        if (node == texture) {
            if (prev == nullptr) {
                this->texture = node->next;
            } else {
                prev->next = node->next;
            }
        }

        prev = node;
        node = node->next;
    }
}

mgCTextureManager::mgCTextureManager()
    : vram_top(0), vram_fix(0), last_block(-1), block_max(0), blocks(nullptr), fix_block{},
      hash_table{}, texture_buf(nullptr), texture_stack(nullptr), texture_max(0), texture_num(0),
      hash_buf(nullptr), hash_stack(nullptr), hash_max(0), hash_num(0), name_suffix{} {}

int mgCTextureManager::hash(char *name) {
    u_char value = {};

    for (value = 0; *(signed char *) name != 0; name++) {
        value = (((value << 8) + *(signed char *) name) % 101);
    }

    return value;
}

void mgCTextureManager::AddHash(mgCTexture *texture) {
    if (!ValidateTableStorage() || texture == nullptr) {
        return;
    }
    mgTEXTURE_HASH *node = {};
    mgTEXTURE_HASH *cur = {};
    mgTEXTURE_HASH *following = {};

    if (hash_num >= hash_max) {
        node = nullptr;
    } else {
        node = hash_stack[hash_num++];
    }

    if (node != nullptr) {
        node->next = nullptr;
        node->texture = texture;

        int index = hash(texture->name);
        cur = hash_table[index];

        if (cur == nullptr) {
            hash_table[index] = node;
        } else {
            while (cur != nullptr) {
                following = cur->next;

                if (following == nullptr) {
                    cur->next = node;
                    return;
                }

                cur = following;
            }
        }
    }
}

void mgCTextureManager::DelHash(mgCTexture *texture) {
    if (!ValidateTableStorage()) {
        return;
    }
    mgTEXTURE_HASH *cur = {};
    mgTEXTURE_HASH *prev = {};
    mgTEXTURE_HASH *found = {};

    if (texture != nullptr) {
        int index = hash(texture->name);
        cur = hash_table[index];
        prev = nullptr;
        found = nullptr;

        while (cur != nullptr) {
            if (cur->texture == texture) {
                found = cur;
                break;
            }

            prev = cur;
            cur = cur->next;
        }

        if (found != nullptr) {
            if (prev == nullptr) {
                hash_table[index] = found->next;
            } else {
                prev->next = found->next;
            }

            if (hash_num > 0) {
                hash_num--;
                hash_stack[hash_num] = found;
            }
        }
    }
}

mgCTexture *mgCTextureManager::SearchHash(char *name, int mode) {
    if (!ValidateTableStorage() || name == nullptr) {
        return nullptr;
    }
    mgTEXTURE_HASH *node = {};
    int             bucket = hash(name);

    for (node = hash_table[bucket]; node != nullptr;
         node = node->next) {
        if (strcmp(name, node->texture->name) == 0) {
            if (mode < 0 || node->texture->block == mode) {
                return node->texture;
            }
        }
    }

    return nullptr;
}

mgCTexture *mgCTextureManager::SearchTextureName(char *name, int block) {
    if (!ValidateTableStorage() || name == nullptr) {
        return nullptr;
    }
    if (name_suffix[0] != '\0') {
        std::string full_name(name);
        full_name += dc2::text::View(name_suffix);
        return SearchHash(full_name.data(), block);
    }
    return SearchHash(name, block);
}

mgCTexture *mgCTextureManager::SearchTexture(char *name) {
    if (!ValidateTableStorage() || name == nullptr) {
        return nullptr;
    }
    mgCTexture *slot = {};

    if (texture_num >= texture_max) {
        slot = nullptr;
    } else {
        slot = texture_stack[texture_num++];
    }

    if (SearchTextureName(name, -1) != nullptr) {
        dc2::log::PrintGame("%s is already used.\n", name);
    }

    return slot;
}

mgCTexture *mgCTextureManager::GetTexture(char *name, int block) {
    return SearchTextureName(name, block);
}

mgCTextureBlock *mgCTextureManager::GetTextureBlock(int block) {
    if (!ValidateTableStorage()) {
        return nullptr;
    }
    if (block == MG_TEXTURE_BLOCK_FIX) {
        return &fix_block;
    }

    if (blocks == nullptr || block < 0 || block >= block_max) {
        return nullptr;
    }

    return &blocks[block];
}

static inline int FirstBlock(int block) { return block; }

/**
 *
 * Identifies the archive format of an IMG texture archive from its
 * signature, or gives MG_IMG_VERSION_NONE when the data is not one.
 *
 */
static int GetIMGVersion(char *img) {
    if (img == nullptr) {
        return MG_IMG_VERSION_NONE;
    }

    if (memcmp(img, "IM", 2) != 0) {
        return MG_IMG_VERSION_NONE;
    }

    if (memcmp(img, "IMG", 3) == 0) {
        return MG_IMG_VERSION_IMG;
    }

    if (memcmp(img, "IM2", 3) == 0) {
        return MG_IMG_VERSION_IM2;
    }

    if (memcmp(img, "IM3", 3) == 0) {
        return MG_IMG_VERSION_IM3;
    }

    return MG_IMG_VERSION_NONE;
}

int mgGetIMGHeaderNum(char *img);

mgIMG_HEADER mgGetIMGHeader(char *img, int index);

void mgCTextureManager::DeleteTexture(char *name, int block) {
    mgCTexture *texture = GetTexture(name, block);

    if (texture != nullptr) {
        DeleteTexture(texture);
    }
}

void mgCTextureManager::DeleteBlock(int block) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTexture      *texture = {};
    mgCTexture      *next = {};

    if (texture_block == nullptr) {
        return;
    }

    for (texture = texture_block->texture; texture != nullptr; texture = next) {
        next = texture->next;
        DeleteTexture(texture);
    }

    texture_block->Initialize();
}

void mgCTextureManager::EndEnterTexture(int block) {
    ReloadTexture(block, (u_int *) nullptr);
}

int mgLoadImage(u_int *packet, int base, int format, int width, u_long128 *image, int quadwords,
                int pos_x, int pos_y, int size_w, int size_h);

/**
 *
 * Writes the DMA chain flushing the GS texture cache, when given a
 * buffer; gives the quadwords it takes either way.
 *
 */
static int SetTexFlush_TagCnt(u_int *buffer) {
    if (buffer == nullptr) {
        return 3;
    }

    std::memcpy(buffer, texflush_dma, sizeof(texflush_dma));
    return 3;
}

sceGsTex0 &sceGsTex0::operator=(const sceGsTex0 &src) {
    value = src.value;
    return *this;
}

void mgCTextureManager::TexAnimeOn(int block, char *group_name) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime = {};

    if (texture_block != nullptr && (anime = texture_block->anime) != nullptr) {
        anime->Enable(anime->SearchGroupName(group_name));
    }
}

void mgCTextureManager::TexAnimeOff(int block, char *group_name) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime = {};

    if (texture_block != nullptr && (anime = texture_block->anime) != nullptr) {
        anime->Disable(anime->SearchGroupName(group_name));
    }
}

void mgCTextureManager::TexAnimeAllOff(int block) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime = {};

    if (texture_block != nullptr && (anime = texture_block->anime) != nullptr) {
        anime->DisableAll();
    }
}

char **mgCTextureManager::GetGroupNameList(int block, int *num) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime = {};

    if (texture_block == nullptr) {
        return nullptr;
    }

    anime = texture_block->anime;

    if (anime == nullptr) {
        return nullptr;
    }

    *num = MG_TEX_ANIME_GROUP_MAX;
    return anime->name;
}

void mgCTextureManager::DeleteTexAnimeGroup(int block, int group) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime = {};

    if (texture_block != nullptr && (anime = texture_block->anime) != nullptr) {
        anime->DeleteGroup(group);
    }
}

void mgCTextureManager::DeleteTexAnime(int block) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);

    if (texture_block != nullptr) {
        texture_block->anime = nullptr;
    }
}

mgCTextureAnime *mgCTextureManager::GetTexAnime(int index) {
    mgCTextureBlock *block = GetTextureBlock(index);

    if (block != nullptr) {
        return block->anime;
    }

    return nullptr;
}

namespace {

/**
 * Keeps immutable native picture semantics and mip variants for exact registration reuse.
 */
struct NativePicture {
    texture_catalog::Entry                 definition; /**< Logical dimensions, sampler and variant identities. */
    std::vector<datapacks::DecodedTexture> variants;   /**< Original physical mip pixels before animation edits. */
    std::vector<std::string>               identities; /**< Decoder-supplied names of each variant's pixels, empty when unknown. */
};

/**
 * Records one native animation group created from a texture document.
 */
struct NativeAnimationGroup {
    int                     block;     /**< Texture block containing the animation. */
    int                     group;     /**< Group index allocated by the native interpreter. */
    mgCTextureAnime        *animation; /**< Animation owner at registration time. */
    CList<mgCTexAnimeData> *head;      /**< Original list head identifying a live group. */
};

/**
 * Retains a document animation's semantics and the groups it registered.
 */
struct NativeAnimation {
    int                               block;      /**< Base block selected for the native texture document. */
    std::string                       suffix;     /**< Texture suffix used to resolve animation operands. */
    texture_catalog::Entry            definition; /**< Ordered typed animation commands. */
    std::vector<NativeAnimationGroup> groups;     /**< Live groups owned by this registration. */
};

/**
 * Keeps native script reuse state available during texture-manager static initialization.
 */
std::unordered_map<const mgCTextureManager *, std::vector<NativeAnimation>> &NativeAnimations() {
    static std::unordered_map<const mgCTextureManager *, std::vector<NativeAnimation>> animations;
    return animations;
}

/**
 * Keeps physical RGBA detail alongside game-accessible retail-sized mip images.
 */
struct CatalogPixels {
    std::vector<std::vector<uint8_t>>             levels;         /**< Padded physical RGBA mip canvases. */
    std::shared_ptr<const texture_catalog::Entry> record;         /**< Owned catalog entry supplying baked variants. */
    std::string                                   record_source;  /**< Native source identity of the most recent registration. */
    std::string                                   selector;       /**< Logical identity of the selected RGBA image. */
    MgTextureImageDecoder                         decoder;        /**< Provider retained for later variant selections. */
    uint32_t                                      width = 0;      /**< Physical base canvas width. */
    uint32_t                                      height = 0;     /**< Physical base canvas height. */
    std::vector<std::vector<uint8_t>>             logical_levels; /**< Tightly packed retail-sized CPU mip images. */
    std::vector<std::vector<uint8_t>>             baseline;       /**< CPU mip values before direct game edits. */
    std::shared_ptr<const NativePicture>          original;       /**< Immutable native registration identity. */
};

std::unordered_map<const mgCTexture *, CatalogPixels> catalog_pixels;
bool                                                  entering_catalog = false;

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
    std::vector<uint8_t>     memory16;           /**< 16-bit RAM image last uploaded, to notice in-place rewrites. */
    uint32_t                 physical_scale = 1; /**< Host texels per retail texel outside the catalog. */
};

struct TextureRegistry {
    std::unordered_map<const mgCTexture *, Entry>              entries;
    std::unordered_map<uint32_t, const mgCTexture *>           textures_by_key;
    std::unordered_map<gfx::TextureHandle, const mgCTexture *> textures_by_image;
    std::vector<uint32_t>                                      free_keys;
    uint32_t                                                   next_key = kMgTextureKeyFirst;
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

// Largest host canvas a region copy or animation destination may grow to.
constexpr uint64_t kMaxCanvasSide = 16384;
constexpr uint64_t kCanvasByteBudget = 256u * 1024u * 1024u;

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
        auto          &logical = pixels.logical_levels[mip];
        logical.resize(static_cast<size_t>(width) * height * 4);
        for (uint32_t y = 0; y < height; ++y) {
            for (uint32_t x = 0; x < width; ++x) {
                const uint32_t px = std::min(physical_width - 1, x * scale + scale / 2);
                const uint32_t py = std::min(physical_height - 1, y * scale + scale / 2);
                std::memcpy(logical.data() + (static_cast<size_t>(y) * width + x) * 4,
                            pixels.levels[mip].data() + (static_cast<size_t>(py) * physical_width + px) * 4, 4);
            }
        }
    }
    pixels.baseline = pixels.logical_levels;
}

/**
 * Associates the game's image pointers with the owned retail-sized mip buffers.
 */
void BindLogicalPixels(mgCTexture *texture, CatalogPixels &pixels) {
    for (int mip = 0; mip < MG_TEXTURE_LEVEL_MAX; ++mip) {
        texture->image[mip] = std::cmp_less(mip, pixels.logical_levels.size())
                                  ? reinterpret_cast<u_long128 *>(pixels.logical_levels[mip].data())
                                  : nullptr;
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
    const size_t         texels = Memory16Bytes(texture) / 2;
    std::vector<uint8_t> rgba(texels * 4);
    const uint8_t       *in = AsBytes(texture->image[0]);
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
    auto       handle = gfx::CreateTexture({.width = extent.width, .height = extent.height, .format = gfx::TextureFormat::Rgba8, .mip_levels = 1, .has_alpha = true});
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
    CT_PROFILE_ZONE("Upload texture pixels");
    const auto     extent = MgTexturePhysicalExtent(texture);
    const auto     pixels = catalog_pixels.find(texture);
    const uint32_t canvas_width = extent.width;
    const uint32_t canvas_height = extent.height;
    uint32_t       levels = 0;
    while (levels < MG_TEXTURE_LEVEL_MAX && texture->image[levels]) {
        ++levels;
    }
    if (levels == 0) {
        levels = 1; // Animation destinations and render targets start empty.
    }
    datapacks::TraceTimer create_timer("mg_texture.create_texture_us");
    auto                  handle = gfx::CreateTexture({.width = canvas_width, .height = canvas_height, .format = gfx::TextureFormat::Rgba8, .mip_levels = levels, .has_alpha = texture->bpp != 24});
    create_timer.Stop();
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
           std::cmp_not_equal(entry.tw, texture->tex0.TW) || std::cmp_not_equal(entry.th, texture->tex0.TH);
}

void Rebuild(const mgCTexture *texture, Entry &entry) {
    if (entry.image != gfx::kNullTexture) {
        mgPortReleaseTextureTarget(entry.key);
    }
    Registry().textures_by_image.erase(entry.image);
    DestroyHandle(entry.image);
    TakeSnapshot(texture, entry);
    // A picture the decoder rejects is not retried until its pointers change; retrying would decode the
    // same bytes every frame.
    entry.uploaded = true;
    entry.memory16.clear();

    if (IsMemory16(texture, entry)) {
        entry.image = UploadMemory16(texture, entry);
        if (entry.image != gfx::kNullTexture) {
            Registry().textures_by_image[entry.image] = texture;
        }
        return;
    }

    if (texture->image[0] != nullptr && !entry.catalog && texture->bpp != 32) {
        CT_LOG_WARN(Gfx, "texture: {} has unsupported non-RGBA memory pixels", texture->name);
        return;
    }
    entry.image = UploadPixels(texture);
    if (entry.image != gfx::kNullTexture) {
        Registry().textures_by_image[entry.image] = texture;
    }
}

void Resolve(const mgCTexture *texture, Entry &entry) {
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
        if (registered.draw_variant == texture) {
            registered.draw_variant = nullptr;
        }
    }
    // A registry key can immediately name a different texture; its old rendered pixels cannot.
    mgPortReleaseTextureTarget(entry.key);
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
    NativeAnimations().erase(owner);
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

} // namespace

bool mgCTextureManager::ValidateTableStorage() {
    if (!table_storage_bound || std::ranges::all_of(table_storage, [](const auto &allocation) { return !allocation.Bytes().empty(); })) {
        return true;
    }
    ReleaseOwned(this);
    blocks = nullptr;
    block_max = 0;
    fix_block.Initialize();
    texture_buf = nullptr;
    texture_stack = nullptr;
    texture_max = texture_num = 0;
    hash_buf = nullptr;
    hash_stack = nullptr;
    hash_max = hash_num = 0;
    std::ranges::fill(hash_table, nullptr);
    name_suffix[0] = '\0';
    last_block = -1;
    table_storage = {};
    table_storage_bound = false;
    return false;
}

namespace {

void ResolveTexture(const mgCTexture *texture) {
    TextureRegistry &registry = Registry();
    const auto       found = registry.entries.find(texture);

    if (found != registry.entries.end()) {
        Resolve(texture, found->second);
    }
}

void ResolveBlock(const mgCTextureBlock &block) {
    for (const mgCTexture *texture = block.texture; texture != nullptr; texture = texture->next) {
        ResolveTexture(texture);
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

            if (texture->image[0] == nullptr) {
                continue;
            }

            MgTexturePixelsChanged(texture);
            // Sprite animations draw into a registered target rather than the decoded image; both handles stay
            // stable and the target is seeded again in the recorded draw order.
            const auto source = MgTextureLookup(texture).texture;
            const auto target = mgPortFindTexture(texture).texture;
            if (source != target) {
                const auto      extent = MgTexturePhysicalExtent(texture);
                const int       scale = extent.width / (1u << texture->tex0.TW);
                const gfx::Rect whole{.x = 0, .y = 0, .w = texture->width * scale, .h = texture->height * scale};
                gfx::BlitTexture(source, whole, target, whole, gfx::Filter::Nearest);
            }
        }
    }
}

const mgCTexture *TextureForKey(uint32_t key) {
    const auto &by_key = Registry().textures_by_key;
    const auto  found = by_key.find(key);
    return found == by_key.end() ? nullptr : found->second;
}

mgPortTexture SeamTexture(const mgCTexture *texture) {
    const MgTextureHandles handles = MgTextureLookup(texture);
    return {.texture = handles.texture, .palette = handles.palette};
}

mgPortTexture SeamTex0(uint64_t tex0) {
    const MgTextureHandles handles = MgTextureLookupTex0(tex0);
    return {.texture = handles.texture, .palette = handles.palette};
}

void InstallSeam() {
    mgPortSetTextureLookup(SeamTexture, SeamTex0);
}

std::string DecodeName(const std::string &encoded) {
    std::string name;
    for (size_t i = 0; i < encoded.size(); ++i) {
        if (encoded[i] == '%' && i + 2 < encoded.size()) {
            auto hex = [](char c) -> int {
                if (c >= '0' && c <= '9') {
                    return c - '0';
                }
                if (c >= 'A' && c <= 'F') {
                    return c - 'A' + 10;
                }
                if (c >= 'a' && c <= 'f') {
                    return c - 'a' + 10;
                }
                return -1;
            };
            const int hi = hex(encoded[i + 1]);
            const int lo = hex(encoded[i + 2]);
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

bool DecodeWith(const MgTextureImageDecoder &decoder, const texture_catalog::Entry &record, std::size_t variant,
                datapacks::DecodedTexture &decoded, std::string &error) {
    CT_PROFILE_ZONE("Decode texture image");
    if (!(decoder ? decoder(record, variant, decoded, error) : datapacks::Decode(record, variant, decoded, error))) {
        return false;
    }
    if (decoded.width == 0 || decoded.height == 0 || decoded.levels.size() > MG_TEXTURE_LEVEL_MAX ||
        (!record.no_image && decoded.levels.empty())) {
        error = "invalid decoded RGBA dimensions or mip count";
        return false;
    }
    std::size_t width = decoded.width;
    std::size_t height = decoded.height;
    for (const auto &level : decoded.levels) {
        if (width > std::numeric_limits<std::size_t>::max() / height / 4 || level.size() < width * height * 4) {
            error = "decoded RGBA mip is shorter than its dimensions";
            return false;
        }
        width = std::max(std::size_t{1}, width / 2);
        height = std::max(std::size_t{1}, height / 2);
    }
    return true;
}

// The pristine variant when one is kept, otherwise a fresh decode.
bool DecodeVariant(const CatalogPixels &pixels, std::size_t variant, datapacks::DecodedTexture &decoded) {
    if (pixels.original && variant < pixels.original->variants.size() &&
        !pixels.original->variants[variant].levels.empty()) {
        decoded = pixels.original->variants[variant];
        return true;
    }
    std::string error;
    return DecodeWith(pixels.decoder, *pixels.record, variant, decoded, error);
}

/**
 * Compares native picture semantics independently of document-local image references.
 */
bool SameDefinition(const texture_catalog::Entry &a, const texture_catalog::Entry &b) {
    if (a.width != b.width || a.height != b.height || a.bpp != b.bpp || a.swizzled != b.swizzled ||
        a.clamp != b.clamp || a.no_image != b.no_image || a.picture != b.picture ||
        a.animation_mode != b.animation_mode || a.nearest != b.nearest || a.variants.size() != b.variants.size()) {
        return false;
    }
    for (std::size_t index = 0; index < a.variants.size(); ++index) {
        if (a.variants[index].selector != b.variants[index].selector) {
            return false;
        }
    }
    return true;
}

/**
 * Compares native picture semantics and decoded pixels.
 */
bool SamePicture(const NativePicture &left, const NativePicture &right) {
    if (!SameDefinition(left.definition, right.definition) || left.variants.size() != right.variants.size()) {
        return false;
    }
    // Named pictures keep no pristine pixels; their names already cover every source file.
    if (!left.identities.empty() || !right.identities.empty()) {
        return left.identities == right.identities;
    }
    for (std::size_t index = 0; index < left.variants.size(); ++index) {
        const auto &x = left.variants[index];
        const auto &y = right.variants[index];
        if (x.width != y.width || x.height != y.height || x.levels != y.levels) {
            return false;
        }
    }
    return true;
}

/**
 * Compares a named registration with a picture named by other files, by the pixels it was entered with.
 *
 * Two IMG documents can each carry their own copy of the same PNG, so different names do not mean different pixels.
 * Only the first variant of a named picture is decoded up front, so the others must share their names.
 */
bool SameNamedPixels(const CatalogPixels &existing, const NativePicture &picture) {
    const NativePicture &original = *existing.original;
    if (picture.identities.empty() || picture.variants.empty() ||
        original.identities.size() != picture.identities.size() ||
        !SameDefinition(original.definition, picture.definition) ||
        !std::ranges::equal(original.identities | std::views::drop(1), picture.identities | std::views::drop(1))) {
        return false;
    }
    const auto &decoded = picture.variants.front();
    return decoded.width == existing.width && decoded.height == existing.height && decoded.levels == existing.levels;
}

/**
 * Names every decoded variant of a picture, or returns nothing when any variant is unnamed.
 */
std::vector<std::string> PictureIdentities(const texture_catalog::Entry &record, const MgTextureImageIdentity &identity) {
    std::vector<std::string> identities;
    if (!identity) {
        return identities;
    }
    const std::size_t count = record.no_image ? 1 : std::max<std::size_t>(record.variants.size(), 1);
    for (std::size_t variant = 0; variant < count; ++variant) {
        auto name = identity(record, variant);
        if (name.empty()) {
            return {};
        }
        identities.push_back(std::move(name));
    }
    return identities;
}

mgCTexture *EnterCatalog(mgCTextureManager *manager, int block, const texture_catalog::Entry &record,
                         MgTextureImageDecoder decoder = {}, const MgTextureImageIdentity &identity = {}, std::string_view record_source = {}) {
    if (!manager) {
        return nullptr;
    }
    std::string name = DecodeName(record.name);
    if (record.picture > 0) {
        name += "#picture" + std::to_string(record.picture);
    }
    std::string full_name_text = name;
    full_name_text += dc2::text::View(manager->name_suffix);
    if (full_name_text.size() >= sizeof(mgCTexture::name)) {
        return nullptr;
    }
    char full_name[32];
    std::memcpy(full_name, full_name_text.c_str(), full_name_text.size() + 1);
    std::vector<std::string> identities;
    {
        datapacks::TraceTimer timer("mg_texture.identity_us");
        identities = PictureIdentities(record, identity);
    }
    if (!identities.empty()) {
        if (auto *existing = manager->SearchHash(full_name, block)) {
            const auto found = catalog_pixels.find(existing);
            if (found != catalog_pixels.end() && found->second.original && found->second.original->identities == identities &&
                SameDefinition(found->second.original->definition, record)) {
                datapacks::Trace("mg_texture.identity_reuses");
                found->second.record = std::make_shared<const texture_catalog::Entry>(record);
                found->second.record_source = record_source;
                found->second.decoder = std::move(decoder);
                return existing;
            }
        }
    }
    std::string               error;
    datapacks::DecodedTexture decoded;
    datapacks::TraceTimer     decode_timer("mg_texture.decode_us");
    if (!DecodeWith(decoder, record, 0, decoded, error)) {
        CT_LOG_ERROR(Data, "texture: {}: {}", record.name, error);
        return nullptr;
    }
    auto original = std::make_shared<NativePicture>();
    original->definition = record;
    original->identities = std::move(identities);
    // A named picture is not compared by its pixels, so it neither copies them nor decodes its other variants
    // up front; selecting one decodes it through the decoder, from the decode cache. Upscaled packs make these
    // copies hundreds of megabytes per area.
    const bool named = !original->identities.empty();
    original->variants.push_back(std::move(decoded));
    if (!record.no_image && !named) {
        for (std::size_t variant = 1; variant < record.variants.size(); ++variant) {
            datapacks::DecodedTexture alternate;
            if (!DecodeWith(decoder, record, variant, alternate, error)) {
                CT_LOG_ERROR(Data, "texture: {}: {}", record.name, error);
                return nullptr;
            }
            original->variants.push_back(std::move(alternate));
        }
    }
    decode_timer.Stop();
    for (auto &variant : original->definition.variants) {
        variant.levels.clear();
    }
    if (auto *existing = manager->SearchHash(full_name, block)) {
        const auto found = catalog_pixels.find(existing);
        if (found != catalog_pixels.end() && found->second.original) {
            if (SamePicture(*found->second.original, *original) || (named && SameNamedPixels(found->second, *original))) {
                found->second.record = std::make_shared<const texture_catalog::Entry>(record);
                found->second.record_source = record_source;
                found->second.decoder = std::move(decoder);
                return existing;
            }
            // The next pool allocation returns this header, retaining every material's pointer.
            manager->DeleteTexture(existing);
        }
    }
    // The original keeps pristine pixels; the registration owns a copy that glyphs and animation edit.
    datapacks::TraceTimer enter_timer("mg_texture.enter_us");
    if (named) {
        decoded = std::move(original->variants.front());
        original->variants.front().levels.clear();
        for (std::size_t variant = 1; variant < original->definition.variants.size(); ++variant) {
            original->variants.push_back({.levels = {}, .width = decoded.width, .height = decoded.height});
        }
    } else {
        decoded = original->variants.front();
    }
    ButtonGlyphsApply(record.name, record.width, record.height, decoded);
    CatalogPixels pixels{.levels = std::move(decoded.levels), .record = std::make_shared<const texture_catalog::Entry>(record), .record_source = std::string(record_source), .selector = record.name, .decoder = std::move(decoder), .width = decoded.width, .height = decoded.height};
    pixels.original = std::move(original);
    u_long128 *levels[MG_TEXTURE_LEVEL_MAX] = {};
    if (!record.no_image) {
        for (size_t mip = 0; mip < pixels.levels.size(); ++mip) {
            levels[mip] = reinterpret_cast<u_long128 *>(pixels.levels[mip].data());
        }
    }
    entering_catalog = true;
    mgCTexture *texture = manager->EnterTexture(block, const_cast<char *>(name.c_str()), levels,
                                                record.width, record.height, 32, nullptr,
                                                0, 0);
    entering_catalog = false;
    if (texture != nullptr) {
        MakeLogicalPixels(texture, pixels);
        catalog_pixels.insert_or_assign(texture, std::move(pixels));
        BindLogicalPixels(texture, catalog_pixels.at(texture));
        texture->clamp_bits = record.clamp;
        if (record.nearest) {
            texture->tex1_bits &= ~(uint64_t{1} << 5);
        }
        enter_timer.Stop();
        datapacks::TraceTimer upload_timer("mg_texture.upload_us");
        ResolveTexture(texture);
    }
    return texture;
}

/**
 * Registers a native animation script against its owning texture blocks.
 */
/**
 * Rejects animation operands before converting them to native integer fields.
 */
template <class T>
bool AnimationIntegerFits(double value) {
    const double whole = std::trunc(value);
    return std::isfinite(whole) && whole >= static_cast<double>(std::numeric_limits<T>::lowest()) &&
           whole <= static_cast<double>(std::numeric_limits<T>::max());
}

/**
 * Checks numeric animation commands before they can alter registered groups.
 */
bool ValidAnimationNumbers(const texture_catalog::Entry &entry) {
    int type = MG_TEX_ANIME_TYPE_NONE;
    for (const auto &command : entry.script) {
        if (std::ranges::any_of(command.args, [](const auto &arg) { return !arg.text && !std::isfinite(arg.number); })) {
            return false;
        }
        auto number = [&command](std::size_t index) {
            return index < command.args.size() && !command.args[index].text ? command.args[index].number : 0.0;
        };
        const auto &op = command.name;
        if (op == "TEX_ANIME" && !AnimationIntegerFits<int>(number(1))) {
            return false;
        }
        if (op == "TEX_ANIME_DATA") {
            if (!AnimationIntegerFits<signed char>(number(0))) {
                return false;
            }
            type = static_cast<int>(number(0));
        }
        if (op == "SRC_TEX" || op == "DEST_TEX") {
            for (std::size_t index = 1; index <= 4; ++index) {
                if (!AnimationIntegerFits<short>(number(index) * 16.0)) {
                    return false;
                }
            }
            if (op == "DEST_TEX" && !AnimationIntegerFits<signed char>(number(5))) {
                return false;
            }
        }
        if (op == "SCROLL") {
            for (std::size_t axis = 0; axis < 2; ++axis) {
                if (type == MG_TEX_ANIME_TYPE_WAVE && !AnimationIntegerFits<short>(number(axis))) {
                    return false;
                }
                if (type == MG_TEX_ANIME_TYPE_SCROLL && std::abs(number(axis)) > static_cast<double>(std::numeric_limits<float>::max()) / 16.0) {
                    return false;
                }
            }
        }
        if ((op == "CLUT_COPY" || op == "ALPHA_BLEND" || op == "ALPHA_TEST") &&
            !AnimationIntegerFits<signed char>(number(0))) {
            return false;
        }
        if (op == "COLOR") {
            for (std::size_t index = 0; index < std::min<std::size_t>(command.args.size(), 4); ++index) {
                if (!AnimationIntegerFits<u_char>(number(index))) {
                    return false;
                }
            }
        }
        if (op == "ALPHA_TEST" && !AnimationIntegerFits<u_char>(number(1))) {
            return false;
        }
        if (op == "WAIT" && number(1) == 0.0 && !AnimationIntegerFits<short>(number(0))) {
            return false;
        }
    }
    return true;
}

void ApplyAnimation(mgCTextureManager *manager, const texture_catalog::Source &source, const texture_catalog::Entry &entry,
                    mgCMemory *stack, int base_block) {
    if (!stack || !ValidAnimationNumbers(entry)) {
        return;
    }
    // Animation groups share the set's arena, so their pictures must belong to the set's blocks.
    std::vector<int> own_blocks;
    for (const auto &picture : source.entries) {
        if (picture.type != "cfg" && std::ranges::find(own_blocks, base_block + picture.block) == own_blocks.end()) {
            own_blocks.push_back(base_block + picture.block);
        }
    }
    auto find_texture = [manager, &own_blocks](std::string &name) {
        for (const int block : own_blocks) {
            if (mgCTexture *texture = manager->GetTexture(name.data(), block)) {
                return texture;
            }
        }
        return manager->GetTexture(name.data(), -1);
    };
    auto &registered = NativeAnimations()[manager];
    auto  operands = [](const texture_catalog::Entry &definition) {
        std::vector<std::string> result;
        for (const auto &command : definition.script) {
            if ((command.name == "SRC_TEX" || command.name == "DEST_TEX" || command.name == "TEX_ANIME") &&
                !command.args.empty() && command.args[0].text) {
                result.push_back(command.name + ":" + DecodeName(*command.args[0].text));
            }
        }
        return result;
    };
    const auto targets = operands(entry);
    auto       live = [manager](const NativeAnimationGroup &group) {
        const auto *block = manager->GetTextureBlock(group.block);
        return block && block->anime == group.animation && group.group < group.animation->group_num &&
               group.animation->list[group.group] == group.head;
    };
    std::erase_if(registered, [&live](const auto &animation) {
        return std::none_of(animation.groups.begin(), animation.groups.end(), live);
    });
    auto previous = std::ranges::find_if(registered, [&](const auto &animation) {
        return animation.block == base_block && animation.definition.name == entry.name && animation.suffix == manager->name_suffix &&
               operands(animation.definition) == targets;
    });
    auto same = [](const texture_catalog::Entry &left, const texture_catalog::Entry &right) {
        if (left.script.size() != right.script.size()) {
            return false;
        }
        for (std::size_t command = 0; command < left.script.size(); ++command) {
            const auto &a = left.script[command];
            const auto &b = right.script[command];
            if (a.name != b.name || a.args.size() != b.args.size()) {
                return false;
            }
            for (std::size_t arg = 0; arg < a.args.size(); ++arg) {
                if (a.args[arg].text != b.args[arg].text || a.args[arg].number != b.args[arg].number) {
                    return false;
                }
            }
        }
        return true;
    };
    if (previous != registered.end()) {
        if (same(previous->definition, entry) && std::all_of(previous->groups.begin(), previous->groups.end(), live)) {
            return;
        }
        for (const auto &group : previous->groups) {
            if (live(group)) {
                group.animation->DeleteGroup(group.group);
            }
        }
        registered.erase(previous);
    }
    NativeAnimation                            registration{.block = base_block, .suffix = manager->name_suffix, .definition = entry, .groups = {}};
    mgCTexAnimeData                            data;
    std::string                                group_name;
    int                                        enabled = 0;
    int                                        bug_patch = 0;
    std::unordered_map<mgCTextureAnime *, int> active_groups;
    for (const auto &command : entry.script) {
        const auto &args = command.args;
        auto        number = [&args](size_t index, double fallback = 0) -> double {
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
            data.src_tex = find_texture(name);
            data.src_x = static_cast<short>(number(1) * 16);
            data.src_y = static_cast<short>(number(2) * 16);
            data.src_w = static_cast<short>(number(3) * 16);
            data.src_h = static_cast<short>(number(4) * 16);
        } else if (op == "DEST_TEX") {
            std::string name = named(0);
            data.dest_tex = find_texture(name);
            data.dest_x = static_cast<short>(number(1) * 16);
            data.dest_y = static_cast<short>(number(2) * 16);
            data.dest_w = args.size() > 3 ? static_cast<short>(number(3) * 16) : data.src_w;
            data.dest_h = args.size() > 4 ? static_cast<short>(number(4) * 16) : data.src_h;
            if (args.size() > 5) {
                data.bilinear = static_cast<signed char>(number(5));
            }
        } else if (op == "SCROLL") {
            if (data.type == MG_TEX_ANIME_TYPE_SCROLL) {
                // Saturating float conversion preserves retail's still-axis period of -1.
                const float sx = 16.0f * static_cast<float>(number(0));
                const float sy = 16.0f * static_cast<float>(number(1));
                data.period_x = static_cast<short>(fptosi(static_cast<float>(data.dest_w - 16) / sx));
                data.period_y = static_cast<short>(fptosi(static_cast<float>(data.dest_h - 16) / sy));
            } else if (data.type == MG_TEX_ANIME_TYPE_WAVE) {
                for (int axis = 0; axis < 2; ++axis) {
                    const double value = number(axis);
                    const int    whole = static_cast<int>(value);
                    const double fraction = value - whole;
                    (axis == 0 ? data.period_x : data.period_y) = static_cast<short>(whole);
                    (axis == 0 ? data.amplitude_x : data.amplitude_y) =
                        static_cast<short>(std::abs(fraction) < 0.001 ? 10000 : static_cast<int>(fraction * 10000));
                }
            }
        } else if (op == "CLUT_COPY") {
            data.clut_copy = static_cast<signed char>(number(0));
        } else if (op == "COLOR") {
            if (!args.empty()) {
                data.r = static_cast<u_char>(number(0));
            }
            if (args.size() > 1) {
                data.g = static_cast<u_char>(number(1));
            }
            if (args.size() > 2) {
                data.b = static_cast<u_char>(number(2));
            }
            if (args.size() > 3) {
                data.a = static_cast<u_char>(number(3));
            }
        } else if (op == "ALPHA_BLEND") {
            if (!args.empty()) {
                data.alpha_blend = static_cast<signed char>(number(0));
            }
        } else if (op == "ALPHA_TEST") {
            if (!args.empty()) {
                data.alpha_test = static_cast<signed char>(number(0));
            }
            if (args.size() > 1) {
                data.alpha_ref = static_cast<u_char>(number(1));
            }
        } else if (op == "WAIT") {
            data.wait = number(1) != 0 ? MG_TEX_ANIME_WAIT_FOREVER : static_cast<short>(number(0));
        } else if (op == "BUG_PATCH") {
            bug_patch = 1;
        } else if (op == "TEX_ANIME_END") {
            active_groups.clear();
        } else if (op == "TEX_ANIME_DATA_END") {
            mgCTexture *texture = data.src_tex ? data.src_tex : data.dest_tex;
            if (!texture || !data.src_tex || !data.dest_tex) {
                continue;
            }
            auto own = [&own_blocks](const mgCTexture *picture) { return std::ranges::find(own_blocks, picture->block) != own_blocks.end(); };
            if (!own_blocks.empty() && (!own(data.src_tex) || !own(data.dest_tex))) {
                continue;
            }
            mgCTextureBlock *block = manager->GetTextureBlock(texture->block);
            if (!block) {
                continue;
            }
            if (!block->anime) {
                block->anime = dc2::memory::NewObject<mgCTextureAnime>(*stack);
                if (!block->anime) {
                    continue;
                }
            }
            auto      *anime = block->anime;
            auto       found = active_groups.find(anime);
            const bool new_group = found == active_groups.end();
            int        group = new_group ? anime->GetEmptyGroup() : found->second;
            if (group < 0) {
                continue;
            }
            active_groups[anime] = group;
            data.group = static_cast<signed char>(group);
            if (new_group) {
                char *name = dc2::memory::NewArray<char>(*stack, group_name.size() + 1);
                if (name == nullptr) {
                    throw std::length_error("texture animation name exceeds arena capacity");
                }
                std::memcpy(name, group_name.c_str(), group_name.size() + 1);
                anime->SetGroupName(group, name);
                if (enabled) {
                    anime->Enable(group);
                } else {
                    anime->Disable(group);
                }
            }
            anime->EnterTexAnime(&data, stack);
            if (new_group) {
                registration.groups.push_back({.block = texture->block, .group = group, .animation = anime, .head = anime->list[group]});
            }
        }
    }
    // A script with unresolved texture operands must be allowed to run after its pictures arrive.
    if (!registration.groups.empty()) {
        registered.push_back(std::move(registration));
    }
}

} // namespace

mgCTexture *MgTextureEnterCatalog(mgCTextureManager *manager, int block, const texture_catalog::Entry &entry) {
    if (manager == nullptr || entry.type != "texture") {
        return nullptr;
    }
    return EnterCatalog(manager, block, entry);
}

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
                auto          &level = pixels.levels.emplace_back(static_cast<size_t>(canvas_width) *
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
                auto          &logical = pixels.logical_levels[mip];
                auto          &baseline = pixels.baseline[mip];
                const uint32_t width = std::max(1, texture->width >> mip);
                const uint32_t physical_width = std::max(1u, pixels.width >> mip);
                const uint32_t physical_height = std::max(1u, pixels.height >> mip);
                for (size_t offset = 0; offset < logical.size(); offset += 4) {
                    if (std::memcmp(logical.data() + offset, baseline.data() + offset, 4) == 0) {
                        continue;
                    }
                    const uint32_t x = (offset / 4 % width) * scale;
                    const uint32_t y = (offset / 4 / width) * scale;
                    for (uint32_t py = y; py < std::min(y + scale, physical_height); ++py) {
                        for (uint32_t px = x; px < std::min(x + scale, physical_width); ++px) {
                            std::memcpy(pixels.levels[mip].data() + (static_cast<size_t>(py) * physical_width + px) * 4,
                                        logical.data() + offset, 4);
                        }
                    }
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
    if (found == Registry().entries.end()) {
        return nullptr;
    }
    auto         *manager = const_cast<mgCTextureManager *>(found->second.owner);
    CatalogPixels pixels;
    const auto    stored = catalog_pixels.find(source);
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
            auto     *color = mip_pixels.data() + i;
            const int grey = (color[0] + color[1] + color[2]) / 3;
            switch (mode) {
                case MgTextureColorMode::IconHighlight:
                    if (grey > 8 && color[2] != 0) {
                        color[2] = 255;
                    }
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
    for (size_t mip = 0; mip < pixels.levels.size(); ++mip) {
        images[mip] = AsQuadwords(pixels.levels[mip].data());
    }
    entering_catalog = true;
    auto *texture = manager->EnterTexture(source->block, name, images, source->width, source->height,
                                          32, nullptr, source->tex1_bits, 0);
    entering_catalog = false;
    if (texture) {
        MakeLogicalPixels(texture, pixels);
        catalog_pixels.insert_or_assign(texture, std::move(pixels));
        BindLogicalPixels(texture, catalog_pixels.at(texture));
        ResolveTexture(texture);
    }
    return texture;
}

void MgTextureSetDrawVariant(const mgCTexture *source, mgCTexture *variant) {
    const auto found = Registry().entries.find(source);
    if (found != Registry().entries.end()) {
        found->second.draw_variant = variant;
    }
}

mgCTexture *MgTextureDrawVariant(mgCTexture *source) {
    const auto found = Registry().entries.find(source);
    return found != Registry().entries.end() && found->second.draw_variant ? found->second.draw_variant : source;
}

bool MgTextureSelectVariant(mgCTexture *texture, std::string_view selector) {
    auto found = catalog_pixels.find(texture);
    if (found == catalog_pixels.end() || !found->second.record) {
        return false;
    }
    CatalogPixels &pixels = found->second;
    if (pixels.selector == selector) {
        return true;
    }
    const auto &variants = pixels.record->variants;
    const auto  variant = std::ranges::find_if(variants, [selector](const auto &value) {
        return value.selector == selector;
    });
    if (variant == variants.end()) {
        return false;
    }
    datapacks::DecodedTexture decoded;
    if (!DecodeVariant(pixels, static_cast<size_t>(variant - variants.begin()), decoded)) {
        return false;
    }
    ButtonGlyphsApply(pixels.record->name, pixels.record->width, pixels.record->height, decoded);
    pixels.levels = std::move(decoded.levels);
    pixels.width = decoded.width;
    pixels.height = decoded.height;
    Registry().entries.at(texture).uploaded = false;
    pixels.selector = selector;
    MakeLogicalPixels(texture, pixels);
    BindLogicalPixels(texture, pixels);
    MgTexturePixelsChanged(texture);
    return true;
}

/**
 * Rebuilds active button glyph pixels when the selected device style changes.
 */
void MgTextureRefreshButtonGlyphs() {
    static std::string applied = ButtonGlyphsStyle();
    const std::string  style = ButtonGlyphsStyle();
    if (style == applied) {
        return;
    }
    applied = style;
    for (auto &[texture, pixels] : catalog_pixels) {
        if (!pixels.record || !ButtonGlyphsTarget(pixels.record->name) || pixels.logical_levels.empty() ||
            texture->image[0] != reinterpret_cast<u_long128 *>(pixels.logical_levels[0].data())) {
            continue;
        }
        const auto               &variants = pixels.record->variants;
        const auto                variant = std::ranges::find_if(variants, [&](const auto &value) {
            return value.selector == pixels.selector;
        });
        const auto                index = variant == variants.end() ? std::size_t{0} : static_cast<std::size_t>(variant - variants.begin());
        datapacks::DecodedTexture decoded;
        if (!DecodeVariant(pixels, index, decoded)) {
            continue;
        }
        ButtonGlyphsApply(pixels.record->name, pixels.record->width, pixels.record->height, decoded);
        pixels.levels = std::move(decoded.levels);
        pixels.width = decoded.width;
        pixels.height = decoded.height;
        if (auto entry = Registry().entries.find(texture); entry != Registry().entries.end()) {
            entry->second.uploaded = false;
        }
        MakeLogicalPixels(texture, pixels);
        BindLogicalPixels(const_cast<mgCTexture *>(texture), pixels);
        MgTexturePixelsChanged(texture);
    }
}

std::string_view MgTextureVariantSelector(const mgCTexture *texture) {
    const auto found = catalog_pixels.find(texture);
    return found == catalog_pixels.end() ? std::string_view{} : std::string_view(found->second.selector);
}

texture_catalog::AnimationMode MgTextureAnimationMode(const mgCTexture *texture) {
    const auto found = catalog_pixels.find(texture);
    if (found != catalog_pixels.end() && found->second.record) {
        return found->second.record->animation_mode;
    }
    if (texture && texture->bpp == 8) {
        return texture_catalog::AnimationMode::CopyVariant;
    }
    return texture && texture->bpp > 0 && texture->bpp < 24
               ? texture_catalog::AnimationMode::Copy
               : texture_catalog::AnimationMode::Draw;
}

bool MgTextureEnteredFrom(const mgCTexture *texture, const texture_catalog::Source &source) {
    const auto found = catalog_pixels.find(texture);
    if (found == catalog_pixels.end() || !found->second.record || found->second.record_source != source.source) {
        return false;
    }
    const auto &registered = *found->second.record;
    return std::ranges::any_of(source.entries, [&registered](const auto &entry) {
        if (entry.type != registered.type || entry.name != registered.name || entry.block != registered.block ||
            !SameDefinition(entry, registered)) {
            return false;
        }
        for (std::size_t index = 0; index < entry.variants.size(); ++index) {
            if (entry.variants[index].levels != registered.variants[index].levels) {
                return false;
            }
        }
        return true;
    });
}

MgTextureExtent MgTexturePhysicalExtent(const mgCTexture *texture) {
    if (!texture) {
        return {};
    }
    const auto found = catalog_pixels.find(texture);
    if (found != catalog_pixels.end()) {
        return {.width = found->second.width, .height = found->second.height};
    }
    const auto     entry = Registry().entries.find(texture);
    const uint32_t scale = entry != Registry().entries.end() ? entry->second.physical_scale : 1;
    return {.width = (1u << texture->tex0.TW) * scale, .height = (1u << texture->tex0.TH) * scale};
}

void MgTextureSetPhysicalScale(const mgCTexture *texture, uint32_t scale) {
    const auto found = Registry().entries.find(texture);
    scale = std::max(1u, scale);
    if (found != Registry().entries.end() && !found->second.catalog && found->second.physical_scale != scale) {
        found->second.physical_scale = scale;
        // The next lookup rebuilds the image at the new canvas size.
        found->second.uploaded = false;
    }
}

MgTextureExtent MgTextureLogicalExtent(uint64_t tex0) {
    sceGsTex0 reg;
    reg.value = tex0;
    return {.width = 1u << reg.TW, .height = 1u << reg.TH};
}

MgTextureExtent MgTexturePhysicalExtent(uint64_t tex0) {
    sceGsTex0 reg;
    reg.value = tex0;
    const auto *texture = TextureForKey(reg.TBP0);
    return texture ? MgTexturePhysicalExtent(texture) : MgTextureLogicalExtent(tex0);
}

float MgTextureImageScale(gfx::TextureHandle image) {
    const auto found = Registry().textures_by_image.find(image);
    if (found == Registry().textures_by_image.end()) {
        return 1.0f;
    }
    const auto *texture = found->second;
    return static_cast<float>(MgTexturePhysicalExtent(texture).width) / (1u << texture->tex0.TW);
}

bool MgTextureCopyRegion(const mgCTexture *source, int sx, int sy, mgCTexture *destination,
                         int dx, int dy, int width, int height) {
    if (!destination || destination->bpp != 32 || !destination->image[0] ||
        !Registry().entries.contains(destination) || width <= 0 || height <= 0 || dx < 0 || dy < 0 ||
        dx + width > destination->width || dy + height > destination->height ||
        (source && (source->bpp != 32 || !source->image[0] || sx < 0 || sy < 0 ||
                    sx + width > source->width || sy + height > source->height))) {
        return false;
    }
    const uint32_t source_scale = source ? MgTexturePhysicalExtent(source).width / (1u << source->tex0.TW) : 1;
    const auto     previous = catalog_pixels.find(destination);
    const uint32_t old_scale = previous != catalog_pixels.end()
                                   ? previous->second.width / (1u << destination->tex0.TW)
                                   : 1;
    const uint32_t scale = std::max(source_scale, old_scale);
    const uint32_t physical_width = (1u << destination->tex0.TW) * scale;
    const uint32_t physical_height = (1u << destination->tex0.TH) * scale;
    if (physical_width > kMaxCanvasSide || physical_height > kMaxCanvasSide ||
        (uint64_t{physical_width} * physical_height + uint64_t{width} * height * scale * scale) * 4 > kCanvasByteBudget) {
        return false;
    }
    auto      &pixels = catalog_pixels[destination];
    const auto source_pixels = catalog_pixels.find(source);
    if (pixels.levels.empty() || scale != old_scale) {
        std::vector<uint8_t> expanded(static_cast<size_t>(physical_width) * physical_height * 4);
        for (int y = 0; y < destination->height * static_cast<int>(scale); ++y) {
            for (int x = 0; x < destination->width * static_cast<int>(scale); ++x) {
                const uint8_t *old = pixels.levels.empty()
                                         ? AsBytes(destination->image[0]) + (static_cast<size_t>(y / scale) * destination->width + x / scale) * 4
                                         : pixels.levels[0].data() + (static_cast<size_t>(y * old_scale / scale) * pixels.width + x * old_scale / scale) * 4;
                std::memcpy(expanded.data() + (static_cast<size_t>(y) * physical_width + x) * 4, old, 4);
            }
        }
        pixels.levels = {std::move(expanded)};
        pixels.width = physical_width;
        pixels.height = physical_height;
        Registry().entries.at(destination).uploaded = false;
    }
    // Copy through a temporary so overlapping atlas regions have memmove semantics.
    std::vector<uint8_t> copied(static_cast<size_t>(width) * height * scale * scale * 4);
    if (source) {
        for (int y = 0; y < height * static_cast<int>(scale); ++y) {
            for (int x = 0; x < width * static_cast<int>(scale); ++x) {
                const uint8_t *from = source_pixels == catalog_pixels.end()
                                          ? AsBytes(source->image[0]) + (static_cast<size_t>(sy + y / scale) * source->width + sx + x / scale) * 4
                                          : source_pixels->second.levels[0].data() +
                                                (static_cast<size_t>(sy * source_scale + y * source_scale / scale) * source_pixels->second.width +
                                                 sx * source_scale + x * source_scale / scale) *
                                                    4;
                std::memcpy(copied.data() + (static_cast<size_t>(y) * width * scale + x) * 4, from, 4);
            }
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
    if (!source || !destination || destination->image[0] || !Registry().entries.contains(destination)) {
        return;
    }
    const uint32_t scale = MgTexturePhysicalExtent(source).width / (1u << source->tex0.TW);
    const auto     previous = MgTexturePhysicalExtent(destination);
    if (scale <= previous.width / (1u << destination->tex0.TW)) {
        return;
    }
    const uint64_t width = uint64_t{1u << destination->tex0.TW} * scale;
    const uint64_t height = uint64_t{1u << destination->tex0.TH} * scale;
    if (width > kMaxCanvasSide || height > kMaxCanvasSide || width * height * 4 > kCanvasByteBudget) {
        return;
    }
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

    Resolve(texture, found->second);
    return {.texture = found->second.image, .palette = gfx::kNullTexture};
}

MgTextureHandles MgTextureLookupTex0(uint64_t tex0) {
    sceGsTex0 reg;
    reg.value = tex0;

    MgTextureHandles handles;

    if (const mgCTexture *texture = TextureForKey(reg.TBP0)) {
        Entry &entry = Registry().entries.at(texture);
        Resolve(texture, entry);
        handles.texture = entry.image;
    }

    return handles;
}

void mgCTextureManager::SetTableBuffer(int texture_count, int block_total, mgCMemory *memory) {
    if (memory == nullptr || memory->lock != 0 || texture_count <= 0 || block_total <= 0) {
        throw std::invalid_argument("texture table needs positive counts and an unlocked arena");
    }
    const auto block_quads = dc2::memory::ArrayQuadwords<mgCTextureBlock>(static_cast<std::size_t>(block_total));
    const auto texture_quads = dc2::memory::ArrayQuadwords<mgCTexture>(static_cast<std::size_t>(texture_count));
    const auto texture_ptr_quads = dc2::memory::ArrayQuadwords<mgCTexture *>(static_cast<std::size_t>(texture_count));
    const auto hash_quads = dc2::memory::ArrayQuadwords<mgTEXTURE_HASH>(static_cast<std::size_t>(texture_count));
    const auto hash_ptr_quads = dc2::memory::ArrayQuadwords<mgTEXTURE_HASH *>(static_cast<std::size_t>(texture_count));
    if (!block_quads || !texture_quads || !texture_ptr_quads || !hash_quads || !hash_ptr_quads) {
        throw std::length_error("texture table allocation exceeds native block size");
    }
    const std::size_t total_quads = static_cast<std::size_t>(*block_quads) + *texture_quads +
                                    *texture_ptr_quads + *hash_quads + *hash_ptr_quads;
    if (total_quads >= dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        throw std::length_error("texture table exceeds remaining arena capacity");
    }

    auto *new_blocks = dc2::memory::NewArray<mgCTextureBlock>(*memory, static_cast<std::size_t>(block_total));
    auto *new_textures = dc2::memory::NewArray<mgCTexture>(*memory, static_cast<std::size_t>(texture_count));
    auto *new_texture_stack = dc2::memory::NewArray<mgCTexture *>(*memory, static_cast<std::size_t>(texture_count));
    auto *new_hashes = dc2::memory::NewArray<mgTEXTURE_HASH>(*memory, static_cast<std::size_t>(texture_count));
    auto *new_hash_stack = dc2::memory::NewArray<mgTEXTURE_HASH *>(*memory, static_cast<std::size_t>(texture_count));
    if (new_blocks == nullptr || new_textures == nullptr || new_texture_stack == nullptr ||
        new_hashes == nullptr || new_hash_stack == nullptr) {
        throw std::length_error("texture table allocation failed");
    }

    const auto capture = [&]<class T>(T *data, std::size_t count) {
        auto bytes = std::as_writable_bytes(std::span(data, count));
        return dc2::memory::ArenaBuffer::Bind(*memory, std::span(reinterpret_cast<u8 *>(bytes.data()), bytes.size()));
    };
    const std::array captures{
        capture(new_blocks, static_cast<std::size_t>(block_total)),
        capture(new_textures, static_cast<std::size_t>(texture_count)),
        capture(new_texture_stack, static_cast<std::size_t>(texture_count)),
        capture(new_hashes, static_cast<std::size_t>(texture_count)),
        capture(new_hash_stack, static_cast<std::size_t>(texture_count))};
    if (std::ranges::any_of(captures, [](const auto &allocation) { return allocation.Bytes().empty(); })) {
        throw std::length_error("texture table has no live allocation producer");
    }
    ReleaseOwned(this);
    table_storage = captures;
    table_storage_bound = true;

    blocks = new_blocks;
    block_max = block_total;
    texture_buf = new_textures;
    texture_max = texture_count;
    texture_stack = new_texture_stack;
    hash_buf = new_hashes;
    hash_max = texture_count;
    hash_stack = new_hash_stack;

    for (int slot = 0; slot < texture_max; slot++) {
        texture_stack[slot] = &texture_buf[slot];
    }

    texture_num = 0;
    for (int node = 0; node < hash_max; node++) {
        hash_stack[node] = hash_buf + node;
    }

    hash_num = 0;
    std::ranges::fill(hash_table, nullptr);
    fix_block.Initialize();
    name_suffix[0] = '\0';
    last_block = -1;
    for (auto &block : std::span(blocks, static_cast<std::size_t>(block_max))) {
        block.Initialize();
    }
}

void mgCTextureManager::Initialize(int start, int end) {
    (void) ValidateTableStorage();
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

mgCTexture *mgCTextureManager::EnterTexture(int block, char *name, u_long128 **image, int width,
                                            int height, int bpp, u_long128 * /*clut*/, u_long tex1,
                                            int swizzled) {
    if (name == nullptr) {
        return nullptr;
    }

    std::string combined_name(name);
    combined_name += dc2::text::View(name_suffix);
    if (combined_name.size() >= sizeof(mgCTexture::name)) {
        return nullptr;
    }
    char full_name[0x20];
    std::memcpy(full_name, combined_name.c_str(), combined_name.size() + 1);

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

    dc2::text::Copy(texture->name, combined_name);
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
    if (!entering_catalog) {
        Resolve(texture, registered);
    }

    if (mgGetPerformanceMeterFlag()) {
        std::println("b = {},{} vram = {}", block, texture->name, texture->vram_size);
    }

    return texture;
}

mgCTexture *mgCTextureManager::EnterTexture(int id, char *name, TM2_head *head, int /*reload*/,
                                            int /*no_image*/) {
    if (head == nullptr || name == nullptr) {
        return nullptr;
    }
    const auto  source_name = TextureSourceLookup(head);
    const auto *source = source_name ? texture_catalog::Find(*source_name) : nullptr;
    if (!source) {
        CT_LOG_ERROR(Data, "texture: no catalog source for {}", name);
        return nullptr;
    }
    for (const auto &entry : source->entries) {
        if (entry.type == "texture" && (DecodeName(entry.name) == name || source->entries.size() == 1)) {
            return EnterCatalog(this, id, entry, {}, {}, source->source);
        }
    }
    CT_LOG_ERROR(Data, "texture: {} has no entry in {}", name, *source_name);
    return nullptr;
}

namespace {
/** Catalog entries decoded together ahead of registration. */
constexpr std::size_t kPrefetchBatch = 32;

int EnterSource(mgCTextureManager *manager, int block, const texture_catalog::Source &source,
                mgCMemory *stack, mgCEnterIMGInfo *info, const MgTextureImageDecoder &decoder,
                const MgTextureImageIdentity &identity = {}) {
    if (!manager) {
        return 0;
    }
    auto valid_group = [block](int group) {
        const auto target = static_cast<std::int64_t>(block) + group;
        return group >= 0 && target >= std::numeric_limits<int>::min() && target <= std::numeric_limits<int>::max();
    };
    if (std::ranges::any_of(source.entries, [&valid_group](const auto &entry) { return !valid_group(entry.block); }) ||
        std::ranges::any_of(source.groups, [&valid_group](int group) { return !valid_group(group); })) {
        return 0;
    }
    if (info) {
        for (int i = 0; i < MG_TEXTURE_IMG_GROUP_MAX; ++i) {
            info->block[i] = -1;
            info->block_num[i] = 0;
        }
    }
    std::vector<const texture_catalog::Entry *> entries;
    entries.reserve(source.entries.size());
    for (const auto &entry : source.entries) {
        entries.push_back(&entry);
    }
    int last_block = block;
    for (std::size_t index = 0; index < entries.size(); ++index) {
        const auto *entry = entries[index];
        // Upscaled pack PNGs take tens of milliseconds each to decode, so the catalog decodes are spread over
        // worker threads a batch ahead; batches keep them inside the decode cache until they are entered.
        if (!decoder && index % kPrefetchBatch == 0) {
            datapacks::PrefetchEntries(std::span(entries).subspan(index, std::min(kPrefetchBatch, entries.size() - index)));
        }
        if (entry->type == "cfg") {
            ApplyAnimation(manager, source, *entry, stack, block);
            continue;
        }
        const int group = entry->block;
        const int target = block + group;
        if (mgCTexture *texture = EnterCatalog(manager, target, *entry, decoder, identity, source.source)) {
            last_block = std::max(last_block, static_cast<int>(texture->block));
            if (info && group < MG_TEXTURE_IMG_GROUP_MAX && info->block[group] < 0) {
                info->block[group] = target;
                info->block_num[group] = 1;
            }
        }
    }
    if (info) {
        for (const int group : source.groups) {
            if (group < MG_TEXTURE_IMG_GROUP_MAX && info->block[group] < 0) {
                info->block[group] = block + group;
                info->block_num[group] = 1;
            }
        }
    }
    const auto difference = static_cast<std::int64_t>(last_block) - block;
    return difference <= std::numeric_limits<int>::max() ? static_cast<int>(difference) : 0;
}
} // namespace

int MgTextureEnterDocument(mgCTextureManager *manager, std::string_view relative_json_path, int block,
                           mgCMemory *stack, mgCEnterIMGInfo *info) {
    CT_PROFILE_ZONE("Load texture document");
    CT_PROFILE_TEXT(relative_json_path.data(), relative_json_path.size());
    const auto *source = texture_catalog::Find(relative_json_path);
    if (!source) {
        CT_LOG_ERROR(Data, "texture: no native texture document for {}", relative_json_path);
        return 0;
    }
    return EnterSource(manager, block, *source, stack, info, {}, [](const texture_catalog::Entry &entry, std::size_t variant) {
        return datapacks::DecodeIdentity(entry, variant);
    });
}

int MgTextureEnterNativeSet(mgCTextureManager *manager, int block, const texture_catalog::Source &source,
                            mgCMemory *stack, const MgTextureImageDecoder &decoder, const MgTextureImageIdentity &identity) {
    if (!decoder) {
        return 0;
    }
    return EnterSource(manager, block, source, stack, nullptr, decoder, identity);
}

int mgCTextureManager::EnterIMGFile(u_char *img, int block, mgCMemory *stack,
                                    mgCEnterIMGInfo *info) {
    if (!img) {
        return 0;
    }
    const auto source_name = TextureSourceLookup(img);
    return source_name ? MgTextureEnterDocument(this, *source_name, block, stack, info) : 0;
}

int mgGetIMGHeaderNum(char *img) {
    const auto  source_name = TextureSourceLookup(img);
    const auto *source = source_name ? texture_catalog::Find(*source_name) : nullptr;
    if (!source) {
        return 0;
    }
    return static_cast<int>(std::count_if(source->entries.begin(), source->entries.end(), [](const auto &entry) {
        return entry.type == "cfg" || entry.picture == 0;
    }));
}

mgIMG_HEADER mgGetIMGHeader(char *img, int index) {
    mgIMG_HEADER header{};
    const auto   source_name = TextureSourceLookup(img);
    const auto  *source = source_name ? texture_catalog::Find(*source_name) : nullptr;
    if (!source || index < 0) {
        return header;
    }
    const texture_catalog::Entry *selected = nullptr;
    for (const auto &entry : source->entries) {
        if (entry.type != "cfg" && entry.picture != 0) {
            continue;
        }
        if (index-- == 0) {
            selected = &entry;
            break;
        }
    }
    if (!selected) {
        return header;
    }
    const auto       &entry = *selected;
    const std::string name = DecodeName(entry.name);
    if (name.size() >= sizeof header.name) {
        return {};
    }
    std::memcpy(header.name, name.c_str(), name.size() + 1);
    header.block = entry.block;
    header.swizzled = entry.swizzled;
    header.no_image = entry.no_image;
    header.clamp_bits = entry.clamp;
    return header;
}

int mgCTextureManager::GetRemainVRAM(int block) {
    if (!ValidateTableStorage()) {
        return 0;
    }
    if (block < 0 || block >= block_max) {
        return 0;
    }

    return INT_MAX;
}

int mgLoadImage(u_int * /*unused*/, int /*unused*/, int /*unused*/, int /*unused*/, u_long128 * /*unused*/, int /*unused*/, int /*unused*/, int /*unused*/, int /*unused*/, int /*unused*/) {
    return 0;
}

void mgCTextureManager::ReloadTexture(int index, sceVif1Packet *packet) {
    if (!ValidateTableStorage()) {
        return;
    }
    if (blocks == nullptr || index < 0 || index >= block_max) {
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

int mgCTextureManager::ReloadTexture(int block, u_int *packet) {
    if (!ValidateTableStorage()) {
        return 0;
    }
    const bool in_range = blocks != nullptr && block >= 0 && block < block_max;

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

int mgCTextureManager::ReloadCLUT(mgCTexture * /*texture*/, u_int * /*unused*/) {
    // Retail palette uploads have no work to do: RGBA variants have their own texture keys.
    return 0;
}

void mgCTextureManager::ReloadCLUT(mgCTexture *texture, sceVif1Packet * /*unused*/) {
}

void mgCTextureManager::DeleteTexture(mgCTexture *texture) {
    if (!ValidateTableStorage()) {
        return;
    }
    if (texture == nullptr || texture_buf == nullptr || texture_max <= 0 ||
        std::ranges::none_of(std::span(texture_buf, static_cast<std::size_t>(texture_max)),
                             [texture](const auto &slot) { return std::addressof(slot) == texture; })) {
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
