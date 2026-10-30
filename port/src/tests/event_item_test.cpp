#include <gtest/gtest.h>

#include <array>
#include <span>

#include "gamedata.hpp"
#include "object/menu/event_item_selection.hpp"

namespace {

constexpr int kRequested = 362;

std::array<CGameDataUsed, 4> Bag() {
    std::array<CGameDataUsed, 4> bag{};
    bag[1].used_type = USED_ITEM_TYPE_ITEM;
    bag[1].item_no = 10;
    bag[3].used_type = USED_ITEM_TYPE_ITEM;
    bag[3].item_no = kRequested;
    return bag;
}

} // namespace

TEST(EventItem, OneRequestedItemTakesTheFirstPlaceHoldingIt) {
    auto                     bag = Bag();
    const std::array<int, 3> used_up{1, kRequested, 0};
    const std::array<int, 3> kept{0, kRequested, 0};
    EXPECT_EQ(PortEventItemPlace(used_up, bag), 3);
    EXPECT_EQ(PortEventItemPlace(kept, bag), 3);
}

TEST(EventItem, SeveralOrMissingItemsNeedThePicker) {
    auto                     bag = Bag();
    const std::array<int, 4> several{1, kRequested, 10, 0};
    const std::array<int, 3> missing{1, 99, 0};
    const std::array<int, 2> none{1, 0};
    EXPECT_EQ(PortEventItemPlace(several, bag), -1);
    EXPECT_EQ(PortEventItemPlace(missing, bag), -1);
    EXPECT_EQ(PortEventItemPlace(none, bag), -1);
    EXPECT_EQ(PortEventItemPlace({}, bag), -1);
}

TEST(EventItem, PlacesThePickerLeavesOutAreSkipped) {
    auto bag = Bag();
    bag[0].used_type = USED_ITEM_TYPE_BOILED;
    bag[0].item_no = kRequested;
    bag[2].used_type = USED_ITEM_TYPE_ATTACH;
    bag[2].item_no = ITEM_ID_SPECTOL;
    bag[2].data.attach.spectol_item_no = 5;
    const std::array<int, 3> boiled{1, kRequested, 0};
    const std::array<int, 3> fitted{1, ITEM_ID_SPECTOL, 0};
    EXPECT_EQ(PortEventItemPlace(boiled, bag), 3);
    EXPECT_EQ(PortEventItemPlace(fitted, bag), -1);
}

TEST(EventItem, RequestsAreReadWithinTheirSpan) {
    auto                      bag = Bag();
    const std::array<int, 2>  unterminated{1, kRequested};
    const std::array<int, 16> eleven{1, kRequested, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    EXPECT_EQ(PortEventItemPlace(unterminated, bag), 3);
    EXPECT_EQ(PortEventItemPlace(eleven, bag), -1);
}
