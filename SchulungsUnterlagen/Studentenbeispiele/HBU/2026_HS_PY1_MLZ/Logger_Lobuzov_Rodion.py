#!/usr/bin/env python3
# ------------------------------------------------------------------
# Name  : Logger_Lobuzov_Rodion.py
# Description: Generic Logger class + built-in tests + weather CLI demo
# Autor: Rodion Lobuzov
#
# Reused: Scroll/OnlyChanges-Idee aus wetter_logger.py (HFU Übung 006)
# Reused: CLI-Struktur angelehnt an WeatherLogger_05
# ------------------------------------------------------------------

import csv
import datetime
import sys
import time
from pathlib import Path

import requests

VALID_LEVELS = ("DEBUG", "INFO", "WARNINGS", "ERROR", "CRITICAL")
STRATEGIES = ("OnlyChanges", "FixedSlices")

OPENWEATHER_API_KEY = "8a3da742593b454e520a9bd95049bf70"

SCRIPT_DIR = Path(__file__).resolve().parent


def print_log_path_hinweis():
    cwd = Path.cwd()
    print(f"\n  Arbeitsverzeichnis (pwd): {cwd}")
    print(f"  logger.py liegt in:       {SCRIPT_DIR}")
    if cwd != SCRIPT_DIR:
        print("  --> Die Log-Datei kommt ins Arbeitsverzeichnis (pwd),")

def resolve_log_path(file_path):
    if not file_path:
        return ""
    path = Path(file_path)
    if not path.is_absolute():
        path = Path.cwd() / path
    return str(path)


def ask_yes_no(question, default="j"):
    default_is_yes = default.lower() in ("j", "ja", "y", "yes")
    default_hint = "j (ja)" if default_is_yes else "n (nein)"
    print(f"\n{question}")
    print("  j / ja  = ja")
    print("  n / nein = nein")
    answer = input(f"Deine Wahl [Enter = {default_hint}]: ").strip().lower()
    if answer == "":
        return default_is_yes
    if answer in ("n", "nein", "no"):
        return False
    return answer in ("j", "ja", "y", "yes")


def ask_text(label, default="", hint=""):
    print(f"\n{label}")
    if hint:
        print(f"  {hint}")
    if default:
        value = input(f"Eingabe [Enter = '{default}']: ").strip()
        return value or default
    return input("Eingabe: ").strip()


def ask_strategy():
    print("\nAufzeichnungs-Strategie:")
    print("  OnlyChanges = nur loggen, wenn sich die Werte ändern")
    print("  FixedSlices = jede Messung loggen")
    value = input("Eingabe [Enter = 'OnlyChanges']: ").strip() or "OnlyChanges"
    if value not in STRATEGIES:
        print("  Unbekannt — verwende 'OnlyChanges'.")
        return "OnlyChanges"
    return value


class Logger:
    """Allgemeiner Datei-/Konsolen-Logger — ohne Wetter, ohne HTTP."""

    def __init__(
        self,
        file_path="weatherLog.txt",
        delimiter="|",
        timestamp_format="{:%Y-%m-%d %H:%M:%S}",
        max_entries=1000,
        strategy="OnlyChanges",
        append_mode=False,
    ):
        self.file_path = resolve_log_path(file_path) if file_path else ""
        self.delimiter = delimiter
        self.timestamp_format = timestamp_format
        self.max_entries = int(max_entries)
        self.strategy = strategy if strategy in STRATEGIES else "OnlyChanges"
        self.append_mode = bool(append_mode)
        self.__header_written = False
        self.__last_data_part = ""
        self.__pinging = False

    @property
    def delimiter(self):
        return self.__delimiter

    @delimiter.setter
    def delimiter(self, value):
        self.__delimiter = str(value)

    @property
    def file_path(self):
        return self.__file_path

    @file_path.setter
    def file_path(self, value):
        self.__file_path = resolve_log_path(value) if value else ""

    @property
    def max_entries(self):
        return self.__max_entries

    @max_entries.setter
    def max_entries(self, value):
        self.__max_entries = int(value)

    @property
    def strategy(self):
        return self.__strategy

    @strategy.setter
    def strategy(self, value):
        if value not in STRATEGIES:
            raise ValueError(f"strategy must be one of {STRATEGIES}")
        self.__strategy = value

    @property
    def timestamp_format(self):
        return self.__timestamp_format

    @timestamp_format.setter
    def timestamp_format(self, value):
        self.__timestamp_format = str(value)

    @property
    def append_mode(self):
        return self.__append_mode

    @append_mode.setter
    def append_mode(self, value):
        self.__append_mode = bool(value)

    def get_timestamp(self):
        return self.timestamp_format.format(datetime.datetime.now())

    def write_header(self, config_line, column_titles):
        if self.__header_written:
            return

        if self.append_mode and self.file_path and Path(self.file_path).exists():
            if Path(self.file_path).stat().st_size > 0:
                self.__header_written = True
                return

        line1 = config_line if config_line.startswith("#") else f"# {config_line}"
        titles = ["Timestamp", "Level"] + list(column_titles)
        line2 = self.delimiter.join(titles)

        self._output_lines([line1, line2], mode="w")
        self.__header_written = True

    def log(self, level, columns):
        if level not in VALID_LEVELS:
            raise ValueError(f"level must be one of {VALID_LEVELS}")

        data_part = self.delimiter.join([level] + [str(c) for c in columns])

        if self.strategy == "OnlyChanges" and data_part == self.__last_data_part:
            self.__pinging = True
            print(".", end="", flush=True)
            return False

        self.__last_data_part = data_part
        if self.__pinging:
            print()
            self.__pinging = False

        log_line = self.delimiter.join([self.get_timestamp(), data_part])
        print(log_line)

        if self.file_path:
            with open(self.file_path, "a", encoding="utf-8") as f:
                f.write(log_line + "\n")
            self._scroll()

        return True

    def _output_lines(self, lines, mode="a"):
        text = "\n".join(lines) + "\n"
        print(text, end="")
        if self.file_path:
            with open(self.file_path, mode, encoding="utf-8") as f:
                f.write(text)

    def _scroll(self):
        if not self.file_path:
            return

        path = Path(self.file_path)
        if not path.exists():
            return

        lines = path.read_text(encoding="utf-8").splitlines()
        if len(lines) <= 2:
            return

        data_count = len(lines) - 2
        if data_count <= self.max_entries:
            return

        del lines[2]
        path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def run_tests(csv_filename="logger_test_results.csv"):
    test_log = resolve_log_path("_logger_test_tmp.log")
    rows = []

    def record(nr, name, ok, detail=""):
        status = "success" if ok else "fehler"
        rows.append([nr, name, detail, status])
        return ok

    if Path(test_log).exists():
        Path(test_log).unlink()
    logger = Logger(file_path=test_log, strategy="FixedSlices", append_mode=False)
    logger.write_header(
        "# <Config><Test>header</Test></Config>",
        ["ColA", "ColB"],
    )
    content = Path(test_log).read_text(encoding="utf-8").splitlines()
    record(1, "header_2_zeilen", len(content) == 2, f"lines={len(content)}")

    logger.log("INFO", ["1", "2"])
    content = Path(test_log).read_text(encoding="utf-8").splitlines()
    record(2, "log_schreibt", len(content) == 3 and "INFO" in content[2])

    logger_oc = Logger(file_path=test_log + ".oc", strategy="OnlyChanges", append_mode=False)
    logger_oc.write_header("# <Config></Config>", ["X"])
    r1 = logger_oc.log("INFO", ["a"])
    r2 = logger_oc.log("INFO", ["a"])
    lines_oc = Path(logger_oc.file_path).read_text(encoding="utf-8").splitlines()
    record(
        3,
        "only_changes",
        r1 is True and r2 is False and len(lines_oc) == 3,
        f"r1={r1}, r2={r2}, data_lines={len(lines_oc) - 2}",
    )

    logger_fs = Logger(file_path=test_log + ".fs", strategy="FixedSlices", append_mode=False)
    logger_fs.write_header("# <Config></Config>", ["X"])
    logger_fs.log("INFO", ["a"])
    logger_fs.log("INFO", ["a"])
    lines_fs = Path(logger_fs.file_path).read_text(encoding="utf-8").splitlines()
    record(4, "fixed_slices", len(lines_fs) == 4, f"lines={len(lines_fs)}")

    logger_sc = Logger(file_path=test_log + ".sc", strategy="FixedSlices", max_entries=2, append_mode=False)
    logger_sc.write_header("# <Config></Config>", ["N"])
    logger_sc.log("INFO", ["1"])
    logger_sc.log("INFO", ["2"])
    logger_sc.log("INFO", ["3"])
    lines_sc = Path(logger_sc.file_path).read_text(encoding="utf-8").splitlines()
    scroll_ok = (
        len(lines_sc) == 4
        and lines_sc[2].endswith("|2")
        and lines_sc[3].endswith("|3")
    )
    record(5, "scroll", scroll_ok, f"lines={len(lines_sc)}")

    logger_co = Logger(file_path="", strategy="FixedSlices")
    record(6, "nur_konsole", logger_co.file_path == "", "file_path leer")

    for p in Path.cwd().glob("_logger_test_tmp*"):
        p.unlink(missing_ok=True)

    passed = sum(1 for r in rows if r[3] == "success")
    csv_path = Path.cwd() / csv_filename
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f, delimiter=";")
        writer.writerow(["nr", "test", "detail", "status"])
        writer.writerows(rows)

    print(f"\nTest-CSV: {csv_path}")
    print("nr;test;detail;status")
    for row in rows:
        print(";".join(str(c) for c in row))
    print(f"\n{passed}/{len(rows)} Tests bestanden")
    return passed == len(rows)


def configure_logger_interactive():
    print("\n" + "=" * 50)
    print("  LOGGER EINRICHTEN")
    print("=" * 50)

    log_to_file = ask_yes_no("Soll in eine Datei geloggt werden?", "j")
    file_path = ""
    max_entries = 1000
    append_mode = False

    if log_to_file:
        print_log_path_hinweis()
        file_path = ask_text(
            "Name der Log-Datei:",
            default="weatherLog.txt",
            hint="Nur Dateiname — gespeichert im Arbeitsverzeichnis (siehe pwd oben).",
        )
        max_entries = int(
            ask_text(
                "Maximale Anzahl Einträge in der Datei (Scroll):",
                default="1000",
                hint="Älteste Zeile wird gelöscht, wenn mehr Einträge da sind.",
            )
        )
        append_mode = ask_yes_no("An bestehende Datei anhängen (statt neu erstellen)?", "n")

    delimiter = ask_text(
        "Trennzeichen zwischen Spalten (Delimiter):",
        default="|",
        hint="Meist '|' — gilt für Konsole und Datei.",
    )
    strategy = ask_strategy()

    logger = Logger(
        file_path=file_path,
        delimiter=delimiter,
        strategy=strategy,
        max_entries=max_entries,
        append_mode=append_mode,
    )
    if file_path:
        print(f"\n→ Log-Datei wird geschrieben nach:\n  {logger.file_path}")
    else:
        print("\n→ Nur Konsole — es wird keine Datei geschrieben.")
    return logger


def normalize_ort(ort):
    return ort.replace("+", " ").strip()


def ask_ort():
    print("\nOrt der Wetterstation:")
    print("  So eingeben:")
    print("    Stadt,land     → z.B. Berlin,de  oder  Winterthur,ch")
    print("    Stadt mit Ort  → z.B. Wangen SZ  (Leerzeichen, kein Komma nötig)")
    print("  Nicht: Stadt und Land mit Leerzeichen trennen (z.B. 'Berlin de' geht nicht)")
    value = input("Eingabe [Enter = 'Wangen SZ']: ").strip()
    return normalize_ort(value or "Wangen SZ")


def fetch_weather(url, params):
    response = requests.get(url, params=params, timeout=10)
    data = response.json()
    if response.status_code != 200:
        msg = data.get("message", f"API-Fehler {response.status_code}")
        if "city not found" in msg.lower():
            ort = params.get("q", "?")
            raise RuntimeError(
                f"Ort nicht gefunden: '{ort}'\n"
                "  Richtig eingeben:\n"
                "    Berlin,de        (Stadt,Kürzel Land)\n"
                "    Winterthur,ch\n"
                "    Wangen SZ        (Ortsname mit Leerzeichen)\n"
                "  Falsch: Berlin de  (Leerzeichen statt Komma)"
            )
        raise RuntimeError(msg)
    return data


def run_weather_demo(logger):
    print("\n" + "=" * 50)
    print("  WETTER-LOGGING")
    print("=" * 50)

    polling_time = float(
        ask_text(
            "Wie oft soll abgefragt werden (Sekunden)?",
            default="1",
            hint="z. B. 1 = jede Sekunde, 60 = jede Minute.",
        )
    )
    ort = ask_ort()
    language = ask_text(
        "Sprache für Wettertexte:",
        default="de",
        hint="Möglich: de, el, en, fr, hr, it",
    )
    url = ask_text(
        "URL der Wetter-API:",
        default="https://api.openweathermap.org/data/2.5/weather",
    )

    params = {
        "q": ort,
        "appid": OPENWEATHER_API_KEY,
        "units": "metric",
        "lang": language,
    }

    json_response = fetch_weather(url, params)
    coord = json_response["coord"]

    fname = Path(logger.file_path).name if logger.file_path else "console"
    config_line = (
        f"# <Config><Ort>{ort}</Ort><Lon>{coord['lon']}</Lon>"
        f"<Lat>{coord['lat']}</Lat><FName>{fname}</FName>"
        f"<StartTime>{logger.get_timestamp()}</StartTime></Config>"
    )
    column_titles = [
        "Temp [°C] ",
        "Druck [mBar]",
        "Feuchte [%]",
        f"Bezeichnung [{language}]",
        f"Beschreibung [{language}]",
    ]
    logger.write_header(config_line, column_titles)

    print("Wetter-Logging läuft — Strg+C zum Stoppen.\n")
    while True:
        json_response = fetch_weather(url, params)
        temp = round(json_response["main"]["temp"], 1)
        pressure = int(json_response["main"]["pressure"])
        humidity = int(json_response["main"]["humidity"])
        bezeichnung = json_response["weather"][0]["main"]
        beschreibung = json_response["weather"][0]["description"]

        logger.log(
            "INFO",
            [str(temp), str(pressure), str(humidity), bezeichnung, beschreibung],
        )
        time.sleep(polling_time)


def main():
    print("\n" + "=" * 50)
    print("  WETTER LOGGER — HFU")
    print("=" * 50)
    print("Nur Tests:  python3 Logger_Lobuzov_Rodion.py --test")

    if "--test" in sys.argv:
        ok = run_tests()
        sys.exit(0 if ok else 1)

    if ask_yes_no("Zuerst die eingebauten Tests ausführen?", "n"):
        run_tests()
        print()

    logger = configure_logger_interactive()
    try:
        run_weather_demo(logger)
    except KeyboardInterrupt:
        print("\nGestoppt.")


if __name__ == "__main__":
    main()
