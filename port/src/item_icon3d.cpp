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
#include "dataread.hpp"
#include "gamedata.hpp"
#include "gfx/gfx.hpp"
#include "item_icon3d.hpp"
#include "menumain.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_visual.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "userdata.hpp"

void MenuWorldTrans(); // menumain.cpp

namespace {

constexpr int kIcon = 32;
constexpr int kScratch = 512;       // the scratch picture's side; the projection's aspect is made for a screen 512 wide
constexpr int kCrop = 128;           // scratch pixels turned into one icon (4x4 each)
constexpr float kFill = 120.0f;      // pixels across the model inside the crop
constexpr int kModelBlock = 0xD1;    // a texture block nothing else loads into
constexpr int kIconBlock = 0xD2;     // holds every icon's texture
constexpr int kWorkQuadwords = 0x100000; // 16 MiB of model, motion and image data per draw

bool EnvOn(const char *name) {
    const char *value = std::getenv(name);
    return value != nullptr && value[0] != 0 && value[0] != '0';
}

float EnvFloat(const char *name, float fallback) {
    const char *text = std::getenv(name);
    return text != nullptr ? static_cast<float>(std::atof(text)) : fallback;
}

bool Debug() {
    static const bool on = EnvOn("DC2_ITEM_ICONS_3D_DEBUG");
    return on;
}

struct Icon {
    mgCTexture *texture = nullptr;
    bool        failed = false;
};

std::map<int, Icon> g_icons;
int                 g_serial = 0;

constexpr int       kSheetColumns = 10, kSheetRows = 8, kSheetCell = 128;
std::vector<int>    g_sheet_items;
std::vector<std::string> g_sheet_labels;
int                g_only_index = -1;   // debug: draw only the nth model part of the item
std::string        g_part_name;
bool               g_force_pose = false;     // debug: draw in the pose in g_forced, searching for none
float              g_forced[3] = {0, 0, 0};
bool               g_box_from_bound = false; // a skin's vertices are in the bones' space, so its stored bound is used
gfx::TextureHandle  g_sheet = gfx::kNullTexture;
const char         *SheetPath() {
    const char *path = std::getenv("DC2_ITEM_ICONS_3D_SHEET");
    return path != nullptr && path[0] != 0 ? path : nullptr;
}


// Clothes and shoes are skins laid over the character's own model, not models of their own.
bool IsSkinItem(int item_type) {
    return item_type == ITEM_DATA_MAX_CLOTHES || item_type == ITEM_DATA_MONICA_CLOTHES || item_type == ITEM_DATA_MAX_SHOES ||
           item_type == ITEM_DATA_MONICA_BOOTS;
}

bool IsFootwear(int item_type) {
    return item_type == ITEM_DATA_MAX_SHOES || item_type == ITEM_DATA_MONICA_BOOTS;
}

std::vector<unsigned char> &SkinStorage() {
    static std::vector<unsigned char> storage(static_cast<std::size_t>(kWorkQuadwords) * 16 + 128);
    return storage;
}

// The model's file, or false where the item has none that is a thing of its own (a costume is a whole character).
bool ModelPath(int item_no, char *path, std::size_t size) {
    CDataCommon *record = GameItemDataManage.GetCommonData(item_no);
    if (record == nullptr || record->file_name == nullptr || record->file_name[0] == 0) {
        return false;
    }
    const int type = ConvertUsedItemType(record->type);
    // A hat or a hair accessory is a model of its own (the game hangs it on the character's head); clothes and shoes are
    // skins on the character and are drawn another way.
    if (type == USED_ITEM_TYPE_COSTUME && record->type != ITEM_DATA_MAX_HAT && record->type != ITEM_DATA_MONICA_ACCESSORY) {
        if (!IsSkinItem(record->type) || EnvOn("DC2_ITEM_ICONS_3D_NO_SKINS")) {
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

std::vector<unsigned char> &WorkStorage() {
    static std::vector<unsigned char> storage(static_cast<std::size_t>(kWorkQuadwords) * 16 + 128);
    return storage;
}

mgCCamera *IconCamera() {
    static mgCCamera camera(1.0f);
    return &camera;
}

// The box of what is drawn: the frames the draw flags show (a frame the parent skips, such as a light's cone, is not drawn
// and is often far larger than the model), each corner taken to world space.
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
            const bool          vertices = mdt != nullptr && mdt->vertex != nullptr && mdt->vertex_num > 0 && !g_box_from_bound && !EnvOn("DC2_ITEM_ICONS_3D_BOUND_BOX");
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

// model_block takes the model's pictures while it is drawn; scratch_block holds the scratch picture. The menu's blocks
// are past the dungeon's texture table, so the dungeon's quick loadout passes blocks of its own. icon_size is the side
// of the icon texture: the menu's 32, halved down from the crop, or the crop itself scaled straight into a larger one.
// into, when given, is the target drawn to in place of icon's.
bool Render(int item_no, mgCTexture *icon, int model_block = kModelBlock, int scratch_block = kIconBlock, int icon_size = kIcon,
            gfx::TextureHandle into = gfx::kNullTexture) {
    char path[0x80];
    if (!ModelPath(item_no, path, sizeof path)) {
        if (Debug()) {
            std::fprintf(stderr, "dc2 item icon 3d: item %d has no model\n", item_no);
        }
        return false;
    }

    // Retail's own pattern for loading an item model into a stack of its own (the developer item viewer).
    static mgCMemory stack;
    auto *base = reinterpret_cast<u_long128 *>((reinterpret_cast<std::uintptr_t>(WorkStorage().data()) + 63) & ~std::uintptr_t{63});
    stack.stSetBuffer(base, kWorkQuadwords);
    stack.stack_used = 0;
    stack.lock = 0;
    u_long128 *buffer = stack.stGetTop();
    int        file_size = 0;
    CDataCommon *item_record = GameItemDataManage.GetCommonData(item_no);
    const bool   skinned = item_record != nullptr && IsSkinItem(item_record->type);
    char         skin_path[0x80] = {};
    if (skinned) {
        // The character's own model is what the skin is laid on; the item's file is the skin.
        std::snprintf(skin_path, sizeof skin_path, "%s", path);
        if (EnvOn("DC2_ITEM_ICONS_3D_COSTUME_T")) {
            char *dot = std::strrchr(skin_path, '.');
            if (dot != nullptr && static_cast<size_t>(dot - skin_path) + 6 < sizeof skin_path) {
                std::memmove(dot + 1, dot, std::strlen(dot) + 1);
                *dot = 't';
            }
        }
        char model_name[32] = {};
        const bool max = item_record->type == ITEM_DATA_MAX_CLOTHES || item_record->type == ITEM_DATA_MAX_SHOES;
        GetMainCharaModelName(max ? USER_CHARA_MAX : USER_CHARA_MONICA, model_name, 0);
        std::snprintf(path, sizeof path, "mainchr/%s", model_name);
    }
    if (!LoadFile2(path, buffer, &file_size, LOAD_FILE_READ) || file_size <= 0) {
        // A weapon without an item-view model falls back to the one it is held by.
        char *plain = GetItemFilePath(item_no, 0);
        if (plain == nullptr || !LoadFile2(plain, buffer, &file_size, LOAD_FILE_READ) || file_size <= 0) {
            if (Debug()) {
                std::fprintf(stderr, "dc2 item icon 3d: item %d: no file %s\n", item_no, path);
            }
            return false;
        }
        std::snprintf(path, sizeof path, "%s", plain);
    }
    stack.Alloc(file_size / 16 + 1);
    stack.Align64();

    mgTexManager.DeleteBlock(model_block);
    auto *chara = new (stack.Alloc((sizeof(CActionChara) + 15) / 16 + 2)) CActionChara;
    chara->Initialize(nullptr);
    char cfg[] = "info.cfg";
    // The item menu enters the model's pictures under a suffix of their own.
    std::strcpy(mgTexManager.name_suffix, "_menu");
    chara->LoadPack(reinterpret_cast<u_int *>(buffer), cfg, &stack, &stack, &stack, model_block, nullptr);
    mgTexManager.name_suffix[0] = 0;
    if (skinned) {
        auto *skin_base = reinterpret_cast<u_long128 *>((reinterpret_cast<std::uintptr_t>(SkinStorage().data()) + 63) & ~std::uintptr_t{63});
        int   skin_size = 0;
        if (LoadFile2(skin_path, skin_base, &skin_size, LOAD_FILE_READ) && skin_size > 0) {
            char empty[] = "";
            if (Debug()) {
                int   cfg_size = 0;
                char *cfg_text = reinterpret_cast<char *>(GetPackFile(reinterpret_cast<u_int *>(skin_base), cfg, &cfg_size));
                if (cfg_text != nullptr) {
                    std::fprintf(stderr, "dc2 item icon 3d: item %d skin cfg (%d bytes):\n%.*s\n=====\n", item_no, cfg_size, cfg_size > 6000 ? 6000 : cfg_size, cfg_text);
                }
            }
            if (!EnvOn("DC2_ITEM_ICONS_3D_KEEP_TEXANIME")) {
                mgTexManager.DeleteTexAnime(model_block); // as the menu's own preview does before a skin
            }
            // The skin's pictures keep the names every outfit of the character shares, which the town's own Max (and the
            // pictures already in the block) answer to first; a suffix of their own keeps them to this model.
            if (!EnvOn("DC2_ITEM_ICONS_3D_NO_SKIN_SUFFIX")) {
                std::strcpy(mgTexManager.name_suffix, EnvOn("DC2_ITEM_ICONS_3D_SKIN_MENU") ? "_menu" : "_skin");
            }
            chara->LoadSkin(reinterpret_cast<unsigned int *>(skin_base), cfg, empty, &stack, model_block);
            mgTexManager.name_suffix[0] = 0;
            if (EnvOn("DC2_ITEM_ICONS_3D_DUMP_TEX") && SheetPath() != nullptr) {
                // Debug: the pictures the model block holds after the skin is in, as the game's own.
                mgCTextureBlock *block = mgTexManager.GetTextureBlock(model_block);
                int              n = 0;
                for (mgCTexture *tex = block != nullptr ? block->texture : nullptr; tex != nullptr && n < 40; tex = tex->next, n++) {
                    if (tex->image[0] == nullptr || tex->width <= 0 || tex->height <= 0) {
                        continue;
                    }
                    char file[512];
                    std::snprintf(file, sizeof file, "%s.tex_%d_%02d_%s.png", SheetPath(), item_no, n, tex->name);
                    gfx::WritePng(file, reinterpret_cast<const uint8_t *>(tex->image[0]), static_cast<uint32_t>(tex->width), static_cast<uint32_t>(tex->height));
                }
            }
        } else if (Debug()) {
            std::fprintf(stderr, "dc2 item icon 3d: item %d: no skin %s\n", item_no, skin_path);
        }
    }
    mgCFrame *frame = chara->CObjectFrame::frame;
    if (frame == nullptr) {
        if (Debug()) {
            std::fprintf(stderr, "dc2 item icon 3d: item %d %s: no frame\n", item_no, path);
        }
        mgTexManager.DeleteBlock(model_block);
        return false;
    }
    g_part_name.clear();
    g_box_from_bound = skinned;
    if (skinned && g_only_index < 0 && !EnvOn("DC2_ITEM_ICONS_3D_NO_HIDE")) {
        // Only the item's own parts of the character are drawn: the jacket or dress, the shoes or boots. The rest of the
        // character (and the stand-in triangles the skin leaves in the other slots) stays hidden.
        const char *keep[3] = {nullptr, nullptr, nullptr};
        switch (item_record->type) {
            case ITEM_DATA_MAX_CLOTHES:
                keep[0] = "skin1"; // the jacket and arms; the legs and feet are left out so it can be drawn larger
                keep[1] = EnvOn("DC2_ITEM_ICONS_3D_NO_SKIN2") ? nullptr : "skin2";
                break;
            case ITEM_DATA_MONICA_CLOTHES:
                keep[0] = "skin1";
                keep[1] = EnvOn("DC2_ITEM_ICONS_3D_NO_SKIN2") ? nullptr : "skin2";
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
                        if (!EnvOn("DC2_ITEM_ICONS_3D_KEEP_SKIP")) { // the second layer (overalls, trousers) is drawn by the game itself, here it has to be asked for
                            node->attr->draw &= ~MG_FRAME_DRAW_SKIP_BY_PARENT;
                        }
                    }
                }
                hide(node->child);
            }
        };
        hide(frame);
    }
    if (g_only_index >= 0) {
        int                                 index = 0;
        std::function<void(mgCFrame *)>     walk = [&](mgCFrame *node) {
            for (; node != nullptr; node = node->brother) {
                if (node->visual != nullptr && node->attr != nullptr) {
                    if (index == g_only_index) {
                        g_part_name = node->name != nullptr ? node->name : "?";
                        node->attr->draw |= MG_FRAME_DRAW_VISIBLE;
                    } else {
                        node->attr->draw &= ~MG_FRAME_DRAW_VISIBLE;
                    }
                    index++;
                }
                walk(node->child);
            }
        };
        walk(frame);
        if (g_part_name.empty()) {
            mgTexManager.DeleteBlock(model_block);
            return false;
        }
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
    root.SetScale(1.0f, 1.0f, 1.0f);
    root.SetPosition(0.0f, 0.0f, 0.0f);
    chara->SetPosition(0.0f, 0.0f, 0.0f);
    chara->SetScale(1.0f, 1.0f, 1.0f);

    float pose[3] = {0.0f, 0.0f, 0.0f};
    if (record->type == ITEM_DATA_MAX_HAT) {
        // A hat is modelled to be worn, so it is tipped back to be seen from the front and a little above, not from above.
        pose[0] = EnvFloat("DC2_ITEM_ICONS_3D_HAT_PITCH", 3.1416f); // upside down as made: the crown up
    }
    float tip = (weapon || IsFootwear(record->type)) ? 0.0f : EnvFloat("DC2_ITEM_ICONS_3D_TIP", 0.35f);
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
            float neck[3] = {}, spine[3] = {}, right[3] = {}, left[3] = {};
            bool  have[4] = {false, false, false, false};
            float *targets[4] = {neck, spine, right, left};
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
                if (Debug()) {
                    static int logged = -1;
                    if (logged != item_no) {
                        logged = item_no;
                        std::fprintf(stderr, "dc2 item icon 3d: item %d torso neck %.1f,%.1f,%.1f spine %.1f,%.1f,%.1f R %.1f,%.1f,%.1f L %.1f,%.1f,%.1f\n", item_no, neck[0], neck[1], neck[2],
                                     spine[0], spine[1], spine[2], right[0], right[1], right[2], left[0], left[1], left[2]);
                    }
                }
                const float centre_x = (right[0] + left[0]) * 0.5f;
                // The shoulder joints sit at the neck, so the width comes from the chest's height.
                (void) shoulders;
                const float half_w = rise * EnvFloat("DC2_ITEM_ICONS_3D_TORSO_WIDTH", 1.15f);
                box_lo[0] = centre_x - half_w;
                box_hi[0] = centre_x + half_w;
                box_lo[1] = std::min(neck[1], spine[1]) - EnvFloat("DC2_ITEM_ICONS_3D_TORSO_BELOW", 0.2f) * rise;
                box_hi[1] = std::max(neck[1], spine[1]) + EnvFloat("DC2_ITEM_ICONS_3D_TORSO_ABOVE", -0.03f) * rise;
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
        pose[1] = EnvFloat("DC2_ITEM_ICONS_3D_HAT_YAW", -1.3f);
        measure();
    } else if (record->type == ITEM_DATA_ROBO_ARM || IsFootwear(record->type)) {
        // The pair lies side by side across the model, so it is shown square on, or the left half would not be an arm.
        // Footwear is seen from the side, which also puts one of the pair behind the other.
        pose[1] = IsFootwear(record->type) ? EnvFloat("DC2_ITEM_ICONS_3D_FOOT_YAW", 1.5708f) : 0.0f;
        measure();
    } else if (!EnvOn("DC2_ITEM_ICONS_3D_NO_TURN_SEARCH")) {
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
        pose[1] = best_yaw + EnvFloat("DC2_ITEM_ICONS_3D_ITEM_TURN", -0.2618f);
        measure();
    }
    // A robo arm's model is the pair side by side; the icon is the one on the left, the right left outside the picture.
    if (g_force_pose) {
        std::memcpy(pose, g_forced, sizeof pose);
        measure();
    }
    // A robo arm's model is the pair side by side; the icon is the one on the left.
    const bool pair = record->type == ITEM_DATA_ROBO_ARM;
    if (pair) {
        box_hi[0] = (box_lo[0] + box_hi[0]) * 0.5f;
    }
    // Turned in the picture plane to the angle that takes the least room (a long thin model fits best along the diagonal),
    // so it can be drawn larger. The first of equals is the one turned the least, so upright models stay upright.
    if (!pair && !skinned && !g_force_pose) {
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
    if (Debug()) {
        std::fprintf(stderr, "dc2 item icon 3d: item %d %s pose %.2f %.2f %.2f roll %.2f box %.2f x %.2f\n", item_no, path,
                     pose[0], pose[1], pose[2], roll_angle, box_hi[0] - box_lo[0], box_hi[1] - box_lo[1]);
    }
    static unsigned dumped_types = 0;
    const unsigned   type_mask = static_cast<unsigned>(EnvFloat("DC2_ITEM_ICONS_3D_TREE_TYPES", 0.0f));
    const bool       dump_type = record->type < 32 && (type_mask & (1u << record->type)) && !(dumped_types & (1u << record->type));
    if (dump_type) {
        dumped_types |= 1u << record->type;
        std::fprintf(stderr, "  tree for item %d type %d\n", item_no, record->type);
    }
    if (dump_type || item_no == static_cast<int>(EnvFloat("DC2_ITEM_ICONS_3D_TREE", -1.0f))) {
        std::function<void(mgCFrame *, int)> dump = [&](mgCFrame *node, int depth) {
            for (; node != nullptr; node = node->brother) {
                float lo[4] = {}, hi[4] = {};
                if (node->visual != nullptr && node->bound != nullptr) {
                    for (int i = 0; i < 4; i++) {
                        hi[i] = node->bound->max[i];
                        lo[i] = node->bound->min[i];
                    }
                }
                int verts = -1, mats = -1;
                if (node->visual != nullptr) {
                    if (const auto *mdt = dynamic_cast<const mgCVisualMDT *>(node->visual)) {
                        verts = mdt->vertex_num;
                        mats = mdt->material_num;
                    }
                }
                std::fprintf(stderr, "  tree v=%d m=%d %*s%s draw=%d visual=%d bound %.1f,%.1f,%.1f .. %.1f,%.1f,%.1f\n", verts, mats, depth * 2, "",
                             node->name != nullptr ? node->name : "?", node->attr != nullptr ? node->attr->draw : -1, node->visual != nullptr,
                             lo[0], lo[1], lo[2], hi[0], hi[1], hi[2]);
                dump(node->child, depth + 1);
            }
        };
        dump(frame, 0);
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
    // Looked up each time: a mode change starts the texture table again and takes the block's pictures with it.
    static char scratch_name[] = "dc2 item icon 3d scratch";
    mgCTexture *scratch_texture = mgTexManager.GetTexture(scratch_name, scratch_block);
    if (scratch_texture == nullptr) {
        scratch_texture = mgTexManager.EnterTexture(scratch_block, scratch_name, nullptr, kScratch, kScratch, 32, nullptr, 0, 0);
    }
    gfx::TextureHandle target = into != gfx::kNullTexture ? into : mgPortRenderTarget(icon, true);
    if (scratch_texture == nullptr || target == gfx::kNullTexture) {
        mgTexManager.DeleteBlock(model_block);
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

    const float saved_projection = mgGetProjection();
    float       saved_ambient[4];
    float       saved_dir[4][4], saved_colour[4][4];
    mgGetAmbient(saved_ambient);
    mgGetLight(saved_dir, saved_colour);

    mgSetPkFrameBuffer(scratch_texture);
    gfx::TextureHandle scratch = mgPortCurrentTarget();
    mgSetProjection(800.0f);
    mgSetViewMatrix(view, camera->pos);
    const float saved_near = mgRenderInfo.clip_min[2], saved_far = mgRenderInfo.clip_max[2];
    bool        far_cut = false;

    const float pixels_per_unit = 800.0f / distance;
    const float scale = (kFill * 0.5f) / (pixels_per_unit * radius);
    // The projection stretches y (the screen's pixels are not square); the icon's are, so take that out.
    const float y_scale = mgRenderInfo.aspect[1][1] > 0.01f ? 1.0f / mgRenderInfo.aspect[1][1] : 1.0f;
    root.SetScale(scale, scale * y_scale, scale);
    float position[3] = {-mid[0] * scale, -mid[1] * scale * y_scale, -mid[2] * scale};
    root.SetPosition(position[0], position[1], position[2]);
    if (IsFootwear(item_record->type) && !EnvOn("DC2_ITEM_ICONS_3D_NO_FAR_CUT")) {
        // The pair is seen from the side, one behind the other: a far clip between the two leaves the nearer one alone.
        float depth[2] = {};
        int   found = 0;
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
            const float split = (depth[0] + depth[1]) * 0.5f + EnvFloat("DC2_ITEM_ICONS_3D_FAR_BIAS", 0.0f);
            const float far_depth = distance - scale * (split - mid[2]);
            if (far_depth > saved_near + 1.0f) {
                mgSetRenderInfo(800.0f, saved_near, far_depth);
                mgSetViewMatrix(view, camera->pos);
                far_cut = true;
            }
        }
    }
    if (EnvOn("DC2_ITEM_ICONS_3D_RED")) {
        mgSetPkClearScreen(0x80, 0, 0, 0x80);
    } else {
        mgSetPkClearScreen(0, 0, 0, 0);
    }
    mgTexManager.ReloadTexture(model_block, static_cast<sceVif1Packet *>(nullptr));
    const uint8_t none[4] = {};
    if (!EnvOn("DC2_ITEM_ICONS_3D_NO_OUTLINE")) {
        // The outline and shadow: the unlit (black) model drawn shifted about the picture, a pixel of the icon (4 of
        // the scratch's) each way and a little more down and right for the shadow, then the lit model on top.
        float dark_dir[4][4] = {};
        float dark_colour[4][4] = {};
        float dark[4] = {0.0f, 0.0f, 0.0f, 128.0f};
        mgSetLight(dark_dir, dark_colour);
        mgSetAmbient(dark);
        // A larger icon shows the scratch near its own size, so its outline is thinner in scratch pixels.
        const float step = (icon_size == kIcon ? 4.0f : 1.5f) / pixels_per_unit;
        const float shifts[9][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-0.75f, -0.75f}, {0.75f, -0.75f},
                                    {-0.75f, 0.75f}, {0.75f, 0.75f}, {1.4f, -1.6f}};
        for (const auto &shift : shifts) {
            root.SetPosition(position[0] + shift[0] * step, position[1] + shift[1] * step, position[2]);
            mgDrawDirect(&root);
        }
        root.SetPosition(position[0], position[1], position[2]);
        gfx::Clear(false, none, true, 0.0f, nullptr);
    }
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
        const float key_strength = EnvFloat("DC2_ITEM_ICONS_3D_KEY", 120.0f);
        const float fill_strength = EnvFloat("DC2_ITEM_ICONS_3D_FILL_LIGHT", 36.0f);
        colour[0][0] = colour[0][1] = colour[0][2] = key_strength;
        colour[1][0] = colour[1][1] = colour[1][2] = fill_strength;
        float ambient[4] = {EnvFloat("DC2_ITEM_ICONS_3D_AMBIENT", 70.0f), 0.0f, 0.0f, 128.0f};
        ambient[1] = ambient[2] = ambient[0];
        mgSetLight(dir, colour);
        mgSetAmbient(ambient);
    }
    mgDrawDirect(&root);
    if (skinned && !IsFootwear(item_record->type)) {
        // An outfit's skin brings along feet, hair and the like beyond the part that is the icon: only the box of the jacket
        // or dress is kept, the rest of the picture wiped.
        const float centre = static_cast<float>(kScratch) * 0.5f;
        const float half_x = (box_hi[0] - box_lo[0]) * 0.5f * scale * pixels_per_unit + 6.0f;
        const float half_y = (box_hi[1] - box_lo[1]) * 0.5f * scale * pixels_per_unit + 6.0f;
        const float full = static_cast<float>(kScratch);
        const uint8_t wipe[4] = {0, 0x80, 0, 0x80};
        const uint8_t *colour = EnvOn("DC2_ITEM_ICONS_3D_RED") ? wipe : none;
        const gfx::LogicalRect bands[4] = {{0.0f, 0.0f, full, std::max(0.0f, centre - half_y)},
                                           {0.0f, centre + half_y, full, std::max(0.0f, full - centre - half_y)},
                                           {0.0f, 0.0f, std::max(0.0f, centre - half_x), full},
                                           {centre + half_x, 0.0f, std::max(0.0f, full - centre - half_x), full}};
        for (const auto &band : bands) {
            if (band.w > 0.0f && band.h > 0.0f) {
                gfx::Clear(true, colour, false, 0.0f, &band);
            }
        }
    }
    if (pair) {
        // What the arm on the right left over at the crop's edge is wiped, from the plane between them.
        const float split = static_cast<float>(kScratch) * 0.5f + (box_hi[0] - mid[0]) * scale * pixels_per_unit;
        const gfx::LogicalRect right = {split, 0.0f, static_cast<float>(kScratch) - split, static_cast<float>(kScratch)};
        const uint8_t wipe[4] = {0, 0x80, 0, 0x80};
        gfx::Clear(true, EnvOn("DC2_ITEM_ICONS_3D_RED") ? wipe : none, false, 0.0f, &right);
    }

    // The picture down to the icon in exact halves: kCrop -> kCrop/2 -> the icon.
    gfx::TextureHandle half = icon_size == kIcon ? gfx::NamedRenderTarget("dc2 item icon 3d half", kCrop / 2, kCrop / 2, true) : gfx::kNullTexture;
    if (icon_size != kIcon) {
        gfx::BlitTexture(scratch, {kScratch / 2 - kCrop / 2, kScratch / 2 - kCrop / 2, kCrop, kCrop}, target, {0, 0, icon_size, icon_size}, gfx::Filter::Linear);
    } else if (half != gfx::kNullTexture) {
        gfx::BlitTexture(scratch, {kScratch / 2 - kCrop / 2, kScratch / 2 - kCrop / 2, kCrop, kCrop}, half, {0, 0, kCrop / 2, kCrop / 2}, gfx::Filter::Linear);
        gfx::BlitTexture(half, {0, 0, kCrop / 2, kCrop / 2}, target, {0, 0, kIcon, kIcon}, gfx::Filter::Linear);
    } else {
        gfx::BlitTexture(scratch, {kScratch / 2 - kCrop / 2, kScratch / 2 - kCrop / 2, kCrop, kCrop}, target, {0, 0, kIcon, kIcon}, gfx::Filter::Linear);
    }
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    if (SheetPath() != nullptr && static_cast<int>(g_sheet_items.size()) < kSheetColumns * kSheetRows) {
        if (g_sheet == gfx::kNullTexture) {
            g_sheet = gfx::NamedRenderTarget("dc2 item icon 3d sheet", kSheetColumns * kSheetCell, kSheetRows * kSheetCell, true);
        }
        if (g_sheet != gfx::kNullTexture) {
            const int cell = static_cast<int>(g_sheet_items.size());
            gfx::BlitTexture(scratch, {kScratch / 2 - kCrop / 2, kScratch / 2 - kCrop / 2, kCrop, kCrop}, g_sheet,
                             {(cell % kSheetColumns) * kSheetCell, (cell / kSheetColumns) * kSheetCell, kSheetCell, kSheetCell},
                             gfx::Filter::Linear);
            g_sheet_items.push_back(item_no);
            g_sheet_labels.push_back(g_part_name);
        }
    }

    if (far_cut) {
        mgSetRenderInfo(800.0f, saved_near, saved_far);
    }
    mgSetProjection(saved_projection);
    mgSetAmbient(saved_ambient);
    mgSetLight(saved_dir, saved_colour);
    if (MenuDrawEnv != nullptr) {
        MenuWorldTrans(); // puts the menu camera's view back
    }
    elev.child = nullptr;
    frame->parent = nullptr;
    mgTexManager.DeleteBlock(model_block);
    return true;
}

} // namespace

bool ItemIcons3DEnabled() {
    static const bool on = EnvOn("DC2_ITEM_ICONS_3D");
    return on;
}

mgCTexture *ItemIcon3DTexture(int item_no) {
    if (item_no <= 0 || !ItemIcons3DEnabled() || !gfx::InFrame() || !mgPortRendererReady()) {
        return nullptr;
    }
    static bool all_started = false;
    if (SheetPath() != nullptr && !all_started) {
        all_started = true;
        const int first = static_cast<int>(EnvFloat("DC2_ITEM_ICONS_3D_SHEET_FIRST", 1.0f));
        const int poses_item = static_cast<int>(EnvFloat("DC2_ITEM_ICONS_3D_POSES_ITEM", -1.0f));
        if (poses_item > 0) {
            // Debug: one item in each of the 64 axis-aligned turns, to find which way up it is made.
            mgCTexture *pose_icon = mgTexManager.EnterTexture(kIconBlock, "item3d poses", nullptr, kIcon, kIcon, 32, nullptr, 0, 0);
            for (int n = 0; n < 64 && pose_icon != nullptr; n++) {
                g_force_pose = true;
                g_forced[0] = (n / 16) * 1.5707964f;
                g_forced[1] = ((n / 4) % 4) * 1.5707964f;
                g_forced[2] = (n % 4) * 1.5707964f;
                Render(poses_item, pose_icon);
            }
            g_force_pose = false;
        }
        const int parts_item = static_cast<int>(EnvFloat("DC2_ITEM_ICONS_3D_PARTS_ITEM", -1.0f));
        if (parts_item > 0) {
            // Debug: each model part of one item drawn alone, to learn which is which.
            mgCTexture *scratch_icon = mgTexManager.EnterTexture(kIconBlock, "item3d parts", nullptr, kIcon, kIcon, 32, nullptr, 0, 0);
            for (int part = 0; part < kSheetColumns * kSheetRows && scratch_icon != nullptr; part++) {
                g_only_index = part;
                Render(parts_item, scratch_icon);
            }
            g_only_index = -1;
        }
        for (int id = first; id < first + 400 && static_cast<int>(g_sheet_items.size()) < kSheetColumns * kSheetRows; id++) {
            ItemIcon3DTexture(id);
        }
    }
    Icon &icon = g_icons[item_no];
    if (icon.texture != nullptr) {
        return icon.texture;
    }
    if (icon.failed) {
        return nullptr;
    }
    char name[32];
    std::snprintf(name, sizeof name, "item3d%d_%d", item_no, g_serial++);
    mgCTexture *texture = mgTexManager.EnterTexture(kIconBlock, name, nullptr, kIcon, kIcon, 32, nullptr, 0, 0);
    if (texture == nullptr) {
        icon.failed = true;
        return nullptr;
    }
    texture->tex0.bits.tcc = 1;
    if (!Render(item_no, texture)) {
        icon.failed = true;
        return nullptr;
    }
    icon.texture = texture;
    return texture;
}

bool ItemIcon3DRenderTo(int item_no, gfx::TextureHandle target, int size, int model_block, int scratch_block) {
    if (item_no <= 0 || size <= 0 || target == gfx::kNullTexture || !gfx::InFrame() || !mgPortRendererReady()) {
        return false;
    }
    // The caller's camera, projection and lights are as they were before; MenuWorldTrans is only the menu's.
    mgRENDER_INFO saved = mgRenderInfo;
    const bool    drawn = Render(item_no, nullptr, model_block, scratch_block, size, target);
    mgRenderInfo = saved;
    return drawn;
}

void ItemIcons3DDumpSheet() {
    const char *path = SheetPath();
    if (path == nullptr || g_sheet == gfx::kNullTexture) {
        return;
    }
    std::vector<uint8_t> rgba;
    uint32_t             width = 0, height = 0;
    if (gfx::ReadbackTexture(g_sheet, rgba, width, height)) {
        gfx::WritePng(path, rgba.data(), width, height);
    }
    if (MenuPosData != nullptr) {
        // The 2D icon sheets as they are, for comparing against.
        for (int sheet = 0; sheet < 2; sheet++) {
            mgCTexture *atlas = MenuPosData->item_icon_tex[0][sheet];
            if (atlas != nullptr && atlas->image[0] != nullptr) {
                gfx::WritePng((std::string(path) + ".atlas" + std::to_string(sheet) + ".png").c_str(), reinterpret_cast<const uint8_t *>(atlas->image[0]),
                              static_cast<uint32_t>(atlas->width), static_cast<uint32_t>(atlas->height));
            }
        }
    }
    std::string list = std::string(path) + ".txt";
    if (FILE *file = std::fopen(list.c_str(), "w")) {
        for (std::size_t i = 0; i < g_sheet_items.size(); i++) {
            CDataCommon *record = GameItemDataManage.GetCommonData(g_sheet_items[i]);
            std::fprintf(file, "%zu item %d %s %s icon %d %d\n", i, g_sheet_items[i], record != nullptr && record->file_name != nullptr ? record->file_name : "",
                         i < g_sheet_labels.size() ? g_sheet_labels[i].c_str() : "-", record != nullptr ? record->icon_texture_no : -1,
                         record != nullptr ? record->icon_no : -1);
        }
        std::fclose(file);
    }
}
