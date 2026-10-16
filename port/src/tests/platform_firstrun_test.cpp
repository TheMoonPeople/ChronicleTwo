#include <gtest/gtest.h>

#include <chrono>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>

#include "exitcodes.hpp"
#include "kazarov/data_version.hpp"
#include "platform/firstrun.hpp"
#include "platform/paths.hpp"

namespace fs = std::filesystem;

namespace {

class PlatformFirstRun : public testing::Test {
protected:
    void SetUp() override {
        base_ = fs::temp_directory_path() /
                ("firstrun_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        fs::create_directories(base_);
    }

    void TearDown() override {
        std::error_code error;
        fs::remove_all(base_, error);
    }

    fs::path Root() const { return base_ / "data"; }

    fs::path base_;
};

} // namespace

TEST_F(PlatformFirstRun, MissingRootIsMissing) {
    EXPECT_TRUE(FirstRunDataMissing(base_ / "absent"));
}

TEST_F(PlatformFirstRun, EmptyDirectoryIsMissing) {
    fs::create_directories(Root());
    EXPECT_TRUE(FirstRunDataMissing(Root()));
}

TEST_F(PlatformFirstRun, ManifestDirectoryIsMissing) {
    fs::create_directories(Root() / "manifest.json");
    EXPECT_TRUE(FirstRunDataMissing(Root()));
}

TEST_F(PlatformFirstRun, RegularFileRootIsMissing) {
    std::ofstream(Root(), std::ios::binary) << "not a directory";
    EXPECT_TRUE(FirstRunDataMissing(Root()));
}

TEST_F(PlatformFirstRun, NativeAssetDirectoryAndMarkerNeedNoManifest) {
    fs::create_directories(Root());
    fs::create_directories(base_ / "port_data");
    std::ofstream(base_ / "data.json", std::ios::binary)
        << "{\"schema_version\":1,\"data_version\":" << KAZAROV_DATA_VERSION << "}";
    EXPECT_FALSE(FirstRunDataMissing(Root()));
}

TEST_F(PlatformFirstRun, MissingConvertedAssetDirectoryRequiresExtraction) {
    fs::create_directories(Root());
    std::ofstream(Root() / "manifest.json", std::ios::binary) << "{\"schema_version\":1,\"files\":{}}";
    std::ofstream(base_ / "data.json", std::ios::binary)
        << "{\"schema_version\":1,\"data_version\":" << KAZAROV_DATA_VERSION << "}";
    EXPECT_TRUE(FirstRunDataMissing(Root()));
}

TEST_F(PlatformFirstRun, MissingOrOldRootMarkerRequiresExtraction) {
    fs::create_directories(Root());
    fs::create_directories(base_ / "port_data");
    std::ofstream(Root() / "manifest.json", std::ios::binary) << "{\"schema_version\":1,\"files\":{}}";
    std::ofstream(base_ / "port_data" / "manifest.json", std::ios::binary)
        << "{\"schema_version\":1,\"files\":{}}";
    EXPECT_TRUE(FirstRunDataMissing(Root()));
    std::ofstream(base_ / "data.json", std::ios::binary)
        << "{\"schema_version\":1,\"data_version\":" << KAZAROV_DATA_VERSION + 1 << "}";
    EXPECT_TRUE(FirstRunDataMissing(Root()));
    std::ofstream(base_ / "data.json", std::ios::binary) << "not json";
    EXPECT_TRUE(FirstRunDataMissing(Root()));
}

TEST_F(PlatformFirstRun, MessageNamesRootAndExtractionCommand) {
    const std::string message = FirstRunDataMessage(Root());
    EXPECT_NE(message.find(PathsDisplay(Root())), std::string::npos) << message;
    EXPECT_NE(message.find("dc2data extract"), std::string::npos) << message;
    EXPECT_NE(message.find("DATA.HD4"), std::string::npos) << message;
}

#ifndef _WIN32
TEST_F(PlatformFirstRun, MessageInsideTheFlatpakNamesItsCommand) {
    EXPECT_EQ(FirstRunDataMessage(Root()).find("flatpak run"), std::string::npos);
    ASSERT_EQ(setenv("FLATPAK_ID", "org.themoonpeople.ChronicleTwo", 1), 0);
    const std::string message = FirstRunDataMessage(Root());
    EXPECT_EQ(unsetenv("FLATPAK_ID"), 0);
    EXPECT_NE(message.find("--command=dc2data org.themoonpeople.ChronicleTwo extract <disc image> " + PathsDisplay(Root())),
              std::string::npos)
        << message;
}
#endif

TEST_F(PlatformFirstRun, MissingDataExitsWithNoDataAndNamesTheCommand) {
    EXPECT_EXIT(FirstRunRequireData(base_ / "absent", /*headless=*/true), testing::ExitedWithCode(kExitNoData),
                "dc2data extract");
}

TEST_F(PlatformFirstRun, PresentDataReturns) {
    fs::create_directories(Root());
    fs::create_directories(base_ / "port_data");
    std::ofstream(Root() / "manifest.json", std::ios::binary) << "{\"schema_version\":1,\"files\":{}}";
    std::ofstream(base_ / "port_data" / "manifest.json", std::ios::binary)
        << "{\"schema_version\":1,\"files\":{}}";
    std::ofstream(base_ / "data.json", std::ios::binary)
        << "{\"schema_version\":1,\"data_version\":" << KAZAROV_DATA_VERSION << "}";
    FirstRunRequireData(Root(), /*headless=*/true);
}
