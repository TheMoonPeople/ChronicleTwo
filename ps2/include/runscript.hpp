#pragma once

#include "common.h"

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

/**
 *
 * Describes a script function's code position and stack-frame
 * requirements.
 *
 */
struct funcdata {
    u32   addr;  /**< Nonnegative byte offset of the function's first instruction in the code section. */
    char *name;  /**< Name of the function, for runtime error messages. */
    int   local; /**< Number of frame slots, arguments included. */
    int   arg;   /**< Number of argument slots. */
};

STATIC_ASSERT(sizeof(funcdata) == 0x10);

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
    int version;                                 /**< Format of the loaded program. @see RS_VERSION. */
    int ext_func_num;                            /**< Number of registered external functions. */
    int (**ext_func_table)(RS_STACKDATA *, int); /**< External functions scripts can call. */
    int             stack_num;                   /**< Operand stack capacity, in slots. */
    RS_STACKDATA   *stack;                       /**< Bottom of the operand stack, above the global slots. */
    RS_STACKDATA   *sp;                          /**< Next free operand stack slot. */
    RS_STACKDATA   *stack_end;                   /**< End of the operand stack storage. */
    RS_STACKDATA   *global;                      /**< Global variable slots. */
    int             call_num;                    /**< Call stack capacity, in entries. */
    RS_CALLDATA    *call;                        /**< Bottom of the call stack. */
    RS_CALLDATA    *call_sp;                     /**< Next free call stack entry. */
    RS_CALLDATA    *call_end;                    /**< End of the call stack storage. */
    RS_STACKDATA   *frame;                       /**< Active function's stack frame. */
    funcdata       *func;                        /**< Active function. */
    vmcode_t       *pc;                          /**< Next instruction; null when not suspended. */
    int             end;                         /**< Nonzero once the script has finished. */
    int             skip_wait;                   /**< Nonzero to run through waits until a skip end. */
    RS_PROG_HEADER *prog;                        /**< Loaded program. */
    char           *code;                        /**< Loaded program's code section. */
    int             result;                      /**< Value the main function returned. */
    int             skip_end_count;              /**< Number of skip ends reached since the script started. */

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
     * Calls the external function the first argument names.
     *
     * @mangled ext__10CRunScriptFP12RS_STACKDATAi
     * @address 0x188600
     * @size 0x9C
     */
    void ext(RS_STACKDATA *command, int arg_count);

    /**
     *
     * Gives the interpreter a program and the stacks to run it on,
     * reserving global slots for an "SB2" program.
     *
     * @mangled load__10CRunScriptFP14RS_PROG_HEADERP12RS_STACKDATAiP11RS_CALLDATAi
     * @address 0x1886A0
     * @size 0xD8
     */
    void load(RS_PROG_HEADER *prog, RS_STACKDATA *values, int value_count, RS_CALLDATA *call, int call_count);

    /**
     *
     * Registers the table of external functions scripts can call.
     *
     * @mangled ext_func__10CRunScriptFPPFP12RS_STACKDATAi_ii
     * @address 0x188780
     * @size 0xC
     */
    void ext_func(int (**table)(RS_STACKDATA *, int), int count);

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
};

STATIC_ASSERT(sizeof(CRunScript) == 0x54);

/**
 *
 * Reads a script argument as an integer, converting a float.
 *
 * @mangled rsGetStackInt__FP12RS_STACKDATA
 * @address 0x189DD0
 * @size 0x3C
 */
int rsGetStackInt(RS_STACKDATA *data);

/**
 *
 * Stores an integer through a script argument that references a
 * stack slot, doing nothing for any other argument.
 *
 * @mangled rsSetStack__FP12RS_STACKDATAi
 * @address 0x189E10
 * @size 0x20
 */
void rsSetStack(RS_STACKDATA *data, int value);
