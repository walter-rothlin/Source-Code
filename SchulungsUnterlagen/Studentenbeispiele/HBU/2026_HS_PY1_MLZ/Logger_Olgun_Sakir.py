#!/usr/bin/python3
# ------------------------------------------------------------------
# Name  : Logger_Olgun_Sakir.py
# Autor : Sakir Olgun
# Zweck : MLZ - Logger-Klasse, die Einträge strukturiert in eine Datei schreibt. 
# Datum : 29.06.2024 
#
# History:
# 29.06.2024 - Initiale Version - Sakir Olgun
# ------------------------------------------------------------------

import os
import datetime


class Logger:
    """Schreibt strukturierte Log-Einträge zeilenweise in eine Datei"""

    LEVELS = ("DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL")
    STRATEGIES = ("FixedSlices", "OnlyChanges")

    def __init__(self, file_name="app.log", file_path="", columns=None,
                 delimiter="|", timestamp_format="%Y-%m-%d %H:%M:%S",
                 max_entries=0, strategy="FixedSlices", append=False):
        self._file_name = file_name
        self._file_path = file_path
        self._columns = list(columns) if columns else []
        self._delimiter = delimiter
        self._timestamp_format = timestamp_format
        self._max_entries = int(max_entries)
        self.set_strategy(strategy)
        self._last_values = None

        self._init_file(append)

    def get_strategy(self):
        return self._strategy

    def set_strategy(self, value):
        if value not in self.STRATEGIES:
            raise ValueError(f"Ungültige Strategie: {value}")
        self._strategy = value

    # --- Logging ----------------------------------------------------------
    def log(self, level, *values):
        """Loggt eine Zeile mit Zeitstempel, Level und Werten in eine neue oder bestehende Datei."""
        if level not in self.LEVELS:
            raise ValueError(f"Ungültiges Log-Level: {level}")

        if self._strategy == "OnlyChanges" and values == self._last_values:
            return
        self._last_values = values

        entry = self._delimiter.join(
            [self._timestamp(), level] + [str(v) for v in values])
        print(entry)

        if not os.path.exists(self._full_path()):
            self._write_header()
        with open(self._full_path(), "a", encoding="utf-8") as f:
            f.write(entry + "\n")
        self._scroll()

    def debug(self, *values):
        self.log("DEBUG", *values)

    def info(self, *values):
        self.log("INFO", *values)

    def warning(self, *values):
        self.log("WARNING", *values)

    def error(self, *values):
        self.log("ERROR", *values)

    def critical(self, *values):
        self.log("CRITICAL", *values)

    # --- Intern -----------------------------------------------------------
    def _full_path(self):
        return os.path.join(self._file_path, self._file_name)

    def _timestamp(self):
        return datetime.datetime.now().strftime(self._timestamp_format)

    def _init_file(self, append):
        has_content = (os.path.exists(self._full_path())
                       and os.path.getsize(self._full_path()) > 0)
        if not (append and has_content):
            self._write_header()

    def _write_header(self):
        start = datetime.datetime.now().strftime(self._timestamp_format)
        comment = f'# <log file="{self._file_name}" start="{start}" />'
        title = self._delimiter.join(["Timestamp", "Level"] + self._columns)
        with open(self._full_path(), "w", encoding="utf-8") as f:
            f.write(comment + "\n")
            f.write(title + "\n")

    def _scroll(self):
        if self._max_entries <= 0:
            return
        with open(self._full_path(), encoding="utf-8") as f:
            lines = f.readlines()
        header, data = lines[:2], lines[2:]
        if len(data) > self._max_entries:
            with open(self._full_path(), "w", encoding="utf-8") as f:
                f.writelines(header + data[-self._max_entries:])

if __name__ == "__main__":
    # Tests: Methoden
    print("# Log-Levels:")
    log = Logger(file_name="demo.log", columns=["Sensor", "Wert"])
    log.debug("Temp", 19)
    log.info("Temp", 20)
    log.warning("Temp", 35)
    log.error("Temp", 80)
    log.critical("Temp", 99)
    log.log("INFO", "Temp", 21)


    # Tests: Strategien
    werte = [10, 10, 10, 20, 20]

    # 1. FixedSlices: schreibt jeden Aufruf -> 5 Einträge.
    print("\n# FixedSlices (schreibt jeden Aufruf):")
    fixed = Logger(file_name="demo_fixed.log", columns=["Wert"],
                   strategy="FixedSlices")
    for w in werte:
        fixed.info(w)

    # 2. OnlyChanges: schreibt nur Änderungen -> 2 Einträge (10 und 20).
    print("\n# OnlyChanges (schreibt nur Änderungen):")
    changes = Logger(file_name="demo_changes.log", columns=["Wert"],
                     strategy="OnlyChanges")
    for w in werte:
        changes.info(w)