#!/usr/bin/env python3
"""Replay menu lifetimes against published game data and require completed transitions."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import tempfile

from pc_settings_replay import published_data_available


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, required=True)
    parser.add_argument("--work", type=Path, required=True)
    parser.add_argument("--case", choices=("georama", "quick-town", "quick-dungeon", "party-town", "party-dungeon", "monster-menu", "equip-dungeon"), default="georama")
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
    (run / "config.json").write_text(json.dumps({"game": {"debug_mode": False}}), encoding="utf-8")
    pipeline_cache = args.work.resolve() / "pipeline_cache.bin"
    if pipeline_cache.is_file():
        shutil.copyfile(pipeline_cache, save / "pipeline_cache.bin")
    input_path = run / "menu.input"
    party_script = (
        "300 triangle\n306\n370 down\n371\n420 cross\n426\n600 left\n606\n650 cross\n656\n740 cross\n746\n900 circle\n906\n1050 circle\n1056\n"
        "1700 triangle\n1706\n1770 down\n1771\n1820 cross\n1826\n2000 right\n2006\n2050 cross\n2056\n2140 cross\n2146\n2300 circle\n2306\n2450 circle\n2456\n2600 up\n2700\n2750 cross\n2756\n"
    )
    jump, frames, script = {
        "georama": ("georama:0", 800,
                     "150 select\n156\n220 triangle\n226\n420 circle\n426\n620 triangle\n626\n"),
        "quick-town": ("town:10", 1500,
                       "400 l3\n406\n900 l3\n906\n1200 up\n1300\n1350 cross\n1356\n"),
        "quick-dungeon": ("event:26010", 3500,
                          "400 l1 l2 r1 r2 r3\n406\n900 r3\n906\n1400 l3\n1406\n1900 r3\n1906\n2400 r3\n2406\n2900 l3\n2906\n3200 up\n3300\n3350 cross\n3356\n"),
        "party-town": ("town:10", 2900, party_script),
        "party-dungeon": ("event:26010", 2900, party_script),
        # Skips the tutorial, equips the spawned Big Bucks Hammer from the bag and closes the menu, which reloads
        # Max's body for the hammer's stance.
        "equip-dungeon": ("dungeon:0:1", 3600,
                          "300 cross\n306\n520 cross\n526\n900 start\n906\n940 triangle\n946\n1100 cross\n1106\n1250 cross\n1256\n"
                          "1400 cross\n1406\n1550 cross\n1556\n1700 cross\n1706\n1850 cross\n1856\n2000 cross\n2006\n2200 128 0 128 128\n2260\n"
                          "2400 triangle\n2406\n2520 cross\n2526\n2700 right\n2706\n2740 right\n2746\n2780 right\n2786\n2820 right\n2826\n"
                          "2860 right\n2866\n2950 cross\n2956\n3050 cross\n3056\n3150 circle\n3156\n3300 circle\n3306\n"),
        "monster-menu": ("event:26010", 2400,
                         "400 l3\n406\n900 triangle\n906\n970 down\n971\n1020 cross\n1026\n1200 up\n1206\n1250 cross\n1256\n1500 cross\n1506\n1650 cross\n1656\n1800 cross\n1806\n2000 up\n2100\n2150 cross\n2156\n"),
    }[args.case]
    # The first dungeon R3 chord disables the jump's retail debug flag and mounts the ridepod.
    input_path.write_text(script, encoding="utf-8")
    env = {name: value for name, value in os.environ.items() if not name.startswith("DC2_")}
    env["DC2_AUDIO"] = "off"
    for name in ("HIDAPI", "RAWINPUT", "WGI", "DIRECTINPUT"):
        env["SDL_JOYSTICK_" + name] = "0"
    screenshot = run / "screen.png"
    command = [
        str(args.exe.resolve()), "--headless", "--offscreen", "--window", "640x480",
        "--run-dir", str(run), "--save", str(save), "--data", str(data),
        "--jump", jump, "--fast-load", "--frames", str(frames),
        "--input", str(input_path), "--log-level", "menu=debug", "--screenshot", str(screenshot),
    ]
    if args.case.endswith("-dungeon") or args.case == "monster-menu":
        command.append("--invincible")
    if args.case == "equip-dungeon":
        command += ["--give", "21"]
    with args.exe.resolve().open("rb") as binary:
        binary_hash = hashlib.file_digest(binary, "sha256").hexdigest()
    receipt = {"case": args.case, "binary_sha256": binary_hash, "command": command}
    receipt_path = run / "result.json"
    receipt_path.write_text(json.dumps(receipt, indent=2), encoding="utf-8")
    log_path = run / "game.log"
    with log_path.open("wb") as log:
        try:
            result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, env=env, timeout=600)
        except subprocess.TimeoutExpired:
            receipt["timed_out"] = True
            receipt_path.write_text(json.dumps(receipt, indent=2), encoding="utf-8")
            raise
    receipt["exit_code"] = result.returncode
    if (save / "pipeline_cache.bin").is_file():
        shutil.copyfile(save / "pipeline_cache.bin", pipeline_cache)
    if result.returncode:
        receipt_path.write_text(json.dumps(receipt, indent=2), encoding="utf-8")
        raise AssertionError(f"game exited {result.returncode}; see {log_path}")
    output = log_path.read_text(encoding="utf-8", errors="replace")
    # A model retired behind the game's back stays loaded but is never drawn again.
    silent_drops = re.findall(r".*(?:is not attached:|dropped: its resources retired).*", output)
    if silent_drops:
        raise AssertionError(f"characters lost their parts: {silent_drops}; see {log_path}")
    if args.case == "equip-dungeon":
        exits = [int(parts) for parts in re.findall(r"item menu exit: character=0 body reloaded with ([0-9]+) attached parts", output)]
        receipt["attached_parts"] = exits
        receipt_path.write_text(json.dumps(receipt, indent=2), encoding="utf-8")
        # The hammer, the gun and the cap stay attached to the reloaded body.
        if exits != [3]:
            raise AssertionError(f"expected one body reload keeping 3 parts; got {exits}; see {log_path}")
    elif args.case == "georama":
        transitions = [(state, int(frame)) for state, frame in re.findall(
            r"georama menu (ready|closed): town=0, frame=([0-9]+)", output)]
        receipt["transitions"] = transitions
        receipt_path.write_text(json.dumps(receipt, indent=2), encoding="utf-8")
        if ([state for state, _ in transitions] != ["ready", "closed", "ready"] or
                not 220 <= transitions[0][1] < 420 <= transitions[1][1] < 620 <= transitions[2][1] < 800):
            raise AssertionError(f"expected menu open, close and reopen; got {transitions}; see {log_path}")
    else:
        loop = "town" if args.case.endswith("-town") else "dungeon"
        kind = "quick" if args.case.startswith("quick-") else "monster" if args.case == "monster-menu" else "party"
        transitions = [(int(character), live == "true", int(frame)) for character, live, frame in re.findall(
            rf"{kind} change complete: loop={loop}, character=([0-9]+), root_live=(true|false), frame=([0-9]+)", output)]
        receipt["transitions"] = transitions
        receipt_path.write_text(json.dumps(receipt, indent=2), encoding="utf-8")
        expected_characters = [2, 0, 1, 3, 1, 0] if args.case == "quick-dungeon" else [1, 0]
        expected_frames = [600, 2000] if kind == "party" else [400, 900, 1400, 1900, 2400, 2900]
        if kind == "monster":
            expected_characters = [3]
            expected_frames = [1800]
        allowed_delay = 500 if kind in ("party", "monster") else 100
        if ([character for character, _, _ in transitions] != expected_characters or
                not all(live for _, live, _ in transitions) or
                not all(start <= frame < start + allowed_delay for start, (_, _, frame) in zip(expected_frames, transitions))):
            raise AssertionError(f"expected completed live character sequence {expected_characters}; got {transitions}; see {log_path}")
    if f"frame {frames} written to" not in output:
        raise AssertionError(f"replay did not reach its final frame; see {log_path}")
    image = screenshot.read_bytes()
    if (image[:8] != b"\x89PNG\r\n\x1a\n" or image[12:16] != b"IHDR" or
            struct.unpack(">II", image[16:24]) != (640, 480) or len(image) < 1024):
        raise AssertionError(f"missing rendered menu capture: {screenshot}")
    print(f"PASS: {args.case} completed its checked transitions; receipts: {run}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
