#pragma once

#include "common.h"

#include <libdma.h>
#include <libgraph.h>
#include <libpkt.h>
#include <libvu0.h>

#include "mg_drawenv.hpp"

/**
 * @file
 * Declares the engine's graphics library: GS and DMA setup, the per-frame
 * packet cycle, the global render state wrappers, screen projection helpers
 * and the VU microprogram table.
 */

class mgCDrawEnv;
class mgCDrawManager;
class mgCFrame;
class mgCMemory;
class mgCTexture;
class mgCTextureManager;
class mgCVisual;
class mgRENDER_INFO;
struct mgPOINT_LIGHT;
struct mgVu0FBOX;
struct sceGsClamp;
template <typename T> class mgRect;

/**
 * Display sizes mgInit can set the screen to, as GetScreenSize maps them.
 */
enum mgSCREEN_MODE {
    MG_SCREEN_MODE_512X448 = 0, /**< 512 by 448 pixels; also used for any unknown mode. */
    MG_SCREEN_MODE_512X416 = 1, /**< 512 by 416 pixels. */
    MG_SCREEN_MODE_512X480 = 2, /**< 512 by 480 pixels. */
    MG_SCREEN_MODE_640X448 = 3, /**< 640 by 448 pixels. */
};

/**
 * Identifiers of the VU1 microprograms that mgSendVuProg can load.
 */
enum mgVU_PROG_ID {
    MG_VU_PROG_MAIN = 0,       /**< Main model microprogram (Vu_prog0). */
    MG_VU_PROG_SHADOW = 1,     /**< Shadow microprogram (Vu_prog_sdw). */
    MG_VU_PROG_3DSPRITE = 2,   /**< Camera-facing sprite microprogram (Vu_prog_3dsp). */
    MG_VU_PROG_USER = 0x100,   /**< First identifier of the table registered with mgSetUserVuProg. */
};

/**
 * Initial DMA chain that prepares VU1 for the graphics microprograms.
 */
extern u_long128 My_dma_start0[];

/**
 * Shared entry microprogram for VU1 drawing.
 */
extern u_long128 Vu_progmain[];

/**
 * Main geometry microprogram's DMA upload packet.
 */
extern u_long128 Vu_prog0[];

/**
 * Shadow microprogram's DMA upload packet.
 */
extern u_long128 Vu_prog_sdw[];

/**
 * Sprite microprogram's DMA upload packet.
 */
extern u_long128 Vu_prog_3dsp[];

/**
 * One deferred depth-buffer sample: a screen position read back at the end
 * of the frame and the nearest depth found around it.
 */
struct MG_PICKZ {
    int enable; /**< Non-zero to sample this position when the frame ends. */
    int x; /**< Horizontal screen coordinate to sample. */
    int y; /**< Vertical screen coordinate to sample. */
    int z; /**< Nearest depth in the 8 by 8 block around the position, or -1 when it lies outside the screen. */
};
STATIC_ASSERT(sizeof(MG_PICKZ) == 0x10);

/**
 * Non-zero to blend the two display circuits for a softer, anti-aliased picture.
 */
extern int mgAntialiasing;

/**
 * Vertical syncs each frame waits for.
 */
extern int mgFrameRate;

/**
 * Vertical syncs the last frame actually took, measured from the root counter.
 */
extern float mgNowFrameRate;

/**
 * DMA channel 1 (VIF1), through which every packet is sent.
 */
extern sceDmaChan *DmaCH1;

/**
 * DMA channel 2 (GIF).
 */
extern sceDmaChan *DmaCH2;

/**
 * DMA channel 8 (from scratchpad).
 */
extern sceDmaChan *DmaCH8;

/**
 * VIF1 packet being built this frame, one of the two packets the frames alternate between.
 */
extern sceVif1Packet *mgVif1Packet;

/**
 * Non-zero to clear the frame to the background colour when a frame begins.
 */
extern int mgClearBackFlag;

/**
 * Screen size in use, as an mgSCREEN_MODE.
 */
extern int mgScreenMode;

/**
 * Screen width in pixels.
 */
extern int mgScreenWidth;

/**
 * Screen height in pixels.
 */
extern int mgScreenHeight;

/**
 * Left edge of the screen relative to its centre (minus half the width).
 */
extern int mgScreenNX;

/**
 * Top edge of the screen relative to its centre (minus half the height).
 */
extern int mgScreenNY;

/**
 * Right edge of the screen relative to its centre.
 */
extern int mgScreenMX;

/**
 * Bottom edge of the screen relative to its centre.
 */
extern int mgScreenMY;

/**
 * Horizontal GS primitive coordinate, in pixels, of the screen's left edge.
 */
extern int mgScreenOffx;

/**
 * Vertical GS primitive coordinate, in pixels, of the screen's top edge.
 */
extern int mgScreenOffy;

/**
 * Bits per pixel of the frame buffer.
 */
extern int mgScreenDepth;

/**
 * Bits per pixel of the depth buffer.
 */
extern int mgScreenZDepth;

/**
 * GS primitive coordinate of the screen's left edge.
 */
extern int mgScreenLeft;

/**
 * GS primitive coordinate of the screen's right edge.
 */
extern int mgScreenRight;

/**
 * GS primitive coordinate of the screen's top edge.
 */
extern int mgScreenTop;

/**
 * GS primitive coordinate of the screen's bottom edge.
 */
extern int mgScreenBottom;

/**
 * Interlace field being displayed, sampled at every vertical sync.
 */
extern int VSyncField;

/**
 * TEX1 register value for drawing context 1.
 */
extern sceGsTex1 mgTEX1_1;

/**
 * TEX1 register value for drawing context 2.
 */
extern sceGsTex1 mgTEX1_2;

/**
 * TEST register value for drawing context 1.
 */
extern sceGsTest mgTEST_1;

/**
 * TEST register value for drawing context 2.
 */
extern sceGsTest mgTEST_2;

/**
 * ZBUF register value for drawing context 1, naming where the depth buffer lives.
 */
extern sceGsZbuf mgZBUF_1;

/**
 * ZBUF register value for drawing context 2.
 */
extern sceGsZbuf mgZBUF_2;

/**
 * ALPHA register value for drawing context 1.
 */
extern sceGsAlpha mgALPHA_1;

/**
 * ALPHA register value for drawing context 2.
 */
extern sceGsAlpha mgALPHA_2;

/**
 * TEXA register value for drawing context 1.
 */
extern sceGsTexa mgTEXA_1;

/**
 * TEXA register value for drawing context 2.
 */
extern sceGsTexa mgTEXA_2;

/**
 * FRAME register value of the buffer being drawn this frame.
 */
extern sceGsFrame mgFRAME_1;

/**
 * Quadwords written by the mgDrawDirect2 calls since mgDrawDirectStart.
 */
extern int ddraw_size;

/**
 * GIF tag that opens a run of address and data register writes.
 */
extern sceGifTag mgGiftagAD;

/**
 * Render state every model is drawn with: matrices, lights, clip volume, fog
 * and the two drawing environments.
 */
extern mgRENDER_INFO mgRenderInfo;

/**
 * Colour the frame is cleared to, with components from 0 to 255.
 */
extern sceVu0FVECTOR mgBackColor;

/**
 * Texture manager the default draw manager loads textures through.
 */
extern mgCTextureManager mgTexManager;

/**
 * Draw manager used when a drawing call is given none.
 */
extern mgCDrawManager mgDrawManager;

/**
 * Display and drawing environments of the two frame buffers.
 */
extern sceGsDBuff mgDBuff;

/**
 * Depth-buffer sample requests served at the end of every frame.
 */
extern MG_PICKZ mgPickZBuff[4];

/**
 * Turns the on-screen performance meter on or off.
 *
 * @mangled mgPerformanceMeter__Fi
 * @address 0x141850
 * @size 0x10
 */
void mgPerformanceMeter(int enable);

/**
 * Tells whether the on-screen performance meter is on.
 *
 * @mangled mgGetPerformanceMeterFlag__Fv
 * @address 0x141860
 * @size 0x10
 */
int mgGetPerformanceMeterFlag();

/**
 * Sets the function called from every vertical-sync interrupt.
 *
 * @mangled mgInitVSyncCallBack__FPFi_i
 * @address 0x1418F0
 * @size 0x10
 */
void mgInitVSyncCallBack(int (*callback)(int));

/**
 * Sets the thread priority whose ready queue is rotated while waiting for a
 * vertical sync; zero or less rotates nothing.
 *
 * @mangled mgSetRotateThread__Fi
 * @address 0x141900
 * @size 0x10
 */
void mgSetRotateThread(int priority);

/**
 * Gives the number of vertical syncs since the library was initialised.
 *
 * @mangled mgGetVSyncCount__Fv
 * @address 0x141980
 * @size 0x10
 */
int mgGetVSyncCount();

/**
 * Resets DMA and the GS, clears video memory, sets up the double buffer,
 * register defaults, render info and microprograms, and installs the
 * vertical-sync handler.
 *
 * @mangled mgInit__Fii
 * @address 0x141A50
 * @size 0xA30
 */
void mgInit(int screen_mode, int video_mode);

/**
 * Sets the two buffers the alternating VIF1 packets are built in, each
 * aligned up to a quadword.
 *
 * @mangled mgInitVif1Packet__FP1P1i
 * @address 0x142480
 * @size 0xE0
 */
void mgInitVif1Packet(u_long128 *buffer0, u_long128 *buffer1, int size);

/**
 * Copies two memory managers into the pair the alternating frames take
 * packet memory from, emptying their stack regions.
 *
 * @mangled mgSetPacketBuffer__FP9mgCMemoryP9mgCMemory
 * @address 0x142560
 * @size 0x150
 */
void mgSetPacketBuffer(mgCMemory *memory0, mgCMemory *memory1);

/**
 * Points the pair of per-frame data managers at the free stack space of two
 * memory managers, optionally skipping their first 0x4000 quadwords.
 *
 * @mangled mgSetDataBuffer__FP9mgCMemoryP9mgCMemoryi
 * @address 0x1426B0
 * @size 0xC0
 */
void mgSetDataBuffer(mgCMemory *memory0, mgCMemory *memory1, int skip_head);

/**
 * Gives the data memory manager of the frame being built.
 *
 * @mangled mgGetDataBuffer__Fv
 * @address 0x142770
 * @size 0x20
 */
mgCMemory *mgGetDataBuffer();

/**
 * Gives the first video memory word past the frame and depth buffers.
 *
 * @mangled mgGetTopVRAMAddress__Fv
 * @address 0x142790
 * @size 0xB0
 */
int mgGetTopVRAMAddress();

/**
 * Gives the number of vertical syncs each frame waits for.
 *
 * @mangled mgGetNowFrameRate__Fv
 * @address 0x142840
 * @size 0x10
 */
float mgGetNowFrameRate();

/**
 * Starts a frame: opens its packet, resets texture repeat, the frame buffer
 * and the render info, and clears the screen.
 *
 * @mangled mgBeginFrame__FP14mgCDrawManager
 * @address 0x142850
 * @size 0x240
 */
void mgBeginFrame(mgCDrawManager *manager);

/**
 * Switches to the packet and memory of the frame being built and resets the
 * draw manager's sort table.
 *
 * @mangled mgBeginPacket__FP14mgCDrawManager
 * @address 0x142A90
 * @size 0xE0
 */
void mgBeginPacket(mgCDrawManager *manager);

/**
 * Starts collecting draw requests in a draw manager, the default one when
 * none is given, optionally limited to a list of texture blocks ended by a
 * negative entry.
 *
 * @mangled mgBeginDraw__FP9mgCMemoryPiP14mgCDrawManager
 * @address 0x142B70
 * @size 0x20
 */
void mgBeginDraw(mgCMemory *memory, int *block_list, mgCDrawManager *manager);

/**
 * Writes the collected draw requests of a draw manager into the frame's
 * packet.
 *
 * @mangled mgEndDraw__FP14mgCDrawManager
 * @address 0x142B90
 * @size 0x20
 */
void mgEndDraw(mgCDrawManager *manager);

/**
 * Prepares a draw manager's collected requests before they are written out.
 *
 * @mangled mgPreEndDraw__FP14mgCDrawManager
 * @address 0x142BB0
 * @size 0x20
 */
void mgPreEndDraw(mgCDrawManager *manager);

/**
 * Has a draw manager reload the textures of one texture block into the
 * frame's packet, returning zero when that block is not drawn.
 *
 * @mangled mgEndDrawReloadTexture__FiP14mgCDrawManager
 * @address 0x142BD0
 * @size 0x20
 */
int mgEndDrawReloadTexture(int block, mgCDrawManager *manager);

/**
 * Writes the draw requests a draw manager collected for one texture block
 * into the frame's packet.
 *
 * @mangled mgEndDraw__FiP14mgCDrawManager
 * @address 0x142BF0
 * @size 0x20
 * @unknownret
 */
void mgEndDraw(int block, mgCDrawManager *manager);

/**
 * Saves the displayed frame to the host as a TGA image.
 *
 * @mangled mgStoreFrameImage__Fv
 * @address 0x142C10
 * @size 0x10
 * @unknownret
 */
void mgStoreFrameImage();

/**
 * Finishes a frame: draws the performance meter, closes and sends the
 * packet, serves depth samples, waits for the frame rate, and swaps the
 * display buffers.
 *
 * @mangled mgEndFrame__FP14mgCDrawManager
 * @address 0x142C20
 * @size 0xA80
 */
void mgEndFrame(mgCDrawManager *manager);

/**
 * Sends the frame's VIF1 packet over DMA channel 1 and flips to the other
 * packet.
 *
 * @mangled mgSendPacket__FP14mgCDrawManager
 * @address 0x1436A0
 * @size 0x70
 * @unknownret
 */
void mgSendPacket(mgCDrawManager *manager);

/**
 * Ends the frame's VIF1 packet.
 *
 * @mangled mgEndPacket__FP14mgCDrawManager
 * @address 0x143710
 * @size 0x30
 * @unknownret
 */
void mgEndPacket(mgCDrawManager *manager);

/**
 * Waits for the GS path to finish, halting with the packet address when it
 * times out.
 *
 * @mangled mgWaitFrame__Fv
 * @address 0x143740
 * @size 0x50
 */
void mgWaitFrame();

/**
 * Draws one model through its frame.
 *
 * @mangled mgDraw__FP8mgCFrame
 * @address 0x143790
 * @size 0x40
 */
int mgDraw(mgCFrame *frame);

/**
 * Builds one model's packet straight into the frame's VIF1 packet.
 *
 * @mangled mgDrawDirect__FP8mgCFrame
 * @address 0x1437D0
 * @size 0x70
 */
int mgDrawDirect(mgCFrame *frame);

/**
 * Builds one visual's packet, placed by a matrix, straight into the frame's
 * VIF1 packet.
 *
 * @mangled mgDrawDirect__FP9mgCVisualPA4_f
 * @address 0x143840
 * @size 0x80
 */
int mgDrawDirect(mgCVisual *visual, float (*matrix)[4]);

/**
 * Starts a run of mgDrawDirect2 calls written back to back into the frame's
 * VIF1 packet.
 *
 * @mangled mgDrawDirectStart__Fv
 * @address 0x1438C0
 * @size 0x20
 * @unknownret
 */
void mgDrawDirectStart();

/**
 * Builds one model's packet after those already written since
 * mgDrawDirectStart.
 *
 * @mangled mgDrawDirect2__FP8mgCFrame
 * @address 0x1438E0
 * @size 0x50
 */
int mgDrawDirect2(mgCFrame *frame);

/**
 * Ends a run of mgDrawDirect2 calls, claiming what they wrote in the frame's
 * VIF1 packet.
 *
 * @mangled mgDrawDirectEnd__Fv
 * @address 0x143930
 * @size 0x30
 */
void mgDrawDirectEnd();

/**
 * Gives the screen rectangle a model covers.
 *
 * @mangled mgGetDrawRect__FP8mgCFrameP9mgVu0FBOX
 * @address 0x143960
 * @size 0x30
 */
int mgGetDrawRect(mgCFrame *frame, mgVu0FBOX *rect);

/**
 * Makes a texture the frame buffer and clears it, so that shadows can be
 * drawn into it.
 *
 * @mangled mgBeginDrawShadow__FP10mgCTextureP10mgCTexture
 * @address 0x143990
 * @size 0x140
 */
void mgBeginDrawShadow(mgCTexture *shadow, mgCTexture *unused);

/**
 * Restores the frame buffer and lays the shadow texture over the frame.
 *
 * @mangled mgEndDrawShadow__FP10mgCTextureP10mgCTexture
 * @address 0x143AD0
 * @size 0x330
 */
void mgEndDrawShadow(mgCTexture *shadow, mgCTexture *unused);

/**
 * Rebuilds the projection and clip volume of the render info for the
 * screen.
 *
 * @mangled mgSetRenderInfo__Ffff
 * @address 0x143E00
 * @size 0x50
 */
void mgSetRenderInfo(float projection, float near_z, float far_z);

/**
 * Changes the projection scale, keeping the clip depths and the view.
 *
 * @mangled mgSetProjection__Ff
 * @address 0x143E50
 * @size 0x40
 */
void mgSetProjection(float projection);

/**
 * Gives the projection scale.
 *
 * @mangled mgGetProjection__Fv
 * @address 0x143E90
 * @size 0x10
 */
float mgGetProjection();

/**
 * Sets the colour the frame is cleared to, from four floats in memory.
 *
 * @mangled mgSetBackGround__FPf
 * @address 0x143EA0
 * @size 0x10
 */
void mgSetBackGround(float *color);

/**
 * Sets the colour the frame is cleared to.
 *
 * @mangled mgSetBackGround__Fffff
 * @address 0x143EB0
 * @size 0x40
 */
void mgSetBackGround(float r, float g, float b, float a);

/**
 * Resets the parallel lights and the ambient colour.
 *
 * @mangled mgInitLighting__Fv
 * @address 0x143EF0
 * @size 0x30
 */
void mgInitLighting();

/**
 * Resets which parallel lights are active.
 *
 * @mangled mgInitActiveLighting__Fv
 * @address 0x143F20
 * @size 0x30
 */
void mgInitActiveLighting();

/**
 * Selects one of the eight lighting sets, copying the current set into it
 * when copy is non-zero, and gives the set that was selected before.
 *
 * @mangled mgActiveLighting__Fii
 * @address 0x143F50
 * @size 0x20
 */
int mgActiveLighting(int set, int copy);

/**
 * Sets the directions and colours of the parallel lights.
 *
 * @mangled mgSetLight__FPA4_fPA4_f
 * @address 0x143F70
 * @size 0x20
 */
void mgSetLight(float (*direction)[4], float (*color)[4]);

/**
 * Reads the directions and colours of the parallel lights.
 *
 * @mangled mgGetLight__FPA4_fPA4_f
 * @address 0x143F90
 * @size 0x20
 */
void mgGetLight(float (*direction)[4], float (*color)[4]);

/**
 * Sets the direction and colour of one parallel light.
 *
 * @mangled mgSetLight__FiPfPf
 * @address 0x143FB0
 * @size 0x30
 */
void mgSetLight(int light, float *direction, float *color);

/**
 * Sets the colour that lights every face of a model.
 *
 * @mangled mgSetAmbient__FPf
 * @address 0x143FE0
 * @size 0x20
 */
void mgSetAmbient(float *ambient);

/**
 * Reads the colour that lights every face of a model.
 *
 * @mangled mgGetAmbient__FPf
 * @address 0x144000
 * @size 0x10
 */
void mgGetAmbient(float *ambient);

/**
 * Sets one of the four point lights from a position, a colour, an
 * intensity and a range.
 *
 * @mangled mgSetPlight__FiPfPfff
 * @address 0x144010
 * @size 0x30
 */
void mgSetPlight(int light, float *position, float *color, float intensity, float range);

/**
 * Sets one of the four point lights; NULL turns it off.
 *
 * @mangled mgSetPlight__FiP13mgPOINT_LIGHT
 * @address 0x144040
 * @size 0x20
 */
void mgSetPlight(int light, mgPOINT_LIGHT *point_light);

/**
 * Reads one of the four point lights.
 *
 * @mangled mgGetPlight__FiP13mgPOINT_LIGHT
 * @address 0x144060
 * @size 0x20
 */
void mgGetPlight(int light, mgPOINT_LIGHT *point_light);

/**
 * Turns all four point lights off.
 *
 * @mangled mgResetPlight__Fv
 * @address 0x144080
 * @size 0x50
 */
void mgResetPlight();

/**
 * Sets the matrix that puts the world in front of the eye, and where the
 * eye stands.
 *
 * @mangled mgSetViewMatrix__FPA4_fPf
 * @address 0x1440D0
 * @size 0x20
 */
void mgSetViewMatrix(float (*view)[4], float *position);

/**
 * Sets the plane shadows are dropped onto and the light that casts them.
 *
 * @mangled mgSetDropShadowMatrix__FPfPfPf
 * @address 0x1440F0
 * @size 0x20
 */
void mgSetDropShadowMatrix(float *light, float *position, float *normal);

/**
 * Turns fog on or off.
 *
 * @mangled mgFogEnable__Fi
 * @address 0x144110
 * @size 0x10
 */
void mgFogEnable(int enable);

/**
 * Tells whether fog is on.
 *
 * @mangled mgGetFogEnable__Fv
 * @address 0x144120
 * @size 0x10
 */
int mgGetFogEnable();

/**
 * Turns the point lights on or off.
 *
 * @mangled mgPlightEnable__Fi
 * @address 0x144130
 * @size 0x10
 */
void mgPlightEnable(int enable);

/**
 * Tells whether the point lights are on.
 *
 * @mangled mgGetPlightEnable__Fv
 * @address 0x144140
 * @size 0x10
 */
int mgGetPlightEnable();

/**
 * Sets how far the fog reaches, what colour it is and how strong it is at
 * each end.
 *
 * @mangled mgSetFogParam__FffUcUcUcff
 * @address 0x144150
 * @size 0x20
 */
void mgSetFogParam(float near_z, float far_z, unsigned char r, unsigned char g, unsigned char b,
                   float far_fog, float near_fog);

/**
 * Sets the fog from a fog parameter block.
 *
 * @mangled mgSetFogParam__FP11mgFOG_PARAM
 * @address 0x144170
 * @size 0x30
 */
void mgSetFogParam(mgFOG_PARAM *fog);

/**
 * Reads the fog into a fog parameter block.
 *
 * @mangled mgGetFogParam__FP11mgFOG_PARAM
 * @address 0x1441A0
 * @size 0xA0
 */
void mgGetFogParam(mgFOG_PARAM *fog);

/**
 * Sets whether every model is scissored against the screen.
 *
 * @mangled mgSetAllScissorFlag__Fi
 * @address 0x144240
 * @size 0x10
 */
void mgSetAllScissorFlag(int flag);

/**
 * Writes the fog curve and clip volume of the render info into the frame's
 * VIF1 packet for the microprograms.
 *
 * @mangled mgFlushRenderInfo__Fv
 * @address 0x144250
 * @size 0xD0
 */
void mgFlushRenderInfo();

/**
 * Sets texture wrapping to repeat, or to clamp when zero.
 *
 * @mangled mgSetPkTextureRepeat__Fi
 * @address 0x144320
 * @size 0x70
 */
void mgSetPkTextureRepeat(int repeat);

/**
 * Writes a CLAMP_1 register value into the frame's VIF1 packet.
 *
 * @mangled mgSetPkTextureRepeat__F10sceGsClamp
 * @address 0x144390
 * @size 0x80
 */
void mgSetPkTextureRepeat(sceGsClamp clamp);

/**
 * Makes a texture the frame buffer drawn into; NULL restores the screen.
 *
 * @mangled mgSetPkFrameBuffer__FP10mgCTexture
 * @address 0x144410
 * @size 0x80
 */
void mgSetPkFrameBuffer(mgCTexture *texture);

/**
 * Makes an area of video memory the frame buffer drawn into, with its
 * viewport and scissor; -1 in every argument restores the screen.
 *
 * @mangled mgSetPkFrameBuffer__Fiiii
 * @address 0x144490
 * @size 0x6A0
 */
void mgSetPkFrameBuffer(int fbp, int width, int height, int psm);

/**
 * Describes the frame buffer being drawn as a texture.
 *
 * @mangled mgGetFrameBuffer__FP10mgCTexture
 * @address 0x144B30
 * @size 0x100
 */
void mgGetFrameBuffer(mgCTexture *texture);

/**
 * Describes the frame buffer not being drawn as a texture.
 *
 * @mangled mgGetFrameBackBuffer__FP10mgCTexture
 * @address 0x144C30
 * @size 0x140
 */
void mgGetFrameBackBuffer(mgCTexture *texture);

/**
 * Gives one of the two drawing environments of the render info.
 *
 * @mangled mgGetpDrawEnv__Fi
 * @address 0x144D70
 * @size 0x20
 */
mgCDrawEnv *mgGetpDrawEnv(int index);

/**
 * Copies a rectangle of one texture into another at a position.
 *
 * @mangled mgSetPkMoveImage__FP10mgCTexture9mgRect_i_P10mgCTextureiii
 * @address 0x144D90
 * @size 0x40
 */
void mgSetPkMoveImage(mgCTexture *src, mgRect<int> src_rect, mgCTexture *dst, int dst_x, int dst_y,
                      int direction);

/**
 * Copies a rectangle of video memory to a position with a GS local transfer.
 *
 * @mangled mgSetPkMoveImage__FP9sceGsTex09mgRect_i_P9sceGsTex0iii
 * @address 0x144DD0
 * @size 0x370
 */
void mgSetPkMoveImage(sceGsTex0 *src, mgRect<int> src_rect, sceGsTex0 *dst, int dst_x, int dst_y,
                      int direction);

/**
 * Draws a rectangle of one texture into a rectangle of another.
 *
 * @mangled mgSetPkMoveImage__FP10mgCTexture9mgRect_i_P10mgCTexture9mgRect_i_P10mgCDrawEnv
 * @address 0x145140
 * @size 0x60
 */
void mgSetPkMoveImage(mgCTexture *src, mgRect<int> src_rect, mgCTexture *dst, mgRect<int> dst_rect,
                      mgCDrawEnv *env);

/**
 * Draws a rectangle of a texture into a rectangle of a frame buffer, with
 * the register state of a drawing environment or the defaults when NULL.
 *
 * @mangled mgSetPkMoveImage__FP9sceGsTex09mgRect_i_P9sceGsTex0i9mgRect_i_P10mgCDrawEnv
 * @address 0x1451A0
 * @size 0x400
 */
void mgSetPkMoveImage(sceGsTex0 *src, mgRect<int> src_rect, sceGsTex0 *dst, int dst_height,
                      mgRect<int> dst_rect, mgCDrawEnv *env);

/**
 * Clears the whole screen to one colour, in strips 32 pixels wide.
 *
 * @mangled mgSetPkClearScreen__FUcUcUcUc
 * @address 0x1455A0
 * @size 0x300
 */
void mgSetPkClearScreen(unsigned char r, unsigned char g, unsigned char b, unsigned char a);

/**
 * Reads a texture back from video memory, giving width * height * bits per pixel, or 0
 * when either argument is NULL.
 *
 * @mangled mgStoreImage__FP10mgCTextureP1
 * @address 0x1458A0
 * @size 0xE0
 */
int mgStoreImage(mgCTexture *texture, u_long128 *buffer);

/**
 * Reads a rectangle of the depth buffer back as 24-bit depths, giving the
 * number of quadwords read.
 *
 * @mangled mgStoreZBuffImage__FR9mgRect_i_P1
 * @address 0x145980
 * @size 0x250
 */
int mgStoreZBuffImage(mgRect<int> &rect, u_long128 *buffer);

/**
 * Turns a depth-buffer value into a view distance.
 *
 * @mangled mgConvZBuffToDist__FUi
 * @address 0x145BD0
 * @size 0x60
 */
float mgConvZBuffToDist(unsigned int z);

/**
 * Gives one of the two textures laid over the depth buffer, or NULL for any
 * other index.
 *
 * @mangled mgGetTextureZ__Fi
 * @address 0x145C30
 * @size 0x40
 */
mgCTexture *mgGetTextureZ(int index);

/**
 * Turns a world position into GS primitive coordinates, giving 1 while it
 * is on the screen and inside the clip depths.
 *
 * @mangled mgTransWorldPrim__FPiPf
 * @address 0x145D20
 * @size 0xD0
 */
int mgTransWorldPrim(int *prim, float *position);

/**
 * Turns a world position into screen coordinates relative to the screen's
 * top left corner, giving 1 while it is visible.
 *
 * @mangled mgTransWorldScreen__FPiPf
 * @address 0x145DF0
 * @size 0x50
 */
int mgTransWorldScreen(int *screen, float *position);

/**
 * Turns a view-space position into GS primitive coordinates, giving 1 while
 * it is on the screen and inside the clip depths.
 *
 * @mangled mgTransViewPrim__FPiPf
 * @address 0x145E40
 * @size 0xD0
 */
int mgTransViewPrim(int *prim, float *position);

/**
 * Turns a world position into view space.
 *
 * @mangled mgTransWorldView__FPfPf
 * @address 0x145F10
 * @size 0x10
 */
void mgTransWorldView(float *view, float *position);

/**
 * Gives the GS depth value of a view depth.
 *
 * @mangled mgTransZPrim__Ff
 * @address 0x145F20
 * @size 0x40
 */
int mgTransZPrim(float z);

/**
 * Gives the distance from the camera to a world position.
 *
 * @mangled mgGetDistFromCamera__FPf
 * @address 0x145F60
 * @size 0x10
 */
float mgGetDistFromCamera(float *position);

/**
 * Gives the vector from the camera to a world position.
 *
 * @mangled mgGetDirFromCamera__FPfPf
 * @address 0x145F70
 * @size 0x10
 */
void mgGetDirFromCamera(float *direction, float *position);

/**
 * Reads the camera's world position.
 *
 * @mangled mgGetCameraPos__FPf
 * @address 0x145F80
 * @size 0x20
 */
void mgGetCameraPos(float *position);

/**
 * Reads the camera's orientation and position as a matrix.
 *
 * @mangled mgGetCameraPose__FPA4_f
 * @address 0x145FA0
 * @size 0x50
 */
void mgGetCameraPose(float (*pose)[4]);

/**
 * Turns a world position into the two GS corners of a camera-facing sprite
 * of a given size, giving non-zero while the sprite is visible.
 *
 * @mangled mgTransWorldPrim3DSprite__FPiPiPfffi
 * @address 0x145FF0
 * @size 0x1D0
 */
int mgTransWorldPrim3DSprite(int *top_left, int *bottom_right, float *position, float width,
                             float height, int unused);

/**
 * Gives the DMA packet that loads a microprogram, or NULL for an unknown
 * identifier.
 *
 * @mangled mgGetVuProgPacket__Fi
 * @address 0x146260
 * @size 0x60
 */
u_long128 *mgGetVuProgPacket(int id);

/**
 * Writes a VIF call that loads a microprogram unless it is the one loaded
 * last, giving the number of words written.
 *
 * @mangled mgSendVuProg__FPUii
 * @address 0x1462C0
 * @size 0x80
 */
int mgSendVuProg(unsigned int *packet, int id);

/**
 * Registers the table of user microprogram packets, reached from
 * MG_VU_PROG_USER on.
 *
 * @mangled mgSetUserVuProg__FPP1i
 * @address 0x146340
 * @size 0x10
 */
void mgSetUserVuProg(u_long128 **table, int count);

/**
 * Sets one entry of the user microprogram table.
 *
 * @mangled mgSetUserVuProgAdr__FiP1
 * @address 0x146350
 * @size 0x40
 */
void mgSetUserVuProgAdr(int index, u_long128 *packet);

/**
 * Opens the debug console at the screen's top left, giving its handle.
 *
 * @mangled mgInitFont__Fv
 * @address 0x146620
 * @size 0x50
 */
int mgInitFont();

/**
 * Closes the debug console.
 *
 * @mangled mgCloseFont__Fv
 * @address 0x146670
 * @size 0x30
 */
void mgCloseFont();
