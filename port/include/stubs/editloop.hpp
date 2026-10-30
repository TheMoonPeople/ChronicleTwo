#pragma once

#include "platform/arena_usage.hpp"

// Expose the retail town ownership state without changing its logic or layout.
extern int LoopMode asm("EditLoop_Mode");
extern int ControlMode asm("EditLoop_Control");
extern int LockChara asm("EditLoop_PlayerLock");
extern int PauseFlag asm("EditLoop_Pause");
extern int ActiveCharaNo asm("EditLoop_ActiveCharaNo");

// The town's exit markers, which the playerless picture leaves out where they stand on the player.
class mgCFrame;
extern mgCFrame *RedBicMark asm("EditLoop_RedBicMark");
extern mgCFrame *BlueBicMark asm("EditLoop_BlueBicMark");
