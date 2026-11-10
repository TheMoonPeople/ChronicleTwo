r"""Re-symbolise the raw frames of a Dark Chronicle PC port crash report.

The PC port writes report.txt to <save root>/crashes/<session>/. This tool resolves the raw
frames in such a report with llvm-symbolizer and writes the report back out with the resolved
inlined frames inserted beneath each raw frame.

Input format:
- A raw frame is any line containing ``<module>+0x<hex offset>``, optionally preceded by a frame
  index such as ``#12``. Both of these are raw frames::

      #03 darkchronicle.exe+0x1a2b3c
        3  darkchronicle+0x1a2b3c

  ``<module>`` is the module's file name. A path is allowed; only its basename is used for lookup.
  The offset is relative to the module's load base, the address its headers are mapped at: a PE
  RVA on Windows, the ELF virtual address of a PIE on Linux, and the distance from the Mach-O
  header on macOS.
- An optional build id line, matched case-insensitively by ``build[ _-]?id\s*[:=]\s*(\S+)``.
  With --symbols, the build id selects ``<DIR>/<build id>/`` as the first directory searched.
- Every other line is passed through unchanged.

Symbol sources:
- ``--binary`` names an object for the frames whose module has the same name or stem: an ELF binary or
  its ``.debug`` file, a Mach-O binary or its ``.dSYM`` bundle, or a PE executable (its embedded DWARF)
  or its ``.pdb``. llvm-symbolizer reads a PDB through its executable, so a ``.pdb`` is used through
  the ``.exe`` beside it (stripped of DWARF or not). ``--symbols DIR`` looks these files up by module
  name.
- llvm-symbolizer resolves all three formats. On macOS without it, Xcode's ``atos`` is used against the
  dSYM or binary. Without llvm-readobj, each format's usual image base is assumed (0x140000000 for a PE
  executable, 0x100000000 for a Mach-O executable, 0 for a PIE).

Output:
- Each raw frame line is followed by one ``    -> <function> at <file>:<line>[:<column>]`` line
  per inlined frame, innermost first. Unresolved frames are reported as ``    -> ??``.
- Exit status is 0 on success, 2 for usage or missing tool errors, and 1 when no frame resolved.
"""

import argparse
import glob
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import NamedTuple

REPO_ROOT = Path(__file__).resolve().parents[2]
MINGW_LLVM_PATTERN = os.path.join(
    str(REPO_ROOT), ".kazarov", "windows", "deps", "llvm", "llvm-mingw-*", "bin"
)

FRAME_RE = re.compile(r"(?:#\s*\d+\s+)?(?P<module>[^\s()\[\]]+?)\+0x(?P<offset>[0-9A-Fa-f]+)\b")
BUILD_ID_RE = re.compile(r"build[ _-]?id\s*[:=]\s*(\S+)", re.IGNORECASE)
COFF_IMAGE_BASE_RE = re.compile(r"ImageBase:\s*(0x[0-9A-Fa-f]+)")
ELF_FORMAT_RE = re.compile(r"Format:\s*elf", re.IGNORECASE)
ELF_SHARED_RE = re.compile(r"Type:\s*(?:SharedObject|ET_DYN)", re.IGNORECASE)
ELF_EXEC_RE = re.compile(r"Type:\s*(?:Executable|ET_EXEC)", re.IGNORECASE)
ELF_LOAD_RE = re.compile(r"Type:\s*PT_LOAD\b.*?VirtualAddress:\s*(0x[0-9A-Fa-f]+)", re.IGNORECASE | re.DOTALL)
MACHO_FORMAT_RE = re.compile(r"Format:\s*Mach-O", re.IGNORECASE)
MACHO_TOKEN_RE = re.compile(r"\bName:\s*(\S+)|\bvm\s*addr(?:ess)?\s*:\s*(0x[0-9A-Fa-f]+)", re.IGNORECASE)


class Frame(NamedTuple):
    """A raw frame found in a report."""

    line: int  #: Zero-based index of the report line holding the frame.
    module: str  #: Module file name or path as written in the report.
    offset: int  #: Offset relative to the module's load base.


def parse_report(text: str) -> tuple[str | None, list[Frame]]:
    """Return the first build id and every raw frame in a crash report."""
    build_id: str | None = None
    frames: list[Frame] = []
    for index, line in enumerate(text.splitlines()):
        if build_id is None and (build_match := BUILD_ID_RE.search(line)):
            build_id = build_match.group(1)
        if match := FRAME_RE.search(line):
            module = match.group("module").strip("\"'")
            frames.append(Frame(index, module, int(match.group("offset"), 16)))
    return build_id, frames


def parse_symbolizer_output(text: str) -> list[list[tuple[str, str]]]:
    """Group llvm-symbolizer output into one list of (function, location) pairs per address."""
    results: list[list[tuple[str, str]]] = []
    current: list[tuple[str, str]] = []
    pending_function: str | None = None
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line:
            results.append(current)
            current, pending_function = [], None
        elif pending_function is None:
            pending_function = line
        else:
            current.append((pending_function, line))
            pending_function = None
    if current:
        results.append(current)
    return results


def parse_coff_image_base(text: str) -> int | None:
    """Return the ImageBase of a COFF/PE image from llvm-readobj file headers, if present."""
    match = COFF_IMAGE_BASE_RE.search(text)
    return int(match.group(1), 16) if match else None


def parse_macho_text_vmaddr(text: str) -> int | None:
    """Return the vmaddr of the __TEXT segment from llvm-readobj --macho-segment output."""
    segment_name: str | None = None
    for match in MACHO_TOKEN_RE.finditer(text):
        if match.group(1) is not None:
            segment_name = match.group(1)
        elif segment_name == "__TEXT":
            return int(match.group(2), 16)
    return None


def parse_elf_load_base(file_headers: str, program_headers: str) -> int:
    """Return the load base of an ELF image: 0 for a PIE, the lowest PT_LOAD address for ET_EXEC."""
    if ELF_SHARED_RE.search(file_headers) or not ELF_EXEC_RE.search(file_headers):
        return 0
    addresses = [int(match.group(1), 16) for match in ELF_LOAD_RE.finditer(program_headers)]
    return min(addresses, default=0)


def executable_for(path: Path) -> Path:
    """Return the .exe beside a .pdb, through which llvm-symbolizer reads it, or the path itself."""
    if path.suffix.lower() == ".pdb" and path.with_suffix(".exe").is_file():
        return path.with_suffix(".exe")
    return path


def dsym_dwarf_file(path: Path) -> Path:
    """Return the DWARF file inside a .dSYM bundle, or the path itself when it is not a bundle."""
    if path.is_dir() and path.suffix.lower() == ".dsym":
        dwarf = sorted((path / "Contents" / "Resources" / "DWARF").glob("*"))
        if dwarf:
            return dwarf[0]
    return path


ATOS_RE = re.compile(r"^(?P<function>.+?) \(in [^)]*\)(?: \((?P<location>[^()]+:\d+)\))?$")


def parse_atos_output(text: str) -> list[list[tuple[str, str]]]:
    """Turn atos output, one line per address, into (function, location) pairs per address."""
    results: list[list[tuple[str, str]]] = []
    for line in text.splitlines():
        match = ATOS_RE.match(line.strip())
        if match is None or match.group("function").startswith("0x"):
            results.append([("??", "??:0:0")])
        else:
            results.append([(match.group("function"), match.group("location") or "??:0:0")])
    return results


def atos_addresses(atos: str, obj: Path, base: int, addresses: list[int]) -> list[list[tuple[str, str]]]:
    """Resolve addresses with Xcode's atos, which reports only the outermost frame."""
    command = [atos, "-o", str(obj), "-l", f"0x{base:x}"] + [f"0x{address:x}" for address in addresses]
    return parse_atos_output(_capture(command))


def _capture(command: list[str]) -> str:
    """Run a command and return its stdout, or an empty string if it cannot be started."""
    try:
        return subprocess.run(command, capture_output=True, text=True, check=False).stdout
    except OSError:
        return ""


def image_base(path: str, readobj: str) -> int:
    """Return the address an object's headers are mapped at, or 0 when it cannot be determined."""
    file_headers = _capture([readobj, "--file-headers", path])
    if (coff_base := parse_coff_image_base(file_headers)) is not None:
        return coff_base
    if ELF_FORMAT_RE.search(file_headers):
        program_headers = _capture([readobj, "--program-headers", path])
        return parse_elf_load_base(file_headers, program_headers)
    if MACHO_FORMAT_RE.search(file_headers):
        vmaddr = parse_macho_text_vmaddr(_capture([readobj, "--macho-segment", path]))
        return vmaddr if vmaddr is not None else 0
    return 0


def default_image_base(path: Path) -> int:
    """Return the usual image base of an executable's format: PE x64, a Mach-O executable, or a PIE."""
    try:
        with path.open("rb") as file:
            magic = file.read(4)
    except OSError:
        return 0
    if magic[:2] == b"MZ":
        return 0x140000000
    if magic in (b"\xcf\xfa\xed\xfe", b"\xfe\xed\xfa\xcf"):
        return 0x100000000
    return 0


def _basename(path: str) -> str:
    """Return the final component of a path that may use either separator."""
    return re.split(r"[\\/]", path)[-1]


def _stem(name: str) -> str:
    """Return a file name without its last extension."""
    stem, dot, _ = name.rpartition(".")
    return stem if dot else name


def find_symbol_file(module: str, symbols: Path, build_id: str | None) -> Path | None:
    """Return the first symbol file for a module under the symbols directory, if one exists."""
    name = _basename(module)
    stem = _stem(name)
    candidates = [
        f"{name}.debug",
        f"{stem}.debug",
        f"{name}.dSYM/Contents/Resources/DWARF/{name}",
        f"{stem}.dSYM/Contents/Resources/DWARF/{stem}",
        name,
        f"{stem}.exe",
    ]
    directories = ([symbols / build_id] if build_id else []) + [symbols]
    for directory in directories:
        for candidate in candidates:
            if (directory / candidate).is_file():
                return directory / candidate
    return None


def resolve_object(
    module: str, binaries: list[Path], symbols: Path | None, build_id: str | None
) -> Path | None:
    """Return the object file for a module, preferring --binary matches over --symbols."""
    name = _basename(module)
    for binary in binaries:
        binary_name = binary.name
        if binary_name.lower() == name.lower() or _stem(binary_name).lower() == _stem(name).lower():
            return binary
    if symbols is None:
        return None
    return find_symbol_file(module, symbols, build_id)


def symbolize_addresses(
    symbolizer: str, obj: Path, addresses: list[int]
) -> list[list[tuple[str, str]]]:
    """Run llvm-symbolizer over one object and return the inlined frames for each address."""
    command = [
        symbolizer,
        f"--obj={obj}",
        "--functions=linkage",
        "--demangle",
        "--inlining",
        "--output-style=LLVM",
    ]
    stdin = "".join(f"0x{address:x}\n" for address in addresses)
    try:
        result = subprocess.run(command, input=stdin, capture_output=True, text=True, check=False)
    except OSError as exc:
        print(f"symbolize: cannot run {symbolizer}: {exc}", file=sys.stderr)
        return []
    return parse_symbolizer_output(result.stdout)


def render_report(
    text: str, frames: list[Frame], results: dict[int, list[tuple[str, str]]]
) -> tuple[str, bool]:
    """Insert resolved frame lines beneath each raw frame and report whether any frame resolved."""
    frame_index_at_line = {frame.line: index for index, frame in enumerate(frames)}
    out: list[str] = []
    resolved = False
    for number, line in enumerate(text.splitlines()):
        out.append(line)
        if number not in frame_index_at_line:
            continue
        inlined = results.get(frame_index_at_line[number], [])
        if not inlined:
            out.append("    -> ??")
        for function, location in inlined:
            if function == "??":
                out.append("    -> ??")
            else:
                out.append(f"    -> {function} at {location}")
                resolved = True
    return "\n".join(out) + "\n", resolved


def mingw_llvm_bin_dirs() -> list[Path]:
    """Return the bundled llvm-mingw bin directories, newest first."""
    return [Path(path) for path in sorted(glob.glob(MINGW_LLVM_PATTERN), reverse=True)]


def locate_tool(
    name: str, explicit: str | None, env_var: str | None = None, sibling: Path | None = None
) -> str | None:
    """Find an LLVM tool from an explicit path, an environment variable, a sibling, or PATH."""
    requested = explicit or (os.environ.get(env_var) if env_var else None)
    if requested:
        return shutil.which(requested)
    if sibling is not None and sibling.is_file():
        return str(sibling)
    if found := shutil.which(name):
        return found
    if os.name == "nt":
        for directory in mingw_llvm_bin_dirs():
            if (directory / f"{name}.exe").is_file():
                return str(directory / f"{name}.exe")
    return None


def build_parser() -> argparse.ArgumentParser:
    """Build the command line parser."""
    parser = argparse.ArgumentParser(description="Re-symbolise a Dark Chronicle PC port crash report.")
    parser.add_argument("report", help="report.txt path, or '-' for stdin")
    parser.add_argument(
        "--binary", action="append", default=[], help="object file for modules with its basename"
    )
    parser.add_argument("--symbols", type=Path, help="directory of per-module symbol files")
    parser.add_argument("--llvm-symbolizer", help="path to llvm-symbolizer")
    parser.add_argument("--llvm-readobj", help="path to llvm-readobj")
    parser.add_argument("-o", "--output", help="write the report here instead of stdout")
    return parser


def _usage_error(message: str) -> int:
    """Report a usage or missing-tool error and return the usage exit status."""
    print(f"symbolize: error: {message}", file=sys.stderr)
    return 2


def main(argv: list[str] | None = None) -> int:
    """Symbolise a crash report and write the result."""
    args = build_parser().parse_args(argv)
    symbolizer = locate_tool("llvm-symbolizer", args.llvm_symbolizer, "LLVM_SYMBOLIZER")
    atos = shutil.which("atos") if symbolizer is None and sys.platform == "darwin" else None
    if symbolizer is None and atos is None:
        return _usage_error("llvm-symbolizer not found; pass --llvm-symbolizer or set LLVM_SYMBOLIZER")
    sibling = Path(symbolizer).with_name("llvm-readobj" + Path(symbolizer).suffix) if symbolizer else None
    readobj = locate_tool("llvm-readobj", args.llvm_readobj, None, sibling)
    if readobj is None:
        print("symbolize: llvm-readobj not found; assuming each format's default image base", file=sys.stderr)
    binaries = [Path(path) for path in args.binary]
    if missing := [str(path) for path in binaries if not path.exists()]:
        return _usage_error(f"--binary not found: {', '.join(missing)}")
    try:
        if args.report == "-":
            text = sys.stdin.read()
        else:
            text = Path(args.report).read_text(encoding="utf-8", errors="replace")
    except OSError as exc:
        return _usage_error(f"cannot read report: {exc}")

    build_id, frames = parse_report(text)
    objects: dict[Path, list[int]] = {}
    for index, frame in enumerate(frames):
        if (obj := resolve_object(frame.module, binaries, args.symbols, build_id)) is not None:
            objects.setdefault(executable_for(dsym_dwarf_file(obj)), []).append(index)

    results: dict[int, list[tuple[str, str]]] = {}
    for obj, members in objects.items():
        base = image_base(str(obj), readobj) if readobj else default_image_base(obj)
        addresses = [base + frames[index].offset for index in members]
        if symbolizer is not None:
            results.update(zip(members, symbolize_addresses(symbolizer, obj, addresses)))
        else:
            results.update(zip(members, atos_addresses(atos, obj, base, addresses)))

    rendered, resolved = render_report(text, frames, results)
    if args.output:
        Path(args.output).write_text(rendered, encoding="utf-8")
    else:
        sys.stdout.write(rendered)
    return 0 if resolved else 1


if __name__ == "__main__":
    sys.exit(main())
