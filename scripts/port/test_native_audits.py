"""Regression tests for records and pointer audits after native source migration."""

import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from collections import Counter
from pathlib import Path

from clang import cindex

from scripts.port import cstring_audit, ownership_audit, records, run_audit_shards, truncations, unsafe_api_audit


class NativeAuditTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.previous_prefixes = truncations.OWNED_PREFIXES
        truncations.OWNED_PREFIXES = ()
        self.addCleanup(setattr, truncations, "OWNED_PREFIXES", self.previous_prefixes)
        self.previous_root = truncations.ROOT
        truncations.ROOT = str(self.root)
        self.addCleanup(setattr, truncations, "ROOT", self.previous_root)

    def test_compile_database_selects_native_units_and_keeps_domain_path(self):
        build = self.root / "build"
        build.mkdir()
        entries = []
        for name in ("port/src/audio/sound.cpp", "port/src/tests/sound_test.cpp", "ps2/src/sound.cpp"):
            source = self.root / name
            source.parent.mkdir(parents=True, exist_ok=True)
            source.write_text("\n")
            entries.append({"directory": str(self.root), "file": str(source),
                            "arguments": ["clang++", "-c", str(source)]})
        (build / "compile_commands.json").write_text(json.dumps(entries))
        selected = truncations.unit_entries(str(build))
        self.assertEqual([truncations.rel(entry["file"]) for entry in selected],
                         ["port/src/audio/sound.cpp"])

    def test_record_finds_renamed_native_header_by_assertion(self):
        header = self.root / "port/include/audio/scene.hpp"
        header.parent.mkdir(parents=True)
        header.write_text("STATIC_ASSERT(sizeof(SND_REV_INFO) == 0x8);\n")
        row = records.Row("SND_REV_INFO", "0x8", "ps2/include/scenesnd.hpp", 12, "assert", 0, 0)
        self.assertEqual(records.runtime_declared_path(str(self.root), row), str(header))

    def test_source_record_extraction_isolates_record_members(self):
        source = self.root / "port/src/object/menu/inventmn.cpp"
        source.parent.mkdir(parents=True)
        source.write_text("struct INVENT_CREATED_ITEM_OLD {\n  short item_id;\n  unsigned char bytes[8];\n};\n"
                          "void unrelated() { while (true) {} }\n")
        row = records.Row("INVENT_CREATED_ITEM_OLD", "0xC", "ps2/src/inventmn.cpp", 1, "assert", 0, 0)
        extracted = records.source_record_declaration(str(source), row)
        self.assertIn("short item_id", extracted)
        self.assertNotIn("unrelated", extracted)

    def test_arena_cursor_audit_finds_writes_and_ignores_reads(self):
        source = self.root / "arena_cursor_fixture.cpp"
        source.write_text("""
struct mgCMemory { int stack_used; int lock; };
void use(mgCMemory& arena, int* other) {
  arena.stack_used = 0;
  arena.stack_used += 2;
  --arena.stack_used;
  arena.lock = 1;
  *other = arena.stack_used;
  if (arena.stack_used == 0) {}
  arena.stack_used = arena.lock = 0;
}
""")
        translation_unit = cindex.Index.create().parse(str(source), args=["-std=c++23"])
        writes = Counter(
            field
            for cursor in translation_unit.cursor.walk_preorder()
            if (field := unsafe_api_audit.arena_cursor_write(cursor))
        )
        self.assertEqual(writes, Counter({"stack_used": 4, "lock": 2}))

    def test_arena_cursor_scan_excludes_allocator_implementation(self):
        build = self.root / "build"
        build.mkdir()
        sources = {
            "port/src/platform/use.cpp":
                "struct mgCMemory { int stack_used; int lock; };\n"
                "void use(mgCMemory& memory) { memory.stack_used = 0; memory.lock++; }\n",
            "port/src/memory/mg_memory.cpp":
                "struct mgCMemory { int stack_used; int lock; };\n"
                "void mgCMemoryReset(mgCMemory& memory) { memory.stack_used = 0; }\n",
        }
        entries = []
        for name, contents in sources.items():
            source = self.root / name
            source.parent.mkdir(parents=True)
            source.write_text(contents)
            entries.append({"directory": str(self.root), "file": str(source),
                            "arguments": ["clang++", "-std=c++23", "-c", str(source)]})
        (build / "compile_commands.json").write_text(json.dumps(entries))
        rows = unsafe_api_audit.scan(build, self.root, arena_cursors_only=True)
        self.assertCountEqual([row[:2] + row[3:] for row in rows], [
            ("port/src/platform/use.cpp", 2, "arena_cursor_write", "lock"),
            ("port/src/platform/use.cpp", 2, "arena_cursor_write", "stack_used"),
        ])

    def test_unsafe_api_scan_uses_resolved_destination_overload(self):
        source = self.root / "port/src/platform/loads.cpp"
        source.parent.mkdir(parents=True)
        source.write_text("""
#include <span>
struct Arena {};
int LoadFile(char *, void *, int *);
int LoadFile(char *, unsigned char *, int *);
int LoadFile(char *, Arena *, int *);
int LoadFile(char *, std::span<unsigned char>, int *);
namespace other { int LoadFile(char *, void *, int *); }
void use(char *path, unsigned char *bytes, Arena *arena, int *size) {
  LoadFile(path, static_cast<void *>(bytes), size);
  LoadFile(path, bytes, size);
  LoadFile(path, arena, size);
  LoadFile(path, std::span<unsigned char>(bytes, 8), size);
  other::LoadFile(path, static_cast<void *>(bytes), size);
}
""")
        compiler = shutil.which("clang++-23") or shutil.which("clang++")
        self.assertIsNotNone(compiler)
        build = self.root / "build"
        build.mkdir()
        (build / "compile_commands.json").write_text(json.dumps([{
            "directory": str(self.root), "file": str(source),
            "arguments": [compiler, "-std=c++26", "-c", str(source)],
        }]))
        rows = unsafe_api_audit.scan(build, self.root)
        self.assertEqual([(row[3], row[4]) for row in rows], [
            ("LoadFile", "char *, void *, int *"),
            ("LoadFile", "char *, unsigned char *, int *"),
        ])

    def included_fixture(self):
        compiler = shutil.which("clang++-23") or shutil.which("clang++")
        self.assertIsNotNone(compiler)
        sources = {
            "port/include/unsafe.hpp":
                "struct mgCMemory { int stack_used; int lock; };\n"
                "char* strcpy(char*, const char*); int LoadFile(char*, void*, int*);\n"
                "inline void included(mgCMemory& arena, char* path, char* dst) {\n"
                "  strcpy(dst, \"x\"); LoadFile(path, dst, nullptr); arena.lock = 1;\n}\n",
            "port/src/shared/alloc.inc": "inline int* included_alloc() { return new int; }\n",
            "port/include/writer.fragment": "inline void writer(mgCMemory& arena) { arena.stack_used += 1; }\n",
            "vendor/dependency.hpp": "inline long* vendor_allocation() { return new long; }\n",
            "tools/kazarov/include/owned_arena.hpp": "inline float* edited_dependency() { return new float; }\n",
            "tools/kazarov/include/unowned_neighbor.hpp": "inline double* unedited_dependency() { return new double; }\n",
        }
        for name, contents in sources.items():
            target = self.root / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(contents)
        includes = "".join(f'#include "{self.root / name}"\n' for name in sources)
        build = self.root / "build"
        build.mkdir()
        entries = []
        for name in ("first.cpp", "second.cpp"):
            source = self.root / "port/src" / name
            source.write_text(includes)
            entries.append({"directory": str(self.root), "file": str(source),
                            "arguments": [compiler, "-std=c++26", "-c", str(source)]})
        (build / "compile_commands.json").write_text(json.dumps(entries))
        return build

    def test_all_audits_include_owned_headers_inc_and_arbitrary_suffix_helpers_once(self):
        build = self.included_fixture()
        coverage = {}
        strings = cstring_audit.inventory(build, self.root, coverage=coverage)
        self.assertEqual(len(coverage["translation_units"]), 2)
        self.assertEqual([(row[0], row[3]) for row in strings], [("port/include/unsafe.hpp", "strcpy")])
        allocations = ownership_audit.inventory(build, self.root)
        self.assertEqual([(row[0], row[3], row[4]) for row in allocations],
                         [("port/src/shared/alloc.inc", "new", "int *")])
        unsafe = unsafe_api_audit.scan(build, self.root)
        self.assertEqual(Counter(row[3] for row in unsafe), Counter({"arena_cursor_write": 2, "LoadFile": 1}))
        writes = unsafe_api_audit.scan(build, self.root, arena_cursors_only=True)
        self.assertEqual({row[0] for row in writes}, {"port/include/unsafe.hpp", "port/include/writer.fragment"})
        self.assertEqual(len(writes), 2)

    def test_calls_on_one_header_line_keep_distinct_columns(self):
        build = self.included_fixture()
        header = self.root / "port/include/unsafe.hpp"
        header.write_text(header.read_text().replace('strcpy(dst, "x");', 'strcpy(dst, "x"); strcpy(dst, "y");'))
        rows = cstring_audit.inventory(build, self.root)
        self.assertEqual(len(rows), 2)
        self.assertEqual(len({row[:3] for row in rows}), 2)

    def test_explicit_owned_dependency_file_does_not_include_neighboring_vendor_code(self):
        build = self.included_fixture()
        rows = ownership_audit.inventory(build, self.root, (Path("tools/kazarov/include/owned_arena.hpp"),))
        self.assertEqual({row[0] for row in rows},
                         {"port/src/shared/alloc.inc", "tools/kazarov/include/owned_arena.hpp"})

    def test_explicit_owned_source_prefix_adds_only_its_compiled_dependency_unit(self):
        build = self.included_fixture()
        entries = json.loads((build / "compile_commands.json").read_text())
        for name in ("owned.cpp", "neighbor.cpp"):
            source = self.root / "tools/kazarov/src" / name
            source.parent.mkdir(parents=True, exist_ok=True)
            source.write_text("int* dependency_unit() { return new int; }")
            entries.append({"directory": str(self.root), "file": str(source),
                            "arguments": [entries[0]["arguments"][0], "-std=c++26", "-c", str(source)]})
        (build / "compile_commands.json").write_text(json.dumps(entries))
        coverage = {}
        rows = ownership_audit.inventory(build, self.root, (Path("tools/kazarov/src/owned.cpp"),), coverage)
        self.assertEqual(len(coverage["translation_units"]), 3)
        self.assertIn("tools/kazarov/src/owned.cpp", coverage["translation_units"])
        self.assertNotIn("tools/kazarov/src/neighbor.cpp", coverage["translation_units"])
        self.assertEqual({row[0] for row in rows},
                         {"port/src/shared/alloc.inc", "tools/kazarov/src/owned.cpp"})

    def test_shared_location_keeps_distinct_concrete_instantiation_types(self):
        build = self.included_fixture()
        header = self.root / "port/include/typed.hpp"
        header.write_text("inline auto typed_allocation() { return new ELEMENT; }\n")
        entries = json.loads((build / "compile_commands.json").read_text())
        for entry, element in zip(entries, ("int", "float")):
            Path(entry["file"]).write_text(f'#include "{header}"\n')
            entry["arguments"].insert(1, f"-DELEMENT={element}")
        (build / "compile_commands.json").write_text(json.dumps(entries))
        rows = ownership_audit.inventory(build, self.root)
        self.assertEqual(len(rows), 2)
        self.assertEqual({row[4] for row in rows}, {"int *", "float *"})
        self.assertEqual(len({row[:3] for row in rows}), 1)

    def test_truncation_walk_includes_owned_header_and_inc_roundtrips(self):
        build = self.included_fixture()
        declaration = "inline void* narrow(void* value) { unsigned int stored = (unsigned int)(uptr)value; return (void*)(uptr)stored; }"
        header = self.root / "port/include/narrow.hpp"
        included = self.root / "port/src/shared/narrow.inc"
        vendor = self.root / "vendor/narrow.hpp"
        for target in (header, included, vendor):
            target.write_text(declaration)
        header.write_text("using uptr = unsigned long long;" + chr(10) + declaration)
        source = self.root / "port/src/first.cpp"
        source.write_text(f'#include "{header}"' + chr(10) + f'#include "{included}"' + chr(10) + f'#include "{vendor}"')
        # Distinct definitions keep the fixture valid while all pointer flows remain identical.
        included.write_text(declaration.replace("narrow(", "narrow_inc("))
        vendor.write_text(declaration.replace("narrow(", "narrow_vendor("))
        truncations.ci = cindex
        result = truncations.walk(str(source), ["-std=c++26"])
        self.assertEqual(result["error_count"], 0)
        expected = {"port/include/narrow.hpp", "port/src/shared/narrow.inc"}
        self.assertEqual({row["file"] for row in result["narrowing"]}, expected)
        self.assertEqual({row["file"] for row in result["casts"]}, expected)
        self.assertEqual({row["file"] for row in result["back"]}, expected)

    def test_audits_reject_a_database_with_no_owned_production_commands(self):
        build = self.included_fixture()
        entries = json.loads((build / "compile_commands.json").read_text())
        entries = [entry for entry in entries if "no_such_unit" in entry["file"]]
        (build / "compile_commands.json").write_text(json.dumps(entries))
        for audit in (cstring_audit.inventory, ownership_audit.inventory, unsafe_api_audit.scan):
            with self.subTest(audit=audit.__module__):
                with self.assertRaisesRegex(RuntimeError, "no production compile commands"):
                    audit(build, self.root)

    def test_sharded_audit_verifies_coverage_and_deduplicates_shared_header_sites(self):
        build = self.included_fixture()
        output = self.root / "merged.tsv"
        coverage = self.root / "coverage.json"
        result = subprocess.run([sys.executable, run_audit_shards.__file__, "--audit", "cstring",
                                 "--build", str(build), "--root", str(self.root), "--out", str(output),
                                 "--coverage", str(coverage), "--jobs", "2"], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        rows = output.read_text().splitlines()
        self.assertEqual(len(rows), 2)
        self.assertEqual(rows[1].split(chr(9))[0], "port/include/unsafe.hpp")
        proof = json.loads(coverage.read_text())
        self.assertEqual(proof["parsed_commands"], 2)
        self.assertEqual(proof["unique_sources"], 2)
        self.assertEqual(proof["findings"], 1)

    def test_shard_selection_resolves_relative_files_and_owned_dependency_commands(self):
        build = self.included_fixture()
        entries = json.loads((build / "compile_commands.json").read_text())
        for entry in entries:
            entry["file"] = Path(entry["file"]).relative_to(self.root).as_posix()
        source = self.root / "tools/kazarov/src/owned.cpp"
        source.parent.mkdir(parents=True)
        source.write_text("int* owned() { return new int; }")
        entries.append({"directory": str(source.parent), "file": source.name,
                        "arguments": [entries[0]["arguments"][0], "-std=c++26", "-c", source.name]})
        (build / "compile_commands.json").write_text(json.dumps(entries))
        commands = run_audit_shards.source_commands(build, self.root, (source,))
        self.assertEqual(len(commands), 3)
        self.assertIn(str(source), [entry["file"] for entry in commands])

    def test_shard_merge_rejects_success_without_complete_command_coverage(self):
        build = self.included_fixture()
        commands = run_audit_shards.source_commands(build, self.root)
        output = chr(9).join(("file", "line", "column", "call", "type", "owner", "status", "expression")) + chr(10) + "inventory rows: 0" + chr(10)
        result = (output, "", 0, {"translation_units": ["port/src/first.cpp"], "parsed_commands": 1})
        with self.assertRaisesRegex(RuntimeError, "coverage differs"):
            run_audit_shards.merge_results("cstring", [result], commands, self.root)

    def test_failed_shard_preserves_previous_output_and_retires_stale_proof(self):
        build = self.included_fixture()
        (self.root / "port/include/unsafe.hpp").write_text("#error broken included helper")
        output = self.root / "merged.tsv"
        coverage = self.root / "coverage.json"
        output.write_text("previous result")
        coverage.write_text("stale")
        result = subprocess.run([sys.executable, run_audit_shards.__file__, "--audit", "ownership",
                                 "--build", str(build), "--root", str(self.root), "--out", str(output),
                                 "--coverage", str(coverage), "--jobs", "2"], capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(output.read_text(), "previous result")
        self.assertFalse(coverage.exists())
        self.assertIn("audit shard", result.stderr)

    def test_included_parse_errors_fail_closed_even_in_cursor_only_scan(self):
        build = self.included_fixture()
        (self.root / "port/include/unsafe.hpp").write_text("#error incomplete audit\n")
        for audit in (cstring_audit.inventory, ownership_audit.inventory):
            with self.subTest(audit=audit.__module__):
                with self.assertRaisesRegex(RuntimeError, "libclang could not parse"):
                    audit(build, self.root)
        with self.assertRaisesRegex(RuntimeError, "libclang could not parse"):
            unsafe_api_audit.scan(build, self.root, arena_cursors_only=True)


if __name__ == "__main__":
    unittest.main()
