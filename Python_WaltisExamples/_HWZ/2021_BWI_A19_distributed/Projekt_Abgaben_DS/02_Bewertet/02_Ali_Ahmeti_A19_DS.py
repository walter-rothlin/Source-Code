# ------------------------------------------------------------------
# Name: Ali_Ahmeti_A19_DS.py
#
# Beschreibung: Applikation einer Wetterstations mittels Openweather
#
# Autor: Ali Ahmeti
#
# Zeit:
# 16-Nov-2021 - 23-Nov-2021  Ali      Vollversion
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      - Ungültige User Eingaben führen zum Absturtz
#      - Automated Tests werden im main loop gemacht
#
# Class Design und Implementation:
#      + Notwendige (__init__, __str__, __eq__) Methoden vorhanden
#      - __init__ isOrtschaftAvailable unötig und verwirrend
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Methoden sind public
#      + AppID, requestURL als Parameter in __init__
#      + Weather Info wird in einfaches JSON umgepackt
#      - createOutput sollte private sein
#      - getResults_Openweather ist zu spezifisch und darf nicht public sein (Muss gekapselt werden z.B. getCurrentWeather()
#
# Test:
#      + Ein einziger Test ist implementiert
#      - Tiefe Testabdeckung (Eine einzige static Methode [createOutput] wird mit einem single Test aufgerufen)
#
# Note: 4.5
#
# Fragen:
#    Was wäre das nächste Refactoring der Klasse?
#    Wo wird der Request zum Web-Service abgesendet?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wie könnte der Design der Klasse in dieser Hinsicht verbessert werden?












# ------------------------------------------------------------------
# Link zum Klassendiagramm: https://drive.google.com/file/d/1DlYIgkBOWG2TGg_5at4KRb7Diezn5gC_/view?usp=sharing

import requests
import json
from rich import print

#Tests----------
class Test:
    def __init__(self):
        print("-------------------Tests-------------------")
        self.test_createOutput()

    #Test mit Zürich
    def test_createOutput(self):
        example = {'coord': {'lon': 8.55, 'lat': 47.3667},
                   'weather': [{'id': 804, 'main': 'Clouds', 'description': 'overcast clouds', 'icon': '04d'}],
                   'base': 'stations',
                   'main': {'temp': 276.92, 'feels_like': 276.92, 'temp_min': 275.29, 'temp_max': 278.74,
                            'pressure': 1017, 'humidity': 91}, 'visibility': 10000,
                   'wind': {'speed': 0.45, 'deg': 135, 'gust': 0.89}, 'clouds': {'all': 90}, 'dt': 1637571614,
                   'sys': {'type': 2, 'id': 2019255, 'country': 'CH', 'sunrise': 1637563230, 'sunset': 1637595825},
                   'timezone': 3600, 'id': 2657896, 'name': 'Zurich', 'cod': 200}
        ergebnisJSON = wetterstation.createOutput(example)
        print("Wetter              = ", ergebnisJSON['Informationen']['Wetter'], "      Expected: Clouds")
        print("Ortschaft           = ", ergebnisJSON['Informationen']['Ortschaft'], "      Expected: Zurich")
        print("Land                = ", ergebnisJSON['Informationen']['Land'], "          Expected: CH")
        print("Temperatur          = ", ergebnisJSON['Informationen']['Temperatur'], "      Expected: 276.49")
        print("Min.Temperatur      = ", ergebnisJSON['Informationen']['Min.Temperatur'], "      Expected: 275.29")
        print("Max.Temperatur      = ", ergebnisJSON['Informationen']['Max.Temperatur'], "      Expected: 278.74")
        print("Luftdruck           = ", ergebnisJSON['Informationen']['Luftdruck'], "        Expected: 1017")
        print("Luftfeuchtigkeit    = ", ergebnisJSON['Informationen']['Luftfeuchtigkeit'], "          Expected: 93")
        print("Windgeschwindigkeit = ", ergebnisJSON['Informationen']['Windgeschwindigkeit'], "        Expected: 0.45")
        print("Sonnenaufgang       = ", ergebnisJSON['Informationen']['Sonnenaufgang'], "  Expected: 1637563230")
        print("Sonnenuntergang     = ", ergebnisJSON['Informationen']['Sonnenuntergang'], "  Expected: 1637595825")




#Application: Wetterstation

doTrace = False

class Wetterstation:

    # Openweathermap.org als Beispiel mit Zürich: http://api.openweathermap.org/data/2.5/weather?q=Zürich&appid=a51bad3b0fafeda70db47a4aa98bef95
    # API:  https://openweathermap.org/api
    def __init__(self, ortschaft = "", url= "http://api.openweathermap.org/data/2.5/weather?q={search:2s}&appid={appId:2s}",
                 appId = "a51bad3b0fafeda70db47a4aa98bef95", isOrtschaftAvailable = True ):
        self.__ortschaft = ortschaft
        self.__url = url
        self.__appId = appId
        self.__isOrtschaftAvailable = isOrtschaftAvailable

    def __str__(self):
        return "\nDas Wetter wurde mit Openweather.org herausgesucht."

    def __eq__(self, jsonAntwort):
        if (jsonAntwort.get('message') == "city not found"):
            self.setIsOrtschaftAvailable(False)
            return "\nDas Wetter folgender Ortschaft wurde nicht gefunden: {0}".format(self.getOrtschaft())
        else:
            self.setIsOrtschaftAvailable(True)
            return "\nDas Wetter folgender Ortschaft wurde erfolgreich gefunden: {0}".format(self.getOrtschaft())


    def getUrl(self):
        return self.__url

    def getAppId(self):
        return self.__appId

    def getOrtschaft(self):
        return self.__ortschaft

    def setOrtschaft(self, ortschaft):
        self.__ortschaft = ortschaft

    def getIsOrtschaftAvailable(self):
        return self.__isOrtschaftAvailable

    def setIsOrtschaftAvailable(self, isOrtschaftAvailable):
        self.__isOrtschaftAvailable = isOrtschaftAvailable



    def getResults_Openweather(self, suchkriteriumEncoded, doTrace = False):

        self.__aufrufStr =self.getUrl().format(search=suchkriteriumEncoded,  appId=self.getAppId())
        self.__antwortStr = requests.get(self.__aufrufStr)
        jsonAntwort = json.loads(self.__antwortStr.text)
        print(self.__eq__(jsonAntwort))
        return self.createOutput(jsonAntwort, doTrace)


    def createOutput(self, jsonAntwort=None, doTrace = False):
        ergebnisJSON = {'Suche': suchkriteriumEncoded,
                        'Informationen': []}

        # überprüft ob die Stadt vorhanden ist, falls die Stadt vorhanden ist werden die weiteren Attribute herausgelesen
        if (self.getIsOrtschaftAvailable()):
            # print("Request:\n", requestStr) if doTrace else False
            # print("Response:\n", jsonResponse, "\n") if doTrace else False
            # print("Parsed values (Records found:{recCount:2d}):".format(recCount=len(jsonResponse['results'])))
            ortschaft = jsonAntwort['name']
            land = jsonAntwort['sys']['country']
            wetter = jsonAntwort['weather'][0]['main']
            temperatur = jsonAntwort['main']['temp']
            min_Temperatur = jsonAntwort['main']['temp_min']
            max_Temperatur = jsonAntwort['main']['temp_max']
            luftdruck = jsonAntwort['main']['pressure']
            luftfeuchtigkeit = jsonAntwort['main']['humidity']
            wind = jsonAntwort['wind']['speed']
            sonnenaufgang = jsonAntwort['sys']['sunrise']
            sonnenuntergang = jsonAntwort['sys']['sunset']

            details = {'Ortschaft': ortschaft,
                       'Land': land,
                       'Wetter': wetter,
                       'Temperatur': temperatur,
                       'Min.Temperatur': min_Temperatur,
                       'Max.Temperatur': max_Temperatur,
                       'Luftdruck': luftdruck,
                       'Luftfeuchtigkeit': luftfeuchtigkeit,
                       'Windgeschwindigkeit': wind,
                       'Sonnenaufgang': sonnenaufgang,
                       'Sonnenuntergang': sonnenuntergang}
            ergebnisJSON['Informationen'] = details
            print("-------------------------------------------")
            print("| Ortschaft           :", ortschaft) if doTrace else False
            print("| Land                :", land) if doTrace else False
            print("| Wetter              :", wetter) if doTrace else False
            print("| Temperatur          :", temperatur) if doTrace else False
            print("| Min.Temperatur      :", min_Temperatur) if doTrace else False
            print("| Max. Temperatur     :", max_Temperatur) if doTrace else False
            print("| Luftdruck           :", luftdruck) if doTrace else False
            print("| Luftfeuchtigkeit    :", luftfeuchtigkeit) if doTrace else False
            print("| Windgeschwindigkeit :", wind) if doTrace else False
            print("| Sonnenaufgang       :", sonnenaufgang) if doTrace else False
            print("| Sonnenuntergang     :", sonnenuntergang) if doTrace else False
            print("-------------------------------------------")
            return ergebnisJSON




while True:
    suchkriterium = input("\nWelche Orschaft suchen Sie:")
    if len(suchkriterium) == 0:
        print("Suche beendet!")
        break

    suchkriteriumEncoded = suchkriterium.replace(" ", "%20")
    wetterstation = Wetterstation(suchkriteriumEncoded)
    results = wetterstation.getResults_Openweather(suchkriteriumEncoded, True)
    print(wetterstation.__str__())
    print(json.dumps(results, indent=4))

    test = Test()

