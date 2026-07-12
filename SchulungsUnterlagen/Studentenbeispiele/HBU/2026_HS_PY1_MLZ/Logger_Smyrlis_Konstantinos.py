#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Logger_Smyrlis_Konstantinos.py
# Description: Loggt Wetterdaten in eine Datei.
# ------------------------------------------------------------------

import argparse
import datetime
import json
import time
import urllib.parse
import urllib.request
from pathlib import Path


class FileLogger:
    LOG_LEVELS = (
        "DEBUG",
        "INFO",
        "WARNINGS",
        "ERROR",
        "CRITICAL",
    )
    STRATEGIES = (
        "FixedSlices",
        "OnlyChanges",
    )

    def __init__(
        self,
        file_path=".",
        file_name="weatherLog.txt",
        delimiter="|",
        max_entries=100,
        strategy="FixedSlices",
        timestamp_format="%Y-%m-%d %H:%M:%S",
        append=False,
        columns=None,
    ):
        # Diese Werte koennen beim Erstellen des Loggers gesetzt werden.
        self.delimiter = delimiter
        self.file_path = file_path
        self.file_name = file_name
        self.max_entries = max_entries
        self.strategy = strategy
        self.timestamp_format = timestamp_format
        self.columns = list(columns or [])
        self.last_values = None
        self.start_time = datetime.datetime.now()

        # Beim Start wird entweder ein neues File mit Header erstellt
        # oder an ein bestehendes File angehaengt.
        self.full_file_name.parent.mkdir(parents=True, exist_ok=True)
        if append and self.full_file_name.exists():
            self._load_last_values()
        else:
            self._write_header()

    @property
    def delimiter(self):
        return self._delimiter

    @delimiter.setter
    def delimiter(self, value):
        if value == "":
            raise ValueError("Delimiter darf nicht leer sein.")
        self._delimiter = value

    @property
    def file_path(self):
        return self._file_path

    @file_path.setter
    def file_path(self, value):
        self._file_path = Path(value)

    @property
    def file_name(self):
        return self._file_name

    @file_name.setter
    def file_name(self, value):
        if value == "":
            raise ValueError("File-Name darf nicht leer sein.")
        self._file_name = value

    @property
    def full_file_name(self):
        return self.file_path / self.file_name

    @property
    def max_entries(self):
        return self._max_entries

    @max_entries.setter
    def max_entries(self, value):
        value = int(value)
        if value < 1:
            raise ValueError("max_entries muss mindestens 1 sein.")
        self._max_entries = value

    @property
    def strategy(self):
        return self._strategy

    @strategy.setter
    def strategy(self, value):
        if value not in self.STRATEGIES:
            raise ValueError("Strategie muss FixedSlices oder OnlyChanges sein.")
        self._strategy = value

    @property
    def timestamp_format(self):
        return self._timestamp_format

    @timestamp_format.setter
    def timestamp_format(self, value):
        if value == "":
            raise ValueError("Timestamp-Format darf nicht leer sein.")
        self._timestamp_format = value

    def log(self, level, values):
        level = level.upper()
        if level not in self.LOG_LEVELS:
            raise ValueError("Ungueltiger Log-Level: " + level)

        text_values = [str(value) for value in values]
        if self.strategy == "OnlyChanges" and text_values == self.last_values:
            return False

        log_line = self.delimiter.join([self._timestamp(), level] + text_values)
        with self.full_file_name.open("a", encoding="utf-8") as log_file:
            log_file.write(log_line + "\n")

        self.last_values = text_values
        self._scroll_entries()
        return True

    def _timestamp(self):
        return datetime.datetime.now().strftime(self.timestamp_format)

    def _write_header(self):
        start_time = self.start_time.strftime(self.timestamp_format)
        xml_config = (
            "<LogConfig>"
            + "<FileName>"
            + self.file_name
            + "</FileName>"
            + "<StartTime>"
            + start_time
            + "</StartTime>"
            + "</LogConfig>"
        )
        header_lines = [
            "# " + xml_config,
            self.delimiter.join(["Time-Stamp", "Log-Level"] + self.columns),
        ]
        self.full_file_name.write_text("\n".join(header_lines) + "\n", encoding="utf-8")

    def _scroll_entries(self):
        lines = self._read_lines()
        header_lines = lines[:2]
        entry_lines = lines[2:]
        if len(entry_lines) <= self.max_entries:
            return

        entry_lines = entry_lines[-self.max_entries :]
        self.full_file_name.write_text(
            "\n".join(header_lines + entry_lines) + "\n",
            encoding="utf-8",
        )

    def _load_last_values(self):
        lines = self._read_lines()
        if len(lines) < 3:
            return
        self.last_values = lines[-1].split(self.delimiter)[2:]

    def _read_lines(self):
        if not self.full_file_name.exists():
            return []
        return self.full_file_name.read_text(encoding="utf-8").splitlines()

def fetch_json(url, parameters):
    query = urllib.parse.urlencode(parameters)
    request_url = url + "?" + query
    with urllib.request.urlopen(request_url, timeout=20) as response:
        response_text = response.read().decode("utf-8")
    return json.loads(response_text)


def format_weather_values(weather_data):
    main_data = weather_data["main"]
    weather_description = weather_data["weather"][0]

    temperature = format(float(main_data["temp"]), ".1f")
    pressure = str(round(float(main_data["pressure"])))
    humidity = str(round(float(main_data["humidity"])))
    title = weather_description["main"]
    description = weather_description["description"]

    return [temperature, pressure, humidity, title, description]


def build_argument_parser():
    parser = argparse.ArgumentParser(description="Weather Logger CLI")
    parser.add_argument("--sample-time", type=float, default=10.0)
    parser.add_argument("--url", default="https://api.openweathermap.org/data/2.5/weather")
    parser.add_argument("--city", default="Wangen SZ")
    parser.add_argument("--language", default="de")
    parser.add_argument("--app-id", default="144747fd356c86e7926ca91ce78ce170")
    parser.add_argument("--file-path", default=str(Path(__file__).resolve().parent))
    parser.add_argument("--file-name", default="weatherLog.txt")
    parser.add_argument("--delimiter", default="|")
    parser.add_argument("--max-entries", type=int, default=100)
    parser.add_argument(
        "--strategy",
        choices=FileLogger.STRATEGIES,
        default="FixedSlices",
    )
    parser.add_argument("--timestamp-format", default="%Y-%m-%d %H:%M:%S")
    parser.add_argument("--append", action="store_true")
    parser.add_argument("--max-samples", type=int, default=0)
    return parser


def main():
    args = build_argument_parser().parse_args()
    logger = FileLogger(
        file_path=args.file_path,
        file_name=args.file_name,
        delimiter=args.delimiter,
        max_entries=args.max_entries,
        strategy=args.strategy,
        timestamp_format=args.timestamp_format,
        append=args.append,
        columns=[
            "Temp [C]",
            "Druck [mBar]",
            "Feuchte [%]",
            "Bezeichnung [" + args.language + "]",
            "Beschreibung [" + args.language + "]",
        ],
    )

    parameters = {
        "q": args.city,
        "appid": args.app_id,
        "mode": "",
        "units": "metric",
        "lang": args.language,
    }

    sample_count = 0
    while args.max_samples == 0 or sample_count < args.max_samples:
        sample_count += 1
        log_weather_sample(args.url, parameters, logger, args.delimiter)

        if args.max_samples == 0 or sample_count < args.max_samples:
            time.sleep(args.sample_time)


def log_weather_sample(url, parameters, logger, delimiter):
    try:
        weather_data = fetch_json(url, parameters)
        if "main" not in weather_data or "weather" not in weather_data:
            message = weather_data.get("message", "Ungueltige REST-Antwort")
            logger.log("ERROR", [message, "", "", "", ""])
            print("ERROR:", message)
            return

        values = format_weather_values(weather_data)
        log_level = "WARNINGS" if float(weather_data["main"]["temp"]) > 35 else "INFO"
        if logger.log(log_level, values):
            print(delimiter.join(values))
    except Exception as exception:
        logger.log("ERROR", [str(exception), "", "", "", ""])
        print("ERROR:", exception)


if __name__ == "__main__":
    main()
