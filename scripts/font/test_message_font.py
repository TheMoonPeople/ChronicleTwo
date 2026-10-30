"""ChronicleTwoMessage: the shipped font's grid and coverage, and that the tools rebuild it byte for byte.

The tests need scripts/font/requirements.txt and skip without it. The rebuild also needs Kosugi, named by
DC2_KOSUGI or already fetched into ~/.cache/chronicletwo by build_message_font.py; it skips without it,
so the test never touches the network.
"""
import hashlib
import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
try:
    from fontTools.ttLib import TTFont

    import build_message_font
    import message_font as mf
except ImportError as missing:
    mf = None
    MISSING = str(missing)


def kosugi():
    named = os.environ.get("DC2_KOSUGI")
    if named:
        return Path(named)
    cached = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "chronicletwo" / "Kosugi-Regular.ttf"
    return cached if cached.exists() else None


@unittest.skipIf(mf is None, "the font tools' Python packages are not installed")
class MessageFont(unittest.TestCase):
    def setUp(self):
        self.font = TTFont(mf.FONT)
        self.cmap = self.font.getBestCmap()

    def test_glyphs_sit_on_the_retail_cell_grid(self):
        self.assertEqual(self.font["head"].unitsPerEm, mf.UNITS_PER_EM)
        self.assertEqual((self.font["hhea"].ascent, -self.font["hhea"].descent), (mf.ASCENT, mf.DESCENT))
        advance = lambda ch: self.font["hmtx"][self.cmap[ord(ch)]][0]  # noqa: E731
        # Figures and symbols keep the retail cell, so they still line up in columns.
        self.assertEqual({advance(ch) for ch in "0123456789+%~" + chr(0xFF65)}, {mf.HALF})
        self.assertEqual(advance("○"), mf.FULL)

    def test_letters_take_their_own_width(self):
        advance = lambda ch: self.font["hmtx"][self.cmap[ord(ch)]][0]  # noqa: E731
        parameters = mf.load_parameters()
        self.assertLess(advance("i"), advance("n") / 2)
        self.assertLess(advance("l"), advance("n") / 2)
        self.assertLess(advance("r"), advance("n"))
        self.assertGreater(advance("m"), advance("n"))
        self.assertEqual(advance(" "), round(mf.HALF * parameters["spacing"]["space"]))
        # Every letter's ink starts its own sidebearing in from the pen, never left of it by much.
        glyf = self.font["glyf"]
        for ch in "inmoGHrt":
            self.assertGreater(glyf[self.cmap[ord(ch)]].xMin, 0, ch)

    def test_every_character_pal_text_draws_is_in_the_font(self):
        parameters = mf.load_parameters()
        wanted = set(mf.ASCII) | {chr(cp) for cp in mf.ACCENTED}
        wanted |= {mf.HALF_MIDDLE_DOT if ch == "・" else ch for ch in mf.FONT_GAIJI}
        wanted |= {mf.ENGLISH_VARIANTS.get(ch, ch) for ch in parameters["full_width"]}
        missing = sorted(ch for ch in wanted if ord(ch) not in self.cmap)
        self.assertEqual(missing, [])

    def test_side_bearings_are_the_outlines_left_edges(self):
        # FreeType and stb_truetype place an outline by its side bearing.
        glyf, hmtx = self.font["glyf"], self.font["hmtx"]
        for name in self.font.getGlyphOrder():
            glyph = glyf[name]
            if glyph.numberOfContours:
                self.assertEqual(hmtx[name][1], glyph.xMin, name)

    @unittest.skipIf(mf is not None and kosugi() is None, "Kosugi is neither named by DC2_KOSUGI nor cached")
    def test_the_tools_rebuild_the_shipped_font(self):
        with tempfile.TemporaryDirectory() as directory:
            out = Path(directory) / "rebuilt.ttf"
            build_message_font.build(kosugi(), mf.load_parameters(), out)
            self.assertEqual(hashlib.sha256(out.read_bytes()).hexdigest(),
                             hashlib.sha256(mf.FONT.read_bytes()).hexdigest())


if __name__ == "__main__":
    unittest.main()
