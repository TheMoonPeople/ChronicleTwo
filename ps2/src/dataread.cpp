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

extern char at_183[];
extern char at_190[];
extern char at_369__2[];
extern char at_370[];
extern char at_438[];
extern char at_439[];
extern char at_440[];
extern char at_441[];
extern char at_530[];
extern char at_531[];
extern char at_532[];
extern char at_533[];
extern char at_534[];
extern char at_564[];
extern char at_571[];
extern char at_659[];
extern char at_660[];
extern char at_713[];
extern char at_714[];

extern "C" void Exit__2(int);
union dataread_path {
    u_long128 quadwords[16];
    char text[256];
};
struct dataread_prefix {
    u_long128 quadword[1];
};
union dataread_prefix_text {
    dataread_prefix init;
    char text[16];
};
extern dataread_path at_259;
extern dataread_path at_845;
extern dataread_path at_583;
extern dataread_prefix at_554;

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
static int NowCacheAddress;
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
    strcpy(TopDir, at_183);
    strcpy(CurrentDir__2, at_183);
    return 1;
}

int ChangeDefaultFile() {
    if (DefaultFileDev != FILE_DEV_HDD) {
        return 0;
    }

    UmountHDDFileSystem();
    DefaultFileDev = FILE_DEV_CDROM;
    strcpy(TopDir, at_190);
    strcpy(CurrentDir__2, at_190);
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
    for (int i = 0; i < 32; i++) {
        bg_read_info[i].busy = 0;
    }
    start_vsync = 0;
    old_vsync = -1;
}

int LoadFileBG(char *name, u_long128 *buffer, int *out_size) {
    dataread_path fullPath;
    char rest[256];
    int loadedSize;
    int device;
    int i;
    BG_READ_INFO *info;
    int *words;
    DATA_HEADER *file;
    if (out_size != 0) {
        *(int *)out_size = 0;
    }
    if (name == NULL) {
        return 0;
    }
    if (*(s8 *)name == 0) {
        return 0;
    }
    fullPath = at_259;
    strcpy(fullPath.text, CurrentDir__2);
    strcat(fullPath.text, name);
    device = GetDevType(name, rest);
    if (device == -1) {
        device = DefaultFileDev;
    }
    i = 0;
    info = bg_read_info;
search:
    if (info->busy != 0) {
        i++;
        info++;
        if (i < 32) {
            goto search;
        }
    }
    if (i == 32) {
        return 0;
    }
    words = (int *)info;
    if (device == 1) {
        file = SearchFile(fullPath.text);
        if (file == NULL) {
            return 0;
        }
        strcpy(info->name, fullPath.text);
        info->busy = 1;
        info->dev = 1;
        info->issued = 0;
        info->done = 0;
        words[0x44] = (int)buffer;
        words[0x45] = file->size;
        if (out_size != 0) {
            *(int *)out_size = file->size;
        }
        info->fd = file->sector + data_sector;
        words[0x47] = size_to_sector(file->size);
        return 1;
    }
    strcpy(info->name, fullPath.text);
    info->busy = 1;
    info->dev = device;
    info->issued = 0;
    info->done = 0;
    words[0x44] = (int)buffer;
    if (SearchFileCache(name, &loadedSize) != 0) {
        info->fd = LoadFile2(name, buffer, &loadedSize, 0);
        words[0x45] = loadedSize;
        if (info->fd == 0) {
            info->busy = 0;
            return 0;
        }
        info->issued = 1;
        info->done = 1;
        if (out_size != 0) {
            *(int *)out_size = loadedSize;
        }
        return 1;
    }
    if (device == 2) {
        info->fd = LoadFile2(name, buffer, &loadedSize, 0);
        words[0x45] = loadedSize;
        info->busy = 1;
        info->issued = 1;
        info->done = 1;
        if (out_size != 0) {
            *(int *)out_size = loadedSize;
        }
        return 1;
    }
    info->fd = LoadFile2(name, buffer, &loadedSize, 2);
    words[0x45] = loadedSize;
    if (info->fd < 0) {
        info->busy = 0;
        info->issued = 0;
        info->done = 0;
        return 0;
    }
    info->issued = 0;
    info->done = 0;
    if (out_size != 0) {
        *(int *)out_size = loadedSize;
    }
    return 1;
}

BG_READ_INFO *GetReadBGFile(char *name) {
    int i;
    BG_READ_INFO *info = bg_read_info;
    for (i = 0; i < 32; i++, info++) {
        if (info->busy != 0 && strcasecmp(name, info->name) == 0) {
            return info;
        }
    }
    return NULL;
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
        return;
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
    ReadBG();
    int i = 0;
    BG_READ_INFO *info = bg_read_info;
    do {
        if (info->busy != 0 && (info->issued == 0 || info->done == 0)) {
            break;
        }
        i++;
        info++;
    } while (i < 32);
    return (i == 32) ^ 1;
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
    int file[9];
    int fd;
    int headerSize;
    int base;
    int i;
    int offset;
    s8 *name;
    s8 c;
    packfile_buff = 0;
    do {
        if (sceCdSearchFile((sceCdlFILE *)file, at_438) == 0) {
            while (sceCdSearchFile((sceCdlFILE *)file, at_438) == 0) {
            }
        }
        sceCdSync(0);
    } while (sceCdGetError() != 0);
    data_sector = file[0];
    fd = sceOpen(at_439, 1);
    if (fd < 0) {
        printf(at_440);
        Exit__2(0);
    }
    headerSize = sceLseek(fd, 0, 2);
    sceLseek(fd, 0, 0);
    sceRead(fd, header_buff, headerSize);
    sceClose(fd);
    printf(at_441, headerSize, 0x50000);
    base = (int)header_buff;
    i = 0;
    offset = 0;
    header_num = *(u32 *)base / 12;
    while (i < header_num) {
        DATA_HEADER *entry = (DATA_HEADER *)(base + offset);
        entry->name += base;
        name = (s8 *)entry->name;
        while ((c = *name) != 0) {
            if (c == '\\') {
                *name = '/';
            }
            name++;
        }
        offset += 12;
        i++;
    }
}

/**
 * Identifies the device a path names with its prefix and copies the path
 * without the prefix; a single-letter drive is left to the default device.
 */
static int GetDevType(char *path, char *out_name) {
    char device[0x40];
    s8 *scan;
    char *out;
    if (*(s8 *)(path + 1) == ':') {
        strcpy(out_name, path);
        return -1;
    }
    scan = (s8 *)path;
    out = device;
    for (;;) {
        if (*scan == 0) {
            break;
        }
        *out++ = *scan;
        if (*scan == ':') {
            break;
        }
        scan++;
    }
    *out = 0;
    if (*scan != 0) {
        strcpy(out_name, (char *)scan + 1);
    } else {
        strcpy(out_name, path);
    }
    if (strcmp(device, at_530) == 0) {
        return 0;
    }
    if (strcmp(device, at_531) == 0) {
        return 0;
    }
    if (strcmp(device, at_532) == 0) {
        return 1;
    }
    if (strcmp(device, at_533) == 0) {
        return 2;
    }
    return strcmp(device, at_534) == 0 ? 3 : -1;
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
    char rest[256];
    dataread_prefix_text prefix;
    int device = GetDevType(path, rest);
    int hasDevice = 0;
    if (device == -1) {
        device = DefaultFileDev;
    } else {
        hasDevice = 1;
    }
    prefix.init = at_554;
    if (device == 0) {
        strcpy(prefix.text, at_530);
    }
    if (device == 3) {
        strcpy(prefix.text, at_564);
    }
    strcpy(out_path, prefix.text);
    if (hasDevice == 0) {
        strcat(out_path, CurrentDir__2);
    }
    strcat(out_path, rest);
    if (device == 3) {
        ConvStr(out_path);
    }
    return device;
}

int LoadFile(char *path, void *buffer, int *out_size) {
    if (!LoadFile2(path, buffer, out_size, LOAD_FILE_READ)) {
        printf(at_571, path);
        Exit__2(0);
    }

    return 1;
}

int LoadFile2(char *path, void *buffer, int *out_size, int mode) {
    FILE_CACHE     *cache;
    DATA_HEADER    *header;
    int             dev;
    int             size;
    int             result;
    dataread_path full_path;
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

        printf(at_659, path);
        return 1;
    }

    full_path = at_583;

    dev = GetFullPath(path, full_path.text);

    if (dev == FILE_DEV_DEFAULT) {
        dev = DefaultFileDev;
    }

    if (dev == FILE_DEV_NET) {
        printf(at_660, full_path.text);
        size = LoadFileSocket(full_path.text, (u_int *) buffer);

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
            header = SearchFile(full_path.text);

            if (!header) {
                return 0;
            }

            if (out_size) {
                *out_size = header->size;
            }

            return 1;
        }

        return CDRead(full_path.text, (u_int *) buffer, out_size);
    }

    printf(at_660, full_path.text);

    // Every failing hard-disk operation is reported to the error callback.
    if (dev == FILE_DEV_HDD) {
        result = sceGetstat(full_path.text, &stat);

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
            dev = sceOpen(full_path.text, SCE_RDONLY | SCE_NOWAIT, 0x1FF);

            if (dev < 0 && error_cb) {
                error_cb(dev);
            }

            return dev;
        }

        dev = sceOpen(full_path.text, SCE_RDONLY, 0x1FF);

        if (dev < 0) {
            if (error_cb) {
                error_cb(dev);
            }

            return 0;
        }

        size = sceLseek(dev, 0, SCE_SEEK_END);

        if (out_size) {
            *out_size = size;
        }

        if (size < 0 && error_cb) {
            error_cb(size);
        }

        if (mode != LOAD_FILE_SIZE) {
            result = sceLseek(dev, 0, SCE_SEEK_SET);

            if (result < 0 && error_cb) {
                error_cb(result);
            }

            result = sceRead(dev, buffer, size);

            if (result < 0 && error_cb) {
                error_cb(result);
            }
        }

        sceClose(dev);
        return 1;
    }

    result = sceOpen(full_path.text, SCE_RDONLY);

    if (result < 0) {
        return mode == LOAD_FILE_OPEN ? -1 : 0;
    }

    size = sceLseek(result, 0, SCE_SEEK_END);

    if (out_size) {
        *out_size = size;
    }

    if (mode != LOAD_FILE_SIZE) {
        sceLseek(result, 0, SCE_SEEK_SET);

        // The size is learnt through a blocking descriptor; the read itself is left to ReadBG.
        if (mode == LOAD_FILE_OPEN) {
            sceClose(result);
            return sceOpen(full_path.text, SCE_RDONLY | SCE_NOWAIT);
        }

        sceRead(result, buffer, size);
    }

    sceClose(result);
    return 1;
}

/**
 * Reads a file inside DATA.DAT from the disc, retrying
 * until the read succeeds; reports whether the file exists.
 */
static int CDRead(char *path, u_int *buffer, int *out_size) {
    int *entry;
    sceCdRMode mode;
    printf(at_713, path);
    entry = (int *)SearchFile(path);
    if (entry == NULL) {
        return 0;
    }
    printf(at_714, entry[0], entry[2], size_to_sector(entry[1]));
    mode.trycount = 0;
    mode.spindlctrl = 1;
    mode.datapattern = 0;
    do {
        while (sceCdRead(entry[2] + data_sector, size_to_sector(entry[1]), buffer, &mode) == 0) {
        }
        sceCdSync(0);
    } while (sceCdGetError() != 0);
    if (out_size != NULL) {
        *out_size = entry[1];
    }
    return 1;
}

/**
 * Rounds a size up to the next
 * multiple of an alignment.
 */
#pragma divbyzerocheck on
static u_int align_size(u_int size, u_int alignment) {
    u32 rest = size % alignment;
    if (rest != 0) {
        size += alignment - rest;
    }
    return size;
}

#pragma divbyzerocheck reset

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
        NowCacheAddress = (int)CacheAddress;

        if (type == FILE_CACHE_DOWN) {
            NowCacheAddress -= 64;
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
    int size;
    int aligned;
    int buffer;
    FILE_CACHE *entry;
    if (path == NULL || *(s8 *)path == 0) {
        return 0;
    }
    if (CacheAddress == 0) {
        return 0;
    }
    entry = (FILE_CACHE *)SearchFileCache(path);
    if (entry != NULL) {
        entry->ref_count += 1;
        return 1;
    }
    size = 0;
    if (LoadFile2(path, NULL, &size, 1) == 0) {
        return 0;
    }
    aligned = align_size(size, 0x800);
    buffer = NowCacheAddress;
    if (FileCacheType == 1) {
        NowCacheAddress -= aligned / 16 * 16;
        buffer = NowCacheAddress;
    }
    if (FileCacheType == 2) {
        NowCacheAddress += aligned / 16 * 16;
    }
    if (LoadFileBG(path, (u_long128 *)buffer, NULL) == 0) {
        return 0;
    }
    return EntryFileCache(path, (u_long128 *)buffer, size);
}

/**
 * Finds the file cache entry held under a path,
 * or null when the file is not cached.
 */
static FILE_CACHE *SearchFileCache(char *path) {
    int i;
    FILE_CACHE *entry;
    if (CacheAddress == 0) {
        return 0;
    }
    entry = FileCache;
    for (i = 0; i < 16; i++, entry++) {
        if (entry->address != 0 && strcasecmp((char *)entry + 0x10, path) == 0) {
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
    dataread_path fullPath = at_845;
    int fd;
    if (GetFullPath(path, fullPath.text) == 2) {
        printf(at_660, fullPath.text);
        WriteFileSocket(fullPath.text, (u32 *)buffer, size);
        return 1;
    }
    fd = sceOpen(path, 0x602);
    if (fd < 0) {
        return 0;
    }
    sceWrite(fd, buffer, size);
    sceClose(fd);
    return 1;
}

u_int *GetPackFile(u_int *pack, char *name, int *out_size) {
    s8 *base;
    u8 *entry;
    s8 *scan;
    s8 c;
    if (pack == NULL) {
        return 0;
    }
    if (name == NULL) {
        return 0;
    }
    if (*(s8 *)name == 0) {
        return 0;
    }
    base = (s8 *)name;
    scan = (s8 *)name;
    while ((c = *scan) != 0) {
        if (c == '/') {
            base = scan + 1;
        }
        scan++;
    }
    for (entry = (u8 *)pack; *(s8 *)entry != 0; entry += *(int *)(entry + 0x48)) {
        if (strcasecmp((char *)entry, (char *)base) == 0) {
            int data = (int)(entry + *(int *)(entry + 0x40));
            if (out_size != NULL) {
                *out_size = *(int *)(entry + 0x44);
            }
            return (u_int *)data;
        }
    }
    return 0;
}

u_int *GetPackFile(u_int *pack, int index, char **out_name, int *out_size) {
    int i;
    u8 *entry = (u8 *)pack;
    if (entry == NULL) {
        return 0;
    }
    i = 0;
    for (; *(s8 *)entry != 0; i++, entry += *(int *)(entry + 0x48)) {
        if (index == i) {
            int data = (int)(entry + *(int *)(entry + 0x40));
            if (out_size != NULL) {
                *out_size = *(int *)(entry + 0x44);
            }
            *out_name = (char *)entry;
            return (u_int *)data;
        }
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
    int size;
    char *name;
    int index;


    index = 0;
loop:
    if (GetPackFile(pack, index, &name, &size) != 0) {
        index += 1;
        goto loop;
    }
    return index;
}

void DivPathName(char *path, char *out_dir, char *out_name) {
    int last = strlen(path) - 1;
    s8 *out = (s8 *)out_dir;
    s8 *in;
    int i;
    if (last >= 0) {
        do {
            if (((s8 *)path)[last] == '/') {
                break;
            }
            last--;
        } while (last >= 0);
    }
    if (last == 0) {
        *out = 0;
        strcpy(out_name, path);
        return;
    }
    in = (s8 *)path;
    for (i = 0; i <= last; i++) {
        *out++ = *in++;
    }
    *out = 0;
    strcpy(out_name, path + (last + 1));
}

void DivPathNameExt(char *path, char *out_dir, char *out_name, char *out_ext) {
    DivPathName(path, out_dir, out_name);
    s8 c;
    s8 *cursor = (s8 *)out_name;
    while ((c = *cursor) != 0) {
        if (c == '.') {
            *cursor = 0;
            cursor++;
            break;
        }
        cursor++;
    }
    strcpy(out_ext, (char *)cursor);
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
