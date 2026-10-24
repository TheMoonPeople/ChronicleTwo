#include <charconv>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <optional>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

#include <SDL3/SDL_platform.h>
#ifdef SDL_PLATFORM_IOS
// main stays this file's own entry point (and the PORT_OVERRIDE of the game's), so SDL must not rename it.
#define SDL_MAIN_HANDLED
#include <SDL3/SDL_main.h>
#endif

#include "audio/soundtrack.hpp"
#include "audio_init.hpp"
#include "crash/crash.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "exitcodes.hpp"
#include "gfx/gfx.hpp"
#include "identity.hpp"
#include "kazarov/data_version.hpp"
#include "log/log.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/config.hpp"
#include "platform/display.hpp"
#include "platform/firstrun.hpp"
#include "platform/input.hpp"
#include "platform/input_script.hpp"
#include "platform/input_startup.hpp"
#ifdef SDL_PLATFORM_IOS
#include "ios/ios.hpp"
#endif
#include "platform/paths.hpp"
#include "platform/settings.hpp"
#include "platform/window.hpp"
#include "present.hpp"
#include "profile.hpp"
#include "sce/threads.hpp"
#include "sound_port.hpp"
#include "test_hooks.hpp"

int VSyncCallBack(int field);

namespace {

constexpr float kLogicalWidth = 512.0f;
constexpr float kLogicalHeight = 480.0f;

struct Options {
    const char           *jump = nullptr;
    const char           *give = nullptr;
    const char           *log_level = nullptr;
    bool                  fast_load = false;
    bool                  skip_events = false;
    bool                  invincible = false;
    const char           *seed = nullptr;
    bool                  headless = false;
    bool                  offscreen = false;
    int                   frames = 0;
    int                   window_width = 0;
    int                   window_height = 0;
    int                   display_per_tick = 0;
    bool                  show_fps = false;
    bool                  log_fps = false;
    int                   screenshot_display = 0;
    bool                  screenshot_fps = false;
    std::filesystem::path screenshot;
    std::filesystem::path input;
    const char           *crash_test = nullptr; // hidden: --crash-test MODE[:early] (DC2_CRASH_TEST)
};

Options g_options;

[[noreturn]] void Usage(const char *program) {
    CT_LOG_ERROR(Main,
                 "usage: {} [--data DIR] [--run-dir DIR] [--save DIR] [--window WxH] [--headless] [--offscreen]\n          [--frames N] [--screenshot PATH] [--input SCRIPT] [--display-per-tick N]\n          [--show-fps] [--log-fps] [--screenshot-display N] [--screenshot-fps]\n          [--log-level SPEC]\n  --jump MODE[:ARG]  start in town:<map>, georama:<0-4>, dungeon:<n>[:<floor>], event:<id>, title, opening, menu (DC2_JUMP)\n  --fast-load        shorten loading-screen holds (DC2_FAST_LOAD=1)\n  --give ITEM,...    give missing items and weapons on arrival (DC2_GIVE)\n  --skip-events      enter a jumped dungeon floor directly; skip skippable dungeon scenes (DC2_SKIP_EVENTS=1)\n  --invincible       the dungeon character takes no hits (DC2_INVINCIBLE=1)\n  --seed N           reseed the random generator with N as each dungeon floor is built (DC2_SEED)\n  --run-dir DIR      game root containing data.zip and saves/\n                     (default: the per-user chronicletwo app data directory)\n  --data DIR         override the extracted data/ subdirectory (DC2_DATA)\n  --save DIR         override the saves/ subdirectory (DC2_SAVE)\n  --headless         render offscreen (SDL offscreen driver, VK_EXT_headless_surface)\n  --offscreen        --headless without a Vulkan surface: render to an image only\n  --frames N         exit after frame N of the game's main loop (N a positive integer)\n  --screenshot PATH  with --frames: write the last frame to PATH as a PNG on exit\n  --screenshot-display N  with --screenshot: also write N interpolated display frames of that frame\n                     beside PATH, as PATH-display-K.png for K = 0..N-1\n  --screenshot-fps   with --screenshot: draw the FPS counter and menu pointer into the written image\n  --input SCRIPT     drive the pads from an input script; live input is ignored\n  --window WxH       window size in pixels (default: config.json, then the monitor's)\n  --display-per-tick N  headless: also render N interpolated display frames per tick (discarded)\n  --show-fps         draw the FPS counter on presented frames, headless too\n  --log-fps          print the FPS counter's text on stderr every second\n  --log-level SPEC   trace, debug, info, warning, error, critical or off, and/or CATEGORY=LEVEL,\n                     comma-separated (DC2_LOG; default: config.json's log.level)",
                 program);
    LogFlush();
    std::exit(kExitUsage);
}

const char *OptionValue(int argc, const char **argv, int &i) {
    if (i + 1 >= argc) {
        Usage(argv[0]);
    }
    return argv[++i];
}

std::uint32_t ParseSeed(std::string_view text, const char *program) {
    std::uint32_t value = 0;
    const char   *last = text.data() + text.size();
    const auto [end, ec] = std::from_chars(text.data(), last, value);
    if (ec != std::errc() || end != last) {
        Usage(program);
    }
    return value;
}

int ParsePositive(std::string_view text, const char *program) {
    int         value = 0;
    const char *last = text.data() + text.size();
    const auto [end, ec] = std::from_chars(text.data(), last, value);
    if (ec != std::errc() || end != last || value <= 0) {
        Usage(program);
    }
    return value;
}

void ParseWindow(std::string_view text, Options &options, const char *program) {
    const char *last = text.data() + text.size();
    const auto [x, width_ec] = std::from_chars(text.data(), last, options.window_width);
    if (width_ec != std::errc() || x == last || (*x != 'x' && *x != 'X')) {
        Usage(program);
    }
    const auto [end, height_ec] = std::from_chars(x + 1, last, options.window_height);
    if (height_ec != std::errc() || end != last || options.window_width <= 0 || options.window_height <= 0) {
        Usage(program);
    }
}

Options ParseOptions(int argc, const char **argv) {
    Options options;
    for (int i = 1; i < argc; i++) {
        std::string_view arg = argv[i];
        if (arg == "--jump") {
            options.jump = OptionValue(argc, argv, i);
        } else if (arg == "--give") {
            options.give = OptionValue(argc, argv, i);
        } else if (arg == "--log-level") {
            options.log_level = OptionValue(argc, argv, i);
            if (!LogSpecValid(options.log_level)) {
                Usage(argv[0]);
            }
        } else if (arg == "--fast-load") {
            options.fast_load = true;
        } else if (arg == "--skip-events") {
            options.skip_events = true;
        } else if (arg == "--invincible") {
            options.invincible = true;
        } else if (arg == "--seed") {
            options.seed = OptionValue(argc, argv, i);
        } else if (arg == "--headless") {
            options.headless = true;
        } else if (arg == "--offscreen") {
            options.headless = true;
            options.offscreen = true;
        } else if (arg == "--frames") {
            options.frames = ParsePositive(OptionValue(argc, argv, i), argv[0]);
        } else if (arg == "--window") {
            ParseWindow(OptionValue(argc, argv, i), options, argv[0]);
        } else if (arg == "--display-per-tick") {
            options.display_per_tick = ParsePositive(OptionValue(argc, argv, i), argv[0]);
        } else if (arg == "--show-fps") {
            options.show_fps = true;
        } else if (arg == "--log-fps") {
            options.log_fps = true;
        } else if (arg == "--screenshot") {
            options.screenshot = PathsFromUtf8(OptionValue(argc, argv, i));
            if (options.screenshot.empty()) {
                Usage(argv[0]);
            }
        } else if (arg == "--screenshot-display") {
            options.screenshot_display = ParsePositive(OptionValue(argc, argv, i), argv[0]);
        } else if (arg == "--screenshot-fps") {
            options.screenshot_fps = true;
        } else if (arg == "--crash-test") {
            options.crash_test = OptionValue(argc, argv, i);
        } else if (arg == "--input") {
            options.input = PathsFromUtf8(OptionValue(argc, argv, i));
            if (options.input.empty()) {
                Usage(argv[0]);
            }
        } else {
            Usage(argv[0]);
        }
    }
    if (!options.screenshot.empty() && options.frames == 0) {
        Usage(argv[0]);
    }
    if ((options.screenshot_display > 0 || options.screenshot_fps) && options.screenshot.empty()) {
        Usage(argv[0]);
    }
    return options;
}

void ReportPipelineProgress(std::uint32_t done, std::uint32_t total) {
    static std::uint32_t reported = 0;
    constexpr std::uint32_t kSteps = 4;
    if (total == 0) {
        return;
    }
    const std::uint32_t step = done * kSteps / total;
    if (done == 0 || step > reported) {
        reported = step;
        CT_LOG_INFO(Gfx, "compiling shaders {}/{}", done, total);
    }
}

gfx::PresentMode PresentMode(ConfigPresentMode mode) {
    switch (mode) {
        case ConfigPresentMode::Mailbox:
            return gfx::PresentMode::Mailbox;
        case ConfigPresentMode::Immediate:
            return gfx::PresentMode::Immediate;
        default:
            return gfx::PresentMode::Fifo;
    }
}

gfx::RenderThreadMode RenderThread(ConfigRenderThread mode) {
    switch (mode) {
        case ConfigRenderThread::Lockstep:
            return gfx::RenderThreadMode::Lockstep;
        case ConfigRenderThread::Async:
            return gfx::RenderThreadMode::Async;
        default:
            return gfx::RenderThreadMode::Off;
    }
}

gfx::FrameLayout Layout(const Config &config) {
    return {.aspect = config.aspect == ConfigAspect::Auto ? gfx::AspectMode::Fill : gfx::AspectMode::Letterbox, .ui_scale = config.ui_scale};
}

PresentSettings PresentSettingsFor(const Config &config, const Options &options) {
    return {
        .interpolation = config.interpolation,
        .max_fps = config.max_fps,
        .display_per_tick = options.display_per_tick,
        .show_fps = options.show_fps || (config.show_fps && !options.headless),
        .fps_detail = config.fps_detail,
        .log_fps = options.log_fps,
    };
}

// A closed window ends the process here: the game has no stop request to ask its loop to return.
void PumpHost() {
    if (!WindowPollEvents()) {
        std::exit(kExitOk);
    }
    DisplayPump();
    InputPoll();
    InputScriptApply(mgPortFrameCount());

    // SetFrameLayout recreates frame targets; it must not run inside a tick's recording.
    if (!gfx::InFrame()) {
        mgPortSetFrameLayout(Layout(ConfigGet()));
    }
}

void ApplyConfigChange(const HostSettings &before, const HostSettings &after) {
    CT_PROFILE_REFRESH();
    LogApplyConfig(ConfigGet().log);
    if (before.present_mode != after.present_mode) {
        gfx::SetPresentMode(PresentMode(after.present_mode));
    }
    InputApplyGameConfig(after);
    SoundApplySettings();
    if (before.soundtrack != after.soundtrack) {
        audio::SoundtrackReload();
    }
    // HostSettings has no interpolation or aspect, so the present settings come from ConfigGet, which
    // already holds the new values. This also resets an F3 toggle of show_fps to the config's value.
    PresentSetSettings(PresentSettingsFor(ConfigGet(), g_options));
}

// The user's home as "~", so a shared log does not carry the account name.
std::string Redacted(const std::filesystem::path &path) {
    std::string text = PathsDisplay(path);
#ifdef _WIN32
    const wchar_t *home = _wgetenv(L"USERPROFILE");
#else
    const char *home = std::getenv("HOME");
#endif
    if (home == nullptr || *home == 0) {
        return text;
    }
    const std::string prefix = PathsDisplay(std::filesystem::path(home));
    if (!prefix.empty() && text.starts_with(prefix) &&
        (text.size() == prefix.size() || text[prefix.size()] == std::filesystem::path::preferred_separator)) {
        text.replace(0, prefix.size(), "~");
    }
    return text;
}

void LogSessionHeader() {
#ifdef CT_GIT_DESCRIBE
    constexpr std::string_view commit = CT_GIT_DESCRIBE;
#else
    constexpr std::string_view commit = "unknown";
#endif
#ifdef NDEBUG
    constexpr std::string_view build = "release";
#else
    constexpr std::string_view build = "debug";
#endif
#ifdef _WIN32
    constexpr std::string_view os = "Windows";
#elifdef __APPLE__
    constexpr std::string_view os = "macOS";
#else
    constexpr std::string_view os = "Linux";
#endif
    CT_LOG_FILE_INFO("session {}: Dark Chronicle {} ({} build, {}), data version {}", LogSessionId(), commit, build,
                     os, KAZAROV_DATA_VERSION);
    CT_LOG_FILE_INFO("session: data {}, saves {}", Redacted(PathsDataRoot()), Redacted(PathsSaveRoot()));
}

int Run(int argc, const char **argv) {
    GameSetIdentity();
    argc = PathsConsumeArgs(argc, argv);
    g_options = ParseOptions(argc, argv);
    const Options &options = g_options;
    LogInit({.headless = options.headless, .level_override = options.log_level ? options.log_level : SettingsEnv("LOG")});
    // Registered before AudioShutdown's, so it runs after it and writes the exit's last lines.
    std::atexit(LogShutdown);
    LogSessionHeader();

    CrashInit({.headless = options.headless || options.frames > 0 || !options.input.empty()});
    const char              *crash_test_text = options.crash_test ? options.crash_test : SettingsEnv("CRASH_TEST");
    std::optional<CrashTest> crash_test;
    if (crash_test_text && *crash_test_text && !(crash_test = CrashTestParse(crash_test_text))) {
        Usage(argv[0]);
    }
    const char *jump = options.jump ? options.jump : SettingsEnv("JUMP");
    const char *give = options.give ? options.give : SettingsEnv("GIVE");
    if ((jump && (options.jump || *jump) && !GameSetJump(jump)) ||
        (give && (options.give || *give) && !GameSetGive(give))) {
        Usage(argv[0]);
    }
    PortAutosave = !options.headless && !GameHasJump() && options.input.empty();
    const char *fast = SettingsEnv("FAST_LOAD");
    GameSetFastLoad(options.fast_load || (fast && *fast && *fast != '0'));
    const char *skip_events = SettingsEnv("SKIP_EVENTS");
    GameSetSkipEvents(options.skip_events || (skip_events && *skip_events && *skip_events != '0'));
    const char *invincible = SettingsEnv("INVINCIBLE");
    GameSetInvincible(options.invincible || (invincible && *invincible && *invincible != '0'));
    const char *seed = options.seed ? options.seed : SettingsEnv("SEED");
    if (seed && (options.seed || *seed)) {
        GameSetSeed(ParseSeed(seed, argv[0]));
    }
    InputScript input_script;
    if (!options.input.empty()) {
        std::string error;
        if (!InputScriptLoad(options.input, input_script, error)) {
            CT_LOG_ERROR(Main, "bad input script: {}", error);
            std::exit(kExitUsage);
        }
    }
    ConfigLoad();
    CT_PROFILE_REFRESH();
    LogAttachFile(PathsSaveRoot(), ConfigGet().log);
    CrashSetBundleRoot(PathsSaveRoot());
    if (crash_test) {
        CrashTestArm(*crash_test, CrashTestWhen::Early);
    }
    FirstRunRequireData(PathsDataRoot(), options.headless);
#ifdef SDL_PLATFORM_IOS
    // After the launcher, which the on-screen gamepad would cover.
    IosTouchOverlayStart();
#endif
    InitCDFile();
    if (!options.headless) {
        GameSetDataIcon();
    }
    if (!DataReadPrepareScriptTiming(options.headless)) {
        return kExitScriptTiming;
    }
    const HostSettings &settings = SettingsGet();
    const bool          offscreen = options.offscreen || (options.headless && !gfx::HeadlessSurfaceAvailable());

    DisplaySetOverrides(options.window_width, options.window_height, options.headless);
    WindowConfig window = DisplayWindowConfig(settings);
    window.vulkan = !offscreen;
    WindowInit(window);
    if (!options.headless) {
        CrashShowLastReportNotice();
    }
    // A scripted run takes no live input: no devices open, no window input events and no mouse capture.
    InputInitForRun(options.headless || !options.input.empty());
    InputScriptInstall(std::move(input_script));

    gfx::RendererConfig renderer;
    renderer.app_name = "Dark Chronicle";
    renderer.logical_width = kLogicalWidth;
    renderer.logical_height = kLogicalHeight;
    renderer.display_aspect = 4.0f / 3.0f;
    renderer.present_mode = PresentMode(settings.present_mode);
    renderer.pipeline_cache = PathsSaveRoot() / "pipeline_cache.bin";
    renderer.progress = ReportPipelineProgress;
    renderer.offscreen = offscreen;
    renderer.layout = Layout(ConfigGet());
    renderer.prog0_meshes = true;
    renderer.validation = renderer.validation || SettingsEnv("VULKAN_VALIDATION") != nullptr;
    // DC2_RENDER_SCALE: pixels per PS2 line of the render targets, 0 for the window's height over 480.
    if (const char *setting = SettingsEnv("RENDER_SCALE")) {
        char       *end = nullptr;
        const float scale = std::strtof(setting, &end);
        if (end != setting && scale >= 0.0f && scale <= 8.0f) {
            renderer.render_scale = scale;
        }
    }
    renderer.render_thread = RenderThread(ConfigGet().render_thread);
    if (const char *setting = SettingsEnv("RENDER_THREAD")) {
        if (auto mode = gfx::ParseRenderThreadMode(setting)) {
            renderer.render_thread = *mode;
        }
    }
    // Headless and screenshot runs stay deterministic: no render thread.
    if (options.headless || !options.screenshot.empty()) {
        renderer.render_thread = gfx::RenderThreadMode::Off;
    }
    gfx::RendererInit(WindowHandle(), renderer);
    PresentSetSettings(PresentSettingsFor(ConfigGet(), g_options));
    AudioInit(options.headless);
    // --frames leaves through std::exit from mgEndFrame: the output must stop before the mixer's statics are destroyed
    // under the audio thread.
    std::atexit(AudioShutdown);

    ClockSetTickRate(kConfigTickRateDefault);
    ClockSetUnbounded(options.headless);
    ClockAddPumpHook(PumpHost);
    ClockSetTickCallback(VSyncCallBack);
    ConfigSetChangeHook(ApplyConfigChange);

    MainThreadPriority = 10;
    KzThreadsSetMainPriority(MainThreadPriority);
    if (options.frames > 0) {
        mgPortSetScreenshotOptions({.display_frames = options.screenshot_display, .fps = options.screenshot_fps});
        mgPortExitAfterFrames(options.frames, options.screenshot);
    }
    if (crash_test) {
        CrashTestArm(*crash_test, CrashTestWhen::FirstFrame);
    }
    CT_PROFILE_THREAD("Game / host");
    MainLoop();

    ClockRemovePumpHook(PumpHost);
    ConfigSetChangeHook(nullptr);
    InputShutdown();
    AudioShutdown();
    gfx::SetRenderIdleHook(nullptr, nullptr);
    gfx::RendererShutdown();
    WindowShutdown();
    CT_LOG_FILE_INFO("main: exit {}", static_cast<int>(kExitOk));
    LogShutdown();
    return kExitOk;
}

} // namespace

#ifdef SDL_PLATFORM_IOS
// UIKit owns the process: SDL_RunApp starts the application delegate, which calls back into Run once it is up.
static int IosMain(int argc, char **argv) {
    // iOS shows no console: stderr goes to Documents, where the Files app reaches it, from the first line on.
    if (const char *home = std::getenv("HOME")) {
        const std::string log = std::string(home) + "/Documents/stderr.log";
        if (std::freopen(log.c_str(), "w", stderr) != nullptr) {
            std::setvbuf(stderr, nullptr, _IONBF, 0);
            std::fprintf(stderr, "darkchronicle: started\n");
        }
        // iOS has no way to start the game with environment variables, so chronicletwo/env.txt in Documents
        // holds them, one KEY=VALUE a line: the DC2_ settings, or MoltenVK's MVK_CONFIG_ and Metal's MTL_ ones for
        // diagnosing the renderer. Each is set before SDL and the renderer start.
        std::ifstream env(std::string(home) + "/Documents/chronicletwo/env.txt");
        for (std::string line; std::getline(env, line);) {
            if (!line.empty() && line.back() == '\r') {
                line.pop_back();
            }
            const std::size_t equals = line.find('=');
            if (line.empty() || line.front() == '#' || equals == std::string::npos || equals == 0) {
                continue;
            }
            const std::string key = line.substr(0, equals);
            const std::string value = line.substr(equals + 1);
            setenv(key.c_str(), value.c_str(), 1);
            std::fprintf(stderr, "darkchronicle: env %s=%s\n", key.c_str(), value.c_str());
        }
    }
    return Run(argc, const_cast<const char **>(argv));
}
#endif

PORT_OVERRIDE int main(int argc, const char **argv) {
#ifdef SDL_PLATFORM_IOS
    return SDL_RunApp(argc, const_cast<char **>(argv), IosMain, nullptr);
#else
    return Run(argc, argv);
#endif
}

#ifdef _WIN32
int wmain(int argc, wchar_t **wide_argv) {
    std::vector<std::string>  args;
    std::vector<const char *> argv;
    args.reserve(argc);
    for (int i = 0; i < argc; ++i) {
        args.push_back(PathsDisplay(std::filesystem::path(wide_argv[i])));
    }
    argv.reserve(args.size());
    for (const std::string &arg : args) {
        argv.push_back(arg.c_str());
    }
    argv.push_back(nullptr);
    return Run(argc, argv.data());
}
#endif
