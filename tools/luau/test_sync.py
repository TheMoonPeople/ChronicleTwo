"""Regression checks for incremental script publication and ownership."""

import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

from tools.luau.sync import sync


class SyncTests(unittest.TestCase):
    """Exercise publication and Ninja ordering without compiling the game."""

    def test_parallel_nested_publication(self):
        """Concurrent creation of shared output directories preserves containment checks."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            sources = root / "sources"
            relatives = [f"dungeon/act_script/f{index:03}.luau" for index in range(256)]
            (sources / "dungeon/act_script").mkdir(parents=True)
            for relative in relatives:
                (sources / relative).write_text("return 1")
            expected = root / "expected"
            expected.write_text("\n".join(relatives))
            sync(sources, root / "scripts", expected, root / "manifest", 16)
            self.assertEqual(len(list((root / "scripts").rglob("*.luau"))), 256)

    def test_incremental_publication(self):
        """Unchanged files keep timestamps while edits and missing outputs are published."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            sources, scripts = root / "sources", root / "scripts"
            sources.mkdir()
            (sources / "a.luau").write_text("return 1")
            (sources / "b.luau").write_text("return 2")
            expected, manifest = root / "expected", root / "manifest"
            expected.write_text("a.luau\nb.luau\n")
            sync(sources, scripts, expected, manifest, 4)
            original = (scripts / "b.luau").stat().st_mtime_ns
            sync(sources, scripts, expected, manifest, 4)
            self.assertEqual((scripts / "b.luau").stat().st_mtime_ns, original)
            (sources / "a.luau").write_text("return 100")
            (scripts / "b.luau").unlink()
            def interrupted_copy(source, destination):
                Path(destination).write_text("partial")
                raise OSError("Interrupted publication")

            with patch("tools.luau.sync.shutil.copyfile", side_effect=interrupted_copy):
                with self.assertRaises(OSError):
                    sync(sources, scripts, expected, manifest, 4)
            self.assertFalse((scripts / "b.luau").exists())
            sync(sources, scripts, expected, manifest, 4)
            self.assertEqual((scripts / "a.luau").read_text(), "return 100")
            self.assertEqual((scripts / "b.luau").read_text(), "return 2")
            (scripts / "b.luau").write_text("edited")
            (scripts / "unowned.luau").write_text("unowned")
            expected.write_text("")
            sync(sources, scripts, expected, manifest, 4)
            self.assertFalse((scripts / "a.luau").exists())
            self.assertEqual((scripts / "b.luau").read_text(), "edited")
            self.assertTrue((scripts / "unowned.luau").exists())

    def test_legacy_ownership(self):
        """The previous CMake manifest still identifies safe obsolete-file removals."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            scripts = root / "scripts"
            scripts.mkdir()
            (scripts / "old.luau").write_bytes(b"obsolete")
            manifest, expected = root / "manifest", root / "expected"
            manifest.write_text(hashlib.sha256(b"obsolete").hexdigest() + " old.luau\n")
            expected.write_text("")
            sync(root / "sources", scripts, expected, manifest, 2)
            self.assertFalse((scripts / "old.luau").exists())
            self.assertEqual(json.loads(manifest.read_text()), {})

    def test_ninja_dependencies(self):
        """The actual CMake publisher repairs missing outputs and stays idle afterward."""
        repository = Path(__file__).resolve().parents[2]
        dependencies = repository / ".kazarov/windows/deps"
        cmake = shutil.which("cmake") or str(dependencies / "cmake/cmake-4.4.5-windows-x86_64/bin/cmake.exe")
        ninja = shutil.which("ninja") or str(dependencies / "ninja/ninja.exe")
        if not Path(cmake).is_file() or not Path(ninja).is_file():
            self.skipTest("CMake and Ninja are required")
        declarations = (repository / "port/cmake/luau.cmake").read_text()
        publisher = declarations.split("# One publisher", 1)[1].split("# CT_LUAU_PRECOMPILE", 1)[0]
        with tempfile.TemporaryDirectory(prefix="chronicle ninja ") as directory:
            root = Path(directory)
            sources = root / "port/src/luau"
            sources.mkdir(parents=True)
            (root / "tools/luau").mkdir(parents=True)
            shutil.copyfile(repository / "tools/luau/sync.py", root / "tools/luau/sync.py")
            source = sources / "a.luau"
            source.write_text("return 1")
            (root / "CMakeLists.txt").write_text(
                'cmake_minimum_required(VERSION 3.22)\nproject(sync NONE)\n'
                f'set(Python3_EXECUTABLE "{Path(sys.executable).as_posix()}")\n'
                + "# One publisher" + publisher
                + '\nadd_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/a.luauc\n'
                'COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/scripts/a.luau ${CMAKE_BINARY_DIR}/a.luauc\n'
                'DEPENDS ${CMAKE_BINARY_DIR}/scripts/a.luau)\n'
                'add_custom_target(scripts ALL DEPENDS ${ct_luau_stamp} ${CT_LUAU_COPIES}\n'
                '${CMAKE_BINARY_DIR}/generated/luau/copied.txt ${CMAKE_BINARY_DIR}/a.luauc)\n'
            )
            build = root / "build"
            subprocess.run([cmake, "-S", str(root), "-B", str(build), "-G", "Ninja", f"-DCMAKE_MAKE_PROGRAM={ninja}"], check=True, capture_output=True)

            def run():
                return subprocess.run([ninja, "-C", str(build)], check=True, capture_output=True, text=True).stdout

            run()
            self.assertIn("no work to do", run())
            source.write_text("return 100")
            run()
            self.assertEqual((build / "a.luauc").read_text(), "return 100")
            self.assertIn("no work to do", run())
            (build / "scripts/a.luau").unlink()
            run()
            self.assertTrue((build / "scripts/a.luau").exists())
            self.assertIn("no work to do", run())
            (sources / "b.luau").write_text("return 2")
            run()
            self.assertTrue((build / "scripts/b.luau").exists())
            (sources / "b.luau").unlink()
            run()
            self.assertFalse((build / "scripts/b.luau").exists())
            self.assertIn("no work to do", run())


if __name__ == "__main__":
    unittest.main()
