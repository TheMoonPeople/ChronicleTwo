#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstring>

#include "cameracontrol.hpp"
#include "editmode.hpp"
#include "editmode_port.hpp"
#include "mainloop.hpp"
#include "mg_camera.hpp"
#include "platform/input.hpp"
#include "scene.hpp"

void PortRetailEditMode(CScene *scene) asm("EditMode_EditMode");

namespace {

// Retail's right stick: 0.1 radian of angle and 15 units of distance a frame at full deflection.
constexpr float kStickTurn = 0.1f;
constexpr float kStickDistance = 15.0f;
constexpr float kNearest = 400.0f;
constexpr float kFarthest = 800.0f;

} // namespace

bool GeoramaMouseOwns(bool edit_map, int cursor_lock, bool follow_camera, bool locked, bool debug_camera) {
    return edit_map && cursor_lock <= 0 && follow_camera && !locked && !debug_camera;
}

bool GeoramaMouseTurn(mgCCameraFollow &camera, float &distance, float yaw, float pitch) {
    bool changed = false;
    if (std::isfinite(yaw) && yaw != 0) {
        // The stick adds 0.1 * -X: a read that turns the view right turns the angle down.
        camera.AddAngle(-yaw);
        changed = true;
    }
    if (std::isfinite(pitch) && pitch != 0 && std::isfinite(distance)) {
        // Looking up is the stick pulled down, which moves the camera out.
        const float moved = std::clamp(distance + (kStickDistance / kStickTurn) * pitch, kNearest, kFarthest);
        changed |= moved != distance;
        distance = moved;
    }
    return changed;
}

void GeoramaMouseCamera(CScene *scene) {
    const InputMouseLook &look = InputGetMouseLook();
    static std::uint64_t  consumed_read = 0;
    if (look.read == consumed_read) {
        return;
    }
    consumed_read = look.read;
    if (scene == nullptr || (look.yaw == 0 && look.pitch == 0)) {
        return;
    }
    CMap      *map = scene->GetMap(scene->active_map);
    mgCCamera *base = scene->GetCamera(scene->active_camera);
    const int  kind = base != nullptr ? base->Iam() : -1;
    if (!GeoramaMouseOwns(map != nullptr && std::strcmp(map->Iam(), "CEditMap") == 0, PortEditCursorLock,
                          kind == MG_CAMERA_KIND_FOLLOW || kind == CAMERA_KIND_CONTROL, GamePad__2.key_lock,
                          DebugInfo.debug_camera != 0)) {
        return;
    }
    GeoramaMouseTurn(*static_cast<mgCCameraFollow *>(base), PortEditCameraDistance, look.yaw, look.pitch);
}

// The mouse turns the camera first, so retail's step adds the stick to it, then follows the cursor,
// keeps the camera off walls and under the map's height limit exactly as it does for the stick.
PORT_OVERRIDE void EditMode(CScene *scene) {
    GeoramaMouseCamera(scene);
    PortRetailEditMode(scene);
}
