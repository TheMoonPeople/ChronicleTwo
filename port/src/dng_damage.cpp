#include "common.h"

#include <cmath>
#include <cstdio>
#include <cstring>
#include <numbers>
#include <unordered_map>

#include "dng_hud.hpp"
#include "gfx/gfx.hpp"
#include "maintex.hpp"
#include "mglib.hpp"
#include "scenesnd.hpp"
#include "screen_overlay_anchor.hpp"

namespace {
// Keep presentation identity outside the retail objects and their serialized layouts.
struct ScoreEmission {
    uint64_t            generation = 0;
    ScreenOverlayAnchor anchor;
};

std::unordered_map<const void *, ScoreEmission> generations;
uint64_t                                        next_generation = 0;

void Emit(const void *score) { generations[score] = {.generation = ++next_generation, .anchor = {}}; }

gfx::Interp2D Presentation(const void *score, const int *screen) {
    auto found = generations.find(score);
    if (found == generations.end()) {
        return {};
    }
    if (found->second.anchor.Update(screen[0] / 16, screen[1] / 16)) {
        found->second.generation = ++next_generation;
    }
    return {.key = static_cast<gfx::InterpKey>(reinterpret_cast<uintptr_t>(score)), .generation = found->second.generation};
}

void BeginScore(CPreSprite &prim) {
    prim.Initialize(nullptr, nullptr);
    prim.Preset2D();
    prim.Coord(1);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(TEX_SystenFrame);
    prim.AlphaTestEnable(1);
}
} // namespace

void CDamageScore::SetValue(float *position, int value) {
    Emit(this);
    sceVu0CopyVector(pos, position);
    alpha = 0;
    phase = DAMAGE_SCORE_PHASE_APPEAR;
    active = true;
    sprite = false;
    std::snprintf(text, sizeof(text), "%d", value);
    length = std::strlen(text);
    for (int i = 0; i < length; ++i) {
        bounce[i] = std::numbers::pi_v<float>;
    }
}

void CDamageScore::SetSprite(float *position, int u, int v, int width, int height) {
    Emit(this);
    sceVu0CopyVector(pos, position);
    alpha = 0;
    phase = DAMAGE_SCORE_PHASE_APPEAR;
    active = true;
    sprite = true;
    bounce[0] = std::numbers::pi_v<float>;
    sprite_w = width;
    sprite_h = height;
    sprite_u = u;
    sprite_v = v;
}

void CDamageScore::Draw() {
    if (!active) {
        return;
    }
    CPreSprite prim;
    int        screen[4];
    pos[3] = 1.0f;
    if (!mgTransWorldPrim(screen, pos)) {
        return;
    }
    gfx::Interp2DScope interpolation(Presentation(this, screen));
    BeginScore(prim);
    if (sprite) {
        if (mgTransWorldPrim(screen, pos)) {
            prim.Color(0x80, 0x80, 0x80, alpha);
            screen[1] += static_cast<int>(12.0f * sinf(bounce[0])) << 4;
            prim.TextureCrd(sprite_u, sprite_v);
            prim.Vertex4(screen[0], screen[1], 0);
            prim.TextureCrd(sprite_u + sprite_w, sprite_v + sprite_h);
            prim.Vertex4(screen[0] + (sprite_w << 4), screen[1] + (sprite_h << 4), 0);
        }
    } else {
        for (int i = 0; text[i] > 0; ++i) {
            if (!mgTransWorldPrim(screen, pos)) {
                continue;
            }
            prim.Color(color[0], color[1], color[2], alpha);
            screen[0] -= (length * digit_w) << 3;
            screen[0] += (i * digit_w) << 4;
            screen[1] += static_cast<int>(48.0f * sinf(bounce[i])) << 4;
            const int digit = text[i] - '0';
            prim.TextureCrd(digit_u + digit * digit_w, digit_v);
            prim.Vertex4(screen[0], screen[1], 0);
            prim.TextureCrd(digit_w + (digit_u + digit * digit_w), digit_v + digit_h);
            prim.Vertex4(screen[0] + (digit_w << 4), screen[1] + (digit_h << 4), 0);
        }
    }
    prim.End();
}

void CDamageScore2::SetValue(int slot, int amount, float rise) {
    Emit(this);
    chara_no = slot;
    alpha = 0;
    value = amount;
    phase = DAMAGE_SCORE2_PHASE_JUMP;
    offset_y = 0;
    height = 2.0f * rise;
    progress = 0;
    std::snprintf(text, sizeof(text), "%d", value);
    length = std::strlen(text);
}

void CDamageScore2::Draw(CScene *scene) {
    if (phase == DAMAGE_SCORE2_PHASE_NONE || length <= 0) {
        return;
    }
    auto *character = scene->GetCharacter(chara_no);
    if (!character) {
        return;
    }
    auto *frame = character->GetFrame();
    if (!frame) {
        return;
    }
    CPreSprite    prim;
    int           screen[4];
    sceVu0FVECTOR position;
    frame->GetWorldPosition0(position);
    position[1] += height;
    position[3] = 1.0f;
    if (!mgTransWorldPrim(screen, position)) {
        return;
    }
    gfx::Interp2DScope interpolation(Presentation(this, screen));
    BeginScore(prim);
    for (int i = 0; text[i] > 0; ++i) {
        if (!mgTransWorldPrim(screen, position)) {
            continue;
        }
        screen[0] -= (length * 14 / 2) << 4;
        screen[0] += (i * 14) << 4;
        screen[1] += static_cast<int>(offset_y) << 4;
        const int digit = text[i] - '0';
        prim.Color(220, 96, 96, static_cast<int>(128.0f * alpha));
        prim.TextureCrd(digit * 12 + 78, 162);
        prim.Vertex4(screen[0], screen[1], 0);
        prim.TextureCrd(digit * 12 + 90, 179);
        prim.Vertex4(screen[0] + 224, screen[1] + 304, 0);
    }
    prim.End();
}
