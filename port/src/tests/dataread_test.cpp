#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include <algorithm>
#include <array>
#include <charconv>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <new>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "character_motion.hpp"
#include "dataread.hpp"
#include "gamedata.hpp"
#include "gameutil.hpp"
#include "inventmn.hpp"
#include "log_capture.hpp"
#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "platform/config_catalog.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "platform/vfs.hpp"
#include "runscript.hpp"
#include "script_text.hpp"
#include "scriptinterpreter.hpp"
#include "texture_source.hpp"

int LoadGameDataAnalyze(char *);

namespace fs = std::filesystem;

namespace {

/**
 * Releases the file cache before its backing test storage is destroyed.
 */
struct CacheReset {
    mgCMemory owner; /**< Keeps cache allocation metadata alive until references are retired. */

    dc2::memory::ArenaBuffer Bind(std::span<u_long128> storage) {
        if (storage.size() < 2) {
            return {};
        }
        owner.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        const auto count = storage.size() - 1;
        auto      *allocated = owner.Alloc(static_cast<int>(count));
        if (allocated == nullptr) {
            return {};
        }
        return dc2::memory::ArenaBuffer::Bind(owner, {reinterpret_cast<u8 *>(allocated), count * sizeof(u_long128)});
    }

    /**
     * Clears cached references to fixture storage.
     */
    ~CacheReset() { DeleteFileCache(); }
};

template <class T>
concept BorrowsFromTemporaryRead = requires { T{}.Bytes(); } || requires { T{}.PaddedBytes(); } ||
                                   requires { T{}.Name(); } || requires { T{}.Source(); };
static_assert(!BorrowsFromTemporaryRead<dc2::io::FileRead>);
static_assert(requires(const dc2::io::FileRead &read) { read.Bytes(); read.PaddedBytes(); read.Name(); read.Source(); });

constexpr std::size_t kFileSize = 3000;
constexpr std::size_t kPadded = 4096;

std::vector<unsigned char> MakeBytes(std::size_t size, unsigned char seed) {
    std::vector<unsigned char> bytes(size);
    for (std::size_t i = 0; i < size; i++) {
        bytes[i] = static_cast<unsigned char>(i * 31 + seed);
    }
    return bytes;
}

void WriteBytes(const fs::path &path, const std::vector<unsigned char> &bytes) {
    fs::create_directories(path.parent_path());
    std::ofstream out(path, std::ios::binary);
    out.write(reinterpret_cast<const char *>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
}

/**
 * Publishes native item table documents at the direct paths used by the native game.
 */
void WriteMenuConfigs(const fs::path &base, const std::vector<std::pair<std::string, nlohmann::json>> &documents) {
    const auto root = base / "data";
    fs::create_directories(root / "menu/cfg7");
    for (const auto &[name, document] : documents) {
        const auto relative = fs::path("menu/cfg7") / fs::path(name).replace_extension(".cfg.json");
        std::ofstream(root / relative) << document.dump();
    }
}

/**
 * Declares the minimal common item table used by native item-message tests.
 */
nlohmann::json ItemConfigCommands() {
    using Json = nlohmann::json;
    return Json{
        {"schema_version", 2              },
        {"kind",           "item_common"  },
        {"count",          1              },
        {"records",
         Json::array({{{"item_no", 11},
                       {"type", 0},
                       {"list_no", 0},
                       {"active_set", 0},
                       {"stack_num", 0},
                       {"max_num", 0},
                       {"icon_texture_no", 0},
                       {"icon_no", 0},
                       {"message_no", 0},
                       {"file_name", "x"},
                       {"attribute", 0}}})}
    };
}

/**
 * Supplies an item_messages document naming item 11 and an item without common data.
 */
nlohmann::json ItemMessageCommands(const char *name) {
    using Json = nlohmann::json;
    return Json{
        {"schema_version", 2                                                                                              },
        {"kind",           "item_messages"                                                                                },
        {"messages",       Json::array({{{"item_no", 11}, {"name", name}}, {{"item_no", 12}, {"name", "No common data"}}})}
    };
}

int Load(const char *name, std::span<u8> buffer, int *size) {
    std::string path(name);
    return LoadFile2(path.data(), buffer, size, LOAD_FILE_READ);
}

// The published asset root selected explicitly or found above the test executable.
std::optional<fs::path> ExtractedDataRoot() {
    const auto published = [](const fs::path &data) {
        std::error_code error;
        return fs::is_regular_file(data.parent_path() / "data.zip", error) || fs::is_directory(data, error);
    };
    if (const char *selected = std::getenv("DC2_DATA")) {
        const fs::path data(selected);
        if (published(data)) {
            return data;
        }
    }
    fs::path dir = PathsExecutable().parent_path();
    for (int up = 0; up < 6 && !dir.empty(); up++, dir = dir.parent_path()) {
        if (published(dir / "data")) {
            return dir / "data";
        }
    }
    return std::nullopt;
}

class DataRead : public testing::Test {
protected:
    void SetUp() override {
        InitReadBG();
        base = fs::temp_directory_path() /
               ("dataread_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        root = base / "data";
        WriteBytes(root / "DIR" / "Sub" / "File.BIN", MakeBytes(kFileSize, 7));
        const auto native = base / "data/chara/pack.pac";
        WriteBytes(native / "a.bin", MakeBytes(10, 1));
        WriteBytes(native / "b.bin", MakeBytes(300, 2));
        std::ofstream(native / "pack.json") << R"({"schema_version":1,"kind":"asset_directory"})";
        WriteBytes(root / "small.txt", MakeBytes(10, 3));
        buffer.assign(kPadded / sizeof(u_long128), 0);
    }

    void TearDown() override {
        InitReadBG();
        PathsReset();
        std::error_code error;
        fs::remove_all(base, error);
    }

    u_long128 *Buffer() { return buffer.data(); }

    std::span<u8> BufferBytes() { return {reinterpret_cast<u8 *>(buffer.data()), std::span(buffer).size_bytes()}; }

    fs::path base;
    fs::path root;

private:
    std::vector<u_long128> buffer;
};

using DataReadDeathTest = DataRead;

} // namespace

TEST_F(DataRead, IndexLogsItsCountAndRoot) {
    CaptureLoggedStderr();
    DataReadIndex(base / "absent");
    const auto        config_log = GetLoggedStderr();
    const std::string prefix = "dataread: indexed ";
    const auto        count_start = config_log.find(prefix);
    ASSERT_NE(count_start, std::string::npos) << config_log;
    std::size_t config_count = 0;
    const auto  parsed = std::from_chars(config_log.data() + count_start + prefix.size(),
                                         config_log.data() + config_log.size(), config_count);
    ASSERT_EQ(parsed.ec, std::errc{});
    CaptureLoggedStderr();
    DataReadIndex(root);
    std::string log = GetLoggedStderr();
    EXPECT_NE(log.find(prefix + std::to_string(config_count + 5) + " files under " + PathsDisplay(root)), std::string::npos) << log;
}

TEST_F(DataRead, RootExclusionsKeepDiscOnlyFilesOutOfTheIndex) {
    const fs::path root = base / "excluded";
    WriteBytes(root / "manifest.txt", MakeBytes(10, 1));
    WriteBytes(root / "manifest.json", MakeBytes(10, 1));
    WriteBytes(root / ".kazarov-data", MakeBytes(10, 2));
    WriteBytes(root / "movie" / "a.pss", MakeBytes(10, 3));
    WriteBytes(root / "sound" / "sound.dat", MakeBytes(10, 4));
    WriteBytes(root / "x.dc2tmp", MakeBytes(10, 5));
    WriteBytes(root / "small.txt", MakeBytes(10, 6));
    WriteBytes(root / "DIR" / "one.bin", MakeBytes(10, 7));
    WriteBytes(root / "map" / "movie" / "b.bin", MakeBytes(10, 8));

    CaptureLoggedStderr();
    DataReadIndex(root);
    std::string log = GetLoggedStderr();
    EXPECT_NE(log.find(" files under " + PathsDisplay(root)), std::string::npos) << log;

    for (const char *name : {"manifest.txt", "manifest.json", ".kazarov-data", "movie/a.pss", "sound/sound.dat", "x.dc2tmp"}) {
        EXPECT_FALSE(DataReadFind(name).has_value()) << name;
    }
    EXPECT_TRUE(DataReadFind("map/movie/b.bin").has_value());
}

TEST_F(DataRead, FindIsCaseInsensitiveAndAcceptsDevicePrefixes) {
    DataReadIndex(root);
    const fs::path expected = root / "DIR" / "Sub" / "File.BIN";
    for (const char *name : {R"(cdrom0:\DIR\SUB\FILE.BIN;1)", "host0:dir/sub/file.bin", "/DIR/Sub/File.BIN",
                             "dir\\sub\\file.bin;1", "cdrom:DIR/SUB/FILE.BIN"}) {
        std::optional<vfs::Ref> found = DataReadFind(name);
        ASSERT_TRUE(found.has_value()) << name;
        EXPECT_TRUE(fs::equivalent(*vfs::HostPath(*found), expected)) << name;
    }
}

TEST_F(DataRead, LoadFileReadsExactBytesThenZeroFillsTheSector) {
    DataReadIndex(root);
    std::memset(Buffer(), 0xAA, kPadded);
    int size = -1;

    ASSERT_EQ(Load("cdrom0:\\DIR\\SUB\\FILE.BIN;1", BufferBytes(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));

    const auto                      *bytes = reinterpret_cast<const unsigned char *>(Buffer());
    const std::vector<unsigned char> expected = MakeBytes(kFileSize, 7);
    EXPECT_EQ(std::memcmp(bytes, expected.data(), kFileSize), 0);
    const std::vector<unsigned char> tail(kPadded - kFileSize, 0);
    EXPECT_EQ(std::memcmp(bytes + kFileSize, tail.data(), tail.size()), 0);
}

// MenuCommonReadData loads into the top of an arena and reserves the file's size afterwards, but the load writes
// the whole sector. A motion set whose channels lie in that padding, with its anchor past the sector, must be
// forgotten though the reservation never reaches it and the anchor keeps its bytes.
TEST_F(DataRead, PaddedLoadForgetsMotionSetBeyondTheReservation) {
    DataReadIndex(root);
    constexpr int list_quadwords = static_cast<int>((sizeof(Mot_List) + 15) / 16);
    static char   key;
    auto         *buffer = reinterpret_cast<u_long128 *>(ArenaBlock(&key, kPadded));
    mgCMemory     arena;
    arena.stSetBuffer(buffer, static_cast<int>(kPadded / sizeof(u_long128)));
    arena.Alloc(512 / static_cast<int>(sizeof(u_long128)));
    const auto *storage = reinterpret_cast<const std::byte *>(arena.stGetTop());
    auto       *channel = ::new (arena.Alloc(list_quadwords)) Mot_List{.frame = -1, .key_count = 1};
    arena.Alloc(2048 / static_cast<int>(sizeof(u_long128)));
    auto *anchor = ::new (arena.Alloc(list_quadwords)) Mot_List{.frame = -1};
    ASSERT_GE(reinterpret_cast<const unsigned char *>(anchor) - reinterpret_cast<const unsigned char *>(buffer), 2048);
    tagMOTION_TYPE motion{};
    motion.motion_list = anchor;
    character_motion::Clear();
    character_motion::Action idle{.name = "idle", .duration = 10, .base = 0, .head = channel};
    character_motion::Register(anchor, {idle}, {storage, reinterpret_cast<const std::byte *>(arena.stGetTop())});
    std::array<std::byte, sizeof(Mot_List)> kept{};
    std::memcpy(kept.data(), anchor, kept.size());

    arena.stReset();
    int size = -1;
    ASSERT_EQ(Load("small.txt", dc2::memory::RemainingBytes(arena), &size), 1);
    arena.Alloc(size / 16 + (size % 16 != 0));
    ASSERT_EQ(std::memcmp(reinterpret_cast<const std::byte *>(anchor), kept.data(), kept.size()), 0);
    ASSERT_EQ(channel->key_count, 0u);
    EXPECT_TRUE(character_motion::Actions(motion).empty());
    character_motion::Clear();
}

TEST_F(DataRead, DatapacksOverrideIndexedFilesWithReplacementSizesAndSparseFallback) {
    const auto first = base / "datapacks" / "First pack";
    const auto last = base / "datapacks" / "Last pack";
    WriteBytes(first / "dir" / "sub" / "file.bin", MakeBytes(83, 11));
    WriteBytes(last / "DIR" / "Sub" / "File.BIN", MakeBytes(177, 19));
    WriteBytes(first / "small.txt", MakeBytes(27, 31));
    std::ofstream(base / "datapacks" / "datapacks.json")
        << R"({"schema_version":1,"load_order":["First pack","Last pack"]})";
    DataReadIndex(root);

    int  size = 0;
    char name[] = R"(cdrom0:\DIR\SUB\FILE.BIN;1)";
    ASSERT_EQ(LoadFile2(name, std::span<u8>{}, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, 177);
    ASSERT_EQ(Load(name, BufferBytes(), &size), 1);
    EXPECT_EQ(size, 177);
    const auto replacement = MakeBytes(177, 19);
    EXPECT_EQ(std::memcmp(Buffer(), replacement.data(), replacement.size()), 0);
    const auto found = DataReadFind(name);
    ASSERT_TRUE(found.has_value());
    EXPECT_TRUE(fs::equivalent(*vfs::HostPath(*found), last / "DIR" / "Sub" / "File.BIN"));

    ASSERT_EQ(Load("small.txt", BufferBytes(), &size), 1);
    EXPECT_EQ(size, 27);
    const auto sparse = MakeBytes(27, 31);
    EXPECT_EQ(std::memcmp(Buffer(), sparse.data(), sparse.size()), 0);
    ASSERT_EQ(Load("chara/pack.pac", BufferBytes(), &size), 1);
    const auto fallback = DataReadFind("chara/pack.pac");
    ASSERT_TRUE(fallback.has_value());
    EXPECT_TRUE(fs::equivalent(*vfs::HostPath(*fallback), base / "data/chara/pack.pac/pack.json"));

    std::ofstream(base / "datapacks" / "datapacks.json")
        << R"({"schema_version":1,"load_order":["Last pack","First pack"]})";
    DataReadIndex(root);
    ASSERT_EQ(Load(name, BufferBytes(), &size), 1);
    EXPECT_EQ(size, 83);
    const auto reordered = MakeBytes(83, 11);
    EXPECT_EQ(std::memcmp(Buffer(), reordered.data(), reordered.size()), 0);
}

TEST_F(DataRead, DatapacksUseSelectedExtractionWithTrailingSeparator) {
    WriteBytes(base / "datapacks" / "Selected" / "small.txt", MakeBytes(41, 15));
    std::ofstream(base / "datapacks" / "datapacks.json")
        << R"({"schema_version":1,"load_order":["Selected"]})";
    DataReadIndex(root / "");
    int size = 0;
    ASSERT_EQ(Load("small.txt", BufferBytes(), &size), 1);
    EXPECT_EQ(size, 41);
}

TEST_F(DataRead, ConvertedTextureLoadsItsActualJsonWithoutACatalog) {
    const fs::path native = base / "data";
    fs::create_directories(native / "img");
    const std::string json = R"({"schema_version":3,"groups":[0],"entries":[]})";
    std::ofstream(native / "img/foo.json")
        << R"({"schema_version":3,"groups":[0],"entries":[]})";
    DataReadIndex(root);
    EXPECT_FALSE(DataReadFind("img/foo.img").has_value());

    int  size = -1;
    char name[] = "cdrom0:\\IMG\\FOO.JSON;1";
    ASSERT_EQ(LoadFile2(name, std::span<u8>{}, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, json.size());
    std::memset(Buffer(), 0xAA, kPadded);
    ASSERT_EQ(Load(name, BufferBytes(), &size), 1);
    EXPECT_EQ(size, json.size());
    const auto *bytes = reinterpret_cast<const unsigned char *>(Buffer());
    EXPECT_EQ(std::memcmp(bytes, json.data(), json.size()), 0);
    EXPECT_TRUE(std::all_of(bytes + json.size(), bytes + 2048, [](unsigned char value) { return value == 0; }));
    EXPECT_EQ(DataReadBufferPath(Buffer()), "img/foo.json");

    ASSERT_EQ(Load("small.txt", BufferBytes(), &size), 1);
    EXPECT_EQ(TextureSourceLookup(Buffer()), "small.txt");
}

TEST_F(DataRead, DirectoryReadLoadsActualVersionMetadataAndMemberBytes) {
    DataReadIndex(root);
    int size = 0;
    ASSERT_EQ(Load("chara/pack.pac", BufferBytes(), &size), 1);
    EXPECT_EQ(DataReadBufferPath(Buffer()), "chara/pack.pac/pack.json");
    char   member[] = "a.bin";
    u_int *data = AssetDirectoryRead(Buffer(), member, nullptr);
    ASSERT_NE(data, nullptr);
    EXPECT_EQ(TextureSourceLookup(data), "chara/pack.pac/a.bin");
}

TEST_F(DataRead, LoadFileAcceptsPlainAndUpperCaseNames) {
    DataReadIndex(root);
    int  size = 0;
    char plain[] = "dir/sub/file.bin";
    char upper[] = "DIR\\SUB\\FILE.BIN;1";
    EXPECT_EQ(LoadFile(plain, BufferBytes(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
    EXPECT_EQ(LoadFile(upper, BufferBytes(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
}

TEST_F(DataReadDeathTest, LoadFileExitsWhenTheFileIsMissing) {
    DataReadIndex(root);
    int  size = 0;
    char name[] = "dir/nope/missing.bin";
    EXPECT_EXIT(LoadFile(name, BufferBytes(), &size), testing::ExitedWithCode(EXIT_FAILURE), "File open error \"dir/nope/missing.bin\"");
}

TEST_F(DataRead, MissingFileReturnsZeroWithoutAborting) {
    DataReadIndex(root);
    int size = 99;
    EXPECT_EQ(Load("cdrom0:\\NOPE\\MISSING.BIN;1", BufferBytes(), &size), 0);
    EXPECT_EQ(size, 0);
}

TEST_F(DataRead, SizeModeReportsWithoutReading) {
    DataReadIndex(root);
    char name[] = "DIR/Sub/File.BIN";
    int  size = 0;
    EXPECT_EQ(LoadFile2(name, std::span<u8>{}, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
}

TEST_F(DataRead, BoundedLoadRejectsOversizedAssetBeforeWritingAndReadsValidAsset) {
    DataReadIndex(root);
    std::array<u8, DATAREAD_SECTOR_SIZE + 2> bytes{};
    bytes.fill(0xA5);
    const auto destination = std::span<u8>(bytes.data(), DATAREAD_SECTOR_SIZE);
    int        size = 99;
    char       large[] = "DIR/Sub/File.BIN";
    EXPECT_EQ(LoadFile2(large, destination, &size, LOAD_FILE_READ), 0);
    EXPECT_EQ(size, 0);
    EXPECT_TRUE(std::all_of(bytes.begin(), bytes.end(), [](u8 value) { return value == 0xA5; }));

    char small[] = "small.txt";
    ASSERT_EQ(LoadFile2(small, destination, &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, 10);
    EXPECT_EQ(bytes[0], 3);
    EXPECT_TRUE(std::all_of(bytes.begin() + size, bytes.begin() + DATAREAD_SECTOR_SIZE,
                            [](u8 value) { return value == 0; }));
    EXPECT_EQ(bytes[DATAREAD_SECTOR_SIZE], 0xA5);
    EXPECT_EQ(bytes[DATAREAD_SECTOR_SIZE + 1], 0xA5);
}

TEST_F(DataRead, BoundedBackgroundLoadCopiesBeforePollingWithoutTouchingSentinel) {
    DataReadIndex(root);
    StartReadBG();
    std::array<u8, DATAREAD_SECTOR_SIZE + 2> bytes{};
    bytes.fill(0xA5);
    const auto destination = std::span<u8>(bytes.data(), DATAREAD_SECTOR_SIZE);
    int        size = 99;
    char       large[] = "DIR/Sub/File.BIN";
    EXPECT_EQ(LoadFileBG(large, destination, &size), 0);
    EXPECT_EQ(size, 0);
    EXPECT_TRUE(std::all_of(bytes.begin(), bytes.end(), [](u8 value) { return value == 0xA5; }));

    char small[] = "small.txt";
    ASSERT_EQ(LoadFileBG(small, destination, &size), 1);
    EXPECT_EQ(size, 10);
    EXPECT_EQ(bytes[0], 3);
    EXPECT_EQ(bytes[DATAREAD_SECTOR_SIZE], 0xA5);
    EXPECT_EQ(bytes[DATAREAD_SECTOR_SIZE + 1], 0xA5);
}

TEST_F(DataRead, OwningPathSplitPreservesDirectoryAndFirstExtensionForLongNames) {
    const std::string long_name(500, 'a');
    const std::string path = "assets/sub/" + long_name + ".part.json";
    const auto [directory, filename] = DivPathName(std::string_view(path));
    EXPECT_EQ(directory, "assets/sub/");
    EXPECT_EQ(filename, long_name + ".part.json");
    const auto split = DivPathNameExt(std::string_view(path));
    EXPECT_EQ(split.directory, directory);
    EXPECT_EQ(split.name, long_name);
    EXPECT_EQ(split.extension, "part.json");
    const auto rooted = DivPathName(std::string_view("/name.ext"));
    EXPECT_TRUE(rooted.first.empty());
    EXPECT_EQ(rooted.second, "/name.ext");
}

TEST_F(DataRead, CurrentDirectoryPrefixesRelativeNames) {
    DataReadIndex(root);
    char dir[] = "DIR/Sub/";
    ChangeDir(dir);
    EXPECT_EQ(GetCurrentDir(), "DIR/Sub/");

    int  size = 0;
    char relative[] = "file.bin";
    char anchored[] = "/small.txt";
    EXPECT_EQ(LoadFile2(relative, BufferBytes(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
    EXPECT_EQ(LoadFile2(anchored, BufferBytes(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, 10);

    ChangeDir(nullptr);
    char missing[] = "file.bin";
    EXPECT_EQ(LoadFile2(missing, BufferBytes(), &size, LOAD_FILE_READ), 0);

    SetCurrentDir(nullptr);
    EXPECT_TRUE(GetCurrentDir().empty());
}

TEST_F(DataRead, FolderMemberIsFoundByItsActualRelativeName) {
    DataReadIndex(root);
    int size = 0;
    ASSERT_EQ(Load("chara/pack.pac", BufferBytes(), &size), 1);

    auto *pack = reinterpret_cast<u_int *>(Buffer());
    EXPECT_EQ(AssetDirectoryCount(pack), 2);

    int    file_size = 0;
    char   name[] = "b.bin";
    u_int *data = AssetDirectoryRead(pack, name, &file_size);
    ASSERT_NE(data, nullptr);
    EXPECT_EQ(file_size, 300);
    const std::vector<unsigned char> expected = MakeBytes(300, 2);
    EXPECT_EQ(std::memcmp(data, expected.data(), expected.size()), 0);
}

TEST_F(DataRead, BackgroundReadCompletesOnTheSecondSync) {
    DataReadIndex(root);
    StartReadBG();

    char name[] = "DIR/Sub/File.BIN";
    int  size = 0;
    ASSERT_EQ(LoadFileBG(name, BufferBytes(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));

    auto info = dc2::io::FindBackgroundRead(0);
    ASSERT_TRUE(info);
    ASSERT_EQ(info.Size(), static_cast<int>(kFileSize));
    EXPECT_TRUE(dc2::io::FindBackgroundRead(name));
    EXPECT_EQ(info.Issued(), 0);
    EXPECT_EQ(info.Done(), 0);

    EXPECT_EQ(ReadBGSync(), 1);
    EXPECT_EQ(info.Issued(), 1);
    EXPECT_EQ(info.Done(), 0);

    EXPECT_EQ(ReadBGSync(), 0);
    EXPECT_EQ(info.Done(), 1);
    const std::vector<unsigned char> expected = MakeBytes(kFileSize, 7);
    EXPECT_EQ(std::memcmp(info.Bytes().data(), expected.data(), kFileSize), 0);

    BreakReadBG();
    EXPECT_TRUE(dc2::io::FindBackgroundRead(0));
    StartReadBG();
    EXPECT_FALSE(dc2::io::FindBackgroundRead(0));
}

TEST_F(DataRead, BackgroundReadFailureDoesNotConsumeTheNextQueueSlot) {
    DataReadIndex(root);
    StartReadBG();

    std::string long_name(256, 'a');
    auto       *destination = Buffer();
    const auto  before = destination[0];
    int         size = -1;
    EXPECT_EQ(LoadFileBG(long_name.data(), BufferBytes(), &size), 0);
    EXPECT_EQ(size, 0);
    EXPECT_EQ(destination[0], before);
    EXPECT_FALSE(dc2::io::FindBackgroundRead(0));

    char valid_name[] = "DIR/Sub/File.BIN";
    EXPECT_EQ(LoadFileBG(valid_name, BufferBytes(), &size), 1);
    EXPECT_TRUE(dc2::io::FindBackgroundRead(valid_name));
}

TEST_F(DataRead, CostumeLoaderWaitSeesPendingRead) {
    DataReadIndex(root);
    StartReadBG();

    char name[] = "DIR/Sub/File.BIN";
    int  size = 0;
    ASSERT_EQ(LoadFileBG(name, BufferBytes(), &size), 1);

    int spins = 0;
    do {
        ++spins;
    } while (ReadBGSync() == 0 && spins < 100);
    EXPECT_EQ(spins, 1);

    StartReadBG();
    ASSERT_EQ(LoadFileBG(name, BufferBytes(), &size), 1);

    int calls = 0;
    int pending = 0;
    do {
        pending = ReadBGSync();
        ++calls;
    } while (pending != 0 && calls < 4);
    EXPECT_EQ(pending, 0);
    EXPECT_LE(calls, 4);
}

TEST_F(DataRead, FileCacheHoldsAFileLoadedInTheBackground) {
    DataReadIndex(root);
    std::vector<u_long128> cache(16384);

    CacheReset reset;

    InitFileCache(reset.Bind(cache), FILE_CACHE_UP);

    char name[] = "DIR/Sub/File.BIN";
    ASSERT_EQ(LoadFileCacheBG(name), 1);

    int        cached_size = 0;
    u_long128 *address = SearchFileCache(name, &cached_size);
    ASSERT_NE(address, nullptr);
    EXPECT_EQ(cached_size, static_cast<int>(kFileSize));

    int size = 0;
    ASSERT_EQ(Load("cdrom0:\\dir\\sub\\file.bin;1", BufferBytes(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
    const std::vector<unsigned char> expected = MakeBytes(kFileSize, 7);
    EXPECT_EQ(std::memcmp(Buffer(), expected.data(), kFileSize), 0);

    DeleteFileCache();
    EXPECT_EQ(SearchFileCache(name, &cached_size), nullptr);
    EXPECT_FALSE(dc2::io::FindBackgroundRead(name));
}

TEST_F(DataRead, FileCacheRecordsTheShrunkenSpanishEventTextLength) {
    constexpr std::string_view path = "event/e300/e314/e314_5.txt";
    std::string                original;
    std::string                expected;
    for (const auto &edit : script_text::Edits(path)) {
        original += std::string(edit.retail) + "\r\n";
        expected += std::string(edit.text) + "\r\n";
    }
    ASSERT_LT(expected.size(), original.size());
    WriteBytes(root / path, {original.begin(), original.end()});
    DataReadIndex(root);
    std::vector<u_long128> cache(16384);

    CacheReset reset;

    InitFileCache(reset.Bind(cache), FILE_CACHE_UP);
    StartReadBG();
    std::string name(path);
    ASSERT_EQ(LoadFileCacheBG(name.data()), 1);
    int cached_size = 0;
    ASSERT_NE(SearchFileCache(name.data(), &cached_size), nullptr);
    EXPECT_EQ(cached_size, static_cast<int>(expected.size()));
    int size = 0;
    ASSERT_EQ(Load(name.data(), BufferBytes(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(expected.size()));
    EXPECT_EQ(DataReadBufferSize(Buffer()), expected.size());
    EXPECT_EQ(std::memcmp(Buffer(), expected.data(), expected.size()), 0);
}

TEST_F(DataRead, WriteToHost0LandsUnderTheSaveRoot) {
    const fs::path save = base / "save";
    PathsSetSaveRoot(save);
    std::vector<unsigned char> data = MakeBytes(5000, 9);
    char                       name[] = "host0:out/x.bin";

    ASSERT_EQ(WriteFile(name, data.data(), static_cast<int>(data.size())), 1);

    const fs::path written = save / "host0" / "out" / "x.bin";
    ASSERT_TRUE(fs::exists(written));
    EXPECT_EQ(fs::file_size(written), data.size());
    std::ifstream              in(written, std::ios::binary);
    std::vector<unsigned char> back((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
    EXPECT_EQ(back, data);
}

TEST_F(DataRead, Host0ReadsBackWhatWasWrittenAndShadowsTheDataIndex) {
    PathsSetSaveRoot(base / "save");
    WriteBytes(root / "geo_data" / "t.edt", MakeBytes(16, 99));
    DataReadIndex(root);

    std::vector<unsigned char> data = MakeBytes(5000, 11);
    char                       name[] = "host0:geo_data/t.edt";
    ASSERT_EQ(WriteFile(name, data.data(), static_cast<int>(data.size())), 1);

    std::vector<u_long128> out(8192 / sizeof(u_long128));
    int                    size = 0;
    ASSERT_EQ(LoadFile2(name, std::span(reinterpret_cast<u8 *>(out.data()), std::span(out).size_bytes()), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, static_cast<int>(data.size()));
    EXPECT_EQ(std::memcmp(out.data(), data.data(), data.size()), 0);

    int size_only = 0;
    EXPECT_EQ(LoadFile2(name, std::span<u8>{}, &size_only, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size_only, static_cast<int>(data.size()));

    StartReadBG();
    char bg_name[] = "host0:geo_data/t.edt";
    ASSERT_EQ(LoadFileBG(bg_name, std::span(reinterpret_cast<u8 *>(out.data()), std::span(out).size_bytes()), &size), 1);
    EXPECT_EQ(size, static_cast<int>(data.size()));
    EXPECT_EQ(std::memcmp(out.data(), data.data(), data.size()), 0);
}

TEST_F(DataRead, HostNameAbsentFromTheSaveTreeLoadsFromData) {
    PathsSetSaveRoot(base / "save");
    WriteBytes(root / "gyorace.cfg", MakeBytes(258, 4));
    DataReadIndex(root);

    char name[] = "host:gyorace.cfg";
    int  size = 0;
    ASSERT_EQ(LoadFile2(name, BufferBytes(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, 258);
    const std::vector<unsigned char> expected = MakeBytes(258, 4);
    EXPECT_EQ(std::memcmp(Buffer(), expected.data(), expected.size()), 0);

    EXPECT_EQ(LoadFile2(name, std::span<u8>{}, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, 258);
}

TEST_F(DataRead, MissingAssetRootDoesNotLoadRepositoryGameplayOrAbort) {
    CaptureLoggedStderr();
    DataReadIndex(base / "absent");
    std::string log = GetLoggedStderr();
    EXPECT_NE(log.find("dataread: indexed "), std::string::npos) << log;
    EXPECT_FALSE(DataReadFind("/menu/cfg7/atdat.cfg.json").has_value());

    EXPECT_FALSE(DataReadFind("small.txt").has_value());
    int size = 0;
    EXPECT_EQ(Load("cdrom0:\\SMALL.TXT;1", BufferBytes(), &size), 0);
}

TEST_F(DataRead, RealDataIndexesTheDiscFiles) {
    std::optional<fs::path> data = ExtractedDataRoot();
    if (!data) {
        GTEST_SKIP() << "no extracted data/ above the test executable";
    }

    CaptureLoggedStderr();
    DataReadIndex(*data);
    std::string log = GetLoggedStderr();
    const auto  archive = data->parent_path() / "data.zip";
    const auto  location = fs::is_regular_file(archive) ? archive : *data;
    EXPECT_NE(log.find(" files under " + PathsDisplay(location)), std::string::npos) << log;
    EXPECT_TRUE(DataReadFind("menu/cfg7/atdat.cfg.json").has_value());
}

TEST_F(DataRead, ExtractedItemConfigLoadsWhenPresent) {
    std::optional<fs::path> data = ExtractedDataRoot();
    if (!data) {
        GTEST_SKIP() << "no published native configuration above the test executable";
    }

    DataReadIndex(*data);
    const std::string relative = "menu/cfg7/atdat.cfg.json";
    ASSERT_TRUE(config_catalog::Contains(relative));
    const auto count = native_config::Read<std::size_t>(relative, "attachments", [](const native_config::Json &document) { return native_config::Array(document, "attachments").size(); });
    ASSERT_TRUE(count.has_value());
    EXPECT_GT(*count, 0u);

    int         size = 0;
    std::string game = relative;
    ASSERT_EQ(LoadFile2(game.data(), std::span<u8>{}, &size, LOAD_FILE_SIZE), 1);
    EXPECT_GT(size, 0);
    std::vector<u_long128> storage((size + 2047) / 2048 * 2048 / sizeof(u_long128));
    ASSERT_EQ(Load(relative.c_str(), std::span(reinterpret_cast<u8 *>(storage.data()), std::span(storage).size_bytes()), &size), 1);
    EXPECT_EQ(DataReadBufferSize(storage.data()), static_cast<std::size_t>(size));
    EXPECT_EQ(DataReadBufferPath(storage.data()), relative);
}

TEST_F(DataRead, ShiftJisNameFindsItsPercentEncodedFile) {
    const std::string game = std::string("DIR\\") + '\x83' + 'A' + "%A.BIN";
    const fs::path    disk = root / "dir/%83a%25a.bin";
    WriteBytes(disk, MakeBytes(20, 5));

    DataReadIndex(root);
    std::optional<vfs::Ref> found = DataReadFind(game.c_str());
    ASSERT_TRUE(found.has_value());
    EXPECT_TRUE(fs::equivalent(*vfs::HostPath(*found), disk));
}

TEST_F(DataRead, ItemMessageReloadClearsTheLiveArenaWithoutClearingReboundRoots) {
    WriteMenuConfigs(base, {
                               {"common.cfg",     ItemConfigCommands()                                },
                               {"comdatmes0.cfg", ItemMessageCommands("A long previous language name")},
                               {"comdatmes1.cfg", ItemMessageCommands("B")                            }
    });
    DataReadIndex(root);
    GameItemDataManage.Initialize();
    char common[] = "common.cfg.json";
    ASSERT_TRUE(LoadGameDataAnalyze(common));
    LanguageCode = 0;
    ASSERT_TRUE(GameItemDataManage.LoadItemSystemMes(0));
    auto *record = GameItemDataManage.GetCommonData(11);
    ASSERT_NE(record, nullptr);
    ASSERT_STREQ(record->name, "A long previous language name");
    char *live = record->name;
    ASSERT_TRUE(GameItemDataManage.LoadItemSystemMes(1));
    ASSERT_EQ(record->name, live);
    ASSERT_STREQ(live, "B");
    // The old suffix must be cleared even though the original static bytes were already zero.
    for (int i = 2; i < 29; ++i) {
        EXPECT_EQ(live[i], 0) << i;
    }
}

TEST_F(DataRead, ItemDataJsonLargerThanRetailScratchLoadsItsRecords) {
    using Json = nlohmann::json;
    const Json document = {
        {"schema_version", 2},
        {"kind", "attachments"},
        {"count", 1},
        {"attachments", Json::array({{{"status", {17, 23}}, {"attribute", {1, 2, 3, 4, 5, 6, 7, 8}}, {"special", 0x1234}}})},
        // The reader ignores members it does not know, so this pads the document past the retail scratch buffer.
        {"padding", std::string(0x780 * sizeof(u_long128), 'x')}
    };
    const auto path = base / "data/menu/cfg7/large.json";
    fs::create_directories(path.parent_path());
    std::ofstream(path, std::ios::binary) << document.dump(2);
    ASSERT_GT(fs::file_size(path), 0x780u * sizeof(u_long128));
    DataReadIndex(root);
    GameItemDataManage.Initialize();
    char name[] = "large.json";
    ASSERT_EQ(LoadGameDataAnalyze(name), 1);
    ASSERT_EQ(GameItemDataManage.attach_num, 1);
    const auto &attachment = GameItemDataManage.attach_data[0];
    EXPECT_EQ(attachment.status[0], 17);
    EXPECT_EQ(attachment.status[1], 23);
    for (int index = 0; index < 8; ++index) {
        EXPECT_EQ(attachment.attribute[index], index + 1);
    }
    EXPECT_EQ(attachment.special, 0x1234u);
}

TEST_F(DataRead, RetailAttachmentJsonPreservesEveryRecordValue) {
    const auto retail = ExtractedDataRoot();
    if (!retail) {
        GTEST_SKIP() << "requires converted retail data";
    }
    DataReadIndex(*retail);
    const auto file = DataReadFind("menu/cfg7/atdat.cfg.json");
    ASSERT_TRUE(file.has_value());
    std::vector<std::uint8_t> bytes;
    ASSERT_TRUE(vfs::Read(*file, bytes));
    const auto document = nlohmann::json::parse(bytes);
    if (document.value("kind", "") != "attachments") {
        GTEST_SKIP() << "requires native attachment data";
    }
    GameItemDataManage.Initialize();
    char name[] = "atdat.cfg.json";
    ASSERT_EQ(LoadGameDataAnalyze(name), 1);
    EXPECT_EQ(GameItemDataManage.attach_num, document.at("count").get<int>());
    const auto &attachments = document.at("attachments");
    ASSERT_LE(attachments.size(), static_cast<std::size_t>(GameItemDataManage.attach_num));
    for (std::size_t index = 0; index < attachments.size(); ++index) {
        const auto &expected = attachments[index];
        const auto &attachment = GameItemDataManage.attach_data[index];
        for (std::size_t value = 0; value < 2; ++value) {
            EXPECT_EQ(attachment.status[value], expected.at("status")[value].get<int>()) << index;
        }
        for (std::size_t value = 0; value < 8; ++value) {
            EXPECT_EQ(attachment.attribute[value], expected.at("attribute")[value].get<int>()) << index;
        }
        EXPECT_EQ(attachment.special, expected.at("special").get<unsigned>()) << index;
    }
}

TEST_F(DataRead, ItemMessagesWithoutTextLeaveNoNameAndSkipUnknownItems) {
    using Json = nlohmann::json;
    WriteMenuConfigs(base, {
                               {"common.cfg",     ItemConfigCommands()                                                                                                                     },
                               {"comdatmes7.cfg",
                                Json{{"schema_version", 2}, {"kind", "item_messages"}, {"messages", Json::array({{{"item_no", 11}, {"name", nullptr}}, {{"item_no", 12}, {"name", "x"}}})}}}
    });
    DataReadIndex(root);
    GameItemDataManage.Initialize();
    char common[] = "common.cfg.json";
    ASSERT_TRUE(LoadGameDataAnalyze(common));

    struct RestoreLanguage {
        int language = LanguageCode;

        ~RestoreLanguage() { LanguageCode = language; }
    } restore;

    LanguageCode = 0;
    ASSERT_TRUE(GameItemDataManage.LoadItemSystemMes(7));
    auto *record = GameItemDataManage.GetCommonData(11);
    ASSERT_NE(record, nullptr);
    EXPECT_EQ(record->name, nullptr);
    EXPECT_EQ(GameItemDataManage.GetCommonData(12), nullptr);
}

TEST_F(DataRead, FileCacheBothDirectionsRejectOverflowBeforeTouchingTheTailGuard) {
    DataReadIndex(root);
    for (int direction : {FILE_CACHE_UP, FILE_CACHE_DOWN}) {
        static char                storage_keys[2];
        auto                      *mapped = reinterpret_cast<u_long128 *>(ArenaBlock(&storage_keys[direction == FILE_CACHE_UP ? 0 : 1],
                                                                                     261 * sizeof(u_long128)));
        const std::span<u_long128> storage(mapped, 261);
        std::memset(storage.data(), 0xA5, storage.size_bytes());
        CacheReset reset;
        InitFileCache(reset.Bind(storage), direction);
        char large[] = "DIR/Sub/File.BIN";
        char small[] = "small.txt";
        ASSERT_EQ(LoadFileCacheBG(large), 1);
        EXPECT_EQ(LoadFileCacheBG(small), 0);
        int size = 0;
        EXPECT_NE(SearchFileCache(large, &size), nullptr);
        EXPECT_EQ(size, static_cast<int>(kFileSize));
        const auto bytes = std::span(reinterpret_cast<const u8 *>(storage.data()), storage.size_bytes());
        EXPECT_TRUE(std::ranges::all_of(bytes.subspan(kPadded), [](u8 value) { return value == 0xA5; }));
    }
}

TEST_F(DataRead, FileCacheRetiresPointersWhenItsExactArenaAllocationIsReleased) {
    DataReadIndex(root);
    static char                storage_key;
    auto                      *mapped = reinterpret_cast<u_long128 *>(ArenaBlock(&storage_key, 512 * sizeof(u_long128)));
    const std::span<u_long128> storage(mapped, 512);
    CacheReset                 reset;
    InitFileCache(reset.Bind(storage), FILE_CACHE_UP);
    char name[] = "DIR/Sub/File.BIN";
    ASSERT_EQ(LoadFileCacheBG(name), 1);
    ASSERT_TRUE(dc2::io::FindBackgroundRead(name));
    const std::vector<u_long128> before(storage.begin(), storage.end());
    reset.owner.stClearUsed();
    int size = -1;
    EXPECT_EQ(SearchFileCache(name, &size), nullptr);
    EXPECT_EQ(size, 0);
    EXPECT_FALSE(dc2::io::FindBackgroundRead(name));
    EXPECT_EQ(LoadFileCacheBG(name), 0);
    EXPECT_TRUE(std::ranges::equal(storage, before));
}

TEST_F(DataRead, OwnedBackgroundReadSurvivesDestinationResetAndQueueSlotReuse) {
    DataReadIndex(root);
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 512 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(storage, 512);
    auto *destination = memory.Alloc(256);
    ASSERT_NE(destination, nullptr);
    char name[] = "DIR/Sub/File.BIN";
    int  size = 0;
    StartReadBG();
    ASSERT_EQ(LoadFileBG(name, {reinterpret_cast<u8 *>(destination), kPadded}, &size), 1);
    const auto expected_source = DataReadBufferPath(destination);
    ASSERT_TRUE(expected_source);
    auto retained = dc2::io::FindBackgroundRead(0);
    ASSERT_TRUE(retained);
    ASSERT_EQ(retained.Size(), kFileSize);
    EXPECT_FALSE(retained.Issued());
    EXPECT_EQ(ReadBGSync(), 1);
    EXPECT_TRUE(retained.Issued());
    EXPECT_FALSE(retained.Done());
    EXPECT_EQ(ReadBGSync(), 0);
    EXPECT_TRUE(retained.Done());
    memory.stClearUsed();
    destination = memory.Alloc(256);
    std::memset(destination, 0xCC, kPadded);
    StartReadBG();
    char next_name[] = "small.txt";
    ASSERT_EQ(LoadFileBG(next_name, {reinterpret_cast<u8 *>(destination), kPadded}, &size), 1);
    const auto next = dc2::io::FindBackgroundRead(0);
    ASSERT_TRUE(next);
    EXPECT_NE(next.Bytes().data(), retained.Bytes().data());
    EXPECT_EQ(next.Size(), 10);
    const auto expected = MakeBytes(kFileSize, 7);
    EXPECT_TRUE(std::ranges::equal(retained.Bytes(), expected));
    EXPECT_EQ(DataReadBufferSize(retained.Bytes().data()), kFileSize);
    EXPECT_EQ(DataReadBufferPath(retained.Bytes().data()), expected_source);
    EXPECT_TRUE(retained.Done());
}

TEST_F(DataRead, AConsumerAllocationRetainsBackgroundInputAfterQueueClearUntilItsExactLeaseEnds) {
    DataReadIndex(root);
    StartReadBG();
    char name[] = "DIR/Sub/File.BIN";
    int  size = 0;
    ASSERT_EQ(LoadFileBG(name, BufferBytes(), &size), 1);
    const auto expected_source = DataReadBufferPath(Buffer());
    ASSERT_TRUE(expected_source);
    auto read = dc2::io::FindBackgroundRead(0);
    ASSERT_TRUE(read);
    const auto *owned_bytes = read.Bytes().data();
    static char consumer_key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&consumer_key, 64 * sizeof(u_long128)));
    mgCMemory   consumer;
    consumer.stSetBuffer(storage, 64);
    auto *object = consumer.Alloc(4);
    ASSERT_NE(object, nullptr);
    const auto anchor = dc2::memory::ArenaBuffer::Bind(consumer, {reinterpret_cast<u8 *>(object), 4 * sizeof(u_long128)});
    ASSERT_TRUE(read.Retain(anchor));
    StartReadBG();
    EXPECT_TRUE(read.Cancelled());
    read = {};
    EXPECT_EQ(DataReadBufferSize(owned_bytes), kFileSize);
    EXPECT_EQ(DataReadBufferPath(owned_bytes), expected_source);
    consumer.stClearUsed();
    EXPECT_EQ(DataReadBufferSize(owned_bytes), 0);
    EXPECT_FALSE(DataReadBufferPath(owned_bytes));
    EXPECT_FALSE(dc2::io::FindBackgroundRead(0));
}

TEST_F(DataRead, OwnedSourceRegistrationCannotEraseANewerIdentityAtTheSameAddress) {
    std::array<u8, 16> bytes{};
    auto               older = dc2::assets::RegisterOwnedSource(bytes.data(), "older.bin");
    auto               newer = dc2::assets::RegisterOwnedSource(bytes.data(), "newer.bin");
    older.reset();
    EXPECT_EQ(TextureSourceLookup(bytes.data()), "newer.bin");
    newer.reset();
    EXPECT_FALSE(TextureSourceLookup(bytes.data()));
}

TEST_F(DataRead, HeapOwnedInventionControllerRetainsItsReadAcrossQueueClearUntilControllerCleanup) {
    struct Cleanup {
        ~Cleanup() { dc2::menu::ResetInventionMenu(); }
    } cleanup;

    DataReadIndex(root);
    StartReadBG();
    char name[] = "DIR/Sub/File.BIN";
    ASSERT_EQ(LoadFileBG(name, BufferBytes(), nullptr), 1);
    auto &controller = dc2::menu::CreateInventionMenu();
    controller.chara_read_info = dc2::io::FindBackgroundRead(0);
    ASSERT_TRUE(controller.chara_read_info);
    const auto *owned_bytes = controller.chara_read_info.Bytes().data();
    const auto  expected = MakeBytes(kFileSize, 7);
    StartReadBG();
    std::memset(Buffer(), 0xCC, kPadded);
    EXPECT_TRUE(std::ranges::equal(controller.chara_read_info.Bytes(), expected));
    EXPECT_EQ(DataReadBufferSize(owned_bytes), kFileSize);
    dc2::menu::ResetInventionMenu();
    EXPECT_EQ(DataReadBufferSize(owned_bytes), 0);
    EXPECT_FALSE(DataReadBufferPath(owned_bytes));
}

TEST_F(DataRead, RetainedReadFollowsOnlyItsExactHeapAllocationAndRejectsItsReusedAddress) {
    DataReadIndex(root);
    auto read = dc2::io::ReadFile("DIR/Sub/File.BIN");
    ASSERT_TRUE(read);
    const auto *owned_bytes = read.Bytes().data();
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 256 * sizeof(u_long128)));
    mgCMemory   heap;
    heap.SetHeapMem(storage, 256);
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIRST, 0), nullptr);
    auto *first = heap.Alloc(4);
    ASSERT_NE(first, nullptr);
    const auto first_anchor = dc2::memory::ArenaBuffer::Bind(heap, {reinterpret_cast<u8 *>(first), 4 * sizeof(u_long128)});
    ASSERT_TRUE(read.Retain(first_anchor));
    heap.EndStackMode();
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIRST, 0), nullptr);
    auto *unrelated = heap.Alloc(4);
    ASSERT_NE(unrelated, nullptr);
    heap.EndStackMode();
    read = {};
    heap.Free(unrelated);
    EXPECT_EQ(DataReadBufferSize(owned_bytes), kFileSize);
    heap.Free(first);
    EXPECT_EQ(DataReadBufferSize(owned_bytes), 0);
    EXPECT_FALSE(DataReadBufferPath(owned_bytes));
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIRST, 0), nullptr);
    auto *reused = heap.Alloc(4);
    ASSERT_EQ(reused, first);
    auto replacement = dc2::io::ReadFile("small.txt");
    ASSERT_TRUE(replacement);
    EXPECT_FALSE(replacement.Retain(first_anchor));
    const auto current_anchor = dc2::memory::ArenaBuffer::Bind(heap, {reinterpret_cast<u8 *>(reused), 4 * sizeof(u_long128)});
    EXPECT_TRUE(replacement.Retain(current_anchor));
    heap.EndStackMode();
    heap.Free(reused);
}

TEST_F(DataRead, ResourceContentsPreserveFullModelsWhileGameReadsKeepTheirNameOnlyContract) {
    struct CurrentDirectoryRestore {
        std::string previous = GetCurrentDir();
        fs::path    previous_index = datapacks::Root().empty() ? PathsDataRoot() : datapacks::Root();

        ~CurrentDirectoryRestore() {
            DataReadIndex(previous_index);
            SetCurrentDir(previous.data());
        }
    } restore;

    const auto contents = MakeBytes(4097, 9);
    WriteBytes(root / "icon.gltf", contents);
    DataReadIndex(root);
    SetCurrentDir(nullptr);
    const auto game = dc2::io::ReadFile("icon.gltf");
    ASSERT_TRUE(game);
    EXPECT_EQ(game.Size(), DATAREAD_SECTOR_SIZE);
    EXPECT_TRUE(std::ranges::all_of(game.Bytes(), [](u8 byte) { return byte == 0; }));
    const auto resource = dc2::io::ReadResourceFile("icon.gltf");
    ASSERT_TRUE(resource);
    EXPECT_EQ(resource.Size(), static_cast<int>(contents.size()));
    EXPECT_TRUE(std::ranges::equal(resource.Bytes(), contents));
    EXPECT_EQ(resource.Source(), "icon.gltf");
    EXPECT_TRUE(std::ranges::all_of(resource.PaddedBytes().subspan(contents.size()), [](u8 byte) { return byte == 0; }));
    DataReadIndex(base / "absent");
    EXPECT_TRUE(std::ranges::equal(resource.Bytes(), contents));
    EXPECT_EQ(resource.Source(), "icon.gltf");
}
