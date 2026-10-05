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
extern mgCTexAnimeData nowTexData;
}

// Code (.text)
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
void mgCTextureAnime::TexAnime(int texb, sceVif1Packet *packet) {
    int i;

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
        if (enable[i] != 0) {
            CList<mgCTexAnimeData> *node = now[i];
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

    for (int group = 0; group < group_num; group++) {
        if (enable[group] == 0) {
            continue;
        }

        CList<mgCTexAnimeData> *node = now[group];
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
            if (data->dest_tex->bpp >= MG_TEX_ANIME_BPP_TRUE_COLOUR) {
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
            if (src->bpp == MG_TEX_ANIME_BPP_INDEXED && data->dest_tex->bpp == MG_TEX_ANIME_BPP_INDEXED &&
                (data->clut_copy != 0 || (data->src_w == src->width && data->src_h == src->height))) {
                // Copy the source palette over the destination's, each treated as a 16x16 image.
                sceGsTex0 src_clut;
                sceGsTex0 dest_clut;
                src_clut.TBP0 = src->tex0.CBP;
                src_clut.TBW = 1;
                src_clut.PSM = data->src_tex->tex0.CPSM;
                dest_clut.TBP0 = data->dest_tex->tex0.CBP;
                dest_clut.TBW = 1;
                dest_clut.PSM = data->dest_tex->tex0.CPSM;
                mgRect<int> clut_rect(0, 0, 0x100, 0x100);
                mgSetPkMoveImage(&src_clut, clut_rect, &dest_clut, 0, 0, 0);
            }

            if (data->type == MG_TEX_ANIME_TYPE_COPY) {
                mgCTexture *dest = data->dest_tex;
                if (dest->bpp < MG_TEX_ANIME_BPP_TRUE_COLOUR) {
                    mgRect<int> rect(data->src_x, data->src_y, data->src_x + data->src_w - MG_TEX_ANIME_SUBTEXEL,
                                     data->src_y + data->src_h - MG_TEX_ANIME_SUBTEXEL);
                    mgSetPkMoveImage(&data->src_tex->tex0, rect, &data->dest_tex->tex0, data->dest_x, data->dest_y, 0);
                } else {
                    short height = dest->height;
                    if (height % MG_TEX_ANIME_FRAME_ALIGN != 0) {
                        height += MG_TEX_ANIME_FRAME_ALIGN - height % MG_TEX_ANIME_FRAME_ALIGN;
                    }
                    mgSetPkFrameBuffer((int) dest->tex0.TBP0 / 32, (int) (dest->tex0.TBW * 64), height, dest->tex0.PSM);
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

                    if (type == MG_TEX_ANIME_TYPE_SCROLL) {
                        float period = data->period_x;
                        if (period < 0.0f) {
                            period = -period;
                        }
                        offset_x = (int) ((float) ((dest_width - 1) * data->phase_x) / period);
                        period = data->period_y;
                        if (period < 0.0f) {
                            period = -period;
                        }
                        offset_y = (int) ((float) ((dest_height - 1) * data->phase_y) / period);
                    } else {
                        offset_y = 0;
                        offset_x = 0;
                    }

                    int src_right = src_left + src_width - 1;
                    int src_bottom = src_top + src_height - 1;
                    int dest_right = dest_left + dest_width - 1;
                    int dest_bottom = dest_top + dest_height - 1;
                    mgRect<int> src_rect;
                    mgRect<int> dest_rect;

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
                    src_end_x = src_right * MG_TEX_ANIME_SUBTEXEL;
                    src_end_y = src_bottom * MG_TEX_ANIME_SUBTEXEL;
                    dest_end_x = dest_right * MG_TEX_ANIME_SUBTEXEL;
                    dest_end_y = dest_bottom * MG_TEX_ANIME_SUBTEXEL;
                } else {
                    int offset_x;
                    int offset_y;

                    if (type == MG_TEX_ANIME_TYPE_SCROLL) {
                        float period = data->period_x;
                        if (period < 0.0f) {
                            period = -period;
                        }
                        offset_x = (int) ((float) (data->dest_w * data->phase_x) / period);
                        period = data->period_y;
                        if (period < 0.0f) {
                            period = -period;
                        }
                        offset_y = (int) ((float) (data->dest_h * data->phase_y) / period);
                    } else {
                        offset_x = (int) ((float) data->dest_w *
                                          ((float) data->amplitude_x *
                                           ((1.0f + sinf((6.2831855f * (float) data->phase_x) / (float) data->period_x)) /
                                            2.0f) /
                                           10000.0f));
                        offset_y = (int) ((float) data->dest_h *
                                          ((float) data->amplitude_y *
                                           ((1.0f + sinf((6.2831855f * (float) data->phase_y) / (float) data->period_y)) /
                                            2.0f) /
                                           10000.0f));
                    }

                    src_end_x = data->src_x + data->src_w;
                    src_end_y = data->src_y + data->src_h;
                    dest_end_x = data->dest_x + data->dest_w;
                    dest_end_y = data->dest_y + data->dest_h;
                    mgRect<int> src_rect;
                    mgRect<int> dest_rect;

                    src_split_x = data->src_x + data->src_w - offset_x * data->src_w / data->dest_w;
                    src_split_y = data->src_y + data->src_h - offset_y * data->src_h / data->dest_h;
                    dest_split_x = data->dest_x + offset_x;
                    dest_split_y = data->dest_y + offset_y;
                }

                mgCTexture *dest = data->dest_tex;
                if (dest->bpp < MG_TEX_ANIME_BPP_TRUE_COLOUR) {
                    mgRect<int> rect;
                    mgRect<int> unused_rect;

                    rect.Set(data->src_x, data->src_y, src_split_x, src_split_y);
                    if (rect.right - rect.left + 1 > 0 && rect.bottom - rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, rect, &data->dest_tex->tex0,
                                         dest_split_x - MG_TEX_ANIME_SUBTEXEL, dest_split_y - MG_TEX_ANIME_SUBTEXEL, 0);
                    }
                    rect.Set(data->src_x, src_split_y, src_split_x, src_end_y - MG_TEX_ANIME_SUBTEXEL);
                    if (rect.right - rect.left + 1 > 0 && rect.bottom - rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, rect, &data->dest_tex->tex0,
                                         dest_split_x - MG_TEX_ANIME_SUBTEXEL, data->dest_y, 0);
                    }
                    rect.Set(src_split_x, data->src_y, src_end_x - MG_TEX_ANIME_SUBTEXEL, src_split_y);
                    if (rect.right - rect.left + 1 > 0 && rect.bottom - rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, rect, &data->dest_tex->tex0, data->dest_x,
                                         dest_split_y - MG_TEX_ANIME_SUBTEXEL, 0);
                    }
                    rect.Set(src_split_x, src_split_y, src_end_x - MG_TEX_ANIME_SUBTEXEL,
                             src_end_y - MG_TEX_ANIME_SUBTEXEL);
                    if (rect.right - rect.left + 1 > 0 && rect.bottom - rect.top + 1 > 0) {
                        mgSetPkMoveImage(&data->src_tex->tex0, rect, &data->dest_tex->tex0, data->dest_x, data->dest_y, 0);
                    }
                } else {
                    short height = dest->height;
                    if (height % MG_TEX_ANIME_FRAME_ALIGN != 0) {
                        height += MG_TEX_ANIME_FRAME_ALIGN - height % MG_TEX_ANIME_FRAME_ALIGN;
                    }
                    mgSetPkFrameBuffer((int) dest->tex0.TBP0 / 32, (int) (dest->tex0.TBW * 64), height, dest->tex0.PSM);
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
        if (data->wait < 0) {
            frame[group] = 0;
        } else if (data->bug_patch != 0) {
            if (frame[group] >= data->wait) {
                frame[group] = 0;
                now[group] = node->next;
                if (now[group] == NULL) {
                    now[group] = list[group];
                }
            }
        } else if (frame[group] > data->wait) {
            frame[group] = 0;
            now[group] = node->next;
            if (now[group] == NULL) {
                now[group] = list[group];
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_tanime", TexAnime__15mgCTextureAnimeFiP13sceVif1Packet);
#endif
void mgCTextureAnime::Initialize() {
    group_num = MG_TEX_ANIME_GROUP_MAX;
    for (int i = 0; i < MG_TEX_ANIME_GROUP_MAX; i++) {
        DeleteGroup(i);
    }
}

mgCTextureAnime::mgCTextureAnime() {
    Initialize();
}

void mgCTextureAnime::SetGroupName(int group, char *group_name) {
    if (group < 0 || group >= group_num) {
        return;
    }
    name[group] = group_name;
}

int mgCTextureAnime::GetEmptyGroup() {
    for (int i = 0; i < group_num; i++) {
        if (list[i] == NULL) {
            return i;
        }
    }
    return -1;
}

int mgCTextureAnime::SearchGroupName(char *group_name) {
    if (group_name == NULL) {
        return -1;
    }
    for (int i = 0; i < group_num; i++) {
        if (name[i] != NULL && strcmp(name[i], group_name) == 0) {
            return i;
        }
    }
    return -1;
}

CList<mgCTexAnimeData> *mgCTextureAnime::NewTexAnimeData(mgCMemory *stack) {
    return new (stack->Alloc(6)) CList<mgCTexAnimeData>;
}

// Defined in the class body in mg_tanime.hpp.
CList<mgCTexAnimeData> *mgCTextureAnime::NewTexAnimeGroupData(int group, mgCMemory *stack) {
    if (group < 0 || group >= group_num) {
        return NULL;
    }

    CList<mgCTexAnimeData> *node = NewTexAnimeData(stack);
    if (node == NULL) {
        return NULL;
    }
    if (node->pGetData() == NULL) {
        return NULL;
    }
    node->Initialize();

    if (list[group] == NULL) {
        list[group] = node;
        now[group] = list[group];
    } else {
        CList<mgCTexAnimeData> *tail = list[group];
        while (tail != NULL && tail->next != NULL) {
            tail = tail->next;
        }
        tail->next = node;
        if (node != NULL) {
            node->prev = tail;
        }
    }
    return node;
}

int mgCTextureAnime::EnterTexAnime(mgCTexAnimeData *data, mgCMemory *stack) {
    CList<mgCTexAnimeData> *node = NewTexAnimeGroupData(data->group, stack);
    if (node == NULL) {
        return 0;
    }
    mgCTexAnimeData *entry = node->pGetData();
    if (entry == NULL) {
        return 0;
    }

    *entry = *data;
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
    char *name = spiGetStackString(&stack[0]);
    if (name != NULL) {
        char *copy = (char *) TexAnimeStack->Alloc((strlen(name) + 1) / MG_TEX_ANIME_NAME_ALLOC_UNIT + 1);
        strcpy(copy, name);
        group_name = copy;
    }
    ta_enable = spiGetStackInt(&stack[1]);
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
    nowTexData.type = spiGetStackInt(&stack[0]);
    spiGetStackString(&stack[1]);
    nowTexData.bug_patch = texBugPatch;
    return 1;
}

/**
 *
 * SRC_TEX(name, x, y, w, h): sets the record's source texture and rectangle, in texels.
 *
 */
int texSRC_TEX(SPI_STACK *stack, int argc) {
    char *name = spiGetStackString(&stack[0]);
    if (name == NULL) {
        return 0;
    }
    nowTexData.src_tex = TexManager->GetTexture(name, -1);
    nowTexData.src_x = spiGetStackInt(&stack[1]) * MG_TEX_ANIME_SUBTEXEL;
    nowTexData.src_y = spiGetStackInt(&stack[2]) * MG_TEX_ANIME_SUBTEXEL;
    nowTexData.src_w = spiGetStackInt(&stack[3]) * MG_TEX_ANIME_SUBTEXEL;
    nowTexData.src_h = spiGetStackInt(&stack[4]) * MG_TEX_ANIME_SUBTEXEL;

    if (nowTexData.src_tex != NULL) {
        if (now_texb < 0) {
            now_texb = nowTexData.src_tex->block;
        } else if (now_texb != nowTexData.src_tex->block) {
            printf("%s block is not match!!!\n", nowTexData.src_tex->name);
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
    char *name = spiGetStackString(&stack[0]);
    if (name == NULL) {
        return 0;
    }
    nowTexData.dest_tex = TexManager->GetTexture(name, -1);
    nowTexData.dest_x = spiGetStackInt(&stack[1]) * MG_TEX_ANIME_SUBTEXEL;
    nowTexData.dest_y = spiGetStackInt(&stack[2]) * MG_TEX_ANIME_SUBTEXEL;
    if (argc >= 4) {
        nowTexData.dest_w = spiGetStackInt(&stack[3]) * MG_TEX_ANIME_SUBTEXEL;
        nowTexData.dest_h = spiGetStackInt(&stack[4]) * MG_TEX_ANIME_SUBTEXEL;
        if (argc >= 6) {
            nowTexData.bilinear = spiGetStackInt(&stack[5]);
        }
    } else {
        nowTexData.dest_w = nowTexData.src_w;
        nowTexData.dest_h = nowTexData.src_h;
    }

    if (nowTexData.dest_tex != NULL) {
        if (now_texb < 0) {
            now_texb = nowTexData.dest_tex->block;
        } else if (now_texb != nowTexData.dest_tex->block) {
            printf("%s block is not match!!!\n", nowTexData.dest_tex->name);
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
    switch (nowTexData.type) {
    case MG_TEX_ANIME_TYPE_SCROLL: {
        float speed_x = 16.0f * spiGetStackFloat(&stack[0]);
        float speed_y = 16.0f * spiGetStackFloat(&stack[1]);
        nowTexData.period_x = (float) (nowTexData.dest_w - MG_TEX_ANIME_SUBTEXEL) / speed_x;
        nowTexData.period_y = (float) (nowTexData.dest_h - MG_TEX_ANIME_SUBTEXEL) / speed_y;
        break;
    }
    case MG_TEX_ANIME_TYPE_WAVE: {
        // The integer part is the period in frames, the fraction the amplitude.
        float wave_x = spiGetStackFloat(&stack[0]);
        float wave_y = spiGetStackFloat(&stack[1]);
        nowTexData.period_x = wave_x;
        nowTexData.period_y = wave_y;
        float amplitude_x = wave_x - nowTexData.period_x;
        float amplitude_y = wave_y - nowTexData.period_y;
        nowTexData.amplitude_x = 10000.0f * amplitude_x;
        nowTexData.amplitude_y = 10000.0f * amplitude_y;
        if (amplitude_x < 0.0f) {
            amplitude_x = -amplitude_x;
        }
        if (amplitude_x < 0.001f) {
            nowTexData.amplitude_x = MG_TEX_ANIME_AMPLITUDE_FULL;
        }
        if (amplitude_y < 0.0f) {
            amplitude_y = -amplitude_y;
        }
        if (amplitude_y < 0.001f) {
            nowTexData.amplitude_y = MG_TEX_ANIME_AMPLITUDE_FULL;
        }
        break;
    }
    default:
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
    nowTexData.clut_copy = spiGetStackInt(&stack[0]);
    return 1;
}

/**
 *
 * COLOR(r[, g[, b[, a]]]): sets the colour a drawn record is tinted with.
 *
 */
int texCOLOR(SPI_STACK *stack, int argc) {
    if (argc > 0) {
        nowTexData.r = spiGetStackInt(&stack[0]);
    }
    if (argc >= 2) {
        nowTexData.g = spiGetStackInt(&stack[1]);
    }
    if (argc >= 3) {
        nowTexData.b = spiGetStackInt(&stack[2]);
    }
    if (argc >= 4) {
        nowTexData.a = spiGetStackInt(&stack[3]);
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
        nowTexData.alpha_blend = spiGetStackInt(&stack[0]);
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
        nowTexData.alpha_test = spiGetStackInt(&stack[0]);
    }
    if (argc >= 2) {
        nowTexData.alpha_ref = spiGetStackInt(&stack[1]);
    }
    return 1;
}

/**
 *
 * WAIT(frames, forever[, name]): sets how long the record plays; the name is ignored.
 *
 */
int texWAIT(SPI_STACK *stack, int argc) {
    nowTexData.wait = spiGetStackInt(&stack[0]);
    if (spiGetStackInt(&stack[1]) != 0) {
        nowTexData.wait = MG_TEX_ANIME_WAIT_FOREVER;
    }
    if (argc >= 3) {
        spiGetStackString(&stack[2]);
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

#pragma schedule off
// Defined in the class body in mg_tanime.hpp.
template <>
void mgRect<int>::Set(int new_left, int new_top, int new_right, int new_bottom) {
    left = new_left;
    top = new_top;
    right = new_right;
    bottom = new_bottom;
}
#pragma schedule reset

// Static initialiser (.init)
// nowTexData, the one object constructed here, is defined with the file-local data at the top.
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_tanime", __sinit_mg_tanime_cpp);

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

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_tanime", D_0037AFE4__DATA);

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
INCLUDE_BSS(nowTexData, 0x40);
