#!/usr/bin/env python3
"""Run a fixed dungeon floor-1 performance scenario and summarize --log-fps budget lines.

  python scripts/port/bench_dungeon.py --exe port/build/pc/darkchronicle [--data DIR] [--work DIR]

Uses tools/input/bench-dungeon-floor1.input with --jump dungeon:0:1 --fast-load.
Writes summary.json under --work and prints a short report. Exit 77 when game data is missing.
"""

from __future__ import annotations

import argparse
import json
import math
import os
import re
import statistics
import subprocess
import sys
import time
from pathlib import Path

SKIP = 77
REPO = Path(__file__).resolve().parents[2]
INPUT = REPO / "tools/input/bench-dungeon-floor1.input"
FRAMES = 5200
WARMUP_SAMPLES = 2
STEADY_START_FRAME = 3200
DEFAULT_SPAWN_ENEMIES = 120
DEFAULT_SPAWN_MONSTER = 0
DEFAULT_SPAWN_VSYNC = 2800
RUN_TIMEOUT = 600

PRESENT_RE = re.compile(
    r"present:\s+FPS\s+(?P<fps>[\d.]+)\s+"
    r"TICK\s+(?P<tick>[\d.]+)/\d+\s+"
    r"DRAWS\s+(?P<draws>\d+)\s+"
    r"CANON\s+(?P<canon>[\d.]+)ms\s+"
    r"DISP\s+(?P<disp>[\d.]+)ms\s+"
    r"OTH\s+(?P<oth>[\d.]+)ms"
)


def skip(reason: str) -> int:
    print(f"SKIP: {reason}")
    return SKIP


def resolve_data(arg: Path | None) -> Path | None:
    if arg is not None:
        return arg
    env = os.environ.get("DC2_DATA", "")
    if env:
        return Path(env)
    candidate = REPO / "port/run/data"
    if candidate.is_dir():
        return candidate
    if (REPO / "data").is_dir():
        return REPO / "data"
    return None


def bench_config(georama: int, interpolation: bool) -> dict:
    return {
        "game": {
            "debug_mode": False,
            "skip_intro": True,
            "georama_poly_multiplier": georama,
            "expanded_dungeon_monsters": True,
        },
        "video": {
            "interpolation": interpolation,
            "interpolation_draw_budget": 2400,
            "interpolation_fps_floor": 54,
            "interpolation_multi_present": False,
            "max_fps": 60,
            "show_fps": True,
            "fps_detail": "budget",
            "width": 1280,
            "height": 720,
            "fullscreen": False,
            "aspect": "auto",
            "present_mode": "fifo",
        },
    }


def parse_log(text: str) -> list[dict]:
    rows: list[dict] = []
    for line in text.splitlines():
        m = PRESENT_RE.search(line)
        if not m:
            continue
        rows.append({k: float(m.group(k)) if k != "draws" else int(m.group(k)) for k in m.groupdict()})
    return rows


def summarize(rows: list[dict]) -> dict:
    if len(rows) <= WARMUP_SAMPLES:
        return {"samples": len(rows), "steady_samples": 0}
    steady = rows[WARMUP_SAMPLES:]

    def stats(key: str) -> dict:
        vals = [r[key] for r in steady]
        return {
            "mean": statistics.mean(vals),
            "median": statistics.median(vals),
            "min": min(vals),
            "max": max(vals),
        }

    return {
        "samples": len(rows),
        "steady_samples": len(steady),
        "fps": stats("fps"),
        "tick": stats("tick"),
        "draws": stats("draws"),
        "canon_ms": stats("canon"),
        "disp_ms": stats("disp"),
        "oth_ms": stats("oth"),
    }


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    p.add_argument("--exe", type=Path, required=True)
    p.add_argument("--data", type=Path, default=None)
    p.add_argument("--work", type=Path, default=None)
    p.add_argument("--frames", type=int, default=FRAMES)
    p.add_argument("--georama", type=int, default=1, choices=range(1, 7))
    p.add_argument("--no-interpolation", action="store_true")
    p.add_argument(
        "--offscreen",
        action="store_true",
        help="use --headless --offscreen (no real present; DISP ~0)",
    )
    p.add_argument(
        "--bench-spawn-enemies",
        type=int,
        default=DEFAULT_SPAWN_ENEMIES,
        help=f"spawn N monsters near player once on floor (default {DEFAULT_SPAWN_ENEMIES}, capped at 24 or 60)",
    )
    p.add_argument("--bench-spawn-monster", type=int, default=DEFAULT_SPAWN_MONSTER)
    p.add_argument("--bench-spawn-vsync", type=int, default=DEFAULT_SPAWN_VSYNC)
    p.add_argument("--no-spawn", action="store_true", help="disable bench enemy spawn")
    args = p.parse_args(argv)

    data = resolve_data(args.data)
    if data is None or not data.is_dir():
        return skip("no game data (--data, DC2_DATA, or port/run/data)")

    if not args.exe.is_file():
        return skip(f"executable not found: {args.exe}")

    if not INPUT.is_file():
        print(f"FAIL: missing input script {INPUT}", file=sys.stderr)
        return 1

    work = args.work or (REPO / "port/run/bench" / time.strftime("%Y%m%d-%H%M%S"))
    work.mkdir(parents=True, exist_ok=True)
    save = work / "save"
    save.mkdir(exist_ok=True)
    config_path = save / "config.json"
    spawn = not args.no_spawn and args.bench_spawn_enemies > 0
    config_path.write_text(
        json.dumps(
            bench_config(args.georama, not args.no_interpolation),
            indent=4,
        ),
        encoding="utf-8",
    )

    cmd = [
        str(args.exe.resolve()),
        "--data",
        str(data.resolve()),
        "--save",
        str(save.resolve()),
        "--jump",
        "dungeon:0:1",
        "--fast-load",
        "--window",
        "1280x720",
        "--input",
        str(INPUT.resolve()),
        "--frames",
        str(args.frames),
        "--log-fps",
    ]
    if args.offscreen:
        cmd += ["--headless", "--offscreen"]

    if spawn:
        cmd += [
            "--bench-spawn-enemies",
            f"{args.bench_spawn_enemies}:{args.bench_spawn_monster}:{args.bench_spawn_vsync}",
        ]

    env = os.environ.copy()
    for name in ("DC2_JUMP", "DC2_GIVE", "DC2_FAST_LOAD"):
        env.pop(name, None)

    print(f"bench: work={work}")
    print(
        f"bench: georama={args.georama}x interpolation={not args.no_interpolation} "
        f"offscreen={args.offscreen} expanded_monsters=True spawn={spawn}"
    )
    log_path = work / "log.txt"
    t0 = time.monotonic()
    try:
        with log_path.open("w", encoding="utf-8") as log_file:
            proc = subprocess.run(
                cmd,
                stdout=log_file,
                stderr=subprocess.STDOUT,
                timeout=RUN_TIMEOUT,
                env=env,
            )
    except subprocess.TimeoutExpired:
        print("FAIL: benchmark timed out", file=sys.stderr)
        return 1
    elapsed = time.monotonic() - t0
    log = log_path.read_text(encoding="utf-8", errors="replace")

    rows = parse_log(log)
    summary = summarize(rows)
    report = {
        "version": 1,
        "rc": proc.returncode,
        "seconds": elapsed,
        "frames": args.frames,
        "steady_start_frame": STEADY_START_FRAME,
        "input": str(INPUT.relative_to(REPO)),
        "config": bench_config(args.georama, not args.no_interpolation),
        "metrics": summary,
    }
    (work / "summary.json").write_text(json.dumps(report, indent=2), encoding="utf-8")

    if proc.returncode != 0:
        print(f"FAIL: darkchronicle exited {proc.returncode}", file=sys.stderr)
        return proc.returncode

    if summary.get("steady_samples", 0) < 3:
        print("FAIL: fewer than 3 steady-state log-fps samples (need longer run or check data)", file=sys.stderr)
        return 1

    m = summary
    print(
        f"BENCH_OK steady={m['steady_samples']} "
        f"FPS median={m['fps']['median']:.1f} "
        f"TICK median={m['tick']['median']:.1f} "
        f"CANON median={m['canon_ms']['median']:.2f}ms "
        f"DISP median={m['disp_ms']['median']:.2f}ms "
        f"OTH median={m['oth_ms']['median']:.2f}ms "
        f"DRAWS median={m['draws']['median']:.0f} "
        f"({elapsed:.1f}s wall)"
    )
    print(f"bench: wrote {work / 'summary.json'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
