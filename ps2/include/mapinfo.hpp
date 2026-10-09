#pragma once

#include "common.h"

#include <libvu0.h>

#include "mapload.hpp"

/**
 * @file
 * Declares the per-map settings read from a map's configuration script
 * (texture and model packs, lighting sets, time of day, sky) and the
 * fixed-camera areas of a map.
 */

class mgCMemory;
class CColFrame;
class CMapLightingInfo;
class CCameraDrawInfo;

/**
 *
 * Describes one fixed-camera area of a map: the camera positions it
 * offers, the collision shapes that mark where it applies, and the
 * map part groups shown while it is in use.
 *
 */
class CCameraInfo {
public:
    int             pos_num;       /**< Number of entries of pos in use. */
    sceVu0FVECTOR   pos[8];        /**< World positions of the fixed camera. */
    int             rect_num;      /**< Number of entries of rect. */
    CColFrame      *rect[4];       /**< Collision shapes marking the area where the camera applies. */
    int             draw_info_num; /**< Number of entries of draw_info. */
    CCameraDrawInfo draw_info[4];  /**< Map part groups switched on while the camera is in use. */

    /**
     *
     * Constructs a camera area with no positions, shapes or part groups.
     *
     * @mangled __ct__11CCameraInfoFv
     * @address 0x1642C0
     * @size 0x60
     */
    CCameraInfo();

    /**
     *
     * Clears every position, collision shape and part group of the area.
     *
     * @mangled Initialize__11CCameraInfoFv
     * @address 0x166250
     * @size 0xD0
     */
    void Initialize();

    /**
     *
     * Gives one part group entry of the area, or null for an index out of range.
     *
     * @mangled GetDrawInfo__11CCameraInfoFi
     * @address 0x166320
     * @size 0x40
     */
    CCameraDrawInfo *GetDrawInfo(int index);
};

STATIC_ASSERT(sizeof(CCameraInfo) == 0xD0);

/**
 *
 * Holds the settings that a map's configuration script gives: the
 * texture and model packs to load, the lighting sets, the time-of-day
 * behaviour, the sky and the character lighting.
 *
 */
class CMapInfo {
public:
    int               img_num;           /**< Capacity of img_name. */
    char             *img_name[16];      /**< Names of the texture packs of the map, null after the last. */
    int               pcp_num;           /**< Capacity of pcp_name. */
    char             *pcp_name[16];      /**< Names of the model packs of the map, null after the last. */
    char             *map_file;          /**< Copy of the map's configuration script. */
    int               map_file_size;     /**< Size of map_file, in bytes. */
    char             *add_map_file;      /**< Copy of the map's additional configuration script. */
    int               add_map_file_size; /**< Size of add_map_file, in bytes. */
    int               active_light_no;   /**< Lighting set used when lighting does not follow the time of day. */
    int               lighting_info_num; /**< Number of entries of lighting_info. */
    CMapLightingInfo *lighting_info;     /**< Lighting sets of the map. */
    int               time_cfade;        /**< Value of the TIME_CFADE tag. */
    float             floor;             /**< Value of the FLOOR tag. */
    int               unk_ac;
    sceVu0FVECTOR     chara_pos;                   /**< Position given by the CHARA_POS tag. */
    int               time_enable;                 /**< Non-zero when the map follows the clock of the game. */
    int               time_light_blend;            /**< Non-zero to blend lighting sets and turn the sun with the time of day. */
    float             fixed_time;                  /**< Hour of the day used when the clock is not followed. */
    int               fixed_time_enable;           /**< Non-zero to use fixed_time when the clock is not followed. */
    int               time_light_num;              /**< Number of lighting sets that divide the day. */
    int               def_foot;                    /**< Value of the DEF_FOOT tag. */
    int               sky_info;                    /**< First value of the SKY_INFO tag. */
    float             sky_height;                  /**< Height used to position the sky and its camera. */
    float             sun_angle;                   /**< Angle, in radians, of the sun's path about the vertical axis. */
    int               lens_flare;                  /**< Value of the LENS_FLARE tag. */
    int               all_scissor;                 /**< Value passed on when the model packs are loaded. */
    int               chara_light_adjust;          /**< First value of the CHARA_LIGHT_ADJUST tag. */
    float             chara_light_adjust_value[3]; /**< Remaining values of the CHARA_LIGHT_ADJUST tag. */
    int               unk_fc;

    CMapInfo() { Initialize(); }

    /**
     *
     * Clears every setting and gives the defaults that a script may change.
     *
     * @mangled Initialize__8CMapInfoFv
     * @address 0x166360
     * @size 0x50
     */
    void Initialize();

    /**
     *
     * Gives the name of one texture pack, or null for an index out of range.
     *
     * @mangled GetImgName__8CMapInfoFi
     * @address 0x1663B0
     * @size 0x40
     */
    char *GetImgName(int index);

    /**
     *
     * Gives the name of one model pack, or null for an index out of range.
     *
     * @mangled GetPCPName__8CMapInfoFi
     * @address 0x1663F0
     * @size 0x40
     */
    char *GetPCPName(int index);

    /**
     *
     * Gives the copy of the configuration script and its size.
     *
     * @mangled GetMapFile__8CMapInfoFPi
     * @address 0x166430
     * @size 0x10
     */
    char *GetMapFile(int *size);

    /**
     *
     * Gives the copy of the additional configuration script and its size.
     *
     * @mangled GetAddMapFile__8CMapInfoFPi
     * @address 0x166440
     * @size 0x10
     */
    char *GetAddMapFile(int *size);

    /**
     *
     * Gives one lighting set, or null for an index out of range.
     *
     * @mangled GetLightingInfo__8CMapInfoFi
     * @address 0x166450
     * @size 0x50
     */
    CMapLightingInfo *GetLightingInfo(int index);

    /**
     *
     * Gives the lighting set used when lighting does not follow the time of day.
     *
     * @mangled GetActiveLightNo__8CMapInfoFv
     * @address 0x162B90
     * @size 0x10
     */
    int GetActiveLightNo() { return active_light_no; }

    /**
     *
     * Keeps a copy of a configuration script, makes room for the lighting sets,
     * and runs the script to fill in the settings.
     *
     * @mangled LoadMapInfo__8CMapInfoFPciP9mgCMemory
     * @address 0x166EF0
     * @size 0x1C0
     */
    void LoadMapInfo(char *script, int script_size, mgCMemory *stack);

    /**
     *
     * Keeps a copy of an additional configuration script and runs it to add
     * texture and model packs.
     *
     * @mangled AddMapInfo__8CMapInfoFPciP9mgCMemory
     * @address 0x167280
     * @size 0xC0
     */
    void AddMapInfo(char *script, int script_size, mgCMemory *stack);

    /**
     *
     * Writes the lighting sets out as configuration script text, and gives the
     * number of characters written.
     *
     * @mangled OutputLightData__8CMapInfoFPc
     * @address 0x167340
     * @size 0x320
     */
    int OutputLightData(char *buff);
};

STATIC_ASSERT(sizeof(CMapInfo) == 0x100);
