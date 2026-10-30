#include <gtest/gtest.h>

#include <memory>

#include "dng_main.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "runscript.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#include "vector_scratch_probes.hpp"

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

int _SCN_GET_CHR_POS(dc2::script::RunArguments, int);
int _SCN_GET_CHR_ROT(dc2::script::RunArguments, int);
int _SCN_GET_ENTRY_OBJ_POS(dc2::script::RunArguments, int);
int _SCN_GET_CHR_ENTOBJ_POS(dc2::script::RunArguments, int);
int _GET_EOH_POS(dc2::script::RunArguments, int);

TEST(EffectVector, CharacterGettersAndMissingEntryFallbackPreserveCoordinates) {
    auto  scene = std::make_unique<CScene>();
    auto  character_owner = std::make_shared<CCharacter2>();
    auto &character = *character_owner;
    character.SetPosition(3, 4, 12);
    character.SetRotation(0.25f, 0.5f, 0.75f);
    for (auto &entry : character.entry_frame) {
        entry = nullptr;
    }
    auto *previous = now_scene;
    now_scene = scene.get();
    scene->chara_num = 1;
    scene->chara[0].status = SCENE_DATA_ASSIGNED;
    scene->chara[0].AssignData(dc2::scene::CharacterResource::FromOwned(character_owner), "effect");
    for (auto callback : {_SCN_GET_CHR_POS, _SCN_GET_CHR_ROT}) {
        RS_STACKDATA outputs[] = {Number(-1), Number(-1), Number(-1)};
        RS_STACKDATA args[] = {Integer(0), Reference(outputs[0]), Reference(outputs[1]), Reference(outputs[2])};
        EXPECT_EQ(callback(dc2::script::RunArguments(args, {}, outputs), 4), 1);
        EXPECT_FLOAT_EQ(outputs[0].val.f, callback == _SCN_GET_CHR_POS ? 3 : 0.25f);
        EXPECT_FLOAT_EQ(outputs[2].val.f, callback == _SCN_GET_CHR_POS ? 12 : 0.75f);
    }
    for (auto callback : {_SCN_GET_ENTRY_OBJ_POS, _SCN_GET_CHR_ENTOBJ_POS}) {
        RS_STACKDATA outputs[] = {Number(-1), Number(-1), Number(-1)};
        RS_STACKDATA args[] = {Integer(0), Integer(0), Reference(outputs[0]), Reference(outputs[1]), Reference(outputs[2])};
        EXPECT_EQ(callback(dc2::script::RunArguments(args, {}, outputs), 5), 1);
        EXPECT_FLOAT_EQ(outputs[0].val.f, 3);
        EXPECT_FLOAT_EQ(outputs[2].val.f, 12);
    }
    now_scene = previous;
}

TEST(EffectVector, HandleGetterPreservesCoordinates) {
    mgCFrame frame;
    frame.SetPosition(3, 4, 12);
    ASSERT_TRUE(EventObjHandleMother.Set(0, EOH_TYPE_FRAME, &frame));
    RS_STACKDATA outputs[] = {Number(-1), Number(-1), Number(-1)};
    RS_STACKDATA args[] = {Integer(0), Reference(outputs[0]), Reference(outputs[1]), Reference(outputs[2])};
    EXPECT_EQ(_GET_EOH_POS(dc2::script::RunArguments(args, {}, outputs), 4), 1);
    EXPECT_FLOAT_EQ(outputs[0].val.f, 3);
    EXPECT_FLOAT_EQ(outputs[2].val.f, 12);
}

TEST(EffectVector, ActualScratchDeclarationsHoldEveryWrittenLane) {
    EXPECT_TRUE(VectorScratchProbe::Effect);
}

TEST(EffectVector, InvalidLaterReferenceCannotPartiallyWriteVectorOutputs) {
    RS_STACKDATA outputs[] = {Number(-1), Number(-2), Number(-3)};
    RS_STACKDATA outside = Number(-4);
    RS_STACKDATA args[] = {Integer(0), Reference(outputs[0]), Reference(outside), Reference(outputs[2])};
    EXPECT_THROW(_GET_EOH_POS(dc2::script::RunArguments(args, {}, outputs), 4), dc2::script::ArgumentError);
    EXPECT_FLOAT_EQ(outputs[0].val.f, -1);
    EXPECT_FLOAT_EQ(outputs[1].val.f, -2);
    EXPECT_FLOAT_EQ(outputs[2].val.f, -3);
    EXPECT_FLOAT_EQ(outside.val.f, -4);
}
