#include <charconv>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

#include "audio/soundtrack.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "exitcodes.hpp"
#include "gfx/gfx.hpp"
#include "identity.hpp"
#include "mainloop.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"
#include "platform/config.hpp"
#include "platform/display.hpp"
#include "platform/firstrun.hpp"
#include "platform/input.hpp"
#include "platform/input_script.hpp"
#include "platform/input_startup.hpp"
#include "platform/paths.hpp"
#include "platform/settings.hpp"
#include "platform/window.hpp"
#include "present.hpp"
#include "sce/threads.hpp"
#include "sound_port.hpp"
#include "mainloop_port.hpp"
#include "test_hooks.hpp"

// The audio branch adds audio_init.hpp; until it lands the port builds without audio.
#if __has_include("audio_init.hpp")
#include "audio_init.hpp"
#define CT_HAVE_AUDIO_INIT 1
#endif

int VSyncCallBack(int field);

namespace {

constexpr float kLogicalWidth = 512.0f;
constexpr float kLogicalHeight = 480.0f;

struct Options {
    const char           *jump = nullptr;
    const char           *give = nullptr;
    bool                  fast_load = false;
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
};

Options g_options;

[[noreturn]] void Usage(const char *program) {
    std::fprintf(stderr,
                 "usage: %s [--data DIR] [--run-dir DIR] [--save DIR] [--window WxH] [--headless] [--offscreen]\n"
                 "          [--frames N] [--screenshot PATH] [--input SCRIPT] [--display-per-tick N]\n"
                 "          [--show-fps] [--log-fps] [--screenshot-display N] [--screenshot-fps]\n"
                 "  --jump MODE[:ARG]  start in town:<map>, dungeon:<n>[:<floor>], event:<id>, title, opening, menu (DC2_JUMP)\n"
                 "  --fast-load        shorten loading-screen holds (DC2_FAST_LOAD=1)\n"
                 "  --give ITEM,...    give missing items and weapons on arrival (DC2_GIVE)\n"
                 "  --run-dir DIR      game root containing data/, port_data/ and saves/\n"
                 "                     (default: the per-user chronicletwo app data directory)\n"
                 "  --data DIR         override the extracted data/ subdirectory (DC2_DATA)\n"
                 "  --save DIR         override the saves/ subdirectory (DC2_SAVE)\n"
                 "  --headless         render offscreen (SDL offscreen driver, VK_EXT_headless_surface)\n"
                 "  --offscreen        --headless without a Vulkan surface: render to an image only\n"
                 "  --frames N         exit after frame N of the game's main loop (N a positive integer)\n"
                 "  --screenshot PATH  with --frames: write the last frame to PATH as a PNG on exit\n"
                 "  --screenshot-display N  with --screenshot: also write N interpolated display frames of that frame\n"
                 "                     beside PATH, as PATH-display-K.png for K = 0..N-1\n"
                 "  --screenshot-fps   with --screenshot: draw the FPS counter into the written image\n"
                 "  --input SCRIPT     drive the pads named in SCRIPT from an input script\n"
                 "  --window WxH       window size in pixels (default: config.json, then the monitor's)\n"
                 "  --display-per-tick N  headless: also render N interpolated display frames per tick (discarded)\n"
                 "  --show-fps         draw the FPS counter on presented frames, headless too\n"
                 "  --log-fps          print the FPS counter's text on stderr every second\n",
                 program);
    std::exit(kExitUsage);
}

const char *OptionValue(int argc, const char **argv, int &i) {
    if (i + 1 >= argc) {
        Usage(argv[0]);
    }
    return argv[++i];
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
        } else if (arg == "--fast-load") {
            options.fast_load = true;
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
    static std::uint32_t    reported = 0;
    constexpr std::uint32_t kSteps = 4;
    if (total == 0) {
        return;
    }
    std::uint32_t step = done * kSteps / total;
    if (done == 0 || step > reported) {
        reported = step;
        std::fprintf(stderr, "compiling shaders %u/%u\n", done, total);
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

gfx::FrameLayout Layout(const Config &config) {
    return {config.aspect == ConfigAspect::Auto ? gfx::AspectMode::Fill : gfx::AspectMode::Letterbox, config.ui_scale};
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
        const gfx::FrameLayout layout = Layout(ConfigGet());
        const gfx::FrameLayout current = gfx::CurrentFrameLayout();
        if (layout.aspect != current.aspect || layout.ui_scale != current.ui_scale) {
            gfx::SetFrameLayout(layout);
        }
    }
}

void ApplyConfigChange(const HostSettings &before, const HostSettings &after) {
    if (before.present_mode != after.present_mode) {
        gfx::SetPresentMode(PresentMode(after.present_mode));
    }
    InputApplyConfig(after);
    SoundApplySettings();
    if (before.soundtrack != after.soundtrack) {
        audio::SoundtrackReload();
    }
    // HostSettings has no interpolation or aspect, so the present settings come from ConfigGet, which
    // already holds the new values. This also resets an F3 toggle of show_fps to the config's value.
    PresentSetSettings(PresentSettingsFor(ConfigGet(), g_options));
}

int Run(int argc, const char **argv) {
    GameSetIdentity();
    argc = PathsConsumeArgs(argc, argv);
    g_options = ParseOptions(argc, argv);
    const Options &options = g_options;
    const char    *jump = options.jump ? options.jump : SettingsEnv("JUMP");
    const char    *give = options.give ? options.give : SettingsEnv("GIVE");
    if ((jump && (options.jump || *jump) && !GameSetJump(jump)) ||
        (give && (options.give || *give) && !GameSetGive(give))) {
        Usage(argv[0]);
    }
    PortAutosave = !options.headless && !GameHasJump() && options.input.empty();
    const char *fast = SettingsEnv("FAST_LOAD");
    GameSetFastLoad(options.fast_load || (fast && *fast && *fast != '0'));
    InputScript   input_script;
    if (!options.input.empty()) {
        std::string error;
        if (!InputScriptLoad(options.input, input_script, error)) {
            std::fprintf(stderr, "bad input script: %s\n", error.c_str());
            std::exit(kExitUsage);
        }
    }
    ConfigLoad();
    FirstRunRequireData(PathsDataRoot(), options.headless);
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
    InputInitForRun(options.headless);
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
    gfx::RendererInit(WindowHandle(), renderer);
    PresentSetSettings(PresentSettingsFor(ConfigGet(), g_options));
#ifdef CT_HAVE_AUDIO_INIT
    AudioInit(options.headless);
    // --frames leaves through std::exit from mgEndFrame: the output must stop before the mixer's statics are destroyed
    // under the audio thread.
    std::atexit(AudioShutdown);
#endif

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
    MainLoop();

    ClockRemovePumpHook(PumpHost);
    ConfigSetChangeHook(nullptr);
    InputShutdown();
#ifdef CT_HAVE_AUDIO_INIT
    AudioShutdown();
#endif
    gfx::RendererShutdown();
    WindowShutdown();
    return kExitOk;
}

} // namespace

PORT_OVERRIDE int main(int argc, const char **argv) {
    return Run(argc, argv);
}

#ifdef _WIN32
int wmain(int argc, wchar_t **wide_argv) {
    std::vector<std::string>  args;
    std::vector<const char *> argv;
    for (int i = 0; i < argc; ++i) {
        args.push_back(PathsDisplay(std::filesystem::path(wide_argv[i])));
    }
    for (const std::string &arg : args) {
        argv.push_back(arg.c_str());
    }
    argv.push_back(nullptr);
    return Run(argc, argv.data());
}
#endif
