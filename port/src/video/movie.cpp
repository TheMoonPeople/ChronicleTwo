#include "common.h"

#include <algorithm>
#include <cctype>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <optional>
#include <string>

#include "audio/mixer.hpp"
#include "audio_assets.hpp"
#include "gfx/gfx.hpp"
#include "log/log.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "movie.hpp"
#include "platform/clock.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "render/renderer.hpp"
#include "render/texture_runtime.hpp"
#include "video/movie_playback.hpp"
#include "video/player.hpp"

namespace {

// The retail player is one set of file-scope statics, so one movie plays at a time.
struct MovieState {
    video::MoviePlayer                    player;
    std::filesystem::path                 path;
    std::string                           texture;
    bool                                  loaded = false;
    bool                                  opened = false;
    bool                                  playing = false;
    bool                                  started = false;
    bool                                  loop = false;
    bool                                  with_audio = false;
    bool                                  audio_on = false;
    int64_t                               start_tick = 0;
    std::chrono::steady_clock::time_point start_time;  /**< Host time when playback starts. */
    int64_t                               elapsed = 0; /**< Last playback time in 90 kHz units. */
    gfx::TextureHandle                    uploaded_to = gfx::kNullTexture;
    bool                                  dirty = false;
};

MovieState g_movie;
/** Host clock override for deterministic playback tests. */
MoviePortNow g_now = nullptr;

/**
 * Returns the host time used to synchronize movie pictures with audio.
 */
std::chrono::steady_clock::time_point Now() {
    return g_now != nullptr ? g_now() : std::chrono::steady_clock::now();
}

void MovieStartAudio() {
    audio::Mixer &mixer = audio::DefaultMixer();
    mixer.SetStream(kMoviePortAudioPort, g_movie.player.Audio());
    mixer.SetVolume(kMoviePortAudioPort, audio::kFullPortVolume);
    mixer.Play(kMoviePortAudioPort);
    g_movie.audio_on = true;
}

/**
 * Anchors the movie clock to the start of audio playback.
 */
void MovieStartClock() {
    g_movie.start_tick = ClockTickCount();
    g_movie.start_time = Now();
    g_movie.elapsed = 0;
}

void MoviePump() {
    const int64_t elapsed =
        ClockUnbounded()
            ? std::llround(static_cast<double>(ClockTickCount() - g_movie.start_tick) * 90000.0 / ClockTickRate())
            : std::llround(std::chrono::duration<double>(Now() - g_movie.start_time).count() * 90000.0);
    g_movie.elapsed = elapsed;
    if (g_movie.player.Advance(elapsed)) {
        g_movie.dirty = true;
    }
}

/**
 * Reports playback that exceeds the container duration and stall allowance.
 */
bool MovieOverran() {
    const int64_t length = g_movie.player.Length();
    if (!MoviePortOverran(g_movie.elapsed, length)) {
        return false;
    }
    CT_LOG_WARN(Movie, "movie: {} still has pictures to show {:.1f} s past its {:.1f} s length; ending it",
                PathsDisplay(g_movie.path), static_cast<double>(kMoviePortOverrun) / 90000.0,
                static_cast<double>(length) / 90000.0);
    return true;
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
    // A 2x or 4x replacement fills the texture at that many host texels per retail texel, so the game's quad, which
    // keeps its retail texel coordinates, shows the whole picture over the same area.
    MgTextureSetPhysicalScale(texture, static_cast<uint32_t>(g_movie.player.Scale()));
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
    g_movie.start_tick = 0;
    g_movie.start_time = {};
    g_movie.elapsed = 0;
    g_movie.uploaded_to = gfx::kNullTexture;
    g_movie.dirty = false;
}

} // namespace

std::filesystem::path dc2::video::MoviePath(std::string_view name) {
    std::string rel(name);

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

void CMovie::Load(std::string_view name, int width, int height, bool with_audio, bool loop) {
    Term();
    g_movie.loaded = true;
    g_movie.path = dc2::video::MoviePath(name);
    g_movie.with_audio = with_audio;
    g_movie.loop = loop;
    g_movie.player.SetRetailSize(width, height);
    g_movie.opened = g_movie.player.Open(g_movie.path, with_audio);
    if (!g_movie.opened) {
        CT_LOG_WARN(Movie, "movie: {} not found or not a playable MP4 ({})", name,
                    PathsDisplay(g_movie.path));
    } else if (g_movie.player.SourceWidth() != g_movie.player.Width() ||
               g_movie.player.SourceHeight() != g_movie.player.Height()) {
        CT_LOG_INFO(Movie, "movie: {} is {}x{}; a replacement should be 1, 2 or 4 times {}x{}, so it is resampled to {}x{}",
                    name, g_movie.player.SourceWidth(), g_movie.player.SourceHeight(), width, height,
                    g_movie.player.Width(), g_movie.player.Height());
    }
}

void CMovie::Play(char *path) {
    CT_LOG_DEBUG(Movie, "playing movie {}", path);
    g_movie.texture = path;
    g_movie.playing = true;
    g_movie.started = true;
    is_playing = true;
    g_movie.dirty = true;
    if (g_movie.opened && g_movie.with_audio && g_movie.player.Audio() != nullptr) {
        MovieStartAudio();
    }
    MovieStartClock();
    MovieUpload();
}

void CMovie::SwitchThread() {
    if (g_movie.playing) {
        MoviePump();
        MovieUpload();
    }
}

void CMovie::Term() {
    MovieReset();
    is_playing = false;
}

int CMovie::EndCheck() {
    if (!g_movie.playing) {
        return g_movie.loaded ? 0 : 1;
    }
    if (!g_movie.opened) {
        return 1;
    }

    MoviePump();
    if (!g_movie.player.Ended() && !MovieOverran()) {
        return 0;
    }
    if (!g_movie.loop) {
        return 1;
    }

    g_movie.opened = g_movie.player.Open(g_movie.path, g_movie.with_audio);
    if (!g_movie.opened) {
        return 1;
    }
    g_movie.dirty = true;
    if (g_movie.with_audio && g_movie.player.Audio() != nullptr) {
        MovieStartAudio();
    }
    MovieStartClock();
    return 0;
}

int CMovie::IsStarted() {
    return g_movie.started ? 1 : 0;
}

int64_t MoviePortClock() {
    return g_movie.elapsed;
}

bool MoviePortOverran(int64_t elapsed, int64_t length) {
    return length > 0 && elapsed > length && elapsed - length > kMoviePortOverrun;
}

void MoviePortSetNow(MoviePortNow now) {
    g_now = now;
}
