#pragma once

#include <cstddef>
#include <cstdint>
#include <span>
#include <string_view>

#include "menuop.hpp"
#include "platform/config.hpp"

namespace port_settings {

enum class Surface : std::uint8_t {
    Retail = 1 << 0,
    PcOverlay = 1 << 1,
};

constexpr Surface operator|(Surface left, Surface right) {
    return static_cast<Surface>(static_cast<std::uint8_t>(left) | static_cast<std::uint8_t>(right));
}

constexpr bool HasSurface(Surface surfaces, Surface flag) {
    return (static_cast<std::uint8_t>(surfaces) & static_cast<std::uint8_t>(flag)) != 0;
}

enum class Kind : std::uint8_t {
    Bool,
    Int,
};

struct Descriptor {
    const char *id;
    const char *config_key;
    const char *label;
    Surface     surfaces;
    Kind        kind;
    int         retail_row;
};

std::span<const Descriptor> Descriptors();

const Descriptor *FindByConfigKey(std::string_view config_key);
const Descriptor *FindByRetailRow(int retail_row);

int PcOverlayPageCount();

std::span<const char *const> PcOverlayPageNames();

constexpr int kRetailVisibleRows = 9;

bool RetailRowVisible(int row, int top, int visible_rows = kRetailVisibleRows);

} // namespace port_settings
