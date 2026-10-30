#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <span>
#include <string>
#include <vector>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "convviewlp.hpp"
#include "inventmn.hpp"
#include "memcard.hpp"
#include "menuop.hpp"
#include "mg_memory.hpp"
#include "platform/datapacks.hpp"
#include "platform/files.hpp"
#include "platform/paths.hpp"
#include "platform_fixture.hpp"
#include "save_slots.hpp"
#include "storage/album.hpp"

namespace fs = std::filesystem;

TEST(SaveConversion, DirectoryCountsStayWithinDestinationTables) {
    EXPECT_EQ(dc2::video::BoundedSaveEntries(-1, SAVEDATA_CONVERT_FILE_MAX), 0);
    EXPECT_EQ(dc2::video::BoundedSaveEntries(0, SAVEDATA_CONVERT_FILE_MAX), 0);
    EXPECT_EQ(dc2::video::BoundedSaveEntries(64, SAVEDATA_CONVERT_FILE_MAX), 64);
    EXPECT_EQ(dc2::video::BoundedSaveEntries(std::numeric_limits<int>::max(), SAVEDATA_CONVERT_FILE_MAX), 64);
    EXPECT_EQ(dc2::video::BoundedSaveEntries(std::numeric_limits<int>::max(), SAVEDATA_CONVERT_DIR_MAX), 64);
}

TEST(SaveConversion, FileIndexParserRejectsMalformedAndOversizedFixedFields) {
    EXPECT_EQ(dc2::video::ParseConvertedSaveIndex("BESCES-51190dkcl0"), 0);
    EXPECT_EQ(dc2::video::ParseConvertedSaveIndex("BESCES-51190dkcl2147483647"), std::numeric_limits<int>::max());
    EXPECT_EQ(dc2::video::ParseConvertedSaveIndex("BESCES-51190dkcl-1"), -1);
    EXPECT_FALSE(dc2::video::ParseConvertedSaveIndex("BESCES-51190dkcl"));
    EXPECT_FALSE(dc2::video::ParseConvertedSaveIndex("BESCES-51190dkcl2147483648"));
    EXPECT_FALSE(dc2::video::ParseConvertedSaveIndex("BESCES-51190dkcl1suffix"));
    constexpr char unterminated[32] = {'B', 'E', 'S', 'C', 'E', 'S', '-', '5', '1', '1', '9', '0',
                                       'd', 'k', 'c', 'l', '9', '9', '9', '9', '9', '9', '9', '9',
                                       '9', '9', '9', '9', '9', '9', '9', '9'};
    EXPECT_FALSE(dc2::video::ParseConvertedSaveIndex(std::string_view(unterminated, sizeof unterminated)));
}

TEST(MemoryCard, SaveRecordAllocationCoversHostLayout) {
    const std::size_t      quads = sizeof(SAVEDATA_FORMAT) / sizeof(u_long128) + 3;
    std::vector<u_long128> storage(quads);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CMemoryCardManager manager;
    manager.Initialize(&memory);
    ASSERT_NE(manager.save_buffer, nullptr);
    EXPECT_GE(dc2::memory::AllocationBytes(memory, manager.save_buffer).size(), sizeof(SAVEDATA_FORMAT));
    const auto *next = memory.Alloc(1);
    ASSERT_NE(next, nullptr);
    EXPECT_GE(reinterpret_cast<std::uintptr_t>(next),
              reinterpret_cast<std::uintptr_t>(manager.save_buffer) + sizeof(SAVEDATA_FORMAT));
}

namespace {

constexpr int         kOpenRead = 0x0001;
constexpr int         kOpenCreateWrite = 0x0202;
constexpr int         kSeekSet = 0;
constexpr char        kCardDir[] = "/BESCES-51190dkcl0";
constexpr char        kCardFile[] = "/BESCES-51190dkcl0/BESCES-51190dkcl0";
constexpr char        kCardFilter[] = "/BESCES-51190dkcl0/*";
constexpr std::size_t kImageSize = sizeof(SAVEDATA_FORMAT);
constexpr int         kIncompleteOffset = 0x45;
constexpr std::size_t kWriteChunk = 0xC00;
constexpr int         kReadChunk = 0x1000;

std::vector<unsigned char> Image() {
    std::vector<unsigned char> image(kImageSize);
    for (std::size_t i = 0; i < image.size(); ++i) {
        image[i] = static_cast<unsigned char>(i * 131 + (i >> 8) * 7);
    }
    return image;
}

// The port finishes each command inside the call that issues it, so the game's
// sceMcSync(MC_NOWAIT) poll reports 1 with the command's function number and result.
int Done(int function) {
    int cmd = -1;
    int result = 0;
    EXPECT_EQ(sceMcSync(MC_NOWAIT, &cmd, &result), 1);
    EXPECT_EQ(cmd, function);
    return result;
}

int Open(const std::string &name, int flags) {
    EXPECT_EQ(sceMcOpen(0, 1, name.c_str(), flags), 0);
    return Done(sceMcFuncNoOpen);
}

void WriteAll(int fd, const std::vector<unsigned char> &image) {
    for (std::size_t offset = 0; offset < image.size(); offset += kWriteChunk) {
        const int  chunk = static_cast<int>(std::min(kWriteChunk, image.size() - offset));
        const auto bytes = std::span(image).subspan(offset, static_cast<std::size_t>(chunk));
        ASSERT_EQ(sceMcWrite(fd, std::as_bytes(bytes), chunk), 0);
        ASSERT_EQ(Done(sceMcFuncNoWrite), chunk);
    }
}

void ReadAll(int fd, std::vector<unsigned char> &out) {
    std::vector<unsigned char> buffer(kReadChunk);
    out.clear();
    for (;;) {
        ASSERT_EQ(sceMcRead(fd, std::as_writable_bytes(std::span(buffer)), kReadChunk), 0);
        const int got = Done(sceMcFuncNoRead);
        ASSERT_GE(got, 0);
        out.insert(out.end(), buffer.begin(), buffer.begin() + got);
        if (got < kReadChunk) {
            return;
        }
    }
}

void Close(int fd) {
    ASSERT_EQ(sceMcClose(fd), 0);
    ASSERT_EQ(Done(sceMcFuncNoClose), 0);
}

void MakeCardDirectory() {
    ASSERT_EQ(sceMcMkdir(0, 1, kCardDir), 0);
    ASSERT_EQ(Done(sceMcFuncNoMkdir), 0);
}

void RunUntilIdle(CMemoryCardManager &manager, int function) {
    manager.SetFuncNo(function);
    for (int i = 0; i < 64 && manager.GetFuncNo() != MC_FUNC_IDLE; ++i) {
        manager.Step();
    }
    ASSERT_EQ(manager.GetFuncNo(), MC_FUNC_IDLE);
}

/**
 * Restores the effective native asset index and current directory after temporary resource reads.
 */
struct DataRootRestore {
    fs::path    previous = datapacks::Root().empty() ? PathsDataRoot() : datapacks::Root();
    std::string previous_directory = GetCurrentDir();

    ~DataRootRestore() {
        if (previous.empty()) {
            DataReadIndex(PathsSaveRoot() / "absent");
            datapacks::Clear();
        } else {
            DataReadIndex(previous);
        }
        SetCurrentDir(previous_directory.data());
    }
};

class Memcard : public testing::Test {
protected:
    void SetUp() override {
        root_ = fs::temp_directory_path() / ("dc_memcard_test_" + std::to_string(dc::test::ProcessId()));
        fs::remove_all(root_);
        fs::create_directories(root_);
        PathsSetSaveRoot(root_);
        ASSERT_EQ(sceMcInit(), sceMcIniSucceed);
        ASSERT_EQ(sceMcFormat(0, 1), 0);
        ASSERT_EQ(Done(sceMcFuncNoFormat), 0);
    }

    void TearDown() override {
        PathsReset();
        std::error_code error;
        fs::remove_all(root_, error);
    }

private:
    fs::path root_;
};

} // namespace

TEST_F(Memcard, CardNamesAreTheGamesDirectoryAndFile) {
    EXPECT_EQ(MakeMemoryCardFileName(0), kCardFile);
    EXPECT_EQ(MakeMemoryCardFileName(1), "/BESCES-51190dkcl1/BESCES-51190dkcl1");
    EXPECT_EQ(MakeMemoryCardAlbumName(false), "/BESCES-51190dc2album");
    EXPECT_EQ(MakeMemoryCardAlbumName(true), "/BESCES-51190dc2album/BESCES-51190dc2album");
}

TEST_F(Memcard, SlotNamesKeepEveryDigitOfExtremeIndices) {
    EXPECT_EQ(MakeMemoryCardFileName(std::numeric_limits<int>::max()),
              "/BESCES-51190dkcl2147483647/BESCES-51190dkcl2147483647");
    EXPECT_EQ(MakeMemoryCardFileName(std::numeric_limits<int>::min()),
              "/BESCES-51190dkcl-2147483648/BESCES-51190dkcl-2147483648");
}

TEST_F(Memcard, BrowserTitleKeepsCompleteShiftJisDigitsWithinIconField) {
    const auto ordinary = MakeMemoryCardBrowserTitle(0);
    const auto extreme = MakeMemoryCardBrowserTitle(std::numeric_limits<int>::max() - 1);
    ASSERT_TRUE(ordinary);
    ASSERT_TRUE(extreme);
    EXPECT_EQ(ordinary->find("%s"), std::string::npos);
    EXPECT_NE(ordinary->find(std::string("\x82P", 2)), std::string::npos);
    EXPECT_NE(extreme->find(std::string("\x82Q\x82P\x82S\x82V\x82S\x82W\x82R\x82U\x82S\x82V", 20)),
              std::string::npos);
    EXPECT_LT(extreme->size(), sizeof(sceMcIconSys::title_name));
    EXPECT_FALSE(MakeMemoryCardBrowserTitle(std::numeric_limits<int>::max()));
    EXPECT_FALSE(MakeMemoryCardBrowserTitle(std::numeric_limits<int>::min()));
    EXPECT_TRUE(MakeMemoryCardBrowserTitle(-1));
}

TEST_F(Memcard, SaveImageReadsBackAndIsListedWithItsSize) {
    int type = 0;
    int free_size = 0;
    int formatted = 0;
    ASSERT_EQ(sceMcGetInfo(0, 1, &type, &free_size, &formatted), 0);
    ASSERT_EQ(Done(sceMcFuncNoCardInfo), sceMcResSucceed);
    EXPECT_EQ(type, sceMcTypePS2);
    EXPECT_EQ(formatted, 1);
    EXPECT_GT(free_size * 1024, static_cast<int>(kImageSize));

    MakeCardDirectory();
    int fd = Open(kCardFile, kOpenCreateWrite);
    ASSERT_GE(fd, 0);
    const std::vector<unsigned char> image = Image();
    WriteAll(fd, image);
    ASSERT_EQ(sceMcFlush(fd), 0);
    ASSERT_EQ(Done(sceMcFuncNoFlush), 0);
    Close(fd);

    sceMcTblGetDir table[MC_DIR_TABLE_NUM] = {};
    ASSERT_EQ(sceMcGetDir(0, 1, kCardFilter, 0, MC_DIR_TABLE_NUM, table), 0);
    const int entries = Done(sceMcFuncNoGetDir);
    ASSERT_EQ(entries, 3);
    const sceMcTblGetDir *save = nullptr;
    for (int i = 0; i < entries; ++i) {
        if (std::string(table[i].entry_name) == "BESCES-51190dkcl0") {
            save = &table[i];
        }
    }
    ASSERT_NE(save, nullptr);
    EXPECT_EQ(save->file_size_byte, kImageSize);
    EXPECT_NE(save->attr_file & 0x0010, 0);

    fd = Open(kCardFile, kOpenRead);
    ASSERT_GE(fd, 0);
    std::vector<unsigned char> back;
    ReadAll(fd, back);
    Close(fd);
    EXPECT_EQ(back, image);
}

// The save finish sets the incomplete byte back to zero through the descriptor that wrote the file,
// and a file that still has it set is hidden from the load menu.
TEST_F(Memcard, SaveFinishClearsIncompleteByteAtOffset0x45) {
    MakeCardDirectory();
    int fd = Open(kCardFile, kOpenCreateWrite);
    ASSERT_GE(fd, 0);
    std::vector<unsigned char> image = Image();
    image[kIncompleteOffset] = 1;
    WriteAll(fd, image);

    ASSERT_EQ(sceMcSeek(fd, kIncompleteOffset, kSeekSet), 0);
    Done(sceMcFuncNoSeek);
    unsigned char cleared = 0;
    ASSERT_EQ(sceMcWrite(fd, std::as_bytes(std::span(&cleared, 1)), 1), 0);
    ASSERT_EQ(Done(sceMcFuncNoWrite), 1);
    Close(fd);

    image[kIncompleteOffset] = 0;
    fd = Open(kCardFile, kOpenRead);
    ASSERT_GE(fd, 0);
    std::vector<unsigned char> back;
    ReadAll(fd, back);
    Close(fd);
    ASSERT_EQ(back.size(), kImageSize);
    EXPECT_EQ(back[kIncompleteOffset], 0);
    EXPECT_EQ(back, image);
}

TEST_F(Memcard, ManagerSearchReadsFormattedCard) {
    CMemoryCardManager manager;
    manager.port = 0;
    RunUntilIdle(manager, MC_FUNC_SEARCH_TYPE);

    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(manager.card[0].present, 1);
    EXPECT_EQ(manager.card[0].type, sceMcTypePS2);
    EXPECT_EQ(manager.card[0].formatted, 1);
    EXPECT_EQ(manager.card[0].format_change, 1);
    EXPECT_GT(manager.card[0].free_size * 1024, static_cast<int>(kImageSize));
}

TEST_F(Memcard, ManagerFormatAndUnformatReportCardState) {
    CMemoryCardManager manager;
    manager.port = 0;

    RunUntilIdle(manager, MC_FUNC_FORMAT);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(manager.card[0].present, 1);
    EXPECT_EQ(manager.card[0].type, sceMcTypePS2);
    EXPECT_EQ(manager.card[0].formatted, 1);

    RunUntilIdle(manager, MC_FUNC_UNFORMAT);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(manager.card[0].formatted, 0);

    RunUntilIdle(manager, MC_FUNC_SEARCH_TYPE);
    EXPECT_EQ(manager.card[0].present, 1);
    EXPECT_EQ(manager.card[0].formatted, 0);
    EXPECT_EQ(manager.card[0].result, sceMcResNoFormat);
}

TEST_F(Memcard, ControllerReplacementRetiresCopiedPublicationsAndTheActiveManager) {
    static CMemoryCardManager *primary = nullptr;
    static CMemoryCardManager *alias = nullptr;
    std::vector<u_long128>     storage(128);
    mgCMemory                  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *first = dc2::mc::CreateManager(memory, primary);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(dc2::mc::CreateManager(memory, alias), nullptr);
    dc2::mc::RetireManager(alias);
    alias = first;
    ASSERT_EQ(first->InitForMC(), 0);
    ASSERT_EQ(SaveSlotManager(), first);
    auto *replacement = dc2::mc::CreateManager(memory, primary);
    ASSERT_NE(replacement, nullptr);
    EXPECT_EQ(alias, nullptr);
    EXPECT_EQ(SaveSlotManager(), nullptr);
    EXPECT_EQ(primary, replacement);
    replacement->SetFuncNo(MC_FUNC_NONE);
    EXPECT_EQ(replacement->Step(), MC_STEP_DONE);
    dc2::mc::RetireManagers();
    EXPECT_EQ(primary, nullptr);
    EXPECT_EQ(alias, nullptr);
    EXPECT_EQ(SubGameSaveKey(), 1);
}

TEST_F(Memcard, ProducerResetRetiresControllersWithoutReenteringTheArenaRegistry) {
    static CMemoryCardManager *published = nullptr;
    std::vector<u_long128>     storage(64);
    mgCMemory                  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *manager = dc2::mc::CreateManager(memory, published);
    ASSERT_NE(manager, nullptr);
    ASSERT_EQ(manager->InitForMC(), 0);
    DataRootRestore restore;
    const auto      data_root = PathsSaveRoot() / "data";
    fs::create_directories(data_root);
    std::ofstream(data_root / "owned.gltf", std::ios::binary) << "owned";
    DataReadIndex(data_root);
    SetCurrentDir(nullptr);
    auto resource = dc2::io::ReadResourceFile("owned.gltf");
    ASSERT_TRUE(resource);
    std::array<MC_ICON_DATA, 3> icons{
        {{.name = "first.gltf", .resource = resource}, {.name = "second.gltf", .resource = resource}, {.name = "third.gltf", .resource = resource}}
    };
    manager->SetIconData(icons, 0);
    for (auto &icon : icons) {
        icon.resource = {};
    }
    resource = {};
    memory.stClearUsed();
    EXPECT_EQ(published, nullptr);
    EXPECT_EQ(SaveSlotManager(), nullptr);
    memory.stSetLocked(true);
    EXPECT_EQ(dc2::mc::CreateManager(memory, published), nullptr);
    EXPECT_EQ(published, nullptr);
}

TEST_F(Memcard, DiagnosticWriteUsesInitializedBytesAndReleasesItsDescriptor) {
    ASSERT_EQ(sceMcFormat(0, 1), 0);
    ASSERT_EQ(Done(sceMcFuncNoFormat), 0);
    int reused = -1;
    {
        CMemoryCardManager manager;
        ASSERT_EQ(manager.Write(), MC_STEP_DONE);
        EXPECT_FALSE(manager.descriptor.IsLive());
        EXPECT_EQ(fs::file_size(PathsSaveRoot() / "mc0/test"), 0x758000u);
        reused = Open("reused", kOpenCreateWrite);
        ASSERT_GE(reused, 0);
        ASSERT_EQ(reused, manager.fd);
    }
    constexpr std::array<std::byte, 1> marker{std::byte{0x53}};
    ASSERT_EQ(sceMcWrite(reused, marker, 1), 0);
    EXPECT_EQ(Done(sceMcFuncNoWrite), 1);
    EXPECT_EQ(sceMcClose(reused), 0);
    EXPECT_EQ(Done(sceMcFuncNoClose), 0);
    std::ifstream written(PathsSaveRoot() / "mc0/test", std::ios::binary);
    ASSERT_TRUE(written);
    EXPECT_EQ(written.get(), 0);
    written.seekg(-1, std::ios::end);
    EXPECT_EQ(written.get(), 0);
}

TEST_F(Memcard, AlbumOperationsRejectARetiredActualProducerBeforeDereferencingIt) {
    std::vector<u_long128> storage(sizeof(CDC2AlbumData) / sizeof(u_long128) + 4);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *album = dc2::memory::NewObject<CDC2AlbumData>(memory);
    ASSERT_NE(album, nullptr);
    CMemoryCardManager manager;
    manager.SetBuff_Album(album, &memory);
    ASSERT_EQ(manager.album_buffer_set, 1);
    memory.stClearUsed();
    EXPECT_EQ(manager.SaveAlbum(), MC_STEP_FAILED);
    EXPECT_EQ(manager.error.code, MC_ERROR_FILE);
    EXPECT_EQ(manager.LoadAlbum(), MC_STEP_FAILED);
}

TEST_F(Memcard, PortableAlbumAtomicallyReplacesALongerLegacyFileAndLoadsOwnedPixels) {
    std::vector<u_long128> storage(sizeof(CDC2AlbumData) / sizeof(u_long128) + 4);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *album = dc2::memory::NewObject<CDC2AlbumData>(memory);
    ASSERT_NE(album, nullptr);
    CMemoryCardManager manager;
    manager.port = 0;
    manager.SetBuff_Album(album, &memory);
    ASSERT_EQ(manager.album_buffer_set, 1);
    album->photo_work[0][0] = 42;
    album->photo_work[49][0x1fff] = 73;
    album->photo[49].neta_id = 1234;
    const auto expected = dc2::mc::EncodeAlbum(*album);
    const auto path = PathsSaveRoot() / "mc0" / fs::path(MakeMemoryCardAlbumName(true)).relative_path();
    fs::create_directories(path.parent_path());
    const std::vector<std::byte> legacy(INVENT_ALBUM_PHOTO_NUM * (0x2000 + 32) + 0x800, std::byte{0xcc});
    ASSERT_GT(legacy.size(), expected.size());
    ASSERT_EQ(FilesWrite(path, legacy.data(), legacy.size(), true), FilesResult::kWritten);
    ASSERT_EQ(manager.SaveAlbum(), MC_STEP_DONE);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(fs::file_size(path), expected.size());
    album->Initialize();
    ASSERT_EQ(manager.LoadAlbum(), MC_STEP_DONE);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_TRUE(expected == dc2::mc::EncodeAlbum(*album));
    EXPECT_EQ(album->photo[49].image, album->photo_work[49]);
    EXPECT_EQ(album->photo_work[0][0], 42);
    EXPECT_EQ(album->photo_work[49][0x1fff], 73);

    auto corrupt = expected;
    corrupt.back() ^= std::byte{1};
    ASSERT_EQ(FilesWrite(path, corrupt.data(), corrupt.size(), true), FilesResult::kWritten);
    EXPECT_EQ(manager.LoadAlbum(), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_BROKEN);
    EXPECT_TRUE(expected == dc2::mc::EncodeAlbum(*album));
}

TEST_F(Memcard, StaleManagerDestructionPreservesAnExternallyReopenedDescriptor) {
    int replacement = -1;
    {
        CMemoryCardManager manager;
        const int          original = Open("manager-owned", kOpenCreateWrite);
        ASSERT_GE(original, 0);
        auto ownership = dc2::mc::TakeCompletedOpen(sceMcFuncNoOpen, original);
        ASSERT_TRUE(ownership);
        manager.fd = original;
        manager.descriptor = *ownership;
        ASSERT_EQ(sceMcClose(original), 0);
        ASSERT_EQ(Done(sceMcFuncNoClose), 0);
        replacement = Open("externally-reopened", kOpenCreateWrite);
        ASSERT_EQ(replacement, original);
    }
    constexpr std::array<std::byte, 1> marker{std::byte{0x61}};
    ASSERT_EQ(sceMcWrite(replacement, marker, 1), 0);
    EXPECT_EQ(Done(sceMcFuncNoWrite), 1);
    ASSERT_EQ(sceMcClose(replacement), 0);
    EXPECT_EQ(Done(sceMcFuncNoClose), 0);
}

TEST_F(Memcard, DirectoryCreationWritesOnlyEachActualShortIconResource) {
    DataRootRestore restore;

    const auto data_root = PathsSaveRoot() / "data";
    const auto directory = data_root / "menu/icons";
    fs::create_directories(directory);
    std::ofstream(directory / "pack.json") << R"({"schema_version":1,"kind":"asset_directory"})";
    std::ofstream(directory / "short.gltf", std::ios::binary) << "icon";
    DataReadIndex(data_root);
    SetCurrentDir(nullptr);
    const auto pack = dc2::io::ReadFile("menu/icons/pack.json");
    ASSERT_TRUE(pack);
    const auto resource = dc2::assets::ReadDirectoryMember(pack, "short.gltf");
    ASSERT_TRUE(resource);
    ASSERT_EQ(resource.Size(), 4u);
    const std::array<MC_ICON_DATA, 3> icons{
        {{.name = "first.gltf", .resource = resource}, {.name = "second.gltf", .resource = resource}, {.name = "third.gltf", .resource = resource}}
    };
    ASSERT_EQ(sceMcFormat(0, 1), 0);
    ASSERT_EQ(Done(sceMcFuncNoFormat), 0);
    CMemoryCardManager manager;
    manager.SetIconData(icons, 0);
    RunUntilIdle(manager, MC_FUNC_MAKE_DIR);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    for (const auto &icon : icons) {
        const auto path = PathsSaveRoot() / "mc0/BESCES-51190dkcl0" / icon.name;
        ASSERT_TRUE(fs::is_regular_file(path));
        EXPECT_EQ(fs::file_size(path), 4u);
        std::ifstream input(path, std::ios::binary);
        EXPECT_EQ(std::string(std::istreambuf_iterator<char>(input), {}), "icon");
    }
}

TEST(MemoryCard, HeaderReadsRejectMissingStorageAndInvalidCallerIndicesBeforeTouchingTheSdk) {
    CMemoryCardManager manager;
    int                phase = 0;
    EXPECT_EQ(manager.GetSaveFileInfoFromMc(0, &phase), MC_STEP_FAILED);
    auto image = std::make_unique<SAVEDATA_FORMAT>();
    manager.save_buffer = image.get();
    EXPECT_EQ(manager.GetSaveFileInfoFromMc(-1, &phase), MC_STEP_FAILED);
    EXPECT_EQ(manager.GetSaveFileInfoFromMc(MC_SAVE_FILE_NUM, &phase), MC_STEP_FAILED);
    EXPECT_EQ(manager.GetSaveFileInfoFromMc(0, nullptr), MC_STEP_FAILED);
    phase = std::numeric_limits<int>::max();
    EXPECT_EQ(manager.GetSaveFileInfoFromMc(0, &phase), MC_STEP_FAILED);
    EXPECT_EQ(phase, std::numeric_limits<int>::max());
}
