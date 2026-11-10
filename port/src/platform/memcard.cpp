#include "common.h"

#include <sifdev.h>

#include <algorithm>
#include <array>
#include <bit>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <limits>
#include <memory>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <type_traits>
#include <vector>

#include "dataread.hpp"
#include "editdata.hpp"
#include "inventmn.hpp"
#include "log/game_output.hpp"
#include "mainloop.hpp"
#include "memcard.hpp"
#include "memory/tracked_copy.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menusys.hpp"
#include "mg_memory.hpp"
#include "platform/files.hpp"
#include "platform/paths.hpp"
#include "storage/album.hpp"
#include "text/bounded.hpp"
#include "title.hpp"

namespace {
/**
 * Gives the fixed album path only for one of the two supported card ports.
 */
std::optional<std::filesystem::path> AlbumPath(int port) {
    if (port != 0 && port != 1) {
        return std::nullopt;
    }
    return PathsSaveRoot() / ("mc" + std::to_string(port)) /
           std::filesystem::path(MakeMemoryCardAlbumName(true)).relative_path();
}

/**
 * Refreshes actual SDK card status before publishing or reading an album image.
 */
bool AlbumCardReady(CMemoryCardManager &manager) {
    if (manager.port != 0 && manager.port != 1) {
        manager.error.code = MC_ERROR_NO_CARD;
        return false;
    }
    int type = 0;
    int free_size = 0;
    int formatted = 0;
    int command = 0;
    int result = 0;
    if (sceMcGetInfo(manager.port, 1, &type, &free_size, &formatted) != 0 ||
        sceMcSync(MC_WAIT, &command, &result) != 1 || command != sceMcFuncNoCardInfo) {
        manager.error.code = MC_ERROR_COMMAND;
        return false;
    }
    auto &card = std::span(manager.card)[static_cast<std::size_t>(manager.port)];
    card.type = type;
    card.free_size = free_size;
    card.formatted = formatted;
    card.present = type == sceMcTypePS2;
    card.result = result;
    if (!card.present) {
        manager.error.code = MC_ERROR_NO_CARD;
        return false;
    }
    if (!formatted) {
        manager.error.code = MC_ERROR_UNFORMATTED;
        return false;
    }
    if (result < 0) {
        manager.error.code = MC_ERROR_FILE;
        return false;
    }
    return true;
}

/**
 * Closes only the controller's captured open and preserves later descriptor reuse.
 */
int CloseManagedFile(CMemoryCardManager &manager) {
    return manager.descriptor.Close();
}

/**
 * Gives the remaining actual transfer extent for a checked nonnegative offset.
 */
template <class Byte>
std::span<Byte> TransferTail(std::span<Byte> buffer, int offset) {
    return offset < 0 || static_cast<std::size_t>(offset) > buffer.size() ? std::span<Byte>{} : buffer.subspan(static_cast<std::size_t>(offset));
}

/**
 * Gives an icon's initialized byte count within the SDK transfer range.
 */
int IconSize(const MC_ICON_DATA &icon) {
    return icon.resource.Size();
}

} // namespace

/**
 *
 * Number of costumes tracked by the persistent costume flags.
 *
 */
enum MC_COSTUME {
    MC_COSTUME_COUNT = 34, /**< Entries in the costume table and in the costume-bit lookup. */
};

/**
 *
 * Costume item numbers and their persistent costume-bit indices.
 *
 */
static COSBIT_INFO cosbit_table[MC_COSTUME_COUNT] = {
    {0x6F,  0,  0},
    {0x70,  1,  0},
    {0x71,  2,  0},
    {0x72,  3,  0},
    {0x73,  4,  0},
    {0x74,  5,  0},
    {0x75,  6,  0},
    {0x76,  7,  0},
    {0x77,  8,  0},
    {0x78,  9,  0},
    {0x79,  10, 0},
    {0x7A,  11, 0},
    {0x7B,  12, 0},
    {0x7C,  13, 0},
    {0x7D,  14, 0},
    {0x7E,  15, 0},
    {0x7F,  16, 0},
    {0x80,  17, 0},
    {0x81,  18, 0},
    {0x82,  19, 0},
    {0x83,  20, 0},
    {0x84,  21, 0},
    {0x85,  22, 0},
    {0x86,  23, 0},
    {0x102, 24, 0},
    {0x103, 25, 0},
    {0x104, 26, 0},
    {0x105, 27, 0},
    {0x106, 28, 0},
    {0x107, 29, 0},
    {0x108, 30, 0},
    {0x109, 31, 0},
    {0x10A, 32, 0},
    {0x10B, 33, 0},
};
static const char at_1315__3[] = "test";
static const char at_1954[] = "/BESCES-51190dc2omake/BESCES-51190dc2omake";

/**
 *
 * Browser titles for save, album, bonus, and formatted save entries by region.
 *
 */
static const char *MCBrowsetName[3][4] = {
    {"\x83_\x81[\x83N\x83N\x83\x8D\x83j\x83N\x83\x8B",                         "\x83_\x81[\x83N\x83N\x83\x8D\x83j\x83N\x83\x8B\x83"
                                                       "A\x83\x8B\x83o\x83\x80\x83"
                                                       "f\x81[\x83^",
     "\x83_\x81[\x83N\x83N\x83\x8D\x83j\x83N\x83\x8B\x82\xA8\x82\xDC\x82\xAF\x83"
     "f\x81[\x83^",
     "\x83_\x81[\x83N\x83N\x83\x8D\x83j\x83N\x83\x8B\x81m%s\x81n"                   },
    {"\x82"
     "c\x82\x81\x82\x92\x82\x8B\x81@\x82"
     "b\x82\x8C\x82\x8F\x82\x95\x82\x84\x82Q",
     "\x82"
     "c\x82\x81\x82\x92\x82\x8B\x81@\x82"
     "b\x82\x8C\x82\x8F\x82\x95\x82\x84\x82Q\x81@\x82`\x82\x8C\x82\x82\x82\x95\x82\x8D",
     "\x82"
     "c\x82\x81\x82\x92\x82\x8B\x81@\x82"
     "b\x82\x8C\x82\x8F\x82\x95\x82\x84\x82Q\x81@\x82"
     "d\x82\x98\x82\x94\x82\x92\x82\x81",
     "\x82"
     "c\x82\x81\x82\x92\x82\x8B\x81@\x82"
     "b\x82\x8C\x82\x8F\x82\x95\x82\x84\x82Q\x81m%s\x81n"                           },
    {"\x82"
     "c\x82\x81\x82\x92\x82\x8B\x81@\x82"
     "b\x82\x88\x82\x92\x82\x8F\x82\x8E\x82\x89\x82\x83\x82\x8C\x82\x85",
     "\x82"
     "c\x82\x81\x82\x92\x82\x8B\x81@\x82"
     "b\x82\x88\x82\x92\x82\x8F\x82\x8E\x82\x89\x82\x83\x82\x8C\x82\x85\x81@\x82`\x82\x8C\x82\x82\x82\x95\x82\x8D",
     "\x82"
     "c\x82\x81\x82\x92\x82\x8B\x81@\x82"
     "b\x82\x88\x82\x92\x82\x8F\x82\x8E\x82\x89\x82\x83\x82\x8C\x82\x85\x81@\x82"
     "d\x82\x98\x82\x94\x82\x92\x82\x81",
     "\x82"
     "c\x82\x81\x82\x92\x82\x8B\x81@\x82"
     "b\x82\x88\x82\x92\x82\x8F\x82\x8E\x82\x89\x82\x83\x82\x8C\x82\x85\x81m%s\x81n"},
};

/**
 *
 * Byte offsets of the second title line for each region and save category.
 *
 */
static u16 MCBrowserName_Offset[3][4] = {
    {0x20, 0x10, 0x10, 0x20},
    {0x20, 0x16, 0x16, 0x20},
    {0x20, 0x1C, 0x1C, 0x1C},
};

/**
 *
 * Whether dungeon-tree state is included in the next save.
 *
 */
static short DngTreeSaveFlag;

namespace {
struct BrowserTitle {
    std::string_view text;
    u16              line_offset;
};

std::optional<BrowserTitle> BrowserTitleFor(int index) {
    if (index < MC_BROWSER_NAME_SAVE || index > MC_BROWSER_NAME_SAVE_NUM) {
        return std::nullopt;
    }
    int region = MC_BROWSER_REGION_JAPAN;

    if (CheckNowEurope() != 0) {
        region = MC_BROWSER_REGION_EUROPE;
    } else if (LanguageCode == LANG_ENGLISH) {
        region = MC_BROWSER_REGION_US;
    }

    return BrowserTitle{MCBrowsetName[region][index], MCBrowserName_Offset[region][index]};
}
} // namespace

std::optional<std::string> MakeMemoryCardBrowserTitle(int file_no) {
    if (file_no < -1 || file_no == std::numeric_limits<int>::max()) {
        return std::nullopt;
    }
    const auto browser = BrowserTitleFor(MC_BROWSER_NAME_SAVE_NUM);
    if (!browser) {
        return std::nullopt;
    }
    std::string number;
    for (char digit : std::to_string(file_no + 1)) {
        const char *glyph = GetMenuBigNum(digit - '0');
        number.append(glyph, 2);
    }
    std::string title(browser->text);
    const auto  insertion = title.find("%s");
    if (insertion == std::string::npos) {
        return std::nullopt;
    }
    title.replace(insertion, 2, number);
    if (title.size() >= sizeof(sceMcIconSys::title_name)) {
        return std::nullopt;
    }
    return title;
}

void SetDngTreeFlag(int flag);

namespace {
std::string SaveSlotName(int slot) {
    return "BESCES-51190dkcl" + std::to_string(slot);
}
} // namespace

std::string MakeMemoryCardFileName(int slot) {
    const std::string name = SaveSlotName(slot);
    return "/" + name + "/" + name;
}

std::string MakeMemoryCardAlbumName(bool append_again) {
    std::string name = "/BESCES-51190dc2album";
    if (append_again) {
        name += "/BESCES-51190dc2album";
    }
    return name;
}

int MakeCheckDigit(int mode, char *data, int size) {
    int sum = 0;

    if (mode == 0) {
        int blocks = size / 64;
        int i = {};
        sum = 0;

        for (i = 0; i < blocks; i++) {
            sum += static_cast<u8>(*data) % 255;
            data += 64;
        }
    }

    return sum;
}

namespace {
/**
 * Records the process-lived controller publication slots registered by menu producers.
 */
std::vector<CMemoryCardManager **> &ManagerPublications() {
    // Arena globals may release their tickets during static destruction.
    static auto *const publications = new std::vector<CMemoryCardManager **>;
    return *publications;
}

/**
 * Identifies the controller publication whose heap resources follow this arena allocation.
 */
struct ManagerTicket {
    CMemoryCardManager **publication; /**< Process-lived menu publication associated with this ticket. */
};
} // namespace

namespace dc2::mc {
/**
 * Owns one controller until replacement or retirement of its producer's resource ticket.
 */
struct OwnerState {
    std::unique_ptr<CMemoryCardManager> manager; /**< Heap controller and its owned file resources. */

    /**
     * Clears every matching publication before destroying the owned controller.
     */
    void Retire() {
        if (!manager) {
            return;
        }
        for (auto **publication : ManagerPublications()) {
            if (*publication == manager.get()) {
                *publication = nullptr;
            }
        }
        manager.reset();
    }

    /**
     * Retires the controller when its producer ticket releases the final owner.
     */
    ~OwnerState() { Retire(); }
};

CMemoryCardManager *CreateManager(mgCMemory &memory, CMemoryCardManager *&publication) {
    auto *ticket = memory::NewObject<ManagerTicket>(memory);
    if (ticket == nullptr) {
        return nullptr;
    }
    ticket->publication = &publication;
    const auto anchor = memory::ArenaBuffer::Bind(memory, std::span(reinterpret_cast<u8 *>(ticket), sizeof(*ticket)));
    auto       state = std::make_shared<OwnerState>();
    state->manager = std::make_unique<CMemoryCardManager>();
    state->manager->native_owner = state;
    if (!anchor.Retain(state)) {
        return nullptr;
    }
    auto &publications = ManagerPublications();
    if (std::ranges::find(publications, &publication) == publications.end()) {
        publications.push_back(&publication);
    }
    RetireManager(publication);
    publication = state->manager.get();
    return publication;
}

void RetireManager(CMemoryCardManager *&publication) {
    if (publication != nullptr) {
        if (auto state = publication->native_owner.lock()) {
            state->Retire();
        } else {
            publication = nullptr;
        }
    }
}

void RetireManagers() {
    for (auto **publication : ManagerPublications()) {
        RetireManager(*publication);
    }
}
} // namespace dc2::mc

CMemoryCardManager::CMemoryCardManager() {
    Initialize(nullptr);
}

void CMemoryCardManager::Initialize(mgCMemory *memory) {
    std::ranges::fill(version, char{});
    std::ranges::fill(file_name, char{});
    std::ranges::fill(game_name, char{});
    std::ranges::fill(unk_54, u8{});
    std::ranges::fill(unk_60, u8{});
    std::ranges::fill(unk_D9C, u8{});
    std::ranges::fill(unk_10E8, u8{});
    dir_entries = 0;
    write_buffer = {};
    read_buffer = {};
    sub_game_data = nullptr;
    album_storage = {};
    load_dungeon_no = 0;
    load_floor_id = 0;
    omake_flag = 0;
    icon_sys = {};

    dc2::text::Copy(file_name, dc2::text::View("BESCES-51190dkcl%d"));
    dc2::text::Copy(game_name, dc2::text::View("darkclonicle"));
    port = 0;
    file_no = 0;
    descriptor.Release();
    fd = -1;
    save_buffer = nullptr;

    if (memory != nullptr) {
        save_buffer = dc2::memory::NewObject<SAVEDATA_FORMAT>(*memory);
        if (save_buffer != nullptr) {
            memset(save_buffer, 0, sizeof(SAVEDATA_FORMAT));
        }
    }

    InitError();
    InitSaveFileInfoTable();
    dc2::text::Copy(version, dc2::text::View("dc2Ver4"));
    func_no = MC_FUNC_IDLE;
    search_wait = 0x3D;
    step = 0;
    album_buffer_set = 0;
    album_buffer = nullptr;
    load_map_no = -1;
    load_program_loop_no = -1;
    load_dng_tree_flag = 0;
    transfer_size = 0;
    transferred = 0;
    total_transferred = 0;
    transfer_result = 0;
    memset(work_buffer, 0, sizeof(work_buffer));
    memset(&card[0], 0, sizeof(card));
    for (auto &info : file_info) {
        info = {};
    }
    InitPlayDataInfo();
    file_exists = 0;
    for (auto &resource : icon) {
        resource = {};
    }
    card[0].present = 0;
    card[1].present = 0;
}

void CMemoryCardManager::InitSaveFileInfoTable() {
    int entry_no = {};

    for (entry_no = 0; entry_no < MC_DIR_TABLE_NUM; entry_no++) {
        memset(&dir_table[entry_no], 0, sizeof(sceMcTblGetDir));
        dir_table[entry_no].entry_name[0] = 0;
    }
}

int CMemoryCardManager::GetOpenAttribute(char *name) {
    for (int i = 0; i < MC_DIR_TABLE_NUM; i++) {
        if (strcmp(name, dir_table[i].entry_name) == 0) {
            return 1;
        }
    }

    return 0;
}

void CMemoryCardManager::InitError() {
    memset(&error, 0, sizeof(error));
}

void CMemoryCardManager::FinishForMC() {
    sceMcEnd();
}

void CMemoryCardManager::SetBuff_Album(CDC2AlbumData *buf, mgCMemory *memory) {
    album_buffer = nullptr;
    album_storage = {};
    album_buffer_set = 0;
    if (buf != nullptr && memory != nullptr) {
        album_storage = dc2::memory::ArenaBuffer::Bind(*memory, std::span(reinterpret_cast<u8 *>(buf), sizeof(*buf)));
        if (!album_storage.Bytes().empty()) {
            album_buffer = buf;
            buf->Initialize();
            album_buffer_set = 1;
        }
    }
}

void CMemoryCardManager::SetIconData(std::span<const MC_ICON_DATA, 3> icon_data, int index) {
    std::ranges::copy(icon_data, std::begin(icon));
    sceMcColor bg_colors[4] = {
        {128, 0,   64,  0},
        {0,   128, 0,   0},
        {0,   0,   128, 0},
        {128, 128, 128, 0},
    };
    sceMcVu0FVECTOR light_dirs[3] = {
        {0.5f,  0.5f,  0.5f,  0.0f},
        {0.0f,  -0.4f, -0.1f, 0.0f},
        {-0.5f, -0.5f, 0.5f,  0.0f},
    };
    sceMcColorF light_colors[3] = {
        {0.48f, 0.48f, 0.03f, 0.0f},
        {0.5f,  0.33f, 0.2f,  0.0f},
        {0.14f, 0.14f, 0.38f, 0.0f},
    };
    sceMcColorF ambient_color = {0.5f, 0.5f, 0.5f, 0.0f};
    memset(&icon_sys, 0, sizeof(sceMcIconSys));
    dc2::text::Copy(icon_sys.head, dc2::text::View("PS2D"));
    if (const auto browser = BrowserTitleFor(index); browser && browser->text.size() < sizeof(icon_sys.title_name)) {
        dc2::text::Copy(std::span(reinterpret_cast<char *>(icon_sys.title_name), sizeof(icon_sys.title_name)),
                        browser->text);
        icon_sys.nl_offset = browser->line_offset;
    }
    icon_sys.trans_rate = 0x60;
    // Each lighting array contributes only its first entry to icon.sys.
    dc2::memory::CopyTrackedBytes(icon_sys.bg_color, bg_colors, 0x10);
    dc2::memory::CopyTrackedBytes(icon_sys.light_dir, light_dirs, 0x10);
    dc2::memory::CopyTrackedBytes(icon_sys.light_color, light_colors, 0x10);
    dc2::memory::CopyTrackedBytes(icon_sys.ambient, ambient_color, 0x10);

    dc2::text::Copy(icon_sys.fname_view, dc2::text::View(icon[0].name));
    dc2::text::Copy(icon_sys.fname_copy, dc2::text::View(icon[1].name));
    dc2::text::Copy(icon_sys.fname_del, dc2::text::View(icon[2].name));
}

int CMemoryCardManager::GetIconDataSize() {
    std::size_t blocks = 1;
    for (const auto &resource : icon) {
        const auto bytes = static_cast<std::size_t>(resource.resource.Size());
        const auto rounded = bytes / 0x400 + (bytes % 0x400 != 0);
        if (rounded > static_cast<std::size_t>(std::numeric_limits<int>::max()) - blocks) {
            return 0;
        }
        blocks += rounded;
    }
    return static_cast<int>(blocks);
}

int CMemoryCardManager::GetSaveDataSize(int type) {
    const auto    icon_blocks = static_cast<std::uint64_t>(GetIconDataSize());
    std::uint64_t size = 0;
    switch (type) {
        case MC_SIZE_SAVE_TOTAL:
            size = (icon_blocks + 0x19A) * 0x400;
            break;
        case MC_SIZE_SAVE_FILE:
            size = sizeof(SAVEDATA_FORMAT);
            break;
        case MC_SIZE_ALBUM_FILE:
            size = dc2::mc::AlbumFileSize();
            break;
        case MC_SIZE_ICONS:
            size = icon_blocks * 0x400;
            break;
        case MC_SIZE_ALBUM_TOTAL:
            size = icon_blocks * 0x400 + dc2::mc::AlbumFileSize() + 0x800;
            break;
        case MC_SIZE_SAVE_KB:
            size = icon_blocks + 0x199;
            break;
        case MC_SIZE_UNK_6:
            size = 0x20800;
            break;
        case MC_SIZE_OMAKE_FILE:
            size = sizeof(CSubGameData);
            break;
        case MC_SIZE_OMAKE_TOTAL:
            size = icon_blocks * 0x400 + sizeof(CSubGameData) + 0x800;
            break;
        case MC_SIZE_OMAKE_KB:
            size = icon_blocks + 0x1B;
            break;
        default:
            break;
    }
    return size > static_cast<std::size_t>(std::numeric_limits<int>::max()) ? 0 : static_cast<int>(size);
}

void CMemoryCardManager::SetFuncNo(int operation) {
    func_no = operation;
    step = 0;

    if (operation == MC_FUNC_IDLE) {
        search_wait = 11;
    }
}

int CMemoryCardManager::GetFuncNo() { return this->func_no; }

void CMemoryCardManager::InitPlayDataInfo() {
    for (int i = 0; i < MC_SAVE_FILE_NUM; i++) {
        file_info[i].state = 0;
    }
}

void CMemoryCardManager::UpDateViewInfo(SAVEDATA_INFO *view, SAVEDATA_FORMAT *format) {
    if (view == nullptr || format == nullptr) {
        return;
    }

    view->program_loop_no = format->program_loop_no;
    view->map_no = format->map_no;
    view->dungeon_no = save_buffer->dungeon_no;
    view->floor_id = save_buffer->floor_id;
    view->play_time = format->save_data.play_time;
    view->progress = format->save_data.game_progress;
    view->debug_code = format->debug_code;
    view->omake_flag = format->omake_flag;
    view->costume_bit = format->costume_bit;
    view->unique_counter = format->unique_counter;
    view->fish_num = format->fish_num;
}

int CMemoryCardManager::Step() {
    int          status = 0;
    int          changed = false;
    int          delete_index = {};
    unsigned int job = func_no;

    switch (job) {
        case MC_FUNC_SEARCH_TYPE:
            status = SearchMcType();
            break;
        case MC_FUNC_IDLE:
            search_wait++;

            if (search_wait >= 10) {
                status = SearchMcType();
                search_wait = 0;
            }

            break;
        case MC_FUNC_NONE:
            status = MC_STEP_DONE;
            break;
        case MC_FUNC_MAKE_DIR:
            status = MakeDir(file_no);
            break;
        case MC_FUNC_GET_ALL_FILE_INFO:
            status = GetAllSaveFileInfo();
            break;
        case MC_FUNC_MAKE_ALBUM_DIR:
            status = MakeDir(-1);
            break;
        case MC_FUNC_SAVE:
            status = SaveToMc(file_no);
            break;
        case MC_FUNC_LOAD:
            status = LoadFromMc(file_no);

            if (status != 0) {
                dc2::log::PrintGame("funcphase : %d\n", step);
            }

            break;
        case MC_FUNC_SAVE_ALBUM:
            status = SaveAlbum();
            break;
        case MC_FUNC_LOAD_ALBUM:
            status = LoadAlbum();
            break;
        case MC_FUNC_CHECK_ALBUM:
            status = CheckAlbum();
            break;
        case MC_FUNC_MAKE_OMAKE_DIR:
            status = MakeDir(-2);
            break;
        case MC_FUNC_FORMAT:
            status = Format();
            break;
        case MC_FUNC_UNFORMAT:
            status = UnFormat();
            break;
        case MC_FUNC_DELETE:
            if (error.code == MC_ERROR_NONE) {
                delete_index = file_no;
            } else {
                delete_index = error.file_no;
            }

            status = DeleteFile(delete_index);
            break;
        case MC_FUNC_SAVE_OMAKE:
            status = SaveOamkeFile();
            break;
        case MC_FUNC_LOAD_OMAKE:
            status = LoadOmakeFile();
            break;
        case MC_FUNC_CHECK_OMAKE:
            status = CheckOmakeFile();
            break;
        case MC_FUNC_WRITE_TEST:
            status = Write();
            break;
        case MC_FUNC_CONVERT:
            status = Convert();
            break;
    }

    if (status == MC_STEP_DONE) {
        step = 0;
        SetFuncNo(MC_FUNC_IDLE);
    } else if (status != MC_STEP_BUSY) {
        McError(status);
    }

    if (job != func_no) {
        changed = true;
    }

    return changed;
}

char *CMemoryCardManager::GetVersion() {
    return version;
}

int CMemoryCardManager::SearchMcType() {
    /** Format state before the current card-type query. */
    static int    old_format;
    int           command = {};
    int           result = {};
    MC_CARD_INFO *card = {};

    if (port == 0 || (card = nullptr, port == 1)) {
        card = &this->card[port];
    }

    if (card == nullptr) {
        return MC_STEP_BUSY;
    }

    if (step == 0) {
        old_format = card->formatted;
    }

    switch (step % 2) {
        case 0:
            if (sceMcSync(MC_NOWAIT, nullptr, nullptr) != 0) {
                InitError();
                int status =
                    sceMcGetInfo(port, 1, &card->type, &card->free_size, &card->formatted);

                if (status == 0) {
                    step++;
                } else if (status != MC_COMMAND_BUSY) {
                    step += 2;
                }
            }

            break;
        case 1:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                card->present = 1;
                card->result = result;

                switch (result) {
                    case 0:
                        break;
                    case sceMcResChangedCard:
                        card->formatted = 1;
                        break;
                    case sceMcResNoFormat:
                        card->formatted = 0;
                        break;
                    default:
                        if (result < -10) {
                            card->present = 0;
                        }

                        break;
                }

                step++;

                if (step >= 2) {
                    if (card->present != 0) {
                        if (card->formatted != 0) {
                            if (old_format != 0 && card->formatted != 0) {
                                card->format_change = 0;
                            }

                            if (old_format == 0) {
                                if (card->formatted != 0) {
                                    card->format_change = 1;
                                }
                            }

                            return MC_STEP_DONE;
                        }
                    }
                }

                if (step >= 10) {
                    if (old_format != 0 && card->formatted != 0) {
                        card->format_change = 0;
                    }

                    if (old_format == 0 && card->formatted == 0) {
                        card->format_change = 0;
                    }

                    if (old_format == 0 && card->formatted != 0) {
                        card->format_change = 1;
                    }

                    if (old_format != 0) {
                        if (card->formatted == 0) {
                            card->format_change = -1;
                        }
                    }

                    return MC_STEP_DONE;
                }
            }

            break;
    }

    return MC_STEP_BUSY;
}

int CMemoryCardManager::Write() {
    int                           result = {};
    int                           command = {};
    std::array<std::byte, 0x1000> buffer{};
    int                           remaining = {};
    result = 0;
    sceMcChdir(port, 1, "/", {});
    sceMcSync(MC_WAIT, &command, &result);
    sceMcOpen(port, 1, at_1315__3, SCE_CREAT | SCE_WRONLY);
    sceMcSync(MC_WAIT, &command, &result);
    if (result < 0) {
        McError(result);
        return MC_STEP_FAILED;
    }
    fd = result;
    auto opened_descriptor = dc2::mc::TakeCompletedOpen(command, result);
    if (!opened_descriptor) {
        error.code = MC_ERROR_COMMAND;
        return MC_STEP_FAILED;
    }
    descriptor = *opened_descriptor;
    remaining = 0x758000;

    do {
        int chunk = 0x1000;

        if (remaining < 0x1000) {
            chunk = remaining;
        }

        descriptor.Write(buffer, chunk);
        sceMcSync(MC_WAIT, &command, &result);
        if (result <= 0 || result > chunk) {
            CloseManagedFile(*this);
            sceMcSync(MC_WAIT, nullptr, nullptr);
            McError(result);
            error.code = MC_ERROR_FILE;
            fd = -1;
            return MC_STEP_FAILED;
        }
        remaining -= result;
    } while (remaining > 0);

    descriptor.Flush();
    sceMcSync(MC_WAIT, &command, &result);
    CloseManagedFile(*this);
    sceMcSync(MC_WAIT, &command, &result);
    return MC_STEP_DONE;
}

int CMemoryCardManager::Convert() {
    return MC_STEP_DONE;
}

int CMemoryCardManager::MakeDir(int file_no) {
    std::string   path = "/" + SaveSlotName(file_no);
    int           result = {};
    int           command = {};
    MC_CARD_INFO *card = {};

    result = 0;

    /** Icon file currently being written during directory creation. */
    static int iconNo = -1;

    if (file_no == -1) {
        path = "/BESCES-51190dc2album";
    }

    if (file_no == -2) {
        path = "/BESCES-51190dc2omake";
    }

    if (port == 0 || port == 1) {
        card = &this->card[port];
    } else {
        card = nullptr;
    }

    MC_ERROR_INFO *errors = &error;

    switch (step) {
        case 0:
            if (sceMcSync(MC_NOWAIT, nullptr, nullptr) != 0) {
                InitError();
                total_transferred = 0;
                int made = sceMcMkdir(port, 1, path.c_str());

                if (made == 0) {
                    step++;
                } else if (made != MC_COMMAND_BUSY) {
                    errors->code = MC_ERROR_COMMAND;
                    return MC_STEP_DONE;
                }
            }

            break;
        case 1:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0 && command == sceMcFuncNoMkdir) {
                if (result < 0 && result != sceMcResNoEntry) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                path += "/icon.sys";

                if (sceMcOpen(port, 1, path.c_str(), SCE_CREAT | SCE_WRONLY) == 0) {
                    iconNo = -1;
                    step++;
                    break;
                }

                return MC_STEP_FAILED;
            }

            break;
        case 2:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    if (result == sceMcResNoFormat) {
                        card->formatted = 0;
                    }

                    if (result < -10) {
                        card->present = 0;
                    }

                    McError(result);
                    return MC_STEP_DONE;
                }

                fd = result;
                auto opened_descriptor = dc2::mc::TakeCompletedOpen(command, result);
                if (!opened_descriptor) {
                    error.code = MC_ERROR_COMMAND;
                    return MC_STEP_FAILED;
                }
                descriptor = *opened_descriptor;
                transferred = 0;

                if (album_buffer_set == 0 && file_no != -2) {
                    const auto title = MakeMemoryCardBrowserTitle(file_no);
                    const auto browser = BrowserTitleFor(MC_BROWSER_NAME_SAVE_NUM);
                    if (!title || !browser) {
                        return MC_STEP_FAILED;
                    }
                    std::memcpy(icon_sys.title_name, title->data(), title->size());
                    icon_sys.title_name[title->size()] = 0;
                    icon_sys.nl_offset = browser->line_offset;
                }

                transfer_result = 0;
                transfer_size = sizeof(icon_sys);
                write_buffer = std::as_bytes(std::span(&icon_sys, 1));

                if (descriptor.Write(write_buffer, transfer_size) == 0) {
                    step++;
                    break;
                }

                return MC_STEP_FAILED;
            }

            break;
        case 3:
        case 7:
        case 11:
        case 15:
            if (sceMcSync(MC_NOWAIT, &command, &transfer_result) != 0) {
                if (transfer_result <= 0) {
                    error.code = MC_ERROR_FILE;
                    if (transfer_result < -10) {
                        card->present = 0;
                    }

                    McError(transfer_result);
                    return MC_STEP_DONE;
                }

                transferred += transfer_result;
                total_transferred += transfer_result;
                int done = transferred;
                int total = transfer_size;

                if (done >= total) {
                    transferred = 0;

                    if (descriptor.Flush() == 0) {
                        step++;
                        break;
                    }

                    return MC_STEP_FAILED;
                }

                int left = total - done;
                int chunk = 0xC00;

                if (left < 0xC00) {
                    chunk = left;
                }

                descriptor.Write(TransferTail(write_buffer, done), chunk);
            }

            break;
        case 4:
        case 8:
        case 12:
        case 16:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (command != sceMcFuncNoFlush) {
                    errors->code = MC_ERROR_COMMAND;
                    return MC_STEP_DONE;
                }

                if (result < 0) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                command = CloseManagedFile(*this);

                if (command == 0) {
                    step++;
                    break;
                }

                errors->code = MC_ERROR_COMMAND;
                return MC_STEP_DONE;
            }

            break;
        case 5:
        case 9:
        case 13:
        case 17:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (command != sceMcFuncNoClose) {
                    errors->code = MC_ERROR_COMMAND;
                    return MC_STEP_DONE;
                }

                if (result < 0) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                iconNo++;

                if (iconNo < 3) {
                    path += "/";
                    const auto icon_name = dc2::text::View(icon[iconNo].name);
                    path.append(icon_name.data(), icon_name.size());
                    command = sceMcOpen(port, 1, path.c_str(), SCE_CREAT | SCE_RDWR);

                    if (command == 0) {
                        step++;
                        break;
                    }

                    return MC_STEP_FAILED;
                }

                return MC_STEP_DONE;
            }

            break;
        case 6:
        case 10:
        case 14:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    if (result < -10) {
                        card->present = 0;
                    }

                    McError(result);
                    return MC_STEP_DONE;
                }

                fd = result;
                auto opened_descriptor = dc2::mc::TakeCompletedOpen(command, result);
                if (!opened_descriptor) {
                    error.code = MC_ERROR_COMMAND;
                    return MC_STEP_FAILED;
                }
                descriptor = *opened_descriptor;
                transferred = 0;
                write_buffer = std::as_bytes(icon[iconNo].resource.Bytes());
                if (write_buffer.size() > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
                    errors->code = MC_ERROR_FILE;
                    return MC_STEP_FAILED;
                }
                transfer_size = static_cast<int>(write_buffer.size());
                command = descriptor.Write(write_buffer, std::min(transfer_size, 0xC00));

                if (command == 0) {
                    step++;
                    break;
                }

                return MC_STEP_FAILED;
            }

            break;
    }

    return MC_STEP_BUSY;
}

int GetCostumeList(u_long mask, int type, short *list) {
    if (list == nullptr) {
        return 0;
    }

    int          count = 0;
    COSBIT_INFO *row = cosbit_table;
    u_long       bit = 1;

    for (unsigned long long i = 0; i < MC_COSTUME_COUNT; i++) {
        if ((mask & bit) && type == GetItemDataType(row->item_no)) {
            count++;
            *list = row->item_no;
            list++;
        }

        bit <<= 1;
        row++;
    }

    *list = -1;
    return count;
}

int CMemoryCardManager::SaveAlbum() {
    if (album_buffer == nullptr || album_storage.Bytes().size() != sizeof(*album_buffer)) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_FAILED;
    }
    InitError();
    descriptor.Release();
    read_buffer = {};
    write_buffer = {};
    transferred = total_transferred = transfer_size = 0;
    const auto path = AlbumPath(port);
    if (!path || !AlbumCardReady(*this)) {
        return MC_STEP_DONE;
    }
    const auto image = dc2::mc::EncodeAlbum(*album_buffer);
    if (image.empty() || FilesWrite(*path, image.data(), image.size(), true) != FilesResult::kWritten) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    transfer_size = transferred = total_transferred = static_cast<int>(image.size());
    file_exists = 1;
    return MC_STEP_DONE;
}

int CMemoryCardManager::LoadAlbum() {
    if (album_buffer == nullptr || album_storage.Bytes().size() != sizeof(*album_buffer)) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_FAILED;
    }
    InitError();
    descriptor.Release();
    read_buffer = {};
    write_buffer = {};
    transferred = total_transferred = transfer_size = 0;
    const auto path = AlbumPath(port);
    if (!path || !AlbumCardReady(*this)) {
        return MC_STEP_DONE;
    }
    std::error_code read_error;
    const auto      size = std::filesystem::file_size(*path, read_error);
    if (read_error || !dc2::mc::IsAlbumImageSize(size)) {
        if (read_error == std::errc::no_such_file_or_directory) {
            file_exists = 0;
        }
        error.code = MC_ERROR_BROKEN;
        return MC_STEP_DONE;
    }
    std::vector<std::byte> image(static_cast<std::size_t>(size));
    if (FilesRead(*path, image.data(), image.size()) != image.size()) {
        error.code = MC_ERROR_BROKEN;
        return MC_STEP_DONE;
    }
    const auto current_size = std::filesystem::file_size(*path, read_error);
    if (read_error || current_size != size || !dc2::mc::DecodeAlbum(image, *album_buffer)) {
        error.code = MC_ERROR_BROKEN;
        return MC_STEP_DONE;
    }
    transfer_size = transferred = total_transferred = static_cast<int>(image.size());
    file_exists = 1;
    return MC_STEP_DONE;
}

int CMemoryCardManager::CheckAlbum() {
    int            command = {};
    int            result = {};
    int           *album_found = &file_exists;
    MC_ERROR_INFO *error_record = &error;

    switch (step) {
        case 0:
            if (sceMcSync(MC_NOWAIT, nullptr, nullptr) != 0) {
                InitSaveFileInfoTable();
                const std::string album_name = MakeMemoryCardAlbumName(true);
                int               status = sceMcGetDir(port, 1, album_name.c_str(), 0, MC_DIR_TABLE_NUM, dir_table);
                *album_found = 0;

                if (status == 0) {
                    step = 1;
                } else {
                    error_record->code = MC_ERROR_NONE;
                    return MC_STEP_DONE;
                }
            }

            break;
        case 1:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                dir_entries = 0;
                *album_found = 0;

                if (result >= 0) {
                    error_record->code = MC_ERROR_NONE;

                    if (result > 0) {
                        *album_found = 1;
                    }

                    dir_entries = result;
                    unsigned int file_size = dir_table[0].file_size_byte;

                    if (file_size < GetSaveDataSize(MC_SIZE_ALBUM_FILE)) {
                        error_record->code = MC_ERROR_BROKEN;
                        *album_found = 0;
                    }

                    strlen(dir_table[0].entry_name);
                    return MC_STEP_DONE;
                }

                McError(result);

                if (result == sceMcResNoFormat) {
                    error_record->code = MC_ERROR_UNFORMATTED;
                } else if (result == sceMcResNoEntry) {
                    error_record->code = MC_ERROR_NONE;
                    *album_found = 0;
                    dir_entries = result;
                    return MC_STEP_DONE;
                }

                error_record->func_no = GetFuncNo();
                error_record->step = step;
                return MC_STEP_DONE;
            }

            break;
    }

    return MC_STEP_BUSY;
}

int CMemoryCardManager::SaveOamkeFile() {
    char          path[0x80];
    int           result = {};
    int           command = {};
    MC_CARD_INFO *card = {};

    result = 0;

    if (port == 0 || port == 1) {
        card = &this->card[port];
    } else {
        card = nullptr;
    }

    MC_ERROR_INFO *errors = &error;

    switch (step) {
        case 0: {
            int synced = sceMcSync(MC_NOWAIT, nullptr, nullptr);

            if (McCheckMCPs2(card) == 0) {
                return MC_STEP_DONE;
            }

            if (synced != 0) {
                InitError();
                dc2::text::Copy(path, dc2::text::View("/BESCES-51190dc2omake/"));
                dc2::text::Append(path, dc2::text::View(icon[2].name));

                if (sceMcOpen(port, 1, path, SCE_RDONLY) == 0) {
                    step++;
                    break;
                }

                return MC_STEP_DONE;
            }

            break;
        }
        case 1:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (0 > result) {
                    McError(result);

                    if (result == sceMcResNoEntry) {
                        errors->code = MC_ERROR_FILE;
                    }

                    return MC_STEP_DONE;
                } else {
                    read_buffer = std::as_writable_bytes(SubGameOmakeTempBuffer.Bytes());
                    transfer_result = 0;
                    transferred = 0;
                    total_transferred = 0;
                    fd = result;
                    auto opened_descriptor = dc2::mc::TakeCompletedOpen(command, result);
                    if (!opened_descriptor) {
                        error.code = MC_ERROR_COMMAND;
                        return MC_STEP_FAILED;
                    }
                    descriptor = *opened_descriptor;
                    descriptor.Read(read_buffer, IconSize(icon[2]));
                    step++;
                }
            }

            break;
        case 2:
            if (McCheckMCPs2(card) == 0) {
                return MC_STEP_DONE;
            }

            if (sceMcSync(MC_NOWAIT, &command, &transfer_result) != 0) {
                if (transfer_result <= 0) {
                    error.code = MC_ERROR_FILE;
                    McError(transfer_result);
                    return MC_STEP_FAILED;
                }

                if (transfer_result != IconSize(icon[2])) {
                    errors->code = MC_ERROR_FILE;
                    McError(result);
                    return MC_STEP_FAILED;
                }

                if (CloseManagedFile(*this) == 0) {
                    step = 0xA;
                    break;
                }

                return MC_STEP_FAILED;
            }

            break;
        case 0xA:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                CSubGameData *sub_game = GetSubGameSaveData();

                if (sub_game == nullptr) {
                    return MC_STEP_DONE;
                }

                transferred = 0;
                total_transferred = 0;
                sub_game->incomplete = 1;
                transfer_size = GetSaveDataSize(MC_SIZE_OMAKE_FILE);
                transfer_result = 0;
                transferred = 0;
                total_transferred = 0;
                write_buffer = std::as_bytes(std::span(sub_game, 1));
                sceMcOpen(port, 1, at_1954, SCE_CREAT | SCE_WRONLY);
                step = 0x64;
            }

            break;
        case 0x64:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                fd = result;
                auto opened_descriptor = dc2::mc::TakeCompletedOpen(command, result);
                if (!opened_descriptor) {
                    error.code = MC_ERROR_COMMAND;
                    return MC_STEP_FAILED;
                }
                descriptor = *opened_descriptor;

                if (descriptor.Write(write_buffer, 0xC00) == 0) {
                    step = 0x6E;
                    break;
                }

                return MC_STEP_FAILED;
            }

            break;
        case 0x6E:
            if (sceMcSync(MC_NOWAIT, &command, &transfer_result) != 0) {
                if (transfer_result <= 0) {
                    error.code = MC_ERROR_FILE;
                    McError(transfer_result);
                    return MC_STEP_DONE;
                }

                transferred += transfer_result;
                total_transferred += transfer_result;
                int done = transferred;
                int total = transfer_size;

                if (done >= total) {
                    if (descriptor.Flush() == 0) {
                        step++;
                        break;
                    }

                    return MC_STEP_FAILED;
                }

                int left = total - done;
                int chunk = 0xC00;

                if (left < 0xC00) {
                    chunk = left;
                }

                descriptor.Write(TransferTail(write_buffer, done), chunk);
            }

            break;
        case 0x6F:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                descriptor.Seek(0, SCE_SEEK_SET);
                sceMcSync(MC_WAIT, nullptr, nullptr);
                CSubGameData *sub_game = GetSubGameSaveData();
                if (sub_game == nullptr) {
                    error.code = MC_ERROR_FILE;
                    return MC_STEP_FAILED;
                }
                sub_game->incomplete = 0;
                descriptor.Write(std::as_bytes(std::span(sub_game, 1)), 1);
                step++;
            }

            break;
        case 0x70:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                CloseManagedFile(*this);
                step++;
            }

            break;
        case 0x71:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                }

                return MC_STEP_DONE;
            }

            break;
    }

    return MC_STEP_BUSY;
}

int CMemoryCardManager::LoadOmakeFile() {
    int           result = {};
    int           command = {};
    MC_CARD_INFO *card = {};

    if (port == 0 || (card = nullptr, port == 1)) {
        card = &this->card[port];
    }

    switch (step) {
        case 0:
            if (sceMcSync(MC_NOWAIT, nullptr, nullptr) != 0) {
                if (McCheckMCPs2(card) == 0) {
                    return MC_STEP_DONE;
                }

                InitError();
                CSubGameData *sub_game = GetSubGameSaveData();

                if (sub_game == nullptr) {
                    return MC_STEP_DONE;
                }

                sub_game->Initialize();
                transfer_size = sizeof(CSubGameData);
                memset(sub_game, 0, transfer_size);
                transfer_result = 0;
                transferred = 0;
                total_transferred = 0;
                read_buffer = std::as_writable_bytes(std::span(sub_game, 1));
                int opened = sceMcOpen(port, 1, at_1954, SCE_RDONLY);
                step++;

                if (opened != 0 && opened != MC_COMMAND_BUSY) {
                    error.code = MC_ERROR_COMMAND;
                    return MC_STEP_DONE;
                }
            }

            break;
        case 1:
            if (sceMcSync(MC_WAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                fd = result;
                auto opened_descriptor = dc2::mc::TakeCompletedOpen(command, result);
                if (!opened_descriptor) {
                    error.code = MC_ERROR_COMMAND;
                    return MC_STEP_FAILED;
                }
                descriptor = *opened_descriptor;

                if (descriptor.Read(read_buffer, 0x1000) == 0) {
                    step++;
                    break;
                }

                error.code = MC_ERROR_LOAD;
                return MC_STEP_DONE;
            }

            break;
        case 2:
            if (sceMcSync(MC_NOWAIT, &command, &transfer_result) != 0) {
                int transferred = transfer_result;

                if (transferred <= 0) {
                    McError(transferred);
                    error.code = MC_ERROR_LOAD;
                    return MC_STEP_DONE;
                }

                this->transferred += transferred;
                total_transferred += transfer_result;
                int done = this->transferred;

                if (done >= transfer_size) {
                    if (CloseManagedFile(*this) == 0) {
                        step++;
                        break;
                    }

                    error.code = MC_ERROR_LOAD;
                    return MC_STEP_DONE;
                }

                descriptor.Read(TransferTail(read_buffer, done), std::min(transfer_size - done, 0x1000));
            }

            break;
        case 3:
            if (sceMcSync(MC_WAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                int incomplete = 0;

                if (transferred != transfer_size) {
                    incomplete = 1;
                }

                if (incomplete != 0) {
                    error.code = MC_ERROR_LOAD;
                    return MC_STEP_DONE;
                }

                return MC_STEP_DONE;
            }

            break;
    }

    return MC_STEP_BUSY;
}

int CMemoryCardManager::CheckOmakeFile() {
    int            command = {};
    int            result = {};
    int           *album_found = &file_exists;
    MC_ERROR_INFO *error_record = &error;

    switch (step) {
        case 0:
            if (sceMcSync(MC_NOWAIT, nullptr, nullptr) != 0) {
                InitSaveFileInfoTable();
                *album_found = 0;

                if (sceMcGetDir(port, 1, "/BESCES-51190dc2omake/*", 0, 0xD, dir_table) == 0) {
                    step = 1;
                } else {
                    error_record->code = MC_ERROR_NONE;
                    return MC_STEP_DONE;
                }
            }

            break;
        case 1:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                dir_entries = 0;

                if (result >= 7) {
                    error_record->code = MC_ERROR_NONE;
                    *album_found = 1;
                    album_found[1] = 0;
                    dir_entries = result;
                    unsigned int file_size = dir_table[6].file_size_byte;

                    if (file_size < GetSaveDataSize(MC_SIZE_OMAKE_FILE)) {
                        error_record->code = MC_ERROR_BROKEN;
                        *album_found = 0;
                    }

                    for (int i = 0; i < result; i++) {
                        strlen(dir_table[i].entry_name);
                    }

                    step = 2;
                    sceMcOpen(port, 1, at_1954, SCE_RDONLY);
                    break;
                }

                if (result < 0) {
                    McError(result);

                    if (result == sceMcResNoFormat) {
                        error_record->code = MC_ERROR_UNFORMATTED;
                    } else if (result == sceMcResNoEntry) {
                        error_record->code = MC_ERROR_NONE;
                        dir_entries = result;
                        return MC_STEP_DONE;
                    }

                    error_record->func_no = GetFuncNo();
                    error_record->step = step;
                    return MC_STEP_DONE;
                }

                error_record->code = MC_ERROR_FILE;
                *album_found = 2;
                return MC_STEP_DONE;
            }

            break;
        case 2:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (0 > result) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                fd = result;
                auto opened_descriptor = dc2::mc::TakeCompletedOpen(command, result);
                if (!opened_descriptor) {
                    error.code = MC_ERROR_COMMAND;
                    return MC_STEP_FAILED;
                }
                descriptor = *opened_descriptor;
                descriptor.Read(std::as_writable_bytes(std::span(work_buffer)), 0x100);

                if (sceMcSync(MC_WAIT, &command, &result) != 0) {
                    if (0 > result) {
                        McError(result);
                        return MC_STEP_DONE;
                    }

                    CloseManagedFile(*this);
                    step++;
                }
            }

            break;
        case 3:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (0 > result) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                CSubGameData sub_game;
                auto         header = std::as_writable_bytes(std::span(&sub_game, 1));
                static_assert(sizeof(sub_game) >= 0x100);
                std::ranges::copy(std::as_bytes(std::span(work_buffer)).first(0x100), header.begin());

                if (album_found != nullptr) {
                    album_found[1] = sub_game.play_enable;
                }

                return MC_STEP_DONE;
            }

            break;
    }

    return MC_STEP_BUSY;
}

int CMemoryCardManager::Format() {
    int            command = {};
    int            result = {};
    MC_CARD_INFO  *record = {};
    MC_ERROR_INFO *error_record = {};
    int            current_port = port;

    if (current_port == 0 || (record = nullptr, current_port == 1)) {
        record = &card[current_port];
    }

    error_record = &error;

    switch (step) {
        case 0:
            if (sceMcSync(MC_NOWAIT, nullptr, nullptr) != 0) {
                if (sceMcFormat(port, 1) == 0) {
                    step += 1;
                } else {
                    error_record->code = MC_ERROR_COMMAND;
                    return MC_STEP_DONE;
                }
            }

            break;
        case 1:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    return MC_STEP_DONE;
                }

                step += 1;
            }

            break;
        case 2:
            if (sceMcGetInfo(port, 1, &record->type, &record->free_size, &record->formatted) ==
                0) {
                step += 1;
            } else {
                error_record->code = MC_ERROR_COMMAND;
                return MC_STEP_DONE;
            }

            break;
        case 3:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);

                    if (result < -9) {
                        record->present = 0;
                    }

                    return MC_STEP_DONE;
                }

                record->present = 1;
                return MC_STEP_DONE;
            }

            break;
    }

    return MC_STEP_BUSY;
}

int CMemoryCardManager::DeleteFile(int index) {
    int result = {};
    int command = {};

    switch (step) {
        case 0:
            if (sceMcSync(MC_NOWAIT, nullptr, nullptr) != 0) {
                std::string name = "darkcloud" + std::to_string(index);

                if (sceMcDelete(port, 1, name.data()) == 0) {
                    step += 1;
                } else {
                    sceMcSync(MC_NOWAIT, nullptr, nullptr);
                }
            }

            break;
        case 1:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0 && command == sceMcFuncNoDelete) {
                if (result < 0) {
                    error.retry_count += 1;

                    if (error.retry_count > 0x78) {
                        return MC_STEP_DONE;
                    }

                    break;
                }

                return MC_STEP_DONE;
            }

            break;
    }

    return MC_STEP_BUSY;
}

int CMemoryCardManager::McError(int code) {
    MC_CARD_INFO  *record = {};
    MC_ERROR_INFO *error_record = &error;

    if (port == 0 || (record = nullptr, port == 1)) {
        record = &card[port];
    }

    switch (code) {
        case sceMcResNoFormat:
        case sceMcResFailDetect:
            error_record->code = MC_ERROR_UNFORMATTED;
            record->formatted = 0;
            break;
        case sceMcResFullDevice:
            error_record->code = MC_ERROR_FULL;
            break;
        case sceMcResNoEntry:
        case sceMcResDeniedPermit:
            break;
        case sceMcResFailReplace:
            break;
    }

    if (code < -10) {
        error_record->code = MC_ERROR_NO_CARD;
        record->present = 0;

        if (func_no == MC_FUNC_SAVE) {
            error_record->code = MC_ERROR_FILE;
        }
    }

    if (code < 0) {
        error_record->func_no = GetFuncNo();
        error_record->step = step;
        error_record->file_no = file_no;
    }

    return 1;
}

int CMemoryCardManager::UnFormat() {
    int status = {};
    int command = {};
    int result = {};

    switch (step) {
        case 0:
            status = sceMcUnformat(port, 1);

            if (status == 0) {
                step += 1;
            } else {
                sceMcSync(MC_NOWAIT, &status, &result);
            }

            break;
        case 1:
            status = sceMcSync(MC_NOWAIT, &command, &result);

            if (status != 0 && command == sceMcFuncNoUnformat && result >= 0) {
                card[port].formatted = 0;
                return MC_STEP_DONE;
            }

            break;
    }

    return MC_STEP_BUSY;
}

int CMemoryCardManager::GetSaveFileInfoFromMc(int index, int *step) {
    if (index < 0 || index >= MC_SAVE_FILE_NUM || step == nullptr || *step < 0 ||
        *step > std::numeric_limits<int>::max() - 4 || save_buffer == nullptr) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_FAILED;
    }
    int            command = {};
    int            result = {};
    SAVEDATA_INFO *slot = &file_info[index];

    int phase = *step;

    switch (phase % 4) {
        case 0:
            if (sceMcSync(MC_NOWAIT, nullptr, nullptr) != 0) {
                memset(slot, 0, sizeof(SAVEDATA_INFO));
                std::string save_name = SaveSlotName(index);

                if (GetOpenAttribute(save_name.data()) == 0) {
                    *step += 4;
                    return -1;
                }

                const std::string file_name = MakeMemoryCardFileName(index);

                if (sceMcOpen(port, 1, file_name.c_str(), SCE_RDONLY) == 0) {
                    *step += 1;
                    break;
                }

                *step += 4;
                return 1;
            }

            break;
        case 1:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    *step += 3;
                    return 1;
                }

                fd = result;
                auto opened_descriptor = dc2::mc::TakeCompletedOpen(command, result);
                if (!opened_descriptor) {
                    error.code = MC_ERROR_COMMAND;
                    return MC_STEP_FAILED;
                }
                descriptor = *opened_descriptor;
                transferred = 0;
                transfer_result = 0;
                transfer_size = 0x2800;
                error.retry_count = 0;
                static_assert(sizeof(SAVEDATA_FORMAT) >= 0x2800);
                const auto header = std::as_writable_bytes(std::span(save_buffer, 1)).first(0x2800);
                std::ranges::fill(header, std::byte{});

                if (descriptor.Read(header, transfer_size) == 0) {
                    *step += 1;
                    break;
                }

                McError(result);
                *step += 3;
                return 1;
            }

            break;
        case 2:
            if (sceMcSync(MC_NOWAIT, &command, &transfer_result) != 0) {
                int transferred = transfer_result;

                if (transferred <= 0) {
                    McError(transferred);
                    *step += 2;
                    return 1;
                }

                this->transferred += transferred;
                total_transferred += transfer_result;

                if (this->transferred < transfer_size) {
                    if (CloseManagedFile(*this) == 0) {
                        *step += 1;
                    } else {
                        *step += 2;
                        return -1;
                    }
                }

                if (this->transferred >= transfer_size) {
                    if (CloseManagedFile(*this) == 0) {
                        *step += 1;
                        break;
                    }

                    *step += 2;
                    return -1;
                }
            }

            break;
        case 3:
            if (sceMcSync(MC_NOWAIT, &command, &result) != 0) {
                if (result < 0) {
                    McError(result);
                    *step += 1;
                    return -1;
                }

                MC_ERROR_INFO *error_record = &error;

                if (this->transferred < transfer_size) {
                    slot->state = 0;
                    error_record->code = MC_ERROR_BROKEN;
                    error_record->file_no = file_no;
                    *step += 1;
                    return -1;
                }

                int broken = 0;

                if (dc2::text::View(save_buffer->version) != "dc2Ver4") {
                    broken = 1;
                }

                if (broken != 0) {
                    dc2::log::PrintGame("differnt version\n");
                }

                if (static_cast<s8>((save_buffer)->incomplete) != 0) {
                    broken = 1;
                }

                if (slot != nullptr) {
                    slot->state = 0;

                    if (broken == 0) {
                        slot->state = 1;
                        slot->file_no = index;
                        UpDateViewInfo(slot, save_buffer);
                    }
                }

                *step += 1;
                return 1;
            }

            break;
    }

    return 0;
}

int McCheckMCPs2(MC_CARD_INFO *info) {
    if (info == nullptr) {
        return 0;
    }

    if (info->present == 0 || info->type != sceMcTypePS2) {
        return 0;
    }

    return 1;
}

int McCheckMCPs2Boot(MC_CARD_INFO *info, int blocks_needed) {
    if (info == nullptr) {
        return 0;
    }

    if (info->present == 0 || info->type != sceMcTypePS2) {
        return 0;
    }

    if (info->formatted != 0 && info->free_size <= blocks_needed) {
        return 0;
    }

    return 1;
}

COSBIT_INFO *GetCosInfo(int costume_no) {
    COSBIT_INFO *row = cosbit_table;

    for (int i = 0; i < MC_COSTUME_COUNT; i++) {
        if (row->item_no == costume_no) {
            return row;
        }

        row++;
    }

    return nullptr;
}

s16 NowProgramLoopNo = -1;

dc2::memory::ArenaBuffer SubGameOmakeTempBuffer;

#include <algorithm>
#include <cstring>
#include <filesystem>
#include <limits>
#include <memory>
#include <type_traits>
#include <utility>

#include "mainloop.hpp"
#include "memcard.hpp"
#include "play_time.hpp"
#include "save_slots.hpp"
#include "title.hpp"
#include "userdata.hpp"

namespace {
CMemoryCardManager *active_manager;
int                 dungeon_tree_flag;

int Digit(const CSaveData &save, std::size_t size) {
    const auto *bytes = reinterpret_cast<const unsigned char *>(&save);
    int         digit = 0;
    for (std::size_t i = 0; i < size / 64; ++i) {
        digit += bytes[i * 64] % 255;
    }
    return digit;
}

u64 MaxUniqueCounter(const SaveSlotList &list) {
    u64 newest = 0;
    for (const auto &slot : list.saves) {
        if (slot.state == SaveSlotState::Ready && slot.info.state) {
            newest = std::max(newest, slot.info.unique_counter);
        }
    }
    return newest;
}

/**
 * Owns the floor-entry save and each town's layout before the floor's arrival events.
 */
std::unique_ptr<SaveDocument> floor_entry;

/**
 * Returns the saved stage and floor, using -1 for an invalid stage's floor.
 */
std::pair<int, int> FloorOf(const CSaveData &save) {
    const auto &dungeon = save.save_dungeon;
    if (dungeon.stage_id < 0 || dungeon.stage_id >= SAVE_DUNGEON_NUM) {
        return {dungeon.stage_id, -1};
    }
    return {dungeon.stage_id, dungeon.floor_id[dungeon.stage_id]};
}

// Builds the retail save image; no PC metadata is embedded in the payload.
void BuildImage(SAVEDATA_FORMAT &image, int program_loop_no, unsigned long long newest) {
    auto &save = *GetSaveData();
    std::memset(&image, 0, sizeof(image));
    dc2::text::Copy(image.version, dc2::text::View("dc2Ver4"));
    std::memcpy(&image.save_data, &save, sizeof(save));
    if (save.GetBitFlag(SAVE_FLAG_COSTUME_UNLOCK)) {
        image.costume_bit = save.user_data.GetCostumeBit();
        image.omake_flag |= OMAKE_ENABLE_COSTUME | OMAKE_ENABLE_DUNGEON;
    }
    if (save.GetBitFlag(SAVE_FLAG_FINNY_FRENZY_UNLOCKED)) {
        image.omake_flag |= OMAKE_ENABLE_GYORACE;
    }
    image.dng_tree_flag = dungeon_tree_flag;
    image.unique_counter = newest == std::numeric_limits<unsigned long long>::max() ? newest : newest + 1;
    image.progress = save.game_progress;
    image.fish_num = save.user_data.CountFish();
    image.program_loop_no = program_loop_no;
    image.map_no = save.map_no;
    image.dungeon_no = save.save_dungeon.stage_id;
    if (image.dungeon_no >= 0 && image.dungeon_no < SAVE_DUNGEON_NUM) {
        image.floor_id = save.save_dungeon.floor_id[image.dungeon_no];
    }
    image.check_digit_half = Digit(image.save_data, sizeof(CSaveData) / 2);
    image.check_digit = Digit(image.save_data, sizeof(CSaveData));
}

// Every save's, the autosave's included, so that the newest save is the one written last.
u64 NewestCounter() {
    return MaxUniqueCounter(SaveSlotScan(true));
}

// The game as it stands: the retail image and the layouts the towns keep beside their records.
std::unique_ptr<SaveDocument> BuildDocument(int program_loop_no, unsigned long long newest) {
    auto document = std::make_unique<SaveDocument>();
    BuildImage(document->image, program_loop_no, newest);
    const auto &save = *GetSaveData();
    for (std::size_t i = 0; i < document->towns.size(); ++i) {
        if (const TownLayout *town = PortFindTownLayout(save.edit_data[i])) {
            document->towns[i] = *town;
        }
    }
    return document;
}
} // namespace

bool SaveSlotWriteAutosave(int program_loop_no, const AutosaveSpawn *spawn) {
    if ((program_loop_no != LOOP_EDIT && program_loop_no != LOOP_DUNGEON) ||
        FilesCreateDirectory(SaveSlotsRoot()) == FilesResult::kFailed) {
        return false;
    }
    // A floor's events can change flags whose effects live only in the running floor (a boss that an arrival
    // scene sets loose, say). The floor load event that loading runs replays those events only from the
    // state before them, so a dungeon autosave is the game as the floor's load event began.
    if (program_loop_no == LOOP_DUNGEON && !SaveSlotHasFloorEntry()) {
        return false;
    }
    const auto list = SaveSlotScan(true);
    const auto newest = MaxUniqueCounter(list);
    if (list.read_failed || newest == std::numeric_limits<u64>::max()) {
        return false;
    }
    if (program_loop_no == LOOP_DUNGEON) {
        // Only the counter belongs to the write; the save data, the towns' layouts and the header are the entry's.
        floor_entry->image.unique_counter = newest + 1;
        return SaveSlotWrite(SaveSlotAutosavePath(), *floor_entry, true) == FilesResult::kWritten;
    }
    auto document = BuildDocument(program_loop_no, newest);
    if (spawn != nullptr) {
        if (spawn->map_no != document->image.map_no) {
            return false;
        }
        document->spawn = *spawn;
        document->spawn->counter = document->image.unique_counter;
    }
    return SaveSlotWrite(SaveSlotAutosavePath(), *document, true) == FilesResult::kWritten;
}

void SaveSlotRecordFloorEntry() {
    if (GetSaveData() == nullptr) {
        floor_entry.reset();
        return;
    }
    floor_entry = BuildDocument(LOOP_DUNGEON, 0);
    // Loading resumes on the floor itself, never on the floor list.
    floor_entry->image.dng_tree_flag = 0;
}

void SaveSlotForgetFloorEntry() { floor_entry.reset(); }

bool SaveSlotHasFloorEntry() {
    const CSaveData *save = GetSaveData();
    if (!floor_entry || save == nullptr) {
        return false;
    }
    const auto floor = FloorOf(floor_entry->image.save_data);
    return floor.second >= 0 && floor == FloorOf(*save);
}

CMemoryCardManager::~CMemoryCardManager() {
    if (active_manager == this) {
        active_manager = nullptr;
    }
    descriptor.Release();
}

CMemoryCardManager *SaveSlotManager() { return active_manager; }

void SetDngTreeFlag(int flag) { dungeon_tree_flag = flag; }

int CMemoryCardManager::InitForMC() {
    active_manager = this;
    SaveSlotNew = false;
    // libmc reports the second card only once its folder exists. Creating it gives the photo album
    // and the Extras data two working slots, as with two inserted cards.
    FilesCreateDirectory(PathsSaveRoot() / "mc1");
    return sceMcInit() == sceMcIniSucceed ? 0 : 1;
}

int CMemoryCardManager::GetAllSaveFileInfo() {
    return SaveSlotRefresh(*this, true);
}

int SaveSlotRefresh(CMemoryCardManager &manager, bool include_autosave) {
    SaveSlots = SaveSlotScan(include_autosave);
    manager.InitError();
    std::memset(manager.file_info, 0, sizeof(manager.file_info));
    // A compatibility view for non-menu retail callers; save selection, title unlocks and newest-save
    // queries use the complete catalog.
    for (std::size_t i = 0; i < SaveSlots.saves.size() && i < MC_SAVE_FILE_NUM; ++i) {
        manager.file_info[i] = SaveSlots.saves[i].info;
    }
    if (SaveSlots.read_failed) {
        manager.error.code = MC_ERROR_FILE;
    }
    manager.total_transferred = 0;
    return MC_STEP_DONE;
}

u64 CMemoryCardManager::CheckMaxUniqueCounter() {
    return MaxUniqueCounter(SaveSlots);
}

int CMemoryCardManager::GetUpdateFile() {
    int                row = -1;
    unsigned long long newest = 0;
    for (std::size_t i = 0; i < SaveSlots.saves.size(); ++i) {
        const auto &slot = SaveSlots.saves[i];
        if (slot.state == SaveSlotState::Ready && slot.info.state && (row < 0 || slot.info.unique_counter > newest)) {
            row = static_cast<int>(i);
            newest = slot.info.unique_counter;
        }
    }
    return row;
}

int CMemoryCardManager::CheckDataFileNum() {
    return static_cast<int>(std::count_if(SaveSlots.saves.begin(), SaveSlots.saves.end(),
                                          [](const SaveSlot &slot) { return slot.state == SaveSlotState::Ready; }));
}

u32 CMemoryCardManager::CheckOmake(u_long *out_mask) {
    unsigned int flags = 0;
    for (const auto &slot : SaveSlots.saves) {
        if (slot.state != SaveSlotState::Ready || !slot.info.state) {
            continue;
        }
        flags |= slot.info.omake_flag;
        if (out_mask) {
            *out_mask |= slot.info.costume_bit;
        }
    }
    return flags;
}

int CMemoryCardManager::CheckDebugCode() {
    int code = 0;
    for (const auto &slot : SaveSlots.saves) {
        if (slot.state == SaveSlotState::Ready && slot.info.state && slot.info.debug_code > 0) {
            code = slot.info.debug_code;
        }
    }
    return code;
}

int CMemoryCardManager::SaveToMc(int row) {
    InitError();
    total_transferred = transferred = 0;
    if (!save_buffer || SaveSlots.read_failed || row < 0 ||
        (!SaveSlotNew && std::cmp_greater_equal(row, SaveSlots.saves.size()))) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    if ((!SaveSlotNew && SaveSlots.saves[row].autosave) ||
        FilesCreateDirectory(SaveSlotsRoot()) == FilesResult::kFailed) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }

    // A confirmed overwrite stays valid even when an unrelated legacy-card root is unreadable.
    const auto newest = std::max(CheckMaxUniqueCounter(), NewestCounter());
    if (newest == std::numeric_limits<u64>::max()) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    const auto document = BuildDocument(NowProgramLoopNo, newest);
    std::memcpy(static_cast<void *>(save_buffer), &document->image, sizeof(*save_buffer));

    std::filesystem::path path;
    FilesResult           result = FilesResult::kFailed;
    if (SaveSlotNew) {
        // Rescan and write without replacing, so a competing process cannot turn New Save into an
        // unconfirmed overwrite.
        for (int attempt = 0; attempt < 100; ++attempt) {
            auto current = SaveSlotScan();
            if (current.read_failed) {
                break;
            }
            int number = SaveSlotFirstFree(current);
            if (number < 0) {
                break;
            }
            path = SaveSlotPath(number);
            result = SaveSlotWrite(path, *document, false);
            if (result != FilesResult::kExists) {
                break;
            }
        }
    } else {
        const auto &slot = SaveSlots.saves[row];
        path = SaveSlotPath(slot.number, slot.second_card);
        // A legacy row can still be replaced, but the original image is never modified.
        result = SaveSlotWrite(slot, *document);
    }
    SaveSlotNew = false;
    if (result != FilesResult::kWritten) {
        error.code = MC_ERROR_FILE;
        return MC_STEP_DONE;
    }
    SaveSlotRefresh(*this, false);
    // A refresh error describes the listing, not the write that succeeded.
    InitError();
    for (std::size_t i = 0; i < SaveSlots.saves.size(); ++i) {
        if (SaveSlots.saves[i].path == path) {
            file_no = static_cast<int>(i);
        }
    }
    total_transferred = transferred = sizeof(*save_buffer);
    return MC_STEP_DONE;
}

int CMemoryCardManager::LoadFromMc(int row) {
    InitError();
    total_transferred = transferred = 0;
    SaveSlotSetPendingSpawn(std::nullopt);
    auto document = std::make_unique<SaveDocument>();
    if (row < 0 || std::cmp_greater_equal(row, SaveSlots.saves.size()) ||
        SaveSlotRead(SaveSlots.saves[row].path, *document) != SaveSlotState::Ready) {
        error.code = MC_ERROR_LOAD;
        return MC_STEP_DONE;
    }
    // SaveSlotRead has validated and converted the save; the retail photo address rebinding runs when its menu opens.
    const auto &image = document->image;
    auto       *save = GetSaveData();
    std::memcpy(static_cast<void *>(save), &image.save_data, sizeof(*save));
    for (std::size_t i = 0; i < document->towns.size(); ++i) {
        PortTownLayout(save->edit_data[i]) = std::move(document->towns[i]);
    }
    load_program_loop_no = image.program_loop_no;
    load_map_no = image.map_no;
    load_dungeon_no = image.dungeon_no;
    load_floor_id = image.floor_id;
    load_dng_tree_flag = image.dng_tree_flag;
    if (SaveSlots.saves[row].autosave && image.program_loop_no == LOOP_EDIT && document->spawn &&
        document->spawn->map_no == image.map_no) {
        SaveSlotSetPendingSpawn(document->spawn);
    }
    if (save->tour.base_day <= 0 && save->GetBitFlag(SAVE_FLAG_FISHING_CONTEST_UNLOCKED)) {
        save->tour.base_day = 7;
    }
    PlayTimeReset();
    total_transferred = transferred = sizeof(image);
    return MC_STEP_DONE;
}
