#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Logger_Reiser_Pasqual.py
#
# Description:
#   Structured file logger and simple weather CLI.
#
# Autor: Pasqual Reiser
#
# History:
# 29-June-2026  Pasqual             Initial Version
# ------------------------------------------------------------------
import datetime
import json
import os
import time
import requests

class Logger:
    LEVELS = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
    STRATEGY_FIXED_SLICES = "FixedSlices"
    STRATEGY_ONLY_CHANGES = "OnlyChanges"

    def __init__(
        self,
        file_path=".",
        file_name="log.txt",
        delimiter="|",
        max_entries=100,
        strategy=STRATEGY_FIXED_SLICES,
        append=False,
        timestamp_format="%Y-%m-%d %H:%M:%S",
        columns=None,
    ):
        self.file_path = str(file_path)
        self.file_name = str(file_name)
        self.full_file_name = os.path.join(self.file_path, self.file_name)
        self.delimiter = str(delimiter)
        self.max_entries = int(max_entries)
        self.strategy = self._validate_strategy(strategy)
        self.append = append
        self.timestamp_format = str(timestamp_format)
        self.columns = columns or ["Message"]
        self._last_values = None
        self._column_widths = self._create_column_widths()

        os.makedirs(self.file_path, exist_ok=True)

        if not self.append or not os.path.exists(self.full_file_name):
            self._write_header()

    def _validate_strategy(self, value):
        if value not in [self.STRATEGY_FIXED_SLICES, self.STRATEGY_ONLY_CHANGES]:
            raise ValueError("strategy muss 'FixedSlices' oder 'OnlyChanges' sein")
        return value

    def log(self, level, values):
        level = level.upper()
        if level not in self.LEVELS:
            raise ValueError("Ungueltiger Log-Level")

        if not isinstance(values, (list, tuple)):
            values = [values]

        values = [str(value) for value in values]

        if self.strategy == self.STRATEGY_ONLY_CHANGES and values == self._last_values:
            return

        timestamp = datetime.datetime.now().strftime(self.timestamp_format)
        line = self._format_row([timestamp, level] + values)

        with open(self.full_file_name, "a", encoding="utf-8") as file:
            file.write(line + "\n")

        self._last_values = values
        self._scroll_if_needed()

    def debug(self, values):
        self.log("DEBUG", values)

    def info(self, values):
        self.log("INFO", values)

    def warning(self, values):
        self.log("WARNING", values)

    def error(self, values):
        self.log("ERROR", values)

    def critical(self, values):
        self.log("CRITICAL", values)

    def _write_header(self):
        start_time = datetime.datetime.now().strftime(self.timestamp_format)
        header = [
            f"# <Log><FileName>{self.file_name}</FileName><StartTime>{start_time}</StartTime></Log>",
            self._format_row(["Timestamp", "Level"] + self.columns),
        ]

        with open(self.full_file_name, "w", encoding="utf-8") as file:
            file.write("\n".join(header) + "\n")

    def _create_column_widths(self):
        columns = ["Timestamp", "Level"] + self.columns
        widths = []

        for column in columns:
            widths.append(max(len(column), 10))

        widths[0] = max(widths[0], len(datetime.datetime.now().strftime(self.timestamp_format)))
        widths[1] = max(widths[1], len("CRITICAL"))

        return widths

    def _format_row(self, values):
        formatted_values = []

        for index, value in enumerate(values):
            value = str(value)
            width = self._get_column_width(index, value)
            formatted_values.append(value.ljust(width))

        return f" {self.delimiter} ".join(formatted_values)

    def _get_column_width(self, index, value):
        if index < len(self._column_widths):
            return max(self._column_widths[index], len(value))
        return len(value)

    def _scroll_if_needed(self):
        if self.max_entries <= 0:
            return

        with open(self.full_file_name, "r", encoding="utf-8") as file:
            lines = file.readlines()

        header = lines[:2]
        entries = lines[2:]

        if len(entries) <= self.max_entries:
            return

        entries = entries[-self.max_entries:]

        with open(self.full_file_name, "w", encoding="utf-8") as file:
            file.writelines(header + entries)


class WeatherLoggerApp:
    def __init__(self):
        self.sample_time = 1.0
        self.url = "http://api.openweathermap.org/data/2.5/weather"
        self.file_name = "weatherLog.txt"
        self.file_path = "."

    def run(self):
        self._read_cli_arguments()
        params = self._create_weather_params()
        first_weather_data = self._get_weather_data(params)
        coord = first_weather_data["coord"]

        logger = Logger(
            file_path=self.file_path,
            file_name=self.file_name,
            max_entries=100,
            append=False,
            strategy="FixedSlices",
            columns=[
                "Ort",
                "Temp [C]",
                "Druck [mBar]",
                "Feuchtigkeit [%]",
                "Bezeichnung",
                "Beschreibung",
            ],
        )

        print("Logger gestartet.")
        print(f"Log-File: {logger.full_file_name}")
        print(f"Ort-Koordinaten: Lon={coord['lon']} Lat={coord['lat']}")

        while True:
            weather_data = self._get_weather_data(params)
            main = weather_data["main"]
            weather = weather_data["weather"][0]

            name = weather_data["name"]
            temp = f"{main['temp']:.1f}"
            pressure = str(int(main["pressure"]))
            humidity = str(int(main["humidity"]))
            description = weather["description"]
            label = weather["main"]

            logger.info([name, temp, pressure, humidity, label, description])
            print(".", end="", flush=True)
            time.sleep(self.sample_time)

    def _read_cli_arguments(self):
        sample_time = input("Sample-Time [s]           : ")
        city = input("Ort                       : ")
        language = input("Sprache [de,el,en,fr,hr,it]: ")
        url = input("URL REST-Call [Enter=Default]: ")

        if sample_time:
            self.sample_time = float(sample_time)
        self.city = city or "Uster"
        self.language = language or "de"
        if url:
            self.url = url

    def _create_weather_params(self):
        return {
            "q": self.city,
            "appid": "d5d29e0029f86fa2f0ec261a7b853fb0",
            "mode": "",
            "units": "metric",
            "lang": self.language,
        }

    def _get_weather_data(self, params):
        response = requests.get(self.url, params=params, timeout=10)
        response.raise_for_status()
        return json.loads(response.text)


if __name__ == "__main__":
    WeatherLoggerApp().run()
