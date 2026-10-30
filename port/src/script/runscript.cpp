#include "common.h"

#include <bit>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <span>
#include <utility>

#if defined(__linux__)
#include <dlfcn.h>
#endif

#include "assets/data_registry.hpp"
#include "log/game_output.hpp"
#include "luau_runtime.hpp"
#include "runscript.hpp"

void runerror(const char *message);

namespace dc2::script {
namespace {
thread_local ScopedExecutionValidation *execution_validation = nullptr; /**< Innermost validation scope on the executing thread. */
}

ScopedExecutionValidation::ScopedExecutionValidation(const CRunScript &script, std::function<bool()> validator)
    : script(&script), validator(std::move(validator)), previous(execution_validation) {
    execution_validation = this;
}

ScopedExecutionValidation::~ScopedExecutionValidation() {
    execution_validation = previous;
}

bool ExecutionValid(const CRunScript *script) noexcept {
    if (script == nullptr) {
        return false;
    }
    for (auto *scope = execution_validation; scope != nullptr; scope = scope->previous) {
        if (scope->script == script) {
            try {
                return scope->validator && scope->validator();
            } catch (...) {
                return false;
            }
        }
    }
    return true;
}
} // namespace dc2::script

namespace {
/**
 *
 * Retains callback text through the interpreter that owns its arena.
 *
 */
dc2::script::OwnedText CaptureScriptText(void *context, std::string_view text) {
    return static_cast<CRunScript *>(context)->RetainText(text);
}

constexpr char kUnresolvedFunctionName[] = "<unnamed function>";

/**
 *
 * Keeps the native VM's low 32 integer bits without signed arithmetic overflow.
 *
 */
int IntegerBits(std::int64_t value) {
    return std::bit_cast<int>(static_cast<std::uint32_t>(value));
}

bool ContainsBytes(std::span<const u8> bytes, std::size_t offset, std::size_t count) {
    return offset <= bytes.size() && count <= bytes.size() - offset;
}

bool ValidFunction(std::span<const u8> bytes, int offset, int code_offset, std::size_t stack_capacity) {
    if (offset < 0 || offset % alignof(funcdata) != 0 ||
        !ContainsBytes(bytes, static_cast<std::size_t>(offset), sizeof(funcdata))) {
        return false;
    }
    funcdata function{};
    std::memcpy(&function, bytes.data() + offset, sizeof function);
    if (function.arg < 0 || function.local < function.arg ||
        static_cast<std::size_t>(function.local) >= stack_capacity) {
        return false;
    }
    const auto first = static_cast<std::size_t>(code_offset) + function.addr;
    return first >= static_cast<std::size_t>(code_offset) && first % alignof(vmcode_t) == 0 &&
           ContainsBytes(bytes, first, sizeof(vmcode_t));
}

char *CodeTarget(std::span<u8> bytes, char *code, int offset, std::size_t count) {
    if (bytes.empty()) {
        return nullptr;
    }
    const auto base = reinterpret_cast<char *>(bytes.data());
    const auto code_offset = static_cast<std::size_t>(code - base);
    if (offset < 0 ||
        (count > 1 && (code_offset + static_cast<std::size_t>(offset)) % alignof(vmcode_t) != 0) ||
        !ContainsBytes(bytes, code_offset, static_cast<std::size_t>(offset)) ||
        !ContainsBytes(bytes, code_offset + static_cast<std::size_t>(offset), count)) {
        return nullptr;
    }
    return code + offset;
}

bool ContainsPointer(std::span<const u8> bytes, const void *pointer, std::size_t count) {
    if (bytes.empty()) {
        return false;
    }
    const auto base = reinterpret_cast<std::uintptr_t>(bytes.data());
    const auto address = reinterpret_cast<std::uintptr_t>(pointer);
    return address >= base && ContainsBytes(bytes, address - base, count);
}

RS_STACKDATA *CheckedSlot(RS_STACKDATA *begin, RS_STACKDATA *end, RS_STACKDATA *base, long long offset) {
    if (begin == nullptr || end == nullptr || base == nullptr || end < begin) {
        runerror("invalid script stack address");
    }
    const auto first = reinterpret_cast<std::uintptr_t>(begin);
    const auto last = reinterpret_cast<std::uintptr_t>(end);
    const auto address = reinterpret_cast<std::uintptr_t>(base);
    if (address < first || address >= last || (address - first) % sizeof(RS_STACKDATA) != 0) {
        runerror("invalid script stack address");
    }
    const auto position = static_cast<long long>((address - first) / sizeof(RS_STACKDATA));
    const auto size = static_cast<long long>(end - begin);
    if (offset < -position || offset >= size - position) {
        runerror("invalid script stack index");
    }
    return begin + position + offset;
}
} // namespace

/**
 *
 * Reports a script execution error and stops the process.
 *
 */
void runerror(const char *message) {
    fprintf(stderr, "RUNTIME ERROR: %s\n", message);
    exit(-1);
}

/**
 *
 * Reports that the script evaluation stack overflowed.
 *
 */
void stkoverflow() {
    runerror("stack overflow");
}

/**
 *
 * Reads an integer script argument or reports its type mismatch.
 *
 */
int chk_int(RS_STACKDATA data, funcdata *func) {
    if (data.type == RS_INT) {
        return data.val.i;
    }

    fprintf(stderr, "RUNTIME ERROR: %s: operand is not integer\n", kUnresolvedFunctionName);
    exit(-1);
    return 0;
}

/**
 *
 * Returns whether a script value is true under script boolean rules.
 *
 */
u8 is_true(RS_STACKDATA data) {
    int is_zero = data.type == RS_INT;

    if (is_zero) {
        is_zero = data.val.i == 0;
    }

    return is_zero ^ 1;
}

/**
 *
 * Reports integer division by zero in a script expression.
 *
 */
void divby0error() {
    runerror("Divide by 0");
}

/**
 *
 * Reports a zero divisor in a script remainder expression.
 *
 */
void modby0error() {
    runerror("Modulo by 0");
}

/**
 *
 * Prints integer, string, and floating point script values to standard output.
 *
 */
void print(RS_STACKDATA *slots, int count) {
    int i = 0;

    if (0 < count) {
        do {
            if (slots->type == RS_INT) {
                dc2::log::PrintGame("%d", slots->val.i);
            } else if (slots->type == RS_STR) {
                dc2::log::PrintGame("%s", slots->val.s);
            } else if (slots->type == RS_FLOAT) {
                dc2::log::PrintGame("%f", slots->val.f);
            }

            fflush(stdout);
            i++;
            slots++;
        } while (i < count);
    }
}

CRunScript::CRunScript()
    : version(RS_VERSION_1), ext_func_num(0), ext_func_table(nullptr), stack_num(0), stack(nullptr), sp(nullptr),
      stack_end(nullptr), global(nullptr), call_num(0), call(nullptr), call_sp(nullptr), call_end(nullptr), frame(nullptr),
      func(nullptr), pc(nullptr), end(0), skip_wait(0), prog(nullptr), code(nullptr), result(0), skip_end_count(0) {
    DeleteProgram();
}

bool CRunScript::BindRetainedTextArena(mgCMemory &memory, std::span<RS_STACKDATA> values) {
    const auto anchor = dc2::memory::ArenaBuffer::Bind(memory,
                                                       {reinterpret_cast<u8 *>(values.data()), values.size_bytes()});
    if (anchor.Bytes().empty()) {
        return false;
    }
    text_anchor = anchor;
    const auto controller = dc2::memory::ArenaBuffer::Bind(memory,
                                                           {reinterpret_cast<u8 *>(this), sizeof(*this)});
    luau_runtime::BindStorage(this, anchor, controller.Bytes().empty() ? std::nullopt : std::optional<dc2::memory::ArenaBuffer>(controller));
    return true;
}

dc2::script::OwnedText CRunScript::RetainText(std::string_view text) {
    const auto storage = dc2::memory::ArenaText::Copy(text_anchor, text);
    if (!storage.Text()) {
        throw dc2::script::ArgumentError("retained script text allocation is retired");
    }
    return dc2::script::OwnedText::FromStorage(storage);
}

void CRunScript::check_stack() {
    if (sp >= stack_end) {
        stkoverflow();
    }
}

void CRunScript::push(RS_STACKDATA data) {
    check_stack();
    RS_STACKDATA *slot = sp;
    sp++;
    slot->type = data.type;
    slot->val = data.val;
}

void CRunScript::push_int(int value) {
    check_stack();
    sp->type = RS_INT;
    RS_STACKDATA *slot = sp;
    sp++;
    slot->val.i = value;
}

void CRunScript::push_str(char *value) {
    check_stack();
    sp->type = RS_STR;
    RS_STACKDATA *slot = sp;
    sp++;
    slot->val.s = value;
}

void CRunScript::push_ptr(RS_STACKDATA *value) {
    check_stack();
    sp->type = RS_PTR;
    RS_STACKDATA *slot = sp;
    sp++;
    slot->val.p = value;
}

void CRunScript::push_float(float value) {
    check_stack();
    sp->type = RS_FLOAT;
    RS_STACKDATA *slot = sp;
    sp++;
    slot->val.f = value;
}

RS_STACKDATA CRunScript::pop() {
    if (sp <= frame + func->local) {
        runerror("stack underflow");
    }
    RS_STACKDATA *top = sp;
    top--;
    sp = top;
    return *top;
}

vmcode_t *CRunScript::call_func(funcdata *callee, vmcode_t *return_pc) {
    if (program_view.empty()) {
        runerror("invalid script program extent");
    }
    if (call_sp >= call_end) {
        dc2::log::PrintGame("\x82\xB1\x82\xEA\x88\xC8\x8F\xE3\x8A\xD6\x90\x94\x8C\xC4\x82\xD1\x8F\x6F\x82\xB5"
                            "\x82\xAA\x82\xC5\x82\xAB\x82\xDC\x82\xB9\x82\xF1\x81\x42\n");
        exit(-2);
    }
    if (!program_view.empty() &&
        (!ContainsPointer(program_view, callee, sizeof(funcdata)) ||
         !ValidFunction(program_view,
                        static_cast<int>(reinterpret_cast<const u8 *>(callee) - program_view.data()),
                        static_cast<int>(code - reinterpret_cast<char *>(program_view.data())),
                        static_cast<std::size_t>(stack_end - stack)))) {
        runerror("invalid script function");
    }

    if (callee->arg < 0 || callee->local < callee->arg || callee->arg > sp - (frame + func->local) ||
        callee->local > stack_end - (sp - callee->arg)) {
        runerror("invalid function stack frame");
    }

    call_sp->ret = return_pc;
    call_sp->func = func;
    call_sp->frame = frame;
    frame = sp - callee->arg;
    sp = frame + callee->local;
    func = callee;
    call_sp++;
    memset(frame + func->arg, 0, (func->local - func->arg) * sizeof(RS_STACKDATA));
    check_stack();
    char *target = CodeTarget(program_view, code, static_cast<int>(callee->addr), sizeof(vmcode_t));
    if (target == nullptr) {
        runerror("invalid script function");
    }
    return reinterpret_cast<vmcode_t *>(target);
}

vmcode_t *CRunScript::ret_func() {
    call_sp--;
    frame = call_sp->frame;
    func = call_sp->func;
    return call_sp->ret;
}

void CRunScript::ext_func(dc2::script::RunFunction *table, int count) {
    ext_func_table = table;
    ext_func_num = count;
}

void CRunScript::exe(vmcode_t *entry) {
    RS_STACKDATA  value{};
    RS_STACKDATA  rhs{};
    RS_STACKDATA  lhs{};
    RS_STACKDATA *target = {};
    float         rhs_f = {};
    float         lhs_f = {};
    int           rhs_i = {};

    pc = entry;
    const auto slot = [this](RS_STACKDATA *base, long long offset) {
        return CheckedSlot(global, stack_end, base, offset);
    };
    const auto pointer_slot = [&](int index) {
        RS_STACKDATA *source = slot(frame, index);
        if (source->type != RS_PTR) {
            runerror("invalid script stack pointer");
        }
        return source->val.p;
    };

    for (;;) {
        if (!ContainsPointer(program_view, pc, sizeof(vmcode_t))) {
            runerror("invalid script instruction");
        }
        switch (pc->op) {
            case RS_OP_LOAD:
                switch (pc->arg2) {
                    case RS_ADDR_LOCAL:
                        push(*slot(frame, pc->arg1));
                        break;
                    case RS_ADDR_GLOBAL:
                        push(*slot(global, pc->arg1));
                        break;
                    case RS_ADDR_LOCAL_INDEX:
                        push(*slot(frame, static_cast<long long>(pc->arg1) + chk_int(pop(), func)));
                        break;
                    case RS_ADDR_POINTER_INDEX:
                        push(*slot(pointer_slot(pc->arg1), chk_int(pop(), func)));
                        break;
                    case RS_ADDR_LOCAL_FLOAT:
                        slot(frame, pc->arg1)->type = RS_FLOAT;
                        push(*slot(frame, pc->arg1));
                        break;
                    case RS_ADDR_GLOBAL_FLOAT:
                        slot(global, pc->arg1)->type = RS_FLOAT;
                        push(*slot(global, pc->arg1));
                        break;
                    case RS_ADDR_LOCAL_INDEX_FLOAT:
                        rhs_i = chk_int(pop(), func);
                        slot(frame, static_cast<long long>(pc->arg1) + rhs_i)->type = RS_FLOAT;
                        push(*slot(frame, static_cast<long long>(pc->arg1) + rhs_i));
                        break;
                    case RS_ADDR_POINTER_INDEX_FLOAT:
                        rhs_i = chk_int(pop(), func);
                        slot(pointer_slot(pc->arg1), rhs_i)->type = RS_FLOAT;
                        push(*slot(pointer_slot(pc->arg1), rhs_i));
                        break;
                }

                break;
            case RS_OP_LOAD_ADDR:
                switch (pc->arg2) {
                    case RS_ADDR_LOCAL:
                        push_ptr(slot(frame, pc->arg1));
                        break;
                    case RS_ADDR_GLOBAL:
                        push_ptr(slot(global, pc->arg1));
                        break;
                    case RS_ADDR_LOCAL_INDEX:
                        push_ptr(slot(frame, static_cast<long long>(pc->arg1) + chk_int(pop(), func)));
                        break;
                    case RS_ADDR_POINTER_INDEX:
                        push_ptr(slot(pointer_slot(pc->arg1), chk_int(pop(), func)));
                        break;
                    case RS_ADDR_LOCAL_FLOAT:
                        push_ptr(slot(frame, pc->arg1));
                        break;
                    case RS_ADDR_GLOBAL_FLOAT:
                        push_ptr(slot(global, pc->arg1));
                        break;
                    case RS_ADDR_LOCAL_INDEX_FLOAT:
                        push_ptr(slot(frame, static_cast<long long>(pc->arg1) + chk_int(pop(), func)));
                        break;
                    case RS_ADDR_POINTER_INDEX_FLOAT:
                        push_ptr(slot(pointer_slot(pc->arg1), chk_int(pop(), func)));
                        break;
                }

                break;
            case RS_OP_STORE:
                value = pop();
                rhs = pop();
                if (rhs.type != RS_PTR) {
                    runerror("invalid script stack pointer");
                }
                target = slot(rhs.val.p, 0);
                target->type = value.type;
                target->val = value.val;
                push(value);
                break;
            case RS_OP_PUSH_CONST:
                if (pc->arg1 == RS_CONST_INT) {
                    push_int(pc->arg2);
                } else if (pc->arg1 == RS_CONST_STR) {
                    char *string = CodeTarget(program_view, code, pc->arg2, 1);
                    if (string == nullptr || (!program_view.empty() &&
                                              std::memchr(string, '\0', reinterpret_cast<char *>(program_view.data() + program_view.size()) - string) == nullptr)) {
                        runerror("invalid script string");
                    }
                    push_str(string);
                } else if (pc->arg1 == RS_CONST_FLOAT) {
                    push_float(pc->arg2_float);
                }

                break;
            case RS_OP_POP:
                pop();
                break;
            case RS_OP_JMP:
                if (!skip_wait) {
                    pc = reinterpret_cast<vmcode_t *>(CodeTarget(program_view, code, pc->arg1, sizeof(vmcode_t)));
                    if (pc == nullptr) {
                        runerror("invalid script jump");
                    }
                    continue;
                }

                break;
            case RS_OP_JMP_TRUE:
                if (!skip_wait) {
                    if (is_true(pop())) {
                        if (pc->arg2) {
                            push_int(1);
                        }

                        pc = reinterpret_cast<vmcode_t *>(CodeTarget(program_view, code, pc->arg1, sizeof(vmcode_t)));
                        if (pc == nullptr) {
                            runerror("invalid script jump");
                        }
                        continue;
                    }
                }

                break;
            case RS_OP_JMP_FALSE:
                if (!skip_wait) {
                    if (!is_true(pop())) {
                        if (pc->arg2) {
                            push_int(0);
                        }

                        pc = reinterpret_cast<vmcode_t *>(CodeTarget(program_view, code, pc->arg1, sizeof(vmcode_t)));
                        if (pc == nullptr) {
                            runerror("invalid script jump");
                        }
                        continue;
                    }
                }

                break;
            case RS_OP_CMP:
                rhs = pop();
                lhs = pop();

                if (lhs.type == RS_INT && rhs.type == RS_INT) {
                    int right = rhs.val.i;
                    int left = lhs.val.i;

                    switch (pc->arg1) {
                        case RS_CMP_EQ:
                            push_int(right == left);
                            break;
                        case RS_CMP_NE:
                            push_int(right != left);
                            break;
                        case RS_CMP_LT:
                            push_int(left < right);
                            break;
                        case RS_CMP_LE:
                            push_int(left <= right);
                            break;
                        case RS_CMP_GT:
                            push_int(left > right);
                            break;
                        case RS_CMP_GE:
                            push_int(left >= right);
                            break;
                    }
                } else {
                    if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                        rhs_f = rhs.val.f;
                        lhs_f = lhs.val.f;
                    } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                        rhs_f = rhs.val.f;
                        lhs_f = lhs.val.i;
                    } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                        rhs_f = rhs.val.i;
                        lhs_f = lhs.val.f;
                    } else {
                        fprintf(stderr, "RUNTIME ERROR at _CMP: %s: operand is not number\n", kUnresolvedFunctionName);
                        exit(-1);
                    }

                    switch (pc->arg1) {
                        case RS_CMP_EQ:
                            push_int(rhs_f == lhs_f);
                            break;
                        case RS_CMP_NE:
                            push_int(rhs_f != lhs_f);
                            break;
                        case RS_CMP_LT:
                            push_int(lhs_f < rhs_f);
                            break;
                        case RS_CMP_LE:
                            push_int(lhs_f <= rhs_f);
                            break;
                        case RS_CMP_GT:
                            push_int(lhs_f > rhs_f);
                            break;
                        case RS_CMP_GE:
                            push_int(lhs_f >= rhs_f);
                            break;
                    }
                }

                break;
            case RS_OP_ADD:
                rhs = pop();
                lhs = pop();

                if (lhs.type == RS_INT && rhs.type == RS_INT) {
                    push_int(IntegerBits(static_cast<std::int64_t>(lhs.val.i) + rhs.val.i));
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.f + rhs.val.f);
                } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.i + rhs.val.f);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                    push_float(lhs.val.f + rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _ADD: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_SUB:
                rhs = pop();
                lhs = pop();

                if (lhs.type == RS_INT && rhs.type == RS_INT) {
                    push_int(IntegerBits(static_cast<std::int64_t>(lhs.val.i) - rhs.val.i));
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.f - rhs.val.f);
                } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.i - rhs.val.f);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                    push_float(lhs.val.f - rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _SUB: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_MUL:
                rhs = pop();
                lhs = pop();

                if (lhs.type == RS_INT && rhs.type == RS_INT) {
                    push_int(IntegerBits(static_cast<std::int64_t>(lhs.val.i) * rhs.val.i));
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.f * rhs.val.f);
                } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.i * rhs.val.f);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                    push_float(lhs.val.f * rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR _MUL: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_DIV:
                rhs = pop();

                if ((rhs.type == RS_INT && rhs.val.i == 0) || (rhs.type == RS_FLOAT && rhs.val.f == 0.0f)) {
                    divby0error();
                }

                lhs = pop();

                if (lhs.type == RS_INT && rhs.type == RS_INT) {
                    push_int(IntegerBits(static_cast<std::int64_t>(lhs.val.i) / rhs.val.i));
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.f / rhs.val.f);
                } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.i / rhs.val.f);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                    push_float(lhs.val.f / rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _DIV: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_MOD:
                rhs_i = chk_int(pop(), func);

                if (rhs_i == 0) {
                    modby0error();
                }

                push_int(static_cast<int>(static_cast<std::int64_t>(chk_int(pop(), func)) % rhs_i));
                break;
            case RS_OP_AND:
                rhs_i = chk_int(pop(), func);
                push_int(rhs_i & chk_int(pop(), func));
                break;
            case RS_OP_OR:
                rhs_i = chk_int(pop(), func);
                push_int(rhs_i | chk_int(pop(), func));
                break;
            case RS_OP_NEG:
                rhs = pop();

                if (rhs.type == RS_INT) {
                    push_int(IntegerBits(-static_cast<std::int64_t>(rhs.val.i)));
                } else if (rhs.type == RS_FLOAT) {
                    push_float(-rhs.val.f);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _INVT: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_SIN:
                rhs = pop();

                if (rhs.type == RS_INT) {
                    push_float(sinf(rhs.val.i));
                } else if (rhs.type == RS_FLOAT) {
                    push_float(sinf(rhs.val.f));
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _SIN: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_COS:
                rhs = pop();

                if (rhs.type == RS_INT) {
                    push_float(cosf(rhs.val.i));
                } else if (rhs.type == RS_FLOAT) {
                    push_float(cosf(rhs.val.f));
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _COS: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_NOT:
                rhs = pop();

                if (rhs.type == RS_INT) {
                    push_int(!rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR: %s: \x90\xAE\x90\x94\x82\xC5\x82\xC8\x82\xA2\x83I\x83y\x83\x89\x83\x93\x83h\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_ITOF:
                rhs = pop();

                if (rhs.type == RS_INT) {
                    push_float(rhs.val.i);
                } else if (rhs.type == RS_FLOAT) {
                    push_float(rhs.val.f);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _ITOF: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_FTOI:
                rhs = pop();

                if (rhs.type == RS_INT) {
                    push_int(rhs.val.i);
                } else if (rhs.type == RS_FLOAT) {
                    const double value = std::trunc(static_cast<double>(rhs.val.f));
                    if (!std::isfinite(value) || value < std::numeric_limits<int>::min() ||
                        value > std::numeric_limits<int>::max()) {
                        runerror("script float exceeds integer range");
                    }
                    push_int(static_cast<int>(value));
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _FTOI: %s: operand is not number\n", kUnresolvedFunctionName);
                    exit(-1);
                }

                break;
            case RS_OP_PRINT:
                if (pc->arg1 < 0 || pc->arg1 > sp - (frame + func->local)) {
                    runerror("stack underflow");
                }
                sp -= pc->arg1;
                print(sp, pc->arg1);
                break;
            case RS_OP_EXT:
                if (pc->arg1 < 1 || pc->arg1 > sp - (frame + func->local)) {
                    runerror("invalid external call stack");
                }
                sp -= pc->arg1;

                if (!skip_wait) {
                    ext(std::span(sp, static_cast<std::size_t>(pc->arg1)));
                    if (!dc2::script::ExecutionValid(this)) {
                        return;
                    }
                }

                break;
            case RS_OP_END:
                end = 1;
                pc = nullptr;
                return;
            case RS_OP_CALL: {
                char *callee_bytes = CodeTarget(program_view, code, pc->arg2, sizeof(funcdata));
                if (callee_bytes == nullptr) {
                    runerror("invalid script function");
                }
                pc = call_func(reinterpret_cast<funcdata *>(callee_bytes), pc);
                continue;
            }
            case RS_OP_RET:
                value = pop();

                if (call_sp != call) {
                    sp = frame;
                    pc = ret_func();
                } else {
                    result = value.val.i;
                    push(value);
                    pc = nullptr;
                    end = 1;
                    return;
                }

                push(value);
                break;
            case RS_OP_NOP:
                break;
            case RS_OP_WAIT:
                if (!skip_wait) {
                    pc++;
                    return;
                }

                break;
            case RS_OP_SKIP_END:
                skip_end_count++;

                if (skip_wait) {
                    skip_wait = 0;
                    pc++;
                    return;
                }

                break;
            default:
                runerror("invalid script opcode");
        }

        pc++;
    }
}

void CRunScript::ResetBytecodeProgram() {
    end = 0;
    skip_wait = 0;
    prog = nullptr;
    code = nullptr;
    program_view = {};
    stack = sp = stack_end = global = frame = nullptr;
    stack_num = 0;
    call = call_sp = call_end = nullptr;
    call_num = 0;
    func = nullptr;
    pc = nullptr;
    result = 0;
    skip_end_count = 0;
    deferred_integer_factory = nullptr;
    deferred_integer_context = nullptr;
    text_anchor = {};
}

void CRunScript::LoadBytecode(std::span<u8> program, std::span<RS_STACKDATA> values, std::span<RS_CALLDATA> calls) {
    stack = values.data();
    global = values.data();
    stack_num = static_cast<int>(values.size());
    call = calls.data();
    call_num = static_cast<int>(calls.size());
    stack_end = values.data() + values.size();
    call_end = calls.data() + calls.size();
    prog = reinterpret_cast<RS_PROG_HEADER *>(program.data());
    code = reinterpret_cast<char *>(program.data()) + prog->code;

    if (strncmp(prog->magic, "SB2", 3) == 0) {
        version = RS_VERSION_2;
        global = stack;
        stack += prog->global_num;
        stack_num -= prog->global_num;
        memset(global, 0, prog->global_num * sizeof(RS_STACKDATA));
    }
}

void CRunScript::ResumeBytecode() {
    vmcode_t *point = {};

    point = pc;

    if (point != nullptr) {
        exe(point);
    }
}

int CRunScript::RunBytecode(int no) {
    RS_PROGDATA    *entry = {};
    int             i = {};
    RS_PROG_HEADER *header = {};
    vmcode_t       *start = {};

    if (prog == nullptr) {
        return -1;
    }

    sp = stack;
    call_sp = call;
    func = nullptr;

    if (no < 0) {
        func = reinterpret_cast<funcdata *>(reinterpret_cast<char *>(prog) + prog->main);
    } else {
        header = prog;
        entry = reinterpret_cast<RS_PROGDATA *>(reinterpret_cast<char *>(header) + header->prog);

        for (i = 0; i < header->prog_num; i++, entry++) {
            if (entry->no == no) {
                func = reinterpret_cast<funcdata *>(reinterpret_cast<char *>(header) + entry->func);
                break;
            }
        }
    }

    if (func == nullptr) {
        dc2::log::PrintGame("not found program %d\n", no);
        return -1;
    }

    if (func->arg != 0 || func->local < 0 || func->local >= stack_end - stack) {
        runerror("invalid function stack frame");
    }

    frame = sp - func->arg;
    sp = frame + func->local;
    check_stack();
    memset(frame + func->arg, 0, (func->local - func->arg) * sizeof(RS_STACKDATA));
    int code_offset = func->addr;
    start = reinterpret_cast<vmcode_t *>(&code[code_offset]);
    end = 0;
    skip_wait = 0;
    skip_end_count = 0;
    exe(start);
    if (!dc2::script::ExecutionValid(this)) {
        return -1;
    }

    if (end != 0) {
        return 0;
    }

    return 1;
}

void CRunScript::SkipBytecode() {
    skip_wait = 1;
    resume();
}

#include "common.h"

#include "runscript.hpp"
#include "script_guards.hpp"

// Retail's printf diagnostics, logged as the game's own (docs/LOGGING.md).
#include "log/game_output.hpp"

void CRunScript::DeleteProgram() {
    luau_runtime::Forget(this);
    ResetBytecodeProgram();
}

// Externals that index fixed tables or copy into fixed fields with script values are checked first, so
// out-of-range arguments are refused like an illegal call instead of reaching past the table.
int dc2::script::InvokeRunFunction(RunFunction function, RunArguments arguments, int count, int index) {
    if (function == nullptr || count < 0 || static_cast<std::size_t>(count) != arguments.Remaining()) {
        return 0;
    }
    try {
        if (!script_guards::AllowExternal(function, arguments, count, index)) {
            return 0;
        }
        return function(arguments, count);
    } catch (const ArgumentError &) {
        return 0;
    }
}

void CRunScript::ext(std::span<RS_STACKDATA>                arguments,
                     std::span<const std::span<const char>> other_text,
                     std::span<RS_STACKDATA>                external_writable,
                     dc2::script::DeferredIntegerFactory deferred_factory, void *deferred_context) {
    if (!dc2::script::ExecutionValid(this)) {
        return;
    }
    if (arguments.empty() || arguments.size() > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        arguments.front().type != RS_INT) {
        dc2::log::PrintGame("invalid ext command\n");
        return;
    }
    const int index = arguments.front().val.i;
    if (index < 0 || index >= ext_func_num || ext_func_table[index] == nullptr) {
        dc2::log::PrintGame("not found ext %d\n", index);
        return;
    }
    const auto                      text = std::span(reinterpret_cast<char *>(program_view.data()), program_view.size());
    const auto                      writable = !external_writable.empty()
                                                   ? external_writable
                                               : global != nullptr && stack_end != nullptr
                                                   ? std::span(global, static_cast<std::size_t>(stack_end - global))
                                                   : std::span<RS_STACKDATA>();
    const auto                      function = ext_func_table[index];
    const auto                      operands = arguments.subspan(1);
    const int                       count = static_cast<int>(operands.size());
    const dc2::script::RunArguments checked(operands, text, writable, other_text,
                                            deferred_factory != nullptr ? deferred_factory : deferred_integer_factory,
                                            deferred_factory != nullptr ? deferred_context : deferred_integer_context,
                                            CaptureScriptText, this);
    const int                       result = dc2::script::InvokeRunFunction(function, checked, count, index);
    if (!dc2::script::ExecutionValid(this) || result != 0) {
        return;
    }
    const auto source = DataReadBufferPath(program_view.data());
    dc2::log::PrintGame("illegal function call ext %d: source=%s table_size=%d argc=%d\n", index,
                        source ? source->c_str() : "<unregistered>", ext_func_num, count);
#if defined(__linux__)
    Dl_info handler_info{};
    if (dladdr(reinterpret_cast<const void *>(function), &handler_info) != 0 && handler_info.dli_fbase != nullptr) {
        const auto base = reinterpret_cast<std::uintptr_t>(handler_info.dli_fbase);
        dc2::log::PrintGame("  handler=%s module=%s offset=%zx table=%p\n",
                            handler_info.dli_sname != nullptr ? handler_info.dli_sname : "<local symbol>",
                            handler_info.dli_fname != nullptr ? handler_info.dli_fname : "<unknown>",
                            static_cast<std::size_t>(reinterpret_cast<std::uintptr_t>(function) - base),
                            static_cast<const void *>(ext_func_table));
    }
#endif
    for (std::size_t operand = 0; operand < operands.size(); ++operand) {
        const auto  type = operands[operand].type;
        const char *kind = "invalid";
        switch (type) {
            case RS_INT:
                kind = "integer";
                break;
            case RS_FLOAT:
                kind = "float";
                break;
            case RS_STR:
                kind = "text";
                break;
            case RS_PTR:
                kind = "reference";
                break;
        }
        dc2::log::PrintGame("  operand[%zu]=%s tag=%d\n", operand, kind, static_cast<int>(type));
    }
}

bool CRunScript::load(std::span<u8> program, std::span<RS_STACKDATA> values, std::span<RS_CALLDATA> calls) {
    const auto reject = [this] {
        DeleteProgram();
        return false;
    };
    if (program.empty() || program.size() > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        values.empty() || calls.empty() ||
        values.size() > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        calls.size() > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        return reject();
    }
    const std::span<const char> text(reinterpret_cast<const char *>(program.data()), program.size());
    if (program.size() >= 4 && std::memcmp(program.data(), "LUAU", 4) == 0) {
        const auto module = luau_runtime::HandleModule(text);
        if (!module) {
            return reject();
        }
        luau_runtime::Forget(this);
        stack = values.data();
        global = values.data();
        stack_num = static_cast<int>(values.size());
        stack_end = values.data() + values.size();
        call = calls.data();
        call_num = static_cast<int>(calls.size());
        call_end = calls.data() + calls.size();
        prog = reinterpret_cast<RS_PROG_HEADER *>(program.data());
        code = nullptr;
        version = RS_VERSION_2;
        program_view = program;
        luau_runtime::Load(this, *module);
        return true;
    }

    if (program.size() < sizeof(RS_PROG_HEADER) ||
        reinterpret_cast<std::uintptr_t>(program.data()) % alignof(RS_PROG_HEADER) != 0) {
        return reject();
    }
    RS_PROG_HEADER header{};
    std::memcpy(&header, program.data(), sizeof header);
    const bool sb2 = std::memcmp(header.magic, "SB2", 3) == 0;
    if (header.main < 0 || header.code < 0 || header.prog < 0 || header.prog_num < 0 ||
        header.prog % alignof(RS_PROGDATA) != 0 ||
        (sb2 && (header.global_num < 0 || static_cast<std::size_t>(header.global_num) >= values.size())) ||
        !ContainsBytes(program, static_cast<std::size_t>(header.code), sizeof(vmcode_t)) ||
        !ContainsBytes(program, static_cast<std::size_t>(header.prog),
                       static_cast<std::size_t>(header.prog_num) * sizeof(RS_PROGDATA)) ||
        !ValidFunction(program, header.main, header.code,
                       values.size() - static_cast<std::size_t>(sb2 ? header.global_num : 0))) {
        return reject();
    }
    for (int index = 0; index < header.prog_num; ++index) {
        RS_PROGDATA entry{};
        std::memcpy(&entry, program.data() + header.prog + static_cast<std::size_t>(index) * sizeof entry, sizeof entry);
        if (!ValidFunction(program, entry.func, header.code,
                           values.size() - static_cast<std::size_t>(sb2 ? header.global_num : 0))) {
            return reject();
        }
    }
    luau_runtime::Forget(this);
    program_view = program;
    LoadBytecode(program, values, calls);
    return true;
}

void CRunScript::resume() {
    if (!dc2::script::ExecutionValid(this)) {
        return;
    }
    if (luau_runtime::Owns(this)) {
        luau_runtime::Resume(this);
        return;
    }
    ResumeBytecode();
}

int CRunScript::run(int no) {
    if (!dc2::script::ExecutionValid(this)) {
        return -1;
    }
    if (luau_runtime::Owns(this)) {
        return luau_runtime::Run(this, no);
    }
    return RunBytecode(no);
}

int CRunScript::check_program(int no) {
    if (luau_runtime::Owns(this)) {
        return luau_runtime::HasProgram(this, no) ? 1 : 0;
    }
    // Town characters can be reset without an action program, as run() also allows.
    if (prog == nullptr) {
        return 0;
    }
    const auto *entries = reinterpret_cast<const RS_PROGDATA *>(reinterpret_cast<const char *>(prog) + prog->prog);
    for (int i = 0; i < prog->prog_num; ++i) {
        if (entries[i].no == no) {
            return 1;
        }
    }
    return 0;
}

void CRunScript::skip() {
    if (luau_runtime::Owns(this)) {
        luau_runtime::Skip(this);
        return;
    }
    SkipBytecode();
}
