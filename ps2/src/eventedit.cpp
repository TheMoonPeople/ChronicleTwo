#include "common.h"
#include "eventedit.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "scenesnd.hpp"
#include "mg_memory.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "sceneseq.hpp"
#include "mainloop.hpp"
#include "dataread.hpp"
#include "menucommon.hpp"
#include "savedata.hpp"
#include "nd_meswin.hpp"
#include "sound.hpp"
#include "snd_mngr.hpp"
#include "dbg_font.hpp"
#include "character.hpp"
#include "gamepad.hpp"
#include "eventsprite.hpp"
#include "prespr.hpp"
#include <cstdio>
#include <cstring>
#include <cmath>
#include <libvu0.h>
#include <sifdev.h>
extern CRunScript EventScript;
extern EventEditInfo g_info;
extern CCameraPas g_cmr_pas;
extern CCharaPas g_chara_pas;
extern int g_cp_mode;
extern int g_cp_cursor;
extern int g_cp_selno;
extern int g_chara_pas_mode;
extern int g_chara_pas_cursor;
extern int g_chara_pas_selno;
extern char at_1208[];
extern char at_1226__2[];
extern char at_1242__2[];
extern char at_809__2[];
extern char at_810__2[];
extern char at_811__2[];
extern char at_812__2[];
extern char at_813__2[];
extern char at_814__2[];
extern char at_815__2[];
extern char at_816__4[];
extern char at_817__3[];
extern char at_818__3[];
extern char at_819__5[];
extern char at_820__5[];
extern char at_821__4[];
extern char at_822__4[];
extern char at_823__4[];
extern char at_824__4[];
extern char at_825__4[];
extern char at_826__4[];
extern char at_827__4[];
extern char at_828__5[];
extern char at_829__5[];
extern char at_830__6[];
extern char at_831__5[];
extern char at_832__5[];
extern char at_889__2[];
extern char at_890__2[];
extern char at_891__2[];
extern char at_979__4[];
extern char at_1204__2[];
extern char at_1205__2[];
extern char at_1206[];
extern char at_1207[];
extern char at_1222__2[];
extern char at_1223__2[];
extern char at_1224__2[];
extern char at_1225__2[];
extern char at_1382[];
extern char at_1383[];
extern char at_1384[];
extern char at_1385__3[];
extern char at_1386__2[];
extern char at_1387__3[];
extern char at_1388__3[];
extern char at_1389__2[];
extern char at_1390[];
extern char at_1391[];
extern char at_1392[];
extern char at_1393[];
extern char at_1394__2[];
extern char at_1395__3[];
extern char at_1396__2[];
extern char at_1397__2[];
extern char at_1398__3[];
extern char at_1399__2[];
extern char at_1400__3[];
extern char at_1401__2[];
extern char at_1402__2[];
extern char at_1403__2[];
void DrawBox(float (*corners)[4], int r, int g, int b);
void MoveChara(CCharacter2 *chara, mgCCamera *camera, mgCMemory *memory);

// Code (.text)
void OutPutFile(void) {
    char text[0x100];
    float chara_pos[4];
    float chara_rot[4];
    float eye_pos[4];
    float look_pos[4];
    float view_dir[4];
    float flat_dir[4];
    float angle;
    int i;
    int file;
    CCharacter2 *chara;
    mgCCamera *camera;

    file = sceOpen(at_809__2, 0x602);
    if (file < 0) {
        return;
    }
    sprintf(text, at_810__2);
    sceWrite(file, text, strlen(text));
    chara = GetCharacter(g_info.chara_no);
    sprintf(text, at_811__2, g_info.chara_no);
    sceWrite(file, text, strlen(text));
    sprintf(text, at_812__2, g_info.collision);
    sceWrite(file, text, strlen(text));
    chara->GetPosition(chara_pos);
    chara->GetRotation(chara_rot);
    CalcPosWorldCoordGyaku(chara_pos);
    chara_rot[0] -= EdEventInfo.world_coord_rot[0];
    chara_rot[1] -= EdEventInfo.world_coord_rot[1];
    chara_rot[2] -= EdEventInfo.world_coord_rot[2];
    sprintf(text, at_813__2, (double)chara_pos[0], (double)chara_pos[1], (double)chara_pos[2]);
    sceWrite(file, text, strlen(text));
    sprintf(text, at_814__2, (double)chara_rot[0], (double)chara_rot[1], (double)chara_rot[2]);
    sceWrite(file, text, strlen(text));
    sprintf(text, at_815__2);
    sceWrite(file, text, strlen(text));
    camera = GetActiveCamera();
    camera->GetPos(eye_pos);
    camera->GetRef(look_pos);
    sceVu0SubVector(view_dir, look_pos, eye_pos);
    flat_dir[1] = 0.0f;
    flat_dir[0] = view_dir[0];
    flat_dir[2] = view_dir[2];
    flat_dir[3] = 0.0f;
    sceVu0Normalize(flat_dir, flat_dir);
    angle = atan2f(-flat_dir[0], -flat_dir[2]);
    CalcPosWorldCoordGyaku(eye_pos);
    CalcPosWorldCoordGyaku(look_pos);
    sprintf(text, at_816__4, (double)eye_pos[0], (double)eye_pos[1], (double)eye_pos[2]);
    sceWrite(file, text, strlen(text));
    sprintf(text, at_817__3, (double)look_pos[0], (double)look_pos[1], (double)look_pos[2]);
    sceWrite(file, text, strlen(text));
    angle -= EdEventInfo.world_coord_rot[1];
    if (angle > 3.1415927f) {
        angle -= 6.2831855f;
    } else if (angle <= -3.1415927f) {
        angle += 6.2831855f;
    }
    sprintf(text, at_818__3, (double)angle);
    sceWrite(file, text, strlen(text));
    sprintf(text, at_819__5, (double)(eye_pos[1] - look_pos[1]));
    sceWrite(file, text, strlen(text));
    eye_pos[1] = 0.0f;
    look_pos[1] = 0.0f;
    sprintf(text, at_820__5, (double)mgDistVector(eye_pos, look_pos));
    sceWrite(file, text, strlen(text));
    sprintf(text, at_821__4, (double)EdEventInfo.projection);
    sceWrite(file, text, strlen(text));
    sprintf(text, at_822__4);
    sceWrite(file, text, strlen(text));
    sprintf(text, at_823__4, g_cmr_pas.pas_num);
    sceWrite(file, text, strlen(text));
    sceWrite(file, at_824__4, strlen(at_824__4));
    sprintf(text, at_825__4, g_cmr_pas.GetFrame());
    sceWrite(file, text, strlen(text));
    for (i = 0; i < g_cmr_pas.pas_num; i++) {
        g_cmr_pas.GetCameraPas(i, eye_pos, look_pos);
        CalcPosWorldCoordGyaku(eye_pos);
        CalcPosWorldCoordGyaku(look_pos);
        sprintf(text, at_826__4, (double)eye_pos[0], (double)eye_pos[1], (double)eye_pos[2],
                (double)look_pos[0], (double)look_pos[1], (double)look_pos[2]);
        sceWrite(file, text, strlen(text));
    }
    sceWrite(file, at_827__4, strlen(at_827__4));
    sprintf(text, at_828__5);
    sceWrite(file, text, strlen(text));
    sprintf(text, at_823__4, g_chara_pas.pas_num);
    sceWrite(file, text, strlen(text));
    sceWrite(file, at_829__5, strlen(at_829__5));
    sprintf(text, at_830__6, g_chara_pas.GetFrame());
    sceWrite(file, text, strlen(text));
    for (i = 0; i < g_chara_pas.pas_num; i++) {
        g_chara_pas.GetCharaPas(i, chara_pos);
        CalcPosWorldCoordGyaku(chara_pos);
        sprintf(text, at_831__5, (double)chara_pos[0], (double)chara_pos[1], (double)chara_pos[2]);
        sceWrite(file, text, strlen(text));
    }
    sceWrite(file, at_832__5, strlen(at_832__5));
    sceClose(file);
}
void DrawBox(float *max, float *min, int r, int g, int b) {
    float corners[8][4];
    float lo[4];
    float hi[4];

    *(u_long128 *)lo = *(u_long128 *)min;
    *(u_long128 *)hi = *(u_long128 *)max;
    corners[0][0] = lo[0];
    corners[0][1] = lo[1];
    corners[0][2] = lo[2];
    corners[0][3] = 1.0f;
    corners[1][0] = hi[0];
    corners[1][1] = lo[1];
    corners[1][2] = lo[2];
    corners[1][3] = 1.0f;
    corners[2][0] = lo[0];
    corners[2][1] = hi[1];
    corners[2][2] = lo[2];
    corners[2][3] = 1.0f;
    corners[3][0] = hi[0];
    corners[3][1] = hi[1];
    corners[3][2] = lo[2];
    corners[3][3] = 1.0f;
    corners[4][0] = lo[0];
    corners[4][1] = lo[1];
    corners[4][2] = hi[2];
    corners[4][3] = 1.0f;
    corners[5][0] = hi[0];
    corners[5][1] = lo[1];
    corners[5][2] = hi[2];
    corners[5][3] = 1.0f;
    corners[6][0] = lo[0];
    corners[6][1] = hi[1];
    corners[6][2] = hi[2];
    corners[6][3] = 1.0f;
    corners[7][0] = hi[0];
    corners[7][1] = hi[1];
    corners[7][2] = hi[2];
    corners[7][3] = 1.0f;
    DrawBox(corners, r, g, b);
}
void DrawBox(float (*corners)[4], int r, int g, int b) {
    mgCDrawPrim prim;
    int vertex[8][4];
    int i;
    int visible;

    prim.Initialize(0, 0);
    prim.DepthTestEnable(1);
    prim.DepthTest(1);
    prim.AlphaTestEnable(0);
    prim.AlphaBlendEnable(1);
    prim.TextureMapEnable(0);
    prim.Coord(1);
    prim.Begin(1);
    prim.Color(r, g, b, 0x80);
    visible = 1;
    for (i = 0; i < 8; i++) {
        corners[i][3] = 1.0f;
        visible &= mgTransWorldPrim(vertex[i], corners[i]);
    }
    if (visible != 0) {
        prim.Vertex4(vertex[0]);
        prim.Vertex4(vertex[1]);
        prim.Vertex4(vertex[1]);
        prim.Vertex4(vertex[5]);
        prim.Vertex4(vertex[5]);
        prim.Vertex4(vertex[4]);
        prim.Vertex4(vertex[4]);
        prim.Vertex4(vertex[0]);
        prim.Vertex4(vertex[2]);
        prim.Vertex4(vertex[3]);
        prim.Vertex4(vertex[3]);
        prim.Vertex4(vertex[7]);
        prim.Vertex4(vertex[7]);
        prim.Vertex4(vertex[6]);
        prim.Vertex4(vertex[6]);
        prim.Vertex4(vertex[2]);
        prim.Vertex4(vertex[0]);
        prim.Vertex4(vertex[2]);
        prim.Vertex4(vertex[4]);
        prim.Vertex4(vertex[6]);
        prim.Vertex4(vertex[5]);
        prim.Vertex4(vertex[7]);
        prim.Vertex4(vertex[1]);
        prim.Vertex4(vertex[3]);
    }
    prim.End();
}
void VectMatMul(float *out, float *vec, float (*mat)[4]) {
    float result[4];

    result[0] = vec[0] * mat[0][0] + vec[1] * mat[1][0] + vec[2] * mat[2][0];
    result[1] = vec[0] * mat[0][1] + vec[1] * mat[1][1] + vec[2] * mat[2][1];
    result[2] = vec[0] * mat[0][2] + vec[1] * mat[1][2] + vec[2] * mat[2][2];
    result[3] = 1.0f;
    sceVu0CopyVector(out, result);
}
void evLoadDebugFont(int texture_id, mgCMemory *memory) {

    mgCTextureManager *texManager = &mgTexManager;
    int file_size;
    u8 *buffer;

    memory->Align64();
    buffer = (u8 *)memory->stAllocTest(1);
    if (LoadFile2(at_889__2, buffer, &file_size, 0) != 0) {
        memory->Alloc(file_size / 16 + 1);
        texManager->EnterTexture(texture_id, at_890__2, (TM2_head *)buffer, 0, 0);
    }
    JisFont.Initialize();
    JisFont.InitTexture(-1, at_891__2, -1, at_891__2, texture_id, at_890__2);
    JisFont.Clear();
    JisFont.shadow_enable = 1;
}
void MoveCamera(float *pos, float *ref) {
    float dir[4];
    float move[4];
    float dist;
    float angle;
    float right;
    float up;
    float forward;

    sceVu0SubVector(dir, ref, pos);
    dist = sqrtf(dir[0] * dir[0] + dir[2] * dir[2]);
    angle = atan2f(dir[0], dir[2]);
    right = -GamePad__2.GetLXf();
    if (GamePad__2.On(8) != 0) {
        right = 0.04f * dist;
    }
    if (GamePad__2.On(4) != 0) {
        right = 0.04f * -dist;
    }
    up = -GamePad__2.GetRYf();
    forward = -GamePad__2.GetLYf();
    move[0] = right * cosf(angle) + forward * sinf(angle);
    move[1] = up;
    move[2] = forward * cosf(angle) - right * sinf(angle);
    if (GamePad__2.On(0x40) != 0) {
        sceVu0ScaleVector(move, move, 6.0f);
    }
    sceVu0AddVector(pos, pos, move);
    if (GamePad__2.On(0x80) != 0 && GamePad__2.On(0xC) == 0) {
        sceVu0AddVector(ref, ref, move);
    }
}
void MoveCameraRef(float *pos, float *ref) {
    float dir[4];
    float move[4];
    float dist;
    float angle;
    float right;
    float up;
    float forward;

    sceVu0SubVector(dir, ref, pos);
    dist = sqrtf(dir[0] * dir[0] + dir[2] * dir[2]);
    angle = atan2f(dir[0], dir[2]);
    right = -GamePad__2.GetLXf();
    if (GamePad__2.On(8) != 0) {
        right = 0.04f * -dist;
    }
    if (GamePad__2.On(4) != 0) {
        right = 0.04f * dist;
    }
    up = GamePad__2.GetRYf();
    forward = -GamePad__2.GetLYf();
    move[0] = right * cosf(angle) + forward * sinf(angle);
    move[1] = up;
    move[2] = forward * cosf(angle) - right * sinf(angle);
    if (GamePad__2.On(0x40) != 0) {
        sceVu0ScaleVector(move, move, 6.0f);
    }
    sceVu0AddVector(ref, ref, move);
    if (GamePad__2.On(0x80) != 0 && GamePad__2.On(0xC) == 0) {
        sceVu0AddVector(pos, pos, move);
    }
}
void MoveChara(CCharacter2 *chara, mgCCamera *camera, mgCMemory *memory) {
    float position[4];
    float eye[4];
    float look[4];
    float rotation[4];
    float view[4];
    float move[4];
    float next_position[4];
    mgVu0FBOX box;
    CCPoly polys[256];
    float ray_top[4];
    float ray_bottom[4];
    float hit[4];
    float speed;
    float angle;
    float right;
    float up;
    float forward;
    int poly_count;

    if (chara == NULL) {
        return;
    }
    chara->GetPosition(position);
    chara->GetRotation(rotation);
    camera->GetPos(eye);
    camera->GetRef(look);
    sceVu0SubVector(view, look, eye);
    angle = atan2f(view[0], view[2]);
    speed = 1.0f;
    right = -GamePad__2.GetLXf();
    up = -GamePad__2.GetRYf();
    forward = -GamePad__2.GetLYf();
    if (GamePad__2.On(8) != 0) {
        rotation[1] += -0.12f;
    }
    if (GamePad__2.On(4) != 0) {
        rotation[1] += 0.12f;
    }
    if (rotation[1] > 3.1415927f) {
        rotation[1] -= 6.2831855f;
    }
    if (rotation[1] < -3.1415927f) {
        rotation[1] += 6.2831855f;
    }
    move[0] = right * cosf(angle) + forward * sinf(angle);
    move[1] = up;
    move[2] = forward * cosf(angle) - right * sinf(angle);
    if (GamePad__2.On(0x40) != 0) {
        speed = 2.0f;
    }
    sceVu0ScaleVector(move, move, speed);
    if (g_info.collision != 0) {
        sceVu0AddVector(position, position, move);
        box.max[0] = 40.0f + position[0];
        box.min[0] = position[0] - 40.0f;
        box.max[1] = 40.0f + position[1];
        box.min[1] = position[1] - 40.0f;
        box.max[2] = 40.0f + position[2];
        box.min[2] = position[2] - 40.0f;
        poly_count = EventScene->GetColPoly(polys, box, 256);
        sceVu0CopyVector(ray_top, position);
        ray_top[1] += 39.0f;
        ray_top[3] = 1.0f;
        sceVu0CopyVector(ray_bottom, position);
        ray_bottom[1] -= 39.0f;
        ray_bottom[3] = 1.0f;
        if (CheckHit(polys, poly_count, ray_top, ray_bottom, hit, 1, 0) >= 0) {
            position[1] = hit[1];
        } else {
            position[1] -= 70.0f;
        }
        if (position[1] < -500.0f) {
            position[1] = 500.0f;
        }
        sceVu0CopyVector(next_position, position);
        printf(at_979__4, poly_count);
    } else {
        sceVu0AddVector(next_position, position, move);
    }
    chara->SetPosition(next_position);
    chara->SetRotation(rotation);
    if (GamePad__2.Down(0x10) != 0) {
        sceVu0CopyVector(look, position);
        look[1] += 0.7f * chara->body_height;
        camera->SetRef(look);
    }
}
void InitEventEdit(int font_id, mgCMemory *memory) {
    g_info.memory = memory;
    g_info.texb = font_id;
    g_info.disp = 1;
    g_info.active = 0;
    g_info.mode = 0;
    g_info.chara_no = 0;
    g_info.collision = 0;
}
int ChkEventEditStart(void) {
    mgCCamera *camera;

    if (DebugFlag != 1) {
        return 0;
    }
    camera = GetActiveCamera();

    if (GamePad__2.Down(0x200) != 0) {
        g_info.active = 1;
        EdEventInfo.projection = mgGetProjection();
        mgCCamera::StopCamera = 1;
        camera->GetPos(g_info.camera_pos);
        camera->GetRef(g_info.camera_ref);
        evLoadDebugFont(g_info.texb, g_info.memory);
        g_cmr_pas.Initialize();
        g_cmr_pas.SetFrame(200);
        g_cp_cursor = 0;
        g_cp_mode = 0;
        g_cp_selno = 0;
        g_chara_pas.Initialize();
        g_chara_pas.SetFrame(200);
        g_chara_pas_cursor = 0;
        g_chara_pas_mode = 0;
        g_chara_pas_selno = 0;
        GamePad__2.MenuModeOff();
        return 1;
    }
    return 0;
}
int EventEdit(mgCMemory *memory) {
    float cam_pos[4];
    float cam_ref[4];
    float focus_pos[4];
    float path_eye[4];
    float path_look[4];
    float chara_pos[4];
    float chara_rot[4];
    float add_pos[4];
    float set_pos[4];
    mgCCamera *camera;
    CCharacter2 *chara;
    mgCMemory *memoryHeap;
    int frame;
    int index;

    if (DebugFlag != 1) {
        return 0;
    }
    camera = GetActiveCamera();
    if (GamePad__2.Down(0x200) != 0) {
        g_info.active = 0;
        camera->SetPos(g_info.camera_pos);
        camera->SetRef(g_info.camera_ref);
        mgCCamera::StopCamera = 0;
        memoryHeap = g_info.memory;
        memoryHeap->stack_used = 0;
        memoryHeap->lock = 0;
        GamePad__2.MenuModeOff();
        mgTexManager.DeleteBlock(g_info.texb);
    }
    if (g_info.active == 0) {
        return 0;
    }
    mgSetProjection(EdEventInfo.projection);
    camera->GetPos(cam_pos);
    camera->GetRef(cam_ref);
    switch (g_info.mode) {
        case 0:
            if (GamePad__2.On(1) != 0) {
                MoveCameraRef(cam_pos, cam_ref);
            } else {
                MoveCamera(cam_pos, cam_ref);
            }
            camera->SetPos(cam_pos);
            camera->SetRef(cam_ref);
            if (GamePad__2.On(0x2000) != 0) {
                EdEventInfo.projection += 1.0f;
            }
            if (GamePad__2.On(0x8000) != 0) {
                EdEventInfo.projection -= 1.0f;
            }
            if (EdEventInfo.projection < 100.0f) {
                EdEventInfo.projection = 100.0f;
            }
            if (EdEventInfo.projection > 2000.0f) {
                EdEventInfo.projection = 2000.0f;
            }
            break;
        case 1:
            if (GamePad__2.On(2) == 0) {
                chara = GetCharacter(g_info.chara_no);
                if (GamePad__2.Down(0x2000) != 0) {
                    chara = NULL;
                    for (index = g_info.chara_no + 1; index < 0x80; index++) {
                        chara = GetCharacter(index);
                        if (chara != NULL) {
                            break;
                        }
                    }
                    if (chara == NULL) {
                        chara = GetCharacter(g_info.chara_no);
                    } else {
                        g_info.chara_no = index;
                    }
                }
                if (GamePad__2.Down(0x8000) != 0) {
                    chara = NULL;
                    for (index = g_info.chara_no - 1; index >= 0; index--) {
                        chara = GetCharacter(index);
                        if (chara != NULL) {
                            break;
                        }
                    }
                    if (chara == NULL) {
                        chara = GetCharacter(g_info.chara_no);
                    } else {
                        g_info.chara_no = index;
                    }
                }
                if (GamePad__2.Down(0x80) != 0) {
                    g_info.collision = !(bool)g_info.collision;
                }
                if (GamePad__2.Down(0x10) != 0) {
                    chara->GetPosition(focus_pos);
                    sceVu0CopyVector(cam_ref, focus_pos);
                    cam_ref[1] += 0.7f * chara->body_height;
                    camera->SetRef(cam_ref);
                }
                MoveChara(chara, camera, memory);
            } else {
                if (GamePad__2.On(1) != 0) {
                    MoveCameraRef(cam_pos, cam_ref);
                } else {
                    MoveCamera(cam_pos, cam_ref);
                }
                camera->SetPos(cam_pos);
                camera->SetRef(cam_ref);
            }
            break;
        case 2:
            if (GamePad__2.On(1) != 0) {
                MoveCameraRef(cam_pos, cam_ref);
            } else {
                MoveCamera(cam_pos, cam_ref);
            }
            camera->SetPos(cam_pos);
            camera->SetRef(cam_ref);
            switch (g_cp_cursor) {
                case 0:
                    if (GamePad__2.Down(0x8000) != 0) {
                        g_cp_mode -= 1;
                        if ((int)g_cp_mode < 0) {
                            g_cp_mode = 0;
                        }
                    } else if (GamePad__2.Down(0x2000) != 0) {
                        g_cp_mode += 1;
                        if ((int)g_cp_mode >= 4) {
                            g_cp_mode = 3;
                        }
                    }
                    break;
                case 1:
                    if (GamePad__2.Down(0x8000) != 0) {
                        g_cp_selno -= 1;
                        if ((int)g_cp_selno < 0) {
                            g_cp_selno = 0;
                        }
                    } else if (GamePad__2.Down(0x2000) != 0) {
                        g_cp_selno += 1;
                        if ((int)g_cp_selno >= 0x10) {
                            g_cp_selno = 0xF;
                        }
                    }
                    break;
                case 2:
                    frame = g_cmr_pas.GetFrame();
                    if (GamePad__2.On(0x8000) != 0) {
                        frame -= 1;
                        if (frame < 0) {
                            frame = 0;
                        }
                    } else if (GamePad__2.On(0x2000) != 0) {
                        frame += 1;
                    }
                    g_cmr_pas.SetFrame(frame);
                    break;
            }
            if (GamePad__2.Down(0x1000) != 0) {
                g_cp_cursor -= 1;
                if ((int)g_cp_cursor < 0) {
                    g_cp_cursor = 0;
                }
            } else if (GamePad__2.Down(0x4000) != 0) {
                g_cp_cursor += 1;
                if ((int)g_cp_cursor >= 3) {
                    g_cp_cursor = 2;
                }
            }
            if (GamePad__2.Down(2) != 0 && (int)g_cp_selno < g_cmr_pas.pas_num) {
                g_cmr_pas.GetCameraPas(g_cp_selno, path_eye, path_look);
                camera->SetPos(path_eye);
                camera->SetRef(path_look);
            }
            if (GamePad__2.Down(0x20) != 0) {
                camera->GetPos(cam_pos);
                camera->GetRef(cam_ref);
                switch (g_cp_mode) {
                    case 0:
                        g_cmr_pas.AddCameraPas(cam_pos, cam_ref);
                        break;
                    case 1:
                        g_cmr_pas.InsCameraPas(g_cp_selno, cam_pos, cam_ref);
                        break;
                    case 2:
                        g_cmr_pas.SetCameraPas(g_cp_selno, cam_pos, cam_ref);
                        break;
                    case 3:
                        g_cmr_pas.DelCameraPas(g_cp_selno);
                        break;
                }
            }
            if (g_cmr_pas.CheckEnd() == 0) {
                g_cmr_pas.Step(cam_pos, cam_ref);
                camera->SetPos(cam_pos);
                camera->SetRef(cam_ref);
            }
            if (GamePad__2.Down(0x10) != 0) {
                g_cmr_pas.Setup();
                g_cmr_pas.Run();
            }
            break;
        case 3:
            if (GamePad__2.Down(0x10) != 0) {
                g_chara_pas.Setup();
                g_chara_pas.Run();
            }
            if (g_chara_pas.CheckEnd() == 0) {
                chara = GetCharacter(g_info.chara_no);
                chara->GetPosition(chara_pos);
                chara->GetRotation(chara_rot);
                g_chara_pas.Step(chara_pos, &chara_rot[1]);
                chara->SetPosition(chara_pos);
                chara->SetRotation(chara_rot);
            } else {
                if (GamePad__2.On(2) == 0) {
                    MoveChara(GetCharacter(g_info.chara_no), camera, memory);
                } else {
                    if (GamePad__2.On(1) != 0) {
                        MoveCameraRef(cam_pos, cam_ref);
                    } else {
                        MoveCamera(cam_pos, cam_ref);
                    }
                    camera->SetPos(cam_pos);
                    camera->SetRef(cam_ref);
                }
                if (GamePad__2.Down(0x1000) != 0) {
                    g_chara_pas_cursor -= 1;
                    if ((int)g_chara_pas_cursor < 0) {
                        g_chara_pas_cursor = 0;
                    }
                } else if (GamePad__2.Down(0x4000) != 0) {
                    g_chara_pas_cursor += 1;
                    if ((int)g_chara_pas_cursor >= 3) {
                        g_chara_pas_cursor = 2;
                    }
                }
                switch (g_chara_pas_cursor) {
                    case 0:
                        if (GamePad__2.Down(0x8000) != 0) {
                            g_chara_pas_mode -= 1;
                            if ((int)g_chara_pas_mode < 0) {
                                g_chara_pas_mode = 0;
                            }
                        } else if (GamePad__2.Down(0x2000) != 0) {
                            g_chara_pas_mode += 1;
                            if ((int)g_chara_pas_mode >= 4) {
                                g_chara_pas_mode = 3;
                            }
                        }
                        break;
                    case 1:
                        if (GamePad__2.Down(0x8000) != 0) {
                            g_chara_pas_selno -= 1;
                            if ((int)g_chara_pas_selno < 0) {
                                g_chara_pas_selno = 0;
                            }
                        } else if (GamePad__2.Down(0x2000) != 0) {
                            g_chara_pas_selno += 1;
                            if ((int)g_chara_pas_selno >= 0x10) {
                                g_chara_pas_selno = 0xF;
                            }
                        }
                        break;
                    case 2:
                        frame = g_chara_pas.GetFrame();
                        if (GamePad__2.On(0x8000) != 0) {
                            frame -= 1;
                            if (frame < 0) {
                                frame = 0;
                            }
                        } else if (GamePad__2.On(0x2000) != 0) {
                            frame += 1;
                        }
                        g_chara_pas.SetFrame(frame);
                        break;
                }
                if (GamePad__2.Down(0x20) != 0) {
                    chara = GetCharacter(g_info.chara_no);
                    chara->GetPosition(add_pos);
                    switch (g_chara_pas_mode) {
                        case 0:
                            g_chara_pas.AddCharaPas(add_pos);
                            break;
                        case 1:
                            g_chara_pas.InsCharaPas(g_chara_pas_selno, add_pos);
                            break;
                        case 2:
                            g_chara_pas.SetCharaPas(g_chara_pas_selno, add_pos);
                            break;
                        case 3:
                            g_chara_pas.DelCharaPas(g_chara_pas_selno);
                            break;
                    }
                }
                if (GamePad__2.Down(0x80) != 0 &&
                    (int)g_chara_pas_selno < g_chara_pas.pas_num) {
                    g_chara_pas.GetCharaPas(g_chara_pas_selno, set_pos);
                    chara = GetCharacter(g_info.chara_no);
                    chara->SetPosition(set_pos);
                }
            }
            break;
    }
    if (GamePad__2.Down(0x100) != 0) {
        g_info.mode += 1;
        if (g_info.mode > 3) {
            g_info.mode = 0;
        }
    }
    if (GamePad__2.Down2(0x200) != 0) {
        g_info.disp = !(bool)g_info.disp;
    }
    if (GamePad__2.Down(0x800) != 0) {
        OutPutFile();
    }
    return 1;
}
#ifdef NONMATCHING
void DrawEventEdit(void) {
    if (DebugFlag == 1 && g_info.disp != 0) {
        EventMarker.Draw();
        if (g_info.active != 0) {
        JisFont.Clear();
        CPreSprite prim;
        prim.Initialize(NULL, NULL);
        prim.Preset2D();
        prim.TextureMapEnable(0);
        prim.Begin(6);
        prim.Color(0x10, 0x10, 0x10, 0x50);
        prim.Vertex(0xE, 0xE, 0);
        prim.Vertex(0xE2, 0x22, 0);
        if (g_info.disp != 0) {
            prim.Vertex(0xE, 0x24, 0);
            prim.Vertex(0xE2, 0x128, 0);
        }
        prim.End();
        char *mode_names[5] = {at_1204__2, at_1205__2, at_1206, at_1207, at_891__2};
        float eye[4];
        float look[4];
        float view[4];
        float flat[4];
        float focus[4];
        int y = 0x10;
        JisFont.PrintDirect(0x10, y, at_1382, mode_names[g_info.mode]);
        CCharacter2 *chara = GetCharacter(g_info.chara_no);
        mgCCamera *camera = GetActiveCamera();
        camera->GetPos(eye);
        camera->GetRef(look);
        sceVu0SubVector(view, look, eye);
        flat[1] = 0.0f;
        flat[0] = view[0];
        flat[2] = view[2];
        flat[3] = 0.0f;
        sceVu0Normalize(flat, flat);
        float angle = atan2f(-flat[0], -flat[2]);
        sceVu0CopyVector(focus, look);
        CalcPosWorldCoordGyaku(eye);
        CalcPosWorldCoordGyaku(look);
        if (g_info.disp != 0) {
            switch (g_info.mode) {
            case 0: {
                y += 0x16;
                JisFont.PrintDirect(0x10, y, at_1383, EventScene->active_camera);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1384, (double)eye[0]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1385__3, (double)eye[1]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1386__2, (double)eye[2]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1387__3);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1384, (double)look[0]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1385__3, (double)look[1]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1386__2, (double)look[2]);
                angle -= EdEventInfo.world_coord_rot[1];
                if (angle > 3.1415927f) {
                    angle -= 6.2831855f;
                } else if (angle <= -3.1415927f) {
                    angle += 6.2831855f;
                }
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1388__3, (double)angle);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1389__2, (double)(eye[1] - look[1]));
                eye[1] = 0.0f;
                look[1] = 0.0f;
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1390, (double)mgDistVector(eye, look));
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1391, (double)EdEventInfo.projection);
                float remain;
                mgCMemory *stack = EventScene->GetStack(EventScene->stack_no);
                if (stack != NULL) {
                    remain = (float)stack->stGetRest();
                }
                remain = ((16.0f * remain) / 1024.0f) / 1024.0f;
                y += 0x20;
                JisFont.PrintDirect(0x10, y, at_1392, (double)remain);
                break;
            }
            case 1: {
                float chara_pos[4];
                float chara_rot[4];
                y += 0x16;
                JisFont.PrintDirect(0x10, y, at_1393, g_info.chara_no);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1394__2, g_info.collision);
                chara->GetPosition(chara_pos);
                chara->GetRotation(chara_rot);
                CalcPosWorldCoordGyaku(chara_pos);
                chara_rot[0] -= EdEventInfo.world_coord_rot[0];
                chara_rot[1] -= EdEventInfo.world_coord_rot[1];
                chara_rot[2] -= EdEventInfo.world_coord_rot[2];
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1395__3);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1384, (double)chara_pos[0]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1385__3, (double)chara_pos[1]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1386__2, (double)chara_pos[2]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1396__2);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1384, (double)chara_rot[0]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1385__3, (double)chara_rot[1]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1386__2, (double)chara_rot[2]);
                break;
            }
            case 2: {
                char *cam_op_names[5] = {at_1222__2, at_1223__2, at_1224__2, at_1225__2, at_891__2};
                float cam_eye[4];
                float cam_look[4];
                float cam_point_eye[4];
                float cam_point_look[4];
                float cam_box_max[4];
                float cam_box_min[4];
                if (g_cp_cursor == 0) {
                    y += 0x16;
                    JisFont.PrintDirect(0x10, y, at_1397__2, cam_op_names[g_cp_mode]);
                } else {
                    y += 0x16;
                    JisFont.PrintDirect(0x10, y, at_1398__3, cam_op_names[g_cp_mode]);
                }
                if (g_cp_cursor == 1) {
                    y += 0x12;
                    JisFont.PrintDirect(0x10, y, at_1399__2, g_cp_selno);
                } else {
                    y += 0x12;
                    JisFont.PrintDirect(0x10, y, at_1400__3, g_cp_selno);
                }
                g_cmr_pas.GetCameraPas(g_cp_selno, cam_eye, cam_look);
                CalcPosWorldCoordGyaku(cam_eye);
                CalcPosWorldCoordGyaku(cam_look);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1395__3);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1384, (double)cam_eye[0]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1385__3, (double)cam_eye[1]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1386__2, (double)cam_eye[2]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1387__3);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1384, (double)cam_look[0]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1385__3, (double)cam_look[1]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1386__2, (double)cam_look[2]);
                if (g_cp_cursor == 2) {
                    y += 0x12;
                    JisFont.PrintDirect(0x10, y, at_1401__2, g_cmr_pas.GetFrame());
                } else {
                    y += 0x12;
                    JisFont.PrintDirect(0x10, y, at_1402__2, g_cmr_pas.GetFrame());
                }
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1403__2, g_cmr_pas.pas_num);
                for (int i = 0; i < g_cmr_pas.pas_num; i++) {
                    g_cmr_pas.GetCameraPas(i, cam_point_eye, cam_point_look);
                    CalcPosWorldCoordGyaku(cam_point_eye);
                    CalcPosWorldCoordGyaku(cam_point_look);
                    sceVu0CopyVector(cam_box_max, cam_point_eye);
                    sceVu0CopyVector(cam_box_min, cam_point_eye);
                    cam_box_min[0] -= 2.0f;
                    cam_box_min[1] -= 2.0f;
                    cam_box_min[2] -= 2.0f;
                    cam_box_max[0] += 2.0f;
                    cam_box_max[1] += 2.0f;
                    cam_box_max[2] += 2.0f;
                    DrawBox(cam_box_max, cam_box_min, 0x20, 0x20, 0x20);
                    sceVu0CopyVector(cam_box_max, cam_point_look);
                    sceVu0CopyVector(cam_box_min, cam_point_look);
                    cam_box_min[0] -= 2.0f;
                    cam_box_min[1] -= 2.0f;
                    cam_box_min[2] -= 2.0f;
                    cam_box_max[0] += 2.0f;
                    cam_box_max[1] += 2.0f;
                    cam_box_max[2] += 2.0f;
                    DrawBox(cam_box_max, cam_box_min, 0, 0, 0x40);
                }
                break;
            }
            case 3: {
                char *chara_op_names[5] = {at_1222__2, at_1223__2, at_1224__2, at_1225__2, at_891__2};
                float path_pos[4];
                float path_point[4];
                float path_box_max[4];
                float path_box_min[4];
                if (g_chara_pas_cursor == 0) {
                    y += 0x16;
                    JisFont.PrintDirect(0x10, y, at_1397__2, chara_op_names[g_chara_pas_mode]);
                } else {
                    y += 0x16;
                    JisFont.PrintDirect(0x10, y, at_1398__3, chara_op_names[g_chara_pas_mode]);
                }
                if (g_chara_pas_cursor == 1) {
                    y += 0x12;
                    JisFont.PrintDirect(0x10, y, at_1399__2, g_chara_pas_selno);
                } else {
                    y += 0x12;
                    JisFont.PrintDirect(0x10, y, at_1400__3, g_chara_pas_selno);
                }
                g_chara_pas.GetCharaPas(g_chara_pas_selno, path_pos);
                CalcPosWorldCoordGyaku(path_pos);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1395__3);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1384, (double)path_pos[0]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1385__3, (double)path_pos[1]);
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1386__2, (double)path_pos[2]);
                if (g_chara_pas_cursor == 2) {
                    y += 0x12;
                    JisFont.PrintDirect(0x10, y, at_1401__2, g_chara_pas.GetFrame());
                } else {
                    y += 0x12;
                    JisFont.PrintDirect(0x10, y, at_1402__2, g_chara_pas.GetFrame());
                }
                y += 0x12;
                JisFont.PrintDirect(0x10, y, at_1403__2, g_chara_pas.pas_num);
                for (int i = 0; i < g_chara_pas.pas_num; i++) {
                    g_chara_pas.GetCharaPas(i, path_point);
                    CalcPosWorldCoordGyaku(path_point);
                    sceVu0CopyVector(path_box_max, path_point);
                    sceVu0CopyVector(path_box_min, path_point);
                    path_box_min[0] -= 2.0f;
                    path_box_min[1] -= 2.0f;
                    path_box_min[2] -= 2.0f;
                    path_box_max[0] += 2.0f;
                    path_box_max[1] += 2.0f;
                    path_box_max[2] += 2.0f;
                    DrawBox(path_box_max, path_box_min, 0x20, 0x20, 0x20);
                }
                break;
            }
            }
        }
        if (g_info.mode == 1 || g_info.mode == 3) {
            float frame_rot[4];
            chara->GetRotation(frame_rot);
            mgCFrame *frame = chara->CObjectFrame::frame;
            if (frame != NULL) {
                mgVu0FBOX bbox;
                float frame_pos[4];
                float corners[8][4];
                float lo[4];
                float hi[4];
                float matrix[4][4];
                frame->SetRotation(0.0f, 0.0f, 0.0f);
                frame->SetPosition(0.0f, 0.0f, 0.0f);
                chara->GetPosition(frame_pos);
                frame->GetWorldBBox(&bbox);
                *(u_long128 *)lo = *(u_long128 *)bbox.min;
                *(u_long128 *)hi = *(u_long128 *)bbox.max;
                corners[0][0] = lo[0];
                corners[0][1] = lo[1];
                corners[0][2] = lo[2];
                corners[0][3] = 1.0f;
                corners[1][0] = hi[0];
                corners[1][1] = lo[1];
                corners[1][2] = lo[2];
                corners[1][3] = 1.0f;
                corners[2][0] = lo[0];
                corners[2][1] = hi[1];
                corners[2][2] = lo[2];
                corners[2][3] = 1.0f;
                corners[3][0] = hi[0];
                corners[3][1] = hi[1];
                corners[3][2] = lo[2];
                corners[3][3] = 1.0f;
                corners[4][0] = lo[0];
                corners[4][1] = lo[1];
                corners[4][2] = hi[2];
                corners[4][3] = 1.0f;
                corners[5][0] = hi[0];
                corners[5][1] = lo[1];
                corners[5][2] = hi[2];
                corners[5][3] = 1.0f;
                corners[6][0] = lo[0];
                corners[6][1] = hi[1];
                corners[6][2] = hi[2];
                corners[6][3] = 1.0f;
                corners[7][0] = hi[0];
                corners[7][1] = hi[1];
                corners[7][2] = hi[2];
                corners[7][3] = 1.0f;
                mgRotMatrixXYZ(matrix, frame_rot);
                VectMatMul(corners[0], corners[0], matrix);
                VectMatMul(corners[1], corners[1], matrix);
                VectMatMul(corners[2], corners[2], matrix);
                VectMatMul(corners[3], corners[3], matrix);
                VectMatMul(corners[4], corners[4], matrix);
                VectMatMul(corners[5], corners[5], matrix);
                VectMatMul(corners[6], corners[6], matrix);
                VectMatMul(corners[7], corners[7], matrix);
                sceVu0AddVector(corners[0], corners[0], frame_pos);
                sceVu0AddVector(corners[1], corners[1], frame_pos);
                sceVu0AddVector(corners[2], corners[2], frame_pos);
                sceVu0AddVector(corners[3], corners[3], frame_pos);
                sceVu0AddVector(corners[4], corners[4], frame_pos);
                sceVu0AddVector(corners[5], corners[5], frame_pos);
                sceVu0AddVector(corners[6], corners[6], frame_pos);
                sceVu0AddVector(corners[7], corners[7], frame_pos);
                DrawBox(corners, 0x80, 0, 0);
                frame->SetRotation(frame_rot);
            } else {
                float marker_max[4];
                float marker_min[4];
                sceVu0CopyVector(marker_max, focus);
                sceVu0CopyVector(marker_min, focus);
                marker_min[0] -= 2.0f;
                marker_min[1] -= 2.0f;
                marker_min[2] -= 2.0f;
                marker_max[0] += 2.0f;
                marker_max[1] += 2.0f;
                marker_max[2] += 2.0f;
                DrawBox(marker_max, marker_min, 0x80, 0, 0);
            }
        } else {
            float marker2_max[4];
            float marker2_min[4];
            sceVu0CopyVector(marker2_max, focus);
            sceVu0CopyVector(marker2_min, focus);
            marker2_min[0] -= 2.0f;
            marker2_min[1] -= 2.0f;
            marker2_min[2] -= 2.0f;
            marker2_max[0] += 2.0f;
            marker2_max[1] += 2.0f;
            marker2_max[2] += 2.0f;
            DrawBox(marker2_max, marker2_min, 0x80, 0, 0);
        }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/eventedit", DrawEventEdit__Fv);
#endif


// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1208__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1226__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1242__2__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_809__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_810__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_811__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_812__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_813__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_814__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_815__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_816__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_817__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_818__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_819__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_820__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_821__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_822__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_823__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_824__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_825__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_826__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_827__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_828__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_829__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_830__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_831__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_832__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_889__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_890__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_891__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_979__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1204__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1205__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1206__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1207__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1222__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1223__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1224__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1225__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1382__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1383__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1384__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1385__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1386__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1387__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1388__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1389__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1390__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1391__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1392__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1393__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1394__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1395__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1396__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1397__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1398__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1399__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1400__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1401__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1402__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/eventedit", at_1403__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(g_cp_mode, 0x4);
INCLUDE_BSS(g_cp_cursor, 0x4);
INCLUDE_BSS(g_cp_selno, 0x4);
INCLUDE_BSS(g_chara_pas_mode, 0x4);
INCLUDE_BSS(g_chara_pas_cursor, 0x4);
INCLUDE_BSS(g_chara_pas_selno, 0x4);

// Uninitialised data (.bss)
CCameraPas g_cmr_pas;
CCharaPas g_chara_pas;
INCLUDE_BSS(g_info, 0x40);
