#include <SDL3/SDL_platform.h>

#ifdef SDL_PLATFORM_IOS

#include "ios/bridge.hpp"

#include <array>

#include "audio/synth.hpp"
#include "dualsense_haptics.hpp"
#include "ios/data.hpp"
#include "options/rows.hpp"
#include "platform/config.hpp"
#include "platform/firstrun.hpp"
#include "platform/input.hpp"

namespace ct::ios {

namespace {

constexpr std::array<std::uint16_t, 16> kButtons = {
    kInputUp, kInputDown, kInputLeft, kInputRight, kInputCross, kInputCircle, kInputSquare, kInputTriangle,
    kInputL1, kInputR1, kInputL2, kInputR2, kInputSelect, kInputStart, kInputL3, kInputR3};

const options::Row *RowAt(int page, int row) {
    const auto pages = options::Pages();
    if (page < 0 || page >= static_cast<int>(pages.size()) || row < 0 ||
        row >= static_cast<int>(pages[page].rows.size())) {
        return nullptr;
    }
    return &pages[page].rows[row];
}

} // namespace

void SetTouchOverlay(const TouchState &state) {
    InputSetTouchOverlay({state.buttons, state.left_x, state.left_y, state.right_x, state.right_y});
}

bool TouchOverlayVisible() { return InputTouchOverlayVisible(); }

std::uint16_t ButtonBit(int index) {
    return index >= 0 && index < static_cast<int>(kButtons.size()) ? kButtons[index] : 0;
}

int HapticsRate() { return audio::kSpuRate; }

void HapticsRender(float *left_right, int frames) { ::HapticsRender(left_right, frames); }

std::string PageTitle() { return options::kPageTitle; }

int SettingsPageCount() { return static_cast<int>(options::Pages().size()); }

std::string SettingsPageName(int page) {
    const auto pages = options::Pages();
    return page >= 0 && page < static_cast<int>(pages.size()) ? pages[page].name : "";
}

int SettingsRowCount(int page) {
    const auto pages = options::Pages();
    return page >= 0 && page < static_cast<int>(pages.size()) ? static_cast<int>(pages[page].rows.size()) : 0;
}

bool SettingsRowSteppable(int page, int row) {
    const options::Row *entry = RowAt(page, row);
    return entry != nullptr && entry->step && entry->action.empty();
}

std::string SettingsRowLabel(int page, int row) {
    const options::Row *entry = RowAt(page, row);
    return entry != nullptr ? entry->label : "";
}

std::string SettingsRowHelp(int page, int row) {
    const options::Row *entry = RowAt(page, row);
    return entry != nullptr ? entry->help : "";
}

std::string SettingsRowValue(int page, int row) {
    const options::Row *entry = RowAt(page, row);
    return entry != nullptr && entry->value ? entry->value(ConfigGet()) : "";
}

StepResult SettingsStep(int page, int row, int direction) {
    const options::Row *entry = RowAt(page, row);
    Config              config = ConfigGet();
    if (entry == nullptr || !options::StepRow(*entry, config, direction)) {
        return StepResult::Unchanged;
    }
    return ConfigChange(config) ? StepResult::Saved : StepResult::NotSaved;
}

bool DataMissing(const std::string &root) { return FirstRunDataMissing(root); }

std::string DiscImage() {
    const auto image = IosDiscImage();
    return image ? image->string() : "";
}

void ExtractBegin(const std::string &image, const std::string &root) { IosExtractBegin(image, root); }

Extraction ExtractPoll() {
    const IosExtraction extraction = IosExtractPoll();
    return {extraction.running, extraction.fraction, extraction.stage, extraction.failure};
}

} // namespace ct::ios

#endif
