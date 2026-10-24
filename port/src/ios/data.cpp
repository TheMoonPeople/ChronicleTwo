#include <SDL3/SDL_platform.h>

#ifdef SDL_PLATFORM_IOS

#include "ios/data.hpp"

#include "kazarov_bridge/rust/lib.h"

#include <algorithm>
#include <atomic>
#include <cctype>
#include <cstdlib>
#include <exception>
#include <fstream>
#include <mutex>
#include <system_error>
#include <thread>

#include "log/log.hpp"
#include "platform/firstrun.hpp"
#include "platform/paths.hpp"

namespace fs = std::filesystem;

namespace {

// One worker at a time, whose failure stays readable until the next one starts.
std::thread       g_extract_worker;
std::atomic<bool> g_extract_running = false;
std::mutex        g_extract_mutex;
std::string       g_extract_failure;

} // namespace

void IosLeaveNote() {
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

// iOS has no file dialog for the game to open: the disc image is copied into the app's Documents folder with the
// Files app, or chosen in the launcher. HOME is the app's container, also under LiveContainer, which points it at
// the guest app's own data container. A file shared to the app with Open In lands in an Inbox: Documents/Inbox
// when installed on its own, <home>/Inbox under LiveContainer.
std::optional<fs::path> IosDiscImage() {
    const char *home = std::getenv("HOME");
    if (home == nullptr) {
        return std::nullopt;
    }
    for (const fs::path &folder : {fs::path(home) / "Documents", fs::path(home) / "Documents" / "Inbox",
                                   fs::path(home) / "Inbox"}) {
        std::error_code error;
        for (const fs::directory_entry &entry : fs::directory_iterator(folder, error)) {
            std::string extension = entry.path().extension().string();
            std::ranges::transform(extension, extension.begin(), [](unsigned char c) { return std::tolower(c); });
            if (extension == ".iso" && entry.is_regular_file(error)) {
                return entry.path();
            }
        }
    }
    return std::nullopt;
}

void IosExtractBegin(const fs::path &image, const fs::path &root) {
    if (g_extract_running) {
        return;
    }
    if (g_extract_worker.joinable()) {
        g_extract_worker.join();
    }
    {
        const std::lock_guard lock(g_extract_mutex);
        g_extract_failure.clear();
    }
    g_extract_running = true;
    CT_LOG_INFO(Main, "Extracting the game data from {}", PathsDisplay(image));
    g_extract_worker = std::thread([image, root] {
        std::string failure;
        try {
            // Each worker holds its resources' converted output: two keep the peak well inside what iOS lets an
            // app use.
            const unsigned jobs = std::clamp(std::thread::hardware_concurrency(), 1u, 2u);
            kazarov::extract_tracked(image.string(), root.string(), jobs);
        } catch (const std::exception &error) {
            failure = error.what();
        }
        if (failure.empty() && FirstRunDataMissing(root)) {
            failure = "The extraction finished without current game data.";
        }
        if (!failure.empty()) {
            CT_LOG_ERROR(Main, "Game data setup: {}", failure);
        }
        {
            const std::lock_guard lock(g_extract_mutex);
            g_extract_failure = std::move(failure);
        }
        g_extract_running = false;
    });
}

IosExtraction IosExtractPoll() {
    IosExtraction result;
    if (g_extract_running) {
        const kazarov::ExtractStatus status = kazarov::extract_status();
        result.running = true;
        result.fraction = std::clamp(status.fraction, 0.0f, 1.0f);
        result.stage = std::string(status.stage);
        return result;
    }
    if (g_extract_worker.joinable()) {
        g_extract_worker.join();
    }
    const std::lock_guard lock(g_extract_mutex);
    result.failure = g_extract_failure;
    return result;
}

#endif
