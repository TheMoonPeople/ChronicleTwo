#!/usr/bin/env python3
"""Fit ChronicleTwoMenu to the pause menu's painted words and write the numbers to menu_font.json.

    fit_menu_font.py <game root> [--candidates DIR] [--letters M]

Reads the English menu atlas from the user's own extraction (data.zip or data/ under the game root); nothing it
reads is written anywhere but as the fitted numbers. Each word is set in its cell as the font would draw it and
compared texel by texel with how lit the painting is, between its rim and its fill:

- global: the em, the stretch, the weight, where the pen starts and the baseline, over every word;
- letters: each letter's scale, move, slant, weight and advance, over the words it is in;
- with --candidates, the --letters are fitted from each font in DIR as well, and the nearest is reported.
"""
import argparse
import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import menu_font as mnf  # noqa: E402
import message_font as mf  # noqa: E402

GLOBAL_KEYS = ["em", "stretch", "weight", "start", "baseline"]
GLOBAL_STEPS = [0.4, 0.04, 8.0, 0.25, 0.25]
# Letters keep the shared baseline and nearly their heights: the painting's per-letter steps up and down are
# its rasterization, which a drawn font should not copy.
LETTER_KEYS = ["kx", "ky", "tx", "shear", "weight", "advance"]
LETTER_STEPS = [0.06, 0.02, 16.0, 0.06, 8.0, 16.0]
LETTER_BOUNDS = [(0.7, 1.3), (0.96, 1.04), (-96, 96), (-0.3, 0.3), (-48, 48), (-192, 192)]
# A letter is 14 texels tall here, so a correction has little to go on: each costs its size in steps, squared,
# times PENALTY, and one that takes less than NOISE of its words' error away is dropped.
PENALTY = 0.00004
NOISE = 0.02


class Fit:
    def __init__(self, targets, sources, parameters, keep=()):
        self.targets, self.sources, self.p = targets, sources, parameters
        self.keep = set(keep)  # letter corrections left as they are

    def word_error(self, word):
        target = self.targets[word]
        drawn = mnf.render_word(self.sources, word, self.p, target.shape[1], target.shape[0])
        return float(np.abs(drawn / 255.0 - target).mean())

    def error(self, words=None):
        return float(np.mean([self.word_error(w) for w in (words or self.targets)]))

    def fit_global(self):
        g = self.p["global"]
        # The font's own numbers, then each other source's em and stretch where it is drawn at its own.
        fields = [(g, k, s) for k, s in zip(GLOBAL_KEYS, GLOBAL_STEPS)]
        for name, spec in self.p["sources"].items():
            if isinstance(spec, dict):
                fields += [(spec, k, s) for k, s in (("em", 0.4), ("stretch", 0.04)) if k in spec]

        def apply(v):
            for (owner, key, _), value in zip(fields, v):
                owner[key] = value
            for name, spec in self.p["sources"].items():
                if isinstance(spec, dict):
                    self.sources[name].scale = {k: spec[k] for k in ("em", "stretch") if k in spec}

        def f(v):
            apply(v)
            return self.error()

        values, best = mf.descend(f, [owner[key] for owner, key, _ in fields], [s for _, _, s in fields])
        apply(values)
        offsets = self.p.setdefault("words", {})
        for word in self.targets:

            def shifted(v, word=word):
                offsets[word] = list(v)
                return self.word_error(word)

            offsets[word], _ = mf.descend(shifted, offsets.get(word, [0.0, 0.0]), [0.25, 0.25],
                                          bounds=[(-4.0, 4.0), (-4.0, 4.0)])
        return self.error()

    def fit_letter(self, ch, source, height=None):
        words = [w for w in self.targets if ch in w]
        glyph = self.p["glyphs"].setdefault(ch, {})
        glyph["source"] = source
        start = [glyph.get(k, mnf.GLYPH_DEFAULTS[k]) for k in LETTER_KEYS]
        # A source only this letter draws from is drawn at its own em and stretch, fitted with it.
        spec = self.p["sources"].get(source)
        users = [c for c, p in self.p["glyphs"].items() if p.get("source", mnf.default_source(self.p)) == source]
        own = [k for k in ("em", "stretch") if isinstance(spec, dict) and k in spec and users == [ch]]
        steps = LETTER_STEPS + [{"em": 0.4, "stretch": 0.04}[k] for k in own]
        start += [spec[k] for k in own]

        def apply(v):
            glyph.update(zip(LETTER_KEYS, v))
            for k, value in zip(own, v[len(LETTER_KEYS):]):
                spec[k] = value
            if own:
                self.sources[source].scale = {k: spec[k] for k in ("em", "stretch") if k in spec}

        def cost(v):
            return PENALTY * sum(((x - mnf.GLYPH_DEFAULTS[k]) / s) ** 2 for k, x, s in zip(LETTER_KEYS, v, LETTER_STEPS))

        def f(v):
            apply(v)
            return self.error(words) + cost(v[:len(LETTER_KEYS)])

        bounds = [height if key == "ky" and height else bound for key, bound in zip(LETTER_KEYS, LETTER_BOUNDS)]
        bounds = [(value, value) if key in self.keep else bound for key, value, bound in zip(LETTER_KEYS, start, bounds)]
        bounds += [(0.0, 1e9)] * len(own)
        values, _ = mf.descend(f, start, steps, bounds=bounds)
        # Uncorrected, but for what --keep holds.
        uncorrected = [value if key in self.keep else mnf.GLYPH_DEFAULTS[key] for key, value in zip(LETTER_KEYS, start)]
        apply(uncorrected + values[len(LETTER_KEYS):])
        plain = self.error(words)
        apply(values)
        corrected = self.error(words)
        if corrected > plain * (1 - NOISE):
            apply(uncorrected + values[len(LETTER_KEYS):])
            return plain
        return corrected


# The drawn question mark's steps, in master units and degrees.
QUESTION_STEPS = [16, 16, 16, 16, 8, 6, 6, 16, 16, 16, 8, 8, 8, 16]


def fit_drawn(fit, ch):
    words = [w for w in fit.targets if ch in w]
    q = fit.p["glyphs"][ch]["drawn"]

    def f(v):
        q.update(zip(mnf.QUESTION_KEYS, v))
        return fit.error(words)

    values, best = mf.descend(f, [q[k] for k in mnf.QUESTION_KEYS], QUESTION_STEPS)
    q.update(zip(mnf.QUESTION_KEYS, values))
    return best


def letters_in(targets):
    counts = {}
    for word in targets:
        for ch in word:
            counts[ch] = counts.get(ch, 0) + 1
    return sorted(counts, key=lambda ch: -counts[ch])


def rounded(parameters):
    g = {k: round(v, 3) for k, v in parameters["global"].items()}
    glyphs = {}
    for ch, p in sorted(parameters["glyphs"].items()):
        if p.get("source") == "drawn":
            glyphs[ch] = {"source": "drawn", "drawn": {k: round(v, 2) for k, v in p["drawn"].items()}}
            continue
        kept = {k: round(v, 3) for k, v in p.items()
                if k not in ("source", "warp", "clip") and abs(v - mnf.GLYPH_DEFAULTS[k]) > 1e-3}
        for design in ("warp", "clip"):
            if design in p:
                kept[design] = p[design]
        if p.get("source", mnf.default_source(parameters)) != mnf.default_source(parameters):
            kept["source"] = p["source"]
        if kept:
            glyphs[ch] = kept
    words = {w: [round(v, 3) for v in offset] for w, offset in parameters.get("words", {}).items()}
    sources = {name: {k: round(v, 3) if k != "weight" else v for k, v in spec.items()} if isinstance(spec, dict) else spec
               for name, spec in parameters["sources"].items()}
    return {**parameters, "sources": sources, "global": g, "glyphs": glyphs, "words": words}


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("game_root", type=Path)
    parser.add_argument("--source", action="append", default=[], metavar="NAME=PATH",
                        help="a source font to use instead of fetching it (libre_franklin=..., jost=...)")
    parser.add_argument("--parameters", type=Path, default=mnf.PARAMETERS)
    parser.add_argument("--out", type=Path, help="where to write the numbers (default: --parameters)")
    parser.add_argument("--candidates", type=Path, help="a directory of fonts to fit --letters from as well")
    parser.add_argument("--letters", default="M")
    parser.add_argument("--no-flare", action="store_true", help="fit without flared stroke ends")
    parser.add_argument("--only", help="fit only these letters, keeping everything else as it is")
    parser.add_argument("--keep", default="", help="corrections to leave as they are, comma separated (shear,...)")
    parser.add_argument("--height", help="with --only, the range a letter's height may scale over, LOW,HIGH")
    args = parser.parse_args()

    parameters = mnf.load_parameters(args.parameters)
    parameters.setdefault("glyphs", {})
    if args.no_flare:
        parameters["flare"] = None
    targets = mnf.targets(mf.Extraction(args.game_root), parameters)
    default = mnf.default_source(parameters)
    paths = dict(item.split("=", 1) for item in args.source)
    with mnf.Sources(parameters, paths) as sources:
        fit = Fit(targets, sources, parameters, [k for k in args.keep.split(",") if k])
        height = tuple(float(v) for v in args.height.split(",")) if args.height else None
        print(f"start {fit.error():.4f}", flush=True)
        for ch in args.only or "":
            source = parameters["glyphs"].get(ch, {}).get("source", default)
            print(f"  {ch} {fit.fit_letter(ch, source, height):.4f}", flush=True)
        for round_ in range(0 if args.only else 2):
            print(f"global {fit.fit_global():.4f}", flush=True)
            for ch in letters_in(targets):
                source = parameters["glyphs"].get(ch, {}).get("source", default)
                error = fit_drawn(fit, ch) if source == "drawn" else fit.fit_letter(ch, source)
                print(f"  {ch} {error:.4f}", flush=True)
            print(f"round {round_ + 1}: {fit.error():.4f}  " +
                  " ".join(f"{w} {fit.word_error(w):.3f}" for w in targets), flush=True)

        if args.candidates:
            for ch in args.letters:
                words = [w for w in targets if ch in w]
                results = [(fit.error(words), parameters["glyphs"].get(ch, {}).get("source", default))]
                kept = dict(parameters["glyphs"][ch])
                for path in sorted(args.candidates.iterdir()):
                    varies = "fvar" in mnf.TTFont(path)
                    for weight in (400, 500, 600, 700) if varies else (None,):
                        name = f"{path.name}@{weight}"
                        if ch not in sources.add(name, path, weight, parameters.get("flare")).advances:
                            continue
                        parameters["glyphs"][ch] = {}
                        # A candidate's letters may stand at another height than the font's: let it scale freely.
                        results.append((fit.fit_letter(ch, name, height=(0.6, 1.6)), name))
                parameters["glyphs"][ch] = kept
                print(f"{ch}: " + ", ".join(f"{n} {e:.4f}" for e, n in sorted(results)[:8]), flush=True)

    out = args.out or args.parameters
    out.write_text(json.dumps(rounded(parameters), indent=2, ensure_ascii=False) + "\n")
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
