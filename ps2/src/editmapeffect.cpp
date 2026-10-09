#include "common.h"

#include "editmapeffect.hpp"
#include "effectlist.hpp"
#include "funcpoint.hpp"
#include "mg_math.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

// Code (.text)
void CEditMap::DrawFireEffect(int tex_block) {
    CMap::DrawFireEffect(tex_block);
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *) NULL);
    mgCTexture   *fire_texture = mgTexManager.GetTexture("fire_wrk", tex_block);
    mgCTexture   *light_texture = mgTexManager.GetTexture("lightling", tex_block);
    sceVu0FMATRIX matrix;
    mgUnitMatrix(matrix);
    CEditParts *part = edit_parts;
    mgDrawDirectStart();

    for (int index = 0; index < edit_parts_max; ++index, ++part) {
        if (part->func_point_mngr.flag & FUNC_POINT_MNGR_BURN) {
            int unnamed = part->name[0] == 0;

            if (unnamed == 0 && part->state != 0) {
                part->GetLWMatrix(matrix);
                ::DrawFireEffect(matrix, &part->func_point_mngr, &check, 1.0f, fire_texture, light_texture);
            }
        }
    }

    mgDrawDirectEnd();
}

void CEditMap::DrawFireRaster() {
    CMap::DrawFireRaster();
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    sceVu0FMATRIX matrix;
    mgUnitMatrix(matrix);
    CEditParts *part = edit_parts;

    for (int index = 0; index < edit_parts_max; ++index, ++part) {
        int unnamed = part->name[0] == 0;

        if (unnamed == 0 && part->state != 0) {
            part->GetLWMatrix(matrix);
            ::DrawFireRaster(matrix, &part->func_point_mngr, &check, fire_raster);
        }
    }
}

void CEditMap::DrawEffect() {
    GetNowTime();
    CMap::DrawEffect();
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    static mgCFrameAttr attr;
    attr.no_cull = 1;
    attr.draw = 3;
    attr.depth_bias = 1.015f;
    attr.fog = 2;

    CEditParts *part = edit_parts;

    for (int index = 0; index < edit_parts_max; ++index, ++part) {
        int unnamed = part->name[0] == 0;

        if (unnamed != 0 || part->state == 0) {
            continue;
        }

        part->func_point_mngr.GetStart(FUNC_POINT_EFFECT);
        CFuncPoint *point;

        while ((point = part->func_point_mngr.Get()) != NULL) {
            if (point->Check(&check) != 0) {
                point->frame.SetReference(&part->frame);
                point->frame.SetVisual(effect_list.GetEffectVisual(point->effect.index));
                point->frame.attr = &attr;
                mgDrawDirect(&point->frame);
                point->frame.DeleteReference();
            }
        }
    }
}

void CEditMap::AnimeStep(CObjAnimeEnv *env) {
    CMap::AnimeStep(env);
    CFuncPointCheck check;
    CreateFuncCheck(&check);

    for (int index = 0; index < edit_parts_max; ++index) {
        CEditParts &part = edit_parts[index];

        for (CList<CObjAnime> *node = part.anime_list; node != NULL; node = node->next) {
            CObjAnime &animation = node->data;

            if (animation.func_point != NULL && animation.func_point->Check(&check) != 0) {
                animation.Step(env);
            }
        }
    }

    if (balance_moved != 0) {
        int settled = 1;

        for (int index = 0; index < EDIT_MAP_BALANCE_MAX; ++index) {
            float difference = balance_pos[index][1] - balance_base_pos[index][1];
            balance_base_pos[index][1] += difference / 4.0f;

            if (difference < 0.0f) {
                difference = -difference;
            }

            if (difference > 0.1f) {
                settled = 0;
            }
        }

        if (settled) {
            balance_moved = 1;
        }
    }
}
