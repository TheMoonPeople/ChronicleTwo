"""BSS gaps need original alignment or exact, explicit unresolved retail storage."""

from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
import postprocess_object as p
from test_literal_data import symbol


class BssAlignmentTests(unittest.TestCase):
    def fixture(self, alignment=16, end=0x3010, size=12):
        def section(size, alignment):
            return NS(name='.bss', sh_type=p.SHT_NOBITS, sh_flags=p.FLAGS['.bss'],
                      sh_size=size, data=b'', sh_addralign=alignment)
        current = section(size, 4)
        following = section(4, alignment)
        compiled = NS(sections=[NS(name='', sh_flags=0), current, following],
                      symtab=NS(symbols=[symbol('object', 1, size), symbol('following', 2, 4)]),
                      relocations=[])
        rows = [(0x3000, 'object', size, False), (end, 'following', 4, False)]
        pieces = NS(unit=lambda unit: [('.bss', [('object', 0x3000, end),
                                                ('following', end, end + 4)])])
        retail = NS(relocations={})
        return compiled, rows, pieces, retail

    def apply(self, fx, held=frozenset(), placeholders=frozenset()):
        compiled, rows, pieces, retail = fx
        with patch.object(p.layout, 'section_of', return_value='.bss'):
            p.pad_data(compiled, 'unit', placeholders, pieces=pieces, rows=rows,
                       retail=retail, held=held)
        return compiled.sections[1].sh_size

    def test_original_alignment_explains_the_exact_next_start(self):
        self.assertEqual(self.apply(self.fixture()), 16)
        self.assertEqual(self.apply(self.fixture(alignment=128, end=0x3080, size=4)), 128)

    def test_large_gap_before_an_ordinary_pointer_stays_unreserved(self):
        self.assertEqual(self.apply(self.fixture(alignment=4, end=0x3040, size=4)), 4)

    def test_original_alignment_above_128_supplies_no_reservation(self):
        self.assertEqual(self.apply(self.fixture(alignment=512, end=0x3200, size=4)), 4)

    def test_missing_or_wrong_sized_next_native_object_supplies_no_alignment(self):
        for invalid in ('missing', 'size', 'alignment', 'alias'):
            with self.subTest(invalid=invalid):
                fx = self.fixture(alignment=64, end=0x3040, size=4)
                elf = fx[0]
                if invalid == 'missing': elf.symtab.symbols.pop()
                elif invalid == 'size': fx[1][-1] = (0x3040, 'following', 8, False)
                elif invalid == 'alignment': elf.sections[2].sh_addralign = 3
                else: elf.symtab.symbols.append(symbol('alias', 2, 4))
                self.assertEqual(self.apply(fx), 4)

    def test_referenced_cut_limits_storage_before_the_verified_alignment_end(self):
        fx = self.fixture(alignment=64, end=0x3040, size=4)
        fx[2].unit = lambda unit: [('.bss', [('object', 0x3000, 0x3020),
                                            ('D_00003020', 0x3020, 0x3040),
                                            ('following', 0x3040, 0x3044)])]
        self.assertEqual(self.apply(fx), 32)

    def test_retail_relocation_in_the_gap_blocks_reservation(self):
        fx = self.fixture(alignment=64, end=0x3040, size=4)
        fx[3].relocations[0x3020] = p.R_MIPS_32
        self.assertEqual(self.apply(fx), 4)

    def test_small_scalar_slots_are_not_inferred_from_retail_spacing(self):
        self.assertEqual(self.apply(self.fixture(alignment=1, end=0x3004, size=1)), 1)
        self.assertEqual(self.apply(self.fixture(alignment=2, end=0x3004, size=2)), 2)

    def test_padded_section_alignment_does_not_replace_original_evidence(self):
        fx = self.fixture(alignment=4, end=0x3040, size=4)
        original = p.native_data_extents(fx[0], set())
        fx[0].sections[2].sh_addralign = 64
        with patch.object(p.layout, 'section_of', return_value='.bss'):
            p.pad_data(fx[0], 'unit', set(), pieces=fx[2], rows=fx[1], retail=fx[3],
                       native_extents=original)
        self.assertEqual(fx[0].sections[1].sh_size, 4)

    def test_original_native_ownership_and_retail_declarations_fail_closed(self):
        for invalid in ('left_alias', 'left_offset', 'left_flags', 'left_alignment',
                        'right_flags', 'right_kind', 'right_type', 'left_declaration',
                        'right_declaration', 'right_function', 'gap_declaration',
                        'duplicate_left', 'duplicate_right', 'native_relocation'):
            with self.subTest(invalid=invalid):
                fx = self.fixture(alignment=64, end=0x3040, size=4)
                compiled, rows, _pieces, _retail = fx
                if invalid == 'left_alias': compiled.symtab.symbols.append(symbol('alias', 1, 4))
                elif invalid == 'left_offset': compiled.symtab.symbols[0].st_value = 1
                elif invalid == 'left_flags': compiled.sections[1].sh_flags = 0
                elif invalid == 'left_alignment': compiled.sections[1].sh_addralign = 3
                elif invalid == 'right_flags': compiled.sections[2].sh_flags = 0
                elif invalid == 'right_kind': compiled.sections[2].name = '.sbss'
                elif invalid == 'right_type': compiled.sections[2].sh_type = p.SHT_PROGBITS
                elif invalid == 'left_declaration': rows[0] = (0x3004, 'object', 4, False)
                elif invalid == 'right_declaration': rows[-1] = (0x3044, 'following', 4, False)
                elif invalid == 'right_function': rows[-1] = (0x3040, 'following', 4, True)
                elif invalid == 'gap_declaration': rows.append((0x3020, 'interior', 4, False))
                elif invalid == 'duplicate_left': rows.append(rows[0])
                elif invalid == 'duplicate_right': rows.append(rows[-1])
                else:
                    compiled.relocations = [NS(sh_info=1, relocations=[NS(r_offset=8)])]
                self.assertEqual(self.apply(fx), 4)

    def listed(self, fx):
        compiled, rows, _pieces, _retail = fx
        return {('unit', 'object'): ('.bss', rows[0][0], compiled.sections[1].sh_size,
                                    'following', rows[-1][0], rows[-1][2],
                                    (compiled.sections[2].sh_addralign,))}

    def test_explicit_unresolved_storage_is_exact_and_unit_scoped(self):
        fx = self.fixture(alignment=4, end=0x3040, size=4)
        listed = self.listed(fx)
        with patch.object(p, 'BSS_RETAIL_RESERVATIONS', listed):
            self.assertEqual(self.apply(fx), 64)
        for field, value in enumerate(('.sbss', 0x3004, 8, 'other', 0x3080, 8)):
            with self.subTest(field=field):
                fx = self.fixture(alignment=4, end=0x3040, size=4)
                changed = list(listed[('unit', 'object')])
                changed[field] = value
                with patch.object(p, 'BSS_RETAIL_RESERVATIONS', {('unit', 'object'): tuple(changed)}):
                    self.assertEqual(self.apply(fx), 4)
        for key in (('other', 'object'), ('unit', 'other')):
            with self.subTest(key=key), patch.object(p, 'BSS_RETAIL_RESERVATIONS',
                                                   {key: listed[('unit', 'object')]}):
                self.assertEqual(self.apply(self.fixture(alignment=4, end=0x3040, size=4)), 4)

    def test_listed_missing_next_native_object_does_not_supply_its_payload(self):
        fx = self.fixture(alignment=4, end=0x3040, size=4)
        listed = self.listed(fx)
        listed[('unit', 'object')] = listed[('unit', 'object')][:6] + ((None,),)
        fx[0].symtab.symbols.pop()
        fx[0].sections.pop()
        with patch.object(p, 'BSS_RETAIL_RESERVATIONS', listed):
            self.assertEqual(self.apply(fx, held={'following'}), 64)
        self.assertEqual(len(fx[0].sections), 2)
        self.assertEqual(len(fx[0].symtab.symbols), 1)
        self.assertEqual(fx[0].symtab.symbols[0].st_size, 4)

    def test_explicit_reservation_cannot_bypass_interior_evidence(self):
        for invalid in ('retail_relocation', 'native_relocation', 'declared', 'wrong_owner'):
            with self.subTest(invalid=invalid):
                fx = self.fixture(alignment=4, end=0x3040, size=4)
                listed = self.listed(fx)
                if invalid == 'retail_relocation': fx[3].relocations[0x3020] = p.R_MIPS_32
                elif invalid == 'native_relocation':
                    fx[0].relocations = [NS(sh_info=1, relocations=[NS(r_offset=8)])]
                elif invalid == 'declared': fx[1].append((0x3020, 'interior', 4, False))
                else: fx[0].symtab.symbols.append(symbol('alias', 1, 4))
                with patch.object(p, 'BSS_RETAIL_RESERVATIONS', listed):
                    self.assertEqual(self.apply(fx), 4)

    def test_actual_reviewer_pointer_case_is_not_generalized_to_another_unit(self):
        fx = self.fixture(alignment=4, end=0x37eac0, size=4)
        fx[0].symtab.symbols[0].name = 'ConvertResultDispTime'
        fx[0].symtab.symbols[1].name = 'SaveFileInfoTablePtr'
        fx[0].sections[1].name = fx[0].sections[2].name = '.sbss'
        fx[0].sections[1].sh_flags = fx[0].sections[2].sh_flags = p.FLAGS['.sbss']
        rows = [(0x37ea8c, 'ConvertResultDispTime', 4, False),
                (0x37eac0, 'SaveFileInfoTablePtr', 4, False)]
        run = [(rows[0][1], rows[0][0], rows[1][0]),
               (rows[1][1], rows[1][0], rows[1][0] + 4)]
        pieces = NS(unit=lambda unit: [('.sbss', run)])
        with patch.object(p.layout, 'section_of', return_value='.sbss'):
            p.pad_data(fx[0], 'another_unit', set(), pieces=pieces, rows=rows, retail=fx[3])
            self.assertEqual(fx[0].sections[1].sh_size, 4)
            p.pad_data(fx[0], 'convviewlp', set(), pieces=pieces, rows=rows, retail=fx[3])
            self.assertEqual(fx[0].sections[1].sh_size, 52)

    def test_listed_reservation_rejects_invalid_live_next_evidence(self):
        for invalid in ('size', 'type', 'flags', 'alias', 'alignment', 'changed_alignment', 'missing'):
            with self.subTest(invalid=invalid):
                fx = self.fixture(alignment=4, end=0x3040, size=4)
                listed = self.listed(fx)
                compiled = fx[0]
                if invalid == 'size':
                    compiled.sections[2].sh_size = compiled.symtab.symbols[1].st_size = 8
                elif invalid == 'type': compiled.sections[2].sh_type = p.SHT_PROGBITS
                elif invalid == 'flags': compiled.sections[2].sh_flags = 0
                elif invalid == 'alias': compiled.symtab.symbols.append(symbol('alias', 2, 4))
                elif invalid == 'alignment': compiled.sections[2].sh_addralign = 3
                elif invalid == 'changed_alignment': compiled.sections[2].sh_addralign = 16
                else: compiled.symtab.symbols.pop()
                with patch.object(p, 'BSS_RETAIL_RESERVATIONS', listed):
                    self.assertEqual(self.apply(fx), 4)

    def test_marker_exception_requires_retained_source_and_valid_placeholder(self):
        for invalid in ('source', 'flags', 'type', 'size', 'alias'):
            with self.subTest(invalid=invalid):
                fx = self.fixture(alignment=4, end=0x3040, size=4)
                listed = self.listed(fx)
                listed[('unit', 'object')] = listed[('unit', 'object')][:6] + ((None,),)
                with patch.object(p, 'BSS_RETAIL_RESERVATIONS', listed):
                    self.assertEqual(self.apply(fx, held={'following'}, placeholders={2}), 64)
                fx[0].sections[1].sh_size = 4
                if invalid == 'flags': fx[0].sections[2].sh_flags = 0
                elif invalid == 'type': fx[0].sections[2].sh_type = p.SHT_PROGBITS
                elif invalid == 'size': fx[0].sections[2].sh_size = 8
                elif invalid == 'alias': fx[0].symtab.symbols.append(symbol('alias', 2, 4))
                with patch.object(p, 'BSS_RETAIL_RESERVATIONS', listed):
                    held = set() if invalid == 'source' else {'following'}
                    self.assertEqual(self.apply(fx, held=held, placeholders={2}), 4)

    def test_retained_placeholder_accepts_only_equal_offset_declaration_aliases(self):
        for declared in (1, 4):
            with self.subTest(declared=declared):
                fx = self.fixture(alignment=4, end=0x3040, size=4)
                fx[1][-1] = (0x3040, 'following', declared, False)
                fx[0].symtab.symbols.append(symbol('following', 2, declared))
                listed = self.listed(fx)
                listed[('unit', 'object')] = listed[('unit', 'object')][:6] + ((None,),)
                with patch.object(p, 'BSS_RETAIL_RESERVATIONS', listed):
                    self.assertEqual(self.apply(fx, held={'following'}, placeholders={2}), 64)
        for invalid in ('name', 'offset', 'size', 'type', 'section'):
            with self.subTest(invalid=invalid):
                fx = self.fixture(alignment=4, end=0x3040, size=4)
                alias = symbol('following', 2, 4)
                fx[0].symtab.symbols.append(alias)
                listed = self.listed(fx)
                listed[('unit', 'object')] = listed[('unit', 'object')][:6] + ((None,),)
                if invalid == 'name': alias.name = 'competing'
                elif invalid == 'offset': alias.st_value = 1
                elif invalid == 'size': alias.st_size = 8
                elif invalid == 'type': alias.type = p.STT_FUNC
                else: alias.st_shndx = 1
                with patch.object(p, 'BSS_RETAIL_RESERVATIONS', listed):
                    self.assertEqual(self.apply(fx, held={'following'}, placeholders={2}), 4)

    def test_stale_snapshot_rejects_current_next_section_exceeding_its_piece(self):
        fx = self.fixture(alignment=64, end=0x3040, size=4)
        original = p.native_data_extents(fx[0], set())
        fx[0].sections[2].sh_size = 128
        with patch.object(p.layout, 'section_of', return_value='.bss'):
            p.pad_data(fx[0], 'unit', set(), pieces=fx[2], rows=fx[1], retail=fx[3],
                       native_extents=original)
        self.assertEqual(fx[0].sections[1].sh_size, 4)

    def test_live_native_object_at_canonical_fragment_rejects_gap_proof(self):
        fx = self.fixture(alignment=64, end=0x3040, size=4)
        fx[2].unit = lambda unit: [('.bss', [('object', 0x3000, 0x3020),
                                          ('D_00003020', 0x3020, 0x3040),
                                          ('following', 0x3040, 0x3044)])]
        fx[0].sections.append(NS(name='.bss', sh_type=p.SHT_NOBITS,
                                 sh_flags=p.FLAGS['.bss'], sh_size=4,
                                 data=b'', sh_addralign=4))
        fx[0].symtab.symbols.append(symbol('D_00003020', 3, 4))
        self.assertEqual(self.apply(fx), 4)
