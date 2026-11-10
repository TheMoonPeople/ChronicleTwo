#include "common.h"

#include <cstdint>
#include <string>
#include <unordered_map>

#include "dng_hud.hpp"
#include "maintex.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "object/dun/target_presentation.hpp"
#include "prespr.hpp"
#include "screen_overlay_anchor.hpp"

namespace {
// Host-only identities keep presentation state out of retail objects and saves.
struct GaugeEmission {
    uint64_t            life = 0;
    uint64_t            content = 0;
    uint64_t            rage = 0;
    int                 max_hp = 0, screen = 0;
    char                brackets = 0, label = 0;
    ScreenOverlayAnchor anchor;
};

struct TargetEmission {
    CActiveMonster     *target = nullptr;
    int                 slot = -1;
    uint64_t            life = 0, generation = 0;
    bool                locked = false;
    std::string         name;
    ScreenOverlayAnchor anchor;
};

std::unordered_map<CEnemyLifeGage *, GaugeEmission> gauges;
std::unordered_map<CLockOnModel *, TargetEmission>  targets;
uint64_t                                            next_generation = 0;

gfx::Interp2D Tag(const void *identity, uint64_t generation) {
    return {.key = static_cast<gfx::InterpKey>(reinterpret_cast<uintptr_t>(identity)), .generation = generation};
}
} // namespace

void mgPortHideTarget(CLockOnModel *lock) {
    auto &state = targets[lock];
    state.target = nullptr;
    state.slot = -1;
}

void mgPortTrackTarget(CLockOnModel *lock, CActiveMonster *target, int slot, bool locked) {
    auto      &state = targets[lock];
    const auto life = gauges[&target->life_gage].life;
    int        projected[4];
    const bool cut = mgTransWorldScreen(projected, lock->pos) &&
                     state.anchor.Update(projected[0] / 16, projected[1] / 16);
    if (cut || state.target != target || state.slot != slot || state.life != life || state.locked != locked ||
        state.name != target->tbl->name) {
        state.generation = ++next_generation;
    }
    state.target = target;
    state.slot = slot;
    state.life = life;
    state.locked = locked;
    state.name = target->tbl->name;
}

gfx::Interp2D mgPortTargetBrackets(CLockOnModel *lock) {
    auto &state = targets[lock];
    return state.target && state.locked ? Tag(&gauges[&state.target->life_gage].brackets, state.generation) : gfx::Interp2D{};
}

gfx::Interp2D mgPortTargetName(CLockOnModel *lock) {
    auto &state = targets[lock];
    return state.target ? Tag(&gauges[&state.target->life_gage].label, state.generation) : gfx::Interp2D{};
}

void CEnemyLifeGage::Initialize(int count) {
    auto &state = gauges[this];
    state = {};
    state.life = state.content = ++next_generation;
    ResetGekirin(count);
    hp = 0;
    max_hp = 0;
    view = 0;
    scale = 0;
}

void CEnemyLifeGage::ResetGekirin(int count) {
    // Refilled marks and reused monster storage start new presentation lifetimes.
    // HP changes do not restart marks that are already moving above the gauge.
    gauges[this].rage = ++next_generation;
    for (int i = 0; i < ENEMY_LIFE_GAGE_GEKIRIN_MAX; ++i) {
        gekirin[i].frame = 0;
        gekirin[i].state = i < count ? GEKIRIN_STATE_SHOW : GEKIRIN_STATE_NONE;
    }
}

void CEnemyLifeGage::SetView(int visible) {
    if (visible != 0) {
        if (view == 0) {
            gauges[this].content = ++next_generation;
            scale = 0.5f;
        }
    } else if (view != 0) {
        scale = 1.0f;
    }
    view = visible;
}

void CLockOnModel::Initialize(CScene *new_scene) {
    mgPortHideTarget(this);
    scene = new_scene;
    name = nullptr;
}

void CEnemyLifeGage::Draw(int hide_gekirin) {
    if (scale <= 0 || (max_hp == 0 && hp == 0)) {
        return;
    }
    if (screen != 0) {
        CPreSprite prim;
        prim.Initialize(nullptr, nullptr);
        prim.Preset2D();
        prim.Begin(MG_PRIM_SPRITE);
        prim.Bilinear(0);
        prim.Texture(TEX_SystenFrame);
        int y = mgScreenHeight - 44;
        prim.Color(128, 128, 128, 128);
        prim.SetIRect(16, y, 34, 34, 210, 146);
        for (int i = 0; i < 15; ++i) {
            prim.SetIRect(50 + i * 10, y, 10, 34, 244, 146);
        }
        prim.SetIRect(200, y, 34, 34, 254, 146);
        prim.End();
        prim.Initialize(nullptr, nullptr);
        prim.Preset2D();
        prim.Coord(0);
        prim.TextureMapEnable(0);
        prim.Shading(1);
        prim.Begin(MG_PRIM_TRIANGLE_STRIP);
        float hp_width = 170.0f * (static_cast<float>(hp) / max_hp);
        int   width = static_cast<int>(hp_width * scale);
        y = mgScreenHeight - 39;
        prim.Color(255, 96, 0, 128);
        prim.Vertex(48, y + 12, 0);
        prim.Color(255, 255, 0, 128);
        prim.Vertex(width + 48, y + 12, 0);
        y = mgScreenHeight - 35;
        prim.Color(255, 96, 0, 128);
        prim.Vertex(48, y + 12, 0);
        prim.Color(255, 255, 0, 128);
        prim.Vertex(width + 48, y + 12, 0);
        prim.End();
        return;
    }

    int position[4];
    if (!mgTransWorldScreen(position, pos)) {
        return;
    }
    position[0] /= 16;
    position[1] /= 16;
    position[1] -= 24;
    if (position[1] < 89) {
        position[1] = 88;
    }
    int   half_width = static_cast<int>(34.0f * scale);
    auto &emission = gauges[this];
    if (emission.anchor.Update(position[0], position[1])) {
        emission.content = ++next_generation;
        emission.rage = ++next_generation;
    }
    // Health and projected position follow the same interval. A hit must not cut
    // the entire gauge away from the still-interpolating monster.
    if (emission.max_hp != max_hp || emission.screen != screen) {
        emission.content = ++next_generation;
        emission.max_hp = max_hp;
        emission.screen = screen;
    }
    CPreSprite prim;
    {
        gfx::Interp2DScope interpolation(Tag(this, emission.content));
        prim.Initialize(nullptr, nullptr);
        prim.Preset2D();
        prim.Coord(0);
        prim.TextureMapEnable(0);
        prim.Shading(1);
        prim.Begin(MG_PRIM_TRIANGLE);
        prim.Color(30, 20, 30, 128);
        int left = position[0] - half_width + 2;
        u32 top = position[1];
        int right = position[0] + half_width + 2;
        int bottom = top + 4;
        prim.Vertex(left, top, 0);
        prim.Vertex(right, top, 0);
        prim.Vertex(left, bottom, 0);
        prim.Vertex(left, bottom, 0);
        prim.Vertex(right, bottom, 0);
        prim.Vertex(right, top, 0);
        top = position[1] - 2;
        left = position[0] - half_width;
        float hp_half_width = static_cast<float>(half_width) * (static_cast<float>(hp) / static_cast<float>(max_hp));
        right = static_cast<int>(2.0f * hp_half_width) + left;
        bottom = position[1] + 2;
        prim.Color(255, 96, 0, 128);
        prim.Vertex(left, top, 0);
        prim.Color(255, 255, 0, 128);
        prim.Vertex(right, top, 0);
        prim.Color(255, 96, 0, 128);
        prim.Vertex(left, bottom, 0);
        prim.Color(255, 96, 0, 128);
        prim.Vertex(left, bottom, 0);
        prim.Color(255, 255, 0, 128);
        prim.Vertex(right, bottom, 0);
        prim.Color(255, 255, 0, 128);
        prim.Vertex(right, top, 0);
        prim.End();
    }
    if (hide_gekirin == 0) {
        prim.Initialize(nullptr, nullptr);
        prim.Preset2D();
        prim.Coord(0);
        prim.TextureMapEnable(1);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(128, 128, 128, 128);
        prim.Texture(TEX_SystenFrame);
        int x = position[0] - half_width;
        u32 top = position[1] - 12;
        for (auto &i : gekirin) {
            // These are screen-space marks, including the break-away bounce.
            // Flush each mark while its key is active: disappearing neighbours
            // must not change its identity or inherit its additive halo.
            gfx::Interp2DScope interpolation(Tag(&i, emission.rage));
            i.Draw(&prim, x, top);
            prim.Flush();
            x += 8;
        }
        prim.End();
    }
}

void CLockOnModel::DrawMess(int tex_block) {
    if (!name) {
        return;
    }
    if (!mes->MakeAnd3DPosSet(name, pos, 0, -48)) {
        mes->draw_speed = mes->GetDrawSpeedDef();
        mes->mes_no = -1;
        mes->text_ptr = nullptr;
        mes->open = 0;
        mes->fade = 0;
        mes->fukidashi_centre_x = -1;
        mes->fukidashi_centre_y = -1;
    }
    mes->Step();
    mgTexManager.ReloadTexture(tex_block, static_cast<sceVif1Packet *>(nullptr));
    gfx::Interp2DScope interpolation(mgPortTargetName(this));
    mes->DrawMesWin();
}
