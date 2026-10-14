#!/usr/bin/env python3
"""Resolution and rate matrix for the port's presentation path.

Runs one input script through the game at a reference size, each Fill size, and a letterbox size,
each plain and with --display-per-tick 4. Checks logical-frame PSNR, display-per-tick identity,
and letterbox geometry, then writes report.md and summary.json to the work dir.

  python scripts/port/matrix.py --exe <darkchronicle> --input <script> --frame N [--scene NAME]
      [--data DIR] [--work DIR] [--jobs N] [--sizes WxH,...] [--reference WxH]
      [--letterbox-size WxH] [--skip-dpt] [--no-run] [--psnr-gate]

Game data comes from --data, else DC2_DATA, else <repo>/data. DC2_PYTHON names an interpreter with
numpy and Pillow for hosts whose running interpreter lacks them.
--no-run re-evaluates the runs already under --work. Below-35 dB PSNR is a FLAG by default and a
FAIL only with --psnr-gate.
Exit 0 pass, 1 FAIL (identity, letterbox, or run failures; PSNR below 35 dB only with --psnr-gate),
77 SKIP.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import dataclasses
import filecmp
import hashlib
import json
import math
import os
import re
import subprocess
import sys
import tempfile
import time
import uuid
from pathlib import Path

SKIP = 77
REPO = Path(__file__).resolve().parents[2]
LOGICAL = (512, 480)
PSNR_TARGET = 40.0
PSNR_FAIL = 35.0
# Slack between letterbox output and the Fill run at the frame's size; above it the two geometries differ.
LETTERBOX_MAX_DIFF = 1
RUN_TIMEOUT = 600
REEXEC_MARK = "DC2_MATRIX_REEXEC"

np = None
Image = None


class RunFailed(Exception):
    pass


def skip(reason: str) -> int:
    print(f"SKIP: {reason}")
    return SKIP


def parse_size(text: str) -> tuple[int, int]:
    m = re.fullmatch(r"(\d+)x(\d+)", text.strip())
    if not m:
        raise argparse.ArgumentTypeError(f"bad size '{text}', want WxH")
    return int(m.group(1)), int(m.group(2))


def parse_sizes(text: str) -> list[tuple[int, int]]:
    return [parse_size(part) for part in text.split(",") if part.strip()]


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    p.add_argument("--exe", required=True, type=Path)
    p.add_argument("--input", required=True, type=Path)
    p.add_argument("--frame", required=True, type=int)
    p.add_argument("--scene", default=None)
    p.add_argument("--data", type=Path, default=None)
    p.add_argument("--work", type=Path, default=None)
    p.add_argument("--jobs", type=int, default=4)
    p.add_argument("--sizes", type=parse_sizes, default=parse_sizes("1280x720,3840x2160,800x1200"))
    p.add_argument("--reference", type=parse_size, default=(1024, 768))
    p.add_argument("--letterbox-size", type=parse_size, default=(1280, 720))
    p.add_argument("--skip-dpt", action="store_true")
    p.add_argument("--no-run", action="store_true")
    p.add_argument("--psnr-gate", action="store_true")
    args = p.parse_args(argv)
    if args.scene is None:
        args.scene = args.input.stem
    return args


def load_deps() -> str | None:
    global np, Image
    try:
        import numpy
        from PIL import Image as pil_image
    except ImportError as e:
        return str(e)
    np, Image = numpy, pil_image
    return None


def maybe_reexec() -> None:
    alt = os.environ.get("DC2_PYTHON", "")
    if not alt or os.environ.get(REEXEC_MARK) or not Path(alt).is_file():
        return
    if Path(alt).resolve() == Path(sys.executable).resolve():
        return
    env = dict(os.environ, **{REEXEC_MARK: "1"})
    # Windows execv does not return the child's exit status to the caller, so run and forward it.
    sys.exit(subprocess.run([alt, str(Path(__file__).resolve()), *sys.argv[1:]], env=env).returncode)


def resolve_data(arg: Path | None) -> Path | None:
    if arg is not None:
        return arg
    env = os.environ.get("DC2_DATA", "")
    if env:
        return Path(env)
    if (REPO / "data").is_dir():
        return REPO / "data"
    return None


@dataclasses.dataclass(frozen=True)
class Mapping:
    scale_x: float
    scale_y: float
    off_x: int
    off_y: int


def main_mapping(w: int, h: int) -> Mapping:
    # float32 throughout, floored offsets: this reproduces MainMapping's rounding in draw.cpp.
    f = np.float32
    fw, fh = f(w), f(h)
    lw, lh = f(LOGICAL[0]), f(LOGICAL[1])
    aspect = f(4.0) / f(3.0)
    shown_w = min(fw, fh * aspect)
    scale_x = shown_w / lw
    scale_y = shown_w / aspect / lh
    return Mapping(float(scale_x), float(scale_y),
                   math.floor((fw - lw * scale_x) * f(0.5)),
                   math.floor((fh - lh * scale_y) * f(0.5)))


def frame_rect(w: int, h: int) -> tuple[int, int, int, int]:
    m = main_mapping(w, h)
    return m.off_x, m.off_y, round(LOGICAL[0] * m.scale_x), round(LOGICAL[1] * m.scale_y)


def crop(arr, rect):
    x, y, w, h = rect
    return arr[y:y + h, x:x + w]


def to_logical(frame):
    # BOX is exact area averaging: the non-integer downscale to 512x480 stays linear in the frame's pixels.
    im = Image.fromarray(np.ascontiguousarray(frame))
    return np.asarray(im.resize(LOGICAL, Image.Resampling.BOX))


def psnr(a, b) -> float:
    mse = float(np.mean((a.astype(np.float64) - b.astype(np.float64)) ** 2))
    return math.inf if mse == 0 else 10.0 * math.log10(255.0 ** 2 / mse)


@dataclasses.dataclass
class Run:
    w: int
    h: int
    aspect: str  # "auto" is Fill, "4:3" is letterbox
    dpt: bool
    dir: Path
    rc: int | None = None
    seconds: float = 0.0

    @property
    def name(self) -> str:
        mode = "letterbox" if self.aspect != "auto" else "fill"
        return f"{self.w}x{self.h} {mode}{' dpt4' if self.dpt else ''}"

    @property
    def png(self) -> Path:
        return self.dir / "shot.png"


def run_tag(w: int, h: int, aspect: str, dpt: bool) -> str:
    return f"{w}x{h}-{'lb' if aspect != 'auto' else 'fill'}{'-dpt4' if dpt else ''}"


def plan_runs(work: Path, ref, sizes, lb, skip_dpt: bool) -> dict[tuple, Run]:
    lb_frame = frame_rect(*lb)[2:]
    wanted = [(*ref, "auto", False)]
    wanted += [(*s, "auto", False) for s in sizes]
    wanted += [(*lb, "4:3", False), (*lb_frame, "auto", False)]
    if not skip_dpt:
        wanted += [(*s, "auto", True) for s in [ref, *sizes]]
        wanted += [(*lb, "4:3", True)]
    plan: dict[tuple, Run] = {}
    for w, h, aspect, dpt in wanted:
        key = (w, h, aspect, dpt)
        if key not in plan:
            plan[key] = Run(w, h, aspect, dpt, work / "runs" / f"{run_tag(w, h, aspect, dpt)}-{uuid.uuid4().hex[:8]}")
    return plan


def launch_config(run: Run) -> bytes:
    return json.dumps({"video": {"aspect": run.aspect}, "game": {"debug_mode": False}},
                      sort_keys=True).encode("utf-8")


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def provenance(exe: Path, data: Path, script: Path, frames: int, run: Run) -> dict:
    return {"exe": {"path": str(exe.resolve()), "sha256": digest(exe)},
            "input": {"path": str(script.resolve()), "sha256": digest(script)},
            "config_sha256": hashlib.sha256(launch_config(run)).hexdigest(),
            "data": str(data.resolve()), "frames": frames,
            "window": [run.w, run.h], "aspect": run.aspect, "dpt": run.dpt,
            "runtime_timing": {"region": "ntsc", "tick_hz": 60}}


def run_game(exe: Path, data: Path, script: Path, frames: int, run: Run) -> None:
    save = run.dir / "save"
    save.mkdir(parents=True)
    config = save / "config.json"
    config.write_bytes(launch_config(run))
    identity = provenance(exe, data, script, frames, run)
    cmd = [str(exe), "--headless", "--data", str(data), "--save", str(save), "--input", str(script),
           "--window", f"{run.w}x{run.h}", "--frames", str(frames), "--screenshot", str(run.png)]
    if run.dpt:
        cmd += ["--display-per-tick", "4"]
    env = os.environ.copy()
    for name in ("DC2_JUMP", "DC2_GIVE", "DC2_FAST_LOAD"):
        env.pop(name, None)
    t0 = time.monotonic()
    try:
        p = subprocess.run(cmd, capture_output=True, timeout=RUN_TIMEOUT, env=env)
        run.rc, out = p.returncode, p.stdout + p.stderr
    except subprocess.TimeoutExpired as e:
        run.rc, out = -1, (e.stdout or b"") + (e.stderr or b"")
    except OSError as e:
        run.rc, out = -1, str(e).encode("utf-8")
    run.seconds = time.monotonic() - t0
    (run.dir / "log.txt").write_bytes(out)
    result = {"version": 1, "rc": run.rc, "seconds": run.seconds, "provenance": identity,
              "saved_config_sha256": digest(config)}
    (run.dir / "result.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(f"  {run.name}: rc={run.rc} {run.seconds:.1f}s", flush=True)


def locate_run(run: Run, work: Path, exe: Path, data: Path, script: Path, frames: int) -> None:
    tag = run_tag(run.w, run.h, run.aspect, run.dpt)
    # The exact UUID suffix excludes dpt4 directories when looking up plain Fill.
    suffix = re.compile(re.escape(tag) + r"-[0-9a-f]{8}")
    found = [d for d in (work / "runs").glob(f"{tag}-*") if suffix.fullmatch(d.name)]
    if len(found) != 1:
        raise RunFailed(f"{run.name}: {len(found)} run dirs match {tag}-*, want 1")
    run.dir = found[0]
    try:
        result = json.loads((run.dir / "result.json").read_text(encoding="utf-8"))
        if not isinstance(result, dict) or result.get("version") != 1 or type(result.get("rc")) is not int:
            raise ValueError("invalid exit-status receipt")
        if result.get("provenance") != provenance(exe, data, script, frames, run):
            raise ValueError("binary, input or launch configuration differs")
        if result.get("saved_config_sha256") != digest(run.dir / "save" / "config.json"):
            raise ValueError("saved configuration differs")
        seconds = result.get("seconds")
        if type(seconds) not in (float, int) or not math.isfinite(seconds) or seconds < 0:
            raise ValueError("invalid duration")
        run.rc, run.seconds = result["rc"], seconds
    except (OSError, ValueError, TypeError) as e:
        raise RunFailed(f"{run.name}: unusable run receipt: {e}") from e


def load(run: Run):
    if run.rc != 0 or not run.png.is_file():
        raise RunFailed(f"{run.name}: rc={run.rc}, screenshot {'present' if run.png.is_file() else 'missing'}")
    with Image.open(run.png) as im:
        arr = np.asarray(im.convert("RGB"))
    if arr.shape[:2] != (run.h, run.w):
        raise RunFailed(f"{run.name}: screenshot is {arr.shape[1]}x{arr.shape[0]}")
    return arr


def evaluate(runs: dict[tuple, Run], ref, sizes, lb, skip_dpt: bool, scene: str, fail, flag,
             psnr_gate: bool) -> list[dict]:
    def dpt_cell(plain: Run, dpt_key: tuple, label: str) -> str:
        if skip_dpt:
            return "skipped"
        dpt = runs[dpt_key]
        same = np.array_equal(load(plain), load(dpt))
        if not same:
            fail(f"{scene} {label}: dpt4 pixels differ from plain run")
            return "NO"
        bytes_same = filecmp.cmp(plain.png, dpt.png, shallow=False)
        return f"yes (bytes {'identical' if bytes_same else 'differ'})"

    def row(size: str, mode: str, psnr_s: str, dpt_s: str, notes: list[str]) -> dict:
        return {"scene": scene, "size": size, "mode": mode, "psnr": psnr_s, "dpt4": dpt_s,
                "notes": "; ".join(notes)}

    rows = []
    ref_run = runs[(*ref, "auto", False)]
    ref_rect = frame_rect(*ref)
    ref_logical = to_logical(crop(load(ref_run), ref_rect))
    rows.append(row(f"{ref[0]}x{ref[1]}", "Fill (reference)", "ref",
                    dpt_cell(ref_run, (*ref, "auto", True), f"{ref[0]}x{ref[1]}"),
                    [f"frame {ref_rect}"]))

    for w, h in sizes:
        run = runs[(w, h, "auto", False)]
        rect = frame_rect(w, h)
        p = psnr(to_logical(crop(load(run), rect)), ref_logical)
        notes = [f"frame {rect}"]
        if p < PSNR_FAIL:
            msg = f"{scene} {w}x{h}: PSNR {p:.2f} dB below {PSNR_FAIL:g}"
            if psnr_gate:
                fail(msg)
                notes.append(f"FAIL: below {PSNR_FAIL:g} dB")
            else:
                flag(msg)
                notes.append(f"FLAG: below {PSNR_FAIL:g} dB")
        elif p < PSNR_TARGET:
            notes.append(f"below target {PSNR_TARGET:g} dB")
        psnr_s = "inf" if math.isinf(p) else f"{p:.2f}"
        rows.append(row(f"{w}x{h}", "Fill", psnr_s, dpt_cell(run, (w, h, "auto", True), f"{w}x{h}"), notes))

    lb_run = runs[(*lb, "4:3", False)]
    lb_arr = load(lb_run)
    lx, ly, fw, fh = frame_rect(*lb)
    outside = np.ones(lb_arr.shape[:2], dtype=bool)
    outside[ly:ly + fh, lx:lx + fw] = False
    nonblack = int(np.count_nonzero(lb_arr[outside].any(axis=1)))
    notes = [f"frame {(lx, ly, fw, fh)}"]
    if nonblack:
        fail(f"{scene} letterbox {lb[0]}x{lb[1]}: {nonblack} non-black pixels outside the frame")
        notes.append(f"FAIL: {nonblack} non-black px outside frame")
    else:
        notes.append("outside black")

    fill_crop = crop(load(runs[(fw, fh, "auto", False)]), frame_rect(fw, fh))
    lb_crop = crop(lb_arr, (lx, ly, fw, fh))
    if lb_crop.shape != fill_crop.shape:
        fail(f"{scene} letterbox {lb[0]}x{lb[1]}: frame shape differs from Fill {fw}x{fh}")
        notes.append(f"FAIL: shape vs Fill {fw}x{fh}")
    else:
        diff = np.abs(lb_crop.astype(np.int16) - fill_crop.astype(np.int16))
        mx = int(diff.max()) if diff.size else 0
        if mx == 0:
            notes.append(f"frame vs Fill {fw}x{fh}: identical")
        else:
            cnt = int(np.count_nonzero(diff.any(axis=2)))
            notes.append(f"frame vs Fill {fw}x{fh}: not identical ({cnt} px, max abs {mx})")
            if mx > LETTERBOX_MAX_DIFF:
                fail(f"{scene} letterbox frame differs from Fill {fw}x{fh} by {mx} (max abs)")
                notes.append("FAIL")
    rows.append(row(f"{lb[0]}x{lb[1]}", "Letterbox 4:3", "-",
                    dpt_cell(lb_run, (*lb, "4:3", True), f"letterbox {lb[0]}x{lb[1]}"), notes))
    return rows


def write_outputs(work: Path, scene: str, rows: list[dict], failures: list[str], flags: list[str],
                  runs: dict[tuple, Run], wall: float, rects: dict[str, tuple]) -> None:
    result = "FAIL" if failures else "PASS"
    lines = [f"## Matrix: {scene}", "",
             "| Scene | Size | Mode | PSNR (dB) | dpt4 identical | Notes |",
             "|---|---|---|---|---|---|"]
    for r in rows:
        lines.append(f"| {r['scene']} | {r['size']} | {r['mode']} | {r['psnr']} | {r['dpt4']} | {r['notes']} |")
    lines += ["", f"Result: {result}", ""]
    lines += ["Failures:"] + ([f"- {f}" for f in failures] or ["- none"]) + [""]
    lines += ["Flags:"] + ([f"- {f}" for f in flags] or ["- none"]) + [""]
    lines += ["Frame rects (x, y, w, h):"] + [f"- {k}: {v}" for k, v in rects.items()] + [""]
    slow = max(runs.values(), key=lambda r: r.seconds)
    lines += [f"Timing: {len(runs)} runs, wall {wall:.1f} s, slowest {slow.name} {slow.seconds:.1f} s", ""]
    lines += [f"- {r.name}: rc={r.rc} {r.seconds:.1f} s" for r in runs.values()]
    text = "\n".join(lines) + "\n"
    (work / "report.md").write_text(text, encoding="utf-8")
    summary = {
        "scene": scene,
        "result": result,
        "failures": failures,
        "flags": flags,
        "rows": rows,
        "frame_rects": {k: list(v) for k, v in rects.items()},
        "wall_seconds": round(wall, 2),
        "runs": [{"name": r.name, "window": [r.w, r.h], "aspect": r.aspect, "dpt": r.dpt, "rc": r.rc,
                  "seconds": round(r.seconds, 2), "png": str(r.png), "log": str(r.dir / "log.txt")}
                 for r in runs.values()],
    }
    (work / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(text)
    print(f"report: {work / 'report.md'}")


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    dep_error = load_deps()
    if dep_error is not None:
        maybe_reexec()
        return skip(f"numpy/Pillow not importable ({dep_error}); set DC2_PYTHON to an interpreter that has them")

    data = resolve_data(args.data)
    if data is None:
        return skip("no game data: set DC2_DATA or pass --data")
    data = data.resolve()
    if not data.is_dir() or not any(data.iterdir()):
        return skip(f"game data missing or empty: {data}")
    exe = args.exe.resolve()
    if not exe.is_file():
        return skip(f"exe not found: {exe}")
    script = args.input.resolve()
    if not script.is_file():
        print(f"input script not found: {script}", file=sys.stderr)
        return 2

    work = args.work.resolve() if args.work else Path(tempfile.mkdtemp(prefix="matrix-", dir=exe.parent))
    work.mkdir(parents=True, exist_ok=True)
    ref, sizes, lb = args.reference, args.sizes, args.letterbox_size
    runs = plan_runs(work, ref, sizes, lb, args.skip_dpt)
    rects = {f"{w}x{h} Fill": frame_rect(w, h) for w, h in [ref, *sizes]}
    rects[f"{lb[0]}x{lb[1]} letterbox"] = frame_rect(*lb)

    print(f"matrix {args.scene}: {len(runs)} runs, {args.jobs} jobs, data {data}, work {work}", flush=True)
    failures: list[str] = []
    flags: list[str] = []
    rows: list[dict] = []
    t0 = time.monotonic()
    try:
        if args.no_run:
            for r in runs.values():
                locate_run(r, work, exe, data, script, args.frame)
        else:
            with concurrent.futures.ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
                list(pool.map(lambda r: run_game(exe, data, script, args.frame, r), runs.values()))
    except RunFailed as e:
        failures.append(f"run failed: {e}")
    wall = time.monotonic() - t0

    if not failures:
        try:
            rows = evaluate(runs, ref, sizes, lb, args.skip_dpt, args.scene, failures.append, flags.append,
                            args.psnr_gate)
        except RunFailed as e:
            failures.append(f"run failed: {e}")
            rows = []
    write_outputs(work, args.scene, rows, failures, flags, runs, wall, rects)
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
