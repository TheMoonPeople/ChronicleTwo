#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "cameracontrol.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "dng_effect.hpp"
#include "editctrl.hpp"
#include "editeff.hpp"
#include "editmap.hpp"
#include "editmenu.hpp"
#include "editmode.hpp"
#include "effscript.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menudraw.hpp"
#include "mg_dataset.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "padcontrol.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"

static void InitBalanceDraw(CScene *scene);
static int  CheckFocusBalanceParts(CEditMap *map, int index, float *cursor);
static void GetBalanceHeight(CScene *scene, float *balance);
static int  GetGeoCheckCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max);
static int  GetGeoCheckCamCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max);

/**
 *
 * Georama tool selected from EditModeType.
 *
 */
static int EditModeNo;

/**
 *
 * Whether cursor placement snaps to nearby parts.
 *
 */
static int MagnetEnable;

/**
 *
 * Consecutive cursor movement frames used to accelerate movement.
 *
 */
static int HighSpeedMoveCnt;

/**
 *
 * Wall-placement phase selected from EditPutSideMode.
 *
 */
static int PutSideMode;

/**
 *
 * Whether wall placement turns the editor camera.
 *
 */
static int PuuSideRotCameraFlag;

/**
 *
 * Slot of the part currently selected for placement.
 *
 */
static int PlacePartsNo;

/**
 *
 * Definition ID of the part currently selected for placement.
 *
 */
static int PartsInfoID;

/**
 *
 * Number of selected parts remaining in the inventory.
 *
 */
static int RemainPartsNum;

/**
 *
 * Whether the current cursor position allows placement.
 *
 */
static int PlacePartsFlag;

/**
 *
 * Height of the current placement above the ground.
 *
 */
static float PartsHeight;

/**
 *
 * Whether the current placement is attached to a nearby part.
 *
 */
static int MagnetPartsFlag;

/**
 *
 * Inventory item consumed by the selected paint.
 *
 */
static int PaintItemNo;

/**
 *
 * Frames remaining before the cursor can move again.
 *
 */
static int CursorLockCnt;

/**
 *
 * Frames remaining in the river placement animation.
 *
 */
static int PlaceRiverCnt;

/**
 *
 * Frames remaining in the removal animation.
 *
 */
static int RemoveMtnCnt;

/**
 *
 * Distance from the placement cursor to its direction marker.
 *
 */
static float eDirCurLen;

/**
 *
 * Slot of the part whose wall is selected for placement.
 *
 */
static int NowSelectWallParts;

/**
 *
 * Selected wall plane within the target part.
 *
 */
static int SelectWallGroup;

/**
 *
 * Current frame of the preview animation before opening the menu.
 *
 */
static int PreMenuCount;

/**
 *
 * Duration of the preview animation before opening the menu.
 *
 */
static int PreMenuMaxCount;

/**
 *
 * Number of outstanding editor control locks.
 *
 */
static int CtrlLockFlag;

/**
 *
 * Requested editor camera distance.
 *
 */
static float eCameraDist;

/**
 *
 * Integer 15-degree turn index of the placement cursor.
 *
 */
static int eCurRot;

/**
 *
 * Texture containing the editor system icons.
 *
 */
static mgCTexture *eSysTexture;

/**
 *
 * Root frame of the paint cursor model.
 *
 */
static mgCFrame *PaintCursor;

/**
 *
 * Paint cursor frame whose material displays the selected color.
 *
 */
static mgCFrame *PaintCursor2;

/**
 *
 * Animated character for the paint cursor.
 *
 */
static CCharacter2 *PaintCurChr;

/**
 *
 * Root frame of the removal cursor model.
 *
 */
static mgCFrame *RemoveCursor;

/**
 *
 * Root frame of the shovel cursor model.
 *
 */
static mgCFrame *ShovelCursor;

/**
 *
 * Animated character for the shovel cursor.
 *
 */
static CCharacter2 *ShovelCurChr;

/**
 *
 * Animated character for the removal cursor.
 *
 */
static CCharacter2 *RemoveCurChr;

/**
 *
 * Grid-cell highlight model for the editor cursor.
 *
 */
static mgCFrame *UnitCursor;

/**
 *
 * Pending help line selected from EditHelpMes.
 *
 */
static int EditHelpMesNo;

/**
 *
 * Primary formatting parameter for the pending help line.
 *
 */
static int EditHelpMesParam;

/**
 *
 * Secondary formatting parameter for the pending help line.
 *
 */
static int EditHelpMesParam2;

/**
 *
 * Frames remaining before closing the editor system message.
 *
 */
static int SysMesCnt;

/**
 *
 * Open editor system message number, or -1 when none is open.
 *
 */
static int SysMesNo = -1;

/**
 *
 * Record of the last placement available for undo.
 *
 */
static UNDO_DATA UndoData;

/**
 *
 * Color applied by the selected paint tool.
 *
 */
static sceVu0FVECTOR PaintColor;

/**
 *
 * Target position of the editor cursor.
 *
 */
static sceVu0FVECTOR eCurPos;

/**
 *
 * Smoothed display position of the editor cursor.
 *
 */
static sceVu0FVECTOR eCurNowPos;

/**
 *
 * Target position of the part preview.
 *
 */
static sceVu0FVECTOR ePartsCurPos;

/**
 *
 * Smoothed display position of the part preview.
 *
 */
static sceVu0FVECTOR ePartsCurNowPos;

/**
 *
 * Target rotation of the part preview.
 *
 */
static sceVu0FVECTOR ePartsCurRot;

/**
 *
 * Smoothed display rotation of the part preview.
 *
 */
static sceVu0FVECTOR ePartsCurNowRot;

/**
 *
 * Position at which the river placement animation places a part.
 *
 */
static sceVu0FVECTOR PlaceRiverPos;

/**
 *
 * Position of the part selected for removal.
 *
 */
static sceVu0FVECTOR RemoveMtnPos;

/**
 *
 * Cursor position associated with the removal animation.
 *
 */
static sceVu0FVECTOR RemoveMtnCurPos;

/**
 *
 * Rotation of the placement direction marker.
 *
 */
static sceVu0FVECTOR eDirCurRot;

/**
 *
 * Position across the selected wall and height above its center.
 *
 */
sceVu0FVECTOR WallPutPos;

/**
 *
 * Plane, center and bounds of the selected placement wall.
 *
 */
CEditParts::WallInfo WallInfo;

/**
 *
 * Frames used for the editor cursor and its direction markers.
 *
 */
static mgCFrame *EditCursor[3];

/**
 *
 * Smoothed display heights of the four ground-balance indicators.
 *
 */
static sceVu0FVECTOR now_balance_h;

/**
 *
 * Font used to draw Georama help lines.
 *
 */
static CFont Font__2;

// Code (.text)
/**
 *
 * Returns the current editor control lock count.
 *
 */
static int CheckControl() {
    return CtrlLockFlag;
}

void EditModeControlLock() {
    CtrlLockFlag++;
}

void EditModeControlUnLock() {
    CtrlLockFlag -= 1;

    if (CtrlLockFlag < 0) {
        CtrlLockFlag = 0;
    }
}

/**
 *
 * Selects the editor help message and its formatting parameters.
 *
 */
static void SetHelpMes(int message_no, int param, int param2) {
    EditHelpMesNo = message_no;
    EditHelpMesParam = param;
    EditHelpMesParam2 = param2;
}

/**
 *
 * Returns the user data manager from the current save.
 *
 */
static CUserDataManager *GetUserData() {
    CSaveData *save;

    save = GetSaveData();

    if (save != NULL) {
        return &save->user_data;
    }

    return NULL;
}

/**
 *
 * Converts a paint color component to the editor color scale.
 *
 */
static float ConvColor(float component) {
    return component / 128.0f;
}

/**
 *
 * Converts the RGB components of a paint color to the editor color scale.
 *
 */
static void ConvColorV(float *color) {
    color[0] /= 128.0f;
    color[1] /= 128.0f;
    color[2] /= 128.0f;
}

/**
 *
 * Finds the paint item color index matching an editor color.
 *
 */
static int emSearchColorCode(float *color) {
    float penki_color[4];
    int   i;

    for (i = 0; i < 8; i++) {
        GetPenkiColor(i, penki_color);
        ConvColorV(penki_color);

        if (EditPartsCmpColor(color, penki_color) != 0) {
            return i;
        }
    }

    return -1;
}

/**
 *
 * Returns the paint item number for a valid color index.
 *
 */
static int emGetPenkiItemNo(int slot) {
    if ((slot < 0) || (slot >= 8)) {
        return -1;
    }

    return GetPenkiItemNo(slot);
}

/**
 *
 * Returns the paint item number matching an editor color.
 *
 */
static int emGetPenkiItemNo(float *color) {
    return emGetPenkiItemNo(emSearchColorCode(color));
}

/**
 *
 * Resets the editor system message timer and selection.
 *
 */
static void IntiSystemMes() {
    SysMesCnt = 0;
    SysMesNo = -1;
}

/**
 *
 * Opens a timed editor system message in the scene.
 *
 */
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

/**
 *
 * Closes the scene editor system message window.
 *
 */
static void SystemMesClose(CScene *scene) {
    ClsMes *message = scene->GetMessage(1);

    if (message != NULL) {
        if (message->select < 0) {
            message->cursor_time = 0;
        }

        message->select = -1;
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
        message->fukidashi_pos = 0;
    }
}

/**
 *
 * Counts down and closes the active editor system message.
 *
 */
static void SystemMesStep(CScene *scene) {
    if (SysMesNo >= 0) {
        if (SysMesCnt < 0) {
            SystemMesClose(scene);
            SysMesCnt = 0;
        }

        SysMesCnt = SysMesCnt - 1;
    }
}

/**
 *
 * Starts placement animation and visual effects for an edit part.
 *
 */
static int EditStartPlaceEffect(CEditParts *parts, float *pos) {
    int             anime_result;
    CEditPartsInfo *info;

    if (parts == NULL || (info = parts->info) == NULL) {
        return 0;
    }

    anime_result = EditSetPlaceAnime(info->place_anime, (CMapParts *) parts);
    anime_result |= EditPlaceEffect(parts, pos);
    return anime_result;
}

/**
 *
 * Checks whether the placement animation and effect have ended.
 *
 */
static int EditEndPlaceEffect() {
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
void LoadEditCursor(mgCMemory *memory, int block) {
    mgCTextureManager *textures = &mgTexManager;
    if (LoadFile2(at_1067__3, read_buffer, NULL, 0) != 0) {
        u_int *pack = (u_int *)read_buffer;
        u_int size;
        u_int *image = GetPackFile(pack, (char *)at_1068__3, (int *)&size);
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
        CCharacter2 *paint_chr;
        paint_chr = new ((u_long128 *)memory->Alloc(0x68)) CCharacter2;
        PaintCurChr = paint_chr;
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
        CCharacter2 *remove_chr;
        remove_chr = new ((u_long128 *)memory->Alloc(0x68)) CCharacter2;
        RemoveCurChr = remove_chr;
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
        CCharacter2 *shovel_chr;
        shovel_chr = new ((u_long128 *)memory->Alloc(0x68)) CCharacter2;
        ShovelCurChr = shovel_chr;
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
            unit_attr.no_light = 1;
            unit_attr.color[1] = 64.0f;
            unit_attr.color[2] = 64.0f;
            unit_attr.color[3] = 32.0f;
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

int GetSelPartsInfoID() {
    return PartsInfoID;
}

/**
 *
 * Clears the river, cursor lock, and mountain removal counters.
 *
 */
static void ClearEditStepCnt() {
    PlaceRiverCnt = 0;
    CursorLockCnt = 0;
    RemoveMtnCnt = 0;
}

void ClearUndoFlag() {
    UndoData.info_id = -1;
    UndoData.parts_no = -1;
}

void ClearEditFlag() {
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

void InitEditFlag() {
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
    CCharacter2     *player = scene->GetCharacter(scene->player_chara);
    mgCCameraFollow *angle_camera;
    mgCCameraFollow *follow_camera;
    float            angle;

    if (player != NULL) {
        player->GetPosition(eCurPos);
        *(u_long128 *) ePartsCurNowPos = *(u_long128 *) eCurPos;
        *(u_long128 *) ePartsCurPos = *(u_long128 *) eCurPos;
        *(u_long128 *) eCurNowPos = *(u_long128 *) eCurPos;
    }

    EditModeNo = 2;
    ClearEditFlag();
    IntiSystemMes();
    angle_camera = static_cast<mgCCameraFollow *>(scene->GetCamera(scene->before_camera));
    angle = 0.0f;

    if (angle_camera != NULL) {
        angle = angle_camera->GetAngle();
    }

    follow_camera = static_cast<mgCCameraFollow *>(scene->GetCamera(scene->active_camera));

    if (follow_camera != NULL) {
        follow_camera->FollowOn();
        follow_camera->SetFollowOffset(0.0f, 0.0f, 0.0f);
        follow_camera->SetFollow(eCurPos[0], eCurPos[1], eCurPos[2]);
        follow_camera->SetHeight(100.0f);
        follow_camera->SetDistance(300.0f);
        follow_camera->SetAngle(angle);
        follow_camera->Step(-1);
    }

    EditInitPlaceEffect();
    InitBalanceDraw(scene);
    return 1;
}

void EndEditMode(CScene *scene, float *cursor_pos) {
    float        pos[4];
    CEditMap    *map = static_cast<CEditMap *>(scene->GetMap(scene->active_map));
    CCharacter2 *player = scene->GetCharacter(scene->player_chara);

    if (player != NULL) {
        *(u_long128 *) pos = *(u_long128 *) cursor_pos;
        pos[1] += 0.01f;
        player->SetPosition(pos);
    }

    SystemMesClose(scene);

    if (map != NULL) {
        map->focus_parts = -1;
    }

    EditInitPlaceEffect();
    EditInitPlaceAnime();
}
int StartEditModeFromMenu(CScene *scene, int mode, int *params) {
    scene->GetMap(scene->active_map);
    EditModeNo = mode;
    PartsInfoID = -1;
    RemainPartsNum = 0;
    ClearEditStepCnt();
    if (EditModeNo == EDIT_MODE_PLACE || EditModeNo == EDIT_MODE_REMOVE || EditModeNo == EDIT_MODE_PAINT ||
        EditModeNo == EDIT_MODE_REPAINT) {
        ClearEditFlag();
        int color[4] = {params[0], params[1], params[2], params[3]};
        int shade[3] = {params[0], params[1], params[2]};
        if (EditModeNo == EDIT_MODE_REPAINT) {
            color[0] = -1;
            color[1] = -1;
            color[2] = -1;
            color[3] = -1;
            shade[0] = 0xFF;
            shade[1] = 0xFF;
            shade[2] = 0xFF;
        }
        if (EditModeNo == EDIT_MODE_PAINT || EditModeNo == EDIT_MODE_REPAINT) {
            if (PaintCursor2 != NULL && PaintCursor2->attr != NULL) {
                float *c;
                PaintCursor2->attr->color[0] = shade[0];
                c = PaintCursor2->attr->color;
                c += 1;
                *c = shade[1];
                c = PaintCursor2->attr->color;
                c += 2;
                *c = shade[2];
                PaintColor[0] = ConvColor(color[0]);
                PaintColor[1] = ConvColor(color[1]);
                PaintColor[2] = ConvColor(color[2]);
                PaintItemNo = color[3];
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

/**
 *
 * Returns the current editor undo record.
 *
 */
static void *GetUndoData() {
    return &UndoData;
}

/**
 *
 * Reports whether an editor undo record is available.
 *
 */
static int UndoEnable() {
    return *(int *) GetUndoData() >= 0;
}

/**
 *
 * Removes the last placed part and restores its placement state.
 *
 */
static void UndoPlaceParts(CScene *scene) {
    UNDO_DATA      *undo;
    CEditMap       *map = (CEditMap *) scene->GetMap(scene->active_map);
    CEditPartsInfo *info;
    int             remaining;
    int             built;

    if (map != NULL) {
        map->focus_parts = -1;
    }

    PlacePartsFlag = 0;

    if (EditModeNo == 2 || EditModeNo == 2) {
        undo = (UNDO_DATA *) GetUndoData();

        if (undo->info_id >= 0) {
            RemoveEditParts(scene, undo->parts_no, (float *) &undo->pos);
            PartsInfoID = undo->info_id;
            info = map->GetePartsInfoAtID(PartsInfoID);

            if (info != NULL) {
                remaining = info->max_num;
                remaining -= map->GetePlacePartsAtInfoID(PartsInfoID, NULL, 0);
                built = GetSaveData()->GetBuildPartsNum(PartsInfoID);

                if (built < remaining) {
                    remaining = built;
                }

                RemainPartsNum = remaining;
                EditInitPlaceAnime();
                EditInitPlaceEffect();
                *(u_long128 *) eCurPos = *(u_long128 *) &undo->pos;
                eCurRot = map->ConvEditAngle(undo->rot[1]);
            }

            undo->info_id = -1;
            undo->parts_no = -1;
        }
    }
}

/**
 *
 * Stores a placed part and its transform in the editor undo record.
 *
 */
static void StackUndoData(UNDO_DATA *data) {
    UndoData.info_id = data->info_id;
    UndoData.parts_no = data->parts_no;
    *(mgVec4 *) UndoData.pos = *(mgVec4 *) data->pos;
    *(mgVec4 *) UndoData.rot = *(mgVec4 *) data->rot;
}

void StartEditPutWall(CEditParts::WallInfo *wall) {
    mgZeroVector(WallPutPos);
    *(mgVec4 *) WallInfo.plane = *(mgVec4 *) wall->plane;
    *(mgVec4 *) WallInfo.center = *(mgVec4 *) wall->center;
    WallInfo.box = wall->box;
}

int PlaceEditParts(CEditMap *map, float *pos, float *rot, EP_PLACE_INFO *place_info) {
    UNDO_DATA       undo;
    CEditPartsInfo *river_info = map->GetePartsInfoAtID(PartsInfoID);
    CEditParts     *placed;
    int             success;
    int             build_no;

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
        placed = (CEditParts *) map->PlaceEditParts(build_no, place_info, pos, rot, NULL);

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
        map->GroundBalance(1);
        map->UpdateHouse();
        undo.info_id = PartsInfoID;
        *(u_long128 *) &undo.pos = *(u_long128 *) pos;
        *(u_long128 *) &undo.rot = *(u_long128 *) rot;
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
    *(u_long128 *) PlaceRiverPos = *(u_long128 *) pos;
    CursorLockCnt = 5;

    if (ShovelCurChr != NULL) {
        ShovelCurChr->SetMotion("\x8c\x40\x82\xe8", 6);
    }
}

int PlaceRiverStep(CEditMap *map) {
    float rotation[4];

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
            float color[4] = {128.0f, 128.0f, 128.0f, 128.0f};
            EditPaintEffect(NULL, PlaceRiverPos, color, 1);
        }
    }

    if (PlaceRiverCnt <= 0) {
        PlaceRiverCnt = 0;
    }

    return 0;
}

int NowPlaceRiver() {
    return PlaceRiverCnt > 0;
}

void RemoveMtnStart(CEditMap *map, float *pos, float *cursor_pos) {
    RemoveMtnCnt = 0x12;
    *(u_long128 *) RemoveMtnPos = *(u_long128 *) pos;
    *(u_long128 *) RemoveMtnCurPos = *(u_long128 *) cursor_pos;
    CursorLockCnt = 5;

    if (RemoveCurChr != NULL) {
        RemoveCurChr->ResetMotion();
        RemoveCurChr->SetMotion("\x82\xa9\x82\xbd\x82\xc3\x82\xaf", 6);
    }
}

int RemoveMtnStep(CScene *scene) {
    CEditMap *edit_map;
    int       parts_index;

    if (RemoveMtnCnt <= 0) {
        return 0;
    }

    edit_map = (CEditMap *) scene->GetMap(scene->active_map);
    RemoveMtnCnt -= 1;

    if (RemoveMtnCnt >= 3) {
        CursorLockCnt = 3;
    }

    *(u_long128 *) eCurPos = *(u_long128 *) RemoveMtnCurPos;
    *(u_long128 *) eCurPos = *(u_long128 *) RemoveMtnCurPos;

    if (RemoveMtnCnt == 3) {
        parts_index = edit_map->GetePlaceParts(RemoveMtnPos);
        EditSetPlaceAnime(3, (CMapParts *) edit_map->GetePlaceParts(parts_index));

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
    int                  paint_num[8];
    float                color[8][4];
    CEditMap            *map = (CEditMap *) scene->GetMap(scene->active_map);
    int                  i;
    int                  j;
    int                  k;
    int                  l;
    int                  count;
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
        map->GroundBalance(1);

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
    *(u_long128 *) removed_position = *(u_long128 *) position;
    int removed = map->RemoveEditParts(parts_no, eCurPos, NULL);

    if (removed != 0) {
        sndSePlay(GetSystemSndID(), 20, 0);
        CEffectScriptMan *effects = scene->GetEffect(0);

        if (effects != NULL) {
            float effect_vector[4] = {8.0f, 8.0f, 8.0f, 0.0f};
            float effect_position[4];
            *(u_long128 *) effect_position = *(u_long128 *) removed_position;
            effects->CreateEffSpt("\x8d\xbb\x89\x8c\x32", -1, -1);
            effects->SetScriptVect1(effect_position, -1, -1);
            effects->SetScriptVect2(effect_vector, -1, -1);
            *(u_long128 *) effect_position = *(u_long128 *) removed_position;
            effect_position[0] += 50.0f;
            effects->CreateEffSpt("\x8d\xbb\x89\x8c\x32", -1, -1);
            effects->SetScriptVect1(effect_position, -1, -1);
            effects->SetScriptVect2(effect_vector, -1, -1);
            *(u_long128 *) effect_position = *(u_long128 *) removed_position;
            effect_position[0] -= 24.0f;
            effect_position[2] -= 30.0f;
            effects->CreateEffSpt("\x8d\xbb\x89\x8c\x32", -1, -1);
            effects->SetScriptVect1(effect_position, -1, -1);
            effects->SetScriptVect2(effect_vector, -1, -1);
            *(u_long128 *) effect_position = *(u_long128 *) removed_position;
            effect_position[0] -= 36.0f;
            effect_position[2] += 40.0f;
            effects->CreateEffSpt("\x8d\xbb\x89\x8c\x32", -1, -1);
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
    float       position[4];
    float       effect_color[4];
    CEditParts *part = map->GetePlaceParts(parts_no);

    if (PaintCurChr != NULL) {
        sceVu0ScaleVector(effect_color, color, 128.0f);
        PaintCurChr->GetPosition(position);
        PaintCurChr->SetMotion("\x93\x68\x82\xe8", 6);
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

/**
 *
 * Checks the allowed placement altitude relative to the map ground.
 *
 */
static int CheckPlaceAlt(int map_no, CEditMap *map, float *position, int parts_no, float *altitude) {
    float      height = position[1];
    float      ground_position[4];
    CMapParts *ground;
    int        index;

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

/**
 *
 * Returns the maximum georama map height for a map kind.
 *
 */
static float GetGeoMapLimitHeight(int map_kind) {
    if (map_kind == 0) {
        return 700.0f;
    }

    if (map_kind == 1) {
        return 900.0f;
    }

    if (map_kind == 3) {
        return 700.0f;
    }

    if (map_kind == 4) {
        return 700.0f;
    }

    return -1.0f;
}

/**
 *
 * Part attributes that control cursor placement, snapping and help.
 *
 */
enum EditCursorAttribute {
    EDIT_CURSOR_ATTR_NO_REMOVE_FOCUS = 0x1, /**< Excludes a part from removal focus. */
    EDIT_CURSOR_ATTR_NO_PREVIEW = 0x2,     /**< Suppresses the selected placement preview. */
    EDIT_CURSOR_ATTR_QUARTER_TURN = 0x8,   /**< Restricts part rotation to quarter turns. */
    EDIT_CURSOR_ATTR_MAGNET_HELP = 0x20,   /**< Shows the magnet toggle in placement help. */
    EDIT_CURSOR_ATTR_LINE = 0x100,         /**< Snaps a line part only while the cursor is still. */
    EDIT_CURSOR_ATTR_WALL = 0x200,         /**< Places the part on a selected wall plane. */
    EDIT_CURSOR_ATTR_ANY_HEIGHT = 0x10000, /**< Bypasses the placement altitude limit. */
};

/**
 *
 * System messages for rejected Georama placement and paint requests.
 *
 */
enum EditCursorSystemMessage {
    EDIT_SYSTEM_MES_PAINT_SHORTAGE = 0x3FC, /**< The selected paint is insufficient. */
    EDIT_SYSTEM_MES_PLACE_BLOCKED = 0x3FD,  /**< The placement query reports a blocked part. */
};

/**
 *
 * Definition IDs used by the completion-part placement interaction.
 *
 */
enum EditCompletionPart {
    EDIT_COMPLETION_BASE = 0x4C, /**< Existing part removed by the completion operation. */
    EDIT_COMPLETION_PART = 0x55, /**< Selected part that completes the existing base. */
};

/**
 *
 * Paint target selecting every segment of a fence.
 *
 */
enum EditPaintTarget {
    EDIT_PAINT_ALL_FENCE = 99, /**< Paints the entire fence rather than one surface. */
};

/**
 *
 * Capacities of the active-map list and collision polygon buffer.
 *
 */
enum EditCursorCapacity {
    EDIT_CURSOR_MAP_MAX = 8,      /**< Active maps considered by the ground query. */
    EDIT_CURSOR_POLY_MAX = 0x800, /**< Collision polygons held by the cursor queries. */
};

void EditMode(CScene *scene) {
    CPadControl     *pad;
    int              key_right;
    int              key_left;
    int              key_up;
    int              key_down;
    u32              attr;
    int              poly_rest;
    CEditMap        *map;
    mgCCameraFollow *camera;

    CCPoly *next_poly;
    int     i;
    int     moving;
    int     river;
    int     any_height;
    int     map_count;
    int     map_no;
    char   *edit_name;
    int     wall_parts;
    map = static_cast<CEditMap *>(scene->GetMap(scene->active_map));
    if (map != NULL && strcmp(map->Iam(), "CEditMap") == 0 && map != NULL) {
        pad = &PadCtrl;
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
        camera = static_cast<mgCCameraFollow *>(scene->GetCamera(scene->active_camera));
        if (camera != NULL) {
            float old_pos[4];
            *(u_long128 *) old_pos = *(u_long128 *) eCurPos;
            float angle = camera->GetAngle();
            float stick_x = 0.0f;
            if (pad != NULL) {
                stick_x = pad->Analog(PAD_ANALOG_LEFT_X);
            }
            float stick_y = 0.0f;
            if (pad != NULL) {
                stick_y = pad->Analog(PAD_ANALOG_LEFT_Y);
            }
            float move_x = stick_x * cosf(angle) + stick_y * sinf(angle);
            float move_z = -stick_x * sinf(angle) + stick_y * cosf(angle);
            move_x *= 10.0f;
            move_z *= 10.0f;
            if (DebugFlag != 0) {
                if (GamePad__2.On(PAD_L3) || (GamePad__2.On(PAD_SQUARE) && EditModeNo != EDIT_MODE_PLACE)) {
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
            key_right = 0;
            key_left = 0;
            key_up = 0;
            key_down = 0;
            if (pad != NULL) {
                key_right = pad->Btn(PAD_BTN_RIGHT);
                key_left = pad->Btn(PAD_BTN_LEFT);
                key_up = pad->Btn(PAD_BTN_UP);
                key_down = pad->Btn(PAD_BTN_DOWN);
            }
            if (key_right || key_left || key_up || key_down) {
                map->GetEditPos(eCurPos, eCurPos);
                float axis_cos;
                float axis_sin;
                stick_x = stick_y = 0.0f;
                if (key_up) {
                    stick_y = -1.0f;
                }
                if (key_right) {
                    stick_x = 1.0f;
                }
                if (key_down) {
                    stick_y = 1.0f;
                }
                if (key_left) {
                    stick_x = -1.0f;
                }
                axis_sin = 0.0f;
                axis_cos = 1.0f;
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
                move_x = stick_x * axis_cos + stick_y * axis_sin;
                move_z = -stick_x * axis_sin + stick_y * axis_cos;
            }
            if (pad != NULL && pad->Btn(PAD_BTN_CANCEL)) {
                UndoPlaceParts(scene);
            }
            float target[4];
            *(u_long128 *) target = *(u_long128 *) ePartsCurNowPos;
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
                int total = map->GetTotalPolyn(&polyn, &draw_mem);
                if (total + info->polyn[0] > max_polyn || draw_mem + info->polyn[2] > max_draw_mem) {
                    RemainPartsNum = 0;
                    PartsInfoID = -1;
                    info = NULL;
                    PlacePartsFlag = 0;
                }
            }
            edit_name = NULL;
            int turn_step = 1;
            attr = 0;
            if (info != NULL) {
                attr = info->attr;
            }
            if ((info != NULL && (attr & EDIT_CURSOR_ATTR_QUARTER_TURN)) || (MagnetPartsFlag != 0 && !(attr & EDIT_CURSOR_ATTR_LINE))) {
                turn_step = EDIT_ANGLE_90;
            }
            river = (attr & EDIT_PARTS_ATR_RIVER) != 0;
            any_height = (attr & EDIT_CURSOR_ATTR_ANY_HEIGHT) != 0;
            if (pad != NULL && pad->Btn(PAD_BTN_EDIT_TURN_DECREASE)) {
                eCurRot -= turn_step;
            }
            if (pad != NULL && pad->Btn(PAD_BTN_EDIT_TURN_INCREASE)) {
                eCurRot += turn_step;
            }
            eCurRot = map->AngleLimit(eCurRot);
            if (info != NULL && (info->attr & EDIT_CURSOR_ATTR_QUARTER_TURN)) {
                eCurRot = map->GetEditAngle90(eCurRot);
            }
            wall_parts = attr & EDIT_CURSOR_ATTR_WALL;
            if (wall_parts == 0 || PutSideMode == EDIT_PUT_SIDE_SELECT) {
                eCurPos[0] += move_x;
                eCurPos[2] += move_z;
            }
            if (wall_parts != 0 && pad != NULL) {
                if (PutSideMode == EDIT_PUT_SIDE_OFF) {
                    PutSideMode = EDIT_PUT_SIDE_SELECT;
                }
                if (PutSideMode == EDIT_PUT_SIDE_MOVE) {
                    WallPutPos[0] += 2.0f * pad->Analog(PAD_ANALOG_LEFT_X);
                    WallPutPos[1] -= 2.0f * pad->Analog(PAD_ANALOG_LEFT_Y);
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
            CMap *maps[EDIT_CURSOR_MAP_MAX];
            map_count = scene->GetActiveMap(maps, EDIT_CURSOR_MAP_MAX);
            eCurPos[1] = 0.0f;
            mgVu0FBOX box;
            float new_pos[4];
            float ground[4];
            float start_pos[4];
            float move[4];
            CCPoly polys[EDIT_CURSOR_POLY_MAX];
            MoveCheckInfo move_info;
            *(u_long128 *) box.max = *(u_long128 *) eCurPos;
            *(u_long128 *) box.min = *(u_long128 *) eCurPos;
            *(u_long128 *) new_pos = *(u_long128 *) eCurPos;
            *(u_long128 *) start_pos = *(u_long128 *) old_pos;
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
            poly_rest = EDIT_CURSOR_POLY_MAX;
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
                if (edit_name == NULL || (info->attr & EDIT_CURSOR_ATTR_NO_PREVIEW)) {
                    edit_name = NULL;
                    PartsInfoID = -1;
                } else {
                    target[1] += 0.5f * info->GetPartsHeight();
                    info->GetPartsMaxWidth();
                }
            }
            if (pad != NULL) {
                eCameraDist += 15.0f * pad->Analog(PAD_ANALOG_RIGHT_Y);
                if (eCameraDist < 400.0f) {
                    eCameraDist = 400.0f;
                }
                if (!(eCameraDist <= 800.0f)) {
                    eCameraDist = 800.0f;
                }
                camera->SetFollowOffset(0.0f, 0.0f, 0.0f);
                camera->SetFollow(target[0], target[1], target[2]);
                if (pad->Btn(PAD_BTN_R1_HELD)) {
                    camera->AddAngle(-0.1f);
                }
                if (pad->Btn(PAD_BTN_L1_HELD)) {
                    camera->AddAngle(0.1f);
                }
                camera->AddAngle(0.1f * -pad->Analog(PAD_ANALOG_RIGHT_X));
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
            if (CheckHit(polys, GetGeoCheckCamCol(map, box, polys, EDIT_CURSOR_POLY_MAX), camera_ref, camera_pos, camera_hit, 1, 0) >= 0) {
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
            *(u_long128 *) ePartsCurPos = *(u_long128 *) eCurPos;
            ePartsCurRot[1] = map->GetEditAngle(eCurRot);
            poly_count = 0;
            next_poly = polys;
            *(u_long128 *) box.max = *(u_long128 *) eCurPos;
            *(u_long128 *) box.min = *(u_long128 *) eCurPos;
            *(u_long128 *) new_pos = *(u_long128 *) eCurPos;
            new_pos[1] = 1000.0f;
            box.max[0] += 10.0f;
            box.max[1] = 10000.0f;
            box.max[2] += 10.0f;
            box.min[0] -= 10.0f;
            box.min[1] = -10000.0f;
            box.min[2] -= 10.0f;
            for (i = 0; i < map_count; i++) {
                int added = maps[i]->GetColPoly(next_poly, box, poly_rest);
                poly_count += added;
                next_poly += added;
                poly_rest -= added;
                if (poly_rest < 0) {
                    break;
                }
            }
            if (CheckHitVertical(polys, poly_count, new_pos, -2000.0f, ground, 1) >= 0) {
                *(u_long128 *) eCurPos = *(u_long128 *) ground;
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
                                    *(u_long128 *) magnet_pos = *(u_long128 *) place_pos;
                                    int was_magnet = MagnetPartsFlag;
                                    magnet_rot = rot[1];
                                    int line_parts = (place_info->attr & EDIT_CURSOR_ATTR_LINE) != 0;
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
                                        sndSePlay(GetSystemSndID(), SYSTEM_SE_MAGNET, 0);
                                    }
                                }
                                if (place_info->attr & EDIT_CURSOR_ATTR_MAGNET_HELP) {
                                    SetHelpMes(EDIT_HELP_PLACE_MAGNET, MagnetEnable, UndoEnable());
                                } else {
                                    SetHelpMes(EDIT_HELP_PLACE, 0, UndoEnable());
                                }
                                EP_PLACE_INFO place;
                                int finish = 0;
                                int finish_no = -1;
                                if (place_info->id == EDIT_COMPLETION_PART) {
                                    float probe[4];
                                    PlacePartsFlag = 0;
                                    *(u_long128 *) probe = *(u_long128 *) eCurPos;
                                    probe[3] = 10.0f;
                                    finish_no = map->GetePlaceParts(probe);
                                    CEditParts *base = map->GetePlaceParts(finish_no);
                                    if (base != NULL && base->GetInfoID() == EDIT_COMPLETION_BASE) {
                                        finish = 1;
                                        eCurPos[1] = floor_y;
                                        PlacePartsFlag = 1;
                                        ePartsCurPos[1] = floor_y;
                                    }
                                }
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
                                if (pad->Btn(PAD_BTN_EDIT_PLACE) && RemainPartsNum > 0) {
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
                                        OpenSystemMes(scene, EDIT_SYSTEM_MES_PLACE_BLOCKED, 40);
                                    }
                                }
                                if (pad->Btn(PAD_BTN_EDIT_MAGNET)) {
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
                        *(u_long128 *) probe = *(u_long128 *) eCurPos;
                        probe[3] = 10.0f;
                        int parts_no = map->GetePlaceParts(probe);
                        eCurPos[1] = eCurPos[1] > probe[1] ? eCurPos[1] : probe[1];
                        CEditPartsInfo *remove_info = map->GetePartsInfoAtPlaceID(parts_no);
                        if (remove_info != NULL && !(remove_info->attr & EDIT_CURSOR_ATTR_NO_REMOVE_FOCUS)) {
                            map->focus_parts = parts_no;
                        }
                        if (pad->Btn(PAD_BTN_EDIT_REMOVE)) {
                            eCurNowPos[1] = eCurPos[1];
                            RemoveMtnStart(map, probe, eCurPos);
                        }
                    }
                    while (EditModeNo == EDIT_MODE_PAINT || EditModeNo == EDIT_MODE_REPAINT) {
                        float probe[4];
                        *(u_long128 *) probe = *(u_long128 *) eCurPos;
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
                                        if (pad->Btn(PAD_BTN_EDIT_PAINT)) {
                                            color_no = 0;
                                        }
                                    }
                                    if (paint_info->paint_num == 2) {
                                        if (repaint) {
                                            SetHelpMes(EDIT_HELP_REPAINT_HOUSE, 0, 0);
                                        } else {
                                            SetHelpMes(EDIT_HELP_PAINT_HOUSE, paint_info->paint_used, paint_held);
                                        }
                                        if (pad->Btn(PAD_BTN_EDIT_PAINT_ALL)) {
                                            color_no = 0;
                                        }
                                        if (pad->Btn(PAD_BTN_EDIT_PAINT)) {
                                            color_no = 1;
                                        }
                                    }
                                } else {
                                    if (repaint) {
                                        SetHelpMes(EDIT_HELP_REPAINT_FENCE, 0, 0);
                                    } else {
                                        SetHelpMes(EDIT_HELP_PAINT_FENCE, paint_info->paint_used, paint_held);
                                    }
                                    if (pad->Btn(PAD_BTN_EDIT_PAINT)) {
                                        color_no = 0;
                                    }
                                    if (pad->Btn(PAD_BTN_EDIT_PAINT_ALL)) {
                                        color_no = EDIT_PAINT_ALL_FENCE;
                                    }
                                }
                                if (color_no >= 0) {
                                    if (EditModeNo == EDIT_MODE_REPAINT) {
                                        float def_color[4];
                                        float now_color[4];
                                        map->RePaintNum(paint_info->paint_used);
                                        int def_no = color_no;
                                        if (color_no > 2) {
                                            def_no = 0;
                                        }
                                        if (!paint_info->GetDefColor(def_no, def_color)) {
                                            break;
                                        }
                                        parts->GetColor(def_no, now_color);
                                        if (EditPartsCmpColor(now_color, def_color)) {
                                            break;
                                        }
                                        printf("penki item = %d\n", emGetPenkiItemNo(now_color));
                                        if (PaintEditParts(map, parts_no, color_no, def_color)) {
                                            CursorLockCnt = 30;
                                        }
                                    }
                                    if (EditModeNo == EDIT_MODE_PAINT) {
                                        int cost = paint_info->paint_used;
                                        // Availability is checked per surface before charging for the whole fence.
                                        int enough = paint_held >= cost;
                                        if (color_no == EDIT_PAINT_ALL_FENCE) {
                                            cost *= 5;
                                        }
                                        if (DebugFlag != 0 && GamePad__2.On(PAD_R2)) {
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
                                            OpenSystemMes(scene, EDIT_SYSTEM_MES_PAINT_SHORTAGE, 30);
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
                        if (pad->Btn(PAD_BTN_EDIT_PLACE)) {
                            float probe[4];
                            CEditParts::WallInfo wall;
                            *(u_long128 *) probe = *(u_long128 *) eCurPos;
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
                        *(u_long128 *) wall_pos = *(u_long128 *) WallPutPos;
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
                            if (pad->Btn(PAD_BTN_EDIT_PLACE)) {
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
                            if (pad->Btn(PAD_BTN_EDIT_WALL_NEXT)) {
                                SelectWallGroup++;
                            }
                            if (pad->Btn(PAD_BTN_EDIT_WALL_PREVIOUS)) {
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
                if (motion != NULL && strcmp(motion, "\x93\x68\x82\xe8") == 0 && PaintCurChr->CheckMotionEnd()) {
                    PaintCurChr->SetMotion(0, 0);
                }
            }
            if (ShovelCurChr != NULL) {
                ShovelCurChr->Step();
                char *motion = ShovelCurChr->GetNowMotionName();
                if (motion != NULL && strcmp(motion, "\x8c\x40\x82\xe8") == 0 && ShovelCurChr->CheckMotionEnd()) {
                    ShovelCurChr->SetMotion(0, 0);
                }
            }
            if (RemoveCurChr != NULL) {
                RemoveCurChr->Step();
                char *motion = RemoveCurChr->GetNowMotionName();
                if (motion != NULL && strcmp(motion, "\x82\xa9\x82\xbd\x82\xc3\x82\xaf") == 0 && RemoveCurChr->CheckMotionEnd()) {
                    RemoveCurChr->SetMotion(0, 0);
                }
            }
        }
    }
}

void DrawEditCursorParts(CScene *scene) {
    if (EditNowPlaceAnime() == 0 && PutSideMode != 1 && EditModeNo != EDIT_MODE_REMOVE) {
        /**
         *
         * Frame counter for the placement preview's pulsing light.
         *
         */
        static int cnt = 0;

        CEditMap *map = (CEditMap *) scene->GetMap(scene->active_map);
        float     rotation[4];
        rotation[2] = 0.0f;
        rotation[0] = 0.0f;
        rotation[1] = ePartsCurNowRot[1];
        float ambient[4];
        mgGetAmbient(ambient);
        float pulse = 32.0f * sinf(6.2831855f * (float) cnt / 60.0f);
        cnt++;

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
        int             lighting;

        if (info != NULL) {
            CMapParts *parts = info->parts;

            if (parts != NULL) {
                float position[4];
                *(u_long128 *) position = *(u_long128 *) ePartsCurNowPos;
                lighting = mgActiveLighting(3, 0);
                mgInitActiveLighting();
                mgSetAmbient(ambient);

                if (PreMenuCount < PreMenuMaxCount) {
                    position[1] += 40.0f * (float) PreMenuCount;
                    float scale = 1.0f - (float) (PreMenuCount + 1) / (float) PreMenuMaxCount;

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

void DrawEditCursor(CScene *scene) {
    mgCFrame       *cursor;
    CCharacter2    *chara;
    mgCFrame       *unit;
    CEditPartsInfo *info;
    CEditMap       *map;
    float           position[4];
    float           grid_position[4];
    float           grid_size[4];
    map = (CEditMap *) scene->GetMap(scene->active_map);
    cursor = EditCursor[0];
    chara = NULL;
    *(u_long128 *) position = *(u_long128 *) eCurNowPos;
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
                *(u_long128 *) unit->attr->color = *(u_long128 *) color;
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
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(1, 1, 1, 0x40);
    prim.Vertex(0x100, 0xA, 0);
    prim.Vertex(0x1FF, 0x3C, 0);
    prim.End();
    char  text[0x100];
    char *end = text;

    /**
     *
     * Whether a reference cursor position is saved for the debug distance display.
     *
     */
    static int cnt = 0;

    /**
     *
     * Saved debug cursor position with its 15-degree turn index in the last component.
     *
     */
    static sceVu0FVECTOR pos_save;

    if (GamePad__2.Down(0x200)) {
        if (cnt == 0) {
            *(u_long128 *) pos_save = *(u_long128 *) eCurPos;
            cnt++;
            pos_save[3] = eCurRot;
        } else {
            cnt = 0;
        }
    }

    *end = 0;

    if (cnt == 0) {
        end += sprintf(end, "%7.1f,%7.1f,%7.1f R=%d\n", eCurPos[0], eCurPos[1], eCurPos[2], eCurRot);
    }

    if (cnt == 1) {
        end += sprintf(end, "%7.1f,%7.1f,%7.1f R=%d\n", pos_save[0], pos_save[1], pos_save[2], (int) pos_save[3]);
        end += sprintf(end, "%7.1f,%7.1f,%7.1f R=%d\n", eCurPos[0], eCurPos[1], eCurPos[2], eCurRot);
        end += sprintf(end, "dist = %7.1f,", mgDistVector(pos_save, eCurPos));
        sprintf(end, "dxz = %7.1f,", mgDistVectorXZ(pos_save, eCurPos));
        mgCFrame *marker = EditCursor[0];

        if (marker != NULL) {
            marker->SetPosition(pos_save);
            mgDrawDirect(marker);
        }
    }

    GetDebugFont()->DrawDirect(text, 0x100, 0xA);
}

/**
 *
 * Separators between editor help actions for each supported language.
 *
 */
static const char *space_str[6] = {
    "  ",
    "  ",
    "  ",
    "  ",
    "  ",
    "  ",
};

/**
 *
 * Placement button help for each supported language.
 *
 */
static const char *place_str[6] = {
    "(O):\x94\x7a\x92\x75",
    "(O):put",
    "(O) : placer",
    "(O) : Platzieren",
    "(O):metti",
    "(O):poner",
};

/**
 *
 * Cursor rotation button help for each supported language.
 *
 */
static const char *rotate_str[6] = {
    "[l2][r2]:\x89\xf1\x93\x5d",
    "[l2][r2]:rotate",
    "[l2][r2] : pivoter",
    "[l2][r2] : Drehen",
    "[l2][r2]:ruota",
    "[l2][r2]:rotar",
};

/**
 *
 * Wall-selection button help for each supported language.
 *
 */
static const char *sw_wall_str[6] = {
    "[l2][r2]\x81\x46\x95\xc7\x82\xcc\x90\xd8\x82\xe8\x91\xd6\x82\xa6",
    "[l2][r2]:switch wall",
    "[l2][r2] : changer de mur",
    "[l2][r2] : Wand wechseln",
    "[l2][r2]:cambia muro",
    "[l2][r2]:cambiar de pared",
};

/**
 *
 * Magnet toggle button help for each supported language.
 *
 */
static const char *magnet_str[6] = {
    "(#)\x81\x46\x83\x7d\x83\x4f\x83\x6c\x83\x62\x83\x67",
    "(#):Magnet ",
    "(#) : accoler ",
    "(#) : Magnet ",
    "(#):Magnete ",
    "(#):Im[UNI00e1]n ",
};

/**
 *
 * Magnet disabled and enabled labels for each supported language.
 *
 */
static const char *onoff_str[2][6] = {
    {"OFF", "off", "non", "aus", "off", "desact."},
    {"ON", "on", "oui", "ein", "on", "activ."},
};

/**
 *
 * Removal button help for each supported language.
 *
 */
static const char *remove_str[6] = {
    "(O)\x81\x46\x82\xa9\x82\xbd\x82\xc3\x82\xaf",
    "(O):remove",
    "(O) : enlever",
    "(O) : Entfernen",
    "(O):rimuovi",
    "(O):quitar",
};

/**
 *
 * Wall-part selection help for each supported language.
 *
 */
static const char *sel_wall_str[6] = {
    "(O)\x81\x46\x95\xc7\x82\xc9\x82\xc8\x82\xe9\x83\x70\x81\x5b\x83\x63\x82\xcc\x91\x49\x91\xf0",
    "(O):parts selection",
    "(O) : enlever",
    "(O) : Entfernen",
    "(O):rimuovi",
    "(O):quitar",
};

/**
 *
 * Single-part painting help with its paint cost for each supported language.
 *
 */
static const char *paint_str[6] = {
    "(O)\x81\x46\x90\x46\x82\xf0\x93\x68\x82\xe9(%d)",
    "(O):paint(%d)",
    "(O) : peindre(%d)",
    "(O) : Bemalen(%d)",
    "(O):dipingi(%d)",
    "(O):pintar(%d)",
};

/**
 *
 * Placement undo button help for each supported language.
 *
 */
static const char *undo_str[6] = {
    "(X)\x81\x46\x82\xe2\x82\xe8\x82\xc8\x82\xa8\x82\xb7",
    "(X):Undo",
    "(X) : annuler",
    "(X) : R[UNI00fc]ckg. machen",
    "(X):Annulla",
    "(X):deshacer",
};

/**
 *
 * Roof and wall painting help with their paint costs for each supported language.
 *
 */
static const char *paint_house_str[6] = {
    "(O)\x81\x46\x89\xae\x8d\xaa\x82\xf0\x93\x68\x82\xe9(%d)\x81\x40(#)\x81\x46\x82\xa9\x82\xd7\x82\xf0\x93\x68\x82\xe9(%d)",
    "(O):paint roof(%d) (#):paint wall(%d)",
    "(O) : peindre toit(%d)  (#) : peindre murs(%d)",
    "(O) : Dach bemalen(%d)  (#) : Wand bemalen(%d)",
    "(O):dipingi tetto(%d)  (#):dipingi muro(%d)",
    "(O):pintar tejado(%d)  (#):pintar pared(%d)",
};

/**
 *
 * Individual and whole-fence painting help with their paint costs for each supported language.
 *
 */
static const char *paint_fence_str[6] = {
    "(O)\x81\x46\x90\x46\x82\xf0\x93\x68\x82\xe9(%d)\x81\x40(#)\x81\x46\x88\xea\x8a\x87\x93\x68\x82\xe8(%d)",
    "(O):paint(%d) (#):paint all(%d)",
    "(O) : peindre(%d)  (#) : tout peindre(%d)",
    "(O) : Bemalen(%d)  (#) : Alles bemalen(%d)",
    "(O):dipingi(%d)  (#):dipingi tutto(%d)",
    "(O):pintar(%d)  (#):pintar todo(%d)",
};

/**
 *
 * Available paint count format for each supported language.
 *
 */
static const char *paint_num_str[6] = {
    "\x83\x79\x83\x93\x83\x4c:%d",
    "paint:%d",
    "peinture : %d",
    "Bemalen : %d",
    "vernice:%d",
    "pintar:%d",
};

/**
 *
 * Original-color restoration help for each supported language.
 *
 */
static const char *repaint_str[6] = {
    "(O)\x81\x46\x8c\xb3\x82\xcc\x90\x46\x82\xc9\x96\xdf\x82\xb7",
    "(O):undo color",
    "(O) : annuler couleur",
    "(O) : Farbe zur[UNI00fc]ck",
    "(O):annulla colore",
    "(O):deshacer color",
};

/**
 *
 * Roof and wall original-color restoration help for each supported language.
 *
 */
static const char *repaint_house_str[6] = {
    "(O)\x81\x46\x8c\xb3\x82\xcc\x90\x46\x82\xc9\x96\xdf\x82\xb7\x81\x69\x89\xae\x8d\xaa\x81\x6a\x81\x40(#)\x81\x46\x8c\xb3\x82\xcc\x90\x46\x82\xc9\x96\xdf\x82\xb7\x81\x69\x83\x4a\x83\x78\x81\x6a",
    "(O):undo color (roof)  (#)undo color (wall)",
    "(O) : annuler couleur toit  (#) : annuler couleur murs",
    "(O) : Dachfarbe zur[UNI00fc]ck  (#) : Wandfarbe zur[UNI00fc]ck",
    "(O):annulla colore (tetto)  (#)annulla colore (parete)",
    "(O):deshacer color (tejado)  (#):deshacer color (pared)",
};

/**
 *
 * Individual and whole-fence original-color restoration help for each supported language.
 *
 */
static const char *repaint_fence_str[6] = {
    "(O)\x81\x46\x8c\xb3\x82\xcc\x90\x46\x82\xc9\x96\xdf\x82\xb7\x81\x40(#)\x81\x46\x8c\xb3\x82\xcc\x90\x46\x82\xc9\x96\xdf\x82\xb7\x81\x69\x88\xea\x8a\x87\x81\x6a",
    "(O):undo color\x81\x40(#):undo color (all)",
    "(O) : annuler couleur  (#) : annuler couleur tout",
    "(O) : Farbe zur[UNI00fc]ck  (#) : Farbe zur[UNI00fc]ck (gesamt)",
    "(O):annulla colore  (#):annulla colore (tutto)",
    "(O):deshacer color  (#):deshacer color (todo)",
};

void DrawEditHelpMes() {
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

/**
 *
 * Checks whether the editor cursor lies inside a balance part footprint.
 *
 */
static int CheckFocusBalanceParts(CEditMap *map, int index, float *cursor) {
    float      box[8];
    CMapParts *parts = (CMapParts *) map->balance_parts[index];

    if (parts == NULL) {
        return 0;
    }

    if (parts->GetBoundBox((mgVu0FBOX *) box) == 0) {
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

/**
 *
 * Updates ground balance and its display offsets for the active map.
 *
 */
static void InitBalanceDraw(CScene *scene) {
    CEditMap *map;

    map = (CEditMap *) scene->GetMap(scene->active_map);

    if (map != NULL) {
        map->GroundBalance(0);
    }

    GetBalanceHeight(scene, now_balance_h);
}

/**
 *
 * Calculates clamped ground balance display offsets.
 *
 */
static void GetBalanceHeight(CScene *scene, float *balance) {
    CEditMap *map = (CEditMap *) scene->GetMap(scene->active_map);
    int       num_x = map->balance_weight[1] - map->balance_weight[0];
    int       depth = map->balance_weight[3] - map->balance_weight[2];
    float     abs_width;

    if ((float) num_x < 0.0f) {
        abs_width = -(float) num_x;
    } else {
        abs_width = (float) num_x;
    }

    if (abs_width < 4.0f) {
        num_x = 0;
    }

    float abs_depth;

    if ((float) depth < 0.0f) {
        abs_depth = -(float) depth;
    } else {
        abs_depth = (float) depth;
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
                prim.Begin(MG_PRIM_SPRITE);
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
                prim.Begin(MG_PRIM_SPRITE);
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
                    prim.Begin(MG_PRIM_SPRITE);
                    prim.Texture(eSysTexture);
                    int x = 0x12C;
                    float colors[2][2][4] = {
                        {{90.0f, 20.0f, 10.0f, 48.0f}, {180.0f, 40.0f, 20.0f, 77.0f}},
                        {{30.0f, 60.0f, 90.0f, 48.0f}, {60.0f, 120.0f, 180.0f, 77.0f}},
                    };
                    int balance = map->BalanceCheck();
                    float target[4];
                    GetBalanceHeight(scene, target);
                    float cursor[4];
                    *(u_long128 *)cursor = *(u_long128 *)eCurPos;
                    int focused = 0;
                    for (int i = 0; i < 4; i++) {
                        float (*color)[4] = colors[balance];
                        prim.Color(color[0]);
                        if (!focused && CheckFocusBalanceParts(map, i, cursor)) {
                            prim.Color(color[1]);
                            focused = 1;
                        }
                        float *now = &now_balance_h[i];
                        float height = *now + (target[i] - *now) / 12.0f;
                        *now = height;
                        int height16 = (int)(16.0f * height);
                        int height1 = (int)height;
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

/**
 *
 * Finds the map part used for the walk-to-edit transition check.
 *
 */
static CMapParts *GetGeoCheckPts(CMap *map) {
    if (map != NULL) {
        return map->GetPlaceParts("geo_check");
    }

    return NULL;
}

/**
 *
 * Collects collision polygons from the walk-to-edit check part.
 *
 */
static int GetGeoCheckCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max) {
    if (map == NULL) {
        return 0;
    }

    CMapParts *part = GetGeoCheckPts(map);

    if (part == NULL) {
        return 0;
    }

    part->Show(1);
    int count = part->GetColPoly(polys, box, max);
    part->Show(0);
    return count;
}

/**
 *
 * Collects camera polygons from the walk-to-edit check part.
 *
 */
static int GetGeoCheckCamCol(CMap *map, mgVu0FBOX &box, CCPoly *polys, int max) {
    if (map == NULL) {
        return 0;
    }

    CMapParts *part = GetGeoCheckPts(map);

    if (part == NULL) {
        return 0;
    }

    part->Show(1);
    int count = part->GetCameraPoly(polys, box, max);
    part->Show(0);
    return count;
}

int CheckWalkToEdit(CScene *scene, float *position) {
    float     pos[4];
    float     hit[4];
    mgVu0FBOX box;
    CCPoly    polys[0x80];
    float     hit_normals[0x20][4];
    int       hit_indices[0x20];
    float     normal[4];
    *(u_long128 *) pos = *(u_long128 *) position;
    CMap *map = scene->GetMap(scene->active_map);

    if (map == NULL) {
        return 1;
    }

    if (GetGeoCheckPts(map) == 0) {
        return 1;
    }

    *(u_long128 *) box.max = *(u_long128 *) pos;
    *(u_long128 *) box.min = *(u_long128 *) pos;
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
    float     cursor[4];
    float     ground_hit[4];
    mgVu0FBOX box;
    CCPoly    polys[512];
    float     hit_positions[64][4];
    int       hit_indices[64];
    *(u_long128 *) cursor = *(u_long128 *) eCurPos;
    *(u_long128 *) position = *(u_long128 *) eCurPos;
    CEditMap *map = (CEditMap *) scene->GetMap(scene->active_map);

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

    *(u_long128 *) box.max = *(u_long128 *) eCurPos;
    *(u_long128 *) box.min = *(u_long128 *) eCurPos;
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

    *(u_long128 *) position = *(u_long128 *) ground_hit;

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
