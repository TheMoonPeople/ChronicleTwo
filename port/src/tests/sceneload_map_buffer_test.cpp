#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "event_func.hpp"
#include "map.hpp"
#include "mg_memory.hpp"
#include "object/world/map_load_size.hpp"
#include "platform/paths.hpp"
#include "scenesnd.hpp"
#include "text/bounded.hpp"

namespace {
namespace fs = std::filesystem;

constexpr std::size_t kMapBytes = 70001;
constexpr std::size_t kAddMapBytes = 90001;
constexpr std::size_t kLargeMapBytes = 300001;
constexpr std::size_t kCfgBytes = 333;
constexpr std::size_t kPackBytes = 54;
constexpr std::size_t kDefaultSkyBytes = 300;
constexpr std::size_t kCallerBytes = 1024;

std::size_t Pad64(std::size_t size) {
    return (size + 63) / 64 * 64;
}

void SetMapFiles(SCN_LOADMAP_INFO2::MapFiles &files, const char *dir, const char *name) {
    files.enable = 1;
    dc2::text::Copy(files.dir, dir);
    for (auto *field : {&files.map_name, &files.cfg_name, &files.mpk_name, &files.ipk_name, &files.efp_name, &files.sky_name}) {
        dc2::text::Copy(*field, name);
    }
    dc2::text::Copy(files.def_sky_name, "none");
}

SCN_LOADMAP_INFO2 Info(u8 *load_buf, const char *dir = "map/t/t01/", const char *name = "t01") {
    SCN_LOADMAP_INFO2 info;
    info.stack_no = 1;
    info.load_buf = load_buf;
    info.load_sky = 1;
    SetMapFiles(info.files[0], dir, name);
    return info;
}

std::string MapText(const SCN_LOADMAP_INFO2::MapFiles &files) {
    return {files.map_data, static_cast<std::size_t>(files.map_size)};
}

/**
 *
 * Maps under a temporary data root whose .map files are larger than the caller's load buffer. No .ipk is written, so
 * LoadMap stops after reading the other files.
 *
 */
class SceneLoadMapBuffer : public testing::Test {
protected:
    fs::path               root = fs::temp_directory_path() /
                                  ("sceneload_map_buffer_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::vector<u_long128> storage = std::vector<u_long128>(0x1000);
    std::vector<u8>        caller = std::vector<u8>(kCallerBytes, 0x3C);
    mgCMemory              stack;
    CScene                 scene;

    void SetUp() override {
        WriteMap("map/t/t01", "t01", kMapBytes, 'm');
        WriteMap("map/t/t02", "t02", kAddMapBytes, 'n');
        WriteMap("map/t/l01", "l01", kLargeMapBytes, 'l');
        WriteMap("map/t/l02", "l02", kLargeMapBytes * 2, 'v');
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

    void WriteMap(const char *dir, const std::string &name, std::size_t bytes, char fill) const {
        const fs::path path = root / dir;
        fs::create_directories(path / (name + ".mpk"));
        fs::create_directories(path / (name + ".sky"));
        Write(path / (name + ".map.json"), std::string(bytes, fill));
        Write(path / (name + ".cfg.json"), std::string(kCfgBytes, 'c'));
        Write(path / (name + ".mpk") / "pack.json", std::string(kPackBytes, 'p'));
        Write(path / (name + ".sky") / "pack.json", std::string(kPackBytes, 's'));
    }

    static void Write(const fs::path &path, const std::string &bytes) {
        std::ofstream(path, std::ios::binary) << bytes;
    }

    [[nodiscard]] bool CallerUntouched() const {
        return std::ranges::all_of(caller, [](u8 byte) { return byte == 0x3C; });
    }
};
} // namespace

TEST_F(SceneLoadMapBuffer, MeasuresEachReadRoundedTo64AndTheLastSectorTail) {
    SCN_LOADMAP_INFO2 info = Info(nullptr);
    const std::size_t reads = Pad64(kMapBytes) + Pad64(kCfgBytes) + Pad64(kPackBytes) * 2;
    EXPECT_EQ(PortMapLoadBytes(info), reads + DATAREAD_SECTOR_SIZE);
    info.load_sky = 0;
    EXPECT_EQ(PortMapLoadBytes(info), reads - Pad64(kPackBytes) + DATAREAD_SECTOR_SIZE);
    info.files[0].enable = 0;
    EXPECT_EQ(PortMapLoadBytes(info), DATAREAD_SECTOR_SIZE);
}

TEST_F(SceneLoadMapBuffer, MeasuresTheSecondFileSetAndTheLargerOfTheMapAndDefaultSky) {
    SCN_LOADMAP_INFO2 info = Info(nullptr);
    SetMapFiles(info.files[1], "map/t/t02/", "t02");
    const std::size_t first = Pad64(kMapBytes) + Pad64(kCfgBytes) + Pad64(kPackBytes) * 2;
    const std::size_t second = Pad64(kAddMapBytes) + Pad64(kCfgBytes) + Pad64(kPackBytes) * 2;
    EXPECT_EQ(PortMapLoadBytes(info), first + second + DATAREAD_SECTOR_SIZE);
    dc2::text::Copy(info.files[1].def_sky_name, "dsky");
    EXPECT_EQ(PortMapLoadBytes(info), first + second - Pad64(kPackBytes) + Pad64(kDefaultSkyBytes) + DATAREAD_SECTOR_SIZE);
}

TEST_F(SceneLoadMapBuffer, MapsLargerThanTheCallersBufferLeaveItUntouched) {
    SCN_LOADMAP_INFO2 info = Info(caller.data());
    SetMapFiles(info.files[1], "map/t/t02/", "t02");

    EXPECT_EQ(scene.LoadMap(0, &info, 0), -1);

    EXPECT_TRUE(CallerUntouched());
    EXPECT_EQ(info.load_buf, caller.data());
    EXPECT_EQ(MapText(info.files[0]), std::string(kMapBytes, 'm'));
    EXPECT_EQ(reinterpret_cast<std::uintptr_t>(info.files[0].map_data) % 64, 0U);
    EXPECT_EQ(std::string(info.files[0].cfg_data, kCfgBytes), std::string(kCfgBytes, 'c'));
    EXPECT_EQ(MapText(info.files[1]), std::string(kAddMapBytes, 'n'));
    EXPECT_EQ(std::string(reinterpret_cast<char *>(info.files[1].sky_data), kPackBytes), std::string(kPackBytes, 's'));
}

TEST_F(SceneLoadMapBuffer, DeferredReadsLeaveTheCallersBufferUntouched) {
    SCN_LOADMAP_INFO2 info = Info(caller.data());

    EXPECT_EQ(scene.LoadMap(0, &info, 1), -1);
    InitReadBG();

    EXPECT_TRUE(CallerUntouched());
    EXPECT_EQ(MapText(info.files[0]), std::string(kMapBytes, 'm'));
}

TEST_F(SceneLoadMapBuffer, GrowsForALargerMapAndKeepsThePreviousOne) {
    SCN_LOADMAP_INFO2 small = Info(nullptr);
    EXPECT_EQ(scene.LoadMap(0, &small, 0), -1);

    SCN_LOADMAP_INFO2 large = Info(nullptr, "map/t/l01/", "l01");
    EXPECT_EQ(scene.LoadMap(0, &large, 0), -1);
    EXPECT_EQ(MapText(large.files[0]), std::string(kLargeMapBytes, 'l'));
    EXPECT_EQ(MapText(small.files[0]), std::string(kMapBytes, 'm'));

    SCN_LOADMAP_INFO2 again = Info(nullptr);
    EXPECT_EQ(scene.LoadMap(0, &again, 0), -1);
    EXPECT_NE(again.files[0].map_data, large.files[0].map_data);
    EXPECT_EQ(MapText(again.files[0]), std::string(kMapBytes, 'm'));
    EXPECT_EQ(MapText(large.files[0]), std::string(kLargeMapBytes, 'l'));
}

TEST(SceneDeleteMap, ReleasesOnlyMapBackedHandlesInsideTheDeletedArena) {
    std::vector<u_long128> storage(256);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CMap   loaded_map;
    CScene scene;
    scene.map_num = 1;
    scene.map[0].AssignData(&loaded_map, const_cast<char *>("map"));
    scene.map[0].stack = &memory;
    EventObjHandleMother = CEohMother{};
    auto &handles = EventObjHandleMother.eoh;
    handles[0].Set(EOH_TYPE_OBJECT, reinterpret_cast<CObject *>(memory.stack), 0);
    handles[1].Set(EOH_TYPE_FRAME, reinterpret_cast<mgCFrame *>(memory.stack + 1));
    handles[2].Set(EOH_TYPE_FUNC_POINT, reinterpret_cast<CFuncPoint *>(memory.stack + 2));
    handles[3].Set(EOH_TYPE_OBJECT, reinterpret_cast<CObject *>(memory.stack + memory.stack_size), 0);
    handles[4].Set(EOH_TYPE_CHARA, 4, reinterpret_cast<CCharacter2 *>(memory.stack));
    handles[5].Set(EOH_TYPE_SPRITE, reinterpret_cast<CEventSprite2 *>(memory.stack));
    CObject outside;
    handles[6].Set(EOH_TYPE_OBJECT, &outside, 0);
    EXPECT_EQ(scene.DeleteMap(0, 0), 1);
    for (int index = 0; index < 3; ++index) {
        EXPECT_EQ(handles[index].type, EOH_TYPE_NONE);
        EXPECT_EQ(handles[index].scene_no, -1);
        EXPECT_EQ(handles[index].world_coord, 1);
        EXPECT_EQ(handles[index].object, nullptr);
    }
    EXPECT_EQ(handles[3].type, EOH_TYPE_OBJECT);
    EXPECT_EQ(handles[4].type, EOH_TYPE_CHARA);
    EXPECT_EQ(handles[5].type, EOH_TYPE_SPRITE);
    EXPECT_EQ(handles[6].object, &outside);
    EXPECT_EQ(scene.GetMap(0), nullptr);
    EventObjHandleMother = CEohMother{};
}

TEST(SceneDeleteMap, EmptySlotsPreserveHandlesAndSharedArenaMapsAreDeletedTogether) {
    std::vector<u_long128> storage(256);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CScene scene;
    scene.map_num = 2;
    EventObjHandleMother = CEohMother{};
    auto &handle = EventObjHandleMother.eoh[0];
    handle.Set(EOH_TYPE_OBJECT, reinterpret_cast<CObject *>(memory.stack), 0);
    EXPECT_EQ(scene.DeleteMap(-1, 1), 0);
    EXPECT_EQ(scene.DeleteMap(0, 1), 0);
    EXPECT_EQ(handle.type, EOH_TYPE_OBJECT);
    CMap first;
    CMap second;
    scene.map[0].AssignData(&first, const_cast<char *>("first"));
    scene.map[1].AssignData(&second, const_cast<char *>("second"));
    scene.map[0].stack = &memory;
    scene.map[1].stack = &memory;
    EXPECT_EQ(scene.DeleteMap(0, 1), 1);
    EXPECT_EQ(handle.type, EOH_TYPE_NONE);
    EXPECT_EQ(scene.GetMap(0), nullptr);
    EXPECT_EQ(scene.GetMap(1), nullptr);
    EventObjHandleMother = CEohMother{};
}

TEST_F(SceneLoadMapBuffer, CopiesKeepTheirFileBytesAcrossThreeGrowingLoadsAndOriginalRequestReset) {
    SCN_LOADMAP_INFO2 first = Info(nullptr);
    EXPECT_EQ(scene.LoadMap(0, &first, 0), -1);
    SCN_LOADMAP_INFO2 retained = first;
    first.Initialize();
    SCN_LOADMAP_INFO2 second = Info(nullptr, "map/t/l01/", "l01");
    EXPECT_EQ(scene.LoadMap(0, &second, 0), -1);
    SCN_LOADMAP_INFO2 third = Info(nullptr, "map/t/l02/", "l02");
    EXPECT_EQ(scene.LoadMap(0, &third, 0), -1);
    EXPECT_EQ(MapText(retained.files[0]), std::string(kMapBytes, 'm'));
    EXPECT_EQ(MapText(second.files[0]), std::string(kLargeMapBytes, 'l'));
    EXPECT_EQ(MapText(third.files[0]), std::string(kLargeMapBytes * 2, 'v'));
    SCN_LOADMAP_INFO2 shared = second;
    EXPECT_EQ(scene.LoadMap(0, &second, 0), -1);
    EXPECT_NE(second.files[0].map_data, shared.files[0].map_data);
    EXPECT_EQ(MapText(shared.files[0]), std::string(kLargeMapBytes, 'l'));
    const std::weak_ptr<dc2::scene::MapReadStorage> lifetime = retained.map_read_storage;
    EXPECT_FALSE(lifetime.expired());
    retained.Initialize();
    EXPECT_TRUE(lifetime.expired());
}
