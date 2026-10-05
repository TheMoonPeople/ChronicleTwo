#include "common.h"
#include "savedata.hpp"
#include "subgame.hpp"
#include "scenesnd.hpp"
#include "gamedata.hpp"
#include "editdata.hpp"
#include "gamepad.hpp"
#include "mapselect.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "npccfg.hpp"
#include "scriptinterpreter.hpp"
#include "visualmotion.hpp"
#include "vlgr_info.hpp"
#include "water.hpp"
#include "dataread.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "helpmes.hpp"
#include "nowload.hpp"
#include "snd_mngr.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"
#include "mainloop.hpp"
#include <cstring>
#include <cstdio>

void LoadFilePictureName();
s16 get_gajji_id_from_monster_progress_table(int monster_no, int *level);
int GetMonsterProgressTableNo(int level, int monster_no);

extern CFont Font;
extern mgCMemory MainBuffer;
extern int menu_mode;
void InitEventSelect();

extern INIT_LOOP_ARG SelectArg;

extern CSaveData *ActiveSaveData;
extern int CaptureMode;
extern int LoopNo;
extern int PlayTimeCountFlag;
extern CSubGameData *SubGameSaveData;
extern int event_view;
extern int future_sel;
extern int hdd_sel;
extern CScene MainScene;
extern INIT_LOOP_ARG InitArg;
extern mgCMemory InfoStack;
extern "C" int InitPadTable__Fi(int);

extern mgCMemory MenuBuffer;
extern mgCMemory buf0_1224;
extern mgCMemory buf1_1227;
extern mgCMemory dbuf0_1230;
extern mgCMemory dbuf1_1233;
extern s8 init_1225;
extern s8 init_1228;
extern s8 init_1231;
extern s8 init_1234;
extern mgCTexture *FontTex;
extern u32 FontDataAdr;
extern char at_1654[];
extern char at_1655[];
extern char at_1656[];
extern u8 font_buff[];
extern char at_1657[];
extern char at_1296[];
extern char at_1856[];

extern SPI_TAG_PARAM tag__3[];
extern char at_2082[];
extern char at_2083[];
extern char at_2084[];
extern char at_2085[];

// Code (.text)
CFont *GetDebugFont(void) {
    return &Font;
}
int GetCaptureMode(void) {
    return CaptureMode;
}
s32 GetSystemSndID(void) {
    return SystemSND_ID;
}
CScene *GetMainScene(void) {
    return &MainScene;
}
CSaveData *GetSaveData(void) {
    return ActiveSaveData;
}
CSubGameData *GetSubGameSaveData(void) {
    return SubGameSaveData;
}
void InitSaveData(void) {
    GetSaveData()->Initialize();
}
int GetVramTopAddress(void) {
    return mgGetTopVRAMAddress() + 0x20;
}
mgCMemory *GetMainStack(void) {
    return &MainBuffer;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", NextLoop__Fi13INIT_LOOP_ARG);
int GetNowLoopNo(void) {
    return LoopNo;
}
INIT_LOOP_ARG *GetNowInitArg(void) {
    return &InitArg;
}
void cat_start() {}
void cat_end() {}
void SetTextureTable(int table_size, int table_count, mgCMemory *memory) {
    mgTexManager.SetTableBuffer(table_count, table_size, memory);
    mgTexManager.Initialize(GetVramTopAddress(), -1);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", InitPadTable__Fi);
extern "C" void VSyncCallBack__Fi__3(int unused) {
    if (PlayTimeCountFlag != 0) {
        GetSaveData()->play_time += 1;
    }
}
void PlayTimeCount(int value) {
    PlayTimeCountFlag = value;
}
int GetPlayTimeCountFlag(void) {
    return PlayTimeCountFlag;
}
void LanguageChange(int language, u_long128 *buffer) {
    LanguageCode = language;
    GameItemDataManage.LoadItemSystemMes(language);
    LoadHelpMes(read_buffer);
    LoadMapName(LanguageCode, read_buffer);
    LanguageEquipChange();
    LoadNPCCfg();
    LoadSystemMes();
    LoadFontTex2Img();
    LoadGaijiImg();
    LoadFontTexture();
    LoadFontTblBin();
    LoadEditAnalyzeData(LanguageCode, (u_long128 *)read_buffer);
    LoadFilePictureName();
    LoadMonsterLanguage(LanguageCode);
    InfoStack.stack_used = 0;
    InfoStack.lock = 0;
    LoadGameInfo(&InfoStack);
    InitPauseData();
    InitPadTable__Fi(LanguageCode);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", MainLoop__Fv);
void MenuInit(INIT_LOOP_ARG arg) {
    mgCMemory *main_stack;
    u_long128 *packet_a;
    u_long128 *packet_b;

    sndSeAllStop(-1);
    sndDeletePort(0);
    MainScene.InitBGM();
    MainScene.InitSeEnv();
    MainScene.InitSeSrc();
    menu_mode = 0;
    mgInitFont();
    main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;
    if (init_1225 == 0) {
        buf0_1224.Init();
        init_1225 = 1;
    }
    if (init_1228 == 0) {
        buf1_1227.Init();
        init_1228 = 1;
    }
    if (init_1231 == 0) {
        dbuf0_1230.Init();
        init_1231 = 1;
    }
    if (init_1234 == 0) {
        dbuf1_1233.Init();
        init_1234 = 1;
    }
    packet_a = main_stack->stAlloc64(0x2710);
    packet_b = main_stack->stAlloc64(0x2710);
    mgInitVif1Packet(packet_a, packet_b, 0x27100);
    buf0_1224.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x2710), 0x2710);
    buf1_1227.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x2710), 0x2710);
    dbuf0_1230.stSetBuffer((u_long128 *)main_stack->stAlloc64(0xC350), 0xC350);
    dbuf1_1233.stSetBuffer((u_long128 *)main_stack->stAlloc64(0xC350), 0xC350);
    MenuBuffer.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x7A120), 0x7A120);
    read_buffer = (u_long128 *)main_stack->stAlloc64(0x186A0);
    mgSetPacketBuffer(&buf0_1224, &buf1_1227);
    mgSetDataBuffer(&dbuf0_1230, &dbuf1_1233, 1);
    GamePad__2.SetAutoRepeat(0xF000, 0xF, 4);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 0.0f);
    SetTextureTable(0x64, 0x14, &MenuBuffer);
    if (DebugFlag == 0) {
        InitEventSelect();
    }
    mgTexManager.DeleteBlock(1);
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 1, NULL, NULL);
    ReLoadFontTexture(1);
    mgTexManager.EnterIMGFile(GetFontTex2ImgPtr(), 1, NULL, NULL);
    LoadEventViewData(read_buffer, &MenuBuffer);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", MenuLoop__Fv);
void MenuExit(void) {
    GamePad__2.AutoRepeatOff();
    mgCloseFont();
}
void InitEventSelect(void) {
    event_view = 0;
    future_sel = 0;
    menu_mode = 2;
    hdd_sel = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", EventSelect__Fv);
mgCTexture *GetFontTexture(int page) {
    if ((page < 0) || (page > 0)) {
        return 0;
    }
    return *(&FontTex + page);
}
void LoadFontTexture(void) {
    u8 scratch[0x35000];
    char path[0x40];
    char file_name[0x20];
    int size;
    u8 *buffer;
    int page;
    u32 misalign;

    buffer = scratch;
    FontTex = 0;
    misalign = (u32)buffer & 3;
    FontDataAdr = 0;
    if (misalign != 0) {
        buffer += (4 - misalign) * 0x10;
    }
    page = 0;
    do {
        if (LanguageCode == 0) {
            sprintf(file_name, at_1654, page);
        } else if (LanguageCode == 1) {
            if (page == 0) {
                sprintf(file_name, at_1655, page);
            }
        } else if (page == 0) {
            sprintf(file_name, at_1656);
        }
        sprintf(path, at_1657, file_name);
        if (LoadFile2(path, buffer, &size, 0) != 0) {
            (&FontDataAdr)[page] = (u32)font_buff;
            if ((&FontDataAdr)[page] == 0) {
                return;
            }
            memcpy((void *)(&FontDataAdr)[page], buffer, size);
        }
        page += 1;
    } while (page <= 0);
}
void ReLoadFontTexture(int texture_no) {
    char file_name[0x20];
    int page;
    int offset;
    TM2_head **font_data;

    offset = 0;
    page = 0;
    do {
        font_data = (TM2_head **)((u8 *)&FontDataAdr + offset);
        if (*font_data != NULL) {
            if (LanguageCode == 0) {
                sprintf(file_name, at_1654, page);
            } else if (LanguageCode == 1) {
                if (page == 0) {
                    sprintf(file_name, at_1655, page);
                }
            } else if (page == 0) {
                sprintf(file_name, at_1656);
            }
            if (&mgTexManager == NULL) {
                return;
            }
            *(mgCTexture **)((u8 *)&FontTex + offset) = mgTexManager.EnterTexture(texture_no, file_name, *font_data, 0, 0);
        }
        page += 1;
        offset += 4;
    } while (page <= 0);
}
void demQuit() {}
void demoQuitTimeOut() {}
void demoAttractInterrupted() {}
void demoAttractComplete() {}
void FadeOutForE3() {}
int TimeLimitCheck() { return 0; }
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", InitPauseMenu__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", PauseMenu__Fv);
void LoadGameConfig(char *path) {
    u8 script[0x4000];
    CScriptInterpreter interpreter;
    int size;

    if (path == NULL) {
        SetCurrentDir(at_1296);
        if (LoadFile2(at_1856, script, &size, 0) == 0) {
            SetCurrentDir(NULL);
            return;
        }
        SetCurrentDir(NULL);
        goto run;
    }
    if (LoadFile2(path, script, &size, 0) != 0) {
    run:

        interpreter.SetTag(tag__3);
        interpreter.SetScript((char *)script, size);
        interpreter.Run();
    }
}
int gcMAP_NO(SPI_STACK *stack, int arg) {
    int map_no;
    if (stack->type == 0) {
        map_no = SearchMapNo(spiGetStackString(stack));
    } else {
        map_no = spiGetStackInt(stack);
    }
    SelectArg.map_no = map_no;
    return 1;
}
int gcPROGRESS(SPI_STACK *stack, int arg) {
    int value = spiGetStackInt(stack);
    CSaveData *save = GetSaveData();
    save->game_progress = value;
    return 0;
}
int gcBIT_FLAG_ON(SPI_STACK *stack, int count) {
    CSaveData *save_data;
    int i;

    for (i = 0; i < count; i++) {
        save_data = GetSaveData();
        save_data->SetBitFlag(spiGetStackInt(stack++), 1);
    }
    return 0;
}
int gcBIT_FLAG_OFF(SPI_STACK *stack, int count) {
    CSaveData *save_data;
    int i;

    for (i = 0; i < count; i++) {
        save_data = GetSaveData();
        save_data->SetBitFlag(spiGetStackInt(stack++), 0);
    }
    return 0;
}
int gcSTART_EVENT(SPI_STACK *stack, int arg_count) {
    DefStartEventNo = spiGetStackInt(stack);
    return 0;
}
int gcGEO_COMPLETE(SPI_STACK *stack, int count) {
    int i;
    int index;
    void *edit_data;

    DebugInfo.georama_debug = 1;
    for (i = 0; i < count; i++) {
        index = spiGetStackInt(stack++);
        edit_data = GetSaveData()->GetEditData(index);
        if (edit_data != 0) {
            ((CEditData *)edit_data)->dbgSetAllContintionFlag(index, 1);
        }
    }
    return 1;
}
int gcGEO_DEBUG(SPI_STACK *stack, int arg_count) {
    DebugInfo.georama_debug = 1;
    return 1;
}
int gcITEM_SET(SPI_STACK *stack, int arg_count) {
    CUserDataManager *user_data;

    user_data = &GetSaveData()->user_data;
    DebugGetItem(user_data, spiGetStackInt(stack));
    return 1;
}
int gcGET_ITEM(SPI_STACK *stack, int count) {
    int i;
    CUserDataManager *user_data;

    for (i = 0; i < count; i++) {
        user_data = &GetSaveData()->user_data;
        user_data->GetItem(spiGetStackInt(stack++), 1);
    }
    return 1;
}
int gcGET_N_ITEM(SPI_STACK *stack, int count) {
    int item_no;
    int i;
    CUserDataManager *user_data;

    for (i = 0; i < count; i++) {
        user_data = &GetSaveData()->user_data;
        item_no = spiGetStackInt(stack++);
        user_data->GetItem(item_no, spiGetStackInt(stack++));
    }
    return 1;
}
int gcEQUIP(SPI_STACK *stack, int arg_count) {
    int chara_no;
    int item_no;
    CUserDataManager *user_data;
    user_data = &GetSaveData()->user_data;
    chara_no = spiGetStackInt(stack++);
    item_no = spiGetStackInt(stack);
    user_data->SetChrEquip(chara_no, item_no);
    return 1;
}
int gcDEFENSE(SPI_STACK *stack, int arg_count) {
    int chara_no;
    int defence;
    CHARA_DATA *chara;

    chara_no = spiGetStackInt(stack++);
    defence = spiGetStackInt(stack);
    chara = GetSaveData()->user_data.GetCharaDataPtr(chara_no);
    if (chara != NULL) {
        chara->defence = defence;
    }
    return 1;
}
int gcHP(SPI_STACK *stack, int arg_count) {
    int chara_no;
    int hp;
    CHARA_DATA *chara;

    chara_no = spiGetStackInt(stack++);
    hp = spiGetStackInt(stack);
    chara = GetSaveData()->user_data.GetCharaDataPtr(chara_no);
    if (chara != NULL) {
        chara->hp.max = hp;
        chara->hp.now = hp;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", gcALL_GEO_PARTS__FP9SPI_STACKi);
int gcPARAM_DRAW(SPI_STACK *stack, int arg_count) {
    DebugInfo.param_off = !spiGetStackInt(stack);
    return 1;
}
int gcOPTION(SPI_STACK *stack, int arg) {
    char *name;
    SV_CONFIG_OPTION *options;
    SPI_STACK *value;

    value = stack + 1;
    name = (char *)spiGetStackString(stack);
    if (name == NULL) {
        return 0;
    }
    options = &GetSaveData()->config;
    if (strcmp(name, at_2082) == 0) {
        options->monster_name = spiGetStackInt(value);
    } else if (strcmp(name, at_2083) == 0) {
        options->map = spiGetStackInt(value);
    } else if (strcmp(name, at_2084) == 0) {
        options->enemy_hp = spiGetStackInt(value);
    } else if (strcmp(name, at_2085) == 0) {
        options->anger_counter = spiGetStackInt(value);
    }
    return 1;
}
int gcMONICA(SPI_STACK *stack, int arg_count) {
    CUserDataManager *manager;

    manager = GetUserDataMan();
    if (manager) {
        manager->JoinPartyMember(1);
    }
    return 1;
}
int gcSTEVE(SPI_STACK *stack, int mode) {
    CUserDataManager *manager;

    manager = GetUserDataMan();
    if (manager == NULL) {
        return 0;
    }
    manager->JoinPartyMember(2);
    manager->GetItemNotOver(0xF6, 1);
    if (mode == 2) {
        manager->DeleteItem(0xF6, 1);
        manager->GetItemNotOver(GetRidePodCore(spiGetStackInt(stack)), 1);
    }
    return 1;
}
int gcMONSTER(SPI_STACK *stack, int arg_count) {
    int sp7C;
    CUserDataManager *manager;
    int i;
    int monster_id;
    int badge_no;
    MOS_CHANGE_PARAM *badge;

    manager = GetUserDataMan();
    if (manager == NULL) {
        return 0;
    }
    manager->JoinPartyMember(3);
    manager->GetItemNotOver(0x134, 1);
    for (i = 0; i < arg_count; i++) {
        monster_id = spiGetStackInt(stack++);
        badge_no = get_gajji_id_from_monster_progress_table(monster_id, &sp7C) + 1;
        manager->monster_box.EnableChange(badge_no);
        badge = manager->monster_box.GetMonsterBajjiData(badge_no);
        if (badge != NULL) {
            badge->class_level = sp7C;
            badge->monster_id = monster_id;
            badge->progress = GetMonsterProgressTableNo(sp7C, monster_id);
        }
        manager->monster_id = monster_id;
    }
    return 1;
}
int gcPARTY(SPI_STACK *stack, int arg_count) {
    int chara_no;
    CUserDataManager *manager;

    chara_no = spiGetStackInt(stack);
    if (chara_no <= 0 || chara_no > 0x1A) {
        return 0;
    }
    manager = GetUserDataMan();
    if (manager != NULL) {
        manager->JoinPartyChara(chara_no, 0x80, 1);
        manager->SetPartyCharaStatus(chara_no, 1);
    }
    return 1;
}
int gcACTIVE_CHARA(SPI_STACK *stack, int arg_count) {
    int chara_no;
    CUserDataManager *manager;

    chara_no = spiGetStackInt(stack);
    if (chara_no < 0) {
        chara_no = 0;
    }
    if (chara_no > 1) {
        chara_no = 1;
    }
    manager = GetUserDataMan();
    if (manager) {
        manager->SetActiveChrNo(chara_no);
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", __ct__16CUserDataManagerFv);
CEditData::CEditData(void) {
    char *entry;
    char *cursor;
    char *entry2;
    char *cursor2;

    cursor = (char *)parts;
    entry = cursor;
    do {
        memset(entry, 0, 0x24);
        cursor += 0x24;
        entry = cursor;
    } while ((u32)cursor < (u32)&house_max);
    cursor2 = (char *)house;
    entry2 = cursor2;
    do {
        memset(entry2, 0, 0x10);
        cursor2 += 0x10;
        entry2 = cursor2;
    } while ((u32)cursor2 < (u32)place_log);
    memset(&analyze, 0, sizeof(analyze));
    Initialize();
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mainloop", __sinit_mainloop_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", LoopInit__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", LoopMain__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", LoopExit__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", pad_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", analog_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", SelectArg__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", menu_1281__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1305__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1310__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1311__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", menu_sel_1452__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1456__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", menu_1457__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", tag__3__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1212__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1213__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1214__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1215__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1216__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1282__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1283__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1284__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1285__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1286__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1287__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1288__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1289__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1290__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1291__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1292__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1293__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1294__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1295__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1296__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1297__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1298__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1299__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1300__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1301__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1302__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1303__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1304__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1306__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1307__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1308__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1309__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1315__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1316__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1408__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1409__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1410__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1411__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1412__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1413__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1414__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1415__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1416__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1417__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1418__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1453__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1454__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1455__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1458__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1459__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1460__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1461__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1462__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1463__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1464__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1465__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1466__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1467__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1468__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1472__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1473__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1582__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1583__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1584__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1585__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1586__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1587__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1588__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1589__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1590__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1591__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1592__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1593__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1594__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1596__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1595__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1654__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1655__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1656__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1657__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1823__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1824__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1825__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1826__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1827__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1828__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1829__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1830__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1831__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1832__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1833__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1834__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1835__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1836__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1837__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1838__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1839__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1840__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1841__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1842__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1843__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1844__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1856__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_2082__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_2083__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_2084__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_2085__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", D_0037AFF8__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", MainThreadPriority__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_973__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_974__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1317__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop", at_1474__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(read_buffer, 0x4);
INCLUDE_BSS(SystemSND_ID, 0x4);
INCLUDE_BSS(DebugFlag, 0x4);
INCLUDE_BSS(DefStartEventNo, 0x4);
INCLUDE_BSS(LanguageCode, 0x4);
INCLUDE_BSS(OmakeFlag, 0x4);
INCLUDE_BSS(MasterDebugCode, 0x4);
INCLUDE_BSS(LoopNo, 0x4);
INCLUDE_BSS(NextLoopNo, 0x4);
INCLUDE_BSS(PrevLoopNo, 0x4);
INCLUDE_BSS(CaptureMode, 0x4);
INCLUDE_BSS(CaptureScreen, 0x4);
INCLUDE_BSS(CSnd, 0x4);
INCLUDE_BSS(ActiveSaveData, 0x4);
INCLUDE_BSS(SubGameSaveData, 0x4);
INCLUDE_BSS(PlayTimeCountFlag, 0x4);
INCLUDE_BSS(pmeter_flag_1037, 0x4);
INCLUDE_BSS(init_1038, 0x4);
INCLUDE_BSS(pause_1108, 0x4);
INCLUDE_BSS(init_1109, 0x4);
INCLUDE_BSS(menu_mode, 0x4);
INCLUDE_BSS(init_1225, 0x4);
INCLUDE_BSS(init_1228, 0x4);
INCLUDE_BSS(init_1231, 0x4);
INCLUDE_BSS(init_1234, 0x4);
INCLUDE_BSS(select_1312, 0x4);
INCLUDE_BSS(init_1313, 0x4);
INCLUDE_BSS(event_view, 0x4);
INCLUDE_BSS(future_sel, 0x4);
INCLUDE_BSS(hdd_sel, 0x4);
INCLUDE_BSS(select_1469, 0x4);
INCLUDE_BSS(init_1470, 0x4);
INCLUDE_BSS(FontTex, 0x4);
INCLUDE_BSS(FontDataAdr, 0x4);
INCLUDE_BSS(BlackFade, 0x4);
INCLUDE_BSS(BlackFade2, 0x4);
INCLUDE_BSS(exit_start, 0x4);
INCLUDE_BSS(PauseSel, 0x4);
INCLUDE_BSS(PauseMenuMode, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(GamePad__2, 0x480);
INCLUDE_BSS(PadCtrl, 0x510);
INCLUDE_BSS(DebugInfo, 0x20);
INCLUDE_BSS(Font, 0xC0);
INCLUDE_BSS(InitArg, 0x50);
INCLUDE_BSS(NextInitArg, 0x50);
INCLUDE_BSS(PrevInitArg, 0x50);
INCLUDE_BSS(main_buffer, 0x1A00000);
static INCLUDE_BSS(MainBuffer, 0x30);
INCLUDE_BSS(MainScene, 0x10550);
INCLUDE_BSS(SystemSeBuff, 0x1900);
INCLUDE_BSS(SystemSeStack, 0x30);
INCLUDE_BSS(InfoBuff, 0x13880);
INCLUDE_BSS(InfoStack, 0x30);
INCLUDE_BSS(SaveData, 0x65930);
INCLUDE_BSS(vu_prog_1048, 0x40);
INCLUDE_BSS(MenuBuffer, 0x30);
INCLUDE_BSS(buf0_1224, 0x30);
INCLUDE_BSS(buf1_1227, 0x30);
INCLUDE_BSS(dbuf0_1230, 0x30);
INCLUDE_BSS(dbuf1_1233, 0x30);
INCLUDE_BSS(at_1529, 0x40);
INCLUDE_BSS(font_buff, 0xD000);
INCLUDE_BSS(PauseMes, 0x2960);
