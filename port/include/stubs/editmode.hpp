#pragma once

class CScene;

// Retail Georama cursor state, exposed to the native camera seam without changing its logic or layout.
extern int   CursorLockCnt asm("EditMode_CursorLock");
extern float eCameraDist asm("EditMode_CameraDistance");

void PortRetailEditMode(CScene *scene) asm("EditMode_EditMode");
