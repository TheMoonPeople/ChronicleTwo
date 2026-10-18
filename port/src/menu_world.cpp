#include "menu_world.hpp"

#include <libvu0.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstring>
#include <iterator>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "dng_main.hpp"
#include "editctrl_port.hpp"
#include "editloop.hpp"
#include "mainloop.hpp"
#include "menuchr.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "scenevillager.hpp"
#include "stubs/menumain.hpp"
#include "subgame.hpp"

namespace menuworld {
namespace {

using Vector = std::array<float, 4>;

constexpr float kFrameAspect = 4.0f / 3.0f;    /**< Aspect the renderer shows the logical frame at. */
constexpr float kLayoutAspect = 16.0f / 9.0f;  /**< Widest aspect the Item page spreads its panels across. */
constexpr int   kSettleTicks = 20;             /**< Longest wait for the player to come to a stop. */
constexpr float kStillDistanceSquared = 0.01f; /**< Squared movement in one tick that counts as standing still. */
constexpr float kFramingDistance = 89.7f;      /**< Camera distance that frames every character at one size. */
constexpr float kFramingScreenX = 140.0f;      /**< Logical x, from the layout's left edge, the player stands at. */
constexpr float kFramingLift = 0.209f;         /**< Screen heights the framed player stands above the centre. */
constexpr float kRoboScale = 0.6f;             /**< Scale the Ridepod is shown at, to fit between the panels. */
constexpr float kMonsterScale = 0.8f;          /**< Scale Monica's monster form is shown at. */
constexpr float kOffLayout = -1000000.0f;      /**< A retail x no panel of the Item page reaches. */

/**
 * Steps from the menu request to the open menu.
 */
enum class Stage {
    Idle,   /**< No main menu is framed. */
    Settle, /**< Waiting for the player to stop. */
    Turn,   /**< The camera swung to the player's front settles against the scenery. */
    Place,  /**< The camera is held at the framing; the next draw is the picture. */
    Framed, /**< The dungeon opens the menu itself. */
    Open,   /**< The menu is open over the framed picture. */
};

/**
 * Loop the waiting main menu belongs to.
 */
enum class Loop {
    Town,
    Dungeon,
};

/**
 * A menu model moved into the world, with where the menu had it.
 */
struct Placed {
    CActionChara *model = nullptr; /**< Model moved, or none. */
    Vector        position{};      /**< Position the menu gave it. */
    Vector        rotation{};      /**< Rotation the menu gave it. */
    Vector        scale{};         /**< Scale the menu gave it. */
};

/**
 * Framing and picture state of the current main menu.
 */
struct State {
    Stage              stage = Stage::Idle;          /**< Step reached. */
    Loop               loop = Loop::Town;            /**< Loop that asked for the menu. */
    MENU_INIT_ARG     *arg = nullptr;                /**< Argument the menu opens with. */
    CScene            *scene = nullptr;              /**< Scene being framed. */
    int                ticks = 0;                    /**< Ticks spent settling. */
    Vector             last_position{};              /**< Player position at the previous tick. */
    Vector             saved_pos{};                  /**< Camera position before the framing. */
    Vector             saved_ref{};                  /**< Camera look-at point before the framing. */
    int                hidden_slot = -1;             /**< Scene slot of the hidden player, or -1. */
    gfx::TextureHandle unframed = gfx::kNullTexture; /**< The world as the menu was asked for, or none. */
    gfx::TextureHandle picture = gfx::kNullTexture;  /**< Window-resolution grab of the framed world. */
    bool               captured = false;             /**< The picture holds this menu's frame. */
    bool               fill_pending = false;         /**< The Item page's black fill is still to come. */
    std::uint64_t      generation = 0;               /**< Frame at which this menu's framing began. */
    Placed             placed;                       /**< Menu model standing in the world. */
};

State state;

mgCCamera *SceneCamera(CScene *scene) {
    return scene != nullptr ? scene->GetCamera(scene->active_camera) : nullptr;
}

CCharacter2 *ScenePlayer(CScene *scene) {
    return scene != nullptr ? scene->GetCharacter(scene->player_chara) : nullptr;
}

// The scene's camera while it follows the player.
CCameraControl *FollowCamera(CScene *scene) {
    mgCCamera *camera = SceneCamera(scene);
    return camera != nullptr && camera->Iam() == CAMERA_KIND_CONTROL && camera->suspended == 0
               ? static_cast<CCameraControl *>(camera)
               : nullptr;
}

// Left edge of the area the Item page's panels spread to, in logical pixels: zero at 4:3, negative when wider.
float LayoutLeft() {
    const auto width = static_cast<float>(mgScreenWidth);
    return std::max(mgPortVisibleExtent().left, (width - width * kLayoutAspect / kFrameAspect) * 0.5f);
}

// The menu script keeps this destination while a form slides in or out.
std::optional<float> InwardX(const CMenuPosDataForm &form) {
    constexpr char k_inward_action[] = "\x92\x86\x82\xD6";
    if (form.action == nullptr) {
        return std::nullopt;
    }
    for (int i = 0; i < form.action_num; ++i) {
        const MENU_FORM_ACTION &action = form.action[i];
        if (action.move != nullptr && std::strncmp(action.name, k_inward_action, sizeof(action.name)) == 0) {
            return action.move->x;
        }
    }
    return std::nullopt;
}

// Logical x where the Item page's panels split between the left and right edges: the bag board's left edge.
float LayoutSplit() {
    return ItemPanelSplit(class_menu_item_info.item_board_form);
}

// Side the selection and the command popup move with: -1 the character's panels, 1 the bag.
int SelectionSide() {
    return class_menu_item_info.key_arg_no == ITEM_MENU_PANEL_BAG ? 1 : -1;
}

void PlaceCamera(mgCCamera &camera, Vector pos, Vector ref) {
    camera.Resume();
    camera.SetPos(pos.data());
    camera.SetRef(ref.data());
    camera.SetNextPos(pos.data());
    camera.SetNextRef(ref.data());
    camera.Step(1);
    mgPortCutCameraInterpolation();
}

// The loop a main menu frames the player in: a town walk or a dungeon floor, outside subgames, the eye view and
// fixed cameras.
std::optional<Loop> FramingLoop(const MENU_INIT_ARG &arg) {
    if (SubGameRunning()) {
        return std::nullopt;
    }
    if (arg.open_type == MENU_OPEN_MAIN_TOWN && PortTownLoopMode == EDIT_LOOP_WALK_MENU && PortEditFixedCamera == 0 &&
        PortEditViewMode == EDIT_VIEW_MODE_WALK) {
        return Loop::Town;
    }
    if (arg.open_type == MENU_OPEN_MAIN_DUNGEON && DngStatus.mode == DNG_STATUS_MENU && DngStatus.eye_view == 0) {
        return Loop::Dungeon;
    }
    return std::nullopt;
}

// Back to the loop's field mode, so the world keeps running while the camera frames the player.
void ResumeField() {
    if (state.loop == Loop::Town) {
        PortTownLoopMode = EDIT_LOOP_WALK;
    } else {
        DngStatus.mode = DNG_STATUS_FIELD;
    }
}

bool InField() {
    if (state.loop == Loop::Town) {
        return PortTownLoopMode == EDIT_LOOP_WALK && PortTownControlMode == EDIT_CONTROL_PLAYER;
    }
    return DngStatus.mode == DNG_STATUS_FIELD || DngStatus.mode == DNG_STATUS_MENU;
}

// The camera and the player as they were before the framing.
void Restore() {
    if (state.stage != Stage::Idle && state.stage != Stage::Settle) {
        if (mgCCamera *camera = SceneCamera(state.scene)) {
            PlaceCamera(*camera, state.saved_pos, state.saved_ref);
        }
    }
    if (state.hidden_slot >= 0) {
        state.scene->chara[state.hidden_slot].status &= ~static_cast<u32>(SCENE_CHARA_HIDE);
    }
    state = State{.unframed = state.unframed, .picture = state.picture};
}

// Drops a menu request the loop gave up on, showing again the dungeon's status bars that the request hid.
void Cancel() {
    if (state.loop == Loop::Dungeon && BattleAreaScene != nullptr && BattleAreaScene->statusbar_show_old != 0) {
        BattleAreaScene->SetStatusBarNow(1);
    }
    Restore();
}

// Swings the camera to the player's front, hiding the player and its shadow; the next world tick's collision
// check pulls the camera clear of scenery.
void Turn(CCameraControl &camera, CCharacter2 &player) {
    Vector rotation{};
    player.GetRotation(rotation.data());
    camera.CancelRotBack();
    camera.SetRotate(rotation[1]);
    camera.SetPos(camera.next_pos);
    camera.SetRef(camera.next_ref);

    const int slot = state.scene->player_chara;
    if (slot >= 0 && slot < std::ssize(state.scene->chara) && (state.scene->chara[slot].status & SCENE_CHARA_HIDE) == 0) {
        state.scene->chara[slot].status |= SCENE_CHARA_HIDE;
        state.hidden_slot = slot;
    }
}

// Moves the settled camera in to the framing distance and sideways, so the player stands where the Item page
// leaves room for the character, and holds it there.
void Place(mgCCamera &camera, CCharacter2 &player) {
    Vector position{};
    Vector rotation{};
    Vector cam_pos{};
    Vector cam_ref{};
    player.GetPosition(position.data());
    player.GetRotation(rotation.data());
    camera.GetPos(cam_pos.data());
    camera.GetRef(cam_ref.data());

    // The collision check only says how far out the camera may stay.
    const float settled = std::max(1.0f, std::hypot(cam_pos[0] - position[0], cam_pos[2] - position[2]));
    const float distance = std::min(kFramingDistance, settled);
    const float forward_x = std::sin(rotation[1]);
    const float forward_z = std::cos(rotation[1]);
    const float projection = mgGetProjection();
    float       side = 0.0f;
    float       lift = 0.0f;
    if (projection > 0.0f) {
        const float screen_x = LayoutLeft() + kFramingScreenX - static_cast<float>(mgScreenWidth) * 0.5f;
        side = -distance * screen_x / projection;
        lift = distance * kFramingLift * static_cast<float>(mgScreenHeight) / projection;
    }
    const float ref_y = cam_ref[1] - (cam_pos[1] >= position[1] ? lift : -lift);
    const float side_x = forward_z * side;
    const float side_z = -forward_x * side;

    PlaceCamera(camera,
                {position[0] + forward_x * distance + side_x, ref_y + (cam_pos[1] - cam_ref[1]) * distance / settled,
                 position[2] + forward_z * distance + side_z, cam_pos[3]},
                {position[0] + side_x, ref_y, position[2] + side_z, cam_ref[3]});
    camera.Suspend();
}

// One world tick of settling or turning.
void Step(CCameraControl &camera, CCharacter2 &player) {
    if (state.stage == Stage::Turn) {
        Place(camera, player);
        state.stage = Stage::Place;
        return;
    }
    Vector position{};
    player.GetPosition(position.data());
    const float dx = position[0] - state.last_position[0];
    const float dy = position[1] - state.last_position[1];
    const float dz = position[2] - state.last_position[2];
    state.last_position = position;
    if (dx * dx + dy * dy + dz * dz < kStillDistanceSquared || ++state.ticks >= kSettleTicks) {
        Turn(camera, player);
        state.stage = Stage::Turn;
    }
}

// Bigger bodies are shrunk about their feet to fit between the circles and the status bars.
float ViewScale(int view) {
    if (view == MENU_ITEM_VIEW_ROBO) {
        return kRoboScale;
    }
    return view == MENU_ITEM_VIEW_MONSTER ? kMonsterScale : 1.0f;
}

// Places the menu model in the world, keeping where the menu had it.
void PutInWorld(CActionChara &model, Vector position, Vector rotation, float scale) {
    Placed &placed = state.placed;
    if (placed.model != &model) {
        placed = {.model = &model};
        model.GetPosition(placed.position.data());
        model.GetRotation(placed.rotation.data());
        model.GetScale(placed.scale.data());
    }
    model.SetPosition(position.data());
    model.SetRotation(rotation.data());
    model.SetScale(placed.scale[0] * scale, placed.scale[1] * scale, placed.scale[2] * scale);
}

// Puts the menu model back where the menu had it.
void PutBack() {
    Placed &placed = state.placed;
    if (placed.model != nullptr && placed.model == MenuActionChara[0]) {
        placed.model->SetPosition(placed.position.data());
        placed.model->SetRotation(placed.rotation.data());
        placed.model->SetScale(placed.scale.data());
    }
    placed = {};
}

// The menu's own camera step (MenuWorldTrans), moved sideways with the panels so a looked-at weapon stays over
// its stats.
void ViewThroughMenuCamera() {
    mgSetProjection(MenuDrawEnv->projection);
    mgCCamera &camera = MenuDrawEnv->camera;
    float      view[4][4];
    Vector     pos{};
    camera.GetCameraMatrix(view);
    camera.GetPos(pos.data());
    camera.SetSpeed(MenuDrawEnv->speed, -1.0f);
    camera.SetNextRef(MenuDrawEnv->ref);
    camera.SetNextPos(MenuDrawEnv->pos);
    camera.Step(1);

    if (CActionChara *model = MenuActionChara[0]; model != nullptr && MenuDrawEnv->projection > 0.0f) {
        Vector at{};
        model->GetPosition(at.data());
        const float depth = std::fabs(at[0] * view[0][2] + at[1] * view[1][2] + at[2] * view[2][2] + view[3][2]);
        if (depth > 1.0f) {
            view[3][0] += LayoutLeft() * depth / MenuDrawEnv->projection;
        }
    }
    mgSetViewMatrix(view, pos.data());
}

} // namespace

bool HoldMenuInit(MENU_INIT_ARG *arg) {
    switch (state.stage) {
        case Stage::Open:
            // The town can ask again in the tick the framed menu opened; a menu no longer running is stale.
            if (MenuPosData != nullptr) {
                return true;
            }
            Restore();
            break;
        case Stage::Framed:
            state.stage = Stage::Open;
            return false;
        case Stage::Settle:
        case Stage::Turn:
        case Stage::Place:
            ResumeField();
            return true;
        case Stage::Idle:
            break;
    }

    const std::optional<Loop> loop = arg != nullptr ? FramingLoop(*arg) : std::nullopt;
    CScene                   *scene = GetMainScene();
    mgCCamera                *camera = FollowCamera(scene);
    CCharacter2              *player = ScenePlayer(scene);
    if (!loop || camera == nullptr || player == nullptr) {
        return false;
    }

    state = State{.stage = Stage::Settle, .loop = *loop, .arg = arg, .scene = scene, .picture = state.picture, .generation = static_cast<std::uint64_t>(mgPortFrameCount())};
    // The menu's other pages show the world as it was asked for, with the player and the walking camera.
    const gfx::TextureHandle unframed = gfx::NamedRenderTarget("menu world unframed", static_cast<uint32_t>(mgScreenWidth),
                                                               static_cast<uint32_t>(mgScreenHeight), false, false, true);
    state.unframed = unframed != gfx::kNullTexture && gfx::SnapshotFrame(unframed) ? unframed : gfx::kNullTexture;
    camera->GetPos(state.saved_pos.data());
    camera->GetRef(state.saved_ref.data());
    player->GetPosition(state.last_position.data());
    ResumeField();
    return true;
}

void AfterWorldDraw() {
    if (state.stage != Stage::Settle && state.stage != Stage::Turn && state.stage != Stage::Place) {
        return;
    }
    if (state.loop == Loop::Town && PortTownPause != 0) {
        return;
    }
    CCharacter2 *player = ScenePlayer(state.scene);
    if (player == nullptr || !InField()) {
        // Whatever took over the loop keeps it.
        Cancel();
        return;
    }
    if (state.stage != Stage::Place) {
        CCameraControl *camera = FollowCamera(state.scene);
        if (camera == nullptr) {
            Cancel();
            return;
        }
        Step(*camera, *player);
        return;
    }

    // The frame just drawn is the picture.
    if (state.loop == Loop::Dungeon) {
        state.stage = Stage::Framed;
        DngStatus.mode = DNG_STATUS_MENU;
        return;
    }
    state.stage = Stage::Open;
    PortTownLoopMode = EDIT_LOOP_WALK_MENU;
    PortRetailMenuMainInit(state.arg);
}

gfx::TextureHandle TakeMenuGrab() {
    if (state.stage != Stage::Open || state.captured) {
        return gfx::kPreviousFrame;
    }
    // A frame target keeps the window's sides past the logical frame.
    state.picture = gfx::NamedRenderTarget("menu world", static_cast<uint32_t>(mgScreenWidth),
                                           static_cast<uint32_t>(mgScreenHeight), false, false, true);
    const gfx::Rect frame{.x = 0, .y = 0, .w = mgScreenWidth, .h = mgScreenHeight};
    state.captured = state.picture != gfx::kNullTexture &&
                     gfx::BlitTexture(gfx::kPreviousFrame, frame, state.picture, frame, gfx::Filter::Linear);
    return state.unframed != gfx::kNullTexture ? state.unframed : gfx::kPreviousFrame;
}

void MenuClosed() {
    // The menu's models go with the menu.
    state.placed = {};
    Restore();
}

bool Framing() {
    return state.stage == Stage::Place || state.stage == Stage::Framed || state.stage == Stage::Open;
}

bool ItemBackdrop() {
    return state.stage == Stage::Open && state.captured && MenuCommonInfo != nullptr &&
           MenuCommonInfo->now_mode == MENU_MODE_ITEM && class_menu_item_info.sub_menu == MENU_ITEM_SUB_MENU_NONE;
}

ItemDrawScope::ItemDrawScope() {
    if (!ItemBackdrop()) {
        return;
    }
    state.fill_pending = true;
    const float split = LayoutSplit();
    anchor.emplace(gfx::UiAnchor{.left_until = split, .right_from = split, .scissor = true, .max_aspect = kLayoutAspect});
}

ItemDrawScope::~ItemDrawScope() {
    state.fill_pending = false;
}

bool FillWithBackdrop() {
    if (!state.fill_pending) {
        return false;
    }
    state.fill_pending = false;

    const int                alpha = ItemBackdropAlpha();
    const gfx::UiAnchorScope unanchored(gfx::UiAnchor{});
    if (alpha < 128 && MenuPosData != nullptr) {
        // Rebuild the returning backdrop below the dissolving world, leaving the moving panels above both.
        int loaded_texture = -1;
        for (CMenuPosDataForm *form = MenuPosData->GetDrawTopList(); form != nullptr; form = form->next) {
            if (HidesForm(*form)) {
                form->MenuFormDraw(static_cast<int>(form->x), static_cast<int>(form->y), loaded_texture);
            }
        }
    }

    // A frame target addresses the window's sides past the logical frame at texels outside it.
    const mgPortExtent extent = mgPortVisibleExtent();
    const auto         corner = [alpha](float x, float y) {
        return gfx::Vertex2D{
            .x = x, .y = y, .z = 0.0f, .u = x, .v = y, .color = {0x80, 0x80, 0x80, static_cast<uint8_t>(alpha)}
        };
    };
    const std::array strip = {corner(extent.left, extent.top), corner(extent.right, extent.top),
                              corner(extent.left, extent.bottom), corner(extent.right, extent.bottom)};
    gfx::DrawState   draw_state = mgPortDrawState();
    draw_state.blend = true;
    draw_state.alpha = {};
    draw_state.alpha_test = false;
    draw_state.depth_test = gfx::DepthTest::Always;
    draw_state.depth_write = false;
    draw_state.cull = gfx::CullMode::None;
    draw_state.scissor = false;
    gfx::TextureBinding binding;
    binding.texture = state.picture;
    binding.ignore_alpha = true;
    // The picture fills the window behind the spread panels, not the spread itself.
    const gfx::Interp2DScope interpolation({.key = 0x4954454D42474E44, .generation = state.generation});
    mgPortDraw2D(gfx::Primitive::TriangleStrip, strip, binding, draw_state);
    return true;
}

int ItemBackdropAlpha() {
    if (class_menu_item_info.mode != MENU_ASK_MODE_CLOSE) {
        return 128;
    }
    // The native frame travels from x=-192 to x=0 during the return and ends before the page switches.
    const float remaining = std::clamp(-GetMenuMainFrameLeftTopPos(0)[0] / 192.0f, 0.0f, 1.0f);
    return static_cast<int>(std::lround(128.0f * remaining * remaining * (3.0f - 2.0f * remaining)));
}

bool ViewMenuCharacter() {
    CActionChara *model = MenuActionChara[0];
    if (!ItemBackdrop() || model == nullptr) {
        PutBack();
        return false;
    }

    const int view = class_menu_item_info.view_mode;
    if (view == MENU_ITEM_VIEW_WEAPON || view == MENU_ITEM_VIEW_FISHING_ROD) {
        // A looked-at weapon or rod keeps the menu's close-up of the model where the menu has it.
        PutBack();
        ViewThroughMenuCamera();
        return true;
    }

    mgCCamera   *camera = SceneCamera(state.scene);
    CCharacter2 *player = ScenePlayer(state.scene);
    if (camera == nullptr || player == nullptr) {
        PutBack();
        return false;
    }

    // The picture was taken through this camera, so the model is drawn through it at the player's spot, facing it.
    float  view_matrix[4][4];
    Vector cam_pos{};
    Vector position{};
    Vector rotation{};
    camera->GetCameraMatrix(view_matrix);
    camera->GetPos(cam_pos.data());
    player->GetPosition(position.data());
    player->GetRotation(rotation.data());
    rotation[1] = std::atan2(cam_pos[0] - position[0], cam_pos[2] - position[2]);
    mgSetProjection(MenuDrawEnv->old_projection);
    mgSetViewMatrix(view_matrix, cam_pos.data());

    PutInWorld(*model, position, rotation, ViewScale(view));
    return true;
}

bool HidesForm(const CMenuPosDataForm &form) {
    if (!ItemBackdrop()) {
        return false;
    }
    return form.dtype == MENUFORM_DTYPE_MAINFRM || form.dtype == MENUFORM_DTYPE_MAINIMG ||
           &form == class_menu_item_info.fill_form ||
           (MenuPosData != nullptr && (&form == MenuPosData->GetFormInfo(const_cast<char *>("main_bg_img")) ||
                                       &form == MenuPosData->GetFormInfo(const_cast<char *>("mainform_fill"))));
}

float ItemPanelSplit(const CMenuPosDataForm *board) {
    if (board != nullptr) {
        if (const auto inward_x = InwardX(*board); inward_x && *inward_x > 0.0f && *inward_x < mgScreenWidth) {
            return *inward_x - 2.0f;
        }
    }
    return 240.0f;
}

int ItemPanelSide(const CMenuPosDataForm &form, float split) {
    if (&form == class_menu_item_info.item_board_form || &form == class_menu_item_info.money_form) {
        return 1;
    }
    for (const CMenuPosDataForm *view : class_menu_item_info.view_form) {
        if (&form == view) {
            return -1;
        }
    }
    const float x = InwardX(form).value_or(form.x);
    return x >= split - 40.0f ? 1 : -1;
}

bool RootChromeUnanchored(const CMenuPosDataForm &form) {
    if (form.name == nullptr) {
        return false;
    }
    if (std::strcmp(form.name, "areaboard") == 0 || std::strcmp(form.name, "timeboard") == 0 ||
        std::strcmp(form.name, "msg1") == 0 || std::strcmp(form.name, "mi00") == 0) {
        return true;
    }
    return form.name[0] == 'm' && form.name[1] == 'i' && form.name[2] >= '0' && form.name[2] <= '9' &&
           form.name[3] == '\0';
}

std::optional<gfx::UiAnchor> FormAnchor(const CMenuPosDataForm &form) {
    if (!ItemBackdrop()) {
        return std::nullopt;
    }
    if (RootChromeUnanchored(form)) {
        return gfx::UiAnchor{};
    }
    // The command popup moves with the panel of the item it is for.
    if (class_menu_item_info.mode != MENU_ASK_MODE_NONE && &form == class_menu_item_info.ask_para.form) {
        return gfx::UiAnchor::Side(SelectionSide(), 0, true, kLayoutAspect);
    }
    return gfx::UiAnchor::Side(ItemPanelSide(form, LayoutSplit()), 0, true, kLayoutAspect);
}

std::optional<gfx::UiAnchor> SelectionAnchor() {
    if (!ItemBackdrop()) {
        return std::nullopt;
    }
    return gfx::UiAnchor::Side(SelectionSide(), 0, true, kLayoutAspect);
}

float RetailPointerX(float x) {
    if (!ItemBackdrop()) {
        return x;
    }
    const float shift = LayoutLeft();
    if (class_menu_item_info.mode != MENU_ASK_MODE_NONE) {
        return SelectionSide() > 0 ? x + shift : x - shift;
    }
    const float split = LayoutSplit();
    if (x - shift < split) {
        return x - shift;
    }
    if (x + shift >= split) {
        return x + shift;
    }
    // The gap the spread opens beside the bag: its first column while an item is held, so it stays by the
    // pointer, and nothing otherwise.
    const bool holding = MenuCommonInfo != nullptr && MenuCommonInfo->have_item.item_no > 0;
    return holding ? split + 30.0f : kOffLayout;
}

float SpreadX(float retail_x) {
    if (!ItemBackdrop()) {
        return retail_x;
    }
    const bool right = class_menu_item_info.mode != MENU_ASK_MODE_NONE ? SelectionSide() > 0 : retail_x >= LayoutSplit();
    return right ? retail_x - LayoutLeft() : retail_x + LayoutLeft();
}

} // namespace menuworld
