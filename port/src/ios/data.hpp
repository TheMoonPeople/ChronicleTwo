#pragma once

// The iOS launcher's game data: where the disc image is, and its extraction on a worker thread.

#include <filesystem>
#include <optional>
#include <string>

// Leaves a note in Documents, so the Files app lists the app's folder and shows where the disc image goes.
void IosLeaveNote();

// The first disc image (.iso) in the app's Documents folder or its Inbox, where the Files app and Open In put it.
std::optional<std::filesystem::path> IosDiscImage();

struct IosExtraction {
    bool        running = false;
    float       fraction = 0;
    std::string stage;
    // Set once a finished extraction failed.
    std::string failure;
};

// Starts extracting image into root on a worker thread; does nothing while one is running.
void IosExtractBegin(const std::filesystem::path &image, const std::filesystem::path &root);
// The running extraction's progress, or the outcome of the last one.
IosExtraction IosExtractPoll();
