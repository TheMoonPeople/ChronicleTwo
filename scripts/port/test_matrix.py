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

    def test_data_root_accepts_published_archive(self):
        self.assertFalse(matrix.has_data(self.data))
        (self.root / "data.zip").write_bytes(b"published archive")
        self.assertTrue(matrix.has_data(self.data))

    def execute(self, rc=0, timeout=False):
        def fake(cmd, **kwargs):
            env = kwargs.get("env", os.environ)
            save = Path(cmd[cmd.index("--save") + 1])
            self.assertTrue((save.parent / "config.json").is_file())
            for arg in self.run.launch_args:
                self.assertIn(arg, cmd)
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
        other.launch_args = self.run.launch_args
        matrix.locate_run(other, self.root, self.exe, self.data, self.script, 100)
        return other

    def test_launch_uses_fixed_ntsc_runtime_without_selector_config(self):
        self.execute()
        config = json.loads((self.run.dir / "config.json").read_bytes())
        self.assertEqual(config["game"], {"debug_mode": False})
        receipt = json.loads((self.run.dir / "result.json").read_text())
        self.assertEqual(receipt["provenance"]["runtime_timing"], {"region": "ntsc", "tick_hz": 60})
        self.assertEqual(self.reload().rc, 0)

    def test_letterbox_setting_is_next_to_save_directory(self):
        self.run.aspect = "4:3"
        self.execute()
        config = json.loads((self.run.dir / "config.json").read_bytes())
        self.assertEqual(config["video"]["aspect"], "4:3")
        self.assertFalse((self.run.dir / "save" / "config.json").exists())

    def test_jump_and_fast_load_are_recorded_in_provenance(self):
        self.run.launch_args = ("--jump", "title", "--fast-load")
        self.execute()
        self.assertEqual(self.reload().launch_args, self.run.launch_args)
        self.run.launch_args = ()
        with self.assertRaises(matrix.RunFailed):
            self.reload()

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
        (self.run.dir / "config.json").write_text("{}")
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


class MatrixPixelContract(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if error := matrix.load_deps():
            raise unittest.SkipTest(f"numpy/Pillow unavailable: {error}")

    def test_sparse_two_value_raster_difference_is_allowed(self):
        reference = matrix.np.zeros((40, 40, 3), dtype=matrix.np.uint8)
        rendered = reference.copy()
        rendered[7, 9, 0] = 2
        changed, maximum, allowed = matrix.letterbox_difference(rendered, reference)
        self.assertLessEqual(changed, allowed)
        self.assertLessEqual(maximum, matrix.LETTERBOX_MAX_DIFF)

    def test_widespread_or_larger_difference_is_rejected(self):
        reference = matrix.np.zeros((40, 40, 3), dtype=matrix.np.uint8)
        rendered = reference.copy()
        rendered[:3, :3, 0] = 2
        changed, maximum, allowed = matrix.letterbox_difference(rendered, reference)
        self.assertGreater(changed, allowed)
        self.assertEqual(maximum, 2)
        rendered = reference.copy()
        rendered[7, 9, 0] = 3
        changed, maximum, allowed = matrix.letterbox_difference(rendered, reference)
        self.assertLessEqual(changed, allowed)
        self.assertGreater(maximum, matrix.LETTERBOX_MAX_DIFF)

    def test_side_bars_must_be_exactly_black(self):
        image = matrix.np.zeros((40, 60, 3), dtype=matrix.np.uint8)
        rect = (10, 0, 40, 40)
        self.assertEqual(matrix.nonblack_outside(image, rect), 0)
        image[5, 0, 0] = 1
        self.assertEqual(matrix.nonblack_outside(image, rect), 1)


if __name__ == "__main__":
    unittest.main()
