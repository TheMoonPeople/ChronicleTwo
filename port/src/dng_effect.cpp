#include "common.h"
#include "mw_runtime.h"

#include <cstdint>

#include "dng_effect.hpp"
#include "gfx/gfx.hpp"
#include "maintex.hpp"
#include "menu_world.hpp"
#include "mg_camera.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "prespr.hpp"

namespace {
// Each Set places the lights around another healing point: a new emission.
uint64_t healing_generation = 0;
} // namespace

// The player's sword glow and pull wire are tagged while the dungeon pause frame is recorded.
PORT_OVERRIDE void CSwordLuminous::Draw() {
    const menuworld::PlayerEffectScope scope(true);
    PortRetailDraw();
}

PORT_OVERRIDE void CAfterWire::DrawWire(float (*smooth)[4]) {
    const menuworld::PlayerEffectScope scope(true);
    PortRetailDrawWire(smooth);
}

// Retail batches every light's glow and halo into one draw at the tick's screen corners, so the
// lights' orbit and bob moved at the game rate. Here each sprite is a draw of its own, keyed by its
// light and kind, and display frames blend its world corners. A culled light leaves no gap that
// would shift another light's match.
PORT_OVERRIDE void CHealingEffectMan::Draw(mgCCamera *camera) {
    float camera_pos[4];
    int   corner0[4];
    int   corner1[4];
    float identity[4][4];
    float rotation[4][4];
    int   glow_alpha;
    int   halo_alpha;

    if (active != 0) {
        camera->GetPos(camera_pos);
        sceVu0UnitMatrix(identity);

        switch (mode) {
            case HEALING_EFFECT_IDLE:
                glow_alpha = 0x80;
                halo_alpha = 0x40;
                break;
            case HEALING_EFFECT_OFF:
                halo_alpha = 0;
                glow_alpha = 0;
                break;
            case HEALING_EFFECT_SPENT: {
                float fade_in = 1.0f - (brightness - 1.0f);
                glow_alpha = fptosi(255.0f * fade_in);
                halo_alpha = fptosi(180.0f * fade_in);
                break;
            }
            case HEALING_EFFECT_RECHARGE: {
                float fade_out = brightness;
                glow_alpha = fptosi(128.0f * fade_out);
                halo_alpha = fptosi(64.0f * fade_out);
                break;
            }
        }

        float distance = mgDistVector(camera_pos, center);

        if (distance <= 640.0f) {
            float distance_fade = 1.0f;

            if (!(distance <= 320.0f)) {
                distance_fade = 1.0f - (distance - 320.0f) / 320.0f;
            }

            glow_alpha = fptosi((float) glow_alpha * distance_fade);
            halo_alpha = fptosi((float) halo_alpha * distance_fade);

            CPreSprite prim;
            prim.Initialize(NULL, NULL);
            prim.Preset2D();
            prim.Coord(1);
            prim.DepthTestEnable(1);
            prim.ZMask(MG_Z_MASK_MASKED);
            prim.Bilinear(1);
            prim.TextureMapEnable(1);
            prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
            prim.Begin(MG_PRIM_SPRITE);
            prim.Texture(TEX_SystemEffect1);
            HEALING_LIGHT *particle = light;

            // A glow is keyed by its light's address and a halo by the next byte, still inside that light.
            auto tag = [](const HEALING_LIGHT *owner, int kind) {
                return gfx::Interp2D{.key = static_cast<gfx::InterpKey>(reinterpret_cast<uintptr_t>(owner) + kind),
                                     .generation = healing_generation,
                                     .world_corners = true,
                                     .teleport_distance = kMgPortFrameTeleportDistance};
            };

            for (int i = 0; i < HEALING_LIGHT_MAX; i++, particle++) {
                particle->pos[0] = 0.0f;
                particle->pos[1] = particle->bob_height * sinf(particle->bob_phase);
                particle->pos[2] = particle->radius;
                sceVu0RotMatrixY(rotation, identity, particle->angle);
                sceVu0ApplyMatrix(particle->pos, rotation, particle->pos);
                sceVu0AddVector(particle->pos, particle->pos, center);
                particle->pos[1] += 8.0f;
                particle->pos[3] = 1.0f;
                float glow_size = 3.0f * brightness;

                if (mgTransWorldPrim3DSprite(corner0, corner1, particle->pos, glow_size, glow_size, 0) != 0) {
                    const gfx::Interp2DScope scope(tag(particle, 0));
                    prim.Color(0x5A, 0x80, 0x40, glow_alpha);
                    prim.TextureCrd(0, 0x20);
                    prim.Vertex4(corner0);
                    prim.TextureCrd(0x1F, 0x3F);
                    prim.Vertex4(corner1);
                    mgPortPrimFlush(prim);
                }

                float halo_size = 30.0f * brightness;

                if (mgTransWorldPrim3DSprite(corner0, corner1, particle->pos, halo_size, halo_size, 0) != 0) {
                    const gfx::Interp2DScope scope(tag(particle, 1));
                    prim.Color(0x5A, 0x80, 0x5A, halo_alpha);
                    prim.TextureCrd(0x40, 0x40);
                    prim.Vertex4(corner0);
                    prim.TextureCrd(0x7F, 0x7F);
                    prim.Vertex4(corner1);
                    mgPortPrimFlush(prim);
                }
            }

            prim.End();
        }
    }
}

PORT_OVERRIDE void CHealingEffectMan::Set(float *pos) {
    ++healing_generation;
    sceVu0CopyVector(this->center, pos);
    this->active = true;
    this->mode = HEALING_EFFECT_IDLE;
    this->brightness = 1.0f;
}
