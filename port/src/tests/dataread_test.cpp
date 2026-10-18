#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include <algorithm>
#include <charconv>
#include <chrono>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <optional>
#include <string>
#include <utility>
#include <vector>

#include "asset_directory.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "platform/config_catalog.hpp"
#include "platform/paths.hpp"
#include "platform/vfs.hpp"
#include "scriptinterpreter.hpp"
#include "texture_source.hpp"

int LoadGameDataAnalyze(char *);

namespace fs = std::filesystem;

namespace {

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
void WriteMenuConfigs(const fs::path &base, const std::vector<std::pair<std::string, nlohmann::json> > &documents) {
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

int Load(const char *name, void *buffer, int *size) {
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
        PathsReset();
        std::error_code error;
        fs::remove_all(base, error);
    }

    u_long128 *Buffer() { return buffer.data(); }

    fs::path base;
    fs::path root;

private:
    std::vector<u_long128> buffer;
};

using DataReadDeathTest = DataRead;

} // namespace

TEST_F(DataRead, IndexLogsItsCountAndRoot) {
    testing::internal::CaptureStderr();
    DataReadIndex(base / "absent");
    const auto        config_log = testing::internal::GetCapturedStderr();
    const std::string prefix = "dataread: indexed ";
    const auto        count_start = config_log.find(prefix);
    ASSERT_NE(count_start, std::string::npos) << config_log;
    std::size_t config_count = 0;
    const auto  parsed = std::from_chars(config_log.data() + count_start + prefix.size(),
                                         config_log.data() + config_log.size(), config_count);
    ASSERT_EQ(parsed.ec, std::errc{});
    testing::internal::CaptureStderr();
    DataReadIndex(root);
    std::string log = testing::internal::GetCapturedStderr();
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

    testing::internal::CaptureStderr();
    DataReadIndex(root);
    std::string log = testing::internal::GetCapturedStderr();
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

    ASSERT_EQ(Load("cdrom0:\\DIR\\SUB\\FILE.BIN;1", Buffer(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));

    const auto                      *bytes = reinterpret_cast<const unsigned char *>(Buffer());
    const std::vector<unsigned char> expected = MakeBytes(kFileSize, 7);
    EXPECT_EQ(std::memcmp(bytes, expected.data(), kFileSize), 0);
    const std::vector<unsigned char> tail(kPadded - kFileSize, 0);
    EXPECT_EQ(std::memcmp(bytes + kFileSize, tail.data(), tail.size()), 0);
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
    ASSERT_EQ(LoadFile2(name, nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, 177);
    ASSERT_EQ(Load(name, Buffer(), &size), 1);
    EXPECT_EQ(size, 177);
    const auto replacement = MakeBytes(177, 19);
    EXPECT_EQ(std::memcmp(Buffer(), replacement.data(), replacement.size()), 0);
    const auto found = DataReadFind(name);
    ASSERT_TRUE(found.has_value());
    EXPECT_TRUE(fs::equivalent(*vfs::HostPath(*found), last / "DIR" / "Sub" / "File.BIN"));

    ASSERT_EQ(Load("small.txt", Buffer(), &size), 1);
    EXPECT_EQ(size, 27);
    const auto sparse = MakeBytes(27, 31);
    EXPECT_EQ(std::memcmp(Buffer(), sparse.data(), sparse.size()), 0);
    ASSERT_EQ(Load("chara/pack.pac", Buffer(), &size), 1);
    const auto fallback = DataReadFind("chara/pack.pac");
    ASSERT_TRUE(fallback.has_value());
    EXPECT_TRUE(fs::equivalent(*vfs::HostPath(*fallback), base / "data/chara/pack.pac/pack.json"));

    std::ofstream(base / "datapacks" / "datapacks.json")
        << R"({"schema_version":1,"load_order":["Last pack","First pack"]})";
    DataReadIndex(root);
    ASSERT_EQ(Load(name, Buffer(), &size), 1);
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
    ASSERT_EQ(Load("small.txt", Buffer(), &size), 1);
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
    ASSERT_EQ(LoadFile2(name, nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, json.size());
    std::memset(Buffer(), 0xAA, kPadded);
    ASSERT_EQ(Load(name, Buffer(), &size), 1);
    EXPECT_EQ(size, json.size());
    const auto *bytes = reinterpret_cast<const unsigned char *>(Buffer());
    EXPECT_EQ(std::memcmp(bytes, json.data(), json.size()), 0);
    EXPECT_TRUE(std::all_of(bytes + json.size(), bytes + 2048, [](unsigned char value) { return value == 0; }));
    EXPECT_EQ(DataReadBufferPath(Buffer()), "img/foo.json");

    ASSERT_EQ(Load("small.txt", Buffer(), &size), 1);
    EXPECT_EQ(TextureSourceLookup(Buffer()), "small.txt");
}

TEST_F(DataRead, DirectoryReadLoadsActualVersionMetadataAndMemberBytes) {
    DataReadIndex(root);
    int size = 0;
    ASSERT_EQ(Load("chara/pack.pac", Buffer(), &size), 1);
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
    EXPECT_EQ(LoadFile(plain, Buffer(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
    EXPECT_EQ(LoadFile(upper, Buffer(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
}

TEST_F(DataReadDeathTest, LoadFileExitsWhenTheFileIsMissing) {
    DataReadIndex(root);
    int  size = 0;
    char name[] = "dir/nope/missing.bin";
    EXPECT_EXIT(LoadFile(name, Buffer(), &size), testing::ExitedWithCode(0), "File open error \"dir/nope/missing.bin\"");
}

TEST_F(DataRead, MissingFileReturnsZeroWithoutAborting) {
    DataReadIndex(root);
    int size = 99;
    EXPECT_EQ(Load("cdrom0:\\NOPE\\MISSING.BIN;1", Buffer(), &size), 0);
    EXPECT_EQ(size, 0);
}

TEST_F(DataRead, SizeModeReportsWithoutReading) {
    DataReadIndex(root);
    char name[] = "DIR/Sub/File.BIN";
    int  size = 0;
    EXPECT_EQ(LoadFile2(name, nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
}

TEST_F(DataRead, CurrentDirectoryPrefixesRelativeNames) {
    DataReadIndex(root);
    char dir[] = "DIR/Sub/";
    ChangeDir(dir);

    char current[64] = {};
    GetCurrentDir(current);
    EXPECT_STREQ(current, "DIR/Sub/");

    int  size = 0;
    char relative[] = "file.bin";
    char anchored[] = "/small.txt";
    EXPECT_EQ(LoadFile2(relative, Buffer(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
    EXPECT_EQ(LoadFile2(anchored, Buffer(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, 10);

    ChangeDir(nullptr);
    char missing[] = "file.bin";
    EXPECT_EQ(LoadFile2(missing, Buffer(), &size, LOAD_FILE_READ), 0);

    SetCurrentDir(nullptr);
    GetCurrentDir(current);
    EXPECT_STREQ(current, "");
}

TEST_F(DataRead, FolderMemberIsFoundByItsActualRelativeName) {
    DataReadIndex(root);
    int size = 0;
    ASSERT_EQ(Load("chara/pack.pac", Buffer(), &size), 1);

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
    ASSERT_EQ(LoadFileBG(name, Buffer(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));

    BG_READ_INFO *info = GetReadBGFile(0);
    ASSERT_NE(info, nullptr);
    EXPECT_NE(GetReadBGFile(name), nullptr);
    EXPECT_EQ(info->issued, 0);
    EXPECT_EQ(info->done, 0);

    EXPECT_EQ(ReadBGSync(), 1);
    EXPECT_EQ(info->issued, 1);
    EXPECT_EQ(info->done, 0);

    EXPECT_EQ(ReadBGSync(), 0);
    EXPECT_EQ(info->done, 1);
    const std::vector<unsigned char> expected = MakeBytes(kFileSize, 7);
    EXPECT_EQ(std::memcmp(info->buffer, expected.data(), kFileSize), 0);

    BreakReadBG();
    EXPECT_NE(GetReadBGFile(0), nullptr);
    StartReadBG();
    EXPECT_EQ(GetReadBGFile(0), nullptr);
}

TEST_F(DataRead, CostumeLoaderWaitSeesPendingRead) {
    DataReadIndex(root);
    StartReadBG();

    char name[] = "DIR/Sub/File.BIN";
    int  size = 0;
    ASSERT_EQ(LoadFileBG(name, Buffer(), &size), 1);

    int spins = 0;
    do {
        ++spins;
    } while (ReadBGSync() == 0 && spins < 100);
    EXPECT_EQ(spins, 1);

    StartReadBG();
    ASSERT_EQ(LoadFileBG(name, Buffer(), &size), 1);

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

    struct CacheReset {
        ~CacheReset() { DeleteFileCache(); }
    } reset;

    InitFileCache(cache.data(), FILE_CACHE_UP);

    char name[] = "DIR/Sub/File.BIN";
    ASSERT_EQ(LoadFileCacheBG(name), 1);

    int        cached_size = 0;
    u_long128 *address = SearchFileCache(name, &cached_size);
    ASSERT_NE(address, nullptr);
    EXPECT_EQ(cached_size, static_cast<int>(kFileSize));

    int size = 0;
    ASSERT_EQ(Load("cdrom0:\\dir\\sub\\file.bin;1", Buffer(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
    const std::vector<unsigned char> expected = MakeBytes(kFileSize, 7);
    EXPECT_EQ(std::memcmp(Buffer(), expected.data(), kFileSize), 0);

    DeleteFileCache();
    EXPECT_EQ(SearchFileCache(name, &cached_size), nullptr);
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
    ASSERT_EQ(LoadFile2(name, out.data(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, static_cast<int>(data.size()));
    EXPECT_EQ(std::memcmp(out.data(), data.data(), data.size()), 0);

    int size_only = 0;
    EXPECT_EQ(LoadFile2(name, nullptr, &size_only, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size_only, static_cast<int>(data.size()));

    StartReadBG();
    char bg_name[] = "host0:geo_data/t.edt";
    ASSERT_EQ(LoadFileBG(bg_name, out.data(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(data.size()));
    EXPECT_EQ(std::memcmp(out.data(), data.data(), data.size()), 0);
}

TEST_F(DataRead, HostNameAbsentFromTheSaveTreeLoadsFromData) {
    PathsSetSaveRoot(base / "save");
    WriteBytes(root / "gyorace.cfg", MakeBytes(258, 4));
    DataReadIndex(root);

    char name[] = "host:gyorace.cfg";
    int  size = 0;
    ASSERT_EQ(LoadFile2(name, Buffer(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, 258);
    const std::vector<unsigned char> expected = MakeBytes(258, 4);
    EXPECT_EQ(std::memcmp(Buffer(), expected.data(), expected.size()), 0);

    EXPECT_EQ(LoadFile2(name, nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, 258);
}

TEST_F(DataRead, MissingAssetRootKeepsLooseConfigsAndDoesNotAbort) {
    testing::internal::CaptureStderr();
    DataReadIndex(base / "absent");
    std::string log = testing::internal::GetCapturedStderr();
    EXPECT_NE(log.find("dataread: indexed "), std::string::npos) << log;
    EXPECT_TRUE(DataReadFind("/menu/cfg7/atdat.cfg.json").has_value());

    EXPECT_FALSE(DataReadFind("small.txt").has_value());
    int size = 0;
    EXPECT_EQ(Load("cdrom0:\\SMALL.TXT;1", Buffer(), &size), 0);
}

TEST_F(DataRead, RealDataIndexesTheDiscFiles) {
    std::optional<fs::path> data = ExtractedDataRoot();
    if (!data) {
        GTEST_SKIP() << "no extracted data/ above the test executable";
    }

    testing::internal::CaptureStderr();
    DataReadIndex(*data);
    std::string log = testing::internal::GetCapturedStderr();
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
    ASSERT_EQ(LoadFile2(game.data(), nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_GT(size, 0);
    std::vector<u_long128> storage((size + 2047) / 2048 * 2048 / sizeof(u_long128));
    ASSERT_EQ(Load(relative.c_str(), storage.data(), &size), 1);
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
