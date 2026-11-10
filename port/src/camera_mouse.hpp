#pragma once

#include <cstdint>

class CCameraControl;
class CScene;
class CPadControl;
class CActionChara;
struct DNG_STATUS;
struct DNG_BATTLE_AREA;
struct CCPoly;
struct mgVu0FBOX;

/**
 * Returns -1 when collection cannot prove complete coverage within capacity.
 * Walking gathers the characters' collision instead of the camera's.
 */
int MouseCameraCollectPolys(CScene &scene, mgVu0FBOX &box, CCPoly *out, int capacity, bool walking = false);

/**
 * Distance from a point to the nearest polygon; 0 for invalid input or geometry.
 */
float MouseCameraClearance(const float *point, CCPoly *polys, int count);

/**
 * Only the active, unlocked walking camera may take a mouse sample; other camera modes keep ownership.
 */
bool TownMouseCameraOwns(CCameraControl *camera, CScene *scene, CPadControl *pad,
                         bool walking, bool subgame, bool locked);

/**
 * Reports whether the dungeon follow or first-person camera may consume direct look input.
 */
bool DungeonMouseCameraOwns(CCameraControl *camera, CScene *scene, CPadControl *pad,
                            const DNG_STATUS &status, const DNG_BATTLE_AREA *area,
                            CActionChara *chara, bool subgame, bool locked, bool debug,
                            bool eye = false);

/**
 * Update the retail first-person angles and both look-at poses without moving
 * the eye. Only a caller with explicit first-person ownership may apply a read.
 */
bool MouseCameraEye(CCameraControl &camera, float &heading, float &tilt, float yaw, float pitch);

/**
 * Applies direct first-person look after the town camera has been placed.
 */
void TownMouseEyeAfterControl(CScene *scene, CPadControl *pad);

/**
 * Turn both current and pending poses by a direct yaw. Retail's wall correction
 * brings the pending eye in front of any wall on its view, and no wall that did
 * not already hide the drawn view hides the view after the next step; a turn
 * that cannot keep that view in sight is dropped and returns 0. Polygons must
 * cover the entire orbit and follow corridor, not just the old eye.
 */
float MouseCameraYaw(CCameraControl &camera, float yaw, CCPoly *polys, int count);

/**
 * Tilt the follow view by changing eye height, within the active retail limits.
 * Returns the accepted height delta; the look-at point remains on the character.
 */
float MouseCameraPitch(CCameraControl &camera, float pitch, CCPoly *polys, int count, float height_scale = 1.0f);
