#pragma once

#include "common.h"

/**
 * @file
 * Declares the engine's quadword memory manager: a block heap carved from a
 * caller-supplied buffer, plus a stack region that hands out memory linearly.
 */

class mgCMemory;

/**
 *
 * Ways StartStackMode picks the free gap in the heap that becomes the
 * stack region.
 *
 */
enum mgSTACK_MODE {
    MG_STACK_MODE_FIRST = 1,   /**< First gap with room for at least one quadword after the header. */
    MG_STACK_MODE_LARGEST = 2, /**< Largest gap in the heap. */
    MG_STACK_MODE_FIT = 3,     /**< First gap with room for more than the requested quadwords. */
};

/**
 *
 * Header that precedes every block in an mgCMemory heap, linking the
 * blocks in address order.
 *
 */
struct mgMEMORY_BLOCK {
    u_long128      *data; /**< Start of the block's contents, directly after this header. */
    int             size; /**< Quadwords the block occupies, header included. */
    int             unk_8;
    mgMEMORY_BLOCK *next; /**< Following block, or NULL for the terminating header. */
};

STATIC_ASSERT(sizeof(mgMEMORY_BLOCK) == 0x10);

/**
 *
 * Quadword memory manager over one buffer, either as a block heap or as a
 * linear stack region allocated from the start of a buffer.
 *
 */
class mgCMemory {
public:
    char            name[0x10]; /**< Name shown in overflow messages. */
    u_int           heap_size;  /**< Heap buffer size, in quadwords. */
    u_long128      *heap;       /**< Heap buffer. */
    mgMEMORY_BLOCK *heap_top;   /**< First block header of the heap, at the start of the heap buffer. */
    int             lock;       /**< Non-zero refuses every stack allocation and alignment. */

    union {
        u_long128 *stack;
        u8        *stack_bytes;
    }; /**< Stack region allocations are taken from. */

    int             stack_used;  /**< Quadwords of the stack region in use. */
    int             stack_size;  /**< Quadwords available in the stack region. */
    mgMEMORY_BLOCK *stack_block; /**< Heap block holding the stack region while stack mode is active. */

    /**
     *
     * Creates a manager with no buffers attached.
     *
     * @mangled __ct__9mgCMemoryFv
     * @address 0x1466A0
     * @size 0x30
     */
    mgCMemory() { Init(); }

    int stGetUsed() {
        return stack_used;
    }

    int stGetSize() {
        return stack_size;
    }

    int stGetRest() {
        return stack_size - stack_used;
    }

    u_long128 *stGetTop() {
        return &stack[stack_used];
    }

    void stReset() {
        stack_used = 0;
        lock = 0;
    }

    /**
     *
     * Detaches the heap and stack buffers and clears the name, leaving
     * nothing to allocate from.
     *
     * @mangled Init__9mgCMemoryFv
     * @address 0x139F70
     * @size 0x30
     */
    void Init();

    /**
     *
     * Makes a buffer the heap, as one free gap ending in a terminating header;
     * a NULL buffer or one under sixteen quadwords resets the manager instead.
     *
     * @mangled SetHeapMem__9mgCMemoryFP1i
     * @address 0x139FA0
     * @size 0xA0
     */
    void SetHeapMem(u_long128 *buffer, int size);

    /**
     *
     * Discards everything in the heap and the stack region, keeping the
     * current heap buffer as an empty heap.
     *
     * @mangled ClearHeapMem__9mgCMemoryFv
     * @address 0x13A040
     * @size 0x50
     */
    void ClearHeapMem();

    /**
     *
     * Unlinks the heap block whose contents start at the given address,
     * halting with a message when no block matches.
     *
     * @mangled Free__9mgCMemoryFP1
     * @address 0x13A090
     * @size 0x80
     */
    void Free(u_long128 *data);

    /**
     *
     * Claims a free gap in the heap as a new block and makes its space the
     * stack region; gives the region's start, or NULL when no gap qualifies.
     *
     * @mangled StartStackMode__9mgCMemoryFii
     * @address 0x13A110
     * @size 0x130
     */
    u_long128 *StartStackMode(int mode, int size);

    /**
     *
     * Grows the stack-mode block to cover what the stack region used and
     * detaches the stack region.
     *
     * @mangled EndStackMode__9mgCMemoryFv
     * @address 0x13A240
     * @size 0x40
     */
    void EndStackMode();

    /**
     *
     * Allocates quadwords from the stack region starting on a 64-byte
     * boundary.
     *
     * @mangled stAlloc64__9mgCMemoryFi
     * @address 0x13A280
     * @size 0x40
     */
    u_long128 *stAlloc64(int size);

    /**
     *
     * Gives the address the next stack allocation of the given size would
     * return, without claiming it, or NULL when it would not fit.
     *
     * @mangled stAllocTest__9mgCMemoryFi
     * @address 0x13A2C0
     * @size 0x60
     */
    u_long128 *stAllocTest(int size);

    /**
     *
     * Allocates quadwords from the stack region, or gives NULL when the
     * manager is locked, the size is not positive or the region is full.
     *
     * @mangled stAlloc__9mgCMemoryFi
     * @address 0x13A320
     * @size 0x70
     */
    u_long128 *stAlloc(int size);

    /**
     *
     * Allocates quadwords from the stack region, or gives NULL when the
     * manager is locked, the size is not positive or the region is full.
     *
     * @mangled Alloc__9mgCMemoryFi
     * @address 0x13A390
     * @size 0x70
     */
    u_long128 *Alloc(int size);

    /**
     *
     * Advances the stack region's next allocation to a 64-byte boundary,
     * clamped to the region's end.
     *
     * @mangled stAlign64__9mgCMemoryFv
     * @address 0x13A400
     * @size 0x70
     */
    void stAlign64();

    /**
     *
     * Advances the stack region's next allocation to a 64-byte boundary,
     * clamped to the region's end.
     *
     * @mangled Align64__9mgCMemoryFv
     * @address 0x13A470
     * @size 0x70
     */
    void Align64();

    /**
     *
     * Makes a buffer the stack region, empty and holding the given
     * number of quadwords.
     *
     * @mangled stSetBuffer__9mgCMemoryFP1i
     * @address 0x13A4E0
     * @size 0x10
     */
    void stSetBuffer(u_long128 *buffer, int size);

    /**
     *
     * Returns the stack region as bytes.
     *
     */
    u8 *stGetBuffer() {
        return stack_bytes;
    }
};

STATIC_ASSERT(sizeof(mgCMemory) == 0x30);

/**
 *
 * Gives an address back unchanged, printing a stack overflow message
 * naming the caller's context when it is NULL.
 *
 * @mangled MG_ADDRESS_CHECK__FPvPc
 * @address 0x139F20
 * @size 0x30
 */
void *MG_ADDRESS_CHECK(void *address, char *where);

/**
 *
 * Constructs an object in memory taken from an mgCMemory.
 *
 * @mangled __nw__FUiP1
 * @address 0x139F50
 * @size 0x10
 */
void *operator new(size_t size, u_long128 *buffer);

/**
 *
 * Constructs an array in memory taken from an mgCMemory.
 *
 * @mangled __nwa__FUiP1
 * @address 0x139F60
 * @size 0x10
 */
void *operator new[](size_t size, u_long128 *buffer);

/**
 *
 * Copies a string into stack memory of a manager, giving the copy, or
 * NULL when either argument is NULL or the memory is full.
 *
 * @mangled mgCopyString__FPcP9mgCMemory
 * @address 0x13A4F0
 * @size 0x90
 */
char *mgCopyString(char *source, mgCMemory *memory);
