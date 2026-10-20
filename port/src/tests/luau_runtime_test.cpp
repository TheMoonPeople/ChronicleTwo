#include <gtest/gtest.h>

#include <cmath>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <optional>
#include <random>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "luau_runtime.hpp"
#include "runscript.hpp"

namespace {

// Native commands the test modules call, numbered as tools/luau/commands.json lists them.
enum class NativeCommand : int {
    InitScript = 0,
    ProgSet = 1,
    ProgGet = 2,
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
int (*ext_table[256])(RS_STACKDATA *, int) = {};

void Record(NativeCommand no, RS_STACKDATA *args, int argc) {
    RecordedCall call{.no = no, .argc = argc};
    for (int i = 0; i < argc; ++i) {
        call.args.push_back(args[i]);
        if (args[i].type == RS_STR) {
            call.strings.emplace_back(args[i].val.s);
        }
    }
    calls.push_back(std::move(call));
}

int HandleInitScript(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::InitScript, args, argc);
    if (argc == 1) {
        args[0].val.p->val.i = 9;
    }
    return 1;
}

int HandleProgSet(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::ProgSet, args, argc);
    return 1;
}

int HandleProgGet(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::ProgGet, args, argc);
    if (argc >= 1) {
        args[0].val.p->val.i = next_output;
    }
    return 1;
}

int HandleGetAttkType(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::GetAttkType, args, argc);
    return 1;
}

int HandleSetMoveSpeed(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::SetMoveSpeed, args, argc);
    return 1;
}

int HandleSetPallet(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::SetPallet, args, argc);
    return 1;
}

// Scales the variables its references name, as retail's monster ScaleVector does.
int HandleMonsterScaleVector(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::MonsterScaleVector, args, argc);
    for (int i = 0; i < 3; ++i) {
        args[i].val.p->val.f *= args[3].val.f;
    }
    return 1;
}

// Writes an integer or a float by the output's tag, as retail's monster VPop copies a variable.
int HandleMonsterVPop(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::MonsterVPop, args, argc);
    RS_STACKDATA &output = *args[1].val.p;
    if (output.type == RS_FLOAT) {
        output.val.f = 2.5f;
    } else {
        output.val.i = 7;
    }
    return 1;
}

int HandleEsmSetValue(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::EsmSetValue, args, argc);
    return 1;
}

int HandleUnregistered(RS_STACKDATA *args, int argc) {
    Record(NativeCommand::Unregistered, args, argc);
    return 1;
}

void RegisterHandlers() {
    ext_table[static_cast<int>(NativeCommand::InitScript)] = HandleInitScript;
    ext_table[static_cast<int>(NativeCommand::ProgSet)] = HandleProgSet;
    ext_table[static_cast<int>(NativeCommand::ProgGet)] = HandleProgGet;
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
        script.load(reinterpret_cast<RS_PROG_HEADER *>(handle.data()), slots, 64, call_stack, 16);
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
        RegisterHandlers();
    }

    void TearDown() override {
        luau_runtime::Shutdown();
        luau_runtime::SetScriptsRoot({});
        std::error_code ec;
        std::filesystem::remove_all(root, ec);
    }

    std::filesystem::path root;
};

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
    EXPECT_EQ(luau_runtime::HandleModule(handle.data()), std::optional<std::string>("facade/basic"));

    const std::string retail("SB2\0", 4);
    EXPECT_FALSE(luau_runtime::HandleModule(retail.data()).has_value());
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
    EXPECT_FALSE(luau_runtime::ModuleForScript("map/x.stb").has_value());
    EXPECT_EQ(luau_runtime::ModuleForScript("dungeon/eff_script/menu_ice.pac/c02cold.stb"),
              std::optional<std::string>("dungeon/eff_script/menu_ice.pac/c02cold"));
    EXPECT_EQ(luau_runtime::ModuleForScript("dungeon/monster/b08a.stb"), std::optional<std::string>("dungeon/monster/b08a"));
    // Effect scripts under event/tbox are pack members; the argument scripts beside the packs are not effects.
    EXPECT_EQ(luau_runtime::ModuleForScript("event/tbox/bomb.pack/tbox_exp.stb"), std::optional<std::string>("event/tbox/bomb.pack/tbox_exp"));
    EXPECT_FALSE(luau_runtime::ModuleForScript("event/tbox/ntbox_arg.stb").has_value());
}

TEST_F(LuauRuntime, FallbackScriptsIgnoreAStaleModule) {
    // Monster Gaspard is on tools/luau/fallback.json; an old copy of its module must not bring it back to Luau.
    std::filesystem::create_directories(root / "dungeon/monster");
    std::ofstream(root / "dungeon/monster/p00_23a.luau") << "return {}\n";
    luau_runtime::SetScriptsRoot(root);
    EXPECT_FALSE(luau_runtime::ModuleForScript("dungeon/monster/p00_23a.stb").has_value());
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
    RS_PROG_HEADER program = {};
    std::memcpy(program.magic, "SB2", 3);
    RS_STACKDATA slots[64] = {};
    RS_CALLDATA  call_stack[16] = {};
    CRunScript   script;
    script.load(&program, slots, 64, call_stack, 16);

    EXPECT_FALSE(luau_runtime::Owns(&script));
    EXPECT_EQ(script.check_program(1), 0);
}
