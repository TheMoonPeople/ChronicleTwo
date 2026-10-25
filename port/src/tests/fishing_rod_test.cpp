#include <gtest/gtest.h>

#include <memory>

#include "fishing_rod.hpp"
#include "gamedata.hpp"
#include "mainloop_port.hpp"
#include "savedata.hpp"
#include "userdata.hpp"

namespace {

constexpr int kWorm = 200;   // bait
constexpr int kMinnow = 201; // bait
constexpr int kLure = 210;   // a lure
constexpr int kStone = 220;  // neither
constexpr int kWrench = 2;   // a melee weapon of Max's

CDataCommon *Lookup(int item_no) {
    static CDataCommon bait{}, lure{}, stone{}, wrench{};
    bait.attribute = ITEM_ATTRIBUTE_BAIT;
    lure.type = ITEM_DATA_LURE;
    stone.type = ITEM_DATA_ETC;
    wrench.type = ITEM_DATA_MAX_MELEE;
    switch (item_no) {
        case kWorm:
        case kMinnow:
            return &bait;
        case kLure:
            return &lure;
        case kStone:
            return &stone;
        case kWrench:
            return &wrench;
        default:
            return nullptr;
    }
}

class FishingRod : public testing::Test {
protected:
    CSaveData                 *saved_save_ = PortActiveSaveData;
    CGameData                  saved_data_ = GameItemDataManage;
    CDataCommon                stack_{};
    std::unique_ptr<CSaveData> save_ = std::make_unique<CSaveData>();
    CUserDataManager          *user_ = nullptr;

    void SetUp() override {
        PortActiveSaveData = save_.get();
        user_ = GetUserDataMan();
        // AddNum caps a stack by the game's own table; without the retail data every item reads this entry.
        stack_.max_num = 99;
        GameItemDataManage.common_data = &stack_;
        for (int item : {kWorm, kMinnow, kLure}) {
            if (GameItemDataManage.GetCommonData(item) != &stack_) {
                GTEST_SKIP() << "the retail item table is loaded";
            }
        }
        Rod(ITEM_ID_FISHING_ROD);
    }

    void TearDown() override {
        GameItemDataManage = saved_data_;
        PortActiveSaveData = saved_save_;
    }

    void Rod(int rod) { user_->chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_MELEE].item_no = static_cast<short>(rod); }

    CGameDataUsed &Bag(int place, int item_no, int num) {
        CGameDataUsed &item = *user_->GetUsedDataPtr(place);
        item.Init();
        item.item_no = static_cast<short>(item_no);
        item.used_type = USED_ITEM_TYPE_ITEM;
        item.data.item.num = static_cast<s16>(num);
        return item;
    }

    CGameDataUsed &Bait() { return *user_->GetActiveEsa(); }
};

} // namespace

TEST_F(FishingRod, AnEmptyRodTakesTheBaitLastUsedElseTheFirstThatFits) {
    Bag(0, kStone, 4);
    Bag(1, kLure, 1);
    Bag(2, kWorm, 3);
    Bag(5, kMinnow, 6);
    EXPECT_EQ(FishingRodRebait(user_, kMinnow, Lookup), FISHING_REBAIT_CHANGED);
    EXPECT_EQ(Bait().item_no, kMinnow);
    EXPECT_EQ(Bait().GetNum(), 6);
    EXPECT_EQ(user_->GetUsedDataPtr(5)->item_no, 0);
    // The minnows are gone: the first bait on the board, not the stone or the lure.
    Bait().Init();
    EXPECT_EQ(FishingRodRebait(user_, kMinnow, Lookup), FISHING_REBAIT_CHANGED);
    EXPECT_EQ(Bait().item_no, kWorm);
    EXPECT_EQ(Bait().GetNum(), 3);
    EXPECT_EQ(user_->GetUsedDataPtr(0)->item_no, kStone);
    EXPECT_EQ(user_->GetUsedDataPtr(1)->item_no, kLure);
    Bait().Init();
    EXPECT_EQ(FishingRodRebait(user_, kWorm, Lookup), FISHING_REBAIT_NONE);
    EXPECT_EQ(Bait().item_no, 0);
}

TEST_F(FishingRod, BaitOnTheRodIsToppedUpFromTheSameKindOnly) {
    CGameDataUsed &worms = Bag(3, kWorm, 98);
    Bag(4, kMinnow, 5);
    Bait().CopyGameData(&worms);
    Bait().data.item.num = 2;
    worms.data.item.num = 98;
    // 97 fit under the 99 cap; one worm stays on the board.
    EXPECT_EQ(FishingRodRebait(user_, kWorm, Lookup), FISHING_REBAIT_TOP_UP);
    EXPECT_EQ(Bait().GetNum(), 99);
    EXPECT_EQ(worms.item_no, kWorm);
    EXPECT_EQ(worms.GetNum(), 1);
    EXPECT_EQ(FishingRodRebait(user_, kWorm, Lookup), FISHING_REBAIT_NONE);
    // A short stack is emptied from the board.
    Bait().data.item.num = 98;
    EXPECT_EQ(FishingRodRebait(user_, kWorm, Lookup), FISHING_REBAIT_TOP_UP);
    EXPECT_EQ(Bait().GetNum(), 99);
    EXPECT_EQ(worms.item_no, 0);
    EXPECT_EQ(user_->GetUsedDataPtr(4)->GetNum(), 5);
    EXPECT_EQ(FishingRodRebait(user_, kWorm, Lookup), FISHING_REBAIT_NONE);
}

TEST_F(FishingRod, TheLureRodTakesOnlyLures) {
    Rod(ITEM_ID_LURE_ROD);
    Bag(0, kWorm, 3);
    EXPECT_EQ(FishingRodRebait(user_, 0, Lookup), FISHING_REBAIT_NONE);
    Bag(7, kLure, 1);
    EXPECT_EQ(FishingRodRebait(user_, 0, Lookup), FISHING_REBAIT_CHANGED);
    EXPECT_EQ(Bait().item_no, kLure);
    EXPECT_EQ(user_->GetActiveEsa(ITEM_ID_FISHING_ROD)->item_no, 0);
    EXPECT_EQ(user_->GetUsedDataPtr(0)->item_no, kWorm);
}

TEST_F(FishingRod, TheFallbackWeaponIsMaxsFirstMeleeWeaponOnTheBoard) {
    EXPECT_EQ(FishingRodFallbackWeapon(user_, Lookup), nullptr);
    Bag(2, kStone, 1);
    CGameDataUsed &wrench = Bag(6, kWrench, 1);
    Bag(9, kWrench, 1);
    EXPECT_EQ(FishingRodFallbackWeapon(user_, Lookup), &wrench);
}
