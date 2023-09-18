#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 03_01_Dictonaries.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/03_01_Dictonaries.py
#
# Description: Dictonaries Operationen.
#
# Autor: Walter Rothlin
#
# History:
# 18-Sep-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
from waltisMegaLib import *

capitols = {
    'Schweiz': 'Bern',
    'Deutschland': 'Berlin'}

capitols['Italien'] = 'Rom'
capitols['Italien'] = 'Roma'

print(capitols, len(capitols))
print(capitols['Schweiz'])


for aKey in capitols:
    print(aKey,' --> ', capitols[aKey])
    

key_liste = capitols.keys()
print(key_liste)

for aValue in capitols.values():
    print(aValue)
    


print("\n\n\n")
# verschachtelt
# =============

countries = {
    'Schweiz': {'Hauptstadt': 'Bern', 'Population': 8500000, 'currencies':['Rappen', 'Franken']},
    'Deutschland': {'Hauptstadt': 'Berlin', 'Population': 85000000},
    'Italien': {'Hauptstadt': 'Rom', 'Population': 60000000}
}

print(countries)

for a_country in countries:
    if 'currencies' in countries[a_country]:
        print(a_country, countries[a_country]['Hauptstadt'], countries[a_country]['Population'], countries[a_country]['currencies'][1])
    else:
        print(a_country, countries[a_country]['Hauptstadt'], countries[a_country]['Population'])
