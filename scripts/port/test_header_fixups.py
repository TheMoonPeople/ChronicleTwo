import unittest
from pathlib import Path
import header_fixups


class UnitFixups(unittest.TestCase):
    def test_password_generator_avoids_host_random_without_changing_its_body(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/password.cpp").read_text()
        result = header_fixups.fixup_unit_text("password.cpp", source)
        self.assertEqual(source.count("random()"), 5)
        self.assertEqual(result.count("PortPasswordRandom()"), 5)
        self.assertEqual(result.replace("PortPasswordRandom()", "random()"), source)
        self.assertEqual(header_fixups.fixup_unit_text("other.cpp", source), source)
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("password.cpp", result)

    def test_party_ring_uses_rgba_variant_instead_of_palette_memory(self):
        source = (Path(__file__).resolve().parents[2] / "ps2/src/menuchr.cpp").read_text()
        result = header_fixups.fixup_unit_text("menuchr.cpp", source)
        self.assertNotIn("->clut", result)
        self.assertNotIn("palette.clut", result)
        self.assertIn("MgTextureColorMode::PartyLocked", result)
        self.assertEqual(result.count("\n"), source.count("\n"))
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("menuchr.cpp", result)

    def test_invent_constructor_emitted_exactly_once(self):
        source = "// constructor\ninline CMenuInvent::CMenuInvent() {\n    card_cursor = 0;\n}\n"
        result = header_fixups.fixup_unit_text("inventmn.cpp", source)
        self.assertEqual(result, source.replace("inline CMenuInvent", "CMenuInvent"))
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("inventmn.cpp", result)
        with self.assertRaises(SystemExit):
            header_fixups.fixup_unit_text("inventmn.cpp", source + source)
        self.assertEqual(header_fixups.fixup_unit_text("other.cpp", source), source)


if __name__ == "__main__":
    unittest.main()
