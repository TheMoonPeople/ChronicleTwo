#include "common.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "editdata.hpp"
#include "font.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "vlgr_info.hpp"

/**
 *
 * Pair of characters used for a line break.
 *
 */
struct LineBreakPair {
    char chars[2]; /**< Line break characters. */
};

/**
 *
 * Pair of labels used to mark selections or name boolean values.
 *
 */
struct SaveEditLabels {
    const char *text[2]; /**< Selection markers or boolean labels. */
};

/**
 *
 * Counts the map name records loaded for the current language.
 *
 */
static int MapNameNum;
/**
 *
 * Points to map records in the map name storage arena.
 *
 */
static MAP_NAME_INFO *map_name;
/**
 *
 * Tracks the next free quadword in the map name storage arena.
 *
 */
static int pMapNameBuff;
/**
 *
 * Tracks the next free byte in the map name string buffer.
 *
 */
static int pCharBuff;
/**
 *
 * Points to the map name string buffer following its records.
 *
 */
static char *CharBuff;
/**
 *
 * Selects the map record filled by the next script command.
 *
 */
static int now_no;
/**
 *
 * Selects the save data editor item.
 *
 */
static int SedSel;
/**
 *
 * Stores editable debug save-data values.
 *
 */
static int SedSelData[SED_ITEM_NUM] = {0};
/**
 *
 * Names the configuration value shown by the save data editor.
 *
 */
static char *config_str[1] = {"Caption off"};
/**
 *
 * Points to the memory stack used by the map selection menu.
 *
 */
static mgCMemory *MenuStack;
/**
 *
 * Selects the current map selection screen.
 *
 */
static int SelectMode;
/**
 *
 * Selects the map category shown by the map list.
 *
 */
static int SelectMapType;
/**
 *
 * Counts the loaded event viewer records.
 *
 */
static int EventInfoNum;
/**
 *
 * Marks the first boss entry in the event viewer list.
 *
 */
static int BossEventTop;
/**
 *
 * Selects the visible event viewer row.
 *
 */
static int sel_event;
/**
 *
 * Selects the first event viewer row on screen.
 *
 */
static int top_event;
/**
 *
 * Stores map records and their variable-length strings in one arena.
 *
 */
static char MapNameBuff[MAP_NAME_BUFF_SIZE * 16];
/**
 *
 * Stores the map name selected for the next edit loop.
 *
 */
static char SelectMapName[0x100] = "";
/**
 *
 * Points to the map name lists for each selection category.
 *
 */
static char **SelectMapList[MAP_SEL_TYPE_NUM];
/**
 *
 * Counts the map names in each selection category.
 *
 */
static int SelectMapNum[MAP_SEL_TYPE_NUM];
/**
 *
 * Stores the selected map row for each map category.
 *
 */
static int select__1049[16] = {0};
/**
 *
 * Stores the first visible map row for each map category.
 *
 */
static int            top__1050[16] = {0};
int                   mlMAP_NAME_NUM(SPI_STACK *stack, int argc);
int                   mlMAP_NAME(SPI_STACK *stack, int argc);
static MAP_NAME_INFO *GetMapNameInfo(int map_no);
int                   MapTypeSelect();
int                   MapSelect();
static char          *GetLine(char **columns, char *position, char *end);

/**
 *
 * Names the map categories shown by the map selection menu.
 *
 */
static char *map_sel_type[MAP_SEL_TYPE_NUM] = {
    "New", "Georama", "PalmBlinks", "Submap", "Future", "Dungeon", "Event", "Special"};

/**
 *
 * Points to the loaded event viewer records.
 *
 */
EVENT_VIEW_INFO *EventInfo;
/**
 *
 * Selects the boss event list when opening the event viewer.
 *
 */
int BossBattleSelFlag;

// Code (.text)
/**
 *
 * Reserves map name records and string storage from the scripted record count.
 *
 */
int mlMAP_NAME_NUM(SPI_STACK *stack, int argc) {
    pMapNameBuff = 0;
    pCharBuff = 0;
    int count = spiGetStackInt(stack);
    MapNameNum = count;
    map_name = (MAP_NAME_INFO *) (MapNameBuff + pMapNameBuff * 16);
    pMapNameBuff += ((count + 1) * sizeof(MAP_NAME_INFO) >> 4) + 1;
    CharBuff = MapNameBuff + pMapNameBuff * 16;

    for (int i = 0; i < count + 1; i++) {
        memset(&map_name[i], 0, sizeof(MAP_NAME_INFO));
    }

    now_no = 0;
    return 1;
}

/**
 *
 * Stores one scripted map's names, type, and optional sound and area identifiers.
 *
 */
int mlMAP_NAME(SPI_STACK *stack, int argc) {
    char *args[3];
    char *copies[3];
    args[0] = spiGetStackString(stack++);
    args[1] = spiGetStackString(stack++);
    args[2] = spiGetStackString(stack++);
    int i;
    int length;

    for (i = 0; i < 3; i++) {
        if (args[i] == NULL || args[i][0] == 0) {
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

/**
 *
 * Dispatches the map name script commands.
 *
 */
static SPI_TAG_PARAM tag[3] = {
    {"MAP_NAME_NUM", mlMAP_NAME_NUM},
    {"MAP_NAME",     mlMAP_NAME    },
    {NULL,           NULL          }
};

void LoadMapName(int language, u_long128 *buffer) {
    char path[0x80];
    int  size;
    MapNameNum = 0;
    sprintf(path, "map/map%d.cfg", language);

    if (LoadFile2(path, buffer, &size, 0)) {
        CScriptInterpreter interpreter;
        interpreter.SetTag(tag);
        interpreter.SetScript((char *) buffer, size);
        interpreter.Run();
        pMapNameBuff += pCharBuff / 16 + 1;
    }
}

/**
 *
 * Finds a loaded map name record by its map number.
 *
 */
static MAP_NAME_INFO *GetMapNameInfo(int map_no) {

    if (map_no < 0 || map_no >= MapNameNum) {
        return NULL;
    }

    return &map_name[map_no];
}

void GetMapPath(char *path, char *name) {
    int   length = strlen(name);
    char *rest = name;
    strcpy(path, "map/");
    strncat(path, name, 1);
    strcat(path, "/");

    if (length >= 3) {
        strncat(path, name, 3);
        rest = name + 3;
        strcat(path, "/");
    }

    if (length >= 6) {
        strncat(path, rest, 3);
        strcat(path, "/");
    }

    strcat(path, name);
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
    struct {
        int   no;
        char *name;
    } search;

    search.name = name;

    if (search.name == NULL) {
        return -1;
    }

    search.no = 0;

    for (; search.no < MapNameNum; search.no++) {
        MAP_NAME_INFO *info = &map_name[search.no];

        if (info->name != NULL && strcmp(info->name, search.name) == 0) {
            return search.no;
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

void InitMapSelect(mgCMemory *stack) {
    MenuStack = stack;
    SetCurrentDir(NULL);
    int list_size;
    LoadFile("map/map.lst", read_buffer, &list_size);
    input_str lines;
    lines.buffer = (char *) read_buffer;
    lines.size = list_size;

    for (int type = 0; type < MAP_SEL_TYPE_NUM; ++type) {
        SelectMapNum[type] = 0;
        SelectMapList[type] = new (MenuStack->Alloc(0x22)) char *[SELECT_MAP_MAX];

        for (int index = 0; index < SELECT_MAP_MAX; ++index) {
            SelectMapList[type][index] = NULL;
        }
    }

    SelectMode = MAP_SELECT_MODE_TYPE;
    char line[0x100];

    if (!lines.GetLine(line, sizeof(line), NULL)) {
        return;
    }

    int path_length = strlen(line) + 1;

    if (lines.GetLine(line, sizeof(line), NULL)) {
        do {
            if (line[0] != 0) {
                char *letter = line;

                for (; *letter != 0; letter++) {
                    char c = *letter;

                    if (c == 0) {
                        break;
                    }

                    if (c == '\\') {
                        *letter = '/';
                    }

                    if (strncmp(letter, "cmn", 3) == 0) {
                        letter = NULL;
                        break;
                    }
                }

                if (letter != NULL) {
                    char directory[0x80], name[0x80], extension[0x80];
                    DivPathNameExt(line + path_length, directory, name, extension);
                    int type = GetMapSelType(SearchMapNo(name));
                    SelectMapList[type][SelectMapNum[type]++] = mgCopyString(name, MenuStack);
                }
            }
        } while (lines.GetLine(line, sizeof(line), NULL));
    }
}

/**
 *
 * Handles and draws the map category selection screen.
 *
 */
int MapTypeSelect() {
    char  text[0x800];
    char *cursor = text;

    static int select = 0;

    if (GamePad__2.Down(PAD_UP)) {
        select--;
    }

    if (GamePad__2.Down(PAD_DOWN)) {
        select++;
    }

    if (select < 0) {
        select = 7;
    }

    if (select >= 8) {
        select = 0;
    }

    if (GamePad__2.Down(PAD_CIRCLE)) {
        if (SelectMapNum[select] > 0) {
            SelectMapType = select;
            SelectMode = (int) MAP_SELECT_MODE_MAP;
        }
    }

    if (GamePad__2.Down(PAD_CROSS)) {
        SelectMode = (int) MAP_SELECT_MODE_CANCEL;
    }

    cursor += sprintf(cursor, "\n\n");

    for (int i = 0; i < 8; i++) {
        if (i == select) {
            cursor += sprintf(cursor, ">>");
        } else {
            cursor += sprintf(cursor, "  ");
        }

        cursor += sprintf(cursor, "%s", map_sel_type[i]);

        if (i == select) {
            cursor += sprintf(cursor, "<<");
        }

        cursor += sprintf(cursor, "\n");
    }

    GetDebugFont()->DrawDirect(text, 10, 10);
    return 0;
}

/**
 *
 * Handles and draws the map list for the selected category.
 *
 */
int MapSelect() {
    char  text[0x800];
    char *name;
    char *cursor = text;
    int  *selected;
    int   count;
    int  *top;
    int   paged;
    int   offset;
    selected = &select__1049[SelectMapType];
    top = &top__1050[SelectMapType];
    offset = *selected - *top;

    if (GamePad__2.Down(PAD_UP)) {
        (*selected)--;
    }

    if (GamePad__2.Down(PAD_DOWN)) {
        (*selected)++;
    }

    paged = 0;

    if (GamePad__2.Down(PAD_L1)) {
        paged = 1;
        *top -= 8;
    }

    if (GamePad__2.Down(PAD_R1)) {
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

    int selected_map_no = SearchMapNo(SelectMapList[SelectMapType][*selected]);
    cursor += sprintf(cursor, "\n\nMapNo = %d\n", selected_map_no);
    int end = *top + 8;

    if (count < end) {
        end = count;
    }

    for (int i = *top; i < end; i++) {
        int map_no = SearchMapNo(SelectMapList[SelectMapType][i]);

        if (i == *selected) {
            cursor += sprintf(cursor, ">>");
        } else {
            cursor += sprintf(cursor, "  ");
        }

        cursor += sprintf(cursor, "%s", SelectMapList[SelectMapType][i]);

        if (selected_map_no < 0) {
            cursor += sprintf(cursor, "   *");
        } else {
            cursor += sprintf(cursor, "    ");
        }

        name = NULL;
        GetMapName(map_no, &name);

        if (name != NULL) {
            cursor += sprintf(cursor, "%s", name);
        }

        if (i == *selected) {
            cursor += sprintf(cursor, "<<");
        }

        cursor += sprintf(cursor, "\n");
    }

    GetDebugFont()->DrawDirect(text, 10, 10);

    if (GamePad__2.Down(PAD_CROSS)) {
        SelectMode = (int) MAP_SELECT_MODE_TYPE;
    }

    if (GamePad__2.Down(PAD_CIRCLE)) {
        strcpy(SelectMapName, SelectMapList[SelectMapType][*selected]);
        SelectMode = (int) MAP_SELECT_MODE_DECIDE;
    }

    return 0;
}

int MapSelectLoop() {
    switch (SelectMode) {
        case MAP_SELECT_MODE_CANCEL:
            return (int) MAP_SELECT_CANCEL;
        case MAP_SELECT_MODE_TYPE:
            MapTypeSelect();
            break;
        case MAP_SELECT_MODE_MAP:
            MapSelect();
            break;
        case MAP_SELECT_MODE_DECIDE:
            return (int) MAP_SELECT_DECIDE;
    }

    return (int) MAP_SELECT_CONTINUE;
}

void InitSaveDataEdit(mgCMemory *stack) {
}

int SaveDataEditLoop() {
    CScene             *scene = GetMainScene();
    CSaveData          *save = GetSaveData();
    char                display[0x800];
    char               *cursor = display;
    GAME_PROGRESS_INFO *progress;
    const char         *progress_name;
    SV_CONFIG_OPTION   *config = save->GetConfig();
    SaveEditLabels      marker = {
        {"  ", ">>"}
    };
    SaveEditLabels on_off = {
        {"OFF", "ON"}
    };
    progress = GetGameProgressInfo(SedSelData[SED_PROGRESS]);
    SedSelData[SED_PLAY_TIME] = GetPlayTimeCountFlag();
    s8 *caption[1] = {&config->caption_off};
    progress_name = marker.text[0];

    if (progress != NULL) {
        progress_name = progress->name;
    }

    cursor += sprintf(cursor, "Save Data Editer\n\n");
    cursor += sprintf(cursor, "%sPROGRESS  %d(%s)\n", marker.text[SedSel == SED_PROGRESS], SedSelData[SED_PROGRESS], progress_name);
    cursor += sprintf(cursor, "%sTIME      %5.1f\n", marker.text[SedSel == SED_TIME], save->now_time);
    cursor += sprintf(cursor, "%sFLAG      %4d = %s\n", marker.text[SedSel == SED_FLAG], SedSelData[SED_FLAG], on_off.text[save->GetBitFlag(SedSelData[SED_FLAG]) != 0]);
    cursor += sprintf(cursor, "%sGEO COMP  %d\n", marker.text[SedSel == SED_GEO_COMP], SedSelData[SED_GEO_COMP]);
    cursor += sprintf(cursor, "%sPLAY TIME %d\n", marker.text[SedSel == SED_PLAY_TIME], SedSelData[SED_PLAY_TIME]);
    int        config_value = *caption[0];
    const int &config_reference = config_value;
    cursor += sprintf(cursor, "%sCONFIG    %s = %d\n", marker.text[SedSel == SED_CONFIG], config_str[0], config_reference);
    SedSelData[SED_PROGRESS] = save->game_progress;

    if (SedSel == SED_PROGRESS) {
        if (GamePad__2.Down(PAD_RIGHT)) {
            ++SedSelData[SED_PROGRESS];
        }

        if (GamePad__2.Down(PAD_LEFT)) {
            --SedSelData[SED_PROGRESS];
        }

        if (SedSelData[SED_PROGRESS] <= 0) {
            SedSelData[SED_PROGRESS] = 1;
        }

        if (SedSelData[SED_PROGRESS] >= GetGameProgressNum()) {
            SedSelData[SED_PROGRESS] = GetGameProgressNum() - 1;
        }

        save->game_progress = SedSelData[SED_PROGRESS];
    }

    if (SedSel == SED_TIME) {
        int hour = (int) save->now_time;

        if (GamePad__2.Down(PAD_RIGHT)) {
            ++hour;
        }

        if (GamePad__2.Down(PAD_LEFT)) {
            --hour;
        }

        hour %= 24;

        if (GamePad__2.Down(PAD_TRIANGLE)) {
            if (hour == 12) {
                hour = 0;
            } else {
                hour = 12;
            }
        }

        scene->SetTime((float) hour);
        save->now_time = (float) hour;
    }

    if (SedSel == SED_FLAG) {
        if (GamePad__2.Down(PAD_RIGHT)) {
            ++SedSelData[SED_FLAG];
        }

        if (GamePad__2.Down(PAD_LEFT)) {
            --SedSelData[SED_FLAG];
        }

        if (GamePad__2.Down(PAD_R1)) {
            SedSelData[SED_FLAG] += 10;
        }

        if (GamePad__2.Down(PAD_L1)) {
            SedSelData[SED_FLAG] -= 10;
        }

        if (GamePad__2.Down(PAD_R2)) {
            SedSelData[SED_FLAG] += 100;
        }

        if (GamePad__2.Down(PAD_L2)) {
            SedSelData[SED_FLAG] -= 100;
        }

        if (SedSelData[SED_FLAG] < 0) {
            SedSelData[SED_FLAG] = 0;
        }

        if (GamePad__2.Down(PAD_CIRCLE)) {
            save->SetBitFlag(SedSelData[SED_FLAG], !save->GetBitFlag(SedSelData[SED_FLAG]));
        }
    }

    if (SedSel == SED_GEO_COMP) {
        if (GamePad__2.Down(PAD_RIGHT)) {
            ++SedSelData[SED_GEO_COMP];
        }

        if (GamePad__2.Down(PAD_LEFT)) {
            --SedSelData[SED_GEO_COMP];
        }

        if (SedSelData[SED_GEO_COMP] < 0) {
            SedSelData[SED_GEO_COMP] = 0;
        }

        if (GamePad__2.Down(PAD_CIRCLE) || GamePad__2.Down(PAD_TRIANGLE)) {
            DebugInfo.georama_debug = 1;
            CEditData *edit = save->GetEditData(SedSelData[SED_GEO_COMP]);

            if (edit != NULL) {
                edit->dbgSetAllContintionFlag(SedSelData[SED_GEO_COMP], GamePad__2.Down(PAD_CIRCLE));
            }
        }
    }

    if (SedSel == SED_PLAY_TIME) {
        if (GamePad__2.Down(PAD_RIGHT)) {
            SedSelData[SED_PLAY_TIME] = 1;
        }

        if (GamePad__2.Down(PAD_LEFT)) {
            SedSelData[SED_PLAY_TIME] = 0;
        }

        PlayTimeCount(SedSelData[SED_PLAY_TIME]);
    }

    if (SedSel == SED_CONFIG) {
        if (GamePad__2.Down(PAD_RIGHT)) {
            ++SedSelData[SED_CONFIG];
        }

        if (GamePad__2.Down(PAD_LEFT)) {
            --SedSelData[SED_CONFIG];
        }

        SedSelData[SED_CONFIG] = 0;

        if (GamePad__2.Down(PAD_CIRCLE)) {
            if (*caption[0] != 0) {
                *caption[0] = 0;
            } else {
                *caption[0] = 1;
            }
        }
    }

    if (GamePad__2.Down(PAD_DOWN)) {
        ++SedSel;
    }

    if (GamePad__2.Down(PAD_UP)) {
        --SedSel;
    }

    if (SedSel < 0) {
        SedSel = SED_ITEM_NUM - 1;
    }

    if (SedSel >= SED_ITEM_NUM) {
        SedSel = 0;
    }

    GetDebugFont()->DrawDirect(display, 10, 10);

    if (GamePad__2.Down(PAD_CROSS)) {
        return 1;
    }

    return 0;
}

int EventViewLoop() {
    char  text[0x400];
    char *cursor = text;
    cursor += sprintf(cursor, "\nEvent \n");

    if (BossBattleSelFlag != 0) {
        if (top_event < BossEventTop) {
            top_event = BossEventTop;
        }

        BossBattleSelFlag = 0;
    }

    int            index = top_event;
    int            last = index + 10;
    SaveEditLabels marker = {
        {"  ", ">>"}
    };

    if (last >= EventInfoNum) {
        last = EventInfoNum;
    }

    for (; index < last; index++) {
        EVENT_VIEW_INFO *info = &EventInfo[index];

        if (info->name != NULL) {
            cursor += sprintf(cursor, "%s%s   %s\n", marker.text[index == top_event + sel_event],
                              info->name, info->detail);
        }
    }

    GetDebugFont()->DrawDirect(text, 10, 10);

    if (GamePad__2.Down(PAD_UP)) {
        sel_event--;
    }

    if (GamePad__2.Down(PAD_DOWN)) {
        sel_event++;
    }

    if (GamePad__2.Down(PAD_LEFT | PAD_L1)) {
        top_event -= 10;
    }

    if (GamePad__2.Down(PAD_RIGHT | PAD_R1)) {
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

    if (GamePad__2.Down(PAD_CIRCLE)) {
        INIT_LOOP_ARG    loop_arg;
        EVENT_VIEW_INFO *chosen = &EventInfo[top_event + sel_event];

        if (chosen->map_no >= 0) {
            loop_arg.map_no = chosen->map_no;
            loop_arg.floor_no = chosen->floor_no;
            loop_arg.event_no = chosen->event_no;

            if (chosen->dungeon != 0) {
                NextLoop((int) LOOP_DUNGEON, loop_arg);
            } else {
                NextLoop((int) LOOP_EDIT, loop_arg);
            }

            return 1;
        }
    }

    if (GamePad__2.Down(PAD_CROSS)) {
        return 2;
    }

    return 0;
}

void LoadEventViewData(u_long128 *buffer, mgCMemory *stack) {
    int              file_size;
    char             fields[16][0x80];
    char            *columns[16];
    int              index;
    char            *end;
    EVENT_VIEW_INFO *entry;
    int              map_no;
    char            *next;
    int              floor_no;
    int              dungeon;

    if (!LoadFile2("event/view_pal.txt", buffer, &file_size, 0)) {
        return;
    }

    EventInfo = new (stack->Alloc(0x382)) EVENT_VIEW_INFO[EVENT_VIEW_MAX];

    for (index = 0; index < EVENT_VIEW_MAX; ++index) {
        memset(&EventInfo[index], 0, sizeof(EVENT_VIEW_INFO));
    }

    end = (char *) buffer + file_size;

    for (index = 0; index < 16; ++index) {
        columns[index] = fields[index];
    }

    entry = EventInfo;
    EventInfoNum = 0;
    BossEventTop = 0;
    next = GetLine(columns, (char *) buffer, end);

    while (next < end) {
        next = GetLine(columns, next, end);
        map_no = SearchMapNo(columns[0]);
        floor_no = 0;
        dungeon = 0;

        if (columns[1][0] != 0) {
            map_no = atoi(columns[1]) - 1;
            floor_no = atoi(columns[2]);
            dungeon = 1;
        }

        entry->map_no = map_no;
        entry->floor_no = floor_no;
        entry->dungeon = dungeon;
        entry->event_no = atoi(columns[3]);
        entry->name = mgCopyString(columns[6], stack);
        entry->detail = mgCopyString(columns[7], stack);
        EventInfoNum++;

        if (strcmp(columns[8], "B") != 0) {
            ++BossEventTop;
        }

        entry++;
    }
}

/**
 *
 * Splits a map event data line into tab-separated columns and returns the next line.
 *
 */
static char *GetLine(char **columns, char *position, char *end) {
    LineBreakPair line_break_pair = {
        {'\r', '\n'}
    };
    int field;
    int length;

    if (position < end) {
        field = 0;

        do {
            if (memcmp(position, line_break_pair.chars, 2) == 0) {
                position += 2;
                break;
            }

            if (memcmp(position, line_break_pair.chars, 1) == 0) {
                position += 1;
                break;
            }

            if (memcmp(position, line_break_pair.chars + 1, 1) == 0) {
                position += 1;
                break;
            }

            length = 0;

            while (position < end) {
                if (memcmp(position, line_break_pair.chars, 2) == 0 ||
                    memcmp(position, line_break_pair.chars, 1) == 0 ||
                    memcmp(position, line_break_pair.chars + 1, 1) == 0) {
                    break;
                }

                s8 ch = *position;

                if (ch == '\t') {
                    char *next = columns[field + 1];
                    position++;

                    if (next != NULL) {
                        *next = 0;
                    }

                    break;
                }

                if (ch != ' ' && columns[field] != NULL) {
                    columns[field][length] = ch;
                    length++;
                }

                position++;
            }

            char *current = columns[field];

            if (current != NULL) {
                field++;
                current[length] = 0;
            }
        } while (position < end);
    }

    return position;
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
        left = frame->SearchFrame("atoramiria");
        right = frame->SearchFrame("himo");

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
        left = frame->SearchFrame("atoramiria");

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
        right = frame->SearchFrame("atora");

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
