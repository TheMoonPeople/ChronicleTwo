#include <gtest/gtest.h>

#include <algorithm>
#include <bit>
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <map>
#include <optional>
#include <string>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "runscript.hpp"
#include "script_timing.hpp"

namespace fs = std::filesystem;
using script_timing::Expected;
using script_timing::Options;
using script_timing::Result;

namespace {

// ---------------------------------------------------------------- a small SB2 assembler

constexpr int kLoad = RS_OP_LOAD, kLda = RS_OP_LOAD_ADDR, kPush = RS_OP_PUSH_CONST, kPop = RS_OP_POP, kStore = RS_OP_STORE;
constexpr int kAdd = RS_OP_ADD, kSub = RS_OP_SUB, kMul = RS_OP_MUL, kDiv = RS_OP_DIV, kItof = RS_OP_ITOF, kFtoi = RS_OP_FTOI;
constexpr int kCmp = RS_OP_CMP, kRet = RS_OP_RET, kJmp = RS_OP_JMP, kJf = RS_OP_JMP_FALSE, kCall = RS_OP_CALL, kExt = RS_OP_EXT;
constexpr int kWait = RS_OP_WAIT, kOp22 = 22;

struct I {
    int  op;
    int  a1;
    int  a2;
    int  label = -1; // jump target: instruction index in the function
    int  callee = -1;
    bool str = false;
};

I Push(int v) {
    return {kPush, RS_CONST_INT, v};
}

I PushF(float v) {
    return {kPush, RS_CONST_FLOAT, std::bit_cast<int>(v)};
}

I Load(int slot) {
    return {kLoad, slot, RS_ADDR_LOCAL};
}

I LoadF(int slot) {
    return {kLoad, slot, RS_ADDR_LOCAL_FLOAT};
}

I Lda(int slot) {
    return {kLda, slot, RS_ADDR_LOCAL};
}

I LdaF(int slot) {
    return {kLda, slot, RS_ADDR_LOCAL_FLOAT};
}

I Op(int op, int a1 = 0) {
    return {op, a1, 0};
}

I Jf(int label) {
    I i{kJf, 0, 0};
    i.label = label;
    return i;
}

I Jmp(int label) {
    I i{kJmp, 0, 0};
    i.label = label;
    return i;
}

I Call(int callee) {
    I i{kCall, 0, 0};
    i.callee = callee;
    return i;
}

// Records the value on top of the stack through external function 0.
std::vector<I> Record(std::vector<I> value) {
    std::vector<I> out = {Push(0)};
    out.insert(out.end(), value.begin(), value.end());
    out.push_back({kExt, 2, 0});
    return out;
}

struct Fn {
    int            local;
    int            arg;
    std::vector<I> code;
    std::string    data; // bytes placed after the code, addressed by PUSH-string instructions (a2 = index into data)
    int            pad_before = 0;
};

// Lays out: header, program table at 0x40, then each function's 0x38-byte block, code and data.
struct Built {
    std::vector<unsigned char> bytes;
    std::vector<std::size_t>   code_at; // header offset of each function's first instruction
};

Built Assemble(const std::vector<Fn> &fns, const std::vector<std::pair<int, int> > &programs, int main_fn) {
    const std::size_t        prog = 0x40;
    const std::size_t        code = prog + 8 * programs.size();
    std::vector<std::size_t> block(fns.size());
    std::size_t              at = code;
    for (std::size_t f = 0; f < fns.size(); ++f) {
        at += static_cast<std::size_t>(fns[f].pad_before) * 12;
        block[f] = at;
        at += 0x38 + fns[f].code.size() * 12;
        at += (fns[f].data.size() + 4) & ~std::size_t(3);
    }
    Built out;
    out.bytes.assign(at, 0);
    auto put = [&](std::size_t o, std::int32_t v) { std::memcpy(out.bytes.data() + o, &v, 4); };
    std::memcpy(out.bytes.data(), "SB2", 4);
    put(4, static_cast<std::int32_t>(block[main_fn]));
    put(8, static_cast<std::int32_t>(code));
    put(12, static_cast<std::int32_t>(prog));
    put(16, static_cast<std::int32_t>(programs.size()));
    for (std::size_t p = 0; p < programs.size(); ++p) {
        put(prog + 8 * p, programs[p].first);
        put(prog + 8 * p + 4, static_cast<std::int32_t>(block[programs[p].second]));
    }
    for (std::size_t f = 0; f < fns.size(); ++f) {
        const std::size_t first = block[f] + 0x38;
        out.code_at.push_back(first);
        put(block[f], static_cast<std::int32_t>(first - code));
        put(block[f] + 8, fns[f].local);
        put(block[f] + 12, fns[f].arg);
        const std::size_t data = first + fns[f].code.size() * 12;
        std::memcpy(out.bytes.data() + data, fns[f].data.data(), fns[f].data.size());
        for (std::size_t k = 0; k < fns[f].code.size(); ++k) {
            const I &i = fns[f].code[k];
            int      a1 = i.a1;
            int      a2 = i.a2;
            if (i.label >= 0) {
                a1 = static_cast<int>(first + static_cast<std::size_t>(i.label) * 12 - code);
            }
            if (i.callee >= 0) {
                a2 = static_cast<int>(block[i.callee] - code);
            }
            if (i.str) {
                a2 = static_cast<int>(data + static_cast<std::size_t>(i.a2) - code);
            }
            put(first + k * 12, i.op);
            put(first + k * 12 + 4, a1);
            put(first + k * 12 + 8, a2);
        }
    }
    return out;
}

std::vector<I> Join(std::initializer_list<std::vector<I> > parts) {
    std::vector<I> out;
    for (const auto &part : parts) {
        out.insert(out.end(), part.begin(), part.end());
    }
    return out;
}

// ---------------------------------------------------------------- running a program

std::vector<RS_STACKDATA> recorded;

int RecordExt(RS_STACKDATA *args, int count) {
    if (count >= 1) {
        recorded.push_back(args[0]);
    }
    return 1;
}

struct VmRun {
    int                       waits = 0;
    std::vector<RS_STACKDATA> values;
};

VmRun Execute(std::vector<unsigned char> bytes, int program) {
    recorded.clear();
    static int (*table[1])(RS_STACKDATA *, int) = {RecordExt};
    std::vector<RS_STACKDATA> stack(256);
    std::vector<RS_CALLDATA>  calls(64);
    CRunScript                vm;
    vm.load(reinterpret_cast<RS_PROG_HEADER *>(bytes.data()), stack.data(), 256, calls.data(), 64);
    vm.ext_func(table, 1);
    VmRun run;
    if (vm.run(program) == 1) {
        run.waits++;
        for (int guard = 0; !vm.end && guard < 10000; ++guard) {
            vm.resume();
            if (!vm.end) {
                run.waits++;
            }
        }
    }
    run.values = recorded;
    return run;
}

int IntAt(const VmRun &run, std::size_t i) {
    EXPECT_LT(i, run.values.size());
    EXPECT_EQ(run.values[i].type, RS_INT);
    return run.values[i].val.i;
}

float FloatAt(const VmRun &run, std::size_t i) {
    EXPECT_LT(i, run.values.size());
    EXPECT_EQ(run.values[i].type, RS_FLOAT);
    return run.values[i].val.f;
}

Expected Want(std::initializer_list<std::pair<script_timing::Recipe, int> > recipes, int anchors = 0, int windows = 0) {
    Expected e{"synthetic", {}, static_cast<std::uint8_t>(anchors), static_cast<std::uint8_t>(windows)};
    for (auto [recipe, count] : recipes) {
        e.recipes[recipe] = static_cast<std::uint16_t>(count);
    }
    return e;
}

Result Convert(const std::string &key, std::vector<unsigned char> &bytes, const Expected &want) {
    Options options;
    options.expected = &want;
    return script_timing::Apply(key, bytes.data(), bytes.size(), options);
}

// The event library's wait(n): PAL form, n + 1 resumes.
Fn EventWait() {
    return {
        1,
        1,
        {Load(0), Push(0), Op(kCmp, RS_CMP_GT), Jf(12),
          Lda(0), Load(0), Push(50), Op(kMul), Push(60), Op(kDiv), Op(kStore), Op(kPop),
          Op(kOp22, 0), Load(0), Push(0), Op(kCmp, RS_CMP_GE), Jf(25),
          Lda(0), Load(0), Push(1), Op(kSub), Op(kStore), Op(kPop), Op(kWait), Jmp(12),
          Op(kOp22, 1), Push(0), Op(kRet)}
    };
}

// The monster converter conv(n) = ftoi(itof(n) / 30.0f * 25.0f).
Fn MonsterConvert() {
    return {
        1, 1, {Load(0), Op(kItof), PushF(30.0f), Op(kDiv), PushF(25.0f), Op(kMul), Op(kFtoi), Op(kRet)}
    };
}

// The integer wait(n) of b14a/rin: n = (n / 30) * 25, then n resumes.
Fn IntegerWait() {
    return {
        2,
        1,
        {Lda(0), Load(0), Push(30), Op(kDiv), Push(25), Op(kMul), Op(kStore), Op(kPop),
          Lda(1), Push(0), Op(kStore), Op(kPop),
          Op(kOp22, 0), Load(1), Load(0), Op(kCmp, RS_CMP_LT), Jf(25),
          Op(kWait), Lda(1), Load(1), Push(1), Op(kAdd), Op(kStore), Op(kPop), Jmp(12), Op(kOp22, 1),
          Push(0), Op(kRet)}
    };
}

std::vector<I> ReturnZero() {
    return {Push(0), Op(kRet)};
}

} // namespace

TEST(ScriptTiming, Op22MarkerIsANoOp) {
    // Opcode 22 has no case in CRunScript::exe(): the patcher's marker must leave stacks and flow alone.
    Fn prog{
        0, 0, Join({Record({Push(7), {kOp22, 0x4E544D54, 0x02030004}, Op(kOp22, 5)}), Record({Push(9)}), ReturnZero()}
          )
    };

    auto built = Assemble({
                              prog
    },
                          {{100, 0}}, 0);

    VmRun run = Execute(built.bytes, 100);
    ASSERT_EQ(run.values.size(), 2u);
    EXPECT_EQ(IntAt(run, 0), 7);
    EXPECT_EQ(IntAt(run, 1), 9);
    EXPECT_EQ(run.waits, 0);
}

TEST(ScriptTiming, EventWaitHelperRunsNtscFields) {
    Fn prog{
        0, 0, Join({{Push(30), Call(1), Op(kPop)}, ReturnZero()}
          )
    };

    auto built = Assemble({
                              prog, EventWait()
    },
                          {{100, 0}}, 0);

    EXPECT_EQ(Execute(built.bytes, 100).waits, 26); // PAL: (30 * 50) / 60 + 1

    auto bytes = built.bytes;
    auto result = Convert("map/x/x01_1.stb", bytes, Want({
                                                        {script_timing::kEventAssign, 1}
    }));
    ASSERT_TRUE(result.ok) << result.error;
    EXPECT_EQ(result.writes, 4);
    EXPECT_EQ(bytes.size(), built.bytes.size());
    EXPECT_EQ(Execute(bytes, 100).waits, 31); // NTSC: 30 + 1

    // A second pass recognises its own markers and writes nothing.
    auto again = bytes;
    auto second = Convert("map/x/x01_1.stb", again, Want({
                                                        {script_timing::kEventAssign, 1}
    }));
    ASSERT_TRUE(second.ok) << second.error;
    EXPECT_EQ(second.writes, 0);
    EXPECT_EQ(second.counts, result.counts);
    EXPECT_EQ(again, bytes);
}

TEST(ScriptTiming, MonsterConvertBecomesIdentityAndKeepsIntegers) {
    Fn prog{
        1, 0, Join({Record({Push(7), Call(1)}), Record({Push(8), Call(1)}), Record({Push(10), Call(1)}), Record({Push(12), Call(1)}), {Lda(0), Push(9), Op(kStore), Op(kPop)}, Record({Load(0), Call(1)}), Record({PushF(8.75f), Call(1)}), ReturnZero()}
          )
    };

    auto built = Assemble({
                              prog, MonsterConvert()
    },
                          {{100, 0}}, 0);

    VmRun pal = Execute(built.bytes, 100);
    ASSERT_EQ(pal.values.size(), 6u);
    EXPECT_EQ(IntAt(pal, 0), 5);
    EXPECT_EQ(IntAt(pal, 1), 6);
    EXPECT_EQ(IntAt(pal, 2), 8);
    EXPECT_EQ(IntAt(pal, 3), 10);
    EXPECT_EQ(IntAt(pal, 4), 7);
    EXPECT_EQ(IntAt(pal, 5), 7);

    auto bytes = built.bytes;
    auto result = Convert("dungeon/monster/x.stb", bytes, Want({
                                                              {script_timing::kMonsterConvert, 1}
    }));
    ASSERT_TRUE(result.ok) << result.error;
    EXPECT_EQ(result.writes, 5);
    VmRun ntsc = Execute(bytes, 100);
    ASSERT_EQ(ntsc.values.size(), 6u);
    EXPECT_EQ(IntAt(ntsc, 0), 7);
    EXPECT_EQ(IntAt(ntsc, 1), 8);
    EXPECT_EQ(IntAt(ntsc, 2), 10);
    EXPECT_EQ(IntAt(ntsc, 3), 12);
    EXPECT_EQ(IntAt(ntsc, 4), 9);
    EXPECT_EQ(IntAt(ntsc, 5), 8); // FTOI stays: a float argument still truncates to the integer callers expect
}

TEST(ScriptTiming, ConvertIsOnlyRecognisedAsAWholeHelper) {
    // The same six instructions inside a larger function are not the converter helper.
    Fn prog{
        1, 1, Join({{Load(0), Op(kItof), PushF(30.0f), Op(kDiv), PushF(25.0f), Op(kMul), Op(kFtoi), Op(kPop)}, ReturnZero()}
          )
    };

    auto built = Assemble({
                              prog
    },
                          {{100, 0}}, 0);

    auto bytes = built.bytes;
    auto result = Convert("dungeon/monster/x.stb", bytes, Want({}));
    ASSERT_TRUE(result.ok) << result.error;
    EXPECT_EQ(result.writes, 0);
    EXPECT_EQ(bytes, built.bytes);
}

TEST(ScriptTiming, IntegerHelpersKeepShortWaits) {
    Fn prog{
        0, 0, Join({{Push(8), Call(1), Op(kPop)}, Record({Push(40), Push(30), Op(kDiv), Push(25), Op(kMul)}), ReturnZero()}
          )
    };

    auto built = Assemble({
                              prog, IntegerWait()
    },
                          {{100, 0}}, 0);

    VmRun pal = Execute(built.bytes, 100);
    EXPECT_EQ(pal.waits, 0); // (8 / 30) * 25 = 0
    EXPECT_EQ(IntAt(pal, 0), 25);

    auto bytes = built.bytes;
    auto result = Convert("dungeon/eff_script/x.stb", bytes, Want({
                                                                 {script_timing::kInteger3025, 2}
    }));
    ASSERT_TRUE(result.ok) << result.error;
    VmRun ntsc = Execute(bytes, 100);
    EXPECT_EQ(ntsc.waits, 8);
    EXPECT_EQ(IntAt(ntsc, 0), 40);
}

TEST(ScriptTiming, EventInlineSitesAndTheLipSyncCue) {
    // cue(l0, l1, l2): PAL scales the timeout l1, then sets the cue l2 from the scaled l1.
    Fn cue{
        3, 3, Join({{Load(1), Push(0), Op(kCmp, RS_CMP_GT), Jf(12), Lda(1), Load(1), Push(50), Op(kMul), Push(60), Op(kDiv), Op(kStore), Op(kPop), Op(kOp22, 0), Load(2), Push(0), Op(kCmp, RS_CMP_GT), Jf(25), Lda(2), Load(1), Push(50), Op(kMul), Push(60), Op(kDiv), Op(kStore), Op(kPop), Op(kOp22, 1)}, Record({Load(1)}), Record({Load(2)}), ReturnZero()}
          )
    };
    // A loop of (45 * 50) / 60 resumes and a variable argument (l1 * 50) / 60.
    Fn prog{
        2, 0, Join({{Lda(0), Push(0), Op(kStore), Op(kPop), Op(kOp22, 0), Load(0), Push(45), Push(50), Op(kMul), Push(60), Op(kDiv), Op(kCmp, RS_CMP_LT), Jf(21), Op(kWait), Lda(0), Load(0), Push(1), Op(kAdd), Op(kStore), Op(kPop), Jmp(4), Op(kOp22, 1), Lda(1), Push(36), Op(kStore), Op(kPop)}, Record({Load(1), Push(50), Op(kMul), Push(60), Op(kDiv)}), {Push(0), Push(90), Push(30), Call(1), Op(kPop)}, ReturnZero()}
          )
    };

    auto built = Assemble({
                              prog, cue
    },
                          {{100, 0}}, 0);

    VmRun pal = Execute(built.bytes, 100);
    EXPECT_EQ(pal.waits, 37);
    ASSERT_EQ(pal.values.size(), 3u);
    EXPECT_EQ(IntAt(pal, 0), 30);
    EXPECT_EQ(IntAt(pal, 1), 75);
    EXPECT_EQ(IntAt(pal, 2), 62);

    auto bytes = built.bytes;
    auto result = Convert("map/x/x01_1.stb", bytes, Want({
                                                        {script_timing::kEventAssign, 1},
                                                        {script_timing::kEventCue,    1},
                                                        {script_timing::kEventInline, 2}
    }));
    ASSERT_TRUE(result.ok) << result.error;
    EXPECT_EQ(result.writes, 4 + 8 + 4 + 4);
    VmRun ntsc = Execute(bytes, 100);
    EXPECT_EQ(ntsc.waits, 45);
    ASSERT_EQ(ntsc.values.size(), 3u);
    EXPECT_EQ(IntAt(ntsc, 0), 36);
    EXPECT_EQ(IntAt(ntsc, 1), 90);
    EXPECT_EQ(IntAt(ntsc, 2), 30); // the cue keeps the value the caller passed
}

TEST(ScriptTiming, FloatAndInverseForms) {
    Fn prog{0, 0, Join({Record({PushF(30.0f), PushF(50.0f), Op(kMul), PushF(60.0f), Op(kDiv)}), Record({Push(121), Push(60), Op(kDiv), Push(50), Op(kMul)}), Record({PushF(0.8f), PushF(120.0f), Op(kDiv), PushF(60.0f), Op(kDiv), PushF(50.0f), Op(kMul)}), ReturnZero()})};

    auto built = Assemble({
                              prog
    },
                          {{100, 0}}, 0);

    VmRun pal = Execute(built.bytes, 100);
    EXPECT_FLOAT_EQ(FloatAt(pal, 0), 25.0f);
    EXPECT_EQ(IntAt(pal, 1), 100);

    auto bytes = built.bytes;
    auto result = Convert("map/x/x01_1.stb", bytes,
                          Want({
                              {script_timing::kEventInlineFloat,  1},
                              {script_timing::kEventInverse,      1},
                              {script_timing::kEventInverseFloat, 1}
    }));
    ASSERT_TRUE(result.ok) << result.error;
    VmRun ntsc = Execute(bytes, 100);
    EXPECT_FLOAT_EQ(FloatAt(ntsc, 0), 30.0f);
    EXPECT_EQ(IntAt(ntsc, 1), 121);
    EXPECT_FLOAT_EQ(FloatAt(ntsc, 2), 0.8f / 120.0f);
}

TEST(ScriptTiming, NearMissesAndStringBytesAreLeftAlone) {
    // The data after the function holds the exact bytes of PUSH 50; MUL; PUSH 60; DIV.
    std::string        pattern(48, '\0');
    const std::int32_t words[12] = {kPush, 1, 50, kMul, 0, 0, kPush, 1, 60, kDiv, 0, 0};
    std::memcpy(pattern.data(), words, sizeof words);
    I str{kPush, RS_CONST_STR, 0};
    str.str = true;
    Fn prog{
        0, 0, Join({{str, Op(kPop)}, Record({Push(9), Push(50), Op(kMul), Push(61), Op(kDiv)}), Record({Push(9), PushF(50.0f), Op(kMul), Push(60), Op(kDiv)}), Record({Push(9), Push(50), Op(kOp22, 3), Op(kMul), Push(60), Op(kDiv)}), ReturnZero()}
          ),
        pattern
    };

    auto built = Assemble({
                              prog
    },
                          {{100, 0}}, 0);

    auto bytes = built.bytes;
    auto result = Convert("map/x/x01_1.stb", bytes, Want({}));
    ASSERT_TRUE(result.ok) << result.error;
    EXPECT_EQ(result.writes, 0);
    EXPECT_EQ(bytes, built.bytes);

    // Expecting a site that is not there refuses the file and writes nothing.
    auto refused = Convert("map/x/x01_1.stb", bytes, Want({
                                                         {script_timing::kEventInline, 1}
    }));
    EXPECT_FALSE(refused.ok);
    EXPECT_EQ(bytes, built.bytes);
}

TEST(ScriptTiming, InvalidScriptsAreRefused) {
    Fn prog{
        0, 0, Join({{Push(30), Call(1), Op(kPop)}, ReturnZero()}
          )
    };

    auto built = Assemble({
                              prog, EventWait()
    },
                          {{100, 0}}, 0);

    const Expected want = Want({
        {script_timing::kEventAssign, 1}
    });

    auto refused = [&](std::vector<unsigned char> bytes, const char *what) {
        const auto before = bytes;
        auto       result = Convert("map/x/x01_1.stb", bytes, want);
        EXPECT_FALSE(result.ok) << what;
        EXPECT_FALSE(result.decoded) << what;
        EXPECT_EQ(bytes, before) << what;
    };
    refused(std::vector<unsigned char>(built.bytes.begin(), built.bytes.end() - 20), "truncated in an instruction");
    refused(std::vector<unsigned char>(built.bytes.begin(), built.bytes.begin() + 0x10), "truncated header");
    auto         bad = built.bytes;
    std::int32_t far = 0x7FFFFF00;
    std::memcpy(bad.data() + 8, &far, 4);
    refused(bad, "code offset past the end");
    bad = built.bytes;
    std::memcpy(bad.data() + 16, &far, 4);
    refused(bad, "program table past the end");
    bad = built.bytes;
    std::memcpy(bad.data() + built.code_at[1] + 3 * 12 + 4, &far, 4); // the helper's first JF
    refused(bad, "jump target past the end");
    bad = built.bytes;
    std::memcpy(bad.data() + 0x40 + 4, &far, 4);
    refused(bad, "program entry past the end");

    // An unknown file that is not a valid script is passed through unchanged.
    std::vector<unsigned char> junk(64, 0xAB);
    auto                       result = script_timing::Apply("map/x/unknown.stb", junk.data(), junk.size());
    EXPECT_TRUE(result.ok);
    EXPECT_FALSE(result.decoded);
}

TEST(ScriptTiming, LanguageAnchorsWriteNtscLiteralsOnce) {
    // s03: a turn of (pi/20) * 1.2 per resume over a 33-resume loop; NTSC turns pi/20 over 40.
    Fn prog{
        4, 0, Join({{LdaF(2), PushF(0.0f), Op(kStore), Op(kPop), Lda(3), Push(0), Op(kStore), Op(kPop), Op(kOp22, 0), Load(3), Push(33), Op(kCmp, RS_CMP_LT), Jf(31), LdaF(2), LoadF(2), {kPush, RS_CONST_FLOAT, 0x40490fdb}, PushF(20.0f), Op(kDiv), PushF(1.2f), Op(kMul), Op(kAdd), Op(kStore), Op(kPop), Op(kWait), Lda(3), Load(3), Push(1), Op(kAdd), Op(kStore), Op(kPop), Jmp(8), Op(kOp22, 1)}, Record({LoadF(2)}), ReturnZero()}
          )
    };

    auto built = Assemble({
                              prog
    },
                          {{100, 0}}, 0);

    VmRun pal = Execute(built.bytes, 100);
    EXPECT_EQ(pal.waits, 33);

    for (const char *key : {"map/s/s03/s03_1.stb", "map/s/s03/s03_4.stb"}) {
        auto bytes = built.bytes;
        auto result = Convert(key, bytes, Want({}, 2));
        ASSERT_TRUE(result.ok) << key << ": " << result.error;
        EXPECT_EQ(result.counts.anchors, 2);
        EXPECT_EQ(result.writes, 3);
        VmRun ntsc = Execute(bytes, 100);
        EXPECT_EQ(ntsc.waits, 40);
        EXPECT_NEAR(FloatAt(ntsc, 0), 2.0f * 3.1415927f, 1e-4f);
        auto again = bytes;
        auto second = Convert(key, again, Want({}, 2));
        ASSERT_TRUE(second.ok) << second.error;
        EXPECT_EQ(second.writes, 0);
        EXPECT_EQ(again, bytes);
    }
    // The stem without a language digit, or another map, is not anchored.
    auto bytes = built.bytes;
    EXPECT_TRUE(Convert("map/s/s03/s03.stb", bytes, Want({})).ok);
    EXPECT_FALSE(Convert("map/s/s03/s03_1.stb", bytes, Want({}, 1)).ok);
}

TEST(ScriptTiming, AttackWindowsUseNtscBounds) {
    // c02's two special-shot window ends sit at 0xb308 and 0xb3bc in the PAL script. Two program entries
    // put the function's instructions on that 12-byte grid.
    const std::vector<std::pair<int, int> > programs = {
        {100, 0},
        {101, 0}
    };
    const std::size_t code_at = Assemble({
                                             {0, 0, {Op(kOp22)}}
    },
                                         programs, 0)
                                    .code_at[0];
    ASSERT_EQ((0xb308 - code_at) % 12, 0u);
    std::vector<I> code;
    auto           fill_to = [&](std::size_t offset) { code.resize((offset - code_at) / 12, Op(kOp22, 0)); };
    fill_to(0xb308 - 12);
    for (I i : {PushF(0.4f), PushF(0.48f), Op(kCmp, RS_CMP_LE), Op(kPop)}) {
        code.push_back(i);
    }
    fill_to(0xb3bc - 12);
    for (I i : {PushF(0.4f), PushF(0.45f), Op(kCmp, RS_CMP_LE), Op(kPop), Push(0), Op(kRet)}) {
        code.push_back(i);
    }

    auto built = Assemble({
                              {0, 0, code}
    },
                          programs, 0);

    ASSERT_EQ(built.code_at[0], code_at);
    Execute(built.bytes, 100);

    auto ntsc = built.bytes;
    auto result = Convert("mainchr/c02.stb", ntsc, Want({}, 0, 2));
    ASSERT_TRUE(result.ok) << result.error;
    EXPECT_EQ(result.writes, 2);
    float value;
    std::memcpy(&value, ntsc.data() + 0xb308 + 8, 4);
    EXPECT_EQ(value, 0.45f);
    std::memcpy(&value, ntsc.data() + 0xb3bc + 8, 4);
    EXPECT_EQ(value, 0.42f);

    auto again = ntsc;
    auto second = Convert("mainchr/c02.stb", again, Want({}, 0, 2));
    ASSERT_TRUE(second.ok) << second.error;
    EXPECT_EQ(second.writes, 0);
    EXPECT_EQ(again, ntsc);
}

TEST(ScriptTiming, InventoryRowsAreSortedAndKnownScriptsAreRefused) {
    EXPECT_GT(script_timing::InventorySize(), 0u);
    ASSERT_NE(script_timing::Find("map/s/s01/s01_1.stb"), nullptr);
    ASSERT_NE(script_timing::Find("map/s/s01/s01_5.stb"), nullptr);
    EXPECT_EQ(script_timing::Find("map/s/s01/s01.stb"), nullptr);
    EXPECT_EQ(script_timing::Key("MAP\\S\\S01\\S01_1.STB"), "map/s/s01/s01_1.stb");
    // A known script whose bytes are not the PAL release's is refused, without writing.
    Fn prog{0, 0, ReturnZero()};

    auto built = Assemble({
                              prog
    },
                          {{100, 0}}, 0);

    auto bytes = built.bytes;
    EXPECT_FALSE(script_timing::Patch("map/s/s01/s01_1.stb", bytes.data(), bytes.size()));
    EXPECT_EQ(bytes, built.bytes);
    // An unknown script without conversions passes; one with a conversion is refused.
    EXPECT_TRUE(script_timing::Patch("map/x/x99_1.stb", bytes.data(), bytes.size()));
    auto wait = Assemble({
                             {0, 0, Join({{Push(3), Call(1), Op(kPop)}, ReturnZero()})},
                             EventWait()
    },
                         {{100, 0}}, 0);
    auto unknown = wait.bytes;
    EXPECT_FALSE(script_timing::Patch("map/x/x99_1.stb", unknown.data(), unknown.size()));
    EXPECT_EQ(unknown, wait.bytes);
}

namespace {

constexpr const char *kStartupScript = "dungeon/eff_script/b02a_hibasira.stb";

Built StartupScript() {
    return Assemble({
                        {0, 0, Join({Record({Push(40), Push(30), Op(kDiv), Push(25), Op(kMul)}), ReturnZero()})}
    },
                    {{100, 0}}, 0);
}

class ScriptTimingStartup : public testing::Test {
protected:
    fs::path            base = fs::temp_directory_path() / ("script_timing_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    fs::path            root = base / "data";

    void SetUp() override {
        InitFileCache(nullptr, FILE_CACHE_NONE);
        SetCurrentDir(nullptr);
    }

    void TearDown() override {
        std::error_code error;
        fs::remove_all(base, error);
    }

    void Write(const fs::path &path, const std::vector<unsigned char> &bytes) {
        fs::create_directories(path.parent_path());
        std::ofstream out(path, std::ios::binary);
        out.write(reinterpret_cast<const char *>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
    }

    void Replace(const std::vector<unsigned char> &bytes) {
        Write(root / kStartupScript, StartupScript().bytes);
        Write(base / "datapacks/test" / kStartupScript, bytes);
        std::ofstream(base / "datapacks/datapacks.json") << R"({"schema_version":1,"load_order":["test"]})";
    }

    std::vector<unsigned char> Load() {
        std::string name = std::string("/") + kStartupScript;
        int         size = 0;
        EXPECT_EQ(LoadFile2(name.data(), nullptr, &size, LOAD_FILE_SIZE), 1);
        std::vector<unsigned char> bytes((static_cast<std::size_t>(size) + DATAREAD_SECTOR_SIZE - 1) &
                                         ~std::size_t(DATAREAD_SECTOR_SIZE - 1));
        EXPECT_EQ(LoadFile2(name.data(), bytes.data(), &size, LOAD_FILE_READ), 1);
        bytes.resize(static_cast<std::size_t>(size));
        return bytes;
    }
};

} // namespace

TEST_F(ScriptTimingStartup, HeadlessExtractedMismatchRefusesStartup) {
    const auto bad = Assemble({
                                  {0, 0, ReturnZero()}
    },
                              {{100, 0}}, 0)
                         .bytes;
    Write(root / kStartupScript, bad);
    DataReadIndex(root);
    const auto report = DataReadValidateScriptTiming();
    EXPECT_EQ(report.files, 1u);
    ASSERT_EQ(report.errors.size(), 1u);
    EXPECT_NE(report.errors[0].find(kStartupScript), std::string::npos);
    testing::internal::CaptureStderr();
    EXPECT_FALSE(DataReadPrepareScriptTiming(true));
    const auto log = testing::internal::GetCapturedStderr();
    EXPECT_NE(log.find(kStartupScript), std::string::npos);
    EXPECT_NE(log.find("refusing startup"), std::string::npos);
}

TEST_F(ScriptTimingStartup, MatchingDatapackIsValidatedAndConverted) {
    const auto original = StartupScript().bytes;
    Replace(original);
    DataReadIndex(root);
    const auto report = DataReadValidateScriptTiming();
    EXPECT_EQ(report.files, 1u);
    EXPECT_TRUE(report.errors.empty());
    EXPECT_TRUE(DataReadPrepareScriptTiming(true));
    auto expected = original;
    ASSERT_TRUE(script_timing::Apply(kStartupScript, expected.data(), expected.size()).ok);
    EXPECT_NE(expected, original);
    EXPECT_EQ(Load(), expected);
    std::ifstream                    disk(base / "datapacks/test" / kStartupScript, std::ios::binary);
    const std::vector<unsigned char> unchanged((std::istreambuf_iterator<char>(disk)), {});
    EXPECT_EQ(unchanged, original);
}

TEST_F(ScriptTimingStartup, HeadlessMismatchingDatapackRefusesStartup) {
    // The replacement changed PAL's divisor, so the known recipe no longer matches.
    auto      bad = StartupScript();
    const int divisor = 31;
    std::memcpy(bad.bytes.data() + bad.code_at[0] + 2 * 12 + 8, &divisor, sizeof divisor);
    Replace(bad.bytes);
    DataReadIndex(root);
    const auto report = DataReadValidateScriptTiming();
    ASSERT_EQ(report.errors.size(), 1u);
    EXPECT_NE(report.errors[0].find(std::string(kStartupScript) + " [datapack]"), std::string::npos);
    testing::internal::CaptureStderr();
    EXPECT_FALSE(DataReadPrepareScriptTiming(true));
    const auto log = testing::internal::GetCapturedStderr();
    EXPECT_NE(log.find(std::string(kStartupScript) + " [datapack]"), std::string::npos);
}

TEST_F(ScriptTimingStartup, UnlistedUndecodableScriptStaysUnchangedAndWarnsOnce) {
    const std::vector<unsigned char> bytes{'n', 'o', 't', ' ', 'S', 'B', '2'};
    Write(root / "unknown-undecodable.stb", bytes);
    DataReadIndex(root);
    testing::internal::CaptureStderr();
    EXPECT_TRUE(DataReadValidateScriptTiming().errors.empty());
    EXPECT_TRUE(DataReadValidateScriptTiming().errors.empty());
    EXPECT_TRUE(DataReadPrepareScriptTiming(true));
    const auto log = testing::internal::GetCapturedStderr();
    const auto first = log.find("warning: unknown-undecodable.stb");
    ASSERT_NE(first, std::string::npos);
    EXPECT_EQ(log.find("warning: unknown-undecodable.stb", first + 1), std::string::npos);
    std::string               name = "/unknown-undecodable.stb";
    alignas(64) unsigned char loaded[DATAREAD_SECTOR_SIZE]{};
    int                       size = 0;
    ASSERT_EQ(LoadFile2(name.data(), loaded, &size, LOAD_FILE_READ), 1);
    EXPECT_EQ(size, static_cast<int>(bytes.size()));
    EXPECT_EQ(std::vector<unsigned char>(loaded, loaded + size), bytes);
}

TEST_F(ScriptTimingStartup, UnlistedConversionsAreReportedOnEveryValidation) {
    const auto unknown = Assemble({
                                      {0, 0, Join({{Push(3), Call(1), Op(kPop)}, ReturnZero()})},
                                      EventWait()
    },
                                  {{100, 0}}, 0);
    Write(root / "map/x/x99_1.stb", unknown.bytes);
    Write(root / "not-a-script.bin", unknown.bytes);
    DataReadIndex(root);
    auto report = DataReadValidateScriptTiming();
    EXPECT_EQ(report.files, 1u);
    ASSERT_EQ(report.errors.size(), 1u);
    EXPECT_NE(report.errors[0].find("map/x/x99_1.stb"), std::string::npos);
    report = DataReadValidateScriptTiming();
    EXPECT_EQ(report.files, 1u);
    ASSERT_EQ(report.errors.size(), 1u);
    EXPECT_NE(report.errors[0].find("map/x/x99_1.stb"), std::string::npos);
    EXPECT_FALSE(DataReadPrepareScriptTiming(true));
}

TEST_F(ScriptTimingStartup, EachAssetLogsOnlyOnceAcrossReloads) {
    auto first = StartupScript().bytes;
    auto second = first;
    testing::internal::CaptureStderr();
    EXPECT_TRUE(script_timing::Patch("dungeon/eff_script/m_curse_h.stb", first.data(), first.size()));
    EXPECT_TRUE(script_timing::Patch("DUNGEON/eff_script/m_curse_h.stb", second.data(), second.size()));
    EXPECT_TRUE(script_timing::Patch("dungeon/eff_script/m_curse_h.stb", second.data(), second.size()));
    const auto log = testing::internal::GetCapturedStderr();
    EXPECT_EQ(std::count(log.begin(), log.end(), '\n'), 1);
    EXPECT_EQ(first, second);
}

// ---------------------------------------------------------------- real data

namespace {

struct DataScripts {
    fs::path                 root;
    std::vector<std::string> keys;
};

std::optional<DataScripts> ReadScripts() {
    const char *data = std::getenv("DC2_DATA");
    if (!data || !fs::is_directory(data)) {
        return std::nullopt;
    }
    DataReadIndex(fs::path(data));
    InitFileCache(nullptr, FILE_CACHE_NONE);
    SetCurrentDir(nullptr);
    return DataScripts{fs::path(data), DataReadScriptKeys()};
}

const std::optional<DataScripts> &Scripts() {
    // The index and key list are shared by all real-data cases in this binary.
    static const auto scripts = ReadScripts();
    return scripts;
}

std::vector<unsigned char> ReadAll(const fs::path &path) {
    std::ifstream              in(path, std::ios::binary | std::ios::ate);
    std::vector<unsigned char> bytes(static_cast<std::size_t>(in.tellg()));
    in.seekg(0);
    in.read(reinterpret_cast<char *>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
    return bytes;
}

// The shard a script belongs to; each shard's case stays well inside the per-case time limit.
std::string ShardOf(const std::string &key) {
    const bool event = key.starts_with("map/") || key.starts_with("event/");
    if (event && key.size() > 6 && key[key.size() - 6] == '_' && key[key.size() - 5] >= '2' && key[key.size() - 5] <= '5') {
        const bool first_half = key.starts_with("map/d/") || key.starts_with("map/f/") || key.starts_with("map/g/");
        return std::string("language") + key[key.size() - 5] + (first_half ? "a" : "b");
    }
    for (const char *prefix : {"map/d/", "map/f/", "map/g/", "map/i/", "map/m/", "map/s/"}) {
        if (key.starts_with(prefix)) {
            return std::string(prefix);
        }
    }
    if (event) {
        return "event";
    }
    for (const char *prefix : {"dungeon/monster/", "dungeon/eff_script/"}) {
        if (key.starts_with(prefix)) {
            return std::string(prefix);
        }
    }
    return "other";
}

// Every script of a shard decodes, shows exactly the inventory's counts, converts with an unchanged size
// and to the same bytes again. The loader always hands out the converted NTSC bytes.
void CheckShard(const std::string &shard) {
    const auto &scripts = Scripts();
    if (!scripts) {
        GTEST_SKIP() << "DC2_DATA supplies the extracted scripts";
    }

    std::map<std::string, long> totals;
    int                         files = 0;
    int                         known = 0;
    std::vector<unsigned char>  buffer;
    for (const std::string &key : scripts->keys) {
        if (ShardOf(key) != shard) {
            continue;
        }
        files++;
        const auto original = ReadAll(scripts->root / key);
        auto       bytes = original;
        Options    options;
        auto result = script_timing::Apply(key, bytes.data(), bytes.size(), options);
        EXPECT_TRUE(result.decoded) << key << ": " << result.error;
        EXPECT_TRUE(result.ok) << key << ": " << result.error;
        ASSERT_EQ(bytes.size(), original.size());
        if (result.known) {
            known++;
            EXPECT_GT(result.writes, 0) << key;
        } else {
            EXPECT_EQ(result.writes, 0) << key;
        }
        std::size_t changed_words = 0;
        for (std::size_t i = 0; i + 4 <= bytes.size(); i += 4) {
            changed_words += std::memcmp(bytes.data() + i, original.data() + i, 4) != 0;
        }
        EXPECT_LE(changed_words, static_cast<std::size_t>(result.writes) * 3) << key;
        EXPECT_EQ(changed_words == 0, result.writes == 0) << key;
        if (result.known) {
            auto again = bytes;
            auto second = script_timing::Apply(key, again.data(), again.size(), options);
            EXPECT_TRUE(second.ok) << key << ": " << second.error;
            EXPECT_EQ(second.writes, 0) << key;
            EXPECT_EQ(second.counts, result.counts) << key;
            EXPECT_EQ(again, bytes) << key;
        }
        for (int r = 0; r < script_timing::kRecipeCount; ++r) {
            totals["recipe" + std::to_string(r)] += result.counts.recipes[r];
        }
        totals["anchors"] += result.counts.anchors;
        totals["windows"] += result.counts.windows;
        totals["writes"] += result.writes;

        buffer.assign((original.size() + 2 * DATAREAD_SECTOR_SIZE) & ~std::size_t(DATAREAD_SECTOR_SIZE - 1), 0);
        std::string name = "/" + key;
        int         size = 0;
        ASSERT_EQ(LoadFile2(name.data(), buffer.data(), &size, LOAD_FILE_READ), 1) << key;
        ASSERT_EQ(static_cast<std::size_t>(size), bytes.size()) << key;
        EXPECT_EQ(std::memcmp(buffer.data(), bytes.data(), bytes.size()), 0) << key << ": NTSC loader bytes differ";
    }
    EXPECT_GT(files, 0);
    std::printf("shard %s: %d scripts, %d known;", shard.c_str(), files, known);
    for (const auto &[name, value] : totals) {
        std::printf(" %s %ld", name.c_str(), value);
    }
    std::printf("\n");
}

} // namespace

TEST(ScriptTimingRealData, MapD) {
    CheckShard("map/d/");
}

TEST(ScriptTimingRealData, MapF) {
    CheckShard("map/f/");
}

TEST(ScriptTimingRealData, MapG) {
    CheckShard("map/g/");
}

TEST(ScriptTimingRealData, MapI) {
    CheckShard("map/i/");
}

TEST(ScriptTimingRealData, MapM) {
    CheckShard("map/m/");
}

TEST(ScriptTimingRealData, MapS) {
    CheckShard("map/s/");
}

TEST(ScriptTimingRealData, Event) {
    CheckShard("event");
}

TEST(ScriptTimingRealData, Language2DtoG) {
    CheckShard("language2a");
}

TEST(ScriptTimingRealData, Language2ItoS) {
    CheckShard("language2b");
}

TEST(ScriptTimingRealData, Language3DtoG) {
    CheckShard("language3a");
}

TEST(ScriptTimingRealData, Language3ItoS) {
    CheckShard("language3b");
}

TEST(ScriptTimingRealData, Language4DtoG) {
    CheckShard("language4a");
}

TEST(ScriptTimingRealData, Language4ItoS) {
    CheckShard("language4b");
}

TEST(ScriptTimingRealData, Language5DtoG) {
    CheckShard("language5a");
}

TEST(ScriptTimingRealData, Language5ItoS) {
    CheckShard("language5b");
}

TEST(ScriptTimingRealData, Monster) {
    CheckShard("dungeon/monster/");
}

TEST(ScriptTimingRealData, Effect) {
    CheckShard("dungeon/eff_script/");
}

TEST(ScriptTimingRealData, Other) {
    CheckShard("other");
}

TEST(ScriptTimingRealData, EveryInventoryRowIsOnDisk) {
    const auto &scripts = Scripts();
    if (!scripts) {
        GTEST_SKIP() << "DC2_DATA supplies the extracted scripts";
    }
    std::size_t found = 0;
    for (const std::string &key : scripts->keys) {
        found += script_timing::Find(key) != nullptr;
    }
    EXPECT_EQ(found, script_timing::InventorySize());
}
