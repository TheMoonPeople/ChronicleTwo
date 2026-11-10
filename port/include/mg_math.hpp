#pragma once

#include "common.h"

#include <span>

#include "mg_drawenv.hpp"

/**
 * @file
 * Declares the engine's VU0 vector, bounding-box, matrix, intersection, angle, random-number and
 * table-sine helpers.
 */

/**
 *
 * How mgVectorInterpolate and mgAngleInterpolate move a value towards its target.
 *
 */
enum mgInterpolateMode {
    MG_INTERPOLATE_STEP = 0,     /**< Moves a fixed distance per call, snapping onto the target when closer than that. */
    MG_INTERPOLATE_FRACTION = 1, /**< Moves the remaining gap divided by the step value. */
};

/**
 *
 * Where a point lies relative to a triangle, as the triangle point tests report it.
 *
 */
enum mgPointPoly3Result {
    MG_POINT_POLY3_OUTSIDE = 0, /**< The point is outside the triangle. */
    MG_POINT_POLY3_INSIDE = 1,  /**< The point is strictly inside the triangle. */
    MG_POINT_POLY3_EDGE_01 = 2, /**< The point lies on the line through the first and second corners. */
    MG_POINT_POLY3_EDGE_12 = 3, /**< The point lies on the line through the second and third corners. */
    MG_POINT_POLY3_EDGE_20 = 4, /**< The point lies on the line through the third and first corners. */
};

/**
 *
 * Bits of the vector unit's status register that the box clip tests read.
 *
 */
enum mgVu0Status {
    MG_VU0_STATUS_SIGN_STICKY = 0x80, /**< Set once any result since the last clear was negative. */
};

/**
 *
 * Converts a vector of floats into integers with four fractional bits.
 *
 * @mangled mgFotI4__FPiPf
 * @address 0x12F840
 * @size 0x10
 */
void mgFotI4(int *out, float *in);

/**
 *
 * Writes the eight corners of the box between a maximum and a minimum corner.
 *
 * @mangled mgCreateBox8__FPA4_fPfPf
 * @address 0x12F850
 * @size 0x5C
 */
void mgCreateBox8(float (*corners)[4], float *max, float *min);

/**
 *
 * Sets all four components of a vector to zero.
 *
 * @mangled mgZeroVector__FPf
 * @address 0x12F8B0
 * @size 0x8
 */
void mgZeroVector(float *vector);

/**
 *
 * Sets a vector to the origin, with a w component of one.
 *
 * @mangled mgZeroVectorW__FPf
 * @address 0x12F8C0
 * @size 0x8
 */
void mgZeroVectorW(float *vector);

/**
 *
 * Returns whether a point lies inside a box on the x, y and z axes.
 *
 * @mangled mgClipBoxVertex__FPfPfPf
 * @address 0x12F8D0
 * @size 0x40
 */
int mgClipBoxVertex(float *point, float *max, float *min);

/**
 *
 * Returns whether two boxes overlap on the x, y and z axes.
 *
 * @mangled mgClipBox__FPfPfPfPf
 * @address 0x12F910
 * @size 0x44
 */
int mgClipBox(float *max0, float *min0, float *max1, float *min1);

/**
 *
 * Returns whether two boxes overlap on the x, y and w axes.
 *
 * @mangled mgClipBoxW__FPfPfPfPf
 * @address 0x12F960
 * @size 0x44
 */
int mgClipBoxW(float *max0, float *min0, float *max1, float *min1);

/**
 *
 * Returns whether the first box lies entirely inside the second on the x, y and z axes.
 *
 * @mangled mgClipInBox__FPfPfPfPf
 * @address 0x12F9B0
 * @size 0x44
 */
int mgClipInBox(float *max0, float *min0, float *max1, float *min1);

/**
 *
 * Returns whether the first box lies entirely inside the second on the x, y and w axes.
 *
 * @mangled mgClipInBoxW__FPfPfPfPf
 * @address 0x12FA00
 * @size 0x44
 */
int mgClipInBoxW(float *max0, float *min0, float *max1, float *min1);

/**
 *
 * Adds a vector into another.
 *
 * @mangled mgAddVector__FPfPf
 * @address 0x12FA50
 * @size 0x14
 */
void mgAddVector(float *vector, float *add);

/**
 *
 * Subtracts a vector from another.
 *
 * @mangled mgSubVector__FPfPf
 * @address 0x12FA70
 * @size 0x14
 */
void mgSubVector(float *vector, float *sub);

/**
 *
 * Writes a vector pointing the same way as another, with the given length.
 *
 * @mangled mgNormalizeVector__FPfPff
 * @address 0x12FA90
 * @size 0x44
 */
void mgNormalizeVector(float *out, float *in, float length);

/**
 *
 * Writes the per-component minimum of two vectors.
 *
 * @mangled mgVectorMin__FPfPfPf
 * @address 0x12FAE0
 * @size 0x14
 */
void mgVectorMin(float *min, float *a, float *b);

/**
 *
 * Writes the per-component minimum of four vectors.
 *
 * @mangled mgVectorMin__FPfPfPfPfPf
 * @address 0x12FB00
 * @size 0x24
 */
void mgVectorMin(float *min, float *a, float *b, float *c, float *d);

/**
 *
 * Writes the per-component maximum and minimum of two vectors.
 *
 * @mangled mgVectorMaxMin__FPfPfPfPf
 * @address 0x12FB30
 * @size 0x1C
 */
void mgVectorMaxMin(float *max, float *min, float *a, float *b);

/**
 *
 * Writes the per-component maximum and minimum of three vectors.
 *
 * @mangled mgVectorMaxMin__FPfPfPfPfPf
 * @address 0x12FB50
 * @size 0x28
 */
void mgVectorMaxMin(float *max, float *min, float *a, float *b, float *c);

/**
 *
 * Writes the per-component maximum and minimum of four vectors.
 *
 * @mangled mgVectorMaxMin__FPfPfPfPfPfPf
 * @address 0x12FB80
 * @size 0x34
 */
void mgVectorMaxMin(float *max, float *min, float *a, float *b, float *c, float *d);

/**
 *
 * Grows a box so that it also encloses another box.
 *
 * @mangled mgBoxMaxMin__FP9mgVu0FBOXP9mgVu0FBOX
 * @address 0x12FBC0
 * @size 0x34
 */
void mgBoxMaxMin(mgVu0FBOX *box, mgVu0FBOX *other);

/**
 *
 * Writes the unnormalised normal of the plane through three points.
 *
 * @mangled mgPlaneNormal__FPfPfPfPf
 * @address 0x12FC00
 * @size 0x24
 */
void mgPlaneNormal(float *normal, float *v0, float *v1, float *v2);

/**
 *
 * Returns the signed distance of a point from a plane, along the plane's normal.
 *
 * @mangled mgDistPlanePoint__FPfPfPf
 * @address 0x12FC30
 * @size 0x40
 */
float mgDistPlanePoint(float *normal, float *on_plane, float *point);

/**
 *
 * Returns the distance from a point to a line segment and writes the nearest point on the segment.
 *
 * @mangled mgDistLinePoint__FPfPfPfPf
 * @address 0x12FC70
 * @size 0x164
 */
float mgDistLinePoint(float *point, float *start, float *end, float *nearest);

/**
 *
 * Writes the reflection of a point's offset in a plane and returns twice the point's distance from it.
 *
 * @mangled mgReflectionPlane__FPfPfPfPf
 * @address 0x12FDE0
 * @size 0x90
 */
float mgReflectionPlane(float *normal, float *on_plane, float *point, float *reflection);

/**
 *
 * Writes up to two segment crossings of a sphere at the origin, rejecting invalid segments and output spans smaller than two points.
 *
 * @mangled mgIntersectionSphereLine0__FfPfPfPA4_f
 * @address 0x12FE70
 * @size 0x194
 */
int mgIntersectionSphereLine0(float radius, float *from, float *to, std::span<float[4]> hits);

/**
 *
 * Writes up to two segment crossings of a sphere, rejecting output spans smaller than two points.
 *
 * @mangled mgIntersectionSphereLine__FPfPfPfPA4_f
 * @address 0x130010
 * @size 0xC0
 */
int mgIntersectionSphereLine(float *sphere, float *from, float *to, std::span<float[4]> hits);

/**
 *
 * Writes where a line meets a triangle's plane and returns whether that point is inside the triangle.
 *
 * @mangled mgIntersectionPoint_line_poly3__FPfPfPfPfPfPfPf
 * @address 0x1300D0
 * @size 0x11C
 */
int mgIntersectionPoint_line_poly3(float *from, float *to, float *v0, float *v1, float *v2, float *normal, float *hit);

/**
 *
 * Returns whether a point on a triangle's plane lies inside the triangle.
 *
 * @mangled mgCheckPointPoly3_XYZ__FPfPfPfPfPf
 * @address 0x1301F0
 * @size 0x1A0
 */
int mgCheckPointPoly3_XYZ(float *point, float *v0, float *v1, float *v2, float *normal);

/**
 *
 * Returns where a point lies relative to a triangle seen from above, as an mgPointPoly3Result.
 *
 * @mangled mgCheckPointPoly3_XZ__FPfPfPfPf
 * @address 0x130390
 * @size 0x24
 */
int mgCheckPointPoly3_XZ(float *point, float *v0, float *v1, float *v2);

/**
 *
 * Returns the length of a vector.
 *
 * @mangled mgDistVector__FPf
 * @address 0x130650
 * @size 0x30
 */
float mgDistVector(float *vector);

/**
 *
 * Returns the length of a vector on the horizontal plane.
 *
 * @mangled mgDistVectorXZ__FPf
 * @address 0x130680
 * @size 0x2C
 */
float mgDistVectorXZ(float *vector);

/**
 *
 * Returns the squared length of a vector.
 *
 * @mangled mgDistVector2__FPf
 * @address 0x1306B0
 * @size 0x28
 */
float mgDistVector2(float *vector);

/**
 *
 * Returns the distance between two positions.
 *
 * @mangled mgDistVector__FPfPf
 * @address 0x1306E0
 * @size 0x38
 */
float mgDistVector(float *a, float *b);

/**
 *
 * Returns the distance between two positions on the horizontal plane.
 *
 * @mangled mgDistVectorXZ__FPfPf
 * @address 0x130720
 * @size 0x34
 */
float mgDistVectorXZ(float *a, float *b);

/**
 *
 * Returns the squared distance between two positions.
 *
 * @mangled mgDistVector2__FPfPf
 * @address 0x130760
 * @size 0x30
 */
float mgDistVector2(float *a, float *b);

/**
 *
 * Returns the squared distance between two positions on the horizontal plane.
 *
 * @mangled mgDistVectorXZ2__FPfPf
 * @address 0x130790
 * @size 0x2C
 */
float mgDistVectorXZ2(float *a, float *b);

/**
 *
 * Sets a matrix to the identity.
 *
 * @mangled mgUnitMatrix__FPA4_f
 * @address 0x1307C0
 * @size 0x20
 */
void mgUnitMatrix(float (*matrix)[4]);

/**
 *
 * Sets every element of a matrix to zero.
 *
 * @mangled mgZeroMatrix__FPA4_f
 * @address 0x1307E0
 * @size 0x18
 */
void mgZeroMatrix(float (*matrix)[4]);

/**
 *
 * Writes the product of two matrices.
 *
 * @mangled mgMulMatrix__FPA4_fPA4_fPA4_f
 * @address 0x1308D0
 * @size 0x74
 */
void mgMulMatrix(float (*product)[4], float (*left_matrix)[4], float (*right_matrix)[4]);

/**
 *
 * Writes the inverse of a rotation-and-translation matrix.
 *
 * @mangled mgInversMatrix__FPA4_fPA4_f
 * @address 0x130950
 * @size 0xF4
 */
void mgInversMatrix(float (*inverse)[4], float (*matrix)[4]);

/**
 *
 * Sets a matrix to a rotation about the x axis.
 *
 * @mangled mgRotMatrixX__FPA4_ff
 * @address 0x130A50
 * @size 0x54
 */
void mgRotMatrixX(float (*matrix)[4], float angle_x);

/**
 *
 * Sets a matrix to a rotation about the y axis.
 *
 * @mangled mgRotMatrixY__FPA4_ff
 * @address 0x130AB0
 * @size 0x54
 */
void mgRotMatrixY(float (*matrix)[4], float angle_y);

/**
 *
 * Sets a matrix to a rotation about the z axis.
 *
 * @mangled mgRotMatrixZ__FPA4_ff
 * @address 0x130B10
 * @size 0x54
 */
void mgRotMatrixZ(float (*matrix)[4], float angle_z);

/**
 *
 * Sets a matrix to the rotation given by angles about the x, y and z axes.
 *
 * @mangled mgRotMatrixXYZ__FPA4_fPf
 * @address 0x130B70
 * @size 0x60
 */
void mgRotMatrixXYZ(float (*matrix)[4], float *rotation);

/**
 *
 * Sets a matrix to a rotation about the y axis followed by a move to a position.
 *
 * @mangled mgCreateMatrixPY__FPA4_fPff
 * @address 0x130BD0
 * @size 0x5C
 */
void mgCreateMatrixPY(float (*matrix)[4], float *position, float angle_y);

/**
 *
 * Sets a matrix to the rotation that turns the z axis to face a direction.
 *
 * @mangled mgLookAtMatrixZ__FPA4_fPf
 * @address 0x130C30
 * @size 0xD4
 */
void mgLookAtMatrixZ(float (*matrix)[4], float *direction);

/**
 *
 * Sets a matrix to the projection of points along a light direction onto a plane.
 *
 * @mangled mgShadowMatrix__FPA4_fPfPfPf
 * @address 0x130D10
 * @size 0x20C
 */
void mgShadowMatrix(float (*matrix)[4], const float (&light_direction)[4], const float (&on_plane)[4], const float (&plane_normal)[4]);

/**
 *
 * Transforms a run of vectors by a matrix.
 *
 * @mangled mgApplyMatrixN__FPA4_fPA4_fPA4_fi
 * @address 0x130F20
 * @size 0x50
 */
void mgApplyMatrixN(float (*out)[4], float (*matrix)[4], float (*in)[4], int count);

/**
 *
 * Transforms a run of vectors by a matrix and writes the bounds of the results.
 *
 * @mangled mgApplyMatrixN_MaxMin__FPA4_fPA4_fPA4_fiPfPf
 * @address 0x130F70
 * @size 0x84
 */
void mgApplyMatrixN_MaxMin(float (*out)[4], float (*matrix)[4], float (*in)[4], int count, float *max, float *min);

/**
 *
 * Writes the per-component maximum and minimum over a run of vectors.
 *
 * @mangled mgVectorMinMaxN__FPfPfPA4_fi
 * @address 0x131000
 * @size 0x58
 */
void mgVectorMinMaxN(float *max, float *min, float (*vectors)[4], int count);

/**
 *
 * Writes the bounds of a box after it is transformed by a matrix.
 *
 * @mangled mgApplyMatrix__FPfPfPA4_fPfPf
 * @address 0x131060
 * @size 0x64
 */
void mgApplyMatrix(float *max, float *min, float (*matrix)[4], float *box_max, float *box_min);

/**
 *
 * Writes a position moved from one point towards another in the way an mgInterpolateMode gives.
 *
 * @mangled mgVectorInterpolate__FPfPfPffi
 * @address 0x1310D0
 * @size 0x10C
 */
void mgVectorInterpolate(float *out, float *from, float *to, float step, int mode);

/**
 *
 * Returns an angle turned from one angle towards another, by the shorter way, as an mgInterpolateMode gives.
 *
 * @mangled mgAngleInterpolate__Ffffi
 * @address 0x1311E0
 * @size 0x1A4
 */
float mgAngleInterpolate(float from, float to, float step, int mode);

/**
 *
 * Returns 1, -1 or 0 as the first angle is ahead of, behind or within a tolerance of the second.
 *
 * @mangled mgAngleCmp__Ffff
 * @address 0x131390
 * @size 0xBC
 */
int mgAngleCmp(float a, float b, float tolerance);

/**
 *
 * Wraps an angle into the half turn either side of zero.
 *
 * @mangled mgAngleLimit__Ff
 * @address 0x131450
 * @size 0x104
 */
float mgAngleLimit(float angle);

/**
 *
 * Returns a random number in the half-open interval from zero to one.
 *
 * @mangled mgRnd__Fv
 * @address 0x131560
 * @size 0x3C
 */
float mgRnd();

/**
 *
 * Returns a random number spread about zero roughly as a normal distribution.
 *
 * @mangled mgNRnd__Fv
 * @address 0x1315A0
 * @size 0x8C
 */
float mgNRnd();

/**
 *
 * Returns a bounded, quantized sine sample, treating non-finite angles as zero.
 *
 * @mangled mgSinf__Ff
 * @address 0x1316D0
 * @size 0x98
 */
float mgSinf(float angle);

/**
 *
 * Returns a bounded, quantized cosine sample, treating non-finite angles as zero.
 *
 * @mangled mgCosf__Ff
 * @address 0x131770
 * @size 0x14
 */
float mgCosf(float angle);

/**
 * Premultiplies a matrix by the second transform and then the third transform.
 */
void MulMatrix3(float (*matrix)[4], float (*second)[4], float (*third)[4]);
