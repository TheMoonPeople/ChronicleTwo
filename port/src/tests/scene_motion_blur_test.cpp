#include <gtest/gtest.h>

#include <cstddef>
#include <cstring>

#include "event.hpp"
#include "event_func.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "native_script_program.hpp"
#include "runscript.hpp"
#include "scenesnd.hpp"

namespace {
struct BlurProgram {
    RS_PROG_HEADER header{};
    RS_PROGDATA    entry{.no = 100, .func = offsetof(BlurProgram, function)};
    funcdata       function{};
    vmcode_t       code[4]{
        {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = EVENT_EXT_SET_MOTION_BLUR},
        {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = 100                      },
        {.op = RS_OP_EXT,        .arg1 = 2,            .arg2 = 0                        },
        {.op = RS_OP_END,        .arg1 = 0,            .arg2 = 0                        }
    };

    BlurProgram() {
        std::memcpy(header.magic, "SB2", 3);
        header.main = offsetof(BlurProgram, function);
        header.code = offsetof(BlurProgram, code);
        header.prog = offsetof(BlurProgram, entry);
        header.prog_num = 1;
    }
};
} // namespace

TEST(SceneMotionBlur, MotionBlurUsesTheConstructedFadeWithoutChangingTheCaptureTexture) {
    CScene     scene;
    mgCTexture capture{};
    scene.fade.cross_texture = &capture;
    scene.fade.blur_alpha = 100;
    EXPECT_EQ(scene.fade.blur_alpha, 100);
    EXPECT_EQ(scene.fade.cross_texture, &capture);
}

TEST(SceneMotionBlur, EventExternalPreservesItsExistingCrossfadeTexture) {
    CScene     scene;
    mgCTexture capture{};
    scene.fade.cross_texture = &capture;
    alignas(64) u_long128 storage[1024]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 1024);
    BlurProgram program;
    SetEventScript(ProgramBytes(program), &memory);
    EXPECT_EQ(RunEvent(100, &scene), 0);
    EXPECT_EQ(scene.fade.blur_alpha, 100);
    EXPECT_EQ(scene.fade.cross_texture, &capture);
    SetEventScript({}, nullptr);
    EventScene = nullptr;
}
