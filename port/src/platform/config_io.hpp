#pragma once
#include <iosfwd>

// Test seam for failures after a file has opened successfully. The hook may
// replace the stream buffer; it must keep that buffer alive for the read.
using ConfigReadHook = void (*)(std::istream &);
void ConfigSetReadHook(ConfigReadHook hook);
