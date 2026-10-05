#pragma once

#include "common.h"

#include <libpkt.h>

#include "mg_drawenv.hpp"
#include "mg_texture.hpp"

/**
 * @file
 * Declares the immediate primitive builder that writes GS register data into
 * DMA packets, and the draw manager that groups packets by texture and sends
 * them in draw order.
 */

class mgCMemory;
class mgCTextureManager;
class mgCDrawManager;

/**
 * GS primitive types that a primitive builder begins with, as the
 * PRIM register's type field takes them.
 */
enum mgPRIM_TYPE {
    MG_PRIM_POINT = 0,          /**< Separate points. */
    MG_PRIM_LINE = 1,           /**< Separate lines, two vertices each. */
    MG_PRIM_LINE_STRIP = 2,     /**< Connected lines. */
    MG_PRIM_TRIANGLE = 3,       /**< Separate triangles, three vertices each. */
    MG_PRIM_TRIANGLE_STRIP = 4, /**< Triangles that share an edge with the previous one. */
    MG_PRIM_TRIANGLE_FAN = 5,   /**< Triangles that share the first vertex. */
    MG_PRIM_SPRITE = 6,         /**< Axis-aligned rectangles, two corner vertices each. */
};

/**
 * Blend equations that mgCDrawPrim::AlphaBlend selects for the
 * ALPHA register; the values are those of mgAlphaMacroID.
 */
enum mgALPHA_BLEND {
    MG_ALPHA_BLEND_NORMAL = 1,   /**< Blends the source over the frame by source alpha. */
    MG_ALPHA_BLEND_ADD = 2,      /**< Adds the source, weighted by source alpha, to the frame. */
    MG_ALPHA_BLEND_SUB = 3,      /**< Subtracts the source, weighted by source alpha, from the frame. */
    MG_ALPHA_BLEND_NONE = 4,     /**< Writes the source unchanged. */
    MG_ALPHA_BLEND_ADD_FULL = 5, /**< Adds the source at full weight to the frame. */
};

/**
 * Depth comparisons that mgCDrawPrim::DepthTest selects for the
 * TEST register.
 */
enum mgDEPTH_TEST {
    MG_DEPTH_TEST_ALWAYS = -1, /**< Every pixel passes. */
    MG_DEPTH_TEST_GEQUAL = 1,  /**< Pixels at or in front of the stored depth pass. */
    MG_DEPTH_TEST_GREATER = 2, /**< Pixels in front of the stored depth pass. */
};

/**
 * Depth buffer write modes that mgCDrawPrim::ZMask takes.
 */
enum mgZ_MASK {
    MG_Z_MASK_MASKED = -1, /**< The depth buffer is left unchanged. */
    MG_Z_MASK_WRITE = 1,   /**< Drawn pixels write their depth. */
};

/**
 * Codes and bits of the DMA tags, VIF codes and GIF tags that the
 * primitive builder and draw manager write as 32-bit words.
 */
enum mgPACKET_CODE {
    MG_DMA_CNT = 1 << 28,          /**< DMA tag ID CNT, in the tag's first word: the data follows the tag. */
    MG_DMA_CALL = 5 << 28,         /**< DMA tag ID CALL, in the tag's first word: calls the packet at the tag's address. */
    MG_DMA_RET = 6 << 28,          /**< DMA tag ID RET, in the tag's first word: returns to the caller of the packet. */
    MG_VIF_DIRECT = 0x50 << 24,    /**< VIF DIRECT code: the given quadwords go to the GIF. */
    MG_GIFTAG_EOP = 1 << 15,       /**< GIF tag end-of-packet bit, in the tag's first word. */
    MG_GIFTAG_PRE = 1 << 14,       /**< GIF tag bit that writes the PRIM field to the PRIM register, in the tag's second word. */
    MG_GIFTAG_PRIM_SHIFT = 15,     /**< Position of the GIF tag's PRIM field in the tag's second word. */
    MG_GIFTAG_NREG_SHIFT = 28,     /**< Position of the GIF tag's NREG field in the tag's second word. */
    MG_UNCACHED = 0x20000000,      /**< Address bit that selects uncached access to main memory. */
    MG_VIF_OFFSET = 0x02 << 24,    /**< VIF OFFSET code: sets the VU1 double-buffer offset. */
    MG_VIF_BASE = 0x03 << 24,      /**< VIF BASE code: sets the VU1 double-buffer base address. */
    MG_VIF_FLUSHA = 0x13 << 24,    /**< VIF FLUSHA code: waits for the VU program and every GIF path to finish. */
    MG_VIF_MSCAL = 0x14 << 24,     /**< VIF MSCAL code: starts the VU program at the given address. */
    MG_VIF_MSCNT = 0x17 << 24,     /**< VIF MSCNT code: continues the VU program from where it stopped. */
    MG_VIF_UNPACK_V4_32 = 0x6C << 24, /**< VIF UNPACK code for quadwords of four 32-bit values. */
    MG_VIF_UNPACK_FLG = 1 << 15,   /**< VIF UNPACK bit that makes the address relative to the VU1 double buffer. */
    MG_VIF_NUM_SHIFT = 16,         /**< Position of the NUM field in a VIF code. */
};

/**
 * GS register addresses and values the primitive builder uses that the SDK
 * header does not name.
 */
enum mgGS_CODE {
    MG_GS_PRMODECONT = 0x1A,  /**< PRMODECONT register: selects whether PRIM or PRMODE holds the attributes. */
    MG_GS_ZGREATER = 3,       /**< TEST register depth comparison: greater than the stored depth. */
    MG_GS_PRIM_FST = 1 << 8,  /**< PRIM register bit that takes texture coordinates from UV. */
};

/**
 * One packet registered with the draw manager: a shared setup packet and
 * the object's own packet, both called from the frame's DMA chain.
 */
struct mgSORT_PACKET {
    u_long128 *common;   /**< Packet called before this one unless the previous packet called the same one. */
    u_long128 *packet;   /**< The object's own packet. */
    mgSORT_PACKET *next; /**< Packet registered before this one in the same sort bucket. */
    s16 group;           /**< Position in draw order of the texture group the packet is drawn with. */
    s16 vu_program;      /**< VU program sent before the packet is called. */
};
STATIC_ASSERT(sizeof(mgSORT_PACKET) == 0x10);

/**
 * Builds a packet of GS register writes for 2D or 3D primitives drawn
 * directly, keeping the drawing state that heads each packet.
 */
class mgCDrawPrim {
public:
    mgCDrawManager *draw_manager; /**< Manager that supplies the render info, or NULL to use mgDrawManager. */
    mgCMemory *memory;            /**< Stack memory the packet is built in. */
    sceVif1Packet *vif_packet;    /**< VIF1 packet that calls the built packet. */
    int detached;                 /**< Zero to call the built packet from the VIF1 packet and end it with a return tag. */
    mgCDrawEnv draw_env;          /**< Texture, test, depth buffer and blend registers sent at the head of each packet. */
    sceGsPrim prim;               /**< PRIM register written at the start of each primitive run. */
    mgCTexture texture;           /**< Texture the primitives are drawn with. */
    int bilinear;                 /**< Non-zero to filter the texture bilinearly. */
    int z_mask;                   /**< Depth buffer write mode, an mgZ_MASK value. */
    int disabled;                 /**< Non-zero when the last Begin found no memory, packet or render info to build with. */
    u_long128 *packet_start;      /**< Uncached address where the current packet starts. */
    u_long128 *packet_top;        /**< Start of the first packet built, kept once set. */
    union { u_long128 *write; u_int *write_words; u_long *command_write; }; /**< Next quadword of the packet to write. */
    union { u_long128 *dma_start; u_int *dma_start_words; }; /**< DMA tag that opens the current primitive run. */
    union { u_long128 *direct_start; u_int *direct_start_words; }; /**< Quadword the VIF direct transfer of the current run counts from. */
    u_int *giftag;                /**< GIF tag of the current primitive run, completed with its loop count at the end. */
    union { u_int *dma_tag; int *dma_tag_words; }; /**< DMA tag word completed with the run's quadword count at the end. */
    union { u_int *direct_code; int *direct_code_words; }; /**< VIF direct code word completed with the run's quadword count at the end. */
    int unk_f4;
    union { float q; u_int q_bits; }; /**< Q value written with every colour. */
    int coord;                    /**< Zero to place vertices relative to the screen offset; non-zero to use raw GS coordinates. */
    int packed;                   /**< Non-zero while the current run uses a packed GIF tag with its own register list. */
    int nreg;                     /**< Registers per loop of the packed GIF tag. */
    int unk_108;
    int unk_10c;
    int offset_x;                 /**< Horizontal offset, in sixteenths of a pixel, added to every vertex. */
    int offset_y;                 /**< Vertical offset, in sixteenths of a pixel, added to every vertex. */
    int unk_118;
    int unk_11c;

    /**
     * Creates a builder with no memory or packet, drawing with UV
     * coordinates, bilinear filtering and depth writes.
     *
     * @mangled __ct__11mgCDrawPrimFv
     * @address 0x134A20
     * @size 0x70
     */
#ifndef MG_DRAWPRIM_MANUAL_CTOR
    mgCDrawPrim();
#endif

    /**
     * Attaches the memory and VIF1 packet to build in, defaulting to the
     * frame's data buffer and packet, and resets the drawing state.
     *
     * @mangled Initialize__11mgCDrawPrimFP9mgCMemoryP13sceVif1Packet
     * @address 0x134A90
     * @size 0x90
     */
    void Initialize(mgCMemory *memory, sceVif1Packet *vif_packet);

    /**
     * Starts a packet and its first primitive run of the given type;
     * disables the builder when it has nothing to build with.
     *
     * @mangled Begin__11mgCDrawPrimFi
     * @address 0x134B20
     * @size 0x90
     */
    void Begin(int type);

    /**
     * Opens a primitive run: its DMA tag, VIF direct code and a GIF tag
     * followed by the PRIM register.
     *
     * @mangled BeginDma__11mgCDrawPrimFv
     * @address 0x134BB0
     * @size 0x90
     */
    void BeginDma();

    /**
     * Closes the current primitive run, filling in its counts, or drops
     * it when it holds no data.
     *
     * @mangled EndDma__11mgCDrawPrimFv
     * @address 0x134C40
     * @size 0xA0
     */
    void EndDma();

    /**
     * Closes the current primitive run and opens another with the same
     * state.
     *
     * @mangled Flush__11mgCDrawPrimFv
     * @address 0x134CE0
     * @size 0x30
     */
    void Flush();

    /**
     * Closes the current primitive run and the packet.
     *
     * @mangled End__11mgCDrawPrimFv
     * @address 0x134D10
     * @size 0x40
     */
    void End();

    /**
     * Starts a packet: calls it from the VIF1 packet unless detached, and
     * writes the texture flush and drawing state at its head.
     *
     * @mangled Begin2__11mgCDrawPrimFv
     * @address 0x134D50
     * @size 0x190
     */
    void Begin2();

    /**
     * Opens a primitive run of the given type within the current packet.
     *
     * @mangled BeginPrim2__11mgCDrawPrimFi
     * @address 0x134EE0
     * @size 0x30
     */
    void BeginPrim2(int type);

    /**
     * Opens a primitive run of the given type with a packed GIF tag that
     * writes the given register list on every loop.
     *
     * @mangled BeginPrim2__11mgCDrawPrimFiUiUii
     * @address 0x134F10
     * @size 0xB0
     */
    void BeginPrim2(int type, unsigned int regs_lo, unsigned int regs_hi, int nreg);

    /**
     * Closes the primitive run opened by either BeginPrim2.
     *
     * @mangled EndPrim2__11mgCDrawPrimFv
     * @address 0x134FC0
     * @size 0xE0
     */
    void EndPrim2();

    /**
     * Ends the packet, with a return tag unless detached, and claims the
     * memory it used.
     *
     * @mangled End2__11mgCDrawPrimFv
     * @address 0x1350A0
     * @size 0x80
     */
    void End2();

    /**
     * Writes four floats converted to integers as one quadword of data.
     *
     * @mangled Data0__11mgCDrawPrimFPf
     * @address 0x135120
     * @size 0x20
     */
    void Data0(float *data);

    /**
     * Writes four floats converted to 12.4 fixed point as one quadword of
     * data.
     *
     * @mangled Data4__11mgCDrawPrimFPf
     * @address 0x135140
     * @size 0x20
     */
    void Data4(float *data);

    /**
     * Writes four integers as one quadword of data.
     *
     * @mangled Data__11mgCDrawPrimFPi
     * @address 0x135160
     * @size 0x20
     */
    void Data(int *data);

    /**
     * Reserves quadwords of the packet that the caller has written
     * directly.
     *
     * @mangled DirectData__11mgCDrawPrimFi
     * @address 0x135180
     * @size 0x20
     */
    u_char *DirectData(int count);

    /**
     * Writes a vertex given in whole pixels.
     *
     * @mangled Vertex__11mgCDrawPrimFiii
     * @address 0x1351A0
     * @size 0x10
     */
    void Vertex(int x, int y, int z);

    /**
     * Writes a vertex given in pixels as floats.
     *
     * @mangled Vertex__11mgCDrawPrimFfff
     * @address 0x1351B0
     * @size 0x40
     */
    void Vertex(float x, float y, float z);

    /**
     * Writes a vertex given as a four-float vector in pixels.
     *
     * @mangled Vertex__11mgCDrawPrimFPf
     * @address 0x1351F0
     * @size 0x40
     */
    void Vertex(float *pos);

    /**
     * Writes a vertex given in sixteenths of a pixel to the XYZ2 register,
     * adding the screen and builder offsets.
     *
     * @mangled Vertex4__11mgCDrawPrimFiii
     * @address 0x135230
     * @size 0xB0
     */
    void Vertex4(int x, int y, int z);

    /**
     * Writes a vertex given as three integers in sixteenths of a pixel.
     *
     * @mangled Vertex4__11mgCDrawPrimFPi
     * @address 0x1352E0
     * @size 0x20
     */
    void Vertex4(int *pos);

    /**
     * Writes a colour to the RGBAQ register, with the builder's Q value.
     *
     * @mangled Color__11mgCDrawPrimFiiii
     * @address 0x135300
     * @size 0x70
     */
    void Color(int r, int g, int b, int a);

    /**
     * Writes a colour given as four floats to the RGBAQ register.
     *
     * @mangled Color__11mgCDrawPrimFPf
     * @address 0x135370
     * @size 0x40
     */
    void Color(float *color);

    /**
     * Writes texel coordinates given in sixteenths of a texel to the UV
     * register.
     *
     * @mangled TextureCrd4__11mgCDrawPrimFii
     * @address 0x1353B0
     * @size 0x40
     */
    void TextureCrd4(int u, int v);

    /**
     * Writes texel coordinates given in whole texels to the UV register.
     *
     * @mangled TextureCrd__11mgCDrawPrimFii
     * @address 0x1353F0
     * @size 0x10
     */
    void TextureCrd(int u, int v);

    /**
     * Writes a value to a GS register by its address.
     *
     * @mangled Direct__11mgCDrawPrimFUlUl
     * @address 0x135400
     * @size 0x20
     */
    void Direct(unsigned long reg, unsigned long data);

    /**
     * Makes a texture the one the primitives are drawn with, writing a
     * texture flush and its TEX1 and TEX0 registers.
     *
     * @mangled Texture__11mgCDrawPrimFP10mgCTexture
     * @address 0x135420
     * @size 0x120
     */
    void Texture(mgCTexture *texture);

    /**
     * Turns alpha blending of later primitive runs on or off.
     *
     * @mangled AlphaBlendEnable__11mgCDrawPrimFi
     * @address 0x135540
     * @size 0x20
     */
    void AlphaBlendEnable(int enable);

    /**
     * Selects the blend equation, an mgALPHA_BLEND value, for later
     * packets through mgCDrawEnv::SetAlpha.
     *
     * @mangled AlphaBlend__11mgCDrawPrimFi
     * @address 0x135560
     * @size 0x10
     */
    void AlphaBlend(int mode);

    /**
     * Turns the alpha test of later packets on or off.
     *
     * @mangled AlphaTestEnable__11mgCDrawPrimFi
     * @address 0x135570
     * @size 0x20
     */
    void AlphaTestEnable(int enable);

    /**
     * Sets the alpha test's comparison and reference value for later
     * packets.
     *
     * @mangled AlphaTest__11mgCDrawPrimFii
     * @address 0x135590
     * @size 0x40
     */
    void AlphaTest(int method, int ref);

    /**
     * Sets the destination alpha test's enable and mode for later
     * packets.
     *
     * @mangled DAlphaTest__11mgCDrawPrimFii
     * @address 0x1355D0
     * @size 0x40
     */
    void DAlphaTest(int enable, int mode);

    /**
     * Turns the depth test of later packets on, as greater-or-equal, or
     * off, letting every pixel pass.
     *
     * @mangled DepthTestEnable__11mgCDrawPrimFi
     * @address 0x135610
     * @size 0x60
     */
    void DepthTestEnable(int enable);

    /**
     * Selects the depth comparison, an mgDEPTH_TEST value, for later
     * packets.
     *
     * @mangled DepthTest__11mgCDrawPrimFi
     * @address 0x135670
     * @size 0xA0
     */
    void DepthTest(int method);

    /**
     * Sets whether later packets write the depth buffer, as an mgZ_MASK
     * value.
     *
     * @mangled ZMask__11mgCDrawPrimFi
     * @address 0x135710
     * @size 0x10
     */
    void ZMask(int mask);

    /**
     * Turns texture mapping of later primitive runs on or off.
     *
     * @mangled TextureMapEnable__11mgCDrawPrimFi
     * @address 0x135720
     * @size 0x20
     */
    void TextureMapEnable(int enable);

    /**
     * Sets whether textures given later are filtered bilinearly.
     *
     * @mangled Bilinear__11mgCDrawPrimFi
     * @address 0x135740
     * @size 0x10
     */
    void Bilinear(int enable);

    /**
     * Turns Gouraud shading of later primitive runs on or off.
     *
     * @mangled Shading__11mgCDrawPrimFi
     * @address 0x135750
     * @size 0x20
     */
    void Shading(int enable);

    /**
     * Turns antialiasing of later primitive runs on or off.
     *
     * @mangled AntiAliasing__11mgCDrawPrimFi
     * @address 0x135770
     * @size 0x20
     */
    void AntiAliasing(int enable);

    /**
     * Turns fogging of later primitive runs on or off.
     *
     * @mangled FogEnable__11mgCDrawPrimFi
     * @address 0x135790
     * @size 0x20
     */
    void FogEnable(int enable);

    /**
     * Sets whether vertices are placed relative to the screen offset
     * (zero) or in raw GS coordinates.
     *
     * @mangled Coord__11mgCDrawPrimFi
     * @address 0x1357B0
     * @size 0x10
     */
    void Coord(int coord);

    /**
     * Gives the offset, in sixteenths of a pixel, added to every vertex.
     *
     * @mangled GetOffset__11mgCDrawPrimFPiPi
     * @address 0x1357C0
     * @size 0x50
     */
    void GetOffset(int *x, int *y);
};
STATIC_ASSERT(sizeof(mgCDrawPrim) == 0x120);

/**
 * Collects the frame's object packets by texture group and sends them,
 * group by group in draw order, after reloading each group's textures.
 */
class mgCDrawManager {
public:
    int *draw_order;                  /**< Texture groups in the order they are drawn, ending in -1, or NULL for the natural order. */
    int *order_index;                 /**< Position in draw order of each texture group, -1 for a group not drawn. */
    int group_max;                    /**< Texture groups packets may be registered for. */
    int group_num;                    /**< Texture groups drawn. */
    mgSORT_PACKET ***packet_list;     /**< Registered packets of each drawn group, in registration order. */
    int *unk_14;
    int *packet_num;                  /**< Number of packets registered for each drawn group. */
    int sort_num;                     /**< Buckets in the sort table. */
    int sort_max;                     /**< Index of the last sort table bucket. */
    float sort_num_f;                 /**< Buckets in the sort table, as a float. */
    float near_clip;                  /**< Near clip distance of the render info. */
    float far_clip;                   /**< Far clip distance of the render info. */
    float clip_range;                 /**< Distance from the near to the far clip. */
    int unk_34;
    int unk_38;
    int unk_3c;
    int unk_40;
    float sort_near;                  /**< Near clip distance, beside the clip ratio and bucket count. */
    float sort_ratio;                 /**< Near clip distance divided by far clip distance. */
    float sort_scale;                 /**< Buckets in the sort table, as a float. */
    mgSORT_PACKET **sort_table;       /**< Packet lists of the sort table's buckets. */
    mgCMemory *memory;                /**< Memory the frame's tables and packet entries are taken from. */
    mgCTextureManager *texture_manager; /**< Texture manager whose slots are the texture groups. */
    mgCMemory *packet_memory;         /**< Frame's packet memory, used when BeginDraw is given none. */
    mgCMemory *data_memory;           /**< Frame's data memory. */
    mgRENDER_INFO *render_info;       /**< Render info that supplies the clip distances and depth buffer. */
    int unk_68;
    int unk_6c;
    int unk_70;
    mgSORT_PACKET ***packet_cursor;   /**< Next free entry of each drawn group's packet list. */
    int unk_78;
    int unk_7c;

    /**
     * Creates a manager with no frame state.
     *
     * @mangled __ct__14mgCDrawManagerFv
     * @address 0x135810
     * @size 0x20
     */
    mgCDrawManager();

    /**
     * Sets the number of sort table buckets and the clip distances that
     * map depths onto them.
     *
     * @mangled SetSortTable__14mgCDrawManagerFi
     * @address 0x135830
     * @size 0x90
     */
    void SetSortTable(int num);

    /**
     * Starts collecting packets in the given memory, drawing the texture
     * groups listed (ending in a negative number) in that order, or every
     * group when given no list.
     *
     * @mangled BeginDraw__14mgCDrawManagerFP9mgCMemoryPi
     * @address 0x1358C0
     * @size 0x240
     */
    void BeginDraw(mgCMemory *memory, int *order);

    /**
     * Empties the group tables and the sort table.
     *
     * @mangled ClearTable__14mgCDrawManagerFv
     * @address 0x135B00
     * @size 0x80
     */
    void ClearTable();

    /**
     * Sorts the registered packets into a list for each texture group.
     *
     * @mangled PreEndDraw__14mgCDrawManagerFv
     * @address 0x135B80
     * @size 0x170
     */
    void PreEndDraw();

    /**
     * Writes the reload of a texture group's textures into a VIF1 packet;
     * gives zero when the group is not drawn.
     *
     * @mangled ReloadTexture__14mgCDrawManagerFiP13sceVif1Packet
     * @address 0x135CF0
     * @size 0xC0
     */
    int ReloadTexture(int group, sceVif1Packet *vif_packet);

    /**
     * Writes calls to a texture group's packets, each after its VU
     * program, into a VIF1 packet; gives zero when the group is not drawn.
     *
     * @mangled Draw__14mgCDrawManagerFiP13sceVif1Packet
     * @address 0x135DB0
     * @size 0x200
     */
    int Draw(int group, sceVif1Packet *vif_packet);

    /**
     * Sorts the registered packets and writes every drawn group's texture
     * reload and packet calls into a VIF1 packet.
     *
     * @mangled EndDraw__14mgCDrawManagerFP13sceVif1Packet
     * @address 0x135FB0
     * @size 0xB0
     */
    void EndDraw(sceVif1Packet *vif_packet);

    /**
     * Registers a packet, with the setup packet it needs and its VU
     * program, for a texture group; a negative group means the first
     * group drawn.
     *
     * @mangled AddPacket__14mgCDrawManagerFiP1P1i
     * @address 0x136060
     * @size 0x100
     */
    void AddPacket(int group, u_long128 *common, u_long128 *packet, int vu_program);
};
STATIC_ASSERT(sizeof(mgCDrawManager) == 0x80);
