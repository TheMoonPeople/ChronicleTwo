#!/usr/bin/env python3
"""Build port/assets/fonts/ChronicleTwoMessage-Regular.ttf from Kosugi and scripts/font/message_font.json.

Each Kosugi component goes through the FreeType steps the fitter rendered (the affine, then the stem
offset), is read back point for point, clipped where its recipe says, and a glyph's parts are merged into
one outline. Needs freetype-py, fonttools and skia-pathops (scripts/font/requirements.txt), and fetches
Kosugi once into ~/.cache/chronicletwo. No game data is read.
"""
import argparse
import sys
from pathlib import Path

import pathops
from fontTools import agl
from fontTools.fontBuilder import FontBuilder
from fontTools.misc.timeTools import timestampFromString
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.pointPen import PointToSegmentPen
from fontTools.pens.recordingPen import RecordingPen
from fontTools.pens.reverseContourPen import ReverseContourPen
from fontTools.pens.ttGlyphPen import TTGlyphPen

sys.path.insert(0, str(Path(__file__).resolve().parent))
import message_font as mf  # noqa: E402

FAMILY = "ChronicleTwoMessage"
VERSION = "1.000"
VERSION_DATE = "Sat Oct 24 00:00:00 2026"


def kosugi_part(source, ch, affine, strength, clip, squash):
    """A Kosugi component as the fitter rendered it, as a pathops path in master units."""
    raw = source.outline(ch, affine, strength, squash)
    path = pathops.Path()
    pen = PointToSegmentPen(path.getPen())
    start = 0
    for c in range(raw.n_contours):
        end = raw.contours[c]
        pen.beginPath()
        previous_on = bool(raw.tags[end] & 1)
        for i in range(start, end + 1):
            on = bool(raw.tags[i] & 1)
            pen.addPoint((raw.points[i].x, raw.points[i].y), ("line" if previous_on else "qcurve") if on else None)
            previous_on = on
        pen.endPath()
        start = end + 1
    if clip:
        a, _, _, d, e, f = affine
        x0, y0, x1, y1 = clip
        xs = sorted((a * x0 + e, a * x1 + e))
        ys = sorted((d * y0 + f, d * y1 + f))
        box = pathops.Path()
        box.moveTo(xs[0], ys[0])
        box.lineTo(xs[1], ys[0])
        box.lineTo(xs[1], ys[1])
        box.lineTo(xs[0], ys[1])
        box.close()
        path = pathops.op(path, box, pathops.PathOp.INTERSECTION)
    return path


def outline(source, components):
    merged = pathops.Path()
    for component in components:
        part = component[1] if component[0] == "path" else kosugi_part(source, *component[1:])
        merged = pathops.op(merged, part, pathops.PathOp.UNION)
    return merged


def side_profiles(path, bottom, top, step=8):
    """Leftmost and rightmost ink at each sampled height between bottom and top, None where a row is blank."""
    x0, _, x1, _ = path.bounds
    rows = []
    for y in range(int(bottom) + step // 2, int(top), step):
        xs = [x for x in range(int(x0) - 1, int(x1) + 2, 2) if path.contains((x, y))]
        rows.append((xs[0], xs[-1]) if xs else None)
    return rows


def spacing(ch, path, spacing_parameters, x_height, cap_height):
    """(shift, advance): how far to move ch so its sidebearings balance its neighbours', and its width.

    Each side's white is averaged over the glyph's zone (the x-height for lower case, the cap height for
    capitals, its own ink for punctuation), counting openings no deeper than `depth`; the sidebearing
    tops that white up to what a straight stem gets, `stem_sidebearing` (HT Letterspacer's method).
    """
    x0, y0, x1, y1 = path.bounds
    if ch.isupper() or ch in "\u00c6\u0152":
        bottom, top = 0, cap_height
    elif ch.isalpha():
        bottom, top = 0, x_height
    else:
        bottom, top = max(0, y0), min(cap_height, y1)
    if top <= bottom:
        bottom, top = y0, y1
    rows = side_profiles(path, bottom, top)
    inked = [r for r in rows if r]
    if not inked:
        return 0, mf.HALF
    left, right = min(r[0] for r in inked), max(r[1] for r in inked)
    depth = spacing_parameters["depth"]
    white_left = sum(min(r[0] - left, depth) if r else depth for r in rows) / len(rows)
    white_right = sum(min(right - r[1], depth) if r else depth for r in rows) / len(rows)
    stem = spacing_parameters["stem_sidebearing"]
    lsb, rsb = stem - white_left, stem - white_right
    return lsb - left, int(round(lsb + (right - left) + rsb))


def signed_area(recording):
    """Twice the signed area of a recorded outline's on-curve polygon; positive runs counter-clockwise."""
    total, first, last = 0.0, None, None
    for op, args in recording.value:
        if op == "qCurveTo" and args[-1] is None:
            # A closed contour of off-curve points only: its control polygon turns the same way.
            total += sum(a[0] * b[1] - b[0] * a[1] for a, b in zip(args[:-1], args[1:-1] + args[:1]))
        elif op == "moveTo":
            first = last = args[0]
        elif op in ("lineTo", "qCurveTo", "curveTo"):
            total += last[0] * args[-1][1] - args[-1][0] * last[1]
            last = args[-1]
        elif op in ("closePath", "endPath") and first is not None:
            total += last[0] * first[1] - first[0] * last[1]
    return total


def tt_glyph(path):
    recording = RecordingPen()
    path.draw(Cu2QuPen(recording, 0.5))
    pen = TTGlyphPen(None)
    # TrueType outlines run clockwise around the ink; pathops leaves them the other way.
    recording.replay(ReverseContourPen(pen) if signed_area(recording) > 0 else pen)
    glyph = pen.glyph()
    if glyph.numberOfContours:
        glyph.recalcBounds(None)
    return glyph


def glyph_name(ch):
    return agl.UV2AGL.get(ord(ch)) or f"uni{ord(ch):04X}"


def build(kosugi, parameters, out):
    source = mf.Source(kosugi)
    table = mf.Recipes(source, parameters).glyphs()
    order = [".notdef"] + [glyph_name(ch) for ch in sorted(table)]
    glyf = {".notdef": TTGlyphPen(None).glyph()}
    metrics = {".notdef": (mf.HALF, 0)}
    cmap = {}
    paths = {ch: outline(source, table[ch][1]) for ch in table}
    x_height, cap_height = paths["x"].bounds[3], paths["H"].bounds[3]
    for ch in sorted(table):
        advance, components = table[ch]
        name = glyph_name(ch)
        path = paths[ch]
        if ch == " ":
            advance = int(round(mf.HALF * parameters["spacing"]["space"]))
        elif ch in mf.PROPORTIONAL:
            shift, advance = spacing(ch, path, parameters["spacing"], x_height, cap_height)
            path = path.transform(1, 0, 0, 1, shift, 0)
        glyph = tt_glyph(path)
        glyf[name] = glyph
        # FreeType and stb_truetype place an outline by its side bearing, so it is the outline's left edge.
        metrics[name] = (advance, glyph.xMin if glyph.numberOfContours else 0)
        cmap[ord(ch)] = name
    builder = FontBuilder(mf.UNITS_PER_EM, isTTF=True)
    builder.setupGlyphOrder(order)
    builder.setupCharacterMap(cmap)
    builder.setupGlyf(glyf)
    builder.setupHorizontalMetrics(metrics)
    builder.setupHorizontalHeader(ascent=mf.ASCENT, descent=-mf.DESCENT, lineGap=0)
    builder.setupNameTable({
        "copyright": "Copyright 2010 The Kosugi Project Authors (https://github.com/googlefonts/kosugi). "
                     "Modified for ChronicleTwo; see NOTICE.",
        "familyName": FAMILY,
        "styleName": "Regular",
        "uniqueFontIdentifier": f"{FAMILY}-Regular {VERSION}",
        "fullName": f"{FAMILY} Regular",
        "version": f"Version {VERSION}",
        "psName": f"{FAMILY}-Regular",
        "description": "Dark Chronicle's message font as outlines, made from Kosugi for the ChronicleTwo port.",
        "licenseDescription": "Licensed under the Apache License, Version 2.0",
        "licenseInfoURL": "https://www.apache.org/licenses/LICENSE-2.0",
    })
    builder.setupOS2(sTypoAscender=mf.ASCENT, sTypoDescender=-mf.DESCENT, sTypoLineGap=0, usWinAscent=mf.ASCENT,
                     usWinDescent=mf.DESCENT, sxHeight=glyf[glyph_name("x")].yMax,
                     sCapHeight=glyf[glyph_name("H")].yMax, usWeightClass=400, fsType=0, achVendID="CHR2",
                     fsSelection=0x40)
    builder.setupPost()
    builder.setupHead(unitsPerEm=mf.UNITS_PER_EM, fontRevision=float(VERSION))
    font = builder.font
    font["OS/2"].recalcUnicodeRanges(font)
    font["OS/2"].recalcCodePageRanges(font)
    # A fixed date, the version's, keeps the build reproducible: the same inputs give the same bytes.
    font["head"].created = font["head"].modified = timestampFromString(VERSION_DATE)
    font.recalcTimestamp = False
    out.parent.mkdir(parents=True, exist_ok=True)
    builder.save(str(out))
    return len(table)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--kosugi", type=Path, help="Kosugi-Regular.ttf to use instead of fetching it")
    parser.add_argument("--parameters", type=Path, default=mf.PARAMETERS)
    parser.add_argument("--out", type=Path, default=mf.FONT)
    args = parser.parse_args()
    count = build(args.kosugi or mf.kosugi_path(), mf.load_parameters(args.parameters), args.out)
    print(f"{count} glyphs -> {args.out}")


if __name__ == "__main__":
    main()
