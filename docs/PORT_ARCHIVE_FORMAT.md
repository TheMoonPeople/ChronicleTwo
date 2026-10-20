# Asset archive format

The extractor publishes all converted assets and gameplay configuration in `<game-root>/data.zip`, with the
marker `<game-root>/data.json` beside it. Datapacks use the same container. Kazarov's
`zip_archive` module (`tools/kazarov/src/rust/zip_archive.rs`) writes and reads it, and the C++
bridge (`kazarov_bridge/rust/lib.h`, namespace `kazarov`) exposes the reader and the directory
packer to the game and `dc2data`.

## Namespace

Entries form a single namespace for retained retail files, converted textures, models, audio,
movies and gameplay JSON. The tracked, pretty-printed documents in `port/gameplay/` are packaged
as compact JSON under `gameplay/` in a gameplay-only seed `data.zip`. The executable contains only
the document paths and SHA-256 hashes used to validate that seed. Extraction copies the validated
documents into the same `gameplay/` paths in the completed archive. Conversion
submits final assets directly to the ZIP writer; it creates no intermediate asset tree. Entry
names are relative to the asset namespace and must not collide, even ignoring case.

Entry names:

- are UTF-8 and use `/` as the only separator;
- are relative, with no empty, `.` or `..` component, and no `\`, `:`, NUL or control character;
- are unique ignoring ASCII case. Original case is preserved.

Directories have no entries of their own. All PNGs and standalone texture JSON
are under `textures/`, preserving ordinary source directories and removing
extension-bearing container directory components. Character PNGs use the nearest
`.chr` basename with sequential suffixes. Models and their `.game.json` sidecars
keep their model locations and refer to the relocated images. A texture outside
any PACK keeps its retail directory and name below `textures/`, where the game
finds a relative `.json` name it misses
([texture format](PORT_TEXTURE_FORMAT.md)).

## Container

The completed archive is a standard ZIP file (APPNOTE 6.3.10), always written in ZIP64 form:

| Field | Value |
| --- | --- |
| Entry order | Final assets in producer-completion order; names sorted in the central directory. Standalone datapacks use globally sorted names. |
| Compression | Method 0 (stored) for names ending `.png` or `.mp4` (ASCII case-insensitive); method 93 (Zstandard, level 1, one frame with its content size) for everything else |
| Flags | Bit 11 (UTF-8 names) only; no encryption and no data descriptors |
| Timestamps | MS-DOS 1980-01-01 00:00:00 (`time = 0x0000`, `date = 0x0021`); no extended time fields |
| Version needed | 63 for Zstandard entries, 45 for stored entries |
| Local header sizes | `0xFFFFFFFF`; the ZIP64 extra field (`0x0001`, 16 bytes) holds the uncompressed then compressed size |
| Central header | Sizes and local header offset are `0xFFFFFFFF`; the ZIP64 extra field (24 bytes) holds uncompressed size, compressed size and local header offset |
| Attributes | Internal and external attributes are 0; no comments |
| End records | ZIP64 end of central directory record, ZIP64 locator, then a classic end record whose counts, size and offset are saturated (`0xFFFF`, `0xFFFFFFFF`) |

Every entry's data begins at a 64-byte aligned file offset. After the ZIP64 field, the local
header carries one padding extra field (`0xD935`, zero-filled) sized to reach the alignment;
padding is omitted when the data is already aligned. Readers ignore the field.

PNG and MP4 files are already compressed. Storing them lets the game read a stored entry's bytes
straight from the file: an MP4 entry can be streamed by file range starting at its data offset.

Standalone directory packing produces identical bytes for identical files with the same Zstandard
library version. Progressive extraction may arrange local entries by completion order; its content
digest is independent of that order.

The smaller build-generated gameplay seed uses classic ZIP size and offset fields, with the
same Zstandard compression, timestamps, CRCs and 64-byte payload alignment. It is built into
`assets/data.zip` and installed or packaged as `data.zip` beside the executable. It has no
`data.json` marker and cannot substitute for a completed extraction. Rebuilding the seed does
not modify an existing completed archive.

## Integrity

Each entry carries the CRC-32 of its uncompressed bytes. The reader verifies the CRC on every
`archive_read_entry` call.

The marker's `output_sha256` is a content digest that does not depend on compression. It is the
SHA-256 of:

```
"kazarov-archive-content-v1\0"
for each entry, in name order:
    u64 LE  name length in bytes
    name    UTF-8 bytes
    u64 LE  uncompressed size
    32 bytes SHA-256 of the uncompressed contents
```

## Marker

`data.json` describes the published archive:

| Key | Meaning |
| --- | --- |
| `schema_version` | 1 |
| `data_version` | Extractor data version (`tools/kazarov/data_version.json`); version 20 renames bare script asset names by their converted extension and rebakes every action of a frame that is scaled but never rotated from its authored matrix; version 19 places gameplay documents under `gameplay/`; version 18 introduced `textures/` and relocated PACK members |
| `layout` | `"zip"` |
| `archive_size` | Size of `data.zip` in bytes |
| `archive_entries` | Number of entries |
| `output_sha256` | Content digest above |
| `source_state` | Path and metadata fingerprint of the disc source |
| `source_sha256` | Content hash of the disc source |
| `texture_sources` | Number of converted retail texture sources |
| `gameplay_plan_sha256` | Fingerprint of the checked-in gameplay plan that affects generated assets |
| `gameplay_source_fingerprint` | Fingerprint of all checked-in gameplay source paths and bytes bundled with this extractor |

A marker with another data version or layout is not current, so data extracted into the earlier
`data/` and `port_data/` directories is extracted again. Publishing an archive removes those
directories.

## Extraction and publication

The extractor reads the ISO once into shared memory, indexes checked byte ranges for top-level
files and nested PACK members, and hashes that same buffer for the source identity. Directory
sources cache each source file once. A single worker pool runs texture, model, audio, movie,
script and retained-asset jobs concurrently. Jobs submit only final immutable bytes or borrowed
source ranges. Separate byte budgets bound conversion and queued ZIP preparation; once other
asset categories finish, the conversion budget can grow using current physical-memory headroom
while the ZIP queue stays bounded. A dedicated writer appends prepared entries as they finish.
No extracted disc tree, PACK scratch files, or
staged asset files are created on the normal path.

The writer keeps `data.zip.partial` private until it writes the sorted central directory, then
records the archive identity in `data.json`. All payload and cross-file checks run after conversion
completes, reading the finished ZIP and the shared source memory. The archive and marker are moved
into the game root only after verification. Earlier data is moved aside first and restored if
publication fails. A retry discards the private partial stage and rebuilds the archive before
verification and publication.

## Verification

`dc2data current <source> <game-root>/data` reads only metadata. It succeeds when the marker has
the current data version and the archive layout, `data.zip` is a file of the recorded size, and
the source is unchanged.

`dc2data check <game-root>/data` parses the archive, validates every name, decompresses every
entry and checks its CRC-32, and compares the entry count and content digest with the marker. It
also applies the rules that need only one entry:

- no `.img` path component, `.chr` file, binary PACK container or obsolete root index
  (`manifest.json`, `catalog.json`, `audio_catalog.json`, `model_catalog.json`,
  `cfg_catalog.json`);
- `pack.json` markers have `schema_version: 1`, `kind: "asset_directory"`, and an
  optional `texture_members` array of `{"name":"one.json","path":"textures/map/one.json"}`
  records linking logical members to physical texture documents;
- no proprietary scene audio table (`snd2/rev.bin`, `snd2/map_index.txt`);
- files other than PNG, MP4, WAV, glTF and JSON contain no TIM2 or IMG texture payload.

After all conversion finishes, cross-file audits read the completed archive: texture documents
and PNG levels, glTF buffers and image references, audio documents and media, and retained scripts
recomputed from the source. Gameplay documents and their cross-file references are checked in
the completed archive. A separate explicit gameplay audit compares the tracked source documents
with their retail sources. The script audit checks targets of migrated resource operands; retail
actor-load literals that name no source asset remain unchanged and do not require archive targets.
The content digest ties the archive to the audited bytes.

## Datapacks

`dc2data pack <directory> <archive.zip>` (bridge: `pack_directory`) writes a datapack archive by
the same rules, naming each file by its path relative to `<directory>`. It writes nothing into the
packed directory itself.

## Bridge API

```cpp
#include "kazarov_bridge/rust/lib.h"

rust::Box<kazarov::Archive> kazarov::open_archive(rust::Str path);           // throws rust::Error
std::size_t   kazarov::archive_entry_count(const Archive &);
rust::Str     kazarov::archive_entry_name(const Archive &, std::size_t);     // original case
std::uint64_t kazarov::archive_entry_size(const Archive &, std::size_t);     // uncompressed
std::uint32_t kazarov::archive_entry_crc(const Archive &, std::size_t);
bool          kazarov::archive_entry_stored(const Archive &, std::size_t);
std::uint64_t kazarov::archive_entry_data_offset(const Archive &, std::size_t);
void          kazarov::archive_read_entry(const Archive &, std::size_t, rust::Slice<std::uint8_t> out); // throws
rust::String  kazarov::archive_path(const Archive &);
void          kazarov::pack_directory(rust::Str source, rust::Str output);   // throws
```

An `Archive` is immutable and can be read from any number of threads at once. It memory-maps the
file and falls back to positional reads when mapping fails. `open_archive` accepts any
single-disk ZIP whose entries are stored or Zstandard-compressed and unencrypted, with or without
ZIP64 records. Every index passed to an entry accessor must be below `archive_entry_count`; an
out-of-range index aborts. `archive_read_entry` requires `out.size()` to equal the entry's size,
fills it by copying or decompressing, and throws on a CRC-32 mismatch.
