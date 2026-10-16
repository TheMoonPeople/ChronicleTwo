#include "options/registry.hpp"

#include <iterator>

namespace port_settings {
namespace {

constexpr Descriptor kDescriptors[] = {
    {
        "debug_mode",
        "game.debug_mode",
        "Debug Mode",
        Surface::PcOverlay,
        Kind::Bool,
        OPTION_ITEM_UNK_9,
    },
    {
        "skip_intro",
        "game.skip_intro",
        "Skip Intro",
        Surface::PcOverlay,
        Kind::Bool,
        OPTION_ITEM_SKIP_INTRO,
    },
    {
        "georama_poly_multiplier",
        "game.georama_poly_multiplier",
        "Polygon budget",
        Surface::PcOverlay,
        Kind::Int,
        -1,
    },
    {
        "expanded_dungeon_monsters",
        "game.expanded_dungeon_monsters",
        "Expanded dungeon monsters",
        Surface::PcOverlay,
        Kind::Bool,
        -1,
    },
};

} // namespace

std::span<const Descriptor> Descriptors() { return kDescriptors; }

const Descriptor *FindByConfigKey(std::string_view config_key) {
    for (const auto &entry : kDescriptors) {
        if (config_key == entry.config_key) {
            return &entry;
        }
    }
    return nullptr;
}

const Descriptor *FindByRetailRow(int retail_row) {
    for (const auto &entry : kDescriptors) {
        if (entry.retail_row == retail_row) {
            return &entry;
        }
    }
    return nullptr;
}

constexpr const char *kPcOverlayPageNames[] = {
    "Display",
    "Audio",
    "Controls",
    "Bindings",
    "Game",
    "Georama",
};

std::span<const char *const> PcOverlayPageNames() { return kPcOverlayPageNames; }

int PcOverlayPageCount() { return static_cast<int>(std::size(kPcOverlayPageNames)); }

bool RetailRowVisible(int row, int top, int visible_rows) {
    return row >= top && row < top + visible_rows;
}

} // namespace port_settings
