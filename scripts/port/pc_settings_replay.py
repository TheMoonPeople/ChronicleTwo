#!/usr/bin/env python3
"""Replay the PC Options flow and assert the settings it actually saved."""

import argparse
import json
import math
import os
from pathlib import Path
import subprocess
import tempfile


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, required=True)
    parser.add_argument("--work", type=Path, required=True)
    parser.add_argument("--case", choices=("pad", "mouse", "zoom"), required=True)
    args = parser.parse_args()
    data = Path(os.environ.get("DC2_DATA", "data")).resolve()
    source = Path(__file__).resolve().parents[2]
    expected = json.loads((source / "tools/kazarov/data_version.json").read_text())
    try:
        marker = json.loads((data.parent / "data.json").read_text())
    except (OSError, ValueError):
        marker = {}
    if not isinstance(marker, dict):
        marker = {}
    if (not (data / "manifest.json").is_file() or
            not (data.parent / "port_data/manifest.json").is_file() or
            marker.get("schema_version") != 1 or
            marker.get("data_version") != expected["data_version"]):
        print("SKIP: no current published game data; set DC2_DATA")
        return 77
    args.work.mkdir(parents=True, exist_ok=True)
    run = Path(tempfile.mkdtemp(prefix=args.case + "-", dir=args.work.resolve()))
    script = {"pad": "pc-settings.input", "mouse": "pc-settings-mouse.input", "zoom": "pc-settings-zoom.input"}[args.case]
    command = [
        str(args.exe.resolve()), "--headless", "--window", "1280x960",
        "--data", str(data), "--save", str(run / "save"), "--jump", "town:10", "--fast-load",
        "--input", str(source / "tools/input" / script),
        "--frames", {"pad": "1850", "mouse": "970", "zoom": "1120"}[args.case],
        "--screenshot", str(run / "screen.png"), "--screenshot-display", "2",
    ]
    env = os.environ.copy()
    for name in ("HIDAPI", "RAWINPUT", "WGI", "DIRECTINPUT"):
        env["SDL_JOYSTICK_" + name] = "0"
    with (run / "game.log").open("wb") as log:
        result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, env=env, timeout=90)
    if result.returncode:
        raise AssertionError(f"game exited {result.returncode}; see {run / 'game.log'}")
    config = json.loads((run / "save/config.json").read_text(encoding="utf-8"))
    expected = {
        "audio": {"master_volume": .95, "soundtrack": "ps2"},
        "input": {"bindings": {"up": ["Mouse3"]}},
    }
    if args.case == "pad":
        expected.update({
            "video": {"present_mode": "mailbox", "max_fps": 30, "interpolation": True,
                      "aspect": "auto", "ui_scale": 1, "show_fps": True},
            "input": {"mouse_sensitivity": .15, "mouse_invert_y": True, "mouse_capture": False,
                      "stick_sensitivity": 1.5, "stick_invert_x": True, "stick_invert_y": True,
                      "glyph_device": "ps3", "bindings": {"cross": ["K"], "circle": ["L"]}},
        })
    if args.case == "zoom":
        expected = {"input": {"mouse_zoom": True}}
    for section, entries in expected.items():
        for key, value in entries.items():
            actual = config[section][key]
            equal = math.isclose(actual, value, rel_tol=1e-5) if isinstance(value, float) else actual == value
            if not equal:
                raise AssertionError(f"{section}.{key}: expected {value!r}, got {actual!r}; receipts: {run}")
    if not (run / "screen-display-1.png").is_file():
        raise AssertionError(f"missing display capture: {run}")
    print(f"PASS: {args.case} PC settings replay and saved configuration; receipts: {run}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
