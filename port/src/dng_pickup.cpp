#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <numbers>
#include <unordered_map>

#include "dng_effect.hpp"
#include "dng_main.hpp"
#include "dng_object.hpp"
#include "gfx/gfx.hpp"
#include "mglib.hpp"
#include "object/dun/pickup_presentation.hpp"
#include "prespr.hpp"

namespace {
std::unordered_map<const void *, uint64_t> generations;
uint64_t                                   next_generation = 0;
// Retail advances one shared glow phase for every active pickup draw, even coins.
float glow_phase = 0.0f;
} // namespace

void mgPortEmitPickup(const void *pickup) { generations[pickup] = ++next_generation; }

mgPortPickupScope::mgPortPickupScope(const void *pickup) {
    const auto previous = gfx::CurrentInterp2D();
    key_ = previous.key;
    generation_ = previous.generation;
    world_corners_ = previous.world_corners;
    teleport_distance_ = previous.teleport_distance;
    const auto found = generations.find(pickup);
    if (found == generations.end()) {
        gfx::SetInterp2D({});
    } else {
        gfx::SetInterp2D({.key = static_cast<gfx::InterpKey>(reinterpret_cast<uintptr_t>(pickup)), .generation = found->second, .world_corners = true, .teleport_distance = 200.0f});
    }
}

mgPortPickupScope::~mgPortPickupScope() {
    gfx::SetInterp2D({.key = static_cast<gfx::InterpKey>(key_), .generation = generation_, .world_corners = world_corners_, .teleport_distance = teleport_distance_});
}

void CPullItem::Draw(mgCTexture *texture) {
    if (state == PULL_ITEM_STATE_FREE) {
        return;
    }
    mgPortPickupScope interpolation(this);
    CPreSprite        sprite;
    sprite.Initialize(nullptr, nullptr);
    sprite.AlphaBlend(glow ? MG_ALPHA_BLEND_ADD : MG_ALPHA_BLEND_NORMAL);
    sprite.AlphaBlendEnable(1);
    sprite.AlphaTestEnable(1);
    sprite.AlphaTest(1, 0);
    sprite.DepthTestEnable(1);
    sprite.ZMask(MG_Z_MASK_MASKED);
    sprite.Bilinear(1);
    sprite.TextureMapEnable(1);
    sprite.Coord(1);
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Texture(texture);
    sprite.AlphaTestEnable(1);
    sprite.Color(0x80, 0x80, 0x80, fptosi(alpha));

    pos[3] = 1.0f;
    const int draw_u = tex_u + (anim_frame / 4) * 16;
    float     center[4];
    sceVu0CopyVector(center, pos);
    center[1] += height / 2.0f;
    center[1] += bob_height * sinf(angle);
    if (glow_phase > std::numbers::pi_v<float>) {
        glow_phase = 0.0f;
    } else {
        glow_phase += std::numbers::pi_v<float> / 15.0f;
    }
    const float shadow_width = width + width * sinf(glow_phase);
    const float shadow_height = height + height * sinf(glow_phase);
    sceVu0CopyVector(draw_pos, center);

    int first[4];
    int last[4];
    if (glow && mgTransWorldPrim3DSprite(first, last, center, shadow_width, shadow_height, 0)) {
        sprite.TextureCrd(0x61, 1);
        sprite.Vertex4(first);
        sprite.TextureCrd(0x7F, 0x1F);
        sprite.Vertex4(last);
    }
    if (mgTransWorldPrim3DSprite(first, last, center, width, height, 0)) {
        sprite.SetAlphaBlend(MG_ALPHA_BLEND_NORMAL);
        sprite.TextureCrd(draw_u, tex_v);
        sprite.Vertex4(first);
        sprite.TextureCrd(draw_u + tex_w, tex_v + tex_h);
        sprite.Vertex4(last);
    }
    sprite.End();
}

void CPullItem::SetItem(float *position, float *new_velocity, int kind) {
    mgPortEmitPickup(this);
    sceVu0CopyVector(pos, position);
    sceVu0CopyVector(velocity, new_velocity);
    type = kind;
    angle = 0.0f;
    can_get = false;
    fall_time = 300;
    exp_param = -1;
    item_no = -1;
    alpha = 128.0f;
    glow = false;
    bob_height = 15.0f;
    wire_index = -1;

    // Leave fields that retail does not initialize intact, including the ABS
    // animation frame and floating pickups' wait time.
    switch (kind) {
        case PULL_ITEM_GATE_KEY:
        case PULL_ITEM_STOLEN:
            state = PULL_ITEM_STATE_FLOAT;
            tex_u = kind == PULL_ITEM_GATE_KEY ? 0 : 0x61;
            tex_v = kind == PULL_ITEM_GATE_KEY ? 0 : 0x21;
            tex_h = kind == PULL_ITEM_GATE_KEY ? 32 : 30;
            tex_w = kind == PULL_ITEM_GATE_KEY ? 32 : 30;
            width = 7.0f;
            height = 8.0f;
            get_range = 0.8f;
            anim_frame = 0;
            get_delay = 30;
            pull_speed = 1.8f;
            pull_accel = 0.1f;
            bob_height = 4.0f;
            glow = true;
            return;
        case PULL_ITEM_MONEY_LARGE:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 32;
            tex_v = 0;
            tex_h = 32;
            tex_w = 32;
            width = 7.0f;
            height = 8.0f;
            get_range = 4.5f;
            anim_frame = 0;
            get_delay = 40;
            wait_time = 240;
            return;
        case PULL_ITEM_MONEY:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 0;
            tex_v = 32;
            tex_h = 16;
            tex_w = 16;
            width = 3.0f;
            height = 4.0f;
            get_range = 4.5f;
            anim_frame = iRand(16);
            get_delay = 40;
            wait_time = 180;
            return;
        case PULL_ITEM_WEAPON_EXP:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 1;
            tex_v = 0x31;
            tex_h = 14;
            tex_w = 14;
            width = 3.0f;
            height = 3.0f;
            get_range = 4.5f;
            get_delay = 30;
            wait_time = 180;
            pull_speed = 1.8f;
            pull_accel = 0.1f;
            glow = true;
            for (int i = 0; i < DNG_AFTER_WIRE_NUM; ++i) {
                if (afterWire[i].mode) {
                    continue;
                }
                afterWire[i].SetMode(true);
                wire_index = i;
                return;
            }
            return;
        case PULL_ITEM_ITEM:
        case PULL_ITEM_ITEM2:
        case PULL_ITEM_BADGE:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 64;
            tex_v = kind == PULL_ITEM_ITEM2 ? 32 : 0;
            tex_h = 31;
            tex_w = 31;
            width = 7.0f;
            height = kind == PULL_ITEM_ITEM2 ? 7.0f : 8.0f;
            get_range = kind == PULL_ITEM_BADGE ? 1.5f : 4.5f;
            anim_frame = 0;
            get_delay = 10;
            wait_time = 300;
            bob_height = 25.0f;
            return;
    }
}
