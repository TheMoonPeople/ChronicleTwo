#include "common.h"

#include <gtest/gtest.h>

#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "mg_memory.hpp"
#include "platform/paths.hpp"
#include "sceneload_port.hpp"
#include "scenesnd.hpp"

namespace {
namespace fs = std::filesystem;

void SetMapFiles(SCN_LOADMAP_INFO2::MapFiles &files, const char *dir, const char *name) {
    files.enable = 1;
    std::strcpy(files.dir, dir);
    for (char *file : {files.map_name, files.cfg_name, files.mpk_name, files.ipk_name, files.efp_name, files.sky_name}) {
        std::strcpy(file, name);
    }
    std::strcpy(files.def_sky_name, "none");
}

SCN_LOADMAP_INFO2 Info(u8 *load_buf, const char *dir = "map/t/t01/", const char *name = "t01") {
    SCN_LOADMAP_INFO2 info{};
    info.stack_no = 1;
    info.load_buf = load_buf;
    info.load_sky = 1;
    SetMapFiles(info.files[0], dir, name);
    return info;
}

std::size_t Pad64(std::size_t size) {
    return (size + 63) / 64 * 64;
}

/**
 * Writes maps' files under a temporary data root: .map files larger than the caller's load buffer, a .cfg, and the
 * .mpk and .sky pack manifests. No .ipk is written, so LoadMap stops after LoadMapData without building the map.
 */
class SceneLoadMapBuffer : public testing::Test {
protected:
    static constexpr std::size_t kMapBytes = 70001;
    static constexpr std::size_t kAddMapBytes = 90001;
    static constexpr std::size_t kLargeMapBytes = 300001;
    static constexpr std::size_t kLargerMapBytes = 600001;
    static constexpr std::size_t kCfgBytes = 333;
    static constexpr std::size_t kPackBytes = 54;
    static constexpr std::size_t kDefaultSkyBytes = 300;
    static constexpr int         kCallerQuadwords = 64;

    fs::path root = fs::temp_directory_path() /
                    ("sceneload_map_buffer_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::vector<u_long128> storage = std::vector<u_long128>(0x1000);
    mgCMemory              stack;
    CScene                 scene;

    void SetUp() override {
        WriteMap("map/t/t01", "t01", kMapBytes, 'm');
        WriteMap("map/t/t02", "t02", kAddMapBytes, 'n');
        WriteMap("map/t/l01", "l01", kLargeMapBytes, 'l');
        WriteMap("map/t/l02", "l02", kLargerMapBytes, 'L');
        fs::create_directories(root / "map" / "dsky.sky");
        Write(root / "map" / "dsky.sky" / "pack.json", std::string(kDefaultSkyBytes, 'd'));
        DataReadIndex(root);
        stack.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        scene.stack_num = 12;
        scene.stack[1] = &stack;
    }

    void TearDown() override {
        PathsReset();
        std::error_code error;
        fs::remove_all(root, error);
    }

    void WriteMap(const char *dir, const char *name, std::size_t bytes, char fill) const {
        const fs::path path = root / dir;
        fs::create_directories(path / (std::string(name) + ".mpk"));
        fs::create_directories(path / (std::string(name) + ".sky"));
        Write(path / (std::string(name) + ".map.json"), std::string(bytes, fill));
        Write(path / (std::string(name) + ".cfg.json"), std::string(kCfgBytes, 'c'));
        Write(path / (std::string(name) + ".mpk") / "pack.json", std::string(kPackBytes, 'p'));
        Write(path / (std::string(name) + ".sky") / "pack.json", std::string(kPackBytes, 's'));
    }

    static void Write(const fs::path &path, const std::string &bytes) {
        std::ofstream(path, std::ios::binary) << bytes;
    }

    // A caller's buffer of kCallerQuadwords, followed by bytes standing in for the objects carved after BuffReadData.
    // It is large enough to take the map's reads, so without the fix the overrun shows as changed bytes.
    static std::vector<u_long128> CallerBuffer(const SCN_LOADMAP_INFO2 &info) {
        std::vector<u_long128> caller(PortMapLoadBytes(info) / sizeof(u_long128) + kCallerQuadwords);
        std::memset(caller.data(), 0x3C, caller.size() * sizeof(u_long128));
        return caller;
    }

    static std::string MapText(const SCN_LOADMAP_INFO2::MapFiles &files) {
        return std::string(files.map_data, static_cast<std::size_t>(files.map_size));
    }
};
} // namespace

TEST_F(SceneLoadMapBuffer, MeasuresEachReadRoundedTo64AndTheLastSectorTail) {
    SCN_LOADMAP_INFO2 info = Info(nullptr);
    const std::size_t reads = Pad64(kMapBytes) + Pad64(kCfgBytes) + 64 + 64;
    EXPECT_EQ(PortMapLoadBytes(info), reads + DATAREAD_SECTOR_SIZE);
    info.load_sky = 0;
    EXPECT_EQ(PortMapLoadBytes(info), reads - 64 + DATAREAD_SECTOR_SIZE);
    info.files[0].enable = 0;
    EXPECT_EQ(PortMapLoadBytes(info), DATAREAD_SECTOR_SIZE);
}

TEST_F(SceneLoadMapBuffer, MeasuresTheSecondFileSetAndTheLargerOfTheMapAndDefaultSky) {
    SCN_LOADMAP_INFO2 info = Info(nullptr);
    SetMapFiles(info.files[1], "map/t/t02/", "t02");
    const std::size_t first = Pad64(kMapBytes) + Pad64(kCfgBytes) + 64 + 64;
    const std::size_t second = Pad64(kAddMapBytes) + Pad64(kCfgBytes) + 64 + 64;
    EXPECT_EQ(PortMapLoadBytes(info), first + second + DATAREAD_SECTOR_SIZE);
    // A missing or smaller map sky is measured as the default sky LoadMapData falls back to.
    std::strcpy(info.files[1].def_sky_name, "dsky");
    EXPECT_EQ(PortMapLoadBytes(info), first + second - 64 + Pad64(kDefaultSkyBytes) + DATAREAD_SECTOR_SIZE);
}

TEST_F(SceneLoadMapBuffer, MapLargerThanTheCallersBufferLeavesItAndWhatFollowsUntouched) {
    SCN_LOADMAP_INFO2      info = Info(nullptr);
    std::vector<u_long128> caller = CallerBuffer(info);
    ASSERT_GT(kMapBytes, kCallerQuadwords * sizeof(u_long128));
    const std::vector<u_long128> before = caller;
    info.load_buf = reinterpret_cast<u8 *>(caller.data());

    // No .ipk: LoadMapData reads the other files and LoadMap reports the map as not loaded.
    EXPECT_EQ(scene.LoadMap(0, &info, 0), -1);

    EXPECT_EQ(std::memcmp(caller.data(), before.data(), caller.size() * sizeof(u_long128)), 0);
    EXPECT_EQ(info.load_buf, reinterpret_cast<u8 *>(caller.data()));
    ASSERT_EQ(info.files[0].map_size, static_cast<int>(kMapBytes));
    EXPECT_EQ(MapText(info.files[0]), std::string(kMapBytes, 'm'));
    EXPECT_EQ(reinterpret_cast<uintptr_t>(info.files[0].map_data) % 64, 0u);
    EXPECT_EQ(info.files[0].cfg_size, static_cast<int>(kCfgBytes));
    EXPECT_EQ(std::string(info.files[0].cfg_data, kCfgBytes), std::string(kCfgBytes, 'c'));
    EXPECT_EQ(std::string(reinterpret_cast<char *>(info.files[0].sky_data), kPackBytes), std::string(kPackBytes, 's'));
}

TEST_F(SceneLoadMapBuffer, DeferredReadsLeaveTheCallersBufferUntouched) {
    SCN_LOADMAP_INFO2            info = Info(nullptr);
    std::vector<u_long128>       caller = CallerBuffer(info);
    const std::vector<u_long128> before = caller;
    info.load_buf = reinterpret_cast<u8 *>(caller.data());

    EXPECT_EQ(scene.LoadMap(0, &info, 1), -1);
    InitReadBG();

    EXPECT_EQ(std::memcmp(caller.data(), before.data(), caller.size() * sizeof(u_long128)), 0);
    ASSERT_EQ(info.files[0].map_size, static_cast<int>(kMapBytes));
    EXPECT_EQ(MapText(info.files[0]), std::string(kMapBytes, 'm'));
    EXPECT_EQ(std::string(info.files[0].cfg_data, kCfgBytes), std::string(kCfgBytes, 'c'));
}

TEST_F(SceneLoadMapBuffer, SecondFileSetIsReadAfterTheFirst) {
    SCN_LOADMAP_INFO2 info = Info(nullptr);
    SetMapFiles(info.files[1], "map/t/t02/", "t02");
    std::vector<u_long128>       caller = CallerBuffer(info);
    const std::vector<u_long128> before = caller;
    info.load_buf = reinterpret_cast<u8 *>(caller.data());

    EXPECT_EQ(scene.LoadMap(0, &info, 0), -1);

    EXPECT_EQ(std::memcmp(caller.data(), before.data(), caller.size() * sizeof(u_long128)), 0);
    EXPECT_EQ(MapText(info.files[0]), std::string(kMapBytes, 'm'));
    ASSERT_EQ(info.files[1].map_size, static_cast<int>(kAddMapBytes));
    EXPECT_EQ(MapText(info.files[1]), std::string(kAddMapBytes, 'n'));
    EXPECT_GE(info.files[1].map_data, reinterpret_cast<char *>(info.files[0].sky_data) + 64);
    EXPECT_EQ(std::string(reinterpret_cast<char *>(info.files[1].sky_data), kPackBytes), std::string(kPackBytes, 's'));
}

TEST_F(SceneLoadMapBuffer, GrowsForALargerMapKeepsThePreviousOneAndReusesItForASmallerMap) {
    SCN_LOADMAP_INFO2 large = Info(nullptr, "map/t/l01/", "l01");
    EXPECT_EQ(scene.LoadMap(0, &large, 0), -1);
    ASSERT_EQ(large.files[0].map_size, static_cast<int>(kLargeMapBytes));

    // The larger map gets a new buffer; the previous one stays readable for a deferred load still using it.
    SCN_LOADMAP_INFO2 larger = Info(nullptr, "map/t/l02/", "l02");
    EXPECT_EQ(scene.LoadMap(0, &larger, 0), -1);
    ASSERT_EQ(larger.files[0].map_size, static_cast<int>(kLargerMapBytes));
    EXPECT_NE(larger.files[0].map_data, large.files[0].map_data);
    EXPECT_EQ(MapText(larger.files[0]), std::string(kLargerMapBytes, 'L'));
    EXPECT_EQ(MapText(large.files[0]), std::string(kLargeMapBytes, 'l'));

    // A smaller map reuses the grown buffer.
    SCN_LOADMAP_INFO2 small = Info(nullptr);
    EXPECT_EQ(scene.LoadMap(0, &small, 0), -1);
    EXPECT_EQ(small.files[0].map_data, larger.files[0].map_data);
    EXPECT_EQ(MapText(small.files[0]), std::string(kMapBytes, 'm'));
}

// A plain test: Windows death tests rerun the test in a child, which must not create files it cannot remove.
TEST(SceneLoadMapBufferDeathTest, ReadPastTheMeasuredBytesStopsTheGame) {
    SCN_LOADMAP_INFO2 info = Info(nullptr);
    info.files[0].enable = 0;
    u8               *base = PortMapLoadBuffer(info);
    const std::size_t reads = PortMapLoadBytes(info) - DATAREAD_SECTOR_SIZE;
    PortMapLoadCheck(info, base + reads);
    EXPECT_DEATH(PortMapLoadCheck(info, base + reads + 64),
                 "map load: map/t/t01/t01 read \\d+ bytes, past the \\d+ measured for its files");
    base[reads + DATAREAD_SECTOR_SIZE] = 0;
    EXPECT_DEATH(PortMapLoadCheck(info, base + reads), "map load: map/t/t01/t01 read");
}
