import contextlib
import io
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
import zipfile
from unittest.mock import patch

import pc_settings_replay


class PublishedDataTests(unittest.TestCase):
    def test_non_object_marker_skips_without_launching_the_game(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ("data", "port_data"):
                (root / name).mkdir()
                (root / name / "manifest.json").write_text("{}")
            for marker in ([], 3, None, "data", True):
                with self.subTest(marker=marker):
                    (root / "data.json").write_text(json.dumps(marker))
                    with patch.dict(os.environ, {"DC2_DATA": str(root / "data")}), \
                         patch.object(sys, "argv", ["pc_settings_replay.py", "--exe", "missing",
                                                   "--work", str(root / "work"), "--case", "pad"]), \
                         patch.object(pc_settings_replay.subprocess, "run") as run, \
                         contextlib.redirect_stdout(io.StringIO()):
                        self.assertEqual(pc_settings_replay.main(), 77)
                        run.assert_not_called()
                    self.assertFalse((root / "work").exists())

    def test_archive_publication_uses_marker_size_without_extracted_directories(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            archive = root / "data.zip"
            with zipfile.ZipFile(archive, "w") as output:
                output.writestr("menu/example.json", "{}")
            marker = {"schema_version": 1, "data_version": 20, "layout": "zip",
                      "archive_size": archive.stat().st_size}
            (root / "data.json").write_text(json.dumps(marker))
            self.assertTrue(pc_settings_replay.published_data_available(root / "data", {"data_version": 20}))
            self.assertFalse((root / "data").exists())
            for field, value in (("archive_size", archive.stat().st_size + 1),
                                 ("archive_size", True), ("schema_version", True),
                                 ("data_version", 19)):
                with self.subTest(field=field, value=value):
                    changed = {**marker, field: value}
                    (root / "data.json").write_text(json.dumps(changed))
                    self.assertFalse(pc_settings_replay.published_data_available(root / "data", {"data_version": 20}))
            (root / "data.json").write_text(json.dumps(marker))
            archive.unlink()
            self.assertFalse(pc_settings_replay.published_data_available(root / "data", {"data_version": 20}))

    def test_extracted_publication_remains_available(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ("data", "port_data"):
                (root / name).mkdir()
                (root / name / "manifest.json").write_text("{}")
            (root / "data.json").write_text(json.dumps({"schema_version": 1, "data_version": 20}))
            self.assertTrue(pc_settings_replay.published_data_available(root / "data", {"data_version": 20}))

    def test_launch_uses_an_isolated_run_root_and_reads_its_config(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)

            def finish_game(command, **kwargs):
                run = Path(command[command.index("--run-dir") + 1])
                self.assertEqual(Path(command[command.index("--save") + 1]), run / "save")
                self.assertEqual(Path(command[command.index("--data") + 1]), root / "data")
                self.assertEqual(command[command.index("--jump") + 1], "town:10")
                self.assertTrue(all(not name.startswith("DC2_") for name in kwargs["env"]))
                (run / "config.json").write_text(json.dumps({"input": {"mouse_zoom": True}}))
                (run / "screen-display-1.png").touch()
                return pc_settings_replay.subprocess.CompletedProcess(command, 0)

            steering = {"DC2_DATA": str(root / "data"), "DC2_JUMP": "dungeon:1",
                        "DC2_GIVE": "1", "DC2_FAST_LOAD": "0", "DC2_SEED": "999",
                        "DC2_SKIP_EVENTS": "1", "DC2_INVINCIBLE": "1"}
            with patch.dict(os.environ, steering), \
                 patch.object(sys, "argv", ["pc_settings_replay.py", "--exe", "unused",
                                           "--work", str(root / "work"), "--case", "zoom"]), \
                 patch.object(pc_settings_replay, "published_data_available", return_value=True), \
                 patch.object(pc_settings_replay.subprocess, "run", side_effect=finish_game) as launch, \
                 contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(pc_settings_replay.main(), 0)
                launch.assert_called_once()


if __name__ == "__main__":
    unittest.main()
