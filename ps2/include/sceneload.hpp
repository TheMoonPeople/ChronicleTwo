#pragma once

#include "common.h"

#include "mg_tanime.hpp"

/**
 * @file
 * Declares what a scene needs to load a map: the description of the map's
 * files and where they are loaded, the steps a map is built from them in,
 * and the object stack an edit map keeps its messages in.
 */

class mgCMemory;
struct EMAP_MESSAGE;

/**
 *
 * Number of maps loaded together into one scene map slot: the map itself and the map added to it.
 *
 */
enum {
    SCN_LOADMAP_FILES_MAX = 2, /**< Entries in SCN_LOADMAP_INFO2::files. */
};

/**
 *
 * Steps of CScene::LoadMapFromMemory, each building one part of a map from its loaded files.
 *
 */
enum SCN_LOADMAP_STEP {
    SCN_LOADMAP_STEP_CREATE = 0,       /**< Makes the map object and assigns it to the scene. */
    SCN_LOADMAP_STEP_MAP_INFO = 1,     /**< Reads the map description (.map) of the map and of the added map. */
    SCN_LOADMAP_STEP_DATA = 2,         /**< Loads the models (.mpk) and textures (.ipk) of both maps. */
    SCN_LOADMAP_STEP_EFFECT = 3,       /**< Loads the effects (.efp) and the sky (.sky). */
    SCN_LOADMAP_STEP_CREATE_MAP = 4,   /**< Makes the table of placed parts and builds the map's parts. */
    SCN_LOADMAP_STEP_FUNC_POINT = 5,   /**< Assigns the map's function points. */
    SCN_LOADMAP_STEP_CFG = 6,          /**< Runs the configuration script (.cfg) and finishes the map; the last step. */
};

/**
 *
 * Describes a map to load into a scene: the names of its files, the buffers they are loaded into, and the texture blocks and stack they use.
 *
 */
struct SCN_LOADMAP_INFO2 {
    /**
     *
     * Names and loaded contents of the files of one map: the map itself, or the map added to it.
     *
     */
    struct MapFiles {
        s32 enable;                 /**< Nonzero when this map is loaded. */
        char dir[0x20];             /**< Directory the map's files are in. */
        char map_name[0x10];        /**< Name of the map description file, without its .map extension. */
        char cfg_name[0x10];        /**< Name of the configuration script, without its .cfg extension. */
        char mpk_name[0x10];        /**< Name of the model pack, without its .mpk extension. */
        char ipk_name[0x10];        /**< Name of the texture pack, without its .ipk extension. */
        char efp_name[0x10];        /**< Name of the effect pack, without its .efp extension. */
        char sky_name[0x10];        /**< Name of the sky pack in dir, without its .sky extension. */
        char def_sky_name[0x10];    /**< Name of the sky pack in the common map/ directory, used when sky_name is not found. */
        char *map_data;             /**< Loaded map description. */
        s32 map_size;               /**< Size in bytes of map_data. */
        char *cfg_data;             /**< Loaded configuration script. */
        s32 cfg_size;               /**< Size in bytes of cfg_data. */
        unsigned int *mpk_data;     /**< Loaded model pack. */
        unsigned int *ipk_data;     /**< Loaded texture pack, or NULL when it was not found. */
        unsigned int *efp_data;     /**< Loaded effect pack, or NULL when it was not found. */
        unsigned int *sky_data;     /**< Loaded sky pack, or NULL when it was not found or not wanted. */
    };

    s32 tex_block;                              /**< First texture block the map's textures are entered into. */
    s32 stack_no;                               /**< Scene stack the map is built in. */
    u8 *load_buf;                               /**< Buffer the map description, configuration script, model pack and sky pack are loaded into. */
    s32 efp_tex_block;                          /**< Texture block the effect pack's textures are entered into. */
    s32 sky_tex_block;                          /**< Texture block the sky's textures are entered into; the sky is made only when it is above zero. */
    char name[0x10];                            /**< Name the map is assigned to the scene under. */
    MapFiles files[SCN_LOADMAP_FILES_MAX];      /**< Files of the map itself and of the map added to it. */
    s32 load_sky;                               /**< Nonzero to load the sky pack. */
    s32 place_parts_max;                        /**< Number of placed parts the map makes room for; none when not above zero. */
    s32 unk_194;
    s32 tex_block_num;                          /**< Number of texture blocks the map's textures took. */
    s32 data_ready;                             /**< Nonzero once the map's files are loaded and the map can be built. */
    s32 map_no;                                 /**< Scene map slot the map is loaded into. */
    mgCMemory *stack;                           /**< Stack the map is built in, and the texture and effect packs are loaded into. */

    /**
     *
     * Clears every name, buffer and setting to zero.
     *
     * @mangled Initialize__17SCN_LOADMAP_INFO2Fv
     * @address 0x288F20
     * @size 0x10
     */
    void Initialize();

    /**
     *
     * Copies every name, buffer and setting of another map description into this one.
     *
     * @mangled __as__17SCN_LOADMAP_INFO2FRC17SCN_LOADMAP_INFO2
     * @address 0x289B80
     * @size 0xC0
     */
    SCN_LOADMAP_INFO2 &operator=(const SCN_LOADMAP_INFO2 &other);
};
STATIC_ASSERT(sizeof(SCN_LOADMAP_INFO2::MapFiles) == 0xB4);
STATIC_ASSERT(sizeof(SCN_LOADMAP_INFO2) == 0x1A8);

/**
 *
 * Stack of objects of type T, emptied by Initialize.
 *
 */
template <typename T>
class mgCObjectStack {
public:
    u8 unk_0[0x8];
    s32 unk_8;
    u8 unk_c[0x8];

    /**
     *
     * Empties the stack.
     *
     * @mangled Initialize__39mgCObjectStack_21CList_12EMAP_MESSAGE__Fv
     * @address 0x289900
     * @size 0x10
     */
    void Initialize();
};

template <typename T>
void mgCObjectStack<T>::Initialize() {
    unk_8 = 0;
}

template <>
void mgCObjectStack<CList<EMAP_MESSAGE> >::Initialize();

STATIC_ASSERT(sizeof(mgCObjectStack<CList<EMAP_MESSAGE> >) == 0x14);
