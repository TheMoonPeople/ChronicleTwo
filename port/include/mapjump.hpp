#pragma once

#include "common.h"

#include <string_view>

#include "mg_memory.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"

/**
 * @file
 * Declares the moves between town maps: loading the main map and the sub
 * map of a scene, entering and leaving interiors, and loading the event
 * script that belongs to the current map.
 */

/**
 *
 * Describes where one of the scene's two map slots is loaded: its slot, stack, texture blocks and load buffer.
 *
 */
class MapJumpMapInfo {
public:
    s32 map_no{};        /**< Scene map slot the map is loaded into. */
    s32 tex_block{};     /**< First texture block the map's textures are entered into. */
    s32 stack_no{};      /**< Scene stack the map is built in. */
    s32 efp_tex_block{}; /**< Texture block the map's effect pack textures are entered into. */
    s32 sky_tex_block{}; /**< Texture block the sky's textures are entered into. */
    u8 *load_buf{};      /**< Buffer the map's files are loaded into. */

    /**
     *
     * Constructs a description with every setting cleared to zero.
     *
     * @mangled __ct__14MapJumpMapInfoFv
     * @address 0x2E3C40
     * @size 0x30
     */
    MapJumpMapInfo();
};

STATIC_ASSERT(sizeof(MapJumpMapInfo) == 0x18);

/**
 *
 * Gives the map number of the main map now loaded, or -1 when none is.
 *
 * @mangled GetMainMapNo__Fv
 * @address 0x2E3C10
 * @size 0x10
 */
int GetMainMapNo();

/**
 *
 * Gives the map number of the sub map now loaded, or -1 when none is.
 *
 * @mangled GetSubMapNo__Fv
 * @address 0x2E3C20
 * @size 0x10
 */
int GetSubMapNo();

/**
 *
 * Records that no sub map is loaded.
 *
 * @mangled ClearSubMapNo__Fv
 * @address 0x2E3C30
 * @size 0x10
 */
void ClearSubMapNo();

/**
 *
 * Sets the slot, stack, texture blocks and buffer the main map is loaded with.
 *
 * @mangled SetMainMapInfo__FP14MapJumpMapInfo
 * @address 0x2E3C70
 * @size 0x50
 */
void SetMainMapInfo(MapJumpMapInfo *info);

/**
 *
 * Sets the slot, stack, texture blocks and buffer the sub map is loaded with.
 *
 * @mangled SetSubMapInfo__FP14MapJumpMapInfo
 * @address 0x2E3CC0
 * @size 0x50
 */
void SetSubMapInfo(MapJumpMapInfo *info);

/**
 *
 * Sets the stack the maps' event scripts are loaded into.
 *
 * @mangled SetScriptBuffer__FP9mgCMemory
 * @address 0x2E3D10
 * @size 0x10
 */
void SetScriptBuffer(mgCMemory *buffer);

/**
 *
 * Reads the background data ahead of a map load and waits until it is read.
 *
 * @mangled PreLoadSync__Fv
 * @address 0x2E3D20
 * @size 0x30
 */
int PreLoadSync();

/**
 *
 * Replaces the scene's main map with another map, clearing its sub map and characters, and loads the new map's event script; gives 1 on success and 0 on failure.
 *
 * @mangled MapJump__FP6CSceneP17SCN_LOADMAP_INFO2i
 * @address 0x2E3D50
 * @size 0x1F0
 */
int MapJump(CScene *scene, SCN_LOADMAP_INFO2 *info, int map_index);

/**
 *
 * Deletes the scene's sub map and main map. A caller that reuses the maps' arena calls this first: an arena reset retires
 * the map slots, and a retired slot no longer knows the texture blocks, model lists and event handles to release.
 *
 */
void DeleteJumpMaps(CScene *scene);

/**
 *
 * Fills a map load description with the main map settings and the file names of a map and its added map; gives 1 on success and 0 for an unknown map.
 *
 * @mangled GetLoadMapInfo__FP17SCN_LOADMAP_INFO2i
 * @address 0x2E3F40
 * @size 0x270
 */
int GetLoadMapInfo(SCN_LOADMAP_INFO2 *info, int map_no);

/**
 *
 * Replaces the scene's sub map with another map, building it at once or, when background is nonzero, only reading its files for the scene to build later; gives 1 on success and 0 on failure.
 *
 * @mangled LoadSubMap__FP6CSceneii
 * @address 0x2E41B0
 * @size 0x1C0
 */
int LoadSubMap(CScene *scene, int sub_map_no, int flag);

/**
 *
 * Loads the event script that belongs to a map and remembers its file name.
 *
 * @mangled LoadMapScript__FPc
 * @address 0x2E4370
 * @size 0x90
 */
void LoadMapScript(char *map_name);

/**
 *
 * Loads again the event script last loaded for a map, if any.
 *
 * @mangled ReloadMapScript__Fv
 * @address 0x2E4400
 * @size 0x30
 */
void ReloadMapScript();

/**
 *
 * Loads an event script into the script stack, preferring the version for the current language, and makes it the running event script.
 *
 * @mangled LoadScript__FPc
 * @address 0x2E4430
 * @size 0x160
 */
void LoadScript(std::string_view path);

/**
 *
 * Gives the map number of the interior last left, or -1 while inside an interior.
 *
 * @mangled GetOldInteriorMapNo__Fv
 * @address 0x2E4590
 * @size 0x40
 */
int GetOldInteriorMapNo();

/**
 *
 * Records that no interior is entered and forgets the interiors and the map left behind.
 *
 * @mangled InitInterior__Fv
 * @address 0x2E45D0
 * @size 0x20
 */
void InitInterior();

/**
 *
 * Gives nonzero while the player is inside an interior.
 *
 * @mangled InInterior__Fv
 * @address 0x2E45F0
 * @size 0x10
 */
int InInterior();

/**
 *
 * Remembers the sub map, player position, music and camera to restore on leaving an interior.
 *
 * @mangled SaveBeforeInterior__FP6CScene
 * @address 0x2E4600
 * @size 0xF0
 */
void SaveBeforeInterior(CScene *scene);

/**
 *
 * Places the player at the door of the active map that leads back to the previous interior, or at its exit.
 *
 * @mangled SetInteriorDoorPos__FP6CScene
 * @address 0x2E46F0
 * @size 0x1E0
 */
void SetInteriorDoorPos(CScene *scene);

/**
 *
 * Enters an interior from the town: loads it as the sub map, makes it the active map and loads its event script.
 *
 * @mangled GotoInterior__FP6CScenei
 * @address 0x2E48D0
 * @size 0x160
 */
void GotoInterior(CScene *scene, int interior_no);

/**
 *
 * Unloads the interior loaded as the sub map, if inside one.
 *
 * @mangled DeleteInterior__FP6CScene
 * @address 0x2E4A30
 * @size 0x70
 */
void DeleteInterior(CScene *scene);

/**
 *
 * Leaves the interior: restores the sub map, player position, camera, music and event script saved on entering it.
 *
 * @mangled ExitInterior__FP6CScenePi
 * @address 0x2E4AA0
 * @size 0x250
 */
void ExitInterior(CScene *scene, int *sub_map_no);

/**
 *
 * Moves from one interior into another, placing the player at the door it was entered by; gives 1 on success and 0 on failure.
 *
 * @mangled InteriorMapJump__FP6CScenei
 * @address 0x2E4CF0
 * @size 0xF0
 */
int InteriorMapJump(CScene *scene, int interior_no);
