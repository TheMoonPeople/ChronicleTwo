"""Read-only audit of resource operands in a completed native asset publication."""

import argparse
import collections
import json
from pathlib import Path
import struct

LEGACY = {"chr", "chr_", "mds", "mdt", "mot", "wgt", "bbp", "cfg", "clo", "map", "img", "tm2", "snd", "pss"}
TARGETS = {**dict.fromkeys(("chr", "chr_", "mds", "mdt", "mot", "wgt", "bbp"), "gltf"), **dict.fromkeys(("clo", "img", "tm2"), "json"), "cfg": "cfg.json", "map": "map.json", "snd": "sound.json", "pss": "mp4"}


def word(data, at):
    if at < 0 or at + 4 > len(data):
        raise ValueError(f"script word outside file: {at:#x}")
    return struct.unpack_from("<i", data, at)[0]


def decode(data):
    """Decode the same function boundaries as the runtime timing validator."""
    if len(data) < 28 or data[:3] not in (b"SB2", b"STB"):
        raise ValueError("not an SB2/STB program")
    code, prog, count = word(data, 8), word(data, 12), word(data, 16)
    if code < 28 or code >= len(data) or code % 4 or prog < 28 or not 0 <= count <= 4096 or prog + count * 8 > len(data):
        raise ValueError("invalid script sections")

    def function(block):
        if block < 28 or block % 4:
            raise ValueError("invalid function block")
        local, args = word(data, block + 8), word(data, block + 12)
        if args < 0 or args > local:
            raise ValueError("invalid function frame")
        relative = word(data, block)
        at = code + relative
        if relative < 0 or at % 4:
            raise ValueError("invalid function code offset")
        farthest, instructions = at, []
        while True:
            op, a1, a2 = word(data, at), word(data, at + 4), word(data, at + 8)
            if not 1 <= op <= 30:
                raise ValueError(f"invalid opcode {op} at {at:#x}")
            if op in (16, 17, 18):
                target = code + a1
                if a1 < 0 or target % 4 or target + 12 > len(data):
                    raise ValueError("jump outside file")
                farthest = max(farthest, target)
            if op == 19 and (a2 < 0 or code + a2 + 16 > len(data)):
                raise ValueError("call outside file")
            instructions.append((at, op, a1, a2))
            at += 12
            if op in (15, 27) and at > farthest:
                return instructions

    todo = [word(data, 4)] + [word(data, prog + i * 8 + 4) for i in range(count)]
    seen, covered, instructions = set(), bytearray(len(data)), {}

    def include(body):
        covered[body[0][0]:body[-1][0] + 12] = bytes([1]) * (body[-1][0] + 12 - body[0][0])
        instructions.update((item[0], item) for item in body)

    for block in todo:
        if block in seen:
            continue
        seen.add(block)
        body = function(block)
        todo.extend(code + a2 for _, op, _, a2 in body if op == 19)
        include(body)
    at = code
    while at + 56 + 12 <= len(data):
        if word(data, at) == at - code + 56 and not covered[at] and at not in seen:
            local, args = word(data, at + 8), word(data, at + 12)
            if 0 <= args <= local < 256 and 1 <= word(data, at + 56) <= 30:
                try:
                    body = function(at)
                except ValueError:
                    pass
                else:
                    seen.add(at)
                    include(body)
                    at = body[-1][0] + 8
        at += 4
    return code, sorted(instructions.values())


def strings(data):
    code, instructions = decode(data)
    for at, op, a1, a2 in instructions:
        if (op, a1) != (3, 3):
            continue
        start = code + a2
        if a2 < 0 or start >= len(data):
            raise ValueError("string outside file")
        end = data.find(b"\0", start)
        if end < 0:
            raise ValueError("unterminated script string")
        yield at, data[start:end]


def is_valid_script(data):
    """Give a fully validated VM priority over coincidental untagged PACK headers."""
    if data[:4] not in (b"SB2\0", b"STB\0"):
        return False
    try:
        list(strings(data))
        return True
    except ValueError:
        return False


def members(data):
    """Return validated raw PACK members, or None for a different file format."""
    if is_valid_script(data):
        return None
    result, seen, at = [], set(), 0
    names = set()
    while at not in seen and at + 76 <= len(data) and len(result) < 16384:
        seen.add(at)
        entry = data[at:at + 76]
        end = entry[:64].find(b"\0")
        if end == 0:
            return result or None
        if end < 0 or any(c < 32 or c in (47, 92) for c in entry[:end]):
            return None
        offset, size, advance = struct.unpack_from("<III", entry, 64)
        start = at + offset
        if offset < 76 or start + size > len(data) or advance < 76:
            return None
        name = "".join(chr(c).lower() if c < 128 else f"%{c:02X}" for c in entry[:end])
        key = name if name not in names else f"{name}#entry:{len(result)}"
        names.add(name)
        result.append((key, data[start:start + size]))
        at += advance
    return None


def native_path(alias, extension):
    parts = alias.split("/")
    for i, part in enumerate(parts):
        base, separator, marker = part.partition("#")
        marker = "." + marker.replace(":", "_") if separator else ""
        if i == len(parts) - 1:
            stem = base if marker.startswith(".offset_") else base.rsplit(".", 1)[0]
            parts[i] = stem + ("_" if base.lower().endswith(".chr_") else "") + marker + "." + extension
        elif base.lower().rstrip("_").endswith(".chr"):
            parts[i] = base.rstrip("_")[:-4] + ("_" if base.endswith("_") else "") + marker + ".assets"
        else:
            parts[i] = base + marker
    return "/".join(parts)


def normalize(text):
    text = text.replace("\\", "/").lower().split(":", 1)[-1].lstrip("/")
    return text[:-2] if text.endswith(";1") else text


def audit(raw, stage):
    native = stage / "data"
    source_paths, leaves, profiles = {}, collections.defaultdict(set), set()

    def inventory(data, alias, depth=0):
        if depth > 16:
            raise ValueError("archive nesting exceeds 16")
        ext = alias.split("#", 1)[0].rsplit(".", 1)[-1]
        if ext in TARGETS:
            target = native_path(alias, TARGETS[ext])
            source_paths[alias] = target
            leaves[alias.rsplit("/", 1)[-1]].add(alias)
        if ext in ("chr", "chr_"):
            sidecar = native / native_path(alias, "game.json")
            if sidecar.is_file():
                profiles.update(json.loads(sidecar.read_text(encoding="utf-8")).get("profiles", {}))
        for name, payload in members(data) or []:
            if payload:
                inventory(payload, alias + "/" + name, depth + 1)

    for path in sorted(raw.rglob("*")):
        if path.is_file():
            inventory(path.read_bytes(), path.relative_to(raw).as_posix().lower())
    report = {"scripts": 0, "string_pushes": 0, "legacy_suffix_counts": {}, "actionable_residuals": [], "missing_native_targets": [], "missing_direct_references": [], "unresolved_original_references": [], "invalid_scripts": []}
    counts = collections.Counter()
    for directory in (native,):
        if not directory.is_dir():
            continue
        for path in sorted(directory.rglob("*")):
            if not path.is_file():
                continue
            if path.suffix.lower().rstrip("_") != ".stb":
                with path.open("rb") as stream:
                    if stream.read(4) not in (b"SB2\0", b"STB\0"):
                        continue
            report["scripts"] += 1
            try:
                for at, value in strings(path.read_bytes()):
                    report["string_pushes"] += 1
                    if not value.isascii():
                        continue
                    text = normalize(value.decode("ascii"))
                    ext = text.rsplit(".", 1)[-1]
                    if ext not in LEGACY:
                        if "/" in text and ext in {"gltf", "json", "wav", "mp4"} and not (native / text).is_file():
                            report["missing_direct_references"].append({"script": path.relative_to(stage).as_posix(), "instruction_offset": at, "value": value.decode("ascii")})
                        continue
                    counts[ext] += 1
                    stem, separator, extension = text.rpartition(".")
                    trimmed = stem.rstrip(" \t\r\n\v\f") + separator + extension
                    exact = text if text in source_paths else trimmed if trimmed in source_paths else text
                    candidates = [exact] if exact in source_paths else list(leaves.get(text, ())) if "/" not in text else []
                    profile = ext == "cfg" and "/" not in text and text[:-4] in profiles
                    targets = sorted({source_paths[key] for key in candidates if (native / source_paths[key]).is_file()})
                    item = {"script": path.relative_to(stage).as_posix(), "instruction_offset": at, "value": value.decode("ascii"), "profile_selector": profile, "published_targets": targets}
                    if profile or targets:
                        destination = "actionable_residuals"
                    elif candidates:
                        destination = "missing_native_targets"
                        item["raw_sources"] = sorted(candidates)
                    else:
                        destination = "unresolved_original_references"
                    report[destination].append(item)
            except ValueError as error:
                report["invalid_scripts"].append({"script": path.relative_to(stage).as_posix(), "error": str(error)})
    report["legacy_suffix_counts"] = dict(sorted(counts.items()))
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--raw", required=True, type=Path)
    parser.add_argument("--stage", required=True, type=Path)
    parser.add_argument("--report", required=True, type=Path)
    args = parser.parse_args()
    marker = args.stage / "data.json"
    if not marker.is_file() or json.loads(marker.read_text(encoding="utf-8")).get("data_version", 0) < 7:
        parser.error("audit requires a completed version 7 or newer publication (stage/data.json)")
    result = audit(args.raw, args.stage)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({key: len(value) if isinstance(value, list) else value for key, value in result.items()}))
    return int(any(result[key] for key in ("actionable_residuals", "missing_native_targets", "missing_direct_references", "invalid_scripts")))


if __name__ == "__main__":
    raise SystemExit(main())
