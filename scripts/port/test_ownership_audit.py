"""Check that the ownership inventory includes concrete allocation call sites."""

import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from scripts.port import cstring_audit, ownership_audit, unsafe_api_audit


class OwnershipAuditTests(unittest.TestCase):
    def test_explicit_ownership_prefix_must_exist_inside_the_project(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            with self.assertRaisesRegex(ValueError, "does not exist"):
                ownership_audit.owned_roots(root, (Path("missing_owned.cpp"),))
            with self.assertRaisesRegex(ValueError, "outside the project"):
                ownership_audit.owned_roots(root, (root.parent,))
            dependency = root / "dependency.cpp"
            dependency.write_text("void owned() {}\n")
            self.assertIn(dependency, ownership_audit.owned_roots(root, (dependency,)))

    def test_c_allocations_and_instantiated_arena_types_are_reported(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            build = root / "build"
            build.mkdir()
            source = root / "port/src/memory/allocations.cpp"
            source.parent.mkdir(parents=True)
            (source.parent / "raw_arena.inc").write_text(
                "inline void *from_header(mgCMemory &memory) { return memory.Alloc(2); }\n")
            source.write_text("""
#include <cstddef>
#include <cstdlib>
#include <cstring>
#include <new>
#include <memory>
#include <string>
struct Arena {};
struct mgCMemory { void *Alloc(int); };
struct Unrelated { void *Alloc(int); };
#include "raw_arena.inc"
template<class T> T *Allocate(Arena &) { return nullptr; }
template<class T> T *NewObject(Arena &) { return nullptr; }
namespace project { template<class T> T *make_unique() { return nullptr; } }
void use(Arena &arena) {
    int *numbers = Allocate<int>(arena);
    long *record = NewObject<long>(arena);
    void *storage = std::malloc(32);
    std::free(storage);
    char copied[8]{};
    std::strcpy(copied, "ok");
    std::string text = "ready";
    mgCMemory memory;
    Unrelated unrelated;
    void *raw_array = memory.Alloc(4);
    (void)unrelated.Alloc(4);
    alignas(int) unsigned char object_storage[sizeof(int)];
    int *placed = ::new (static_cast<void *>(object_storage)) int(7);
    auto unique = std::make_unique<int>(7);
    auto shared = std::make_shared<int>(8);
    auto allocated = std::allocate_shared<int>(std::allocator<int>{}, 9);
    auto unique_overwrite = std::make_unique_for_overwrite<int[]> (2);
    auto shared_overwrite = std::make_shared_for_overwrite<int>();
    auto allocated_overwrite = std::allocate_shared_for_overwrite<int>(std::allocator<int>{});
    (void)project::make_unique<int>();
    (void)numbers;
    (void)record;
    (void)text;
    (void)raw_array;
    (void)placed;
}
""")
            compiler = shutil.which("clang++-23") or shutil.which("clang++")
            self.assertIsNotNone(compiler)
            resource_dir = subprocess.check_output([compiler, "-print-resource-dir"], text=True).strip()
            (build / "compile_commands.json").write_text(json.dumps([{
                "directory": str(root),
                "file": str(source),
                "arguments": [compiler, "-std=c++26", f"-resource-dir={resource_dir}", "-c", str(source)],
            }]))
            rows = ownership_audit.inventory(build, root)
            self.assertIn(("arena_template_call", "int *"), {(row[3], row[4]) for row in rows})
            self.assertIn(("arena_object_call", "long *"), {(row[3], row[4]) for row in rows})
            self.assertIn("heap_alloc_call", {row[3] for row in rows})
            self.assertIn("heap_release_call", {row[3] for row in rows})
            raw = [row for row in rows if row[3] == "raw_arena_call"]
            self.assertEqual(len(raw), 2)
            self.assertTrue(any(row[0].endswith("raw_arena.inc") for row in raw))
            self.assertIn("memory . Alloc", raw[0][-1])
            self.assertIn(("placement_new", "int *"), {(row[3], row[4]) for row in rows})
            factories = [row for row in rows if row[3] == "ownership_factory_call"]
            self.assertEqual(len(factories), 6)
            self.assertTrue(all("std ::" in row[-1] for row in factories))
            self.assertTrue(any("unique_ptr<int" in row[4] for row in factories))
            self.assertTrue(any("shared_ptr<int" in row[4] for row in factories))
            self.assertIn("strcpy", {row[3] for row in cstring_audit.inventory(build, root)})
            self.assertEqual(unsafe_api_audit.scan(build, root), [])
            source.write_text('#include "missing_allocation_header.hpp"\n')
            with self.assertRaisesRegex(RuntimeError, "could not parse"):
                ownership_audit.inventory(build, root)
            with self.assertRaisesRegex(RuntimeError, "could not parse"):
                cstring_audit.inventory(build, root)
            with self.assertRaisesRegex(RuntimeError, "could not parse"):
                unsafe_api_audit.scan(build, root)


if __name__ == "__main__":
    unittest.main()
