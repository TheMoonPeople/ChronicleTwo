#include "menu_world.hpp"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstring>
#include <iterator>
#include <unordered_set>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "dng_main.hpp"
#include "editctrl_port.hpp"
#include "editloop.hpp"
#include "effscript.hpp"
#include "gfx/displaylist.hpp"
#include "mainloop.hpp"
#include "menuchr.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "outline.hpp"
#include "scenevillager.hpp"
#include "stubs/editloop.hpp"
#include "stubs/menumain.hpp"
#include "subgame.hpp"

namespace menuworld {
namespace {

using Vector = std::array<float, 4>;

constexpr float   kFrameAspect = 4.0f / 3.0f;               /**< Aspect the renderer shows the logical frame at. */
constexpr float   kLayoutAspect = 16.0f / 9.0f;             /**< Widest aspect the Item page spreads its panels across. */
constexpr float   kFramingScreenX = 131.0f;                 /**< Logical x, from the layout's left edge, the player stands at. */
constexpr float   kRoboScale = 0.6f;                        /**< Scale the Ridepod is shown at, to fit between the panels. */
constexpr float   kMonsterScale = 0.8f;                     /**< Scale Monica's monster form is shown at. */
constexpr float   kFrameHeight = 480.0f;                    /**< Logical height the screen positions below are given in. */
constexpr float   kHeadScreenY = 128.0f;                    /**< Logical y the head is drawn at, below the quick-select rings. */
constexpr float   kFeetScreenY = 343.0f;                    /**< Logical y the feet are drawn at, a few pixels above the "Maximilian" name at every size. */
constexpr float   kModelHeightPerBodyHeight = 1.664f;       /**< Height of Max's mesh in body_height units. */
constexpr float   kOffLayout = -1000000.0f;                 /**< A retail x no panel of the Item page reaches. */
constexpr float   kDefaultPanelSplit = 240.0f;              /**< Logical x the panels split at when the bag board gives none. */
constexpr float   kPanelFlipWidth = 40.0f;                  /**< Width of the band where panels change sides, ending at the split. */
constexpr float   kMainFrameTravel = 269.0f;                /**< Distance the main frame's left edge moves as the orb opens or closes. */
constexpr float   kHeldPointerOffset = 30.0f;               /**< Logical x past the split where the pointer rests while an item is held. */
constexpr uint8_t kFullPictureAlpha = 128;                  /**< Opacity of a full picture, out of 128. */
constexpr int     kMaxPartChain = 64;                       /**< Character parts walked before a chain is cut short. */
constexpr int     kCharacterFadeTicks = 16;                 /**< Frames the menu character takes to fade in. */
constexpr int     kCharacterDrawCounter = 15;               /**< Counter from which the menu draws a poly form's character. */
constexpr gfx::InterpKey kBackdropKey = 0x4954454D42474E44; /**< Interpolation key of the Item page's backdrop draws. */

/**
 * Steps from the menu request to the open menu.
 */
enum class Stage {
    Idle, /**< No main menu is framed. */
    Open, /**< The menu is open over the captured picture. */
};

/**
 * Picture and transition state of the current main menu.
 */
struct State {
    Stage              stage = Stage::Idle;                      /**< Step reached. */
    gfx::TextureHandle picture = gfx::kNullTexture;              /**< World captured at the pause instant. */
    gfx::TextureHandle clean_picture = gfx::kNullTexture;        /**< Same world with the player omitted. */
    CActionChara      *player = nullptr;                         /**< Field character whose meshes are left out of the clean picture. */
    bool               captured = false;                         /**< The picture holds this menu's frame. */
    bool               fill_pending = false;                     /**< The Item page's black fill is still to come. */
    std::uint64_t      generation = 0;                           /**< Frame at which this menu opened. */
    float              frame_progress = 1.0f;                    /**< Native orb size, zero when closed and one when open. */
    bool               entering = false;                         /**< The orb is closing into Items. */
    bool               returning = false;                        /**< The orb is opening toward the main menu. */
    bool               orb_closed = false;                       /**< The orb has closed into Items and not yet reopened. */
    float              character_alpha = 1.0f;                   /**< Opacity the menu character has faded in to, one when opaque. */
    std::uint64_t      character_fade_frame = ~std::uint64_t{0}; /**< Frame at which the fade last stepped. */
};

State state;

// Set while a cursor form draws, which places its pieces by the cursor's shift instead of a panel anchor.
bool drawing_cursor = false;

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

// Bigger bodies are shrunk about their feet to fit between the circles and the status bars.
float ViewScale(int view) {
    if (view == MENU_ITEM_VIEW_ROBO) {
        return kRoboScale;
    }
    return view == MENU_ITEM_VIEW_MONSTER ? kMonsterScale : 1.0f;
}

// The menu's own camera step (MenuWorldTrans), moved sideways with the panels so a looked-at weapon stays over
// its stats.
void ViewThroughMenuCamera() {
    mgCCamera &camera = MenuDrawEnv->camera;
    float      view[4][4];
    Vector     pos{};
    camera.GetCameraMatrix(view);
    camera.GetPos(pos.data());
    camera.SetSpeed(MenuDrawEnv->speed, -1.0f);
    camera.SetNextRef(MenuDrawEnv->ref);
    camera.SetNextPos(MenuDrawEnv->pos);
    camera.Step(1);

    float projection = MenuDrawEnv->projection;
    if (CActionChara *model = MenuActionChara[0]; model != nullptr && projection > 0.0f) {
        Vector at{};
        model->GetPosition(at.data());
        const float depth = std::fabs(at[0] * view[0][2] + at[1] * view[1][2] + at[2] * view[2][2] + view[3][2]);
        if (depth > 1.0f) {
            const int mode = class_menu_item_info.view_mode;
            if (mode == MENU_ITEM_VIEW_WEAPON || mode == MENU_ITEM_VIEW_FISHING_ROD) {
                view[3][0] += LayoutLeft() * depth / projection;
            } else {
                const float body_height = std::max(model->body_height, 1.0f);
                // The model origin sits at the feet, so the body is framed from the feet up to the head.
                const float frame_scale = static_cast<float>(mgScreenHeight) / kFrameHeight;
                const float desired_height = (kFeetScreenY - kHeadScreenY) * frame_scale * ViewScale(mode);
                // The projection scales Y by the pixel aspect, so Y offsets and heights are divided by it.
                const float aspect_y = mgRenderInfo.aspect[1][1];
                projection = std::clamp(desired_height * depth / (body_height * kModelHeightPerBodyHeight * aspect_y),
                                        MenuDrawEnv->projection * 0.3f, MenuDrawEnv->projection * 1.6f);
                const float view_x = at[0] * view[0][0] + at[1] * view[1][0] + at[2] * view[2][0] + view[3][0];
                const float view_y = at[0] * view[0][1] + at[1] * view[1][1] + at[2] * view[2][1] + view[3][1];
                const float desired_x = LayoutLeft() + kFramingScreenX - static_cast<float>(mgScreenWidth) * 0.5f;
                const float desired_y = kFeetScreenY * frame_scale - static_cast<float>(mgScreenHeight) * 0.5f;
                view[3][0] += desired_x * depth / projection - view_x;
                view[3][1] += desired_y * depth / (projection * aspect_y) - view_y;
            }
        }
    }
    mgSetProjection(projection);
    mgSetViewMatrix(view, pos.data());
}

// Sets the opacity of each part of a character. The character's draw takes its own alpha, which fades the outline
// composite that the menu model draws with.
void SetCharacterOpacity(CActionChara *chara, float alpha) {
    int count = 0;
    for (CActionChara *part = chara; part != nullptr && count < kMaxPartChain; part = part->next, ++count) {
        part->alpha = alpha;
    }
}

// A frame draws under its own key, and a visual drawn at a frame, a shadow volume among them, under the visual's.
void InsertFrameKeys(const mgCFrame *frame, std::unordered_set<gfx::InterpKey> &keys) {
    keys.insert(reinterpret_cast<gfx::InterpKey>(frame));
    if (frame->visual != nullptr) {
        keys.insert(reinterpret_cast<gfx::InterpKey>(frame->visual));
    }
}

void CollectFrameKeys(const mgCFrame *root, std::unordered_set<gfx::InterpKey> &keys) {
    if (root == nullptr) {
        return;
    }
    InsertFrameKeys(root, keys);
    if (root->frame_list != nullptr && root->frame_num > 0) {
        for (int index = 0; index < root->frame_num; ++index) {
            if (root->frame_list[index] != nullptr) {
                InsertFrameKeys(root->frame_list[index], keys);
            }
        }
        return;
    }
    for (const mgCFrame *child = root->child; child != nullptr; child = child->brother) {
        CollectFrameKeys(child, keys);
    }
}

// The model copy an effect script moves and draws as meshes.
void CollectCharaKeys(const CCharacter2 *chara, std::unordered_set<gfx::InterpKey> &keys) {
    if (chara != nullptr) {
        CollectFrameKeys(chara->CObjectFrame::frame, keys);
    }
}

// Keys of the player's own draws: its chain of parts with their shadows and outlines, and the effect scripts it
// started. The town's exit markers stand on the player too.
PlayerlessFilter CollectPlayerKeys() {
    constexpr int                       kMaxEffectScripts = 256;
    PlayerlessFilter                    filter;
    std::unordered_set<gfx::InterpKey> &keys = filter.keys;
    int                                 chain_length = 0;
    for (const CActionChara *part = state.player; part != nullptr && chain_length++ < kMaxPartChain; part = part->next) {
        CollectFrameKeys(part->CObjectFrame::frame, keys);
        CollectFrameKeys(part->shadow_frame, keys);
        for (int index = 0; part->lod != nullptr && index < part->lod_num; ++index) {
            CollectFrameKeys(part->lod[index].frame, keys);
        }
        for (const COutLineDraw *outline = part->outline; outline != nullptr; outline = outline->next) {
            CollectFrameKeys(outline->frame, keys);
        }
    }

    int                     script_count = 0;
    const CEffectScriptMan *effects = state.player->effect_man;
    for (const _EFF_SCRIPT *script = effects != nullptr ? effects->head : nullptr;
         script != nullptr && script_count++ < kMaxEffectScripts; script = script->next) {
        CollectCharaKeys(script->chara, keys);
        for (const CCharacter2 *sub_chara : script->sub_chara) {
            CollectCharaKeys(sub_chara, keys);
        }
    }

    // The blue marker is drawn only on the player. The red one is also drawn for NPCs earlier in the frame, so only
    // its last run of meshes, the player's, is left out.
    if (PortTownLoopMode == EDIT_LOOP_WALK_MENU) {
        CollectFrameKeys(BlueBicMark, keys);
        const CScene *scene = GetMainScene();
        if (scene != nullptr && (scene->map_event_no & 1) != 0) {
            CollectFrameKeys(RedBicMark, filter.trailing_run_keys);
        }
    }
    return filter;
}

// Entries of the last contiguous run of meshes keyed by keys, where the run ignores the entries between its meshes.
std::unordered_set<std::size_t> LastTrailingRun(const gfx::DisplayList                   &source,
                                                const std::unordered_set<gfx::InterpKey> &keys) {
    std::unordered_set<std::size_t> run;
    bool                            in_run = false;
    for (std::size_t index = source.entries.size(); index-- > 0;) {
        const auto *mesh = std::get_if<gfx::detail::MeshEntry>(&source.entries[index]);
        if (mesh == nullptr) {
            continue;
        }
        const bool trailing = mesh->record < source.records.size() && keys.contains(source.records[mesh->record].key);
        if (!trailing) {
            if (in_run) {
                break;
            }
            continue;
        }
        in_run = true;
        run.insert(index);
    }
    return run;
}

// A vertex at (x, y) that samples the captured picture at texel (u, v).
gfx::Vertex2D PictureCorner(float x, float y, float u, float v) {
    return gfx::Vertex2D{
        .x = x, .y = y, .z = 0.0f, .u = u, .v = v, .color = {0x80, 0x80, 0x80, 0x80}
    };
}

bool NamedForm(const CMenuPosDataForm &form, const char *name) {
    return form.name != nullptr && std::strcmp(form.name, name) == 0;
}

// Draws a quad of the captured world: the clean copy at full opacity, then the player over it at player_alpha.
void DrawPausePicture(std::array<gfx::Vertex2D, 4> vertices, int player_alpha) {
    gfx::DrawState draw_state = mgPortDrawState();
    draw_state.blend = true;
    draw_state.alpha = {};
    draw_state.alpha_test = false;
    draw_state.depth_test = gfx::DepthTest::Always;
    draw_state.depth_write = false;
    draw_state.cull = gfx::CullMode::None;
    draw_state.scissor = false;
    gfx::TextureBinding binding;
    binding.texture = state.clean_picture != gfx::kNullTexture ? state.clean_picture : state.picture;
    binding.ignore_alpha = true;
    for (auto &vertex : vertices) {
        vertex.color[3] = kFullPictureAlpha;
    }
    mgPortDraw2D(gfx::Primitive::TriangleStrip, vertices, binding, draw_state);
    if (player_alpha > 0 && state.clean_picture != gfx::kNullTexture) {
        for (auto &vertex : vertices) {
            vertex.color[3] = static_cast<uint8_t>(player_alpha);
        }
        binding.texture = state.picture;
        mgPortDraw2D(gfx::Primitive::TriangleStrip, vertices, binding, draw_state);
    }
}

} // namespace

bool RenderPauseFrame(const gfx::DisplayList &source) {
    if (state.stage != Stage::Open || state.captured || state.player == nullptr) {
        return false;
    }
    const gfx::TextureHandle clean = gfx::NamedRenderTarget("menu world without player",
                                                            static_cast<uint32_t>(mgScreenWidth),
                                                            static_cast<uint32_t>(mgScreenHeight), false, false, true);
    if (clean == gfx::kNullTexture) {
        return false;
    }
    PlayerlessFilter filter = CollectPlayerKeys();
    filter.outline_target = gfx::FindNamedRenderTarget("outline");

    gfx::DisplayList replay;
    BuildPlayerlessReplay(source, filter, clean, replay);
    if (!gfx::RenderList(replay, 1.0f, gfx::RenderOptions{.canonical = true})) {
        return false;
    }
    state.clean_picture = clean;
    return true;
}

void BuildPlayerlessReplay(const gfx::DisplayList &source, const PlayerlessFilter &filter, gfx::TextureHandle clean,
                           gfx::DisplayList &replay) {
    replay.instance = source.instance;
    replay.serial = source.serial;
    replay.records = source.records;
    replay.cameras = source.cameras;
    replay.scenes = source.scenes;
    replay.prog0_blocks = source.prog0_blocks;
    replay.palettes = source.palettes;
    replay.main_cleared = source.main_cleared;
    replay.needs_base = source.needs_base;
    replay.cut_generation = source.cut_generation;

    const std::unordered_set<std::size_t> trailing_run = LastTrailingRun(source, filter.trailing_run_keys);
    const bool                            has_outline = filter.outline_target != gfx::kNullTexture;
    // Whether the outline target holds draws since its last clear. The composites sample it, and sample nothing
    // once the player's meshes are the only draws it had.
    bool               outline_drawn = false;
    gfx::TextureHandle target = gfx::kMainTarget;
    replay.entries.reserve(source.entries.size() * 2 + 1);
    for (std::size_t index = 0; index < source.entries.size(); ++index) {
        const gfx::detail::Entry &entry = source.entries[index];
        if (const auto *mesh = std::get_if<gfx::detail::MeshEntry>(&entry)) {
            const bool player = mesh->record < source.records.size() &&
                                filter.keys.contains(source.records[mesh->record].key);
            if (player || trailing_run.contains(index)) {
                continue;
            }
            if (has_outline && target == filter.outline_target) {
                outline_drawn = true;
            }
            replay.entries.push_back(entry);
        } else if (const auto *draw = std::get_if<gfx::detail::Draw2DEntry>(&entry)) {
            if (draw->interpolation.key == kPlayerEffectKey) {
                continue;
            }
            if (has_outline && draw->binding.texture == filter.outline_target && !outline_drawn) {
                continue;
            }
            if (has_outline && draw->target == filter.outline_target) {
                outline_drawn = true;
            }
            replay.entries.push_back(entry);
        } else if (const auto *target_entry = std::get_if<gfx::detail::TargetEntry>(&entry)) {
            target = target_entry->target;
            replay.entries.push_back(entry);
        } else if (std::holds_alternative<gfx::detail::ClearEntry>(entry)) {
            if (has_outline && target == filter.outline_target) {
                outline_drawn = false;
            }
            replay.entries.push_back(entry);
        } else if (!std::holds_alternative<gfx::detail::ReadDepthEntry>(entry)) {
            replay.entries.push_back(entry);
        }
    }
    const gfx::Rect frame{.x = 0, .y = 0, .w = mgScreenWidth, .h = mgScreenHeight};
    replay.entries.emplace_back(gfx::detail::CopyEntry{.kind = gfx::detail::CopyEntry::Blit,
                                                       .src = gfx::kMainTarget,
                                                       .src_rect = frame,
                                                       .dst = clean,
                                                       .dst_rect = frame,
                                                       .filter = gfx::Filter::Linear});
    replay.entries.insert(replay.entries.end(), source.entries.begin(), source.entries.end());
}

PlayerEffectScope::PlayerEffectScope(bool player_owned) {
    if (player_owned && PausingDungeonFrame()) {
        tag.emplace(gfx::Interp2D{.key = kPlayerEffectKey, .generation = static_cast<std::uint64_t>(mgPortFrameCount())});
    }
}

bool PausingDungeonFrame() {
    return state.stage == Stage::Idle && GetNowLoopNo() == LOOP_DUNGEON && DngStatus.mode == DNG_STATUS_MENU;
}

const CActionChara *PausingPlayer() {
    if (!PausingDungeonFrame()) {
        return nullptr;
    }
    CScene *scene = GetMainScene();
    return scene != nullptr ? static_cast<CActionChara *>(scene->GetCharacter(scene->player_chara)) : nullptr;
}

void MenuOpening(const MENU_INIT_ARG *arg) {
    if (arg == nullptr || SubGameRunning()) {
        return;
    }
    const bool town = arg->open_type == MENU_OPEN_MAIN_TOWN && PortTownLoopMode == EDIT_LOOP_WALK_MENU;
    const bool dungeon = arg->open_type == MENU_OPEN_MAIN_DUNGEON && DngStatus.mode == DNG_STATUS_MENU;
    if (town || dungeon) {
        CScene *scene = GetMainScene();
        state = State{
            .stage = Stage::Open,
            .picture = state.picture,
            .player = scene != nullptr ? static_cast<CActionChara *>(scene->GetCharacter(scene->player_chara)) : nullptr,
            .generation = static_cast<std::uint64_t>(mgPortFrameCount()),
        };
    }
}

gfx::TextureHandle TakeMenuGrab() {
    if (state.stage != Stage::Open || state.captured) {
        return gfx::kPreviousFrame;
    }
    state.picture = gfx::NamedRenderTarget("menu world", static_cast<uint32_t>(mgScreenWidth),
                                           static_cast<uint32_t>(mgScreenHeight), false, false, true);
    const gfx::Rect frame{.x = 0, .y = 0, .w = mgScreenWidth, .h = mgScreenHeight};
    state.captured = state.picture != gfx::kNullTexture &&
                     gfx::BlitTexture(gfx::kPreviousFrame, frame, state.picture, frame, gfx::Filter::Linear);
    return gfx::kPreviousFrame;
}

void MenuClosed() {
    state = State{.picture = state.picture};
}

void ItemOpening() {
    // A page reopened from a sub page, with the orb already closed, shows the character at once; a first opening fades it in.
    state.character_alpha = state.orb_closed ? 1.0f : 0.0f;
    state.character_fade_frame = ~std::uint64_t{0};
    // The orb stays closed while the Items page reopens from one of its sub pages.
    if (state.stage != Stage::Open || state.orb_closed) {
        return;
    }
    state.frame_progress = 1.0f;
    state.entering = true;
    state.returning = false;
    MenuMainFrameModeSet(MENU_MAIN_FRAME_CLOSE, true);
}

int FrameMode(int requested) {
    if (requested == MENU_MAIN_FRAME_SLIDE_BACK && state.stage == Stage::Open && state.orb_closed &&
        MenuCommonInfo != nullptr && MenuCommonInfo->now_mode == MENU_MODE_ITEM) {
        state.entering = false;
        state.returning = true;
        state.frame_progress = 0.0f;
        return MENU_MAIN_FRAME_OPEN;
    }
    return requested;
}

void FrameStepped() {
    if (!state.entering && !state.returning) {
        return;
    }
    // The closing tick still draws the orb at zero, where it matches the strip; the orb stops on the next tick.
    if (state.entering && state.orb_closed) {
        state.entering = false;
        return;
    }
    // Native OPEN/CLOSE place the main frame's left edge at -269 + 269 * progress.
    state.frame_progress = std::clamp((GetMenuMainFrameLeftTopPos(0)[0] + kMainFrameTravel) / kMainFrameTravel, 0.0f, 1.0f);
    // Native CLOSE can raise the end flag on its first step, before the orb has moved, so the entry ends only once
    // the orb is fully closed.
    if (state.entering && GetMenuMainFrameEndFlag() && state.frame_progress <= 0.0f) {
        state.orb_closed = true;
        state.frame_progress = 0.0f;
    } else if (state.returning && GetMenuMainFrameEndFlag()) {
        state.returning = false;
        state.orb_closed = false;
        state.frame_progress = 1.0f;
    }
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
    // The debug item browser lays its draws out across the whole frame, which a spread would tear apart.
    if (menu_debug_flag != 0) {
        return;
    }
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

    const gfx::UiAnchorScope unanchored(gfx::UiAnchor{});
    // A frame target addresses the window's sides past the logical frame at texels outside it.
    const mgPortExtent extent = mgPortVisibleExtent();
    const std::array   strip = {PictureCorner(extent.left, extent.top, extent.left, extent.top),
                                PictureCorner(extent.right, extent.top, extent.right, extent.top),
                                PictureCorner(extent.left, extent.bottom, extent.left, extent.bottom),
                                PictureCorner(extent.right, extent.bottom, extent.right, extent.bottom)};
    // The picture fills the window behind the spread panels, not the spread itself.
    const gfx::Interp2DScope interpolation({.key = kBackdropKey, .generation = state.generation});
    DrawPausePicture(strip, PlayerDissolveAlpha());
    return true;
}

bool DrawOrbPicture() {
    if (!ItemBackdrop() || !state.entering || state.clean_picture == gfx::kNullTexture) {
        return false;
    }
    // The orb shows the whole captured frame squeezed into the main frame image's rectangle, one pixel taller
    // at the bottom as the retail draw is.
    const mgRect<int> &put = MenuMainIMG_PutRect;
    const float        left = static_cast<float>(put.left);
    const float        top = static_cast<float>(put.top);
    const float        right = left + static_cast<float>(put.right);
    const float        bottom = top + static_cast<float>(put.bottom) + 1.0f;
    const auto         width = static_cast<float>(mgScreenWidth);
    const auto         height = static_cast<float>(mgScreenHeight);

    // Unanchored, the quad's corners are the logical positions the backdrop strip samples, so a corner at progress
    // zero samples exactly the strip beneath it.
    const gfx::UiAnchorScope unanchored(gfx::UiAnchor{});
    const float              progress = state.frame_progress;
    const auto               corner = [&](float x, float y, float full_u, float full_v) {
        return PictureCorner(x, y, std::lerp(x, full_u, progress), std::lerp(y, full_v, progress));
    };
    const std::array orb = {corner(left, top, 0.0f, 0.0f), corner(right, top, width, 0.0f),
                            corner(left, bottom, 0.0f, height), corner(right, bottom, width, height)};
    DrawPausePicture(orb, PlayerDissolveAlpha());
    return true;
}

int PlayerDissolveAlpha() {
    return state.entering ? static_cast<int>(std::lround(kFullPictureAlpha * state.frame_progress)) : 0;
}

bool ViewMenuCharacter() {
    // The debug item browser draws its model through the menu's own camera.
    if (!ItemBackdrop() || menu_debug_flag != 0 || MenuActionChara[0] == nullptr) {
        return false;
    }
    ViewThroughMenuCamera();
    return true;
}

bool HidesForm(const CMenuPosDataForm &form) {
    if (!ItemBackdrop()) {
        return false;
    }
    if (&form == class_menu_item_info.fill_form || NamedForm(form, "mainform_fill") ||
        NamedForm(form, "mainform_filldmy")) {
        return true;
    }
    // The menu character waits for the orb to close into Items, then fades in.
    if (form.dtype == MENUFORM_DTYPE_POLY && form.chara != nullptr && state.entering && state.character_alpha < 1.0f) {
        return true;
    }
    // The main frame and its image stay on screen only while the orb moves them.
    const bool main_chrome = form.dtype == MENUFORM_DTYPE_MAINFRM || form.dtype == MENUFORM_DTYPE_MAINIMG;
    return main_chrome && !state.entering && !state.returning;
}

float ItemPanelSplit(const CMenuPosDataForm *board) {
    if (board != nullptr) {
        if (const auto inward_x = InwardX(*board); inward_x && *inward_x > 0.0f && *inward_x < mgScreenWidth) {
            return *inward_x - 2.0f;
        }
    }
    return kDefaultPanelSplit;
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
    return x >= split - kPanelFlipWidth ? 1 : -1;
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
    // The main frame keeps the root menu's placement, its backdrop widened past the frame, while the orb moves it.
    const bool main_chrome = form.dtype == MENUFORM_DTYPE_MAINFRM || form.dtype == MENUFORM_DTYPE_MAINIMG;
    if (main_chrome || RootChromeUnanchored(form)) {
        return gfx::UiAnchor{};
    }
    // The command popup moves with the panel of the item it is for.
    if (class_menu_item_info.mode != MENU_ASK_MODE_NONE && &form == class_menu_item_info.ask_para.form) {
        return gfx::UiAnchor::Side(SelectionSide(), 0, true, kLayoutAspect);
    }
    return gfx::UiAnchor::Side(ItemPanelSide(form, LayoutSplit()), 0, true, kLayoutAspect);
}

std::optional<gfx::UiAnchor> SelectionAnchor() {
    if (!ItemBackdrop() || drawing_cursor) {
        return std::nullopt;
    }
    return gfx::UiAnchor::Side(SelectionSide(), 0, true, kLayoutAspect);
}

bool CursorDrawing() {
    return drawing_cursor;
}

CursorDrawScope::CursorDrawScope() {
    drawing_cursor = true;
}

CursorDrawScope::~CursorDrawScope() {
    drawing_cursor = false;
}

CharacterFadeScope::CharacterFadeScope(const CMenuPosDataForm &form) {
    if (!ItemBackdrop() || form.dtype != MENUFORM_DTYPE_POLY || form.chara == nullptr ||
        form.counter < kCharacterDrawCounter || state.character_alpha >= 1.0f) {
        return;
    }
    // The menu draws the character several times a frame, so the ramp steps once per frame rather than per draw.
    const auto frame = static_cast<std::uint64_t>(mgPortFrameCount());
    if (frame != state.character_fade_frame) {
        state.character_fade_frame = frame;
        state.character_alpha = std::min(1.0f, state.character_alpha + 1.0f / kCharacterFadeTicks);
    }
    chara = form.chara;
    SetCharacterOpacity(chara, state.character_alpha);
}

CharacterFadeScope::~CharacterFadeScope() {
    if (chara != nullptr) {
        SetCharacterOpacity(chara, 1.0f);
    }
}

bool CursorForm(const CMenuPosDataForm &form) {
    if (!ItemBackdrop()) {
        return false;
    }
    return &form == MenuCommonInfo->cursor_form || NamedForm(form, "cursor0") || NamedForm(form, "cur_waku0");
}

bool CursorShown() {
    if (!ItemBackdrop()) {
        return true;
    }
    // The cursor waits for the orb and the panels to settle, so it does not slide in ahead of them.
    if (state.entering || state.returning) {
        return false;
    }
    // A panel still sliding in runs its action; the character pages keep theirs running, so they are not waited on.
    for (int i = 0; i < MenuPosData->form_num; ++i) {
        const CMenuPosDataForm *form = MenuPosData->GetFormInfo(i);
        if (form == nullptr || !form->active || !form->draw_flag || CursorForm(*form) || HidesForm(*form)) {
            continue;
        }
        const bool view_page =
            std::find(std::begin(class_menu_item_info.view_form), std::end(class_menu_item_info.view_form), form) !=
            std::end(class_menu_item_info.view_form);
        if (!view_page && form->action_state == MENUFORM_ACTION_STATE_RUN) {
            return false;
        }
    }
    return true;
}

float CursorFrameShift() {
    // The build-up list is drawn with the left panels, and its hand sits near the split, where the eased shift
    // would carry it far right of its row. It takes the selection's side, as the pointer does (RetailPointerX).
    if (class_menu_item_info.mode == MENU_ASK_MODE_EXTEND && class_menu_item_info.ask_para.ask_mode == MENU_ITEM_EXTEND_BUILD_UP) {
        return SelectionSide() > 0 ? -LayoutLeft() : LayoutLeft();
    }
    // The selection frame's x tweens with the selection, so one shift keeps the hand and the frame together.
    const CMenuPosDataForm *frame = MenuPosData->GetFormInfo(const_cast<char *>("cur_waku0"));
    if (frame == nullptr) {
        frame = MenuCommonInfo->cursor_form;
    }
    return frame != nullptr ? CursorShift(frame->x) : 0.0f;
}

float CursorShift(float x) {
    // Matches the sides ItemPanelSide gives the panels: the left panels' shift up to the flip, the right's from the split.
    const float shift = LayoutLeft();
    const float split = LayoutSplit();
    const float flip = split - kPanelFlipWidth;
    if (x <= flip) {
        return shift;
    }
    if (x >= split) {
        return -shift;
    }
    return std::lerp(shift, -shift, (x - flip) / kPanelFlipWidth);
}

float RetailPointerX(float x) {
    if (!ItemBackdrop()) {
        return x;
    }
    const float shift = LayoutLeft();
    if (class_menu_item_info.mode != MENU_ASK_MODE_NONE) {
        return SelectionSide() > 0 ? x + shift : x - shift;
    }
    const bool holding = MenuCommonInfo != nullptr && MenuCommonInfo->have_item.item_no > 0;
    return SpreadPointerX(x, shift, LayoutSplit(), holding);
}

float SpreadPointerX(float x, float shift, float split, bool holding) {
    // The view pages move whole with the left spread right up to the split, so a part in the band where the
    // retail cursor eases across (Max's second weapon) is hit where it is drawn. The bag moves with the right.
    if (x < split + shift) {
        return x - shift;
    }
    if (x >= split - shift) {
        return x + shift;
    }
    // The gap the spread opens beside the bag: its first column while an item is held, so it stays by the
    // pointer, and nothing otherwise.
    return holding ? split + kHeldPointerOffset : kOffLayout;
}

float SpreadX(float retail_x) {
    if (!ItemBackdrop()) {
        return retail_x;
    }
    if (class_menu_item_info.mode != MENU_ASK_MODE_NONE) {
        return SelectionSide() > 0 ? retail_x - LayoutLeft() : retail_x + LayoutLeft();
    }
    return retail_x + CursorFrameShift();
}

} // namespace menuworld
