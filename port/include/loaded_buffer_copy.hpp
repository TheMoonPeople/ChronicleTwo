#pragma once

#include <cstddef>

/**
 * Transfers native file byte bounds when a loaded buffer is copied.
 */
void DataReadCopyBuffer(const void *source, void *destination, std::size_t size);
