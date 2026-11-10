#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <string_view>

#include "effect.hpp"
#include "effectlist.hpp"
#include "memory/tracked_copy.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scriptinterpreter.hpp"
#include "text/bounded.hpp"

/**
 *
 * Effect manager receiving the current script.
 *
 */
static CEffectManager *g_tmp_effm;

/**
 *
 * Emitter receiving the current script block.
 *
 */
static CEffectCtrl *g_tmp_effc;

/**
 *
 * Whether parsed emitters are entered into the manager.
 *
 */
static int g_eff_entry_flag;

/**
 *
 * Name of the emitter being parsed.
 *
 */
static char g_tmp_eff_name[0x20];

/**
 *
 * Draws a uniform random value around a center.
 *
 */
float UniformityRand(float center, float range) {
    float value = (float) rand() / 2147483648.0f;

    value *= range;
    value = center + value;
    return value - range / 2.0f;
}

/**
 *
 * Draws an averaged random value around a center.
 *
 */
float RegularityRand(float center, float range, int samples) {
    float sum = 0.0f;
    int   i = {};

    for (i = 0; i < samples; i++) {
        sum += (float) rand() / 2147483648.0f;
        sum -= (float) rand() / 2147483648.0f;
    }

    sum /= (float) samples;
    sum *= range;
    return center + sum;
}

/**
 *
 * Restores an effect parameter set to its defaults.
 *
 */
void InitEffectParam(EFFECT_PARAM *param) {
    int i = {};

    param->life = 0;
    param->dir = 0;
    param->height = 0;
    param->width = 0;
    param->pos[0] = 0;
    param->pos[1] = 0;
    param->pos[2] = 0;
    param->pos[3] = 1.0f;
    param->velo[0] = 0;
    param->velo[1] = 0;
    param->velo[2] = 0;
    param->velo[3] = 0;
    param->velo_mul[0] = 1.0f;
    param->velo_mul[1] = 1.0f;
    param->velo_mul[2] = 1.0f;
    param->velo_mul[3] = 1.0f;
    param->acc[0] = 0;
    param->acc[1] = 0;
    param->acc[2] = 0;
    param->acc[3] = 0;
    param->acc_mul[0] = 1.0f;
    param->acc_mul[1] = 1.0f;
    param->acc_mul[2] = 1.0f;
    param->acc_mul[3] = 1.0f;
    param->move_type[0] = EFFECT_CHANGE_NONE;
    param->move_type[1] = EFFECT_CHANGE_NONE;
    param->move_type[2] = EFFECT_CHANGE_NONE;
    param->move_p1[0] = 0;
    param->move_p1[1] = 0;
    param->move_p1[2] = 0;
    param->move_p1[3] = 0;
    param->move_p2[0] = 0;
    param->move_p2[1] = 0;
    param->move_p2[2] = 0;
    param->move_p2[3] = 0;
    param->scale_type[0] = EFFECT_CHANGE_NONE;
    param->scale_type[1] = EFFECT_CHANGE_NONE;
    param->scale_type[2] = EFFECT_CHANGE_NONE;
    param->scale[0] = 1.0f;
    param->scale[1] = 1.0f;
    param->scale[2] = 1.0f;
    param->scale[3] = 1.0f;
    param->svelo[0] = 0;
    param->svelo[1] = 0;
    param->svelo[2] = 0;
    param->svelo[3] = 0;
    param->scale_p1[0] = 0;
    param->scale_p1[1] = 0;
    param->scale_p1[2] = 0;
    param->scale_p1[3] = 0;
    param->scale_p2[0] = 0;
    param->scale_p2[1] = 0;
    param->scale_p2[2] = 0;
    param->scale_p2[3] = 0;
    param->alpha_blend = EFFECT_ALPHA_BLEND_NONE;
    param->alpha_type = EFFECT_CHANGE_NONE;
    param->alpha = 1.0f;
    param->alpha_p1 = 0;
    param->alpha_p2 = 0;

    i = 0;

    do {
        param->tex_rect[i][0] = 0;
        param->tex_rect[i][1] = 0;
        param->tex_rect[i][2] = 0;
        param->tex_rect[i][3] = 0;
        i++;
    } while (i < 8);

    param->tex_get_type = 0;
    param->tex_frame = 0;
    param->gravity = 0;
    param->gravity_pos[3] = 0;
    param->gravity_pos[2] = 0;
    param->gravity_pos[1] = 0;
    param->gravity_pos[0] = 0;
    param->gravity_accel = 9.80665f;
    param->gravity_mass = 10.0f;
}

CEffect::CEffect() {
    Initialize();
}

void CEffect::Initialize() {
    active = 0;
    frame = 0;
    InitEffectParam(&param);
    pos[0] = 0;
    pos[1] = 0;
    pos[2] = 0;
    pos[3] = 0;
    scale[0] = 0;
    scale[1] = 0;
    scale[2] = 0;
    scale[3] = 0;
    alpha = 0;
    tex_rect[0] = 0;
    tex_rect[1] = 0;
    tex_rect[2] = 0;
    tex_rect[3] = 0;
    tex_index = 0;
    tex_count = 0;
}

void CEffect::SetEffect(EFFECT_PARAM *param) {
    active = 1;
    pos[0] = 0;
    pos[1] = 0;
    pos[2] = 0;
    scale[0] = 0;
    scale[1] = 0;
    scale[2] = 0;
    alpha = 0;
    tex_rect[0] = 0;
    tex_rect[1] = 0;
    tex_rect[2] = 0;
    tex_rect[3] = 0;
    tex_index = 0;
    tex_count = 0;
    dc2::memory::CopyTrackedBytes(&this->param, param, sizeof(EFFECT_PARAM));
}

static inline void GravityAbs(float *step) {
    if (*step < 0.0f) {
        *step = -*step;
    }
}

static inline void GravityPull(float *pos, float *target, float *step) {
    if (*pos < *target) {
        *pos += *step;

        if (*pos > *target) {
            *pos = *target;
        }
    } else {
        *pos -= *step;

        if (*pos < *target) {
            *pos = *target;
        }
    }
}

void CEffect::Step(int steps) {
    int                channel = {};
    sceVu0FVECTOR      gravity_step;
    EFFECT_CHANGE_TYPE change{};
    float             *value{};
    float              amount{};
    float              life = {};
    float              timing{};
    float              distance = {};
    float              duration = {};
    float              rate = {};
    int                axis = {};

    if (active == 0) {
        return;
    }

    frame++;

    if (param.life < frame) {
        active = 0;
        frame = 0;
    }

    if (param.texture == nullptr) {
        active = 0;
        frame = 0;
    }

    sceVu0AddVector(param.pos, param.pos, param.velo);
    sceVu0AddVector(param.velo, param.velo, param.acc);
    sceVu0MulVector(param.velo, param.velo, param.velo_mul);
    sceVu0MulVector(param.acc, param.acc, param.acc_mul);

    if (param.gravity != 0) {
        sceVu0SubVector(gravity_step, param.gravity_pos, param.pos);
        distance = mgDistVector(gravity_step);

        if (distance != 0.0f) {
            sceVu0ScaleVector(gravity_step, gravity_step, (param.gravity_accel * param.gravity_mass) / (distance * distance));
            GravityAbs(&gravity_step[0]);
            GravityAbs(&gravity_step[1]);
            GravityAbs(&gravity_step[2]);
            GravityPull(&param.pos[0], &param.gravity_pos[0], &gravity_step[0]);
            GravityPull(&param.pos[1], &param.gravity_pos[1], &gravity_step[1]);
            GravityPull(&param.pos[2], &param.gravity_pos[2], &gravity_step[2]);
        }
    }

    sceVu0CopyVector(pos, param.pos);
    pos[3] = 1.0f;
    sceVu0AddVector(param.scale, param.scale, param.svelo);
    sceVu0CopyVector(scale, param.scale);
    scale[3] = 1.0f;
    alpha = param.alpha;

    for (channel = 0; channel < 6; channel++) {
        switch (channel) {
            case 0:
                change = param.move_type[0];
                amount = param.move_p1[0];
                timing = param.move_p2[0];
                value = &pos[0];
                break;
            case 1:
                change = param.move_type[1];
                amount = param.move_p1[1];
                timing = param.move_p2[1];
                value = &pos[1];
                break;
            case 2:
                change = param.move_type[2];
                amount = param.move_p1[2];
                timing = param.move_p2[2];
                value = &pos[2];
                break;
            case 3:
                change = param.scale_type[0];
                amount = param.scale_p1[0];
                timing = param.scale_p2[0];
                value = &scale[0];
                break;
            case 4:
                change = param.scale_type[1];
                amount = param.scale_p1[1];
                timing = param.scale_p2[1];
                value = &scale[1];
                break;
            case 5:
                change = param.alpha_type;
                amount = param.alpha_p1;
                timing = param.alpha_p2;
                value = &alpha;
                break;
        }

        int total = {};
        switch (change) {
            case EFFECT_CHANGE_ADD:
                life = param.life;

                if (life > 0.0f) {
                    float per_frame = timing * (amount / life);
                    per_frame *= (float) frame;
                    *value += per_frame;
                }

                break;
            case EFFECT_CHANGE_SUB:
                life = param.life;

                if (life > 0.0f) {
                    rate = timing * (amount / life);
                    rate *= (float) frame;
                    *value -= rate;
                }

                break;
            case EFFECT_CHANGE_ADD_HEAD:
                life = param.life;

                if (life > 0.0f) {
                    duration = life * timing;
                    rate = amount / duration;

                    if ((float) frame < duration) {
                        rate *= (float) frame;
                        *value += rate;
                    } else {
                        rate *= duration;
                        *value += rate;
                    }
                }

                break;
            case EFFECT_CHANGE_SUB_TAIL:
                life = param.life;

                if (life > 0.0f) {
                    duration = life * timing;
                    rate = amount / duration;

                    if ((float) frame > duration) {
                        rate *= ((float) frame - duration);
                        *value -= rate;
                    }
                }

                break;
            case EFFECT_CHANGE_ADD_HEAD_TAIL:
                total = param.life;
                life = total;

                if (life > 0.0f) {
                    duration = life * timing;
                    rate = amount / duration;

                    if ((float) frame < duration) {
                        rate *= (float) frame;
                        *value += rate;
                    } else if ((float) frame > life - duration) {
                        rate *= (float) (total - frame);
                        *value += rate;
                    } else {
                        rate *= duration;
                        *value += rate;
                    }
                }

                break;
            case EFFECT_CHANGE_SINE:
                life = param.life;

                if (life > 0.0f) {
                    duration = life * timing;
                    *value += (float) (amount * sin((frame * (360.0f / duration)) * 0.017453293005625408));
                }

                break;
        }
    }

    if (alpha < 0.0f) {
        alpha = 0.0f;
    }

    if (alpha > 1.0f) {
        alpha = 1.0f;
    }

    if (param.tex_get_type == 0) {
        tex_rect[0] = param.tex_rect[0][0];
        tex_rect[1] = param.tex_rect[0][1];
        tex_rect[2] = param.tex_rect[0][2];
        tex_rect[3] = param.tex_rect[0][3];
    } else {
        tex_count++;

        if (tex_count > param.tex_frame) {
            tex_index++;
            tex_count = 0;
        }

        tex_rect[0] = param.tex_rect[tex_index][0];
        tex_rect[1] = param.tex_rect[tex_index][1];
        tex_rect[2] = param.tex_rect[tex_index][2];
        tex_rect[3] = param.tex_rect[tex_index][3];
    }
}

void CEffect::Draw() {
    mgCDrawPrim prim;
    int         corner_a[4];
    int         corner_b[4];
    float       width = {};
    float       height = {};

    if (active != 0) {
        prim.Initialize(nullptr, nullptr);
        prim.TextureMapEnable(1);
        prim.AlphaTestEnable(1);
        prim.AlphaTest(5, 0);
        prim.AlphaBlendEnable(1);

        if (param.alpha_blend == 1) {
            prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
        } else if (param.alpha_blend == 1) {
            prim.AlphaBlend(MG_ALPHA_BLEND_SUB);
        } else {
            prim.AlphaBlend(MG_ALPHA_BLEND_NONE);
        }

        prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
        prim.DepthTestEnable(1);
        prim.ZMask(MG_Z_MASK_MASKED);
        prim.Coord(1);

        width = param.width;
        width *= scale[0];
        height = param.height;
        height *= scale[1];

        if (mgTransWorldPrim3DSprite(corner_a, corner_b, pos, width, height, 0) != 0) {
            prim.Begin(MG_PRIM_SPRITE);
            prim.Color(0x80, 0x80, 0x80, fptosi(128.0f * alpha));
            prim.Texture(param.texture);
            prim.TextureCrd(tex_rect[0], tex_rect[1]);
            prim.Vertex4(corner_a);
            prim.TextureCrd((tex_rect[0] + tex_rect[2]) - 1, (tex_rect[1] + tex_rect[3]) - 1);
            prim.Vertex4(corner_b);
            prim.End();
        }
    }
}

CEffectCtrl::CEffectCtrl() {
    Initialize();
}

void CEffectCtrl::Ctrl(CEffect *effects, int effect_num) {
    int          spawned = {};
    int          count = {};
    int          i = {};
    EFFECT_PARAM param;

    if (run == 0 || entry == 0 || effects == nullptr || effect_num <= 0 ||
        tex_rect_num > static_cast<int>(std::size(tex_rect))) {
        return;
    }
    const int rectangle_count = std::max(1, tex_rect_num);

    if (repeat == 1) {
        repeat_timer += 1;

        if (repeat_timer < repeat_wait_now) {
            return;
        }

        switch (rep_rand_type) {
            case EFFECT_RAND_NONE:
                break;
            case EFFECT_RAND_UNIFORMITY:
                repeat_wait_now = fptosi(UniformityRand((float) repeat_wait, rep_rand));
                break;
            case EFFECT_RAND_REGULARITY:
                repeat_wait_now =
                    fptosi(RegularityRand((float) repeat_wait, rep_rand, rep_rand_count));
                break;
        }

        repeat_timer = 0;
        repeat_cnt += 1;

        if (repeat_num != -1 && repeat_cnt >= repeat_num) {
            run = 0;
        }
    } else {
        run = 0;
    }

    switch (num_rand_type) {
        case EFFECT_RAND_NONE:
            count = num;
            break;
        case EFFECT_RAND_UNIFORMITY:
            count = fptosi(UniformityRand((float) num, num_rand));
            break;
        case EFFECT_RAND_REGULARITY:
            count = fptosi(RegularityRand((float) num, num_rand, num_rand_count));
            break;
    }

    for (spawned = 0; spawned < count; spawned++) {
        InitEffectParam(&param);

        switch (cnt_rand_type) {
            case EFFECT_RAND_NONE:
                param.life = this->count;
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.life = UniformityRand(this->count, cnt_rand);
                break;
            case EFFECT_RAND_REGULARITY:
                param.life = RegularityRand(this->count, cnt_rand, cnt_rand_count);
                break;
        }

        param.width = width;
        param.height = height;
        param.dir = dir;

        switch (pos_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.pos, pos);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.pos[0] = UniformityRand(pos[0], pos_rand[0]);
                param.pos[1] = UniformityRand(pos[1], pos_rand[1]);
                param.pos[2] = UniformityRand(pos[2], pos_rand[2]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.pos[0] = RegularityRand(pos[0], pos_rand[0], pos_rand_count);
                param.pos[1] = RegularityRand(pos[1], pos_rand[1], pos_rand_count);
                param.pos[2] = RegularityRand(pos[2], pos_rand[2], pos_rand_count);
                break;
        }

        sceVu0AddVector(param.pos, param.pos, origin);
        param.move_type[0] = move_type.x;
        param.move_type[1] = move_type.y;
        param.move_type[2] = move_type.z;
        sceVu0CopyVector(param.velo_mul, velo_mul);
        sceVu0CopyVector(param.acc_mul, acc_mul);

        switch (velo_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.velo, velo);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.velo[0] = UniformityRand(velo[0], velo_rand[0]);
                param.velo[1] = UniformityRand(velo[1], velo_rand[1]);
                param.velo[2] = UniformityRand(velo[2], velo_rand[2]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.velo[0] = RegularityRand(velo[0], velo_rand[0], velo_rand_count);
                param.velo[1] = RegularityRand(velo[1], velo_rand[1], velo_rand_count);
                param.velo[2] = RegularityRand(velo[2], velo_rand[2], velo_rand_count);
                break;
        }

        switch (acc_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.acc, acc);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.acc[0] = UniformityRand(acc[0], acc_rand[0]);
                param.acc[1] = UniformityRand(acc[1], acc_rand[1]);
                param.acc[2] = UniformityRand(acc[2], acc_rand[2]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.acc[0] = RegularityRand(acc[0], acc_rand[0], acc_rand_count);
                param.acc[1] = RegularityRand(acc[1], acc_rand[1], acc_rand_count);
                param.acc[2] = RegularityRand(acc[2], acc_rand[2], acc_rand_count);
                break;
        }

        switch (move_p1_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.move_p1, move_p1);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.move_p1[0] = UniformityRand(move_p1[0], move_p1_rand[0]);
                param.move_p1[1] = UniformityRand(move_p1[1], move_p1_rand[1]);
                param.move_p1[2] = UniformityRand(move_p1[2], move_p1_rand[2]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.move_p1[0] = RegularityRand(move_p1[0], move_p1_rand[0], move_p1_rand_count);
                param.move_p1[1] = RegularityRand(move_p1[1], move_p1_rand[1], move_p1_rand_count);
                param.move_p1[2] = RegularityRand(move_p1[2], move_p1_rand[2], move_p1_rand_count);
                break;
        }

        switch (move_p2_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.move_p2, move_p2);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.move_p2[0] = UniformityRand(move_p2[0], move_p2_rand[0]);
                param.move_p2[1] = UniformityRand(move_p2[1], move_p2_rand[1]);
                param.move_p2[2] = UniformityRand(move_p2[2], move_p2_rand[2]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.move_p2[0] = RegularityRand(move_p2[0], move_p2_rand[0], move_p2_rand_count);
                param.move_p2[1] = RegularityRand(move_p2[1], move_p2_rand[1], move_p2_rand_count);
                param.move_p2[2] = RegularityRand(move_p2[2], move_p2_rand[2], move_p2_rand_count);
                break;
        }

        param.scale_type[0] = scale_type.x;
        param.scale_type[1] = scale_type.y;
        param.scale_type[2] = scale_type.z;

        switch (scale_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.scale, scale);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.scale[0] = UniformityRand(scale[0], scale_rand[0]);
                param.scale[1] = UniformityRand(scale[1], scale_rand[1]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.scale[0] = RegularityRand(scale[0], scale_rand[0], scale_rand_count);
                param.scale[1] = RegularityRand(scale[1], scale_rand[1], scale_rand_count);
                break;
        }

        switch (svelo_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.svelo, svelo);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.svelo[0] = UniformityRand(svelo[0], svelo_rand[0]);
                param.svelo[1] = UniformityRand(svelo[1], svelo_rand[1]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.svelo[0] =
                    RegularityRand(svelo[0], svelo_rand[0], svelo_rand_count);
                param.svelo[1] =
                    RegularityRand(svelo[1], svelo_rand[1], svelo_rand_count);
                break;
        }

        switch (scale_p1_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.scale_p1, scale_p1);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.scale_p1[0] = UniformityRand(scale_p1[0], scale_p1_rand[0]);
                param.scale_p1[1] = UniformityRand(scale_p1[1], scale_p1_rand[1]);
                param.scale_p1[2] = UniformityRand(scale_p1[2], scale_p1_rand[2]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.scale_p1[0] =
                    RegularityRand(scale_p1[0], scale_p1_rand[0], scale_p1_rand_count);
                param.scale_p1[1] =
                    RegularityRand(scale_p1[1], scale_p1_rand[1], scale_p1_rand_count);
                param.scale_p1[2] =
                    RegularityRand(scale_p1[2], scale_p1_rand[2], scale_p1_rand_count);
                break;
        }

        switch (scale_p2_rand_type) {
            case EFFECT_RAND_NONE:
                sceVu0CopyVector(param.scale_p2, scale_p2);
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.scale_p2[0] = UniformityRand(scale_p2[0], scale_p2_rand[0]);
                param.scale_p2[1] = UniformityRand(scale_p2[1], scale_p2_rand[1]);
                param.scale_p2[2] = UniformityRand(scale_p2[2], scale_p2_rand[2]);
                break;
            case EFFECT_RAND_REGULARITY:
                param.scale_p2[0] =
                    RegularityRand(scale_p2[0], scale_p2_rand[0], scale_p2_rand_count);
                param.scale_p2[1] =
                    RegularityRand(scale_p2[1], scale_p2_rand[1], scale_p2_rand_count);
                param.scale_p2[2] =
                    RegularityRand(scale_p2[2], scale_p2_rand[2], scale_p2_rand_count);
                break;
        }

        param.alpha = alpha;
        param.alpha_blend = alpha_blend;
        param.alpha_type = alpha_type;

        switch (alpha_rand_type) {
            case EFFECT_RAND_NONE:
                param.alpha = alpha;
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.alpha = UniformityRand(alpha, alpha_rand);
                break;
            case EFFECT_RAND_REGULARITY:
                param.alpha = RegularityRand(alpha, alpha_rand, alpha_rand_count);
                break;
        }

        switch (alpha_p1_rand_type) {
            case EFFECT_RAND_NONE:
                param.alpha_p1 = alpha_p1;
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.alpha_p1 = UniformityRand(alpha_p1, alpha_p1_rand);
                break;
            case EFFECT_RAND_REGULARITY:
                param.alpha_p1 = RegularityRand(alpha_p1, alpha_p1_rand, alpha_p1_rand_count);
                break;
        }

        switch (alpha_p2_rand_type) {
            case EFFECT_RAND_NONE:
                param.alpha_p2 = alpha_p2;
                break;
            case EFFECT_RAND_UNIFORMITY:
                param.alpha_p2 = UniformityRand(alpha_p2, alpha_p2_rand);
                break;
            case EFFECT_RAND_REGULARITY:
                param.alpha_p2 = RegularityRand(alpha_p2, alpha_p2_rand, alpha_p2_rand_count);
                break;
        }

        param.tex_get_type = tex_get_type;

        if (tex_get_type == 0) {
            if (tex_rect_num <= 0) {
                tex_rect_num = 1;
            }

            std::ranges::copy(tex_rect[rand() % rectangle_count], param.tex_rect[0]);
        } else {
            for (std::size_t index = 0; index < std::size(tex_rect); ++index) {
                std::ranges::copy(tex_rect[index], param.tex_rect[index]);
            }
            param.tex_frame = param.life / rectangle_count;
        }

        param.gravity = gravity;
        sceVu0AddVector(param.gravity_pos, gravity_pos, origin);
        param.gravity_accel = gravity_accel;
        param.gravity_mass = gravity_mass;
        param.texture = texture;

        for (i = 0; i < effect_num; i++) {
            if (effects[i].active == 0) {
                effects[i].SetEffect(&param);
                break;
            }
        }
    }
}

void CEffectCtrl::Initialize() {
    int i = {};

    entry = 0;
    run = 0;
    origin[0] = 0;
    origin[1] = 0;
    origin[2] = 0;
    origin[3] = 0;
    width = 1.0f;
    height = 1.0f;
    dir = 0;
    num = 0;
    num_rand_type = EFFECT_RAND_NONE;
    num_rand = 0;
    num_rand_count = 1;
    count = 0;
    cnt_rand_type = EFFECT_RAND_NONE;
    cnt_rand = 0;
    cnt_rand_count = 1;
    repeat = 0;
    repeat_wait = 0;
    repeat_timer = 0;
    rep_rand_type = EFFECT_RAND_NONE;
    rep_rand = 0;
    rep_rand_count = 1;
    repeat_cnt = 0;
    repeat_num = -1;
    move_type.x = EFFECT_CHANGE_NONE;
    move_type.y = EFFECT_CHANGE_NONE;
    move_type.z = EFFECT_CHANGE_NONE;
    pos[0] = 0;
    pos[1] = 0;
    pos[2] = 0;
    pos[3] = 1.0f;
    pos_rand_type = EFFECT_RAND_NONE;
    pos_rand[0] = 0;
    pos_rand[1] = 0;
    pos_rand[2] = 0;
    pos_rand[3] = 1.0f;
    pos_rand_count = 1;
    velo[0] = 0;
    velo[1] = 0;
    velo[2] = 0;
    velo[3] = 1.0f;
    velo_mul[0] = 1.0f;
    velo_mul[1] = 1.0f;
    velo_mul[2] = 1.0f;
    velo_mul[3] = 1.0f;
    velo_rand_type = EFFECT_RAND_NONE;
    velo_rand[0] = 0;
    velo_rand[1] = 0;
    velo_rand[2] = 0;
    velo_rand[3] = 1.0f;
    velo_rand_count = 1;
    acc[0] = 0;
    acc[1] = 0;
    acc[2] = 0;
    acc[3] = 1.0f;
    acc_mul[0] = 1.0f;
    acc_mul[1] = 1.0f;
    acc_mul[2] = 1.0f;
    acc_mul[3] = 1.0f;
    acc_rand_type = EFFECT_RAND_NONE;
    acc_rand[0] = 0;
    acc_rand[1] = 0;
    acc_rand[2] = 0;
    acc_rand[3] = 1.0f;
    acc_rand_count = 1;
    move_p1[0] = 0;
    move_p1[1] = 0;
    move_p1[2] = 0;
    move_p1[3] = 1.0f;
    move_p1_rand_type = EFFECT_RAND_NONE;
    move_p1_rand[0] = 0;
    move_p1_rand[1] = 0;
    move_p1_rand[2] = 0;
    move_p1_rand[3] = 1.0f;
    move_p1_rand_count = 1;
    move_p2[0] = 0;
    move_p2[1] = 0;
    move_p2[2] = 0;
    move_p2[3] = 1.0f;
    move_p2_rand_type = EFFECT_RAND_NONE;
    move_p2_rand[0] = 0;
    move_p2_rand[1] = 0;
    move_p2_rand[2] = 0;
    move_p2_rand[3] = 1.0f;
    move_p2_rand_count = 1;
    scale_type.x = EFFECT_CHANGE_NONE;
    scale_type.y = EFFECT_CHANGE_NONE;
    scale_type.z = EFFECT_CHANGE_NONE;
    scale[0] = 1.0f;
    scale[1] = 1.0f;
    scale[2] = 1.0f;
    scale[3] = 1.0f;
    scale_rand_type = EFFECT_RAND_NONE;
    scale_rand[0] = 0;
    scale_rand[1] = 0;
    scale_rand[2] = 0;
    scale_rand[3] = 1.0f;
    scale_rand_count = 1;
    svelo[0] = 0;
    svelo[1] = 0;
    svelo[2] = 0;
    svelo[3] = 1.0f;
    svelo_rand_type = EFFECT_RAND_NONE;
    svelo_rand[0] = 0;
    svelo_rand[1] = 0;
    svelo_rand[2] = 0;
    svelo_rand[3] = 1.0f;
    svelo_rand_count = 1;
    scale_p1[0] = 0;
    scale_p1[1] = 0;
    scale_p1[2] = 0;
    scale_p1[3] = 1.0f;
    scale_p1_rand_type = EFFECT_RAND_NONE;
    scale_p1_rand[0] = 0;
    scale_p1_rand[1] = 0;
    scale_p1_rand[2] = 0;
    scale_p1_rand[3] = 1.0f;
    scale_p1_rand_count = 1;
    scale_p2[0] = 0;
    scale_p2[1] = 0;
    scale_p2[2] = 0;
    scale_p2[3] = 1.0f;
    scale_p2_rand_type = EFFECT_RAND_NONE;
    scale_p2_rand[0] = 0;
    scale_p2_rand[1] = 0;
    scale_p2_rand[2] = 0;
    scale_p2_rand[3] = 1.0f;
    scale_p2_rand_count = 1;
    alpha_type = EFFECT_CHANGE_NONE;
    alpha_blend = EFFECT_ALPHA_BLEND_ADD;
    alpha = 1.0f;
    alpha_rand_type = EFFECT_RAND_NONE;
    alpha_rand = 0;
    alpha_rand_count = 1;
    alpha_p1 = 0;
    alpha_p2 = 0;
    alpha_p1_rand_type = EFFECT_RAND_NONE;
    alpha_p2_rand_type = EFFECT_RAND_NONE;
    alpha_p1_rand = 0;
    alpha_p2_rand = 0;
    alpha_p1_rand_count = 1;
    alpha_p2_rand_count = 1;
    tex_rect_num = 0;

    i = 0;

    do {
        tex_rect[i][0] = 0;
        tex_rect[i][1] = 0;
        tex_rect[i][2] = 0;
        tex_rect[i][3] = 0;
        i++;
    } while (i < 8);

    tex_get_type = 0;
    texture = nullptr;
    gravity = 0;
    gravity_pos[0] = 0;
    gravity_pos[1] = 0;
    gravity_pos[2] = 0;
    gravity_pos[3] = 0;
    gravity_accel = 9.80665f;
    gravity_mass = 10.0f;
}

void CEffectCtrl::Run() {
    run = 1;
    repeat_timer = 0;
    repeat_cnt = 0;
}

void CEffectCtrl::SetOrigin(float *origin) {
    sceVu0CopyVector(this->origin, origin);
}

CEffectCtrl &CEffectCtrl::operator=(const CEffectCtrl &other) {
    sceVu0CopyVector((float *) origin, (float *) other.origin);
    run = other.run;
    entry = other.entry;
    repeat = other.repeat;
    repeat_wait = other.repeat_wait;
    repeat_wait_now = other.repeat_wait_now;
    repeat_timer = other.repeat_timer;
    rep_rand_type = other.rep_rand_type;
    rep_rand = other.rep_rand;
    rep_rand_count = other.rep_rand_count;
    repeat_cnt = other.repeat_cnt;
    repeat_num = other.repeat_num;
    num = other.num;
    num_rand_type = other.num_rand_type;
    num_rand = other.num_rand;
    num_rand_count = other.num_rand_count;
    count = other.count;
    cnt_rand_type = other.cnt_rand_type;
    cnt_rand = other.cnt_rand;
    cnt_rand_count = other.cnt_rand_count;
    width = other.width;
    height = other.height;
    dir = other.dir;
    sceVu0CopyVector((float *) pos, (float *) other.pos);
    pos_rand_type = other.pos_rand_type;
    sceVu0CopyVector((float *) pos_rand, (float *) other.pos_rand);
    pos_rand_count = other.pos_rand_count;
    this->move_type.x = other.move_type.x;
    this->move_type.y = other.move_type.y;
    this->move_type.z = other.move_type.z;
    sceVu0CopyVector((float *) velo, (float *) other.velo);
    sceVu0CopyVector((float *) acc, (float *) other.acc);
    sceVu0CopyVector((float *) velo_mul, (float *) other.velo_mul);
    sceVu0CopyVector((float *) acc_mul, (float *) other.acc_mul);
    sceVu0CopyVector((float *) move_p1, (float *) other.move_p1);
    sceVu0CopyVector((float *) move_p2, (float *) other.move_p2);
    velo_rand_type = other.velo_rand_type;
    acc_rand_type = other.acc_rand_type;
    move_p1_rand_type = other.move_p1_rand_type;
    move_p2_rand_type = other.move_p2_rand_type;
    sceVu0CopyVector((float *) velo_rand, (float *) other.velo_rand);
    sceVu0CopyVector((float *) acc_rand, (float *) other.acc_rand);
    sceVu0CopyVector((float *) move_p1_rand, (float *) other.move_p1_rand);
    sceVu0CopyVector((float *) move_p2_rand, (float *) other.move_p2_rand);
    velo_rand_count = other.velo_rand_count;
    acc_rand_count = other.acc_rand_count;
    move_p1_rand_count = other.move_p1_rand_count;
    move_p2_rand_count = other.move_p2_rand_count;
    this->scale_type.x = other.scale_type.x;
    this->scale_type.y = other.scale_type.y;
    this->scale_type.z = other.scale_type.z;
    sceVu0CopyVector((float *) scale, (float *) other.scale);
    sceVu0CopyVector((float *) svelo, (float *) other.svelo);
    sceVu0CopyVector((float *) scale_p1, (float *) other.scale_p1);
    sceVu0CopyVector((float *) scale_p2, (float *) other.scale_p2);
    scale_rand_type = other.scale_rand_type;
    svelo_rand_type = other.svelo_rand_type;
    scale_p1_rand_type = other.scale_p1_rand_type;
    scale_p2_rand_type = other.scale_p2_rand_type;
    sceVu0CopyVector((float *) scale_rand, (float *) other.scale_rand);
    sceVu0CopyVector((float *) svelo_rand, (float *) other.svelo_rand);
    sceVu0CopyVector((float *) scale_p1_rand, (float *) other.scale_p1_rand);
    sceVu0CopyVector((float *) scale_p2_rand, (float *) other.scale_p2_rand);
    scale_rand_count = other.scale_rand_count;
    svelo_rand_count = other.svelo_rand_count;
    scale_p1_rand_count = other.scale_p1_rand_count;
    scale_p2_rand_count = other.scale_p2_rand_count;
    alpha_blend = other.alpha_blend;
    alpha_type = other.alpha_type;
    alpha = other.alpha;
    alpha_p1 = other.alpha_p1;
    alpha_p2 = other.alpha_p2;
    alpha_rand_type = other.alpha_rand_type;
    alpha_p1_rand_type = other.alpha_p1_rand_type;
    alpha_p2_rand_type = other.alpha_p2_rand_type;
    alpha_rand = other.alpha_rand;
    alpha_p1_rand = other.alpha_p1_rand;
    alpha_p2_rand = other.alpha_p2_rand;
    alpha_rand_count = other.alpha_rand_count;
    alpha_p1_rand_count = other.alpha_p1_rand_count;
    alpha_p2_rand_count = other.alpha_p2_rand_count;
    tex_rect_num = other.tex_rect_num;
    dc2::memory::CopyTrackedBytes(tex_rect, other.tex_rect, sizeof(tex_rect));
    texture = other.texture;
    tex_get_type = other.tex_get_type;
    gravity = other.gravity;
    sceVu0CopyVector((float *) gravity_pos, (float *) other.gravity_pos);
    gravity_accel = other.gravity_accel;
    gravity_mass = other.gravity_mass;
    return *this;
}

namespace {
/**
 *
 * Validates every numeric tag argument before a handler changes an emitter.
 *
 */
void RequireNumericArguments(dc2::script::TagArguments args, std::string_view kinds) {
    for (std::size_t index = 0; index < kinds.size(); ++index) {
        if (kinds[index] == 'i') {
            (void) dc2::script::TagInteger(args + index);
        } else {
            (void) dc2::script::TagFloat(args + index);
        }
    }
}
} // namespace

/**
 *
 * Sets particle width and height.
 *
 */
int __SIZE(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ff");
    g_tmp_effc->width = dc2::script::TagFloat(args++);
    g_tmp_effc->height = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Sets the particle direction mode.
 *
 */
int __DIR(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "i");
    g_tmp_effc->dir = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the number of particles emitted.
 *
 */
int __NUM(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "i");
    g_tmp_effc->num = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Configures particle count variation.
 *
 */
int __NUM_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifi");
    g_tmp_effc->num_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->num_rand = dc2::script::TagFloat(args++);
    g_tmp_effc->num_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the effect controller count.
 *
 */
int __COUNT(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "i");
    g_tmp_effc->count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Configures effect controller count variation.
 *
 */
int __CNT_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifi");
    g_tmp_effc->cnt_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->cnt_rand = dc2::script::TagFloat(args++);
    g_tmp_effc->cnt_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the effect repetition count and wait interval.
 *
 */
int __REPEAT(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "iiii");
    g_tmp_effc->repeat = dc2::script::TagInteger(args++);

    g_tmp_effc->repeat_wait_now = dc2::script::TagInteger(args);
    g_tmp_effc->repeat_wait = dc2::script::TagInteger(args++);
    g_tmp_effc->repeat_num = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Configures repetition variation.
 *
 */
int __REP_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifi");
    g_tmp_effc->rep_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->rep_rand = dc2::script::TagFloat(args++);
    g_tmp_effc->rep_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the particle origin.
 *
 */
int __POS(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "fff");
    g_tmp_effc->pos[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->pos[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->pos[2] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures particle origin variation.
 *
 */
int __POS_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifffi");
    g_tmp_effc->pos_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->pos_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->pos_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->pos_rand[2] = dc2::script::TagFloat(args++);
    g_tmp_effc->pos_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the initial particle velocity.
 *
 */
int __VELO(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "fff");
    g_tmp_effc->velo[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->velo[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->velo[2] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures initial velocity variation.
 *
 */
int __VELO_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifffi");
    g_tmp_effc->velo_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->velo_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->velo_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->velo_rand[2] = dc2::script::TagFloat(args++);
    g_tmp_effc->velo_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the particle velocity multipliers.
 *
 */
int __VELO_MUL(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "fff");
    g_tmp_effc->velo_mul[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->velo_mul[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->velo_mul[2] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Sets particle acceleration.
 *
 */
int __ACC(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "fff");
    g_tmp_effc->acc[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->acc[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->acc[2] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures particle acceleration variation.
 *
 */
int __ACC_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifffi");
    g_tmp_effc->acc_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->acc_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->acc_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->acc_rand[2] = dc2::script::TagFloat(args++);
    g_tmp_effc->acc_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the particle acceleration multipliers.
 *
 */
int __ACC_MUL(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "fff");
    g_tmp_effc->acc_mul[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->acc_mul[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->acc_mul[2] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Sets the change mode for particle movement on each axis.
 *
 */
int __MOVE_TYPE(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "iii");
    g_tmp_effc->move_type.x = (EFFECT_CHANGE_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->move_type.y = (EFFECT_CHANGE_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->move_type.z = (EFFECT_CHANGE_TYPE) dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the first particle movement parameters.
 *
 */
int __MOVE_P1(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "fff");
    g_tmp_effc->move_p1[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p1[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p1[2] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures variation of the first movement parameters.
 *
 */
int __MOVE_P1_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifffi");
    g_tmp_effc->move_p1_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->move_p1_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p1_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p1_rand[2] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p1_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the second particle movement parameters.
 *
 */
int __MOVE_P2(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "fff");
    g_tmp_effc->move_p2[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p2[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p2[2] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures variation of the second movement parameters.
 *
 */
int __MOVE_P2_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifffi");
    g_tmp_effc->move_p2_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->move_p2_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p2_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p2_rand[2] = dc2::script::TagFloat(args++);
    g_tmp_effc->move_p2_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the change mode for particle scale.
 *
 */
int __SCALE_TYPE(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ii");
    g_tmp_effc->scale_type.x = (EFFECT_CHANGE_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->scale_type.y = (EFFECT_CHANGE_TYPE) dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the initial particle scale.
 *
 */
int __SCALE(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ff");
    g_tmp_effc->scale[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale[1] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures initial particle scale variation.
 *
 */
int __SCALE_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "iffi");
    g_tmp_effc->scale_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->scale_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets particle scale velocity.
 *
 */
int __SVELO(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ff");
    g_tmp_effc->svelo[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->svelo[1] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures scale velocity variation.
 *
 */
int __SVELO_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "iffi");
    g_tmp_effc->svelo_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->svelo_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->svelo_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->svelo_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the first particle scale parameters.
 *
 */
int __SCALE_P1(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ff");
    g_tmp_effc->scale_p1[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale_p1[1] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures variation of the first scale parameters.
 *
 */
int __SCALE_P1_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "iffi");
    g_tmp_effc->scale_p1_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->scale_p1_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale_p1_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale_p1_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the second particle scale parameters.
 *
 */
int __SCALE_P2(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ff");
    g_tmp_effc->scale_p2[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale_p2[1] = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures variation of the second scale parameters.
 *
 */
int __SCALE_P2_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "iffi");
    g_tmp_effc->scale_p2_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->scale_p2_rand[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale_p2_rand[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->scale_p2_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the particle alpha blend mode.
 *
 */
int __ALPHA_BLEND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "i");
    g_tmp_effc->alpha_blend = (EFFECT_ALPHA_BLEND) dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the change mode for particle alpha.
 *
 */
int __ALPHA_TYPE(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "i");
    g_tmp_effc->alpha_type = (EFFECT_CHANGE_TYPE) dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the initial particle alpha.
 *
 */
int __ALPHA(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "f");
    g_tmp_effc->alpha = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures initial particle alpha variation.
 *
 */
int __ALPHA_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifi");
    g_tmp_effc->alpha_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->alpha_rand = dc2::script::TagFloat(args++);
    g_tmp_effc->alpha_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the first particle alpha parameter.
 *
 */
int __ALPHA_P1(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "f");
    g_tmp_effc->alpha_p1 = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures variation of the first alpha parameter.
 *
 */
int __ALPHA_P1_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifi");
    g_tmp_effc->alpha_p1_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->alpha_p1_rand = dc2::script::TagFloat(args++);
    g_tmp_effc->alpha_p1_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the second particle alpha parameter.
 *
 */
int __ALPHA_P2(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "f");
    g_tmp_effc->alpha_p2 = dc2::script::TagFloat(args);
    return 1;
}

/**
 *
 * Configures variation of the second alpha parameter.
 *
 */
int __ALPHA_P2_RAND(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "ifi");
    g_tmp_effc->alpha_p2_rand_type = (EFFECT_RAND_TYPE) dc2::script::TagInteger(args++);
    g_tmp_effc->alpha_p2_rand = dc2::script::TagFloat(args++);
    g_tmp_effc->alpha_p2_rand_count = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Sets the particle texture selection mode.
 *
 */
int __TEX_GET_TYPE(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "i");
    g_tmp_effc->tex_get_type = dc2::script::TagInteger(args);
    return 1;
}

/**
 *
 * Resolves the texture used by the current effect.
 *
 */
int __TEX_NAME(dc2::script::TagArguments args) {
    char *name = dc2::script::TagCString(args);
    g_tmp_effc->texture = mgTexManager.GetTexture(name, -1);
    return 1;
}

/**
 *
 * Enables gravity with an origin, acceleration, and mass.
 *
 */
int __GRAVITY(dc2::script::TagArguments args) {
    RequireNumericArguments(args, "fffff");
    g_tmp_effc->gravity_pos[0] = dc2::script::TagFloat(args++);
    g_tmp_effc->gravity_pos[1] = dc2::script::TagFloat(args++);
    g_tmp_effc->gravity_pos[2] = dc2::script::TagFloat(args++);
    g_tmp_effc->gravity_accel = dc2::script::TagFloat(args++);
    g_tmp_effc->gravity_mass = dc2::script::TagFloat(args);
    g_tmp_effc->gravity = 1;
    return 1;
}

namespace {
int BufferSize(dc2::script::TagArguments args, int unused);
int EffectStart(dc2::script::TagArguments args, int unused);
int EffectEnd(dc2::script::TagArguments unused_args, int unused);
int WaitFrame(dc2::script::TagArguments args, int unused);
int ImageName(dc2::script::TagArguments args, int unused);
int TextureRects(dc2::script::TagArguments args, int unused);
} // namespace

/**
 *
 * Effect-script tags and their argument handlers.
 *
 */
static SPI_TAG_PARAM effm_tag[48] = {
    {"BUFFER_SIZE",   dc2::script::AdaptTagArguments<BufferSize>     },
    {"EFFECT_START",  dc2::script::AdaptTagArguments<EffectStart>    },
    {"EFFECT_END",    dc2::script::AdaptTagArguments<EffectEnd>      },
    {"WAIT_FRAME",    dc2::script::AdaptTagArguments<WaitFrame>      },
    {"IMG_NAME",      dc2::script::AdaptTagArguments<ImageName>      },
    {"SIZE",          dc2::script::AdaptTagArguments<__SIZE>         },
    {"DIR",           dc2::script::AdaptTagArguments<__DIR>          },
    {"NUM",           dc2::script::AdaptTagArguments<__NUM>          },
    {"NUM_RAND",      dc2::script::AdaptTagArguments<__NUM_RAND>     },
    {"COUNT",         dc2::script::AdaptTagArguments<__COUNT>        },
    {"CNT_RAND",      dc2::script::AdaptTagArguments<__CNT_RAND>     },
    {"REPEAT",        dc2::script::AdaptTagArguments<__REPEAT>       },
    {"__REP_RAND",    dc2::script::AdaptTagArguments<__REP_RAND>     },
    {"POS",           dc2::script::AdaptTagArguments<__POS>          },
    {"POS_RAND",      dc2::script::AdaptTagArguments<__POS_RAND>     },
    {"VELO",          dc2::script::AdaptTagArguments<__VELO>         },
    {"VELO_RAND",     dc2::script::AdaptTagArguments<__VELO_RAND>    },
    {"VELO_MUL",      dc2::script::AdaptTagArguments<__VELO_MUL>     },
    {"ACC",           dc2::script::AdaptTagArguments<__ACC>          },
    {"ACC_RAND",      dc2::script::AdaptTagArguments<__ACC_RAND>     },
    {"ACC_MUL",       dc2::script::AdaptTagArguments<__ACC_MUL>      },
    {"MOVE_TYPE",     dc2::script::AdaptTagArguments<__MOVE_TYPE>    },
    {"MOVE_P1",       dc2::script::AdaptTagArguments<__MOVE_P1>      },
    {"MOVE_P1_RAND",  dc2::script::AdaptTagArguments<__MOVE_P1_RAND> },
    {"MOVE_P2",       dc2::script::AdaptTagArguments<__MOVE_P2>      },
    {"MOVE_P2_RAND",  dc2::script::AdaptTagArguments<__MOVE_P2_RAND> },
    {"SCALE_TYPE",    dc2::script::AdaptTagArguments<__SCALE_TYPE>   },
    {"SCALE",         dc2::script::AdaptTagArguments<__SCALE>        },
    {"SCALE_RAND",    dc2::script::AdaptTagArguments<__SCALE_RAND>   },
    {"SVELO",         dc2::script::AdaptTagArguments<__SVELO>        },
    {"SVELO_RAND",    dc2::script::AdaptTagArguments<__SVELO_RAND>   },
    {"SCALE_P1",      dc2::script::AdaptTagArguments<__SCALE_P1>     },
    {"SCALE_P1_RAND", dc2::script::AdaptTagArguments<__SCALE_P1_RAND>},
    {"SCALE_P2",      dc2::script::AdaptTagArguments<__SCALE_P2>     },
    {"SCALE_P2_RAND", dc2::script::AdaptTagArguments<__SCALE_P2_RAND>},
    {"ALPHA_BLEND",   dc2::script::AdaptTagArguments<__ALPHA_BLEND>  },
    {"ALPHA_TYPE",    dc2::script::AdaptTagArguments<__ALPHA_TYPE>   },
    {"ALPHA",         dc2::script::AdaptTagArguments<__ALPHA>        },
    {"ALPHA_RAND",    dc2::script::AdaptTagArguments<__ALPHA_RAND>   },
    {"ALPHA_P1",      dc2::script::AdaptTagArguments<__ALPHA_P1>     },
    {"ALPHA_P1_RAND", dc2::script::AdaptTagArguments<__ALPHA_P1_RAND>},
    {"ALPHA_P2",      dc2::script::AdaptTagArguments<__ALPHA_P2>     },
    {"ALPHA_P2_RAND", dc2::script::AdaptTagArguments<__ALPHA_P2_RAND>},
    {"TEX_GET_RECT",  dc2::script::AdaptTagArguments<TextureRects>   },
    {"TEX_GET_TYPE",  dc2::script::AdaptTagArguments<__TEX_GET_TYPE> },
    {"TEX_NAME",      dc2::script::AdaptTagArguments<__TEX_NAME>     },
    {"GRAVITY",       dc2::script::AdaptTagArguments<__GRAVITY>      },
    {nullptr,         nullptr                                        },
};

CEffectManager::CEffectManager() {
    EntryEffCtrls(nullptr, 0, nullptr, 0);
    Initialize();
    name[0] = 0;
}

void CEffectManager::Initialize() {
    int i = {};

    load = 0;
    ctrl_index = -1;
    run = 0;
    wait_count = 0;
    next_ctrl = 0;

    for (i = 0; i < 8; i++) {
        wait_frame[i] = 0;
        ctrl_name[i][0] = '\0';
    }

    for (i = 0; i < ctrl_num; i++) {
        ctrls[i].Initialize();
    }

    img_name[0] = '\0';
}

void CEffectManager::EntryEffCtrls(CEffect *effects, int effect_num, CEffectCtrl *ctrls,
                                   int ctrl_num) {
    this->effects = effects;
    this->effect_num = effect_num;
    this->ctrls = ctrls;
    this->ctrl_num = std::clamp(ctrl_num, 0, static_cast<int>(std::size(ctrl_name)));
}

void CEffectManager::SetEffectNums(int particle_count, int emitter_count) {
    effect_num = particle_count;
    ctrl_num = std::clamp(emitter_count, 0, static_cast<int>(std::size(ctrl_name)));
}

void CEffectManager::Ctrl() {
    CEffectCtrl *ctrl = {};

    if (run == 0 || ctrls == nullptr) {
        return;
    }

    if (ctrl_index == -1) {
        if (wait_count != 0x7FFFFFFF) {
            wait_count++;
        }

        if (next_ctrl < ctrl_num && wait_frame[next_ctrl] < wait_count) {
            ctrl = ctrls + next_ctrl;

            if (ctrl->entry != 0) {
                ctrl->Run();
            }

            next_ctrl++;
            wait_count = 0;
        }
    } else if (next_ctrl == 0) {
        ctrl = ctrls + ctrl_index;

        if (ctrl->entry != 0) {
            ctrl->Run();
        }

        next_ctrl = 1;
    }
}

void CEffectManager::Step(int frames) {
    int i = {};

    if (ctrls == nullptr || effects == nullptr) {
        return;
    }

    for (i = 0; i < ctrl_num; i++) {
        if (ctrls[i].entry != 0) {
            ctrls[i].Ctrl(effects, effect_num);
        }
    }

    for (i = 0; i < effect_num; i++) {
        effects[i].Step(1);
    }
}

void CEffectManager::Draw() {
    int i = {};

    if (effects != nullptr) {
        for (i = 0; i < effect_num; i++) {
            effects[i].Draw();
        }
    }
}

void CEffectManager::Run() {
    if (ctrls == nullptr || effects == nullptr) {
        return;
    }

    run = 1;
    wait_count = 0;
    next_ctrl = 0;
}

void CEffectManager::Stop() {
    int i = {};

    run = 0;
    wait_count = 0;
    next_ctrl = 0;

    if (ctrls != nullptr) {
        for (i = 0; i < ctrl_num; i++) {
            if (ctrls[i].entry != 0) {
                ctrls[i].run = 0;
            }
        }
    }
}

int CEffectManager::EnterEffectCtrl(CEffectCtrl ctrl, char *name) {
    int i = {};

    if (ctrls == nullptr) {
        return 1;
    }

    for (i = 0; i < ctrl_num && i < static_cast<int>(std::size(ctrl_name)); i++) {
        if (ctrls[i].entry == 0) {
            CEffectCtrl *slot = {};

            ctrls[i] = ctrl;
            dc2::text::Copy(ctrl_name[i], dc2::text::View(name));

            slot = ctrls + i;
            slot->entry = 1;
            return 0;
        }
    }

    return 1;
}

void CEffectManager::SetOrigin(float *origin) {
    int i = {};

    for (i = 0; i < ctrl_num; i++) {
        if (ctrls[i].entry != 0) {
            ctrls[i].SetOrigin(origin);
        }
    }
}

#include "common.h"

#include <algorithm>
#include <array>
#include <cstddef>
#include <memory>
#include <string_view>
#include <utility>

#include "command_replay.hpp"
#include "effect.hpp"
#include "scriptinterpreter.hpp"
#include "text/bounded.hpp"

namespace {

/**
 *
 * Emitter between an EFFECT_START tag and its EFFECT_END, owned by the loader.
 *
 */
std::unique_ptr<CEffectCtrl> open_emitter;

/**
 *
 * Takes the settings of tags written outside an EFFECT_START block, which retail wrote through a null emitter.
 *
 */
CEffectCtrl &DiscardEmitter() {
    static CEffectCtrl emitter;
    return emitter;
}

/**
 *
 * Owns one effect definition's temporary emitter and restores an enclosing parser context.
 *
 */
class EffectScriptScope {
    CEffectManager                          *previous_manager;    /**< Manager of the enclosing definition. */
    CEffectCtrl                             *previous_controller; /**< Emitter selected by the enclosing definition. */
    int                                      previous_entry;      /**< Whether the enclosing definition publishes emitters. */
    std::array<char, sizeof(g_tmp_eff_name)> previous_name{};     /**< Name of the enclosing emitter. */
    std::unique_ptr<CEffectCtrl>             previous_emitter;    /**< Owned emitter suspended by this nested definition. */
    CEffectCtrl                              previous_discard;    /**< Scratch settings ignored outside an enclosing emitter. */
public:
    /**
     *
     * Saves the enclosing parser state and begins an empty definition context.
     *
     */
    explicit EffectScriptScope(CEffectManager &manager, int entry)
        : previous_manager(g_tmp_effm), previous_controller(g_tmp_effc), previous_entry(g_eff_entry_flag),
          previous_emitter(std::move(open_emitter)), previous_discard(DiscardEmitter()) {
        std::ranges::copy(g_tmp_eff_name, previous_name.begin());
        g_tmp_effm = &manager;
        g_tmp_effc = &DiscardEmitter();
        g_eff_entry_flag = entry;
        g_tmp_eff_name[0] = char{};
    }

    EffectScriptScope(const EffectScriptScope &) = delete;
    EffectScriptScope &operator=(const EffectScriptScope &) = delete;
    EffectScriptScope(EffectScriptScope &&) = delete;
    EffectScriptScope &operator=(EffectScriptScope &&) = delete;

    /**
     *
     * Releases this definition's emitter and restores every enclosing scratch value.
     *
     */
    ~EffectScriptScope() {
        open_emitter = std::move(previous_emitter);
        DiscardEmitter() = previous_discard;
        g_tmp_effm = previous_manager;
        g_tmp_effc = previous_controller;
        g_eff_entry_flag = previous_entry;
        std::ranges::copy(previous_name, std::begin(g_tmp_eff_name));
    }
};

/**
 *
 * Reads one finite numeric effect argument within the initialized slot extent.
 *
 */
int IntArgument(dc2::script::TagArguments args, int index) {
    return dc2::script::TagInteger(args + static_cast<std::size_t>(index));
}

/**
 *
 * Reads one string within its live script or converted command allocation.
 *
 */
std::string_view TextArgument(dc2::script::TagArguments args, int index) {
    return dc2::script::TagText(args + static_cast<std::size_t>(index));
}

/**
 *
 * Sets the particle and emitter pools, holding the emitters to the manager's per-emitter tables.
 *
 */
int BufferSize(dc2::script::TagArguments args, int /*unused*/) {
    const int particles = std::max(IntArgument(args, 0), 0);
    const int emitters = std::clamp(IntArgument(args, 1), 0, static_cast<int>(std::size(g_tmp_effm->wait_frame)));
    g_tmp_effm->SetEffectNums(particles, emitters);
    return 1;
}

/**
 *
 * Opens a named emitter definition, discarding one left open by a missing EFFECT_END.
 *
 */
int EffectStart(dc2::script::TagArguments args, int /*unused*/) {
    dc2::text::Copy(g_tmp_eff_name, TextArgument(args, 0));
    open_emitter = std::make_unique<CEffectCtrl>();
    g_tmp_effc = open_emitter.get();
    return 1;
}

/**
 *
 * Enters the open emitter into the manager when loading, and closes it.
 *
 */
int EffectEnd(dc2::script::TagArguments /*unused*/, int /*unused*/) {
    if (open_emitter != nullptr && g_eff_entry_flag != 0) {
        g_tmp_effm->EnterEffectCtrl(*open_emitter, g_tmp_eff_name);
    }
    open_emitter.reset();
    g_tmp_effc = &DiscardEmitter();
    return 1;
}

/**
 *
 * Sets the start delay of one of the manager's emitters.
 *
 */
int WaitFrame(dc2::script::TagArguments args, int /*unused*/) {
    const int index = IntArgument(args, 0);
    if (index >= 0 && std::cmp_less(index, std::size(g_tmp_effm->wait_frame))) {
        g_tmp_effm->wait_frame[index] = IntArgument(args, 1);
    }
    return 1;
}

/**
 *
 * Names the texture archive the effect needs.
 *
 */
int ImageName(dc2::script::TagArguments args, int /*unused*/) {
    dc2::text::Copy(g_tmp_effm->img_name, TextArgument(args, 0));
    return 1;
}

/**
 *
 * Reads the open emitter's texture rectangles, no more than it has room for.
 *
 */
int TextureRects(dc2::script::TagArguments args, int /*unused*/) {
    decltype(g_tmp_effc->tex_rect) rectangles;
    std::memcpy(rectangles, g_tmp_effc->tex_rect, sizeof rectangles);
    const int count = std::clamp(IntArgument(args, 0), 0, static_cast<int>(std::size(rectangles)));
    for (int row = 0; row < count; ++row) {
        for (std::size_t column = 0; column < std::size(rectangles[row]); ++column) {
            rectangles[row][column] = IntArgument(args, 1 + row * static_cast<int>(std::size(rectangles[row])) + static_cast<int>(column));
        }
    }
    std::memcpy(g_tmp_effc->tex_rect, rectangles, sizeof rectangles);
    g_tmp_effc->tex_rect_num = count;
    return 1;
}

/**
 *
 * Runs an effect script against a manager, entering its emitters when entry is set.
 *
 */
void RunEffectScript(CEffectManager &manager, char *script, int size, int entry) {
    EffectScriptScope  scope(manager, entry);
    CScriptInterpreter interpreter;
    // Character effect scripts embedded in .game.json resources are typed command lists.
    if (command_replay::IsCommandBuffer(script, size)) {
        command_replay::RunBuffer(script, size, effm_tag);
    } else {
        interpreter.SetTag(effm_tag);
        interpreter.SetScript(script, size);
        interpreter.Run();
    }
}

} // namespace

// Retail allocates each emitter with new and frees it at EFFECT_END, leaking one left open, and its
// handlers index the manager's eight-entry tables and copy names without bounds.
void CEffectManager::GetBufferNums(char *script, int size, int *effect_num, int *ctrl_num) {
    RunEffectScript(*this, script, size, 0);
    *effect_num = this->effect_num;
    *ctrl_num = this->ctrl_num;
}

void CEffectManager::Load(char *script, int size) {
    RunEffectScript(*this, script, size, 1);
    load = 1;
}
