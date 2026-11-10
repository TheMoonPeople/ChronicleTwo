"""Publish changed Luau sources in parallel and prune unchanged obsolete copies."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
import os
from pathlib import Path
import shutil
import tempfile


def resolved_path(path):
    """Normalize Windows extended-path spellings used by concurrent path resolution."""
    resolved = str(path.resolve())
    if resolved.startswith("\\\\?\\UNC\\"):
        resolved = "\\\\" + resolved[8:]
    elif resolved.startswith("\\\\?\\"):
        resolved = resolved[4:]
    return Path(resolved)


def contained(root, relative):
    """Resolve an owned path within its publication root."""
    path = root / relative
    resolved = resolved_path(path)
    if not resolved.is_relative_to(root):
        raise ValueError(f"Script path leaves its root: {resolved} (root: {root})")
    return path


def sync(sources, scripts, expected, manifest, jobs):
    """Keep owned scripts current while preserving edited or unowned obsolete files."""
    sources = resolved_path(sources)
    scripts = resolved_path(scripts)
    relatives = expected.read_text(encoding="utf-8").splitlines()
    relatives = [relative for relative in relatives if relative]
    for relative in relatives:
        if Path(relative).is_absolute() or ".." in Path(relative).parts:
            raise ValueError(f"Unsafe script path: {relative}")
    try:
        contents = manifest.read_text(encoding="utf-8")
        try:
            owned = json.loads(contents)
        except json.JSONDecodeError:
            # Adopt the ownership hashes written by the CMake publisher.
            owned = {line[65:]: {"source": None, "sha256": line[:64]} for line in contents.splitlines() if len(line) >= 66}
    except FileNotFoundError:
        owned = {}
    for relative in owned:
        if Path(relative).is_absolute() or ".." in Path(relative).parts:
            raise ValueError(f"Unsafe owned script path: {relative}")

    def publish(relative):
        """Copy and hash one changed source without starting a child process."""
        source = sources / relative
        destination = scripts / relative
        stat = source.stat()
        signature = [stat.st_mtime_ns, stat.st_size]
        previous = owned.get(relative)
        if previous and previous["source"] == signature and destination.is_file():
            return relative, previous
        source = contained(sources, relative)
        destination = contained(scripts, relative)
        destination.parent.mkdir(parents=True, exist_ok=True)
        descriptor, temporary_name = tempfile.mkstemp(dir=destination.parent, prefix=destination.name + ".", suffix=".tmp")
        os.close(descriptor)
        temporary = Path(temporary_name)
        try:
            shutil.copyfile(source, temporary)
            digest = hashlib.sha256(temporary.read_bytes()).hexdigest()
            temporary.replace(destination)
        finally:
            temporary.unlink(missing_ok=True)
        # The output timestamp advances even when a checkout restores an older source timestamp.
        return relative, {"source": signature, "sha256": digest}

    with ThreadPoolExecutor(max_workers=jobs) as pool:
        current = dict(pool.map(publish, relatives))
    for relative, previous in owned.items():
        if relative in current:
            continue
        destination = contained(scripts, relative)
        if destination.is_file() and hashlib.sha256(destination.read_bytes()).hexdigest() == previous["sha256"]:
            destination.unlink()
            print(f"Removed the obsolete script {relative}")
    manifest.parent.mkdir(parents=True, exist_ok=True)
    temporary = manifest.with_suffix(".tmp")
    temporary.write_text(json.dumps(current, sort_keys=True), encoding="utf-8")
    temporary.replace(manifest)


def main():
    """Synchronize the script outputs declared by CMake."""
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("sources", "scripts", "expected", "manifest", "stamp"):
        parser.add_argument(f"--{name}", required=True, type=Path)
    parser.add_argument("--jobs", type=int, default=min(16, os.cpu_count() or 1))
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be positive")
    sync(args.sources, args.scripts, args.expected, args.manifest, args.jobs)
    args.stamp.touch()


if __name__ == "__main__":
    main()
