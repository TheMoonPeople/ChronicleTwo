#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstring>
#include <format>
#include <memory>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "drawwin.hpp"
#include "gfx/gfx.hpp"
#include "mainloop.hpp"
#include "mg_drawprim.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"

namespace {

/**
 * Installs a deterministic ASCII font table and restores the surrounding font state on every exit.
 */
struct AsciiFontState {
    FONT_TBL_BIN *table = reinterpret_cast<FONT_TBL_BIN *>(GetYoyakuTblTop() - offsetof(FONT_TBL_BIN, yoyaku_tbl));
    FONT_TBL_BIN  saved = *table;
    int           language = LanguageCode;

    AsciiFontState() {
        *table = {};
        table->half_font_num = table->yoyaku_num = 94;
        table->kanji_top_no = 0xffff;
        for (std::size_t index = 0; index < 94; ++index) {
            table->yoyaku_tbl[index][0] = static_cast<u8>(index + 0x20);
            table->yoyaku_tbl[index][1] = 0x20;
        }
        LanguageCode = LANG_ENGLISH;
    }

    ~AsciiFontState() {
        *table = saved;
        LanguageCode = language;
    }
};

struct Batch {
    gfx::Primitive             primitive;
    std::vector<gfx::Vertex2D> vertices;
    gfx::TextureBinding        texture;
    gfx::DrawState             state;
};

// FillRect initialises its builder with NULL, so it binds to the global draw manager and packet.
class GlobalDrawRig {
public:
    GlobalDrawRig() : saved_render_info_(mgDrawManager.render_info), saved_packet_(mgVif1Packet),
                      saved_screen_x_(mgScreenOffx), saved_screen_y_(mgScreenOffy) {
        mgScreenOffx = 1792;
        mgScreenOffy = 1824;
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
        mgScreenOffx = saved_screen_x_;
        mgScreenOffy = saved_screen_y_;
    }

    GlobalDrawRig(const GlobalDrawRig &) = delete;
    GlobalDrawRig &operator=(const GlobalDrawRig &) = delete;

    std::vector<Batch> batches;

private:
    mgRENDER_INFO  render_info_{};
    sceVif1Packet  vif_packet_{};
    mgRENDER_INFO *saved_render_info_;
    sceVif1Packet *saved_packet_;
    int            saved_screen_x_;
    int            saved_screen_y_;
};

void ExpectAt(const gfx::Vertex2D &v, float x, float y) {
    // Vertex adds the GS screen offset and the submission seam removes it.
    EXPECT_FLOAT_EQ(v.x, x);
    EXPECT_FLOAT_EQ(v.y, y);
}

std::array<uint8_t, 4> Rgba(const gfx::Vertex2D &v) {
    return {v.color[0], v.color[1], v.color[2], v.color[3]};
}

// Menu message 153, shown when an item is over its carrying limit.
constexpr int           kItemLimitLine = 153;
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
    message.SetBuff(dc2::text::MessageTable::Parse(std::as_bytes(std::span(table))));
    std::vector<std::uint16_t> codes;
    for (const u16 code : message.GetTextLineDataTop(line_id)) {
        if (code == MES_CODE_END) {
            break;
        }
        codes.push_back(code);
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

TEST(MessageTable, OwnsAndDeduplicatesValidatedWordsAfterInputStorageDisappears) {
    using Table = dc2::text::MessageTable;
    Table original;
    {
        std::vector<u16> source{1, 37, 7, 2, 33, MES_CODE_END};
        original = Table::Parse(std::as_bytes(std::span(source)));
        ASSERT_TRUE(original);
        source[4] = 44;
        const auto changed = Table::Parse(std::as_bytes(std::span(source)));
        ASSERT_TRUE(changed);
        EXPECT_NE(original, changed);
        ASSERT_EQ(changed.Line(7).size(), 2);
        EXPECT_EQ(changed.Line(7)[0], 44);
    }
    ASSERT_EQ(original.Line(7).size(), 2);
    EXPECT_EQ(original.Line(7)[0], 33);
    EXPECT_EQ(original.Line(7)[1], MES_CODE_END);
    EXPECT_TRUE(original.Line(-1).empty());
    EXPECT_TRUE(original.Line(8).empty());
    const std::array<u16, 6> identical{1, 37, 7, 2, 33, MES_CODE_END};
    for (int repeat = 0; repeat < 100; ++repeat) {
        const auto shared = Table::Parse(std::as_bytes(std::span(identical)));
        EXPECT_EQ(shared, original);
        EXPECT_EQ(shared.Line(7).data(), original.Line(7).data());
    }
    const auto kept = original;
    original = nullptr;
    ASSERT_EQ(kept.Line(7).size(), 2);
    EXPECT_EQ(kept.Line(7)[0], 33);
}

TEST(MessageTable, RejectsRealTruncatedExtentsInvalidOffsetsAndUnterminatedLines) {
    using Table = dc2::text::MessageTable;
    const std::array<std::byte, 3> odd{};
    EXPECT_FALSE(Table::Parse(odd));
    const std::array<u16, 1> truncated_header{1};
    EXPECT_FALSE(Table::Parse(std::as_bytes(std::span(truncated_header))));
    const std::array<u16, 2> truncated_entries{1, 0};
    EXPECT_FALSE(Table::Parse(std::as_bytes(std::span(truncated_entries))));
    const std::array<u16, 6> header_offset{1, 0, 7, 0, 33, MES_CODE_END};
    EXPECT_FALSE(Table::Parse(std::as_bytes(std::span(header_offset))));
    const std::array<u16, 6> outside{1, 0, 7, 5, 33, MES_CODE_END};
    EXPECT_FALSE(Table::Parse(std::as_bytes(std::span(outside))));
    const std::array<u16, 6> unterminated{1, 0, 7, 2, 33, 34};
    EXPECT_FALSE(Table::Parse(std::as_bytes(std::span(unterminated))));
    const std::array<u16, 6> valid{1, 0, 7, 2, 33, MES_CODE_END};
    const auto               bytes = std::as_bytes(std::span(valid));
    EXPECT_FALSE(Table::Parse(bytes.first(bytes.size() - sizeof(u16))));
    ASSERT_TRUE(Table::Parse(bytes));
    const std::array<u16, 2> empty{0, 0};
    const auto               document = Table::Parse(std::as_bytes(std::span(empty)));
    ASSERT_TRUE(document);
    EXPECT_TRUE(document.Line(0).empty());
}

TEST(MessageTable, EndOfFileBoundaryRecordsKeepValidMessagesWithoutReadingPastTheFile) {
    std::vector<u16> source{2, 0, 7, 3, 10460, 5, 33, MES_CODE_END};
    const auto       table = dc2::text::MessageTable::Parse(std::as_bytes(std::span(source)));
    ASSERT_TRUE(table);
    ASSERT_EQ(table.Line(7).size(), 2u);
    EXPECT_EQ(table.Line(7)[0], 33);
    EXPECT_EQ(table.Line(7)[1], MES_CODE_END);
    EXPECT_TRUE(table.Line(10460).empty());
    source[5] = 6;
    EXPECT_FALSE(dc2::text::MessageTable::Parse(std::as_bytes(std::span(source))));
    source[5] = 5;
    source.pop_back();
    EXPECT_FALSE(dc2::text::MessageTable::Parse(std::as_bytes(std::span(source))));
    const std::array<u16, 5> unterminated{1, 0, 7, 2, 33};
    EXPECT_FALSE(dc2::text::MessageTable::Parse(std::as_bytes(std::span(unterminated))));
}

TEST(MessageConstruction, PoisonedStorageStartsWithEmptyDocumentsAndCompleteLayoutDefaults) {
    alignas(ClsMes) std::array<std::byte, sizeof(ClsMes)> storage{};
    std::memset(storage.data(), 0xA5, storage.size());
    auto *message = std::construct_at(reinterpret_cast<ClsMes *>(storage.data()));
    EXPECT_FALSE(message->buff);
    EXPECT_FALSE(message->buff_system);
    EXPECT_EQ(message->columns, 70);
    EXPECT_EQ(message->font_w, 15);
    EXPECT_EQ(message->font_h, 24);
    EXPECT_EQ(message->unk_2954, 0);
    std::destroy_at(message);
}

TEST(MessageTable, RejectsMoreRowsOrPagesThanTheLayoutCanStore) {
    using Table = dc2::text::MessageTable;
    for (const auto [code, limit] : {
             std::pair<u16, int>{MES_CODE_NEWLINE, MES_LINE_MAX},
             {MES_CODE_PAGE,    MES_PAGE_MAX}
    }) {
        std::vector<u16> source{1, 0, 7, 2};
        source.insert(source.end(), static_cast<std::size_t>(limit - 1), code);
        source.push_back(MES_CODE_END);
        EXPECT_TRUE(Table::Parse(std::as_bytes(std::span(source))));
        source.insert(source.end() - 1, code);
        EXPECT_FALSE(Table::Parse(std::as_bytes(std::span(source))));
    }
}

TEST(MessageLayout, RejectsNegativeAndPastEndIndicesWithoutChangingEitherTable) {
    ClsMes message;
    std::ranges::fill(message.line_w, 123);
    std::ranges::fill(message.page_chars, 456);
    for (int index : std::array<int, 2>{-1, MES_LINE_MAX}) {
        message.AddYokoHaba(index, 9);
        message.SetYokoHaba(index, 9);
    }
    for (int page : std::array<int, 2>{-1, MES_PAGE_MAX}) {
        message.AddPage(9, page);
    }
    for (int width : message.line_w) {
        EXPECT_EQ(width, 123);
    }
    for (int count : message.page_chars) {
        EXPECT_EQ(count, 456);
    }
}

TEST(MessageLayout, ExpandedNamesRejectOverflowAndKeepTheLastValidPhysicalSlot) {
    AsciiFontState font_state;
    ClsMes         message;
    std::fill_n(message.name[0], MES_NAME_LEN - 1, 'A');
    message.name[0][MES_NAME_LEN - 1] = char{};
    std::vector<u16> source{1, 0, 7, 2};
    source.insert(source.end(), 9, 0xFAF9);
    source.insert(source.end(), 8, 33);
    source.push_back(MES_CODE_END);
    message.SetBuff(dc2::text::MessageTable::Parse(std::as_bytes(std::span(source))));
    ASSERT_EQ(message.MakeMesWinTbl(7), 1);
    EXPECT_EQ(message.tbl_num, MES_WIN_TBL_MAX);
    source.erase(source.begin() + 4, source.end());
    source.insert(source.end(), 10, 0xFAF9);
    source.push_back(MES_CODE_END);
    message.SetBuff(dc2::text::MessageTable::Parse(std::as_bytes(std::span(source))));
    EXPECT_EQ(message.MakeMesWinTbl(7), 0);
    EXPECT_EQ(message.tbl_num, 0);
}

TEST(MessageLayout, DirectTextOverflowRollsBackTheWholeLayout) {
    AsciiFontState font_state;
    ClsMes         message;
    std::string    text(MES_WIN_TBL_MAX - 1, 'A');
    ASSERT_EQ(message.MakeMesWinTbl(text.data()), 1);
    EXPECT_EQ(message.tbl_num, MES_WIN_TBL_MAX);
    text.push_back('A');
    EXPECT_EQ(message.MakeMesWinTbl(text.data()), 0);
    EXPECT_EQ(message.tbl_num, 0);
}

TEST(MessageLayout, UnterminatedInlineCommentRejectsTheLayoutAtItsActualEnd) {
    ClsMes message;
    char   text[] = "//";
    EXPECT_EQ(message.MakeMesWinTbl(text), 0);
    EXPECT_EQ(message.tbl_num, 0);
}

TEST(EventMessageText, OwnsAndDeduplicatesABodyReadFromItsActualInitializedExtent) {
    std::optional<std::string_view> kept;
    {
        std::string source = "@7\nowned body\n@8\nother";
        kept = dc2::text::FindEventMessage(std::span<const char>(source), 7);
        ASSERT_TRUE(kept);
        EXPECT_EQ(*kept, "owned body");
        source.assign(source.size(), 'X');
    }
    ASSERT_TRUE(kept);
    EXPECT_EQ(*kept, "owned body");
    EXPECT_EQ(kept->data()[kept->size()], char{});
    const std::string same = "@7\nowned body";
    const auto        again = dc2::text::FindEventMessage(std::span<const char>(same), 7);
    ASSERT_TRUE(again);
    EXPECT_EQ(again->data(), kept->data());
    const std::array<char, 3> empty{'@', '7', '\n'};
    const auto                empty_body = dc2::text::FindEventMessage(empty, 7);
    ASSERT_TRUE(empty_body);
    EXPECT_TRUE(empty_body->empty());
    const std::array<char, 2> truncated{'@', '7'};
    EXPECT_FALSE(dc2::text::FindEventMessage(truncated, 7));
    EXPECT_FALSE(dc2::text::FindEventMessage({}, 7));
    EXPECT_FALSE(dc2::text::FindEventMessage(std::span<const char>(same), 9));
}

TEST(MessageLayout, InvalidExpansionIndicesAndUnterminatedNamesRejectBeforeReadingTheirStorage) {
    ClsMes message;
    int    x = 123;
    int    y = 456;
    for (int index : std::array<int, 3>{-1, MES_VALUE_MAX, std::numeric_limits<int>::max()}) {
        message.InitMesWinTbl();
        message.MakeMesWinTbl_value(index, &x, &y);
        EXPECT_EQ(message.tbl_num, MES_WIN_TBL_MAX + 1);
        EXPECT_EQ(x, 123);
        EXPECT_EQ(y, 456);
    }
    for (int index : std::array<int, 3>{-1, MES_NAME_MAX, std::numeric_limits<int>::max()}) {
        message.InitMesWinTbl();
        message.MakeMesWinTbl_str(index, &x, &y);
        EXPECT_EQ(message.tbl_num, MES_WIN_TBL_MAX + 1);
        EXPECT_EQ(x, 123);
        EXPECT_EQ(y, 456);
    }
    std::ranges::fill(message.name[0], char{65});
    message.InitMesWinTbl();
    message.MakeMesWinTbl_str(0, &x, &y);
    EXPECT_EQ(message.tbl_num, MES_WIN_TBL_MAX + 1);
    EXPECT_EQ(x, 123);
    EXPECT_EQ(y, 456);
}
