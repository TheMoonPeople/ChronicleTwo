#pragma once

#include "platform/input.hpp"

class CScene;
class CPadControl;
class CCameraControl;

// Map keyboard movement to the retail camera-relative stick without changing its camera.
InputKeyboardMovement FirstPersonWalkStick(InputKeyboardMovement keys, float heading, float camera_angle);
// Keep the third-person entry offset through collision-accepted eye-view movement.
void FirstPersonShiftSavedEye(float *saved, const float *before, const float *after);
bool TownFirstPersonOwns(CScene *scene, CPadControl *pad);
bool DungeonFirstPersonOwns(CCameraControl *camera);
bool FirstPersonLookOwns();
bool TownFirstPersonWalk(CScene *scene, CPadControl *pad);
void DungeonFirstPersonWalk(CCameraControl &camera);

bool DungeonFirstPersonCheckEvents(CCameraControl &camera);
