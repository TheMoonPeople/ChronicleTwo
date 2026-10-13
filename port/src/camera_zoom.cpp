#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstring>

#include "camera_mouse.hpp"
#include "camera_zoom.hpp"
#include "scenesnd.hpp"

namespace {
float Distance(const float *eye, const float *target) {
    return std::hypot(eye[0] - target[0], eye[2] - target[2]);
}

} // namespace

float CameraZoom::HeightScale(CCameraControl &camera) const {
    return active ? std::clamp(requested / std::max(1.0f, camera.GetActiveParam()->min_dist), 0.05f, 1.0f) : 1.0f;
}

void CameraZoom::Read(CCameraControl &camera, float wheel, bool reset, bool enabled) {
    if (!enabled || reset) {
        requested = camera.GetActiveParam()->min_dist;
        active = false;
        return;
    }
    if (!std::isfinite(wheel) || wheel == 0) {
        return;
    }
    if (!active) {
        requested = Distance(camera.next_pos, camera.next_ref);
    }
    if (!std::isfinite(requested)) {
        return;
    }
    // Bound the multiplication as well as the result; enormous finite wheel
    // samples must behave like reaching a limit, never introduce infinity.
    requested = std::clamp(requested - std::clamp(wheel, -1000.0f, 1000.0f) * wheel_step,
                           min_distance, max_distance);
    active = true;
}

void CameraZoom::Move(CCameraControl &camera, CScene &scene,
                      CCameraControl::Control &control, float *rotation,
                      CCPoly *retail_polys, int retail_count) {
    if (!active) {
        camera.MoveCamera(&control, rotation, retail_polys, retail_count);
        return;
    }
    CCameraControl        candidate = camera;
    CameraCtrlParam      &param = *candidate.GetActiveParam();
    const CameraCtrlParam retail = param;
    // Never set equal limits: retail interpolates height by max_dist-min_dist.
    // Retain its height curve at the requested distance without extrapolating
    // the near-player lift through the floor at long zoom distances.
    const float span = std::max(1.0f, retail.max_dist - retail.min_dist);
    const float ratio = std::clamp((requested - retail.min_dist) / span, 0.0f, 1.0f);
    param.min_dist = requested;
    param.max_dist = requested + 0.01f;
    param.near_height = param.far_height = retail.near_height + ratio * (retail.far_height - retail.near_height);

    // First generate the normal follow, controller and reset destination. Its
    // geometry is collected below, including the new distance and follow point.
    param.no_check = 1;
    candidate.MoveCamera(&control, rotation, nullptr, 0);
    // Close zoom preserves the normal viewing slope, instead of turning the
    // same retail eye height into an overhead view. Ground clearance still wins.
    candidate.next_pos[1] = candidate.next_ref[1] +
                            (candidate.next_pos[1] - candidate.next_ref[1]) * HeightScale(camera);
    const float height = param.height;
    param = retail;
    param.height = height;
    param.no_check = 0;

    CCPoly polys[512];
    // Reuse the collector after retail avoidance changes the destination. Each
    // proof must enclose the actual current and final pending corridors.
    auto collect = [&]() {
        mgVu0FBOX bounds{};
        for (int i = 0; i < 3; ++i) {
            bounds.min[i] = std::min({camera.pos[i], camera.ref[i], candidate.next_pos[i], candidate.next_ref[i]}) - 8;
            bounds.max[i] = std::max({camera.pos[i], camera.ref[i], candidate.next_pos[i], candidate.next_ref[i]}) + 8;
        }
        // Include the full vertical query used by CheckGround, not only the eye.
        bounds.min[1] = std::min(bounds.min[1], candidate.next_ref[1] + param.min_height - param.ground_space - 8);
        bounds.max[1] = std::max(bounds.max[1], candidate.next_ref[1] + param.max_height + 28);
        if (candidate.check_ref_on) {
            for (int i = 0; i < 3; ++i) {
                const float target = candidate.check_ref[i] + (i == 1 ? candidate.follow_offset[1] : 0);
                bounds.min[i] = std::min(bounds.min[i], target - 8);
                bounds.max[i] = std::max(bounds.max[i], target + 8);
                if (i == 1) {
                    bounds.min[i] = std::min(bounds.min[i], target + param.min_height - param.ground_space - 8);
                    bounds.max[i] = std::max(bounds.max[i], target + param.max_height + 28);
                }
            }
        }
        bounds.min[3] = bounds.max[3] = 1;
        int count = MouseCameraCollectPolys(scene, bounds, polys, 512);
        if (count < 0 || count >= 512 || retail_count < 0 || retail_count >= 512 ||
            (retail_count && !retail_polys)) {
            return -1;
        }
        for (int i = 0; i < retail_count; ++i) {
            // The broader query commonly contains the caller's whole query.
            // Compare complete records: different collision attributes matter.
            const bool duplicate = std::any_of(polys, polys + count, [&](const CCPoly &poly) {
                return std::memcmp(&poly, &retail_polys[i], sizeof(CCPoly)) == 0;
            });
            if (!duplicate) {
                if (count >= 511) {
                    return -1;
                }
                polys[count++] = retail_polys[i];
            }
        }
        return count;
    };
    int count = collect();
    if (count < 0) {
        camera.MoveCamera(&control, rotation, retail_polys, retail_count);
        return;
    }
    if (!retail.no_check) {
        candidate.CheckGround(polys, count);
        candidate.CheckCollision(polys, count);
        if (control.rot == 0 && !(candidate.rot_cancel & CAMERA_ROT_CANCEL_AUTO_MOVE)) {
            candidate.AutoMove(polys, count);
        }
    }
    count = collect();
    if (count < 0) {
        camera.MoveCamera(&control, rotation, retail_polys, retail_count);
        return;
    }
    // Only next poses are committed. Retail's Step supplies smooth motion, and
    // the proof covers independent eye/target easing and thin walls in between.
    CCameraControl clamped = camera;
    if (MouseCameraClampFollow(clamped, candidate, polys, count) <= 0) {
        camera.MoveCamera(&control, rotation, retail_polys, retail_count);
        return;
    }
    for (int i = 0; i < 4; ++i) {
        camera.next_pos[i] = clamped.next_pos[i];
        camera.next_ref[i] = clamped.next_ref[i];
    }
    camera.GetActiveParam()->height = height;
    camera.rot_back = candidate.rot_back;
    camera.rot_back_angle = candidate.rot_back_angle;
}
