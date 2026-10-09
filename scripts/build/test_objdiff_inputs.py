"""Missing raw inputs must never expose raw or stale data comparisons."""

from pathlib import Path
import re
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch

import objdiff_config as c


class ObjdiffInputTests(unittest.TestCase):
    def test_missing_base_or_target_rejects_stale_comparisons(self):
        for missing in ('base', 'target'):
            with self.subTest(missing=missing), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                for kind, suffix in (('base', 'cpp.o'), ('target', 's.o')):
                    raw = root / f'out/objdiff/{kind}/unit.{suffix}'
                    raw.parent.mkdir(parents=True)
                    if kind != missing:
                        raw.write_bytes(b'raw')
                    stale = root / f'out/objdiff/compare/{kind}/unit.{suffix}'
                    stale.parent.mkdir(parents=True)
                    stale.write_bytes(b'stale')
                lay = NS(units=lambda kind: ['unit'], source=lambda unit: 'unit.cpp')
                with patch.object(c, 'ROOT', root), \
                     patch.object(c.layout, 'Layout', return_value=lay), \
                     patch.object(c.layout, 'read_symbols', return_value=[]), \
                     patch.object(c.objdiff_data, 'Context'), patch.object(c, 'object_mappings', return_value={}):
                    with self.assertRaisesRegex(FileNotFoundError, 'unit'):
                        c.config('out')

    def test_data_sections_are_explicitly_combined_for_aggregate_scores(self):
        lay = NS(units=lambda kind: [])
        with patch.object(c.layout, 'Layout', return_value=lay), \
             patch.object(c.layout, 'read_symbols', return_value=[]), \
             patch.object(c.objdiff_data, 'Context'):
            config = c.config('out')
            self.assertIs(config['options'].get('combineDataSections'), True)
            version = re.fullmatch(r'(\d+)\.(\d+)\.(\d+)(?:[-+].*)?', config['min_version'])
            self.assertIsNotNone(version)
            self.assertGreaterEqual(tuple(map(int, version.groups())), (3, 7, 3),
                                    'Data comparison requires the validated combineDataSections CLI')

    def test_failed_refresh_removes_the_old_config(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / 'objdiff.json'
            output.write_text('stale')
            with patch('sys.argv', ['objdiff_config.py', '-o', str(output)]), \
                 patch.object(c.os, 'chdir'), \
                 patch.object(c, 'config', side_effect=FileNotFoundError('missing raw object')):
                with self.assertRaises(FileNotFoundError):
                    c.main()
            self.assertFalse(output.exists())


if __name__ == '__main__':
    unittest.main()
