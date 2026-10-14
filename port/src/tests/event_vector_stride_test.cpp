#include <gtest/gtest.h>

#include <cstring>
#include <memory>

#include "dng_main.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "mg_memory.hpp"
#include "runscript.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#include "stubs/event.hpp"

namespace {
RS_STACKDATA Number(float value) {
    RS_STACKDATA s{};
    s.type = RS_FLOAT;
    s.val.f = value;
    return s;
}

RS_STACKDATA Integer(int value) {
    RS_STACKDATA s{};
    s.type = RS_INT;
    s.val.i = value;
    return s;
}

RS_STACKDATA Reference(RS_STACKDATA &value) {
    RS_STACKDATA s{};
    s.type = RS_PTR;
    s.val.p = &value;
    return s;
}
} // namespace

namespace {
class EventVectorStride : public testing::Test {
protected:
    void SetUp() override {
        std::memcpy(program.magic, "SB2", 3);
        memory.stSetBuffer(storage, 512);
        SetEventScript(reinterpret_cast<char *>(&program), nullptr, &memory);
    }

    void TearDown() override { SetEventScript(nullptr, nullptr, nullptr); }

    alignas(64) u_long128 storage[512] {};
    mgCMemory      memory;
    RS_PROG_HEADER program{};
};
} // namespace

TEST_F(EventVectorStride, DistanceOutputsUseNativeStackElements) {
    auto        &script = EventScript;
    RS_STACKDATA output = Number(-123);
    RS_STACKDATA args[] = {Number(3), Number(4), Number(12), Reference(output)};
    ASSERT_EQ(script.ext_func_table[EVENT_EXT_DIST_VECTOR](args, 4), 1);
    EXPECT_FLOAT_EQ(output.val.f, 13);
    output = Number(-123);
    RS_STACKDATA pair[] = {Number(0), Number(0), Number(0), Number(3), Number(4), Number(12), Reference(output)};
    ASSERT_EQ(script.ext_func_table[EVENT_EXT_DIST_VECTOR2](pair, 7), 1);
    EXPECT_FLOAT_EQ(output.val.f, 13);
    EXPECT_FLOAT_EQ(pair[3].val.f, 3);
}

TEST_F(EventVectorStride, AttributeOutputFollowsThreeInputs) {
    auto &script = EventScript;
    auto  previous = AutoMapGen.grid;
    AutoMapGen.grid = nullptr;
    RS_STACKDATA output = Integer(-123);
    RS_STACKDATA args[] = {Number(3), Number(4), Number(12), Reference(output)};
    EXPECT_EQ(script.ext_func_table[EVENT_EXT_AMG_GET_ATTR_STATUS](args, 4), 1);
    EXPECT_EQ(output.type, RS_INT);
    EXPECT_EQ(output.val.i, 0);
    AutoMapGen.grid = previous;
}

TEST_F(EventVectorStride, FrameCountFollowsOffsetVector) {
    auto        &script = EventScript;
    _SEN_OBJ_SEQ nodes[4]{};
    ObjectSeq[0].Initialize(nodes, 4);
    RS_STACKDATA name{};
    name.type = RS_STR;
    name.val.s = const_cast<char *>("root");
    RS_STACKDATA args[] = {Integer(0), Integer(2), name, Number(3), Number(4), Number(12), Integer(60)};
    ASSERT_EQ(script.ext_func_table[EVENT_EXT_OBJS_SET_EOH_FRAME_POS](args, 7), 1);
    ASSERT_NE(ObjectSeq[0].pos_last, nullptr);
    // Native NTSC timing keeps the supplied frame count instead of scaling it to PAL.
    EXPECT_EQ(ObjectSeq[0].pos_last->sub_frame, 60);
    EXPECT_FLOAT_EQ(ObjectSeq[0].pos_last->vec[0], 3);
    EXPECT_FLOAT_EQ(ObjectSeq[0].pos_last->vec[3], 1);
    ObjectSeq[0].ZeroInitialize();
}
