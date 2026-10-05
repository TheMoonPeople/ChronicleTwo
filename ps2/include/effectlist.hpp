#pragma once

#include "common.h"

/**
 * @file
 * Declares the list of a map's effects, read from the effect files of a pack
 * and drawn as 3D sprites, and the screen fade that covers the screen with a
 * colour, dissolves or wipes away a captured screen, and blurs motion.
 */

class CEffectManager;
class mgC3DSprite;
class mgCMemory;
class mgCTexture;

/**
 *
 * Direction a CFadeInOut is fading in, as its mode holds it.
 *
 */
enum FadeMode {
    FADE_MODE_OUT = -1, /**< The cover rises from clear to full; it stays full once reached. */
    FADE_MODE_NONE = 0, /**< No fade is running and the screen is not covered. */
    FADE_MODE_IN = 1,   /**< The cover falls from full to clear; the mode returns to none once clear. */
};

/**
 *
 * How a cross-fade takes the captured screen away, as CrossFadeIn and CrossFadeOut take it.
 *
 */
enum CrossFadeType {
    CROSS_FADE_DISSOLVE = 0, /**< The captured screen is drawn translucent over the new one; any value other than CROSS_FADE_WIPE acts as this. */
    CROSS_FADE_WIPE = 1,     /**< The captured screen is cut back sideways behind a jagged edge. */
};

/**
 *
 * Every effect of a map: one effect manager and one 3D sprite for each effect file of the map's pack.
 *
 */
class CEffectList {
public:
    char *name;                /**< Copy, in the list's memory, of the name the list was loaded under. */
    u_int *pack;               /**< Pack file the effects and their textures were read from. */
    int block;                 /**< Texture block the pack's textures were entered into. */
    int effect_num;            /**< Effects in the list. */
    CEffectManager *managers;  /**< Effect manager of each effect, named after its effect file. */
    mgC3DSprite *sprites;      /**< 3D sprite each effect's particles are drawn with. */

    /**
     * Enters every texture archive of a pack into a texture block, and builds
     * one effect manager and one 3D sprite for each effect file of the pack,
     * all in the given memory.
     *
     * @mangled LoadEFPFile__11CEffectListFPcPUiiP9mgCMemory
     * @address 0x17E280
     * @size 0x3B0
     */
    void LoadEFPFile(char *name, u_int *pack, int block, mgCMemory *stack);

    /**
     * Gives the index of the effect whose effect file has a name, or -1
     * when no effect has it.
     *
     * @mangled SaerchEffectIndex__11CEffectListFPc
     * @address 0x17E690
     * @size 0x90
     */
    int SaerchEffectIndex(char *name);

    /**
     * Gives the 3D sprite an effect is drawn with, or NULL for an index
     * outside the list.
     *
     * @mangled GetEffectVisual__11CEffectListFi
     * @address 0x17E720
     * @size 0x40
     */
    mgC3DSprite *GetEffectVisual(int index);

    /**
     * Runs the control scripts of every effect and moves each one's
     * particles on by one frame.
     *
     * @mangled Step__11CEffectListFv
     * @address 0x17E760
     * @size 0x70
     */
    void Step();

    /**
     * Builds the draw packet of every effect's particles into the effect's
     * 3D sprite.
     *
     * @mangled CreatePacket__11CEffectListFv
     * @address 0x17E7D0
     * @size 0x80
     */
    void CreatePacket();
};
STATIC_ASSERT(sizeof(CEffectList) == 0x18);

/**
 *
 * Screen fade: covers the screen with a colour, takes away a captured screen, and blurs motion.
 *
 */
class CFadeInOut {
public:
    /**
     *
     * Creates an inactive screen fade.
     *
     */
    CFadeInOut() { Initialize(); }

    float r;                     /**< Red of the cover colour, 0 to 128. */
    float g;                     /**< Green of the cover colour, 0 to 128. */
    float b;                     /**< Blue of the cover colour, 0 to 128. */
    float alpha;                 /**< How far the screen is covered, 0 (clear) to 128 (full). */
    int mode;                    /**< Direction of the running fade, a FadeMode. */
    int end;                     /**< Non-zero once the running fade has reached its end. */
    float speed;                 /**< Alpha the cover changes by in one frame. */
    int cross_type;              /**< How the captured screen is taken away, a CrossFadeType. */
    int cross;                   /**< Non-zero when the fade shows the captured screen instead of the cover colour. */
    float cross_alpha_rate;      /**< Scale on the alpha of a dissolving captured screen. */
    mgCTexture *cross_texture;   /**< Texture the screen is captured into for a cross-fade, or NULL. */
    int blur_alpha;              /**< Alpha the previous frame is drawn over the screen with for motion blur, or 0 for none. */

    /**
     * Clears the cover, stops any fade and forgets the cross-fade texture
     * and the motion blur.
     *
     * @mangled Initialize__10CFadeInOutFv
     * @address 0x17EB90
     * @size 0x30
     */
    void Initialize();

    /**
     * Stops any fade and clears the cover at once.
     *
     * @mangled ResetFade__10CFadeInOutFv
     * @address 0x17EBC0
     * @size 0x10
     */
    void ResetFade();

    /**
     * Takes a cover of a colour away over a number of frames, starting from
     * full when no fade is running or the frame count is negative; a
     * negative count holds the cover where it is.
     *
     * @mangled FadeIn__10CFadeInOutFifff
     * @address 0x17EBD0
     * @size 0x60
     */
    void FadeIn(int frames, float r, float g, float b);

    /**
     * Takes the cover away over a number of frames, in the colour the screen
     * was faded out to or in black when it was not faded out.
     *
     * @mangled FadeIn__10CFadeInOutFi
     * @address 0x17EC30
     * @size 0x50
     */
    void FadeIn(int frames);

    /**
     * Brings a cover of a colour up over a number of frames, starting from
     * clear when no fade is running or the frame count is negative; a
     * negative count holds the cover where it is.
     *
     * @mangled FadeOut__10CFadeInOutFifff
     * @address 0x17EC80
     * @size 0x60
     */
    void FadeOut(int frames, float r, float g, float b);

    /**
     * Dissolves the captured screen away over a number of frames, with its
     * alpha scaled by a rate.
     *
     * @mangled CrossFade__10CFadeInOutFif
     * @address 0x17ECE0
     * @size 0x10
     */
    void CrossFade(int frames, float alpha_rate);

    /**
     * Takes the captured screen away in a CrossFadeType over a number of
     * frames, starting with it covering the whole screen.
     *
     * @mangled CrossFadeIn__10CFadeInOutFiif
     * @address 0x17ECF0
     * @size 0x60
     */
    void CrossFadeIn(int type, int frames, float alpha_rate);

    /**
     * Brings the captured screen up in a CrossFadeType over a number of
     * frames, starting with none of it shown.
     *
     * @mangled CrossFadeOut__10CFadeInOutFiif
     * @address 0x17ED50
     * @size 0x60
     */
    void CrossFadeOut(int type, int frames, float alpha_rate);

    /**
     * Gives whether the running fade has reached its end.
     *
     * @mangled FadeCheck__10CFadeInOutFv
     * @address 0x17EDB0
     * @size 0x10
     */
    int FadeCheck();

    /**
     * Gives whether a fade is running or the screen is held faded out.
     *
     * @mangled NowFade__10CFadeInOutFv
     * @address 0x17EDC0
     * @size 0x10
     */
    int NowFade();

    /**
     * Moves the running fade on by one frame, and gives whether it has
     * reached its end; 1 when no fade is running.
     *
     * @mangled FadeStep__10CFadeInOutFv
     * @address 0x17EDD0
     * @size 0xC0
     */
    int FadeStep();

    /**
     * Sets the texture the screen is captured into for a cross-fade, with
     * the buffer that holds its pixels; a NULL texture leaves it as it is.
     *
     * @mangled SetCrossTexture__10CFadeInOutFP10mgCTextureP1
     * @address 0x17EE90
     * @size 0x20
     */
    void SetCrossTexture(mgCTexture *texture, u_long128 *buffer);

    /**
     * Reads the screen last drawn into the cross-fade texture's buffer, when
     * the texture and its buffer are set.
     *
     * @mangled CaptureScreen__10CFadeInOutFv
     * @address 0x17EEB0
     * @size 0x60
     */
    void CaptureScreen();

    /**
     * Draws the cover or the captured screen over the whole screen, and then
     * the previous frame over it for motion blur.
     *
     * @mangled Draw__10CFadeInOutFv
     * @address 0x17F310
     * @size 0x450
     */
    void Draw();
};
STATIC_ASSERT(sizeof(CFadeInOut) == 0x30);
