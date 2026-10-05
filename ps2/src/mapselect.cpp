#include <cstring>
extern "C" char *strncat(char *destination, const char *source, size_t count);
#include <cstdio>
#include "font.hpp"
#include "gamepad.hpp"
#include "dataread.hpp"
#include "common.h"
#include "actionchara.hpp"
#include "character.hpp"
#include "mainloop.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"
#include "mapselect.hpp"

struct EventListColors { u32 color[2]; };
struct LineBreakPair { char chars[2]; };
extern int MapNameNum;
extern MAP_NAME_INFO * map_name;
extern int pMapNameBuff;
extern int pCharBuff;
extern char * CharBuff;
extern int now_no;
extern int SelectMode;
extern int SelectMapType;
extern int select_1009;
extern int init_1010;
extern EVENT_VIEW_INFO * EventInfo;
extern int EventInfoNum;
extern int BossEventTop;
extern int sel_event;
extern int top_event;
extern int BossBattleSelFlag;
extern char MapNameBuff[0x8000];
extern char SelectMapName[];
extern char ** SelectMapList[8];
extern int SelectMapNum[8];
extern char * map_sel_type[8];
extern int select__1049[8];
extern int top__1050[8];
extern SPI_TAG_PARAM tag__7[];
extern CGamePad GamePad__2;
extern EventListColors at_1270__4;
extern LineBreakPair at_1377__2;
extern char at_1040__4[];
extern char at_1041__4[];
extern char at_1042__3[];
extern char at_1043__3[];
extern char at_1044__2[];
extern char at_1045__3[];
extern char at_1103__4[];
extern char at_1104__6[];
extern char at_1105__3[];
extern char at_1323__3[];
extern char at_1324__2[];
extern char at_1469__4[];
extern char at_1470__3[];
extern char at_1471__3[];
extern char at_842__4[];
extern char at_859__3[];
extern char at_860__2[];
int mlMAP_NAME_NUM(SPI_STACK *stack, int argc);
int mlMAP_NAME(SPI_STACK *stack, int argc);
void LoadMapName(int language, u_long128 *buffer);
static MAP_NAME_INFO *GetMapNameInfo(int map_no);
char *GetMapPath(char *path, char *name);
int GetMapType(int map_no);
int GetMapAreaNo(int map_no);
int GetMapSelType(int map_no);
int GetMapSndDataID(int map_no);
char *GetMapName(int map_no, char **title);
int SearchMapNo(char *name);
char *GetMapTitle(int map_no);
char *GetAddMapPath(int map_no);
int MapTypeSelect(void);
int MapSelect(void);
void InitSaveDataEdit(mgCMemory *stack);
int EventViewLoop(void);
extern "C" char *GetLine__FPPcPcPc__3(char **fields, char *cursor, char *end);
void AtraMiriaOnOff(int mode, CCharacter2 *chara, int enable);

// Code (.text)
int mlMAP_NAME_NUM(SPI_STACK *stack, int argc) {
    pMapNameBuff = 0;
    pCharBuff = 0;
    int count = spiGetStackInt(stack);
    MapNameNum = count;
    map_name = (MAP_NAME_INFO *)(MapNameBuff + pMapNameBuff * 16);
    pMapNameBuff += ((count + 1) * sizeof(MAP_NAME_INFO) >> 4) + 1;
    CharBuff = MapNameBuff + pMapNameBuff * 16;
    for (int i = 0; i < count + 1; i++) {
        memset(&map_name[i], 0, sizeof(MAP_NAME_INFO));
    }
    now_no = 0;
    return 1;
}
int mlMAP_NAME(SPI_STACK *stack, int argc) {
    char *args[3];
    char *copies[3];
    args[0] = spiGetStackString(stack++);
    args[1] = spiGetStackString(stack++);
    args[2] = spiGetStackString(stack++);
    int i;
    int length;
    for (i = 0; i < 3; i++) {
        if (args[i] == NULL || *(s8 *)args[i] == 0) {
            copies[i] = NULL;
        } else {
            length = strlen(args[i]);
            copies[i] = CharBuff + pCharBuff;
            strcpy(copies[i], args[i]);
            pCharBuff += length + 1;
        }
    }
    MAP_NAME_INFO *info = &map_name[now_no++];
    info->name = copies[0];
    info->title = copies[1];
    info->add_path = copies[2];
    info->type = spiGetStackInt(stack++);
    info->sel_type = spiGetStackInt(stack++);
    info->snd_data_id = -1;
    if (argc >= 6) {
        info->snd_data_id = spiGetStackInt(stack++);
    }
    if (argc >= 7) {
        info->area_no = spiGetStackInt(stack);
    }
    return 1;
}
void LoadMapName(int language, u_long128 *buffer) {
    char path[0x80];
    CScriptInterpreter interpreter;
    int size;
    MapNameNum = 0;
    sprintf(path, at_842__4, language);
    if (LoadFile2(path, buffer, &size, 0)) {
        interpreter.SetTag(tag__7);
        interpreter.SetScript((char *)buffer, size);
        interpreter.Run();
        pMapNameBuff += pCharBuff / 16 + 1;
    }
}
static MAP_NAME_INFO *GetMapNameInfo(int map_no) {

    if (map_no < 0 || map_no >= MapNameNum) {
        return NULL;
    }
    return &map_name[map_no];
}
char *GetMapPath(char *path, char *name) {
    int length = strlen(name);
    char *rest = name;
    strcpy(path, at_859__3);
    strncat(path, name, 1);
    strcat(path, at_860__2);
    if (length >= 3) {
        strncat(path, name, 3);
        rest = name + 3;
        strcat(path, at_860__2);
    }
    if (length >= 6) {
        strncat(path, rest, 3);
        strcat(path, at_860__2);
    }
    strcat(path, name);
    return path;
}
int GetMapType(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);
    if (info != NULL) {
        return info->type;
    }
    return -1;
}
int GetMapAreaNo(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);
    if (info != NULL) {
        return info->area_no;
    }
    return -1;
}
int GetMapSelType(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);
    if (info != NULL) {
        return info->sel_type;
    }
    return 0;
}
int GetMapSndDataID(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);
    if (info != NULL) {
        return info->snd_data_id;
    }
    return -1;
}
char *GetMapName(int map_no, char **title) {
    if (title != NULL) {
        *title = NULL;
    }
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);
    if (info == NULL) {
        return SelectMapName;
    }
    if (title != NULL) {
        *title = info->title;
    }
    return info->name;
}
int SearchMapNo(char *name) {
    if (name == NULL) {
        return -1;
    }
    for (int map_no = 0; map_no < MapNameNum; map_no++) {
        MAP_NAME_INFO *info = &map_name[map_no];
        if (info->name != NULL && strcmp(info->name, name) == 0) {
            return map_no;
        }
    }
    return -1;
}
char *GetMapTitle(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);
    if (info != NULL) {
        return info->title;
    }
    return NULL;
}
char *GetAddMapPath(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);
    if (info != NULL) {
        return info->add_path;
    }
    return NULL;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapselect", InitMapSelect__FP9mgCMemory);
int MapTypeSelect(void) {
    char text[0x800];
    char *cursor = text;
    if (init_1010 == 0) {
        select_1009 = 0;
        init_1010 = 1;
    }
    if (GamePad__2.Down(0x1000)) {
        select_1009--;
    }
    if (GamePad__2.Down(0x4000)) {
        select_1009++;
    }
    if (select_1009 < 0) {
        select_1009 = 7;
    }
    if (select_1009 >= 8) {
        select_1009 = 0;
    }
    if (GamePad__2.Down(0x20)) {
        if (SelectMapNum[select_1009] > 0) {
            SelectMapType = select_1009;
            SelectMode = 1;
        }
    }
    if (GamePad__2.Down(0x40)) {
        SelectMode = -1;
    }
    cursor += sprintf(cursor, at_1040__4);
    for (int i = 0; i < 8; i++) {
        if (i == select_1009) {
            cursor += sprintf(cursor, at_1041__4);
        } else {
            cursor += sprintf(cursor, at_1042__3);
        }
        cursor += sprintf(cursor, at_1043__3, map_sel_type[i]);
        if (i == select_1009) {
            cursor += sprintf(cursor, at_1044__2);
        }
        cursor += sprintf(cursor, at_1045__3);
    }
    GetDebugFont()->DrawDirect(text, 10, 10);
    return 0;
}
int MapSelect(void) {
    char text[0x800];
    char *name;
    char *cursor = text;
    int *selected;
    int count;
    int *top;
    int paged;
    int offset;
    selected = &select__1049[SelectMapType];
    top = &top__1050[SelectMapType];
    offset = *selected - *top;
    if (GamePad__2.Down(0x1000)) {
        (*selected)--;
    }
    if (GamePad__2.Down(0x4000)) {
        (*selected)++;
    }
    paged = 0;
    if (GamePad__2.Down(4)) {
        paged = 1;
        *top -= 8;
    }
    if (GamePad__2.Down(8)) {
        paged = 1;
        *top += 8;
    }
    count = SelectMapNum[SelectMapType];
    if (*selected < 0) {
        *selected = 0;
    }
    if (*selected >= count) {
        *selected = count - 1;
    }
    if (paged == 0) {
        if (*selected - *top >= 8) {
            (*top)++;
        }
        if (*selected < *top) {
            (*top)--;
        }
    }
    if (*top + 8 >= count) {
        *top = count - 8;
    }
    if (*top < 0) {
        *top = 0;
    }
    if (paged != 0) {
        *selected = *top + offset;
    }
    int selectedMapNo = SearchMapNo(SelectMapList[SelectMapType][*selected]);
    cursor += sprintf(cursor, at_1103__4, selectedMapNo);
    int end = *top + 8;
    if (count < end) {
        end = count;
    }
    for (int i = *top; i < end; i++) {
        int map_no = SearchMapNo(SelectMapList[SelectMapType][i]);
        if (i == *selected) {
            cursor += sprintf(cursor, at_1041__4);
        } else {
            cursor += sprintf(cursor, at_1042__3);
        }
        cursor += sprintf(cursor, at_1043__3, SelectMapList[SelectMapType][i]);
        if (selectedMapNo < 0) {
            cursor += sprintf(cursor, at_1104__6);
        } else {
            cursor += sprintf(cursor, at_1105__3);
        }
        name = NULL;
        GetMapName(map_no, &name);
        if (name != NULL) {
            cursor += sprintf(cursor, at_1043__3, name);
        }
        if (i == *selected) {
            cursor += sprintf(cursor, at_1044__2);
        }
        cursor += sprintf(cursor, at_1045__3);
    }
    GetDebugFont()->DrawDirect(text, 10, 10);
    if (GamePad__2.Down(0x40)) {
        SelectMode = 0;
    }
    if (GamePad__2.Down(0x20)) {
        strcpy(SelectMapName, SelectMapList[SelectMapType][*selected]);
        SelectMode = 2;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapselect", MapSelectLoop__Fv);
void InitSaveDataEdit(mgCMemory *stack) {
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapselect", SaveDataEditLoop__Fv);
int EventViewLoop(void) {
    char text[0x400];
    EventListColors colors;
    INIT_LOOP_ARG loopArg;
    char *cursor = text;
    cursor += sprintf(cursor, at_1323__3);
    if (BossBattleSelFlag != 0) {
        if (top_event < BossEventTop) {
            top_event = BossEventTop;
        }
        BossBattleSelFlag = 0;
    }
    int index = top_event;
    int last = index + 10;
    colors = at_1270__4;
    if (last >= EventInfoNum) {
        last = EventInfoNum;
    }
    for (; index < last; index++) {
        EVENT_VIEW_INFO *info = &EventInfo[index];
        if (info->name != NULL) {
            cursor += sprintf(cursor, at_1324__2, colors.color[index == top_event + sel_event],
                              info->name, info->detail);
        }
    }
    GetDebugFont()->DrawDirect(text, 10, 10);
    if (GamePad__2.Down(0x1000)) {
        sel_event--;
    }
    if (GamePad__2.Down(0x4000)) {
        sel_event++;
    }
    if (GamePad__2.Down(0x8004)) {
        top_event -= 10;
    }
    if (GamePad__2.Down(0x2008)) {
        top_event += 10;
    }
    if (top_event < 0) {
        top_event = 0;
    }
    if (top_event >= EventInfoNum - 1) {
        top_event -= 10;
    }
    if (sel_event < 0) {
        sel_event = 9;
        if (top_event + 9 >= EventInfoNum) {
            sel_event = EventInfoNum - top_event - 1;
        }
    }
    if (sel_event >= 10 || top_event + sel_event >= EventInfoNum) {
        sel_event = 0;
    }
    if (GamePad__2.Down(0x20)) {
        memset(&loopArg, 0, sizeof(loopArg));
        EVENT_VIEW_INFO *chosen = &EventInfo[top_event + sel_event];
        if (chosen->map_no >= 0) {
            loopArg.map_no = chosen->map_no;
            loopArg.floor_no = chosen->floor_no;
            loopArg.event_no = chosen->event_no;
            if (chosen->dungeon != 0) {
                NextLoop(2, loopArg);
            } else {
                NextLoop(1, loopArg);
            }
            return 1;
        }
    }
    if (GamePad__2.Down(0x40)) {
        return 2;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mapselect", LoadEventViewData__FP1P9mgCMemory);
extern "C" char *GetLine__FPPcPcPc__3(char **fields, char *cursor, char *end) {
    LineBreakPair lineBreakPair;
    int field;
    int length;
    lineBreakPair = at_1377__2;
    if (cursor < end) {
        field = 0;
        do {
            if (memcmp(cursor, lineBreakPair.chars, 2) == 0) {
                cursor += 2;
                break;
            }
            if (memcmp(cursor, lineBreakPair.chars, 1) == 0) {
                cursor += 1;
                break;
            }
            if (memcmp(cursor, lineBreakPair.chars + 1, 1) == 0) {
                cursor += 1;
                break;
            }
            length = 0;
            while (cursor < end) {
                if (memcmp(cursor, lineBreakPair.chars, 2) == 0 ||
                    memcmp(cursor, lineBreakPair.chars, 1) == 0 ||
                    memcmp(cursor, lineBreakPair.chars + 1, 1) == 0) {
                    break;
                }
                s8 ch = *cursor;
                if (ch == '\t') {
                    char *next = fields[field + 1];
                    cursor++;
                    if (next != NULL) {
                        *next = 0;
                    }
                    break;
                }
                if (ch != ' ' && fields[field] != NULL) {
                    fields[field][length] = ch;
                    length++;
                }
                cursor++;
            }
            char *current = fields[field];
            if (current != NULL) {
                field++;
                current[length] = 0;
            }
        } while (cursor < end);
    }
    return cursor;
}
void AtraMiriaOnOff(int mode, CCharacter2 *chara, int enable) {
    mgCFrame *left;
    mgCFrame *right;
    mgCFrame *frame;
    if (chara == NULL) {
        return;
    }
    frame = chara->CObjectFrame::frame;
    if (frame == NULL) {
        return;
    }
    if (mode == 0) {
        left = frame->SearchFrame(at_1469__4);
        right = frame->SearchFrame(at_1470__3);
        if (enable) {
            if (left != NULL) {
                left->attr->draw = 5;
            }
            if (right != NULL) {
                right->attr->draw = 1;
            }
        } else {
            if (left != NULL) {
                left->attr->draw = 2;
            }
            if (right != NULL) {
                right->attr->draw = 2;
            }
        }
    }
    if (mode == 1) {
        left = frame->SearchFrame(at_1469__4);
        if (enable) {
            if (left != NULL) {
                left->attr->draw = 1;
            }
        } else {
            if (left != NULL) {
                left->attr->draw = 2;
            }
        }
    }
    if (mode == 2) {
        right = frame->SearchFrame(at_1471__3);
        if (enable) {
            if (right != NULL) {
                right->attr->draw = 5;
            }
        } else {
            if (right != NULL) {
                right->attr->draw = 2;
            }
        }
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", map_sel_type__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", SelectMapName__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", tag__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", select__1049__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", top__1050__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", SedSelData__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_792__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_793__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_794__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_795__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_796__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_797__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_798__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_799__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_800__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_801__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_842__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_859__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_860__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1004__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1005__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1040__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1041__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1042__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1043__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1044__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1045__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1103__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1104__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1105__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1117__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1126__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1127__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1222__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1223__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1224__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1225__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1226__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1227__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1228__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1323__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1324__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1372__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1373__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1469__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1470__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1471__3__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", config_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1125__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1128__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1270__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mapselect", at_1377__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MapNameNum, 0x4);
INCLUDE_BSS(map_name, 0x4);
INCLUDE_BSS(pMapNameBuff, 0x4);
INCLUDE_BSS(pCharBuff, 0x4);
INCLUDE_BSS(CharBuff, 0x4);
INCLUDE_BSS(now_no, 0x4);
INCLUDE_BSS(MenuStack, 0x4);
INCLUDE_BSS(SelectMode, 0x4);
INCLUDE_BSS(SelectMapType, 0x4);
INCLUDE_BSS(select_1009, 0x4);
INCLUDE_BSS(init_1010, 0x4);
INCLUDE_BSS(SedSel, 0x4);
INCLUDE_BSS(EventInfo, 0x4);
INCLUDE_BSS(EventInfoNum, 0x4);
INCLUDE_BSS(BossEventTop, 0x4);
INCLUDE_BSS(sel_event, 0x4);
INCLUDE_BSS(top_event, 0x4);
INCLUDE_BSS(BossBattleSelFlag, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(MapNameBuff, 0x8000);
INCLUDE_BSS(SelectMapList, 0x20);
INCLUDE_BSS(SelectMapNum, 0x20);
