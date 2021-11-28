#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_01c_Dict.py
#
# Description: Examples for JSON (Dicts / List)
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version ()
# 28-Nov-2021   Walter Rothlin      Added some more specifics
# ------------------------------------------------------------------

import json
import requests


print("10 --------------------------------------------------- 10\n")
print("\n\n----> json string --> json --> json string --> formated json str")
# string must be in ' NOT in "
ampelColors_jsonStr = '''{
       "stop": "red", 
       "go": "green", 
       "maybe": "orange"
       }'''

print("ampelColors_jsonStr        :", ampelColors_jsonStr)

ampelColors_json = json.loads(ampelColors_jsonStr)
ampelColors_json['stop'] = 'ROT'
print("ampelColors_json           :", ampelColors_json)

ampelColors_jsonStr1 = str(ampelColors_json)
print("ampelColors_jsonStr1       :", ampelColors_jsonStr1)

ampelColors_jsonStrFormated = json.dumps(ampelColors_json, indent=4)
print("ampelColors_jsonStrFormated:\n", ampelColors_jsonStrFormated)


print("\n\n----> json string list --> json --> json string --> formated json str")
ampelColorsListStr = '''[
       "red","green","orange"
       ]'''
print("ampelColorsListStr             :", ampelColorsListStr)

ampelColorsList = json.loads(ampelColorsListStr)
ampelColorsList[0] = "RED"
print("ampelColorsList                :", ampelColorsList)

ampelColors_jsonStr1 = str(ampelColorsList)
print("ampelColors_jsonStr1           :", ampelColors_jsonStr1)

ampelColorsList_jsonStrFormated = json.dumps(ampelColorsList, indent=4)
print("ampelColorsList_jsonStrFormated:\n", ampelColorsList_jsonStrFormated)
print("10 --------------------------------------------------- 10\n")


# see https://realpython.com/python-json/

# Original response = requests.get("https://jsonplaceholder.typicode.com/todos")
# response = requests.get("http://hwz.peterliwiese.ch/DatenSaetze/todos.json")
response = requests.get("https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/DatenFiles/JSON/todos_Small.json")
print("response.url:", response.url)
print("response.status_code:", response.status_code)
todos = json.loads(response.text)

# Zugriff auf bestimmte Daten-Elemente
print(todos)
print(todos[0])   # 1.Array-Element (Beginnt mit Element 0)
print(todos[1]["title"])   # Vom 2.Array-Element der Wert mit key "title"
print(todos[2]["completed"])   # Vom 2.Array-Element der Wert mit key "completed"
print(todos[3]["completed"])   # Vom 3.Array-Element der Wert mit key "completed"
if todos[2]["completed"]:
    print("toDo[2] is completed!")
else:
    print("toDo[2] is NOT completed!")
if todos[3]["completed"]:
    print("toDo[3] is completed!")
else:
    print("toDo[3] is NOT completed!")

# Length of array
print(len(todos))

# Alle Keys from Dict
for c in todos[4]:
    print("Key:", c, "    Value:", todos[4][c])
print("\n")
# foreach aToDo in todos:
for i in range(len(todos)):
    print(i, ": ", todos[i])

print("--Sub Listen")
subToDos = todos[4:-1]
print("len(subToDos):", len(subToDos))


response = requests.get("https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/DatenFiles/CSV_Excel/Adressliste.json")
print("response.url:", response.url)
print("response.status_code:", response.status_code)
adressListe = json.loads(response.text)
print(adressListe)
# Alle Keys from Dict
for c in adressListe[4]:
    print("Key:", c, "    Value:", adressListe[4][c])

