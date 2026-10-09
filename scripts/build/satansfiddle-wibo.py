#!/usr/bin/env python3
"""Adapt mwccgap's wibo invocation to one Satan's Fiddle compilation."""

import json
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[2]


def invocation(arguments):
    """Separate only the compiler, generated output option and final source."""
    if len(arguments) < 4:
        raise ValueError("expected COMPILER [OPTIONS] -o OBJECT SOURCE")
    compiler, *options, source = arguments
    outputs = [index for index, value in enumerate(options) if value == "-o"]
    if len(outputs) != 1 or outputs[0] + 1 >= len(options):
        raise ValueError("expected exactly one -o OBJECT option")
    index = outputs[0]
    output = options[index + 1]
    del options[index:index + 2]
    return Path(compiler).resolve(), options, Path(output).resolve(), Path(source).resolve()


def unit_name(value):
    return value.replace("\\", "/").rsplit("/", 1)[-1]


def validate_profile_units(profile):
    """Reject unknown game source identities before discarding other units' rows."""
    source_directory = ROOT / "ps2/src"
    known_units = {
        path.name for suffix in ("*.c", "*.cpp")
        for path in source_directory.rglob(suffix) if path.is_file()
    }
    tables = [("translation_units", profile.get("translation_units", []), "name")]
    for section, names in (
        ("floating_point", ("expression_overrides", "literal_overrides")),
        ("placement_new", ("statement_conversions",)),
    ):
        block = profile.get(section, {})
        if not isinstance(block, dict):
            raise ValueError(f"{section} must be a JSON object")
        for name in names:
            tables.append((f"{section}.{name}", block.get(name, []), "translation_unit"))
    for location, rows, field in tables:
        if not isinstance(rows, list):
            raise ValueError(f"{location} must be a JSON array")
        for row in rows:
            if not isinstance(row, dict):
                raise ValueError(f"{location} rows must be JSON objects")
            name = row.get(field)
            if not isinstance(name, str) or unit_name(name) not in known_units:
                raise ValueError(f"unknown translation unit {name!r} in {location}")


def main(arguments):
    compiler, options, output, source = invocation(arguments)
    binary = os.environ.get("SATANSFIDDLE", "satansfiddle")
    executable = shutil.which(binary)
    if executable is None:
        raise ValueError(
            f"Satan's Fiddle executable {binary!r} is unavailable; "
            "build Satan's Fiddle and set SATANSFIDDLE to its executable"
        )
    profile_path = Path(os.environ.get(
        "SATANSFIDDLE_CONFIG", ROOT / "scripts/build/satansfiddle.json"
    ))
    profile = json.loads(profile_path.read_text())
    if not isinstance(profile, dict):
        raise ValueError("Satan's Fiddle profile must be a JSON object")
    validate_profile_units(profile)
    logical_unit = unit_name(os.environ.get("SATANSFIDDLE_TRANSLATION_UNIT", source.name))

    # mwccgap supplies the complete flags for each pass; retain argument boundaries.
    profile["compiler_path"] = str(compiler)
    profile["compiler_options"] = shlex.join(options)
    profile["translation_units"] = [
        row for row in profile.get("translation_units", [])
        if unit_name(row["name"]) == logical_unit
    ]
    floating_point = profile.get("floating_point", {})
    for key in ("expression_overrides", "literal_overrides"):
        if key in floating_point:
            floating_point[key] = [
                row for row in floating_point[key]
                if unit_name(row["translation_unit"]) == logical_unit
            ]
    placement_new = profile.get("placement_new", {})
    if "statement_conversions" in placement_new:
        placement_new["statement_conversions"] = [
            row for row in placement_new["statement_conversions"]
            if unit_name(row["translation_unit"]) == logical_unit
        ]

    # Each compiler pass runs in a fresh process with a private configuration.
    with tempfile.TemporaryDirectory(prefix="chronicletwo-satansfiddle-") as directory:
        configuration = Path(directory) / "config.json"
        configuration.write_text(json.dumps(profile, indent=2) + "\n")
        return subprocess.run([
            executable, "--config", str(configuration), "--output", str(output),
            "--translation-unit", logical_unit, str(source),
        ]).returncode


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except (OSError, ValueError, KeyError, TypeError) as error:
        print(f"satansfiddle-wibo: {error}", file=sys.stderr)
        sys.exit(1)
