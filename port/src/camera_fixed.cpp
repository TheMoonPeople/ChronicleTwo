#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstring>
#include <limits>
#include <numbers>

#include "camera_fixed.hpp"
#include "cameracontrol.hpp"
#include "gfx/displaylist.hpp"
#include "mainloop.hpp"
#include "platform/input.hpp"
#include "scenesnd.hpp"

void FixedMouseLook::Update(bool owns, std::uint64_t sample, float x, float y, double seconds) {
    const bool fresh = sample != read;
    read = sample;
    if (!owns) {
        yaw = pitch = 0;
        return;
    }
    if (fresh && std::isfinite(x) && std::isfinite(y)) {
        constexpr float degree = std::numbers::pi_v<float> / 180;
        yaw = std::clamp(yaw + x * 0.5f, -15 * degree, 15 * degree);
        pitch = std::clamp(pitch + y * 0.5f, -10 * degree, 10 * degree);
    }
    if (std::isfinite(seconds) && seconds > 0) {
        const float ease = std::exp(-4.0 * seconds);
        yaw *= ease;
        pitch *= ease;
    }
    if (std::fabs(yaw) < 0.000001f) {
        yaw = 0;
    }
    if (std::fabs(pitch) < 0.000001f) {
        pitch = 0;
    }
}

bool TownMouseFixedOwns(CCameraControl *camera, CScene *scene, CPadControl *pad,
                        bool walking, bool fixed, bool locked, bool enabled) {
    return enabled && walking && fixed && !locked && camera && scene && pad &&
           !scene->event_run && scene->active_camera == 0 && scene->GetCamera(0) == camera &&
           !camera->control_on && !camera->suspended && !mgCCamera::StopCamera;
}

namespace {
using Matrix = gfx::detail::Mat4;
using gfx::detail::Multiply;

Matrix Read(const float *p) {
    Matrix m;
    std::memcpy(m.data(), p, sizeof(float) * 16);
    return m;
}

// Perspective projections and shadow middle transforms need a full inverse.
bool Inverse(const Matrix &m, Matrix &out) {
    double a[4][8]{};
    for (int r = 0; r < 4; ++r) {
        for (int c = 0; c < 4; ++c) {
            a[r][c] = m[c * 4 + r];
        }
        a[r][r + 4] = 1;
    }
    for (int c = 0; c < 4; ++c) {
        int pivot = c;
        for (int r = c + 1; r < 4; ++r) {
            if (std::fabs(a[r][c]) > std::fabs(a[pivot][c])) {
                pivot = r;
            }
        }
        if (!std::isfinite(a[pivot][c]) || std::fabs(a[pivot][c]) < 1e-12) {
            return false;
        }
        for (int k = 0; k < 8; ++k) {
            std::swap(a[c][k], a[pivot][k]);
        }
        const double scale = a[c][c];
        for (double &v : a[c]) {
            v /= scale;
        }
        for (int r = 0; r < 4; ++r) {
            if (r != c) {
                const double factor = a[r][c];
                for (int k = 0; k < 8; ++k) {
                    a[r][k] -= factor * a[c][k];
                }
            }
        }
    }
    for (int r = 0; r < 4; ++r) {
        for (int c = 0; c < 4; ++c) {
            out[c * 4 + r] = a[r][c + 4];
            if (!std::isfinite(out[c * 4 + r])) {
                return false;
            }
        }
    }
    return true;
}

Matrix Rotation(float yaw, float pitch) {
    Matrix y = Read(gfx::IdentityMeshTransform().view), x = y;
    y[0] = y[10] = std::cos(yaw);
    y[8] = std::sin(yaw);
    y[2] = -y[8];
    x[5] = x[10] = std::cos(pitch);
    x[9] = -std::sin(pitch);
    x[6] = -x[9];
    return Multiply(x, y);
}

int MainCamera(const gfx::DisplayList &list) {
    auto target = gfx::kMainTarget;
    for (const auto &entry : list.entries) {
        if (const auto *t = std::get_if<gfx::detail::TargetEntry>(&entry)) {
            target = t->target;
        }
        if (const auto *mesh = std::get_if<gfx::detail::MeshEntry>(&entry)) {
            const auto &r = list.records[mesh->record];
            if (target == gfx::kMainTarget && r.has_transform) {
                return r.camera;
            }
        }
    }
    return -1;
}
} // namespace

void MouseFixedDisplayList(const gfx::DisplayList &source, gfx::DisplayList &out, float yaw, float pitch) {
    // Lists only borrow the original resources. In particular, never copy doomed_*.
    out.instance = source.instance;
    out.serial = source.serial;
    out.entries = source.entries;
    out.records = source.records;
    out.cameras = source.cameras;
    out.scenes = source.scenes;
    out.prog0_blocks = source.prog0_blocks;
    out.cut = source.cut;
    out.camera_cut = source.camera_cut;
    out.needs_base = source.needs_base;
    out.tagged_2d = source.tagged_2d;
    out.scene = source.scene;
    out.target_scenes = source.target_scenes;
    out.main_cleared = source.main_cleared;
    out.occurrences = source.occurrences;
    out.occurrences_2d = source.occurrences_2d;
    out.cache = {};
    const int camera = MainCamera(source);
    if (camera < 0 || (yaw == 0 && pitch == 0)) {
        return;
    }
    const Matrix rotate = Rotation(-yaw, -pitch);
    // Offscreen character outlines use the same camera; unrelated views stay retail.
    std::vector<bool> moved(source.cameras.size());
    for (size_t i = 0; i < moved.size(); ++i) {
        moved[i] = source.cameras[i] == source.cameras[camera];
        if (moved[i]) {
            out.cameras[i] = Multiply(rotate, source.cameras[i]);
        }
    }
    for (const auto &r : source.records) {
        if (!r.has_transform || !moved[r.camera]) {
            continue;
        }
        auto        &mesh = std::get<gfx::detail::MeshEntry>(out.entries[r.entry]);
        const Matrix eye = Multiply(Multiply(source.cameras[r.camera], r.middle), r.model);
        const Matrix turned_eye = Multiply(Multiply(out.cameras[r.camera], r.middle), r.model);
        const Matrix mvp = Multiply(r.projection, Multiply(turned_eye, r.local));
        std::memcpy(mesh.constants.mvp, mvp.data(), sizeof mesh.constants.mvp);
        if (mesh.prog0 >= 0) {
            auto  &block = out.prog0_blocks[mesh.prog0];
            Matrix back;
            if (Inverse(eye, back)) {
                const Matrix clip = Multiply(Multiply(Read(block.clip_or_view), back), turned_eye);
                std::memcpy(block.clip_or_view, clip.data(), sizeof block.clip_or_view);
            }
        }
    }
    for (auto &entry : out.entries) {
        auto *sprite = std::get_if<gfx::detail::Draw2DEntry>(&entry);
        if (!sprite || sprite->scene < 0) {
            continue;
        }
        const auto &scene = source.scenes[sprite->scene];
        if (!moved[scene.camera]) {
            continue;
        }
        Matrix back;
        if (!Inverse(scene.projection, back)) {
            continue;
        }
        const Matrix carry = Multiply(Multiply(scene.projection, rotate), back);
        auto         vertices = sprite->vertices;
        bool         valid = true;
        for (auto &v : vertices) {
            const float in[] = {v.x * scene.to_clip[0] + scene.to_clip[2],
                                v.y * scene.to_clip[1] + scene.to_clip[3], v.z, 1};
            float       clip[4]{};
            for (int r = 0; r < 4; ++r) {
                for (int c = 0; c < 4; ++c) {
                    clip[r] += carry[c * 4 + r] * in[c];
                }
            }
            if (!(clip[3] > 1e-6f)) {
                valid = false;
                break;
            }
            v.x = (clip[0] / clip[3] - scene.to_clip[2]) / scene.to_clip[0];
            v.y = (clip[1] / clip[3] - scene.to_clip[3]) / scene.to_clip[1];
            v.z = clip[2] / clip[3];
        }
        if (valid) {
            sprite->vertices = std::move(vertices);
        }
    }
}

namespace {
FixedMouseLook display_look;
}

bool MouseFixedActive(double seconds) {
    auto                      &look = display_look;
    static CCameraControl     *owner = nullptr;
    static int                 map = -1, submap = -1, active_map = -1;
    const auto                 sample = InputPeekMouseLookTotal();
    static InputMouseLookTotal before;
    static std::uint64_t       display_sample = 0;
    auto                      *camera = TownMouseFixedOwner();
    CScene                    *scene = camera ? GetMainScene() : nullptr;
    if (owner != camera || (scene && (map != scene->now_map_no || submap != scene->now_sub_map_no ||
                                      active_map != scene->active_map))) {
        look = {};
        before = sample;
        owner = camera;
        map = scene ? scene->now_map_no : -1;
        submap = scene ? scene->now_sub_map_no : -1;
        active_map = scene ? scene->active_map : -1;
    }
    if (before.epoch != sample.epoch) {
        look = {};
        before = sample;
    }
    look.Update(camera != nullptr, ++display_sample, sample.yaw - before.yaw,
                sample.pitch - before.pitch, seconds);
    before = sample;
    return look.Active();
}

bool MouseFixedRender(const gfx::DisplayList &list, float alpha, const gfx::RenderOptions &options,
                      double seconds) {
    const bool  active = MouseFixedActive(seconds);
    const auto &look = display_look;
    if (!active || options.canonical) {
        return gfx::RenderList(list, alpha, options);
    }
    // Reuse storage across displays; geometry and resource handles remain borrowed.
    static gfx::DisplayList turned, previous;
    MouseFixedDisplayList(list, turned, look.yaw, look.pitch);
    auto render = options;
    if (options.previous) {
        MouseFixedDisplayList(*options.previous, previous, look.yaw, look.pitch);
        render.previous = &previous;
    }
    return gfx::RenderList(turned, alpha, render);
}

float MouseFixedCullRadius(float focal_x, float focal_y, float half_width, float half_height) {
    // A cone around the outermost visible corner encloses every combination of
    // the bounded 15-degree yaw and 10-degree pitch. Keep the original draw pose.
    const float angle = std::atan(std::hypot(half_width / focal_x, half_height / focal_y)) +
                        25 * std::numbers::pi_v<float> / 180;
    if (!(focal_x > 0 && focal_y > 0) || angle >= std::numbers::pi_v<float> / 2) {
        return std::numeric_limits<float>::max() / 4;
    }
    return std::max(focal_x, focal_y) * std::tan(angle);
}
