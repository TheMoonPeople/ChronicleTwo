#include "common.h"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"
#include <cstring>
#include "editmap.hpp"
#include "dbg_font.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "gamepad.hpp"
#include "scene.hpp"
#include "editdebug.hpp"
#include <cstdio>

extern char at_1028__2[];
extern char at_1029__2[];

extern int EditDebugFlag;
extern int EditDebugTexb;
extern int Select;
extern int LEditFlag;

// Code (.text)
void EditDebugInit(void) {
    EditDebugFlag = 0;
    Select = 0;
    EditDebugTexb = -1;
}
int EditDebugMode(void) {
    return EditDebugFlag;
}
void EditDebugStart(int texb, mgCMemory *memory) {
    memory->stack_used = 0;
    memory->lock = 0;
    EditDebugFlag = 1;
    EditDebugTexb = texb;
}
void PrintCursor(char *buffer, int row) {
    if (row == Select) {
        sprintf(buffer, at_1028__2);
        return;
    }
    sprintf(buffer, at_1029__2);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdebug", EditDebugLoop__FP6CSceneP13EditDebugInfo);
void EditDebugEnd(void) {
    EditDebugInit();
}
void InitLightingEdit(void) {
    LEditFlag = 0;
}
void EndLightingEdit(void) {
    InitLightingEdit();
}
int IsLightingEditMode(void) {
    return LEditFlag;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdebug", LightingEdit__FP6CScene);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdebug", tagGyoFish__FP9SPI_STACKi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdebug", LoadGyorace__Fv);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", SelMax__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", SelData__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", SelText__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", SelHelp__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", LightSel__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", LightListNum__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1219__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1222__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1231__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1243__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1321__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1385__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1386__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1387__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1388__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1542__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_989__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_990__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_991__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_992__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_993__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_994__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_995__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_996__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_997__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_998__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_999__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1000__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1001__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1002__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1003__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1004__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1005__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1028__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1029__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1057__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1058__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1181__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1182__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1183__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1184__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1185__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1186__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1187__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1188__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1189__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1190__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1191__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1216__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1217__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1218__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1220__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1221__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1223__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1225__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1227__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1228__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1229__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1230__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1240__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1241__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1242__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1495__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1496__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1497__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1498__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1499__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1500__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1501__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1502__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1503__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1504__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1505__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1506__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1507__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1508__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1509__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1510__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1511__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1512__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1513__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1514__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1541__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1544__2__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", EventNo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1059__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1063__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1224__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1226__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(EditDebugFlag, 0x4);
INCLUDE_BSS(EditDebugTexb, 0x4);
INCLUDE_BSS(Select, 0x4);
INCLUDE_BSS(SelTAG, 0x4);
INCLUDE_BSS(sg_type, 0x4);
INCLUDE_BSS(map_jump, 0x4);
INCLUDE_BSS(save_no, 0x4);
INCLUDE_BSS(load_no, 0x4);
INCLUDE_BSS(condition, 0x4);
INCLUDE_BSS(map_flag_no, 0x4);
INCLUDE_BSS(LEditFlag, 0x4);
INCLUDE_BSS(LightType, 0x4);
INCLUDE_BSS(DirLightNo, 0x4);
INCLUDE_BSS(fish_num, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_1237, 0x10);
