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
#include <string>
#include <thread>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "kazarov/data_version.hpp"
#include "platform/archive_mount.hpp"
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

    std::vector<std::uint8_t> Read(const vfs::Ref &file) {
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
    auto       names = [](std::vector<vfs::Member> members) {
        std::vector<std::string> result;
        for (const auto &member : members) {
            result.push_back(member.name + (member.directory ? "/" : ""));
        }
        std::sort(result.begin(), result.end());
        return result;
    };
    EXPECT_EQ(names(archive->List("CHARA")), (std::vector<std::string>{"hero.bin", "pack.pac/"}));
    EXPECT_EQ(names(archive->List("")), (std::vector<std::string>{"Menu/", "chara/", "empty.bin"}));
    EXPECT_TRUE(archive->List("missing").empty());
}

TEST_F(DataArchive, ConcurrentReadsReturnEveryEntryIntact) {
    Pack(tree, root / "data.zip");
    const auto               archive = ArchiveMountOpen(root / "data.zip");
    std::atomic<int>         failures = 0;
    std::vector<std::thread> threads;
    for (int worker = 0; worker < 16; ++worker) {
        threads.emplace_back([&] {
            for (int pass = 0; pass < 50; ++pass) {
                std::vector<std::uint8_t> hero, png;
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

TEST_F(DataArchive, DataReadLoadsFromDataZipWithoutDirectories) {
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
}

TEST_F(DataArchive, MoviePlaysIdenticallyFromAStoredArchiveEntry) {
    const auto fixture = fs::path(__FILE__).parent_path() / "fixtures/movie.mp4";
    fs::create_directories(root / "movies/movie");
    fs::copy_file(fixture, root / "movies/movie/clip.mp4");
    Pack(root / "movies", root / "data.zip");
    datapacks::Load(root / "data.zip");
    ASSERT_TRUE(vfs::Stored(*datapacks::Asset("movie/clip.mp4")));

    video::MoviePlayer direct, archived;
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
