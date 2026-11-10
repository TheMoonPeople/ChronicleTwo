#!/usr/bin/env python3
"""Check dependency-stage ordering before starting a Docker build."""

from pathlib import Path
import re
import shlex
import tomllib
import unittest


def instructions(recipe: str):
    pending = ""
    start = 0
    heredocs = []
    for number, line in enumerate(recipe.splitlines(), 1):
        if heredocs:
            if line.strip() == heredocs[0]:
                heredocs.pop(0)
            continue
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if not pending:
            start = number
        pending += line.strip()
        if pending.endswith("\\"):
            pending = pending[:-1] + " "
            continue
        words = shlex.split(pending)
        if words and words[0].upper() in ("FROM", "COPY", "RUN"):
            yield start, words
        heredocs = re.findall(r"<<-?['\"]?([A-Za-z_][A-Za-z_0-9]*)", pending)
        pending = ""


def stage_errors(recipe: str) -> list[str]:
    commands = list(instructions(recipe))
    stages = {}
    current = -1
    for _, words in commands:
        if words[0].upper() == "FROM":
            current += 1
            if len(words) >= 4 and words[-2].upper() == "AS":
                stages[words[-1].casefold()] = current
    errors = []
    current = -1
    for line, words in commands:
        kind = words[0].upper()
        references = []
        if kind == "FROM":
            current += 1
            references = [next(word for word in words[1:] if not word.startswith("--"))]
        else:
            for index, word in enumerate(words[1:], 1):
                if word.startswith("--from="):
                    references.append(word.split("=", 1)[1])
                elif word == "--from" and index + 1 < len(words):
                    references.append(words[index + 1])
                elif word.startswith("--mount="):
                    references.extend(field.split("=", 1)[1] for field in word.split("=", 1)[1].split(",")
                                      if field.startswith("from="))
        for reference in references:
            target = stages.get(reference.casefold())
            if kind != "FROM" and reference.isdigit():
                target = int(reference)
            if target is not None and (target > current or (target == current and kind != "FROM")):
                errors.append(f"line {line}: stage {current} references {reference!r} before its definition")
    return errors


class DockerfileStages(unittest.TestCase):
    def test_prior_stages_and_external_images(self):
        recipe = """FROM ubuntu:26.04 AS compiler
FROM compiler AS bridge
COPY --from=compiler /compiler /compiler
FROM scratch AS bundle
COPY --from=bridge /bridge /bridge
COPY --from=ghcr.io/example/assets:latest /assets /assets
RUN --mount=type=bind,from=compiler,target=/compiler true
"""
        self.assertEqual(stage_errors(recipe), [])

    def test_numeric_stage_references(self):
        self.assertEqual(stage_errors("FROM ubuntu\nFROM scratch\nCOPY --from=0 /a /a\n"), [])
        self.assertTrue(stage_errors("FROM scratch\nCOPY --from=1 /a /a\nFROM ubuntu\n"))

    def test_windows_bridge_forward_reference_from_issue_173(self):
        recipe = """FROM ubuntu AS windows-sdk
COPY --from=windows-cxxbridge /opt/bridge/bin/cxxbridge.exe /opt/deps/rust/bin/cxxbridge.exe
FROM ubuntu AS windows-compiler
FROM windows-compiler AS windows-cxxbridge
"""
        errors = stage_errors(recipe)
        self.assertEqual(len(errors), 1)
        self.assertIn("windows-cxxbridge", errors[0])

    def test_forward_base_mount_and_self_copy_are_rejected(self):
        self.assertTrue(stage_errors("FROM later AS first\nFROM ubuntu AS later\n"))
        self.assertTrue(stage_errors("FROM ubuntu AS first\nRUN --mount=from=later true\nFROM first AS later\n"))
        self.assertTrue(stage_errors("FROM ubuntu AS first\nCOPY --from=first /a /a\n"))

    def test_heredoc_contents_are_not_stage_declarations(self):
        recipe = """FROM ubuntu AS first
RUN <<'SCRIPT'
COPY --from=later /a /a
FROM imaginary AS later
SCRIPT
FROM first AS last
COPY --from=first /a /a
"""
        self.assertEqual(stage_errors(recipe), [])

    def test_repository_recipe_and_bridge_pins(self):
        root = Path(__file__).resolve().parents[2]
        recipe = (root / "tools/ci/Dockerfile").read_text(encoding="utf-8")
        self.assertEqual(stage_errors(recipe), [])
        packages = tomllib.loads((root / "tools/kazarov/Cargo.lock").read_text(encoding="utf-8"))["package"]
        cxx = next(package["version"] for package in packages if package["name"] == "cxx")
        bridges = re.findall(r"cargo install --locked cxxbridge-cmd --version ([0-9.]+)", recipe)
        self.assertTrue(bridges)
        self.assertTrue(all(bridge == cxx for bridge in bridges))
        rust = re.search(r"FROM rust:([0-9.]+)-slim-bookworm@sha256:[0-9a-f]{64} AS rust-base", recipe)
        self.assertIsNotNone(rust)
        self.assertIn(f"rust-{rust.group(1)}-x86_64-pc-windows-gnullvm.tar.xz", recipe)


if __name__ == "__main__":
    unittest.main()
