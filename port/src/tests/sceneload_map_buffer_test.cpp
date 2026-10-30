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
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "event_func.hpp"
#include "map.hpp"
#include "mdslist.hpp"
#include "mg_memory.hpp"
#include "object/world/map_load_size.hpp"
#include "platform/paths.hpp"
#include "scenesnd.hpp"
#include "scoped_global_object.hpp"
#include "text/bounded.hpp"

namespace {
/**
 * Constructs an unresolved piece whose exact producer identities can be tested without loading a model.
 */
CList<CMapPiece> *AddUnresolvedPiece(CMapParts &part, mgCMemory &memory, std::string_view name) {
    auto *node = dc2::memory::NewObject<CList<CMapPiece>>(memory);
    if (node != nullptr) {
        node->data.SetName(dc2::memory::CopyText(memory, name));
        part.AddPiece(node);
    }
    return node;
}

/**
 * Consumes native arena headroom so a test exposes an exact host allocation boundary.
 */
bool LeaveQuadwords(mgCMemory &memory, std::size_t count) {
    const auto available = dc2::memory::RemainingBytes(memory).size() / sizeof(u_long128);
    return count <= available && (count == available || memory.Alloc(static_cast<int>(available - count)) != nullptr);
}
} // namespace

TEST(MapPieceBindings, OwnedNamesAndValidatedNodesIgnoreMutatedRawLinksAndNames) {
    std::vector<u_long128> storage(2048);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CMapParts source;
    auto     *first = AddUnresolvedPiece(source, memory, "first");
    auto     *second = AddUnresolvedPiece(source, memory, "second");
    ASSERT_NE(first, nullptr);
    ASSERT_NE(second, nullptr);
    const auto first_view = dc2::world::PieceView::Capture(memory, *first);
    const auto second_view = dc2::world::PieceView::Capture(memory, *second);
    ASSERT_TRUE(source.PublishPieceBindings({
        {"first",  first_view },
        {"second", second_view}
    }));
    first->next = reinterpret_cast<CList<CMapPiece> *>(std::uintptr_t{1});
    first->data.name = reinterpret_cast<char *>(std::uintptr_t{1});
    second->data.name = reinterpret_cast<char *>(std::uintptr_t{1});
    second->data.col_type = 1;
    EXPECT_EQ(source.FindPieceView("second").Get(), &second->data);
    char first_name[] = "first";
    EXPECT_EQ(source.SearchPiece(first_name), &first->data);

    std::vector<u_long128> copied_storage(2048);
    mgCMemory              copies;
    copies.stSetBuffer(copied_storage.data(), static_cast<int>(copied_storage.size()));
    CMapParts copied;
    ASSERT_TRUE(source.Copy(copied, &copies));
    EXPECT_NE(copied.AssignmentToken(), source.AssignmentToken());
    ASSERT_NE(copied.FindPieceView("first").Get(), nullptr);
    EXPECT_STREQ(copied.FindPieceView("first").Get()->name, "first");
    EXPECT_EQ(copied.FindPieceView("second").Get(), nullptr);
    memory.stReset();
    EXPECT_EQ(first_view.Get(), nullptr);
    EXPECT_EQ(source.FindPieceView("first").Get(), nullptr);
    EXPECT_NE(copied.FindPieceView("first").Get(), nullptr);
}

TEST(MapPieceBindings, CopyRejectsRetiredSourcesAndAllocationFailureWithoutPublishingPartialLists) {
    std::vector<u_long128> storage(2048);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CMapParts source;
    auto     *node = AddUnresolvedPiece(source, memory, "piece");
    ASSERT_NE(node, nullptr);
    ASSERT_TRUE(source.PublishPieceBindings({
        {"piece", dc2::world::PieceView::Capture(memory, *node)}
    }));
    CMapParts shared;
    ASSERT_TRUE(source.Copy(shared, nullptr));
    ASSERT_NE(shared.FindPieceView("piece").Get(), nullptr);
    mgCMemory locked;
    locked.lock = 1;
    CMapParts failed;
    EXPECT_FALSE(source.Copy(failed, &locked));
    EXPECT_EQ(failed.piece_list, nullptr);
    EXPECT_EQ(failed.FindPieceView("piece").Get(), nullptr);
    memory.stReset();
    EXPECT_EQ(shared.FindPieceView("piece").Get(), nullptr);
    EXPECT_FALSE(source.Copy(shared, nullptr));
    EXPECT_EQ(shared.piece_list, nullptr);
}

TEST(MapPieceBindings, MaterialPointerAndCountReplacementRejectTheCapturedPiece) {
    std::vector<u_long128> storage(2048);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CMapParts part;
    auto     *node = AddUnresolvedPiece(part, memory, "piece");
    ASSERT_NE(node, nullptr);
    auto *materials = dc2::memory::NewArray<PieceMaterial>(memory, 2);
    ASSERT_NE(materials, nullptr);
    node->data.SetMaterial(materials, 2);
    const auto view = dc2::world::PieceView::Capture(memory, *node);
    ASSERT_EQ(view.Get(), &node->data);
    node->data.material_num = 3;
    EXPECT_EQ(view.Get(), nullptr);
    node->data.material_num = 2;
    node->data.material = materials + 1;
    EXPECT_EQ(view.Get(), nullptr);
    node->data.material = materials;
    EXPECT_EQ(view.Get(), &node->data);
}

TEST(MapPieceBindings, MaterialCloneExhaustionFailsEvenWhenTheNodeAndNameWouldFit) {
    std::vector<u_long128> storage(2048);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CMapParts source;
    auto     *node = AddUnresolvedPiece(source, memory, "piece");
    ASSERT_NE(node, nullptr);
    auto *materials = dc2::memory::NewArray<PieceMaterial>(memory, 64);
    ASSERT_NE(materials, nullptr);
    node->data.SetMaterial(materials, 64);
    ASSERT_TRUE(source.PublishPieceBindings({
        {"piece", dc2::world::PieceView::Capture(memory, *node)}
    }));
    const auto node_words = dc2::memory::ArrayQuadwords<CList<CMapPiece>>(1);
    ASSERT_TRUE(node_words);
    std::vector<u_long128> small_storage(static_cast<std::size_t>(*node_words) + 8);
    mgCMemory              small;
    small.stSetBuffer(small_storage.data(), static_cast<int>(small_storage.size()));
    ASSERT_TRUE(LeaveQuadwords(small, static_cast<std::size_t>(*node_words) + 8));
    CMapParts destination;
    EXPECT_FALSE(source.Copy(destination, &small));
    EXPECT_EQ(destination.piece_list, nullptr);
    EXPECT_EQ(destination.FindPieceView("piece").Get(), nullptr);
}

TEST(MapPieceBindings, FunctionPointAndAnimationAllocationFailuresLeaveTheDestinationEmpty) {
    std::vector<u_long128> storage(2048);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CMapParts source;
    ASSERT_NE(source.func_point_mngr.Add(FUNC_POINT_ANIME, &memory), nullptr);
    source.anime_list = dc2::memory::NewObject<CList<CObjAnime>>(memory);
    ASSERT_NE(source.anime_list, nullptr);
    const auto function_words = dc2::memory::ArrayQuadwords<CList<CFuncPoint>>(1);
    const auto animation_words = dc2::memory::ArrayQuadwords<CList<CObjAnime>>(1);
    ASSERT_TRUE(function_words);
    ASSERT_TRUE(animation_words);
    for (const int capacity : {*function_words, *function_words + *animation_words}) {
        std::vector<u_long128> small_storage(static_cast<std::size_t>(capacity));
        mgCMemory              small;
        small.stSetBuffer(small_storage.data(), capacity);
        ASSERT_TRUE(LeaveQuadwords(small, static_cast<std::size_t>(capacity)));
        ASSERT_EQ(dc2::memory::RemainingBytes(small).size(), static_cast<std::size_t>(capacity) * sizeof(u_long128));
        const int used_before = small.stack_used;
        CMapParts destination;
        EXPECT_FALSE(source.Copy(destination, &small));
        EXPECT_EQ(small.stack_used - used_before, capacity == *function_words ? 0 : *function_words);
        EXPECT_EQ(destination.piece_list, nullptr);
        EXPECT_EQ(destination.anime_list, nullptr);
        destination.func_point_mngr.GetStart(FUNC_POINT_ANIME);
        EXPECT_EQ(destination.func_point_mngr.Get(), nullptr);
        EXPECT_EQ(source.anime_list->next, nullptr);
    }
    std::vector<u_long128> copied_storage(2048);
    mgCMemory              copies;
    copies.stSetBuffer(copied_storage.data(), static_cast<int>(copied_storage.size()));
    CMapParts copied;
    ASSERT_TRUE(source.Copy(copied, &copies));
    EXPECT_NE(copied.anime_list, source.anime_list);
    EXPECT_EQ(source.anime_list->next, nullptr);
}

TEST(PlacedPartBindings, AssignmentAndTableReplacementRevokeViewsAndUnexpectedFrameLinksRejectResolution) {
    std::vector<u_long128> storage(2048);
    std::vector<u_long128> replacement_storage(2048);
    mgCMemory              memory;
    mgCMemory              replacement;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    replacement.stSetBuffer(replacement_storage.data(), static_cast<int>(replacement_storage.size()));
    CMap map;
    ASSERT_TRUE(map.SetPlacePartsBuff(&memory, 2));
    auto parts = map.PlacedParts();
    char name[] = "placed";
    parts[0].SetName(name);
    const auto original = map.FindPlacedPart(name);
    ASSERT_EQ(original.Get(map), &parts[0]);
    parts[0].Initialize();
    parts[0].SetName(name);
    EXPECT_EQ(original.Get(map), nullptr);
    const auto previous_binding = map.FindPlacedPart(name);
    ASSERT_EQ(previous_binding.Get(map), &parts[0]);
    ASSERT_TRUE(parts[0].PublishPieceBindings({}));
    EXPECT_EQ(previous_binding.Get(map), nullptr);
    const auto current = map.FindPlacedPart(name);
    ASSERT_EQ(current.Get(map), &parts[0]);
    parts[0].frame.parent = reinterpret_cast<mgCFrame *>(std::uintptr_t{1});
    EXPECT_EQ(current.Get(map), nullptr);
    sceVu0FMATRIX matrix;
    parts[0].GetLWMatrix(matrix);
    EXPECT_FLOAT_EQ(matrix[0][0], 1.0f);
    parts[0].frame.parent = nullptr;
    ASSERT_TRUE(map.SetPlacePartsBuff(&replacement, 2));
    map.PlacedParts()[0].SetName(name);
    EXPECT_EQ(current.Get(map), nullptr);
    EXPECT_NE(map.FindPlacedPart(name).Get(map), nullptr);
}

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

TEST_F(SceneLoadMapBuffer, PieceLookupKeepsTheResolvedCanonicalModelSpellingAndExplicitOverrides) {
    auto *entry = dc2::memory::NewObject<CMdsInfo>(stack);
    ASSERT_NE(entry, nullptr);
    entry->resource_lifetime = dc2::memory::ArenaLifetime::Capture(stack);
    ASSERT_TRUE(entry->AssignName(stack, "Foo"));
    CMdsListSet models;
    models.mds_list_num = 1;
    models.mds_list[0].resource_lifetime = dc2::memory::ArenaLifetime::Capture(stack);
    models.mds_list[0].num = 1;
    models.mds_list[0].list = entry;
    std::string document = R"({"schema_version":2,"kind":"scene_map","info":{"texture_packs":[],"model_packs":[],"light_sets":[]},"parts":[{"name":"definition","pieces":[{"model":"foo"},{"model":"foo","name":"named"}]}],"placements":[]})";
    fs::create_directories(root / "map");
    std::ofstream(root / "map/canonical.map.json") << document;
    DataReadIndex(root);
    DataReadRegisterAsset(document.data(), "map/canonical.map.json", document.size());
    CMap map;
    map.mds_list_set = &models;
    map.LoadMapFile(document.data(), static_cast<int>(document.size()), &stack, 0);
    char  definition[] = "definition";
    auto *part = map.GetParts(definition);
    ASSERT_NE(part, nullptr);
    char canonical[] = "Foo";
    char authored[] = "foo";
    char overridden[] = "named";
    EXPECT_NE(part->SearchPiece(canonical), nullptr);
    EXPECT_EQ(part->SearchPiece(authored), nullptr);
    EXPECT_NE(part->SearchPiece(overridden), nullptr);
    CMdsInfo retained_name;
    ASSERT_TRUE(retained_name.AssignName(stack, "retained"));
    stack.stReset();
    EXPECT_FALSE(retained_name.CanonicalName());
}

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

TEST(SceneMapSettings, PackSearchUsesTheSettingsMemberAndHonorsExcludedSlots) {
    auto scene = std::make_unique<CScene>();
    auto map = std::make_unique<CMap>();
    scene->map_num = 1;
    char map_name[] = "map";
    ASSERT_EQ(scene->map[0].AssignData(map.get(), map_name), 1);
    char texture[] = "texture.json";
    char model[] = "model.pcp";
    map->map_info.img_num = 16;
    map->map_info.pcp_num = 16;
    map->map_info.img_name[0] = texture;
    map->map_info.pcp_name[0] = model;
    EXPECT_EQ(scene->CheckIMGName(-1, texture), 1);
    EXPECT_EQ(scene->CheckMDSName(-1, model), 1);
    EXPECT_EQ(scene->CheckIMGName(0, texture), 0);
    EXPECT_EQ(scene->CheckMDSName(0, model), 0);
    EXPECT_EQ(scene->CheckIMGName(-1, nullptr), 0);
    EXPECT_EQ(scene->CheckMDSName(-1, nullptr), 0);
}

TEST(SceneMapSettings, LightingExchangeSwapsTypedSetsAndRejectsMissingInputs) {
    dc2::test::ScopedGlobalObject<DngMainScene> scene;
    auto                                        map = std::make_unique<CMap>();
    scene->map_num = 1;
    scene->active_map = 0;
    char map_name[] = "lighting";
    ASSERT_EQ(scene->map[0].AssignData(map.get(), map_name), 1);
    std::array<CMapLightingInfo, MAP_INFO_LIGHTING_MAX> lighting{};
    for (std::size_t index = 0; index < lighting.size(); ++index) {
        lighting[index].bg_color[0] = static_cast<float>(index);
    }
    XChgMapLighting();
    map->map_info.lighting_info = lighting.data();
    map->map_info.lighting_info_num = MAP_INFO_LIGHTING_MAX - 1;
    XChgMapLighting();
    EXPECT_FLOAT_EQ(lighting[0].bg_color[0], 0.0f);
    map->map_info.lighting_info_num = MAP_INFO_LIGHTING_MAX;
    XChgMapLighting();
    for (std::size_t index = 0; index < lighting.size(); ++index) {
        EXPECT_FLOAT_EQ(lighting[index].bg_color[0], static_cast<float>((index + 8) % lighting.size()));
    }
    XChgMapLighting();
    EXPECT_FLOAT_EQ(lighting[0].bg_color[0], 0.0f);
}
