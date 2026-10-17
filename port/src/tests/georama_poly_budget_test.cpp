#include <gtest/gtest.h>

#include "editanalyze.hpp"
#include "georama_poly_budget.hpp"
#include "platform/config.hpp"

TEST(GeoramaPolyBudget, RetailCapsMatchKnownTowns) {
    EXPECT_EQ(GetMaxPolynRetailCap(EDIT_ANALYZE_MAP_SHARLOT), 0xFA0);
    EXPECT_EQ(GetMaxPolynRetailCap(EDIT_ANALYZE_MAP_HEIM), 0x1770);
    EXPECT_EQ(GetMaxPolynRetailCap(EDIT_ANALYZE_MAP_MOON_FLOWER), 0xFA0);
    EXPECT_EQ(GetMaxPolynRetailCap(-1), 0);
}

TEST(GeoramaPolyBudget, ScalePreservesZeroCap) {
    EXPECT_EQ(ScaleGeoramaPolyBudget(0, 6), 0);
    EXPECT_EQ(ScaleGeoramaPolyBudget(0xFA0, 1), 0xFA0);
    EXPECT_EQ(ScaleGeoramaPolyBudget(0xFA0, 6), 0xFA0 * 6);
}

TEST(GeoramaPolyBudget, GetMaxPolynUsesConfigMultiplier) {
    Config config = ConfigGet();
    config.georama_poly_multiplier = 6;
    ASSERT_TRUE(ConfigChange(config));

    EXPECT_EQ(GetMaxPolyn(EDIT_ANALYZE_MAP_SHARLOT), 0xFA0 * 6);
    EXPECT_EQ(GetMaxPolyn(EDIT_ANALYZE_MAP_HEIM), 0x1770 * 6);
    EXPECT_EQ(GetMaxPolyn(-1), 0);

    config.georama_poly_multiplier = 1;
    ASSERT_TRUE(ConfigChange(config));
    EXPECT_EQ(GetMaxPolyn(EDIT_ANALYZE_MAP_SHARLOT), 0xFA0);
}
