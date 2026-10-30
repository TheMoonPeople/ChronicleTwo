"""ChronicleTwoMenu, ChronicleTwoBoard and ChronicleTwoTitle: the shipped fonts' characters and shapes, and that the
tools rebuild them byte for byte.

The tests need scripts/font/requirements.txt and skip without it. The rebuild also needs the source fonts, in the
directory DC2_FONT_SOURCES names or already fetched into ~/.cache/chronicletwo by build_menu_font.py; it skips
without them, so the test never touches the network.
"""
import hashlib
import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
try:
    import pathops
    from fontTools.pens.recordingPen import RecordingPen
    from fontTools.ttLib import TTFont

    import build_menu_font
    import menu_font as mnf
except ImportError as missing:
    mnf = None
    MISSING = str(missing)


def source_paths():
    """{name: path} of every source font, from DC2_FONT_SOURCES or the cache; None where one is missing."""
    named = os.environ.get("DC2_FONT_SOURCES")
    # The port's own fonts are sources where the port keeps them.
    paths = {name: Path(named) / file if named and url else mnf.cached(name)
             for name, (file, url, _) in mnf.SOURCES.items()}
    return paths if all(path.exists() for path in paths.values()) else None


@unittest.skipIf(mnf is None, "the font tools' Python packages are not installed")
class MenuFont(unittest.TestCase):
    def setUp(self):
        self.font = TTFont(mnf.FONT)
        self.cmap = self.font.getBestCmap()
        self.glyf = self.font["glyf"]

    def path(self, ch):
        recording = RecordingPen()
        self.font.getGlyphSet()[self.cmap[ord(ch)]].draw(recording)
        path = pathops.Path()
        recording.replay(path.getPen())
        return path

    def width_at(self, ch, y):
        """How wide the glyph's ink is along the line y, in font units."""
        path = self.path(ch)
        x0, _, x1, _ = path.bounds
        return sum(4 for x in range(int(x0), int(x1) + 1, 4) if path.contains((x, y)))

    def test_every_ascii_character_is_in_the_font(self):
        self.assertEqual(sorted(chr(c) for c in range(0x20, 0x7F) if c not in self.cmap), [])

    def test_its_units_are_the_fitted_texel_grid(self):
        self.assertEqual(self.font["head"].unitsPerEm, round(mnf.load_parameters()["global"]["em"] * mnf.UNIT))

    def test_fitted_letters_keep_the_baseline(self):
        # Heights grow from the baseline; only the weight's half-stroke reaches past it.
        for ch in "HIMhiklmnr":
            self.assertLess(abs(self.glyf[self.cmap[ord(ch)]].yMin), mnf.UNIT / 4, ch)

    def test_the_m_splays(self):
        cap = self.font["OS/2"].sCapHeight
        self.assertGreater(self.width_at("M", mnf.UNIT / 2), self.width_at("M", cap - mnf.UNIT / 2) * 1.1)

    def test_the_question_mark_is_drawn_with_a_drop(self):
        # The hood, its drop and the stem are one contour, the dot another.
        self.assertEqual(self.glyf[self.cmap[ord("?")]].numberOfContours, 2)
        self.assertEqual(mnf.load_parameters()["glyphs"]["?"]["source"], "drawn")

    def test_corners_are_rounded(self):
        # A square stroke end now meets its sides through a curve, so the stem's foot is narrower than its middle.
        cap = self.font["OS/2"].sCapHeight
        self.assertLess(self.width_at("I", 2), self.width_at("I", cap / 2))

    def test_side_bearings_are_the_outlines_left_edges(self):
        # FreeType and stb_truetype place an outline by its side bearing.
        hmtx = self.font["hmtx"]
        for name in self.font.getGlyphOrder():
            glyph = self.glyf[name]
            if glyph.numberOfContours:
                self.assertEqual(hmtx[name][1], glyph.xMin, name)

    @unittest.skipIf(mnf is not None and source_paths() is None,
                     "the source fonts are neither in DC2_FONT_SOURCES nor cached")
    def test_the_tools_rebuild_the_shipped_font(self):
        with tempfile.TemporaryDirectory() as directory:
            out = Path(directory) / "rebuilt.ttf"
            build_menu_font.build(mnf.load_parameters(), out, source_paths())
            self.assertEqual(hashlib.sha256(out.read_bytes()).hexdigest(),
                             hashlib.sha256(mnf.FONT.read_bytes()).hexdigest())


@unittest.skipIf(mnf is None, "the font tools' Python packages are not installed")
class BoardFont(unittest.TestCase):
    def setUp(self):
        self.parameters = mnf.load_parameters(mnf.BOARD_PARAMETERS)
        self.font = TTFont(mnf.font_path(self.parameters))
        self.cmap = self.font.getBestCmap()

    def test_it_holds_the_board_and_ascii(self):
        self.assertEqual(sorted(chr(c) for c in range(0x20, 0x7F) if c not in self.cmap), [])
        self.assertEqual(self.font["head"].unitsPerEm, round(self.parameters["global"]["em"] * mnf.UNIT))

    def test_figures_share_their_height(self):
        # The figures come from three fonts; they stand as tall as one another, within a texel.
        heights = [self.font["glyf"][self.cmap[ord(ch)]].yMax for ch in "0123456789"]
        self.assertLess(max(heights) - min(heights), mnf.UNIT)

    @unittest.skipIf(mnf is not None and source_paths() is None,
                     "the source fonts are neither in DC2_FONT_SOURCES nor cached")
    def test_the_tools_rebuild_the_shipped_font(self):
        with tempfile.TemporaryDirectory() as directory:
            out = Path(directory) / "rebuilt.ttf"
            build_menu_font.build(self.parameters, out, source_paths())
            self.assertEqual(hashlib.sha256(out.read_bytes()).hexdigest(),
                             hashlib.sha256(mnf.font_path(self.parameters).read_bytes()).hexdigest())



@unittest.skipIf(mnf is None, "the font tools' Python packages are not installed")
class TitleFont(unittest.TestCase):
    def setUp(self):
        self.parameters = mnf.load_parameters(mnf.TITLE_PARAMETERS)
        self.font = TTFont(mnf.font_path(self.parameters))
        self.cmap = self.font.getBestCmap()

    def test_it_holds_every_character_the_european_text_draws(self):
        # ASCII, and the accented letters and marks ChronicleTwoMessage draws for French, German, Italian and Spanish:
        # everything of those it has.
        message = TTFont(mnf.cached("chronicletwo_message")).getBestCmap()
        self.assertEqual([ch for ch in mnf.characters(self.parameters) if ord(ch) in message and ord(ch) not in self.cmap],
                         [])
        self.assertTrue(all(ord(ch) in self.cmap for ch in "ÀÇÈÉÑÖÜßàçèéíñóöùüŒœ¡¿"))
        self.assertEqual(self.font["head"].unitsPerEm, round(self.parameters["global"]["em"] * mnf.UNIT))

    def test_the_round_capitals_are_wider_than_the_message_fonts(self):
        # Their stems keep their weight, so their outlines widen by less than their scale.
        message = TTFont(mnf.cached("chronicletwo_message"))
        scale = self.font["head"].unitsPerEm / message["head"].unitsPerEm * self.parameters["global"]["stretch"]
        for ch in "CNO":
            title = self.font["glyf"][self.cmap[ord(ch)]]
            plain = message["glyf"][message.getBestCmap()[ord(ch)]]
            self.assertGreater(title.xMax - title.xMin, (plain.xMax - plain.xMin) * scale * 1.1, ch)

    @unittest.skipIf(mnf is not None and source_paths() is None,
                     "the source fonts are neither in DC2_FONT_SOURCES nor cached")
    def test_the_tools_rebuild_the_shipped_font(self):
        with tempfile.TemporaryDirectory() as directory:
            out = Path(directory) / "rebuilt.ttf"
            build_menu_font.build(self.parameters, out, source_paths())
            self.assertEqual(hashlib.sha256(out.read_bytes()).hexdigest(),
                             hashlib.sha256(mnf.font_path(self.parameters).read_bytes()).hexdigest())


if __name__ == "__main__":
    unittest.main()
