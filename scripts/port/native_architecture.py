"""Check that the native runtime is built entirely from port-owned code."""

import argparse
import json
import re
import shlex
from pathlib import Path


CODE_SUFFIXES = {".c", ".cc", ".cpp", ".cxx", ".h", ".hpp", ".hh", ".inc", ".inl", ".ipp", ".tpp"}
UNBOUNDED_TEXT_CALL = re.compile(r"\b(?:strcpy|strcat|strncpy|strncat|sprintf|vsprintf|gets)\s*\(")
PORT_MACROS = re.compile(r"\bPORT_(?:OVERRIDE|INIT|RETURN|FIX)\b")
PORT_CONDITIONAL = re.compile(
    r"^[ \t]*#[ \t]*(?:if(?:n?def)?|elif(?:n?def)?)\b(?:\\\r?\n|[^\r\n])*?\bPORT\b",
    re.MULTILINE,
)
RAW_MC_TRANSFER = re.compile(
    r"\b(?:int|auto)\s+sceMc(?:Read|Write)\s*\(\s*[^,{};]+,\s*[^,{};]*\*[^,{};]*,"
)
RAW_MC_DIRECTORY_OUTPUT = re.compile(
    r"\b(?:int|auto)\s+sceMcChdir\s*\(\s*[^,{};]+,\s*[^,{};]+,\s*[^,{};]+,\s*[^,{};)]*\*"
)
RAW_MC_DIRECTORY_TABLE = re.compile(
    r"\b(?:int|auto)\s+sceMcGetDir\s*\(\s*[^,{};]+,\s*[^,{};]+,\s*[^,{};]+,"
    r"\s*[^,{};]+,\s*[^,{};]+,\s*[^,{};)]*\*"
)
INCLUDE = re.compile(r'^\s*#\s*include\s*[<"]([^>"]+)[>"]', re.MULTILINE)
PS2_COMPONENTS = re.compile(r"(?:^|/)ps2/(?:src|include)(?![A-Za-z0-9_.-])", re.IGNORECASE)
SUFFIXED_NAME = re.compile(r".+[_-](?:port|ps2)$", re.IGNORECASE)
LEXEME = re.compile(
    r'//[^\n]*|/\*[\s\S]*?\*/|R"([^()]*)\([\s\S]*?\)\1"|"(?:\\.|[^"\\])*"|'
    r"'(?:\\.|[^'\\])*'"
)


def relative(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return str(path)


def mask_non_code(source: str, *, strings: bool = True) -> str:
    """Preserve line numbers while hiding comments and optionally literals."""

    def replace(match: re.Match[str]) -> str:
        value = match.group()
        if not strings and not value.startswith(("//", "/*")):
            return value
        return re.sub(r"[^\n]", " ", value)

    return LEXEME.sub(replace, source)


def is_ps2_runtime_path(value: str) -> bool:
    return bool(PS2_COMPONENTS.search(value.replace("\\", "/")))


def inspect_source(path: Path, root: Path) -> list[str]:
    source = path.read_text(encoding="utf-8", errors="replace")
    code = mask_non_code(source)
    name = relative(path, root)
    issues = []
    for match in UNBOUNDED_TEXT_CALL.finditer(code):
        line = source.count("\n", 0, match.start()) + 1
        issues.append(f"{name}:{line}: unsafe native text API {match.group().rstrip('(').strip()}")
    for pattern in (RAW_MC_TRANSFER, RAW_MC_DIRECTORY_OUTPUT, RAW_MC_DIRECTORY_TABLE):
        for match in pattern.finditer(code):
            line = source.count("\n", 0, match.start()) + 1
            issues.append(f"{name}:{line}: unbounded native memory-card prototype")
    for match in PORT_MACROS.finditer(code):
        line = source.count("\n", 0, match.start()) + 1
        issues.append(f"{name}:{line}: banned native macro {match.group()}")
    for match in PORT_CONDITIONAL.finditer(code):
        line = source.count("\n", 0, match.start()) + 1
        issues.append(f"{name}:{line}: redundant native PORT conditional")
    for match in INCLUDE.finditer(mask_non_code(source, strings=False)):
        target = match.group(1)
        line = source.count("\n", 0, match.start()) + 1
        if SUFFIXED_NAME.search(Path(target).stem):
            issues.append(f"{name}:{line}: platform-suffixed native include {target}")
        if is_ps2_runtime_path(target):
            issues.append(f"{name}:{line}: PS2 runtime include {target}")
        elif target.startswith(".") and is_ps2_runtime_path(str((path.parent / target).resolve())):
            issues.append(f"{name}:{line}: PS2 runtime include {target}")
    return issues


def inspect_cmake(root: Path) -> list[str]:
    issues = []
    for path in [root / "port/CMakeLists.txt", *(root / "port/cmake").glob("*.cmake")]:
        if not path.is_file():
            continue
        for number, line in enumerate(path.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            if is_ps2_runtime_path(line.split("#", 1)[0]):
                issues.append(f"{relative(path, root)}:{number}: PS2 runtime path in CMake")
    return issues


def compile_arguments(entry: dict) -> list[str]:
    if "arguments" in entry:
        return entry["arguments"]
    return shlex.split(entry.get("command", ""), posix=True)


def inspect_compile_commands(path: Path, root: Path) -> list[str]:
    if not path.is_file():
        return [f"{relative(path, root)}: compile database does not exist"]
    try:
        entries = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as error:
        return [f"{relative(path, root)}: invalid compile database: {error}"]
    if not isinstance(entries, list) or not entries:
        return [f"{relative(path, root)}: compile database must contain native translation units"]
    issues = []
    native_units = 0
    for entry in entries:
        if not isinstance(entry, dict) or not entry.get("file"):
            issues.append("compile database: entry has no source file")
            continue
        directory = Path(entry.get("directory", str(path.parent)))
        if not directory.is_absolute():
            directory = path.parent / directory
        directory = directory.resolve()
        source = Path(entry.get("file", ""))
        if not source.is_absolute():
            source = directory / source
        source = source.resolve()
        source_name = source.as_posix()
        if is_ps2_runtime_path(source_name):
            issues.append(f"compile database: PS2 source input {source_name}")
        # Only native game compilations are relevant; dependencies may have their own layout.
        if not source.is_relative_to((root / "port/src").resolve()):
            continue
        native_units += 1
        try:
            arguments = compile_arguments(entry)
        except ValueError as error:
            issues.append(f"compile database: invalid command for {source_name}: {error}")
            continue
        if "-w" in arguments:
            issues.append(f"compile database: native warnings are disabled for {source_name}")
        compiler = next((Path(argument).name for argument in arguments[:2] if "clang" in Path(argument).name), None)
        if compiler is not None and "-Weverything" not in arguments:
            issues.append(f"compile database: all Clang warnings must be enabled for {source_name}")
        compatibility_warning = re.compile(r"-Wno-(?:c\+\+98-compat|pre-c\+\+(?:14|17|20|23|26)-compat)(?:-pedantic)?$")
        for argument in arguments:
            if argument.startswith("-Wno-") and not compatibility_warning.fullmatch(argument):
                issues.append(f"compile database: native warning exclusion {argument} for {source_name}")
        for index, argument in enumerate(arguments):
            value = None
            for option in ("-I", "-isystem", "-iquote", "-include", "/I"):
                if argument == option and index + 1 < len(arguments):
                    value = arguments[index + 1]
                    break
                if argument.startswith(option) and len(argument) > len(option):
                    value = argument[len(option) :]
                    break
            if value is None:
                continue
            candidate = Path(value)
            if not candidate.is_absolute():
                candidate = directory / candidate
            if is_ps2_runtime_path(str(candidate.resolve())):
                issues.append(f"compile database: PS2 include input for {source_name}: {value}")
    if not native_units:
        issues.append("compile database: no native translation units were checked")
    return issues


def audit(root: Path, compile_commands: Path | None = None) -> list[str]:
    root = root.resolve()
    issues = inspect_cmake(root)
    for code_root in (root / "port/src", root / "port/include"):
        if not code_root.is_dir():
            issues.append(f"missing native code directory: {relative(code_root, root)}")
            continue
        for path in sorted(code_root.rglob("*")):
            if not path.is_file() or path.suffix.lower() not in CODE_SUFFIXES:
                continue
            if "tests" in path.relative_to(code_root).parts:
                continue
            if is_ps2_runtime_path(str(path.resolve())):
                issues.append(f"{relative(path, root)}: file resolves to PS2 runtime code")
            if SUFFIXED_NAME.search(path.stem):
                issues.append(f"{relative(path, root)}: platform-suffixed native filename")
            issues.extend(inspect_source(path, root))
    if compile_commands is not None:
        issues.extend(inspect_compile_commands(compile_commands, root))
    return issues


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2])
    database = parser.add_mutually_exclusive_group()
    database.add_argument("--compile-commands", type=Path, help="Optional compile_commands.json to verify")
    database.add_argument("--build", type=Path, help="Optional build directory containing compile_commands.json")
    args = parser.parse_args()
    compile_commands = args.compile_commands
    if args.build is not None:
        compile_commands = args.build / "compile_commands.json"
    issues = audit(args.root, compile_commands)
    for issue in issues:
        print(issue)
    if not issues:
        print("Native architecture check passed")
    return bool(issues)


if __name__ == "__main__":
    raise SystemExit(main())
