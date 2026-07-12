#! /usr/bin/python


## es wurde keine KI verwended
## Wetterstation aus vorhergehendem Abend verwendet und erweitert


## Wurde leider nicht mehr ganz fertig
# max entries rotation in file
# Grad-Zeichen wird nicht sauber dargestellt
# logging header nicht sauber umgesetzt
# xml notation
# neues oder bestehendes file nutzen
# wenig tests geschrieben (script mit -t flag ausführen)


import datetime
import os
import uuid
import requests
import json
from time import sleep

appId = "18ec6bd52a510aad4259e0eaaac968dc"


def get_timestamp():
    return "{ts:%Y-%m-%d %H:%M:%S}".format(ts=datetime.datetime.now())


## Wetter Station Klasse welche in Unterricht erarbeitet wurde
class WeatherStation:
    __weather_end_point_url = "https://api.openweathermap.org/data/2.5/weather"

    def __init__(
        self,
        app_id: str,
        location: str = "Näfels",
        language: str = "de",
        units: str = "metric",
    ):
        self.__appId = app_id
        self.__location = location
        self.__units = units
        self.__language = language

    @property
    def location_value(self):
        return self.__location

    @property
    def lon_value(self):
        return self.__lon

    @property
    def lat_value(self):
        return self.__lat

    def get_weather(self) -> str:
        params_end_point = {
            "appid": self.__appId,
            "q": self.__location,
            "units": self.__units,
            "lang": self.__language,
            "mode": "",  # xml, html
        }

        response = requests.get(self.__weather_end_point_url, params_end_point)

        if response.status_code != 200:
            raise ConnectionError(
                f"Ein problem mit der Anforderung der Daten ist aufgetreten. Stimmen die Daten?\n{response.text}"
            )

        response_data = json.loads(response.text)
        mapped_data = self.__map_data(response_data)

        self.__lon = mapped_data["coordinates"]["lon"]
        self.__lat = mapped_data["coordinates"]["lat"]

        return mapped_data

    def __map_data(self, jsonResponse: dict):
        units_letter = self.__get_temparature_unit(self.__units)

        mapped_data = {
            "location": jsonResponse["name"],
            "country": jsonResponse["sys"]["country"],
            "temperature": {
                "value": jsonResponse["main"]["temp"],
                "unit": units_letter,
            },
            "pressure": {"value": jsonResponse["main"]["pressure"], "unit": "hPa"},
            "humidity": {
                "value": jsonResponse["main"]["humidity"],
                "unit": "%",
            },
            "coordinates": {
                "lon": jsonResponse["coord"]["lon"],
                "lat": jsonResponse["coord"]["lat"],
            },
            "description": jsonResponse["weather"][0]["description"],
            "icon_url": f"http://openweathermap.org/img/w/{jsonResponse['weather'][0]['icon']}.png",
            "wind": {
                "velocity": {
                    "value": jsonResponse["wind"]["speed"],
                    "unit": "m/s",
                },
                "direction": {"value": jsonResponse["wind"]["deg"], "unit": "°"},
            },
        }

        return mapped_data

    def __get_temparature_unit(self, unittype: str = "metric"):
        match unittype:
            case "imperial":
                return "°F"
            case "standard":
                return "°K"
            case "metric":
                return "°C"
            case _:
                return "°C"


## Logger Klasse
class MiniLogger:
    def __init__(
        self,
        file_path: str = "log.txt",
        header: str = None,
        max_entries: int = 50,
        delimiter: str = "|",
    ):
        file_handle = open(file_path, "w")
        file_handle.close()

        self.__file_path = file_path
        self.__max_entries = max_entries

        if header is not None:
            self.__header = header
            self.__write_to_file(f"{header}\n")

        self.__delimiter = delimiter

    def __write_to_file(self, entry):
        filehandle = open(self.__file_path, "a")

        ### für rotation hat es leider nicht mehr gereicht

        filehandle.write(entry)
        filehandle.close()

    def __get_log_level_name(self, log_level):
        match (log_level):
            case 0:
                return "DEBUG"
            case 1:
                return "INFO"
            case 2:
                return "WARNING"
            case 3:
                return "ERROR"
            case 4:
                return "CRITICAL"
            case _:
                return "LOG_LEVEL_NOT_RECOGNIZED"

    def log(self, log_message, log_level=2):
        log_level_str = self.__get_log_level_name(log_level)
        time = get_timestamp()
        delim = self.__delimiter

        ## compile entry with timestamp, log level string and message to be logged
        entry = f"{log_level_str} {delim} {time} {delim} {log_message}\n"
        self.__write_to_file(entry)


class CliApplication:
    __polling_interval = 10
    __weather_station = WeatherStation(appId)

    ## Getter und Setter für delimiter
    @property
    def delimiter_value(self):
        return self.__delimiter

    @delimiter_value.setter
    def delimiter_value(self, value):
        self.__delimiter = value

    ## delimiter kann in initializer geändert werden
    def __init__(self, delimiter="|", only_log_changes=True):
        self.__delimiter = delimiter
        self.__only_log_changes = only_log_changes

    ## Daten von Benutzer anfordern.
    def __get_user_input(self):
        weather_station_user_input_valid = False
        while not weather_station_user_input_valid:

            ## get location from user
            location = input(
                "Für welche Ortschaft sollen die Wetterdaten erfasst werden? "
            )

            ## get unittype to use from user
            unit_type = input(
                "Welche Einheiten sollen benutzt werden? [standard | metric | imperial]"
            )

            ## get language to use from user
            language = input(
                "Welche Sprache soll verwendet werden für die Daten? [de (Deutsch), el (Greek), en (English), fr (French), hr (Croatian), it (Italien)]"
            )

            ## testet, ob die API mit angegebenen daten positiv antwortet
            try:
                new_weather_station = WeatherStation(
                    appId, location, language, unit_type
                )
                new_weather_station.get_weather()

                ## wenn kein Fehler entsteht, kann die Station als variable für die Klasse gesetzt werden
                self.__weather_station = new_weather_station
                weather_station_user_input_valid = True

            except Exception as ex:
                continue_input = input(
                    f'Eingegebene Daten konnten nicht abgefragt werden. Geben sie die Daten noch mal ein oder "q" zum Beenden.:\n{ex}'
                )
                if continue_input == "q":
                    quit()

        ## Interval festlegen
        interval_user_input_valie = False

        while not interval_user_input_valie:
            polling_invterval_input = input(
                "In welchem Zeitabstand (Sekunden) sollen die Daten abgefragt werden?"
            )

            try:
                self.__polling_interval = int(polling_invterval_input)
                interval_user_input_valie = True

            except:
                continue_input = input(
                    'Eingegebenes Interval konnte nicht in Integer gewandelt werden. Nochmal versuchen (enter) oder "q" zum Beenden.'
                )
                if continue_input == "q":
                    quit()

        ## log file name anfragen
        self.__logfile_name = (
            input("Wo sollen die Daten abgespeichert werden? (log.txt)") or "log.txt"
        )

    ## Header erzeugen aus wetterstation daten
    def get_header_string(self):
        delim = self.__delimiter
        file_name = self.__logfile_name

        lon = self.__weather_station.lon_value
        lat = self.__weather_station.lat_value
        location = self.__weather_station.location_value

        first_line = f"# <MetaData><StartTime>{get_timestamp()}</StartTime><FileName>{file_name}</FileName><location>{location}</location><lon>{lon}</lon><lat>{lat}</lat></MetaData>"
        table_header = f"LogLevel {delim} Timestamp {delim} Location {delim} Temp {delim} Wind {delim} Description"

        return f"{first_line}\n{table_header}"

    ## json string in Zeile umwandeln für log Eintrag
    def convert_to_loggable_string(self, data):
        delim = self.__delimiter
        location = data["location"]
        temperature = data["temperature"]["value"]
        temp_unit = data["temperature"]["unit"]
        wind = data["wind"]["velocity"]["value"]
        wind_unit = data["wind"]["velocity"]["unit"]
        weather_description = data["description"]

        converted_entry = f"{location} {delim} {temperature} {temp_unit} {delim} {wind} {wind_unit} {delim} {weather_description}"
        return converted_entry

    ## Hauptanwendung CLI
    def StartWeatherAppCli(self):
        ## Daten von User abfragen
        self.__get_user_input()

        ## compile header
        header = self.get_header_string()

        ## Logger anlegen
        self.__logger = MiniLogger(self.__logfile_name, header, "30", self.__delimiter)

        ## start loop
        app_running = True
        cached_data = ""

        while app_running:
            new_data = self.__weather_station.get_weather()
            ### print weather on every interval
            print(new_data)

            ### convert data and print
            converted_data = self.convert_to_loggable_string(new_data)
            print(converted_data)

            ## log based on preference
            if self.__only_log_changes and cached_data != new_data:
                self.__logger.log(converted_data, 1)

            elif not self.__only_log_changes:
                self.__logger.log(converted_data, 1)

            cached_data = new_data
            sleep(self.__polling_interval)


## UnitTests werden ausgeführt, wenn app mit '-t' flag aufgerufen wurde
def run_tests():
    ### Wetterstation Tests ###

    ## testet fehler, wenn request nicht funktioniert hat
    faulty_weather_station = WeatherStation(appId, "aksjhdflkahsncflzu")
    try:
        faulty_weather_station.get_weather()
    except ConnectionError as ce:
        print(
            f"OK: Angabe falscher Ortschaft erzeugt Fehlermeldung in WeatherStation-Klasse. Fehlernachricht: {ce}"
        )

    ### Logger Tests ###
    ## Logger erstellen und schauen, of file vorhanden ist.
    random_guid = uuid.uuid4()
    test_log_file_path = f"test_log_{random_guid}.txt"

    logger_1 = MiniLogger(test_log_file_path)
    try:
        file = open(test_log_file_path)
        print(
            f"OK: Konnte logfile: {test_log_file_path} finden nach erzeugen der Logger Klasse"
        )
        file.close()
        os.remove(test_log_file_path)  ## entfernen nach test um aufzuräumen
    except:
        print(
            f"NOK: Konnte logfile: {test_log_file_path} nicht finden nach erzeugen der Logger Klasse: "
        )


## CLI Programm wird nur ausgeführt, wenn diese Datei als Main ausgeführt wird
if __name__ == "__main__":
    from sys import argv

    ## does run tests, when -t flag passed in cli args
    if "-t" in argv:
        print("running tests")
        run_tests()

    ## does not run app, when -o flag was passed with cli args
    if "-o" in argv:
        print("closing application without running cli app")
        quit()

    print("Starting Weather App CLI")
    app = CliApplication(only_log_changes=True)
    app.StartWeatherAppCli()
