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

url_str = "https://api.openweathermap.org/data/2.5/weather?q=Wangen+SZ&units=metric&lang=de&appid=144747fd356c86e7926ca91ce78ce170"

responseStr = requests.get(url_str)
print(responseStr.text)

print("\n\nParses the response String and converts it to a JSON structutre (Dict-List-Dict...)")
responseStr = responseStr.text
jsonResponse = json.loads(responseStr)

print("Show single fields!")
print("   Ortsname:", jsonResponse['name'])
print("   Land:", jsonResponse['sys']['country'])
print("   Temp:", jsonResponse['main']['temp'])
