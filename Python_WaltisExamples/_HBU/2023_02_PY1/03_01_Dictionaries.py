#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 03_01_Dictonaries.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_PY1/03_01_Dictonaries.py
#
# Description: Beispiele mit Dictornaries
#
# Autor: Walter Rothlin
#
# History:
# 20-Sep-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

capitols = {
    'Schweiz': 'Bern',
    'Deutschland': 'Berlin'
}

capitols['Italien'] = 'Rom'
capitols['Italien'] = 'Roma'

print(capitols['Deutschland'], len(capitols))

for aKey in capitols:
    print('  --> ', aKey, capitols[aKey])
    

key_liste = capitols.keys()
print(key_liste)

for aValue in capitols.values():
    print('  --> ', aValue)


print('\n\n\nVerschachtelte Dicts')
countries = {
    'Schweiz': {'Hauptstadt': 'Bern', 'Population': 8500000, 'currencies':['Rappen', 'Franken']},
    'Deutschland': {'Hauptstadt': 'Berlin', 'Population': 85000000},
    'Italien': {'Hauptstadt': 'Rom', 'Population': 60000000},
}

print(countries)
details_from_germany = countries['Deutschland']
print(details_from_germany['Hauptstadt'], countries['Deutschland']['Population'])

print(countries['Schweiz']['currencies'][1])

for a_country in countries:
    if 'currencies' in countries[a_country]:
        print(a_country, countries[a_country]['currencies'][1])
    else:
        print(a_country, 'Kene Währung definiert')