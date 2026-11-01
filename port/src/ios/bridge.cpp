#include <SDL3/SDL_platform.h>

#ifdef SDL_PLATFORM_IOS

#include "kazarov_bridge/rust/lib.h"

#include <algorithm>
#include <array>
#include <cctype>
#include <chrono>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <fstream>
#include <future>
#include <memory>
#include <thread>
#include <utility>

#include "audio/synth.hpp"
#include "dualsense_haptics.hpp"
#include "ios/bridge.hpp"
#include "log/log.hpp"
#include "options/rows.hpp"
#include "platform/config.hpp"
#include "platform/firstrun.hpp"
#include "platform/input.hpp"
#include "platform/paths.hpp"

namespace ct::ios {
namespace fs = std::filesystem;

namespace {

std::future<std::string> extraction_worker;
std::string              extraction_failure;

constexpr std::array<std::uint16_t, 16> kButtons = {
    kInputUp, kInputDown, kInputLeft, kInputRight, kInputCross, kInputCircle, kInputSquare, kInputTriangle,
    kInputL1, kInputR1, kInputL2, kInputR2, kInputSelect, kInputStart, kInputL3, kInputR3};

const options::Row *RowAt(int page, int row) {
    const auto pages = options::Pages();
    if (page < 0 || std::cmp_greater_equal(page, pages.size()) || row < 0 ||
        std::cmp_greater_equal(row, pages[page].rows.size())) {
        return nullptr;
    }
    return &pages[page].rows[row];
}

} // namespace

void SetTouchOverlay(const TouchState &state) {
    InputSetTouchOverlay({.buttons = state.buttons, .left_x = state.left_x, .left_y = state.left_y, .right_x = state.right_x, .right_y = state.right_y});
}

bool TouchOverlayVisible() { return InputTouchOverlayVisible(); }

std::uint16_t ButtonBit(int index) {
    return index >= 0 && std::cmp_less(index, kButtons.size()) ? kButtons[index] : 0;
}

int HapticsRate() { return audio::kSpuRate; }

void HapticsRender(float *left_right, int frames) { ::HapticsRender(left_right, frames); }

std::string PageTitle() { return options::kPageTitle; }

int SettingsPageCount() { return static_cast<int>(options::Pages().size()); }

std::string SettingsPageName(int page) {
    const auto pages = options::Pages();
    return page >= 0 && std::cmp_less(page, pages.size()) ? pages[page].name : "";
}

int SettingsRowCount(int page) {
    const auto pages = options::Pages();
    return page >= 0 && std::cmp_less(page, pages.size()) ? static_cast<int>(pages[page].rows.size()) : 0;
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

void LeaveNote() {
    const char *home = std::getenv("HOME");
    if (home == nullptr) {
        return;
    }
    std::error_code error;
    const fs::path  documents = fs::path(home) / "Documents";
    fs::create_directories(documents, error);
    const fs::path note = documents / "Copy the Dark Chronicle ISO here.txt";
    if (!fs::exists(note, error)) {
        std::ofstream(note) << "Copy your Dark Chronicle disc image (.iso) into this folder, then open the game.\n";
    }
}

std::string DiscImage() {
    const char *home = std::getenv("HOME");
    if (home == nullptr) {
        return {};
    }
    for (const fs::path &folder : {fs::path(home) / "Documents", fs::path(home) / "Documents" / "Inbox",
                                   fs::path(home) / "Inbox"}) {
        std::error_code error;
        for (const fs::directory_entry &entry : fs::directory_iterator(folder, error)) {
            std::string extension = entry.path().extension().string();
            std::ranges::transform(extension, extension.begin(), [](unsigned char c) { return std::tolower(c); });
            if (extension == ".iso" && entry.is_regular_file(error)) {
                return entry.path().string();
            }
        }
    }
    return {};
}

void ExtractBegin(const std::string &image, const std::string &root) {
    if (extraction_worker.valid() && extraction_worker.wait_for(std::chrono::seconds(0)) != std::future_status::ready) {
        return;
    }
    extraction_failure.clear();
    CT_LOG_INFO(Main, "Extracting game data from {}", PathsDisplay(image));
    extraction_worker = {};
    try {
        extraction_worker = std::async(std::launch::async, [](const std::string &image, const std::string &root) {
        try {
            const unsigned jobs = std::clamp(std::thread::hardware_concurrency(), 1u, 2u);
            // The game runs the scripts' Luau modules, so the compiled scripts are not published.
            kazarov::extract_tracked_with_script_policy(image, root, jobs, kazarov::ScriptPublicationPolicy::LuauOnly);
            return FirstRunDataMissing(root) ? std::string("The extraction finished without current game data.") : std::string{};
        } catch (const std::exception &error) {
            return std::string(error.what());
        } }, image, root);
    } catch (const std::exception &error) {
        extraction_failure = error.what();
    }
}

Extraction ExtractPoll() {
    if (extraction_worker.valid()) {
        if (extraction_worker.wait_for(std::chrono::seconds(0)) != std::future_status::ready) {
            const auto status = kazarov::extract_status();
            return {.running = true, .fraction = std::clamp(status.fraction, 0.0f, 1.0f), .stage = std::string(status.stage)};
        }
        extraction_failure = extraction_worker.get();
        if (!extraction_failure.empty()) {
            CT_LOG_ERROR(Main, "Game data setup: {}", extraction_failure);
        }
    }
    return {.failure = extraction_failure};
}

} // namespace ct::ios

namespace {

/**
 * Copies native UTF-8 text into a buffer owned by the Swift caller.
 */
IosString CopyUtf8(const std::string &text) {
    if (text.empty()) {
        return {};
    }
    auto data = std::make_unique<uint8_t[]>(text.size());
    std::ranges::copy(text, data.get());
    return {.data = data.release(), .size = text.size()};
}

} // namespace

// Unexpected native exceptions terminate at this boundary; extraction catches operational errors
// and reports their text through the owned progress snapshot.
void IosStringFree(IosString text) noexcept { delete[] text.data; }

void IosExtractionFree(IosExtraction extraction) noexcept {
    IosStringFree(extraction.stage);
    IosStringFree(extraction.failure);
}

void IosSetTouchOverlay(IosTouchState state) noexcept {
    ct::ios::SetTouchOverlay({.buttons = state.buttons, .left_x = state.left_x, .left_y = state.left_y, .right_x = state.right_x, .right_y = state.right_y});
}

bool IosTouchOverlayVisible() noexcept { return ct::ios::TouchOverlayVisible(); }

uint16_t IosButtonBit(int index) noexcept { return ct::ios::ButtonBit(index); }

int IosHapticsRate() noexcept { return ct::ios::HapticsRate(); }

void IosHapticsRender(float *left_right, int frames) noexcept { ct::ios::HapticsRender(left_right, frames); }

IosString IosPageTitle() noexcept { return CopyUtf8(ct::ios::PageTitle()); }

int IosSettingsPageCount() noexcept { return ct::ios::SettingsPageCount(); }

IosString IosSettingsPageName(int page) noexcept { return CopyUtf8(ct::ios::SettingsPageName(page)); }

int IosSettingsRowCount(int page) noexcept { return ct::ios::SettingsRowCount(page); }

bool IosSettingsRowSteppable(int page, int row) noexcept { return ct::ios::SettingsRowSteppable(page, row); }

IosString IosSettingsRowLabel(int page, int row) noexcept { return CopyUtf8(ct::ios::SettingsRowLabel(page, row)); }

IosString IosSettingsRowHelp(int page, int row) noexcept { return CopyUtf8(ct::ios::SettingsRowHelp(page, row)); }

IosString IosSettingsRowValue(int page, int row) noexcept { return CopyUtf8(ct::ios::SettingsRowValue(page, row)); }

IosSettingsChange IosSettingsStep(int page, int row, int direction) noexcept {
    const ct::ios::StepResult result = ct::ios::SettingsStep(page, row, direction);
    return {.changed = result != ct::ios::StepResult::Unchanged, .saved = result == ct::ios::StepResult::Saved};
}

bool IosDataMissing(const char *root) noexcept { return ct::ios::DataMissing(root); }

IosString IosDiscImage() noexcept { return CopyUtf8(ct::ios::DiscImage()); }

void IosExtractBegin(const char *image, const char *root) noexcept try {
    ct::ios::ExtractBegin(image, root);
} catch (...) {
    std::terminate();
}

IosExtraction IosExtractPoll() noexcept try {
    const ct::ios::Extraction extraction = ct::ios::ExtractPoll();
    return {.running = extraction.running, .fraction = extraction.fraction, .stage = CopyUtf8(extraction.stage), .failure = CopyUtf8(extraction.failure)};
} catch (...) {
    std::terminate();
}

#endif
