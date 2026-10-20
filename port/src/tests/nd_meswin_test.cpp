#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <format>
#include <span>
#include <string>
#include <utility>
#include <vector>

#include "drawwin.hpp"
#include "gfx/gfx.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "nd_meswin.hpp"

namespace {

struct Batch {
    gfx::Primitive             primitive;
    std::vector<gfx::Vertex2D> vertices;
    gfx::TextureBinding        texture;
    gfx::DrawState             state;
};

// FillRect initialises its builder with NULL, so it binds to the global draw manager and packet.
class GlobalDrawRig {
public:
    GlobalDrawRig() : saved_render_info_(mgDrawManager.render_info), saved_packet_(mgVif1Packet) {
        mgDrawManager.render_info = &render_info_;
        mgVif1Packet = &vif_packet_;
        mgPortSetPrimSink([this](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &texture, const gfx::DrawState &state) {
            batches.push_back({
                .primitive = primitive, .vertices = {vertices.begin(), vertices.end()},
                     .texture = texture, .state = state
            });
        });
    }

    ~GlobalDrawRig() {
        mgPortSetPrimSink({});
        mgDrawManager.render_info = saved_render_info_;
        mgVif1Packet = saved_packet_;
    }

    GlobalDrawRig(const GlobalDrawRig &) = delete;
    GlobalDrawRig &operator=(const GlobalDrawRig &) = delete;

    std::vector<Batch> batches;

private:
    mgRENDER_INFO  render_info_{};
    sceVif1Packet  vif_packet_{};
    mgRENDER_INFO *saved_render_info_;
    sceVif1Packet *saved_packet_;
};

int Gs(float pixels) {
    return static_cast<int>(pixels * 16.0f);
}

void ExpectAt(const gfx::Vertex2D &v, float x, float y) {
    EXPECT_FLOAT_EQ(v.x, mgPortLogicalX(Gs(x)));
    EXPECT_FLOAT_EQ(v.y, mgPortLogicalY(Gs(y)));
}

std::array<uint8_t, 4> Rgba(const gfx::Vertex2D &v) {
    return {v.color[0], v.color[1], v.color[2], v.color[3]};
}

// Menu message 153, shown when an item is over its carrying limit.
constexpr int kItemLimitLine = 153;
constexpr std::uint16_t kCodeItemName = 0xFAF9;
constexpr std::uint16_t kCodeValue = 0xFBFA;
constexpr std::uint16_t kCodeTriangle = 0xFD07;

// A message table with the header words of a menu file and one line, message 153, reading
// "You {FD07}": like the PAL text, it names neither the item nor the limit.
std::vector<short> ItemLimitTable(std::uint16_t count, std::uint16_t word1) {
    // The header words, then an id and text offset per line; only the first line is used.
    std::vector<short> table(2 + (count * 2), -1);
    table[0] = static_cast<short>(count);
    table[1] = static_cast<short>(word1);
    table[2] = kItemLimitLine;
    table[3] = static_cast<short>(count + 1);
    const std::uint16_t text[] = {0x39, 0x4E, 0x54, MES_CODE_SPACE, kCodeTriangle, MES_CODE_END};
    table.insert(table.end(), std::begin(text), std::end(text));
    return table;
}

std::vector<std::uint16_t> Line(std::vector<short> &table, int line_id) {
    ClsMes message;
    message.SetBuff(table.data());
    std::vector<std::uint16_t> codes;
    for (const u16 *code = message.GetTextLineDataTop(line_id); code != nullptr && *code != MES_CODE_END; ++code) {
        codes.push_back(*code);
    }
    return codes;
}

// ASCII letters as the message encoding stores them, any other code as {XXXX}.
std::string Text(const std::vector<std::uint16_t> &codes) {
    std::string text;
    for (const auto code : codes) {
        if (code == MES_CODE_NEWLINE) {
            text += '\n';
        } else if (code == MES_CODE_SPACE) {
            text += ' ';
        } else if (code > 0 && code < 0x3C) {
            text += static_cast<char>(code + 0x20);
        } else if (code >= 0x3C && code < 0x5E) {
            text += static_cast<char>(code + 0x21);
        } else {
            text += std::format("{{{:04X}}}", code);
        }
    }
    return text;
}

} // namespace

TEST(MesWinFillRect, BackingCoversFrameOpening) {
    GlobalDrawRig rig;

    FillRect(159, 346, 197, 47, 0, 0, 0, 54);

    ASSERT_EQ(rig.batches.size(), 1u);
    const Batch &batch = rig.batches[0];
    EXPECT_EQ(batch.primitive, gfx::Primitive::Quads);
    EXPECT_EQ(batch.texture.texture, gfx::kNullTexture);
    EXPECT_TRUE(batch.state.blend);

    ASSERT_EQ(batch.vertices.size(), 4u);
    ExpectAt(batch.vertices[0], 158.0f, 345.0f);
    ExpectAt(batch.vertices[1], 356.0f, 345.0f);
    ExpectAt(batch.vertices[2], 356.0f, 393.0f);
    ExpectAt(batch.vertices[3], 158.0f, 393.0f);
    for (const gfx::Vertex2D &v : batch.vertices) {
        EXPECT_EQ(Rgba(v), (std::array<uint8_t, 4>{0, 0, 0, 54}));
    }

    // Every physical pixel centre in the opening must hit the single translucent backing,
    // including the last row and column at non-integral display scales.
    for (float scale : {1.25f, 2.5f, 3.75f}) {
        const int physical_left = static_cast<int>(159 * scale);
        const int physical_top = static_cast<int>(346 * scale);
        const int physical_right = static_cast<int>(356 * scale);
        const int physical_bottom = static_cast<int>(393 * scale);
        for (int px : {physical_left, physical_right - 1}) {
            for (int py : {physical_top, physical_bottom - 1}) {
                const float x = (static_cast<float>(px) + 0.5f) / scale;
                const float y = (static_cast<float>(py) + 0.5f) / scale;
                EXPECT_GE(x, batch.vertices[0].x);
                EXPECT_LT(x, batch.vertices[2].x);
                EXPECT_GE(y, batch.vertices[0].y);
                EXPECT_LT(y, batch.vertices[2].y);
            }
        }
    }
}

TEST(MesWinFillRect, SelectedLineFrameKeepsTopSideAndBackingToBand) {
    GlobalDrawRig rig;
    mgCDrawPrim   prim;
    RGBAQ_TYPE    color{.r = 128, .g = 128, .b = 128, .a = 96};
    const int     saved_abs_draw_off = MesAbsDrawOff;
    MesAbsDrawOff = 0;
    DrawVersatileWin_3(&prim, {.x = 100, .y = 100, .width = 180, .height = 120}, 170, &color, 96, 0);
    MesAbsDrawOff = saved_abs_draw_off;

    const Batch *left_side = nullptr;
    const Batch *backing = nullptr;
    for (const Batch &batch : rig.batches) {
        if (batch.vertices.size() != 4) {
            continue;
        }
        if (batch.vertices[0].x == 100.0f && batch.vertices[0].y == 125.0f) {
            left_side = &batch;
        }
        if (batch.vertices[0].x == 112.0f && batch.vertices[0].y == 115.0f) {
            backing = &batch;
        }
    }
    ASSERT_NE(left_side, nullptr);
    ASSERT_NE(backing, nullptr);
    ExpectAt(left_side->vertices[2], 123.0f, 163.0f);
    ExpectAt(backing->vertices[2], 269.0f, 167.0f);
    EXPECT_EQ(Rgba(backing->vertices[0]), (std::array<uint8_t, 4>{0, 0, 0, 40}));
}

TEST(MesWinFillRect, CollapsedSelectedLineFrameDoesNotInvertSideTiles) {
    GlobalDrawRig rig;
    mgCDrawPrim   prim;
    RGBAQ_TYPE    color{.r = 128, .g = 128, .b = 128, .a = 32};
    const int     saved_abs_draw_off = MesAbsDrawOff;
    MesAbsDrawOff = 0;
    DrawVersatileWin_3(&prim, {.x = 100, .y = 100, .width = 180, .height = 20}, 110, &color, 32, 0);
    DrawVersatileWin_3(&prim, {.x = 100, .y = 100, .width = 20, .height = 120}, 170, &color, 32, 0);
    MesAbsDrawOff = saved_abs_draw_off;

    for (const Batch &batch : rig.batches) {
        ASSERT_EQ(batch.vertices.size(), 4u);
        EXPECT_LE(batch.vertices[0].x, batch.vertices[2].x);
        EXPECT_LE(batch.vertices[0].y, batch.vertices[2].y);
    }
}

TEST(MesWinFillRect, ZeroHeightSelectedSideStillDrawsPositiveBacking) {
    GlobalDrawRig rig;
    mgCDrawPrim   prim;
    RGBAQ_TYPE    color{.r = 128, .g = 128, .b = 128, .a = 32};
    const int     saved_abs_draw_off = MesAbsDrawOff;
    MesAbsDrawOff = 0;
    DrawVersatileWin_3(&prim, {.x = 100, .y = 100, .width = 180, .height = 120}, 132, &color, 32, 0);
    MesAbsDrawOff = saved_abs_draw_off;

    const Batch *backing = nullptr;
    for (const Batch &batch : rig.batches) {
        if (batch.vertices.size() == 4 && batch.vertices[0].x == 112.0f && batch.vertices[0].y == 115.0f) {
            backing = &batch;
        }
    }
    ASSERT_NE(backing, nullptr);
    ExpectAt(backing->vertices[2], 269.0f, 129.0f);
}

// Each PAL language's menu file, by its header words, names the item over its limit and the limit,
// as the Japanese text does, so the player can tell what to throw away.
TEST(ItemLimitMessage, NamesTheItemAndTheLimitInEveryPalLanguage) {
    for (const auto [count, word1] : {
             std::pair<std::uint16_t, std::uint16_t>{933, 14870},
             {934, 16394},
             {933, 11090},
             {934, 17338},
             {934, 20008}
    }) {
        auto       table = ItemLimitTable(count, word1);
        const auto codes = Line(table, kItemLimitLine);
        EXPECT_NE(std::ranges::find(codes, kCodeItemName), codes.end()) << word1;
        EXPECT_NE(std::ranges::find(codes, kCodeValue), codes.end()) << word1;
        EXPECT_NE(std::ranges::find(codes, kCodeTriangle), codes.end()) << word1;
    }
}

TEST(ItemLimitMessage, EnglishText) {
    auto table = ItemLimitTable(933, 14870);
    EXPECT_EQ(Text(Line(table, kItemLimitLine)),
              "You can only carry {FBFA} \"{FAF9}\".\nPress {FD07} to Move or use the\n\"Throw away\" command to tidy up.");
}

TEST(ItemLimitMessage, UnknownFileKeepsItsText) {
    auto table = ItemLimitTable(933, 1);
    EXPECT_EQ(Text(Line(table, kItemLimitLine)), "You {FD07}");
}
