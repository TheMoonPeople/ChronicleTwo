#include "common.h"
#include "mw_runtime.h"

#include <array>
#include <cstring>
#include <limits>
#include <string>

#include "asset_directory.hpp"
#include "dataread.hpp"
#include "effect.hpp"
#include "effectlist.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scriptinterpreter.hpp"

void DivSpriteScreen(mgCDrawPrim &prim);
void DivSpriteScreen(mgCDrawPrim &prim, int left, int right, int mode);

int CEffectList::SaerchEffectIndex(char *name) {
    int i = {};

    for (i = 0; i < effect_num; i++) {
        if (strcmp(name, managers[i].name) == 0) {
            return i;
        }
    }

    return -1;
}

mgC3DSprite *CEffectList::GetEffectVisual(int index) {
    if (index < 0 || index >= effect_num) {
        return nullptr;
    }

    return sprites + index;
}

void CEffectList::Step() {
    int i = {};

    for (i = 0; i < effect_num; i++) {
        managers[i].Ctrl();
        managers[i].Step(1);
    }
}

void CEffectList::CreatePacket() {
    int i = {};

    for (i = 0; i < effect_num; i++) {
        managers[i].CreatePacket(sprites + i);
    }
}

void CEffectManager::CreatePacket(mgC3DSprite *sprite) {
    if (sprite == nullptr) {
        return;
    }

    mgCDrawEnv  env = *mgGetpDrawEnv(0);
    mgCTexture *last_texture = {};
    mgCTexture *texture = {};
    int         last_blend = {};
    int         blend = {};
    CEffect    *particle = {};
    int         first = {};
    int         texture_changed = {};
    int         blend_changed = {};
    int         i = {};

    sceGsTest *test = &env.test;
    test->bits.zte = 1;
    test->bits.ztst = SCE_GS_ZGEQUAL;
    env.SetZBuf(MG_ZBUF_NO_WRITE);
    env.SetAlpha(MG_ALPHA_MACRO_ADD);
    sprite->BeginCreatePacket(MG_3DSPRITE_MODE_ROTATE, nullptr);
    sprite->CPSetDrawEnv(&env);
    sprite->BeginCPSprite();
    sceVu0FVECTOR size = {0.0f, 0.0f, 0.0f, 0.0f};
    sceVu0FVECTOR color = {128.0f, 128.0f, 128.0f, 128.0f};
    sceVu0FVECTOR uv0;
    sceVu0FVECTOR uv1;
    mgZeroVector(uv0);
    mgZeroVector(uv1);
    last_texture = nullptr;
    last_blend = MG_ALPHA_MACRO_ADD;
    first = 1;

    for (i = 0; i < effect_num; i++) {
        particle = &effects[i];

        if (particle->active) {
            texture = particle->param.texture;

            if (texture != nullptr) {
                if (particle->param.alpha_blend == EFFECT_ALPHA_BLEND_ADD) {
                    blend = MG_ALPHA_MACRO_ADD;
                } else if (particle->param.alpha_blend == EFFECT_ALPHA_BLEND_SUB) {
                    blend = MG_ALPHA_MACRO_SUB;
                } else {
                    blend = MG_ALPHA_MACRO_OPAQUE;
                }

                size[0] = particle->param.width * particle->scale[0];
                size[1] = particle->param.height * particle->scale[0];
                color[3] = 128.0f * particle->alpha;
                texture_changed = 0;
                blend_changed = 0;

                if (last_texture != texture) {
                    texture_changed = 1;
                }

                if (first || last_blend != blend) {
                    blend_changed = 1;
                }

                first = 0;

                if (texture_changed || blend_changed) {
                    sprite->EndCPSprite();
                    env.SetAlpha(blend);

                    if (blend_changed) {
                        sprite->CPSetDrawEnv(&env);
                    }

                    sprite->CPSetTexture(texture);
                    sprite->BeginCPSprite();
                }

                last_texture = texture;
                last_blend = blend;
                uv0[0] = particle->tex_rect[0];
                uv0[1] = particle->tex_rect[1];
                uv1[0] = particle->tex_rect[0] + particle->tex_rect[2] - 1;
                uv1[1] = particle->tex_rect[1] + particle->tex_rect[3] - 1;
                particle->pos[3] = 1.0f;
                sprite->CPSetSprite(particle->pos, size, color, uv0, uv1);
            }
        }
    }

    sprite->EndCPSprite();
    sprite->EndCreatePacket();
}

void CFadeInOut::Initialize() {
    alpha = 0.0f;
    b = 0.0f;
    g = 0.0f;
    r = 0.0f;
    mode = FADE_MODE_NONE;
    speed = 0.0f;
    end = 0;
    cross = 0;
    cross_texture = nullptr;
    blur_alpha = 0;
}

void CFadeInOut::ResetFade() {
    mode = FADE_MODE_NONE;
    alpha = 0.0f;
    cross = 0;
}

void CFadeInOut::FadeIn(int frames, float r, float g, float b) {
    if ((mode == FADE_MODE_NONE) || (frames < 0)) {
        alpha = 128.0f;
    }

    mode = FADE_MODE_IN;
    end = 0;

    if (frames < 0) {
        speed = 0.0f;
    } else {
        speed = 128.0f / static_cast<float>(frames);
    }

    this->r = r;
    this->g = g;
    this->b = b;
    cross = 0;
}

void CFadeInOut::FadeIn(int frames) {
    if (mode >= FADE_MODE_NONE) {
        FadeIn(frames, 0.0f, 0.0f, 0.0f);
    } else {
        FadeIn(frames, r, g, b);
    }
}

void CFadeInOut::FadeOut(int frames, float r, float g, float b) {
    if ((mode == FADE_MODE_NONE) || (frames < 0)) {
        alpha = 0.0f;
    }

    mode = FADE_MODE_OUT;
    end = 0;

    if (frames < 0) {
        speed = 0.0f;
    } else {
        speed = 128.0f / static_cast<float>(frames);
    }

    this->r = r;
    this->g = g;
    this->b = b;
    cross = 0;
}

void CFadeInOut::CrossFade(int duration, float alpha) {
    CrossFadeIn(CROSS_FADE_DISSOLVE, duration, alpha);
}

void CFadeInOut::CrossFadeIn(int mode, int frames, float value) {
    cross_type = mode;
    FadeIn(frames, 128.0f, 128.0f, 128.0f);
    cross = 1;
    cross_alpha_rate = value;
}

void CFadeInOut::CrossFadeOut(int mode, int frames, float value) {
    cross_type = mode;
    FadeOut(frames, 128.0f, 128.0f, 128.0f);
    alpha = 0.0f;
    cross = 1;
    cross_alpha_rate = value;
}

int CFadeInOut::FadeCheck() { return this->end; }

int CFadeInOut::NowFade() {
    return mode != FADE_MODE_NONE;
}

int CFadeInOut::FadeStep() {
    if (mode == FADE_MODE_NONE) {
        return 1;
    }

    if (mode > FADE_MODE_NONE) {
        alpha -= speed;

        if (alpha <= 0.0f) {
            alpha = 0.0f;
            mode = FADE_MODE_NONE;
            end = 1;
        }
    } else {
        alpha += speed;

        if (!(alpha < 128.0f)) {
            alpha = 128.0f;
            end = 1;
        }
    }

    if (end != 0 && cross != 0 && cross_type == CROSS_FADE_WIPE) {
        alpha = 0.0f;
    }

    return end;
}

void CFadeInOut::SetCrossTexture(mgCTexture *texture, u_long128 *image) {
    if (texture != nullptr) {
        cross_texture = texture;

        (*(mgCTexture *volatile *) &cross_texture)->image[0] = image;
    }
}

void DivSpriteScreen(mgCDrawPrim &prim);

void DivSpriteScreen(mgCDrawPrim &prim, int left, int right, int jagged_left);

void CFadeInOut::Draw() {
    if (alpha > 0.0f) {
        mgCDrawPrim prim;
        prim.Initialize(nullptr, nullptr);
        prim.DepthTestEnable(0);
        prim.AlphaTestEnable(0);
        prim.AlphaBlendEnable(1);
        prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
        prim.ZMask(MG_Z_MASK_MASKED);

        if (cross != 0) {
            if (cross_texture != nullptr) {
                cross_texture->tex0.bits.tcc = 0;
                mgTexManager.ReloadTexture(cross_texture->block, (sceVif1Packet *) nullptr);
                prim.TextureMapEnable(1);

                if (cross_type == CROSS_FADE_WIPE) {
                    prim.Begin2();
                    prim.BeginPrim2(6);
                    prim.Texture(cross_texture);

                    prim.Direct(SCE_GS_TEXA, 0x8080 | (static_cast<u_long>(0x80) << 32));
                    prim.Color(0x80, 0x80, 0x80, 0x80);
                    prim.EndPrim2();

                    if (mode > 0) {
                        DivSpriteScreen(prim, 0,
                                        fptosi((alpha / 128.0f) * static_cast<float>(mgScreenWidth)), 0);
                    } else {
                        int width = mgScreenWidth;

                        DivSpriteScreen(prim, fptosi((alpha / 128.0f) * static_cast<float>(width)),
                                        width, 1);
                    }

                    prim.End2();
                } else {
                    int b = {};
                    int g = {};
                    int r = {};

                    prim.Begin2();
                    prim.BeginPrim2(6);
                    prim.Texture(cross_texture);

                    prim.Direct(SCE_GS_TEXA, 0x8080 | (static_cast<u_long>(0x80) << 32));
                    r = fptosi(this->r);
                    g = fptosi(this->g);
                    b = fptosi(this->b);
                    prim.Color(r, g, b, fptosi(alpha * cross_alpha_rate));
                    prim.EndPrim2();
                    DivSpriteScreen(prim);
                    prim.End2();
                }
            }
        } else {
            int b = {};
            int g = {};
            int r = {};

            prim.TextureMapEnable(0);
            prim.Begin2();
            prim.BeginPrim2(6);
            r = fptosi(this->r);
            g = fptosi(this->g);
            b = fptosi(this->b);
            prim.Color(r, g, b, fptosi(alpha));
            prim.EndPrim2();
            DivSpriteScreen(prim);
            prim.End2();
        }
    }

    if (blur_alpha != 0) {
        mgCDrawPrim prim2;
        prim2.Initialize(nullptr, nullptr);
        mgCTexture back_tex;

        mgGetFrameBackBuffer(&back_tex);
        back_tex.tex0.bits.tcc = 0;
        prim2.TextureMapEnable(1);
        prim2.AlphaBlendEnable(1);
        prim2.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
        prim2.DepthTestEnable(0);
        prim2.ZMask(MG_Z_MASK_MASKED);
        prim2.Begin(MG_PRIM_SPRITE);

        prim2.Direct(SCE_GS_TEXA, 0x80 | (static_cast<u_long>(0x80) << 32));
        prim2.Texture(&back_tex);
        prim2.Color(0x80, 0x80, 0x80, blur_alpha);
        prim2.TextureCrd(0, 0);
        prim2.Vertex(0, 0, 0);
        prim2.TextureCrd(back_tex.width, back_tex.height);
        prim2.Vertex(back_tex.width, back_tex.height, 0);
        prim2.End();
    }
}

#include "common.h"

#include <algorithm>
#include <cstring>
#include <string>
#include <string_view>
#include <vector>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "effect.hpp"
#include "effectlist.hpp"
#include "mg_drawprim.hpp"
#include "mglib.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "render/texture_runtime.hpp"
#include "text/bounded.hpp"

void CFadeInOut::CaptureScreen() {
    if (cross_texture == nullptr || cross_texture->image[0] == nullptr || !mgPortRendererReady()) {
        return;
    }

    // Blit on the GPU: a CPU store followed by a pointer-only texture reload can keep an earlier scene.
    const gfx::TextureHandle target = mgPortRenderTarget(cross_texture, true);
    if (target != gfx::kNullTexture) {
        gfx::BlitTexture(gfx::kPreviousFrame,
                         gfx::Rect{.x = 0, .y = 0, .w = static_cast<int>(gfx::LogicalWidth()), .h = static_cast<int>(gfx::LogicalHeight())},
                         target, gfx::Rect{.x = 0, .y = 0, .w = cross_texture->width, .h = cross_texture->height}, gfx::Filter::Nearest);
    }
}

namespace {

gfx::Vertex2D EdgeVertex(const mgCDrawPrim &prim, float x, float y, const uint8_t rgba[4]) {
    return mgPortPrimVertex(prim, x, y, 0.0f, x, y, rgba, 0);
}

// Corner order matches the builder's own sprite assembly: top-left, top-right, bottom-right, bottom-left.
void AppendSprite(std::vector<gfx::Vertex2D> &out, const mgCDrawPrim &prim, float x0, float y0, float x1, float y1,
                  const uint8_t rgba[4]) {
    out.push_back(EdgeVertex(prim, x0, y0, rgba));
    out.push_back(EdgeVertex(prim, x1, y0, rgba));
    out.push_back(EdgeVertex(prim, x1, y1, rgba));
    out.push_back(EdgeVertex(prim, x0, y1, rgba));
}

} // namespace

void DivSpriteScreen(mgCDrawPrim &prim) {
    uint8_t rgba[4];
    mgPortPrimColor(prim, rgba);

    std::vector<gfx::Vertex2D> quads;

    for (int x = 0; x < mgScreenWidth; x += 64) {
        for (int y = 0; y < mgScreenHeight; y += 32) {
            AppendSprite(quads, prim, static_cast<float>(x), static_cast<float>(y), static_cast<float>(x + 64),
                         static_cast<float>(y + 32), rgba);
        }
    }

    mgPortPrimSubmit(prim, gfx::Primitive::Quads, quads);
}

void DivSpriteScreen(mgCDrawPrim &prim, int left, int right, int jagged_left) {
    uint8_t rgba[4];
    mgPortPrimColor(prim, rgba);

    const int                  row_height = mgScreenHeight / 16;
    const int                  edge_offset[2] = {-10, 10};
    std::vector<gfx::Vertex2D> strip;

    for (int row = 0; row < 17; row++) {
        const auto y = static_cast<float>(row * row_height);
        const int  left_x = std::max(0, jagged_left ? left + edge_offset[row % 2] : left);
        const int  right_x = std::max(0, jagged_left ? right : right + edge_offset[row % 2]);
        strip.push_back(EdgeVertex(prim, static_cast<float>(left_x), y, rgba));
        strip.push_back(EdgeVertex(prim, static_cast<float>(right_x), y, rgba));
    }

    std::vector<gfx::Vertex2D> triangles;
    mgPortStripTriangles(strip, triangles);
    mgPortPrimSubmit(prim, gfx::Primitive::Triangles, triangles);
}

void CEffectList::LoadEFPFile(const dc2::io::FileRead &directory, int block, mgCMemory *stack) {
    std::array<int, 64> particle_counts{};
    std::array<int, 64> ctrl_counts{};
    this->block = block;
    this->name = nullptr;
    managers = nullptr;
    sprites = nullptr;
    effect_num = 0;
    if (!dc2::assets::DirectoryPath(directory) || stack == nullptr || stack->lock != 0 || dc2::memory::RemainingBytes(*stack).empty()) {
        return;
    }

    const auto name_text = directory.Name();
    const auto files = dc2::assets::ReadDirectoryMembers(directory, "em");
    if (files.size() > particle_counts.size()) {
        return;
    }
    const int         count = static_cast<int>(files.size());
    const std::size_t available = dc2::memory::RemainingBytes(*stack).size() / sizeof(u_long128);
    std::size_t       required = 0;
    const auto        account = [&](std::size_t entries, std::size_t width, std::size_t extra) {
        if (entries > std::numeric_limits<std::size_t>::max() / width) {
            return false;
        }
        const std::size_t bytes = entries * width;
        const std::size_t blocks = bytes / sizeof(u_long128) + (bytes % sizeof(u_long128) != 0);
        if (blocks > static_cast<std::size_t>(std::numeric_limits<int>::max()) - extra ||
            blocks + extra >= available - required) {
            return false;
        }
        required += blocks + extra;
        return true;
    };
    if (!account(name_text.size() + 1, 1, 0) ||
        !account(static_cast<std::size_t>(count), sizeof(CEffectManager), 2) ||
        !account(static_cast<std::size_t>(count), sizeof(mgC3DSprite), 2)) {
        return;
    }
    for (int i = 0; i < count; ++i) {
        CEffectManager probe;
        probe.GetBufferNums(reinterpret_cast<char *>(files[static_cast<std::size_t>(i)].read.Bytes().data()), files[static_cast<std::size_t>(i)].read.Size(), &particle_counts[i], &ctrl_counts[i]);
        if (particle_counts[i] < 0 || ctrl_counts[i] < 0 ||
            !account(static_cast<std::size_t>(particle_counts[i]), sizeof(CEffect), 2) ||
            !account(static_cast<std::size_t>(ctrl_counts[i]), sizeof(CEffectCtrl), 2)) {
            return;
        }
    }

    const auto allocate = [&](std::size_t bytes, std::size_t extra) -> u_long128 * {
        const std::size_t words = (bytes + 15) / 16 + extra;
        const std::size_t remaining = dc2::memory::RemainingBytes(*stack).size() / sizeof(u_long128);
        if (words == 0 || words > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
            remaining == 0 || words >= remaining) {
            return nullptr;
        }
        return stack->Alloc(static_cast<int>(words));
    };
    this->name = reinterpret_cast<char *>(allocate(name_text.size() + 1, 0));
    if (this->name == nullptr) {
        return;
    }
    std::memcpy(this->name, name_text.data(), name_text.size());
    this->name[name_text.size()] = 0;

    const auto texture_documents = dc2::assets::ReadDirectoryMembers(directory, "texture");
    for (const auto &texture : texture_documents) {
        MgTextureEnterDocument(&mgTexManager, texture.read.Source(), block, nullptr, nullptr);
    }

    auto *manager_storage = allocate(static_cast<std::size_t>(count) * sizeof(CEffectManager), 2);
    auto *sprite_storage = allocate(static_cast<std::size_t>(count) * sizeof(mgC3DSprite), 2);
    if (manager_storage == nullptr || sprite_storage == nullptr) {
        return;
    }
    effect_num = count;
    managers = ::new (static_cast<void *>(manager_storage)) CEffectManager[effect_num];
    sprites = ::new (static_cast<void *>(sprite_storage)) mgC3DSprite[effect_num];

    for (int i = 0; i < effect_num; i++) {
        const int particle_num = particle_counts[i];
        const int ctrl_num = ctrl_counts[i];
        // The manager is named by the entry's base name, without its directory or extension.
        std::string_view basename = files[static_cast<std::size_t>(i)].name;
        basename.remove_prefix(std::min(basename.size(), basename.find_last_of("/\\") + 1));
        basename = basename.substr(0, basename.find_last_of('.'));
        auto *data = reinterpret_cast<char *>(files[static_cast<std::size_t>(i)].read.Bytes().data());
        auto *particle_storage = allocate(static_cast<std::size_t>(particle_num) * sizeof(CEffect), 2);
        auto *ctrl_storage = allocate(static_cast<std::size_t>(ctrl_num) * sizeof(CEffectCtrl), 2);
        if (particle_storage == nullptr || ctrl_storage == nullptr) {
            effect_num = 0;
            return;
        }
        auto *particles = ::new (static_cast<void *>(particle_storage)) CEffect[particle_num];
        auto *ctrls = ::new (static_cast<void *>(ctrl_storage)) CEffectCtrl[ctrl_num];
        managers[i].EntryEffCtrls(particles, particle_num, ctrls, ctrl_num);
        managers[i].Initialize();
        managers[i].Load(data, files[static_cast<std::size_t>(i)].read.Size());
        dc2::text::Copy(managers[i].name, basename);
        managers[i].Run();
    }
}
