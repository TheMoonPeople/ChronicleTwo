#include "common.h"
#include "snd_mngr.hpp"
#include "mglib.hpp"
#include "convviewlp.hpp"
#include "gamepad.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "scenesnd.hpp"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include "mglib.hpp"
#include "snd_mngr.hpp"
#include <libmc.h>

// File-local data supplied by the retail assembly while data migration is pending.
extern CGamePad GamePad__2;
extern CScene *MovieScene__2;
extern SAVE_CONVERT_WORK *SAVEDATA_BUFFER;
extern mgCMemory buf0_816, buf1_819, dbuf0_822, dbuf1_825;
extern char init_817, init_820, init_823, init_826;
extern int ConvMode;
extern int SlotSelect;
extern char at_1016__4[], at_1017__4[], at_1018__7[], at_1019__5[];
extern char at_1020__4[], at_1021__4[], at_1022__3[], at_1023__5[];
extern char at_1024__4[], at_1025__5[], at_1026__4[], at_1027__5[];
extern char at_1028__10[], at_1029__7[], at_1030__6[], at_1031__7[];
extern char at_1072__4[], at_1073__4[], at_1074__5[];
extern char at_1159__2[], at_1160__3[], at_1161__3[], at_1162__3[];
extern char at_1163__2[], at_1164__2[], at_1165__2[], at_1166__2[];
extern char at_1167__2[], at_1168[], at_1169[];
extern SAVE_CONVERT_FILE_INFO *SaveFileInfoTablePtr;
extern int SaveFileInfoTableSizeConvert[];
extern int FileListNum;
extern int ConvertPhase;
extern int ConvertFileNum;
extern int ConvertResult;
extern int ConvertResultDispTime;
extern mgCMemory DataBuffer__3;
extern mgCMemory Stack_ReadBuff__3;

static void InitSaveFileInfoTablePtr();

// Code (.text)
#ifdef NONMATCHING
void SVConvViewInit(INIT_LOOP_ARG arg) {
    MovieScene__2 = GetMainScene();
    MovieScene__2->Initialize();
    mgInitFont();
    mgCMemory *main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;
    if (!init_817) { buf0_816.Init(); init_817 = 1; }
    if (!init_820) { buf1_819.Init(); init_820 = 1; }
    if (!init_823) { dbuf0_822.Init(); init_823 = 1; }
    if (!init_826) { dbuf1_825.Init(); init_826 = 1; }
    u_long128 *vif0 = main_stack->stAlloc64(10000);
    u_long128 *vif1 = main_stack->stAlloc64(10000);
    mgInitVif1Packet(vif0, vif1, 10000);
    buf0_816.stSetBuffer(main_stack->stAlloc64(30000), 30000);
    buf1_819.stSetBuffer(main_stack->stAlloc64(30000), 30000);
    dbuf0_822.stSetBuffer(main_stack->stAlloc64(60000), 60000);
    dbuf1_825.stSetBuffer(main_stack->stAlloc64(60000), 60000);
    DataBuffer__3.stSetBuffer(main_stack->stAlloc64(100000), 100000);
    mgSetPacketBuffer(&buf0_816, &buf1_819);
    mgSetDataBuffer(&dbuf0_822, &dbuf1_825, 1);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetTextureTable(100, 20, &DataBuffer__3);
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 0, NULL, NULL);
    ReLoadFontTexture(0);
    mgTexManager.EnterIMGFile(GetFontTex2ImgPtr(), 0, NULL, NULL);
    sceMcInit();
    main_stack->Align64();
    SaveFileInfoTablePtr = new ((u_long128 *)main_stack->Alloc(0x82)) SAVE_CONVERT_FILE_INFO[32];
    main_stack->Align64();
    SAVEDATA_BUFFER = (SAVE_CONVERT_WORK *)main_stack->Alloc(0x659E);
    if (SAVEDATA_BUFFER != NULL) {
        for (int i = 0; i < SAVE_EDIT_DATA_MAX; ++i)
            new ((u_long128 *)&SAVEDATA_BUFFER->save_data.edit_data[i]) CEditData;
        new ((u_long128 *)&SAVEDATA_BUFFER->save_data.user_data) CUserDataManager;
        SAVEDATA_BUFFER->save_data.quest_data.Initialize();
        new ((u_long128 *)&SAVEDATA_BUFFER->save_data.menu_system_data) CMenuSystemData;
    }
    main_stack->Align64();
    Stack_ReadBuff__3.stSetBuffer(main_stack->stAlloc(0), 0);
    Stack_ReadBuff__3.stack_used = 0;
    Stack_ReadBuff__3.lock = 0;
    Stack_ReadBuff__3.Align64();
    InitSaveFileInfoTablePtr();
    ConvMode = SV_CONV_MODE_SELECT;
    SlotSelect = 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/convviewlp", SVConvViewInit__F13INIT_LOOP_ARG);
#endif
void SVConvViewExit() {
    sceMcEnd();
    GamePad__2.AutoRepeatOff();
    GamePad__2.MenuModeOff();
    sndSeAllStop(-1);
    mgCloseFont();
}
#ifdef NONMATCHING
int SVConvViewLoop() {
    if (ConvMode == SV_CONV_MODE_SELECT &&
        (GamePad__2.Down(PAD_START) || GamePad__2.Down(PAD_TRIANGLE))) {
        return 1;
    }
    switch (ConvMode) {
    case SV_CONV_MODE_SELECT:
        if (GamePad__2.Down(PAD_LEFT)) SlotSelect = 0;
        if (GamePad__2.Down(PAD_RIGHT)) SlotSelect = 1;
        if (GamePad__2.Down(PAD_CROSS)) {
            ConvMode = SV_CONV_MODE_CONVERT;
            InitSaveFileInfoTablePtr();
        }
        break;
    case SV_CONV_MODE_CONVERT:
        ConvertResultDispTime = 30;
        if (SaveDataConvertLoop()) ConvMode = SV_CONV_MODE_RESULT;
        break;
    case SV_CONV_MODE_RESULT:
        if (GamePad__2.Down(PAD_CIRCLE)) {
            ConvertResult = SAVEDATA_CONVERT_RESULT_NONE;
            ConvertResultDispTime = 0;
            ConvMode = SV_CONV_MODE_SELECT;
        }
        break;
    }
    mgTexManager.ReloadTexture(0, (sceVif1Packet *)NULL);
    CFont font;
    font.Init();
    font.SetClearance(16, 20);
    font.SetFuchi(5);
    font.SetColor(0x80686A6B);
    font.DrawDirect(at_1016__4, 40, 20);
    if (ConvMode == SV_CONV_MODE_SELECT) font.DrawDirect(at_1017__4, 200, 20);
    char line[256];
    sprintf(line, at_1018__7, SlotSelect);
    font.SetStr(line);
    font.SetPos(40, 42);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    int y = 72;
    if (ConvMode == SV_CONV_MODE_SELECT) {
        font.DrawDirect(at_1019__5, 40, 72);
        y = 96;
        font.DrawDirect(at_1020__4, 40, 96);
    }
    if (ConvMode == SV_CONV_MODE_CONVERT) {
        char *phase_text = at_1021__4;
        if (ConvertPhase == SAVEDATA_CONVERT_PHASE_READ_DIR) phase_text = at_1022__3;
        if (ConvertPhase == SAVEDATA_CONVERT_PHASE_CONVERT) phase_text = at_1023__5;
        font.SetStr(phase_text);
        font.SetPos(40, y);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        y += 24;
        font.SetStr(at_1024__4);
        font.SetPos(40, y);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
    }
    if (ConvMode == SV_CONV_MODE_RESULT) {
        if (ConvertResult == SAVEDATA_CONVERT_RESULT_CARD_ERROR) {
            font.SetStr(at_1025__5);
            font.SetPos(40, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 24;
        } else if (ConvertResult == SAVEDATA_CONVERT_RESULT_NO_FILES) {
            font.SetStr(at_1026__4);
            font.SetPos(40, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 24;
        } else {
            font.DrawDirect(at_1027__5, 40, y);
            sprintf(line, at_1028__10, FileListNum);
            font.SetStr(line); font.SetPos(40, y + 24);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            sprintf(line, at_1029__7, ConvertFileNum);
            font.SetStr(line); font.SetPos(40, y + 48);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            sprintf(line, at_1030__6, FileListNum - ConvertFileNum);
            font.SetStr(line); font.SetPos(40, y + 72);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 96;
        }
        font.DrawDirect(at_1031__7, 40, y);
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/convviewlp", SVConvViewLoop__Fv);
#endif
static void InitSaveFileInfoTablePtr() {
    FileListNum = 0;
    ConvertPhase = SAVEDATA_CONVERT_PHASE_CHECK_CARD;
    ConvertFileNum = 0;
    ConvertResult = SAVEDATA_CONVERT_RESULT_NONE;
    ConvertResultDispTime = 0;
    for (int i = 0; i < 32; i++) {
        SaveFileInfoTablePtr[i].entry_name[0] = '\0';
        SaveFileInfoTableSizeConvert[i] = 0;
    }
}
#ifdef NONMATCHING
int SaveDataConvertLoop() {
    int command, result;
    if (ConvertPhase == SAVEDATA_CONVERT_PHASE_CHECK_CARD) {
        int card_type, free_size, formatted;
        sceMcSync(0, NULL, NULL);
        sceMcGetInfo(SlotSelect, 1, &card_type, &free_size, &formatted);
        sceMcSync(0, &command, &result);
        if (card_type != sceMcTypePS2 || formatted != 1 || result < -1) {
            ConvertResult = SAVEDATA_CONVERT_RESULT_CARD_ERROR;
            return 1;
        }
        ConvertPhase = SAVEDATA_CONVERT_PHASE_READ_DIR;
        return 0;
    }
    if (ConvertPhase == SAVEDATA_CONVERT_PHASE_READ_DIR) {
        SAVE_CONVERT_FILE_INFO entries[64];
        memset(entries, 0, sizeof(entries));
        char mask[128];
        strcpy(mask, at_1159__2);
        memset(entries, 0, sizeof(entries));
        sceMcGetDir(SlotSelect, 1, mask, 0, 64, entries);
        sceMcSync(0, &command, &result);
        for (int i = 0; i < result && i < 64; i++) {
            memcpy(&SaveFileInfoTablePtr[FileListNum], &entries[i], sizeof(SAVE_CONVERT_FILE_INFO));
            FileListNum++;
        }
        if (FileListNum <= 0) {
            ConvertResult = SAVEDATA_CONVERT_RESULT_NO_FILES;
            return 1;
        }
        ConvertPhase = SAVEDATA_CONVERT_PHASE_CONVERT;
        return 0;
    }
    if (ConvertPhase != SAVEDATA_CONVERT_PHASE_CONVERT) return 0;

    char dkcl_name[128], album_name[128], omake_name[128];
    memcpy(dkcl_name, at_1072__4, sizeof(dkcl_name));
    memcpy(album_name, at_1073__4, sizeof(album_name));
    memcpy(omake_name, at_1074__5, sizeof(omake_name));
    for (int file = 0; file < FileListNum; file++) {
        SAVE_CONVERT_FILE_INFO existing[64];
        char old_name[128], new_name[128], previous_dir[128];
        char existing_names[64][128];
        int existing_numbers[64];
        strcpy(old_name, at_1160__3);
        memset(existing, 0, sizeof(existing));
        sceMcGetDir(SlotSelect, 1, old_name, 0, 64, existing);
        int existing_count = 0;
        sceMcSync(0, &command, &existing_count);
        for (int i = 0; i < 64; i++) {
            existing_numbers[i] = -1;
            existing_names[i][0] = '\0';
        }
        for (int i = 0; i < existing_count; i++) {
            strcpy(existing_names[i], existing[i].entry_name);
            int number = atoi(&existing[i].entry_name[16]);
            existing_numbers[i] = existing[i].entry_name[16] ? number : 32;
            printf(at_1161__3, i, number);
        }
        printf(at_1162__3);
        SAVE_CONVERT_FILE_INFO &candidate = SaveFileInfoTablePtr[file];
        SAVEDATA_CONVERT_TYPE type = SAVEDATA_CONVERT_TYPE_NONE;
        if (strncmp(&candidate.entry_name[12], at_1163__2, 4) == 0) type = SAVEDATA_CONVERT_TYPE_GAME;
        if (strncmp(&candidate.entry_name[12], at_1164__2, 8) == 0) type = SAVEDATA_CONVERT_TYPE_ALBUM;
        if (strncmp(&candidate.entry_name[12], at_1165__2, 8) == 0) type = SAVEDATA_CONVERT_TYPE_OMAKE;
        if (type == SAVEDATA_CONVERT_TYPE_NONE) {
            printf(at_1166__2, candidate.entry_name);
            continue;
        }
        char *target = NULL;
        int number = -1;
        bool duplicate = false;
        if (type == SAVEDATA_CONVERT_TYPE_ALBUM) target = album_name;
        if (type == SAVEDATA_CONVERT_TYPE_OMAKE) target = omake_name;
        if (type == SAVEDATA_CONVERT_TYPE_GAME) {
            number = atoi(&candidate.entry_name[16]);
            if (number >= 0) {
                for (int i = 0; i < existing_count; i++) {
                    if (number == existing_numbers[i]) { duplicate = true; break; }
                }
            }
        } else {
            for (int i = 0; i < existing_count; i++) {
                if (strcmp(existing_names[i], target) == 0) duplicate = true;
            }
        }
        if (duplicate) {
            printf(at_1167__2, number);
            continue;
        }
        sceMcChdir(SlotSelect, 1, candidate.entry_name, previous_dir);
        sceMcSync(0, NULL, NULL);
        strcpy(old_name, candidate.entry_name);
        SAVE_CONVERT_FILE_INFO inside[16];
        sceMcGetDir(SlotSelect, 1, old_name, 0, 16, inside);
        sceMcSync(0, &command, &result);
        if (type == SAVEDATA_CONVERT_TYPE_GAME) {
            if (result > 0) {
                sprintf(new_name, dkcl_name, number);
                sceMcRename(SlotSelect, 1, old_name, new_name);
                sceMcSync(0, NULL, NULL);
                sceMcChdir(SlotSelect, 1, at_1168, NULL);
                sceMcSync(0, NULL, NULL);
                sceMcRename(SlotSelect, 1, old_name, new_name);
                sceMcSync(0, NULL, NULL);
                ConvertFileNum++;
            } else {
                printf(at_1169);
            }
        } else {
            sceMcRename(SlotSelect, 1, old_name, target);
            sceMcSync(0, NULL, NULL);
            sceMcChdir(SlotSelect, 1, at_1168, NULL);
            sceMcSync(0, NULL, NULL);
            sceMcRename(SlotSelect, 1, old_name, target);
            sceMcSync(0, NULL, NULL);
            ConvertFileNum++;
        }
        sceMcChdir(SlotSelect, 1, at_1168, NULL);
        sceMcSync(0, NULL, NULL);
    }
    ConvertPhase = SAVEDATA_CONVERT_PHASE_END;
    ConvertResult = SAVEDATA_CONVERT_RESULT_DONE;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/convviewlp", SaveDataConvertLoop__Fv);
#endif

// Static initialiser (.init)
extern "C" void __sinit_convviewlp_cpp() {
    DataBuffer__3.Init();
    Stack_ReadBuff__3.Init();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1072__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1073__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1074__5__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1016__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1017__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1018__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1019__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1020__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1021__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1022__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1023__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1024__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1025__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1026__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1027__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1028__10__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1029__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1030__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1031__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1159__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1160__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1161__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1162__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1163__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1164__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1165__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1166__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1167__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1168__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", at_1169__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/convviewlp", D_0037B0A0__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MovieScene__2, 0x4);
INCLUDE_BSS(ConvMode, 0x4);
INCLUDE_BSS(SlotSelect, 0x4);
INCLUDE_BSS(FileListNum, 0x4);
INCLUDE_BSS(ConvertPhase, 0x4);
INCLUDE_BSS(ConvertFileNum, 0x4);
INCLUDE_BSS(ConvertResult, 0x4);
INCLUDE_BSS(ConvertResultDispTime, 0x34);
INCLUDE_BSS(SaveFileInfoTablePtr, 0x4);
INCLUDE_BSS(SAVEDATA_BUFFER, 0x4);
INCLUDE_BSS(init_817, 0x4);
INCLUDE_BSS(init_820, 0x4);
INCLUDE_BSS(init_823, 0x4);
INCLUDE_BSS(init_826, 0x1);

// Uninitialised data (.bss)
INCLUDE_BSS(DataBuffer__3, 0x30);
INCLUDE_BSS(Stack_ReadBuff__3, 0x30);
INCLUDE_BSS(SaveFileInfoTableSizeConvert, 0x200);
INCLUDE_BSS(buf0_816, 0x30);
INCLUDE_BSS(buf1_819, 0x30);
INCLUDE_BSS(dbuf0_822, 0x30);
INCLUDE_BSS(dbuf1_825, 0x30);
