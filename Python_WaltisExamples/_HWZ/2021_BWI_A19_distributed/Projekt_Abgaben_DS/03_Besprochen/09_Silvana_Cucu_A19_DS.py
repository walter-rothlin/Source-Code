# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      (-) Absturz bei ungültigen User-Eingaben (ist aber in den Releasenotes so beschrieben)
#
# Class Design und Implementation:
#      - Diagramm stimmt nicht mit Code überein
#      + Notwendige (__eq__ __str__) Methoden vorhanden
#      + __init__ klare Signatur mit funktionierenden Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Instance Variablen sind public oder protected
#      -- WeatherstationCH ist eine static class
#      + returnDataCalculation() hilfreiche Methode (falscher Name)
#
# Test:
#      - Keine Test (positive wie negative) implementiert
#
# Note: 4.5
#
# Fragen:
#    Wo und wie wird der Request zum Web-Service abgesendet?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wie müssten Sie Refactorn, dass es eine richtige (non-static) Klasse wird?
# ------------------------------------------------------------------
import requests
import json
from datetime import datetime

"""
Das Klassendiagra, das .py-File als auch Notizen zum Vorgehen sind aufrufbar unter
Direker Zugriff gewährt für walter.rothlin@fh-hwz.ch und Walter@Rothlin.com
https://fhhwz-my.sharepoint.com/:f:/g/personal/silvana_cucu_student_fh-hwz_ch/Ejh75P48Bp1HtzuMc9CWJAIBWzMXXOYsGKtV-mudClBoqg?e=XWy9qK

"""
"""
Für diese CLI-Applikation wurden folgene Quellen für den Code verwendet 
* def __str__ in Anlehnung an https://www.pythontutorial.net/python-oop/python-__str__/
* def __eq__ in Anlehnung an https://www.geeksforgeeks.org/difference-between-__eq__-vs-is-vs-in-python/

Die Generierung des Request, des Response und der Umwandlung in JSON 
* Search Geo Admin https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_14_fHoch3/SearchLocationREST_Calls/Search_GeoAdmin.py
* Search tel Search https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_14_fHoch3/SearchLocationREST_Calls/Search_TelSearch.py
* CH Adress search https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_14_fHoch3/SearchLocationREST_Calls/CH_Adress_search.py

Für die allgemeine Funktionsweise on openweather.com
* Projektauftrag "Metodaten Munich", Winter 2020, abgegeben durch Silvana Cucu

Für die Umwandlung des Datums in die korrekte Zeitzone (UTC+1)
* https://stackoverflow.com/questions/30921399/datetime-fromtimestamp-vs-datetime-utcfromtimestamp-which-one-is-safer-to-use

Offene Punkte 
* Exception Handling bei unbekannten Orten 
* Enumeration für Sprachen

"""

print ("Das aktuelle Wetter an einem beliebigen Ort in der Schweiz auf einen Blick.\nGeben Sie einen Ort in der Schweiz ein und wählen Sie die Sprache (de, fr, en, it) aus.")
"""
    Die Einschränkung für das Land ist aktuell über das Klassenattribut fest programmiert. 
    Als personas für diese Applikation wurde ein benutzer gewählt für den die aktuell Temperatur und die Wetterlage eine Rolle spielen. Aktuell werden nur diese Werte aus der JSON Struktur verwendet.
    Für eine Erweiterung könnten verschiedene Personas implementiert werden, die am Anfang über einen Entscheidungsbaum abgefragt werden. 
    z.B. 1) Hundebesitzer, der mit Hund eine Runde Gassi geht, 2) Hobbygärtner, der auch Feuchtigkeit etc. abfragen möchte
    
"""
class WeatherstationCH:
    serviceURL = "http://api.openweathermap.org/data/2.5/weather?q={city},{country}&{appid}&{lang}&{units}"
    appID = "appid=144747fd356c86e7926ca91ce78ce170"
    country = "CH"
    city = ""
    lang = ""
    jsonResponse = None

    def __init__(self,  requestStr, responseStr, units, temperature):
        self._requestStr = requestStr
        self._responseStr = responseStr
        self.units = units
        self.temperature = temperature

    #def __str__ in Anlehnung an https://www.pythontutorial.net/python-oop/python-__str__/
    def __str__(self):
        return f'Weatherstation({self.requestStr}, {self.responseStr}, {self.units}, {self.temperature}'

    #def __eq__ in Anlehnung an https://www.geeksforgeeks.org/difference-between-__eq__-vs-is-vs-in-python/
    def __eq__(self, another):
        return self.country == another.country

    # Exceptionhandling fehlt noch
    def setCity ():
        WeatherstationCH.city =input("Eingabe Ort (*Zürich):")
        if WeatherstationCH.city == "":
            WeatherstationCH.city = "Zürich"
            return WeatherstationCH.city

    # Exceptionhandling fehlt noch
    def setLanguage ():
        WeatherstationCH.lang = input("Auswahl der Sprache (de,fr, it, en):")
        if WeatherstationCH.lang == "":
            WeatherstationCH.lang = "de"
            return WeatherstationCH.lang

    # Search Geo Admin https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_14_fHoch3/SearchLocationREST_Calls/Search_GeoAdmin.py
    # Search tel Search https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_14_fHoch3/SearchLocationREST_Calls/Search_TelSearch.py
    # CH Adress search https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_14_fHoch3/SearchLocationREST_Calls/CH_Adress_search.py

    def createjsonResponse( units ="units=metric"):
        city = WeatherstationCH.city
        lang = "lang="+WeatherstationCH.lang
        requestStr = WeatherstationCH.serviceURL.format(city=city, country=WeatherstationCH.country,
                                                        appid=WeatherstationCH.appID, lang=lang, units=units)
        responseStr = requests.get(requestStr)
        jsonResponse = json.loads(responseStr.text)

        WeatherstationCH.jsonResponse = jsonResponse

        return jsonResponse

    def returnTemperature(temperature =""):
        temperature = str(round(WeatherstationCH.jsonResponse['main']['temp']))
        return temperature

    def returnWeatherDescription():
        weatherDescription = WeatherstationCH.jsonResponse['weather'][0]['description']
        return weatherDescription

    def returnDataCalculation():
        dt = WeatherstationCH.jsonResponse['dt']
        dataCalculation = str(datetime.fromtimestamp(dt).strftime('%d.%m.%Y %H:%M:%S'))
        return dataCalculation



wetterstation = WeatherstationCH
wetterstation.setCity()
wetterstation.setLanguage()
wetterstation.createjsonResponse()
print("Die Temperatur in " + wetterstation.city + " beträgt " + wetterstation.returnTemperature() + " Grad","\nDas Wetter ist:", wetterstation.returnWeatherDescription(), "\nLetzte Messung der Wetterstation:", wetterstation.returnDataCalculation(), end="\n")

