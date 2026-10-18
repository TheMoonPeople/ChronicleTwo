#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

#include "dataread.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "font.hpp"
#include "gamepad.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "platform/clock.hpp"
#include "platform/config.hpp"
#include "platform/files.hpp"
#include "platform/paths.hpp"
#include "platform_fixture.hpp"
#include "play_time.hpp"
#include "save_json.hpp"
#include "save_slots.hpp"
#include "scene.hpp"

namespace fs = std::filesystem;

namespace {
class SaveSlotTest : public testing::Test {
protected:
    fs::path                         root;
    std::unique_ptr<SAVEDATA_FORMAT> image = std::make_unique<SAVEDATA_FORMAT>();
    std::unique_ptr<SAVEDATA_FORMAT> buffer = std::make_unique<SAVEDATA_FORMAT>();
    std::unique_ptr<SaveDocument>    document = std::make_unique<SaveDocument>();
    std::unique_ptr<CSaveData>       live = std::make_unique<CSaveData>();
    CSaveData                       *previous = PortActiveSaveData;
    CMemoryCardManager               manager;

    void SetUp() override {
        SaveSlotSetImportHook({});
        root = fs::temp_directory_path() / ("dc2_save_slots_" + std::to_string(dc::test::ProcessId())) / "save";
        fs::remove_all(root.parent_path());
        fs::create_directories(root / "saves");
        PathsSetSaveRoot(root);
        std::memset(image.get(), 0, sizeof(*image));
        std::strcpy(image->version, "dc2Ver4");
        image->map_no = 10;
        image->save_data.map_no = 10;
        image->save_data.game_progress = 2;
        image->save_data.play_time = 123456;
        image->unique_counter = 1;
        PortActiveSaveData = live.get();
        manager.save_buffer = buffer.get();
        manager.InitForMC();
        SaveSlots = {};
        SaveSlotSetPendingSpawn(std::nullopt);
        SaveSlotForgetFloorEntry();
        ClearTowns();
    }

    // The live layouts are found by the address of their record, which a later test's save data may reuse.
    void ClearTowns() {
        for (const CEditData &data : live->edit_data) {
            PortClearTownLayout(data);
        }
    }

    void TearDown() override {
        SaveSlotSetImportHook({});
        manager.FinishForMC();
        PortActiveSaveData = previous;
        SaveSlots = {};
        SaveSlotSetPendingSpawn(std::nullopt);
        SaveSlotForgetFloorEntry();
        ClearTowns();
        SaveSlotNew = false;
        PathsReset();
        std::error_code error;
        fs::remove_all(root.parent_path(), error);
    }

    // A JSON save of the image at a .json path; the raw image elsewhere, as a legacy save.
    void Write(const fs::path &path) {
        if (path.extension() != ".json") {
            WriteRaw(path);
            return;
        }
        fs::create_directories(path.parent_path());
        const auto text = SaveJsonWrite(Document());
        ASSERT_EQ(FilesWrite(path, text.data(), text.size(), false), FilesResult::kWritten);
    }

    void WriteRaw(const fs::path &path, std::size_t size = sizeof(SAVEDATA_FORMAT)) {
        fs::create_directories(path.parent_path());
        ASSERT_EQ(FilesWrite(path, image.get(), size, false), FilesResult::kWritten);
    }

    static void WriteText(const fs::path &path, std::string_view text) {
        fs::create_directories(path.parent_path());
        ASSERT_EQ(FilesWrite(path, text.data(), text.size(), true), FilesResult::kWritten);
    }

    // The fixture image as a save document with empty towns.
    const SaveDocument &Document() {
        *document = {};
        std::memcpy(static_cast<void *>(&document->image), image.get(), sizeof(*image));
        return *document;
    }

    // The unique counter of the save at a path, JSON or legacy, or 0 when it cannot be read.
    static u64 Counter(const fs::path &path) {
        auto read = std::make_unique<SaveDocument>();
        return SaveSlotRead(path, *read) == SaveSlotState::Ready ? read->image.unique_counter : 0;
    }

    // Changes a value inside the save body, leaving the header and the stored checksum as they were.
    static void Corrupt(const fs::path &path) {
        auto        bytes = Bytes(path);
        std::string text(bytes.begin(), bytes.end());
        const auto  at = text.find("\"time_stop\": 0");
        ASSERT_NE(at, std::string::npos);
        text[at + std::strlen("\"time_stop\": ")] = '1';
        WriteText(path, text);
    }

    static std::vector<char> Bytes(const fs::path &path) {
        std::ifstream input(path, std::ios::binary);
        return {std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>()};
    }

    static std::size_t FlatCount() {
        std::size_t count = 0;
        for (const auto &entry : fs::directory_iterator(SaveSlotsRoot())) {
            bool second = false;
            count += entry.is_regular_file() && SaveSlotNumber(entry.path().filename().string(), second) >= 0;
        }
        return count;
    }

    fs::path Archived(int card, int number) {
        auto name = SaveSlotPath(number).filename().replace_extension();
        return root / "imported" / (card ? "mc1" : "mc0") / name / name;
    }

    fs::path Legacy(int card, int number) {
        auto name = SaveSlotPath(number).filename().replace_extension();
        return root / (card ? "mc1" : "mc0") / name / name;
    }

    // A legacy image in the flat save folder.
    static fs::path Raw(int number, bool second_card = false) {
        return SaveSlotPath(number, second_card).replace_extension();
    }
};

struct SaveSlotImportConfiguration {
    int  card;
    bool collision;
};

class SaveSlotImportTest : public SaveSlotTest, public testing::WithParamInterface<SaveSlotImportConfiguration> {};

INSTANTIATE_TEST_SUITE_P(CardsAndCollisions, SaveSlotImportTest,
                         testing::Values(SaveSlotImportConfiguration{0, false}, SaveSlotImportConfiguration{0, true},
                                         SaveSlotImportConfiguration{1, false}, SaveSlotImportConfiguration{1, true}),
                         [](const testing::TestParamInfo<SaveSlotImportConfiguration> &info) {
                             return "Card" + std::to_string(info.param.card) + (info.param.collision ? "Collision" : "NoCollision");
                         });

std::string MessageText(const CDC2Mes &message) {
    std::string text;
    const auto *font = GetYoyakuTblTop();
    for (int i = 0; i < message.tbl_num; ++i) {
        const auto code = message.tbl[i].code;
        if (code == MES_CODE_SPACE) {
            text += ' ';
        } else if (code == MES_CODE_NEWLINE) {
            text += '\n';
        } else if (code < GetYoyakuTblNum()) {
            text += font[code * 2 + 1] == ' ' ? static_cast<char>(font[code * 2]) : '?';
        }
    }
    return text;
}

std::vector<u_long128> SaveMessages(int language) {
    const auto    path = PathsDataRoot().parent_path() / "data/menu" / std::to_string(language) / "save.pac/allmenu.mes";
    std::ifstream file(path, std::ios::binary | std::ios::ate);
    if (!file) {
        return {};
    }
    const auto             size = static_cast<std::size_t>(file.tellg());
    std::vector<u_long128> archive((size + 15) / 16);
    file.seekg(0);
    if (!file.read(reinterpret_cast<char *>(archive.data()), size)) {
        return {};
    }
    return archive;
}

struct MenuRig {
    CSaveMenuClass      menu;
    CMenuKeyFunc        common;
    CMenuPosDataManage  layout = {};
    CMenuPosDataForm    form = {};
    CDC2Mes             message;
    CMenuKeyFunc       *old_common = MenuCommonInfo;
    CMenuPosDataManage *old_layout = MenuPosData;
    CDC2Mes            *old_messages[9]{};
    CMenuPosDataForm   *old_forms[9]{};
    int                 old_language = LanguageCode;

    MenuRig() {
        LanguageCode = LANG_ENGLISH;
        common.key_enable = true;
        MenuCommonInfo = &common;
        MenuPosData = &layout;
        for (int i = 0; i < 9; ++i) {
            old_messages[i] = MenuDCMsg[i];
            old_forms[i] = MenuMesForm[i];
            MenuDCMsg[i] = &message;
            MenuMesForm[i] = &form;
        }
        menu.first_step = false;
        menu.CBaseMenuClass::mode = MENU_ASK_MODE_NONE;
        menu.mode = SAVE_MENU_MODE_SAVE;
        menu.step = SAVE_MENU_STEP_READY;
        menu.page = SAVE_MENU_PAGE_FILE_LIST;
        menu.phase = SAVE_LIST_PHASE_SELECT;
        menu.cursor_form = &form;
        menu.list_form = &form;
        menu.scrlbar_form = &form;
        menu.script = const_cast<char *>("");
        menu.script_size = 0;
        GamePad__2.key_lock = 0;
        GamePad__2.previous_pad[0].button = 0;
        GamePad__2.pad[0].button = 0;
    }

    ~MenuRig() {
        MenuCommonInfo = old_common;
        MenuPosData = old_layout;
        LanguageCode = old_language;
        for (int i = 0; i < 9; ++i) {
            MenuDCMsg[i] = old_messages[i];
            MenuMesForm[i] = old_forms[i];
        }
        GamePad__2.pad[0].button = 0;
    }

    void Press(int button) {
        GamePad__2.pad[0].button = button;
        menu.KeyStep();
        GamePad__2.pad[0].button = 0;
    }

    void Idle() {
        for (int i = 0; i < 10; ++i) {
            menu.KeyStep();
        }
    }
};
} // namespace

TEST_F(SaveSlotTest, NamesAreCanonicalAndIgnoreTemporaryFiles) {
    bool second = false;
    EXPECT_EQ(SaveSlotNumber("BESCES-51190dkcl0", second), 0);
    EXPECT_FALSE(second);
    EXPECT_EQ(SaveSlotNumber("BESCES-51190dkcl0.json", second), 0);
    EXPECT_FALSE(second);
    EXPECT_EQ(SaveSlotNumber("BESCES-51190dkcl999999999.card2", second), 999999999);
    EXPECT_TRUE(second);
    EXPECT_EQ(SaveSlotNumber("BESCES-51190dkcl3.card2.json", second), 3);
    EXPECT_TRUE(second);
    EXPECT_EQ(SaveSlotPath(3, true).filename(), "BESCES-51190dkcl3.card2.json");
    EXPECT_EQ(SaveSlotAutosavePath().filename(), "autosave.json");
    for (const auto *name : {"BESCES-51190dkcl01", "BESCES-51190dkcl-1", "BESCES-51190dkcl1000000000",
                             "BESCES-51190dkcl0.123.tmp", "BESCES-51190dkcl0.json.1a2b.tmp", "BESCES-51190dkcl",
                             "BESCES-51190dkcl0.json.json", "icon.sys", "../BESCES-51190dkcl0"}) {
        EXPECT_EQ(SaveSlotNumber(name, second), -1) << name;
    }
}

TEST_F(SaveSlotTest, ImportsBothCardsAndArchivesCompleteOriginalEntries) {
    std::vector<std::vector<char> > originals;
    for (int number = 0; number < 3; ++number) {
        image->unique_counter = number + 1;
        Write(Legacy(0, number));
        originals.push_back(Bytes(Legacy(0, number)));
    }
    image->unique_counter = 99;
    Write(Legacy(1, 0));
    const auto second = Bytes(Legacy(1, 0));
    const auto icon = Legacy(0, 0).parent_path() / "icon.sys";
    std::ofstream(icon) << "original icon";
    const auto icon_bytes = Bytes(icon);
    auto       list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 4);
    EXPECT_FALSE(list.read_failed);
    for (int number = 0; number < 3; ++number) {
        EXPECT_EQ(Bytes(Archived(0, number)), originals[number]);
        EXPECT_EQ(Counter(SaveSlotPath(number)), number + 1);
    }
    EXPECT_EQ(Bytes(Archived(1, 0)), second);
    EXPECT_EQ(Counter(SaveSlotPath(0, true)), 99);
    EXPECT_EQ(Bytes(Archived(0, 0).parent_path() / "icon.sys"), icon_bytes);
    EXPECT_FALSE(fs::exists(Legacy(0, 0).parent_path()));
    EXPECT_FALSE(fs::exists(Legacy(1, 0).parent_path()));
    EXPECT_EQ(SaveSlotScan().saves.size(), 4); // Reopening never duplicates imports.
}

TEST_F(SaveSlotTest, DifferentLegacyCollisionImportsWithoutReplacingFlatFile) {
    Write(Legacy(0, 0));
    const auto original = Bytes(Legacy(0, 0));
    image->unique_counter = 42;
    Write(SaveSlotPath(0));
    auto before = Bytes(SaveSlotPath(0));
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 2);
    EXPECT_EQ(list.saves[0].info.unique_counter, 42);
    EXPECT_EQ(Counter(SaveSlotPath(1)), 1);
    EXPECT_EQ(Bytes(Archived(0, 0)), original);
    EXPECT_EQ(SaveSlotScan().saves.size(), 2);
    fs::remove(SaveSlotPath(1));
    EXPECT_EQ(SaveSlotScan().saves.size(), 1);
    EXPECT_EQ(Bytes(SaveSlotPath(0)), before);
}

TEST_F(SaveSlotTest, UnusableEntriesReserveNamesEvenWhenUnreadableRowsAreSkipped) {
    WriteRaw(Raw(0), 100);
    image->incomplete = 1;
    Write(Raw(1));
    image->incomplete = 0;
    image->check_digit = 999999;
    Write(Raw(2));
    image->check_digit = 0;
    std::memset(image->version, 'x', sizeof(image->version));
    Write(Raw(3));
    fs::create_directory(SaveSlotPath(4));
    fs::create_directories(Legacy(0, 5).parent_path());
    WriteText(SaveSlotPath(6), "{\"format\": \"something else\"}");
    auto before = Bytes(Raw(2));
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 5);
    EXPECT_EQ(list.saves[0].state, SaveSlotState::WrongSize);
    EXPECT_EQ(list.saves[1].state, SaveSlotState::Incomplete);
    EXPECT_EQ(list.saves[2].state, SaveSlotState::Ready);
    EXPECT_EQ(SaveSlotRead(Raw(2), *document), SaveSlotState::BadChecksum);
    EXPECT_EQ(list.saves[3].state, SaveSlotState::WrongVersion);
    EXPECT_EQ(list.saves[4].state, SaveSlotState::Invalid);
    EXPECT_STREQ(SaveSlotStatus(list.saves[4].state), "Unusable save (contents)");
    EXPECT_EQ(SaveSlotRows(list, true), 6);
    EXPECT_EQ(SaveSlotRows(list, false), 5);
    EXPECT_EQ(SaveSlotFirstFree(list), 7);
    EXPECT_EQ(Bytes(Raw(2)), before);
    EXPECT_FALSE(fs::exists(root / "imported"));
}

TEST_F(SaveSlotTest, CatalogHasNoRetailSlotLimitAndOnlyOneNewRow) {
    for (int number = 0; number < 31; ++number) {
        image->unique_counter = number + 1;
        Write(SaveSlotPath(number));
    }
    manager.GetAllSaveFileInfo();
    EXPECT_EQ(manager.CheckDataFileNum(), 31);
    EXPECT_EQ(manager.GetUpdateFile(), 30);
    EXPECT_EQ(manager.CheckMaxUniqueCounter(), 31);
    EXPECT_EQ(SaveSlotRows(SaveSlots, false), 31);
    EXPECT_EQ(SaveSlotRows(SaveSlots, true), 32);
    for (int row = -1; row <= 32; ++row) {
        EXPECT_EQ(SaveSlotIsNew(SaveSlots, row, true), row == 31);
        EXPECT_FALSE(SaveSlotIsNew(SaveSlots, row, false));
    }
    SaveSlotNew = true;
    manager.SaveToMc(31);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_TRUE(fs::is_regular_file(SaveSlotPath(31)));
    EXPECT_EQ(SaveSlotRows(SaveSlots, true), 33);
}

TEST_F(SaveSlotTest, NewSaveCannotReplaceAFileCreatedAfterDiscovery) {
    manager.GetAllSaveFileInfo();
    Write(SaveSlotPath(0));
    auto original = Bytes(SaveSlotPath(0));
    SaveSlotNew = true;
    manager.SaveToMc(0);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(Bytes(SaveSlotPath(0)), original);
    EXPECT_TRUE(fs::is_regular_file(SaveSlotPath(1)));
    EXPECT_EQ(manager.file_no, 1);
}

TEST_F(SaveSlotTest, LoadBeyondRetailLimitRestoresPayloadAndTransition) {
    image->program_loop_no = LOOP_DUNGEON;
    image->dungeon_no = 2;
    image->floor_id = 4;
    image->dng_tree_flag = 1;
    Write(SaveSlotPath(81));
    manager.GetAllSaveFileInfo();
    ASSERT_EQ(manager.LoadFromMc(0), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(live->map_no, 10);
    EXPECT_EQ(live->play_time, 123456);
    EXPECT_EQ(manager.load_program_loop_no, LOOP_DUNGEON);
    EXPECT_EQ(manager.load_dungeon_no, 2);
    EXPECT_EQ(manager.load_floor_id, 4);
    EXPECT_EQ(manager.load_dng_tree_flag, 1);
}

TEST_F(SaveSlotTest, DungeonAutosaveLoadsOnItsFloor) {
    live->save_dungeon.stage_id = 3;
    live->save_dungeon.floor_id[3] = 7;
    SaveSlotRecordFloorEntry();
    SetDngTreeFlag(1);
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_DUNGEON));
    SetDngTreeFlag(0);

    manager.GetAllSaveFileInfo();
    ASSERT_EQ(manager.LoadFromMc(0), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(manager.load_program_loop_no, LOOP_DUNGEON);
    EXPECT_EQ(manager.load_dungeon_no, 3);
    EXPECT_EQ(manager.load_floor_id, 7);
    EXPECT_EQ(manager.load_dng_tree_flag, 0);
}

// Underground Channel's pump room: Linda's arrival scene sets flag 103 and then sets the boss loose. A save of
// the floor after the scene would load with the flag set and no boss, so the autosave keeps the floor's entry.
TEST_F(SaveSlotTest, DungeonAutosaveKeepsTheStateTheFloorWasEnteredWith) {
    live->save_dungeon.stage_id = 0;
    live->save_dungeon.floor_id[0] = 4;
    live->user_data.money = 303;
    DungeonFloorInit();
    live->SetBitFlag(103, 1);
    live->user_data.money = 999;
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_DUNGEON));

    ASSERT_EQ(SaveSlotRead(SaveSlotAutosavePath(), *document), SaveSlotState::Ready);
    EXPECT_EQ(document->image.program_loop_no, LOOP_DUNGEON);
    EXPECT_EQ(document->image.dungeon_no, 0);
    EXPECT_EQ(document->image.floor_id, 4);
    EXPECT_EQ(document->image.save_data.GetBitFlag(103), 0);
    EXPECT_EQ(document->image.save_data.user_data.money, 303);
    // The live game is untouched, and a town autosave still writes it as it stands.
    EXPECT_EQ(live->GetBitFlag(103), 1);
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_EDIT));
    ASSERT_EQ(SaveSlotRead(SaveSlotAutosavePath(), *document), SaveSlotState::Ready);
    EXPECT_EQ(document->image.save_data.GetBitFlag(103), 1);
}

TEST_F(SaveSlotTest, DungeonAutosaveNeedsAnEntryStateOfTheCurrentFloor) {
    live->save_dungeon.stage_id = 0;
    live->save_dungeon.floor_id[0] = 3;
    EXPECT_FALSE(SaveSlotHasFloorEntry());
    EXPECT_FALSE(SaveSlotWriteAutosave(LOOP_DUNGEON));
    EXPECT_FALSE(fs::exists(SaveSlotAutosavePath()));

    SaveSlotRecordFloorEntry();
    EXPECT_TRUE(SaveSlotHasFloorEntry());
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_DUNGEON));
    const auto original = Bytes(SaveSlotAutosavePath());
    // Another floor, or the same floor number of another dungeon, is not the recorded one.
    live->save_dungeon.floor_id[0] = 4;
    EXPECT_FALSE(SaveSlotHasFloorEntry());
    EXPECT_FALSE(SaveSlotWriteAutosave(LOOP_DUNGEON));
    live->save_dungeon.floor_id[0] = 3;
    live->save_dungeon.stage_id = 1;
    live->save_dungeon.floor_id[1] = 3;
    EXPECT_FALSE(SaveSlotWriteAutosave(LOOP_DUNGEON));
    live->save_dungeon.stage_id = -1;
    EXPECT_FALSE(SaveSlotHasFloorEntry());
    EXPECT_EQ(Bytes(SaveSlotAutosavePath()), original);

    live->save_dungeon.stage_id = 0;
    EXPECT_TRUE(SaveSlotHasFloorEntry());
    SaveSlotForgetFloorEntry();
    EXPECT_FALSE(SaveSlotHasFloorEntry());
    EXPECT_FALSE(SaveSlotWriteAutosave(LOOP_DUNGEON));
    EXPECT_EQ(Bytes(SaveSlotAutosavePath()), original);
}

// A town's Georama layout past retail's part limit, with houses, a placement log and a river grid.
static TownLayout LargeTown(int seed) {
    TownLayout town;
    const int  parts = EDIT_DATA_PARTS_MAX + 40;
    for (int i = 0; i < parts; ++i) {
        TownPart part;
        part.id = seed * 1000 + i + 1;
        part.state = static_cast<s8>(1 + i % 2);
        part.angle = static_cast<s8>(i % 4);
        part.pos = {static_cast<s16>(i), static_cast<s16>(seed), static_cast<s16>(-i)};
        part.color[i % EDIT_DATA_COLOR_MAX] = {0x80, static_cast<u8>(i), static_cast<u8>(seed)};
        part.house_no = i % 10 == 0 ? i / 10 + 1 : 0;
        town.parts.push_back(part);
    }
    for (int i = 0; i < parts / 10 + 1; ++i) {
        town.houses.push_back({.npc_no = static_cast<s16>(seed * 100 + i)});
    }
    for (int i = 1; i < parts; ++i) {
        town.place_log.push_back({.parts_no = static_cast<s16>(i), .base_no = static_cast<s16>(i - 1)});
    }
    TownGrid river;
    river.num_x = 3;
    river.num_z = 2;
    river.pos = {1, 2, 3};
    river.cells = {1, 0, 1, 1, 0, static_cast<u8>(seed & 1)};
    town.grids.push_back(river);
    return town;
}

static void ExpectSameTown(const TownLayout &actual, const TownLayout &expected) {
    ASSERT_EQ(actual.parts.size(), expected.parts.size());
    for (std::size_t i = 0; i < expected.parts.size(); ++i) {
        EXPECT_EQ(actual.parts[i].id, expected.parts[i].id) << i;
        EXPECT_EQ(actual.parts[i].state, expected.parts[i].state) << i;
        EXPECT_EQ(actual.parts[i].angle, expected.parts[i].angle) << i;
        EXPECT_EQ(actual.parts[i].pos, expected.parts[i].pos) << i;
        EXPECT_EQ(actual.parts[i].color, expected.parts[i].color) << i;
        EXPECT_EQ(actual.parts[i].house_no, expected.parts[i].house_no) << i;
    }
    ASSERT_EQ(actual.houses.size(), expected.houses.size());
    for (std::size_t i = 0; i < expected.houses.size(); ++i) {
        EXPECT_EQ(actual.houses[i].npc_no, expected.houses[i].npc_no) << i;
    }
    ASSERT_EQ(actual.place_log.size(), expected.place_log.size());
    for (std::size_t i = 0; i < expected.place_log.size(); ++i) {
        EXPECT_EQ(actual.place_log[i].parts_no, expected.place_log[i].parts_no) << i;
        EXPECT_EQ(actual.place_log[i].base_no, expected.place_log[i].base_no) << i;
    }
    ASSERT_EQ(actual.grids.size(), expected.grids.size());
    for (std::size_t i = 0; i < expected.grids.size(); ++i) {
        EXPECT_EQ(actual.grids[i].num_x, expected.grids[i].num_x) << i;
        EXPECT_EQ(actual.grids[i].num_z, expected.grids[i].num_z) << i;
        EXPECT_EQ(actual.grids[i].pos, expected.grids[i].pos) << i;
        EXPECT_EQ(actual.grids[i].cells, expected.grids[i].cells) << i;
    }
}

// The towns' Georama layouts are kept beside the save data, found by the address of the live town records, so the
// dungeon autosave's entry state owns copies of them: the autosave writes and loads every layout, past retail's part
// limit too, rather than the empty towns a copy of the save data alone would find.
TEST_F(SaveSlotTest, DungeonAutosaveRoundTripsTheTownsLayouts) {
    const TownLayout first = LargeTown(1);
    const TownLayout second = LargeTown(2);
    PortTownLayout(live->edit_data[1]) = first;
    PortTownLayout(live->edit_data[3]) = second;
    live->save_dungeon.stage_id = 2;
    live->save_dungeon.floor_id[2] = 5;
    DungeonFloorInit();
    // The entry state holds the towns as the floor began, whatever later becomes of the live layouts.
    PortTownLayout(live->edit_data[1]).parts.resize(1);
    PortClearTownLayout(live->edit_data[3]);
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_DUNGEON));

    ASSERT_EQ(SaveSlotRead(SaveSlotAutosavePath(), *document), SaveSlotState::Ready);
    EXPECT_EQ(document->image.program_loop_no, LOOP_DUNGEON);
    ExpectSameTown(document->towns[1], first);
    ExpectSameTown(document->towns[3], second);
    EXPECT_TRUE(document->towns[0].parts.empty());
    EXPECT_TRUE(document->towns[2].parts.empty());
    EXPECT_TRUE(document->towns[4].parts.empty());

    // Loading puts every layout back beside the live records.
    ClearTowns();
    manager.GetAllSaveFileInfo();
    ASSERT_EQ(manager.LoadFromMc(0), MC_STEP_DONE);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(manager.load_program_loop_no, LOOP_DUNGEON);
    EXPECT_EQ(manager.load_dungeon_no, 2);
    EXPECT_EQ(manager.load_floor_id, 5);
    ASSERT_NE(PortFindTownLayout(live->edit_data[1]), nullptr);
    ASSERT_NE(PortFindTownLayout(live->edit_data[3]), nullptr);
    ExpectSameTown(*PortFindTownLayout(live->edit_data[1]), first);
    ExpectSameTown(*PortFindTownLayout(live->edit_data[3]), second);

    // A town autosave and a save from the save screen write the layouts as they stand.
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_EDIT));
    ASSERT_EQ(SaveSlotRead(SaveSlotAutosavePath(), *document), SaveSlotState::Ready);
    ExpectSameTown(document->towns[1], first);
    ExpectSameTown(document->towns[3], second);
    SaveSlotNew = true;
    manager.SaveToMc(0);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    ASSERT_EQ(SaveSlotRead(SaveSlotPath(0), *document), SaveSlotState::Ready);
    ExpectSameTown(document->towns[1], first);
    ExpectSameTown(document->towns[3], second);
}

TEST_F(SaveSlotTest, AutosaveIsOneFileListedFirstForLoadingOnly) {
    Write(SaveSlotPath(0));
    live->map_no = 12;
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_EDIT));
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_EDIT));
    EXPECT_TRUE(fs::is_regular_file(SaveSlotAutosavePath()));
    EXPECT_EQ(FlatCount(), 1);

    manager.GetAllSaveFileInfo();
    ASSERT_EQ(SaveSlots.saves.size(), 2);
    EXPECT_TRUE(SaveSlots.saves[0].autosave);
    EXPECT_EQ(SaveSlots.saves[0].info.unique_counter, 3);
    EXPECT_EQ(manager.GetUpdateFile(), 0);
    live->map_no = 0;
    ASSERT_EQ(manager.LoadFromMc(0), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(live->map_no, 12);
    EXPECT_EQ(manager.load_program_loop_no, LOOP_EDIT);

    // A save made after the autosave is the newest.
    SaveSlotRefresh(manager, false);
    ASSERT_EQ(SaveSlots.saves.size(), 1);
    EXPECT_FALSE(SaveSlots.saves[0].autosave);
    SaveSlotNew = true;
    manager.SaveToMc(1);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    manager.GetAllSaveFileInfo();
    ASSERT_EQ(SaveSlots.saves.size(), 3);
    EXPECT_EQ(SaveSlots.saves[manager.GetUpdateFile()].number, 1);
}

TEST_F(SaveSlotTest, ManualSaveCannotOverwriteAnAutosaveRow) {
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_EDIT));
    const auto original = Bytes(SaveSlotAutosavePath());
    manager.GetAllSaveFileInfo();
    ASSERT_TRUE(SaveSlots.saves[0].autosave);
    manager.SaveToMc(0);
    EXPECT_EQ(manager.error.code, MC_ERROR_FILE);
    EXPECT_EQ(Bytes(SaveSlotAutosavePath()), original);
    EXPECT_EQ(FlatCount(), 0);
}

TEST_F(SaveSlotTest, TownAutosaveKeepsItsSpawnInsideTheSave) {
    live->map_no = 42;
    AutosaveSpawn spawn;
    spawn.map_no = 42;
    spawn.position[0] = 15.5f;
    spawn.camera_ref[2] = -8;
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_EDIT, &spawn));
    const auto original = Bytes(SaveSlotAutosavePath());
    const auto text = std::string(original.begin(), original.end());
    EXPECT_NE(text.find("\n  \"schema_version\": 1"), std::string::npos);
    EXPECT_NE(text.find("\"spawn\""), std::string::npos);
    ASSERT_EQ(SaveSlotRead(SaveSlotAutosavePath(), *document), SaveSlotState::Ready);
    ASSERT_TRUE(document->spawn);
    EXPECT_EQ(document->spawn->counter, document->image.unique_counter);
    EXPECT_EQ(document->spawn->map_no, 42);
    EXPECT_FLOAT_EQ(document->spawn->position[0], 15.5f);
    EXPECT_FLOAT_EQ(document->spawn->camera_ref[2], -8);
    EXPECT_FALSE(fs::exists(SaveSlotsRoot() / "autosave.spawn.1.json"));

    // A spot of another map, or with unusable coordinates, is dropped while the save still loads.
    spawn.map_no = 43;
    EXPECT_FALSE(SaveSlotWriteAutosave(LOOP_EDIT, &spawn));
    EXPECT_EQ(Bytes(SaveSlotAutosavePath()), original);
    auto       json = nlohmann::json::parse(text);
    const auto unusable = json;
    for (const auto &change : {nlohmann::json{{"position", {1, 2, 3}}}, nlohmann::json{{"position", {1e100, 0, 0, 0}}},
                               nlohmann::json{{"map_no", "ten"}}}) {
        json = unusable;
        json["pc"]["spawn"].update(change);
        json.erase("checksum");
        WriteText(SaveSlotAutosavePath(), json.dump(2));
        ASSERT_EQ(SaveSlotRead(SaveSlotAutosavePath(), *document), SaveSlotState::Ready) << change.dump();
        EXPECT_FALSE(document->spawn) << change.dump();
    }
}

TEST_F(SaveSlotTest, AutosaveSpawnIsConsumedOnceAfterLoadingTheAutosave) {
    live->map_no = 10;
    AutosaveSpawn first;
    first.map_no = 10;
    first.position[0] = 1;
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_EDIT, &first));
    AutosaveSpawn second = first;
    second.position[0] = 2;
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_EDIT, &second));
    manager.GetAllSaveFileInfo();
    manager.LoadFromMc(0);
    const auto pending = SaveSlotTakePendingSpawn(10);
    ASSERT_TRUE(pending);
    EXPECT_FLOAT_EQ(pending->position[0], 2);
    EXPECT_EQ(pending->counter, 2);
    EXPECT_FALSE(SaveSlotTakePendingSpawn(10));
    manager.LoadFromMc(0);
    manager.LoadFromMc(99);
    EXPECT_FALSE(SaveSlotTakePendingSpawn(10));
    Write(SaveSlotPath(0));
    manager.GetAllSaveFileInfo();
    manager.LoadFromMc(1);
    EXPECT_FALSE(SaveSlotTakePendingSpawn(10));
    // A dungeon autosave carries no spot.
    SaveSlotRecordFloorEntry();
    ASSERT_TRUE(SaveSlotWriteAutosave(LOOP_DUNGEON, &second));
    ASSERT_EQ(SaveSlotRead(SaveSlotAutosavePath(), *document), SaveSlotState::Ready);
    EXPECT_FALSE(document->spawn);
}

TEST_F(SaveSlotTest, FailedAutosavePayloadCannotApplyOrphanSpawn) {
    fs::create_directory(SaveSlotAutosavePath());
    AutosaveSpawn spawn;
    live->map_no = spawn.map_no = 10;
    EXPECT_FALSE(SaveSlotWriteAutosave(LOOP_EDIT, &spawn));
    EXPECT_TRUE(fs::is_directory(SaveSlotAutosavePath()));
    manager.GetAllSaveFileInfo();
    manager.LoadFromMc(0);
    EXPECT_EQ(manager.error.code, MC_ERROR_LOAD);
    EXPECT_FALSE(SaveSlotTakePendingSpawn(10));
}

TEST_F(SaveSlotTest, PendingSpawnIsDiscardedOnMapMismatchAndNewGame) {
    AutosaveSpawn spawn;
    spawn.counter = 1;
    spawn.map_no = 42;
    SaveSlotSetPendingSpawn(spawn);
    EXPECT_FALSE(SaveSlotTakePendingSpawn(43));
    EXPECT_FALSE(SaveSlotTakePendingSpawn(42));
    SaveSlotSetPendingSpawn(spawn);
    InitSaveData();
    EXPECT_FALSE(SaveSlotTakePendingSpawn(42));
}

TEST_F(SaveSlotTest, CounterExhaustionPreservesExistingSaves) {
    image->unique_counter = std::numeric_limits<u64>::max();
    Write(SaveSlotPath(0));
    const auto original = Bytes(SaveSlotPath(0));
    EXPECT_FALSE(SaveSlotWriteAutosave(LOOP_EDIT));
    manager.GetAllSaveFileInfo();
    manager.SaveToMc(0);
    EXPECT_EQ(manager.error.code, MC_ERROR_FILE);
    EXPECT_EQ(Bytes(SaveSlotPath(0)), original);
    EXPECT_FALSE(fs::exists(SaveSlotAutosavePath()));
}

TEST_F(SaveSlotTest, ArrivalAutosaveWaitsForControlAndEnabledConfigurationThenRunsOnce) {
    const bool old_enabled = PortAutosave;
    const int  old_capture = PortCaptureMode;
    const auto old_mode = DngStatus.mode;
    auto      *old_area = BattleAreaScene;
    const auto old_event = GetMainScene()->event_run;
    const auto old_lock = GamePad__2.key_lock;
    const auto old_config = ConfigGet();
    auto       area = std::make_unique<DNG_BATTLE_AREA>();

    struct Restore {
        std::function<void()> action;

        ~Restore() { action(); }
    } restore{[&] {
        PortAutosave = old_enabled;
        PortCaptureMode = old_capture;
        DngStatus.mode = old_mode;
        BattleAreaScene = old_area;
        GetMainScene()->event_run = old_event;
        GamePad__2.key_lock = old_lock;
        const auto bytes = ConfigSerialize(old_config);
        FilesWrite(root.parent_path() / "config.json", bytes.data(), bytes.size(), true);
        ConfigLoad();
        PortAutosaveResetArrival();
    }};

    auto configure = [&](bool enabled) {
        auto config = old_config;
        config.autosave = enabled;
        const auto bytes = ConfigSerialize(config);
        ASSERT_EQ(FilesWrite(root.parent_path() / "config.json", bytes.data(), bytes.size(), true), FilesResult::kWritten);
        ASSERT_TRUE(ConfigLoad());
    };
    PortAutosaveResetArrival();
    PortAutosave = true;
    PortCaptureMode = CAPTURE_OFF;
    BattleAreaScene = area.get();
    GamePad__2.key_lock = 0;
    GetMainScene()->event_run = false;
    live->save_dungeon.stage_id = 2;
    live->save_dungeon.floor_id[2] = 7;
    SaveSlotRecordFloorEntry();
    configure(true);
    for (auto mode : {DNG_STATUS_MENU, DNG_STATUS_EVENT, DNG_STATUS_EVENT_EDIT, DNG_STATUS_EVENT_MENU, DNG_STATUS_EXIT}) {
        DngStatus.mode = mode;
        PortAutosaveStep(LOOP_DUNGEON);
        EXPECT_FALSE(fs::exists(SaveSlotAutosavePath()));
    }
    DngStatus.mode = DNG_STATUS_FIELD;
    for (int flag : {DNG_PAUSE_PLAYER_STEP, DNG_PAUSE_FIELD_STEP}) {
        area->pause_flag = flag;
        PortAutosaveStep(LOOP_DUNGEON);
        EXPECT_FALSE(fs::exists(SaveSlotAutosavePath()));
    }
    area->pause_flag = 0;
    GamePad__2.key_lock = 1;
    PortAutosaveStep(LOOP_DUNGEON);
    GamePad__2.key_lock = 0;
    GetMainScene()->event_run = true;
    PortAutosaveStep(LOOP_DUNGEON);
    GetMainScene()->event_run = false;
    EXPECT_FALSE(fs::exists(SaveSlotAutosavePath()));
    EXPECT_TRUE(SaveSlotHasFloorEntry());
    PortAutosaveStep(LOOP_DUNGEON);
    EXPECT_EQ(Counter(SaveSlotAutosavePath()), 1);
    EXPECT_FALSE(SaveSlotHasFloorEntry());
    PortAutosaveStep(LOOP_DUNGEON);
    EXPECT_EQ(Counter(SaveSlotAutosavePath()), 1);
    // With autosave off at a floor's first controllable frame, the floor is passed over: its entry state lacks what
    // the player goes on to do there, so turning autosave on again does not write it.
    const std::vector<std::function<void(bool)> > switches = {
        [&](bool on) { PortCaptureMode = on ? CAPTURE_OFF : CAPTURE_OFF + 1; },
        [&](bool on) { PortAutosave = on; },
        [&](bool on) { configure(on); },
    };
    for (std::size_t i = 0; i < switches.size(); ++i) {
        live->save_dungeon.floor_id[2] = static_cast<s16>(20 + i);
        SaveSlotRecordFloorEntry();
        switches[i](false);
        PortAutosaveStep(LOOP_DUNGEON);
        EXPECT_FALSE(SaveSlotHasFloorEntry()) << i;
        switches[i](true);
        PortAutosaveStep(LOOP_DUNGEON);
        EXPECT_EQ(Counter(SaveSlotAutosavePath()), 1) << i;
    }
    // A floor reached without its load event's entry state is passed over, and stays passed over.
    live->save_dungeon.floor_id[2] = 8;
    PortAutosaveStep(LOOP_DUNGEON);
    EXPECT_EQ(Counter(SaveSlotAutosavePath()), 1);
    live->save_dungeon.floor_id[2] = 9;
    SaveSlotRecordFloorEntry();
    PortAutosaveStep(LOOP_DUNGEON);
    ASSERT_EQ(SaveSlotRead(SaveSlotAutosavePath(), *document), SaveSlotState::Ready);
    EXPECT_EQ(document->image.unique_counter, 2);
    EXPECT_EQ(document->image.floor_id, 9);
    // Entering a loop forgets both the arrival and the entry state.
    PortAutosaveResetArrival();
    PortAutosaveStep(LOOP_DUNGEON);
    EXPECT_EQ(Counter(SaveSlotAutosavePath()), 2);
    PortAutosaveResetArrival();
    SaveSlotRecordFloorEntry();
    PortAutosaveStep(LOOP_DUNGEON);
    EXPECT_EQ(Counter(SaveSlotAutosavePath()), 3);
}

TEST_F(SaveSlotTest, FishlessAutosaveCannotBypassFinnyFrenzyEligibility) {
    Write(SaveSlotAutosavePath());
    manager.GetAllSaveFileInfo();
    MenuRig rig;
    rig.menu.mode = SAVE_MENU_MODE_GYORACE_LOAD;
    rig.Idle();
    rig.Press(PAD_CROSS);
    EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_NOTICE);
    EXPECT_EQ(rig.message.mes_no, 0x13AA);
}

TEST_F(SaveSlotTest, EligibleAutosaveLoadsDirectlyFromFinnyFrenzyMenu) {
    image->fish_num = 1;
    Write(SaveSlotAutosavePath());
    manager.GetAllSaveFileInfo();
    MenuRig rig;
    rig.menu.mode = SAVE_MENU_MODE_GYORACE_LOAD;
    rig.Idle();
    rig.Press(PAD_CROSS);
    EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_LOADING);
}

TEST_F(SaveSlotTest, FailedLoadDoesNotPartiallyReplaceLiveStateOrDeleteFile) {
    Write(SaveSlotPath(0));
    Corrupt(SaveSlotPath(0));
    auto before = Bytes(SaveSlotPath(0));
    live->map_no = 42;
    live->play_time = 777;
    manager.GetAllSaveFileInfo();
    manager.LoadFromMc(0);
    EXPECT_EQ(manager.error.code, MC_ERROR_LOAD);
    EXPECT_EQ(live->map_no, 42);
    EXPECT_EQ(live->play_time, 777);
    EXPECT_EQ(Bytes(SaveSlotPath(0)), before);
}

TEST_F(SaveSlotTest, ConfirmedOverwritePublishesCompleteImageAndKeepsLegacyBackup) {
    Write(Legacy(0, 0));
    auto original = Bytes(Legacy(0, 0));
    manager.GetAllSaveFileInfo();
    live->map_no = 21;
    live->play_time = 9999;
    SetDngTreeFlag(1);
    SaveSlotNew = false; // The menu calls the writer only after its Yes confirmation.
    manager.SaveToMc(0);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    ASSERT_EQ(SaveSlotRead(SaveSlotPath(0), *document), SaveSlotState::Ready);
    EXPECT_EQ(document->image.save_data.map_no, 21);
    EXPECT_EQ(document->image.save_data.play_time, 9999);
    EXPECT_EQ(document->image.incomplete, 0);
    EXPECT_EQ(document->image.dng_tree_flag, 1);
    EXPECT_EQ(Bytes(Archived(0, 0)), original);
    int files = 0;
    for (const auto &entry : fs::directory_iterator(SaveSlotsRoot())) {
        EXPECT_FALSE(entry.path().string().ends_with(".tmp"));
        ++files;
    }
    EXPECT_EQ(files, 1);
}

TEST_F(SaveSlotTest, FailedPublicationPreservesOccupiedNameAndReportsError) {
    fs::create_directory(SaveSlotPath(0));
    std::ofstream(SaveSlotPath(0) / "keep.txt") << "keep";
    manager.GetAllSaveFileInfo();
    SaveSlotNew = false;
    manager.SaveToMc(0);
    EXPECT_EQ(manager.error.code, MC_ERROR_FILE);
    EXPECT_TRUE(fs::exists(SaveSlotPath(0) / "keep.txt"));
    EXPECT_TRUE(SaveSlotScan().saves.empty());
}

TEST_F(SaveSlotTest, InvalidCatalogRootReportsErrorAndRefusesNewSave) {
    fs::remove(root / "saves");
    std::ofstream(root / "saves") << "occupied";
    manager.GetAllSaveFileInfo();
    EXPECT_TRUE(SaveSlots.read_failed);
    EXPECT_EQ(SaveSlotFirstFree(SaveSlots), -1);
    EXPECT_EQ(SaveSlotRows(SaveSlots, true), 0);
    EXPECT_FALSE(SaveSlotIsNew(SaveSlots, 0, true));
    SaveSlotNew = true;
    manager.SaveToMc(0);
    EXPECT_EQ(manager.error.code, MC_ERROR_FILE);
    EXPECT_TRUE(fs::is_regular_file(root / "saves"));
}

TEST_F(SaveSlotTest, CorruptRowUsesRetailOverwriteConfirmationAndNoNeverWrites) {
    WriteText(SaveSlotPath(0), "corrupt");
    auto before = Bytes(SaveSlotPath(0));
    manager.GetAllSaveFileInfo();
    MenuRig rig;
    rig.Idle();
    rig.Press(PAD_CROSS);
    EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_CONFIRM_SAVE);
    EXPECT_EQ(rig.menu.save_kind, SAVE_FILE_OVERWRITE);
    EXPECT_EQ(rig.message.mes_no, 0xBC4);
    EXPECT_EQ(rig.message.GetMsgCursor(), 1);
    rig.Idle();
    rig.Press(PAD_CROSS);
    EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_SELECT);
    EXPECT_EQ(manager.GetFuncNo(), MC_FUNC_IDLE);
    EXPECT_EQ(Bytes(SaveSlotPath(0)), before);
}

TEST_F(SaveSlotTest, OverwriteRequiresYesAndRetainsConfirmationInputDelay) {
    Write(SaveSlotPath(0));
    manager.GetAllSaveFileInfo();
    MenuRig rig;
    rig.Idle();
    rig.Press(PAD_CROSS);
    rig.Idle();
    rig.Press(PAD_LEFT | PAD_CROSS);
    EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_CONFIRM_SAVE);
    EXPECT_EQ(rig.message.GetMsgCursor(), 0);
    EXPECT_EQ(manager.GetFuncNo(), MC_FUNC_IDLE);
    rig.Idle();
    rig.Press(PAD_CROSS);
    EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_SAVING);
    EXPECT_EQ(manager.GetFuncNo(), MC_FUNC_SAVE);
    EXPECT_FALSE(SaveSlotNew);
}

TEST_F(SaveSlotTest, MenuScrollsPastThirteenAndClampsItsVisibleWindow) {
    for (int i = 0; i < 31; ++i) {
        Write(SaveSlotPath(i));
    }
    manager.GetAllSaveFileInfo();
    MenuRig rig;
    rig.menu.select = 12;
    rig.menu.top = 10;
    rig.Idle();
    rig.Press(PAD_DOWN);
    EXPECT_EQ(rig.menu.select, 13);
    EXPECT_EQ(rig.menu.top, 11);
    rig.menu.select = 31;
    rig.menu.top = 31;
    rig.Press(PAD_DOWN);
    EXPECT_EQ(rig.menu.select, 31);
    EXPECT_EQ(rig.menu.top, 29);
    EXPECT_TRUE(SaveSlotIsNew(SaveSlots, rig.menu.select, true));
}

TEST_F(SaveSlotTest, DeletedImportsStayDeletedAcrossLaterScans) {
    Write(Legacy(0, 0));
    image->unique_counter = 2;
    Write(Legacy(1, 0));
    ASSERT_EQ(SaveSlotScan().saves.size(), 2);
    fs::remove(SaveSlotPath(0));
    fs::remove(SaveSlotPath(0, true));
    SaveSlots = {};
    EXPECT_TRUE(SaveSlotScan().saves.empty());
    EXPECT_TRUE(fs::exists(Archived(0, 0)));
    EXPECT_TRUE(fs::exists(Archived(1, 0)));
}

TEST_F(SaveSlotTest, IdenticalFlatSaveRetiresItsLegacyCopyBeforeManualDeletion) {
    Write(Legacy(0, 3));
    Write(SaveSlotPath(3));
    ASSERT_EQ(SaveSlotScan().saves.size(), 1);
    fs::remove(SaveSlotPath(3));
    EXPECT_TRUE(SaveSlotScan().saves.empty());
}

TEST_F(SaveSlotTest, ListingDefersChecksumValidationUntilLoad) {
    Write(SaveSlotPath(0));
    Corrupt(SaveSlotPath(0));
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 1);
    EXPECT_EQ(list.saves[0].state, SaveSlotState::Ready);
    EXPECT_EQ(list.saves[0].info.play_time, 123456);
    EXPECT_EQ(SaveSlotRead(SaveSlotPath(0), *document), SaveSlotState::BadChecksum);
}

TEST_F(SaveSlotTest, HeaderCacheUsesSizeAndTimeWhileLoadAlwaysRevalidates) {
    Write(SaveSlotPath(0));
    ASSERT_EQ(SaveSlotScan().saves.size(), 1);
    const auto  stamp = fs::last_write_time(SaveSlotPath(0));
    auto        bytes = Bytes(SaveSlotPath(0));
    std::string text(bytes.begin(), bytes.end());
    const auto  at = text.find("\"schema_version\": 1");
    ASSERT_NE(at, std::string::npos);
    text[at + std::strlen("\"schema_version\": ")] = '9';
    WriteText(SaveSlotPath(0), text);
    fs::last_write_time(SaveSlotPath(0), stamp);
    auto cached = SaveSlotScan();
    ASSERT_EQ(cached.saves.size(), 1);
    EXPECT_EQ(cached.saves[0].state, SaveSlotState::Ready);
    EXPECT_EQ(SaveSlotRead(SaveSlotPath(0), *document), SaveSlotState::WrongVersion);
    fs::last_write_time(SaveSlotPath(0), stamp + std::chrono::seconds(2));
    EXPECT_EQ(SaveSlotScan().saves[0].state, SaveSlotState::WrongVersion);
    WriteText(SaveSlotPath(0), "not a save");
    EXPECT_EQ(SaveSlotScan().saves[0].state, SaveSlotState::Invalid);
}

TEST_F(SaveSlotTest, UnreadableUnrelatedEntriesAreSkipped) {
    Write(SaveSlotPath(0));
    fs::create_directory(SaveSlotPath(1));
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 1);
    EXPECT_FALSE(list.read_failed);
    EXPECT_EQ(list.saves[0].number, 0);
}

TEST_F(SaveSlotTest, DurableSaveRemainsSuccessfulWhenPostWriteScanFails) {
    Write(SaveSlotPath(0));
    manager.GetAllSaveFileInfo();
    // The catalog was readable at selection; an unrelated legacy-card root
    // becomes unreadable before the confirmed overwrite is published.
    ASSERT_TRUE(fs::remove_all(root / "mc1"));
    std::ofstream(root / "mc1") << "occupied";
    live->map_no = 21;
    SaveSlotNew = false;
    ASSERT_EQ(manager.SaveToMc(0), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(manager.total_transferred, sizeof(SAVEDATA_FORMAT));
    EXPECT_TRUE(SaveSlots.read_failed);
    ASSERT_EQ(SaveSlotRead(SaveSlotPath(0), *document), SaveSlotState::Ready);
    EXPECT_EQ(document->image.save_data.map_no, 21);
}

TEST_F(SaveSlotTest, VersionTwoLoadsAndUsesRetailInventionConversion) {
    std::strcpy(image->version, "dc2Ver2");

    // Retail's old INVENT_CREATED_ITEM record is twelve bytes; conversion
    // copies the first two shorts of each of its 128 entries to four-byte cards.
    struct OldCard {
        short          item_id;
        unsigned short flags;
        unsigned char  unused[8];
    };

    static_assert(sizeof(OldCard) == 12);
    auto *source = image->save_data.GetUserDataManager()->GetInventUserData();
    for (int i = 0; i < 128; ++i) {
        const OldCard card{.item_id = static_cast<short>(i + 1), .flags = static_cast<unsigned short>(i + 100), .unused = {}};
        auto         *bytes = reinterpret_cast<char *>(source) + offsetof(CInventUserData, created_item);
        std::memcpy(bytes + i * sizeof(OldCard), &card, sizeof(card));
    }
    image->check_digit = image->check_digit_half = 999999; // Retail does not check Ver2 digits.
    Write(Legacy(0, 7));
    manager.GetAllSaveFileInfo();
    ASSERT_EQ(SaveSlots.saves.size(), 1);
    EXPECT_EQ(SaveSlots.saves[0].state, SaveSlotState::Ready);
    ASSERT_EQ(manager.LoadFromMc(0), MC_STEP_DONE);
    ASSERT_EQ(manager.error.code, MC_ERROR_NONE);
    auto *converted = live->GetUserDataManager()->GetInventUserData();
    for (int i = 0; i < 128; ++i) {
        EXPECT_EQ(converted->created_item[i].item_id, i + 1);
        EXPECT_EQ(converted->created_item[i].unk_2, i + 100);
    }
    EXPECT_EQ(live->map_no, 10);
}

TEST_F(SaveSlotTest, NewSaveAndFinnyPromptsUseRetailMessagesInEveryPalLanguage) {
    const char *data = std::getenv("DC2_DATA");
    if (!data) {
        GTEST_SKIP() << "DC2_DATA supplies the retail font table";
    }
    PathsSetDataRoot(data);
    LoadFontTblBin();
    image->fish_num = 5;
    Write(SaveSlotPath(7));
    manager.GetAllSaveFileInfo();
    for (int language = LANG_ENGLISH; language <= LANG_SPANISH; ++language) {
        {
            MenuRig rig;
            LanguageCode = language;
            rig.menu.select = 1;
            rig.Idle();
            rig.Press(PAD_CROSS);
            EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_CONFIRM_SAVE);
            EXPECT_EQ(rig.message.mes_no, 0xBC3);
            EXPECT_GT(rig.message.values[0], 0);
            EXPECT_EQ(rig.message.GetMsgCursor(), 1);
        }
        {
            MenuRig rig;
            LanguageCode = language;
            rig.menu.mode = SAVE_MENU_MODE_GYORACE_LOAD;
            rig.Idle();
            rig.Press(PAD_CROSS);
            EXPECT_EQ(rig.message.mes_no, 0x13A9);
            EXPECT_EQ(rig.message.values[0], 8);
            EXPECT_EQ(rig.message.values[1], 5);
        }
    }
}

TEST_F(SaveSlotTest, NoFishAndOperationFailuresUseRetailNotices) {
    const char *data = std::getenv("DC2_DATA");
    if (!data) {
        GTEST_SKIP() << "DC2_DATA supplies the retail font table";
    }
    PathsSetDataRoot(data);
    LoadFontTblBin();
    Write(SaveSlotPath(7));
    manager.GetAllSaveFileInfo();
    {
        MenuRig rig;
        rig.menu.mode = SAVE_MENU_MODE_GYORACE_LOAD;
        rig.Idle();
        rig.Press(PAD_CROSS);
        EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_NOTICE);
        EXPECT_EQ(rig.message.mes_no, 0x13AA);
        EXPECT_EQ(rig.message.values[0], 8);
    }
    for (bool writing : {true, false}) {
        MenuRig rig;
        rig.Idle();
        rig.menu.phase = writing ? SAVE_LIST_PHASE_SAVING : SAVE_LIST_PHASE_LOADING;
        manager.save_buffer = nullptr;
        manager.file_no = 99;
        manager.SetFuncNo(writing ? MC_FUNC_SAVE : MC_FUNC_LOAD);
        rig.menu.KeyStep();
        EXPECT_EQ(rig.menu.phase, SAVE_LIST_PHASE_NOTICE);
        EXPECT_EQ(rig.message.mes_no, writing ? 0xBC1 : 0xBC6);
    }
}

TEST_F(SaveSlotTest, FlatLegacyImagesConvertOnceAndMoveToTheArchive) {
    image->unique_counter = 5;
    Write(Raw(3));
    image->unique_counter = 6;
    Write(Raw(4, true));
    const auto original = Bytes(Raw(3));
    image->unique_counter = 7;
    Write(Raw(9));
    Write(SaveSlotPath(9)); // Already converted: the legacy image only moves.
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 3);
    EXPECT_EQ(Counter(SaveSlotPath(3)), 5);
    EXPECT_EQ(Counter(SaveSlotPath(4, true)), 6);
    EXPECT_EQ(Bytes(root / "imported" / "flat" / Raw(3).filename()), original);
    EXPECT_TRUE(fs::exists(root / "imported" / "flat" / Raw(4, true).filename()));
    EXPECT_TRUE(fs::exists(root / "imported" / "flat" / Raw(9).filename()));
    EXPECT_FALSE(fs::exists(Raw(3)));
    EXPECT_FALSE(fs::exists(Raw(9)));
    EXPECT_EQ(SaveSlotScan().saves.size(), 3);
    EXPECT_EQ(FlatCount(), 3);

    // The legacy autosave becomes the JSON autosave.
    image->unique_counter = 8;
    Write(SaveSlotsRoot() / "autosave");
    list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 4);
    EXPECT_TRUE(list.saves[0].autosave);
    EXPECT_EQ(list.saves[0].path, SaveSlotAutosavePath());
    EXPECT_EQ(Counter(SaveSlotAutosavePath()), 8);
    EXPECT_TRUE(fs::exists(root / "imported" / "flat" / "autosave"));
}

TEST_F(SaveSlotTest, CollisionAllocationReservesUnreadableNamesOnBothCards) {
    Write(SaveSlotPath(0));
    image->unique_counter = 2;
    Write(Legacy(0, 0));
    const auto original = Bytes(Legacy(0, 0));
    fs::create_directories(Legacy(0, 1).parent_path());
    fs::create_directories(Legacy(1, 2).parent_path());
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 2);
    EXPECT_EQ(Counter(SaveSlotPath(3)), 2);
    EXPECT_EQ(Bytes(Archived(0, 0)), original);
    EXPECT_EQ(SaveSlotFirstFree(list), 4);
    EXPECT_TRUE(fs::exists(Legacy(0, 1).parent_path()));
    EXPECT_TRUE(fs::exists(Legacy(1, 2).parent_path()));
}

TEST_F(SaveSlotTest, PublishedSaveInvalidatesHeaderEvenWithUnchangedTimestamp) {
    Write(SaveSlotPath(0));
    ASSERT_EQ(SaveSlotScan().saves[0].info.unique_counter, 1);
    const auto stamp = fs::last_write_time(SaveSlotPath(0));
    image->unique_counter = 99;
    image->save_data.play_time = 900;
    ASSERT_EQ(SaveSlotWrite(SaveSlotPath(0), Document(), true), FilesResult::kWritten);
    fs::last_write_time(SaveSlotPath(0), stamp);
    manager.GetAllSaveFileInfo();
    ASSERT_EQ(SaveSlots.saves.size(), 1);
    EXPECT_EQ(SaveSlots.saves[0].info.unique_counter, 99);
    EXPECT_EQ(SaveSlots.saves[0].info.play_time, 900);
    SaveSlotNew = false;
    live->play_time = 1000;
    ASSERT_EQ(manager.SaveToMc(0), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    EXPECT_EQ(SaveSlots.saves[0].info.unique_counter, 100);
    EXPECT_EQ(SaveSlots.saves[0].info.play_time, 1000);
}

TEST_F(SaveSlotTest, VersionTwoMetadataDoesNotUnlockOrSelectNewestBeforeConversion) {
    Write(SaveSlotPath(0));
    std::strcpy(image->version, "dc2Ver2");
    image->unique_counter = 9999;
    image->omake_flag = 0xff;
    image->costume_bit = 0xffff;
    image->debug_code = 42;
    Write(Raw(1));
    manager.GetAllSaveFileInfo();
    ASSERT_EQ(SaveSlots.saves.size(), 2);
    EXPECT_EQ(SaveSlots.saves[1].state, SaveSlotState::Ready);
    EXPECT_EQ(SaveSlots.saves[1].path, SaveSlotPath(1));
    EXPECT_EQ(SaveSlots.saves[1].info.unique_counter, 0);
    u_long costumes = 0;
    EXPECT_EQ(manager.CheckOmake(&costumes), 0);
    EXPECT_EQ(costumes, 0);
    EXPECT_EQ(manager.CheckDebugCode(), 0);
    EXPECT_EQ(manager.GetUpdateFile(), 0);
    EXPECT_EQ(manager.CheckMaxUniqueCounter(), 1);
    EXPECT_EQ(manager.LoadFromMc(1), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
}

TEST_F(SaveSlotTest, FirstFreeIsACatalogSnapshotRefreshedByScans) {
    auto list = SaveSlotScan();
    EXPECT_EQ(SaveSlotFirstFree(list), 0);
    Write(SaveSlotPath(0));
    EXPECT_EQ(SaveSlotFirstFree(list), 0);
    list = SaveSlotScan();
    EXPECT_EQ(SaveSlotFirstFree(list), 1);
    fs::remove(SaveSlotPath(0));
    EXPECT_EQ(SaveSlotFirstFree(list), 1);
    EXPECT_EQ(SaveSlotFirstFree(SaveSlotScan()), 0);
}

TEST_F(SaveSlotTest, LocalizedSavePromptsContainRetailText) {
    const char *data = std::getenv("DC2_DATA");
    if (!data) {
        GTEST_SKIP() << "DC2_DATA supplies localized menu folders and the font table";
    }
    PathsSetDataRoot(data);
    LoadFontTblBin();
    image->fish_num = 5;
    Write(SaveSlotPath(7));
    manager.GetAllSaveFileInfo();
    for (int language : {LANG_ENGLISH, LANG_SPANISH}) {
        auto message_data = SaveMessages(language);
        ASSERT_FALSE(message_data.empty());
        auto *messages = reinterpret_cast<short *>(message_data.data());
        for (bool finny : {false, true}) {
            MenuRig rig;
            LanguageCode = language;
            rig.message.SetMessData(messages, messages);
            rig.menu.mode = finny ? SAVE_MENU_MODE_GYORACE_LOAD : SAVE_MENU_MODE_SAVE;
            rig.menu.select = finny ? 0 : 1;
            rig.Idle();
            rig.Press(PAD_CROSS);
            rig.message.StepMsg();
            const auto  text = MessageText(rig.message);
            const char *expected = nullptr;
            if (language == LANG_ENGLISH) {
                expected = finny ? "File 8 has data for 5 fish.\nLoad fish data from file 8?"
                                 : "At least 415KB is necessary\nfor a new file.\nOK to save?";
            } else {
                expected = finny ? "El archivo 8 tiene datos de 5 peces.\nCargar los datos de peces del archivo 8?"
                                 : "Necesitas al menos 415 KB \npara guardar datos.\nGuardar?";
            }
            EXPECT_EQ(text, expected);
        }
    }
}

TEST_F(SaveSlotTest, ExistingMarkersAreIgnoredAndLeftUntouched) {
    std::vector<std::vector<char> > originals;
    for (int card : {0, 1}) {
        Write(Legacy(card, 0));
        originals.push_back(Bytes(Legacy(card, 0)));
        const auto marker = root / ".save-imports" / Legacy(card, 0).filename();
        fs::create_directories(marker.parent_path());
        std::ofstream(marker) << "imported\n";
    }
    const auto marker0 = Bytes(root / ".save-imports" / Legacy(0, 0).filename());
    ASSERT_EQ(SaveSlotScan().saves.size(), 1); // The same save on both cards shares one converted copy.
    EXPECT_EQ(Counter(SaveSlotPath(0)), 1);
    EXPECT_EQ(Bytes(Archived(0, 0)), originals[0]);
    EXPECT_EQ(Bytes(Archived(1, 0)), originals[1]);
    EXPECT_EQ(Bytes(root / ".save-imports" / Legacy(0, 0).filename()), marker0);
}

TEST_F(SaveSlotTest, IdenticalPayloadAtAnotherNumberOrCardNeedsNoNewCopy) {
    Write(SaveSlotPath(7, true));
    const auto converted = Bytes(SaveSlotPath(7, true));
    Write(Legacy(0, 0));
    const auto original = Bytes(Legacy(0, 0));
    Write(Legacy(1, 3));
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 1);
    EXPECT_EQ(list.saves[0].path, SaveSlotPath(7, true));
    EXPECT_EQ(Bytes(SaveSlotPath(7, true)), converted);
    EXPECT_EQ(Bytes(Archived(0, 0)), original);
    EXPECT_EQ(Bytes(Archived(1, 3)), original);
    EXPECT_FALSE(fs::exists(SaveSlotPath(0)));
    EXPECT_FALSE(fs::exists(SaveSlotPath(3, true)));
}

TEST_F(SaveSlotTest, OccupiedArchiveNamesAreNeverReplaced) {
    Write(Archived(0, 0));
    const auto previous = Bytes(Archived(0, 0));
    image->unique_counter = 42;
    Write(Legacy(0, 0));
    const auto original = Bytes(Legacy(0, 0));
    ASSERT_EQ(SaveSlotScan().saves.size(), 1);
    const auto alternate = Archived(0, 0).parent_path().string() + ".1";
    EXPECT_EQ(Bytes(Archived(0, 0)), previous);
    EXPECT_EQ(Bytes(fs::path(alternate) / Legacy(0, 0).filename()), original);
    EXPECT_EQ(Counter(SaveSlotPath(0)), 42);
    EXPECT_FALSE(fs::exists(Legacy(0, 0).parent_path()));
}

TEST_F(SaveSlotTest, UnwritableFlatDirectoryKeepsOnlyTheOriginalReadableRow) {
    Write(Legacy(0, 3));
    const auto original = Bytes(Legacy(0, 3));
    fs::remove(root / "saves");
    std::ofstream(root / "saves") << "blocked";
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 1);
    EXPECT_EQ(list.saves[0].path, Legacy(0, 3));
    EXPECT_TRUE(list.read_failed);
    EXPECT_EQ(SaveSlotWrite(list.saves[0], Document()), FilesResult::kFailed);
    EXPECT_EQ(Bytes(Legacy(0, 3)), original);
    EXPECT_FALSE(fs::exists(root / "imported"));
    fs::remove(root / "saves");
    fs::create_directory(root / "saves");
    SaveSlots = {};
    ASSERT_EQ(SaveSlotScan().saves.size(), 1);
    EXPECT_EQ(Bytes(Archived(0, 3)), original);
}

TEST_P(SaveSlotImportTest, ArchiveMoveFailureRescansConvergeWithoutExtraCopies) {
    const auto [card, collision] = GetParam();
    fs::remove_all(root);
    fs::create_directories(root / "saves");
    image->unique_counter = 1;
    if (collision) {
        Write(SaveSlotPath(0, card != 0));
    }
    image->unique_counter = 42;
    Write(Legacy(card, 0));
    const auto original = Bytes(Legacy(card, 0));
    int        publications = 0;
    SaveSlotSetImportHook([&](auto stage, const auto &, const auto &) {
        publications += stage == SaveSlotImportStage::Published;
        return stage != SaveSlotImportStage::BeforeArchive;
    });
    const auto flat = SaveSlotPath(collision ? 1 : 0, card != 0);
    for (int scan = 0; scan < 3; ++scan) {
        SaveSlots = {};
        SaveSlotSetPendingSpawn(std::nullopt); // No retained import association or menu state.
        manager.InitForMC();
        auto list = SaveSlotScan();
        ASSERT_EQ(list.saves.size(), collision ? 3 : 2);
        EXPECT_EQ(Counter(flat), 42);
        EXPECT_EQ(Bytes(Legacy(card, 0)), original);
        EXPECT_EQ(list.saves.back().path, Legacy(card, 0));
        EXPECT_EQ(SaveSlotRead(list.saves.back().path, *document), SaveSlotState::Ready);
    }
    EXPECT_EQ(publications, 1);
    SaveSlotSetImportHook({});
    SaveSlots = {};
    ASSERT_EQ(SaveSlotScan().saves.size(), collision ? 2 : 1);
    EXPECT_EQ(Bytes(Archived(card, 0)), original);
    EXPECT_FALSE(fs::exists(Legacy(card, 0).parent_path()));
    fs::remove(flat); // User deletion cannot re-import an archived entry.
    EXPECT_EQ(SaveSlotScan().saves.size(), collision ? 1 : 0);
}

TEST_F(SaveSlotTest, PublishedCopySurvivesReportedSyncFailureAndRecovery) {
    Write(Legacy(0, 0));
    const auto original = Bytes(Legacy(0, 0));
    SaveSlotSetImportHook([](auto stage, const auto &, const auto &) {
        return stage != SaveSlotImportStage::Published;
    });
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 2);
    EXPECT_EQ(Counter(SaveSlotPath(0)), 1);
    EXPECT_EQ(Bytes(Legacy(0, 0)), original);
    EXPECT_FALSE(fs::exists(root / "imported"));
    SaveSlotSetImportHook({});
    SaveSlots = {};
    ASSERT_EQ(SaveSlotScan().saves.size(), 1);
    EXPECT_EQ(Bytes(Archived(0, 0)), original);
    EXPECT_FALSE(fs::exists(SaveSlotPath(1)));
}

TEST_F(SaveSlotTest, CompetitorReplacingPublishedCopyCannotLoseOriginal) {
    Write(Legacy(1, 0));
    const auto original = Bytes(Legacy(1, 0));
    image->unique_counter = 99;
    fs::path          flat;
    std::vector<char> competing;
    SaveSlotSetImportHook([&](auto stage, const auto &, const auto &to) {
        if (stage == SaveSlotImportStage::Published) {
            flat = to;
        } else if (stage == SaveSlotImportStage::BeforeArchive) {
            const auto text = SaveJsonWrite(Document());
            EXPECT_EQ(FilesWrite(flat, text.data(), text.size(), true), FilesResult::kWritten);
            competing = Bytes(flat);
        }
        return true;
    });
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 1);
    EXPECT_EQ(Bytes(flat), competing);
    EXPECT_EQ(Counter(flat), 99);
    EXPECT_EQ(Bytes(Archived(1, 0)), original);
    SaveSlotSetImportHook({});
    EXPECT_EQ(SaveSlotScan().saves.size(), 1);
}

TEST_F(SaveSlotTest, ArchivePublicationRemainsConsistentAfterReportedSyncFailure) {
    Write(Legacy(0, 3));
    const auto original = Bytes(Legacy(0, 3));
    SaveSlotSetImportHook([](auto stage, const auto &, const auto &) {
        return stage != SaveSlotImportStage::Archived;
    });
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 1);
    EXPECT_EQ(list.saves[0].path, SaveSlotPath(3));
    EXPECT_FALSE(fs::exists(Legacy(0, 3).parent_path()));
    EXPECT_EQ(Bytes(Archived(0, 3)), original);
    const auto converted = Bytes(SaveSlotPath(3));
    SaveSlotSetImportHook({});
    SaveSlots = {};
    EXPECT_EQ(SaveSlotScan().saves.size(), 1);
    EXPECT_EQ(Bytes(SaveSlotPath(3)), converted);
}

TEST_F(SaveSlotTest, ConcurrentArchiveNamePublicationIsPreserved) {
    Write(Legacy(0, 0));
    const auto original = Bytes(Legacy(0, 0));
    bool       competed = false;
    SaveSlotSetImportHook([&](auto stage, const auto &, const auto &to) {
        if (stage == SaveSlotImportStage::BeforeArchive && !competed) {
            fs::create_directory(to);
            std::ofstream(to / "keep") << "competing archive";
            competed = true;
        }
        return true;
    });
    ASSERT_EQ(SaveSlotScan().saves.size(), 1);
    const auto first = Archived(0, 0).parent_path();
    EXPECT_EQ(Bytes(first / "keep"), std::vector<char>({'c', 'o', 'm', 'p', 'e', 't', 'i', 'n', 'g', ' ', 'a', 'r', 'c', 'h', 'i', 'v', 'e'}));
    EXPECT_EQ(Bytes(fs::path(first.string() + ".1") / Legacy(0, 0).filename()), original);
}

TEST_F(SaveSlotTest, UnreadableLegacyPayloadsRemainReservedAndAreNotArchived) {
    for (int card : {0, 1}) {
        fs::create_directories(Legacy(card, card));
    }
    auto list = SaveSlotScan();
    EXPECT_TRUE(list.saves.empty());
    EXPECT_EQ(list.first_free, 2);
    EXPECT_TRUE(fs::exists(Legacy(0, 0)));
    EXPECT_TRUE(fs::exists(Legacy(1, 1)));
    EXPECT_FALSE(fs::exists(root / "imported"));
    EXPECT_TRUE(fs::is_empty(root / "saves"));
}

TEST_F(SaveSlotTest, StillListedLegacyReplacementKeepsNewSaveWhenArchiveFails) {
    Write(Legacy(1, 0));
    const auto original = Bytes(Legacy(1, 0));
    std::ofstream(root / "imported") << "blocked";
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 2);
    ASSERT_EQ(list.saves.back().path, Legacy(1, 0));
    const auto selected = list.saves.back();
    image->unique_counter = 99;
    EXPECT_EQ(SaveSlotWrite(selected, Document()), FilesResult::kWritten);
    const auto replacement = SaveSlotPath(selected.number, true);
    EXPECT_EQ(Counter(replacement), 99);
    EXPECT_EQ(Bytes(Legacy(1, 0)), original);
    EXPECT_EQ(SaveSlotScan().saves.size(), 3);
    EXPECT_EQ(SaveSlotScan().saves.size(), 3);
    // Ordinary flat replacements and unrelated new saves remain available.
    image->unique_counter = 100;
    EXPECT_EQ(SaveSlotWrite(list.saves.front(), Document()), FilesResult::kWritten);
    image->unique_counter = 101;
    manager.GetAllSaveFileInfo();
    SaveSlotNew = true;
    EXPECT_EQ(manager.SaveToMc(0), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    fs::remove(root / "imported");
    SaveSlots = {};
    manager.InitForMC();
    auto recovered = SaveSlotScan();
    EXPECT_EQ(recovered.saves.size(), 4);
    EXPECT_EQ(Bytes(Archived(1, 0)), original);
    EXPECT_FALSE(fs::exists(Legacy(1, 0).parent_path()));
    EXPECT_EQ(Counter(replacement), 99);
}

TEST_F(SaveSlotTest, LegacyReplacementNeverRemovesCompetitorPublishedAfterSelection) {
    Write(Legacy(1, 0));
    const auto original = Bytes(Legacy(1, 0));
    std::ofstream(root / "imported") << "blocked";
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 2);
    const auto selected = list.saves.back();
    image->unique_counter = 99;
    const auto target = SaveSlotPath(selected.number, true);
    Write(target);
    const auto competing = Bytes(target);
    EXPECT_EQ(SaveSlotWrite(selected, Document()), FilesResult::kExists);
    EXPECT_EQ(Bytes(target), competing);
    EXPECT_EQ(Bytes(Legacy(1, 0)), original);
    EXPECT_EQ(Bytes(root / "imported"), std::vector<char>({'b', 'l', 'o', 'c', 'k', 'e', 'd'}));
}

TEST_F(SaveSlotTest, UnavailableSourceAfterFailedMoveCannotTriggerAnotherCopy) {
    Write(Legacy(0, 0));
    const auto original = Bytes(Legacy(0, 0));
    SaveSlotSetImportHook([](auto stage, const auto &, const auto &) {
        return stage != SaveSlotImportStage::BeforeArchive;
    });
    ASSERT_EQ(SaveSlotScan().saves.size(), 2);
    const auto converted = Bytes(SaveSlotPath(0));
    const auto hidden = root / "unavailable";
    fs::rename(Legacy(0, 0), hidden);
    SaveSlots = {};
    auto list = SaveSlotScan();
    ASSERT_EQ(list.saves.size(), 1);
    EXPECT_TRUE(list.occupied.contains(0));
    EXPECT_EQ(Bytes(SaveSlotPath(0)), converted);
    EXPECT_FALSE(fs::exists(SaveSlotPath(1)));
    fs::rename(hidden, Legacy(0, 0));
    SaveSlotSetImportHook({});
    ASSERT_EQ(SaveSlotScan().saves.size(), 1);
    EXPECT_EQ(Bytes(Archived(0, 0)), original);
    EXPECT_FALSE(fs::exists(SaveSlotPath(1)));
}

TEST_F(SaveSlotTest, RecoveryUsesOnlyPublishedFilesInFreshProcess) {
    constexpr auto variable = "DC2_IMPORT_RECOVERY_ROOT";
    auto *const    inherited = std::getenv(variable);
    const auto     recovery = inherited ? fs::path(inherited) : root;
    if (!inherited) {
        Write(Legacy(1, 0));
        SaveSlotSetImportHook([](auto stage, const auto &, const auto &) {
            return stage != SaveSlotImportStage::BeforeArchive;
        });
        ASSERT_EQ(SaveSlotScan().saves.size(), 2);
#ifdef _WIN32
        ASSERT_EQ(_putenv_s(variable, recovery.string().c_str()), 0);
#else
        ASSERT_EQ(setenv(variable, recovery.c_str(), 1), 0);
#endif
    }
    EXPECT_EXIT(([&] {
                    PathsSetSaveRoot(recovery);
                    SaveSlots = {};
                    SaveSlotSetPendingSpawn(std::nullopt);
                    SaveSlotSetImportHook({});
                    const auto name = SaveSlotPath(0).filename().replace_extension();
                    const auto source = recovery / "mc1" / name / name;
                    const auto original = Bytes(source);
                    const auto list = SaveSlotScan();
                    const auto archive = recovery / "imported" / "mc1" / source.parent_path().filename() / source.filename();
                    const bool recovered = list.saves.size() == 1 && !original.empty() &&
                                           Bytes(archive) == original && Counter(SaveSlotPath(0, true)) == 1 &&
                                           !fs::exists(source.parent_path()) && !fs::exists(SaveSlotPath(1, true));
                    if (root != recovery) {
                        fs::remove_all(root);
                    }
                    std::exit(recovered ? 0 : 1);
                }()),
                testing::ExitedWithCode(0), "");
#ifdef _WIN32
    EXPECT_EQ(_putenv_s(variable, ""), 0);
#else
    EXPECT_EQ(unsetenv(variable), 0);
#endif
    EXPECT_EQ(Counter(Archived(1, 0)), Counter(SaveSlotPath(0, true)));
}

TEST_P(SaveSlotImportTest, OverwriteBetweenUnavailableSourceRescansPreservesNewProgressAndBoundsPublication) {
    const auto [card, collision] = GetParam();
    fs::remove_all(root);
    fs::create_directories(SaveSlotsRoot());
    image->unique_counter = 1;
    if (collision) {
        Write(SaveSlotPath(0, card != 0));
    }
    image->unique_counter = 42;
    Write(Legacy(card, 0));
    const auto original = Bytes(Legacy(card, 0));
    std::ofstream(root / "imported") << "blocked";
    ASSERT_EQ(SaveSlotScan().saves.size(), collision ? 3 : 2);
    const auto flat = SaveSlotPath(collision ? 1 : 0, card != 0);
    const auto hidden = root / "unavailable";
    fs::rename(Legacy(card, 0), hidden);
    SaveSlots = {};
    const auto unavailable = SaveSlotScan();
    const auto selected = std::ranges::find_if(unavailable.saves, [&](const auto &slot) { return slot.path == flat; });
    ASSERT_NE(selected, unavailable.saves.end());
    image->unique_counter = 99;
    ASSERT_EQ(SaveSlotWrite(*selected, Document()), FilesResult::kWritten);
    const auto newer = Bytes(flat);
    const auto initial_count = FlatCount();
    for (int scan = 0; scan < 3; ++scan) {
        SaveSlots = {};
        SaveSlotSetPendingSpawn(std::nullopt);
        EXPECT_EQ(SaveSlotScan().saves.size(), initial_count);
        EXPECT_EQ(FlatCount(), initial_count);
        EXPECT_EQ(Bytes(flat), newer);
    }
    fs::rename(hidden, Legacy(card, 0));
    int      publications = 0;
    fs::path republished;
    SaveSlotSetImportHook([&](auto stage, const auto &, const auto &to) {
        if (stage == SaveSlotImportStage::Published) {
            ++publications;
            republished = to;
        }
        return true;
    });
    for (int scan = 0; scan < 4; ++scan) {
        SaveSlots = {};
        SaveSlotSetPendingSpawn(std::nullopt);
        EXPECT_EQ(SaveSlotScan().saves.size(), initial_count + 2);
        EXPECT_EQ(FlatCount(), initial_count + 1);
        EXPECT_EQ(Bytes(flat), newer);
        EXPECT_EQ(Bytes(Legacy(card, 0)), original);
    }
    EXPECT_EQ(publications, 1);
    EXPECT_EQ(Counter(republished), 42);
    fs::remove(root / "imported");
    SaveSlots = {};
    EXPECT_EQ(SaveSlotScan().saves.size(), initial_count + 1);
    EXPECT_EQ(FlatCount(), initial_count + 1);
    EXPECT_EQ(publications, 1);
    EXPECT_EQ(Bytes(flat), newer);
    EXPECT_EQ(Bytes(Archived(card, 0)), original);
    SaveSlotSetImportHook({});
}

TEST_F(SaveSlotTest, SaveAdoptionDiscardsPlayTimeFraction) {
    const auto old_rate = ClockTickRate();
    const auto old_flag = PortPlayTimeCountFlag;
    ClockSetTickRate(60);
    PortPlayTimeCountFlag = true;
    PlayTimeReset();
    PortPlayTimeVSyncCallback(0);
    Write(SaveSlotPath(0));
    manager.GetAllSaveFileInfo();
    EXPECT_EQ(manager.LoadFromMc(0), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_NONE);
    PortPlayTimeVSyncCallback(0);
    EXPECT_EQ(live->play_time, image->save_data.play_time);
    for (int tick = 0; tick < 5; ++tick) {
        PortPlayTimeVSyncCallback(0);
    }
    EXPECT_EQ(live->play_time, image->save_data.play_time + 5);
    PlayTimeReset();
    PortPlayTimeCountFlag = old_flag;
    ClockSetTickRate(old_rate);
}

TEST_F(SaveSlotTest, FailedSaveAdoptionKeepsPlayTimeFraction) {
    const auto old_rate = ClockTickRate();
    const auto old_flag = PortPlayTimeCountFlag;
    ClockSetTickRate(60);
    PortPlayTimeCountFlag = true;
    PlayTimeReset();
    live->play_time = 0;
    PortPlayTimeVSyncCallback(0);
    EXPECT_EQ(manager.LoadFromMc(-1), MC_STEP_DONE);
    EXPECT_EQ(manager.error.code, MC_ERROR_LOAD);
    for (int tick = 0; tick < 5; ++tick) {
        PortPlayTimeVSyncCallback(0);
    }
    EXPECT_EQ(live->play_time, 5);
    PlayTimeReset();
    PortPlayTimeCountFlag = old_flag;
    ClockSetTickRate(old_rate);
}
