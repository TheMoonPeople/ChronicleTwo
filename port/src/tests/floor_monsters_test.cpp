#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <string>
#include <vector>

#include "dngmenu.hpp"
#include "floor_monsters.hpp"
#include "menusys.hpp"
#include "monster.hpp"
#include "platform/config.hpp"
#include "platform/config_catalog.hpp"

namespace {

config_catalog::Command Tag(std::string name, std::vector<int> values) {
    config_catalog::Command command;
    command.name = std::move(name);
    for (int value : values) {
        command.arguments.push_back({value});
    }
    return command;
}

// Mount Gundor's Deathtrap (mos_place4, FLS 13) in shape: four kinds, a King Mimic, and a floor either side.
config_catalog::Document Deathtrap() {
    config_catalog::Document document;
    document.commands = {
        Tag("FLS", {12, 2}),
        Tag("FL", {22, 2200, 22, 2201}),
        Tag("FLE", {}),
        Tag("FLS", {13, 23}),
        Tag("FL", {37, 3700, 137, 13700, 37, 3701, 149, 14900}),
        Tag("FL", {254, 25400, 201, 20100, 149, 14901}),
        Tag("FLE", {}),
        Tag("FLS", {14, 1}),
        Tag("FL", {65, 6500}),
        Tag("FLE", {}),
    };
    return document;
}

std::vector<int> Ids(const std::vector<floor_monsters::Species> &species) {
    std::vector<int> ids;
    for (const auto &kind : species) {
        ids.push_back(kind.id);
    }
    return ids;
}

int Width(const std::string &text) {
    return static_cast<int>(text.size()) * 7;
}

} // namespace

TEST(FloorMonsters, FloorSpeciesCountsTheFloorsListInOrderAndKeysItsFirstEntry) {
    const auto species = floor_monsters::FloorSpecies(Deathtrap(), 13, 24);
    EXPECT_EQ(Ids(species), (std::vector<int>{37, 137, 149, 254, 201}));
    EXPECT_EQ(species[0].count, 2);
    EXPECT_EQ(species[2].count, 2);
    EXPECT_EQ(species[3].count, 1);
    EXPECT_TRUE(species[0].key);
    for (std::size_t i = 1; i < species.size(); ++i) {
        EXPECT_FALSE(species[i].key) << species[i].id;
    }
    EXPECT_EQ(Ids(floor_monsters::FloorSpecies(Deathtrap(), 14, 24)), (std::vector<int>{65}));
    EXPECT_TRUE(floor_monsters::FloorSpecies(Deathtrap(), 8, 24).empty());
}

TEST(FloorMonsters, FloorSpeciesFollowsRetailTagsForRepeatsAndStrayEntries) {
    config_catalog::Document document;
    document.commands = {
        Tag("FL", {1, 100}), // before any FLS: no floor is listing
        Tag("FLS", {3, 1}),
        Tag("FL", {2, 200}),
        Tag("FLE", {}),
        Tag("FL", {4, 400}), // after FLE: ignored
        Tag("FLS", {3, 1}),
        Tag("FL", {5, 500, 5, 501}), // a second block for the floor starts it again
    };
    const auto species = floor_monsters::FloorSpecies(document, 3, 24);
    ASSERT_EQ(Ids(species), (std::vector<int>{5}));
    EXPECT_EQ(species[0].count, 2);
}

TEST(FloorMonsters, MimicsNeverCarryTheKeyAndAlwaysBecomeChestsPastTheCap) {
    config_catalog::Document document;
    document.commands = {
        Tag("FLS", {1, 4}),
        Tag("FL", {MONSTER_ID_MIMIC_FIRST, 0, 7, 700, 8, 800, MONSTER_ID_MIMIC_LAST, 1}),
        Tag("FLE", {}),
    };
    // AutoSetMonster places the first cap entries; the treasure boxes take every mimic.
    const auto species = floor_monsters::FloorSpecies(document, 1, 2);
    EXPECT_EQ(Ids(species), (std::vector<int>{MONSTER_ID_MIMIC_FIRST, 7, MONSTER_ID_MIMIC_LAST}));
    for (const auto &kind : species) {
        EXPECT_FALSE(kind.key) << kind.id;
    }
}

TEST(FloorMonsters, DropChancesMatchEveryRollOfTheRetailDeathHandler) {
    const std::array<std::array<short, 3>, 6> tables{
        {
         {312, 178, 215},
         {0, 178, 210},
         {268, 0, 0},
         {0, 0, 0},
         {0, 0, 233},
         {293, 182, 0},
         }
    };
    for (const auto &slots : tables) {
        // _SET_DEAD_START: r = iRand(100); r % 6 == 0 drops slot 1 when r < 20 and it is set, else slot 0, or slot 1
        // when slot 0 is empty. Slot 2 drops on its own roll's multiples of 4.
        int expected[3] = {0, 0, 0};
        for (int roll = 0; roll < 100; ++roll) {
            if (roll % 6 != 0 || (slots[0] <= 0 && slots[1] <= 0)) {
                continue;
            }
            int index = roll < 20 && slots[1] > 0 ? 1 : 0;
            if (slots[0] <= 0) {
                index = 1;
            }
            ++expected[index];
        }
        expected[2] = slots[2] > 0 ? 25 : 0;
        int got[3] = {0, 0, 0};
        for (const auto &drop : floor_monsters::DropChances(slots, 76, false)) {
            for (int slot = 0; slot < 3; ++slot) {
                if (slots[slot] == drop.item) {
                    got[slot] = drop.percent;
                }
            }
        }
        for (int slot = 0; slot < 3; ++slot) {
            EXPECT_EQ(got[slot], expected[slot]) << slots[0] << "," << slots[1] << "," << slots[2] << " slot " << slot;
        }
    }
    const std::array<short, 3> rat{0, 178, 210};
    EXPECT_TRUE(floor_monsters::DropChances(rat, 0, true).empty()); // no reward money: the handler returns first
}

TEST(FloorMonsters, TextsKeepTheNamesAndAddCountsAndPercents) {
    EXPECT_EQ(floor_monsters::CountText("Griffon Soldier", 6), "Griffon Soldier x6");
    EXPECT_EQ(floor_monsters::DropText("Hunter Crystal", 4), "Hunter Crystal 4%");
}

TEST(FloorMonsters, LayoutWrapsDropsAndKeepsEachMonsterOnOnePage) {
    const std::vector<floor_monsters::Entry> entries{
        {"Griffon Soldier x6", "Magma Rock", {"Cheese 13%", "Protector Crystal 4%", "Hunk of Copper 25%"}},
        {"King Mimic x1",      "",           {}                                                          },
        {"Savage Ram x6",      "",           {"Mimi 13%", "Hunter Crystal 4%", "Sturdy Cloth 25%"}       },
    };
    // 7 per character: the first entry's three drops (10, 20 and 18 characters) need two rows in 260.
    const auto pages = floor_monsters::Layout(entries, 260, 16, 14, 4, Width);
    ASSERT_EQ(pages.size(), 2u);
    const auto &first = pages[0];
    ASSERT_EQ(first.size(), 6u);
    EXPECT_EQ(first[0].text, "Griffon Soldier x6");
    EXPECT_EQ(first[0].x, 0);
    EXPECT_EQ(first[1].text, "Magma Rock");
    EXPECT_TRUE(first[1].key);
    EXPECT_EQ(first[1].x, 260 - Width("Magma Rock"));
    EXPECT_EQ(first[1].row, 0);
    EXPECT_EQ(first[2].row, 1);
    EXPECT_EQ(first[2].x, 16);
    EXPECT_EQ(first[3].row, 1);
    EXPECT_EQ(first[3].x, 16 + Width("Cheese 13%") + 14);
    EXPECT_EQ(first[4].row, 2);
    EXPECT_EQ(first[4].x, 16);
    EXPECT_EQ(first[5].text, "King Mimic x1");
    EXPECT_EQ(first[5].row, 3);
    EXPECT_EQ(floor_monsters::PageRows(first), 4);
    // Savage Ram needs three rows, which do not fit under the first page's four.
    EXPECT_EQ(pages[1][0].text, "Savage Ram x6");
    EXPECT_EQ(pages[1][0].row, 0);
    EXPECT_EQ(floor_monsters::PageRows(pages[1]), 3);
}

TEST(FloorMonsters, TriangleOpensThePageAfterTheInformationOrTheLastMaterialsPage) {
    using floor_monsters::Action;
    floor_monsters::View info;
    info.key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
    info.info_view = true;
    info.asking = true;
    info.has_monsters = true;
    EXPECT_EQ(floor_monsters::Decide(info, MENU_PUSH_BUTTON_TRIANGLE), Action::kOpen);
    EXPECT_EQ(floor_monsters::Decide(info, MENU_PUSH_BUTTON_CANCEL), Action::kNone);
    auto with_materials = info;
    with_materials.materials = 3; // retail's Triangle opens the materials list instead
    EXPECT_EQ(floor_monsters::Decide(with_materials, MENU_PUSH_BUTTON_TRIANGLE), Action::kNone);
    auto empty = info;
    empty.has_monsters = false;
    EXPECT_EQ(floor_monsters::Decide(empty, MENU_PUSH_BUTTON_TRIANGLE), Action::kNone);
    auto question = info;
    question.info_view = false; // the jump question
    EXPECT_EQ(floor_monsters::Decide(question, MENU_PUSH_BUTTON_TRIANGLE), Action::kNone);

    floor_monsters::View materials;
    materials.key_arg_no = DNG_TREE_MAP_SCREEN_MATERIALS;
    materials.has_monsters = true;
    materials.materials = DNG_TREE_MAP_MATERIA_PAGE + 1;
    EXPECT_EQ(floor_monsters::Decide(materials, MENU_PUSH_BUTTON_TRIANGLE), Action::kNone); // retail turns the page
    materials.materials_page = 1;
    EXPECT_EQ(floor_monsters::Decide(materials, MENU_PUSH_BUTTON_TRIANGLE), Action::kOpen);
    EXPECT_EQ(floor_monsters::Decide(materials, MENU_PUSH_BUTTON_CANCEL), Action::kNone); // retail closes the list
}

TEST(FloorMonsters, ThePageTurnsOnTriangleAndClosesOnItsLastPageOrCancel) {
    using floor_monsters::Action;
    floor_monsters::View view;
    view.key_arg_no = floor_monsters::kScreenMonsters;
    view.pages = 2;
    EXPECT_EQ(floor_monsters::Decide(view, MENU_PUSH_BUTTON_TRIANGLE), Action::kNextPage);
    EXPECT_EQ(floor_monsters::Decide(view, MENU_PUSH_BUTTON_CANCEL), Action::kClose);
    EXPECT_EQ(floor_monsters::Decide(view, MENU_PUSH_BUTTON_DECIDE), Action::kNone);
    view.page = 1;
    EXPECT_EQ(floor_monsters::Decide(view, MENU_PUSH_BUTTON_TRIANGLE), Action::kClose);
}

TEST(FloorMonsters, BorneoMakesTheThirdSlotCertain) {
    // _SET_DEAD_START sets drop_second when GetNowNPC() == 2, whatever its own roll gave.
    const std::array<short, 3> soldier{312, 178, 215};
    const auto                 drops = floor_monsters::DropChances(soldier, 76, true);
    ASSERT_EQ(drops.size(), 3u);
    EXPECT_EQ(drops[0].percent, 13);
    EXPECT_EQ(drops[1].percent, 4);
    EXPECT_EQ(drops[2].item, 215);
    EXPECT_EQ(drops[2].percent, 100);
}

TEST(FloorMonsters, HintShowsWhereRetailsPromptHasNoTriangleLine) {
    floor_monsters::View info;
    info.key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
    info.info_view = true;
    info.asking = true; // the jump question's information, or the dungeon menu's information only
    info.has_monsters = true;
    EXPECT_TRUE(floor_monsters::HintShown(info));
    auto with_materials = info;
    with_materials.materials = 2; // retail's prompt has its own Triangle line
    EXPECT_FALSE(floor_monsters::HintShown(with_materials));
    auto off = info;
    off.has_monsters = false; // no list, or the setting is off
    EXPECT_FALSE(floor_monsters::HintShown(off));

    floor_monsters::View materials;
    materials.key_arg_no = DNG_TREE_MAP_SCREEN_MATERIALS;
    materials.materials_drawn = true;
    materials.has_monsters = true;
    materials.materials = DNG_TREE_MAP_MATERIA_PAGE + 3;
    EXPECT_FALSE(floor_monsters::HintShown(materials)); // its first of two pages
    materials.materials_page = 1;
    EXPECT_TRUE(floor_monsters::HintShown(materials));
    materials.key_arg_no = floor_monsters::kScreenMonsters;
    EXPECT_FALSE(floor_monsters::HintShown(materials));
}

TEST(FloorMonsters, TheListIsOffByDefault) {
    EXPECT_FALSE(Config{}.floor_info_monsters);
}

namespace {

// Channel floor 1's information as retail opens it, without materials: the 0x40 prompt on one row (dngmenu.cpp).
floor_monsters::RetailInfo FreshOffInformation() {
    floor_monsters::RetailInfo info;
    info.key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
    info.info_view = true;
    info.draw_alpha = 128;
    info.prompt_y = 480 - 0x32;
    return info;
}

void ExpectSame(const floor_monsters::RetailInfo &got, const floor_monsters::RetailInfo &want) {
    EXPECT_EQ(got.key_arg_no, want.key_arg_no);
    EXPECT_EQ(got.info_view, want.info_view);
    EXPECT_EQ(got.draw_alpha, want.draw_alpha);
    EXPECT_EQ(got.prompt_y, want.prompt_y);
}

} // namespace

TEST(FloorMonsters, TurningOffWithTheInformationOpenPutsRetailsPromptBack) {
    floor_monsters::Changes    changes;
    floor_monsters::RetailInfo info = FreshOffInformation();
    floor_monsters::MovePrompt(info, changes, 480);
    floor_monsters::MovePrompt(info, changes, 480); // every frame the hint shows
    EXPECT_EQ(info.prompt_y, 480 - 0x46);
    floor_monsters::Restore(info, changes);
    ExpectSame(info, FreshOffInformation());
    EXPECT_FALSE(changes.prompt_moved);
    floor_monsters::Restore(info, changes); // and again on later frames: nothing more to put back
    ExpectSame(info, FreshOffInformation());
}

TEST(FloorMonsters, TurningOffWithTheListOpenGoesBackToRetailsInformation) {
    floor_monsters::Changes    changes;
    floor_monsters::RetailInfo info = FreshOffInformation();
    floor_monsters::MovePrompt(info, changes, 480);
    // Triangle opened the list (AfterStep's kOpen); with the setting off, Triangle leaves retail's information as is.
    info.key_arg_no = floor_monsters::kScreenMonsters;
    info.info_view = false;
    info.draw_alpha = 0;
    floor_monsters::Restore(info, changes);
    ExpectSame(info, FreshOffInformation());
}
