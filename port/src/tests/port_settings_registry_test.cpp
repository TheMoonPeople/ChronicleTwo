#include <gtest/gtest.h>

#include "menuop.hpp"
#include "options/registry.hpp"
#include "options/retail_system_mes.hpp"

TEST(PortSettingsRegistry, HostBoolsMapToConfigKeysAndRetailRows) {
    const auto entries = port_settings::Descriptors();
    ASSERT_EQ(entries.size(), 4u);

    const auto *debug = port_settings::FindByConfigKey("game.debug_mode");
    const auto *skip = port_settings::FindByConfigKey("game.skip_intro");
    ASSERT_NE(debug, nullptr);
    ASSERT_NE(skip, nullptr);

    EXPECT_STREQ(debug->id, "debug_mode");
    EXPECT_EQ(debug->retail_row, OPTION_ITEM_UNK_9);
    EXPECT_FALSE(port_settings::HasSurface(debug->surfaces, port_settings::Surface::Retail));
    EXPECT_TRUE(port_settings::HasSurface(debug->surfaces, port_settings::Surface::PcOverlay));

    EXPECT_STREQ(skip->id, "skip_intro");
    EXPECT_EQ(skip->retail_row, OPTION_ITEM_SKIP_INTRO);
    EXPECT_FALSE(port_settings::HasSurface(skip->surfaces, port_settings::Surface::Retail));
    EXPECT_TRUE(port_settings::HasSurface(skip->surfaces, port_settings::Surface::PcOverlay));

    EXPECT_EQ(port_settings::FindByRetailRow(OPTION_ITEM_UNK_9), debug);
    EXPECT_EQ(port_settings::FindByRetailRow(OPTION_ITEM_SKIP_INTRO), skip);
}

TEST(PortSettingsRegistry, PcOverlayPageCountMatchesPagesBuilder) {
    EXPECT_EQ(port_settings::PcOverlayPageCount(), 6);
    EXPECT_EQ(port_settings::PcOverlayPageNames().size(), 6u);
    EXPECT_STREQ(port_settings::PcOverlayPageNames().back(), "Georama");
}

TEST(PortSettingsRegistry, GeoramaPolyMultiplierRegisteredOnPcOverlay) {
    const auto *entry = port_settings::FindByConfigKey("game.georama_poly_multiplier");
    ASSERT_NE(entry, nullptr);
    EXPECT_EQ(entry->kind, port_settings::Kind::Int);
    EXPECT_TRUE(port_settings::HasSurface(entry->surfaces, port_settings::Surface::PcOverlay));
}

TEST(PortSettingsRetail, DebugRowVisibleBandMatchesOptionScroll) {
    constexpr int row = OPTION_ITEM_UNK_9;
    for (int top = 0; top < 20; ++top) {
        const bool visible = port_settings::RetailRowVisible(row, top);
        const bool expected = row >= top && row < top + port_settings::kRetailVisibleRows;
        EXPECT_EQ(visible, expected) << "top=" << top;
    }
    EXPECT_TRUE(port_settings::RetailRowVisible(row, 1));
    EXPECT_FALSE(port_settings::RetailRowVisible(row, 0));
    EXPECT_FALSE(port_settings::RetailRowVisible(row, 10));
}

TEST(PortSettingsRetail, SkipIntroRowUsesSyntheticLabelColumn) {
    constexpr int row = OPTION_ITEM_SKIP_INTRO;
    EXPECT_GE(row, port_settings::kRetailVisibleRows);
    const int line_id = PortRetailSyntheticSysMesId(row);
    EXPECT_EQ(line_id, 0x7F00 + row);
}

TEST(PortSettingsRetail, SystemMessageOverrideStartsEmpty) {
    PortRetailClearSystemMessageOverrides();
    const int line_id = PortRetailSyntheticSysMesId(OPTION_ITEM_UNK_9);
    EXPECT_EQ(PortRetailSystemMessageOverride(line_id), nullptr);
    EXPECT_EQ(PortRetailSystemMessageOverride(line_id + 1), nullptr);
}

TEST(PortSettingsRetail, SyntheticSysMesIdMatchesRetailRow) {
    EXPECT_EQ(PortRetailSyntheticSysMesId(OPTION_ITEM_UNK_9), 0x7F00 + OPTION_ITEM_UNK_9);
}
