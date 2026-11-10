#!/usr/bin/env python3
"""Verify the native sanitizer configuration diagnoses real memory errors."""

import argparse
import os
from pathlib import Path
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", required=True)
    parser.add_argument("--sanitizers", default="address")
    args = parser.parse_args()
    cases = {
        "heap-buffer-overflow": "auto p = new int[2]; p[index] = 1; delete[] p;",
        "heap-use-after-free": "auto p = new int[8]; delete[] p; p[index] = 1;",
        "stack-buffer-overflow": "int p[2]{}; p[index] = 1; return p[0];",
    }
    environment = dict(os.environ, ASAN_OPTIONS="halt_on_error=1:detect_leaks=0")
    with tempfile.TemporaryDirectory(prefix="ct-sanitizer-") as directory:
        root = Path(directory)
        module = Path(__file__).resolve().with_name("sanitizers.cmake").as_posix()
        targets = []
        for diagnostic, body in cases.items():
            name = diagnostic.replace("-", "_")
            source = root / (name + ".cpp")
            source.write_text("int main(int argc, char **) { volatile int index = argc + 2; " + body + " }\n")
            targets.append(f"add_executable({name} {source.name})")
        (root / "CMakeLists.txt").write_text(
            "cmake_minimum_required(VERSION 3.25)\nproject(sanitizer_probe CXX)\n"
            f'include("{module}")\n' + "\n".join(targets) + "\n")
        build = root / "build"
        subprocess.run(["cmake", "-S", str(root), "-B", str(build),
                        "-DCMAKE_CXX_COMPILER=" + args.compiler, "-DCMAKE_BUILD_TYPE=Debug",
                        "-DCT_SANITIZERS=" + args.sanitizers], check=True, timeout=60)
        subprocess.run(["cmake", "--build", str(build), "--parallel", "2"], check=True, timeout=60)
        for diagnostic in cases:
            binary = build / diagnostic.replace("-", "_")
            result = subprocess.run([str(binary)], capture_output=True, text=True,
                                    env=environment, timeout=20)
            diagnosed = "AddressSanitizer: " + diagnostic in result.stderr
            if "undefined" in args.sanitizers and diagnostic == "stack-buffer-overflow":
                diagnosed |= "runtime error: index" in result.stderr
            if result.returncode == 0 or not diagnosed:
                raise RuntimeError(f"Missing {diagnostic} diagnostic (exit {result.returncode}):\n{result.stderr}")
            print(f"PASS: {diagnostic}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
