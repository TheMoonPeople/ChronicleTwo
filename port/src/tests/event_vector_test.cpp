#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <memory>

#include "dng_main.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "menumain.hpp"
#include "native_script_program.hpp"
#include "nd_meswin.hpp"
#include "runscript.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#include "scoped_global_object.hpp"
#include "stubs/event.hpp"
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

TEST(EventVector, HandleGettersReturnAllCoordinates) {
    CRunScript script;
    SetEventFunc(&script);
    mgCFrame frame;
    frame.SetPosition(3, 4, 12);
    frame.SetRotation(0.25f, 0.5f, 0.75f);
    ASSERT_TRUE(EventObjHandleMother.Set(0, EOH_TYPE_FRAME, &frame));
    for (int callback : {EVENT_EXT_EOH_GET_POS, EVENT_EXT_EOH_GET_ROT}) {
        RS_STACKDATA outputs[3] = {Number(-1), Number(-1), Number(-1)};
        RS_STACKDATA args[] = {Integer(0), Reference(outputs[0]), Reference(outputs[1]), Reference(outputs[2])};
        ASSERT_EQ(InvokeNativeExternal(script.ext_func_table[callback], std::span(args).first(4), outputs), 1);
        EXPECT_FLOAT_EQ(outputs[0].val.f, callback == EVENT_EXT_EOH_GET_POS ? 3 : 0.25f);
        EXPECT_FLOAT_EQ(outputs[1].val.f, callback == EVENT_EXT_EOH_GET_POS ? 4 : 0.5f);
        EXPECT_FLOAT_EQ(outputs[2].val.f, callback == EVENT_EXT_EOH_GET_POS ? 12 : 0.75f);
    }
}

TEST(EventVector, RandomCircleReturnsAllCoordinates) {
    CRunScript script;
    SetEventFunc(&script);
    RandomCircle.pos[0][0] = 3;
    RandomCircle.pos[0][1] = 4;
    RandomCircle.pos[0][2] = 12;
    RandomCircle.pos[0][3] = 1;
    RS_STACKDATA outputs[3] = {Number(-1), Number(-1), Number(-1)};
    RS_STACKDATA args[] = {Integer(0), Reference(outputs[0]), Reference(outputs[1]), Reference(outputs[2])};
    ASSERT_EQ(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_RANDOM_CIRCLE_GET_POS], std::span(args).first(4), outputs), 1);
    EXPECT_FLOAT_EQ(outputs[0].val.f, 3);
    EXPECT_FLOAT_EQ(outputs[1].val.f, 4);
    EXPECT_FLOAT_EQ(outputs[2].val.f, 12);
}

TEST(EventVector, TreasurePositionIsDecodedBeforeMissingManagerReturns) {
    auto  scene = std::make_unique<CScene>();
    auto *previous = EventScene;
    EventScene = scene.get();
    scene->battle_area.treasure_box = nullptr;
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA args[] = {Number(3), Number(4), Number(12), Number(0), Integer(0)};
    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_POST_TREASURE_BOX], std::span(args).first(5)), 0);
    EventScene = previous;
}

TEST(EventVector, FadeColorRejectsMissingOrMistypedComponentsBeforeUsingScene) {
    CRunScript script;
    SetEventFunc(&script);
    const auto callback = script.ext_func_table[EVENT_EXT_SET_FADE_IN];
    ASSERT_NE(callback, nullptr);
    RS_STACKDATA arguments[] = {Integer(12), Number(0.25f), Number(0.5f), Number(0.75f)};
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(arguments).first(2)), 0);
    arguments[2].type = RS_STR;
    arguments[2].val.s = nullptr;
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(arguments).first(4)), 0);
}

TEST(EventVector, PadOutputRejectsAReferenceWithoutInvocationOwnedSlots) {
    CRunScript script;
    SetEventFunc(&script);
    const auto callback = script.ext_func_table[EVENT_EXT_GET_PADON];
    ASSERT_NE(callback, nullptr);
    RS_STACKDATA output = Integer(-1);
    RS_STACKDATA reference = Reference(output);
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(&reference, 1)), 0);
    EXPECT_EQ(output.val.i, -1);
}

TEST(EventVector, ActualScratchDeclarationsHoldEveryWrittenLane) {
    EXPECT_TRUE(VectorScratchProbe::Event);
}

TEST(EventMessageArguments, ValueSlotsRequireThreeTypedArgumentsAndStayWithinTheMessageArray) {
    auto   scene = std::make_unique<CScene>();
    ClsMes message;
    scene->message_num = 1;
    ASSERT_EQ(scene->AssignMessage(0, &message, nullptr), 0);

    CRunScript script;
    SetEventFunc(&script);
    const auto callback = script.ext_func_table[EVENT_EXT_SET_MES_VALUE];
    ASSERT_NE(callback, nullptr);

    auto *previous_scene = EventScene;
    EventScene = scene.get();
    const int    prior_value = message.values[MES_VALUE_MAX - 1];
    RS_STACKDATA args[] = {Integer(0), Integer(MES_VALUE_MAX), Integer(123)};
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(args).first(2)), 0);
    EXPECT_EQ(message.values[MES_VALUE_MAX - 1], prior_value);
    args[1].type = RS_STR;
    args[1].val.s = nullptr;
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(args).first(3)), 0);
    args[1] = Integer(MES_VALUE_MAX + 1);
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(args).first(3)), 0);
    args[1] = Integer(-1);
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(args).first(3)), 0);
    args[1] = Integer(MES_VALUE_MAX);
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(args).first(3)), 1);
    EXPECT_EQ(message.values[MES_VALUE_MAX - 1], 123);
    EventScene = previous_scene;
}

TEST(EventMessageArguments, PartyMessageRejectsMissingOrForgedOutputBeforeLookup) {
    CRunScript script;
    SetEventFunc(&script);
    const auto callback = script.ext_func_table[EVENT_EXT_GET_PARTY_CHARA_MES_NO];
    ASSERT_NE(callback, nullptr);
    RS_STACKDATA output = Integer(-1);
    RS_STACKDATA args[] = {Integer(0), Integer(0), Integer(0)};
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(args).first(2)), 0);
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(args).first(3)), 0);
    args[2] = Reference(output);
    EXPECT_EQ(InvokeNativeExternal(callback, std::span(args).first(3)), 0);
    EXPECT_EQ(output.val.i, -1);
}

TEST(EventVector, CopyValidatesEveryOutputBeforeWritingAnyComponent) {
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA outputs[] = {Number(-1), Number(-2), Number(-3)};
    RS_STACKDATA forged = Number(-4);
    RS_STACKDATA args[] = {Integer(EVENT_EXT_COPY_VECTOR), Reference(outputs[0]), Reference(outputs[1]),
                           Reference(forged), Number(3), Number(4), Number(12)};
    script.ext(args, {}, outputs);
    EXPECT_FLOAT_EQ(outputs[0].val.f, -1);
    EXPECT_FLOAT_EQ(outputs[1].val.f, -2);
    EXPECT_FLOAT_EQ(outputs[2].val.f, -3);
    EXPECT_FLOAT_EQ(forged.val.f, -4);
    args[3] = Reference(outputs[2]);
    script.ext(args, {}, outputs);
    EXPECT_FLOAT_EQ(outputs[0].val.f, 3);
    EXPECT_FLOAT_EQ(outputs[1].val.f, 4);
    EXPECT_FLOAT_EQ(outputs[2].val.f, 12);
}

TEST(EventVector, ArithmeticRejectsMistypedVariablesWithoutPartialWrites) {
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA outputs[] = {Number(3), Integer(4), Number(12)};
    RS_STACKDATA args[] = {Integer(EVENT_EXT_ADD_VECTOR), Reference(outputs[0]), Reference(outputs[1]),
                           Reference(outputs[2]), Number(1), Number(2), Number(3)};
    script.ext(args, {}, outputs);
    EXPECT_FLOAT_EQ(outputs[0].val.f, 3);
    EXPECT_EQ(outputs[1].type, RS_INT);
    EXPECT_EQ(outputs[1].val.i, 4);
    EXPECT_FLOAT_EQ(outputs[2].val.f, 12);
}

TEST(EventVector, RetainedArgumentVectorRejectsMissingComponentsBeforeWritingDestination) {
    ARG_DATA values[] = {
        {.type = RS_FLOAT, .f = 3.0f},
        {.type = RS_FLOAT, .f = 4.0f}
    };
    float destination[] = {-1, -2, -3, -4};
    EXPECT_THROW(GetArgVector(destination, dc2::script::EventArguments(values)), dc2::script::ArgumentError);
    EXPECT_FLOAT_EQ(destination[0], -1);
    EXPECT_FLOAT_EQ(destination[1], -2);
    EXPECT_FLOAT_EQ(destination[2], -3);
    EXPECT_FLOAT_EQ(destination[3], -4);
}

TEST(EventVector, RetainedArgumentListsRejectAnExtentOutsideTheirAllocationAndReleasedStorage) {
    alignas(16) std::array<u_long128, 32> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *list = dc2::memory::NewObject<ARG_LIST>(memory);
    auto *value = dc2::memory::NewObject<ARG_DATA>(memory);
    ASSERT_NE(list, nullptr);
    ASSERT_NE(value, nullptr);
    *list = {.id = 7, .args = value, .arg_num = 100, .next = nullptr};
    *value = {.type = RS_INT, .i = 0};
    const auto previous = EventScriptArg;
    EventScriptArg.memory = &memory;
    EventScriptArg.list = list;
    EventScriptArg.list_storage = dc2::memory::ArenaBuffer::Bind(memory, {reinterpret_cast<u8 *>(list), sizeof(*list)});
    EventScriptArg.list_num = 1;
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA arguments[] = {Integer(7)};
    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_EOH_SET_POS], arguments), 0);
    list->arg_num = 1;
    memory.stClearUsed();
    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_EOH_SET_POS], arguments), 0);
    EventScriptArg = previous;
}

TEST(EventVector, InvocationBoundaryRejectsMalformedTextDuringSemanticGuardEvaluation) {
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA argument{};
    argument.type = RS_STR;
    argument.val.s = reinterpret_cast<char *>(std::uintptr_t{1});
    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_LOAD_SCRIPT], std::span(&argument, 1)), 0);
}

TEST(EventVector, InvocationBoundaryRejectsMissingArgumentsDuringHandlerExecution) {
    CRunScript script;
    SetEventFunc(&script);
    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_PAUSE_ENABLE_FLAG], {}), 0);
}

TEST(EventScreenStorage, CaptureRefusesAReleasedImageLeaseBeforeCallingTheRenderer) {
    alignas(16) std::array<u_long128, 16> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *pixels = memory.Alloc(1);
    ASSERT_NE(pixels, nullptr);
    auto       lease = dc2::memory::ArenaBuffer::Bind(memory, {reinterpret_cast<u8 *>(pixels), sizeof(u_long128)});
    mgCTexture texture;
    texture.width = 2;
    texture.height = 2;
    texture.bpp = 32;
    CScreenEffect effect;
    effect.SetSepiaTexture(&texture, lease);
    ASSERT_EQ(effect.sepia_texture, &texture);
    effect.SetSepiaFlag(1);
    memory.stClearUsed();
    effect.CaptureSepiaScreen();
    EXPECT_EQ(effect.sepia, 0);
    EXPECT_TRUE(effect.sepia_image.Bytes().empty());
}

TEST(EventScreenStorage, TextureSetterRejectsAnImageSmallerThanItsRgbaExtent) {
    alignas(16) std::array<u_long128, 16> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *pixels = memory.Alloc(1);
    ASSERT_NE(pixels, nullptr);
    auto       lease = dc2::memory::ArenaBuffer::Bind(memory, {reinterpret_cast<u8 *>(pixels), sizeof(u_long128) - 1});
    mgCTexture texture;
    texture.width = 2;
    texture.height = 2;
    texture.bpp = 32;
    CScreenEffect effect;
    effect.SetSepiaTexture(&texture, lease);
    EXPECT_EQ(effect.sepia_texture, nullptr);
}

TEST(EventVector, ItemMenuCannotRetainAnInvocationOnlyOutputSlot) {
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA output = Integer(-1);
    RS_STACKDATA arguments[] = {Reference(output), Integer(376)};
    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_GOTO_USE_ITEM], arguments, std::span(&output, 1)), 0);
    EXPECT_EQ(output.val.i, -1);
}

TEST(EventVector, DeferredNativeMenuResultUsesOnlyTheCurrentEventProgramGeneration) {
    const auto          previous_menu = MenuArg;
    const auto          previous_mode = EdEventInfo.command_mode;
    NativeScriptProgram program;
    program.header.global_num = 1;
    mgCMemory memory;
    SetEventScript(program.Bytes(), &memory);
    ASSERT_NE(EventScript.global, nullptr);
    EventScript.global[0] = Integer(-1);
    RS_STACKDATA arguments[] = {Integer(EVENT_EXT_GOTO_USE_ITEM), Reference(EventScript.global[0]), Integer(376)};
    EventScript.ext(arguments);
    EXPECT_EQ(EventScript.global[0].val.i, -1);
    MenuArg.result[0] = 376;
    EdEventMenuExit();
    EXPECT_EQ(EventScript.global[0].val.i, 376);

    EventScript.ext(arguments);
    SetEventScript(program.Bytes(), &memory);
    EventScript.global[0] = Integer(-9);
    MenuArg.result[0] = 7;
    EdEventMenuExit();
    EXPECT_EQ(EventScript.global[0].val.i, -9);
    SetEventScript({}, nullptr);
    MenuArg = previous_menu;
    EdEventInfo.command_mode = previous_mode;
}

TEST(EventVector, SwordTrailCallbacksValidateTheControllerLeaseBeforeAnyFieldAccess) {
    std::array<u_long128, 1024> storage{};
    mgCMemory                   memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    dc2::test::ScopedGlobalObject<EventScene> scene;
    scene->SetStack(0, &memory);
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA create[] = {Integer(0), Integer(8), Integer(2)};
    ASSERT_TRUE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_CREATE_SWORD_EFFECT], create));
    RS_STACKDATA colors[] = {Integer(1), Integer(2), Integer(3), Integer(4), Integer(5), Integer(6), Integer(7), Integer(8)};
    EXPECT_TRUE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_SWORD_EFFECT_COLOR], colors));
    create[1] = Integer(0);
    EXPECT_FALSE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_CREATE_SWORD_EFFECT], create));
    EXPECT_TRUE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_SWORD_EFFECT_COLOR], colors));
    memory.stClearUsed();
    auto bytes = dc2::memory::RemainingBytes(memory);
    ASSERT_FALSE(bytes.empty());
    std::memset(bytes.data(), 0xA5, bytes.size());
    EXPECT_FALSE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_SWORD_EFFECT_COLOR], colors));
    RS_STACKDATA point[] = {Number(1), Number(2), Number(3), Number(4), Number(5), Number(6)};
    EXPECT_TRUE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_SWORD_EFFECT_ADD_POINT], point));
    for (std::size_t index = 0; index < bytes.size(); ++index) {
        ASSERT_EQ(bytes[index], 0xA5) << index;
    }
    EXPECT_TRUE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_DELETE_SWORD_EFFECT], std::span<RS_STACKDATA>{}));
}

TEST(EventVector, EventEffectManagerRejectsARetiredControllerBeforeTraversingItsPrograms) {
    std::array<u_long128, 2048> storage{};
    mgCMemory                   memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    dc2::test::ScopedGlobalObject<EventScene> scene;
    scene->SetStack(0, &memory);
    scene->event_texb = 0;
    scene->event_texb_num = 0;
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA create[] = {Integer(0)};
    ASSERT_TRUE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_ESM_INITIALIZE], create));
    memory.stClearUsed();
    auto bytes = dc2::memory::RemainingBytes(memory);
    ASSERT_FALSE(bytes.empty());
    std::memset(bytes.data(), 0xA5, bytes.size());
    EXPECT_FALSE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_ESM_CLEAR], std::span<RS_STACKDATA>{}));
    for (std::size_t index = 0; index < bytes.size(); ++index) {
        ASSERT_EQ(bytes[index], 0xA5) << index;
    }
}
