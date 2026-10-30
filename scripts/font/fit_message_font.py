#!/usr/bin/env python3
"""Fit scripts/font/message_font.json to the retail message font of your own extraction.

Reads meswin/fonttbl_{1,2}.bin and textures/meswin/fonttex_{1,2}_0_0.png from a dc2data extraction
(<game-root>, its data.zip or a data/ directory) and measures Kosugi's glyphs against them. Only the
numbers it writes leave your machine; the pages themselves are never copied. Stages run in order and
each starts from the numbers of the ones before it, so --only reruns some on top of the current file.

  global      Kosugi units to master units on the European page
  english     how the English page draws master space
  ascii       per-glyph corrections, kept only where both pages agree
  accents     mark shapes shared by both cases, their places, the capitals' squash
  cedilla     the drawn stroke under ç and Ç
  half_width  ß ¡ ¿ ª º ° the quotes, ・ and the ligatures
  full_width  every full-width symbol, jointly on both pages where both draw it
"""
import argparse
import json
import sys
import unicodedata
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import message_font as mf  # noqa: E402

STAGES = ("global", "english", "ascii", "accents", "cedilla", "half_width", "full_width")
NAMES = ("kx", "ky", "tx", "ty", "shear", "weight")
IDENTITY = [1.0, 1.0, 0.0, 0.0, 0.0, 0.0]
# A change has to buy this much accuracy (summed per-page error) per unit to be worth making, and changes
# smaller than NOISE are dropped: hinting differences on one page must not leak into the design.
PENALTY = [0.06, 0.06, 0.012 / 64, 0.012 / 64, 0.03, 0.12 / 64]
NOISE = [0.03, 0.03, 0.15 * 64, 0.15 * 64, 0.05, 0.1 * 64]
STEPS = [0.06, 0.06, 32, 32, 0.15, 8]
BOUNDS = [(0.75, 1.3), (0.75, 1.3), (-128, 128), (-96, 96), (-0.8, 0.8), (-24, 24)]
FAMILIES = ["０１２３４５６７８９", "ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ",
            "ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ", "←→", "↑↓", "○●", "□■", "（）", "［］",
            "｛｝", "「」", "『』", "【】", "、。", "，．", "：；", "？！", "＋−", "＜＞", "“”"]


class Fitter:
    def __init__(self, extraction, kosugi, parameters):
        self.source = mf.Source(kosugi)
        self.extraction = extraction
        self.p = parameters
        self.reload()

    def reload(self):
        self.recipes = mf.Recipes(self.source, self.p)
        self.eu, self.en = mf.pages(self.extraction, self.p)

    def error(self, recipe, page, ch):
        return mf.error(self.source, recipe, page, ch)

    # ---- global and english ----

    def fit_global(self):
        a, _, _, d, e, _ = self.p.get(mf.GLOBAL_KEY, [0.95, 0, 0, 0.92, 32, 0])

        def cost(v):
            base = (v[0], 0.0, 0.0, v[1], v[2], 0.0)
            return np.mean([self.error([mf.component(ch, base)], self.eu, ch) for ch in mf.ASCII])

        v, e = mf.descend(cost, [a, d, e], [0.02, 0.02, 16])
        self.p[mf.GLOBAL_KEY] = [v[0], 0.0, 0.0, v[1], v[2], 0.0]
        print(f"global: x {v[0]:.4f} y {v[1]:.4f} pen {v[2] / 64:+.2f}px  error {e:.4f}")

    def fit_english(self):
        a, _, _, d, e, f = self.p["english_page"]["affine"]
        base = tuple(self.p[mf.GLOBAL_KEY])

        def cost(v):
            self.en.affine = (v[0], 0.0, 0.0, v[1], v[2], v[3])
            return np.mean([self.error([mf.component(ch, base)], self.en, ch) for ch in mf.ASCII])

        v, e = mf.descend(cost, [a, d, e, f], [0.02, 0.02, 8, 8])
        self.p["english_page"]["affine"] = [v[0], 0.0, 0.0, v[1], v[2], v[3]]
        print(f"english: x {v[0]:.4f} y {v[1]:.4f} offset {v[2]:.1f},{v[3]:.1f}  error {e:.4f}")

    # ---- ascii ----

    def ascii_errors(self, ch, p):
        recipe = [self.recipes.ascii(ch, dict(zip(NAMES, p)))]
        return self.error(recipe, self.eu, ch), self.error(recipe, self.en, ch)

    def fit_ascii(self):
        out = {}
        for ch in mf.ASCII:
            free = [0, 1, 2, 3, 5] + ([4] if ch in "'`" else [])

            def expand(q):
                p = list(IDENTITY)
                for i, x in zip(free, q):
                    p[i] = x
                return p

            def run(cost, start):
                q, value = mf.descend(lambda q: cost(expand(q)), [start[i] for i in free], [STEPS[i] for i in free],
                                      bounds=[BOUNDS[i] for i in free])
                return expand(q), value

            def penalised(p):
                return sum(self.ascii_errors(ch, p)) + sum(PENALTY[i] * abs(p[i] - IDENTITY[i]) for i in free)

            # The penalised search starts from the unpenalised optimum too: some corrections (the
            # apostrophe's shift, lift and slant together) only pay off as a whole.
            unpenalised, _ = run(lambda p: sum(self.ascii_errors(ch, p)), IDENTITY)
            p = min((run(penalised, start) for start in (IDENTITY, unpenalised)), key=lambda r: r[1])[0]
            p = [IDENTITY[i] if abs(x - IDENTITY[i]) < NOISE[i] else x for i, x in enumerate(p)]
            before, after = self.ascii_errors(ch, IDENTITY), self.ascii_errors(ch, p)
            if p != IDENTITY and all(b - a >= 0.003 for b, a in zip(before, after)) and sum(before) - sum(after) >= 0.01:
                out[ch] = {n: round(x, 4) for n, x, ref in zip(NAMES, p, IDENTITY) if x != ref}
                print(f"ascii {ch!r}: {out[ch]}  European {before[0]:.3f}->{after[0]:.3f}  "
                      f"English {before[1]:.3f}->{after[1]:.3f}", flush=True)
        self.p["ascii"] = out
        self.reload()

    # ---- accents ----

    def accent_errors(self, members):
        return np.mean([self.error(self.recipes.accent(ch, base, mark, case), self.eu, ch)
                        for ch, base, mark, case in members])

    def fit_accents(self):
        letters = [x for x in self.recipes.accented() if x[2] != "ȷ"]
        accents = self.p.setdefault("accents", {"shapes": {}, "places": {}, "capital_squash": [1.0, 0.0]})
        for mark in sorted({x[2] for x in letters}):
            accents["shapes"].setdefault(mark, [1.0, 200.0, 0.0] if mark == "¨" else [0.8, 0.8, 1.0])
            for case in ("upper", "lower"):
                accents["places"].setdefault(f"{mark}|{case}", [0.0, 60.0])
        for round_ in range(2):
            for mark in sorted({x[2] for x in letters}):
                members = [x for x in letters if x[2] == mark]
                cases = sorted({x[3] for x in members})

                def cost(v):
                    accents["shapes"][mark] = v[:3]
                    for k, case in enumerate(cases):
                        accents["places"][f"{mark}|{case}"] = v[3 + 2 * k:5 + 2 * k]
                    return self.accent_errors(members)

                start = accents["shapes"][mark] + [x for case in cases for x in accents["places"][f"{mark}|{case}"]]
                shape_steps = [0.1, 32, 0.25] if mark == "¨" else [0.08, 0.08, 0.25]
                shape_bounds = [(0.4, 1.6), (60, 400), (0, 1)] if mark == "¨" else [(0.2, 1.6), (0.2, 1.6), (0, 1)]
                v, e = mf.descend(cost, start, shape_steps + [16, 16] * len(cases),
                                  bounds=shape_bounds + [(-160, 160), (-240, 240)] * len(cases))
                cost(v)
                print(f"accents {mark!r} round {round_}: error {e:.4f}", flush=True)
            capitals = [x for x in letters if x[3] == "upper"]

            def squash(q):
                accents["capital_squash"] = list(q)
                return self.accent_errors(capitals)

            q, e = mf.descend(squash, accents["capital_squash"], [0.04, 16], bounds=[(0.7, 1.1), (-128, 64)])
            squash(q)
            print(f"accents capital squash round {round_}: y {q[0]:.3f} lift {q[1] / 64:+.2f}px  error {e:.4f}")
        accents["shapes"] = {m: [round(x, 4) for x in v] for m, v in accents["shapes"].items()}
        accents["places"] = {k: [round(x, 4) for x in v] for k, v in accents["places"].items()}
        accents["capital_squash"] = [round(x, 4) for x in accents["capital_squash"]]

    def fit_cedilla(self):
        names = ("length", "width", "depth", "end", "weight", "dx")
        cedilla = self.p.setdefault("cedilla", dict(zip(names, [40.0, 110.0, 120.0, -60.0, mf.STEM_X, 0.0])))
        members = [x for x in self.recipes.accented() if x[2] == "ȷ"]

        def cost(v):
            cedilla.update(zip(names, v))
            total = 0.0
            for ch, base, mark, case in members:
                target = self.eu.target(ch)
                cover = mf.render(self.source, self.recipes.accent(ch, base, mark, case), self.eu, 8)
                # The rows under the baseline decide the cedilla's shape, so they weigh as much as the cell.
                total += np.abs(cover - target).mean() / 255 + np.abs(cover[16:] - target[16:]).mean() / 255
            return total / len(members)

        v, e = mf.descend(cost, [cedilla[n] for n in names], [16, 24, 24, 24, 12, 16],
                          bounds=[(0, 160), (0, 260), (40, 260), (-200, 120), (40, 140), (-96, 96)])
        cost(v)
        self.p["cedilla"] = {n: round(x, 4) for n, x in zip(names, v)}
        print(f"cedilla: {self.p['cedilla']}  cost {e:.4f}")

    # ---- half-width specials ----

    def target_ink(self, page, target):
        """The retail ink box of a cell, in master units."""
        ys, xs = np.nonzero(target > 40)
        a, _, _, d, e, f = page.affine
        base = np.floor(page.baseline)
        lift = (page.baseline - base) * 64
        return ((xs.min() * 64.0 - e) / a, ((base - ys.max() - 1) * 64.0 - f + lift) / d,
                ((xs.max() + 1) * 64.0 - e) / a, ((base - ys.min()) * 64.0 - f + lift) / d)

    def ink_start(self, page, target, source, rotate=False):
        t = self.target_ink(page, target)
        s = self.source.ink(source, self.recipes.placed(source, 1, 1, 0, 0, rotate)[2])
        return [float(np.clip((t[2] - t[0]) / max(s[2] - s[0], 1), 0.2, 1.6)),
                float(np.clip((t[3] - t[1]) / max(s[3] - s[1], 1), 0.2, 1.6)), (t[0] + t[2]) / 2, (t[1] + t[3]) / 2]

    def fit_half_width(self):
        half = self.p.setdefault("half_width", {})
        specs = {"ª": ("single", "a"), "º": ("single", "o"), "°": ("single", "°"), "・": ("single", "・"),
                 "‘": ("marks", "‘", 1), "’": ("marks", "’", 1), "“": ("marks", "‘", 2), "”": ("marks", "’", 2),
                 "Æ": ("pair", "AE"), "Œ": ("pair", "OE"), "æ": ("pair", "ae"), "œ": ("pair", "oe"),
                 "¡": ("turned", "!"), "¿": ("turned", "?"), "ß": ("eszett",)}
        for ch, spec in specs.items():
            kind = spec[0]
            entry = {"kind": kind}
            if kind != "eszett":
                entry["source"] = spec[1]
            if kind == "marks":
                entry["count"] = spec[2]
            target = self.eu.target(ch)
            t = self.target_ink(self.eu, target)
            if kind == "single":
                start, steps = self.ink_start(self.eu, target, spec[1]), [0.05, 0.05, 16, 16]
                bounds = [(0.2, 1.6), (0.2, 1.6), (-200, 1200), (-400, 1200)]
            elif kind == "marks":
                s = self.source.ink(spec[1], tuple(self.p[mf.GLOBAL_KEY]))
                start = [float(np.clip((t[3] - t[1]) / max(s[3] - s[1], 1), 0.3, 1.5)), (t[0] + t[2]) / 2,
                         (t[1] + t[3]) / 2, (t[2] - t[0]) / 2 if spec[2] > 1 else 0.0]
                steps, bounds = [0.05, 16, 16, 16 if spec[2] > 1 else 0], [(0.2, 1.6), (-200, 800), (-200, 1200), (0, 512)]
            elif kind == "pair":
                start, steps = [0.6, 0.55, 1.0, 60.0, t[0]], [0.05, 0.05, 0.03, 16, 16]
                bounds = [(0.3, 1.2), (0.3, 1.2), (0.8, 1.1), (-60, 240), (-64, 256)]
            elif kind == "turned":
                start, steps, bounds = [0.0, -260.0], [16, 16], [(-256, 256), (-600, 200)]
            else:
                start = [t[0] + 50, t[1], 0.8, 1.0, (t[0] + t[2]) / 2 + 40, 380]
                steps = [16, 16, 0.05, 0.05, 16, 16]
                bounds = [(-64, 400), (-400, 200), (0.3, 1.5), (0.5, 1.5), (0, 512), (0, 800)]

            def cost(v):
                entry["params"] = v
                half[ch] = entry
                return self.error(self.recipes.half_width(ch), self.eu, ch)

            v, e = mf.descend(cost, start, steps, bounds=bounds)
            entry["params"] = [round(x, 4) for x in v]
            half[ch] = entry
            print(f"half-width {ch} ({kind}): error {e:.4f}", flush=True)

    # ---- full-width ----

    def english_symbols(self):
        """Full-width symbols the English page draws (not kana or kanji): char -> font number."""
        half, kanji_top, codes = self.extraction.table(1)
        cells = (self.en.coverage.shape[0] // 20) * 32
        out = {}
        for no in range(half, min(kanji_top, cells)):
            ch = mf.decode(codes[no])
            if ch is None or ch == "\u3000":
                continue
            name = unicodedata.name(ch, "")
            if ("HIRAGANA" in name or "KATAKANA" in name) and "MIDDLE DOT" not in name:
                continue
            out.setdefault(ch, no)
        return out

    def fit_full_width(self):
        english = self.english_symbols()
        european = {ch for ch in mf.FONT_GAIJI if ch not in mf.HALF_GAIJI}

        def targets(ch):
            out = []
            if ch in english:
                out.append((self.en, self.en.cell(english[ch])))
            if ch in european:
                out.append((self.eu, self.eu.target(ch)))
            return out

        def error(ch, v):
            recipe = [self.recipes.placed(ch, *v)]
            return np.mean([np.abs(mf.render(self.source, recipe, page, 16) - t).mean() / 255 for page, t in targets(ch)])

        def start(ch):
            page, target = targets(ch)[-1]
            return self.ink_start(page, target, ch)

        full = {}
        grouped = set()
        for family in FAMILIES:
            chars = [c for c in family if targets(c)]
            starts = [start(c) for c in chars]
            v0 = [float(np.median([s[0] for s in starts])), float(np.median([s[1] for s in starts]))]
            v0 += [x for s in starts for x in s[2:]]
            cost = lambda v: np.mean([error(c, [v[0], v[1], v[2 + 2 * i], v[3 + 2 * i]])  # noqa: E731
                                      for i, c in enumerate(chars)])
            v, e = mf.descend(cost, v0, [0.05, 0.05] + [16, 16] * len(chars),
                              bounds=[(0.3, 1.6), (0.3, 1.6)] + [(-200, 1300), (-500, 1200)] * len(chars))
            for i, c in enumerate(chars):
                full[c] = [round(x, 4) for x in (v[0], v[1], v[2 + 2 * i], v[3 + 2 * i])]
            grouped.update(chars)
            print(f"full-width {family[:10]}: error {e:.4f}", flush=True)
        for ch in sorted((set(english) | european) - grouped):
            v, e = mf.descend(lambda v: error(ch, v), start(ch), [0.05, 0.05, 16, 16],
                              bounds=[(0.3, 1.6), (0.3, 1.6), (-200, 1300), (-500, 1200)])
            full[ch] = [round(x, 4) for x in v]
        self.p["full_width"] = full


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("extraction", type=Path, help="<game-root>, its data.zip or a data/ directory")
    parser.add_argument("--kosugi", type=Path, help="Kosugi-Regular.ttf to use instead of fetching it")
    parser.add_argument("--parameters", type=Path, default=mf.PARAMETERS)
    parser.add_argument("--only", help=f"comma-separated stages from: {', '.join(STAGES)}")
    args = parser.parse_args()
    stages = args.only.split(",") if args.only else STAGES
    unknown = set(stages) - set(STAGES)
    if unknown:
        parser.error(f"unknown stages: {', '.join(sorted(unknown))}")
    # Without a file, start from Kosugi at about the European page's size, untouched otherwise.
    parameters = mf.load_parameters(args.parameters) if args.parameters.exists() else {
        mf.GLOBAL_KEY: [0.95, 0.0, 0.0, 0.92, 32.0, 0.0],
        "english_page": {"affine": [0.96, 0.0, 0.0, 1.35, -38.4, 0.0], "baseline": 17.0},
        "ascii": {}, "half_width": {}, "full_width": {}}
    fitter = Fitter(mf.Extraction(args.extraction), args.kosugi or mf.kosugi_path(), parameters)
    for stage in STAGES:
        if stage in stages:
            getattr(fitter, f"fit_{stage}")()
            fitter.reload()
    with open(args.parameters, "w", encoding="utf-8") as f:
        json.dump(fitter.p, f, indent=1, ensure_ascii=False)
        f.write("\n")
    print(f"wrote {args.parameters}")


if __name__ == "__main__":
    main()
