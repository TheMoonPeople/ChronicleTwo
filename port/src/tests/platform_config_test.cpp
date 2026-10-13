#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <filesystem>
#include <format>
#include <fstream>
#include <iterator>
#include <string>
#include <string_view>

#include "platform/config.hpp"
#include "platform/config_io.hpp"
#include "platform/paths.hpp"
#include "platform/settings.hpp"
#include "platform_fixture.hpp"

namespace fs = std::filesystem;

namespace {

// Each case gets an empty save root: SettingsChange on a window-affecting field would open a window,
// so the cases that need one write the file and load it.
class PlatformConfig : public testing::Test {
protected:
    void SetUp() override {
        root_ = fs::temp_directory_path() / std::format("dc2_config_{}", dc::test::ProcessId());
        fs::remove_all(root_);
        fs::create_directories(root_);
        PathsSetSaveRoot(root_);
    }

    void TearDown() override {
        ConfigSetReadHook(nullptr);
        std::error_code error;
        fs::remove_all(root_, error);
    }

    fs::path Path() const { return root_ / "config.json"; }

    void Write(std::string_view text) const { std::ofstream(Path(), std::ios::binary) << text; }

    std::string Read() const {
        std::ifstream file(Path(), std::ios::binary);
        return {std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>()};
    }

private:
    fs::path root_;
};

int          g_hook_calls = 0;
HostSettings g_hook_before;
HostSettings g_hook_after;

void CaptureChange(const HostSettings &before, const HostSettings &after) {
    ++g_hook_calls;
    g_hook_before = before;
    g_hook_after = after;
}

} // namespace

TEST_F(PlatformConfig, DefaultsAreWrittenWhenAbsent) {
    ASSERT_FALSE(ConfigLoad());
    ASSERT_TRUE(fs::exists(Path()));
    ASSERT_TRUE(ConfigParse(Read()) == Config{});
    ASSERT_TRUE(SettingsGet().tick_rate == kConfigTickRateDefault);
    ASSERT_TRUE(ConfigLoad());
    ASSERT_TRUE(SettingsGet() == static_cast<const HostSettings &>(Config{}));
}

TEST_F(PlatformConfig, TinyFrameCapsClampButZeroRemainsUncapped) {
    EXPECT_DOUBLE_EQ(ConfigParse(R"({"video":{"max_fps":1e-12}})").max_fps, 1.0);
    EXPECT_DOUBLE_EQ(ConfigParse(R"({"video":{"max_fps":0.5}})").max_fps, 1.0);
    EXPECT_DOUBLE_EQ(ConfigParse(R"({"video":{"max_fps":0}})").max_fps, 0.0);
}

TEST_F(PlatformConfig, FullFileRoundTrips) {
    Config full;
    full.tick_rate = 120.0;
    full.present_mode = ConfigPresentMode::Mailbox;
    full.max_fps = 144.0;
    full.window_width = 1920;
    full.window_height = 1080;
    full.fullscreen = true;
    full.show_fps = false;
    full.fps_detail = ConfigFpsDetail::Ticks;
    full.master_volume = 0.5f;
    full.surround = true;
    full.soundtrack = true;
    full.key_bindings = {ConfigKeyBinding{"cross", {"Space", "Z"}}, ConfigKeyBinding{"start", {"Return"}}};
    full.mouse_sensitivity = 0.25f;
    full.stick_sensitivity = 1.5f;
    full.stick_invert_x = true;
    full.stick_invert_y = true;
    full.gyro = ConfigGyro::FirstPerson;
    full.gyro_sensitivity = 1.25f;
    full.gyro_invert_x = true;
    full.gyro_invert_y = true;
    full.mouse_invert_y = true;
    full.mouse_capture = false;
    full.mouse_zoom = true;
    full.mouse_fixed_look = false;
    full.touchpad = false;
    full.touchpad_sensitivity = 2.0f;
    full.lightbar = false;
    full.rumble_strength = 0.5f;
    full.glyphs_new = false;
    full.glyph_device = ConfigGlyphDevice::Ps5Color;
    full.mouse_release_keys = {"F12", "Pause"};
    full.font_sharp = true;

    ASSERT_TRUE(ConfigParse(ConfigSerialize(full)) == full);

    Write(ConfigSerialize(full));
    ASSERT_TRUE(ConfigLoad());
    const HostSettings &expected = full;
    ASSERT_TRUE(SettingsGet() == expected);
}

TEST_F(PlatformConfig, TextFontIsOptInAndRoundTrips) {
    EXPECT_FALSE(ConfigParse("").font_sharp);
    const Config sharp = ConfigParse(R"({"video":{"text_font":"sharp"}})");
    EXPECT_TRUE(sharp.font_sharp);
    EXPECT_TRUE(ConfigParse(ConfigSerialize(sharp)).font_sharp);
    EXPECT_FALSE(ConfigParse(R"({"video":{"text_font":"original"}})").font_sharp);
    for (const char *value : {"null", "true", "1", "\"blurry\""}) {
        EXPECT_FALSE(ConfigParse(std::string("{\"video\":{\"text_font\":") + value + "}}").font_sharp);
    }
}

TEST_F(PlatformConfig, TickRateOutsideItsRangeKeepsTheDefault) {
    ASSERT_TRUE(ConfigParse(R"({"game": {"tick_rate": 25}})").tick_rate == 25.0);
    ASSERT_TRUE(ConfigParse(R"({"game": {"tick_rate": 240}})").tick_rate == 240.0);
    for (const char *value : {"0", "-3", "24.9", "240.1", "1e9", "\"fast\"", "null", "true"}) {
        std::string json = std::string(R"({"game": {"tick_rate": )") + value + "}}";
        ASSERT_TRUE(ConfigParse(json).tick_rate == kConfigTickRateDefault) << value;
    }
    Write(R"({"game": {"tick_rate": 1000}})");
    ASSERT_TRUE(ConfigLoad());
    ASSERT_TRUE(SettingsGet().tick_rate == kConfigTickRateDefault);
}

TEST_F(PlatformConfig, UnknownKeysAndSectionsAreIgnored) {
    Config config = ConfigParse(R"({
        // comment
        "game": {"tick_rate": 60, "debug_menu": true, "unknown": 1},
        "video": {"vsync": false, "width": 1280},
        "audio": {"master_volume": 0.5},
        "extra": {"tick_rate": 30},
        "stray": 1
    })");
    ASSERT_TRUE(config.tick_rate == 60.0);
    ASSERT_TRUE(config.window_width == 1280 && config.window_height == 0);
    ASSERT_TRUE(config.master_volume == 0.5f);
    ASSERT_TRUE(config.present_mode == ConfigPresentMode::Fifo);
    ASSERT_TRUE(ConfigParse(R"({"game": {"debug_menu": false}, "stray": 1})") == Config{});
}

TEST_F(PlatformConfig, DebugModeParsesBoolsAndDefaultsToOff) {
    ASSERT_FALSE(Config{}.debug_mode);
    ASSERT_FALSE(ConfigParse("").debug_mode);
    ASSERT_FALSE(ConfigParse(R"({"game": {"debug_mode": false}})").debug_mode);
    ASSERT_TRUE(ConfigParse(R"({"game": {"debug_mode": true}})").debug_mode);
}

TEST_F(PlatformConfig, DebugModeInvalidValuesKeepTheDefault) {
    for (const char *value : {"\"yes\"", "1", "null", "\"off\""}) {
        std::string json = std::string(R"({"game": {"debug_mode": )") + value + "}}";
        ASSERT_FALSE(ConfigParse(json).debug_mode) << json;
    }
}

TEST_F(PlatformConfig, DebugModeRoundTripsThroughSerialize) {
    Config config;
    config.debug_mode = true;
    Config parsed = ConfigParse(ConfigSerialize(config));
    ASSERT_TRUE(parsed.debug_mode);
    ASSERT_TRUE(parsed == config);
}

TEST_F(PlatformConfig, WrongTypesKeepTheDefaults) {
    ASSERT_TRUE(ConfigParse(R"({
        "game": {"tick_rate": "50"},
        "video": {"width": 1.5, "height": "tall", "fullscreen": "yes", "present_mode": 3,
                  "fps_detail": true, "max_fps": -1},
        "audio": {"master_volume": 1.5, "sound": "mono", "soundtrack": 1},
        "input": {"mouse_sensitivity": 0, "gyro": true, "glyphs": 0, "glyph_device": "xbox360",
                  "rumble_strength": 2, "mouse_release": 4, "bindings": "cross"}
    })") == Config{});
}

TEST_F(PlatformConfig, MalformedFileKeepsTheDefaults) {
    ASSERT_TRUE(ConfigParse("[game]\ntick_rate = 50\n") == Config{});
    ASSERT_TRUE(ConfigParse(R"({"game": {"tick_rate": 50})") == Config{});
    ASSERT_TRUE(ConfigParse("[1, 2]") == Config{});
    ASSERT_TRUE(ConfigParse(" \n") == Config{});
}

TEST_F(PlatformConfig, SettingsChangeStoresAndNormalises) {
    ASSERT_FALSE(ConfigLoad());
    HostSettings changed = SettingsGet();
    changed.tick_rate = 120.0;
    changed.rumble_strength = 2.0f;
    ASSERT_TRUE(SettingsChange(changed));
    ASSERT_TRUE(SettingsGet().tick_rate == 120.0);
    ASSERT_TRUE(SettingsGet().rumble_strength == 1.0f);
    ASSERT_TRUE(ConfigParse(Read()).tick_rate == 120.0);
}

TEST_F(PlatformConfig, InvalidFilesAreBackedUpAndReplacedOnChange) {
    int backup_number = 0;
    for (const std::string text : {"", " \r\n\t", "{broken", "[]", "null", "42"}) {
        SCOPED_TRACE(text);
        Write(text);
        ASSERT_TRUE(ConfigLoad());
        EXPECT_EQ(Read(), text);
        Config changed = ConfigGet();
        changed.master_volume = 0.25f;
        ASSERT_TRUE(ConfigChange(changed));
        EXPECT_EQ(ConfigParse(Read()), changed);
        EXPECT_TRUE(nlohmann::json::parse(Read()).contains("game"));
        auto backup = Path();
        backup += ".bad";
        if (backup_number) {
            backup += "." + std::to_string(backup_number);
        }
        std::ifstream file(backup, std::ios::binary);
        ASSERT_TRUE(file);
        EXPECT_EQ(std::string(std::istreambuf_iterator<char>(file), {}), text);
        ++backup_number;
    }
    std::ifstream first(Path().string() + ".bad", std::ios::binary);
    EXPECT_EQ(std::string(std::istreambuf_iterator<char>(first), {}), "");
}

TEST_F(PlatformConfig, DirectoryCreatedAfterLoadIsNeverReplaced) {
    ASSERT_FALSE(ConfigLoad());
    fs::remove(Path());
    fs::create_directory(Path());
    Config changed = ConfigGet();
    changed.master_volume = 0.25f;
    EXPECT_FALSE(ConfigChange(changed));
    EXPECT_TRUE(fs::is_directory(Path()));
    EXPECT_FALSE(fs::exists(Path().string() + ".bad"));
}

TEST_F(PlatformConfig, ExistingUnreadableFileIsNeverOverwritten) {
    fs::create_directory(Path());
    ASSERT_FALSE(ConfigLoad());
    ASSERT_TRUE(SettingsGet() == static_cast<const HostSettings &>(Config{}));
    HostSettings changed = SettingsGet();
    changed.tick_rate = 120.0;
    ASSERT_FALSE(SettingsChange(changed));
    ASSERT_TRUE(SettingsGet().tick_rate == 120.0);
    ASSERT_FALSE(ConfigSave());
    ASSERT_TRUE(fs::is_directory(Path()));
    ASSERT_FALSE(fs::is_regular_file(Path()));
}

TEST_F(PlatformConfig, ChangeHookSeesBeforeAndAfter) {
    ASSERT_FALSE(ConfigLoad());
    g_hook_calls = 0;
    ConfigSetChangeHook(CaptureChange);
    HostSettings changed = SettingsGet();
    changed.tick_rate = 120.0;
    ASSERT_TRUE(SettingsChange(changed));
    ASSERT_TRUE(g_hook_calls == 1);
    ASSERT_TRUE(g_hook_before.tick_rate == kConfigTickRateDefault);
    ASSERT_TRUE(g_hook_after.tick_rate == 120.0);
    ASSERT_TRUE(SettingsChange(SettingsGet()));
    ASSERT_TRUE(g_hook_calls == 1);
    ConfigSetChangeHook(nullptr);
}

TEST_F(PlatformConfig, ConfigChangeStoresPortFieldsAndNotifiesTheLiveHook) {
    ConfigLoad();
    g_hook_calls = 0;
    ConfigSetChangeHook(CaptureChange);
    Config config = ConfigGet();
    config.interpolation = false;
    config.aspect = ConfigAspect::FourThree;
    config.ui_scale = 0.75f;
    EXPECT_TRUE(ConfigChange(config));
    EXPECT_EQ(ConfigGet(), config);
    EXPECT_EQ(ConfigParse(Read()), config);
    EXPECT_EQ(g_hook_calls, 1);
    EXPECT_TRUE(ConfigChange(config));
    EXPECT_EQ(g_hook_calls, 1);
    // A later host-only change must retain the port-owned fields.
    HostSettings host = SettingsGet();
    host.show_fps = false;
    EXPECT_TRUE(SettingsChange(host));
    EXPECT_FALSE(ConfigGet().interpolation);
    EXPECT_EQ(ConfigGet().aspect, ConfigAspect::FourThree);
    EXPECT_FLOAT_EQ(ConfigGet().ui_scale, .75f);
    ConfigSetChangeHook(nullptr);
}

TEST_F(PlatformConfig, FailedPortChangeKeepsLiveValuesAndRetriesTheSave) {
    ConfigLoad();
    fs::remove(Path());
    fs::create_directory(Path());
    Config config = ConfigGet();
    config.interpolation = false;
    EXPECT_FALSE(ConfigChange(config));
    EXPECT_FALSE(ConfigGet().interpolation);
    fs::remove(Path());
    EXPECT_TRUE(ConfigChange(config));
    EXPECT_FALSE(ConfigParse(Read()).interpolation);
}

TEST_F(PlatformConfig, ChangeMergesOnlyEditedFieldsIntoExternallyUpdatedJson) {
    Write(R"({"audio":{"master_volume":0.5},"input":{"bindings":{"cross":["K"]}},"extra":{"old":1}})");
    ASSERT_TRUE(ConfigLoad());
    Write(R"({"audio":{"master_volume":0.25,"future_mode":"custom"},"input":{"bindings":{"cross":["Z"],"future_action":["J"]}},"extra":{"old":2,"new":[1,2]},"stray":7})");
    Config changed = ConfigGet();
    changed.font_sharp = true;
    ASSERT_TRUE(ConfigChange(changed));
    auto json = nlohmann::json::parse(Read());
    EXPECT_EQ(json["audio"]["master_volume"], 0.25);
    EXPECT_EQ(json["audio"]["future_mode"], "custom");
    EXPECT_EQ(json["input"]["bindings"]["cross"][0], "Z");
    EXPECT_EQ(json["input"]["bindings"]["future_action"][0], "J");
    EXPECT_EQ(json["extra"]["old"], 2);
    EXPECT_EQ(json["extra"]["new"].size(), 2);
    EXPECT_EQ(json["stray"], 7);
    EXPECT_EQ(json["video"]["text_font"], "sharp");
    const auto before = Read();
    ASSERT_TRUE(ConfigChange(changed));
    EXPECT_EQ(Read(), before);
}

TEST_F(PlatformConfig, BindingResetPreservesUnrelatedExternalBindings) {
    Write(R"({"input":{"bindings":{"cross":["K"],"circle":["Q"]}}})");
    ASSERT_TRUE(ConfigLoad());
    Write(R"({"input":{"bindings":{"cross":["K"],"circle":["Z"],"future":["J"]}}})");
    Config changed = ConfigGet();
    changed.key_bindings.erase(changed.key_bindings.begin());
    ASSERT_TRUE(ConfigChange(changed));
    auto json = nlohmann::json::parse(Read());
    EXPECT_FALSE(json["input"]["bindings"].contains("cross"));
    EXPECT_EQ(json["input"]["bindings"]["circle"][0], "Z");
    EXPECT_EQ(json["input"]["bindings"]["future"][0], "J");
}

TEST_F(PlatformConfig, BindingEditsAndResetMergeCaseInsensitiveNames) {
    Write(R"({"input":{"bindings":{"Cross":["K"],"CiRcLe":["Q"]}}})");
    ASSERT_TRUE(ConfigLoad());
    Write(R"({"input":{"bindings":{"Cross":["K"],"CROSS":["X"],"CiRcLe":["Z"],"Future":["J"]}},"extra":{"Cross":42}})");
    Config changed = ConfigGet();
    changed.key_bindings[0].keys = {"V"};
    ASSERT_TRUE(ConfigChange(changed));
    auto json = nlohmann::json::parse(Read());
    EXPECT_EQ(json["input"]["bindings"].size(), 3);
    EXPECT_EQ(json["input"]["bindings"]["cross"][0], "V");
    EXPECT_FALSE(json["input"]["bindings"].contains("Cross"));
    EXPECT_FALSE(json["input"]["bindings"].contains("CROSS"));
    EXPECT_EQ(json["input"]["bindings"]["CiRcLe"][0], "Z");
    EXPECT_EQ(json["input"]["bindings"]["Future"][0], "J");
    EXPECT_EQ(json["extra"]["Cross"], 42);
    Write(R"({"input":{"bindings":{"CrOsS":["V"],"CiRcLe":["Z"],"Future":["J"]}}})");
    changed.key_bindings.erase(changed.key_bindings.begin());
    ASSERT_TRUE(ConfigChange(changed));
    json = nlohmann::json::parse(Read());
    EXPECT_FALSE(json["input"]["bindings"].contains("CrOsS"));
    EXPECT_EQ(json["input"]["bindings"].size(), 2);
}

namespace {
class FailingConfigBuffer : public std::streambuf {
public:
    std::string prefix;

    explicit FailingConfigBuffer(std::size_t bytes) : prefix(bytes, 'x') {
        setg(prefix.data(), prefix.data(), prefix.data() + prefix.size());
    }

    int_type underflow() override { throw std::ios_base::failure("injected read error"); }
};

std::streambuf *failing_config_buffer;

void InjectConfigReadFailure(std::istream &file) { file.rdbuf(failing_config_buffer); }
} // namespace

TEST_F(PlatformConfig, ReadErrorsNeverReplaceOriginalOrPublishPartialBackup) {
    const std::string original = "{broken but all original bytes must survive}";
    for (bool loading : {false, true}) {
        for (std::size_t bytes : {0u, 9000u}) {
            SCOPED_TRACE(loading);
            SCOPED_TRACE(bytes);
            ConfigSetReadHook(nullptr);
            Write(original);
            ASSERT_TRUE(ConfigLoad());
            FailingConfigBuffer buffer(bytes);
            failing_config_buffer = &buffer;
            ConfigSetReadHook(InjectConfigReadFailure);
            if (loading) {
                EXPECT_FALSE(ConfigLoad());
                EXPECT_FALSE(ConfigSave());
            } else {
                EXPECT_FALSE(ConfigSave());
            }
            EXPECT_FALSE(ConfigSaved());
            EXPECT_EQ(Read(), original);
            EXPECT_FALSE(fs::exists(Path().string() + ".bad"));
            ConfigSetReadHook(nullptr);
            // A failed load protects this session even after the I/O recovers.
            if (loading) {
                EXPECT_FALSE(ConfigSave());
            }
        }
    }
}
