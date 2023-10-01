#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 03_02_weather_REST.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_PY1/03_02_weather_REST.py
#
# Description: Beispiele eines REST-Calls
#
# Autor: Walter Rothlin
#
# History:
# 20-Sep-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import json
import requests

city_name = input('City:')
if city_name == '':
    city_name = 'Wangen SZ'



url_end_point = "http://api.openweathermap.org/data/2.5/weather"
params_end_point = {
    'q'    : city_name,
    'appid': '144747fd356c86e7926ca91ce78ce170',
    'mode' : '',         # xml, html
    'units': 'metric',   # standard, metric, imperial
}

response = requests.get(url_end_point, params=params_end_point)
print(response, '\n\n')
response_str = response.text
print(response_str, '\n\n')
json_response = json.loads(response_str)
print(json_response)

print('\n\'Show single fields from JSON response!')
print('   Ortsname     :', json_response['name'])
print('   Land         :', json_response['sys']['country'])
print('   Longitude    : ',json_response['coord']['lon'])
print('   Latitude     : ',json_response['coord']['lat'])
print('   Temp         :', json_response['main']['temp'], '°C')
print('   Luftdruck    :', json_response['main']['pressure'], 'mBar')
print('   Feuchtigkeit :', json_response['main']['humidity'], '%')
print('   Text         :', json_response['weather'][0]['main'], json_response['weather'][0]['description'])



