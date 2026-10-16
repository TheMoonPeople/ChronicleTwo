#include "common.h"

#include <cstdio>
#include <string>

#include "character.hpp"
#include "dataread_port.hpp"
#include "monster.hpp"
#include "platform/model_assets.hpp"
#include "runscript.hpp"
#include "runscript_opcodes.hpp"

static int GetStackInt(RS_STACKDATA *stack) {
    if (stack->type == RS_FLOAT) {
        return (int) stack->val.f;
    }

    return stack->val.i;
}

static void SetStack(RS_STACKDATA *stack, float value) {
    if (stack->type == RS_PTR) {
        stack->val.p->val.f = value;
    }
}

// Retail sums the entry address into an int; the uptr form of that sum in ps2/src does not compile identically under MWCC.
PORT_OVERRIDE int _GET_INDEXOBJ_SIZE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int object_index = GetStackInt(stack++);

    if (object_index == -1) {
        object_index = 0;
    }

    CHARA_ENTRY_OBJECT *object = &nowMonster->entry_object[object_index];
    SetStack(stack, object->size);
    return 1;
}

PORT_OVERRIDE int _LOAD_RESERV_IMG(RS_STACKDATA *stack, int argc) {
    if (argc != 2 || !nowMonster || !stack[1].val.s) {
        return 0;
    }
    const int slot = GetStackInt(stack);
    if (slot < 0 || slot >= 2) {
        return 0;
    }
    const auto path = DataReadAssetPath(stack[1].val.s);
    if (!path) {
        return 0;
    }
    std::string error;
    if (!model_assets::ReserveMonsterTextureDocument(*nowMonster, slot, *path, error)) {
        std::fprintf(stderr, "reserved monster texture: %s\n", error.c_str());
        return 0;
    }
    return 1;
}

PORT_OVERRIDE int _TRANS_RESERV_IMG(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1 || !nowMonster) {
        return 0;
    }
    std::string error;
    return model_assets::ApplyReservedMonsterTexture(*nowMonster, GetStackInt(stack), error) ? 1 : 0;
}
