#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <memory>
#include <string>
#include <vector>

#include "actionchara.hpp"
#include "actscript.hpp"
#include "dng_main.hpp"
#include "gamepad.hpp"
#include "log_capture.hpp"
#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "native_script_program.hpp"
#include "padcontrol.hpp"
#include "runscript_opcodes.hpp"
#include "scenesnd.hpp"
#include "scoped_global_object.hpp"
#include "swordeffect.hpp"
#include "userdata.hpp"

namespace {
/**
 *
 * Restores borrowed action globals before each fixture controller leaves scope.
 *
 */
struct ActionGlobalScope {
    ACTION_INFO       action = action_info; /**< Action environment before this test. */
    CScene           *scene = nowScene__2;  /**< Previous action scene. */
    CUserDataManager *user = DngUserData;   /**< Previous dungeon user data. */
    CActiveMonster   *monster = nowMonster; /**< Previous monster opcode target. */

    ~ActionGlobalScope() {
        action_info = action;
        nowScene__2 = scene;
        DngUserData = user;
        nowMonster = monster;
    }
};

RS_STACKDATA ScriptInteger(int value) {
    RS_STACKDATA result{};
    result.type = RS_INT;
    result.val.i = value;
    return result;
}

RS_STACKDATA ScriptFloat(float value) {
    RS_STACKDATA result{};
    result.type = RS_FLOAT;
    result.val.f = value;
    return result;
}

RS_STACKDATA ScriptText(char *value) {
    RS_STACKDATA result{};
    result.type = RS_STR;
    result.val.s = value;
    return result;
}

} // namespace

TEST(ActionInput, RejectsOutOfRangeEquipmentObjectAndWeaponSlots) {
    std::vector<u_long128> storage(1024);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    NativeScriptProgram program;
    CRunScript          script;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&script, program.Bytes(), &memory));

    CActionChara                               character;
    ACCUME_EFFECT                              charge{};
    ActionGlobalScope                          restore;
    dc2::test::ScopedGlobalObject<DngUserData> user_data;
    action_info.chara = &character;
    character.chara_type = USER_CHARA_MAX;
    character.accume_effect = &charge;

    RS_STACKDATA arguments[4]{};
    for (auto &argument : arguments) {
        argument.type = RS_INT;
    }
    for (int index : {-1, 5}) {
        arguments[0].val.i = index;
        EXPECT_FALSE(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_CHECK_EQUIP], std::span(arguments).first(2)));
    }
    for (int index : {-1, static_cast<int>(ACTION_OBJECT_MAX)}) {
        arguments[0].val.i = index;
        EXPECT_FALSE(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_SET_ACCUME_FX], std::span(arguments).first(2)));
        EXPECT_FALSE(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_SET_SHOT], std::span(arguments).first(4)));
    }
    for (int index : {-1, 2}) {
        arguments[0].val.i = index;
        EXPECT_FALSE(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_GET_ATTK_POINT], std::span(arguments).first(2)));
    }
}

TEST(ActionInput, LogicalButtonsWriteThroughTheOutputReference) {
    std::vector<u_long128> storage(1024);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    NativeScriptProgram program;
    CRunScript          script;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&script, program.Bytes(), &memory));

    PadCtrl.Initialize();
    PadCtrl.RegisterBtn(PAD_BTN_ACTION_CONFIRM, PAD_CROSS, PAD_CTRL_TRIGGER_DOWN);
    PadCtrl.RegisterBtn(PAD_BTN_L1_HELD_2, PAD_L1, PAD_CTRL_TRIGGER_ON);
    PadCtrl.RegisterBtn(PAD_BTN_R1_HELD_2, PAD_R1, PAD_CTRL_TRIGGER_ON);
    GamePad__2.key_lock = 0;
    GamePad__2.previous_pad[0].button = 0;
    GamePad__2.pad[0].button = PAD_CROSS | PAD_L1;
    PadCtrl.Update(&GamePad__2);

    for (int button : {PAD_BTN_ACTION_CONFIRM, PAD_BTN_L1_HELD_2, PAD_BTN_R1_HELD_2}) {
        RS_STACKDATA output = {};
        output.type = RS_INT;
        output.val.i = -123;
        RS_STACKDATA args[2] = {};
        args[0].type = RS_INT;
        args[0].val.i = button;
        args[1].type = RS_PTR;
        args[1].val.p = &output;

        InvokeNativeExternal(script.ext_func_table[ACTION_EXT_GET_BTN], std::span(args).first(2), std::span(&output, 1));
        EXPECT_EQ(output.val.i, PadCtrl.Btn(button)) << button;
        EXPECT_EQ(args[0].val.i, button);
        EXPECT_EQ(args[1].val.p, &output);
    }
}

TEST(ActionInput, PauseMaskWritesThroughTheFollowingOutputReference) {
    std::vector<u_long128> storage(1024);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    NativeScriptProgram program;
    CRunScript          script;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&script, program.Bytes(), &memory));
    ActionGlobalScope                          restore;
    dc2::test::ScopedGlobalObject<nowScene__2> scene_owner;
    auto                                      &scene = scene_owner.Get();
    scene.battle_area.pause_flag = 0x5;

    for (int mask : {0x1, 0x2, 0x4, 0x7}) {
        RS_STACKDATA output = {};
        output.type = RS_INT;
        output.val.i = -123;
        RS_STACKDATA args[2] = {};
        args[0].type = RS_INT;
        args[0].val.i = mask;
        args[1].type = RS_PTR;
        args[1].val.p = &output;

        ASSERT_EQ(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_CHECK_PAUSE], std::span(args).first(2), std::span(&output, 1)), 1);
        EXPECT_EQ(output.val.i, 0x5 & mask);
        EXPECT_EQ(args[0].val.i, mask);
        EXPECT_EQ(args[1].val.p, &output);
    }
}

TEST(ActionInput, InvalidLaterReferenceCannotPartiallyWritePosition) {
    std::vector<u_long128> storage(1024);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    NativeScriptProgram program;
    CRunScript          script;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&script, program.Bytes(), &memory));
    CActionChara character;
    character.SetPosition(3.0f, 4.0f, 5.0f);
    ActionGlobalScope restore;
    action_info.chara = &character;
    RS_STACKDATA outputs[3]{};
    RS_STACKDATA outside{};
    for (auto &value : outputs) {
        value.type = RS_FLOAT;
        value.val.f = -1.0f;
    }
    RS_STACKDATA arguments[3]{};
    for (int index = 0; index < 3; ++index) {
        arguments[index].type = RS_PTR;
        arguments[index].val.p = &outputs[index];
    }
    arguments[1].val.p = &outside;

    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_GET_POS], std::span(arguments).first(3), outputs), 0);
    for (const auto &value : outputs) {
        EXPECT_FLOAT_EQ(value.val.f, -1.0f);
    }
}

TEST(ActionInput, DefaultMotionOwnsItsTextAfterTheInvocationSourceIsOverwrittenAndDestroyed) {
    std::vector<u_long128> storage(1024);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    NativeScriptProgram program;
    CRunScript          script;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&script, program.Bytes(), &memory));
    CActionChara      character;
    ActionGlobalScope restore;
    action_info.chara = &character;
    {
        std::string  source = "retained-native-motion";
        RS_STACKDATA argument{};
        argument.type = RS_STR;
        argument.val.s = source.data();
        EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_SET_DEFAULT_MOS], std::span(&argument, 1), {},
                                       std::span(source.data(), source.size() + 1)),
                  1);
        source.assign(source.size(), 'x');
        EXPECT_STREQ(character.default_motion.data(), "retained-native-motion");
    }
    EXPECT_STREQ(character.default_motion.data(), "retained-native-motion");
}

TEST(ActionInput, DefaultMotionAcceptsTheFormatLimitAndRejectsLongerNamesBeforeMutation) {
    std::vector<u_long128> storage(1024);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    NativeScriptProgram program;
    CRunScript          script;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&script, program.Bytes(), &memory));
    CActionChara      character;
    ActionGlobalScope restore;
    action_info.chara = &character;
    std::string  exact(sizeof(CHRINFO_KEY_SET::name) - 1, 'n');
    RS_STACKDATA argument{};
    argument.type = RS_STR;
    argument.val.s = exact.data();
    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_SET_DEFAULT_MOS], std::span(&argument, 1), {},
                                   std::span(exact.data(), exact.size() + 1)),
              1);
    EXPECT_STREQ(character.default_motion.data(), exact.c_str());
    const auto  before = character.default_motion;
    std::string oversized(sizeof(CHRINFO_KEY_SET::name), 'q');
    argument.val.s = oversized.data();
    EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[ACTION_EXT_SET_DEFAULT_MOS], std::span(&argument, 1), {},
                                   std::span(oversized.data(), oversized.size() + 1)),
              0);
    EXPECT_EQ(character.default_motion, before);
}

TEST(ActionInput, MonsterScoopOwnsItsMotionAfterTheInvocationSourceIsDestroyed) {
    std::vector<u_long128> storage(2048);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    NativeScriptProgram program;
    CRunScript          script;
    SetMonsterExtendTable();
    ASSERT_TRUE(SetMonsterScript(&script, program.Bytes(), &memory));
    ActionGlobalScope restore;
    auto              monster = dc2::test::BindGlobalOwner<nowMonster>(std::make_unique<CActiveMonster>());
    {
        std::string                 source = "scoop-motion";
        RS_STACKDATA                arguments[] = {ScriptInteger(RS_MONSTER_EXT_SET_SCOOP), ScriptText(source.data()),
                                                   ScriptFloat(2.0f), ScriptFloat(5.0f), ScriptInteger(7)};
        const std::span<const char> text(source.data(), source.size() + 1);
        script.ext(arguments, std::span(&text, 1));
        EXPECT_EQ(monster->scoop.type, 1);
        source.assign(source.size(), 'x');
    }
    ASSERT_TRUE(monster->scoop.motion.Text());
    EXPECT_EQ(*monster->scoop.motion.Text(), "scoop-motion");
    memory.stClearUsed();
    EXPECT_FALSE(monster->scoop.motion.Text());
}

TEST(ActionInput, SwordScheduleOwnsVariableFrameNamesAndRejectsTheirArenaRetirement) {
    std::vector<u_long128> storage(2048);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    NativeScriptProgram program;
    CRunScript          script;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&script, program.Bytes(), &memory));
    auto character = std::make_unique<CActionChara>();
    auto sword = std::make_unique<CSWordAfterEffect>();
    character->sw_effect_num = 0;
    character->sword_effect[0] = sword.get();
    ActionGlobalScope restore;
    action_info.chara = character.get();
    const std::string start(400, 's');
    const std::string end(401, 'e');
    {
        std::array<std::string, 3>           source{"motion", start, end};
        std::array<std::span<const char>, 3> texts;
        for (std::size_t index = 0; index < source.size(); ++index) {
            texts[index] = {source[index].data(), source[index].size() + 1};
        }
        RS_STACKDATA arguments[] = {ScriptInteger(ACTION_EXT_SW_EFFECT), ScriptInteger(0), ScriptText(source[0].data()),
                                    ScriptFloat(1.0f), ScriptFloat(5.0f), ScriptText(source[1].data()),
                                    ScriptText(source[2].data()), ScriptInteger(1), ScriptInteger(2), ScriptInteger(3)};
        script.ext(arguments, texts);
        EXPECT_EQ(character->sw_effect_num, 1);
        for (auto &text : source) {
            text.assign(text.size(), 'x');
        }
    }
    ASSERT_TRUE(character->sw_effect[0].frame0.Text());
    ASSERT_TRUE(character->sw_effect[0].frame1.Text());
    EXPECT_EQ(*character->sw_effect[0].frame0.Text(), start);
    EXPECT_EQ(*character->sw_effect[0].frame1.Text(), end);
    memory.stClearUsed();
    EXPECT_FALSE(character->sw_effect[0].motion.Text());
    EXPECT_FALSE(character->sw_effect[0].frame0.Text());
    EXPECT_FALSE(character->sw_effect[0].frame1.Text());
    character->StepEffect();
    ASSERT_TRUE(SetActionScript(&script, program.Bytes(), &memory));
    std::array<std::string, 3>           source{"replacement motion", start, end};
    std::array<std::span<const char>, 3> texts;
    for (std::size_t index = 0; index < source.size(); ++index) {
        texts[index] = {source[index].data(), source[index].size() + 1};
    }
    RS_STACKDATA arguments[] = {ScriptInteger(ACTION_EXT_SW_EFFECT), ScriptInteger(0), ScriptText(source[0].data()),
                                ScriptFloat(1.0f), ScriptFloat(5.0f), ScriptText(source[1].data()),
                                ScriptText(source[2].data()), ScriptInteger(1), ScriptInteger(2), ScriptInteger(3)};
    script.ext(arguments, texts);
    EXPECT_EQ(character->sw_effect_num, 1);
    ASSERT_TRUE(character->sw_effect[0].motion.Text());
    EXPECT_EQ(*character->sw_effect[0].motion.Text(), source[0]);
}

TEST(ActionInput, ExpiredOptionalDamageSelectorDoesNotBecomeTheSelfSelector) {
    std::array<u_long128, 1024> hit_storage{};
    std::array<u_long128, 1024> selector_storage{};
    mgCMemory                   hit_memory;
    mgCMemory                   selector_memory;
    hit_memory.stSetBuffer(hit_storage.data(), static_cast<int>(hit_storage.size()));
    selector_memory.stSetBuffer(selector_storage.data(), static_cast<int>(selector_storage.size()));
    NativeScriptProgram program;
    CRunScript          hit_script;
    CRunScript          selector_script;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&hit_script, program.Bytes(), &hit_memory));
    ASSERT_TRUE(SetActionScript(&selector_script, program.Bytes(), &selector_memory));
    const auto   hit = hit_script.RetainText("live hit");
    const auto   selector = selector_script.RetainText("other character");
    CActionChara character;
    for (auto &slot : character.damage) {
        slot = {};
    }
    character.damage_num = 1;
    character.damage[0].use = true;
    character.damage[0].damage = hit;
    character.damage[0].chara = selector;
    selector_memory.stClearUsed();
    ASSERT_TRUE(hit.Text());
    ASSERT_TRUE(selector.HasValue());
    ASSERT_EQ(selector.CString(), nullptr);
    EXPECT_EQ(character.EntryDamage2(static_cast<mgCFrame *>(nullptr), static_cast<mgCFrame *>(nullptr), hit,
                                     1.0f, nullptr, 0.0f, 1.0f, selector),
              nullptr);
    EXPECT_FALSE(character.damage[0].use);
    EXPECT_EQ(character.damage_num, 0);
}

TEST(ActionInput, PoisonedControllerStorageStartsInactiveAndRejectsInvalidObjectSlots) {
    alignas(CActionChara) std::array<std::byte, sizeof(CActionChara)> storage{};
    for (int reuse = 0; reuse < 2; ++reuse) {
        storage.fill(std::byte{0xA5});
        auto *character = std::construct_at(reinterpret_cast<CActionChara *>(storage.data()));
        EXPECT_EQ(character->damage_num, 0);
        EXPECT_EQ(character->sw_effect_num, 0);
        EXPECT_EQ(character->script_buf, nullptr);
        EXPECT_EQ(character->parent, nullptr);
        EXPECT_EQ(character->target_no, -1);
        EXPECT_EQ(character->max_speed, 4.0f);
        EXPECT_EQ(character->throw_effect, -1);
        EXPECT_EQ(character->sound[0].se_no, -1);
        EXPECT_EQ(character->body_col[0].unk_20, -1);
        EXPECT_EQ(character->EntryObject(nullptr, -2), nullptr);
        EXPECT_EQ(character->EntryObject(nullptr, ACTION_OBJECT_MAX), nullptr);
        EXPECT_EQ(character->object[0].frame, nullptr);
        std::destroy_at(character);
    }
}

TEST(ActionInput, ReleaseObjectDuringInitDoesNotRequireASceneWhenNothingIsHeld) {
    struct InitProgram {
        RS_PROG_HEADER header{};
        RS_PROGDATA    entry{};
        funcdata       function{};
        vmcode_t       instructions[4]{};
    } program;

    std::memcpy(program.header.magic, "SB2", 3);
    program.header.main = offsetof(InitProgram, function);
    program.header.code = offsetof(InitProgram, instructions);
    program.header.prog = offsetof(InitProgram, entry);
    program.header.prog_num = 1;
    program.entry.no = ACTION_PROG_INIT;
    program.entry.func = offsetof(InitProgram, function);
    program.instructions[0] = {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = ACTION_EXT_RELEASE_OBJ};
    program.instructions[1] = {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = 0};
    program.instructions[2] = {.op = RS_OP_EXT, .arg1 = 2};
    program.instructions[3] = {.op = RS_OP_END};
    std::vector<u_long128> storage(1024);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CActionChara      character;
    ActionGlobalScope restore;
    nowScene__2 = nullptr;
    SetActionExtendTable();
    ASSERT_TRUE(SetActionScript(&character.script, ProgramBytes(program), &memory));
    CaptureLoggedStderr();
    character.InitScript();
    const auto output = GetLoggedStderr();
    EXPECT_EQ(output.find("illegal function call ext"), std::string::npos);
    EXPECT_EQ(character.hold_type, ACTION_HOLD_NONE);
    auto argument = ScriptInteger(0);
    EXPECT_TRUE(InvokeNativeExternal(character.script.ext_func_table[ACTION_EXT_RELEASE_OBJ], std::span(&argument, 1)));
    character.hold_type = ACTION_HOLD_ENEMY;
    EXPECT_FALSE(InvokeNativeExternal(character.script.ext_func_table[ACTION_EXT_RELEASE_OBJ], std::span(&argument, 1)));
    EXPECT_EQ(character.hold_type, ACTION_HOLD_ENEMY);
}
