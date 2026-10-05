#include "common.h"

#include <libgraph.h>
#include <libpkt.h>

#include <cstdio>
#include <cstring>

#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

/**
 * Gives the quadwords a buffer of the given bytes takes, rounded up.
 */
#define QWORDS(bytes) ((bytes) % 16 == 0 ? (bytes) / 16 : (bytes) / 16 + 1)

/**
 * Words of the DMA tags, VIF codes and GIF tags the upload chains are
 * built from.
 */
enum {
    DMA_ID_CNT = 0x10000000,   /**< DMA tag transferring the quadwords that follow it. */
    DMA_ID_REF = 0x30000000,   /**< DMA tag transferring quadwords from the address it holds. */
    VIF_DIRECT = 0x50000000,   /**< VIF code passing the quadwords that follow it to the GIF. */
    GIF_EOP = 0x8000,          /**< GIF tag lower word: last tag of the packet. */
    GIF_NREG_1 = 0x10000000,   /**< GIF tag upper word: one register descriptor. */
    GIF_FLG_IMAGE = 0x08000000 /**< GIF tag upper word: image data. */
};

static int Conv32To8(int width, int height, u_char *image);

/**
 * DMA chain flushing the GS texture cache, copied in front of and behind
 * every texture upload.
 */
extern u_char texflush_dma[0x30];

extern char at_497[];
extern char at_866[];
extern char at_884[];
extern char at_867[];
extern char at_868[];
extern u_char lut_1246[128];
extern int block_table8_1266[32];
extern int block_table32_1267[32];
extern "C" void *__construct_new_array(void *, void *(*)(void *), void *, u_int, int);
extern "C" void *__ct__10mgCTextureFv(void *);
extern "C" void *__ct__15mgCTextureBlockFv(void *);
extern "C" void *Alloc__9mgCMemoryFi(mgCMemory *, int);
static inline u_int align16_blocks(u_int n) {
    if (n & 0xF)
        return (n >> 4) + 1;
    return n >> 4;
}

#pragma schedule off

// Code (.text)
/**
 * Gives the VRAM block address of the Z buffer and stores the GS blocks
 * it spans, which 8-bit textures can borrow while it holds nothing.
 */
static int GetZBufVram(int *size) {
    mgCTexture frame;

    mgGetTextureZ(0);
    mgGetFrameBuffer(&frame);
    *size = frame.width * frame.width * 4 / 256;
    return mgZBUF_1.bits.zbp << 5;
}
#pragma schedule reset
#pragma schedule off

/**
 * Tells whether a texture can be placed in the Z buffer's VRAM, which
 * holds unswizzled 8-bit textures only, and stores the blocks it needs.
 */
static int CheckCopyToZBufVram(mgCTexture *texture, int *size) {
    *size = 0;

    if (texture->swizzled == 0 && texture->bpp == 8 && texture->image[0] != NULL) {
        *size = texture->vram_size * 4;
        return 1;
    }

    return 0;
}
#pragma schedule reset
#pragma schedule off
mgCTexture::mgCTexture() {
    Initialize();
}
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off

void mgCTexture::Initialize() {
    u_char *self = (u_char *)this;
    int i;
    *(signed char *)(self + 8) = 0;
    this->block = -1;
    for (i = 0; i < 4; i++) {
        *(int *)((i << 2) + (int)self + 0x50) = 0;
    }
    *(int *)(self + 0x60) = 0;
    *(long long *)(self + 0x48) = 0;
    *(long long *)(self + 0x40) = 0;
    *(long long *)(self + 0x38) = 0;
    struct TexFlags {
        u_char flags_low : 2;
        u_char flags_mid : 2;
        u_char flags_high : 4;
    };
    ((TexFlags *)(self + 0x48))->flags_low = 1;
    ((TexFlags *)(self + 0x48))->flags_mid = 1;
    *(short *)(self + 6) = 0;
    this->height = 0;
    this->width = 0;
    *(int *)(self + 0x64) = 0;
    *(int *)(self + 0x28) = 0;
    *(int *)(self + 0x2C) = 0;
    *(int *)(self + 0x30) = 0;
    *(int *)(self + 0x68) = 0;
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
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
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
mgCTextureBlock::mgCTextureBlock() {
    Initialize();
}
#pragma schedule reset
#pragma schedule off
void mgCTextureBlock::Initialize() {
    unk_4 = 0;
    unk_0 = 0;
    anime = NULL;
    texture = NULL;
}
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureBlock::Add(mgCTexture *texture) {
    texture->next = NULL;
    mgCTexture *node;
    if (this->texture == NULL) {
        this->texture = texture;
    } else {
        node = this->texture;
        while (node != NULL) {
            mgCTexture *next = node->next;
            if (next == NULL) {
                node->next = texture;
                break;
    }
            node = next;
        }
    }
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureBlock::Delete(mgCTexture *texture) {
    mgCTexture *node = this->texture;
    mgCTexture *prev = NULL;
    while (node != NULL) {
        if (node == texture) {
            if (prev == NULL) {
                this->texture = node->next;
            } else {
                prev->next = node->next;
            }
        }
        prev = node;
        node = node->next;
    }
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
mgCTextureManager::mgCTextureManager() : texture_max(0), hash_max(0) {
    block_max = 0;
    blocks = NULL;
}
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureManager::SetTableBuffer(int texture_count, int block_total, mgCMemory *memory) {
    int slot;
    int node;
    int count;
    u_int bytes;
    block_max = block_total;
    count = block_max;
    bytes = count * 0x10;
    blocks = (mgCTextureBlock *)__construct_new_array(
        (void *)operator new[](count * 0x10 + 0x10,
                               (u_long128 *)Alloc__9mgCMemoryFi(memory, align16_blocks(bytes) + 2)),
        __ct__15mgCTextureBlockFv, 0, 0x10, count);
    if (blocks == 0) {
        block_max = 0;
    }
    texture_max = texture_count;
    count = texture_max;
    bytes = count * 0x70;
    texture_buf = (mgCTexture *)__construct_new_array(
        (void *)operator new[](count * 0x70 + 0x10,
                               (u_long128 *)Alloc__9mgCMemoryFi(memory, align16_blocks(bytes) + 2)),
        __ct__10mgCTextureFv, 0, 0x70, count);
    bytes = texture_max * 4;
    texture_stack = (mgCTexture **)Alloc__9mgCMemoryFi(memory, align16_blocks(bytes));
    for (slot = 0; slot < texture_max; slot++) {
        texture_stack[slot] = &texture_buf[slot];
    }
    texture_num = 0;
    hash_max = texture_count;
    bytes = hash_max * 8;
    hash_buf = (mgTEXTURE_HASH *)operator new[](
        hash_max * 8, (u_long128 *)Alloc__9mgCMemoryFi(memory, align16_blocks(bytes) + 2));
    bytes = hash_max * 4;
    hash_stack = (mgTEXTURE_HASH **)Alloc__9mgCMemoryFi(memory, align16_blocks(bytes));
    for (node = 0; node < hash_max; node++) {
        hash_stack[node] = hash_buf + node;
    }
    hash_num = 0;
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureManager::Initialize(int start, int end) {
    int i;
    int slot;
    int bucket;
    int node;
    vram_top = start;
    vram_fix = end;
    if (vram_fix < 0) {
        vram_fix = 0x3FE0;
    }
    if (blocks != 0) {
    for (i = 0; i < block_max; i++) {
        blocks[i].Initialize();
    }
    fix_block.Initialize();
        for (slot = 0; slot < texture_max; slot++) {
            texture_stack[slot] = &texture_buf[slot];
    }
    texture_num = 0;
    for (i = 0; i < block_max; i++) {
            blocks[i].unk_0 = vram_top;

            ((mgCTextureBlock *)((i << 4) + (int)blocks))->unk_4 = vram_top;
    }
    last_block = -1;
        name_suffix[0] = 0;
        for (bucket = 0; bucket < 101; bucket++) {
            *(mgTEXTURE_HASH **)((bucket << 2) + (int)this + 0x24) = 0;
    }
        for (node = 0; node < hash_max; node++) {
            hash_stack[node] = hash_buf + node;
    }
    hash_num = 0;
}
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma optimization_level 2
int mgCTextureManager::hash(char *name) {
    u_char value;
    for (value = 0; *(signed char *)name != 0; name++) {
        value = (((value << 8) + *(signed char *)name) % 101);
    }
    return value;
}
#pragma optimization_level reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureManager::AddHash(mgCTexture *texture) {
    mgTEXTURE_HASH *node;
    mgTEXTURE_HASH *cur;
    mgTEXTURE_HASH *following;
    mgTEXTURE_HASH **bucket;
    if (hash_num >= hash_max) {
        node = NULL;
    } else {
        node = hash_stack[hash_num++];
    }
    if (node != NULL) {
        node->next = NULL;
        node->texture = texture;

        int index = hash((char *)texture + 8);
        bucket = (mgTEXTURE_HASH **)((index << 2) + (int)this + 0x24);
        cur = *bucket;
        if (cur == NULL) {
            *bucket = node;
    } else {
            while (cur != NULL) {
                following = cur->next;
                if (following == NULL) {
                    cur->next = node;
        return;
    }
                cur = following;
        }
    }
}
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureManager::DelHash(mgCTexture *texture) {
    mgTEXTURE_HASH *cur;
    mgTEXTURE_HASH *prev;
    mgTEXTURE_HASH *found;
    mgTEXTURE_HASH **bucket;
    if (texture != NULL) {
        int index = hash((char *)texture + 8);
        bucket = (mgTEXTURE_HASH **)((index << 2) + (int)this + 0x24);
        cur = *bucket;
        prev = NULL;
        found = NULL;
        while (cur != NULL) {
            if (cur->texture == texture) {
                found = cur;
            break;
        }
            prev = cur;
            cur = cur->next;
    }
        if (found != NULL) {
            if (prev == NULL) {
                *bucket = found->next;
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
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
mgCTexture *mgCTextureManager::SearchHash(char *name, int mode) {
    mgTEXTURE_HASH *node;
    int bucket = hash(name);

    for (node = *(mgTEXTURE_HASH **)((bucket << 2) + (int)this + 0x24); node != NULL;
         node = node->next) {
        if (strcmp(name, (char *)node->texture + 8) == 0) {
            if (mode < 0 || node->texture->block == mode) {
                return node->texture;
            }
        }
    }
    return NULL;
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
mgCTexture *mgCTextureManager::SearchTextureName(char *name, int block) {
    char full_name[128];

    if (name_suffix[0] != '\0') {
        strcpy(full_name, name);
        strcat(full_name, name_suffix);
        name = full_name;
    }

    return SearchHash(name, block);
}
#pragma schedule reset
#pragma schedule off
mgCTexture *mgCTextureManager::SearchTexture(char *name) {
    mgCTexture *slot;
    if (texture_num >= texture_max) {
        slot = NULL;
    } else {
        slot = texture_stack[texture_num++];
    }
    if (SearchTextureName(name, -1) != 0) {
        printf(at_497, name);
    }
    return slot;
}
#pragma schedule reset
#pragma schedule off
#pragma optimization_level 1
mgCTexture *mgCTextureManager::GetTexture(char *name, int block) {
    return SearchTextureName(name, block);
}
#pragma optimization_level reset
#pragma schedule reset
#pragma schedule off
mgCTextureBlock *mgCTextureManager::GetTextureBlock(int block) {
    if (block == MG_TEXTURE_BLOCK_FIX) {
        return &fix_block;
    }

    if (block < 0 || block >= block_max) {
        return NULL;
    }

    return &blocks[block];
}
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
int mgCTextureManager::GetRemainVRAM(int block) {
    mgCTexture *texture;
    int vram;
    int zbuf_remain;
    int size;

    if (block < 0 || block >= block_max) {
        return 0;
    }

    texture = blocks[block].texture;
    vram = vram_top;
    GetZBufVram(&zbuf_remain);

    for (; texture != NULL; texture = texture->next) {
        if (CheckCopyToZBufVram(texture, &size) && size <= zbuf_remain) {
            zbuf_remain -= size;
        } else {
            vram += texture->vram_size;
        }

        if (texture->bpp <= 8) {
            vram += MG_TEXTURE_CLUT_BLOCKS;
        }
    }

    return vram_fix - vram;
}
#pragma global_optimizer reset
#pragma schedule reset
#ifdef NONMATCHING
mgCTexture *mgCTextureManager::EnterTexture(int block, char *name, u_long128 **image, int width,
                                            int height, int bpp, u_long128 *clut, u_long tex1,
                                            int swizzled) {
    char full_name[0x20];
    u_long128 *no_image[MG_TEXTURE_LEVEL_MAX];
    mgCTextureBlock *texture_block;
    mgCTexture *texture;
    sceGsTex1 *lod;
    int psm;
    int tw;
    int th;
    int tbw;
    int power;
    int i;
    int level_blocks;
    int last_level;
    int vram;

    strcpy(full_name, name);
    strcat(full_name, name_suffix);

    if (full_name[0] == '\0') {
        return NULL;
    }

    texture_block = GetTextureBlock(block);

    if (texture_block == NULL) {
        return NULL;
    }

    if (image == NULL) {
        image = no_image;

        for (i = 0; i < MG_TEXTURE_LEVEL_MAX; i++) {
            image[i] = NULL;
        }
    }

    texture = SearchTexture(full_name);

    if (texture == NULL) {
        return NULL;
    }

    texture->Initialize();

    switch (bpp) {
        case 32:
            psm = SCE_GS_PSMCT32;
            break;
        case 24:
            psm = SCE_GS_PSMCT24;
            break;
        case 16:
            psm = SCE_GS_PSMCT16;
            break;
        case 8:
            psm = SCE_GS_PSMT8;
            break;
        case 4:
            psm = SCE_GS_PSMT4;
            break;
        default:
            return NULL;
    }

    tw = 0;
    th = 0;

    for (power = width; power >= 2; power /= 2) {
        tw++;
    }

    for (power = 1, i = 0; i < tw; i++) {
        power <<= 1;
    }

    if (width != power) {
        tw++;
    }

    for (power = height; power >= 2; power /= 2) {
        th++;
    }

    for (power = 1, i = 0; i < th; i++) {
        power <<= 1;
    }

    if (height != power) {
        th++;
    }

    tbw = width / 64;

    if (width % 64 != 0) {
        tbw++;
    }

    if (tbw <= 0) {
        tbw = 1;
    }

    // 24-bit pixels occupy 32 bits each in VRAM.
    level_blocks = (bpp == 24 ? 32 : bpp) * width * height / 256 / 8;
    texture->image_blocks = 0;
    last_level = -1;

    if (psm == SCE_GS_PSMT4 || psm == SCE_GS_PSMT8 || psm == SCE_GS_PSMCT16 ||
        psm == SCE_GS_PSMCT32 || psm == SCE_GS_PSMCT24) {
        for (i = 0; i < MG_TEXTURE_LEVEL_MAX; i++) {
            if (image[i] == NULL) {
                last_level = i - 1;
                break;
            }
        }

        for (i = 0; i < last_level + 1; i++) {
            texture->image[i] = image[i];

            if (image[i] != NULL) {
                texture->image_blocks += level_blocks;
            }

            level_blocks /= 4;
        }

        if (image[0] == NULL) {
            texture->image_blocks = level_blocks;
        }

        if (psm == SCE_GS_PSMT8) {
            texture->clut = clut;
            texture->clut_size = MG_TEXTURE_CLUT_BLOCKS;
            texture->tex0.value = SCE_GS_SET_TEX0(0, tbw, psm, tw, th, 1, 0, 0, 0, 0, 0, 1);
        } else if (psm == SCE_GS_PSMT4) {
            texture->clut = clut;
            texture->clut_size = MG_TEXTURE_CLUT_BLOCKS;
            texture->tex0.value = SCE_GS_SET_TEX0(0, tbw, psm, tw, th, 1, 0, 0, 0, 0, 0, 1);
        } else {
            texture->clut = NULL;
            texture->tex0.value = SCE_GS_SET_TEX0(0, tbw, psm, tw, th, 1, 0, 0, 0, 0, 0, 0);
        }
    }

    texture->vram_size = texture->image_blocks;

    if (texture->vram_size % MG_TEXTURE_PAGE_BLOCKS != 0) {
        texture->vram_size += MG_TEXTURE_PAGE_BLOCKS - texture->vram_size % MG_TEXTURE_PAGE_BLOCKS;
    }

    strcpy(texture->name, full_name);
    texture->width = width;
    texture->height = height;
    texture->bpp = bpp;
    texture->block = block;
    texture->swizzled = swizzled;
    *(u_long *)&texture->tex1 = SCE_GS_SET_TEX1(1, 0, 1, 1, 1, 0, 0);

    if (bpp > 0) {
        if (last_level > 0) {
            *(u_long *)&texture->tex1 = SCE_GS_SET_TEX1(0, 2, 1, 5, 1, 0, -120);

            if (tex1 != 0) {
                lod = (sceGsTex1 *)&tex1;
                *(u_long *)&texture->tex1 = SCE_GS_SET_TEX1(0, last_level, 1, 5, 1, lod->L, lod->K);
            }
        } else {
            *(u_long *)&texture->tex1 = SCE_GS_SET_TEX1(0, 0, 1, 1, 1, 0, 0);

            if (tex1 != 0) {
                *(u_long *)&texture->tex1 = SCE_GS_SET_TEX1(0, 0, 1, 1, 1, 0, 0);
            }
        }
    }

    texture_block->Add(texture);
    AddHash(texture);

    // Fixed textures are allocated downwards from the top of VRAM, each palette above its pixels.
    if (block == MG_TEXTURE_BLOCK_FIX) {
        vram = vram_fix;

        if (texture->bpp <= 8) {
            vram -= MG_TEXTURE_CLUT_BLOCKS;
            texture->tex0.CBP = vram;
        }

        texture->tex0.TBP0 = vram - texture->vram_size;
        vram_fix = vram - texture->vram_size;
    }

    if (mgGetPerformanceMeterFlag()) {
        printf("b = %d,%s vram = %d\n", block, texture->name, texture->vram_size);
    }

    return texture;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_texture", EnterTexture__17mgCTextureManagerFiPcPP1iiiP1Uli);
#endif
#pragma schedule off
#pragma optimization_level 2
mgCTexture *mgCTextureManager::EnterTexture(int id, char *name, TM2_head *head, int reload,
                                            int no_image) {
    u_char magic[8];
    u_long128 *images[4];
    TM2_PICTURE *pic;
    int width;
    int height;
    int pixel_bits;
    u_char *clut;
    u_char *mip;
    u_char *first;
    int level;

    memcpy(magic, head, 4);
    magic[4] = 0;
    pic = &head->picture;
    width = head->picture.width;
    height = head->picture.height;
    switch (head->picture.image_type) {
        case 1:
            pixel_bits = 0x10;
            break;
        case 2:
            pixel_bits = 0x18;
            break;
        case 3:
            pixel_bits = 0x20;
            break;
        case 4:
            pixel_bits = 4;
            break;
        case 5:
            pixel_bits = 8;
            break;
        default:
            return 0;
    }
    clut = NULL;
    for (int j = 0; j < 4; j++) {
        images[j] = NULL;
    }
        // The pixels follow the picture header; the palette follows every mip level.
    if (no_image == 0) {
        images[0] = (u_long128 *)((u_char *)pic + pic->header_size);
        if (pixel_bits <= 8) {
            clut = (u_char *)images[0] + pic->image_size;
        }
        if (pic->mipmap_count > 1) {
            mip = (u_char *)images[0] + pic->mip_sizes[0];
            for (level = 1; level < pic->mipmap_count; level++) {
                images[level] = (u_long128 *)mip;
                mip += pic->mip_sizes[level];
            }
        }
    }
    if (reload != 0 && pixel_bits == 8 && pic->mipmap_count == 1) {
        first = (u_char *)images[0];
        if (Conv32To8(width, height, first) != 0) {
            reload = 0;
    }
}
    return EnterTexture(id, name, images, width, height, pixel_bits, (u_long128 *)clut, pic->tex1,
                        reload);
}
#pragma optimization_level reset
#pragma schedule reset
#ifdef NONMATCHING
int mgCTextureManager::EnterIMGFile(u_char *img, int block, mgCMemory *stack,
                                    mgCEnterIMGInfo *info) {
    mgIMG_FILE_HEADER *file = (mgIMG_FILE_HEADER *)img;
    mgIMG_HEADER swap;
    mgIMG_HEADER *entries;
    mgIMG_HEADER *entry;
    mgIMG1_HEADER *entry1;
    mgCTexture *texture;
    int not_im2;
    int not_im3;
    int spill;
    int current_block;
    int last_block_used;
    int texture_block;
    int swizzled;
    int offset;
    int i;
    u_int a;
    u_int b;

    if (img == NULL) {
        return 0;
    }

    if (memcmp(img, "IM", 2) != 0) {
        return 0;
    }

    not_im2 = memcmp(img, "IM2", 3);
    not_im3 = memcmp(img, "IM3", 3);

    if (info != NULL) {
        for (i = 0; i < MG_TEXTURE_IMG_GROUP_MAX; i++) {
            info->block[i] = -1;
            info->block_num[i] = 0;
        }
    }

    spill = 0;
    current_block = block;
    last_block_used = block;

    if (not_im3 == 0) {
        entries = (mgIMG_HEADER *)(file + 1);

        // Order the pictures by group, leaving texture animation scripts where they are.
        for (a = 0; a < file->num3 - 1; a++) {
            for (b = a + 1; b < file->num3; b++) {
                if (entries[a].block < 0) {
                    entries[a].block = 0;
                }

                if (entries[b].block < 0) {
                    entries[b].block = 0;
                }

                if (entries[b].block < entries[a].block && entries[b].name[0] != '#') {
                    memcpy(&swap, &entries[a], sizeof(mgIMG_HEADER));
                    memcpy(&entries[a], &entries[b], sizeof(mgIMG_HEADER));
                    memcpy(&entries[b], &swap, sizeof(mgIMG_HEADER));
                }
            }
        }

        entry = entries;

        for (a = 0; a < file->num3; a++, entry++) {
            offset = entry->offset;

            if (entry->name[0] == '#') {
                if (block >= 0 && stack != NULL) {
                    LoadCFGFile((char *)img + offset, entry->size, stack, NULL);
                }

                continue;
            }

            swizzled = entry->swizzled;
            texture_block = spill + block + entry->block;

            if (info != NULL && info->block[entry->block] < 0) {
                info->block[entry->block] = texture_block;
                info->block_num[entry->block] = 1;
            }

            texture = EnterTexture(texture_block, entry->name, (TM2_head *)(img + offset), swizzled,
                                   entry->no_image);

            if (texture != NULL) {
                entry->swizzled = texture->swizzled;
                texture->clamp = entry->clamp;

                // A block out of VRAM passes the texture on to the following block.
                if (texture_block < block_max - 1 && GetRemainVRAM(texture_block) < 0) {
                    if (info != NULL && info->block[entry->block] >= 0) {
                        info->block_num[entry->block]++;
                    }

                    spill++;
                    blocks[texture->block].Delete(texture);
                    texture->block++;

                    if (texture->block < block_max) {
                        blocks[texture->block].Add(texture);
                    } else {
                        if (texture_num > 0) {
                            texture_stack[--texture_num] = texture;
                        }

                        texture = NULL;
                    }

                    printf("texture over %d:%s\n", block, texture->name);
                }
            }

            if (texture != NULL && texture->block > last_block_used) {
                last_block_used = texture->block;
            }
        }
    } else {
        entry1 = (mgIMG1_HEADER *)(file + 1);

        for (a = 0; a < file->num; a++, entry1++) {
            texture = EnterTexture(current_block, entry1->name, (TM2_head *)(img + entry1->offset),
                                   not_im2 == 0, 0);

            if (texture != NULL && current_block < block_max - 1 &&
                GetRemainVRAM(current_block) < 0) {
                current_block++;
                spill++;
                texture->block = current_block;
            }

            if (texture != NULL && texture->block > last_block_used) {
                last_block_used = texture->block;
            }
        }

        if (info != NULL) {
            info->block[0] = block;
            info->block_num[0] = spill + 1;
        }
    }

    return last_block_used - current_block;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_texture", EnterIMGFile__17mgCTextureManagerFPUciP9mgCMemoryP15mgCEnterIMGInfo);
#endif
#pragma schedule off

/**
 * Identifies the archive format of an IMG texture archive from its
 * signature, or gives MG_IMG_VERSION_NONE when the data is not one.
 */
static int GetIMGVersion(char *img) {
    if (img == NULL) {
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
#pragma schedule reset
#pragma schedule off
int mgGetIMGHeaderNum(char *img) {
    int *words = (int *)img;
    if (words == NULL) {
        return 0;
    }
    int version = GetIMGVersion(img);
    if (version == 0) {
        return 0;
    }
    if (version == 1 || version == 2) {
        return words[1];
    }
    if (version == 3) {
        return words[2];
    }
    return 0;
}
#pragma schedule reset
#pragma schedule off
#pragma optimization_level 2
mgIMG_HEADER mgGetIMGHeader(char *img, int index) {
    mgIMG_HEADER header;
    int version;
    int count;
    int stride;
    int i;
    char *entry;
    char *start;
    memset(&header, 0, sizeof(mgIMG_HEADER));
    if (img == NULL) {
        return header;
    }
    entry = img;
    version = GetIMGVersion(img);
    if (version == 0) {
        return header;
    }
    count = 0;
    stride = 0;
    if (version == 1 || version == 2) {
        entry += 0x10;
        count = *(int *)(img + 4);
        stride = 0x30;
    }
    if (version == 3) {
        start = entry;
        entry += 0x10;
        count = *(int *)(start + 8);
        stride = 0x40;
    }
    for (i = 0; i < count; i++) {
        if (index == i) {
        switch (version) {
                case 2:
                header.swizzled = 1;
                case 1:
                    memcpy(&header, entry, 0x20);
                    header.offset = *(u_int *)(entry + 0x20);
                break;
                case 3:
                    header.name_copy = *(IMG_HEADER_NAME *)entry;
                    header.unk_20 = *(u_int *)(entry + 0x20);
                    header.offset = *(u_int *)(entry + 0x24);
                    header.swizzled = *(u_int *)(entry + 0x28);
                    header.block = *(u_int *)(entry + 0x2C);
                    header.no_image = *(short *)(entry + 0x30);
                    short *half = &header.unk_32;
                    *half = *(short *)(entry + 0x32);
                    header.size = *(int *)(entry + 0x34);
                    header.clamp_bits = *(long long *)(entry + 0x38);
                break;
        }
    }
        entry += stride;
    }
    return header;
}
#pragma optimization_level reset
#pragma schedule reset
#pragma schedule off
void mgCTextureManager::DeleteTexture(mgCTexture *texture) {
    mgCTextureBlock *block;
    if (texture != NULL) {
        block = GetTextureBlock(texture->block);
        if (block != NULL) {
    DelHash(texture);
            block->Delete(texture);
    if (texture_num > 0) {
                texture_num--;
                texture_stack[texture_num] = texture;
    }
    texture->Initialize();
}
    }
}
#pragma schedule reset
#pragma schedule off
void mgCTextureManager::DeleteTexture(char *name, int block) {
    mgCTexture *texture = GetTexture(name, block);

    if (texture != NULL) {
        DeleteTexture(texture);
    }
}
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureManager::DeleteBlock(int block) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTexture *texture;
    mgCTexture *next;

    if (texture_block == NULL) {
        return;
    }

    for (texture = texture_block->texture; texture != NULL; texture = next) {
        next = texture->next;
        DeleteTexture(texture);
    }

    texture_block->Initialize();
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma optimization_level 1
void mgCTextureManager::EndEnterTexture(int block) {
    ReloadTexture(block, (u_int *)NULL);
}
#pragma optimization_level reset
#pragma schedule reset
#pragma schedule off
#pragma optimization_level 2
int mgLoadImage(u_int *packet, int base, int format, int width, u_long128 *image, int quadwords,
                int pos_x, int pos_y, int size_w, int size_h) {
    u_int *start = packet;
    unsigned long long blt_buf;
    unsigned long long trx_pos;
    unsigned long long trx_reg;
    int chunk;
    int length;
    // The transfer setup: TEXFLUSH, BITBLTBUF, TRXPOS, TRXREG and TRXDIR as A+D pairs.
    packet[0] = 0x10000006;
    packet[1] = 0;
    packet[2] = 0;
    packet[3] = 0x50000006;
    packet[4] = 5;
    packet[5] = 0x10000000;
    packet[6] = 0xE;
    packet[7] = 0;
    packet[8] = 0;
    packet[9] = 0;
    packet[10] = 0x3F;
    packet[11] = 0;
    blt_buf = ((long long)format << 56) | (((long long)base << 32) | ((long long)width << 48));
    packet[12] = (int)(blt_buf & 0xFFFFFFFFULL);
    packet[13] = (int)((blt_buf >> 32) & 0xFFFFFFFFULL);
    packet[14] = 0x50;
    packet[15] = 0;
    trx_pos = ((long long)pos_x << 32) | ((long long)pos_y << 48);
    packet[16] = (u_int)(trx_pos & 0xFFFFFFFFULL);
    packet[17] = (int)((trx_pos >> 32) & 0xFFFFFFFFULL);
    packet[18] = 0x51;
    packet[19] = 0;
    trx_reg = size_w | ((long long)size_h << 32);
    packet[20] = (u_int)(trx_reg & 0xFFFFFFFFULL);
    packet[21] = (int)((trx_reg >> 32) & 0xFFFFFFFFULL);
    packet[22] = 0x52;
    packet[23] = 0;
    packet[24] = 0;
    packet[25] = 0;
    packet[26] = 0x53;
    packet[27] = 0;
    // The pixels follow by reference, in transfers of at most 0x4000 quadwords.
    packet += 28;
    while (quadwords > 0) {
        chunk = 0x4000;
        if (quadwords < 0x4000) {
            chunk = quadwords;
        }
        packet[0] = 0x10000001;
        packet[1] = 0;
        packet[2] = 0;
        packet[3] = 0x50000001;
        packet[4] = chunk | 0x8000;
        packet[5] = 0x08000000;
        packet[6] = 0;
        packet[7] = 0;
        packet[8] = chunk | 0x30000000;
        packet[9] = (u_int)image;
        packet[10] = 0;
        packet[11] = chunk | 0x50000000;
        packet += 12;
        image += chunk;
        quadwords -= 0x4000;
    }
    length = packet - start;
    return length;
}
#pragma optimization_level reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
/**
 * Writes the DMA chain flushing the GS texture cache, when given a
 * buffer; gives the quadwords it takes either way.
 */
static int SetTexFlush_TagCnt(u_int *buffer) {
    if (buffer == NULL) {
    return 3;
}
    u_long128 *dst = (u_long128 *)buffer;
    dst[0] = *(u_long128 *)&texflush_dma[0];
    dst[1] = *(u_long128 *)&texflush_dma[0x10];
    dst[2] = *(u_long128 *)&texflush_dma[0x20];
    return 3;
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureManager::ReloadTexture(int index, sceVif1Packet *packet) {
    int previous;
    u_int *cursor;
    u_int *start;
    mgCTextureAnime *anime;
    if (index < 0 || index >= block_max) {
        last_block = -1;
        return;
    }
    previous = last_block;
    if (packet == NULL) {
        packet = mgVif1Packet;
    }
    sceVif1PkTerminate(packet);
    cursor = *(u_int **)packet;
    start = cursor;
    cursor += ReloadTexture(index, cursor) * 4;
    sceVif1PkReserve(packet, cursor - start);
    if (previous != index) {
        mgCTextureBlock *base = blocks;
        anime = ((mgCTextureBlock *)((index << 4) + (int)base))->anime;
        if (anime != NULL) {
            // An 8-bit texture in the Z buffer's VRAM sits in the upper byte of each 32-bit pixel.
            anime->TexAnime(index, packet);
        }
    }
    last_block = index;
// Swizzled 8-bit pixels are uploaded as a 32-bit image of half the size.
}
#pragma global_optimizer reset
#pragma schedule reset
#ifdef NONMATCHING
int mgCTextureManager::ReloadTexture(int block, u_int *packet) {
    sceGsTex0 tex0;
    mgCTexture *texture;
    u_int *cursor;
    int vram;
    int fix;
    int zbuf;
    int zbuf_size;
    int zbuf_end;
    int size;
    int to_zbuf;
    int width;
    int height;
    int bpp;
    int level;

    if (packet != NULL && (block < 0 || block >= block_max)) {
        last_block = -1;
        return 0;
    }

    cursor = packet;

    if (cursor != NULL) {
        cursor += SetTexFlush_TagCnt(cursor) * 4;
    }

    vram = vram_top;
    fix = vram_fix;
    zbuf = GetZBufVram(&zbuf_size);
    zbuf_end = zbuf + zbuf_size;

    if (last_block != block) {
        for (texture = blocks[block].texture; texture != NULL; texture = texture->next) {
            width = texture->width;
            height = texture->height;
            bpp = texture->bpp;
            to_zbuf = 0;

            if (CheckCopyToZBufVram(texture, &size) && zbuf + size < zbuf_end) {
                to_zbuf = 1;
            }

            if (to_zbuf) {
                texture->tex0.TBP0 = zbuf;
                texture->tex0.PSM = SCE_GS_PSMT8H;
                zbuf += texture->vram_size * 4;
            } else {
                texture->tex0.TBP0 = vram;
                vram += texture->vram_size;

                if (bpp == 8) {
                    texture->tex0.PSM = SCE_GS_PSMT8;
                }
            }

            tex0 = texture->tex0;

            if (texture->bpp <= 8) {
                fix -= MG_TEXTURE_CLUT_BLOCKS;
                texture->tex0.CBP = fix;
            }

            if (texture->swizzled != 0 && bpp == 8) {
                width >>= 1;
                height >>= 1;
                bpp = 32;
                tex0.PSM = SCE_GS_PSMCT32;
                tex0.TBW = tex0.TBW >> 1;
            }

            if (cursor != NULL) {
                cursor += ReloadCLUT(texture, cursor);
            }

            for (level = 0; level < MG_TEXTURE_LEVEL_MAX && texture->image[level] != NULL;
                 level++) {
                if (tex0.TBW == 0) {
                    tex0.TBW = 1;
                }

                if (cursor != NULL) {
                    cursor +=
                        mgLoadImage(cursor, tex0.TBP0, tex0.PSM, tex0.TBW, texture->image[level],
                                          bpp * width * height / 16 / 8, 0, 0, width, height);
                }

                tex0.TBP0 = tex0.TBP0 + bpp * width * height / 256 / 8;
                tex0.TBW = tex0.TBW >> 1;
                width >>= 1;
                height >>= 1;
            }
        }
    }

    if (cursor != NULL) {
        cursor += SetTexFlush_TagCnt(cursor) * 4;
        last_block = block;
    }

    return (cursor - packet) / 4;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_texture", ReloadTexture__17mgCTextureManagerFiPUi);
#endif
#pragma schedule off
// sceGsTex0::operator= is the compiler-generated copy assignment of the SDK type (sce/libgraph.h).
sceGsTex0 &sceGsTex0::operator=(const sceGsTex0 &src) {
    value = src.value;
    return *this;
}
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
int mgCTextureManager::ReloadCLUT(mgCTexture *texture, u_int *buffer) {
    int result;
    short depth;
    u_char *palette;
    if (texture == NULL) {
        return 0;
    }
    palette = (u_char *)texture->clut;
    if (palette == NULL) {
        return 0;
    }
    result = 0;
    depth = texture->bpp;
    if (depth == 8) {
        return mgLoadImage(buffer, texture->tex0.CBP, texture->tex0.CPSM, 1, (u_long128 *)palette,
                           0x40, 0, 0, 0x10, 0x10);
    }
    if (depth == 4) {
        result = mgLoadImage(buffer, texture->tex0.CBP, texture->tex0.CPSM, 1, (u_long128 *)palette,
                             4, 0, 0, 8, 2);
}
    return result;
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
#pragma global_optimizer off
void mgCTextureManager::ReloadCLUT(mgCTexture *texture, sceVif1Packet *packet) {
    u_int *cursor;
    u_int *start;
    if (packet == NULL) {
        packet = mgVif1Packet;
    }
    sceVif1PkTerminate(packet);
    cursor = *(u_int **)packet;
    start = cursor;
    cursor += ReloadCLUT(texture, cursor);
    cursor += SetTexFlush_TagCnt(cursor) * 4;
    sceVif1PkReserve(packet, cursor - start);
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off
void mgCTextureManager::TexAnimeOn(int block, char *group_name) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime;

    if (texture_block != NULL && (anime = texture_block->anime) != NULL) {
        anime->Enable(anime->SearchGroupName(group_name));
    }
}
#pragma schedule reset
#pragma schedule off
void mgCTextureManager::TexAnimeOff(int block, char *group_name) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime;

    if (texture_block != NULL && (anime = texture_block->anime) != NULL) {
        anime->Disable(anime->SearchGroupName(group_name));
    }
}
#pragma schedule reset
#pragma schedule off
void mgCTextureManager::TexAnimeAllOff(int block) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime;

    if (texture_block != NULL && (anime = texture_block->anime) != NULL) {
        anime->DisableAll();
    }
}
#pragma schedule off
char **mgCTextureManager::GetGroupNameList(int block, int *num) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime;

    if (texture_block == NULL) {
        return NULL;
    }

    anime = texture_block->anime;

    if (anime == NULL) {
        return NULL;
    }

    *num = MG_TEX_ANIME_GROUP_MAX;
    return anime->name;
}
#pragma schedule reset
#pragma schedule off
void mgCTextureManager::DeleteTexAnimeGroup(int block, int group) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);
    mgCTextureAnime *anime;

    if (texture_block != NULL && (anime = texture_block->anime) != NULL) {
        anime->DeleteGroup(group);
    }
}
#pragma schedule reset
void mgCTextureManager::DeleteTexAnime(int block) {
    mgCTextureBlock *texture_block = GetTextureBlock(block);

    if (texture_block != NULL) {
        texture_block->anime = NULL;
    }
}
#pragma schedule reset
#pragma schedule off
mgCTextureAnime *mgCTextureManager::GetTexAnime(int index) {
    mgCTextureBlock *block = GetTextureBlock(index);
    if (block != NULL) {
        return block->anime;
    }
        return NULL;
    }
#pragma schedule reset
#pragma schedule off
#pragma optimization_level 1
/**
 * Reorders one block of 8-bit pixels stored in 32-bit page order back
 * into linear order.
 */
    // Each block is four columns of 64 bytes; odd columns use the second half of the table.
static int BlockConv32to8(u_char *src, u_char *dst) {
    u_int column;
    u_int texel;
    u_int row;
    int lut_index;
    int src_index;
    src_index = 0;
    for (row = 0; row < 4; row++) {
        lut_index = (row & 1) << 6;
        for (column = 0; column < 16; column++) {
            for (texel = 0; texel < 4; texel++) {
                u_char dst_index = lut_1246[lut_index];
                lut_index++;
                dst[dst_index] = src[src_index];
                src_index++;
            }
        }
        dst += 0x40;
    }
    return 0;
}
#pragma optimization_level reset
#pragma schedule reset
#pragma schedule off
#pragma optimization_level 2
/**
 * Reorders one page of 8-bit pixels stored in 32-bit page order back
 * into linear order, block by block.
 */
static int PageConv32to8(int width, int height, u_char *src, u_char *dst) {
    int block_column[32];
    int block_row[32];
    u_char block_out[0x100];
    u_char block_in[0x100];
    int index;
    int row;
    int column;
    int line;
    int blocks_wide;
    u_char *block_ptr;
    u_char *page_ptr;
    int blocks_high;
    int block;

    index = 0;
    for (row = 0; row < 4; row++) {
        for (column = 0; column < 8; column++) {
            int entry = block_table32_1267[index];
            block_column[entry] = column;
            block_row[entry] = row;
            index++;
        }
    }
    blocks_wide = width / 16;
    blocks_high = height / 16;
    memset(block_out, 0, 0x100);
    memset(block_in, 0, 0x100);
    for (row = 0; row < blocks_high; row++) {
        for (column = 0; column < blocks_wide; column++) {
            block = block_table8_1266[column + row * blocks_wide];
            block_ptr = block_in;
            page_ptr = src + (block_row[block] << 11) + (block_column[block] << 5);
            for (line = 0; line < 8; line++) {
                memcpy(block_ptr, page_ptr, 0x20);
                block_ptr += 0x20;
                page_ptr += 0x100;
            }
            BlockConv32to8(block_in, block_out);
            block_ptr = block_out;
            page_ptr = dst + (row << 11) + column * 0x10;
            for (line = 0; line < 0x10; line++) {
                memcpy(page_ptr, block_ptr, 0x10);
                block_ptr += 0x10;
                page_ptr += 0x80;
            }
        }
    }
    return 0;
}
#pragma optimization_level reset
#pragma schedule reset
#ifdef NONMATCHING

/**
 * Converts 8-bit pixels stored in 32-bit page order back into linear
 * order in place; gives 0 when the image is too large to convert.
 */
static int Conv32To8(int width, int height, u_char *image) {
    static u_char conv_work[0x10000];
    u_char work8[0x2000];
    u_char work32[0x2000];
    u_char *source_cursor;
    u_char *work_cursor;
    u_char *destination_cursor;
    int size;
    int pages_x;
    int pages_y;
    int row_bytes;
    int row_count;
    int i;
    int j;
    int k;

    size = width * height;

    if (size > 0x10000) {
        return 0;
    }

    memset(work8, 0, sizeof(work8));
    memset(work32, 0, sizeof(work32));
    pages_x = (width - 1) / 128 + 1;
    pages_y = (height - 1) / 64 + 1;

    if (pages_x == 1) {
        row_bytes = width * 2;
    } else {
        width = 128;
        row_bytes = 256;
    }

    if (pages_y == 1) {
        row_count = height / 2;
    } else {
        height = 64;
        row_count = 32;
    }

    for (i = 0; i < pages_y; i++) {
        for (j = 0; j < pages_x; j++) {
            source_cursor = image + row_bytes * j + i * pages_x * row_bytes * row_count;
            work_cursor = work32;

            for (k = 0; k < row_count; k++) {
                memcpy(work_cursor, source_cursor, row_bytes);
                source_cursor += row_bytes * pages_x;
                work_cursor += 256;
            }

            PageConv32to8(128, 64, work32, work8);
            destination_cursor = conv_work + width * j + i * pages_x * width * 64;
            work_cursor = work8;

            for (k = 0; k < height; k++) {
                memcpy(destination_cursor, work_cursor, width);
                destination_cursor += width * pages_x;
                work_cursor += 128;
            }
        }
    }

    memcpy(image, conv_work, size);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_texture", Conv32To8__FiiPUc);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", texflush_dma__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", lut_1246__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", block_table8_1266__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", block_table32_1267__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", at_497__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", at_629__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", at_866__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", at_867__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", at_868__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", at_869__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_texture", at_884__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(conv_work_1306, 0x10000);
