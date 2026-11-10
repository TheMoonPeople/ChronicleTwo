#pragma once
#include "editctrl.hpp"

// Retail town control state and unit-local control entry points.
extern int           PortEditLadderMode asm("EditCtrl_LadderMode");
extern EditViewMode  PortEditViewMode asm("EditCtrl_ViewMode");
extern float         PortEditEyeHeading asm("EditCtrl_EyeHeading");
extern float         PortEditEyeTilt asm("EditCtrl_EyeTilt");
extern sceVu0FVECTOR PortTownSavedEye asm("EditCtrl_SavedEye");
void                 PortEditLadderControl(CScene *, CPadControl *);
void                 PortEditCharaControl(CScene *, CPadControl *);
void                 PortEditCameraControl(CScene *, CPadControl *);

extern int PortEditFixedCamera asm("EditCtrl_FixedCamera");
extern int PortTownLoopMode asm("EditLoop_Mode");
extern int PortTownControlMode asm("EditLoop_Control");
extern int PortTownLockChara asm("EditLoop_PlayerLock");
extern int PortTownPause asm("EditLoop_Pause");

void TownMouseEyeAfterControl(CScene * /*scene*/, CPadControl * /*pad*/);
