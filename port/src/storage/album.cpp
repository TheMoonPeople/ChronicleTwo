#include "storage/album.hpp"

#include <algorithm>
#include <array>
#include <bit>
#include <limits>
#include <memory>
#include <optional>
#include <type_traits>

#include "inventmn.hpp"

namespace {
constexpr std::size_t              kAlbumPhotoCount = INVENT_ALBUM_PHOTO_NUM;
constexpr std::size_t              kAlbumPixelBytes = 0x2000;
constexpr std::size_t              kAlbumMetadataBytes = 20;
constexpr std::size_t              kAlbumLegacyTrailerBytes = 0x800;
constexpr std::size_t              kAlbumLegacyDigitsBytes = 8;
constexpr std::size_t              kAlbumOpaqueBytes = kAlbumLegacyTrailerBytes - kAlbumLegacyDigitsBytes;
constexpr std::size_t              kAlbumHeaderBytes = 40;
constexpr std::size_t              kAlbumChecksumOffset = 32;
constexpr std::size_t              kAlbumPixelsBytes = kAlbumPhotoCount * kAlbumPixelBytes;
constexpr std::size_t              kAlbumPayloadBytes = kAlbumPhotoCount * (kAlbumMetadataBytes + kAlbumPixelBytes) + kAlbumOpaqueBytes;
constexpr std::size_t              kAlbumPortableBytes = kAlbumHeaderBytes + kAlbumPayloadBytes;
constexpr std::uint32_t            kAlbumVersion = 1;
constexpr std::array<std::byte, 8> kAlbumMagic{
    std::byte{0x44}, std::byte{0x43}, std::byte{0x32}, std::byte{0x41},
    std::byte{0x4c}, std::byte{0x42}, std::byte{0x55}, std::byte{0x4d}};

static_assert(kAlbumPortableBytes <= static_cast<std::size_t>(std::numeric_limits<int>::max()));
static_assert(sizeof(short) == sizeof(std::uint16_t));
static_assert(sizeof(s8) == sizeof(std::byte));

/**
 * Gives a fixed unsigned field's portable little-endian representation.
 */
template <class Integer>
std::array<std::byte, sizeof(Integer)> AlbumLittleEndian(Integer value) {
    static_assert(std::is_unsigned_v<Integer>);
    static_assert(std::endian::native == std::endian::little || std::endian::native == std::endian::big);
    if constexpr (std::endian::native == std::endian::big) {
        value = std::byteswap(value);
    }
    return std::bit_cast<std::array<std::byte, sizeof(Integer)>>(value);
}

/**
 * Appends one fixed-width unsigned field to the portable image.
 */
template <class Integer>
void AppendAlbumInteger(std::vector<std::byte> &image, Integer value) {
    const auto bytes = AlbumLittleEndian(value);
    image.insert(image.end(), bytes.begin(), bytes.end());
}

/**
 * Computes the portable image's stable FNV-1a integrity value over every payload byte.
 */
std::uint64_t AlbumChecksum(std::span<const std::byte> bytes) {
    std::uint64_t value = 14695981039346656037ull;
    for (const auto byte : bytes) {
        value ^= std::to_integer<std::uint8_t>(byte);
        value *= 1099511628211ull;
    }
    return value;
}

/**
 * Consumes bounded album fields without exposing serialized addresses as native pointers.
 */
class AlbumReader {
public:
    explicit AlbumReader(std::span<const std::byte> input) : remaining(input) {}

    /**
     * Borrows the next field only when its complete extent remains available.
     */
    std::optional<std::span<const std::byte>> Take(std::size_t count) {
        if (count > remaining.size()) {
            return std::nullopt;
        }
        const auto field = remaining.first(count);
        remaining = remaining.subspan(count);
        return field;
    }

    /**
     * Decodes one fixed unsigned field in portable little-endian order.
     */
    template <class Integer>
    std::optional<Integer> IntegerField() {
        const auto field = Take(sizeof(Integer));
        if (!field) {
            return std::nullopt;
        }
        std::array<std::byte, sizeof(Integer)> bytes{};
        std::ranges::copy(*field, bytes.begin());
        auto value = std::bit_cast<Integer>(bytes);
        if constexpr (std::endian::native == std::endian::big) {
            value = std::byteswap(value);
        }
        return value;
    }

    /**
     * Reports the unconsumed input after the last complete field.
     */
    std::span<const std::byte> Remaining() const { return remaining; }

private:
    std::span<const std::byte> remaining; /**< Input extent still owned by the decoder's caller. */
};

/**
 * Reads the twenty meaningful metadata bytes shared by all supported album layouts.
 */
bool ReadAlbumMetadata(AlbumReader &reader, USER_PICTURE_INFO &photo) {
    const auto flags = reader.Take(2);
    if (!flags) {
        return false;
    }
    photo.used = std::bit_cast<s8>((*flags)[0]);
    photo.is_new = std::bit_cast<s8>((*flags)[1]);
    const auto read_short = [&](short &field) {
        const auto value = reader.IntegerField<std::uint16_t>();
        if (!value) {
            return false;
        }
        field = std::bit_cast<short>(*value);
        return true;
    };
    if (!read_short(photo.map_no) || !read_short(photo.npc_no) || !read_short(photo.monster_no) ||
        !read_short(photo.unk_8) || !read_short(photo.neta_id)) {
        return false;
    }
    const auto opaque = reader.Take(sizeof(photo.unk_c));
    if (!opaque) {
        return false;
    }
    std::ranges::copy(*opaque, std::as_writable_bytes(std::span(photo.unk_c)).begin());
    return true;
}

/**
 * Gives the legacy record stride only for an exact historical album file extent.
 */
std::optional<std::size_t> LegacyAlbumStride(std::size_t size) {
    for (const std::size_t stride : {24u, 32u}) {
        if (size == kAlbumPixelsBytes + kAlbumPhotoCount * stride + kAlbumLegacyTrailerBytes) {
            return stride;
        }
    }
    return std::nullopt;
}

/**
 * Accepts only the complete fixed extents of the supported portable and legacy formats.
 */
bool AlbumImageExtent(std::uintmax_t size) {
    return size == kAlbumPortableBytes ||
           size == kAlbumPixelsBytes + kAlbumPhotoCount * 24 + kAlbumLegacyTrailerBytes ||
           size == kAlbumPixelsBytes + kAlbumPhotoCount * 32 + kAlbumLegacyTrailerBytes;
}

/**
 * Gives the legacy sampled-byte check digit without interpreting its pointer fields.
 */
std::uint32_t LegacyAlbumDigit(std::span<const std::byte> metadata) {
    std::uint32_t digit = 0;
    for (std::size_t block = 0; block < metadata.size() / 64; ++block) {
        digit += std::to_integer<std::uint8_t>(metadata[block * 64]) % 255u;
    }
    return digit;
}

} // namespace

bool dc2::mc::IsAlbumImageSize(std::uintmax_t size) {
    return AlbumImageExtent(size);
}

std::size_t dc2::mc::AlbumFileSize() {
    return kAlbumPortableBytes;
}

std::vector<std::byte> dc2::mc::EncodeAlbum(const CDC2AlbumData &album) {
    std::vector<std::byte> image;
    image.reserve(kAlbumPortableBytes);
    image.insert(image.end(), kAlbumMagic.begin(), kAlbumMagic.end());
    AppendAlbumInteger(image, kAlbumVersion);
    AppendAlbumInteger(image, static_cast<std::uint32_t>(kAlbumPhotoCount));
    AppendAlbumInteger(image, static_cast<std::uint32_t>(kAlbumMetadataBytes));
    AppendAlbumInteger(image, static_cast<std::uint32_t>(kAlbumPixelBytes));
    AppendAlbumInteger(image, static_cast<std::uint32_t>(kAlbumOpaqueBytes));
    AppendAlbumInteger(image, static_cast<std::uint32_t>(kAlbumPayloadBytes));
    AppendAlbumInteger(image, std::uint64_t{0});
    const auto  pixels = std::as_bytes(std::span(album.photo_work));
    std::size_t slot = 0;
    for (const auto &photo : album.photo) {
        image.push_back(std::bit_cast<std::byte>(photo.used));
        image.push_back(std::bit_cast<std::byte>(photo.is_new));
        for (const short field : {photo.map_no, photo.npc_no, photo.monster_no, photo.unk_8, photo.neta_id}) {
            AppendAlbumInteger(image, std::bit_cast<std::uint16_t>(field));
        }
        const auto opaque = std::as_bytes(std::span(photo.unk_c));
        image.insert(image.end(), opaque.begin(), opaque.end());
        const auto photo_pixels = pixels.subspan(slot * kAlbumPixelBytes, kAlbumPixelBytes);
        image.insert(image.end(), photo_pixels.begin(), photo_pixels.end());
        ++slot;
    }
    const auto opaque = std::as_bytes(std::span(album.unk_644b0)).subspan(kAlbumLegacyDigitsBytes);
    image.insert(image.end(), opaque.begin(), opaque.end());
    if (image.size() != kAlbumPortableBytes) {
        return {};
    }
    const auto checksum = AlbumLittleEndian(AlbumChecksum(std::span(image).subspan(kAlbumHeaderBytes)));
    std::ranges::copy(checksum, std::span(image).subspan(kAlbumChecksumOffset, checksum.size()).begin());
    return image;
}

bool dc2::mc::DecodeAlbum(std::span<const std::byte> image, CDC2AlbumData &destination) {
    const auto                 legacy_stride = LegacyAlbumStride(image.size());
    std::span<const std::byte> payload;
    if (image.size() == kAlbumPortableBytes) {
        AlbumReader header(image);
        const auto  magic = header.Take(kAlbumMagic.size());
        if (!magic || !std::ranges::equal(*magic, kAlbumMagic) ||
            header.IntegerField<std::uint32_t>() != kAlbumVersion ||
            header.IntegerField<std::uint32_t>() != kAlbumPhotoCount ||
            header.IntegerField<std::uint32_t>() != kAlbumMetadataBytes ||
            header.IntegerField<std::uint32_t>() != kAlbumPixelBytes ||
            header.IntegerField<std::uint32_t>() != kAlbumOpaqueBytes ||
            header.IntegerField<std::uint32_t>() != kAlbumPayloadBytes) {
            return false;
        }
        const auto checksum = header.IntegerField<std::uint64_t>();
        payload = header.Remaining();
        if (!checksum || payload.size() != kAlbumPayloadBytes || *checksum != AlbumChecksum(payload)) {
            return false;
        }
    } else if (legacy_stride) {
        payload = image;
        const auto  metadata = image.subspan(kAlbumPixelsBytes, kAlbumPhotoCount * *legacy_stride);
        AlbumReader digits(image.subspan(kAlbumPixelsBytes + metadata.size(), kAlbumLegacyDigitsBytes));
        const auto  first = digits.IntegerField<std::uint32_t>();
        const auto  second = digits.IntegerField<std::uint32_t>();
        if (!first || !second || ((*first != 0 || *second != 0) && *first != LegacyAlbumDigit(metadata))) {
            return false;
        }
    } else {
        return false;
    }
    auto        decoded = std::make_unique<CDC2AlbumData>();
    AlbumReader reader(payload);
    if (legacy_stride) {
        const auto pixels = reader.Take(kAlbumPixelsBytes);
        if (!pixels) {
            return false;
        }
        std::ranges::copy(*pixels, std::as_writable_bytes(std::span(decoded->photo_work)).begin());
    }
    const auto  pixel_slots = std::span(decoded->photo_work);
    std::size_t slot = 0;
    for (auto &photo : decoded->photo) {
        if (!ReadAlbumMetadata(reader, photo)) {
            return false;
        }
        if (legacy_stride) {
            if (!reader.Take(*legacy_stride - kAlbumMetadataBytes)) {
                return false;
            }
        } else {
            const auto pixels = reader.Take(kAlbumPixelBytes);
            if (!pixels) {
                return false;
            }
            std::ranges::copy(*pixels, std::as_writable_bytes(std::span(pixel_slots[slot])).begin());
        }
        ++slot;
    }
    if (legacy_stride && !reader.Take(kAlbumLegacyDigitsBytes)) {
        return false;
    }
    const auto opaque = reader.Take(kAlbumOpaqueBytes);
    if (!opaque || !reader.Remaining().empty()) {
        return false;
    }
    std::ranges::copy(*opaque, std::as_writable_bytes(std::span(decoded->unk_644b0)).subspan(kAlbumLegacyDigitsBytes).begin());
    destination = *decoded;
    destination.RelateAlbumPicData();
    return true;
}
