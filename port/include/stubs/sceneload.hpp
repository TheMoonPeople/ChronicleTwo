#pragma once

#include <sceneload.hpp>

// LoadMapData reads a map's files into a buffer sized to them and followed by a guard (port/src/sceneload.cpp); the
// caller's load_buf is left alone.
u8 *PortMapLoadBuffer(const SCN_LOADMAP_INFO2 &info);
// Aborts with a log line when LoadMapData's reads ended past what was measured or wrote into the guard.
void PortMapLoadCheck(const SCN_LOADMAP_INFO2 &info, const u8 *end);
