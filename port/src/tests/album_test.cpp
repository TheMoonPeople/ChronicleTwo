#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <bit>
#include <cstddef>
#include <cstdint>
#include <memory>
#include <span>
#include <vector>

#include "inventmn.hpp"
#include "storage/album.hpp"

namespace {

constexpr std::size_t photo_count = INVENT_ALBUM_PHOTO_NUM;
constexpr std::size_t pixel_bytes = 0x2000;
constexpr std::size_t metadata_bytes = 20;
constexpr std::size_t header_bytes = 40;

/**
 * Populates every persistent byte independently of the album's in-memory photo pointers.
 */
std::unique_ptr<CDC2AlbumData> MakeAlbum() {
    auto album = std::make_unique<CDC2AlbumData>();
    auto pixels = std::as_writable_bytes(std::span(album->photo_work));
    for (std::size_t index = 0; index < pixels.size(); ++index) {
        pixels[index] = static_cast<std::byte>((index * 37 + index / pixel_bytes) % 256);
    }
    std::size_t slot = 0;
    for (auto &photo : album->photo) {
        photo.used = 1;
        photo.is_new = static_cast<s8>(slot % 2);
        photo.map_no = static_cast<short>(slot);
        photo.npc_no = static_cast<short>(-static_cast<int>(slot) - 1);
        photo.monster_no = 32767;
        photo.unk_8 = -32768;
        photo.neta_id = static_cast<short>(slot * 101);
        std::ranges::fill(std::as_writable_bytes(std::span(photo.unk_c)), static_cast<std::byte>(slot));
        ++slot;
    }
    std::ranges::fill(std::span(album->unk_644b0), u8{0xa7});
    return album;
}

/**
 * Writes the legacy check digit in its little-endian disk representation.
 */
void WriteLegacyDigit(std::span<std::byte, 4> output, std::uint32_t value) {
    for (std::size_t index = 0; index < output.size(); ++index) {
        output[index] = static_cast<std::byte>((value >> (index * 8)) & 0xffu);
    }
}

/**
 * Builds an independent legacy image whose serialized addresses and padding are deliberately invalid.
 */
std::vector<std::byte> LegacyImage(const CDC2AlbumData &album, std::size_t stride) {
    const auto             portable = dc2::mc::EncodeAlbum(album);
    const std::size_t      pixels_size = photo_count * pixel_bytes;
    std::vector<std::byte> image(pixels_size + photo_count * stride + 0x800, std::byte{0xcc});
    std::ranges::copy(std::as_bytes(std::span(album.photo_work)), image.begin());
    auto metadata = std::span(image).subspan(pixels_size, photo_count * stride);
    for (std::size_t slot = 0; slot < photo_count; ++slot) {
        const auto source = std::span(portable).subspan(header_bytes + slot * (metadata_bytes + pixel_bytes), metadata_bytes);
        std::ranges::copy(source, metadata.subspan(slot * stride, metadata_bytes).begin());
    }
    std::uint32_t digit = 0;
    for (std::size_t block = 0; block < metadata.size() / 64; ++block) {
        digit += std::to_integer<std::uint8_t>(metadata[block * 64]) % 255u;
    }
    const auto trailer = std::span(image).last(0x800);
    WriteLegacyDigit(trailer.first<4>(), digit);
    WriteLegacyDigit(trailer.subspan<4, 4>(), digit);
    std::ranges::copy(std::as_bytes(std::span(album.unk_644b0)).subspan(8), trailer.subspan(8).begin());
    return image;
}

/**
 * Checks that decoded pointers name their destination's own pixel slots.
 */
void ExpectOwnedPixels(CDC2AlbumData &album) {
    for (std::size_t slot = 0; slot < photo_count; ++slot) {
        EXPECT_EQ(album.photo[slot].image, album.photo_work[slot]);
    }
}

} // namespace

TEST(AlbumCodec, RoundTripPreservesAllPersistentBytesAndRebindsEveryPhoto) {
    const auto source = MakeAlbum();
    const auto encoded = dc2::mc::EncodeAlbum(*source);
    ASSERT_EQ(encoded.size(), dc2::mc::AlbumFileSize());
    auto destination = std::make_unique<CDC2AlbumData>();
    ASSERT_TRUE(dc2::mc::DecodeAlbum(encoded, *destination));
    EXPECT_TRUE(encoded == dc2::mc::EncodeAlbum(*destination));
    ExpectOwnedPixels(*destination);
    EXPECT_EQ(destination->photo[1].npc_no, -2);
    EXPECT_EQ(destination->photo[49].neta_id, 4949);
    EXPECT_EQ(destination->photo[0].unk_8, -32768);

    for (auto &photo : source->photo) {
        photo.image = nullptr;
    }
    EXPECT_TRUE(encoded == dc2::mc::EncodeAlbum(*source));
}

TEST(AlbumCodec, HeaderPayloadAndChecksumCorruptionCannotPartiallyReplaceAnAlbum) {
    const auto                        source = MakeAlbum();
    const auto                        valid = dc2::mc::EncodeAlbum(*source);
    auto                              destination = std::make_unique<CDC2AlbumData>();
    const auto                        before = dc2::mc::EncodeAlbum(*destination);
    const std::array<std::size_t, 11> offsets{0, 8, 12, 16, 20, 24, 28, 32, 40, 60, valid.size() - 1};
    for (const auto offset : offsets) {
        SCOPED_TRACE(offset);
        auto corrupt = valid;
        corrupt[offset] ^= std::byte{1};
        EXPECT_FALSE(dc2::mc::DecodeAlbum(corrupt, *destination));
        EXPECT_TRUE(before == dc2::mc::EncodeAlbum(*destination));
        ExpectOwnedPixels(*destination);
    }
}

TEST(AlbumCodec, TruncatedAndExtendedImagesAreRejectedBeforeDestinationMutation) {
    const auto source = MakeAlbum();
    const auto valid = dc2::mc::EncodeAlbum(*source);
    auto       destination = std::make_unique<CDC2AlbumData>();
    const auto before = dc2::mc::EncodeAlbum(*destination);
    for (const auto size : std::array<std::size_t, 7>{0, 7, 39, 40, 60, valid.size() / 2, valid.size() - 1}) {
        SCOPED_TRACE(size);
        EXPECT_FALSE(dc2::mc::IsAlbumImageSize(size));
        EXPECT_FALSE(dc2::mc::DecodeAlbum(std::span(valid).first(size), *destination));
        EXPECT_TRUE(before == dc2::mc::EncodeAlbum(*destination));
    }
    auto extended = valid;
    extended.push_back(std::byte{0});
    EXPECT_FALSE(dc2::mc::DecodeAlbum(extended, *destination));
    EXPECT_TRUE(before == dc2::mc::EncodeAlbum(*destination));
}

TEST(AlbumCodec, Legacy32And64BitImagesIgnoreSerializedPointersAndPadding) {
    const auto source = MakeAlbum();
    const auto expected = dc2::mc::EncodeAlbum(*source);
    for (const std::size_t stride : {24u, 32u}) {
        SCOPED_TRACE(stride);
        auto legacy = LegacyImage(*source, stride);
        ASSERT_TRUE(dc2::mc::IsAlbumImageSize(legacy.size()));
        auto destination = std::make_unique<CDC2AlbumData>();
        ASSERT_TRUE(dc2::mc::DecodeAlbum(legacy, *destination));
        EXPECT_TRUE(expected == dc2::mc::EncodeAlbum(*destination));
        ExpectOwnedPixels(*destination);
        legacy[photo_count * pixel_bytes] ^= std::byte{1};
        EXPECT_FALSE(dc2::mc::DecodeAlbum(legacy, *destination));
        EXPECT_TRUE(expected == dc2::mc::EncodeAlbum(*destination));
        const auto digits = std::span(legacy).last(0x800).first(8);
        std::ranges::fill(digits, std::byte{0});
        EXPECT_TRUE(dc2::mc::DecodeAlbum(legacy, *destination));
        ExpectOwnedPixels(*destination);
    }
}
