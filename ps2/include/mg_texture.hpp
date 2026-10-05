#pragma once

#include "common.h"

#include <libgraph.h>

#include "mg_memory.hpp"

/**
 * @file
 * Declares the engine's texture manager: textures registered by name into
 * numbered texture blocks, placed in GS video memory and uploaded block by
 * block, plus the IMG texture archive and TIM2 image layouts it reads.
 */

class mgCTexture;
class mgCTextureAnime;
struct sceVif1Packet;

/**
 * Block numbers and table sizes of the texture manager that the code
 * spells as constants.
 */
enum mgTEXTURE_CONST {
    MG_TEXTURE_HASH_SIZE = 101,          /**< Chains in the manager's name hash table. */
    MG_TEXTURE_VRAM_FIX_DEFAULT = 0x3FE0, /**< VRAM block address fixed textures grow down from when none is given. */
    MG_TEXTURE_BLOCK_FIX = 0x7FFF,       /**< Block number of the fixed block, whose textures stay resident in VRAM. */
    MG_TEXTURE_LEVEL_MAX = 4,            /**< Mip levels a texture holds, its base level included. */
    MG_TEXTURE_CLUT_BLOCKS = 4,          /**< GS blocks of VRAM reserved for the palette of an indexed texture. */
    MG_TEXTURE_PAGE_BLOCKS = 32,         /**< GS blocks in one VRAM page, the unit a texture's VRAM is rounded up to. */
    MG_TEXTURE_IMG_GROUP_MAX = 32,       /**< Archive groups an mgCEnterIMGInfo reports. */
};

/**
 * Filtering modes mgCTexture::Bilinear sets in a texture's TEX1.
 */
enum mgTEXTURE_FILTER {
    MG_TEXTURE_FILTER_NEAREST = 0, /**< Point sampling, and nearest mip level for mip-mapped textures. */
    MG_TEXTURE_FILTER_LINEAR = 1,  /**< Bilinear sampling, blended between mip levels for mip-mapped textures. */
    MG_TEXTURE_FILTER_2 = 2,       /**< Behaves as MG_TEXTURE_FILTER_LINEAR. */
};

/**
 * Archive formats GetIMGVersion recognises from the first three bytes
 * of an IMG texture archive.
 */
enum mgIMG_VERSION {
    MG_IMG_VERSION_NONE = 0, /**< Not an IMG archive. */
    MG_IMG_VERSION_IMG = 1,  /**< "IMG": 0x30-byte entries. */
    MG_IMG_VERSION_IM2 = 2,  /**< "IM2": 0x30-byte entries whose pictures are stored swizzled. */
    MG_IMG_VERSION_IM3 = 3,  /**< "IM3": 0x40-byte entries carrying a block, flags and a clamp mode each. */
};

/**
 * Pixel formats of a TIM2 picture, as TM2_head::image_type holds them.
 */
enum TIM2_IMAGE_TYPE {
    TIM2_RGB16 = 1,  /**< Sixteen-bit colour. */
    TIM2_RGB24 = 2,  /**< Twenty-four-bit colour. */
    TIM2_RGB32 = 3,  /**< Thirty-two-bit colour. */
    TIM2_IDTEX4 = 4, /**< Four-bit indexed colour. */
    TIM2_IDTEX8 = 5, /**< Eight-bit indexed colour. */
};

/**
 * A TIM2 image as the texture manager reads it: the file header followed
 * directly by the first picture's header and its mip-map header.
 */
struct TM2_PICTURE {
    u_int total_size;         /**< Bytes of the first picture; its header starts here. */
    u_int clut_size; /**< GS blocks the palette occupies, or 0 for a true-colour texture. */
    u_int image_size;         /**< Bytes of pixels of the first picture, every mip level included. */
    u_short header_size;      /**< Bytes from the picture header to the picture's pixels. */
    u_short clut_colors;
    u_char picture_format;
    u_char mipmap_count;
    u_char clut_type;
    u_char image_type; /**< Pixel format of the picture. @see TIM2_IMAGE_TYPE */
    u_short width; /**< Width of the base level, in pixels. */
    u_short height; /**< Height of the base level, in pixels. */
    unsigned long long tex0; /**< GS TEX0 value the texture is drawn with. */
    unsigned long long tex1; /**< GS TEX1 value the picture asks to be sampled with. */
    u_int gs_regs;
    u_int gs_tex_clut;
    long long mip_tbp1;
    long long mip_tbp2;
    int mip_sizes[1];
};
#pragma cpp_extensions on
struct TM2_head {
    char tag[4];              /**< File signature. */
    char unk_04[0xC];
    union {
        struct {
    u_int total_size;         /**< Bytes of the first picture; its header starts here. */
    u_int unk_14;
    u_int image_size;         /**< Bytes of pixels of the first picture, every mip level included. */
    u_short header_size;      /**< Bytes from the picture header to the picture's pixels. */
    u_short unk_1e;
    u_char unk_20;
    u_char mipmap_textures;   /**< Mip levels stored for the picture. */
    u_char unk_22;
    u_char image_type;        /**< Pixel format of the picture. @see TIM2_IMAGE_TYPE */
    u_short image_width;      /**< Width of the base level, in pixels. */
    u_short image_height;     /**< Height of the base level, in pixels. */
    u_long unk_28;
    u_long tex1;              /**< GS TEX1 value the picture asks to be sampled with. */
    char unk_38[0x18];
    u_int mipmap_size[4];     /**< Bytes of pixels of each mip level, in order from the base level. */
};
        TM2_PICTURE picture;
    };
};
#pragma cpp_extensions reset

/**
 * Leading header of an IMG texture archive; the entries follow at offset
 * 0x10.
 */
struct mgIMG_FILE_HEADER {
    char tag[4];  /**< "IMG", "IM2" or "IM3". @see mgIMG_VERSION */
    u_int num;    /**< Entries in an IMG or IM2 archive. */
    u_int num3;   /**< Entries in an IM3 archive. */
    int unk_c;
};
STATIC_ASSERT(sizeof(mgIMG_FILE_HEADER) == 0x10);

/**
 * One picture entry of an IMG or IM2 texture archive.
 */
struct mgIMG1_HEADER {
    char name[0x20]; /**< Name the picture is registered under. */
    int offset;      /**< Byte offset of the picture's TIM2 image from the start of the archive. */
    char unk_24[0xC];
};
STATIC_ASSERT(sizeof(mgIMG1_HEADER) == 0x30);

/**
 * One entry of an IM3 texture archive, which is also the form
 * mgGetIMGHeader gives the entries of every IMG version in.
 */
struct IMG_HEADER_NAME {
    char bytes[0x20];
};

struct mgIMG_HEADER {
    union {
    char name[0x20]; /**< Name the picture is registered under; a leading '#' marks a texture animation script. */
        IMG_HEADER_NAME name_copy;
    };
    int unk_20;
    int offset;      /**< Byte offset of the picture's TIM2 image, or of the script, from the start of the archive. */
    int swizzled;    /**< Non-zero when the 8-bit pixels are stored in 32-bit page order. */
    int block;       /**< Texture block the picture goes into, relative to the block the archive is entered at. */
    short no_image;  /**< Non-zero to register the picture and reserve its VRAM without its pixels. */
    short unk_32;
    int size;        /**< Byte size of a texture animation script entry. */
    union {
    sceGsClamp clamp; /**< GS CLAMP value the texture is sampled with. */
        long long clamp_bits;
    };
};
STATIC_ASSERT(sizeof(mgIMG_HEADER) == 0x40);

/**
 * Texture blocks each group of an IM3 archive was entered into, as
 * EnterIMGFile reports them.
 */
class mgCEnterIMGInfo {
public:
    int block[MG_TEXTURE_IMG_GROUP_MAX];     /**< First texture block of each archive group, or -1 for a group the archive does not use. */
    int block_num[MG_TEXTURE_IMG_GROUP_MAX]; /**< Texture blocks each archive group spills over, its first block included. */
};
STATIC_ASSERT(sizeof(mgCEnterIMGInfo) == 0x100);

/**
 * One texture known to the manager: its size and format, the GS register
 * values it is drawn with, where its pixels and palette are in main memory,
 * and its link in its texture block's list.
 */
class mgCTexture {
public:
    short block;             /**< Texture block the texture belongs to, or -1 when it is free. */
    short width;             /**< Width of the base level, in pixels. */
    short height;            /**< Height of the base level, in pixels. */
    short bpp;               /**< Bits per pixel: 4, 8, 16, 24 or 32. */
    char name[0x20];         /**< Name the texture is registered and looked up under. */
    int vram_size;           /**< GS blocks of VRAM reserved for the pixels, rounded up to whole pages. */
    int image_blocks;        /**< GS blocks the pixels of every mip level occupy. */
    int clut_size;           /**< GS blocks the palette occupies, or 0 for a true-colour texture. */
    sceGsTex0 tex0;          /**< GS TEX0 value the texture is drawn with. */
    sceGsTex1 tex1;          /**< GS TEX1 value the texture is sampled with. */
    sceGsClamp clamp;        /**< GS CLAMP value the texture is sampled with. */
    u_long128 *image[MG_TEXTURE_LEVEL_MAX];      /**< Pixels of each mip level in main memory, or NULL past the last level. */
    u_long128 *clut;         /**< Palette in main memory, or NULL for a true-colour texture. */
    int swizzled;            /**< Non-zero when the 8-bit pixels are stored in 32-bit page order. */
    mgCTexture *next;        /**< Following texture of the same texture block. */

    /**
     * Creates a free texture with no pixels, no palette and default
     * register values.
     *
     * @mangled __ct__10mgCTextureFv
     * @address 0x12C390
     * @size 0x30
     */
#ifndef MG_DRAWPRIM_MANUAL_CTOR
    mgCTexture();
#endif

    /**
     * Returns the texture to the free state: no block, no name, no pixels
     * and clamped sampling.
     *
     * @mangled Initialize__10mgCTextureFv
     * @address 0x12C3C0
     * @size 0xA0
     */
    void Initialize();

    /**
     * Sets the magnification and minification filters of the texture's
     * TEX1, choosing mip-map filters when the texture has mip levels.
     *
     * @mangled Bilinear__10mgCTextureFi
     * @address 0x12C460
     * @size 0x180
     */
    void Bilinear(int mode);
};
STATIC_ASSERT(sizeof(mgCTexture) == 0x70);

/**
 * One texture block: the list of textures entered into it, which are placed
 * in VRAM and uploaded together, and the texture animation that plays on
 * them.
 */
class mgCTextureBlock {
public:
    int unk_0;
    int unk_4;
    mgCTexture *texture;    /**< First texture of the block's list, or NULL when the block is empty. */
    mgCTextureAnime *anime; /**< Texture animation of the block, or NULL. */

    /**
     * Creates an empty block.
     *
     * @mangled __ct__15mgCTextureBlockFv
     * @address 0x12C5E0
     * @size 0x30
     */
    mgCTextureBlock();

    /**
     * Empties the block, dropping its textures and its texture animation.
     *
     * @mangled Initialize__15mgCTextureBlockFv
     * @address 0x12C610
     * @size 0x20
     */
    void Initialize();

    /**
     * Appends a texture to the end of the block's list.
     *
     * @mangled Add__15mgCTextureBlockFP10mgCTexture
     * @address 0x12C630
     * @size 0x60
     */
    void Add(mgCTexture *texture);

    /**
     * Unlinks a texture from the block's list.
     *
     * @mangled Delete__15mgCTextureBlockFP10mgCTexture
     * @address 0x12C690
     * @size 0x60
     */
    void Delete(mgCTexture *texture);
};
STATIC_ASSERT(sizeof(mgCTextureBlock) == 0x10);

/**
 * Link of the texture manager's name hash table, chaining the textures
 * whose names hash alike.
 */
struct mgTEXTURE_HASH {
    mgCTexture *texture;  /**< Texture the link refers to. */
    mgTEXTURE_HASH *next; /**< Following link of the same chain, or NULL. */
};
STATIC_ASSERT(sizeof(mgTEXTURE_HASH) == 8);

/**
 * Registry of every texture the game has entered: pools of textures and
 * hash links taken from an mgCMemory, the texture blocks they are grouped
 * into, and the VRAM layout the blocks are uploaded into, with fixed
 * textures allocated downwards from the top.
 */
class mgCTextureManager {
public:
    int vram_top;                                 /**< VRAM block address the uploaded texture block starts at. */
    int vram_fix;                                 /**< VRAM block address below the fixed textures, which grow downwards. */
    int last_block;                               /**< Texture block last placed by ReloadTexture, or -1. */
    int block_max;                                /**< Texture blocks in the block array. */
    mgCTextureBlock *blocks;                      /**< Numbered texture blocks. */
    mgCTextureBlock fix_block;                    /**< Block MG_TEXTURE_BLOCK_FIX, whose textures stay resident in VRAM. */
    mgTEXTURE_HASH *hash_table[MG_TEXTURE_HASH_SIZE]; /**< First link of each chain of the name hash table. */
    mgCTexture *texture_buf;                      /**< Pool of textures. */
    mgCTexture **texture_stack;                   /**< Textures of the pool, in use first and free after. */
    int texture_max;                              /**< Textures in the pool. */
    int texture_num;                              /**< Textures of the pool in use. */
    mgTEXTURE_HASH *hash_buf;                     /**< Pool of hash links. */
    mgTEXTURE_HASH **hash_stack;                  /**< Hash links of the pool, in use first and free after. */
    int hash_max;                                 /**< Hash links in the pool. */
    int hash_num;                                 /**< Hash links of the pool in use. */
    char name_suffix[0x14];                       /**< Text appended to every name a texture is entered or looked up under. */
    mgCMemory unk_1ec;

    /**
     * Creates a manager with no pools and no texture blocks.
     *
     * @mangled __ct__17mgCTextureManagerFv
     * @address 0x12C6F0
     * @size 0x50
     */
    mgCTextureManager();

    /**
     * Takes the texture block array and the texture and hash link pools
     * from a memory manager.
     *
     * @mangled SetTableBuffer__17mgCTextureManagerFiiP9mgCMemory
     * @address 0x12C740
     * @size 0x2A0
     */
    void SetTableBuffer(int texture_max, int block_max, mgCMemory *memory);

    /**
     * Empties every texture block, the pools and the hash table, and sets
     * the VRAM range textures are placed in.
     *
     * @mangled Initialize__17mgCTextureManagerFii
     * @address 0x12C9E0
     * @size 0x1A0
     */
    void Initialize(int vram_top, int vram_fix);

    /**
     * Gives the hash table chain a texture name belongs to.
     *
     * @mangled hash__17mgCTextureManagerFPc
     * @address 0x12CB80
     * @size 0x50
     */
    int hash(char *name);

    /**
     * Links a texture into the hash table under its name.
     *
     * @mangled AddHash__17mgCTextureManagerFP10mgCTexture
     * @address 0x12CBD0
     * @size 0xE0
     */
    void AddHash(mgCTexture *texture);

    /**
     * Unlinks a texture from the hash table and frees its link.
     *
     * @mangled DelHash__17mgCTextureManagerFP10mgCTexture
     * @address 0x12CCB0
     * @size 0xF0
     */
    void DelHash(mgCTexture *texture);

    /**
     * Finds the texture of a name in one texture block, or in any block
     * when the block is negative.
     *
     * @mangled SearchHash__17mgCTextureManagerFPci
     * @address 0x12CDA0
     * @size 0xB0
     */
    mgCTexture *SearchHash(char *name, int block);

    /**
     * Finds the texture of a name, with the name suffix appended, in one
     * texture block or in any block when the block is negative.
     *
     * @mangled SearchTextureName__17mgCTextureManagerFPci
     * @address 0x12CE50
     * @size 0x70
     */
    mgCTexture *SearchTextureName(char *name, int block);

    /**
     * Takes a free texture from the pool for a new name, warning when the
     * name is already registered; gives NULL when the pool is used up.
     *
     * @mangled SearchTexture__17mgCTextureManagerFPc
     * @address 0x12CEC0
     * @size 0xA0
     */
    mgCTexture *SearchTexture(char *name);

    /**
     * Finds the texture of a name in one texture block, or in any block
     * when the block is negative.
     *
     * @mangled GetTexture__17mgCTextureManagerFPci
     * @address 0x12CF60
     * @size 0x20
     */
    mgCTexture *GetTexture(char *name, int block);

    /**
     * Gives a texture block by number, the fixed block for
     * MG_TEXTURE_BLOCK_FIX, or NULL for a number out of range.
     *
     * @mangled GetTextureBlock__17mgCTextureManagerFi
     * @address 0x12CF80
     * @size 0x50
     */
    mgCTextureBlock *GetTextureBlock(int block);

    /**
     * Gives the VRAM, in GS blocks, left between a texture block's textures
     * and the fixed textures; negative when the block does not fit.
     *
     * @mangled GetRemainVRAM__17mgCTextureManagerFi
     * @address 0x12CFD0
     * @size 0x100
     */
    int GetRemainVRAM(int block);

    /**
     * Registers a texture from pixels and a palette in main memory into a
     * texture block, building its register values; gives the texture, or
     * NULL when it cannot be entered.
     *
     * @mangled EnterTexture__17mgCTextureManagerFiPcPP1iiiP1Uli
     * @address 0x12D0D0
     * @size 0x760
     */
    mgCTexture *EnterTexture(int block, char *name, u_long128 **image, int width, int height,
                             int bpp, u_long128 *clut, u_long tex1, int swizzled);

    /**
     * Registers the first picture of a TIM2 image into a texture block,
     * converting swizzled 8-bit pixels to linear order where it can.
     *
     * @mangled EnterTexture__17mgCTextureManagerFiPcP8TM2_headii
     * @address 0x12D830
     * @size 0x260
     */
    mgCTexture *EnterTexture(int block, char *name, TM2_head *tm2, int swizzled, int no_image);

    /**
     * Registers every picture of an IMG archive from a texture block on,
     * spilling into following blocks when one runs out of VRAM, and loads
     * the archive's texture animation scripts; gives the blocks spilled into.
     *
     * @mangled EnterIMGFile__17mgCTextureManagerFPUciP9mgCMemoryP15mgCEnterIMGInfo
     * @address 0x12DA90
     * @size 0x570
     */
    int EnterIMGFile(u_char *img, int block, mgCMemory *stack, mgCEnterIMGInfo *info);

    /**
     * Unregisters a texture and returns it to the pool.
     *
     * @mangled DeleteTexture__17mgCTextureManagerFP10mgCTexture
     * @address 0x12E440
     * @size 0xB0
     */
    void DeleteTexture(mgCTexture *texture);

    /**
     * Unregisters the texture of a name in one texture block, or in any
     * block when the block is negative.
     *
     * @mangled DeleteTexture__17mgCTextureManagerFPci
     * @address 0x12E4F0
     * @size 0x50
     */
    void DeleteTexture(char *name, int block);

    /**
     * Unregisters every texture of a texture block and empties it.
     *
     * @mangled DeleteBlock__17mgCTextureManagerFi
     * @address 0x12E540
     * @size 0x90
     */
    void DeleteBlock(int block);

    /**
     * Places a texture block's textures in VRAM after entering them,
     * without uploading anything.
     *
     * @mangled EndEnterTexture__17mgCTextureManagerFi
     * @address 0x12E5D0
     * @size 0x30
     */
    void EndEnterTexture(int block);

    /**
     * Uploads a texture block's textures into VRAM through a VIF1 packet,
     * then steps the block's texture animation when the block was not
     * already loaded.
     *
     * @mangled ReloadTexture__17mgCTextureManagerFiP13sceVif1Packet
     * @address 0x12E850
     * @size 0x120
     */
    void ReloadTexture(int block, sceVif1Packet *packet);

    /**
     * Places a texture block's textures in VRAM and, given a buffer, writes
     * the DMA chain uploading them and their palettes; gives the quadwords
     * written.
     *
     * @mangled ReloadTexture__17mgCTextureManagerFiPUi
     * @address 0x12E970
     * @size 0x4F0
     */
    int ReloadTexture(int block, u_int *packet);

    /**
     * Writes the DMA chain uploading a texture's palette into VRAM; gives
     * the words written.
     *
     * @mangled ReloadCLUT__17mgCTextureManagerFP10mgCTexturePUi
     * @address 0x12EE80
     * @size 0x110
     */
    int ReloadCLUT(mgCTexture *texture, u_int *packet);

    /**
     * Uploads a texture's palette into VRAM through a VIF1 packet.
     *
     * @mangled ReloadCLUT__17mgCTextureManagerFP10mgCTextureP13sceVif1Packet
     * @address 0x12EF90
     * @size 0xD0
     */
    void ReloadCLUT(mgCTexture *texture, sceVif1Packet *packet);

    /**
     * Starts the named texture animation group of a texture block.
     *
     * @mangled TexAnimeOn__17mgCTextureManagerFiPc
     * @address 0x12F060
     * @size 0x70
     */
    void TexAnimeOn(int block, char *group_name);

    /**
     * Stops the named texture animation group of a texture block.
     *
     * @mangled TexAnimeOff__17mgCTextureManagerFiPc
     * @address 0x12F0D0
     * @size 0x70
     */
    void TexAnimeOff(int block, char *group_name);

    /**
     * Stops every texture animation group of a texture block.
     *
     * @mangled TexAnimeAllOff__17mgCTextureManagerFi
     * @address 0x12F140
     * @size 0x40
     */
    void TexAnimeAllOff(int block);

    /**
     * Gives the group names of a texture block's texture animation and
     * their count, or NULL when the block has none.
     *
     * @mangled GetGroupNameList__17mgCTextureManagerFiPi
     * @address 0x12F180
     * @size 0x70
     */
    char **GetGroupNameList(int block, int *num);

    /**
     * Deletes one group of a texture block's texture animation.
     *
     * @mangled DeleteTexAnimeGroup__17mgCTextureManagerFii
     * @address 0x12F1F0
     * @size 0x50
     */
    void DeleteTexAnimeGroup(int block, int group);

    /**
     * Detaches a texture block's texture animation.
     *
     * @mangled DeleteTexAnime__17mgCTextureManagerFi
     * @address 0x12F240
     * @size 0x30
     */
    void DeleteTexAnime(int block);

    /**
     * Gives a texture block's texture animation, or NULL.
     *
     * @mangled GetTexAnime__17mgCTextureManagerFi
     * @address 0x12F270
     * @size 0x40
     */
    mgCTextureAnime *GetTexAnime(int block);

    /**
     * Runs a texture animation script, entering its animations into the
     * given texture animation or into the current texture block's own.
     *
     * @mangled LoadCFGFile__17mgCTextureManagerFPciP9mgCMemoryP15mgCTextureAnime
     * @address 0x13DF30
     * @size 0xA0
     */
    void LoadCFGFile(char *script, int size, mgCMemory *stack, mgCTextureAnime *anime);
};
STATIC_ASSERT(sizeof(mgCTextureManager) == 0x21C);

/**
 * Gives the number of picture entries of an IMG archive, or 0 when the
 * data is not one.
 *
 * @mangled mgGetIMGHeaderNum__FPc
 * @address 0x12E0E0
 * @size 0xA0
 */
int mgGetIMGHeaderNum(char *img);

/**
 * Gives one picture entry of an IMG archive in IM3 entry form, or a cleared
 * entry when the data is not an archive.
 *
 * @mangled mgGetIMGHeader__FPci
 * @address 0x12E180
 * @size 0x2C0
 */
mgIMG_HEADER mgGetIMGHeader(char *img, int index);

/**
 * Writes the DMA chain uploading an image from main memory into a VRAM
 * rectangle; gives the words written.
 *
 * @mangled mgLoadImage__FPUiiiiP1iiiii
 * @address 0x12E600
 * @size 0x200
 */
int mgLoadImage(u_int *packet, int dbp, int dpsm, int dbw, u_long128 *image, int qwc, int x, int y,
                int w, int h);
