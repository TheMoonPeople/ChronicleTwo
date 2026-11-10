#pragma once

class CScene;
class mgCCameraFollow;

/**
 * Locks Georama cursor input during placement transitions.
 */
extern int PortEditCursorLock asm("EditMode_CursorLock");
/**
 * Requested distance of the Georama placement camera.
 */
extern float PortEditCameraDistance asm("EditMode_CameraDistance");

/**
 * Whether the Georama placement camera may take a mouse read: retail's cursor step reads the right
 * stick only on an edit map, with no cursor lock, and the port leaves locked input and the debug camera alone.
 */
bool GeoramaMouseOwns(bool edit_map, int cursor_lock, bool follow_camera, bool locked, bool debug_camera);

/**
 * Turns the Georama placement camera by one mouse read as the right stick turns it. Yaw adds to the
 * angle as X does (0.1 radian a frame at full deflection, right turning the view right); pitch moves
 * the requested distance as Y does (15 units a frame), at the stick's 150 units per radian, within
 * retail's 400 to 800. Returns whether the read changed either.
 */
bool GeoramaMouseTurn(mgCCameraFollow &camera, float &distance, float yaw, float pitch);

/**
 * Applies the newest mouse read to the active Georama camera ahead of retail's cursor step, which then
 * adds the stick, follows the cursor and fits the camera to the ground as it does for the stick alone.
 */
void GeoramaMouseCamera(CScene *scene);
