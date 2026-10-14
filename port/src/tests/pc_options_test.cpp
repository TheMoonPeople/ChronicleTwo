#include <gtest/gtest.h>

#include <algorithm>
#include <set>
#include <string>

#include "options/rows.hpp"
#include "options/screen.hpp"
#include "platform/input.hpp"

namespace {
const options::Row &Find(std::string_view key) {
    for (const auto &page : options::Pages()) {
        for (const auto &row : page.rows) {
            if (row.key == key) {
                return row;
            }
        }
    }
    throw std::runtime_error("Missing settings row");
}
} // namespace

TEST(PcOptions, RequestedSettingsHaveUniqueRowsAndRoundTripTheirEdits) {
    const std::set<std::string> required{
        "video.fullscreen",
        "video.width",
        "video.present_mode",
        "video.max_fps",
        "video.interpolation",
        "video.aspect",
        "video.ui_scale",
        "video.show_fps",
        "audio.master_volume",
        "audio.soundtrack",
        "input.mouse_sensitivity",
        "input.mouse_invert_y",
        "input.mouse_capture",
        "input.mouse_zoom",
        "input.mouse_fixed_look",
        "input.stick_sensitivity",
        "input.stick_invert_x",
        "input.stick_invert_y",
        "input.glyphs",
        "input.glyph_device",
    };
    std::set<std::string> actual;
    for (const auto &page : options::Pages()) {
        for (const auto &row : page.rows) {
            ASSERT_TRUE(actual.insert(row.key).second) << row.key;
            ASSERT_FALSE(row.help.empty()) << row.key;
            if (!row.step) {
                continue;
            }
            Config config;
            ASSERT_TRUE(options::StepRow(row, config, 1) || options::StepRow(row, config, -1)) << row.key;
            EXPECT_NE(config, Config{}) << row.key;
            EXPECT_EQ(ConfigParse(ConfigSerialize(config)), config) << row.key;
            EXPECT_FALSE(config.debug_mode);
            EXPECT_DOUBLE_EQ(config.tick_rate, 60);
        }
    }
    for (const auto &key : required) {
        EXPECT_TRUE(actual.contains(key)) << key;
    }
}

TEST(PcOptions, CustomNumbersMoveToAdjacentPresetsWithoutChangingOtherSettings) {
    Config config;
    config.max_fps = 137;
    config.mouse_sensitivity = .123f;
    const auto &cap = Find("video.max_fps");
    EXPECT_EQ(cap.value(config), "137 FPS");
    EXPECT_TRUE(options::StepRow(cap, config, 1));
    EXPECT_EQ(config.max_fps, 144);
    EXPECT_FLOAT_EQ(config.mouse_sensitivity, .123f);
    config.max_fps = 137;
    EXPECT_TRUE(options::StepRow(cap, config, -1));
    EXPECT_EQ(config.max_fps, 120);
    config.max_fps = 0;
    EXPECT_FALSE(options::StepRow(cap, config, -1));
    EXPECT_EQ(cap.value(config), "Unlimited");
}

TEST(PcOptions, BooleanAndEnumChoicesWrapInBothDirections) {
    Config config;
    EXPECT_TRUE(options::StepRow(Find("video.fullscreen"), config, -1));
    EXPECT_TRUE(config.fullscreen);
    EXPECT_TRUE(options::StepRow(Find("video.fullscreen"), config, 1));
    EXPECT_FALSE(config.fullscreen);
    EXPECT_TRUE(options::StepRow(Find("video.present_mode"), config, -1));
    EXPECT_EQ(config.present_mode, ConfigPresentMode::Immediate);
    EXPECT_TRUE(options::StepRow(Find("video.present_mode"), config, 1));
    EXPECT_EQ(config.present_mode, ConfigPresentMode::Fifo);
}

TEST(PcOptions, ResolutionsKeepDesktopAndCustomSizeAndDeduplicateDisplayModes) {
    const DisplayModeSize modes[]{
        {1920, 1080},
        {1920, 1080},
        {2560, 1440},
        {320,  200 }
    };
    const auto sizes = options::ResolutionList(modes, 1234, 789);
    EXPECT_EQ(sizes.front().width, 0);
    EXPECT_EQ(sizes.front().height, 0);
    EXPECT_EQ(std::ranges::count_if(sizes, [](auto s) { return s.width == 1920 && s.height == 1080; }), 1);
    EXPECT_TRUE(std::ranges::any_of(sizes, [](auto s) { return s.width == 1234 && s.height == 789; }));
    EXPECT_FALSE(std::ranges::any_of(sizes, [](auto s) { return s.width == 320; }));
}

TEST(PcOptions, LongBindingPageScrollsAndEachTabKeepsItsCursor) {
    options::State state;
    state.open = true;
    options::SelectPage(state, 3);
    for (int n = 0; n < 12; ++n) {
        options::MoveRow(state, 1);
    }
    EXPECT_EQ(state.row[3], 12);
    EXPECT_EQ(state.first[3], 5);
    options::SelectPage(state, 0);
    EXPECT_EQ(state.row[0], 0);
    options::MoveRow(state, -1);
    EXPECT_EQ(state.row[0], 0);
    options::SelectPage(state, -1);
    EXPECT_EQ(state.page, 3);
    EXPECT_EQ(state.row[3], 12);
    EXPECT_EQ(state.first[3], 5);
    for (int n = 0; n < 100; ++n) {
        options::MoveRow(state, 1);
    }
    EXPECT_EQ(state.row[3], options::Pages()[3].rows.size() - 1);
    for (int n = 0; n < 100; ++n) {
        options::MoveRow(state, -1);
    }
    EXPECT_EQ(state.first[3], 0);
}

TEST(PcOptions, HitTestingUsesVisibleRowsAndHasNoDeadRowsOrOutOfBoundsHits) {
    options::State state;
    EXPECT_EQ(options::HitTest(state, 300, 60).kind, options::HitKind::Entry);
    EXPECT_EQ(options::HitTest(state, 300, 180).kind, options::HitKind::None);
    state.open = true;
    EXPECT_EQ(options::HitTest(state, 82, 91).index, 0);
    EXPECT_EQ(options::HitTest(state, 370, 100).index, 3);
    EXPECT_EQ(options::HitTest(state, 288, 120).direction, -1);
    EXPECT_EQ(options::HitTest(state, 420, 120).direction, 1);
    EXPECT_EQ(options::HitTest(state, 440, 120).kind, options::HitKind::None);
    EXPECT_EQ(options::HitTest(state, 84, 352).kind, options::HitKind::Back);
    options::SelectPage(state, 1);
    EXPECT_EQ(options::HitTest(state, 300, 180).kind, options::HitKind::None);
    options::SelectPage(state, 3);
    state.first[3] = 7;
    EXPECT_EQ(options::HitTest(state, 300, 120).index, 7);
    EXPECT_EQ(options::HitTest(state, 300, 300).index, 14);
    EXPECT_EQ(options::HitTest(state, 300, 352).kind, options::HitKind::ResetBinding);
    state.binding = 7;
    EXPECT_EQ(options::HitTest(state, 300, 100).kind, options::HitKind::None);
    EXPECT_EQ(options::HitTest(state, 100, 352).kind, options::HitKind::Back);
}

TEST(PcOptions, PointerUsesUiScaleLetterboxingAndHighDpiMapping) {
    // 2560x1440 pixels in a 1280x720 window, UI 0.75, 4:3 logical image centered.
    gfx::LogicalMapping mapping{2.8125f, 2.25f, 560, 180, 2560, 1440};
    const float         x = (300 * mapping.scale_x + mapping.offset_x) / 2;
    const float         y = (160 * mapping.scale_y + mapping.offset_y) / 2;
    auto                point = options::PointerToUi(x, y, 1280, 720, mapping);
    EXPECT_FLOAT_EQ(point.x, 300);
    EXPECT_FLOAT_EQ(point.y, 160);
    point = options::PointerToUi(0, 0, 0, 0, mapping);
    EXPECT_LT(point.x, 0);
}

TEST(PcOptions, StationaryPointerDoesNotUndoWheelOrPadNavigation) {
    options::State state;
    state.open = true;
    options::SelectPage(state, 3);
    const options::Point point{200, options::kRowY + 3 * options::kRowStep + 4};
    options::NavigatePointer(state, point, true, 0);
    EXPECT_EQ(state.row[3], 3);
    for (int n = 0; n < 15; ++n) {
        options::NavigatePointer(state, point, false, -1);
        options::NavigatePointer(state, point, false, 0);
    }
    EXPECT_EQ(state.row[3], 18);
    EXPECT_EQ(state.first[3], 11);
    options::MoveRow(state, -1);
    options::NavigatePointer(state, point, false, 0);
    EXPECT_EQ(state.row[3], 17);
}

TEST(PcOptions, HeldConfirmNeverRepeatsButNavigationDoes) {
    options::Repeat repeat;
    EXPECT_EQ(repeat.Step(kInputCross), kInputCross);
    for (int n = 0; n < 70; ++n) {
        EXPECT_EQ(repeat.Step(kInputCross), 0);
    }
    repeat.Reset();
    EXPECT_EQ(repeat.Step(kInputDown), kInputDown);
    for (int n = 2; n < 20; ++n) {
        EXPECT_EQ(repeat.Step(kInputDown), 0);
    }
    EXPECT_EQ(repeat.Step(kInputDown), kInputDown);
    repeat.Reset(kInputSelect);
    EXPECT_EQ(repeat.Step(kInputSelect), 0);
    repeat.Step(0);
    EXPECT_EQ(repeat.Step(kInputSelect), kInputSelect);
}

TEST(PcOptions, EscapeAndWholeAxesCannotBeBoundAndResetOnlyTouchesOneAction) {
    Config config;
    config.key_bindings = {
        {"circle", {"Q"}}
    };
    EXPECT_FALSE(options::SetBinding(config, "cross", "Escape"));
    EXPECT_FALSE(options::SetBinding(config, "cross", "ESCAPE"));
    EXPECT_FALSE(options::SetBinding(config, "cross", "not a key"));
    EXPECT_FALSE(options::SetBinding(config, "lx", "K"));
    EXPECT_FALSE(options::SetBinding(config, "missing", "K"));
    EXPECT_EQ(config.key_bindings.size(), 1);
    ASSERT_TRUE(options::SetBinding(config, "cross", "K"));
    ASSERT_TRUE(options::SetBinding(config, "cross", "Mouse3"));
    EXPECT_EQ(config.key_bindings.size(), 2);
    EXPECT_EQ(config.key_bindings[1].keys, std::vector<std::string>{"Mouse3"});
    options::ResetBinding(config, "cross");
    ASSERT_EQ(config.key_bindings.size(), 1);
    EXPECT_EQ(config.key_bindings[0].action, "circle");
}

TEST(PcOptions, CaptureSkipsItsOpeningKeyAndOnlyTakesNewPresses) {
    InputApplyConfig(Config{});
    InputKeyboardMouse devices;
    devices.keys = {InputScancodeFromName("Space")};
    InputSetScriptedDevices(devices);
    InputBeginBindCapture();
    EXPECT_TRUE(InputTakeBindKey(false).empty());
    InputSetScriptedDevices({});
    EXPECT_TRUE(InputTakeBindKey(false).empty());
    devices.keys = {InputScancodeFromName("K")};
    InputSetScriptedDevices(devices);
    const auto key = InputTakeBindKey(false);
    EXPECT_EQ(key, "K");
    Config config;
    EXPECT_TRUE(options::SetBinding(config, "cross", key));
    EXPECT_TRUE(InputBindSourceHeld(key));
    EXPECT_TRUE(InputTakeBindKey(false).empty());
    InputSetScriptedDevices({});
    EXPECT_FALSE(InputBindSourceHeld(key));
}

TEST(PcOptions, PromptsFollowBindingsAndControllerFamilyWithoutChangingPadActions) {
    Config config;
    config.glyph_device = ConfigGlyphDevice::Xbox;
    EXPECT_EQ(options::ButtonName("cross", config), "A");
    config.glyph_device = ConfigGlyphDevice::Switch;
    EXPECT_EQ(options::ButtonName("cross", config), "B");
    config.glyph_device = ConfigGlyphDevice::Keyboard;
    config.key_bindings = {
        {"cross", {"K"}}
    };
    InputApplyConfig(config);
    EXPECT_EQ(options::ButtonName("cross", config), "K");
    EXPECT_EQ(options::ButtonName("select", config), "Backspace");
    InputPadState pad;
    pad.connected = true;
    pad.buttons = kInputCross;
    EXPECT_EQ(InputApplyKeyboardMouse(pad, {}).buttons, kInputCross);
    config.glyphs_new = false;
    EXPECT_EQ(options::ButtonName("cross", config), "Cross");
}

TEST(PcOptions, ZoomResetHasAVisibleRebindableRow) {
    const auto &row = Find("input.bindings.zoom_reset");
    EXPECT_EQ(row.label, "Zoom reset");
    EXPECT_EQ(row.action, "zoom_reset");
    Config config;
    EXPECT_TRUE(options::SetBinding(config, row.action, "K"));
}

TEST(PcOptions, TimingRowIsAbsentAndOtherSettingsRemain) {
    EXPECT_EQ(options::Pages().size(), 4u);
    for (const auto &page : options::Pages()) {
        for (const auto &row : page.rows) {
            EXPECT_NE(row.key, "game.timing");
            EXPECT_NE(row.key, "game.tick_rate");
        }
    }
    Config config;
    EXPECT_TRUE(options::StepRow(Find("audio.master_volume"), config, -1));
    EXPECT_FLOAT_EQ(config.master_volume, 0.95f);
    EXPECT_TRUE(options::StepRow(Find("video.fullscreen"), config, 1));
    EXPECT_TRUE(config.fullscreen);
    EXPECT_DOUBLE_EQ(config.tick_rate, 60);
}
