"""Linked objects must rebuild when the postprocessing steps change."""

from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time
import unittest

ROOT = Path(__file__).resolve().parents[2]


def postprocess(revision):
    return ("import pathlib,sys\n"
            f"pathlib.Path(sys.argv[1]).write_text('postprocessed {revision}')\n")


@unittest.skipUnless(shutil.which('cmake') and shutil.which('ninja'), 'CMake and Ninja required')
class ObjectGraphTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.write('src/first.cpp', '')
        self.write('src/second.cpp', '')
        self.write('scripts/build/postprocess_object.py', postprocess('1'))
        self.write('scripts/build/fixup_sections.sh', 'exit 0\n')
        self.write('compiler/mwccps2.py',
                   'import pathlib,sys\n'
                   'pathlib.Path(sys.argv[sys.argv.index("-o")+1]).write_bytes(b"compiled");pathlib.Path(pathlib.Path(sys.argv[-1]).stem+\".d\").write_text(\"x.o: \"+sys.argv[-1]+\"\\n\")\n')
        self.write('ObjectLists.cmake', (ROOT / 'ps2/cmake/ObjectLists.cmake').read_text())
        self.write('CMakeLists.txt', f'''cmake_minimum_required(VERSION 3.20)
project(graph NONE)
set(BUILD_DIR out)
set(SCRIPTS_DIR scripts)
set(INCLUDE_DIR include)
set(PYTHON "{sys.executable}")
set(SATANSFIDDLE none)
set(SATANSFIDDLE_CONFIG none)
set(SATANSFIDDLE_DEPENDENCIES "")
set(CC_FLAGS -c)
set(KZ_MWCC compiler/mwccps2.py)
set(KZ_MWCC_RUNNER "{sys.executable}")
set(KZ_LIB_INCLUDE_DIRS include/std)
include("{ROOT / 'tools/kazarov/CMakeLists.txt'}")
include(ObjectLists.cmake)
set(objects out/first.cpp.o out/second.cpp.o)
kz_object_dirs(${{objects}})
foreach(unit first second)
  add_cpp_object(out/${{unit}}.cpp.o src/${{unit}}.cpp ${{unit}})
endforeach()
add_custom_target(objects DEPENDS ${{objects}})
''')
        self.command('cmake', '-S', '.', '-B', 'out', '-G', 'Ninja')

    def write(self, name, text):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)

    def command(self, *args):
        result = subprocess.run(args, cwd=self.root, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result.stdout

    def test_postprocessing_inputs_rebuild_linked_objects_without_recompiling(self):
        self.command('cmake', '--build', 'out', '--target', 'objects')
        self.assertNotIn('CC src/', self.command('ninja', '-C', 'out', '-n', 'objects'))
        self.assertEqual((self.root / 'out/objdiff/base/first.cpp.o').read_bytes(), b'compiled')

        time.sleep(0.01)
        self.write('scripts/build/postprocess_object.py', postprocess('2'))
        pending = self.command('ninja', '-C', 'out', '-n', 'objects')
        self.assertNotIn('CC src/', pending)
        for unit in ('first', 'second'):
            self.assertIn(f'POST src/{unit}.cpp', pending)

        self.command('cmake', '--build', 'out', '--target', 'objects')
        for unit in ('first', 'second'):
            self.assertEqual((self.root / f'out/{unit}.cpp.o').read_bytes(), b'postprocessed 2')
            self.assertEqual((self.root / f'out/objdiff/base/{unit}.cpp.o').read_bytes(), b'compiled')
        self.assertNotIn('POST src/', self.command('ninja', '-C', 'out', '-n', 'objects'))


if __name__ == '__main__':
    unittest.main()
