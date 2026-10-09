#pragma once

#include "common.h"

/**
 * @file
 * Declares the tests that find where pipes, spheres and line segments meet triangles and boxes.
 */

struct mgVu0FBOX;
struct RS_STACKDATA;

/**
 *
 * How a sphere touches a triangle, as IntersectionSpherePoly3 reports it.
 *
 */
// clang-format off
enum SpherePoly3Contact {
    SPHERE_POLY3_NONE   = 0, /**< The sphere does not touch the triangle. */
    SPHERE_POLY3_FACE   = 1, /**< The sphere's centre projects inside the triangle's face. */
    SPHERE_POLY3_VERTEX = 2, /**< A corner of the triangle lies inside the sphere. */
    SPHERE_POLY3_EDGE   = 3, /**< An edge of the triangle passes through the sphere. */
};

// clang-format on

/**
 *
 * Finds the points of a triangle that a vertical pipe of infinite height meets, lifted onto the triangle's plane, and gives back how many it found.
 *
 * @mangled IntersectionPipeYPoly3__FPfPA4_fPfPA4_f
 * @address 0x2E2DE0
 * @size 0x3F0
 */
int IntersectionPipeYPoly3(float *pipe, float (*poly)[4], float *normal, float (*hits)[4]);

/**
 *
 * Finds the points of a triangle that a pipe running from a point along a direction meets, and gives back how many it found.
 *
 * @mangled IntersectionPipePoly3__FPfPfPA4_fPfPA4_f
 * @address 0x2E31D0
 * @size 0x270
 */
int IntersectionPipePoly3(float *pipe, float *axis, float (*tri)[4], float *offset, float (*hits)[4]);

/**
 *
 * Tests a sphere against a triangle, giving back the push out of the triangle's plane and how they touch.
 *
 * @mangled IntersectionSpherePoly3__FPfPA4_fPfPf
 * @address 0x2E3440
 * @size 0x210
 */
int IntersectionSpherePoly3(float *sphere, float (*tri)[4], float *normal, float *push);

/**
 *
 * Finds up to two points where a line segment crosses the faces of an axis-aligned box, nearest first, and gives back how many it found.
 *
 * @mangled IntersectionBox__FPfPfP9mgVu0FBOXPA4_f
 * @address 0x2E3650
 * @size 0x4B0
 */
int IntersectionBox(float *from, float *to, mgVu0FBOX *box, float (*hits)[4]);

/**
 *
 * Finds up to two points where a line segment crosses the faces of a box placed by a matrix, nearest first, and gives back how many it found.
 *
 * @mangled IntersectionBox__FPfPfP9mgVu0FBOXPA4_fPA4_f
 * @address 0x2E3B00
 * @size 0x100
 */
int IntersectionBox(float *start, float *end, mgVu0FBOX *box, float (*matrix)[4], float (*hits)[4]);

/**
 *
 * Test routine with a script command's parameters that ignores them and always gives back one.
 *
 * @mangled mt_test__FP12RS_STACKDATAi
 * @address 0x2E3C00
 * @size 0x10
 */
int mt_test(RS_STACKDATA *args, int count);
