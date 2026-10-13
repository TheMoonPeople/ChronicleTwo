#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <algorithm>
#include <cmath>
#include <cstring>
#include <numbers>

#include "camera_fixed.hpp"
#include "cameracontrol.hpp"
#include "editctrl.hpp"
#include "editloop.hpp"
#include "gfx/displaylist.hpp"
#include "gfx_fixture.hpp"
#include "mainloop.hpp"
#include "options/rows.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "platform/mouse.hpp"
#include "present.hpp"
#include "scenesnd.hpp"

TEST(CameraFixedMouse, BoundsDecayAndDisplayRateIndependence) {
    FixedMouseLook look;
    look.Update(true, 1, 100, -100, 0);
    EXPECT_NEAR(look.yaw, 15 * std::numbers::pi_v<float> / 180, 1e-6f);
    EXPECT_NEAR(look.pitch, -10 * std::numbers::pi_v<float> / 180, 1e-6f);
    auto fast = look, slow = look;
    for (int frame = 0; frame < 144; ++frame) {
        fast.Update(true, 1, 100, -100, 1.0 / 144);
    }
    for (int frame = 0; frame < 25; ++frame) {
        slow.Update(true, 1, 100, -100, 1.0 / 25);
    }
    EXPECT_NEAR(fast.yaw, slow.yaw, 1e-6f);
    EXPECT_NEAR(fast.pitch, slow.pitch, 1e-6f);
    EXPECT_GT(slow.yaw, 0);
    EXPECT_LT(slow.yaw, look.yaw * 0.02f);
    for (int frame = 0; frame < 4 * 144; ++frame) {
        fast.Update(true, 1, 100, -100, 1.0 / 144);
    }
    EXPECT_FALSE(fast.Active());
    // Smaller display steps visibly ease even without another pad read.
    look.Update(true, 1, 100, -100, 1.0 / 144);
    EXPECT_LT(look.yaw, 15 * std::numbers::pi_v<float> / 180);
}

TEST(CameraFixedMouse, RejectedOwnersDropMotionAndInvalidSamplesDoNotPoisonTheView) {
    FixedMouseLook look;
    look.Update(false, 1, 1, 1, 0);
    look.Update(true, 1, 1, 1, 0);
    EXPECT_FALSE(look.Active());
    look.Update(true, 2, 0.2f, 0.1f, 0);
    EXPECT_TRUE(look.Active());
    look.Update(true, 3, NAN, INFINITY, NAN);
    EXPECT_FLOAT_EQ(look.yaw, 0.1f);
    EXPECT_FLOAT_EQ(look.pitch, 0.05f);
    look.Update(false, 4, 1, 1, 0);
    EXPECT_FALSE(look.Active());
    look.Update(true, 4, 1, 1, 0);
    EXPECT_FALSE(look.Active());
}

TEST(CameraFixedMouse, OwnershipExcludesEventsMenusControllableCamerasAndDisabledSetting) {
    CScene         scene;
    CCameraControl camera;
    CPadControl    pad{};
    camera.ControlOff();
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    // CScene leaves event_run to the zeroed storage of the retail global; a local holds garbage.
    scene.event_run = 0;
    EXPECT_TRUE(TownMouseFixedOwns(&camera, &scene, &pad, true, true, false, true));
    EXPECT_FALSE(TownMouseFixedOwns(&camera, &scene, &pad, false, true, false, true));
    EXPECT_FALSE(TownMouseFixedOwns(&camera, &scene, &pad, true, false, false, true));
    EXPECT_FALSE(TownMouseFixedOwns(&camera, &scene, &pad, true, true, true, true));
    EXPECT_FALSE(TownMouseFixedOwns(&camera, &scene, &pad, true, true, false, false));
    scene.event_run = 1;
    EXPECT_FALSE(TownMouseFixedOwns(&camera, &scene, &pad, true, true, false, true));
    scene.event_run = 0;
    camera.ControlOn();
    EXPECT_FALSE(TownMouseFixedOwns(&camera, &scene, &pad, true, true, false, true));
    camera.ControlOff();
    camera.suspended = 1;
    EXPECT_FALSE(TownMouseFixedOwns(&camera, &scene, &pad, true, true, false, true));
}

TEST(CameraFixedMouse, OptionDefaultsOnAndRoundTripsThroughItsSettingsRow) {
    EXPECT_TRUE(ConfigParse("{}").mouse_fixed_look);
    auto config = ConfigParse(R"({"input":{"mouse_fixed_look":false}})");
    EXPECT_FALSE(config.mouse_fixed_look);
    EXPECT_EQ(ConfigParse(ConfigSerialize(config)), config);
    bool found = false;
    for (const auto &page : options::Pages()) {
        for (const auto &row : page.rows) {
            if (row.key != "input.mouse_fixed_look") {
                continue;
            }
            found = true;
            EXPECT_STREQ(page.name, "Controls");
            EXPECT_TRUE(options::StepRow(row, config, 1));
            EXPECT_TRUE(config.mouse_fixed_look);
        }
    }
    EXPECT_TRUE(found);
}

TEST(CameraFixedMouse, DisplayRotationKeepsEyePositionGameplayListUiAndOtherViewsUnchanged) {
    gfx::DisplayList  source, turned;
    auto              identity = gfx::IdentityMeshTransform();
    gfx::detail::Mat4 view;
    std::copy_n(identity.view, 16, view.data());
    view[12] = -10;
    view[13] = -20;
    view[14] = -30;
    source.cameras = {view, gfx::detail::Mat4{}};
    source.doomed_textures.push_back(123);
    gfx::detail::MeshRecord record;
    record.has_transform = true;
    std::copy_n(identity.projection, 16, record.projection.data());
    std::copy_n(identity.middle, 16, record.middle.data());
    std::copy_n(identity.model, 16, record.model.data());
    std::copy_n(identity.local, 16, record.local.data());
    record.entry = 0;
    source.records.push_back(record);
    gfx::detail::MeshEntry mesh{};
    mesh.record = 0;
    mesh.prog0 = 0;
    source.entries.push_back(mesh);
    gfx::Prog0Constants block;
    std::copy(view.begin(), view.end(), block.clip_or_view);
    source.prog0_blocks.push_back(block);
    gfx::detail::Draw2DEntry ui;
    ui.vertices.resize(1);
    ui.vertices[0].x = 123;
    source.entries.push_back(ui);
    MouseFixedDisplayList(source, turned, 0.2f, 0.1f);
    gfx::detail::Mat4 place;
    ASSERT_TRUE(gfx::detail::InvertAffine(turned.cameras[0], place));
    EXPECT_NEAR(place[12], 10, 1e-5);
    EXPECT_NEAR(place[13], 20, 1e-5);
    EXPECT_NEAR(place[14], 30, 1e-5);
    EXPECT_EQ(source.cameras[0], view);
    EXPECT_EQ(source.cameras[1], turned.cameras[1]);
    EXPECT_TRUE(turned.doomed_textures.empty());
    EXPECT_FLOAT_EQ(std::get<gfx::detail::Draw2DEntry>(turned.entries[1]).vertices[0].x, 123);
    EXPECT_NE(std::get<gfx::detail::MeshEntry>(turned.entries[0]).constants.mvp[0], mesh.constants.mvp[0]);
    EXPECT_NEAR(turned.prog0_blocks[0].clip_or_view[0], turned.cameras[0][0], 1e-6);
    MouseFixedDisplayList(source, turned, 0, 0);
    EXPECT_EQ(turned.cameras, source.cameras);
    EXPECT_FLOAT_EQ(std::get<gfx::detail::MeshEntry>(turned.entries[0]).constants.mvp[0], mesh.constants.mvp[0]);
}

extern int          PortLoopNo asm("MainLoop_LoopNo");
extern int          PortEditFixedCamera asm("EditCtrl_FixedCamera");
extern int          PortTownLoopMode asm("EditLoop_Mode");
extern int          PortTownControlMode asm("EditLoop_Control");
extern int          PortTownLockChara asm("EditLoop_PlayerLock");
extern int          PortTownPause asm("EditLoop_Pause");
extern int          PortEditLadderMode asm("EditCtrl_LadderMode");
extern EditViewMode PortEditViewMode asm("EditCtrl_ViewMode");

TEST(CameraFixedMouse, RetailTownModesGateBothPointAndPathCameras) {
    CScene    &scene = *GetMainScene();
    const auto old_slot = *scene.GetSceneCamera(0);
    const int  old_active = scene.active_camera;
    const int  old_event = scene.event_run;
    const auto old_view = PortEditViewMode;
    const auto old_key = GamePad__2.key_lock;
    const auto old_debug = DebugInfo.debug_camera;
    const bool old_option = ConfigGet().mouse_fixed_look;
    int       *flags[] = {&PortLoopNo, &PortEditFixedCamera, &PortTownLoopMode, &PortTownControlMode,
                          &PortTownLockChara, &PortTownPause, &PortEditLadderMode};
    int        saved[7];
    for (int i = 0; i < 7; ++i) {
        saved[i] = *flags[i];
    }
    CCameraControl camera;
    camera.ControlOff();
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    auto reset = [&] {
        PortLoopNo = LOOP_EDIT;
        PortEditFixedCamera = 1;
        PortTownLoopMode = EDIT_LOOP_WALK;
        PortTownControlMode = EDIT_CONTROL_PLAYER;
        PortTownLockChara = PortTownPause = PortEditLadderMode = 0;
        PortEditViewMode = EDIT_VIEW_MODE_WALK;
        scene.active_camera = scene.event_run = 0;
        GamePad__2.key_lock = DebugInfo.debug_camera = 0;
        const_cast<Config &>(ConfigGet()).mouse_fixed_look = true;
        camera.ControlOff();
    };
    reset();
    EXPECT_EQ(TownMouseFixedOwner(), &camera);
    MouseFixedActive(0); // Establish the new owner with no inherited motion.
    EXPECT_FALSE(PresentMouseActive());
    MouseConfigure(false, {});
    SDL_Event motion{};
    motion.type = SDL_EVENT_MOUSE_MOTION;
    motion.motion.xrel = 20;
    InputHandleEvent(motion);
    EXPECT_TRUE(PresentMouseActive()); // Pending motion before a logical sample.
    InputLatchPad(0);
    EXPECT_TRUE(PresentMouseActive());
    MouseFixedActive(10); // Let the spring settle completely.
    EXPECT_FALSE(PresentMouseActive());
    MouseConfigure(true, {});
    PortEditFixedCamera = 2;
    EXPECT_EQ(TownMouseFixedOwner(), &camera);
    for (int other = 0; other < 9; ++other) {
        reset();
        if (other == 0) {
            PortTownLoopMode = EDIT_LOOP_WALK_MENU;
        }
        if (other == 1) {
            PortTownControlMode = EDIT_CONTROL_EVENT;
        }
        if (other == 2) {
            PortTownPause = 1;
        }
        if (other == 3) {
            PortTownLockChara = 1;
        }
        if (other == 4) {
            PortEditViewMode = EDIT_VIEW_MODE_PHOTO;
        }
        if (other == 5) {
            PortEditLadderMode = EDIT_LADDER_MODE_BOTTOM;
        }
        if (other == 6) {
            camera.ControlOn();
        }
        if (other == 7) {
            const_cast<Config &>(ConfigGet()).mouse_fixed_look = false;
        }
        if (other == 8) {
            scene.event_run = 1;
        }
        EXPECT_EQ(TownMouseFixedOwner(), nullptr) << other;
    }
    *scene.GetSceneCamera(0) = old_slot;
    scene.active_camera = old_active;
    scene.event_run = old_event;
    PortEditViewMode = old_view;
    GamePad__2.key_lock = old_key;
    DebugInfo.debug_camera = old_debug;
    const_cast<Config &>(ConfigGet()).mouse_fixed_look = old_option;
    for (int i = 0; i < 7; ++i) {
        *flags[i] = saved[i];
    }
}

TEST(CameraFixedMouse, CullingConeIncludesRotatedScreenCorners) {
    const float focal = 400, half_width = 256, half_height = 240;
    const float radius = MouseFixedCullRadius(focal, focal, half_width, half_height);
    EXPECT_GT(radius, half_width);
    for (float yaw : {-15.0f, 0.0f, 15.0f}) {
        for (float pitch : {-10.0f, 0.0f, 10.0f}) {
            const float y = yaw * std::numbers::pi_v<float> / 180;
            const float p = pitch * std::numbers::pi_v<float> / 180;
            for (float x : {-half_width / focal, half_width / focal}) {
                for (float v : {-half_height / focal, half_height / focal}) {
                    const float py = v * std::cos(p) - std::sin(p);
                    const float pz = v * std::sin(p) + std::cos(p);
                    const float rx = x * std::cos(y) + pz * std::sin(y);
                    const float rz = -x * std::sin(y) + pz * std::cos(y);
                    ASSERT_GT(rz, 0);
                    EXPECT_LT(std::fabs(focal * rx / rz), radius);
                    EXPECT_LT(std::fabs(focal * py / rz), radius);
                }
            }
        }
    }
}

TEST(CameraFixedMouseGpu, FixedLookOutlinePixelsMatchFullExtentReference) {
    dc::test::GfxOptions options;
    options.offscreen = true;
    options.prog0_meshes = true;
    options.logical_width = 64;
    options.logical_height = 48;
    dc::test::GfxFixture fixture(64, 48, 1, options);
    const auto           target = gfx::CreateRenderTarget(64, 48, true, true);
    ASSERT_NE(target, gfx::kNullTexture);
    const gfx::LogicalRect           full{0, 0, 64, 48};
    const uint8_t                    clear[4] = {};
    const std::vector<gfx::Vertex3D> triangle = {
        {{-.2f, -.2f, .9f}}, {{.2f, -.2f, .9f}}, {{0, .2f, .9f}}};
    const std::vector<uint32_t> indices{0, 1, 2};
    auto                        record = [&](float camera, bool outlined) {
        auto transform = gfx::IdentityMeshTransform();
        transform.view[12] = camera;
        gfx::MeshConstants constants{};
        std::memcpy(constants.mvp, transform.view, sizeof constants.mvp);
        gfx::Prog0Constants block{};
        block.flags = gfx::kProg0Unlit;
        for (int i = 0; i < 4; ++i) {
            block.object_color[i] = i == 3 ? 128 : 200;
            block.diffuse[i] = 1;
        }
        gfx::BeginRecording();
        if (outlined) {
            // Identify the main-target camera, then erase this setup draw.
            gfx::DrawMeshImmediateProg0(triangle, indices, constants, block, {}, {}, &transform);
        }
        gfx::Clear(true, clear, true, 0);
        gfx::SetInterpKey(17);
        if (outlined) {
            gfx::SetRenderTarget(target);
            const gfx::LogicalRect crop{32 + camera * 32 - 7, 18, 14, 12};
            gfx::Clear(true, clear, false, 0, &crop, &full);
            gfx::DrawMeshImmediateProg0(triangle, indices, constants, block, {}, {}, &transform);
            gfx::SetRenderTarget(gfx::kMainTarget);
            std::vector<gfx::Vertex2D> quad(4), display_quad(4);
            for (int i = 0; i < 4; ++i) {
                const bool right = i == 1 || i == 2;
                quad[i].x = quad[i].u = crop.x + (right ? crop.w : 0);
                quad[i].y = quad[i].v = crop.y + (i >= 2 ? crop.h : 0);
                display_quad[i].x = display_quad[i].u = right ? full.w : 0;
                display_quad[i].y = display_quad[i].v = i >= 2 ? full.h : 0;
                std::memset(quad[i].color, 128, 4);
                std::memset(display_quad[i].color, 128, 4);
            }
            gfx::TextureBinding binding;
            binding.texture = target;
            const gfx::Presentation2D presentation{display_quad, {}};
            gfx::Draw2D(gfx::Primitive::Quads, quad, binding, {}, &presentation);
        } else {
            // Independent complete-pixel reference: draw the mesh directly, without
            // a scratch image, crop or presentation replacement.
            gfx::DrawMeshImmediateProg0(triangle, indices, constants, block, {}, {}, &transform);
        }
        return gfx::EndRecording();
    };
    auto render = [&](const gfx::DisplayList &list, float alpha, gfx::RenderOptions options) {
        options.present = !options.canonical;
        EXPECT_TRUE(gfx::RenderList(list, alpha, options));
        EXPECT_TRUE(gfx::ReadbackFrame(fixture.pixels, fixture.width, fixture.height));
        return fixture.pixels;
    };
    auto             before = record(-.1f, true), after = record(.1f, true);
    gfx::DisplayList turned, previous;
    MouseFixedDisplayList(*before, previous, .26f, .17f);
    MouseFixedDisplayList(*after, turned, .26f, .17f);
    EXPECT_NE(turned.cameras[0], after->cameras[0]);
    EXPECT_TRUE(turned.doomed_textures.empty());
    EXPECT_TRUE(previous.doomed_meshes.empty());
    for (float alpha : {1.0f, .5f}) {
        render(turned, 1, {.canonical = true});
        const auto       pixels = render(turned, alpha, {.previous = &previous});
        auto             direct = record(-.1f + .2f * alpha, false);
        gfx::DisplayList reference;
        MouseFixedDisplayList(*direct, reference, .26f, .17f);
        EXPECT_EQ(pixels, render(reference, 1, {.canonical = true})) << alpha;
        EXPECT_GT(std::count_if(pixels.begin(), pixels.end(), [](uint8_t c) { return c > 0; }), 20);
    }
    gfx::DestroyTexture(target);
}
