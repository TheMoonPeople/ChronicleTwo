#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <string>
#include <string_view>

// Load-time removal of the PAL release's 50 Hz conversions from the disc scripts (.stb), for the NTSC
// gameplay timing. The PAL scripts carry the NTSC frame counts and convert them at run time: the event
// library scales field counts by 50/60, monster scripts call a 30 -> 25 frame converter, a few scripts
// divide by 30 and multiply by 25 in integers, and a handful of sites were retuned by hand. Each recipe
// matches decoded instructions inside a script's functions (never a raw byte search) and replaces the
// conversion with no-ops, or writes the NTSC literal at an anchored instruction after checking the PAL
// one. A known script that does not show exactly the expected recipe counts is refused.

namespace script_timing {

// The recipe classes, in the order of the inventory's count columns.
enum Recipe : int {
    kEventAssign = 0, // l = (l * 50) / 60 in an event helper: the factor becomes no-ops
    kEventCue,        // the lip-sync cue l2 = (l1 * 50) / 60: the whole assignment becomes no-ops
    kEventInline,     // (x * 50) / 60 in an expression: the factor becomes no-ops
    kEventInlineFloat,
    kEventInverse, // (x / 60) * 50
    kEventInverseFloat,
    kMonsterConvert, // conv(n) = ftoi(itof(n) / 30.0f * 25.0f): conversion and factor become no-ops, FTOI stays
    kInteger3025,    // (n / 30) * 25 in integers
    kRecipeCount,
};

struct Counts {
    std::array<int, kRecipeCount> recipes{};
    int                           anchors = 0; // per-file anchored timing literals
    int                           windows = 0; // Max/Monica motion-ratio attack windows

    bool operator==(const Counts &) const = default;
};

// One inventory row: the counts a known PAL script must show.
struct Expected {
    const char                             *path;
    std::array<std::uint16_t, kRecipeCount> recipes;
    std::uint8_t                            anchors;
    std::uint8_t                            windows;
};

struct Options {
    bool            write = true;
    const Expected *expected = nullptr; // replaces the inventory lookup (tests)
    bool            use_inventory = true;
};

struct Result {
    bool        ok = false;    // decoded and matched the expectation (or no recipe in an unknown script)
    bool        known = false; // listed in the inventory
    bool        decoded = false;
    Counts      counts;     // sites found, patched or already patched
    int         writes = 0; // instructions rewritten by this call
    std::string error;
};

// Normalised inventory key of an asset path: lower case, forward slashes, no leading slash.
std::string Key(std::string_view asset_path);

// The inventory row of a key, or nullptr for a script with no PAL timing conversion.
const Expected *Find(std::string_view key);

// The number of inventory rows.
std::size_t InventorySize();

// Matches every recipe in bytes (size unchanged) and, when options.write and the counts match, rewrites
// them all at once. Already patched sites are recognised and counted, so a second call writes nothing.
Result Apply(std::string_view key, unsigned char *bytes, std::size_t size, const Options &options = {});

// Converts a loaded script for the NTSC timing; false when a known script does not match.
bool Patch(const char *asset_path, unsigned char *bytes, std::size_t size);

} // namespace script_timing

// The loader seam: always converts script bytes read from the data index to NTSC timing.
// Returns false (after printing the asset) when a known script does not match; other assets pass unchanged.
bool ScriptTimingPatch(const char *asset_path, unsigned char *bytes, std::size_t size);
