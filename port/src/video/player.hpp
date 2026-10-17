#pragma once
#include <cstdint>
#include <deque>
#include <filesystem>
#include <functional>
#include <memory>
#include <optional>
#include <utility>
#include <vector>

#include "audio/pcm.hpp"

struct AVFrame;

namespace video {
/**
 * Plays a standard MP4 with embedded audio against the game's movie clock.
 */
class MoviePlayer {
public:
    /**
     * Returns the size a decoded picture of width x height is shown at; libswscale resamples it when they differ.
     */
    using PictureFit = std::function<std::pair<int, int>(int width, int height)>;

    MoviePlayer();
    ~MoviePlayer();
    MoviePlayer(const MoviePlayer &) = delete;
    MoviePlayer                           &operator=(const MoviePlayer &) = delete;
    bool                                   Open(const std::filesystem::path &path, bool with_audio);
    void                                   Close();
    bool                                   IsOpen() const;
    bool                                   Advance(int64_t elapsed);
    bool                                   HasPicture() const;
    int                                    Width() const;
    int                                    Height() const;
    const std::vector<uint8_t>            &Rgba() const;
    bool                                   Ended() const;
    std::shared_ptr<const audio::PcmTrack> Audio() const;
    int64_t                                PicturesShown() const;
    // The current picture's size as decoded, before any fit.
    int SourceWidth() const;
    int SourceHeight() const;
    // Applies to the pictures decoded after the next Open; empty keeps each picture's own size.
    void SetPictureFit(PictureFit fit);
    // Streams of more pixels than this, from the next Open, decode on FFmpeg's threads (tests lower it).
    void SetThreadedDecodePixels(int64_t pixels);
    // FFmpeg's decoder threads for the open stream; 0 when closed.
    int DecoderThreadCount() const;
    // Decoder threads for a stream of pixels: 1 up to threaded_pixels, else one per core up to 8 (2 if unknown).
    static int DecoderThreads(int64_t pixels, int64_t threaded_pixels, unsigned cores);
    // Default for SetThreadedDecodePixels: 512x512, above the retail 512x416.
    static constexpr int64_t kThreadedDecodePixels = 512 * 512;

private:
    struct Frame {
        int                      width = 0;
        int                      height = 0;
        int                      source_width = 0;
        int                      source_height = 0;
        int64_t                  pts = 0;
        std::shared_ptr<AVFrame> decoded; // Until the picture is shown and converted into rgba.
        std::vector<uint8_t>     rgba;
    };
    struct Impl;
    void                                   Pump();
    std::unique_ptr<Impl>                  impl_;
    std::deque<Frame>                      queue_;
    bool                                   input_exhausted_ = false;
    std::optional<int64_t>                 first_pts_;
    int64_t                                shown_pts_ = 0;
    int64_t                                elapsed_last_ = 0;
    int                                    width_ = 0;
    int                                    height_ = 0;
    int                                    source_width_ = 0;
    int                                    source_height_ = 0;
    PictureFit                             fit_;
    int64_t                                threaded_pixels_ = kThreadedDecodePixels;
    std::vector<uint8_t>                   rgba_;
    int64_t                                pictures_shown_ = 0;
    std::shared_ptr<const audio::PcmTrack> audio_;
};
} // namespace video
