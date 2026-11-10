#pragma once

#include <span>

#include "runscript.hpp"

/**
 *
 * Replaces event externals that build text in fixed buffers with bounded native ones.
 *
 */
void ReplaceEventTextExternals(std::span<dc2::script::RunFunction> table);
