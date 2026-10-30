#pragma once

#include "common.h"

#include <memory>
#include <span>
#include <string>
#include <string_view>
#include <utility>

#include "mg_memory.hpp"

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

namespace dc2::io {
struct FileReadState;

/**
 *
 * Owns initialized aligned file bytes independently of queue slots and destination arenas.
 *
 */
class [[gsl::Owner]] FileRead {
public:
    /**
     *
     * Creates an empty read without allocating storage or a queue slot.
     *
     */
    FileRead() = default;
    /**
     *
     * Reports whether a successful read owns initialized file storage.
     *
     */
    [[nodiscard]] explicit operator bool() const;
    /**
     *
     * Borrows the initialized native file bytes while this read remains owned.
     *
     */
    [[nodiscard]] std::span<u8> Bytes() const &;
    std::span<u8>               Bytes() const && = delete;
    /**
     *
     * Borrows the initialized file bytes together with their zeroed sector padding.
     *
     */
    [[nodiscard]] std::span<const u8> PaddedBytes() const &;
    std::span<const u8>               PaddedBytes() const && = delete;
    /**
     *
     * Gives the initialized file byte count excluding padding.
     *
     */
    [[nodiscard]] int Size() const;
    /**
     *
     * Borrows the requested full filename while this read remains owned.
     *
     */
    [[nodiscard]] std::string_view Name() const &;
    std::string_view               Name() const && = delete;
    /**
     *
     * Borrows the selected native source identity while this read remains owned.
     *
     */
    [[nodiscard]] std::string_view Source() const &;
    std::string_view               Source() const && = delete;
    /**
     *
     * Reports whether completion polling has issued this read.
     *
     */
    [[nodiscard]] bool Issued() const;
    /**
     *
     * Reports whether completion polling or a synchronous read has completed.
     *
     */
    [[nodiscard]] bool Done() const;
    /**
     *
     * Reports whether queue cleanup removed an unfinished read.
     *
     */
    [[nodiscard]] bool Cancelled() const;
    /**
     *
     * Retains the input until an explicit consuming allocation or either owner retires.
     *
     */
    [[nodiscard]] bool Retain(const dc2::memory::ArenaBuffer &consumer) const;

private:
    friend FileRead FindBackgroundRead(std::string_view name);
    friend FileRead FindBackgroundRead(int index);
    friend FileRead ReadFile(std::string_view name);
    friend FileRead ReadResourceFile(std::string_view name);
    friend FileRead QueueBackgroundRead(std::string_view name);
    /**
     *
     * Acquires file storage and status already established by a native read factory.
     *
     */
    explicit FileRead(std::shared_ptr<FileReadState> value);
    std::shared_ptr<FileReadState> state; /**< Independently owned data and completion state. */
};

/**
 *
 * Retains a background read selected by its full path or current queue index.
 *
 */
FileRead FindBackgroundRead(std::string_view name);
/**
 *
 * Acquires an owning copy of a current queue entry by its bounded slot index.
 *
 */
FileRead FindBackgroundRead(int index);
/**
 *
 * Acquires an owning read named relative to the current file directory.
 *
 */
FileRead FindBackgroundReadInCurrentDir(std::string_view name);
/**
 *
 * Loads transformed native file bytes into independent aligned storage.
 *
 */
FileRead ReadFile(std::string_view name);
/**
 *
 * Owns complete indexed resource contents without game-data placeholders or script transforms.
 *
 */
FileRead ReadResourceFile(std::string_view name);
/**
 *
 * Queues an independently owned read without a borrowed destination buffer.
 *
 */
FileRead QueueBackgroundRead(std::string_view name);
} // namespace dc2::io

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
 * Returns the current asset directory as an owning string.
 *
 */
std::string GetCurrentDir();

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
 * Copies a background asset into a bounded destination before returning; completion polling does not write it again.
 *
 */
int LoadFileBG(char *name, std::span<u8> destination, int *out_size);

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
 * Loads a required asset into a bounded destination and exits if it is missing or too large.
 *
 */
int LoadFile(char *path, std::span<u8> destination, int *out_size);

/**
 *
 * Reads an asset only when its complete padded and patched data fits the destination.
 *
 */
int LoadFile2(char *path, std::span<u8> destination, int *out_size, int mode);

/**
 *
 * Clears the file cache and binds its complete live storage,
 * growing within that extent in the selected direction.
 *
 * @mangled InitFileCache__FP1i
 * @address 0x149D70
 * @size 0xA4
 */
void InitFileCache(dc2::memory::ArenaBuffer storage, int type);

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

namespace dc2::io {
/**
 *
 * Writes a complete bounded byte sequence to a host device file.
 *
 */
bool WriteFile(std::string_view path, std::span<const std::byte> bytes);
} // namespace dc2::io

/**
 *
 * Splits a path into its directory and filename without fixed output buffers.
 *
 */
std::pair<std::string, std::string> DivPathName(std::string_view path);

/**
 *
 * Holds the directory, filename stem and extension of a split asset path.
 *
 */
struct DataReadPathNameExt {
    std::string directory;
    std::string name;
    std::string extension;
};

/**
 *
 * Splits a path and its first filename extension without fixed output buffers.
 *
 */
DataReadPathNameExt DivPathNameExt(std::string_view path);
