#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the sprites that event scripts put on screen or into the world,
 * the marker that event editing shows, and the arc of a parabolic jump.
 */

/**
 *
 * Gives the vertical speed that carries a jump from one height to another in a number of frames under gravity.
 *
 * @mangled ParabolicInitialVectorY__Fffff
 * @address 0x293EC0
 * @size 0x30
 */
float ParabolicInitialVectorY(float start_y, float end_y, float gravity, float frames);

/**
 *
 * Gives the position, on a given frame, of a jump that arcs from a start position to an end position.
 *
 * @mangled CalcPosParabolicJump__FPfPfPffff
 * @address 0x293EF0
 * @size 0x170
 */
void CalcPosParabolicJump(float *pos, float *start, float *end, float gravity, float frames, float frame);

/**
 *
 * Counts down the frames for which the event editor's marker shows.
 *
 */
class CMarker {
public:
    int count{}; /**< Frames left for which the marker shows. */

    /**
     *
     * Hides the marker.
     *
     */
    CMarker() { Init(); }

    /**
     *
     * Counts down one frame of the marker.
     *
     * @mangled Draw__7CMarkerFv
     * @address 0x294060
     * @size 0x20
     */
    void Draw();

    /**
     *
     * Shows the marker for a number of frames.
     *
     * @mangled Set__7CMarkerFi
     * @address 0x294080
     * @size 0x10
     */
    void Set(int count);

    /**
     *
     * Hides the marker.
     *
     * @mangled Init__7CMarkerFv
     * @address 0x294090
     * @size 0x10
     */
    void Init();
};

STATIC_ASSERT(sizeof(CMarker) == 0x4);

/**
 *
 * Animation that an event image runs.
 *
 */
enum EVENT_SPRITE_ANIME {
    EVENT_SPRITE_ANIME_NONE = -1, /**< No animation. */
    EVENT_SPRITE_ANIME_MOVE = 0,  /**< Moves the image's screen position to a target position. */
    EVENT_SPRITE_ANIME_FADE = 1,  /**< Fades the image's alpha in or out. */
};

/**
 *
 * Image that an event script cuts from a texture and draws as a screen sprite, and that moves or fades.
 *
 */
class CEventSprite {
public:
    int  draw{};       /**< Non-zero to draw the image. */
    int  tex_block{};  /**< Texture block that holds the image's texture. */
    char name[0x40]{}; /**< Name of the image's texture. */
    int  color[4]{};   /**< Red, green, blue and alpha, with 0x80 as full. */
    int  get[4]{};     /**< Texel x, y, width and height of the part of the texture that the image shows. */
    int  put[4]{};     /**< Screen x, y, width and height at which the image is drawn. */
    int  anime[4]{};   /**< Running animation (EVENT_SPRITE_ANIME) and its target values and frames left. */

    /**
     *
     * Clears the image.
     *
     */
    CEventSprite() { Init(); }

    /**
     *
     * Gives the image the texture of a name.
     *
     * @mangled SetName__12CEventSpriteFPc
     * @address 0x2940A0
     * @size 0x10
     */
    void SetName(char *name);

    /**
     *
     * Shows or hides the image.
     *
     * @mangled SetDraw__12CEventSpriteFi
     * @address 0x2940B0
     * @size 0x10
     */
    void SetDraw(int draw);

    /**
     *
     * Sets the part of the texture that the image shows.
     *
     * @mangled SetGet__12CEventSpriteFiiii
     * @address 0x2940C0
     * @size 0x20
     */
    void SetGet(int x, int y, int w, int h);

    /**
     *
     * Sets the screen rectangle at which the image is drawn.
     *
     * @mangled SetPut__12CEventSpriteFiiii
     * @address 0x2940E0
     * @size 0x20
     */
    void SetPut(int x, int y, int w, int h);

    /**
     *
     * Starts moving the image to a screen position over a number of frames.
     *
     * @mangled SetMove__12CEventSpriteFiii
     * @address 0x294100
     * @size 0x30
     */
    void SetMove(int x, int y, int frames);

    /**
     *
     * Starts fading the image in or out over a number of frames.
     *
     * @mangled SetFade__12CEventSpriteFii
     * @address 0x294130
     * @size 0x40
     */
    void SetFade(int fade_in, int frames);

    /**
     *
     * Sets the image's colour.
     *
     * @mangled SetColor__12CEventSpriteFiiii
     * @address 0x294170
     * @size 0x20
     */
    void SetColor(int r, int g, int b, int a);

    /**
     *
     * Advances the image's move or fade by one frame.
     *
     * @mangled Step__12CEventSpriteFv
     * @address 0x294190
     * @size 0x130
     */
    void Step();

    /**
     *
     * Draws the image as a screen sprite.
     *
     * @mangled Draw__12CEventSpriteFv
     * @address 0x2942C0
     * @size 0x1A0
     */
    void Draw();

    /**
     *
     * Clears the image and stops its animation.
     *
     * @mangled Init__12CEventSpriteFv
     * @address 0x294460
     * @size 0x80
     */
    void Init();
};

STATIC_ASSERT(sizeof(CEventSprite) == 0x88);

/**
 *
 * Holds the eight images that event scripts address by number.
 *
 */
class CEventSpriteMother {
public:
    CEventSprite sprite[8]; /**< Images, by number. */

    /**
     *
     * Clears every image.
     *
     */
    CEventSpriteMother() { Init(); }

    /**
     *
     * Gives an image the texture of a name; gives 1, or 0 for an image number out of range.
     *
     * @mangled SetName__18CEventSpriteMotherFiPc
     * @address 0x2944E0
     * @size 0x50
     */
    int SetName(int index, char *name);

    /**
     *
     * Shows or hides an image; gives 1, or 0 for an image number out of range.
     *
     * @mangled SetDraw__18CEventSpriteMotherFii
     * @address 0x294530
     * @size 0x50
     */
    int SetDraw(int index, int draw);

    /**
     *
     * Sets the part of the texture that an image shows; gives 1, or 0 for an image number out of range.
     *
     * @mangled SetGet__18CEventSpriteMotherFiiiii
     * @address 0x294580
     * @size 0x50
     */
    int SetGet(int index, int a, int b, int c, int d);

    /**
     *
     * Sets the screen rectangle of an image; gives 1, or 0 for an image number out of range.
     *
     * @mangled SetPut__18CEventSpriteMotherFiiiii
     * @address 0x2945D0
     * @size 0x50
     */
    int SetPut(int index, int a, int b, int c, int d);

    /**
     *
     * Starts moving an image; gives 1, or 0 for an image number out of range.
     *
     * @mangled SetMove__18CEventSpriteMotherFiiii
     * @address 0x294620
     * @size 0x50
     */
    int SetMove(int index, int a, int b, int c);

    /**
     *
     * Starts fading an image in or out; gives 1, or 0 for an image number out of range.
     *
     * @mangled SetFade__18CEventSpriteMotherFiii
     * @address 0x294670
     * @size 0x50
     */
    int SetFade(int index, int a, int b);

    /**
     *
     * Sets an image's colour; gives 1, or 0 for an image number out of range.
     *
     * @mangled SetColor__18CEventSpriteMotherFiiiii
     * @address 0x2946C0
     * @size 0x50
     */
    int SetColor(int index, int a, int b, int c, int d);

    /**
     *
     * Advances every image's animation by one frame.
     *
     * @mangled Step__18CEventSpriteMotherFv
     * @address 0x294710
     * @size 0x60
     */
    void Step();

    /**
     *
     * Draws every shown image.
     *
     * @mangled Draw__18CEventSpriteMotherFv
     * @address 0x294770
     * @size 0x60
     */
    void Draw();

    /**
     *
     * Clears an image, hidden and at full colour, on a texture block; gives 1, or 0 for an image number out of range.
     *
     * @mangled Set__18CEventSpriteMotherFii
     * @address 0x2947D0
     * @size 0xA0
     */
    int Set(int index, int value);

    /**
     *
     * Clears every image.
     *
     * @mangled Init__18CEventSpriteMotherFv
     * @address 0x294870
     * @size 0x60
     */
    void Init();
};

STATIC_ASSERT(sizeof(CEventSpriteMother) == 0x440);

/**
 *
 * Draw pass in which an event sprite is drawn.
 *
 */
enum EVENT_SPRITE2_DRAW {
    EVENT_SPRITE2_DRAW_OFF = 0,    /**< Not drawn. */
    EVENT_SPRITE2_DRAW_NORMAL = 1, /**< Drawn in the event's normal draw pass. */
    EVENT_SPRITE2_DRAW_FIRST = 2,  /**< Drawn in the event's first draw pass. */
};

/**
 *
 * Space in which an event sprite is placed.
 *
 */
enum EVENT_SPRITE2_TYPE {
    EVENT_SPRITE2_TYPE_SCREEN = 0, /**< Screen sprite, at a screen position and turned about the screen's z axis. */
    EVENT_SPRITE2_TYPE_WORLD = 1,  /**< Billboard at a world position, depth-tested against the scene. */
};

/**
 *
 * Sprite that an event script places on screen or in the world, scaled, turned and coloured.
 *
 */
class CEventSprite2 {
public:
    int           draw_flag{};      /**< Draw pass in which the sprite is drawn (EVENT_SPRITE2_DRAW). */
    int           sprite_type{};    /**< Space in which the sprite is placed (EVENT_SPRITE2_TYPE). */
    int           tex_block{};      /**< Texture block that holds the sprite's texture. */
    char          tex_name[0x20]{}; /**< Name of the sprite's texture; empty for an untextured sprite. */
    int           alpha_blend{};    /**< Alpha blend mode with which the sprite is drawn. */
    sceVu0FVECTOR pos{};            /**< Screen or world position of the sprite's centre. */
    sceVu0FVECTOR color{};          /**< Red, green, blue and alpha, with 128.0 as full. */
    float         rot_z{};          /**< Angle, in radians, by which a screen sprite is turned. */
    int           put_w{};          /**< Width of the sprite before scaling. */
    int           put_h{};          /**< Height of the sprite before scaling. */
    int           uv_x{};           /**< Texel x of the part of the texture that the sprite shows. */
    int           uv_y{};           /**< Texel y of the part of the texture that the sprite shows. */
    int           uv_w{};           /**< Texel width of the part of the texture that the sprite shows. */
    int           uv_h{};           /**< Texel height of the part of the texture that the sprite shows. */
    float         scale_x{};        /**< Horizontal scale of the sprite. */
    float         scale_y{};        /**< Vertical scale of the sprite. */

    /**
     *
     * Makes a hidden, untextured, white screen sprite.
     *
     * @mangled __ct__13CEventSprite2Fv
     * @address 0x2948D0
     * @size 0x30
     */
    CEventSprite2();

    /**
     *
     * Puts the sprite back to a hidden, untextured, white screen sprite.
     *
     * @mangled Initialize__13CEventSprite2Fv
     * @address 0x294900
     * @size 0x90
     */
    void Initialize();

    /**
     *
     * Gives the sprite the texture of a name in a texture block.
     *
     * @mangled SetTexture__13CEventSprite2FPci
     * @address 0x294990
     * @size 0x40
     */
    void SetTexture(char *name, int slot);

    /**
     *
     * Sets the draw pass in which the sprite is drawn.
     *
     * @mangled SetDrawFlag__13CEventSprite2Fi
     * @address 0x2949D0
     * @size 0x10
     */
    void SetDrawFlag(int draw_flag);

    /**
     *
     * Sets the space in which the sprite is placed.
     *
     * @mangled SetSpriteType__13CEventSprite2Fi
     * @address 0x2949E0
     * @size 0x10
     */
    void SetSpriteType(int sprite_type);

    /**
     *
     * Sets the sprite's position.
     *
     * @mangled SetPosition__13CEventSprite2FPf
     * @address 0x2949F0
     * @size 0x10
     */
    void SetPosition(float *pos);

    /**
     *
     * Sets the sprite's colour.
     *
     * @mangled SetColor__13CEventSprite2FPf
     * @address 0x294A00
     * @size 0x10
     */
    void SetColor(float *color);

    /**
     *
     * Sets the sprite's size before scaling.
     *
     * @mangled SetPutSize__13CEventSprite2Fii
     * @address 0x294A10
     * @size 0x10
     */
    void SetPutSize(int w, int h);

    /**
     *
     * Sets the part of the texture that the sprite shows.
     *
     * @mangled SetUvSize__13CEventSprite2Fiiii
     * @address 0x294A20
     * @size 0x20
     */
    void SetUvSize(int u, int v, int w, int h);

    /**
     *
     * Sets the sprite's scale.
     *
     * @mangled SetScale__13CEventSprite2Fff
     * @address 0x294A40
     * @size 0x10
     */
    void SetScale(float scale_x, float scale_y);

    /**
     *
     * Gives the sprite's scale.
     *
     * @mangled GetScale__13CEventSprite2FPfPf
     * @address 0x294A50
     * @size 0x20
     */
    void GetScale(float *out_x, float *out_y);

    /**
     *
     * Gives the sprite's position.
     *
     * @mangled GetPosition__13CEventSprite2FPf
     * @address 0x294A70
     * @size 0x10
     */
    void GetPosition(float *out);

    /**
     *
     * Gives the sprite's colour.
     *
     * @mangled GetColor__13CEventSprite2FPf
     * @address 0x294A80
     * @size 0x10
     */
    void GetColor(float *out);

    /**
     *
     * Gives the space in which the sprite is placed.
     *
     * @mangled GetType__13CEventSprite2Fv
     * @address 0x294A90
     * @size 0x10
     */
    int GetType();

    /**
     *
     * Sets the alpha blend mode with which the sprite is drawn.
     *
     * @mangled SetAlphaBlend__13CEventSprite2Fi
     * @address 0x294AA0
     * @size 0x10
     */
    void SetAlphaBlend(int alpha_blend);

    /**
     *
     * Sets the angle by which a screen sprite is turned.
     *
     * @mangled SetRotZ__13CEventSprite2Ff
     * @address 0x294AB0
     * @size 0x10
     */
    void SetRotZ(float rot_z);

    /**
     *
     * Gives the angle by which a screen sprite is turned.
     *
     * @mangled GetRotZ__13CEventSprite2Fv
     * @address 0x294AC0
     * @size 0x10
     */
    float GetRotZ();

    /**
     *
     * Draws the sprite when it belongs to the normal draw pass.
     *
     * @mangled NormalDraw__13CEventSprite2Fv
     * @address 0x294AD0
     * @size 0x30
     */
    void NormalDraw();

    /**
     *
     * Draws the sprite when it belongs to the first draw pass.
     *
     * @mangled FirstDraw__13CEventSprite2Fv
     * @address 0x294B00
     * @size 0x30
     */
    void FirstDraw();

    /**
     *
     * Draws the sprite as a screen sprite or a world billboard; hides a sprite of an unknown type.
     *
     * @mangled Draw__13CEventSprite2Fv
     * @address 0x294B30
     * @size 0x630
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CEventSprite2) == 0x80);
