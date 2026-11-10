#pragma once

#include <cstddef>
#include <cstring>

#include "../../src/texture_source.hpp"
#include "loaded_buffer_copy.hpp"

namespace dc2::memory {

/**
 *
 * Copies bytes and carries their loaded-resource identity and byte bounds.
 *
 */
inline void *CopyTrackedBytes(void *destination, const void *source, std::size_t size) {
    void *result = std::memcpy(destination, source, size);
    TextureSourceCopy(source, destination, size);
    DataReadCopyBuffer(source, destination, size);
    return result;
}

} // namespace dc2::memory
