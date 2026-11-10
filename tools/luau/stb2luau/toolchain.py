"""Fetches the pinned Luau and StyLua release binaries used by the Python Luau transpiler."""

from __future__ import annotations

import hashlib
import json
import platform
import stat
import urllib.request
import zipfile
from pathlib import Path
from typing import Any

MANIFEST = Path(__file__).resolve().parents[1] / "toolchain.json"
ROOT = Path(__file__).resolve().parents[3] / "port" / "build" / "luau-tools"


def _manifest() -> dict[str, Any]:
    return json.loads(MANIFEST.read_text(encoding="utf-8"))


def _platform_key() -> str | None:
    return {"Windows": "windows", "Linux": "linux", "Darwin": "macos"}.get(platform.system())


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _install(directory: Path, asset: dict[str, str], key: str) -> None:
    directory.mkdir(parents=True, exist_ok=True)
    archive = directory.parent / f"{directory.name}-{key}.zip"
    print(f"Downloading {asset['url']}")
    with urllib.request.urlopen(asset["url"]) as response, archive.open("wb") as handle:
        handle.write(response.read())

    actual = _sha256(archive)
    if actual != asset["sha256"]:
        archive.unlink()
        raise RuntimeError(f"SHA-256 mismatch for {asset['url']}: expected {asset['sha256']}, got {actual}")

    with zipfile.ZipFile(archive) as zf:
        zf.extractall(directory)
    archive.unlink()

    if key != "windows":
        for path in directory.rglob("*"):
            if path.is_file():
                path.chmod(path.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def executable(tool: str, name: str, fetch: bool = True) -> Path | None:
    """Return the path to executable `name` of `tool`, downloading and extracting the release if needed."""
    spec = _manifest()["tools"][tool]
    if name not in spec["executables"]:
        raise ValueError(f"{name!r} is not a pinned executable of {tool!r}")

    key = _platform_key()
    asset = spec["assets"].get(key) if key is not None else None
    directory = ROOT / f"{tool}-{spec['version']}"
    path = directory / (f"{name}.exe" if key == "windows" else name)
    if path.is_file():
        return path
    if not fetch or asset is None or key is None:
        return None

    _install(directory, asset, key)
    if not path.is_file():
        raise RuntimeError(f"{path.name} not found in the {tool} {spec['version']} archive")
    return path


def main() -> None:
    """Fetch every pinned tool and print the path of each executable."""
    for tool, spec in _manifest()["tools"].items():
        for name in spec["executables"]:
            print(f"{tool} {name}: {executable(tool, name)}")


if __name__ == "__main__":
    main()
