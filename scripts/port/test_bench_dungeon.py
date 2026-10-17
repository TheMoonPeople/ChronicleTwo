import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import bench_dungeon


class BenchDungeon(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.exe = self.root / "darkchronicle"
        self.exe.write_bytes(b"binary")
        self.data = self.root / "data"
        self.data.mkdir()

    def test_parse_log_fps_budget_lines(self):
        log = """
present: FPS 0.0  TICK 0.0/60  DRAWS 2  CANON 0.0ms DISP 0.0ms OTH 0.0ms
present: FPS 70.0  TICK 140.0/60  DRAWS 1500  CANON 2.0ms DISP 1.5ms OTH 3.0ms
present: FPS 68.0  TICK 136.0/60  DRAWS 1600  CANON 2.5ms DISP 1.6ms OTH 3.1ms
present: FPS 72.0  TICK 144.0/60  DRAWS 1550  CANON 2.2ms DISP 1.4ms OTH 2.9ms
"""
        rows = bench_dungeon.parse_log(log)
        self.assertEqual(len(rows), 4)
        summary = bench_dungeon.summarize(rows)
        self.assertEqual(summary["steady_samples"], 2)
        self.assertAlmostEqual(summary["fps"]["median"], 70.0)

    def test_run_writes_summary(self):
        work = self.root / "work"
        log = (
            b"dataread: indexed\n"
            b"present: FPS 10.0  TICK 20.0/60  DRAWS 100  CANON 1.0ms DISP 0.0ms OTH 1.0ms\n"
            b"present: FPS 60.0  TICK 120.0/60  DRAWS 1500  CANON 2.0ms DISP 1.0ms OTH 2.0ms\n"
            b"present: FPS 62.0  TICK 124.0/60  DRAWS 1550  CANON 2.1ms DISP 1.1ms OTH 2.1ms\n"
            b"present: FPS 61.0  TICK 122.0/60  DRAWS 1520  CANON 2.2ms DISP 1.2ms OTH 2.2ms\n"
            b"present: FPS 63.0  TICK 126.0/60  DRAWS 1580  CANON 2.0ms DISP 1.0ms OTH 2.0ms\n"
        )

        def fake_run(cmd, **kwargs):
            self.assertIn("--log-fps", cmd)
            self.assertIn("dungeon:0:1", cmd)
            self.assertNotIn("--headless", cmd)
            self.assertNotIn("--offscreen", cmd)
            stdout = kwargs.get("stdout")
            if stdout is not None:
                stdout.write(log.decode("utf-8"))
            return subprocess.CompletedProcess(cmd, 0, b"", b"")

        with patch.object(bench_dungeon.subprocess, "run", side_effect=fake_run):
            rc = bench_dungeon.main(
                ["--exe", str(self.exe), "--data", str(self.data), "--work", str(work)]
            )
        self.assertEqual(rc, 0)
        summary = json.loads((work / "summary.json").read_text(encoding="utf-8"))
        self.assertEqual(summary["rc"], 0)
        self.assertGreaterEqual(summary["metrics"]["steady_samples"], 3)

    def test_missing_data_skips(self):
        with patch.dict(os.environ, {}, clear=True):
            empty = self.root / "nodata"
            rc = bench_dungeon.main(["--exe", str(self.exe), "--data", str(empty)])
        self.assertEqual(rc, bench_dungeon.SKIP)


if __name__ == "__main__":
    unittest.main()
