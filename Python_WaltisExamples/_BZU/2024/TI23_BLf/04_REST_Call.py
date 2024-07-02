# ------------------------------------------------------------------
# Name  : 04_REST_Call.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2024/TI23_BLf/04_REST_Call.py
#
# Description: Polling REST Service and write values to console
# https://openweathermap.org/current
#
# Autor: Walter Rothlin
#
# History:
# 12-Jun-2024   Walter Rothlin      Initial Version
# 27-Jun-2024   Walter Rothlin      Write to file
# ------------------------------------------------------------------
import requests
import json
import time
import datetime

url_endpoint = 'https://api.openweathermap.org/data/2.5/weather'
appid = '144747fd356c86e7926ca91ce78ce170'  # correct
# appid = '144747fd356c86e7926ca91ce78ce166'  # wrong
lang = 'de'
units = 'metric'

ort = input('Ort:')
url_str = f"{url_endpoint}?q={ort}&units={units}&lang={lang}&appid={appid}"


old_log_entry = ''
header_str = f'''

'''
do_loop = True
try:
    while do_loop:
        response = requests.get(url_str)
        jsonResponse = json.loads(response.text)

        if response.status_code >= 400:
            print(f"Error: {jsonResponse}")
            break

        temp = jsonResponse['main']['temp']
        pressure = jsonResponse['main']['pressure']
        humidity = jsonResponse['main']['humidity']

        log_entry = f"{ort} ({jsonResponse['coord']['lon']}/{jsonResponse['coord']['lat']}):"
        log_entry += f"{temp}°C  {pressure}mBar  {humidity}%   "
        log_entry += f"{jsonResponse['weather'][0]['main']} --> {jsonResponse['weather'][0]['description']}\n"
        if old_log_entry != log_entry:
            new_log_entry_full = f'{datetime.datetime.now():%Y-%m-%d %H:%M:%S}:: {log_entry}'
            print(new_log_entry_full, end='')
            open('Wetter_Daten.txt', 'a').write(new_log_entry_full)
            old_log_entry = log_entry
        else:
            print('.', flush=True, end='')

        time.sleep(5)
except KeyboardInterrupt:
    do_loop = False

print('Tschüss!!')
