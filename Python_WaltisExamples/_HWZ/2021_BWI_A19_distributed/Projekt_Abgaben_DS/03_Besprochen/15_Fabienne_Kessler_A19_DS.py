# ------------------------------------------------------------------
# Name: Fabienne_Kessler_A19_DS.py
#
# Description: Does a search via REST request to openweather (JSON)
#
# Autor: Fabienne Kessler
#
# History:
# 23-Nov-2021   Fabienne Kessler
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + User-Eingaben möglich
#      - Falsche Usereingaben werden nicht behandelt und führen zu einem Absturtz
#      - Nur gerade Temp wird angezeigt
#
# Class Design und Implementation:
#      - Design-Diagramm vorhanden
#      - Notwendige (__init__ __str__ ) Methoden vorhanden, nicht aber __eq__
#      + __init__ alle relevanten Argumente mit funktionierenden Default Werten
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Instance Variablen sind public
#      - Kein Exception Handling in den Methoden verwendet
#      -- base URL ausserhalb der Klasse definiert
#      - in den Methoden wird z.T. nicht über self auf instance variablen zugegriffen
#
# Test:
#      - Keine Tests (positive/negative) implementiert
#
# Note: 4.0
#
# Fragen:
#    Auf welcher Zeile wird der Request zum Web-Service abgesendet?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------

import requests
import json


URL = "http://api.openweathermap.org/data/2.5/"

# API: hhttps://openweathermap.org/current
# API-KEY: wird in der Maske eingegeben: 54df40e238084fbf095d3540271e48a0


class Wetterstation:
    def __init__(self, city, key, units, lat, lon, cnt):
        self.city = city
        self.key = key
        self.units = units
        self.lat = lat
        self.lon = lon
        self.cnt = cnt

    def __str__(self):
        return(str(self.city)+", "+str(self.lat)+", "+str(self.lon))



    def getTemperatureByCity(self):
        if  self.units == "C":
            units = "metric"
            bezunits = "Grad Celsius"
        else:
            units = "imperial"
            bezunits = "Kelvin"
        req = "weather?q="
        fullURL = str(URL+req+self.city+"&units="+units+"&appid="+self.key)
        response = requests.get(fullURL)    # get the response from server --- convert in json file
        jsonResponse = json.loads(response.text)
        temp = jsonResponse["main"]["temp"]

                    #return ("Das aktuelle Wetter in "+city)
        return ("Die aktuelle Temperatur in "+city+" beträgt: "+str(temp)+" "+bezunits)


    def getCitiesByCoordinates(self):
        fullURL = str(URL+"find?lat="+lat+"&lon="+lon+"&cnt="+cnt+"&appid="+self.key)
        data = requests.get(fullURL)    # get the response from server --- convert in json file
        jsonResponse = json.loads(data.text)

        print("Folgende Städte wurden gefunden (Anzahl:{recCount:2d}):".format(recCount=len(jsonResponse['list'])))
        for entry in jsonResponse['list']:

            print("\nName            :", entry['name'])
            print("Land            :", entry["sys"]["country"])
            print("Temperatur (K)  :", entry["main"]["temp"])

#------------------------------------------------------------------------------------

city = input("Stadt:")
key = input("API-KEY:")
units = input("Masseinheit (K oder C):")

weatherRequest = Wetterstation(city, key, units, 0, 0, 0)
print(weatherRequest.getTemperatureByCity())

lat = input("Breitengrade:")
lon = input("Längengrade:")
cnt = input("Anzahl Städte (max. 50):")
key = input("API-KEY:")

cityRequest = Wetterstation(city, key, 0, lat, lon, cnt)
print(cityRequest.getCitiesByCoordinates())
