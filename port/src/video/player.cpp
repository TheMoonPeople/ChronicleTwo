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
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <fstream>
#include <limits>
#include <memory>
#include <string>
#include <string_view>
#include <thread>
#include <utility>

#include "audio_assets.hpp"
#include "log/log.hpp"
#include "video/yuv.hpp"

namespace video {
namespace {
constexpr AVRational kMovieClock = {.num = 1, .den = 90000};
/** Bytes FFmpeg reads through a custom input at a time. */
constexpr int kInputBufferBytes = 64 * 1024;
/** Most decoder threads a movie gets; a 4x picture gains little past this. */
constexpr unsigned kMaxDecoderThreads = 8;
/** Largest picture side, in pixels, the player converts. */
constexpr int kMaxPictureSide = 16384;
/** Most host texels per retail texel a replacement movie is shown at. */
constexpr int kMaxPictureScale = 4;

bool ValidSize(int width, int height) {
    return width > 0 && height > 0 && width <= kMaxPictureSide && height <= kMaxPictureSide;
}

/**
 * Feeds FFmpeg one data entry that is not a host file: a stored archive entry read from its own file handle, or a
 * compressed entry held in memory.
 */
class EntryInput {
public:
    EntryInput(const EntryInput &) = delete;
    EntryInput &operator=(const EntryInput &) = delete;

    ~EntryInput() {
        if (io_) {
            av_freep(&io_->buffer);
            avio_context_free(&io_);
        }
    }

    /**
     * Prepares a custom input for an entry, or returns null when it cannot be read.
     */
    static std::unique_ptr<EntryInput> Open(const vfs::Ref &file) {
        std::unique_ptr<EntryInput> input(new EntryInput);
        if (const auto range = vfs::Stored(file)) {
            input->file_.open(range->file, std::ios::binary);
            if (!input->file_) {
                return nullptr;
            }
            input->offset_ = range->offset;
            input->length_ = range->length;
        } else if (vfs::Read(file, input->bytes_, std::numeric_limits<std::uint64_t>::max())) {
            input->length_ = input->bytes_.size();
        } else {
            return nullptr;
        }
        auto *buffer = static_cast<unsigned char *>(av_malloc(kInputBufferBytes));
        if (!buffer) {
            return nullptr;
        }
        input->io_ = avio_alloc_context(buffer, kInputBufferBytes, 0, input.get(), &EntryInput::ReadPacket, nullptr, &EntryInput::Seek);
        if (!input->io_) {
            av_free(buffer);
            return nullptr;
        }
        return input;
    }

    AVIOContext *Context() const { return io_; }

private:
    EntryInput() = default;

    static int ReadPacket(void *opaque, uint8_t *buffer, int size) {
        auto      *input = static_cast<EntryInput *>(opaque);
        const auto count = static_cast<int>(std::min<std::uint64_t>(static_cast<std::uint64_t>(size), input->length_ - input->position_));
        if (count <= 0) {
            return AVERROR_EOF;
        }
        if (input->bytes_.empty()) {
            input->file_.clear();
            input->file_.seekg(static_cast<std::streamoff>(input->offset_ + input->position_));
            input->file_.read(reinterpret_cast<char *>(buffer), count);
            if (input->file_.gcount() != count) {
                return AVERROR(EIO);
            }
        } else {
            std::copy_n(input->bytes_.data() + input->position_, count, buffer);
        }
        input->position_ += static_cast<std::uint64_t>(count);
        return count;
    }

    static int64_t Seek(void *opaque, int64_t offset, int whence) {
        auto *input = static_cast<EntryInput *>(opaque);
        if (whence & AVSEEK_SIZE) {
            return static_cast<int64_t>(input->length_);
        }
        int64_t base = 0;
        switch (whence & ~AVSEEK_FORCE) {
            case SEEK_SET:
                break;
            case SEEK_CUR:
                base = static_cast<int64_t>(input->position_);
                break;
            case SEEK_END:
                base = static_cast<int64_t>(input->length_);
                break;
            default:
                return AVERROR(EINVAL);
        }
        const int64_t target = base + offset;
        if (target < 0 || std::cmp_greater(target, input->length_)) {
            return AVERROR(EINVAL);
        }
        input->position_ = static_cast<std::uint64_t>(target);
        return target;
    }

    std::ifstream             file_;         /**< Archive file holding a stored entry. */
    std::vector<std::uint8_t> bytes_;        /**< Contents of a compressed entry. */
    std::uint64_t             offset_ = 0;   /**< Entry data offset within the archive file. */
    std::uint64_t             length_ = 0;   /**< Entry size in bytes. */
    std::uint64_t             position_ = 0; /**< Read position within the entry. */
    AVIOContext              *io_ = nullptr; /**< FFmpeg's view of the entry. */
};

/**
 * Opens an MP4 entry: host files by path, archive entries through a custom input that must outlive the format.
 */
bool OpenMovie(const vfs::Ref &file, AVFormatContext *&format, std::unique_ptr<EntryInput> &input) {
    if (const auto host = vfs::HostPath(file)) {
        const auto        utf8 = host->u8string();
        const std::string name(utf8.begin(), utf8.end());
        return avformat_open_input(&format, name.c_str(), av_find_input_format("mov"), nullptr) >= 0;
    }
    input = EntryInput::Open(file);
    if (!input) {
        return false;
    }
    format = avformat_alloc_context();
    if (!format) {
        return false;
    }
    format->pb = input->Context();
    format->flags |= AVFMT_FLAG_CUSTOM_IO;
    const auto name = file.Display();
    // A failed open frees the context; the custom input stays owned by the caller.
    return avformat_open_input(&format, name.c_str(), av_find_input_format("mov"), nullptr) >= 0;
}

struct AudioReader {
    std::unique_ptr<EntryInput> input;
    AVFormatContext            *format = nullptr;
    AVCodecContext             *codec = nullptr;
    AVPacket                   *packet = av_packet_alloc();
    AVFrame                    *frame = av_frame_alloc();
    SwrContext                 *resampler = nullptr;

    ~AudioReader() {
        swr_free(&resampler);
        av_frame_free(&frame);
        av_packet_free(&packet);
        avcodec_free_context(&codec);
        avformat_close_input(&format);
    }
};

std::shared_ptr<audio::PcmTrack> EmbeddedAudio(const vfs::Ref &file, bool &failed) {
    failed = false;
    AudioReader reader;
    if (!OpenMovie(file, reader.format, reader.input) || avformat_find_stream_info(reader.format, nullptr) < 0) {
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
    const auto             append = [&] -> bool {
        while (true) {
            const int result = avcodec_receive_frame(reader.codec, reader.frame);
            if (result == AVERROR(EAGAIN) || result == AVERROR_EOF) {
                return true;
            }
            if (result < 0) {
                return false;
            }
            const auto *frame = reader.frame;
            if (frame->nb_samples < 0 || frame->sample_rate <= 0 || frame->ch_layout.nb_channels <= 0 ||
                frame->extended_data == nullptr) {
                return false;
            }
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
                first_audio = av_rescale_q(frame->best_effort_timestamp, stream->time_base, {.num = 1, .den = track->rate});
            }
            const int capacity = swr_get_out_samples(reader.resampler, frame->nb_samples);
            if (capacity < 0 || static_cast<std::size_t>(capacity) > std::vector<int16_t>{}.max_size() / 2) {
                return false;
            }
            std::vector<int16_t>         converted(static_cast<std::size_t>(capacity) * 2);
            uint8_t                     *output[] = {reinterpret_cast<uint8_t *>(converted.data())};
            const int                    planes = av_sample_fmt_is_planar(static_cast<AVSampleFormat>(frame->format)) ? frame->ch_layout.nb_channels : 1;
            std::vector<const uint8_t *> input;
            input.reserve(planes);
            for (int i = 0; i < planes; i++) {
                input.push_back(frame->extended_data[i]);
            }
            const int count = swr_convert(reader.resampler, output, capacity, input.data(), frame->nb_samples);
            if (count < 0 || count > capacity) {
                return false;
            }
            const auto stereo_samples = static_cast<std::size_t>(count) * 2;
            if (stereo_samples > track->samples.max_size() - track->samples.size()) {
                return false;
            }
            track->samples.insert(track->samples.end(), converted.begin(), converted.begin() + static_cast<std::ptrdiff_t>(stereo_samples));
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
            first_video = av_rescale_q(v->start_time, v->time_base, {.num = 1, .den = track->rate});
        }
    }
    const auto audio_start = first_audio.value_or(first_video);
    if ((first_video > 0 && audio_start < std::numeric_limits<int64_t>::min() + first_video) ||
        (first_video < 0 && audio_start > std::numeric_limits<int64_t>::max() + first_video)) {
        failed = true;
        return nullptr;
    }
    const int64_t offset = audio_start - first_video;
    if (offset > 0) {
        const auto padding_frames = static_cast<std::uint64_t>(offset);
        if (padding_frames > (track->samples.max_size() - track->samples.size()) / 2) {
            failed = true;
            return nullptr;
        }
        track->samples.insert(track->samples.begin(), static_cast<std::size_t>(padding_frames) * 2, 0);
    } else if (offset < 0) {
        const auto magnitude = static_cast<std::uint64_t>(-(offset + 1)) + 1;
        const auto frames = std::min(magnitude, static_cast<std::uint64_t>(track->Frames()));
        track->samples.erase(track->samples.begin(), track->samples.begin() + static_cast<std::ptrdiff_t>(frames * 2));
    }
    return track;
}
} // namespace

struct MoviePlayer::Impl {
    std::unique_ptr<EntryInput> input;
    AVFormatContext            *format = nullptr;
    AVCodecContext             *codec = nullptr;
    AVPacket                   *packet = av_packet_alloc();
    AVFrame                    *frame = av_frame_alloc();
    SwsContext                 *scaler = nullptr;
    SwsContext                 *resampler = nullptr;
    std::vector<uint8_t>        source_rgba;
    int                         video = -1;
    int64_t                     duration = 3600;
    int64_t                     next_pts = 0;
    bool                        draining = false;
    bool                        failed = false;
    int64_t                     decoded = 0; /**< Pictures decoded since Open. */
    DecodeRejections            rejections;  /**< Undecodable packets and pictures passed over. */
    int64_t                     length = 0;  /**< The container's duration on the movie clock; 0 when it gives none. */

    ~Impl() {
        sws_freeContext(resampler);
        sws_freeContext(scaler);
        av_frame_free(&frame);
        av_packet_free(&packet);
        avcodec_free_context(&codec);
        avformat_close_input(&format);
    }

    bool Open(const vfs::Ref &file, int retail_width, int retail_height) {
        if (!packet || !frame || !OpenMovie(file, format, input) || avformat_find_stream_info(format, nullptr) < 0) {
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
        if (!codec || avcodec_parameters_to_context(codec, stream->codecpar) < 0) {
            return false;
        }
        // A retail-size picture decodes in about a millisecond; a larger replacement decodes on FFmpeg's threads.
        const int64_t retail_pixels = static_cast<int64_t>(retail_width) * retail_height;
        if (retail_pixels > 0 && static_cast<int64_t>(codec->width) * codec->height > retail_pixels) {
            codec->thread_count = static_cast<int>(std::clamp(std::thread::hardware_concurrency(), 1u, kMaxDecoderThreads));
        }
        if (avcodec_open2(codec, decoder, nullptr) < 0) {
            return false;
        }
        codec->pkt_timebase = stream->time_base;
        const auto rate = av_guess_frame_rate(format, format->streams[video], nullptr);
        if (rate.num > 0 && rate.den > 0) {
            duration = std::max<int64_t>(1, av_rescale_q(1, av_inv_q(rate), kMovieClock));
        }
        if (format->duration > 0) {
            length = av_rescale_q(format->duration, {.num = 1, .den = AV_TIME_BASE}, kMovieClock);
        }
        return true;
    }

    /**
     * Converts a decoded picture to RGBA at its fitted size. A fitted picture is converted at its own size first, so
     * it has the same colours as an unfitted one, then resampled: area averaging when either side shrinks, bicubic
     * when both grow.
     */
    bool Convert(const AVFrame &picture, const PictureFit &fit, std::vector<uint8_t> &rgba) {
        const int  width = picture.width;
        const int  height = picture.height;
        const bool fitted = fit.width != width || fit.height != height;
        auto      &converted = fitted ? source_rgba : rgba;
        converted.resize(static_cast<std::size_t>(width) * height * 4);
        if (picture.format == AV_PIX_FMT_YUV420P && picture.linesize[1] == picture.linesize[2]) {
            Yuv420ToRgba(picture.data[0], picture.linesize[0], picture.data[1], picture.data[2], picture.linesize[1], width, height, converted.data());
        } else {
            scaler = sws_getCachedContext(scaler, width, height, static_cast<AVPixelFormat>(picture.format), width, height, AV_PIX_FMT_RGBA, SWS_BILINEAR, nullptr, nullptr, nullptr);
            uint8_t  *planes[] = {converted.data()};
            const int strides[] = {width * 4};
            if (!scaler || sws_scale(scaler, picture.data, picture.linesize, 0, height, planes, strides) <= 0) {
                return false;
            }
        }
        if (!fitted) {
            return true;
        }
        const int flags = (fit.width < width || fit.height < height ? SWS_AREA : SWS_BICUBIC) | SWS_FULL_CHR_H_INP | SWS_FULL_CHR_H_INT | SWS_ACCURATE_RND;
        resampler = sws_getCachedContext(resampler, width, height, AV_PIX_FMT_RGBA, fit.width, fit.height, AV_PIX_FMT_RGBA, flags, nullptr, nullptr, nullptr);
        rgba.resize(static_cast<std::size_t>(fit.width) * fit.height * 4);
        const uint8_t *from[] = {source_rgba.data()};
        const int      from_strides[] = {width * 4};
        uint8_t       *to[] = {rgba.data()};
        const int      to_strides[] = {fit.width * 4};
        return resampler && sws_scale(resampler, from, from_strides, 0, height, to, to_strides) > 0;
    }

    std::optional<Frame> Next() {
        while (!failed) {
            const int result = avcodec_receive_frame(codec, frame);
            if (result == 0) {
                if (!ValidSize(frame->width, frame->height)) {
                    return Fail(AVERROR_INVALIDDATA, "picture size");
                }
                Frame out;
                out.pts = frame->best_effort_timestamp == AV_NOPTS_VALUE ? next_pts : av_rescale_q(frame->best_effort_timestamp, format->streams[video]->time_base, kMovieClock);
                next_pts = out.pts + duration;
                out.decoded.reset(av_frame_alloc());
                if (!out.decoded) {
                    return Fail(AVERROR(ENOMEM), "picture allocation");
                }
                av_frame_move_ref(out.decoded.get(), frame);
                rejections.Decoded();
                decoded++;
                return out;
            }
            if (result == AVERROR_EOF) {
                return std::nullopt;
            }
            if (result == AVERROR_INVALIDDATA) {
                if (!Skip()) {
                    return Fail(result, "decoding");
                }
                continue;
            }
            if (result != AVERROR(EAGAIN) || draining) {
                return Fail(result, "decoding");
            }
            bool submitted = false;
            int  read = 0;
            while ((read = av_read_frame(format, packet)) >= 0) {
                if (packet->stream_index == video) {
                    const int sent = avcodec_send_packet(codec, packet);
                    av_packet_unref(packet);
                    if (sent == AVERROR_INVALIDDATA) {
                        if (!Skip()) {
                            return Fail(sent, "decoding");
                        }
                        continue;
                    }
                    if (sent < 0) {
                        return Fail(sent, "decoding");
                    }
                    submitted = true;
                    break;
                }
                av_packet_unref(packet);
            }
            if (!submitted) {
                if (read != AVERROR_EOF) {
                    return Fail(read, "reading the file");
                }
                draining = true;
                if (const int sent = avcodec_send_packet(codec, nullptr); sent < 0) {
                    return Fail(sent, "decoding");
                }
            }
        }
        return std::nullopt;
    }

    /**
     * Skips an undecodable packet or picture within the consecutive rejection limit.
     */
    bool Skip() {
        if (rejections.Total() == 0) {
            CT_LOG_WARN(Movie, "movie: skipping an undecodable picture");
        }
        return rejections.Skip();
    }

    /**
     * Stops picture decoding and reports the failing stage and decoder error.
     */
    std::nullopt_t Fail(int code, std::string_view stage) {
        failed = true;
        std::array<char, AV_ERROR_MAX_STRING_SIZE> text{};
        av_strerror(code, text.data(), text.size());
        CT_LOG_WARN(Movie, "movie: {} stopped the pictures after {} ({}); the movie ends at the last one shown", stage,
                    decoded, text.data());
        return std::nullopt;
    }
};

bool DecodeRejections::Skip() {
    total++;
    return ++run <= kMaxInARow;
}

void DecodeRejections::Decoded() { run = 0; }

int64_t DecodeRejections::Total() const { return total; }

PictureFit FitPicture(int retail_width, int retail_height, int width, int height) {
    if (retail_width <= 0 || retail_height <= 0) {
        return {.width = width, .height = height, .scale = 1};
    }
    int scale = kMaxPictureScale;
    while (scale > 1 && (width < retail_width * scale || height < retail_height * scale)) {
        scale /= 2;
    }
    return {.width = retail_width * scale, .height = retail_height * scale, .scale = scale};
}

void MoviePlayer::FrameDeleter::operator()(AVFrame *frame) const { av_frame_free(&frame); }

MoviePlayer::MoviePlayer() = default;
MoviePlayer::~MoviePlayer() = default;

bool MoviePlayer::Open(const std::filesystem::path &path, bool with_audio) {
    Close();
    if (path.extension() != ".mp4") {
        return false;
    }
    auto candidates = path.is_absolute() ? std::vector<vfs::Ref>{vfs::HostFile(path)} : AudioAssetCandidates(path.generic_string());
    for (const auto &candidate : candidates) {
        impl = std::make_unique<Impl>();
        if (!impl->Open(candidate, retail_width, retail_height)) {
            Close();
            continue;
        }
        if (with_audio) {
            bool failed = false;
            audio_track = EmbeddedAudio(candidate, failed);
            if (failed) {
                Close();
                continue;
            }
        }
        Pump();
        if (queue.empty() || !Advance(0)) {
            Close();
            continue;
        }
        return true;
    }
    return false;
}

void MoviePlayer::Close() {
    impl.reset();
    queue.clear();
    input_exhausted = false;
    first_pts.reset();
    shown_pts = 0;
    elapsed_last = 0;
    source_width = 0;
    source_height = 0;
    picture_fit = {};
    rgba.clear();
    pictures_shown = 0;
    audio_track.reset();
}

bool MoviePlayer::IsOpen() const { return impl != nullptr; }

bool MoviePlayer::Advance(int64_t elapsed) {
    if (!IsOpen()) {
        return false;
    }
    elapsed_last = elapsed;
    std::optional<Frame> candidate;
    while (true) {
        if (queue.empty()) {
            if (input_exhausted) {
                break;
            }
            Pump();
            continue;
        }
        if (queue.front().pts - first_pts.value_or(0) > elapsed) {
            break;
        }
        candidate = std::move(queue.front());
        queue.pop_front();
    }
    if (!candidate) {
        return false;
    }
    const AVFrame &picture = *candidate->decoded;
    const auto     fit = FitPicture(retail_width, retail_height, picture.width, picture.height);
    if (!ValidSize(fit.width, fit.height) || !impl->Convert(picture, fit, rgba)) {
        // As a picture that fails to decode: the movie ends at the last one shown.
        impl->Fail(AVERROR(EINVAL), "picture conversion");
        input_exhausted = true;
        queue.clear();
        return false;
    }
    source_width = picture.width;
    source_height = picture.height;
    picture_fit = fit;
    shown_pts = candidate->pts;
    pictures_shown++;
    return true;
}

bool MoviePlayer::HasPicture() const { return !rgba.empty(); }

int MoviePlayer::Width() const { return picture_fit.width; }

int MoviePlayer::Height() const { return picture_fit.height; }

const std::vector<uint8_t> &MoviePlayer::Rgba() const { return rgba; }

bool MoviePlayer::Ended() const { return input_exhausted && queue.empty() && HasPicture() && elapsed_last >= shown_pts - first_pts.value_or(0) + impl->duration; }

std::shared_ptr<const audio::PcmTrack> MoviePlayer::Audio() const { return audio_track; }

int64_t MoviePlayer::PicturesShown() const { return pictures_shown; }

int64_t MoviePlayer::Length() const { return impl ? impl->length : 0; }

int MoviePlayer::SourceWidth() const { return source_width; }

int MoviePlayer::SourceHeight() const { return source_height; }

int MoviePlayer::Scale() const { return picture_fit.scale; }

void MoviePlayer::SetRetailSize(int width, int height) {
    retail_width = width;
    retail_height = height;
}

void MoviePlayer::Pump() {
    if (input_exhausted) {
        return;
    }
    auto frame = impl->Next();
    if (!frame) {
        input_exhausted = true;
        return;
    }
    if (!first_pts) {
        first_pts = frame->pts;
    }
    queue.push_back(std::move(*frame));
}
} // namespace video
