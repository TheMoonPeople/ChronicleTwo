"""The pause menu's painted lettering as outline fonts: ChronicleTwoMenu for its words (menu_font.json) and
ChronicleTwoBoard for the time board's (board_font.json), each made from open fonts.

Master space is the menu atlas's texels at 64 units each: a word's pen starts on its cell's left edge, `start`
texels in, and its baseline lies `baseline` rows down the cell. A font's default source reaches it through one
affine (`em` texels an em, `stretch` times as wide), another source through its own, and each fitted letter
through its own correction on top. fit_menu_font.py measures the numbers against the user's own extraction;
build_menu_font.py turns them into the font. Needs freetype-py, fonttools, skia-pathops and numpy
(scripts/font/requirements.txt).
"""
import hashlib
import json
import math
import os
import sys
import tempfile
import unicodedata
import urllib.request
from pathlib import Path

import numpy as np
import pathops
from fontTools.pens.recordingPen import DecomposingRecordingPen, RecordingPen
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont

sys.path.insert(0, str(Path(__file__).resolve().parent))
import message_font as mf  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
PARAMETERS = Path(__file__).resolve().parent / "menu_font.json"
BOARD_PARAMETERS = Path(__file__).resolve().parent / "board_font.json"
TITLE_PARAMETERS = Path(__file__).resolve().parent / "title_font.json"
FONT = ROOT / "port/assets/fonts/ChronicleTwoMenu-Regular.ttf"
LAYOUT = ROOT / "port/gameplay/menu/1/men0.pac/menu0.cfg.json"  # the English menu's cells

UNIT = 64  # master units a texel
CELL_W, CELL_H = 112, 24

# The fonts the letters are drawn from, as google/fonts publishes them (SIL Open Font License 1.1): file, URL at
# a pinned revision, SHA-256. A font's default source draws everything its parameters give no other.
SOURCES = {
    "libre_franklin": ("LibreFranklin[wght].ttf",
                       "https://raw.githubusercontent.com/google/fonts/e2332cf862ac3145c0ee5f24f04f4c1819b2410b/"
                       "ofl/librefranklin/LibreFranklin%5Bwght%5D.ttf",
                       "2329f394b10ed1c71107df20fddc11e2bb1b68c1ecbb385f975b36fd64a971f8"),
    "jost": ("Jost[wght].ttf",
             "https://raw.githubusercontent.com/google/fonts/6e4b84c976cadb3c49a40fd9a1c203e4f7fcf2da/"
             "ofl/jost/Jost%5Bwght%5D.ttf",
             "6343b70971000b04c5d401c96ae08ce371086135e999d5e1e1413039c0213076"),
    "yanone_kaffeesatz": ("YanoneKaffeesatz[wght].ttf",
                          "https://raw.githubusercontent.com/google/fonts/a1f61ce2c7aac279c317534f2dddd219ef11a1b9/"
                          "ofl/yanonekaffeesatz/YanoneKaffeesatz%5Bwght%5D.ttf",
                          "17e3bd546d57d2c41200866ac310bd76b8c59c44cd738f6ca402a285f45e97b8"),
    "roboto_condensed": ("RobotoCondensed[wght].ttf",
                         "https://raw.githubusercontent.com/google/fonts/69d0549e8fc7ad72e1531734c81237be401ec4fd/"
                         "ofl/robotocondensed/RobotoCondensed%5Bwght%5D.ttf",
                         "dace262afcee68a5276f200d8026c57221735c0118ab5fda8c2c0d3dc409a8d0"),
    "fjalla_one": ("FjallaOne-Regular.ttf",
                   "https://raw.githubusercontent.com/google/fonts/a60a77e14f28abd4ef243a1b5dfc48df0cec5205/"
                   "ofl/fjallaone/FjallaOne-Regular.ttf",
                   "ce3b299625abe3c76f8acd235b57b3e07ac6ee2d550e106a4b4e4d60095ae2ba"),
    "antonio": ("Antonio[wght].ttf",
                "https://raw.githubusercontent.com/google/fonts/95f4904fc8bcf26d3420fe315560c96417c6dec7/"
                "ofl/antonio/Antonio%5Bwght%5D.ttf",
                "9e95a2258ecdf3e45c72c5bbea1c4cd350e8f7bebc87c9dba53b29b1890b8903"),
    "sawarabi_gothic": ("SawarabiGothic-Regular.ttf",
                        "https://raw.githubusercontent.com/google/fonts/7bfa8c0bdd1a33f4b34dd05aba830ad40742ef1e/"
                        "ofl/sawarabigothic/SawarabiGothic-Regular.ttf",
                        "04f2f9111bb69cb8d3706c27b44879c2c0fac593a11edf5cfe8cec1efc92c789"),
    "mplus_1p": ("MPLUS1p-Regular.ttf",
                 "https://raw.githubusercontent.com/google/fonts/d714b17ce2379f06daf6295617f961df605dccb5/"
                 "ofl/mplus1p/MPLUS1p-Regular.ttf",
                 "2f294ad496432b1608f070d310e3aa2adcf1de4af429f4901df97ec4bd361ed1"),
    # The port's own message font (Apache License 2.0), read from port/assets/fonts rather than fetched.
    "chronicletwo_message": ("ChronicleTwoMessage-Regular.ttf", None,
                             "d4b63a196a5eda346cabae7afcba9b6f055db73309ff0d1830a658b182d8a44b"),
}

# The words the English atlas paints, by the name of their cell.
WORDS = {"mi_item_ic": "Item", "mi_chr_ic": "Character", "mi_invent_ic": "Make", "mi_move_ic": "Move",
         "mi_op_ic": "Options", "mi_mn_ic": "Help", "mi_hatena_ic": "???"}
# The characters the font holds.
CHARACTERS = [chr(c) for c in range(0x20, 0x7F)]
# The painted letters' colours: the lit fill, and the rim and shadow behind it; the time board's are its lit
# figures and the shadow a texel right and down.
FILL, RIM = 217.0, 29.0
BOARD_FILL, BOARD_SHADOW = 205.0, 10.0
# The time board's painted words and figures (menu0.cfg's "timeboard"), by the name of their cell. Its figures are
# one strip, a 16-texel cell each.
BOARD_WORDS = {"日目": "Day", "未来": "Future", "AM": "AM", "PM": "PM", "::": ":"}
BOARD_FIGURES = "時間数"

GLYPH_DEFAULTS = {"kx": 1.0, "ky": 1.0, "tx": 0.0, "ty": 0.0, "shear": 0.0, "weight": 0.0, "advance": 0.0}


def cached(name):
    """Where source `name` is cached (the port's own fonts are where the port keeps them); it may not be there
    yet."""
    if SOURCES[name][1] is None:
        return ROOT / "port/assets/fonts" / SOURCES[name][0]
    return Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "chronicletwo" / SOURCES[name][0]


def source_path(name, path=None):
    """Source `name`: path if given, else fetched once into the cache; checked against its pinned SHA-256."""
    file, url, sha256 = SOURCES[name]
    if path is None:
        path = cached(name)
        if not path.exists() and url is not None:
            path.parent.mkdir(parents=True, exist_ok=True)
            with urllib.request.urlopen(url) as response:
                path.write_bytes(response.read())
    digest = hashlib.sha256(Path(path).read_bytes()).hexdigest()
    if digest != sha256:
        raise SystemExit(f"{path}: SHA-256 {digest}, expected {sha256}")
    return Path(path)


class Sources(dict):
    """{name: MenuSource} of the parameters' sources, prepared into temporary files deleted on exit."""

    def __init__(self, parameters, paths=None):
        super().__init__()
        self.files = []
        radii = parameters.get("rounding", {})
        default = default_source(parameters)
        for name, spec in parameters["sources"].items():
            # A source is its weight, or {"weight", and the "em" and "stretch" it is drawn at instead of the font's}.
            spec = spec if isinstance(spec, dict) else {"weight": spec}
            rounding = {ch: radii.get(name, 0) for ch in CHARACTERS}
            file = prepared(source_path(name, (paths or {}).get(name)), spec["weight"], parameters.get("flare"),
                            rounding)
            self.files.append(file)
            warps = {ch: p["warp"] for ch in set(parameters["glyphs"]) | set(characters(parameters))
                     if "warp" in (p := corrections(parameters, ch)) and p.get("source", default) == name}
            self[name] = MenuSource(file, warps)
            self[name].scale = {k: spec[k] for k in ("em", "stretch") if k in spec}

    def add(self, name, path, weight, flare=None):
        file = prepared(path, weight, flare)
        self.files.append(file)
        self[name] = MenuSource(file)
        return self[name]

    def __enter__(self):
        return self

    def __exit__(self, *exc):
        for file in self.files:
            os.unlink(file)


def load_parameters(path=PARAMETERS):
    return json.loads(Path(path).read_text())


def font_path(parameters):
    """Where a font's parameters build it."""
    return ROOT / "port/assets/fonts" / f"{parameters['family']}-Regular.ttf"


def characters(parameters):
    """The characters a font holds: ASCII, and the parameters' "extra_characters"."""
    return CHARACTERS + list(parameters.get("extra_characters", ""))


def corrections(parameters, ch):
    """A letter's corrections: its own, or where it has none, those of the letter it is accented from, so an é is
    drawn as its e is."""
    glyphs = parameters["glyphs"]
    if ch in glyphs:
        return glyphs[ch]
    base = unicodedata.normalize("NFD", ch)[0]
    return glyphs.get(base, {}) if base != ch else {}


def default_source(parameters):
    return parameters.get("default_source", "libre_franklin")


# ---- Flared stroke ends ----

def _sub(a, b):
    return (a[0] - b[0], a[1] - b[1])


def _add(a, b):
    return (a[0] + b[0], a[1] + b[1])


def _mul(a, k):
    return (a[0] * k, a[1] * k)


def _dot(a, b):
    return a[0] * b[0] + a[1] * b[1]


def _unit(v):
    n = math.hypot(*v)
    return (v[0] / n, v[1] / n) if n else (0.0, 0.0)


def _intersect(p, d, q, e):
    den = d[0] * e[1] - d[1] * e[0]
    if abs(den) < 1e-6:
        return None
    t = ((q[0] - p[0]) * e[1] - (q[1] - p[1]) * e[0]) / den
    return _add(p, _mul(d, t))


def _contours(recording):
    out, current, start, last = [], [], None, None
    for op, args in recording.value:
        if op == "moveTo":
            current, start = [], args[0]
            last = start
        elif op in ("lineTo", "qCurveTo", "curveTo"):
            current.append((op, last, args))
            last = args[-1]
        elif op in ("closePath", "endPath"):
            if last != start:
                current.append(("lineTo", last, (start,)))
            out.append(current)
    return out


def _chord(segment):
    return math.hypot(*_sub(segment[2][-1], segment[1]))


def flares(recording, stem, width, length, corner=40):
    """A concave wedge at both corners of each straight stroke end: a straight segment about a stem across
    whose two sides, past any small corner rounding, are straight and run away from it side by side. Each
    wedge reaches `width` past the corner along the end and curves back into the side `length` from it; a
    side shorter than that (a t above its bar) takes a shorter, narrower one."""
    wedges = []
    for contour in _contours(recording):
        points = [p for segment in contour for p in (segment[1],) + tuple(segment[2])]
        xs, ys = [p[0] for p in points], [p[1] for p in points]
        if max(xs) - min(xs) < 2 * stem and max(ys) - min(ys) < 2 * stem:
            continue  # a dot or a stop: no strokes
        n = len(contour)
        for i, segment in enumerate(contour):
            if segment[0] != "lineTo":
                continue
            a, b = segment[1], segment[2][0]
            if not 0.45 * stem <= math.hypot(*_sub(b, a)) <= 1.7 * stem:
                continue
            along = _unit(_sub(b, a))
            after, before = (i + 1) % n, (i - 1) % n
            for _ in range(3):
                if contour[after][0] == "lineTo" or _chord(contour[after]) >= corner:
                    break
                after = (after + 1) % n
            for _ in range(3):
                if contour[before][0] == "lineTo" or _chord(contour[before]) >= corner:
                    break
                before = (before - 1) % n
            side_b, side_a = contour[after], contour[before]
            if (side_b[0] != "lineTo" or side_a[0] != "lineTo" or _chord(side_b) < 0.5 * stem
                    or _chord(side_a) < 0.5 * stem):
                continue
            leave_b = _unit(_sub(side_b[2][0], side_b[1]))
            leave_a = _unit(_sub(side_a[1], side_a[2][0]))
            if abs(_dot(leave_b, along)) > 0.5 or abs(_dot(leave_a, along)) > 0.5 or _dot(leave_a, leave_b) < 0.6:
                continue
            corner_a = _intersect(a, along, side_a[2][0], leave_a)
            corner_b = _intersect(b, along, side_b[1], leave_b)
            if corner_a is None or corner_b is None:
                continue
            for p, out, leave, side in ((corner_a, _mul(along, -1), leave_a, _chord(side_a)),
                                        (corner_b, along, leave_b, _chord(side_b))):
                reach = min(length, 0.8 * side)
                far = _add(p, _mul(leave, reach))
                inner = _mul(out, -0.35 * stem)
                wedge = pathops.Path()
                pen = wedge.getPen()
                pen.moveTo(_add(p, _mul(out, width * reach / length)))
                pen.qCurveTo(p, far)
                pen.lineTo(_add(far, inner))
                pen.lineTo(_add(p, inner))
                pen.closePath()
                wedges.append(wedge)
    return wedges


# ---- Rounded corners ----

def _segments(path):
    """Each contour of a pathops path as [("line", p0, p1) or ("quad", p0, control, p1)], its implied on-curve
    points made explicit."""
    recording = RecordingPen()
    path.draw(recording)
    contours, current, start, last = [], [], None, None
    for op, args in recording.value:
        if op == "moveTo":
            current, start = [], args[0]
            last = start
        elif op == "lineTo":
            current.append(("line", last, args[0]))
            last = args[0]
        elif op == "qCurveTo":
            controls, end = list(args[:-1]), args[-1]
            if end is None:  # a closed contour of off-curve points only
                end = _mul(_add(controls[-1], controls[0]), 0.5)
                current, last = [], end
            for i, control in enumerate(controls):
                to = end if i == len(controls) - 1 else _mul(_add(control, controls[i + 1]), 0.5)
                current.append(("quad", last, control, to))
                last = to
        elif op in ("closePath", "endPath"):
            if current and last != current[0][1]:
                current.append(("line", last, current[0][1]))
            if current:
                contours.append(current)
            current = []
    return contours


def _point(segment, t):
    if segment[0] == "line":
        return _add(segment[1], _mul(_sub(segment[2], segment[1]), t))
    _, a, c, b = segment
    return _add(_add(_mul(a, (1 - t) ** 2), _mul(c, 2 * t * (1 - t))), _mul(b, t * t))


def _split(segment, t):
    """The two halves of a segment at parameter t."""
    if segment[0] == "line":
        m = _point(segment, t)
        return ("line", segment[1], m), ("line", m, segment[2])
    _, a, c, b = segment
    ac, cb = _add(a, _mul(_sub(c, a), t)), _add(c, _mul(_sub(b, c), t))
    m = _add(ac, _mul(_sub(cb, ac), t))
    return ("quad", a, ac, m), ("quad", m, cb, b)


def _at_distance(segment, d, from_end):
    """The parameter where the segment is d from its start (or end), measured straight."""
    origin = segment[-1] if from_end else segment[1]
    lo, hi = (0.0, 1.0)
    for _ in range(30):
        mid = (lo + hi) / 2
        t = 1 - mid if from_end else mid
        if math.hypot(*_sub(_point(segment, t), origin)) < d:
            lo = mid
        else:
            hi = mid
    return 1 - lo if from_end else lo


def _tangent(segment, at_end):
    if segment[0] == "line":
        return _unit(_sub(segment[2], segment[1]))
    _, a, c, b = segment
    return _unit(_sub(b, c) if at_end else _sub(c, a))


def rounded(path, radius, turn=20.0):
    """The path with each outer corner sharper than `turn` degrees rounded off: both its sides cut back `radius`
    (at most 45% of either) and joined by a curve through the corner. Inner corners stay sharp, and no stroke
    loses weight, so a square stroke end comes back round and a sharp point (an M's apex) blunt."""
    if radius <= 0:
        return path
    out = pathops.Path()
    pen = out.getPen()
    for contour in _segments(path):
        n = len(contour)
        # The filled side is on the left of a simplified outline, so a left turn is an outer corner.
        corner = []
        for i in range(n):
            before, after = _tangent(contour[i - 1], True), _tangent(contour[i], False)
            cross = before[0] * after[1] - before[1] * after[0]
            angle = math.degrees(math.acos(max(-1.0, min(1.0, _dot(before, after)))))
            corner.append(cross > 0 and angle > turn)
        lengths = [math.hypot(*_sub(s[-1], s[1])) for s in contour]
        cut = [min(radius, 0.45 * lengths[i - 1], 0.45 * lengths[i]) if corner[i] else 0.0 for i in range(n)]
        trimmed = []
        for i, segment in enumerate(contour):
            start_cut, end_cut = cut[i], cut[(i + 1) % n]
            t0 = _at_distance(segment, start_cut, False) if start_cut else 0.0
            t1 = _at_distance(segment, end_cut, True) if end_cut else 1.0
            piece = segment
            if t1 < 1.0:
                piece = _split(piece, t1)[0]
            if t0 > 0.0:
                piece = _split(piece, t0 / t1 if t1 else 0.0)[1]
            trimmed.append(piece)
        pen.moveTo(trimmed[0][1])
        for i, piece in enumerate(trimmed):
            if piece[0] == "line":
                pen.lineTo(piece[2])
            else:
                pen.qCurveTo(piece[2], piece[3])
            following = (i + 1) % n
            if cut[following]:
                pen.qCurveTo(contour[following][1], trimmed[following][1])
        pen.closePath()
    return out


# ---- Drawn letters ----

QUESTION_KEYS = ["cx", "cy", "rx", "ry", "weight", "start", "end", "stem_x", "stem_top", "stem_bottom", "drop", "dot",
                 "dot_y", "advance"]


def _circle(path, centre, radius):
    k = 0.5523 * radius  # a quarter circle's cubic control distance
    x, y = centre
    pen = path.getPen()
    pen.moveTo((x + radius, y))
    pen.curveTo((x + radius, y + k), (x + k, y + radius), (x, y + radius))
    pen.curveTo((x - k, y + radius), (x - radius, y + k), (x - radius, y))
    pen.curveTo((x - radius, y - k), (x - k, y - radius), (x, y - radius))
    pen.curveTo((x + k, y - radius), (x + radius, y - k), (x + radius, y))
    pen.closePath()


def question_mark(q):
    """The painted question mark, in master units from the pen on the baseline: a hood, an arc about (cx, cy)
    stroked `weight` wide from `start` degrees over the top to `end`, its left end hanging into a round drop;
    a stem sweeping from the hood's end down to `stem_top` and on to `stem_bottom` at stem_x; and a round dot."""
    def at(angle):
        a = math.radians(angle)
        return (q["cx"] + q["rx"] * math.cos(a), q["cy"] + q["ry"] * math.sin(a))

    steps = 48
    centreline = [at(q["start"] + (q["end"] - q["start"]) * i / steps) for i in range(steps + 1)]
    end = centreline[-1]
    a = math.radians(q["end"])
    heading = _unit((q["rx"] * math.sin(a), -q["ry"] * math.cos(a)))  # clockwise along the arc
    reach = abs(end[1] - q["stem_top"]) / 2
    c1 = _add(end, _mul(heading, reach))
    c2 = (q["stem_x"], q["stem_top"] + reach)
    to = (q["stem_x"], q["stem_top"])
    for i in range(1, steps + 1):
        u = i / steps
        centreline.append(tuple(end[k] * (1 - u) ** 3 + 3 * c1[k] * u * (1 - u) ** 2 + 3 * c2[k] * u * u * (1 - u)
                                + to[k] * u ** 3 for k in range(2)))
    centreline.append((q["stem_x"], q["stem_bottom"]))
    stroke = pathops.Path()
    pen = stroke.getPen()
    pen.moveTo(centreline[0])
    for point in centreline[1:]:
        pen.lineTo(point)
    pen.endPath()
    stroke.stroke(q["weight"], pathops.LineCap.BUTT_CAP, pathops.LineJoin.ROUND_JOIN, 4)
    stroke.convertConicsToQuads()
    parts = pathops.Path()
    _circle(parts, centreline[0], q["drop"])
    _circle(parts, (q["stem_x"], q["dot_y"]), q["dot"])
    return pathops.op(pathops.simplify(stroke, fix_winding=True), parts, pathops.PathOp.UNION, fix_winding=True)


_drawn = {}


def drawn(q):
    """A source drawing question_mark(q) at mf.PART, kept for the parameters it was drawn with."""
    key = tuple(q[k] for k in QUESTION_KEYS)
    if key not in _drawn:
        if len(_drawn) > 64:
            _drawn.clear()
        _drawn[key] = mf.DrawnSource(question_mark(q))
    return _drawn[key]


# ---- Sources ----

def prepared(path, weight=None, flare=None, rounding=None):
    """A static font of path, its `weight` instance if it varies, its stroke ends flared when `flare` says so and
    its corners rounded by `rounding` ({character: radius in its units}), saved to a temporary file (the caller
    deletes it)."""
    font = TTFont(path)
    if "fvar" in font:
        axes = {axis.axisTag: axis.defaultValue for axis in font["fvar"].axes}
        if weight is not None and "wght" in axes:
            axes["wght"] = weight
        font = instantiateVariableFont(font, axes)
    if flare or rounding:
        import build_message_font as bmf
        glyph_set = font.getGlyphSet()
        glyf = font["glyf"]
        new = {}
        cmap = font.getBestCmap()
        for ch in CHARACTERS:
            name = cmap.get(ord(ch))
            if name is None or name in new or not (flare or (rounding or {}).get(ch)):
                continue
            recording = DecomposingRecordingPen(glyph_set)
            glyph_set[name].draw(recording)
            if not recording.value:
                continue
            path_ = pathops.Path()
            recording.replay(path_.getPen())
            if flare:
                for wedge in flares(recording, flare["stem"], flare["width"], flare["length"]):
                    path_ = pathops.op(path_, wedge, pathops.PathOp.UNION, fix_winding=True)
            if rounding and rounding.get(ch):
                path_ = rounded(pathops.simplify(path_, fix_winding=True), rounding[ch])
            new[name] = bmf.tt_glyph(path_)
        for name, glyph in new.items():
            glyf[name] = glyph
            advance, _ = font["hmtx"][name]
            font["hmtx"][name] = (advance, glyph.xMin if glyph.numberOfContours else 0)
    handle, name = tempfile.mkstemp(suffix=".ttf")
    os.close(handle)
    font.save(name)
    return name


class MenuSource(mf.Source):
    """A prepared font, with its advances and units per em, the em and stretch it is drawn at where they are its
    own, and its letters' warps (a letter's "warp" in the parameters): the points inside a region, in master units
    from the pen, scaled and sheared about a point, one warp after another. Warps are design over the fit (an r's hook lowered, a t's tail lengthened),
    applied wherever the letter is drawn."""

    def __init__(self, path, warps=None):
        super().__init__(path)
        self.warps = warps or {}
        self.scale = {}
        font = TTFont(path)
        self.units_per_em = font["head"].unitsPerEm
        self.ascent, self.descent = font["hhea"].ascent, font["hhea"].descent
        cmap = font.getBestCmap()
        self.advances = {chr(c): font["hmtx"][name][0] for c, name in cmap.items()}

    def outline(self, ch, affine, strength=(0.0, 0.0), squash=None):
        raw = super().outline(ch, affine, strength, squash)
        for warp in self.warps.get(ch, ()):
            x0, y0, x1, y1 = warp["region"]
            sx, sy = warp.get("scale", (1.0, 1.0))
            hx, hy = warp.get("shear", (0.0, 0.0))  # x moved by y, and y by x, about the point
            ax, ay = warp["about"]
            for i in range(raw.n_points):
                point = raw.points[i]
                if x0 <= point.x <= x1 and y0 <= point.y <= y1:
                    x, y = point.x - ax, point.y - ay
                    point.x = int(round(ax + x * sx + y * hx))
                    point.y = int(round(ay + y * sy + x * hy))
        return raw


def base(source, g):
    """The affine from a source's units to master space, before a letter's own correction."""
    scale = g["em"] * UNIT / source.units_per_em
    return (scale * g["stretch"], 0.0, 0.0, scale, 0.0, 0.0)


def letter(source, ch, g, p):
    """(affine, strength, advance) of ch in master space with correction p: scaled across about its ink centre and
    up from the baseline, so it keeps the baseline, its stems emboldened back towards their weight, sheared about
    its middle, moved across; the advance moved by p["advance"]."""
    p = {**GLYPH_DEFAULTS, **p}
    g = {**g, **source.scale}
    affine0 = base(source, g)
    if ch.isspace():
        cx = cy = 0.0  # no ink to scale about
    else:
        x0, y0, x1, y1 = source.ink(ch, affine0)
        cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    affine = mf.compose(mf.compose(mf.scale_about(p["kx"], p["ky"], cx, 0.0, p["tx"], p["ty"]),
                                   (1, 0, p["shear"], 1, -p["shear"] * cy, 0)), affine0)
    # A stem keeps its weight when its letter is scaled: embolden back by what the scale took.
    stem = g["stem"]
    strength = (g["weight"] + p["weight"] + stem * (1 - p["kx"]) * g["stretch"],
                g["weight"] + p["weight"] + stem * (1 - p["ky"]))
    advance = source.advances.get(ch, 0) * affine0[0] + p["advance"]
    return affine, strength, advance


def advance_of(sources, ch, parameters):
    """How far ch moves the pen in master units, as render_word sets it."""
    p = corrections(parameters, ch)
    if p.get("source") == "drawn":
        return p["drawn"]["advance"]
    return letter(sources[p.get("source", default_source(parameters))], ch, parameters["global"], p)[2]


def render_word(sources, word, parameters, width=CELL_W, height=CELL_H):
    """Coverage (0 to 255) of a word set in its cell, as the fitted font draws it."""
    default = default_source(parameters)
    g = parameters["global"]
    # Each word was painted on its own, and may sit a fraction of a texel off the others; the fitter measures that
    # as the word's offset so the letters need not take it up. The font ignores it.
    dx, dy = parameters.get("words", {}).get(word, (0.0, 0.0))
    baseline = g["baseline"] + dy
    frac = baseline - math.floor(baseline)
    row = math.floor(baseline)
    pen = (g["start"] + dx) * UNIT
    if parameters.get("centred"):
        # Words centred in their cells: "start" is the middle, which the word's advances straddle.
        pen -= sum(advance_of(sources, ch, parameters) for ch in word) / 2
    out = np.zeros((height, width), np.float32)
    for ch in word:
        p = corrections(parameters, ch)
        page = (1, 0, 0, 1, pen, -frac * UNIT)
        if p.get("source") == "drawn":
            cover = drawn(p["drawn"]).coverage(mf.PART, mf.IDENTITY, (0.0, 0.0), page, row, width, height)
            advance = p["drawn"]["advance"]
        else:
            source = sources[p.get("source", default)]
            affine, strength, advance = letter(source, ch, g, p)
            cover = source.coverage(ch, affine, strength, page, row, width, height) if ch != " " else 0
        if "clip" in p:
            # Only the ink inside the box (master units from the pen) is kept: an end cut off.
            cover = cover * mf.clip_mask(tuple(p["clip"]), page, row, width, height)
        out = np.maximum(out, cover)
        pen += advance
    return out


# ---- The atlas, for fitting: disc data, read from the user's own extraction ----

def cells(layout=LAYOUT):
    """{cell name: (x, y, w, h)} of the menu atlas's word cells."""
    for op in json.loads(Path(layout).read_text())["operations"]:
        if op.get("op") == "texture_sheet" and op.get("sheet") == "mnmain":
            return {t["name"]: tuple(t["rect"]) for t in op["textures"] if t["name"] in WORDS}
    raise SystemExit(f"{layout}: no mnmain sheet")


def _atlas(extraction):
    import io

    from PIL import Image
    return np.array(Image.open(io.BytesIO(extraction.read("textures/menu/1/frametex_1.png"))).convert("RGBA"),
                    np.float32)


def _rects(layout=LAYOUT):
    for op in json.loads(Path(layout).read_text())["operations"]:
        if op.get("op") == "texture_sheet" and op.get("sheet") == "mnmain":
            return {t["name"]: tuple(t["rect"]) for t in op["textures"]}
    raise SystemExit(f"{layout}: no mnmain sheet")


# The English title atlas's buttons (moji in title1.img): each label's cell, and the row its plate starts on.
TITLE_BUTTONS = {"New Game": (302, 40, 41), "Continue": (302, 94, 95), "Install": (302, 148, 149),
                 "Options": (302, 204, 203), "Extras": (302, 256, 257), "Free Race": (92, 202, 203),
                 "Spheda Practice Area": (92, 256, 257)}
# A plate is 208 by 52 texels; its lettering lies in its flat middle, lit 230 over a fill of 57.
PLATE_W, PLATE_H = 208, 52
TITLE_FILL, TITLE_GROUND = 230.0, 57.0


def title_targets(extraction):
    """{label: how lit each texel of its plate's middle is, 0 to 1, between the plate's fill and the lettering's}."""
    import io

    from PIL import Image
    atlas = np.array(Image.open(io.BytesIO(extraction.read("textures/title/title1_1.png"))).convert("RGBA"), np.float32)
    lit = np.clip((atlas[..., :3].mean(2) - TITLE_GROUND) / (TITLE_FILL - TITLE_GROUND), 0, 1)
    out = {}
    for text, (x, _, plate_y) in TITLE_BUTTONS.items():
        plate = lit[plate_y:plate_y + PLATE_H, x + 1:x + 1 + PLATE_W].copy()
        # The frame is lit too: only the middle, inside its bevels, is lettering.
        plate[:10], plate[42:], plate[:, :17], plate[:, 191:] = 0, 0, 0, 0
        out[text] = plate
    return out


def targets(extraction, parameters=None):
    """{text: how lit each texel of its cell is, 0 to 1, between the shadow and the fill}: the pause menu's words,
    with board parameters the time board's words and each of its figures, or with title parameters the title
    menu's buttons."""
    if (parameters or {}).get("kind") == "title":
        return title_targets(extraction)
    atlas = _atlas(extraction)
    rects = _rects()
    if (parameters or {}).get("kind") == "board":
        lit = np.clip((atlas[..., :3].mean(2) - BOARD_SHADOW) / (BOARD_FILL - BOARD_SHADOW), 0, 1) * (atlas[..., 3] > 0)
        out = {}
        for name, text in BOARD_WORDS.items():
            x, y, w, h = rects[name]
            out[text] = lit[y:y + min(h, CELL_H), x:x + w]
        x, y, w, h = rects[BOARD_FIGURES]
        for figure in "0123456789":
            i = int(figure)
            out[figure] = lit[y:y + h, x + i * w:x + (i + 1) * w]
        return out
    lit = np.clip((atlas[..., :3].mean(2) - RIM) / (FILL - RIM), 0, 1) * (atlas[..., 3] > 0)
    return {WORDS[name]: lit[y:y + h, x:x + w] for name, (x, y, w, h) in cells().items()}
