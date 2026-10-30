#include <gtest/gtest.h>

#include <cstdlib>
#include <filesystem>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

#include "assets/data_registry.hpp"
#include "script_text.hpp"

namespace {

/**
 * Reads a retail asset from either the published archive or an extracted data tree.
 */
std::optional<std::vector<unsigned char>> PublishedFile(std::string_view key) {
    const char *data = std::getenv("DC2_DATA");
    if (!data) {
        return std::nullopt;
    }
    DataReadIndex(std::filesystem::path(data));
    const auto                 file = DataReadFind(std::string(key).c_str());
    std::vector<unsigned char> bytes;
    if (!file || !vfs::Read(*file, bytes)) {
        return std::nullopt;
    }
    return bytes;
}

} // namespace

TEST(ScriptText, KeyIgnoresCaseAndSeparators) {
    EXPECT_EQ(script_text::Edits("EVENT\\E300\\E314\\E314_5.TXT").size(), script_text::Edits("event/e300/e314/e314_5.txt").size());
    EXPECT_TRUE(script_text::Edits("event/e300/e314/e314_4.txt").empty());
    EXPECT_EQ(script_text::Extra("map/s/s17/s17_5.stb"), 0u);
}

TEST(ScriptText, SpanishSphedaLessonTextIsCorrected) {
    constexpr std::string_view key = "event/e300/e314/e314_5.txt";
    std::string                text = "@3140050\r\nNo tienes que acordarte de nada m\xe1s.\r\n@3140055\r\nDe azul a rojo, de negro a azul. "
                                      "As\xed.\r\n@3140080\r\nuna pared o algo y cambiar\xe1 el color a negro.\r\n";
    const std::size_t          size = text.size();
    EXPECT_EQ(script_text::Extra(key), 0u);

    const std::size_t patched = script_text::Patch(key, reinterpret_cast<unsigned char *>(text.data()), size);
    const std::string expected = "@3140050\r\nTienes que acordarte de otra cosa m\xe1s.\r\n@3140055\r\nDe azul a rojo, de rojo a azul. "
                                 "As\xed.\r\n@3140080\r\nuna pared o algo y cambiar\xe1 el color.\r\n";
    ASSERT_EQ(patched, expected.size());
    EXPECT_EQ(text.substr(0, patched), expected);
    EXPECT_EQ(text.find_first_not_of('\0', patched), std::string::npos);
}

TEST(ScriptText, EventTextWithoutTheRetailLinesIsLeftUnchanged) {
    std::string       text = "@3140050\r\nNo tienes que acordarte de nada m\xe1s.\r\n";
    const std::string before = text;
    EXPECT_EQ(script_text::Patch("event/e300/e314/e314_5.txt", reinterpret_cast<unsigned char *>(text.data()), text.size()), text.size());
    EXPECT_EQ(text, before);
}

TEST(ScriptText, ExtractedSpanishSphedaLessonMatches) {
    constexpr std::string_view key = "event/e300/e314/e314_5.txt";
    auto                       file = PublishedFile(key);
    if (!file) {
        GTEST_SKIP() << "DC2_DATA supplies the retail event text";
    }
    auto bytes = std::move(*file);
    EXPECT_EQ(script_text::Patch(key, bytes.data(), bytes.size()), bytes.size() - 7);
}
