#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Marc_Affentranger_A19_DS.py
#
# Description: Implements Console Application to get requested weather information from a specific location
#
# Klassendiagramm: https://fhhwz-my.sharepoint.com/:i:/g/personal/marc_affentranger_student_fh-hwz_ch/EdTZsfYc_XRAgkLwUBMT_CcBuhJ7d0H8_h6FzLBC9l_udA?e=XcoHJt
#
# Autor: Marc Affentranger
#
# History:
# 23-Nov-2021   Marc Affentranger      Initial Version
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und intuitiv zu bedienen
#      + User Eingaben werden geprüft und bei Fehlern kein Absturtz
#      + Output gut formatiert (Tabelle)
#
# Class Design und Implementation:
#      + Sinnvolle und notwendige (__init__, __str__, __eq__) Methoden mit sprechender Signatur funktionieren
#      - __init__ calvinFactor, hourInSeconds unötig und verwirrend
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Methoden sind public
#      - AppID als Parameter in einer Methode (als default Parameter)
#      - Weather Info wird JSON 1:1 übernommen
#      - extractAttributes sollte __ sein und auf self für die response zugreifen
#      - response mit time-stamp abspeichern und als cash verwenden
#
# Test:
#      ++ Testabdeckung und protokollierung (reuse of Tests)
#
# Note: 5.1
#
# Fragen:
#    Was wäre das nächste Refactoring der Klasse?
#    Wo wird der Request zum Web-Service abgesendet?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wie könnte der Design der Klasse in dieser Hinsicht verbessert werden?









# ------------------------------------------------------------------

import json
import unittest
from datetime import datetime, timedelta

import requests


class WeatherStation:

    def __init__(self, location="Zurich", calvinFactor = 273.15, hourInSeconds = 3600, result = "N/A"):
        self.__location = location.lower()
        self.__calvinFactor = calvinFactor
        self.__hourInSeconds = hourInSeconds
        self.__result = result

    def __str__(self):
        return "Folgende Klassenattribute sind vorhanden: (location= {location}    calvinFactor: {calvinFactor}    hourInSeconds: {hourInSeconds}    result= {result}".format(
            location=self.__location, calvinFactor=self.__calvinFactor, hourInSeconds=self.__hourInSeconds,
            result=self.__result)

    def __eq__(self, result):
        if result == self.__result:
            return "Ja das Resultat inkl. Parameter stimmen überein"
        else:
            return "Nein das Resultat stimmt nicht überein"


    """toString: Ausgabe in die Konsole inkl. Formatierung"""
    def toString(self):
        result = self.getResult()
        # Error wird returned falls der Ort nicht gefunden wurde oder
        # es kein gültiges oder überhaupt kein Informationskriterium angegeben wurde
        if list(result)[0] == "error":
            return list(result.values())[0]

        #Output:
        resultString = "Folgend sind die gewünschenten Informationen über die Ortschaft {0}:\n".format(
            self.getLocation().replace("%20", " "))
        resultString += "================================\n"
        resultString += "+-------------------+----------+\n"

        for key in result:
            resultString += "| {0:18s}: {1:8s} |\n".format(key, result[key])

        resultString += "+-------------------+----------+"
        return resultString

    #Getter und Setter Methoden:
    def getResult(self):
        return self.__result

    def setResult(self, result=None):
        self.__result = result

    def getLocation(self):
        return self.__location.capitalize()

    def getCalvinFactor(self):
        return self.__calvinFactor

    def getHourInSeconds(self):
        return self.__hourInSeconds

    def getTemperature(self, response):
        return format(response['main']['temp'] - self.getCalvinFactor(), '.2f')

    def getPressure(self, response):
        return response['main']['pressure']

    def getHumidity(self, response):
        return response['main']['humidity']

    def getSunsetTime(self, response):
        # parse int to utc timestamp
        return datetime.utcfromtimestamp(response['sys']['sunset'])

    def getUtcHourDiff(self, response):
        return response['timezone'] / self.getHourInSeconds()



    """Weather-API Aufruf
    :param List attributeList: gesuchte Informationen des Wetters
    :param String appId: angegebene AppId für die Weather-API
    """
    def getWeatherInfo(self, attributeList = None, appId = "beae7a5a43c4d71bf542db0df9322b88"):
        serviceUrl = "http://api.openweathermap.org/data/2.5/weather?q={search:2s}&APPID={appId:2s}"
        requestStr = serviceUrl.format(search=self.getLocation(), appId=appId)
        responseStr = requests.get(requestStr)
        response = json.loads(responseStr.text)
        self.setResult(self.extractAttributes(response, attributeList))
        return self.toString()


    """Methode um von der Json-Response die gewünschten Informationen auszulesen inkl. Einheit etc.
    :param dict response: enthält die Antwort der Weather-API
    :param List attributeList: gesuchte Informationen des Wetters
    """
    def extractAttributes(self, response = None,  attributeList = None):

        if response == None or str(response).__contains__("city not found"):
            return {"error": "Ortschaft {0} nicht gefunden.".format(self.getLocation().replace("%20", " "))}

        if attributeList == None or attributeList == ['']:
            return {"error": "Kein Informationskriterium vorhanden."}
        else:
            result = {}
            if "temp" in attributeList:
                result["Temperatur"] = "{0} °C".format(self.getTemperature(response))

            if "pressure" in attributeList:
                result["Luftdruck"] = "{0} hPa".format(self.getPressure(response))

            if "humidity" in attributeList:
                result["Luftfeuchtigkeit"] = "{0} %".format(self.getHumidity(response))

            if "sunset" in attributeList:
                time = self.getSunsetTime(response)
                # Adjust time regarding utc hour difference
                time = time + timedelta(hours=(self.getUtcHourDiff(response)))
                result["Sonnenuntergang"] = time.strftime('%H:%M')

            if "timezone" in attributeList:
                utcHourDiff = self.getUtcHourDiff(response)
                symbol = "UTC "
                if utcHourDiff >= 0:
                    symbol += "+"
                result["Zeitzone"] = "{0}{1:.0f}".format(symbol, utcHourDiff)

        if result == {}:
            return {"error": "Kein gueltiges Informationskriterium vorhanden {0}.".format(attributeList)}

        return result


trace = False #set to True for more information logs

while True:
    location = input("Geben Sie an von welchem Ort Sie das Wetter wissen wollen (um Programm beenden drücken Sie enter):")
    if len(location) == 0:
        print("Applikation beendet!")
        break

    locationEncoded = location.replace(" ", "%20")
    weatherStation = WeatherStation(locationEncoded)
    if (trace):
        print(weatherStation.__str__())

    attributeString = input(
        "Geben Sie an welche Informationen Sie interessiert "
        "(Temp, Pressure, Humidity, Sunset, Timezone -> mehrere Kriterien mit Komma seperarieren):")

    attributeString = attributeString.replace(" ", "").lower()
    attributeList = attributeString.split(",")

    results = weatherStation.getWeatherInfo(attributeList)
    print(results)

    if (trace):
        equalParameters = weatherStation.__eq__(weatherStation.getResult())
        print("Stimmt das Resultat überein? {0}".format(equalParameters))
        print(weatherStation.__str__())




#----------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------
#Testing - put while on line 96 to False to be able to run the tests
from datetime import timedelta
class TestWeatherStation(unittest.TestCase):
    
    responseExample = {'coord': {'lon': 8.55, 'lat': 47.3667}, 'weather': [{'id': 804, 'main': 'Clouds', 'description': 'overcast clouds', 'icon': '04d'}], 'base': 'stations', 'main': {'temp': 278.45, 'feels_like': 278.45, 'temp_min': 277.3, 'temp_max': 281.08, 'pressure': 1023, 'humidity': 84}, 'visibility': 10000, 'wind': {'speed': 0.45, 'deg': 46, 'gust': 1.79}, 'clouds': {'all': 90}, 'dt': 1637152829, 'sys': {'type': 2, 'id': 2019255, 'country': 'CH', 'sunrise': 1637130800, 'sunset': 1637164110}, 'timezone': 3600, 'id': 2657896, 'name': 'Zurich', 'cod': 200}

    def setUp(self):
        self.weatherStation = WeatherStation()

"""Tests um die Setter Methoden zu testen:"""
class TestSetters(TestWeatherStation):
    def test_SetResult(self):
        self.weatherStation.setResult({"Test Get Result"})
        self.assertEqual(self.weatherStation.getResult(), {"Test Get Result"})


"""Tests um die Getter Methoden zu testen:"""
class TestGetters(TestWeatherStation):
    def test_GetResult(self):
        self.assertEqual(self.weatherStation.getResult(), "N/A")
        self.weatherStation.setResult({"Test Get Result"})
        self.assertEqual(self.weatherStation.getResult(), {"Test Get Result"})

    def test_GetTemperature(self):
        self.assertEqual(self.weatherStation.getTemperature(self.responseExample),
                         "%.2f" % round(278.45-self.weatherStation.getCalvinFactor(), 2))

    def test_GetPressure(self):
        self.assertEqual(self.weatherStation.getPressure(self.responseExample), 1023)

    def test_GetHumidity(self):
        self.assertEqual(self.weatherStation.getHumidity(self.responseExample), 84)

    def test_GetSunsetTime(self):
        self.assertEqual(self.weatherStation.getSunsetTime(self.responseExample), datetime(2021, 11, 17, 15, 48, 30))

    def test_GetUtcHourDiff(self):
        self.assertEqual(self.weatherStation.getUtcHourDiff(self.responseExample), 1.0)

    #Test getLocation() Methode inkl. Instanzierung neuer WeatherStation mit Miami
    def test_GetLocation(self):
        self.assertEqual(self.weatherStation.getLocation(), "Zurich")
        weatherStationMiami = WeatherStation("Miami")
        self.assertEqual(weatherStationMiami.getLocation(), "Miami")

    def test_GetCalvinFactor(self):
        self.assertEqual(self.weatherStation.getCalvinFactor(), 273.15)

    def test_GetHourInSeconds(self):
        self.assertEqual(self.weatherStation.getHourInSeconds(), 3600)


"""Tests um die Methode (extractAttributes) zu testen, welche die Informationen ausliest:"""
class TestExtractAttributes(TestWeatherStation):
    def test_ExtractTemp(self):
        self.assertEqual(self.weatherStation.extractAttributes(self.responseExample, ['temp']), {'Temperatur': '5.30 °C'})

    def test_ExtractPressure(self):
        self.assertEqual(self.weatherStation.extractAttributes(self.responseExample, ['pressure']), {'Luftdruck': '1023 hPa'})

    def test_ExtractHumidity(self):
        self.assertEqual(self.weatherStation.extractAttributes(self.responseExample, ['humidity']), {'Luftfeuchtigkeit': '84 %'})

    def test_ExtractSunset(self):
        self.assertEqual(self.weatherStation.extractAttributes(self.responseExample, ['sunset']), {'Sonnenuntergang': '16:48'})

    def test_ExtractTimezone(self):
        self.assertEqual(self.weatherStation.extractAttributes(self.responseExample, ['timezone']), {'Zeitzone': 'UTC +1'})

    def test_ExtractAllAttributes(self):
        self.assertEqual(self.weatherStation.extractAttributes(self.responseExample, ['temp','pressure','humidity','sunset','timezone']), {'Temperatur': '5.30 °C', 'Luftdruck': '1023 hPa', 'Luftfeuchtigkeit': '84 %', 'Sonnenuntergang': '16:48', 'Zeitzone': 'UTC +1'})

    def test_ExtractAllAttributesMiami(self):
        miamiResponse = {"coord":{"lon":-80.1937,"lat":25.7743},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":298.76,"feels_like":299.2,"temp_min":298.15,"temp_max":299.27,"pressure":1022,"humidity":70},"visibility":10000,"wind":{"speed":1.79,"deg":23,"gust":4.47},"clouds":{"all":75},"dt":1637158359,"sys":{"type":2,"id":2009435,"country":"US","sunrise":1637149227,"sunset":1637188286},"timezone":-18000,"id":4164138,"name":"Miami","cod":200}
        weatherStationMiami = WeatherStation("Miami")
        self.assertEqual(weatherStationMiami.extractAttributes(miamiResponse, ['temp','pressure','humidity','sunset','timezone']), {'Temperatur': '25.61 °C', 'Luftdruck': '1022 hPa', 'Luftfeuchtigkeit': '70 %', 'Sonnenuntergang': '17:31', 'Zeitzone': 'UTC -5'})

    #negative Testfälle:
    def test_ExtractWithoutAttributes(self):
        self.assertEqual(self.weatherStation.extractAttributes(self.responseExample), {'error': 'Kein Informationskriterium vorhanden.'})

    def test_InvalidLocation(self):
        invalidResponse = {"cod":"404","message":"city not found"}
        self.assertEqual(self.weatherStation.extractAttributes(invalidResponse, ['pressure']), {'error': 'Ortschaft Zurich nicht gefunden.'})

    def test_InvalidAttribute(self):
        self.assertEqual(self.weatherStation.extractAttributes(self.responseExample, ['test']), {'error': "Kein gueltiges Informationskriterium vorhanden ['test']."})

