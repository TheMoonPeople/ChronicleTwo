#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstring>
#include <numbers>
#include <vector>

#include "camera_mouse.hpp"
#include "camera_zoom.hpp"
#include "gameutil.hpp"
#include "render/renderer.hpp"
#include "scenesnd.hpp"

namespace {
float Distance(const float *eye, const float *target) {
    return std::hypot(eye[0] - target[0], eye[2] - target[2]);
}

bool Finite(const float *p) {
    return std::isfinite(p[0]) && std::isfinite(p[1]) && std::isfinite(p[2]);
}

// The point retail wall correction keeps visible: the check reference when set.
void CollisionTarget(CCameraControl &camera, float *target) {
    for (int i = 0; i < 4; ++i) {
        target[i] = camera.check_ref_on ? camera.check_ref[i] + (i == 1 ? camera.follow_offset[1] : 0)
                                        : camera.next_ref[i];
    }
}

// Collision bytes, excluding trailing padding that copies need not preserve.
constexpr std::size_t kPolyBytes = offsetof(CCPoly, attr) + sizeof(CCPoly::attr);

// Gathers the polygons beside each view segment. A query that fills the map
// collector is split in half, so a long view through dense geometry needs only
// the polygons near it rather than one box enclosing the whole view. Zoomed
// beyond retail's range, views also see the characters' collision, since the
// camera's own collision data does not cover every wall seen from that far.
class Collector {
public:
    static constexpr int capacity = 2048;

    Collector(CScene &scene, CCPoly *retail, int retail_count)
        : scene(scene), retail(retail), retail_count(retail_count) {}

    void Clear(bool is_walking) {
        polys.clear();
        walls.clear();
        walking = is_walking;
        ok = retail_count >= 0 && retail_count < 512 && (!retail_count || retail);
        if (ok) {
            polys.insert(polys.end(), retail, retail + retail_count);
        }
    }

    void Add(const float *a, const float *b, float pad = 8, int depth = 0) {
        if (!ok) {
            return;
        }
        if (!Finite(a) || !Finite(b)) {
            ok = false;
            return;
        }
        mgVu0FBOX bounds{};
        for (int i = 0; i < 3; ++i) {
            bounds.min[i] = std::min(a[i], b[i]) - pad;
            bounds.max[i] = std::max(a[i], b[i]) + pad;
        }
        bounds.min[3] = bounds.max[3] = 1;
        static CCPoly piece[512];
        static CCPoly wall_piece[512];
        const int     found = MouseCameraCollectPolys(scene, bounds, piece, 512);
        const int     walled = walking && found >= 0 && found < 512
                                   ? MouseCameraCollectPolys(scene, bounds, wall_piece, 512, true)
                                   : 0;
        if (found >= 0 && found < 512 && walled >= 0 && walled < 512) {
            ok = Insert(polys, piece, found) && Insert(walls, wall_piece, walled);
            return;
        }
        const float length = std::sqrt((a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]) +
                                       (a[2] - b[2]) * (a[2] - b[2]));
        if (length < 16 || depth >= 12) {
            ok = false;
            return;
        }
        const float middle[4] = {(a[0] + b[0]) * 0.5f, (a[1] + b[1]) * 0.5f, (a[2] + b[2]) * 0.5f, 1};
        Add(a, middle, pad, depth + 1);
        Add(middle, b, pad, depth + 1);
    }

    // Returns the unique camera polygons, or -1 when the geometry could not be
    // gathered. View() then also holds the characters' collision when walking.
    int Finish() {
        if (!ok) {
            return -1;
        }
        Merge(polys);
        walls.insert(walls.end(), polys.begin(), polys.end());
        Merge(walls);
        if (walls.size() > capacity) {
            return -1;
        }
        return static_cast<int>(polys.size());
    }

    CCPoly *Data() { return polys.data(); }

    CCPoly *View() { return walls.data(); }

    [[nodiscard]] int ViewCount() const { return static_cast<int>(walls.size()); }

private:
    static void Merge(std::vector<CCPoly> &polys) {
        auto less = [](const CCPoly &x, const CCPoly &y) { return std::memcmp(&x, &y, kPolyBytes) < 0; };
        auto same = [](const CCPoly &x, const CCPoly &y) { return std::memcmp(&x, &y, kPolyBytes) == 0; };
        std::ranges::sort(polys, less);
        polys.erase(std::ranges::unique(polys, same).begin(), polys.end());
    }

    // Neighbouring queries overlap; merge them before giving up.
    static bool Insert(std::vector<CCPoly> &polys, const CCPoly *found, int count) {
        if (polys.size() + count > capacity) {
            Merge(polys);
        }
        if (polys.size() + count > capacity) {
            return false;
        }
        polys.insert(polys.end(), found, found + count);
        return true;
    }

    CScene             &scene;
    CCPoly             *retail;
    int                 retail_count;
    std::vector<CCPoly> polys;
    std::vector<CCPoly> walls;
    bool                walking = false;
    bool                ok = true;
};

// Retail's wall correction places the eye five units in front of a hit along
// the view, which leaves it almost touching a wall it grazes. Move it toward the
// target until it keeps the clearance, so the view does not graze that wall.
void KeepClear(const float *target, float *eye, CCPoly *polys, int count) {
    if (count <= 0 || MouseCameraClearance(eye, polys, count) > CameraZoom::clearance) {
        return;
    }
    const float length = std::sqrt((eye[0] - target[0]) * (eye[0] - target[0]) + (eye[1] - target[1]) * (eye[1] - target[1]) +
                                   (eye[2] - target[2]) * (eye[2] - target[2]));
    const int   steps = std::min(1000, static_cast<int>(length / 2));
    for (int step = 1; step < steps; ++step) {
        const float fraction = 1 - static_cast<float>(step) / steps;
        float       point[4] = {0, 0, 0, 1};
        for (int i = 0; i < 3; ++i) {
            point[i] = target[i] + (eye[i] - target[i]) * fraction;
        }
        if (MouseCameraClearance(point, polys, count) > CameraZoom::clearance) {
            std::copy_n(point, 3, eye);
            return;
        }
    }
}

// Where the view from target to eye is reach from the target, horizontally as
// retail's follow distances are, or the eye when the view is not that long.
void Reach(const float *target, const float *eye, float reach, float *point) {
    const float length = Distance(eye, target);
    const float fraction = length > reach ? reach / length : 1;
    for (int i = 0; i < 3; ++i) {
        point[i] = target[i] + (eye[i] - target[i]) * fraction;
    }
    point[3] = 1;
}

// The nearest wall on the view from target to eye, from the camera's collision
// and, when walking, the characters' collision too. The characters' collision
// counts only where the view crosses it beyond reach, retail's farthest follow
// distance; nearer, the camera's data decides as in retail. This trades some
// occlusion for distance: pulling in to the railings, ledges and invisible
// bounds retail's eye looks across would put the eye at the character, but a
// nearer walking-only wall that retail's shorter view clears can still hide the
// player from a longer zoomed view. The crossing point decides, so the same
// wall counts the same however it is triangulated.
bool FirstHit(Collector &collector, int count, bool walking, float reach, const float *target, const float *eye,
              float *hit) {
    float from[4] = {target[0], target[1], target[2], 1};
    float to[4] = {eye[0], eye[1], eye[2], 1};
    // Retail's follow distances are horizontal.
    const float length = Distance(to, from);
    auto        distance = [&](const float *point) {
        return std::sqrt((point[0] - from[0]) * (point[0] - from[0]) + (point[1] - from[1]) * (point[1] - from[1]) +
                         (point[2] - from[2]) * (point[2] - from[2]));
    };
    bool found = count > 0 && CheckHit(collector.Data(), count, from, to, hit, 1, 0) >= 0;
    if (!walking || collector.ViewCount() <= 0 || !(reach >= 0) || !(length > reach)) {
        return found;
    }
    float start[4];
    float near_hit[4];
    Reach(from, to, reach, start);
    if (CheckHit(collector.View(), collector.ViewCount(), start, to, near_hit, 1, 0) >= 0 &&
        (!found || distance(near_hit) < distance(hit))) {
        std::copy_n(near_hit, 4, hit);
        found = true;
    }
    return found;
}

// Places the eye retail's five-unit margin in front of a hit, toward the target.
void InFront(const float *target, const float *hit, float *eye) {
    const float to_target[3] = {target[0] - hit[0], target[1] - hit[1], target[2] - hit[2]};
    const float length = std::sqrt(to_target[0] * to_target[0] + to_target[1] * to_target[1] + to_target[2] * to_target[2]);
    if (!(length > 0) || !std::isfinite(length)) {
        return;
    }
    // Never past the target itself.
    const float push = std::min(5.0f, length * 0.5f) / length;
    for (int i = 0; i < 3; ++i) {
        eye[i] = hit[i] + to_target[i] * push;
    }
}

// The surface a view sweeps while display frames blend from one drawn pose to
// the next. Presentation blends the camera's placement: its position linearly,
// as it does the models', and only its rotation by slerp. What lies between the
// eye and the target depends on their positions alone, so each frame's view runs
// from eye(u) to target(u), both blended linearly, and the views form the
// bilinear patch eye_a + u * across + v * along + u * v * twist, u and v in
// [0, 1]. Testing it is algebraically exact for linear blending, subject to
// floating-point tolerances and to treating a view that only grazes a wall as
// clear; no allowance is needed for the slerp, which only changes where the view
// is drawn on screen.
class Sweep {
public:
    Sweep(const float *target_a, const float *eye_a, const float *target_b, const float *eye_b) {
        for (int i = 0; i < 3; ++i) {
            origin[i] = eye_a[i];
            across[i] = static_cast<double>(eye_b[i]) - eye_a[i];
            along[i] = static_cast<double>(target_a[i]) - eye_a[i];
            twist[i] = static_cast<double>(target_b[i]) - target_a[i] - across[i];
            // The patch lies within its corners' convex hull, so within their box.
            box_min[i] = std::min({target_a[i], eye_a[i], target_b[i], eye_b[i]});
            box_max[i] = std::max({target_a[i], eye_a[i], target_b[i], eye_b[i]});
        }
    }

    [[nodiscard]] bool Overlaps(const CCPoly &poly) const {
        for (int i = 0; i < 3; ++i) {
            if (std::max({poly.vertex[0][i], poly.vertex[1][i], poly.vertex[2][i]}) < box_min[i] ||
                std::min({poly.vertex[0][i], poly.vertex[1][i], poly.vertex[2][i]}) > box_max[i]) {
                return false;
            }
        }
        return true;
    }

    // Whether segment a-b crosses the patch. Across the segment, the patch point
    // must match the segment in two directions; eliminating v leaves a quadratic
    // in u. When that vanishes for every u, every view meets the segment's line:
    // the segment lies in the patch, on a flat one or along a twisted one's line
    // of fixed v, or passes through a point all views share. It then only
    // touches the views, as CheckHit treats a view in a wall's plane as clear;
    // the wall's other edges, or the patch's edges, find where the wall reaches in.
    bool Crosses(const float *a, const float *b) const {
        const double d[3] = {static_cast<double>(b[0]) - a[0], static_cast<double>(b[1]) - a[1],
                             static_cast<double>(b[2]) - a[2]};
        const double length2 = Dot(d, d);
        if (!(length2 > 0)) {
            return false;
        }
        // Two directions across the segment, scaled to unit length below.
        double unit[3] = {0, 0, 0};
        double n[2][3];
        unit[SmallestAxis(d)] = 1;
        Cross(d, unit, n[0]);
        Cross(d, n[0], n[1]);
        const double offset[3] = {origin[0] - a[0], origin[1] - a[1], origin[2] - a[2]};
        double       c[2];
        double       du[2];
        double       dv[2];
        double       duv[2];
        for (int k = 0; k < 2; ++k) {
            const double norm = std::sqrt(Dot(n[k], n[k]));
            c[k] = Dot(offset, n[k]) / norm;
            du[k] = Dot(across, n[k]) / norm;
            dv[k] = Dot(along, n[k]) / norm;
            duv[k] = Dot(twist, n[k]) / norm;
        }
        const double q2 = du[0] * duv[1] - du[1] * duv[0];
        const double q1 = c[0] * duv[1] + du[0] * dv[1] - c[1] * duv[0] - du[1] * dv[0];
        const double q0 = c[0] * dv[1] - c[1] * dv[0];
        double       scale = length2;
        for (const double *v : {offset, across, along, twist}) {
            scale = std::max(scale, Dot(v, v));
        }
        const double tiny = 1e-12 * scale;
        if (std::fabs(q2) <= tiny && std::fabs(q1) <= tiny && std::fabs(q0) <= tiny) {
            return false;
        }
        const double discriminant = q1 * q1 - 4 * q2 * q0;
        if (discriminant < -1e-12 * (q1 * q1 + std::fabs(4 * q2 * q0))) {
            return false;
        }
        const double root = std::sqrt(std::max(0.0, discriminant));
        const double t = -0.5 * (q1 + std::copysign(root, q1));
        double       us[2];
        int          roots = 0;
        if (q2 != 0) {
            us[roots++] = t / q2;
        }
        if (t != 0) {
            us[roots++] = q0 / t;
        }
        constexpr double slack = 1e-6;
        for (int r = 0; r < roots; ++r) {
            const double u = us[r];
            const double den[2] = {dv[0] + u * duv[0], dv[1] + u * duv[1]};
            const int    k = std::fabs(den[0]) >= std::fabs(den[1]) ? 0 : 1;
            // A view along the segment's line only touches it, as above.
            const bool within = u >= -slack && u <= 1 + slack;
            if (!within || std::fabs(den[k]) <= 1e-9 * std::sqrt(scale)) {
                continue;
            }
            const double v = -(c[k] + u * du[k]) / den[k];
            // Where along the segment the patch point at (u, v) lies.
            double w = 0;
            for (int i = 0; i < 3; ++i) {
                w += (offset[i] + u * across[i] + v * (along[i] + u * twist[i])) * d[i];
            }
            w /= length2;
            if (v >= -slack && v <= 1 + slack && w >= -slack && w <= 1 + slack) {
                return true;
            }
        }
        return false;
    }

private:
    static int SmallestAxis(const double *d) {
        if (std::fabs(d[0]) <= std::fabs(d[1]) && std::fabs(d[0]) <= std::fabs(d[2])) {
            return 0;
        }
        return std::fabs(d[1]) <= std::fabs(d[2]) ? 1 : 2;
    }

    static double Dot(const double *x, const double *y) { return x[0] * y[0] + x[1] * y[1] + x[2] * y[2]; }

    static void Cross(const double *x, const double *y, double *out) {
        out[0] = x[1] * y[2] - x[2] * y[1];
        out[1] = x[2] * y[0] - x[0] * y[2];
        out[2] = x[0] * y[1] - x[1] * y[0];
    }

    double origin[3]{};
    double across[3]{};
    double along[3]{};
    double twist[3]{};
    float  box_min[3]{};
    float  box_max[3]{};
};

} // namespace

/**
 * Reports whether a wall intersects the surface swept between two camera views.
 */
bool CameraViewSweeps(CCPoly *walls, int count, const float *target_a, const float *eye_a, const float *target_b,
                      const float *eye_b) {
    if (count <= 0) {
        return false;
    }
    float corners[4][4];
    for (int i = 0; i < 4; ++i) {
        corners[0][i] = target_a[i];
        corners[1][i] = eye_a[i];
        corners[2][i] = eye_b[i];
        corners[3][i] = target_b[i];
    }
    float hit[4];
    for (int k = 0; k < 4; ++k) {
        if (CheckHit(walls, count, corners[k], corners[(k + 1) % 4], hit, 0, 0) >= 0) {
            return true;
        }
    }
    const Sweep sweep(target_a, eye_a, target_b, eye_b);
    for (int i = 0; i < count; ++i) {
        if (!sweep.Overlaps(walls[i])) {
            continue;
        }
        for (int k = 0; k < 3; ++k) {
            if (sweep.Crosses(walls[i].vertex[k], walls[i].vertex[(k + 1) % 3])) {
                return true;
            }
        }
    }
    return false;
}

float CameraZoom::HeightScale(CCameraControl &camera) const {
    return active ? std::clamp(requested / std::max(1.0f, camera.GetActiveParam()->min_dist), 0.05f, 1.0f) : 1.0f;
}

void CameraZoom::Read(CCameraControl &camera, float wheel, bool reset, bool enabled) {
    if (!enabled || reset) {
        *this = {};
        requested = camera.GetActiveParam()->min_dist;
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
    // A wheel request is the player's choice: move at the camera's own easing,
    // still limited by the walls, without waiting out an earlier hold.
    allowed = requested;
    hold = clear = strikes = calm = 0;
    pulled = false;
    active = true;
}

float CameraZoom::Floor(const CameraCtrlParam &retail) const {
    return std::min(requested, retail.min_dist);
}

void CameraZoom::Strike(float drop) {
    clear = 0;
    if (!(drop >= minor_pull_in)) {
        return;
    }
    if (!pulled) {
        strikes = std::min(strikes + 1, max_strikes + 2);
        pulled = true;
    }
    hold = strikes > 1 ? hold_ticks << std::min(strikes - 2, max_strikes) : 0;
    calm = 0;
}

void CameraZoom::Move(CCameraControl &camera, CScene &scene,
                      CCameraControl::Control &control, float *rotation,
                      CCPoly *retail_polys, int retail_count) {
    if (!active) {
        camera.MoveCamera(&control, rotation, retail_polys, retail_count);
        return;
    }
    // A broken pose has no meaningful distance to keep; retail owns recovery.
    if (!Finite(camera.pos) || !Finite(camera.ref) || !Finite(camera.next_pos) || !Finite(camera.next_ref)) {
        camera.MoveCamera(&control, rotation, retail_polys, retail_count);
        return;
    }
    // Presentation interpolates from the pose drawn last, before this step.
    std::copy_n(camera.pos, 3, shown_pos);
    std::copy_n(camera.ref, 3, shown_ref);
    const CameraCtrlParam retail = *camera.GetActiveParam();
    Collector             collector(scene, retail_polys, retail_count);
    // Zoomed beyond retail's range, views also respect the characters' collision.
    const bool walking = requested > retail.max_dist;

    // The retail follow, controller and reset destination at one distance, then
    // retail's floor, ceiling and wall correction and obstacle avoidance.
    // A turn rotates the destination first, to look at where the view is going.
    // Returns the distance the corrected eye reaches, or -1 without geometry.
    auto evaluate = [&](float distance, CCameraControl &candidate, float turn = 0) -> float {
        candidate = camera;
        CameraCtrlParam &param = *candidate.GetActiveParam();
        // Never set equal limits: retail interpolates height by max_dist-min_dist.
        // Retain its height curve at this distance without extrapolating the
        // near-player lift through the floor at long zoom distances.
        const float span = std::max(1.0f, retail.max_dist - retail.min_dist);
        const float ratio = std::clamp((distance - retail.min_dist) / span, 0.0f, 1.0f);
        param.min_dist = distance;
        param.max_dist = distance + 0.01f;
        param.near_height = param.far_height = retail.near_height + ratio * (retail.far_height - retail.near_height);
        param.no_check = 1;
        candidate.MoveCamera(&control, rotation, nullptr, 0);
        if (turn != 0) {
            candidate.Rotate(turn);
        }
        // Close zoom preserves the normal viewing slope, instead of turning the
        // same retail eye height into an overhead view. Ground clearance still wins.
        candidate.next_pos[1] = candidate.next_ref[1] +
                                (candidate.next_pos[1] - candidate.next_ref[1]) * HeightScale(camera);
        const float height = param.height;
        param = retail;
        param.height = height;
        if (!Finite(candidate.next_pos) || !Finite(candidate.next_ref)) {
            return -1;
        }
        if (retail.no_check) {
            return Distance(candidate.next_pos, candidate.next_ref);
        }
        float target[4];
        CollisionTarget(candidate, target);
        // The view (its eight-unit pad covers retail's five-unit overrun), the
        // vertical line CheckGround queries, and every view from the target to
        // that line, which ground correction can select.
        auto gather = [&] {
            collector.Clear(walking);
            float low[4];
            float high[4];
            for (int i = 0; i < 4; ++i) {
                low[i] = high[i] = candidate.next_pos[i];
            }
            low[1] = target[1] + retail.min_height - retail.ground_space - 8;
            high[1] = target[1] + retail.max_height + 28;
            collector.Add(target, candidate.next_pos);
            collector.Add(low, high);
            collector.Add(target, low);
            collector.Add(target, high);
            if (candidate.check_ref_on) {
                collector.Add(candidate.next_ref, candidate.next_pos);
            }
            return collector.Finish();
        };
        int count = gather();
        if (count < 0) {
            return -1;
        }
        // Walls only the characters' collision knows, such as facades.
        auto beyond = [&] {
            float hit[4];
            if (FirstHit(collector, 0, walking, retail.max_dist, target, candidate.next_pos, hit)) {
                InFront(target, hit, candidate.next_pos);
            }
        };
        candidate.CheckGround(collector.Data(), count);
        candidate.CheckCollision(collector.Data(), count);
        beyond();
        const float avoided[3] = {candidate.next_pos[0], candidate.next_pos[1], candidate.next_pos[2]};
        if (control.rot == 0 && !(candidate.rot_cancel & CAMERA_ROT_CANCEL_AUTO_MOVE) &&
            candidate.AutoMove(collector.Data(), count) && !std::equal(avoided, avoided + 3, candidate.next_pos)) {
            // Avoidance turns the eye beyond the gathered view; correct its new view.
            count = gather();
            if (count >= 0) {
                candidate.CheckGround(collector.Data(), count);
                candidate.CheckCollision(collector.Data(), count);
                beyond();
            } else {
                std::copy_n(avoided, 3, candidate.next_pos);
                count = gather();
                if (count < 0) {
                    return -1;
                }
            }
        }
        KeepClear(target, candidate.next_pos, collector.Data(), count);
        return Distance(candidate.next_pos, candidate.next_ref);
    };

    // Within retail's own follow distance (or a nearer request) the destination
    // is limited on each tick as in retail, and is free again as soon as retail's
    // would be; only a wall cutting the zoom beyond it holds the distance.
    const float least = Floor(retail);
    allowed = std::isfinite(allowed) && allowed > 0 ? std::clamp(allowed, least, requested) : requested;
    CCameraControl chosen = camera;
    float          reached = evaluate(allowed, chosen);
    // Geometry too dense to gather even piecewise: try shorter views first.
    const float first = allowed;
    for (int halvings = 1; reached < 0; ++halvings) {
        const float shorter = std::ldexp(first, -halvings);
        if (!(shorter >= min_distance)) {
            break;
        }
        reached = evaluate(shorter, chosen);
        if (reached >= 0) {
            allowed = shorter;
        }
    }
    if (reached < 0) {
        camera.MoveCamera(&control, rotation, retail_polys, retail_count);
        allowed = std::min(requested, Distance(camera.next_pos, camera.next_ref));
        Strike(first - allowed);
        return;
    }
    if (allowed > least + 0.5f && reached < allowed - 0.5f) {
        // The view is blocked: take the corrected distance at once and hold it.
        const float limited = std::max(reached, least);
        Strike(allowed - limited);
        allowed = limited;
    } else {
        if (++calm >= calm_ticks) {
            strikes = std::max(0, strikes - 1);
            calm = 0;
        }
        const bool held = hold > 0;
        hold = std::max(0, hold - 1);
        if (!held && allowed < requested) {
            // Return only while the view a step farther stays clear.
            const float next = std::min(requested, allowed + std::max(release_min, (requested - allowed) * release_rate));
            const float ahead = std::min(requested, next + lookahead);
            // Also where the view will point while it keeps turning as it has:
            // a field of rocks it sweeps across keeps the shorter distance.
            CCameraControl probe = camera;
            const float    turn = std::clamp(turn_rate * lookahead_ticks, -0.6f, 0.6f);
            const int      samples = std::fabs(turn) < 0.001f ? 1 : 5;
            bool           open = true;
            for (int k = 0; k < samples && open; ++k) {
                open = evaluate(ahead, probe, turn * k / 4) >= ahead - 0.5f;
            }
            clear = open ? clear + 1 : 0;
            if (clear >= clear_ticks) {
                CCameraControl farther = camera;
                if (evaluate(next, farther) >= next - 0.5f) {
                    allowed = next;
                    chosen = farther;
                    pulled = false;
                }
            }
        }
    }
    // Retail's target always follows the player; only the eye is corrected.
    for (int i = 0; i < 4; ++i) {
        camera.next_pos[i] = chosen.next_pos[i];
        camera.next_ref[i] = chosen.next_ref[i];
    }
    camera.GetActiveParam()->height = chosen.GetActiveParam()->height;
    camera.rot_back = chosen.rot_back;
    camera.rot_back_angle = chosen.rot_back_angle;
    // How fast the view turns around the player, for the next lookahead.
    const float angle = std::atan2(camera.next_pos[0] - camera.next_ref[0], camera.next_pos[2] - camera.next_ref[2]);
    if (std::isfinite(heading) && std::isfinite(angle)) {
        turn_rate = std::remainder(angle - heading, 2 * std::numbers::pi_v<float>);
    }
    heading = angle;
    KeepVisible(camera, scene, retail_polys, retail_count);
}

void CameraZoom::KeepVisible(CCameraControl &camera, CScene &scene, CCPoly *retail_polys, int retail_count) {
    const CameraCtrlParam &retail = *camera.GetActiveParam();
    if (!active || retail.no_check || !Finite(camera.pos) || !Finite(camera.ref) || !Finite(camera.next_pos) ||
        !Finite(camera.next_ref)) {
        return;
    }
    // The rendered view is the eased eye and look-at point after the next step;
    // retail eases them separately. When a wall would come between them, place
    // the eye in front of it on that view and cut presentation interpolation.
    CCameraControl rendered = camera;
    rendered.mgCCamera::Step(1);
    const bool walking = requested > retail.max_dist;
    Collector  collector(scene, retail_polys, retail_count);
    collector.Clear(walking);
    collector.Add(rendered.ref, rendered.pos);
    const int count = collector.Finish();
    float     hit[4];
    if (count < 0) {
        return;
    }
    if (!FirstHit(collector, count, walking, retail.max_dist, rendered.ref, rendered.pos, hit)) {
        // Display frames blend from the pose drawn last to this one; cut that
        // when a camera wall lies between, such as a post the view sweeps across.
        // Walking-only walls are checked on each tick's view alone, so one
        // beyond reach can show only in the frames blending between two clear
        // ticks, never in a tick's own view.
        if (Swept(camera, scene, rendered, retail_polys, retail_count)) {
            mgPortCutCameraInterpolation();
        }
        return;
    }
    float eye[4] = {hit[0], hit[1], hit[2], 1};
    InFront(rendered.ref, hit, eye);
    KeepClear(rendered.ref, eye, collector.Data(), count);
    for (int i = 0; i < 3; ++i) {
        camera.pos[i] = camera.next_pos[i] = eye[i];
    }
    // Only a zoom beyond retail's own distance holds, as for the destination.
    const float least = Floor(retail);
    const float shown = std::clamp(Distance(camera.next_pos, camera.next_ref), least, std::max(least, allowed));
    if (allowed > least + 0.5f) {
        Strike(allowed - shown);
    }
    allowed = shown;
    // Cut only where display frames blending to the placed eye would show a
    // wall, the characters' walls included, between it and the player;
    // otherwise they blend as any pull-in does.
    CCameraControl placed = camera;
    placed.mgCCamera::Step(1);
    if (Swept(camera, scene, placed, retail_polys, retail_count, true)) {
        mgPortCutCameraInterpolation();
    }
}

bool CameraZoom::Swept(CCameraControl &camera, CScene &scene, CCameraControl &rendered, CCPoly *retail_polys,
                       int retail_count, bool walking) const {
    float eye[4] = {0, 0, 0, 1};
    float target[4] = {0, 0, 0, 1};
    for (int i = 0; i < 3; ++i) {
        eye[i] = std::isfinite(shown_pos[i]) ? shown_pos[i] : camera.pos[i];
        target[i] = std::isfinite(shown_ref[i]) ? shown_ref[i] : camera.ref[i];
    }
    // Every point of the swept surface lies within the farthest step of the
    // eye or target from the first view.
    float step = 0;
    for (int i = 0; i < 3; ++i) {
        step = std::max({step, std::fabs(rendered.pos[i] - eye[i]), std::fabs(rendered.ref[i] - target[i])});
    }
    if (!(step > 0.001f) || !std::isfinite(step)) {
        return false;
    }
    Collector collector(scene, retail_polys, retail_count);
    collector.Clear(walking);
    collector.Add(target, eye, 8 + step);
    const int count = collector.Finish();
    if (count < 0) {
        // A placed eye that cannot be proved clear of the walls is cut to.
        return walking;
    }
    return walking ? CameraViewSweeps(collector.View(), collector.ViewCount(), target, eye, rendered.ref, rendered.pos)
                   : CameraViewSweeps(collector.Data(), count, target, eye, rendered.ref, rendered.pos);
}
