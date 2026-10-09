#include "common.h"

#include <cstdio>
#include <cstring>

#include "mg_memory.hpp"

// Code (.text)
void *MG_ADDRESS_CHECK(void *address, char *where) {
    if (address == NULL) {
        printf("stack over at %s\n", where);
        return NULL;
    }

    return address;
}

void *operator new(size_t size, u_long128 *buffer) {
    return buffer;
}

void *operator new[](size_t size, u_long128 *buffer) {
    return buffer;
}

void mgCMemory::Init() {
    heap_size = 0;
    heap = NULL;
    heap_top = NULL;
    name[0] = '\0';
    stack = NULL;
    stack_used = 0;
    stack_size = 0;
    lock = 0;
}

void mgCMemory::SetHeapMem(u_long128 *buffer, int size) {
    heap = buffer;
    heap_size = size;

    if (buffer == 0 || heap_size < 0x10) {
        Init();
        return;
    }

    // The first header owns no contents; the last quadword of the buffer
    // is the terminating header.
    heap_top = (mgMEMORY_BLOCK *) buffer;
    heap_top->data = 0;
    heap_top->size = 1;
    heap_top->next = (mgMEMORY_BLOCK *) (heap_size + heap) - 1;
    heap_top->next->data = 0;
    heap_top->next->size = 0;
    heap_top->next->next = 0;
}

void mgCMemory::ClearHeapMem() {
    u_long128 *buffer = heap;
    u_int      size = heap_size;

    Init();
    SetHeapMem(buffer, size);
}

void mgCMemory::Free(u_long128 *data) {
    mgMEMORY_BLOCK *block;
    mgMEMORY_BLOCK *prev;
    mgMEMORY_BLOCK *found;

    if (data == NULL) {
        return;
    }

    prev = NULL;
    found = NULL;

    for (block = heap_top; block->next != NULL; block = block->next) {
        if (block->data == data) {
            found = block;
            break;
        }

        prev = block;
    }

    if (found == NULL) {
        printf("Illegal Free Memory %x\n", data);

        while (true) {
        }
    }

    prev->next = found->next;
}

u_long128 *mgCMemory::StartStackMode(int mode, int size) {
    stack_block = 0;
    mgMEMORY_BLOCK *block = heap_top;

    if (block == 0) {
        return 0;
    }

    mgMEMORY_BLOCK *chosen = 0;
    mgMEMORY_BLOCK *chosen_previous = 0;
    int             spare = 0;
    u_int           best_count = 0;
    mgMEMORY_BLOCK *gap;
    u_int           count;
    mgMEMORY_BLOCK *next;

    for (; (next = block->next) != 0; block = next) {
        gap = block + block->size;
        // Taken from the last gap examined, not necessarily the chosen one.
        count = next - gap;
        spare = count - 1;

        if (mode == 1 && count > 1) {
            chosen = gap;
            chosen_previous = block;
            break;
        }

        if (mode == 2 && best_count < count) {
            chosen = gap;
            chosen_previous = block;
            best_count = count;
        }

        if (mode == 3 && (u_int) (size + 1) < count) {
            chosen = gap;
            chosen_previous = block;
            break;
        }
    }

    if (chosen != 0) {
        stack_block = chosen;
        stack_block->next = chosen_previous->next;
        chosen_previous->next = stack_block;
        stack_block->size = 1;
        stack_block->data = (u_long128 *) (stack_block + 1);
        stack = stack_block->data;
        stack_size = spare;
        return stack_block->data;
    }

    return 0;
}

void mgCMemory::EndStackMode() {
    mgMEMORY_BLOCK *block = stack_block;

    if (block != 0) {
        u_int count = stack_used;
        block->size += count;
        stack_block = 0;
        stack = 0;
        stack_size = 0;
        stack_used = 0;
    }
}

u_long128 *mgCMemory::stAlloc64(int size) {
    stAlign64();
    return stAlloc(size);
}

u_long128 *mgCMemory::stAllocTest(int size) {
    if (lock) {
        return NULL;
    }

    if (stack_used + size >= stack_size) {
        printf("stack over %d/%d at %s\n", stack_used + size, stack_size, name);
        return NULL;
    }

    return &stack[stack_used];
}

u_long128 *mgCMemory::stAlloc(int size) {
    if (lock != 0) {
        return 0;
    }

    if (size <= 0) {
        return 0;
    }

    int old_used = stack_used;
    int old_capacity = stack_size;
    int new_used = old_used + size;

    if (new_used >= old_capacity) {
        printf("stack over %d/%d at %s\n", new_used, old_capacity, this);
        return 0;
    }

    u_long128 *data = &stack[old_used];
    stack_used = new_used;
    return data;
}

u_long128 *mgCMemory::Alloc(int size) {
    if (lock != 0) {
        return 0;
    }

    if (size <= 0) {
        return 0;
    }

    int old_used = stack_used;
    int old_capacity = stack_size;
    int new_used = old_used + size;

    if (new_used >= old_capacity) {
        printf("stack over %d/%d at %s\n", new_used, old_capacity, this);
        return 0;
    }

    u_long128 *data = &stack[old_used];
    stack_used = new_used;
    return data;
}

void mgCMemory::stAlign64() {
    u_int misalign;

    if (lock) {
        return;
    }

    misalign = (u_int) &stack[stack_used] & 0x3F;

    if (misalign != 0) {
        stack_used += (int) (64 - misalign) / 16;
    }

    if (stack_used >= stack_size) {
        stack_used = stack_size;
    }
}

void mgCMemory::Align64() {
    u_int misalign;

    if (lock) {
        return;
    }

    misalign = (u_int) &stack[stack_used] & 0x3F;

    if (misalign != 0) {
        stack_used += (int) (64 - misalign) / 16;
    }

    if (stack_used >= stack_size) {
        stack_used = stack_size;
    }
}

void mgCMemory::stSetBuffer(u_long128 *buffer, int size) {
    stack = buffer;
    stack_used = 0;
    stack_size = size;
}

char *mgCopyString(char *source, mgCMemory *memory) {
    if (source == NULL || memory == NULL) {
        return NULL;
    }

    u_int size = strlen(source) + 1;
    u_int quadwords = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
    char *copy = (char *) memory->Alloc(quadwords);

    if (copy == NULL) {
        return NULL;
    }

    strcpy(copy, source);
    return copy;
}
