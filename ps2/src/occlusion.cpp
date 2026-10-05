#include "common.h"
#include "occlusion.hpp"
#include "mg_math.hpp"

// Code (.text)
void COcclusion::Setup(float (*view_matrix)[4]) {
    float points[4][4];
    float origin[4];
    if (enable == 0) {
        return;
    }
    setup = 1;
    mgApplyMatrixN(&points[0], view_matrix, vertex, 4);
    float *p1 = points[1];
    float *p2 = points[2];
    float *p3 = points[3];
    mgVectorMin(view_min, points[0], p1, p2, p3);
    mgZeroVector(origin);
    mgPlaneNormal(plane, p2, p1, points[0]);
    sceVu0Normalize(plane, plane);
    plane[3] = -sceVu0InnerProduct(plane, points[0]);
    if (!(plane[3] <= 0.0f)) {
        mgPlaneNormal(plane, points[0], p1, p2);
        sceVu0Normalize(plane, plane);
        plane[3] = -sceVu0InnerProduct(plane, points[0]);
        mgPlaneNormal(side_plane[0], origin, p1, p2);
        mgPlaneNormal(side_plane[1], origin, p3, points[0]);
        mgPlaneNormal(side_plane[2], origin, points[0], p1);
        mgPlaneNormal(side_plane[3], origin, p2, p3);
    } else {
        mgPlaneNormal(side_plane[0], origin, p2, p1);
        mgPlaneNormal(side_plane[1], origin, points[0], p3);
        mgPlaneNormal(side_plane[2], origin, p1, points[0]);
        mgPlaneNormal(side_plane[3], origin, p3, p2);
    }
    sceVu0Normalize(side_plane[0], side_plane[0]);
    side_plane[0][3] = 0;
    sceVu0Normalize(side_plane[1], side_plane[1]);
    side_plane[1][3] = 0;
    sceVu0Normalize(side_plane[2], side_plane[2]);
    side_plane[2][3] = 0;
    sceVu0Normalize(side_plane[3], side_plane[3]);
    side_plane[3][3] = 0;
}

int COcclusion::CheckSphere(float *sphere) {
    if (enable == 0 || setup == 0) {
        return 0;
    }
    if (!(view_min[2] <= sphere[2] - sphere[3])) {
        return 0;
    }
    float distance = sceVu0InnerProduct(plane, sphere);
    distance += plane[3];
    if (distance < sphere[3]) {
        return 0;
    }
    if (sceVu0InnerProduct(side_plane[0], sphere) < sphere[3]) {
        return 0;
    }
    if (sceVu0InnerProduct(side_plane[1], sphere) < sphere[3]) {
        return 0;
    }
    if (sceVu0InnerProduct(side_plane[2], sphere) < sphere[3]) {
        return 0;
    }
    if (sceVu0InnerProduct(side_plane[3], sphere) < sphere[3]) {
        return 0;
    }
    return 1;
}
