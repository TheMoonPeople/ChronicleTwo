#include "common.h"

#include <cmath>

#include "mg_drawprim.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"

PORT_OVERRIDE void mgCTextureAnime::TexAnime(int texb, sceVif1Packet *) {
    int                     i;
    int                     group;
    CList<mgCTexAnimeData> *node;
    mgCTexAnimeData        *data;

    // TEXFLUSH has no PC counterpart: the renderer keeps no texture cache to invalidate.
    // TA0 = TA1 = 0x80: alpha of 24-bit and 16-bit texels.
    mgPortGs().texa = 0x80 | (static_cast<uint64_t>(0x80) << 32);

    for (i = 0; i < group_num; i++) {
        if (enable[i] != 0) {
            CList<mgCTexAnimeData> *linked_node = now[i];

            if (linked_node != NULL) {
                mgCTexAnimeData *linked_data = linked_node->pGetData();

                if (linked_data != NULL && linked_data->link_group >= 0) {
                    Enable(linked_data->link_group);
                }
            }
        }
    }

    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.DepthTest(MG_DEPTH_TEST_ALWAYS);
    prim.TextureMapEnable(1);

    for (group = 0; group < group_num; group++) {
        if (enable[group] == 0) {
            continue;
        }

        if (now[group] == NULL) {
            continue;
        }

        node = now[group];
        data = node->pGetData();

        if (data == NULL || data->src_tex == NULL || data->dest_tex == NULL) {
            continue;
        }

        if (data->src_tex->block != texb || data->dest_tex->block != texb) {
            continue;
        }

        // Records that wait no frames play together with the record after them.
        for (;;) {
            MgTexturePrepareAnimationDestination(data->src_tex, data->dest_tex);
            if (MgTextureAnimationMode(data->dest_tex) == texture_catalog::AnimationMode::Draw) {
                if (data->bilinear != 0) {
                    prim.Bilinear(1);
                } else {
                    prim.Bilinear(0);
                }

                if (data->alpha_blend != MG_TEX_ANIME_ALPHA_BLEND_OFF) {
                    prim.AlphaBlendEnable(1);
                    prim.AlphaBlend(data->alpha_blend);
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

            if (MgTextureAnimationMode(src) == texture_catalog::AnimationMode::CopyVariant &&
                MgTextureAnimationMode(data->dest_tex) == texture_catalog::AnimationMode::CopyVariant &&
                (data->clut_copy != 0 || (data->src_w == src->width && data->src_h == src->height))) {
                mgPortAdoptColorVariant(src, data->dest_tex);
            }

            if (data->type == MG_TEX_ANIME_TYPE_COPY) {
                mgCTexture *dest = data->dest_tex;

                if (MgTextureAnimationMode(dest) != texture_catalog::AnimationMode::Draw) {
                    mgSetPkMoveImage(&data->src_tex->tex0,
                                     mgRect<int>(data->src_x, data->src_y,
                                                 data->src_x + data->src_w - MG_TEX_ANIME_SUBTEXEL,
                                                 data->src_y + data->src_h - MG_TEX_ANIME_SUBTEXEL),
                                     &data->dest_tex->tex0, data->dest_x, data->dest_y, 0);
                } else {
                    mgSetPkFrameBuffer(dest);
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

            if (data->type == MG_TEX_ANIME_TYPE_SCROLL || data->type == MG_TEX_ANIME_TYPE_WAVE) {
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

                if (MgTextureAnimationMode(data->dest_tex) != texture_catalog::AnimationMode::Draw) {
                    int src_left = data->src_x / MG_TEX_ANIME_SUBTEXEL;
                    int src_top = data->src_y / MG_TEX_ANIME_SUBTEXEL;
                    int src_width = data->src_w / MG_TEX_ANIME_SUBTEXEL;
                    int src_height = data->src_h / MG_TEX_ANIME_SUBTEXEL;
                    int dest_left = data->dest_x / MG_TEX_ANIME_SUBTEXEL;
                    int dest_top = data->dest_y / MG_TEX_ANIME_SUBTEXEL;
                    int dest_width = data->dest_w / MG_TEX_ANIME_SUBTEXEL;
                    int dest_height = data->dest_h / MG_TEX_ANIME_SUBTEXEL;
                    int offset_x;
                    int offset_y;

                    // Retail bug, kept: paletted waves get zero offsets.
                    if (data->type == MG_TEX_ANIME_TYPE_SCROLL) {
                        float period_x = data->period_x;
                        period_x = period_x < 0.0f ? -period_x : period_x;
                        offset_x = (float) ((dest_width - 1) * data->phase_x) / period_x;
                        float numerator_y;
                        float period_y;
                        period_y = data->period_y;
                        numerator_y = (dest_height - 1) * data->phase_y;
                        period_y = period_y < 0.0f ? -period_y : period_y;
                        offset_y = numerator_y / period_y;
                    } else {
                        offset_y = 0;
                        offset_x = 0;
                    }

                    src_end_x = src_left + src_width - 1;
                    src_end_y = src_top + src_height - 1;
                    dest_end_x = dest_left + dest_width - 1;
                    dest_end_y = dest_top + dest_height - 1;

                    src_split_x = src_left + src_width - offset_x - 1;
                    src_split_y = src_top + src_height - offset_y - 1;
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

                    if (src_split_x > src_end_x) {
                        src_split_x = src_end_x;
                    }

                    if (src_split_y > src_end_y) {
                        src_split_y = src_end_y;
                    }

                    if (dest_split_x > dest_end_x) {
                        dest_split_x = dest_end_x;
                    }

                    if (dest_split_y > dest_end_y) {
                        dest_split_y = dest_end_y;
                    }

                    src_split_x *= MG_TEX_ANIME_SUBTEXEL;
                    src_split_y *= MG_TEX_ANIME_SUBTEXEL;
                    dest_split_x *= MG_TEX_ANIME_SUBTEXEL;
                    dest_split_y *= MG_TEX_ANIME_SUBTEXEL;
                    src_end_x *= MG_TEX_ANIME_SUBTEXEL;
                    src_end_y *= MG_TEX_ANIME_SUBTEXEL;
                    dest_end_x *= MG_TEX_ANIME_SUBTEXEL;
                    dest_end_y *= MG_TEX_ANIME_SUBTEXEL;
                } else {
                    int offset_x;
                    int offset_y;

                    if (data->type == MG_TEX_ANIME_TYPE_SCROLL) {
                        float period_x = data->period_x;
                        period_x = period_x < 0.0f ? -period_x : period_x;
                        offset_x = (float) (data->dest_w * data->phase_x) / period_x;
                        float numerator_y;
                        float period_y;
                        period_y = data->period_y;
                        numerator_y = data->dest_h * data->phase_y;
                        period_y = period_y < 0.0f ? -period_y : period_y;
                        offset_y = numerator_y / period_y;
                    } else {
                        offset_x = (float) data->dest_w *
                                   ((float) data->amplitude_x *
                                    ((1.0f + sinf(TWO_PI * (float) data->phase_x / (float) data->period_x)) / 2.0f) /
                                    (float) MG_TEX_ANIME_AMPLITUDE_FULL);
                        offset_y = (float) data->dest_h *
                                   ((float) data->amplitude_y *
                                    ((1.0f + sinf(TWO_PI * (float) data->phase_y / (float) data->period_y)) / 2.0f) /
                                    (float) MG_TEX_ANIME_AMPLITUDE_FULL);
                    }

                    src_end_x = data->src_x + data->src_w;
                    src_end_y = data->src_y + data->src_h;
                    dest_end_x = data->dest_x + data->dest_w;
                    dest_end_y = data->dest_y + data->dest_h;

                    src_split_x = data->src_x + data->src_w - offset_x * data->src_w / data->dest_w;
                    src_split_y = data->src_y + data->src_h - offset_y * data->src_h / data->dest_h;
                    dest_split_x = data->dest_x + offset_x;
                    dest_split_y = data->dest_y + offset_y;
                }

                if (MgTextureAnimationMode(data->dest_tex) != texture_catalog::AnimationMode::Draw) {
                    mgRect<int> src_rect(0, 0, 0, 0);

                    src_rect.Set(data->src_x, data->src_y, src_split_x, src_split_y);

                    if (src_rect.right - src_rect.left + 1 > 0 && src_rect.bottom - src_rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, src_rect, &data->dest_tex->tex0,
                                         dest_split_x - MG_TEX_ANIME_SUBTEXEL, dest_split_y - MG_TEX_ANIME_SUBTEXEL, 0);
                    }

                    src_rect.Set(data->src_x, src_split_y, src_split_x, src_end_y - MG_TEX_ANIME_SUBTEXEL);

                    if (src_rect.right - src_rect.left + 1 > 0 && src_rect.bottom - src_rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, src_rect, &data->dest_tex->tex0,
                                         dest_split_x - MG_TEX_ANIME_SUBTEXEL, data->dest_y, 0);
                    }

                    src_rect.Set(src_split_x, data->src_y, src_end_x - MG_TEX_ANIME_SUBTEXEL, src_split_y);

                    if (src_rect.right - src_rect.left + 1 > 0 && src_rect.bottom - src_rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, src_rect, &data->dest_tex->tex0, data->dest_x,
                                         dest_split_y - MG_TEX_ANIME_SUBTEXEL, 0);
                    }

                    src_rect.Set(src_split_x, src_split_y, src_end_x - MG_TEX_ANIME_SUBTEXEL,
                                 src_end_y - MG_TEX_ANIME_SUBTEXEL);

                    if (src_rect.right - src_rect.left + 1 > 0 && src_rect.bottom - src_rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, src_rect, &data->dest_tex->tex0, data->dest_x,
                                         data->dest_y, 0);
                    }
                } else {
                    mgSetPkFrameBuffer(data->dest_tex);
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
            frame[group]++;
        }

        int wait = data->wait;

        if (wait < 0) {
            frame[group] = 0;
        } else if (data->bug_patch != 0) {
            if (wait <= frame[group]) {
                frame[group] = 0;
                CList<mgCTexAnimeData> *next = node->next;
                now[group] = next;

                if (now[group] == NULL) {
                    now[group] = list[group];
                }
            }
        } else {
            if (frame[group] > wait) {
                frame[group] = 0;
                CList<mgCTexAnimeData> *next = node->next;
                now[group] = next;

                if (now[group] == NULL) {
                    now[group] = list[group];
                }
            }
        }
    }

    // Retail's epilogue flushes the texture cache and restores nothing, so TEXA stays as set above.
}

// Stride fix: retail finds list[group] as (group << 2) + this + 0x64, a 4-byte pointer stride.
PORT_OVERRIDE CList<mgCTexAnimeData> *mgCTextureAnime::NewTexAnimeGroupData(int group, mgCMemory *stack) {
    if (group < 0 || group >= group_num) {
        return NULL;
    }

    CList<mgCTexAnimeData> *node = NewTexAnimeData(stack);

    if (node == NULL || node->pGetData() == NULL) {
        return NULL;
    }

    node->Initialize();

    if (list[group] == NULL) {
        list[group] = node;
        now[group] = node;
        return node;
    }

    CList<mgCTexAnimeData> *tail = list[group];

    while (tail->next != NULL) {
        tail = tail->next;
    }

    tail->next = node;
    node->prev = tail;
    return node;
}
