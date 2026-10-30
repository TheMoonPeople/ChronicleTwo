#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <memory>

#include "gamedata.hpp"
#include "menucls1.hpp"

TEST(MenuItemUse, NullItemRetainsFullWidthTarget) {
    CMenuItemUse  use{};
    CGameDataUsed target{};
    const auto    saved = MenuUsedTarget;
    EXPECT_EQ(use.UseItem(nullptr, ITEM_USE_TARGET_ITEM, &target), 0);
    EXPECT_EQ(MenuUsedTarget.type, ITEM_USE_TARGET_ITEM);
    EXPECT_EQ(MenuUsedTarget.target.data, &target);
    MenuUsedTarget = saved;
}

TEST(MenuItemUse, IneffectiveItemStillRecordsTheTarget) {
    CMenuItemUse  use{};
    CGameDataUsed item{};
    CGameDataUsed target{};
    const auto    saved = MenuUsedTarget;
    EXPECT_EQ(use.UseItem(&item, ITEM_USE_TARGET_ITEM, &target), 0);
    EXPECT_EQ(use.item_no, item.item_no);
    EXPECT_EQ(use.target_type, ITEM_USE_TARGET_ITEM);
    EXPECT_EQ(MenuUsedTarget.target.data, &target);
    MenuUsedTarget = saved;
}

TEST(MenuItemUse, PoisonedTargetStartsEmptyAndUnknownKindsForgetThePreviousPointer) {
    alignas(CItemUseTarget) std::array<std::byte, sizeof(CItemUseTarget)> bytes{};
    std::memset(bytes.data(), 0xA5, bytes.size());
    auto *target = std::construct_at(reinterpret_cast<CItemUseTarget *>(bytes.data()));
    EXPECT_EQ(target->type, ITEM_USE_TARGET_NONE);
    EXPECT_EQ(target->target.data, nullptr);
    CGameDataUsed item{};
    target->SetPtr(ITEM_USE_TARGET_ITEM, &item);
    EXPECT_EQ(static_cast<CGameDataUsed *>(target->target.data), &item);
    target->SetPtr(ITEM_USE_TARGET_NONE, nullptr);
    EXPECT_EQ(target->target.data, nullptr);
    target->SetPtr(-99, &item);
    EXPECT_EQ(target->target.data, nullptr);
    std::destroy_at(target);
}
