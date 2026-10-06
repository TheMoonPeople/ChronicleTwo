#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "actionchara.hpp"
#include "scene.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "cameracontrol.hpp"
#include "fishing.hpp"
#include "fishingobj.hpp"
#include "subgame.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "savedata.hpp"
#include "nd_meswin.hpp"
#include "scriptinterpreter.hpp"
#include "editctrl.hpp"
#include "mainloop.hpp"
#include "gamepad.hpp"
#include "effscript.hpp"
#include "helpmes.hpp"
#include "sceneload.hpp"
#include "dataread.hpp"
#include "gamedata.hpp"
#include "dngfloor.hpp"
#include <eekernel.h>
#include <cmath>
#include <cstring>
#include <cstdio>
#include "intersection.hpp"
#include <cstdlib>

struct Vec4 { float v[4]; };
extern FISHING_ROD_DATA RodData;
extern FISH_DATA FishData;
extern mgCMemory *fpStack;
extern FISH_PLACE_MAP *fpNowFishPlaceMap;
extern FISH_PLACE_MAP *FishPlaceMap;
extern int FishPlaceMapNum;
extern u_int fpNowFishPlaceMapNum;
extern SPI_TAG_PARAM tag__8[];
extern "C" int fptosi(float value);
void StepDataLoading(void *arg);
extern int RodActFlag;
extern int UkiCameraFlag;
extern int UkiMode;
extern int UkiModeCnt;
extern u_int FishSnd;
extern int CastStep;
extern int CastCount;
extern int CastTime;
extern int CastMotionCnt;
extern Vec4 CastPoint;
extern float UkiCamOldRot;
extern CCameraControl UkiCameraInfo;
extern int DrawHit;
extern float LineTension;
extern float addLineTension;
extern float MinLineTension;
extern float LineMaxLen;
extern float LineMinLen;
extern float FishMinLen;
extern float FishMaxLen;
extern int RodStatus;
extern int RodStatusCnt;
extern int ActionCount;
extern int ActionDecCount;
extern int WindReel;
extern int BattleBgmCnt;
extern int BattleCount;
extern int FalseStep;
extern int FalseMotionCount;
extern int FavoredEsa;
extern CCharacter2 *EsaChara;
extern int FalseStep2;
extern int FishMesNo;
extern int font_h_2216;
extern signed char init_2217;
extern float oldPadRx;
extern float oldPadRy;
extern int RunEventNo;
extern int MardanEventMap;
extern int MardanEventPlace;
extern signed char init_1961;
extern signed char init_2496;
extern int snd_cnt_2495;
extern int snd_cnt_1960;
extern float CastDistSizeRate;
extern int RodNo;
extern int LocalEsaNo;
extern int RodActionPoint;
extern int hamon_count_1798;
extern signed char init_1799;
extern int boze_cnt_1801;
extern int pull_uki_cnt_1808;
extern int act_count_1838;
extern int charge_point_1839;
extern int act_interval_1840;
extern int LoadFishFlag;
extern int FishFontH;
extern CCharacter2 *FishChara;
extern CCharacter2 *MainChara;
extern int FishTexb;
extern u_long128 *ReadBuffer;
extern mgCMemory FishStack;
extern mgCMemory MotionBuff;
extern int GetItemRet;
extern int DrawCongra;
extern u_int FanSnd;
extern char at_932__4[];
extern char at_2197__3[];
extern char at_2198__3[];
extern char at_2272[];
extern char at_1397__3[];
extern char at_1920[];
extern char at_1921[];
extern char at_1922[];
extern char at_1722[];
extern char at_2057[];
extern char at_2058[];
extern char at_2059[];
extern char at_2060[];
extern char at_1749__2[];
extern char at_2099[];
extern char at_2127__3[];
extern char at_2461[];
extern "C" int rand(void);
enum { kFishShapeCount = 5, kFishShapeCircle = 2 };
const int kFishPlaceValueCount = 5;
const int kFishPlaceMaxFish = 8;
enum {
    kUkiStart = 0,
    kUkiWaitBite = 1,
    kUkiPoke = 2,
    kUkiPull = 3,
    kUkiReeledIn = 4,
    kUkiCharge = 5,
    kUkiBite = 6,
};
enum { kFishingModeFloat = 1, kFishingModeLure = 2 };
const int kFishCameraState = 1000;
enum {
    kFishBtnCameraToggle = 6,
    kFishBtnAction = 0x78,
    kFishBtnReel = 0x79,
    kFishBtnReelFast = 0x7A,
};
enum {
    kFishAxisUp = 4,
    kFishAxisSide = 5,
};
int InitUkiWait(CScene *);
int InitFalse(CScene *);
int InitBattle(CScene *);
int InitSuccess(CScene *);
void DrawHamon(float *, float);
void SetNextMode(int);
float GetFishDist(CScene *);
void EsaInit(void);
int GetMotionCount(CCharacter2 *, char *, int, int, int);
void DeleteEsa(void);
int EndSelectCastingPoint(CScene *);
FISH_PARAM *GetFishParam(int);
int GetUkiWaitTime(FISH_DATA *, CScene *, float *, int, int);
int GetUkiPokeTime(FISH_DATA *);
int GetUkiPullTime(FISH_DATA *);
int FishLoadBG(FISH_DATA *, u_long128 *);
float GetRandamNumber(float, float, float);
void DrawSplash(float *, float);
void LineTensionStep(FISH_DATA *, int);
void ExitFishing(CScene *);
int LoadExMotionBG(SubGameInfo *info, u_long128 *buffer);
void ReplayPrevBGM(CScene *scene);
int LoadExMotionStep(SubGameInfo *info, mgCMemory *memory);
int InitDataLoading(void);
int switch_thread(void);
int CreateLoadThread(mgCMemory *memory);
int StepLoadThread(void);
void DeleteLoadThread(void);
void DrawNumber(mgCDrawPrim *prim, int digit, int x, int y);
int InitCasting(CScene *scene);
extern float CastDist;
extern Vec4 CastPointCur;
extern Vec4 at_1631__3;
extern char at_1576__2[];
extern Vec4 at_1490__2;
extern Vec4 at_1491__2;
extern char at_1508__3[];
extern char at_1509__3[];
extern "C" void sceVu0InterVectorXYZ(float *result, float *from, float *to, float rate);
extern mgCMemory EsaStack;
extern mgCMemory SndStack;
extern mgCMemory FishingBuff__2;
extern "C" void *__ct__14CCameraControlFv(void *);
extern Vec4 at_1536;
extern char at_1577[];
enum { kPadButtonDebugJump = 1, kPadButtonCancel = 1, kPadButtonCast = 0x78 };
int InitSelectCastingPoint(CScene *scene);
int CheckCasting(CScene *scene, float *position, float *direction);
extern FISH_PARAM FishParam[];
extern CCharacter2 *Lure;
extern mgCFrame *LureFrame;
extern mgCFrame *UkiFrame;
extern mgCFrame *HariFrame;
extern CCharacter2 *CursorChara[2];
extern int EsaNo;
extern int LureNo;
extern int NextCharaMode;
extern int CharaMode;
extern int RetCode;
extern int CastOKFlag;
extern int fgLoopMode;
extern mgCFrame *RodHand;
extern CCharacter2 *UkiRod;
extern CCharacter2 *LureRod;
extern CCharacter2 *Uki;
extern CCharacter2 *Hari;
extern CScene::BGM_STATUS BgmStatus;
extern int FishingTexb;
extern int SystemTexb;
extern int EsaTexb;
extern mgCMemory ReadStack;
extern int fgLoopStep;
extern int fgLoopCnt;
extern int BgmReadFlag;
extern int LoadExMotionFlag;
extern u_long128 *ex_mtn_buff;
extern int ThreadRunning;
extern int step_end_flag;
extern CEffectScriptMan *EffectMan;
extern int ThreadStack__2;
extern int TheadID__2;
extern char at_917__6[];
extern char at_979__6[];
extern char at_980__4[];
extern char at_1058__3[];
extern char at_1304__8[];
extern char at_1305__5[];
extern char at_1306__6[];
extern char at_1307__6[];
extern char at_1308__6[];
extern char at_1309__5[];
extern char at_1310__5[];
extern char at_1311__4[];
extern char at_1312__2[];
extern char at_1313__2[];
extern char at_1314__2[];
extern char at_1315__4[];
extern char at_1316__2[];
extern int EsaInfo[18];
extern char *lure_file[4];
extern char at_1424__2[];
extern char at_1442__3[];
extern char at_1443__3[];
extern char at_1723__2[];
extern CCameraControl CameraInfo;
extern "C" void srand(u_int seed);
extern Vec4 at_1681__2;
extern char at_1683__2[];
extern Vec4 at_1689;
extern char at_1691__2[];
enum { kCameraSettled = 1000 };
enum { kLastFishParam = 18 };
enum { kLoadThreadPriority = 10 };
enum {
    kCharaModeReel = 6,
    kCharaModeReel2 = 7,
};
enum { kCaptureSeed = 0xC31AFF };
static void CharaControl(CScene *scene, CPadControl *pad);
void SelectCastingPoint(CScene *scene, CPadControl *pad);
void CastingLoop(CScene *scene, CPadControl *pad);
void UkiWaitLoop(CScene *scene, CPadControl *pad);
void BattleLoop(CScene *scene, CPadControl *pad);
void FalseLoop(CScene *scene, CPadControl *pad);
void SuccessLoop(CScene *scene, CPadControl *pad);
int CheckFishing(float *pos, CCPoly *polys, int count);
int fpFISH_MAP_NUM(SPI_STACK *args, int argCount);
int fpFISH_MAP(SPI_STACK *args, int argCount);
int fpFISH_PLACE(SPI_STACK *args, int argCount);
int fpFISH(SPI_STACK *args, int argCount);
int fpFISH_MAP_END(SPI_STACK *args, int argCount);

static inline int FreeSize(mgCMemory *memory) {
    return memory->stack_size - memory->stack_used;
}

static inline u_char *FreeTop(mgCMemory *memory) {
    return (u_char *)(memory->stack + memory->stack_used);
}

extern "C" void *__vt__9mgCObject[];
extern "C" void *__vt__7CObject[];
extern "C" void *__vt__12CObjectFrame[];
extern "C" void *__vt__11CCharacter2[];

extern "C" void __ct__11mgCDrawPrimFv(mgCDrawPrim *prim);

// Code (.text)
FISH_PARAM *GetFishParam(int index) {
    if (index < 0 || index > kLastFishParam) {
        return NULL;
    }
    return &FishParam[index];
}
void EsaInit(void) {
    CObjectFrame *lure = Lure;
    EsaChara = 0;
    LureFrame = 0;
    EsaNo = -1;
    LocalEsaNo = -1;
    FavoredEsa = -1;
    LureNo = -1;
    lure->Initialize();
}
void ReplayPrevBGM(CScene *scene) {
    u_char *read_buff;
    if (BgmReadFlag == 0) {
        scene->SetActiveBgmStatus(&BgmStatus);
        return;
    }
    read_buff = (u_char *)scene->read_buff + 0x100000;
    if (BgmStatus.load_no < 0) {
        scene->StopBGM(0);
        scene->InitBGM();
        return;
    }
    scene->LoadBGM(BgmStatus.load_no, (u_long128 *)read_buff);
    scene->SetActiveBgmStatus(&BgmStatus);
}
int LoadExMotionBG(SubGameInfo *info, u_long128 *buffer) {
    LoadExMotionFlag = 0;
    if (info->dungeon != 0) {
        return 0;
    }
    StartReadBG();
    if (LoadFileBG(at_917__6, buffer, 0) == 0) {
        return 0;
    }
    ex_mtn_buff = buffer;
    LoadExMotionFlag = 1;
    return 1;
}
int LoadExMotionStep(SubGameInfo *info, mgCMemory *memory) {
    CCharacter2 *chara;
    CScene *scene;

    if (info->dungeon != 0) {
        return 0;
    }
    if (ReadBGSync() != 0) {
        return 1;
    }
    if (LoadExMotionFlag == 0) {
        return 0;
    }
    scene = info->scene;
    chara = scene->GetCharacter(scene->player_chara);
    if (chara != NULL) {
        chara->LoadPack((u_int *)ex_mtn_buff, at_932__4, memory, memory, memory, 0, NULL);
    }
    LoadExMotionFlag = 0;
    return 0;
}
void SetNextMode(int mode) {
    NextCharaMode = mode;
}
void ExitFishing(CScene *scene) {
    RetCode = 1;
}
int sgInitFishing(SubGameInfo *info) {
    CCharacter2 *chara;
    CScene *scene;

    FishingTexb = info->texb;
    FishTexb = info->texb + 1;
    SystemTexb = info->texb + 2;
    EsaTexb = info->texb + 4;
    scene = info->scene;
    mgTexManager.DeleteBlock(FishingTexb);
    mgTexManager.DeleteBlock(FishTexb);
    mgTexManager.DeleteBlock(SystemTexb);
    LoadExMotionFlag = 0;
    u_long128 *read_buff = scene->read_buff;
    ReadBuffer = read_buff;
    if (info->menu_buff != NULL) {
        int buffer_size = info->menu_buff->stGetSize();
        u_long128 *buffer_top = info->menu_buff->stack;
        ReadStack.stSetBuffer(buffer_top, buffer_size);
        ReadStack.stReset();
        ReadBuffer = ReadStack.stAlloc64(0x10000);
        ReadStack.Align64();
        int remaining = ReadStack.stGetRest();
        u_long128 *top = ReadStack.stGetTop();
        MotionBuff.stSetBuffer(top, remaining);
    } else {
        MotionBuff.stSetBuffer((u_long128 *)((u_char *)read_buff + 0x100000), 30000);
    }
    chara = scene->GetCharacter(scene->player_chara);
    if (chara != NULL) {
        if (chara->GetKeyListPtr(at_979__6, NULL) != 0) {
            chara->SetMotion(at_979__6, 0);
        } else {
            chara->SetMotion(at_980__4, 0);
        }
    }
    fgLoopMode = 0;
    fgLoopStep = 0;
    fgLoopCnt = 0;
    info->no_map_event = info->dungeon;
    info->record_check = info->dungeon;
    return 1;
}
#ifdef NONMATCHING
int sgRestartFishing(SubGameInfo *info) {
    CScene *scene = info->scene;
    u_long128 *buffer = ReadBuffer;
    int rod_status[5];

    mgTexManager.DeleteBlock(EsaTexb);
    EsaStack.stack_used = 0;
    LocalEsaNo = -1;
    EsaStack.lock = 0;
    EsaChara = NULL;
    for (int i = 0; i < 18; i++) {
        if (info->esa_no == EsaInfo[i]) {
            LocalEsaNo = i;
            break;
        }
    }
    if (info->rod_no == 0x12F) {
        SetFishingMode(kFishingModeLure);
        EsaChara = NULL;
        char lure_path[0x40] = "sg/fish/";
        int lure_no = LocalEsaNo - 14;
        if (lure_no >= 4) {
            lure_no = -1;
        }
        LureFrame = NULL;
        if (lure_no >= 0) {
            strcat(lure_path, lure_file[lure_no]);
            if (LoadFile2(lure_path, buffer, NULL, 0) != 0) {
                Lure->LoadPack((u_int *)buffer, at_932__4, &EsaStack, &EsaStack, &EsaStack, EsaTexb, NULL);
            }
            LureFrame = Lure->CObjectFrame::frame;
        }
        InitLureObj(lure_no, LureFrame);
        if (lure_no < 0) {
            LureFrame = NULL;
            Lure->Initialize();
        }
        LureNo = lure_no;
    } else {
        SetFishingMode(kFishingModeFloat);
        char *esa_path = GetItemFilePath(info->esa_no, 0);
        if (esa_path != NULL) {
            if (*esa_path != 0 && LocalEsaNo >= 0) {
                EsaChara = new (EsaStack.Alloc(0x68)) CCharacter2;
                EsaChara->Initialize();
                if (LoadFile2(esa_path, buffer, NULL, 0) != 0) {
                    EsaChara->LoadPack((u_int *)buffer, at_932__4, &EsaStack, &EsaStack, &EsaStack, EsaTexb, NULL);
                } else {
                    EsaChara = NULL;
                }
            }
        }
    }
    sndSeAllStop(5);
    sndSeAllStop(8);
    if (sndSeCheck(FanSnd, 0) == 0) {
        mgCMemory sound_memory;
        sound_memory.Init();
        sound_memory.stSetBuffer(MotionBuff.stGetTop(), MotionBuff.stGetRest());
        u_int *sound_buffer = (u_int *)sound_memory.stAlloc64(0x4000);
        if (sound_buffer != NULL && LoadFile2(at_1058__3, sound_buffer, NULL, 0) != 0) {
            sndInitPort(8);
            SndStack.stack_used = 0;
            SndStack.lock = 0;
            FanSnd = sndLoadSound(8, sound_buffer, &SndStack);
        }
    }
    MardanEventMap = 0;
    MardanEventPlace = 0;
    CSaveData *save_data = GetSaveData();
    if (scene->now_map_no == 0x41) {
        if (save_data->GetBitFlag(0xEB) != 0 && save_data->GetBitFlag(0xF0) == 0) {
            MardanEventPlace = 0;
            MardanEventMap = 1;
        }
    }
    save_data->user_data.GetRodStatus(rod_status);
    RodData.status[0] = rod_status[0];
    RodData.status[1] = rod_status[1];
    RodData.status[2] = rod_status[2];
    RodData.status[3] = rod_status[3];
    RodData.status[4] = rod_status[4];
    float rate = 0.2f * ((float)RodData.status[3] / 100.0f) + 0.8f;
    RodData.status[0] = fptosi(0.5f + (float)RodData.status[0] * rate);
    RodData.status[1] = fptosi(0.5f + (float)RodData.status[1] * rate);
    RodData.status[2] = fptosi(0.5f + (float)RodData.status[2] * rate);
    CastDistSizeRate = 10.0f;
    RodData.status4_rate = (float)RodData.status[4] / 100.0f;
    SetWaterLevel(-100000.0f);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishing", sgRestartFishing__FP11SubGameInfo);
#endif
int InitDataLoading(void) {
    SubGameInfo *info;
    CScene *scene;
    int bgm_no;
    mgCMemory *memory;

    info = GetNowSubGameInfo();
    memory = info->load_buff;
    scene = info->scene;
    if (memory != NULL) {
        memory->stack_used = 0;
        memory->lock = 0;
        memory->Align64();
    } else {
        scene->AssignStack(5);
        scene->GetStack(5);
    }
    bgm_no = scene->GetDefBgmNo(0x205);
    if (info->keep_bgm == 0) {
        scene->GetActiveBgmStatus(&BgmStatus);
        if (scene->CheckLoadBGM(bgm_no) != 0) {
            scene->StopBGM(0);
        }
    }
    EffectMan = (CEffectScriptMan *)scene->GetEffect(0);
    CharaMode = 0;
    NextCharaMode = -1;
    RunEventNo = -1;
    CastOKFlag = 0;
    MardanEventMap = 0;
    MardanEventPlace = 0;
    RodNo = info->rod_no;
    EsaNo = info->esa_no;
    RetCode = 0;
    oldPadRy = 0;
    oldPadRx = 0;
    DrawCongra = 0;
    DrawHit = 0;
    return 1;
}
int switch_thread(void) {
    return RotateThreadReadyQueue(kLoadThreadPriority);
}
int CreateLoadThread(mgCMemory *memory) {
    ThreadParam param;
    int misalignment;

    stack_size = 0x40000;

    ThreadStack__2 = (int)memory->Alloc(0x4001);
    misalignment = ThreadStack__2 & 0x3F;
    if (misalignment != 0) {
        ThreadStack__2 += 0x40 - misalignment;
    }
    param.entry = StepDataLoading;
    step_end_flag = 0;
    param.initPriority = kLoadThreadPriority;
    param.option = 0;
    param.gpReg = &_gp;
    param.stack = (void *)ThreadStack__2;
    param.stackSize = stack_size;
    TheadID__2 = CreateThread(&param);
    ThreadRunning = 1;
    StartThread(TheadID__2, NULL);
    return 1;
}
int StepLoadThread(void) {
    if (ThreadRunning == 0) {
        return 0;
    }
    switch_thread();

    return !(step_end_flag != 0);
}
void DeleteLoadThread(void) {
    if (ThreadRunning != 0) {
        while (StepLoadThread() != 0) {
        }
        TerminateThread(TheadID__2);
        DeleteThread(TheadID__2);
        ThreadRunning = 0;
    }
}
#ifdef NONMATCHING
void StepDataLoading(void *arg) {
    char path[0x80];
    char bgm_path[0x80];
    int file_size;
    int pack_size;
    u_long128 *buffer = ReadBuffer;
    SubGameInfo *info = GetNowSubGameInfo();
    mgCMemory *memory = info->load_buff;
    CScene *scene = info->scene;

    if (memory == NULL) {
        memory = scene->GetStack(5);
    }
    if (LoadFile2(at_1304__8, buffer, &file_size, 0) != 0) {
        LoadFishPlaceData((char *)buffer, file_size, memory);
    }
    StartReadBG();
    if (LanguageCode >= 2) {
        sprintf(path, at_1305__5, LanguageCode);
    } else {
        strcpy(path, at_1306__6);
    }
    if (LoadFileBG(path, buffer, &pack_size) != 0) {
        while (ReadBGSync() != 0) {
            switch_thread();
        }
        UkiRod = new (memory->Alloc(0x68)) CCharacter2;
        UkiRod->Initialize();
        LureRod = new (memory->Alloc(0x68)) CCharacter2;
        LureRod->Initialize();
        Uki = new (memory->Alloc(0x68)) CCharacter2;
        Uki->Initialize();
        Lure = new (memory->Alloc(0x68)) CCharacter2;
        Lure->Initialize();
        Hari = new (memory->Alloc(0x68)) CCharacter2;
        Hari->Initialize();
        CursorChara[0] = new (memory->Alloc(0x68)) CCharacter2;
        CursorChara[0]->Initialize();
        CursorChara[1] = new (memory->Alloc(0x68)) CCharacter2;
        CursorChara[1]->Initialize();
        EsaChara = NULL;
        FishChara = NULL;
        BG_READ_INFO *read_info = GetReadBGFile(0);
        if (read_info != NULL) {
            u_int *pack = (u_int *)read_info->buffer;
            int bgm_no = scene->GetDefBgmNo(0x205);
            if (scene->CheckLoadBGM(bgm_no) != 0) {
                scene->GetBgmFile(bgm_path, bgm_no);
                u_int *bgm_pack = GetPackFile(pack, bgm_path, NULL);
                if (bgm_pack != NULL) {
                    BgmReadFlag = 1;
                    scene->LoadBGMPack(bgm_no, bgm_pack);
                }
            }
            switch_thread();
            scene->PlayBGM(0, -1, 1.0f);
            if (info->rod_no == 0x12F) {
                u_int *rod_pack = GetPackFile(pack, at_1307__6, NULL);
                if (rod_pack != NULL) {
                    UkiRod->LoadPack(rod_pack, at_932__4, memory, memory, memory, FishingTexb, NULL);
                }
            } else {
                u_int *rod_pack = GetPackFile(pack, at_1308__6, NULL);
                if (rod_pack != NULL) {
                    UkiRod->LoadPack(rod_pack, at_932__4, memory, memory, memory, FishingTexb, NULL);
                }
            }
            if (UkiRod->CObjectFrame::frame != NULL) {
                u_int *cursor_pack = GetPackFile(pack, at_1309__5, NULL);
                if (cursor_pack != NULL) {
                    CursorChara[0]->LoadPack(cursor_pack, at_932__4, memory, memory, memory, FishingTexb, NULL);
                }
                u_int *system_pack = GetPackFile(pack, at_1310__5, &pack_size);
                if (system_pack != NULL) {
                    u_char *copy = (u_char *)memory->Alloc((pack_size + 15) / 16);
                    if (copy != NULL) {
                        memcpy(copy, system_pack, pack_size);
                        mgTexManager.EnterIMGFile(copy, SystemTexb, NULL, NULL);
                    }
                }
                u_int *fish_pack = GetPackFile(pack, at_1311__4, &pack_size);
                if (fish_pack != NULL) {
                    u_char *copy = (u_char *)memory->Alloc((pack_size + 15) / 16);
                    if (copy != NULL) {
                        memcpy(copy, fish_pack, pack_size);
                        mgTexManager.EnterIMGFile(copy, SystemTexb, NULL, NULL);
                    }
                }
                u_int *uki_pack = GetPackFile(pack, at_1312__2, NULL);
                if (uki_pack != NULL) {
                    Uki->LoadPack(uki_pack, at_932__4, memory, memory, memory, FishingTexb, NULL);
                }
                u_int *hari_pack = GetPackFile(pack, at_1313__2, NULL);
                if (hari_pack != NULL) {
                    Hari->LoadPack(hari_pack, at_932__4, memory, memory, memory, FishingTexb, NULL);
                }
                UkiFrame = Uki->CObjectFrame::frame;
                HariFrame = Hari->CObjectFrame::frame;
                if (UkiFrame != NULL && HariFrame != NULL) {
                    MainChara = scene->GetCharacter(scene->player_chara);
                    if (MainChara != NULL && MainChara->CObjectFrame::frame != NULL) {
                        RodHand = MainChara->CObjectFrame::frame->SearchFrame(at_1314__2);
                        if (RodHand != NULL) {
                            UkiRod->CObjectFrame::frame->SetReference(RodHand);
                            InitRodPoint(RodHand, UkiRod->CObjectFrame::frame);
                            InitUkiObj(0, UkiFrame, HariFrame);
                            EsaStack.stSetBuffer(memory->Alloc(8000), 8000);
                            FishSnd = -1;
                            FanSnd = -1;
                            SndStack.stSetBuffer(memory->Alloc(100), 100);
                            if (LoadFile2(at_1315__4, buffer, NULL, 0) != 0) {
                                sndInitPort(5);
                                FishSnd = sndLoadSound(5, (u_int *)buffer, memory);
                            }
                            if (LoadFile2(at_1058__3, buffer, NULL, 0) != 0) {
                                sndInitPort(8);
                                SndStack.stack_used = 0;
                                SndStack.lock = 0;
                                FanSnd = sndLoadSound(8, (u_int *)buffer, &SndStack);
                            }
                            if (info->dungeon != 0) {
                                if (LoadFile2(at_917__6, buffer, NULL, 0) != 0) {
                                    MainChara->LoadPackNoLine((u_int *)buffer, at_932__4, memory, memory, memory, 0, NULL);
                                }
                            }
                            sgRestartFishing(info);
                            printf(at_1316__2, (memory->stack_size - memory->stack_used) * 16 / 1024);
                        }
                    }
                }
            }
        }
    }
    step_end_flag = 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishing", StepDataLoading__FPv);
#endif
int sgBreakFishing(void) {
    DeleteLoadThread();
    sgExitFishing(GetNowSubGameInfo());
    return 1;
}
int sgExitFishing(SubGameInfo *info) {
    CCharacter2 *chara;
    CScene *scene;

    mgTexManager.DeleteBlock(FishingTexb);
    mgTexManager.DeleteBlock(FishTexb);
    mgTexManager.DeleteBlock(SystemTexb);
    ReEquipFishingGameWeapon();
    if (info != NULL && info->scene != NULL) {
        ReplayPrevBGM(info->scene);
    }
    scene = info->scene;
    chara = scene->GetCharacter(scene->player_chara);
    if (chara != NULL) {
        chara->DeleteExtMotion();
        chara->SetMotion(at_980__4, 0);
    }
    BgmReadFlag = 0;
    return 1;
}
#ifdef NONMATCHING
int sgLoopFishing(SubGameInfo *info) {
    CScene *scene = info->scene;
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);

    if (fgLoopMode == 0) {
        fgLoopCnt++;
        CharaControl(scene, NULL);
        switch (fgLoopStep) {
            case 0:
                if (fgLoopCnt < 3) {
                    return 0;
                }
                if (0 < scene->bg_load_step) {
                    return 0;
                }
                fgLoopStep++;
            case 1:
                InitDataLoading();
                fgLoopStep++;
                return 0;
            case 2:
                MotionBuff.stReset();
                CreateLoadThread(&MotionBuff);
                fgLoopStep++;
            case 3:
                if (StepLoadThread() != 0) {
                    return 0;
                }
                fgLoopStep++;
            case 4:
                scene->fade.CaptureScreen();
                scene->fade.CrossFade(20, 1.0f);
                fgLoopStep++;
                return 0;
            case 5:
                if (chara != NULL) {
                    chara->SetMotion(at_1397__3, 4);
                    chara->UpdatePosition();
                    chara->Step();
                }
                DeleteLoadThread();
                fgLoopStep = 0;
                fgLoopMode = 1;
                fgLoopCnt = 0;
                break;
            default:
                ExitFishing(scene);
                sgExitFishing(info);
                return RetCode;
        }
    }
    CPadControl *pad = &PadCtrl;
    sgSetMenuOpenEnableFlag(0);
    switch (CharaMode) {
        case 0:
            CharaControl(scene, pad);
            break;
        case 1:
            SelectCastingPoint(scene, pad);
            break;
        case 2:
            CastingLoop(scene, pad);
            break;
        case 3:
            UkiWaitLoop(scene, pad);
            break;
        case 5:
            BattleLoop(scene, pad);
            break;
        case 6:
            FalseLoop(scene, pad);
            break;
        case 7:
            SuccessLoop(scene, pad);
            if (FishChara != NULL) {
                FishChara->Step();
            }
            break;
    }
    oldPadRx = pad->Analog(5);
    oldPadRy = pad->Analog(4);
    if (NextCharaMode >= 0) {
        CharaMode = NextCharaMode;
    }
    if (CharaMode == 0) {
        sgSetMenuOpenEnableFlag(1);
    }
    DrawHit--;
    if (DrawHit < 0) {
        DrawHit = 0;
    }
    DrawCongra--;
    if (DrawCongra < 0) {
        DrawCongra = 0;
    }
    if (RetCode != 0) {
        sgExitFishing(info);
    }
    return RetCode;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishing", sgLoopFishing__FP11SubGameInfo);
#endif
int sgLoopFishing2(SubGameInfo *info) {
    CScene *scene;

    u_long128 poly_buffer[0x1400];
    float hand_pos[4];
    CCharacter2 *chara;
    mgCFrame *frame;

    if (fgLoopMode == 0) {
        return 0;
    }
    scene = info->scene;
    MainChara->UpdatePosition();
    UkiRod->CObjectFrame::frame->SetReference(RodHand);
    RodStep(scene, poly_buffer);
    if (CharaMode == kCharaModeReel || CharaMode == kCharaModeReel2) {
        chara = scene->GetCharacter(scene->player_chara);
        if (chara != NULL) {
            frame = chara->CObjectFrame::frame;
            if (frame != NULL) {
                frame = frame->SearchFrame(at_1424__2);
            }
            if (frame != NULL) {
                frame->GetWorldPosition0(hand_pos);
                if (CatchLine(hand_pos, 50.0f) == 0) {
                    SlowLineVelo(0.2f);
                }
            }
        }
    }
    return 0;
}
#ifdef NONMATCHING
int sgDrawFishing(SubGameInfo *info) {
    sceVu0FMATRIX uki_matrix;
    sceVu0FMATRIX lure_matrix;

    if (fgLoopMode == 0) {
        return 0;
    }
    mgCTextureManager *textures = &mgTexManager;
    textures->ReloadTexture(FishingTexb, (sceVif1Packet *)NULL);
    UkiRod->DrawDirect();
    sceVu0FVECTOR hook_offset = {0.0f, -3.5f, 1.0f, 0.0f};
    if (LureFrame != NULL && SetLurePose(LureFrame) != 0) {
        if (GetShowHari() != 0) {
            textures->ReloadTexture(EsaTexb, (sceVif1Packet *)NULL);
            mgDrawDirect(LureFrame);
        }
        LureFrame->GetLWMatrix(uki_matrix);
        u_long128 lure_swap_row;
        lure_swap_row = *(u_long128 *)uki_matrix[0];
        *(u_long128 *)uki_matrix[0] = *(u_long128 *)uki_matrix[2];
        *(u_long128 *)uki_matrix[2] = lure_swap_row;
        sceVu0ScaleVector(uki_matrix[2], uki_matrix[2], -1.0f);
        *(u_long128 *)lure_matrix[0] = *(u_long128 *)uki_matrix[0];
        *(u_long128 *)lure_matrix[1] = *(u_long128 *)uki_matrix[1];
        *(u_long128 *)lure_matrix[2] = *(u_long128 *)uki_matrix[2];
        *(u_long128 *)lure_matrix[3] = *(u_long128 *)uki_matrix[3];
        LureFrame->GetWorldPosition(lure_matrix[3], hook_offset);
    }
    textures->ReloadTexture(FishingTexb, (sceVif1Packet *)NULL);
    if (SetUkiPose(UkiFrame, HariFrame) != 0) {
        mgDrawDirect(UkiFrame);
        if (GetShowHari() != 0) {
            mgDrawDirect(HariFrame);
        }
        HariFrame->GetLWMatrix(uki_matrix);
        u_long128 hari_swap_row;
        hari_swap_row = *(u_long128 *)uki_matrix[1];
        *(u_long128 *)uki_matrix[1] = *(u_long128 *)uki_matrix[2];
        *(u_long128 *)uki_matrix[2] = hari_swap_row;
        sceVu0ScaleVector(uki_matrix[0], uki_matrix[0], -1.0f);
        *(u_long128 *)lure_matrix[0] = *(u_long128 *)uki_matrix[0];
        *(u_long128 *)lure_matrix[1] = *(u_long128 *)uki_matrix[1];
        *(u_long128 *)lure_matrix[2] = *(u_long128 *)uki_matrix[2];
        *(u_long128 *)lure_matrix[3] = *(u_long128 *)uki_matrix[3];
        HariFrame->GetWorldPosition(lure_matrix[3], hook_offset);
    }
    if (CharaMode == 1) {
        char *cursor_motion[2] = {at_1442__3, at_1443__3};
        CursorChara[0]->SetMotion(cursor_motion[CastOKFlag], 0);
        CursorChara[0]->SetPosition((float *)&CastPointCur);
        CursorChara[0]->Step();
        CursorChara[0]->DrawDirect();
    }
    if (EsaChara != NULL && FishChara == NULL) {
        textures->ReloadTexture(EsaTexb, (sceVif1Packet *)NULL);
        EsaChara->SetPosition(lure_matrix[3]);
        mgZeroVectorW(lure_matrix[3]);
        if (EsaChara->CObjectFrame::frame != NULL) {
            EsaChara->CObjectFrame::frame->SetTransMatrix(lure_matrix);
        }
        if (GetShowHari() != 0) {
            EsaChara->DrawDirect();
        }
    }
    if (FishChara != NULL) {
        textures->ReloadTexture(FishTexb, (sceVif1Packet *)NULL);
        FishChara->SetPosition(uki_matrix[3]);
        mgZeroVectorW(uki_matrix[3]);
        if (FishChara->CObjectFrame::frame != NULL) {
            FishChara->CObjectFrame::frame->SetTransMatrix(uki_matrix);
        }
        FishChara->DrawDirect();
    }
    DrawFishingLine();
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishing", sgDrawFishing__FP11SubGameInfo);
#endif
void DrawNumber(mgCDrawPrim *prim, int digit, int x, int y) {

    int tex_u = 0;
    tex_u += digit * 12;
    prim->TextureCrd(tex_u, 0x72);
    prim->Vertex(x, y, 0);
    prim->TextureCrd(tex_u + 12, 0x80);
    prim->Vertex(x + 12, y + 14, 0);
}
int sgSystemDrawFishing(SubGameInfo *info) {
    union {
        mgCDrawPrim prim;
    };
    CScene *scene;
    mgCTexture *system_texture;
    mgCTexture *banner_texture;
    float tension_end[4];
    float tension_color[4];
    int top;
    int gauge_top;
    float reach;
    float line_length;
    int length;
    float fill;
    float bottom_y;
    float tension;
    float fish_dist;
    int hundreds;
    int tens;
    int ones;

    if (fgLoopMode == 0) {
        return 0;
    }

    mgTexManager.ReloadTexture(SystemTexb, (sceVif1Packet *)NULL);
    DrawFishingActionChance();
    scene = info->scene;
    system_texture = (mgCTexture *)mgTexManager.GetTexture(at_1508__3,
                                                                      SystemTexb);
    banner_texture = (mgCTexture *)mgTexManager.GetTexture(at_1509__3,
                                                                      SystemTexb);

    __ct__11mgCDrawPrimFv(&prim);
    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.DepthTestEnable(0);
    prim.Coord(0);
    prim.ZMask(-1);
    prim.Bilinear(1);
    prim.TextureMapEnable(0);
    if (CharaMode == 5) {
        top = mgScreenHeight - 0x47;
        prim.Begin(6);
        prim.Color(0x15, 0x29, 0x47, 0x60);
        prim.Vertex(0x156, top + 0x25, 0);
        prim.Vertex(0x1C4, top + 0x2A, 0);
        prim.End();
        fish_dist = GetFishDist(scene);
        reach = (FishMaxLen - fish_dist) / (FishMaxLen - FishMinLen);
        if (reach < 0.0f) {
            reach = 0.0f;
        }
        if (!(reach <= 1.0f)) {
            reach = 1.0f;
        }
        line_length = GetNowLineLength();
        prim.Begin(6);
        prim.Color(0x15, 0x29, 0xFF, 0x80);
        prim.Vertex(342.0f + 110.0f * reach, (float)(top + 0x25), 0.0f);
        prim.Vertex(0x1C4, top + 0x2A, 0);
        prim.End();
        prim.Bilinear(0);
        prim.TextureMapEnable(1);
        prim.Begin(6);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.Texture(system_texture);
        prim.TextureCrd(0, 0x34);
        prim.Vertex(0x146, top, 0);
        prim.TextureCrd(0xA8, 0x6A);
        prim.Vertex(0x1EE, top + 0x36, 0);
        prim.End();
        prim.Begin(6);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.Texture(system_texture);
        gauge_top = mgScreenHeight - 0x36;
        length = fptosi(line_length / 2.0f);
        hundreds = length / 100;
        length %= 100;
        tens = length / 10;
        length %= 10;
        DrawNumber(&prim, hundreds, 0x18B, gauge_top);
        DrawNumber(&prim, tens, 0x194, gauge_top);
        DrawNumber(&prim, length, 0x1A3, gauge_top);
        prim.End();
        prim.Bilinear(1);
        prim.TextureMapEnable(0);
        top = mgScreenHeight - 0xD7;
        prim.Begin(6);
        prim.Color(0x15, 0x29, 0x47, 0x60);
        prim.Vertex(0x1D5, top + 0x14, 0);
        prim.Vertex(0x1E1, top + 0x96, 0);
        prim.End();
        tension = LineTension;
        fill = 130.0f * (1.0f - (float)tension);
        *(u_long128 *)tension_end = *(u_long128 *)&at_1490__2;
        *(u_long128 *)tension_color = *(u_long128 *)&at_1491__2;
        sceVu0InterVectorXYZ(tension_color, tension_color, tension_end, tension);
        prim.Shading(1);
        prim.Begin(4);
        prim.Color(fptosi(tension_end[0]), fptosi(tension_end[1]), fptosi(tension_end[2]), 0x80);
        bottom_y = (float)(top + 0x96);
        prim.Vertex(469.0f, bottom_y, 0.0f);
        prim.Color(fptosi(tension_end[0]), fptosi(tension_end[1]), fptosi(tension_end[2]), 0x80);
        prim.Vertex(481.0f, (float)(top + 0x96), 0.0f);
        prim.Color(fptosi(tension_color[0]), fptosi(tension_color[1]), fptosi(tension_color[2]),
                        0x80);
        fill = fill + (float)(top + 0x14);
        prim.Vertex(469.0f, fill, 0.0f);
        prim.Color(fptosi(tension_color[0]), fptosi(tension_color[1]), fptosi(tension_color[2]),
                        0x80);
        prim.Vertex(481.0f, fill, 0.0f);
        prim.End();
        prim.Begin(4);
        prim.Color(0xFF, 0xFF, 0xFF, 0x20);
        prim.Vertex(0x1D5, top + 0x14, 0);
        prim.Color(0xFF, 0xFF, 0xFF, 0);
        prim.Vertex(0x1E1, top + 0x14, 0);
        prim.Color(0xFF, 0xFF, 0xFF, 0x20);
        prim.Vertex(0x1D5, top + 0x96, 0);
        prim.Color(0xFF, 0xFF, 0xFF, 0);
        prim.Vertex(0x1E1, top + 0x96, 0);
        prim.End();
        prim.Bilinear(0);
        prim.TextureMapEnable(1);
        prim.Begin(4);
        prim.Texture(system_texture);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.TextureCrd(0, 0x34);
        prim.Vertex(0x1C3, top, 0);
        prim.TextureCrd(0, 0);
        prim.Vertex(0x1F6, top, 0);
        prim.TextureCrd(0xA8, 0x34);
        prim.Vertex(0x1C3, top + 0xA7, 0);
        prim.TextureCrd(0xA8, 0);
        prim.Vertex(0x1F6, top + 0xA7, 0);
        prim.End();
    }
    prim.TextureMapEnable(1);
    if (DrawCongra > 0) {
        prim.Begin(6);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.Texture(banner_texture);
        prim.TextureCrd(0, 0);
        prim.Vertex(0x80, 0xBD, 0);
        prim.TextureCrd(0x100, 0x26);
        prim.Vertex(0x180, 0xE3, 0);
        prim.End();
    }
    if (DrawHit > 0) {
        prim.Begin(6);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.Texture(banner_texture);
        prim.TextureCrd(0, 0x50);
        prim.Vertex(0x80, 0xB8, 0);
        prim.TextureCrd(0x100, 0x80);
        prim.Vertex(0x180, 0xE8, 0);
        prim.End();
    }
    return 1;
}
static void CharaControl(CScene *scene, CPadControl *pad) {
    mgCCameraFollow *camera;
    CCharacter2 *chara;
    float position[4];
    float rotation[4];
    float velocity[4];
    float matrix[4][4];
    EditMoveCharaInfo idle_info;
    float turn_rotation[4];
    EditMoveCharaInfo move_info;
    float camera_angle;
    float stick_y;
    float stick_x;
    float move_x;
    float move_z;
    float target_angle;
    float turned_angle;
    float turn_delta;
    float stick_length;
    float cast_dir[4];
    float event_pos[4];
    int can_cast;

    chara = scene->GetCharacter(scene->player_chara);
    if (chara != NULL) {
        camera = (mgCCameraFollow *)scene->GetCamera(scene->active_camera);
        if (camera != NULL) {
            switch (((mgCCamera *)camera)->Iam()) {
                case kCameraSettled:
                    break;
                default:
                    return;
            }
            chara->GetPosition(position);
            chara->GetRotation(rotation);
            mgCreateMatrixPY(matrix, position, rotation[1]);
            *(u_long128 *)velocity = *(u_long128 *)chara->velocity;
            if (pad == NULL) {
                memset(&idle_info.move_info, 0, sizeof(idle_info.move_info));
                memset(&idle_info, 0, sizeof(idle_info));
                velocity[1] -= 0.6f;
                EditMoveChara(scene, velocity, &idle_info);
                EditCameraControl(scene, NULL, NULL);
                return;
            }
            camera_angle = camera->GetAngle();
            stick_y = pad->Analog(5);
            stick_x = pad->Analog(4);
            move_x = stick_y * cosf(camera_angle) + stick_x * sinf(camera_angle);
            move_z = -stick_y * sinf(camera_angle) + stick_x * cosf(camera_angle);
            move_x *= 3.5f;
            move_z *= 3.5f;
            if (DebugInfo.chara_move != 0) {
                if (GamePad__2.On(1) != 0) {
                    move_x *= 3.0f;
                    move_z *= 3.0f;
                }
                if (pad->Btn(kPadButtonDebugJump) != 0) {
                    velocity[1] = 8.0f;
                }
            }
            velocity[0] = move_x;
            velocity[2] = move_z;
            velocity[1] -= 0.6f;
            if (move_x != 0.0f || move_z != 0.0f) {
                chara->GetRotation(turn_rotation);
                target_angle = atan2f(move_x, move_z);
                turned_angle = mgAngleInterpolate(turn_rotation[1], target_angle, 0.3f, 0);
                turn_delta = target_angle - turned_angle;
                if (turn_delta < 0.0f) {
                    turn_delta = -turn_delta;
                }
                if (!((float)fptosi(turn_delta) <= 1.0f)) {
                    velocity[0] *= 0.5f;
                    velocity[2] *= 0.5f;
                }
                chara->SetRotation(0.0f, turned_angle, 0.0f);
                stick_length = sqrtf(stick_y * stick_y + stick_x * stick_x);
                if (stick_length < 0.8f) {
                    chara->SetMotion(at_1576__2, 0);
                    chara->SetStep(0.1f + stick_length / 0.8f);
                } else {
                    chara->SetMotion(at_1577, 0);
                }
            } else {
                chara->SetMotion(at_1397__3, 0);
            }
            memset(&move_info.move_info, 0, sizeof(move_info.move_info));
            memset(&move_info, 0, sizeof(move_info));
            EditMoveChara(scene, velocity, &move_info);
            EditCameraControl(scene, pad, NULL);
            *(u_long128 *)cast_dir = *(u_long128 *)&at_1536;
            sceVu0ApplyMatrix(cast_dir, matrix, cast_dir);
            can_cast = move_info.move_info.landed;
            if (GetFishingMode() == 2 && LureNo < 0) {
                can_cast = 0;
            }
            if (can_cast != 0 && CheckCasting(scene, position, cast_dir) != 0) {
                ShowHelpMes(0x65, 1);
                if (pad->Btn(kPadButtonCast) != 0 && InitSelectCastingPoint(scene) != 0) {
                    SetNextMode(1);
                }
            }
            if (GetNowSubGameInfo()->no_map_event == 0) {
                chara->GetPosition(event_pos);
                union {
                    CSceneEventData data;
                    struct {
                        u_char unknown_00[8];
                        int event_no;
                    } fields;
                } eventData;
                if (scene->GetMapEvent(event_pos, 0, &eventData.data) != 0) {
                    scene->RunEvent(eventData.fields.event_no, &eventData.data);
                    ExitFishing(scene);
                }
                scene->map_event_no = 0;
            }
        }
    }
}
int InitSelectCastingPoint(CScene *scene) {
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);
    mgCCamera *camera;
    float position[4];
    CameraCtrlParam *param;

    if (chara == NULL) {
        return 0;
    }
    camera = (mgCCamera *)scene->GetCamera(scene->active_camera);
    if (camera == NULL || camera->Iam() != kCameraSettled) {
        return 0;
    }
    chara->GetRotation(position);
    ((CCameraControl *)camera)->CopyParam(CameraInfo);
    param = ((CCameraControl *)camera)->GetActiveParam();
    param->max_dist = 120.0f;
    param->min_dist = 120.0f;
    param->near_height = 12.0f;
    param->far_height = 12.0f;
    if (GetCaptureMode() != 0) {
        srand(kCaptureSeed);
    }
    LoadExMotionBG(GetNowSubGameInfo(), ReadBuffer);
    return 1;
}
int EndSelectCastingPoint(CScene *scene) {
    mgCCamera *camera = (mgCCamera *)scene->GetCamera(scene->active_camera);
    CCharacter2 *chara;

    if (camera == NULL || camera->Iam() != kCameraSettled) {
        return 1;
    }
    CameraInfo.CopyParam(*(CCameraControl *)camera);
    if (GetNowSubGameInfo()->dungeon == 0) {
        chara = scene->GetCharacter(scene->player_chara);
        if (chara != NULL) {
            chara->DeleteExtMotion();
            chara->SetMotion(at_1397__3, 4);
        }
    }
    SetWaterLevel(-100000.0f);
    CastOKFlag = 0;
    return 1;
}
void SelectCastingPoint(CScene *scene, CPadControl *pad) {
    CCharacter2 *chara;
    CCameraControl *camera;
    float matrix[4][4];
    float rotation[4];
    float position[4];
    float cast_dir[4];
    float target[4];
    float follow_offset[4];
    float camera_pos[4];
    float diff[4];
    float angle_diff;
    float turn;
    float max_dist;
    float cast_distance;
    float ratio;
    float lean;
    float lean_abs;
    int saved_cancel;
    int castable;

    if (pad == NULL) {
        return;
    }
    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return;
    }
    camera = (CCameraControl *)scene->GetCamera(scene->active_camera);
    if (camera == NULL) {
        return;
    }
    switch (((mgCCamera *)camera)->Iam()) {
        case kCameraSettled:
            break;
        default:
            return;
    }
    chara->GetPosition(position);
    chara->GetRotation(rotation);
    mgCreateMatrixPY(matrix, position, rotation[1]);
    angle_diff = mgAngleLimit(rotation[1] - mgAngleLimit(camera->GetAngle() - 3.1415927f));
    turn = 0.0f;
    if (!(angle_diff <= 0.4f)) {
        turn = 0.2f * mgAngleLimit(angle_diff - 0.4f);
    }
    if (angle_diff < -0.4f) {
        turn = 0.2f * mgAngleLimit(0.4f + angle_diff);
    }
    camera->Rotate(turn);
    CastDist -= 5.0f * pad->Analog(4);
    max_dist = 240.0f * (0.5f * (1.0f + (float)RodData.status[0] / 100.0f));
    max_dist += 160.0f;
    if (CastDist < 160.0f) {
        CastDist = 160.0f;
    }
    if (!(CastDist <= max_dist)) {
        CastDist = max_dist;
    }
    cast_distance = CastDist;
    CastDistSizeRate = (cast_distance - 160.0f) / 240.0f;
    CastDistSizeRate = 0.8f + 0.4f * CastDistSizeRate;
    *(u_long128 *)cast_dir = *(u_long128 *)&at_1631__3;
    cast_dir[2] = cast_distance;
    sceVu0ApplyMatrix(cast_dir, matrix, cast_dir);
    camera->GetFollowOffset(follow_offset);
    sceVu0AddVector(target, cast_dir, follow_offset);
    camera->GetPos(camera_pos);
    ratio = mgDistVectorXZ(camera_pos, position);
    ratio = ratio / mgDistVectorXZ(camera_pos, cast_dir);
    sceVu0SubVector(diff, target, camera_pos);
    sceVu0ScaleVector(diff, diff, ratio);
    sceVu0AddVector(target, diff, camera_pos);
    sceVu0SubVector(target, target, follow_offset);
    target[0] = position[0];
    target[2] = position[2];
    saved_cancel = camera->rot_cancel;
    camera->BitSetRotCameraCancel(0x80);
    EditCameraControl(scene, pad, NULL);
    camera->SetRotCameraCancel(saved_cancel);
    castable = CheckCasting(scene, position, cast_dir);
    if (mgDistVectorXZ(camera_pos, position) < 30.0f) {
        castable = 0;
    }
    if (castable > 0) {
        CastOKFlag = 1;
    } else {
        CastOKFlag = 0;
    }
    *(u_long128 *)&CastPoint = *(u_long128 *)cast_dir;
    *(u_long128 *)&CastPointCur = *(u_long128 *)cast_dir;
    if (CastOKFlag != 0) {
        SetWaterLevel(cast_dir[1]);
        ShowHelpMes(0x66, 1);
    } else {
        SetWaterLevel(-100000.0f);
        ShowHelpMes(0x6A, 1);
        if (!(cast_dir[1] <= position[1])) {
            cast_dir[1] = position[1];
        }
    }
    CastPoint.v[1] = cast_dir[1];
    CastPointCur.v[1] = cast_dir[1];
    lean = 0.05f * -pad->Analog(5);
    lean_abs = lean < 0.0f ? -lean : lean;
    if (!(lean_abs <= 0.01f)) {
        rotation[1] = mgAngleLimit(rotation[1] + lean);
        chara->SetRotation(rotation);
        chara->SetMotion(at_1576__2, 0);
    } else {
        chara->SetMotion(at_1397__3, 0);
    }
    ReadBG();
    if (CastOKFlag != 0 && pad->Btn(kPadButtonCast) != 0) {
        if (InitCasting(scene) != 0) {
            SetNextMode(2);
        }
    } else if (pad->Btn(kPadButtonCancel) != 0) {
        BreakReadBG();
        if (EndSelectCastingPoint(scene) != 0) {
            SetNextMode(0);
        }
    }
}
void DrawHamon(float *pos, float scale) {
    if (EffectMan != NULL) {
        float pos_vec[4];
        Vec4 scale_vec = at_1681__2;
        scale_vec.v[0] = scale;
        scale_vec.v[1] = scale;
        scale_vec.v[2] = scale;
        *(u_long128 *)pos_vec = *(u_long128 *)pos;
        pos_vec[1] = 0.5f + GetWaterLevel();
        EffectMan->CreateEffSpt(at_1683__2, 0, 0);
        EffectMan->SetScriptVect1(pos_vec, -1, -1);
        EffectMan->SetScriptVect2(scale_vec.v, -1, -1);
    }
}
void DrawSplash(float *pos, float scale) {
    if (EffectMan != NULL) {
        float pos_vec[4];
        Vec4 scale_vec = at_1689;
        scale_vec.v[0] = scale;
        scale_vec.v[1] = scale;
        scale_vec.v[2] = scale;
        *(u_long128 *)pos_vec = *(u_long128 *)pos;
        pos_vec[1] = 0.5f + GetWaterLevel();
        EffectMan->CreateEffSpt(at_1691__2, 0, 0);
        EffectMan->SetScriptVect1(pos_vec, -1, -1);
        EffectMan->SetScriptVect2(scale_vec.v, -1, -1);
    }
}
int GetMotionCount(CCharacter2 *chara, char *name, int min_count, int max_count, int min_speed) {
    CHRINFO_KEY_SET *list;
    float speed;
    float floor;
    int count;

    list = chara->GetKeyListPtr(name, NULL);
    if (list == NULL) {
        return min_count;
    }
    speed = list->step;
    floor = (float)min_speed;
    if (speed < floor) {
        speed = floor;
    }
    count = fptosi((float)(list->end_frame - list->start_frame) / speed);
    if (count <= min_count) {
        count = min_count;
    }
    if (count >= max_count) {
        count = max_count;
    }
    return count;
}
int InitCasting(CScene *scene) {
    CCharacter2 *chara;

    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return 0;
    }
    MotionBuff.stack_used = 0;
    MotionBuff.lock = 0;
    while (LoadExMotionStep(GetNowSubGameInfo(), &MotionBuff) != 0) {
    }
    chara->SetMotion(at_1722, 4);
    chara->Step();
    CastStep = 0;
    CastTime = 60;
    CastCount = 0;
    chara->SetMotion(at_1723__2, 2);
    CastMotionCnt = GetMotionCount(chara, at_1723__2, 20, 300, 0);
    return 1;
}
void CastingLoop(CScene *scene, CPadControl *pad) {
    CCharacter2 *chara;
    float hari_pos[4];
    float hari_prev[4];
    chara = scene->GetCharacter(scene->player_chara);
    if (chara != NULL) {
        EditCameraControl(scene, pad, NULL);
        GetHariPos(hari_pos, hari_prev);
        if (hari_pos[1] <= GetWaterLevel() && !(hari_prev[1] <= GetWaterLevel())) {
            DrawHamon(hari_pos, 0.8f);
            sndSePlay(FishSnd, 4, 0);
        }
        if (CastStep == 0) {
            CastCount += 1;
            if (CastCount == 0x23) {
                sndSePlay(FishSnd, 0, 0);
                CastTime = CastingLure(CastPoint.v);
            }
            CastMotionCnt -= 1;
            if (CastMotionCnt <= 0) {
                CastCount = 0;
                CastStep = 1;
                chara->SetMotion(at_1749__2, 0);
                return;
            }
        } else if (CastStep == 1) {
            CastCount += 1;
            if (CastCount >= CastTime) {
                EndCastingLure();
                if (InitUkiWait(scene) != 0) {
                    SetNextMode(3);
                }
            }
        }
    }
}
int InitUkiWait(CScene *scene) {
    RodActFlag = 0;
    UkiMode = kUkiStart;
    UkiModeCnt = 0;
    UkiCameraFlag = 0;
    return 1;
}
void ResetUkiCamera(CCameraControl *camera) {
    if (UkiCameraFlag != 0) {
        camera->RotBack(UkiCamOldRot);
        if (camera != NULL) {
            UkiCameraInfo.CopyParam(*camera);
        }
    }
    UkiCameraFlag = 0;
}
void UkiWaitLoop(CScene *scene, CPadControl *pad) {
    int moved;
    int up_push;
    int right_push;
    int left_push;
    CCharacter2 *chara;
    CCameraControl *camera;
    int pushed;
    CameraCtrlParam *param;
    float stick_side;
    float stick_up;
    int up_now;
    u_char right_now;
    u_char left_now;
    u_char up_old;
    u_char right_old;
    u_char left_old;
    int reel_result;
    int reel_sound;
    int reel_held;
    int caught;
    float hari_pos[4];
    float hari_prev[4];
    float chara_pos[4];
    float hari_now[4];
    float hari_now_prev[4];
    float uki_pos[4];
    float uki_prev[4];
    float chara_now[4];
    float camera_target[1][4];
    float uki_pos2[4];
    float dist;
    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return;
    }
    camera = (CCameraControl *)scene->GetCamera(scene->active_camera);
    if (UkiMode == kUkiReeledIn) {
        UkiModeCnt += 1;
        if (UkiModeCnt > 15) {
            EndSelectCastingPoint(scene);
            if (chara != NULL) {
                chara->SetMotion(at_1397__3, 4);
            }
            SetNextMode(0);
        }
        return;
    }
    moved = 1;
    stick_side = pad->Analog(kFishAxisSide);
    stick_up = pad->Analog(kFishAxisUp);
    if (stick_up > 0.8f) {
        RodActFlag = 1;
        chara->SetMotion(at_1920, 6);
    } else if (stick_side > 0.8f) {
        RodActFlag = 1;
        chara->SetMotion(at_1921, 6);
    } else if (stick_side < -0.8f) {
        RodActFlag = 1;
        chara->SetMotion(at_1922, 6);
    } else {
        chara->SetMotion(at_1749__2, 0);
        moved = 0;
    }
    right_now = stick_side > 0.8f;
    left_now = stick_side < -0.8f;
    up_old = oldPadRy > 0.8f;
    right_old = oldPadRx > 0.8f;
    left_old = oldPadRx < -0.8f;
    up_now = stick_up > 0.8f;
    up_push = up_now && !up_old;
    right_push = right_now && !right_old;
    left_push = left_now && !left_old;
    pushed = up_push || right_push || left_push;
    reel_result = 0;
    reel_held = 0;
    reel_sound = 7;
    if (pad->Btn(kFishBtnReel) != 0) {
        reel_sound = 7;
        reel_result = ExtendLine(-1.0f);
        moved = reel_held = 1;
    } else if (pad->Btn(kFishBtnReelFast) != 0) {
        reel_result = ExtendLine(-2.5f);
        moved = 1;
        reel_held = moved;
        reel_sound = 8;
    }
    if (reel_result < 0) {
        UkiMode = kUkiReeledIn;
        if (chara != NULL) {
            chara->SetMotion(at_1722, 0);
        }
        UkiModeCnt = 0;
        return;
    }
    if (reel_held != 0) {
        scene->loop_se.SeLoopPlayStop(FishSnd, reel_sound, 2, 13);
    }
    GetHariPos(hari_pos, hari_prev);
    ((mgCObject *)chara)->GetPosition(chara_pos);
    if (!(hari_pos[1] <= GetWaterLevel() - 3.0f)) {
        if (GetFishingMode() == kFishingModeFloat) {
            FishData.fish_no = -1;
        }
    }
    if (mgDistVectorXZ(chara_pos, hari_pos) < 160.0f) {
        FishData.fish_no = -1;
    }
    if (init_1799 == 0) {
        hamon_count_1798 = 0;
        init_1799 = 1;
    }
    caught = 0;
    GetHariPos(hari_now, hari_now_prev);
    GetUkiPos(uki_pos, uki_prev);
    ((mgCObject *)chara)->GetPosition(chara_now);
    dist = mgDistVectorXZ(chara_now, hari_now);
    if (dist < 160.0f) {
        dist = 160.0f;
    }
    if (!(dist <= 400.0f)) {
        dist = 400.0f;
    }
    CastDistSizeRate = (dist - 160.0f) / 240.0f;
    CastDistSizeRate = 0.8f + 0.4f * CastDistSizeRate;
    if (GetFishingMode() == kFishingModeFloat) {
        ShowHelpMes(0x67, 1);
        switch (UkiMode) {
            case kUkiStart:
                scene->ResetStatus(1, scene->player_chara, 0x20);
                UkiModeCnt = GetUkiWaitTime(&FishData, scene, hari_now, RodNo, LocalEsaNo);
                boze_cnt_1801 = 0;
                UkiMode = kUkiWaitBite;
                hamon_count_1798 = 10;
            case kUkiWaitBite:
                if (moved != 0 || boze_cnt_1801 > 0x258) {
                    UkiMode = kUkiStart;
                } else {
                    if (hamon_count_1798 <= 0) {
                        DrawHamon(uki_pos, 0.4f);
                        hamon_count_1798 = fptosi(50.0f * mgRnd()) + 30;
                    }
                    hamon_count_1798 -= 1;
                    if (FishData.fish_no < 0) {
                        boze_cnt_1801 += 1;
                    } else if (UkiModeCnt <= 0) {
                        UkiMode = kUkiPoke;
                        UkiModeCnt = GetUkiPokeTime(&FishData);
                        pull_uki_cnt_1808 = 0;
                    }
                }
                break;
            case kUkiPoke:
                if (moved != 0) {
                    UkiMode = kUkiStart;
                } else {
                    if (UkiModeCnt <= 0) {
                        if (FishData.fish_no <= 0) {
                            UkiMode = kUkiStart;
                            break;
                        }
                        UkiMode = kUkiPull;
                        UkiModeCnt = GetUkiPullTime(&FishData);
                    }
                    if (pull_uki_cnt_1808 <= 0) {
                        PullUki(2.0f + 5.0f * mgRnd());
                        GamePad__2.SetVibration(1, 0x50, 10);
                        pull_uki_cnt_1808 = rand() % 10 + 5;
                        DrawHamon(uki_pos, 0.6f);
                    }
                    pull_uki_cnt_1808 -= 1;
                }
                break;
            case kUkiPull:
                if (FishData.fish_no <= 0) {
                    UkiMode = kUkiStart;
                } else {
                    scene->SetStatus(1, scene->player_chara, 0x20);
                    if (pushed != 0) {
                        caught = 1;
                    }
                    GamePad__2.SetVibration(1, 0x96, 4);
                    if (UkiModeCnt <= 0) {
                        UkiMode = kUkiStart;
                    } else {
                        PullUki(10.0f);
                    }
                }
                break;
        }
    } else {
        ShowHelpMes(0x68, 1);
        switch (UkiMode) {
            case kUkiStart:
                scene->ResetStatus(1, scene->player_chara, 0x20);
                RodActionPoint = GetUkiWaitTime(&FishData, scene, hari_now, RodNo, LocalEsaNo);
                act_count_1838 = 0;
                UkiMode = kUkiCharge;
                charge_point_1839 = 0;
                act_interval_1840 = 0;
            case kUkiCharge:
                if (act_count_1838 <= 0 && pushed != 0) {
                    RodActionPoint -= charge_point_1839;
                    act_count_1838 = 0;
                    charge_point_1839 = 0;
                }
                if (pushed != 0 || pad->Btn(kFishBtnAction) != 0) {
                    if (act_interval_1840 < 3) {
                        RodActionPoint = RodActionPoint + fptosi(3.0f * mgRnd());
                    } else {
                        charge_point_1839 += fptosi(10.0f * mgRnd()) + 2;
                        RodActionPoint = RodActionPoint - fptosi(3.0f * mgRnd());
                    }
                    act_interval_1840 = 0;
                    act_count_1838 = fptosi(30.0f * mgRnd()) + 10;
                    DrawHamon(hari_now, 0.5f);
                    sndSePlay(FishSnd, 10, 0);
                }
                act_interval_1840 += 1;
                act_count_1838 -= 1;
                if (FishData.fish_no >= 0 && RodActionPoint < 0) {
                    UkiMode = kUkiBite;
                    UkiModeCnt = 0x23;
                    DrawHamon(hari_now, 0.8f);
                    DrawSplash(hari_now, 0.5f);
                    sndSePlay(FishSnd, 11, 0);
                }
                break;
            case kUkiBite:
                if (UkiModeCnt < 0x20 && pushed != 0) {
                    caught = 1;
                }
                scene->SetStatus(1, scene->player_chara, 0x20);
                GamePad__2.SetVibration(1, 0x96, 4);
                if (UkiModeCnt <= 0) {
                    UkiMode = kUkiStart;
                } else {
                    PullUki(10.0f);
                }
                break;
        }
    }
    UkiModeCnt -= 1;
    if (UkiModeCnt < 0) {
        UkiModeCnt = 0;
    }
    camera->SetRotCameraCancel(0x80);
    if (caught == 0 && GetFishingMode() == kFishingModeFloat) {
        GetUkiPos(camera_target[0], uki_pos2);
        if (!(camera_target[0][1] <= 1.0f + GetWaterLevel())) {
            ResetUkiCamera(camera);
        }
        if (moved != 0) {
            ResetUkiCamera(camera);
        }
        if (UkiCameraFlag != 0) {
            camera_target[0][1] = GetWaterLevel() - 20.0f;
            EditCameraControl(scene, NULL, camera_target);
        } else {
            EditCameraControl(scene, pad, NULL);
        }
    } else {
        EditCameraControl(scene, pad, NULL);
    }
    if (GetFishingMode() == kFishingModeFloat) {
        if (pad->Btn(kFishBtnCameraToggle) != 0) {
            if (UkiCameraFlag == 0) {
                UkiCamOldRot = camera->GetAngle();
                UkiCameraFlag = 1;
                camera->CopyParam(UkiCameraInfo);
                param = camera->GetActiveParam();
                param->SetFixHeight(100.0f);
                param->SetFixDist(80.0f);
                param->no_check = 1;
            } else {
                ResetUkiCamera(camera);
            }
        }
    }
    camera->SetRotCameraCancel(0);
    if (caught != 0) {
        ResetUkiCamera(camera);
        scene->ResetStatus(1, scene->player_chara, 0x20);
        if (InitBattle(scene) != 0) {
            GamePad__2.SetVibration(0, 1, 5);
            SetNextMode(5);
            sndSePlay(FishSnd, 0x12, 0);
            if (MardanEventMap != 0 && MardanEventPlace != 0) {
                RunEventNo = 0x1F9;
                scene->fade.FadeOut(0x14, 0.0f, 0.0f, 0.0f);
            }
            LoadFishFlag = FishLoadBG(&FishData, (u_long128 *)ReadBuffer);
        }
    }
}
int InitBattle(CScene *scene) {
    CCharacter2 *chara;
    mgCCamera *camera;
    CameraCtrlParam *param;
    float chara_rot[4];
    float chara_pos[4];
    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return 0;
    }
    camera = (mgCCamera *)scene->GetCamera(scene->active_camera);
    if (camera == NULL || camera->Iam() != kFishCameraState) {
        return 0;
    }
    ((mgCObject *)chara)->GetPosition(chara_pos);
    ((mgCObject *)chara)->GetRotation(chara_rot);
    param = ((CCameraControl *)camera)->GetActiveParam();
    param->max_dist = 80.0f;
    param->min_dist = 80.0f;
    param->near_height = 12.0f;
    param->far_height = 12.0f;
    ((CCameraControl *)camera)->RotBack(mgAngleLimit(3.1415927f + chara_rot[1] - 0.2f));
    camera->Step(-1);
    InitFishBattle();
    LineTension = 0;
    addLineTension = 0;
    MinLineTension = 0;
    LineMaxLen = GetNowLineLength();
    LineMinLen = GetMinLineLength();
    FishMaxLen = GetFishDist(scene);
    FishMinLen = 90.0f;
    DrawHit = 60;
    RodStatus = 0;
    RodStatusCnt = 0;
    ActionCount = 0;
    ActionDecCount = 0;
    WindReel = 0;
    BattleBgmCnt = 0;
    scene->StopBGM(0);
    BattleCount = 0;
    return 1;
}
void BattleLoop(CScene *scene, CPadControl *pad) {
    int pushed;
    int released;
    CCharacter2 *chara;
    float stick_side;
    float stick_up;
    u_char up_now;
    u_char right_now;
    u_char left_now;
    u_char up_old;
    u_char right_old;
    u_char left_old;
    int rod_dir;
    int rod_chance;
    int rod_sound;
    int reel_result;
    int finished;
    float hari_pos[4];
    float hari_prev[4];
    CCPoly polys[0x400];
    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return;
    }
    EditCameraControl(scene, pad, NULL);
    ReadBG();
    ShowHelpMes(0x69, 1);
    if (RunEventNo > 0 && scene->fade.FadeCheck() != 0) {
        scene->StopBGM(0);
        scene->InitBGM();
        scene->RunEvent(RunEventNo, NULL);
        EsaInit();
        EsaChara = 0;
        GetSaveData()->user_data.DeleteBait();
        EndSelectCastingPoint(scene);
        ExitFishing(scene);
        return;
    }
    if (BattleBgmCnt == 20) {
        scene->PlayBGM(1, -1, 1.0f);
    }
    BattleBgmCnt += 1;
    stick_side = pad->Analog(kFishAxisSide);
    stick_up = pad->Analog(kFishAxisUp);
    up_now = stick_up > 0.8f;
    right_now = stick_side > 0.8f;
    left_now = stick_side < -0.8f;
    up_old = oldPadRy > 0.8f;
    right_old = oldPadRx > 0.8f;
    left_old = oldPadRx < -0.8f;
    pushed = (up_now && !up_old) || (right_now && !right_old) || (left_now && !left_old);
    released = (!up_now && up_old) || (!right_now && right_old) || (!left_now && left_old);
    rod_dir = 0;
    if (right_now) {
        rod_dir = 1;
    }
    if (left_now) {
        rod_dir = -1;
    }
    rod_chance = CheckRodActionChance(rod_dir, &rod_sound);
    if (rod_sound != 0) {
        sndSePlay(FishSnd, 0x11, 0);
    }
    if (init_1961 == 0) {
        snd_cnt_1960 = 0;
        init_1961 = 1;
    }
    if (pushed) {
        GetHariPos(hari_pos, hari_prev);
        sndSePlay(FishSnd, 0xB, 0);
        DrawSplash(hari_pos, 0.5f);
        if (snd_cnt_1960 == 0) {
            sndSePlay(FishSnd, 9, 0);
            snd_cnt_1960 = 10;
        }
    }
    snd_cnt_1960 -= 1;
    if (snd_cnt_1960 < 0) {
        snd_cnt_1960 = 0;
    }
    switch (RodStatus) {
        case 0:
            if (pushed) {
                RodStatus = 1;
                RodStatusCnt = 20;
            } else if (released) {
                RodStatus = 2;
                RodStatusCnt = 20;
            }
            break;
        case 1:
            if (RodStatusCnt == 0) {
                RodStatus = 0;
            } else if (released) {
                RodStatus = 2;
            }
            break;
        case 2:
            if (RodStatusCnt == 0) {
                RodStatus = 0;
            } else if (pushed) {
                RodStatus = 1;
            }
            break;
    }
    RodStatusCnt -= 1;
    BattleCount += 1;
    if (stick_up > 0.8f) {
        chara->SetMotion(at_2057, 0);
    } else if (stick_side > 0.8f) {
        chara->SetMotion(at_2058, 0);
    } else if (stick_side < -0.8f) {
        chara->SetMotion(at_2059, 0);
    } else {
        chara->SetMotion(at_2060, 0);
    }
    reel_result = 0;
    if (pad->Btn(kFishBtnReel) != 0) {
        scene->loop_se.SeLoopPlayStop(FishSnd, 7, 2, 100);
        reel_result = ExtendLine(-1.0f);
        WindReel = 1;
    } else {
        WindReel = 0;
    }
    if (pushed || pad->Btn(kFishBtnAction) != 0) {
        ActionCount += 1;
        ActionDecCount = 10;
    }
    ActionDecCount -= 1;
    if (ActionDecCount <= 0) {
        ActionCount -= 1;
        if (ActionCount < 0) {
            ActionCount = 0;
        }
    }
    FishBattle(scene, polys, 0x400);
    LineTensionStep(&FishData, rod_chance);
    finished = 0;
    if (GetFishDist(scene) < FishMinLen || reel_result < 0) {
        finished = 1;
    }
    if (BattleCount < 100) {
        finished = 0;
    }
    if (MardanEventMap != 0 && MardanEventPlace != 0) {
        finished = 0;
    }
    if (!(LineTension < 1.0f)) {
        if (InitFalse(scene) != 0) {
            EndFishBattle();
            SetNextMode(6);
            sndSePlay(FishSnd, 0x13, 0);
            scene->StopBGM(0);
        }
    } else if (finished != 0) {
        if (LoadFishFlag == 0) {
            if (InitFalse(scene) != 0) {
                EndFishBattle();
                SetNextMode(6);
            }
        } else if (InitSuccess(scene) != 0) {
            EndFishBattle();
            SetNextMode(7);
            sndSePlay(FishSnd, 0x14, 0);
            scene->StopBGM(0);
        }
    }
}
float GetFishDist(CScene *scene) {
    float chara_rot[4];
    float chara_pos[4];
    float fish_pos[4];
    float fish_velo[4];
    float matrix[16];
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);
    ((mgCObject *)chara)->GetPosition(chara_pos);
    ((mgCObject *)chara)->GetRotation(chara_rot);
    mgUnitMatrix((float(*)[4])matrix);
    sceVu0RotMatrixY((float(*)[4])matrix, (float(*)[4])matrix, chara_rot[1]);
    GetFishPosVelo(fish_pos, fish_velo);
    return mgDistVectorXZ(chara_pos, fish_pos);
}
void DeleteEsa(void) {
    CSaveData *saved = GetSaveData();
    EsaInit();
    EsaChara = 0;
    saved->user_data.DeleteBait();
}
int InitFalse(CScene *scene) {
    CCharacter2 *chara;
    mgCCamera *camera;
    float roll;
    float chance;
    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return 0;
    }
    camera = (mgCCamera *)scene->GetCamera(scene->active_camera);
    if (camera == NULL || camera->Iam() != kFishCameraState) {
        return 0;
    }
    ExtendLine(-1000.0f);
    ExtendLine(20.0f);
    ResetLineVelo();
    FalseStep = 0;
    chara->SetMotion(at_2099, 6);
    FalseMotionCount = GetMotionCount(chara, at_2099, 20, 300, 0);
    roll = mgRnd();
    chance = 0.3f;
    chance *= 1.0f - 0.5f * RodData.status4_rate;
    if (GetFishingMode() == kFishingModeLure) {
        chance *= 0.5f;
    }
    if (roll < chance) {
        DeleteEsa();
    }
    return 1;
}
void FalseLoop(CScene *scene, CPadControl *pad) {
    CCharacter2 *chara;
    mgCCamera *camera;
    CameraCtrlParam *param;
    float chara_rot[4];
    float chara_pos[4];
    float ref_pos[4];
    float cam_pos[4];
    if (pad == NULL) {
        return;
    }
    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return;
    }
    camera = (mgCCamera *)scene->GetCamera(scene->active_camera);
    if (camera == NULL) {
        return;
    }
    switch (camera->Iam()) {
        case kFishCameraState:
            break;
        default:
            return;
    }
    ((mgCObject *)chara)->GetPosition(chara_pos);
    ((mgCObject *)chara)->GetPosition(ref_pos);
    ((mgCObject *)chara)->GetRotation(chara_rot);
    param = ((CCameraControl *)camera)->GetActiveParam();
    param->max_dist = 80.0f;
    param->min_dist = 80.0f;
    param->near_height = -5.0f;
    param->far_height = -5.0f;
    param->min_height = -5.0f;
    ref_pos[1] += 15.0f;
    ((CCameraControl *)camera)->GetPos(cam_pos);
    cam_pos[1] = 5.0f + ref_pos[1];
    ((CCameraControl *)camera)->SetRef(ref_pos);
    ((CCameraControl *)camera)->SetPos(cam_pos);
    ((CCameraControl *)camera)->SetRotate(mgAngleLimit(chara_rot[1] - 0.2f));
    camera->Step(-1);
    FalseMotionCount -= 1;
    if (FalseStep == 0 && (FalseMotionCount <= 0 || chara->CheckMotionEnd() != 0)) {
        chara->SetMotion(at_2127__3, 4);
        FalseStep = 1;
        FalseMotionCount = 40;
    }
    if (FalseStep > 0 && FalseMotionCount <= 0 && pad->Btn(kFishBtnAction) != 0) {
        ExtendLine(-1000.0f);
        ResetLineVelo();
        EndSelectCastingPoint(scene);
        SetNextMode(0);
        ((CCameraControl *)camera)->RotBack(mgAngleLimit(3.1415927f + chara_rot[1]));
        scene->PlayBGM(0, -1, 1.0f);
    }
}
int InitSuccess(CScene *scene) {
    mgCTextureManager *tex_manager;
    CCharacter2 *fish_chara;
    CCharacter2 *chara;
    ClsMes *message;
    CSaveData *save_data;
    FISH_PARAM *fish_param;
    int fish_item_no;
    float fish_size;
    float fish_weight;
    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return 0;
    }
    mgCCamera *camera = (mgCCamera *)scene->GetCamera(scene->active_camera);
    if (camera == NULL || camera->Iam() != kFishCameraState) {
        return 0;
    }
    tex_manager = &mgTexManager;
    FishFontH = 0;
    if (LoadFishFlag != 0) {
        while (ReadBGSync() != 0) {
        }
        int size = FreeSize(&MotionBuff);
        FishStack.stSetBuffer((u_long128 *)FreeTop(&MotionBuff), size);
        FishStack.stack_used = 0;
        FishStack.lock = 0;

        if ((fish_chara = (CCharacter2 *)operator new(sizeof(CCharacter2), FishStack.Alloc(0x68))) != NULL) {
            *(void ***)fish_chara = __vt__9mgCObject;
            fish_chara->Initialize();
            *(void ***)fish_chara = __vt__7CObject;
            fish_chara->Initialize();
            *(void ***)fish_chara = __vt__12CObjectFrame;
            fish_chara->Initialize();
            *(void ***)fish_chara = __vt__11CCharacter2;
            fish_chara->shadow_link.num = 0;
            fish_chara->shadow_link.dst_frame = 0;
            fish_chara->shadow_link.src_frame = 0;
            fish_chara->Initialize();
        }
        FishChara = fish_chara;
        fish_chara->Initialize();
        tex_manager->DeleteBlock(FishTexb);
        FishChara->LoadPack((u_int *)ReadBuffer, at_932__4, &FishStack, &FishStack, &FishStack,
                              FishTexb, NULL);
        FishChara->SetScale(FishData.width_scale, FishData.width_scale, FishData.length_scale);
        FishChara->SetMotion(at_2197__3, 0);
    }
    ExtendLine(-1000.0f);
    ExtendLine(20.0f);
    ResetLineVelo();
    FalseStep = 0;
    chara->SetMotion(at_2198__3, 6);
    FalseMotionCount = GetMotionCount(chara, at_2198__3, 20, 300, 0);
    save_data = GetSaveData();
    if (GetFishingMode() == kFishingModeFloat) {
        DeleteEsa();
    }
    GetItemRet = 0;
    message = scene->GetMessage(1);
    fish_param = GetFishParam(FishData.fish_no);
    message->values[0] = 0;
    message->value_width[0] = 0;
    fish_item_no = -1;
    message->values[1] = 0;
    message->value_width[1] = 0;
    if (fish_param != NULL) {
        fish_size = FishData.size / 100.0f;
        fish_item_no = fish_param->item_no;
        fish_weight = FishData.weight;
        GetItemRet = save_data->user_data.GetFishInAquarium(fish_item_no, fish_size, fish_weight);
        save_data->user_data.AddFp(FishData.fishing_point);
        save_data->user_data.CheckFishRecordUpdate(fish_item_no, fish_size, fish_weight);
    }
    DrawCongra = 100;
    SetShowHari(0);
    if (fish_item_no >= 0) {
        message->Preset(4);
        message->SetWindowMode(4);
        message->item_mes[0] = GetItemMessageNo(fish_param->item_no, 1);
        message->values[0] = fptosi(FishData.size);
        message->value_width[0] = 0;
        message->values[1] = FishData.fishing_point;
        message->value_width[1] = 0;
        if (LanguageCode > 0 && LanguageCode < 6) {
            message->value_half = 1;
        }
        FishFontH = message->font_h;
        message->font_h += 4;
        message->MakeMesWin(13);
        message->fukidashi_pos = 8;
        message->abs_win.height = message->font_h * 4 - message->font_h / 2 + 4;
    }
    sndSePlay(FanSnd, 0, 0);
    return 1;
}
void SuccessLoop(CScene *scene, CPadControl *pad) {
    ClsMes *message;
    CCharacter2 *chara;
    mgCCamera *camera;
    CameraCtrlParam *param;
    float chara_rot[4];
    float chara_pos[4];
    float ref_pos[4];
    float cam_pos[4];
    if (pad == NULL) {
        return;
    }
    chara = scene->GetCharacter(scene->player_chara);
    if (chara == NULL) {
        return;
    }
    camera = (mgCCamera *)scene->GetCamera(scene->active_camera);
    if (camera == NULL) {
        return;
    }
    switch (camera->Iam()) {
        case kFishCameraState:
            break;
        default:
            return;
    }
    message = scene->GetMessage(1);
    ((mgCObject *)chara)->GetPosition(chara_pos);
    ((mgCObject *)chara)->GetPosition(ref_pos);
    ((mgCObject *)chara)->GetRotation(chara_rot);
    param = ((CCameraControl *)camera)->GetActiveParam();
    param->max_dist = 80.0f;
    param->min_dist = 80.0f;
    param->near_height = -5.0f;
    param->far_height = -5.0f;
    param->min_height = -5.0f;
    ref_pos[1] += 15.0f;
    ((CCameraControl *)camera)->GetPos(cam_pos);
    cam_pos[1] = 5.0f + ref_pos[1];
    ((CCameraControl *)camera)->SetRef(ref_pos);
    ((CCameraControl *)camera)->SetPos(cam_pos);
    ((CCameraControl *)camera)->SetRotate(mgAngleLimit(chara_rot[1] - 0.2f));
    camera->Step(-1);
    FalseMotionCount -= 1;
    if (FalseStep == 0 && (FalseMotionCount <= 0 || chara->CheckMotionEnd() != 0)) {
        chara->SetMotion(at_2272, 4);
        FalseStep2 = 0;
        FalseStep = 1;
        FalseMotionCount = 60;
    }
    if (FalseMotionCount <= 0) {
        FalseMotionCount = 0;
    }
    if (init_2217 == 0) {
        font_h_2216 = 0;
        init_2217 = 1;
    }
    if (FalseStep == 1) {
        if (FalseMotionCount <= 0 && pad->Btn(kFishBtnAction) != 0) {
            if (message->select < 0) {
                message->cursor_time = 0;
            }
            message->select = -1;
            message->draw_speed = message->GetDrawSpeedDef();
            message->mes_no = -1;
            message->unk_1e40 = 0;
            message->open = 0;
            message->fade = 0.0f;
            message->fukidashi_centre_x = -1;
            message->fukidashi_centre_y = -1;
            message->fukidashi_pos = 0;
            if (FishFontH > 0) {
                message->font_h = FishFontH;
            }
            message->abs_win.height = -1;
            sndSePlay(GetSystemSndID(), 0x19, 0);
            FalseStep = 3;
            if (GetSaveData()->GetBitFlag(0x3C) == 0) {
                FalseStep2 = 0;
                FalseStep = 2;
                FishMesNo = 0x7D1;
            }
            if (GetNowSubGameInfo()->record_check != 0 &&
                CheckFishingRecord(FishData.size / 100.0f) != 0) {
                FalseStep2 = 0;
                FalseStep = 2;
                FishMesNo = 0x7D2;
            }
            return;
        }
    }
    if (FalseStep == 2) {
        ClsMes *result_message = scene->GetMessage(1);
        int state = result_message->State();
        int confirm = pad->Btn(kFishBtnAction);
        switch (FalseStep2) {
            case 0:
                GetSaveData()->SetBitFlag(0x3C, 1);
                result_message->Preset(4);
                result_message->SetWindowMode(4);
                result_message->MakeMesWin(FishMesNo);
                result_message->fukidashi_pos = 8;
                FalseStep2 += 1;
                break;
            case 1:
                switch (state) {
                    case 5:
                        if (confirm != 0) {
                            result_message->GoNextPage();
                            sndSePlay(GetSystemSndID(), 0x19, 0);
                            if (FishMesNo == 0x7D2) {
                                sndSePlay(GetSystemSndID(), 0x12, 0);
                            }
                        }
                        break;
                    case 3:
                        if (confirm != 0) {
                            FalseStep2 += 1;
                            sndSePlay(GetSystemSndID(), 0x19, 0);
                        }
                        break;
                    case 0:
                        FalseStep2 += 1;
                        break;
                }
                break;
            case 2:
                if (result_message->select < 0) {
                    result_message->cursor_time = 0;
                }
                result_message->select = -1;
                result_message->draw_speed = result_message->GetDrawSpeedDef();
                result_message->mes_no = -1;
                result_message->unk_1e40 = 0;
                result_message->open = 0;
                result_message->fade = 0.0f;
                result_message->fukidashi_centre_x = -1;
                result_message->fukidashi_centre_y = -1;
                result_message->fukidashi_pos = 0;
                FalseStep = 3;
                break;
        }
    }
    if (FalseStep >= 3) {
        ExtendLine(-1000.0f);
        ResetLineVelo();
        EndSelectCastingPoint(scene);
        SetNextMode(0);
        FishChara = NULL;
        mgTexManager.DeleteBlock(FishTexb);
        ((CCameraControl *)camera)->RotBack(mgAngleLimit(3.1415927f + chara_rot[1]));
        SetShowHari(1);
        scene->PlayBGM(0, -1, 1.0f);
        if (GetItemRet != 0) {
            sgGetItemOverFlagOn();
        }
    }
}
int CheckFishing(float *pos, CCPoly *polys, int count) {
    float end[4];
    int hit_index[32];
    float hit_point[32][4];
    int hits;
    int i;
    *(u_long128 *)end = *(u_long128 *)pos;
    end[1] -= 140.0f;
    hits = CheckHits(polys, count, pos, end, 32, hit_index, hit_point, 1, 0);
    i = 0;
    if (hits <= 0) {
        return 0;
    }
    for (; i < 1; i++) {
        int index = hit_index[i];
        float height = hit_point[i][1];
        pos[1] = height;
        if (polys[index].area_kind == 7) {
            return 1;
        }
    }
    return 0;
}
#ifdef NONMATCHING
int CheckCasting(CScene *scene, float *position, float *direction) {
    mgVu0FBOX box;
    CCPoly polys[0x400];
    float end[4];
    float move_dir[4];
    float step_point[4];
    float from[4];
    float to[4];
    float point_a[4];
    float point_b[4];
    float point_dir[4];
    float probe[4];
    float hit_point[32][4];
    int hit_index[32];

    mgVectorMaxMin(box.max, box.min, position, direction);
    box.max[3] = 1.0f;
    box.max[0] += 40.0f;
    box.max[1] += 2000.0f;
    box.max[2] += 40.0f;
    box.min[0] -= 40.0f;
    box.min[3] = 1.0f;
    box.min[1] -= 2000.0f;
    box.min[2] -= 40.0f;
    int poly_count = scene->GetColPoly(polys, box, 0x400);
    direction[1] = 40.0f + position[1];
    sceVu0SubVector(move_dir, direction, position);
    move_dir[3] = 0.0f;
    *(u_long128 *)end = *(u_long128 *)direction;
    *(u_long128 *)from = *(u_long128 *)position;
    *(u_long128 *)to = *(u_long128 *)direction;
    from[1] = direction[1];
    from[3] = 1.0f;
    *(u_long128 *)point_b = *(u_long128 *)direction;
    if (CheckFishing(direction, polys, poly_count) == 0) {
        return 0;
    }
    to[1] = 1.0f + (direction[1] + from[3]);
    mgNormalizeVector(step_point, move_dir, 80.0f);
    mgAddVector(step_point, position);
    step_point[1] = end[1];
    *(u_long128 *)point_a = *(u_long128 *)step_point;
    if (CheckFishing(step_point, polys, poly_count) == 0) {
        return 0;
    }
    sceVu0SubVector(point_dir, point_b, point_a);
    point_dir[1] = 0.0f;
    mgNormalizeVector(point_dir, point_dir, 10.0f);
    int steps = fptosi(mgDistVectorXZ(point_a, point_b) / 10.0f);
    mgAddVector(point_a, point_dir);
    for (int i = 1; i < steps; i++) {
        *(u_long128 *)probe = *(u_long128 *)point_a;
        if (CheckFishing(probe, polys, poly_count) == 0) {
            return 0;
        }
        mgAddVector(point_a, point_dir);
    }
    return CheckHits(polys, poly_count, from, to, 32, hit_index, hit_point, 0, 9) <= 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishing", CheckCasting__FP6CScenePfPf);
#endif
float GetRandamNumber(float center, float high, float floor) {
    float value = mgNRnd();
    value = center + value * ((high - center) / 3.0f);
    if (value < floor) {
        value = floor + (center - floor) * mgRnd();
    }
    return value;
}
#ifdef NONMATCHING
int GetUkiWaitTime(FISH_DATA *fish, CScene *scene, float *position, int rod_no, int bait_no) {
    FISH_PLACE place[16];
    int candidate_num = 0;
    float rate_sum = 0.0f;
    int picked;
    int fish_no;
    float size;
    float weight;
    float length_scale;
    float width_scale;
    float pull_strength;
    int fishing_point;
    int wait_time;

    if (bait_no < 0) {
        fish->fish_no = -1;
        return 100;
    }
    int time_band = GetTimeBand(scene->time);
    int place_num = GetAppearFish(scene->GetMainMapNo(), position, place, 16);
    for (int i = 0; i < place_num; i++) {
        FISH_PARAM *param = GetFishParam(place[i].fish_no);
        if (param != NULL) {
            int bait_affinity = 0;
            if (bait_no >= 0 && bait_no < 18) {
                bait_affinity = param->bait_affinity[bait_no];
            }
            if (place[i].fish_no > 0) {
                switch (bait_affinity) {
                    case FISH_AFFINITY_NORMAL:
                        break;
                    case FISH_AFFINITY_NONE:
                        place[i].rate = 0.0f;
                        break;
                    case FISH_AFFINITY_LOW:
                        place[i].rate = place[i].rate * 0.5f;
                        break;
                    case FISH_AFFINITY_HIGH:
                        place[i].rate = place[i].rate * 1.5f;
                        break;
                }
                int time_affinity = 0;
                if (time_band >= 0 && time_band < 4) {
                    time_affinity = param->time_band_affinity[time_band];
                }
                switch (time_affinity) {
                    case FISH_AFFINITY_NORMAL:
                        break;
                    case FISH_AFFINITY_NONE:
                        place[i].rate = 0.0f;
                        break;
                    case FISH_AFFINITY_LOW:
                        place[i].rate = place[i].rate * 0.5f;
                        break;
                    case FISH_AFFINITY_HIGH:
                        place[i].rate = place[i].rate * 1.5f;
                        break;
                }
            }
            if (place[i].fish_no == 0) {
                place[i].rate = place[i].rate * (1.0f - 0.5f * RodData.status4_rate);
            }
            rate_sum += place[i].rate;
            if (!(place[i].rate <= 0.0f)) {
                candidate_num++;
            }
        }
    }
    float roll = mgRnd();
    float cumulative = 0.0f;
    picked = 0;
    for (; picked < place_num; picked++) {
        place[picked].rate = place[picked].rate / rate_sum;
        if (!(place[picked].rate <= 0.0f)) {
            cumulative += place[picked].rate;
            if (!(cumulative <= roll)) {
                break;
            }
        }
    }
    int wait_base = 240;
    int wait_extra = 240;
    FavoredEsa = 0;
    fishing_point = 0;
    fish_no = place[picked].fish_no;
    size = 100.0f;
    width_scale = 1.0f;
    length_scale = 1.0f;
    pull_strength = 0.5f;
    if (MardanEventMap != 0 && bait_no == 4 && position[0] < 1000.0f && position[2] < -300.0f) {
        MardanEventPlace = 1;
    }
    if (MardanEventPlace != 0) {
        fish->vigour_recovery = 0.005f;
        fish_no = 7;
        wait_time = 100;
        size = 500.0f;
        FavoredEsa = 2;
    } else {
        if (candidate_num <= 0) {
            return 100;
        }
        if (fish_no == 0) {
            fish->fish_no = -1;
            return 100;
        }
        float wait_bias = 0.0f;
        if (fish_no > 0) {
            FISH_PARAM *param = GetFishParam(fish_no);
            int bait_affinity = 0;
            if (bait_no >= 0 && bait_no < 18) {
                bait_affinity = param->bait_affinity[bait_no];
            }
            FavoredEsa = bait_affinity;
            wait_bias = place[picked].wait_bias;
            if (!(wait_bias <= 2.0f)) {
                wait_bias = 2.0f;
            }
            if (wait_bias < -2.0f) {
                wait_bias = -2.0f;
            }
            size = GetRandamNumber(param->min_size * CastDistSizeRate, param->max_size * CastDistSizeRate,
                                   param->min_size * CastDistSizeRate / 2.0f);
            if (GetCaptureMode() != 0) {
                size = 60.0f;
            }
            length_scale = size / param->base_size * 1.05f;
            if (!(length_scale <= 4.0f)) {
                length_scale = 4.0f;
            }
            float width_rate = GetRandamNumber(1.0f, 1.3f, 0.6f);
            if (!(width_rate <= 1.3f)) {
                width_rate = 1.3f;
            }
            width_scale = length_scale * width_rate;
            weight = width_rate * (size * param->weight_rate);
            pull_strength = param->pull_rate * (size / 80.0f * width_rate);
            fishing_point = fptosi(width_rate * (param->fishing_point_rate * size));
            if (GetFishingMode() == 2) {
                fishing_point *= 2;
            }
        }
        if (rod_no == 0x12F) {
            wait_base = 240 / 2;
            wait_extra = 240 / 2;
        }
        if (!(wait_bias < 0.0f)) {
            float rate = 1.0f + wait_bias;
            wait_time = fptosi((float)wait_base / rate);
            int extra = fptosi((float)wait_extra / rate);
            wait_time += fptosi((float)extra * mgRnd());
        } else {
            float rate = 1.0f - wait_bias;
            wait_time = fptosi((float)wait_base * rate);
            int extra = fptosi((float)wait_extra / rate);
            wait_time += fptosi((float)extra * mgRnd());
        }
    }
    int rod_power = RodData.status[2] - 10;
    if (rod_power < 0) {
        rod_power = 0;
    }
    fish->fish_no = fish_no;
    fish->size = size;
    fish->weight = weight;
    fish->length_scale = length_scale;
    fish->width_scale = width_scale;
    fish->pull_strength = pull_strength / (1.0f + 2.0f * ((float)rod_power / 90.0f));
    fish->vigour_recovery = 0.01f;
    fish->vigour = 0.0f;
    fish->fishing_point = fishing_point;
    return wait_time;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishing", GetUkiWaitTime__FP9FISH_DATAP6CScenePfii);
#endif
int GetUkiPokeTime(FISH_DATA *fish) {
    switch (FavoredEsa) {
        case 0:
            fish->fish_no = -1;
            return 5;
        case 1:
            return (int)(60.0f * mgRnd()) + 100;
        case 2:
            return (int)(50.0f * mgRnd()) + 50;
        case 3:
            return (int)(30.0f * mgRnd()) + 30;
    }
    return 0;
}
int GetUkiPullTime(FISH_DATA *fish) {
    return 30;
}
int FishLoadBG(FISH_DATA *fish, u_long128 *buffer) {
    char path[0x40];
    if (fish->fish_no < 0) {
        return 0;
    }
    StartReadBG();
    FISH_PARAM *param = GetFishParam(fish->fish_no);
    if (param == NULL) {
        return 0;
    }
    sprintf(path, at_2461, param->file_name);
    return LoadFileBG(path, buffer, 0) != 0;
}
#ifdef NONMATCHING
void LineTensionStep(FISH_DATA *fish, int reel) {
    float tension_rate;
    int left_vibration;
    int right_vibration;
    float pull;

    pull = fish->pull_strength * (1.0f + 0.5f * fish->vigour);
    int action_count = ActionCount;
    tension_rate = -0.004f;
    if (action_count > 5) {
        tension_rate = -0.004f + 0.01f * (float)(action_count - 5) / 15.0f;
    }
    if (action_count > 20) {
        tension_rate = 0.2f;
    }
    left_vibration = 0;
    if (!(tension_rate <= 0.0f)) {
        tension_rate *= pull;
    }
    right_vibration = 0x96;
    if (reel > 0) {
        LineTension *= 0.9f;
    }
    if (reel < 0) {
        pull *= 2.0f;
        fish->vigour -= 0.05f * (3.0f * ((float)RodData.status[1] / 100.0f));
    }
    switch (RodStatus) {
        case 0:
            fish->vigour += fish->vigour_recovery;
            if (tension_rate < 0.0f) {
                right_vibration = 0;
                left_vibration = 0;
            }
            break;
        case 1:
            right_vibration = 0xDC;
            tension_rate += 0.03f * pull;
            fish->vigour -= 0.02f;
            break;
        case 2:
            right_vibration = 0x64;
            tension_rate -= 0.008f;
            break;
    }
    if (WindReel != 0) {
        tension_rate += 0.03f * pull;
    }
    if (!(fish->vigour <= 1.0f)) {
        fish->vigour = 1.0f;
    }
    if (fish->vigour < -1.0f) {
        fish->vigour = -1.0f;
    }
    MinLineTension += 0.0001f;
    if (!(MinLineTension <= 1.0f)) {
        MinLineTension = 1.0f;
    }
    LineTension += tension_rate;
    addLineTension = tension_rate;
    if (LineTension < MinLineTension) {
        LineTension = MinLineTension;
    }
    if (!(LineTension <= 1.0f)) {
        LineTension = 1.0f;
    }
    if (!(tension_rate <= 0.001f)) {
        left_vibration = 1;
    }
    GamePad__2.SetVibration(1, right_vibration, 4);
    GamePad__2.SetVibration(0, left_vibration, 4);
    if (init_2496 == 0) {
        snd_cnt_2495 = 0;
        init_2496 = 1;
    }
    if (!(LineTension <= 0.7f) && snd_cnt_2495 == 0) {
        sndSePlay(FishSnd, 0x10, 0);
        snd_cnt_2495 = 0x14;
    }
    snd_cnt_2495--;
    if (snd_cnt_2495 < 0) {
        snd_cnt_2495 = 0;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/fishing", LineTensionStep__FP9FISH_DATAi);
#endif
int GetAppearFish(int map_no, float *pos, FISH_PLACE *places, int max_places) {
    FISH_PLACE_MAP *map;
    int i;
    int count;
    map = FishPlaceMap;
    for (i = 0; i < max_places; i++) {
        places[i].fish_no = -1;
        places[i].wait_bias = 0;
        places[i].rate = 0;
    }
    for (i = 0; i < FishPlaceMapNum; i++, map++) {
        if (map_no == map->map_no && map->CheckFishPlace(pos) != 0) {
            map->SetFishPlace(places, max_places, map->exclusive);
            if (map->exclusive != 0) {
                break;
            }
        }
    }
    for (count = 0; count < max_places; count++) {
        if (places[count].fish_no < 0) {
            break;
        }
    }
    if (map_no >= 0 && count <= 0) {
        return GetAppearFish(-1, pos, places, max_places);
    }
    return count;
}
int FISH_PLACE_MAP::SetFishPlace(FISH_PLACE *place, int place_num, int replace) {
    int filled = 0;

    if (replace != 0) {
        for (int i = 0; i < place_num; i++) {
            place[i].fish_no = -1;
            place[i].wait_bias = 0.0f;
            place[i].rate = 0.0f;
        }
    }
    if (fish_num >= place_num) {
        fish_num = place_num;
    }
    for (int i = 0; i < fish_num; i++) {
        FISH_PLACE *source = &fish[i];
        if (replace == 0) {
            int j;
            for (j = 0; j < place_num; j++) {
                if (place[j].fish_no < 0 || source->fish_no == place[j].fish_no) {
                    FISH_PLACE *target = &place[j];
                    if (target->fish_no < 0) {
                        filled++;
                    }
                    target->fish_no = source->fish_no;
                    target->rate = place[i].rate > source->rate ? place[i].rate : source->rate;
                    target->wait_bias = place[i].wait_bias > source->wait_bias ? place[i].wait_bias : source->wait_bias;
                    break;
                }
            }
        } else {
            filled++;
            place[i].fish_no = source->fish_no;
            place[i].rate = source->rate;
            place[i].wait_bias = source->wait_bias;
        }
    }
    return filled;
}
int FISH_PLACE_MAP::CheckFishPlace(float *pos) {
    float center[4];
    mgZeroVector(center);
    switch (area_type) {
        case kFishShapeCircle:
            center[0] = area_param[0];
            center[2] = area_param[1];
            float dist = mgDistVectorXZ(center, pos);
            if (dist > area_param[2])
                return 0;
            return 1;
    }
    return 1;
}
int fpFISH_MAP_NUM(SPI_STACK *args, int arg_count) {
    FishPlaceMapNum = spiGetStackInt(args);
    u_int blocks;
    if (((u_int)FishPlaceMapNum * sizeof(FISH_PLACE_MAP)) & 0xF) {
        blocks = (((u_int)FishPlaceMapNum * sizeof(FISH_PLACE_MAP)) >> 4) + 1;
    } else {
        blocks = ((u_int)FishPlaceMapNum * sizeof(FISH_PLACE_MAP)) >> 4;
    }
    void *block = fpStack->Alloc(blocks + 2);
    FishPlaceMap =
        (FISH_PLACE_MAP *)operator new[](FishPlaceMapNum * sizeof(FISH_PLACE_MAP), (u_long128 *)block);
    fpNowFishPlaceMapNum = 0;
    fpNowFishPlaceMap = FishPlaceMap;
    return 1;
}
int fpFISH_MAP(SPI_STACK *args, int arg_count) {
    fpNowFishPlaceMap = NULL;
    if ((int)fpNowFishPlaceMapNum >= FishPlaceMapNum) {
        return 0;
    }
    fpNowFishPlaceMap = &FishPlaceMap[fpNowFishPlaceMapNum];
    memset(fpNowFishPlaceMap, 0, sizeof(FISH_PLACE_MAP));
    fpNowFishPlaceMap->map_no = spiGetStackInt(args++);
    if (arg_count >= 2) {
        fpNowFishPlaceMap->exclusive = spiGetStackInt(args);
    }
    return 1;
}
int fpFISH_PLACE(SPI_STACK *args, int arg_count) {
    int area_type;
    char *name;
    int i;
    if (fpNowFishPlaceMap == 0) {
        return 0;
    }
    area_type = spiGetStackInt(args++);
    if (area_type < 0 || area_type >= kFishShapeCount) {
        area_type = 0;
    }
    fpNowFishPlaceMap->area_type = area_type;
    name = spiGetStackString(args++);

    if (name != 0 && *(signed char *)name != 0) {
        fpNowFishPlaceMap->name = mgCopyString(name, fpStack);
    }
    for (i = 0; i < kFishPlaceValueCount; i++) {
        fpNowFishPlaceMap->area_param[i] = spiGetStackFloat(args++);
    }
    return 1;
}
int fpFISH(SPI_STACK *args, int arg_count) {
    FISH_PLACE *entry;
    int index;
    int *count_ptr;
    if (fpNowFishPlaceMap == 0) {
        return 0;
    }
    count_ptr = &fpNowFishPlaceMap->fish_num;
    index = *count_ptr;
    if (index >= kFishPlaceMaxFish) {
        return 0;
    }
    *count_ptr = index + 1;
    entry = &fpNowFishPlaceMap->fish[index];
    entry->fish_no = -1;
    entry->wait_bias = 0;
    entry->rate = 0;
    entry->fish_no = spiGetStackInt(args++);
    entry->rate = spiGetStackFloat(args++);
    entry->wait_bias = spiGetStackFloat(args);
    return 1;
}
int fpFISH_MAP_END(SPI_STACK *args, int arg_count) {
    if (fpNowFishPlaceMap == 0) {
        return 0;
    }
    fpNowFishPlaceMapNum += 1;
    return 1;
}
void LoadFishPlaceData(char *script, int size, mgCMemory *stack) {
    fpStack = stack;
    FishPlaceMapNum = 0;
    FishPlaceMap = NULL;
    CScriptInterpreter interpreter;
    interpreter.SetTag(tag__8);
    interpreter.SetScript(script, size);
    interpreter.Run();
}

// Static initialiser (.init)
extern "C" void __sinit_fishing_cpp() {
    EsaStack.Init();
    SndStack.Init();
    __ct__14CCameraControlFv(&CameraInfo);
    __ct__14CCameraControlFv(&UkiCameraInfo);
    MotionBuff.Init();
    ReadStack.Init();
    FishingBuff__2.Init();
    FishStack.Init();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", lure_file__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", EsaInfo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", FishParam__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_993__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1430__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1490__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1491__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1536__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1631__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", tag__8__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_832__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_833__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_834__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_835__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_845__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_846__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_847__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_848__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_849__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_850__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_851__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_852__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_853__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_854__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_855__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_856__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_857__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_858__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_859__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_860__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_861__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_862__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_863__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_864__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_865__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_866__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_867__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_868__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_869__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_870__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_871__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_872__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_873__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_874__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_875__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_876__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_877__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_878__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_879__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_880__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_881__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_882__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_917__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_932__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_979__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_980__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1058__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1304__8__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1305__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1306__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1307__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1308__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1309__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1310__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1311__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1312__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1313__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1314__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1315__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1316__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1397__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1399__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1398__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1424__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1442__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1443__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1508__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1509__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1576__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1577__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1683__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1691__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1722__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1723__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1749__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1920__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1921__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1922__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2057__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2058__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2059__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2060__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2099__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2127__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2197__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2198__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2272__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2461__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2670__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2671__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2672__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2673__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_2674__2__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", D_0037B074__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/fishing", at_1444__3__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(EffectMan, 0x4);
INCLUDE_BSS(FishSnd, 0x4);
INCLUDE_BSS(FanSnd, 0x4);
INCLUDE_BSS(UkiRod, 0x4);
INCLUDE_BSS(LureRod, 0x4);
INCLUDE_BSS(Uki, 0x4);
INCLUDE_BSS(Lure, 0x4);
INCLUDE_BSS(Hari, 0x4);
INCLUDE_BSS(FishingTexb, 0x4);
INCLUDE_BSS(FishTexb, 0x4);
INCLUDE_BSS(SystemTexb, 0x4);
INCLUDE_BSS(EsaTexb, 0x4);
static INCLUDE_BSS(MainChara, 0x4);
INCLUDE_BSS(FishChara, 0x4);
INCLUDE_BSS(EsaChara, 0x4);
INCLUDE_BSS(CursorChara, 0x8);
INCLUDE_BSS(RodHand, 0x4);
INCLUDE_BSS(UkiFrame, 0x4);
INCLUDE_BSS(LureFrame, 0x4);
INCLUDE_BSS(HariFrame, 0x4);
INCLUDE_BSS(oldPadRx, 0x4);
INCLUDE_BSS(oldPadRy, 0x4);
INCLUDE_BSS(CastOKFlag, 0x4);
INCLUDE_BSS(RunEventNo, 0x4);
INCLUDE_BSS(MardanEventMap, 0x4);
INCLUDE_BSS(MardanEventPlace, 0x4);
INCLUDE_BSS(CharaMode, 0x4);
INCLUDE_BSS(NextCharaMode, 0x4);
INCLUDE_BSS(fgLoopMode, 0x4);
INCLUDE_BSS(fgLoopStep, 0x4);
INCLUDE_BSS(fgLoopCnt, 0x4);
INCLUDE_BSS(RodNo, 0x4);
INCLUDE_BSS(EsaNo, 0x4);
INCLUDE_BSS(LocalEsaNo, 0x4);
INCLUDE_BSS(FavoredEsa, 0x4);
INCLUDE_BSS(LureNo, 0x4);
INCLUDE_BSS(CastDist, 0x4);
INCLUDE_BSS(CastDistSizeRate, 0x4);
INCLUDE_BSS(UkiMode, 0x4);
INCLUDE_BSS(UkiModeCnt, 0x4);
INCLUDE_BSS(RodActionPoint, 0x4);
INCLUDE_BSS(ReadBuffer, 0x4);
INCLUDE_BSS(LoadFishFlag, 0x4);
INCLUDE_BSS(LoadExMotionFlag, 0x4);
INCLUDE_BSS(LineTension, 0x4);
INCLUDE_BSS(addLineTension, 0x4);
INCLUDE_BSS(MinLineTension, 0x4);
INCLUDE_BSS(LineMaxLen, 0x4);
INCLUDE_BSS(LineMinLen, 0x4);
INCLUDE_BSS(FishMaxLen, 0x4);
INCLUDE_BSS(FishMinLen, 0x4);
INCLUDE_BSS(BattleCount, 0x4);
INCLUDE_BSS(WindReel, 0x4);
INCLUDE_BSS(RodStatus, 0x4);
INCLUDE_BSS(RodStatusCnt, 0x4);
INCLUDE_BSS(ActionCount, 0x4);
INCLUDE_BSS(ActionDecCount, 0x4);
INCLUDE_BSS(RetCode, 0x4);
INCLUDE_BSS(DrawHit, 0x4);
INCLUDE_BSS(DrawCongra, 0x4);
INCLUDE_BSS(BgmReadFlag, 0x4);
INCLUDE_BSS(BattleBgmCnt, 0x4);
INCLUDE_BSS(ex_mtn_buff, 0x4);
INCLUDE_BSS(stack_size, 0x4);
INCLUDE_BSS(ThreadStack__2, 0x4);
INCLUDE_BSS(TheadID__2, 0x4);
INCLUDE_BSS(ThreadRunning, 0x4);
INCLUDE_BSS(step_end_flag, 0x4);
INCLUDE_BSS(CastStep, 0x4);
INCLUDE_BSS(CastCount, 0x4);
INCLUDE_BSS(CastTime, 0x4);
INCLUDE_BSS(CastMotionCnt, 0x4);
INCLUDE_BSS(RodActFlag, 0x4);
INCLUDE_BSS(UkiCameraFlag, 0x4);
INCLUDE_BSS(UkiCamOldRot, 0x4);
INCLUDE_BSS(hamon_count_1798, 0x4);
INCLUDE_BSS(init_1799, 0x4);
INCLUDE_BSS(boze_cnt_1801, 0x4);
INCLUDE_BSS(pull_uki_cnt_1808, 0x4);
INCLUDE_BSS(act_count_1838, 0x4);
INCLUDE_BSS(charge_point_1839, 0x4);
INCLUDE_BSS(act_interval_1840, 0x4);
INCLUDE_BSS(snd_cnt_1960, 0x4);
INCLUDE_BSS(init_1961, 0x4);
INCLUDE_BSS(FalseStep, 0x4);
INCLUDE_BSS(FalseStep2, 0x4);
INCLUDE_BSS(FalseMotionCount, 0x4);
INCLUDE_BSS(GetItemRet, 0x4);
INCLUDE_BSS(FishMesNo, 0x4);
INCLUDE_BSS(FishFontH, 0x4);
INCLUDE_BSS(font_h_2216, 0x4);
INCLUDE_BSS(init_2217, 0x4);
INCLUDE_BSS(snd_cnt_2495, 0x4);
INCLUDE_BSS(init_2496, 0x4);
INCLUDE_BSS(FishPlaceMapNum, 0x4);
INCLUDE_BSS(FishPlaceMap, 0x4);
INCLUDE_BSS(fpStack, 0x4);
INCLUDE_BSS(fpNowFishPlaceMap, 0x4);
INCLUDE_BSS(fpNowFishPlaceMapNum, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(EsaStack, 0x30);
INCLUDE_BSS(SndStack, 0x30);
INCLUDE_BSS(CameraInfo, 0x1F0);
INCLUDE_BSS(UkiCameraInfo, 0x1F0);
INCLUDE_BSS(CastPoint, 0x10);
INCLUDE_BSS(CastPointCur, 0x10);
INCLUDE_BSS(RodData, 0x20);
INCLUDE_BSS(FishData, 0x30);
INCLUDE_BSS(MotionBuff, 0x30);
INCLUDE_BSS(ReadStack, 0x30);
INCLUDE_BSS(FishingBuff__2, 0x30);
INCLUDE_BSS(FishStack, 0x30);
INCLUDE_BSS(BgmStatus, 0x20);
INCLUDE_BSS(at_1681__2, 0x10);
INCLUDE_BSS(at_1689, 0x10);
