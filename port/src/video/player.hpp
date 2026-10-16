#pragma once
#include <cstdint>
#include <deque>
#include <filesystem>
#include <memory>
#include <optional>
#include <vector>

#include "audio/pcm.hpp"

namespace video {
/**
 * Plays a standard MP4 with embedded audio against the game's movie clock.
 */
class MoviePlayer {
public:
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

private:
    struct Frame {
        int                  width = 0;
        int                  height = 0;
        int64_t              pts = 0;
        std::vector<uint8_t> rgba;
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
    std::vector<uint8_t>                   rgba_;
    int64_t                                pictures_shown_ = 0;
    std::shared_ptr<const audio::PcmTrack> audio_;
};
} // namespace video
