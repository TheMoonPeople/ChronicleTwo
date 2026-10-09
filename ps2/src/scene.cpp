#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstddef>
#include <cstdlib>
#include <cstring>

#include "character.hpp"
#include "effscript.hpp"
#include "font.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mapsky.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"

// Code (.text)
float f_rand(float min_value, float max_value) {
    return min_value + (((max_value - min_value) * (float) rand()) / 2147483648.0f);
}

int i_rand(int min, int max) {
    return fptosi(f_rand((float) min, (float) max));
}

void InitVector(float *vector) {
    vector[0] = 0.0f;
    vector[1] = 0.0f;
    vector[2] = 0.0f;
    vector[3] = 1.0f;
}
float RandXYinViewArea(float min_dist, float max_dist, float view_angle, float *x, float *z) {
    float position[4];
    float reference[4];
    float direction[4];
    float heading;
    float distance;
    CScene *scene = GetMainScene();
    mgCCamera *camera = scene->GetCamera(scene->active_camera);

    camera->GetPos(position);
    camera->GetRef(reference);
    sceVu0SubVector(direction, reference, position);
    float facing = atan2f(direction[0], direction[2]);
    float spread = f_rand(view_angle / -2.0f, view_angle / 2.0f);
    heading = spread + facing;
    distance = f_rand(min_dist, max_dist);
    *x = distance * sinf(heading);
    *z = distance * cosf(heading);
    *x += position[0];
    *z += position[2];
    float pitch = -1.0f * camera->GetAngleV();
    pitch += 0.7853982f;
    float height = distance * atanf(pitch);
    height += position[1];
    return height;
}
int CRipple::Birth(float *position) {
    if (active != 0) {
        return 0;
    }

    active = 1;
    sceVu0CopyVector(pos, position);
    pos[1] = 5.0f;
    pos[3] = 1.0f;
    size = f_rand(8.0f, 12.0f);
    count = 0;
    return life = i_rand(20, 40);
}

int CRipple::Step() {
    if (active == 0) {
        return 0;
    }

    count++;

    if (count >= life) {
        active = 0;
        return -1;
    }

    return 1;
}

void CRipple::Draw() {
    float size;
    float alpha;
    size = this->size * (float) count / (float) life;
    alpha = (float) ((life - count) * 40) / (float) life;

    mgCDrawPrim prim;
    float       corner[4][4];
    int         vertex[4][4];
    RECT        rect_a;
    RECT        rect_b;
    int         tex_no;
    float       half;
    int         u;
    int         v;
    int         w;
    int         h;

    prim.Initialize(0, 0);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AlphaTestEnable(1);
    prim.AlphaTest(1, 0);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(0);
    prim.TextureMapEnable(1);
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
    prim.Bilinear(1);
    prim.Coord(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.AlphaTestEnable(1);
    prim.AntiAliasing(1);
    half = size / 2.0f;
    corner[0][0] = pos[0] - half;
    corner[0][1] = pos[1];
    corner[0][2] = pos[2] - half;
    corner[0][3] = 1.0f;
    corner[1][0] = pos[0] + half;
    corner[1][1] = pos[1];
    corner[1][2] = pos[2] - half;
    corner[1][3] = 1.0f;
    corner[2][0] = pos[0] - half;
    corner[2][1] = pos[1];
    corner[2][2] = pos[2] + half;
    corner[2][3] = 1.0f;
    corner[3][0] = pos[0] + half;
    corner[3][1] = pos[1];
    corner[3][2] = pos[2] + half;
    corner[3][3] = 1.0f;

    if (mgTransWorldPrim(vertex[0], corner[0]) != 0 &&
        mgTransWorldPrim(vertex[1], corner[1]) != 0 &&
        mgTransWorldPrim(vertex[2], corner[2]) != 0 &&
        mgTransWorldPrim(vertex[3], corner[3]) != 0) {
        prim.Begin(MG_PRIM_TRIANGLE);

        if (LanguageCode == 0 || LanguageCode == 1) {
            rect_a = GetRectFontTex(GetFontNo("\x81\x9b"), &tex_no);
            u = rect_a.x;
            v = rect_a.y;
            w = rect_a.width;
            h = rect_a.height;
        } else {
            rect_b = GetRectFontTex(GetHalfFontNo('O'), &tex_no);
            u = rect_b.x;
            v = rect_b.y;
            w = rect_b.width;
            h = rect_b.height;
        }

        MySetTex(tex_no, &prim);
        prim.Color(0x80, 0x80, 0x80, (int) alpha);
        prim.TextureCrd(u, v);
        prim.Vertex4(vertex[0]);
        prim.TextureCrd(u, v + h);
        prim.Vertex4(vertex[1]);
        prim.TextureCrd(u + w, v);
        prim.Vertex4(vertex[2]);
        prim.TextureCrd(u, v + h);
        prim.Vertex4(vertex[1]);
        prim.TextureCrd(u + w, v);
        prim.Vertex4(vertex[2]);
        prim.TextureCrd(u + w, v + h);
        prim.Vertex4(vertex[3]);
        prim.End();
    }
}

void CRipple::Init() {
    active = 0;
    InitVector(pos);
    size = 0;
    count = 0;
    life = 0;
}

int CParticle::Birth(float *position, float *velocity) {
    if (active != 0) {
        return 0;
    }

    active = 1;
    accel[0] = 0.0f;
    accel[1] = -0.5f;
    accel[2] = 0.0f;
    accel[3] = 1.0f;
    speed[0] = velocity[0];
    speed[1] = velocity[1];
    speed[2] = velocity[2];
    speed[3] = 1.0f;
    pos[0] = position[0];
    pos[1] = position[1];
    pos[2] = position[2];
    pos[3] = 1.0f;
    base_y = position[1];
    return 1;
}

int CParticle::Step() {
    if (active == 0) {
        return 0;
    }

    if (pos[1] < base_y) {
        active = 0;
        return -1;
    }

    speed[0] += accel[0];
    speed[1] += accel[1];
    speed[2] += accel[2];
    pos[0] += speed[0];
    pos[1] += speed[1];
    pos[2] += speed[2];
    return 1;
}
void CParticle::Draw(void) {
    if (active != 0) {
        mgCDrawPrim prim;
        float camera_pos[4];
        int vertex[4];

        prim.Initialize(0, 0);
        prim.AlphaBlendEnable(1);
        prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
        prim.AlphaTestEnable(1);
        prim.AlphaTest(1, 0);
        prim.DepthTestEnable(0);
        prim.ZMask(MG_Z_MASK_MASKED);
        prim.Bilinear(0);
        prim.TextureMapEnable(0);
        prim.Coord(1);
        prim.Shading(1);
        prim.DepthTestEnable(1);
        prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
        prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
        prim.AntiAliasing(1);
        prim.Begin(MG_PRIM_POINT);
        CScene *scene = GetMainScene();
        mgCCamera *camera = scene->GetCamera(scene->active_camera);
        if (camera != NULL) {
            camera->GetPos(camera_pos);
            float dx = pos[0] - camera_pos[0];
            float dz = pos[2] - camera_pos[2];
            float distance = sqrtf(dx * dx + dz * dz);
            float alpha = 128.0f + -0.42666668f * distance;
            if (!(alpha <= 0.0f)) {
                prim.Color(128, 128, 128, (int)alpha);
                if (mgTransWorldPrim(vertex, pos) != 0) {
                    prim.Vertex4(vertex);
                }
                prim.End();
            }
        }
    }
}
void CParticle::Init() {
    active = 0;
    InitVector(pos);
    InitVector(speed);
    InitVector(accel);
    base_y = 0;
}

void CRainDrop::Birth(int drop_type) {
    float view_angle = 0.7853982f;
    int   i;

    if (active != 0) {
        return;
    }

    active = 1;
    type = drop_type;

    if (1 == type) {
        float far_dist = 800.0f;
        pos[0][1] = RandXYinViewArea(600.0f, far_dist, view_angle, pos[0], &pos[0][2]);
    } else {
        pos[0][1] = RandXYinViewArea(110.0f, 600.0f, view_angle, pos[0], &pos[0][2]);
    }

    pos[0][3] = 1.0f;

    for (i = 1; i < 8; i++) {
        sceVu0CopyVector(pos[i], pos[i - 1]);
    }

    speed[0] = f_rand(-2.0f, 2.0f);
    speed[1] = -15.0f;
    speed[2] = f_rand(-2.0f, 2.0f);
    speed[3] = 1.0f;

    if (type == 1) {
        color[0] = 128;
        color[1] = 128;
        color[2] = 128;
        color[3] = 32;
    } else {
        color[0] = 128;
        color[1] = 128;
        color[2] = 128;
        color[3] = 32;
    }
}

int CRainDrop::Step() {
    int i;

    if (active == 0) {
        return 0;
    }

    for (i = 7; i > 0; i--) {
        sceVu0CopyVector(pos[i], pos[i - 1]);
    }

    sceVu0AddVector(pos[0], pos[0], speed);
    pos[0][3] = 1.0f;

    if (pos[0][1] < -100.0f) {
        return -2;
    }

    if (pos[0][1] < 0.0f) {
        return -1;
    }

    return 1;
}

void CRainDrop::Draw() {
    mgCDrawPrim prim;
    int         vertex_a[4];
    int         vertex_b[4];
    int         i;

    prim.Initialize(0, 0);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AlphaTestEnable(1);
    prim.AlphaTest(1, 0);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(0);
    prim.TextureMapEnable(0);
    prim.Coord(1);
    prim.Shading(1);
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.AntiAliasing(1);
    prim.Begin(MG_PRIM_LINE);

    for (i = 7; i > 0; i -= 2) {
        if (mgTransWorldPrim(vertex_a, pos[i]) != 0 &&
            mgTransWorldPrim(vertex_b, pos[i - 1]) != 0) {
            prim.Color(color[0], color[1], color[2], 8);
            prim.Vertex4(vertex_a);
            prim.Color(color[0], color[1], color[2], 0x10);
            prim.Vertex4(vertex_b);
        }
    }

    prim.End();
}

void CRainDrop::Init() {
    int i;

    active = 0;
    type = 0;

    for (i = 0; i < 8; i++) {
        InitVector(pos[i]);
    }

    InitVector(speed);
    color[0] = 0x80;
    color[1] = 0x80;
    color[2] = 0x80;
    color[3] = 0x80;
}

void CRain::SetCharNo(int chara_no) {
    this->chara_no = chara_no;

    if (chara_no == -1) {
        for (int i = 0; i < 100; i++) {
            particle[i].Init();
        }
    }
}

void CRain::ParticleBirth(float *position, int from_character) {
    sceVu0FVECTOR velocity;

    if (from_character == 1) {
        velocity[0] = 0.0f;
        velocity[1] = f_rand(0.0f, 1.0f);
        velocity[2] = 0.0f;
    } else {
        velocity[0] = f_rand(-1.0f, 1.0f);
        float minimum = 0.0f;
        float maximum = 2.0f;
        velocity[1] = f_rand(minimum, maximum);
        velocity[2] = f_rand(-1.0f, 1.0f);
    }

    for (int index = 0; index < RAIN_PARTICLE_NUM; index++) {
        if (particle[index].Birth(position, velocity) != 0) {
            return;
        }
    }
}

void CRain::Stop() {
    active = 0;
}

void CRain::Start() {
    int   i;
    float view_angle = 0.7853982f;
    float position[4];

    active = 1;

    for (i = 0; i < RAIN_DROP_NUM; i++) {
        drop[i].Birth(RAIN_DROP_NEAR);
    }

    for (i = 0; i < RAIN_FAR_DROP_NUM; i++) {
        far_drop[i].Birth(RAIN_DROP_FAR);
    }

    for (i = 0; i < RAIN_RIPPLE_NUM; i++) {
        ripple[i].active = 0;
        RandXYinViewArea(110.0f, 600.0f, view_angle, &position[0], &position[2]);
        position[1] = 1.0f;
        position[3] = 1.0f;
        ripple[i].Birth(position);
    }
}

void CRain::Step() {
    int   i;
    float landing[4];
    float hand_pos[4];
    float velocity[4];
    float splash_pos[4];

    if (active == 0) {
        return;
    }

    for (i = 0; i < RAIN_DROP_NUM; i++) {
        if (drop[i].Step() == -1) {
            sceVu0CopyVector(landing, drop[i].pos[0]);
            landing[1] = 0.0f;
            landing[3] = 1.0f;
        } else if (drop[i].Step() == -2) {
            drop[i].active = 0;
            drop[i].Birth(RAIN_DROP_NEAR);
        }
    }

    for (i = 0; i < RAIN_FAR_DROP_NUM; i++) {
        if (far_drop[i].Step() == -1) {
            far_drop[i].active = 0;
            far_drop[i].Birth(RAIN_DROP_FAR);
        }
    }

    for (i = 0; i < RAIN_PARTICLE_NUM; i++) {
        if (particle[i].Step() == -1) {
            CCharacter2 *chara = GetMainScene()->GetCharacter(chara_no);

            if (chara == NULL) {
                break;
            }

            mgCFrame *chara_frame = chara->GetFrame();

            if (chara_frame == NULL) {
                break;
            }

            mgCFrame *frame = chara_frame->SearchFrame("hat");

            if (frame == NULL) {
                break;
            }

            frame->GetWorldPosition0(hand_pos);
            float yaw = f_rand(-3.1415927f, 3.1415927f);
            float pitch = f_rand(0.0f, 1.5707964f);
            velocity[1] = 4.0f * sinf(pitch);
            float radius = 4.0f * cosf(pitch);
            velocity[0] = radius * cosf(yaw);
            velocity[2] = radius * sinf(yaw);
            velocity[0] += hand_pos[0];
            velocity[1] += hand_pos[1];
            velocity[2] += hand_pos[2];
            velocity[3] = 1.0f;
            ParticleBirth(velocity, 1);
        }
    }

    for (i = 0; i < RAIN_RIPPLE_NUM; i++) {
        if (ripple[i].Step() == -1) {
            ripple[i].active = 0;
            RandXYinViewArea(110.0f, 600.0f, 0.7853982f, &splash_pos[0], &splash_pos[2]);
            splash_pos[1] = 5.0f;
            splash_pos[3] = 1.0f;
            ripple[i].Birth(splash_pos);
            ParticleBirth(splash_pos, 0);
            ParticleBirth(splash_pos, 0);
            ParticleBirth(splash_pos, 0);
        }
    }
}

void CRain::Init() {
    int i;
    active = 0;
    chara_no = 0;

    for (i = 0; i < 100; i++) {
        drop[i].Init();
    }

    for (i = 0; i < 50; i++) {
        far_drop[i].Init();
    }

    for (i = 0; i < 100; i++) {
        particle[i].Init();
    }

    for (i = 0; i < 200; i++) {
        ripple[i].Init();
    }
}

void DrawScreenRain() {
    mgCDrawPrim prim;
    int         i;
    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AlphaTestEnable(1);
    prim.AlphaTest(1, 0);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(0);
    prim.TextureMapEnable(0);
    prim.AntiAliasing(1);
    prim.Shading(1);
    prim.Begin(MG_PRIM_LINE);

    for (i = 0; i < 50; i++) {
        float length = f_rand(mgScreenHeight / 8, mgScreenHeight / 4);
        float angle = f_rand(-0.0490873866f, 0.0490873866f);
        int   x = i_rand(0, mgScreenWidth);
        int   y = i_rand(0, mgScreenHeight);
        int   end_x = fptosi(length * sinf(angle));
        end_x += x;
        int end_y = fptosi(length * cosf(angle));
        end_y += y;
        prim.Color(128, 128, 128, 0);
        prim.Vertex(x, y, 0);
        prim.Color(128, 128, 128, 32);
        prim.Vertex(end_x, end_y, 0);
    }

    prim.End();
}

void CRain::Draw() {
    int i;

    if (active) {
        for (i = 0; i < 50; i++) {
            far_drop[i].Draw();
        }

        for (i = 0; i < 100; i++) {
            drop[i].Draw();
        }

        for (i = 0; i < 100; i++) {
            particle[i].Draw();
        }

        for (i = 0; i < 100; i++) {
            ripple[i].Draw();
        }

        DrawScreenRain();
    }
}

void CSceneData::Initialize() {
    status = 0;
    name[0] = 0;
    stack = NULL;
    tex_block = -1;
    tex_block_num = 0;
    type = 0;
}

int CSceneCharacter::AssignData(CCharacter2 *character_data, char *character_name) {
    if ((character_name == NULL) || (character_data == NULL)) {
        return 0;
    }

    status = 0;
    chara = character_data;
    strcpy(name, character_name);
    status |= SCENE_DATA_ASSIGNED;
    return 1;
}

void CSceneCharacter::Initialize() {
    chara = 0;
    texb = -1;
    chara_no = -1;
    CSceneData::Initialize();
}

void CSceneMap::Initialize() {
    map = 0;
    CSceneData::Initialize();
}

int CSceneMap::AssignData(CMap *map_data, char *map_name) {
    if ((map_name == NULL) || (map_data == NULL)) {
        return 0;
    }

    Initialize();
    status = 0;
    map = map_data;
    strcpy(name, map_name);
    status |= SCENE_DATA_ASSIGNED;
    return 1;
}

void CSceneMessage::Initialize() {
    mes = 0;
    CSceneData::Initialize();
}

int CSceneMessage::AssignData(ClsMes *message_data, char *message_name) {
    if (message_data == NULL) {
        return 0;
    }

    Initialize();
    status = 0;
    mes = message_data;

    if (message_name == NULL) {
        name[0] = 0;
    } else {
        strcpy(name, message_name);
    }

    status |= SCENE_DATA_ASSIGNED;
    return 1;
}

int CSceneCamera::AssignData(mgCCamera *camera_data, char *camera_name) {
    if (camera_data == NULL) {
        return 0;
    }

    Initialize();
    status = 0;
    camera = camera_data;

    if (camera_name == NULL) {
        name[0] = 0;
    } else {
        strcpy(name, camera_name);
    }

    status |= SCENE_DATA_ASSIGNED;
    return 1;
}

void CSceneCamera::Initialize() {
    camera = 0;
    CSceneData::Initialize();
}

int CSceneSky::AssignData(CMapSky *sky_data, char *sky_name) {
    if (sky_data == NULL) {
        return 0;
    }

    Initialize();
    status = 0;
    sky = sky_data;

    if (sky_name == NULL) {
        name[0] = 0;
    } else {
        strcpy(name, sky_name);
    }

    status |= SCENE_DATA_ASSIGNED;
    return 1;
}

void CSceneSky::Initialize() {
    sky = 0;
    CSceneData::Initialize();
}

void CSceneGameObj::Initialize() {
    CSceneCharacter::Initialize();
}

void CSceneEffect::Initialize() {
    effect = 0;
    CSceneData::Initialize();
}

int CSceneEffect::AssignData(CEffectScriptMan *effect_data, char *effect_name) {
    if (effect_data == NULL) {
        return 0;
    }

    Initialize();
    status = 0;
    effect = effect_data;

    if (effect_name == NULL) {
        name[0] = 0;
    } else {
        strcpy(name, effect_name);
    }

    status |= SCENE_DATA_ASSIGNED;
    return 1;
}

void CScene::InitAllData() {
    Initialize();
    time = 0.0f;
    day = 0;
    save_data = NULL;
    now_map_no = -1;
    now_sub_map_no = -1;
    old_map_no = -1;
    old_sub_map_no = -1;
    skip_load_villager = 0;
    skip_load_sub_villager = 0;
}

void CScene::Initialize(void) {
    int index;

    stack_num = 12;
    stack_no = 0;
    for (index = 0; index < stack_num; index++) {
        stack[index] = NULL;
    }
    work_stack = NULL;
    read_buff = NULL;
    chara_num = 128;
    for (index = 0; index < chara_num; index++) {
        chara[index].Initialize();
    }
    camera_num = 8;
    for (index = 0; index < camera_num; index++) {
        camera[index].Initialize();
    }
    message_num = 8;
    for (index = 0; index < message_num; index++) {
        message[index].Initialize();
    }
    map_num = 4;
    for (index = 0; index < map_num; index++) {
        map[index].Initialize();
    }
    sky_num = 4;
    for (index = 0; index < sky_num; index++) {
        sky[index].Initialize();
    }
    gameobj_num = 4;
    for (index = 0; index < sky_num; index++) {
        gameobj[index].Initialize();
    }
    effect_num = 8;
    for (index = 0; index < effect_num; index++) {
        effect[index].Initialize();
    }
    bg_load_step = 0;
    mds_list_set.Initialize();
    fade.Initialize();
    player_chara = -1;
    active_camera = -1;
    before_camera = -1;
    active_map = -1;
    villager_texb_num = 0;
    villager_texb = 0;
    chara_texb = 0;
    event_texb = 0;
    event_texb_num = 0;
    unk_2e84 = -1;
    time_speed = 0.00088f;
    time_step = 0;
    fire_raster.Initialize();
    thunder.Init();
    exit_flag = 0;
    battle_area.floor_manager.Initialize();
    battle_area.unk_0 = 0;
    battle_area.unk_4 = 0;
    battle_area.bright_rate = 1.0f;
    battle_area.unk_4 = 0;
    battle_area.quake_count = 0;
    battle_area.treasure_box = NULL;
    battle_area.battle_effect = NULL;
    battle_area.map_name[0] = 0;
    battle_area.script.event_no = -1;
    wind_power = 0.0f;
    mgZeroVector(wind_dir);
    villager_time = -1;
    sub_villager_time = -1;
}

void CScene::SetStack(int index, mgCMemory *stack) {
    if (index < 0 || index >= stack_num) {
        return;
    }

    this->stack[index] = stack;
}

mgCMemory *CScene::GetStack(int index) {
    if (index < 0 || index >= stack_num) {
        return NULL;
    }

    return stack[index];
}

void CScene::ClearStack(int index) {
    int i;

    int offset = index * 4;
    for (i = index; i < stack_num; i++) {
        mgCMemory **slot = (mgCMemory **)((u8 *)this + offset + 8);
        mgCMemory *stack = *slot;
        if (stack != NULL) {
            stack->stack_used = 0;
            stack->lock = 0;
            if (index < i) {
                (*slot)->stSetBuffer(NULL, 0);
            }
        }
        offset += 4;
    }
}

void CScene::AssignStack(int index) {
    mgCMemory *memory;

    if (index <= 1 || stack[index] == NULL || stack[index - 1] == NULL) {
        return;
    }

    if (stack[index - 1]->stack_size <= 0) {
        AssignStack(index - 1);
    }

    stack[index - 1]->Align64();
    stack[index - 1]->lock = 1;
    int remaining = stack[index - 1]->stGetRest();
    stack[index]->stSetBuffer(stack[index - 1]->stGetTop(), remaining);
    memory = stack[index];
    memory->stack_used = 0;
    memory->lock = 0;
    stack_no = index;
}

CSceneCharacter *CScene::GetSceneCharacter(int index) {
    if (index < 0 || index >= chara_num) {
        return NULL;
    }

    return &chara[index];
}

CSceneMap *CScene::GetSceneMap(int index) {
    if (index < 0 || index >= map_num) {
        return NULL;
    }

    return &map[index];
}

CSceneMessage *CScene::GetSceneMessage(int index) {
    if (index < 0 || index >= message_num) {
        return NULL;
    }

    return &message[index];
}

CSceneCamera *CScene::GetSceneCamera(int index) {
    if (index < 0 || index >= camera_num) {
        return NULL;
    }

    return &camera[index];
}

CSceneSky *CScene::GetSceneSky(int index) {
    if (index < 0 || index >= sky_num) {
        return NULL;
    }

    return &sky[index];
}

CSceneGameObj *CScene::GetSceneGameObj(int index) {
    if (index < 0 || index >= gameobj_num) {
        return NULL;
    }

    return &gameobj[index];
}

CSceneEffect *CScene::GetSceneEffect(int index) {
    if (index < 0 || index >= effect_num) {
        return NULL;
    }

    return &effect[index];
}

int CScene::CheckIMGName(int excluded_map, char *filename) {
    for (int map_index = 0; map_index < map_num; map_index++) {
        if (map_index != excluded_map) {
            int       name_index;
            CMapInfo *map_info;
            CMap     *loaded_map = GetMap(map_index);

            if ((map_info = (CMapInfo *)loaded_map) != NULL && loaded_map != NULL) {
                name_index = 0;

                for (;;) {
                    char *name = map_info->GetImgName(name_index);

                    if (name == NULL) {
                        break;
                    }

                    if (strcmp(name, filename) == 0) {
                        return 1;
                    }

                    name_index++;
                }
            }
        }
    }

    return 0;
}

int CScene::CheckMDSName(int excluded_map, char *filename) {
    for (int map_index = 0; map_index < map_num; map_index++) {
        if (map_index != excluded_map) {
            int       name_index;
            CMapInfo *map_info;
            CMap     *loaded_map = GetMap(map_index);

            if ((map_info = (CMapInfo *)loaded_map) != NULL && loaded_map != NULL) {
                name_index = 0;

                for (;;) {
                    char *name = map_info->GetPCPName(name_index);

                    if (name == NULL) {
                        break;
                    }

                    if (strcmp(name, filename) == 0) {
                        return 1;
                    }

                    name_index++;
                }
            }
        }
    }

    return 0;
}

CSceneData *CScene::GetData(int kind, int index) {
    switch (kind) {
        case SCENE_DATA_CHARA:
            return GetSceneCharacter(index);
        case SCENE_DATA_MAP:
            return GetSceneMap(index);
        case SCENE_DATA_MESSAGE:
            return GetSceneMessage(index);
        case SCENE_DATA_CAMERA:
            return GetSceneCamera(index);
        case SCENE_DATA_GAMEOBJ:
            return GetSceneGameObj(index);
        case SCENE_DATA_EFFECT:
            return GetSceneGameObj(index);
        default:
            return NULL;
    }
}

int CScene::AssignCamera(int index, mgCCamera *camera, char *camera_name) {
    CSceneCamera *slot;
    int           i;

    if (index < 0) {
        for (i = 0; i < camera_num; i++) {
            slot = GetSceneCamera(i);

            if (slot == NULL) {
                continue;
            }

            int empty = (slot->status == 0);

            if (empty) {
                break;
            }
        }

        return -1;
    }

    slot = GetSceneCamera(index);

    if (slot == NULL) {
        return -1;
    }

    static char noname[8] = "no_name";


    if (camera_name == NULL) {
        camera_name = noname;
    }

    if (active_camera < 0) {
        active_camera = index;
    }

    if (slot->AssignData(camera, camera_name) != 0) {
        return index;
    }

    return -1;
}

int CScene::GetCameraID(char *camera_name) {
    int index;

    if (camera_name == NULL) {
        return -1;
    }

    for (index = 0; index < camera_num; index++) {
        CSceneCamera *slot = GetSceneCamera(index);

        if (slot == NULL) {
            continue;
        }

        int empty = (slot->status == 0);

        if (empty) {
            continue;
        }

        if (strcmp(camera_name, slot->name) == 0) {
            return index;
        }
    }

    return -1;
}

mgCCamera *CScene::GetCamera(int index) {
    CSceneCamera *slot = GetSceneCamera(index);

    if (slot == NULL) {
        return NULL;
    }

    int empty = (slot->status == 0);

    if (empty) {
        return NULL;
    }

    return slot->camera;
}

int CScene::AssignMessage(int index, ClsMes *message_data, char *message_name) {
    CSceneMessage *slot;
    int            i;

    if (index < 0) {
        for (i = 0; i < message_num; i++) {
            slot = GetSceneMessage(i);

            if (slot == NULL) {
                continue;
            }

            int empty = (slot->status == 0);

            if (empty) {
                break;
            }
        }

        return -1;
    }

    slot = GetSceneMessage(index);

    if (slot == NULL) {
        return -1;
    }

    static char noname[8] = "no_name";


    if (message_name == NULL) {
        message_name = noname;
    }

    if (slot->AssignData(message_data, message_name) != 0) {
        return index;
    }

    return -1;
}

ClsMes *CScene::GetMessage(int index) {
    CSceneMessage *slot = GetSceneMessage(index);

    if (slot == NULL) {
        return NULL;
    }

    int empty = (slot->status == 0);

    if (empty) {
        return NULL;
    }

    return slot->mes;
}

int CScene::AssignChara(int index, CCharacter2 *character_data, char *character_name) {
    CSceneCharacter *slot;
    int              i;

    if (index < 0) {
        for (i = 0; i < chara_num; i++) {
            slot = GetSceneCharacter(i);

            if (slot == NULL) {
                continue;
            }

            int empty = (slot->status == 0);

            if (empty) {
                break;
            }
        }

        return -1;
    }

    slot = GetSceneCharacter(index);

    if (slot == NULL) {
        return -1;
    }

    static char noname[8] = "no_name";


    if (character_name == NULL) {
        character_name = noname;
    }

    if (slot->AssignData(character_data, character_name) != 0) {
        return index;
    }

    return -1;
}

void CScene::SetCharaNo(int index, int value) {
    CSceneCharacter *chara = GetSceneCharacter(index);

    if (chara != 0) {
        chara->chara_no = value;
    }
}

int CScene::GetCharaNo(int index) {
    CSceneCharacter *chara;

    chara = GetSceneCharacter(index);

    if (chara != NULL) {
        return chara->chara_no;
    }

    return -1;
}

CCharacter2 *CScene::GetCharacter(int index) {
    CSceneCharacter *slot = GetSceneCharacter(index);

    if (slot == NULL) {
        return NULL;
    }

    int empty = (slot->status == 0);

    if (empty) {
        return NULL;
    }

    return slot->chara;
}

int CScene::AssignMap(int index, CMap *map_data, char *map_name) {
    CSceneMap *slot;
    int        i;

    if (index < 0) {
        for (i = 0; i < map_num; i++) {
            slot = GetSceneMap(i);

            if (slot == NULL) {
                continue;
            }

            int empty = (slot->status == 0);

            if (empty) {
                break;
            }
        }

        return -1;
    }

    slot = GetSceneMap(index);

    if (slot == NULL) {
        return -1;
    }

    static char noname[8] = "no_name";


    if (map_name == NULL) {
        map_name = noname;
    }

    if (active_map < 0) {
        active_map = index;
    }

    if (slot->AssignData(map_data, map_name) != 0) {
        return index;
    }

    return -1;
}

char *CScene::GetMapName(int index) {
    CSceneMap *slot;

    slot = GetSceneMap(index);

    if (slot != 0) {
        return slot->name;
    }

    return 0;
}

int CScene::GetMapID(char *map_name) {
    int index;

    if (map_name == NULL) {
        return -1;
    }

    for (index = 0; index < map_num; index++) {
        CSceneMap *slot = GetSceneMap(index);

        if (slot == NULL) {
            continue;
        }

        int empty = (slot->status == 0);

        if (empty) {
            continue;
        }

        if (strcmp(map_name, slot->name) == 0) {
            return index;
        }
    }

    return -1;
}

CMap *CScene::GetMap(int index) {
    CSceneMap *slot = GetSceneMap(index);

    if (slot == NULL) {
        return NULL;
    }

    int empty = (slot->status == 0);

    if (empty) {
        return NULL;
    }

    return slot->map;
}

CMapSky *CScene::GetSky(int index) {
    CSceneSky *slot = GetSceneSky(index);

    if (slot == NULL) {
        return NULL;
    }

    int empty = (slot->status == 0);

    if (empty) {
        return NULL;
    }

    return slot->sky;
}

int CScene::GetMainMapNo() {
    if (active_map == 0) {
        return now_map_no;
    }

    return now_sub_map_no;
}

CFuncPoint *CScene::InScreenFunc(InScreenFuncInfo *info) {
    CFuncPoint *nearest = NULL;
    float       distance = -1.0f;
    float       range = 0.0f;

    for (int i = 0; i < map_num; i++) {
        if (IsActive(SCENE_DATA_MAP, i)) {
            CMap *map = GetMap(i);

            if (map != NULL) {
                CFuncPoint *point = map->InScreenFunc(info);

                if (point != NULL && (nearest == NULL || info->dist < distance)) {
                    nearest = point;
                    range = info->unk_04;
                    distance = info->dist;
                }
            }
        }
    }

    info->unk_04 = range;

    if (nearest != NULL) {
        return nearest;
    }

    CMap *map = GetMap(active_map);

    if (map == NULL) {
        return NULL;
    }

    CMapSky *sky = GetSky(0);

    if (sky == NULL) {
        return NULL;
    }

    for (int i = 0; i < 4; i++) {
        if (sky->sun[i] == NULL) {
            return NULL;
        }
    }

    float         lighting[4];
    float         position[4];
    float         screen_max[4];
    float         screen_min[4];
    sceVu0FMATRIX matrix;
    mgVu0FBOX     box;
    map->GetLightingSunRatio(lighting);
    mgUnitMatrix(matrix);
    float brightness = lighting[0] > lighting[1]
                           ? (lighting[0] > lighting[2] ? (lighting[0] > lighting[3] ? lighting[0] : lighting[3]) : (lighting[2] > lighting[3] ? lighting[2] : lighting[3]))
                           : (lighting[1] > lighting[2] ? (lighting[1] > lighting[3] ? lighting[1] : lighting[3]) : (lighting[2] > lighting[3] ? lighting[2] : lighting[3]));

    if (brightness < 0.2f) {
        return NULL;
    }

    if (lighting[2] > 0.0f) {
        GetMoonPosition(position);
    } else {
        GetSunPosition(position);
    }

    position[3] = 1.0f;
    *(u_long128 *) box.max = *(u_long128 *) position;
    *(u_long128 *) box.min = *(u_long128 *) position;

    for (int i = 0; i < 3; i++) {
        box.max[i] += 100.0f;
        box.min[i] -= 100.0f;
    }

    if (!mgInsideScreen(&box, matrix, screen_max, screen_min)) {
        return NULL;
    }

    float bounds_max[4] = {50.0f, 50.0f, 0.0f, 0.0f};
    float bounds_min[4] = {-50.0f, -50.0f, 0.0f, 0.0f};

    if (!(screen_max[0] < bounds_min[0])) {
        if (screen_min[0] <= bounds_max[0] && !(screen_max[1] < bounds_min[1]) &&
            screen_min[1] <= bounds_max[1] && screen_min[3] - 100.0f <= 4.0f + info->range) {
            static CFuncPoint sun_func;
            sun_func.type = FUNC_POINT_INVENT;
            int subject;

            if (lighting[2] > 0.0f) {
                subject = 0xC1;
            } else {
                if (lighting[0] > lighting[1]) {
                    if (lighting[0] > lighting[3]) {
                        subject = 0xC2;
                    } else {
                        subject = 0xC3;
                    }
                } else {
                    if (lighting[1] > lighting[3]) {
                        subject = 0xC4;
                    } else {
                        subject = 0xC3;
                    }
                }
            }

            sun_func.invent.neta_no = subject;
            return &sun_func;
        }
    }

    return NULL;
}

void CScene::DrawScreenFunc(mgCFrame *frame) {
    for (int i = 0; i < map_num; i++) {
        CMap *map = GetMap(i);

        if (IsActive(2, i) != 0 && map != NULL) {
            map->DrawScreenFunc(frame);
        }
    }
}

int CScene::AssignSky(int index, CMapSky *sky_data, char *sky_name) {
    CSceneSky *slot;
    int        i;

    if (index < 0) {
        for (i = 0; i < sky_num; i++) {
            slot = GetSceneSky(i);

            if (slot == NULL) {
                continue;
            }

            int empty = (slot->status == 0);

            if (empty) {
                break;
            }
        }

        return -1;
    }

    slot = GetSceneSky(index);

    if (slot == NULL) {
        return -1;
    }

    static char noname[8] = "no_name";


    if (sky_name == NULL) {
        sky_name = noname;
    }

    if (slot->AssignData(sky_data, sky_name) != 0) {
        return index;
    }

    return -1;
}

int CScene::DeleteSky(int index) {
    CSceneSky *slot;

    slot = GetSceneSky(index);

    if (slot == NULL) {
        return 0;
    }

    slot->Initialize();
    return 1;
}

int CScene::AssignEffect(int index, CEffectScriptMan *effect, char *effect_name) {
    CSceneEffect *slot = GetSceneEffect(index);

    if (slot == NULL) {
        return -1;
    }

    static char noname[8] = "no_name";


    if (effect_name == NULL) {
        effect_name = noname;
    }

    if (slot->AssignData(effect, effect_name) != 0) {
        return index;
    }

    return -1;
}

void CScene::DeleteEffect(int index) {
    CSceneEffect *slot;

    slot = GetSceneEffect(index);

    if (slot != NULL) {
        slot->Initialize();
    }
}

CEffectScriptMan *CScene::GetEffect(int index) {
    CSceneEffect *slot = GetSceneEffect(index);

    if (slot != 0) {
        return slot->effect;
    }

    return 0;
}

void CScene::StepEffectScript(int index) {
    if (index < 0) {
        for (int i = 0; i < effect_num; i++) {
            CEffectScriptMan *effect = GetEffect(i);

            if (effect != NULL) {
                effect->Step();
            }
        }
    } else {
        CEffectScriptMan *effect = GetEffect(index);

        if (effect != NULL) {
            effect->Step();
        }
    }
}

void CScene::DrawEffectScript(int index) {
    if (index < 0) {
        for (int i = 0; i < effect_num; i++) {
            CEffectScriptMan *effect = GetEffect(i);

            if (effect != NULL) {
                effect->Draw();
            }
        }
    } else {
        CEffectScriptMan *effect = GetEffect(index);

        if (effect != NULL) {
            effect->Draw();
        }
    }
}

int CScene::IsActive(int kind, int index) {
    CSceneData *data;

    data = GetData(kind, index);

    if (data != NULL) {
        return (data->status & (SCENE_DATA_ACTIVE | SCENE_DATA_ASSIGNED)) ==
               (SCENE_DATA_ACTIVE | SCENE_DATA_ASSIGNED);
    }

    return 0;
}

void CScene::SetActive(int kind, int index) {
    CSceneData *data;

    data = GetData(kind, index);

    if (data != NULL) {
        data->status |= SCENE_DATA_ACTIVE;
    }
}

void CScene::ResetActive(int kind, int index) {
    CSceneData *data;

    data = GetData(kind, index);

    if (data != NULL) {
        data->status &= ~SCENE_DATA_ACTIVE;
    }
}

void CScene::SetStatus(int kind, int index, int bits) {
    CSceneData *data;

    data = GetData(kind, index);

    if (data != NULL) {
        data->status |= bits;
    }
}

void CScene::ResetStatus(int kind, int index, int bits) {
    CSceneData *data;

    data = GetData(kind, index);

    if (data != NULL) {
        data->status &= ~bits;
    }
}

int CScene::GetStatus(int kind, int index) {
    CSceneData *data;

    data = GetData(kind, index);

    if (data != NULL) {
        return data->status;
    }

    return 0;
}

void CScene::SetType(int kind, int index, int type) {
    CSceneData *data = GetData(kind, index);

    if (data != 0) {
        data->type = type;
    }
}

int CScene::GetType(int kind, int index) {
    CSceneData *data = GetData(kind, index);

    if (data != 0) {
        return data->type;
    }

    return 0;
}

int CScene::GetActiveMap(CMap **map, int max_count) {
    int i;
    int count = 0;

    for (i = 0; i < map_num; i++) {
        if (count >= max_count) {
            break;
        }

        if (IsActive(2, i) != 0) {
            map[count++] = GetMap(i);
        }
    }

    return count;
}

int CScene::GetCharaTexb(int index) {
    int              texb;
    CSceneCharacter *chara;

    chara = GetSceneCharacter(index);

    if (chara == NULL) {
        return -1;
    }

    texb = chara->texb;

    if (texb >= 0) {
        return texb;
    }

    if (index < 8) {
        return chara_texb;
    }

    if ((index - 8) >= villager_texb_num) {
        return -1;
    }

    return (villager_texb + index) - 8;
}

void CScene::SetCharaTexb(int index, int texb) {
    CSceneCharacter *chara = GetSceneCharacter(index);

    if (chara != 0) {
        chara->texb = texb;
    }
}

void CScene::SetTime(float hours) {
    hours -= 24.0f * (int) (hours / 24.0f);

    if (hours < 0.0f) {
        hours += 24.0f;
    }

    time = hours;

    if (save_data != NULL) {
        save_data->now_time = time;
    }
}

void CScene::AddTime(float hours) {
    SetTime(hours + time);
}

void CScene::TimeStep(float frame_scale) {
    CSaveData *save_data;
    float      previous_time;
    float      step;

    if (time_step != 0) {
        previous_time = time;
        step = (time_speed * frame_scale);
        AddTime(step);

        if (!(previous_time <= ((24.0f - step) - 0.1f)) && (time < (0.1f + step))) {
            day += 1;
        }

        save_data = this->save_data;

        if (save_data != NULL) {
            save_data->day = day;
            this->save_data->CheckTourBoot(day);
        }
    }
}

void CScene::SetWind(float strength, float *direction) {
    wind_power = strength;
    sceVu0Normalize(wind_dir, direction);
}

void CScene::ResetWind() {
    wind_power = 0.0f;
}

float CScene::GetWind(float *direction) {
    *(u_long128 *) direction = *(u_long128 *) wind_dir;
    return wind_power;
}

void CScene::SetNowMapNo(int now_map_no) {
    int old = this->now_map_no;

    if (old != now_map_no) {
        old_map_no = old;
    }

    this->now_map_no = now_map_no;
}

void CScene::SetNowSubMapNo(int now_sub_map_no) {
    int old = this->now_sub_map_no;

    if (old != now_sub_map_no) {
        old_sub_map_no = old;
    }

    this->now_sub_map_no = now_sub_map_no;
}
