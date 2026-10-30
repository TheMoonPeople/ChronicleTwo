#include <gtest/gtest.h>

#include <array>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <functional>
#include <memory>
#include <optional>
#include <random>
#include <span>
#include <stdexcept>
#include <string>
#include <string_view>
#include <thread>
#include <utility>
#include <vector>

#include "dng_main.hpp"
#include "event_func.hpp"
#include "luau_bytecode.hpp"
#include "luau_runtime.hpp"
#include "menumain.hpp"
#include "monster.hpp"
#include "native_script_program.hpp"
#include "platform/arena.hpp"
#include "runscript.hpp"
#include "runscript_opcodes.hpp"
#include "scoped_global_object.hpp"

namespace {

// Native commands the test modules call, numbered as tools/luau/commands.json lists them.
enum class NativeCommand : int {
    InitScript = 0,
    ProgSet = 1,
    ProgGet = 2,
    GetFlag = 14,
    GetAttkType = 3,
    SetMoveSpeed = 5,
    MonsterScaleVector = 4,
    SetPallet = 30,
    MonsterVPop = 38,
    EsmSetValue = 155,
    Unregistered = 200,
};

// One native command invocation as the handler saw it.
struct RecordedCall {
    NativeCommand             no;
    int                       argc;
    std::vector<RS_STACKDATA> args;
    std::vector<std::string>  strings;
};

std::vector<RecordedCall> calls;
int                       next_output = 0;
dc2::script::RunFunction  ext_table[256]{};
std::function<void()>     after_prog_set; /**< Optional callback exercised inside the program-value native handler. */

struct NativeTextProbe {
    std::string                              handle;
    std::array<RS_STACKDATA, 64>             slots{};
    std::array<RS_CALLDATA, 16>              calls{};
    CRunScript                               nested;
    std::optional<dc2::script::RunArguments> outer;
    dc2::script::OwnedText                   retained;
    std::string                              after_nested;
    std::string                              nested_saw_outer;

    ~NativeTextProbe() { nested.DeleteProgram(); }
};

NativeTextProbe *native_text_probe = nullptr;

void ProbeNativeText(dc2::script::RunArguments args) {
    if (native_text_probe == nullptr) {
        return;
    }
    const auto text = dc2::script::RunText(args);
    if (text == "outer") {
        native_text_probe->retained = dc2::script::RunRetainedText(args);
        native_text_probe->outer = args;
        native_text_probe->nested.run(201);
        native_text_probe->after_nested = dc2::script::RunText(args);
        native_text_probe->outer.reset();
    } else if (text == "inner" && native_text_probe->outer) {
        native_text_probe->nested_saw_outer = dc2::script::RunText(*native_text_probe->outer);
    }
}

void Record(NativeCommand no, dc2::script::RunArguments args, int argc) {
    RecordedCall call{.no = no, .argc = argc};
    for (int i = 0; i < argc; ++i) {
        call.args.push_back(args.At(i));
        if (args.At(i).type == RS_STR) {
            call.strings.emplace_back(dc2::script::RunText(args + i));
        }
    }
    calls.push_back(std::move(call));
}

int HandleInitScript(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::InitScript, args, argc);
    if (argc == 1) {
        dc2::script::RunOutput(args).val.i = 9;
    }
    return 1;
}

int HandleProgSet(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::ProgSet, args, argc);
    const auto callback = after_prog_set;
    if (callback) {
        callback();
    }
    return 1;
}

int HandleProgGet(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::ProgGet, args, argc);
    if (argc >= 1) {
        dc2::script::RunOutput(args).val.i = next_output;
    }
    return 1;
}

// Answers an event flag read with 77 through the output reference.
int HandleGetFlag(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::GetFlag, args, argc);
    dc2::script::RunOutput(args + 1).val.i = 77;
    return 1;
}

int HandleGetAttkType(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::GetAttkType, args, argc);
    return 1;
}

int HandleSetMoveSpeed(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::SetMoveSpeed, args, argc);
    return 1;
}

int HandleSetPallet(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::SetPallet, args, argc);
    ProbeNativeText(args + 1);
    return 1;
}

// Scales the variables its references name, as retail's monster ScaleVector does.
int HandleMonsterScaleVector(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::MonsterScaleVector, args, argc);
    for (int i = 0; i < 3; ++i) {
        dc2::script::RunOutput(args + i).val.f *= args.At(3).val.f;
    }
    return 1;
}

// Writes an integer or a float by the output's tag, as retail's monster VPop copies a variable.
int HandleMonsterVPop(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::MonsterVPop, args, argc);
    RS_STACKDATA &output = dc2::script::RunOutput(args + 1);
    if (output.type == RS_FLOAT) {
        output.val.f = 2.5f;
    } else {
        output.val.i = 7;
    }
    return 1;
}

int HandleEsmSetValue(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::EsmSetValue, args, argc);
    return 1;
}

int HandleUnregistered(dc2::script::RunArguments args, int argc) {
    Record(NativeCommand::Unregistered, args, argc);
    ProbeNativeText(args);
    return 1;
}

void RegisterHandlers() {
    ext_table[static_cast<int>(NativeCommand::InitScript)] = HandleInitScript;
    ext_table[static_cast<int>(NativeCommand::ProgSet)] = HandleProgSet;
    ext_table[static_cast<int>(NativeCommand::ProgGet)] = HandleProgGet;
    ext_table[static_cast<int>(NativeCommand::GetFlag)] = HandleGetFlag;
    ext_table[static_cast<int>(NativeCommand::GetAttkType)] = HandleGetAttkType;
    ext_table[static_cast<int>(NativeCommand::SetMoveSpeed)] = HandleSetMoveSpeed;
    ext_table[static_cast<int>(NativeCommand::SetPallet)] = HandleSetPallet;
    ext_table[static_cast<int>(NativeCommand::MonsterScaleVector)] = HandleMonsterScaleVector;
    ext_table[static_cast<int>(NativeCommand::MonsterVPop)] = HandleMonsterVPop;
    ext_table[static_cast<int>(NativeCommand::EsmSetValue)] = HandleEsmSetValue;
    ext_table[static_cast<int>(NativeCommand::Unregistered)] = HandleUnregistered;
}

// A script instance loaded with a Luau module and the native command table.
struct Loaded {
    std::string  handle;
    RS_STACKDATA slots[64] = {};
    RS_CALLDATA  call_stack[16] = {};
    CRunScript   script;

    explicit Loaded(std::string_view module) : handle(luau_runtime::MakeHandle(module)) {
        script.ext_func(ext_table, 256);
        if (!script.load({reinterpret_cast<u8 *>(handle.data()), handle.size()}, slots, call_stack)) {
            throw std::runtime_error("invalid Luau script handle");
        }
    }
};

} // namespace

class LuauRuntime : public ::testing::Test {
protected:
    void SetUp() override {
        const auto suffix = std::to_string(std::random_device{}());
        root = std::filesystem::temp_directory_path() / ("ct-luau-" + suffix);
        std::error_code ec;
        std::filesystem::create_directories(root / "lib", ec);
        ASSERT_FALSE(ec);
        std::filesystem::copy(CT_TEST_LUAU_DIR, root, std::filesystem::copy_options::recursive, ec);
        ASSERT_FALSE(ec);
        std::filesystem::copy_file(std::filesystem::path(CT_LUAU_SOURCE_DIR) / "lib" / "vm.luau", root / "lib" / "vm.luau",
                                   std::filesystem::copy_options::overwrite_existing, ec);
        ASSERT_FALSE(ec);

        luau_runtime::SetScriptsRoot(root);
        luau_runtime::SetInterruptBudget(10000000);
        calls.clear();
        next_output = 0;
        after_prog_set = {};
        RegisterHandlers();
    }

    void TearDown() override {
        after_prog_set = {};
        luau_runtime::Shutdown();
        luau_runtime::SetScriptsRoot({});
        std::error_code ec;
        std::filesystem::remove_all(root, ec);
    }

    std::filesystem::path root;
};

TEST(ScriptExecutionValidation, NestedTargetsRestoreAndOtherThreadsRemainIndependent) {
    CRunScript first;
    CRunScript second;
    EXPECT_TRUE(dc2::script::ExecutionValid(&first));
    EXPECT_FALSE(dc2::script::ExecutionValid(nullptr));
    {
        dc2::script::ScopedExecutionValidation outer(first, [] { return false; });
        EXPECT_FALSE(dc2::script::ExecutionValid(&first));
        EXPECT_TRUE(dc2::script::ExecutionValid(&second));
        {
            dc2::script::ScopedExecutionValidation unrelated(second, [] { return true; });
            EXPECT_FALSE(dc2::script::ExecutionValid(&first));
            EXPECT_TRUE(dc2::script::ExecutionValid(&second));
        }
        {
            dc2::script::ScopedExecutionValidation nested(first, [] { return true; });
            EXPECT_TRUE(dc2::script::ExecutionValid(&first));
        }
        EXPECT_FALSE(dc2::script::ExecutionValid(&first));
        bool        worker_valid = false;
        std::thread worker([&] { worker_valid = dc2::script::ExecutionValid(&first); });
        worker.join();
        EXPECT_TRUE(worker_valid);
    }
    EXPECT_TRUE(dc2::script::ExecutionValid(&first));
}

TEST(ScriptExecutionValidation, MissingAndThrowingPredicatesRejectExecution) {
    CRunScript script;
    {
        dc2::script::ScopedExecutionValidation empty(script, {});
        EXPECT_FALSE(dc2::script::ExecutionValid(&script));
    }
    {
        dc2::script::ScopedExecutionValidation throwing(script, []() -> bool { throw std::runtime_error("expired"); });
        EXPECT_FALSE(dc2::script::ExecutionValid(&script));
    }
    EXPECT_TRUE(dc2::script::ExecutionValid(&script));
}

TEST(ScriptExecutionValidation, ExceptionUnwindingRestoresTheEnclosingValidationScope) {
    CRunScript script;
    CRunScript other;
    {
        dc2::script::ScopedExecutionValidation outer(script, [] { return false; });
        try {
            dc2::script::ScopedExecutionValidation unrelated(other, [] { return false; });
            dc2::script::ScopedExecutionValidation inner(script, [] { return true; });
            EXPECT_TRUE(dc2::script::ExecutionValid(&script));
            EXPECT_FALSE(dc2::script::ExecutionValid(&other));
            throw std::runtime_error("leave nested validation");
        } catch (const std::runtime_error &) {
            EXPECT_FALSE(dc2::script::ExecutionValid(&script));
            EXPECT_TRUE(dc2::script::ExecutionValid(&other));
        }
        EXPECT_FALSE(dc2::script::ExecutionValid(&script));
    }
    EXPECT_TRUE(dc2::script::ExecutionValid(&script));
}

TEST_F(LuauRuntime, BytecodeCallbackInvalidationStopsBeforeTheFollowingResultInstruction) {
    /**
     * Calls a native handler before instructions that would overwrite the script result.
     */
    struct CallbackProgram {
        RS_PROG_HEADER header{};
        RS_PROGDATA    entry{.no = 100, .func = offsetof(CallbackProgram, function)};
        funcdata       function{};
        vmcode_t       code[5]{
            {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = static_cast<int>(NativeCommand::ProgSet)},
            {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = 11                                      },
            {.op = RS_OP_EXT,        .arg1 = 2,            .arg2 = 0                                       },
            {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = 99                                      },
            {.op = RS_OP_RET,        .arg1 = 0,            .arg2 = 0                                       }
        };

        CallbackProgram() {
            std::memcpy(header.magic, "SB2", 3);
            header.main = offsetof(CallbackProgram, function);
            header.code = offsetof(CallbackProgram, code);
            header.prog = offsetof(CallbackProgram, entry);
            header.prog_num = 1;
        }
    } program;

    std::array<RS_STACKDATA, 64> slots{};
    std::array<RS_CALLDATA, 16>  call_stack{};
    CRunScript                   script;
    script.ext_func(ext_table, static_cast<int>(std::size(ext_table)));
    ASSERT_TRUE(script.load(ProgramBytes(program), slots, call_stack));
    script.result = 17;
    bool                                   live = true;
    dc2::script::ScopedExecutionValidation validation(script, [&] { return live; });
    after_prog_set = [&] { live = false; };
    EXPECT_EQ(script.run(100), -1);
    ASSERT_EQ(calls.size(), 1U);
    EXPECT_EQ(calls[0].args[0].val.i, 11);
    EXPECT_EQ(script.result, 17);
    EXPECT_EQ(script.end, 0);
    EXPECT_EQ(script.pc, &program.code[2]);
    EXPECT_EQ(script.sp, script.stack);
    script.resume();
    EXPECT_EQ(script.result, 17);
    EXPECT_EQ(calls.size(), 1U);
}

TEST_F(LuauRuntime, NativeCallbacksRejectSameControllerReentryWithoutReplacingTheOuterCoroutine) {
    std::ofstream(root / "facade/reentry.luau") << R"(
return {
    [200] = function()
        action.set_program_value(1)
        action.set_program_value(2)
        return 37
    end,
    [201] = function()
        action.set_program_value(99)
        return 99
    end,
}
)";
    Loaded loaded("facade/reentry");
    int    rejected = 0;
    after_prog_set = [&] {
        if (calls.back().args[0].val.i == 1) {
            EXPECT_EQ(loaded.script.run(201), -1);
            loaded.script.resume();
            EXPECT_EQ(loaded.script.end, 0);
            ++rejected;
        }
    };
    EXPECT_EQ(loaded.script.run(200), 0);
    EXPECT_EQ(rejected, 1);
    EXPECT_EQ(loaded.script.end, 1);
    EXPECT_EQ(loaded.script.result, 37);
    ASSERT_EQ(calls.size(), 2U);
    EXPECT_EQ(calls[0].args[0].val.i, 1);
    EXPECT_EQ(calls[1].args[0].val.i, 2);
}

TEST_F(LuauRuntime, DifferentControllerCallbacksRejectReentryOfAnyActiveAncestor) {
    std::ofstream(root / "facade/reentry_outer.luau") << R"(
return {
    [200] = function()
        action.set_program_value(1)
        action.set_program_value(3)
        return 11
    end,
    [201] = function()
        action.set_program_value(99)
        return 99
    end,
}
)";
    std::ofstream(root / "facade/reentry_inner.luau") << R"(
return {[200] = function() action.set_program_value(2); return 22 end}
)";
    Loaded outer("facade/reentry_outer");
    Loaded inner("facade/reentry_inner");
    int    rejected = 0;
    after_prog_set = [&] {
        const auto marker = calls.back().args[0].val.i;
        if (marker == 1) {
            EXPECT_EQ(inner.script.run(200), 0);
            EXPECT_EQ(inner.script.result, 22);
        } else if (marker == 2) {
            EXPECT_EQ(outer.script.run(201), -1);
            outer.script.resume();
            EXPECT_EQ(outer.script.end, 0);
            ++rejected;
        }
    };
    EXPECT_EQ(outer.script.run(200), 0);
    EXPECT_EQ(rejected, 1);
    EXPECT_EQ(outer.script.end, 1);
    EXPECT_EQ(outer.script.result, 11);
    ASSERT_EQ(calls.size(), 3U);
    EXPECT_EQ(calls[0].args[0].val.i, 1);
    EXPECT_EQ(calls[1].args[0].val.i, 2);
    EXPECT_EQ(calls[2].args[0].val.i, 3);
}

TEST_F(LuauRuntime, ExpiredExecutionCancelsTypedAndGenericCallbacksEvenWhenLuaCatchesTheError) {
    for (const bool generic : {false, true}) {
        const auto command = generic ? "action.call_command(1, 1)" : "action.set_program_value(1)";
        const auto module = generic ? "facade/expired_generic" : "facade/expired_typed";
        std::ofstream(root / (std::string(module) + ".luau"))
            << "return {[200]=function() pcall(function() " << command << " end); " << command << " end}";
    }
    for (const bool generic : {false, true}) {
        calls.clear();
        const auto module = generic ? "facade/expired_generic" : "facade/expired_typed";
        SCOPED_TRACE(module);
        Loaded loaded(module);
        ASSERT_EQ(loaded.script.check_program(200), 1);
        bool                                   live = true;
        dc2::script::ScopedExecutionValidation execution(loaded.script, [&] { return live; });
        after_prog_set = [&] { live = false; };
        EXPECT_EQ(loaded.script.run(200), -1);
        ASSERT_EQ(calls.size(), 1U) << "owns=" << luau_runtime::Owns(&loaded.script)
                                    << " end=" << loaded.script.end << " result=" << loaded.script.result;
        EXPECT_EQ(loaded.script.end, 0);
        live = true;
        loaded.script.resume();
        EXPECT_EQ(calls.size(), 1U);
        EXPECT_EQ(loaded.script.run(200), -1);
        EXPECT_EQ(calls.size(), 1U);
        after_prog_set = {};
    }
}

TEST_F(LuauRuntime, NestedMonsterCallbacksRestoreOnlyLiveOuterBindings) {
    for (const bool retire_outer : {false, true}) {
        calls.clear();
        auto manager = std::make_unique<CMonsterMan>();
        auto scene = std::make_unique<CScene>();
        scene->chara_num = DNG_CHARA_SLOT_MONSTER_END;
        auto outer = std::make_shared<CActiveMonster>();
        auto inner = std::make_shared<CActiveMonster>();
        ASSERT_EQ(scene->AssignChara(DNG_CHARA_SLOT_MONSTER, dc2::scene::CharacterResource::FromOwned(outer)), DNG_CHARA_SLOT_MONSTER);
        ASSERT_EQ(scene->AssignChara(DNG_CHARA_SLOT_MONSTER + 1, dc2::scene::CharacterResource::FromOwned(inner)), DNG_CHARA_SLOT_MONSTER + 1);
        dc2::test::ScopedGlobalObject<FxScriptMan> effects;
        manager->Initialize(scene.get());
        auto                                        handle = luau_runtime::MakeHandle("facade/basic");
        std::array<std::array<RS_STACKDATA, 64>, 2> values{};
        std::array<std::array<RS_CALLDATA, 16>, 2>  call_stacks{};
        int                                         index = 0;
        for (auto *monster : {outer.get(), inner.get()}) {
            monster->mons_script.ext_func(ext_table, 256);
            ASSERT_TRUE(monster->mons_script.load({reinterpret_cast<u8 *>(handle.data()), handle.size()}, values[index], call_stacks[index]));
            monster->req_prog = MONSTER_PROG_MAIN;
            ++index;
        }
        after_prog_set = [&] {
            if (nowMonster == outer.get()) {
                manager->RunScript(1);
                EXPECT_EQ(nowMonster, retire_outer ? nullptr : outer.get());
            } else {
                EXPECT_EQ(nowMonster, inner.get());
                if (retire_outer) {
                    scene->chara[DNG_CHARA_SLOT_MONSTER].Initialize();
                }
            }
        };
        manager->RunScript(0);
        EXPECT_EQ(calls.size(), 2U);
        EXPECT_EQ(nowMonster, retire_outer ? nullptr : outer.get());
        after_prog_set = {};
        nowMonster = nullptr;
    }
}

TEST_F(LuauRuntime, SceneRetirementDuringCallbackRetainsControllerUntilVmReturns) {
    auto manager = std::make_unique<CMonsterMan>();
    auto scene = std::make_unique<CScene>();
    scene->chara_num = DNG_CHARA_SLOT_MONSTER_END;
    auto                                monster = std::make_shared<CActiveMonster>();
    const std::weak_ptr<CActiveMonster> lifetime = monster;
    ASSERT_EQ(scene->AssignChara(DNG_CHARA_SLOT_MONSTER, dc2::scene::CharacterResource::FromOwned(monster)), DNG_CHARA_SLOT_MONSTER);
    dc2::test::ScopedGlobalObject<FxScriptMan> effects;
    manager->Initialize(scene.get());
    auto                         handle = luau_runtime::MakeHandle("facade/basic");
    std::array<RS_STACKDATA, 64> values{};
    std::array<RS_CALLDATA, 16>  call_stack{};
    monster->mons_script.ext_func(ext_table, 256);
    ASSERT_TRUE(monster->mons_script.load({reinterpret_cast<u8 *>(handle.data()), handle.size()}, values, call_stack));
    monster->req_prog = MONSTER_PROG_MAIN;
    monster.reset();
    after_prog_set = [&] {
        scene.reset();
        EXPECT_FALSE(lifetime.expired());
    };
    manager->RunScript(0);
    EXPECT_TRUE(lifetime.expired());
    EXPECT_EQ(calls.size(), 1U);
    EXPECT_EQ(nowMonster, nullptr);
}

TEST_F(LuauRuntime, RunWaitResumeEnd) {
    Loaded      loaded("facade/basic");
    CRunScript &script = loaded.script;
    EXPECT_EQ(script.check_program(200), 1);
    EXPECT_EQ(script.check_program(300), 0);

    ASSERT_EQ(script.run(200), 1);
    EXPECT_EQ(script.end, 0);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[0].args[0].val.i, 1);

    script.resume();
    EXPECT_EQ(script.end, 0);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[1].args[0].val.i, 2);

    script.resume();
    EXPECT_EQ(script.end, 1);
    ASSERT_EQ(calls.size(), 3u);
    EXPECT_EQ(calls[2].args[0].val.i, 3);

    script.resume();
    EXPECT_EQ(calls.size(), 3u);
}

TEST_F(LuauRuntime, MonsterWithoutStunProgramResumesSuspendedBehaviorAfterStun) {
    auto        monster_owner = std::make_shared<CActiveMonster>();
    auto       &monster = *monster_owner;
    CMonsterMan manager{};
    CScene      scene{};
    scene.chara_num = DNG_CHARA_SLOT_MONSTER_END;
    ASSERT_EQ(scene.AssignChara(DNG_CHARA_SLOT_MONSTER, dc2::scene::CharacterResource::FromOwned(monster_owner)), DNG_CHARA_SLOT_MONSTER);
    dc2::test::ScopedGlobalObject<FxScriptMan> effects;
    manager.Initialize(&scene);
    std::string  handle = luau_runtime::MakeHandle("facade/basic");
    RS_STACKDATA slots[64]{};
    RS_CALLDATA  call_stack[16]{};
    monster.mons_script.ext_func(ext_table, 256);
    ASSERT_TRUE(monster.mons_script.load({reinterpret_cast<u8 *>(handle.data()), handle.size()}, slots, call_stack));
    ASSERT_EQ(monster.mons_script.check_program(MONSTER_PROG_PIYORI), 0);

    monster.req_prog = MONSTER_PROG_MAIN;
    manager.RunScript(0);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls.back().args[0].val.i, 1);
    EXPECT_EQ(monster.now_prog, MONSTER_PROG_MAIN);

    monster.piyori_time = 3;
    monster.req_prog = MONSTER_PROG_PIYORI;
    manager.RunScript(0);
    EXPECT_EQ(monster.req_prog, MONSTER_PROG_RUNNING);
    EXPECT_EQ(monster.now_prog, MONSTER_PROG_MAIN);
    EXPECT_EQ(monster.piyori_mark, 3);
    EXPECT_EQ(monster.piyori.target, &monster);
    manager.RunScript(0);
    EXPECT_EQ(calls.size(), 1u);

    monster.piyori_mark = 0;
    manager.RunScript(0);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls.back().args[0].val.i, 2);
    EXPECT_EQ(monster.mons_script.end, 0);
    manager.RunScript(0);
    ASSERT_EQ(calls.size(), 3u);
    EXPECT_EQ(calls.back().args[0].val.i, 3);
    EXPECT_EQ(monster.mons_script.end, 1);
    EXPECT_EQ(monster.req_prog, MONSTER_PROG_MAIN);
    luau_runtime::Forget(&monster.mons_script);
}

TEST_F(LuauRuntime, GlobalsPersistPerInstance) {
    Loaded first("facade/basic");
    Loaded second("facade/basic");
    EXPECT_EQ(first.script.run(100), 0);
    EXPECT_EQ(first.script.run(100), 0);
    EXPECT_EQ(second.script.run(100), 0);

    ASSERT_EQ(calls.size(), 3u);
    EXPECT_EQ(calls[0].args[0].val.i, 1);
    EXPECT_EQ(calls[1].args[0].val.i, 2);
    EXPECT_EQ(calls[2].args[0].val.i, 1);
}

TEST_F(LuauRuntime, MainReturnsResult) {
    Loaded loaded("facade/basic");
    EXPECT_EQ(loaded.script.run(-1), 0);
    EXPECT_EQ(loaded.script.end, 1);
    EXPECT_EQ(loaded.script.result, 7);
}

TEST_F(LuauRuntime, NamedHandlersFollowTheKindsProgramNames) {
    Loaded      loaded("dungeon/act_script/named");
    CRunScript &script = loaded.script;
    EXPECT_EQ(script.check_program(100), 1);
    EXPECT_EQ(script.check_program(200), 1);
    EXPECT_EQ(script.check_program(500), 0);

    // Program 100 is named init, so the numeric key that would record -1 is ignored.
    ASSERT_EQ(script.run(100), 0);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[0].args[0].val.i, 100);

    ASSERT_EQ(script.run(200), 1);
    EXPECT_EQ(script.end, 0);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[1].args[0].val.i, 200);

    script.resume();
    EXPECT_EQ(script.end, 1);
    ASSERT_EQ(calls.size(), 3u);
    EXPECT_EQ(calls[2].args[0].val.i, 201);

    EXPECT_EQ(script.run(-1), 0);
    EXPECT_EQ(script.result, 3);
}

TEST_F(LuauRuntime, MissingProgramReturnsMinusOne) {
    Loaded loaded("facade/basic");
    EXPECT_EQ(loaded.script.run(999), -1);
}

TEST_F(LuauRuntime, OutputsReturnAndUnwrittenAreNil) {
    next_output = 42;
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(100), 0);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[0].no, NativeCommand::ProgGet);
    EXPECT_EQ(calls[1].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[1].args[0].type, RS_INT);
    EXPECT_EQ(calls[1].args[0].val.i, 42);

    ASSERT_EQ(loaded.script.run(101), 0);
    ASSERT_EQ(calls.size(), 4u);
    EXPECT_EQ(calls[2].no, NativeCommand::GetAttkType);
    EXPECT_EQ(calls[3].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[3].args[0].val.i, 1);
}

TEST_F(LuauRuntime, StringsReachHandlersAsCp932) {
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(102), 0);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].no, NativeCommand::SetPallet);
    EXPECT_EQ(calls[0].argc, 2);
    EXPECT_EQ(calls[0].args[0].type, RS_INT);
    EXPECT_EQ(calls[0].args[0].val.i, 4);
    EXPECT_EQ(calls[0].args[1].type, RS_STR);
    ASSERT_EQ(calls[0].strings.size(), 1u);
    EXPECT_EQ(calls[0].strings[0], std::string("\x83\x65\x83\x58\x83\x67", 6));
}

TEST_F(LuauRuntime, FloatInputsAreFloatSlots) {
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(103), 0);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].no, NativeCommand::SetMoveSpeed);
    ASSERT_EQ(calls[0].args.size(), 1u);
    EXPECT_EQ(calls[0].args[0].type, RS_FLOAT);
    EXPECT_FLOAT_EQ(calls[0].args[0].val.f, 1.5f);
}

TEST_F(LuauRuntime, ExtMarshalsByLuauType) {
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(104), 0);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].no, NativeCommand::Unregistered);
    ASSERT_EQ(calls[0].argc, 4);
    ASSERT_EQ(calls[0].args.size(), 4u);
    EXPECT_EQ(calls[0].args[0].type, RS_INT);
    EXPECT_EQ(calls[0].args[0].val.i, 1);
    EXPECT_EQ(calls[0].args[1].type, RS_FLOAT);
    EXPECT_FLOAT_EQ(calls[0].args[1].val.f, 2.5f);
    EXPECT_EQ(calls[0].args[2].type, RS_STR);
    ASSERT_EQ(calls[0].strings.size(), 1u);
    EXPECT_EQ(calls[0].strings[0], "x");
    EXPECT_EQ(calls[0].args[3].type, RS_INT);
    EXPECT_EQ(calls[0].args[3].val.i, 1);
}

TEST_F(LuauRuntime, SuffixedAndAmbiguousArities) {
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(105), 0);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[0].no, NativeCommand::InitScript);
    EXPECT_EQ(calls[0].argc, 1);
    EXPECT_EQ(calls[1].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[1].args[0].val.i, 9);

    ASSERT_EQ(loaded.script.run(106), 0);
    ASSERT_EQ(calls.size(), 3u);
    EXPECT_EQ(calls[2].no, NativeCommand::InitScript);
    EXPECT_EQ(calls[2].argc, 1);
}

TEST_F(LuauRuntime, VariantsTypeTaggedParameters) {
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(108), 0);
    ASSERT_EQ(calls.size(), 3u);
    for (const RecordedCall &call : calls) {
        EXPECT_EQ(call.no, NativeCommand::EsmSetValue);
        ASSERT_EQ(call.args.size(), 3u);
        EXPECT_EQ(call.args[0].type, RS_INT);
    }
    // The catalogued type of the tagged value is an integer, so an integral float still passes as one.
    EXPECT_EQ(calls[0].args[2].type, RS_INT);
    EXPECT_EQ(calls[0].args[2].val.i, 12);
    EXPECT_EQ(calls[1].args[2].type, RS_FLOAT);
    EXPECT_FLOAT_EQ(calls[1].args[2].val.f, 12.0f);
    EXPECT_EQ(calls[2].args[2].type, RS_INT);
    EXPECT_EQ(calls[2].args[2].val.i, 3);
}

TEST_F(LuauRuntime, VariantsSeedTaggedOutputs) {
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(109), 0);
    ASSERT_EQ(calls.size(), 4u);
    EXPECT_EQ(calls[0].no, NativeCommand::MonsterVPop);
    // The handler wrote 7 for each integer read and 2.5 for the float one; the sum passes as a float.
    EXPECT_EQ(calls[3].no, NativeCommand::EsmSetValue);
    EXPECT_EQ(calls[3].args[2].type, RS_FLOAT);
    EXPECT_FLOAT_EQ(calls[3].args[2].val.f, 16.5f);
}

TEST_F(LuauRuntime, InOutParametersPassTheirValueThroughTheReference) {
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(110), 0);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[0].no, NativeCommand::MonsterScaleVector);
    ASSERT_EQ(calls[0].args.size(), 4u);
    EXPECT_EQ(calls[0].args[0].type, RS_PTR);
    // The scaled values reach ProgSet: 2 * (1 + 2 + 3).
    EXPECT_EQ(calls[1].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[1].args[0].val.i, 12);
}

TEST_F(LuauRuntime, CmathIsTheCLibrarysSinglePrecisionTrig) {
    Loaded loaded("facade/natives");
    ASSERT_EQ(loaded.script.run(111), 0);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].args[0].type, RS_FLOAT);
    // The interpreter's SIN calls sinf; rounding a double-precision sine differs in the last bit here.
    // A volatile angle keeps the expected value a library call too: the compiler may fold a constant one with
    // its own correctly rounded sine, which differs from the C library's.
    volatile float angle = 0.779f;
    EXPECT_EQ(calls[0].args[0].val.f, std::sin(angle));
}

TEST_F(LuauRuntime, ErrorsEndTheProgram) {
    Loaded loaded("facade/errors");
    EXPECT_EQ(loaded.script.run(100), 0);
    EXPECT_EQ(loaded.script.end, 1);
    loaded.script.resume();
    EXPECT_TRUE(calls.empty());
    EXPECT_EQ(loaded.script.end, 1);
}

TEST_F(LuauRuntime, InterruptBudgetStopsLoops) {
    luau_runtime::SetInterruptBudget(1000);
    Loaded loaded("facade/errors");
    EXPECT_EQ(loaded.script.run(101), 0);
    EXPECT_EQ(loaded.script.end, 1);
}

TEST_F(LuauRuntime, ModuleMustReturnTable) {
    Loaded loaded("facade/badreturn");
    EXPECT_TRUE(luau_runtime::Owns(&loaded.script));
    EXPECT_EQ(loaded.script.check_program(100), 0);
    EXPECT_EQ(loaded.script.run(100), -1);
}

TEST_F(LuauRuntime, DeleteProgramForgets) {
    Loaded loaded("facade/basic");
    EXPECT_TRUE(luau_runtime::Owns(&loaded.script));
    loaded.script.DeleteProgram();
    EXPECT_FALSE(luau_runtime::Owns(&loaded.script));
    EXPECT_EQ(loaded.script.check_program(200), 0);
}

TEST_F(LuauRuntime, HandlesRoundTrip) {
    const std::string handle = luau_runtime::MakeHandle("facade/basic");
    EXPECT_EQ(luau_runtime::HandleModule(std::span<const char>(handle)), std::optional<std::string>("facade/basic"));
    EXPECT_EQ(luau_runtime::HandleModule(std::span<const char>(handle)), std::optional<std::string>("facade/basic"));
    for (std::size_t length = 0; length < 8 + std::string_view("facade/basic").size() + 1; ++length) {
        EXPECT_FALSE(luau_runtime::HandleModule(std::span<const char>(handle.data(), length)).has_value());
    }

    std::string invalid = handle;
    invalid[4] = static_cast<char>(0x7f);
    EXPECT_FALSE(luau_runtime::HandleModule(std::span<const char>(invalid)).has_value());

    const std::string retail("SB2\0", 4);
    EXPECT_FALSE(luau_runtime::HandleModule(std::span<const char>(retail)).has_value());
    EXPECT_FALSE(luau_runtime::HandleModule(std::span<const char>(retail)).has_value());
}

TEST_F(LuauRuntime, ModuleForScriptMapsTheKindsLuauRuns) {
    for (const char *directory : {"mainchr", "map", "dungeon/eff_script/menu_ice.pac", "dungeon/monster", "event/tbox/bomb.pack"}) {
        std::filesystem::create_directories(root / directory);
    }
    for (const char *module : {"mainchr/c01", "map/x", "dungeon/eff_script/menu_ice.pac/c02cold", "dungeon/monster/b08a",
                               "event/tbox/bomb.pack/tbox_exp", "event/tbox/ntbox_arg"}) {
        std::ofstream(root / (std::string(module) + ".luau")) << "return {}\n";
    }
    luau_runtime::SetScriptsRoot(root);

    EXPECT_EQ(luau_runtime::ModuleForScript("mainchr/c01.stb"), std::optional<std::string>("mainchr/c01"));
    EXPECT_FALSE(luau_runtime::ModuleForScript("mainchr/c99.stb").has_value());
    EXPECT_EQ(luau_runtime::ModuleForScript("map/x.stb"), std::optional<std::string>("map/x"));
    EXPECT_EQ(luau_runtime::ModuleForScript("dungeon/eff_script/menu_ice.pac/c02cold.stb"),
              std::optional<std::string>("dungeon/eff_script/menu_ice.pac/c02cold"));
    EXPECT_EQ(luau_runtime::ModuleForScript("dungeon/monster/b08a.stb"), std::optional<std::string>("dungeon/monster/b08a"));
    // Effect scripts under event/tbox are pack members; the argument scripts beside the packs are not effects.
    EXPECT_EQ(luau_runtime::ModuleForScript("event/tbox/bomb.pack/tbox_exp.stb"), std::optional<std::string>("event/tbox/bomb.pack/tbox_exp"));
    EXPECT_EQ(luau_runtime::ModuleForScript("event/tbox/ntbox_arg.stb"), std::optional<std::string>("event/tbox/ntbox_arg"));
}

TEST_F(LuauRuntime, PrintMatchesRetailPrint) {
    Loaded loaded("facade/natives");
    testing::internal::CaptureStdout();
    const int         result = loaded.script.run(107);
    const std::string output = testing::internal::GetCapturedStdout();
    EXPECT_EQ(result, 0);
    EXPECT_NE(output.find("a12.500000b\n"), std::string::npos) << output;
}

TEST_F(LuauRuntime, InterpreterKeepsRetailPrograms) {
    NativeScriptProgram program;
    RS_STACKDATA        slots[64] = {};
    RS_CALLDATA         call_stack[16] = {};
    CRunScript          script;
    ASSERT_TRUE(script.load(program.Bytes(), slots, call_stack));

    EXPECT_FALSE(luau_runtime::Owns(&script));
    EXPECT_EQ(script.check_program(1), 0);
}

TEST_F(LuauRuntime, PrecompiledModulesFallBackWhenStaleOrIncompatible) {
    const std::string source = "return {[100] = function() return 7 end}\r\n";
    const auto        module = root / "facade/precompiled.luau";
    std::ofstream(module, std::ios::binary) << source;
    auto                                          options = luau_bytecode::RuntimeOptions();
    std::size_t                                   size = 0;
    const std::unique_ptr<char, void (*)(void *)> code(luau_compile(source.data(), source.size(), &options, &size), std::free);
    ASSERT_NE(code, nullptr);
    const std::string valid = luau_bytecode::Header(source) + std::string(code.get(), size);
    const std::string stale = luau_bytecode::Header("old source") + std::string(code.get(), size);
    const std::string incompatible = luau_bytecode::Header(source) + "invalid bytecode";
    for (const auto &contents : {valid, stale, incompatible}) {
        luau_runtime::Shutdown();
        luau_runtime::SetScriptsRoot(root);
        std::ofstream(module.string() + "c", std::ios::binary) << contents;
        Loaded loaded("facade/precompiled");
        ASSERT_EQ(loaded.script.run(100), 0);
        EXPECT_EQ(loaded.script.result, 7);
    }
}

TEST(LuauBytecode, HeaderRejectsChangedSourceAndTruncatedPayloads) {
    const std::string contents = luau_bytecode::Header("source") + "code";
    const auto        bytecode = luau_bytecode::Bytecode(contents, "source");
    EXPECT_EQ(bytecode, std::optional<std::string_view>{"code"});
    EXPECT_FALSE(luau_bytecode::Bytecode(contents, "changed"));
    EXPECT_FALSE(luau_bytecode::Bytecode(luau_bytecode::Header("source"), "source"));
    EXPECT_FALSE(luau_bytecode::Bytecode("CTLB", "source"));
}

TEST_F(LuauRuntime, EventKindPrefixesMapToModules) {
    for (const char *directory : {"map/d/d01", "dungeon/sys_script", "event/e200/e209", "event/tbox/bomb.pack"}) {
        std::filesystem::create_directories(root / directory);
    }
    for (const char *module : {"map/d/d01/d01_sfida_0", "dungeon/sys_script/d06", "event/e200/e209/e209_arg_1", "event/tbox/ntbox_arg",
                               "event/e200/e209/e209_arg", "event/tbox/bomb.pack/tbox_exp"}) {
        std::ofstream(root / (std::string(module) + ".luau")) << "return {}\n";
    }
    luau_runtime::SetScriptsRoot(root);

    EXPECT_EQ(luau_runtime::ModuleForScript("map/d/d01/d01_sfida_0.stb"), std::optional<std::string>("map/d/d01/d01_sfida_0"));
    EXPECT_EQ(luau_runtime::ModuleForScript("dungeon/sys_script/d06.stb"), std::optional<std::string>("dungeon/sys_script/d06"));
    EXPECT_EQ(luau_runtime::ModuleForScript("event/e200/e209/e209_arg_1.stb"), std::optional<std::string>("event/e200/e209/e209_arg_1"));
    EXPECT_EQ(luau_runtime::ModuleForScript("event/tbox/ntbox_arg.stb"), std::optional<std::string>("event/tbox/ntbox_arg"));
    EXPECT_EQ(luau_runtime::ModuleForScript("event/e200/e209/e209_arg.stb"), std::optional<std::string>("event/e200/e209/e209_arg"));
    EXPECT_EQ(luau_runtime::ModuleForScript("event/tbox/bomb.pack/tbox_exp.stb"), std::optional<std::string>("event/tbox/bomb.pack/tbox_exp"));
    // Without a module the script stays on the interpreter, whatever its language.
    EXPECT_FALSE(luau_runtime::ModuleForScript("map/d/d01/d01_5.stb").has_value());
}

TEST_F(LuauRuntime, EventModuleRunsNumberedPrograms) {
    Loaded      loaded("map/event_basic");
    CRunScript &script = loaded.script;
    EXPECT_EQ(script.check_program(3), 1);
    EXPECT_EQ(script.check_program(4), 0);

    ASSERT_EQ(script.run(3), 1);
    EXPECT_EQ(script.end, 0);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[0].args[0].val.i, 1);

    script.resume();
    EXPECT_EQ(script.end, 1);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[1].args[0].val.i, 2);

    EXPECT_EQ(script.run(-1), 0);
    ASSERT_EQ(calls.size(), 3u);
    EXPECT_EQ(calls[2].args[0].val.i, 50);
}

TEST_F(LuauRuntime, SkipRunsToTheNextSkipEnd) {
    Loaded      loaded("facade/skip");
    CRunScript &script = loaded.script;
    ASSERT_EQ(script.run(1), 1);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].args[0].val.i, 1);

    // The site-10 wait ends the skip; its skip function's call is dropped.
    script.skip();
    EXPECT_EQ(calls.size(), 1u);
    EXPECT_EQ(script.skip_end_count, 1);
    EXPECT_EQ(script.skip_wait, 0);
    EXPECT_EQ(script.end, 0);

    script.resume();
    EXPECT_EQ(script.end, 1);
    EXPECT_EQ(script.result, 10);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[1].args[0].val.i, 99);
}

TEST_F(LuauRuntime, SkipFromALaterWaitUsesThatSite) {
    Loaded      loaded("facade/skip");
    CRunScript &script = loaded.script;
    ASSERT_EQ(script.run(1), 1);
    script.resume();
    ASSERT_EQ(calls.size(), 2u);

    script.skip();
    EXPECT_EQ(calls.size(), 2u);
    EXPECT_EQ(script.end, 0);

    script.resume();
    EXPECT_EQ(script.end, 1);
    EXPECT_EQ(script.result, 11);
    ASSERT_EQ(calls.size(), 3u);
    EXPECT_EQ(calls[2].args[0].val.i, 99);
}

TEST_F(LuauRuntime, NormalSkipEndOnlyCounts) {
    Loaded      loaded("facade/skip");
    CRunScript &script = loaded.script;
    EXPECT_EQ(script.run(2), 0);
    EXPECT_EQ(script.skip_end_count, 1);
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[0].args[0].val.i, 5);
    EXPECT_EQ(calls[1].args[0].val.i, 7);
}

TEST_F(LuauRuntime, SkipSentinelOutsideSectionEndsTheScript) {
    Loaded      loaded("facade/skip");
    CRunScript &script = loaded.script;
    ASSERT_EQ(script.run(3), 1);
    script.skip();
    EXPECT_EQ(script.end, 1);
    EXPECT_TRUE(calls.empty());
}

TEST_F(LuauRuntime, RunResetsSkipState) {
    Loaded      loaded("facade/skip");
    CRunScript &script = loaded.script;
    ASSERT_EQ(script.run(1), 1);
    script.skip();
    ASSERT_EQ(script.skip_end_count, 1);

    EXPECT_EQ(script.run(1), 1);
    EXPECT_EQ(script.skip_wait, 0);
    EXPECT_EQ(script.skip_end_count, 0);
}

TEST_F(LuauRuntime, NativeOutputsAreNilWhileSkipping) {
    Loaded loaded("facade/skip");
    ASSERT_EQ(loaded.script.run(4), 1);
    loaded.script.skip();
    EXPECT_TRUE(calls.empty());
    EXPECT_EQ(loaded.script.skip_wait, 0);
    EXPECT_EQ(loaded.script.end, 0);

    loaded.script.resume();
    EXPECT_EQ(loaded.script.end, 1);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].no, NativeCommand::GetFlag);
    // The dropped call returned nil inside the skip, and the call after the section reached the handler.
    EXPECT_EQ(loaded.script.result, 11);
}

TEST_F(LuauRuntime, NestedHelpersLoadNativeCommandsAndResumeInTheInstanceSandbox) {
    std::ofstream(root / "lib/boss_command.luau") << R"(
local set_program = action.set_program_value
return function(value) set_program(value) end
)";
    std::ofstream(root / "lib/boss_setup.luau") << R"(
local vm = require("@lib/vm")
local set_program = require("@lib/boss_command")
return function()
    set_program(1)
    vm.wait()
    set_program(2)
end
)";
    const auto module = root / "dungeon/monster/boss_sandbox.luau";
    std::filesystem::create_directories(module.parent_path());
    std::ofstream(module) << R"(
local setup = require("@lib/boss_setup")
return { setup = setup }
)";

    Loaded loaded("dungeon/monster/boss_sandbox");
    ASSERT_EQ(loaded.script.run(-1), 1);
    ASSERT_EQ(calls.size(), 1u);
    EXPECT_EQ(calls[0].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[0].args[0].val.i, 1);
    EXPECT_EQ(loaded.script.end, 0);

    loaded.script.resume();
    ASSERT_EQ(calls.size(), 2u);
    EXPECT_EQ(calls[1].no, NativeCommand::ProgSet);
    EXPECT_EQ(calls[1].args[0].val.i, 2);
    EXPECT_EQ(loaded.script.end, 1);
}

TEST_F(LuauRuntime, ItemMenuResultReachesTheScriptAfterTheMenuExits) {
    std::ofstream(root / "map" / "deferred_menu.luau") << R"(
local script = {}
function script.event_3()
    event.open_use_item_menu(376)
    coroutine.yield()
    return vmhost.used_item() or -1
end
return script
)";
    Loaded loaded("map/deferred_menu");
    SetEventFunc(&loaded.script);
    const auto previous_menu = MenuArg;
    const auto previous_mode = EdEventInfo.command_mode;
    ASSERT_EQ(loaded.script.run(3), 1);
    EXPECT_EQ(loaded.script.end, 0);
    MenuArg.result[0] = 376;
    EdEventMenuExit();
    loaded.script.resume();
    EXPECT_EQ(loaded.script.end, 1);
    EXPECT_EQ(loaded.script.result, 376);
    MenuArg = previous_menu;
    EdEventInfo.command_mode = previous_mode;
}

TEST_F(LuauRuntime, ItemMenuOfARetiredScriptWritesNothing) {
    std::ofstream(root / "map" / "cancelled_menu.luau") << R"(
return { event_3 = function() event.open_use_item_menu(376) coroutine.yield() end }
)";
    std::ofstream(root / "map" / "used_item_probe.luau") << R"(
return { event_3 = function() return vmhost.used_item() or -1 end }
)";
    Loaded loaded("map/cancelled_menu");
    SetEventFunc(&loaded.script);
    const auto previous_menu = MenuArg;
    const auto previous_mode = EdEventInfo.command_mode;
    ASSERT_EQ(loaded.script.run(3), 1);
    loaded.script.DeleteProgram();
    MenuArg.result[0] = 7;
    EdEventMenuExit();
    EXPECT_FALSE(luau_runtime::Owns(&loaded.script));
    Loaded probe("map/used_item_probe");
    probe.script.run(3);
    EXPECT_EQ(probe.script.end, 1);
    EXPECT_EQ(probe.script.result, -1);
    MenuArg = previous_menu;
    EdEventInfo.command_mode = previous_mode;
}

TEST_F(LuauRuntime, RetiredArenaStorageDropsTheInstanceBeforeReadingItsPoisonedController) {
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 1024 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(storage, 1024);
    auto *script = dc2::memory::NewObject<CRunScript>(memory);
    auto *slots = dc2::memory::NewArray<RS_STACKDATA>(memory, 64);
    auto *calls_storage = dc2::memory::NewArray<RS_CALLDATA>(memory, 16);
    ASSERT_NE(script, nullptr);
    ASSERT_NE(slots, nullptr);
    ASSERT_NE(calls_storage, nullptr);
    std::string handle = luau_runtime::MakeHandle("facade/basic");
    script->ext_func(ext_table, 256);
    ASSERT_TRUE(script->load({reinterpret_cast<u8 *>(handle.data()), handle.size()},
                             std::span(slots, 64), std::span(calls_storage, 16)));
    ASSERT_TRUE(script->BindRetainedTextArena(memory, std::span(slots, 64)));
    ASSERT_TRUE(luau_runtime::Owns(script));
    memory.stClearUsed();
    std::memset(storage, 0xA5, 1024 * sizeof(u_long128));
    EXPECT_FALSE(luau_runtime::Owns(script));
}

TEST_F(LuauRuntime, NativeTextRemainsBoundedAcrossNestedCallsAndRetainedCopiesOutliveCallFrames) {
    {
        std::ofstream output(root / "facade" / "text_lifetime.luau");
        output << "return {[200]=function() action.start_palette_flash(4,'outer');"
                  "action.start_palette_flash(4,'replacement') end,"
                  "[201]=function() action.call_command(200,'inner') end}";
    }
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 1024 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(storage, 1024);
    auto *slots = dc2::memory::NewArray<RS_STACKDATA>(memory, 64);
    auto *call_data = dc2::memory::NewArray<RS_CALLDATA>(memory, 16);
    ASSERT_NE(slots, nullptr);
    ASSERT_NE(call_data, nullptr);
    CRunScript  script;
    std::string handle = luau_runtime::MakeHandle("facade/text_lifetime");
    script.ext_func(ext_table, 256);
    ASSERT_TRUE(script.load({reinterpret_cast<u8 *>(handle.data()), handle.size()},
                            std::span(slots, 64), std::span(call_data, 16)));
    ASSERT_TRUE(script.BindRetainedTextArena(memory, std::span(slots, 64)));
    dc2::test::ScopedGlobalObject<native_text_probe> probe;
    probe->handle = luau_runtime::MakeHandle("facade/text_lifetime");
    probe->nested.ext_func(ext_table, 256);
    ASSERT_TRUE(probe->nested.load({reinterpret_cast<u8 *>(probe->handle.data()), probe->handle.size()},
                                   probe->slots, probe->calls));
    ASSERT_EQ(script.run(200), 0);
    EXPECT_EQ(probe->nested_saw_outer, "outer");
    EXPECT_EQ(probe->after_nested, "outer");
    ASSERT_NE(probe->retained.CString(), nullptr);
    EXPECT_STREQ(probe->retained.CString(), "outer");
    script.DeleteProgram();
    EXPECT_STREQ(probe->retained.CString(), "outer");
    memory.stClearUsed();
    EXPECT_TRUE(probe->retained.HasValue());
    EXPECT_EQ(probe->retained.CString(), nullptr);
}

TEST_F(LuauRuntime, AReusedControllerCannotReviveItsInstanceWhileTheSeparateStackRemainsLive) {
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 4096 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.SetHeapMem(storage, 4096);
    auto *controller_token = memory.StartStackMode(MG_STACK_MODE_FIRST, 0);
    ASSERT_NE(controller_token, nullptr);
    auto *script = dc2::memory::NewObject<CRunScript>(memory);
    ASSERT_NE(script, nullptr);
    // The reused heap gap needs the allocator's strict end sentinel as well as the controller bytes.
    ASSERT_NE(memory.Alloc(1), nullptr);
    memory.EndStackMode();
    auto *stack_token = memory.StartStackMode(MG_STACK_MODE_FIRST, 0);
    ASSERT_NE(stack_token, nullptr);
    auto *slots = dc2::memory::NewArray<RS_STACKDATA>(memory, 64);
    auto *call_data = dc2::memory::NewArray<RS_CALLDATA>(memory, 16);
    ASSERT_NE(slots, nullptr);
    ASSERT_NE(call_data, nullptr);
    memory.EndStackMode();
    std::string handle = luau_runtime::MakeHandle("facade/basic");
    script->ext_func(ext_table, 256);
    ASSERT_TRUE(script->load({reinterpret_cast<u8 *>(handle.data()), handle.size()},
                             std::span(slots, 64), std::span(call_data, 16)));
    ASSERT_TRUE(script->BindRetainedTextArena(memory, std::span(slots, 64)));
    ASSERT_TRUE(luau_runtime::Owns(script));
    const auto program = script->prog;
    const auto program_offset = reinterpret_cast<std::uintptr_t>(&script->prog) - reinterpret_cast<std::uintptr_t>(script);
    const auto stack_lease = dc2::memory::ArenaBuffer::Bind(memory,
                                                            {reinterpret_cast<u8 *>(slots), 64 * sizeof(RS_STACKDATA)});
    memory.Free(controller_token);
    ASSERT_EQ(memory.StartStackMode(MG_STACK_MODE_FIRST, 0), controller_token);
    const auto controller_words = dc2::memory::ArrayQuadwords<CRunScript>(1);
    ASSERT_TRUE(controller_words);
    ASSERT_EQ(memory.stack_size, *controller_words + 1);
    auto *replacement = dc2::memory::NewArray<u8>(memory, sizeof(CRunScript));
    ASSERT_EQ(replacement, reinterpret_cast<u8 *>(script));
    std::memset(replacement, 0xA5, sizeof(CRunScript));
    std::memcpy(replacement + program_offset, &program, sizeof(program));
    memory.EndStackMode();
    EXPECT_FALSE(stack_lease.Bytes().empty());
    EXPECT_FALSE(luau_runtime::Owns(script));
    memory.Free(controller_token);
    memory.Free(stack_token);
}
