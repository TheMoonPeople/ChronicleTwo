#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <limits>
#include <string_view>
#include <utility>

#include "log/game_output.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "render/renderer.hpp"
#include "render/texture_runtime.hpp"
#include "scriptinterpreter.hpp"

namespace {

/**
 *
 * Reads an integer that fits its texture-animation destination field.
 *
 */
template <class T>
T TextureTagInteger(dc2::script::TagArguments argument) {
    const int value = dc2::script::TagInteger(argument);
    if (!std::in_range<T>(value)) {
        throw dc2::script::ArgumentError("texture animation integer exceeds its field");
    }
    return static_cast<T>(value);
}

/**
 *
 * Converts a texel coordinate only when its sixteenth-texel value fits the record.
 *
 */
short TextureTagCoordinate(dc2::script::TagArguments argument) {
    const int value = dc2::script::TagInteger(argument);
    if (value < std::numeric_limits<short>::min() / MG_TEX_ANIME_SUBTEXEL ||
        value > std::numeric_limits<short>::max() / MG_TEX_ANIME_SUBTEXEL) {
        throw dc2::script::ArgumentError("texture animation coordinate exceeds its field");
    }
    return static_cast<short>(value * MG_TEX_ANIME_SUBTEXEL);
}

} // namespace

static int texTEX_ANIME(dc2::script::TagArguments args);

static int texTEX_ANIME_DATA(dc2::script::TagArguments stack, int argc);

static int texSRC_TEX(dc2::script::TagArguments stack, int argc);

static int texDEST_TEX(dc2::script::TagArguments stack, int argc);

static int texSCROLL(dc2::script::TagArguments stack, int argc);

static int texCLUT_COPY(dc2::script::TagArguments stack, int argc);

static int texCOLOR(dc2::script::TagArguments stack, int argc);

static int texALPHA_BLEND(dc2::script::TagArguments stack, int argc);

static int texALPHA_TEST(dc2::script::TagArguments stack, int argc);

static int texWAIT(dc2::script::TagArguments stack, int argc);

static int texTEX_ANIME_DATA_END(dc2::script::TagArguments stack, int argc);

static int texTEX_ANIME_END(dc2::script::TagArguments stack, int argc);

static int texBUG_PATCH(dc2::script::TagArguments stack, int argc);

/**
 *
 * Commands accepted by the texture-animation script loader.
 *
 */
static SPI_TAG_PARAM tex_tag[] = {
    {"TEX_ANIME",          dc2::script::AdaptTagArguments<texTEX_ANIME>         },
    {"TEX_ANIME_DATA",     dc2::script::AdaptTagArguments<texTEX_ANIME_DATA>    },
    {"SRC_TEX",            dc2::script::AdaptTagArguments<texSRC_TEX>           },
    {"DEST_TEX",           dc2::script::AdaptTagArguments<texDEST_TEX>          },
    {"SCROLL",             dc2::script::AdaptTagArguments<texSCROLL>            },
    {"CLUT_COPY",          dc2::script::AdaptTagArguments<texCLUT_COPY>         },
    {"COLOR",              dc2::script::AdaptTagArguments<texCOLOR>             },
    {"ALPHA_BLEND",        dc2::script::AdaptTagArguments<texALPHA_BLEND>       },
    {"ALPHA_TEST",         dc2::script::AdaptTagArguments<texALPHA_TEST>        },
    {"WAIT",               dc2::script::AdaptTagArguments<texWAIT>              },
    {"TEX_ANIME_DATA_END", dc2::script::AdaptTagArguments<texTEX_ANIME_DATA_END>},
    {"TEX_ANIME_END",      dc2::script::AdaptTagArguments<texTEX_ANIME_END>     },
    {"BUG_PATCH",          dc2::script::AdaptTagArguments<texBUG_PATCH>         },
    {nullptr,              nullptr                                              },
};

/**
 *
 * Default timing patch applied to new texture-animation records.
 *
 */
static int mgBugPatch;

/**
 *
 * Pauses advancement of every texture-animation group.
 *
 */
int mgCTextureAnime::stop_anime;

/**
 *
 * Animation receiving the current script record.
 *
 */
static mgCTextureAnime *pTexAnime;

/**
 *
 * Animation supplied to the texture script loader.
 *
 */
static mgCTextureAnime *pLoadTexAnime;

/**
 *
 * Group receiving the current texture-animation record.
 *
 */
static int now_group;

/**
 *
 * Texture manager used by the animation script loader.
 *
 */
static mgCTextureManager *TexManager;

/**
 *
 * Memory pool used to allocate texture-animation records and names.
 *
 */
static mgCMemory *TexAnimeStack;

/**
 *
 * Name of the group being assembled by the animation script.
 *
 */
static char *group_name;

/**
 *
 * Initial enable state of the current animation group.
 *
 */
static int ta_enable;

/**
 *
 * Texture block shared by the current animation record.
 *
 */
static int now_texb;

/**
 *
 * Timing patch requested for subsequent animation records.
 *
 */
static int texBugPatch;

/** Record the script is building. */
static mgCTexAnimeData nowTexData;

mgCTexAnimeData::mgCTexAnimeData() {
    Initialize();
}

void mgCTexAnimeData::Initialize() {
    type = MG_TEX_ANIME_TYPE_NONE;
    group = 0;
    wait = 0;
    clut_copy = 0;
    dest_tex = nullptr;
    src_tex = nullptr;
    src_h = 0;
    src_w = 0;
    src_y = 0;
    src_x = 0;
    dest_y = 0;
    dest_x = 0;
    dest_w = 0;
    dest_h = 0;
    phase_y = 0;
    phase_x = 0;
    period_y = 0;
    period_x = 0;
    amplitude_y = 0;
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

void mgCTextureAnime::Initialize() {
    group_num = MG_TEX_ANIME_GROUP_MAX;

    for (int i = 0; i < MG_TEX_ANIME_GROUP_MAX; i++) {
        list[i] = nullptr;
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
        if (list[i] == nullptr) {
            return i;
        }
    }

    return -1;
}

int mgCTextureAnime::SearchGroupName(char *group_name) {
    if (group_name == nullptr) {
        return -1;
    }

    for (int i = 0; i < group_num; i++) {
        char *candidate = name[i];

        if (candidate != nullptr && strcmp(candidate, group_name) == 0) {
            return i;
        }
    }

    return -1;
}

CList<mgCTexAnimeData> *mgCTextureAnime::NewTexAnimeData(mgCMemory *stack) {
    return stack != nullptr ? dc2::memory::NewObject<CList<mgCTexAnimeData>>(*stack) : nullptr;
}

/**
 *
 * Four colour channels used by a texture animation.
 *
 */
struct mgTexAnimeColor {
    u_char channel[4]; /**< Colour channels. */
};

int mgCTextureAnime::EnterTexAnime(mgCTexAnimeData *data, mgCMemory *stack) {
    CList<mgCTexAnimeData> *node = NewTexAnimeGroupData(data->group, stack);

    if (node == nullptr) {
        return 0;
    }

    mgCTexAnimeData *entry = node->pGetData();

    if (entry == nullptr) {
        return 0;
    }

    entry->type = data->type;
    entry->group = data->group;
    entry->link_group = data->link_group;
    entry->clut_copy = data->clut_copy;
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
    entry->bilinear = data->bilinear;
    entry->alpha_blend = data->alpha_blend;
    entry->alpha_test = data->alpha_test;
    entry->alpha_ref = data->alpha_ref;
    *(mgTexAnimeColor *) &entry->r = *(mgTexAnimeColor *) &data->r;

    // Scripts give rectangles from the top of the texture; the records keep them from the bottom.
    if (entry->src_tex != nullptr && entry->dest_tex != nullptr) {
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
    list[group] = nullptr;
    now[group] = nullptr;
    name[group] = nullptr;
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
        return nullptr;
    }

    return list[group];
}

void mgCTextureManager::LoadCFGFile(char *script, int size, mgCMemory *stack, mgCTextureAnime *anime) {
    pTexAnime = nullptr;
    pLoadTexAnime = anime;
    group_name = nullptr;
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
int texTEX_ANIME(dc2::script::TagArguments args) {
    const std::string_view name = dc2::script::TagText(args++);
    const int              enable = dc2::script::TagInteger(args);
    if (TexAnimeStack == nullptr) {
        return 0;
    }
    char *copy = dc2::memory::NewArray<char>(*TexAnimeStack, name.size() + 1);
    if (copy == nullptr) {
        return 0;
    }
    std::memcpy(copy, name.data(), name.size());
    copy[name.size()] = '\0';
    group_name = copy;
    ta_enable = enable;
    return 1;
}

/**
 *
 * TEX_ANIME_DATA(type, name): starts a new record of the given mgTEX_ANIME_TYPE; the name is ignored.
 *
 */
int texTEX_ANIME_DATA(dc2::script::TagArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    now_texb = -1;
    nowTexData.Initialize();
    nowTexData.type = TextureTagInteger<decltype(nowTexData.type)>(stack++);
    dc2::script::TagCString(stack++);
    nowTexData.bug_patch = texBugPatch;
    return 1;
}

/**
 *
 * SRC_TEX(name, x, y, w, h): sets the record's source texture and rectangle, in texels.
 *
 */
int texSRC_TEX(dc2::script::TagArguments stack, int argc) {
    if (argc != 5) {
        return 0;
    }
    char *name = dc2::script::TagCString(stack++);

    if (name == nullptr) {
        return 0;
    }

    nowTexData.src_tex = TexManager->GetTexture(name, -1);
    nowTexData.src_x = TextureTagCoordinate(stack++);
    nowTexData.src_y = TextureTagCoordinate(stack++);
    nowTexData.src_w = TextureTagCoordinate(stack++);
    nowTexData.src_h = TextureTagCoordinate(stack++);

    if (nowTexData.src_tex != nullptr) {
        if (now_texb < 0) {
            now_texb = nowTexData.src_tex->block;
        } else if (now_texb != nowTexData.src_tex->block) {
            dc2::log::PrintGame("%s block is not match!!!\n", nowTexData.src_tex->name);
        }
    }

    return 1;
}

/**
 *
 * DEST_TEX(name, x, y[, w, h[, bilinear]]): sets the record's destination texture and rectangle, in texels.
 *
 */
int texDEST_TEX(dc2::script::TagArguments stack, int argc) {
    if (argc != 3 && argc != 5 && argc != 6) {
        return 0;
    }
    char *name = dc2::script::TagCString(stack++);

    if (name == nullptr) {
        return 0;
    }

    nowTexData.dest_tex = TexManager->GetTexture(name, -1);
    nowTexData.dest_x = TextureTagCoordinate(stack++);
    nowTexData.dest_y = TextureTagCoordinate(stack++);

    if (argc > 3) {
        nowTexData.dest_w = TextureTagCoordinate(stack++);
        nowTexData.dest_h = TextureTagCoordinate(stack++);

        if (argc > 5) {
            nowTexData.bilinear = TextureTagInteger<decltype(nowTexData.bilinear)>(stack++);
        }
    } else {
        nowTexData.dest_w = nowTexData.src_w;
        nowTexData.dest_h = nowTexData.src_h;
    }

    if (nowTexData.dest_tex != nullptr) {
        if (now_texb < 0) {
            now_texb = nowTexData.dest_tex->block;
        } else if (now_texb != nowTexData.dest_tex->block) {
            dc2::log::PrintGame("%s block is not match!!!\n", nowTexData.dest_tex->name);
        }
    }

    return 1;
}

/**
 *
 * SCROLL(x, y): sets a scroll record's speeds in texels per frame, or a wave record's periods and amplitudes.
 *
 */
int texSCROLL(dc2::script::TagArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    signed char mode = nowTexData.type;

    if (mode == 1) {
        float speed_x = 16.0f * dc2::script::TagFloat(stack++);
        float speed_y = 16.0f * dc2::script::TagFloat(stack);
        nowTexData.period_x = fptosi((float) (nowTexData.dest_w - 16) / speed_x);
        nowTexData.period_y = fptosi((float) (nowTexData.dest_h - 16) / speed_y);
    } else if (mode == 2) {
        float value_x = {};
        float value_y = {};
        float fraction_y = {};
        float fraction_x = {};
        value_x = dc2::script::TagFloat(stack++);
        value_y = dc2::script::TagFloat(stack);
        int whole_x = fptosi(value_x);
        nowTexData.period_x = whole_x;
        int whole_y = fptosi(value_y);
        nowTexData.period_y = whole_y;
        fraction_x = value_x - (float) whole_x;
        fraction_y = value_y - (float) whole_y;
        nowTexData.amplitude_x = fptosi(10000.0f * fraction_x);
        nowTexData.amplitude_y = fptosi(10000.0f * fraction_y);

        if (fraction_x < 0.0f) {
            fraction_x = -fraction_x;
        }

        if (fraction_x < 0.001f) {
            nowTexData.amplitude_x = 10000;
        }

        if (fraction_y < 0.0f) {
            fraction_y = -fraction_y;
        }

        if (fraction_y < 0.001f) {
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
int texCLUT_COPY(dc2::script::TagArguments stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    nowTexData.clut_copy = TextureTagInteger<decltype(nowTexData.clut_copy)>(stack++);
    return 1;
}

/**
 *
 * COLOR(r[, g[, b[, a]]]): sets the colour a drawn record is tinted with.
 *
 */
int texCOLOR(dc2::script::TagArguments stack, int argc) {
    if (argc < 0 || argc > 4) {
        return 0;
    }
    if (argc > 0) {
        nowTexData.r = TextureTagInteger<decltype(nowTexData.r)>(stack++);
    }

    if (argc > 1) {
        nowTexData.g = TextureTagInteger<decltype(nowTexData.g)>(stack++);
    }

    if (argc > 2) {
        nowTexData.b = TextureTagInteger<decltype(nowTexData.b)>(stack++);
    }

    if (argc > 3) {
        nowTexData.a = TextureTagInteger<decltype(nowTexData.a)>(stack++);
    }

    return 1;
}

/**
 *
 * ALPHA_BLEND(mode): sets the alpha blending mode a drawn record uses.
 *
 */
int texALPHA_BLEND(dc2::script::TagArguments stack, int argc) {
    if (argc < 0 || argc > 1) {
        return 0;
    }
    if (argc > 0) {
        nowTexData.alpha_blend = TextureTagInteger<decltype(nowTexData.alpha_blend)>(stack++);
    }

    return 1;
}

/**
 *
 * ALPHA_TEST(method[, ref]): sets the alpha test a drawn record uses.
 *
 */
int texALPHA_TEST(dc2::script::TagArguments stack, int argc) {
    if (argc < 0 || argc > 2) {
        return 0;
    }
    if (argc > 0) {
        nowTexData.alpha_test = TextureTagInteger<decltype(nowTexData.alpha_test)>(stack++);
    }

    if (argc > 1) {
        nowTexData.alpha_ref = TextureTagInteger<decltype(nowTexData.alpha_ref)>(stack++);
    }

    return 1;
}

/**
 *
 * WAIT(frames, forever[, name]): sets how long the record plays; the name is ignored.
 *
 */
int texWAIT(dc2::script::TagArguments stack, int argc) {
    if (argc != 2 && argc != 3) {
        return 0;
    }
    nowTexData.wait = TextureTagInteger<decltype(nowTexData.wait)>(stack++);

    if (dc2::script::TagInteger(stack++) != 0) {
        nowTexData.wait = MG_TEX_ANIME_WAIT_FOREVER;
    }

    if (argc > 2) {
        dc2::script::TagCString(stack++);
    }

    return 1;
}

/**
 *
 * TEX_ANIME_DATA_END: enters the record built so far into the current group of its texture block's animation.
 *
 */
int texTEX_ANIME_DATA_END(dc2::script::TagArguments stack, int argc) {
    if (argc != 0) {
        return 0;
    }
    if (now_texb < 0) {
        return 0;
    }

    mgCTextureBlock *block = TexManager->GetTextureBlock(now_texb);

    if (block == nullptr) {
        return 0;
    }

    pTexAnime = block->anime;

    if (pTexAnime == nullptr) {
        if (pLoadTexAnime == nullptr) {
            if (TexAnimeStack == nullptr) {
                return 0;
            }
            block->anime = dc2::memory::NewObject<mgCTextureAnime>(*TexAnimeStack);
            if (block->anime == nullptr) {
                return 0;
            }
            pTexAnime = block->anime;
        } else {
            pTexAnime = pLoadTexAnime;
        }

        if (pTexAnime != nullptr) {
            now_group = pTexAnime->GetEmptyGroup();
        }
    } else if (now_group < 0) {
        now_group = pTexAnime->GetEmptyGroup();
    }

    if (pTexAnime != nullptr && now_group >= 0) {
        nowTexData.group = now_group;
        pTexAnime->SetGroupName(now_group, group_name);

        if (ta_enable != 0) {
            pTexAnime->Enable(now_group);
        } else {
            pTexAnime->Disable(now_group);
        }

        if (nowTexData.src_tex != nullptr && nowTexData.dest_tex != nullptr) {
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
int texTEX_ANIME_END(dc2::script::TagArguments stack, int argc) {
    if (argc != 0) {
        return 0;
    }
    now_group = -1;

    if (pTexAnime != nullptr) {
        now_group = pTexAnime->GetEmptyGroup();
    }

    return 1;
}

/**
 *
 * BUG_PATCH: makes every following record end after exactly its wait frames.
 *
 */
int texBUG_PATCH(dc2::script::TagArguments stack, int argc) {
    if (argc != 0) {
        return 0;
    }
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

void mgCTextureAnime::TexAnime(int texb, sceVif1Packet * /*unused*/) {
    int                     i = 0;
    int                     group = 0;
    CList<mgCTexAnimeData> *node = nullptr;
    mgCTexAnimeData        *data = nullptr;

    // TEXFLUSH has no PC counterpart: the renderer keeps no texture cache to invalidate.
    // TA0 = TA1 = 0x80: alpha of 24-bit and 16-bit texels.
    mgPortGs().texa = 0x80 | (static_cast<uint64_t>(0x80) << 32);

    for (i = 0; i < group_num; i++) {
        if (enable[i] != 0) {
            CList<mgCTexAnimeData> *linked_node = now[i];

            if (linked_node != nullptr) {
                mgCTexAnimeData *linked_data = linked_node->pGetData();

                if (linked_data != nullptr && linked_data->link_group >= 0) {
                    Enable(linked_data->link_group);
                }
            }
        }
    }

    mgCDrawPrim prim;
    prim.Initialize(nullptr, nullptr);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.DepthTest(MG_DEPTH_TEST_ALWAYS);
    prim.TextureMapEnable(1);

    for (group = 0; group < group_num; group++) {
        if (enable[group] == 0) {
            continue;
        }

        if (now[group] == nullptr) {
            continue;
        }

        node = now[group];
        data = node->pGetData();

        if (data == nullptr || data->src_tex == nullptr || data->dest_tex == nullptr) {
            continue;
        }

        if (data->src_tex->block != texb || data->dest_tex->block != texb) {
            continue;
        }

        // Records that wait no frames play together with the record after them.
        for (;;) {
            MgTexturePrepareAnimationDestination(data->src_tex, data->dest_tex);
            if (MgTextureAnimationMode(data->dest_tex) == texture_catalog::AnimationMode::Draw) {
                prim.Bilinear(data->bilinear != 0 ? 1 : 0);

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
                int src_split_x = 0;
                int src_split_y = 0;
                int dest_split_x = 0;
                int dest_split_y = 0;
                int src_end_x = 0;
                int src_end_y = 0;
                int dest_end_x = 0;
                int dest_end_y = 0;

                if (MgTextureAnimationMode(data->dest_tex) != texture_catalog::AnimationMode::Draw) {
                    int src_left = data->src_x / MG_TEX_ANIME_SUBTEXEL;
                    int src_top = data->src_y / MG_TEX_ANIME_SUBTEXEL;
                    int src_width = data->src_w / MG_TEX_ANIME_SUBTEXEL;
                    int src_height = data->src_h / MG_TEX_ANIME_SUBTEXEL;
                    int dest_left = data->dest_x / MG_TEX_ANIME_SUBTEXEL;
                    int dest_top = data->dest_y / MG_TEX_ANIME_SUBTEXEL;
                    int dest_width = data->dest_w / MG_TEX_ANIME_SUBTEXEL;
                    int dest_height = data->dest_h / MG_TEX_ANIME_SUBTEXEL;
                    int offset_x = 0;
                    int offset_y = 0;

                    // Retail bug, kept: paletted waves get zero offsets.
                    if (data->type == MG_TEX_ANIME_TYPE_SCROLL) {
                        float period_x = data->period_x;
                        period_x = period_x < 0.0f ? -period_x : period_x;
                        offset_x = static_cast<float>((dest_width - 1) * data->phase_x) / period_x;
                        float numerator_y = NAN;
                        float period_y = NAN;
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

                    src_split_x = std::max(src_split_x, src_left);

                    src_split_y = std::max(src_split_y, src_top);

                    dest_split_x = std::max(dest_split_x, dest_left);

                    dest_split_y = std::max(dest_split_y, dest_top);

                    src_split_x = std::min(src_split_x, src_end_x);

                    src_split_y = std::min(src_split_y, src_end_y);

                    dest_split_x = std::min(dest_split_x, dest_end_x);

                    dest_split_y = std::min(dest_split_y, dest_end_y);

                    src_split_x *= MG_TEX_ANIME_SUBTEXEL;
                    src_split_y *= MG_TEX_ANIME_SUBTEXEL;
                    dest_split_x *= MG_TEX_ANIME_SUBTEXEL;
                    dest_split_y *= MG_TEX_ANIME_SUBTEXEL;
                    src_end_x *= MG_TEX_ANIME_SUBTEXEL;
                    src_end_y *= MG_TEX_ANIME_SUBTEXEL;
                    dest_end_x *= MG_TEX_ANIME_SUBTEXEL;
                    dest_end_y *= MG_TEX_ANIME_SUBTEXEL;
                } else {
                    int offset_x = 0;
                    int offset_y = 0;

                    if (data->type == MG_TEX_ANIME_TYPE_SCROLL) {
                        float period_x = data->period_x;
                        period_x = period_x < 0.0f ? -period_x : period_x;
                        offset_x = static_cast<float>(data->dest_w * data->phase_x) / period_x;
                        float numerator_y = NAN;
                        float period_y = NAN;
                        period_y = data->period_y;
                        numerator_y = data->dest_h * data->phase_y;
                        period_y = period_y < 0.0f ? -period_y : period_y;
                        offset_y = numerator_y / period_y;
                    } else {
                        offset_x = static_cast<float>(data->dest_w) *
                                   (static_cast<float>(data->amplitude_x) *
                                    ((1.0f + sinf(TWO_PI * static_cast<float>(data->phase_x) / static_cast<float>(data->period_x))) / 2.0f) /
                                    static_cast<float>(MG_TEX_ANIME_AMPLITUDE_FULL));
                        offset_y = static_cast<float>(data->dest_h) *
                                   (static_cast<float>(data->amplitude_y) *
                                    ((1.0f + sinf(TWO_PI * static_cast<float>(data->phase_y) / static_cast<float>(data->period_y))) / 2.0f) /
                                    static_cast<float>(MG_TEX_ANIME_AMPLITUDE_FULL));
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

            if (data->wait != 0 || node->next == nullptr) {
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

                if (now[group] == nullptr) {
                    now[group] = list[group];
                }
            }
        } else {
            if (frame[group] > wait) {
                frame[group] = 0;
                CList<mgCTexAnimeData> *next = node->next;
                now[group] = next;

                if (now[group] == nullptr) {
                    now[group] = list[group];
                }
            }
        }
    }

    // Retail's epilogue flushes the texture cache and restores nothing, so TEXA stays as set above.
}

// Retail indexes list[group] with a 4-byte pointer stride ((group << 2) + this + 0x64), which a host pointer breaks.
CList<mgCTexAnimeData> *mgCTextureAnime::NewTexAnimeGroupData(int group, mgCMemory *stack) {
    if (group < 0 || group >= group_num) {
        return nullptr;
    }

    CList<mgCTexAnimeData> *node = NewTexAnimeData(stack);

    if (node == nullptr || node->pGetData() == nullptr) {
        return nullptr;
    }

    node->Initialize();

    if (list[group] == nullptr) {
        list[group] = node;
        now[group] = node;
        return node;
    }

    CList<mgCTexAnimeData> *tail = list[group];

    while (tail->next != nullptr) {
        tail = tail->next;
    }

    tail->next = node;
    node->prev = tail;
    return node;
}
