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
#include "mdslist.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "mapload.hpp"
#include "dataread.hpp"
#include "scriptinterpreter.hpp"
#include <cstring>
#include <cstdio>

extern "C" int strcasecmp(const char *left, const char *right);
extern int now_mds_num;
extern int max_mds_num;
extern CMdsList *pcpMdsList;
extern CMdsInfo *pcpMdsInfo;
extern CMdsInfo *pcpNowMdsInfo;
extern mgCMemory *pcpStack;
extern u_int *pcp_file;
extern int pcpAllScissor;
extern SPI_TAG_PARAM pcp_tag[];
CCharacter2 *CreateChara(u_int *pack, char *config, mgCMemory *memory);

extern char at_754[];

extern char at_807[];

extern char at_828[];

extern char at_829[];

extern char at_830[];

static u_int align16_blocks(u_int size) {
    return (size + 15) >> 4;
}

// Code (.text)
int CMapPiece::AssignMds(CMdsInfo *info) {
    if (info == NULL) {
        return 0;
    }
    name = info->name;
    chara = info->chara;
    type = info->type;
    frame = info->frame;
    far_dist = info->far_dist;
    fade = info->far_fade;
    return 1;
}
int CMapPiece::GetPoly(int type, CCPoly *poly, mgVu0FBOX &box, int num) {
    if (type != this->type) {
        return 0;
    }
    if (col_type != 0) {
        return 0;
    }
    if (GetShow() == 0) {
        return 0;
    }
    UpDatePosition();
    return ((CColFrame *)frame)->PickUpNearPoly(poly, box, num);
}
void CMapPiece::SetTimeBand(float start, float end) {
    time_start = start;
    time_end = end;
}
PieceMaterial *CMapPiece::GetMaterial(int index) {
    PieceMaterial *list;

    list = material;
    if (list == NULL) {
        return NULL;
    }
    if (index >= 0) {
        if (index < material_num) {
            goto found;
        }
    }
    return NULL;

found:
    return list + index;
}
void CMapPiece::Step() {
    if (chara != NULL) {
        UpDatePosition();
        chara->Step();
    }
}
int CMapPiece::GetBoundBox(mgVu0FBOX *box) {
    if (frame == NULL) {
        return 0;
    }
    UpDatePosition();
    return frame->GetWorldBBox(box);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mdslist", DrawSub__9CMapPieceFi);
void CMapPiece::Copy(CMapPiece &dest, mgCMemory *memory) {
    int i;
    PieceMaterial *to;
    PieceMaterial *from;
    int offset;
    int num;
    CCharacter2 *model;

    dest.Initialize();
    ((CObjectFrame *)this)->Copy((CObjectFrame &)dest, memory);
    dest.name = name;
    dest.type = type;
    dest.draw_enable = draw_enable;
    dest.col_type = col_type;
    dest.time_start = time_start;
    dest.time_end = time_end;
    dest.material_num = material_num;
    if (memory == NULL) {
        dest.material = material;
    } else {
        num = material_num;
        dest.material = new (memory->Alloc(align16_blocks(num * sizeof(PieceMaterial)) + 2)) PieceMaterial[num];
        i = 0;
        if (dest.material == NULL) {
            dest.material_num = 0;
        }
        offset = 0;
        for (; i < dest.material_num; i++) {
            from = (PieceMaterial *)((u_char *)material + offset);
            to = (PieceMaterial *)((u_char *)dest.material + offset);
            offset += 0x20;
            to->frame = from->frame;
            to->material_no = from->material_no;
            to->material = from->material;
            to->unk_c = from->unk_c;
            sceVu0CopyVector(to->color, from->color);
        }
    }
    if (chara != NULL && memory != NULL) {
        model = new (memory->Alloc(0x68)) CCharacter2;
        dest.chara = (CCharacter2 *)model;
        if (dest.chara != NULL) {
            chara->Copy(*dest.chara, memory);
            dest.frame = (mgCFrame *)((CObjectFrame *)dest.chara)->frame;
        }
    } else {
        dest.chara = chara;
    }
}
void CMapPiece::Initialize() {
    int i;
    int offset;

    ((CObjectFrame *)this)->Initialize();
    type = 0;
    chara = NULL;
    i = 0;
    draw_enable = 1;
    offset = 0;
    name = NULL;
    material_num = 0;
    col_type = 0;
    col_param = 0;
    for (; i < material_num; i++) {
        memset((u_char *)material + offset, 0, 0x20);
        offset += 0x20;
    }
    time_end = 0;
    time_start = 0;
}
void CMdsInfo::Initialize(void) {
    name = NULL;
    type = MDS_TYPE_MODEL;
    frame = NULL;
    chara = NULL;
    far_dist = -1.0f;
    far_fade = 0;
}
CMdsList *CMdsListSet::SearchMdsList(char *name) {
    int i;

    if (name == NULL) {
        return NULL;
    }
    for (i = 0; i < mds_list_num; i++) {
        if (mds_list[i].name != NULL && strcmp(mds_list[i].name, name) == 0) {
            return &mds_list[i];
        }
    }
    return NULL;
}
CMdsList *CMdsListSet::GetMdsList(int index) {
    if (index >= 0) {
        if (index <= mds_list_num) {
            goto found;
        }
    }
    return NULL;

found:
    return mds_list + index;
}
CMdsInfo *CMdsListSet::SearchMDS(char *name) {
    int i;
    CMdsList *models;
    CMdsInfo *item;

    i = 0;
    for (;;) {
        models = GetMdsList(i);
        if (models == NULL) {
            break;
        }
        item = models->GetList(name);
        if (item != NULL) {
            return item;
        }
        i++;
    }
    return 0;
}
int CMdsListSet::LoadPCPFile(char *name, u_int *pack, mgCMemory *memory, int type) {
    CMdsList *slot;
    int i;
    int is_free;

    if (name == NULL) {
        return 0;
    }
    if (SearchMdsList(name) != NULL) {
        return 0;
    }
    slot = NULL;
    i = 0;
    for (; i < mds_list_num; i++) {
        is_free = !mds_list[i].list || !mds_list[i].name || mds_list[i].num == 0;
        if (is_free & 0xFF) {
            slot = &mds_list[i];
        }
    }
    if (slot == NULL) {
        return 0;
    }
    slot->LoadPCPFile(name, pack, memory, type);
    return 1;
}
int CMdsListSet::DeleteMdsList(char *name) {
    CMdsList *mds_list = SearchMdsList(name);
    if (mds_list == NULL) {
        return 0;
    }
    mds_list->name = NULL;
    mds_list->num = 0;
    mds_list->list = NULL;
    return 1;
}
int CMdsListSet::LoadIMGFile(char *name, mgCEnterIMGInfo *info, mgCMemory *memory) {
    CIMGList *slot;
    int i;

    if (name == NULL) {
        return 0;
    }
    if (SearchIMGList(name) != NULL) {
        return 0;
    }
    slot = NULL;
    i = 0;
    for (; i < img_list_num; i++) {
        if ((u_char)(!img_list[i].name) != 0) {
            slot = &img_list[i];
        }
    }
    if (slot == NULL) {
        return 0;
    }
    ((CIMGList *)slot)->LoadIMGFile(name, info, memory);
    return 1;
}
void CMdsListSet::DeleteIMG(char *name) {
    CIMGList *img_list = SearchIMGList(name);
    if (img_list != NULL) {
        img_list->name = NULL;
        img_list->info = NULL;
    }
}
CIMGList *CMdsListSet::SearchIMGList(char *name) {
    int i;

    for (i = 0; i < img_list_num; i++) {
        if ((u_char)(!img_list[i].name) == 0 && img_list[i].name != NULL && strcmp(img_list[i].name, name) == 0) {
            return &img_list[i];
        }
    }
    return NULL;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mdslist", GetTextureBlockNo__11CMdsListSetFiPii);
void CMdsListSet::Initialize() {
    int i;
    int j;

    mds_list_num = 8;
    for (i = 0; i < mds_list_num; i++) {
        mds_list[i].name = NULL;
        mds_list[i].num = 0;
        mds_list[i].list = NULL;
    }
    img_list_num = 16;
    for (j = 0; j < img_list_num; j++) {
        img_list[j].name = NULL;
        img_list[j].info = NULL;
    }
}
CMdsInfo *CMdsList::GetList(int index) {
    if (index >= 0) {
        if (index < num) {
            goto found;
        }
    }
    return NULL;

found:
    return list + index;
}
int CMdsList::GetListID(char *name) {
    int i;

    if (name == NULL || *(signed char *)name == 0) {
        return -1;
    }
    for (i = 0; i < num; i++) {
        if (list[i].name != NULL && strcasecmp(list[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}
CMdsInfo *CMdsList::GetList(char *name) {
    int index;

    index = GetListID(name);
    if (index < 0) {
        return 0;
    }
    return GetList(index);
}
int CIMGList::LoadIMGFile(char *name, mgCEnterIMGInfo *info, mgCMemory *memory) {
    CIMGList *slot;
    mgCEnterIMGInfo *copy;
    u_int length;
    u_int blocks;

    slot = (CIMGList *)this;
    if (name == NULL) {
        return 0;
    }
    slot->name = NULL;
    length = strlen(name) + 1;
    blocks = align16_blocks(length);
    slot->name = (char *)memory->Alloc(blocks);
    strcpy(slot->name, name);
    slot->info = NULL;
    if (info != NULL) {
        slot->info =
            (mgCEnterIMGInfo *)operator new(sizeof(mgCEnterIMGInfo), (u_long128 *)memory->Alloc(0x12));
        copy = slot->info;
        memcpy(copy->block, info->block, sizeof(copy->block));
        memcpy(copy->block_num, info->block_num, sizeof(copy->block_num));
    }
    return 1;
}
int pcpMDS(SPI_STACK *stack, int arg) {
    char *name;
    char *copy;
    u_int length;
    u_int blocks;

    if (now_mds_num >= max_mds_num) {
        pcpNowMdsInfo = NULL;
        return 0;
    }
    name = spiGetStackString(stack);
    if (name != NULL && pcpMdsList->GetList(name) != NULL) {
        printf(at_754, name);
        pcpNowMdsInfo = NULL;
        return 0;
    }
    pcpNowMdsInfo = &pcpMdsInfo[now_mds_num];
    now_mds_num += 1;
    pcpNowMdsInfo->Initialize();
    if (name == NULL) {
        pcpNowMdsInfo->name = NULL;
    } else {
        length = strlen(name) + 1;
        blocks = align16_blocks(length);
        copy = (char *)pcpStack->Alloc(blocks);
        strcpy(copy, name);
        pcpNowMdsInfo->name = copy;
    }
    return 1;
}
int pcpTYPE(SPI_STACK *stack, int argc) {
    int type;

    if (pcpNowMdsInfo == NULL) {
        return 0;
    }
    type = spiGetStackInt(stack);
    switch (type) {
        case 0:
            type = 0;
            break;
        case 1:
            type = 1;
            break;
        case 2:
            type = 3;
            break;
        case 3:
        case 4:
            type = 4;
            break;
    }
    pcpNowMdsInfo->type = type;
    return 1;
}
int pcpFAR_CLIP(SPI_STACK *stack, int argc) {
    if (pcpNowMdsInfo == NULL) {
        return 0;
    }
    pcpNowMdsInfo->far_dist = spiGetStackFloat(stack++);
    pcpNowMdsInfo->far_fade = spiGetStackInt(stack);
    return 1;
}
int pcpMDS_END(SPI_STACK *stack, int argc) {
    mgCFrameAttr attr;
    int size;
    u_int *file;
    mgCFrame *frame;
    CCharacter2 *chara;

    if (pcpNowMdsInfo == NULL) {
        return 0;
    }
    frame = NULL;
    file = GetPackFile(pcp_file, pcpNowMdsInfo->name, &size);
    if (file == NULL) {
        return 0;
    }
    switch (pcpNowMdsInfo->type) {
        case 0:
            frame = (mgCFrame *)mgLoadMDSFile((MDS_HEADER *)file, pcpStack, NULL, NULL);
            break;

        case 3:
        case 1:
            frame = LoadCollisionFile((MDS_HEADER *)file, pcpStack);
            break;
        case 4:
            chara = CreateChara(file, at_807, pcpStack);
            pcpNowMdsInfo->chara = (CCharacter2 *)chara;
            if (chara != NULL) {
                frame = (mgCFrame *)((CObjectFrame *)chara)->frame;
            }
            break;
    }
    if (pcpAllScissor != 0 && frame != NULL) {

        attr.clip_enable = 1;
        frame->SetAttrParam(attr, 1, 0x20);
    }
    pcpNowMdsInfo->frame = frame;
    return 1;
}
void CMdsList::LoadPCPFile(char *name, u_int *pack, mgCMemory *memory, int type) {
    u_int *files[0x200];
    char *names[0x200];
    char *script;
    int script_size;
    u_int length;
    u_int blocks;
    int model_count;

    pcpMdsList = this;
    GetPackFileNum(pack);
    num = GetPackFileExt(pack, at_828, files, 0x200, NULL, names);
    num += GetPackFileExt(pack, at_829, files, 0x200, NULL, names);
    if (num >= 0x200) {
        printf(at_830, num);
    }
    this->name = NULL;
    if (name != NULL) {
        length = strlen(name) + 1;
        blocks = align16_blocks(length);
        this->name = (char *)memory->Alloc(blocks);
        strcpy(this->name, name);
    }
    model_count = num;
    list = new (memory->Alloc(align16_blocks(model_count * sizeof(CMdsInfo)) + 2)) CMdsInfo[model_count];
    now_mds_num = 0;
    max_mds_num = num;
    pcpMdsInfo = (CMdsInfo *)list;
    pcpStack = memory;
    pcp_file = pack;
    pcpAllScissor = type;
    pcpNowMdsInfo = NULL;
    script = (char *)GetPackFile(pack, at_807, &script_size);
    CScriptInterpreter interpreter;
    interpreter.SetTag(pcp_tag);
    interpreter.SetScript(script, script_size);
    interpreter.Run();
}
CMdsInfo::CMdsInfo() {
    Initialize();
}
CCharacter2 *CreateChara(u_int *pack, char *config, mgCMemory *memory) {
    CCharacter2 *chara;

    chara = new (memory->Alloc(0x68)) CCharacter2;
    if (chara == NULL) {
        return NULL;
    }
    chara->Initialize();
    chara->LoadPackNoLine(pack, config, memory, memory, memory, -1, 0);
    return chara;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", pcp_tag__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_729__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_730__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_731__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_732__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_754__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_807__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_828__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_829__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", at_830__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", __vt__8CMdsInfo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mdslist", __vt__9CMapPiece__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(now_mds_num, 0x4);
INCLUDE_BSS(max_mds_num, 0x4);
INCLUDE_BSS(pcpMdsList, 0x4);
INCLUDE_BSS(pcpMdsInfo, 0x4);
INCLUDE_BSS(pcpNowMdsInfo, 0x4);
INCLUDE_BSS(pcpStack, 0x4);
INCLUDE_BSS(pcp_file, 0x4);
INCLUDE_BSS(pcpAllScissor, 0x4);
