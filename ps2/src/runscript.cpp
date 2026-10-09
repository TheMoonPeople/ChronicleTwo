#include "common.h"

#include "runscript.hpp"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Code (.text)
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

    fprintf(stderr, "RUNTIME ERROR: %s: operand is not integer\n", func->name);
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
                printf("%d", slots->val.i);
            } else if (slots->type == RS_STR) {
                printf("%s", slots->val.i);
            } else if (slots->type == RS_FLOAT) {
                printf("%f", slots->val.f);
            }

            fflush(stdout);
            i++;
            slots++;
        } while (i < count);
    }
}

CRunScript::CRunScript() {
    sp = stack;
    stack_end = stack;
    call_sp = call;
    call_end = call;
    pc = 0;
    ext_func_num = 0;
    stack_num = 0;
    call_num = 0;
    skip_wait = 0;
    version = 1;
    DeleteProgram();
}

void CRunScript::DeleteProgram() {
    end = 0;
    skip_wait = 0;
    prog = NULL;
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
    RS_STACKDATA *top = sp;
    top--;
    sp = top;
    return *top;
}

vmcode_t *CRunScript::call_func(funcdata *callee, vmcode_t *return_pc) {
    if (call_sp >= call_end) {
        printf("\x82\xB1\x82\xEA\x88\xC8\x8F\xE3\x8A\xD6\x90\x94\x8C\xC4\x82\xD1\x8F\x6F\x82\xB5"
               "\x82\xAA\x82\xC5\x82\xAB\x82\xDC\x82\xB9\x82\xF1\x81\x42\n");
        exit(-2);
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
    int code_offset = callee->addr;
    return reinterpret_cast<vmcode_t *>(&code[code_offset]);
}

vmcode_t *CRunScript::ret_func() {
    call_sp--;
    frame = call_sp->frame;
    func = call_sp->func;
    return call_sp->ret;
}

void CRunScript::ext(RS_STACKDATA *command, int arg_count) {
    int index = command->val.i;
    int (*func)(RS_STACKDATA *, int);

    if (index < 0 || index >= ext_func_num) {
        printf("not found ext %d\n", index);
        return;
    }

    func = ext_func_table[index];

    if (func == 0) {
        printf("not found ext %d\n", index);
        return;
    }

    if (func(command + 1, arg_count - 1) == 0) {
        printf("illegal function call ext %d\n", command->val.i);
    }
}

void CRunScript::load(RS_PROG_HEADER *program, RS_STACKDATA *values, int value_count, RS_CALLDATA *calls, int call_count) {
    stack = values;
    stack_num = value_count;
    call = calls;
    call_num = call_count;
    stack_end = stack + value_count;
    call_end = call + call_count;
    prog = program;
    code = (char *) program + program->code;

    if (strncmp(prog->magic, "SB2", 3) == 0) {
        version = RS_VERSION_2;
        global = stack;
        stack += prog->global_num;
        stack_num -= prog->global_num;
        memset(global, 0, prog->global_num * sizeof(RS_STACKDATA));
    }
}

void CRunScript::ext_func(int (**table)(RS_STACKDATA *, int), int count) {
    ext_func_table = table;
    ext_func_num = count;
}

void CRunScript::resume() {
    vmcode_t *point;

    point = pc;

    if (point != NULL) {
        exe(point);
    }
}

int CRunScript::run(int no) {
    RS_PROGDATA    *entry;
    int             i;
    RS_PROG_HEADER *header;
    vmcode_t       *start;

    if (prog == NULL) {
        return -1;
    }

    sp = stack;
    call_sp = call;
    func = NULL;

    if (no < 0) {
        func = (funcdata *) ((char *) prog + prog->main);
    } else {
        header = prog;
        entry = (RS_PROGDATA *) ((char *) header + header->prog);

        for (i = 0; i < header->prog_num; i++, entry++) {
            if (entry->no == no) {
                func = (funcdata *) ((char *) header + entry->func);
                break;
            }
        }
    }

    if (func == NULL) {
        printf("not found program %d\n", no);
        return -1;
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

    if (end != 0) {
        return 0;
    }

    return 1;
}

int CRunScript::check_program(int no) {
    RS_PROG_HEADER *header = prog;
    RS_PROGDATA    *entry = (RS_PROGDATA *) ((char *) header + header->prog);
    int             i;

    for (i = 0; i < header->prog_num; i++, entry++) {
        if (entry->no == no) {
            return 1;
        }
    }

    return 0;
}

void CRunScript::skip() {
    skip_wait = 1;
    resume();
}

void CRunScript::exe(vmcode_t *entry) {
    RS_STACKDATA  value;
    RS_STACKDATA  rhs;
    RS_STACKDATA  lhs;
    RS_STACKDATA *target;
    float         rhs_f;
    float         lhs_f;
    int           rhs_i;

    pc = entry;

    for (;;) {
        switch (pc->op) {
            case RS_OP_LOAD:
                switch (pc->arg2) {
                    case RS_ADDR_LOCAL:
                        push(*(frame + pc->arg1));
                        break;
                    case RS_ADDR_GLOBAL:
                        push(*(global + pc->arg1));
                        break;
                    case RS_ADDR_LOCAL_INDEX:
                        push(*(frame + pc->arg1 + chk_int(pop(), func)));
                        break;
                    case RS_ADDR_POINTER_INDEX:
                        push(*(frame[pc->arg1].val.p + chk_int(pop(), func)));
                        break;
                    case RS_ADDR_LOCAL_FLOAT:
                        (frame + pc->arg1)->type = RS_FLOAT;
                        push(*(frame + pc->arg1));
                        break;
                    case RS_ADDR_GLOBAL_FLOAT:
                        (global + pc->arg1)->type = RS_FLOAT;
                        push(*(global + pc->arg1));
                        break;
                    case RS_ADDR_LOCAL_INDEX_FLOAT:
                        rhs_i = chk_int(pop(), func);
                        (frame + pc->arg1 + rhs_i)->type = RS_FLOAT;
                        push(*(frame + pc->arg1 + rhs_i));
                        break;
                    case RS_ADDR_POINTER_INDEX_FLOAT:
                        rhs_i = chk_int(pop(), func);
                        (frame[pc->arg1].val.p + rhs_i)->type = RS_FLOAT;
                        push(*(frame[pc->arg1].val.p + rhs_i));
                        break;
                }

                break;
            case RS_OP_LOAD_ADDR:
                switch (pc->arg2) {
                    case RS_ADDR_LOCAL:
                        push_ptr(frame + pc->arg1);
                        break;
                    case RS_ADDR_GLOBAL:
                        push_ptr(global + pc->arg1);
                        break;
                    case RS_ADDR_LOCAL_INDEX:
                        push_ptr(frame + pc->arg1 + chk_int(pop(), func));
                        break;
                    case RS_ADDR_POINTER_INDEX:
                        push_ptr(frame[pc->arg1].val.p + chk_int(pop(), func));
                        break;
                    case RS_ADDR_LOCAL_FLOAT:
                        push_ptr(frame + pc->arg1);
                        break;
                    case RS_ADDR_GLOBAL_FLOAT:
                        push_ptr(global + pc->arg1);
                        break;
                    case RS_ADDR_LOCAL_INDEX_FLOAT:
                        push_ptr(frame + pc->arg1 + chk_int(pop(), func));
                        break;
                    case RS_ADDR_POINTER_INDEX_FLOAT:
                        push_ptr(frame[pc->arg1].val.p + chk_int(pop(), func));
                        break;
                }

                break;
            case RS_OP_STORE:
                value = pop();
                target = pop().val.p;
                target->type = value.type;
                target->val = value.val;
                push(value);
                break;
            case RS_OP_PUSH_CONST:
                if (pc->arg1 == RS_CONST_INT) {
                    push_int(pc->arg2);
                } else if (pc->arg1 == RS_CONST_STR) {
                    push_str(code + pc->arg2);
                } else if (pc->arg1 == RS_CONST_FLOAT) {
                    push_float(pc->arg2_float);
                }

                break;
            case RS_OP_POP:
                sp--;
                break;
            case RS_OP_JMP:
                if (!skip_wait) {
                    pc = (vmcode_t *) (code + pc->arg1);
                    continue;
                }

                break;
            case RS_OP_JMP_TRUE:
                if (!skip_wait) {
                    if (is_true(pop())) {
                        if (pc->arg2) {
                            push_int(1);
                        }

                        pc = (vmcode_t *) (code + pc->arg1);
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

                        pc = (vmcode_t *) (code + pc->arg1);
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
                        fprintf(stderr, "RUNTIME ERROR at _CMP: %s: operand is not number\n", func->name);
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
                    push_int(lhs.val.i + rhs.val.i);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.f + rhs.val.f);
                } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.i + rhs.val.f);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                    push_float(lhs.val.f + rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _ADD: %s: operand is not number\n", func->name);
                    exit(-1);
                }

                break;
            case RS_OP_SUB:
                rhs = pop();
                lhs = pop();

                if (lhs.type == RS_INT && rhs.type == RS_INT) {
                    push_int(lhs.val.i - rhs.val.i);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.f - rhs.val.f);
                } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.i - rhs.val.f);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                    push_float(lhs.val.f - rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _SUB: %s: operand is not number\n", func->name);
                    exit(-1);
                }

                break;
            case RS_OP_MUL:
                rhs = pop();
                lhs = pop();

                if (lhs.type == RS_INT && rhs.type == RS_INT) {
                    push_int(lhs.val.i * rhs.val.i);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.f * rhs.val.f);
                } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.i * rhs.val.f);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                    push_float(lhs.val.f * rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR _MUL: %s: operand is not number\n", func->name);
                    exit(-1);
                }

                break;
            case RS_OP_DIV:
                rhs = pop();

                if (rhs.val.i == 0) {
                    divby0error();
                }

                lhs = pop();

                if (lhs.type == RS_INT && rhs.type == RS_INT) {
                    push_int(lhs.val.i / rhs.val.i);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.f / rhs.val.f);
                } else if (lhs.type == RS_INT && rhs.type == RS_FLOAT) {
                    push_float(lhs.val.i / rhs.val.f);
                } else if (lhs.type == RS_FLOAT && rhs.type == RS_INT) {
                    push_float(lhs.val.f / rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _DIV: %s: operand is not number\n", func->name);
                    exit(-1);
                }

                break;
            case RS_OP_MOD:
                rhs_i = chk_int(pop(), func);

                if (rhs_i == 0) {
                    modby0error();
                }

                push_int(chk_int(pop(), func) % rhs_i);
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
                    push_int(-rhs.val.i);
                } else if (rhs.type == RS_FLOAT) {
                    push_float(-rhs.val.f);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _INVT: %s: operand is not number\n", func->name);
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
                    fprintf(stderr, "RUNTIME ERROR at _SIN: %s: operand is not number\n", func->name);
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
                    fprintf(stderr, "RUNTIME ERROR at _COS: %s: operand is not number\n", func->name);
                    exit(-1);
                }

                break;
            case RS_OP_NOT:
                rhs = pop();

                if (rhs.type == RS_INT) {
                    push_int(!rhs.val.i);
                } else {
                    fprintf(stderr, "RUNTIME ERROR: %s: \x90\xAE\x90\x94\x82\xC5\x82\xC8\x82\xA2\x83I\x83y\x83\x89\x83\x93\x83h\n", func->name);
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
                    fprintf(stderr, "RUNTIME ERROR at _ITOF: %s: operand is not number\n", func->name);
                    exit(-1);
                }

                break;
            case RS_OP_FTOI:
                rhs = pop();

                if (rhs.type == RS_INT) {
                    push_int(rhs.val.i);
                } else if (rhs.type == RS_FLOAT) {
                    push_int((int) rhs.val.f);
                } else {
                    fprintf(stderr, "RUNTIME ERROR at _FTOI: %s: operand is not number\n", func->name);
                    exit(-1);
                }

                break;
            case RS_OP_PRINT:
                sp -= pc->arg1;
                print(sp, pc->arg1);
                break;
            case RS_OP_EXT:
                sp -= pc->arg1;

                if (!skip_wait) {
                    ext(sp, pc->arg1);
                }

                break;
            case RS_OP_END:
                end = 1;
                pc = NULL;
                return;
            case RS_OP_CALL:
                pc = call_func((funcdata *) (code + pc->arg2), pc);
                pc--;
                break;
            case RS_OP_RET:
                value = pop();

                if (call_sp != call) {
                    sp = frame;
                    pc = ret_func();
                } else {
                    result = value.val.i;
                    push(value);
                    pc = NULL;
                    end = 1;
                    return;
                }

                push(value);
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
        }

        pc++;
    }
}

int rsGetStackInt(RS_STACKDATA *data) {
    if (data->type == RS_FLOAT) {
        return (int) data->val.f;
    }

    return data->val.i;
}

void rsSetStack(RS_STACKDATA *data, int value) {
    if (data->type == RS_PTR) {
        data->val.p->val.i = value;
    }
}
