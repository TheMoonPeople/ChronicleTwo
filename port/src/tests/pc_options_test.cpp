#include <gtest/gtest.h>

#include <algorithm>
#include <set>
#include <string>
#include <vector>

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
        "video.text_font",
        "video.show_fps",
        "audio.master_volume",
        "audio.soundtrack",
        "audio.dualsense_speaker",
        "audio.controller_volume",
        "input.mouse_sensitivity",
        "input.mouse_invert_y",
        "input.mouse_capture",
        "input.mouse_zoom",
        "input.mouse_fixed_look",
        "input.menu_pointer_speed",
        "input.menu_pointer_acceleration",
        "input.stick_sensitivity",
        "input.stick_invert_x",
        "input.stick_invert_y",
        "input.dualsense_haptics",
        "input.haptics_strength",
        "input.glyphs",
        "input.glyph_device",
        "game.autosave",
        "game.quick_loadout_title",
        "game.skip_intro",
        "game.auto_use_event_item",
        "game.floor_info_monsters",
        "game.more_monsters",
        "game.debug_mode",
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
            EXPECT_EQ(config.debug_mode, row.key == "game.debug_mode") << row.key;
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
        {.width = 1920, .height = 1080},
        {.width = 1920, .height = 1080},
        {.width = 2560, .height = 1440},
        {.width = 320,  .height = 200 }
    };
    const auto sizes = options::ResolutionList(modes, 1234, 789);
    EXPECT_EQ(sizes.front().width, 0);
    EXPECT_EQ(sizes.front().height, 0);
    EXPECT_EQ(std::ranges::count_if(sizes, [](auto s) { return s.width == 1920 && s.height == 1080; }), 1);
    EXPECT_TRUE(std::ranges::any_of(sizes, [](auto s) { return s.width == 1234 && s.height == 789; }));
    EXPECT_FALSE(std::ranges::any_of(sizes, [](auto s) { return s.width == 320; }));
}

TEST(PcOptions, OnlyATabChangeCountsAsATurn) {
    const int      pages = static_cast<int>(options::Pages().size());
    options::State state;
    state.open = true;
    EXPECT_TRUE(options::SelectPage(state, 1));
    EXPECT_TRUE(options::SelectPage(state, 0));
    EXPECT_TRUE(options::SelectPage(state, -1));
    EXPECT_EQ(state.page, pages - 1);
    EXPECT_TRUE(options::SelectPage(state, pages));
    EXPECT_EQ(state.page, 0);
    // Selecting the tab already shown is not a turn and stays silent.
    EXPECT_FALSE(options::SelectPage(state, 0));
}

TEST(PcOptions, LongBindingPageScrollsAndEachTabKeepsItsCursor) {
    options::State state;
    state.open = true;
    options::SelectPage(state, options::kBindingsPage);
    for (int n = 0; n < 12; ++n) {
        options::MoveRow(state, 1);
    }
    EXPECT_EQ(state.row[options::kBindingsPage], 12);
    EXPECT_EQ(state.first[options::kBindingsPage], 5);
    options::SelectPage(state, 0);
    EXPECT_EQ(state.row[0], 0);
    options::MoveRow(state, -1);
    EXPECT_EQ(state.row[0], 0);
    options::SelectPage(state, -1);
    EXPECT_EQ(state.page, options::kBindingsPage);
    EXPECT_EQ(state.row[options::kBindingsPage], 12);
    EXPECT_EQ(state.first[options::kBindingsPage], 5);
    for (int n = 0; n < 100; ++n) {
        options::MoveRow(state, 1);
    }
    EXPECT_EQ(state.row[options::kBindingsPage], options::Pages()[options::kBindingsPage].rows.size() - 1);
    for (int n = 0; n < 100; ++n) {
        options::MoveRow(state, -1);
    }
    EXPECT_EQ(state.first[options::kBindingsPage], 0);
}

TEST(PcOptions, HitTestingUsesVisibleRowsAndHasNoDeadRowsOrOutOfBoundsHits) {
    options::State state;
    EXPECT_EQ(options::HitTest(state, 300, 60).kind, options::HitKind::Entry);
    EXPECT_EQ(options::HitTest(state, 300, 180).kind, options::HitKind::None);
    state.open = true;
    EXPECT_EQ(options::HitTest(state, 82, 91).index, 0);
    EXPECT_EQ(options::HitTest(state, 370, 100).index, options::kBindingsPage);
    EXPECT_EQ(options::HitTest(state, 288, 120).direction, -1);
    EXPECT_EQ(options::HitTest(state, 420, 120).direction, 1);
    EXPECT_EQ(options::HitTest(state, 440, 120).kind, options::HitKind::None);
    EXPECT_EQ(options::HitTest(state, 84, 352).kind, options::HitKind::Back);
    options::SelectPage(state, 1);
    const auto audio_rows = static_cast<int>(options::Pages()[1].rows.size());
    EXPECT_EQ(options::HitTest(state, 300, options::kRowY + (audio_rows - 1) * options::kRowStep).index, audio_rows - 1);
    EXPECT_EQ(options::HitTest(state, 300, options::kRowY + audio_rows * options::kRowStep).kind, options::HitKind::None);
    options::SelectPage(state, options::kBindingsPage - 1);
    const auto game_rows = static_cast<int>(options::Pages()[options::kBindingsPage - 1].rows.size());
    EXPECT_EQ(options::HitTest(state, 300, options::kRowY + game_rows * options::kRowStep).kind, options::HitKind::None);
    options::SelectPage(state, options::kBindingsPage);
    state.first[options::kBindingsPage] = 7;
    EXPECT_EQ(options::HitTest(state, 300, 120).index, 7);
    EXPECT_EQ(options::HitTest(state, 300, 300).index, 14);
    EXPECT_EQ(options::HitTest(state, 300, 352).kind, options::HitKind::ResetBinding);
    state.binding = 7;
    EXPECT_EQ(options::HitTest(state, 300, 100).kind, options::HitKind::None);
    EXPECT_EQ(options::HitTest(state, 100, 352).kind, options::HitKind::Back);
}

TEST(PcOptions, PointerUsesUiScaleLetterboxingAndHighDpiMapping) {
    // 2560x1440 pixels in a 1280x720 window, UI 0.75, 4:3 logical image centered.
    gfx::LogicalMapping mapping{.scale_x = 2.8125f, .scale_y = 2.25f, .offset_x = 560, .offset_y = 180, .pixel_width = 2560, .pixel_height = 1440};
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
    options::SelectPage(state, options::kBindingsPage);
    const options::Point point{.x = 200, .y = options::kRowY + 3 * options::kRowStep + 4};
    options::NavigatePointer(state, point, true, 0);
    EXPECT_EQ(state.row[options::kBindingsPage], 3);
    for (int n = 0; n < 15; ++n) {
        options::NavigatePointer(state, point, false, -1);
        options::NavigatePointer(state, point, false, 0);
    }
    EXPECT_EQ(state.row[options::kBindingsPage], 18);
    EXPECT_EQ(state.first[options::kBindingsPage], 11);
    options::MoveRow(state, -1);
    options::NavigatePointer(state, point, false, 0);
    EXPECT_EQ(state.row[options::kBindingsPage], 17);
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
        {.action = "circle", .keys = {"Q"}}
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
        {.action = "cross", .keys = {"K"}}
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
    EXPECT_EQ(options::Pages().size(), static_cast<std::size_t>(options::kPages));
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

namespace {
// The UI scales the PC page offers, smallest first.
std::vector<float> OfferedUiScales() {
    const auto        &row = Find("video.ui_scale");
    Config             config;
    std::vector<float> scales;
    while (options::StepRow(row, config, -1)) {
    }
    do {
        scales.push_back(config.ui_scale);
    } while (options::StepRow(row, config, 1));
    return scales;
}

// Where a page point lands in logical units once the UI scale scales the view's output.
options::Point Logical(const options::View &view, options::Point page, float ui_scale) {
    const auto ui = view.ToUi(page);
    return {.x = view.centre_x + (ui.x - view.centre_x) * ui_scale, .y = view.centre_y + (ui.y - view.centre_y) * ui_scale};
}
} // namespace

TEST(PcOptions, EntryAndPageFitAtEveryOfferedUiScaleAndWindowShape) {
    const auto scales = OfferedUiScales();
    ASSERT_EQ(scales.front(), 0.5f);
    ASSERT_EQ(scales.back(), 1.5f);
    const gfx::LogicalRect frame{.x = 0, .y = 0, .w = 512, .h = 480};
    // 4:3 (letterboxed or not), 16:9 and 5:4 windows.
    const gfx::LogicalRect windows[] = {
        {.x = 0,         .y = 0,   .w = 512,       .h = 480},
        {.x = -85.3333f, .y = 0,   .w = 682.6667f, .h = 480},
        {.x = 0,         .y = -16, .w = 512,       .h = 512},
    };
    for (const auto &visible : windows) {
        for (const auto &bounds : {options::kEntryBounds, options::kPageBounds}) {
            for (const float scale : scales) {
                const auto view = options::FitView(bounds, visible, frame, scale);
                EXPECT_LE(view.scale, 1.0f);
                if (scale <= 1.1f) {
                    EXPECT_EQ(view.scale, 1.0f) << scale;
                }
                for (const float x : {bounds.x, bounds.x + bounds.w}) {
                    for (const float y : {bounds.y, bounds.y + bounds.h}) {
                        const auto at = Logical(view, {.x = x, .y = y}, scale);
                        EXPECT_GE(at.x, visible.x - 1e-3f) << scale;
                        EXPECT_LE(at.x, visible.x + visible.w + 1e-3f) << scale;
                        EXPECT_GE(at.y, visible.y - 1e-3f) << scale;
                        EXPECT_LE(at.y, visible.y + visible.h + 1e-3f) << scale;
                    }
                }
                // Shrunk no further than the window needs.
                const float drawn = view.scale * scale;
                EXPECT_NEAR(options::FitView(bounds, visible, frame, drawn).scale, 1.0f, 1e-5f);
                if (view.scale < 1.0f) {
                    EXPECT_LT(options::FitView(bounds, visible, frame, drawn * 1.01f).scale, 1.0f);
                }
            }
        }
    }
}

TEST(PcOptions, FittedEntryAndBackStayClickableAtTheLargestUiScale) {
    // 1920x1080 at 4:3, UI 150%: the UI mapping of the letterboxed 512x480 frame.
    const gfx::LogicalMapping ui{.scale_x = 2.8125f * 1.5f,
                                 .scale_y = 2.25f * 1.5f,
                                 .offset_x = -120,
                                 .offset_y = -270,
                                 .pixel_width = 1920,
                                 .pixel_height = 1080};
    const gfx::LogicalRect    frame{.x = 0, .y = 0, .w = 512, .h = 480};
    const auto                in_window = [&](options::Point at) {
        const float x = at.x * ui.scale_x + ui.offset_x;
        const float y = at.y * ui.scale_y + ui.offset_y;
        return x >= 0 && x < 1920 && y >= 0 && y < 1080;
    };
    options::State       state;
    const options::Point entry{.x = 364, .y = 63};
    ASSERT_EQ(options::HitTest(state, entry.x, entry.y).kind, options::HitKind::Entry);
    // Unfitted, the entry lies above the window.
    EXPECT_FALSE(in_window(entry));
    auto view = options::FitView(options::kEntryBounds, frame, frame, 1.5f);
    EXPECT_LT(view.scale, 1.0f);
    auto at = view.ToUi(entry);
    ASSERT_TRUE(in_window(at));
    // A click there, mapped back through the window and the view, is on the entry.
    auto ui_point = options::PointerToUi(at.x * ui.scale_x + ui.offset_x, at.y * ui.scale_y + ui.offset_y, 1920, 1080, ui);
    auto page = view.ToPage(ui_point);
    EXPECT_EQ(options::HitTest(state, page.x, page.y).kind, options::HitKind::Entry);

    state.open = true;
    const options::Point back{.x = options::kLeft + 50, .y = 356};
    ASSERT_EQ(options::HitTest(state, back.x, back.y).kind, options::HitKind::Back);
    view = options::FitView(options::kPageBounds, frame, frame, 1.5f);
    at = view.ToUi(back);
    ASSERT_TRUE(in_window(at));
    ui_point = options::PointerToUi(at.x * ui.scale_x + ui.offset_x, at.y * ui.scale_y + ui.offset_y, 1920, 1080, ui);
    page = view.ToPage(ui_point);
    EXPECT_EQ(options::HitTest(state, page.x, page.y).kind, options::HitKind::Back);
}

TEST(PcOptions, FittedTabsLandInsideTheWindowAtTheLargestUiScale) {
    const float            scale = OfferedUiScales().back();
    const gfx::LogicalRect frame{.x = 0, .y = 0, .w = 512, .h = 480};
    // Unfitted, the outer tabs cross a 4:3 window's sides.
    const options::View unfitted{.centre_x = 256, .centre_y = 240, .scale = 1};
    ASSERT_LT(Logical(unfitted, {.x = options::kLeft, .y = 91}, scale).x, frame.x);
    ASSERT_GT(Logical(unfitted, {.x = options::kRight, .y = 91}, scale).x, frame.x + frame.w);
    // 1920x1080 at 4:3 and 16:9, whose UI mapping is the same, in a 960x540 window as on a high-DPI display.
    const gfx::LogicalMapping ui{.scale_x = 2.8125f * scale,
                                 .scale_y = 2.25f * scale,
                                 .offset_x = 960 - 256 * 2.8125f * scale,
                                 .offset_y = 540 - 240 * 2.25f * scale,
                                 .pixel_width = 1920,
                                 .pixel_height = 1080};
    const gfx::LogicalRect    windows[] = {
        frame,
        {.x = -85.3333f, .y = 0, .w = 682.6667f, .h = 480},
    };
    options::State state;
    state.open = true;
    for (const auto &visible : windows) {
        SCOPED_TRACE(visible.w);
        const auto view = options::FitView(options::kPageBounds, visible, frame, scale);
        for (int tab = 0; tab < options::kPages; ++tab) {
            SCOPED_TRACE(tab);
            const float left = options::kLeft + tab * options::kTabStep;
            for (const float x : {left, left + options::kTabStep}) {
                for (const float y : {91.0f, 114.0f}) {
                    const auto at = Logical(view, {.x = x, .y = y}, scale);
                    EXPECT_GE(at.x, visible.x);
                    EXPECT_LE(at.x, visible.x + visible.w);
                    EXPECT_GE(at.y, visible.y);
                    EXPECT_LE(at.y, visible.y + visible.h);
                }
            }
            // A click on the drawn tab, mapped back through the window and the view, is on that tab.
            const auto at = view.ToUi({.x = left + options::kTabStep / 2.0f, .y = 102});
            const auto page = view.ToPage(options::PointerToUi((at.x * ui.scale_x + ui.offset_x) / 2,
                                                               (at.y * ui.scale_y + ui.offset_y) / 2, 960, 540, ui));
            const auto hit = options::HitTest(state, page.x, page.y);
            EXPECT_EQ(hit.kind, options::HitKind::Tab);
            EXPECT_EQ(hit.index, tab);
        }
    }
}
