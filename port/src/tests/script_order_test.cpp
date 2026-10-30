#include <gtest/gtest.h>

#include <array>

#include "event_func.hpp"
#include "log_capture.hpp"
#include "native_script_program.hpp"
#include "runscript.hpp"

TEST(ScriptOrder, VoiceClipUsesItsOwnArgumentAndDirectWavePath) {
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA args[3] = {};
    args[0].type = RS_INT;
    args[0].val.i = 0;
    args[1].type = RS_STR;
    char voice_group[] = "abc123";
    args[1].val.s = voice_group;
    args[2].type = RS_STR;
    char voice_clip[] = "clip456";
    args[2].val.s = voice_clip;
    CaptureLoggedStderr();
    const std::array<std::span<const char>, 1> other_text{std::span<const char>(voice_group)};
    InvokeNativeExternal(script.ext_func_table[EVENT_EXT_STREAM_OPEN], args, {}, voice_clip, other_text);
    const std::string output = GetLoggedStderr();
    EXPECT_NE(output.find("sound/clip456.wav"), std::string::npos);
    EXPECT_EQ(output.find("abc123"), std::string::npos);
    EXPECT_EQ(output.find(".VPK"), std::string::npos);
    EXPECT_EQ(args[1].val.s, std::string("abc123"));
    EXPECT_EQ(args[2].val.s, std::string("clip456"));
}
