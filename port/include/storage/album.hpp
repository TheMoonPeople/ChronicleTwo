#pragma once

#include <cstddef>
#include <cstdint>
#include <span>
#include <vector>

class CDC2AlbumData;

namespace dc2::mc {

/**
 * Gives the byte count of the portable fifty-photo album format.
 */
std::size_t AlbumFileSize();

/**
 * Accepts only the complete extents of supported portable and legacy album images.
 */
bool IsAlbumImageSize(std::uintmax_t size);

/**
 * Encodes owned album pixels and metadata without serializing host addresses or padding.
 */
std::vector<std::byte> EncodeAlbum(const CDC2AlbumData &album);

/**
 * Validates an album image before replacing the destination and rebinding its photo pointers.
 */
bool DecodeAlbum(std::span<const std::byte> image, CDC2AlbumData &destination);

} // namespace dc2::mc
