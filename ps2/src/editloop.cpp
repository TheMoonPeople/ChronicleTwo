#include "common.h"
#include "vlgr_info.hpp"
#include "dng_effect.hpp"
#include "mglib.hpp"
#include "sphida.hpp"
#include "nowload.hpp"
#include "helpmes.hpp"
#include "sysmes.hpp"
#include "mapselect.hpp"
#include "mapjump.hpp"
#include "event.hpp"
#include "scenesnd.hpp"
#include "mg_memory.hpp"
#include "dataread.hpp"
#include "actionchara.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "editevent.hpp"
#include <cstdio>
#include "editanalyze.hpp"
#include "menucommon.hpp"
#include "nd_meswin.hpp"
#include "subgame.hpp"
#include "sound.hpp"
#include "eventedit.hpp"
#include "main.hpp"
#include "dbg_font.hpp"
#include "editdebug.hpp"
#include "editdata.hpp"
#include "editmenu.hpp"
#include "editmode.hpp"
#include "editctrl.hpp"
#include "editmap.hpp"
#include "editexception.hpp"
#include "mg_texture.hpp"
#include "sceneevent.hpp"
#include "mg_math.hpp"
#include "cameracontrol.hpp"
#include "gamepad.hpp"
#include "padcontrol.hpp"
#include "userdata.hpp"
#include "savedata.hpp"
#include "character.hpp"
#include "scene.hpp"
#include "editloop.hpp"
#include <cstring>

void EditModeChgStep(CScene *scene);

extern EditDebugInfo EdDebugInfo;
extern DEBUG_INFO DebugInfo;
extern CEditEvent EditEvent;
extern "C" int Reset__10CEditEventFv(CEditEvent *event);

static const int kEventNoMapJump = 0x1869F;
static const int kEventDataCallFlag = 8;
static const int kKeyOpenEvent = 0x96;
static const int kCameraKindEvent = 0x3E8;

extern char at_2948[];
extern char at_2949[];
extern char at_2950[];
extern char at_2951[];
extern char at_2952[];
extern char at_2953[];
extern char at_2954[];
extern char at_2955[];
extern char at_2956[];
extern char at_2957[];
extern char at_2958[];
extern char at_2261[];
extern char at_2262[];

extern mgCMemory ControlCharaBuff;
extern mgCMemory MainDataBuff;
extern EditDebugInfo EdDebugInfo;
extern int EditDrawCancelFlag;
extern int LoopCounter;
extern int LanguageCode;
extern mgCTextureManager mgTexManager;
extern CScene *MainScene__2;
extern int SubMapLoadBG;
extern int now_load_map_no;
extern u_long128 *read_buffer;
extern int MapNo;
extern int DelMainNPCflag;
extern CMapTreasureBox *TreasureBox;
extern int beforeAnalyze[16];
extern DEBUG_INFO DebugInfo;
extern CEditEvent EditEvent;
extern float at_3041[4];
extern CCharacter2 *WalkChara;
extern int ControlMode;
extern int LoopMode;
extern ClsMes EventMes1;
extern char at_2747[9];
extern "C" void LoadEditInfo__13CEditInfoMngrFPciP9mgCMemory(void *infoMngr, char *data, int size,
                                                             mgCMemory *memory);
extern "C" void CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory(CMap *map, CMapTreasureBox *boxes,
                                                                  int count, int stack);
extern "C" int Reset__10CEditEventFv(CEditEvent *event);
extern "C" void *__ct__10CRunScriptFv(void *);
extern CGamePad GamePad__2;
extern int LockChara;
extern int EditModeChgCnt;
extern int EditModeChgEvent;
extern int EditModeChgFlag;

#ifdef NONMATCHING
#include <libvu0.h>
#include "charasetup.hpp"
#include "editeff.hpp"
#include "editparts.hpp"
#include "effectlist.hpp"
#include "effscript.hpp"
#include "gaiji.hpp"
#include "gamedata.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "menumain.hpp"
#include "mg_dataset.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_visual.hpp"
#include "photo.hpp"
#include "screeneffect.hpp"
#include "snd_mngr.hpp"
#include "wavetable.hpp"
extern mgCFrame * WaterFrame;
extern mgCFrame * RedBicMark;
extern mgCFrame * BlueBicMark;
extern CCameraControl * Camera;
extern CCameraControl * FixCamera;
extern CCameraControl * EditCamera;
extern int ActiveCharaNo;
extern int ControlCharaID;
extern int EventSquareJump;
extern int EditDrawFlag;
extern int PauseFlag;
extern int PreEditMenuCnt;
extern u_long128 * main_pkt1;
extern u_long128 * main_pkt2;
extern u_long128 * read_buffer_end;
extern u_long128 * MenuDataBuf;
extern int MenuDataSize;
extern int FixCharaBuffSize;
extern u_long128 * CrossFadeBuff;
extern MENU_INIT_ARG * MenuInfo;
extern int DataPktMode;
extern CWaveTable WaveTable;
extern sceVu0FVECTOR CharaOldPos;
extern mgCMemory buf0;
extern mgCMemory buf1;
extern mgCMemory data_buf__2[2];
extern mgCMemory init_dbuf[2];
extern mgCMemory WorkBuffer;
extern mgCMemory MenuBuffer__2;
extern mgCMemory ChrEffBuffer;
extern mgCMemory ScriptBuffer__2;
extern mgCMemory TotalDataBuff;
extern mgCMemory MainCharaBuff;
extern mgCMemory SubDataBuff;
extern mgCMemory SubCharaBuff;
extern mgCMemory EventBuff[4];
extern mgCMemory CharaBufs[8];
extern mgCMemory FishingBuff;
extern mgCMemory SkyBuff;
extern mgCVisualMDT TestVisual;
extern mgCFrame TestFrame;
namespace editloop { extern CCameraControl *EventCamera; }
void InitSubMapLoadStep();
void LoadMap();
void InitEditEvent();
void ResetEditEvent();
void RestartEditEvent();
void UpdateTrBoxFlag(int map_no);
void editLoadSound(int map_no);
#endif

// Code (.text)
extern "C" CUserDataManager *GetUserData__Fv__2(void) {
    CSaveData *save;

    save = GetSaveData();
    if (save != 0) {
        return &save->user_data;
    }
    return 0;
}
void InitLockCharaCtrl(void) {
    LockChara = 0;
}
void LockCharaCtrl(void) {
    LockChara++;
}
void UnLockCharaCtrl(void) {
    LockChara -= 1;
    if (LockChara < 0) {
        LockChara = 0;
    }
}
#ifdef NONMATCHING
int IsEditMode() {
    if (LoopMode == EDIT_LOOP_EDIT) {
        return 1;
    }
    if (LoopMode == EDIT_LOOP_EDIT_PRE_MENU) {
        return 1;
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", IsEditMode__Fv);
#endif
void InitEditModeChg(void) {
    EditModeChgFlag = 0;
    EditModeChgCnt = 0;
    EditModeChgEvent = 0;
}
int NowEditModeChg(void) {
    if (EditModeChgFlag != 0) {
        return EditModeChgCnt > 0;
    }
    return 0;
}
#ifdef NONMATCHING
/**
 * Locks character control for thirty frames before starting the transition event.
 */
void EditModeChg(int event) {
    EditModeChgEvent = event;
    EditModeChgCnt = 30;
    EditModeChgFlag = 1;
    LockCharaCtrl();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditModeChg__Fi);
#endif
#ifdef NONMATCHING
/**
 * Finishes the transition delay and starts its event when the scene is idle.
 */
void EditModeChgStep(CScene *scene) {
    if (EditModeChgFlag != 0) {
        EditModeChgCnt--;
        if (EditModeChgCnt <= 0) {
            EditModeChgFlag = 0;
            EditModeChgCnt = 0;
            UnLockCharaCtrl();
            if (scene->event_run == 0 && EditModeChgEvent > 0) {
                scene->RunEvent(EditModeChgEvent, NULL);
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditModeChgStep__FP6CScene);
#endif
#ifdef NONMATCHING
void SetDataPacket(int mode) {
    u_long128 *buffer;
    int        size;

    if (mode == 0) {
        buffer = read_buffer - 5000;
        init_dbuf[0].stSetBuffer(buffer, 5000);
        init_dbuf[1].stSetBuffer(buffer - 5000, 5000);
        mgInitVif1Packet(main_pkt1, main_pkt2, 160000);
        mgSetPacketBuffer(&buf0, &buf1);
        mgSetDataBuffer(&init_dbuf[0], &init_dbuf[1], 1);
        DataPktMode = mode;
        return;
    }
    size = 70000;
    if (mode == 2) {
        size = 115000;
    }
    printf("Data Packet Size = %dkb\n", size * 16 / 1024);
    if (mode == DataPktMode) {
        ControlCharaBuff.stack_used = 0;
        ControlCharaBuff.lock = 0;
        ControlCharaBuff.Alloc(FixCharaBuffSize);
        ControlCharaBuff.Alloc(size);
        ControlCharaBuff.Alloc(size);
        ControlCharaBuff.lock = 1;
        return;
    }
    ControlCharaBuff.stack_used = 0;
    ControlCharaBuff.lock = 0;
    ControlCharaBuff.Alloc(FixCharaBuffSize);
    mgInitVif1Packet(main_pkt1, main_pkt2, 160000);
    mgSetPacketBuffer(&buf0, &buf1);
    data_buf__2[0].stSetBuffer(ControlCharaBuff.Alloc(size), size);
    data_buf__2[1].stSetBuffer(ControlCharaBuff.Alloc(size), size);
    ControlCharaBuff.lock = 1;
    mgSetDataBuffer(&data_buf__2[0], &data_buf__2[1], 1);
    printf("Data ADR %x,%x\n", data_buf__2[0].stack + data_buf__2[0].stack_used, data_buf__2[1].stack + data_buf__2[1].stack_used);
    DataPktMode = mode;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", SetDataPacket__Fi);
#endif
void PreExitLoop(CScene *scene) {
    BurnEditParts();
    EditDataSave();
    sgBreakSubGame();
    scene->StopBGM(0);
    scene->InitBGM();
    scene->SeAllStop();
    BreakReadBG();
    sndStopVoice(1);
    ResetNpcTalkMes();
    EdEventTermination();
}
#ifdef NONMATCHING
void EditInit(INIT_LOOP_ARG arg) {
    mgCMemory         *main_stack;
    u_long128         *script_data;
    u_long128         *image_data;
    CEffectScriptMan  *effects;
    CActionChara      *characters;
    CCameraControl   *debug_camera;
    CCharacter2      *player;
    CMap             *map;
    mgCTexture       *cross_texture;
    mgCMDTBuilder     builder;
    mgLoadData        load;
    sceVu0FVECTOR     material = {0.5f, 0.0f, 0.0f, 0.2f};
    sceVu0FVECTOR     position;
    char              system_image[64] = "img/esystem.img";
    char             *menu_file;
    int               data_size;
    int               image_size;
    int               fire_size;
    int               water_size;
    u_int             water_qwords;
    int               event_no;
    int               active_chara_no;
    int               fishing_item;
    int               i;
    static sceVu0FVECTOR initial_position;

    DataPktMode = -1;
    MainScene__2 = GetMainScene();
    DeleteFileCache();
    MapNo = -1;
    mgInitFont();
    PauseFlag = 0;
    LoopMode = EDIT_LOOP_WALK;
    ControlMode = EDIT_CONTROL_PLAYER;
    InitLockCharaCtrl();
    InitEditModeChg();
    LoopCounter = 0;
    EditDrawFlag = 0;
    EditDrawCancelFlag = 0;
    mgInitLighting();
    InitInterior();
    InitSubMapLoadStep();
    EventSquareJump = 0;
    mgActiveLighting(0, 0);
    mgInitActiveLighting();

    main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;
    main_pkt1 = main_stack->stAlloc64(10000);
    main_pkt2 = main_stack->stAlloc64(10000);
    mgInitVif1Packet(main_pkt1, main_pkt2, 160000);
    buf0.stSetBuffer(main_stack->stAlloc64(35000), 35000);
    buf1.stSetBuffer(main_stack->stAlloc64(35000), 35000);
    mgSetPacketBuffer(&buf0, &buf1);
    script_data = main_stack->stAlloc64(20000);
    if (strlen("SsScript Buffer") < 16) {
        strcpy(ScriptBuffer__2.name, "SsScript Buffer");
    }
    ScriptBuffer__2.stSetBuffer(script_data, 20000);
    main_stack->Align64();
    data_size = main_stack->stack_size - main_stack->stack_used - 210128;
    TotalDataBuff.stSetBuffer(&main_stack->stack[main_stack->stack_used], data_size);
    printf("data memory size = %d kbyte", data_size * 16 / 1024);
    if (strlen("Total Data Buffer") < 16) {
        strcpy(TotalDataBuff.name, "Total Data Buffer");
    }
    TotalDataBuff.stack_used = 0;
    TotalDataBuff.lock = 0;
    main_stack->Alloc(data_size);
    read_buffer = main_stack->stAlloc64(200000);
    MenuBuffer__2.stSetBuffer(read_buffer, 200000);
    read_buffer_end = read_buffer + 200000;
    WorkBuffer.stSetBuffer(main_stack->stAlloc64(10000), 10000);
    mgTexManager.SetTableBuffer(350, 221, &TotalDataBuff);
    mgTexManager.Initialize(GetVramTopAddress(), -1);
    SetDataPacket(0);

    NowLoadingInfo loading;
    loading.tex_block = 206;
    loading.step_count = 15;
    loading.unk_4 = 1;
    loading.memory.stSetBuffer(read_buffer + 195000, 5000);
    CreateNowLoading(&loading);
    SetEnvUserDataMan(0);
    TotalDataBuff.Align64();
    MenuDataBuf = &TotalDataBuff.stack[TotalDataBuff.stack_used];
    menu_file = GetMenuCfgFileName(0, 0);
    SetCurrentDir(NULL);
    if (LoadFile2(menu_file, MenuDataBuf, &MenuDataSize, 0) != 0) {
        TotalDataBuff.Alloc(MenuDataSize / 16 + 1);
    }
    NowLoadingBarStep();

    builder.Begin(&TotalDataBuff);
    builder.BeginData(MG_MDT_DATA_VERTEX);
    builder.SetData(0.0f, 0.0f, 0.0f, 1.0f);
    builder.SetData(0.0f, 0.0f, 1.0f, 1.0f);
    builder.SetData(0.0f, 1.0f, 0.0f, 1.0f);
    builder.SetData(0.0f, 1.0f, 1.0f, 1.0f);
    builder.SetData(1.0f, 0.0f, 0.0f, 1.0f);
    builder.SetData(1.0f, 0.0f, 1.0f, 1.0f);
    builder.SetData(1.0f, 1.0f, 0.0f, 1.0f);
    builder.SetData(1.0f, 1.0f, 1.0f, 1.0f);
    builder.EndData();
    builder.BeginData(MG_MDT_DATA_MATERIAL);
    builder.SetMaterial(material, "");
    builder.EndData();
    builder.BeginFaces();
    builder.BeginPrim(0x214, 0);
    builder.AddFace(0);
    builder.AddFace(1);
    builder.AddFace(2);
    builder.AddFace(3);
    builder.AddFace(6);
    builder.AddFace(7);
    builder.AddFace(4);
    builder.AddFace(5);
    builder.EndPrim();
    builder.BeginPrim(0x214, 0);
    builder.AddFace(2);
    builder.AddFace(6);
    builder.AddFace(0);
    builder.AddFace(4);
    builder.AddFace(1);
    builder.AddFace(5);
    builder.AddFace(3);
    builder.AddFace(7);
    builder.EndPrim();
    builder.EndFaces();
    TestFrame.mgCFrame::Initialize();
    memset(&load, 0, sizeof(load));
    load.memory = &TotalDataBuff;
    load.work_memory = &WorkBuffer;
    builder.End(&TestFrame, &TestVisual, &load);
    if (TestFrame.attr != NULL) {
        TestFrame.attr->clip_enable = 1;
        TestFrame.attr->z_write = -1;
    }

    if (LoadFile2("etc/bikkuri_aka.mds", read_buffer, NULL, 0) != 0) {
        RedBicMark = mgLoadMDSFile((MDS_HEADER *)read_buffer, &TotalDataBuff, NULL, NULL);
        mgCFrameAttr attr;
        attr.billboard = MG_FRAME_BILLBOARD_Y;
        attr.no_light = 1;
        attr.color[3] = 128.0f;
        attr.color[2] = 255.0f;
        attr.color[1] = 255.0f;
        attr.color[0] = 255.0f;
        RedBicMark->SetAttrParam(attr, 1, 0);
    }
    LoadEditCursor(&TotalDataBuff, 163);
    EditSetEffectBuffer(&TotalDataBuff);
    TreasureBox = NULL;
    if (LoadFile2("map/itembox.chr", read_buffer, NULL, 0) != 0) {
        TreasureBox = new (TotalDataBuff.Alloc(sizeof(CMapTreasureBox) / 16 + 2)) CMapTreasureBox;
        mgTexManager.DeleteBlock(173);
        TreasureBox->LoadPackNoLine((u_int *)read_buffer, "info.cfg", &TotalDataBuff, &TotalDataBuff, &TotalDataBuff, 173, NULL);
    }
    ChrEffBuffer.SetHeapMem(TotalDataBuff.stAlloc64(6400), 6400);
    NowLoadingBarStep();
    NowLoadingBarStep();
    SetCurrentDir(NULL);

    TotalDataBuff.Align64();
    image_data = TotalDataBuff.stAllocTest(1);
    if (LanguageCode > 0) {
        sprintf(system_image, "img/esystem%d.img", LanguageCode);
    }
    if (LoadFile2(system_image, image_data, &image_size, 0) != 0) {
        mgTexManager.EnterIMGFile((u_char *)image_data, 162, &TotalDataBuff, NULL);
        TotalDataBuff.Alloc(image_size / 16 + 1);
        LoadTakePhoto(162, &TotalDataBuff, read_buffer);
    }
    TotalDataBuff.Align64();
    image_data = TotalDataBuff.stAllocTest(1);
    if (LoadFile2("effect/fire.img", image_data, &fire_size, 0) != 0) {
        TotalDataBuff.Alloc(fire_size / 16 + 1);
        mgTexManager.EnterIMGFile((u_char *)image_data, 66, &TotalDataBuff, NULL);
    }

    EventMes1.Init();
    EventMes1.Preset(0);
    EventMes1.texture_block = 154;
    ReLoadFontTexture(154);
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 154, NULL, NULL);
    mgTexManager.EnterIMGFile(GetFontTex2ImgPtr(), 154, NULL, NULL);
    NowLoadingBarStep();
    MainScene__2->Initialize();
    MainScene__2->chara_texb = 70;
    MainScene__2->villager_texb = 78;
    MainScene__2->villager_texb_num = 56;
    MainScene__2->event_texb = 160;
    MainScene__2->event_texb_num = 2;
    MainScene__2->GetActiveBgmInfo()->unk_c = 1.0f;
    MainScene__2->SetVolfBGM(MainScene__2->GetActiveBgmInfo()->volf);
    MainScene__2->unk_3e68 = 185;
    MainScene__2->unk_3e6c = 21;
    effects = new (TotalDataBuff.Alloc(sizeof(CEffectScriptMan) / 16 + 2)) CEffectScriptMan;
    effects->Initialize(&TotalDataBuff, 174, 11);
    effects->load_buffer = read_buffer;
    effects->SetWorkBuffer(&ChrEffBuffer);
    effects->LoadBaseEffSpt("\x91\xab\x8d\xbb\x89\x8c", NULL, -1);
    effects->LoadBaseEffSpt("\x91\xab\x94\x67\x96\xe4", NULL, -1);
    effects->LoadBaseEffSpt("\x91\xab\x90\x85\x83\x70\x83\x56\x83\x83", NULL, -1);
    effects->LoadBaseEffSpt("\x91\xab\x8e\xc5\x90\xb6", NULL, -1);
    effects->LoadBaseEffSpt("\x8d\xbb\x89\x8c" "2", NULL, -1);
    MainScene__2->AssignEffect(0, effects, NULL);
    MainScene__2->read_buff = read_buffer;
    if (LoadFile2("img/water_ref.img", TotalDataBuff.stAllocTest(1), &water_size, 0) != 0) {
        water_qwords = (u_int)water_size / 16;
        if (water_size & 0xF) {
            water_qwords++;
        }
        mgTexManager.EnterIMGFile((u_char *)TotalDataBuff.Alloc(water_qwords), 158, NULL, NULL);
    }
    NowLoadingBarStep();

    characters = new (TotalDataBuff.Alloc(sizeof(CActionChara) * 8 / 16 + 2)) CActionChara[8];
    for (i = 0; i < 8; i++) {
        MainScene__2->AssignChara(i, &characters[i], NULL);
    }
    MainScene__2->AssignMessage(0, &EventMes1, NULL);
    GetSystemMessage()->texture_block = 154;
    MainScene__2->AssignMessage(1, GetSystemMessage(), NULL);
    GetSystemMessage(1)->texture_block = 154;
    MainScene__2->AssignMessage(2, GetSystemMessage(1), NULL);
    GetSystemMessage(2)->texture_block = 154;
    MainScene__2->AssignMessage(3, GetSystemMessage(2), NULL);
    Camera = new (TotalDataBuff.Alloc(sizeof(CCameraControl) / 16 + 2)) CCameraControl;
    editloop::EventCamera = new (TotalDataBuff.Alloc(sizeof(CCameraControl) / 16 + 2)) CCameraControl;
    FixCamera = new (TotalDataBuff.Alloc(sizeof(CCameraControl) / 16 + 2)) CCameraControl;
    EditCamera = new (TotalDataBuff.Alloc(sizeof(CCameraControl) / 16 + 2)) CCameraControl;
    debug_camera = new (TotalDataBuff.Alloc(sizeof(CCameraControl) / 16 + 2)) CCameraControl;
    MainScene__2->AssignCamera(0, Camera, NULL);
    MainScene__2->AssignCamera(1, editloop::EventCamera, NULL);
    MainScene__2->AssignCamera(2, FixCamera, NULL);
    MainScene__2->AssignCamera(3, EditCamera, NULL);
    MainScene__2->AssignCamera(7, debug_camera, NULL);
    MainScene__2->active_camera = 0;
    MainScene__2->before_camera = 0;
    Camera->GetActiveParam()->near_height = 10.0f;
    Camera->GetActiveParam()->far_height = 10.0f;
    Camera->GetActiveParam()->ground_space = 30.0f;
    Camera->default_param = *Camera->GetActiveParam();
    MainScene__2->player_chara = 0;

    mgTexManager.EnterTexture(156, "work", NULL, mgScreenWidth, mgScreenHeight, 32, NULL, 0, 0);
    mgTexManager.EnterTexture(159, "shadow_work", NULL, mgScreenWidth, mgScreenHeight, 32, NULL, 0, 0);
    mgTexManager.EnterTexture(158, "water_work", NULL, mgScreenWidth, mgScreenHeight, 32, NULL, 0, 0);
    mgTexManager.EnterTexture(66, "fire_work", NULL, mgScreenWidth, mgScreenHeight, 32, NULL, 0, 0);
    mgTexManager.EnterTexture(213, "test4", NULL, 64, 64, 16, NULL, 0, 0);
    mgTexManager.EnterTexture(157, "f_work", NULL, mgScreenWidth, mgScreenHeight, 32, NULL, 0, 0);
    mgTexManager.EnterTexture(157, "f_work2", NULL, mgScreenWidth / 3, mgScreenHeight / 3, 32, NULL, 0, 0);
    cross_texture = mgTexManager.EnterTexture(213, "cross_f", NULL, mgScreenWidth, mgScreenHeight, 32, NULL, 0, 0);
    InitPause(207);
    CrossFadeBuff = read_buffer + 131072;
    MainScene__2->fade.SetCrossTexture(cross_texture, CrossFadeBuff);
    MainScene__2->unk_2e84 = 159;

    TotalDataBuff.Align64();
    TotalDataBuff.lock = 1;
    ControlCharaBuff.stSetBuffer(&TotalDataBuff.stack[TotalDataBuff.stack_used], TotalDataBuff.stack_size - TotalDataBuff.stack_used);
    ControlCharaBuff.stack_used = 0;
    ControlCharaBuff.lock = 0;
    MainScene__2->SetStack(0, &ControlCharaBuff);
    MainScene__2->SetStack(1, &MainDataBuff);
    MainScene__2->SetStack(2, &MainCharaBuff);
    MainScene__2->SetStack(3, &SubDataBuff);
    MainScene__2->SetStack(4, &SubCharaBuff);
    MainScene__2->SetStack(5, &EventBuff[0]);
    MainScene__2->SetStack(6, &EventBuff[1]);
    MainScene__2->SetStack(7, &EventBuff[2]);
    MainScene__2->SetStack(8, &EventBuff[3]);
    MainScene__2->work_stack = &WorkBuffer;
    ControlCharaBuff.stAlloc64(GetCharaMemAllocSize());
    ControlCharaBuff.Align64();
    FixCharaBuffSize = ControlCharaBuff.stack_used;
    ControlCharaBuff.lock = 1;
    active_chara_no = GetUserData__Fv__2()->active_chr_no;
    SetupMainUnit(read_buffer, &ControlCharaBuff, CharaBufs, 70, MainScene__2, GetUserData__Fv__2(), active_chara_no, 1);
    ActiveCharaNo = GetUserData__Fv__2()->active_chr_no;
    ControlCharaID = 0;
    MainScene__2->SetActive(1, 0);
    MainScene__2->player_chara = ControlCharaID;
    NowLoadingBarStep();

    MapJumpMapInfo main_map;
    main_map.stack_no = 1;
    main_map.map_no = 0;
    main_map.efp_tex_block = 64;
    main_map.tex_block = 0;
    main_map.sky_tex_block = 169;
    main_map.load_buf = (u_char *)read_buffer;
    SetMainMapInfo(&main_map);
    MapJumpMapInfo sub_map;
    sub_map.map_no = 1;
    sub_map.tex_block = 24;
    sub_map.stack_no = 3;
    sub_map.efp_tex_block = 65;
    sub_map.sky_tex_block = 169;
    sub_map.load_buf = (u_char *)read_buffer;
    SetSubMapInfo(&sub_map);
    SetScriptBuffer(&ScriptBuffer__2);
    MainScene__2->InitSeBas();
    if (arg.map_no < 0) {
        MainScene__2->LoadSound(0, read_buffer);
    }
    EditMapJump(SearchMapNo(GetMapName(arg.map_no, NULL)));
    NowLoadingBarStep();
    WaterFrame = NULL;
    InitEditFlag();
    SetCurrentDir(NULL);
    if (MapNo == 10) {
        LoadMap();
    }
    MainCharaBuff.Align64();
    MainCharaBuff.lock = 1;
    SubDataBuff.stSetBuffer(&MainCharaBuff.stack[MainCharaBuff.stack_used], MainCharaBuff.stack_size - MainCharaBuff.stack_used);
    SubDataBuff.stack_used = 0;
    SubDataBuff.lock = 0;
    SetCurrentDir(NULL);
    *(u_long128 *)position = *(u_long128 *)initial_position;
    player = MainScene__2->GetCharacter(MainScene__2->player_chara);
    map = MainScene__2->GetMap(0);
    if (player != NULL && map != NULL) {
        player->SetPosition(map->chara_pos);
        player->GetPosition(position);
    }
    Camera->SetPos(0.0f, 0.0f, 100.0f);
    Camera->Step(10);
    Camera->SetFollowOffset(0.0f, 30.0f, 0.0f);
    Camera->SetFollow(position[0], position[1], position[2]);
    Camera->SetDistance(130.0f);
    Camera->SetHeight(20.0f);
    Camera->SetSpeed(8.0f / (float)mgFrameRate, -1.0f);
    Camera->Step(-1);
    printf("Basic Data %dkbyte\n", TotalDataBuff.stack_used * 16 / 1024);
    printf("Main Data %dkbyte\n", MainDataBuff.stack_used * 16 / 1024);
    printf("Main Chara %dkbyte\n", MainCharaBuff.stack_used * 16 / 1024);
    printf("Sub Data %dkbyte\n", SubDataBuff.stack_used * 16 / 1024);
    printf("Remain %dkbyte\n", (SubDataBuff.stack_size - SubDataBuff.stack_used) * 16 / 1024);
    CreateHelpMes(154);
    InitEvent(MainScene__2);
    InitEventEdit(214, &MenuBuffer__2);
    EdEventLoopInit();
    EditControlInit(MainScene__2);
    MainScene__2->fade.FadeIn(30);
    MainScene__2->time_step = 1;
    event_no = arg.event_no;
    if (event_no <= 0) {
        event_no = 100;
    }
    if (event_no > 0 && RunEvent(event_no, MainScene__2) > 0) {
        ControlMode = EDIT_CONTROL_EVENT;
    }
    MenuInfo->stack = &MenuBuffer__2;
    MenuInfo->tex_block_top = 134;
    MenuInfo->tex_block_num = 16;
    MenuInfo->mes_tex_block = 154;
    MenuInfo->active_chara_no = ActiveCharaNo;
    MenuInfo->user_data = GetUserData__Fv__2();
    MenuInfo->chara_stack = &ControlCharaBuff;
    MenuInfo->base_chara_stack = CharaBufs;
    MenuInfo->chara_tex_block = 70;
    MenuInfo->pack = (u_int *)MenuDataBuf;
    MenuInfo->pack_size = MenuDataSize;
    EditDebugInit();
    InitLightingEdit();
    EditEvent.Reset();
    InitSubGame(MainScene__2);
    EdDebugInfo.rod_no = fishing_item;
    EdDebugInfo.menu_buff = NULL;
    EdDebugInfo.esa_no = fishing_item;
    EdDebugInfo.texb = 185;
    EdDebugInfo.texb_num = 21;
    EdDebugInfo.load_buff = NULL;
    EdDebugInfo.jump_map_no = -1;
    EdDebugInfo.unk_c = 154;
    EdDebugInfo.dungeon = 0;
    EdDebugInfo.no_map_event = 0;
    EdDebugInfo.record_check = 0;
    EdDebugInfo.keep_bgm = 0;
    EdDebugInfo.scene = MainScene__2;
    InitPauseMenu(154);
    NowLoadingBarSteEnd();
    DeleteNowLoading();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditInit__F13INIT_LOOP_ARG);
#endif
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", __as__15CameraCtrlParamFRC15CameraCtrlParam);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", __ct__12CActionCharaFv);
void EditExit(void) {
    sndSeAllStop(1);
    MainScene__2->InitSeSrc();
    mgCloseFont();
    BreakReadBG();
    sndStopVoice(1);
    if (SubGameRunning() != 0) {
        sgExitSubGame();
    }
}
void InitSubMapLoadStep(void) {
    SubMapLoadBG = 0;
    now_load_map_no = -1;
}
int SubMapLoadStep(void) {
    CScene *scene;
    if (MainScene__2->LoadMapBGStep(0) != 0) {
        if (SubMapLoadBG != 0) {
            SubMapLoadBG = 0;
            MainScene__2->SetActive(2, 1);
            MainScene__2->LoadSubVillager(GetSubMapNo(), 0x5E);
            MainScene__2->PreLoadVillagerEnd();
            char *name = GetMapName(now_load_map_no, 0);
            scene = MainScene__2;
            EditMapInitEvent(now_load_map_no, (CEditMap *)scene->GetMap(scene->GetMapID(name)));
            now_load_map_no = -1;
        }
        return 0;
    }
    return 1;
}
#ifdef NONMATCHING
int EditLoop() {
    static int          time_step;
    static int          show_time_step;
    static int          old_cm;
    static int          rain_flag;
    CMap               *map;
    CCharacter2        *chara;
    CCameraControl     *camera;
    CCameraControl     *walk_camera;
    CameraCtrlParam    *camera_param;
    CameraCtrlParam    *default_param;
    SubGameInfo        *current_subgame;
    PAUSE_INFO          menu_pause;
    PAUSE_INFO          pause;
    sceVu0FVECTOR       position;
    sceVu0FVECTOR       ground_position;
    sceVu0FVECTOR       closest;
    sceVu0FVECTOR       line_start;
    sceVu0FVECTOR       line_end;
    sceVu0FVECTOR       load_position = {1400.0f, -6.0f, -218.0f, 1.0f};
    sceVu0FVECTOR       talk_position;
    sceVu0FVECTOR       talk_height;
    sceVu0FVECTOR       villager_position;
    sceVu0FVECTOR       edit_position;
    sceVu0FVECTOR       return_position;
    sceVu0FVECTOR       camera_position;
    sceVu0FVECTOR       camera_reference;
    int                 stay[32];
    char               *map_name;
    float               time_rate;
    float               projection;
    float               distance;
    float               camera_angle;
    int                 game_progress;
    int                 light_band;
    int                 next_sub_map;
    int                 finish;
    int                 wait_for_map;
    int                 menu_mode;
    int                 open_menu;
    int                 change_mode;
    int                 return_to_player;
    int                 start_event;
    int                 pause_enabled;
    int                 event_result;
    int                 reset_event;
    int                 menu_requested;
    int                 menu_button;
    int                 quick_change;
    int                 next_chara;
    int                 menu_enabled;
    int                 debug_closed;
    int                 debug_move;
    int                 edit_enabled;
    int                 main_map_no;
    int                 change_event;
    int                 pause_result;

    finish = 0;
    mgSetAllScissorFlag(0);
    LoopCounter++;
    if (LoopCounter > 10000) {
        LoopCounter = 10000;
    }
    {
        static char init;

        if (init == 0) {
            time_step = 1;
            init = 1;
        }
    }
    {
        static char init;

        if (init == 0) {
            show_time_step = 0;
            init = 1;
        }
    }

    if (PauseFlag == 0 && IsLightingEditMode() == 0) {
        map = MainScene__2->GetMap(MainScene__2->active_map);
        if (map != NULL) {
            map->now_time = MainScene__2->time;
            light_band = map->GetNowTimeLightBand();
            if (GamePad__2.On2(PAD_RIGHT) != 0) {
                MainScene__2->AddTime(0.1f);
            }
            if (GamePad__2.On2(PAD_LEFT) != 0) {
                MainScene__2->AddTime(-0.1f);
            }
            if (GamePad__2.Down2(PAD_UP) != 0) {
                MainScene__2->SetTime(((int)MainScene__2->time / 2) * 2 + 2);
            }
            if (GamePad__2.Down2(PAD_DOWN) != 0) {
                show_time_step = 30;
                time_step = time_step == 0;
            }
            if (LoopMode == EDIT_LOOP_WAIT_READ) {
                if (ReadBGSync() == 0) {
                    LoopMode = EDIT_LOOP_WALK;
                }
            } else if (GetSaveData()->time_stop == 0 && time_step != 0 &&
                       ControlMode == EDIT_CONTROL_PLAYER && LoopMode == EDIT_LOOP_WALK) {
                time_rate = 1.0f;
                if (GetSaveData() != NULL && GetSaveData()->config.fast_time != 0) {
                    time_rate = 1.5f;
                }
                MainScene__2->TimeStep(time_rate);
            }
            map->now_time = MainScene__2->time;
            if (light_band != map->GetNowTimeLightBand() && map->time_cfade != 0) {
                MainScene__2->fade.CaptureScreen();
                MainScene__2->fade.CrossFade(10, 0.8f);
            }
        }
    }

    wait_for_map = 0;
    if (PadCtrl.Btn(0) != 0 || PadCtrl.Btn(5) != 0) {
        wait_for_map = 1;
    }
    map_name = MainScene__2->GetMapName(MainScene__2->active_map);
    if (LoopCounter >= 3 && LoopMode == EDIT_LOOP_WALK && map_name != NULL && strcmp(map_name, "m01") == 0) {
        chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
        if (chara != NULL) {
            chara->GetPosition(position);
            *(u_long128 *)ground_position = *(u_long128 *)position;
            ground_position[1] = 0.0f;
            line_start[3] = 1.0f;
            line_end[3] = 1.0f;
            next_sub_map = -1;
            if (MainScene__2->LoadMapBGStep(NULL) == 0) {
                line_start[0] = 1900.0f;
                line_start[1] = 0.0f;
                line_start[2] = 1200.0f;
                line_end[0] = 1900.0f;
                line_end[1] = 0.0f;
                line_end[2] = 1700.0f;
                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }
                line_start[0] = 1713.0f;
                line_start[1] = 0.0f;
                line_start[2] = -302.0f;
                line_end[0] = 1423.0f;
                line_end[1] = 0.0f;
                line_end[2] = -487.0f;
                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }
                line_start[0] = -1380.0f;
                line_start[1] = 0.0f;
                line_start[2] = 151.0f;
                line_end[0] = -1380.0f;
                line_end[1] = 0.0f;
                line_end[2] = 444.0f;
                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }
                line_start[0] = -3283.0f;
                line_start[1] = 0.0f;
                line_start[2] = 1362.0f;
                line_end[0] = -2996.0f;
                line_end[1] = 0.0f;
                line_end[2] = 1616.0f;
                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }
                line_start[0] = -2218.0f;
                line_start[1] = 0.0f;
                line_start[2] = 628.0f;
                line_end[0] = -2041.0f;
                line_end[1] = 0.0f;
                line_end[2] = 660.0f;
                if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f) {
                    wait_for_map = 1;
                }
            }
            line_start[0] = 1340.0f;
            line_start[1] = 0.0f;
            line_start[2] = 79.0f;
            line_end[0] = 1125.0f;
            line_end[1] = 0.0f;
            line_end[2] = -245.0f;
            if (now_load_map_no != 11 &&
                mgDistLinePoint(ground_position, line_start, line_end, closest) < 20.0f && MainScene__2->GetMapID("m02") != 1) {
                next_sub_map = 11;
            }
            line_start[0] = 1500.0f;
            line_start[1] = 0.0f;
            line_start[2] = 1600.0f;
            line_end[0] = 1500.0f;
            line_end[1] = 0.0f;
            line_end[2] = 1100.0f;
            if (mgDistLinePoint(ground_position, line_start, line_end, closest) < 40.0f) {
                if (GetSquareEvent() != 0) {
                    if (ground_position[0] >= 1500.0f && CharaOldPos[0] < 1500.0f) {
                        MainScene__2->RunEvent(201, NULL);
                        if (SubGameRunning() != 0 && GetSubGameNo() == SUBGAME_FISHING) {
                            sgExitSubGame();
                        }
                    }
                } else if (now_load_map_no != 12 && MainScene__2->GetMapID("m03") != 1) {
                    next_sub_map = 12;
                }
            }
            game_progress = GetSaveData()->game_progress;
            if (game_progress != 2 && game_progress != 3) {
                line_start[0] = -520.0f;
                line_start[1] = 0.0f;
                line_start[2] = 243.0f;
                line_end[0] = -608.0f;
                line_end[1] = 0.0f;
                line_end[2] = -187.0f;
                if (now_load_map_no != 13 &&
                    mgDistLinePoint(ground_position, line_start, line_end, closest) < 50.0f && MainScene__2->GetMapID("m04") != 1) {
                    next_sub_map = 13;
                }
            }
            load_position[0] = -2259.0f;
            load_position[1] = 185.0f;
            load_position[2] = 851.0f;
            if (now_load_map_no != 13 && mgDistVectorXZ(position, load_position) < 150.0f && MainScene__2->GetMapID("m04") != 1) {
                next_sub_map = 13;
            }
            load_position[0] = -2700.0f;
            load_position[1] = 256.0f;
            load_position[2] = 1207.0f;
            if (now_load_map_no != 14 && mgDistVectorXZ(position, load_position) < 150.0f && MainScene__2->GetMapID("m05") != 1) {
                next_sub_map = 14;
            }
            line_start[0] = -2157.0f;
            line_start[1] = 0.0f;
            line_start[2] = 756.0f;
            line_end[0] = -3037.0f;
            line_end[1] = 0.0f;
            line_end[2] = 1531.0f;
            distance = mgDistLinePoint(ground_position, line_start, line_end, closest);
            camera = (CCameraControl *)MainScene__2->GetCamera(MainScene__2->active_camera);
            camera_param = camera->GetActiveParam();
            default_param = &camera->default_param;
            if (distance < 220.0f) {
                CancelEyeViewMode();
                camera_param->min_height += (100.0f - camera_param->min_height) / 8.0f;
                camera_param->max_height = camera_param->min_height;
            } else {
                camera_param->min_height += (default_param->min_height - camera_param->min_height) / 8.0f;
                camera_param->max_height += (default_param->max_height - camera_param->max_height) / 8.0f;
            }
            *(u_long128 *)CharaOldPos = *(u_long128 *)position;
            if (next_sub_map > 0) {
                now_load_map_no = next_sub_map;
                LoadSubMap(MainScene__2, next_sub_map, 1);
                MainScene__2->PreLoadVillager(next_sub_map, read_buffer_end);
                SubMapLoadBG = 1;
            }
        }
    }
    if (SubMapLoadStep() != 0) {
        while (wait_for_map != 0 && SubMapLoadStep() != 0) {
        }
    }

    if (LoopMode == EDIT_LOOP_WALK_MENU || LoopMode == EDIT_LOOP_EDIT_MENU) {
        menu_pause.scene = MainScene__2;
        menu_pause.event_skip = 0;
        if (PadCtrl.Btn(21) != 0) {
            PauseStart(&menu_pause);
        }
        if (MenuMainLoop() != 0) {
            MenuMainExit();
            if (LoopMode == EDIT_LOOP_WALK_MENU) {
                LoopMode = EDIT_LOOP_WALK;
                if (MenuInfo->end_code != 11 && SubGameRunning() != 0 && GetSubGameNo() == SUBGAME_FISHING) {
                    sgExitSubGame();
                }
                switch (MenuInfo->end_code) {
                    case 1:
                    case 21:
                        if (MenuInfo->end_code == 21) {
                            MainScene__2->fade.CaptureScreen();
                            MainScene__2->fade.CrossFade(20, 1.0f);
                        }
                        ActiveCharaNo = MenuInfo->result[0];
                        ActiveCharaNo = GetUserData__Fv__2()->active_chr_no;
                        chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
                        if (chara != NULL) {
                            chara->UpdatePosition();
                            chara->ResetDAPosition();
                        }
                        EditControlStatusInit(MainScene__2);
                        break;
                    case 11: {
                        SubGameInfo fishing;

                        fishing.scene = MainScene__2;
                        fishing.rod_no = MenuInfo->result[0];
                        fishing.esa_no = MenuInfo->result[1];
                        FishingBuff.stSetBuffer(CharaBufs[0].stack + CharaBufs[0].stack_used,
                                                CharaBufs[0].stack_size - CharaBufs[0].stack_used);
                        fishing.menu_buff = &MenuBuffer__2;
                        fishing.load_buff = &FishingBuff;
                        MenuInfo->end_code = 0;
                        current_subgame = GetNowSubGameInfo();
                        if (SubGameRunning() != 0 && current_subgame->rod_no != fishing.rod_no) {
                            fishing.keep_bgm = 1;
                        }
                        if ((GetMenuEtcFlag() & 0x1) != 0 || SubGameRunning() == 0 || current_subgame->rod_no != fishing.rod_no) {
                            ResetViewMode(MainScene__2);
                            sgInitSubGame(SUBGAME_FISHING, &fishing);
                        } else {
                            sgRestartSubGame(&fishing);
                        }
                        break;
                    }
                    case 6:
                        SetEventScript(NULL, NULL, NULL);
                        if (ControlMode == EDIT_CONTROL_EVENT) {
                            MainScene__2->active_camera = MainScene__2->before_camera;
                            ControlMode = EDIT_CONTROL_PLAYER;
                        }
                        if (MenuInfo->result[0] != LOOP_EDIT) {
                            finish = 1;
                            INIT_LOOP_ARG next_loop;
                            memset(&next_loop, 0, sizeof(next_loop));
                            next_loop.map_no = MenuInfo->result[1];
                            next_loop.floor_no = MenuInfo->result[2];
                            next_loop.event_no = 1010;
                            NextLoop(MenuInfo->result[0], next_loop);
                        } else {
                            BurnEditParts();
                            EditMapJump(MenuInfo->result[1]);
                            MainScene__2->RunEvent(100, NULL);
                        }
                        break;
                }
            } else if (LoopMode == EDIT_LOOP_EDIT_MENU) {
                MainScene__2->GetMap(MainScene__2->active_map);
                MainScene__2->GetCharacter(MainScene__2->player_chara);
                LoopMode = EDIT_LOOP_EDIT;
                MainScene__2->before_camera = MainScene__2->active_camera;
                MainScene__2->active_camera = 3;
                StartEditModeFromMenu(MainScene__2, MenuInfo->end_code, MenuInfo->result);
            }
        }
        FadeOutForE3();
        MainScene__2->fade.FadeStep();
        MainScene__2->fade.Draw();
        if (finish != 0) {
            PreExitLoop(MainScene__2);
            return 1;
        }
        return TimeLimitCheck() != 0;
    }

    if (DebugFlag != 0 && EdDebugInfo.jump_map_no >= 0) {
        BurnEditParts();
        EditMapJump(EdDebugInfo.jump_map_no);
        MainScene__2->RunEvent(100, NULL);
        EdDebugInfo.jump_map_no = -1;
        return 0;
    }
    mgPlightEnable(0);
    MainScene__2->UpDateMapInfo();
    projection = mgGetProjection() + PhotoAddProjection();
    if (strcmp(MainScene__2->GetMapName(MainScene__2->active_map), "s32") == 0 ||
        strcmp(MainScene__2->GetMapName(MainScene__2->active_map), "s55") == 0) {
        projection = 250.0f;
    }
    if (projection < 300.0f) {
        projection = 300.0f;
    }
    if (projection > 1000.0f) {
        projection = 1000.0f;
    }
    mgSetRenderInfo(projection, 3.0f, 30000.0f);
    S51Thunder(MainScene__2);
    menu_mode = LoopMode;
    open_menu = 0;
    change_mode = 0;
    return_to_player = 0;
    start_event = -1;
    pause.scene = MainScene__2;
    pause.event_skip = 0;
    pause_enabled = 0;
    if (PauseFlag == 0) {
        switch (ControlMode) {
            case EDIT_CONTROL_PLAYER:
                pause_enabled = 1;
                pause.event_skip = 0;
                if (SubGameRunning() != 0) {
                    sgLoopSubGame();
                } else {
                    if (LockChara == 0 && IsEditMode() != 0) {
                        EditMode(MainScene__2);
                        GamePad__2.SetAutoRepeat2(PAD_L2 | PAD_R2, 13, 2);
                        GamePad__2.SetAutoRepeat2(PAD_UP | PAD_RIGHT | PAD_DOWN | PAD_LEFT, 13, 2);
                    }
                    event_result = EditEvent.Step(MainScene__2);
                    CSceneEventData event_data;
                    memset(&event_data, 0, sizeof(event_data));
                    reset_event = 0;
                    switch (event_result) {
                        case EDIT_EVENT_RESULT_END:
                            reset_event = 1;
                            EditDataSave();
                            break;
                        case EDIT_EVENT_RESULT_ENTER:
                        case EDIT_EVENT_RESULT_ENTER_HOUSE:
                            reset_event = 1;
                            event_data = EditEvent.data;
                            EditGotoInterior(SearchMapNo(EditEvent.map_name), event_result == EDIT_EVENT_RESULT_ENTER_HOUSE);
                            MainScene__2->RunEvent(100, &event_data);
                            break;
                        case EDIT_EVENT_RESULT_EXIT:
                            reset_event = 1;
                            event_data = EditEvent.data;
                            EditExitInterior(0);
                            MainScene__2->RunEvent(100, &event_data);
                            break;
                        case EDIT_EVENT_RESULT_MENU:
                            open_menu = 1;
                            menu_mode = EDIT_LOOP_WALK_MENU;
                            break;
                    }
                    if (reset_event != 0) {
                        EditEvent.Reset();
                        UnLockCharaCtrl();
                    }
                    if (LoopMode == EDIT_LOOP_WALK) {
                        if (LockChara == 0) {
                            EditControl(MainScene__2, &PadCtrl);
                        } else {
                            EditControl(MainScene__2, NULL);
                        }
                        GamePad__2.AutoRepeatOff();
                        MainScene__2->EyeViewDrawOnOff(IsWalkMode() == 0);
                        if (LockChara == 0 && MainScene__2->event_run == 0 && PadCtrl.Btn(0) != 0 && IsWalkMode() != 0) {
                            chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
                            chara->GetPosition(talk_position);
                            chara->GetPosition(talk_height);
                            talk_position[3] = talk_height[1];
                            CSceneEventData talk_event;
                            memset(&talk_event, 0, sizeof(talk_event));
                            if (MainScene__2->GetTalkEvent(talk_position, &talk_event) != 0) {
                                MainScene__2->RunEvent(1000, &talk_event);
                                printf("chara No = %d\n", talk_event.chara_no);
                            }
                        }
                    }
                }
                break;
            case EDIT_CONTROL_EVENT:
                pause.event_skip = 1;
                pause_enabled = 1;
                if (CheckEventSkip() == 0) {
                    pause.event_skip = 0;
                }
                switch (EventLoop()) {
                    case 17:
                        change_mode = 1;
                        return_to_player = 1;
                        break;
                    case 18:
                        ResetEditEvent();
                        return_to_player = 1;
                        break;
                    case 19:
                        RestartEditEvent();
                        return_to_player = 1;
                        break;
                    case 1:
                        return_to_player = 1;
                        break;
                    case 2:
                        menu_mode = EDIT_LOOP_WALK_MENU;
                        open_menu = 1;
                        break;
                    case 3:
                        finish = 1;
                        break;
                    case 8:
                        BurnEditParts();
                        EditMapJump(SearchMapNo(EdEventInfo.jump_map_name));
                        start_event = EdEventInfo.event_no;
                        if (start_event < 0) {
                            start_event = 100;
                        }
                        printf("start_event = %d\n", start_event);
                        EdEventInfo.event_no = -1;
                        break;
                    case 4:
                        EditGotoInterior(SearchMapNo(EdEventInfo.jump_map_name), EdEventInfo.interior_entrance);
                        start_event = EdEventInfo.event_no;
                        if (start_event < 0) {
                            start_event = 100;
                        }
                        printf("start_event = %d\n", start_event);
                        EdEventInfo.event_no = -1;
                        break;
                    case 7:
                        EditExitInterior(0);
                        start_event = EdEventInfo.event_no;
                        if (start_event < 0) {
                            start_event = 100;
                        }
                        printf("start_event = %d\n", start_event);
                        EdEventInfo.event_no = -1;
                        break;
                    default:
                        if (DebugFlag != 0 && ChkEventEditStart() != 0) {
                            ControlMode = EDIT_CONTROL_EVENT_EDIT;
                        }
                        break;
                }
                if (return_to_player != 0) {
                    ControlMode = EDIT_CONTROL_PLAYER;
                    MainScene__2->active_camera = MainScene__2->before_camera;
                }
                if (start_event > 0) {
                    MainScene__2->RunEvent(start_event, NULL);
                }
                break;
            case EDIT_CONTROL_EVENT_EDIT:
                if (EventEdit(&WorkBuffer) == 0) {
                    ControlMode = EDIT_CONTROL_EVENT;
                }
                break;
        }
        if (pause_enabled != 0 && (PadCtrl.Btn(21) != 0 || GamePad__2.Connect() == 0)) {
            PauseStart(&pause);
        }
        WalkChara = MainScene__2->GetCharacter(MainScene__2->player_chara);
        if (WalkChara != NULL) {
            WalkChara->foot_se_bank = MainScene__2->se_base_id;
        }
        EditStep();
        if (WalkChara != NULL) {
            WalkChara->GetPosition(villager_position);
            villager_position[3] = 30.0f;
            MainScene__2->StayNearVillager(villager_position, stay);
        }
        if (LoopMode == EDIT_LOOP_WALK) {
            MainScene__2->StepVillager();
        }
        MainScene__2->CancelStayVillager(stay);
        sgLoopSubGame2();
        if (open_menu == 0 && LockChara == 0 && sgMenuOpenEnable() != 0 && change_mode == 0) {
            menu_requested = PadCtrl.Btn(5) != 0 || sgGetItemOver() != 0;
            menu_button = PadCtrl.Btn(5);
            quick_change = EditOnGround() != 0 && PadCtrl.Btn(23) != 0 && SubGameRunning() == 0;
            if (MainScene__2->fade.NowFade() != 0 && MainScene__2->fade.cross != 0) {
                quick_change = 0;
            }
            next_chara = GetUserData__Fv__2()->active_chr_no == 0;
            if ((GetUserData__Fv__2()->CheckQuickChange(next_chara, NULL) & 0x1) == 0) {
                quick_change = 0;
            }
            if (IsWalkMode() == 0 || GetPauseFlag() != 0) {
                quick_change = 0;
            }
            menu_enabled = 1;
            if (LoopMode != EDIT_LOOP_EDIT && SubGameRunning() == 0 && EditOnGround() == 0) {
                menu_enabled = 0;
            }
            if (menu_enabled != 0 && LoopCounter >= 3 && ControlMode == EDIT_CONTROL_PLAYER &&
                (menu_requested != 0 || quick_change != 0 || menu_button != 0)) {
                ShowOffOnceHelpMes();
                if (LoopMode == EDIT_LOOP_WALK) {
                    if (menu_requested != 0) {
                        if (NowTakePhoto() != 0) {
                            if (IsEnablePhotoMenu() != 0) {
                                MenuInfo->open_type = MENU_OPEN_INVENT;
                                HidePhoto();
                                menu_mode = EDIT_LOOP_WALK_MENU;
                                open_menu = 1;
                            }
                        } else {
                            menu_mode = EDIT_LOOP_WALK_MENU;
                            open_menu = 1;
                            MenuInfo->open_type = MENU_OPEN_MAIN_TOWN;
                        }
                    } else {
                        open_menu = 1;
                        menu_mode = EDIT_LOOP_WALK_MENU;
                        MenuInfo->open_type = MENU_OPEN_MAIN_CHARA_BG;
                        MenuInfo->param[0] = next_chara;
                    }
                } else if (LoopMode == EDIT_LOOP_EDIT && menu_button != 0) {
                    EditDataSave();
                    LoopMode = EDIT_LOOP_EDIT_PRE_MENU;
                    MenuInfo->open_type = MENU_OPEN_GEORAMA;
                    PreEditMenuCnt = 0;
                    EditModeControlLock();
                    if (menu_button != 0) {
                        MenuInfo->param[0] = -1;
                    } else {
                        EditPreMenuAnime(25);
                        MenuInfo->param[0] = GetSelPartsInfoID();
                    }
                }
            }
        }
        if (open_menu != 0) {
            EditDrawFlag |= 0x1;
        }
    }

    mgFlushRenderInfo();
    EditEvent.Draw(MainScene__2);
    EditDraw();
    debug_closed = 0;
    if (DebugFlag != 0) {
        if (EditDebugMode() != 0 && EditDebugLoop(MainScene__2, &EdDebugInfo) != 0) {
            ControlMode = old_cm;
            debug_closed = 1;
            if (ControlMode == EDIT_CONTROL_DEBUG) {
                ControlMode = EDIT_CONTROL_PLAYER;
            }
        }
        if (ControlMode != EDIT_CONTROL_DEBUG && GamePad__2.Down(PAD_R3) != 0 && debug_closed == 0) {
            EditDebugStart(215, &MenuBuffer__2);
            old_cm = ControlMode;
            ControlMode = EDIT_CONTROL_DEBUG;
        }
        LightingEdit(MainScene__2);
    }
    if (PauseFlag == 0) {
        if (LockChara == 0 && NowEditModeChg() == 0) {
            edit_enabled = 1;
            debug_move = DebugInfo.chara_move > 0;
            chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
            if (debug_move == 0) {
                if ((GetSaveData()->GetBitCtrl() & 0x2) != 0) {
                    edit_enabled = 0;
                }
                main_map_no = MainScene__2->GetMainMapNo();
                if (main_map_no < 0 || main_map_no >= 5) {
                    edit_enabled = 0;
                }
            }
            if (PadCtrl.Btn(108) != 0) {
                change_mode = 1;
            }
            if (open_menu != 0) {
                change_mode = 0;
            }
            if (SubGameRunning() != 0) {
                change_mode = 0;
            }
            if (edit_enabled != 0 && chara != NULL && ControlMode == EDIT_CONTROL_PLAYER && change_mode != 0) {
                chara->GetPosition(edit_position);
                if (LoopMode == EDIT_LOOP_WALK) {
                    if (CheckWalkToEdit(MainScene__2, edit_position) != 0 || debug_move != 0) {
                        open_menu = 0;
                        ResetViewMode(MainScene__2);
                        MainScene__2->before_camera = MainScene__2->active_camera;
                        MainScene__2->active_camera = 3;
                        StartEditMode(MainScene__2);
                        LoopMode = EDIT_LOOP_EDIT;
                        KeepEditAnalyze();
                        chara->SetMotion("\x97\xA7\x82\xBF", 0);
                        MainScene__2->map_event_no = 0;
                    }
                } else if (LoopMode == EDIT_LOOP_EDIT && (CheckEditToWalk(MainScene__2, return_position) != 0 || debug_move != 0)) {
                    LoopMode = EDIT_LOOP_WALK;
                    open_menu = 0;
                    EndEditMode(MainScene__2, return_position);
                    EditControlStatusInit(MainScene__2);
                    camera = (CCameraControl *)MainScene__2->GetCamera(MainScene__2->active_camera);
                    camera_angle = 0.0f;
                    if (camera != NULL) {
                        camera_angle = camera->GetAngle();
                        camera->GetPos(camera_position);
                        camera->GetRef(camera_reference);
                    }
                    walk_camera = (CCameraControl *)MainScene__2->GetCamera(0);
                    if (walk_camera != NULL) {
                        walk_camera->FollowOff();
                        walk_camera->SetRef(camera_reference);
                        camera_position[1] += 0.1f;
                        walk_camera->SetPos(camera_position);
                        walk_camera->SetAngle(camera_angle);
                        walk_camera->Step(-1);
                        walk_camera->FollowOn();
                    }
                    MainScene__2->active_camera = 0;
                    EditDataSave();
                    GeoUpdateNpcPos(MainScene__2);
                    if (GetGameChapter(GetSaveData()->game_progress) < 8) {
                        change_event = -1;
                        if (MapNo == 0 && GetSaveData()->GetBitFlag(0x21) != 0 && GetSaveData()->GetBitFlag(0x22) == 0) {
                            change_event = 507;
                        }
                        if (change_event < 0 && EditAnalyzeChanged() != 0) {
                            change_event = 310;
                        }
                        if (change_event > 0) {
                            EditModeChg(change_event);
                        }
                    }
                }
            }
        }
        if (LoopMode == EDIT_LOOP_EDIT_PRE_MENU) {
            PreEditMenuCnt++;
            if (MenuInfo->param[0] < 0 || PreEditMenuCnt >= 25) {
                menu_mode = EDIT_LOOP_EDIT_MENU;
                MenuInfo->open_type = MENU_OPEN_GEORAMA;
                open_menu = 1;
                EditModeControlUnLock();
            }
        }
        if (open_menu != 0) {
            EditDrawFlag &= ~0x1;
            if (MainScene__2->bg_load_step <= 0) {
                if (MainScene__2->fade.NowFade() != 0 && MainScene__2->fade.cross != 0) {
                    MainScene__2->fade.FadeIn(0);
                }
                MenuInfo->scene = MainScene__2;
                if (MenuDataBuf != NULL) {
                    LoopMode = menu_mode;
                    MenuMainInit(MenuInfo);
                    if (sgGetItemOver() != 0) {
                        sgGetItemOverReset();
                    }
                }
            }
        }
        {
            static char init;

            if (init == 0) {
                rain_flag = 0;
                init = 1;
            }
        }
        if (GamePad__2.Down2(PAD_R2) != 0) {
            if (rain_flag == 0) {
                EventRain.Start();
            } else {
                EventRain.Stop();
            }
            rain_flag = rain_flag == 0;
        }
        MainScene__2->fade.FadeStep();
    }
    MainScene__2->fade.Draw();
    if (PauseFlag != 0) {
        pause_result = PauseMenu();
        if (pause_result == 1) {
            PauseFlag = 0;
        }
        if (pause_result == 2) {
            finish = 1;
        }
    }
    DrawEventEdit();
    FadeOutForE3();
    if (DebugFlag != 0) {
        static int start_bt_cnt;
        static int encount_flag;
        static int show_encount_cnt;
        static int next_encount;

        {
            static char init;

            if (init == 0) {
                start_bt_cnt = 0;
                init = 1;
            }
        }
        {
            static char init;

            if (init == 0) {
                encount_flag = 1;
                init = 1;
            }
        }
        {
            static char init;

            if (init == 0) {
                show_encount_cnt = 0;
                init = 1;
            }
        }
        {
            static char init;

            if (init == 0) {
                next_encount = -1;
                init = 1;
            }
        }

        if (show_time_step > 0 || show_encount_cnt > 0) {
            mgCDrawPrim prim;

            prim.Initialize(NULL, NULL);
            prim.DepthTestEnable(0);
            prim.AlphaBlendEnable(0);
            prim.ZMask(1);
            prim.TextureMapEnable(0);
            if ((show_time_step > 0 && time_step != 0) || (show_encount_cnt > 0 && encount_flag != 0)) {
                prim.Begin(MG_PRIM_TRIANGLE);
                if (show_encount_cnt > 0) {
                    prim.Color(255, 0, 0, 128);
                } else {
                    prim.Color(255, 255, 255, 128);
                }
                prim.Vertex(450, 10, 0);
                prim.Vertex(480, 25, 0);
                prim.Vertex(450, 40, 0);
                prim.End();
            } else {
                prim.Begin(MG_PRIM_SPRITE);
                if (show_encount_cnt > 0) {
                    prim.Color(255, 0, 0, 128);
                } else {
                    prim.Color(255, 255, 255, 128);
                }
                prim.Vertex(450, 10, 0);
                prim.Vertex(480, 40, 0);
                prim.End();
            }
        }
        show_time_step--;
        show_encount_cnt--;
        if (show_time_step < 0) {
            show_time_step = 0;
        }
        if (show_encount_cnt < 0) {
            show_encount_cnt = 0;
        }
    }
    if (DebugFlag != 0 && GamePad__2.On(PAD_SELECT) != 0 && GamePad__2.Down(PAD_START) != 0) {
        finish = 1;
    }
    if (MainScene__2->exit_flag != 0) {
        finish = 1;
    }
    if (finish != 0) {
        PauseCancel();
        PreExitLoop(MainScene__2);
        return 1;
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditLoop__Fv);
#endif
void InitEditEvent(void) {
    InitLockCharaCtrl();
    Reset__10CEditEventFv(&EditEvent);
}
void ResetEditEvent() {
    if (EditEvent.state == 1) {
        Reset__10CEditEventFv(&EditEvent);
        UnLockCharaCtrl();
    }
}
void RestartEditEvent() {
    if (EditEvent.state == 1) {
        ResetEditEvent();
        if (EditEvent.StartEvent(&MainScene__2->event_data) != 0) {
            LockCharaCtrl();
        }
    }
}
int EditStep(void) {
    CEditMap *maps[8];
    float viewer[24];
    int event_no;
    int map_count;
    int index;
    CSceneEventData *event_data;
    CCameraControl *camera;
    CEditMap *map;
    CCharacter2 *chara;

    chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
    WalkChara = chara;
    if (chara != NULL) {
        chara->foot_se_bank = MainScene__2->se_base_id;
    }
    EditModeChgStep(MainScene__2);
    if (MainScene__2->event_run != 0) {
        event_no = MainScene__2->event_no;
        printf(at_2261, event_no);
        event_data = &MainScene__2->event_data;
        if (event_no == kEventNoMapJump) {
            if (EditEvent.StartEvent( event_data) != 0) {
                camera = (CCameraControl *)MainScene__2->GetCamera(MainScene__2->active_camera);
                if (camera == NULL || camera->Iam() != kCameraKindEvent) {
                    return 0;
                }
                if ((event_data->event.flag & kEventDataCallFlag) != 0) {
                    event_no = event_data->event.unk_34;
                    if (event_no > 0) {
                        printf(at_2262, event_no);
                        if (RunEvent(event_data->event.unk_34, MainScene__2) > 0) {
                            ResetViewMode(MainScene__2);
                            ControlMode = 2;
                        }
                    }
                }
                LockCharaCtrl();
            }
        } else {
            InitEvent(MainScene__2);
            MainScene__2->before_camera = MainScene__2->active_camera;
            if (RunEvent(event_no, MainScene__2) > 0) {
                ResetViewMode(MainScene__2);
                ControlMode = 2;
            }
        }
        MainScene__2->event_run = 0;
    }
    if (GamePad__2.Down2(0x80) != 0) {
        InitEvent(MainScene__2);
        ReloadMapScript();
        MainScene__2->before_camera = MainScene__2->active_camera;
        if (RunEvent(kKeyOpenEvent, MainScene__2) != 0) {
            ControlMode = 2;
        }
    }
    map_count = MainScene__2->GetActiveMap((CMap **)maps, 8);
    if (WalkChara != NULL) {
        *(u_long128 *)viewer = *(u_long128 *)WalkChara->position;
        viewer[4] = MainScene__2->time;
        index = 0;
        if (0 < map_count) {
            do {
                map = maps[index];
                if (map != NULL) {
                    map->AnimeStep((CObjAnimeEnv *)viewer);
                    maps[index]->Step();
                }
                index += 1;
            } while (index < map_count);
        }
    }
    MainScene__2->PrePlaySeSrc();
    MainScene__2->PlayMapSeSrc();
    if (LoopMode != 2) {
        EditStepChara(MainScene__2);
    }
    MainScene__2->EffectStep();
    MainScene__2->StepEffectScript(-1);
    if (InInterior() == 0) {
        StepFirePowder(MainScene__2);
        StepGeyserEffect(MainScene__2);
    }
    camera = (CCameraControl *)MainScene__2->GetCamera(MainScene__2->active_camera);
    if (camera != NULL) {
        camera->Step(1);
    }
    EditExceptionStep(MapNo, MainScene__2);
    EventMes1.Step();
    GetSystemMessage()->Step();
    GetSystemMessage(1)->Step();
    GetSystemMessage(2)->Step();
    StepHelpMes();
    return 1;
}
#ifdef NONMATCHING
int EditDraw() {
    static int                 flag;
    static char                init;
    CMap                      *maps[8];
    CMap                      *map;
    CEditMap                  *edit_map;
    CPartsGroup               *ghost_group;
    CList<PartsGroupData>     *group_entry;
    CMapParts                 *parts;
    CList<CMapPiece>          *piece;
    CCharacter2               *chara;
    mgCCamera                 *camera;
    mgCTexture                *water;
    mgCTexture                *screen;
    mgCTexture                *overlay;
    CInventUserData           *invent;
    USER_PICTURE_INFO         *picture;
    CFuncPoint                *subject;
    CScene::InScreenCharaInfo  screen_chara;
    InScreenFuncInfo           screen_func;
    sceVu0FMATRIX             view_matrix;
    sceVu0FVECTOR             camera_pos = { 0.0f, 0.0f, 100.0f, 0.0f };
    sceVu0FVECTOR             camera_dir;
    sceVu0FVECTOR             walk_pos;
    sceVu0FVECTOR             player_pos;
    sceVu0FVECTOR             system_pos;
    sceVu0FVECTOR             screen_range;
    sceVu0FVECTOR             lighting;
    float                     blur_range[2];
    float                     photo_dist;
    int                       texture_order[65];
    int                       texture_blocks[128];
    int                       later_texture_blocks[128];
    int                       map_count;
    int                       map_draw;
    int                       ghost_visible;
    int                       water_block;
    int                       block_count;
    int                       map_index;
    int                       texture_group;
    int                       block_index;
    int                       block;
    int                       dof_off;
    int                       chara_no;
    int                       idea_no;
    int                       show_system;
    int                       main_map_no;
    int                       exit_flag;

    if (EditDrawCancelFlag != 0) {
        EditDrawCancelFlag = 0;
        return 0;
    }

    map_draw = EdEventInfo.map_draw;
    map_count = MainScene__2->GetActiveMap(maps, 8);
    mgSetPkTextureRepeat(0);
    MainScene__2->GetCamera(MainScene__2->active_camera);
    camera = MainScene__2->GetCamera(MainScene__2->active_camera);
    if (camera != NULL) {
        camera->GetCameraMatrix(view_matrix);
        camera->GetPos(camera_pos);
        camera->GetDir(camera_dir);
        mgSetViewMatrix(view_matrix, camera_pos);
        sndSetMicPos(camera_pos, camera_dir);
        MainScene__2->FixCameraPartsOnOff(camera_pos);
    }

    MainScene__2->DrawSky(-1);
    map = MainScene__2->GetMap(MainScene__2->active_map);
    edit_map = NULL;
    if (map != NULL && strcmp(map->Iam(), "CEditMap") == 0) {
        edit_map = (CEditMap *)map;
    }
    if (map_draw != 0 && edit_map != NULL) {
        edit_map->DrawRiverMask();
    }

    ghost_visible = GhostPhotoTiming();
    if (CheckTime(MainScene__2->time, 0.0f, 4.0f) == 0) {
        ghost_visible = 0;
    }
    for (map_index = 0; map_index < map_count; map_index++) {
        ghost_group = maps[map_index]->SearchPartsGroup("ghost");
        if (ghost_group != NULL) {
            for (group_entry = ghost_group->list; group_entry != NULL; group_entry = group_entry->next) {
                parts = group_entry->data.parts;
                if (parts != NULL) {
                    piece = parts->piece_list;
                    if (piece != NULL) {
                        piece->data.fade = 1;
                        piece->data.Show(ghost_visible);
                        if (ghost_visible != 0) {
                            piece->data.fade_alpha = 1.0f;
                        }
                        if ((double)piece->data.fade_alpha <= 0.0) {
                            parts->Show(0);
                        } else {
                            parts->Show(1);
                        }
                    }
                }
            }
        }
    }

    WorkBuffer.stack_used = 0;
    WorkBuffer.lock = 0;
    for (block_index = 0; block_index < 64; block_index++) {
        texture_order[block_index] = block_index;
    }
    texture_order[64] = -1;
    mgBeginDraw(&WorkBuffer, texture_order, NULL);

    if (map_draw != 0) {
        if (edit_map != NULL) {
            edit_map->DrawRiver();
        }
        EditPlaceAnime();
        for (map_index = 0; map_index < map_count; map_index++) {
            if (WalkChara != NULL) {
                WalkChara->GetPosition(walk_pos);
            }
            maps[map_index]->PreDraw(walk_pos);
            maps[map_index]->Draw();
        }
        mgSetPkTextureRepeat(1);
        if (IsEditMode() != 0 && edit_map != NULL) {
            DrawEditCursorParts(MainScene__2);
            EditPlaceAnimeDraw();
        }
        EditPlaceAnime2();
        water = mgTexManager.GetTexture("water", -1);
        water_block = -1;
        if (water != NULL) {
            water_block = water->block;
            WaveTable.GetEffect();
        }
        mgPreEndDraw(NULL);
        for (texture_group = 0; texture_group < 6; texture_group++) {
            block_count = MainScene__2->mds_list_set.GetTextureBlockNo(texture_group, texture_blocks, 128);
            for (block_index = 0; block_index < block_count; block_index++) {
                block = texture_blocks[block_count - block_index - 1];
                if (mgEndDrawReloadTexture(block, NULL) != 0 && water_block == block) {
                    WaveTable.CreateTexture(water);
                }
                mgEndDraw(block, NULL);
            }
        }
        mgSetPkTextureRepeat(0);
        sgDrawSubGameMap();
        map = MainScene__2->GetMap(MainScene__2->active_map);
        dof_off = 0;
        if (map != NULL) {
            map->GetNowTimeBand();
        }
        if (GetSaveData() != NULL) {
            dof_off = GetSaveData()->config.dof_off;
        }
        if (dof_off != 0 && IsEditMode() == 0) {
            blur_range[0] = 1000.0f;
            blur_range[1] = 2000.0f;
            screen = mgTexManager.GetTexture("work", 0x9C);
            mgTexManager.ReloadTexture(0x9C, (sceVif1Packet *)NULL);
            DepthOfField(2, blur_range, screen, 1.0f);
        } else {
            map = MainScene__2->GetMap(MainScene__2->active_map);
            if (map != NULL) {
                map->GetLightingRatio(lighting);
            }
            blur_range[0] = 3000.0f;
            blur_range[1] = 4000.0f;
            screen = mgTexManager.GetTexture("work", 0x9C);
            mgTexManager.ReloadTexture(0x9C, (sceVif1Packet *)NULL);
            DepthOfField(1, blur_range, screen, 1.0f);
        }
    }

    EdEventFirstDraw();
    if (TreasureBox != NULL) {
        map = MainScene__2->GetMap(MainScene__2->active_map);
        if (map != NULL) {
            map->DrawTrBox();
        }
    }
    if (LoopMode == EDIT_LOOP_WALK) {
        mgTexManager.ReloadTexture(0x9F, (sceVif1Packet *)NULL);
        screen = mgTexManager.GetTexture("shadow_work", 0x9F);
        mgBeginDrawShadow(screen, NULL);
        EditDrawShadowChara(MainScene__2);
        sgDrawSubGameCharaShadow();
        mgEndDrawShadow(screen, NULL);
        chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
        if (chara != NULL) {
            chara->SetFadeFlag(1);
            chara->SetNearDist(25.0f);
        }
        EditDrawChara(MainScene__2);
    }
    sgDrawSubGameChara();
    mgSetPkTextureRepeat(1);
    if (map_draw != 0) {
        for (texture_group = 6; texture_group < 16; texture_group++) {
            block_count = MainScene__2->mds_list_set.GetTextureBlockNo(texture_group, later_texture_blocks, 128);
            for (block_index = 0; block_index < block_count; block_index++) {
                block = later_texture_blocks[block_index];
                mgEndDrawReloadTexture(block, NULL);
                mgEndDraw(block, NULL);
            }
        }
    }
    MainScene__2->DrawEffectScript(-1);
    if (InInterior() == 0) {
        DrawFirePowder(MainScene__2);
        DrawGeyserEffect(MainScene__2);
    }
    MainScene__2->DrawExclamationMark(RedBicMark);
    chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
    if (chara != NULL) {
        chara->GetPosition(player_pos);
        if (BlueBicMark != NULL) {
            BlueBicMark->SetPosition(player_pos);
        }
        exit_flag = MainScene__2->map_event_no;
        if ((exit_flag & 0x1) != 0) {
            if (RedBicMark != NULL) {
                RedBicMark->SetPosition(0.0f, 0.0f, 0.0f);
                RedBicMark->SetPosition(player_pos);
                RedBicMark->SetRotation(0.0f, 0.0f, 0.0f);
            }
            mgDrawDirect(RedBicMark);
        }
        if ((exit_flag & 0x2) != 0) {
            mgDrawDirect(BlueBicMark);
        }
    }
    EditDrawEffectChara(MainScene__2);
    if (map_draw != 0) {
        screen = mgTexManager.GetTexture("water_work", 0x9E);
        overlay = mgTexManager.GetTexture("ref", 0x9E);
        camera = MainScene__2->GetCamera(MainScene__2->active_camera);
        for (map_index = 0; map_index < map_count; map_index++) {
            maps[map_index]->DrawWater(camera, screen, overlay);
        }
    }
    if (IsEditMode() != 0 && edit_map != NULL) {
        mgTexManager.ReloadTexture(0xA3, (sceVif1Packet *)NULL);
        DrawEditCursor(MainScene__2);
        EditPEffectStep();
        EditPEffectDraw(0xA3);
    }
    if (map_draw != 0) {
        MainScene__2->DrawEffect(0x42);
        mgTexManager.ReloadTexture(0xA4, (sceVif1Packet *)NULL);
        MainScene__2->DrawGameObject(MapNo);
    }
    sgDrawSubGameEffect();
    EdEventDraw();
    mgSetPkTextureRepeat(0);
    if (InInterior() == 0) {
        MainScene__2->DrawLensFlare(0x9D, "f_work", "f_work2");
    }
    sgDrawSubGameSystem();
    if (DebugFlag != 0 && DebugInfo.invent_debug == 1) {
        MainScene__2->DrawScreenFunc(&TestFrame);
    }

    if (NowTakePhoto() == 0) {
        InitNpcCameraReaction();
    } else {
        mgTexManager.ReloadTexture(0xA2, (sceVif1Packet *)NULL);
        mgTexManager.GetTexture("fix_work", -1);
        invent = NULL;
        if (GetUserData__Fv__2() != NULL) {
            invent = &GetUserData__Fv__2()->invent_data;
        }
        if (init == 0) {
            flag = 0;
            init = 1;
        }
        screen_chara.chara_no = -1;
        screen_chara.dist = 0.0f;
        screen_chara.in_center = 0;
        chara_no = MainScene__2->InScreenChara(&screen_chara, screen_range);
        chara = MainScene__2->GetCharacter(chara_no);
        if (chara_no >= 0 && chara != NULL && chara->GetKeyListPtr("\x83\x4A\x83\x81\x83\x89", NULL) != NULL) {
            MainScene__2->ExModeVillager(chara_no);
        }
        picture = invent->IsPhotoSpace(NULL);
        if (DrawTakePhoto(picture, &photo_dist) != 0 && picture != NULL) {
            screen_func.range = -1.0f;
            screen_func.unk_04 = 0;
            screen_func.dist = -1.0f;
            screen_func.range = photo_dist;
            subject = MainScene__2->InScreenFunc(&screen_func);
            picture->map_no = MainScene__2->GetMainMapNo();
            idea_no = -1;
            picture->neta_id = -1;
            picture->npc_no = -1;
            if (subject != NULL) {
                idea_no = subject->invent.unk_20;
            }
            if (idea_no == 196 && MainScene__2->GetMainMapNo() == 2) {
                idea_no = 2006;
            }
            if (screen_chara.dist < 5.0f + photo_dist) {
                picture->npc_no = screen_chara.chara_no;
                if (screen_chara.in_center != 0 && screen_chara.chara_no == 14) {
                    idea_no = 36;
                    picture->npc_no = -1;
                }
            }
            if (idea_no > 0) {
                picture->neta_id = idea_no;
                sndSePlay(GetSystemSndID(), 14, 0);
                printf("invent_no = %d\n", picture->neta_id);
            }
            SetTookPhotoData(picture);
        }
        if ((EditDrawFlag & 0x1) == 0) {
            DrawTakePhotoSystem(0x9A, invent);
        }
    }

    show_system = DebugInfo.param_off == 0;
    if ((GetSaveData()->GetBitCtrl() & 0x2) != 0) {
        show_system = 0;
    }
    main_map_no = MainScene__2->GetMainMapNo();
    if (main_map_no < 0 || main_map_no >= 5) {
        show_system = 0;
    }
    if (ControlMode != EDIT_CONTROL_PLAYER) {
        show_system = 0;
    }
    if (LoopMode != EDIT_LOOP_EDIT && LoopMode != EDIT_LOOP_WALK) {
        show_system = 0;
    }
    if (IsWalkMode() == 0) {
        show_system = 0;
    }
    if (SubGameRunning() != 0) {
        show_system = 0;
    }
    if (show_system != 0) {
        chara = MainScene__2->GetCharacter(MainScene__2->player_chara);
        if (chara != NULL) {
            chara->GetPosition(system_pos);
        }
        DrawEditSystem(0xA3, MainScene__2, system_pos, LoopMode == EDIT_LOOP_EDIT);
    }
    mgTexManager.ReloadTexture(0x9A, (sceVif1Packet *)NULL);
    EventMes1.DrawMesWin();
    GetSystemMessage()->DrawMesWin();
    GetSystemMessage(1)->DrawMesWin();
    GetSystemMessage(2)->DrawMesWin();
    DrawHelpMes();
    DrawEditHelpMes();
    EventTimeDraw();
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditDraw__Fv);
#endif
void UpdateTrBoxFlag(int map_no) {
    int i;
    CMapFlagData *flag_data = (CMapFlagData *)GetSaveData()->GetMapFlag(map_no);
    CMap *map = MainScene__2->GetMap(MainScene__2->active_map);
    map->UpdateTrBoxFlag(flag_data);
    int box_count = map->tr_box_num;

    CSaveDataDungeon *dungeon_save = &GetSaveData()->save_dungeon;
    for (i = 0; i < box_count; i++) {
        CMapTreasureBox *box = map->GetTrBox(i);
        if (box != NULL) {

            DNG_FLOOR_SAVE *floor = (DNG_FLOOR_SAVE *)dungeon_save->GetFloorInfoPtr(
                box->floor_id / 100 - 1, box->floor_id % 100);
            if (floor != NULL && (u16)floor->visit_count <= 0) {
                map->DeleteTrBox(i, NULL);
            }
        }
    }
}
int BurnEditParts(void) {
    CEditMap::RemoveInfo info;
    CEditMap *map;
    int i;
    int id;
    if (GetSaveData()->GetBitFlag(0x208) != 0) {
        return 0;
    }
    if (MainScene__2->GetMainMapNo() == 3) {
        map = (CEditMap *)MainScene__2->GetMap(MainScene__2->active_map);
        if (map != NULL) {
            memset(&info, 0, sizeof(info));
            map->BurnEditParts(&info);
            for (i = 0; i < info.house_num; i++) {
                GetSaveData()->user_data.LeaveHouse(info.house_npc[i]);
            }
            id = 0;
            do {
                CEditPartsInfo *river_info = map->GetePartsInfoAtID(id);

                if (river_info != NULL && !(river_info->attr & 0x8000) &&
                    !(river_info->attr & 0x1000)) {
                    int count = info.parts_num[id];
                    if (count > 0) {
                        GetSaveData()->AddBuildPartsNum(id, count);
                    }
                }
                id++;
            } while (id < 0x100);
            return 1;
        }
    }
    return 0;
}
void editLoadSound(int map_no) {
    int sound_data_id;
    int bgm_no;

    sound_data_id = GetMapSndDataID(map_no);
    MainScene__2->LoadSound(sound_data_id, read_buffer);
    if (MainScene__2->skip_load_bgm == 0) {
        bgm_no = MainScene__2->GetDefBgmNo(sound_data_id);
        if (bgm_no == -1) {
            MainScene__2->StopBGM(0);
        }

        if ((MainScene__2->CheckLoadBGM(bgm_no) == 0) || (bgm_no == 0x270F)) {
            MainScene__2->PlayBGM(0, -1, 1.0f);
            return;
        }
        MainScene__2->StopBGM(0);
        if (MainScene__2->LoadBGM(bgm_no, read_buffer) != 0) {
            MainScene__2->PlayBGM(0, -1, 1.0f);
            if (bgm_no == 0) {
                MainScene__2->AutoChangeBGMVol(1);
                MainScene__2->StepSnd();
                sndStep(2.0f);
            }
        }
    } else {
        MainScene__2->skip_load_bgm = 0;
    }
}
int EditMapJump(int map_no) {
    SCN_LOADMAP_INFO2 load_info;
    char path[0x88];
    int file_size;
    char size_text[4];
    int sub_map_no;
    char *map_name;
    mgCMemory *main_data;
    int area_no;
    CEditMap *map;
    mgCTextureManager *textures;
    int used_before;
    CCameraControl *camera;
    CameraCtrlParam *param;
    CEditData *edit_data;
    int loaded_sub;
    int used_quads;
    int used_kb;
    int free_quads;

    InitEditEvent();
    DeleteFileCache();
    textures = &mgTexManager;
    sub_map_no = map_no;
    if (map_no > 0xA && map_no < 0xF) {
        map_no = 0xA;
    } else {
        sub_map_no = -1;
    }
    InitSubMapLoadStep();
    map_name = GetMapName(map_no, NULL);
    if (map_name == NULL) {
        printf(at_2948, map_no);
        return 0;
    }
    MainScene__2->SeAllStop();
    EditDataSave();
    MainScene__2->ResetWind();
    InitSphida();
    mgWaitFrame();
    if (GetMapType(map_no) == 1) {
        SetDataPacket(2);
    } else {
        SetDataPacket(1);
    }
    free_quads = ControlCharaBuff.stack_size;
    ControlCharaBuff.lock = 1;
    MainDataBuff.stSetBuffer((u_long128 *)(ControlCharaBuff.stack + ControlCharaBuff.stack_used),
                             free_quads - ControlCharaBuff.stack_used);
    MainDataBuff.stack_used = 0;
    MainDataBuff.lock = 0;
    printf(at_2949, MainDataBuff.stack + MainDataBuff.stack_used);
    load_info.Initialize();
    if (GetLoadMapInfo(&load_info, map_no) == 0) {
        return 0;
    }
    if (map_no == SearchMapNo(at_2950) &&
        ((CEditData *)GetSaveData()->GetEditData(0))->GetAnalyzeFlag(0, 3) == 0) {
        strcat(load_info.files[0].map_name, at_2951);
        strcat(load_info.files[0].mpk_name, at_2951);
        strcat(load_info.files[0].ipk_name, at_2951);
    }
    MainScene__2->DeleteVillager();
    MainScene__2->DeleteSubVillager();
    MapJump(MainScene__2, &load_info, map_no);
    EditMapInitEvent(map_no, (CEditMap *)MainScene__2->GetMap(0));
    main_data = &MainDataBuff;
    ResetNpcTalkMes();
    if (map_no == 0xA || map_no == 0x22 || map_no == 0x79) {
        main_data->Align64();
        LoadNpcTalkMes(main_data);
    }
    NowLoadingBarStep();
    MapNo = SearchMapNo(map_name);
    MainScene__2->SetNowMapNo(MapNo);
    EdEventMapInit();
    if (GetMapType(MapNo) == 1) {
        used_before = main_data->stack_used;
        map = (CEditMap *)MainScene__2->GetMap(0);
        map->CreateTable(main_data, 0x100, 0xA000);
        GetMapPath(path, map_name);
        sprintf(size_text, at_2952, LanguageCode);
        strcat(path, size_text);
        strcat(path, at_2953);
        if (LoadFile2(path, (void *)read_buffer, &file_size, 0) != 0) {
            LoadEditInfo__13CEditInfoMngrFPciP9mgCMemory(&map->info_mngr, (char *)read_buffer,
                                                         file_size, main_data);
        }
        GetMapPath(path, map_name);
        strcat(path, at_2954);
        if (LoadFile2(path, (void *)read_buffer, &file_size, 0) != 0) {
            map->LoadEditInfo((char *)read_buffer, file_size, main_data);
        }
        map->area_no = MainScene__2->now_map_no;
        map->ClearAllParts();
        used_quads = main_data->stack_used - used_before;
        used_kb = (used_quads * 0x10) / 0x400;
        printf(at_2955, used_kb);
        EditDataLoad();
        if (map_no == 0) {
            map->river_poly_margin = 15.0f;
        }
    }
    NowLoadingBarStep();
    MainScene__2->LoadGameObject(map_no, 0xA4, main_data);
    if (GetMapType(MapNo) == 5) {
        area_no = 0;
        SearchMapNo(at_2950);
        if (map_no == SearchMapNo(at_2956)) {
            area_no = 1;
        }
        if (map_no == SearchMapNo(at_2957)) {
            area_no = 2;
        }
        if (map_no == SearchMapNo(at_2958)) {
            area_no = 3;
        }
        edit_data = (CEditData *)GetSaveData()->GetEditData(area_no);
        map = (CEditMap *)MainScene__2->GetMap(MainScene__2->active_map);
        if (map != NULL) {
            map->PartsOnOff(area_no, edit_data);
        }
    }
    map = (CEditMap *)MainScene__2->GetMap(MainScene__2->active_map);
    if (map != NULL) {
        if (TreasureBox != NULL) {
            CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory((CMap *)map, TreasureBox, 0xAD,
                                                              (int)main_data);
            UpdateTrBoxFlag(MapNo);
        }
        map->now_time = MainScene__2->time;
    }
    InitFirePowder(map_no, MainScene__2, 0xD0, main_data);
    InitGeyserEffect(map_no, MainScene__2, 0xD1, main_data);
    EditControlInit(MainScene__2);
    NowLoadingBarStep();
    editLoadSound(map_no);
    NowLoadingBarStep();
    MainScene__2->DeleteVillager();
    MainScene__2->LoadVillager(MapNo, 0x4E);
    NowLoadingBarStep();
    if (sub_map_no > 0) {
        loaded_sub = LoadSubMap(MainScene__2, sub_map_no, 0);
        NowLoadingBarStep();
        if (loaded_sub != 0) {
            MainScene__2->SetActive(2, 1);
            MainScene__2->LoadSubVillager(GetSubMapNo(), 0x5E);
            EditMapInitEvent(sub_map_no, (CEditMap *)MainScene__2->GetMap(1));
        }
        NowLoadingBarStep();
    } else {
        NowLoadingBarStep();
        NowLoadingBarStep();
    }
    area_no = MapNo;
    if (area_no == SearchMapNo(at_2950)) {
        area_no = 0;
    }
    if (MapNo == SearchMapNo(at_2956)) {
        area_no = 1;
    }
    if (MapNo == SearchMapNo(at_2957)) {
        area_no = 2;
    }
    if (MapNo == SearchMapNo(at_2958)) {
        area_no = 3;
    }
    EdDebugInfo.edit_data_no = area_no;
    EdDebugInfo.edit_data = (CEditData *)GetSaveData()->GetEditData(area_no);
    mgPlightEnable(0);
    MainScene__2->UpDateMapInfo();
    camera = (CCameraControl *)MainScene__2->GetCamera(MainScene__2->active_camera);
    if (camera != NULL) {
        param = camera->GetActiveParam();
        param->min_dist = camera->default_param.min_dist;
        param->max_dist = camera->default_param.max_dist;
        param->near_height = camera->default_param.near_height;
        param->far_height = camera->default_param.far_height;
        param->height = camera->default_param.height;
        param->max_height = camera->default_param.max_height;
        param->min_height = camera->default_param.min_height;
        param->rest_max_height = camera->default_param.rest_max_height;
        param->rest_min_height = camera->default_param.rest_min_height;
        param->ground_space = camera->default_param.ground_space;
        param->no_check = camera->default_param.no_check;
    }
    textures->ReloadTexture(-1, (sceVif1Packet *)NULL);
    LoopCounter = 0;
    EditDrawCancelFlag = 1;
    InitS51Thunder();
    return 1;
}
int EditGotoInterior(int interior_no, int delete_villagers) {
    float door_pos[4];
    int stack;
    CMap *map;
    InitEditEvent();
    DeleteFileCache();
    EditDataSave();
    MainScene__2->StopSeSrc();
    DelMainNPCflag = 0;
    if (delete_villagers != 0) {
        MainScene__2->DeleteVillager();
        DelMainNPCflag = 1;
    }
    MainScene__2->DeleteSubVillager();
    if (InInterior() != 0) {
        InteriorMapJump(MainScene__2, interior_no);
    } else {
        GotoInterior(MainScene__2, interior_no);
    }
    editLoadSound(interior_no);
    stack =
        (int)MainScene__2->GetStack(3);
    map = MainScene__2->GetMap(MainScene__2->active_map);
    if (map != NULL && TreasureBox != NULL) {
        CreateTrBox__4CMapFP15CMapTreasureBoxiP9mgCMemory(map, TreasureBox, 0xAD, stack);
        UpdateTrBoxFlag(interior_no);
    }
    MainScene__2->LoadSubVillager(interior_no, 0x5E);
    MainScene__2->SetActiveVillager();
    EditControlInit(MainScene__2);
    if (EditEvent.door_se >= 0) {
        MainScene__2->SePlayCloseDoor(EditEvent.door_se, door_pos);
    }
    mgPlightEnable(0);
    MainScene__2->UpDateMapInfo();
    return 1;
}
int EditExitInterior(int interior_no) {
    int exit_map_no;
    float door_pos[4];
    int villager_time;
    int saved_time;
    InitEditEvent();
    DeleteFileCache();
    MainScene__2->StopSeSrc();
    MainScene__2->DeleteSubVillager();
    villager_time = MainScene__2->GetNowVillagerTime();
    saved_time =
        MainScene__2->villager_time;
    if (DelMainNPCflag != 0 || villager_time != saved_time) {
        DeleteInterior(MainScene__2);
        MainScene__2->DeleteVillager();
        MainScene__2->LoadVillager(GetMainMapNo(), 0x4E);
    }
    exit_map_no = -1;
    ExitInterior(MainScene__2, &exit_map_no);
    EditMapInitEvent(exit_map_no, (CEditMap *)MainScene__2->GetMap(1));
    MainScene__2->LoadSubVillager(GetSubMapNo(), 0x5E);
    MainScene__2->SetActiveVillager();
    EditControlInit(MainScene__2);
    if (EditEvent.door_se >= 0) {
        MainScene__2->SePlayCloseDoor(EditEvent.door_se, door_pos);
    }
    MainScene__2->LoadSound(GetMapSndDataID(GetMainMapNo()), read_buffer);
    mgPlightEnable(0);
    MainScene__2->UpDateMapInfo();
    return 1;
}
void EditDataSave(void) {
    CEditData *edit_data;
    CEditMap *map;

    if (InInterior() == 0) {
        edit_data = (CEditData *)(GetSaveData()->GetEditData(MapNo));
        if (edit_data != NULL) {
            map = (CEditMap *)(MainScene__2->GetMap(MainScene__2->active_map));
            if ((map != NULL) && (strcmp(map->Iam(), at_2747) == 0) && (map != NULL)) {
                map->SaveData(edit_data);
                GetSaveData()->GetBitFlag(0x208);
                edit_data->culture_point = map->CultureAnalyze(0);
                edit_data->save_count += 1;
                map->GroundBalance(0);
                map->UpdateHouse();
                if ((DebugInfo.georama_debug == 0) && (GetMapType(MapNo) == 1)) {
                    AnalyzeEditMap(MapNo, map);
                }
            }
        }
    }
}
#ifdef NONMATCHING
void EditDataLoad() {
    EP_PLACE_INFO   placement;
    sceVu0FVECTOR  positions[2] = { { 54.0f, 0.0f, 454.0f, 0.0f }, { -103.0f, 0.0f, 397.0f, 0.0f } };
    sceVu0FVECTOR  rotation = { 0.0f, 0.0f, 0.0f, 0.0f };
    CMap          *base;
    CEditMap      *map;
    CEditData     *data;
    CSaveData     *save;
    CEditPartsInfo *info;
    int            slot;
    int            i;

    base = MainScene__2->GetMap(MainScene__2->active_map);
    if (base == NULL) {
        return;
    }
    data = GetSaveData()->GetEditData(MapNo);
    if (data == NULL || strcmp(base->Iam(), "CEditMap") != 0) {
        return;
    }
    map = (CEditMap *)base;
    map->ClearAllParts();
    map->LoadData(data);
    map->InitialPlaceParts(data);
    map->GroundBalance(0);
    map->UpdateHouse();
    if (DebugInfo.georama_debug == 0 && GetMapType(MapNo) == 1) {
        AnalyzeEditMap(MapNo, map);
    }
    save = GetSaveData();
    if (MapNo == 0 && save->GetBitFlag(0xFA) != 0 && save->GetBitFlag(0x3D) == 0) {
        info = map->GetePartsInfoAtID(19);
        for (i = 0; i < 2; i++) {
            if (map->CheckEditParts(info, positions[i], 0.0f, &placement) != 0) {
                slot = map->BuildEditParts(19);
                if (slot >= 0) {
                    map->PlaceEditParts(slot, &placement, positions[i], rotation, NULL);
                }
            }
        }
        save->SetBitFlag(0x3D, 1);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", EditDataLoad__Fv);
#endif
void KeepEditAnalyze() {
    CEditData *edit_data = (CEditData *)GetSaveData()->GetEditData(MapNo);
    for (int entry = 0; entry < 16; entry++) {
        beforeAnalyze[entry] = edit_data->GetAnalyzeFlag(MapNo, entry);
    }
}
int EditAnalyzeChanged() {
    if (GetGameChapter(GetSaveData()->game_progress) >= 8) {
        return 0;
    }
    CEditData *edit_data = (CEditData *)GetSaveData()->GetEditData(MapNo);
    for (int entry = 0; entry < 16; entry++) {
        int analyze_flag = edit_data->GetAnalyzeFlag(MapNo, entry);
        if (analyze_flag != beforeAnalyze[entry]) {
            return 1;
        }
    }
    return 0;
}
void LoadComVillaager(void) {
}
void LoadMap(void) {
    LoadComVillaager();
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editloop", __sinit_editloop_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1045__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1053__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1528__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2271__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_3040__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1032__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1033__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1395__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1396__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1397__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1398__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1399__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1400__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1401__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1402__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1403__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1404__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1405__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1406__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1407__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1408__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1409__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1410__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1411__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1412__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1413__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1414__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1415__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1416__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1417__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1418__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1419__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1420__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1421__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_1422__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2125__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2126__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2127__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2128__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2129__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2130__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2131__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2132__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2133__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2134__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2136__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2261__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2262__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2747__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2748__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2749__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2750__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2751__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2752__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2753__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2948__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2949__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2950__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2951__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2952__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2953__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2954__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2955__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2956__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2957__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2958__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", D_0037B00C__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", MenuInfo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", DataPktMode__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2346__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editloop", at_2352__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(WaterFrame, 0x4);
INCLUDE_BSS(RedBicMark, 0x4);
INCLUDE_BSS(BlueBicMark, 0x4);
INCLUDE_BSS(TreasureBox, 0x4);
INCLUDE_BSS(MapNo, 0x4);
INCLUDE_BSS(Camera, 0x4);
static INCLUDE_BSS(EventCamera, 0x4);
INCLUDE_BSS(FixCamera, 0x4);
INCLUDE_BSS(EditCamera, 0x4);
INCLUDE_BSS(ActiveCharaNo, 0x4);
INCLUDE_BSS(ControlCharaID, 0x4);
INCLUDE_BSS(WalkChara, 0x4);
INCLUDE_BSS(LoopCounter, 0x4);
INCLUDE_BSS(LoopMode, 0x4);
INCLUDE_BSS(ControlMode, 0x4);
INCLUDE_BSS(SubMapLoadBG, 0x4);
INCLUDE_BSS(now_load_map_no, 0x4);
INCLUDE_BSS(EventSquareJump, 0x4);
INCLUDE_BSS(EditDrawFlag, 0x4);
INCLUDE_BSS(EditDrawCancelFlag, 0x4);
INCLUDE_BSS(PauseFlag, 0x4);
INCLUDE_BSS(LockChara, 0x4);
INCLUDE_BSS(PreEditMenuCnt, 0x4);
INCLUDE_BSS(EditModeChgFlag, 0x4);
INCLUDE_BSS(EditModeChgCnt, 0x4);
INCLUDE_BSS(EditModeChgEvent, 0x4);
INCLUDE_BSS(MainScene__2, 0x4);
INCLUDE_BSS(main_pkt1, 0x4);
INCLUDE_BSS(main_pkt2, 0x4);
INCLUDE_BSS(read_buffer_end, 0x4);
INCLUDE_BSS(MenuDataBuf, 0x4);
INCLUDE_BSS(MenuDataSize, 0x4);
INCLUDE_BSS(FixCharaBuffSize, 0x4);
INCLUDE_BSS(CrossFadeBuff, 0x4);
INCLUDE_BSS(time_step_1481, 0x4);
INCLUDE_BSS(init_1482, 0x4);
INCLUDE_BSS(show_time_step_1484, 0x4);
INCLUDE_BSS(init_1485, 0x4);
INCLUDE_BSS(old_cm_1772, 0x4);
INCLUDE_BSS(rain_flag_1849, 0x4);
INCLUDE_BSS(init_1850, 0x4);
INCLUDE_BSS(start_bt_cnt_1865, 0x4);
INCLUDE_BSS(init_1866, 0x4);
INCLUDE_BSS(encount_flag_1868, 0x4);
INCLUDE_BSS(init_1869, 0x4);
INCLUDE_BSS(show_encount_cnt_1871, 0x4);
INCLUDE_BSS(init_1872, 0x4);
INCLUDE_BSS(next_encount_1874, 0x4);
INCLUDE_BSS(init_1875, 0x4);
INCLUDE_BSS(flag_2408, 0x4);
INCLUDE_BSS(init_2409, 0x4);
INCLUDE_BSS(DelMainNPCflag, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_949, 0x10);
INCLUDE_BSS(WaveTable, 0x1210);
INCLUDE_BSS(CharaOldPos, 0x10);
INCLUDE_BSS(EventMes1, 0x2960);
INCLUDE_BSS(buf0, 0x30);
INCLUDE_BSS(buf1, 0x30);
INCLUDE_BSS(data_buf__2, 0x60);
INCLUDE_BSS(init_dbuf, 0x60);
INCLUDE_BSS(WorkBuffer, 0x30);
INCLUDE_BSS(MenuBuffer__2, 0x30);
INCLUDE_BSS(ChrEffBuffer, 0x30);
INCLUDE_BSS(ScriptBuffer__2, 0x30);
INCLUDE_BSS(TotalDataBuff, 0x30);
INCLUDE_BSS(ControlCharaBuff, 0x30);
INCLUDE_BSS(MainDataBuff, 0x30);
INCLUDE_BSS(MainCharaBuff, 0x30);
INCLUDE_BSS(SubDataBuff, 0x30);
INCLUDE_BSS(SubCharaBuff, 0x30);
INCLUDE_BSS(EventBuff, 0xC0);
INCLUDE_BSS(CharaBufs, 0x180);
INCLUDE_BSS(FishingBuff, 0x30);
INCLUDE_BSS(SkyBuff, 0x30);
INCLUDE_BSS(EditEvent, 0x150);
INCLUDE_BSS(EdDebugInfo, 0x40);
INCLUDE_BSS(TestVisual, 0x50);
INCLUDE_BSS(TestFrame, 0x110);
INCLUDE_BSS(at_1077, 0x10);
INCLUDE_BSS(at_3041, 0x10);
INCLUDE_BSS(beforeAnalyze, 0x40);
