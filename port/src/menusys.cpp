#include "common.h"
#include "mw_runtime.h"
#include <libvu0.h>
#include <cmath>
#include <cstdio>
#include <cstring>
#include "charasetup.hpp"
#include "dataread.hpp"
#include "dng_main.hpp"
#include "dynamicanime.hpp"
#include "effscript.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menushop.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nameregi.hpp"
#include "password.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"
#include "gfx/gfx.hpp"
#include "stubs/menusys.hpp"

#ifdef PORT
// Inside buildings the Item pages show the location's stored outdoor scene (ps2/src/menumain.cpp,
// port/src/menudraw.cpp).
extern bool MenuSnapshotFallback;
bool        MenuPortFallbackValid();
bool        MenuMouseHeldItemAt(float &x, float &y);
float       MenuPortVisibleLeft();
void        MenuPortStoreScene(int area, const float *world_matrix, const float *camera_pos, float projection,
                               const float *position, const float *rotation);
bool        MenuPortLoadScene(int area, float *world_matrix, float *camera_pos, float *projection, float *position,
                              float *rotation);
int         GetMapAreaNo(int map_no);

// An area's stored scene: the camera the picture was taken with and where the character stood.
struct MenuItemScene {
    bool  valid;
    int   area;
    float world_matrix[4][4];
    float camera_pos[4];
    float projection;
    float position[4];
    float rotation[4];
};
static MenuItemScene menu_item_scene = {};
// Set when the menu being opened inside a building found its area's scene.
static bool menu_item_scene_ready = false;

int MenuSceneArea(CScene *scene) {
    if (scene == NULL) {
        return -1;
    }
    const int area = GetMapAreaNo(scene->now_map_no);
    return area >= 0 ? area : 1000 + scene->now_map_no;
}

// Inside a building: makes the area's stored scene (from this session or the save folder) the one shown.
bool MenuItemLoadScene(CScene *scene) {
    const int area = MenuSceneArea(scene);
    menu_item_scene_ready = false;
    if (area < 0) {
        return false;
    }
    if (menu_item_scene.valid && menu_item_scene.area == area && MenuPortFallbackValid()) {
        menu_item_scene_ready = true;
        return true;
    }
    MenuItemScene loaded = {};
    if (!MenuPortLoadScene(area, &loaded.world_matrix[0][0], loaded.camera_pos, &loaded.projection, loaded.position,
                           loaded.rotation)) {
        return false;
    }
    loaded.valid = true;
    loaded.area = area;
    menu_item_scene = loaded;
    menu_item_scene_ready = true;
    return true;
}

static CActionChara *menu_inventory_preview_chara = NULL;
static int menu_inventory_preview_view_mode = -1;
static bool menu_inventory_preview_active = false;
#endif

#ifdef PORT
bool MenuItemUsesWorldBackdrop() {
    return MenuFrameTex != NULL && MenuCommonInfo != NULL && MenuCommonInfo->now_mode == MENU_MODE_ITEM &&
           CMenuItemInfoPt != NULL && CMenuItemInfoPt->sub_menu == MENU_ITEM_SUB_MENU_NONE &&
           (!MenuSnapshotFallback || menu_item_scene_ready);
}

// Over the paused world, view the menu character through the world camera and stand it where the player
// stands, so the live inventory character replaces the player in the snapshot.
// The character the inventory last showed (0 Max, 1 Monica), or -1; menu exit makes it the world character.
int MenuItemViewedChara = -1;

// Logical x where the item page's panels split between the left and right anchors (the bag board's left
// edge); the mouse uses it to map the pointer back to the retail layout.
float MenuItemAnchorSplit = 240.0f;
// Side the command popup moves to: 1 with the bag (right), -1 with the character panels (left).
int MenuItemPopupSide = 1;

// Side the item page's selection frame belongs to: 1 on the bag, -1 on the character's panels.
int MenuItemWakuSide() {
    return CMenuItemInfoPt != NULL && CMenuItemInfoPt->key_arg_no == ITEM_MENU_PANEL_BAG ? 1 : -1;
}

bool MenuItemWorldView() {
    if (!MenuItemUsesWorldBackdrop()) {
        return false;
    }

    // The ridepod is Max's and the monster is Monica's, so leaving on those views returns as their owner.
    const int view_mode = CMenuItemInfoPt->view_mode;

    // The menu model's own place, from before it was first moved into the world, for the views that use
    // the menu's close-up camera.
    static CActionChara *home_chara = NULL;
    static float         home_position[4];
    static float         home_rotation[4];
    CActionChara        *model = MenuActionChara[0];
    if (model != NULL && model != home_chara) {
        home_chara = model;
        model->GetPosition(home_position);
        model->GetRotation(home_rotation);
    }

    // A weapon or rod being looked at keeps the menu's own close-up camera, large over its stats.
    if (view_mode == MENU_ITEM_VIEW_WEAPON || view_mode == MENU_ITEM_VIEW_FISHING_ROD) {
        // Turns slowly in place, about once every seven seconds.
        static float spin = 0.0f;
        spin += 0.015f;
        if (spin > 6.2831853f) {
            spin -= 6.2831853f;
        }
        if (model != NULL && model == home_chara) {
            float turned[4] = {home_rotation[0], home_rotation[1] + spin, home_rotation[2], home_rotation[3]};
            model->SetPosition(home_position);
            model->SetRotation(turned);
        }

        // The menu's camera step (as MenuWorldTrans), moved sideways by the same distance the anchoring moves
        // the stats box, so the weapon stays centred over it on wide windows.
        mgCCamera *menu_camera = &MenuDrawEnv->camera;
        float      menu_view[4][4];
        float      menu_pos[4];
        float      menu_identity[4][4];
        float      menu_world[4][4];
        mgSetProjection(MenuDrawEnv->projection);
        menu_camera->GetCameraMatrix(menu_view);
        menu_camera->GetPos(menu_pos);
        menu_camera->SetSpeed(MenuDrawEnv->speed, -1.0f);
        menu_camera->SetNextRef(MenuDrawEnv->ref);
        menu_camera->SetNextPos(MenuDrawEnv->pos);
        menu_camera->Step(1);
        sceVu0UnitMatrix(menu_identity);
        sceVu0MulMatrix(menu_world, menu_identity, menu_view);
        const float depth = std::fabs(home_position[0] * menu_world[0][2] + home_position[1] * menu_world[1][2] +
                                      home_position[2] * menu_world[2][2] + menu_world[3][2]);
        if (MenuDrawEnv->projection > 0.0f && depth > 1.0f) {
            menu_world[3][0] += MenuPortVisibleLeft() * depth / MenuDrawEnv->projection;
        }
        mgSetViewMatrix(menu_world, menu_pos);
        return true;
    }
    if (view_mode == MENU_ITEM_VIEW_MAX || view_mode == MENU_ITEM_VIEW_ROBO) {
        MenuItemViewedChara = 0;
    } else if (view_mode == MENU_ITEM_VIEW_MONICA || view_mode == MENU_ITEM_VIEW_MONSTER) {
        MenuItemViewedChara = 1;
    }

    // The scene the snapshot was taken in (the dungeon's in a dungeon).
    extern CScene *MenuSnapshotScene();
    CScene        *scene = MenuSnapshotScene();
    if (scene == NULL) {
        return false;
    }

    mgCCamera    *camera = scene->GetCamera(scene->active_camera);
    CCharacter2  *player = scene->GetCharacter(scene->player_chara);
    CActionChara *preview = MenuActionChara[0];
    if (camera == NULL || player == NULL || preview == NULL) {
        return false;
    }

    MenuItemScene &stored = menu_item_scene;
    float          view_matrix[4][4];
    float identity[4][4];
    float world_matrix[4][4];
    float camera_pos[4];
    float position[4];
    float rotation[4];
    float projection = MenuDrawEnv->old_projection;

    if (MenuSnapshotFallback) {
        if (!menu_item_scene_ready || !stored.valid) {
            return false;
        }
        memcpy(world_matrix, stored.world_matrix, sizeof(world_matrix));
        memcpy(camera_pos, stored.camera_pos, sizeof(camera_pos));
        memcpy(position, stored.position, sizeof(position));
        memcpy(rotation, stored.rotation, sizeof(rotation));
        projection = stored.projection;
    } else {
        camera->GetCameraMatrix(view_matrix);
        camera->GetPos(camera_pos);
        sceVu0UnitMatrix(identity);
        sceVu0MulMatrix(world_matrix, identity, view_matrix);
        player->GetPosition(position);
        player->GetRotation(rotation);
        // Face the camera itself; the camera is panned sideways, so the player's own heading reads as turned.
        rotation[1] = std::atan2(camera_pos[0] - position[0], camera_pos[2] - position[2]);

        // A new outdoor scene is kept as the area's scene, in memory and in the save folder.
        const int area = MenuSceneArea(scene);
        if (!stored.valid || stored.area != area || memcmp(stored.camera_pos, camera_pos, sizeof(camera_pos)) != 0) {
            stored.valid = true;
            stored.area = area;
            memcpy(stored.world_matrix, world_matrix, sizeof(world_matrix));
            memcpy(stored.camera_pos, camera_pos, sizeof(camera_pos));
            memcpy(stored.position, position, sizeof(position));
            memcpy(stored.rotation, rotation, sizeof(rotation));
            stored.projection = projection;
            MenuPortStoreScene(area, &stored.world_matrix[0][0], stored.camera_pos, stored.projection,
                               stored.position, stored.rotation);
        }
    }

    // The picture was taken through this camera, so the live character is drawn through it as is.
    mgSetProjection(projection);
    mgSetViewMatrix(world_matrix, camera_pos);
    preview->SetPosition(position);
    preview->SetRotation(rotation);

    // Bigger bodies are shrunk about their feet so they still fit between the circles and the status bars.
    static bool scaled = false;
    float       scale = 1.0f;
    if (view_mode == MENU_ITEM_VIEW_ROBO) {
        scale = 0.6f;
    } else if (view_mode == MENU_ITEM_VIEW_MONSTER) {
        scale = 0.8f;
    }
    if (scale != 1.0f || scaled) {
        preview->SetScale(scale, scale, scale);
        scaled = scale != 1.0f;
    }
    return true;
}
#endif

extern void PortRetailMenuItemDraw();
extern void MenuMainFrameWorldDraw(int &loaded_tex_no);

PORT_OVERRIDE void MenuItemDraw() {
    const bool world_backdrop = MenuItemUsesWorldBackdrop();
    if (world_backdrop) {
        CMenuPosDataForm *main_frame = MenuPosData != NULL ? MenuPosData->GetFormInfo("main_bg_img") : NULL;
        CMenuPosDataForm *menu_fill = MenuPosData != NULL ? MenuPosData->GetFormInfo("mainform_fill") : NULL;
        CMenuPosDataForm *character_fill = CMenuItemInfoPt != NULL ? CMenuItemInfoPt->fill_form : NULL;
        const bool main_frame_was_drawn = main_frame != NULL && main_frame->draw_flag;
        const bool menu_fill_was_drawn = menu_fill != NULL && menu_fill->draw_flag;
        const bool character_fill_was_drawn = character_fill != NULL && character_fill->draw_flag;

        if (main_frame != NULL) {
            main_frame->draw_flag = false;
        }
        if (menu_fill != NULL) {
            menu_fill->draw_flag = false;
        }
        if (character_fill != NULL) {
            character_fill->draw_flag = false;
        }

        CActionChara *preview = MenuActionChara[0];
        if (preview != NULL && (!menu_inventory_preview_active || preview != menu_inventory_preview_chara ||
                                CMenuItemInfoPt->view_mode != menu_inventory_preview_view_mode)) {
            menu_inventory_preview_chara = preview;
            menu_inventory_preview_view_mode = CMenuItemInfoPt->view_mode;
        }
        menu_inventory_preview_active = true;

        float split = 240.0f;
        if (CMenuItemInfoPt->item_board_form != NULL) {
            float board_x = 0.0f;
            float board_y = 0.0f;
            CMenuItemInfoPt->item_board_form->GetPutPosXY(NULL, board_x, board_y);
            split = board_x - 2.0f;
        }
        MenuItemAnchorSplit = split;
        MenuItemPopupSide = CMenuItemInfoPt->key_arg_no == ITEM_MENU_PANEL_BAG ? 1 : -1;
        int loaded_tex_no = -1;
        MenuMainFrameWorldDraw(loaded_tex_no);

        gfx::UiAnchor wide_menu_anchor{split, split};
        wide_menu_anchor.max_aspect = 16.0f / 9.0f;
        wide_menu_anchor.scissor = true;
        gfx::UiAnchorScope wide_layout(wide_menu_anchor);

        PortRetailMenuItemDraw();

        if (main_frame != NULL) {
            main_frame->draw_flag = main_frame_was_drawn;
        }
        if (menu_fill != NULL) {
            menu_fill->draw_flag = menu_fill_was_drawn;
        }
        if (character_fill != NULL) {
            character_fill->draw_flag = character_fill_was_drawn;
        }
        return;
    }

    menu_inventory_preview_chara = NULL;
    menu_inventory_preview_view_mode = -1;
    menu_inventory_preview_active = false;
    PortRetailMenuItemDraw();
}
