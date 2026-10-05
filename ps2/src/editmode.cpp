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
#include "editmode.hpp"

extern "C" int GetBuildPartsNum__9CSaveDataFi(CSaveData *save, int parts_no);
void InitBalanceDraw(CScene *scene);
void GetBalanceHeight(CScene *scene, float *balance);
int GetGeoCheckCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max);

extern "C" UNDO_DATA UndoData;
extern "C" CEditParts::WallInfo WallInfo;

extern mgRect<int> data[];
extern "C" char at_1254__2[];
extern "C" char at_1284__5[];

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
extern "C" u32 EditModeNo;
extern "C" u32 HighSpeedMoveCnt;
extern "C" u32 MagnetEnable;
extern "C" u32 eCameraDist;
extern "C" float eCurPos[4];
extern "C" u8 ePartsCurNowPos[16];
extern "C" u8 ePartsCurPos[16];
extern "C" u8 eCurNowPos[16];
extern "C" int eCurRot;
extern "C" int PlacePartsFlag;
extern "C" int RemainPartsNum;
extern "C" float WallPutPos[4];
extern "C" CEditParts::WallInfo WallInfo;
extern "C" int __as__9mgVu0FBOXFR9mgVu0FBOX(...);
extern "C" int GroundBalance__8CEditMapFi(CEditMap *, int);
extern "C" int UpdateHouse__8CEditMapFv(CEditMap *);
extern "C" float PlaceRiverPos[4];
extern CCharacter2 *ShovelCurChr;
extern "C" u8 at_1268__3[16];
extern "C" float RemoveMtnPos[4];
extern "C" u8 RemoveMtnCurPos[16];
extern CCharacter2 *RemoveCurChr;
extern "C" u8 now_balance_h[16];
extern "C" u8 at_2213__3[10];
extern "C" int GetPlaceParts__4CMapFPc(CMap *map, char *name);

// Code (.text)
int CheckControl(void) {
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
void SetHelpMes(int message_no, int param, int param2) {
    EditHelpMesNo = message_no;
    EditHelpMesParam = param;
    EditHelpMesParam2 = param2;
}
extern "C" int GetUserData__Fv__3(void) {
    CSaveData *save;

    save = GetSaveData();
    if (save != 0) {
        return (int)&save->user_data;
    }
    return 0;
}
float ConvColor(float component) {
    return component / 128.0f;
}
void ConvColorV(float *color) {
    color[0] /= 128.0f;
    color[1] /= 128.0f;
    color[2] /= 128.0f;
}
int emSearchColorCode(float *color) {
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
int emGetPenkiItemNo(int slot) {
    if ((slot < 0) || (slot >= 8)) {
        return -1;
    }
    return GetPenkiItemNo(slot);
}
void emGetPenkiItemNo(float *color) {
    emGetPenkiItemNo(emSearchColorCode(color));
}
void IntiSystemMes(void) {
    SysMesCnt = 0;
    SysMesNo = -1;
}
void OpenSystemMes(CScene *scene, int message_no, int frames) {
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
void SystemMesClose(CScene *scene) {
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
void SystemMesStep(CScene *scene) {
    if (SysMesNo >= 0) {
        if (SysMesCnt < 0) {
            SystemMesClose(scene);
            SysMesCnt = 0;
        }
        SysMesCnt = SysMesCnt - 1;
    }
}
int EditStartPlaceEffect(CEditParts *parts, float *pos) {
    int anime_result;
    CEditPartsInfo *info;
    if (parts == NULL || (info = parts->info) == NULL) {
        return 0;
    }
    anime_result = EditSetPlaceAnime(info->place_anime, (CMapParts *)parts);
    anime_result |= EditPlaceEffect(parts, pos);
    return anime_result;
}
int EditEndPlaceEffect(void) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", LoadEditCursor__FP9mgCMemoryi);
int GetSelPartsInfoID(void) {
    return PartsInfoID;
}
void ClearEditStepCnt(void) {
    PlaceRiverCnt = 0;
    CursorLockCnt = 0;
    RemoveMtnCnt = 0;
}
void ClearUndoFlag(void) {
    UndoData.info_id = -1;
    UndoData.parts_no = -1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", ClearEditFlag__Fv);
void InitEditFlag(void) {
    eCameraDist = 0x44160000;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", StartEditModeFromMenu__FP6CSceneiPi);
void *GetUndoData(void) {
    return &UndoData;
}
int UndoEnable(void) {
    return *(int *)GetUndoData() >= 0;
}
void UndoPlaceParts(CScene *scene) {
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
void StackUndoData(UNDO_DATA *data) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", DeleteKanketuParts__FP6CSceneP8CEditMapPfi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", PaintEditParts__FP8CEditMapiiPf);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", CheckPlaceAlt__FiP8CEditMapPfiPf);
float GetGeoMapLimitHeight(int map_kind) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", EditMode__FP6CScene);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", DrawEditCursorParts__FP6CScene);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", DrawEditCursor__FP6CScene);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", DrawEditHelpMes__Fv);
int CheckFocusBalanceParts(CEditMap *map, int index, float *cursor) {
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
void InitBalanceDraw(CScene *scene) {
    CEditMap *map;

    map = (CEditMap *)scene->GetMap(scene->active_map);
    if (map != NULL) {
        GroundBalance__8CEditMapFi(map, 0);
    }
    GetBalanceHeight(scene, (float *)now_balance_h);
}
void GetBalanceHeight(CScene *scene, float *balance) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", DrawEditSystem__FiP6CScenePfi);
int GetGeoCheckPts(CMap *map) {
    if (map != NULL) {
        return GetPlaceParts__4CMapFPc(map, (char *)at_2213__3);
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", GetGeoCheckCol__FP4CMapR9mgVu0FBOXP6CCPolyi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", GetGeoCheckCamCol__FP4CMapR9mgVu0FBOXP6CCPolyi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", CheckEditToWalk__FP6CScenePf);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editmode", __sinit_editmode_cpp);

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
