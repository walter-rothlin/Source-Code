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

cityRequest = Wetterstation(city,key, 0, lat, lon, cnt)
print(cityRequest.getCitiesByCoordinates())
