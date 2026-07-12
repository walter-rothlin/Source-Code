#!/usr/bin/env python3
"""
Test suite for the logger class using pytest.
"""

import sys
from pathlib import Path
from ..logger import Logger, LogLevel, RecordingStrategy

# Add project root to Python path
project_root = Path(__file__).parent.parent
sys.path.append(str(project_root))


# Person class tests
class TestLogger:
    """Test cases for the Logger class."""

    def test_default_delimiter(self):
        """Test that the default delimiter is |."""
        logger = Logger("log.txt")

        assert logger.delimiter == "|"

        # teardown
        Path("log.txt").unlink(missing_ok=True)

    def test_file_path_configurable(self):
        """Test that the file path can be configured and is used."""
        logger = Logger("\logfiles\log.txt")

        assert logger.file_path == "\logfiles\log.txt"
        assert Path("\logfiles\log.txt").exists()

        # teardown
        Path("\logfiles\log.txt").unlink(missing_ok=True)

    def test_max_entries(self):
        logger = Logger("log.txt", max_entries=5)

        # Log 6 entries
        logger.log(LogLevel.INFO, "Log Entry")
        logger.log(LogLevel.INFO, "Log Entry")
        logger.log(LogLevel.INFO, "Log Entry")
        logger.log(LogLevel.INFO, "Log Entry")
        logger.log(LogLevel.INFO, "Log Entry")

        file = open(logger.file_path, "r")
        lines = file.readlines()

        # 1. Line is comment
        # 2. Line contains column names
        # +5 log entries => total 7 lines
        assert len(lines) == 7

        # teardown
        Path("log.txt").unlink(missing_ok=True)

    def test_logger_initialization(self):
        """Test that Person objects are initialized correctly."""
        logger = Logger("log.txt", "|", 10, RecordingStrategy.ONLY_CHANGES, True)
        assert logger.file_path == "log.txt"
        assert logger.delimiter == "|"
        assert logger.max_entries == 10
        assert logger.strategy == RecordingStrategy.ONLY_CHANGES

        # teardown - delete log file
        Path("log.txt").unlink(missing_ok=True)

    def test_log_file_created(self):
        # check if log file has been created
        Logger("log.txt")
        assert Path("log.txt").exists()

    def test_log_file_header(self):
        """Test that the log file has the correct header."""
        Logger("log.txt", "|", 10, RecordingStrategy.ONLY_CHANGES, True)

        with open("log.txt", "r") as file:
            lines = file.readlines()
            assert lines[0].startswith("<!--")
            assert lines[0].endswith("-->\n")
            assert lines[1].strip() == "Time-Stamp|Log-Level|Message"

        # teardown - delete log file
        Path("log.txt").unlink(missing_ok=True)

    def test_log_entry(self):
        """Test that a log entry is written correctly."""
        logger = Logger("log.txt", "|", 10, RecordingStrategy.ONLY_CHANGES, True)
        logger.log(LogLevel.INFO, "Test message")
        with open("log.txt", "r") as file:
            lines = file.readlines()
            assert len(lines) == 3  # header + title + log entry
            assert lines[2].split("|")[1].strip() == "INFO"
            assert "Test message" in lines[2]

        # teardown - delete log file
        Path("log.txt").unlink(missing_ok=True)

    def test_log_scrolling(self):
        """Test that old entries are removed when max_entries is reached."""

        # setup - delete log file if it still exists
        Path("log.txt").unlink(missing_ok=True)

        logger = Logger("log.txt", "|", 2, RecordingStrategy.ONLY_CHANGES, True)
        logger.log(LogLevel.INFO, "Message 1")
        logger.log(LogLevel.INFO, "Message 2")
        logger.log(LogLevel.INFO, "Message 3")
        with open("log.txt", "r") as file:
            lines = file.readlines()
            assert len(lines) == 4  # header + title + 2 log entries
            assert "Message 2" in lines[2]
            assert "Message 3" in lines[3]

        # teardown - delete log file
        Path("log.txt").unlink(missing_ok=True)

    def test_log_only_changes(self):
        """Test that only changes are logged with ONLY_CHANGES strategy."""

        # setup - delete log file if it still exists
        Path("log.txt").unlink(missing_ok=True)

        logger = Logger("log.txt", "|", 10, RecordingStrategy.ONLY_CHANGES, True)
        logger.log(LogLevel.INFO, "Message 1")
        logger.log(LogLevel.INFO, "Message 1")  # same message, should not be logged
        with open("log.txt", "r") as file:
            lines = file.readlines()
            assert len(lines) == 3  # header + title + 1 log entry

        # teardown - delete log file
        Path("log.txt").unlink(missing_ok=True)

    def test_log_fixed_slices(self):
        """Test that all entries are logged with FIXED_SLICES strategy."""
        logger = Logger("log.txt", "|", 10, RecordingStrategy.FIXED_SLICES, True)
        logger.log(LogLevel.INFO, "Message 1")
        logger.log(LogLevel.INFO, "Message 1")  # same message, should be logged
        with open("log.txt", "r") as file:
            lines = file.readlines()
            assert len(lines) == 4  # header + title + 2 log entries

        # teardown - delete log file
        Path("log.txt").unlink(missing_ok=True)
