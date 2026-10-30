// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <array>
#include <charconv>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <optional>
#include <string>
#include <string_view>

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
#include "text/bounded.hpp"
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

namespace {
dc2::memory::ArenaBuffer event_table_storage;
}

std::span<const EVENT_VIEW_INFO> dc2::debug::EventViewEntries() {
    const auto storage = event_table_storage.Bytes();
    if (EventInfoNum <= 0 || EventInfoNum > EVENT_VIEW_MAX ||
        storage.size() / sizeof(EVENT_VIEW_INFO) < static_cast<std::size_t>(EventInfoNum)) {
        return {};
    }
    return {reinterpret_cast<const EVENT_VIEW_INFO *>(storage.data()), static_cast<std::size_t>(EventInfoNum)};
}

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
static MAP_NAME_INFO *GetMapNameInfo(int map_no);
int                   MapTypeSelect();
int                   MapSelect();

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

void LoadMapName(int language, u_long128 *buffer);

/**
 *
 * Finds a loaded map name record by its map number.
 *
 */
static MAP_NAME_INFO *GetMapNameInfo(int map_no) {

    if (map_no < 0 || map_no >= MapNameNum) {
        return nullptr;
    }

    return &map_name[map_no];
}

std::string dc2::world::MapPath(std::string_view name) {
    std::string path = "map/";
    path.append(name.substr(0, 1));
    path += '/';
    if (name.size() >= 3) {
        path.append(name.substr(0, 3));
        path += '/';
    }
    if (name.size() >= 6) {
        path.append(name.substr(3, 3));
        path += '/';
    }
    path.append(name);
    return path;
}

int GetMapType(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);

    if (info != nullptr) {
        return info->type;
    }

    return -1;
}

int GetMapAreaNo(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);

    if (info != nullptr) {
        return info->area_no;
    }

    return -1;
}

int GetMapSelType(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);

    if (info != nullptr) {
        return info->sel_type;
    }

    return 0;
}

int GetMapSndDataID(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);

    if (info != nullptr) {
        return info->snd_data_id;
    }

    return -1;
}

char *GetMapName(int map_no, char **title) {
    if (title != nullptr) {
        *title = nullptr;
    }

    MAP_NAME_INFO *info = GetMapNameInfo(map_no);

    if (info == nullptr) {
        return SelectMapName;
    }

    if (title != nullptr) {
        *title = info->title;
    }

    return info->name;
}

int SearchMapNo(char *name) {
    struct {
        int   no;
        char *name;
    } search{};

    search.name = name;

    if (search.name == nullptr) {
        return -1;
    }

    search.no = 0;

    for (; search.no < MapNameNum; search.no++) {
        MAP_NAME_INFO *info = &map_name[search.no];

        if (info->name != nullptr && strcmp(info->name, search.name) == 0) {
            return search.no;
        }
    }

    return -1;
}

char *GetMapTitle(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);

    if (info != nullptr) {
        return info->title;
    }

    return nullptr;
}

char *GetAddMapPath(int map_no) {
    MAP_NAME_INFO *info = GetMapNameInfo(map_no);

    if (info != nullptr) {
        return info->add_path;
    }

    return nullptr;
}

void InitMapSelect(mgCMemory *stack) {
    MenuStack = stack;
    SetCurrentDir(nullptr);
    int list_size = {};
    LoadFile("map/map.lst", ReadBufferBytes(), &list_size);
    input_str lines;
    lines.buffer = reinterpret_cast<char *>(read_buffer);
    lines.size = list_size;

    for (int type = 0; type < MAP_SEL_TYPE_NUM; ++type) {
        SelectMapNum[type] = 0;
        SelectMapList[type] = new (MenuStack->Alloc(0x22)) char *[SELECT_MAP_MAX];

        for (int index = 0; index < SELECT_MAP_MAX; ++index) {
            SelectMapList[type][index] = nullptr;
        }
    }

    SelectMode = MAP_SELECT_MODE_TYPE;
    char line[0x100];

    if (!lines.GetLine(line, sizeof(line), nullptr)) {
        return;
    }

    int path_length = strlen(line) + 1;

    if (lines.GetLine(line, sizeof(line), nullptr)) {
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
                        letter = nullptr;
                        break;
                    }
                }

                if (letter != nullptr) {
                    auto path = DivPathNameExt(line + path_length);
                    int  type = GetMapSelType(SearchMapNo(path.name.data()));
                    SelectMapList[type][SelectMapNum[type]++] = mgCopyString(path.name.data(), MenuStack);
                }
            }
        } while (lines.GetLine(line, sizeof(line), nullptr));
    }
}

/**
 *
 * Handles and draws the map category selection screen.
 *
 */
int MapTypeSelect() {
    std::string text;

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
            SelectMode = MAP_SELECT_MODE_MAP;
        }
    }

    if (GamePad__2.Down(PAD_CROSS)) {
        SelectMode = MAP_SELECT_MODE_CANCEL;
    }

    dc2::text::AppendFormatted(text, "\n\n");

    for (int i = 0; i < 8; i++) {
        if (i == select) {
            dc2::text::AppendFormatted(text, ">>");
        } else {
            dc2::text::AppendFormatted(text, "  ");
        }

        dc2::text::AppendFormatted(text, "%s", map_sel_type[i]);

        if (i == select) {
            dc2::text::AppendFormatted(text, "<<");
        }

        dc2::text::AppendFormatted(text, "\n");
    }

    GetDebugFont()->DrawDirect(text.data(), 10, 10);
    return 0;
}

/**
 *
 * Handles and draws the map list for the selected category.
 *
 */
int MapSelect() {
    std::string text;
    char       *name = {};
    int        *selected = {};
    int         count = {};
    int        *top = {};
    int         paged = {};
    int         offset = {};
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
    dc2::text::AppendFormatted(text, "\n\nMapNo = %d\n", selected_map_no);
    int end = *top + 8;

    if (count < end) {
        end = count;
    }

    for (int i = *top; i < end; i++) {
        int map_no = SearchMapNo(SelectMapList[SelectMapType][i]);

        if (i == *selected) {
            dc2::text::AppendFormatted(text, ">>");
        } else {
            dc2::text::AppendFormatted(text, "  ");
        }

        dc2::text::AppendFormatted(text, "%s", SelectMapList[SelectMapType][i]);

        if (selected_map_no < 0) {
            dc2::text::AppendFormatted(text, "   *");
        } else {
            dc2::text::AppendFormatted(text, "    ");
        }

        name = nullptr;
        GetMapName(map_no, &name);

        if (name != nullptr) {
            dc2::text::AppendFormatted(text, "%s", name);
        }

        if (i == *selected) {
            dc2::text::AppendFormatted(text, "<<");
        }

        dc2::text::AppendFormatted(text, "\n");
    }

    GetDebugFont()->DrawDirect(text.data(), 10, 10);

    if (GamePad__2.Down(PAD_CROSS)) {
        SelectMode = MAP_SELECT_MODE_TYPE;
    }

    if (GamePad__2.Down(PAD_CIRCLE)) {
        dc2::text::Copy(SelectMapName, dc2::text::View(SelectMapList[SelectMapType][*selected]));
        SelectMode = MAP_SELECT_MODE_DECIDE;
    }

    return 0;
}

int MapSelectLoop() {
    switch (SelectMode) {
        case MAP_SELECT_MODE_CANCEL:
            return MAP_SELECT_CANCEL;
        case MAP_SELECT_MODE_TYPE:
            MapTypeSelect();
            break;
        case MAP_SELECT_MODE_MAP:
            MapSelect();
            break;
        case MAP_SELECT_MODE_DECIDE:
            return MAP_SELECT_DECIDE;
    }

    return MAP_SELECT_CONTINUE;
}

void InitSaveDataEdit(mgCMemory *stack) {
}

int SaveDataEditLoop() {
    CScene             *scene = GetMainScene();
    CSaveData          *save = GetSaveData();
    std::string         display;
    GAME_PROGRESS_INFO *progress = {};
    const char         *progress_name = {};
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

    if (progress != nullptr) {
        progress_name = progress->name;
    }

    dc2::text::AppendFormatted(display, "Save Data Editer\n\n");
    dc2::text::AppendFormatted(display, "%sPROGRESS  %d(%s)\n", marker.text[SedSel == SED_PROGRESS], SedSelData[SED_PROGRESS], progress_name);
    dc2::text::AppendFormatted(display, "%sTIME      %5.1f\n", marker.text[SedSel == SED_TIME], save->now_time);
    dc2::text::AppendFormatted(display, "%sFLAG      %4d = %s\n", marker.text[SedSel == SED_FLAG], SedSelData[SED_FLAG], on_off.text[save->GetBitFlag(SedSelData[SED_FLAG]) != 0]);
    dc2::text::AppendFormatted(display, "%sGEO COMP  %d\n", marker.text[SedSel == SED_GEO_COMP], SedSelData[SED_GEO_COMP]);
    dc2::text::AppendFormatted(display, "%sPLAY TIME %d\n", marker.text[SedSel == SED_PLAY_TIME], SedSelData[SED_PLAY_TIME]);
    int        config_value = *caption[0];
    const int &config_reference = config_value;
    dc2::text::AppendFormatted(display, "%sCONFIG    %s = %d\n", marker.text[SedSel == SED_CONFIG], config_str[0], config_reference);
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
        int hour = static_cast<int>(save->now_time);

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

        scene->SetTime(static_cast<float>(hour));
        save->now_time = static_cast<float>(hour);
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

            if (edit != nullptr) {
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

    GetDebugFont()->DrawDirect(display.data(), 10, 10);

    if (GamePad__2.Down(PAD_CROSS)) {
        return 1;
    }

    return 0;
}

int EventViewLoop() {
    const auto entries = dc2::debug::EventViewEntries();
    if (entries.empty()) {
        return 0;
    }
    std::string text;
    dc2::text::AppendFormatted(text, "\nEvent \n");

    if (BossBattleSelFlag != 0) {
        if (top_event < BossEventTop) {
            top_event = BossEventTop;
        }

        BossBattleSelFlag = 0;
    }

    top_event = std::clamp(top_event, 0, EventInfoNum - 1);
    sel_event = std::clamp(sel_event, 0, std::min(9, EventInfoNum - top_event - 1));
    int            index = top_event;
    int            last = index + 10;
    SaveEditLabels marker = {
        {"  ", ">>"}
    };

    if (last >= EventInfoNum) {
        last = EventInfoNum;
    }

    for (; index < last; index++) {
        const EVENT_VIEW_INFO *info = &entries[static_cast<std::size_t>(index)];

        if (info->name != nullptr) {
            dc2::text::AppendFormatted(text, "%s%s   %s\n", marker.text[index == top_event + sel_event],
                                       info->name, info->detail);
        }
    }

    GetDebugFont()->DrawDirect(text.data(), 10, 10);

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

    top_event = std::clamp(top_event, 0, EventInfoNum - 1);
    sel_event = std::clamp(sel_event, 0, std::min(9, EventInfoNum - top_event - 1));
    if (GamePad__2.Down(PAD_CIRCLE)) {
        INIT_LOOP_ARG          loop_arg;
        const EVENT_VIEW_INFO *chosen = &entries[static_cast<std::size_t>(top_event + sel_event)];

        if (chosen->map_no >= 0) {
            loop_arg.map_no = chosen->map_no;
            loop_arg.floor_no = chosen->floor_no;
            loop_arg.event_no = chosen->event_no;

            if (chosen->dungeon != 0) {
                NextLoop(LOOP_DUNGEON, loop_arg);
            } else {
                NextLoop(LOOP_EDIT, loop_arg);
            }

            return 1;
        }
    }

    if (GamePad__2.Down(PAD_CROSS)) {
        return 2;
    }

    return 0;
}

void LoadEventViewData(std::span<u8> buffer, mgCMemory *stack) {
    EventInfo = nullptr;
    event_table_storage = {};
    EventInfoNum = 0;
    BossEventTop = 0;
    int file_size = 0;
    if (stack == nullptr || !LoadFile2("event/view_pal.txt", buffer, &file_size, LOAD_FILE_READ) || file_size <= 0) {
        return;
    }
    auto *entries = dc2::memory::NewArray<EVENT_VIEW_INFO>(*stack, EVENT_VIEW_MAX);
    if (entries == nullptr) {
        return;
    }
    const auto parse_integer = [](std::string_view text) -> std::optional<int> {
        int        value = 0;
        const auto result = std::from_chars(text.data(), text.data() + text.size(), value);
        if (result.ec != std::errc{} || result.ptr != text.data() + text.size()) {
            return std::nullopt;
        }
        return value;
    };
    std::string_view input(reinterpret_cast<const char *>(buffer.data()), static_cast<std::size_t>(file_size));
    const auto       read_line = [&input]() {
        const auto end = input.find_first_of("\r\n");
        const auto line = input.substr(0, end);
        if (end == std::string_view::npos) {
            input = {};
        } else {
            const char delimiter = input[end];
            input.remove_prefix(end + 1);
            if (delimiter == '\r' && input.starts_with('\n')) {
                input.remove_prefix(1);
            }
        }
        return line;
    };
    read_line();
    while (!input.empty() && EventInfoNum < EVENT_VIEW_MAX) {
        std::array<std::string, 16> columns;
        std::size_t                 field = 0;
        bool                        valid = true;
        for (const char character : read_line()) {
            if (character == '\t') {
                if (++field == columns.size()) {
                    valid = false;
                    break;
                }
            } else if (character != ' ') {
                columns[field] += character;
            }
        }
        const auto event_no = parse_integer(columns[3]);
        if (!valid || !event_no) {
            continue;
        }
        EVENT_VIEW_INFO entry{};
        entry.event_no = *event_no;
        if (!columns[1].empty()) {
            const auto map = parse_integer(columns[1]);
            const auto floor = parse_integer(columns[2]);
            if (!map || !floor || *map == std::numeric_limits<int>::min()) {
                continue;
            }
            entry.map_no = *map - 1;
            entry.floor_no = *floor;
            entry.dungeon = 1;
        } else {
            entry.map_no = SearchMapNo(columns[0].data());
        }
        entry.name = mgCopyString(columns[6].data(), stack);
        entry.detail = mgCopyString(columns[7].data(), stack);
        if (entry.name == nullptr || entry.detail == nullptr) {
            break;
        }
        entries[EventInfoNum++] = entry;
        if (columns[8] != "B") {
            ++BossEventTop;
        }
    }
    event_table_storage = dc2::memory::ArenaBuffer::Bind(*stack,
                                                         std::span(reinterpret_cast<u8 *>(entries), static_cast<std::size_t>(EVENT_VIEW_MAX) * sizeof(EVENT_VIEW_INFO)));
    EventInfo = entries;
}

void AtraMiriaOnOff(int mode, CCharacter2 *chara, int enable) {
    mgCFrame *left = {};
    mgCFrame *right = {};
    mgCFrame *frame = {};

    if (chara == nullptr) {
        return;
    }

    frame = chara->CObjectFrame::frame;

    if (frame == nullptr) {
        return;
    }

    if (mode == 0) {
        left = frame->SearchFrame("atoramiria");
        right = frame->SearchFrame("himo");

        if (enable) {
            if (left != nullptr) {
                left->attr->draw = 5;
            }

            if (right != nullptr) {
                right->attr->draw = 1;
            }
        } else {
            if (left != nullptr) {
                left->attr->draw = 2;
            }

            if (right != nullptr) {
                right->attr->draw = 2;
            }
        }
    }

    if (mode == 1) {
        left = frame->SearchFrame("atoramiria");

        if (enable) {
            if (left != nullptr) {
                left->attr->draw = 1;
            }
        } else {
            if (left != nullptr) {
                left->attr->draw = 2;
            }
        }
    }

    if (mode == 2) {
        right = frame->SearchFrame("atora");

        if (enable) {
            if (right != nullptr) {
                right->attr->draw = 5;
            }
        } else {
            if (right != nullptr) {
                right->attr->draw = 2;
            }
        }
    }
}

// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
// clang-format on

#include "common.h"

#include <cstddef>
#include <cstring>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

#include "mapselect.hpp"
#include "stubs/mapselect.hpp"

namespace {

/**
 * Names, type and identifiers one MAP_NAME row gives a map.
 */
struct MapNameEntry {
    std::optional<std::string> name;        /**< CP932 file name of the map; empty or none stores null. */
    std::optional<std::string> title;       /**< CP932 name shown to the player; empty or none stores null. */
    std::optional<std::string> add_path;    /**< CP932 additional path; empty or none stores null. */
    int                        type;        /**< Kind of map. */
    int                        sel_type;    /**< Map selection category. */
    std::optional<int>         snd_data_id; /**< Sound data of the map, or none for -1. */
    std::optional<int>         area_no;     /**< Area of the map, or none to leave it 0. */
};

/**
 * Typed contents of a map_names document.
 */
struct MapNames {
    int                       count; /**< MAP_NAME_NUM count, which sizes the table. */
    std::vector<MapNameEntry> maps;  /**< Maps in table order. */
};

/**
 * Bytes a string of the table takes in the string storage: none for a missing or empty one.
 */
std::size_t StoredBytes(const std::optional<std::string> &text) {
    return text && !text->empty() ? text->size() + 1 : 0;
}

/**
 * Quadwords of MapNameBuff the table of a count takes before its strings.
 */
std::size_t TableQuadwords(int count) {
    return ((static_cast<std::size_t>(count) + 1) * sizeof(MAP_NAME_INFO) >> 4) + 1;
}

/**
 * Parses a map_names document, refusing one whose table or strings would not fit MapNameBuff.
 */
MapNames ParseMapNames(const native_config::Json &document) {
    using namespace native_config;
    MapNames names{.count = Int(document, "count"), .maps = {}};
    if (names.count < 0) {
        throw std::runtime_error("negative map name count");
    }
    std::size_t string_bytes = 0;
    for (const auto &map : Array(document, "maps")) {
        MapNameEntry entry{.name = OptionalText(map, "name"), .title = OptionalText(map, "title"), .add_path = OptionalText(map, "add_path"), .type = Int(map, "type"), .sel_type = Int(map, "sel_type"), .snd_data_id = OptionalInt(map, "snd_data_id"), .area_no = OptionalInt(map, "area_no")};
        string_bytes += StoredBytes(entry.name) + StoredBytes(entry.title) + StoredBytes(entry.add_path);
        names.maps.push_back(std::move(entry));
    }
    // Retail clears count + 1 entries; later rows would overwrite the strings.
    if (names.maps.size() > static_cast<std::size_t>(names.count) + 1) {
        throw std::runtime_error("more map names than the table holds");
    }
    if (TableQuadwords(names.count) + (string_bytes / 16) + 1 > MAP_NAME_BUFF_SIZE) {
        throw std::runtime_error("map names exceed the map name buffer");
    }
    return names;
}

/**
 * Copies one optional map name into the validated native table storage.
 */
char *StoreString(std::optional<std::string> &text) {
    if (!text || text->empty()) {
        return nullptr;
    }
    char *copy = CharBuff + pCharBuff;
    std::memcpy(copy, text->c_str(), text->size() + 1);
    pCharBuff += static_cast<int>(text->size()) + 1;
    return copy;
}

} // namespace

void LoadMapName(int language, u_long128 * /*buffer*/) {
    MapNameNum = 0;
    const auto path = "map/map" + std::to_string(language) + ".cfg.json";
    auto       names = native_config::ReadGame<MapNames>(path.c_str(), "map_names", ParseMapNames);
    if (!names) {
        return;
    }

    pMapNameBuff = 0;
    pCharBuff = 0;
    MapNameNum = names->count;
    map_name = reinterpret_cast<MAP_NAME_INFO *>(MapNameBuff + (pMapNameBuff * 16));
    pMapNameBuff += static_cast<int>(TableQuadwords(names->count));
    CharBuff = MapNameBuff + (pMapNameBuff * 16);
    std::memset(map_name, 0, (static_cast<std::size_t>(names->count) + 1) * sizeof(MAP_NAME_INFO));
    now_no = 0;

    for (auto &entry : names->maps) {
        MAP_NAME_INFO *info = &map_name[now_no++];
        info->name = StoreString(entry.name);
        info->title = StoreString(entry.title);
        info->add_path = StoreString(entry.add_path);
        info->type = entry.type;
        info->sel_type = entry.sel_type;
        info->snd_data_id = entry.snd_data_id.value_or(-1);
        if (entry.area_no) {
            info->area_no = *entry.area_no;
        }
    }
    pMapNameBuff += (pCharBuff / 16) + 1;
}
