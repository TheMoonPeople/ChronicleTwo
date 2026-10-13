#pragma once
#include <libvu0.h>

// Retail binds dng_main's objects under the __2 names; mainloop, editloop and gyorace own the plain names of their statics.
#define MainBuffer MainBuffer__2
#define BuffWorkData BuffWorkData__2
#define EventCamera EventCamera__2

extern int           DebugPause asm("DngMain_DebugPause");
extern sceVu0FVECTOR backup_pos asm("DngMain_SavedEye");
extern int           init_camera asm("DngMain_EyeInitialized");

class CActionChara;
void PortRetailResetEyeView(CActionChara *) asm("DngMain_ResetEyeView");
