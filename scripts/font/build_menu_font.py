#!/usr/bin/env python3
"""Build a menu lettering font (ChronicleTwoMenu from scripts/font/menu_font.json, ChronicleTwoBoard from
board_font.json) into port/assets/fonts from its source fonts.

Each letter goes through the FreeType steps the fitter rendered (its affine, then its stem offset) and is read
back point for point, so the font draws what fit_menu_font.py measured. Its units are master units, 64 a texel
of the menu atlas, so its em is the fitted `em` in texels. Needs freetype-py, fonttools and skia-pathops
(scripts/font/requirements.txt), and fetches the source fonts once into ~/.cache/chronicletwo. No game data is
read.
"""
import argparse
import sys
from pathlib import Path

import pathops
from fontTools.fontBuilder import FontBuilder
from fontTools.misc.timeTools import timestampFromString
from fontTools.pens.ttGlyphPen import TTGlyphPen

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build_message_font as bmf  # noqa: E402
import menu_font as mnf  # noqa: E402

VERSION = "1.000"
VERSION_DATE = "Sat Oct 24 00:00:00 2026"


def build(parameters, out, paths=None):
    g = parameters["global"]
    with mnf.Sources(parameters, paths) as sources:
        units_per_em = round(g["em"] * mnf.UNIT)
        order = [".notdef"]
        glyf = {".notdef": TTGlyphPen(None).glyph()}
        metrics = {".notdef": (units_per_em // 2, 0)}
        cmap = {}
        for ch in mnf.characters(parameters):
            p = mnf.corrections(parameters, ch)
            name = bmf.glyph_name(ch)
            if p.get("source") != "drawn" and ch not in sources[p.get("source", mnf.default_source(parameters))].advances:
                continue  # a source without the character: the font leaves it out
            if p.get("source") == "drawn":
                glyph, advance = bmf.tt_glyph(mnf.question_mark(p["drawn"])), p["drawn"]["advance"]
            else:
                source = sources[p.get("source", mnf.default_source(parameters))]
                affine, strength, advance = mnf.letter(source, ch, g, p)
                if ch == " ":
                    glyph = TTGlyphPen(None).glyph()
                else:
                    path = bmf.kosugi_part(source, ch, affine, strength, None, None)
                    if "clip" in p:
                        x0, y0, x1, y1 = p["clip"]
                        box = pathops.Path()
                        box.moveTo(x0, y0)
                        box.lineTo(x1, y0)
                        box.lineTo(x1, y1)
                        box.lineTo(x0, y1)
                        box.close()
                        path = pathops.op(path, box, pathops.PathOp.INTERSECTION)
                    glyph = bmf.tt_glyph(path)
            order.append(name)
            glyf[name] = glyph
            # FreeType places an outline by its left side bearing, so it is the outline's own left edge.
            metrics[name] = (round(advance), glyph.xMin if glyph.numberOfContours else 0)
            cmap[ord(ch)] = name
        default = mnf.default_source(parameters)
        main = sources[default]
        scale = mnf.base(main, g)[3]
        ascent, descent = round(main.ascent * scale), round(main.descent * scale)
        spec = parameters["sources"][default]
        # A static source has no weight of its own to set; it is a regular.
        weight = (spec["weight"] if isinstance(spec, dict) else spec) or 400

    builder = FontBuilder(units_per_em, isTTF=True)
    builder.setupGlyphOrder(order)
    builder.setupCharacterMap(cmap)
    builder.setupGlyf(glyf)
    builder.setupHorizontalMetrics(metrics)
    builder.setupHorizontalHeader(ascent=ascent, descent=descent, lineGap=0)
    family = parameters["family"]
    builder.setupNameTable({
        "copyright": parameters["copyright"],
        "familyName": family,
        "styleName": "Regular",
        "uniqueFontIdentifier": f"{family}-Regular {VERSION}",
        "fullName": f"{family} Regular",
        "version": f"Version {VERSION}",
        "psName": f"{family}-Regular",
        "description": parameters["description"],
        "licenseDescription": parameters.get("license", "This Font Software is licensed under the SIL Open Font License, Version 1.1."),
        "licenseInfoURL": parameters.get("license_url", "https://openfontlicense.org"),
    })
    builder.setupOS2(sTypoAscender=ascent, sTypoDescender=descent, sTypoLineGap=0, usWinAscent=ascent,
                     usWinDescent=-descent, sxHeight=glyf[bmf.glyph_name("x")].yMax,
                     sCapHeight=glyf[bmf.glyph_name("H")].yMax, usWeightClass=weight, usWidthClass=7,
                     fsType=0, achVendID="CHR2", fsSelection=0x40)
    builder.setupPost()
    builder.setupHead(unitsPerEm=units_per_em, fontRevision=float(VERSION))
    font = builder.font
    font["OS/2"].recalcUnicodeRanges(font)
    font["OS/2"].recalcCodePageRanges(font)
    # A fixed date, the version's, keeps the build reproducible: the same inputs give the same bytes.
    font["head"].created = font["head"].modified = timestampFromString(VERSION_DATE)
    font.recalcTimestamp = False
    out.parent.mkdir(parents=True, exist_ok=True)
    builder.save(str(out))


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--source", action="append", default=[], metavar="NAME=PATH",
                        help="a source font to use instead of fetching it (libre_franklin=..., jost=...)")
    parser.add_argument("--parameters", type=Path, default=mnf.PARAMETERS)
    parser.add_argument("--out", type=Path, help="where to write the font (default: its family's in port/assets/fonts)")
    args = parser.parse_args()
    parameters = mnf.load_parameters(args.parameters)
    build(parameters, args.out or mnf.font_path(parameters), dict(item.split("=", 1) for item in args.source))


if __name__ == "__main__":
    main()
