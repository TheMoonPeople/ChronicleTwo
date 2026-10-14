#include <gtest/gtest.h>

extern "C" {
#include <libavcodec/avcodec.h>
}

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <optional>
#include <span>
#include <string_view>
#include <utility>
#include <vector>

#include "platform/paths.hpp"
#include "video/pss.hpp"

namespace fs = std::filesystem;
using video::Mpeg2SequenceInfo;
using video::PssChunk;
using video::PssDemuxer;
using video::PssError;
using video::PssStream;

namespace {

using Bytes = std::vector<uint8_t>;

constexpr int64_t kVideoPts = (int64_t{1} << 32) + 90000;
constexpr int64_t kVideoDts = (int64_t{1} << 32) + 86000;
constexpr int64_t kPcmPts = (int64_t{1} << 32) + 90450;

const Bytes kVideoEs = {0x00, 0x00, 0x01, 0x00, 0x10, 0x20, 0x30, 0x40};
const Bytes kPcm = {0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88};

void Append(Bytes &out, const Bytes &more) { out.insert(out.end(), more.begin(), more.end()); }

// The 33-bit value in the five-byte PTS/DTS layout: the prefix nibble, then the three marker bits.
Bytes Timestamp(uint8_t prefix, int64_t value) {
    return {
        static_cast<uint8_t>((prefix << 4) | ((value >> 29) & 0x0E) | 1),
        static_cast<uint8_t>(value >> 22),
        static_cast<uint8_t>(((value >> 14) & 0xFE) | 1),
        static_cast<uint8_t>(value >> 7),
        static_cast<uint8_t>(((value << 1) & 0xFE) | 1),
    };
}

Bytes PackHeader() { return {0x00, 0x00, 0x01, 0xBA, 0x44, 0x00, 0x04, 0x00, 0x04, 0x01, 0x00, 0xD8, 0x43, 0xF8}; }

Bytes SystemHeader() { return {0x00, 0x00, 0x01, 0xBB, 0x00, 0x06, 0x80, 0x00, 0x01, 0xE0, 0xE0, 0x00}; }

Bytes Padding() { return {0x00, 0x00, 0x01, 0xBE, 0x00, 0x04, 0xFF, 0xFF, 0xFF, 0xFF}; }

Bytes EndCode() { return {0x00, 0x00, 0x01, 0xB9}; }

Bytes Pes(uint8_t stream_id, std::optional<int64_t> pts, std::optional<int64_t> dts, const Bytes &payload) {
    Bytes header_data;
    if (pts) {
        Append(header_data, Timestamp(dts ? 3 : 2, *pts));
    }
    if (dts) {
        Append(header_data, Timestamp(1, *dts));
    }
    const uint8_t flags = dts ? 0xC0 : pts ? 0x80 : 0x00;
    const size_t length = 3 + header_data.size() + payload.size();

    Bytes packet = {0x00, 0x00, 0x01, stream_id, static_cast<uint8_t>(length >> 8), static_cast<uint8_t>(length),
                    0x80, flags, static_cast<uint8_t>(header_data.size())};
    Append(packet, header_data);
    Append(packet, payload);
    return packet;
}

Bytes VideoPes() { return Pes(0xE0, kVideoPts, kVideoDts, kVideoEs); }

Bytes PcmPayload() {
    Bytes payload = {0xA0, 0x00, 0x00, 0x00};
    Append(payload, kPcm);
    return payload;
}

Bytes PcmPes() { return Pes(0xBD, kPcmPts, std::nullopt, PcmPayload()); }

Bytes TwoPacketStream() {
    Bytes stream = PackHeader();
    Append(stream, SystemHeader());
    Append(stream, VideoPes());
    Append(stream, PcmPes());
    Append(stream, Padding());
    Append(stream, EndCode());
    return stream;
}

struct DemuxRun {
    std::vector<PssChunk> chunks;
    PssError error = PssError::None;
    bool done = false;
    uint64_t consumed = 0;
};

DemuxRun Drive(std::span<const uint8_t> stream, size_t step) {
    PssDemuxer demux;
    DemuxRun run;
    const auto drain = [&] {
        while (std::optional<PssChunk> chunk = demux.Next()) {
            run.chunks.push_back(std::move(*chunk));
        }
    };
    for (size_t at = 0; at < stream.size(); at += step) {
        demux.Push(stream.subspan(at, std::min(step, stream.size() - at)));
        drain();
    }
    demux.Finish();
    drain();
    run.error = demux.Error();
    run.done = demux.Done();
    run.consumed = demux.Consumed();
    return run;
}

void ExpectSame(const PssChunk &got, const PssChunk &want) {
    EXPECT_EQ(got.stream, want.stream);
    EXPECT_EQ(got.substream, want.substream);
    EXPECT_EQ(got.pts, want.pts);
    EXPECT_EQ(got.dts, want.dts);
    EXPECT_EQ(got.payload, want.payload);
}

PssChunk VideoChunk() {
    PssChunk chunk;
    chunk.stream = PssStream::Video;
    chunk.pts = kVideoPts;
    chunk.dts = kVideoDts;
    chunk.payload = kVideoEs;
    return chunk;
}

PssChunk PcmChunk() {
    PssChunk chunk;
    chunk.stream = PssStream::Pcm;
    chunk.substream = 0xA0;
    chunk.pts = kPcmPts;
    chunk.payload = kPcm;
    return chunk;
}

// Writes fields most significant bit first, as the MPEG headers lay them out.
class BitWriter {
public:
    void Put(uint64_t value, int bits) {
        for (int i = bits - 1; i >= 0; i--, bit_++) {
            if (bit_ % 8 == 0) {
                out_.push_back(0);
            }
            if ((value >> i) & 1) {
                out_.back() |= static_cast<uint8_t>(0x80 >> (bit_ % 8));
            }
        }
    }

    void Start(uint8_t code) {
        Append(out_, {0x00, 0x00, 0x01, code});
        bit_ = 0;
    }

    const Bytes &Data() const { return out_; }

private:
    Bytes out_;
    int bit_ = 0;
};

// ctest runs from the build directory, so PathsDataRoot() does not reach the checkout's data/. Search upward
// from the test executable instead, as dataread_test.cpp does.
std::optional<fs::path> MovieFile(const char *name) {
    fs::path dir = PathsExecutable().parent_path();
    for (int up = 0; up < 6 && !dir.empty(); up++, dir = dir.parent_path()) {
        std::error_code error;
        fs::path path = dir / "data" / "movie" / name;
        if (fs::is_regular_file(path, error)) {
            return path;
        }
    }
    return std::nullopt;
}

} // namespace

TEST(VideoPss, DemuxesVideoAndPcmChunks) {
    const Bytes stream = TwoPacketStream();
    const DemuxRun run = Drive(stream, stream.size());

    ASSERT_EQ(run.chunks.size(), 2u);
    ExpectSame(run.chunks[0], VideoChunk());
    ExpectSame(run.chunks[1], PcmChunk());
    EXPECT_EQ(run.error, PssError::None);
    EXPECT_TRUE(run.done);
    EXPECT_EQ(run.consumed, stream.size());
}

TEST(VideoPss, ByteAtATimeMatchesWholeStream) {
    const Bytes stream = TwoPacketStream();
    const DemuxRun whole = Drive(stream, stream.size());
    const DemuxRun bytewise = Drive(stream, 1);

    ASSERT_EQ(bytewise.chunks.size(), whole.chunks.size());
    for (size_t i = 0; i < whole.chunks.size(); i++) {
        ExpectSame(bytewise.chunks[i], whole.chunks[i]);
    }
    EXPECT_EQ(bytewise.error, PssError::None);
    EXPECT_TRUE(bytewise.done);
    EXPECT_EQ(bytewise.consumed, stream.size());
}

TEST(VideoPss, LeadingGarbageIsSkipped) {
    const Bytes garbage = {0x12, 0x00, 0x00, 0x01, 0xE0, 0x00, 0x03, 0xAA, 0x00};
    Bytes stream = garbage;
    Append(stream, TwoPacketStream());

    const DemuxRun run = Drive(stream, stream.size());
    ASSERT_EQ(run.chunks.size(), 2u);
    ExpectSame(run.chunks[0], VideoChunk());
    ExpectSame(run.chunks[1], PcmChunk());
    EXPECT_EQ(run.error, PssError::None);
    EXPECT_TRUE(run.done);
}

TEST(VideoPss, OtherStreamsAreSkipped) {
    Bytes stream = PackHeader();
    Append(stream, SystemHeader());
    Append(stream, Pes(0xE1, kVideoPts, kVideoDts, {0x55, 0x55, 0x55}));
    Append(stream, Pes(0xBD, kPcmPts, std::nullopt, {0xA1, 0x00, 0x00, 0x00, 0x99, 0x99}));
    Append(stream, VideoPes());
    Append(stream, PcmPes());
    Append(stream, EndCode());

    const DemuxRun run = Drive(stream, stream.size());
    ASSERT_EQ(run.chunks.size(), 2u);
    ExpectSame(run.chunks[0], VideoChunk());
    ExpectSame(run.chunks[1], PcmChunk());
    EXPECT_EQ(run.error, PssError::None);
    EXPECT_TRUE(run.done);
}

TEST(VideoPss, TruncatedPcmPacketIsDroppedAfterFinish) {
    Bytes stream = PackHeader();
    Append(stream, SystemHeader());
    Append(stream, VideoPes());
    const size_t video_end = stream.size();
    Append(stream, PcmPes());
    stream.resize(video_end + 12);

    const DemuxRun run = Drive(stream, stream.size());
    ASSERT_EQ(run.chunks.size(), 1u);
    ExpectSame(run.chunks[0], VideoChunk());
    EXPECT_EQ(run.error, PssError::None);
    EXPECT_TRUE(run.done);
    EXPECT_EQ(run.consumed, stream.size());
}

TEST(VideoPss, ProbeSequenceReadsHeaders) {
    BitWriter es;
    es.Start(0xB3);
    es.Put(720, 12);
    es.Put(480, 12);
    es.Put(2, 4);
    es.Put(4, 4);
    es.Put(0x12345, 18);
    es.Put(1, 1);
    es.Put(0x1FF, 10);
    es.Put(0, 3);

    es.Start(0xB5);
    es.Put(1, 4);
    es.Put(0x48, 8);
    es.Put(0, 1);
    es.Put(1, 2);
    es.Put(0, 2);
    es.Put(0, 2);
    es.Put(0, 12);
    es.Put(1, 1);
    es.Put(0, 8);
    es.Put(0, 1);
    es.Put(0, 2);
    es.Put(0, 5);

    es.Start(0x00);
    es.Put(0, 10);
    es.Put(1, 3);
    es.Put(0xFFFF, 16);

    es.Start(0xB5);
    es.Put(8, 4);
    es.Put(0xFFFF, 16);
    es.Put(0, 2);
    es.Put(3, 2);
    es.Put(0, 1);
    es.Put(1, 1);
    es.Put(0, 1);
    es.Put(0, 1);
    es.Put(0, 1);
    es.Put(0, 1);
    es.Put(0, 1);
    es.Put(1, 1);
    es.Put(1, 1);
    es.Put(0, 1);

    const std::optional<Mpeg2SequenceInfo> info = video::ProbeSequence(es.Data());
    ASSERT_TRUE(info.has_value());
    EXPECT_EQ(info->width, 720);
    EXPECT_EQ(info->height, 480);
    EXPECT_EQ(info->aspect_ratio_code, 2);
    EXPECT_EQ(info->frame_rate_code, 4);
    EXPECT_EQ(info->bit_rate, 0x12345u);
    EXPECT_TRUE(info->mpeg2);
    EXPECT_EQ(info->profile_and_level, 0x48);
    EXPECT_FALSE(info->progressive_sequence);
    EXPECT_EQ(info->chroma_format, 1);
    EXPECT_FALSE(info->low_delay);
    ASSERT_TRUE(info->first_picture_progressive_frame.has_value());
    EXPECT_TRUE(*info->first_picture_progressive_frame);
    ASSERT_TRUE(info->first_picture_structure.has_value());
    EXPECT_EQ(*info->first_picture_structure, 3);
}

TEST(VideoPss, ProbeSequenceWithoutHeaderIsEmpty) {
    const Bytes es = {0x00, 0x00, 0x01, 0x12, 0x00, 0x00, 0x01, 0xB2, 0x01, 0x02, 0x03};
    EXPECT_FALSE(video::ProbeSequence(es).has_value());
}

TEST(VideoPss, L5LogoSequenceFlags) {
    const std::optional<fs::path> path = MovieFile("l5logo.pss");
    if (!path) {
        GTEST_SKIP() << "no extracted data/movie/l5logo.pss within 6 levels above the test executable";
    }

    std::ifstream in(*path, std::ios::binary);
    ASSERT_TRUE(in.is_open());
    const Bytes file((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());

    constexpr size_t kPush = 64 * 1024;
    constexpr size_t kProbeBytes = 64 * 1024;
    PssDemuxer demux;
    Bytes probe;
    size_t video_chunks = 0;
    size_t pcm_chunks = 0;
    uint64_t video_bytes = 0;
    uint64_t pcm_bytes = 0;
    std::optional<int64_t> first_video_pts;
    std::optional<int64_t> last_video_pts;
    std::optional<uint8_t> pcm_substream;
    Bytes first_pcm;

    const auto drain = [&] {
        while (std::optional<PssChunk> chunk = demux.Next()) {
            if (chunk->stream == PssStream::Video) {
                video_chunks++;
                video_bytes += chunk->payload.size();
                if (!first_video_pts && chunk->pts) {
                    first_video_pts = chunk->pts;
                }
                if (chunk->pts) {
                    last_video_pts = chunk->pts;
                }
                if (probe.size() < kProbeBytes) {
                    const size_t take = std::min(kProbeBytes - probe.size(), chunk->payload.size());
                    probe.insert(probe.end(), chunk->payload.begin(), chunk->payload.begin() + take);
                }
            } else {
                if (pcm_chunks == 0) {
                    pcm_substream = chunk->substream;
                    first_pcm = chunk->payload;
                }
                pcm_chunks++;
                pcm_bytes += chunk->payload.size();
            }
        }
    };

    for (size_t at = 0; at < file.size(); at += kPush) {
        demux.Push(std::span<const uint8_t>(file).subspan(at, std::min(kPush, file.size() - at)));
        drain();
    }
    demux.Finish();
    drain();

    EXPECT_EQ(demux.Error(), PssError::None);
    EXPECT_TRUE(demux.Done());
    EXPECT_EQ(demux.Consumed(), file.size());
    EXPECT_GT(video_chunks, 0u);

    const std::optional<Mpeg2SequenceInfo> info = video::ProbeSequence(probe);
    ASSERT_TRUE(info.has_value());
    EXPECT_TRUE(info->mpeg2);
    EXPECT_EQ(info->chroma_format, 1);

    const auto flag = [](bool value) { return value ? "1" : "0"; };
    const uint8_t structure = info->first_picture_structure.value_or(0);
    const bool progressive_frame = info->first_picture_progressive_frame.value_or(false);
    std::printf("L5LOGO width=%u height=%u aspect=%u frame_rate_code=%u bit_rate=%u mpeg2=%s profile_level=0x%02x "
                "progressive_sequence=%s chroma=%u first_progressive_frame=%s first_picture_structure=%u "
                "video_chunks=%zu pcm_chunks=%zu pcm_substream=0x%02x video_bytes=%llu pcm_bytes=%llu "
                "video_pts_first=%lld video_pts_last=%lld pcm_first_0x28=",
                info->width, info->height, info->aspect_ratio_code, info->frame_rate_code, info->bit_rate,
                flag(info->mpeg2), info->profile_and_level, flag(info->progressive_sequence), info->chroma_format,
                flag(progressive_frame), structure, video_chunks, pcm_chunks,
                pcm_substream.value_or(0), static_cast<unsigned long long>(video_bytes),
                static_cast<unsigned long long>(pcm_bytes),
                static_cast<long long>(first_video_pts.value_or(-1)),
                static_cast<long long>(last_video_pts.value_or(-1)));
    for (size_t i = 0; i < 0x28 && i < first_pcm.size(); i++) {
        std::printf("%02x", first_pcm[i]);
    }
    std::printf("\n");
    std::fflush(stdout);

    EXPECT_EQ(info->width, 512);
    EXPECT_EQ(info->height, 416);
    EXPECT_FALSE(info->progressive_sequence);
}

TEST(VideoFfmpeg, LinksTheLgplMpeg2Decoder) {
    EXPECT_EQ(LIBAVCODEC_VERSION_MAJOR, 63);
    EXPECT_EQ(avcodec_version() >> 16, static_cast<unsigned>(LIBAVCODEC_VERSION_MAJOR));
    EXPECT_NE(avcodec_find_decoder(AV_CODEC_ID_MPEG2VIDEO), nullptr);
    EXPECT_EQ(std::string_view(avcodec_license()).substr(0, 4), "LGPL");
    const std::string_view configuration = avcodec_configuration();
    EXPECT_EQ(configuration.find("--enable-gpl"), std::string_view::npos);
    EXPECT_EQ(configuration.find("--enable-nonfree"), std::string_view::npos);
}
