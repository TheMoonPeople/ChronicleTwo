#include "video/player.hpp"

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/channel_layout.h>
#include <libavutil/imgutils.h>
#include <libswresample/swresample.h>
#include <libswscale/swscale.h>
}

#include <algorithm>
#include <cstdio>
#include <string>
#include <utility>

#include "audio_assets.hpp"
#include "video/yuv.hpp"

namespace video {
namespace {
constexpr AVRational kMovieClock = {1, 90000};

struct AudioReader {
    AVFormatContext *format = nullptr;
    AVCodecContext  *codec = nullptr;
    AVPacket        *packet = av_packet_alloc();
    AVFrame         *frame = av_frame_alloc();
    SwrContext      *resampler = nullptr;

    ~AudioReader() {
        swr_free(&resampler);
        av_frame_free(&frame);
        av_packet_free(&packet);
        avcodec_free_context(&codec);
        avformat_close_input(&format);
    }
};

std::shared_ptr<audio::PcmTrack> EmbeddedAudio(const std::filesystem::path &path, bool &failed) {
    failed = false;
    AudioReader       reader;
    const auto        utf8 = path.u8string();
    const std::string name(utf8.begin(), utf8.end());
    if (avformat_open_input(&reader.format, name.c_str(), av_find_input_format("mov"), nullptr) < 0 || avformat_find_stream_info(reader.format, nullptr) < 0) {
        failed = true;
        return nullptr;
    }
    const int index = av_find_best_stream(reader.format, AVMEDIA_TYPE_AUDIO, -1, -1, nullptr, 0);
    if (index < 0) {
        failed = index != AVERROR_STREAM_NOT_FOUND;
        return nullptr;
    }
    const AVStream *stream = reader.format->streams[index];
    const AVCodec  *decoder = avcodec_find_decoder(stream->codecpar->codec_id);
    if (!decoder || !reader.packet || !reader.frame) {
        failed = true;
        return nullptr;
    }
    reader.codec = avcodec_alloc_context3(decoder);
    if (!reader.codec || avcodec_parameters_to_context(reader.codec, stream->codecpar) < 0 || avcodec_open2(reader.codec, decoder, nullptr) < 0) {
        failed = true;
        return nullptr;
    }
    reader.codec->pkt_timebase = stream->time_base;
    auto track = std::make_shared<audio::PcmTrack>();
    track->loop = false;
    std::optional<int64_t> first_audio;
    const auto             append = [&]() -> bool {
        while (true) {
            const int result = avcodec_receive_frame(reader.codec, reader.frame);
            if (result == AVERROR(EAGAIN) || result == AVERROR_EOF) {
                return true;
            }
            if (result < 0) {
                return false;
            }
            const auto *frame = reader.frame;
            if (!reader.resampler) {
                track->rate = frame->sample_rate;
                track->source_channels = frame->ch_layout.nb_channels;
                if (track->rate <= 0 || frame->ch_layout.nb_channels <= 0) {
                    return false;
                }
                AVChannelLayout stereo = AV_CHANNEL_LAYOUT_STEREO;
                if (swr_alloc_set_opts2(&reader.resampler, &stereo, AV_SAMPLE_FMT_S16, track->rate, &frame->ch_layout,
                                        static_cast<AVSampleFormat>(frame->format), frame->sample_rate, 0, nullptr) < 0) {
                    return false;
                }
                if (frame->ch_layout.nb_channels == 1) {
                    const double matrix[] = {1.0, 1.0};
                    if (swr_set_matrix(reader.resampler, matrix, 1) < 0) {
                        return false;
                    }
                }
                if (swr_init(reader.resampler) < 0) {
                    return false;
                }
            }
            if (!first_audio && frame->best_effort_timestamp != AV_NOPTS_VALUE) {
                first_audio = av_rescale_q(frame->best_effort_timestamp, stream->time_base, {1, track->rate});
            }
            const int                    capacity = swr_get_out_samples(reader.resampler, frame->nb_samples);
            std::vector<int16_t>         converted(static_cast<std::size_t>(capacity) * 2);
            uint8_t                     *output[] = {reinterpret_cast<uint8_t *>(converted.data())};
            const int                    planes = av_sample_fmt_is_planar(static_cast<AVSampleFormat>(frame->format)) ? frame->ch_layout.nb_channels : 1;
            std::vector<const uint8_t *> input;
            for (int i = 0; i < planes; i++) {
                input.push_back(frame->extended_data[i]);
            }
            const int count = swr_convert(reader.resampler, output, capacity, input.data(), frame->nb_samples);
            if (count < 0) {
                return false;
            }
            track->samples.insert(track->samples.end(), converted.begin(), converted.begin() + count * 2);
            av_frame_unref(reader.frame);
        }
    };
    while (av_read_frame(reader.format, reader.packet) >= 0) {
        if (reader.packet->stream_index == index && (avcodec_send_packet(reader.codec, reader.packet) < 0 || !append())) {
            failed = true;
            return nullptr;
        }
        av_packet_unref(reader.packet);
    }
    if (avcodec_send_packet(reader.codec, nullptr) < 0 || !append()) {
        failed = true;
        return nullptr;
    }
    if (track->samples.empty()) {
        failed = true;
        return nullptr;
    }
    const int video = av_find_best_stream(reader.format, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
    int64_t   first_video = 0;
    if (video >= 0) {
        const AVStream *v = reader.format->streams[video];
        if (v->start_time != AV_NOPTS_VALUE) {
            first_video = av_rescale_q(v->start_time, v->time_base, {1, track->rate});
        }
    }
    const int64_t offset = first_audio.value_or(first_video) - first_video;
    if (offset > 0) {
        track->samples.insert(track->samples.begin(), static_cast<std::size_t>(offset) * 2, 0);
    } else if (offset < 0) {
        track->samples.erase(track->samples.begin(), track->samples.begin() + std::min(-offset, track->Frames()) * 2);
    }
    return track;
}
} // namespace

struct MoviePlayer::Impl {
    AVFormatContext *format = nullptr;
    AVCodecContext  *codec = nullptr;
    AVPacket        *packet = av_packet_alloc();
    AVFrame         *frame = av_frame_alloc();
    SwsContext      *scaler = nullptr;
    int              video = -1;
    int64_t          duration = 3600;
    int64_t          next_pts = 0;
    bool             draining = false;
    bool             failed = false;

    ~Impl() {
        sws_freeContext(scaler);
        av_frame_free(&frame);
        av_packet_free(&packet);
        avcodec_free_context(&codec);
        avformat_close_input(&format);
    }

    bool Open(const std::filesystem::path &path) {
        const auto        utf8 = path.u8string();
        const std::string name(utf8.begin(), utf8.end());
        if (!packet || !frame || avformat_open_input(&format, name.c_str(), av_find_input_format("mov"), nullptr) < 0 || avformat_find_stream_info(format, nullptr) < 0) {
            return false;
        }
        video = av_find_best_stream(format, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
        if (video < 0) {
            return false;
        }
        const AVStream *stream = format->streams[video];
        const AVCodec  *decoder = avcodec_find_decoder(stream->codecpar->codec_id);
        if (!decoder) {
            return false;
        }
        codec = avcodec_alloc_context3(decoder);
        if (!codec || avcodec_parameters_to_context(codec, stream->codecpar) < 0 || avcodec_open2(codec, decoder, nullptr) < 0) {
            return false;
        }
        codec->pkt_timebase = stream->time_base;
        const auto rate = av_guess_frame_rate(format, format->streams[video], nullptr);
        if (rate.num > 0 && rate.den > 0) {
            duration = std::max<int64_t>(1, av_rescale_q(1, av_inv_q(rate), kMovieClock));
        }
        return true;
    }

    std::optional<Frame> Next() {
        while (!failed) {
            const int result = avcodec_receive_frame(codec, frame);
            if (result == 0) {
                Frame out;
                out.width = frame->width;
                out.height = frame->height;
                if (out.width <= 0 || out.height <= 0 || out.width > 16384 || out.height > 16384) {
                    failed = true;
                    return std::nullopt;
                }
                out.pts = frame->best_effort_timestamp == AV_NOPTS_VALUE ? next_pts : av_rescale_q(frame->best_effort_timestamp, format->streams[video]->time_base, kMovieClock);
                next_pts = out.pts + duration;
                out.rgba.resize(static_cast<std::size_t>(out.width) * out.height * 4);
                if (frame->format == AV_PIX_FMT_YUV420P && frame->linesize[1] == frame->linesize[2]) {
                    Yuv420ToRgba(frame->data[0], frame->linesize[0], frame->data[1], frame->data[2], frame->linesize[1], out.width, out.height, out.rgba.data());
                } else {
                    scaler = sws_getCachedContext(scaler, out.width, out.height, static_cast<AVPixelFormat>(frame->format), out.width, out.height, AV_PIX_FMT_RGBA, SWS_BILINEAR, nullptr, nullptr, nullptr);
                    if (!scaler) {
                        failed = true;
                        return std::nullopt;
                    }
                    uint8_t  *planes[] = {out.rgba.data()};
                    const int strides[] = {out.width * 4};
                    if (sws_scale(scaler, frame->data, frame->linesize, 0, out.height, planes, strides) <= 0) {
                        failed = true;
                        return std::nullopt;
                    }
                }
                av_frame_unref(frame);
                return out;
            }
            if (result == AVERROR_EOF) {
                return std::nullopt;
            }
            if (result != AVERROR(EAGAIN) || draining) {
                failed = true;
                return std::nullopt;
            }
            bool submitted = false;
            while (av_read_frame(format, packet) >= 0) {
                if (packet->stream_index == video) {
                    const int sent = avcodec_send_packet(codec, packet);
                    av_packet_unref(packet);
                    if (sent < 0) {
                        failed = true;
                        return std::nullopt;
                    }
                    submitted = true;
                    break;
                }
                av_packet_unref(packet);
            }
            if (!submitted) {
                draining = true;
                if (avcodec_send_packet(codec, nullptr) < 0) {
                    failed = true;
                    return std::nullopt;
                }
            }
        }
        return std::nullopt;
    }
};

MoviePlayer::MoviePlayer() = default;
MoviePlayer::~MoviePlayer() = default;

bool MoviePlayer::Open(const std::filesystem::path &path, bool with_audio) {
    Close();
    if (path.extension() != ".mp4") {
        return false;
    }
    auto candidates = path.is_absolute() ? std::vector<std::filesystem::path>{path} : AudioAssetCandidates(path.generic_string());
    for (const auto &candidate : candidates) {
        impl_ = std::make_unique<Impl>();
        if (!impl_->Open(candidate)) {
            Close();
            continue;
        }
        if (with_audio) {
            bool failed = false;
            audio_ = EmbeddedAudio(candidate, failed);
            if (failed) {
                Close();
                continue;
            }
        }
        Pump();
        if (queue_.empty() || !Advance(0)) {
            Close();
            continue;
        }
        return true;
    }
    return false;
}

void MoviePlayer::Close() {
    impl_.reset();
    queue_.clear();
    input_exhausted_ = false;
    first_pts_.reset();
    shown_pts_ = 0;
    elapsed_last_ = 0;
    width_ = 0;
    height_ = 0;
    rgba_.clear();
    pictures_shown_ = 0;
    audio_.reset();
}

bool MoviePlayer::IsOpen() const { return impl_ != nullptr; }

bool MoviePlayer::Advance(int64_t elapsed) {
    if (!IsOpen()) {
        return false;
    }
    elapsed_last_ = elapsed;
    std::optional<Frame> candidate;
    while (true) {
        if (queue_.empty()) {
            if (input_exhausted_) {
                break;
            }
            Pump();
            continue;
        }
        if (queue_.front().pts - *first_pts_ > elapsed) {
            break;
        }
        candidate = std::move(queue_.front());
        queue_.pop_front();
    }
    if (!candidate) {
        return false;
    }
    width_ = candidate->width;
    height_ = candidate->height;
    rgba_ = std::move(candidate->rgba);
    shown_pts_ = candidate->pts;
    pictures_shown_++;
    return true;
}

bool MoviePlayer::HasPicture() const { return !rgba_.empty(); }

int MoviePlayer::Width() const { return width_; }

int MoviePlayer::Height() const { return height_; }

const std::vector<uint8_t> &MoviePlayer::Rgba() const { return rgba_; }

bool MoviePlayer::Ended() const { return input_exhausted_ && queue_.empty() && HasPicture() && elapsed_last_ >= shown_pts_ - *first_pts_ + impl_->duration; }

std::shared_ptr<const audio::PcmTrack> MoviePlayer::Audio() const { return audio_; }

int64_t MoviePlayer::PicturesShown() const { return pictures_shown_; }

void MoviePlayer::Pump() {
    if (input_exhausted_) {
        return;
    }
    auto frame = impl_->Next();
    if (!frame) {
        input_exhausted_ = true;
        return;
    }
    if (!first_pts_) {
        first_pts_ = frame->pts;
    }
    queue_.push_back(std::move(*frame));
}
} // namespace video
