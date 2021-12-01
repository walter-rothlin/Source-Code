# ------------------------------------------------------------------
# Name: Diego_Crepulja_A19_DS.py
#
# Description: Eine Wetter-Klasse die es ermöglicht
# Wetter-Daten von einem Service-Anbieter zu ziehen und in
# ansichtlichen Form auszugeben. Die Applikation ermöglicht ein
# einfache interakton mit dem User.
#
# Autor: Diego Crepulja
#
# History:
# 23-11-2021   Diego Crepulja
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + Kein Absturz bei ungültigen User-Eingaben
#      + gute Use-Cases in Klasse implementiert Wettervorhersage für 3 Tage)
#      - User-Input Text-Eingaben anstelle Auswahl
#
# Class Design und Implementation:
#      + Diagramm stimmt mit Code überein
#      - Notwendige (__eq__) Methode nicht vorhanden
#      + __init__ klare Signatur mit funktionierenden Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Instance Variablen sind public
#      ++ docString mit strukturierten Erklärungen für alle Public Methoden
#      + es wird mit try-except user Fehler behandelt
#
# Test:
#      - Keine Test (positive wie negative) implementiert
#
# Note: 5.5
#
# Fragen:
#    Wo wird der Request zum Web-Service abgesendet?
#    Wo wird gechecked, ob der Ort gültig ist oder nicht? in der Klasse?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Bei showWeatherData() wird wdata (Zeile 213-214) übergben. Wie müssten Sie Refactorn, dass dies Variable nicht nötig ist?
# ------------------------------------------------------------------

import requests
from rich import print
import json

#class diagramm: https://drive.google.com/file/d/1Kk7vuZcF9xcM1NG_k7HeMY4oQwXOwaot/view?usp=sharing
class WeatherStation:

    '''
    Die Klasse WeatherStation beinhaltet folgendes

    Args:
        location (str): Das Argument wird für die Ermittlung der Lokation benötigt und hat keinen Default-Wert
        appID (str): Das Argument wird als Schlüssel für die JSON-Abfrage benötigt und hat einen Default-Wert
        units (str): Das Argument bestimmt die Einheit der Ausgaben und hat den Default-Wert 'metric'

    Attributes:
        location (str): Hier wird die Lokation gespeichert
        appID (str): Hier wird die AppID gespeichert
        units (str): Hier wird die Einheit gespeichert
    '''

    def __init__(self, location, appID="bca328e5ff9576b4c98dbd946f79a120", units="metric"):
        self.location = location
        self.appID = appID
        self.units = units
        #print("Welcome, I am your weather station! =)") <-- only for testing

    def __str__(self):
        attributes = "Location: {0}, AppID: {1}, Units: {2}".format(self.location, self.appID, self.units)
        return attributes

    def getCoordinates(self, loc):

        '''Dies ist eine Hilfsfunktion um die Koordinaten einer Location zu ermitteln.

        Args:
            loc (str): Name des Standortes

        Returns:
            coord: die Koordinaten des gesuchte Standortes
        '''

        # Der folgende Code wurde von der App CH_Adress_search.py (Author Walter Rothlin) kopiert und für diese Methode optimiert.
        serviceURL = "http://api.openweathermap.org/data/2.5/weather?q={search:2s}&APPID={appId:2s}"
        requestWeather = serviceURL.format(search=loc, appId=self.appID)
        responseWeather = requests.get(requestWeather)
        jsonCoordResponse = json.loads(responseWeather.text)
        coord = []
        coord.append(jsonCoordResponse["coord"]["lon"])
        coord.append(jsonCoordResponse["coord"]["lat"])
        #print(coord) <-- only for Testing
        return coord


    def getCurrentWeatherData(self):

        '''Diese Funktion holt die Wetterdaten vom Service-Anbieter in Form einer JSON-Datei.
        Die Funktion erstellt eine neue 'dictionary' in JSON Struktur mit den wichtigsten Wetterdaten.

        Returns:
            returnJSON: Eine Bibliothek mit den relevantesten Wetterdaten
        '''

        #Der folgende Code wurde von der App CH_Adress_search.py (Author Walter Rothlin) kopiert und für diese Methode optimiert.
        serviceURL = "http://api.openweathermap.org/data/2.5/weather?q={search:2s}&APPID={appId:2s}&units={units:2s}"
        requestWeather = serviceURL.format(search=self.location, appId=self.appID, units=self.units)
        responseWeather = requests.get(requestWeather)
        jsonResponse = json.loads(responseWeather.text)
        #print("Request:\n", requestWeather) <-- only for testing
        #print("Response:\n", jsonResponse, "\n") <-- only for testing
        returnJSON = {'location': self.location,
                      'description' : jsonResponse['weather'][0]['description'],
                      'temperature' : jsonResponse['main']['temp'],
                      'wind' : jsonResponse['wind']['speed'],
                      'pressure' : jsonResponse['main']['pressure']
                      }
        #print(json.dumps(returnJSON, indent=4)) <-- only for testing
        return returnJSON

    def showWeatherData(self, weatherData):

        '''Funktion gibt die Wetterdaten in einer beschreibenden Form aus.

        Args:
            weatherData (dict): Wetterdaten in JSON-Form
        '''

        print("\nThe weather data for {} are : ".format(weatherData['location']))
        print("Current weather                      : ", weatherData['description'])
        print("Current temperature in Celsius       : ", weatherData['temperature'])
        print("Current wind speed in meter/sec      : ", weatherData['wind'])
        print("Current pressure in hecto Pascals    : ", weatherData['pressure'])
        print("\n")


    def getForecastWeatherData(self):

        '''Funktion holt die die Wetterdaten in als JSON-Datei und gibt das Wetter für die folgenden 3 Tage aus
        '''

        # Der folgende Code wurde von der App CH_Adress_search.py (Author Walter Rothlin) kopiert und für diese Methode optimiert.
        coordinates = self.getCoordinates(self.location)
        serviceURL = "http://api.openweathermap.org/data/2.5/onecall?lat={lat:2s}&lon={lon:2s}&exclude=current,minutely,hourly,alerts&APPID={appId:2s}&units={units}"
        requestFcWeather = serviceURL.format(lat=str(coordinates[1]), lon=str(coordinates[0]), appId=self.appID, units=self.units)
        responseFcWeather = requests.get(requestFcWeather)
        jsonFcResponse = json.loads(responseFcWeather.text)
        print("\n")
        print("The weather for tomorrow in {}     : ".format(self.location), jsonFcResponse["daily"][1]["weather"][0]["description"])
        print("The weather for in 2 days in {}    : ".format(self.location), jsonFcResponse["daily"][2]["weather"][0]["description"])
        print("The weather for in 3 days in {}    : ".format(self.location), jsonFcResponse["daily"][3]["weather"][0]["description"])
        print("\n")

    def checkAppID(self):

        '''
        Funktion prüft den Status der JSON-Datei um fehler abfangen zu können und gibt einen Integer zwischen 0 und 3 aus.

        Returns:
              0 (int): Code für ungültige AppID
              1 (int): Code für gültiges JSON
              2 (int): Code für Error Lokation nicht gefunden
              3 (int): Code für Error keine Daten gefunden
        '''

        # Der folgende Code wurde von der App CH_Adress_search.py (Author Walter Rothlin) kopiert und für diese Methode optimiert.
        serviceURL = "http://api.openweathermap.org/data/2.5/weather?q={search:2s}&APPID={appId:2s}"
        requestWeather = serviceURL.format(search=self.location, appId=self.appID)
        responseWeather = requests.get(requestWeather)
        jsonResponse = json.loads(responseWeather.text)
        #print("Response:\n", jsonResponse, "\n") <-- only for testing
        code = jsonResponse['cod']
        #print(jsonResponse['cod']) <-- only for testing
        if code == 401: #Invalid AppID key. Please input valid AppID.
            return 0
        elif code == 200: #everything good
            return 1
        elif code == "404": #Error city not found
            return 2
        elif code == "400": #Error nothing to geocode
            return 3


#Hauptprogramm/Testapplikation
def main():
    print("------------   Welcome I am your weather station! =)   ------------\n")
    resultsFound = 10000
    while resultsFound > 1: #Schleife für mehrere Abfragen
        status = input(
            "\nFor the current weather data write today, "
            "for weather informations for the next 3 days write next, "
            "to close the app write exit: ")
        while status == "today": #Schleife für die Abfrage der momentanen Wetterdaten
            location = input("Please enter the location: ")
            appid = input("Please enter your appID: ")
            checkID = WeatherStation(location, appid).checkAppID()
            #print(checkID) <-- only for testing
            #print(checkLoc) <-- only for testing
            if checkID == 1:
                print("Valid Location and AppID")
                current_station = WeatherStation(location, appid)
                print(current_station)
            elif checkID == 0:
                print("Invalid or no AppID, we use the default ID.")
                current_station = WeatherStation(location)
                print(current_station)
            elif checkID == 2:
                print("Citiy not found. Please try it again.")
                break
            elif checkID == 3:
                print("Invalid input or data.")
                break
            while True:
                try:
                    wdata = current_station.getCurrentWeatherData()
                    current_station.showWeatherData(wdata)
                    break
                except KeyError:
                    print("Invalid input or data.")
                    break
            exitLoop = input("\nDo you want the current weather for another locations? Please insert for yes --> y or for no --> n: ")
            if exitLoop == "n":
                break
            elif exitLoop == "y":
                continue
            else:
                break

        if status == "next":
            while resultsFound > 1: #schleife für die Abfrage der Wetterdaten der nächsten 3 Tage
                location = input("Please enter the location: ")
                appid = input("Please enter your appID: ")
                checkID = WeatherStation(location, appid).checkAppID()
                #print(checkID) <-- only for Testing
                if checkID == 1:
                    print("Valid AppID")
                    further_station = WeatherStation(location, appid)
                    print(further_station)
                elif checkID == 0:
                    print("Invalid or no AppID, we use the default ID.")
                    further_station = WeatherStation(location)
                    print(further_station)
                elif checkID == 2:
                    print("Citiy not found. Please try it again.")
                    break
                while True:
                    try:
                        further_station.getForecastWeatherData()
                        break
                    except KeyError:
                        print("Invalid input or data.")
                        break
                exitLoop = input("\nDo you want the further weather for another locations? Please insert y for yes or n for no: ")
                if exitLoop == "n":
                    break
                elif exitLoop == "y":
                    continue
                else:
                    break

        elif status == "exit": #Anweisung für Ausstieg aus der Schleife oder Wechsel in andere Schleife
            break
        else:
            print("\nSorry something went wrong, please try it again.\n")

main()





