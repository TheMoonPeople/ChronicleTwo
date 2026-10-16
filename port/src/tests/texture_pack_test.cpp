#include <gtest/gtest.h>

#include <array>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <string_view>
#include <utility>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "gfx/gfx.hpp"
#include "platform/datapacks.hpp"
#include "platform/texture_catalog.hpp"

namespace {

/**
 * Provides isolated native texture documents and their matching data root.
 */
class TextureDocumentFixture : public testing::Test {
protected:
    std::filesystem::path base = std::filesystem::temp_directory_path() /
                                 ("texture_pack_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count())); /**< Isolated fixture root. */
    std::filesystem::path data = base / "data";                                                                                   /**< Existing disc-data directory. */
    std::filesystem::path native = base / "port_data";                                                                            /**< Direct native asset directory. */

    void SetUp() override {
        std::filesystem::create_directories(data);
        std::filesystem::create_directories(native);
    }

    void TearDown() override {
        texture_catalog::Clear();
        datapacks::Clear();
        std::error_code error;
        std::filesystem::remove_all(base, error);
    }

    void Write(std::string_view relative, std::string_view contents) const {
        const auto path = native / relative;
        std::filesystem::create_directories(path.parent_path());
        std::ofstream output(path, std::ios::binary);
        output.write(contents.data(), static_cast<std::streamsize>(contents.size()));
    }

    void Pixel(std::string_view relative) const {
        const auto path = native / relative;
        std::filesystem::create_directories(path.parent_path());
        constexpr std::array<uint8_t, 4> rgba{32, 64, 128, 255};
        ASSERT_TRUE(gfx::WritePng(path, rgba.data(), 1, 1));
    }

    void Reload() const {
        std::string error;
        ASSERT_TRUE(texture_catalog::Load(native, error)) << error;
    }
};

} // namespace

TEST_F(TextureDocumentFixture, ReadsDistinctNativeJsonDocumentsBeneathArchiveDirectory) {
    constexpr std::string_view first =
        R"({"schema_version":3,"groups":[0],"entries":[{"name":"first","pictures":[{"levels":["a_0.png"]}]}]})";
    constexpr std::string_view second =
        R"({"schema_version":3,"groups":[0],"entries":[{"name":"second","pictures":[{"levels":["b_0.png"]}]}]})";
    Write("chara/foo.chr/a.json", first);
    Write("chara/foo.chr/b.json", second);
    Pixel("chara/foo.chr/a_0.png");
    Pixel("chara/foo.chr/b_0.png");
    DataReadIndex(data);

    EXPECT_FALSE(DataReadFind("chara/foo.chr/a.img"));
    for (const auto &[relative, expected] :
         {
             std::pair{"chara/foo.chr/a.json", first },
             std::pair{"chara/foo.chr/b.json", second}
    }) {
        const auto physical = DataReadFind(relative);
        ASSERT_TRUE(physical);
        EXPECT_TRUE(std::filesystem::equivalent(*vfs::HostPath(*physical), native / relative));
        std::array<u_long128, 128> buffer{};
        std::string                path(relative);
        int                        size = -1;
        ASSERT_EQ(LoadFile2(path.data(), buffer.data(), &size, LOAD_FILE_READ), 1);
        EXPECT_EQ(size, expected.size());
        EXPECT_EQ(std::memcmp(buffer.data(), expected.data(), expected.size()), 0);
        EXPECT_EQ(DataReadBufferSize(buffer.data()), expected.size());
        EXPECT_EQ(DataReadBufferPath(buffer.data()), relative);
        const auto *source = texture_catalog::Find(relative);
        ASSERT_NE(source, nullptr);
        ASSERT_EQ(source->entries.size(), 1u);
        EXPECT_EQ(source->entries[0].width, 1);
        EXPECT_EQ(source->entries[0].height, 1);
    }
}

TEST_F(TextureDocumentFixture, RejectsMalformedDirectDocumentsAndUnsafeReferences) {
    const auto rejected = [&](std::string_view contents) {
        Write("source.json", contents);
        Reload();
        EXPECT_EQ(texture_catalog::Find("source.json"), nullptr);
    };
    rejected(R"({"schema_version":3.5,"groups":[0],"entries":[]})");
    rejected(R"({"schema_version":3,"groups":[0],"entries":[],"source":"old.img"})");
    rejected(R"({"schema_version":3,"groups":[0],"entries":[{"name":"old","pictures":[{"canvas":{"width":2,"height":2},"source_bpp":8}]}]})");
    rejected(R"({"schema_version":3,"groups":[0],"entries":[{"name":"fractional","block":0.5,"pictures":[{"canvas":{"width":2,"height":2}}]}]})");
    rejected(R"({"schema_version":3,"groups":[0],"entries":[{"name":"fractional","pictures":[{"canvas":{"width":2.5,"height":2}}]}]})");
    rejected(R"({"schema_version":3,"groups":[0],"entries":[{"name":"bad","pictures":[{"levels":["../outside.png"]}]}]})");
    rejected(R"({"schema_version":3,"groups":[0],"entries":[{"name":"embedded","pictures":[{"levels":["#/images/0"]}]}]})");

    Write("source.json", R"({"schema_version":3,"groups":[],"entries":[{"name":"#anime","script":[]}]})");
    Reload();
    const auto *source = texture_catalog::Find("source.json");
    ASSERT_NE(source, nullptr);
    EXPECT_TRUE(source->groups.empty());
    EXPECT_EQ(texture_catalog::Find("source.img"), nullptr);
    EXPECT_EQ(texture_catalog::Find("../source.json"), nullptr);
    EXPECT_EQ(texture_catalog::Find("/source.json"), nullptr);
    EXPECT_EQ(texture_catalog::Find("source.json#offset:80"), nullptr);
}

TEST_F(TextureDocumentFixture, ResolvesNestedTextureByExplicitJsonPath) {
    constexpr std::string_view relative = "dungeon/eff_script/e211aex_knife.json";
    constexpr std::string_view document =
        R"({"schema_version":3,"groups":[0],"entries":[{"name":"knife","pictures":[{"levels":["e211aex_knife_0.png"]}]}]})";
    Write(relative, document);
    Pixel("dungeon/eff_script/e211aex_knife_0.png");
    DataReadIndex(data);

    const auto physical = DataReadFind(relative.data());
    ASSERT_TRUE(physical);
    EXPECT_TRUE(std::filesystem::equivalent(*vfs::HostPath(*physical), native / relative));
    const auto *source = texture_catalog::Find(relative);
    ASSERT_NE(source, nullptr);
    ASSERT_EQ(source->entries.size(), 1u);
    EXPECT_EQ(source->entries[0].name, "knife");
    EXPECT_EQ(source->entries[0].variants[0].levels[0].path, "dungeon/eff_script/e211aex_knife_0.png");
    EXPECT_TRUE(std::filesystem::equivalent(*vfs::HostPath(source->entries[0].variants[0].levels[0].file), native / "dungeon/eff_script/e211aex_knife_0.png"));
    EXPECT_EQ(texture_catalog::Find("dungeon/eff_script/e211aex_knife.chr#offset:80"), nullptr);
}
