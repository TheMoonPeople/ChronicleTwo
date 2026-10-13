#include <gtest/gtest.h>

#include <algorithm>
#include <chrono>
#include <cstddef>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <optional>
#include <string>
#include <utility>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "platform/paths.hpp"
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

std::vector<unsigned char> BuildPack(const std::vector<std::pair<std::string, std::vector<unsigned char>>> &files) {
    std::size_t total = (files.size() + 1) * sizeof(PACK_ENTRY);
    std::vector<std::size_t> starts;
    for (const auto &file : files) {
        starts.push_back(total);
        total += (file.second.size() + 3) & ~std::size_t(3);
    }

    std::vector<unsigned char> pack(total, 0);
    for (std::size_t i = 0; i < files.size(); i++) {
        PACK_ENTRY entry{};
        std::snprintf(entry.name, sizeof entry.name, "%s", files[i].first.c_str());
        entry.offset = static_cast<int>(starts[i] - i * sizeof(PACK_ENTRY));
        entry.size = static_cast<int>(files[i].second.size());
        entry.next = static_cast<int>(sizeof(PACK_ENTRY));
        std::memcpy(pack.data() + i * sizeof(PACK_ENTRY), &entry, sizeof entry);
        std::memcpy(pack.data() + starts[i], files[i].second.data(), files[i].second.size());
    }
    return pack;
}

int Load(const char *name, void *buffer, int *size) {
    std::string path(name);
    return LoadFile2(path.data(), buffer, size, LOAD_FILE_READ);
}

// The extracted data/ the test executable was built beside. Empty when that tree is absent, which is
// the case in the Linux container, where data/ is a dangling junction.
std::optional<fs::path> ExtractedDataRoot() {
    fs::path dir = PathsExecutable().parent_path();
    for (int up = 0; up < 6 && !dir.empty(); up++, dir = dir.parent_path()) {
        std::error_code error;
        if (fs::is_regular_file(dir / "data" / "edit.cfg", error)) {
            return dir / "data";
        }
    }
    return std::nullopt;
}

class DataRead : public testing::Test {
protected:
    void SetUp() override {
        base_ = fs::temp_directory_path() /
                ("dataread_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        root_ = base_ / "data";
        WriteBytes(root_ / "DIR" / "Sub" / "File.BIN", MakeBytes(kFileSize, 7));
        WriteBytes(root_ / "chara" / "Pack.PAC",
                   BuildPack({{"a.bin", MakeBytes(10, 1)}, {"b.bin", MakeBytes(300, 2)}}));
        WriteBytes(root_ / "small.txt", MakeBytes(10, 3));
        buffer_.assign(kPadded / sizeof(u_long128), 0);
    }

    void TearDown() override {
        PathsReset();
        std::error_code error;
        fs::remove_all(base_, error);
    }

    u_long128 *Buffer() { return buffer_.data(); }

    fs::path base_;
    fs::path root_;

private:
    std::vector<u_long128> buffer_;
};

using DataReadDeathTest = DataRead;

} // namespace

TEST_F(DataRead, IndexLogsItsCountAndRoot) {
    testing::internal::CaptureStderr();
    DataReadIndex(root_);
    std::string log = testing::internal::GetCapturedStderr();
    EXPECT_NE(log.find("dataread: indexed 3 files under " + PathsDisplay(root_)), std::string::npos) << log;
}

TEST_F(DataRead, RootExclusionsKeepDiscOnlyFilesOutOfTheIndex) {
    const fs::path root = base_ / "excluded";
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
    EXPECT_NE(log.find("dataread: indexed 3 files under " + PathsDisplay(root)), std::string::npos) << log;

    for (const char *name : {"manifest.txt", "manifest.json", ".kazarov-data", "movie/a.pss", "sound/sound.dat", "x.dc2tmp"}) {
        EXPECT_FALSE(DataReadFind(name).has_value()) << name;
    }
    EXPECT_TRUE(DataReadFind("map/movie/b.bin").has_value());
}

TEST_F(DataRead, FindIsCaseInsensitiveAndAcceptsDevicePrefixes) {
    DataReadIndex(root_);
    const fs::path expected = root_ / "DIR" / "Sub" / "File.BIN";
    for (const char *name : {"cdrom0:\\DIR\\SUB\\FILE.BIN;1", "host0:dir/sub/file.bin", "/DIR/Sub/File.BIN",
                             "dir\\sub\\file.bin;1", "cdrom:DIR/SUB/FILE.BIN"}) {
        std::optional<fs::path> found = DataReadFind(name);
        ASSERT_TRUE(found.has_value()) << name;
        EXPECT_TRUE(fs::equivalent(*found, expected)) << name;
    }
}

TEST_F(DataRead, LoadFileReadsExactBytesThenZeroFillsTheSector) {
    DataReadIndex(root_);
    std::memset(Buffer(), 0xAA, kPadded);
    int size = -1;

    ASSERT_EQ(Load("cdrom0:\\DIR\\SUB\\FILE.BIN;1", Buffer(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));

    const auto *bytes = reinterpret_cast<const unsigned char *>(Buffer());
    const std::vector<unsigned char> expected = MakeBytes(kFileSize, 7);
    EXPECT_EQ(std::memcmp(bytes, expected.data(), kFileSize), 0);
    const std::vector<unsigned char> tail(kPadded - kFileSize, 0);
    EXPECT_EQ(std::memcmp(bytes + kFileSize, tail.data(), tail.size()), 0);
}

TEST_F(DataRead, DatapacksOverrideIndexedFilesWithReplacementSizesAndSparseFallback) {
    const auto first = base_ / "datapacks" / "First pack";
    const auto last = base_ / "datapacks" / "Last pack";
    WriteBytes(first / "dir" / "sub" / "file.bin", MakeBytes(83, 11));
    WriteBytes(last / "DIR" / "Sub" / "File.BIN", MakeBytes(177, 19));
    WriteBytes(first / "small.txt", MakeBytes(27, 31));
    std::ofstream(base_ / "datapacks" / "datapacks.json")
        << R"({"schema_version":1,"load_order":["First pack","Last pack"]})";
    DataReadIndex(root_);

    int size = 0;
    char name[] = "cdrom0:\\DIR\\SUB\\FILE.BIN;1";
    ASSERT_EQ(LoadFile2(name, nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, 177);
    ASSERT_EQ(Load(name, Buffer(), &size), 1);
    EXPECT_EQ(size, 177);
    const auto replacement = MakeBytes(177, 19);
    EXPECT_EQ(std::memcmp(Buffer(), replacement.data(), replacement.size()), 0);
    const auto found = DataReadFind(name);
    ASSERT_TRUE(found.has_value());
    EXPECT_TRUE(fs::equivalent(*found, last / "DIR" / "Sub" / "File.BIN"));

    ASSERT_EQ(Load("small.txt", Buffer(), &size), 1);
    EXPECT_EQ(size, 27);
    const auto sparse = MakeBytes(27, 31);
    EXPECT_EQ(std::memcmp(Buffer(), sparse.data(), sparse.size()), 0);
    ASSERT_EQ(Load("chara/pack.pac", Buffer(), &size), 1);
    const auto fallback = DataReadFind("chara/pack.pac");
    ASSERT_TRUE(fallback.has_value());
    EXPECT_TRUE(fs::equivalent(*fallback, root_ / "chara" / "Pack.PAC"));

    std::ofstream(base_ / "datapacks" / "datapacks.json")
        << R"({"schema_version":1,"load_order":["Last pack","First pack"]})";
    DataReadIndex(root_);
    ASSERT_EQ(Load(name, Buffer(), &size), 1);
    EXPECT_EQ(size, 83);
    const auto reordered = MakeBytes(83, 11);
    EXPECT_EQ(std::memcmp(Buffer(), reordered.data(), reordered.size()), 0);
}

TEST_F(DataRead, DatapacksUseSelectedExtractionWithTrailingSeparator) {
    WriteBytes(base_ / "datapacks" / "Selected" / "small.txt", MakeBytes(41, 15));
    std::ofstream(base_ / "datapacks" / "datapacks.json")
        << R"({"schema_version":1,"load_order":["Selected"]})";
    DataReadIndex(root_ / "");
    int size = 0;
    ASSERT_EQ(Load("small.txt", Buffer(), &size), 1);
    EXPECT_EQ(size, 41);
}

TEST_F(DataRead, ConvertedTextureIsAnOpaqueCatalogHandle) {
    const fs::path catalog = base_ / "port_data" / "catalog.json";
    fs::create_directories(catalog.parent_path());
    std::ofstream(catalog)
        << R"({"schema_version":1,"sources":[{"source":"img/foo.img","kind":"img","size":1234,"entries":[]}]})";
    DataReadIndex(root_);
    EXPECT_FALSE(DataReadFind("img/foo.img").has_value());

    int size = -1;
    char name[] = "cdrom0:\\IMG\\FOO.IMG;1";
    ASSERT_EQ(LoadFile2(name, nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, 16);
    std::memset(Buffer(), 0xAA, kPadded);
    ASSERT_EQ(Load(name, Buffer(), &size), 1);
    EXPECT_EQ(size, 16);
    const auto *bytes = reinterpret_cast<const unsigned char *>(Buffer());
    EXPECT_EQ(std::memcmp(bytes, "KZTX:asset", 10), 0);
    EXPECT_TRUE(std::all_of(bytes + 16, bytes + 2048, [](unsigned char value) { return value == 0; }));
    EXPECT_EQ(TextureSourceLookup(Buffer()), "img/foo.img");

    ASSERT_EQ(Load("small.txt", Buffer(), &size), 1);
    EXPECT_EQ(TextureSourceLookup(Buffer()), "small.txt");
}

TEST_F(DataRead, PackLoadRegistersParentSourceForCatalogMembers) {
    DataReadIndex(root_);
    int size = 0;
    ASSERT_EQ(Load("chara/pack.pac", Buffer(), &size), 1);
    EXPECT_EQ(TextureSourceLookup(Buffer()), "chara/pack.pac");
    char member[] = "a.bin";
    u_int *data = GetPackFile(reinterpret_cast<u_int *>(Buffer()), member, nullptr);
    ASSERT_NE(data, nullptr);
    EXPECT_EQ(TextureSourceLookup(data), "chara/pack.pac/a.bin");
}

TEST_F(DataRead, LoadFileAcceptsPlainAndUpperCaseNames) {
    DataReadIndex(root_);
    int size = 0;
    char plain[] = "dir/sub/file.bin";
    char upper[] = "DIR\\SUB\\FILE.BIN;1";
    EXPECT_EQ(LoadFile(plain, Buffer(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
    EXPECT_EQ(LoadFile(upper, Buffer(), &size), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
}

TEST_F(DataReadDeathTest, LoadFileExitsWhenTheFileIsMissing) {
    DataReadIndex(root_);
    int  size = 0;
    char name[] = "dir/nope/missing.bin";
    EXPECT_EXIT(LoadFile(name, Buffer(), &size), testing::ExitedWithCode(0), "File open error \"dir/nope/missing.bin\"");
}

TEST_F(DataRead, MissingFileReturnsZeroWithoutAborting) {
    DataReadIndex(root_);
    int size = 99;
    EXPECT_EQ(Load("cdrom0:\\NOPE\\MISSING.BIN;1", Buffer(), &size), 0);
    EXPECT_EQ(size, 0);
}

TEST_F(DataRead, SizeModeReportsWithoutReading) {
    DataReadIndex(root_);
    char name[] = "DIR/Sub/File.BIN";
    int  size = 0;
    EXPECT_EQ(LoadFile2(name, nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, static_cast<int>(kFileSize));
}

TEST_F(DataRead, CurrentDirectoryPrefixesRelativeNames) {
    DataReadIndex(root_);
    char dir[] = "DIR/Sub/";
    ChangeDir(dir);

    char current[64] = {};
    GetCurrentDir(current);
    EXPECT_STREQ(current, "DIR/Sub/");

    int   size = 0;
    char  relative[] = "file.bin";
    char  anchored[] = "/small.txt";
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

TEST_F(DataRead, PackFileIsFoundByNameInsideTheLoadedPack) {
    DataReadIndex(root_);
    int size = 0;
    ASSERT_EQ(Load("chara/pack.pac", Buffer(), &size), 1);

    auto *pack = reinterpret_cast<u_int *>(Buffer());
    EXPECT_EQ(GetPackFileNum(pack), 2);

    int   file_size = 0;
    char  name[] = "chara/b.bin";
    u_int *data = GetPackFile(pack, name, &file_size);
    ASSERT_NE(data, nullptr);
    EXPECT_EQ(file_size, 300);
    const std::vector<unsigned char> expected = MakeBytes(300, 2);
    EXPECT_EQ(std::memcmp(data, expected.data(), expected.size()), 0);
}

TEST_F(DataRead, BackgroundReadCompletesOnTheSecondSync) {
    DataReadIndex(root_);
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
    DataReadIndex(root_);
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
    DataReadIndex(root_);
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
    const fs::path save = base_ / "save";
    PathsSetSaveRoot(save);
    std::vector<unsigned char> data = MakeBytes(5000, 9);
    char name[] = "host0:out/x.bin";

    ASSERT_EQ(WriteFile(name, data.data(), static_cast<int>(data.size())), 1);

    const fs::path written = save / "host0" / "out" / "x.bin";
    ASSERT_TRUE(fs::exists(written));
    EXPECT_EQ(fs::file_size(written), data.size());
    std::ifstream in(written, std::ios::binary);
    std::vector<unsigned char> back((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
    EXPECT_EQ(back, data);
}

TEST_F(DataRead, Host0ReadsBackWhatWasWrittenAndShadowsTheDataIndex) {
    PathsSetSaveRoot(base_ / "save");
    WriteBytes(root_ / "geo_data" / "t.edt", MakeBytes(16, 99));
    DataReadIndex(root_);

    std::vector<unsigned char> data = MakeBytes(5000, 11);
    char name[] = "host0:geo_data/t.edt";
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
    PathsSetSaveRoot(base_ / "save");
    WriteBytes(root_ / "gyorace.cfg", MakeBytes(258, 4));
    DataReadIndex(root_);

    char name[] = "host:gyorace.cfg";
    int  size = 0;
    ASSERT_EQ(LoadFile2(name, Buffer(), &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, 258);
    const std::vector<unsigned char> expected = MakeBytes(258, 4);
    EXPECT_EQ(std::memcmp(Buffer(), expected.data(), expected.size()), 0);

    EXPECT_EQ(LoadFile2(name, nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, 258);
}

TEST_F(DataRead, MissingRootIndexesNothingAndDoesNotAbort) {
    testing::internal::CaptureStderr();
    DataReadIndex(base_ / "absent");
    std::string log = testing::internal::GetCapturedStderr();
    EXPECT_NE(log.find("dataread: indexed 0 files under"), std::string::npos) << log;

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
    EXPECT_NE(log.find(" files under " + PathsDisplay(*data)), std::string::npos) << log;
    EXPECT_TRUE(DataReadFind("edit.cfg").has_value());
}

TEST_F(DataRead, ExtractedEditConfigLoadsWhenPresent) {
    std::optional<fs::path> data = ExtractedDataRoot();
    if (!data) {
        GTEST_SKIP() << "no extracted data/ above the test executable";
    }

    DataReadIndex(*data);
    std::optional<fs::path> edit = DataReadFind("cdrom0:\\EDIT.CFG;1");
    if (!edit) {
        GTEST_SKIP() << "data/ has no edit.cfg";
    }

    constexpr int kEditConfigSize = 1133;
    std::ifstream in(*edit, std::ios::binary);
    const std::vector<unsigned char> on_disk((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
    ASSERT_EQ(on_disk.size(), static_cast<std::size_t>(kEditConfigSize));

    int         size = 0;
    std::string relative = "edit.cfg";
    ASSERT_EQ(LoadFile2(relative.data(), nullptr, &size, LOAD_FILE_SIZE), 1);
    EXPECT_EQ(size, kEditConfigSize);

    std::vector<u_long128> buffer(2048 / sizeof(u_long128));
    ASSERT_EQ(Load("edit.cfg", buffer.data(), &size), 1);
    EXPECT_EQ(size, kEditConfigSize);
    EXPECT_EQ(std::memcmp(buffer.data(), on_disk.data(), on_disk.size()), 0);
}

TEST_F(DataRead, ShiftJisNameFindsItsPercentEncodedFile) {
    const std::string game = std::string("DIR\\") + '\x83' + 'A' + "%A.BIN";
    const fs::path    disk = root_ / "dir/%83a%25a.bin";
    WriteBytes(disk, MakeBytes(20, 5));

    DataReadIndex(root_);
    std::optional<fs::path> found = DataReadFind(game.c_str());
    ASSERT_TRUE(found.has_value());
    EXPECT_TRUE(fs::equivalent(*found, disk));
}

TEST_F(DataRead, ItemMessageReloadClearsTheLiveArenaWithoutClearingReboundRoots) {
    auto write = [&](const char *name, const char *text) {
        fs::create_directories(root_ / "menu/cfg7");
        std::ofstream(root_ / "menu/cfg7" / name) << text;
    };
    write("common.cfg", "COMINIT 1; COM 11,0,0,0,0,0,0,0,0,\"x\",0;");
    write("comdatmes0.cfg", "MES_SYS 11,\"A long previous language name\";");
    write("comdatmes1.cfg", "MES_SYS 11,\"B\";");
    DataReadIndex(root_);
    GameItemDataManage.Initialize();
    char common[] = "common.cfg";
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

extern SPI_TAG_PARAM PortGameDataTags[25] asm("GameData_Tags");

TEST_F(DataRead, ItemMessagesUseTheSameDispatchTableAsItemData) {
    fs::create_directories(root_ / "menu/cfg7");
    std::ofstream(root_ / "menu/cfg7/common.cfg") << "COMINIT 1; COM 11,0,0,0,0,0,0,0,0,\"x\",0;";
    std::ofstream(root_ / "menu/cfg7/comdatmes7.cfg") << "MES_SHARED 11,\"Shared retail dispatch\";";
    DataReadIndex(root_);
    GameItemDataManage.Initialize();
    char common[] = "common.cfg";
    ASSERT_TRUE(LoadGameDataAnalyze(common));

    struct RestoreTag {
        char *name = PortGameDataTags[22].name;
        int   language = LanguageCode;

        ~RestoreTag() {
            PortGameDataTags[22].name = name;
            LanguageCode = language;
        }
    } restore;

    ASSERT_STREQ(PortGameDataTags[22].name, "MES_SYS");
    PortGameDataTags[22].name = const_cast<char *>("MES_SHARED");
    LanguageCode = 0;
    ASSERT_TRUE(GameItemDataManage.LoadItemSystemMes(7));
    auto *record = GameItemDataManage.GetCommonData(11);
    ASSERT_NE(record, nullptr);
    EXPECT_STREQ(record->name, "Shared retail dispatch");
}
