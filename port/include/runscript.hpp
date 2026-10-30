#pragma once

#include "common.h"

#include <cmath>
#include <limits>
#include <span>
#include <string_view>

#include "mg_memory.hpp"
#include "script/argument_view.hpp"

/**
 * @file
 * Declares the stack-based virtual machine that runs compiled scripts for
 * characters, monsters, effects and events, and the data a compiled script
 * program is made of.
 */

/**
 *
 * Opcodes of the script virtual machine, as vmcode_t::op holds them.
 *
 */
// clang-format off
enum RS_OPCODE {
    RS_OP_LOAD       = 1,  /**< Push a variable. */
    RS_OP_LOAD_ADDR  = 2,  /**< Push a variable's address. */
    RS_OP_PUSH_CONST = 3,  /**< Push a constant. */
    RS_OP_POP        = 4,  /**< Pop. */
    RS_OP_STORE      = 5,  /**< Store. */
    RS_OP_ADD        = 6,  /**< Add. */
    RS_OP_SUB        = 7,  /**< Subtract. */
    RS_OP_MUL        = 8,  /**< Multiply. */
    RS_OP_DIV        = 9,  /**< Divide. */
    RS_OP_MOD        = 10, /**< Remainder. */
    RS_OP_NEG        = 11, /**< Negate. */
    RS_OP_ITOF       = 12, /**< Integer to float. */
    RS_OP_FTOI       = 13, /**< Float to integer. */
    RS_OP_CMP        = 14, /**< Compare. */
    RS_OP_RET        = 15, /**< Return. */
    RS_OP_JMP        = 16, /**< Jump. */
    RS_OP_JMP_FALSE  = 17, /**< Jump if false. */
    RS_OP_JMP_TRUE   = 18, /**< Jump if true. */
    RS_OP_CALL       = 19, /**< Call a script function. */
    RS_OP_PRINT      = 20, /**< Print. */
    RS_OP_EXT        = 21, /**< Call an external function. */
    RS_OP_NOP        = 22, /**< Preserve a timing marker without changing execution state. */
    RS_OP_WAIT       = 23, /**< Suspend until the next resume. */
    RS_OP_AND        = 24, /**< Bitwise and. */
    RS_OP_OR         = 25, /**< Bitwise or. */
    RS_OP_NOT        = 26, /**< Logical not. */
    RS_OP_END        = 27, /**< End the script. */
    RS_OP_SKIP_END   = 28, /**< End a skippable stretch, suspending if it was skipped. */
    RS_OP_SIN        = 29, /**< Sine. */
    RS_OP_COS        = 30, /**< Cosine. */
};

// clang-format on

/**
 *
 * How a load or address-load instruction finds its variable, as
 * vmcode_t::arg2 holds it.
 *
 */
// clang-format off
enum RS_ADDR_MODE {
    RS_ADDR_LOCAL               = 0x1,   /**< Local slot. */
    RS_ADDR_LOCAL_INDEX         = 0x2,   /**< Indexed local slot. */
    RS_ADDR_POINTER_INDEX       = 0x4,   /**< Indexed through a pointer in a local slot. */
    RS_ADDR_LOCAL_FLOAT         = 0x8,   /**< Local slot, as a float. */
    RS_ADDR_LOCAL_INDEX_FLOAT   = 0x10,  /**< Indexed local slot, as a float. */
    RS_ADDR_POINTER_INDEX_FLOAT = 0x20,  /**< Indexed through a pointer in a local slot, as a float. */
    RS_ADDR_GLOBAL              = 0x40,  /**< Global slot. */
    RS_ADDR_GLOBAL_FLOAT        = 0x200, /**< Global slot, as a float. */
};

// clang-format on

/**
 *
 * Kind of constant a push-constant instruction pushes, as vmcode_t::arg1
 * holds it.
 *
 */
// clang-format off
enum RS_CONST_TYPE {
    RS_CONST_INT   = 1, /**< Integer held in vmcode_t::arg2. */
    RS_CONST_FLOAT = 2, /**< Float held in vmcode_t::arg2_float. */
    RS_CONST_STR   = 3, /**< String at the code-section offset vmcode_t::arg2 holds. */
};

// clang-format on

/**
 *
 * Comparisons of the compare opcode, as vmcode_t::arg1 holds them.
 *
 */
// clang-format off
enum RS_COMPARE {
    RS_CMP_EQ = 40, /**< Equal. */
    RS_CMP_NE = 41, /**< Not equal. */
    RS_CMP_LT = 42, /**< Less than. */
    RS_CMP_LE = 43, /**< Less than or equal. */
    RS_CMP_GT = 44, /**< Greater than. */
    RS_CMP_GE = 45, /**< Greater than or equal. */
};

// clang-format on

/**
 *
 * Kind of value an operand stack slot holds, as RS_STACKDATA::type holds it.
 *
 */
// clang-format off
enum RS_STACK_TYPE {
    RS_INT   = 0, /**< Integer. */
    RS_FLOAT = 1, /**< Float. */
    RS_STR   = 2, /**< String. */
    RS_PTR   = 3, /**< Reference to another stack slot. */
};

// clang-format on

/**
 *
 * Program format an interpreter is running, as CRunScript::version holds it.
 *
 */
// clang-format off
enum RS_VERSION {
    RS_VERSION_1 = 1, /**< Program with no global variables. */
    RS_VERSION_2 = 2, /**< Program signed "SB2", with a block of global variables. */
};

// clang-format on

/**
 *
 * A tagged value stored on the script interpreter's operand stack.
 *
 */
struct RS_STACKDATA {
    int type; /**< Kind of value held. @see RS_STACK_TYPE. */

    union {
        float         f; /**< Value of a float. */
        int           i; /**< Value of an integer. */
        char         *s; /**< Value of a string. */
        RS_STACKDATA *p; /**< Stack slot a reference points at. */
    } val;               /**< Value held by this stack slot. */
};

STATIC_ASSERT(sizeof(RS_STACKDATA) == 0x8);

namespace dc2::script {

/**
 *
 * Keeps immutable command text tied to its exact arena allocation and owner generation.
 *
 */
class OwnedText {
public:
    /**
     *
     * Wraps a terminated text allocation whose lifetime is already explicit.
     *
     */
    static OwnedText FromStorage(dc2::memory::ArenaText value) {
        OwnedText result;
        result.storage = value;
        result.assigned = true;
        return result;
    }

    /**
     *
     * Returns bounded text only while its backing allocation remains live and terminated.
     *
     */
    [[nodiscard]] std::optional<std::string_view> Text() const {
        return storage.Text();
    }

    /**
     *
     * Borrows the checked terminator for an immediate legacy text consumer.
     *
     */
    [[nodiscard]] char *CString() const {
        const auto text = Text();
        return text ? const_cast<char *>(text->data()) : nullptr;
    }

    /**
     *
     * Distinguishes an absent optional selector from one whose backing allocation retired.
     *
     */
    [[nodiscard]] bool HasValue() const { return assigned; }

    /**
     *
     * Reports missing or retired text without reading an invalid allocation.
     *
     */
    [[nodiscard]] bool operator==(std::nullptr_t) const { return CString() == nullptr; }

    /**
     *
     * Clears this reference while immutable arena storage remains available to other readers.
     *
     */
    OwnedText &operator=(std::nullptr_t) {
        storage = {};
        assigned = false;
        return *this;
    }

private:
    dc2::memory::ArenaText storage;          /**< Exact immutable text allocation. */
    bool                   assigned = false; /**< Whether this selector was explicitly supplied. */
};

static_assert(std::is_trivially_copyable_v<OwnedText>);
static_assert(std::is_trivially_destructible_v<OwnedText>);

/**
 *
 * Carries the actual operands supplied to one run-script external.
 *
 */
using RunArguments = ArgumentView<RS_STACKDATA, OwnedText>;

/**
 *
 * Reads a finite integer or floating-point argument as an integer.
 *
 */
inline int RunInteger(RunArguments argument) {
    const RS_STACKDATA &value = argument.At();
    if (value.type == RS_INT) {
        return value.val.i;
    }
    if (value.type == RS_FLOAT) {
        const double number = value.val.f;
        if (std::isfinite(number) && number >= std::numeric_limits<int>::min() &&
            number < static_cast<double>(std::numeric_limits<int>::max()) + 1.0) {
            return static_cast<int>(number);
        }
    }
    throw ArgumentError("script argument is not a finite integer");
}

/**
 *
 * Reads a finite numeric argument as a float.
 *
 */
inline float RunFloat(RunArguments argument) {
    const RS_STACKDATA &value = argument.At();
    if (value.type == RS_INT) {
        return static_cast<float>(value.val.i);
    }
    if (value.type == RS_FLOAT && std::isfinite(value.val.f)) {
        return value.val.f;
    }
    throw ArgumentError("script argument is not a finite number");
}

/**
 *
 * Reads a string within the loaded program's exact byte extent.
 *
 */
inline std::string_view RunText(RunArguments argument) {
    const RS_STACKDATA &value = argument.At();
    if (value.type != RS_STR) {
        throw ArgumentError("script argument is not text");
    }
    return argument.Text(value.val.s);
}

/**
 *
 * Gives an existing C-string consumer a validated script string.
 *
 */
inline char *RunCString(RunArguments argument) {
    const RS_STACKDATA &value = argument.At();
    if (value.type != RS_STR) {
        throw ArgumentError("script argument is not text");
    }
    return argument.CString(value.val.s);
}

/**
 *
 * Finds a referenced result slot inside the live script stack.
 *
 */
inline RS_STACKDATA &RunOutput(RunArguments argument) {
    const RS_STACKDATA &value = argument.At();
    if (value.type != RS_PTR) {
        throw ArgumentError("script argument is not an output reference");
    }
    return argument.Writable(value.val.p);
}

/**
 *
 * Completes an integer result through its producer's lifetime-aware storage.
 *
 */
using DeferredIntegerWriter = RunArguments::DeferredIntegerWriter;
using DeferredIntegerFactory = RunArguments::DeferredIntegerFactory;

/**
 *
 * Captures a live integer result that its producer permits a later callback to complete.
 *
 */
inline DeferredIntegerWriter RunDeferredInteger(RunArguments argument) {
    return argument.DeferInteger(RunOutput(argument));
}

/**
 *
 * Retains a validated argument in the invocation producer's owned text arena.
 *
 */
inline OwnedText RunRetainedText(RunArguments argument) {
    return argument.RetainText(RunText(argument));
}

/**
 *
 * Invokes one external with its validated argument and provenance view.
 *
 */
using RunFunction = int (*)(RunArguments arguments, int count);

/**
 *
 * Validates a callback's semantic rules and rejects malformed arguments at the invocation boundary.
 *
 */
int InvokeRunFunction(RunFunction function, RunArguments arguments, int count, int index = -1);

/**
 *
 * Normalizes a checked callback that reads its extent from the argument view.
 *
 */
template <int (*Function)(RunArguments)>
int AdaptRunArguments(RunArguments arguments, int) {
    return Function(arguments);
}

/**
 *
 * Normalizes a checked callback that also reads the explicit argument count.
 *
 */
template <int (*Function)(RunArguments, int)>
int AdaptRunArguments(RunArguments arguments, int count) {
    return Function(arguments, count);
}

} // namespace dc2::script

/**
 *
 * A single virtual-machine instruction and its two opcode-specific
 * operands.
 *
 */
struct vmcode_t {
    int op;   /**< Operation to execute. @see RS_OPCODE. */
    int arg1; /**< First operand. */

    union {
        int   arg2;       /**< Second operand. */
        float arg2_float; /**< Second operand of a RS_CONST_FLOAT constant push. */
    }; /**< Second operand, read by type for a constant push. */
};

STATIC_ASSERT(sizeof(vmcode_t) == 0xC);
PORT_RECORD_ASSERT(sizeof(vmcode_t) == 0xC);

/**
 *
 * Describes a script function's code position and stack-frame
 * requirements.
 *
 */
struct funcdata {
    u32 addr;  /**< Nonnegative byte offset of the function's first instruction in the code section. */
    u32 name;  /**< Script compiler's name word; unresolved and zero on the disc, 32-bit because the struct is read in place. */
    int local; /**< Number of frame slots, arguments included. */
    int arg;   /**< Number of argument slots. */
};

STATIC_ASSERT(sizeof(funcdata) == 0x10);
PORT_RECORD_ASSERT(sizeof(funcdata) == 0x10);

/**
 *
 * Reads an integer operand or reports a script type error.
 *
 */
int chk_int(RS_STACKDATA data, funcdata *func);

/**
 *
 * Caller state saved on the call stack while a script function runs.
 *
 */
struct RS_CALLDATA {
    vmcode_t     *ret;   /**< Caller's call instruction, to return to. */
    RS_STACKDATA *frame; /**< Caller's stack frame. */
    funcdata     *func;  /**< Caller's function. */
};

STATIC_ASSERT(sizeof(RS_CALLDATA) == 0xC);

/**
 *
 * Maps an externally selectable program number to its function.
 *
 */
struct RS_PROGDATA {
    int no;   /**< Program number. */
    int func; /**< Offset of the program's funcdata from the program header. */
};

STATIC_ASSERT(sizeof(RS_PROGDATA) == 0x8);
PORT_RECORD_ASSERT(sizeof(RS_PROGDATA) == 0x8);

/**
 *
 * Header of a compiled script program, locating its sections by offset from
 * the header.
 *
 */
struct RS_PROG_HEADER {
    char magic[4]; /**< Format signature; "SB2" for a program with global variables. */
    int  main;     /**< Offset of the main function's funcdata. */
    int  code;     /**< Offset of the code section. */
    int  prog;     /**< Offset of the program table. */
    int  prog_num; /**< Number of program-table entries. */
    int  unk_14;
    int  global_num; /**< Number of global variable slots. */
};

/**
 *
 * Runs one compiled script on a stack machine, suspending at its waits.
 *
 */
class CRunScript {
public:
    int                                 version;                            /**< Format of the loaded program. @see RS_VERSION. */
    int                                 ext_func_num;                       /**< Number of registered external functions. */
    dc2::script::DeferredIntegerFactory deferred_integer_factory = nullptr; /**< Factory for persistent native event result slots. */
    void                               *deferred_integer_context = nullptr; /**< Context owned by the deferred-result producer. */
    dc2::script::RunFunction           *ext_func_table;                     /**< External functions scripts can call. */
    int                                 stack_num;                          /**< Operand stack capacity, in slots. */
    RS_STACKDATA                       *stack;                              /**< Bottom of the operand stack, above the global slots. */
    RS_STACKDATA                       *sp;                                 /**< Next free operand stack slot. */
    RS_STACKDATA                       *stack_end;                          /**< End of the operand stack storage. */
    RS_STACKDATA                       *global;                             /**< Global variable slots. */
    int                                 call_num;                           /**< Call stack capacity, in entries. */
    RS_CALLDATA                        *call;                               /**< Bottom of the call stack. */
    RS_CALLDATA                        *call_sp;                            /**< Next free call stack entry. */
    RS_CALLDATA                        *call_end;                           /**< End of the call stack storage. */
    RS_STACKDATA                       *frame;                              /**< Active function's stack frame. */
    funcdata                           *func;                               /**< Active function. */
    vmcode_t                           *pc;                                 /**< Next instruction; null when not suspended. */
    int                                 end;                                /**< Nonzero once the script has finished. */
    int                                 skip_wait;                          /**< Nonzero to run through waits until a skip end. */
    RS_PROG_HEADER                     *prog;                               /**< Loaded program. */
    char                               *code;                               /**< Loaded program's code section. */
    int                                 result;                             /**< Value the main function returned. */
    int                                 skip_end_count;                     /**< Number of skip ends reached since the script started. */
    std::span<u8>                       program_view;                       /**< Actual bytes of a validated native program during execution. */

    /**
     *
     * Makes an interpreter with no program, stack or external
     * functions.
     *
     * @mangled __ct__10CRunScriptFv
     * @address 0x188280
     * @size 0x64
     */
    CRunScript();

    /**
     *
     * Binds retained command text to the actual arena allocation that owns the script stack.
     *
     */
    bool BindRetainedTextArena(mgCMemory &memory, std::span<RS_STACKDATA> values);
    /**
     *
     * Interns exact command text in the live script arena without retaining its input pointer.
     *
     */
    dc2::script::OwnedText RetainText(std::string_view text);

    /**
     *
     * Detaches the loaded program and clears the finished and skip
     * states.
     *
     * @mangled DeleteProgram__10CRunScriptFv
     * @address 0x1882F0
     * @size 0x10
     */
    void DeleteProgram();

    /**
     *
     * Stops the game when the operand stack is full.
     *
     * @mangled check_stack__10CRunScriptFv
     * @address 0x188300
     * @size 0x30
     */
    void check_stack();

    /**
     *
     * Pushes one value onto the operand stack.
     *
     * @mangled push__10CRunScriptF12RS_STACKDATA
     * @address 0x188330
     * @size 0x48
     */
    void push(RS_STACKDATA data);

    /**
     *
     * Pushes an integer onto the operand stack.
     *
     * @mangled push_int__10CRunScriptFi
     * @address 0x188380
     * @size 0x48
     */
    void push_int(int value);

    /**
     *
     * Pushes a string onto the operand stack.
     *
     * @mangled push_str__10CRunScriptFPc
     * @address 0x1883D0
     * @size 0x4C
     */
    void push_str(char *value);

    /**
     *
     * Pushes a reference to a stack slot onto the operand stack.
     *
     * @mangled push_ptr__10CRunScriptFP12RS_STACKDATA
     * @address 0x188420
     * @size 0x4C
     */
    void push_ptr(RS_STACKDATA *value);

    /**
     *
     * Pushes a float onto the operand stack.
     *
     * @mangled push_float__10CRunScriptFf
     * @address 0x188470
     * @size 0x4C
     */
    void push_float(float value);

    /**
     *
     * Pops the top value off the operand stack.
     *
     * @mangled pop__10CRunScriptFv
     * @address 0x1884C0
     * @size 0x20
     */
    RS_STACKDATA pop();

    /**
     *
     * Enters a script function, and gives back its first instruction.
     *
     * @mangled call_func__10CRunScriptFP8funcdataP8vmcode_t
     * @address 0x1884E0
     * @size 0xF0
     */
    vmcode_t *call_func(funcdata *callee, vmcode_t *return_pc);

    /**
     *
     * Leaves the current script function, and gives back the caller's
     * call instruction.
     *
     * @mangled ret_func__10CRunScriptFv
     * @address 0x1885D0
     * @size 0x30
     */
    vmcode_t *ret_func();

    /**
     *
     * Calls an external with a proven slot extent and additional native argument storage.
     *
     */
    void ext(std::span<RS_STACKDATA>                arguments,
             std::span<const std::span<const char>> other_text = {},
             std::span<RS_STACKDATA>                external_writable = {},
             dc2::script::DeferredIntegerFactory deferred_factory = nullptr, void *deferred_context = nullptr);

    /**
     *
     * Validates and loads a program with its actual byte extent.
     *
     */
    bool load(std::span<u8> program, std::span<RS_STACKDATA> values, std::span<RS_CALLDATA> calls);

    /**
     *
     * Registers the table of external functions scripts can call.
     *
     * @mangled ext_func__10CRunScriptFPPFP12RS_STACKDATAi_ii
     * @address 0x188780
     * @size 0xC
     */
    void ext_func(dc2::script::RunFunction *table, int count);

    /**
     *
     * Continues a suspended script where it stopped.
     *
     * @mangled resume__10CRunScriptFv
     * @address 0x188790
     * @size 0x28
     */
    void resume();

    /**
     *
     * Starts a numbered program, or the main function for a negative
     * number; gives back 1 if it suspended, 0 if it ended, -1 on failure.
     *
     * @mangled run__10CRunScriptFi
     * @address 0x1887C0
     * @size 0x150
     */
    int run(int no);

    /**
     *
     * Reports whether the program has a numbered entry.
     *
     * @mangled check_program__10CRunScriptFi
     * @address 0x188910
     * @size 0x4C
     */
    int check_program(int no);

    /**
     *
     * Resumes the script, running through its waits up to the next
     * skip end.
     *
     * @mangled skip__10CRunScriptFv
     * @address 0x188960
     * @size 0xC
     */
    void skip();

    /**
     *
     * Runs instructions from one until the script ends or waits.
     *
     * @mangled exe__10CRunScriptFP8vmcode_t
     * @address 0x188970
     * @size 0x145C
     */
    void exe(vmcode_t *entry);
    /**
     *
     * Clears the state of the bytecode interpreter.
     *
     */
    void ResetBytecodeProgram();
    /**
     *
     * Loads a compiled bytecode program into the interpreter.
     *
     */
    void LoadBytecode(std::span<u8> program, std::span<RS_STACKDATA> values, std::span<RS_CALLDATA> calls);
    /**
     *
     * Continues the bytecode program after a wait.
     *
     */
    void ResumeBytecode();
    /**
     *
     * Runs a numbered bytecode entry point.
     *
     */
    int RunBytecode(int no);
    /**
     *
     * Advances the bytecode program through its next wait.
     *
     */
    void SkipBytecode();

private:
    dc2::memory::ArenaBuffer text_anchor; /**< Exact script-stack allocation authorizing retained text. */
};

STATIC_ASSERT(sizeof(CRunScript) == 0x54);
