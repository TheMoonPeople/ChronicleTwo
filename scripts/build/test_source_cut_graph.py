"""Explicit address cuts must invalidate the split and every dependent unit."""

from pathlib import Path
import unittest

from test_objdiff_graph import ObjdiffGraphFixture

ROOT = Path(__file__).resolve().parents[2]


class SourceCutGraphTests(ObjdiffGraphFixture):
    def setUp(self):
        super().setUp()
        self.write('split.py', '''import pathlib,re,sys
cuts=sorted({name for source in pathlib.Path('src').glob('*.cpp')
             for name in re.findall(r'\\bD_[0-9A-F]{8}\\b', source.read_text())})
pathlib.Path(sys.argv[1]).write_text('\\n'.join(cuts))
''')
        self.write('assemble.py', '''import pathlib,sys
output=pathlib.Path(sys.argv[sys.argv.index('-o')+1])
output.write_bytes(pathlib.Path('out/split').read_bytes())
''')
        cmake = (self.root / 'CMakeLists.txt').read_text()
        cmake = cmake.replace('COMMAND "${CMAKE_COMMAND}" -E touch "${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}"',
                              'COMMAND "${PYTHON}" "${CMAKE_SOURCE_DIR}/split.py" "${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}" WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"')
        self.write('CMakeLists.txt', cmake)
        self.run_command('cmake', '-S', '.', '-B', 'out', '-G', 'Ninja')

    def test_ordinary_edit_rebuilds_only_its_base(self):
        self.write('src/first.cpp', 'void changed_function() {}\n')
        self.build()
        split = self.root / 'out/split'
        other = self.root / 'out/objdiff/target/second.s.o'
        split_time, other_time = split.stat().st_mtime_ns, other.stat().st_mtime_ns
        self.touch('src/first.cpp')
        self.write('src/first.cpp', 'void changed_function() { return; }\n')
        output = self.build()
        self.assertIn('CC (objdiff base) src/first.cpp', output)
        self.assertNotIn('Splitting fixture', output)
        self.assertNotIn('AS (objdiff target)', output)
        self.assertEqual(split.stat().st_mtime_ns, split_time)
        self.assertEqual(other.stat().st_mtime_ns, other_time)

    def test_added_and_removed_cuts_rebuild_other_units_like_a_clean_build(self):
        self.build()
        other = self.root / 'out/objdiff/target/second.s.o'
        self.assertEqual(other.read_bytes(), b'')
        for source, expected in (('int D_0000300C;', b'D_0000300C'), ('', b'')):
            with self.subTest(source=source):
                self.touch('src/first.cpp')
                self.write('src/first.cpp', source)
                self.assertIn('Splitting fixture', self.pending())
                self.build()
                incremental = other.read_bytes()
                self.assertEqual(incremental, expected)
                self.run_command('ninja', '-C', 'out', '-t', 'clean')
                self.build()
                self.assertEqual(other.read_bytes(), incremental)


class SourceClassificationGraphTests(ObjdiffGraphFixture):
    def setUp(self):
        super().setUp()
        # Model splat's output placement; use the real mwccgap preprocessor to
        # prove the linked rule's fallback dependency rather than its bytes.
        self.write('src/first.cpp', 'void restored__Fv() {}\n')
        self.write('split.py', r"""import pathlib, re, shutil, sys
root = pathlib.Path('.')
for kind in ('matchings', 'nonmatchings'):
    shutil.rmtree(root / 'asm' / kind, ignore_errors=True)
for unit in ('first', 'second'):
    text = (root / f'src/{unit}.cpp').read_text()
    fallback = bool(re.search(r'INCLUDE_ASM\([^,]*,\s*restored__Fv\)', text))
    kind = 'nonmatchings' if fallback else 'matchings'
    target = root / f'asm/{kind}/{unit}/restored__Fv.s'
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text('.section .text\nglabel restored__Fv\nnop\n')
pathlib.Path(sys.argv[1]).write_text('split')
""")
        self.write('linked.py', f"""import pathlib, sys
sys.path.insert(0, {str(ROOT / 'tools/mwccgap')!r})
from mwccgap.preprocessor import Preprocessor
source = pathlib.Path(sys.argv[1])
with source.open() as stream:
    Preprocessor(pathlib.Path('.')).preprocess_c_file(stream)
pathlib.Path(sys.argv[2]).write_text('linked')
""")
        cmake = (self.root / 'CMakeLists.txt').read_text()
        cmake = cmake.replace(
            'COMMAND "${CMAKE_COMMAND}" -E touch "${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}"',
            'COMMAND "${PYTHON}" "${CMAKE_SOURCE_DIR}/split.py" "${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}" WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"')
        cmake += """
add_custom_command(OUTPUT "${CMAKE_SOURCE_DIR}/out/linked.cpp.o"
    COMMAND "${PYTHON}" "${CMAKE_SOURCE_DIR}/linked.py" src/first.cpp out/linked.cpp.o
    DEPENDS "${CMAKE_SOURCE_DIR}/src/first.cpp" "${CMAKE_SOURCE_DIR}/${SPLIT_STAMP}"
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
add_custom_target(linked_fixture DEPENDS "${CMAKE_SOURCE_DIR}/out/linked.cpp.o")
"""
        self.write('CMakeLists.txt', cmake)
        self.run_command('cmake', '-S', '.', '-B', 'out', '-G', 'Ninja')

    def linked_build(self):
        return self.run_command('cmake', '--build', 'out', '--target', 'linked_fixture', '--', '-j8')

    def test_restoring_and_removing_fallback_without_address_cuts(self):
        self.linked_build()
        matching = self.root / 'asm/matchings/first/restored__Fv.s'
        fallback = self.root / 'asm/nonmatchings/first/restored__Fv.s'
        self.assertTrue(matching.is_file())
        self.assertFalse(fallback.is_file())
        self.touch('src/first.cpp')
        self.write('src/first.cpp', 'INCLUDE_ASM("asm/nonmatchings/first", restored__Fv);\n')
        self.assertIn('Splitting fixture', self.linked_build())
        self.assertTrue(fallback.is_file())
        self.assertFalse(matching.is_file())
        self.touch('src/first.cpp')
        self.write('src/first.cpp', 'void restored__Fv() {}\n')
        self.assertIn('Splitting fixture', self.linked_build())
        self.assertTrue(matching.is_file())
        self.assertFalse(fallback.is_file())

    def test_body_and_comment_edits_keep_classification_timestamp(self):
        self.linked_build()
        before = (self.root / 'out/split').stat().st_mtime_ns
        self.touch('src/first.cpp')
        self.write('src/first.cpp', 'void restored__Fv() { return; }\n// INCLUDE_ASM("asm/nonmatchings/first", restored__Fv);\n')
        self.assertNotIn('Splitting fixture', self.linked_build())
        self.assertEqual((self.root / 'out/split').stat().st_mtime_ns, before)


class SourceClassificationTests(unittest.TestCase):
    def signature(self, text):
        from source_cuts import source_split_signature
        return source_split_signature(text)

    def test_source_classifier_tracks_the_pinned_splat_contract(self):
        self.assertEqual(self.signature('void first() {}\nstatic int second(int arg) { return arg; }\n'),
                         (['first', 'second'], [], []))
        self.assertEqual(self.signature('/* INCLUDE_ASM("dir", comment); */\n'
                                        '// INCLUDE_RODATA("dir", comment);\n'
                                        'INCLUDE_ASM("dir", function);\n'
                                        'INCLUDE_RODATA("dir", datum);\n'),
                         ([], ['function'], ['datum']))
        # splat preserves strings in this classification pass.
        self.assertEqual(self.signature('const char *s = "INCLUDE_ASM(dir, literal)";\n'),
                         ([], ['literal'], []))

    def test_marker_order_and_duplicates_keep_the_same_signature(self):
        first = 'INCLUDE_ASM("dir", a);\nINCLUDE_ASM("dir", b);\n'
        second = 'INCLUDE_ASM("dir", b);\nINCLUDE_ASM("dir", a);\nINCLUDE_ASM("dir", a);\n'
        self.assertEqual(self.signature(first), self.signature(second))


if __name__ == '__main__':
    unittest.main()
