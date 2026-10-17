#include "common.h"

#include <algorithm>
#include <cmath>
#include <numbers>

#include "camera_mouse.hpp"
#include "cameracontrol.hpp"
#include "dng_main.hpp"
#include "map.hpp"
#include "mapparts.hpp"
#include "scenesnd.hpp"

namespace {
struct Vec {
    double x, y, z;

    Vec operator+(Vec b) const { return {x + b.x, y + b.y, z + b.z}; }

    Vec operator-(Vec b) const { return {x - b.x, y - b.y, z - b.z}; }

    Vec operator*(double s) const { return {x * s, y * s, z * s}; }
};

Vec Read(const float *p) { return {p[0], p[1], p[2]}; }

double Dot(Vec a, Vec b) { return a.x * b.x + a.y * b.y + a.z * b.z; }

Vec Cross(Vec a, Vec b) { return {a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x}; }

double Length(Vec a) { return std::sqrt(Dot(a, a)); }

bool Finite(Vec a) { return std::isfinite(a.x) && std::isfinite(a.y) && std::isfinite(a.z); }

Vec Orbit(Vec eye, Vec target, float angle) {
    const Vec   d = eye - target;
    const float c = std::cos(angle), s = std::sin(angle);
    return target + Vec{d.x * c + d.z * s, d.y, d.z * c - d.x * s};
}

double SegmentDistance(Vec a, Vec b, Vec c, Vec d) {
    const Vec    u = b - a, v = d - c, w = a - c;
    const double uu = Dot(u, u), vv = Dot(v, v), uv = Dot(u, v);
    double       s = 0, t = 0;
    if (uu > 0 && vv > 0) {
        const double det = uu * vv - uv * uv;
        if (det > 0) {
            s = std::clamp((uv * Dot(v, w) - vv * Dot(u, w)) / det, 0.0, 1.0);
        }
        t = (uv * s + Dot(v, w)) / vv;
        if (t < 0) {
            t = 0;
            s = std::clamp(-Dot(u, w) / uu, 0.0, 1.0);
        }
        if (t > 1) {
            t = 1;
            s = std::clamp((uv - Dot(u, w)) / uu, 0.0, 1.0);
        }
    } else if (uu > 0) {
        s = std::clamp(-Dot(u, w) / uu, 0.0, 1.0);
    } else if (vv > 0) {
        t = std::clamp(Dot(v, w) / vv, 0.0, 1.0);
    }
    return Length(w + u * s - v * t);
}

bool Inside(Vec p, Vec a, Vec b, Vec c, Vec normal) {
    return Dot(Cross(b - a, p - a), normal) >= 0 &&
           Dot(Cross(c - b, p - b), normal) >= 0 &&
           Dot(Cross(a - c, p - c), normal) >= 0;
}

double PointTriangleDistance(Vec p, Vec a, Vec b, Vec c, Vec normal) {
    const double nn = Dot(normal, normal);
    const double plane = Dot(p - a, normal);
    const Vec    projected = p - normal * (plane / nn);
    if (Inside(projected, a, b, c, normal)) {
        return std::fabs(plane) / std::sqrt(nn);
    }
    return std::min({SegmentDistance(p, p, a, b), SegmentDistance(p, p, b, c), SegmentDistance(p, p, c, a)});
}

double TriangleDistance(Vec start, Vec end, const CCPoly &poly) {
    const Vec a = Read(poly.vertex[0]), b = Read(poly.vertex[1]), c = Read(poly.vertex[2]);
    const Vec normal = Cross(b - a, c - a);
    // Invalid geometry cannot prove a clear corridor.
    // Distance calculations use double precision so near-parallel edges do not
    // lose the small separation that the clearance proof depends on.
    if (!Finite(a) || !Finite(b) || !Finite(c) || !(Dot(normal, normal) > 0) || !Finite(normal)) {
        return 0;
    }
    const double plane = Dot(start - a, normal), direction = Dot(end - start, normal);
    if (direction != 0) {
        const double along = -plane / direction;
        if (along >= 0 && along <= 1 && Inside(start + (end - start) * along, a, b, c, normal)) {
            return 0;
        }
    }
    return std::min({PointTriangleDistance(start, a, b, c, normal), PointTriangleDistance(end, a, b, c, normal),
                     SegmentDistance(start, end, a, b), SegmentDistance(start, end, b, c), SegmentDistance(start, end, c, a)});
}

// A capsule around the middle look ray encloses the whole arc interval and all
// interpolated current/pending eyes and targets. Subdivision reduces this bound,
// instead of sampling rays that can miss a thin wall between endpoints.
bool ClearArc(const CCameraControl &camera, float begin, float end, CCPoly *polys, int count) {
    const float middle = -(begin + end) * 0.5f;
    const Vec   ref = Read(camera.ref), next_ref = Read(camera.next_ref);
    const Vec   eye = Orbit(Read(camera.pos), ref, middle);
    const Vec   next_eye = Orbit(Read(camera.next_pos), next_ref, middle);
    const float radius = std::max(Length(Read(camera.pos) - ref), Length(Read(camera.next_pos) - next_ref));
    const float arc = 2 * radius * std::sin(std::fabs(end - begin) * 0.25f);
    const float envelope = 4.0f + std::max(Length(next_eye - eye) * 0.5f + arc, Length(next_ref - ref) * 0.5f);
    if (!std::isfinite(envelope)) {
        return false;
    }
    const Vec from = (ref + next_ref) * 0.5f, to = (eye + next_eye) * 0.5f;
    for (int i = 0; i < count; ++i) {
        if (!(TriangleDistance(from, to, polys[i]) > envelope)) {
            return false;
        }
    }
    return true;
}

bool ClearRise(const CCameraControl &camera, float begin, float end, CCPoly *polys, int count) {
    const Vec   ref = Read(camera.ref), next_ref = Read(camera.next_ref);
    const Vec   rise{0, (begin + end) * 0.5f, 0};
    const Vec   eye = Read(camera.pos) + rise, next_eye = Read(camera.next_pos) + rise;
    const float envelope = 4.0f + std::max(Length(next_eye - eye) * 0.5f + std::fabs(end - begin) * 0.5f,
                                           Length(next_ref - ref) * 0.5f);
    if (!std::isfinite(envelope)) {
        return false;
    }
    const Vec from = (ref + next_ref) * 0.5f, to = (eye + next_eye) * 0.5f;
    for (int i = 0; i < count; ++i) {
        if (!(TriangleDistance(from, to, polys[i]) > envelope)) {
            return false;
        }
    }
    return true;
}

void Write(float *out, Vec p) {
    out[0] = p.x;
    out[1] = p.y;
    out[2] = p.z;
}

void CorrectGroundAndWalls(CCameraControl &camera, CCPoly *polys, int count) {
    if (camera.GetActiveParam()->no_check) {
        return;
    }
    // The direct mouse pose must not wait for the next frame's retail solver.
    // Correct the current eye as well as the pending eye, retaining both targets.
    CCameraControl current = camera;
    Write(current.next_pos, Read(camera.pos));
    Write(current.next_ref, Read(camera.ref));
    current.CheckGround(polys, count);
    current.CheckCollision(polys, count);
    Write(camera.pos, Read(current.next_pos));
    camera.CheckGround(polys, count);
    camera.CheckCollision(polys, count);
}

void CopyPose(CCameraControl &camera, const CCameraControl &candidate) {
    Write(camera.pos, Read(candidate.pos));
    Write(camera.next_pos, Read(candidate.next_pos));
    const Vec actual = Read(camera.pos) - Read(camera.ref);
    const Vec pending = Read(camera.next_pos) - Read(camera.next_ref);
    camera.angle = std::atan2(actual.x, actual.z);
    camera.next_angle = std::atan2(pending.x, pending.z);
    camera.angle_h = camera.angle;
    camera.angle_v = std::atan2(actual.y, std::hypot(actual.x, actual.z));
    camera.height = pending.y;
    camera.distance = Length(pending);
}

bool ClearFollow(Vec eye, Vec target, Vec next_eye, Vec next_target, CCPoly *polys, int count) {
    if (!Finite(eye) || !Finite(target) || !Finite(next_eye) || !Finite(next_target)) {
        return false;
    }
    const Vec    middle_target = (target + next_target) * 0.5;
    const double target_radius = Length(next_target - target) * 0.5;
    const double eye_travel = Length(next_eye - eye);
    double       accepted = 0, step = 1;
    // The target can ease at a different rate from the eye. Enclose its entire
    // segment for every eye interval rather than checking synchronized samples.
    for (int work = 0; work < 256; ++work) {
        const double end = std::min(1.0, accepted + step);
        const Vec    middle_eye = eye + (next_eye - eye) * ((accepted + end) * 0.5);
        const double envelope = 4.0 + std::max(target_radius, eye_travel * (end - accepted) * 0.5);
        bool         clear = true;
        for (int i = 0; i < count; ++i) {
            if (!(TriangleDistance(middle_target, middle_eye, polys[i]) > envelope)) {
                clear = false;
                break;
            }
        }
        if (clear) {
            if (end == 1) {
                return true;
            }
            accepted = end;
            step = 1 - accepted;
        } else {
            step *= 0.5;
            if (step < 0.00001) {
                return false;
            }
        }
    }
    return false;
}

// The active, unlocked main camera outside scene events; each view adds its mode.
bool MainCameraActive(CCameraControl *camera, CScene *scene, CPadControl *pad, bool subgame, bool locked) {
    return camera && scene && pad && !subgame && !locked && !scene->event_run && scene->active_camera == 0 &&
           scene->GetCamera(0) == camera && !camera->suspended && !mgCCamera::StopCamera &&
           !(camera->rot_cancel & CAMERA_ROT_CANCEL_ANALOG);
}
} // namespace

float MouseCameraClampFollow(CCameraControl &camera, const CCameraControl &candidate, CCPoly *polys, int count) {
    const Vec eye = Read(camera.pos), target = Read(camera.ref);
    const Vec next_eye = Read(candidate.next_pos), next_target = Read(candidate.next_ref);
    Write(camera.next_pos, eye);
    Write(camera.next_ref, target);
    if (count < 0 || count >= 512 || (count && !polys) ||
        !Finite(next_eye) || !Finite(next_target) || !ClearFollow(eye, target, eye, target, polys, count)) {
        return -1;
    }
    double accepted = 0, rejected = 1;
    if (ClearFollow(eye, target, next_eye, next_target, polys, count)) {
        accepted = 1;
    } else {
        // Find a safe destination from the actual pose, even when the old
        // pending pose was blocked. Refused pending motion is never replayed.
        for (int work = 0; work < 16; ++work) {
            const double fraction = (accepted + rejected) * 0.5;
            if (ClearFollow(eye, target, eye + (next_eye - eye) * fraction,
                            target + (next_target - target) * fraction, polys, count)) {
                accepted = fraction;
            } else {
                rejected = fraction;
            }
        }
        const double travel = std::max(Length(next_eye - eye), Length(next_target - target));
        if (travel > 0) {
            accepted = std::max(0.0, accepted - 0.1 / travel);
        }
    }
    Write(camera.next_pos, eye + (next_eye - eye) * accepted);
    Write(camera.next_ref, target + (next_target - target) * accepted);
    return accepted;
}

int MouseCameraCollectPolys(CScene &scene, mgVu0FBOX &box, CCPoly *out, int capacity) {
    if (!out || capacity <= 0) {
        return -1;
    }
    CMap     *maps[4];
    const int maps_count = scene.GetActiveMap(maps, 4);
    int       total = 0;
    for (int i = 0; i < maps_count; ++i) {
        CMapParts *parts[128];
        const int  parts_count = maps[i]->GetPlaceColParts(&box, parts, 128);
        if (parts_count < 0 || parts_count >= 128) {
            return -1;
        }
        // CScene's retail collector continues at exactly zero remaining capacity;
        // its polygon picker writes before checking capacity. Never enter that call.
        const int remaining = capacity - total;
        if (remaining <= 0) {
            return -1;
        }
        const int found = maps[i]->GetCameraPoly(out + total, box, remaining);
        if (found < 0 || found >= remaining) {
            return -1;
        }
        total += found;
    }
    return total;
}

bool TownMouseCameraOwns(CCameraControl *camera, CScene *scene, CPadControl *pad,
                         bool walking, bool subgame, bool locked) {
    return walking && MainCameraActive(camera, scene, pad, subgame, locked) && camera->control_on && camera->follow_on;
}

bool DungeonMouseCameraOwns(CCameraControl *camera, CScene *scene, CPadControl *pad,
                            const DNG_STATUS &status, const DNG_BATTLE_AREA *area,
                            CActionChara *chara, bool subgame, bool locked, bool debug, bool eye) {
    // A system event's _INITIALIZE turns this camera's follow off before the event
    // camera takes over, and the death event never turns it back on. Retail ignores
    // follow while control is on, so eye_view alone tells follow from eye view.
    const bool active = MainCameraActive(camera, scene, pad, subgame, locked) &&
                        (eye ? !camera->follow_on : bool(camera->control_on));
    return active && status.mode == DNG_STATUS_FIELD && bool(status.eye_view) == eye && area && chara && !debug &&
           (area->camera_mode == DNG_CAMERA_FOLLOW || area->camera_mode == DNG_CAMERA_FOLLOW_LOW) &&
           !(area->pause_flag & (DNG_PAUSE_PLAYER_STEP | DNG_PAUSE_PLAYER_CONTROL |
                                 DNG_PAUSE_FIELD_STEP | DNG_PAUSE_PAD_RESET)) &&
           area->script.event_no == -1 && !area->script.running &&
           chara->damage_req != ACTION_DAMAGE_REQ_DEAD &&
           // CheckRunEvent gates menus and eye entry, not the retail follow
           // camera. Carrying, action scripts and lock-on still reach its
           // MoveCamera call after the automatic target framing.
           (!eye || (!chara->lock_on && chara->CheckRunEvent()));
}

bool MouseCameraEye(CCameraControl &camera, float &heading, float &tilt, float yaw, float pitch) {
    if (!std::isfinite(heading) || !std::isfinite(tilt) || !std::isfinite(yaw) || !std::isfinite(pitch) ||
        !Finite(Read(camera.pos)) || !Finite(Read(camera.next_pos)) || (yaw == 0 && pitch == 0)) {
        return false;
    }
    heading = std::remainder(heading - yaw, 2 * std::numbers::pi_v<float>);
    // An existing controller overshoot is preserved when the mouse is idle or
    // turns away from that boundary, matching the reference eye-angle rules.
    if (pitch > 0) {
        tilt = std::max(tilt - pitch, std::min(tilt, -1.0f));
    }
    if (pitch < 0) {
        tilt = std::min(tilt - pitch, std::max(tilt, 0.65f));
    }
    const Vec ray{10 * std::sin(heading) * std::cos(tilt), -10 * std::sin(tilt),
                  10 * std::cos(heading) * std::cos(tilt)};
    Write(camera.ref, Read(camera.pos) + ray);
    Write(camera.next_ref, Read(camera.next_pos) + ray);
    return true;
}

float MouseCameraYaw(CCameraControl &camera, float yaw, CCPoly *polys, int count) {
    if (!std::isfinite(yaw) || yaw == 0 || count < 0 || count >= 512 || (count && !polys) ||
        !Finite(Read(camera.pos)) || !Finite(Read(camera.ref)) ||
        !Finite(Read(camera.next_pos)) || !Finite(Read(camera.next_ref))) {
        return 0;
    }
    // Repeated revolutions traverse the same corridor. Prove at most one complete
    // turn, then use the requested final phase only when that whole turn is clear.
    constexpr float turn = 2 * std::numbers::pi_v<float>;
    const float     requested = yaw;
    yaw = std::copysign(std::min(std::fabs(yaw), turn), yaw);
    if (!ClearArc(camera, 0, 0, polys, count)) {
        return 0;
    }
    float accepted = 0;
    float step = yaw;
    // A fixed validation budget rejects only the unproved suffix. No queued yaw.
    for (int work = 0; work < 256 && std::fabs(yaw - accepted) > 0.00001f; ++work) {
        const float target = accepted + step;
        if (ClearArc(camera, accepted, target, polys, count)) {
            accepted = target;
            step = yaw - accepted;
        } else {
            step *= 0.5f;
            if (std::fabs(step) < 0.00001f) {
                break;
            }
        }
    }
    // Keep a small angular margin at a clipped boundary. A capsule enclosing a
    // reverse interval needs finite clearance to prove movement away from it,
    // and floating-point rounding must not strand an eye exactly on the bound.
    if (std::fabs(yaw - accepted) > 0.00001f) {
        accepted = std::copysign(std::max(0.0f, std::fabs(accepted) - 0.001f), accepted);
    }
    if (accepted == 0) {
        return 0;
    }
    if (accepted == yaw) {
        accepted = requested;
    }
    CCameraControl candidate = camera;
    const float    phase = std::remainder(accepted, turn);
    Write(candidate.pos, Orbit(Read(camera.pos), Read(camera.ref), -phase));
    Write(candidate.next_pos, Orbit(Read(camera.next_pos), Read(camera.next_ref), -phase));
    CorrectGroundAndWalls(candidate, polys, count);
    if (!ClearArc(candidate, 0, 0, polys, count)) {
        return 0;
    }
    // Collision contraction can alter the endpoint's heading. Measure the actual
    // result rather than leaving a stale orientation for character movement.
    CopyPose(camera, candidate);
    return accepted;
}

float MouseCameraPitch(CCameraControl &camera, float pitch, CCPoly *polys, int count, float height_scale) {
    if (!std::isfinite(pitch) || pitch == 0 || count < 0 || count >= 512 || (count && !polys) ||
        !Finite(Read(camera.pos)) || !Finite(Read(camera.ref)) ||
        !Finite(Read(camera.next_pos)) || !Finite(Read(camera.next_ref))) {
        return 0;
    }
    if (!std::isfinite(height_scale) || height_scale <= 0) {
        return 0;
    }
    CameraCtrlParam *param = camera.GetActiveParam();
    if (!std::isfinite(param->height) || !std::isfinite(param->min_height) ||
        !std::isfinite(param->max_height) || param->min_height > param->max_height) {
        return 0;
    }
    const Vec   pending = Read(camera.next_pos) - Read(camera.next_ref);
    const float distance = std::hypot(pending.x, pending.z);
    if (!(distance > 0)) {
        return 0;
    }
    const float angle = std::clamp(std::atan2(pending.y, distance) - pitch, -1.5, 1.5);
    const float wanted = param->height + (distance * std::tan(angle) - pending.y) / height_scale;
    const float delta = (std::clamp(wanted, param->min_height, param->max_height) - param->height) * height_scale;
    if (!std::isfinite(delta) || delta == 0 || !ClearRise(camera, 0, 0, polys, count)) {
        return 0;
    }
    float accepted = 0, step = delta;
    for (int work = 0; work < 256 && std::fabs(delta - accepted) > 0.001f; ++work) {
        const float target = accepted + step;
        if (ClearRise(camera, accepted, target, polys, count)) {
            accepted = target;
            step = delta - accepted;
        } else {
            step *= 0.5f;
            if (std::fabs(step) < 0.001f) {
                break;
            }
        }
    }
    if (std::fabs(delta - accepted) > 0.001f) {
        accepted = std::copysign(std::max(0.0f, std::fabs(accepted) - 0.1f), accepted);
    }
    if (accepted == 0) {
        return 0;
    }
    CCameraControl candidate = camera;
    candidate.pos[1] += accepted;
    candidate.next_pos[1] += accepted;
    candidate.GetActiveParam()->height += accepted / height_scale;
    CorrectGroundAndWalls(candidate, polys, count);
    if (!ClearRise(candidate, 0, 0, polys, count)) {
        return 0;
    }
    CopyPose(camera, candidate);
    param->height += accepted / height_scale;
    return accepted;
}
