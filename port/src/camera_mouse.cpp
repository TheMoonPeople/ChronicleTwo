#include "common.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <numbers>
#include <vector>

#include "camera_mouse.hpp"
#include "camera_zoom.hpp"
#include "cameracontrol.hpp"
#include "dng_main.hpp"
#include "gameutil.hpp"
#include "map.hpp"
#include "mapparts.hpp"
#include "render/renderer.hpp"
#include "scenesnd.hpp"

namespace {
struct Vec {
    double x, y, z;

    Vec operator+(Vec b) const { return {.x = x + b.x, .y = y + b.y, .z = z + b.z}; }

    Vec operator-(Vec b) const { return {.x = x - b.x, .y = y - b.y, .z = z - b.z}; }

    Vec operator*(double s) const { return {.x = x * s, .y = y * s, .z = z * s}; }
};

Vec Read(const float *p) { return {.x = p[0], .y = p[1], .z = p[2]}; }

double Dot(Vec a, Vec b) { return a.x * b.x + a.y * b.y + a.z * b.z; }

Vec Cross(Vec a, Vec b) { return {.x = a.y * b.z - a.z * b.y, .y = a.z * b.x - a.x * b.z, .z = a.x * b.y - a.y * b.x}; }

double Length(Vec a) { return std::sqrt(Dot(a, a)); }

bool Finite(Vec a) { return std::isfinite(a.x) && std::isfinite(a.y) && std::isfinite(a.z); }

Vec Orbit(Vec eye, Vec target, float angle) {
    const Vec   d = eye - target;
    const float c = std::cos(angle);
    const float s = std::sin(angle);
    return target + Vec{.x = d.x * c + d.z * s, .y = d.y, .z = d.z * c - d.x * s};
}

double SegmentDistance(Vec a, Vec b, Vec c, Vec d) {
    const Vec    u = b - a;
    const Vec    v = d - c;
    const Vec    w = a - c;
    const double uu = Dot(u, u);
    const double vv = Dot(v, v);
    const double uv = Dot(u, v);
    double       s = 0;
    double       t = 0;
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
    const Vec a = Read(poly.vertex[0]);
    const Vec b = Read(poly.vertex[1]);
    const Vec c = Read(poly.vertex[2]);
    const Vec normal = Cross(b - a, c - a);
    // Invalid geometry cannot prove a clear corridor. Double precision keeps the small separation of
    // near-parallel edges that the clearance proof depends on.
    if (!Finite(a) || !Finite(b) || !Finite(c) || !(Dot(normal, normal) > 0) || !Finite(normal)) {
        return 0;
    }
    const double plane = Dot(start - a, normal);
    const double direction = Dot(end - start, normal);
    if (direction != 0) {
        const double along = -plane / direction;
        if (along >= 0 && along <= 1 && Inside(start + (end - start) * along, a, b, c, normal)) {
            return 0;
        }
    }
    return std::min({PointTriangleDistance(start, a, b, c, normal), PointTriangleDistance(end, a, b, c, normal),
                     SegmentDistance(start, end, a, b), SegmentDistance(start, end, b, c), SegmentDistance(start, end, c, a)});
}

// Whether every polygon lies farther than envelope from the segment from-to.
bool ClearCapsule(Vec from, Vec to, double envelope, CCPoly *polys, int count) {
    for (int i = 0; i < count; ++i) {
        if (!(TriangleDistance(from, to, polys[i]) > envelope)) {
            return false;
        }
    }
    return true;
}

bool ClearRise(const CCameraControl &camera, float begin, float end, CCPoly *polys, int count) {
    const Vec   ref = Read(camera.ref);
    const Vec   next_ref = Read(camera.next_ref);
    const Vec   rise{.x = 0, .y = (begin + end) * 0.5f, .z = 0};
    const Vec   eye = Read(camera.pos) + rise;
    const Vec   next_eye = Read(camera.next_pos) + rise;
    const float envelope = 4.0f + std::max(Length(next_eye - eye) * 0.5f + std::fabs(end - begin) * 0.5f,
                                           Length(next_ref - ref) * 0.5f);
    if (!std::isfinite(envelope)) {
        return false;
    }
    return ClearCapsule((ref + next_ref) * 0.5f, (eye + next_eye) * 0.5f, envelope, polys, count);
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

/**
 * Whether a wall crosses the segment between two points.
 */
bool Blocked(CCPoly *polys, int count, const float *from, const float *to) {
    float a[4] = {from[0], from[1], from[2], 1};
    float b[4] = {to[0], to[1], to[2], 1};
    float hit[4];
    return count > 0 && CheckHit(polys, count, a, b, hit, 1, 0) >= 0;
}

/**
 * The point retail's wall correction checks from when it has an explicit one.
 */
std::array<float, 4> CheckTarget(const CCameraControl &camera) {
    return {camera.check_ref[0], camera.check_ref[1] + camera.follow_offset[1], camera.check_ref[2], 1};
}

/**
 * The largest fraction in [0, 1], to 1/4096, that a test accepts when it
 * accepts 0 and refuses 1.
 */
template <typename Test>
double LastAccepted(Test accepts) {
    double accepted = 0;
    double refused = 1;
    for (int i = 0; i < 12; ++i) {
        const double middle = (accepted + refused) * 0.5;
        (accepts(middle) ? accepted : refused) = middle;
    }
    return accepted;
}

/**
 * Collects walls that obstructed neither camera target before the turn.
 */
std::vector<CCPoly> NewWalls(const CCameraControl &camera, CCPoly *polys, int count) {
    std::vector<CCPoly> walls;
    walls.reserve(static_cast<std::size_t>(count));
    for (int i = 0; i < count; ++i) {
        if (!Blocked(&polys[i], 1, camera.ref, camera.pos) &&
            !(camera.check_ref_on && Blocked(&polys[i], 1, CheckTarget(camera).data(), camera.pos))) {
            walls.push_back(polys[i]);
        }
    }
    return walls;
}

/**
 * Whether an eye sees its look-at point past the walls and, when retail's wall
 * correction keeps an explicit collision target in view, that target too.
 */
bool InSight(const CCameraControl &camera, const float *ref, const float *eye, std::vector<CCPoly> &walls) {
    const int count = static_cast<int>(walls.size());
    return !Blocked(walls.data(), count, ref, eye) &&
           !(camera.check_ref_on && Blocked(walls.data(), count, CheckTarget(camera).data(), eye));
}

/**
 * Predicts the camera pose after one logic step without changing the original.
 */
CCameraControl Stepped(const CCameraControl &camera) {
    CCameraControl stepped = camera;
    stepped.mgCCamera::Step(1);
    return stepped;
}

// The shortest view a placement here may leave, well clear of a camera with no
// usable direction.
constexpr double shortest_view = 10;

// Where a fallback view's search starts, a little beyond shortest_view so that
// the view still measures at least that once its eye is stored as floats and
// stepped.
constexpr double fallback_start = shortest_view + 0.01;

// The headings tried for that view in each half turn.
constexpr int heading_steps = 8;

/**
 * Places a usable stepped view clear of newly obstructing walls, rejecting turns with no sampled placement.
 */
bool KeepInSight(CCameraControl &camera, std::vector<CCPoly> &walls) {
    const int count = static_cast<int>(walls.size());
    // A placement made here must also leave a view of usable length.
    const auto usable = [&](Vec drawn_eye, Vec pending_eye) {
        CCameraControl trial = camera;
        Write(trial.pos, drawn_eye);
        Write(trial.next_pos, pending_eye);
        const CCameraControl stepped = Stepped(trial);
        return Length(Read(stepped.pos) - Read(stepped.ref)) >= shortest_view &&
               InSight(camera, stepped.ref, stepped.pos, walls);
    };
    const Vec pending = Read(camera.next_pos);
    if (const CCameraControl stepped = Stepped(camera); InSight(camera, stepped.ref, stepped.pos, walls)) {
        return true;
    }
    if (Blocked(walls.data(), count, camera.ref, camera.pos) &&
        !Blocked(walls.data(), count, camera.ref, camera.next_pos)) {
        const Vec drawn = Read(camera.pos);
        const Vec eased = pending + (drawn - pending) * LastAccepted([&](double t) {
                                        float point[3];
                                        Write(point, pending + (drawn - pending) * t);
                                        return !Blocked(walls.data(), count, camera.ref, point);
                                    });
        if (usable(eased, pending)) {
            Write(camera.pos, eased);
            return true;
        }
    }
    const Vec  look_at = Read(camera.ref);
    const Vec  drawn = Read(camera.pos);
    const auto toward = [&](double t) { return look_at + (drawn - look_at) * t; };
    if (usable(toward(0), pending)) {
        Write(camera.pos, toward(LastAccepted([&](double t) { return usable(toward(t), pending); })));
        return true;
    }
    const CCameraControl stepped = Stepped(camera);
    const Vec            from = Read(stepped.ref);
    const double         length = std::max(Length(Read(stepped.pos) - from), fallback_start);
    // Nearest first: the stepped view itself, then views turned from it in
    // steps of an eighth of a half turn either way, round to the view behind.
    for (int k = 0; k < 2 * heading_steps; ++k) {
        const int    steps = (k % 2 ? 1 : -1) * ((k + 1) / 2);
        const float  angle = std::numbers::pi_v<float> * static_cast<float>(steps) / heading_steps;
        const Vec    aim = Orbit(Read(stepped.pos), from, angle);
        const double aim_length = Length(aim - from);
        if (!(aim_length > 0)) {
            continue;
        }
        const Vec  direction = (aim - from) * (1 / aim_length);
        const auto at = [&](double s) { return from + direction * (fallback_start + (length - fallback_start) * s); };
        if (!usable(at(0), at(0))) {
            continue;
        }
        const double reach = LastAccepted([&](double s) { return usable(at(s), at(s)); });
        // Five units nearer where there is room, as retail's correction leaves.
        const double room = reach - (5 / std::max(length - fallback_start, 5.0));
        const Vec    eye = at(room > 0 && usable(at(room), at(room)) ? room : reach);
        Write(camera.pos, eye);
        Write(camera.next_pos, eye);
        return true;
    }
    return false;
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

// The active, unlocked main camera outside scene events; each view adds its mode.
bool MainCameraActive(CCameraControl *camera, CScene *scene, CPadControl *pad, bool subgame, bool locked) {
    return camera && scene && pad && !subgame && !locked && !scene->event_run && scene->active_camera == 0 &&
           scene->GetCamera(0) == camera && !camera->suspended && !mgCCamera::StopCamera &&
           !(camera->rot_cancel & CAMERA_ROT_CANCEL_ANALOG);
}
} // namespace

int MouseCameraCollectPolys(CScene &scene, mgVu0FBOX &box, CCPoly *out, int capacity, bool walking) {
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
        const int found = walking ? maps[i]->GetColPoly(out + total, box, remaining)
                                  : maps[i]->GetCameraPoly(out + total, box, remaining);
        if (found < 0 || found >= remaining) {
            return -1;
        }
        total += found;
    }
    return total;
}

float MouseCameraClearance(const float *point, CCPoly *polys, int count) {
    const Vec p = Read(point);
    if (count < 0 || (count && !polys) || !Finite(p)) {
        return 0;
    }
    double nearest = INFINITY;
    for (int i = 0; i < count; ++i) {
        nearest = std::min(nearest, TriangleDistance(p, p, polys[i]));
    }
    return static_cast<float>(nearest);
}

bool TownMouseCameraOwns(CCameraControl *camera, CScene *scene, CPadControl *pad,
                         bool walking, bool subgame, bool locked) {
    // Door, map and world-map entry events turn follow off until a later event resets the camera. Retail's
    // control, like the right stick, runs without follow, so control alone decides.
    return walking && MainCameraActive(camera, scene, pad, subgame, locked) && camera->control_on;
}

bool DungeonMouseCameraOwns(CCameraControl *camera, CScene *scene, CPadControl *pad,
                            const DNG_STATUS &status, const DNG_BATTLE_AREA *area,
                            CActionChara *chara, bool subgame, bool locked, bool debug, bool eye) {
    // Events turn follow off and the death event never turns it back on; retail control runs without it, so
    // follow only tells the eye view apart.
    const bool active = MainCameraActive(camera, scene, pad, subgame, locked) &&
                        (eye ? !camera->follow_on : static_cast<bool>(camera->control_on));
    return active && status.mode == DNG_STATUS_FIELD && static_cast<bool>(status.eye_view) == eye && area && chara && !debug &&
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
    const Vec ray{.x = 10 * std::sin(heading) * std::cos(tilt), .y = -10 * std::sin(tilt), .z = 10 * std::cos(heading) * std::cos(tilt)};
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
    // Rotate both eyes immediately and contract the pending view at walls.
    CCameraControl  candidate = camera;
    constexpr float turn = 2 * std::numbers::pi_v<float>;
    const float     phase = std::remainder(yaw, turn);
    Write(candidate.pos, Orbit(Read(camera.pos), Read(camera.ref), -phase));
    Write(candidate.next_pos, Orbit(Read(camera.next_pos), Read(camera.next_ref), -phase));
    if (!candidate.GetActiveParam()->no_check) {
        candidate.CheckGround(polys, count);
        candidate.CheckCollision(polys, count);
    }
    if (!Finite(Read(candidate.pos)) || !Finite(Read(candidate.next_pos))) {
        return 0;
    }
    std::vector<CCPoly> walls = NewWalls(camera, polys, count);
    if (!KeepInSight(candidate, walls)) {
        return 0;
    }
    // Display frames blend the view straight to its next pose. Cut that where
    // the eye passes a wall, or a new wall crosses a sightline between: the
    // look-at point's or the explicit collision target's.
    const CCameraControl rendered = Stepped(candidate);
    const int            new_count = static_cast<int>(walls.size());
    bool                 cut = Blocked(polys, count, camera.pos, rendered.pos) ||
                               CameraViewSweeps(walls.data(), new_count, camera.ref, camera.pos, rendered.ref, rendered.pos);
    if (camera.check_ref_on) {
        const auto target = CheckTarget(camera);
        cut = cut || CameraViewSweeps(walls.data(), new_count, target.data(), camera.pos, target.data(), rendered.pos);
    }
    if (cut) {
        mgPortCutCameraInterpolation();
    }
    // Collision contraction can alter the endpoint's heading. Measure the actual
    // result rather than leaving a stale orientation for character movement.
    CopyPose(camera, candidate);
    return yaw;
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
    float accepted = 0;
    float step = delta;
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
