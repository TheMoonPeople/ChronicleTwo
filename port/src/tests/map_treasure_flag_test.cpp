#include <gtest/gtest.h>

#include <memory>

#include "map.hpp"
#include "map_port.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"

namespace {
// Starlight Temple's two Fruit of Eden chests that retail data both give opened flag 7.
class StarlightChests : public testing::Test {
protected:
    std::unique_ptr<CMapTreasureBox[]> boxes = std::make_unique<CMapTreasureBox[]>(2);
    CFuncPoint                         points[2];
    char                               weapon_name[8] = "item19";
    char                               items_name[8] = "item11";
    CMapFlagData                       flags = {};
    CMap                               map;

    void SetUp() override {
        points[0].name = weapon_name;
        points[1].name = items_name;
        map.tr_box = boxes.get();
        map.tr_box_num = 2;
        Build();
    }

    void TearDown() override {
        map.tr_box = nullptr;
        map.tr_box_num = 0;
    }

    // As CMap::CreateTrBox does on each visit: every chest takes its flag from its function point again.
    void Build() {
        for (int i = 0; i < 2; ++i) {
            points[i].flag_no = 7;
            points[i].enable = 1;
            boxes[i].active = 1;
            boxes[i].flag_no = points[i].flag_no;
            boxes[i].func_point = &points[i];
            boxes[i].parts = nullptr;
        }
    }

    void Visit(const char *map_name) {
        Build();
        PortSplitTreasureBoxFlags(&map, map_name);
        map.UpdateTrBoxFlag(&flags);
    }
};
} // namespace

TEST_F(StarlightChests, OnlyItem11MovesToFlag9) {
    Visit("f02");
    EXPECT_EQ(boxes[0].flag_no, 7);
    EXPECT_EQ(boxes[1].flag_no, 9);
}

TEST_F(StarlightChests, OpeningTheWeaponChestEarlyLeavesTheWindGemChest) {
    Visit("f02");
    map.DeleteTrBox(0, &flags);
    EXPECT_TRUE(flags.GetFlag(7));
    EXPECT_FALSE(flags.GetFlag(9));

    Visit("f02");
    EXPECT_EQ(boxes[0].active, 0);
    EXPECT_EQ(boxes[1].active, 1);
    EXPECT_EQ(points[1].enable, 1);

    map.DeleteTrBox(1, &flags);
    EXPECT_TRUE(flags.GetFlag(9));
    Visit("f02");
    EXPECT_EQ(boxes[1].active, 0);
}

TEST_F(StarlightChests, OpeningTheWindGemChestLeavesTheWeaponChest) {
    Visit("f02");
    map.DeleteTrBox(1, &flags);
    Visit("f02");
    EXPECT_EQ(boxes[0].active, 1);
    EXPECT_EQ(boxes[1].active, 0);
}

TEST_F(StarlightChests, OtherMapsKeepTheirRetailFlags) {
    flags.SetFlag(7, 1);
    Visit("f01");
    EXPECT_EQ(boxes[1].flag_no, 7);
    EXPECT_EQ(boxes[0].active, 0);
    EXPECT_EQ(boxes[1].active, 0);
    PortSplitTreasureBoxFlags(&map, nullptr);
    PortSplitTreasureBoxFlags(nullptr, "f02");
    EXPECT_EQ(boxes[1].flag_no, 7);
}
