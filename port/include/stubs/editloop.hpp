#pragma once

#include "../../src/mg_memory_port.hpp"

// Expose the retail town ownership state without changing its logic or layout.
extern int LoopMode asm("EditLoop_Mode");
extern int ControlMode asm("EditLoop_Control");
extern int LockChara asm("EditLoop_PlayerLock");
extern int PauseFlag asm("EditLoop_Pause");
extern int ActiveCharaNo asm("EditLoop_ActiveCharaNo");
// Bit 0 is set for the tick that asks for a menu, whose frame the menu pauses on.
extern int EditDrawFlag asm("EditLoop_DrawFlag");

// The town's exit markers, which the playerless picture leaves out where they stand on the player.
class mgCFrame;
extern mgCFrame *RedBicMark asm("EditLoop_RedBicMark");
extern mgCFrame *BlueBicMark asm("EditLoop_BlueBicMark");

void PortRetailUpdateTrBoxFlag(int map_no) asm("EditLoop_UpdateTrBoxFlag");
int  PortRetailEditDraw() asm("EditLoop_EditDraw");
