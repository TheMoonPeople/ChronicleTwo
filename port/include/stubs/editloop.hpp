#pragma once

// Expose the retail town ownership state without changing its logic or layout.
extern int LoopMode asm("EditLoop_Mode");
extern int ControlMode asm("EditLoop_Control");
extern int LockChara asm("EditLoop_PlayerLock");
extern int PauseFlag asm("EditLoop_Pause");
extern int ActiveCharaNo asm("EditLoop_ActiveCharaNo");
