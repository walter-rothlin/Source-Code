#!/usr/bin/python3

##########################
# Name: logger.py
#
# Autor: Rainer Kuster
#
# Datum: 24.10.2022
#
##########################

import json
import requests
from datetime import datetime, date, time, timezone


#test teil

logfile = "./LogFile.txt"
f = open(logfile,"w")
f.write('''Filename = Logfile
Ortname ¦ Land ¦ Temperatur ¦''')
f.write("\n")
print('''Filename = LogFile // Zeitstempel = ''',print(datetime.now(timezone.utc)),'''
Ortsname:    ¦ Land:  ¦ Temperatur''')
doLoop = True
while doLoop:
    url_str = "https://api.openweathermap.org/data/2.5/weather?q=Wetzikon+ZH&units=metric&lang=de&appid=9f7e3ccf2defc497b2d5eef345ceca47" 
    responseStr = requests.get(url_str)
    responseStr = responseStr.text
    jsonResponse = json.loads(responseStr)
    print(jsonResponse['name'],"    ", jsonResponse['sys']['country'],"     ", jsonResponse['main']['temp'])
    Ortsname=str(jsonResponse['name'])
    Land=str(jsonResponse['sys']['country'])
    Temperatur=str(jsonResponse['main']['temp'])
    #f.write(jsonResponse['name'])
    f.write(Ortsname)
    f.write("    ")
    f.write(Land)
    f.write("    ")
    f.write(Temperatur)
    f.write("\n")