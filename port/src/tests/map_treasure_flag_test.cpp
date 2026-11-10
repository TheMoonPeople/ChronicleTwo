#include <gtest/gtest.h>

#include <array>
#include <memory>
#include <string>
#include <string_view>

#include "map.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mapselect.hpp"
#include "object/world/treasure_flags.hpp"

namespace {

/**
 *
 * Starlight Temple's two Fruit of Eden chests, which retail data both give opened flag 7.
 *
 */
class StarlightChests : public testing::Test {
protected:
    std::unique_ptr<CMapTreasureBox[]> boxes = std::make_unique<CMapTreasureBox[]>(2);
    std::array<CFuncPoint, 2>          points;
    char                               weapon_name[8] = "item19";
    char                               items_name[8] = "item11";
    CMapFlagData                       flags = {};
    CMap                               map;

    void SetUp() override {
        points[0].name = weapon_name;
        points[1].name = items_name;
        map.tr_box = boxes.get();
        map.tr_box_num = 2;
    }

    void TearDown() override {
        map.tr_box = nullptr;
        map.tr_box_num = 0;
    }

    // As CMap::CreateTrBox does on each visit, every chest takes its flag from its function point again.
    void Visit(std::string_view map_name) {
        for (int i = 0; i < 2; ++i) {
            points[i].flag_no = 7;
            points[i].enable = 1;
            boxes[i].active = 1;
            boxes[i].flag_no = points[i].flag_no;
            boxes[i].func_point = &points[i];
            boxes[i].parts = nullptr;
        }
        PortSplitTreasureBoxFlags(map, map_name);
        map.UpdateTrBoxFlag(&flags);
    }
};

} // namespace

TEST(NativeMapPath, OwnsTheFullMapDirectoryWithoutTruncatingLongNames) {
    EXPECT_EQ(dc2::world::MapPath("f01"), "map/f/f01/f01");
    EXPECT_EQ(dc2::world::MapPath("abc1234"), "map/a/abc/123/abc1234");
    const std::string long_name(200, 'x');
    const std::string path = dc2::world::MapPath(long_name);
    EXPECT_EQ(path, "map/x/xxx/xxx/" + long_name);
}

TEST_F(StarlightChests, OpeningTheWeaponChestLeavesTheWindGemChest) {
    Visit("f02");
    EXPECT_EQ(boxes[0].flag_no, 7);
    EXPECT_EQ(boxes[1].flag_no, 9);
    map.DeleteTrBox(0, &flags);
    EXPECT_TRUE(flags.GetFlag(7));
    EXPECT_FALSE(flags.GetFlag(9));

    Visit("f02");
    EXPECT_EQ(boxes[0].active, 0);
    EXPECT_EQ(boxes[1].active, 1);

    map.DeleteTrBox(1, &flags);
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
}
