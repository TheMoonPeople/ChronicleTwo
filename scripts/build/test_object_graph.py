"""Linked objects must rebuild when native-data proof tools change."""

from pathlib import Path
import shutil
import subprocess
import tempfile
import time
import unittest

ROOT = Path(__file__).resolve().parents[2]


@unittest.skipUnless(shutil.which('cmake') and shutil.which('ninja'), 'CMake and Ninja required')
class ObjectGraphTests(unittest.TestCase):
    def test_postprocessing_inputs_rebuild_every_compiled_unit(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)

            def write(name, text):
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(text)

            for name in ('scripts/build/postprocess_object.py', 'tools/mwccgap/elf.py',
                         'src/first.cpp', 'src/second.cpp', 'out/split'):
                write(name, '')
            for name in ('objdiff_data', 'lcf'):
                write(f'scripts/build/{name}.py', name)
            write('scripts/build/mwccgap.sh', '''#!/bin/sh
cat scripts/build/objdiff_data.py scripts/build/lcf.py > "$1"
printf '%s:\\n' "$PWD/$1" > "$2"
''')
            write('scripts/build/fixup_sections.sh', 'exit 0\n')
            write('ObjectLists.cmake', (ROOT / 'ps2/cmake/ObjectLists.cmake').read_text())
            write('CMakeLists.txt', '''cmake_minimum_required(VERSION 3.20)
project(graph NONE)
set(SCRIPTS_DIR scripts)
set(SPLIT_STAMP out/split)
set(MWCCGAP_SOURCES "${CMAKE_SOURCE_DIR}/tools/mwccgap/elf.py")
include(ObjectLists.cmake)
set(objects out/first.cpp.o out/second.cpp.o)
make_object_dirs("${objects}")
foreach(unit first second)
  add_cpp_object(out/${unit}.cpp.o src/${unit}.cpp)
endforeach()
add_custom_target(objects DEPENDS ${objects})
''')

            def run(*args):
                result = subprocess.run(args, cwd=root, text=True, capture_output=True)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                return result.stdout

            run('cmake', '-S', '.', '-B', 'out', '-G', 'Ninja')
            run('cmake', '--build', 'out', '--target', 'objects')
            self.assertNotIn('CC src/', run('ninja', '-C', 'out', '-n', 'objects'))
            for tool in ('objdiff_data', 'lcf'):
                with self.subTest(tool=tool):
                    time.sleep(0.01)
                    write(f'scripts/build/{tool}.py', tool + ' changed')
                    pending = run('ninja', '-C', 'out', '-n', 'objects')
                    for unit in ('first', 'second'):
                        self.assertIn(f'CC src/{unit}.cpp', pending)
                    run('cmake', '--build', 'out', '--target', 'objects')
                    expected = b''.join((root / f'scripts/build/{name}.py').read_bytes()
                                        for name in ('objdiff_data', 'lcf'))
                    for unit in ('first', 'second'):
                        self.assertEqual((root / f'out/{unit}.cpp.o').read_bytes(), expected)
                    self.assertNotIn('CC src/', run('ninja', '-C', 'out', '-n', 'objects'))


if __name__ == '__main__':
    unittest.main()
