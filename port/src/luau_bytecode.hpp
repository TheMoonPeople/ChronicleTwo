#pragma once

// Precompiled Luau scripts (docs/PORT_LUAU.md). A build can compile each scripts/<module>.luau ahead of time into
// <module>.luauc beside it, so the game loads bytecode instead of compiling the source when a module first runs.
// luau_runtime.cpp and the build's precompiler (tools/luau/precompile) share this header.
//
// A .luauc file is kMagic, the 64-bit FNV-1a hash of the source it was compiled from (little-endian), then the bytecode.
// The game uses it only while the hash still matches the .luau beside it, so an edited script is compiled as before.

#include "luacode.h"

#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <string_view>

namespace luau_bytecode {

inline constexpr std::string_view kMagic = "CTLB";
inline constexpr std::size_t kHeaderSize = kMagic.size() + sizeof(std::uint64_t);

/**
 *
 * The options the game compiles a script's source with at run time.
 *
 */
inline lua_CompileOptions RuntimeOptions() {
    lua_CompileOptions options{};
    options.optimizationLevel = 1;
    options.debugLevel = 1;
    return options;
}

/**
 *
 * FNV-1a hash of a script's source, which ties a .luauc file to the source it was compiled from.
 *
 */
constexpr std::uint64_t SourceHash(std::string_view source) {
    std::uint64_t hash = 0xcbf29ce484222325ULL;
    for (const char c : source) {
        hash ^= static_cast<unsigned char>(c);
        hash *= 0x100000001b3ULL;
    }
    return hash;
}

/**
 *
 * The header a .luauc file compiled from source starts with.
 *
 */
inline std::string Header(std::string_view source) {
    std::string         header(kMagic);
    const std::uint64_t hash = SourceHash(source);
    for (std::size_t byte = 0; byte < sizeof hash; ++byte) {
        header.push_back(static_cast<char>((hash >> (8 * byte)) & 0xFF));
    }
    return header;
}

/**
 *
 * The bytecode in a .luauc file's contents, or nothing when they are not a precompiled form of source.
 *
 */
inline std::optional<std::string_view> Bytecode(std::string_view contents, std::string_view source) {
    if (contents.size() <= kHeaderSize || contents.substr(0, kHeaderSize) != Header(source)) {
        return std::nullopt;
    }
    return contents.substr(kHeaderSize);
}

} // namespace luau_bytecode
