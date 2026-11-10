#pragma once

#include "dataread.hpp"
#include "runscript.hpp"

namespace dc2::event {
/**
 *
 * Acquires owned event bytes from queued files, a retained native directory, or the selected data source.
 *
 */
io::FileRead ReadFile(std::string_view name);
/**
 *
 * Selects the native source identity from current owned event reads without borrowing data pointers.
 *
 */
std::optional<std::string> ResolveFileSource(std::string_view name);
/**
 *
 * Retains a selected event pack file until replacement or event cleanup.
 *
 */
bool LoadPack(std::string_view name);
/**
 *
 * Releases the retained event directory when its event lifetime ends.
 *
 */
void ResetReadFiles();
} // namespace dc2::event

/**
 *
 * Queues event resource reads into independently owned native file buffers.
 *
 */
int _SET_LOADBG_FILE(dc2::script::RunArguments stack, int argc);
