#include "common.h"
#include "runscript.hpp"

#include <cstdio>
#include <cstdlib>
#include <cstring>

extern char at_168[];
extern char at_173[];
extern char at_183__2[];
extern char at_197[];
extern char at_202[];
extern char at_223[];
extern char at_224[];
extern char at_225[];
extern char at_275[];
extern char at_292__3[];
extern char at_293__2[];
extern char at_300__3[];
extern char at_341__2[];
extern char at_686[];
extern char at_687[];
extern char at_688[];
extern char at_689[];
extern char at_690[];
extern char at_691[];
extern char at_692[];
extern char at_693[];
extern char at_694[];
extern char at_695[];
extern char at_696[];
extern char at_699[];
extern char at_698[];
extern char at_697[];

// Code (.text)
void runerror(const char *message) {
    fprintf(stderr, at_168, message);
    exit(-1);
}
void stkoverflow(void) {
    runerror(at_173);
}
int chk_int(RS_STACKDATA data, funcdata *func) {
    if (data.type == RS_INT) {
        return data.i;
    }
    fprintf(stderr, at_183__2, func->name);
    exit(-1);
    return 0;
}
u8 is_true(RS_STACKDATA data) {
    int is_zero = data.type == RS_INT;
    if (is_zero) {
        is_zero = data.i == 0;
    }
    return is_zero ^ 1;
}
void divby0error(void) {
    runerror(at_197);
}
void modby0error(void) {
    runerror(at_202);
}
void print(RS_STACKDATA *slots, int count) {
    int i = 0;
    if (0 < count) {
        do {
            if (slots->type == RS_INT) {
                printf(at_223, slots->i);
            } else if (slots->type == RS_STR) {
                printf(at_224, slots->i);
            } else if (slots->type == RS_FLOAT) {
                printf(at_225, slots->f);
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
void CRunScript::DeleteProgram(void) {
    end = 0;
    skip_wait = 0;
    prog = NULL;
}
void CRunScript::check_stack(void) {
    if (sp >= stack_end) {
        stkoverflow();
    }
}
void CRunScript::push(RS_STACKDATA data) {
    check_stack();
    RS_STACKDATA *slot = sp;
    sp++;
    slot->type = data.type;
    *(float *)&slot->i = *(float *)&data.i;
}
void CRunScript::push_int(int value) {
    check_stack();
    sp->type = RS_INT;
    RS_STACKDATA *slot = sp;
    sp++;
    slot->i = value;
}
void CRunScript::push_str(char *value) {
    check_stack();
    sp->type = RS_STR;
    RS_STACKDATA *slot = sp;
    sp++;
    slot->s = value;
}
void CRunScript::push_ptr(RS_STACKDATA *value) {
    check_stack();
    sp->type = RS_PTR;
    RS_STACKDATA *slot = sp;
    sp++;
    slot->p = value;
}
void CRunScript::push_float(float value) {
    check_stack();
    sp->type = RS_FLOAT;
    RS_STACKDATA *slot = sp;
    sp++;
    slot->f = value;
}
RS_STACKDATA CRunScript::pop() {
    RS_STACKDATA *top = sp;
    top--;
    sp = top;
    return *top;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript", call_func__10CRunScriptFP8funcdataP8vmcode_t);
vmcode_t *CRunScript::ret_func() {
    call_sp--;
    frame = call_sp->frame;
    func = call_sp->func;
    return call_sp->ret;
}
void CRunScript::ext(RS_STACKDATA *command, int arg_count) {
    int index = command->i;
    int (*func)(RS_STACKDATA *, int);

    if (index < 0 || index >= ext_func_num) {
        printf(at_292__3, index);
        return;
    }
    func = ext_func_table[index];
    if (func == 0) {
        printf(at_292__3, index);
        return;
    }
    if (func(command + 1, arg_count - 1) == 0) {
        printf(at_293__2, command->i);
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
    code = (char *)program + program->code;
    if (strncmp((char *)prog, at_300__3, 3) == 0) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript", run__10CRunScriptFi);
extern "C" int check_program__10CRunScriptFi(CRunScript *self, int no) {
    int count;
    int offset;
    int i = 0;
    self = (CRunScript *)self->prog;
    offset = ((RS_PROG_HEADER *)self)->prog;
    int *entry = (int *)((u8 *)self + offset);
    count = ((RS_PROG_HEADER *)self)->prog_num;
    goto test;
next:
    if (*entry == no) {
        return 1;
    }
    i++;
    entry += 2;
test:
    if (i < count) {
        goto next;
    }
    return 0;
}
void CRunScript::skip(void) {
    skip_wait = 1;
    resume();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript", exe__10CRunScriptFP8vmcode_t);
int rsGetStackInt(RS_STACKDATA *data) {
    if (data->type == RS_FLOAT) {
        return (int)data->f;
    }
    return data->i;
}
void rsSetStack(RS_STACKDATA *data, int value) {
    if (data->type == RS_PTR) {
        data->p->i = value;
    }
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_168__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_173__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_183__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_197__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_202__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_223__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_224__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_225__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_275__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_292__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_293__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_300__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_341__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_686__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_687__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_688__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_689__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_690__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_691__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_692__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_693__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_694__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_695__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_696__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_699__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_698__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript", at_697__DATA);
