# ------------------------------------------------------------------
# Name  : 04_REST_Call.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2024/TI23_BLeM/04_REST_Call.py
#
# Description: Polling REST Service and write values to console
# https://openweathermap.org/current
#
# Autor: Walter Rothlin
#
# History:
# 12-Jun-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import requests
import json
import time
import datetime

url_endpoint = "https://api.openweathermap.org/data/2.5/weather"
units = "metric"
lang = "de"
appid = "144747fd356c86e7926ca91ce78ce170"

ort = input('Ort:')

header = f'''
Ort:  {ort}
+-------------------+-----------------+--------------+--------------+----------------------+-------------------+
| Timestamp         | Temperatur [°C] | Druck [mBar] | Feuchtigkeit | Text                 |
+-------------------+-----------------+--------------+--------------+----------------------+-------------------+
'''

old_log_entry = ''
open('Wetter_Daten.txt', 'w').write(header)
do_loop = True
while do_loop:
    url_request = f"{url_endpoint}?q={ort}&units={units}&lang={lang}&appid={appid}"

    response = requests.get(url_request)
    jsonResponse = json.loads(response.text)

    if response.status_code >= 400:
        print(f"Error: {jsonResponse}")
        break

    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']

    # log_entry = f"({jsonResponse['coord']['lon']}/{jsonResponse['coord']['lat']}): "
    log_entry = ''
    log_entry += f"{temp}°C   {pressure}mBar   {humidity}%  "
    log_entry += f"{jsonResponse['weather'][0]['main']} --> {jsonResponse['weather'][0]['description']} "

    if old_log_entry != log_entry:
        log_entry_full = f'|{datetime.datetime.now():%Y-%m-%d %H:%M:%S}|{log_entry}|'
        print(log_entry_full)
        open('Wetter_Daten.txt', 'a').write(log_entry_full + '\n')
        old_log_entry = log_entry
    else:
        print('.', end='', flush=True)

    time.sleep(5)

