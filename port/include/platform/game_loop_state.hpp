#pragma once

#include "common.h"

class CSaveData;
class CSubGameData;
class CScene;

// The retail final-frame outline, drawn at the current target edges.
void PortDrawFrameBorder();
int  PortPlayTimeVSyncCallback(int unused);

// Retained retail loop and save state shared with native launch and rendering hooks.
extern int           PortNextLoopNo asm("MainLoop_NextLoopNo");
extern int           PortLoopNo asm("MainLoop_LoopNo");
extern int           PortPrevLoopNo asm("MainLoop_PrevLoopNo");
extern int           PortCaptureMode asm("MainLoop_CaptureMode");
extern int           PortCaptureScreen asm("MainLoop_CaptureScreen");
extern int           PortPlayTimeCountFlag asm("MainLoop_PlayTimeCountFlag");
extern CSaveData    *PortActiveSaveData asm("MainLoop_ActiveSaveData");
extern CSubGameData *PortSubGameSaveData asm("MainLoop_SubGameSaveData");
extern u_long128     PortSystemSeBuff[400] asm("MainLoop_SystemSeBuff");
extern u_long128     PortInfoBuff[5000] asm("MainLoop_InfoBuff");
void                 PortInitPadTable(int language) asm("MainLoop_InitPadTable");

// Whether arriving in a town map or on a dungeon floor overwrites the autosave; off for test runs.
extern bool PortAutosave;
/**
 * Clears the saved-arrival identities when entering a game loop.
 */
void PortAutosaveResetArrival();
/**
 * Saves eligible town or dungeon arrivals after the frame gives the player control.
 */
void PortAutosaveStep(int program_loop_no);

/**
 * Whether the player has control on a dungeon floor: the field is up, with no menu, event or locked input, and the
 * player and field are stepping. Floor autosave and the debug menu key read it.
 */
bool PortDungeonFieldControl();
/**
 * Whether the player walks a town with control: no Georama edit, menu, event, player lock, pause, locked input or
 * sub-game. Town autosave, which also skips interiors, and the debug menu key read it.
 */
bool PortTownFieldControl();

/**
 * Saves town edits and releases the active town's event, sub-game and audio state.
 */
void PreExitLoop(CScene *scene);
