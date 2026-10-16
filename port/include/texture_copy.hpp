#pragma once

#include <cstddef>
#include <cstring>

#include "../src/texture_source.hpp"
#include "loaded_buffer_copy.hpp"

inline void *PortTextureSourceCopy(void *destination, const void *source, std::size_t size) {
    void *result = std::memcpy(destination, source, size);
    TextureSourceCopy(source, destination, size);
    DataReadCopyBuffer(source, destination, size);
    return result;
}

// Native source copies call this explicitly, leaving standard-library headers unaffected.
