#pragma once

#include <filesystem>
#include <format>

#include "platform/config.hpp"
#include "platform/paths.hpp"
#include "platform_fixture.hpp"

// Sets game.sprint for a test, in a save root of its own, since config.json sits beside the save root.
struct SprintSetting {
    std::filesystem::path previous = PathsSaveRoot();
    std::filesystem::path root = std::filesystem::temp_directory_path() / std::format("dc2_sprint_{}", dc::test::ProcessId());

    explicit SprintSetting(bool on) {
        PathsSetSaveRoot(root / "save");
        Set(on);
    }

    void Set(bool on) {
        Config config = ConfigGet();
        config.sprint = on;
        ConfigChange(config);
    }

    ~SprintSetting() {
        ConfigChange(Config{});
        PathsSetSaveRoot(previous);
        std::error_code ignored;
        std::filesystem::remove_all(root, ignored);
    }
};
