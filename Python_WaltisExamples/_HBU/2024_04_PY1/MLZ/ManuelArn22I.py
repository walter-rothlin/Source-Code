#/usr/bin/env python3
# Filename: ManuelArn22I.py


'''
Bewertung
========
1. Lauffähiger Code abgegeben (2 Punkte)                                                2
2. CLI Applikation schreibt ein Log-File (2 Punkte)                                     2
3. Für den Weather REST Service wurde ein eigener Token verwendet                       1
4. Eine eigene, reusable Klasse mit einfachem Interface implementiert (4 Punkte)        4
5. Nur absolut Notwendiges ist public (2 Punkte)                                        2
6. Kommentare in Form von doc_strings sind enthalten                                    1
7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                                 0 (Als HTML Kommentar)
8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)                            1
9. Log-Entries enthalten formatierten Time-Stamp und Level                              1
9a. Scrolling Strategie implementiert                                                   1
10. Anzahl Zeilen für Scrollbereich definierbar                                         1
11. ChangesOnly implementiert                                                           1
12. Append / New implementiert                                                          1
13. Delimiter via __init__ setzbar (mit Default-Wert)                                   1
14. Strategie via __init__ setzbar (mit Default-Wert)                                   1
15. Scrolling area via __init__ setzbar (mit Default-Wert)                              1
                                                                -------------------------
                                                                Max. Punkte:22         21
                                                                =========================

+ initializer kreiert file
+ sehr guter Design

'''


import time
import requests

class Logger:
    """Eine wiederverwendbare Logger-Klasse für strukturiertes Logging in eine Textdatei."""

    def __init__(self, file_path, delimiter="|", scroll_limit=100, strategy="FixedSlices", append=False, timestamp_format='%Y-%m-%d %H:%M:%S'):
        """
        Initialisiert die Logger-Instanz.

        Parameter:
            file_path (str): Der Pfad zur Logdatei.
            delimiter (str): Der Delimiter, der in der Logdatei verwendet wird. Standard ist '|'.
            scroll_limit (int): Die Anzahl der Einträge, nach denen gescrollt wird. Standard ist 100.
            strategy (str): Die Logging-Strategie ('FixedSlices' oder 'OnlyChanges'). Standard ist 'FixedSlices'.
            append (bool): Ob an die bestehende Logdatei angehängt oder eine neue erstellt wird. Standard ist False.
            timestamp_format (str): Das Format des Zeitstempels. Standard ist '%Y-%m-%d %H:%M:%S'.
        """
        self._file_path = file_path
        self._delimiter = delimiter
        self._scroll_limit = scroll_limit
        self._strategy = strategy
        self._append = append
        self._timestamp_format = timestamp_format

        self._entries = 0
        self._last_message = None  # Für die 'OnlyChanges'-Strategie

        mode = 'a' if self._append else 'w'
        with open(self._file_path, mode) as log_file:
            log_file.write(f"<!-- {self._file_path} {time.strftime(self._timestamp_format)} -->\n")
            log_file.write(f"Timestamp{self._delimiter}Level{self._delimiter}Message\n")

    def log(self, level, message):
        """
        Schreibt einen Logeintrag in die Logdatei.

        Parameter:
            level (str): Das Log-Level ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL').
            message (str): Die Log-Nachricht.
        """
        if self._strategy == "OnlyChanges" and message == self._last_message:
            return  # Nur Änderungen loggen
        self._last_message = message

        timestamp = time.strftime(self._timestamp_format)
        with open(self._file_path, 'a') as log_file:
            log_file.write(f"{timestamp}{self._delimiter}{level}{self._delimiter}{message}\n")
        self._entries += 1
        if self._entries >= self._scroll_limit:
            self._scroll()

    def _scroll(self):
        """Scrollt die Logdatei, indem alte Einträge gelöscht werden, um Platz für neue zu schaffen."""
        with open(self._file_path, 'r') as log_file:
            lines = log_file.readlines()
        header = lines[:3]  # Behalte die Header-Zeilen
        new_logs = lines[-(self._scroll_limit ):]  # Behalte die neuesten Einträge
        with open(self._file_path, 'w') as log_file:
            log_file.writelines(header + new_logs)
        self._entries = len(new_logs)  # Zurücksetzen des Eintragszählers

    # Properties für Setter und Getter

    @property
    def delimiter(self):
        """Gibt den in der Logdatei verwendeten Delimiter zurück."""
        return self._delimiter

    @delimiter.setter
    def delimiter(self, value):
        """Setzt den in der Logdatei verwendeten Delimiter."""
        self._delimiter = value

    @property
    def file_path(self):
        """Gibt den Pfad zur Logdatei zurück."""
        return self._file_path

    @file_path.setter
    def file_path(self, value):
        """Setzt den Pfad zur Logdatei."""
        self._file_path = value

    @property
    def scroll_limit(self):
        """Gibt das Scroll-Limit zurück."""
        return self._scroll_limit

    @scroll_limit.setter
    def scroll_limit(self, value):
        """Setzt das Scroll-Limit."""
        self._scroll_limit = value

    @property
    def strategy(self):
        """Gibt die aktuelle Logging-Strategie zurück."""
        return self._strategy

    @strategy.setter
    def strategy(self, value):
        """Setzt die Logging-Strategie ('FixedSlices' oder 'OnlyChanges')."""
        if value in ["FixedSlices", "OnlyChanges"]:
            self._strategy = value
        else:
            raise ValueError("Strategie muss 'FixedSlices' oder 'OnlyChanges' sein.")

    @property
    def append(self):
        """Gibt zurück, ob an die Logdatei angehängt wird."""
        return self._append

    @append.setter
    def append(self, value):
        """Setzt, ob an die Logdatei angehängt wird."""
        self._append = value

    @property
    def timestamp_format(self):
        """Gibt das Format des Zeitstempels zurück."""
        return self._timestamp_format

    @timestamp_format.setter
    def timestamp_format(self, value):
        """Setzt das Format des Zeitstempels."""
        self._timestamp_format = value

def main():
    """Hauptfunktion für die Wetter-Logging-Applikation."""

    # Einstellungen einlesen (Sample-Time, URL)
    sample_time = float(input("Geben Sie die Abfragezeit in Sekunden ein: "))
    city_name = input("Geben Sie den Stadtnamen für die Wetterabfrage ein: ")
    api_key = input("Bitte geben Sie Ihren OpenWeatherMap API-Schlüssel ein: ")

    # URL für den REST-Call
    url = f"https://api.openweathermap.org/data/2.5/weather?q={city_name}&appid={api_key}&units=metric"

    # Logger initialisieren
    logger = Logger(
        file_path="Manuel_Arn_log.txt",
        delimiter="|",  # Default-Wert
        scroll_limit=30,  # Default-Wert
        strategy="FixedSlices",  # Default-Wert
        append=False  # Kann True oder False sein
    )
    logger.log("INFO", "Wetterdaten-Logging gestartet.")

    # Wiederhole die Abfrage in Intervallen (Sample-Time)
    while True:
        try:
            response = requests.get(url)
            if response.status_code == 200:
                weather_data = response.json()

                # Float- und Integer-Logdaten formatieren und runden
                temperature = round(weather_data['main']['temp'], 2)
                humidity = int(round(weather_data['main']['humidity'], 0))  # Integer-Daten
                wind_speed = round(weather_data['wind']['speed'], 2)
                description = weather_data['weather'][0]['description']

                # Logeintrag schreiben
                logger.log(
                    "INFO",
                    f"Temperatur: {temperature}°C, Luftfeuchtigkeit: {humidity}%, "
                    f"Windgeschwindigkeit: {wind_speed} m/s, Wetter: {description}"
                )
            else:
                logger.log(
                    "ERROR",
                    f"Fehler beim Abrufen der Wetterdaten. HTTP-Statuscode: {response.status_code}"
                )
        except Exception as e:
            logger.log("ERROR", f"Ausnahme aufgetreten: {e}")

        # Wartezeit zwischen den Anfragen (Sample-Time)
        time.sleep(sample_time)

if __name__ == "__main__":
    main()
