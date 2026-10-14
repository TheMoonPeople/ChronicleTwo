#pragma once

#include <cstddef>
#include <cstdint>
#include <vector>

/**
 * High-resolution copies of camera photos. Saves keep retail's 64x64 16-bit picture; the host keeps a sharper
 * copy beside the saves, found again by a hash of those 16-bit bytes.
 */

/** Side of a stored high-resolution photo, in texels. */
inline constexpr uint32_t kPhotoHdSize = 256;
/** Physical scale of the camera's capture target ("fix_work") over its retail 64x64. */
inline constexpr uint32_t kPhotoWorkScale = 4;

/** True for the camera's capture target. */
bool PhotoHdIsWorkTexture(const char *name);
/** Keeps an RGBA kPhotoHdSize square for the retail picture image16, in memory and on disk. */
void PhotoHdRemember(const uint8_t *image16, size_t bytes, std::vector<uint8_t> rgba);
/** The RGBA kPhotoHdSize square kept for image16, or nullptr. */
const std::vector<uint8_t> *PhotoHdFind(const uint8_t *image16, size_t bytes);
