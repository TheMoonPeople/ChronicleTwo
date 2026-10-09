"""Exercise comparison dependencies and byproducts through CMake and Ninja."""

from pathlib import Path
import inspect
import shutil
import subprocess
import sys
import tempfile
import time
import unittest

import disassemble

ROOT = Path(__file__).resolve().parents[2]


@unittest.skipUnless(shutil.which('cmake') and shutil.which('ninja'), 'CMake and Ninja required')
class ObjdiffGraphFixture(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for name in ('main.yaml', 'main.symbols.txt', 'include/macro.inc', 'compiler/mwccps2.exe',
                     'scripts/build/layout.py', 'scripts/build/objdiff_data.py',
                     'scripts/build/postprocess_object.py', 'scripts/build/disassemble.py',
                     'scripts/build/lcf.py',
                     'rom/SCES_511.90', 'tools/mwccgap/elf.py'):
            self.write(name, '')
        self.write('scripts/build/source_cuts.py', (ROOT / 'scripts/build/source_cuts.py').read_text())
        self.write('scripts/build/disassemble.py',
                   'import re\nINVENTED = re.compile(r"\\bD_([0-9A-F]{8})\\b")\n'
                   + inspect.getsource(disassemble.source_addresses))
        for unit in ('first', 'second'):
            self.write(f'src/{unit}.cpp', '')
            self.write(f'asm/{unit}.s', '')
        self.write('scripts/build/prepare_objdiff_target.py', '')
        self.write('scripts/build/satansfiddle-wibo.py',
                   'import pathlib,sys\np=pathlib.Path(sys.argv[sys.argv.index("-o")+1]);p.write_bytes(b"base")\n')
        self.write('assemble.py',
                   'import pathlib,sys,time\ntime.sleep(0.1)\np=pathlib.Path(sys.argv[sys.argv.index("-o")+1]);p.write_bytes(b"target")\n')
        self.write('scripts/build/objdiff_config.py', '''import pathlib,sys
out=pathlib.Path(sys.argv[sys.argv.index('-o')+1])
for unit in ('first','second'):
    for kind,suffix in (('base','cpp.o'),('target','s.o')):
        raw=pathlib.Path(f'out/objdiff/{kind}/{unit}.{suffix}')
        assert raw.is_file(), f'missing raw object: {raw}'
        copy=pathlib.Path(f'out/objdiff/compare/{kind}/{unit}.{suffix}')
        copy.parent.mkdir(parents=True,exist_ok=True)
        copy.write_bytes(raw.read_bytes())
        copy.with_suffix(copy.suffix+'.json').write_text('{}')
out.write_text('{}')
''')
        self.write('Objdiff.cmake', (ROOT / 'ps2/cmake/Objdiff.cmake').read_text())
        self.write('CMakeLists.txt', f'''cmake_minimum_required(VERSION 3.20)
project(graph NONE)
set(BUILD_DIR out)
set(INCLUDE_DIR include)
set(CONFIG_DIR .)
set(SCRIPTS_DIR scripts)
set(EXTRACTED_ELF rom/SCES_511.90)
set(MWCCGAP_SOURCES "${{CMAKE_SOURCE_DIR}}/tools/mwccgap/elf.py")
set(SPLIT_STAMP out/split)
set(PYTHON "{sys.executable}")
set(AS "{sys.executable}")
set(AS_FLAGS assemble.py)
set(MW_CC_DIR compiler)
set(SATANSFIDDLE none)
set(unit_rows "cpp\tfirst\tsrc/first.cpp\tasm/first.s" "cpp\tsecond\tsrc/second.cpp\tasm/second.s")
function(make_object_dirs objs)
  foreach(obj IN LISTS objs)
    get_filename_component(dir "${{CMAKE_SOURCE_DIR}}/${{obj}}" DIRECTORY)
    file(MAKE_DIRECTORY "${{dir}}")
  endforeach()
endfunction()
add_custom_command(OUTPUT "${{CMAKE_SOURCE_DIR}}/${{SPLIT_STAMP}}"
  COMMAND "${{CMAKE_COMMAND}}" -E touch "${{CMAKE_SOURCE_DIR}}/${{SPLIT_STAMP}}"
  COMMENT "Splitting fixture")
add_custom_target(setup DEPENDS "${{CMAKE_SOURCE_DIR}}/${{SPLIT_STAMP}}")
include(Objdiff.cmake)
''')
        self.run_command('cmake', '-S', '.', '-B', 'out', '-G', 'Ninja')

    def write(self, name, text):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)

    def run_command(self, *command):
        result = subprocess.run(command, cwd=self.root, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result.stdout

    def build(self):
        return self.run_command('cmake', '--build', 'out', '--target', 'objdiff', '--', '-j8')

    def pending(self, target='objdiff'):
        return self.run_command('ninja', '-C', 'out', '-n', target)

    def touch(self, name):
        path = self.root / name
        # Ninja compares mtimes; avoid depending on the filesystem's tick size.
        time.sleep(0.01)
        path.touch()



class ObjdiffGraphTests(ObjdiffGraphFixture):
    def test_parallel_config_waits_for_both_raw_objects(self):
        self.build()
        self.assertEqual((self.root / 'out/objdiff/compare/target/second.s.o').read_bytes(), b'target')

    def build_targets(self):
        # Isolate refresh dependencies from the separate parallel-ordering test.
        self.run_command('ninja', '-C', 'out',
                         str(self.root / 'out/objdiff/target/first.s.o'),
                         str(self.root / 'out/objdiff/target/second.s.o'))

    def test_target_and_preparation_inputs_invalidate_config(self):
        self.build_targets()
        self.build()
        for name in ('out/objdiff/target/first.s.o', 'scripts/build/objdiff_data.py',
                     'scripts/build/postprocess_object.py', 'scripts/build/disassemble.py',
                     'scripts/build/lcf.py',
                     'main.symbols.txt', 'rom/SCES_511.90', 'tools/mwccgap/elf.py'):
            with self.subTest(name=name):
                self.touch(name)
                self.assertIn('Generating objdiff.json', self.pending())
                self.build()

    def test_missing_comparison_objects_and_receipts_are_rebuilt(self):
        self.build_targets()
        self.build()
        for name in ('base/first.cpp.o', 'target/second.s.o',
                     'base/second.cpp.o.json', 'target/first.s.o.json'):
            with self.subTest(name=name):
                path = self.root / 'out/objdiff/compare' / name
                path.unlink()
                self.assertIn('Generating objdiff.json', self.pending())
                self.build()
                self.assertTrue(path.is_file())


if __name__ == '__main__':
    unittest.main()
