#pragma once

#include "common.h"
#include "mainloop.hpp"
#include "savedata.hpp"

/**
 * @file
 * Declares the save data conversion screen, a main-loop mode that renames the North American
 * release's memory card save directories so that this release recognises them.
 */

/**
 *
 * Steps of the conversion screen, as ConvMode holds them.
 *
 */
enum SV_CONV_MODE {
    SV_CONV_MODE_SELECT  = 0, /**< Choosing the memory card slot. */
    SV_CONV_MODE_CONVERT = 2, /**< Running SaveDataConvertLoop each frame. */
    SV_CONV_MODE_RESULT  = 3, /**< Showing the outcome until the player returns to slot selection. */
};

/**
 *
 * Phases of SaveDataConvertLoop, as ConvertPhase holds them.
 *
 */
enum SAVEDATA_CONVERT_PHASE {
    SAVEDATA_CONVERT_PHASE_CHECK_CARD = 0, /**< Checking that a formatted PS2 memory card is in the slot. */
    SAVEDATA_CONVERT_PHASE_READ_DIR   = 1, /**< Listing the North American release's save directories. */
    SAVEDATA_CONVERT_PHASE_CONVERT    = 2, /**< Renaming each listed directory. */
    SAVEDATA_CONVERT_PHASE_END        = 3, /**< Conversion has finished. */
};

/**
 *
 * Outcome of a conversion, as ConvertResult holds it.
 *
 */
enum SAVEDATA_CONVERT_RESULT {
    SAVEDATA_CONVERT_RESULT_NONE       = 0,   /**< No conversion has finished yet. */
    SAVEDATA_CONVERT_RESULT_DONE       = 1,   /**< Every listed directory was processed. */
    SAVEDATA_CONVERT_RESULT_CARD_ERROR = 100, /**< The memory card could not be accessed. */
    SAVEDATA_CONVERT_RESULT_NO_FILES   = 101, /**< The card holds no saves to convert. */
};

/**
 *
 * Kinds of save directory that the conversion recognises from the directory name's suffix.
 *
 */
enum SAVEDATA_CONVERT_TYPE {
    SAVEDATA_CONVERT_TYPE_NONE  = -1, /**< Not a directory the conversion handles. */
    SAVEDATA_CONVERT_TYPE_GAME  = 0,  /**< Numbered game save, suffixed "dkcl". */
    SAVEDATA_CONVERT_TYPE_ALBUM = 1,  /**< Photo album save, suffixed "dc2album". */
    SAVEDATA_CONVERT_TYPE_OMAKE = 2,  /**< Bonus data save, suffixed "dc2omake". */
};

/**
 *
 * One memory card directory entry copied while searching for save files.
 *
 */
struct SAVE_CONVERT_FILE_INFO {
    char unk_0[0x20];
    char entry_name[0x20]; /**< Directory name returned by the memory card library. */
};
STATIC_ASSERT(sizeof(SAVE_CONVERT_FILE_INFO) == 0x40);

/**
 *
 * Work allocation holding one save image during directory conversion.
 *
 */
struct SAVE_CONVERT_WORK {
    u8 unk_0[0x80];
    CSaveData save_data; /**< Save image whose embedded objects are constructed for conversion. */
    u8 unk_659b0[0x10];
};
STATIC_ASSERT(sizeof(SAVE_CONVERT_WORK) == 0x659C0);

/**
 * Prepares the conversion screen when the main loop enters it: sets up the drawing buffers,
 * the font textures, the memory card library and the save file table.
 *
 * @mangled SVConvViewInit__F13INIT_LOOP_ARG
 * @address 0x324AC0
 * @size 0x370
 */
void SVConvViewInit(INIT_LOOP_ARG arg);

/**
 * Releases the conversion screen when the main loop leaves it, closing the memory card
 * library and the font and stopping every sound effect.
 *
 * @mangled SVConvViewExit__Fv
 * @address 0x324E30
 * @size 0x50
 */
void SVConvViewExit();

/**
 * Runs one frame of the conversion screen, handling input and drawing its text, and returns 1
 * when the player leaves the screen.
 *
 * @mangled SVConvViewLoop__Fv
 * @address 0x324E80
 * @size 0x530
 */
int SVConvViewLoop();

/**
 * Advances the save data conversion by one phase on the selected memory card, and returns 1
 * once the conversion has finished or failed.
 *
 * @mangled SaveDataConvertLoop__Fv
 * @address 0x325480
 * @size 0x800
 */
int SaveDataConvertLoop();
