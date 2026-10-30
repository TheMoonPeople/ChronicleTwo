#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <tuple>
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
#include "render/primitive_submission.hpp"
#include "text/glyph_mapping.hpp"

namespace {

std::array<std::uint8_t, 188> AsciiTable() {
    std::array<std::uint8_t, 188> table{};
    for (int i = 0; i < 94; ++i) {
        table[i * 2] = static_cast<std::uint8_t>(i + 0x20);
        table[i * 2 + 1] = 0x20;
    }
    return table;
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

} // namespace

TEST(FontPort, MapsOnlyVerifiedAsciiTableEntries) {
    auto table = AsciiTable();
    for (int i = 0; i < 94; ++i) {
        EXPECT_EQ(FontPortCharacter(LANG_ENGLISH, i, table), static_cast<char32_t>(i + 0x20));
    }
    EXPECT_EQ(FontPortCharacter(LANG_JAPANESE, 33, table), 0u);
    EXPECT_EQ(FontPortCharacter(LANG_ENGLISH, -1, table), 0u);
    EXPECT_EQ(FontPortCharacter(LANG_ENGLISH, 94, table), 0u);
    EXPECT_EQ(FontPortCharacter(LANG_ENGLISH, 0xfd06, table), 0u);
    EXPECT_EQ(FontPortCharacter(LANG_ENGLISH, 0xff00, table), 0u);
    EXPECT_EQ(FontPortCharacter(LANG_ENGLISH, 3, {table.data(), 3}), 0u);
    table[1] = 0x81;
    EXPECT_EQ(FontPortCharacter(LANG_ENGLISH, 0, table), 0u);
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

TEST(FontPortGpu, SharpDrawingKeepsRetailLayoutAndLineBreaks) {
    const char *file = SettingsEnv("TEST_FONT");
    if (!file || !std::filesystem::is_regular_file(PathsFromUtf8(file))) {
        GTEST_SKIP() << "TEST_FONT must name a trusted test font";
    }
    const auto root = std::filesystem::temp_directory_path() /
                      ("dc2_font_" + std::to_string(dc::test::ProcessId()));
    ASSERT_FALSE(std::filesystem::exists(root));
    std::filesystem::create_directories(root / "saves" / "lang");

    struct Cleanup {
        std::filesystem::path root;

        ~Cleanup() {
            std::error_code error;
            std::filesystem::remove_all(root, error);
        }
    } cleanup{root};

    std::filesystem::copy_file(PathsFromUtf8(file), root / "saves" / "lang" / "font.ttf");
    PathsSetSaveRoot(root / "saves");
    auto select = [&](const char *choice) {
        std::ofstream(root / "config.json") << R"({"video":{"text_font":")" << choice << "\"}}";
        EXPECT_TRUE(ConfigLoad());
    };
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
    EXPECT_EQ(new_w, old_w);
    EXPECT_EQ(new_h, old_h);
    EXPECT_EQ(old_w, 16 * 7); // Half-cell advance is 7, not 8 or the TrueType advance.
    EXPECT_EQ(old_h, 48);
    font.DrawDirect(direct, 40, 30);
    ASSERT_FALSE(textures.empty());
    EXPECT_NE(textures, original_textures); // The sharp painter actually ran; this is not fallback equality.
    EXPECT_NE(textures.front(), gfx::kNullTexture);
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

    // The sharp silhouette supplies every retail outline style and the fill's alpha multiplication.
    constexpr std::array<int, 9> passes = {1, 2, 2, 5, 3, 2, 5, 4, 13};
    char                         letter[] = "W";
    font.SetColor(23, 45, 67, 96);
    font.alpha = 64;
    for (int style = 0; style < FUCHI_NUM; ++style) {
        geometry.clear();
        textures.clear();
        font.SetFuchi(style);
        font.DrawDirect(letter, 40, 30);
        ASSERT_EQ(geometry.size(), 1u);
        EXPECT_EQ(geometry[0].size(), static_cast<std::size_t>(passes[style] * 4));
        const auto &fill = geometry[0][geometry[0].size() - 4];
        EXPECT_EQ(fill.color[0], 23);
        EXPECT_EQ(fill.color[1], 45);
        EXPECT_EQ(fill.color[2], 67);
        EXPECT_EQ(fill.color[3], 48);
        const auto texture = gfx::GetTextureInfo(textures[0]);
        ASSERT_TRUE(texture.has_value());
        const auto &right = geometry[0][geometry[0].size() - 3];
        EXPECT_GE(texture->width - 2, (right.x - fill.x) * 2.25f);
        EXPECT_GE(fill.x, 40.0f);
        EXPECT_LE(right.x, 48.0f);
    }
}
