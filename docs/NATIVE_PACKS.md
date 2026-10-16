# Native asset directories

Ordinary retail PACK containers become directories under port_data. The directory retains the archive's filename and extension, including enclosing archive components. Every such directory contains a pretty-printed pack.json with exactly schema_version 1 and kind asset_directory. Runtime code enumerates the actual filesystem; the marker has no member list, alias map, count or copied source bytes.

```json
{
  "schema_version": 1,
  "kind": "asset_directory"
}
```

The converter reads original PACK structure only to recover directory existence and original member identity. Leaf bytes come exclusively from the already-converted published data, preserving any remaining unrelated payloads and excluding zero-length consumed members. Thus the raw inventory cannot resurrect converted model, script, image or audio bytes. Nested ordinary PACKs become nested directories even when all their members were consumed.

Characters and sound bundles have their specialized native glTF or sound document outputs. They do not become ordinary CHR/SND PACK directories. Remaining binary PACK files are removed. Duplicate member names use deterministic ordinal suffixes, with distinct physical files and directories. Reserved pack.json collisions and attempts to overwrite existing native assets fail.

packs::verify rejects any recognized binary PACK in data or port_data and checks every directory marker's exact minimal schema. Tests cover preservation of current published bytes, removal of consumed payloads, nested empty directories, duplicate identities and retained-container rejection.
