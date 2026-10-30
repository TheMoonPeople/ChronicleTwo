#pragma once

#include <cstddef>

#include "sceneload.hpp"
#include "stubs/sceneload.hpp"

// The bytes LoadMapData writes for a map's .map, .cfg, .mpk and .sky reads, including the last read's sector tail.
std::size_t PortMapLoadBytes(const SCN_LOADMAP_INFO2 &info);
