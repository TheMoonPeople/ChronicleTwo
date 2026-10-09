"""A comparison cache must change with every proof input and reject damaged receipts."""

import json
from pathlib import Path
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import objdiff_data as d
from mwccgap import elf as mwccgap_elf


class ComparisonCacheTests(unittest.TestCase):
    def test_inputs_and_output_hash_control_cache_reuse(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, cpp, output = root / 'raw.o', root / 'unit.cpp', root / 'comparison.o'
            source.write_bytes(b'raw')
            cpp.write_text('source')
            ctx = NS(fingerprint='tools', layout=NS(source=lambda unit: cpp))
            compiled = NS(sections=[], relocations=[], symtab=NS(symbols=[]), pack=lambda: b'prepared')
            with patch.object(d.p, 'Elf', return_value=compiled), patch.object(d.p, 'name_sections'), \
                 patch.object(d, 'prepare_native_data') as prepare:
                def copy():
                    d.comparison_copy(source, output, 'unit', ctx, True)
                copy()
                copy()
                self.assertEqual(prepare.call_count, 1)
                source.write_bytes(b'changed raw')
                copy()
                self.assertEqual(prepare.call_count, 2)
                cpp.write_text('changed source')
                copy()
                self.assertEqual(prepare.call_count, 3)
                ctx.fingerprint = 'changed tools and cuts'
                copy()
                self.assertEqual(prepare.call_count, 4)
                output.write_bytes(b'damaged')
                copy()
                self.assertEqual(prepare.call_count, 5)
                self.assertEqual(output.read_bytes(), b'prepared')
                receipt = output.with_suffix('.o.json')
                saved = json.loads(receipt.read_text())
                saved['input'] = 'stale'
                receipt.write_text(json.dumps(saved))
                copy()
                self.assertEqual(prepare.call_count, 6)
                self.assertEqual(source.read_bytes(), b'changed raw')

    def test_moving_bytes_between_raw_and_source_invalidates_the_copy(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, cpp, output = root / 'raw.o', root / 'unit.cpp', root / 'comparison.o'
            source.write_bytes(b'raw')
            cpp.write_bytes(b'tools source')
            ctx = NS(fingerprint='tools', layout=NS(source=lambda unit: cpp))
            compiled = NS(sections=[], relocations=[], symtab=NS(symbols=[]), pack=lambda: b'prepared')
            with patch.object(d.p, 'Elf', return_value=compiled), patch.object(d.p, 'name_sections'), \
                 patch.object(d, 'prepare_native_data') as prepare:
                d.comparison_copy(source, output, 'unit', ctx, True)
                source.write_bytes(b'rawtools')
                cpp.write_bytes(b' source')
                d.comparison_copy(source, output, 'unit', ctx, True)
                self.assertEqual(prepare.call_count, 2)

    def test_malformed_receipt_is_rebuilt_from_raw_inputs(self):
        for damaged in ('invalid json', '[]', 'null'):
            with self.subTest(damaged=damaged), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                source, cpp, output = root / 'raw.o', root / 'unit.cpp', root / 'comparison.o'
                source.write_bytes(b'raw')
                cpp.write_text('')
                output.write_bytes(b'stale')
                output.with_suffix('.o.json').write_text(damaged)
                ctx = NS(fingerprint='tools', layout=NS(source=lambda unit: cpp))
                compiled = NS(sections=[], relocations=[], symtab=NS(symbols=[]), pack=lambda: b'prepared')
                with patch.object(d.p, 'Elf', return_value=compiled), patch.object(d.p, 'name_sections'), \
                     patch.object(d, 'prepare_native_data') as prepare:
                    d.comparison_copy(source, output, 'unit', ctx, True)
                self.assertEqual(output.read_bytes(), b'prepared')
                self.assertEqual(prepare.call_count, 1)
                self.assertEqual(source.read_bytes(), b'raw')


class ContextFingerprintTests(unittest.TestCase):
    def test_fingerprint_inputs_have_unambiguous_component_boundaries(self):
        contents = {Path(d.__file__): b'a', Path(d.p.__file__): b'bc'}
        pieces = NS(defined=lambda: [])
        with patch.object(d.layout, 'Layout'), patch.object(d.layout, 'read_symbols', return_value=[]), \
             patch.object(d.layout, 'Retail'), patch.object(d.disassemble, 'Pieces', return_value=pieces), \
             patch.object(d.lcf, 'Generator'), \
             patch.object(Path, 'read_bytes', autospec=True,
                          side_effect=lambda path: contents.get(path, b'other')):
            first = d.Context().fingerprint
            contents[Path(d.__file__)] = b'ab'
            contents[Path(d.p.__file__)] = b'c'
            self.assertNotEqual(d.Context().fingerprint, first)

    def test_elf_reader_and_global_cuts_are_proof_inputs(self):
        reader = Path(mwccgap_elf.__file__)
        contents = [b'first reader']
        defined = [[(0x3000, 'D_00003000')]]
        pieces = NS(defined=lambda: defined[0])
        with patch.object(d.layout, 'Layout'), patch.object(d.layout, 'read_symbols', return_value=[]), \
             patch.object(d.layout, 'Retail'), patch.object(d.disassemble, 'Pieces', return_value=pieces), \
             patch.object(d.lcf, 'Generator'):
            # Autospec exposes the actual file path to the fingerprint read.
            with patch.object(Path, 'read_bytes', autospec=True,
                              side_effect=lambda path: contents[0] if path == reader else b'other'):
                first = d.Context().fingerprint
                self.assertEqual(d.Context().fingerprint, first)
                contents[0] = b'changed reader'
                second = d.Context().fingerprint
                self.assertNotEqual(second, first)
                defined[0] = [(0x3000, 'D_00003000'), (0x3004, 'D_00003004')]
                self.assertNotEqual(d.Context().fingerprint, second)


if __name__ == '__main__':
    unittest.main()
