#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <string_view>
#include <tuple>
#include <utility>
#include <vector>

// SDL must precede the game's register-name macros.
#include <SDL3/SDL.h>

#include "font.hpp"
#include "gfx_fixture.hpp"
#include "mainloop.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "platform/config.hpp"
#include "platform/paths.hpp"
#include "platform/ttffont.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "text/lettering.hpp"
#include "text/menu_label.hpp"
#include "text/outline.hpp"
#include "text/title_lettering.hpp"

namespace {

std::array<std::uint8_t, 188> AsciiTable() {
    std::array<std::uint8_t, 188> table{};
    for (int i = 0; i < 94; ++i) {
        table[i * 2] = static_cast<std::uint8_t>(i + 0x20);
        table[i * 2 + 1] = 0x20;
    }
    return table;
}

// The retail tables' half-width entries: ASCII from the space to the tilde, without the backslash.
std::vector<std::uint8_t> RetailAsciiTable() {
    std::vector<std::uint8_t> table;
    for (int c = 0x20; c <= 0x7E; ++c) {
        if (c != '\\') {
            table.push_back(static_cast<std::uint8_t>(c));
            table.push_back(0x20);
        }
    }
    return table;
}

std::filesystem::path ShippedFont() {
    return PathsExecutable().parent_path() / "fonts" / "ChronicleTwoMessage-Regular.ttf";
}

using Entry = std::tuple<int, int, int, unsigned, int>;

std::vector<Entry> Entries(const ClsMes &mes) {
    std::vector<Entry> out;
    for (int i = 0; i < mes.tbl_num; ++i) {
        const auto &entry = mes.tbl[i];
        out.emplace_back(entry.code, entry.x, entry.y, entry.color, entry.wait);
    }
    return out;
}

// The lookup table is game state, so use a synthetic equivalent of the ASCII table, not disc assets.
struct FontState {
    std::array<unsigned char, FONT_TBL_BIN_SIZE> saved{};
    int                                          language = LanguageCode;
    mgRENDER_INFO                               *render = mgDrawManager.render_info;
    sceVif1Packet                               *packet = mgVif1Packet;
    mgRENDER_INFO                                info{};
    sceVif1Packet                                vif{};

    FontState() {
        auto *header = reinterpret_cast<FONT_TBL_BIN *>(GetYoyakuTblTop() - 8);
        std::memcpy(saved.data(), header, saved.size());
        std::memset(header, 0, sizeof(*header));
        header->half_font_num = header->yoyaku_num = 94;
        header->kanji_top_no = 0xffff;
        const auto table = AsciiTable();
        std::memcpy(GetYoyakuTblTop(), table.data(), table.size());
        LanguageCode = LANG_ENGLISH;
        mgDrawManager.render_info = &info;
        mgVif1Packet = &vif;
    }

    ~FontState() {
        std::memcpy(GetYoyakuTblTop() - 8, saved.data(), saved.size());
        LanguageCode = language;
        mgDrawManager.render_info = render;
        mgVif1Packet = packet;
        mgPortSetPrimSink({});
    }
};

// A save root of the test's own, beside which config.json chooses the text font.
struct ConfigRoot {
    std::filesystem::path root = std::filesystem::temp_directory_path() / ("dc2_font_" + std::to_string(dc::test::ProcessId()));

    ConfigRoot() {
        EXPECT_FALSE(std::filesystem::exists(root));
        std::filesystem::create_directories(root / "saves");
        PathsSetSaveRoot(root / "saves");
    }

    ~ConfigRoot() {
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }

    void Select(const char *choice) {
        std::ofstream(root / "config.json") << R"({"video":{"text_font":")" << choice << "\"}}";
        EXPECT_TRUE(ConfigLoad());
    }
};

// The synthetic table's font number for an ASCII character.
int FontNo(char c) { return c - 0x20; }

// How far a message window's kerning moves what follows c: its advance in the font less retail's.
float Shift(const ClsMes &mes, char c) {
    const int retail = c == ' ' ? mes.font_w / 2 : static_cast<int>(mes.font_w * mes.half_font_w_percent);
    return (dc2::font::HalfAdvance(FontNo(c)) - 1.0f) * static_cast<float>(retail);
}

} // namespace

TEST(FontPort, MapsEveryPalFontPage) {
    auto table = AsciiTable();
    for (int language = LANG_ENGLISH; language <= LANG_SPANISH; ++language) {
        for (int i = 0; i < 94; ++i) {
            EXPECT_EQ(dc2::font::Character(language, i, table), static_cast<char32_t>(i + 0x20));
        }
    }
    // The European pages: alphabetical_chara_tbl's letters, then FontGaijiConvTbl's symbols.
    EXPECT_EQ(dc2::font::Character(LANG_FRENCH, FONT_NO_ALPHABETICAL_TOP, table), char32_t{0xA1});      // ¡
    EXPECT_EQ(dc2::font::Character(LANG_GERMAN, FONT_NO_ALPHABETICAL_TOP + 32, table), char32_t{0xDF}); // ß
    EXPECT_EQ(dc2::font::Character(LANG_SPANISH, FONT_NO_FONT_GAIJI_TOP - 1, table), char32_t{0x153});  // œ
    EXPECT_EQ(dc2::font::Character(LANG_ITALIAN, FONT_NO_FONT_GAIJI_TOP, table), char32_t{0x25CB});     // ○
    EXPECT_EQ(dc2::font::Character(LANG_FRENCH, FONT_NO_FONT_GAIJI_TOP + 19, table), char32_t{0xFF65}); // half-width ・
    EXPECT_EQ(dc2::font::Character(LANG_FRENCH, FONT_NO_FONT_GAIJI_END - 1, table), char32_t{0x2019});  // ’
    EXPECT_EQ(dc2::font::Character(LANG_FRENCH, FONT_NO_FONT_GAIJI_END, table), 0u);

    // The English page: its full-width symbols by their Shift-JIS codes; kana and kanji keep the bitmap.
    std::array<std::uint8_t, 10> english = {'A', ' ', 0x81, 0x79, 0x81, 0x67, 0x82, 0xA0, 0x88, 0x9F};
    EXPECT_EQ(dc2::font::Character(LANG_ENGLISH, 0, english), char32_t{'A'});
    EXPECT_EQ(dc2::font::Character(LANG_ENGLISH, 1, english), char32_t{0x3010}); // 【
    EXPECT_EQ(dc2::font::Character(LANG_ENGLISH, 2, english), char32_t{0xE001}); // the full-width “
    EXPECT_EQ(dc2::font::Character(LANG_ENGLISH, 3, english), 0u);               // あ
    EXPECT_EQ(dc2::font::Character(LANG_ENGLISH, 4, english), 0u);               // a kanji
    EXPECT_EQ(dc2::font::Character(LANG_FRENCH, 1, english), 0u);                // a European page draws no Shift-JIS symbols

    EXPECT_EQ(dc2::font::Character(LANG_JAPANESE, 33, table), 0u);
    EXPECT_EQ(dc2::font::Character(LANG_ENGLISH, -1, table), 0u);
    EXPECT_EQ(dc2::font::Character(LANG_ENGLISH, 94, table), 0u);
    EXPECT_EQ(dc2::font::Character(LANG_ENGLISH, 3, {table.data(), 3}), 0u);
}

TEST(FontPort, LookupTerminatesForEmptySingleEntryAndInvalidTables) {
    FontState state;
    auto     *header = reinterpret_cast<FONT_TBL_BIN *>(GetYoyakuTblTop() - offsetof(FONT_TBL_BIN, yoyaku_tbl));
    char      first[] = "  ";
    char      missing[] = "! ";
    header->yoyaku_num = 0;
    EXPECT_EQ(GetFontNo(first), -1);
    header->yoyaku_num = 1;
    EXPECT_EQ(GetFontNo(first), 0);
    EXPECT_EQ(GetFontNo(missing), -1);
    header->yoyaku_num = std::numeric_limits<u16>::max();
    EXPECT_EQ(GetYoyakuTblNum(), 0);
    EXPECT_EQ(GetFontNo(first), -1);
    EXPECT_EQ(GetFontNo(nullptr), -1);
}

TEST(FontPort, PageGeometryIsTheFittedOne) {
    std::ifstream file(CT_MESSAGE_FONT_PARAMETERS);
    ASSERT_TRUE(file);
    const auto english = nlohmann::json::parse(file)["english_page"];
    const auto affine = english["affine"];
    const auto page = dc2::font::PageOf(LANG_ENGLISH);
    EXPECT_FLOAT_EQ(page.texels_per_unit_x, affine[0].get<float>() / 64.0f);
    EXPECT_FLOAT_EQ(page.texels_per_unit_y, affine[3].get<float>() / 64.0f);
    EXPECT_FLOAT_EQ(page.pen_x, affine[4].get<float>() / 64.0f);
    EXPECT_FLOAT_EQ(page.baseline, english["baseline"].get<float>() - affine[5].get<float>() / 64.0f);
    for (int language : {LANG_FRENCH, LANG_GERMAN, LANG_ITALIAN, LANG_SPANISH}) {
        const auto european = dc2::font::PageOf(language);
        EXPECT_FLOAT_EQ(european.texels_per_unit_x, 1.0f / 64.0f);
        EXPECT_FLOAT_EQ(european.baseline, 16.0f);
    }
}

// Every character the painter can ask for is in the shipped font, so no cell falls back to its bitmap.
TEST(FontPort, EveryMappedCharacterIsInTheShippedFont) {
    ASSERT_TRUE(ttffont::Load(ShippedFont()));
    std::vector<unsigned char> alpha;
    int                        w = 0;
    int                        h = 0;
    int                        x0 = 0;
    int                        y0 = 0;
    auto                       draws = [&](char32_t ch) {
        return ch == 0x20 || ch == 0x3000 || ttffont::RenderGlyph(ch, 20.0f, 20.0f, 0.0f, 0.0f, alpha, w, h, x0, y0);
    };
    const auto ascii = RetailAsciiTable();
    ASSERT_EQ(ascii.size() / 2, static_cast<std::size_t>(FONT_NO_ALPHABETICAL_TOP));
    for (int no = 0; no < FONT_NO_FONT_GAIJI_END; ++no) {
        const char32_t ch = dc2::font::Character(LANG_FRENCH, no, ascii);
        ASSERT_NE(ch, 0u) << no;
        EXPECT_TRUE(draws(ch)) << "font number " << no;
    }
    std::vector<std::uint8_t> codes;
    for (int code = 0x8140; code <= 0x82FF; ++code) {
        codes.push_back(static_cast<std::uint8_t>(code >> 8));
        codes.push_back(static_cast<std::uint8_t>(code));
    }
    int mapped = 0;
    for (int no = 0; std::cmp_less(no, codes.size() / 2); ++no) {
        if (const char32_t ch = dc2::font::Character(LANG_ENGLISH, no, codes)) {
            ++mapped;
            EXPECT_TRUE(draws(ch)) << "Shift-JIS " << std::hex << (0x8140 + no);
        }
    }
    EXPECT_EQ(mapped, 119);
}

// Every typeface loads from fonts/ beside the executable, and each draws its own letters.
TEST(FontPort, EveryTypefaceLoads) {
    const ttffont::Face *message = dc2::font::FaceOf(dc2::font::Typeface::Message);
    const ttffont::Face *menu = dc2::font::FaceOf(dc2::font::Typeface::Menu);
    ASSERT_NE(message, nullptr);
    ASSERT_NE(menu, nullptr);
    ASSERT_NE(dc2::font::FaceOf(dc2::font::Typeface::Board), nullptr);
    ASSERT_NE(dc2::font::FaceOf(dc2::font::Typeface::Title), nullptr);
    float message_m = 0;
    float menu_m = 0;
    float menu_i = 0;
    ASSERT_TRUE(message->GetAdvance('m', message_m));
    ASSERT_TRUE(menu->GetAdvance('m', menu_m));
    ASSERT_TRUE(menu->GetAdvance('i', menu_i));
    EXPECT_LT(menu_i, menu_m);
    EXPECT_NE(menu_m, message_m);
    std::vector<unsigned char> alpha;
    int                        w = 0;
    int                        h = 0;
    int                        x0 = 0;
    int                        y0 = 0;
    EXPECT_TRUE(menu->RenderGlyph('H', 40.0f, 40.0f, 0.0f, 0.0f, alpha, w, h, x0, y0));
    // The menu font has no Japanese; the painting keeps those labels.
    EXPECT_FALSE(menu->RenderGlyph(char32_t{0x30A2}, 40.0f, 40.0f, 0.0f, 0.0f, alpha, w, h, x0, y0));
}

// The label painter places words where the fit put them: each lettering's em (its font's units over 64), pen and
// baseline, and each word's own offset.
TEST(MenuLabel, GeometryIsTheFittedOne) {
    for (const auto &[lettering, path] : {
             std::pair{dc2::text::MenuLettering::Words, CT_MENU_FONT_PARAMETERS },
             std::pair{dc2::text::MenuLettering::Board, CT_BOARD_FONT_PARAMETERS}
    }) {
        std::ifstream file(path);
        ASSERT_TRUE(file) << path;
        const auto parameters = nlohmann::json::parse(file);
        const auto fitted = parameters["global"];
        const auto geometry = dc2::text::MenuLabelGeometryOf(lettering);
        EXPECT_FLOAT_EQ(geometry.em, std::round(fitted["em"].get<float>() * 64.0f) / 64.0f) << path;
        EXPECT_FLOAT_EQ(geometry.start, fitted["start"].get<float>()) << path;
        EXPECT_FLOAT_EQ(geometry.baseline, fitted["baseline"].get<float>()) << path;
        ASSERT_EQ(dc2::text::MenuLabelWords(lettering).size(), parameters["words"].size()) << path;
        for (const dc2::text::MenuLabelWord &word : dc2::text::MenuLabelWords(lettering)) {
            const auto offset = parameters["words"][std::string(word.text)];
            EXPECT_FLOAT_EQ(word.dx, offset[0].get<float>()) << word.text;
            EXPECT_FLOAT_EQ(word.dy, offset[1].get<float>()) << word.text;
        }
    }
}

// A label is lettered only where the menu atlas paints one, and only with the sharp text font.
TEST(MenuLabel, OnlyTheAtlasWordsAreLettered) {
    ConfigRoot  config;
    FontState   state;
    mgCDrawPrim prim;
    MySetPrim(&prim, 1, 0);
    const mgRect<float> put(10.0f, 20.0f, 112.0f, 24.0f);
    const mgRect<int>   cell(32, 160, 112, 24);
    config.Select("sharp");
    EXPECT_FALSE(dc2::text::DrawMenuLabel(prim, put, cell)); // no texture bound
    config.Select("original");
    EXPECT_FALSE(dc2::text::DrawMenuLabel(prim, put, cell));
}

// Lettering reads its text as UTF-8, a malformed byte at a time as the replacement character.
TEST(Lettering, ReadsUtf8) {
    const std::string_view text = "a\xc3\xa7\xe2\x80\x94\xf0\x9f\x98\x80\xc3(\xc0\xaf";
    std::vector<char32_t>  read;
    for (std::size_t at = 0; at < text.size();) {
        read.push_back(dc2::text::NextCharacter(text, at));
    }
    const std::vector<char32_t> expected = {'a', 0xE7, 0x2014, 0x1F600, 0xFFFD, '(', 0xFFFD, 0xFFFD};
    EXPECT_EQ(read, expected);
}

// Every label the title and language menus letter, in every language, is drawn by ChronicleTwoTitle, and none
// needs narrowing by more than 30% to fit its plate's flat middle.
TEST(TitleLettering, EveryLabelIsInTheTitleFont) {
    const ttffont::Face *face = dc2::font::FaceOf(dc2::font::Typeface::Title);
    ASSERT_NE(face, nullptr);
    int labels = 0;
    for (const auto table : {dc2::text::TitleLanguageLabels(), dc2::text::TitleMenuLabels(), dc2::text::TitlePushStartLabels()}) {
        for (const dc2::text::TitleLabel &label : table) {
            for (const std::string_view text : label.text) {
                for (std::size_t at = 0; at < text.size();) {
                    const char32_t c = dc2::text::NextCharacter(text, at);
                    float          advance = 0;
                    EXPECT_TRUE(face->GetAdvance(c, advance)) << text << " U+" << std::hex << static_cast<std::uint32_t>(c);
                }
                labels += !text.empty();
            }
        }
    }
    EXPECT_EQ(labels, 5 + 7 * 5 + 5);
    for (const dc2::text::TitleLabel &label : dc2::text::TitleMenuLabels()) {
        for (const std::string_view text : label.text) {
            EXPECT_GT(166.0f / dc2::text::LetteringAdvance(dc2::font::Typeface::Title, text), 1971.0f / 64.0f * 0.7f) << text;
        }
    }
}

// A blank plate's nine pieces cover it once: at its own size each lands on the texels it samples, but the middle,
// which stretches a column of the fill; larger, only the edges and middle stretch.
TEST(TitleLettering, PlatePiecesTileThePlate) {
    for (const auto [w, h] : {
             std::pair{210.0f, 54.0f},
             std::pair{300.0f, 80.0f}
    }) {
        float area = 0;
        for (const dc2::text::TitlePlatePiece &piece : dc2::text::TitlePlatePieces(302, 256, w, h)) {
            EXPECT_GE(piece.dst_w, 0.0f);
            EXPECT_GE(piece.dst_h, 0.0f);
            EXPECT_LE(piece.dst_x + piece.dst_w, w);
            EXPECT_LE(piece.dst_y + piece.dst_h, h);
            area += piece.dst_w * piece.dst_h;
        }
        EXPECT_FLOAT_EQ(area, w * h);
    }
    const auto pieces = dc2::text::TitlePlatePieces(302, 256, 210.0f, 54.0f);
    for (std::size_t i = 0; i < pieces.size(); ++i) {
        const dc2::text::TitlePlatePiece &piece = pieces[i];
        if (i == 4) {
            EXPECT_EQ(piece.src_w, 1.0f);
            continue;
        }
        EXPECT_EQ(piece.src_x - 302, piece.dst_x) << i;
        EXPECT_EQ(piece.src_y - 256, piece.dst_y) << i;
        EXPECT_EQ(piece.src_w, piece.dst_w) << i;
        EXPECT_EQ(piece.src_h, piece.dst_h) << i;
    }
    const auto larger = dc2::text::TitlePlatePieces(302, 256, 300.0f, 80.0f);
    for (const std::size_t corner : {0u, 2u, 6u, 8u}) {
        EXPECT_EQ(larger[corner].dst_w, pieces[corner].dst_w);
        EXPECT_EQ(larger[corner].dst_h, pieces[corner].dst_h);
    }
}

// Only the title atlases' cells are lettered, and only with the sharp text font.
TEST(TitleLettering, OnlyTheTitleCellsAreLettered) {
    ConfigRoot  config;
    FontState   state;
    mgCDrawPrim prim;
    MySetPrim(&prim, 1, 0);
    const mgRect<int> cell(0, 0, 210, 54);
    config.Select("sharp");
    EXPECT_FALSE(dc2::text::DrawTitleLettering(prim, 10.0f, 20.0f, cell)); // no texture bound
    config.Select("original");
    EXPECT_FALSE(dc2::text::DrawTitleLettering(prim, 10.0f, 20.0f, cell));
}

// The rims' profiles: a soft half-pixel edge at their measured radius, and the glow fading out.
TEST(FontOutline, RimsFadeOutAtTheirMeasuredReach) {
    EXPECT_FLOAT_EQ(dc2::text::OutlineOpacity(dc2::text::Outline::Thin, 0.0f), 1.0f);
    EXPECT_FLOAT_EQ(dc2::text::OutlineOpacity(dc2::text::Outline::Thin, 0.6f), 1.0f);
    EXPECT_NEAR(dc2::text::OutlineOpacity(dc2::text::Outline::Thin, 0.85f), 0.5f, 1e-5f);
    EXPECT_FLOAT_EQ(dc2::text::OutlineOpacity(dc2::text::Outline::Thin, dc2::text::OutlineReach(dc2::text::Outline::Thin)), 0.0f);
    EXPECT_NEAR(dc2::text::OutlineOpacity(dc2::text::Outline::Thick, 1.67f), 0.5f, 1e-5f);
    EXPECT_GT(dc2::text::OutlineReach(dc2::text::Outline::Thick), dc2::text::OutlineReach(dc2::text::Outline::Thin));
    EXPECT_FLOAT_EQ(dc2::text::OutlineOpacity(dc2::text::Outline::Glow, 0.0f), 1.0f);
    EXPECT_NEAR(dc2::text::OutlineOpacity(dc2::text::Outline::Glow, 1.25f), 0.5f, 1e-5f);
    EXPECT_FLOAT_EQ(dc2::text::OutlineOpacity(dc2::text::Outline::Glow, 2.5f), 0.0f);
    EXPECT_LT(dc2::text::OutlineAlpha(dc2::text::Outline::Glow), 0.5f);
    EXPECT_FLOAT_EQ(dc2::text::OutlineAlpha(dc2::text::Outline::Thin), 1.0f);
}

// A rim is round in logical pixels, so where a logical pixel is 4 target pixels across and 2 down it
// reaches twice as far across, and the glyph stays fully covered inside it.
TEST(FontOutline, RimIsRoundInLogicalPixels) {
    constexpr int                   size = 4;
    const std::vector<std::uint8_t> square(static_cast<std::size_t>(size) * size, 255);
    const auto                      rim = dc2::text::OutlineRim(square, size, size, 4.0f, 2.0f, dc2::text::Outline::Thin);
    EXPECT_EQ(rim.margin_x, 6);
    EXPECT_EQ(rim.margin_y, 4);
    const int width = size + 2 * rim.margin_x;
    ASSERT_EQ(rim.alpha.size(), static_cast<std::size_t>(width * (size + 2 * rim.margin_y)));
    auto      at = [&](int x, int y) { return rim.alpha[static_cast<std::size_t>(y + rim.margin_y) * width + x + rim.margin_x]; };
    const int middle = size / 2;
    EXPECT_EQ(at(middle, middle), 255);
    EXPECT_EQ(at(size - 1 + 2, middle), 255); // half a logical pixel right
    EXPECT_EQ(at(size - 1 + 6, middle), 0);   // a logical pixel and a half right
    EXPECT_EQ(at(middle, size - 1 + 1), 255); // half a logical pixel down
    EXPECT_EQ(at(middle, size - 1 + 3), 0);   // a logical pixel and a half down
    // Corners are round: the diagonal pixel as far out as the side one is fainter.
    EXPECT_LT(at(size - 1 + 4, size - 1 + 2), at(size - 1 + 4, middle));
}

// A rim of any radius is the thin and thick rims' profile at that radius, and the distance field is the one they
// are drawn from: zero on the glyph, growing in logical pixels away from it.
TEST(FontOutline, RimOfAnyRadiusAndItsDistances) {
    constexpr int                   size = 4;
    const std::vector<std::uint8_t> square(static_cast<std::size_t>(size) * size, 255);
    const auto                      thin = dc2::text::OutlineRim(square, size, size, 4.0f, 2.0f, dc2::text::Outline::Thin);
    const auto                      same = dc2::text::OutlineRimOf(square, size, size, 4.0f, 2.0f, 0.85f);
    EXPECT_EQ(same.alpha, thin.alpha);
    EXPECT_EQ(same.margin_x, thin.margin_x);
    const auto wider = dc2::text::OutlineRimOf(square, size, size, 4.0f, 2.0f, 1.3f);
    EXPECT_GT(wider.margin_x, thin.margin_x);

    const int  w = size + 8;
    const int  h = size + 4;
    const auto distance = dc2::text::OutlineDistance(square, size, size, 4.0f, 2.0f, 4, 2, w, h);
    ASSERT_EQ(distance.size(), static_cast<std::size_t>(w * h));
    auto at = [&](int x, int y) { return distance[static_cast<std::size_t>(y) * w + x]; };
    EXPECT_EQ(at(4 + 1, 2 + 1), 0.0f);
    EXPECT_NEAR(at(4 + size - 1 + 4, 2 + 1), 1.0f - 0.5f / std::sqrt(8.0f), 1e-4f); // four pixels right: a logical one
    EXPECT_GT(at(w - 1, h - 1), at(4 + size, 2 + size));
    EXPECT_TRUE(dc2::text::OutlineDistance(square, size, size, 4.0f, 2.0f, 4, 2, size, size).empty());
}

// Sharp, each letter takes its own width in the font; the original font keeps retail's one cell for every
// half-width character. Digits keep the cell, so figures line up.
TEST(FontPort, SharpLettersTakeTheirOwnWidths) {
    ConfigRoot config;
    FontState  state;
    config.Select("original");
    EXPECT_FALSE(dc2::font::Proportional());
    EXPECT_EQ(dc2::font::HalfAdvance(FontNo('i')), 1.0f);
    config.Select("sharp");
    ASSERT_TRUE(dc2::font::Proportional());
    EXPECT_LT(dc2::font::HalfAdvance(FontNo('i')), 0.6f);
    EXPECT_LT(dc2::font::HalfAdvance(FontNo('l')), 0.6f);
    EXPECT_LT(dc2::font::HalfAdvance(FontNo('r')), dc2::font::HalfAdvance(FontNo('n')));
    EXPECT_GT(dc2::font::HalfAdvance(FontNo('m')), 1.0f);
    EXPECT_NEAR(dc2::font::HalfAdvance(FontNo(' ')), 0.7f, 0.01f);
    for (const char digit : std::string_view("0123456789")) {
        EXPECT_EQ(dc2::font::HalfAdvance(FontNo(digit)), 1.0f) << digit;
    }
    EXPECT_EQ(dc2::font::HalfAdvance(-1), 1.0f);
}

// A message window's characters move by the widths of the letters before them; its lines, its text and its bubble
// are measured again from those widths, and a space the text sets a width for keeps it.
TEST(FontPort, MessageWindowsTakeTheLettersWidths) {
    ConfigRoot config;
    FontState  state;
    char       text[] = "Wide Wi, 0129!\nSecond line (X) done";
    ClsMes     mes;
    config.Select("original");
    mes.MakeMesWin(text, 1, 1);
    const auto original = Entries(mes);
    const int  original_w[2] = {mes.line_w[0], mes.line_w[1]};
    EXPECT_EQ(mes.fukidashi_w, mes.text_w + 80); // the last line is the widest

    config.Select("sharp");
    mes.MakeMesWin(text, 1, 1);
    const auto kerned = Entries(mes);
    ASSERT_EQ(kerned.size(), original.size());
    float shift = 0.0f;
    int   line = 0;
    for (std::size_t i = 0; i < kerned.size(); ++i) {
        const auto [code, x, y, color, wait] = original[i];
        EXPECT_EQ(std::get<0>(kerned[i]), code);
        EXPECT_EQ(std::get<1>(kerned[i]), static_cast<int>(std::floor(static_cast<float>(x) + shift))) << i;
        EXPECT_EQ(std::get<2>(kerned[i]), y);
        if (code == MES_CODE_NEWLINE || code == MES_CODE_END) {
            EXPECT_EQ(mes.line_w[line], original_w[line] + static_cast<int>(std::lround(shift)));
            EXPECT_LT(mes.line_w[line], original_w[line]);
            ++line;
            shift = 0.0f;
        } else if (mes.CheckHalfFont(code) != 0) { // not the (X) button's picture
            shift += Shift(mes, static_cast<char>(code + 0x20));
        }
    }
    EXPECT_EQ(line, 2);
    // The figures keep retail's pitch.
    const auto digit = std::ranges::find(original, FontNo('0'), [](const Entry &e) { return std::get<0>(e); }) - original.begin();
    for (int i = 0; i < 3; ++i) {
        EXPECT_EQ(std::get<1>(kerned[digit + i + 1]) - std::get<1>(kerned[digit + i]),
                  std::get<1>(original[digit + i + 1]) - std::get<1>(original[digit + i]));
    }
    EXPECT_EQ(mes.text_w, std::max(mes.line_w[0], mes.line_w[1]));
    EXPECT_EQ(mes.line_indent[0], (mes.text_w - mes.line_w[0]) / 2);
    EXPECT_EQ(mes.fukidashi_w, mes.text_w + 80);

    // The European text narrows its spaces with a width code at the start of a line; those spaces keep it.
    std::array<u16, 13> message = {1, 0, 7, 3, 0, 0xF805, static_cast<u16>(FontNo('W')), static_cast<u16>(FontNo('i')),
                                   0xFF02, static_cast<u16>(FontNo('a')), 0xFF02, static_cast<u16>(FontNo('m')), 0xFF01};
    ClsMes              spaced;
    spaced.SetBuff(dc2::text::MessageTable::Parse(std::as_bytes(std::span(message))));
    spaced.MakeMesWin(7);
    ASSERT_EQ(spaced.tbl_num, 7); // and the end
    EXPECT_EQ(spaced.tbl[2].code, MES_CODE_SPACE);
    EXPECT_EQ(spaced.tbl[3].x - spaced.tbl[2].x, 5);
    EXPECT_EQ(spaced.tbl[5].x - spaced.tbl[4].x, 5);
    EXPECT_LT(spaced.tbl[2].x, 14); // after a narrow i
}

TEST(FontPortGpu, SharpDrawingKeepsRetailTablesAndDrawsEachStyle) {
    ConfigRoot                              config;
    auto                                    select = [&](const char *choice) { config.Select(choice); };
    dc::test::GfxFixture                    gfx(1440, 1080, 1.0f, dc::test::GfxOptions{.offscreen = true});
    FontState                               state;
    std::vector<gfx::TextureHandle>         textures;
    std::vector<std::vector<gfx::Vertex2D>> geometry;
    mgPortSetPrimSink([&](gfx::Primitive, std::span<const gfx::Vertex2D> vertices, const gfx::TextureBinding &texture,
                          const gfx::DrawState &) {
        textures.push_back(texture.texture);
        geometry.emplace_back(vertices.begin(), vertices.end());
    });

    char  direct[] = "Wi 0129!\nA long menu item";
    CFont font;
    select("original");
    int old_w = 0;
    int old_h = 0;
    font.CalcDrawWH(direct, &old_w, &old_h);
    font.DrawDirect(direct, 40, 30);
    const auto original_textures = textures;
    textures.clear();

    ClsMes mes;
    char   text[] = "Wide Wi, 0129!\nSecond line (X) done";
    ASSERT_EQ(mes.MakeMesWinTbl(text), 1);
    const auto original = Entries(mes);
    const int  old_font_w = mes.font_w;
    const int  old_font_h = mes.font_h;
    select("sharp");
    ASSERT_TRUE(ConfigGet().font_sharp);
    int new_w = 0;
    int new_h = 0;
    font.CalcDrawWH(direct, &new_w, &new_h);
    EXPECT_EQ(old_w, 16 * 7); // Half-cell advance is 7, not 8 or the TrueType advance.
    EXPECT_EQ(old_h, 48);
    // Sharp, the longest line is the second still, by each letter's own width.
    float second = 0.0f;
    for (const char c : std::string_view("A long menu item")) {
        second += 7.0f * dc2::font::HalfAdvance(FontNo(c));
    }
    EXPECT_EQ(new_w, static_cast<int>(std::ceil(second)));
    EXPECT_LT(new_w, old_w);
    EXPECT_EQ(new_h, old_h);
    font.DrawDirect(direct, 40, 30);
    ASSERT_FALSE(textures.empty());
    EXPECT_NE(textures, original_textures); // The sharp painter actually ran; this is not fallback equality.
    EXPECT_NE(textures.front(), gfx::kNullTexture);
    // The table builder stays retail's; MakeMesWin kerns what it builds.
    ASSERT_EQ(mes.MakeMesWinTbl(text), 1);
    EXPECT_EQ(Entries(mes), original);
    EXPECT_EQ(mes.font_w, old_font_w);
    EXPECT_EQ(mes.font_h, old_font_h);
    mes.reveal_num = mes.tbl_num - 1;
    mes.DrawFont();
    EXPECT_EQ(Entries(mes), original);

    // A tokenized page also keeps its explicit page/line/space/position controls and icon cells.
    std::array<u16, 16> message = {1, 0, 7, 3, 0, 0xf700 | 30, 33, 0xff02, 55, 0xfd06,
                                   0xff00, 0xf900 | 5, 34, 0xff03, 35, 0xff01};
    mes.SetBuff(dc2::text::MessageTable::Parse(std::as_bytes(std::span(message))));
    select("original");
    ASSERT_EQ(mes.MakeMesWinTbl(7), 1);
    const auto tokenized = Entries(mes);
    select("sharp");
    ASSERT_EQ(mes.MakeMesWinTbl(7), 1);
    EXPECT_EQ(Entries(mes), tokenized);
    EXPECT_TRUE(std::ranges::any_of(tokenized, [](const Entry &e) { return std::get<0>(e) == MES_CODE_PAGE; }));

    // Shadows are retail's copies through the painter; outlines are one rim each; the white-and-blue
    // style's blue is five steps of one extrusion. The fill comes last with its alpha multiplied, each
    // a quad of the glyph's image on whole pixels inside the cell.
    constexpr std::array<int, 9> passes = {1, 2, 2, 2, 3, 2, 2, 7, 2};
    char                         letter[] = "W";
    font.SetColor(23, 45, 67, 96);
    font.alpha = 64;
    const auto mapping = gfx::GetUiMapping(mgPortCurrentTarget());
    auto       on_pixel = [](float logical, float scale, float offset) {
        const float pixel = logical * scale + offset;
        return std::abs(pixel - std::round(pixel)) < 0.01f;
    };
    for (int style = 0; style < FUCHI_NUM; ++style) {
        geometry.clear();
        textures.clear();
        font.SetFuchi(style);
        font.DrawDirect(letter, 40, 30);
        ASSERT_EQ(geometry.size(), static_cast<std::size_t>(passes[style])) << "style " << style;
        const auto &fill = geometry.back();
        ASSERT_EQ(fill.size(), 4u);
        EXPECT_EQ(fill[0].color[0], 23);
        EXPECT_EQ(fill[0].color[1], 45);
        EXPECT_EQ(fill[0].color[2], 67);
        EXPECT_EQ(fill[0].color[3], 48);
        const auto texture = gfx::GetTextureInfo(textures.back());
        ASSERT_TRUE(texture.has_value());
        // One texel a target pixel, on whole pixels: nothing is resampled.
        EXPECT_NEAR(static_cast<float>(texture->width), (fill[1].x - fill[0].x) * mapping.scale_x, 0.01f);
        EXPECT_NEAR(static_cast<float>(texture->height), (fill[2].y - fill[1].y) * mapping.scale_y, 0.01f);
        EXPECT_TRUE(on_pixel(fill[0].x, mapping.scale_x, mapping.offset_x));
        EXPECT_TRUE(on_pixel(fill[0].y, mapping.scale_y, mapping.offset_y));
        // Inside the half cell at 40, give or take the border and the English page's pen, left of the cell.
        EXPECT_GE(fill[0].x, 39.0f);
        EXPECT_LE(fill[1].x, 49.0f);
        if (style == FUCHI_OUTLINE || style == FUCHI_OUTLINE_THICK || style == FUCHI_OUTLINE_WIDE) {
            const auto &rim = geometry.front();
            EXPECT_EQ(rim[0].color[0], 0);
            EXPECT_LT(rim[0].x, fill[0].x - 0.5f); // the rim reaches past the glyph
            EXPECT_TRUE(on_pixel(rim[0].x, mapping.scale_x, mapping.offset_x));
        }
    }

    // A kerned pen between pixels moves the glyph by its fraction: here 2.8 target pixels a logical one.
    auto fill_left = [&](float fraction) {
        geometry.clear();
        mgCDrawPrim prim;
        MySetPrim(&prim, 1, 0);
        prim.Begin(MG_PRIM_SPRITE);
        {
            const dc2::font::SubpixelPen pen(fraction);
            font.DrawChar(&prim, FontNo('W'), 40, 30, 0, font.color, 0x80);
        }
        prim.End();
        return geometry.back()[0].x * mapping.scale_x;
    };
    const float whole = fill_left(0.0f);
    EXPECT_NEAR(fill_left(0.75f) - whole, 0.75f * mapping.scale_x, 1.0f);
}

TEST(FontTags, BoundedUnicodeTagsRejectEveryTruncatedPrefix) {
    FontState state;
    LanguageCode = LANG_FRENCH;
    constexpr std::array<char, 9> tag{'[', 'U', 'N', 'I', '0', '0', 'a', '1', ']'};
    const std::string_view        complete(tag.data(), tag.size());
    EXPECT_EQ(dc2::font::AlphabeticalCode(complete), 0x5E);
    for (std::size_t size = 0; size < tag.size(); ++size) {
        EXPECT_EQ(dc2::font::AlphabeticalCode(complete.substr(0, size)), 0);
    }
    EXPECT_EQ(dc2::font::AlphabeticalCode("[UNI00a1x"), 0);
    LanguageCode = LANG_ENGLISH;
    EXPECT_EQ(dc2::font::AlphabeticalCode(complete), 0);
}

TEST(FontTags, AccentAliasesPreserveTheirCanonicalGlyphs) {
    FontState state;
    LanguageCode = LANG_FRENCH;
    constexpr std::array<std::pair<std::string_view, std::string_view>, 5> tags{
        {{"[UNI011d]", "[UNI00e8]"}, {"[UNI0129]", "[UNI00ea]"}, {"[UNI0155]", "[UNI00e0]"}, {"[UNI0171]", "[UNI00fb]"}, {"[UNI017f]", "[UNI00f9]"}}
    };
    for (const auto &[alias, canonical] : tags) {
        const auto expected = dc2::font::AlphabeticalCode(canonical);
        ASSERT_NE(expected, 0);
        EXPECT_EQ(dc2::font::AlphabeticalCode(alias), expected);
    }
}
