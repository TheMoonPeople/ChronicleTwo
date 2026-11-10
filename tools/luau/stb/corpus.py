"""Locates the published script corpus and classifies each script by the interpreter that runs it."""

from __future__ import annotations

import enum
import os
import shutil
import subprocess
import tempfile
import zipfile
from collections.abc import Iterator
from pathlib import Path, PurePosixPath

from .program import is_script


class Kind(enum.Enum):
    """Script kinds, distinguished by the external-function table registered with the interpreter."""

    ACTION = "action"
    EFFECT = "effect"
    MONSTER = "monster"
    EVENT = "event"
    EVENT_ARG = "event_arg"


def classify(path: str) -> Kind:
    """Kind of the script published at a data-relative path."""
    parts = PurePosixPath(path.lower()).parts
    name = parts[-1]
    if parts[:2] == ("dungeon", "act_script") or parts[0] == "mainchr":
        return Kind.ACTION
    if parts[:2] == ("dungeon", "monster"):
        return Kind.MONSTER
    if parts[:2] in (("dungeon", "eff_script"), ("dungeon", "articles"), ("dungeon", "sphida")):
        return Kind.EFFECT
    if parts[:2] == ("event", "tbox") and len(parts) > 3:
        return Kind.EFFECT
    if "_arg" in name:
        return Kind.EVENT_ARG
    return Kind.EVENT


def _seven_zip() -> str | None:
    for candidate in ("7z", "7z.exe", "7za"):
        found = shutil.which(candidate)
        if found:
            return found
    for root in (os.environ.get("ProgramFiles"), os.environ.get("ProgramFiles(x86)")):
        if root and (Path(root) / "7-Zip" / "7z.exe").is_file():
            return str(Path(root) / "7-Zip" / "7z.exe")
    return None


def _from_directory(root: Path) -> Iterator[tuple[str, bytes]]:
    for path in sorted(root.rglob("*")):
        if path.is_file():
            data = path.read_bytes()
            if is_script(data):
                yield path.relative_to(root).as_posix(), data


def _from_zip(archive: Path) -> Iterator[tuple[str, bytes]]:
    with zipfile.ZipFile(archive) as zf:
        names = [n for n in zf.namelist() if n.lower().endswith((".stb", ".stb_"))]
        methods = {zf.getinfo(n).compress_type for n in names}
        if methods <= {zipfile.ZIP_STORED, zipfile.ZIP_DEFLATED}:
            for name in sorted(names):
                data = zf.read(name)
                if is_script(data):
                    yield name.replace("\\", "/"), data
            return
    # The publication compresses entries with Zstandard, which zipfile cannot read before Python 3.14.
    tool = _seven_zip()
    if tool is None:
        raise RuntimeError(f"{archive} uses Zstandard entries; install 7-Zip or pass an extracted directory")
    with tempfile.TemporaryDirectory() as directory:
        subprocess.run([tool, "x", str(archive), f"-o{directory}", "-ir!*.stb", "-ir!*.stb_", "-y"], check=True, stdout=subprocess.DEVNULL)
        yield from _from_directory(Path(directory))


def scripts(source: Path) -> Iterator[tuple[str, bytes]]:
    """Every script in a data directory or data.zip, as (data-relative path, bytes), in path order."""
    if source.is_dir():
        yield from _from_directory(source)
    elif zipfile.is_zipfile(source):
        yield from _from_zip(source)
    else:
        raise RuntimeError(f"{source} is neither a data directory nor a zip archive")
