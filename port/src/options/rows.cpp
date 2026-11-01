#include "options/rows.hpp"

#include <algorithm>
#include <array>
#include <cmath>
#include <format>
#include <iterator>
#include <ranges>
#include <string_view>
#include <type_traits>
#include <utility>

#include "platform/input.hpp"

namespace options {
namespace {

// {0, 0} is the desktop size.
constexpr std::array<DisplayModeSize, 6> kPresetSizes{
    {{.width = 0, .height = 0},
     {.width = 800, .height = 600},
     {.width = 1024, .height = 768},
     {.width = 1280, .height = 720},
     {.width = 1280, .height = 960},
     {.width = 1920, .height = 1080}}
};

std::vector<DisplayModeSize> g_sizes(kPresetSizes.begin(), kPresetSizes.end());

template <auto Member>
Row Choice(const char *key, const char *label, const char *help, const std::vector<std::string> &names) {
    using Value = std::remove_cvref_t<decltype(Config{}.*Member)>;
    Row row{.key = key, .label = label, .help = help};
    row.value = [names](const Config &c) { return names.at(static_cast<int>(c.*Member)); };
    row.step = [names](Config &c, int direction) {
        const int n = static_cast<int>(names.size());
        c.*Member = static_cast<Value>((static_cast<int>(c.*Member) + direction + n) % n);
    };
    return row;
}

template <auto Member>
Row Number(const char *key, const char *label, const char *help, const std::vector<double> &values,
           double display_scale = 1.0, const char *suffix = "") {
    Row row{.key = key, .label = label, .help = help};
    row.value = [display_scale, suffix](const Config &c) {
        const double n = c.*Member;
        if (n == 0 && std::string_view(suffix) == " FPS") {
            return std::string("Unlimited");
        }
        return std::format("{:.3g}{}", n * display_scale, suffix);
    };
    row.step = [values](Config &c, int direction) {
        // Preserve a hand-edited value until this row is changed. Move to the next preset,
        // rather than rounding first and skipping a value on either side of it.
        const double current = c.*Member;
        if (direction > 0) {
            for (double n : values) {
                if (n > current + 0.00001) {
                    c.*Member = n;
                    return;
                }
            }
        } else {
            for (double value : std::views::reverse(values)) {
                if (value < current - 0.00001) {
                    c.*Member = value;
                    return;
                }
            }
        }
    };
    return row;
}

// V-Sync on presents in FIFO order; off presents at once and may tear.
Row VSync() {
    Row row{.key = "video.vsync", .label = "V-Sync", .help = "On prevents tearing.\nOff shows each frame at once and may tear."};
    row.value = [](const Config &c) { return std::string(c.present_mode == ConfigPresentMode::Fifo ? "On" : "Off"); };
    row.step = [](Config &c, int) {
        c.present_mode = c.present_mode == ConfigPresentMode::Fifo ? ConfigPresentMode::Immediate : ConfigPresentMode::Fifo;
    };
    return row;
}

Row Resolution() {
    Row row{.key = "video.width", .label = "Resolution", .help = "Window size. Fullscreen uses the desktop.\nCommand-line --window overrides this setting."};
    row.value = [](const Config &c) {
        if (c.window_width == 0 && c.window_height == 0) {
            return std::string("Desktop");
        }
        return std::format("{} x {}", c.window_width, c.window_height);
    };
    row.step = [](Config &c, int direction) {
        auto       sizes = ResolutionList(g_sizes, c.window_width, c.window_height);
        const auto it = std::ranges::find_if(sizes, [&](auto s) {
            return s.width == c.window_width && s.height == c.window_height;
        });
        const int  index = it == sizes.end() ? 0 : static_cast<int>(it - sizes.begin());
        auto       next = sizes[(index + direction + sizes.size()) % sizes.size()];
        c.window_width = next.width;
        c.window_height = next.height;
    };
    return row;
}

/**
 * Names a binding action for the settings pages.
 */
std::string ActionLabel(std::string_view action) {
    static constexpr std::pair<std::string_view, const char *> names[] = {
        {"cross",           "Cross"          },
        {"circle",          "Circle"         },
        {"square",          "Square"         },
        {"triangle",        "Triangle"       },
        {"up",              "D-pad Up"       },
        {"down",            "D-pad Down"     },
        {"left",            "D-pad Left"     },
        {"right",           "D-pad Right"    },
        {"start",           "Start"          },
        {"select",          "Select"         },
        {"l1",              "L1"             },
        {"r1",              "R1"             },
        {"l2",              "L2"             },
        {"r2",              "R2"             },
        {"l3",              "L3"             },
        {"r3",              "R3"             },
        {"lx-",             "Move left"      },
        {"lx+",             "Move right"     },
        {"ly-",             "Move forward"   },
        {"ly+",             "Move back"      },
        {"rx-",             "Look left"      },
        {"rx+",             "Look right"     },
        {"ry-",             "Look up"        },
        {"ry+",             "Look down"      },
        {"walk",            "Walk"           },
        {"zoom_reset",      "Zoom reset"     },
        {"fps_toggle",      "Toggle FPS"     },
        {"debug_menu",      "Developer menu" },
        {"mode_debug_menu", "Debug menu (R3)"},
        {"gyro_hold",       "Gyro hold"      },
        {"quick_loadout",   "Quick loadout"  },
    };
    for (auto [name, text] : names) {
        if (action == name) {
            return text;
        }
    }
    return std::string(action);
}

std::vector<Row> Bindings() {
    std::vector<Row> rows;
    for (const auto &info : InputActions()) {
        if (info.whole_axis) {
            continue;
        }
        // These host actions have no game-side consumer in this port, or none from a keyboard.
        if (info.action == "developer_menu" || info.action == "gyro_hold") {
            continue;
        }
        std::string action(info.action);
        rows.push_back({.key = "input.bindings." + action, .label = ActionLabel(action), .help = "Confirm, then press a key or mouse button.\nEscape cancels. Square restores this binding.", .value = [action](const Config &) { return InputBindingLabel(action); }, .step = {}, .action = action});
    }
    return rows;
}

/**
 * Names a physical controller button for each supported layout family.
 */
struct PadButtonNames {
    std::string_view button;      /**< Identifies the SDL controller button. */
    const char      *playstation; /**< Names the button on a PlayStation controller. */
    const char      *xbox;        /**< Names the button on an Xbox controller. */
    const char      *nintendo;    /**< Names the button on a Nintendo controller. */
};

// By SDL's names, which are the places of a pad with the Xbox layout: on a Nintendo pad the bottom button is B.
// clang-format off
constexpr PadButtonNames kPadButtonNames[] = {
    {.button = "a", .playstation = "Cross", .xbox = "A", .nintendo = "B"},
    {.button = "b", .playstation = "Circle", .xbox = "B", .nintendo = "A"},
    {.button = "x", .playstation = "Square", .xbox = "X", .nintendo = "Y"},
    {.button = "y", .playstation = "Triangle", .xbox = "Y", .nintendo = "X"},
    {.button = "back", .playstation = "Share", .xbox = "View", .nintendo = "Minus"},
    {.button = "guide", .playstation = "PS", .xbox = "Guide", .nintendo = "Home"},
    {.button = "start", .playstation = "Options", .xbox = "Menu", .nintendo = "Plus"},
    {.button = "leftstick", .playstation = "L3", .xbox = "LS", .nintendo = "LS"},
    {.button = "rightstick", .playstation = "R3", .xbox = "RS", .nintendo = "RS"},
    {.button = "leftshoulder", .playstation = "L1", .xbox = "LB", .nintendo = "L"},
    {.button = "rightshoulder", .playstation = "R1", .xbox = "RB", .nintendo = "R"},
    {.button = "lefttrigger", .playstation = "L2", .xbox = "LT", .nintendo = "ZL"},
    {.button = "righttrigger", .playstation = "R2", .xbox = "RT", .nintendo = "ZR"},
    {.button = "dpup", .playstation = "D-pad Up", .xbox = "D-pad Up", .nintendo = "D-pad Up"},
    {.button = "dpdown", .playstation = "D-pad Down", .xbox = "D-pad Down", .nintendo = "D-pad Down"},
    {.button = "dpleft", .playstation = "D-pad Left", .xbox = "D-pad Left", .nintendo = "D-pad Left"},
    {.button = "dpright", .playstation = "D-pad Right", .xbox = "D-pad Right", .nintendo = "D-pad Right"},
    {.button = "touchpad", .playstation = "Touchpad", .xbox = "Touchpad", .nintendo = "Touchpad"},
    {.button = "misc1", .playstation = "Mute", .xbox = "Share", .nintendo = "Capture"},
    {.button = "paddle1", .playstation = "Paddle 1", .xbox = "Paddle 1", .nintendo = "Paddle 1"},
    {.button = "paddle2", .playstation = "Paddle 2", .xbox = "Paddle 2", .nintendo = "Paddle 2"},
    {.button = "paddle3", .playstation = "Paddle 3", .xbox = "Paddle 3", .nintendo = "Paddle 3"},
    {.button = "paddle4", .playstation = "Paddle 4", .xbox = "Paddle 4", .nintendo = "Paddle 4"},
    {.button = "misc2", .playstation = "Misc 2", .xbox = "Misc 2", .nintendo = "Misc 2"},
    {.button = "misc3", .playstation = "Misc 3", .xbox = "Misc 3", .nintendo = "Misc 3"},
    {.button = "misc4", .playstation = "Misc 4", .xbox = "Misc 4", .nintendo = "Misc 4"},
    {.button = "misc5", .playstation = "Misc 5", .xbox = "Misc 5", .nintendo = "Misc 5"},
    {.button = "misc6", .playstation = "Misc 6", .xbox = "Misc 6", .nintendo = "Misc 6"},
};
// clang-format on

/**
 * Finds the display names of a physical controller button.
 */
const PadButtonNames *FindPadButton(std::string_view button) {
    for (const auto &names : kPadButtonNames) {
        if (names.button == button) {
            return &names;
        }
    }
    return nullptr;
}

/**
 * Builds settings rows for controller buttons and host actions.
 */
std::vector<Row> PadBindings() {
    std::vector<Row> rows;
    for (const auto &info : InputActions()) {
        // The developer menu has no consumer in this port, and zoom reset belongs to the mouse wheel's zoom.
        if (!info.pad || info.action == "developer_menu" || info.action == "zoom_reset") {
            continue;
        }
        std::string action(info.action);
        const auto  value = [action](const Config &config) {
            std::string text;
            for (const std::string &button : InputPadBindingNames(action)) {
                text += (text.empty() ? "" : ", ") + PadButtonName(button, config);
            }
            return text.empty() ? std::string("None") : text;
        };
        rows.push_back({.key = "input.gamepad_bindings." + action, .label = ActionLabel(action), .help = "Confirm, then press a controller button. Escape or\nfive seconds cancels. Square restores this binding.", .value = value, .step = {}, .action = action, .pad = true});
    }
    return rows;
}

/**
 * Reports whether an action owns a gamepad button rather than a shared host shortcut.
 */
bool PadButtonAction(std::string_view action) {
    const auto actions = InputActions();
    const auto known = std::ranges::find(actions, action, &InputActionInfo::action);
    return known != actions.end() && known->pad && !known->host;
}

/**
 * Returns an action's configured or active controller buttons.
 */
std::vector<std::string> PadNames(const Config &config, std::string_view action) {
    const auto it = std::ranges::find(config.pad_bindings, action, &ConfigKeyBinding::action);
    return it != config.pad_bindings.end() ? it->keys : InputPadBindingNames(action);
}

/**
 * Stores an action's controller buttons in the pending configuration.
 */
void SetPadNames(Config &config, std::string_view action, std::vector<std::string> names) {
    auto it = std::ranges::find(config.pad_bindings, action, &ConfigKeyBinding::action);
    if (it == config.pad_bindings.end()) {
        config.pad_bindings.push_back({.action = std::string(action), .keys = std::move(names)});
    } else {
        it->keys = std::move(names);
    }
}

/**
 * Moves conflicting pad-button bindings to the replaced buttons when a binding is reassigned.
 */
void TakeFromOthers(Config &config, std::string_view action, const std::vector<std::string> &taken,
                    const std::vector<std::string> &previous) {
    if (!PadButtonAction(action)) {
        return;
    }
    const auto is_taken = [&](const std::string &name) { return std::ranges::find(taken, name) != taken.end(); };
    for (const auto &info : InputActions()) {
        if (info.action == action || !PadButtonAction(info.action)) {
            continue;
        }
        auto names = PadNames(config, info.action);
        if (std::erase_if(names, is_taken) == 0) {
            continue;
        }
        if (names.empty()) {
            std::ranges::copy_if(previous, std::back_inserter(names), [&](const std::string &name) { return !is_taken(name); });
        }
        SetPadNames(config, info.action, std::move(names));
    }
}

// The rows kAppPage leaves out.
bool PcOnly(std::string_view key) {
    static constexpr std::string_view keys[] = {
#ifdef __SWITCH__
        "video.interpolation",
        "video.aspect",
        "video.max_fps",
#endif
        "video.fullscreen",
        "video.width",
        "video.vsync",
        "audio.dualsense_speaker",
        "audio.controller_volume",
        "input.mouse_sensitivity",
        "input.mouse_invert_y",
        "input.mouse_capture",
        "input.menu_pointer_speed",
        "input.menu_pointer_acceleration",
        "input.mouse_zoom",
        "input.mouse_fixed_look",
    };
    return std::ranges::find(keys, key) != std::end(keys);
}

std::vector<Page> MakePages() {
    std::vector<Page> pages{
        {.name = "Display",  .rows = {
                                Choice<&Config::fullscreen>("video.fullscreen", "Window mode", "Applies immediately. Fullscreen uses the desktop.", {"Windowed", "Fullscreen"}),
                                Resolution(),
                                VSync(),
                                Number<&Config::max_fps>("video.max_fps", "Frame cap", "Limits display frames, not game speed.", {0, 30, 50, 60, 75, 90, 100, 120, 144, 165, 180, 240, 360}, 1, " FPS"),
                                Choice<&Config::interpolation>("video.interpolation", "Interpolation", "Smooths display frames between game ticks.", {"Off", "On"}),
                                Choice<&Config::aspect>("video.aspect", "Aspect ratio", "Auto fills the window. 4:3 adds black side bars.", {"Auto", "4:3"}),
                                Number<&Config::ui_scale>("video.ui_scale", "UI scale", "Scales menus and HUD. Large values can crop the UI.\nUse Left to reduce the scale if it no longer fits.", {0.5, 0.65, 0.75, 0.85, 1, 1.1, 1.25, 1.5}, 100, "%"),
                                Choice<&Config::font_sharp>("video.text_font", "Text font", "Sharp draws the letters as outlines, clear at any\n"
                                                                                            "resolution, each spaced by its own width.",
                                                            {"Original", "Sharp"}),
                                Choice<&Config::show_fps>("video.show_fps", "Show FPS", "Shows the display and tick rates in a window.", {"Off", "On"}),
                            }  },
        {.name = "Audio",    .rows = {
                              Number<&Config::master_volume>("audio.master_volume", "Master volume", "Adjusts all sound, including music and movies.", {0, .05, .1, .15, .2, .25, .3, .35, .4, .45, .5, .55, .6, .65, .7, .75, .8, .85, .9, .95, 1}, 100, "%"),
                              Choice<&Config::soundtrack>("audio.soundtrack", "Soundtrack", "Applies when the next song starts; no restart needed.\nCustom needs soundtrack/soundtrack.json recordings.", {"PS2", "Custom"}),
                              Choice<&Config::dualsense_speaker>("audio.dualsense_speaker", "DualSense Speaker", "Plays sound effects on a DualSense controller speaker.\nTurn off if you want to keep vanilla experience", {"Off", "On"}),
                              Number<&Config::controller_volume>("audio.controller_volume", "Controller volume", "DualSense speaker volume, after master volume.", {0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1, 1.25, 1.5, 1.75, 2}, 100, "%"),
                          }      },
        {.name = "Controls", .rows = {
                                 Number<&Config::mouse_sensitivity>("input.mouse_sensitivity", "Mouse sensitivity", "Camera turn per count of mouse movement.", {.01, .025, .05, .075, .1, .15, .2, .3, .5, .75, 1}),
                                 Choice<&Config::mouse_invert_y>("input.mouse_invert_y", "Invert mouse Y", "Reverses vertical mouse look.", {"Off", "On"}),
                                 Choice<&Config::mouse_capture>("input.mouse_capture", "Capture mouse", "Keeps the pointer inside the game.\nRelease with a configured mouse-release key.", {"Off", "On"}),
                                 Number<&Config::menu_pointer_speed>("input.menu_pointer_speed", "Menu pointer speed", "Menu hand speed while the mouse is captured.\n100% moves it one window pixel per count.", {.5, .75, 1, 1.25, 1.5, 1.75, 2, 2.5, 3, 4}, 100, "%"),
                                 Choice<&Config::menu_pointer_acceleration>("input.menu_pointer_acceleration", "Menu pointer acceleration", "Fast mouse motion moves the menu hand further.\nSlow motion keeps its precision.", {"Off", "On"}),
                                 Number<&Config::stick_sensitivity>("input.stick_sensitivity", "Stick sensitivity", "Scales controller stick response.", {.5, .75, 1, 1.1, 1.2, 1.33, 1.5, 1.75, 2, 2.5, 3}),
                                 Choice<&Config::stick_invert_x>("input.stick_invert_x", "Invert stick X", "Reverses the right stick's horizontal axis.", {"Off", "On"}),
                                 Choice<&Config::stick_invert_y>("input.stick_invert_y", "Invert stick Y", "Reverses the right stick's vertical axis.", {"Off", "On"}),
                                 Choice<&Config::dualsense_haptics>("input.dualsense_haptics", "DualSense haptics", "Plays vibration on a DualSense's HD actuators.\nFull adds quakes and hit, weapon and monster effects.", {"Off", "Vibration", "Full"}),
                                 Number<&Config::haptics_strength>("input.haptics_strength", "Haptics strength", "DualSense actuator strength.", {0, .25, .5, .75, 1, 1.25, 1.5, 1.75, 2}, 100, "%"),
                                 Choice<&Config::glyphs_new>("input.glyphs", "Button symbols", "New redraws the game's button symbols from glyphs/.\nOriginal keeps the PlayStation art.", {"Original", "New"}),
                                 Choice<&Config::glyph_device>("input.glyph_device", "Glyph style", "Auto follows the last device used.\nKeyboard prompts follow your current bindings.", {"Auto", "PS3", "PS4", "PS5", "PS5 Color", "Xbox", "Switch", "Steam Deck", "Steam Controller", "Keyboard"}),
                                 Choice<&Config::keyboard_walk>("input.keyboard_walk", "Keyboard movement", "Run: keys run and the Walk key walks.\nWalk: keys walk and the Walk key runs.", {"Run", "Walk"}),
                                 Choice<&Config::mouse_zoom>("input.mouse_zoom", "Mouse wheel zoom", "Wheel changes camera distance while walking.\nMenus use the wheel for selection instead.", {"Off", "On"}),
                                 Choice<&Config::mouse_fixed_look>("input.mouse_fixed_look", "Fixed camera mouse look", "Gently look around fixed-camera rooms.\nThe view returns when the mouse rests.", {"Off", "On"}),
                             }},
        {.name = "Game",     .rows = {
                             Choice<&Config::autosave>("game.autosave", "Autosave", "Saves on arriving in a town or on a dungeon floor.\nThe load screen lists it first.", {"Off", "On"}),
                             Choice<&Config::quick_loadout_plate>("game.quick_loadout_title", "Quick loadout title", "How the D-pad down panel shows its title:\non a bar, or on a plate like the EXP gauge's.", {"Bar", "Plate"}),
                             Choice<&Config::skip_intro>("game.skip_intro", "Skip intro", "Boots past the Sony text, the copyright notice\nand the Level-5 logo to the title screen.", {"Off", "On"}),
                             Choice<&Config::auto_use_event_item>("game.auto_use_event_item", "Auto-use event items", "An event that asks for one item you carry\nis handed it without the item picker.", {"Off", "On"}),
                             Choice<&Config::spheda_handicap>("game.spheda_handicap", "Spheda handicap", "Extra shots added to each Spheda hole's par.\nOff is the original game.", {"Off", "+1", "+2", "+3", "+4", "+5"}),
                             Choice<&Config::floor_info_monsters>("game.floor_info_monsters", "Floor monster list", "Triangle on a floor's info lists its monsters, drops and\ngate key carrier (spoilers). Off is the original game.", {"Off", "On"}),
                             Choice<&Config::more_monsters>("game.more_monsters", "More monsters", "Floors hold up to 60 monsters instead of 24, and all of\nthem in range show and act. Applies from the next floor.", {"Off", "On"}),
                             Choice<&Config::transformation_stats>("game.transformation_stats", "Transformation stats", "Monster attack grows twice as fast per level.\nMonica's defence is used when it is higher.", {"Off", "On"}),
                             Choice<&Config::transformation_exp>("game.transformation_exp", "Transformation EXP", "Monster badges gain twice the absorption\nwhile Monica is transformed.", {"Off", "On"}),
                             Choice<&Config::shared_badge_exp>("game.shared_badge_exp", "Shared badge EXP", "A quarter of Monica's absorption also goes\nto every other monster badge.", {"Off", "On"}),
                             Choice<&Config::debug_mode>("game.debug_mode", "Debug mode", "Unlocks the developer menu and debug controls.\nThe boot unlock applies from the next start.", {"Off", "On"}),
                         }        },
        {.name = "Keyboard", .rows = Bindings()           },
        {.name = "Gamepad",  .rows = PadBindings()        },
    };
    if (kAppPage) {
        for (Page &page : pages) {
            std::erase_if(page.rows, [](const Row &row) { return PcOnly(row.key); });
        }
    }
    return pages;
}

} // namespace

std::span<const Page> Pages() {
    static const std::vector<Page> pages = MakePages();
    return pages;
}

bool StepRow(const Row &row, Config &config, int direction) {
    if (!row.step || direction == 0) {
        return false;
    }
    const Config before = config;
    row.step(config, direction > 0 ? 1 : -1);
    return before != config;
}

bool SetBinding(Config &config, std::string_view action, std::string_view key) {
    if (key.empty() || InputScancodeFromName(key) == InputScancodeFromName("Escape")) {
        return false;
    }
    const bool mouse = key.size() == 6 && key.starts_with("Mouse") && key[5] >= '1' && key[5] <= '5';
    if (InputScancodeFromName(key) < 0 && !mouse) {
        return false;
    }
    const auto actions = InputActions();
    const auto known = std::ranges::find(actions, action, &InputActionInfo::action);
    if (known == actions.end() || known->whole_axis) {
        return false;
    }
    auto it = std::ranges::find(config.key_bindings, action, &ConfigKeyBinding::action);
    if (it == config.key_bindings.end()) {
        config.key_bindings.push_back({.action = std::string(action), .keys = {std::string(key)}});
    } else {
        it->keys = {std::string(key)};
    }
    return true;
}

void ResetBinding(Config &config, std::string_view action) {
    std::erase_if(config.key_bindings, [&](const auto &b) { return b.action == action; });
}

bool SetPadBinding(Config &config, std::string_view action, std::string_view button) {
    const auto actions = InputActions();
    const auto known = std::ranges::find(actions, action, &InputActionInfo::action);
    if (known == actions.end() || !known->pad || FindPadButton(button) == nullptr) {
        return false;
    }
    std::vector<std::string> names{std::string(button)};
    const auto               previous = PadNames(config, action);
    if (previous == names) {
        return false;
    }
    SetPadNames(config, action, names);
    TakeFromOthers(config, action, names, previous);
    return true;
}

void ResetPadBinding(Config &config, std::string_view action) {
    const auto previous = PadNames(config, action);
    std::erase_if(config.pad_bindings, [&](const auto &b) { return b.action == action; });
    TakeFromOthers(config, action, InputPadBindingNames(action, true), previous);
}

std::string PadButtonName(std::string_view button, const Config &config) {
    auto device = config.glyphs_new ? config.glyph_device : ConfigGlyphDevice::Ps3;
    if (device == ConfigGlyphDevice::Auto || device == ConfigGlyphDevice::Keyboard) {
        switch (InputGamepadGlyphFamily()) {
            case InputGlyphFamily::Ps3:
                device = ConfigGlyphDevice::Ps3;
                break;
            case InputGlyphFamily::Ps5:
                device = ConfigGlyphDevice::Ps5;
                break;
            case InputGlyphFamily::Xbox:
            case InputGlyphFamily::SteamDeck:
            case InputGlyphFamily::SteamController:
                device = ConfigGlyphDevice::Xbox;
                break;
            case InputGlyphFamily::Switch:
                device = ConfigGlyphDevice::Switch;
                break;
            default:
                device = ConfigGlyphDevice::Ps4;
                break;
        }
    }
    const PadButtonNames *names = FindPadButton(button);
    if (names == nullptr) {
        return std::string(button);
    }
    if (device == ConfigGlyphDevice::Xbox || device == ConfigGlyphDevice::SteamDeck ||
        device == ConfigGlyphDevice::SteamController) {
        return names->xbox;
    }
    if (device == ConfigGlyphDevice::Switch) {
        return names->nintendo;
    }
    const bool ps3 = device == ConfigGlyphDevice::Ps3;
    if (button == "back") {
        if (ps3) {
            return "Select";
        }
        return device == ConfigGlyphDevice::Ps5 || device == ConfigGlyphDevice::Ps5Color ? "Create" : "Share";
    }
    if (button == "start" && ps3) {
        return "Start";
    }
    return names->playstation;
}

std::vector<DisplayModeSize> ResolutionList(std::span<const DisplayModeSize> modes, int width, int height) {
    std::vector<DisplayModeSize> sizes(kPresetSizes.begin(), kPresetSizes.end());
    for (auto size : modes) {
        if (size.width >= 640 && size.height >= 480) {
            sizes.push_back(size);
        }
    }
    if (width != 0 || height != 0) {
        sizes.push_back({.width = width, .height = height});
    }
    std::ranges::sort(sizes, [](auto a, auto b) { return std::pair(a.width, a.height) < std::pair(b.width, b.height); });
    const auto duplicates = std::ranges::unique(sizes, [](auto a, auto b) { return a.width == b.width && a.height == b.height; });
    sizes.erase(duplicates.begin(), duplicates.end());
    return sizes;
}

void ListResolutions() {
    const auto &c = ConfigGet();
    g_sizes = ResolutionList(WindowDisplayModes(), c.window_width, c.window_height);
}

std::string ButtonName(std::string_view action, const Config &config) {
    auto device = config.glyph_device;
    if (!config.glyphs_new) {
        device = ConfigGlyphDevice::Ps3; // the PS2 pad's names, as the game's art shows them
    }
    if (device == ConfigGlyphDevice::Auto) {
        switch (InputActiveGlyphFamily()) {
            case InputGlyphFamily::Keyboard:
                device = ConfigGlyphDevice::Keyboard;
                break;
            case InputGlyphFamily::Xbox:
                device = ConfigGlyphDevice::Xbox;
                break;
            case InputGlyphFamily::Switch:
                device = ConfigGlyphDevice::Switch;
                break;
            case InputGlyphFamily::SteamDeck:
                device = ConfigGlyphDevice::SteamDeck;
                break;
            case InputGlyphFamily::SteamController:
                device = ConfigGlyphDevice::SteamController;
                break;
            default:
                device = ConfigGlyphDevice::Ps4;
                break;
        }
    }
    if (device == ConfigGlyphDevice::Keyboard) {
        const std::string bindings = InputBindingLabel(action);
        return bindings.substr(0, bindings.find(", "));
    }
    // A pad button moved on the controller is named after the button it now sits on.
    const std::string shown = InputPadGlyphAction(action);
    if (!shown.empty()) {
        action = shown;
    }
    const bool xbox = device == ConfigGlyphDevice::Xbox || device == ConfigGlyphDevice::SteamDeck || device == ConfigGlyphDevice::SteamController;
    const bool sw = device == ConfigGlyphDevice::Switch;
    if (action == "cross") {
        return xbox ? "A" : sw ? "B"
                               : "Cross";
    }
    if (action == "circle") {
        return xbox ? "B" : sw ? "A"
                               : "Circle";
    }
    if (action == "square") {
        return xbox ? "X" : sw ? "Y"
                               : "Square";
    }
    if (action == "select") {
        return sw ? "Minus" : xbox                           ? "View"
                          : device == ConfigGlyphDevice::Ps3 ? "Select"
                                                             : "Touchpad";
    }
    if (action == "l1") {
        return xbox ? "LB" : sw ? "L"
                                : "L1";
    }
    if (action == "r1") {
        return xbox ? "RB" : sw ? "R"
                                : "R1";
    }
    return std::string(action);
}

} // namespace options
