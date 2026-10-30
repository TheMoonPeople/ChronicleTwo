#include <gtest/gtest.h>

#include <filesystem>
#include <fstream>
#include <iterator>
#include <limits>
#include <vector>

#include "gamepad.hpp"
#include "platform/paths.hpp"
#include "platform_fixture.hpp"

namespace {
class PadCapture : public testing::Test {
protected:
    void SetUp() override {
        root = std::filesystem::temp_directory_path() /
               ("dc2_pad_capture_" + std::to_string(dc::test::ProcessId()));
        std::filesystem::remove_all(root);
        PathsConfigure({.app_dir = "dc2-pad-test", .env_data = "DC2_PAD_TEST_DATA", .env_save = "DC2_PAD_TEST_SAVE"});
        PathsSetSaveRoot(root);
        pad.CaptureStart();
    }

    void TearDown() override { std::filesystem::remove_all(root); }

    std::filesystem::path root;
    CGamePad              pad{};
};
} // namespace

TEST_F(PadCapture, RecordingRoundTripsUnderSaveRootAndStopsAtEnd) {
    PAD_STATUS input{};
    input.button = 0x1234;
    input.left_y = 1;
    input.left_x = 2;
    input.right_y = 3;
    input.right_x = 4;
    pad.Capture(&input);
    input.button = 0xABCD;
    pad.Capture(&input);
    pad.SaveCapture();
    std::ifstream                    file(root / "key_cap.bin", std::ios::binary);
    const std::vector<unsigned char> bytes{std::istreambuf_iterator<char>(file), {}};
    EXPECT_EQ(bytes, (std::vector<unsigned char>{0x34, 0x12, 1, 2, 3, 4, 0xCD, 0xAB, 1, 2, 3, 4}));
    pad.CaptureStart();
    pad.LoadCapture();
    pad.CapturePlay();
    PAD_STATUS output{};
    output.phase = PAD_PHASE_QUERY;
    pad.Play(&output);
    EXPECT_EQ(output.button, 0x1234);
    EXPECT_EQ(output.left_x, 2);
    EXPECT_EQ(output.right_y, 3);
    EXPECT_EQ(output.phase, PAD_PHASE_QUERY);
    pad.Play(&output);
    EXPECT_EQ(output.button, 0xABCD);
    pad.Play(&output);
    EXPECT_EQ(output.button, 0);
    EXPECT_EQ(output.left_x, 128);
    EXPECT_EQ(pad.capture_mode, PAD_CAPTURE_OFF);
    pad.CapturePlay();
    pad.Play(&output);
    EXPECT_EQ(output.button, 0x1234);
}

TEST_F(PadCapture, StartingANewRecordingDiscardsTheOldTail) {
    PAD_STATUS input{};
    pad.Capture(&input);
    pad.Capture(&input);
    pad.CaptureStart();
    input.button = 0x4000;
    pad.Capture(&input);
    pad.SaveCapture();
    EXPECT_EQ(std::filesystem::file_size(root / "key_cap.bin"), 6u);
    pad.capture_frame = PAD_CAPTURE_FRAME_MAX;
    pad.Capture(&input);
    EXPECT_EQ(pad.capture_frame, PAD_CAPTURE_FRAME_MAX);
}

TEST_F(PadCapture, MissingAndPartialFilesCannotReplayStaleFrames) {
    PAD_STATUS input{};
    input.button = 1;
    pad.Capture(&input);
    pad.LoadCapture();
    pad.CapturePlay();
    pad.Play(&input);
    EXPECT_EQ(input.button, 0);
    EXPECT_EQ(pad.capture_mode, PAD_CAPTURE_OFF);
    std::filesystem::create_directories(root);
    std::ofstream(root / "key_cap.bin", std::ios::binary).write("bad", 3);
    pad.LoadCapture();
    pad.CapturePlay();
    input.button = 1;
    pad.Play(&input);
    EXPECT_EQ(input.button, 0);
    EXPECT_EQ(pad.capture_mode, PAD_CAPTURE_OFF);
}

TEST(PadCaptureOwnership, IndependentControllersKeepIndependentRecordings) {
    CGamePad   first;
    CGamePad   second;
    PAD_STATUS input{};
    input.button = PAD_CROSS;
    first.CaptureStart();
    first.Capture(&input);
    input.button = PAD_CIRCLE;
    second.CaptureStart();
    second.Capture(&input);
    PAD_STATUS output{};
    first.CapturePlay();
    first.Play(&output);
    EXPECT_EQ(output.button, PAD_CROSS);
    second.CapturePlay();
    second.Play(&output);
    EXPECT_EQ(output.button, PAD_CIRCLE);
}

TEST(PadCaptureOwnership, MalformedAxesAreClampedBeforeEncoding) {
    CGamePad   controller;
    PAD_STATUS input{};
    input.left_x = std::numeric_limits<int>::min();
    input.left_y = std::numeric_limits<int>::max();
    input.right_x = -1;
    input.right_y = 256;
    controller.CaptureStart();
    controller.Capture(&input);
    controller.CapturePlay();
    PAD_STATUS output{};
    controller.Play(&output);
    EXPECT_EQ(output.left_x, 0);
    EXPECT_EQ(output.left_y, 255);
    EXPECT_EQ(output.right_x, 0);
    EXPECT_EQ(output.right_y, 255);
}
