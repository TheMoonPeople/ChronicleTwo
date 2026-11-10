#pragma once
#include <cstdint>
#include <deque>
#include <filesystem>
#include <memory>
#include <optional>
#include <vector>

#include "audio/pcm.hpp"

struct AVFrame;

namespace video {
/**
 * Size a movie picture is shown at, and the host texels per retail texel it fills the movie texture with.
 */
struct PictureFit {
    int width = 0;  /**< Shown width in pixels. */
    int height = 0; /**< Shown height in pixels. */
    int scale = 1;  /**< 1, 2 or 4. */
};

/**
 * Fits a decoded picture to 1, 2 or 4 times the retail size: an exact multiple is kept and any other size becomes the
 * largest multiple it covers, or the retail size when it covers none. A zero retail size keeps the picture.
 */
PictureFit FitPicture(int retail_width, int retail_height, int width, int height);

/**
 * Counts the undecodable packets and pictures a movie passes over. More than kMaxInARow in a row, with no picture
 * decoded between them, stop the movie, so a decoder that rejects everything cannot hold the game in one Advance.
 */
class DecodeRejections {
public:
    static constexpr int kMaxInARow = 250; /**< Ten seconds of 25 fps pictures. */
    /**
     * Counts a rejection and reports whether decoding may continue.
     */
    bool Skip();
    /**
     * Resets consecutive rejections after a successfully decoded picture.
     */
    void Decoded();
    /**
     * Returns the total number of rejected packets and pictures.
     */
    [[nodiscard]] int64_t Total() const;

private:
    int     run = 0;   /**< Rejections since the last decoded picture. */
    int64_t total = 0; /**< Rejections since Open. */
};

/**
 * Plays a standard MP4 with embedded audio against the game's movie clock.
 */
class MoviePlayer {
public:
    MoviePlayer();
    ~MoviePlayer();
    MoviePlayer(const MoviePlayer &) = delete;
    MoviePlayer                                         &operator=(const MoviePlayer &) = delete;
    bool                                                 Open(const std::filesystem::path &path, bool with_audio);
    void                                                 Close();
    [[nodiscard]] bool                                   IsOpen() const;
    bool                                                 Advance(int64_t elapsed);
    [[nodiscard]] bool                                   HasPicture() const;
    [[nodiscard]] int                                    Width() const;
    [[nodiscard]] int                                    Height() const;
    [[nodiscard]] const std::vector<uint8_t>            &Rgba() const;
    [[nodiscard]] bool                                   Ended() const;
    [[nodiscard]] std::shared_ptr<const audio::PcmTrack> Audio() const;
    [[nodiscard]] int64_t                                PicturesShown() const;
    /**
     * The container's duration on the 90 kHz movie clock, the longer of its tracks; 0 when closed or unknown.
     */
    [[nodiscard]] int64_t Length() const;
    [[nodiscard]] int     SourceWidth() const;
    [[nodiscard]] int     SourceHeight() const;
    [[nodiscard]] int     Scale() const;
    /**
     * Fits the pictures of the next Open to this retail size (zero keeps each picture's size); a stream larger than
     * it decodes on FFmpeg's threads.
     */
    void SetRetailSize(int width, int height);

private:
    struct FrameDeleter {
        void operator()(AVFrame *frame) const;
    };

    struct Frame {
        std::unique_ptr<AVFrame, FrameDeleter> decoded; /**< Converted to RGBA only when shown. */
        int64_t                                pts = 0; /**< Presentation time on the 90 kHz movie clock. */
    };
    struct Impl;
    void                                   Pump();
    std::unique_ptr<Impl>                  impl;                    /**< Open demuxer and decoders. */
    std::deque<Frame>                      queue;                   /**< Decoded pictures not yet shown, in presentation order. */
    bool                                   input_exhausted = false; /**< Whether the decoder has no more pictures. */
    std::optional<int64_t>                 first_pts;               /**< Presentation time of the first picture. */
    int64_t                                shown_pts = 0;           /**< Presentation time of the shown picture. */
    int64_t                                elapsed_last = 0;        /**< Movie time of the last Advance. */
    int                                    retail_width = 0;        /**< Retail picture width the pictures are fitted to. */
    int                                    retail_height = 0;       /**< Retail picture height the pictures are fitted to. */
    int                                    source_width = 0;        /**< Shown picture's decoded width. */
    int                                    source_height = 0;       /**< Shown picture's decoded height. */
    PictureFit                             picture_fit;             /**< Shown picture's fitted size and scale. */
    std::vector<uint8_t>                   rgba;                    /**< Shown picture as RGBA. */
    int64_t                                pictures_shown = 0;      /**< Pictures shown since Open. */
    std::shared_ptr<const audio::PcmTrack> audio_track;             /**< Embedded audio, when requested. */
};
} // namespace video
