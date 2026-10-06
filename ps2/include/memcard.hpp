#pragma once

#include "common.h"

#include <libmc.h>

#include "savedata.hpp"

/**
 * @file
 * Declares the memory card manager that saves and loads the game, the photo album and the bonus (omake) data, the
 * records it keeps about each card and save file, and the save file image it writes.
 */

class mgCMemory;

/**
 *
 * Operations CMemoryCardManager::Step runs, as CMemoryCardManager::func_no holds them.
 *
 */
// clang-format off
enum MC_FUNC_NO {
    MC_FUNC_SEARCH_TYPE        = 0,  /**< Reads the type, free space and format of the card once. */
    MC_FUNC_IDLE               = 1,  /**< Rereads the card every ten frames. */
    MC_FUNC_NONE               = 2,  /**< Finishes at once. */
    MC_FUNC_MAKE_DIR           = 3,  /**< Creates the directory of the save file being worked on. */
    MC_FUNC_GET_ALL_FILE_INFO  = 5,  /**< Reads the header of every save file of the card. */
    MC_FUNC_SAVE               = 6,  /**< Writes the game to the save file being worked on. */
    MC_FUNC_LOAD               = 7,  /**< Reads the game from the save file being worked on. */
    MC_FUNC_DELETE             = 8,  /**< Deletes a save file. */
    MC_FUNC_FORMAT             = 10, /**< Formats the card. */
    MC_FUNC_UNFORMAT           = 11, /**< Unformats the card. */
    MC_FUNC_WRITE_TEST         = 13, /**< Writes a large test file to the card. */
    MC_FUNC_SAVE_ALBUM         = 16, /**< Writes the photo album. */
    MC_FUNC_LOAD_ALBUM         = 17, /**< Reads the photo album. */
    MC_FUNC_CHECK_ALBUM        = 18, /**< Looks for the photo album on the card. */
    MC_FUNC_MAKE_ALBUM_DIR     = 19, /**< Creates the photo album directory. */
    MC_FUNC_SAVE_OMAKE         = 20, /**< Writes the bonus data. */
    MC_FUNC_LOAD_OMAKE         = 21, /**< Reads the bonus data. */
    MC_FUNC_CHECK_OMAKE        = 22, /**< Looks for the bonus data on the card. */
    MC_FUNC_MAKE_OMAKE_DIR     = 23, /**< Creates the bonus data directory. */
    MC_FUNC_CONVERT            = 24, /**< Converts old save data; finishes at once. */
};
// clang-format on

/**
 *
 * What one step of a CMemoryCardManager operation reports.
 *
 */
// clang-format off
enum MC_STEP_RESULT {
    MC_STEP_FAILED = -1, /**< The operation stopped on an error. */
    MC_STEP_BUSY   = 0,  /**< The operation is still running. */
    MC_STEP_DONE   = 1,  /**< The operation has finished. */
};
// clang-format on

/**
 *
 * Errors MC_ERROR_INFO::code records.
 *
 */
// clang-format off
enum MC_ERROR_CODE {
    MC_ERROR_NONE        = 0,  /**< No error. */
    MC_ERROR_LOAD        = 2,  /**< A save could not be read, or its version or checksums do not match. */
    MC_ERROR_BROKEN      = 3,  /**< A file is shorter than it should be or fails its checksum. */
    MC_ERROR_FULL        = 4,  /**< The card is full. */
    MC_ERROR_FILE        = 6,  /**< A file is missing or the wrong size, or the card was lost during a save. */
    MC_ERROR_UNFORMATTED = 7,  /**< The card is unformatted. */
    MC_ERROR_NO_CARD     = 8,  /**< The card could not be found. */
    MC_ERROR_COMMAND     = 11, /**< A memory card library command could not be started. */
};
// clang-format on

/**
 *
 * Kinds of size CMemoryCardManager::GetSaveDataSize returns.
 *
 */
// clang-format off
enum MC_DATA_SIZE_TYPE {
    MC_SIZE_SAVE_TOTAL  = 0, /**< Bytes a save directory takes, icons included. */
    MC_SIZE_SAVE_FILE   = 1, /**< Bytes of one save file. */
    MC_SIZE_ALBUM_FILE  = 2, /**< Bytes of the photo album file. */
    MC_SIZE_ICONS       = 3, /**< Bytes the icons and icon.sys take. */
    MC_SIZE_ALBUM_TOTAL = 4, /**< Bytes the photo album directory takes, icons included. */
    MC_SIZE_SAVE_KB     = 5, /**< Kilobytes a save directory takes, icons included. */
    MC_SIZE_UNK_6       = 6,
    MC_SIZE_OMAKE_FILE  = 7, /**< Bytes of the bonus data file. */
    MC_SIZE_OMAKE_TOTAL = 8, /**< Bytes the bonus data directory takes, icons included. */
    MC_SIZE_OMAKE_KB    = 9, /**< Kilobytes the bonus data directory takes, icons included. */
};
// clang-format on

/**
 *
 * Describes one memory card icon resource used by a save file.
 *
 */
struct MC_ICON_DATA {
    char  name[0x20]; /**< Name of the icon resource in the save archive. */
    void *data;       /**< Loaded icon resource data. */
    int   size;       /**< Size of the loaded icon resource. */
};

STATIC_ASSERT(sizeof(MC_ICON_DATA) == 0x28);

/**
 *
 * Holds what the manager found out about the card in one port.
 *
 */
struct MC_CARD_INFO {
    s32 present;       /**< One while the card answers; cleared when a command reports the card lost. */
    s32 type;          /**< Card type that sceMcGetInfo writes; 2 is a PlayStation 2 memory card. */
    s32 formatted;     /**< Format flag that sceMcGetInfo writes. */
    s32 format_change; /**< 1 once a search finds the card newly formatted, -1 once it finds it unformatted. */
    u8  unk_10[4];
    s32 free_size; /**< Free space, in kilobytes, that sceMcGetInfo writes. */
    u8  unk_18[4];
    s32 result; /**< Result of the last sceMcGetInfo on the card. */
};

STATIC_ASSERT(sizeof(MC_CARD_INFO) == 0x20);

/**
 *
 * One entry that sceMcGetDir writes into CMemoryCardManager::dir_table.
 *
 */
struct MC_DIR_ENTRY {
    u8   unk_00[0x10];
    u32  file_size; /**< Size of the file in bytes. */
    u8   unk_14[0xC];
    char name[0x20]; /**< Name of the file or directory. */
};

STATIC_ASSERT(sizeof(MC_DIR_ENTRY) == 0x40);

/**
 *
 * Records what stopped the last memory card operation.
 *
 */
struct MC_ERROR_INFO {
    s32 code;        /**< Kind of error that stopped the last operation. @see MC_ERROR_CODE. */
    s32 func_no;     /**< Operation that the manager was running when the error came. @see MC_FUNC_NO. */
    s32 file_no;     /**< Save file that the manager was working on when the error came. */
    s32 step;        /**< Step that the operation had reached when the error came. */
    s32 retry_count; /**< Failed polls of the current delete, which stop it after 120. */
};

STATIC_ASSERT(sizeof(MC_ERROR_INFO) == 0x14);

/**
 *
 * Describes one save file of the card to the save and load menus.
 *
 */
struct SAVEDATA_INFO {
    s32 state;           /**< One once the file is read, complete and of the current version, zero otherwise. */
    s32 file_no;         /**< Number of the save file. */
    s16 map_no;          /**< Main map the save was written on. */
    s16 dungeon_no;      /**< Dungeon the save was written in. */
    s16 floor_id;        /**< Floor of that dungeon the save was written on. */
    s16 progress;        /**< Story progress of the save. */
    u8  unk_10[2];
    s16 program_loop_no; /**< Main loop mode the save was written in. @see MainLoopMode. */
    u32 omake_flag;      /**< Bonus content the save unlocks, as SAVEDATA_FORMAT::omake_flag holds it. */
    s16 debug_code;      /**< Debug code of the save; above zero turns the debug mode on. */
    u8  unk_1A[6];
    u64 costume_bit;    /**< Costumes the save has collected, one bit for each COSBIT_INFO entry. */
    u64 play_time;      /**< Play time of the save, in frames. */
    u64 unique_counter; /**< Number that grows with every save, marking the newest save of the card. */
    s32 fish_num;       /**< Fish the save has caught. */
    u8  unk_3C[4];
};

STATIC_ASSERT(sizeof(SAVEDATA_INFO) == 0x40);

/**
 *
 * The image of one save file: a header that the load menu reads, followed by the save data itself.
 *
 */
struct SAVEDATA_FORMAT {
    char      version[0x10];   /**< Version string that the file starts with. */
    u64       costume_bit;     /**< Costumes the save has collected, once the costume flag is set. */
    s16       debug_code;      /**< Debug code of the save. */
    s16       unk_1A;
    s32       unk_1C;
    s32       unk_20;
    s32       unk_24;
    s32       check_digit_half; /**< Checksum of the first half of the save data. */
    s32       check_digit;      /**< Checksum of the whole save data. */
    s32       map_no;           /**< Main map the save was written on. */
    s32       program_loop_no;  /**< Main loop mode the save was written in. @see MainLoopMode. */
    s32       dungeon_no;       /**< Dungeon the save was written in. */
    s32       floor_id;         /**< Floor of that dungeon the save was written on. */
    s32       progress;         /**< Story progress of the save. */
    s8        dng_tree_flag;    /**< Dungeon tree flag at the time of the save. */
    u8        incomplete;       /**< One while the file is being written; a file with it set is not shown. */
    u8        omake_flag;       /**< Bonus content the save unlocks. */
    u8        unk_47;
    s32       fish_num; /**< Fish the save has caught. */
    s32       unk_4C[11];
    u64       unique_counter; /**< Number that grows with every save, marking the newest save of the card. */
    CSaveData save_data;      /**< The save data. */
    u8        unk_659B0[0x10];
};

STATIC_ASSERT(sizeof(SAVEDATA_FORMAT) == 0x659C0);

/**
 *
 * One entry of the costume table: an item and the bit of the costume flags that records it.
 *
 */
struct COSBIT_INFO {
    s16 item_no; /**< Costume item. */
    s8  bit_no;  /**< Bit of the costume flags that records the costume. */
    u8  unk_03;
};

STATIC_ASSERT(sizeof(COSBIT_INFO) == 0x4);

/**
 *
 * Runs the memory card operations of the game one step at a time: saves, loads, the photo album and the bonus
 * data.
 *
 */
class CMemoryCardManager {
public:
    char             version[0x10];     /**< Version string that every save file starts with. */
    char             file_name[0x20];   /**< Name format of the save files. */
    char             game_name[0x20];   /**< Name of the game. */
    s32              func_no;           /**< Operation that the manager is running. @see MC_FUNC_NO. */
    u8               unk_54[4];
    s32              step;              /**< Step that the current operation has reached. */
    s32              fd;                /**< File that the last sceMcOpen returned, -1 until one does. */
    u8               unk_60[0x20];
    MC_DIR_ENTRY     dir_table[17];     /**< Table that sceMcGetDir fills with directory entries. */
    s32              dir_entries;       /**< Entries the last sceMcGetDir found, or the error it reported. */
    s32              album_buffer_set;  /**< One once SetBuff_Album has been given an album buffer. */
    s32              port;              /**< Port that every command of the manager names. */
    s32              file_no;           /**< Save file that the current operation works on. */
    MC_ERROR_INFO    error;             /**< What stopped the last operation. */
    char            *write_buffer;      /**< Data the current write sends. */
    char            *read_buffer;       /**< Area the current read fills. */
    char             work_buffer[0x400]; /**< Area that the header of the bonus data file is read into. */
    SAVEDATA_FORMAT *save_buffer;       /**< Save file image that saves and loads go through. */
    CSubGameData    *sub_game_data;     /**< Bonus data that the save menu hands the manager. */
    char            *album_buffer;      /**< Photo album image that album saves and loads go through. */
    s32              load_map_no;       /**< Main map of the save last loaded. */
    s32              load_program_loop_no; /**< Main loop mode of the save last loaded. @see MainLoopMode. */
    s32              load_dungeon_no;   /**< Dungeon of the save last loaded. */
    s32              load_floor_id;     /**< Dungeon floor of the save last loaded. */
    s32              load_dng_tree_flag; /**< Dungeon tree flag of the save last loaded. */
    s32              search_wait;       /**< Frames the idle operation has waited since it last read the card. */
    s32              transferred;       /**< Bytes that the current read or write has moved. */
    s32              total_transferred; /**< Bytes that the current operation has moved, for its progress bar. */
    s32              transfer_size;     /**< Bytes that the current read or write is to move. */
    s32              transfer_result;   /**< Result of the last read or write command. */
    MC_ICON_DATA     icon[3];           /**< Icon files that the save directories carry. */
    sceMcIconSys     icon_sys;          /**< icon.sys image that MakeDir writes into a new directory. */
    MC_CARD_INFO     card[2];           /**< What the manager found out about the card in each port. */
    u8               unk_D9C[4];
    SAVEDATA_INFO    file_info[13];     /**< Save files of the card, as the menus show them. */
    s32              file_exists;       /**< Whether the last album or bonus data check found the file. */
    u32              omake_flag;        /**< Bonus content that the bonus data file unlocks. */
    u8               unk_10E8[0x18];

    /**
     *
     * Fills the manager with its starting values.
     *
     * @mangled __ct__18CMemoryCardManagerFv
     * @address 0x2F6690
     * @size 0x30
     */
    CMemoryCardManager();

    /**
     *
     * Fills the manager with its starting values and, given a heap, builds its save file image there.
     *
     * @mangled Initialize__18CMemoryCardManagerFP9mgCMemory
     * @address 0x2F66C0
     * @size 0x1B0
     */
    void Initialize(mgCMemory *memory);

    /**
     *
     * Clears the directory table.
     *
     * @mangled InitSaveFileInfoTable__18CMemoryCardManagerFv
     * @address 0x2F6870
     * @size 0x70
     */
    void InitSaveFileInfoTable();

    /**
     *
     * Returns one when the directory table holds an entry of the given name.
     *
     * @mangled GetOpenAttribute__18CMemoryCardManagerFPc
     * @address 0x2F68E0
     * @size 0x80
     */
    int GetOpenAttribute(char *name);

    /**
     *
     * Clears the record of the last error.
     *
     * @mangled InitError__18CMemoryCardManagerFv
     * @address 0x2F6960
     * @size 0x10
     */
    void InitError();

    /**
     *
     * Starts the memory card library, and returns one if it fails to start.
     *
     * @mangled InitForMC__18CMemoryCardManagerFv
     * @address 0x2F6970
     * @size 0x60
     */
    int InitForMC();

    /**
     *
     * Releases what the memory card library holds, and returns one.
     *
     * @mangled FinishForMC__18CMemoryCardManagerFv
     * @address 0x2F69D0
     * @size 0x10
     */
    void FinishForMC();

    /**
     *
     * Sets the buffer that the photo album is saved from and loaded into, and clears it.
     *
     * @mangled SetBuff_Album__18CMemoryCardManagerFPc
     * @address 0x2F69E0
     * @size 0x50
     */
    void SetBuff_Album(char *buffer);

    /**
     *
     * Sets the icon files of the save directories and fills the icon.sys image with the browser title of the given
     * kind.
     *
     * @mangled SetIconData__18CMemoryCardManagerFP12MC_ICON_DATAi
     * @address 0x2F6A30
     * @size 0x190
     */
    void SetIconData(MC_ICON_DATA *icon_data, int name_no);

    /**
     *
     * Returns how many kilobytes the icon files and icon.sys take.
     *
     * @mangled GetIconDataSize__18CMemoryCardManagerFv
     * @address 0x2F6BC0
     * @size 0x60
     */
    int GetIconDataSize();

    /**
     *
     * Returns a size of the save, photo album or bonus data. @see MC_DATA_SIZE_TYPE.
     *
     * @mangled GetSaveDataSize__18CMemoryCardManagerFi
     * @address 0x2F6C20
     * @size 0x110
     */
    int GetSaveDataSize(int type);

    /**
     *
     * Starts the given operation from its first step. @see MC_FUNC_NO.
     *
     * @mangled SetFuncNo__18CMemoryCardManagerFi
     * @address 0x2F6D30
     * @size 0x20
     */
    void SetFuncNo(int func_no);

    /**
     *
     * Returns the operation that the manager is running. @see MC_FUNC_NO.
     *
     * @mangled GetFuncNo__18CMemoryCardManagerFv
     * @address 0x2F6D50
     * @size 0x10
     */
    int GetFuncNo();

    /**
     *
     * Returns the highest save counter among the save files of the card.
     *
     * @mangled CheckMaxUniqueCounter__18CMemoryCardManagerFv
     * @address 0x2F6D60
     * @size 0x40
     */
    u_long CheckMaxUniqueCounter();

    /**
     *
     * Returns the save file written last, or -1.
     *
     * @mangled GetUpdateFile__18CMemoryCardManagerFv
     * @address 0x2F6DA0
     * @size 0x60
     */
    int GetUpdateFile();

    /**
     *
     * Returns how many save files of the card are valid.
     *
     * @mangled CheckDataFileNum__18CMemoryCardManagerFv
     * @address 0x2F6E00
     * @size 0x40
     */
    int CheckDataFileNum();

    /**
     *
     * Returns the bonus content that the valid save files unlock, and adds their costumes to the given flags.
     *
     * @mangled CheckOmake__18CMemoryCardManagerFPUl
     * @address 0x2F6E40
     * @size 0x70
     */
    u32 CheckOmake(u_long *costume_bit);

    /**
     *
     * Returns the debug code of the valid save files, or zero.
     *
     * @mangled CheckDebugCode__18CMemoryCardManagerFv
     * @address 0x2F6EB0
     * @size 0x50
     */
    int CheckDebugCode();

    /**
     *
     * Marks every save file of the table as not valid.
     *
     * @mangled InitPlayDataInfo__18CMemoryCardManagerFv
     * @address 0x2F6F00
     * @size 0x70
     */
    void InitPlayDataInfo();

    /**
     *
     * Fills a save file's menu record from the header of its save file image.
     *
     * @mangled UpDateViewInfo__18CMemoryCardManagerFP13SAVEDATA_INFOP15SAVEDATA_FORMAT
     * @address 0x2F6F70
     * @size 0x80
     */
    void UpDateViewInfo(SAVEDATA_INFO *info, SAVEDATA_FORMAT *format);

    /**
     *
     * Runs one step of the current operation, and returns non-zero when the operation has changed.
     *
     * @mangled Step__18CMemoryCardManagerFv
     * @address 0x2F6FF0
     * @size 0x240
     */
    int Step();

    /**
     *
     * Returns the version string that every save file starts with.
     *
     * @mangled GetVersion__18CMemoryCardManagerFv
     * @address 0x2F7230
     * @size 0x10
     */
    char *GetVersion();

    /**
     *
     * Reads the type, the free space and the format of the card in the current port. @see MC_STEP_RESULT.
     *
     * @mangled SearchMcType__18CMemoryCardManagerFv
     * @address 0x2F7240
     * @size 0x260
     */
    int SearchMcType();

    /**
     *
     * Writes a test file of 0x758000 bytes into the root directory of the card. @see MC_STEP_RESULT.
     *
     * @mangled Write__18CMemoryCardManagerFv
     * @address 0x2F74A0
     * @size 0x100
     */
    int Write();

    /**
     *
     * Converts old save data; does nothing and finishes at once. @see MC_STEP_RESULT.
     *
     * @mangled Convert__18CMemoryCardManagerFv
     * @address 0x2F75A0
     * @size 0x10
     */
    int Convert();

    /**
     *
     * Creates the directory of a save file, or of the photo album (-1) or the bonus data (-2), and writes icon.sys
     * and the icon files into it. @see MC_STEP_RESULT.
     *
     * @mangled MakeDir__18CMemoryCardManagerFi
     * @address 0x2F75B0
     * @size 0x5D0
     */
    int MakeDir(int file_no);

    /**
     *
     * Builds the save file image from the save data and writes it to the given save file. @see MC_STEP_RESULT.
     *
     * @mangled SaveToMc__18CMemoryCardManagerFi
     * @address 0x2F7C50
     * @size 0x680
     */
    int SaveToMc(int file_no);

    /**
     *
     * Reads the given save file and, when its version and checksums match, copies it into the save data.
     * @see MC_STEP_RESULT.
     *
     * @mangled LoadFromMc__18CMemoryCardManagerFi
     * @address 0x2F82D0
     * @size 0x470
     */
    int LoadFromMc(int file_no);

    /**
     *
     * Writes the photo album with its checksums. @see MC_STEP_RESULT.
     *
     * @mangled SaveAlbum__18CMemoryCardManagerFv
     * @address 0x2F8740
     * @size 0x310
     */
    int SaveAlbum();

    /**
     *
     * Reads the photo album and checks its checksum. @see MC_STEP_RESULT.
     *
     * @mangled LoadAlbum__18CMemoryCardManagerFv
     * @address 0x2F8A50
     * @size 0x2D0
     */
    int LoadAlbum();

    /**
     *
     * Looks for the photo album on the card and checks its size. @see MC_STEP_RESULT.
     *
     * @mangled CheckAlbum__18CMemoryCardManagerFv
     * @address 0x2F8D20
     * @size 0x1A0
     */
    int CheckAlbum();

    /**
     *
     * Checks the bonus data directory's icon and writes the bonus data. @see MC_STEP_RESULT.
     *
     * @mangled SaveOamkeFile__18CMemoryCardManagerFv
     * @address 0x2F8EC0
     * @size 0x500
     */
    int SaveOamkeFile();

    /**
     *
     * Reads the bonus data. @see MC_STEP_RESULT.
     *
     * @mangled LoadOmakeFile__18CMemoryCardManagerFv
     * @address 0x2F93C0
     * @size 0x2C0
     */
    int LoadOmakeFile();

    /**
     *
     * Looks for the bonus data on the card and reads the bonus content it unlocks. @see MC_STEP_RESULT.
     *
     * @mangled CheckOmakeFile__18CMemoryCardManagerFv
     * @address 0x2F9680
     * @size 0x310
     */
    int CheckOmakeFile();

    /**
     *
     * Formats the card in the current port and rereads its state. @see MC_STEP_RESULT.
     *
     * @mangled Format__18CMemoryCardManagerFv
     * @address 0x2F9990
     * @size 0x190
     */
    int Format();

    /**
     *
     * Deletes the given save file. @see MC_STEP_RESULT.
     *
     * @mangled DeleteFile__18CMemoryCardManagerFi
     * @address 0x2F9B20
     * @size 0x130
     */
    int DeleteFile(int file_no);

    /**
     *
     * Records the kind of the given library error and the operation, file and step that it stopped, and returns
     * one.
     *
     * @mangled McError__18CMemoryCardManagerFi
     * @address 0x2F9C50
     * @size 0x100
     */
    int McError(int result);

    /**
     *
     * Unformats the card in the current port. @see MC_STEP_RESULT.
     *
     * @mangled UnFormat__18CMemoryCardManagerFv
     * @address 0x2F9D50
     * @size 0xD0
     */
    int UnFormat();

    /**
     *
     * Runs one step of reading the header of the given save file into its menu record, advancing the given step.
     *
     * @mangled GetSaveFileInfoFromMc__18CMemoryCardManagerFiPi
     * @address 0x2F9E20
     * @size 0x3D0
     */
    int GetSaveFileInfoFromMc(int file_no, int *step);

    /**
     *
     * Reads the save directory listing and then the header of every save file of the card. @see MC_STEP_RESULT.
     *
     * @mangled GetAllSaveFileInfo__18CMemoryCardManagerFv
     * @address 0x2FA1F0
     * @size 0x250
     */
    int GetAllSaveFileInfo();
};

STATIC_ASSERT(sizeof(CMemoryCardManager) == 0x1100);

/**
 *
 * Copies one of the memory card browser titles, in the current language, and returns where it went.
 *
 * @mangled CopyMCBrowserName__FiPcPUs
 * @address 0x2F6390
 * @size 0xC0
 */
void CopyMCBrowserName(int name_no, char *dest, unsigned short *nl_offset);

/**
 *
 * Sets the dungeon tree flag that the next save records.
 *
 * @mangled SetDngTreeFlag__Fi
 * @address 0x2F6450
 * @size 0x10
 */
void SetDngTreeFlag(int flag);

/**
 *
 * Lists the costumes of the given item type that the given costume flags hold, ending the list with -1, and
 * returns how many it found.
 *
 * @mangled GetCostumeList__FUliPs
 * @address 0x2F7B80
 * @size 0xD0
 */
int GetCostumeList(u_long costume_bit, int type, short *list);

/**
 *
 * Returns one when a card is present in the port and is a PlayStation 2 memory card.
 *
 * @mangled McCheckMCPs2__FP12MC_CARD_INFO
 * @address 0x2FA440
 * @size 0x40
 */
int McCheckMCPs2(MC_CARD_INFO *card);

/**
 *
 * Returns one when the card is a PlayStation 2 memory card that is unformatted or has more than the given free
 * space.
 *
 * @mangled McCheckMCPs2Boot__FP12MC_CARD_INFOi
 * @address 0x2FA480
 * @size 0x70
 */
int McCheckMCPs2Boot(MC_CARD_INFO *card, int size);

/**
 *
 * Returns the costume table entry of the given item, or null when the item is not a costume.
 *
 * @mangled GetCosInfo__Fi
 * @address 0x2FA4F0
 * @size 0x40
 */
COSBIT_INFO *GetCosInfo(int item_no);

/**
 *
 * Main loop mode that the game is in, recorded in every save.
 *
 */
extern s16 NowProgramLoopNo;

/**
 *
 * Buffer that the bonus data directory's icon is read into to check it before a bonus data save.
 *
 */
extern char *SubGameOmakeTempBuffer;
