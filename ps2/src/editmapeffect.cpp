#include "common.h"
#include "editmapeffect.hpp"
#include "effectlist.hpp"
#include "funcpoint.hpp"
#include "mg_math.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

// Code (.text)
#ifdef NONMATCHING
void CEditMap::DrawFireEffect(int tex_block) {
    CMap::DrawFireEffect(tex_block);
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *)NULL);
    mgCTexture *fire_texture = mgTexManager.GetTexture("fire_wrk", tex_block);
    mgCTexture *light_texture = mgTexManager.GetTexture("lightling", tex_block);
    sceVu0FMATRIX matrix;
    mgUnitMatrix(matrix);
    mgDrawDirectStart();
    for (int index = 0; index < edit_parts_max; ++index) {
        CEditParts &part = edit_parts[index];
        if ((part.func_point_mngr.flag & FUNC_POINT_MNGR_BURN) && part.name[0] != '\0' && part.state != 0) {
            part.GetLWMatrix(matrix);
            ::DrawFireEffect(matrix, &part.func_point_mngr, &check, 1.0f, fire_texture, light_texture);
        }
    }
    mgDrawDirectEnd();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmapeffect", DrawFireEffect__8CEditMapFi);
#endif
#ifdef NONMATCHING
void CEditMap::DrawFireRaster() {
    CMap::DrawFireRaster();
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    sceVu0FMATRIX matrix;
    mgUnitMatrix(matrix);
    for (int index = 0; index < edit_parts_max; ++index) {
        CEditParts &part = edit_parts[index];
        if (part.name[0] != '\0' && part.state != 0) {
            part.GetLWMatrix(matrix);
            ::DrawFireRaster(matrix, &part.func_point_mngr, &check, fire_raster);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmapeffect", DrawFireRaster__8CEditMapFv);
#endif
#ifdef NONMATCHING
void CEditMap::DrawEffect() {
    GetNowTime();
    CMap::DrawEffect();
    CFuncPointCheck check;
    CreateFuncCheck(&check);
    static mgCFrameAttr effect_attr;
    effect_attr.no_light = 1;
    effect_attr.fog = 3;
    effect_attr.depth_bias = 1.015f;
    effect_attr.no_cull = 2;

    for (int index = 0; index < edit_parts_max; ++index) {
        CEditParts &part = edit_parts[index];
        if (part.name[0] == '\0' || part.state == 0) {
            continue;
        }
        part.func_point_mngr.GetStart(FUNC_POINT_EFFECT);
        for (CFuncPoint *point = part.func_point_mngr.Get(); point != NULL; point = part.func_point_mngr.Get()) {
            if (point->Check(&check) != 0) {
                point->frame.SetReference(&part.frame);
                point->frame.SetVisual(effect_list.GetEffectVisual(point->effect.index));
                point->frame.attr = &effect_attr;
                mgDrawDirect(&point->frame);
                point->frame.DeleteReference();
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmapeffect", DrawEffect__8CEditMapFv);
#endif
#ifdef NONMATCHING
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
        bool settled = true;
        for (int index = 0; index < EDIT_MAP_BALANCE_MAX; ++index) {
            float difference = balance_pos[index][1] - balance_base_pos[index][1];
            balance_base_pos[index][1] += difference / 4.0f;
            if (difference < 0.0f) {
                difference = -difference;
            }
            if (difference > 0.1f) {
                settled = false;
            }
        }
        if (settled) {
            balance_moved = 1;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmapeffect", AnimeStep__8CEditMapFP12CObjAnimeEnv);
#endif

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmapeffect", at_358__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmapeffect", at_359__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(init_379, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(attr_378, 0x90);
