#include "common.h"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_tanime.hpp"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scriptinterpreter.hpp"

extern "C" {
/**
 *
 * Tags of the texture animation script and the handlers they call.
 *
 */
extern SPI_TAG_PARAM tex_tag[];
/** Default bug_patch of a newly initialised record. */
extern int mgBugPatch;
/** Texture animation of the texture block the script is entering records into. */
extern mgCTextureAnime *pTexAnime;
/** Texture animation the script enters every record into, or NULL to use each block's own. */
extern mgCTextureAnime *pLoadTexAnime;
/** Group the script is entering records into, or -1 for none yet. */
extern int now_group;
/** Texture manager the script looks textures up in. */
extern mgCTextureManager *TexManager;
/** Memory the script allocates records, players and names from. */
extern mgCMemory *TexAnimeStack;
/** Name of the group the script is entering records into. */
extern char *group_name;
/** Non-zero when the group the script is entering plays from the start. */
extern int ta_enable;
/** Texture block of the textures named by the current record, or -1 before the first. */
extern int now_texb;
/** Non-zero once the script has asked for exact record timing. */
extern int texBugPatch;
/** Record the script is building. */
static mgCTexAnimeData nowTexData;
}

extern char at_873[];
extern "C" int fptosi(float);
// Code (.text)
#pragma schedule off
mgCTexAnimeData::mgCTexAnimeData() {
    Initialize();
}

void mgCTexAnimeData::Initialize() {
    type = MG_TEX_ANIME_TYPE_NONE;
    group = 0;
    wait = 0;
    clut_copy = 0;
    dest_tex = NULL;
    src_tex = NULL;
    src_h = 0;
    src_w = 0;
    src_y = 0;
    src_x = 0;
    dest_y = 0;
    dest_x = 0;
    phase_y = 0;
    phase_x = 0;
    period_y = 0;
    period_x = 0;
    // amplitude_y is left as it was.
    amplitude_x = 0;
    amplitude_x = 0;
    link_group = -1;
    bilinear = 1;
    alpha_blend = MG_TEX_ANIME_ALPHA_BLEND_OFF;
    alpha_test = MG_TEX_ANIME_ALPHA_TEST_OFF;
    alpha_ref = 0;
    bug_patch = mgBugPatch;
    a = 0x80;
    b = 0x80;
    g = 0x80;
    r = 0x80;
}

#ifdef NONMATCHING
#pragma global_optimizer off
#pragma divbyzerocheck on
void mgCTextureAnime::TexAnime(int texb, sceVif1Packet *packet) {
    int i;
    int group;
    int src_left;
    int src_top;
    int dest_left;
    int dest_top;
    int offset;
    CList<mgCTexAnimeData> *node;
    int src_end;
    int src_bottom_end;
    CList<mgCTexAnimeData> **current;

    if (packet == NULL) {
        packet = mgVif1Packet;
    }

    sceVif1PkCnt(packet, 0);
    sceVif1PkOpenDirectCode(packet, 0);
    sceVif1PkOpenGifTag(packet, *(u_long128 *) &mgGiftagAD);
    sceVif1PkAddGsAD(packet, SCE_GS_TEXFLUSH, 0);
    // TA0 = TA1 = 0x80: alpha of 24-bit and 16-bit texels.
    sceVif1PkAddGsAD(packet, SCE_GS_TEXA, 0x80 | ((u_long) 0x80 << 32));
    sceVif1PkCloseGifTag(packet);
    sceVif1PkCloseDirectCode(packet);

    for (i = 0; i < group_num; i++) {
        if (*(int *)((i << 2) + (int)this + 4) != 0) {
            CList<mgCTexAnimeData> *node = *(CList<mgCTexAnimeData> **)((i << 2) + (int)this + 0xC4);
            if (node != NULL) {
                mgCTexAnimeData *data = node->pGetData();
                if (data != NULL && data->link_group >= 0) {
                    Enable(data->link_group);
                }
            }
        }
    }

    mgCDrawEnv draw_env;
    draw_env.Initialize(0);

    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.DepthTest(MG_DEPTH_TEST_ALWAYS);
    prim.TextureMapEnable(1);

    for (group = 0; group < group_num; group++) {
        offset = group << 2;
        if (*(int *)(offset + (int)this + 4) == 0) {
            continue;
        }

        current = (CList<mgCTexAnimeData> **)(offset + (int)this + 0xC4);
        node = *current;
        if (node == NULL) {
            continue;
        }
        mgCTexAnimeData *data = node->pGetData();
        if (data == NULL || data->src_tex == NULL || data->dest_tex == NULL) {
            continue;
        }
        if (data->src_tex->block != texb || data->dest_tex->block != texb) {
            continue;
        }

        // Records that wait no frames play together with the record after them.
        for (;;) {
            mgRect<int> indexed_src_rect;
            mgRect<int> indexed_dest_rect;
            mgRect<int> colour_src_rect;
            mgRect<int> colour_dest_rect;
            mgRect<int> draw_rect;
            mgRect<int> unused_draw_rect;
            mgRect<int> clut_rect;

            if (data->dest_tex->bpp >= MG_TEX_ANIME_BPP_TRUE_COLOUR) {
                if ((s8)data->bilinear != 0) {
                    prim.Bilinear(1);
                } else {
                    prim.Bilinear(0);
                }
                if ((s8)data->alpha_blend != MG_TEX_ANIME_ALPHA_BLEND_OFF) {
                    prim.AlphaBlendEnable(1);
                    prim.AlphaBlend((s8)data->alpha_blend);
                } else {
                    prim.AlphaBlendEnable(0);
                }
                if (data->alpha_test != MG_TEX_ANIME_ALPHA_TEST_OFF) {
                    prim.AlphaTestEnable(1);
                    prim.AlphaTest(data->alpha_test, data->alpha_ref);
                } else {
                    prim.AlphaTestEnable(0);
                }
            }

            mgCTexture *src = data->src_tex;
            if (src->bpp == MG_TEX_ANIME_BPP_INDEXED && data->dest_tex->bpp == MG_TEX_ANIME_BPP_INDEXED &&
                ((s8)data->clut_copy != 0 || (data->src_w == src->width && data->src_h == src->height))) {
                // Copy the source palette over the destination's, each treated as a 16x16 image.
                sceGsTex0 src_clut;
                sceGsTex0 dest_clut;
                src_clut.TBP0 = src->tex0.CBP;
                src_clut.TBW = 1;
                src_clut.PSM = data->src_tex->tex0.CPSM;
                dest_clut.TBP0 = data->dest_tex->tex0.CBP;
                dest_clut.TBW = 1;
                dest_clut.PSM = data->dest_tex->tex0.CPSM;
                clut_rect.Set(0, 0, 0x100, 0x100);
                mgRect<int> *clut_p = &clut_rect;
                clut_p = clut_p;
                mgSetPkMoveImage(&src_clut, *clut_p, &dest_clut, 0, 0, 0);
            }

            if (data->type == MG_TEX_ANIME_TYPE_COPY) {
                mgCTexture *dest = data->dest_tex;
                dest = dest;
                if (dest->bpp < MG_TEX_ANIME_BPP_TRUE_COLOUR) {
                    mgSetPkMoveImage(&data->src_tex->tex0,
                                     mgRect<int>(data->src_x, data->src_y,
                                                 data->src_x + data->src_w - MG_TEX_ANIME_SUBTEXEL,
                                                 data->src_y + data->src_h - MG_TEX_ANIME_SUBTEXEL),
                                     &data->dest_tex->tex0, data->dest_x, data->dest_y, 0);
                } else {
                    int height = dest->height;
                    int rem = height % MG_TEX_ANIME_FRAME_ALIGN;
                    if (rem != 0) {
                        height += MG_TEX_ANIME_FRAME_ALIGN - rem;
                    }
                    sceGsTex0 *tex = &dest->tex0;
                    mgSetPkFrameBuffer((int)tex->TBP0 / 32, (int)(tex->TBW * 64), height, dest->tex0.PSM);
                    prim.Begin(MG_PRIM_SPRITE);
                    prim.Texture(data->src_tex);
                    prim.Color(data->r, data->g, data->b, data->a);
                    prim.TextureCrd4(data->src_x, data->src_y);
                    prim.Vertex4(data->dest_x, data->dest_y, 0);
                    prim.TextureCrd4(data->src_x + data->src_w, data->src_y + data->src_h);
                    prim.Vertex4(data->dest_x + data->dest_w, data->dest_y + data->dest_h, 0);
                    prim.End();
                    mgSetPkFrameBuffer(-1, -1, -1, -1);
                }
            }

            int type = data->type;
            if (type == MG_TEX_ANIME_TYPE_SCROLL || type == MG_TEX_ANIME_TYPE_WAVE) {
                // The source is split where the scroll or sway has reached and its four
                // quarters are placed crosswise so that the image wraps round.
                int src_split_x;
                int src_split_y;
                int dest_split_x;
                int dest_split_y;
                int src_end_x;
                int src_end_y;
                int dest_end_x;
                int dest_end_y;

                if (data->dest_tex->bpp < MG_TEX_ANIME_BPP_TRUE_COLOUR) {
                    src_left = data->src_x / MG_TEX_ANIME_SUBTEXEL;
                    src_left = src_left;
                    src_top = data->src_y / MG_TEX_ANIME_SUBTEXEL;
                    src_top = src_top;
                    int src_width = data->src_w / MG_TEX_ANIME_SUBTEXEL;
                    int src_height = data->src_h / MG_TEX_ANIME_SUBTEXEL;
                    dest_left = data->dest_x / MG_TEX_ANIME_SUBTEXEL;
                    dest_left = dest_left;
                    dest_top = data->dest_y / MG_TEX_ANIME_SUBTEXEL;
                    dest_top = dest_top;
                    int dest_width = data->dest_w / MG_TEX_ANIME_SUBTEXEL;
                    int dest_height = data->dest_h / MG_TEX_ANIME_SUBTEXEL;
                    int offset_x;
                    int offset_y;

                    if (type == MG_TEX_ANIME_TYPE_SCROLL) {
                        float period = data->period_x;
                        if (period >= 0.0f) {
                        } else {
                            period = -period;
                        }
                        offset_x = (int) ((float) ((dest_width - 1) * data->phase_x) / period);
                        float numerator;
                        float period_y;
                        period_y = data->period_y;
                        numerator = (float)((dest_height - 1) * data->phase_y);
                        if (period_y < 0.0f) {
                            period_y = -period_y;
                        }
                        period_y = period_y;
                        offset_y = (int)(numerator / period_y);
                    } else {
                        offset_y = 0;
                        offset_x = 0;
                    }

                    src_end = src_left + src_width;
                    int src_right = src_end - 1;
                    src_bottom_end = src_top + src_height;
                    int src_bottom = src_bottom_end - 1;
                    int dest_right = dest_left + dest_width - 1;
                    int dest_bottom = dest_top + dest_height - 1;
                    indexed_src_rect.Set(0, 0, 0, 0);
                    indexed_dest_rect.Set(0, 0, 0, 0);

                    src_split_x = src_end - offset_x - 1;
                    src_split_y = src_bottom_end - offset_y - 1;
                    dest_split_x = dest_left + offset_x + 1;
                    dest_split_y = dest_top + offset_y + 1;
                    if (src_split_x < src_left) {
                        src_split_x = src_left;
                    }
                    if (src_split_y < src_top) {
                        src_split_y = src_top;
                    }
                    if (dest_split_x < dest_left) {
                        dest_split_x = dest_left;
                    }
                    if (dest_split_y < dest_top) {
                        dest_split_y = dest_top;
                    }
                    if (src_split_x > src_right) {
                        src_split_x = src_right;
                    }
                    if (src_split_y > src_bottom) {
                        src_split_y = src_bottom;
                    }
                    if (dest_split_x > dest_right) {
                        dest_split_x = dest_right;
                    }
                    if (dest_split_y > dest_bottom) {
                        dest_split_y = dest_bottom;
                    }
                    src_split_x *= MG_TEX_ANIME_SUBTEXEL;
                    src_split_y *= MG_TEX_ANIME_SUBTEXEL;
                    dest_split_x *= MG_TEX_ANIME_SUBTEXEL;
                    dest_split_y *= MG_TEX_ANIME_SUBTEXEL;
                    src_right *= MG_TEX_ANIME_SUBTEXEL;
                    src_end_x = src_right;
                    src_bottom *= MG_TEX_ANIME_SUBTEXEL;
                    src_end_y = src_bottom;
                    dest_right *= MG_TEX_ANIME_SUBTEXEL;
                    dest_end_x = dest_right;
                    dest_bottom *= MG_TEX_ANIME_SUBTEXEL;
                    dest_end_y = dest_bottom;
                } else {
                    int offset_x;
                    int offset_y;

                    if (type == MG_TEX_ANIME_TYPE_SCROLL) {
                        float period = data->period_x;
                        if (period < 0.0f) {
                            period = -period;
                        }
                        offset_x = (int) ((float) (data->dest_w * data->phase_x) / period);
                        float numerator;
                        float period_y;
                        period_y = data->period_y;
                        numerator = (float)(data->dest_h * data->phase_y);
                        if (period_y < 0.0f) {
                            period_y = -period_y;
                        }
                        period_y = period_y;
                        offset_y = (int)(numerator / period_y);
                    } else {
                        float phase = (float)data->phase_x;
                        float radians = float(6.2831855);
                        float sine = sinf(radians * phase / data->period_x);
                        float one = float(1.0);
                        float wave = one + sine;
                        float two = float(2.0);
                        float half = wave / two;
                        float amplitude = (float)data->amplitude_x;
                        float scaled = amplitude * half;
                        float full = float(10000.0);
                        float ratio = scaled / full;
                        float width = (float)data->dest_w;
                        offset_x = (int)(width * ratio);
                        offset_y = (int) ((float) data->dest_h *
                                          ((float) data->amplitude_y *
                                           ((float(1.0) + sinf((float(6.2831855) * (float) data->phase_y) / (float) data->period_y)) /
                                            float(2.0)) /
                                           float(10000.0)));
                    }

                    src_end_x = data->src_x + data->src_w;
                    src_end_y = data->src_y + data->src_h;
                    dest_end_x = data->dest_x + data->dest_w;
                    dest_end_y = data->dest_y + data->dest_h;
                    colour_src_rect.Set(0, 0, 0, 0);
                    colour_dest_rect.Set(0, 0, 0, 0);

                    int width = data->src_w;
                    src_split_x = data->src_x + width - offset_x * width / data->dest_w;
                    int height = data->src_h;
                    src_split_y = data->src_y + height - offset_y * height / data->dest_h;
                    dest_split_x = data->dest_x + offset_x;
                    dest_split_y = data->dest_y + offset_y;
                }

                mgCTexture *dest = data->dest_tex;
                dest = dest;
                if (dest->bpp < MG_TEX_ANIME_BPP_TRUE_COLOUR) {
                    draw_rect.Set(0, 0, 0, 0);
                    unused_draw_rect.Set(0, 0, 0, 0);
                    

                    draw_rect.Set(data->src_x, data->src_y, src_split_x, src_split_y);
                    int *right = &draw_rect.right;
                    if (*right - draw_rect.left + 1 > 0 && draw_rect.bottom - draw_rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, draw_rect, &data->dest_tex->tex0,
                                         dest_split_x - MG_TEX_ANIME_SUBTEXEL, dest_split_y - MG_TEX_ANIME_SUBTEXEL, 0);
                    }
                    draw_rect.Set(data->src_x, src_split_y, src_split_x, src_end_y - MG_TEX_ANIME_SUBTEXEL);
                    if (*right - draw_rect.left + 1 > 0 && draw_rect.bottom - draw_rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, draw_rect, &data->dest_tex->tex0,
                                         dest_split_x - MG_TEX_ANIME_SUBTEXEL, data->dest_y, 0);
                    }
                    draw_rect.Set(src_split_x, data->src_y, src_end_x - MG_TEX_ANIME_SUBTEXEL, src_split_y);
                    if (*right - draw_rect.left + 1 > 0 && draw_rect.bottom - draw_rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, draw_rect, &data->dest_tex->tex0, data->dest_x,
                                         dest_split_y - MG_TEX_ANIME_SUBTEXEL, 0);
                    }
                    draw_rect.Set(src_split_x, src_split_y, src_end_x - MG_TEX_ANIME_SUBTEXEL,
                             src_end_y - MG_TEX_ANIME_SUBTEXEL);
                    if (*right - draw_rect.left + 1 > 0 && draw_rect.bottom - draw_rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, draw_rect, &data->dest_tex->tex0, data->dest_x, data->dest_y, 0);
                    }
                } else {
                    int height = dest->height;
                    int rem = height % MG_TEX_ANIME_FRAME_ALIGN;
                    if (rem != 0) {
                        height += MG_TEX_ANIME_FRAME_ALIGN - rem;
                    }
                    sceGsTex0 *tex = &dest->tex0;
                    mgSetPkFrameBuffer((int)tex->TBP0 / 32, (int)(tex->TBW * 64), height, dest->tex0.PSM);
                    prim.Begin(MG_PRIM_SPRITE);

                    prim.Texture(data->src_tex);
                    prim.Color(data->r, data->g, data->b, data->a);
                    prim.TextureCrd4(data->src_x, data->src_y);
                    prim.Vertex4(dest_split_x, dest_split_y, 0);
                    prim.TextureCrd4(src_split_x, src_split_y);
                    prim.Vertex4(dest_end_x, dest_end_y, 0);

                    prim.Texture(data->src_tex);
                    prim.TextureCrd4(data->src_x, src_split_y);
                    prim.Vertex4(dest_split_x, data->dest_y, 0);
                    prim.TextureCrd4(src_split_x, src_end_y);
                    prim.Vertex4(dest_end_x, dest_split_y, 0);

                    prim.Texture(data->src_tex);
                    prim.TextureCrd4(src_split_x, data->src_y);
                    prim.Vertex4(data->dest_x, dest_split_y, 0);
                    prim.TextureCrd4(src_end_x, src_split_y);
                    prim.Vertex4(dest_split_x, dest_end_y, 0);

                    prim.Texture(data->src_tex);
                    prim.TextureCrd4(src_split_x, src_split_y);
                    prim.Vertex4(data->dest_x, data->dest_y, 0);
                    prim.TextureCrd4(src_end_x, src_end_y);
                    prim.Vertex4(dest_split_x, dest_split_y, 0);

                    prim.End();
                    mgSetPkFrameBuffer(-1, -1, -1, -1);
                }

                if (stop_anime == 0) {
                    // A negative period runs the phase backwards, from -period down to 1.
                    if (data->period_x != 0) {
                        if (data->period_x > 0) {
                            data->phase_x++;
                            if (data->phase_x >= data->period_x) {
                                data->phase_x = 0;
                            }
                        } else {
                            data->phase_x--;
                            if (data->phase_x <= 0) {
                                data->phase_x = -data->period_x;
                            }
                        }
                    }
                    if (data->period_y != 0) {
                        if (data->period_y > 0) {
                            data->phase_y++;
                            if (data->phase_y >= data->period_y) {
                                data->phase_y = 0;
                            }
                        } else {
                            data->phase_y--;
                            if (data->phase_y <= 0) {
                                data->phase_y = -data->period_y;
                            }
                        }
                    }
                }
            }

            if (data->wait != 0 || node->next == NULL) {
                break;
            }
            node = node->next;
            data = node->pGetData();
        }

        if (stop_anime == 0) {
            (*(int *)(offset + (int)this + 0x184))++;
        }
        int wait = data->wait;
        if (wait < 0) {
            *(int *)(offset + (int)this + 0x184) = 0;
        } else if (data->bug_patch != 0) {
            int *base = (int *)(offset + (int)this);
            int *counter = base + 0x61;
            int count = base[0x61];
            CList<mgCTexAnimeData> *next;
            if (count >= wait) {
                *counter = 0;
                next = node->next;
                *current = next;
                if (*current == NULL) {
                    *current = *(CList<mgCTexAnimeData> **)(base + 0x19);
                }
            }
        } else {
            int count;
            int *base = (int *)(offset + (int)this);
            int *counter = base + 0x61;
            count = base[0x61];
            CList<mgCTexAnimeData> *next;
            if (count > wait) {
                *counter = 0;
                next = node->next;
                *current = next;
                if (*current == NULL) { *current = *(CList<mgCTexAnimeData> **)(base + 0x19); }
            }
        }
    }

    sceVif1PkCnt(packet, 0);
    sceVif1PkOpenDirectCode(packet, 0);
    sceVif1PkOpenGifTag(packet, *(u_long128 *) &mgGiftagAD);
    sceVif1PkAddGsAD(packet, SCE_GS_TEXFLUSH, 0);
    sceVif1PkCloseGifTag(packet);
    sceVif1PkCloseDirectCode(packet);
}
#pragma global_optimizer reset
#pragma divbyzerocheck reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_tanime", TexAnime__15mgCTextureAnimeFiP13sceVif1Packet);
#endif
#pragma global_optimizer off
void mgCTextureAnime::Initialize() {
    group_num = MG_TEX_ANIME_GROUP_MAX;
    for (int i = 0; i < MG_TEX_ANIME_GROUP_MAX; i++) {
        DeleteGroup(i);
    }
}
#pragma global_optimizer reset

mgCTextureAnime::mgCTextureAnime() {
    Initialize();
}

void mgCTextureAnime::SetGroupName(int group, char *group_name) {
    if (group < 0 || group >= group_num) {
        return;
    }
    name[group] = group_name;
}

#pragma global_optimizer off
int mgCTextureAnime::GetEmptyGroup() {
    for (int i = 0; i < *(volatile int *)&group_num; i++) {
        if (*(CList<mgCTexAnimeData> **)((i << 2) + (int)this + 0x64) == NULL) {
            return i;
        }
    }
    return -1;
}
#pragma global_optimizer reset

#pragma global_optimizer off
int mgCTextureAnime::SearchGroupName(char *group_name) {
    if (group_name == NULL) {
        return -1;
    }
    for (int i = 0; i < group_num; i++) {
        char *candidate = *(char **)((i << 2) + (int)this + 0x124);
        if (candidate != NULL && strcmp(candidate, group_name) == 0) {
            return i;
        }
    }
    return -1;
}
#pragma global_optimizer reset

extern "C" u_char __vt__24CList_15mgCTexAnimeData_[];
extern "C" void __ct__15mgCTexAnimeDataFv(void *);
CList<mgCTexAnimeData> *mgCTextureAnime::NewTexAnimeData(mgCMemory *stack) {
    CList<mgCTexAnimeData> *node;
    if ((node = (CList<mgCTexAnimeData> *)operator new(0x40, stack->Alloc(6))) != 0) {
        *(void **)((u_char *)node + 0x3C) = __vt__24CList_15mgCTexAnimeData_;
        __ct__15mgCTexAnimeDataFv((u_char *)node + 8);
        node->Initialize();
    }
    return node;
}

// Defined in the class body in mg_tanime.hpp.
#pragma global_optimizer off
CList<mgCTexAnimeData> *mgCTextureAnime::NewTexAnimeGroupData(int group, mgCMemory *stack) {
    if (group < 0 || group >= group_num) {
        return NULL;
    }

    CList<mgCTexAnimeData> *node = NewTexAnimeData(stack);
    if (node == NULL) {
        return NULL;
    }
    if (&node->data == NULL) {
        return NULL;
    }
    node->Initialize();

    CList<mgCTexAnimeData> **slot = (CList<mgCTexAnimeData> **)((group << 2) + (int)this + 0x64);
    CList<mgCTexAnimeData> *p = *slot;
    CList<mgCTexAnimeData> *tail;
    CList<mgCTexAnimeData> *next;
    if (p == NULL) {
        *slot = node;
        now[group] = *slot;
    } else {
        tail = p;
        while (tail != NULL) {
            next = tail->next;
            if (next == NULL) {
                break;
            }
            tail = next;
        }
        tail->next = node;
        if (node != NULL) {
            node->prev = tail;
        }
    }
    return node;
}
#pragma global_optimizer reset

struct mgTexAnimeColor {
    u_char channel[4];
};
int mgCTextureAnime::EnterTexAnime(mgCTexAnimeData *data, mgCMemory *stack) {
    CList<mgCTexAnimeData> *node = NewTexAnimeGroupData(data->group, stack);
    if (node == NULL) {
        return 0;
    }
    mgCTexAnimeData *entry = node->pGetData();
    if (entry == NULL) {
        return 0;
    }

    entry->type = data->type;
    entry->group = data->group;
    entry->link_group = data->link_group;
    entry->clut_copy = *(s8 *)&data->clut_copy;
    entry->src_tex = data->src_tex;
    entry->dest_tex = data->dest_tex;
    entry->src_x = data->src_x;
    entry->src_y = data->src_y;
    entry->src_w = data->src_w;
    entry->src_h = data->src_h;
    entry->dest_x = data->dest_x;
    entry->dest_y = data->dest_y;
    entry->dest_w = data->dest_w;
    entry->dest_h = data->dest_h;
    entry->period_x = data->period_x;
    entry->period_y = data->period_y;
    entry->phase_x = data->phase_x;
    entry->phase_y = data->phase_y;
    entry->amplitude_x = data->amplitude_x;
    entry->amplitude_y = data->amplitude_y;
    entry->wait = data->wait;
    entry->bug_patch = data->bug_patch;
    entry->bilinear = *(s8 *)&data->bilinear;
    entry->alpha_blend = *(s8 *)&data->alpha_blend;
    entry->alpha_test = data->alpha_test;
    entry->alpha_ref = data->alpha_ref;
    *(mgTexAnimeColor *)&entry->r = *(mgTexAnimeColor *)&data->r;
    // Scripts give rectangles from the top of the texture; the records keep them from the bottom.
    if (entry->src_tex != NULL && entry->dest_tex != NULL) {
        entry->src_y = entry->src_tex->height * MG_TEX_ANIME_SUBTEXEL - data->src_y - data->src_h;
        entry->dest_y = entry->dest_tex->height * MG_TEX_ANIME_SUBTEXEL - data->dest_y - data->dest_h;
    }
    return 1;
}

void mgCTextureAnime::DeleteGroup(int group) {
    if (group < 0 || group >= group_num) {
        return;
    }
    Disable(group);
    list[group] = NULL;
    now[group] = NULL;
    name[group] = NULL;
    frame[group] = 0;
}

void mgCTextureAnime::DisableAll() {
    for (int i = 0; i < group_num; i++) {
        Disable(i);
    }
}

void mgCTextureAnime::Enable(int group) {
    if (group < 0 || group >= group_num) {
        return;
    }
    enable[group] = 1;
}

void mgCTextureAnime::Disable(int group) {
    if (group < 0 || group >= group_num) {
        return;
    }
    enable[group] = 0;
    now[group] = list[group];
    frame[group] = 0;
}

CList<mgCTexAnimeData> *mgCTextureAnime::GetAnimeList(int group) {
    if (group < 0 || group >= group_num) {
        return NULL;
    }
    return list[group];
}

void mgCTextureManager::LoadCFGFile(char *script, int size, mgCMemory *stack, mgCTextureAnime *anime) {
    pTexAnime = NULL;
    pLoadTexAnime = anime;
    group_name = NULL;
    ta_enable = 0;
    now_texb = -1;
    now_group = -1;
    TexAnimeStack = stack;
    TexManager = this;
    texBugPatch = 0;

    CScriptInterpreter interpreter;
    interpreter.SetTag(tex_tag);
    interpreter.SetScript(script, size);
    interpreter.Run();
}

/**
 *
 * TEX_ANIME(name, enable): opens a named group of records and says whether it plays from the start.
 *
 */
int texTEX_ANIME(SPI_STACK *stack, int argc) {
    char *name = spiGetStackString(stack++);
    if (name != NULL) {
        char *copy = (char *) TexAnimeStack->Alloc((strlen(name) + 1) / MG_TEX_ANIME_NAME_ALLOC_UNIT + 1);
        strcpy(copy, name);
        group_name = copy;
    }
    ta_enable = spiGetStackInt(stack++);
    return 1;
}

/**
 *
 * TEX_ANIME_DATA(type, name): starts a new record of the given mgTEX_ANIME_TYPE; the name is ignored.
 *
 */
int texTEX_ANIME_DATA(SPI_STACK *stack, int argc) {
    now_texb = -1;
    nowTexData.Initialize();
    nowTexData.type = spiGetStackInt(stack++);
    spiGetStackString(stack++);
    nowTexData.bug_patch = texBugPatch;
    return 1;
}

/**
 *
 * SRC_TEX(name, x, y, w, h): sets the record's source texture and rectangle, in texels.
 *
 */
int texSRC_TEX(SPI_STACK *stack, int argc) {
    char *name = spiGetStackString(stack++);
    if (name == NULL) {
        return 0;
    }
    nowTexData.src_tex = TexManager->GetTexture(name, -1);
    nowTexData.src_x = spiGetStackInt(stack++) * MG_TEX_ANIME_SUBTEXEL;
    nowTexData.src_y = spiGetStackInt(stack++) * MG_TEX_ANIME_SUBTEXEL;
    nowTexData.src_w = spiGetStackInt(stack++) * MG_TEX_ANIME_SUBTEXEL;
    nowTexData.src_h = spiGetStackInt(stack++) * MG_TEX_ANIME_SUBTEXEL;

    if (nowTexData.src_tex != NULL) {
        if (now_texb < 0) {
            now_texb = nowTexData.src_tex->block;
        } else if (now_texb != nowTexData.src_tex->block) {
            printf(at_873, nowTexData.src_tex->name);
        }
    }
    return 1;
}

/**
 *
 * DEST_TEX(name, x, y[, w, h[, bilinear]]): sets the record's destination texture and rectangle, in texels.
 *
 */
int texDEST_TEX(SPI_STACK *stack, int argc) {
    char *name = spiGetStackString(stack++);
    if (name == NULL) {
        return 0;
    }
    nowTexData.dest_tex = TexManager->GetTexture(name, -1);
    nowTexData.dest_x = spiGetStackInt(stack++) * MG_TEX_ANIME_SUBTEXEL;
    nowTexData.dest_y = spiGetStackInt(stack++) * MG_TEX_ANIME_SUBTEXEL;
    if (argc > 3) {
        nowTexData.dest_w = spiGetStackInt(stack++) * MG_TEX_ANIME_SUBTEXEL;
        nowTexData.dest_h = spiGetStackInt(stack++) * MG_TEX_ANIME_SUBTEXEL;
        if (argc > 5) {
            nowTexData.bilinear = spiGetStackInt(stack++);
        }
    } else {
        nowTexData.dest_w = nowTexData.src_w;
        nowTexData.dest_h = nowTexData.src_h;
    }

    if (nowTexData.dest_tex != NULL) {
        if (now_texb < 0) {
            now_texb = nowTexData.dest_tex->block;
        } else if (now_texb != nowTexData.dest_tex->block) {
            printf(at_873, nowTexData.dest_tex->name);
        }
    }
    return 1;
}

/**
 *
 * SCROLL(x, y): sets a scroll record's speeds in texels per frame, or a wave record's periods and amplitudes.
 *
 */
int texSCROLL(SPI_STACK *stack, int argc) {
    signed char mode = nowTexData.type;
    if (mode == 1) {
        float speedX = 16.0f * spiGetStackFloat(stack++);
        float speedY = 16.0f * spiGetStackFloat(stack);
        nowTexData.period_x = fptosi((float)(nowTexData.dest_w - 16) / speedX);
        nowTexData.period_y = fptosi((float)(nowTexData.dest_h - 16) / speedY);
    } else if (mode == 2) {
        float valueX;
        float valueY;
        float fractionY;
        float fractionX;
        valueX = spiGetStackFloat(stack++);
        valueY = spiGetStackFloat(stack);
        int wholeX = fptosi(valueX);
        nowTexData.period_x = wholeX;
        int wholeY = fptosi(valueY);
        nowTexData.period_y = wholeY;
        fractionX = valueX - (float)wholeX;
        fractionY = valueY - (float)wholeY;
        nowTexData.amplitude_x = fptosi(10000.0f * fractionX);
        nowTexData.amplitude_y = fptosi(10000.0f * fractionY);
        if (fractionX < 0.0f) {
            fractionX = -fractionX;
        }
        if (fractionX < 0.001f) {
            nowTexData.amplitude_x = 10000;
        }
        if (fractionY < 0.0f) {
            fractionY = -fractionY;
        }
        if (fractionY < 0.001f) {
            nowTexData.amplitude_y = 10000;
        }
    } else {
        return 0;
    }
    return 1;
}
/**
 *
 * CLUT_COPY(flag): makes the record copy the source's palette even for a partial rectangle.
 *
 */
int texCLUT_COPY(SPI_STACK *stack, int argc) {
    nowTexData.clut_copy = spiGetStackInt(stack++);
    return 1;
}

/**
 *
 * COLOR(r[, g[, b[, a]]]): sets the colour a drawn record is tinted with.
 *
 */
int texCOLOR(SPI_STACK *stack, int argc) {
    if (argc > 0) {
        nowTexData.r = spiGetStackInt(stack++);
    }
    if (argc > 1) {
        nowTexData.g = spiGetStackInt(stack++);
    }
    if (argc > 2) {
        nowTexData.b = spiGetStackInt(stack++);
    }
    if (argc > 3) {
        nowTexData.a = spiGetStackInt(stack++);
    }
    return 1;
}

/**
 *
 * ALPHA_BLEND(mode): sets the alpha blending mode a drawn record uses.
 *
 */
int texALPHA_BLEND(SPI_STACK *stack, int argc) {
    if (argc > 0) {
        nowTexData.alpha_blend = spiGetStackInt(stack++);
    }
    return 1;
}

/**
 *
 * ALPHA_TEST(method[, ref]): sets the alpha test a drawn record uses.
 *
 */
int texALPHA_TEST(SPI_STACK *stack, int argc) {
    if (argc > 0) {
        nowTexData.alpha_test = spiGetStackInt(stack++);
    }
    if (argc > 1) {
        nowTexData.alpha_ref = spiGetStackInt(stack++);
    }
    return 1;
}

/**
 *
 * WAIT(frames, forever[, name]): sets how long the record plays; the name is ignored.
 *
 */
int texWAIT(SPI_STACK *stack, int argc) {
    nowTexData.wait = spiGetStackInt(stack++);
    if (spiGetStackInt(stack++) != 0) {
        nowTexData.wait = MG_TEX_ANIME_WAIT_FOREVER;
    }
    if (argc > 2) {
        spiGetStackString(stack++);
    }
    return 1;
}

/**
 *
 * TEX_ANIME_DATA_END: enters the record built so far into the current group of its texture block's animation.
 *
 */
int texTEX_ANIME_DATA_END(SPI_STACK *stack, int argc) {
    if (now_texb < 0) {
        return 0;
    }
    mgCTextureBlock *block = TexManager->GetTextureBlock(now_texb);
    if (block == NULL) {
        return 0;
    }

    pTexAnime = block->anime;
    if (pTexAnime == NULL) {
        if (pLoadTexAnime == NULL) {
            block->anime = new (TexAnimeStack->Alloc(0x21)) mgCTextureAnime;
            pTexAnime = block->anime;
        } else {
            pTexAnime = pLoadTexAnime;
        }
        if (pTexAnime != NULL) {
            now_group = pTexAnime->GetEmptyGroup();
        }
    } else if (now_group < 0) {
        now_group = pTexAnime->GetEmptyGroup();
    }

    if (pTexAnime != NULL && now_group >= 0) {
        nowTexData.group = now_group;
        pTexAnime->SetGroupName(now_group, group_name);
        if (ta_enable != 0) {
            pTexAnime->Enable(now_group);
        } else {
            pTexAnime->Disable(now_group);
        }
        if (nowTexData.src_tex != NULL && nowTexData.dest_tex != NULL) {
            pTexAnime->EnterTexAnime(&nowTexData, TexAnimeStack);
        }
    }
    return 1;
}

/**
 *
 * TEX_ANIME_END: closes the current group, so that the next records go into a new one.
 *
 */
int texTEX_ANIME_END(SPI_STACK *stack, int argc) {
    now_group = -1;
    if (pTexAnime != NULL) {
        now_group = pTexAnime->GetEmptyGroup();
    }
    return 1;
}

/**
 *
 * BUG_PATCH: makes every following record end after exactly its wait frames.
 *
 */
int texBUG_PATCH(SPI_STACK *stack, int argc) {
    texBugPatch = 1;
    return 1;
}

template <>
void mgRect<int>::Set(int new_left, int new_top, int new_right, int new_bottom) {
    left = new_left;
    top = new_top;
    right = new_right;
    bottom = new_bottom;
}

#pragma optimization_level 1

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", tex_tag__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_831__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_832__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_833__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_834__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_835__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_836__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_837__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_838__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_839__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_840__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_841__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_842__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_843__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", at_873__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", __vt__24CList_15mgCTexAnimeData___DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(mgBugPatch, 0x4);
INCLUDE_BSS(stop_anime__15mgCTextureAnime, 0x4);
INCLUDE_BSS(pTexAnime, 0x4);
INCLUDE_BSS(pLoadTexAnime, 0x4);
INCLUDE_BSS(now_group, 0x4);
INCLUDE_BSS(TexManager, 0x4);
INCLUDE_BSS(TexAnimeStack, 0x4);
INCLUDE_BSS(group_name, 0x4);
INCLUDE_BSS(ta_enable, 0x4);
INCLUDE_BSS(now_texb, 0x4);
INCLUDE_BSS(texBugPatch, 0x4);

// Uninitialised data (.bss)
