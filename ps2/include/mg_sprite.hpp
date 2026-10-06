#pragma once

#include "common.h"

#include <libgraph.h>

#include "mg_dataset.hpp"
#include "mg_tanime.hpp"
#include "mg_visual.hpp"

/**
 * @file
 * Declares the engine's sprites: the screen sprite that draws one textured
 * rectangle in screen coordinates, and the 3D sprite that builds a VU1 packet
 * of camera-facing billboards placed in the world.
 */

class mgCDrawEnv;
class mgCDrawManager;
class mgCMemory;
class mgCTexture;
class mgRENDER_INFO;

/**
 *
 * Shapes that the billboards of an mgC3DSprite packet are drawn as, as BeginCreatePacket takes them.
 *
 */
enum mgC3DSpriteMode {
    MG_3DSPRITE_MODE_UPRIGHT = 0, /**< Axis-aligned rectangles drawn as GS sprites; any value other than MG_3DSPRITE_MODE_ROTATE acts as this. */
    MG_3DSPRITE_MODE_ROTATE = 1,  /**< Rectangles turned about the view direction, drawn as four-vertex triangle strips. */
};

/**
 *
 * Bits of the draw flags quadword that mgC3DSprite::CreateRenderInfoPacket sends to the VU program.
 *
 */
enum mg3DSpriteDrawFlag {
    MG_3DSPRITE_FLAG_CLIP = 1 << 0,           /**< The object being drawn needs clipping or scissoring. */
    MG_3DSPRITE_FLAG_SCISSOR = 1 << 1,        /**< The object being drawn needs scissoring. */
    MG_3DSPRITE_FLAG_PROGRAM_OPTION = 1 << 2, /**< The frame attributes' program_option is set. */
    MG_3DSPRITE_FLAG_PROGRAM_MODE = 1 << 3,   /**< The frame attributes' program_mode is set. */
    MG_3DSPRITE_FLAG_POINT_LIGHT = 1 << 4,    /**< A point light reaches the object being drawn. */
    MG_3DSPRITE_FLAG_NO_LIGHT = 1 << 5,       /**< The frame is drawn without the scene's lights. */
};

/**
 *
 * Largest number of billboards one batch of an mgC3DSprite packet holds before it is closed.
 *
 */
enum {
    MG_3DSPRITE_BATCH_MAX = 32, /**< Billboards in a full batch. */
};

/**
 *
 * Packet that mgC3DSprite::CreateRenderInfoPacket builds: the VU program's matrices, lighting and fog, its draw flags and the GS drawing state.
 *
 */
struct mg3DSpriteRenderHead {
    u_int dma_tag[4];              /**< DMA tag over the VU data and the program call. */
    u_int vif_code[4];             /**< VIF NOP, BASE, OFFSET and the UNPACK of the VU data. */
    sceVu0IVECTOR unk_20[3];
    u_int unk_50[4];
    sceVu0FMATRIX local_screen;    /**< Transform from the sprite's local space to GS screen coordinates. */
    sceVu0FMATRIX local_world;     /**< Transform from the sprite's local space to world space. */
    u_int unk_e0[11][4];
    sceVu0FVECTOR fog;             /**< Fog offset, near value, far value and scale. */
};

struct mg3DSpriteRenderTail {
    u_int unk_00[4];
    sceVu0FMATRIX view_screen;     /**< View-to-screen transform with its axes scaled by the local transform's scale. */
    u_int program_call[4];         /**< VIF MSCAL that starts the VU program. */
    u_int flags_tag[4];            /**< DMA tag and VIF UNPACK of the draw flags. */
    u_int flags[4];                /**< Draw flags, from mg3DSpriteDrawFlag. */
    u_int direct_tag[4];           /**< DMA tag and VIF DIRECT of the GS register writes. */
    u_int giftag[4];               /**< GIF tag of the GS register writes, in A+D mode. */
    u_int prmodecont[4];           /**< PRMODECONT write that makes PRMODE hold the primitive attributes. */
    u_int prmode[4];               /**< PRMODE write of the visual's primitive attributes. */
    u_int fogcol[4];               /**< FOGCOL write of the fog colour. */
    u_int ret_tag[4];              /**< DMA tag that returns to the caller. */
};

struct mg3DSpriteRenderInfo {
    mg3DSpriteRenderHead head;
    mg3DSpriteRenderTail tail;
};
STATIC_ASSERT(sizeof(mg3DSpriteRenderInfo) == 0x280);

/**
 *
 * Draws one textured, coloured rectangle at a screen position, optionally at a view depth.
 *
 */
class mgCSprite : public mgCVisualPrim {
public:
    int unk_38;
    int unk_3C;
    mgCTexture *texture;  /**< Texture the rectangle is mapped with, or NULL for an untextured rectangle. */
    float depth;          /**< View-space distance the rectangle is drawn at; below 1.0 it is drawn at depth zero. */
    int unk_48;
    int unk_4C;
    mgRect<int> screen;   /**< Corners of the rectangle on screen, in sixteenths of a pixel from the screen offset. */
    mgRect<int> uv;       /**< Corners of the rectangle in the texture, in sixteenths of a texel. */
    sceGsRgbaq color;     /**< Colour and alpha the rectangle is drawn with. */

    /**
     *
     * Creates a sprite with no texture, an empty rectangle and a neutral colour.
     *
     */
    mgCSprite() {
        screen.Set(0, 0, 0, 0);
        uv.Set(0, 0, 0, 0);
        Initialize();
    }

    /**
     * Draws the sprite through the draw manager, adding nothing to a
     * caller's DMA chain.
     *
     * @mangled Draw__9mgCSpriteFPA4_fP14mgCDrawManager
     * @address 0x13C2D0
     * @size 0x20
     */
    virtual void Draw(float (*matrix)[4], mgCDrawManager *manager);

    /**
     * Builds the render-info packet and the sprite's packet, and writes
     * DMA calls to both into a caller's chain when one is given.
     *
     * @mangled Draw__9mgCSpriteFPUiPA4_fP14mgCDrawManager
     * @address 0x13C1E0
     * @size 0xF0
     */
    virtual int Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *manager);

    /**
     * Clears the sprite to no texture and no depth, with a neutral colour
     * and the default visual attributes.
     *
     * @mangled Initialize__9mgCSpriteFv
     * @address 0x13BED0
     * @size 0x70
     */
    virtual void Initialize();

    /**
     * Builds the packet of GS register writes that draws the rectangle,
     * returning the packet's address.
     *
     * @mangled CreatePacket__9mgCSpriteFP14mgCDrawManager
     * @address 0x13BF60
     * @size 0x280
     */
    virtual u_int CreatePacket(mgCDrawManager *manager);

    /**
     * Sets the colour and alpha the rectangle is drawn with, where 0x80 is
     * full intensity.
     *
     * @mangled SetColor__9mgCSpriteFiiii
     * @address 0x13BF40
     * @size 0x20
     */
    void SetColor(int r, int g, int b, int a);
};

/**
 *
 * Builds a VU1 packet of billboards placed in the world, in batches that the VU program turns to face the camera.
 *
 */
class mgC3DSprite : public mgCVisual {
public:
    u_long128 *packet;        /**< Cached address of the built packet, or NULL when nothing has been built. */
    mgCMemory *memory;        /**< Memory the packet is built in. */
    u_long128 *packet_start;  /**< Uncached address of the start of the packet. */
    u_long128 *packet_cur;    /**< Uncached address the next quadword of the packet is written to. */
    int unk_30;
    u_int *batch_tag;         /**< DMA tag and VIF unpack code that head the open batch of billboards. */
    sceGifTag *batch_giftag;  /**< GIF tag that the VU program draws the open batch's billboards with. */
    u_int *batch_header;      /**< Quadword giving the VU program the open batch's billboard count and mode. */
    int sprite_num;           /**< Billboards in the open batch. */
    int mode;                 /**< Shape the billboards are drawn as, an mgC3DSpriteMode. */
    int prog_started;         /**< Whether a batch has already started the VU program in this packet. */
    int unk_4C;

    /**
     *
     * Creates a 3D sprite with no packet.
     *
     * @mangled __ct__11mgC3DSpriteFv
     * @address 0x17E630
     * @size 0x60
     */
    mgC3DSprite() {
        Initialize();
    }

    /**
     * Builds the packet that loads the VU program's matrices, lighting and
     * drawing state for the billboards, and sends it.
     *
     * @mangled CreateRenderInfoPacket__11mgC3DSpriteFPUiPA4_fP13mgRENDER_INFO
     * @address 0x13B2E0
     * @size 0x400
     */
    virtual int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4],
                                       mgRENDER_INFO *render_info);

    /**
     * Draws the built packet through the draw manager, adding nothing to a
     * caller's DMA chain.
     *
     * @mangled Draw__11mgC3DSpriteFPA4_fP14mgCDrawManager
     * @address 0x13C300
     * @size 0x20
     */
    virtual void Draw(float (*matrix)[4], mgCDrawManager *manager);

    /**
     * Builds the render-info packet and, when a caller's chain is given,
     * writes DMA calls to it, the VU program, and the built packet.
     *
     * @mangled Draw__11mgC3DSpriteFPUiPA4_fP14mgCDrawManager
     * @address 0x13B6E0
     * @size 0x130
     */
    virtual int Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *manager);

    /**
     * Clears the visual's state and forgets the built packet.
     *
     * @mangled Initialize__11mgC3DSpriteFv
     * @address 0x13C320
     * @size 0x20
     */
    virtual void Initialize();

    /**
     * Starts a new packet in the draw manager's data memory, for billboards
     * of the given mgC3DSpriteMode.
     *
     * @mangled BeginCreatePacket__11mgC3DSpriteFiP14mgCDrawManager
     * @address 0x13B810
     * @size 0x60
     */
    void BeginCreatePacket(int mode, mgCDrawManager *manager);

    /**
     * Adds the drawing environment's GS registers to the packet, with a
     * black fog colour for additive and subtractive blending.
     *
     * @mangled CPSetDrawEnv__11mgC3DSpriteFP10mgCDrawEnv
     * @address 0x13B870
     * @size 0xF0
     */
    void CPSetDrawEnv(mgCDrawEnv *env);

    /**
     * Adds a texture flush and the texture's TEX0 register to the packet,
     * when a texture is given.
     *
     * @mangled CPSetTexture__11mgC3DSpriteFP10mgCTexture
     * @address 0x13B960
     * @size 0x70
     */
    void CPSetTexture(mgCTexture *texture);

    /**
     * Opens a batch of billboards, reserving its DMA tag, GIF tag and
     * header quadwords and filling in the GIF tag for the mode.
     *
     * @mangled BeginCPSprite__11mgC3DSpriteFv
     * @address 0x13B9D0
     * @size 0x230
     */
    void BeginCPSprite();

    /**
     * Adds one billboard to the open batch, closing it and opening another
     * once the batch holds more than 32.
     *
     * @mangled CPSetSprite__11mgC3DSpriteFPfPfPfPfPf
     * @address 0x13BC00
     * @size 0x130
     */
    void CPSetSprite(float *pos, float *size, float *color, float *uv0, float *uv1);

    /**
     * Closes the open batch, filling in its DMA tag and header and starting
     * or continuing the VU program when it holds any billboards.
     *
     * @mangled EndCPSprite__11mgC3DSpriteFv
     * @address 0x13BD30
     * @size 0x130
     */
    void EndCPSprite();

    /**
     * Ends the packet with a flush and a DMA return, and takes the space it
     * used from the memory it was built in.
     *
     * @mangled EndCreatePacket__11mgC3DSpriteFv
     * @address 0x13BE60
     * @size 0x70
     */
    void EndCreatePacket();
};

STATIC_ASSERT(sizeof(mgC3DSprite) == 0x50);
