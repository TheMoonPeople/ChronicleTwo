#pragma once

#include "common.h"

/**
 * @file
 * Declares the constants of the engine's texture animation and the list and rectangle templates its
 * records are held and drawn with.
 */

/**
 *
 * Number of animation groups one mgCTextureAnime holds.
 *
 */
enum {
    MG_TEX_ANIME_GROUP_MAX = 24, /**< Groups held by every mgCTextureAnime. */
};

/**
 *
 * Ways a texture-animation record moves its source rectangle into the destination.
 *
 */
enum mgTEX_ANIME_TYPE {
    MG_TEX_ANIME_TYPE_NONE = -1,  /**< Record holds no animation. */
    MG_TEX_ANIME_TYPE_COPY = 0,   /**< Copies the source rectangle onto the destination unchanged. */
    MG_TEX_ANIME_TYPE_SCROLL = 1, /**< Scrolls the source rectangle through the destination, wrapping round. */
    MG_TEX_ANIME_TYPE_WAVE = 2,   /**< Sways the source rectangle back and forth along a sine wave. */
};

/**
 *
 * Settings of a texture-animation record that leave a drawing state switched off.
 *
 */
enum {
    MG_TEX_ANIME_ALPHA_BLEND_OFF = 4, /**< alpha_blend value that draws without alpha blending. */
    MG_TEX_ANIME_ALPHA_TEST_OFF = -1, /**< alpha_test value that draws without an alpha test. */
    MG_TEX_ANIME_WAIT_FOREVER = -1,   /**< wait value that keeps a record playing for good. */
};

/**
 *
 * Texel formats and fixed-point scales a texture-animation record is drawn with.
 *
 */
enum mgTEX_ANIME_CONST {
    MG_TEX_ANIME_SUBTEXEL = 16,          /**< Sixteenths of a texel in one texel, the unit of every record rectangle. */
    MG_TEX_ANIME_BPP_INDEXED = 8,        /**< Bits per pixel of a paletted texture whose palette can be copied. */
    MG_TEX_ANIME_BPP_TRUE_COLOUR = 24,   /**< Lowest bits per pixel drawn as sprites rather than moved in VRAM. */
    MG_TEX_ANIME_AMPLITUDE_FULL = 10000, /**< Wave amplitude spanning the whole destination rectangle. */
    MG_TEX_ANIME_FRAME_ALIGN = 64,       /**< Rows a frame buffer's height is rounded up to. */
    MG_TEX_ANIME_NAME_ALLOC_UNIT = 16,   /**< Bytes in one quadword of a group name allocation. */
};

/**
 *
 * Axis-aligned rectangle given by its two inclusive corners.
 *
 */
template <class T>
class mgRect {
public:
    T left{};   /**< Left edge. */
    T top{};    /**< Top edge. */
    T right{};  /**< Right edge, inclusive. */
    T bottom{}; /**< Bottom edge, inclusive. */

    /**
     *
     * Creates a rectangle with every edge at zero.
     *
     */
    mgRect() { Set(0, 0, 0, 0); }

    /**
     *
     * Creates a rectangle from its four edges.
     *
     */
    mgRect(T new_left, T new_top, T new_right, T new_bottom) { Set(new_left, new_top, new_right, new_bottom); }

    /**
     *
     * Sets all four edges of the rectangle.
     *
     * @mangled Set__9mgRect_i_Fiiii
     * @address 0x13EA00
     * @size 0x20
     */
    void Set(T new_left, T new_top, T new_right, T new_bottom);
} __attribute__((aligned(16)));

template <class T>
void mgRect<T>::Set(T new_left, T new_top, T new_right, T new_bottom) {
    left = new_left;
    top = new_top;
    right = new_right;
    bottom = new_bottom;
}

template <>
inline mgRect<int>::mgRect() : left(0), top(0), right(0), bottom(0) {}

/**
 *
 * Sets the four edges of an integer rectangle.
 *
 * @mangled Set__9mgRect_i_Fiiii
 * @address 0x13EA00
 * @size 0x18
 */
template <>
void mgRect<int>::Set(int new_left, int new_top, int new_right, int new_bottom);

/**
 *
 * Sets the four edges of a floating-point rectangle.
 *
 * @mangled Set__9mgRect_f_Fffff
 * @address 0x1F3D50
 * @size 0x14
 */
template <>
void mgRect<float>::Set(float new_left, float new_top, float new_right, float new_bottom);

template <>
inline mgRect<float>::mgRect() { Set(0, 0, 0, 0); }

STATIC_ASSERT(sizeof(mgRect<int>) == 0x10);

/**
 *
 * Node of a doubly linked list that carries one object by value.
 *
 */
template <class T>
class CList {
public:
    CList<T> *next; /**< Following node, or NULL at the end of the list. */
    CList<T> *prev; /**< Preceding node, or NULL at the start of the list. */
    T         data; /**< Object the node carries. */

    /**
     *
     * Creates an unlinked node around a newly constructed object.
     *
     */
    CList() { Initialize(); }

    /**
     *
     * Gives the object the node carries.
     *
     */
    T *pGetData() { return &data; }

    /**
     *
     * Unlinks the node from its neighbours.
     *
     * @mangled Initialize__24CList_15mgCTexAnimeData_Fv
     * @address 0x13DAC0
     * @size 0x10
     */
    virtual void Initialize();
};

template <class T>
void CList<T>::Initialize() {
    prev = nullptr;
    next = nullptr;
}
