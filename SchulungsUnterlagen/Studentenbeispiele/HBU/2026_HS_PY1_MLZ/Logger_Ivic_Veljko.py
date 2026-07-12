#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Logger_Ivic_Veljko.py
#
# Beschreibung: Eigene Logger-Klasse, die Log-Einträge strukturiert
#               in ein Text-File schreibt. Zum Testen dient die
#               CLI-App WeatherApp am Ende der Datei (Wetter-Logger).
#
# Autor: Veljko Ivic
# ------------------------------------------------------------------

import datetime
import os
import json
import requests
import threading
from enum import Enum


class LogLevel(Enum):
    """Erlaubte Log-Level als benannte Konstanten (Enum).

    Vorteil: nur ein definierter Wert möglich -> Tippfehler wie 'IFNO'
    fallen sofort auf. Der Text (z.B. 'INFO') ist der Wert im Log-File.
    """
    DEBUG = 'DEBUG'
    INFO = 'INFO'
    WARNINGS = 'WARNINGS'
    ERROR = 'ERROR'
    CRITICAL = 'CRITICAL'


class Strategy(Enum):
    """Aufzeichnungs-Strategie: wann wird geloggt?

    - FIXED_SLICES: immer loggen (jeder Messzyklus eine Zeile)
    - ONLY_CHANGES: nur bei geänderten Werten gegenüber letztem Eintrag
    """
    FIXED_SLICES = 'Fixed Slices'
    ONLY_CHANGES = 'OnlyChanges'


class Logger:
    """Logger-Klasse: schreibt Log-Einträge strukturiert in ein Text-File.

    - Zeitstempel-Format als Property (umstellbar)
    - Konstruktor: neue Datei oder an bestehende anhängen
    - Header aus 2 Zeilen (XML-Kommentar + Titelzeile)
    - log(): Zeile mit Zeitstempel, Level und Werten
    - Delimiter, Dateiname, Pfad, max_entries, strategy als Properties
    - Scrollen: bei gesetztem max_entries alte Zeilen löschen
    - Strategie: FIXED_SLICES (immer) oder ONLY_CHANGES (nur bei Änderung)
    """

    def __init__(self,
                 file_name='log.txt',
                 file_path='.',
                 columns=None,
                 append=False,
                 max_entries=None,
                 strategy=Strategy.FIXED_SLICES,
                 delimiter=',',
                 time_format='%Y-%m-%d %H:%M:%S'):
        # Einstellungen als "private" Attribute speichern (_-Konvention)
        self._file_name = file_name
        self._file_path = file_path
        self._delimiter = delimiter
        self._time_format = time_format
        self._append = append
        # None = kein Limit -> kein Scrollen
        self._max_entries = max_entries
        self._strategy = strategy
        # zuletzt geloggte Werte merken (für ONLY_CHANGES)
        self._last_values = None

        # Spaltennamen der Datenspalten (ohne Timestamp/Level)
        # Default: leere Liste (nie über None iterieren)
        self._columns = columns if columns is not None else []

        # Start-Zeit = jetzt (Beginn des Loggens)
        self._start_time = self.get_timestamp()

        # Anhängen an bestehendes, nicht-leeres File -> Header existiert schon
        # Sonst (neues File): Header neu schreiben
        if not (self._append and self._file_has_content()):
            self._write_header()

    # --- Hilfsmethoden -------------------------------------------------

    def _full_path(self):
        # Pfad + Dateiname zu komplettem Pfad zusammensetzen
        return os.path.join(self._file_path, self._file_name)

    def _file_has_content(self):
        # True, wenn Datei existiert und nicht leer
        full = self._full_path()
        return os.path.exists(full) and os.path.getsize(full) > 0

    def _write_header(self):
        # 2 Kopfzeilen in NEUE Datei schreiben ('w' überschreibt)
        # Zeile 1: Kommentar (#) in XML-Syntax: Dateiname + Start-Zeit
        comment_line = ('# <LogInfo FileName="' + self._file_name +
                        '" StartTime="' + self._start_time + '"/>')
        # Zeile 2: Titelzeile = feste Spalten + Datenspalten (Delimiter-getrennt)
        title_line = self._delimiter.join(['Timestamp', 'Level'] + self._columns)

        with open(self._full_path(), 'w') as f:
            f.write(comment_line + '\n')
            f.write(title_line + '\n')

    def _scroll(self):
        # Scrollen: 2 Kopfzeilen + nur jüngste max_entries Datenzeilen behalten,
        # ältere Einträge löschen
        if self._max_entries is None:
            return  # kein Limit -> nichts tun

        with open(self._full_path(), 'r') as f:
            lines = f.readlines()

        header = lines[:2]    # 2 Kopfzeilen bleiben erhalten
        data = lines[2:]      # alle Datenzeilen

        if len(data) > self._max_entries:
            data = data[-self._max_entries:]  # nur die jüngsten behalten
            with open(self._full_path(), 'w') as f:
                f.writelines(header + data)

    # --- Loggen --------------------------------------------------------

    def log(self, level, *values):
        # ONLY_CHANGES: nur bei geänderten Werten gegenüber letztem Eintrag
        if self._strategy == Strategy.ONLY_CHANGES and values == self._last_values:
            return  # gleiche Werte -> nichts tun

        # Log-Zeile bauen: Zeitstempel, Level, Werte
        # Werte kommen schon gerundet/formatiert aus der App
        parts = [self.get_timestamp(), level.value] + [str(v) for v in values]
        line = self._delimiter.join(parts)

        with open(self._full_path(), 'a') as f:
            f.write(line + '\n')

        # Werte für nächsten Vergleich merken, dann ggf. scrollen
        self._last_values = values
        self._scroll()

    # --- Properties (Getter/Setter) -----------------------------------

    @property
    def delimiter(self):
        return self._delimiter

    @delimiter.setter
    def delimiter(self, new_delimiter):
        # Setter prüft: leeres Trennzeichen würde Spalten zusammenkleben -> verbieten
        if not isinstance(new_delimiter, str) or new_delimiter == '':
            raise ValueError('Delimiter muss ein nicht-leerer Text sein.')
        self._delimiter = new_delimiter

    @property
    def max_entries(self):
        return self._max_entries

    @max_entries.setter
    def max_entries(self, value):
        # None = kein Limit, sonst positive Ganzzahl
        if value is not None and (not isinstance(value, int) or value < 1):
            raise ValueError('max_entries muss None oder eine positive Ganzzahl sein.')
        self._max_entries = value

    @property
    def strategy(self):
        return self._strategy

    @strategy.setter
    def strategy(self, new_strategy):
        # nur definierte Strategien erlauben
        if not isinstance(new_strategy, Strategy):
            raise ValueError('strategy muss ein Strategy-Enum sein.')
        self._strategy = new_strategy

    @property
    def file_path(self):
        return self._file_path

    @file_path.setter
    def file_path(self, new_path):
        self._file_path = new_path

    @property
    def file_name(self):
        return self._file_name

    @file_name.setter
    def file_name(self, new_name):
        self._file_name = new_name

    @property
    def time_format(self):
        # Getter: aktuelles Zeitstempel-Format
        return self._time_format

    @time_format.setter
    def time_format(self, new_format):
        # Setter: Format nachträglich änderbar
        self._time_format = new_format

    def get_timestamp(self):
        # aktueller Zeitstempel im eingestellten Format
        return datetime.datetime.now().strftime(self._time_format)


class WeatherApp:
    """CLI-App: holt Wetterdaten von einer REST-API (JSON) und schreibt
    sie über die Logger-Klasse in ein File.

    - Argumente/Properties: sample_time und url
    - Runden/Formatieren der Zahlen passiert HIER (ausserhalb des Loggers)
    - Logger bekommt nur fertige Strings
    """

    def __init__(self, url, sample_time, location, app_id,
                 language='de', logger=None):
        self._url = url
        self.sample_time = sample_time   # über Setter -> wird geprüft
        self._location = location
        self._app_id = app_id
        self._language = language

        # kein Logger übergeben -> Standard-Logger bauen
        # (Dependency Injection: im Test eigener Logger einsetzbar)
        self._logger = logger if logger is not None else Logger(
            file_name='weatherLog.txt',
            columns=['Temp [C]', 'Druck [hPa]', 'Feuchte [%]', 'Wetter'])

    # --- Properties (Argumente der App) -------------------------------

    @property
    def url(self):
        return self._url

    @url.setter
    def url(self, new_url):
        self._url = new_url

    @property
    def sample_time(self):
        return self._sample_time

    @sample_time.setter
    def sample_time(self, seconds):
        # Sample-Time = Polling-Intervall, muss positiv sein
        if not isinstance(seconds, (int, float)) or seconds <= 0:
            raise ValueError('sample_time muss eine positive Zahl (Sekunden) sein.')
        self._sample_time = seconds

    # --- REST-Call ----------------------------------------------------

    def fetch_weather(self):
        # aktuelle Wetterdaten holen, Rohwerte zurückgeben
        params = {
            'q': self._location,
            'appid': self._app_id,
            'units': 'metric',
            'lang': self._language,
        }
        response = requests.get(self._url, params=params)
        data = json.loads(response.text)

        # keine Wetterdaten (falscher Key/Ort) -> 'main' fehlt
        # Grund steht in 'cod'/'message' -> klar melden
        if 'main' not in data:
            raise RuntimeError('API-Fehler ' + str(data.get('cod', '?')) +
                               ': ' + str(data.get('message', 'keine Wetterdaten')))

        # interessante Rohwerte herausziehen
        temp = data['main']['temp']
        pressure = data['main']['pressure']
        humidity = data['main']['humidity']
        description = data['weather'][0]['description']
        return temp, pressure, humidity, description

    # --- Eine Messung aufbereiten und loggen --------------------------

    def log_once(self, temp, pressure, humidity, description):
        # Runden/Formatieren ausserhalb des Loggers:
        temp_str = format(round(float(temp), 1), '.1f')  # Float -> 1 Nachkommastelle
        pressure_str = str(int(pressure))                # als Ganzzahl
        humidity_str = str(int(humidity))                # als Ganzzahl

        # Logger bekommt nur fertige Strings
        self._logger.log(LogLevel.INFO, temp_str, pressure_str, humidity_str, description)

    # --- Hauptschleife ------------------------------------------------

    def run(self):
        # Polling-Schleife; Stopp per Enter (Hintergrund-Thread)
        print('\nStarte Wetter-Logger (Enter zum Beenden) ...')
        print('\ngeloggt: Temp[C]  Druck[hPa]  Feuchte[%]  Wetter')

        # Stopp-Signal; Thread wartet auf Enter und setzt es
        stop = threading.Event()

        def warte_auf_enter():
            input()        # blockiert, bis Enter gedrückt wird
            stop.set()     # Signal: Schleife soll stoppen

        threading.Thread(target=warte_auf_enter, daemon=True).start()

        while not stop.is_set():
            try:
                temp, pressure, humidity, description = self.fetch_weather()
                self.log_once(temp, pressure, humidity, description)
                print('geloggt:', temp, pressure, humidity, description)
            except Exception as fehler:
                # bei Problem (kein Netz/falscher Key): ERROR loggen, weiterlaufen
                self._logger.log(LogLevel.ERROR, 'Abruf fehlgeschlagen: ' + str(fehler))
                print('Fehler:', fehler)
            # wartet sample_time Sekunden, bricht bei Enter sofort ab
            stop.wait(self._sample_time)

        print('\nLogger gestoppt.')


# ------------------------------------------------------------------
# CLI-Applikation: Testprogramm (Wetter-Logger).
# Läuft nur beim direkten Start dieser Datei, nicht beim Import.
# ------------------------------------------------------------------
if __name__ == '__main__':
    URL = 'http://api.openweathermap.org/data/2.5/weather'
    APP_ID = '144747fd356c86e7926ca91ce78ce170'   # <- eigene App-ID eintragen

    # nur das Nötigste abfragen, mit Defaults (einfach testbar)
    location = input('Ort [Tokyo]            : ') or 'Tokyo'
    sample_time = float(input('Sample-Time in Sekunden [60]: ') or '60')

    app = WeatherApp(url=URL, sample_time=sample_time,
                     location=location, app_id=APP_ID)
    app.run()
