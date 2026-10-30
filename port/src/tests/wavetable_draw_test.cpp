#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <span>
#include <vector>

#include "gfx/gfx.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "render/primitive_submission.hpp"
#include "wavetable.hpp"

namespace {

struct Batch {
    gfx::Primitive             primitive;
    std::vector<gfx::Vertex2D> vertices;
};

class Harness {
public:
    Harness() : saved_render_info_(mgDrawManager.render_info), saved_vif_packet_(mgVif1Packet) {
        mgDrawManager.render_info = &render_info_;
        mgVif1Packet = &vif_packet_;
        mgPortSetPrimSink([this](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &, const gfx::DrawState &) {
            batches.push_back({
                .primitive = primitive, .vertices = {vertices.begin(), vertices.end()}
            });
        });
    }

    ~Harness() {
        mgPortSetPrimSink({});
        mgDrawManager.render_info = saved_render_info_;
        mgVif1Packet = saved_vif_packet_;
    }

    Harness(const Harness &) = delete;
    Harness &operator=(const Harness &) = delete;

    std::vector<Batch> batches;

private:
    mgRENDER_INFO  render_info_{};
    sceVif1Packet  vif_packet_{};
    mgRENDER_INFO *saved_render_info_;
    sceVif1Packet *saved_vif_packet_;
};

std::array<uint8_t, 4> Rgba(const gfx::Vertex2D &v) {
    return {v.color[0], v.color[1], v.color[2], v.color[3]};
}

} // namespace

TEST(WaveTableDraw, CreateTextureDrawsOneStripPerRowThenTheDarkenSprite) {
    Harness    h;
    mgCTexture texture;
    texture.bpp = 32;
    texture.width = 230;
    texture.height = 230;

    CWaveTable wave;
    wave.CreateTexture(&texture);

    ASSERT_EQ(h.batches.size(), 24u);

    // 23 rows of 24 columns, two vertices per column, which is 46 triangles per row.
    for (std::size_t row = 0; row < 23; ++row) {
        EXPECT_EQ(h.batches[row].primitive, gfx::Primitive::Triangles);
        EXPECT_EQ(h.batches[row].vertices.size(), 138u);
    }

    const std::vector<gfx::Vertex2D> &first = h.batches[0].vertices;
    EXPECT_FLOAT_EQ(first[0].x, 0.0f);
    EXPECT_FLOAT_EQ(first[0].y, 0.0f);
    EXPECT_FLOAT_EQ(first[1].x, 0.0f);
    EXPECT_FLOAT_EQ(first[1].y, 10.0f);
    EXPECT_FLOAT_EQ(first[2].x, 10.0f);
    EXPECT_FLOAT_EQ(first[2].y, 0.0f);

    // Flat heights give every vertex the 40-level shade and the fixed 96 alpha.
    for (const gfx::Vertex2D &v : first) {
        EXPECT_EQ(Rgba(v), (std::array<uint8_t, 4>{40, 40, 40, 96}));
    }

    EXPECT_EQ(h.batches[23].primitive, gfx::Primitive::Quads);
    EXPECT_EQ(h.batches[23].vertices.size(), 4u);
}
