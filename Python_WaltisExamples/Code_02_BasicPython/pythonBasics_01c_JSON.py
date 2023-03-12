#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_01c_JSON.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01c_JSON.py
#
# Description: Examples for JSON (Dicts / List)
#
# Autor: Walter Rothlin
#
# History:
# 12-Mar-2023   Walter Rothlin      Initial Version ()
# ------------------------------------------------------------------

import json
import requests

print('JSON String von File lesen')
print('==========================')
f = open('../../DatenFiles/JSON/response_weather_1.json', 'r', encoding='utf-8')
fileContent = f.read()  # filecontent ist eine Liste von Zeilen mit \n am Schluss
f.close()
print('fileContent:', fileContent)
print("fileContent.loaded json:", json.loads(fileContent))
print("fileContent.loaded json['weather'][0]:", json.loads(fileContent)['weather'][0])
print()

print('JSON String von REST Response lesen')
print('===================================')
response = requests.get("https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/DatenFiles/JSON/response_weather_1.json")
print("response.url:", response.url)
print("response.status_code:", response.status_code)
print("response.text:", response.text)
print("response.loaded json:", json.loads(response.text))
print("response.loaded json['weather'][0]:", json.loads(response.text)['weather'][0])
print()

print('String als JSON Struktur')
print('========================')
repsonse_weather_1_jsonStr = '{"coord":{"lon":8.895,"lat":47.1908},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"base":"stations","main":{"temp":280.33,"feels_like":279.78,"temp_min":277.28,"temp_max":282.6,"pressure":1015,"humidity":69},"visibility":8649,"wind":{"speed":1.34,"deg":74,"gust":2.24},"clouds":{"all":95},"dt":1678616883,"sys":{"type":2,"id":2006037,"country":"CH","sunrise":1678599864,"sunset":1678641862},"timezone":3600,"id":2658054,"name":"Wangen","cod":200}'
print("repsonse_weather_1_jsonStr        :", repsonse_weather_1_jsonStr)
print()

print('String in eine DICT-LIST Python Struktur umwandeln und auf Elemente zugreifen')
print('=============================================================================')
repsonse_weather_1_json = json.loads(repsonse_weather_1_jsonStr)
print("repsonse_weather_1_json        :", repsonse_weather_1_json)
print("repsonse_weather_1_json['weather'][0]        :", repsonse_weather_1_json['weather'][0])
print()

print('JSON-String formatieren')
print('=======================')
repsonse_weather_1_jsonStr_Formated = json.dumps(repsonse_weather_1_json, indent=4)
print("repsonse_weather_1_jsonStr_Formated:\n", repsonse_weather_1_jsonStr_Formated)

print('Formatierter JSON-String in eine DICT-LIST Python Struktur umwandeln und auf Elemente zugreifen')
print('===============================================================================================')
repsonse_weather_1_json = json.loads(repsonse_weather_1_jsonStr_Formated)
print("repsonse_weather_1_json        :", repsonse_weather_1_json)
print("repsonse_weather_1_json['weather'][0]        :", repsonse_weather_1_json['weather'][0])
print()