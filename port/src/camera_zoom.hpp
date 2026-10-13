#pragma once

#include "cameracontrol.hpp"

class CScene;

// A request belongs to the walking camera, not its temporary collision distance.
// The retail parameter sets are never retained or modified between updates.
struct CameraZoom {
    static constexpr float min_distance = 30.0f;
    static constexpr float max_distance = 600.0f;
    static constexpr float wheel_step = 8.0f;

    float requested = 0;
    bool  active = false;

    float HeightScale(CCameraControl &camera) const;
    void  Read(CCameraControl &camera, float wheel, bool reset, bool enabled);
    void  Move(CCameraControl &camera, CScene &scene, CCameraControl::Control &control, float *rotation,
               CCPoly *retail_polys = nullptr, int retail_count = 0);
};
