#pragma once

class CSaveData;
class CSubGameData;

extern int           NextLoopNo asm("MainLoop_NextLoopNo");
extern int           LoopNo asm("MainLoop_LoopNo");
extern int           PrevLoopNo asm("MainLoop_PrevLoopNo");
extern int           CaptureMode asm("MainLoop_CaptureMode");
extern int           CaptureScreen asm("MainLoop_CaptureScreen");
extern int           PlayTimeCountFlag asm("MainLoop_PlayTimeCountFlag");
extern CSaveData    *ActiveSaveData asm("MainLoop_ActiveSaveData");
extern CSubGameData *SubGameSaveData asm("MainLoop_SubGameSaveData");
extern u_long128     SystemSeBuff[400] asm("MainLoop_SystemSeBuff");
extern u_long128     InfoBuff[5000] asm("MainLoop_InfoBuff");

static void InitPadTable(int language);
static void VSyncCallBack(int unused);

void PortInitPadTable(int language) asm("MainLoop_InitPadTable");

void PortInitPadTable(int language) {
    InitPadTable(language);
}

// mgInitVSyncCallBack takes an int(int) callback and never reads its result; the retail function is void.
int PortVSyncCallBack(int unused) asm("MainLoop_VSyncCallBack");

int PortVSyncCallBack(int unused) {
    VSyncCallBack(unused);
    return 0;
}

struct SPI_TAG_PARAM;

/** Native game configuration loading shares the original callback table. */
extern SPI_TAG_PARAM tag__3[] asm("MainLoop_ConfigTags");
