#!/usr/bin/python

import json
import requests
import time
import datetime
from urllib.parse import quote


def get_timestamp():
    formatStr = '{:%Y-%m-%d %H:%M:%S}'
    return formatStr.format(datetime.datetime.now())


def limit_lines_in_logfile(filename, max_lines=10):
    print(f"limit_lines_in_logfile({filename}, {max_lines})")
    with open(filename, "r", encoding="utf-8") as datei:
        log_zeilen = datei.readlines()
        print(log_zeilen)


log_always = True
logFilename = "weatherLog.txt"
sep = "|"
waltis_app_id = '144747fd356c86e7926ca91ce78ce170'

polling_time = float(input('Polling Time [s]:'))

ort_wetterstation = input("Ort: ")
if ort_wetterstation == '':
    ort_wetterstation = 'Wangen SZ'
# ort_wetterstation = quote(ort_wetterstation)
print(f'ort_wetterstation: {ort_wetterstation}')

languages = ['de', 'el', 'en', 'fr', 'hr', 'it']
language = input(f'Sprache : {languages}:') or languages[0]
while language not in languages:
    language = input(f'ERROR: Sprache : {languages}') or 'de'

possible_units = ['standard', 'metric', 'imperial']
units = input(f'Einheiten: {possible_units}:') or possible_units[0]
while units not in possible_units:
    units = input(f'ERROR: Einheiten: {possible_units}')

url_end_point = 'https://api.openweathermap.org/data/2.5/weather'

params_end_point = {
    'q': ort_wetterstation,
    'units': units,
    'lang': language,
    'appid': waltis_app_id,
}

temp_einheit = 'K'
if units == 'metric':
    temp_einheit = '°C'
elif units == 'imperial':
    temp_einheit = '°F'

print(params_end_point)

response = requests.get(url_end_point, params=params_end_point)
response_daten = response.json()
print(f"{response_daten['cod']}: {response_daten.get('message', 'OK')}")
weather_json = json.loads(response.text)

fHandler = open(logFilename, "w")
comment = f"# {get_timestamp()}: {ort_wetterstation} ({weather_json['coord']['lon']} / {weather_json['coord']['lat']}), {units}, {language}"
fHandler.write(comment + '\n')
header = f"Timestamp          {sep}Temp     {sep}Einheit_Temp{sep}Druck{sep}Einheit_Druck{sep}Feuchtigkeit{sep}Einheit_Feuchtigkeit{sep}Bezeichnung{sep}Beschreibung"
fHandler.write(header + '\n')
fHandler.close()

doLoop = False
if response.status_code == 200:
    # print(response.text)

    weather_json = json.loads(response.text)
    print(weather_json)
    ## print(f"coordinates: ({weather_json['coord']['lon']} / {weather_json['coord']['lat']})")
    doLoop = True
elif response.status_code == 404:
    print(f"ERROR: Der Ort '{ort_wetterstation}' wurde nicht gefunden.")

else:
    print(f"ERROR: HTTP {response.status_code}: {response_daten.get('message', 'OK')}")

logStrOld = ''
while doLoop:
    response = requests.get(url_end_point, params=params_end_point)
    if response.status_code == 200:
        weather_json = json.loads(response.text)

        temp = weather_json['main']['temp']
        pressure = weather_json['main']['pressure']
        humidity = weather_json['main']['humidity']
        bezeichnung = weather_json['weather'][0]['main']
        beschreibung = weather_json['weather'][0]['description']

        # print(weather_json)
        logStr = f"{sep}{temp:9.2f}{sep}{temp_einheit}{sep}{pressure}{sep}mBar{sep}{humidity}{sep}%{sep}{bezeichnung}{sep}{beschreibung}"
        if log_always or logStr != logStrOld:
            print(f"\n{get_timestamp()}:{logStr}")
            fHandler = open(logFilename, "a")
            fHandler.write(f'{get_timestamp()}{logStr}\n')
            fHandler.close()
            logStrOld = logStr
        else:
            print('.', end='', flush=True)

        limit_lines_in_logfile(logFilename, max_lines=5)
        time.sleep(polling_time)
    else:
        doLoop = False