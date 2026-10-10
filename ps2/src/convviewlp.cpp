#include "common.h"

#include <libmc.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "convviewlp.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "gamepad.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"

/**
 * Display-time value recorded for the conversion result.
 */
static int ConvertResultDispTime;
/**
 * Texture and data storage used by the conversion screen.
 */
static mgCMemory DataBuffer;
/**
 * Read buffer backed by the remaining main-stack storage.
 */
static mgCMemory Stack_ReadBuff;

/**
 * Scene used by the save-data conversion screen.
 */
static CScene *MovieScene;

/**
 * Current mode of the save-data conversion screen.
 */
static int ConvMode;

/**
 * Selected memory-card port.
 */
static int SlotSelect;

/**
 * Number of source save directories in the conversion list.
 */
static int FileListNum;

/**
 * Current phase of memory-card checking and conversion.
 */
static int ConvertPhase;

/**
 * Number of directories converted in the current run.
 */
static int ConvertFileNum;

/**
 * Result reported by the save-data conversion run.
 */
static int ConvertResult;

/**
 * Directory records for the source save files.
 */
static MC_DIR_ENTRY *SaveFileInfoTablePtr;

/**
 * Allocated work image for converting saved game data.
 */
static SAVE_CONVERT_WORK *SAVEDATA_BUFFER;

/**
 * Per-file size information for the conversion list.
 */
int SaveFileInfoTableSizeConvert[128];

static void InitSaveFileInfoTablePtr();

// Code (.text)
void SVConvViewInit(INIT_LOOP_ARG arg) {
    MovieScene = GetMainScene();
    MovieScene->Initialize();
    mgInitFont();
    mgCMemory *main_stack = GetMainStack();
    main_stack->stReset();

    /**
     * First packet buffer for the conversion screen.
     */
    static mgCMemory buf0;

    /**
     * Second packet buffer for the conversion screen.
     */
    static mgCMemory buf1;

    /**
     * First data buffer for the conversion screen.
     */
    static mgCMemory dbuf0;

    /**
     * Second data buffer for the conversion screen.
     */
    static mgCMemory dbuf1;

    u_long128 *vif0 = main_stack->stAlloc64(10000);
    u_long128 *vif1 = main_stack->stAlloc64(10000);
    mgInitVif1Packet(vif0, vif1, 160000);
    buf0.stSetBuffer(main_stack->stAlloc64(30000), 30000);
    buf1.stSetBuffer(main_stack->stAlloc64(30000), 30000);
    dbuf0.stSetBuffer(main_stack->stAlloc64(60000), 60000);
    dbuf1.stSetBuffer(main_stack->stAlloc64(60000), 60000);
    DataBuffer.stSetBuffer(main_stack->stAlloc64(100000), 100000);
    mgSetPacketBuffer(&buf0, &buf1);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetTextureTable(100, 20, &DataBuffer);
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 0, NULL, NULL);
    ReLoadFontTexture(0);
    mgTexManager.EnterIMGFile(GetFontTex2ImgPtr(), 0, NULL, NULL);
    sceMcInit();
    main_stack->Align64();
    SaveFileInfoTablePtr = new (main_stack->Alloc(0x82)) MC_DIR_ENTRY[32];
    main_stack->Align64();
    SAVEDATA_BUFFER = new (main_stack->Alloc(0x659E)) SAVE_CONVERT_WORK;
    main_stack->Align64();
    int rest = main_stack->stGetRest();
    Stack_ReadBuff.stSetBuffer(main_stack->stGetTop(), rest);
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
        return 1;
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

    texture_manager->ReloadTexture(0, (sceVif1Packet *) NULL);
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
    sprintf(line, "Now Slot : %d", SlotSelect);
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
            sprintf(line, "Need Convert Files: %d", FileListNum);
            font.SetStr(line);
            font.SetPos(40, y + 24);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            sprintf(line, "Converted Files: %d", ConvertFileNum);
            font.SetStr(line);
            font.SetPos(40, y + 48);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            sprintf(line, "Not Convert Files: %d", FileListNum - ConvertFileNum);
            font.SetStr(line);
            font.SetPos(40, y + 72);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 96;
        }

        font.DrawDirect("Return to SlotSelect : (X)", 40, y);
    }

    return 0;
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

    for (int i = 0; i < 32; i++) {
        SaveFileInfoTablePtr[i].name[0] = '\0';
        SaveFileInfoTableSizeConvert[i] = 0;
    }
}

int SaveDataConvertLoop() {
    MC_DIR_ENTRY dir_entries[64] __attribute__((aligned(64)));
    MC_DIR_ENTRY inside_entries[32] __attribute__((aligned(64)));
    char         path[128];
    int          card_type, free_size, formatted;
    int          command, result, existing_count;

    switch (ConvertPhase) {
        case SAVEDATA_CONVERT_PHASE_CHECK_CARD: {
            sceMcSync(0, NULL, NULL);
            sceMcGetInfo(SlotSelect, 1, &card_type, &free_size, &formatted);
            sceMcSync(0, &command, &result);

            if (card_type != sceMcTypePS2 || formatted != 1) {
                ConvertResult = SAVEDATA_CONVERT_RESULT_CARD_ERROR;
                return 1;
            }

            if (result < -1) {
                ConvertResult = SAVEDATA_CONVERT_RESULT_CARD_ERROR;
                return 1;
            }

            ConvertPhase = SAVEDATA_CONVERT_PHASE_READ_DIR;
            break;
        }
        case SAVEDATA_CONVERT_PHASE_READ_DIR: {
            memset(dir_entries, 0, sizeof(dir_entries));
            strcpy(path, "BASCUS-97213*");
            memset(dir_entries, 0, sizeof(dir_entries));
            sceMcGetDir(SlotSelect, 1, path, 0, 64, dir_entries);
            sceMcSync(0, &command, &result);

            for (int i = 0; i < result && i < 64; i++) {
                memcpy(&SaveFileInfoTablePtr[FileListNum], &dir_entries[i], sizeof(MC_DIR_ENTRY));
                FileListNum++;
            }

            if (FileListNum <= 0) {
                ConvertResult = SAVEDATA_CONVERT_RESULT_NO_FILES;
                return 1;
            }

            ConvertPhase = SAVEDATA_CONVERT_PHASE_CONVERT;
            break;
        }
        case SAVEDATA_CONVERT_PHASE_CONVERT: {
            char dkcl_name[128] = "BESCES-51190dkcl%d";
            char album_name[128] = "BESCES-51190dc2album";
            char omake_name[128] = "BESCES-51190dc2omake";
            char existing_names[64][128];
            int  existing_numbers[64];
            char previous_dir[128];
            char new_name[128];

            for (int file = 0; file < FileListNum; file++) {
                strcpy(path, "BESCES-51190*");
                memset(dir_entries, 0, sizeof(dir_entries));
                sceMcGetDir(SlotSelect, 1, path, 0, 64, dir_entries);
                existing_count = 0;
                sceMcSync(0, &command, &existing_count);

                for (int i = 0; i < 64; i++) {
                    existing_numbers[i] = -1;
                    existing_names[i][0] = '\0';
                }

                int listed = 0;

                for (int i = 0; i < existing_count; i++) {
                    strcpy(existing_names[file], dir_entries[i].name);
                    int number = atoi(&dir_entries[i].name[16]);

                    if ((u8) dir_entries[i].name[16] != 0) {
                        existing_numbers[listed] = number;
                    } else {
                        existing_numbers[listed] = 32;
                    }

                    printf("file[%d] : %d\n", listed, number);
                    listed++;
                }

                printf("\n");
                int number = -1;
                int type = SAVEDATA_CONVERT_TYPE_NONE;

                if (strncmp(&SaveFileInfoTablePtr[file].name[12], "dkcl", 4) == 0) {
                    type = SAVEDATA_CONVERT_TYPE_GAME;
                }

                if (strncmp(&SaveFileInfoTablePtr[file].name[12], "dc2album", 8) == 0) {
                    type = SAVEDATA_CONVERT_TYPE_ALBUM;
                }

                if (strncmp(&SaveFileInfoTablePtr[file].name[12], "dc2omake", 8) == 0) {
                    type = SAVEDATA_CONVERT_TYPE_OMAKE;
                }

                if (type < 0) {
                    printf("not convert type : %s\n", SaveFileInfoTablePtr[file].name);
                    continue;
                }

                bool  duplicate = false;
                char *target = NULL;

                if (type == SAVEDATA_CONVERT_TYPE_ALBUM) {
                    target = album_name;
                }

                if (type == SAVEDATA_CONVERT_TYPE_OMAKE) {
                    target = omake_name;
                }

                if (type == SAVEDATA_CONVERT_TYPE_GAME) {
                    number = atoi(&SaveFileInfoTablePtr[file].name[16]);

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
                    for (int i = 0; i < existing_count; i++) {
                        if (strcmp(existing_names[i], target) == 0) {
                            duplicate = true;
                        }
                    }
                }

                if (duplicate) {
                    printf("error already exist ... convert no : %d\n", number);
                    continue;
                }

                sceMcChdir(SlotSelect, 1, SaveFileInfoTablePtr[file].name, previous_dir);
                sceMcSync(0, NULL, NULL);

                if (type == SAVEDATA_CONVERT_TYPE_GAME) {
                    strcpy(path, SaveFileInfoTablePtr[file].name);
                    sceMcGetDir(SlotSelect, 1, path, 0, 16, inside_entries);
                    sceMcSync(0, &command, &result);

                    if (0 < result) {
                        sprintf(new_name, dkcl_name, number);
                        sceMcRename(SlotSelect, 1, path, new_name);
                        sceMcSync(0, NULL, NULL);
                        sceMcChdir(SlotSelect, 1, "/", NULL);
                        sceMcSync(0, NULL, NULL);
                        sceMcRename(SlotSelect, 1, path, new_name);
                        sceMcSync(0, NULL, NULL);
                        ConvertFileNum++;
                    } else {
                        printf("ERROR : not exist file,,,\n");
                    }
                }

                if (type == SAVEDATA_CONVERT_TYPE_ALBUM || type == SAVEDATA_CONVERT_TYPE_OMAKE) {
                    strcpy(path, SaveFileInfoTablePtr[file].name);
                    sceMcGetDir(SlotSelect, 1, path, 0, 16, inside_entries);
                    sceMcSync(0, &command, &result);
                    sceMcRename(SlotSelect, 1, path, target);
                    sceMcSync(0, NULL, NULL);
                    sceMcChdir(SlotSelect, 1, "/", NULL);
                    sceMcSync(0, NULL, NULL);
                    sceMcRename(SlotSelect, 1, path, target);
                    sceMcSync(0, NULL, NULL);
                    ConvertFileNum++;
                }

                sceMcChdir(SlotSelect, 1, "/", NULL);
                sceMcSync(0, NULL, NULL);
            }

            ConvertPhase = SAVEDATA_CONVERT_PHASE_END;
            ConvertResult = SAVEDATA_CONVERT_RESULT_DONE;
            return 1;
        }
    }

    return 0;
}
