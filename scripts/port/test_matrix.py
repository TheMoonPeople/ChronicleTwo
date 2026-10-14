import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import matrix


class MatrixRunner(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.exe = self.root / "game.exe"
        self.script = self.root / "script.input"
        self.data = self.root / "data"
        self.data.mkdir()
        self.exe.write_bytes(b"binary")
        self.script.write_text("10 cross\n")
        self.run = matrix.Run(640, 480, "auto", False,
                              self.root / "runs" / "640x480-fill-12345678")

    def execute(self, rc=0, timeout=False):
        def fake(cmd, **kwargs):
            env = kwargs.get("env", os.environ)
            for key in ("DC2_JUMP", "DC2_GIVE", "DC2_FAST_LOAD"):
                self.assertFalse(key in env, f"launch environment retains {key}")
            self.run.png.write_bytes(b"synthetic screenshot")
            if timeout:
                raise subprocess.TimeoutExpired(cmd, 1, output=b"partial")
            return subprocess.CompletedProcess(cmd, rc, b"output", b"error")
        with patch.dict(os.environ, {"DC2_JUMP": "town:10", "DC2_GIVE": "2", "DC2_FAST_LOAD": "1"}), \
             patch.object(matrix.subprocess, "run", side_effect=fake):
            matrix.run_game(self.exe, self.data, self.script, 100, self.run)

    def reload(self):
        other = matrix.Run(640, 480, "auto", False, self.root / "unused")
        matrix.locate_run(other, self.root, self.exe, self.data, self.script, 100)
        return other

    def test_launch_uses_fixed_ntsc_runtime_without_selector_config(self):
        self.execute()
        config = json.loads((self.run.dir / "save" / "config.json").read_bytes())
        self.assertEqual(config["game"], {"debug_mode": False})
        receipt = json.loads((self.run.dir / "result.json").read_text())
        self.assertEqual(receipt["provenance"]["runtime_timing"], {"region": "ntsc", "tick_hz": 60})
        self.assertEqual(self.reload().rc, 0)

    def test_obsolete_runtime_policy_rejects_cached_run(self):
        self.execute()
        path = self.run.dir / "result.json"
        receipt = json.loads(path.read_text())
        for policy in (None, {"region": "pal", "tick_hz": 50}, {"region": "ntsc", "tick_hz": 50}):
            changed = json.loads(json.dumps(receipt))
            if policy is None:
                del changed["provenance"]["runtime_timing"]
            else:
                changed["provenance"]["runtime_timing"] = policy
            path.write_text(json.dumps(changed))
            with self.assertRaises(matrix.RunFailed):
                self.reload()

    def test_sanitises_launch_changing_environment(self):
        self.execute()
        self.assertEqual(self.reload().rc, 0)

    def test_failed_run_with_screenshot_keeps_exit_status(self):
        self.execute(rc=7)
        self.assertEqual(self.reload().rc, 7)
        with self.assertRaises(matrix.RunFailed):
            matrix.load(self.reload())

    def test_timeout_status_survives_reload(self):
        self.execute(timeout=True)
        self.assertEqual(self.reload().rc, -1)

    def test_changed_binary_and_input_reject_cached_run(self):
        self.execute()
        for path in (self.exe, self.script):
            original = path.read_bytes()
            path.write_bytes(b"changed")
            with self.assertRaises(matrix.RunFailed):
                self.reload()
            path.write_bytes(original)

    def test_changed_config_rejects_cached_run(self):
        self.execute()
        (self.run.dir / "save" / "config.json").write_text("{}")
        with self.assertRaises(matrix.RunFailed):
            self.reload()

    def test_screenshot_without_receipt_is_not_success(self):
        self.run.dir.mkdir(parents=True)
        self.run.png.write_bytes(b"synthetic screenshot")
        with self.assertRaises(matrix.RunFailed):
            self.reload()

    def test_malformed_status_is_rejected(self):
        self.execute()
        path = self.run.dir / "result.json"
        status = json.loads(path.read_text())
        status["rc"] = "0"
        path.write_text(json.dumps(status))
        with self.assertRaises(matrix.RunFailed):
            self.reload()


if __name__ == "__main__":
    unittest.main()
