"""Data padding must preserve object sizes and referenced retail boundaries."""
from types import SimpleNamespace
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import postprocess_object as p
import objdiff_data as d
from mwccgap.elf import BssSection, Section
from test_objdiff_data import elf, record, symbol


class AlignmentFragmentTests(unittest.TestCase):
    def fixture(self, nobits=False):
        kind = '.bss' if nobits else '.data'
        section_type = p.SHT_NOBITS if nobits else p.SHT_PROGBITS
        cls = BssSection if nobits else Section
        def data(size):
            entry = cls(0, section_type, 3, 0, 0, size, 0, 0, 16, 0, bytes(size))
            entry.name = kind
            return entry
        code = Section(0, 1, 6, 0, 0, 4, 0, 0, 4, 0, b'CODE')
        code.name = '.text'
        compiled = elf([Section(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, b''),
                        code, data(24), data(12)],
                       [symbol('caller', 1, 4, info=0x12),
                        symbol('first', 2, 24, info=0x11),
                        symbol('following', 3, 12, info=0x11),
                        symbol('D_0000301C')], [record(1, [(0, 6, 3)])])
        compiled.e_shstrndx = compiled.symtab_index = 0
        compiled.sections[0].name = ''
        compiled.relocations[0].name = '.rel.text'
        compiled.sections.extend(compiled.relocations)
        def add_section(section):
            compiled.sections.append(section)
            return len(compiled.sections) - 1
        compiled.add_section = add_section
        run = [('first', 0x3000, 0x301c), ('D_0000301C', 0x301c, 0x3020),
               ('following', 0x3020, 0x3030)]
        pieces = SimpleNamespace(unit=lambda unit: [(kind, run)])
        ctx = SimpleNamespace(pieces=pieces, literal_pieces=pieces,
                              addresses={'caller': 0x1000, 'first': 0x3000,
                                         'D_0000301C': 0x301c, 'following': 0x3020},
                              rows=[(0x3000, 'first', 24, False),
                                    (0x3020, 'following', 12, False)],
                              retail=SimpleNamespace(bytes=lambda lo, hi: bytes(hi - lo),
                                                     relocations={}),
                              ranges=lambda unit: {kind: (0x3000, 0x302c, 0x3030)})
        return compiled, ctx

    def prepare(self, compiled, ctx, source='', literal_padding=None):
        with tempfile.TemporaryDirectory() as directory:
            cpp = Path(directory) / 'owner.cpp'
            cpp.write_text(source)
            ctx.layout = SimpleNamespace(source=lambda unit: cpp,
                                          sections=lambda unit: [(ctx.pieces.unit('')[0][0],
                                                                  0x3000, 0x3030)])
            with patch.object(p, 'name_literal_data', side_effect=literal_padding), \
                 patch.object(p, 'bind_suffixed_references'), \
                 patch.object(p, 'retail_sections', side_effect=lambda obj, *args:
                              {index: section.name for index, section in enumerate(obj.sections)
                               if section.sh_flags & p.SHF_ALLOC}):
                d.prepare_native_data(compiled, 'owner', ctx)

    def test_native_alignment_owns_separately_referenced_zero_fragment(self):
        for nobits in (False, True):
            with self.subTest(nobits=nobits):
                compiled, ctx = self.fixture(nobits)
                before = d.code_snapshot(compiled)
                self.prepare(compiled, ctx)
                label = compiled.symtab.symbols[3]
                self.assertGreater(label.st_shndx, 0)
                self.assertEqual(label.type, 0)
                self.assertEqual(p.section_size(compiled.sections[label.st_shndx]), 4)
                self.assertEqual(d.code_snapshot(compiled), before)

    def test_literal_prefix_padding_keeps_original_extent_evidence(self):
        for padding in (bytes(4), b'FAIL', bytes(8)):
            with self.subTest(padding=padding):
                compiled, ctx = self.fixture()
                def extend(*args, **kwargs):
                    compiled.sections[2].data += padding
                    compiled.symtab.symbols[1].st_size += len(padding)
                self.prepare(compiled, ctx, literal_padding=extend)
                label = compiled.symtab.symbols[3]
                self.assertEqual(label.st_shndx > 0, padding == bytes(4))

    def test_alignment_can_have_multiple_canonical_reference_cuts(self):
        compiled, ctx = self.fixture()
        run = ctx.pieces.unit('')[0][1]
        run[0] = ('first', 0x3000, 0x301a)
        run.insert(1, ('D_0000301A', 0x301a, 0x301c))
        ctx.addresses['D_0000301A'] = 0x301a
        self.prepare(compiled, ctx)
        for name, size in (('D_0000301A', 2), ('D_0000301C', 4)):
            _index, label = compiled.symtab.get_symbol_by_name(name)
            self.assertEqual(p.section_size(compiled.sections[label.st_shndx]), size)

    def test_held_alignment_marker_supplies_no_native_credit(self):
        compiled, ctx = self.fixture()
        self.prepare(compiled, ctx, 'INCLUDE_RODATA("dir", D_0000301C__DATA);')
        self.assertEqual(compiled.symtab.symbols[3].st_shndx, 0)

    def test_native_alignment_evidence_fails_closed(self):
        for invalid in ('left_size', 'right_size', 'left_alias', 'right_alias', 'left_offset',
                        'alignment', 'small_alignment', 'wrong_alignment', 'left_type',
                        'right_type', 'flags', 'nonzero', 'short_bytes', 'retail_relocation',
                        'native_relocation', 'declared_boundary', 'live_boundary', 'duplicate_boundary',
                        'unknown_boundary', 'noncontiguous', 'terminal', 'missing_right', 'held_left',
                        'held_right', 'left_placeholder', 'right_placeholder'):
            with self.subTest(invalid=invalid):
                compiled, ctx = self.fixture()
                source = ''
                if invalid == 'left_size': ctx.rows[0] = (0x3000, 'first', 20, False)
                elif invalid == 'right_size': ctx.rows[1] = (0x3020, 'following', 8, False)
                elif invalid.endswith('_alias'):
                    compiled.symtab.symbols.append(symbol('alias', 2 if invalid == 'left_alias' else 3))
                elif invalid == 'left_offset': compiled.symtab.symbols[1].st_value = 4
                elif invalid == 'alignment': compiled.sections[3].sh_addralign = 3
                elif invalid == 'small_alignment': compiled.sections[3].sh_addralign = 4
                elif invalid == 'wrong_alignment': compiled.sections[2].sh_addralign = 0x100
                elif invalid == 'left_type': compiled.symtab.symbols[1].type = 0
                elif invalid == 'right_type': compiled.symtab.symbols[2].type = 0
                elif invalid == 'flags': compiled.sections[2].sh_flags = 2
                elif invalid == 'nonzero': ctx.retail.bytes = lambda lo, hi: b'X' * (hi - lo)
                elif invalid == 'short_bytes': ctx.retail.bytes = lambda lo, hi: bytes(hi - lo - 1)
                elif invalid == 'retail_relocation': ctx.retail.relocations[0x301c] = 2
                elif invalid == 'native_relocation':
                    entry = record(2, [(28, 2, 2)])
                    entry.name = '.rel.data'
                    compiled.sections.append(entry)
                    compiled.relocations.append(entry)
                elif invalid == 'declared_boundary': ctx.rows.append((0x301c, 'D_0000301C', 0, False))
                elif invalid == 'live_boundary': compiled.symtab.symbols[3].st_shndx = 2
                elif invalid == 'duplicate_boundary': compiled.symtab.symbols.append(symbol('D_0000301C'))
                elif invalid in ('unknown_boundary', 'noncontiguous', 'terminal'):
                    run = ctx.pieces.unit('')[0][1]
                    if invalid == 'unknown_boundary': run[1] = ('unknown', 0x301c, 0x3020)
                    elif invalid == 'noncontiguous': run[1] = ('D_0000301C', 0x301d, 0x3020)
                    else: run.pop()
                elif invalid == 'missing_right': compiled.symtab.symbols[2].st_shndx = 0
                elif invalid in ('held_left', 'held_right'):
                    source = 'INCLUDE_BSS(%s, 0x18);' % ('first' if invalid == 'held_left' else 'following')
                else:
                    index = 1 if invalid == 'left_placeholder' else 2
                    compiled.symtab.symbols[index].name += '__DATA'
                before = d.code_snapshot(compiled)
                self.prepare(compiled, ctx, source)
                self.assertEqual(compiled.symtab.symbols[3].st_shndx,
                                 2 if invalid == 'live_boundary' else 0)
                self.assertEqual(d.code_snapshot(compiled), before)


class BssReservationCutTests(unittest.TestCase):
    def fixture(self):
        rows = [(0x3000, 'object', 24, False), (0x3020, 'following', 4, False)]
        run = [('object', 0x3000, 0x301a), ('D_0000301A', 0x301a, 0x301c),
               ('D_0000301C', 0x301c, 0x3020), ('following', 0x3020, 0x3024)]
        section = SimpleNamespace(name='.bss', sh_type=p.SHT_NOBITS, sh_size=24, data=b'',
                                  sh_flags=p.FLAGS['.bss'], sh_addralign=16)
        sym = SimpleNamespace(name='object', type=p.STT_OBJECT, st_value=0,
                              st_shndx=1, st_size=24)
        following = SimpleNamespace(name='.bss', sh_type=p.SHT_NOBITS, sh_size=4, data=b'',
                                    sh_flags=p.FLAGS['.bss'], sh_addralign=16)
        next_sym = SimpleNamespace(name='following', type=p.STT_OBJECT, st_value=0,
                                   st_shndx=2, st_size=4)
        compiled = SimpleNamespace(sections=[None, section, following],
                                   symtab=SimpleNamespace(symbols=[sym, next_sym]))
        return compiled, section, rows, run

    def apply(self, compiled, rows, run):
        with patch.object(p.layout, 'section_of', return_value='.bss'):
            p.pad_data(compiled, 'unit', set(), rows=rows,
                       pieces=SimpleNamespace(unit=lambda unit: [('.bss', run)]),
                       retail=SimpleNamespace(relocations={}))

    def test_alignment_proof_crosses_canonical_cuts_without_absorbing_them(self):
        compiled, section, rows, run = self.fixture()
        self.apply(compiled, rows, run)
        self.assertEqual(section.sh_size, 26)
        self.assertEqual(compiled.symtab.symbols[0].st_size, 24)
        self.assertEqual(run[1:], [('D_0000301A', 0x301a, 0x301c),
                                  ('D_0000301C', 0x301c, 0x3020),
                                  ('following', 0x3020, 0x3024)])

    def test_incomplete_gap_proofs_cannot_reserve_an_unaligned_cut(self):
        for invalid in ('unknown', 'noncontiguous', 'backwards', 'declared', 'terminal', 'unaligned'):
            with self.subTest(invalid=invalid):
                compiled, section, rows, run = self.fixture()
                if invalid == 'unknown': run[1] = ('unknown', 0x301a, 0x301c)
                elif invalid == 'noncontiguous': run[1] = ('D_0000301B', 0x301b, 0x301c)
                elif invalid == 'backwards': run[1] = ('D_0000301A', 0x301a, 0x3018)
                elif invalid == 'declared': rows.append((0x301a, 'D_0000301A', 0, False))
                elif invalid == 'terminal': run.pop()
                else:
                    run[2] = ('D_0000301C', 0x301c, 0x3024)
                    run[3] = ('following', 0x3024, 0x3028)
                    rows[1] = (0x3024, 'following', 4, False)
                self.apply(compiled, rows, run)
                self.assertEqual(section.sh_size, 24)


class DataPaddingTests(unittest.TestCase):
    def run_padding(self, size=12, declared=12, end=16, nobits=True, tail=b"\0" * 4,
                    terminal=False, section_name=None, retail_name=None, placeholder=False, relocations=(),
                    next_alignment=16):
        section = SimpleNamespace(sh_type=p.SHT_NOBITS if nobits else 1,
                                  sh_size=size, data=b"x" * size,
                                  name=section_name or (".bss" if nobits else ".data"))
        symbol = SimpleNamespace(type=p.STT_OBJECT, st_value=0, st_shndx=1,
                                 name="object", st_size=size)
        elf = SimpleNamespace(sections=[None, section],
                              symtab=SimpleNamespace(symbols=[symbol]))
        section.sh_flags = p.FLAGS[section.name]
        section.sh_addralign = 4
        rows = [(0, "object", declared, False)]
        run = [("object", 0, end)]
        if not terminal:
            run.append(("following", end, end + 4))
            following = SimpleNamespace(name=section.name, sh_type=section.sh_type,
                                        sh_flags=section.sh_flags, sh_addralign=next_alignment,
                                        sh_size=4, data=bytes(4))
            next_sym = SimpleNamespace(name="following", type=p.STT_OBJECT, st_value=0,
                                       st_shndx=2, st_size=4)
            elf.sections.append(following)
            elf.symtab.symbols.append(next_sym)
            rows.append((end, "following", 4, False))
        kind = retail_name or section.name
        pieces = SimpleNamespace(unit=lambda unit: [(kind, run)])
        retail = SimpleNamespace(bytes=lambda start, end: tail, relocations=dict.fromkeys(relocations, 2))
        with patch.object(p.layout, "section_of", return_value=kind), \
             patch.object(p.disassemble, "Pieces", return_value=pieces), \
             patch.object(p.layout, "Retail", return_value=retail), \
             patch.object(p.layout, "read_symbols", return_value=rows):
            placeholders = {1} if placeholder else set()
            p.pad_data(elf, "test", placeholders)
            once = p.section_size(section)
            p.pad_data(elf, "test", placeholders)
            self.assertEqual(p.section_size(section), once)
        return once

    def test_exact_object_acquires_only_its_piece_tail(self):
        self.assertEqual(self.run_padding(), 16)
        self.assertEqual(self.run_padding(end=14, nobits=False, tail=b"\0" * 2), 14)

    def test_wrong_object_size_is_not_hidden(self):
        self.assertEqual(self.run_padding(size=8), 8)
        self.assertEqual(self.run_padding(size=13), 13)

    def test_bss_reservations_require_bounded_original_next_alignment(self):
        self.assertEqual(self.run_padding(size=4, declared=4, end=64), 4)
        self.assertEqual(self.run_padding(size=4, declared=4, end=64, next_alignment=64), 64)
        self.assertEqual(self.run_padding(size=4, declared=4, end=52), 4)
        self.assertEqual(self.run_padding(size=4, declared=4, end=8192), 4)
        for end in (256, 4096):
            with self.subTest(end=end):
                self.assertEqual(self.run_padding(size=4, declared=4, end=end), 4)
        self.assertEqual(self.run_padding(end=14), 12)
        self.assertEqual(self.run_padding(end=32), 12)
        self.assertEqual(self.run_padding(end=28), 12)
        self.assertEqual(self.run_padding(end=28, nobits=False), 12)
        self.assertEqual(self.run_padding(end=8), 12)
        self.assertEqual(self.run_padding(size=8, end=52), 8)
        self.assertEqual(self.run_padding(end=52, declared=0), 12)
        self.assertEqual(self.run_padding(end=52, terminal=True), 12)

    def test_referenced_boundary_limits_the_bss_piece(self):
        rows = [(0x3000, "object", 4, False), (0x3040, "following", 4, False)]
        lay = SimpleNamespace(sections=lambda unit: [(".bss", 0x3000, 0x3044)])
        symbols = SimpleNamespace(rows=rows,
                                  within=lambda lo, hi: [row for row in rows if lo <= row[0] < hi])
        pieces = p.disassemble.Pieces(lay=lay, symbols=symbols, references=[0x3020])
        section = SimpleNamespace(name=".bss", sh_type=p.SHT_NOBITS, sh_size=4, data=b"",
                                  sh_flags=p.FLAGS['.bss'], sh_addralign=4)
        sym = SimpleNamespace(name="object", type=p.STT_OBJECT, st_value=0,
                              st_shndx=1, st_size=4)
        following = SimpleNamespace(name=".bss", sh_type=p.SHT_NOBITS, sh_size=4, data=b"",
                                    sh_flags=p.FLAGS['.bss'], sh_addralign=64)
        next_sym = SimpleNamespace(name="following", type=p.STT_OBJECT, st_value=0,
                                   st_shndx=2, st_size=4)
        compiled = SimpleNamespace(sections=[None, section, following],
                                   symtab=SimpleNamespace(symbols=[sym, next_sym]))
        with patch.object(p.layout, "section_of", return_value=".bss"):
            p.pad_data(compiled, "unit", set(), pieces=pieces, rows=rows,
                       retail=SimpleNamespace(relocations={}))
        self.assertEqual(pieces.unit("unit")[0][1][0], ("object", 0x3000, 0x3020))
        self.assertEqual(section.sh_size, 0x20)

    def test_initialized_tail_must_be_retail_zero(self):
        self.assertEqual(self.run_padding(nobits=False), 16)
        self.assertEqual(self.run_padding(nobits=False, tail=b"\0\0\1\0"), 12)

    def test_terminal_padding_belongs_to_linker(self):
        self.assertEqual(self.run_padding(terminal=True), 12)

    def test_terminal_detection_uses_the_retail_section_kind(self):
        self.assertEqual(self.run_padding(terminal=True, section_name=".sbss",
                                          retail_name=".bss"), 12)

    def test_initialized_padding_cannot_contain_relocation_fields(self):
        self.assertEqual(self.run_padding(nobits=False, relocations=(12,)), 12)

    def test_initialized_padding_requires_the_complete_retail_tail(self):
        self.assertEqual(self.run_padding(nobits=False, tail=b'\0'), 12)

    def test_vtable_padding_uses_the_same_exact_size_policy(self):
        self.assertEqual(self.run_padding(nobits=False, section_name='.vtables'), 16)
        self.assertEqual(self.run_padding(nobits=False, section_name='.vtables', size=8), 8)
        self.assertEqual(self.run_padding(nobits=False, section_name='.vtables',
                                          tail=b'\0\0\1\0'), 12)
        self.assertEqual(self.run_padding(nobits=False, section_name='.vtables',
                                          terminal=True), 12)

    def test_vtable_placeholder_is_not_padded(self):
        self.assertEqual(self.run_padding(nobits=False, section_name='.vtables',
                                          placeholder=True), 12)


if __name__ == "__main__":
    unittest.main()
