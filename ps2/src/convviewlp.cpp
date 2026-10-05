#include "common.h"
#include "snd_mngr.hpp"
#include "mglib.hpp"
#include "convviewlp.hpp"
#include "memcard.hpp"
#include <libmc.h>

extern CGamePad GamePad__2;

extern int FileListNum;
extern int ConvertPhase;
extern int ConvertFileNum;
extern int ConvertResult;
extern int ConvertResultDispTime;
extern MC_DIR_ENTRY *SaveFileInfoTablePtr;
extern int SaveFileInfoTableSizeConvert[32];

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/convviewlp", SVConvViewInit__F13INIT_LOOP_ARG);
void SVConvViewExit(void) {
    sceMcEnd();
    GamePad__2.AutoRepeatOff();
    GamePad__2.MenuModeOff();
    sndSeAllStop(-1);
    mgCloseFont();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/convviewlp", SVConvViewLoop__Fv);
void InitSaveFileInfoTablePtr(void) {
    int i;
    FileListNum = 0;
    ConvertPhase = 0;
    ConvertFileNum = 0;
    ConvertResult = 0;
    ConvertResultDispTime = 0;
    for (i = 0; i < 32; i++) {
        SaveFileInfoTablePtr[i].name[0] = 0;
        SaveFileInfoTableSizeConvert[i] = 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/convviewlp", SaveDataConvertLoop__Fv);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/convviewlp", __sinit_convviewlp_cpp);

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
