#include <gtest/gtest.h>

#include "gamedata.hpp"
#include "local_layout_probes.hpp"

TEST(LocalLayout, ItemCommandTargetFitsTheTypedWrite) {
    EXPECT_GE(LocalLayoutProbe::TargetSize(), sizeof(CItemUseTarget));
}
