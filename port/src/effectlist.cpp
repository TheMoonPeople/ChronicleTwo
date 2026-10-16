#include "common.h"

#include <algorithm>
#include <cstring>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "effect.hpp"
#include "effectlist.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"

PORT_OVERRIDE void CFadeInOut::CaptureScreen() {
    if (cross_texture == nullptr || cross_texture->image[0] == nullptr || !mgPortRendererReady()) {
        return;
    }

    // Capture the completed scene at this point in the stream. A CPU store followed by a
    // pointer-only texture reload can keep an earlier scene even after its buffer changes.
    const gfx::TextureHandle target = mgPortRenderTarget(cross_texture, true);
    if (target != gfx::kNullTexture) {
        gfx::BlitTexture(gfx::kPreviousFrame,
                         gfx::Rect{0, 0, static_cast<int>(gfx::LogicalWidth()), static_cast<int>(gfx::LogicalHeight())},
                         target, gfx::Rect{0, 0, cross_texture->width, cross_texture->height}, gfx::Filter::Nearest);
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

PORT_OVERRIDE void DivSpriteScreen(mgCDrawPrim &prim) {
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

PORT_OVERRIDE void DivSpriteScreen(mgCDrawPrim &prim, int left, int right, int jagged_left) {
    uint8_t rgba[4];
    mgPortPrimColor(prim, rgba);

    const int                  row_height = mgScreenHeight / 16;
    const int                  edge_offset[2] = {-10, 10};
    std::vector<gfx::Vertex2D> strip;

    for (int row = 0; row < 17; row++) {
        const float y = static_cast<float>(row * row_height);
        const int   left_x = std::max(0, jagged_left ? left + edge_offset[row % 2] : left);
        const int   right_x = std::max(0, jagged_left ? right : right + edge_offset[row % 2]);
        strip.push_back(EdgeVertex(prim, static_cast<float>(left_x), y, rgba));
        strip.push_back(EdgeVertex(prim, static_cast<float>(right_x), y, rgba));
    }

    std::vector<gfx::Vertex2D> triangles;
    mgPortStripTriangles(strip, triangles);
    mgPortPrimSubmit(prim, gfx::Primitive::Triangles, triangles);
}

PORT_OVERRIDE void CEffectList::LoadEFPFile(char *name, u_int *pack, int block, mgCMemory *stack) {
    int          sizes[64];
    u_int       *files[64];
    char        *names[64];
    char         directory[32];
    char         basename[32];
    char         extension[16];
    int          particle_num;
    int          ctrl_num;
    int          i;
    u_int        bytes;
    u_int        quadwords;
    CEffect     *particles;
    CEffectCtrl *ctrls;

    this->block = block;
    this->pack = pack;
    bytes = strlen(name) + 1;
    quadwords = bytes % 16 ? bytes / 16 + 1 : bytes / 16;
    this->name = (char *) stack->Alloc(quadwords);
    strcpy(this->name, name);

    if (const auto directory = AssetDirectoryPath(pack)) {
        for (const auto &document : DataReadNativeKeys(*directory)) {
            if (texture_catalog::Find(document)) {
                MgTextureEnterDocument(&mgTexManager, document, block, nullptr, nullptr);
            }
        }
    }

    effect_num = AssetDirectoryReadExtension(pack, "em", files, 64, sizes, names);
    bytes = effect_num * sizeof(CEffectManager);
    quadwords = bytes % 16 ? bytes / 16 + 1 : bytes / 16;
    managers = new (stack->Alloc(quadwords + 2)) CEffectManager[effect_num];
    bytes = effect_num * sizeof(mgC3DSprite);
    quadwords = bytes % 16 ? bytes / 16 + 1 : bytes / 16;
    sprites = new (stack->Alloc(quadwords + 2)) mgC3DSprite[effect_num];

    for (i = 0; i < effect_num; i++) {
        DivPathNameExt(names[i], directory, basename, extension);
        managers[i].GetBufferNums((char *) files[i], sizes[i], &particle_num, &ctrl_num);
        bytes = particle_num * sizeof(CEffect);
        quadwords = bytes % 16 ? bytes / 16 + 1 : bytes / 16;
        particles = new (stack->Alloc(quadwords + 2)) CEffect[particle_num];
        bytes = ctrl_num * sizeof(CEffectCtrl);
        quadwords = bytes % 16 ? bytes / 16 + 1 : bytes / 16;
        ctrls = new (stack->Alloc(quadwords + 2)) CEffectCtrl[ctrl_num];
        managers[i].EntryEffCtrls(particles, particle_num, ctrls, ctrl_num);
        managers[i].Initialize();
        managers[i].Load((char *) files[i], sizes[i]);
        strcpy(managers[i].name, basename);
        managers[i].Run();
    }
}
