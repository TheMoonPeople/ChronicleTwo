#include <gtest/gtest.h>

#include <chrono>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "mg_memory.hpp"
#include "platform/paths.hpp"

TEST(MenuRead, ReadsEveryHostPointerAndAlignsEachFile) {
    /**
     * Restores the language selected before menu data is read.
     */
    struct LanguageState {
        int previous_language = LanguageCode; /**< Language belonging to the enclosing test scope. */

        /**
         * Returns language selection to its enclosing scope.
         */
        ~LanguageState() { LanguageCode = previous_language; }
    } language_state;
    namespace fs = std::filesystem;
    const auto root = fs::temp_directory_path() /
                      ("menu_read_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    fs::create_directories(root / "menu" / "1");
    const std::string first(17, 'A');
    const std::string second(33, 'B');
    std::ofstream(root / "menu" / "1" / "first.bin", std::ios::binary) << first;
    std::ofstream(root / "menu" / "1" / "second.bin", std::ios::binary) << second;
    DataReadIndex(root);
    LanguageCode = LANG_ENGLISH;
    std::vector<u_long128> storage(512);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    auto *base = reinterpret_cast<char *>(memory.stGetTop());
    char  first_name[] = "first.bin";
    char  second_name[] = "second.bin";
    char *names[] = {first_name, second_name, nullptr};

    EXPECT_EQ(MenuCommonReadData(&memory, names, MENU_FILE_LOAD_DIRECT), 50);
    EXPECT_EQ(std::string(base, first.size()), first);
    EXPECT_EQ(std::string(base + 64, second.size()), second);
    EXPECT_EQ(memory.stack_used, 8);
    PathsReset();
    std::error_code error;
    fs::remove_all(root, error);
}
