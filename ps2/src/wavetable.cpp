#include "common.h"
#include "wavetable.hpp"
#include <cstdlib>

extern int cnt_302;
extern signed char init_303;

// Code (.text)
CWaveTable::CWaveTable() {
    int i;
    int j;
    for (i = 0; i < 24; i++) {
        for (j = 0; j < 24; j++) {
            height[1][i][j] = 0;
            height[0][i][j] = 0;
        }
    }
    current = 0;
}
CWaveTable::~CWaveTable() {
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/wavetable", CreateTexture__10CWaveTableFP10mgCTexture);
void CWaveTable::GetEffect() {
    int drop;
    int column;
    int row;
    if (init_303 == 0) {
        cnt_302 = 0;
        init_303 = 1;
    }
    drop = 0;
    if (cnt_302 == 0) {
        do {
            column = rand() % 22 + 1;
            row = rand() % 22 + 1;
            height[current][row][column] += 0.04f * ((float)rand() / 2147483648.0f - 0.5f);
            drop++;
        } while (drop < 4);
    }
    cnt_302 += 1;
    if (cnt_302 > 4) {
        cnt_302 = 0;
    }
    Effect();
    current = 1 - current;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/wavetable", Effect__10CWaveTableFv);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/wavetable", at_251__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/wavetable", at_256__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/wavetable", __vt__10CWaveTable__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(cnt_302, 0x4);
INCLUDE_BSS(init_303, 0x4);
