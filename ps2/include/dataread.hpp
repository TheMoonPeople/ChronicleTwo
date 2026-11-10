#pragma once

#include "common.h"

/**
 * @file
 * Declares the calls that read files off the disc, the host, the network or the hard disk,
 * the background read queue, the file cache, and the calls that reach into a pack file once
 * it has been read.
 */

/**
 *
 * Identifies the device a file path names with its prefix, which decides
 * how the file is opened and read.
 *
 */
enum FILE_DEV {
    FILE_DEV_DEFAULT = -1, /**< No prefix; the current default device applies. */
    FILE_DEV_HOST = 0,     /**< "host:" or "host0:", the development host. */
    FILE_DEV_CDROM = 1,    /**< "cdrom:", a file inside DATA.DAT on the disc. */
    FILE_DEV_NET = 2,      /**< "net:", a file sent over the network socket. */
    FILE_DEV_HDD = 3,      /**< "psf0:" in a path; the installed copy on the hard disk at "pfs0:". */
};

/**
 *
 * Selects what LoadFile2 does with the file it finds: read it whole,
 * only report its size, or leave it open for a background read.
 *
 */
enum LOAD_FILE_MODE {
    LOAD_FILE_READ = 0, /**< Read the whole file into the buffer. */
    LOAD_FILE_SIZE = 1, /**< Only report whether the file exists and its size. */
    LOAD_FILE_OPEN = 2, /**< Open the file and return its descriptor without reading. */
};

/**
 *
 * Selects the direction the file cache hands out memory in from the
 * address it was given, or that the cache is disabled.
 *
 */
enum FILE_CACHE_TYPE {
    FILE_CACHE_NONE = 0, /**< The cache is disabled. */
    FILE_CACHE_DOWN = 1, /**< Files are placed downward from the given address. */
    FILE_CACHE_UP = 2,   /**< Files are placed upward from the given address. */
};

/**
 *
 * Sizes of the background read queue, the file cache and a disc sector.
 *
 */
enum DATAREAD_SIZE {
    BG_READ_MAX = 32,            /**< Files that the background read queue holds. */
    FILE_CACHE_MAX = 16,         /**< Files that the file cache holds. */
    DATAREAD_SECTOR_SIZE = 2048, /**< Bytes in one disc sector. */
};

/**
 *
 * Locates one file inside DATA.DAT, as a record of the
 * index that is read from DATA.HD4 at start-up.
 *
 */
struct DATA_HEADER {
    union {
        int   name_offset; /**< Offset of the file name from the start of the index, as stored on the disc. */
        char *name;        /**< File name, once the index has been loaded. */
    };

    int size;   /**< File size in bytes. */
    int sector; /**< Starting sector relative to DATA.DAT. */
};

STATIC_ASSERT(sizeof(DATA_HEADER) == 0xC);

/**
 *
 * Tracks one file queued for reading in the background
 * while the game keeps running.
 *
 */
struct BG_READ_INFO {
    int        busy;      /**< Whether the queue slot is allocated. */
    int        dev;       /**< Device the file is read from (FILE_DEV). */
    int        issued;    /**< Whether the read has been started. */
    int        done;      /**< Whether the read has completed. */
    char       name[256]; /**< Full path of the file, used to find it and in messages. */
    u_long128 *buffer;    /**< Destination buffer. */
    int        size;      /**< File size in bytes. */

    union {
        int sector; /**< Absolute starting sector, for a file on the disc. */
        int fd;     /**< Open file descriptor, for a file on any other device. */
    };

    int sectors; /**< Number of sectors to read, for a file on the disc. */
};

STATIC_ASSERT(sizeof(BG_READ_INFO) == 0x120);

/**
 *
 * Holds one file kept in the file cache, so a later
 * load of the same name is copied from memory.
 *
 */
struct FILE_CACHE {
    u_long128 *address;   /**< Where the file's data is cached; null for a free entry. */
    int        size;      /**< File size in bytes. */
    int        ref_count; /**< Number of pending loads that will take the file from the cache. */
    int        unk_0c;
    char       name[48]; /**< Path the file was cached under. */
};

STATIC_ASSERT(sizeof(FILE_CACHE) == 0x40);

/**
 *
 * Describes one file in a pack. A first name byte of zero ends the table,
 * and every offset counts from the start of the entry itself.
 *
 */
struct PACK_ENTRY {
    char name[64]; /**< Null-terminated file name; empty ends the table. */
    int  offset;   /**< Byte offset of the file data from this entry. */
    int  size;     /**< File size in bytes. */
    int  next;     /**< Byte offset of the next entry from this entry. */
};

STATIC_ASSERT(sizeof(PACK_ENTRY) == 0x4C);
PORT_RECORD_ASSERT(sizeof(PACK_ENTRY) == 0x4C);

/**
 *
 * Converts a byte count into the number of 2048-byte
 * disc sectors needed to hold it.
 *
 * @mangled size_to_sector__Fi
 * @address 0x148A90
 * @size 0x38
 */
int size_to_sector(int size);

/**
 *
 * Gives the device that paths without a device prefix
 * are read from.
 *
 * @mangled GetMainFileDev__Fv
 * @address 0x148AD0
 * @size 0x8
 */
int GetMainFileDev();

/**
 *
 * Mounts the hard-disk installation and makes it the default device,
 * resetting the top and current directories to its root.
 *
 * @mangled ChangeHddFile__Fv
 * @address 0x148AE0
 * @size 0x78
 */
int ChangeHddFile();

/**
 *
 * Unmounts the hard-disk installation and makes the disc the default device
 * again; reports whether the hard disk had been in use.
 *
 * @mangled ChangeDefaultFile__Fv
 * @address 0x148B60
 * @size 0x68
 */
int ChangeDefaultFile();

/**
 *
 * Sets the function that is told the error code
 * whenever a hard-disk file operation fails.
 *
 * @mangled SetIoErrCallBack__FPFi_i
 * @address 0x148BD0
 * @size 0x8
 */
void SetIoErrCallBack(int (*callback)(int));

/**
 *
 * Sets the directory that relative paths are read from,
 * or resets it to the top directory when given null.
 *
 * @mangled SetCurrentDir__FPc
 * @address 0x148BE0
 * @size 0x54
 */
void SetCurrentDir(char *dir);

/**
 *
 * Copies the directory that relative paths
 * are currently read from.
 *
 * @mangled GetCurrentDir__FPc
 * @address 0x148C40
 * @size 0xC
 */
void GetCurrentDir(char *out_dir);

/**
 *
 * Sets the current directory to a directory below the top
 * directory, or to the top directory itself when given null.
 *
 * @mangled ChangeDir__FPc
 * @address 0x148C50
 * @size 0x5C
 */
void ChangeDir(char *dir);

/**
 *
 * Empties the background read queue.
 *
 * @mangled InitReadBG__Fv
 * @address 0x148D30
 * @size 0x54
 */
void InitReadBG();

/**
 *
 * Queues a file for reading in the background, from the
 * file cache, the disc or another device; reports success.
 *
 * @mangled LoadFileBG__FPcP1Pi
 * @address 0x148D90
 * @size 0x2BC
 */
int LoadFileBG(char *name, u_long128 *buffer, int *out_size);

/**
 *
 * Finds the background read queued under a full path,
 * or null when there is none.
 *
 * @mangled GetReadBGFile__FPc
 * @address 0x149050
 * @size 0x74
 */
BG_READ_INFO *GetReadBGFile(char *name);

/**
 *
 * Gives a background read queue slot by index,
 * or null when it is out of range or free.
 *
 * @mangled GetReadBGFile__Fi
 * @address 0x1490D0
 * @size 0x48
 */
BG_READ_INFO *GetReadBGFile(int index);

/**
 *
 * Starts a fresh round of background reads
 * by emptying the queue.
 *
 * @mangled StartReadBG__Fv
 * @address 0x149120
 * @size 0x8
 */
void StartReadBG();

/**
 *
 * Advances the first unfinished background read,
 * at most once per vertical sync.
 *
 * @mangled ReadBG__Fv
 * @address 0x149130
 * @size 0x194
 */
void ReadBG();

/**
 *
 * Advances the background reads and reports
 * whether any is still unfinished.
 *
 * @mangled ReadBGSync__Fv
 * @address 0x1492D0
 * @size 0x68
 */
int ReadBGSync();

/**
 *
 * Cancels the background reads still running, closing any open
 * file, and empties the queue.
 *
 * @mangled BreakReadBG__Fv
 * @address 0x149340
 * @size 0x8C
 */
void BreakReadBG();

/**
 *
 * Finds DATA.DAT on the disc and loads the
 * DATA.HD4 index of the files inside it.
 *
 * @mangled InitCDFile__Fv
 * @address 0x1493D0
 * @size 0x1A4
 */
void InitCDFile();

/**
 *
 * Reads a whole file, and stops the game with
 * a message when it cannot be read.
 *
 * @mangled LoadFile__FPcPvPi
 * @address 0x1497D0
 * @size 0x48
 */
int LoadFile(char *path, void *buffer, int *out_size);

/**
 *
 * Reads a file from the file cache or its device as the mode asks
 * (LOAD_FILE_MODE); reports success, or gives the open descriptor.
 *
 * @mangled LoadFile2__FPcPvPii
 * @address 0x149820
 * @size 0x3D4
 */
int LoadFile2(char *path, void *buffer, int *out_size, int mode);

/**
 *
 * Clears the file cache and gives it memory starting at an address,
 * growing in the direction the type (FILE_CACHE_TYPE) selects.
 *
 * @mangled InitFileCache__FP1i
 * @address 0x149D70
 * @size 0xA4
 */
void InitFileCache(u_long128 *address, int type);

/**
 *
 * Clears the file cache
 * and disables it.
 *
 * @mangled DeleteFileCache__Fv
 * @address 0x149E20
 * @size 0xC
 */
void DeleteFileCache();

/**
 *
 * Queues a file to be read into the file cache in the background, or
 * counts one more use of it when it is already cached; reports success.
 *
 * @mangled LoadFileCacheBG__FPc
 * @address 0x149E80
 * @size 0x13C
 */
int LoadFileCacheBG(char *path);

/**
 *
 * Gives where a file is held in the file cache and its size,
 * or null when it is not cached.
 *
 * @mangled SearchFileCache__FPcPi
 * @address 0x14A050
 * @size 0x5C
 */
u_long128 *SearchFileCache(char *path, int *out_size);

/**
 *
 * Writes a buffer to a file on the network
 * socket or another device.
 *
 * @mangled WriteFile__FPcPvi
 * @address 0x14A0B0
 * @size 0xDC
 */
int WriteFile(char *path, void *buffer, int size);

/**
 *
 * Finds a file by name inside a pack that has already been read,
 * ignoring any directory in the name.
 *
 * @mangled GetPackFile__FPUiPcPi
 * @address 0x14A190
 * @size 0xE8
 */
u_int *GetPackFile(u_int *pack, char *name, int *out_size);

/**
 *
 * Finds a file by its position inside a pack that
 * has already been read, giving its name and size.
 *
 * @mangled GetPackFile__FPUiiPPcPi
 * @address 0x14A280
 * @size 0x5C
 */
u_int *GetPackFile(u_int *pack, int index, char **out_name, int *out_size);

/**
 *
 * Collects up to a maximum number of files with an extension from a pack,
 * giving their data, sizes and names; returns how many were found.
 *
 * @mangled GetPackFileExt__FPUiPcPPUiiPiPPc
 * @address 0x14A2E0
 * @size 0x144
 */
int GetPackFileExt(u_int *pack, char *extension, u_int **files, int max_files, int *sizes, char **names);

/**
 *
 * Counts the files held
 * in a pack.
 *
 * @mangled GetPackFileNum__FPUi
 * @address 0x14A430
 * @size 0x58
 */
int GetPackFileNum(u_int *pack);

/**
 *
 * Splits a path into its directory, with the trailing slash,
 * and its file name.
 *
 * @mangled DivPathName__FPcPcPc
 * @address 0x14A490
 * @size 0x13C
 */
void DivPathName(char *path, char *out_dir, char *out_name);

/**
 *
 * Splits a path into its directory, its file name
 * without extension, and its extension.
 *
 * @mangled DivPathNameExt__FPcPcPcPc
 * @address 0x14A5D0
 * @size 0x78
 */
void DivPathNameExt(char *path, char *out_dir, char *out_name, char *out_ext);
