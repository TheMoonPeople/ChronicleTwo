#pragma once

#include "common.h"

#include <libvu0.h>

#include "editparts.hpp"

/**
 * @file
 * Declares Georama mode: the cursor that places, removes and paints the
 * parts of a town, putting parts against walls, laying rivers, undoing the
 * last placement, and the checks for switching between walking and editing.
 */

class CEditMap;
class CMap;
class CScene;
class mgCMemory;
struct EP_PLACE_INFO;

/**
 *
 * Tools of Georama mode, as chosen from the menu and held in EditModeNo.
 *
 */
enum EditModeType {
    EDIT_MODE_NONE = 0,       /**< No tool is in use. */
    EDIT_MODE_PLACE = 2,      /**< Places parts of the chosen definition. */
    EDIT_MODE_REMOVE = 3,     /**< Digs placed parts out of the town with the shovel. */
    EDIT_MODE_PAINT = 8,      /**< Paints placed parts with the chosen paint. */
    EDIT_MODE_REPAINT = 0x10, /**< Returns painted parts to their own colours. */
};

/**
 *
 * Steps of putting a part against the wall of another, as PutSideMode holds them.
 *
 */
enum EditPutSideMode {
    EDIT_PUT_SIDE_OFF = 0,    /**< The part is placed on the ground. */
    EDIT_PUT_SIDE_SELECT = 1, /**< A wall to put the part against is being chosen. */
    EDIT_PUT_SIDE_MOVE = 2,   /**< The part is being moved across the chosen wall. */
};

/**
 *
 * Help lines shown at the bottom of the screen in Georama mode, as EditHelpMesNo holds them.
 *
 */
enum EditHelpMes {
    EDIT_HELP_NONE = -1,          /**< No help line is shown. */
    EDIT_HELP_PLACE = 0,          /**< Place and rotate, with undo when it is available. */
    EDIT_HELP_PLACE_WALL = 1,     /**< Place and switch wall, with undo when it is available. */
    EDIT_HELP_PLACE_MAGNET = 2,   /**< Place, rotate and magnet on or off, with undo when it is available. */
    EDIT_HELP_REMOVE = 3,         /**< Remove. */
    EDIT_HELP_SELECT_WALL = 4,    /**< Choose a wall. */
    EDIT_HELP_PAINT = 5,          /**< Paint a part of one colour, with the paint it costs and the paint held. */
    EDIT_HELP_PAINT_HOUSE = 6,    /**< Paint a house's walls or roof, with the paint it costs and the paint held. */
    EDIT_HELP_PAINT_FENCE = 7,    /**< Paint a fence or the whole fence, with the paint it costs and the paint held. */
    EDIT_HELP_REPAINT = 8,        /**< Return a part of one colour to its own colour. */
    EDIT_HELP_REPAINT_HOUSE = 9,  /**< Return a house's walls or roof to their own colours. */
    EDIT_HELP_REPAINT_FENCE = 10, /**< Return a fence to its own colour. */
    EDIT_HELP_UNDO = 11,          /**< Undo. */
};

/**
 *
 * Record of the last part placed, kept so that the placement can be undone.
 *
 */
struct UNDO_DATA {
    s32           info_id;  /**< Definition ID of the part, or -1 when there is nothing to undo. */
    s32           parts_no; /**< Slot number of the placed part in the edit map, or -1 for a river. */
    s32           unk_8;
    s32           unk_c;
    sceVu0FVECTOR pos; /**< Position the part was placed at. */
    sceVu0FVECTOR rot; /**< Rotation the part was placed with; Y is its turn. */
};

STATIC_ASSERT(sizeof(UNDO_DATA) == 0x30);

/** Position of the part across the wall it is put against: across in X, height in Y. */
extern sceVu0FVECTOR WallPutPos;

/** Wall the part is being put against. */
extern CEditParts::WallInfo WallInfo;

/**
 *
 * Takes the player's control away from Georama mode, once for each
 * call to EditModeControlUnLock.
 *
 * @mangled EditModeControlLock__Fv
 * @address 0x2DD750
 * @size 0x10
 */
void EditModeControlLock();

/**
 *
 * Gives back the player's control of Georama mode taken by one call to
 * EditModeControlLock.
 *
 * @mangled EditModeControlUnLock__Fv
 * @address 0x2DD760
 * @size 0x30
 */
void EditModeControlUnLock();

/**
 *
 * Starts the count of frames that the cursor's parts are animated for
 * before the menu opens.
 *
 * @mangled EditPreMenuAnime__Fi
 * @address 0x2DDB20
 * @size 0x10
 */
void EditPreMenuAnime(int max_count);

/**
 *
 * Loads the Georama mode system texture into a texture block, and the
 * cursor, paint, shovel and removal models.
 *
 * @mangled LoadEditCursor__FP9mgCMemoryi
 * @address 0x2DDB30
 * @size 0x5C0
 */
void LoadEditCursor(mgCMemory *stack, int block);

/**
 *
 * Returns the definition ID of the part chosen for placing, or -1.
 *
 * @mangled GetSelPartsInfoID__Fv
 * @address 0x2DE0F0
 * @size 0x10
 */
int GetSelPartsInfoID();

/**
 *
 * Forgets the last placement, so that there is nothing to undo.
 *
 * @mangled ClearUndoFlag__Fv
 * @address 0x2DE110
 * @size 0x20
 */
void ClearUndoFlag();

/**
 *
 * Clears the chosen part, the wall being put against, the help line and
 * every step in progress of Georama mode.
 *
 * @mangled ClearEditFlag__Fv
 * @address 0x2DE130
 * @size 0x60
 */
void ClearEditFlag();

/**
 *
 * Puts Georama mode in its first state: no tool, the default camera
 * distance, the magnet on and the player's control given.
 *
 * @mangled InitEditFlag__Fv
 * @address 0x2DE190
 * @size 0x50
 */
void InitEditFlag();

/**
 *
 * Enters Georama mode from walking, placing the cursor where the player
 * stands and turning the edit camera to follow it.
 *
 * @mangled StartEditMode__FP6CScene
 * @address 0x2DE1E0
 * @size 0x180
 */
int StartEditMode(CScene *scene);

/**
 *
 * Leaves Georama mode for walking, closing its message and ending the
 * placing animations and effects.
 *
 * @mangled EndEditMode__FP6CScenePf
 * @address 0x2DE360
 * @size 0xB0
 */
void EndEditMode(CScene *scene, float *pos);

/**
 *
 * Starts the tool chosen from the menu, with the part and number to place
 * or the paint colour and paint item to paint with.
 *
 * @mangled StartEditModeFromMenu__FP6CSceneiPi
 * @address 0x2DE410
 * @size 0x250
 */
int StartEditModeFromMenu(CScene *scene, int mode, int *arg);

/**
 *
 * Starts putting the part against a wall, from the middle of the wall.
 *
 * @mangled StartEditPutWall__FPQ210CEditParts8WallInfo
 * @address 0x2DE830
 * @size 0x90
 */
void StartEditPutWall(CEditParts::WallInfo *wall);

/**
 *
 * Places a part of the chosen definition, or a river, records it for
 * undoing and takes it from the parts held; returns zero when no part is
 * chosen.
 *
 * @mangled PlaceEditParts__FP8CEditMapPfPfP13EP_PLACE_INFO
 * @address 0x2DE8C0
 * @size 0x1C0
 */
int PlaceEditParts(CEditMap *map, float *pos, float *rot, EP_PLACE_INFO *place);

/**
 *
 * Starts laying a river at a position, which is placed partway through
 * the shovel's animation.
 *
 * @mangled PlaceRiverStart__FP8CEditMapPf
 * @address 0x2DEA80
 * @size 0x60
 */
void PlaceRiverStart(CEditMap *map, float *pos);

/**
 *
 * Advances the laying of a river by one frame, placing it and showing its
 * effect partway through.
 *
 * @mangled PlaceRiverStep__FP8CEditMap
 * @address 0x2DEAE0
 * @size 0xE0
 */
int PlaceRiverStep(CEditMap *map);

/**
 *
 * Reports whether a river is being laid.
 *
 * @mangled NowPlaceRiver__Fv
 * @address 0x2DEBC0
 * @size 0x10
 */
int NowPlaceRiver();

/**
 *
 * Starts digging out the placed part at a position, which is removed
 * partway through the removal animation.
 *
 * @mangled RemoveMtnStart__FP8CEditMapPfPf
 * @address 0x2DEBD0
 * @size 0x80
 */
void RemoveMtnStart(CEditMap *map, float *pos, float *cursor_pos);

/**
 *
 * Advances the digging out of a part by one frame, removing it partway
 * through.
 *
 * @mangled RemoveMtnStep__FP6CScene
 * @address 0x2DEC50
 * @size 0x110
 */
int RemoveMtnStep(CScene *scene);

/**
 *
 * Removes a placed part and those resting on it, giving back their parts
 * and paint and sending the villagers of removed houses away; returns
 * zero when nothing was removed.
 *
 * @mangled RemoveEditParts__FP6CSceneiPf
 * @address 0x2DED60
 * @size 0x200
 */
int RemoveEditParts(CScene *scene, int parts_index, float *pos);

/**
 *
 * Uses the chosen part on a placed part that it completes: removes the
 * placed part with its effects and takes one chosen part from the parts
 * held; returns zero when nothing was removed.
 *
 * @mangled DeleteKanketuParts__FP6CSceneP8CEditMapPfi
 * @address 0x2DEF60
 * @size 0x2D0
 */
int DeleteKanketuParts(CScene *scene, CEditMap *map, float *pos, int parts_no);

/**
 *
 * Paints one colour of a placed part, or a whole fence when the colour
 * number is 99, with its effect and sound.
 *
 * @mangled PaintEditParts__FP8CEditMapiiPf
 * @address 0x2DF230
 * @size 0x120
 */
int PaintEditParts(CEditMap *map, int parts_no, int color_no, float *color);

/**
 *
 * Runs one frame of Georama mode: moves the cursor and camera and uses
 * the current tool on the part under the cursor.
 *
 * @mangled EditMode__FP6CScene
 * @address 0x2DF4F0
 * @size 0x1DDC
 */
void EditMode(CScene *scene);

/**
 *
 * Draws the part being placed at the cursor, or the paint and removal cursors.
 *
 * @mangled DrawEditCursorParts__FP6CScene
 * @address 0x2E12D0
 * @size 0x360
 */
void DrawEditCursorParts(CScene *scene);

/**
 *
 * Draws the Georama mode cursor and the direction marker when putting a part against a wall.
 *
 * @mangled DrawEditCursor__FP6CScene
 * @address 0x2E1630
 * @size 0x5B0
 */
void DrawEditCursor(CScene *scene);

/**
 *
 * Draws the help line of the current tool in the game's language.
 *
 * @mangled DrawEditHelpMes__Fv
 * @address 0x2E1BE0
 * @size 0x560
 */
void DrawEditHelpMes();

/**
 *
 * Draws the icons for switching between walking and editing when the
 * switch is allowed, and the town's balance gauge while editing.
 *
 * @mangled DrawEditSystem__FiP6CScenePfi
 * @address 0x2E23C0
 * @size 0x450
 */
void DrawEditSystem(int block, CScene *scene, float *pos, int edit);

/**
 *
 * Reports whether the player may enter Georama mode at a position: on
 * ground, with no steep wall close by.
 *
 * @mangled CheckWalkToEdit__FP6CScenePf
 * @address 0x2E29A0
 * @size 0x1D0
 */
int CheckWalkToEdit(CScene *scene, float *pos);

/**
 *
 * Reports whether the player may leave Georama mode at the cursor, which
 * needs walkable ground clear of rivers, and gives the position the player
 * would stand at.
 *
 * @mangled CheckEditToWalk__FP6CScenePf
 * @address 0x2E2B70
 * @size 0x270
 */
int CheckEditToWalk(CScene *scene, float *position);
