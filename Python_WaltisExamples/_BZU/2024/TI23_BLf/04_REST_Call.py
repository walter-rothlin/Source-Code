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
# ------------------------------------------------------------------
import requests
import json
import time
import datetime

url_endpoint = 'https://api.openweathermap.org/data/2.5/weather'
appid = '144747fd356c86e7926ca91ce78ce170'
lang = 'de'
units = 'metric'

ort = input('Ort:')
url_str = f"{url_endpoint}?q={ort}&units={units}&lang={lang}&appid={appid}"


old_temp = 0
old_pressure = 0
old_humidity = 0

do_loop = True
while do_loop:
    responseStr = requests.get(url_str)
    jsonResponse = json.loads(responseStr.text)
    # print(jsonResponse)

    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    if old_temp != temp or old_pressure != pressure or old_humidity != humidity:
        print(f'{datetime.datetime.now():%Y-%m-%d %H:%M:%S}:: ', end='')
        print(f"{ort} ({jsonResponse['coord']['lon']}/{jsonResponse['coord']['lat']}):", end='')
        print(f"{temp}°C  {pressure}mBar  {humidity}%   ", end='')
        print(f"{jsonResponse['weather'][0]['main']} --> {jsonResponse['weather'][0]['description']}")
        old_temp = temp
        old_pressure = pressure
        old_humidity = humidity
    time.sleep(5)
