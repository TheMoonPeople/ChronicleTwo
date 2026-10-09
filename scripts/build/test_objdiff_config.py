"""Check mappings between retail identifiers and native MWCC symbols."""

import unittest

from objdiff_config import compiler_mappings


class CompilerMappingsTests(unittest.TestCase):
    def test_template_symbols_use_actual_compiler_spelling(self):
        name = "Initialize__17CList_9CObjAnime_Fv"
        raw = "Initialize__17CList<9CObjAnime>Fv"
        self.assertEqual(compiler_mappings([name], [raw]), {name: raw})

    def test_suffixed_local_and_dollar_data_names(self):
        self.assertEqual(compiler_mappings(
            ["helper__Fv__2", "table_42__3", "at_17__2"],
            ["helper__Fv", "table$42", "@17"],
        ), {"helper__Fv__2": "helper__Fv", "table_42__3": "table$42"})

    def test_normalized_native_suffix_still_maps_the_reference_identity(self):
        self.assertEqual(compiler_mappings(['Font__3', 'at_17__2'], ['Font__3', 'at_17__2']),
                         {'Font__3': 'Font__3', 'at_17__2': 'at_17__2'})
        self.assertEqual(compiler_mappings(['ordinary'], ['ordinary']), {})

    def test_anonymous_number_is_never_a_mapping_identity(self):
        self.assertEqual(compiler_mappings(['at_17', 'at_17__2'], ['@17']), {})

    def test_unavailable_native_symbol_is_not_invented(self):
        self.assertEqual(compiler_mappings(["missing__Fv", "native__Fv"], ["native__Fv"]), {})

    def test_ambiguous_normalization_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "ambiguous"):
            compiler_mappings(["table_42"], ["table$42", "table_42"])


if __name__ == "__main__":
    unittest.main()
