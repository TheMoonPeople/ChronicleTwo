#pragma once

#include "common.h"

#include <cstring>
#include <libvu0.h>

#include "mg_dataset.hpp"
#include "mg_frame.hpp"
#include "mg_texture.hpp"

/**
 * @file
 * Declares the rippling water surface and the frame that carries it in a map,
 * together with the heat-haze effect drawn above fire points and the scene's
 * thunder effect state.
 */

class mgCMemory;
class mgCDrawManager;
class mgRENDER_INFO;

/**
 *
 * One rising wisp of a heat-haze effect.
 *
 */
struct FireRasterParticle {
    sceVu0FVECTOR position; /**< Offset of the wisp from the point it rises above. */
    float         size;     /**< Half-size of the screen patch the wisp distorts, shrinking as it rises. */
    int           time;     /**< Frames the wisp has risen for; also phases its sideways sway. */
    int           life;     /**< Frames the wisp lives for, or 0 while the slot is free. */
    int           unk_1c;

    /**
     * Creates a free slot.
     */
    FireRasterParticle() { memset(this, 0, sizeof(FireRasterParticle)); }
};

STATIC_ASSERT(sizeof(FireRasterParticle) == 0x20);

/**
 *
 * Heat-haze effect that redraws patches of the frame buffer above fire points.
 *
 */
class CFireRaster {
public:
    mgCTexture         texture;      /**< Copy of the frame-buffer texture the patches are cut from, with its alpha channel ignored. */
    FireRasterParticle particle[20]; /**< Wisps of the effect, spawned one per step into a free slot. */

    /**
     * Creates the effect with every wisp slot free.
     */
    CFireRaster() { Initialize(); }

    /**
     * Moves every live wisp up and sideways, frees the expired ones and
     * spawns a new wisp in a free slot.
     *
     * @mangled Step__11CFireRasterFv
     * @address 0x185710
     * @size 0x1CC
     */
    void Step();

    /**
     * Takes a copy of the texture the patches are cut from, with its alpha
     * channel ignored.
     *
     * @mangled SetTexture__11CFireRasterFP10mgCTexture
     * @address 0x1858E0
     * @size 0xE0
     */
    void SetTexture(mgCTexture *texture);

    /**
     * Draws every live wisp above a point as a displaced patch of the
     * frame buffer.
     *
     * @mangled Draw__11CFireRasterFPfPf
     * @address 0x1859C0
     * @size 0x3B0
     */
    void Draw(float *position, float *scale);

    /**
     * Frees every wisp slot.
     *
     * @mangled Initialize__11CFireRasterFv
     * @address 0x185D70
     * @size 0x5C
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CFireRaster) == 0x2F0);

/**
 *
 * State of the thunder effect a scene keeps.
 *
 */
class CThunderEffect {
public:
    int unk_00;
    u_char  unk_04[0x8C];
    int unk_90;
    int unk_94;
    int unk_98;

    /**
     * Clears the thunder effect's state.
     *
     * @mangled Init__14CThunderEffectFv
     * @address 0x185DD0
     * @size 0x14
     */
    void Init();
};

/**
 *
 * Visual that draws a rippling water surface as a grid of heights.
 *
 */
class CWater : public mgCVisual {
public:
    float         *height_a; /**< First of the two wave-height buffers. */
    float         *height_b; /**< Second of the two wave-height buffers. */
    mgCTexture    *texture;  /**< Texture the surface is drawn with, or NULL for none. */
    u_int          packet;   /**< Address of the packet that draws the grid, built by CreatePacket. */
    int            color[4]; /**< Red, green, blue and alpha channels of the surface. */
    float          speed;    /**< Speed the ripples travel across the grid at. */
    float          damping;  /**< Rate the ripples lose height at. */
    float          unk_48;
    float          unk_4c;
    int            unk_50;
    int            rows;     /**< Grid points along the x axis. */
    int            columns;  /**< Grid points along the z axis. */
    float         *height;   /**< Wave-height buffer the surface currently draws from. */
    sceVu0FVECTOR  min;      /**< Minimum corner of the surface. */
    sceVu0FVECTOR  max;      /**< Maximum corner of the surface. */

    /**
     * Advances the ripples one step, writing into whichever of the two height
     * buffers is not being drawn and drawing from it next.
     *
     * @mangled Hamon__6CWaterFv
     * @address 0x185DF0
     * @size 0xFC
     */
    void Hamon();

    /**
     * Sets the extent of the surface from two opposite corners.
     *
     * @mangled SetVertex__6CWaterFPfPf
     * @address 0x185EF0
     * @size 0x18
     */
    void SetVertex(float *corner0, float *corner1);

    /**
     * Raises one interior grid point, starting a ripple from it.
     *
     * @mangled Shake__6CWaterFiif
     * @address 0x185F10
     * @size 0x90
     */
    void Shake(int row, int column, float height_change);

    /**
     * Gives the surface its grid size and takes two cleared height buffers
     * out of an arena.
     *
     * @mangled SetSize__6CWaterFiiP9mgCMemory
     * @address 0x186130
     * @size 0xDC
     */
    void SetSize(int row_count, int column_count, mgCMemory *memory);

    /**
     * Stores the ripple speed and damping and the two values the surface's
     * microprogram is given.
     *
     * @mangled SetParam__6CWaterFffff
     * @address 0x186210
     * @size 0x14
     */
    void SetParam(float speed, float damping, float param_48, float param_4c);

    /**
     * Sets the red, green, blue and alpha channels of the surface.
     *
     * @mangled SetColor__6CWaterFUcUcUcUc
     * @address 0x186230
     * @size 0x24
     */
    void SetColor(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha);

    /**
     * Creates a surface with no grid, a half-bright white colour and the
     * default ripple constants.
     *
     * @mangled __ct__6CWaterFv
     * @address 0x186260
     * @size 0x88
     */
    CWater();

    /**
     * Sends the matrices, screen, colour and draw settings the surface's
     * microprogram needs.
     *
     * @mangled CreateRenderInfoPacket__6CWaterFPUiPA4_fP13mgRENDER_INFO
     * @address 0x1862F0
     * @size 0x458
     */
    virtual int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     * Draws the surface by sending its render information, the
     * microprogram and the grid packet built by CreatePacket.
     *
     * @mangled Draw__6CWaterFPUiPA4_fP14mgCDrawManager
     * @address 0x186750
     * @size 0x118
     */
    virtual int Draw(u_int *packet, float (*matrix)[4], mgCDrawManager *draw_manager);

    /**
     * Builds the packet that draws the grid from the current wave heights,
     * and returns its address.
     *
     * @mangled CreatePacket__6CWaterFP14mgCDrawManager
     * @address 0x186870
     * @size 0x85C
     */
    virtual u_int CreatePacket(mgCDrawManager *draw_manager);
};

STATIC_ASSERT(sizeof(CWater) == 0x80);

/**
 *
 * Frame that places a water surface in a map and steps its ripples.
 *
 */
class CWaterFrame : public mgCFrame {
public:
    int unk_110;
    int stop; /**< Whether the ripples are held still instead of advanced each step. */
    int unk_118;
    int unk_11c;

    /**
     * Creates a water frame with its ripples running.
     */
    CWaterFrame() { Initialize(); }

    /**
     * Raises the grid point under a world position, starting a ripple from
     * it when the position lies over the surface.
     *
     * @mangled Shake__11CWaterFrameFfff
     * @address 0x185FA0
     * @size 0x174
     */
    void Shake(float x, float z, float height_change);

    /**
     * Returns the water surface the frame draws.
     *
     * @mangled GetWater__11CWaterFrameFv
     * @address 0x186120
     * @size 0x8
     */
    virtual CWater *GetWater();

    /**
     * Sets the texture the surface is drawn with.
     *
     * @mangled SetTexture__11CWaterFrameFP10mgCTexture
     * @address 0x1870D0
     * @size 0x38
     */
    void SetTexture(mgCTexture *texture);

    /**
     * Advances the ripples one step unless they are held still.
     *
     * @mangled Step__11CWaterFrameFv
     * @address 0x187110
     * @size 0x54
     */
    virtual void Step();

    /**
     * Stores the ripple speed and damping and the two microprogram values
     * of the surface.
     *
     * @mangled SetParam__11CWaterFrameFffff
     * @address 0x187170
     * @size 0x6C
     */
    void SetParam(float speed, float damping, float param_48, float param_4c);

    /**
     * Sets the red, green, blue and alpha channels of the surface.
     *
     * @mangled SetColor__11CWaterFrameFUcUcUcUc
     * @address 0x1871E0
     * @size 0x6C
     */
    void SetColor(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha);

    /**
     * Raises one interior grid point of the surface, starting a ripple from
     * it.
     *
     * @mangled Shake__11CWaterFrameFiif
     * @address 0x187250
     * @size 0x5C
     */
    void Shake(int row, int column, float height_change);

    /**
     * Rebuilds the packet that draws the surface's grid.
     *
     * @mangled CreatePacket__11CWaterFrameFv
     * @address 0x1872B0
     * @size 0x3C
     */
    void CreatePacket();

    /**
     * Clears the frame's own state and resets the frame.
     *
     * @mangled Initialize__11CWaterFrameFv
     * @address 0x187490
     * @size 0xC
     */
    virtual void Initialize();
};

STATIC_ASSERT(sizeof(CWaterFrame) == 0x120);

/**
 * Creates a water frame whose surface spans two corners with a grid of the
 * given size, taking everything it needs out of an arena.
 *
 * @mangled CreateWaterFrame__FiiPfPfP9mgCMemory
 * @address 0x1872F0
 * @size 0x198
 */
CWaterFrame *CreateWaterFrame(int rows, int columns, float *min, float *max, mgCMemory *memory);
