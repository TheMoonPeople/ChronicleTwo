#include "common.h"

#include <libmc.h>

#include <charconv>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "convviewlp.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "gamepad.hpp"
#include "log/game_output.hpp"
#include "memory/tracked_copy.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "text/bounded.hpp"

std::optional<int> dc2::video::ParseConvertedSaveIndex(std::string_view entry_name) {
    if (entry_name.size() <= 16) {
        return std::nullopt;
    }
    const auto suffix = entry_name.substr(16);
    int        number = 0;
    const auto [end, error] = std::from_chars(suffix.data(), suffix.data() + suffix.size(), number);
    if (error != std::errc{} || end != suffix.data() + suffix.size()) {
        return std::nullopt;
    }
    return number;
}

/**
 *
 * Display-time value recorded for the conversion result.
 *
 */
static int ConvertResultDispTime;
/**
 *
 * Texture and data storage used by the conversion screen.
 *
 */
static mgCMemory DataBuffer;
/**
 *
 * Read buffer backed by the remaining main-stack storage.
 *
 */
static mgCMemory Stack_ReadBuff;

/**
 *
 * Scene used by the save-data conversion screen.
 *
 */
static CScene *MovieScene;

/**
 *
 * Current mode of the save-data conversion screen.
 *
 */
static SV_CONV_MODE ConvMode;

/**
 *
 * Selected memory-card port.
 *
 */
static int SlotSelect;

/**
 *
 * Number of source save directories in the conversion list.
 *
 */
static int FileListNum;

/**
 *
 * Current phase of memory-card checking and conversion.
 *
 */
static SAVEDATA_CONVERT_PHASE ConvertPhase;

/**
 *
 * Number of directories converted in the current run.
 *
 */
static int ConvertFileNum;

/**
 *
 * Result reported by the save-data conversion run.
 *
 */
static SAVEDATA_CONVERT_RESULT ConvertResult;

/**
 *
 * Directory records for the source save files.
 *
 */
static sceMcTblGetDir *SaveFileInfoTablePtr;

/**
 *
 * Allocated work image for converting saved game data.
 *
 */
static SAVE_CONVERT_WORK *SAVEDATA_BUFFER;

/**
 *
 * Per-file size information for the conversion list.
 *
 */
static int SaveFileInfoTableSizeConvert[128];

static void InitSaveFileInfoTablePtr();

void SVConvViewInit(INIT_LOOP_ARG arg) {
    MovieScene = GetMainScene();
    MovieScene->Initialize();
    mgInitFont();
    mgCMemory *main_stack = GetMainStack();
    main_stack->stReset();

    /**
     *
     * First packet buffer for the conversion screen.
     *
     */
    static mgCMemory buf0;

    /**
     *
     * Second packet buffer for the conversion screen.
     *
     */
    static mgCMemory buf1;

    /**
     *
     * First data buffer for the conversion screen.
     *
     */
    static mgCMemory dbuf0;

    /**
     *
     * Second data buffer for the conversion screen.
     *
     */
    static mgCMemory dbuf1;

    u_long128 *vif0 = main_stack->stAlloc64(10000);
    u_long128 *vif1 = main_stack->stAlloc64(10000);
    mgInitVif1Packet(vif0, vif1, 160000);
    buf0.stSetChildBuffer(*main_stack, main_stack->stAlloc64(30000), 30000);
    buf1.stSetChildBuffer(*main_stack, main_stack->stAlloc64(30000), 30000);
    dbuf0.stSetChildBuffer(*main_stack, main_stack->stAlloc64(60000), 60000);
    dbuf1.stSetChildBuffer(*main_stack, main_stack->stAlloc64(60000), 60000);
    DataBuffer.stSetChildBuffer(*main_stack, main_stack->stAlloc64(100000), 100000);
    mgSetPacketBuffer(&buf0, &buf1);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetTextureTable(100, 20, &DataBuffer);
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 0, nullptr, nullptr);
    ReLoadFontTexture(0);
    sceMcInit();
    main_stack->Align64();
    SaveFileInfoTablePtr = dc2::memory::NewArray<sceMcTblGetDir>(*main_stack, SAVEDATA_CONVERT_FILE_MAX);
    main_stack->Align64();
    SAVEDATA_BUFFER = dc2::memory::NewObject<SAVE_CONVERT_WORK>(*main_stack);
    if (SaveFileInfoTablePtr == nullptr || SAVEDATA_BUFFER == nullptr) {
        return;
    }
    main_stack->Align64();
    int rest = main_stack->stGetRest();
    if (rest <= 0 || !Stack_ReadBuff.stShareBuffer(*main_stack,
                                                   std::span(main_stack->stGetTop(), static_cast<std::size_t>(rest)))) {
        return;
    }
    Stack_ReadBuff.stReset();
    Stack_ReadBuff.Align64();
    InitSaveFileInfoTablePtr();
    ConvMode = SV_CONV_MODE_SELECT;
    SlotSelect = 0;
}

void SVConvViewExit() {
    sceMcEnd();
    GamePad__2.AutoRepeatOff();
    GamePad__2.MenuModeOff();
    sndSeAllStop(-1);
    mgCloseFont();
}

int SVConvViewLoop() {
    mgCTextureManager *texture_manager = &mgTexManager;

    if (ConvMode == SV_CONV_MODE_SELECT &&
        (GamePad__2.Down(PAD_START) || GamePad__2.Down(PAD_TRIANGLE))) {
        return true;
    }

    if (ConvMode == SV_CONV_MODE_SELECT) {
        if (GamePad__2.Down(PAD_LEFT)) {
            SlotSelect = 0;
        }

        if (GamePad__2.Down(PAD_RIGHT)) {
            SlotSelect = 1;
        }

        if (GamePad__2.Down(PAD_CROSS)) {
            ConvMode = SV_CONV_MODE_CONVERT;
            InitSaveFileInfoTablePtr();
        }
    } else if (ConvMode == SV_CONV_MODE_CONVERT) {
        ConvertResultDispTime = 30;

        if (SaveDataConvertLoop()) {
            ConvMode = SV_CONV_MODE_RESULT;
        }
    } else if (ConvMode == SV_CONV_MODE_RESULT) {
        if (GamePad__2.Down(PAD_CIRCLE)) {
            ConvertResult = SAVEDATA_CONVERT_RESULT_NONE;
            ConvertResultDispTime = 0;
            ConvMode = SV_CONV_MODE_SELECT;
        }
    }

    texture_manager->ReloadTexture(0, (sceVif1Packet *) nullptr);
    CFont font;
    font.Init();
    font.SetClearance(16, 20);
    font.SetFuchi(5);
    font.SetColor(0x80686A6B);
    font.DrawDirect("SaveData Convert", 40, 20);

    if (ConvMode == SV_CONV_MODE_SELECT) {
        font.DrawDirect("Exit: Start or (A)", 200, 20);
    }

    char line[256];
    std::snprintf(line, sizeof(line), "Now Slot : %d", SlotSelect);
    font.SetStr(line);
    font.SetPos(40, 42);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    int y = 72;

    if (ConvMode == SV_CONV_MODE_SELECT) {
        font.DrawDirect("Slot Select    : Left or Right", 40, 72);
        y += 24;
        font.DrawDirect("Check & Convert: (O)", 40, y);
    }

    if (ConvMode == SV_CONV_MODE_CONVERT) {
        if (ConvertPhase == SAVEDATA_CONVERT_PHASE_CHECK_CARD) {
            font.SetStr("Checking MemoryCard");
            font.SetPos(40, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }

        if (ConvertPhase == SAVEDATA_CONVERT_PHASE_READ_DIR) {
            font.SetStr("Now Check DataFile");
            font.SetPos(40, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }

        if (ConvertPhase == SAVEDATA_CONVERT_PHASE_CONVERT) {
            font.SetStr("Now Convert Data ....");
            font.SetPos(40, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }

        if (ConvertPhase == SAVEDATA_CONVERT_PHASE_END) {
            font.SetStr("Checking MemoryCard");
            font.SetPos(40, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }

        y += 24;
        font.SetStr("Don't remove memory card (PS2).");
        font.SetPos(40, y);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
    }

    if (ConvMode == SV_CONV_MODE_RESULT) {
        if (ConvertResult == SAVEDATA_CONVERT_RESULT_CARD_ERROR) {
            font.SetStr("Failed Access memory card(PS2)");
            font.SetPos(40, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 24;
        } else if (ConvertResult == SAVEDATA_CONVERT_RESULT_NO_FILES) {
            font.SetStr("Not Exist Convert Files ");
            font.SetPos(40, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 24;
        } else {
            font.DrawDirect("End Convert", 40, y);
            std::snprintf(line, sizeof(line), "Need Convert Files: %d", FileListNum);
            font.SetStr(line);
            font.SetPos(40, y + 24);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            std::snprintf(line, sizeof(line), "Converted Files: %d", ConvertFileNum);
            font.SetStr(line);
            font.SetPos(40, y + 48);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            std::snprintf(line, sizeof(line), "Not Convert Files: %d", FileListNum - ConvertFileNum);
            font.SetStr(line);
            font.SetPos(40, y + 72);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 96;
        }

        font.DrawDirect("Return to SlotSelect : (X)", 40, y);
    }

    return false;
}

/**
 *
 * Resets the save conversion state and file information table.
 *
 */
static void InitSaveFileInfoTablePtr() {
    FileListNum = 0;
    ConvertPhase = SAVEDATA_CONVERT_PHASE_CHECK_CARD;
    ConvertFileNum = 0;
    ConvertResult = SAVEDATA_CONVERT_RESULT_NONE;
    ConvertResultDispTime = 0;

    for (int i = 0; i < SAVEDATA_CONVERT_FILE_MAX; i++) {
        SaveFileInfoTablePtr[i].entry_name[0] = '\0';
        SaveFileInfoTableSizeConvert[i] = 0;
    }
}

int SaveDataConvertLoop() {
    sceMcTblGetDir dir_entries[SAVEDATA_CONVERT_DIR_MAX] __attribute__((aligned(64)));
    sceMcTblGetDir inside_entries[32] __attribute__((aligned(64)));
    char           path[128];
    int            card_type = {}, free_size = {}, formatted = {};
    int            command = {}, result = {}, existing_count = {};

    switch (ConvertPhase) {
        case SAVEDATA_CONVERT_PHASE_CHECK_CARD: {
            sceMcSync(0, nullptr, nullptr);
            sceMcGetInfo(SlotSelect, 1, &card_type, &free_size, &formatted);
            sceMcSync(0, &command, &result);

            if (card_type != sceMcTypePS2 || formatted != 1) {
                ConvertResult = SAVEDATA_CONVERT_RESULT_CARD_ERROR;
                return true;
            }

            if (result < -1) {
                ConvertResult = SAVEDATA_CONVERT_RESULT_CARD_ERROR;
                return true;
            }

            ConvertPhase = SAVEDATA_CONVERT_PHASE_READ_DIR;
            break;
        }
        case SAVEDATA_CONVERT_PHASE_READ_DIR: {
            memset(dir_entries, 0, sizeof(dir_entries));
            dc2::text::Copy(path, dc2::text::View("BASCUS-97213*"));
            memset(dir_entries, 0, sizeof(dir_entries));
            sceMcGetDir(SlotSelect, 1, path, 0, SAVEDATA_CONVERT_DIR_MAX, dir_entries);
            sceMcSync(0, &command, &result);

            const int listed = dc2::video::BoundedSaveEntries(result, SAVEDATA_CONVERT_FILE_MAX);
            for (int i = 0; i < listed; i++) {
                dc2::memory::CopyTrackedBytes(&SaveFileInfoTablePtr[FileListNum], &dir_entries[i], sizeof(sceMcTblGetDir));
                SaveFileInfoTablePtr[FileListNum].entry_name[sizeof(sceMcTblGetDir::entry_name) - 1] = '\0';
                FileListNum++;
            }

            if (FileListNum <= 0) {
                ConvertResult = SAVEDATA_CONVERT_RESULT_NO_FILES;
                return true;
            }

            ConvertPhase = SAVEDATA_CONVERT_PHASE_CONVERT;
            break;
        }
        case SAVEDATA_CONVERT_PHASE_CONVERT: {
            char dkcl_name[128] = "BESCES-51190dkcl%d";
            char album_name[128] = "BESCES-51190dc2album";
            char omake_name[128] = "BESCES-51190dc2omake";
            char existing_names[SAVEDATA_CONVERT_DIR_MAX][128];
            int  existing_numbers[SAVEDATA_CONVERT_DIR_MAX];
            char previous_dir[128];
            char new_name[128];

            for (int file = 0; file < FileListNum; file++) {
                dc2::text::Copy(path, dc2::text::View("BESCES-51190*"));
                memset(dir_entries, 0, sizeof(dir_entries));
                sceMcGetDir(SlotSelect, 1, path, 0, SAVEDATA_CONVERT_DIR_MAX, dir_entries);
                existing_count = 0;
                sceMcSync(0, &command, &existing_count);

                for (int i = 0; i < SAVEDATA_CONVERT_DIR_MAX; i++) {
                    existing_numbers[i] = -1;
                    existing_names[i][0] = '\0';
                }

                int listed = 0;

                const int bounded_count = dc2::video::BoundedSaveEntries(existing_count, SAVEDATA_CONVERT_DIR_MAX);
                for (int i = 0; i < bounded_count; i++) {
                    dc2::text::Copy(existing_names[listed], dc2::text::View(dir_entries[i].entry_name));
                    const auto number = dc2::video::ParseConvertedSaveIndex(dc2::text::View(dir_entries[i].entry_name));

                    if ((u8) dir_entries[i].entry_name[16] != 0) {
                        existing_numbers[listed] = number.value_or(-1);
                    } else {
                        existing_numbers[listed] = 32;
                    }

                    dc2::log::PrintGame("file[%d] : %d\n", listed, number.value_or(-1));
                    listed++;
                }

                dc2::log::PrintGame("\n");
                int                   number = -1;
                SAVEDATA_CONVERT_TYPE type = SAVEDATA_CONVERT_TYPE_NONE;

                if (strncmp(&SaveFileInfoTablePtr[file].entry_name[12], "dkcl", 4) == 0) {
                    type = SAVEDATA_CONVERT_TYPE_GAME;
                }

                if (strncmp(&SaveFileInfoTablePtr[file].entry_name[12], "dc2album", 8) == 0) {
                    type = SAVEDATA_CONVERT_TYPE_ALBUM;
                }

                if (strncmp(&SaveFileInfoTablePtr[file].entry_name[12], "dc2omake", 8) == 0) {
                    type = SAVEDATA_CONVERT_TYPE_OMAKE;
                }

                if (type < 0) {
                    dc2::log::PrintGame("not convert type : %s\n", SaveFileInfoTablePtr[file].entry_name);
                    continue;
                }

                bool  duplicate = false;
                char *target = nullptr;

                if (type == SAVEDATA_CONVERT_TYPE_ALBUM) {
                    target = album_name;
                }

                if (type == SAVEDATA_CONVERT_TYPE_OMAKE) {
                    target = omake_name;
                }

                if (type == SAVEDATA_CONVERT_TYPE_GAME) {
                    const auto parsed = dc2::video::ParseConvertedSaveIndex(dc2::text::View(SaveFileInfoTablePtr[file].entry_name));
                    if (!parsed) {
                        continue;
                    }
                    number = *parsed;

                    if (0 <= number) {
                        for (int i = 0; i < listed; i++) {
                            if (number == existing_numbers[i]) {
                                duplicate = true;
                                break;
                            }
                        }
                    }
                }

                if (type == SAVEDATA_CONVERT_TYPE_ALBUM || type == SAVEDATA_CONVERT_TYPE_OMAKE) {
                    for (int i = 0; i < listed; i++) {
                        if (strcmp(existing_names[i], target) == 0) {
                            duplicate = true;
                        }
                    }
                }

                if (duplicate) {
                    dc2::log::PrintGame("error already exist ... convert no : %d\n", number);
                    continue;
                }

                sceMcChdir(SlotSelect, 1, SaveFileInfoTablePtr[file].entry_name, std::span(previous_dir));
                sceMcSync(0, nullptr, nullptr);

                if (type == SAVEDATA_CONVERT_TYPE_GAME) {
                    dc2::text::Copy(path, dc2::text::View(SaveFileInfoTablePtr[file].entry_name));
                    sceMcGetDir(SlotSelect, 1, path, 0, 16, inside_entries);
                    sceMcSync(0, &command, &result);

                    if (0 < result) {
                        std::snprintf(new_name, sizeof(new_name), dkcl_name, number);
                        sceMcRename(SlotSelect, 1, path, new_name);
                        sceMcSync(0, nullptr, nullptr);
                        sceMcChdir(SlotSelect, 1, "/", {});
                        sceMcSync(0, nullptr, nullptr);
                        sceMcRename(SlotSelect, 1, path, new_name);
                        sceMcSync(0, nullptr, nullptr);
                        ConvertFileNum++;
                    } else {
                        dc2::log::PrintGame("ERROR : not exist file,,,\n");
                    }
                }

                if (type == SAVEDATA_CONVERT_TYPE_ALBUM || type == SAVEDATA_CONVERT_TYPE_OMAKE) {
                    dc2::text::Copy(path, dc2::text::View(SaveFileInfoTablePtr[file].entry_name));
                    sceMcGetDir(SlotSelect, 1, path, 0, 16, inside_entries);
                    sceMcSync(0, &command, &result);
                    sceMcRename(SlotSelect, 1, path, target);
                    sceMcSync(0, nullptr, nullptr);
                    sceMcChdir(SlotSelect, 1, "/", {});
                    sceMcSync(0, nullptr, nullptr);
                    sceMcRename(SlotSelect, 1, path, target);
                    sceMcSync(0, nullptr, nullptr);
                    ConvertFileNum++;
                }

                sceMcChdir(SlotSelect, 1, "/", {});
                sceMcSync(0, nullptr, nullptr);
            }

            ConvertPhase = SAVEDATA_CONVERT_PHASE_END;
            ConvertResult = SAVEDATA_CONVERT_RESULT_DONE;
            return true;
        }
    }

    return false;
}
