#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_memory.hpp"

/**
 * @file
 * Declares the event editor, a developer tool for placing the event camera and characters,
 * recording camera and character paths and writing the results to a host file as script lines.
 */

/**
 *
 * Pages of the event editor, cycled through with the select button.
 *
 */
enum EVENT_EDIT_MODE {
    EVENT_EDIT_MODE_CAMERA_MOVE = 0, /**< Free camera movement and projection adjustment ("CAMERA MOVE"). */
    EVENT_EDIT_MODE_CHARACTER = 1,   /**< Choosing and moving an event character ("CHARACTER"). */
    EVENT_EDIT_MODE_CAMERA_PAS = 2,  /**< Recording and playing back a camera path ("CAMERA PAS"). */
    EVENT_EDIT_MODE_CHARA_PAS = 3,   /**< Recording and playing back a character path ("CHARA PAS"). */
    EVENT_EDIT_MODE_COUNT = 4,       /**< Number of event editor pages. */
};

/**
 *
 * Operations the confirm button applies to the selected point of a camera or character path.
 *
 */
enum EVENT_EDIT_PAS_OP {
    EVENT_EDIT_PAS_OP_ADDITION = 0,  /**< Appends the current position as a new last point ("Addition"). */
    EVENT_EDIT_PAS_OP_INSERT = 1,    /**< Inserts the current position before the selected point ("Insert"). */
    EVENT_EDIT_PAS_OP_OVERWRITE = 2, /**< Replaces the selected point with the current position ("OverWrite"). */
    EVENT_EDIT_PAS_OP_DELETE = 3,    /**< Removes the selected point ("Delete"). */
    EVENT_EDIT_PAS_OP_COUNT = 4,     /**< Number of path operations. */
};

/**
 *
 * Rows of the path pages of the event editor that the cursor moves between.
 *
 */
enum EVENT_EDIT_PAS_ITEM {
    EVENT_EDIT_PAS_ITEM_EDIT_MODE = 0, /**< Chooses the path operation ("EditMode"). */
    EVENT_EDIT_PAS_ITEM_SELECT_NO = 1, /**< Chooses the path point operated on ("SelectNo"). */
    EVENT_EDIT_PAS_ITEM_FRAME = 2,     /**< Sets the number of frames the path takes to play ("Frame"). */
    EVENT_EDIT_PAS_ITEM_COUNT = 3,     /**< Number of rows on a path page. */
};

/**
 *
 * State of the event editor: whether it is open, the page shown, the character being edited
 * and the camera to restore when it closes.
 *
 */
struct EventEditInfo {
    int           active;    /**< Non-zero while the event editor is open. */
    int           mode;      /**< Page shown, an EVENT_EDIT_MODE. */
    int           disp;      /**< Non-zero to draw the editor's panel and the event marker. */
    mgCMemory    *memory;    /**< Work buffer whose stack is released when the editor closes. */
    int           texb;      /**< Texture bank the debug font is loaded into. */
    int           chara_no;  /**< Number of the event character being edited. */
    int           collision; /**< Non-zero to keep the edited character on the ground below it while moving. */
    int           unk_1C;
    sceVu0FVECTOR camera_pos; /**< Camera position when the editor opened, restored on close. */
    sceVu0FVECTOR camera_ref; /**< Camera reference point when the editor opened, restored on close. */
};

STATIC_ASSERT(sizeof(EventEditInfo) == 0x40);

/**
 *
 * Prepares the event editor to start closed and shown, remembering the
 * texture bank for its font and the work buffer it releases on closing.
 *
 * @mangled InitEventEdit__FiP9mgCMemory
 * @address 0x282FA0
 * @size 0x40
 */
void InitEventEdit(int font_id, mgCMemory *memory);

/**
 *
 * Opens the event editor when debugging is on and the left stick is
 * pressed, giving 1 when it opened and 0 otherwise.
 *
 * @mangled ChkEventEditStart__Fv
 * @address 0x282FE0
 * @size 0x110
 */
int ChkEventEditStart();

/**
 *
 * Runs one frame of the event editor, acting on the pad for the current page,
 * and gives 1 while the editor is open and 0 once it is closed.
 *
 * @mangled EventEdit__FP9mgCMemory
 * @address 0x2830F0
 * @size 0xCF0
 */
int EventEdit(mgCMemory *memory);

/**
 *
 * Draws the event marker and, while the event editor is open, its panel
 * for the current page and boxes marking the edited points.
 *
 * @mangled DrawEventEdit__Fv
 * @address 0x283DE0
 * @size 0x12D0
 */
void DrawEventEdit();
