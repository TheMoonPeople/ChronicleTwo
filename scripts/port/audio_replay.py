#!/usr/bin/env python3
"""Check delayed title and shop sound playback after initialization has returned."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

from pc_settings_replay import published_data_available


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, required=True)
    parser.add_argument("--work", type=Path, required=True)
    parser.add_argument("--case", choices=("title", "shop", "costume"), default="title")
    args = parser.parse_args()
    source = Path(__file__).resolve().parents[2]
    data = Path(os.environ.get("DC2_DATA", "data")).resolve()
    expected = json.loads((source / "tools/kazarov/data_version.json").read_text())
    if not published_data_available(data, expected):
        print("SKIP: no current published game data; set DC2_DATA")
        return 77
    args.work.mkdir(parents=True, exist_ok=True)
    run = Path(tempfile.mkdtemp(prefix=args.case + "-", dir=args.work.resolve()))
    save = run / "save"
    save.mkdir()
    pipeline_cache = args.work.resolve() / "pipeline_cache.bin"
    if pipeline_cache.is_file():
        shutil.copyfile(pipeline_cache, save / "pipeline_cache.bin")
    env = {name: value for name, value in os.environ.items() if not name.startswith("DC2_")}
    env["DC2_AUDIO"] = "off"
    env["DC2_AUDIO_TRACE"] = "1"
    for name in ("HIDAPI", "RAWINPUT", "WGI", "DIRECTINPUT"):
        env["SDL_JOYSTICK_" + name] = "0"
    jump, script, frames, bank_port, driver_port, music = {
        "title": ("title", "sweep-title.input", 1500, 4, 14, "bg_048"),
        "shop": ("town:10", "area-town-shop.input", 3100, 8, 11, "bg_050"),
        "costume": ("title", "sweep-costume.input", 1100, 4, 14, "bg_048"),
    }[args.case]
    input_path = source / "tools/input" / script
    if args.case in ("title", "costume"):
        input_path = run / f"{args.case}.input"
        input_path.write_text(
            "600 start\n606\n"
            + ("720 down\n726\n780 down\n786\n840 down\n846\n900 cross\n906\n"
               if args.case == "title" else "780 cross\n786\n"),
            encoding="utf-8",
        )
    command = [
        str(args.exe.resolve()), "--headless", "--offscreen", "--window", "640x480",
        "--run-dir", str(run), "--save", str(save), "--data", str(data),
        "--jump", jump, "--fast-load", "--frames", str(frames),
        "--input", str(input_path),
        "--log-level", "audio=trace", "--screenshot", str(run / "screen.png"),
    ]
    with args.exe.resolve().open("rb") as binary:
        binary_hash = hashlib.file_digest(binary, "sha256").hexdigest()
    receipt = {"case": args.case, "binary_sha256": binary_hash, "command": command}
    (run / "result.json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")
    log_path = run / "game.log"
    with log_path.open("wb") as log:
        try:
            result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, env=env, timeout=600)
        except subprocess.TimeoutExpired:
            receipt["timed_out"] = True
            (run / "result.json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")
            raise
    receipt["exit_code"] = result.returncode
    (run / "result.json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")
    if (save / "pipeline_cache.bin").is_file():
        shutil.copyfile(save / "pipeline_cache.bin", pipeline_cache)
    if result.returncode:
        raise AssertionError(f"game exited {result.returncode}; see {log_path}")
    output = log_path.read_text(encoding="utf-8", errors="replace")
    if not re.search(rf"sound bundle: port {bank_port} bank 0 loaded", output):
        raise AssertionError(f"{args.case} bank did not load; see {log_path}")
    if not re.search(rf"port {driver_port} program 0 note 60 -> sample [0-9]+", output):
        raise AssertionError(f"{args.case} did not dispatch its delayed sound after initialization; see {log_path}")
    music_path = f"snd2/bgm/{music}.sound/sequences/{music}_000.json"
    music_start = re.search(rf"SQ_Play PORT=0 SEQ_NO=0 path={re.escape(music_path)}", output)
    if not music_start:
        raise AssertionError(f"{args.case} did not start its menu music {music}; see {log_path}")
    if not re.search(r"port 0 program [0-9]+ note [0-9]+ -> sample [0-9]+", output[music_start.end():]):
        raise AssertionError(f"{args.case} menu music did not dispatch a sample; see {log_path}")
    print(f"PASS: {args.case} dispatched its delayed sound and menu music; receipts: {run}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
