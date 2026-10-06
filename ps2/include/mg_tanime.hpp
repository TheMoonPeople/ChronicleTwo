#pragma once

#include "common.h"

/**
 * @file
 * Declares the engine's texture animation: records that copy, scroll or sway
 * a rectangle of one texture into another every frame, chained into named
 * groups that a texture block plays, plus the list and rectangle templates
 * the records are held and drawn with.
 */

class mgCMemory;
class mgCTexture;
struct sceVif1Packet;

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
    MG_TEX_ANIME_ALPHA_BLEND_OFF = 4,  /**< alpha_blend value that draws without alpha blending. */
    MG_TEX_ANIME_ALPHA_TEST_OFF = -1,  /**< alpha_test value that draws without an alpha test. */
    MG_TEX_ANIME_WAIT_FOREVER = -1,    /**< wait value that keeps a record playing for good. */
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
    T left;   /**< Left edge. */
    T top;    /**< Top edge. */
    T right;  /**< Right edge, inclusive. */
    T bottom; /**< Bottom edge, inclusive. */

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

template <>
class mgRect<short> {
public:
    short left;
    short top;
    short right;
    short bottom;

    mgRect() { Set(0, 0, 0, 0); }
    mgRect(short new_left, short new_top, short new_right, short new_bottom) {
        Set(new_left, new_top, new_right, new_bottom);
    }
    void Set(short new_left, short new_top, short new_right, short new_bottom) {
        left = new_left;
        top = new_top;
        right = new_right;
        bottom = new_bottom;
    }
};

template <class T>
void mgRect<T>::Set(T new_left, T new_top, T new_right, T new_bottom) {
    left = new_left;
    top = new_top;
    right = new_right;
    bottom = new_bottom;
}

template <>
inline mgRect<int>::mgRect() {}

template <>
void mgRect<int>::Set(int new_left, int new_top, int new_right, int new_bottom);

template <>
inline mgRect<float>::mgRect() { Set(0, 0, 0, 0); }

template <>
void mgRect<float>::Set(float new_left, float new_top, float new_right, float new_bottom);

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
    T data;         /**< Object the node carries. */

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
    prev = 0;
    next = 0;
}

/**
 *
 * One step of a texture animation: a rectangle of a source texture moved into a destination texture, and how long it plays.
 *
 */
class mgCTexAnimeData {
public:
    signed char type; /**< How the rectangle is moved, an mgTEX_ANIME_TYPE. */
    signed char group; /**< Animation group the record is entered into. */
    signed char link_group; /**< Group enabled while this record plays, or -1 for none. */
    u_char clut_copy; /**< Non-zero copies the source's palette to the destination even when the rectangle is not the whole texture. */
    mgCTexture *src_tex;      /**< Texture the rectangle is taken from. */
    mgCTexture *dest_tex;     /**< Texture the rectangle is drawn into. */
    short src_x; /**< Left edge of the source rectangle, in sixteenths of a texel. */
    short src_y; /**< Top edge of the source rectangle, in sixteenths of a texel. */
    short src_w; /**< Width of the source rectangle, in sixteenths of a texel. */
    short src_h; /**< Height of the source rectangle, in sixteenths of a texel. */
    short dest_x; /**< Left edge of the destination rectangle, in sixteenths of a texel. */
    short dest_y; /**< Top edge of the destination rectangle, in sixteenths of a texel. */
    short dest_w; /**< Width of the destination rectangle, in sixteenths of a texel. */
    short dest_h; /**< Height of the destination rectangle, in sixteenths of a texel. */
    short period_x; /**< Frames one horizontal cycle lasts; the sign gives the scroll direction and zero stops it. */
    short period_y; /**< Frames one vertical cycle lasts; the sign gives the scroll direction and zero stops it. */
    short phase_x; /**< Frame reached in the current horizontal cycle. */
    short phase_y; /**< Frame reached in the current vertical cycle. */
    short amplitude_x; /**< Horizontal sway of a wave record, in ten-thousandths of the destination width. */
    short amplitude_y; /**< Vertical sway of a wave record, in ten-thousandths of the destination height. */
    short wait; /**< Frames the record plays before the group moves on; zero also plays the next record, -1 holds forever. */
    short bug_patch; /**< Non-zero ends the record after exactly wait frames rather than one frame later. */
    u_char bilinear; /**< Non-zero filters a drawn rectangle bilinearly. */
    u_char alpha_blend; /**< Alpha blending mode a drawn rectangle uses, or 4 for none. */
    signed char alpha_test; /**< Alpha test method a drawn rectangle uses, or -1 for none. */
    u_char alpha_ref; /**< Reference value of the alpha test. */
    u_char r; /**< Red the drawn rectangle is tinted with, 0x80 for unchanged. */
    u_char g; /**< Green the drawn rectangle is tinted with, 0x80 for unchanged. */
    u_char b; /**< Blue the drawn rectangle is tinted with, 0x80 for unchanged. */
    u_char a; /**< Alpha the drawn rectangle is drawn with, 0x80 for opaque. */

    /**
     *
     * Creates an empty record with default drawing settings.
     *
     * @mangled __ct__15mgCTexAnimeDataFv
     * @address 0x13C340
     * @size 0x30
     */
    mgCTexAnimeData();

    /**
     *
     * Empties the record and restores the default drawing settings.
     *
     * @mangled Initialize__15mgCTexAnimeDataFv
     * @address 0x13C370
     * @size 0x90
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(mgCTexAnimeData) == 0x34);
STATIC_ASSERT(sizeof(CList<mgCTexAnimeData>) == 0x40);

/**
 *
 * Plays the texture-animation groups of one texture block, each a chain of records stepped through frame by frame.
 *
 */
class mgCTextureAnime {
public:
    /**
     *
     * Holds every texture animation on its current frame while it is not zero.
     *
     * @mangled stop_anime__15mgCTextureAnime
     * @address 0x37CD98
     * @size 0x4
     */
    static int stop_anime;

    int group_num; /**< Number of groups in use by the arrays below. */
    int enable[MG_TEX_ANIME_GROUP_MAX]; /**< Non-zero for each group that plays. */
    CList<mgCTexAnimeData> *list[MG_TEX_ANIME_GROUP_MAX]; /**< First record of each group. */
    CList<mgCTexAnimeData> *now[MG_TEX_ANIME_GROUP_MAX];  /**< Record each group is playing. */
    char *name[MG_TEX_ANIME_GROUP_MAX];                   /**< Name each group is looked up by, or NULL. */
    int frame[MG_TEX_ANIME_GROUP_MAX]; /**< Frames each group's current record has played. */

    /**
     *
     * Draws the current record of every playing group whose textures lie in the given texture block, and advances the groups a frame.
     *
     * @mangled TexAnime__15mgCTextureAnimeFiP13sceVif1Packet
     * @address 0x13C400
     * @size 0x1460
     */
    void TexAnime(int texb, sceVif1Packet *packet);

    /**
     *
     * Empties every group.
     *
     * @mangled Initialize__15mgCTextureAnimeFv
     * @address 0x13D860
     * @size 0x70
     */
    void Initialize();

    /**
     *
     * Creates a player with every group empty.
     *
     * @mangled __ct__15mgCTextureAnimeFv
     * @address 0x13D8D0
     * @size 0x30
     */
    mgCTextureAnime();

    /**
     *
     * Names a group so that it can be looked up.
     *
     * @mangled SetGroupName__15mgCTextureAnimeFiPc
     * @address 0x13D900
     * @size 0x40
     */
    void SetGroupName(int group, char *group_name);

    /**
     *
     * Gives the first group with no records, or -1 when every group is in use.
     *
     * @mangled GetEmptyGroup__15mgCTextureAnimeFv
     * @address 0x13D940
     * @size 0x50
     */
    int GetEmptyGroup();

    /**
     *
     * Gives the group with the given name, or -1 when there is none.
     *
     * @mangled SearchGroupName__15mgCTextureAnimeFPc
     * @address 0x13D990
     * @size 0xB0
     */
    int SearchGroupName(char *group_name);

    /**
     *
     * Allocates an unlinked record node from the given memory.
     *
     * @mangled NewTexAnimeData__15mgCTextureAnimeFP9mgCMemory
     * @address 0x13DA40
     * @size 0x80
     */
    CList<mgCTexAnimeData> *NewTexAnimeData(mgCMemory *stack);

    /**
     *
     * Allocates a record node from the given memory and appends it to a group.
     *
     * @mangled NewTexAnimeGroupData__15mgCTextureAnimeFiP9mgCMemory
     * @address 0x13DAD0
     * @size 0x120
     */
    CList<mgCTexAnimeData> *NewTexAnimeGroupData(int group, mgCMemory *stack);

    /**
     *
     * Appends a copy of a record to the group it names, flipping its rectangles into the textures' vertical orientation.
     *
     * @mangled EnterTexAnime__15mgCTextureAnimeFP15mgCTexAnimeDataP9mgCMemory
     * @address 0x13DBF0
     * @size 0x1B0
     */
    int EnterTexAnime(mgCTexAnimeData *data, mgCMemory *stack);

    /**
     *
     * Stops a group and forgets its records and name.
     *
     * @mangled DeleteGroup__15mgCTextureAnimeFi
     * @address 0x13DDA0
     * @size 0x70
     */
    void DeleteGroup(int group);

    /**
     *
     * Stops every group and rewinds it to its first record.
     *
     * @mangled DisableAll__15mgCTextureAnimeFv
     * @address 0x13DE10
     * @size 0x60
     */
    void DisableAll();

    /**
     *
     * Starts a group playing.
     *
     * @mangled Enable__15mgCTextureAnimeFi
     * @address 0x13DE70
     * @size 0x40
     */
    void Enable(int group);

    /**
     *
     * Stops a group and rewinds it to its first record.
     *
     * @mangled Disable__15mgCTextureAnimeFi
     * @address 0x13DEB0
     * @size 0x40
     */
    void Disable(int group);

    /**
     *
     * Gives the first record of a group, or NULL for a group out of range.
     *
     * @mangled GetAnimeList__15mgCTextureAnimeFi
     * @address 0x13DEF0
     * @size 0x40
     */
    CList<mgCTexAnimeData> *GetAnimeList(int group);
};

STATIC_ASSERT(sizeof(mgCTextureAnime) == 0x1E4);
