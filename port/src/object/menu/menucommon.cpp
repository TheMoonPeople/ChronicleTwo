#include <limits>
// clang-format off
// Load JSON before legacy game headers define conflicting macros.
#include "platform/native_config.hpp"
#include "log/game_output.hpp"
// clang-format on

#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <initializer_list>
#include <map>
#include <memory>
#include <optional>
#include <print>
#include <stdexcept>
#include <string>
#include <string_view>
#include <type_traits>
#include <utility>
#include <variant>
#include <vector>

#include "character.hpp"
#include "dataread.hpp"
#include "effectlist.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "text/bounded.hpp"
#include "userdata.hpp"

/**
 *
 * Number of item categories used by the menu sorting order.
 *
 */
static const int sort_type_count = 36;

/**
 *
 * Default number of miscellaneous-information entries in a menu layout.
 *
 */
static const int default_etc_count = 96;

/**
 *
 * Rounds a byte count up to the number of 16-byte allocation blocks.
 *
 */
static inline unsigned int align16_blocks(unsigned int n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

int CompGameData(int item_a, int item_b);

int SeitonItemBoardSub(CGameDataUsed *items, int count);

void menu_texdata_to_formpart_copy(MENUFORMPARTS_TYPE *part);

/**
 *
 * Sort rank of each item category, with an empty slot ordered last.
 *
 */
static signed char sort_table[sort_type_count] = {
    sort_type_count, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
    23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 0};

/**
 *
 * First item category used by the next sorting pass.
 *
 */
static short sort_top_type = 1;

u8 MenuSePlayUsedFlag;

/**
 *
 * Volume of the object sound port before the menu silences it.
 *
 */
static float SndPortVol_Ob;

/**
 *
 * Volume of the base sound port before the menu silences it.
 *
 */
static float SndPortVol_Base;

/**
 *
 * Volume of the event sound port before the menu silences it.
 *
 */
static float SndPortVol_Event;

/**
 *
 * Whether the menu also silences the event sound port.
 *
 */
static int SndPortCheck_EventPort;

/**
 *
 * Environment music volume before the menu silences it.
 *
 */
static float SndPortVol_Env;

/**
 *
 * First texture-information slot of the current script block.
 *
 */
static u16 MenuTexPosNo;

/**
 *
 * Texture-information offset within the current script block.
 *
 */
static u16 MenuTexPosNo_local;

/**
 *
 * Texture block assigned to the current script texture.
 *
 */
static short menu_analyze_texblock;

mgCMemory *MenuSpiStack;

/**
 *
 * First miscellaneous-information slot of the current script block.
 *
 */
static short Menu_Target_No;

/**
 *
 * Miscellaneous-information offset within the current script block.
 *
 */
static short Menu_Target_No_local;

/**
 *
 * Form receiving the current menu layout script entries.
 *
 */
static CMenuPosDataForm *menu_formPt;

/**
 *
 * Part receiving the current menu layout script entries.
 *
 */
static MENUFORMPARTS_TYPE *menu_form_part;

/**
 *
 * Next effect entry receiving script parameters.
 *
 */
static MENU_PARTS_EFFECT_STRUCT1 *menu_parts_effect_ptr;

/**
 *
 * Form index selected by the layout script.
 *
 */
static short menu_analyze_formno;

/**
 *
 * Offset added to form indices in the current script block.
 *
 */
static short menu_analyze_formno_offset;

/**
 *
 * Next action entry receiving layout script parameters.
 *
 */
static MENU_FORM_ACTION *menu_spi_form_action_info;

/**
 *
 * Whether the command interpreter is executing the selected command block.
 *
 */
static u8 SpiMenuExeCommandFlag;

/**
 *
 * Texture name copied into entries of the current texture-information block.
 *
 */
static char MenuSpiTextureName[0x20];

MENU_COMMAND_ANALYZE_INFO MenuCommandAnalyzeInfo;

int GetRandI(int range) {
    return rand() % range;
}

float GetRandF(float range) {
    return range * mgRnd();
}

/**
 *
 * Recenters a bounding box around its midpoint.
 *
 */
static void ReCalcBox(mgVu0FBOX *out, mgVu0FBOX box) {
    float center_x = (box.max[0] + box.min[0]) / 2.0f;
    float center_y = (box.max[1] + box.min[1]) / 2.0f;
    float center_z = (box.max[2] + box.min[2]) / 2.0f;
    out->max[0] = box.max[0] - center_x;
    out->max[1] = box.max[1] - center_y;
    out->max[2] = box.max[2] - center_z;
    out->min[0] = box.min[0] - center_x;
    out->min[1] = box.min[1] - center_y;
    out->min[2] = box.min[2] - center_z;
    out->min[3] = 1.0f;
    out->max[3] = 1.0f;
}

float MenuAdjustPolygonScale(mgCFrame *frame, float size) {
    mgVu0FBOX box{};

    if (frame == nullptr) {
        return 1.0f;
    }

    frame->GetWorldBBox(&box);
    return MenuAdjustPolygonScale(box, size);
}

float MenuAdjustPolygonScale(mgVu0FBOX box, float size) {
    mgVu0FBOX centered_box{};
    ReCalcBox(&centered_box, box);
    mgVu0FBOX target_box{};
    target_box.max[0] = size;
    target_box.max[1] = size;
    target_box.max[2] = size;
    target_box.max[3] = 1.0f;
    float size_distance = mgDistVector(target_box.max);
    float box_distance = mgDistVector(centered_box.max);
    float scale = 1.0f;

    if (box_distance != 0.0f) {
        scale = size_distance / box_distance;

        if (scale <= 0.0f) {
            scale = -scale;
        }
    }

    return scale;
}

void MenuAdjustPolygonScale(CCharacter2 *chara, float size) {
    if (chara != nullptr) {
        float magnitude = {};
        float height = chara->body_height;
        float scale = 1.0f;
        magnitude = height;

        if (height < 0.0f) {
            magnitude = -height;
        }

        if (!(magnitude <= 1.0f)) {
            scale = size / height;
        }

        chara->SetScale(scale, scale, scale);
    }
}

void AddRotationCharaY(CCharacter2 *chara, float angle) {
    float rotation[4];

    if (chara != nullptr) {
        chara->GetRotation(rotation);
        float *rotation_y = &rotation[1];
        *rotation_y += angle;
        *rotation_y = mgAngleLimit(*rotation_y);
        chara->SetRotation(rotation);
    }
}

void MenuSePlay(int sound_no);

void MenuSePlay(unsigned int handle, int sound_no) {
    if (sound_no >= 0) {
        sndSePlay(handle, sound_no, 0);
    }
}

void MenuSePlay(int sound_no, unsigned int *bank, mgCMemory *memory) {
    if (bank == nullptr || memory == nullptr) {
        return;
    }

    memory->stClearUsed();
    memory->stSetLocked(false);
    sndInitPort(SND_PORT_MENU);
    sndSePlay(sndLoadSound(SND_PORT_MENU, bank, memory), sound_no, 0);
    MenuSePlayUsedFlag = true;
}

void StopEnvSoundMenu(int event_port) {
    SndPortVol_Ob = sndGetPortVol(SND_PORT_OB);
    SndPortVol_Base = sndGetPortVol(SND_PORT_BASE);
    sndSetPortVol(SND_PORT_OB, 0.0f);
    sndSetPortVol(SND_PORT_BASE, 0.0f);
    SndPortCheck_EventPort = event_port;

    if (event_port != 0) {
        SndPortVol_Event = sndGetPortVol(SND_PORT_EVENT);
        sndSetPortVol(SND_PORT_EVENT, 0.0f);
    }

    SndPortCheck_EventPort = event_port;
    SndPortVol_Env = GetMainScene()->GetEnvBGMVol();
    GetMainScene()->SetEnvBGMVol(0.0f);
}

void ReStartEnvSoundMenu() {
    sndSetPortVol(SND_PORT_OB, SndPortVol_Ob);
    sndSetPortVol(SND_PORT_BASE, SndPortVol_Base);

    if (SndPortCheck_EventPort != 0) {
        sndSetPortVol(SND_PORT_EVENT, SndPortVol_Event);
    }

    GetMainScene()->SetEnvBGMVol(SndPortVol_Env);
}

/**
 *
 * Compares item identifiers by their configured inventory category and item number.
 *
 */
int CompGameData(int item_a, int item_b) {
    CGameData   *game_data = {};
    CDataCommon *record_a = {};
    CDataCommon *record_b = {};
    int          rank_a = {};
    int          rank_b = {};

    game_data = GetGameDataPt();
    record_a = game_data->GetCommonData(item_a);
    record_b = game_data->GetCommonData(item_b);
    rank_b = 0;
    rank_a = 0;

    if (record_a != nullptr) {
        rank_a = sort_table[record_a->type];
    }

    if (record_b != nullptr) {
        rank_b = sort_table[record_b->type];
    }

    if (item_a <= 0) {
        rank_a = sort_type_count;
    }

    if (item_b <= 0) {
        rank_b = sort_type_count;
    }

    if (rank_b < rank_a) {
        return 1;
    }

    if (rank_a < rank_b) {
        return -1;
    }

    if (item_b < item_a) {
        return 1;
    }

    if (item_a < item_b) {
        return -1;
    }

    return 0;
}

/**
 *
 * Sorts an item board using the current inventory category order.
 *
 */
int SeitonItemBoardSub(CGameDataUsed *items, int count) {
    CGameDataUsed *board = {};
    int            i = {};
    int            sort_type = {};
    int            j = {};
    u8             swapped = {};

    board = items;
    sort_type = sort_top_type;

    for (i = 0; i < sort_type_count; i++) {
        sort_table[sort_type] = i;
        sort_type++;

        if (sort_type >= sort_type_count) {
            sort_type = 0;
        }
    }

    sort_table[0] = sort_type_count;
    swapped = false;

    for (i = 0; i < count - 1; i++) {
        for (j = i + 1; j < count; j++) {
            if (CompGameData(board[i].item_no, board[j].item_no) > 0) {
                GameDataSwap(&board[i], &board[j], 1);
                swapped = true;
            }
        }
    }

    return swapped;
}

int MenuSeiton(CGameDataUsed *items, int count) {
    CGameDataUsed *board = items;
    int            i = {};
    int            j = {};
    int            attempt = {};
    CGameDataUsed *second = {};
    int            room = {};
    int            moved = {};
    CGameDataUsed *first = {};

    if (board == nullptr) {
        return 0;
    }

    for (i = 0; i < count; i++) {
        first = &board[i];

        if (first->CheckTypeEnableStack() != 0) {
            for (j = i + 1; j < count; j++) {
                second = &board[j];

                if (first->item_no == second->item_no) {
                    room = first->CheckStackRemain();

                    if (room <= 0) {
                        break;
                    }

                    moved = second->GetNum();

                    if (room < moved) {
                        moved = room;
                    }

                    first->AddNum(moved, 1);
                    second->DeleteNum(moved);
                }
            }
        }
    }

    for (attempt = 0; attempt < sort_type_count; attempt++) {
        if (SeitonItemBoardSub(board, count) != 0) {
            break;
        }

        sort_top_type += 1;

        if (sort_top_type >= sort_type_count) {
            sort_top_type = 1;
        }
    }

    return 1;
}

int GetSameAdrressUserData(CGameDataUsed *item, int kind) {
    CGameDataUsed *entry = {};
    int            bag_max = {};
    int            i = {};

    if (kind == 0) {
        entry = MenuUserParam.used_data;
        bag_max = GetNowBagMax(ITEM_BOARD_ALL);

        for (i = 0; i < bag_max; i++, entry++) {
            if (entry == item) {
                return i;
            }
        }
    }

    return -1;
}

void local_sort1(int &cursor, int *count, int *list) {
    int i = {};

    for (i = cursor; i < *count; i++) {
        list[i] = list[i + 1];
    }

    *count -= 1;

    if (cursor > 0) {
        cursor -= 1;
    }
}

int GetNowChapter(CSaveData *save) {
    int progress = {};

    if (save == nullptr) {
        return -1;
    }

    progress = save->game_progress;

    if (progress < 2) {
        return 0;
    }

    if (progress == 2 || progress == 3) {
        return 1;
    }

    if (progress >= 4) {
        return progress - 2;
    }

    if (progress >= 100) {
        return 1;
    }

    return 1;
}

u_long128 *MenuCalcBufAlignment(u_long128 *buffer) {
    uptr aligned = {};
    uptr blocks = {};
    sptr size = (sptr) buffer;

    aligned = size;

    if ((size % 64) != 0) {
        blocks = size >> 6;

        if (size < 0) {
            blocks = (size + 0x3F) >> 6;
        }

        aligned = (blocks + 1) << 6;
    }

    return (u_long128 *) aligned;
}

void ConvertFontCode(char *source, char *destination);

int CheckNowEurope() {
    if (LanguageCode > LANG_JAPANESE && LanguageCode < LANG_CHINESE) {
        return true;
    }

    return false;
}

int MenuCommonReadData(mgCMemory *memory, char **names, int mode);

void MenuDeleteTextureBlock(int *blocks) {
    mgCTextureManager *manager = &mgTexManager;
    int                i = 0;
    int                block = {};

    while ((block = blocks[i]) >= 0 && i < 16) {
        manager->DeleteBlock(block);
        i++;
    }
}

void MenuWorkTextureEnter(int id, char *name, int width, int height, int format) {
    mgCTextureManager *manager = &mgTexManager;
    int                width_rest = width % 64;

    if (width_rest != 0) {
        width += 64 - width_rest;
    }

    int height_rest = height % 64;

    if (height_rest != 0) {
        height += 64 - height_rest;
    }

    manager->EnterTexture(id, name, nullptr, width, height, format, nullptr, 0, 0);
}

void MenuEnterIMG(int size, u8 *data, char *name) {
    mgCTextureManager *manager = &mgTexManager;

    if (name == nullptr) {
        manager->name_suffix[0] = 0;
    } else {
        dc2::text::Copy(manager->name_suffix, dc2::text::View(name));
    }

    manager->EnterIMGFile(data, size, nullptr, nullptr);
    manager->name_suffix[0] = 0;
}

void CalcMenu1(float target, float *value, float divisor, float snap_range, int snap) {
    *value += (target - *value) / divisor;

    if (snap != 0 || static_cast<float>(abs(fptosi(target - *value))) < snap_range) {
        *value = target;
    }
}

void CalcMenu1(int target, int *value, int divisor, int snap_range, int snap) {
    *value += (target - *value) / divisor;

    if (snap != 0 || abs(target - *value) < snap_range) {
        *value = target;
    }
}

int CalcMenuAdd(int *cursor, int step, int limit) {
    if (cursor == nullptr) {
        return -1;
    }

    *cursor += step;

    if ((step < 0 && *cursor < limit) || (step > 0 && *cursor > limit)) {
        *cursor = limit;
        return 1;
    }

    return 0;
}

int CalcMenuAdd(float *cursor, float step, float limit) {
    if (cursor == nullptr) {
        return -1;
    }

    *cursor += step;

    if ((step < 0.0f && *cursor < limit) || (step > 0.0f && *cursor > limit)) {
        *cursor = limit;
        return 1;
    }

    return 0;
}

int CalcMenuAdd2(int *value, int delta, int limit) {
    if (value == nullptr) {
        return -1;
    }

    if ((delta < 0) && ((*value + delta) < limit)) {
        return 1;
    }

    if ((delta > 0) && (limit < (*value + delta))) {
        return 1;
    }

    *value += delta;
    return 0;
}

int GetNumberKeta(int value) {
    int digits = 1;
    int number = abs(value);

    while (9 < number) {
        number /= 10;
        digits++;
    }

    return digits;
}

int GetDispVolumeForFloat(float volume) {
    int whole = {};

    whole = fptosi(volume);

    if ((volume - static_cast<float>(whole)) < 0.00005f) {
        return whole;
    }

    return whole + 1;
}

float GetFloatCommaValue(float value) {
    return value - static_cast<float>(fptosi(value));
}

int CalcScrlBarPutPos(int top, float pos, int length, float pos_max) {
    int y = top;

    if (pos_max != 0.0f) {
        y = static_cast<int>(static_cast<float>(top) + length * (pos / pos_max));
    }

    return y;
}

void Trans3DPosTo2DPos(mgCCamera *camera, mgCFrame *frame, int *out) {
    float view[4][4];
    float camera_pos[4];
    float frame_pos[4];

    if (camera == nullptr || frame == nullptr) {
        return;
    }

    camera->GetCameraMatrix(view);
    camera->GetPos(camera_pos);
    mgSetViewMatrix(view, camera_pos);
    frame->GetPosition(frame_pos);
    mgTransWorldScreen(out, frame_pos);
}

/**
 *
 * Copies the referenced texture region's size into a menu form part.
 *
 */
void menu_texdata_to_formpart_copy(MENUFORMPARTS_TYPE *part) {
    MENU_BASETEXINFO *tex = MenuPosData->GetTexGetInfo(part->tex_info_no);
    part->w = 0;
    part->h = 0;

    if (tex != nullptr) {
        part->w = tex->rect.right;
        part->h = tex->rect.bottom;
    }
}

int menu_spi_analyze_func_strcut1(MENU_SPI_ANALYZE_STRUCT1 *table, char *name) {
    int i = 0;

    while (1) {
        char *entry_name = table[i].name;

        if (entry_name == nullptr) {
            break;
        }

        if (strcmp(entry_name, name) == 0) {

            return table[i].value;
        }

        i++;
    }

    return -1;
}

int MenuDataAnalyze(char *script, int size, mgCMemory *memory);

namespace {
/**
 * Selects the language-aware native resource path shared by menu reads.
 */
std::optional<std::string> MenuFilePath(std::string_view member) {
    constexpr std::array<std::string_view, 7> language_directories{"0/", "1/", "2/", "3/", "4/", "5/", "1/"};
    if (LanguageCode < 0 || static_cast<std::size_t>(LanguageCode) >= language_directories.size()) {
        return std::nullopt;
    }
    const bool texture = member.starts_with("textures/");
    if (texture) {
        member.remove_prefix(std::string_view("textures/").size());
    }
    std::string path = texture ? "textures/menu/" : "menu/";
    path += language_directories[static_cast<std::size_t>(LanguageCode)];
    path += member;
    return path;
}
} // namespace

dc2::io::FileRead dc2::menu::ReadMenuFile(std::string_view name) {
    const auto path = MenuFilePath(name);
    return path ? io::ReadFile(*path) : io::FileRead{};
}

int LoadFileMenu(char *name, std::span<u8> destination, int mode) {
    if (!name || destination.empty()) {
        return -1;
    }
    auto path = MenuFilePath(name);
    if (!path) {
        return -1;
    }
    int size = 0;
    if (mode == MENU_FILE_LOAD_BG) {
        LoadFileBG(path->data(), destination, &size);
    } else if (mode == MENU_FILE_LOAD_DIRECT) {
        LoadFile2(path->data(), destination, &size, LOAD_FILE_READ);
    }
    return size;
}

int MenuCommonReadData(mgCMemory *memory, char **names, int mode) {
    StartReadBG();
    memory->Align64();
    int total = 0;
    for (char **entry = names; *entry != nullptr; ++entry) {
        const int size = LoadFileMenu(*entry, dc2::memory::RemainingBytes(*memory), mode);
        if (size <= 0 || total > std::numeric_limits<int>::max() - size) {
            return -1;
        }
        if (memory->Alloc(static_cast<unsigned int>(size) / 16u + (size % 16 != 0)) == nullptr) {
            return -1;
        }
        total += size;
        memory->Align64();
    }
    return total;
}

namespace {

/**
 * Gives a lowercase hexadecimal digit's value, or zero for any other character, as retail's table does.
 */
int FontCodeNibble(char digit) {
    if (digit >= '0' && digit <= '9') {
        return digit - '0';
    }
    if (digit >= 'a' && digit <= 'f') {
        return digit - 'a' + 10;
    }
    return 0;
}

/**
 * Whether a '[' opens a complete nine-byte code such as "[UNI00f4]" that ConvertFontCode replaces.
 */
bool IsFontCode(const char *source) {
    for (int index = 1; index < 9; ++index) {
        if (source[index] == '\0') {
            return false;
        }
    }
    return source[5] == '0' || source[5] == '1';
}

} // namespace

// Retail never moves past a '[' whose sixth byte is not '0' or '1', looping forever, and reads and skips
// nine bytes even when the string ends sooner. Only complete codes are replaced; any other '[' is copied.
void ConvertFontCode(char *source, char *destination) {
    if (source == nullptr || destination == nullptr) {
        return;
    }
    if (!CheckNowEurope()) {
        std::memmove(destination, source, std::strlen(source) + 1);
        return;
    }

    while (*source != '\0') {
        if (*source != '[' || !IsFontCode(source)) {
            *destination++ = *source++;
            continue;
        }

        const auto code = static_cast<s8>((FontCodeNibble(source[6]) << 4) + FontCodeNibble(source[7]));
        if (source[5] == '1' && code == 0x52) {
            *destination = static_cast<char>(0xBD);
        } else if (source[5] == '1' && code == 0x53) {
            *destination = static_cast<char>(0xBE);
        } else {
            *destination = code;
        }
        ++destination;
        source += 9;
    }
    *destination = '\0';
}

namespace {
int cursor_sounds = 0;
} // namespace

// Retail's body; it counts every menu cursor sound, retail or mouse, for tests.
void MenuSePlay(int sound_no) {
    if (sound_no == SYSTEM_SE_CURSOR) {
        ++cursor_sounds;
    }
    if (sound_no >= 0) {
        MenuSePlay(SystemSND_ID, sound_no);
    }
}

int MenuCursorSounds() { return cursor_sounds; }

namespace {

using native_config::Json;

// --- Keyword tables of the retail callbacks ------------------------------------------------------------

/**
 * A script keyword and the value it stands for.
 */
struct Keyword {
    std::string_view name;  /**< Keyword in the game's CP932 encoding. */
    int              value; /**< Value the keyword stands for. */
};

/**
 * Looks a keyword up as menu_spi_analyze_func_strcut1 does, giving -1 when the table lacks it.
 */
template <std::size_t N>
int Lookup(const std::array<Keyword, N> &table, std::string_view name) {
    const auto found = std::ranges::find(table, name, &Keyword::name);
    return found != table.end() ? found->value : -1;
}

/**
 * Form drawing-type keywords of _MENU_FORM_DTYPE.
 */
constexpr std::array<Keyword, 26> kFormDrawTypes = {
    {{.name = "normal", .value = MENUFORM_DTYPE_NORMAL},
     {.name = "itembrd", .value = MENUFORM_DTYPE_ITEMBRD},
     {.name = "giftview", .value = MENUFORM_DTYPE_GIFTVIEW},
     {.name = "msgform", .value = MENUFORM_DTYPE_MSGFORM},
     {.name = "poly", .value = MENUFORM_DTYPE_POLY},
     {.name = "mappart", .value = MENUFORM_DTYPE_MAPPART},
     {.name = "combrd", .value = MENUFORM_DTYPE_COMBRD},
     {.name = "createbrd", .value = MENUFORM_DTYPE_CREATEBRD},
     {.name = "list", .value = MENUFORM_DTYPE_LIST},
     {.name = "bg_tile", .value = MENUFORM_DTYPE_BG_TILE},
     {.name = "dload", .value = MENUFORM_DTYPE_DLOAD},
     {.name = "mainfrm", .value = MENUFORM_DTYPE_MAINFRM},
     {.name = "mainimg", .value = MENUFORM_DTYPE_MAINIMG},
     {.name = "chrstar", .value = MENUFORM_DTYPE_CHRSTAR},
     {.name = "inv_card", .value = MENUFORM_DTYPE_INV_CARD},
     {.name = "geolist", .value = MENUFORM_DTYPE_GEOLIST},
     {.name = "geotitle", .value = MENUFORM_DTYPE_GEOTITLE},
     {.name = "geoana", .value = MENUFORM_DTYPE_GEOANA},
     {.name = "shoplist", .value = MENUFORM_DTYPE_SHOPLIST},
     {.name = "clip", .value = MENUFORM_DTYPE_CLIP},
     {.name = "wmap", .value = MENUFORM_DTYPE_WMAP},
     {.name = "buildup", .value = MENUFORM_DTYPE_BUILDUP},
     {.name = "mosbaji", .value = MENUFORM_DTYPE_MOSBAJI},
     {.name = "savelist", .value = MENUFORM_DTYPE_SAVELIST},
     {.name = "infocur", .value = MENUFORM_DTYPE_INFOCUR},
     {.name = "house", .value = MENUFORM_DTYPE_HOUSE}}
};

/**
 * Movement keywords of _MENU_FORM_MTYPE, each standing for its MENUFORM_MTYPE.
 */
constexpr std::array<Keyword, 5> kMoveTypes = {
    {{.name = "n", .value = MENUFORM_MTYPE_N}, {.name = "d", .value = MENUFORM_MTYPE_D}, {.name = "l", .value = MENUFORM_MTYPE_L}, {.name = "i", .value = MENUFORM_MTYPE_I}, {.name = "ir", .value = MENUFORM_MTYPE_IR}}
};

/**
 * Part drawing-type keywords of _MENU_PART_DTYPE.
 */
constexpr std::array<Keyword, 6> kPartDrawTypes = {
    {{.name = "clut_reload", .value = MENUFORMPARTS_DTYPE_CLUT_RELOAD},
     {.name = "\x94\xAD\x96\xBE\x83l\x83^", .value = MENUFORMPARTS_DTYPE_IDEA_BOARD},
     {.name = "\x83"
              "A\x83\x8B\x83o\x83\x80",
      .value = MENUFORMPARTS_DTYPE_ALBUM},
     {.name = "\x82\xB2\x82\xBF\x82\xE1\x90\xFC", .value = MENUFORMPARTS_DTYPE_RANDOM_LINE},
     {.name = "font", .value = MENUFORMPARTS_DTYPE_FONT},
     {.name = "\x83l\x83^\x92\xA0", .value = MENUFORMPARTS_DTYPE_IDEA_MEMO}}
};

/**
 * Frame-image keywords of _MENU_FRMIMG.
 */
constexpr std::array<Keyword, 2> kFrameImageTypes = {
    {{.name = "bg", .value = MENUFORMPARTS_DTYPE_BG}, {.name = "beta", .value = MENUFORMPARTS_DTYPE_BETA}}
};

/**
 * Item-icon keywords of _MENU_ITEM.
 */
constexpr std::array<Keyword, 2> kItemTypes = {
    {{.name = "trs", .value = MENUFORMPARTS_DTYPE_TRS}, {.name = "neta", .value = MENUFORMPARTS_DTYPE_NETA}}
};

/**
 * Filled-box keywords of _MENU_FILLBOX.
 */
constexpr std::array<Keyword, 1> kFillBoxTypes = {
    {{.name = "sq_beta", .value = MENUFORMPARTS_DTYPE_SQ_BETA}}};

/**
 * Animation keywords of _MENU_PARTS_EFFECT.
 */
constexpr std::array<Keyword, 6> kEffectTypes = {
    {{.name = "blink", .value = MENU_PARTS_EFFECT_BLINK},
     {.name = "rot", .value = MENU_PARTS_EFFECT_ROT},
     {.name = "huriko", .value = MENU_PARTS_EFFECT_HURIKO},
     {.name = "stretch", .value = MENU_PARTS_EFFECT_STRETCH},
     {.name = "stretch_rep", .value = MENU_PARTS_EFFECT_STRETCH_REP},
     {.name = "stretch_sin", .value = MENU_PARTS_EFFECT_STRETCH_SIN}}
};

/**
 * Message preset keywords of _MENU_EXE_MSGENV.
 */
constexpr std::array<Keyword, 20> kMessagePresets = {
    {{.name = "default", .value = MENU_SCRIPT_MES_DEFAULT},
     {.name = "default_black", .value = MENU_SCRIPT_MES_DEFAULT_BLACK},
     {.name = "no_win", .value = MENU_SCRIPT_MES_NO_WIN},
     {.name = "system", .value = MENU_SCRIPT_MES_SYSTEM},
     {.name = "name", .value = MENU_SCRIPT_MES_NAME},
     {.name = "name_black", .value = MENU_SCRIPT_MES_NAME_BLACK},
     {.name = "itemcmd", .value = MENU_SCRIPT_MES_ITEMCMD},
     {.name = "invent", .value = MENU_SCRIPT_MES_INVENT},
     {.name = "geo", .value = MENU_SCRIPT_MES_GEO},
     {.name = "msgdic", .value = MENU_SCRIPT_MES_MSGDIC},
     {.name = "general", .value = MENU_SCRIPT_MES_GENERAL},
     {.name = "general_2", .value = MENU_SCRIPT_MES_GENERAL_2},
     {.name = "yesno", .value = MENU_SCRIPT_MES_YESNO},
     {.name = "brd3", .value = MENU_SCRIPT_MES_BRD3},
     {.name = "helpwin", .value = MENU_SCRIPT_MES_HELPWIN},
     {.name = "makebrd", .value = MENU_SCRIPT_MES_MAKEBRD},
     {.name = "itemmsg", .value = MENU_SCRIPT_MES_ITEMMSG},
     {.name = "itemmsg_defaultfuchi", .value = MENU_SCRIPT_MES_ITEMMSG_DEFAULTFUCHI},
     {.name = "volmsg", .value = MENU_SCRIPT_MES_VOLMSG},
     {.name = "talk", .value = MENU_SCRIPT_MES_TALK}}
};

/**
 * Font-outline keywords of _MENU_EXE_MSGSETFUCHI.
 */
constexpr std::array<Keyword, 3> kOutlines = {
    {{.name = "default", .value = FUCHI_SHADOW_BLACK_WIDE}, {.name = "none", .value = FUCHI_NONE}, {.name = "ol2", .value = FUCHI_OUTLINE_THICK}}
};

/**
 * Sound keywords of _MENU_SE_PLAY.
 */
constexpr std::array<Keyword, 2> kSounds = {
    {{.name = "OK", .value = SYSTEM_SE_DECIDE}, {.name = "CANCEL", .value = SYSTEM_SE_CANCEL}}
};

/**
 * Number of effect records a filled box allocates for each fill style.
 */
constexpr std::array<u8, 4> kFillEffectCounts = {1, 2, 2, 4};

/**
 * Integer extra-information entries a table holds when its allocation gives no count.
 */
constexpr int kDefaultEtcCount = 96;

/**
 * Texture records the table holds when its allocation gives no count.
 */
constexpr int kDefaultTextureCount = 256;

/**
 * Passes document text to a retail function that takes a mutable string it only reads.
 */
char *Arg(const std::string &text) { return const_cast<char *>(text.c_str()); }

// --- menu_layout ----------------------------------------------------------------------------------------

/**
 * Table of the menu position manager an operation acts on.
 */
enum class LayoutTable {
    EtcInfo,  /**< Named integer pairs. */
    EtcInfo2, /**< Named sets of numbers. */
    Textures, /**< Named texture rectangles. */
    Forms     /**< Forms. */
};

/**
 * Allocates one of the manager's tables from the layout memory.
 */
struct AllocateOp {
    LayoutTable        table{}; /**< Table to allocate. */
    std::optional<int> count;   /**< Entries, or the table's default count. */
};

/**
 * Clears a range of one of the manager's tables.
 */
struct ClearOp {
    LayoutTable        table{}; /**< Table to clear. */
    std::optional<int> from;    /**< First entry; absent clears the forms' default range. */
    std::optional<int> to;      /**< Entry after the last, or the table's end. */
};

/**
 * Moves the cursor that following entries of a table are stored at.
 */
struct OffsetOp {
    LayoutTable table{}; /**< Table whose cursor moves; both extra-information tables share one. */
    int         index{}; /**< First entry index. */
};

/**
 * Rebuilds the form draw list.
 */
struct InitDrawListOp {};

/**
 * Resets every texture rectangle's texture.
 */
struct ResetTexInfoOp {};

/**
 * Named integer pair stored at the extra-information cursor.
 */
struct EtcInfoEntry {
    std::string        name;     /**< Name the entry is looked up by. */
    std::array<int, 2> values{}; /**< Values. */
};

/**
 * Named set of numbers stored at the extra-information cursor.
 */
struct EtcInfo2Entry {
    std::string        name;   /**< Name the entry is looked up by. */
    std::vector<float> values; /**< Values, at most four of which are stored. */
};

/**
 * Run of integer extra-information entries.
 */
struct EtcInfoOp {
    std::vector<EtcInfoEntry> entries; /**< Entries in script order. */
};

/**
 * Run of floating-point extra-information entries.
 */
struct EtcInfo2Op {
    std::vector<EtcInfo2Entry> entries; /**< Entries in script order. */
};

/**
 * Named texture rectangle stored at the texture cursor.
 */
struct TextureEntry {
    std::string        name;   /**< Name the rectangle is looked up by. */
    std::array<int, 4> rect{}; /**< x, y, width and height. */
};

/**
 * Texture rectangles, optionally after selecting the texture sheet they are cut from.
 */
struct TexturesOp {
    bool                       selects_sheet = false; /**< Whether the operation selects a sheet first. */
    std::optional<std::string> sheet;                 /**< Sheet name; absent keeps the previous one. */
    int                        block_slot = 0;        /**< Entry of the menu's texture blocks holding the sheet. */
    std::vector<TextureEntry>  textures;              /**< Rectangles in script order. */
};

/**
 * Allocates the current form's parts.
 */
struct PartsCapacitySetting {
    int count{}; /**< Number of parts. */
};

/**
 * Selects the current form's drawing type and its type-specific data.
 */
struct DrawTypeSetting {
    std::optional<std::string>          type;    /**< Drawing-type keyword; absent leaves the form unchanged. */
    std::optional<std::array<float, 4>> ambient; /**< Ambient light of a "poly" form. */
    std::optional<int>                  list;    /**< List a "geolist" form draws. */
};

/**
 * Selects the current form's movement type.
 */
struct MoveTypeSetting {
    std::string type; /**< Movement keyword. */
};

/**
 * Shows or hides the current form.
 */
struct DrawFlagSetting {
    int draw{}; /**< Non-zero to draw. */
};

/**
 * Shows or hides another named form while the current form is being defined.
 */
struct OtherFormDrawFlagSetting {
    std::string form;   /**< Form to change. */
    int         draw{}; /**< Non-zero to draw. */
};

/**
 * Sets the current form's sway periods.
 */
struct VibeCountSetting {
    std::array<int, 2> counts{}; /**< Horizontal and vertical half periods. */
};

/**
 * Sets the current form's movement rates.
 */
struct MoveRateSetting {
    std::array<float, 2> rate{}; /**< Horizontal and vertical rates. */
};

/**
 * Sets the current form's screen position.
 */
struct PositionSetting {
    std::array<int, 2> xy{}; /**< Screen position. */
};

/**
 * Sets the current form's colour.
 */
struct RgbaSetting {
    std::vector<int> rgba; /**< Red, green and blue, optionally followed by alpha. */
};

/**
 * Selects the colour channels the current form animates.
 */
struct RgbaBitsSetting {
    std::string channels; /**< Channel letters among "rgba". */
};

/**
 * Named movement action of a form.
 */
struct ActionDefinition {
    std::string          name;        /**< Name the action is set by. */
    int                  move_type{}; /**< MENUFORM_MTYPE of the movement. */
    std::array<float, 2> xy{};        /**< Target position. */
    std::array<float, 2> rate{};      /**< Horizontal and vertical rates. */
};

/**
 * Allocates the current form's action table and defines its actions.
 */
struct ActionsSetting {
    int                           capacity{}; /**< Entries of the table. */
    std::vector<ActionDefinition> actions;    /**< Actions stored from the table's start. */
};

/**
 * Starts one of the current form's actions.
 */
struct ActionSetting {
    std::string name; /**< Action name. */
};

/**
 * Sets the current form's clipping size.
 */
struct ClipSetting {
    std::optional<std::array<int, 2>> size; /**< Width and height, or the screen size less one. */
};

/**
 * One attribute of a form, in script order.
 */
using FormSetting =
    std::variant<PartsCapacitySetting, DrawTypeSetting, MoveTypeSetting, DrawFlagSetting, OtherFormDrawFlagSetting, VibeCountSetting, MoveRateSetting,
                 PositionSetting, RgbaSetting, RgbaBitsSetting, ActionsSetting, ActionSetting, ClipSetting>;

/**
 * Drop shadow of the current part.
 */
struct ShadowModifier {
    std::optional<int> on;     /**< Non-zero to draw the shadow; absent draws it. */
    std::optional<int> offset; /**< Shadow offset; absent uses four pixels. */
};

/**
 * Colour of the current part.
 */
struct PartRgbaModifier {
    std::vector<int> rgba; /**< Alpha alone, red, green and blue, or all four channels. */
};

/**
 * Blend equation of the current part.
 */
struct AlphaBlendModifier {
    int mode{}; /**< Blend equation. */
};

/**
 * Extra values of the current part.
 */
struct PartEtcInfoModifier {
    std::vector<std::pair<int, int>> entries; /**< Index and value of each extra value set. */
};

/**
 * Bilinear sampling of the current part.
 */
struct BilinearModifier {};

/**
 * Sway periods of the current part.
 */
struct PartVibeCountModifier {
    std::array<int, 2> counts{}; /**< Horizontal and vertical half periods. */
};

/**
 * Sway amplitudes of the current part.
 */
struct ViberModifier {
    std::array<int, 2> ranges{}; /**< Horizontal and vertical amplitudes. */
};

/**
 * Allocates the current part's effect records.
 */
struct EffectCapacityModifier {
    int count{}; /**< Number of records. */
};

/**
 * Configures the next effect record.
 */
struct EffectModifier {
    std::optional<std::string> type;   /**< Animation keyword; absent configures nothing. */
    std::vector<int>           params; /**< Parameters, at most eight of which are stored. */
};

/**
 * Stores a fill colour into the next effect record.
 */
struct FillModifier {
    std::array<int, 4> rgba{}; /**< Fill colour. */
};

/**
 * One change to the current part or the effect records last allocated, in script order.
 */
using PartModifier = std::variant<ShadowModifier, PartRgbaModifier, AlphaBlendModifier, PartEtcInfoModifier, BilinearModifier, PartVibeCountModifier,
                                  ViberModifier, EffectCapacityModifier, EffectModifier, FillModifier>;

/**
 * Callback that creates a kind of part.
 */
enum class PartKind {
    Normal,        /**< _MENU_NORMAL. */
    Normal2,       /**< _MENU_NORMAL2. */
    Cursor,        /**< _MENU_CURSOR. */
    FuncInfo,      /**< _MENU_FUNCINFO. */
    Number1,       /**< _MENU_NUMBER1. */
    Number2,       /**< _MENU_NUMBER2. */
    FrameImage,    /**< _MENU_FRMIMG. */
    Form,          /**< _MENU_FORM. */
    Item,          /**< _MENU_ITEM. */
    ItemCheckmark, /**< _MENU_ITEM_CHECKMARK. */
    FillBox,       /**< _MENU_FILLBOX. */
    WakuRect,      /**< _MENU_WAKU_RECT. */
    WakuCircle,    /**< _MENU_WAKU_CIRCLE. */
    DrawType       /**< _MENU_PART_DTYPE. */
};

/**
 * One part entered into the current form, with the modifiers that follow it.
 */
struct Part {
    PartKind                          kind{};    /**< Callback that creates the part. */
    std::string                       name;      /**< Part name. */
    std::string                       texture;   /**< Texture rectangle name, for textured parts. */
    std::string                       type;      /**< Drawing-type keyword, for parts that look one up. */
    int                               form = 0;  /**< Referenced form's texture-information index. */
    int                               value = 0; /**< Number part's first extra value. */
    int                               style = 0; /**< Fill style of a filled box. */
    std::array<int, 2>                xy{};      /**< Position relative to the form. */
    std::optional<std::array<int, 2>> size;      /**< Width and height, when given. */
    std::vector<int>                  etc_info;  /**< Extra values of a "clut_reload" part. */
    std::vector<PartModifier>         modifiers; /**< Modifiers in script order. */
};

/**
 * Defines one form: its slot, attributes and parts.
 */
struct FormOp {
    std::string              name;     /**< Form name. */
    std::optional<int>       slot;     /**< Index after the form cursor's base, or the running index. */
    std::vector<FormSetting> settings; /**< Attributes in script order. */
    std::vector<Part>        parts;    /**< Parts in script order. */
};

/**
 * One step of a menu layout.
 */
using LayoutOp = std::variant<AllocateOp, ClearOp, OffsetOp, InitDrawListOp, ResetTexInfoOp, EtcInfoOp, EtcInfo2Op, TexturesOp, FormOp>;

/**
 * Typed contents of a menu_layout document.
 */
struct MenuLayout {
    std::vector<LayoutOp> operations; /**< Steps in script order. */
};

/**
 * Reads a required string field that must fit a retail buffer of the given size.
 */
std::string BoundedText(const Json &object, const char *key, std::size_t capacity) {
    auto text = native_config::Text(object, key);
    if (text.size() >= capacity) {
        throw std::runtime_error(std::string(key) + " is too long");
    }
    return text;
}

/**
 * Reads a count that retail turns into an allocation size.
 */
int Count(const Json &object, const char *key, int limit) {
    const int count = native_config::Int(object, key);
    if (count < 0 || count > limit) {
        throw std::runtime_error(std::string(key) + " is out of range");
    }
    return count;
}

/**
 * Reads an optional allocation count.
 */
std::optional<int> OptionalCount(const Json &object, const char *key, int limit) {
    if (!object.contains(key)) {
        return std::nullopt;
    }
    return Count(object, key, limit);
}

/**
 * Reads an optional fixed-length integer pair.
 */
std::optional<std::array<int, 2>> OptionalPair(const Json &object, const char *key) {
    if (!object.contains(key)) {
        return std::nullopt;
    }
    return native_config::Ints<2>(object, key);
}

/**
 * Reads an integer list whose length must be one of the given counts.
 */
std::vector<int> IntsOfLength(const Json &object, const char *key, std::initializer_list<std::size_t> lengths) {
    auto values = native_config::IntList(object, key);
    if (std::ranges::find(lengths, values.size()) == lengths.end()) {
        throw std::runtime_error(std::string(key) + " has an unexpected length");
    }
    return values;
}

FormSetting ParseSetting(const Json &setting) {
    using namespace native_config;
    const std::string kind = Text(setting, "set");
    // The table of entries a "u16" count field of the manager or a form can describe.
    constexpr int count_limit = 0x7FFF;
    if (kind == "parts_capacity") {
        return PartsCapacitySetting{.count = Count(setting, "count", count_limit)};
    }
    if (kind == "draw_type") {
        DrawTypeSetting out{.type = OptionalText(setting, "type"), .ambient = std::nullopt, .list = OptionalInt(setting, "list")};
        if (setting.contains("ambient")) {
            out.ambient = Floats<4>(setting, "ambient");
        }
        if (out.type == "geolist" && !out.list) {
            throw std::runtime_error("geolist form without its list");
        }
        return out;
    }
    if (kind == "move_type") {
        return MoveTypeSetting{.type = Text(setting, "type")};
    }
    if (kind == "draw_flag") {
        return DrawFlagSetting{.draw = Int(setting, "draw")};
    }
    if (kind == "other_form_draw_flag") {
        return OtherFormDrawFlagSetting{.form = Text(setting, "form"), .draw = Int(setting, "draw")};
    }
    if (kind == "vibe_count") {
        return VibeCountSetting{.counts = Ints<2>(setting, "counts")};
    }
    if (kind == "move_rate") {
        return MoveRateSetting{.rate = Floats<2>(setting, "rate")};
    }
    if (kind == "position") {
        return PositionSetting{.xy = Ints<2>(setting, "xy")};
    }
    if (kind == "rgba") {
        return RgbaSetting{.rgba = IntsOfLength(setting, "rgba", {3, 4})};
    }
    if (kind == "rgba_bits") {
        return RgbaBitsSetting{.channels = Text(setting, "channels")};
    }
    if (kind == "actions") {
        ActionsSetting out{.capacity = Count(setting, "capacity", count_limit), .actions = {}};
        for (const auto &action : Array(setting, "actions")) {
            out.actions.push_back({.name = BoundedText(action, "name", sizeof(MENU_FORM_ACTION::name)),
                                   .move_type = Int(action, "move_type"),
                                   .xy = Floats<2>(action, "xy"),
                                   .rate = Floats<2>(action, "rate")});
        }
        return out;
    }
    if (kind == "action") {
        return ActionSetting{.name = Text(setting, "name")};
    }
    if (kind == "clip") {
        return ClipSetting{.size = OptionalPair(setting, "size")};
    }
    throw std::runtime_error("unknown form setting " + kind);
}

PartModifier ParseModifier(const Json &modifier) {
    using namespace native_config;
    const std::string kind = Text(modifier, "mod");
    if (kind == "shadow") {
        return ShadowModifier{.on = OptionalInt(modifier, "on"), .offset = OptionalInt(modifier, "offset")};
    }
    if (kind == "alpha") {
        return PartRgbaModifier{.rgba = {Int(modifier, "alpha")}};
    }
    if (kind == "rgba") {
        return PartRgbaModifier{.rgba = IntsOfLength(modifier, "rgba", {3, 4})};
    }
    if (kind == "alpha_blend") {
        return AlphaBlendModifier{.mode = Int(modifier, "mode")};
    }
    if (kind == "etc_info") {
        PartEtcInfoModifier out;
        for (const auto &entry : Array(modifier, "entries")) {
            out.entries.emplace_back(Int(entry, "index"), Int(entry, "value"));
        }
        return out;
    }
    if (kind == "bilinear") {
        return BilinearModifier{};
    }
    if (kind == "vibe_count") {
        return PartVibeCountModifier{.counts = Ints<2>(modifier, "counts")};
    }
    if (kind == "viber") {
        return ViberModifier{.ranges = Ints<2>(modifier, "ranges")};
    }
    if (kind == "effect_capacity") {
        return EffectCapacityModifier{.count = Int(modifier, "count")};
    }
    if (kind == "effect") {
        return EffectModifier{.type = OptionalText(modifier, "type"), .params = IntList(modifier, "params")};
    }
    if (kind == "fill") {
        return FillModifier{.rgba = Ints<4>(modifier, "rgba")};
    }
    throw std::runtime_error("unknown part modifier " + kind);
}

Part ParsePart(const Json &part) {
    using namespace native_config;
    static const std::map<std::string, PartKind, std::less<>> kinds = {
        {"normal",         PartKind::Normal       },
        {"normal2",        PartKind::Normal2      },
        {"cursor",         PartKind::Cursor       },
        {"funcinfo",       PartKind::FuncInfo     },
        {"number1",        PartKind::Number1      },
        {"number2",        PartKind::Number2      },
        {"frame_image",    PartKind::FrameImage   },
        {"form",           PartKind::Form         },
        {"item",           PartKind::Item         },
        {"item_checkmark", PartKind::ItemCheckmark},
        {"fillbox",        PartKind::FillBox      },
        {"waku_rect",      PartKind::WakuRect     },
        {"waku_circle",    PartKind::WakuCircle   },
        {"dtype",          PartKind::DrawType     },
    };
    const auto found = kinds.find(Text(part, "part"));
    if (found == kinds.end()) {
        throw std::runtime_error("unknown part kind");
    }
    Part out{.kind = found->second, .name = Text(part, "name")};
    out.xy = part.contains("xy") ? Ints<2>(part, "xy") : std::array<int, 2>{};
    out.size = OptionalPair(part, "size");
    switch (out.kind) {
        case PartKind::Normal:
        case PartKind::Normal2:
        case PartKind::WakuRect:
        case PartKind::WakuCircle:
            out.texture = Text(part, "texture");
            break;
        case PartKind::Number1:
        case PartKind::Number2:
            out.texture = Text(part, "texture");
            out.value = Int(part, "value");
            break;
        case PartKind::FrameImage:
            out.type = Text(part, "kind");
            out.texture = Text(part, "texture");
            break;
        case PartKind::Form:
            out.form = Int(part, "form");
            break;
        case PartKind::Item:
            out.type = Text(part, "kind");
            break;
        case PartKind::FillBox:
            out.type = Text(part, "kind");
            out.style = Int(part, "style");
            break;
        case PartKind::DrawType:
            out.type = Text(part, "kind");
            out.etc_info = part.contains("etc_info") ? IntList(part, "etc_info") : std::vector<int>{};
            break;
        case PartKind::Cursor:
        case PartKind::FuncInfo:
        case PartKind::ItemCheckmark:
            break;
    }
    const bool positioned = out.kind != PartKind::DrawType || Lookup(kPartDrawTypes, out.type) == MENUFORMPARTS_DTYPE_RANDOM_LINE;
    if (positioned && !part.contains("xy")) {
        throw std::runtime_error("part without a position");
    }
    const bool sized = out.kind == PartKind::FrameImage || out.kind == PartKind::FillBox || out.kind == PartKind::WakuRect || out.kind == PartKind::WakuCircle ||
                       (out.kind == PartKind::DrawType && positioned);
    if (sized && !out.size) {
        throw std::runtime_error("part without a size");
    }
    for (const auto &modifier : OptionalArray(part, "modifiers")) {
        out.modifiers.push_back(ParseModifier(modifier));
    }
    return out;
}

std::vector<TextureEntry> ParseTextures(const Json &op) {
    std::vector<TextureEntry> out;
    for (const auto &texture : native_config::Array(op, "textures")) {
        out.push_back({.name = native_config::Text(texture, "name"), .rect = native_config::Ints<4>(texture, "rect")});
    }
    return out;
}

LayoutOp ParseLayoutOp(const Json &op) {
    using namespace native_config;
    // Retail stores table counts in u16 fields.
    constexpr int     table_limit = 0xFFFF;
    const std::string kind = Text(op, "op");
    if (kind == "allocate_etc_info") {
        return AllocateOp{.table = LayoutTable::EtcInfo, .count = OptionalCount(op, "count", table_limit)};
    }
    if (kind == "allocate_etc_info2") {
        return AllocateOp{.table = LayoutTable::EtcInfo2, .count = OptionalCount(op, "count", table_limit)};
    }
    if (kind == "allocate_textures") {
        return AllocateOp{.table = LayoutTable::Textures, .count = OptionalCount(op, "count", table_limit)};
    }
    if (kind == "allocate_forms") {
        return AllocateOp{.table = LayoutTable::Forms, .count = Count(op, "count", table_limit)};
    }
    if (kind == "clear_etc_info" || kind == "clear_etc_info2" || kind == "clear_textures" || kind == "clear_forms") {
        static const std::map<std::string, LayoutTable, std::less<>> tables = {
            {"clear_etc_info",  LayoutTable::EtcInfo },
            {"clear_etc_info2", LayoutTable::EtcInfo2},
            {"clear_textures",  LayoutTable::Textures},
            {"clear_forms",     LayoutTable::Forms   },
        };
        const LayoutTable table = tables.at(kind);
        ClearOp           out{.table = table, .from = OptionalInt(op, "from"), .to = OptionalInt(op, "to")};
        if ((table != LayoutTable::Forms && !out.from) || (table == LayoutTable::Forms && out.from.has_value() != out.to.has_value())) {
            throw std::runtime_error(kind + " with an incomplete range");
        }
        return out;
    }
    if (kind == "etc_info_offset" || kind == "etc_info2_offset") {
        return OffsetOp{.table = LayoutTable::EtcInfo, .index = Int(op, "index")};
    }
    if (kind == "texture_offset") {
        return OffsetOp{.table = LayoutTable::Textures, .index = Int(op, "index")};
    }
    if (kind == "form_offset") {
        return OffsetOp{.table = LayoutTable::Forms, .index = Int(op, "index")};
    }
    if (kind == "init_drawlist") {
        return InitDrawListOp{};
    }
    if (kind == "reset_texinfo") {
        return ResetTexInfoOp{};
    }
    if (kind == "etc_info") {
        EtcInfoOp out;
        for (const auto &entry : Array(op, "entries")) {
            out.entries.push_back({.name = Text(entry, "name"), .values = Ints<2>(entry, "values")});
        }
        return out;
    }
    if (kind == "etc_info2") {
        EtcInfo2Op out;
        for (const auto &entry : Array(op, "entries")) {
            EtcInfo2Entry parsed{.name = Text(entry, "name"), .values = {}};
            for (const auto &value : Array(entry, "values")) {
                parsed.values.push_back(Float(value));
            }
            out.entries.push_back(std::move(parsed));
        }
        return out;
    }
    if (kind == "texture_sheet") {
        TexturesOp out{.selects_sheet = true, .sheet = OptionalText(op, "sheet"), .block_slot = Int(op, "block_slot"), .textures = ParseTextures(op)};
        if (out.sheet && out.sheet->size() >= sizeof(MenuSpiTextureName)) {
            throw std::runtime_error("texture sheet name is too long");
        }
        if (out.block_slot < 0 || std::cmp_greater_equal(out.block_slot, std::extent_v<decltype(CMenuKeyFunc::tex_block)>)) {
            throw std::runtime_error("texture block slot is out of range");
        }
        return out;
    }
    if (kind == "textures") {
        return TexturesOp{.selects_sheet = false, .sheet = std::nullopt, .block_slot = 0, .textures = ParseTextures(op)};
    }
    if (kind == "form") {
        FormOp out{.name = Text(op, "name"), .slot = OptionalInt(op, "slot"), .settings = {}, .parts = {}};
        for (const auto &setting : Array(op, "settings")) {
            out.settings.push_back(ParseSetting(setting));
        }
        for (const auto &part : Array(op, "parts")) {
            out.parts.push_back(ParsePart(part));
        }
        return out;
    }
    throw std::runtime_error("unknown layout operation " + kind);
}

MenuLayout ParseLayout(const Json &document) {
    MenuLayout layout;
    for (const auto &op : native_config::Array(document, "operations")) {
        layout.operations.push_back(ParseLayoutOp(op));
    }
    return layout;
}

/**
 * Effect records left at menu_parts_effect_ptr in the table last allocated, which retail writes past.
 */
int effect_room = 0;

/**
 * Allocates count records of a type from the layout memory.
 */
template <typename T>
T *AllocateRecords(int count) {
    if (count < 0 || MenuSpiStack == nullptr) {
        throw std::length_error("invalid menu layout allocation");
    }
    if (count == 0) {
        return nullptr;
    }
    auto *records = dc2::memory::NewArray<T>(*MenuSpiStack, static_cast<std::size_t>(count));
    if (records == nullptr) {
        throw std::length_error("menu layout storage is unavailable");
    }
    if constexpr (std::is_aggregate_v<T>) {
        std::fill_n(records, count, T{});
    }
    return records;
}

void Apply(const AllocateOp &op) {
    CPosDataManage *data = MenuPosData;
    switch (op.table) {
        case LayoutTable::EtcInfo: {
            const int count = op.count.value_or(kDefaultEtcCount);
            data->etc_tbl = AllocateRecords<MENU_ETCINFO>(count);
            data->etc_tbl_num = count;
            MenuPosData->EtcTblClear(0, count);
            break;
        }
        case LayoutTable::EtcInfo2: {
            const int count = op.count.value_or(kDefaultEtcCount);
            data->etc_tbl2 = AllocateRecords<MENU_ETCINFO2>(count);
            data->etc_tbl2_num = count;
            MenuPosData->EtcTbl2Clear(0, count);
            break;
        }
        case LayoutTable::Textures: {
            const int count = op.count.value_or(kDefaultTextureCount);
            data->tex_info = AllocateRecords<MENU_BASETEXINFO>(count);
            data->tex_info_num = count;
            break;
        }
        case LayoutTable::Forms: {
            const int count = op.count.value_or(0);
            data->form = AllocateRecords<CMenuPosDataForm>(count);
            data->form_num = count;
            MenuPosData->FormInfoClear(0, count);
            break;
        }
    }
}

void Apply(const ClearOp &op) {
    CPosDataManage *data = MenuPosData;
    // A range end past the table, or none, clears to the table's end.
    const auto end = [&op](int limit, int fallback) {
        const int to = op.to.value_or(fallback);
        return !op.to || limit < to ? limit : to;
    };
    switch (op.table) {
        case LayoutTable::EtcInfo:
            data->EtcTblClear(op.from.value_or(0), end(data->etc_tbl_num, 1000));
            break;
        case LayoutTable::EtcInfo2:
            data->EtcTbl2Clear(op.from.value_or(0), end(data->etc_tbl2_num, 1000));
            break;
        case LayoutTable::Textures:
            data->TexGetInfoClear(op.from.value_or(0), end(data->tex_info_num, 500));
            break;
        case LayoutTable::Forms:
            MenuPosData->FormInfoClear(op.from.value_or(0), op.to.value_or(100));
            MenuPosData->InitDrawList();
            break;
    }
}

void Apply(const OffsetOp &op) {
    switch (op.table) {
        case LayoutTable::EtcInfo:
        case LayoutTable::EtcInfo2:
            Menu_Target_No = op.index;
            Menu_Target_No_local = 0;
            break;
        case LayoutTable::Textures:
            MenuTexPosNo = op.index;
            MenuTexPosNo_local = 0;
            break;
        case LayoutTable::Forms:
            menu_analyze_formno = op.index;
            menu_analyze_formno_offset = 0;
            break;
    }
}

void Apply(const InitDrawListOp & /*op*/) { MenuPosData->InitDrawList(); }

void Apply(const ResetTexInfoOp & /*op*/) { MenuPosData->ResetTextureInfoAll(); }

void Apply(const EtcInfoOp &op) {
    for (const auto &entry : op.entries) {
        const int index = Menu_Target_No + Menu_Target_No_local;
        // An entry that already has a name keeps it and its values, and the cursor stays.
        if (index < 0 || std::cmp_greater_equal(index, MenuPosData->etc_tbl_num) || MenuPosData->etc_tbl[index].name != nullptr) {
            continue;
        }
        MENU_ETCINFO &slot = MenuPosData->etc_tbl[index];
        slot.name = mgCopyString(Arg(entry.name), MenuSpiStack);
        slot.value[0] = entry.values[0];
        slot.value[1] = entry.values[1];
        Menu_Target_No_local++;
    }
}

void Apply(const EtcInfo2Op &op) {
    for (const auto &entry : op.entries) {
        const int index = Menu_Target_No + Menu_Target_No_local;
        if (index < 0 || std::cmp_greater_equal(index, MenuPosData->etc_tbl2_num)) {
            continue;
        }
        MENU_ETCINFO2 &slot = MenuPosData->etc_tbl2[index];
        // Retail compares the slot with itself once per earlier index, so only a slot past the first that already
        // has this name is kept; any other slot is renamed and refilled.
        if (slot.name != nullptr && index > 0 && entry.name == slot.name) {
            continue;
        }
        slot.name = mgCopyString(Arg(entry.name), MenuSpiStack);
        const std::size_t count = std::min(entry.values.size(), std::size(slot.value));
        for (std::size_t value = 0; value < count; ++value) {
            slot.value[value] = entry.values[value];
        }
        Menu_Target_No_local++;
    }
}

void Apply(const TexturesOp &op) {
    if (op.selects_sheet) {
        if (op.sheet) {
            dc2::text::Copy(MenuSpiTextureName, *op.sheet);
        }
        menu_analyze_texblock = MenuCommonInfo->tex_block[op.block_slot];
    }
    for (const auto &texture : op.textures) {
        const int         no = MenuTexPosNo + MenuTexPosNo_local;
        MENU_BASETEXINFO *slot = MenuPosData->GetTexGetInfo(no);
        if (slot == nullptr || MenuPosData->GetTexGetInfo(Arg(texture.name)) != nullptr) {
            continue;
        }
        slot->tex_name = mgCopyString(MenuSpiTextureName, MenuSpiStack);
        slot->tex_block = menu_analyze_texblock;
        slot->tbl_no = no;
        slot->name = mgCopyString(Arg(texture.name), MenuSpiStack);
        slot->rect.Set(texture.rect[0], texture.rect[1], texture.rect[2], texture.rect[3]);
        MenuTexPosNo_local += 1;
    }
}

/**
 * Initializes the drawing type's own data of the current form, as menu_dtype_init does.
 */
void InitDrawType(CMenuPosDataForm *form, const DrawTypeSetting &setting) {
    if (form->dtype == MENUFORM_DTYPE_POLY) {
        form->ambient[0] = 64.0f;
        form->ambient[1] = 64.0f;
        form->ambient[2] = 64.0f;
        form->ambient[3] = 128.0f;
        if (setting.ambient) {
            std::ranges::copy(*setting.ambient, form->ambient);
        }
    } else if (form->dtype == MENUFORM_DTYPE_ITEMBRD) {
        form->parts_num = 150;
        form->parts = AllocateRecords<MENUFORMPARTS_TYPE>(form->parts_num);
        MenuItemBrdItemIconEffectMalloc(MenuSpiStack, form->parts, form->parts_num);
    } else if (form->dtype == MENUFORM_DTYPE_GEOLIST) {
        form->sub_no = setting.list.value_or(0);
    } else if (form->dtype == MENUFORM_DTYPE_MSGFORM) {
        // The message window is the digit at the name's fourth character, as in "msg0".
        const char digit[2] = {std::strlen(form->name) > 3 ? form->name[3] : '\0', '\0'};
        form->sub_no = std::strtol(digit, nullptr, 10);
    }
}

/**
 * Applies one attribute to the current form; every attribute needs one.
 */
void ApplySetting(const FormSetting &setting) {
    CMenuPosDataForm *form = menu_formPt;
    if (form == nullptr) {
        return;
    }
    std::visit(
        [form](const auto &value) {
            using T = std::decay_t<decltype(value)>;
            if constexpr (std::is_same_v<T, PartsCapacitySetting>) {
                form->parts_num = value.count;
                form->parts = AllocateRecords<MENUFORMPARTS_TYPE>(form->parts_num);
                for (int index = 0; index < form->parts_num; ++index) {
                    MenuPosDataTypeInit(&form->parts[index]);
                }
            } else if constexpr (std::is_same_v<T, DrawTypeSetting>) {
                if (value.type) {
                    form->dtype = Lookup(kFormDrawTypes, *value.type);
                    InitDrawType(form, value);
                }
            } else if constexpr (std::is_same_v<T, MoveTypeSetting>) {
                form->mtype = Lookup(kMoveTypes, value.type);
            } else if constexpr (std::is_same_v<T, DrawFlagSetting>) {
                form->draw_flag = value.draw != 0;
            } else if constexpr (std::is_same_v<T, OtherFormDrawFlagSetting>) {
                if (CMenuPosDataForm *other = MenuPosData->GetFormInfo(Arg(value.form))) {
                    other->draw_flag = value.draw != 0;
                }
            } else if constexpr (std::is_same_v<T, VibeCountSetting>) {
                form->vibe_cnt[0] = value.counts[0];
                form->vibe_cnt[1] = value.counts[1];
            } else if constexpr (std::is_same_v<T, MoveRateSetting>) {
                form->rate_x = value.rate[0];
                form->rate_y = value.rate[1];
            } else if constexpr (std::is_same_v<T, PositionSetting>) {
                form->x = value.xy[0];
                form->y = value.xy[1];
            } else if constexpr (std::is_same_v<T, RgbaSetting>) {
                form->rgba[0] = value.rgba[0];
                form->rgba[1] = value.rgba[1];
                form->rgba[2] = value.rgba[2];
                form->rgba[3] = value.rgba.size() == 4 ? value.rgba[3] : 0x80;
                for (int channel = 0; channel < 4; ++channel) {
                    form->SetRGBACalcParam(channel, 0, 0x80);
                }
            } else if constexpr (std::is_same_v<T, RgbaBitsSetting>) {
                u8 mask = 0;
                for (const char channel : value.channels) {
                    switch (channel) {
                        case 'r':
                            mask |= MENUFORM_RGBA_BIT_RED;
                            break;
                        case 'g':
                            mask |= MENUFORM_RGBA_BIT_GREEN;
                            break;
                        case 'b':
                            mask |= MENUFORM_RGBA_BIT_BLUE;
                            break;
                        case 'a':
                            mask |= MENUFORM_RGBA_BIT_ALPHA;
                            break;
                        default:
                            break;
                    }
                }
                form->rgba_bit = mask;
            } else if constexpr (std::is_same_v<T, ActionsSetting>) {
                auto *table = AllocateRecords<MENU_FORM_ACTION>(value.capacity);
                form->action = table;
                form->action_num = value.capacity;
                menu_spi_form_action_info = table;
                // Retail stores definitions past the table's end; the port keeps those that fit.
                const std::size_t count = std::min(value.actions.size(), static_cast<std::size_t>(value.capacity));
                for (std::size_t index = 0; index < count; ++index) {
                    const auto &action = value.actions[index];
                    dc2::text::Copy(menu_spi_form_action_info->name, action.name);
                    menu_spi_form_action_info->move = AllocateRecords<MENU_FORM_ACTION_MOVE>(1);
                    MENU_FORM_ACTION_MOVE *move = menu_spi_form_action_info->move;
                    move->mtype = action.move_type;
                    move->x = action.xy[0];
                    move->y = action.xy[1];
                    move->rate_x = action.rate[0];
                    move->rate_y = action.rate[1];
                    menu_spi_form_action_info++;
                }
            } else if constexpr (std::is_same_v<T, ActionSetting>) {
                form->SetAction(Arg(value.name));
            } else if constexpr (std::is_same_v<T, ClipSetting>) {
                const auto size = value.size.value_or(std::array<int, 2>{mgScreenWidth - 1, mgScreenHeight - 1});
                form->clip_w = size[0];
                form->clip_h = size[1];
            }
        },
        setting);
}

/**
 * Starts filling the effect records a part allocated.
 */
void SetEffectRecords(MENU_PARTS_EFFECT_STRUCT1 *records, int count) {
    menu_parts_effect_ptr = records;
    effect_room = records != nullptr ? count : 0;
}

/**
 * Applies one modifier to the current part or the effect records last allocated.
 */
void ApplyModifier(const PartModifier &modifier) {
    std::visit(
        [](const auto &value) {
            using T = std::decay_t<decltype(value)>;
            MENUFORMPARTS_TYPE *part = menu_form_part;
            if constexpr (std::is_same_v<T, EffectModifier>) {
                if (!value.type || menu_parts_effect_ptr == nullptr || effect_room <= 0) {
                    return;
                }
                MENU_PARTS_EFFECT_STRUCT1 *effect = menu_parts_effect_ptr;
                effect->type = Lookup(kEffectTypes, *value.type);
                effect->active = true;
                effect->repeat = true;
                const std::size_t count = std::min(value.params.size(), std::size(effect->param));
                for (std::size_t index = 0; index < count; ++index) {
                    effect->param[index] = value.params[index];
                }
                menu_parts_effect_ptr++;
                effect_room--;
            } else if constexpr (std::is_same_v<T, FillModifier>) {
                if (menu_parts_effect_ptr == nullptr || effect_room <= 0) {
                    return;
                }
                menu_parts_effect_ptr->type = MENU_PARTS_EFFECT_FILLBOX;
                for (int index = 0; index < 4; ++index) {
                    menu_parts_effect_ptr->param[index] = value.rgba[index];
                }
                menu_parts_effect_ptr++;
                effect_room--;
            } else {
                if (part == nullptr) {
                    return;
                }
                if constexpr (std::is_same_v<T, ShadowModifier>) {
                    part->shadow = true;
                    part->shadow_offset = 4;
                    if (value.on) {
                        part->shadow = *value.on != 0;
                    }
                    if (value.offset) {
                        part->shadow_offset = *value.offset;
                    }
                } else if constexpr (std::is_same_v<T, PartRgbaModifier>) {
                    if (value.rgba.size() == 1) {
                        part->rgba[3] = value.rgba[0];
                        part->rgba[2] = 0x80;
                        part->rgba[1] = 0x80;
                        part->rgba[0] = 0x80;
                    } else {
                        part->rgba[0] = value.rgba[0];
                        part->rgba[1] = value.rgba[1];
                        part->rgba[2] = value.rgba[2];
                        part->rgba[3] = value.rgba.size() == 4 ? value.rgba[3] : 0x80;
                    }
                } else if constexpr (std::is_same_v<T, AlphaBlendModifier>) {
                    part->alpha_blend = value.mode;
                } else if constexpr (std::is_same_v<T, PartEtcInfoModifier>) {
                    // Retail writes any index; the port keeps those inside the part's extra values.
                    for (const auto &[index, number] : value.entries) {
                        if (index >= 0 && index < static_cast<int>(std::size(part->etc_info))) {
                            part->etc_info[index] = number;
                        }
                    }
                } else if constexpr (std::is_same_v<T, BilinearModifier>) {
                    part->bilinear |= 1;
                } else if constexpr (std::is_same_v<T, PartVibeCountModifier>) {
                    part->vibe_cnt[0] = value.counts[0];
                    part->vibe_cnt[1] = value.counts[1];
                } else if constexpr (std::is_same_v<T, ViberModifier>) {
                    part->viber[0] = value.ranges[0];
                    part->viber[1] = value.ranges[1];
                } else if constexpr (std::is_same_v<T, EffectCapacityModifier>) {
                    if (value.count <= 0) {
                        return;
                    }
                    part->effect_num = value.count;
                    part->effect = AllocateRecords<MENU_PARTS_EFFECT_STRUCT1>(value.count);
                    SetEffectRecords(part->effect, value.count);
                }
            }
        },
        modifier);
}

/**
 * Sets the size of a part to that of its texture rectangle.
 */
void SizeFromTexture(MENUFORMPARTS_TYPE *part, const std::optional<std::array<int, 2>> &size) {
    if (size) {
        part->w = (*size)[0];
        part->h = (*size)[1];
    } else {
        // As menu_texdata_to_formpart_copy: the rectangle's size, or none for a missing rectangle.
        const MENU_BASETEXINFO *texture = MenuPosData->GetTexGetInfo(part->tex_info_no);
        part->w = texture != nullptr ? texture->rect.right : 0;
        part->h = texture != nullptr ? texture->rect.bottom : 0;
    }
}

/**
 * Enters one part into the current form as its creating callback does.
 */
void ApplyPart(const Part &spec) {
    // A part needs a form with a free part slot; retail dereferences null when there is none.
    if (menu_formPt == nullptr) {
        return;
    }
    MENUFORMPARTS_TYPE *part = menu_formPt->GetEnableEnterPart();
    menu_form_part = part;
    if (part == nullptr) {
        return;
    }
    const auto name = [&spec, part] { part->name = mgCopyString(Arg(spec.name), MenuSpiStack); };
    const auto texture = [&spec] { return MenuPosData->GetTexGetInfoTblNo(Arg(spec.texture)); };
    const auto place = [&spec, part] {
        part->x = spec.xy[0];
        part->y = spec.xy[1];
    };
    const auto rect = [&spec, part] {
        part->x = spec.xy[0];
        part->y = spec.xy[1];
        part->w = (*spec.size)[0];
        part->h = (*spec.size)[1];
    };
    switch (spec.kind) {
        case PartKind::Normal:
        case PartKind::Normal2:
            part->tex_info_no = texture();
            name();
            place();
            SizeFromTexture(part, spec.size);
            part->dtype = spec.kind == PartKind::Normal ? MENUFORMPARTS_DTYPE_NORMAL : MENUFORMPARTS_DTYPE_NORMAL2;
            part->active = true;
            break;
        case PartKind::Cursor:
        case PartKind::FuncInfo:
            name();
            place();
            part->dtype = spec.kind == PartKind::Cursor ? MENUFORMPARTS_DTYPE_CURSOR : MENUFORMPARTS_DTYPE_FUNCINFO;
            part->active = true;
            part->draw_flag = spec.kind == PartKind::Cursor;
            break;
        case PartKind::Number1:
        case PartKind::Number2:
            part->tex_info_no = texture();
            name();
            part->etc_info[0] = spec.value;
            place();
            if (spec.size) {
                part->w = (*spec.size)[0];
                part->h = (*spec.size)[1];
            }
            if (spec.kind == PartKind::Number2) {
                part->etc_info[1] = 0;
            }
            part->dtype = spec.kind == PartKind::Number1 ? MENUFORMPARTS_DTYPE_NUMBER1 : MENUFORMPARTS_DTYPE_NUMBER2;
            part->active = true;
            break;
        case PartKind::FrameImage:
            part->dtype = Lookup(kFrameImageTypes, spec.type);
            part->tex_info_no = texture();
            name();
            rect();
            part->bilinear |= 1;
            part->active = true;
            break;
        case PartKind::Form:
            part->tex_info_no = spec.form;
            name();
            place();
            part->dtype = MENUFORMPARTS_DTYPE_FORM;
            part->active = true;
            break;
        case PartKind::Item:
            part->dtype = Lookup(kItemTypes, spec.type);
            part->etc_info[1] = 0;
            name();
            place();
            part->w = 32.0f;
            part->h = 40.0f;
            if (spec.size) {
                part->w = (*spec.size)[0];
                part->h = (*spec.size)[1];
            }
            part->active = true;
            part->draw_flag = true;
            break;
        case PartKind::ItemCheckmark:
            part->dtype = MENUFORMPARTS_DTYPE_CHECKMARK;
            part->tex_info_no = static_cast<s8>(MenuCommonInfo->tex_block[0]);
            name();
            place();
            SizeFromTexture(part, spec.size);
            part->active = true;
            part->draw_flag = true;
            break;
        case PartKind::FillBox:
            part->dtype = Lookup(kFillBoxTypes, spec.type);
            name();
            rect();
            part->etc_info[0] = spec.style;
            part->active = true;
            part->draw_flag = true;
            // Retail reads the record count from past its table for any other style; the port allocates none.
            if (spec.style >= 0 && std::cmp_less(spec.style, kFillEffectCounts.size())) {
                const int count = kFillEffectCounts[spec.style];
                part->effect = AllocateRecords<MENU_PARTS_EFFECT_STRUCT1>(count);
                SetEffectRecords(part->effect, count);
            } else {
                SetEffectRecords(nullptr, 0);
            }
            break;
        case PartKind::WakuRect:
        case PartKind::WakuCircle:
            part->tex_info_no = texture();
            name();
            part->dtype = spec.kind == PartKind::WakuRect ? MENUFORMPARTS_DTYPE_WAKU_RECT : MENUFORMPARTS_DTYPE_WAKU_CIRCLE;
            rect();
            part->active = true;
            part->draw_flag = true;
            break;
        case PartKind::DrawType: {
            part->dtype = Lookup(kPartDrawTypes, spec.type);
            name();
            if (part->dtype == MENUFORMPARTS_DTYPE_CLUT_RELOAD) {
                const std::size_t count = std::min(spec.etc_info.size(), std::size(part->etc_info));
                std::copy_n(spec.etc_info.begin(), count, part->etc_info);
            } else if (part->dtype == MENUFORMPARTS_DTYPE_RANDOM_LINE) {
                rect();
            }
            part->draw_flag = 1;
            part->active = 1;
            break;
        }
    }
}

void Apply(const FormOp &op) {
    int form_no = menu_analyze_formno + menu_analyze_formno_offset;
    if (op.slot) {
        form_no = menu_analyze_formno + *op.slot;
    }
    menu_formPt = nullptr;
    // A form whose name is already defined leaves no current form, and the cursor stays.
    if (MenuPosData->GetFormInfo(Arg(op.name)) == nullptr) {
        menu_formPt = MenuPosData->GetFormInfo(form_no);
        if (menu_formPt != nullptr) {
            menu_formPt->Initialize();
            menu_formPt->name = mgCopyString(Arg(op.name), MenuSpiStack);
            menu_formPt->active = true;
            menu_formPt->draw_flag = true;
            menu_analyze_formno_offset += 1;
        }
    }
    for (const auto &setting : op.settings) {
        ApplySetting(setting);
    }
    for (const auto &part : op.parts) {
        ApplyPart(part);
        for (const auto &modifier : part.modifiers) {
            ApplyModifier(modifier);
        }
    }
}

/**
 * Reads the native document a script buffer was loaded from, or the document bytes a caller copied elsewhere.
 */
template <typename T>
std::optional<T> ReadScript(const char *script, int size, std::string_view kind, T (*parse)(const Json &)) {
    if (native_config::BufferPath(script)) {
        return native_config::ReadBuffer<T>(script, kind, parse);
    }
    const auto document = size > 0 ? Json::parse(script, script + size, nullptr, false) : Json();
    if (document.is_discarded() || document.is_null()) {
        native_config::Report("<buffer>", "configuration buffer has no native source");
        return std::nullopt;
    }
    try {
        native_config::CheckKind(document, kind);
        return parse(document);
    } catch (const std::exception &exception) {
        native_config::Report("<buffer>", exception.what());
        return std::nullopt;
    }
}

// --- menu_commands -------------------------------------------------------------------------------------

/**
 * Shows or hides named forms.
 */
struct FormDrawFlagCommand {
    int                      draw{}; /**< Non-zero to draw. */
    std::vector<std::string> forms;  /**< Forms to change. */
};

/**
 * Sets a form's colour, or resets it to grey.
 */
struct FormRgbaCommand {
    std::string                       form; /**< Form to change. */
    std::optional<std::array<int, 4>> rgba; /**< Colour, or absent for 0x80 in every channel. */
};

/**
 * Starts one colour channel of a form changing.
 */
struct FormCalcRgbaCommand {
    std::string form;      /**< Form to change. */
    int         channel{}; /**< Colour channel. */
    int         step{};    /**< Change per frame. */
    int         target{};  /**< Value the channel changes towards. */
};

/**
 * Fades a form in or out.
 */
struct FormFadeCommand {
    std::string form;     /**< Form to fade. */
    int         mode{};   /**< 0 fades in, 1 fades out. */
    int         frames{}; /**< Fade length. */
};

/**
 * Moves a form, optionally only for one language.
 */
struct FormSetPosCommand {
    std::string        form;     /**< Form to move. */
    std::array<int, 2> xy{};     /**< Screen position. */
    std::optional<int> language; /**< Language the move applies to, or the current one. */
};

/**
 * Starts a named action of a form.
 */
struct FormSetActionCommand {
    std::string form;   /**< Form whose action starts. */
    std::string action; /**< Action name. */
};

/**
 * Shows or hides parts of a form.
 */
struct PartsDrawFlagCommand {
    std::string              form;   /**< Form holding the parts. */
    int                      draw{}; /**< Non-zero to draw. */
    std::vector<std::string> parts;  /**< Parts to change. */
};

/**
 * Moves forms in the draw list.
 */
struct FormSwapCommand {
    std::vector<std::string> forms; /**< Two forms, or four for a group swap. */
};

/**
 * Message-window command and the window it acts on.
 */
enum class MessageAction {
    Make,         /**< MakeMsg. */
    AbsPos,       /**< SetAbsPos. */
    SystemBuffer, /**< SetBuff_system with a numbered system buffer. */
    Buffer,       /**< SetBuff with a numbered buffer. */
    Cursor,       /**< SetMsgCursor. */
    QuestionRow,  /**< First selectable line. */
};

/**
 * Message-window command taking one integer.
 */
struct MessageCommand {
    MessageAction action{}; /**< What to do. */
    int           window{}; /**< MenuDCMsg index. */
    int           value{};  /**< Integer operand. */
};

/**
 * Message-window command taking a keyword or a speed.
 */
struct MessageStyleCommand {
    enum class Kind {
        Preset,  /**< MsgPreset by keyword. */
        Outline, /**< Outline style by keyword. */
        Speed    /**< Opening speed. */
    };

    Kind        kind{};       /**< What to set. */
    int         window{};     /**< MenuDCMsg index. */
    std::string keyword;      /**< Preset or outline keyword. */
    float       speed = 0.0f; /**< Opening speed. */
};

/**
 * Menu-wide command taking integers.
 */
struct MenuCommand {
    enum class Kind {
        InitDrawList, /**< Rebuild the draw list. */
        ResetTexInfo, /**< Reset texture information. */
        InputKey,     /**< Enable or disable key input. */
        CursorOnOff,  /**< Show or hide the cursor form. */
        CursorFade,   /**< Fade the cursor. */
        FrameType,    /**< Window frame type. */
        SceneFade     /**< Fade the scene. */
    };

    Kind               kind{};    /**< What to do. */
    int                value = 0; /**< Main operand. */
    std::optional<int> second;    /**< Speed or frame count. */
    std::optional<int> steps;     /**< Cursor fade steps. */
};

/**
 * Plays a named sound or prints a debug message.
 */
struct TextCommand {
    bool        sound{}; /**< True to play a sound, false to print. */
    std::string text;    /**< Sound keyword or message. */
};

/**
 * One command of a block.
 */
using MenuScriptCommand = std::variant<FormDrawFlagCommand, FormRgbaCommand, FormCalcRgbaCommand, FormFadeCommand, FormSetPosCommand, FormSetActionCommand,
                                       PartsDrawFlagCommand, FormSwapCommand, MessageCommand, MessageStyleCommand, MenuCommand, TextCommand>;

/**
 * Commands that run when the menu asks for a command name.
 */
struct CommandBlock {
    std::string                    name;     /**< Command name. */
    std::vector<MenuScriptCommand> commands; /**< Commands in script order. */
};

/**
 * Typed contents of a menu_commands document.
 */
struct MenuCommands {
    std::vector<CommandBlock> blocks; /**< Blocks in script order; several may share a name. */
};

std::vector<std::string> Texts(const Json &object, const char *key) {
    std::vector<std::string> out;
    for (const auto &value : native_config::Array(object, key)) {
        auto text = native_config::GameText(value);
        if (!text) {
            throw std::runtime_error(std::string(key) + " holds a missing name");
        }
        out.push_back(std::move(*text));
    }
    return out;
}

MenuScriptCommand ParseCommand(const Json &command) {
    using namespace native_config;
    const std::string                                                                       op = Text(command, "op");
    static const std::map<std::string, std::pair<MessageAction, const char *>, std::less<>> messages = {
        {"make_message",          {MessageAction::Make, "message"}       },
        {"message_abs_pos",       {MessageAction::AbsPos, "value"}       },
        {"message_system_buffer", {MessageAction::SystemBuffer, "buffer"}},
        {"message_buffer",        {MessageAction::Buffer, "buffer"}      },
        {"message_cursor",        {MessageAction::Cursor, "cursor"}      },
        {"message_question_row",  {MessageAction::QuestionRow, "row"}    },
    };
    if (const auto found = messages.find(op); found != messages.end()) {
        return MessageCommand{.action = found->second.first, .window = Int(command, "window"), .value = Int(command, found->second.second)};
    }
    if (op == "form_draw_flag") {
        return FormDrawFlagCommand{.draw = Int(command, "draw"), .forms = Texts(command, "forms")};
    }
    if (op == "form_rgba") {
        FormRgbaCommand out{.form = Text(command, "form"), .rgba = std::nullopt};
        if (command.contains("rgba")) {
            out.rgba = Ints<4>(command, "rgba");
        }
        return out;
    }
    if (op == "form_calc_rgba") {
        return FormCalcRgbaCommand{
            .form = Text(command, "form"), .channel = Int(command, "channel"), .step = Int(command, "step"), .target = Int(command, "target")};
    }
    if (op == "form_fade") {
        return FormFadeCommand{.form = Text(command, "form"), .mode = Int(command, "mode"), .frames = Int(command, "frames")};
    }
    if (op == "form_set_pos") {
        return FormSetPosCommand{.form = Text(command, "form"), .xy = Ints<2>(command, "xy"), .language = OptionalInt(command, "language")};
    }
    if (op == "form_set_action") {
        return FormSetActionCommand{.form = Text(command, "form"), .action = Text(command, "action")};
    }
    if (op == "part_draw_flag") {
        return PartsDrawFlagCommand{.form = Text(command, "form"), .draw = Int(command, "draw"), .parts = {Text(command, "part")}};
    }
    if (op == "parts_draw_flag") {
        return PartsDrawFlagCommand{.form = Text(command, "form"), .draw = Int(command, "draw"), .parts = Texts(command, "parts")};
    }
    if (op == "form_swap" || op == "form_group_swap") {
        FormSwapCommand out{.forms = Texts(command, "forms")};
        if (out.forms.size() != (op == "form_swap" ? 2u : 4u)) {
            throw std::runtime_error(op + " has the wrong number of forms");
        }
        return out;
    }
    if (op == "message_env") {
        return MessageStyleCommand{.kind = MessageStyleCommand::Kind::Preset, .window = Int(command, "window"), .keyword = Text(command, "preset")};
    }
    if (op == "message_outline") {
        return MessageStyleCommand{.kind = MessageStyleCommand::Kind::Outline, .window = Int(command, "window"), .keyword = Text(command, "style")};
    }
    if (op == "message_speed") {
        return MessageStyleCommand{
            .kind = MessageStyleCommand::Kind::Speed, .window = Int(command, "window"), .keyword = {}, .speed = Float(command, "speed")};
    }
    using Kind = MenuCommand::Kind;
    if (op == "init_drawlist") {
        return MenuCommand{.kind = Kind::InitDrawList};
    }
    if (op == "reset_texinfo") {
        return MenuCommand{.kind = Kind::ResetTexInfo};
    }
    if (op == "input_key") {
        return MenuCommand{.kind = Kind::InputKey, .value = Int(command, "enable")};
    }
    if (op == "cursor_on_off") {
        return MenuCommand{.kind = Kind::CursorOnOff, .value = Int(command, "show")};
    }
    if (op == "cursor_fade") {
        return MenuCommand{
            .kind = Kind::CursorFade, .value = Int(command, "fade_in"), .second = OptionalInt(command, "speed"), .steps = OptionalInt(command, "steps")};
    }
    if (op == "frame_type") {
        return MenuCommand{.kind = Kind::FrameType, .value = Int(command, "type")};
    }
    if (op == "scene_fade") {
        return MenuCommand{.kind = Kind::SceneFade, .value = Int(command, "fade_in"), .second = OptionalInt(command, "frames")};
    }
    if (op == "play_se") {
        return TextCommand{.sound = true, .text = Text(command, "name")};
    }
    if (op == "print") {
        return TextCommand{.sound = false, .text = Text(command, "text")};
    }
    throw std::runtime_error("unknown menu command " + op);
}

MenuCommands ParseCommands(const Json &document) {
    MenuCommands out;
    for (const auto &block : native_config::Array(document, "blocks")) {
        CommandBlock parsed{.name = native_config::Text(block, "name"), .commands = {}};
        for (const auto &command : native_config::Array(block, "commands")) {
            parsed.commands.push_back(ParseCommand(command));
        }
        out.blocks.push_back(std::move(parsed));
    }
    return out;
}

/**
 * The message window a command names, or null when there is none.
 */
CDC2Mes *Window(int index) {
    return index >= 0 && std::cmp_less(index, std::size(MenuDCMsg)) ? MenuDCMsg[index] : nullptr;
}

/**
 * Runs one command of the selected block as its retail callback does.
 */
void Execute(const MenuScriptCommand &command) {
    std::visit(
        [](const auto &value) {
            using T = std::decay_t<decltype(value)>;
            if constexpr (std::is_same_v<T, FormDrawFlagCommand>) {
                for (const auto &name : value.forms) {
                    if (CMenuPosDataForm *form = MenuPosData->GetFormInfo(Arg(name))) {
                        form->draw_flag = value.draw != 0;
                    } else {
                        std::println("{} not found", name);
                    }
                }
            } else if constexpr (std::is_same_v<T, FormRgbaCommand>) {
                CMenuPosDataForm *form = MenuPosData->GetFormInfo(Arg(value.form));
                if (form == nullptr) {
                    return;
                }
                const auto rgba = value.rgba.value_or(std::array<int, 4>{0x80, 0x80, 0x80, 0x80});
                for (int channel = 0; channel < 4; ++channel) {
                    form->rgba[channel] = rgba[channel];
                }
                for (int channel = 0; channel < 4; ++channel) {
                    form->SetRGBACalcParam(channel, 0, 0x80);
                }
            } else if constexpr (std::is_same_v<T, FormCalcRgbaCommand>) {
                if (CMenuPosDataForm *form = MenuPosData->GetFormInfo(Arg(value.form))) {
                    form->SetRGBACalcParam(value.channel, value.step, value.target);
                }
            } else if constexpr (std::is_same_v<T, FormFadeCommand>) {
                CMenuPosDataForm *form = MenuPosData->GetFormInfo(Arg(value.form));
                if (form != nullptr && value.mode == 0) {
                    form->FormFadeIn(value.frames, 1);
                }
                if (form != nullptr && value.mode == 1) {
                    form->FormFadeOut(value.frames, 1);
                }
            } else if constexpr (std::is_same_v<T, FormSetPosCommand>) {
                CMenuPosDataForm *form = MenuPosData->GetFormInfo(Arg(value.form));
                if (form != nullptr && value.language.value_or(LanguageCode) == LanguageCode) {
                    form->x = value.xy[0];
                    form->y = value.xy[1];
                }
            } else if constexpr (std::is_same_v<T, FormSetActionCommand>) {
                if (CMenuPosDataForm *form = MenuPosData->GetFormInfo(Arg(value.form))) {
                    form->SetAction(Arg(value.action));
                }
            } else if constexpr (std::is_same_v<T, PartsDrawFlagCommand>) {
                CMenuPosDataForm *form = MenuPosData->GetFormInfo(Arg(value.form));
                if (form == nullptr) {
                    return;
                }
                for (const auto &name : value.parts) {
                    if (MENUFORMPARTS_TYPE *part = form->GetPartInfo(Arg(name))) {
                        part->draw_flag = value.draw != 0;
                    }
                }
            } else if constexpr (std::is_same_v<T, FormSwapCommand>) {
                if (value.forms.size() == 2) {
                    MenuPosData->FormReLink(Arg(value.forms[0]), Arg(value.forms[1]));
                } else {
                    MenuPosData->FormReLink2(Arg(value.forms[0]), Arg(value.forms[1]), Arg(value.forms[2]), Arg(value.forms[3]));
                }
            } else if constexpr (std::is_same_v<T, MessageCommand>) {
                CDC2Mes *window = Window(value.window);
                if (window == nullptr) {
                    return;
                }
                const auto buffer_slot = [&value] { return value.value >= 0 && value.value < static_cast<int>(std::size(MenuCommandAnalyzeInfo.mes_buff)); };
                switch (value.action) {
                    case MessageAction::Make:
                        window->MakeMsg(value.value);
                        break;
                    case MessageAction::AbsPos:
                        window->SetAbsPos(value.value);
                        break;
                    case MessageAction::SystemBuffer: {
                        const auto buffer = buffer_slot() ? MenuCommandAnalyzeInfo.system_mes_buff[value.value] : dc2::text::MessageTable{};
                        window->SetBuff_system(buffer != nullptr ? buffer : GetSystemMesBuffer());
                        break;
                    }
                    case MessageAction::Buffer:
                        if (buffer_slot()) {
                            window->SetBuff(MenuCommandAnalyzeInfo.mes_buff[value.value]);
                        }
                        break;
                    case MessageAction::Cursor:
                        window->SetMsgCursor(value.value);
                        break;
                    case MessageAction::QuestionRow:
                        window->select_top = value.value;
                        break;
                }
            } else if constexpr (std::is_same_v<T, MessageStyleCommand>) {
                CDC2Mes *window = Window(value.window);
                if (window == nullptr) {
                    return;
                }
                switch (value.kind) {
                    case MessageStyleCommand::Kind::Preset:
                        window->MsgPreset(Lookup(kMessagePresets, value.keyword), LanguageCode);
                        break;
                    case MessageStyleCommand::Kind::Outline:
                        window->fuchi = Lookup(kOutlines, value.keyword);
                        break;
                    case MessageStyleCommand::Kind::Speed:
                        window->fade_speed = value.speed;
                        break;
                }
            } else if constexpr (std::is_same_v<T, MenuCommand>) {
                switch (value.kind) {
                    case MenuCommand::Kind::InitDrawList:
                        MenuPosData->InitDrawList();
                        break;
                    case MenuCommand::Kind::ResetTexInfo:
                        MenuPosData->ResetTextureInfoAll();
                        break;
                    case MenuCommand::Kind::InputKey:
                        MenuCommonInfo->key_enable = value.value;
                        break;
                    case MenuCommand::Kind::CursorOnOff:
                        if (MenuCommonInfo->cursor_form != nullptr) {
                            MenuCommonInfo->cursor_form->draw_flag = value.value != 0;
                        }
                        break;
                    case MenuCommand::Kind::CursorFade: {
                        // Retail reads the speed only from a two-operand command and the steps from a three-operand one.
                        const int speed = value.second && !value.steps ? *value.second : 10;
                        const int steps = value.steps.value_or(1);
                        if (value.value != 0) {
                            MenuCommonInfo->CursorFadeIn(speed, steps);
                        } else {
                            MenuCommonInfo->CursorFadeOut(speed, steps);
                        }
                        break;
                    }
                    case MenuCommand::Kind::FrameType:
                        MenuCommonInfo->SetWakuType(value.value);
                        break;
                    case MenuCommand::Kind::SceneFade: {
                        const int frames = value.second.value_or(40);
                        if (value.value != 0) {
                            MenuMainScene->fade.FadeIn(frames);
                        } else {
                            MenuMainScene->fade.FadeOut(frames, 0.0f, 0.0f, 0.0f);
                        }
                        MenuMainScene->fade.FadeStep();
                        break;
                    }
                }
            } else if constexpr (std::is_same_v<T, TextCommand>) {
                if (value.sound) {
                    MenuSePlay(Lookup(kSounds, value.text));
                } else {
                    // Retail passes the message as the format string.
                    std::println("{}", value.text);
                }
            }
        },
        command);
}

/**
 * Parsed command document of one source, kept while its datapack candidates are unchanged.
 */
struct CachedCommands {
    std::vector<std::shared_ptr<const Json>> candidates; /**< Candidate documents the result was chosen from. */
    std::shared_ptr<const MenuCommands>      commands;   /**< Parsed result, or null when no candidate was usable. */
};

/**
 * Typed command documents by source path; menus run their commands on every action.
 */
std::map<std::string, CachedCommands, std::less<>> command_cache;

/**
 * Parses the command document of a source path, reusing the earlier result while its candidates are the same.
 */
std::shared_ptr<const MenuCommands> CommandsOf(const std::string &path) {
    std::vector<std::string> names;
    auto                     candidates = native_config::Candidates(path, names);
    if (const auto found = command_cache.find(path); found != command_cache.end() && found->second.candidates == candidates) {
        return found->second.commands;
    }
    std::shared_ptr<const MenuCommands> commands;
    for (std::size_t index = 0; index < candidates.size() && !commands; ++index) {
        try {
            native_config::CheckKind(*candidates[index], "menu_commands");
            commands = std::make_shared<const MenuCommands>(ParseCommands(*candidates[index]));
        } catch (const std::exception &exception) {
            native_config::Report(names[index], exception.what());
        }
    }
    if (candidates.empty()) {
        native_config::Report(path, "native configuration document missing");
    }
    command_cache[path] = {.candidates = std::move(candidates), .commands = commands};
    return commands;
}

} // namespace

// NOLINTNEXTLINE(readability-non-const-parameter)
int MenuDataAnalyze(char *script, int size, mgCMemory *memory) {
    if (script == nullptr || memory == nullptr || MenuPosData == nullptr) {
        return 0;
    }

    struct LayoutMemoryScope {
        mgCMemory *previous;

        ~LayoutMemoryScope() { MenuSpiStack = previous; }
    } scope{MenuSpiStack};

    MenuSpiStack = memory;
    try {
        if (const auto layout = ReadScript<MenuLayout>(script, size, "menu_layout", ParseLayout)) {
            for (const auto &op : layout->operations) {
                std::visit([](const auto &value) { Apply(value); }, op);
            }
        }
    } catch (const std::length_error &error) {
        native_config::Report("<menu layout>", error.what());
        return 0;
    }
    return 1;
}

// NOLINTNEXTLINE(readability-non-const-parameter)
void dc2::menu::AnalyzeCommands(char *script, int size, std::string_view command_name) {
    if (script == nullptr) {
        return;
    }
    MenuCommandAnalyzeInfo.command_name = command_name;
    std::shared_ptr<const MenuCommands> commands;
    if (const auto path = native_config::BufferPath(script)) {
        commands = CommandsOf(*path);
    } else if (auto parsed = ReadScript<MenuCommands>(script, size, "menu_commands", ParseCommands)) {
        commands = std::make_shared<const MenuCommands>(std::move(*parsed));
    }
    if (!commands) {
        return;
    }
    for (const auto &block : commands->blocks) {
        SpiMenuExeCommandFlag = block.name == MenuCommandAnalyzeInfo.command_name;
        if (SpiMenuExeCommandFlag != 0) {
            for (const auto &command : block.commands) {
                Execute(command);
            }
        }
    }
}
