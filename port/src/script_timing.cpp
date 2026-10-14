#include "script_timing.hpp"

#include <algorithm>
#include <bit>
#include <cstdio>
#include <cstring>
#include <map>
#include <optional>
#include <set>
#include <vector>

// The compiled script format is ps2/include/runscript.hpp's: an RS_PROG_HEADER, funcdata blocks of 0x38
// bytes each followed by the function's code, and 12-byte vmcode_t {op, arg1, arg2} instructions with
// code-relative jump targets and CALL funcdata offsets. CRunScript::exe() has no case for opcode 22, so
// an instruction with op 22 falls through to the next one without touching the stacks; the compiler
// emits it at branch joins. Recipes write op 22 with kTag in arg1 and the replaced instruction's identity
// in arg2, so a converted script decodes back to its PAL preimage and a second pass writes nothing.

namespace script_timing {
namespace {

constexpr int kOpLoad = 1;
constexpr int kOpLoadAddr = 2;
constexpr int kOpPush = 3;
constexpr int kOpPop = 4;
constexpr int kOpStore = 5;
constexpr int kOpMul = 8;
constexpr int kOpDiv = 9;
constexpr int kOpNeg = 11;
constexpr int kOpItof = 12;
constexpr int kOpFtoi = 13;
constexpr int kOpCmp = 14;
constexpr int kOpRet = 15;
constexpr int kOpJmp = 16;
constexpr int kOpJmpFalse = 17;
constexpr int kOpJmpTrue = 18;
constexpr int kOpCall = 19;
constexpr int kOpExt = 21;
constexpr int kOpNop = 22;
constexpr int kOpEnd = 27;
constexpr int kOpLast = 30;

constexpr int kConstInt = 1;
constexpr int kConstFloat = 2;
constexpr int kAddrLocal = 1;
constexpr int kAddrLocalIndexFloat = 0x10;
constexpr int kCmpEq = 40;
constexpr int kCmpLt = 42;
constexpr int kCmpLe = 43;
constexpr int kCmpGe = 45;

constexpr std::int32_t kTag = 0x4E544D54;
constexpr std::size_t kInsnSize = 12;
constexpr std::size_t kBlockSize = 0x38;
constexpr std::size_t kHeaderSize = 0x1C;
constexpr int         kMaxPrograms = 4096;

constexpr std::int32_t Bits(float value) {
    return std::bit_cast<std::int32_t>(value);
}

std::int32_t Read32(const unsigned char *bytes, std::size_t offset) {
    std::uint32_t value = static_cast<std::uint32_t>(bytes[offset]) | static_cast<std::uint32_t>(bytes[offset + 1]) << 8 |
                          static_cast<std::uint32_t>(bytes[offset + 2]) << 16 | static_cast<std::uint32_t>(bytes[offset + 3]) << 24;
    return static_cast<std::int32_t>(value);
}

void Write32(unsigned char *bytes, std::size_t offset, std::int32_t value) {
    std::uint32_t bits = static_cast<std::uint32_t>(value);
    for (int i = 0; i < 4; ++i) {
        bytes[offset + i] = static_cast<unsigned char>(bits >> (8 * i));
    }
}

struct Insn {
    std::size_t  offset = 0;
    std::int32_t op = 0;
    std::int32_t a1 = 0;
    std::int32_t a2 = 0;

    bool operator==(const Insn &other) const {
        return op == other.op && a1 == other.a1 && a2 == other.a2;
    }
};

struct Function {
    std::size_t       block = 0;
    std::int32_t      local = 0;
    std::int32_t      arg = 0;
    std::vector<Insn> insns;
};

// ---------------------------------------------------------------- patterns

enum ItemFlags : std::uint8_t {
    kExact = 0,
    kAnyArg1 = 1,
    kAnyArg2 = 2,
};

struct Item {
    std::int32_t op;
    std::int32_t a1;
    std::int32_t a2;
    std::uint8_t flags;
};

constexpr Item Op(int op) {
    return {op, 0, 0, kExact};
}

constexpr Item PushInt(int value) {
    return {kOpPush, kConstInt, value, kExact};
}

constexpr Item PushFloat(float value) {
    return {kOpPush, kConstFloat, Bits(value), kExact};
}

constexpr Item PushFloatBits(std::int32_t bits) {
    return {kOpPush, kConstFloat, bits, kExact};
}

constexpr Item LocalLoad() {
    return {kOpLoad, 0, kAddrLocal, kAnyArg1};
}

constexpr Item LocalAddr() {
    return {kOpLoadAddr, 0, kAddrLocal, kAnyArg1};
}

constexpr Item Compare(int how) {
    return {kOpCmp, how, 0, kExact};
}

bool Matches(const Item &item, const Insn &insn) {
    return item.op == insn.op && ((item.flags & kAnyArg1) || item.a1 == insn.a1) && ((item.flags & kAnyArg2) || item.a2 == insn.a2);
}

// A recipe window and the positions it turns into no-ops.
struct Pattern {
    Recipe            recipe;
    std::vector<Item> items;
    int               first_nop;
    int               nops;
};

const std::vector<Pattern> &Patterns() {
    static const std::vector<Pattern> patterns = {
        {kEventAssign,       {LocalAddr(), LocalLoad(), PushInt(50), Op(kOpMul), PushInt(60), Op(kOpDiv), Op(kOpStore), Op(kOpPop)},           2, 4},
        {kEventCue,          {LocalAddr(), LocalLoad(), PushInt(50), Op(kOpMul), PushInt(60), Op(kOpDiv), Op(kOpStore), Op(kOpPop)},           0, 8},
        {kEventInline,       {PushInt(50), Op(kOpMul), PushInt(60), Op(kOpDiv)},                                                               0, 4},
        {kEventInlineFloat,  {PushFloat(50.0f), Op(kOpMul), PushFloat(60.0f), Op(kOpDiv)},                                                     0, 4},
        {kEventInverse,      {PushInt(60), Op(kOpDiv), PushInt(50), Op(kOpMul)},                                                               0, 4},
        {kEventInverseFloat, {PushFloat(60.0f), Op(kOpDiv), PushFloat(50.0f), Op(kOpMul)},                                                     0, 4},
        {kMonsterConvert,
         {{kOpLoad, 0, kAddrLocal, kExact}, Op(kOpItof), PushFloat(30.0f), Op(kOpDiv), PushFloat(25.0f), Op(kOpMul), Op(kOpFtoi), Op(kOpRet)},
         1,
         5                                                                                                                                         },
        {kInteger3025,       {PushInt(30), Op(kOpDiv), PushInt(25), Op(kOpMul)},                                                               0, 4},
    };
    return patterns;
}

// ---------------------------------------------------------------- anchors

struct AnchorWrite {
    int          pos;
    bool         nop;
    std::int32_t ntsc_a2;
};

struct Anchor {
    const char              *id;
    const char              *path; // exact key, or the stem of the language copies stem_1..stem_5
    bool                     language;
    std::int32_t             offset; // window start for an exact-path anchor; -1 searches decoded code
    bool                     window; // an attack window, governed by the attack-window policy
    std::vector<Item>        items;  // PAL preimage; a value write's position also accepts the NTSC value
    std::vector<AnchorWrite> writes;
};

const std::vector<Anchor> &Anchors() {
    static const std::vector<Anchor> anchors = {
        // d03 jump: PAL speeds up the jump by 6/5 (horizontal 16.0f * 1.2f, fewer steps) and retunes its
        // vertical start; the loop and the per-step move are kEventInline sites.
        {"d03-jump-speed",        "map/d/d03/d03",             true,  -1,      false, {PushFloat(16.0f), PushFloat(1.2f), Op(kOpMul)},                            {{1, true, 0}, {2, true, 0}}},
        {"d03-jump-rise",
         "map/d/d03/d03",
         true,
         -1,
         false,
         {{kOpLoadAddr, 0, kAddrLocalIndexFloat, kAnyArg1}, PushFloat(6.2f), Op(kOpNeg), Op(kOpStore)},
         {{1, false, Bits(6.0f)}}                                                                                                                                                             },
        // s03: a turn of pi/20 per field, sped up by 6/5 over a loop shortened from 40 to 33.
        {"s03-turn-step",
         "map/s/s03/s03",
         true,
         -1,
         false,
         {PushFloatBits(0x40490fdb), PushFloat(20.0f), Op(kOpDiv), PushFloat(1.2f), Op(kOpMul)},
         {{3, true, 0}, {4, true, 0}}                                                                                                                                                         },
        {"s03-turn-loop",         "map/s/s03/s03",             true,  -1,      false, {LocalLoad(), PushInt(33), Compare(kCmpLt), {kOpJmpFalse, 0, 0, kAnyArg1}}, {{1, false, 40}}            },
        // m06b: an object's motion delay and the wait after it, written as PAL literals.
        {"m06b-motion-delay",
         "map/m/m06/m06b",
         true,
         -1,
         false,
         {PushFloat(0.08f), {kOpExt, 3, 0, kExact}, PushInt(464), PushInt(4), PushInt(34), {kOpExt, 3, 0, kExact}},
         {{4, false, 30}}                                                                                                                                                                     },
        {"m06b-wait",             "map/m/m06/m06b",            true,  -1,      false, {LocalLoad(), PushInt(25), Compare(kCmpLt), {kOpJmpFalse, 0, 0, kAnyArg1}}, {{1, false, 30}}            },
        // i01h01b backpack scene: NTSC loops 42 times over wait(1), two resumes each, with the sound cue at
        // step 12; PAL loops over a bare wait. With the factors gone the loop counts resumes: 84, cue at 24.
        {"i01h01b-backpack-loop",
         "map/i/i01/h01/i01h01b",
         true,
         -1,
         false,
         {LocalLoad(), PushInt(42), PushInt(50), Op(kOpMul), PushInt(60), Op(kOpDiv), Compare(kCmpLt)},
         {{1, false, 84}}                                                                                                                                                                     },
        {"i01h01b-backpack-cue",
         "map/i/i01/h01/i01h01b",
         true,
         -1,
         false,
         {LocalLoad(), PushInt(25), PushInt(50), Op(kOpMul), PushInt(60), Op(kOpDiv), Compare(kCmpEq)},
         {{1, false, 24}}                                                                                                                                                                     },
        // e221a: one turn passes conv(15) where NTSC passed 12.
        {"e221a-turn",            "dungeon/monster/e221a.stb", false, 0x12cd8, false, {PushInt(15), {kOpCall, 0, 0, kAnyArg1 | kAnyArg2}},                        {{0, false, 12}}            },
        // Max (c01) and Monica (c02) motion-ratio windows.
        {"c01-trail-start",       "mainchr/c01.stb",           false, 0x11a0,  true,  {PushFloat(0.26f), {kOpPush, kConstFloat, 0, kAnyArg2}},                    {{0, false, Bits(0.27f)}}   },
        {"c01-trail-end",         "mainchr/c01.stb",           false, 0x11ac,  true,  {PushFloat(0.3f), {kOpPush, 3, 0, kAnyArg2}},                               {{0, false, Bits(0.29f)}}   },
        {"c01-catch-start",       "mainchr/c01.stb",           false, 0x87c0,  true,  {PushFloat(0.12f), Compare(kCmpGe)},                                        {{0, false, Bits(0.14f)}}   },
        {"c01-catch-end",         "mainchr/c01.stb",           false, 0x87f0,  true,  {PushFloat(0.24f), Compare(kCmpLt)},                                        {{0, false, Bits(0.233f)}}  },
        {"c01-catch2-start",      "mainchr/c01.stb",           false, 0x932c,  true,  {PushFloat(0.12f), Compare(kCmpGe)},                                        {{0, false, Bits(0.14f)}}   },
        {"c01-catch2-end",        "mainchr/c01.stb",           false, 0x935c,  true,  {PushFloat(0.24f), Compare(kCmpLt)},                                        {{0, false, Bits(0.233f)}}  },
        {"c02-shot-end",          "mainchr/c02.stb",           false, 0xb308,  true,  {PushFloat(0.48f), Compare(kCmpLe)},                                        {{0, false, Bits(0.45f)}}   },
        {"c02-shot2-end",         "mainchr/c02.stb",           false, 0xb3bc,  true,  {PushFloat(0.45f), Compare(kCmpLe)},                                        {{0, false, Bits(0.42f)}}   },
    };
    return anchors;
}

bool AnchorApplies(const Anchor &anchor, std::string_view key) {
    if (!anchor.language) {
        return key == anchor.path;
    }
    std::string_view stem = anchor.path;
    return key.size() == stem.size() + 6 && key.starts_with(stem) && key[stem.size()] == '_' && key[stem.size() + 1] >= '1' &&
           key[stem.size() + 1] <= '5' && key.substr(stem.size() + 2) == ".stb";
}

// ---------------------------------------------------------------- markers

constexpr int kMarkAnchorBase = 32;

Insn Marker(int kind, int pos, std::int32_t value) {
    return {0, kOpNop, kTag, (kind << 24) | (pos << 16) | (value & 0xFFFF)};
}

// The PAL instruction a marker replaced, or nullopt for an op-22 that is not a recipe marker.
std::optional<Insn> Unmark(const Insn &insn, bool &bad) {
    if (insn.op != kOpNop || insn.a1 != kTag) {
        return std::nullopt;
    }
    const int          kind = (insn.a2 >> 24) & 0xFF;
    const int          pos = (insn.a2 >> 16) & 0xFF;
    const std::int32_t value = static_cast<std::int16_t>(insn.a2 & 0xFFFF);
    const Item        *item = nullptr;
    if (kind < kRecipeCount) {
        const Pattern &pattern = Patterns()[kind];
        if (pos < static_cast<int>(pattern.items.size())) {
            item = &pattern.items[pos];
        }
    } else if (kind >= kMarkAnchorBase && kind - kMarkAnchorBase < static_cast<int>(Anchors().size())) {
        const Anchor &anchor = Anchors()[kind - kMarkAnchorBase];
        if (pos < static_cast<int>(anchor.items.size())) {
            item = &anchor.items[pos];
        }
    }
    if (!item || (item->flags & kAnyArg2)) {
        bad = true;
        return std::nullopt;
    }
    return Insn{insn.offset, item->op, (item->flags & kAnyArg1) ? value : item->a1, item->a2};
}

// ---------------------------------------------------------------- decoding

struct Program {
    std::size_t           code = 0;
    std::vector<Function> functions;
};

bool ValidOp(std::int32_t op) {
    return op >= kOpLoad && op <= kOpLast;
}

class Decoder {
public:
    Decoder(const unsigned char *bytes, std::size_t size) : bytes_(bytes), size_(size), covered_(size, 0) {}

    bool Run(Program &program, std::string &error) {
        if (size_ < kHeaderSize) {
            error = "shorter than a script header";
            return false;
        }
        if (std::memcmp(bytes_, "SB2", 3) != 0 && std::memcmp(bytes_, "STB", 3) != 0) {
            error = "not a compiled script";
            return false;
        }
        const std::int32_t main = Read32(bytes_, 4);
        const std::int32_t code = Read32(bytes_, 8);
        const std::int32_t prog = Read32(bytes_, 12);
        const std::int32_t prog_num = Read32(bytes_, 16);
        if (code < static_cast<std::int32_t>(kHeaderSize) || static_cast<std::size_t>(code) >= size_ || code % 4 != 0) {
            error = "code offset out of range";
            return false;
        }
        if (prog_num < 0 || prog_num > kMaxPrograms || prog < static_cast<std::int32_t>(kHeaderSize) ||
            static_cast<std::size_t>(prog) + static_cast<std::size_t>(prog_num) * 8 > size_) {
            error = "program table out of range";
            return false;
        }
        code_ = static_cast<std::size_t>(code);
        program.code = code_;
        std::vector<std::int64_t> todo = {main};
        for (std::int32_t i = 0; i < prog_num; ++i) {
            todo.push_back(Read32(bytes_, static_cast<std::size_t>(prog) + 8 * i + 4));
        }
        for (std::size_t next = 0; next < todo.size(); ++next) {
            const std::int64_t block = todo[next];
            if (seen_.count(block)) {
                continue;
            }
            seen_.insert(block);
            Function function;
            if (!DecodeAt(block, function, error)) {
                return false;
            }
            for (const Insn &insn : function.insns) {
                if (insn.op == kOpCall) {
                    todo.push_back(static_cast<std::int64_t>(code_) + insn.a2);
                }
            }
            Cover(function);
            program.functions.push_back(std::move(function));
        }
        // Unreferenced helpers: a funcdata block whose first instruction sits right behind it.
        for (std::size_t at = code_; at + kBlockSize + kInsnSize <= size_; at += 4) {
            if (static_cast<std::uint32_t>(Read32(bytes_, at)) != at - code_ + kBlockSize) {
                continue;
            }
            if (covered_[at] || seen_.count(static_cast<std::int64_t>(at))) {
                continue;
            }
            const std::int32_t local = Read32(bytes_, at + 8);
            const std::int32_t arg = Read32(bytes_, at + 12);
            if (arg < 0 || arg > local || local >= 0x100 || !ValidOp(Read32(bytes_, at + kBlockSize))) {
                continue;
            }
            Function    function;
            std::string ignored;
            if (!DecodeAt(static_cast<std::int64_t>(at), function, ignored)) {
                continue;
            }
            seen_.insert(static_cast<std::int64_t>(at));
            Cover(function);
            at = function.insns.back().offset + kInsnSize - 4;
            program.functions.push_back(std::move(function));
        }
        return true;
    }

private:
    bool DecodeAt(std::int64_t block, Function &function, std::string &error) {
        if (block < static_cast<std::int64_t>(kHeaderSize) || block % 4 != 0 || static_cast<std::size_t>(block) + 16 > size_) {
            error = "function block out of range";
            return false;
        }
        const std::size_t   at = static_cast<std::size_t>(block);
        const std::uint32_t addr = static_cast<std::uint32_t>(Read32(bytes_, at));
        function.block = at;
        function.local = Read32(bytes_, at + 8);
        function.arg = Read32(bytes_, at + 12);
        if (function.arg < 0 || function.arg > function.local) {
            error = "function frame invalid";
            return false;
        }
        std::size_t offset = code_ + addr;
        if (offset < code_ || offset % 4 != 0 || offset + kInsnSize > size_) {
            error = "function code out of range";
            return false;
        }
        std::size_t farthest = offset;
        for (;;) {
            if (offset + kInsnSize > size_) {
                error = "function runs past the end";
                return false;
            }
            Insn insn{offset, Read32(bytes_, offset), Read32(bytes_, offset + 4), Read32(bytes_, offset + 8)};
            if (!ValidOp(insn.op)) {
                error = "invalid opcode";
                return false;
            }
            if (insn.op == kOpJmp || insn.op == kOpJmpFalse || insn.op == kOpJmpTrue) {
                const std::int64_t target = static_cast<std::int64_t>(code_) + insn.a1;
                if (insn.a1 < 0 || target % 4 != 0 || static_cast<std::size_t>(target) + kInsnSize > size_) {
                    error = "jump target out of range";
                    return false;
                }
                farthest = std::max(farthest, static_cast<std::size_t>(target));
            }
            if (insn.op == kOpCall) {
                const std::int64_t target = static_cast<std::int64_t>(code_) + insn.a2;
                if (insn.a2 < 0 || static_cast<std::size_t>(target) + 16 > size_) {
                    error = "call target out of range";
                    return false;
                }
            }
            function.insns.push_back(insn);
            offset += kInsnSize;
            if ((insn.op == kOpRet || insn.op == kOpEnd) && offset > farthest) {
                return true;
            }
        }
    }

    void Cover(const Function &function) {
        if (function.insns.empty()) {
            return;
        }
        const std::size_t end = std::min(size_, function.insns.back().offset + kInsnSize);
        std::fill(covered_.begin() + static_cast<std::ptrdiff_t>(function.insns.front().offset), covered_.begin() + static_cast<std::ptrdiff_t>(end), 1);
    }

    const unsigned char      *bytes_;
    std::size_t               size_;
    std::size_t               code_ = 0;
    std::vector<std::uint8_t> covered_;
    std::set<std::int64_t>    seen_;
};

// ---------------------------------------------------------------- families

enum Family {
    kFamilyNone,
    kFamilyEvent,
    kFamilyMonster,
    kFamilyEffect
};

Family FamilyOf(std::string_view key) {
    if (key.starts_with("map/") || key.starts_with("event/")) {
        return kFamilyEvent;
    }
    if (key.starts_with("dungeon/monster/")) {
        return kFamilyMonster;
    }
    if (key.starts_with("dungeon/eff_script/")) {
        return kFamilyEffect;
    }
    return kFamilyNone;
}

bool Allowed(Recipe recipe, Family family) {
    switch (recipe) {
        case kMonsterConvert:
            return family == kFamilyMonster;
        case kInteger3025:
            return family == kFamilyMonster || family == kFamilyEffect;
        default:
            return family == kFamilyEvent;
    }
}

bool WindowAt(const std::vector<Item> &items, const std::vector<Insn> &code, std::size_t at) {
    if (at + items.size() > code.size()) {
        return false;
    }
    for (std::size_t k = 0; k < items.size(); ++k) {
        if (!Matches(items[k], code[at + k])) {
            return false;
        }
    }
    return true;
}

// Where a recipe applies inside a function, beyond its window: the integer helper form starts a
// one-argument function, the inline form follows an integer literal; the converter is a whole function.
bool InContext(const Pattern &pattern, const Function &function, const std::vector<Insn> &code, std::size_t at) {
    switch (pattern.recipe) {
        case kEventAssign:
            return code[at].a1 == code[at + 1].a1;
        case kEventCue:
            return code[at].a1 != code[at + 1].a1;
        case kMonsterConvert:
            return at == 0 && code.size() == pattern.items.size() && function.arg == 1 && function.local == 1;
        case kInteger3025: {
            const bool helper = at == 2 && function.arg >= 1 && code[0].op == kOpLoadAddr && code[0].a1 == 0 && code[0].a2 == kAddrLocal &&
                                code[1].op == kOpLoad && code[1].a1 == 0 && code[1].a2 == kAddrLocal && at + 5 < code.size() &&
                                code[at + 4].op == kOpStore && code[at + 5].op == kOpPop;
            const bool literal = at >= 1 && code[at - 1].op == kOpPush && code[at - 1].a1 == kConstInt;
            return helper || literal;
        }
        default:
            return true;
    }
}

struct Plan {
    Counts                      counts;
    std::map<std::size_t, Insn> target; // offset -> instruction the NTSC script holds there
    std::string                 error;
};

bool AddWrite(Plan &plan, std::size_t offset, const Insn &insn) {
    auto [it, inserted] = plan.target.emplace(offset, insn);
    if (!inserted && !(it->second == insn)) {
        plan.error = "two recipes write the same instruction";
        return false;
    }
    return true;
}

bool BuildPlan(std::string_view key, const Program &program, const std::vector<std::vector<Insn> > &canonical, Plan &plan) {
    const Family          family = FamilyOf(key);
    std::set<std::size_t> sites;
    for (std::size_t f = 0; f < program.functions.size(); ++f) {
        const Function          &function = program.functions[f];
        const std::vector<Insn> &code = canonical[f];
        for (std::size_t at = 0; at < code.size();) {
            bool matched = false;
            for (const Pattern &pattern : Patterns()) {
                if (!Allowed(pattern.recipe, family) || !WindowAt(pattern.items, code, at) || !InContext(pattern, function, code, at)) {
                    continue;
                }
                if (sites.insert(code[at].offset).second) {
                    plan.counts.recipes[pattern.recipe]++;
                    for (int k = 0; k < pattern.nops; ++k) {
                        const int   pos = pattern.first_nop + k;
                        const Insn &original = code[at + pos];
                        if (!AddWrite(plan, original.offset, Marker(pattern.recipe, pos, original.a1))) {
                            return false;
                        }
                    }
                }
                at += pattern.items.size();
                matched = true;
                break;
            }
            if (!matched) {
                ++at;
            }
        }
    }

    const std::vector<Anchor> &anchors = Anchors();
    for (std::size_t a = 0; a < anchors.size(); ++a) {
        const Anchor &anchor = anchors[a];
        if (!AnchorApplies(anchor, key)) {
            continue;
        }
        // The PAL preimage must occur once. Only when it does not occur at all is the script taken to be
        // converted already, which needs the NTSC image (the preimage with the anchor's values) once.
        auto matches = [&](const std::vector<Insn> &code, std::size_t at, bool converted) {
            if (at + anchor.items.size() > code.size()) {
                return false;
            }
            for (std::size_t k = 0; k < anchor.items.size(); ++k) {
                const Item &item = anchor.items[k];
                const Insn &insn = code[at + k];
                bool        ok = Matches(item, insn);
                for (const AnchorWrite &write : anchor.writes) {
                    if (converted && static_cast<std::size_t>(write.pos) == k && !write.nop) {
                        ok = item.op == insn.op && item.a1 == insn.a1 && insn.a2 == write.ntsc_a2;
                    }
                }
                if (!ok) {
                    return false;
                }
            }
            return true;
        };
        auto find = [&](bool converted) {
            std::vector<std::pair<std::size_t, std::size_t> > hits; // function, index
            std::set<std::size_t>                             hit_offsets;
            for (std::size_t f = 0; f < program.functions.size(); ++f) {
                const std::vector<Insn> &code = canonical[f];
                for (std::size_t at = 0; at < code.size(); ++at) {
                    if (anchor.offset >= 0 && code[at].offset != static_cast<std::size_t>(anchor.offset)) {
                        continue;
                    }
                    if (matches(code, at, converted) && hit_offsets.insert(code[at].offset).second) {
                        hits.emplace_back(f, at);
                    }
                }
            }
            return hits;
        };
        auto hits = find(false);
        if (hits.empty()) {
            hits = find(true);
        }
        if (hits.size() != 1) {
            plan.error = std::string("anchor ") + anchor.id + (hits.empty() ? " not found" : " found more than once");
            return false;
        }
        (anchor.window ? plan.counts.windows : plan.counts.anchors)++;
        const std::vector<Insn> &code = canonical[hits[0].first];
        for (const AnchorWrite &write : anchor.writes) {
            const Insn &original = code[hits[0].second + static_cast<std::size_t>(write.pos)];
            Insn        target = write.nop ? Marker(kMarkAnchorBase + static_cast<int>(a), write.pos, original.a1)
                                           : Insn{0, original.op, original.a1, write.ntsc_a2};
            if (!AddWrite(plan, original.offset, target)) {
                return false;
            }
        }
    }
    return true;
}

// ---------------------------------------------------------------- inventory

const Expected kInventory[] = {
#include "script_timing_inventory.inc"
};

std::set<std::string> logged_assets;

Counts CountsOf(const Expected &expected) {
    Counts counts;
    for (int i = 0; i < kRecipeCount; ++i) {
        counts.recipes[i] = expected.recipes[i];
    }
    counts.anchors = expected.anchors;
    counts.windows = expected.windows;
    return counts;
}

std::string Describe(const Counts &counts) {
    char text[200];
    std::snprintf(text, sizeof text, "assign %d, cue %d, inline %d, float %d, inverse %d, inverse float %d, convert %d, integer %d, anchors %d, windows %d",
                  counts.recipes[kEventAssign], counts.recipes[kEventCue], counts.recipes[kEventInline], counts.recipes[kEventInlineFloat],
                  counts.recipes[kEventInverse], counts.recipes[kEventInverseFloat], counts.recipes[kMonsterConvert], counts.recipes[kInteger3025],
                  counts.anchors, counts.windows);
    return text;
}

} // namespace

std::string Key(std::string_view asset_path) {
    std::string key;
    key.reserve(asset_path.size());
    for (char c : asset_path) {
        char folded = c == '\\' ? '/' : (c >= 'A' && c <= 'Z' ? static_cast<char>(c - 'A' + 'a') : c);
        if (folded == '/' && key.empty()) {
            continue;
        }
        key.push_back(folded);
    }
    return key;
}

const Expected *Find(std::string_view key) {
    const Expected *begin = std::begin(kInventory);
    const Expected *end = std::end(kInventory);
    const Expected *found = std::lower_bound(begin, end, key, [](const Expected &entry, std::string_view k) { return std::string_view(entry.path) < k; });
    return found != end && std::string_view(found->path) == key ? found : nullptr;
}

std::size_t InventorySize() {
    return std::size(kInventory);
}

Result Apply(std::string_view key, unsigned char *bytes, std::size_t size, const Options &options) {
    Result          result;
    const Expected *expected = options.expected ? options.expected : (options.use_inventory ? Find(key) : nullptr);
    result.known = expected != nullptr;

    Program     program;
    std::string error;
    Decoder     decoder(bytes, size);
    if (!decoder.Run(program, error)) {
        result.error = error;
        result.ok = !result.known; // an unknown file that is not a valid script has nothing to convert
        return result;
    }
    result.decoded = true;

    std::vector<std::vector<Insn> > canonical(program.functions.size());
    bool                            bad_marker = false;
    for (std::size_t f = 0; f < program.functions.size(); ++f) {
        canonical[f] = program.functions[f].insns;
        for (Insn &insn : canonical[f]) {
            if (auto original = Unmark(insn, bad_marker)) {
                insn = *original;
            }
        }
    }
    if (bad_marker) {
        result.error = "unknown recipe marker";
        return result;
    }

    Plan plan;
    if (!BuildPlan(key, program, canonical, plan)) {
        result.error = plan.error;
        result.counts = plan.counts;
        return result;
    }
    result.counts = plan.counts;
    const Counts want = expected ? CountsOf(*expected) : Counts{};
    if (!(plan.counts == want)) {
        result.error = "found " + Describe(plan.counts) + "; expected " + Describe(want);
        return result;
    }
    result.ok = true;

    for (const auto &[offset, insn] : plan.target) {
        if (Read32(bytes, offset) != insn.op || Read32(bytes, offset + 4) != insn.a1 || Read32(bytes, offset + 8) != insn.a2) {
            result.writes++;
        }
    }
    if (options.write) {
        for (const auto &[offset, insn] : plan.target) {
            Write32(bytes, offset, insn.op);
            Write32(bytes, offset + 4, insn.a1);
            Write32(bytes, offset + 8, insn.a2);
        }
    }
    return result;
}

bool Patch(const char *asset_path, unsigned char *bytes, std::size_t size) {
    const std::string key = Key(asset_path ? asset_path : "");
    Result result = Apply(key, bytes, size);
    if (!result.ok) {
        if (logged_assets.insert(key).second) {
            std::fprintf(stderr, "script timing: %s does not match the PAL script the NTSC timing converts (%s)\n", key.c_str(), result.error.c_str());
        }
        return false;
    }
    if (result.known && logged_assets.insert(key).second) {
        std::fprintf(stderr, "script timing: %s: %d instructions (%s)\n", key.c_str(), result.writes, Describe(result.counts).c_str());
    }
    return true;
}

} // namespace script_timing

bool ScriptTimingPatch(const char *asset_path, unsigned char *bytes, std::size_t size) {
    return script_timing::Patch(asset_path, bytes, size);
}
