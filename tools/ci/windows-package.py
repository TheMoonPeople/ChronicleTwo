"""Package cross-built Windows programs and relocate CTest's native test scripts."""

import pathlib
import re
import shutil
import subprocess
import sys
import zipfile


ROOT = pathlib.Path(__file__).resolve().parents[2]
BUILD = ROOT / "port/build/windows-cross-x64-release"


def relocate():
    """Resolve host tool and checkout paths before CTest discovers native tests."""
    cmake = pathlib.Path(shutil.which("cmake")).as_posix()
    discovery = BUILD / "cmake/GoogleTestAddTests.cmake"
    if not discovery.is_file():
        raise RuntimeError("The test bundle lacks its matching GoogleTest discovery module")
    for path in BUILD.rglob("*.cmake"):
        text = path.read_text()
        text = text.replace("/work/", ROOT.as_posix() + "/")
        text = re.sub(r"/usr/share/cmake-[\d.]+/Modules/GoogleTestAddTests\.cmake", lambda _: discovery.as_posix(), text)
        text = text.replace("/usr/bin/cmake", cmake)
        text = text.replace("/usr/bin/python3", pathlib.Path(sys.executable).as_posix())
        path.write_text(text)


def package(mode):
    """Keep runtime files, assets and test metadata while omitting compiler outputs."""
    names = set(BUILD.joinpath("windows-runtime-files.txt").read_text().splitlines())
    if not {"darkchronicle.exe", "dc2data.exe", "vulkan-1.dll"} <= names:
        raise RuntimeError("Incomplete Windows runtime manifest")
    files = set()
    for name in names:
        if pathlib.PurePosixPath(name).name != name or "\\" in name:
            raise ValueError(f"Invalid runtime entry: {name}")
        files.add(BUILD / name)
    # Share the native package audit's OS allowlist so both paths reject missing DLLs.
    audit = ROOT.joinpath("tools/windows/check-runtime.ps1").read_text()
    system_block = audit.split("$system = @(", 1)[1].split(")", 1)[0]
    system = set(re.findall(r"'([^']+)'", system_block))
    bundled = {name.lower() for name in names}
    for name in names:
        imports = subprocess.check_output(["llvm-readobj", "--coff-imports", str(BUILD / name)], text=True)
        for dependency in re.findall(r"^\s*Name: (.+\.(?:dll|drv))$", imports, re.MULTILINE | re.IGNORECASE):
            dependency = dependency.lower()
            if dependency.startswith(("api-ms-", "ext-ms-")) or dependency in system or dependency in bundled:
                continue
            raise RuntimeError(f"{name} imports unbundled dependency {dependency}")
    for name in ("assets/data.zip", "Luau-LICENSE.txt", "fonts/ChronicleTwoMessage-Regular.ttf"):
        files.add(BUILD / name)
    for directory in ("scripts", "fonts", "glyphs"):
        files.update(path for path in (BUILD / directory).rglob("*") if path.is_file())
    files.update(BUILD.glob("*-LICENSE.txt"))
    runtime_files = set(files)
    if mode == "tests":
        # Discovery scripts and their private CMake module must use the same argument format.
        info = subprocess.check_output(["cmake", "--system-information"], text=True)
        modules = pathlib.Path(re.search(r'^CMAKE_ROOT "(.+)"$', info, re.MULTILINE)[1]) / "Modules"
        discovery = BUILD / "cmake/GoogleTestAddTests.cmake"
        discovery.parent.mkdir(exist_ok=True)
        shutil.copyfile(modules / discovery.name, discovery)
        if (modules / "GoogleTest").is_dir():
            shutil.copytree(modules / "GoogleTest", discovery.parent / "GoogleTest", dirs_exist_ok=True)
        files.add(discovery)
        license_file = discovery.parent / "CMake-LICENSE.txt"
        shutil.copyfile("/usr/share/doc/cmake/copyright", license_file)
        files.add(license_file)
        files.add(BUILD / "compile_commands.json")
        files.add(BUILD / "rust-tests/data.zip")
        files.update(BUILD.rglob("*.exe"))
        files.update(BUILD.rglob("*.dll"))
        files.update(BUILD.rglob("*.pdb"))
        files.update(path for path in BUILD.rglob("*.cmake") if "_deps" not in path.parts)
    output = ROOT / "artifacts"
    output.mkdir(exist_ok=True)
    executable = BUILD / "darkchronicle.exe"
    # PE links with PDB output can omit COFF symbols while retaining the crash handler's DWARF.
    debug_info = subprocess.check_output(["llvm-dwarfdump", "--name=wmain", str(executable)], text=True)
    address = None
    for entry in re.split(r"\n\s*\n", debug_info):
        if "DW_TAG_subprogram" in entry and re.search(r'DW_AT_name\s+\("wmain"\)', entry):
            address = re.search(r"DW_AT_low_pc\s+\((0x[0-9a-fA-F]+)\)", entry)
            if address is not None:
                break
    if address is None:
        raise RuntimeError("Windows executable has no defined wmain in its retained DWARF")
    headers = subprocess.check_output(["llvm-readobj", "--file-headers", str(executable)], text=True)
    image_base = re.search(r"ImageBase:\s*(0x[0-9a-fA-F]+)", headers)
    if image_base is None:
        raise RuntimeError("Windows executable has no PE image base")
    report = output / "windows-symbol-check.txt"
    report.write_text(f"#0  darkchronicle.exe+0x{int(address[1], 16) - int(image_base[1], 16):x}\n")
    symbolized = subprocess.check_output([
        sys.executable, str(ROOT / "tools/crash/symbolize.py"), str(report),
        "--binary", str(executable), "--llvm-symbolizer", shutil.which("llvm-symbolizer"),
    ], text=True)
    if "main.cpp:" not in symbolized:
        raise RuntimeError(f"Windows symbolization did not resolve main.cpp: {symbolized}")
    archives = {"chronicletwo-windows-x64.zip": runtime_files}
    if mode == "tests":
        archives["windows-test-binaries.zip"] = files
    for name, contents in archives.items():
        with zipfile.ZipFile(output / name, "w", zipfile.ZIP_DEFLATED, compresslevel=1) as archive:
            for path in sorted(contents):
                archive.write(path, path.relative_to(BUILD))
    ids = []
    with zipfile.ZipFile(output / "chronicletwo-windows-x64-symbols.zip", "w", zipfile.ZIP_DEFLATED, compresslevel=1) as archive:
        for name in ("darkchronicle", "dc2data"):
            archive.write(BUILD / (name + ".exe"), name + ".exe")
            debug = subprocess.check_output(["llvm-readobj", "--coff-debug-directory", str(BUILD / (name + ".exe"))], text=True)
            match = re.search(r"PDBGUID: \{([0-9A-Fa-f-]+)\}\s+PDBAge: (\d+)", debug)
            build_id = match[1].replace("-", "") + format(int(match[2]), "X") if match else "-"
            ids.append(f"{name}.exe {build_id}\n")
            pdb = BUILD / (name + ".pdb")
            if pdb.exists():
                archive.write(pdb, pdb.name)
        archive.writestr("build-ids.txt", "".join(ids))


if __name__ == "__main__":
    mode = sys.argv[1]
    if mode == "relocate":
        relocate()
    elif mode in ("build", "tests"):
        package(mode)
    else:
        raise SystemExit("Expected build, tests, or relocate")
