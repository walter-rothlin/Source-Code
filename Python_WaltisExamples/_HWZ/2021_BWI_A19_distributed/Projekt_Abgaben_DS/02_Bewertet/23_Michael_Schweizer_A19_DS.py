# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + User-Eingaben möglich
#      + Unsinnige Usereingaben werden abgefangen
#
# Class Design und Implementation:
#      + Diagramm stimmt grösstenteils mit Code überein (+ / - für private / public)
#      + Notwendige (__eq__ __str__ __eq__) Methoden vorhanden
#      -- Nicht OO und keine Klasse die in der App instanziert wird
#      - __init__ unnötige parameter und die relevanten haben keine Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Instance Variablen sind public
#
# Test:
#      + Test (positive) implementiert
#
# Note: 4.5
#
# Fragen:
#    Auf welcher Zeile wird der Request zum Web-Service abgesendet?
#    Auf welcher Zeile wird ein Objekt ihrer Wetter-Klasse kreiert
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------
# ------------------------------------------------------------------
# Name: Wetterstation.py
#
# Description: Does a search via REST request to openweather.org (JSON) to give back
#              the weather in a given City
#
# Autor: Michael Schweizer
#
# ClassDiagram: https://lucid.app/publicSegments/view/3da56612-a64b-4dc2-b56d-464147a51778
#
# History:
# 22-Nov-2021   Michael Schweizer      Initial Version
# ------------------------------------------------------------------

import requests
import json
import sys

doTrace = False

class Wetterstation:
    def get_current_weather(self):
        pass

    def __eq__(self, other):    # verstehe nicht, warum wir das hier brauchen
        pass

class WetterstationException(Exception):

    def __init__(self, code, message):
        self.code = code
        self.message = message

    def __str__(self):
        return "(" + str(self.code) + ") " + self.message


def getResults_openweather(searchCriteria, doTrace = False):
    api_key = "881ecf18244253fc8677291c03199f35"
    requestStr = "https://api.openweathermap.org/data/2.5/weather?" + "q=" + searchCriteria + " &units=metric&lang=de&appid=" + api_key
    responseStr = requests.get(requestStr)
    if not str.isalpha(searchCriteria):
          # len(searchCriteria) == 0:
          # len() prüft nur die Länge. isalpha() prüft ob jeder character im String ein Buchstabe ist und min. 1 character --> https://docs.python.org/2/library/stdtypes.html#str.isalpha
          # Absichtlich keinen DefaultWert für SearchCriteria gesetzt, um diesen Fall abzubilden
        print("")
        print("Bitte Suchkriterium eingeben (keine Zahlen)")
        # Wenn kein Suchkriterium eingegeben wird, wird eine Fehlermeldung ausgegeben mit dem Text "Bitte Suchkriterium eingeben"
    elif responseStr.status_code == 401 or responseStr.status_code == 404 or responseStr.status_code == 429:
        print("")
        print("An Error occured: " + str(OpenWeatherException(responseStr.status_code, responseStr.json()['message'])))
        #raise OpenWeatherException(responseStr.status_code, responseStr.json()['message'])
        # "raise" führt zu einer "unschönen" Fehlermeldung "raceback (most recent call last):...."
        # Ausgabe des Fehlers inkl. Fehlercode von openweather.org
        # Bei der Ausgabe des Fehlers entsteht eine zusätzliche Zeile mit "null" --> weiss nicht, wo die herkommt
    else:
        jsonResponse = json.loads(responseStr.text)
        city = jsonResponse['name']
        country = jsonResponse['sys']['country']
        temp = jsonResponse['main']['temp']
        description = jsonResponse['weather'][0]['description']
        humidity = jsonResponse['main']['humidity']
        Windspeed = jsonResponse['wind']['speed']
        print("")
        print("City:         " + city)
        print("Country:      " + country)
        print("Temperature:  " + str(temp) + " °C")
        print("Description:  " + description)
        print("Humidity:     " + str(humidity) + "%")
        print("Windspeed:    " + str(Windspeed) + " m/s")
         # aus Aufgabenstellung übernommen

# Klasse für die Exceptions, die von openweather.org als Antwort auf einen fehlgeschlagenen Request kommen
class OpenWeatherException(Exception):

    def __init__(self, code, message):
        self.code = code
        self.message = message

    def __str__(self):
        return "(" + str(self.code) + ") " + self.message

# Input des Suchkriteriums zu Testzwecken
searchCriteria = input("Suchkriterium (City):")
# searchCriteriaEncoded = searchCriteria.replace(" ", "%20")
# ersetzen von Leerzeichen führt zu Fehler bei Abfrage von "St. Mortiz"


# Testprint der Ergebnisse
results = getResults_openweather(searchCriteria, False)
print(json.dumps(results, indent=4))

"""
Mögliche Erweiterungen:
- Einbinden von GeoAdmin:
    - um jeweils die nächste Stadt abzufragen so, dass für jeden Ort das Wetter verfügbar wird.
    - um suchen nach PLZ in der Schweiz zu ermöglichen
- Korrektes Fehlerhandling aller möglichen Fehlertypen (Sonderzeichen in Suchkriterien usw.)
    - Momentan ist die Suche nach z.B. "St. Moritz" nicht möglich aufgrund des "."
"""