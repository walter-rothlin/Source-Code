#####################################################################
# Applikation Wetterstation - v9 ( Final)
# --------------------------------
# David Bosshard - 22.11.2021
#
# Inhalt:
# - Klasse initialisiert für Wetterstation
# - Methode implementiert für Suche
# - Check implementiert (Kontrolle status_code = 200)
# - verschiedene Methoden implementiert (createURL, createRequest)
# - Methode Wetterbericht
# - Methode Vergleichstabelle
# - Programmauswahl (Einfache Suche, Vegleich, Wetterbericht)
#
# - Klassendiagramm ab Zeile 25
# - Testfälle ab Zeile 293
# - Durchgeführte Tests ab Zeile 346
#
# openWeather API --> https://openweathermap.org/api
# kompletter Link --> https://api.openweathermap.org/data/2.5/weather?q=winterthur&appid=acaa7111efd235f5766821b57a56ff2e
#
#####################################################################

# Klassendiagramm
#
#  |------------------------|
#  | Weatherstation         |
#  |------------------------|
#  | Attribute              |
#  | - appId: string        |
#  | - URL: string          |
#  | + requestStr: string   |
#  | + responseStr: string  |
#  | + searchInput: string  |
#  |------------------------|
#  | Methoden:              |
#  | + createURL()          |
#  | + createRequest()      |
#  | + weatherSearch()      |
#  | + getWeather()         |
#  | + getWeatherReport()   |
#  |------------------------|
#
#    Weitere Methoden:
#      searchReport()
#      weatherCompare()
#      search()
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + Kein Absturz bei ungültigen User-Eingaben
#      -- die "Weiteren Methoden" könnten als static in die Klasse übernommen werden (kein Reuse möglich)
#
# Class Design und Implementation:
#      + Diagramm stimmt mit Code überein
#      - Notwendige (__eq__) Methoden mit Syntax-Fehler
#      - __init__ klare Signatur mit funktionierenden Default values, ort als parameter fehlt aber (Wichtigster Parameter)
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - nicht alle Instance Variablen sind private
#      + Weather Info wird übersetzt (Uebersetzungstabelle mit Dicts wäre erweiterbarer gewesen)
#
# Test:
#      + Test (positive wie negative) implementiert
#
# Note: 4.5
#
# Fragen:
#    Wo wird der Request zum Web-Service abgesendet?
#    Wo wird gechecked, ob der Ort gültig ist oder nicht? in der Klasse?
#    Wo werden Werte Uebersetz und könnte man dies wartbarer implementieren
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Gehört searchReport() zur Klasse? Wenn nein, wie sieht ein refactoring aus (stische methoden, methoden)

import requests
import json
import time

appId = "acaa7111efd235f5766821b57a56ff2e"
URL = "https://api.openweathermap.org/data/2.5/weather?q={search:2s}&appid={appId:2s}"

class Weatherstation:
    def __init__(self, appId= "acaa7111efd235f5766821b57a56ff2e", URL = "https://api.openweathermap.org/data/2.5/weather?q={search:2s}&appid={appId:2s}", searchInput="Empty"):
        self.__appId = appId
        self.__URL = URL
        self.searchInput = searchInput

    # return string
    def __str__(self):
        string = "appId   : " + self.__appId + "\n"
        string += "URL     : " + self.__URL + "\n"
        string += "Request : " + self.requestStr + "\n"
        return string

    # compare Inputs
    def __eq__(self):
        return self.searchInput == searchInput2.searchInput

    def weatherSearch(self):
        searchInput = input("Bitte einen gewünschten Ort eingeben: ")
        return searchInput

    def createURL(self,searchInput):
        requestStr = URL.format(search=searchInput, appId=appId)
        return requestStr

    def createRequest(self,requestStr):
        responseStr = requests.get(requestStr)
        return responseStr

    # Erstellen eines Wetterberichts in Textform
    def getWeatherReport(self,responseStr):
        weatherReport = json.loads(responseStr.text)
        print("\nWetterbericht:")
        station = weatherReport['name']
        weather = weatherReport['weather'][0]['description']
        tempmax = weatherReport["main"]["temp_max"] - 273
        tempmin = weatherReport["main"]["temp_min"] - 273
        windspeed = weatherReport["wind"]["speed"]
        winddirection = weatherReport["wind"]["deg"]

        # Übersetzung der englischen Werte
        if weather == "mist":
            weather = "leicht neblig"
        elif weather == "fog":
            weather = "neblig"
        elif weather == "scattered clouds":
            weather = "heiter"
        elif weather == "broken clouds":
            weather = "durchbrochen bewölkt"
        elif weather == "clear sky":
            weather = "klar und sonnig"
        elif weather == "few clouds":
            weather = "leicht bewölkt"
        elif weather == "overcast clouds":
            weather = "bewölkt"
        elif weather == "light intensity drizzle":
            weather = "leicht nieselnd"
        elif weather == "moderate rain":
            weather = "mässig regnerisch"
        elif weather == "heavy rain":
            weather = "stark regnerisch"

        # Umwandlung der Windrichtung in Text
        if 1 <= winddirection <= 45:
            winddirection = "nördlicher Richtung"
        elif 46 <= winddirection <= 135:
            winddirection = "östlicher Richtung"
        elif 136 <= winddirection <= 225:
            winddirection = "südlicher Richtung"
        elif 226 <= winddirection <= 315:
            winddirection = "westlicher Richtung"
        elif 316 <= winddirection <= 360:
            winddirection = "nördlicher Richtung"
        else:
            winddirection = "keiner Richtung"

        # Ausgabe Wetterbericht
        print("In {0} ist das Wetter {1} und die Temperatur beträgt von Minimum {2:.0f}°C bis Maximal {3:.0f}°C.".format(station, weather, tempmin, tempmax))
        print("Die Windgeschwindigkeit beträgt dabei {0} km/h und der Wind bläst aus {1}.".format(windspeed, winddirection))

    # Rückgabe von Wetterdaten
    def getWeather(self,responseStr):
        weatherData = json.loads(responseStr.text)
        print("\nSuchresultat:")
        print("   Station:              {}".format(weatherData['name']))
        print("   Wetter:               {}".format(weatherData['weather'][0]['description']))
        print("   Luftfeuchtigkeit:     {0:.2f}%".format(weatherData["main"]["humidity"]))
        print("   Luftdruck:            {0:.2f} hpa".format(weatherData["main"]["pressure"]))
        print("   Temperatur:           {0:.4s}° C".format(str(weatherData["main"]["temp"] - 273)))
        print("   Max. Temperatur:      {0:.4s}° C".format(str(weatherData["main"]["temp_max"] - 273)))
        print("   Min. Temperatur:      {0:.4s}° C".format(str(weatherData["main"]["temp_min"] - 273)))
        print("   Windgeschwindigkeit:  {0:.2f} m/s".format(weatherData["wind"]["speed"]))
        print("   Windrichtung:         {}°".format(weatherData["wind"]["deg"]))
        print("\n")

# Such-Methode mit Suchparameter (Überprüfung status_code zur Verhinderung von Falscheingaben)
def search():
    check_city = True
    while check_city:
        request = Weatherstation()
        searchInput = request.weatherSearch()
        requestStr = URL.format(search=searchInput, appId=appId, URL=URL)
        responseStr = requests.get(requestStr)

        if (responseStr.status_code != 200):
            print("Dieser Ort ist nicht verfügbar! Neuen Ort eingeben.\n")
        else:
            check_city = False
            print("Abfrage ist korrekt! Suche wird gestartet...\n")
            time.sleep(1)
            print("Suchkriterium:          ", "-->", searchInput, "<--")
            print("\n---------------------------------------")
            request.getWeather(responseStr)
            print("\n---------------------------------------")

# Suchmethode für Wetterbericht
def searchReport():
    check_city = True
    while check_city:
        report = Weatherstation()
        reportInput = input("Bitte einen gewünschten Ort eingeben: ")
        requestStr = URL.format(search=reportInput, appId=appId, URL=URL)
        responseStr = requests.get(requestStr)

        if (responseStr.status_code != 200):
            print("Dieser Ort ist nicht verfügbar! Neuen Ort eingeben.\n")
        else:
            check_city = False
            print("Abfrage ist korrekt! Suche wird gestartet...\n")
            time.sleep(1)
            print("Suchkriterium:          ", "-->", reportInput, "<--")
            print("\n---------------------------------------")
            report.getWeatherReport(responseStr)
            print("\n---------------------------------------")

# Methode für den Vergleich von 2 Orten
def weatherCompare():
    searchInput = input("\nBitte geben Sie Ort Nr. 1 ein: ")
    requestStr = URL.format(search=searchInput, appId=appId)
    responseStr = requests.get(requestStr)

    searchInput2 = input("Bitte geben Sie Ort Nr. 2 ein: ")
    requestStr2 = URL.format(search=searchInput2, appId=appId)
    responseStr2 = requests.get(requestStr2)

    print("\n\nVergleichstabelle zwischen:",  searchInput, "und", searchInput2)
    compareWeather = json.loads(responseStr.text)
    compareWeather2 = json.loads(responseStr2.text)
    station1 = compareWeather['name']
    station2 = compareWeather2['name']
    weather_des1 = compareWeather['weather'][0]['description']
    weather_des2 = compareWeather2['weather'][0]['description']
    temp_str = str(round(compareWeather["main"]["temp"] - 273))
    temp1 = temp_str + "°C"
    temp2 = str(round(compareWeather2["main"]["temp"] - 273))
    print("\n-------------------------------------------------------------")
    print("Station:    | {0:20s} | {1}".format(station1, station2))
    print("Wetter:     | {0:20s} | {1}".format(weather_des1, weather_des2))
    print("Temperatur: | {0:20s} | {1} °C".format(temp1, temp2))
    print("\n-------------------------------------------------------------")
    print("\n\n")

# Testdurchlauf mit vorgegebenen Werten
def test_Weather():
    print("Tests Wetterapplikation")
    print("#########################")
    print("\nTest Einzelsuche:")
    print("Input = Winterthur")
    print("----------------------")
    responseStr = requests.get('https://api.openweathermap.org/data/2.5/weather?q=winterthur&appid=acaa7111efd235f5766821b57a56ff2e')
    Weatherstation.getWeather(1,responseStr)
    print("\nTest Vergleichstabelle:")
    print("Input1 = London | Input2 = Paris")
    print("----------------------")
    responseStr2_1 = requests.get('https://api.openweathermap.org/data/2.5/weather?q=london&appid=acaa7111efd235f5766821b57a56ff2e')
    responseStr2_2 = requests.get('https://api.openweathermap.org/data/2.5/weather?q=paris&appid=acaa7111efd235f5766821b57a56ff2e')
    compareWeather = json.loads(responseStr2_1.text)
    compareWeather2 = json.loads(responseStr2_2.text)
    station1 = compareWeather['name']
    station2 = compareWeather2['name']
    weather_des1 = compareWeather['weather'][0]['description']
    weather_des2 = compareWeather2['weather'][0]['description']
    temp_str = str(round(compareWeather["main"]["temp"] - 273))
    temp1 = temp_str + "°C"
    temp2 = str(round(compareWeather2["main"]["temp"] - 273))
    print("Station:    | {0:20s} | {1}".format(station1, station2))
    print("Wetter:     | {0:20s} | {1}".format(weather_des1, weather_des2))
    print("Temperatur: | {0:20s} | {1} °C".format(temp1, temp2))
    print("\n\nTest Wetterbericht")
    print("Input = Winterthur")
    print("----------------------")
    responseStr3 = requests.get('https://api.openweathermap.org/data/2.5/weather?q=winterthur&appid=acaa7111efd235f5766821b57a56ff2e')
    Weatherstation.getWeatherReport(1,responseStr3)


# --------------------------
# Applikation Wetterstation
# --------------------------

if __name__ == '__main__':
    print("\nApplikation Wetterstation - von David Bosshard\n")
    print("---------------------------------------------")
    # print-Befehl für __str__ (ausgeblendet)
    # print(Weatherstation())

    # Testlauf (muss aktiviert werden)
    if False:
        test_Weather()

    # Hauptprogramm
    doLoop = True
    while doLoop:
        if True:
            print("\nWählen Sie ihr Suchprogramm aus: ")

            # Programmauswahl
            print("\nFolgende Auswahl steht Ihnen zur Verfügung: \n[1] Einzelsuche \n[2] Vergleichssuche \n[3] Wetterbericht \n[0] Abbruch\n")
            time.sleep(1)
            try:
                programm = int(input("Geben Sie die entsprechende Zahl für das gewünschte Programm ein (1-3): "))
                if programm == 1:
                    print("Einzelsuche gestartet...\n")
                    time.sleep(1)
                    search()
                elif programm == 2:
                    weatherCompare()
                elif programm == 3:
                    searchReport()
                elif programm == 0:
                    print("Programm beendet!")
                    exit()
            except ValueError:
                print("Fehlerhafte Eingabe!")
                exit()


##############
# TESTFÄLLE #
##############

# Testfall Nr.1
#--------------
# Auswahl der Programms (1,2,3)
#
# Erwartetes Ergebnis: Je nach Auswahl wird das entsprechende Programm gestartet und ausgeführt.


# Testfall Nr.2.1
# --------------
# User gibt ein korrektes Suchkriterium ein und startet die Suche
#
# Erwartetes Ergebnis: Suche wird gestartet und Suchresultate werden angezeigt


# Testfall Nr.2.2
# --------------
# User gibt ein falsches Suchkriterium (Rückgabewert: status_code != 200) ein und startet die Suche
#
# Erwartetes Ergebnis: Fehlermeldung "Dieser Ort ist nicht verfügbar! Neuen Ort eingeben!" erscheint und der User
#                      muss einen neuen Wert eingeben.


# Testfall Nr.3 (nicht umgesetzt)
# --------------
# User möchte das Suchkriterium nochmals anpassen
#
# Erwartetes Ergebnis: Altes Suchkriterium wird überschrieben und das neue Suchkriterium wird angezeigt


# Testfall Nr.4 (nicht umgesetzt --> nicht Business relevant)
# --------------
# User möchte für einen Ort ein speziellen Feldwert anzeigen lassen (z.B. nur die Temperatur)
#
# Erwartetes Ergebnis: Suchkriterium wird nur mit diesem Wert angezeigt


# Testfall Nr. 5
# ---------------
# User möchte das Wetter vergleichen zwischen zwei Orten
#
# Erwartetes Ergebnis: Vergleichstabelle zwischen zwei Orten erscheint


# Testfall Nr. 6
# ---------------
# User möchte das Programm abbrechen
#
# Erwartetes Ergebenis: Nach Eingabe des Abbruchbefehls [0] wird das Programm beendet

#######################
# DURCHGEFÜHRTE TESTS #
#######################

# Test v1 OK --> Weiter mit v2:
# Methode implementiert mit einfach Wertrückgabe
# SearchInput: Winterthur
# Output:
"""
{
    "criteria": "Winterthur",
    "result": [
        {
            "station": "Winterthur",
            "description": "overcast clouds",
            "wind speed": "0.89 km/h",
            "humidity": "83%",
            "temperature": "5 degrees"
        }
    ]
}
"""

# Test v2 NOK --> Neuer Start mit v3:
# Fehlerhafte Implementation von check_city (Problem --> Wahrscheinlich liegt es an der Sequenzierung)
# SearchInput: Winterthur
# Output:
"""
Traceback (most recent call last):
  File "C:/Users/charl/PycharmProjects/Python_HWZ/Distributed and Mobile Systems/Leistungsnachweis/weatherstation_v2.py", line 54, in <module>
    requestStr = URL.format(search=SearchInputEnc, appId=appId)
NameError: name 'SearchInputEnc' is not defined
"""

# Test v3.1 NOK (Nicht zufrieden mit Struktur) --> Neuer Versuch mit v3.2:
# Klasse initialisiert
# SearchInput: berlin
# Output:
"""
{
    "criteria": "berlin",
    "result": [
        {
            "station": "Berlin",
            "description": "broken clouds",
            "wind speed": "4.02 km/h",
            "humidity": "87%",
            "temperature": "6 degrees"
        }
    ]
}
"""

# Test v3.2 OK --> Weiter mit v4:
# JSON Struktur umgebaut
# SearchInput: Winterthur
# Output:
"""
Suchkriterium: Winterthur
Resultat:
   Luftfeuchtigkeit: 81%
   Luftdruck: 1024 hpa
   Temperatur: 5.519999999999982° C
   Max. Temperatur: 7.800000000000011° C
   Min. Temperatur: 4.139999999999986° C
   Windgeschwindigkeit: 0.89 m/s
   Windrichtung: 231°
"""

#Test 4 OK --> Weiter mit v5:
# check_city erfolgreich implementiert
# SearchInput: 1. Try --> blub / 2. Try  --> Madrid
# Output:
"""
Bitte gewünschten Ort eingeben: blub
Dieser Ort ist nicht verfügbar! Neuen Ort eingeben.

Bitte gewünschten Ort eingeben: Madrid
Abfrage ist korrekt! Suche starten....

Suchkriterium: Madrid
Resultat:
   Station:              Madrid
   Wetter:               scattered clouds
   Luftfeuchtigkeit:     62.00%
   Luftdruck:            1026.00 hpa
   Temperatur:           12.1° C
   Max. Temperatur:      14.4° C
   Min. Temperatur:      9.14° C
   Windgeschwindigkeit:  0.89 m/s
   Windrichtung:         23°
"""
# Problem: Suchabfragen nicht in Klasse implementiert

#Test v5 - OK --> weiter mit v6 (Versuch: Vergleich zwischen zwei Orten :
# Aufteilung in mehrere Methoden (createURL, createRequest)
# SearchInput: London
# Output:
"""
Applikation Wetterstation - von David Bosshard

Bitte einen gewünschten Ort eingeben: London
Abfrage ist korrekt! Suche wird gestartet...

Suchkriterium:           --> London <--

---------------------------------------

Suchresultat:
   Station:              London
   Wetter:               scattered clouds
   Luftfeuchtigkeit:     88.00%
   Luftdruck:            1030.00 hpa
   Temperatur:           11.9° C
   Max. Temperatur:      13.0° C
   Min. Temperatur:      10.4° C
   Windgeschwindigkeit:  5.14 m/s
   Windrichtung:         240°

---------------------------------------
"""

# Test v6.1 - NOK (Problem mit Übersetzung):
# Implementation eines Wetterberichts in Form von Text
# Problem: Texte müssten übersetzt oder umformatiert werden --> Windrichtung
# Suchkriterium: Winterthur
# Output:
"""
Wetterbericht:
In Winterthur ist das Wetter 'mist' und die Temperatur beträgt von Minimum 2°C bis Maximal 9°C.
Die Windgeschwindigkeit beträgt dabei 1.03 km/h und kommt aus '0' 
---------------------------------------
"""

# Test v6.2 - OK:
# Implementation eines Wetterberichts in Form von Text
# Suchkriterium: Winterthur
# Output:
"""
Wetterbericht:
In Winterthur ist das Wetter 'heiter' und die Temperatur beträgt von Minimum 3°C bis Maximal 12°C.
Die Windgeschwindigkeit beträgt dabei 0.89 km/h und kommt aus 'südlicher Richtung' 
---------------------------------------
"""

# Test v7 NOK - 1. Versuch:
# Implementation einer Vergleichstabelle zwischen 2 Orten
# Formatierung mit Abständen noch korrigieren
# SearchInput: Winterthur + Madrid
# Output:
"""
Bitte geben Sie Ort Nr. 1 ein: Winterthur
Bitte geben Sie Ort Nr. 2 ein: Madrid

Vergleichstabelle zwischen: Winterthur <-- ---> Madrid

Station:    |   Winterthur            |   Madrid
Wetter:     |   overcast clouds            |   scattered clouds
Temperatur: |   6 °C        |   12 °C

---------------------------------------
"""

# Test v7 OK - 2. Versuch:
# Implementation einer Vergleichstabelle zwischen 2 Orten
# SearchInput: Winterthur + Madrid
# Output:
"""
Bitte geben Sie Ort Nr. 1 ein: Winterthur
Bitte geben Sie Ort Nr. 2 ein: Madrid


Vergleichstabelle zwischen: Winterthur <-- ---> Winterthur
Station:    | Winterthur           | Madrid
Wetter:     | scattered clouds     | few clouds
Temperatur: | 6°C                  | 14 °C
"""

# Test v8 - OK:
# Implementation von 3 Programmen mit Auswahl
# Output:
"""
Wählen Sie ihr Suchprogramm aus: 

Folgende Auswahl steht Ihnen zur Verfügung: 
[1] Einzelsuche 
[2] Vergleichssuche 
[3] Wetterbericht 
[0] Abbruch

Geben Sie die entsprechende Zahl für das gewünschte Programm ein (1-3): 
"""


# Test v9 - OK:
# Finaler Test - Durchgang alle Testfälle
"""
Output:

"Applikation Wetterstation - von David Bosshard

---------------------------------------------

Wählen Sie ihr Suchprogramm aus: 

Folgende Auswahl steht Ihnen zur Verfügung: 
[1] Einzelsuche 
[2] Vergleichssuche 
[3] Wetterbericht 
[0] Abbruch

Geben Sie die entsprechende Zahl für das gewünschte Programm ein (1-3): 1
Einzelsuche gestartet...

Bitte einen gewünschten Ort eingeben: dfsf
Dieser Ort ist nicht verfügbar! Neuen Ort eingeben.

Bitte einen gewünschten Ort eingeben: Winterthur
Abfrage ist korrekt! Suche wird gestartet...

Suchkriterium:           --> Winterthur <--

---------------------------------------

Suchresultat:
   Station:              Winterthur
   Wetter:               overcast clouds
   Luftfeuchtigkeit:     81.00%
   Luftdruck:            1021.00 hpa
   Temperatur:           5.54° C
   Max. Temperatur:      6.56° C
   Min. Temperatur:      3.57° C
   Windgeschwindigkeit:  3.13 m/s
   Windrichtung:         328°



---------------------------------------

Wählen Sie ihr Suchprogramm aus: 

Folgende Auswahl steht Ihnen zur Verfügung: 
[1] Einzelsuche 
[2] Vergleichssuche 
[3] Wetterbericht 
[0] Abbruch

Geben Sie die entsprechende Zahl für das gewünschte Programm ein (1-3): 2

Bitte geben Sie Ort Nr. 1 ein: London
Bitte geben Sie Ort Nr. 2 ein: Paris


Vergleichstabelle zwischen: London und Paris

-------------------------------------------------------------
Station:    | London               | Paris
Wetter:     | broken clouds        | clear sky
Temperatur: | 5°C                  | 5 °C

-------------------------------------------------------------




Wählen Sie ihr Suchprogramm aus: 

Folgende Auswahl steht Ihnen zur Verfügung: 
[1] Einzelsuche 
[2] Vergleichssuche 
[3] Wetterbericht 
[0] Abbruch

Geben Sie die entsprechende Zahl für das gewünschte Programm ein (1-3): 3
Bitte einen gewünschten Ort eingeben: sdfs
Dieser Ort ist nicht verfügbar! Neuen Ort eingeben.

Bitte einen gewünschten Ort eingeben: Winterthur
Abfrage ist korrekt! Suche wird gestartet...

Suchkriterium:           --> Winterthur <--

---------------------------------------

Wetterbericht:
In Winterthur ist das Wetter bewölkt und die Temperatur beträgt von Minimum 4°C bis Maximal 7°C.
Die Windgeschwindigkeit beträgt dabei 3.13 km/h und der Wind bläst aus nördlicher Richtung.

---------------------------------------

Wählen Sie ihr Suchprogramm aus: 

Folgende Auswahl steht Ihnen zur Verfügung: 
[1] Einzelsuche 
[2] Vergleichssuche 
[3] Wetterbericht 
[0] Abbruch

Geben Sie die entsprechende Zahl für das gewünschte Programm ein (1-3): 0
Programm beendet!
"""