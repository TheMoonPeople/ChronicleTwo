#pragma once

#include <cstdint>

#include "gfx/gfx.hpp"

class CScene;
class CCameraControl;
class CPadControl;

struct FixedMouseLook {
    float         yaw = 0, pitch = 0;
    std::uint64_t read = 0;

    // Display-frame time, in seconds. A rejected owner drops the sample and offset.
    void Update(bool owns, std::uint64_t sample, float x, float y, double seconds);

    [[nodiscard]] bool Active() const { return yaw != 0 || pitch != 0; }
};

bool            TownMouseFixedOwns(CCameraControl *camera, CScene *scene, CPadControl *pad,
                                   bool walking, bool fixed, bool locked, bool enabled);
CCameraControl *TownMouseFixedOwner();

// Borrow geometry/resources into a display-only list; no destruction ownership is copied.
void MouseFixedDisplayList(const gfx::DisplayList &source, gfx::DisplayList &out, float yaw, float pitch);
bool MouseFixedActive(double seconds);
// The current look offset, as the last MouseFixedActive left it.
void  MouseFixedLook(float &yaw, float &pitch);
float MouseFixedCullRadius(float focal_x, float focal_y, float half_width, float half_height);
bool  MouseFixedRender(const gfx::DisplayList &list, float alpha, const gfx::RenderOptions &options,
                       double seconds);
// MouseFixedRender at the given look offset, with previous as the tick before. Does not advance the look.
bool MouseFixedRenderAt(const gfx::DisplayList &list, const gfx::DisplayList *previous, float yaw, float pitch,
                        float alpha, const gfx::RenderOptions &options);
