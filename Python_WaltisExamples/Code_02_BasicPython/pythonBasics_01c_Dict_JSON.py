#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_01c_Dict_JSON.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01c_Dict_JSON.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import json

# see https://realpython.com/python-json/

# Serialization: dictonary to JSON-String
data = {
    "president": {
        "name": "Zaphod Beeblebrox",
        "species": "Betelgeusian"
    }
}

with open("data_file.json", "w") as write_file:
    json.dump(data, write_file, indent=4)

# Deserialization: JSON-String to dictonary
json_string = """
{
    "researcher": {
        "name": "Ford Prefect",
        "species": "Betelgeusian",
        "relatives": [
            {
                "name": "Zaphod Beeblebrox",
                "species": "Betelgeusian"
            }
        ]
    }
}
"""

data = json.loads(json_string)
print("data from JSON-String:", data)


with open("data_file.json", "r") as read_file:
    data = json.load(read_file)
print("data from File:", data)
