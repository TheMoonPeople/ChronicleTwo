#include "common.h"
#include "dng_effect.hpp"
#include "character.hpp"
#include "cameracontrol.hpp"
#include "editeff.hpp"
#include "mainloop.hpp"
#include "scenesnd.hpp"
#include <cstring>
#include "nd_meswin.hpp"
#include <cstdio>
#include "gamepad.hpp"
#include "mg_texture.hpp"
#include "mg_math.hpp"
#include "menudraw.hpp"
#include "editctrl.hpp"
#include "editmenu.hpp"
#include "editmap.hpp"
#include "savedata.hpp"
#include "padcontrol.hpp"
#include "scene.hpp"
#include "effscript.hpp"
#include "editmode.hpp"
#include "mglib.hpp"
#include "dataread.hpp"
#include "mg_dataset.hpp"
#include <cmath>

extern "C" int fptosi(float);
extern "C" int GetBuildPartsNum__9CSaveDataFi(CSaveData *save, int parts_no);
static void InitBalanceDraw(CScene *scene);
static int CheckFocusBalanceParts(CEditMap *map, int index, float *cursor);
static void GetBalanceHeight(CScene *scene, float *balance);
static int GetGeoCheckCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max);
static int GetGeoCheckCamCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max);

extern "C" UNDO_DATA UndoData;
extern "C" CEditParts::WallInfo WallInfo;

extern mgRect<int> data[];
extern "C" char at_1254__2[];
extern "C" char at_1284__5[];

extern CFont Font__2;
extern int PutSideMode;
extern int NowSelectWallParts;
extern int PuuSideRotCameraFlag;
extern int PlacePartsNo;
extern float PartsHeight;
extern int MagnetPartsFlag;
extern int SelectWallGroup;
extern int CtrlLockFlag;
extern int PartsInfoID;
extern int PreMenuCount;
extern int PreMenuMaxCount;
extern int CursorLockCnt;
extern int EditHelpMesNo;
extern int EditHelpMesParam2;
extern int EditHelpMesParam;
extern int PlaceRiverCnt;
extern int RemoveMtnCnt;
extern int SysMesCnt;
extern int SysMesNo;
extern "C" UNDO_DATA UndoData;
extern "C" int EditModeNo;
extern "C" int HighSpeedMoveCnt;
extern "C" int MagnetEnable;
extern "C" float eCameraDist;
extern "C" float eCurPos[4];
extern "C" float ePartsCurNowPos[4];
extern "C" float ePartsCurPos[4];
extern "C" float eCurNowPos[4];
extern "C" int eCurRot;
extern "C" int PlacePartsFlag;
extern "C" int RemainPartsNum;
extern "C" float WallPutPos[4];
extern "C" CEditParts::WallInfo WallInfo;
extern "C" int __as__9mgVu0FBOXFR9mgVu0FBOX(...);
extern "C" int GroundBalance__8CEditMapFi(CEditMap *, int);
extern "C" int UpdateHouse__8CEditMapFv(CEditMap *);
extern "C" float PlaceRiverPos[4];
extern char at_1367[];
extern CCharacter2 *PaintCurChr;
extern mgCFrame *PaintCursor2;
extern "C" float PaintColor[4];
extern int PaintItemNo;
extern char at_1377__3[];
extern CCharacter2 *ShovelCurChr;
extern "C" u8 at_1268__3[16];
extern "C" float RemoveMtnPos[4];
extern "C" u8 RemoveMtnCurPos[16];
extern CCharacter2 *RemoveCurChr;
extern mgCFrame *UnitCursor;
extern mgCFrame *EditCursor[3];
extern "C" u8 now_balance_h[16];
extern "C" u8 at_2213__3[10];
extern "C" int GetPlaceParts__4CMapFPc(CMap *map, char *name);

// Code (.text)
static int CheckControl(void) {
    return CtrlLockFlag;
}
void EditModeControlLock(void) {
    CtrlLockFlag++;
}
void EditModeControlUnLock(void) {
    CtrlLockFlag -= 1;
    if (CtrlLockFlag < 0) {
        CtrlLockFlag = 0;
    }
}
static void SetHelpMes(int message_no, int param, int param2) {
    EditHelpMesNo = message_no;
    EditHelpMesParam = param;
    EditHelpMesParam2 = param2;
}
static CUserDataManager *GetUserData() {
    CSaveData *save;

    save = GetSaveData();
    if (save != NULL) {
        return &save->user_data;
    }
    return NULL;
}
static float ConvColor(float component) {
    return component / 128.0f;
}
static void ConvColorV(float *color) {
    color[0] /= 128.0f;
    color[1] /= 128.0f;
    color[2] /= 128.0f;
}
static int emSearchColorCode(float *color) {
    float penki_color[4];
    int i;

    for (i = 0; i < 8; i++) {
        GetPenkiColor(i, penki_color);
        ConvColorV(penki_color);
        if (EditPartsCmpColor(color, penki_color) != 0) {
            return i;
        }
    }
    return -1;
}
static int emGetPenkiItemNo(int slot) {
    if ((slot < 0) || (slot >= 8)) {
        return -1;
    }
    return GetPenkiItemNo(slot);
}
static int emGetPenkiItemNo(float *color) {
    return emGetPenkiItemNo(emSearchColorCode(color));
}
static void IntiSystemMes(void) {
    SysMesCnt = 0;
    SysMesNo = -1;
}
static void OpenSystemMes(CScene *scene, int message_no, int frames) {
    ClsMes *message;

    message = scene->GetMessage(1);
    if (message != NULL) {
        message->Preset(4);
        message->SetWindowMode(4);
        message->MakeMesWin(message_no);
        message->fukidashi_pos = 8;
        SysMesCnt = frames;
        SysMesNo = message_no;
    }
}
static void SystemMesClose(CScene *scene) {
    ClsMes *message = scene->GetMessage(1);
    if (message != NULL) {
        if (message->select < 0) {
            message->cursor_time = 0;
        }
        message->select = -1;
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->unk_1e40 = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
        message->fukidashi_pos = 0;
    }
}
static void SystemMesStep(CScene *scene) {
    if (SysMesNo >= 0) {
        if (SysMesCnt < 0) {
            SystemMesClose(scene);
            SysMesCnt = 0;
        }
        SysMesCnt = SysMesCnt - 1;
    }
}
static int EditStartPlaceEffect(CEditParts *parts, float *pos) {
    int anime_result;
    CEditPartsInfo *info;
    if (parts == NULL || (info = parts->info) == NULL) {
        return 0;
    }
    anime_result = EditSetPlaceAnime(info->place_anime, (CMapParts *)parts);
    anime_result |= EditPlaceEffect(parts, pos);
    return anime_result;
}
static int EditEndPlaceEffect(void) {
    int anime_end = EditPlaceAnimeEndCheck();
    int effect_end = EditPEffectEndCheck();
    if (anime_end == 1 || effect_end == 1) {
        return 0;
    }
    return 0;
}
void EditPreMenuAnime(int max_count) {
    PreMenuMaxCount = max_count;
    PreMenuCount = 0;
}
#ifdef NONMATCHING
extern char at_1067__3[];
extern char at_1068__3[];
extern char at_1069__5[];
extern char at_1070__3[];
extern char at_1071__3[];
extern char at_1072__3[];
extern char at_1073__3[];
extern char at_1074__3[];
extern char at_1075__2[];
extern char at_1076__2[];
extern mgCFrame *PaintCursor;
extern mgCFrame *RemoveCursor;
extern mgCFrame *ShovelCursor;
extern mgCTexture *eSysTexture;
void LoadEditCursor(mgCMemory *memory, int block) {
    mgCTextureManager *textures = &mgTexManager;
    if (LoadFile2(at_1067__3, read_buffer, NULL, 0) != 0) {
        u_int *pack = (u_int *)read_buffer;
        u_int size;
        u_int *image = GetPackFile(pack, at_1068__3, (int *)&size);
        if (image != NULL) {
            u_int blocks;
            if (size & 0xF) {
                blocks = (size >> 4) + 1;
            } else {
                blocks = size >> 4;
            }
            void *copy = memory->Alloc(blocks);
            memcpy(copy, image, size);
            textures->EnterIMGFile((u_char *)copy, block, NULL, NULL);
        }
        eSysTexture = textures->GetTexture(at_1069__5, block);
        mgCFrameAttr attr;
        attr.no_light = 1;
        attr.color[0] = 128.0f;
        attr.color[1] = 128.0f;
        attr.color[2] = 128.0f;
        attr.color[3] = 128.0f;
        u_int *cursor_model = GetPackFile(pack, at_1070__3, NULL);
        if (cursor_model != NULL) {
            EditCursor[0] = mgLoadMDSFile((MDS_HEADER *)cursor_model, memory, NULL, NULL);
            EditCursor[0]->SetAttrParam(attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR | MG_FRAME_ATTR_BILLBOARD);
        }
        PaintCursor = NULL;
        PaintCursor2 = NULL;
        PaintCurChr = new ((u_long128 *)memory->Alloc(0x68)) CCharacter2;
        u_int *paint_model = GetPackFile(pack, at_1071__3, NULL);
        if (paint_model != NULL) {
            PaintCurChr->LoadPackNoLine(paint_model, at_1072__3, memory, memory, memory, block, NULL);
            PaintCursor = PaintCurChr->GetFrame();
            if (PaintCursor != NULL) {
                PaintCursor->SetAttrParam(attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR | MG_FRAME_ATTR_BILLBOARD);
                PaintCursor2 = PaintCursor->SearchFrame(at_1073__3);
            }
            PaintCurChr->SetMotion(0, 0);
        }
        RemoveCursor = NULL;
        ShovelCursor = NULL;
        ShovelCurChr = NULL;
        RemoveCurChr = NULL;
        RemoveCurChr = new ((u_long128 *)memory->Alloc(0x68)) CCharacter2;
        u_int *remove_model = GetPackFile(pack, at_1074__3, NULL);
        if (remove_model != NULL) {
            RemoveCurChr->LoadPackNoLine(remove_model, at_1072__3, memory, memory, memory, block, NULL);
            if (RemoveCurChr != NULL) {
                RemoveCursor = RemoveCurChr->GetFrame();
                if (RemoveCursor != NULL) {
                    RemoveCursor->SetAttrParam(attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR | MG_FRAME_ATTR_BILLBOARD);
                }
            }
        }
        ShovelCurChr = new ((u_long128 *)memory->Alloc(0x68)) CCharacter2;
        u_int *shovel_model = GetPackFile(pack, at_1075__2, NULL);
        if (shovel_model != NULL) {
            ShovelCurChr->LoadPackNoLine(shovel_model, at_1072__3, memory, memory, memory, block, NULL);
            if (ShovelCurChr != NULL) {
                ShovelCursor = ShovelCurChr->GetFrame();
                if (ShovelCursor != NULL) {
                    ShovelCursor->SetAttrParam(attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR | MG_FRAME_ATTR_BILLBOARD);
                }
            }
        }
        u_int *unit_model = GetPackFile(pack, at_1076__2, NULL);
        if (unit_model != NULL) {
            UnitCursor = mgLoadMDSFile((MDS_HEADER *)unit_model, memory, NULL, NULL);
            mgCFrameAttr unit_attr;
            unit_attr.z_write = -1;
            unit_attr.clip_enable = 1;
            unit_attr.color[0] = 128.0f;
            unit_attr.color[3] = 32.0f;
            unit_attr.no_light = 1;
            unit_attr.color[1] = 64.0f;
            unit_attr.color[2] = 64.0f;
            UnitCursor->SetAttrParam(unit_attr, 1, 0);
        }
        Font__2.Init();
        Font__2.Preset(4);
        Font__2.SetFuchi(3);
        Font__2.SetClearance(0xF, 0x18);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", LoadEditCursor__FP9mgCMemoryi);
#endif
int GetSelPartsInfoID(void) {
    return PartsInfoID;
}
static void ClearEditStepCnt(void) {
    PlaceRiverCnt = 0;
    CursorLockCnt = 0;
    RemoveMtnCnt = 0;
}
void ClearUndoFlag(void) {
    UndoData.info_id = -1;
    UndoData.parts_no = -1;
}
void ClearEditFlag(void) {
    PlacePartsNo = -1;
    PartsInfoID = -1;
    NowSelectWallParts = -1;
    SelectWallGroup = -1;
    RemainPartsNum = 0;
    PutSideMode = 0;
    PuuSideRotCameraFlag = 0;
    PlacePartsFlag = 0;
    PartsHeight = 0.0f;
    MagnetPartsFlag = 0;
    PreMenuCount = 0;
    PreMenuMaxCount = 0;
    ClearUndoFlag();
    EditHelpMesNo = -1;
    ClearEditStepCnt();
}
void InitEditFlag(void) {
    eCameraDist = 600.0f;
    EditModeNo = 0;
    ClearEditFlag();
    EditInitPlaceAnime();
    EditInitPlaceEffect();
    CtrlLockFlag = 0;
    MagnetEnable = 1;
    HighSpeedMoveCnt = 0;
}
int StartEditMode(CScene *scene) {
    CCharacter2 *player = scene->GetCharacter(scene->player_chara);
    mgCCameraFollow *angle_camera;
    CCameraControl *follow_camera;
    float angle;
    if (player != NULL) {
        ((mgCObject *)player)->GetPosition(eCurPos);
        *(u_long128 *)ePartsCurNowPos = *(u_long128 *)eCurPos;
        *(u_long128 *)ePartsCurPos = *(u_long128 *)eCurPos;
        *(u_long128 *)eCurNowPos = *(u_long128 *)eCurPos;
    }
    EditModeNo = 2;
    ClearEditFlag();
    IntiSystemMes();
    angle_camera = (mgCCameraFollow *)scene->GetCamera(scene->before_camera);
    angle = 0.0f;
    if (angle_camera != NULL) {
        angle = angle_camera->GetAngle();
    }
    follow_camera = (CCameraControl *)scene->GetCamera(scene->active_camera);
    if (follow_camera != NULL) {
        ((mgCCameraFollow *)follow_camera)->FollowOn();
        ((mgCCameraFollow *)follow_camera)->SetFollowOffset(0.0f, 0.0f, 0.0f);
        follow_camera->SetFollow(eCurPos[0], eCurPos[1], eCurPos[2]);
        ((mgCCameraFollow *)follow_camera)->SetHeight(100.0f);
        ((mgCCameraFollow *)follow_camera)->SetDistance(300.0f);
        ((mgCCameraFollow *)follow_camera)->SetAngle(angle);
        follow_camera->Step(-1);
    }
    EditInitPlaceEffect();
    InitBalanceDraw(scene);
    return 1;
}
void EndEditMode(CScene *scene, float *cursor_pos) {
    float pos[4];
    CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
    CCharacter2 *player = scene->GetCharacter(scene->player_chara);
    if (player != NULL) {
        *(u_long128 *)pos = *(u_long128 *)cursor_pos;
        pos[1] += 0.01f;
        ((mgCObject *)player)->SetPosition(pos);
    }
    SystemMesClose(scene);
    if (map != NULL) {
        map->focus_parts = -1;
    }
    EditInitPlaceEffect();
    EditInitPlaceAnime();
}
#ifdef NONMATCHING
struct PaintParams {
    int red;
    int green;
    int blue;
    int item;
};
struct PaintShade {
    int red;
    int green;
    int blue;
};
int StartEditModeFromMenu(CScene *scene, int mode, int *params) {
    scene->GetMap(scene->active_map);
    EditModeNo = mode;
    PartsInfoID = -1;
    RemainPartsNum = 0;
    ClearEditStepCnt();
    if (EditModeNo == EDIT_MODE_PLACE || EditModeNo == EDIT_MODE_REMOVE || EditModeNo == EDIT_MODE_PAINT ||
        EditModeNo == EDIT_MODE_REPAINT) {
        ClearEditFlag();
        PaintParams color = {0, 0, 0, 0};
        PaintShade shade = {0, 0, 0};
        color.red = params[0];
        color.green = params[1];
        color.blue = params[2];
        color.item = params[3];
        shade.red = params[0];
        shade.green = params[1];
        shade.blue = params[2];
        if (EditModeNo == EDIT_MODE_REPAINT) {
            color.red = -1;
            color.green = -1;
            color.blue = -1;
            color.item = -1;
            shade.red = 0xFF;
            shade.green = 0xFF;
            shade.blue = 0xFF;
        }
        if (EditModeNo == EDIT_MODE_PAINT || EditModeNo == EDIT_MODE_REPAINT) {
            if (PaintCursor2 != NULL && PaintCursor2->attr != NULL) {
                PaintCursor2->attr->color[0] = shade.red;
                PaintCursor2->attr->color[1] = shade.green;
                PaintCursor2->attr->color[2] = shade.blue;
                PaintColor[0] = ConvColor(color.red);
                PaintColor[1] = ConvColor(color.green);
                PaintColor[2] = ConvColor(color.blue);
                PaintItemNo = color.item;
            }
        } else {
            PartsInfoID = params[0];
            RemainPartsNum = params[1];
        }
        PlacePartsFlag = 0;
        MagnetPartsFlag = 0;
        mgCCameraFollow *camera = (mgCCameraFollow *)scene->GetCamera(scene->active_camera);
        if (camera != NULL) {
            camera->SetFollowOffset(0.0f, 0.0f, 0.0f);
            ((CCameraControl *)camera)->SetFollow(eCurPos[0], eCurPos[1], eCurPos[2]);
            camera->SetHeight(eCameraDist);
            camera->SetDistance(eCameraDist);
        }
    }
    EditInitPlaceEffect();
    EditInitPlaceAnime();
    InitBalanceDraw(scene);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", StartEditModeFromMenu__FP6CSceneiPi);
#endif
static void *GetUndoData(void) {
    return &UndoData;
}
static int UndoEnable(void) {
    return *(int *)GetUndoData() >= 0;
}
static void UndoPlaceParts(CScene *scene) {
    UNDO_DATA *undo;
    CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
    CEditPartsInfo *info;
    int remaining;
    int built;
    if (map != NULL) {
        map->focus_parts = -1;
    }
    PlacePartsFlag = 0;

    if (EditModeNo == 2 || EditModeNo == 2) {
        undo = (UNDO_DATA *)GetUndoData();
        if (undo->info_id >= 0) {
            RemoveEditParts(scene, undo->parts_no, (float *)&undo->pos);
            PartsInfoID = undo->info_id;
            info = map->GetePartsInfoAtID(PartsInfoID);
            if (info != NULL) {
                remaining = info->max_num;
                remaining -= map->GetePlacePartsAtInfoID(PartsInfoID, NULL, 0);
                built = GetBuildPartsNum__9CSaveDataFi(GetSaveData(), PartsInfoID);
                if (built < remaining) {
                    remaining = built;
                }
                RemainPartsNum = remaining;
                EditInitPlaceAnime();
                EditInitPlaceEffect();
                *(u_long128 *)eCurPos = *(u_long128 *)&undo->pos;
                eCurRot = map->ConvEditAngle(undo->rot[1]);
            }
            undo->info_id = -1;
            undo->parts_no = -1;
        }
    }
}
static void StackUndoData(UNDO_DATA *data) {
    UndoData.info_id = data->info_id;
    UndoData.parts_no = data->parts_no;
    *(mgVec4 *)UndoData.pos = *(mgVec4 *)data->pos;
    *(mgVec4 *)UndoData.rot = *(mgVec4 *)data->rot;
}
extern "C" void StartEditPutWall__FPQ210CEditParts8WallInfo(CEditParts::WallInfo *wall) {
    mgZeroVector(WallPutPos);
    *(mgVec4 *)WallInfo.plane = *(mgVec4 *)wall->plane;
    *(mgVec4 *)WallInfo.center = *(mgVec4 *)wall->center;
    WallInfo.box = wall->box;
}
int PlaceEditParts(CEditMap *map, float *pos, float *rot, EP_PLACE_INFO *place_info) {
    UNDO_DATA undo;
    CEditPartsInfo *river_info = map->GetePartsInfoAtID(PartsInfoID);
    CEditParts *placed;
    int success;
    int build_no;
    if (river_info == NULL) {
        return 0;
    }
    undo.info_id = -1;
    success = 0;
    undo.parts_no = -1;
    placed = NULL;
    if (river_info->attr & 0x80) {
        if (map->PlaceRiverParts(pos) != 0) {
            success = 1;
            undo.parts_no = -1;
        }
    } else {
        build_no = map->BuildEditParts(PartsInfoID);
        placed = (CEditParts *)map->PlaceEditParts(build_no, place_info, pos, rot, NULL);
        if (placed != NULL) {
            undo.parts_no = build_no;
            success = 1;
        }
    }
    if (success != 0) {
        if (!(river_info->attr & 0x80)) {
            sndSePlay(GetSystemSndID(), 0x14, 0);
        }
        EditStartPlaceEffect(placed, pos);
        GroundBalance__8CEditMapFi(map, 1);
        UpdateHouse__8CEditMapFv(map);
        undo.info_id = PartsInfoID;
        *(u_long128 *)&undo.pos = *(u_long128 *)pos;
        *(u_long128 *)&undo.rot = *(u_long128 *)rot;
        StackUndoData(&undo);
        RemainPartsNum -= 1;
        GetSaveData()->AddBuildPartsNum(PartsInfoID, -1);
        if (RemainPartsNum <= 0) {
            RemainPartsNum = 0;
            PartsInfoID = -1;
        }
    }
    PlacePartsFlag = 0;
    return 1;
}
void PlaceRiverStart(CEditMap *map, float *pos) {
    PlaceRiverCnt = 0x32;
    *(u_long128 *)PlaceRiverPos = *(u_long128 *)pos;
    CursorLockCnt = 5;
    if (ShovelCurChr != NULL) {
        ShovelCurChr->SetMotion(at_1254__2, 6);
    }
}
int PlaceRiverStep(CEditMap *map) {
    float rotation[4];
    float color[4];

    if (PlaceRiverCnt <= 0) {
        return 0;
    }
    PlaceRiverCnt -= 1;
    if (PlaceRiverCnt >= 0x1E) {
        CursorLockCnt = 5;
    }
    if (PlaceRiverCnt == 0x28) {
        sndSePlay(GetSystemSndID(), 0x22, 0);
    }
    if (PlaceRiverCnt == 0x1E) {
        mgZeroVector(rotation);
        if (PlaceEditParts(map, PlaceRiverPos, rotation, NULL) != 0) {
            *(u_long128 *)color = *(u_long128 *)at_1268__3;
            EditPaintEffect(NULL, PlaceRiverPos, color, 1);
        }
    }
    if (PlaceRiverCnt <= 0) {
        PlaceRiverCnt = 0;
    }
    return 0;
}
int NowPlaceRiver(void) {
    return PlaceRiverCnt > 0;
}
void RemoveMtnStart(CEditMap *map, float *pos, float *cursor_pos) {
    RemoveMtnCnt = 0x12;
    *(u_long128 *)RemoveMtnPos = *(u_long128 *)pos;
    *(u_long128 *)RemoveMtnCurPos = *(u_long128 *)cursor_pos;
    CursorLockCnt = 5;
    if (RemoveCurChr != NULL) {
        RemoveCurChr->ResetMotion();
        RemoveCurChr->SetMotion(at_1284__5, 6);
    }
}
int RemoveMtnStep(CScene *scene) {
    CEditMap *edit_map;
    int parts_index;

    if (RemoveMtnCnt <= 0) {
        return 0;
    }
    edit_map = (CEditMap *)scene->GetMap(scene->active_map);
    RemoveMtnCnt -= 1;
    if (RemoveMtnCnt >= 3) {
        CursorLockCnt = 3;
    }

    *(u_long128 *)eCurPos = *(u_long128 *)RemoveMtnCurPos;
    *(u_long128 *)eCurPos = *(u_long128 *)RemoveMtnCurPos;
    if (RemoveMtnCnt == 3) {
        parts_index = edit_map->GetePlaceParts(RemoveMtnPos);
        EditSetPlaceAnime(3, (CMapParts *)edit_map->GetePlaceParts(parts_index));
        if (RemoveEditParts(scene, parts_index, RemoveMtnPos) != 0) {
            sndSePlay(GetSystemSndID(), 0x17, 0);
        } else {
            EditInitPlaceAnime();
        }
    }
    if (RemoveMtnCnt <= 0) {
        RemoveMtnCnt = 0;
    }
    return 0;
}
int RemoveEditParts(CScene *scene, int parts_index, float *pos) {
    CEditMap::RemoveInfo info;
    int paint_num[8];
    float color[8][4];
    CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
    int i;
    int j;
    int k;
    int l;
    int count;
    memset(&info, 0, 0x494);
    for (i = 0; i < 8; i++) {
        GetPenkiColor(i, color[i]);
        ConvColorV(color[i]);
        paint_num[i] = 0;
    }
    info.color_num = 8;
    info.color = color;
    info.paint_num = paint_num;
    if (map->RemoveEditParts(parts_index, pos, &info) != 0) {
        GroundBalance__8CEditMapFi(map, 1);
        for (j = 0; j < 0x100; j++) {
            CEditPartsInfo *river_info = map->GetePartsInfoAtID(j);
            if (river_info != NULL && !(river_info->attr & 0x8000)) {
                count = info.parts_num[j];
                if (count > 0) {
                    GetSaveData()->AddBuildPartsNum(j, count);
                }
            }
        }
        for (k = 0; k < info.house_num; k++) {
            GetSaveData()->user_data.LeaveHouse(info.house_npc[k]);
            scene->ResetActive(1, scene->SearchCharaID(info.house_npc[k]));
        }
        for (l = 0; l < 8; l++) {
            emGetPenkiItemNo(l);
        }
        return 1;
    }
    return 0;
}
int DeleteKanketuParts(CScene *scene, CEditMap *map, float *position, int parts_no) {
    float removed_position[4];
    if (map->GetePlaceParts(PartsInfoID) == NULL) {
        return 0;
    }
    map->GetePlaceParts(parts_no);
    *(u_long128 *)removed_position = *(u_long128 *)position;
    int removed = map->RemoveEditParts(parts_no, eCurPos, NULL);
    if (removed != 0) {
        sndSePlay(GetSystemSndID(), 20, 0);
        CEffectScriptMan *effects = scene->GetEffect(0);
        if (effects != NULL) {
            float effect_vector[4] = {8.0f, 8.0f, 8.0f, 0.0f};
            float effect_position[4];
            *(u_long128 *)effect_position = *(u_long128 *)removed_position;
            effects->CreateEffSpt(at_1367, -1, -1);
            effects->SetScriptVect1(effect_position, -1, -1);
            effects->SetScriptVect2(effect_vector, -1, -1);
            *(u_long128 *)effect_position = *(u_long128 *)removed_position;
            effect_position[0] += 50.0f;
            effects->CreateEffSpt(at_1367, -1, -1);
            effects->SetScriptVect1(effect_position, -1, -1);
            effects->SetScriptVect2(effect_vector, -1, -1);
            *(u_long128 *)effect_position = *(u_long128 *)removed_position;
            effect_position[0] -= 24.0f;
            effect_position[2] -= 30.0f;
            effects->CreateEffSpt(at_1367, -1, -1);
            effects->SetScriptVect1(effect_position, -1, -1);
            effects->SetScriptVect2(effect_vector, -1, -1);
            *(u_long128 *)effect_position = *(u_long128 *)removed_position;
            effect_position[0] -= 36.0f;
            effect_position[2] += 40.0f;
            effects->CreateEffSpt(at_1367, -1, -1);
            effects->SetScriptVect1(effect_position, -1, -1);
            effects->SetScriptVect2(effect_vector, -1, -1);
        }
        RemainPartsNum--;
        GetSaveData()->AddBuildPartsNum(PartsInfoID, -1);
        if (RemainPartsNum <= 0) {
            RemainPartsNum = 0;
            PartsInfoID = -1;
        }
    }
    PlacePartsFlag = 0;
    return removed;
}
int PaintEditParts(CEditMap *map, int parts_no, int color_no, float *color) {
    float position[4];
    float effect_color[4];
    CEditParts *part = map->GetePlaceParts(parts_no);
    if (PaintCurChr != NULL) {
        sceVu0ScaleVector(effect_color, color, 128.0f);
        PaintCurChr->GetPosition(position);
        PaintCurChr->SetMotion(at_1377__3, 6);
        EditPaintEffect(part, position, effect_color, 0);
    }
    sndSePlay(GetSystemSndID(), 22, 0);
    color[3] = 128.0f;
    if (color_no == 99) {
        map->PaintFence(parts_no, color, 999);
    } else {
        part->SetColor(color_no, color);
        part->UpdateColor();
    }
    return 1;
}
static int CheckPlaceAlt(int map_no, CEditMap *map, float *position, int parts_no, float *altitude) {
    float height = position[1];
    float ground_position[4];
    CMapParts *ground;
    int index;
    if (map_no == 1) {
        ground = NULL;
        for (index = 0; index < EDIT_MAP_BALANCE_MAX; index++) {
            if (CheckFocusBalanceParts(map, index, position)) {
                ground = map->balance_parts[index];
                break;
            }
        }
        if (ground != NULL) {
            ground->GetPosition(ground_position);
            height -= ground_position[1];
        }
    }
    if (parts_no == 75 || parts_no == 79) {
        if (!(height <= 30.0f)) {
            return 0;
        }
    }
    if (altitude != NULL) {
        *altitude = height;
    }
    if (!(height <= 200.0f)) {
        return 0;
    }
    return 1;
}
static float GetGeoMapLimitHeight(int map_kind) {
    if (map_kind == 0)
        return 700.0f;
    if (map_kind == 1)
        return 900.0f;
    if (map_kind == 3)
        return 700.0f;
    if (map_kind == 4)
        return 700.0f;
    return -1.0f;
}
#ifdef NONMATCHING
extern "C" float ePartsCurRot[4];
extern "C" float ePartsCurNowRot[4];
extern "C" float eDirCurRot[4];
extern float eDirCurLen;
extern char at_1835__2[];
extern char at_1836__2[];
void EditMode(CScene *scene) {
    int moving;
    int river;
    int any_height;
    int map_count;
    int map_no;
    char *edit_name;
    int wall_parts;
    CMap *active_map = scene->GetMap(scene->active_map);
    if (active_map != NULL && strcmp(active_map->Iam(), at_1835__2) == 0) {
        CEditMap *map = (CEditMap *)active_map;
        if (map != NULL) {
            CPadControl *pad = &PadCtrl;
            if (CursorLockCnt > 0) {
                pad = NULL;
            }
            CursorLockCnt--;
            if (CursorLockCnt < 0) {
                CursorLockCnt = 0;
            }
            SystemMesStep(scene);
            map_no = scene->now_map_no;
            map->area_no = map_no;
            mgCCameraFollow *camera = (mgCCameraFollow *)scene->GetCamera(scene->active_camera);
            if (camera != NULL) {
                float old_pos[4];
                *(u_long128 *)old_pos = *(u_long128 *)eCurPos;
                float angle = camera->GetAngle();
                float stick_x = 0.0f;
                if (pad != NULL) {
                    stick_x = pad->Analog(0);
                }
                float stick_y = 0.0f;
                if (pad != NULL) {
                    stick_y = pad->Analog(1);
                }
                float move_x = stick_x * cosf(angle) + stick_y * sinf(angle);
                float move_z = -stick_x * sinf(angle) + stick_y * cosf(angle);
                move_x *= 10.0f;
                move_z *= 10.0f;
                if (DebugFlag != 0) {
                    if (GamePad__2.On(0x200) || (GamePad__2.On(0x80) && EditModeNo != EDIT_MODE_PLACE)) {
                        HighSpeedMoveCnt = 0;
                        move_x *= 3.0f;
                        move_z *= 3.0f;
                    }
                }
                float stick[4] = {0.0f, 0.0f, 0.0f, 0.0f};
                stick[0] = stick_x;
                stick[1] = stick_y;
                if (!(mgDistVector(stick) <= 0.9f)) {
                    HighSpeedMoveCnt++;
                } else {
                    HighSpeedMoveCnt--;
                }
                if (HighSpeedMoveCnt > 30) {
                    move_x *= 2.5f;
                    move_z *= 2.5f;
                }
                if (HighSpeedMoveCnt > 30) {
                    HighSpeedMoveCnt = 30;
                }
                if (HighSpeedMoveCnt < 0) {
                    HighSpeedMoveCnt = 0;
                }
                int key_up = 0;
                int key_down = 0;
                int key_left = 0;
                int key_right = 0;
                if (pad != NULL) {
                    key_up = pad->Btn(9);
                    key_down = pad->Btn(10);
                    key_left = pad->Btn(7);
                    key_right = pad->Btn(8);
                }
                if (key_up || key_down || key_left || key_right) {
                    map->GetEditPos(eCurPos, eCurPos);
                    float axis_cos;
                    float axis_sin;
                    float key_z;
                    float key_x;
                    key_z = 0.0f;
                    key_x = key_z;
                    if (key_left) {
                        key_z = -1.0f;
                    }
                    if (key_up) {
                        key_x = 1.0f;
                    }
                    if (key_right) {
                        key_z = 1.0f;
                    }
                    if (key_down) {
                        key_x = -1.0f;
                    }
                    axis_cos = 1.0f;
                    axis_sin = 0.0f;
                    if (mgAngleCmp(angle, 1.5707964f, 0.7853982f) == 0) {
                        axis_sin = 1.0f;
                        axis_cos = 0.0f;
                    }
                    if (mgAngleCmp(angle, 3.1415927f, 0.7853982f) == 0) {
                        axis_sin = 0.0f;
                        axis_cos = -1.0f;
                    }
                    if (mgAngleCmp(angle, -1.5707964f, 0.7853982f) == 0) {
                        axis_sin = -1.0f;
                        axis_cos = 0.0f;
                    }
                    move_x = key_x * axis_cos + key_z * axis_sin;
                    move_z = -key_x * axis_sin + key_z * axis_cos;
                }
                if (pad != NULL && pad->Btn(1)) {
                    UndoPlaceParts(scene);
                }
                float target[4];
                *(u_long128 *)target = *(u_long128 *)ePartsCurNowPos;
                moving = 0;
                if ((move_x != 0.0f) | (move_z != 0.0f)) {
                    moving = 1;
                }
                CEditPartsInfo *info = map->GetePartsInfoAtID(PartsInfoID);
                if (info != NULL) {
                    int max_polyn = GetMaxPolyn(map_no);
                    int max_draw_mem = GetMaxDrawMem(map_no);
                    int draw_mem;
                    int polyn;
                    if (max_polyn < map->GetTotalPolyn(&polyn, &draw_mem) + info->polyn[0] ||
                        max_draw_mem < draw_mem + info->polyn[2]) {
                        RemainPartsNum = 0;
                        PartsInfoID = -1;
                        info = NULL;
                        PlacePartsFlag = 0;
                    }
                }
                edit_name = NULL;
                int turn_step = 1;
                u32 attr = 0;
                if (info != NULL) {
                    attr = info->attr;
                }
                if ((info != NULL && (attr & 0x8)) || (MagnetPartsFlag != 0 && !(attr & 0x100))) {
                    turn_step = 6;
                }
                river = (attr & EDIT_PARTS_ATR_RIVER) != 0;
                any_height = (attr & 0x10000) != 0;
                if (pad != NULL && pad->Btn(100)) {
                    eCurRot -= turn_step;
                }
                if (pad != NULL && pad->Btn(101)) {
                    eCurRot += turn_step;
                }
                eCurRot = map->AngleLimit(eCurRot);
                if (info != NULL && (info->attr & 0x8)) {
                    eCurRot = map->GetEditAngle90(eCurRot);
                }
                wall_parts = attr & 0x200;
                if (wall_parts == 0 || PutSideMode == EDIT_PUT_SIDE_SELECT) {
                    eCurPos[0] += move_x;
                    eCurPos[2] += move_z;
                }
                if (wall_parts != 0 && pad != NULL) {
                    if (PutSideMode == EDIT_PUT_SIDE_OFF) {
                        PutSideMode = EDIT_PUT_SIDE_SELECT;
                    }
                    if (PutSideMode == EDIT_PUT_SIDE_MOVE) {
                        WallPutPos[0] += 2.0f * pad->Analog(0);
                        WallPutPos[1] -= 2.0f * pad->Analog(1);
                        if (WallPutPos[0] < WallInfo.box.min[0]) {
                            WallPutPos[0] = WallInfo.box.min[0];
                        }
                        if (WallPutPos[1] < WallInfo.box.min[1]) {
                            WallPutPos[1] = WallInfo.box.min[1];
                        }
                        if (!(WallPutPos[0] <= WallInfo.box.max[0])) {
                            WallPutPos[0] = WallInfo.box.max[0];
                        }
                        if (!(WallPutPos[1] <= WallInfo.box.max[1])) {
                            WallPutPos[1] = WallInfo.box.max[1];
                        }
                    }
                }
                CMap *maps[8];
                map_count = scene->GetActiveMap(maps, 8);
                eCurPos[1] = 0.0f;
                mgVu0FBOX box;
                float new_pos[4];
                float ground[4];
                float start_pos[4];
                float move[4];
                CCPoly polys[0x800];
                MoveCheckInfo move_info;
                *(u_long128 *)box.max = *(u_long128 *)eCurPos;
                *(u_long128 *)box.min = *(u_long128 *)eCurPos;
                *(u_long128 *)new_pos = *(u_long128 *)eCurPos;
                *(u_long128 *)start_pos = *(u_long128 *)old_pos;
                new_pos[1] = 20.0f;
                start_pos[1] = 20.0f;
                sceVu0SubVector(move, new_pos, start_pos);
                int poly_count = 0;
                box.max[0] += 100.0f;
                box.max[1] = 100.0f;
                box.max[2] += 100.0f;
                box.min[0] -= 100.0f;
                box.min[1] = -100.0f;
                box.min[2] -= 100.0f;
                int poly_rest = 0x800;
                if (maps[0] != NULL) {
                    poly_count = GetGeoCheckCol(maps[0], box, polys, poly_rest);
                }
                memset(&move_info, 0, sizeof(move_info));
                move_info.radius = 50.0f;
                MoveCheck(start_pos, move, new_pos, &move_info, polys, poly_count, 0);
                eCurPos[0] = new_pos[0];
                eCurPos[2] = new_pos[2];
                mgSetProjection(400.0f);
                if (info != NULL) {
                    edit_name = info->edit_name;
                    if (edit_name == NULL || (info->attr & 0x2)) {
                        edit_name = NULL;
                        PartsInfoID = -1;
                    } else {
                        target[1] += 0.5f * info->GetPartsHeight();
                        info->GetPartsMaxWidth();
                    }
                }
                if (pad != NULL) {
                    eCameraDist += 15.0f * pad->Analog(3);
                    if (eCameraDist < 400.0f) {
                        eCameraDist = 400.0f;
                    }
                    if (!(eCameraDist <= 800.0f)) {
                        eCameraDist = 800.0f;
                    }
                    camera->SetFollowOffset(0.0f, 0.0f, 0.0f);
                    camera->SetFollow(target[0], target[1], target[2]);
                    if (pad->Btn(2)) {
                        camera->AddAngle(-0.1f);
                    }
                    if (pad->Btn(3)) {
                        camera->AddAngle(0.1f);
                    }
                    camera->AddAngle(0.1f * -pad->Analog(2));
                    float height = eCameraDist;
                    if (height < 500.0f) {
                        height = 500.0f;
                    }
                    camera->SetHeight(height);
                    camera->SetDistance(eCameraDist);
                    camera->SetSpeed(6.0f, 6.0f);
                }
                float camera_pos[4];
                float camera_ref[4];
                float camera_hit[4];
                float camera_dir[4];
                camera->GetFollowNextPos(camera_pos);
                camera_pos[1] = 0.0f;
                camera->GetNextRef(camera_ref);
                camera_ref[1] = 0.0f;
                sceVu0SubVector(camera_dir, camera_pos, camera_ref);
                camera_dir[1] = 0.0f;
                sceVu0Normalize(camera_dir, camera_dir);
                sceVu0ScaleVector(camera_dir, camera_dir, 20.0f);
                mgAddVector(camera_pos, camera_dir);
                mgVectorMaxMin(box.max, box.min, camera_pos, camera_ref);
                box.max[0] += 10.0f;
                box.max[1] = 100.0f;
                box.max[2] += 10.0f;
                box.min[0] -= 10.0f;
                box.min[1] = -100.0f;
                box.min[2] -= 10.0f;
                if (CheckHit(polys, GetGeoCheckCamCol(map, box, polys, 0x800), camera_ref, camera_pos, camera_hit, 1, 0) >= 0) {
                    float dist = mgDistVectorXZ(camera_ref, camera_hit);
                    camera->SetDistance(dist);
                    if (dist < 500.0f) {
                        dist = 500.0f;
                    }
                    camera->SetHeight(dist);
                }
                if (wall_parts != 0 && PutSideMode == EDIT_PUT_SIDE_MOVE) {
                    camera->SetDistance(400.0f);
                    camera->SetHeight(400.0f);
                }
                float limit_height = GetGeoMapLimitHeight(map_no);
                if (!(limit_height <= 0.0f)) {
                    float follow[4];
                    camera->GetFollowNext(follow);
                    if (!(follow[1] + camera->GetHeight() <= limit_height)) {
                        camera->SetHeight(limit_height - follow[1]);
                    }
                }
                *(u_long128 *)ePartsCurPos = *(u_long128 *)eCurPos;
                ePartsCurRot[1] = map->GetEditAngle(eCurRot);
                int ground_count = 0;
                CCPoly *next_poly = polys;
                *(u_long128 *)box.max = *(u_long128 *)eCurPos;
                *(u_long128 *)box.min = *(u_long128 *)eCurPos;
                *(u_long128 *)new_pos = *(u_long128 *)eCurPos;
                new_pos[1] = 1000.0f;
                box.max[0] += 10.0f;
                box.max[1] = 10000.0f;
                box.max[2] += 10.0f;
                box.min[0] -= 10.0f;
                box.min[1] = -10000.0f;
                box.min[2] -= 10.0f;
                for (int i = 0; i < map_count; i++) {
                    int added = maps[i]->GetColPoly(next_poly, box, poly_rest);
                    ground_count += added;
                    poly_rest -= added;
                    next_poly += added;
                    if (poly_rest < 0) {
                        break;
                    }
                }
                if (CheckHitVertical(polys, ground_count, new_pos, -2000.0f, ground, 1) >= 0) {
                    *(u_long128 *)eCurPos = *(u_long128 *)ground;
                    ePartsCurPos[1] = ground[1];
                }
                EditEndPlaceEffect();
                PlaceRiverStep(map);
                RemoveMtnStep(scene);
                if (CheckControl() == 0 && pad != NULL) {
                    map->focus_parts = -1;
                    if (wall_parts == 0) {
                        if (EditModeNo == EDIT_MODE_PLACE) {
                            if (edit_name == NULL && UndoEnable()) {
                                SetHelpMes(EDIT_HELP_UNDO, 0, 0);
                            }
                            while (edit_name != NULL) {
                                float rot[4] = {0.0f, 0.0f, 0.0f, 0.0f};
                                float floor_y = eCurPos[1];
                                if (!river) {
                                    eCurPos[1] = -1000.0f;
                                }
                                CEditPartsInfo *place_info = map->GetePartsInfo(edit_name);
                                if (place_info != NULL) {
                                    float place_pos[4];
                                    rot[1] = map->GetEditAngle(eCurRot);
                                    map->GetEditPos(place_pos, eCurPos);
                                    float alt = map->GetEditPartsAlt(place_info, place_pos, rot[1]);
                                    place_pos[1] = alt;
                                    eCurPos[1] = alt;
                                    ePartsCurPos[1] = alt;
                                    if (MagnetEnable != 0) {
                                        float magnet_pos[4];
                                        float magnet_rot;
                                        *(u_long128 *)magnet_pos = *(u_long128 *)place_pos;
                                        int was_magnet = MagnetPartsFlag;
                                        magnet_rot = rot[1];
                                        int line_parts = (place_info->attr & 0x100) != 0;
                                        MagnetPartsFlag = 0;
                                        if (!line_parts || (line_parts && !moving)) {
                                            MagnetPartsFlag = map->MagnetParts(place_info, magnet_pos, &magnet_rot);
                                            if (MagnetPartsFlag != 0) {
                                                rot[1] = magnet_rot;
                                                eCurRot = map->ConvEditAngle(magnet_rot);
                                                ePartsCurPos[0] = magnet_pos[0];
                                                place_pos[0] = magnet_pos[0];
                                                ePartsCurPos[2] = magnet_pos[2];
                                                place_pos[2] = magnet_pos[2];
                                                if (line_parts) {
                                                    eCurPos[0] = magnet_pos[0];
                                                    eCurPos[2] = magnet_pos[2];
                                                }
                                            }
                                        }
                                        if (MagnetPartsFlag != 0 && was_magnet == 0) {
                                            sndSePlay(GetSystemSndID(), 0x15, 0);
                                        }
                                    }
                                    if (place_info->attr & 0x20) {
                                        SetHelpMes(EDIT_HELP_PLACE_MAGNET, MagnetEnable, UndoEnable());
                                    } else {
                                        SetHelpMes(EDIT_HELP_PLACE, 0, UndoEnable());
                                    }
                                    int finish = 0;
                                    int finish_no = -1;
                                    if (place_info->id == 0x55) {
                                        float probe[4];
                                        PlacePartsFlag = 0;
                                        *(u_long128 *)probe = *(u_long128 *)eCurPos;
                                        probe[3] = 10.0f;
                                        finish_no = map->GetePlaceParts(probe);
                                        CEditParts *base = map->GetePlaceParts(finish_no);
                                        if (base != NULL && base->GetInfoID() == 0x4C) {
                                            finish = 1;
                                            eCurPos[1] = floor_y;
                                            PlacePartsFlag = 1;
                                            ePartsCurPos[1] = floor_y;
                                        }
                                    }
                                    EP_PLACE_INFO place;
                                    int blocked = 0;
                                    place.unk_44 = 0;
                                    PartsHeight = 0.0f;
                                    if (!finish) {
                                        if (river) {
                                            PlacePartsFlag = map->CheckRiverParts(place_pos);
                                        } else {
                                            PlacePartsFlag = map->CheckEditParts(place_info, place_pos, rot[1], &place);
                                            blocked = place.unk_44;
                                            if (!any_height &&
                                                CheckPlaceAlt(map_no, map, place_pos, place_info->id, &PartsHeight) == 0) {
                                                PlacePartsFlag = 0;
                                            }
                                        }
                                    }
                                    if (PlacePartsFlag == 0) {
                                        if (eCurPos[1] <= floor_y) {
                                            eCurPos[1] = floor_y;
                                            ePartsCurPos[1] = floor_y;
                                        }
                                    }
                                    if (pad->Btn(0x66) && RemainPartsNum > 0) {
                                        if (PlacePartsFlag != 0) {
                                            if (river) {
                                                if (!NowPlaceRiver()) {
                                                    PlaceRiverStart(map, place_pos);
                                                }
                                            } else if (finish) {
                                                DeleteKanketuParts(scene, map, place_pos, finish_no);
                                            } else {
                                                PlaceEditParts(map, place_pos, rot, &place);
                                            }
                                        } else if (blocked) {
                                            OpenSystemMes(scene, 0x3FD, 0x28);
                                        }
                                    }
                                    if (pad->Btn(0x6D)) {
                                        MagnetPartsFlag = 0;
                                        MagnetEnable = !MagnetEnable;
                                    }
                                }
                                break;
                            }
                        }
                        if (EditModeNo == EDIT_MODE_REMOVE) {
                            float probe[4];
                            SetHelpMes(EDIT_HELP_REMOVE, 0, 0);
                            *(u_long128 *)probe = *(u_long128 *)eCurPos;
                            probe[3] = 10.0f;
                            int parts_no = map->GetePlaceParts(probe);
                            eCurPos[1] = eCurPos[1] > probe[1] ? eCurPos[1] : probe[1];
                            CEditPartsInfo *remove_info = map->GetePartsInfoAtPlaceID(parts_no);
                            if (remove_info != NULL && !(remove_info->attr & 0x1)) {
                                map->focus_parts = parts_no;
                            }
                            if (pad->Btn(0x67)) {
                                eCurNowPos[1] = eCurPos[1];
                                RemoveMtnStart(map, probe, eCurPos);
                            }
                        }
                        while (EditModeNo == EDIT_MODE_PAINT || EditModeNo == EDIT_MODE_REPAINT) {
                            float probe[4];
                            *(u_long128 *)probe = *(u_long128 *)eCurPos;
                            probe[3] = 10.0f;
                            int parts_no = map->GetePlaceParts(probe);
                            CEditParts *parts = map->GetePlaceParts(parts_no);
                            if (parts != NULL) {
                                CEditPartsInfo *paint_info = parts->info;
                                if (paint_info != NULL) {
                                    int color_no = -1;
                                    int repaint = EditModeNo == EDIT_MODE_REPAINT;
                                    int paint_held = GetUserData()->GetNumSameItem(PaintItemNo);
                                    if (paint_info->paint_num > 0) {
                                        map->focus_parts = parts_no;
                                    }
                                    if (!parts->IsFence()) {
                                        if (paint_info->paint_num == 1) {
                                            if (repaint) {
                                                SetHelpMes(EDIT_HELP_REPAINT, 0, 0);
                                            } else {
                                                SetHelpMes(EDIT_HELP_PAINT, paint_info->paint_used, paint_held);
                                            }
                                            if (pad->Btn(0x68)) {
                                                color_no = 0;
                                            }
                                        }
                                        if (paint_info->paint_num == 2) {
                                            if (repaint) {
                                                SetHelpMes(EDIT_HELP_REPAINT_HOUSE, 0, 0);
                                            } else {
                                                SetHelpMes(EDIT_HELP_PAINT_HOUSE, paint_info->paint_used, paint_held);
                                            }
                                            if (pad->Btn(0x6B)) {
                                                color_no = 0;
                                            }
                                            if (pad->Btn(0x68)) {
                                                color_no = 1;
                                            }
                                        }
                                    } else {
                                        if (repaint) {
                                            SetHelpMes(EDIT_HELP_REPAINT_FENCE, 0, 0);
                                        } else {
                                            SetHelpMes(EDIT_HELP_PAINT_FENCE, paint_info->paint_used, paint_held);
                                        }
                                        if (pad->Btn(0x68)) {
                                            color_no = 0;
                                        }
                                        if (pad->Btn(0x6B)) {
                                            color_no = 99;
                                        }
                                    }
                                    if (color_no >= 0) {
                                        if (EditModeNo == EDIT_MODE_REPAINT) {
                                            float def_color[4];
                                            float now_color[4];
                                            map->RePaintNum(paint_info->paint_used);
                                            int def_no = color_no;
                                            if (color_no >= 3) {
                                                def_no = 0;
                                            }
                                            if (!paint_info->GetDefColor(def_no, def_color)) {
                                                break;
                                            }
                                            parts->GetColor(def_no, now_color);
                                            if (EditPartsCmpColor(now_color, def_color)) {
                                                break;
                                            }
                                            printf(at_1836__2, emGetPenkiItemNo(now_color));
                                            if (PaintEditParts(map, parts_no, color_no, def_color)) {
                                                CursorLockCnt = 30;
                                            }
                                        }
                                        if (EditModeNo == EDIT_MODE_PAINT) {
                                            int cost = paint_info->paint_used;
                                            int enough = paint_held >= cost;
                                            if (color_no == 99) {
                                                cost *= 5;
                                            }
                                            if (DebugFlag != 0 && GamePad__2.On(2)) {
                                                enough = 1;
                                            }
                                            if (color_no >= 0 && color_no < 2) {
                                                float now_color[4];
                                                parts->GetColor(color_no, now_color);
                                                if (EditPartsCmpColor(now_color, PaintColor)) {
                                                    cost = 0;
                                                }
                                            }
                                            if (enough) {
                                                if (cost > 0) {
                                                    PaintEditParts(map, parts_no, color_no, PaintColor);
                                                    GetUserData()->DeleteItem(PaintItemNo, cost);
                                                    CursorLockCnt = 30;
                                                }
                                            } else {
                                                OpenSystemMes(scene, 0x3FC, 0x1E);
                                            }
                                        }
                                    }
                                }
                            }
                            break;
                        }
                    } else {
                        int side_mode = PutSideMode;
                        if (side_mode == EDIT_PUT_SIDE_SELECT) {
                            SetHelpMes(EDIT_HELP_SELECT_WALL, 0, 0);
                            if (pad->Btn(0x66)) {
                                float probe[4];
                                CEditParts::WallInfo wall;
                                *(u_long128 *)probe = *(u_long128 *)eCurPos;
                                probe[3] = 1.0f;
                                int parts_no = map->GetePlaceParts(probe);
                                CEditParts *parts = map->GetePlaceParts(parts_no);
                                SelectWallGroup = 0;
                                if (parts != NULL && parts->IsWallParts() && parts->GetWallPlane(SelectWallGroup, &wall)) {
                                    StartEditPutWall(&wall);
                                    PuuSideRotCameraFlag = 1;
                                    side_mode = EDIT_PUT_SIDE_MOVE;
                                    NowSelectWallParts = parts_no;
                                    SelectWallGroup = 0;
                                    eDirCurRot[1] = mgAngleLimit(3.1415927f + camera->GetAngle());
                                    eDirCurLen = 200.0f;
                                    eDirCurRot[0] = 0.0f;
                                }
                            }
                        }
                        if (PutSideMode == EDIT_PUT_SIDE_MOVE) {
                            float wall_pos[4];
                            EP_PLACE_INFO place;
                            *(u_long128 *)wall_pos = *(u_long128 *)WallPutPos;
                            int placeable = map->CheckWallEditParts(map->GetePartsInfo(edit_name), wall_pos, SelectWallGroup,
                                                                    NowSelectWallParts, &place);
                            ePartsCurPos[0] = wall_pos[0];
                            ePartsCurPos[1] = wall_pos[1];
                            ePartsCurPos[2] = wall_pos[2];
                            ePartsCurRot[1] = wall_pos[3];
                            if (PuuSideRotCameraFlag != 0) {
                                camera->SetAngle(ePartsCurRot[1]);
                                PuuSideRotCameraFlag = 0;
                            }
                            PlacePartsFlag = 0;
                            if (placeable) {
                                PlacePartsFlag = 1;
                                if (pad->Btn(0x66)) {
                                    float wall_rot[4];
                                    mgZeroVector(wall_rot);
                                    wall_rot[1] = wall_pos[3];
                                    PlaceEditParts(map, wall_pos, wall_rot, &place);
                                    PutSideMode = EDIT_PUT_SIDE_OFF;
                                    PlacePartsFlag = 0;
                                }
                            }
                            CEditParts *base = map->GetePlaceParts(NowSelectWallParts);
                            if (base != NULL && base->GetWallGroupNum() > 0) {
                                CEditParts::WallInfo wall;
                                SetHelpMes(EDIT_HELP_PLACE_WALL, base->GetWallGroupNum(), UndoEnable());
                                int old_group = SelectWallGroup;
                                if (pad->Btn(0x69)) {
                                    SelectWallGroup++;
                                }
                                if (pad->Btn(0x6A)) {
                                    SelectWallGroup--;
                                }
                                if (SelectWallGroup < 0) {
                                    SelectWallGroup = base->GetWallGroupNum() - 1;
                                }
                                if (SelectWallGroup >= base->GetWallGroupNum()) {
                                    SelectWallGroup = 0;
                                }
                                if (old_group != SelectWallGroup && base->GetWallPlane(SelectWallGroup, &wall)) {
                                    StartEditPutWall(&wall);
                                    PuuSideRotCameraFlag = 1;
                                }
                            }
                        }
                        PutSideMode = side_mode;
                    }
                }

                float step[4];
                sceVu0SubVector(step, ePartsCurPos, ePartsCurNowPos);
                sceVu0ScaleVector(step, step, 0.5f);
                sceVu0AddVector(ePartsCurNowPos, ePartsCurNowPos, step);
                ePartsCurNowRot[1] = mgAngleInterpolate(ePartsCurNowRot[1], ePartsCurRot[1], 2.0f, 1);
                eCurNowPos[0] = eCurPos[0];
                eCurNowPos[1] += (eCurPos[1] - eCurNowPos[1]) / 2.0f;
                eCurNowPos[2] = eCurPos[2];
                if (PaintCurChr != NULL) {
                    PaintCurChr->Step();
                    char *motion = PaintCurChr->GetNowMotionName();
                    if (motion != NULL && strcmp(motion, at_1377__3) == 0 && PaintCurChr->CheckMotionEnd()) {
                        PaintCurChr->SetMotion(0, 0);
                    }
                }
                if (ShovelCurChr != NULL) {
                    ShovelCurChr->Step();
                    char *motion = ShovelCurChr->GetNowMotionName();
                    if (motion != NULL && strcmp(motion, at_1254__2) == 0 && ShovelCurChr->CheckMotionEnd()) {
                        ShovelCurChr->SetMotion(0, 0);
                    }
                }
                if (RemoveCurChr != NULL) {
                    RemoveCurChr->Step();
                    char *motion = RemoveCurChr->GetNowMotionName();
                    if (motion != NULL && strcmp(motion, at_1284__5) == 0 && RemoveCurChr->CheckMotionEnd()) {
                        RemoveCurChr->SetMotion(0, 0);
                    }
                }
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", EditMode__FP6CScene);
#endif
extern int cnt_1857;
extern s8 init_1858;
extern "C" float ePartsCurNowRot[4];
void DrawEditCursorParts(CScene *scene) {
    if (EditNowPlaceAnime() == 0 && PutSideMode != 1 && EditModeNo != EDIT_MODE_REMOVE) {
        if (init_1858 == 0) {
            init_1858 = 1;
            cnt_1857 = 0;
        }
        CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
        float rotation[4];
        rotation[2] = 0.0f;
        rotation[0] = 0.0f;
        rotation[1] = ePartsCurNowRot[1];
        float ambient[4];
        mgGetAmbient(ambient);
        float pulse = 32.0f * sinf(6.2831855f * (float)cnt_1857 / 60.0f);
        cnt_1857++;
        if (PlacePartsFlag != 0) {
            float base = 32.0f + pulse;
            ambient[0] += base;
            ambient[1] += base;
            ambient[2] += 128.0f + pulse;
        } else {
            float base = 32.0f + pulse;
            ambient[2] = ambient[1] = base;
            ambient[0] = 128.0f + pulse;
        }
        CEditPartsInfo *info = map->GetePartsInfoAtID(PartsInfoID);
        int lighting;
        if (info != NULL) {
            CMapParts *parts = info->parts;
            if (parts != NULL) {
                float position[4];
                *(u_long128 *)position = *(u_long128 *)ePartsCurNowPos;
                lighting = mgActiveLighting(3, 0);
                mgInitActiveLighting();
                mgSetAmbient(ambient);
                if (PreMenuCount < PreMenuMaxCount) {
                    position[1] += 40.0f * (float)PreMenuCount;
                    float scale = 1.0f - (float)(PreMenuCount + 1) / (float)PreMenuMaxCount;
                    if (parts != NULL) {
                        parts->SetScale(scale, 1.0f, scale);
                    }
                }
                if (!(info->attr & 0x80) && parts != NULL && PartsHeight < 300.0f) {
                    parts->SetPosition(position);
                    parts->SetRotation(rotation);
                    CFuncPointCheck check;
                    check.time = 12.0f;
                    parts->CopyFuncPointCheck(check);
                    parts->StepFuncPoint(check);
                    parts->Draw();
                }
                if (PreMenuCount < PreMenuMaxCount) {
                    if (parts != NULL) {
                        parts->SetScale(1.0f, 1.0f, 1.0f);
                    }
                    PreMenuCount++;
                }
                if (parts != NULL) {
                    parts->SetPosition(0.0f, 0.0f, 0.0f);
                    parts->SetRotation(0.0f, 0.0f, 0.0f);
                    parts->SetScale(1.0f, 1.0f, 1.0f);
                }
                mgActiveLighting(lighting, 0);
            }
        }
    }
}
extern char at_1961[];
extern char at_1962[];
extern char at_1963[];
extern int cnt_1939;
extern s8 init_1940;
extern "C" float pos_save_1942[4];
void DrawEditCursor(CScene *scene) {
    mgCFrame *cursor;
    CCharacter2 *chara;
    mgCFrame *unit;
    CEditPartsInfo *info;
    CEditMap *map;
    float position[4];
    float grid_position[4];
    float grid_size[4];
    map = (CEditMap *)scene->GetMap(scene->active_map);
    cursor = EditCursor[0];
    chara = NULL;
    *(u_long128 *)position = *(u_long128 *)eCurNowPos;
    unit = NULL;
    switch (EditModeNo) {
    case EDIT_MODE_REMOVE:
        chara = RemoveCurChr;
        cursor = NULL;
        if (map->IsRiverGrid(position)) {
            unit = UnitCursor;
        }
        break;
    case EDIT_MODE_PLACE:
        info = map->GetePartsInfoAtID(PartsInfoID);
        if (info != NULL) {
            if (EditNowPlaceAnime() == 0 && PutSideMode != 1) {
                cursor = NULL;
            }
            if (info->attr & 0x80) {
                unit = UnitCursor;
                cursor = NULL;
                chara = ShovelCurChr;
            }
        }
        if (NowPlaceRiver()) {
            chara = ShovelCurChr;
            unit = NULL;
            cursor = NULL;
        }
        break;
    case EDIT_MODE_PAINT:
    case EDIT_MODE_REPAINT:
        chara = PaintCurChr;
        cursor = NULL;
        break;
    }
    if (cursor != NULL) {
        cursor->SetPosition(position);
        cursor->SetScale(6.0f, 6.0f, 6.0f);
        mgDrawDirect(cursor);
    }
    if (chara != NULL) {
        chara->SetPosition(position);
        chara->SetScale(6.0f, 6.0f, 6.0f);
        chara->DrawDirect();
    }
    if (unit != NULL && map->GetGridPos(position, grid_position, grid_size)) {
        if (unit != NULL) {
            grid_position[1] += 10.0f;
            unit->SetPosition(grid_position);
            unit->SetScale(grid_size[0], 1.0f, grid_size[2]);
            float color[4] = {128.0f, 64.0f, 64.0f, 48.0f};
            if (PlacePartsFlag != 0) {
                color[0] = 64.0f;
                color[1] = 78.0f;
                color[2] = 128.0f;
            }
            if (unit->attr != NULL) {
                *(u_long128 *)unit->attr->color = *(u_long128 *)color;
            }
        }
        mgDrawDirect(unit);
    }
    if (DebugFlag == 0 || DebugInfo.georama_debug == 0) {
        return;
    }
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.AlphaTestEnable(0);
    prim.DepthTestEnable(0);
    prim.Begin(6);
    prim.Color(1, 1, 1, 0x40);
    prim.Vertex(0x100, 0xA, 0);
    prim.Vertex(0x1FF, 0x3C, 0);
    prim.End();
    char text[0x100];
    char *end = text;
    if (init_1940 == 0) {
        cnt_1939 = 0;
        init_1940 = 1;
    }
    if (GamePad__2.Down(0x200)) {
        if (cnt_1939 == 0) {
            *(u_long128 *)pos_save_1942 = *(u_long128 *)eCurPos;
            cnt_1939++;
            pos_save_1942[3] = eCurRot;
        } else {
            cnt_1939 = 0;
        }
    }
    *end = 0;
    if (cnt_1939 == 0) {
        end += sprintf(end, at_1961, eCurPos[0], eCurPos[1], eCurPos[2], eCurRot);
    }
    if (cnt_1939 == 1) {
        end += sprintf(end, at_1961, pos_save_1942[0], pos_save_1942[1], pos_save_1942[2], (int)pos_save_1942[3]);
        end += sprintf(end, at_1961, eCurPos[0], eCurPos[1], eCurPos[2], eCurRot);
        end += sprintf(end, at_1962, mgDistVector(pos_save_1942, eCurPos));
        sprintf(end, at_1963, mgDistVectorXZ(pos_save_1942, eCurPos));
        mgCFrame *marker = EditCursor[0];
        if (marker != NULL) {
            marker->SetPosition(pos_save_1942);
            mgDrawDirect(marker);
        }
    }
    GetDebugFont()->DrawDirect(text, 0x100, 0xA);
}
extern char *space_str[6];
extern char *place_str[6];
extern char *rotate_str[6];
extern char *sw_wall_str[6];
extern char *magnet_str[6];
extern char *onoff_str[2][6];
extern char *remove_str[6];
extern char *sel_wall_str[6];
extern char *paint_str[6];
extern char *undo_str[6];
extern char *paint_house_str[6];
extern char *paint_fence_str[6];
extern char *paint_num_str[6];
extern char *repaint_str[6];
extern char *repaint_house_str[6];
extern char *repaint_fence_str[6];
void DrawEditHelpMes(void) {
    int lang;
    if (EditHelpMesNo < 0 || (lang = LanguageCode) < 0 || lang >= 6) {
        return;
    }
    Font__2.SetColor(0xFF, 0xFF, 0xFF, 0x80);
    char text[0x100] = {0};
    char number[0x100] = {0};
    switch (EditHelpMesNo) {
    case 11:
        strcpy(text, undo_str[lang]);
        break;
    case 0:
        strcpy(text, place_str[lang]);
        strcat(text, space_str[lang]);
        strcat(text, rotate_str[lang]);
        if (EditHelpMesParam2 != 0) {
            strcat(text, space_str[lang]);
            strcat(text, undo_str[lang]);
        }
        break;
    case 1:
        strcpy(text, place_str[lang]);
        if (EditHelpMesParam > 1) {
            strcat(text, sw_wall_str[lang]);
        }
        if (EditHelpMesParam2 != 0) {
            strcat(text, space_str[lang]);
            strcat(text, undo_str[lang]);
        }
        break;
    case 2:
        strcpy(text, place_str[lang]);
        strcat(text, space_str[lang]);
        strcat(text, rotate_str[lang]);
        strcat(text, space_str[lang]);
        strcat(text, magnet_str[lang]);
        strcat(text, onoff_str[EditHelpMesParam == 0][lang]);
        if (EditHelpMesParam2 != 0) {
            strcat(text, space_str[lang]);
            strcat(text, undo_str[lang]);
        }
        break;
    case 3:
        strcpy(text, remove_str[lang]);
        break;
    case 4:
        strcpy(text, sel_wall_str[lang]);
        break;
    case 5:
        sprintf(text, paint_str[lang], EditHelpMesParam);
        sprintf(number, paint_num_str[lang], EditHelpMesParam2);
        strcat(text, space_str[lang]);
        strcat(text, number);
        break;
    case 6:
        sprintf(text, paint_house_str[lang], EditHelpMesParam, EditHelpMesParam);
        sprintf(number, paint_num_str[lang], EditHelpMesParam2);
        strcat(text, space_str[lang]);
        strcat(text, number);
        break;
    case 7:
        sprintf(text, paint_fence_str[lang], EditHelpMesParam, EditHelpMesParam * 5);
        sprintf(number, paint_num_str[lang], EditHelpMesParam2);
        strcat(text, space_str[lang]);
        strcat(text, number);
        break;
    case 8:
        strcpy(text, repaint_str[lang]);
        break;
    case 9:
        strcpy(text, repaint_house_str[lang]);
        break;
    case 10:
        strcpy(text, repaint_fence_str[lang]);
        break;
    }
    if (text[0] != 0) {
        int y = mgScreenHeight - 0x1F;
        Font__2.SetStr(text);
        Font__2.SetPos(0x28, y);
        Font__2.DrawDirect(Font__2.str, Font__2.pos_x, Font__2.pos_y);
    }
    EditHelpMesNo = -1;
}
static int CheckFocusBalanceParts(CEditMap *map, int index, float *cursor) {
    float box[8];
    CMapParts *parts = (CMapParts *)map->balance_parts[index];
    if (parts == NULL) {
        return 0;
    }
    if (parts->GetBoundBox((mgVu0FBOX *)box) == 0) {
        return 0;
    }
    if (!(cursor[0] <= box[0])) {
        return 0;
    }
    if (cursor[0] < box[4]) {
        return 0;
    }
    if (!(cursor[2] <= box[2])) {
        return 0;
    }
    int outside = 1;
    if (!(cursor[2] < box[6])) {
        outside = 0;
    }
    return outside ^ 1;
}
static void InitBalanceDraw(CScene *scene) {
    CEditMap *map;

    map = (CEditMap *)scene->GetMap(scene->active_map);
    if (map != NULL) {
        GroundBalance__8CEditMapFi(map, 0);
    }
    GetBalanceHeight(scene, (float *)now_balance_h);
}
static void GetBalanceHeight(CScene *scene, float *balance) {
    CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
    int num_x = map->balance_weight[1] - map->balance_weight[0];
    int depth = map->balance_weight[3] - map->balance_weight[2];
    float abs_width;
    if ((float)num_x < 0.0f) {
        abs_width = -(float)num_x;
    } else {
        abs_width = (float)num_x;
    }
    if (abs_width < 4.0f) {
        num_x = 0;
    }
    float abs_depth;
    if ((float)depth < 0.0f) {
        abs_depth = -(float)depth;
    } else {
        abs_depth = (float)depth;
    }
    if (abs_depth < 4.0f) {
        depth = 0;
    }
    balance[0] = -num_x;
    balance[1] = num_x;
    balance[2] = -depth;
    balance[3] = depth;
    int i = 0;
    do {
        float *slot = &balance[i];
        if (!(*slot <= 20.0f)) {
            *slot = 20.0f;
        }
        if (*slot < -20.0f) {
            *slot = -20.0f;
        }
        i++;
    } while (i < 4);
}
#ifdef NONMATCHING
extern mgCTexture *eSysTexture;
void DrawEditSystem(int block, CScene *scene, float *pos, int edit) {
    mgCTextureManager *manager = &mgTexManager;
    if (eSysTexture != NULL) {
        manager->ReloadTexture(block, (sceVif1Packet *)NULL);
        mgCDrawPrim prim;
        prim.Initialize(NULL, NULL);
        prim.AlphaBlendEnable(1);
        prim.AlphaTestEnable(0);
        prim.DepthTestEnable(0);
        prim.TextureMapEnable(1);
        int icon_y = mgScreenHeight - 0x38;
        if (EditHelpMesNo >= 0) {
            icon_y -= 0x14;
        }
        if (edit == 0) {
            if (CheckWalkToEdit(scene, pos)) {
                prim.Begin(6);
                prim.Texture(eSysTexture);
                prim.Color(0x80, 0x80, 0x80, 0x80);
                prim.TextureCrd(0, 0x5A);
                prim.Vertex(0x14, icon_y, 0);
                prim.TextureCrd(0x28, 0x80);
                prim.Vertex(0x3C, icon_y + 0x26, 0);
                prim.End();
            }
        } else {
            float exit_pos[4];
            if (CheckEditToWalk(scene, exit_pos)) {
                prim.Begin(6);
                prim.Texture(eSysTexture);
                prim.Color(0x80, 0x80, 0x80, 0x80);
                prim.TextureCrd(0x28, 0x5A);
                prim.Vertex(0x14, icon_y, 0);
                prim.TextureCrd(0x50, 0x80);
                prim.Vertex(0x3C, icon_y + 0x26, 0);
                prim.End();
            }
            if (scene->GetMainMapNo() == 1) {
                CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
                if (map != NULL) {
                    prim.Begin(6);
                    prim.Texture(eSysTexture);
                    int x = 0x12C;
                    float colors[4][4] = {
                        {90.0f, 20.0f, 10.0f, 48.0f},
                        {180.0f, 40.0f, 20.0f, 77.0f},
                        {30.0f, 60.0f, 90.0f, 48.0f},
                        {60.0f, 120.0f, 180.0f, 77.0f},
                    };
                    int balance = map->BalanceCheck();
                    float target[4];
                    GetBalanceHeight(scene, target);
                    int focused = 0;
                    float cursor[4];
                    *(u_long128 *)cursor = *(u_long128 *)eCurPos;
                    for (int i = 0; i < 4; i++) {
                        float *color = colors[balance * 2];
                        prim.Color(color);
                        if (!focused && CheckFocusBalanceParts(map, i, cursor)) {
                            prim.Color(color + 4);
                            focused = 1;
                        }
                        float *now = (float *)now_balance_h + i;
                        float height = *now + (target[i] - *now) / 12.0f;
                        *now = height;
                        int height16 = fptosi(16.0f * height);
                        int height1 = fptosi(height);
                        prim.TextureCrd(0x52, 0);
                        prim.Vertex4(x * 16, height16 + (mgScreenHeight - 0x2C) * 16, 0);
                        prim.TextureCrd(0x80, 0x7C);
                        prim.Vertex4((x + 0x2E) * 16, height16 + (mgScreenHeight + 0x50) * 16, 0);
                        prim.TextureCrd(i * 0xC, 0x4A);
                        prim.Vertex(x + 0x11, mgScreenHeight - 0x22 + height1, 0);
                        prim.TextureCrd(i * 0xC + 0xC, 0x5A);
                        prim.Vertex(x + 0x1D, mgScreenHeight - 0x12 + height1, 0);
                        x += 0x30;
                    }
                    prim.End();
                }
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", DrawEditSystem__FiP6CScenePfi);
#endif
static int GetGeoCheckPts(CMap *map) {
    if (map != NULL) {
        return GetPlaceParts__4CMapFPc(map, (char *)at_2213__3);
    }
    return 0;
}
static int GetGeoCheckCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max) {
    if (map == NULL) {
        return 0;
    }
    CMapParts *part = (CMapParts *)GetGeoCheckPts(map);
    if (part == NULL) {
        return 0;
    }
    part->Show(1);
    int count = part->GetColPoly(polys, box, max);
    part->Show(0);
    return count;
}
static int GetGeoCheckCamCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max) {
    if (map == NULL) {
        return 0;
    }
    CMapParts *part = (CMapParts *)GetGeoCheckPts(map);
    if (part == NULL) {
        return 0;
    }
    part->Show(1);
    int count = part->GetCameraPoly(polys, box, max);
    part->Show(0);
    return count;
}
int CheckWalkToEdit(CScene *scene, float *position) {
    float pos[4];
    float hit[4];
    mgVu0FBOX box;
    CCPoly polys[0x80];
    float hit_normals[0x20][4];
    int hit_indices[0x20];
    float normal[4];
    *(u_long128 *)pos = *(u_long128 *)position;
    CMap *map = scene->GetMap(scene->active_map);
    if (map == NULL) {
        return 1;
    }
    if (GetGeoCheckPts(map) == 0) {
        return 1;
    }
    *(u_long128 *)box.max = *(u_long128 *)pos;
    *(u_long128 *)box.min = *(u_long128 *)pos;
    pos[1] = 20.0f;
    box.max[1] = 100.0f;
    box.max[0] += 100.0f;
    box.max[2] += 100.0f;
    box.min[0] -= 100.0f;
    box.min[1] = -100.0f;
    box.min[2] -= 100.0f;
    int poly_count = GetGeoCheckCol(map, box, polys, 0x80);
    if (CheckHitVertical(polys, poly_count, pos, -40.0f, hit, 0) < 0) {
        return 0;
    }
    pos[3] = 20.0f;
    int hit_count = CheckHitsSphere(polys, poly_count, pos, 0x20, hit_indices, hit_normals, 0, 0);
    int i;
    for (i = 0; i < hit_count; i++) {
        sceVu0Normalize(normal, polys[hit_indices[i]].normal);
        float slope;
        if (normal[1] < 0.0f) {
            slope = -normal[1];
        } else {
            slope = normal[1];
        }
        if (slope <= 0.5f) {
            return 0;
        }
    }
    return 1;
}
int CheckEditToWalk(CScene *scene, float *position) {
    float cursor[4];
    float ground_hit[4];
    mgVu0FBOX box;
    CCPoly polys[512];
    float hit_positions[64][4];
    int hit_indices[64];
    *(u_long128 *)cursor = *(u_long128 *)eCurPos;
    *(u_long128 *)position = *(u_long128 *)eCurPos;
    CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
    if (map == NULL) {
        return 1;
    }
    if (GetGeoCheckPts(map) == 0) {
        return 1;
    }
    cursor[3] = 1.0f;
    if (map->IsRiverGrid(cursor)) {
        return 0;
    }
    *(u_long128 *)box.max = *(u_long128 *)eCurPos;
    *(u_long128 *)box.min = *(u_long128 *)eCurPos;
    cursor[1] = 1000.0f;
    box.max[0] += 20.0f;
    box.max[1] = 10000.0f;
    box.max[2] += 20.0f;
    box.min[0] -= 20.0f;
    box.min[1] = -10000.0f;
    box.min[2] -= 20.0f;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    int poly_count = scene->GetColPoly(polys, box, 512);
    int ground_index = CheckHitVertical(polys, poly_count, cursor, -2000.0f, ground_hit, 1);
    if (ground_index < 0) {
        return 0;
    }
    *(u_long128 *)position = *(u_long128 *)ground_hit;
    if (polys[ground_index].area_kind != 9) {
        return 0;
    }
    cursor[3] = 10.0f;
    int hit_count = CheckHitsPipeY(polys, poly_count, cursor,
                                  -(5.0f + (cursor[1] - ground_hit[1])), 64,
                                  hit_indices, hit_positions, 0, 1);
    int index;
    for (index = 0; index < hit_count; index++) {
        if (!(hit_positions[index][1] <= 5.0f + ground_hit[1])) {
            return 0;
        }
    }
    return 1;
}

extern "C" void __sinit_editmode_cpp(void) {
    Font__2.Init();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1268__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1362__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1931__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", space_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", place_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", rotate_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", sw_wall_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", magnet_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", onoff_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", remove_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", sel_wall_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", paint_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", undo_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", paint_house_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", paint_fence_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", paint_num_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", repaint_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", repaint_house_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", repaint_fence_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2188__3__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1067__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1068__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1069__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1070__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1071__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1072__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1073__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1074__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1075__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1076__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1254__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1284__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1367__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1377__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1835__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1836__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1961__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1962__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1963__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1964__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1965__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1966__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1967__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1968__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1969__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1970__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1971__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1972__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1973__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1974__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1975__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1976__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1977__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1978__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1979__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1980__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1981__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1982__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1983__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1984__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1985__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1986__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1987__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1988__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1989__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1990__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1991__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1992__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1993__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1994__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1995__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1996__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1997__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1998__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_1999__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2000__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2001__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2002__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2003__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2004__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2005__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2006__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2007__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2008__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2009__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2010__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2011__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2012__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2013__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2014__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2015__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2016__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2017__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2018__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2019__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2020__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2021__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2022__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2023__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2024__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2025__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2026__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2027__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2028__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2029__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2030__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2031__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2032__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2033__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2034__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2035__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2036__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2037__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2038__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2039__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2040__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2041__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2042__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2043__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2044__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2045__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2046__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2047__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2048__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2049__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2050__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2051__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2052__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2053__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2054__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2103__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", at_2213__3__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", D_0037B068__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editmode", SysMesNo__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(EditModeNo, 0x4);
INCLUDE_BSS(MagnetEnable, 0x4);
INCLUDE_BSS(HighSpeedMoveCnt, 0x4);
INCLUDE_BSS(PutSideMode, 0x4);
INCLUDE_BSS(PuuSideRotCameraFlag, 0x4);
INCLUDE_BSS(PlacePartsNo, 0x4);
INCLUDE_BSS(PartsInfoID, 0x4);
INCLUDE_BSS(RemainPartsNum, 0x4);
INCLUDE_BSS(PlacePartsFlag, 0x4);
INCLUDE_BSS(PartsHeight, 0x4);
INCLUDE_BSS(MagnetPartsFlag, 0x4);
INCLUDE_BSS(PaintItemNo, 0x4);
INCLUDE_BSS(CursorLockCnt, 0x4);
INCLUDE_BSS(PlaceRiverCnt, 0x4);
INCLUDE_BSS(RemoveMtnCnt, 0x4);
INCLUDE_BSS(eDirCurLen, 0x4);
INCLUDE_BSS(NowSelectWallParts, 0x4);
INCLUDE_BSS(SelectWallGroup, 0x4);
INCLUDE_BSS(PreMenuCount, 0x4);
INCLUDE_BSS(PreMenuMaxCount, 0x4);
INCLUDE_BSS(CtrlLockFlag, 0x4);
INCLUDE_BSS(eCameraDist, 0x4);
INCLUDE_BSS(eCurRot, 0x4);
INCLUDE_BSS(eSysTexture, 0x4);
INCLUDE_BSS(PaintCursor, 0x4);
INCLUDE_BSS(PaintCursor2, 0x4);
INCLUDE_BSS(PaintCurChr, 0x4);
INCLUDE_BSS(RemoveCursor, 0x4);
INCLUDE_BSS(ShovelCursor, 0x4);
INCLUDE_BSS(ShovelCurChr, 0x4);
INCLUDE_BSS(RemoveCurChr, 0x4);
INCLUDE_BSS(UnitCursor, 0x4);
INCLUDE_BSS(EditHelpMesNo, 0x4);
INCLUDE_BSS(EditHelpMesParam, 0x4);
INCLUDE_BSS(EditHelpMesParam2, 0x4);
INCLUDE_BSS(SysMesCnt, 0x4);
INCLUDE_BSS(cnt_1857, 0x4);
INCLUDE_BSS(init_1858, 0x4);
INCLUDE_BSS(cnt_1939, 0x4);
INCLUDE_BSS(init_1940, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(UndoData, 0x30);
INCLUDE_BSS(PaintColor, 0x10);
INCLUDE_BSS(eCurPos, 0x10);
INCLUDE_BSS(eCurNowPos, 0x10);
INCLUDE_BSS(ePartsCurPos, 0x10);
INCLUDE_BSS(ePartsCurNowPos, 0x10);
INCLUDE_BSS(ePartsCurRot, 0x10);
INCLUDE_BSS(ePartsCurNowRot, 0x10);
INCLUDE_BSS(PlaceRiverPos, 0x10);
INCLUDE_BSS(RemoveMtnPos, 0x10);
INCLUDE_BSS(RemoveMtnCurPos, 0x10);
INCLUDE_BSS(eDirCurRot, 0x10);
INCLUDE_BSS(WallPutPos, 0x10);
INCLUDE_BSS(WallInfo, 0x40);
INCLUDE_BSS(EditCursor, 0x10);
INCLUDE_BSS(Font__2, 0xC0);
INCLUDE_BSS(at_1148, 0x10);
INCLUDE_BSS(at_1149__2, 0x10);
INCLUDE_BSS(at_1445__3, 0x10);
INCLUDE_BSS(at_1579__2, 0x10);
INCLUDE_BSS(pos_save_1942, 0x10);
INCLUDE_BSS(at_2063, 0x100);
INCLUDE_BSS(at_2064, 0x100);
INCLUDE_BSS(now_balance_h, 0x10);
