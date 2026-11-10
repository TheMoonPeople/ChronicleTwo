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

namespace {

// Mount Gundor's Deathtrap (mos_place4, floor 13) in shape: four kinds and a King Mimic.
constexpr std::array kDeathtrap = {37, 137, 37, 149, 254, 201, 149};

std::vector<int> Ids(const std::vector<floor_monsters::Species> &species) {
    std::vector<int> ids;
    ids.reserve(species.size());
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
    const auto species = floor_monsters::FloorSpecies(kDeathtrap, 24);
    EXPECT_EQ(Ids(species), (std::vector<int>{37, 137, 149, 254, 201}));
    EXPECT_EQ(species[0].count, 2);
    EXPECT_EQ(species[2].count, 2);
    EXPECT_EQ(species[3].count, 1);
    EXPECT_TRUE(species[0].key);
    for (std::size_t i = 1; i < species.size(); ++i) {
        EXPECT_FALSE(species[i].key) << species[i].id;
    }
    EXPECT_TRUE(floor_monsters::FloorSpecies({}, 24).empty());
}

TEST(FloorMonsters, MimicsNeverCarryTheKeyAndAlwaysBecomeChestsPastTheCap) {
    constexpr std::array ids = {static_cast<int>(MONSTER_ID_MIMIC_FIRST), 7, 8, static_cast<int>(MONSTER_ID_MIMIC_LAST)};
    // AutoSetMonster places the first cap entries; the treasure boxes take every mimic.
    const auto species = floor_monsters::FloorSpecies(ids, 2);
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
        {.name = "Griffon Soldier x6", .key = "Magma Rock", .drops = {"Cheese 13%", "Protector Crystal 4%", "Hunk of Copper 25%"}},
        {.name = "King Mimic x1",      .key = "",           .drops = {}                                                          },
        {.name = "Savage Ram x6",      .key = "",           .drops = {"Mimi 13%", "Hunter Crystal 4%", "Sturdy Cloth 25%"}       },
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
    EXPECT_EQ(floor_monsters::Decide(info, MENU_PUSH_BUTTON_TRIANGLE), Action::Open);
    EXPECT_EQ(floor_monsters::Decide(info, MENU_PUSH_BUTTON_CANCEL), Action::None);
    auto with_materials = info;
    with_materials.materials = 3; // retail's Triangle opens the materials list instead
    EXPECT_EQ(floor_monsters::Decide(with_materials, MENU_PUSH_BUTTON_TRIANGLE), Action::None);
    auto empty = info;
    empty.has_monsters = false;
    EXPECT_EQ(floor_monsters::Decide(empty, MENU_PUSH_BUTTON_TRIANGLE), Action::None);
    auto question = info;
    question.info_view = false; // the jump question
    EXPECT_EQ(floor_monsters::Decide(question, MENU_PUSH_BUTTON_TRIANGLE), Action::None);

    floor_monsters::View materials;
    materials.key_arg_no = DNG_TREE_MAP_SCREEN_MATERIALS;
    materials.has_monsters = true;
    materials.materials = DNG_TREE_MAP_MATERIA_PAGE + 1;
    EXPECT_EQ(floor_monsters::Decide(materials, MENU_PUSH_BUTTON_TRIANGLE), Action::None); // retail turns the page
    materials.materials_page = 1;
    EXPECT_EQ(floor_monsters::Decide(materials, MENU_PUSH_BUTTON_TRIANGLE), Action::Open);
    EXPECT_EQ(floor_monsters::Decide(materials, MENU_PUSH_BUTTON_CANCEL), Action::None); // retail closes the list
}

TEST(FloorMonsters, ThePageTurnsOnTriangleAndClosesOnItsLastPageOrCancel) {
    using floor_monsters::Action;
    floor_monsters::View view;
    view.key_arg_no = floor_monsters::kScreenMonsters;
    view.pages = 2;
    EXPECT_EQ(floor_monsters::Decide(view, MENU_PUSH_BUTTON_TRIANGLE), Action::NextPage);
    EXPECT_EQ(floor_monsters::Decide(view, MENU_PUSH_BUTTON_CANCEL), Action::Close);
    EXPECT_EQ(floor_monsters::Decide(view, MENU_PUSH_BUTTON_DECIDE), Action::None);
    view.page = 1;
    EXPECT_EQ(floor_monsters::Decide(view, MENU_PUSH_BUTTON_TRIANGLE), Action::Close);
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
    // Triangle opened the list (AfterStep's Open); with the setting off, Triangle leaves retail's information as is.
    info.key_arg_no = floor_monsters::kScreenMonsters;
    info.info_view = false;
    info.draw_alpha = 0;
    floor_monsters::Restore(info, changes);
    ExpectSame(info, FreshOffInformation());
}
