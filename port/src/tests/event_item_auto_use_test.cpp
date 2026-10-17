#include <gtest/gtest.h>

#include "event_item_auto_use.hpp"
#include "gamedata.hpp"

namespace {

constexpr int kParamCap = 16;

TEST(EventItemAutoUse, WhitelistCount) {
    const int none[] = {1, 0};
    EXPECT_EQ(PortCountEventItemWhitelistIds(none, kParamCap), 0);

    const int one[] = {1, 42, 0};
    EXPECT_EQ(PortCountEventItemWhitelistIds(one, kParamCap), 1);

    const int two[] = {1, 10, 11, 0};
    EXPECT_EQ(PortCountEventItemWhitelistIds(two, kParamCap), 2);
}

TEST(EventItemAutoUse, ResolvesSingleOwnedId) {
    const int params[] = {1, 100, 0};
    const EventItemBagSlot bag[] = {
        {0, 0, 0},
        {100, USED_ITEM_TYPE_ITEM, 0},
    };

    int item_no = 0;
    int index = -1;
    EXPECT_TRUE(PortTryResolveEventItemFromParams(kEventItemMenuOpenUseItem, true, params, kParamCap, bag, 2, &item_no,
                                                  &index));
    EXPECT_EQ(item_no, 100);
    EXPECT_EQ(index, 1);
}

TEST(EventItemAutoUse, SkipsIneligibleBagSlots) {
    const int params[] = {1, 100, 0};
    const EventItemBagSlot bag[] = {
        {100, USED_ITEM_TYPE_BOILED, 0},
        {100, USED_ITEM_TYPE_ITEM, 1},
        {100, USED_ITEM_TYPE_ITEM, 0},
    };

    int item_no = 0;
    int index = -1;
    EXPECT_TRUE(PortTryResolveEventItemFromParams(kEventItemMenuOpenUseItem, true, params, kParamCap, bag, 3, &item_no,
                                                  &index));
    EXPECT_EQ(index, 2);
}

TEST(EventItemAutoUse, MultipleWhitelistIdsOpensPicker) {
    const int params[] = {1, 10, 11, 0};
    const EventItemBagSlot bag[] = {{10, USED_ITEM_TYPE_ITEM, 0}};

    int item_no = 0;
    int index = -1;
    EXPECT_FALSE(PortTryResolveEventItemFromParams(kEventItemMenuOpenUseItem, true, params, kParamCap, bag, 1, &item_no,
                                                   &index));
}

TEST(EventItemAutoUse, MissingItemDoesNotResolve) {
    const int params[] = {1, 99, 0};
    const EventItemBagSlot bag[] = {{10, USED_ITEM_TYPE_ITEM, 0}};

    int item_no = 0;
    int index = -1;
    EXPECT_FALSE(PortTryResolveEventItemFromParams(kEventItemMenuOpenUseItem, true, params, kParamCap, bag, 1, &item_no,
                                                   &index));
}

TEST(EventItemAutoUse, DisabledHostSetting) {
    const int params[] = {1, 10, 0};
    const EventItemBagSlot bag[] = {{10, USED_ITEM_TYPE_ITEM, 0}};

    int item_no = 0;
    int index = -1;
    EXPECT_FALSE(PortTryResolveEventItemFromParams(kEventItemMenuOpenUseItem, false, params, kParamCap, bag, 1,
                                                  &item_no, &index));
}

TEST(EventItemAutoUse, FishSelectExcluded) {
    const int params[] = {1, 10, 0};
    const EventItemBagSlot bag[] = {{10, USED_ITEM_TYPE_ITEM, 0}};

    int item_no = 0;
    int index = -1;
    EXPECT_FALSE(PortTryResolveEventItemFromParams(kEventItemMenuOpenUseItemFish, true, params, kParamCap, bag, 1,
                                                  &item_no, &index));
}

TEST(EventItemAutoUse, ParamZeroNotOneSkipsAuto) {
    const int params[] = {2, 10, 11, 0};
    const EventItemBagSlot bag[] = {{10, USED_ITEM_TYPE_ITEM, 0}};

    int item_no = 0;
    int index = -1;
    EXPECT_FALSE(PortTryResolveEventItemFromParams(kEventItemMenuOpenUseItem, true, params, kParamCap, bag, 1, &item_no,
                                                  &index));
}

TEST(EventItemAutoUse, GotoUseItem2SingleIdInParamZero) {
    const int params[] = {100, 0};
    const EventItemBagSlot bag[] = {{100, USED_ITEM_TYPE_ITEM, 0}};

    int required = 0;
    EXPECT_TRUE(PortRequiredEventItemId(params, kParamCap, &required));
    EXPECT_EQ(required, 100);

    int item_no = 0;
    int index = -1;
    EXPECT_TRUE(PortTryResolveEventItemFromParams(kEventItemMenuOpenUseItem, true, params, kParamCap, bag, 1, &item_no,
                                                  &index));
    EXPECT_EQ(index, 0);
}

} // namespace
