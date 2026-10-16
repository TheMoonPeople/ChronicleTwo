#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <functional>
#include <map>
#include <string>
#include <vector>

#include "actionchara.hpp"
#include "gamedata.hpp"
#include "gfx/gfx.hpp"
#include "item_icon3d.hpp"
#include "menumain.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/model_assets.hpp"
#include "userdata.hpp"

namespace {

bool g_textures_ready = false;

constexpr int   kIcon = 32;
constexpr int   kScratch = 512; // the scratch picture's side; the projection's aspect is made for a screen 512 wide
constexpr int   kCrop = 128;    // scratch pixels turned into one icon (4x4 each)
constexpr float kFill = 120.0f; // pixels across the model inside the crop
constexpr int   kModelBlock = 0;
constexpr int   kIconBlock = MG_TEXTURE_IMG_GROUP_MAX;
constexpr int   kIconSlots = 512;
constexpr int   kCachedIcons = 128;

/**
 * Owns icon textures independently of each gameplay mode's texture table.
 */
struct IconTextures {
    std::vector<u_long128> storage;           /**< Backing allocation for the manager tables. */
    mgCMemory              memory;            /**< Aligned table allocation view. */
    mgCTextureManager      manager;           /**< Independent model and icon texture ownership. */
    mgCTexture            *scratch = nullptr; /**< Reusable model render destination. */

    IconTextures() {
        const auto bytes = (kIconBlock + 1) * sizeof(mgCTextureBlock) +
                           kIconSlots * (sizeof(mgCTexture) + sizeof(mgTEXTURE_HASH) + sizeof(mgCTexture *) + sizeof(mgTEXTURE_HASH *)) + 1024;
        storage.resize((bytes + 63) / 16 + 4);
        const auto aligned = (reinterpret_cast<std::uintptr_t>(storage.data()) + 63) & ~std::uintptr_t{63};
        memory.stSetBuffer(reinterpret_cast<u_long128 *>(aligned), static_cast<int>((storage.size() * sizeof(u_long128) - (aligned - reinterpret_cast<std::uintptr_t>(storage.data()))) / sizeof(u_long128)));
        manager.SetTableBuffer(kIconSlots, kIconBlock + 1, &memory);
        manager.Initialize(0, -1);
        g_textures_ready = true;
    }
};

/**
 * Returns the lazily allocated icon texture owner.
 */
IconTextures &Textures() {
    static IconTextures textures;
    return textures;
}

/**
 * Reports whether an environment feature switch is enabled.
 */
bool EnvOn(const char *name) {
    const char *value = std::getenv(name);
    return value != nullptr && value[0] != 0 && value[0] != '0';
}

/**
 * Retains one successful or unavailable icon and its last draw frame.
 */
struct Icon {
    mgCTexture        *texture = nullptr;
    bool               failed = false;
    unsigned long long used = 0;
};

std::map<int, Icon> g_icons;
int                 g_icon_frame = -1;
int                 g_serial = 0;

bool g_box_from_bound = false; // a skin's vertices are in the bones' space, so its stored bound is used

/**
 * Identifies clothing items applied to a native base character.
 */
bool IsSkinItem(int item_type) {
    return item_type == ITEM_DATA_MAX_CLOTHES || item_type == ITEM_DATA_MONICA_CLOTHES || item_type == ITEM_DATA_MAX_SHOES ||
           item_type == ITEM_DATA_MONICA_BOOTS;
}

/**
 * Identifies clothing items whose icon shows footwear.
 */
bool IsFootwear(int item_type) {
    return item_type == ITEM_DATA_MAX_SHOES || item_type == ITEM_DATA_MONICA_BOOTS;
}

/**
 * Selects an item's native model path, excluding whole-character costumes and stand-ins.
 */
bool ModelPath(int item_no, char *path, std::size_t size) {
    CDataCommon *record = GameItemDataManage.GetCommonData(item_no);
    if (record == nullptr || record->file_name[0] == 0) {
        return false;
    }
    const int type = ConvertUsedItemType(record->type);
    // A hat or a hair accessory is a model of its own (the game hangs it on the character's head); clothes and shoes are
    // skins on the character and are drawn another way.
    if (type == USED_ITEM_TYPE_COSTUME && record->type != ITEM_DATA_MAX_HAT && record->type != ITEM_DATA_MONICA_ACCESSORY) {
        if (!IsSkinItem(record->type)) {
            return false;
        }
        char *skin = GetItemFilePath(item_no, 0);
        if (skin == nullptr || skin[0] == 0) {
            return false;
        }
        std::snprintf(path, size, "%s", skin);
        return true;
    }
    // A weapon or a robo part has a model made for the item view; the rest are the one model.
    char *variant = GetItemFilePath(item_no, 1);
    char  probe[0x80];
    if (variant != nullptr && variant[0] != 0 && (type == USED_ITEM_TYPE_WEAPON || type == USED_ITEM_TYPE_ROBO_PART)) {
        std::snprintf(probe, sizeof probe, "%s", variant);
        std::snprintf(path, size, "%s", probe);
        return true;
    }
    char *plain = GetItemFilePath(item_no, 0);
    if (plain == nullptr || plain[0] == 0) {
        return false;
    }
    std::snprintf(path, size, "%s", plain);
    // The treasure chest's model stands in for items that have none of their own.
    return std::strstr(path, "d_box") == nullptr;
}

/**
 * Returns the camera used to render item icons.
 */
mgCCamera *IconCamera() {
    static mgCCamera camera(1.0f);
    return &camera;
}

/**
 * Measures visible model geometry in world coordinates.
 */
void DrawnBox(mgCFrame *node, float lo[3], float hi[3], bool &any) {
    for (; node != nullptr; node = node->brother) {
        const int draw = node->attr != nullptr ? node->attr->draw : MG_FRAME_DRAW_VISIBLE;
        if (node->attr != nullptr && (draw & MG_FRAME_DRAW_SKIP_BY_PARENT)) {
            continue;
        }
        if (node->visual != nullptr && node->bound != nullptr && (draw & MG_FRAME_DRAW_VISIBLE)) {
            float matrix[4][4];
            node->GetLWMatrix(matrix);
            // The stored bound is loose for some models (a robo arm's is far larger than the arm), so the model's own vertices
            // are used where it has them; the bound's corners are the fallback.
            const mgCVisualMDT *mdt = dynamic_cast<const mgCVisualMDT *>(node->visual);
            const bool          vertices = mdt != nullptr && mdt->vertex != nullptr && mdt->vertex_num > 0 && !g_box_from_bound;
            const int           count = vertices ? mdt->vertex_num : 8;
            for (int n = 0; n < count; n++) {
                float point[4];
                if (vertices) {
                    point[0] = mdt->vertex[n][0];
                    point[1] = mdt->vertex[n][1];
                    point[2] = mdt->vertex[n][2];
                    point[3] = 1.0f;
                } else {
                    point[0] = (n & 1) ? node->bound->max[0] : node->bound->min[0];
                    point[1] = (n & 2) ? node->bound->max[1] : node->bound->min[1];
                    point[2] = (n & 4) ? node->bound->max[2] : node->bound->min[2];
                    point[3] = 1.0f;
                }
                float world[4];
                sceVu0ApplyMatrix(world, matrix, point);
                for (int i = 0; i < 3; i++) {
                    if (!any || world[i] < lo[i]) {
                        lo[i] = world[i];
                    }
                    if (!any || world[i] > hi[i]) {
                        hi[i] = world[i];
                    }
                }
                any = true;
            }
        }
        if (!(node->attr != nullptr && (draw & MG_FRAME_DRAW_SKIP_CHILDREN))) {
            DrawnBox(node->child, lo, hi, any);
        }
    }
}

/**
 * Renders one native item model into the supplied icon texture.
 */
bool Render(int item_no, mgCTexture *icon) {
    char path[0x80];
    if (!ModelPath(item_no, path, sizeof path)) {

        return false;
    }

    CDataCommon *item_record = GameItemDataManage.GetCommonData(item_no);
    const bool   skinned = item_record && IsSkinItem(item_record->type);
    char         skin_path[0x80] = {};
    if (skinned) {
        std::snprintf(skin_path, sizeof(skin_path), "%s", path);

        char       model_name[32] = {};
        const bool max = item_record->type == ITEM_DATA_MAX_CLOTHES || item_record->type == ITEM_DATA_MAX_SHOES;
        GetMainCharaModelName(max ? USER_CHARA_MAX : USER_CHARA_MONICA, model_name, 0);
        std::snprintf(path, sizeof(path), "mainchr/%s", model_name);
    }
    std::string error;
    auto        estimated = model_assets::EstimateCharacterMemory(path, "info", error);
    if (!estimated && !skinned) {
        const char *plain = GetItemFilePath(item_no, 0);
        if (!plain || !*plain) {
            return false;
        }
        std::snprintf(path, sizeof(path), "%s", plain);
        estimated = model_assets::EstimateCharacterMemory(path, "info", error);
    }
    if (!estimated) {

        return false;
    }
    std::size_t bytes = *estimated + sizeof(CActionChara) + 65536;
    if (skinned) {
        const auto skin_estimate = model_assets::EstimateCharacterMemory(skin_path, "info", error);
        if (!skin_estimate) {
            return false;
        }
        bytes += *skin_estimate;
    }
    if (bytes > 256u * 1024u * 1024u) {
        return false;
    }
    std::vector<u_long128> storage((bytes + 63) / 16 + 4);
    const auto             aligned = (reinterpret_cast<std::uintptr_t>(storage.data()) + 63) & ~std::uintptr_t{63};
    mgCMemory              stack;
    stack.stSetBuffer(reinterpret_cast<u_long128 *>(aligned), static_cast<int>(bytes / 16));
    auto *chara = new (stack.Alloc((sizeof(CActionChara) + 15) / 16 + 2)) CActionChara;
    chara->Initialize(nullptr);

    struct CharacterCleanup {
        CActionChara &character;

        ~CharacterCleanup() {
            model_assets::DeleteCharacterTextures(character, 0, CHARA_IMAGE_MAX - 1);
            for (int block = 0; block < kIconBlock; ++block) {
                Textures().manager.DeleteBlock(block);
            }
            Textures().manager.name_suffix[0] = 0;
        }
    } cleanup{*chara};

    model_assets::CharacterLoadOptions options;
    options.model_memory = options.motion_memory = options.image_memory = &stack;
    options.textures = &Textures().manager;
    options.texture_block = kModelBlock;
    options.outline = false;
    std::strcpy(Textures().manager.name_suffix, "_menu");
    if (!model_assets::LoadCharacter(*chara, path, "info", options, error)) {
        return false;
    }
    if (skinned) {
        Textures().manager.DeleteTexAnime(kModelBlock);
        std::strcpy(Textures().manager.name_suffix, "_skin");
        if (!model_assets::LoadSkin(*chara, skin_path, "info", "", options, error)) {
            return false;
        }
    }
    Textures().manager.name_suffix[0] = 0;
    mgCFrame *frame = chara->CObjectFrame::frame;
    if (frame == nullptr) {
        return false;
    }
    g_box_from_bound = skinned;
    if (skinned) {
        // Only the item's own parts of the character are drawn: the jacket or dress, the shoes or boots. The rest of the
        // character (and the stand-in triangles the skin leaves in the other slots) stays hidden.
        const char *keep[3] = {nullptr, nullptr, nullptr};
        switch (item_record->type) {
            case ITEM_DATA_MAX_CLOTHES:
                keep[0] = "skin1"; // the jacket and arms; the legs and feet are left out so it can be drawn larger
                keep[1] = "skin2";
                break;
            case ITEM_DATA_MONICA_CLOTHES:
                keep[0] = "skin1";
                keep[1] = "skin2";
                break;
            default: // shoes and boots
                keep[0] = "skin3";
                break;
        }
        std::function<void(mgCFrame *)> hide = [&](mgCFrame *node) {
            for (; node != nullptr; node = node->brother) {
                if (node->visual != nullptr && node->attr != nullptr) {
                    bool wanted = false;
                    for (const char *name : keep) {
                        wanted = wanted || (name != nullptr && node->name != nullptr && std::strcmp(node->name, name) == 0);
                    }
                    if (!wanted) {
                        node->attr->draw &= ~MG_FRAME_DRAW_VISIBLE;
                    } else {
                        node->attr->draw |= MG_FRAME_DRAW_VISIBLE;
                        // the second layer (overalls, trousers) is drawn by the game itself, here it has to be asked for
                        node->attr->draw &= ~MG_FRAME_DRAW_SKIP_BY_PARENT;
                    }
                }
                hide(node->child);
            }
        };
        hide(frame);
    }

    CDataCommon *record = GameItemDataManage.GetCommonData(item_no);
    const int    type = ConvertUsedItemType(record->type);
    const bool   weapon = type == USED_ITEM_TYPE_WEAPON;

    // Turn the model with a chain of frames over it: its own pose (the item's way up, or the axis-aligned turn that
    // shows its broadest face), then the tip towards the viewer, then the roll in the picture; the outermost scales
    // and places it. Each is about the axis it names, which a single set of Euler angles cannot say.
    static mgCFrame root, roll, elev;
    mgCFrame       *chain[3] = {&root, &roll, &elev};
    for (mgCFrame *link : chain) {
        link->child = nullptr;
        link->brother = nullptr;
    }
    frame->parent = nullptr;
    root.SetChild(&roll);
    roll.SetChild(&elev);
    elev.SetChild(frame);

    struct FrameDetach {
        mgCFrame &parent;
        mgCFrame &child;

        ~FrameDetach() {
            parent.child = nullptr;
            child.parent = nullptr;
        }
    } detach{elev, *frame};

    root.SetScale(1.0f, 1.0f, 1.0f);
    root.SetPosition(0.0f, 0.0f, 0.0f);
    chara->SetPosition(0.0f, 0.0f, 0.0f);
    chara->SetScale(1.0f, 1.0f, 1.0f);

    float pose[3] = {0.0f, 0.0f, 0.0f};
    if (record->type == ITEM_DATA_MAX_HAT) {
        // A hat is modelled to be worn, so it is tipped back to be seen from the front and a little above, not from above.
        pose[0] = 3.1416f; // upside down as made: the crown up
    }
    float tip = (weapon || IsFootwear(record->type)) ? 0.0f : 0.35f;
    float roll_angle = 0.0f;
    float box_lo[3], box_hi[3];
    auto  place = [&]() {
        chara->SetRotation(pose[0], pose[1], pose[2]);
        chara->Step();
        elev.SetRotation(tip, 0.0f, 0.0f);
        roll.SetRotation(0.0f, 0.0f, roll_angle);
    };
    auto measure = [&]() {
        place();
        bool any = false;
        DrawnBox(frame, box_lo, box_hi, any);
        if (skinned && !IsFootwear(item_record->type)) {
            // An outfit's skin is the whole body's clothes; the icon is the upper torso, from the chest to the neck with the
            // shoulders and upper arms, so the box is taken from the character's own joints.
            float       neck[3] = {}, spine[3] = {}, right[3] = {}, left[3] = {};
            bool        have[4] = {false, false, false, false};
            float      *targets[4] = {neck, spine, right, left};
            const char *joints[4] = {"neck", "spine", "R_sdr", "L_sdr"};
            for (int j = 0; j < 4; j++) {
                mgCFrame *bone = chara->SearchObject(const_cast<char *>(joints[j]));
                if (bone == nullptr) {
                    continue;
                }
                float matrix[4][4], origin[4] = {0.0f, 0.0f, 0.0f, 1.0f}, world[4];
                bone->GetLWMatrix(matrix);
                sceVu0ApplyMatrix(world, matrix, origin);
                for (int i = 0; i < 3; i++) {
                    targets[j][i] = world[i];
                }
                have[j] = true;
            }
            if (have[0] && have[1] && have[2] && have[3]) {
                const float dx = right[0] - left[0], dy = right[1] - left[1], dz = right[2] - left[2];
                const float shoulders = std::sqrt(dx * dx + dy * dy + dz * dz);
                const float rise = std::max(0.001f, std::fabs(neck[1] - spine[1]));

                const float centre_x = (right[0] + left[0]) * 0.5f;
                // The shoulder joints sit at the neck, so the width comes from the chest's height.
                (void) shoulders;
                const float half_w = rise * 1.15f;
                box_lo[0] = centre_x - half_w;
                box_hi[0] = centre_x + half_w;
                box_lo[1] = std::min(neck[1], spine[1]) - 0.2f * rise;
                box_hi[1] = std::max(neck[1], spine[1]) + -0.03f * rise;
                box_lo[2] = std::min(neck[2], spine[2]) - rise;
                box_hi[2] = std::max(neck[2], spine[2]) + rise;
                any = true;
            }
        }
        if (!any) {
            mgVu0FBOX world;
            frame->GetWorldBBox(&world);
            for (int i = 0; i < 3; i++) {
                box_lo[i] = world.min[i];
                box_hi[i] = world.max[i];
            }
        }
    };
    auto area = [&]() { return (box_hi[0] - box_lo[0]) * (box_hi[1] - box_lo[1]); };
    measure();
    if (weapon) {
        // The broadest face to the viewer: of the axis-aligned turns, the one whose picture covers the most, the
        // smallest turn when two do alike.
        float best = -1.0f, best_turn = 1e9f, best_pose[3] = {0, 0, 0};
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                for (int k = 0; k < 4; k++) {
                    pose[0] = i * 1.5707964f;
                    pose[1] = j * 1.5707964f;
                    pose[2] = k * 1.5707964f;
                    measure();
                    const float turn = static_cast<float>(i + j + k);
                    const float a = area();
                    if (a > best * 1.02f || (a > best * 0.98f && turn < best_turn)) {
                        best = std::max(a, best);
                        best_turn = turn;
                        std::memcpy(best_pose, pose, sizeof pose);
                    }
                }
            }
        }
        std::memcpy(pose, best_pose, sizeof pose);
        measure();
    } else if (record->type == ITEM_DATA_MAX_HAT) {
        // Crown up, turned a little so the visor comes round towards the viewer.
        pose[1] = -1.3f;
        measure();
    } else if (record->type == ITEM_DATA_ROBO_ARM || IsFootwear(record->type)) {
        // The pair lies side by side across the model, so it is shown square on, or the left half would not be an arm.
        // Footwear is seen from the side, which also puts one of the pair behind the other.
        pose[1] = IsFootwear(record->type) ? 1.5708f : 0.0f;
        measure();
    } else {
        // Kept upright, turned about the vertical to the broadest view, leaning to a three-quarter turn.
        float best = -1.0f, best_yaw = 0.0f;
        for (int step = -6; step <= 6; step++) {
            pose[1] = step * 0.2618f;
            measure();
            const float score = area() * (1.0f - 0.04f * std::fabs(pose[1] - 0.5f));
            if (score > best) {
                best = score;
                best_yaw = pose[1];
            }
        }
        pose[1] = best_yaw - 0.2618f;
        measure();
    }

    // A robo arm's model is the pair side by side; the icon is the one on the left.
    const bool pair = record->type == ITEM_DATA_ROBO_ARM;
    if (pair) {
        box_hi[0] = (box_lo[0] + box_hi[0]) * 0.5f;
    }
    // Turned in the picture plane to the angle that takes the least room (a long thin model fits best along the diagonal),
    // so it can be drawn larger. The first of equals is the one turned the least, so upright models stay upright.
    if (!pair && !skinned) {
        float best_extent = 0.0f, best_roll = 0.0f;
        for (int step = -6; step <= 6; step++) {
            roll_angle = step * 0.2618f;
            measure();
            const float extent = std::max(box_hi[0] - box_lo[0], box_hi[1] - box_lo[1]);
            if (step == -6 || extent < best_extent * 0.97f) {
                best_extent = extent;
                best_roll = roll_angle;
            } else if (extent < best_extent * 1.03f && std::fabs(roll_angle) < std::fabs(best_roll)) {
                best_extent = std::min(extent, best_extent);
                best_roll = roll_angle;
            }
        }
        roll_angle = best_roll;
        measure();
    }
    const float mid[3] = {(box_lo[0] + box_hi[0]) * 0.5f, (box_lo[1] + box_hi[1]) * 0.5f, (box_lo[2] + box_hi[2]) * 0.5f};
    float       radius = 0.5f * std::max(box_hi[0] - box_lo[0], box_hi[1] - box_lo[1]);
    if (!(radius > 0.0001f)) {
        radius = 1.0f;
    }

    // The screen-bound test is made against the visible extent, which is not this picture's.
    std::function<void(mgCFrame *)> no_cull = [&](mgCFrame *node) {
        for (; node != nullptr; node = node->brother) {
            if (node->attr != nullptr) {
                node->attr->no_cull = 1;
            }
            no_cull(node->child);
        }
    };
    no_cull(frame);

    // The scratch picture is a texture of its own that the frame is drawn into, which is retail's way of drawing to a
    // texture (and sets the screen size the projection is made for).
    auto *&scratch_texture = Textures().scratch;
    if (scratch_texture == nullptr) {
        static char scratch_name[] = "dc2 item icon 3d scratch";
        scratch_texture = Textures().manager.EnterTexture(kIconBlock, scratch_name, nullptr, kScratch, kScratch, 32, nullptr, 0, 0);
    }
    gfx::TextureHandle target = mgPortRenderTarget(icon, true);
    if (scratch_texture == nullptr || target == gfx::kNullTexture) {
        return false;
    }

    // The camera looks down -z from z = distance at the origin; the picture's centre is the screen's.
    const float distance = 100.0f;
    mgCCamera  *camera = IconCamera();
    camera->pos[0] = camera->next_pos[0] = 0.0f;
    camera->pos[1] = camera->next_pos[1] = 0.0f;
    camera->pos[2] = camera->next_pos[2] = distance;
    camera->pos[3] = camera->next_pos[3] = 1.0f;
    camera->ref[0] = camera->next_ref[0] = 0.0f;
    camera->ref[1] = camera->next_ref[1] = 0.0f;
    camera->ref[2] = camera->next_ref[2] = 0.0f;
    camera->ref[3] = camera->next_ref[3] = 1.0f;
    camera->roll = 0.0f;
    float view[4][4];
    camera->GetCameraMatrix(view);

    mgPortRenderStateScope render_state;
    mgSetPkFrameBuffer(scratch_texture);
    gfx::TextureHandle scratch = mgPortCurrentTarget();
    mgSetProjection(800.0f);
    mgSetViewMatrix(view, camera->pos);
    const float saved_near = mgRenderInfo.clip_min[2];

    const float pixels_per_unit = 800.0f / distance;
    const float scale = (kFill * 0.5f) / (pixels_per_unit * radius);
    // The projection stretches y (the screen's pixels are not square); the icon's are, so take that out.
    const float y_scale = mgRenderInfo.aspect[1][1] > 0.01f ? 1.0f / mgRenderInfo.aspect[1][1] : 1.0f;
    root.SetScale(scale, scale * y_scale, scale);
    float position[3] = {-mid[0] * scale, -mid[1] * scale * y_scale, -mid[2] * scale};
    root.SetPosition(position[0], position[1], position[2]);
    if (IsFootwear(item_record->type)) {
        // The pair is seen from the side, one behind the other: a far clip between the two leaves the nearer one alone.
        float       depth[2] = {};
        int         found = 0;
        const char *feet[2] = {"R_foot", "L_foot"};
        for (int j = 0; j < 2; j++) {
            mgCFrame *bone = chara->SearchObject(const_cast<char *>(feet[j]));
            if (bone == nullptr) {
                continue;
            }
            float matrix[4][4], origin[4] = {0.0f, 0.0f, 0.0f, 1.0f}, world[4];
            bone->GetLWMatrix(matrix);
            sceVu0ApplyMatrix(world, matrix, origin);
            depth[j] = world[2];
            found++;
        }
        if (found == 2 && std::fabs(depth[0] - depth[1]) > 0.5f) {
            const float split = (depth[0] + depth[1]) * 0.5f;
            const float far_depth = distance - scale * (split - mid[2]);
            if (far_depth > saved_near + 1.0f) {
                mgSetRenderInfo(800.0f, saved_near, far_depth);
                mgSetViewMatrix(view, camera->pos);
            }
        }
    }

    mgSetPkClearScreen(0, 0, 0, 0);

    Textures().manager.ReloadTexture(kModelBlock, static_cast<sceVif1Packet *>(nullptr));
    const uint8_t none[4] = {};

    // The outline and shadow: the unlit (black) model drawn shifted about the picture, a pixel of the icon (4 of
    // the scratch's) each way and a little more down and right for the shadow, then the lit model on top.
    float dark_dir[4][4] = {};
    float dark_colour[4][4] = {};
    float dark[4] = {0.0f, 0.0f, 0.0f, 128.0f};
    mgSetLight(dark_dir, dark_colour);
    mgSetAmbient(dark);
    const float step = 4.0f / pixels_per_unit;
    const float shifts[9][2] = {
        {-1,     0     },
        {1,      0     },
        {0,      -1    },
        {0,      1     },
        {-0.75f, -0.75f},
        {0.75f,  -0.75f},
        {-0.75f, 0.75f },
        {0.75f,  0.75f },
        {1.4f,   -1.6f }
    };
    for (const auto &shift : shifts) {
        root.SetPosition(position[0] + shift[0] * step, position[1] + shift[1] * step, position[2]);
        mgDrawDirect(&root);
    }
    root.SetPosition(position[0], position[1], position[2]);
    gfx::Clear(false, none, true, 0.0f, nullptr);

    // A key light from the upper left, a weak fill from the other side, and an ambient that keeps the shade side a colour.
    {
        float key[3] = {-0.45f, 0.75f, 0.5f};
        float fill[3] = {0.6f, -0.2f, 0.4f};
        float key_length = std::sqrt(key[0] * key[0] + key[1] * key[1] + key[2] * key[2]);
        float fill_length = std::sqrt(fill[0] * fill[0] + fill[1] * fill[1] + fill[2] * fill[2]);
        float dir[4][4] = {};
        float colour[4][4] = {};
        for (int i = 0; i < 3; i++) {
            dir[i][0] = key[i] / key_length;
            dir[i][1] = fill[i] / fill_length;
        }
        const float key_strength = 120.0f;
        const float fill_strength = 36.0f;
        colour[0][0] = colour[0][1] = colour[0][2] = key_strength;
        colour[1][0] = colour[1][1] = colour[1][2] = fill_strength;
        float ambient[4] = {70.0f, 0.0f, 0.0f, 128.0f};
        ambient[1] = ambient[2] = ambient[0];
        mgSetLight(dir, colour);
        mgSetAmbient(ambient);
    }
    mgDrawDirect(&root);
    if (skinned && !IsFootwear(item_record->type)) {
        // An outfit's skin brings along feet, hair and the like beyond the part that is the icon: only the box of the jacket
        // or dress is kept, the rest of the picture wiped.
        const float            centre = static_cast<float>(kScratch) * 0.5f;
        const float            half_x = (box_hi[0] - box_lo[0]) * 0.5f * scale * pixels_per_unit + 6.0f;
        const float            half_y = (box_hi[1] - box_lo[1]) * 0.5f * scale * pixels_per_unit + 6.0f;
        const float            full = static_cast<float>(kScratch);
        const uint8_t         *colour = none;
        const gfx::LogicalRect bands[4] = {
            {0.0f,            0.0f,            full,          std::max(0.0f,           centre - half_y)       },
            {0.0f,            centre + half_y, full,          std::max(0.0f,           full - centre - half_y)},
            {0.0f,            0.0f,            std::max(0.0f, centre - half_x),        full                   },
            {centre + half_x, 0.0f,            std::max(0.0f, full - centre - half_x), full                   }
        };
        for (const auto &band : bands) {
            if (band.w > 0.0f && band.h > 0.0f) {
                gfx::Clear(true, colour, false, 0.0f, &band);
            }
        }
    }
    if (pair) {
        // What the arm on the right left over at the crop's edge is wiped, from the plane between them.
        const float            split = static_cast<float>(kScratch) * 0.5f + (box_hi[0] - mid[0]) * scale * pixels_per_unit;
        const gfx::LogicalRect right = {split, 0.0f, static_cast<float>(kScratch) - split, static_cast<float>(kScratch)};
        gfx::Clear(true, none, false, 0.0f, &right);
    }

    // The picture down to the icon in exact halves: kCrop -> kCrop/2 -> the icon.
    gfx::TextureHandle half = gfx::NamedRenderTarget("dc2 item icon 3d half", kCrop / 2, kCrop / 2, true);
    if (half != gfx::kNullTexture) {
        gfx::BlitTexture(scratch, {kScratch / 2 - kCrop / 2, kScratch / 2 - kCrop / 2, kCrop, kCrop}, half, {0, 0, kCrop / 2, kCrop / 2}, gfx::Filter::Linear);
        gfx::BlitTexture(half, {0, 0, kCrop / 2, kCrop / 2}, target, {0, 0, kIcon, kIcon}, gfx::Filter::Linear);
    } else {
        gfx::BlitTexture(scratch, {kScratch / 2 - kCrop / 2, kScratch / 2 - kCrop / 2, kCrop, kCrop}, target, {0, 0, kIcon, kIcon}, gfx::Filter::Linear);
    }
    mgSetPkFrameBuffer(-1, -1, -1, -1);

    return true;
}

} // namespace

bool ItemIcons3DEnabled() {
    return EnvOn("DC2_ITEM_ICONS_3D");
}

mgCTexture *ItemIcon3DTexture(int item_no) {
    if (item_no <= 0 || !ItemIcons3DEnabled() || !gfx::InFrame() || !mgPortRendererReady()) {
        return nullptr;
    }

    const int frame = mgPortFrameCount();
    if (g_icon_frame != frame) {
        g_icon_frame = frame;
        while (g_icons.size() >= kCachedIcons) {
            const auto oldest = std::min_element(g_icons.begin(), g_icons.end(), [](const auto &a, const auto &b) {
                return a.second.used < b.second.used;
            });
            if (oldest->second.used == static_cast<unsigned long long>(frame)) {
                break;
            }
            if (oldest->second.texture) {
                Textures().manager.DeleteTexture(oldest->second.texture);
            }
            g_icons.erase(oldest);
        }
    }
    Icon &icon = g_icons[item_no];
    icon.used = static_cast<unsigned long long>(frame);
    if (icon.texture != nullptr) {
        return icon.texture;
    }
    if (icon.failed) {
        return nullptr;
    }
    char name[32];
    std::snprintf(name, sizeof name, "item3d%d_%d", item_no, g_serial++);
    mgCTexture *texture = Textures().manager.EnterTexture(kIconBlock, name, nullptr, kIcon, kIcon, 32, nullptr, 0, 0);
    if (texture == nullptr) {
        icon.failed = true;
        return nullptr;
    }
    texture->tex0.bits.tcc = 1;
    if (!Render(item_no, texture)) {
        Textures().manager.DeleteTexture(texture);
        icon.failed = true;
        return nullptr;
    }
    icon.texture = texture;
    return texture;
}

void ItemIcons3DReset() {
    g_icons.clear();
    g_icon_frame = -1;
    g_serial = 0;
    if (g_textures_ready) {
        Textures().manager.Initialize(0, -1);
        Textures().scratch = nullptr;
    }
}
