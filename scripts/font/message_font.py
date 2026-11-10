"""ChronicleTwoMessage: the message font of Dark Chronicle as outlines, built from Kosugi.

Master space is the retail font cell: 64 units a texel of the 16x20 cell, the origin at the pen on the
European page's baseline (cell row 16), y up. A glyph is a recipe of Kosugi components, each moved into
master space by an affine (x' = a*x + c*y + e, y' = b*x + d*y + f) and offset back to its stem weight
when the affine scales it, or of parts drawn for the port. The fitter renders recipes through FreeType
as each retail page draws them; the builder runs the same FreeType steps and writes the outlines out, so
the font draws what was measured. docs/PC.md "Message font" covers the whole.
"""
import ctypes
import hashlib
import io
import json
import os
import struct
import tempfile
import unicodedata
import urllib.request
import zipfile
from pathlib import Path

import freetype
import numpy as np
import pathops
from fontTools.fontBuilder import FontBuilder
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.ttGlyphPen import TTGlyphPen

ROOT = Path(__file__).resolve().parents[2]
PARAMETERS = Path(__file__).resolve().parent / "message_font.json"
FONT = ROOT / "port/assets/fonts/ChronicleTwoMessage-Regular.ttf"

# Kosugi 4.002 by MOTOYA, Apache 2.0, as google/fonts publishes it.
KOSUGI_URL = "https://raw.githubusercontent.com/google/fonts/9fc4eac722cec1cbb58b3c85c2f687bc39eda180/apache/kosugi/Kosugi-Regular.ttf"
KOSUGI_SHA256 = "f5e81d6a6b865d9b88c54d2d3c16bcaa3b239dfcefaf2a62976ac9dc7574bab7"

UNIT = 64  # master units a texel
UNITS_PER_EM = 1280  # the 20-texel cell
ASCENT, DESCENT = 1024, 256  # the cell above and below the European page's baseline
HALF, FULL = 512, 1024  # cell widths
STEM_X, STEM_Y = 85.0, 66.0  # Kosugi's vertical stem and horizontal stroke in master units

# Font numbers 0x5E-0x9C of the European page: the Latin-1 codes of alphabetical_chara_tbl (ps2/src/font.cpp).
ACCENTED = [0xA1, 0xAA, 0xB0, 0xBA, 0xBF, 0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA, 0xCB,
            0xCC, 0xCD, 0xCE, 0xCF, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD, 0xDF, 0xE0,
            0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC, 0xED, 0xEE, 0xEF, 0xF1, 0xF2,
            0xF3, 0xF4, 0xF5, 0xF6, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFF, 0x152, 0x153]
# Font numbers 0x9D-0xB4 of the European page, FontGaijiConvTbl's characters; the last five are half-width.
FONT_GAIJI = "○●↑↓←→０１２３４５６７８９：＋－・“”‘’"
HALF_GAIJI = "・“”‘’"
# Characters both pages draw with different widths. The standard code point keeps the European page's
# half-width form; the English page's full-width form takes these. (The English page has no ‘.)
ENGLISH_VARIANTS = {"“": "\ue001", "”": "\ue002", "’": "\ue004", "°": "\ue005"}
HALF_MIDDLE_DOT = "\uff65"  # the European page's half-width ・
# The marks of accented letters: a combining mark to the Kosugi glyph drawn for it. The diaeresis is
# two of Kosugi's full stops and the cedilla a drawn stroke, so neither has a source glyph.
MARKS = {"\u0300": "`", "\u0301": "´", "\u0302": "^", "\u0303": "˜", "\u0308": "¨", "\u030a": "°", "\u0327": "ȷ"}
ASCII = [chr(c) for c in range(0x21, 0x7F) if chr(c) != "\\"]
# Glyphs that take their own width in the sharp font's layout; the rest keep the retail cell, so
# figures and symbols still line up in columns. Letters, the punctuation of running text and the space.
PROPORTIONAL = (set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") | {chr(cp) for cp in ACCENTED if cp != 0xB0}
                | set(".,:;!?'\"()-& ") | {"\u2018", "\u2019", "\u201c", "\u201d"})

GLOBAL_KEY = "kosugi_to_master"
IDENTITY = (1.0, 0.0, 0.0, 1.0, 0.0, 0.0)


def compose(outer, inner):
    """The affine `outer` after `inner`."""
    a1, b1, c1, d1, e1, f1 = outer
    a2, b2, c2, d2, e2, f2 = inner
    return (a1 * a2 + c1 * b2, b1 * a2 + d1 * b2, a1 * c2 + c1 * d2, b1 * c2 + d1 * d2,
            a1 * e2 + c1 * f2 + e1, b1 * e2 + d1 * f2 + f1)


def scale_about(kx, ky, cx, cy, tx=0.0, ty=0.0):
    """Scales by (kx, ky) about (cx, cy), then moves by (tx, ty)."""
    return (kx, 0.0, 0.0, ky, cx - kx * cx + tx, cy - ky * cy + ty)


def transform(outline, affine):
    """Applies an affine to a loaded FT_Outline in place, in 26.6 units."""
    a, b, c, d, e, f = affine
    matrix = freetype.FT_Matrix(int(round(a * 0x10000)), int(round(c * 0x10000)),
                                int(round(b * 0x10000)), int(round(d * 0x10000)))
    freetype.raw.FT_Outline_Transform(outline, ctypes.byref(matrix))
    freetype.raw.FT_Outline_Translate(outline, int(round(e)), int(round(f)))


def kosugi_path(cache=None):
    """Kosugi-Regular.ttf, fetched once into the cache and checked against its pinned SHA-256."""
    cache = Path(cache or os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "chronicletwo"
    path = cache / "Kosugi-Regular.ttf"
    if not path.exists():
        cache.mkdir(parents=True, exist_ok=True)
        with urllib.request.urlopen(KOSUGI_URL) as response:
            data = response.read()
        path.write_bytes(data)
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    if digest != KOSUGI_SHA256:
        raise SystemExit(f"{path}: SHA-256 {digest}, expected {KOSUGI_SHA256}")
    return path


class Source:
    """A font whose glyphs are moved into master space and rendered with FreeType, unhinted."""

    # Kosugi has no dotless i or j: they are its i and j without the contours above the x-height.
    DOTLESS = {"ı": "i", "ȷ": "j"}
    DOT_FLOOR = 600  # Kosugi units: the dots start at 672, the stems end at 539

    def __init__(self, path):
        self.face = freetype.Face(str(path))
        # 16 pixels an em: a unit of a 1024-unit font is one 26.6 unit, so outlines read in font units.
        self.face.set_char_size(0, 16 * 64)
        self.unit = 1024.0 / self.face.units_per_EM  # 26.6 units a font unit

    def load(self, ch):
        """Loads ch unscaled into the glyph slot and returns its FT_Outline."""
        self.face.set_transform(freetype.Matrix(0x10000, 0, 0, 0x10000), freetype.Vector(0, 0))
        self.face.load_char(self.DOTLESS.get(ch, ch), freetype.FT_LOAD_NO_HINTING | freetype.FT_LOAD_NO_BITMAP)
        raw = self.face.glyph.outline._FT_Outline
        if ch in self.DOTLESS:
            self._drop_contours_above(raw, self.DOT_FLOOR * self.unit)
        return raw

    @staticmethod
    def _drop_contours_above(raw, floor):
        kept_points, kept_ends, start = 0, 0, 0
        for c in range(raw.n_contours):
            end = raw.contours[c]
            if min(raw.points[i].y for i in range(start, end + 1)) < floor:
                for i in range(start, end + 1):
                    raw.points[kept_points] = raw.points[i]
                    raw.tags[kept_points] = raw.tags[i]
                    kept_points += 1
                raw.contours[kept_ends] = kept_points - 1
                kept_ends += 1
            start = end + 1
        raw.n_contours, raw.n_points = kept_ends, kept_points

    def outline(self, ch, affine, strength=(0.0, 0.0), squash=None):
        """Moves ch into master space: the affine, then EmboldenXY by strength (master units), then, with
        squash = (floor, top), everything above floor pressed down so the glyph's top is at top."""
        raw = self.load(ch)
        outline = ctypes.byref(raw)
        k = 1.0 / self.unit
        a, b, c, d, e, f = affine
        transform(outline, (a * k, b * k, c * k, d * k, e, f))
        if strength[0] or strength[1]:
            freetype.raw.FT_Outline_EmboldenXY(outline, int(round(strength[0])), int(round(strength[1])))
        if squash:
            floor, top = squash
            highest = max(raw.points[i].y for i in range(raw.n_points))
            if highest > floor:
                ratio = (top - floor) / (highest - floor)
                for i in range(raw.n_points):
                    if raw.points[i].y > floor:
                        raw.points[i].y = int(round(floor + (raw.points[i].y - floor) * ratio))
        return raw

    def ink(self, ch, affine=IDENTITY):
        """The bounding box (x0, y0, x1, y1) of ch under the affine, in master units."""
        raw = self.load(ch)
        points = np.array([(raw.points[i].x, raw.points[i].y) for i in range(raw.n_points)], np.float64) / self.unit
        a, b, c, d, e, f = affine
        xs = a * points[:, 0] + c * points[:, 1] + e
        ys = b * points[:, 0] + d * points[:, 1] + f
        return xs.min(), ys.min(), xs.max(), ys.max()

    def coverage(self, ch, affine, strength, page, baseline, width, height, squash=None):
        """Coverage of one component as page draws it, the pen at (0, baseline)."""
        raw = self.outline(ch, affine, strength, squash)
        transform(ctypes.byref(raw), page)
        slot = self.face.glyph
        slot.render(freetype.FT_RENDER_MODE_NORMAL)
        bitmap = slot.bitmap
        out = np.zeros((height, width), np.float32)
        if bitmap.width == 0:
            return out
        glyph = np.array(bitmap.buffer, np.float32).reshape(bitmap.rows, bitmap.pitch)[:, :bitmap.width]
        left, top = slot.bitmap_left, int(baseline) - slot.bitmap_top
        y0, x0 = max(0, top), max(0, left)
        y1, x1 = min(height, top + bitmap.rows), min(width, left + bitmap.width)
        if y1 > y0 and x1 > x0:
            out[y0:y1, x0:x1] = glyph[y0 - top:y1 - top, x0 - left:x1 - left]
        return out


def clip_mask(rect, affine, baseline, width, height):
    """Fraction of each pixel inside rect (source units) once affine, which only scales and moves, maps it."""
    a, b, c, d, e, f = affine
    x0, y0, x1, y1 = rect
    px = sorted(((a * x0 + e) / UNIT, (a * x1 + e) / UNIT))
    py = sorted((baseline - (d * y0 + f) / UNIT, baseline - (d * y1 + f) / UNIT))

    def span(lo, hi, n):
        edges = np.arange(n + 1, dtype=np.float64)
        return np.clip(np.minimum(edges[1:], hi) - np.maximum(edges[:-1], lo), 0.0, 1.0)

    return np.outer(span(py[0], py[1], height), span(px[0], px[1], width)).astype(np.float32)


# ---- Parts drawn for the port ----

PART = "\ue000"  # the code point of a drawn part's one-glyph font


def cedilla_path(length, width, depth, end, weight):
    """A short stem down `length` from the origin, then a hook swinging right `width` and back to `end` at
    `depth` below it, stroked at `weight` with butt ends like Kosugi's terminals."""
    path = pathops.Path()
    path.moveTo(0, 24)  # a little into the letter, so the join has no seam
    path.lineTo(0, -length)
    path.cubicTo(width, -length, width, -length - depth, end, -length - depth)
    path.stroke(weight, pathops.LineCap.BUTT_CAP, pathops.LineJoin.MITER_JOIN, 4)
    path.simplify()
    return path


def glyph_of(path):
    """A TrueType glyph of a pathops path, its cubics made quadratic within half a unit."""
    pen = TTGlyphPen(None)
    path.draw(Cu2QuPen(pen, 0.5, reverse_direction=True))
    glyph = pen.glyph()
    if glyph.numberOfContours:
        glyph.recalcBounds(None)
    return glyph


class DrawnSource(Source):
    """A one-glyph font holding a drawn part at PART, its units master units."""

    def __init__(self, path):
        builder = FontBuilder(1024, isTTF=True)
        builder.setupGlyphOrder([".notdef", "part"])
        builder.setupCharacterMap({ord(PART): "part"})
        part = glyph_of(path)
        builder.setupGlyf({".notdef": TTGlyphPen(None).glyph(), "part": part})
        # FreeType places a TrueType outline by its side bearing, so it must be the outline's own left edge.
        builder.setupHorizontalMetrics({".notdef": (512, 0), "part": (512, part.xMin if part.numberOfContours else 0)})
        builder.setupHorizontalHeader(ascent=1024, descent=-256)
        builder.setupNameTable({"familyName": "part", "styleName": "Regular"})
        builder.setupOS2()
        builder.setupPost()
        handle, name = tempfile.mkstemp(suffix=".ttf")
        os.close(handle)
        try:
            builder.save(name)
            super().__init__(name)
        finally:
            os.unlink(name)


# ---- Retail pages, for fitting: disc data, read from the user's own extraction ----

class Extraction:
    """The message font pages and tables of a dc2data extraction: data.zip or a data/ directory."""

    def __init__(self, root):
        root = Path(root)
        if root.is_dir() and (root / "data.zip").exists():
            root = root / "data.zip"
        self.root = root

    def read(self, name):
        if self.root.is_dir():
            return (self.root / name).read_bytes()
        with zipfile.ZipFile(self.root) as archive, open(self.root, "rb") as raw:
            info = archive.getinfo(name)
            if info.compress_type != 93:
                return archive.read(name)
            # Python's zipfile has no Zstandard; read the entry's bytes and decompress them here.
            import zstandard
            raw.seek(info.header_offset + 26)
            raw.seek(int.from_bytes(raw.read(2), "little") + int.from_bytes(raw.read(2), "little"), 1)
            return zstandard.ZstdDecompressor().decompress(raw.read(info.compress_size), max_output_size=info.file_size)

    def coverage(self, name):
        from PIL import Image
        return np.array(Image.open(io.BytesIO(self.read(f"textures/meswin/{name}.png"))).convert("RGBA"))[..., 3]

    def table(self, number):
        """(half-width count, kanji top, Shift-JIS code of each font number) of fonttbl_<number>.bin."""
        data = self.read(f"meswin/fonttbl_{number}.bin")
        half, kanji_top, count, _ = struct.unpack("<4H", data[:8])
        return half, kanji_top, [data[8 + i * 2:10 + i * 2] for i in range(count)]


def decode(code):
    if code[1] == 0x20 and 0x20 <= code[0] <= 0x7E:
        return chr(code[0])
    try:
        return code.decode("shift_jis")
    except UnicodeDecodeError:
        return None


class Page:
    """How a retail page draws master space: an affine to its texels (times 64), and its baseline row."""

    def __init__(self, extraction, number, texture, baseline, affine=IDENTITY):
        self.number, self.baseline, self.affine = number, baseline, tuple(affine)
        self.coverage = extraction.coverage(texture)
        half, kanji_top, codes = extraction.table(number)
        cells = (self.coverage.shape[0] // 20) * 32
        self.glyphs = {}
        for no, code in enumerate(codes[:cells]):
            ch = decode(code)
            if ch is None or (number == 2 and 0x5E <= no < 0xB5):
                continue
            self.glyphs.setdefault(ch, (no, no < half))
        if number == 2:
            for i, cp in enumerate(ACCENTED):
                self.glyphs[chr(cp)] = (0x5E + i, True)
            for i, ch in enumerate(FONT_GAIJI):
                self.glyphs[ch] = (0x9D + i, ch in HALF_GAIJI)

    def cell(self, no, half=False):
        r, c = divmod(no, 32)
        block = self.coverage[r * 20:(r + 1) * 20, c * 16:(c + 1) * 16]
        return (block[:, :8] if half else block).astype(np.float32)

    def target(self, ch):
        no, half = self.glyphs[ch]
        return self.cell(no, half)


def pages(extraction, parameters):
    english = parameters["english_page"]
    return (Page(extraction, 2, "fonttex_2_0_0", 16.0),
            Page(extraction, 1, "fonttex_1_0_0", english["baseline"], english["affine"]))


def render(source, recipe, page, width, height=20, drawn=None):
    """The union of a recipe's components as page draws them (the darker pixel where parts overlap)."""
    frac = page.baseline - np.floor(page.baseline)
    lift = compose((1, 0, 0, 1, 0, -frac * UNIT), page.affine)
    baseline = np.floor(page.baseline)
    out = np.zeros((height, width), np.float32)
    for component in recipe:
        if component[0] == "path":
            part = DrawnSource(component[1])
            cover = part.coverage(PART, IDENTITY, (0.0, 0.0), lift, baseline, width, height)
        else:
            _, ch, affine, strength, clip, squash = component
            cover = source.coverage(ch, affine, strength, lift, baseline, width, height, squash)
            if clip:
                cover *= clip_mask(clip, compose(lift, affine), baseline, width, height)
        out = np.maximum(out, cover)
    return out


def error(source, recipe, page, ch):
    target = page.target(ch)
    return float(np.abs(render(source, recipe, page, target.shape[1]) - target).mean() / 255.0)


def descend(f, params, steps, rounds=3, bounds=None):
    """Coordinate descent with the steps halved each round."""
    params = list(params)
    best = f(params)
    steps = list(steps)
    for _ in range(rounds):
        improved = True
        while improved:
            improved = False
            for i in range(len(params)):
                for sign in (-1, 1):
                    trial = list(params)
                    trial[i] += sign * steps[i]
                    if bounds and not bounds[i][0] <= trial[i] <= bounds[i][1]:
                        continue
                    value = f(trial)
                    if value < best - 1e-7:
                        params, best, improved = trial, value, True
        steps = [s / 2 for s in steps]
    return params, best


# ---- Recipes ----

def component(ch, affine, strength=(0.0, 0.0), clip=None, squash=None):
    return ("kosugi", ch, tuple(affine), tuple(strength), clip, squash)


class Recipes:
    """Turns message_font.json into glyph recipes; needs Kosugi, never the disc."""

    def __init__(self, source, parameters):
        self.source = source
        self.p = parameters
        self.base = tuple(parameters[GLOBAL_KEY])

    def adjusted(self, ch, kx=1.0, ky=1.0, tx=0.0, ty=0.0, shear=0.0, weight=0.0):
        """ch scaled about its ink centre with its stems kept at their weight, sheared, moved, emboldened."""
        x0, y0, x1, y1 = self.source.ink(ch, self.base)
        cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
        affine = compose(compose(scale_about(kx, ky, cx, cy, tx, ty), (1, 0, shear, 1, -shear * cy, 0)), self.base)
        return component(ch, affine, (-(kx - 1) * STEM_X + weight, -(ky - 1) * STEM_Y + weight))

    def ascii(self, ch, override=None):
        p = dict(kx=1.0, ky=1.0, tx=0.0, ty=0.0, shear=0.0, weight=0.0)
        p.update(self.p["ascii"].get(ch, {}) if override is None else override)
        design = self.p.get("design", {}).get(ch, {}) if override is None else {}
        if "widen" in design:
            # Wider to the right by `widen` master units, the left edge where it was, stems kept.
            x0, _, x1, _ = self.source.ink(ch, self.adjusted(ch, **p)[2])
            k = (x1 - x0 + design["widen"]) / (x1 - x0)
            p["kx"] *= k
            p["tx"] += design["widen"] / 2
        letter = self.adjusted(ch, **p)
        if "squash_above" in design:
            letter = component(letter[1], letter[2], letter[3], None, tuple(design["squash_above"]))
        return letter

    def placed(self, ch, kx, ky, x, y, rotate=False):
        """ch scaled about its ink centre with stems kept, turned half a turn when asked, its ink centred on (x, y)."""
        affine = self.base
        if rotate:
            x0, y0, x1, y1 = self.source.ink(ch, affine)
            affine = compose((-1, 0, 0, -1, x0 + x1, y0 + y1), affine)
        x0, y0, x1, y1 = self.source.ink(ch, affine)
        affine = compose(scale_about(kx, ky, (x0 + x1) / 2, (y0 + y1) / 2), affine)
        x0, y0, x1, y1 = self.source.ink(ch, affine)
        return component(ch, compose((1, 0, 0, 1, x - (x0 + x1) / 2, y - (y0 + y1) / 2), affine),
                         (-(kx - 1) * STEM_X, -(ky - 1) * STEM_Y))

    # Accented letters: a base letter and a mark shaped once per mark, placed per case.

    @staticmethod
    def accented():
        """(char, base, mark, case) of each accented letter the European page draws."""
        out = []
        for cp in ACCENTED:
            parts = unicodedata.normalize("NFD", chr(cp))
            if len(parts) == 2 and parts[1] in MARKS:
                base = "ı" if parts[0] == "i" else parts[0]
                out.append((chr(cp), base, MARKS[parts[1]], "upper" if parts[0].isupper() else "lower"))
        return out

    def accent_base(self, base, case):
        ky, ty = self.p["accents"]["capital_squash"] if case == "upper" else (1.0, 0.0)
        _, name, affine, strength, _, _ = self.ascii(base)
        # Lowered about the baseline under a capital's accent, stems kept like any other correction.
        affine = compose((1, 0, 0, ky, 0, ty), affine)
        return component(name, affine, (strength[0], strength[1] - (ky - 1) * STEM_Y))

    def accent(self, ch, base, mark, case):
        b = self.accent_base(base, case)
        bx0, by0, bx1, by1 = self.source.ink(b[1], b[2])
        if mark == "ȷ":
            cedilla = self.p["cedilla"]
            path = cedilla_path(cedilla["length"], cedilla["width"], cedilla["depth"], cedilla["end"],
                                cedilla["weight"])
            return [b, ("path", path.transform(1, 0, 0, 1, (bx0 + bx1) / 2 + cedilla["dx"], by0))]
        shape = self.p["accents"]["shapes"][mark]
        dx, gap = self.p["accents"]["places"][f"{mark}|{case}"]
        if mark == "¨":
            size, spacing, keep = shape
            return [b] + [self.dot(size, keep, (bx0 + bx1) / 2 + dx + side * spacing / 2, by1 + gap)
                          for side in (-1, 1)]
        sx, sy, keep = shape
        mx0, my0, mx1, my1 = self.source.ink(mark, self.base)
        mcx, mcy = (mx0 + mx1) / 2, (my0 + my1) / 2
        scaled = compose(scale_about(sx, sy, mcx, mcy), self.base)
        _, sy0, _, _ = self.source.ink(mark, scaled)
        moved = compose((1, 0, 0, 1, (bx0 + bx1) / 2 + dx - mcx, by1 + gap - sy0), scaled)
        return [b, component(mark, moved, (-(sx - 1) * STEM_X * keep, -(sy - 1) * STEM_Y * keep))]

    def dot(self, size, keep, x, bottom):
        """One of Kosugi's full stops scaled by size, centred on x, its bottom at `bottom`."""
        px0, py0, px1, py1 = self.source.ink(".", self.base)
        pcx, pcy = (px0 + px1) / 2, (py0 + py1) / 2
        scaled = compose(scale_about(size, size, pcx, pcy), self.base)
        _, sy0, _, _ = self.source.ink(".", scaled)
        return component(".", compose((1, 0, 0, 1, x - pcx, bottom - sy0), scaled),
                         (-(size - 1) * STEM_X * keep, -(size - 1) * STEM_Y * keep))

    # Half-width glyphs of the European page that are not accented letters.

    def stem(self, x, top, bottom):
        """A stem of Kosugi's weight from top down to bottom, centred on x: a dotless i stretched."""
        sx0, sy0, sx1, sy1 = self.source.ink("ı", self.base)
        k = (top - bottom) / (sy1 - sy0)
        return component("ı", compose((1, 0, 0, k, x - (sx0 + sx1) / 2, bottom - k * sy0), self.base),
                         (0.0, -(k - 1) * STEM_Y))

    def eszett(self, v):
        """The retail ß is an upright β: a stem and the bowls of a 3, the 3 cut where it meets the stem."""
        x, bottom, kx, ky, bx, by = v
        bowls = self.placed("3", kx, ky, bx, by)
        a, _, _, _, e, _ = bowls[2]
        arch_top = self.source.ink(bowls[1], bowls[2])[3]
        return [self.stem(x, arch_top, bottom), component(bowls[1], bowls[2], bowls[3], ((x - e) / a, -400.0, 2000.0, 1200.0))]

    def turned(self, ch, v):
        """The master's ch turned half a turn about its ink centre and moved (tx, ty)."""
        letter = self.ascii(ch)
        x0, y0, x1, y1 = self.source.ink(letter[1], letter[2])
        tx, ty = v
        return [component(letter[1], compose((-1, 0, 0, -1, x0 + x1 + tx, y0 + y1 + ty), letter[2]), letter[3])]

    def marks(self, source, count, v):
        """count copies of one mark, `spacing` apart, centred on (x, y)."""
        k, x, y, spacing = v
        return [self.placed(source, k, k, x + (i - (count - 1) / 2) * spacing, y) for i in range(count)]

    def pair(self, first, second, v):
        """Two letters squeezed into one cell, the second overlapping the first by `overlap`."""
        k1, k2, ky, overlap, x0 = v
        a = self.placed(first, k1, ky, 0, 0)
        ax0, ay0, ax1, _ = self.source.ink(a[1], a[2])
        b = self.placed(second, k2, ky, 0, 0)
        bx0, by0, _, _ = self.source.ink(b[1], b[2])
        return [component(a[1], compose((1, 0, 0, 1, x0 - ax0, -ay0), a[2]), a[3]),
                component(b[1], compose((1, 0, 0, 1, x0 + (ax1 - ax0) - overlap - bx0, -by0), b[2]), b[3])]

    def half_width(self, ch):
        entry = self.p["half_width"][ch]
        kind, v = entry["kind"], entry["params"]
        if kind == "single":
            return [self.placed(entry["source"], *v, rotate=False)]
        if kind == "turned":
            return self.turned(entry["source"], v)
        if kind == "marks":
            return self.marks(entry["source"], entry["count"], v)
        if kind == "pair":
            return self.pair(entry["source"][0], entry["source"][1], v)
        if kind == "eszett":
            return self.eszett(v)
        raise ValueError(f"{ch}: unknown kind {kind}")

    def full_width(self, ch):
        return [self.placed(ch, *self.p["full_width"][ch])]

    def glyphs(self):
        """Every glyph: code point -> (advance, components)."""
        table = {" ": (HALF, []), "\u3000": (FULL, [])}
        for ch in ASCII:
            table[ch] = (HALF, [self.ascii(ch)])
        for ch, base, mark, case in self.accented():
            table[ch] = (HALF, self.accent(ch, base, mark, case))
        for ch in self.p["half_width"]:
            table[HALF_MIDDLE_DOT if ch == "・" else ch] = (HALF, self.half_width(ch))
        for ch in self.p["full_width"]:
            table[ENGLISH_VARIANTS.get(ch, ch)] = (FULL, self.full_width(ch))
        return table


def load_parameters(path=PARAMETERS):
    with open(path, encoding="utf-8") as f:
        return json.load(f)
