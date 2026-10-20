#include "kazarov_bridge/rust/lib.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <ranges>
#include <string>
#include <thread>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "gfx/gfx.hpp"
#include "kazarov/data_version.hpp"
#include "platform/archive_mount.hpp"
#include "platform/config_catalog.hpp"
#include "platform/datapacks.hpp"
#include "platform/firstrun.hpp"
#include "platform/vfs.hpp"
#include "video/player.hpp"

namespace fs = std::filesystem;

namespace {

/**
 * Bytes of one fixture file whose value depends on its seed.
 */
std::vector<std::uint8_t> Bytes(std::size_t size, std::uint8_t seed) {
    std::vector<std::uint8_t> bytes(size);
    for (std::size_t i = 0; i < size; ++i) {
        bytes[i] = static_cast<std::uint8_t>(i * 7 + seed);
    }
    return bytes;
}

void Write(const fs::path &path, const std::vector<std::uint8_t> &bytes) {
    fs::create_directories(path.parent_path());
    std::ofstream file(path, std::ios::binary);
    file.write(reinterpret_cast<const char *>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
}

void Write(const fs::path &path, const std::string &text) {
    Write(path, std::vector<std::uint8_t>(text.begin(), text.end()));
}

/**
 * Writes a deterministic ZIP of a directory with the same writer that publishes data.zip.
 */
void Pack(const fs::path &source, const fs::path &archive) {
    fs::create_directories(archive.parent_path());
    const auto from = source.u8string();
    const auto to = archive.u8string();
    kazarov::pack_directory(rust::Str(reinterpret_cast<const char *>(from.data()), from.size()),
                            rust::Str(reinterpret_cast<const char *>(to.data()), to.size()));
}

/**
 * A scratch game root holding converted data as directories and as data.zip.
 */
class DataArchive : public ::testing::Test {
protected:
    fs::path root = fs::temp_directory_path() / ("ct_data_archive_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    fs::path tree = root / "tree";

    void SetUp() override {
        Write(tree / "Menu/Example_0.png", Bytes(300, 1));
        Write(tree / "menu/example.json", std::string(R"({"schema_version":3,"groups":[0],"entries":[]})"));
        Write(tree / "chara/hero.bin", Bytes(5000, 2));
        Write(tree / "chara/pack.pac/pack.json", std::string(R"({"schema_version":1,"kind":"asset_directory"})"));
        Write(tree / "chara/pack.pac/member.bin", Bytes(17, 3));
        Write(tree / "empty.bin", std::vector<std::uint8_t>{});
    }

    void TearDown() override {
        datapacks::Clear();
        std::error_code error;
        fs::remove_all(root, error);
    }

    static std::vector<std::uint8_t> Read(const vfs::Ref &file) {
        std::vector<std::uint8_t> bytes;
        EXPECT_TRUE(vfs::Read(file, bytes)) << file.Display();
        return bytes;
    }
};

} // namespace

TEST_F(DataArchive, ArchiveMountMatchesTheDirectoryItWasPackedFrom) {
    Pack(tree, root / "data.zip");
    const auto archive = ArchiveMountOpen(root / "data.zip");
    const auto directory = vfs::OpenDirectory(tree);
    ASSERT_EQ(archive->Count(), directory->Count());
    for (std::size_t index = 0; index < directory->Count(); ++index) {
        const auto name = directory->Name(index);
        const auto packed = vfs::Find(archive, name);
        ASSERT_TRUE(packed) << name;
        EXPECT_EQ(packed.Name(), name);
        EXPECT_EQ(vfs::Size(packed), vfs::Size(vfs::Ref(directory, index))) << name;
        EXPECT_EQ(Read(packed), Read(vfs::Ref(directory, index))) << name;
    }
    EXPECT_EQ(vfs::Find(archive, "MENU/EXAMPLE_0.PNG").Name(), "Menu/Example_0.png");
    EXPECT_FALSE(vfs::Find(archive, "menu/missing.png"));
    EXPECT_FALSE(vfs::Find(archive, "../menu/example.json"));
    EXPECT_EQ(vfs::Find(archive, "chara/hero.bin").Display(), "data.zip!chara/hero.bin");
    EXPECT_FALSE(vfs::HostPath(vfs::Find(archive, "chara/hero.bin")));
}

TEST_F(DataArchive, StoredPngIsReadableAtItsAlignedOffsetAndCompressedFilesAreNot) {
    Pack(tree, root / "data.zip");
    const auto archive = ArchiveMountOpen(root / "data.zip");
    const auto png = vfs::Find(archive, "menu/example_0.png");
    const auto range = vfs::Stored(png);
    ASSERT_TRUE(range);
    EXPECT_EQ(range->offset % 64, 0u);
    EXPECT_EQ(range->length, 300u);
    std::vector<std::uint8_t> direct(range->length);
    std::ifstream             file(range->file, std::ios::binary);
    file.seekg(static_cast<std::streamoff>(range->offset));
    file.read(reinterpret_cast<char *>(direct.data()), static_cast<std::streamsize>(direct.size()));
    EXPECT_EQ(direct, Bytes(300, 1));
    EXPECT_FALSE(vfs::Stored(vfs::Find(archive, "chara/hero.bin")));

    std::array<std::uint8_t, 24> prefix{};
    ASSERT_TRUE(vfs::ReadPrefix(png, prefix));
    EXPECT_TRUE(std::equal(prefix.begin(), prefix.end(), Bytes(300, 1).begin()));
    ASSERT_TRUE(vfs::ReadPrefix(vfs::Find(archive, "chara/hero.bin"), prefix));
    EXPECT_TRUE(std::equal(prefix.begin(), prefix.end(), Bytes(5000, 2).begin()));

    std::vector<std::uint8_t> limited;
    EXPECT_FALSE(vfs::Read(vfs::Find(archive, "chara/hero.bin"), limited, 4999));
    EXPECT_TRUE(vfs::Read(vfs::Find(archive, "empty.bin"), limited));
    EXPECT_TRUE(limited.empty());
}

TEST_F(DataArchive, ArchiveStampsAreFixedAndNameTheEntry) {
    Pack(tree, root / "data.zip");
    const auto archive = ArchiveMountOpen(root / "data.zip");
    const auto hero = vfs::Find(archive, "chara/hero.bin");
    const auto stamp = vfs::Stamp(hero);
    EXPECT_FALSE(stamp.empty());
    EXPECT_EQ(stamp, vfs::Stamp(vfs::Find(archive, "CHARA/HERO.BIN")));
    EXPECT_NE(stamp, vfs::Stamp(vfs::Find(archive, "chara/pack.pac/member.bin")));
    const std::vector<vfs::Ref> sources{hero};
    EXPECT_EQ(datapacks::ImageDecodeKey("stamp", sources), datapacks::ImageDecodeKey("stamp", sources));
}

TEST_F(DataArchive, ArchiveListsDirectMembersAndImpliedDirectories) {
    Pack(tree, root / "data.zip");
    const auto archive = ArchiveMountOpen(root / "data.zip");
    auto       names = [](const std::vector<vfs::Member> &members) {
        std::vector<std::string> result;
        result.reserve(members.size());
        for (const auto &member : members) {
            result.push_back(member.name + (member.directory ? "/" : ""));
        }
        std::ranges::sort(result);
        return result;
    };
    EXPECT_EQ(names(archive->List("CHARA")), (std::vector<std::string>{"hero.bin", "pack.pac/"}));
    EXPECT_EQ(names(archive->List("")), (std::vector<std::string>{"Menu/", "chara/", "empty.bin"}));
    EXPECT_TRUE(archive->List("missing").empty());
}

TEST_F(DataArchive, OverlayPrefersLaterFilesAndFindsNewLooseFiles) {
    Pack(tree, root / "data.zip");
    const auto archive = ArchiveMountOpen(root / "data.zip");
    const auto loose_root = root / "loose";
    Write(loose_root / "CHARA/HERO.BIN", std::string("loose hero"));
    Write(loose_root / "menu/setting.cfg.json", std::string(R"({"schema_version":1})"));
    const auto overlay = vfs::Overlay({archive, vfs::OpenDirectory(loose_root)});

    const auto hero = vfs::Find(overlay, "chara/hero.bin");
    ASSERT_TRUE(hero);
    EXPECT_EQ(hero.Name(), "CHARA/HERO.BIN");
    EXPECT_EQ(Read(hero), (std::vector<std::uint8_t>{'l', 'o', 'o', 's', 'e', ' ', 'h', 'e', 'r', 'o'}));
    EXPECT_EQ(vfs::Size(hero), 10u);
    ASSERT_TRUE(vfs::HostPath(hero));
    EXPECT_EQ(*vfs::HostPath(hero), loose_root / "CHARA/HERO.BIN");
    EXPECT_FALSE(vfs::Stored(hero));
    EXPECT_FALSE(vfs::Stamp(hero).empty());
    std::array<std::uint8_t, 5> prefix{};
    ASSERT_TRUE(vfs::ReadPrefix(hero, prefix));
    EXPECT_EQ(prefix, (std::array<std::uint8_t, 5>{'l', 'o', 'o', 's', 'e'}));
    std::array<std::uint8_t, 10> whole{};
    ASSERT_TRUE(vfs::ReadInto(hero, whole.data(), whole.size()));
    EXPECT_EQ(whole[0], 'l');

    const auto png = vfs::Find(overlay, "menu/example_0.png");
    ASSERT_TRUE(png);
    EXPECT_EQ(Read(png), Bytes(300, 1));
    EXPECT_TRUE(vfs::Stored(png));
    EXPECT_FALSE(vfs::HostPath(png));
    EXPECT_TRUE(vfs::Find(overlay, "MENU/SETTING.CFG.JSON"));
    const auto menu = overlay->List("menu");
    EXPECT_TRUE(std::ranges::any_of(menu, [](const vfs::Member &member) { return member.name == "setting.cfg.json"; }));

    const auto original_index = hero.index();
    Write(loose_root / "new/document.map.json", std::string("{}"));
    const auto added = vfs::Find(overlay, "new/document.map.json");
    ASSERT_TRUE(added);
    EXPECT_EQ(Read(added), (std::vector<std::uint8_t>{'{', '}'}));
    EXPECT_EQ(vfs::Find(overlay, "CHARA/HERO.BIN").index(), original_index);

    const auto png_index = png.index();
    Write(loose_root / "menu/example_0.png", std::string("replacement"));
    const auto replaced = vfs::Find(overlay, "menu/example_0.png");
    ASSERT_TRUE(replaced);
    EXPECT_EQ(replaced.index(), png_index);
    EXPECT_EQ(Read(replaced), (std::vector<std::uint8_t>{'r', 'e', 'p', 'l', 'a', 'c', 'e', 'm', 'e', 'n', 't'}));
    EXPECT_TRUE(vfs::HostPath(replaced));
}

TEST_F(DataArchive, ConcurrentReadsReturnEveryEntryIntact) {
    Pack(tree, root / "data.zip");
    const auto               archive = ArchiveMountOpen(root / "data.zip");
    std::atomic<int>         failures = 0;
    std::vector<std::thread> threads;
    threads.reserve(16);
    for (int worker = 0; worker < 16; ++worker) {
        threads.emplace_back([&] {
            for (int pass = 0; pass < 50; ++pass) {
                std::vector<std::uint8_t> hero;
                std::vector<std::uint8_t> png;
                if (!vfs::Read(vfs::Find(archive, "chara/hero.bin"), hero) || hero != Bytes(5000, 2) ||
                    !vfs::Read(vfs::Find(archive, "menu/example_0.png"), png) || png != Bytes(300, 1)) {
                    ++failures;
                }
            }
        });
    }
    for (auto &thread : threads) {
        thread.join();
    }
    EXPECT_EQ(failures, 0);
}

TEST_F(DataArchive, OverrideIndexMergesZipAndFolderPacksByLoadOrder) {
    Pack(tree, root / "data.zip");
    Write(root / "staging/low/chara/HERO.BIN", Bytes(10, 4));
    Write(root / "staging/low/chara/extra.bin", Bytes(11, 5));
    Pack(root / "staging/low", root / "datapacks/low.zip");
    Write(root / "datapacks/middle/Chara/hero.bin", Bytes(12, 6));
    Write(root / "staging/high/chara/hero.bin", Bytes(13, 7));
    Pack(root / "staging/high", root / "datapacks/high.zip");
    Write(root / "datapacks/datapacks.json", std::string(R"({"schema_version":1,"load_order":["low","middle","high.zip"]})"));
    datapacks::Load(root / "data.zip");
    ASSERT_TRUE(datapacks::Base());

    const auto candidates = datapacks::Candidates("CHARA/hero.bin");
    ASSERT_EQ(candidates.size(), 4u);
    EXPECT_EQ(candidates[0].Display(), "high.zip!chara/hero.bin");
    EXPECT_TRUE(candidates[1].Display().ends_with("middle/Chara/hero.bin"));
    EXPECT_EQ(candidates[2].Display(), "low.zip!chara/HERO.BIN");
    EXPECT_EQ(candidates[3].Display(), "data.zip!chara/hero.bin");
    EXPECT_EQ(Read(candidates[0]), Bytes(13, 7));
    EXPECT_TRUE(datapacks::IsReplacement(candidates[0]));
    EXPECT_FALSE(datapacks::IsReplacement(candidates[3]));
    EXPECT_EQ(datapacks::Resolve("chara/hero.bin")->Display(), "high.zip!chara/hero.bin");
    EXPECT_EQ(Read(*datapacks::Asset("chara/extra.bin")), Bytes(11, 5));
    EXPECT_FALSE(datapacks::Resolve("chara/pack.pac/member.bin"));
    EXPECT_EQ(datapacks::Asset("chara/pack.pac/member.bin")->Display(), "data.zip!chara/pack.pac/member.bin");

    const auto members = datapacks::DirectoryMembers("chara");
    EXPECT_EQ(members, (std::vector<fs::path>{"chara/extra.bin", "chara/hero.bin", "chara/pack.pac"}));

    Write(root / "datapacks/datapacks.json", std::string(R"({"schema_version":1,"load_order":["high","low"]})"));
    datapacks::Load(root / "data.zip");
    EXPECT_EQ(datapacks::Resolve("chara/hero.bin")->Display(), "low.zip!chara/HERO.BIN");
}

TEST_F(DataArchive, TextureOverrideZipUsesItsContentsWithoutPackManifest) {
    const std::string document = "textures/menu/0/save.json";
    const std::string png = "textures/menu/0/save_0.png";
    Write(tree / document,
          R"({"schema_version":3,"groups":[0],"entries":[{"name":"blank","pictures":[{"canvas":{"width":2,"height":2}}]}]})");
    Pack(tree, root / "data.zip");
    const auto staging = root / "staging/detail";
    Write(staging / document,
          R"({"schema_version":3,"groups":[0],"entries":[{"name":"added","pictures":[{"levels":["save_0.png"]}]}]})");
    fs::create_directories((staging / png).parent_path());
    const std::array<uint8_t, 16> pixels{80, 80, 80, 255, 80, 80, 80, 255,
                                         80, 80, 80, 255, 80, 80, 80, 255};
    ASSERT_TRUE(gfx::WritePng(staging / png, pixels.data(), 2, 2));
    Write(staging / "textures/pack-only/image.png", Bytes(1, 7));
    Write(staging / "pack.json", R"({"schema_version":1,"texture_members":[]})");
    Pack(staging, root / "datapacks/detail.zip");
    Write(root / "datapacks/datapacks.json", R"({"schema_version":1,"load_order":["detail"]})");

    const auto base = ArchiveMountOpen(root / "data.zip");
    texture_catalog::Load(base);
    datapacks::Load(base, root / "data.zip");
    texture_catalog::SetCandidateResolver(datapacks::Candidates);
    const auto members = datapacks::DirectoryMembers("textures");
    EXPECT_NE(std::ranges::find(members, fs::path("textures/pack-only")), members.end());
    const auto *source = texture_catalog::Find(document);
    ASSERT_NE(source, nullptr);
    ASSERT_EQ(source->entries.size(), 1u);
    EXPECT_EQ(source->entries[0].name, "added");
    ASSERT_EQ(source->entries[0].variants[0].levels.size(), 1u);
    const auto &level = source->entries[0].variants[0].levels[0];
    EXPECT_EQ(level.path, png);
    EXPECT_EQ(level.file.Display(), "detail.zip!" + png);
    const auto override = datapacks::Resolve(png);
    ASSERT_TRUE(override);
    EXPECT_EQ(override.value().Display(), level.file.Display());
    datapacks::DecodedTexture decoded;
    std::string               error;
    ASSERT_TRUE(datapacks::Decode(source->entries[0], 0, decoded, error)) << error;
    ASSERT_EQ(decoded.levels.size(), 1u);
    EXPECT_EQ(decoded.levels[0][0], 80);
    texture_catalog::Clear();
}

TEST_F(DataArchive, DataReadLoadsFromDataZipWithoutDirectories) {
    const std::string gameplay = R"({"schema_version":2,"kind":"weapon","records":[]})";
    Write(tree / "gameplay/menu/cfg7/wepdat.cfg.json", gameplay);
    Pack(tree, root / "data.zip");
    Write(root / "data.json", R"({"schema_version":1,"data_version":)" + std::to_string(KAZAROV_DATA_VERSION) + "}");
    EXPECT_FALSE(FirstRunDataMissing(root / "data"));
    DataReadIndex(root / "data");
    const auto found = DataReadFind("cdrom0:\\CHARA\\HERO.BIN;1");
    ASSERT_TRUE(found);
    EXPECT_EQ(found->Display(), "data.zip!chara/hero.bin");

    std::vector<std::uint8_t> buffer(8192, 0xAA);
    int                       size = 0;
    char                      name[] = "chara/hero.bin";
    ASSERT_EQ(LoadFile2(name, buffer.data(), &size, LOAD_FILE_READ), 1);
    ASSERT_EQ(size, 5000);
    const auto expected = Bytes(5000, 2);
    EXPECT_TRUE(std::equal(expected.begin(), expected.end(), buffer.begin()));
    EXPECT_TRUE(std::all_of(buffer.begin() + 5000, buffer.begin() + 6144, [](std::uint8_t value) { return value == 0; }));
    EXPECT_EQ(DataReadScriptKeys().size(), 0u);
    EXPECT_FALSE(DataReadFind("missing.bin"));
    const auto settings = DataReadFind("menu/cfg7/wepdat.cfg.json");
    if (!settings) {
        FAIL() << "archived gameplay document is missing";
    }
    EXPECT_EQ(settings->Display(), "data.zip!gameplay/menu/cfg7/wepdat.cfg.json");
    EXPECT_FALSE(datapacks::Asset("menu/cfg7/wepdat.cfg.json"));
    EXPECT_FALSE(vfs::HostPath(*settings));
    EXPECT_EQ(Read(*settings), (std::vector<std::uint8_t>(gameplay.begin(), gameplay.end())));
    char gameplay_name[] = "menu/cfg7/wepdat.cfg.json";
    ASSERT_EQ(LoadFile2(gameplay_name, buffer.data(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, gameplay.size());
    EXPECT_EQ(std::memcmp(buffer.data(), gameplay.data(), gameplay.size()), 0);
    EXPECT_EQ(DataReadBufferPath(buffer.data()), gameplay_name);
    EXPECT_EQ(DataReadAssetPath(gameplay_name), gameplay_name);
    EXPECT_EQ(DataReadNativeKeys("menu/cfg7"), (std::vector<std::string>{gameplay_name}));
    EXPECT_FALSE(DataReadFind("character_clips.json"));
}

TEST_F(DataArchive, ImageOutsideAnyPackIsFoundBelowTexturesFromItsRetailDirectory) {
    const std::string document = R"({"schema_version":3,"groups":[0],"entries":[]})";
    Write(tree / "textures/event/e100/e110/e110telop01_1.json", document);
    Write(tree / "event/e100/e110/e110.txt", std::string("text"));
    Pack(tree, root / "data.zip");
    Write(root / "data.json", R"({"schema_version":1,"data_version":)" + std::to_string(KAZAROV_DATA_VERSION) + "}");
    DataReadIndex(root / "data");

    // The boss scene changes to its event directory and loads the title card by its bare name.
    char directory[] = "event/e100/e110/";
    ChangeDir(directory);
    std::vector<std::uint8_t> buffer(4096, 0xAA);
    int                       size = 0;
    char                      name[] = "E110TELOP01_1.json";
    ASSERT_EQ(LoadFile2(name, buffer.data(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, document.size());
    EXPECT_EQ(DataReadAssetPath(name), "textures/event/e100/e110/e110telop01_1.json");
    char text[] = "e110.txt";
    EXPECT_EQ(DataReadAssetPath(text), "event/e100/e110/e110.txt");
    char missing[] = "e110telop01_2.json";
    EXPECT_FALSE(DataReadAssetPath(missing));
    SetCurrentDir(nullptr);
    EXPECT_EQ(DataReadAssetPath("textures/event/e100/e110/e110telop01_1.json"), "textures/event/e100/e110/e110telop01_1.json");
    EXPECT_FALSE(DataReadAssetPath("e110telop01_1.json"));
}

TEST_F(DataArchive, GameplayDocumentsPreservePackPriorityAcrossNamespacedAndLegacyPaths) {
    const std::string relative = "menu/cfg7/wepdat.cfg.json";
    Write(tree / "gameplay" / relative, "base");
    Pack(tree, root / "data.zip");
    Write(root / "datapacks/low/gameplay" / relative, "low");
    Write(root / "datapacks/high" / relative, "legacy high");
    Write(root / "datapacks/datapacks.json", std::string(R"({"schema_version":1,"load_order":["low","high"]})"));
    DataReadIndex(root / "data");

    const auto candidates = config_catalog::Paths(relative);
    ASSERT_EQ(candidates.size(), 3u);
    EXPECT_TRUE(candidates[0].Display().ends_with("high/" + relative));
    EXPECT_TRUE(candidates[1].Display().ends_with("low/gameplay/" + relative));
    EXPECT_EQ(candidates[2].Display(), "data.zip!gameplay/" + relative);
    const auto legacy = DataReadFind(relative.c_str());
    if (!legacy) {
        FAIL() << "legacy gameplay replacement is missing";
    }
    EXPECT_EQ(legacy->Display(), candidates[0].Display());

    Write(root / "datapacks/high/gameplay" / relative, "namespaced high");
    DataReadIndex(root / "data");
    const auto selected = DataReadFind(relative.c_str());
    if (!selected) {
        FAIL() << "namespaced gameplay replacement is missing";
    }
    EXPECT_TRUE(selected->Display().ends_with("high/gameplay/" + relative));
}

TEST_F(DataArchive, MoviePlaysIdenticallyFromAStoredArchiveEntry) {
    const auto fixture = fs::path(__FILE__).parent_path() / "fixtures/movie.mp4";
    fs::create_directories(root / "movies/movie");
    fs::copy_file(fixture, root / "movies/movie/clip.mp4");
    Pack(root / "movies", root / "data.zip");
    datapacks::Load(root / "data.zip");
    ASSERT_TRUE(vfs::Stored(*datapacks::Asset("movie/clip.mp4")));

    video::MoviePlayer direct;
    video::MoviePlayer archived;
    ASSERT_TRUE(direct.Open(fixture, true));
    ASSERT_TRUE(archived.Open("movie/clip.mp4", true));
    ASSERT_NE(archived.Audio(), nullptr);
    EXPECT_EQ(archived.Audio()->samples, direct.Audio()->samples);
    for (int64_t elapsed = 0; elapsed <= 10800; elapsed += 1800) {
        EXPECT_EQ(archived.Advance(elapsed), direct.Advance(elapsed));
        EXPECT_EQ(archived.Rgba(), direct.Rgba());
        EXPECT_EQ(archived.PicturesShown(), direct.PicturesShown());
        EXPECT_EQ(archived.Ended(), direct.Ended());
    }
    EXPECT_TRUE(archived.Ended());
}
