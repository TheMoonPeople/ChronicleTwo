#include "common.h"

#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <optional>
#include <string>
#include <utility>

#include "audio/mixer.hpp"
#include "audio_assets.hpp"
#include "gfx/gfx.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "movie.hpp"
#include "movie_port.hpp"
#include "platform/clock.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "video/player.hpp"

namespace {

// The retail player is one set of file-scope statics, so one movie plays at a time.
struct MovieState {
    video::MoviePlayer    player;
    std::filesystem::path path;
    std::string           texture;
    bool                  loaded = false;
    bool                  opened = false;
    bool                  playing = false;
    bool                  started = false;
    bool                  loop = false;
    bool                  with_audio = false;
    bool                  audio_on = false;
    int                   retail_width = 0;
    int                   retail_height = 0;
    int64_t               start_tick = 0;
    gfx::TextureHandle    uploaded_to = gfx::kNullTexture;
    bool                  dirty = false;
};

MovieState g_movie;

void MovieStartAudio() {
    audio::Mixer &mixer = audio::DefaultMixer();
    mixer.SetStream(kMoviePortAudioPort, g_movie.player.Audio());
    mixer.SetVolume(kMoviePortAudioPort, audio::kFullPortVolume);
    mixer.Play(kMoviePortAudioPort);
    g_movie.audio_on = true;
}

void MoviePump() {
    const int64_t elapsed =
        std::llround(static_cast<double>(ClockTickCount() - g_movie.start_tick) * 90000.0 / ClockTickRate());
    if (g_movie.player.Advance(elapsed)) {
        g_movie.dirty = true;
    }
}

void MovieUpload() {
    if (!g_movie.opened || !g_movie.player.HasPicture() || !mgPortRendererReady()) {
        return;
    }

    // The game draws the picture through its own "moviework" texture, as on the PS2, so the fades and the
    // letterboxing stay the game's.
    mgCTexture *texture = mgTexManager.GetTexture(g_movie.texture.data(), -1);
    if (texture == nullptr) {
        return;
    }
    // A 2x or 4x replacement fills the texture at that many host texels per retail texel; the game's quad keeps
    // its retail coordinates and so shows the whole picture over the same area.
    const int scale = MoviePortFit(g_movie.retail_width, g_movie.retail_height, g_movie.player.Width(),
                                   g_movie.player.Height())
                          .scale;
    MgTextureSetPhysicalScale(texture, static_cast<uint32_t>(scale));
    const gfx::TextureHandle target = mgPortFindTexture(texture).texture;
    if (target == gfx::kNullTexture || (!g_movie.dirty && target == g_movie.uploaded_to)) {
        return;
    }
    const std::optional<gfx::TextureInfo> info = gfx::GetTextureInfo(target);
    if (!info) {
        return;
    }

    const uint32_t width = std::min(info->pixel_width, static_cast<uint32_t>(g_movie.player.Width()));
    const uint32_t height = std::min(info->pixel_height, static_cast<uint32_t>(g_movie.player.Height()));
    // Alpha is 0xFF, the renderer's opaque; the IPU's opaque is GS 0x80, which would draw half-transparent here.
    gfx::UpdateTexture(target, 0, 0, 0, width, height, g_movie.player.Rgba().data(),
                       static_cast<uint32_t>(g_movie.player.Width()));
    g_movie.uploaded_to = target;
    g_movie.dirty = false;
}

void MovieReset() {
    if (g_movie.audio_on) {
        audio::DefaultMixer().Stop(kMoviePortAudioPort);
        audio::DefaultMixer().SetStream(kMoviePortAudioPort, nullptr);
    }
    g_movie.player.Close();
    g_movie.path.clear();
    g_movie.texture.clear();
    g_movie.loaded = false;
    g_movie.opened = false;
    g_movie.playing = false;
    g_movie.started = false;
    g_movie.loop = false;
    g_movie.with_audio = false;
    g_movie.audio_on = false;
    g_movie.retail_width = 0;
    g_movie.retail_height = 0;
    g_movie.start_tick = 0;
    g_movie.uploaded_to = gfx::kNullTexture;
    g_movie.dirty = false;
}

} // namespace

std::filesystem::path MoviePortPath(const char *name) {
    std::string rel = name;

    const size_t colon = rel.find(':');
    if (colon != std::string::npos &&
        std::all_of(rel.begin(), rel.begin() + colon, [](unsigned char c) { return std::isalnum(c) != 0; })) {
        rel.erase(0, colon + 1);
    }
    while (!rel.empty() && (rel.front() == '\\' || rel.front() == '/')) {
        rel.erase(0, 1);
    }
    const size_t semicolon = rel.rfind(';');
    if (semicolon != std::string::npos && semicolon + 1 < rel.size() &&
        std::all_of(rel.begin() + semicolon + 1, rel.end(), [](unsigned char c) { return std::isdigit(c) != 0; })) {
        rel.erase(semicolon);
    }
    for (char &c : rel) {
        if (c == '\\') {
            c = '/';
        } else if (c >= 'A' && c <= 'Z') {
            c = static_cast<char>(c - 'A' + 'a');
        }
    }
    const std::filesystem::path native = rel;
    if (native.extension() != ".mp4") {
        return {};
    }
    return rel.starts_with("movie/") ? native : std::filesystem::path("movie") / native;
}

MoviePortPicture MoviePortFit(int retail_width, int retail_height, int width, int height) {
    if (retail_width <= 0 || retail_height <= 0) {
        return {width, height, 1};
    }
    int scale = kMoviePortMaxScale;
    while (scale > 1 && (width < retail_width * scale || height < retail_height * scale)) {
        scale /= 2;
    }
    return {retail_width * scale, retail_height * scale, scale};
}

// The retail pools are replaced by the host's allocator. init_sound would reset the PS2 sound driver, which the
// shared mixer does not need. The width and height are the retail picture size, which a replacement multiplies.
PORT_OVERRIDE void CMovie::Load(char *name, mgCMemory **, int width, int height, bool with_audio, bool loop, bool) {
    Term();
    g_movie.loaded = true;
    g_movie.path = MoviePortPath(name);
    g_movie.with_audio = with_audio;
    g_movie.loop = loop;
    g_movie.retail_width = width;
    g_movie.retail_height = height;
    g_movie.player.SetPictureFit([width, height](int picture_width, int picture_height) {
        const MoviePortPicture fit = MoviePortFit(width, height, picture_width, picture_height);
        return std::pair{fit.width, fit.height};
    });
    g_movie.opened = g_movie.player.Open(g_movie.path, with_audio);
    if (!g_movie.opened) {
        std::fprintf(stderr, "movie: %s not found or not a playable MP4 (%s)\n", name,
                     PathsDisplay(g_movie.path).c_str());
    } else if (g_movie.player.SourceWidth() != g_movie.player.Width() ||
               g_movie.player.SourceHeight() != g_movie.player.Height()) {
        std::fprintf(stderr, "movie: %s is %dx%d; a replacement should be 1, 2 or 4 times %dx%d, so it is shown resampled to %dx%d\n",
                     name, g_movie.player.SourceWidth(), g_movie.player.SourceHeight(), width, height,
                     g_movie.player.Width(), g_movie.player.Height());
    }
}

PORT_OVERRIDE void CMovie::Play(char *path) {
    g_movie.texture = path;
    g_movie.playing = true;
    g_movie.started = true;
    is_playing = true;
    g_movie.start_tick = ClockTickCount();
    g_movie.dirty = true;
    if (g_movie.opened && g_movie.with_audio && g_movie.player.Audio() != nullptr) {
        MovieStartAudio();
    }
    MovieUpload();
}

PORT_OVERRIDE void CMovie::SwitchThread() {
    if (g_movie.playing) {
        MoviePump();
        MovieUpload();
    }
}

PORT_OVERRIDE void CMovie::Term() {
    MovieReset();
    is_playing = false;
}

PORT_OVERRIDE int CMovie::EndCheck() {
    if (!g_movie.playing) {
        return g_movie.loaded ? 0 : 1;
    }
    if (!g_movie.opened) {
        return 1;
    }

    MoviePump();
    if (!g_movie.player.Ended()) {
        return 0;
    }
    if (!g_movie.loop) {
        return 1;
    }

    g_movie.opened = g_movie.player.Open(g_movie.path, g_movie.with_audio);
    if (!g_movie.opened) {
        return 1;
    }
    g_movie.start_tick = ClockTickCount();
    g_movie.dirty = true;
    if (g_movie.with_audio && g_movie.player.Audio() != nullptr) {
        MovieStartAudio();
    }
    return 0;
}

PORT_OVERRIDE int CMovie::IsStarted() {
    return g_movie.started ? 1 : 0;
}
