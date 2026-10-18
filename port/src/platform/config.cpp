#include "platform/config.hpp"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <format>
#include <fstream>
#include <limits>
#include <optional>
#include <string>
#include <utility>
#include <vector>

#include "log/log.hpp"
#include "platform/config_io.hpp"
#include "platform/display.hpp"
#include "platform/files.hpp"
#include "platform/paths.hpp"

namespace {

using Json = nlohmann::ordered_json;

Config g_config;
// What config.json was last read or written as; unset when its contents are unknown.
std::optional<Config> g_persisted;
// Whether config.json holds g_config, so a failed save is retried with the next change.
bool g_saved = false;
// An existing config.json that could not be read: replacing it would discard the user's settings.
bool             g_keep_file = false;
ConfigChangeHook g_change_hook = nullptr;
ConfigReadHook   g_read_hook = nullptr;

bool ReadConfig(const std::filesystem::path &path, std::string &text) {
    std::ifstream file(path, std::ios::binary);
    if (!file) {
        return false;
    }
    if (g_read_hook) {
        g_read_hook(file);
    }
    // Extract through the istream so a streambuf exception marks its badbit.
    // A short final read, including an empty file, succeeds only at clean EOF.
    char block[4096];
    text.clear();
    while (file.read(block, sizeof block)) {
        text.append(block, sizeof block);
    }
    if (file.bad() || !file.eof()) {
        text.clear();
        return false;
    }
    text.append(block, static_cast<std::size_t>(file.gcount()));
    return true;
}

constexpr auto kPositive = [](auto value) { return value > 0; };
constexpr auto kNonNegative = [](auto value) { return value >= 0; };
constexpr auto kUnit = [](auto value) { return value >= 0 && value <= 1; };

constexpr const char *kPresentModeNames[] = {"fifo", "mailbox", "immediate"};
constexpr const char *kRenderThreadNames[] = {"off", "lockstep", "async"};
constexpr const char *kAspectNames[] = {"auto", "4:3"};
constexpr const char *kFpsDetailNames[] = {"fps", "ticks", "all"};
constexpr const char *kHapticsNames[] = {"off", "vibration", "full"};
constexpr const char *kGyroNames[] = {"off", "always", "first_person", "held"};
constexpr const char *kGlyphDeviceNames[] = {
    "auto",
    "ps3",
    "ps4",
    "ps5",
    "ps5color",
    "xbox",
    "switch",
    "steamdeck",
    "steamcontroller",
    "keyboard",
};

std::string_view Trim(std::string_view text) {
    constexpr std::string_view kSpace = " \t\r\n";
    std::size_t                first = text.find_first_not_of(kSpace);
    if (first == std::string_view::npos) {
        return {};
    }
    return text.substr(first, text.find_last_not_of(kSpace) - first + 1);
}

std::string Lower(std::string_view text) {
    std::string lower(text);
    std::ranges::transform(lower, lower.begin(), [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
    return lower;
}

// The double that prints as the float does: 0.1f as 0.1, not 0.10000000149011612.
double Shortest(float value) {
    return std::stod(std::format("{}", value));
}

void Ignore(std::string_view name, const Json &value) {
    CT_LOG_WARN(Config, "config.json: ignoring {} = {}", name, value.dump());
}

template <class T, class Valid>
bool ReadNumber(const Json &value, T &out, Valid valid) {
    if (!value.is_number()) {
        return false;
    }
    T number = value.get<T>();
    if (!std::isfinite(number) || !valid(number)) {
        return false;
    }
    out = number;
    return true;
}

bool ReadInt(const Json &value, int &out) {
    if (!value.is_number_integer()) {
        return false;
    }
    std::int64_t number = value.get<std::int64_t>();
    if (number < 0 || number > std::numeric_limits<int>::max()) {
        return false;
    }
    out = static_cast<int>(number);
    return true;
}

bool ReadBool(const Json &value, bool &out) {
    if (!value.is_boolean()) {
        return false;
    }
    out = value.get<bool>();
    return true;
}

// A choice between two names, the second setting true. Matched in any case.
bool ReadChoice(const Json &value, std::string_view first, std::string_view second, bool &out) {
    if (!value.is_string()) {
        return false;
    }
    std::string choice = Lower(value.get<std::string>());
    if (choice != first && choice != second) {
        return false;
    }
    out = choice == second;
    return true;
}

// An enum's values are the indices of its names, in order.
template <class E, std::size_t N>
bool ReadEnum(const Json &value, const char *const (&names)[N], E &out) {
    if (!value.is_string()) {
        return false;
    }
    std::string name = Lower(value.get<std::string>());
    for (std::size_t i = 0; i < N; ++i) {
        if (name == names[i]) {
            out = static_cast<E>(i);
            return true;
        }
    }
    return false;
}

bool ReadList(const Json &value, std::vector<std::string> &out) {
    std::vector<std::string> items;
    if (value.is_string()) {
        items.push_back(value.get<std::string>());
    } else if (value.is_array()) {
        for (const Json &item : value) {
            if (!item.is_string()) {
                return false;
            }
            items.push_back(item.get<std::string>());
        }
    } else {
        return false;
    }
    out = std::move(items);
    return true;
}

bool ApplyBindings(Config &config, const Json &bindings) {
    if (!bindings.is_object()) {
        return false;
    }
    for (const auto &[action, keys] : bindings.items()) {
        ConfigKeyBinding binding = {.action = Lower(action), .keys = {}};
        if (ReadList(keys, binding.keys)) {
            config.key_bindings.push_back(std::move(binding));
        } else {
            Ignore("input.bindings." + action, keys);
        }
    }
    return true;
}

bool ReadLogLevel(const Json &value, std::optional<LogLevel> &out) {
    if (!value.is_string()) {
        return false;
    }
    const std::string name = value.get<std::string>();
    if (Lower(name) == "auto") {
        out.reset();
        return true;
    }
    const std::optional<LogLevel> level = LogLevelFromName(name);
    if (!level) {
        return false;
    }
    out = level;
    return true;
}

bool ApplyLogCategories(Config &config, const Json &categories) {
    if (!categories.is_object()) {
        return false;
    }
    for (const auto &[name, value] : categories.items()) {
        const std::optional<LogCategory> category = LogCategoryFromName(name);
        std::optional<LogLevel>          level;
        if (!category || !ReadLogLevel(value, level) || !level) {
            Ignore("log.categories." + name, value);
            continue;
        }
        auto      &levels = config.log.categories;
        const auto it = std::ranges::find_if(levels, [&](const auto &entry) { return entry.first == *category; });
        if (it != levels.end()) {
            it->second = *level;
        } else {
            levels.emplace_back(*category, *level);
        }
    }
    return true;
}

bool Apply(Config &config, std::string_view name, const Json &value) {
    HostSettings &s = config;
    if (name == "game.debug_mode") {
        return ReadBool(value, config.debug_mode);
    }
    if (name == "game.autosave") {
        return ReadBool(value, config.autosave);
    }
    if (name == "game.floor_info_monsters") {
        return ReadBool(value, config.floor_info_monsters);
    }
    if (name == "game.more_monsters") {
        return ReadBool(value, config.more_monsters);
    }
    if (name == "game.quick_loadout_title") {
        return ReadChoice(value, "bar", "plate", config.quick_loadout_plate);
    }
    if (name == "game.skip_intro") {
        return ReadBool(value, config.skip_intro);
    }
    if (name == "game.auto_use_event_item") {
        return ReadBool(value, config.auto_use_event_item);
    }
    if (name == "video.present_mode") {
        return ReadEnum(value, kPresentModeNames, s.present_mode);
    }
    if (name == "video.interpolation") {
        return ReadBool(value, config.interpolation);
    }
    if (name == "video.render_thread") {
        return ReadEnum(value, kRenderThreadNames, config.render_thread);
    }
    if (name == "video.max_fps") {
        if (!ReadNumber(value, s.max_fps, kNonNegative)) {
            return false;
        }
        if (s.max_fps > 0.0 && s.max_fps < 1.0) {
            s.max_fps = 1.0;
        }
        return true;
    }
    if (name == "video.width") {
        return ReadInt(value, s.window_width);
    }
    if (name == "video.height") {
        return ReadInt(value, s.window_height);
    }
    if (name == "video.fullscreen") {
        return ReadBool(value, s.fullscreen);
    }
    if (name == "video.aspect") {
        return ReadEnum(value, kAspectNames, config.aspect);
    }
    if (name == "video.ui_scale") {
        return ReadNumber(value, config.ui_scale, [](float scale) { return scale >= 0.25f && scale <= 4.0f; });
    }
    if (name == "video.text_font") {
        return ReadChoice(value, "original", "sharp", config.font_sharp);
    }
    if (name == "video.show_fps") {
        return ReadBool(value, s.show_fps);
    }
    if (name == "video.fps_detail") {
        return ReadEnum(value, kFpsDetailNames, s.fps_detail);
    }
    if (name == "audio.master_volume") {
        return ReadNumber(value, s.master_volume, kUnit);
    }
    if (name == "audio.sound") {
        return ReadChoice(value, "stereo", "surround", s.surround);
    }
    if (name == "audio.dualsense_speaker") {
        return ReadBool(value, config.dualsense_speaker);
    }
    // Superseded by audio.dualsense_speaker, whose default is this key's only opt-in: validated and dropped.
    if (name == "audio.robot_voice") {
        bool controller = false;
        return ReadChoice(value, "tv", "controller", controller);
    }
    if (name == "audio.controller_volume") {
        return ReadNumber(value, config.controller_volume, [](float volume) { return volume >= 0.0f && volume <= 2.0f; });
    }
    if (name == "audio.soundtrack") {
        return ReadChoice(value, "ps2", "custom", s.soundtrack);
    }
    if (name == "input.mouse_sensitivity") {
        return ReadNumber(value, s.mouse_sensitivity, kPositive);
    }
    if (name == "input.stick_sensitivity") {
        return ReadNumber(value, s.stick_sensitivity, kPositive);
    }
    if (name == "input.stick_invert_x") {
        return ReadBool(value, s.stick_invert_x);
    }
    if (name == "input.stick_invert_y") {
        return ReadBool(value, s.stick_invert_y);
    }
    if (name == "input.gyro") {
        return ReadEnum(value, kGyroNames, s.gyro);
    }
    if (name == "input.gyro_sensitivity") {
        return ReadNumber(value, s.gyro_sensitivity, kPositive);
    }
    if (name == "input.gyro_invert_x") {
        return ReadBool(value, s.gyro_invert_x);
    }
    if (name == "input.gyro_invert_y") {
        return ReadBool(value, s.gyro_invert_y);
    }
    if (name == "input.mouse_invert_y") {
        return ReadBool(value, s.mouse_invert_y);
    }
    if (name == "input.mouse_capture") {
        return ReadBool(value, s.mouse_capture);
    }
    if (name == "input.mouse_fixed_look") {
        return ReadBool(value, config.mouse_fixed_look);
    }
    if (name == "input.menu_pointer_speed") {
        return ReadNumber(value, config.menu_pointer_speed, [](float speed) { return speed >= 0.25f && speed <= 4.0f; });
    }
    if (name == "input.menu_pointer_acceleration") {
        return ReadBool(value, config.menu_pointer_acceleration);
    }
    if (name == "input.mouse_zoom") {
        return ReadBool(value, s.mouse_zoom);
    }
    if (name == "input.touchpad") {
        return ReadBool(value, s.touchpad);
    }
    if (name == "input.touchpad_sensitivity") {
        return ReadNumber(value, s.touchpad_sensitivity, kPositive);
    }
    if (name == "input.lightbar") {
        return ReadBool(value, s.lightbar);
    }
    if (name == "input.rumble_strength") {
        return ReadNumber(value, s.rumble_strength, kUnit);
    }
    if (name == "input.dualsense_haptics") {
        return ReadEnum(value, kHapticsNames, config.dualsense_haptics);
    }
    if (name == "input.haptics_strength") {
        return ReadNumber(value, config.haptics_strength, [](float strength) { return strength >= 0.0f && strength <= 2.0f; });
    }
    if (name == "input.glyphs") {
        return ReadChoice(value, "original", "new", s.glyphs_new);
    }
    if (name == "input.glyph_device") {
        return ReadEnum(value, kGlyphDeviceNames, s.glyph_device);
    }
    if (name == "input.mouse_release") {
        return ReadList(value, s.mouse_release_keys);
    }
    if (name == "input.bindings") {
        return ApplyBindings(config, value);
    }
    if (name == "log.level") {
        return ReadLogLevel(value, config.log.level);
    }
    if (name == "log.file") {
        return ReadBool(value, config.log.file);
    }
    if (name == "log.keep") {
        int keep = 0;
        if (!ReadInt(value, keep) || keep < 1 || keep > kLogKeepMax) {
            return false;
        }
        config.log.keep = keep;
        return true;
    }
    if (name == "log.console") {
        return ReadBool(value, config.log.console);
    }
    if (name == "log.categories") {
        return ApplyLogCategories(config, value);
    }
    return false;
}

// Apply only session edits, leaving unrelated fields from the current file intact.
void MergeChanges(Json &root, const Json &before, const Json &after, const std::string &path = "") {
    if (before == after) {
        return;
    }
    if (!after.is_object()) {
        root = after;
        return;
    }
    if (!root.is_object()) {
        root = Json::object();
    }
    const auto erase = [&](const std::string &key) {
        if (path == "input.bindings") {
            for (auto it = root.begin(); it != root.end();) {
                if (Lower(it.key()) == Lower(key)) {
                    it = root.erase(it);
                } else {
                    ++it;
                }
            }
        } else {
            root.erase(key);
        }
    };
    for (const auto &[key, value] : after.items()) {
        const Json previous = before.is_object() && before.contains(key) ? before[key] : Json();
        if (previous != value) {
            if (path == "input.bindings") {
                erase(key);
            }
            MergeChanges(root[key], previous, value, path.empty() ? key : path + "." + key);
        }
    }
    if (before.is_object()) {
        for (const auto &[key, value] : before.items()) {
            if (!after.contains(key)) {
                erase(key);
            }
        }
    }
}

bool WriteReplacing(const std::filesystem::path &path, std::string_view text) {
    std::filesystem::path temp = path;
    temp += ".tmp";
    std::error_code error;
    {
        std::ofstream file(temp, std::ios::binary | std::ios::trunc);
        file << text;
        file.close();
        if (!file) {
            std::filesystem::remove(temp, error);
            return false;
        }
    }
    std::filesystem::rename(temp, path, error);
    if (error) {
        std::filesystem::remove(temp, error);
        return false;
    }
    return true;
}

} // namespace

Config ConfigParse(std::string_view text) {
    Config config;
    if (Trim(text).empty()) {
        return config;
    }
    Json root = Json::parse(text, nullptr, false, true);
    if (!root.is_object()) {
        CT_LOG_WARN(Config, "config.json: {}; using the defaults",
                    root.is_discarded() ? "not valid JSON" : "expected an object");
        return config;
    }
    for (const auto &[section, keys] : root.items()) {
        if (!keys.is_object()) {
            Ignore(section, keys);
            continue;
        }
        for (const auto &[key, value] : keys.items()) {
            std::string name = section + "." + key;
            if (!Apply(config, name, value)) {
                Ignore(name, value);
            }
        }
    }
    return config;
}

std::string ConfigSerialize(const Config &config) {
    const HostSettings &s = config;
    Json                bindings = Json::object();
    for (const ConfigKeyBinding &binding : s.key_bindings) {
        bindings[binding.action] = binding.keys;
    }
    Json root;
    root["game"]["debug_mode"] = config.debug_mode;
    root["game"]["autosave"] = config.autosave;
    root["game"]["quick_loadout_title"] = config.quick_loadout_plate ? "plate" : "bar";
    root["game"]["skip_intro"] = config.skip_intro;
    root["game"]["auto_use_event_item"] = config.auto_use_event_item;
    root["game"]["floor_info_monsters"] = config.floor_info_monsters;
    root["game"]["more_monsters"] = config.more_monsters;
    root["video"]["present_mode"] = kPresentModeNames[static_cast<std::size_t>(s.present_mode)];
    root["video"]["interpolation"] = config.interpolation;
    root["video"]["render_thread"] = kRenderThreadNames[static_cast<std::size_t>(config.render_thread)];
    root["video"]["max_fps"] = s.max_fps;
    root["video"]["width"] = s.window_width;
    root["video"]["height"] = s.window_height;
    root["video"]["fullscreen"] = s.fullscreen;
    root["video"]["aspect"] = kAspectNames[static_cast<std::size_t>(config.aspect)];
    root["video"]["ui_scale"] = Shortest(config.ui_scale);
    root["video"]["text_font"] = config.font_sharp ? "sharp" : "original";
    root["video"]["show_fps"] = s.show_fps;
    root["video"]["fps_detail"] = kFpsDetailNames[static_cast<std::size_t>(s.fps_detail)];
    root["audio"]["master_volume"] = Shortest(s.master_volume);
    root["audio"]["sound"] = s.surround ? "surround" : "stereo";
    root["audio"]["soundtrack"] = s.soundtrack ? "custom" : "ps2";
    root["audio"]["dualsense_speaker"] = config.dualsense_speaker;
    root["audio"]["controller_volume"] = Shortest(config.controller_volume);
    root["input"]["mouse_sensitivity"] = Shortest(s.mouse_sensitivity);
    root["input"]["stick_sensitivity"] = Shortest(s.stick_sensitivity);
    root["input"]["stick_invert_x"] = s.stick_invert_x;
    root["input"]["stick_invert_y"] = s.stick_invert_y;
    root["input"]["gyro"] = kGyroNames[static_cast<std::size_t>(s.gyro)];
    root["input"]["gyro_sensitivity"] = Shortest(s.gyro_sensitivity);
    root["input"]["gyro_invert_x"] = s.gyro_invert_x;
    root["input"]["gyro_invert_y"] = s.gyro_invert_y;
    root["input"]["mouse_invert_y"] = s.mouse_invert_y;
    root["input"]["mouse_capture"] = s.mouse_capture;
    root["input"]["mouse_zoom"] = s.mouse_zoom;
    root["input"]["mouse_fixed_look"] = config.mouse_fixed_look;
    root["input"]["menu_pointer_speed"] = Shortest(config.menu_pointer_speed);
    root["input"]["menu_pointer_acceleration"] = config.menu_pointer_acceleration;
    root["input"]["touchpad"] = s.touchpad;
    root["input"]["touchpad_sensitivity"] = Shortest(s.touchpad_sensitivity);
    root["input"]["lightbar"] = s.lightbar;
    root["input"]["rumble_strength"] = Shortest(s.rumble_strength);
    root["input"]["dualsense_haptics"] = kHapticsNames[static_cast<std::size_t>(config.dualsense_haptics)];
    root["input"]["haptics_strength"] = Shortest(config.haptics_strength);
    root["input"]["glyphs"] = s.glyphs_new ? "new" : "original";
    root["input"]["glyph_device"] = kGlyphDeviceNames[static_cast<std::size_t>(s.glyph_device)];
    root["input"]["mouse_release"] = s.mouse_release_keys;
    root["input"]["bindings"] = std::move(bindings);
    Json log_categories = Json::object();
    for (const auto &[category, level] : config.log.categories) {
        log_categories[std::string(LogCategoryName(category))] = LogLevelName(level);
    }
    root["log"]["level"] = config.log.level ? LogLevelName(*config.log.level) : "auto";
    root["log"]["file"] = config.log.file;
    root["log"]["keep"] = config.log.keep;
    root["log"]["console"] = config.log.console;
    root["log"]["categories"] = std::move(log_categories);
    return root.dump(4) + "\n";
}

bool ConfigSave() {
    if (g_keep_file) {
        return false;
    }
    const std::filesystem::path path = (PathsSaveRoot() / ".." / "config.json").lexically_normal();
    std::error_code             error;
    std::filesystem::create_directories(path.parent_path(), error);
    Json root = Json::object();
    bool recovered = false;
    if (std::filesystem::exists(path, error)) {
        // A directory opens as a stream on Linux and only fails when parsed.
        if (!std::filesystem::is_regular_file(path, error)) {
            return g_saved = false;
        }
        std::string text;
        if (!ReadConfig(path, text)) {
            return g_saved = false;
        }
        root = Json::parse(text, nullptr, false, true);
        if (!root.is_object()) {
            // Keep every original byte, including empty files, before recovery.
            // Exclusive publication also preserves backups from earlier repairs.
            for (unsigned number = 0;; ++number) {
                auto backup = path;
                backup += ".bad";
                if (number) {
                    backup += "." + std::to_string(number);
                }
                const auto result = FilesWrite(backup, text.data(), text.size(), false);
                if (result == FilesResult::kExists) {
                    continue;
                }
                if (result != FilesResult::kWritten) {
                    return g_saved = false;
                }
                break;
            }
            recovered = true;
        }
    } else if (error) {
        return g_saved = false;
    }
    const Json after = Json::parse(ConfigSerialize(g_config));
    if (g_persisted && !recovered) {
        MergeChanges(root, Json::parse(ConfigSerialize(*g_persisted)), after);
    } else {
        root = after;
    }
    g_saved = WriteReplacing(path, root.dump(4) + "\n");
    if (g_saved) {
        g_persisted = g_config;
    } else {
        CT_LOG_ERROR(Config, "config: could not save {}", PathsDisplay(path));
    }
    return g_saved;
}

bool ConfigLoad() {
    const std::filesystem::path        path = (PathsSaveRoot() / ".." / "config.json").lexically_normal();
    std::error_code                    error;
    const std::filesystem::file_status status = std::filesystem::status(path, error);
    g_keep_file = false;
    g_persisted.reset();
    if (status.type() == std::filesystem::file_type::not_found) {
        g_config = Config{};
        ConfigSave();
        return false;
    }
    std::string text;
    if (error || !std::filesystem::is_regular_file(status) || !ReadConfig(path, text)) {
        CT_LOG_ERROR(Config, "config: could not read {}; using defaults and leaving it untouched",
                     PathsDisplay(path));
        g_config = Config{};
        g_saved = false;
        g_keep_file = true;
        return false;
    }
    g_config = ConfigParse(text);
    g_saved = true;
    g_persisted = g_config;
    return true;
}

bool ConfigSaved() { return g_saved; }

const HostSettings &SettingsGet() {
    return g_config;
}

const Config &ConfigGet() {
    return g_config;
}

// Stored as ConfigParse reads ConfigSerialize's output, so a value out of range is normalised the
// way a hand-edited file's would be.
bool SettingsChange(const HostSettings &settings) {
    Config candidate = g_config;
    static_cast<HostSettings &>(candidate) = settings;
    return ConfigChange(candidate);
}

bool ConfigChange(const Config &candidate) {
    Config after = ConfigParse(ConfigSerialize(candidate));
    if (after == g_config) {
        return g_saved || ConfigSave();
    }
    Config before = std::exchange(g_config, std::move(after));
    ConfigSave();
    DisplayChanged(before, g_config);
    if (g_change_hook != nullptr) {
        g_change_hook(before, g_config);
    }
    return g_saved;
}

void ConfigSetChangeHook(ConfigChangeHook hook) {
    g_change_hook = hook;
}

void ConfigSetReadHook(ConfigReadHook hook) { g_read_hook = hook; }
