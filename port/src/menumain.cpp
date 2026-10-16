#include "common.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "charasetup.hpp"
#include "dataread.hpp"
#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "dynamicanime.hpp"
#include "editmenu.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mapselect.hpp"
#include "menuaqua.hpp"
#include "menucapt.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menumap.hpp"
#include "menuop.hpp"
#include "menushop.hpp"
#include "menusys.hpp"
#include "menusystemdata.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nameregi.hpp"
#include "nowload.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

#ifdef PORT
#include <math.h>

#include "cameracontrol.hpp"

static bool  menu_snapshot_framed = false;
static int   menu_snapshot_hidden_slot = -1;
static int   menu_snapshot_phase = 0;
static int   menu_snapshot_ticks = 0;
static float menu_snapshot_walk_distance = 0.0f;
static float menu_snapshot_last_pos[4];
static float menu_snapshot_saved_pos[4];
static float menu_snapshot_saved_ref[4];

static void MenuCameraPlace(mgCCamera *camera, float *pos, float *ref) {
    camera->Resume();
    camera->SetPos(pos);
    camera->SetRef(ref);
    camera->SetNextPos(pos);
    camera->SetNextRef(ref);
    camera->Step(1);
}

// Before the menu snapshot: put the world camera in front of the player, panned so the player stands
// left of centre above the status bars, and hold it there while the menu is open.
// The scene the snapshot is taken in: town passes MainScene, the dungeon DngMainScene. Kept so the
// menu's live character and the restore on exit use the same one.
static CScene *menu_snapshot_scene = NULL;

CScene *MenuSnapshotScene() {
    return menu_snapshot_scene != NULL ? menu_snapshot_scene : GetMainScene();
}

// Set for a menu opened where the live picture does not work (a town fixed camera, inside buildings):
// the Item pages then show the location's stored outdoor scene (port/src/menudraw.cpp).
extern int MenuEditFixedCamera asm("EditCtrl_FixedCamera");
bool       MenuSnapshotFallback = false;

bool MenuFrameCameraForSnapshot(CScene *field_scene, bool town) {
    MenuSnapshotFallback = town && MenuEditFixedCamera != 0;
    if (MenuSnapshotFallback) {
        // Inside a building: show the area's stored outdoor scene if there is one (retail backdrop otherwise).
        extern bool MenuItemLoadScene(CScene * scene);
        MenuItemLoadScene(field_scene != NULL ? field_scene : GetMainScene());
        return false;
    }

    CScene *scene = field_scene != NULL ? field_scene : GetMainScene();
    menu_snapshot_scene = scene;
    if (scene == NULL) {
        return false;
    }

    mgCCamera   *camera = scene->GetCamera(scene->active_camera);
    CCharacter2 *player = scene->GetCharacter(scene->player_chara);
    if (camera == NULL || player == NULL) {
        return false;
    }

    float position[4];
    float rotation[4];
    float cam_pos[4];
    float cam_ref[4];
    player->GetPosition(position);
    player->GetRotation(rotation);
    camera->GetPos(cam_pos);
    camera->GetRef(cam_ref);

    for (int i = 0; i < 4; i++) {
        menu_snapshot_saved_pos[i] = cam_pos[i];
        menu_snapshot_saved_ref[i] = cam_ref[i];
    }

    // The walking camera's distance, before anything moves it; the close framing is measured from it.
    const float dx = cam_pos[0] - position[0];
    const float dz = cam_pos[2] - position[2];
    menu_snapshot_walk_distance = sqrtf(dx * dx + dz * dz);
    for (int i = 0; i < 4; i++) {
        menu_snapshot_last_pos[i] = position[i];
    }
    menu_snapshot_phase = 1;
    menu_snapshot_ticks = 0;
    menu_snapshot_framed = true;
    return true;
}

// One world tick of the snapshot sequence; true when the frame just drawn is the framed one to grab.
// 1: let the player come to a stop (up to 20 ticks). 2: swing the gameplay camera to the player's front
// (behind is the facing minus pi, as RotBack uses) and hide the player model; the tick runs the camera's
// own collision check, which pulls it in front of anything in the way. 3: from that settled camera, move in
// and to the side so the player stands between the quick-select circles and the status bars, then hold it.
bool MenuSnapshotStep() {
    CScene *scene = MenuSnapshotScene();
    if (scene == NULL) {
        return true;
    }

    mgCCamera   *camera = scene->GetCamera(scene->active_camera);
    CCharacter2 *player = scene->GetCharacter(scene->player_chara);
    if (camera == NULL || player == NULL) {
        return true;
    }

    float position[4];
    float rotation[4];
    player->GetPosition(position);
    player->GetRotation(rotation);
    menu_snapshot_ticks++;

    if (menu_snapshot_phase == 1) {
        const float mx = position[0] - menu_snapshot_last_pos[0];
        const float my = position[1] - menu_snapshot_last_pos[1];
        const float mz = position[2] - menu_snapshot_last_pos[2];
        const bool  still = mx * mx + my * my + mz * mz < 0.01f;
        for (int i = 0; i < 4; i++) {
            menu_snapshot_last_pos[i] = position[i];
        }
        if (!still && menu_snapshot_ticks < 20) {
            return false;
        }

        CCameraControl *control = (CCameraControl *) camera;
        control->CancelRotBack();
        control->SetRotate(rotation[1]);
        camera->SetPos(control->next_pos);
        camera->SetRef(control->next_ref);
        menu_snapshot_hidden_slot = scene->player_chara;
        // Model and shadow both: the live menu character stands in that spot without a shadow.
        scene->chara[menu_snapshot_hidden_slot].status |= 1u << 4; // SCENE_CHARA_HIDE
        extern bool MenuSnapshotNoDepthOfField;
        MenuSnapshotNoDepthOfField = true;
        menu_snapshot_phase = 2;
        return false;
    }

    if (menu_snapshot_phase == 2) {
        float cam_pos[4];
        float cam_ref[4];
        camera->GetPos(cam_pos);
        camera->GetRef(cam_ref);

        // Always the player's front (the follow camera may have drifted back during the settle tick);
        // the settled camera only says how far out the collision check let it stay.
        const float dx = cam_pos[0] - position[0];
        const float dz = cam_pos[2] - position[2];
        float       settled = sqrtf(dx * dx + dz * dz);
        if (settled < 1.0f) {
            settled = 1.0f;
        }
        const float forward_x = sinf(rotation[1]);
        const float forward_z = cosf(rotation[1]);
        const float right_x = forward_z;
        const float right_z = -forward_x;

        // Closer than walking, keeping the pitch; never further out than the collision check allowed.
        extern float MenuPortVisibleLeft();
        // A fixed distance, so every character comes out the same size whatever the walking camera was doing
        // (89.7 is the framing Jeff approved); closer only when the collision check stopped the camera nearer.
        const float kFramingDistance = 89.7f;
        float       distance = kFramingDistance;
        if (distance > settled) {
            distance = settled;
        }
        const float scale = settled > 1.0f ? distance / settled : 1.0f;
        const float projection = mgGetProjection();
        const float target_x = MenuPortVisibleLeft() + 140.0f - mgScreenWidth * 0.5f;
        const float side = projection > 0.0f ? distance * -target_x / projection : 0.0f;
        const float up_sign = cam_pos[1] >= position[1] ? 1.0f : -1.0f;
        const float lift = projection > 0.0f ? distance * 0.209f * mgScreenHeight / projection : 0.0f;
        const float ref_y = cam_ref[1] - up_sign * lift;
        const float pos_y = ref_y + (cam_pos[1] - cam_ref[1]) * scale;

        float new_pos[4] = {position[0] + forward_x * distance + right_x * side, pos_y,
                            position[2] + forward_z * distance + right_z * side, cam_pos[3]};
        float new_ref[4] = {position[0] + right_x * side, ref_y, position[2] + right_z * side, cam_ref[3]};
        MenuCameraPlace(camera, new_pos, new_ref);
        camera->Suspend();
        menu_snapshot_phase = 3;
        return false;
    }

    menu_snapshot_phase = 0;
    return true;
}

static void MenuRestoreSnapshotCamera(CScene *exit_scene) {
    CScene *scene = menu_snapshot_scene != NULL ? menu_snapshot_scene : exit_scene;

    MenuSnapshotFallback = false;

    // Whatever happened, the field camera must move again once the menu is gone.
    if (exit_scene != NULL && exit_scene->GetCamera(exit_scene->active_camera) != NULL) {
        exit_scene->GetCamera(exit_scene->active_camera)->Resume();
    }
    if (scene != NULL && scene->GetCamera(scene->active_camera) != NULL) {
        scene->GetCamera(scene->active_camera)->Resume();
    }
    menu_snapshot_phase = 0;

    if (!menu_snapshot_framed || scene == NULL) {
        return;
    }

    mgCCamera *camera = scene->GetCamera(scene->active_camera);
    if (camera != NULL) {
        MenuCameraPlace(camera, menu_snapshot_saved_pos, menu_snapshot_saved_ref);
    }
    extern bool MenuSnapshotNoDepthOfField;
    MenuSnapshotNoDepthOfField = false;
    if (menu_snapshot_hidden_slot >= 0) {
        scene->chara[menu_snapshot_hidden_slot].status &= ~(1u << 4); // SCENE_CHARA_HIDE
        menu_snapshot_hidden_slot = -1;
    }
    menu_snapshot_framed = false;
    menu_snapshot_scene = NULL;
}
#endif

extern int PortRetailMenuMainExit();
extern void PortRetailMenuWorldTrans();
extern int MenuItemViewedChara;
extern bool MenuItemWorldView();

PORT_OVERRIDE int MenuMainExit() {
    // The character last shown in the inventory becomes the world character, as a Character-menu change would.
    if (MenuItemViewedChara >= 0 && MenuArg.end_code == MENU_END_NONE &&
        MenuItemViewedChara != MenuUserDataManPtr->active_chr_no) {
        MenuArg.end_code = MENU_END_CHARA_CHANGE;
        MenuArg.result[0] = MenuItemViewedChara;
    }
    MenuItemViewedChara = -1;
    MenuRestoreSnapshotCamera(GetMainScene());
    return PortRetailMenuMainExit();
}

PORT_OVERRIDE void MenuWorldTrans() {
    if (MenuItemWorldView()) {
        return;
    }
    PortRetailMenuWorldTrans();
}
