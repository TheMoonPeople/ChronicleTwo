#include <gtest/gtest.h>

#include "platform/settings.hpp"
#include "present.hpp"

TEST(FrameBudget, RollingAveragesMsPerTick) {
    PresentFrameBudgetResetForTest();
    for (int i = 0; i < 3; ++i) {
        PresentFrameBudgetInjectTickForTest(0.010, 0.005, 0.002);
    }
    const FrameBudgetAverages averages = PresentFrameBudgetAverages();
    EXPECT_NEAR(averages.canonical_ms, 10.0, 0.1);
    EXPECT_NEAR(averages.display_ms, 5.0, 0.1);
    EXPECT_NEAR(averages.other_ms, 2.0, 0.1);
}

TEST(FrameBudget, PresentFpsTextIncludesBudgetLine) {
    PresentFrameBudgetResetForTest();
    PresentFrameBudgetInjectTickForTest(0.001, 0.002, 0.003);
    PresentSetSettings(PresentSettings{.show_fps = true,
                                       .fps_detail = ConfigFpsDetail::All,
                                       .fps_detail_budget = true});
    const std::string text = PresentFpsText();
    EXPECT_NE(text.find("CANON"), std::string::npos);
    EXPECT_NE(text.find("DISP"), std::string::npos);
    EXPECT_NE(text.find("OTH"), std::string::npos);
}
