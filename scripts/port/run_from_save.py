#!/usr/bin/env python3
"""Run a frame-bounded replay against an isolated copy of a save fixture."""

import argparse
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


def run_from_save(exe, data, fixture, script, frames, screenshot):
    """Keep the fixture immutable; discard only the temporary replay copy."""
    if not fixture.is_dir():
        raise ValueError(f"save fixture is not a directory: {fixture}")
    if not any((fixture / folder).is_dir() for folder in ("saves", "mc0", "mc1")):
        raise ValueError(f"save fixture has no saves or legacy card directory: {fixture}")
    for label, path in (("executable", exe), ("input script", script)):
        if not path.is_file():
            raise ValueError(f"{label} is not a file: {path}")
    if not (data / "manifest.txt").is_file():
        raise ValueError(f"data root has no manifest.txt: {data}")
    screenshot.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="darkchronicle-save-") as temp:
        save = Path(temp) / "save"
        shutil.copytree(fixture, save)
        command = [str(exe), "--headless", "--offscreen", "--data", str(data),
                   "--save", str(save), "--input", str(script), "--frames", str(frames),
                   "--screenshot", str(screenshot)]
        env = os.environ.copy()
        for name in ("DC2_JUMP", "DC2_GIVE", "DC2_FAST_LOAD"):
            env.pop(name, None)
        return subprocess.run(command, check=False, env=env).returncode


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, required=True)
    parser.add_argument("--data", type=Path, required=True)
    parser.add_argument("--save-fixture", type=Path, required=True)
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--frames", type=int, required=True)
    parser.add_argument("--screenshot", type=Path, required=True)
    args = parser.parse_args()
    if args.frames <= 0:
        parser.error("--frames must be positive")
    try:
        return run_from_save(args.exe.resolve(), args.data.resolve(), args.save_fixture.resolve(),
                             args.input.resolve(), args.frames, args.screenshot.resolve())
    except (OSError, ValueError) as error:
        parser.exit(2, f"{error}\n")


if __name__ == "__main__":
    raise SystemExit(main())
