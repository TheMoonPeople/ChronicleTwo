#pragma once

#include <functional>
#include <span>
#include <string>
#include <vector>

#include "platform/config.hpp"
#include "platform/window.hpp"

namespace options {

struct Row {
    std::string                                key;
    std::string                                label;
    std::string                                help;
    std::function<std::string(const Config &)> value;
    std::function<void(Config &, int)>         step;
    std::string                                action;
};

struct Page {
    const char      *name;
    std::vector<Row> rows;
};

std::span<const Page>        Pages();
bool                         StepRow(const Row &row, Config &config, int direction);
bool                         SetBinding(Config &config, std::string_view action, std::string_view key);
void                         ResetBinding(Config &config, std::string_view action);
std::vector<DisplayModeSize> ResolutionList(std::span<const DisplayModeSize> modes, int width, int height);
void                         ListResolutions();
// Names for the PC page's prompts, including keyboard rebinding and forced controller families.
std::string ButtonName(std::string_view action, const Config &config);

} // namespace options
