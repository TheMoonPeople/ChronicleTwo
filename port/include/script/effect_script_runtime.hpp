#pragma once

#include <cstddef>

#include "gfx/gfx.hpp"

/**
 *
 * Effect-script programs that retail's EFFECT_SCRIPT_PROG leaves unnamed.
 *
 */
enum class EffectScriptProgram : int {
    Init = 100,  /**< Initialisation program that every effect script defines empty; the engine never runs it. */
    Start = 200, /**< Runs the effect from the frame it is created. */
};

class CEffectScriptMan;
class mgC3DSprite;
class mgCTexture;
struct _EFF_SCRIPT;

/**
 * Interpolation tag of sprite `index` of a running effect: keyed by the sprite with world corners, its generation the
 * sprite's incarnation, or no tag (key 0) when the effect's sprites are not interpolated. Only the recovery effect
 * (n_heal and n_heal_sub) interpolates its sprites. An incarnation is renewed when the script assigns the effect's
 * sprites or resets the slot (_SPT_ASSIGN_SPRITE, _SPT_INIT_SPRITE), and when the sprite array is found replaced.
 */
gfx::Interp2D PortEffectSpriteTag(const _EFF_SCRIPT *script, int index);

/**
 * Builds an effect's visible sprites into `renderer`'s open packet, as retail's DrawEffSptSprite does. An effect
 * whose sprites interpolate gives each sprite a batch of its own under its tag, unless a tag is already current.
 */
void PortDrawEffectSprites(_EFF_SCRIPT *script, mgCTexture *texture, float *offset, mgC3DSprite *renderer);

/**
 * Number of running recovery effects whose sprite incarnations are kept. For tests.
 */
std::size_t PortRecoveryEffectCount();

/**
 * Makes `script` the effect whose script is running, as CEffectScriptMan::Step does around each one, so the sprite
 * commands act on it. For tests (port/src/effscript_config_bridge.inc).
 */
void PortSetRunningEffect(CEffectScriptMan *manager, _EFF_SCRIPT *script);
