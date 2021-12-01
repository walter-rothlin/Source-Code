# Name:         Daniela_Todaro_A19_DS.py
#
# Description:  Leistungsnachweis 5.Semester -> Klasse Wetterstation
#
# Autor:        Daniela Todaro
#
# History:
# 19-Nov-2021	Initial Version of Methods created and tested
# 20-Nov-2021   Main Class created and tested
#               https://app.genmymodel.com/api/projects/_yJNakEq8Eeyzq6ra3GZCdA/diagrams/_yJOBoEq8Eeyzq6ra3GZCdA/svg
# 21-Nov-2021   Main CLass recreated and tested
# 22-Nov-2021   Class Diagram with GenMyModel recreated
# 21-Nov-2021   Check Errors
#
#
# Sources Declaration:
# https://github.com/GuiFernandess7/OpenWeather-API/blob/master/main.py
# https://github.com/ii-Python/iiWeather/blob/master/weather.py
# https://github.com/Keith-Howard/Weather-Data/blob/main/main.py
# ------------------------------------------------------------------------------------------------------------

import datetime
import requests
from waltisLibrary import *
import webbrowser
import time
import pprint
# import json

appID = "2ae7d5d1d217953562e1dfca8462523d"

class Wetterstation:
    webbrowser.open(
      "https://app.genmymodel.com/api/projects/_kH1CQEuzEeyzq6ra3GZCdA/diagrams/_kH1pUkuzEeyzq6ra3GZCdA/svg")

    def __init__(self, appID=None, url=None):
        self.__appID = appID
        self.__url = url

    #def __str__(self, sep="/"):
    #   return str(self.__appID) + sep + str(self.__url)

    def __str__(self, sep="/"):
        characterization = "appID: {0}" + sep + "url: {1}".format(self.__appID, self.__url)
        return characterization

    def __eq__(self, other):
        return True if self.__appID == other.appID else False

    def getWeatherRequest(self, user_input, location):
        if user_input == 1:
            response = requests.get('http://api.openweathermap.org/data/2.5/weather?q=' + location[0] +
                                    '&appid=' + appID + "&units=metric&lang=de")
        else:
            response = requests.get('http://api.openweathermap.org/data/2.5/weather?zip=' + str(location[0]) +
                                    ',' + str(location[1]) + '&appid=' + appID + "&units=metric&lang=de")
        return response.json()

    def getWeatherData(self, get_request):
        json_data = get_request
        if str(json_data["cod"]) == "200":  # 200 = request was successful
            main_key = json_data["main"]
            temperature = main_key["temp"]
            wind_key = json_data["wind"]
            wind = wind_key["speed"]
            sun_key = json_data["sys"]
            sunrise = sun_key["sunrise"]
            sunset = sun_key["sunset"]
            weather_key = json_data["weather"]
            description = weather_key[0]["description"]
            # pprint.pprint(json_data)

            print("\n 📌 Ihre Auswahl = " + json_data["name"].upper() +
                  "\n 🌡️ Die Temperatur beträgt " +
                  str(temperature) + "°C" +
                  "\n 🌪 Der Wind weht " +
                  str(wind) + " m/s" +
                  "\n ⛅ Die Sonne geht um " +
                  str(datetime.datetime.utcfromtimestamp(sunrise).strftime('%H:%M')) + " auf"
                  "\n ☁ Die Sonne geht um " +
                  str(datetime.datetime.utcfromtimestamp(sunset).strftime('%H:%M')) + " unter"
                  "\n 🌞 Das Wetter ist heute: " +
                  str(description))
            time.sleep(1)
            print("\n Danke, und einen schönen Tag noch!")
        else:
            print(json_data["message"])  # city not found -> cod: "404"


"""
# Testing Class Wetterstation
if __name__ == '__main__':
    print(unterstreichen("Automated Test-Cases from Class-Wetterstation"))

    # Test Ctr and toString()
    test = Wetterstation()
    print(test)
    print(test.__str__(sep="-"))
    print(Wetterstation(appID))

    # Test business methods
    test = Wetterstation()
    print(test.getWind)

    # import doctest
    # doctest.testmod()
    
def main():
    Wetter = Wetterstation("51556", "https://wetter.ch")
    print(str(Wetter))
    characterization = str(Wetter)
"""

# =============
# HAUPTPROGRAMM
# =============
def main():
    print(unterstreichen("\n📅 WELCOME TO THE WEATHER FORECASTER 🌥️ ☔"))
    time.sleep(1)
    request_data = []
    user_choice = int(float(input('Geben Sie [1] für Stadteingabe, oder [2] für Zip Code ein: ')))
    info = Wetterstation()

    if user_choice == 1:
        request_data.append(input('Geben Sie die gewünschte Ortschaft ein: '))
        return info.getWeatherData(info.getWeatherRequest(user_choice, request_data))
    elif user_choice == 2:
        request_data.append(input('Geben Sie den gewünschten Zip Code ein: '))
        request_data.append(input('Geben Sie die ersten zwei Buchstaben des gesuchten Landes ein: '))
        return info.getWeatherData(info.getWeatherRequest(user_choice, request_data))
    else:
        print("Ihre Eingabe ist nicht korrekt!")


if __name__ == '__main__':
    main()


