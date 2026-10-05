#include "common.h"
#include "dataread.hpp"
#include "filesocket.hpp"
#include "hddinstall.hpp"
#include "mglib.hpp"
#include <eekernel.h>
#include <libcdvd.h>
#include <sifdev.h>
#include <cstdio>
#include <cstring>

// Initialised data (.data)
static char TopDir[256] = "";
static char CurrentDir__2[256] = "";
// Small initialised data (.sdata)
static int  DefaultFileDev = FILE_DEV_CDROM;

// Small uninitialised data (.sbss)
static int header_num;
static int data_sector;
static int (*error_cb)(int);
static int old_vsync;
static int start_vsync;

// Uninitialised data (.bss)
u_char header_buff[0x50000];
static BG_READ_INFO bg_read_info[32];
static FILE_CACHE   FileCache[16];

static u_int     *packfile_buff;
static u_long128 *CacheAddress;
static u_long128 *NowCacheAddress;
static int        FileCacheType;

static DATA_HEADER *SearchFile(char *name);
static int          GetDevType(char *path, char *out_name);
static void         ConvStr(char *text);
static int          GetFullPath(char *path, char *out_path);
static int          CDRead(char *path, u_int *buffer, int *out_size);
static u_int        align_size(u_int size, u_int alignment);
static FILE_CACHE  *GetNewFileCache();
static int          EntryFileCache(char *path, u_long128 *address, int size);
static FILE_CACHE  *SearchFileCache(char *path);

// Code (.text)
int size_to_sector(int size) {
    int sectors;

    sectors = size / 2048;

    if (size % 2048) {
        sectors++;
    }

    return sectors;
}

int GetMainFileDev() {
    return DefaultFileDev;
}

int ChangeHddFile() {
    int result;

    if (DefaultFileDev == FILE_DEV_HDD) {
        return 0;
    }

    result = MountHDDFileSystem();

    if (result <= 0) {
        return result;
    }

    DefaultFileDev = FILE_DEV_HDD;
    strcpy(TopDir, "/");
    strcpy(CurrentDir__2, "/");
    return 1;
}

int ChangeDefaultFile() {
    if (DefaultFileDev != FILE_DEV_HDD) {
        return 0;
    }

    UmountHDDFileSystem();
    DefaultFileDev = FILE_DEV_CDROM;
    strcpy(TopDir, "");
    strcpy(CurrentDir__2, "");
    return 1;
}

void SetIoErrCallBack(int (*callback)(int)) {
    error_cb = callback;
}

void SetCurrentDir(char *dir) {
    if (dir) {
        if (*dir == '/') {
            dir++;
        }

        strcpy(CurrentDir__2, dir);
        return;
    }

    strcpy(CurrentDir__2, TopDir);
}

void GetCurrentDir(char *out_dir) {
    strcpy(out_dir, CurrentDir__2);
}

void ChangeDir(char *dir) {
    strcpy(CurrentDir__2, TopDir);

    if (dir) {
        if (*dir == '/') {
            dir++;
        }

        strcat(CurrentDir__2, dir);
    }
}

/**
 * Finds a file's record in the DATA.DAT index
 * by name, or null when it is not there.
 */
static DATA_HEADER *SearchFile(char *name) {
    DATA_HEADER *header;
    int          i;

    header = (DATA_HEADER *) header_buff;

    for (i = 0; i < header_num; i++, header++) {
        if (strcasecmp(header->name, name) == 0) {
            return header;
        }
    }

    return 0;
}

void InitReadBG() {
    int i;

    for (i = 0; i < 32; i++) {
        bg_read_info[i].busy = false;
    }

    start_vsync = 0;
    old_vsync = -1;
}

int LoadFileBG(char *name, u_long128 *buffer, int *out_size) {
    BG_READ_INFO *info;
    DATA_HEADER  *header;
    int           dev;
    int           i;
    int           size;
    char          file_name[256];

    if (out_size) {
        *out_size = 0;
    }

    if (!name) {
        return 0;
    }

    if (*name == 0) {
        return 0;
    }

    char path[256] = "";

    strcpy(path, CurrentDir__2);
    strcat(path, name);
    dev = GetDevType(name, file_name);

    if (dev == FILE_DEV_DEFAULT) {
        dev = DefaultFileDev;
    }

    info = bg_read_info;

    for (i = 0; i < 32; i++, info++) {
        if (!info->busy) {
            break;
        }
    }

    if (i == 32) {
        return 0;
    }

    if (dev == FILE_DEV_CDROM) {
        header = SearchFile(path);

        if (!header) {
            return 0;
        }

        strcpy(info->name, path);
        info->busy = true;
        info->dev = FILE_DEV_CDROM;
        info->issued = 0;
        info->done = 0;
        info->buffer = buffer;
        info->size = header->size;

        if (out_size) {
            *out_size = header->size;
        }

        info->sector = header->sector + data_sector;
        info->sectors = size_to_sector(header->size);
        return 1;
    }

    strcpy(info->name, path);
    info->busy = true;
    info->dev = dev;
    info->issued = 0;
    info->done = 0;
    info->buffer = buffer;

    // A cached file is copied at once, so its read is queued as already finished.
    if (SearchFileCache(name, &size)) {
        info->fd = LoadFile2(name, buffer, &size, LOAD_FILE_READ);
        info->size = size;

        if (!info->fd) {
            info->busy = false;
            return 0;
        }

        info->issued = 1;
        info->done = 1;

        if (out_size) {
            *out_size = size;
        }

        return 1;
    }

    // The network socket has no asynchronous read, so the file is read at once.
    if (dev == FILE_DEV_NET) {
        info->fd = LoadFile2(name, buffer, &size, LOAD_FILE_READ);
        info->size = size;
        info->busy = true;
        info->issued = 1;
        info->done = 1;

        if (out_size) {
            *out_size = size;
        }

        return 1;
    }

    info->fd = LoadFile2(name, buffer, &size, LOAD_FILE_OPEN);
    info->size = size;

    if (info->fd < 0) {
        info->busy = false;
        info->issued = 0;
        info->done = 0;
        return 0;
    }

    info->issued = 0;
    info->done = 0;

    if (out_size) {
        *out_size = size;
    }

    return 1;
}

BG_READ_INFO *GetReadBGFile(char *name) {
    BG_READ_INFO *info;
    int           i;

    info = bg_read_info;

    for (i = 0; i < 32; i++, info++) {
        if (info->busy && strcasecmp(name, info->name) == 0) {
            return info;
        }
    }

    return 0;
}

BG_READ_INFO *GetReadBGFile(int index) {
    if (index < 0 || index >= 32) {
        return 0;
    }

    return bg_read_info[index].busy ? &bg_read_info[index] : 0;
}

void StartReadBG() {
    InitReadBG();
}

void ReadBG() {
    BG_READ_INFO *info;
    sceCdRMode    mode;
    int           vsync;
    int           i;
    int           status;

    vsync = mgGetVSyncCount();

    if (old_vsync == vsync) {
        return;
    }

    old_vsync = vsync;
    start_vsync++;
    mode.trycount = 0;
    mode.spindlctrl = 1;
    mode.datapattern = 0;
    info = bg_read_info;

    for (i = 0; i < 32; i++, info++) {
        if (info->busy) {
            if (info->issued != 0 && info->done == 0) {
                break;
            }

            if (info->issued == 0 && info->done == 0) {
                break;
            }
        }
    }

    if (i == 32) {
        return;
    }

    if (info->issued == 0) {
        start_vsync = 0;

        if (info->dev == FILE_DEV_CDROM) {
            info->issued = sceCdRead(info->sector, info->sectors, info->buffer, &mode);
        } else {
            info->issued = 1;
            sceRead(info->fd, info->buffer, info->size);
        }
    } else if (info->issued != 0) {
        if (info->dev == FILE_DEV_CDROM) {
            if (sceCdSync(1)) {
                return;
            }

            if (sceCdGetError()) {
                printf("error at %s\n", info->name);
                info->issued = 0;
                return;
            }

            printf("LoadBG %s\n", info->name);
            info->done = 1;
        } else {
            sceIoctl(info->fd, SCE_FS_EXECUTING, &status);

            if (status == 0) {
                sceClose(info->fd);
                info->done = 1;
            }
        }
    }
}

int ReadBGSync() {
    BG_READ_INFO *info;
    int           i;

    ReadBG();
    info = bg_read_info;

    for (i = 0; i < 32; i++, info++) {
        if (info->busy) {
            if (info->issued == 0) {
                break;
            }

            if (info->done == 0) {
                break;
            }
        }
    }

    return i != 32;
}

void BreakReadBG() {
    BG_READ_INFO *info;
    int           i;

    if (!ReadBGSync()) {
        return;
    }

    sceCdBreak();
    info = bg_read_info;

    for (i = 0; i < 32; i++, info++) {
        if (info->busy && info->dev != FILE_DEV_CDROM) {
            sceClose(info->fd);
            info->done = 1;
        }
    }

    InitReadBG();
}

void InitCDFile() {
    sceCdlFILE   file;
    int          fd;
    int          size;
    DATA_HEADER *records;
    int          i;

    packfile_buff = 0;

    while (1) {
        if (sceCdSearchFile(&file, "\\DATA.DAT;1")) {
            sceCdSync(0);

            if (sceCdGetError() == 0) {
                break;
            }
        }
    }

    data_sector = file.lsn;
    fd = sceOpen("cdrom0:\\DATA.HD4;1", SCE_RDONLY);

    if (fd < 0) {
        printf("File open error \"\"\n \n \n");
        Exit(0);
    }

    size = sceLseek(fd, 0, SCE_SEEK_END);
    sceLseek(fd, 0, SCE_SEEK_SET);
    sceRead(fd, header_buff, size);
    sceClose(fd);
    printf("head size = %d/%d\n", size, sizeof(header_buff));
    records = (DATA_HEADER *) header_buff;
    // The names follow the last record, so the first name's offset counts the records.
    header_num = records->name_offset / (int) sizeof(DATA_HEADER);

    for (i = 0; i < header_num; i++) {
        char *cursor;
        char  ch;

        records[i].name = (char *) &header_buff[records[i].name_offset];

        for (cursor = records[i].name; (ch = *cursor) != 0; cursor++) {
            if (ch == '\\') {
                *cursor = '/';
            }
        }
    }
}

/**
 * Identifies the device a path names with its prefix and copies the path
 * without the prefix; a single-letter drive is left to the default device.
 */
static int GetDevType(char *path, char *out_name) {
    char *cursor;
    char *device_end;
    char  device[64];

    if (path[1] == ':') {
        strcpy(out_name, path);
        return FILE_DEV_DEFAULT;
    }

    cursor = path;
    device_end = device;

    while (*cursor != 0) {
        *device_end = *cursor;
        device_end++;

        if (*cursor == ':') {
            break;
        }

        cursor++;
    }

    *device_end = 0;

    if (*cursor != 0) {
        strcpy(out_name, cursor + 1);
    } else {
        strcpy(out_name, path);
    }

    if (strcmp(device, "host:") == 0) {
        return FILE_DEV_HOST;
    }

    if (strcmp(device, "host0:") == 0) {
        return FILE_DEV_HOST;
    }

    if (strcmp(device, "cdrom:") == 0) {
        return FILE_DEV_CDROM;
    }

    if (strcmp(device, "net:") == 0) {
        return FILE_DEV_NET;
    }

    if (strcmp(device, "psf0:") == 0) {
        return FILE_DEV_HDD;
    }

    return FILE_DEV_DEFAULT;
}

/**
 * Converts the upper-case letters of a string
 * to lower case in place.
 */
static void ConvStr(char *text) {
    char ch;

    while ((ch = *text) != 0) {
        if (ch >= 'A' && ch <= 'Z') {
            *text += 'a' - 'A';
        }

        text++;
    }
}

/**
 * Builds the path a file is opened by on its device, with the device's
 * prefix and the current directory; returns the device.
 */
static int GetFullPath(char *path, char *out_path) {
    int  dev;
    int  has_device;
    char name[256];

    dev = GetDevType(path, name);
    has_device = false;

    if (dev == FILE_DEV_DEFAULT) {
        dev = DefaultFileDev;
    } else {
        has_device = true;
    }

    char prefix[16] = "";

    if (dev == FILE_DEV_HOST) {
        strcpy(prefix, "host:");
    }

    if (dev == FILE_DEV_HDD) {
        strcpy(prefix, "pfs0:");
    }

    strcpy(out_path, prefix);

    if (!has_device) {
        strcat(out_path, CurrentDir__2);
    }

    strcat(out_path, name);

    if (dev == FILE_DEV_HDD) {
        ConvStr(out_path);
    }

    return dev;
}

int LoadFile(char *path, void *buffer, int *out_size) {
    if (!LoadFile2(path, buffer, out_size, LOAD_FILE_READ)) {
        printf("File open error \"%s\"\n \n \n", path);
        Exit(0);
    }

    return 1;
}

int LoadFile2(char *path, void *buffer, int *out_size, int mode) {
    FILE_CACHE     *cache;
    DATA_HEADER    *header;
    int             dev;
    int             size;
    int             result;
    int             fd;
    struct sce_stat stat;

    if (out_size) {
        *out_size = 0;
    }

    cache = SearchFileCache(path);

    if (cache) {
        if (mode == LOAD_FILE_READ) {
            memcpy(buffer, cache->address, cache->size);
            cache->ref_count--;
        }

        if (out_size) {
            *out_size = cache->size;
        }

        printf("file cache %s\n", path);
        return 1;
    }

    char full_path[256] = "";

    dev = GetFullPath(path, full_path);

    if (dev == FILE_DEV_DEFAULT) {
        dev = DefaultFileDev;
    }

    if (dev == FILE_DEV_NET) {
        printf("load %s\n", full_path);
        size = LoadFileSocket(full_path, (u_int *) buffer);

        if (out_size) {
            *out_size = size;
        }

        if (!size) {
            return 0;
        }

        return 1;
    }

    if (dev == FILE_DEV_CDROM) {
        if (mode == LOAD_FILE_SIZE) {
            header = SearchFile(full_path);

            if (!header) {
                return 0;
            }

            if (out_size) {
                *out_size = header->size;
            }

            return 1;
        }

        return CDRead(full_path, (u_int *) buffer, out_size);
    }

    printf("load %s\n", full_path);

    // Every failing hard-disk operation is reported to the error callback.
    if (dev == FILE_DEV_HDD) {
        result = sceGetstat(full_path, &stat);

        if (result < 0 && error_cb) {
            error_cb(result);
        }

        if (out_size && result >= 0) {
            *out_size = stat.st_size;
        }

        if (mode == LOAD_FILE_SIZE) {
            return result >= 0;
        }

        if (mode == LOAD_FILE_OPEN) {
            fd = sceOpen(full_path, SCE_RDONLY | SCE_NOWAIT);

            if (fd < 0 && error_cb) {
                error_cb(fd);
            }

            return fd;
        }

        fd = sceOpen(full_path, SCE_RDONLY);

        if (fd < 0) {
            if (error_cb) {
                error_cb(fd);
            }

            return 0;
        }

        size = sceLseek(fd, 0, SCE_SEEK_END);

        if (out_size) {
            *out_size = size;
        }

        if (size < 0 && error_cb) {
            error_cb(size);
        }

        if (mode != LOAD_FILE_SIZE) {
            result = sceLseek(fd, 0, SCE_SEEK_SET);

            if (result < 0 && error_cb) {
                error_cb(result);
            }

            result = sceRead(fd, buffer, size);

            if (result < 0 && error_cb) {
                error_cb(result);
            }
        }

        sceClose(fd);
        return 1;
    }

    fd = sceOpen(full_path, SCE_RDONLY);

    if (fd < 0) {
        return mode == LOAD_FILE_OPEN ? -1 : 0;
    }

    size = sceLseek(fd, 0, SCE_SEEK_END);

    if (out_size) {
        *out_size = size;
    }

    if (mode != LOAD_FILE_SIZE) {
        sceLseek(fd, 0, SCE_SEEK_SET);

        // The size is learnt through a blocking descriptor; the read itself is left to ReadBG.
        if (mode == LOAD_FILE_OPEN) {
            sceClose(fd);
            return sceOpen(full_path, SCE_RDONLY | SCE_NOWAIT);
        }

        sceRead(fd, buffer, size);
    }

    sceClose(fd);
    return 1;
}

/**
 * Reads a file inside DATA.DAT from the disc, retrying
 * until the read succeeds; reports whether the file exists.
 */
static int CDRead(char *path, u_int *buffer, int *out_size) {
    DATA_HEADER *header;
    sceCdRMode   mode;

    printf("Load %s\n", path);
    header = SearchFile(path);

    if (!header) {
        return 0;
    }

    printf("%s %d %d\n", header->name, header->sector, size_to_sector(header->size));
    mode.trycount = 0;
    mode.spindlctrl = 1;
    mode.datapattern = 0;

    while (1) {
        if (sceCdRead(header->sector + data_sector, size_to_sector(header->size), buffer, &mode)) {
            sceCdSync(0);

            if (sceCdGetError() == 0) {
                break;
            }
        }
    }

    if (out_size) {
        *out_size = header->size;
    }

    return 1;
}

/**
 * Rounds a size up to the next
 * multiple of an alignment.
 */
static u_int align_size(u_int size, u_int alignment) {
    if (size % alignment) {
        size += alignment - size % alignment;
    }

    return size;
}

/**
 * Gives a free file cache entry,
 * or null when every entry is in use.
 */
static FILE_CACHE *GetNewFileCache() {
    int i;

    for (i = 0; i < 16; i++) {
        if (!FileCache[i].address) {
            return &FileCache[i];
        }
    }

    return 0;
}

void InitFileCache(u_long128 *address, int type) {
    int i;

    CacheAddress = 0;

    for (i = 0; i < 16; i++) {
        FileCache[i].address = 0;
    }

    if (type == FILE_CACHE_DOWN || type == FILE_CACHE_UP) {
        CacheAddress = (u_long128 *) align_size((u_int) address, 64);
        NowCacheAddress = CacheAddress;

        if (type == FILE_CACHE_DOWN) {
            NowCacheAddress -= 64 / sizeof(u_long128);
        }

        FileCacheType = type;
    }
}

void DeleteFileCache() {
    InitFileCache(0, FILE_CACHE_NONE);
}

/**
 * Records a file as held in the file cache at an address,
 * with one pending use; reports whether an entry was free.
 */
static int EntryFileCache(char *path, u_long128 *address, int size) {
    FILE_CACHE *entry;

    entry = GetNewFileCache();

    if (!entry) {
        return 0;
    }

    entry->address = address;
    entry->size = size;
    entry->ref_count = 1;
    strcpy(entry->name, path);
    return 1;
}

int LoadFileCacheBG(char *path) {
    FILE_CACHE *entry;
    int         size;
    int         aligned_size;

    if (!path || *path == 0) {
        return 0;
    }

    if (!CacheAddress) {
        return 0;
    }

    entry = SearchFileCache(path);

    if (entry) {
        entry->ref_count++;
        return 1;
    }

    size = 0;

    if (!LoadFile2(path, 0, &size, LOAD_FILE_SIZE)) {
        return 0;
    }

    aligned_size = align_size(size, 2048);

    if (FileCacheType == FILE_CACHE_DOWN) {
        NowCacheAddress -= aligned_size / 16;
    }

    if (FileCacheType == FILE_CACHE_UP) {
        NowCacheAddress += aligned_size / 16;
    }

    if (!LoadFileBG(path, NowCacheAddress, 0)) {
        return 0;
    }

    return EntryFileCache(path, NowCacheAddress, size);
}

/**
 * Finds the file cache entry held under a path,
 * or null when the file is not cached.
 */
static FILE_CACHE *SearchFileCache(char *path) {
    FILE_CACHE *entry;
    int         i;

    if (!CacheAddress) {
        return 0;
    }

    entry = FileCache;

    for (i = 0; i < 16; i++, entry++) {
        if (entry->address && strcasecmp(entry->name, path) == 0) {
            return entry;
        }
    }

    return 0;
}

u_long128 *SearchFileCache(char *path, int *out_size) {
    FILE_CACHE *entry;

    if (out_size) {
        *out_size = 0;
    }

    entry = SearchFileCache(path);

    if (!entry) {
        return 0;
    }

    if (out_size) {
        *out_size = entry->size;
    }

    return entry->address;
}

int WriteFile(char *path, void *buffer, int size) {
    int fd;

    char full_path[256] = "";

    if (GetFullPath(path, full_path) == FILE_DEV_NET) {
        printf("load %s\n", full_path);
        WriteFileSocket(full_path, (u_int *) buffer, size);
        return 1;
    }

    fd = sceOpen(path, SCE_WRONLY | SCE_CREAT | SCE_TRUNC);

    if (fd < 0) {
        return 0;
    }

    sceWrite(fd, buffer, size);
    sceClose(fd);
    return 1;
}

u_int *GetPackFile(u_int *pack, char *name, int *out_size) {
    char       *base_name;
    PACK_ENTRY *entry;
    u_int      *data;
    char        ch;

    if (!pack) {
        return 0;
    }

    if (!name) {
        return 0;
    }

    base_name = name;

    if (*name == 0) {
        return 0;
    }

    while ((ch = *name) != 0) {
        if (ch == '/') {
            base_name = name + 1;
        }

        name++;
    }

    entry = (PACK_ENTRY *) pack;

    while (entry->name[0]) {
        if (strcasecmp(entry->name, base_name) == 0) {
            data = (u_int *) ((char *) entry + entry->offset);

            if (out_size) {
                *out_size = entry->size;
            }

            return data;
        }

        entry = (PACK_ENTRY *) ((char *) entry + entry->next);
    }

    return 0;
}

u_int *GetPackFile(u_int *pack, int index, char **out_name, int *out_size) {
    PACK_ENTRY *entry;
    int         i;

    entry = (PACK_ENTRY *) pack;
    i = 0;

    if (!entry) {
        return 0;
    }

    while (entry->name[0]) {
        if (index == i) {
            if (out_size) {
                *out_size = entry->size;
            }

            *out_name = entry->name;
            return (u_int *) ((char *) entry + entry->offset);
        }

        i++;
        entry = (PACK_ENTRY *) ((char *) entry + entry->next);
    }

    return 0;
}

int GetPackFileExt(u_int *pack, char *extension, u_int **files, int max_files, int *sizes, char **names) {
    int    found_count;
    int    i;
    u_int *data;
    char  *ext_start;
    char   ch;
    int    size;
    char  *name;

    found_count = 0;
    i = 0;

    for (;;) {
        data = GetPackFile(pack, i, &name, &size);

        if (!data) {
            break;
        }

        ext_start = name;

        while ((ch = *ext_start) != 0) {
            if (ch == '.') {
                ext_start++;
                break;
            }

            ext_start++;
        }

        if (strcasecmp(extension, ext_start) == 0) {
            files[found_count] = data;

            if (names) {
                names[found_count] = name;
            }

            if (sizes) {
                sizes[found_count] = size;
            }

            found_count++;

            if (found_count >= max_files) {
                break;
            }
        }

        i++;
    }

    return found_count;
}

int GetPackFileNum(u_int *pack) {
    int   count;
    char *name;
    int   size;

    count = 0;

    while (GetPackFile(pack, count, &name, &size)) {
        count++;
    }

    return count;
}

void DivPathName(char *path, char *out_dir, char *out_name) {
    int slash;
    int i;

    for (slash = strlen(path) - 1; slash >= 0; slash--) {
        if (path[slash] == '/') {
            break;
        }
    }

    if (slash == 0) {
        *out_dir = 0;
        strcpy(out_name, path);
        return;
    }

    for (i = 0; i <= slash; i++) {
        out_dir[i] = path[i];
    }

    out_dir[i] = 0;
    strcpy(out_name, &path[slash + 1]);
}

void DivPathNameExt(char *path, char *out_dir, char *out_name, char *out_ext) {
    char *ext;

    ext = out_name;
    DivPathName(path, out_dir, out_name);

    while (*ext != 0) {
        if (*ext == '.') {
            *ext = 0;
            ext++;
            break;
        }

        ext++;
    }

    strcpy(out_ext, ext);
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_183__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_190__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_369__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_370__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_438__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_439__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_440__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_441__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_530__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_531__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_532__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_533__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_534__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_564__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_571__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_659__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_660__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_713__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dataread", at_714__DATA);

INCLUDE_BSS(at_259, 0x100);
INCLUDE_BSS(at_554, 0x10);
INCLUDE_BSS(at_583, 0x100);
INCLUDE_BSS(at_845, 0x130);
