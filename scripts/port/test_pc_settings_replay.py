import contextlib
import io
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
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


if __name__ == "__main__":
    unittest.main()
