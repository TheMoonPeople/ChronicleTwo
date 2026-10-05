#pragma once

#include "common.h"

/**
 * @file
 * Declares the sky of a map: the sky, back sky and sun models of each
 * time band, the background model behind them, and the description that
 * a sky pack's configuration script gives of them.
 */

class mgCFrame;
class mgCVisualMDT;
class mgCMemory;

/**
 * Holds what a sky pack's configuration script (info.cfg) names: for each
 * of the four time bands a texture pack and the sky, back sky and sun
 * models, plus the background model and the frames that turn by themselves.
 */
struct MAP_SKY_INFO {
    char  img_name[4][32];        /**< Texture pack of each time band, from the SKY_IMG tag. */
    char  sky_mds_name[4][32];    /**< Sky model of each time band, from the SKY_MDS tag. */
    float sky_rot_speed[4];       /**< Turn of each sky model per frame, in radians, from the SKY_MDS tag. */
    char  sun_mds_name[4][32];    /**< Sun or moon model of each time band, from the SUN_MDS tag. */
    char  skyb_mds_name[4][32];   /**< Back sky model of each time band, from the SKYB_MDS tag. */
    float skyb_rot_speed[4];      /**< Turn of each back sky model per frame, in radians, from the SKYB_MDS tag. */
    char  bg_mds_name[32];        /**< Background model drawn behind every time band, from the SKY_BG tag. */
    int   sky_anime_id[16];       /**< Time band whose sky model holds each turning frame, from the SKY_ANIME tag. */
    char  sky_anime_name[16][32]; /**< Name of each turning frame of a sky model, from the SKY_ANIME tag. */
    float sky_anime_speed[16];    /**< Turn of each sky model frame per frame, in radians, from the SKY_ANIME tag. */
    int   skyb_anime_id[16];      /**< Time band whose back sky model holds each turning frame, from the SKYB_ANIME tag. */
    char  skyb_anime_name[16][32]; /**< Name of each turning frame of a back sky model, from the SKYB_ANIME tag. */
    float skyb_anime_speed[16];   /**< Turn of each back sky model frame per frame, in radians, from the SKYB_ANIME tag. */
};
STATIC_ASSERT(sizeof(MAP_SKY_INFO) == 0x740);

/**
 * Draws the sky around the camera: a background model, then for each
 * time band whose lighting is in use a back sky, a sun or moon and a sky,
 * each with its own texture pack and slowly turning about the vertical axis.
 */
class CMapSky {
public:
    /**
     *
     * A frame of a sky or back sky model that turns about the vertical axis by itself.
     *
     */
    struct AnimeFrame {
        mgCFrame *frame; /**< Frame turned, or null for an unused entry. */
        float     speed; /**< Turn of the frame per frame, in radians. */
    };

    mgCFrame     *sky[4];            /**< Sky model of each time band, or null. */
    float         sky_rot[4];        /**< Angle, in radians, of each sky model about the vertical axis. */
    float         sky_rot_speed[4];  /**< Turn of each sky model per frame, in radians. */
    mgCFrame     *skyb[4];           /**< Back sky model of each time band, or null. */
    float         skyb_rot[4];       /**< Angle, in radians, of each back sky model about the vertical axis. */
    float         skyb_rot_speed[4]; /**< Turn of each back sky model per frame, in radians. */
    mgCFrame     *sun[4];            /**< Sun or moon model of each time band, or null. */
    int           tex_block[4];      /**< Texture block holding each time band's texture pack, or -1. */
    mgCFrame     *bg;                /**< Background model drawn behind the time band models, or null. */
    mgCVisualMDT *bg_visual;         /**< Visual of bg, whose colours follow the map lighting. */
    AnimeFrame    anime[16];         /**< Frames of the sky and back sky models that turn by themselves. */

    /**
     * Clears every model and turning frame and frees every texture block entry.
     *
     * @mangled Initialize__7CMapSkyFv
     * @address 0x1846F0
     * @size 0xA8
     */
    void Initialize();

    /**
     * Draws the background model at the camera, with its colours set from the map lighting.
     *
     * @mangled DrawSkyBack__7CMapSkyFPfPfPf
     * @address 0x1847A0
     * @size 0xFC
     */
    void DrawSkyBack(float *camera_pos, float *color1, float *color0);

    /**
     * Turns the sky models and draws the back sky, sun or moon, and sky of each time band in use.
     *
     * @mangled DrawSky__7CMapSkyFPfPfPfiPfPf
     * @address 0x1848A0
     * @size 0x570
     */
    void DrawSky(float *camera_pos, float *sun_pos, float *moon_pos, int time_band, float *lighting_ratio,
                 float *sun_lighting_ratio);

    /**
     * Loads a sky pack's textures into consecutive texture blocks and its models into memory.
     *
     * @mangled LoadPack__7CMapSkyFPUiiP9mgCMemory
     * @address 0x184E10
     * @size 0x3FC
     */
    void LoadPack(unsigned int *pack, int tex_block_base, mgCMemory *memory);
};
STATIC_ASSERT(sizeof(CMapSky::AnimeFrame) == 0x8);
STATIC_ASSERT(sizeof(CMapSky) == 0x108);

int CheckSkyID(int sky_id);
