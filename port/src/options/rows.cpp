#include "options/rows.hpp"

#include <algorithm>
#include <cmath>
#include <format>
#include <type_traits>
#include <utility>

#include "platform/input.hpp"

namespace options {
namespace {

std::vector<DisplayModeSize> g_sizes{
    {0,    0   },
    {800,  600 },
    {1024, 768 },
    {1280, 720 },
    {1280, 960 },
    {1920, 1080}
};

template <auto Member>
Row Choice(const char *key, const char *label, const char *help, std::vector<std::string> names) {
    using Value = std::remove_cvref_t<decltype(Config{}.*Member)>;
    Row row{key, label, help};
    row.value = [names](const Config &c) { return names.at(static_cast<int>(c.*Member)); };
    row.step = [names](Config &c, int direction) {
        const int n = static_cast<int>(names.size());
        c.*Member = static_cast<Value>((static_cast<int>(c.*Member) + direction + n) % n);
    };
    return row;
}

template <auto Member>
Row Number(const char *key, const char *label, const char *help, std::vector<double> values,
           double display_scale = 1.0, const char *suffix = "") {
    Row row{key, label, help};
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
            for (auto i = values.rbegin(); i != values.rend(); ++i) {
                if (*i < current - 0.00001) {
                    c.*Member = *i;
                    return;
                }
            }
        }
    };
    return row;
}

Row Resolution() {
    Row row{"video.width", "Resolution", "Window size. Fullscreen uses the desktop.\nCommand-line --window overrides this setting."};
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

std::vector<Row> Bindings() {
    static constexpr const char *labels[] = {
        "D-pad Up",
        "D-pad Down",
        "D-pad Left",
        "D-pad Right",
    };
    std::vector<Row> rows;
    for (const auto &info : InputActions()) {
        if (info.whole_axis) {
            continue;
        }
        // These host actions have no game-side consumer in this port.
        if (info.action == "developer_menu" || info.action == "gyro_hold") {
            continue;
        }
        std::string      action(info.action);
        std::string      label = action;
        static constexpr std::pair<std::string_view, const char *> names[] = {
            {"cross",      "Cross"       },
            {"circle",     "Circle"      },
            {"square",     "Square"      },
            {"triangle",   "Triangle"    },
            {"up",         labels[0]     },
            {"down",       labels[1]     },
            {"left",       labels[2]     },
            {"right",      labels[3]     },
            {"start",      "Start"       },
            {"select",     "Select"      },
            {"l1",         "L1"          },
            {"r1",         "R1"          },
            {"l2",         "L2"          },
            {"r2",         "R2"          },
            {"l3",         "L3"          },
            {"r3",         "R3"          },
            {"lx-",        "Move left"   },
            {"lx+",        "Move right"  },
            {"ly-",        "Move forward"},
            {"ly+",        "Move back"   },
            {"rx-",        "Look left"   },
            {"rx+",        "Look right"  },
            {"ry-",        "Look up"     },
            {"ry+",        "Look down"   },
            {"zoom_reset", "Zoom reset"  },
            {"fps_toggle", "Toggle FPS"  },
            {"debug_menu", "Debug menu"  },
        };
        for (auto [name, text] : names) {
            if (action == name) {
                label = text;
            }
        }
        rows.push_back({"input.bindings." + action, label, "Confirm, then press a key or mouse button.\nEscape cancels. Square restores this binding.", [action](const Config &) { return InputBindingLabel(action); }, {}, action});
    }
    return rows;
}

} // namespace

std::span<const Page> Pages() {
    static const std::vector<Page> pages{
        {"Display",  {
                        Choice<&Config::fullscreen>("video.fullscreen", "Window mode", "Applies immediately. Fullscreen uses the desktop.", {"Windowed", "Fullscreen"}),
                        Resolution(),
                        Choice<&Config::present_mode>("video.present_mode", "Present mode", "FIFO prevents tearing. Mailbox keeps the newest frame.\nUnsupported modes fall back to FIFO.", {"FIFO", "Mailbox", "Immediate"}),
                        Number<&Config::max_fps>("video.max_fps", "Frame cap", "Limits display frames, not game speed.", {0, 30, 50, 60, 75, 90, 100, 120, 144, 165, 180, 240, 360}, 1, " FPS"),
                        Choice<&Config::interpolation>("video.interpolation", "Interpolation", "Smooths display frames between game ticks.", {"Off", "On"}),
                        Choice<&Config::aspect>("video.aspect", "Aspect ratio", "Auto fills the window. 4:3 adds black side bars.", {"Auto", "4:3"}),
                        Number<&Config::ui_scale>("video.ui_scale", "UI scale", "Scales menus and HUD. Large values can crop the UI.\nUse Left to reduce the scale if it no longer fits.", {0.5, 0.65, 0.75, 0.85, 1, 1.1, 1.25, 1.5}, 100, "%"),
                        Choice<&Config::show_fps>("video.show_fps", "Show FPS", "Shows the display and tick rates in a window.", {"Off", "On"}),
                    }  },
        {"Audio",    {
                      Number<&Config::master_volume>("audio.master_volume", "Master volume", "Adjusts all sound, including music and movies.", {0, .05, .1, .15, .2, .25, .3, .35, .4, .45, .5, .55, .6, .65, .7, .75, .8, .85, .9, .95, 1}, 100, "%"),
                      Choice<&Config::soundtrack>("audio.soundtrack", "Soundtrack", "Applies when the next song starts; no restart needed.\nCustom needs soundtrack/soundtrack.json recordings.", {"PS2", "Custom"}),
                      Choice<&Config::robot_voice_controller>("audio.robot_voice", "Ridepod voice", "Plays the Ridepod on a DualSense speaker.\nFrom the next line; the TV is used without one.", {"TV", "Controller"}),
                      Number<&Config::controller_volume>("audio.controller_volume", "Controller volume", "DualSense speaker volume, after master volume.", {0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1, 1.25, 1.5, 1.75, 2}, 100, "%"),
                  }      },
        {"Controls", {
                         Number<&Config::mouse_sensitivity>("input.mouse_sensitivity", "Mouse sensitivity", "Camera turn per count of mouse movement.", {.01, .025, .05, .075, .1, .15, .2, .3, .5, .75, 1}),
                         Choice<&Config::mouse_invert_y>("input.mouse_invert_y", "Invert mouse Y", "Reverses vertical mouse look.", {"Off", "On"}),
                         Choice<&Config::mouse_capture>("input.mouse_capture", "Capture mouse", "Keeps the pointer inside the game.\nRelease with a configured mouse-release key.", {"Off", "On"}),
                         Number<&Config::stick_sensitivity>("input.stick_sensitivity", "Stick sensitivity", "Scales controller stick response.", {.5, .75, 1, 1.1, 1.2, 1.33, 1.5, 1.75, 2, 2.5, 3}),
                         Choice<&Config::stick_invert_x>("input.stick_invert_x", "Invert stick X", "Reverses the controller look stick's horizontal axis.", {"Off", "On"}),
                         Choice<&Config::stick_invert_y>("input.stick_invert_y", "Invert stick Y", "Reverses the controller look stick's vertical axis.", {"Off", "On"}),
                         Choice<&Config::glyphs_new>("input.glyphs", "Button symbols", "New redraws the game's button symbols from glyphs/.\nOriginal keeps the PlayStation art.", {"Original", "New"}),
                         Choice<&Config::glyph_device>("input.glyph_device", "Glyph style", "Auto follows the last device used.\nKeyboard prompts follow your current bindings.", {"Auto", "PS3", "PS4", "PS5", "PS5 Color", "Xbox", "Switch", "Steam Deck", "Steam Controller", "Keyboard"}),
                         Choice<&Config::mouse_zoom>("input.mouse_zoom", "Mouse wheel zoom", "Wheel changes camera distance while walking.\nMenus use the wheel for selection instead.", {"Off", "On"}),
                         Choice<&Config::mouse_fixed_look>("input.mouse_fixed_look", "Fixed camera mouse look", "Gently look around fixed-camera rooms.\nThe view returns when the mouse rests.", {"Off", "On"}),
                     }},
        {"Game",     {
                     Choice<&Config::autosave>("game.autosave", "Autosave", "Saves on arriving in a town or on a dungeon floor.\nThe load screen lists it first.", {"Off", "On"}),
                 }       },
        {"Bindings", Bindings()           },
    };
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
    const bool mouse = key.size() == 6 && key.substr(0, 5) == "Mouse" && key[5] >= '1' && key[5] <= '5';
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
        config.key_bindings.push_back({std::string(action), {std::string(key)}});
    } else {
        it->keys = {std::string(key)};
    }
    return true;
}

void ResetBinding(Config &config, std::string_view action) {
    std::erase_if(config.key_bindings, [&](const auto &b) { return b.action == action; });
}

std::vector<DisplayModeSize> ResolutionList(std::span<const DisplayModeSize> modes, int width, int height) {
    std::vector<DisplayModeSize> sizes{
        {0,    0   },
        {800,  600 },
        {1024, 768 },
        {1280, 720 },
        {1280, 960 },
        {1920, 1080}
    };
    for (auto size : modes) {
        if (size.width >= 640 && size.height >= 480) {
            sizes.push_back(size);
        }
    }
    if (width != 0 || height != 0) {
        sizes.push_back({width, height});
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
        return sw ? "Minus" : xbox ? "View" : device == ConfigGlyphDevice::Ps3 ? "Select" : "Touchpad";
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
