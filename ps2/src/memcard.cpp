#include "common.h"
#include "memcard.hpp"
#include "mg_memory.hpp"
#include "mainloop.hpp"
#include "dataread.hpp"
#include "editdata.hpp"
#include "menuaqua.hpp"
#include "menusys.hpp"
#include "menucommon.hpp"
#include "menucls1.hpp"
#include "inventmn.hpp"
#include <cstring>
#include <cstdio>

extern char at_852__4[];

struct FormatA { char text[0x14]; };
struct FormatB { char text[0x13]; };
struct McFileName { char text[0x40]; };
struct McSaveDirPattern { char text[0x80]; };
struct McIconBlock40 { u8 data[0x40]; };
struct McIconBlock30 { u8 data[0x30]; };
struct McIconBlock10 { u8 data[0x10]; };
struct AlbumFile { u8 data[0x64000]; char digit_data[0x4B0]; int checksum; int trailer; };
extern "C" int sceMcFlush(int fd);
extern "C" int sceMcUnformat(int port, int slot);
extern u8 cosbit_table[136];
extern "C" void __ct__9CEditDataFv(void *edit);
extern "C" void __ct__16CUserDataManagerFv(void *manager);
extern "C" void __ct__15CMenuSystemDataFv(void *menuSystem);
extern char at_922__4[0x13];
extern char at_923__5[0xD];
extern char at_924__4[];
extern McIconBlock40 at_1031__6;
extern McIconBlock30 at_1032__7;
extern McIconBlock30 at_1033__8;
extern McIconBlock10 at_1034__6;
extern char at_1036__6[];
extern char at_1229__3[0x10];
extern int old_format_1242;
extern char at_843__5[];
extern const unsigned char at_1315__3[5];
extern unsigned char at_1954[0x2B];
extern char at_2083__2[0x18];
extern McFileName at_2131__3;
extern McSaveDirPattern at_2297;
extern int ReadFileNo_2290;
extern char init_2291;
extern char at_2285[0x12];
extern FormatA at_838__5;
extern FormatB at_839__5;
extern const char *MCBrowsetName[3][4];
extern u16 MCBrowserName_Offset[3][4];
extern short DngTreeSaveFlag;
extern int iconNo_1323;
extern char at_1953[];
extern char at_1679__2[];
extern char at_1680__2[];
extern char at_1681[];
extern int test_write_num_1476;
extern char init_1477;
extern char at_1581__4[];
extern char at_1582__4[];
extern "C" int sceMcSeek(int fd, int offset, int origin);
extern char init_1324;
extern char at_1453__3[];
extern char at_1454__3[];
extern char at_1455__3[];

// Code (.text)
void CopyMCBrowserName(int index, char *name, u16 *offset) {
    int region = 0;
    if (CheckNowEurope() != 0) {
        region = 2;
    } else if (LanguageCode == 1) {
        region = 1;
    }
    strcpy(name, MCBrowsetName[region][index]);
    if (offset != NULL) {
        *offset = MCBrowserName_Offset[region][index];
    }
}
void SetDngTreeFlag(int flag) {
    DngTreeSaveFlag = flag;
}
void MakeMemoryCardFileName(int slot, char *path) {
    FormatA directory = at_838__5;
    FormatB file_name = at_839__5;
    sprintf(directory.text, directory.text, slot);
    sprintf(file_name.text, file_name.text, slot);
    if (path != NULL) {
        strcpy(path, directory.text);
        strcat(path, at_843__5);
        strcat(path, file_name.text);
    }
}
void MakeMemoryCardAlbumName(char *name, int append_again) {
    if (name != NULL) {
        strcpy(name, at_852__4);
        if (append_again != 0) {
            strcat(name, at_852__4);
        }
    }
}
int MakeCheckDigit(int mode, char *data, int size) {
    int sum = 0;
    if (mode == 0) {
        int blocks = size / 64;
        int i;
        sum = 0;
        for (i = 0; i < blocks; i++) {
            sum += (u8)*data % 255;
            data += 64;
        }
    }
    return sum;
}
CMemoryCardManager::CMemoryCardManager() {
    Initialize(NULL);
}
void CMemoryCardManager::Initialize(mgCMemory *memory) {
    memset(this, 0, 0x1100);
    strcpy(file_name, at_922__4);
    strcpy(game_name, at_923__5);
    port = 0;
    file_no = 0;
    fd = -1;
    save_buffer = NULL;
    if (memory != NULL) {
        u8 *buffer;
        if ((buffer = (u8 *)operator new(sizeof(SAVEDATA_FORMAT),
                                         (u_long128 *)memory->Alloc(0x659E))) !=
            NULL) {
            u8 *edit = buffer + 0x1CA4;
            do {
                __ct__9CEditDataFv(edit);
                edit += 0x5510;
            } while (edit < buffer + 0x1C5F4);
            __ct__16CUserDataManagerFv(buffer + 0x1D320);
            ((CQuestData *)(buffer + 0x62AC0))->Initialize();
            __ct__15CMenuSystemDataFv(buffer + 0x64140);
        }
        save_buffer = (SAVEDATA_FORMAT *)buffer;
        memset(save_buffer, 0, sizeof(SAVEDATA_FORMAT));
    }
    InitError();
    InitSaveFileInfoTable();
    strcpy(version, at_924__4);
    func_no = MC_FUNC_IDLE;
    search_wait = 0x3D;
    step = 0;
    album_buffer_set = 0;
    album_buffer = NULL;
    load_map_no = -1;
    load_program_loop_no = -1;
    load_dng_tree_flag = 0;
    transfer_size = 0;
    transferred = 0;
    total_transferred = 0;
    transfer_result = 0;
    memset(work_buffer, 0, sizeof(work_buffer));
    memset(&card[0], 0, 0x40);
    InitPlayDataInfo();
    file_exists = 0;
    memset(&icon[0], 0, 0x78);
    card[0].present = 0;
    card[1].present = 0;
}
void CMemoryCardManager::InitSaveFileInfoTable() {
    int entry_no;
    int entry_offset;
    CMemoryCardManager *entry_base;

    entry_offset = 0;
    entry_no = 0;
    do {
        entry_base = (CMemoryCardManager *)((u8 *)this + entry_offset);
        memset(&entry_base->dir_table[0], 0, sizeof(MC_DIR_ENTRY));
        entry_no += 1;
        entry_base->dir_table[0].name[0] = 0;
        entry_offset += sizeof(MC_DIR_ENTRY);
    } while (entry_no < 17);
}
int CMemoryCardManager::GetOpenAttribute(char *name) {
    for (int i = 0; i < 17; i++) {
        if (strcmp(name, dir_table[i].name) == 0) {
            return 1;
        }
    }
    return 0;
}
void CMemoryCardManager::InitError() {
    memset(&error, 0, sizeof(error));
}
int CMemoryCardManager::InitForMC() {
    int result;
    switch (sceMcInit()) {
        case 0:
            result = 0;
            break;
        case -101:
            result = 1;
            break;
        case -120:
            result = 1;
            break;
        case -121:
            result = 1;
            break;
    }
    return result;
}
void CMemoryCardManager::FinishForMC() {
    sceMcEnd();
}
void CMemoryCardManager::SetBuff_Album(char *buf) {
    album_buffer = buf;
    if (buf) {
        memset(album_buffer, 0, GetSaveDataSize(MC_SIZE_ALBUM_FILE));
        album_buffer_set = 1;
    }
}
void CMemoryCardManager::SetIconData(MC_ICON_DATA *icon_data, int index) {
    McIconBlock40 bg_colors;
    McIconBlock30 light_dirs;
    McIconBlock30 light_colors;
    McIconBlock10 ambient_color;
    memcpy(&icon[0], &icon_data[0], sizeof(MC_ICON_DATA));
    memcpy(&icon[1], &icon_data[1], sizeof(MC_ICON_DATA));
    memcpy(&icon[2], &icon_data[2], sizeof(MC_ICON_DATA));
    bg_colors = at_1031__6;
    light_dirs = at_1032__7;
    light_colors = at_1033__8;
    ambient_color = at_1034__6;
    memset(&icon_sys, 0, sizeof(sceMcIconSys));
    strcpy(icon_sys.head, at_1036__6);
    CopyMCBrowserName(index, (char *)icon_sys.title_name, &icon_sys.nl_offset);
    icon_sys.trans_rate = 0x60;
    memcpy(icon_sys.bg_color, &bg_colors, 0x10);
    memcpy(icon_sys.light_dir, &light_dirs, 0x10);
    memcpy(icon_sys.light_color, &light_colors, 0x10);
    memcpy(icon_sys.ambient, &ambient_color, 0x10);

    strcpy((char *)&icon_sys.fname_view, (char *)&icon[0]);
    strcpy((char *)&icon_sys.fname_copy, (char *)&icon[1]);
    strcpy((char *)&icon_sys.fname_del, (char *)&icon[2]);
}
int CMemoryCardManager::GetIconDataSize() {
    int blocks = (icon[0].size + 0x3FF) / 0x400 + 1;
    blocks += (icon[1].size + 0x3FF) / 0x400;
    return (icon[2].size + 0x3FF) / 0x400 + blocks;
}
int CMemoryCardManager::GetSaveDataSize(int type) {
    int size;

    size = 0;
    if (type == MC_SIZE_SAVE_TOTAL) {
        size = (GetIconDataSize() + 0x19A) << 0xA;
    }
    if (type == MC_SIZE_SAVE_FILE) {
        size = sizeof(SAVEDATA_FORMAT);
    }
    if (type == MC_SIZE_ALBUM_FILE) {
        size = 0x64CB0;
    }
    if (type == MC_SIZE_ICONS) {
        size = GetIconDataSize() << 0xA;
    }
    if (type == MC_SIZE_ALBUM_TOTAL) {
        size = (GetIconDataSize() << 0xA) + 0x654B0;
    }
    if (type == MC_SIZE_SAVE_KB) {
        size = GetIconDataSize() + 0x199;
    }
    if (type == MC_SIZE_UNK_6) {
        size = 0x20800;
    }
    if (type == MC_SIZE_OMAKE_FILE) {
        size = sizeof(CSubGameData);
    }
    if (type == MC_SIZE_OMAKE_TOTAL) {
        size = (GetIconDataSize() << 0xA) + 0x5C70;
    }
    if (type == MC_SIZE_OMAKE_KB) {
        size = GetIconDataSize() + 0x1B;
    }
    return size;
}
void CMemoryCardManager::SetFuncNo(int operation) {
    func_no = operation;
    step = 0;
    if (operation == MC_FUNC_IDLE) {
        search_wait = 11;
    }
}
int CMemoryCardManager::GetFuncNo() { return this->func_no; }
u_long CMemoryCardManager::CheckMaxUniqueCounter() {
    u64 max = 0;
    for (int i = 0; i < 13; i++) {
        if (max < file_info[i].unique_counter) {
            max = file_info[i].unique_counter;
        }
    }
    return max;
}
int CMemoryCardManager::GetUpdateFile() {
    u64 max = CheckMaxUniqueCounter();
    int found = -1;
    for (int i = 0; i < 13; i++) {
        if (max == file_info[i].unique_counter) {
            found = i;
            break;
        }
    }
    return found;
}
int CMemoryCardManager::CheckDataFileNum() {
    int count = 0;
    for (int i = 0; i < 13; i++) {
        if (file_info[i].state != 0) {
            count++;
        }
    }
    return count;
}
u32 CMemoryCardManager::CheckOmake(unsigned long *outMask) {
    int flags = 0;
    u64 mask = 0;

    for (s64 i = 0; i < 13; i++) {
        if (file_info[(int)i].state == 0) {
            continue;
        }
        flags |= file_info[(int)i].omake_flag;
        mask |= file_info[(int)i].costume_bit;
    }
    if (outMask) {
        *outMask |= mask;
    }
    return flags;
}
int CMemoryCardManager::CheckDebugCode() {
    int code = 0;
    for (int i = 0; i < 13; i++) {
        if (file_info[i].state == 0) {
            continue;
        }
        if (0 < file_info[i].debug_code) {
            code = file_info[i].debug_code;
        }
    }
    return code;
}
void CMemoryCardManager::InitPlayDataInfo() {
    for (int i = 0; i < 13; i++) {
        file_info[i].state = 0;
    }
}
void CMemoryCardManager::UpDateViewInfo(SAVEDATA_INFO *view, SAVEDATA_FORMAT *format) {
    if (view == 0 || format == 0) {
        return;
    }
    view->program_loop_no = format->program_loop_no;
    view->map_no = format->map_no;
    view->dungeon_no = save_buffer->dungeon_no;
    view->floor_id = save_buffer->floor_id;
    view->play_time = format->save_data.play_time;
    view->progress = format->save_data.game_progress;
    view->debug_code = format->debug_code;
    view->omake_flag = format->omake_flag;
    view->costume_bit = format->costume_bit;
    view->unique_counter = format->unique_counter;
    view->fish_num = format->fish_num;
}
int CMemoryCardManager::Step() {
    int status = 0;
    int changed = 0;
    unsigned int job = func_no;
    switch (job) {
        case MC_FUNC_SEARCH_TYPE:
            status = SearchMcType();
            break;
        case MC_FUNC_IDLE:
            search_wait++;
            if (search_wait >= 10) {
                status = SearchMcType();
                search_wait = 0;
            }
            break;
        case MC_FUNC_NONE:
            status = 1;
            break;
        case MC_FUNC_MAKE_DIR:
            status = MakeDir(file_no);
            break;
        case MC_FUNC_GET_ALL_FILE_INFO:
            status = GetAllSaveFileInfo();
            break;
        case MC_FUNC_MAKE_ALBUM_DIR:
            status = MakeDir(-1);
            break;
        case MC_FUNC_SAVE:
            status = SaveToMc(file_no);
            break;
        case MC_FUNC_LOAD:
            status = LoadFromMc(file_no);
            if (status != 0) {
                printf(at_1229__3, step);
            }
            break;
        case MC_FUNC_SAVE_ALBUM:
            status = SaveAlbum();
            break;
        case MC_FUNC_LOAD_ALBUM:
            status = LoadAlbum();
            break;
        case MC_FUNC_CHECK_ALBUM:
            status = CheckAlbum();
            break;
        case MC_FUNC_MAKE_OMAKE_DIR:
            status = MakeDir(-2);
            break;
        case MC_FUNC_FORMAT:
            status = Format();
            break;
        case MC_FUNC_UNFORMAT:
            status = UnFormat();
            break;
        case MC_FUNC_DELETE:
            int delete_index;
            if (error.code == 0) {
                delete_index = file_no;
            } else {
                delete_index = error.file_no;
            }
            status = DeleteFile(delete_index);
            break;
        case MC_FUNC_SAVE_OMAKE:
            status = SaveOamkeFile();
            break;
        case MC_FUNC_LOAD_OMAKE:
            status = LoadOmakeFile();
            break;
        case MC_FUNC_CHECK_OMAKE:
            status = CheckOmakeFile();
            break;
        case MC_FUNC_WRITE_TEST:
            status = Write();
            break;
        case MC_FUNC_CONVERT:
            status = Convert();
            break;
    }
    if (status == 1) {
        step = 0;
        SetFuncNo(MC_FUNC_IDLE);
    } else if (status != 0) {
        McError(status);
    }
    if (job != func_no) {
        changed = 1;
    }
    return changed;
}
char *CMemoryCardManager::GetVersion() {
    return version;
}
int CMemoryCardManager::SearchMcType() {
    int command;
    int result;
    MC_CARD_INFO *card;

    if (port == 0 || (card = NULL, port == 1)) {
        card = &this->card[port];
    }
    if (card == NULL) {
        return 0;
    }
    if (step == 0) {
        old_format_1242 = card->formatted;
    }
    switch (step % 2) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                InitError();
                int status =
                    sceMcGetInfo(port, 1, &card->type, &card->free_size, &card->formatted);
                if (status == 0) {
                    step++;
                } else if (status != -0xC8) {
                    step += 2;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                card->present = 1;
                card->result = result;
                switch (result) {
                    case 0:
                        break;
                    case -1:
                        card->formatted = 1;
                        break;
                    case -2:
                        card->formatted = 0;
                        break;
                    default:
                        if (result < -10) {
                            card->present = 0;
                        }
                        break;
                }
                step++;
                if (step >= 2) {
                    if (card->present != 0) {
                        if (card->formatted != 0) {
                            if (old_format_1242 != 0 && card->formatted != 0) {
                                card->format_change = 0;
                            }
                            if (old_format_1242 == 0) {
                                if (card->formatted != 0) {
                                    card->format_change = 1;
                                }
                            }
                            return 1;
                        }
                    }
                }
                if (step >= 10) {
                    if (old_format_1242 != 0 && card->formatted != 0) {
                        card->format_change = 0;
                    }
                    if (old_format_1242 == 0 && card->formatted == 0) {
                        card->format_change = 0;
                    }
                    if (old_format_1242 == 0 && card->formatted != 0) {
                        card->format_change = 1;
                    }
                    if (old_format_1242 != 0) {
                        if (card->formatted == 0) {
                            card->format_change = -1;
                        }
                    }
                    return 1;
                }
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::Write() {
    int result;
    int command;
    u8 buffer[0x1000];
    int remaining;
    result = 0;
    sceMcChdir(port, 1, at_843__5, 0);
    sceMcSync(0, &command, &result);
    sceMcOpen(port, 1, at_1315__3, 0x202);
    sceMcSync(0, &command, &result);
    fd = result;
    remaining = 0x758000;
    do {
        int chunk = 0x1000;
        if (remaining < 0x1000) {
            chunk = remaining;
        }
        sceMcWrite(fd, buffer, chunk);
        sceMcSync(0, &command, &result);
        remaining -= result;
    } while (remaining > 0);
    sceMcFlush(fd);
    sceMcSync(0, &command, &result);
    sceMcClose(fd);
    sceMcSync(0, &command, &result);
    return 1;
}
int CMemoryCardManager::Convert() {
    return 1;
}
int CMemoryCardManager::MakeDir(int file_no) {
    unsigned char path[0x80];
    char browser_name[0x40];
    char number[0x14];
    u16 nl_offset;
    int result;
    int command;
    MC_CARD_INFO *card;

    result = 0;
    if (init_1324 == 0) {
        iconNo_1323 = -1;
        init_1324 = 1;
    }
    strcpy((char *)path, at_1453__3);
    sprintf((char *)path, (char *)path, file_no);
    if (file_no == -1) {
        strcpy((char *)path, at_852__4);
    }
    if (file_no == -2) {
        strcpy((char *)path, at_1454__3);
    }
    if (port == 0 || port == 1) {
        card = &this->card[port];
    } else {
        card = NULL;
    }
    MC_ERROR_INFO *errors = &error;
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                InitError();
                total_transferred = 0;
                int made = sceMcMkdir(port, 1, path);
                if (made == 0) {
                    step++;
                } else if (made != -200) {
                    errors->code = MC_ERROR_COMMAND;
                    return 1;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0 && command == 0xB) {
                if (result < 0 && result != -4) {
                    McError(result);
                    return 1;
                }
                strcat((char *)path, at_1455__3);
                if (sceMcOpen(port, 1, path, 0x202) == 0) {
                    iconNo_1323 = -1;
                    step++;
                    break;
                }
                return -1;
            }
            break;
        case 2:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    if (result == -2) {
                        card->formatted = 0;
                    }
                    if (result < -10) {
                        card->present = 0;
                    }
                    McError(result);
                    return 1;
                }
                fd = result;
                transferred = 0;
                if (album_buffer_set == 0 && file_no != -2) {
                    nl_offset = 0;
                    SetMenuBigNum2(number, file_no + 1);
                    CopyMCBrowserName(3, browser_name, &nl_offset);
                    sprintf((char *)icon_sys.title_name, browser_name, number);
                    icon_sys.nl_offset = nl_offset;
                }
                transfer_result = 0;
                transfer_size = sizeof(icon_sys);
                write_buffer = (char *)&icon_sys;
                if (sceMcWrite(fd, write_buffer, transfer_size) == 0) {
                    step++;
                    break;
                }
                return -1;
            }
            break;
        case 3:
        case 7:
        case 11:
        case 15:
            if (sceMcSync(1, &command, &transfer_result) != 0) {
                if (transfer_result < 0) {
                    if (transfer_result < -10) {
                        card->present = 0;
                    }
                    McError(transfer_result);
                    return 1;
                }
                transferred += transfer_result;
                total_transferred += transfer_result;
                int done = transferred;
                int total = transfer_size;
                if (done >= total) {
                    transferred = 0;
                    if (sceMcFlush(fd) == 0) {
                        step++;
                        break;
                    }
                    return -1;
                }
                int left = total - done;
                int chunk = 0xC00;
                if (left > 0xC00) {
                    chunk = left;
                }
                sceMcWrite(fd, write_buffer + done, chunk);
            }
            break;
        case 4:
        case 8:
        case 12:
        case 16:
            if (sceMcSync(1, &command, &result) != 0) {
                if (command != 0xA) {
                    errors->code = MC_ERROR_COMMAND;
                    return 1;
                }
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                command = sceMcClose(fd);
                if (command == 0) {
                    step++;
                    break;
                }
                errors->code = MC_ERROR_COMMAND;
                return 1;
            }
            break;
        case 5:
        case 9:
        case 13:
        case 17:
            if (sceMcSync(1, &command, &result) != 0) {
                if (command != 3) {
                    errors->code = MC_ERROR_COMMAND;
                    return 1;
                }
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                iconNo_1323++;
                if (iconNo_1323 < 3) {
                    strcat((char *)path, at_843__5);
                    strcat((char *)path, icon[iconNo_1323].name);
                    command = sceMcOpen(port, 1, path, 0x203);
                    if (command == 0) {
                        step++;
                        break;
                    }
                    return -1;
                }
                return 1;
            }
            break;
        case 6:
        case 10:
        case 14:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    if (result < -10) {
                        card->present = 0;
                    }
                    McError(result);
                    return 1;
                }
                fd = result;
                transferred = 0;
                transfer_size = icon[iconNo_1323].size;
                write_buffer = (char *)icon[iconNo_1323].data;
                command = sceMcWrite(fd, write_buffer, 0xC00);
                if (command == 0) {
                    step++;
                    break;
                }
                return -1;
            }
            break;
    }
    return 0;
}
int GetCostumeList(unsigned long mask, int type, short *list) {
    if (list == NULL) {
        return 0;
    }
    int count = 0;
    short *row = (short *)cosbit_table;
    unsigned long bit = 1;
    for (unsigned long i = 0; i < 0x22; i++) {
        if ((mask & bit) && type == GetItemDataType(*row)) {
            count++;
            *list = *row;
            list++;
        }
        bit <<= 1;
        row += 2;
    }
    *list = -1;
    return count;
}
int CMemoryCardManager::SaveToMc(int file_no) {
    unsigned char path[0x80];
    int result;
    int command;
    MC_CARD_INFO *card;

    MakeMemoryCardFileName(file_no, (char *)path);
    if (port == 0 || port == 1) {
        card = &this->card[port];
    } else {
        card = NULL;
    }
    if (init_1477 == 0) {
        test_write_num_1476 = 0;
        init_1477 = 1;
    }
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                if (card->present == 0 || card->type != 2) {
                    return 1;
                }
                CSaveData *save = GetSaveData();
                transferred = 0;
                total_transferred = 0;
                CSaveDataDungeon *dungeon = &save->save_dungeon;
                CUserDataManager *user_data = &save->user_data;
                strcpy(save_buffer->version, version);
                save_buffer->costume_bit = 0;
                if (save->GetBitFlag(0x31F)) {
                    save_buffer->costume_bit = user_data->GetCostumeBit();
                }
                save_buffer->incomplete = 1;
                save_buffer->omake_flag = 0;
                if (save->GetBitFlag(0x1A8)) {
                    save_buffer->omake_flag |= 1;
                }
                if (save->GetBitFlag(0x31F)) {
                    save_buffer->omake_flag |= 0x80;
                    save_buffer->omake_flag |= 2;
                }
                save_buffer->debug_code = 0;
                save_buffer->unk_1A = 0;
                save_buffer->unk_1C = 0;
                for (int i = 0; i < 11; i++) {
                    save_buffer->unk_4C[i] = 0;
                }
                save_buffer->unk_47 = 0;
                save_buffer->dng_tree_flag = DngTreeSaveFlag;
                save_buffer->unique_counter = CheckMaxUniqueCounter() + 1;
                save_buffer->progress = save->game_progress;
                save_buffer->fish_num = user_data->CountFish();
                save_buffer->program_loop_no = NowProgramLoopNo;
                save_buffer->map_no = save->map_no;
                save_buffer->dungeon_no = dungeon->stage_id;
                save_buffer->floor_id = dungeon->floor_id[dungeon->stage_id];
                printf(at_1581__4, save_buffer->unique_counter);
                memcpy(&save_buffer->save_data, save, sizeof(CSaveData));
                save_buffer->unk_20 = 0;
                save_buffer->unk_24 = 0;
                save_buffer->check_digit_half = MakeCheckDigit(0, (char *)&save_buffer->save_data, 0x32C98);
                save_buffer->check_digit = 0;
                save_buffer->check_digit = MakeCheckDigit(0, (char *)&save_buffer->save_data, sizeof(CSaveData));
                printf(at_1582__4, save_buffer->check_digit, save_buffer->check_digit_half);
                transfer_size = sizeof(SAVEDATA_FORMAT);
                transfer_result = 0;
                write_buffer = (char *)save_buffer;
                if (sceMcOpen(port, 1, path, 0x202) == -200) {
                    sceMcSync(1, NULL, NULL);
                } else {
                    step = 0x64;
                }
            }
            break;
        case 0x64:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                fd = result;
                test_write_num_1476 = 0;
                if (sceMcWrite(fd, write_buffer, 0xC00) == 0) {
                    step++;
                    break;
                }
                return -1;
            }
            break;
        case 0x65:
            if (sceMcSync(1, &command, &transfer_result) == 0) {
                test_write_num_1476++;
                break;
            }
            if (transfer_result < 0) {
                McError(transfer_result);
                return 1;
            }
            transferred += transfer_result;
            total_transferred += transfer_result;
            {
                int done = transferred;
                int total = transfer_size;
                if (done >= total) {
                    if (sceMcFlush(fd) == 0) {
                        step++;
                        break;
                    }
                    return -1;
                }
                int left = total - done;
                int chunk = 0xC00;
                if (left < 0xC00) {
                    chunk = left;
                }
                sceMcWrite(fd, write_buffer + done, chunk);
            }
            break;
        case 0x66:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                sceMcSeek(fd, 0x45, 0);
                sceMcSync(0, NULL, NULL);
                save_buffer->incomplete = 0;
                sceMcWrite(fd, &save_buffer->incomplete, 1);
                step++;
            }
            break;
        case 0x67:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                sceMcClose(fd);
                step++;
            }
            break;
        case 0x68:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                step++;
            }
            break;
        case 0x69: {
            SAVEDATA_INFO *info = &file_info[file_no];
            if (info != NULL) {
                info->state = 1;
                info->file_no = file_no;
                UpDateViewInfo(info, save_buffer);
            }
            return 1;
        }
    }
    return 0;
}
int CMemoryCardManager::LoadFromMc(int file_no) {
    unsigned char path[0x80];
    int result;
    int command;
    MC_CARD_INFO *card;

    if (port == 0 || port == 1) {
        card = &this->card[port];
    } else {
        card = NULL;
    }
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                if (card->present == 0 || card->type != 2) {
                    return 1;
                }
                InitError();
                transfer_size = sizeof(SAVEDATA_FORMAT);
                memset(save_buffer, 0, transfer_size);
                transfer_result = 0;
                transferred = 0;
                total_transferred = 0;
                read_buffer = (char *)save_buffer;
                MakeMemoryCardFileName(file_no, (char *)path);
                int opened = sceMcOpen(port, 1, path, 1);
                step++;
                if (opened != 0 && opened != -200) {
                    error.code = MC_ERROR_COMMAND;
                    return 1;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                fd = result;
                if (sceMcRead(fd, read_buffer, 0x1000) == 0) {
                    step++;
                    break;
                }
                error.code = MC_ERROR_LOAD;
                return 1;
            }
            break;
        case 2:
            if (sceMcSync(1, &command, &transfer_result) != 0) {
                if (transfer_result < 0) {
                    McError(transfer_result);
                    error.code = MC_ERROR_LOAD;
                    return 1;
                }
                transferred += transfer_result;
                total_transferred += transfer_result;
                if (transferred >= transfer_size || transfer_result == 0) {
                    if (sceMcClose(fd) == 0) {
                        step++;
                        break;
                    }
                    error.code = MC_ERROR_LOAD;
                    return 1;
                }
                sceMcRead(fd, read_buffer + transferred, 0x1000);
            }
            break;
        case 3:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                int bad = 0;
                int short_read = 0;
                if (transferred != transfer_size) {
                    bad = 1;
                    short_read = bad;
                }
                int old_version = 0;
                if (strcmp(save_buffer->version, GetVersion()) == 0) {
                    int saved_digit = save_buffer->check_digit;
                    int digit = MakeCheckDigit(0, (char *)&save_buffer->save_data, sizeof(CSaveData));
                    if (saved_digit != 0 && digit != saved_digit) {
                        bad = 1;
                    }
                    int saved_digit_half = save_buffer->check_digit_half;
                    int digit_half = MakeCheckDigit(0, (char *)&save_buffer->save_data, 0x32C98);
                    if (saved_digit_half != 0 && digit_half != saved_digit_half) {
                        bad = 1;
                    }
                } else {
                    bad = 1;
                    if (short_read == 0) {
                        if (strcmp(save_buffer->version, at_1679__2) == 0) {
                            old_version = bad;
                            bad = 0;
                        }
                    }
                    printf(at_1680__2);
                }
                if (bad == 0) {
                    CSaveData *save = GetSaveData();
                    memcpy(save, &save_buffer->save_data, sizeof(CSaveData));
                    load_program_loop_no = save_buffer->program_loop_no;
                    load_map_no = save_buffer->map_no;
                    load_dungeon_no = save_buffer->dungeon_no;
                    load_floor_id = save_buffer->floor_id;
                    load_dng_tree_flag = save_buffer->dng_tree_flag;
                    if (old_version) {
                        TranslateInventUserData(save_buffer->save_data.GetUserDataManager()->GetInventUserData(),
                                                save->GetUserDataManager()->GetInventUserData());
                    }
                    SAVE_TOUR_INFO *tour = &save->tour;
                    if (tour != NULL) {
                        if (tour->base_day <= 0 && save->GetBitFlag(0x158)) {
                            tour->base_day = 7;
                        }
                    }
                } else {
                    error.code = MC_ERROR_LOAD;
                    printf(at_1681);
                    return 1;
                }
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::SaveAlbum() {
    unsigned char album_name[0x80];
    int command;
    int result;
    MC_CARD_INFO *card;

    if (port == 0 || port == 1) {
        card = &this->card[port];
    } else {
        card = NULL;
    }
    MC_ERROR_INFO *errors = &error;
    int *album_found = &file_exists;
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                InitError();
                transfer_size = GetSaveDataSize(2);
                transfer_result = 0;
                transferred = 0;
                total_transferred = 0;
                AlbumFile *album = (AlbumFile *)album_buffer;
                album->checksum = MakeCheckDigit(0, album->digit_data, sizeof(album->digit_data));
                album->trailer = MakeCheckDigit(0, album->digit_data, sizeof(album->digit_data));
                write_buffer = album_buffer;
                MakeMemoryCardAlbumName((char *)album_name, 1);
                int opened = sceMcOpen(port, 1, album_name, 0x202);
                step++;
                if (opened != 0) {
                    return -1;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    if (result == -4) {
                        *album_found = 0;
                    } else if (result == -2) {
                        card->formatted = 0;
                    }
                    McError(result);
                    return 1;
                }
                fd = result;
                if (sceMcWrite(fd, write_buffer, 0xC00) == 0) {
                    step++;
                    break;
                }
                errors->code = 0xB;
                return 1;
            }
            break;
        case 2:
            if (sceMcSync(1, &command, &transfer_result) != 0) {
                int written = transfer_result;
                if (written < 0) {
                    if (written == -4) {
                        *album_found = 0;
                    }
                    if (transfer_result == -2) {
                        card->formatted = 0;
                    }
                    McError(transfer_result);
                    return 1;
                }
                transferred += written;
                total_transferred += transfer_result;
                int done = this->transferred;
                int total = transfer_size;
                int chunk;
                int left;

                if (done < total) {
                    goto write;
                }
                if (sceMcClose(fd) == 0) {
                    step++;
                    break;
                }
                return -1;
            write:
                left = total - done;
                chunk = 0xC00;
                if (left < 0xC00) {
                    chunk = left;
                }
                sceMcWrite(fd, write_buffer + done, chunk);
            }
            break;
        case 3:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                step = 4;
            }
            break;
        case 4:
            return 1;
        case 100:
            break;
    }
    return 0;
}
int CMemoryCardManager::LoadAlbum() {
    char album_name[0x80];
    int command;
    int result;
    MC_ERROR_INFO *errors = &error;

    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                InitError();
                transfer_size = GetSaveDataSize(2);
                memset(album_buffer, 0, transfer_size);
                transfer_result = 0;
                transferred = 0;
                total_transferred = 0;
                read_buffer = album_buffer;
                MakeMemoryCardAlbumName(album_name, 1);
                int opened = sceMcOpen(port, 1, (const unsigned char *)album_name, 1);
                step++;
                if (opened != 0) {
                    return -1;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                fd = result;
                if (sceMcRead(fd, read_buffer, 0x1000) == 0) {
                    step++;
                    break;
                }
                return 1;
            }
            break;
        case 2:
            if (sceMcSync(1, &command, &transfer_result) != 0) {
                int transferred = transfer_result;
                if (transferred <= 0) {
                    McError(transferred);
                    if (this->transferred < transfer_size) {
                        errors->code = 3;
                        return 1;
                    }
                    return 1;
                }
                this->transferred += transferred;
                total_transferred += transfer_result;
                int done = this->transferred;
                int total = transfer_size;
                int chunk;
                int left;

                if (done < total) {
                    goto read;
                }
                if (sceMcClose(fd) == 0) {
                    step++;
                    break;
                }
                errors->code = 3;
                return 1;
            read:
                left = total - done;
                chunk = 0x1000;
                if (left < 0x1000) {
                    chunk = left;
                }
                sceMcRead(fd, read_buffer + done, chunk);
            }
            break;
        case 3:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                if (this->transferred < transfer_size) {
                    errors->code = 3;
                }
                AlbumFile *album = (AlbumFile *)album_buffer;
                int stored_digit = album->checksum;
                if (stored_digit == 0) {
                    if (album->trailer != 0) {
                        goto verify;
                    }
                } else {
                verify:
                    if (stored_digit !=
                        MakeCheckDigit(0, album->digit_data, sizeof(album->digit_data))) {
                        errors->code = 3;
                    }
                }
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::CheckAlbum() {
    char album_name[0x80];
    int command;
    int result;
    int *album_found = &file_exists;
    MC_ERROR_INFO *error_record = &error;
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                InitSaveFileInfoTable();
                MakeMemoryCardAlbumName(album_name, 1);
                int status = sceMcGetDir(port, 1, album_name, 0, 0x11, dir_table);
                *album_found = 0;
                if (status == 0) {
                    step = 1;
                } else {
                    error_record->code = 0;
                    return 1;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                dir_entries = 0;
                *album_found = 0;
                if (result >= 0) {
                    error_record->code = 0;
                    if (result > 0) {
                        *album_found = 1;
                    }
                    dir_entries = result;
                    unsigned int file_size = dir_table[0].file_size;
                    if (file_size < GetSaveDataSize(2)) {
                        error_record->code = 3;
                        *album_found = 0;
                    }
                    strlen(dir_table[0].name);
                    return 1;
                }
                McError(result);
                if (result == -2) {
                    error_record->code = 7;
                } else if (result == -4) {
                    error_record->code = 0;
                    *album_found = 0;
                    dir_entries = result;
                    return 1;
                }
                error_record->func_no = GetFuncNo();
                error_record->step = step;
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::SaveOamkeFile() {
    unsigned char path[0x80];
    int result;
    int command;
    MC_CARD_INFO *card;

    result = 0;
    if (port == 0 || port == 1) {
        card = &this->card[port];
    } else {
        card = NULL;
    }
    MC_ERROR_INFO *errors = &error;
    switch (step) {
        case 0: {
            int synced = sceMcSync(1, NULL, NULL);
            if (McCheckMCPs2(card) == 0) {
                return 1;
            }
            if (synced != 0) {
                InitError();
                strcpy((char *)path, at_1953);
                strcat((char *)path, icon[2].name);
                if (sceMcOpen(port, 1, path, 1) == 0) {
                    step++;
                    break;
                }
                return 1;
            }
            break;
        }
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                if (0 > result) {
                    McError(result);
                    if (result == -4) {
                        errors->code = MC_ERROR_FILE;
                    }
                    return 1;
                } else {
                    read_buffer = SubGameOmakeTempBuffer;
                    transfer_result = 0;
                    transferred = 0;
                    total_transferred = 0;
                    fd = result;
                    sceMcRead(fd, read_buffer, icon[2].size);
                    step++;
                }
            }
            break;
        case 2:
            if (McCheckMCPs2(card) == 0) {
                return 1;
            }
            if (sceMcSync(1, &command, &transfer_result) != 0) {
                if (transfer_result < 0) {
                    McError(transfer_result);
                    return -1;
                }
                if (transfer_result != icon[2].size) {
                    errors->code = MC_ERROR_FILE;
                    McError(result);
                    return -1;
                }
                if (sceMcClose(fd) == 0) {
                    step = 0xA;
                    break;
                }
                return -1;
            }
            break;
        case 0xA:
            if (sceMcSync(1, &command, &result) != 0) {
                CSubGameData *sub_game = GetSubGameSaveData();
                if (sub_game == NULL) {
                    return 1;
                }
                transferred = 0;
                total_transferred = 0;
                sub_game->incomplete = 1;
                transfer_size = GetSaveDataSize(MC_SIZE_OMAKE_FILE);
                transfer_result = 0;
                transferred = 0;
                total_transferred = 0;
                write_buffer = (char *)sub_game;
                sceMcOpen(port, 1, at_1954, 0x202);
                step = 0x64;
            }
            break;
        case 0x64:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                fd = result;
                if (sceMcWrite(fd, write_buffer, 0xC00) == 0) {
                    step = 0x6E;
                    break;
                }
                return -1;
            }
            break;
        case 0x6E:
            if (sceMcSync(1, &command, &transfer_result) != 0) {
                if (transfer_result < 0) {
                    McError(transfer_result);
                    return 1;
                }
                transferred += transfer_result;
                total_transferred += transfer_result;
                int done = transferred;
                int total = transfer_size;
                if (done >= total) {
                    if (sceMcFlush(fd) == 0) {
                        step++;
                        break;
                    }
                    return -1;
                }
                int left = total - done;
                int chunk = 0xC00;
                if (left < 0xC00) {
                    chunk = left;
                }
                sceMcWrite(fd, write_buffer + done, chunk);
            }
            break;
        case 0x6F:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                sceMcSeek(fd, 0, 0);
                sceMcSync(0, NULL, NULL);
                CSubGameData *sub_game = GetSubGameSaveData();
                sub_game->incomplete = 0;
                sceMcWrite(fd, sub_game, 1);
                step++;
            }
            break;
        case 0x70:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                sceMcClose(fd);
                step++;
            }
            break;
        case 0x71:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                }
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::LoadOmakeFile() {
    int result;
    int command;
    MC_CARD_INFO *card;

    if (port == 0 || (card = NULL, port == 1)) {
        card = &this->card[port];
    }
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                if (McCheckMCPs2(card) == 0) {
                    return 1;
                }
                InitError();
                CSubGameData *sub_game = GetSubGameSaveData();
                if (sub_game == NULL) {
                    return 1;
                }
                sub_game->Initialize();
                transfer_size = 0x5470;
                memset(sub_game, 0, transfer_size);
                transfer_result = 0;
                transferred = 0;
                total_transferred = 0;
                read_buffer = (char *)sub_game;
                int opened = sceMcOpen(port, 1, at_1954, 1);
                step++;
                if (opened != 0 && opened != -0xC8) {
                    error.code = 0xB;
                    return 1;
                }
            }
            break;
        case 1:
            if (sceMcSync(0, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                fd = result;
                if (sceMcRead(fd, read_buffer, 0x1000) == 0) {
                    step++;
                    break;
                }
                error.code = 2;
                return 1;
            }
            break;
        case 2:
            if (sceMcSync(1, &command, &transfer_result) != 0) {
                int transferred = transfer_result;
                if (transferred < 0) {
                    McError(transferred);
                    error.code = 2;
                    return 1;
                }
                this->transferred += transferred;
                total_transferred += transfer_result;
                int done = this->transferred;
                if (done >= transfer_size) {
                    if (sceMcClose(fd) == 0) {
                        step++;
                        break;
                    }
                    error.code = 2;
                    return 1;
                }
                sceMcRead(fd, read_buffer + done, 0x1000);
            }
            break;
        case 3:
            if (sceMcSync(0, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                int incomplete = 0;
                if (transferred != transfer_size) {
                    incomplete = 1;
                }
                if (incomplete != 0) {
                    error.code = 2;
                    return 1;
                }
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::CheckOmakeFile() {
    int command;
    int result;
    int *album_found = &file_exists;
    MC_ERROR_INFO *error_record = &error;

    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                InitSaveFileInfoTable();
                *album_found = 0;
                if (sceMcGetDir(port, 1, at_2083__2, 0, 0xD, dir_table) == 0) {
                    step = 1;
                } else {
                    error_record->code = 0;
                    return 1;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                dir_entries = 0;
                if (result >= 7) {
                    error_record->code = 0;
                    *album_found = 1;
                    album_found[1] = 0;
                    dir_entries = result;
                    unsigned int file_size = dir_table[6].file_size;
                    if (file_size < GetSaveDataSize(7)) {
                        error_record->code = 3;
                        *album_found = 0;
                    }
                    for (int i = 0; i < result; i++) {
                        strlen(dir_table[i].name);
                    }
                    step = 2;
                    sceMcOpen(port, 1, at_1954, 1);
                    break;
                }
                if (result < 0) {
                    McError(result);
                    if (result == -2) {
                        error_record->code = 7;
                    } else if (result == -4) {
                        error_record->code = 0;
                        dir_entries = result;
                        return 1;
                    }
                    error_record->func_no = GetFuncNo();
                    error_record->step = step;
                    return 1;
                }
                error_record->code = 6;
                *album_found = 2;
                return 1;
            }
            break;
        case 2:
            if (sceMcSync(1, &command, &result) != 0) {
                if (0 > result) {
                    McError(result);
                    return 1;
                }
                fd = result;
                sceMcRead(fd, work_buffer, 0x100);
                if (sceMcSync(0, &command, &result) != 0) {
                    if (0 > result) {
                        McError(result);
                        return 1;
                    }
                    sceMcClose(fd);
                    step++;
                }
            }
            break;
        case 3:
            if (sceMcSync(1, &command, &result) != 0) {
                if (0 > result) {
                    McError(result);
                    return 1;
                }
                CSubGameData sub_game;
                memcpy(&sub_game, work_buffer, 0x100);
                if (album_found != NULL) {
                    album_found[1] = sub_game.play_enable;
                }
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::Format() {
    int command;
    int result;
    MC_CARD_INFO *record;
    MC_ERROR_INFO *error_record;
    int current_port = port;
    if (current_port == 0 || (record = NULL, current_port == 1)) {
        record = &card[current_port];
    }
    error_record = &error;
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                if (sceMcFormat(port, 1) == 0) {
                    step += 1;
                } else {
                    error_record->code = 11;
                    return 1;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return 1;
                }
                step += 1;
            }
            break;
        case 2:
            if (sceMcGetInfo(port, 1, &record->type, &record->free_size, &record->formatted) ==
                0) {
                step += 1;
            } else {
                error_record->code = 11;
                return 1;
            }
            break;
        case 3:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    if (result < -9) {
                        record->present = 0;
                    }
                    return 1;
                }
                record->present = 1;
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::DeleteFile(int index) {
    int result;
    int command;
    McFileName name;
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                name = at_2131__3;
                sprintf(name.text, name.text, index);
                if (sceMcDelete(port, 1, name.text) == 0) {
                    step += 1;
                } else {
                    sceMcSync(1, NULL, NULL);
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0 && command == 0xF) {
                if (result < 0) {
                    error.retry_count += 1;
                    if (error.retry_count > 0x78) {
                        return 1;
                    }
                    break;
                }
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::McError(int code) {
    MC_CARD_INFO *record;
    MC_ERROR_INFO *error_record = &error;
    if (port == 0 || (record = NULL, port == 1)) {
        record = &card[port];
    }
    switch (code) {
        case -2:
        case -12:
            error_record->code = 7;
            record->formatted = 0;
            break;
        case -3:
            error_record->code = 4;
            break;
        case -4:
        case -5:
            break;
        case -8:
            break;
    }
    if (code < -10) {
        error_record->code = 8;
        record->present = 0;
        if (func_no == MC_FUNC_SAVE) {
            error_record->code = 6;
        }
    }
    if (code < 0) {
        error_record->func_no = GetFuncNo();
        error_record->step = step;
        error_record->file_no = file_no;
    }
    return 1;
}
int CMemoryCardManager::UnFormat() {
    int status;
    int command;
    int result;
    switch (step) {
        case 0:
            status = sceMcUnformat(port, 1);
            if (status == 0) {
                step += 1;
            } else {
                sceMcSync(1, &status, &result);
            }
            break;
        case 1:
            status = sceMcSync(1, &command, &result);
            if (status != 0 && command == 0x11 && result >= 0) {
                card[port].formatted = 0;
                return 1;
            }
            break;
    }
    return 0;
}
int CMemoryCardManager::GetSaveFileInfoFromMc(int index, int *step) {
    char save_name[0x20];
    char file_name[0x80];
    int command;
    int result;
    SAVEDATA_INFO *slot = &file_info[index];

    int phase = *step;
    switch (phase % 4) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                memset(slot, 0, sizeof(SAVEDATA_INFO));
                sprintf(save_name, at_922__4, index);
                if (GetOpenAttribute(save_name) == 0) {
                    *step += 4;
                    return -1;
                }
                MakeMemoryCardFileName(index, file_name);
                if (sceMcOpen(port, 1, (const unsigned char *)file_name, 1) == 0) {
                    *step += 1;
                    break;
                }
                *step += 4;
                return 1;
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    *step += 3;
                    return 1;
                }
                fd = result;
                transferred = 0;
                transfer_result = 0;
                transfer_size = 0x2800;
                error.retry_count = 0;
                memset(save_buffer, 0, transfer_size);
                if (sceMcRead(fd, save_buffer, transfer_size) == 0) {
                    *step += 1;
                    break;
                }
                McError(result);
                *step += 3;
                return 1;
            }
            break;
        case 2:
            if (sceMcSync(1, &command, &transfer_result) != 0) {
                int transferred = transfer_result;
                if (transferred < 0) {
                    McError(transferred);
                    *step += 2;
                    return 1;
                }
                this->transferred += transferred;
                total_transferred += transfer_result;
                if (this->transferred < transfer_size) {
                    if (sceMcClose(fd) == 0) {
                        *step += 1;
                    } else {
                        *step += 2;
                        return -1;
                    }
                }
                if (this->transferred >= transfer_size) {
                    if (sceMcClose(fd) == 0) {
                        *step += 1;
                        break;
                    }
                    *step += 2;
                    return -1;
                }
            }
            break;
        case 3:
            if (sceMcSync(1, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    *step += 1;
                    return -1;
                }
                MC_ERROR_INFO *error_record = &error;
                if (this->transferred < transfer_size) {
                    slot->state = 0;
                    error_record->code = 3;
                    error_record->file_no = file_no;
                    *step += 1;
                    return -1;
                }
                int broken = 0;
                if (strcmp((char *)save_buffer, at_924__4) != 0) {
                    broken = 1;
                }
                if (broken != 0) {
                    printf(at_2285);
                }
                if ((s8)((SAVEDATA_FORMAT *)save_buffer)->incomplete != 0) {
                    broken = 1;
                }
                if (slot != NULL) {
                    slot->state = 0;
                    if (broken == 0) {
                        slot->state = 1;
                        slot->file_no = index;
                        UpDateViewInfo(slot, (SAVEDATA_FORMAT *)save_buffer);
                    }
                }
                *step += 1;
                return 1;
            }
            break;
    }
    return 0;
}
#ifdef NONMATCHING
int CMemoryCardManager::GetAllSaveFileInfo() {
    McSaveDirPattern pattern;
    int result;
    int command;
    int sub_step;

    result = 0;
    if (init_2291 == 0) {
        ReadFileNo_2290 = 0;
        init_2291 = 1;
    }
    switch (step) {
        case 0:
            if (sceMcSync(1, NULL, NULL) != 0) {
                InitSaveFileInfoTable();
                total_transferred = 0;
                pattern = at_2297;
                if (sceMcGetDir(port, 1, pattern.text, 0, 0x11, dir_table) == 0) {
                    step++;
                }
            }
            break;
        case 1:
            if (sceMcSync(1, &command, &result) != 0) {
                if (command != 0xD) {
                    McError(result);
                    return 1;
                }
                ReadFileNo_2290 = 0;
                dir_entries = 0;
                if (result >= 0) {
                    dir_entries = result;
                    for (int i = 0; i < 13; i++) {
                        strlen(dir_table[i].name);
                    }
                    step++;
                    break;
                }
                MC_ERROR_INFO *errors = &error;
                if (result == -2) {
                    errors->code = MC_ERROR_UNFORMATTED;
                }
                errors->func_no = GetFuncNo();
                errors->step = step;
                return -1;
            }
            break;
        default:
            sub_step = step - 2;
            int finished = GetSaveFileInfoFromMc(ReadFileNo_2290, &sub_step);
            step = sub_step + 2;
            if (finished != 0) {
                ReadFileNo_2290++;
            }
            if (ReadFileNo_2290 >= 13) {
                for (int i = 0; i < 13; i++) {
                }
                return 1;
            }
            break;
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/memcard", GetAllSaveFileInfo__18CMemoryCardManagerFv);
#endif
int McCheckMCPs2(MC_CARD_INFO *info) {
    if (info == NULL) {
        return 0;
    }
    if (info->present == 0 || info->type != 2) {
        return 0;
    }
    return 1;
}
int McCheckMCPs2Boot(MC_CARD_INFO *info, int blocks_needed) {
    if (info == NULL) {
        return 0;
    }
    if (info->present == 0 || info->type != 2) {
        return 0;
    }
    if (info->formatted != 0 && info->free_size <= blocks_needed) {
        return 0;
    }
    return 1;
}
COSBIT_INFO *GetCosInfo(int costume_no) {
    short *row = (short *)cosbit_table;
    for (int i = 0; i < 0x22; i++) {
        if (*row == costume_no) {
            return (COSBIT_INFO *)row;
        }
        row += 2;
    }
    return NULL;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", cosbit_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", MCBrowsetName__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", MCBrowserName_Offset__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_838__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_839__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1031__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1032__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1033__8__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1034__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_2131__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_2297__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_808__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_809__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_810__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_811__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_812__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_813__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_814__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_815__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_816__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_817__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_818__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_819__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_843__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_852__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_922__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_923__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_924__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1036__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1229__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1230__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1315__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1453__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1454__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1455__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1456__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1581__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1582__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1679__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1680__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1681__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1953__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_1954__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_2083__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", at_2285__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/memcard", NowProgramLoopNo__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(DngTreeSaveFlag, 0x4);
INCLUDE_BSS(old_format_1242, 0x4);
INCLUDE_BSS(iconNo_1323, 0x4);
INCLUDE_BSS(init_1324, 0x4);
INCLUDE_BSS(test_write_num_1476, 0x4);
INCLUDE_BSS(init_1477, 0x4);
INCLUDE_BSS(SubGameOmakeTempBuffer, 0x4);
INCLUDE_BSS(ReadFileNo_2290, 0x4);
INCLUDE_BSS(init_2291, 0x4);
