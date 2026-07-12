#!/usr/bin/env python3

import os
import time
from datetime import datetime
from enum import Enum, auto


class LogLevel(Enum):
    DEBUG = auto()
    INFO = auto()
    WARNINGS = auto()
    ERROR = auto()
    CRITICAL = auto()


class RecordingStrategy(Enum):
    FIXED_SLICES = auto()
    ONLY_CHANGES = auto()


class Logger:
    def __init__(
        self,
        file_path: str,
        delimiter: str = "|",
        max_entries: int = 100,
        strategy: RecordingStrategy = RecordingStrategy.FIXED_SLICES,
        append: bool = False,
    ):
        self.file_path = file_path
        self.delimiter = delimiter
        self.max_entries = max_entries
        self.strategy = strategy
        self.timestamp_format = "%Y-%m-%d %H:%M:%S"
        self._initialize_file(append)

    def _initialize_file(self, append: bool):
        if not append or not os.path.exists(self.file_path):
            with open(self.file_path, "w") as file:
                file.write(
                    f"<!-- File: {os.path.basename(self.file_path)}, Start-Time: {datetime.now().strftime(self.timestamp_format)} -->\n"
                )
                file.write(
                    f"Time-Stamp{self.delimiter}Log-Level{self.delimiter}Message\n"
                )

    def log(self, level: LogLevel, message: str):
        timestamp = datetime.now().strftime(self.timestamp_format)
        log_entry = (
            f"{timestamp}{self.delimiter}{level.name}{self.delimiter}{message}\n"
        )

        if self._is_new_entry_identical_to_last(level, message):
            return  # Skip writing if the last entry is the same

        with open(self.file_path, "a") as file:
            file.write(log_entry)

        self._enforce_max_entries()

    def _is_new_entry_identical_to_last(self, level: LogLevel, message: str):
        is_identical_entry = False

        if self.strategy == RecordingStrategy.ONLY_CHANGES:
            with open(self.file_path, "r") as file:
                lines = file.readlines()
            if len(lines) > 2:  # Check if there are any log entries
                last_entry = lines[-1].strip().split(self.delimiter)
                if (
                    len(last_entry) >= 3
                    and last_entry[1] == level.name
                    and last_entry[2] == message
                ):
                    is_identical_entry = True

        return is_identical_entry

    def _enforce_max_entries(self):
        with open(self.file_path, "r") as file:
            lines = file.readlines()

        if len(lines) > self.max_entries + 2:  # +2 for header lines
            with open(self.file_path, "w") as file:
                file.writelines(lines[:2])  # Keep header
                file.writelines(lines[-self.max_entries :])  # Keep last max_entries

    def set_delimiter(self, delimiter: str):
        self.delimiter = delimiter

    def set_max_entries(self, max_entries: int):
        self.max_entries = max_entries

    def set_recording_strategy(self, strategy: RecordingStrategy):
        self.strategy = strategy

    def set_timestamp_format(self, timestamp_format: str):
        self.timestamp_format = timestamp_format


# Logger Demo
if __name__ == "__main__":
    import requests

    # Current air temperature from all meteo swiss weahter stations
    url = "https://www.meteoschweiz.admin.ch/product/output/measured-values/stationsTable/messwerte-lufttemperatur-10min/stationsTable.messwerte-lufttemperatur-10min.de.json"
    sample_time = 10
    file_path = "air-temperature-taenikon.csv"

    logger = Logger(file_path)

    try:
        while True:
            response = requests.get(url)

            # Get the value from station Taenikon/Aadorf
            # ToDo: Query by station_name
            data = response.json()["stations"][76]["current"]
            value = round(float(data["value"]), 1)

            # ToDo: Query by key
            unit = response.json()["headers"][2]["unit"]

            log_entry = f"Temperature: {value} {unit}"

            logger.log(LogLevel.INFO, log_entry)

            print(log_entry)

            logger.log(LogLevel.INFO, "adfadf, ieieod")

            time.sleep(sample_time)
    except KeyboardInterrupt:
        print("\nLogging stopped by user.")
