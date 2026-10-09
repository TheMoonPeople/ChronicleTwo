"""Data callbacks may retain verified local identities without rewriting code."""

from pathlib import Path
import struct
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import objdiff_data as d
from mwccgap.elf import Section
from test_objdiff_data import elf, record, symbol


class DataCallbackTests(unittest.TestCase):
    def fixture(self):
        def section(name, flags, data):
            result = Section(0, 1, flags, 0, 0, len(data), 0, 0, 4, 0, data)
            result.name = name
            return result
        callback = struct.pack('<I', 0x03e00008)
        caller = struct.pack('<I', 0x0c000000)
        code_retail = struct.pack('<I', 0x0c000400)
        compiled = elf([section('', 0, b''), section('.text', 6, callback),
                        section('.text', 6, caller), section('.data', 3, bytes(4))],
                       [symbol('helper__Fv', 1, 4, info=2),
                        symbol('caller', 2, 4, info=0x12),
                        symbol('table', 3, 4, info=0x11)],
                       [record(2, [(0, 4, 0)]), record(3, [(0, 2, 0)])])
        compiled.e_shstrndx = compiled.symtab_index = 0
        for entry in compiled.relocations:
            entry.name = '.rel' + compiled.sections[entry.sh_info].name
        compiled.sections.extend(compiled.relocations)
        spans = {0x1000: callback, 0x2000: code_retail, 0x3000: struct.pack('<I', 0x1000)}
        retail = NS(bytes=lambda lo, hi: spans.get(lo, b'')[:hi - lo],
                    word=lambda address: int.from_bytes(spans[address], 'little'),
                    relocations={0x2000: 4, 0x3000: 2})
        runs = [('.text', [('helper__Fv__2', 0x1000, 0x1004), ('caller', 0x2000, 0x2004)]),
                ('.data', [('table', 0x3000, 0x3004)])]
        rows = [(0x1000, 'helper__Fv__2', 4, True), (0x2000, 'caller', 4, True),
                (0x3000, 'table', 4, False), (0x5000, 'helper__Fv', 4, True)]
        ctx = NS(retail=retail, pieces=NS(unit=lambda unit: runs),
                 rows=rows, addresses={name: address for address, name, _size, _function in rows},
                 ranges=lambda unit: {'.data': (0x3000, 0x3004, 0x3004)})
        ctx.literal_pieces = ctx.pieces
        return compiled, ctx

    def prepare(self, compiled, ctx, source=''):
        with tempfile.TemporaryDirectory() as directory:
            cpp = Path(directory) / 'owner.cpp'
            cpp.write_text(source)
            ctx.layout = NS(source=lambda unit: cpp, kinds={'owner': 'cpp'},
                            sections=lambda unit: [('.text', 0x1000, 0x2004),
                                                   ('.data', 0x3000, 0x3004)])
            with patch.object(d.p, 'name_literal_data'), \
                 patch.object(d.p.layout, 'Layout', return_value=ctx.layout), \
                 patch.object(d.p.layout, 'read_symbols', return_value=ctx.rows), \
                 patch.object(d.p, 'retail_sections', side_effect=lambda obj, *args:
                              {index: section.name for index, section in enumerate(obj.sections)
                               if section.sh_flags & d.p.SHF_ALLOC}):
                d.prepare_native_data(compiled, 'owner', ctx)

    def test_local_callback_keeps_canonical_data_identity_and_original_code(self):
        compiled, ctx = self.fixture()
        before = d.code_snapshot(compiled)
        self.prepare(compiled, ctx)
        target = compiled.symtab.symbols[compiled.relocations[1].relocations[0].symbol_index]
        self.assertEqual(target.name, 'helper__Fv__2')
        self.assertEqual((target.st_shndx, target.st_value, target.st_size), (0, 0, 0))
        self.assertEqual(compiled.symtab.symbols[0].name, 'helper__Fv')
        self.assertEqual(d.code_snapshot(compiled), before)

    def test_callback_alias_requires_complete_native_and_retail_evidence(self):
        for invalid in ('body', 'extent', 'global', 'callback_alias', 'duplicate_callback',
                        'canonical_address', 'canonical_row', 'canonical_size', 'retail_kind',
                        'native_kind', 'duplicate_site', 'native_addend', 'interior', 'target',
                        'data_size', 'data_alias', 'unknown_owner', 'owner_address', 'owner_kind',
                        'competing_alias', 'duplicate_alias', 'ambiguous_suffix', 'local_plain'):
            with self.subTest(invalid=invalid):
                compiled, ctx = self.fixture()
                pointer = compiled.relocations[1].relocations[0]
                if invalid == 'body': compiled.sections[1].data = bytes(4)
                elif invalid == 'extent': compiled.symtab.symbols[0].st_size = 8
                elif invalid == 'global': compiled.symtab.symbols[0].bind = 1
                elif invalid == 'callback_alias': compiled.symtab.symbols.append(symbol('alias', 1, 4, info=2))
                elif invalid == 'duplicate_callback': compiled.symtab.symbols.append(symbol('helper__Fv', 2, 4, info=2))
                elif invalid == 'canonical_address': ctx.addresses['helper__Fv__2'] = 0x5000
                elif invalid == 'canonical_row': ctx.rows.append(ctx.rows[0])
                elif invalid == 'canonical_size': ctx.rows[0] = (0x1000, 'helper__Fv__2', 8, True)
                elif invalid == 'retail_kind': ctx.retail.relocations[0x3000] = 4
                elif invalid == 'native_kind': pointer.reloc_type = 4
                elif invalid == 'duplicate_site': compiled.relocations[1].relocations.append(pointer)
                elif invalid == 'native_addend': compiled.sections[3].data = struct.pack('<I', 4)
                elif invalid == 'interior': pointer.r_offset = 4
                elif invalid == 'target':
                    ctx.retail.word = lambda address: 0x5000 if address == 0x3000 else 0x0c000400
                elif invalid == 'data_size': ctx.rows[2] = (0x3000, 'table', 8, False)
                elif invalid == 'data_alias': compiled.symtab.symbols.append(symbol('alias', 3, 4, info=0x11))
                elif invalid == 'unknown_owner': compiled.symtab.symbols[2].name = 'unknown'
                elif invalid == 'owner_address': ctx.addresses['table'] = 0x4000
                elif invalid == 'owner_kind': ctx.rows[2] = (0x3000, 'table', 4, True)
                elif invalid == 'competing_alias': compiled.symtab.symbols.append(symbol('helper__Fv__2', 3, 4, info=0x11))
                elif invalid == 'duplicate_alias':
                    compiled.symtab.symbols.extend([symbol('helper__Fv__2'), symbol('helper__Fv__2')])
                elif invalid == 'ambiguous_suffix': ctx.rows.append((0x1010, 'helper__Fv__3', 4, True))
                else: ctx.rows.append((0x1020, 'helper__Fv', 4, True))
                before = d.code_snapshot(compiled)
                self.prepare(compiled, ctx)
                self.assertEqual(pointer.symbol_index, 0)
                self.assertEqual(d.code_snapshot(compiled), before)

    def test_existing_undefined_canonical_alias_is_reused(self):
        compiled, ctx = self.fixture()
        compiled.symtab.symbols.append(symbol('helper__Fv__2'))
        self.prepare(compiled, ctx)
        self.assertEqual(compiled.relocations[1].relocations[0].symbol_index, 3)
        self.assertEqual(len(compiled.symtab.symbols), 4)

    def test_held_callback_table_keeps_no_native_storage_or_alias(self):
        compiled, ctx = self.fixture()
        before = d.code_snapshot(compiled)
        self.prepare(compiled, ctx, 'INCLUDE_RODATA("dir", table__DATA);')
        self.assertEqual(compiled.symtab.symbols[2].st_shndx, 0)
        self.assertFalse(any(symbol.name == 'helper__Fv__2' for symbol in compiled.symtab.symbols))
        self.assertEqual(d.code_snapshot(compiled), before)


if __name__ == '__main__':
    unittest.main()
