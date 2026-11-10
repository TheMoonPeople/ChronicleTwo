#include "common.h"

#include <libvu0.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <span>

#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "vu0_lanes.hpp"

namespace {
int ClassifyPointInTriangle(float x, float y, float x0, float y0, float x1, float y1, float x2, float y2);

/** Number of samples in a complete quantized sine period. */
constexpr std::size_t kSineTableSize = 1024;
/** Converts radians into quantized sine samples. */
constexpr float kSineTableScale = static_cast<float>(kSineTableSize) / TWO_PI;

/**
 * Returns immutable sine samples used by native animation and effect transforms.
 */
const std::array<float, kSineTableSize> &SineTable() {
    static const auto samples = [] {
        std::array<float, kSineTableSize> values{};
        for (std::size_t index = 0; index < values.size(); ++index) {
            values[index] = std::sin(PI * (2.0f * static_cast<float>(index)) / static_cast<float>(values.size()));
        }
        return values;
    }();
    return samples;
}
} // namespace

float mgDistPlanePoint(float *normal, float *on_plane, float *point) {
    sceVu0FVECTOR offset;

    sceVu0SubVector(offset, point, on_plane);
    return sceVu0InnerProduct(normal, offset);
}

float mgDistLinePoint(float *point, float *start, float *end, float *nearest) {
    float to_start[4];
    float to_end[4];
    float offset[4];
    float foot[4];
    float along[4];
    float line_length = {};
    float t = {};
    float dist_start = {};
    float dist_end = {};
    sceVu0SubVector(to_start, start, point);
    sceVu0SubVector(to_end, end, point);
    sceVu0SubVector(along, to_end, to_start);
    line_length = mgDistVector(along);
    line_length = line_length * line_length;
    t = -sceVu0InnerProduct(to_start, along) / line_length;

    if (t < 0.0f || !(t <= 1.0f)) {
        dist_start = mgDistVector(point, start);
        dist_end = mgDistVector(point, end);

        if (dist_start < dist_end) {
            sceVu0CopyVector(nearest, start);
            return dist_start;
        }

        sceVu0CopyVector(nearest, end);
        return dist_end;
    }

    sceVu0ScaleVector(foot, along, t);
    sceVu0AddVector(foot, to_start, foot);
    sceVu0AddVector(nearest, foot, point);
    return mgDistVector(foot);
}

float mgReflectionPlane(float *normal, float *on_plane, float *point, float *reflection) {
    sceVu0FVECTOR step;
    float         distance = {};

    distance = 2.0f * mgDistPlanePoint(normal, on_plane, point);
    sceVu0ScaleVector(step, normal, -distance);
    sceVu0SubVector(reflection, on_plane, point);
    sceVu0SubVector(reflection, reflection, step);
    return distance;
}

int mgIntersectionSphereLine0(float radius, float *from, float *to, std::span<float[4]> hits) {
    if (from == nullptr || to == nullptr || hits.size() < 2 || !std::isfinite(radius) || radius < 0.0f) {
        return 0;
    }
    float delta[4];
    float scaled[4];
    float a = {};
    float b = {};
    float c = {};
    float discriminant = {};
    float root = {};
    float t1 = {};
    float t2 = {};
    int   count = {};

    // Solves |from + line * t|^2 = radius^2 for t within the segment.
    sceVu0SubVector(delta, to, from);
    a = mgDistVector2(delta);
    if (!(a > 0.0f) || !std::isfinite(a)) {
        return 0;
    }
    b = sceVu0InnerProduct(delta, from);
    c = mgDistVector2(from) - radius * radius;
    discriminant = b * b - a * c;

    if (discriminant < 0.0f || !std::isfinite(discriminant)) {
        return 0;
    }

    root = sqrtf(discriminant);
    count = 0;
    t1 = (-b - root) / a;
    t2 = (-b + root) / a;

    if (!(t1 < 0.0f) && t1 <= 1.0f) {
        sceVu0ScaleVector(scaled, delta, t1);
        sceVu0AddVector(hits[0], from, scaled);
        count++;
    }

    // A grazing line touches the sphere once.
    if (discriminant == 0.0f) {
        return count;
    }

    if (!(t2 < 0.0f) && t2 <= 1.0f) {
        sceVu0ScaleVector(scaled, delta, t2);
        sceVu0AddVector(hits[static_cast<std::size_t>(count)], from, scaled);
        count++;
    }

    return count;
}

int mgIntersectionSphereLine(float *sphere, float *from, float *to, std::span<float[4]> hits) {
    if (sphere == nullptr || from == nullptr || to == nullptr || hits.size() < 2) {
        return 0;
    }
    sceVu0FVECTOR local_from;
    sceVu0FVECTOR local_to;
    float         radius = {};
    int           count = {};
    int           i = {};

    radius = sphere[3];
    sceVu0SubVector(local_from, from, sphere);
    sceVu0SubVector(local_to, to, sphere);
    count = mgIntersectionSphereLine0(radius, local_from, local_to, hits);

    for (i = 0; i < count; i++) {
        mgAddVector(hits[static_cast<std::size_t>(i)], sphere);
    }

    return count;
}

int mgIntersectionPoint_line_poly3(float *from, float *to, float *v0, float *v1, float *v2, float *normal, float *hit) {
    sceVu0FVECTOR line;
    sceVu0FVECTOR e0;
    sceVu0FVECTOR e1;
    sceVu0FVECTOR e2;
    float         above = {};
    float         along = {};

    sceVu0SubVector(line, to, from);
    sceVu0SubVector(e0, v0, from);
    sceVu0SubVector(e1, v1, from);
    sceVu0SubVector(e2, v2, from);
    above = -sceVu0InnerProduct(normal, e0);
    along = sceVu0InnerProduct(normal, line);

    if (along == 0.0f) {
        return 0;
    }

    sceVu0ScaleVector(hit, line, -above / along);
    sceVu0AddVector(hit, hit, from);
    return mgCheckPointPoly3_XYZ(hit, v0, v1, v2, normal);
}

int mgCheckPointPoly3_XYZ(float *point, float *v0, float *v1, float *v2, float *normal) {
    sceVu0FVECTOR p0;
    sceVu0FVECTOR p1;
    sceVu0FVECTOR p2;
    sceVu0FVECTOR e0;
    sceVu0FVECTOR e1;
    sceVu0FVECTOR e2;
    sceVu0FVECTOR c0;
    sceVu0FVECTOR c1;
    sceVu0FVECTOR c2;
    float         d0 = {};
    float         d1 = {};
    float         d2 = {};

    sceVu0SubVector(p0, point, v0);
    sceVu0SubVector(p1, point, v1);
    sceVu0SubVector(p2, point, v2);
    sceVu0SubVector(e0, v1, v0);
    sceVu0SubVector(e1, v2, v1);
    sceVu0SubVector(e2, v0, v2);
    sceVu0OuterProduct(c0, e0, p0);
    sceVu0OuterProduct(c1, e1, p1);
    sceVu0OuterProduct(c2, e2, p2);
    d0 = sceVu0InnerProduct(c0, normal);
    d1 = sceVu0InnerProduct(c1, normal);
    d2 = sceVu0InnerProduct(c2, normal);

    if (d0 >= 0.0f && d1 >= 0.0f && d2 >= 0.0f) {
        return 1;
    }

    if (d0 <= 0.0f && d1 <= 0.0f && d2 <= 0.0f) {
        return 1;
    }

    return 0;
}

int mgCheckPointPoly3_XZ(float *point, float *v0, float *v1, float *v2) {
    return ClassifyPointInTriangle(point[0], point[2], v0[0], v0[2], v1[0], v1[2], v2[0], v2[2]);
}

namespace {
/**
 *
 * Returns where a 2D point lies relative to a 2D triangle, as an mgPointPoly3Result.
 *
 */
int ClassifyPointInTriangle(float x, float y, float x0, float y0, float x1, float y1, float x2, float y2) {
    float edge_20 = {};
    float edge_12 = {};
    float edge_01 = {};
    float min_x = {};
    float max_x = {};
    float min_y = {};
    float max_y = {};

    min_x = (x0 < x1) ? ((x0 < x2) ? x0 : x2) : ((x1 < x2) ? x1 : x2);

    if (!(min_x <= x)) {
        return MG_POINT_POLY3_OUTSIDE;
    }

    max_x = (x0 > x1) ? ((x0 > x2) ? x0 : x2) : ((x1 > x2) ? x1 : x2);

    if (!(x <= max_x)) {
        return MG_POINT_POLY3_OUTSIDE;
    }

    min_y = (y0 < y1) ? ((y0 < y2) ? y0 : y2) : ((y1 < y2) ? y1 : y2);

    if (!(min_y <= y)) {
        return MG_POINT_POLY3_OUTSIDE;
    }

    max_y = (y0 > y1) ? ((y0 > y2) ? y0 : y2) : ((y1 > y2) ? y1 : y2);

    if (!(y <= max_y)) {
        return MG_POINT_POLY3_OUTSIDE;
    }

    edge_01 = ((x1 - x0) * (y - y0)) - ((y1 - y0) * (x - x0));
    edge_12 = ((x2 - x1) * (y - y1)) - ((y2 - y1) * (x - x1));
    edge_20 = ((x0 - x2) * (y - y2)) - ((y0 - y2) * (x - x2));

    if (edge_01 == 0.0f) {
        return MG_POINT_POLY3_EDGE_01;
    }

    if (edge_12 == 0.0f) {
        return MG_POINT_POLY3_EDGE_12;
    }

    if (edge_20 == 0.0f) {
        return MG_POINT_POLY3_EDGE_20;
    }

    if (!(edge_01 <= 0.0f) && !(edge_12 <= 0.0f) && !(edge_20 <= 0.0f)) {
        return MG_POINT_POLY3_INSIDE;
    }

    if (edge_01 < 0.0f) {
        if (edge_12 < 0.0f) {
            if (edge_20 < 0.0f) {
                return MG_POINT_POLY3_INSIDE;
            }
        }
    }

    return MG_POINT_POLY3_OUTSIDE;
}
} // namespace

void mgRotMatrixX(float (*matrix)[4], float angle_x) {
    mgUnitMatrix(matrix);
    matrix[2][2] = cosf(angle_x);
    matrix[1][1] = matrix[2][2];
    matrix[1][2] = sinf(angle_x);
    matrix[2][1] = -matrix[1][2];
}

void mgRotMatrixY(float (*matrix)[4], float angle_y) {
    mgUnitMatrix(matrix);
    matrix[2][2] = cosf(angle_y);
    matrix[0][0] = matrix[2][2];
    matrix[2][0] = sinf(angle_y);
    matrix[0][2] = -matrix[2][0];
}

void mgRotMatrixZ(float (*matrix)[4], float angle_z) {
    mgUnitMatrix(matrix);
    matrix[1][1] = cosf(angle_z);
    matrix[0][0] = matrix[1][1];
    matrix[0][1] = sinf(angle_z);
    matrix[1][0] = -matrix[0][1];
}

void mgRotMatrixXYZ(float (*matrix)[4], float *rotation) {
    sceVu0FMATRIX rotate_x;
    sceVu0FMATRIX rotate_y;

    mgRotMatrixX(rotate_x, rotation[0]);
    mgRotMatrixY(rotate_y, rotation[1]);
    mgRotMatrixZ(matrix, rotation[2]);
    MulMatrix3(matrix, rotate_y, rotate_x);
}

void mgCreateMatrixPY(float (*matrix)[4], float *position, float angle_y) {
    mgUnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, angle_y);
    std::memcpy(matrix[3], position, sizeof(matrix[3]));
    matrix[3][3] = 1.0f;
}

void mgLookAtMatrixZ(float (*matrix)[4], float *direction) {
    sceVu0FMATRIX pitch;
    sceVu0FMATRIX yaw;
    sceVu0FVECTOR unit;
    sceVu0FVECTOR flat;
    float         ground = {};
    float         cosine = {};
    float         sine = {};

    sceVu0UnitMatrix(yaw);
    sceVu0CopyMatrix(pitch, yaw);
    sceVu0Normalize(unit, direction);
    sceVu0CopyVector(flat, unit);
    flat[1] = 0.0f;
    ground = mgDistVector(flat);

    if (ground == 0.0f) {
        cosine = 0.0f;
        sine = 1.0f;
    } else {
        cosine = unit[0] / ground;
        sine = unit[2] / ground;
    }

    pitch[1][1] = ground;
    pitch[2][2] = ground;
    yaw[0][2] = -cosine;
    yaw[2][0] = cosine;
    yaw[0][0] = sine;
    yaw[2][2] = sine;
    pitch[2][1] = unit[1];
    pitch[1][2] = -unit[1];
    mgMulMatrix(matrix, yaw, pitch);
}

void mgShadowMatrix(float (*matrix)[4], const float (&light_direction)[4], const float (&on_plane)[4], const float (&plane_normal)[4]) {
    float light_dir[4];
    float plane_point[4];
    float normal_copy[4];
    float dot = {};
    float facing = {};
    float nx = {};
    float inv_dot = {};
    float ly = {};
    float ny = {};
    float lx = {};
    float lz = {};
    float scale = {};
    float nz = {};
    light_dir[0] = light_direction[0];
    light_dir[1] = light_direction[1];
    light_dir[2] = light_direction[2];
    light_dir[3] = 0.0f;
    std::ranges::copy(on_plane, std::span(plane_point).begin());
    std::ranges::copy(plane_normal, std::span(normal_copy).begin());
    dot = sceVu0InnerProduct(normal_copy, plane_point);

    // A plane through the origin cannot be scaled to n.x = 1, so it is moved slightly first.
    if (dot == 0.0f) {
        plane_point[0] -= 0.1f * normal_copy[0];
        plane_point[1] -= 0.1f * normal_copy[1];
        plane_point[2] -= 0.1f * normal_copy[2];
        dot = sceVu0InnerProduct(normal_copy, plane_point);
    }

    inv_dot = 1.0f / dot;
    nx = normal_copy[0] * inv_dot;
    ny = normal_copy[1] * inv_dot;
    nz = normal_copy[2] * inv_dot;
    sceVu0Normalize(light_dir, light_dir);
    lx = light_dir[0];
    ly = light_dir[1];
    lz = light_dir[2];
    facing = nx * lx + ny * ly + nz * lz;
    scale = -1.0f / facing;
    matrix[0][0] = scale * (nx * lx - facing);
    matrix[1][0] = scale * (ny * lx);
    matrix[2][0] = scale * (nz * lx);
    matrix[3][0] = scale * -lx;
    matrix[0][1] = scale * (nx * ly);
    matrix[1][1] = scale * (ny * ly - facing);
    matrix[2][1] = scale * (nz * ly);
    matrix[3][1] = scale * -ly;
    matrix[0][2] = scale * (nx * lz);
    matrix[1][2] = scale * (ny * lz);
    matrix[2][2] = scale * (nz * lz - facing);
    matrix[3][2] = scale * -lz;
    matrix[0][3] = 0.0f;
    matrix[1][3] = 0.0f;
    matrix[2][3] = 0.0f;
    matrix[3][3] = scale * -facing;
}

void mgApplyMatrix(float *max, float *min, float (*matrix)[4], float *box_max, float *box_min) {
    sceVu0FVECTOR corners[8];

    mgCreateBox8(corners, box_max, box_min);
    mgApplyMatrixN_MaxMin(corners, matrix, corners, 8, max, min);
}

void mgVectorInterpolate(float *out, float *from, float *to, float step, int mode) {
    sceVu0FVECTOR gap;

    sceVu0SubVector(gap, to, from);

    switch (mode) {
        case MG_INTERPOLATE_STEP:
            if (mgDistVector(gap) < step) {
                std::memcpy(out, to, sizeof(sceVu0FVECTOR));
                break;
            }

            sceVu0Normalize(gap, gap);
            sceVu0ScaleVector(gap, gap, step);
            sceVu0AddVector(out, from, gap);
            break;
        case MG_INTERPOLATE_FRACTION:
            out[0] = from[0] + gap[0] / step;
            out[1] = from[1] + gap[1] / step;
            out[2] = from[2] + gap[2] / step;
            break;
    }
}

float mgAngleInterpolate(float from, float to, float step, int mode) {
    float delta = {};
    float offset = {};
    float result = {};

    // Angles are kept in (-pi, pi]; one whole turn brings a sum or difference back into range.
    delta = to - from;

    if (delta > PI) {
        delta -= TWO_PI;
    }

    if (delta <= -PI) {
        delta += TWO_PI;
    }

    offset = 0.0f;

    if (mode == MG_INTERPOLATE_STEP && (delta < 0.0f ? -delta : delta) < step) {
        return to;
    }

    switch (mode) {
        case MG_INTERPOLATE_STEP:
            if (delta < 0.0f) {
                if (step < delta) {
                    return to;
                }

                offset -= step;
            }

            if (delta >= 0.0f) {
                if (step > delta) {
                    return to;
                }

                offset += step;
            }

            break;
        case MG_INTERPOLATE_FRACTION:
            offset = delta / step;
            break;
    }

    result = from + offset;

    if (result > PI) {
        result -= TWO_PI;
    }

    if (result <= -PI) {
        result += TWO_PI;
    }

    return result;
}

int mgAngleCmp(float a, float b, float tolerance) {
    float delta = {};

    delta = a - b;

    if (delta == 0.0f) {
        return 0;
    }

    if (delta > PI) {
        delta -= TWO_PI;
    }

    if (delta < -PI) {
        delta += TWO_PI;
    }

    if (delta > tolerance) {
        return 1;
    }

    if (delta < -tolerance) {
        return -1;
    }

    return 0;
}

float mgAngleLimit(float angle) {
    if (!std::isfinite(angle)) {
        return 0.0f;
    }
    if (angle < PI && angle > -PI) {
        return angle;
    }

    angle = std::fmod(angle, TWO_PI);

    if (angle > PI) {
        angle -= TWO_PI;
    }

    if (angle < -PI) {
        angle += TWO_PI;
    }

    return angle;
}

float mgRnd() {
    const float value = static_cast<float>(rand()) / 2147483648.0f;
    return std::min(value, std::nextafter(1.0f, 0.0f));
}

float mgNRnd() {
    // The sum of twelve uniform samples has unit variance about six.
    return mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() + mgRnd() - 6.0f;
}

float mgSinf(float angle) {
    if (!std::isfinite(angle)) {
        return 0.0f;
    }
    const double scaled = std::fabs(static_cast<double>(angle)) * static_cast<double>(kSineTableScale);
    const double rounded = scaled <= std::numeric_limits<float>::max() ? static_cast<double>(static_cast<float>(scaled)) : scaled;
    const auto   index = static_cast<std::size_t>(std::fmod(rounded, static_cast<double>(kSineTableSize)));
    const float  value = SineTable()[index];
    return angle < 0.0f ? -value : value;
}

float mgCosf(float angle) {
    return mgSinf(HALF_PI + angle);
}

namespace {

// Retail adds vf0.x (+0) to every lane it copies, which turns -0 into +0.
float add_vf0x(float v) { return v + 0.0f; }

constexpr int kLanesXYZ[3] = {0, 1, 2};
constexpr int kLanesXYW[3] = {0, 1, 3};

int clip_box_overlap(const int *lanes, float *max0, float *min0, float *max1, float *min1) {
    for (int i = 0; i < 3; i++) {
        const int l = lanes[i];
        if (vu0::SignSet(max0[l] - min1[l]) || vu0::SignSet(max1[l] - min0[l])) {
            return 0;
        }
    }
    return 1;
}

int clip_box_inside(const int *lanes, float *max0, float *min0, float *max1, float *min1) {
    for (int i = 0; i < 3; i++) {
        const int l = lanes[i];
        if (vu0::SignSet(max1[l] - max0[l]) || vu0::SignSet(min0[l] - min1[l])) {
            return 0;
        }
    }
    return 1;
}

// Accumulated in j order: the VU MAC chain's rounding depends on it.
void mat_mul(float out[4][4], const float a[4][4], const float b[4][4]) {
    float r[4][4];
    for (int i = 0; i < 4; i++) {
        for (int k = 0; k < 4; k++) {
            float acc = a[i][0] * b[0][k];
            for (int j = 1; j < 4; j++) {
                acc = acc + a[i][j] * b[j][k];
            }
            r[i][k] = acc;
        }
    }
    for (int i = 0; i < 4; i++) {
        for (int k = 0; k < 4; k++) {
            out[i][k] = r[i][k];
        }
    }
}

void copy_matrix(float dst[4][4], float (*src)[4]) {
    for (int r = 0; r < 4; r++) {
        for (int k = 0; k < 4; k++) {
            dst[r][k] = src[r][k];
        }
    }
}

float squared_sum3(float x, float y, float z) { return (x * x + y * y) + z * z; }

} // namespace

void mgFotI4(int *out, float *in) {
    for (int i = 0; i < 4; i++) {
        out[i] = vu0::Ftoi4(in[i]);
    }
}

void mgCreateBox8(float (*corners)[4], float *max, float *min) {
    const float mx[4] = {max[0], max[1], max[2], max[3]};
    const float mn[4] = {min[0], min[1], min[2], min[3]};
    const float out[8][4] = {
        {mn[0],           mn[1],           mn[2],           mn[3]          },
        {add_vf0x(mx[0]), add_vf0x(mn[1]), add_vf0x(mn[2]), add_vf0x(mn[3])},
        {add_vf0x(mn[0]), add_vf0x(mx[1]), add_vf0x(mn[2]), add_vf0x(mn[3])},
        {add_vf0x(mx[0]), add_vf0x(mx[1]), add_vf0x(mn[2]), add_vf0x(mx[3])},
        {add_vf0x(mn[0]), add_vf0x(mn[1]), add_vf0x(mx[2]), add_vf0x(mn[3])},
        {add_vf0x(mx[0]), add_vf0x(mn[1]), add_vf0x(mx[2]), add_vf0x(mx[3])},
        {add_vf0x(mn[0]), add_vf0x(mx[1]), add_vf0x(mx[2]), add_vf0x(mx[3])},
        {mx[0],           mx[1],           mx[2],           mx[3]          },
    };
    for (int c = 0; c < 8; c++) {
        for (int k = 0; k < 4; k++) {
            corners[c][k] = out[c][k];
        }
    }
}

void mgZeroVector(float *vector) {
    // Native class members need only float alignment, not quadword alignment.
    vector[0] = 0.0f;
    vector[1] = 0.0f;
    vector[2] = 0.0f;
    vector[3] = 0.0f;
}

void mgZeroVectorW(float *vector) {
    vector[0] = 0.0f;
    vector[1] = 0.0f;
    vector[2] = 0.0f;
    vector[3] = 1.0f;
}

int mgClipBoxVertex(float *point, float *max, float *min) {
    for (int i = 0; i < 3; i++) {
        if (vu0::SignSet(max[i] - point[i]) || vu0::SignSet(point[i] - min[i])) {
            return 0;
        }
    }
    return 1;
}

int mgClipBox(float *max0, float *min0, float *max1, float *min1) {
    return clip_box_overlap(kLanesXYZ, max0, min0, max1, min1);
}

int mgClipBoxW(float *max0, float *min0, float *max1, float *min1) {
    return clip_box_overlap(kLanesXYW, max0, min0, max1, min1);
}

int mgClipInBox(float *max0, float *min0, float *max1, float *min1) {
    return clip_box_inside(kLanesXYZ, max0, min0, max1, min1);
}

int mgClipInBoxW(float *max0, float *min0, float *max1, float *min1) {
    return clip_box_inside(kLanesXYW, max0, min0, max1, min1);
}

void mgAddVector(float *vector, float *add) {
    for (int i = 0; i < 4; i++) {
        vector[i] = vector[i] + add[i];
    }
}

void mgSubVector(float *vector, float *sub) {
    for (int i = 0; i < 4; i++) {
        vector[i] = vector[i] - sub[i];
    }
}

void mgNormalizeVector(float *out, float *in, float length) {
    sceVu0FVECTOR unit;

    sceVu0Normalize(unit, in);
    sceVu0ScaleVector(out, unit, length);
}

void mgVectorMin(float *min, float *a, float *b) {
    float r[4];
    for (int i = 0; i < 4; i++) {
        r[i] = vu0::Min(a[i], b[i]);
    }
    for (int i = 0; i < 4; i++) {
        min[i] = r[i];
    }
}

void mgVectorMin(float *min, float *a, float *b, float *c, float *d) {
    float r[4];
    for (int i = 0; i < 4; i++) {
        r[i] = vu0::Min(vu0::Min(vu0::Min(a[i], b[i]), c[i]), d[i]);
    }
    for (int i = 0; i < 4; i++) {
        min[i] = r[i];
    }
}

void mgVectorMaxMin(float *max, float *min, float *a, float *b) {
    float hi[4];
    float lo[4];
    for (int i = 0; i < 4; i++) {
        hi[i] = vu0::Max(a[i], b[i]);
        lo[i] = vu0::Min(a[i], b[i]);
    }
    for (int i = 0; i < 4; i++) {
        max[i] = hi[i];
        min[i] = lo[i];
    }
}

void mgVectorMaxMin(float *max, float *min, float *a, float *b, float *c) {
    float hi[4];
    float lo[4];
    for (int i = 0; i < 4; i++) {
        hi[i] = vu0::Max(vu0::Max(a[i], b[i]), c[i]);
        lo[i] = vu0::Min(vu0::Min(a[i], b[i]), c[i]);
    }
    for (int i = 0; i < 4; i++) {
        max[i] = hi[i];
        min[i] = lo[i];
    }
}

void mgVectorMaxMin(float *max, float *min, float *a, float *b, float *c, float *d) {
    float hi[4];
    float lo[4];
    for (int i = 0; i < 4; i++) {
        hi[i] = vu0::Max(vu0::Max(vu0::Max(a[i], b[i]), c[i]), d[i]);
        lo[i] = vu0::Min(vu0::Min(vu0::Min(a[i], b[i]), c[i]), d[i]);
    }
    for (int i = 0; i < 4; i++) {
        max[i] = hi[i];
        min[i] = lo[i];
    }
}

void mgBoxMaxMin(mgVu0FBOX *box, mgVu0FBOX *other) {
    float hi[4];
    float lo[4];
    for (int i = 0; i < 4; i++) {
        const float a = box->max[i];
        const float b = box->min[i];
        hi[i] = vu0::Max(vu0::Max(vu0::Max(a, b), other->max[i]), other->min[i]);
        lo[i] = vu0::Min(vu0::Min(vu0::Min(a, b), other->max[i]), other->min[i]);
    }
    for (int i = 0; i < 4; i++) {
        box->max[i] = hi[i];
        box->min[i] = lo[i];
    }
}

void mgPlaneNormal(float *normal, float *v0, float *v1, float *v2) {
    // Retail stores vf12 whole, but only xyz is computed, so its w is whatever the register
    // held before. That value is not recoverable; normal[3] is left as it was.
    float a[3];
    float b[3];
    for (int i = 0; i < 3; i++) {
        a[i] = v1[i] - v0[i];
        b[i] = v2[i] - v0[i];
    }
    const float n[3] = {
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0],
    };
    for (int i = 0; i < 3; i++) {
        normal[i] = n[i];
    }
}

float mgDistVector(float *vector) {
    return vu0::Sqrt(squared_sum3(vector[0], vector[1], vector[2]));
}

float mgDistVectorXZ(float *vector) {
    return vu0::Sqrt(vector[0] * vector[0] + vector[2] * vector[2]);
}

float mgDistVector2(float *vector) {
    return squared_sum3(vector[0], vector[1], vector[2]);
}

float mgDistVector(float *a, float *b) {
    return vu0::Sqrt(squared_sum3(b[0] - a[0], b[1] - a[1], b[2] - a[2]));
}

float mgDistVectorXZ(float *a, float *b) {
    const float dx = b[0] - a[0];
    const float dz = b[2] - a[2];
    return vu0::Sqrt(dx * dx + dz * dz);
}

float mgDistVector2(float *a, float *b) {
    return squared_sum3(b[0] - a[0], b[1] - a[1], b[2] - a[2]);
}

float mgDistVectorXZ2(float *a, float *b) {
    const float dx = b[0] - a[0];
    const float dz = b[2] - a[2];
    return dx * dx + dz * dz;
}

void mgUnitMatrix(float (*matrix)[4]) {
    for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
            matrix[row][col] = (row == col) ? 1.0f : 0.0f;
        }
    }
}

void mgZeroMatrix(float (*matrix)[4]) {
    for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
            matrix[row][col] = 0.0f;
        }
    }
}

void MulMatrix3(float (*matrix)[4], float (*second)[4], float (*third)[4]) {
    float m[4][4];
    float t[4][4];
    copy_matrix(m, matrix);
    mat_mul(t, second, m);
    mat_mul(m, third, t);
    copy_matrix(matrix, m);
}

void mgMulMatrix(float (*product)[4], float (*left_matrix)[4], float (*right_matrix)[4]) {
    // Product is right * left: callers such as mg_drawenv and mg_frame depend on this order.
    float l[4][4];
    float r[4][4];
    copy_matrix(l, left_matrix);
    copy_matrix(r, right_matrix);
    float p[4][4];
    mat_mul(p, r, l);
    copy_matrix(product, p);
}

void mgInversMatrix(float (*inverse)[4], float (*matrix)[4]) {
    float m[4][4];
    copy_matrix(m, matrix);
    const float *a = m[0];
    const float *b = m[1];
    const float *c = m[2];
    const float *d = m[3];

    // Retail's accumulation order; the determinant's rounding depends on it.
    float acc = a[0] * b[1] * c[2];
    acc = acc + c[0] * a[1] * b[2];
    acc = acc + b[0] * c[1] * a[2];
    acc = acc - a[0] * c[1] * b[2];
    acc = acc - b[0] * a[1] * c[2];
    const float det = acc - c[0] * b[1] * a[2];
    const float q = vu0::Div(1.0f, det);

    const float *p[3] = {b, c, a};
    const float *s[3] = {c, a, b};
    float        rows[3][3];
    for (int k = 0; k < 3; k++) {
        rows[0][k] = p[k][1] * s[k][2] - p[k][2] * s[k][1];
        rows[1][k] = p[k][2] * s[k][0] - p[k][0] * s[k][2];
        rows[2][k] = p[k][0] * s[k][1] - p[k][1] * s[k][0];
    }

    float out[4][4];
    for (int r = 0; r < 3; r++) {
        for (int k = 0; k < 3; k++) {
            out[r][k] = vu0::Sat((0.0f + rows[r][k]) * q);
        }
        out[r][3] = vu0::Sat(0.0f * q);
    }

    for (int k = 0; k < 3; k++) {
        float t = vu0::Sat(out[0][k] * d[0]);
        t = vu0::Sat(t + vu0::Sat(out[1][k] * d[1]));
        t = vu0::Sat(t + vu0::Sat(out[2][k] * d[2]));
        out[3][k] = 0.0f - t;
    }
    out[3][3] = 1.0f;

    copy_matrix(inverse, out);
}

void mgApplyMatrixN(float (*out)[4], float (*matrix)[4], float (*in)[4], int count) {
    // Retail's do-while touches the first elements even for count < 1.
    if (count < 1) {
        return;
    }
    float m[4][4];
    copy_matrix(m, matrix);
    for (int i = 0; i < count; i++) {
        const float v[4] = {in[i][0], in[i][1], in[i][2], in[i][3]};
        vu0::Transform(out[i], m, v);
    }
}

void mgApplyMatrixN_MaxMin(float (*out)[4], float (*matrix)[4], float (*in)[4], int count,
                           float *max, float *min) {
    // Retail's do-while touches the first elements even for count < 1.
    if (count < 1) {
        return;
    }
    float m[4][4];
    copy_matrix(m, matrix);

    float v0[4];
    {
        const float v[4] = {in[0][0], in[0][1], in[0][2], in[0][3]};
        vu0::Transform(v0, m, v);
        for (int k = 0; k < 4; k++) {
            out[0][k] = v0[k];
        }
    }
    float hi[4];
    float lo[4];
    for (int k = 0; k < 4; k++) {
        hi[k] = add_vf0x(v0[k]);
        lo[k] = add_vf0x(v0[k]);
    }

    for (int i = 1; i < count; i++) {
        const float v[4] = {in[i][0], in[i][1], in[i][2], in[i][3]};
        float       r[4];
        vu0::Transform(r, m, v);
        for (int k = 0; k < 4; k++) {
            out[i][k] = r[k];
            hi[k] = vu0::Max(hi[k], r[k]);
            lo[k] = vu0::Min(lo[k], r[k]);
        }
    }

    for (int k = 0; k < 4; k++) {
        max[k] = hi[k];
        min[k] = lo[k];
    }
}

void mgVectorMinMaxN(float *max, float *min, float (*vectors)[4], int count) {
    // Retail's do-while touches the first elements even for count < 1.
    if (count < 1) {
        return;
    }
    float hi[4];
    float lo[4];
    for (int k = 0; k < 4; k++) {
        hi[k] = vectors[0][k];
        lo[k] = vectors[0][k];
    }
    for (int i = 1; i < count; i++) {
        for (int k = 0; k < 4; k++) {
            hi[k] = vu0::Max(hi[k], vectors[i][k]);
            lo[k] = vu0::Min(lo[k], vectors[i][k]);
        }
    }
    for (int k = 0; k < 4; k++) {
        max[k] = hi[k];
        min[k] = lo[k];
    }
}
