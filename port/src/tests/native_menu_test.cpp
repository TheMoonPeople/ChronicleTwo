#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "platform/datapacks.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Serves native menu documents to MenuDataAnalyze and MenuCommandAnalyze through registered script buffers.
 */
class NativeMenu : public testing::Test {
protected:
    std::filesystem::path                     directory;                 /**< Temporary native data directory. */
    std::filesystem::path                     previous_root;             /**< Datapack root restored after the fixture. */
    std::vector<u_long128>                    storage;                   /**< Backing storage of the layout memory. */
    mgCMemory                                 memory;                    /**< Memory the layouts allocate from. */
    std::unique_ptr<CMenuPosDataManage>       positions;                 /**< Position manager the layouts fill. */
    std::unique_ptr<CMenuKeyFunc>             keys;                      /**< Menu state holding the texture blocks. */
    CMenuPosDataManage                       *saved_positions = nullptr; /**< Position manager restored afterwards. */
    CMenuKeyFunc                             *saved_keys = nullptr;      /**< Menu state restored afterwards. */
    std::vector<std::unique_ptr<std::string>> buffers;                   /**< Script buffers registered as loaded files. */

    void SetUp() override {
        previous_root = datapacks::Root();
        directory = std::filesystem::temp_directory_path() / ("chronicle_native_menu_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        std::filesystem::create_directories(directory / "data/menu/fixture.pac");
        std::filesystem::create_directories(directory / "data");
        DataReadIndex(directory / "data");
        storage.resize(16384);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        positions = std::make_unique<CMenuPosDataManage>();
        positions->Initialize();
        keys = std::make_unique<CMenuKeyFunc>();
        for (int index = 0; index < 16; ++index) {
            keys->tex_block[index] = 20 + index;
        }
        saved_positions = MenuPosData;
        saved_keys = MenuCommonInfo;
        MenuPosData = positions.get();
        MenuCommonInfo = keys.get();
    }

    void TearDown() override {
        for (const auto &buffer : buffers) {
            TextureSourceForget(buffer->data());
            DataReadRegisterBuffer(buffer->data(), 0);
        }
        MenuPosData = saved_positions;
        MenuCommonInfo = saved_keys;
        if (previous_root.empty()) {
            DataReadIndex(directory / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous_root.parent_path() / "data");
        }
        std::filesystem::remove_all(directory);
    }

    /**
     * Writes a native document and returns a buffer registered as the loaded file it came from.
     */
    std::string &Load(const std::string &name, const std::string &kind, const Json &body) {
        Json document = body;
        document["schema_version"] = 2;
        document["kind"] = kind;
        const auto text = document.dump(2);
        std::ofstream(directory / "data/menu/fixture.pac" / name, std::ios::binary) << text;
        buffers.push_back(std::make_unique<std::string>(text));
        DataReadRegisterAsset(buffers.back()->data(), "menu/fixture.pac/" + name, text.size());
        return *buffers.back();
    }

    /**
     * Runs a layout document through MenuDataAnalyze.
     */
    void Layout(const std::string &name, const Json &operations) {
        auto &buffer = Load(name, "menu_layout", {
                                                     {"operations", operations}
        });
        EXPECT_EQ(MenuDataAnalyze(buffer.data(), static_cast<int>(buffer.size()), &memory), 1);
    }
};

/**
 * Base tables and one form that later documents build on.
 */
Json BaseOperations() {
    return Json::array({
        {{"op", "allocate_etc_info"}, {"count", 8}},
        {{"op", "allocate_etc_info2"}},
        {{"op", "allocate_textures"}, {"count", 16}},
        {{"op", "allocate_forms"}, {"count", 4}},
        {{"op", "clear_textures"}, {"from", 0}, {"to", 255}},
        {{"op", "etc_info_offset"}, {"index", 2}},
        {{"op", "etc_info"}, {"entries", Json::array({{{"name", "left"}, {"values", {-260, 0}}}, {{"name", "right"}, {"values", {670, 1}}}})}},
        {{"op", "etc_info2_offset"}, {"index", 0}},
        {{"op", "etc_info2"}, {"entries", Json::array({{{"name", "scale"}, {"values", {1.5, 2.0, 3.0, 4.0}}}})}},
        {{"op", "texture_offset"}, {"index", 0}},
        {{"op", "texture_sheet"}, {"sheet", "mnmain"}, {"block_slot", 1}, {"textures", Json::array({{{"name", "plate"}, {"rect", {0, 64, 126, 32}}}, {{"name", "num"}, {"rect", {0, 244, 10, 13}}}})}},
        // Name lookups walk the draw list from slot 0, which a retail layout always names.
        {{"op", "form_offset"}, {"index", 0}},
        {{"op", "form"}, {"name", "top"}, {"settings", Json::array()}, {"parts", Json::array()}},
        {{"op", "form_offset"}, {"index", 1}},
        {{"op", "form"},
         {"name", "board"},
         {"settings",
          Json::array({{{"set", "parts_capacity"}, {"count", 4}},
                       {{"set", "draw_flag"}, {"draw", 0}},
                       {{"set", "position"}, {"xy", {600, 14}}},
                       {{"set", "rgba"}, {"rgba", {10, 20, 30}}},
                       {{"set", "rgba_bits"}, {"channels", "ra"}},
                       {{"set", "move_type"}, {"type", "i"}},
                       {{"set", "actions"}, {"capacity", 2}, {"actions", Json::array({{{"name", "in"}, {"move_type", 2}, {"xy", {222.0, 10.0}}, {"rate", {5.0, 1.1}}}})}},
                       {{"set", "clip"}, {"size", {100, 50}}}})},
         {"parts",
          Json::array({{{"part", "normal"}, {"texture", "plate"}, {"name", "plate"}, {"xy", {-16, 0}}, {"modifiers", Json::array({{{"mod", "shadow"}}, {{"mod", "bilinear"}}, {{"mod", "etc_info"}, {"entries", Json::array({{{"index", 1}, {"value", 7}}, {{"index", 9}, {"value", 8}}})}}})}},
                       {{"part", "number1"}, {"texture", "num"}, {"name", "days"}, {"value", 3}, {"xy", {92, 3}}, {"size", {-3, 0}}, {"modifiers", Json::array({{{"mod", "shadow"}, {"on", 1}, {"offset", 2}}, {{"mod", "effect_capacity"}, {"count", 1}}, {{"mod", "effect"}, {"type", "blink"}, {"params", {1, 2, 3}}}, {{"mod", "effect"}, {"type", "rot"}, {"params", {9}}}})}},
                       {{"part", "fillbox"}, {"kind", "sq_beta"}, {"name", "fill"}, {"xy", {0, 0}}, {"size", {512, 480}}, {"style", 1}, {"modifiers", Json::array({{{"mod", "fill"}, {"rgba", {40, 29, 42, 128}}}, {{"mod", "fill"}, {"rgba", {1, 2, 3, 4}}}, {{"mod", "fill"}, {"rgba", {5, 6, 7, 8}}}})}}})}},
        // As every retail layout does, the base links its forms into the draw list that name lookups walk.
        {{"op", "init_drawlist"}},
    });
}

TEST_F(NativeMenu, LayoutFillsTablesAtTheirCursors) {
    Layout("base.cfg.json", BaseOperations());

    ASSERT_EQ(MenuPosData->etc_tbl_num, 8);
    EXPECT_EQ(MenuPosData->etc_tbl2_num, 96);
    EXPECT_EQ(MenuPosData->etc_tbl[0].name, nullptr);
    ASSERT_NE(MenuPosData->etc_tbl[3].name, nullptr);
    EXPECT_STREQ(MenuPosData->etc_tbl[3].name, "right");
    EXPECT_EQ(MenuPosData->etc_tbl[3].value[0], 670);
    EXPECT_FLOAT_EQ(MenuPosData->etc_tbl2[0].value[3], 4.0f);

    MENU_BASETEXINFO *num = MenuPosData->GetTexGetInfo(1);
    ASSERT_NE(num, nullptr);
    EXPECT_STREQ(num->name, "num");
    EXPECT_STREQ(num->tex_name, "mnmain");
    EXPECT_EQ(num->tex_block, 21);
    EXPECT_EQ(num->rect.bottom, 13);

    CMenuPosDataForm *board = MenuPosData->GetFormInfo(1);
    ASSERT_NE(board, nullptr);
    EXPECT_STREQ(board->name, "board");
    EXPECT_EQ(board->draw_flag, 0);
    EXPECT_EQ(board->x, 600.0f);
    EXPECT_EQ(board->rgba[3], 0x80);
    EXPECT_EQ(board->rgba_bit, MENUFORM_RGBA_BIT_RED | MENUFORM_RGBA_BIT_ALPHA);
    EXPECT_EQ(board->mtype, MENUFORM_MTYPE_I);
    EXPECT_EQ(board->action_num, 2);
    EXPECT_STREQ(board->action[0].name, "in");
    EXPECT_FLOAT_EQ(board->action[0].move->rate_y, 1.1f);
    EXPECT_EQ(board->clip_h, 50);

    const MENUFORMPARTS_TYPE &plate = board->parts[0];
    EXPECT_EQ(plate.dtype, MENUFORMPARTS_DTYPE_NORMAL);
    EXPECT_EQ(plate.w, 126.0f);
    EXPECT_EQ(plate.shadow, 1);
    EXPECT_EQ(plate.shadow_offset, 4);
    EXPECT_EQ(plate.bilinear & 1, 1);
    EXPECT_EQ(plate.etc_info[1], 7);

    const MENUFORMPARTS_TYPE &days = board->parts[1];
    EXPECT_EQ(days.etc_info[0], 3);
    EXPECT_EQ(days.shadow_offset, 2);
    ASSERT_EQ(days.effect_num, 1);
    EXPECT_EQ(days.effect[0].type, MENU_PARTS_EFFECT_BLINK);
    EXPECT_FLOAT_EQ(days.effect[0].param[2], 3.0f);

    // Style 1 allocates two fill records; a third fill has no record to go to.
    const MENUFORMPARTS_TYPE &fill = board->parts[2];
    EXPECT_EQ(fill.dtype, MENUFORMPARTS_DTYPE_SQ_BETA);
    EXPECT_EQ(fill.effect[1].type, MENU_PARTS_EFFECT_FILLBOX);
    EXPECT_FLOAT_EQ(fill.effect[1].param[3], 4.0f);
}

TEST_F(NativeMenu, LayoutCursorsAndCurrentEntriesCarryIntoTheNextScript) {
    Layout("base.cfg.json", BaseOperations());
    // No offsets: the cursors continue, a repeated texture name is skipped, and a form whose name exists leaves
    // no current form, so its settings and parts are not applied.
    Layout("more.cfg.json", Json::array({
                                {{"op", "etc_info"}, {"entries", Json::array({{{"name", "next"}, {"values", {5, 6}}}})}},
                                {{"op", "textures"}, {"textures", Json::array({{{"name", "num"}, {"rect", {1, 1, 1, 1}}}, {{"name", "fresh"}, {"rect", {2, 2, 2, 2}}}})}},
                                {{"op", "form"}, {"name", "board"}, {"settings", Json::array({{{"set", "draw_flag"}, {"draw", 1}}})}, {"parts", Json::array({{{"part", "cursor"}, {"name", "cur"}, {"xy", {1, 2}}}})}},
                                {{"op", "form"}, {"name", "second"}, {"slot", 2}, {"settings", Json::array({{{"set", "parts_capacity"}, {"count", 1}}, {{"set", "other_form_draw_flag"}, {"form", "board"}, {"draw", 1}}})}, {"parts", Json::array()}},
    }));

    // Both extra-information tables share one cursor, which the floating-point entry left at index 1.
    EXPECT_STREQ(MenuPosData->etc_tbl[1].name, "next");
    MENU_BASETEXINFO *fresh = MenuPosData->GetTexGetInfo(2);
    ASSERT_NE(fresh, nullptr);
    EXPECT_STREQ(fresh->name, "fresh");
    EXPECT_STREQ(fresh->tex_name, "mnmain");
    CMenuPosDataForm *board = MenuPosData->GetFormInfo(1);
    EXPECT_EQ(board->parts[3].name, nullptr);
    EXPECT_EQ(board->draw_flag, 1);
    CMenuPosDataForm *second = MenuPosData->GetFormInfo(3);
    ASSERT_NE(second, nullptr);
    EXPECT_STREQ(second->name, "second");
}

TEST_F(NativeMenu, LayoutCopiedOutOfItsFileIsReadFromItsBytes) {
    Json document = {
        {"schema_version", 2                                                                                                                                                                                        },
        {"kind",           "menu_layout"                                                                                                                                                                            },
        {"operations",     Json::array({{{"op", "allocate_forms"}, {"count", 2}}, {{"op", "form_offset"}, {"index", 0}}, {{"op", "form"}, {"name", "only"}, {"settings", Json::array()}, {"parts", Json::array()}}})}
    };
    std::string copy = document.dump();
    EXPECT_EQ(MenuDataAnalyze(copy.data(), static_cast<int>(copy.size()), &memory), 1);
    ASSERT_EQ(MenuPosData->form_num, 2);
    EXPECT_STREQ(MenuPosData->GetFormInfo(0)->name, "only");
}

TEST_F(NativeMenu, CommandsRunEveryBlockOfTheRequestedName) {
    Layout("base.cfg.json", BaseOperations());
    auto             &script = Load("cmd_com.cfg.json", "menu_commands",
                                    {
                                        {"blocks", Json::array({
                                                       {{"name", "open"}, {"commands", Json::array({{{"op", "form_draw_flag"}, {"draw", 1}, {"forms", {"board", "missing"}}}, {{"op", "form_rgba"}, {"form", "board"}, {"rgba", {1, 2, 3, 4}}}, {{"op", "input_key"}, {"enable", 1}}})}},
                                                       {{"name", "close"}, {"commands", Json::array({{{"op", "form_draw_flag"}, {"draw", 0}, {"forms", {"board"}}}, {{"op", "form_rgba"}, {"form", "board"}}})}},
                                                       {{"name", "open"}, {"commands", Json::array({{{"op", "form_set_pos"}, {"form", "board"}, {"xy", {5, 6}}}, {{"op", "form_set_pos"}, {"form", "board"}, {"xy", {7, 8}}, {"language", LanguageCode + 1}}, {{"op", "part_draw_flag"}, {"form", "board"}, {"part", "days"}, {"draw", 0}}})}},
                                                   })}
    });
    char              board_name[] = "board";
    CMenuPosDataForm *board = MenuPosData->GetFormInfo(board_name);
    ASSERT_NE(board, nullptr);
    char open[] = "open";
    char close[] = "close";
    char none[] = "none";

    MenuCommandAnalyze(script.data(), static_cast<int>(script.size()), open);
    EXPECT_EQ(board->draw_flag, 1);
    EXPECT_EQ(board->rgba[3], 4);
    EXPECT_EQ(MenuCommonInfo->key_enable, 1);
    EXPECT_EQ(board->x, 5.0f);
    EXPECT_EQ(board->parts[1].draw_flag, 0);
    EXPECT_STREQ(MenuCommandAnalyzeInfo.command_name, "open");

    MenuCommandAnalyze(script.data(), static_cast<int>(script.size()), close);
    EXPECT_EQ(board->draw_flag, 0);
    EXPECT_EQ(board->rgba[0], 0x80);

    board->draw_flag = 1;
    MenuCommandAnalyze(script.data(), static_cast<int>(script.size()), none);
    EXPECT_EQ(board->draw_flag, 1);
}

TEST_F(NativeMenu, InvalidDocumentsChangeNothing) {
    auto &script = Load("bad.cfg.json", "menu_layout", {
                                                           {"operations", Json::array({{{"op", "allocate_forms"}, {"count", 2}}, {{"op", "texture_sheet"}, {"sheet", "x"}, {"block_slot", 99}, {"textures", Json::array()}}})}
    });
    EXPECT_EQ(MenuDataAnalyze(script.data(), static_cast<int>(script.size()), &memory), 1);
    EXPECT_EQ(MenuPosData->form_num, 0);
}
} // namespace

TEST_F(NativeMenu, LayoutAllocationRejectsShortLockedAndRetiredStorageBeforePublication) {
    auto     &buffer = Load("short.cfg.json", "menu_layout", {
                                                                 {"operations", Json::array({{{"op", "allocate_forms"}, {"count", 1}}})}
    });
    mgCMemory parent;
    auto     *root = reinterpret_cast<u_long128 *>(ArenaBlock(&parent, 4 * sizeof(u_long128)));
    parent.stSetBuffer(root, 4);
    auto *allocation = parent.Alloc(3);
    ASSERT_NE(allocation, nullptr);
    mgCMemory child;
    child.stSetChildBuffer(parent, allocation, 3);
    std::memset(allocation, 0xA5, 3 * sizeof(u_long128));
    const auto previous_forms = MenuPosData->form;
    const auto previous_count = MenuPosData->form_num;
    EXPECT_EQ(MenuDataAnalyze(buffer.data(), static_cast<int>(buffer.size()), &child), 0);
    EXPECT_EQ(child.stGetUsed(), 0);
    EXPECT_EQ(MenuPosData->form, previous_forms);
    EXPECT_EQ(MenuPosData->form_num, previous_count);
    for (const auto value : std::span(reinterpret_cast<const u8 *>(allocation), 3 * sizeof(u_long128))) {
        EXPECT_EQ(value, 0xA5);
    }
    memory.stSetLocked(true);
    EXPECT_EQ(MenuDataAnalyze(buffer.data(), static_cast<int>(buffer.size()), &memory), 0);
    EXPECT_EQ(memory.stGetUsed(), 0);
    parent.stClearUsed();
    EXPECT_EQ(MenuDataAnalyze(buffer.data(), static_cast<int>(buffer.size()), &child), 0);
    EXPECT_EQ(child.stGetUsed(), 0);
    EXPECT_EQ(MenuPosData->form, previous_forms);
    EXPECT_EQ(MenuPosData->form_num, previous_count);
}
