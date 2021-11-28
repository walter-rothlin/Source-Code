# Description: Weather Klasse
#
# Autor: Joel Boss
#
# History:
#18.11.2021 Klasse erstellt und erste Methoden hinzugefügt.
#19.11.2021 Verzweifelt und vergeblich versucht die Parameter in der Klasse zu definieren. get.Methoden implementiert.
#19.11.2021 Eureka es ist vollbracht.
#20.11.2021 If statement hinzugefügt und json data formatiert.
#22.11.2021 Neue Methoden hinzugefügt und alle print() in die Klasse gepackt
#23.11.2021 Letzter Feinschliff am Code.

# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + Sehr einfache und intuitive Anwendung der Klasse in der Applikation gezeigt
#      - Absturz bei ungültigen User-Eingaben
#
# Class Design und Implementation:
#      - Diagramm stimmt nicht Code überein (z.B. getURL privat/public)
#      - Notwendige (__str__, __eq__) Methoden nicht vorhanden
#      + __init__ klare Signatur mit funktionierenden Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - nicht alle Instance Variablen sind private
#      - Weather Info wird 1:1 vom Openweather REST zurückgegeben (Keine Abstahierung!)
#      ++ URL Encoding und Parameter Uebergabe mit Dict und nicht String-Operationen
#      -- Für jeden einzelnen Wert wird ein REST-Request ausgelöst (Recourcen und run-time!!!)
#
# Test:
#      - Keine Test implementiert
#
# Note: 4.0
#
# Fragen:
#    Wo wird der Request zum Web-Service abgesendet?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Was wäre das nächste Refactoring der Klasse?











# ------------------------------------------------------------------
import requests, json

class Wetterstation:



    def __init__(self, url="https://api.openweathermap.org/data/2.5/weather", ort=input("From which City do you want the current weather data?:"), appid="3df0b9b0730de55d48f1253c89532595", mode="", units=input("Should the units be imperial or metric? For Kelvin just press Enter:"), lang="en"):
        self.__url = url #privat
        self.ort = ort
        self.__appid = appid #privat
        self.__mode = mode #privat
        self.units = units
        self.lang = lang

    def getURL(self):
        return self.__url

    def getOrt(self):
        return self.ort

    def getAppid(self):
        return self.__appid

    def getMode(self):
        return self.__mode

    def getUnits(self):
        return self.units

    def getLang(self):
        return self.lang

    def getParams(self):
        params = dict(q=self.getOrt(),appid=self.getAppid(), mode=self.getMode(), units=self.getUnits(), lang=self.getLang())
        return params

    def getResult(self):
        result = requests.get(url=self.getURL(), params=self.getParams())
        return result

    def getResponse(self):
        response = self.getResult()
        return response.text

    def getJsonrespone(self):
        jsonResponse = json.loads(self.getResponse())
        return jsonResponse

    def temperature(self):
        if self.getUnits() == "metric":
            temperature = "°C"
        elif self.getUnits() == "imperial":
            temperature = "Fahrenheit"
        else :
            temperature ="Kelvin"
        return temperature

    def overview(self):
        overview = print("___________________________________________________________________",
                    "\nCity Name                                  :", self.getJsonrespone()['name'],"|", self.getJsonrespone()['sys']['country'],
                    "\nThe current weathersituation is            :",(self.getJsonrespone()['weather'][0]['description']),
                    "\n___________________________________________________________________",
                    "\nTemperature   ",
                    "\nactual Temperature:                        :", self.getJsonrespone()['main']['temp'], self.temperature(),
                    "\nMinimum temperature at the moment          :", self.getJsonrespone()['main']['temp_min'], self.temperature(),
                    "\nMaximum temperature at the moment          :", self.getJsonrespone()['main']['temp_max'], self.temperature(),
                    "\n___________________________________________________________________",
                    "\nAtmospheric pressure",
                    "\nAtmospheric pressure on the sea level      :", self.getJsonrespone()['main']['pressure'], "hPa",
                    "\n___________________________________________________________________",
                    "\nClouds",
                    "\nCloudiness                                 :", self.getJsonrespone()['clouds']['all'], "%")

        return overview




    #Das weitere Vorgehen wäre mehrere Sprachen und eine Auswahlmöglichkeit der Daten zu implementieren.
    #def language(self):
       # if self.getLang() == "en"

wetterfrosch = Wetterstation()
print(wetterfrosch.overview())





#Notizen und alte Codesnippets
#1. Methode um Parameter und URL ausserhalb der Klass aufzurufen. Wure später durch getParams Methode ersetzt.
#params = dict(q=wetterfrosch.ort, appid=wetterfrosch.appid, mode=wetterfrosch.mode, units=wetterfrosch.units, lang=wetterfrosch.lang)
#response = requests.get(wetterfrosch.url, params=wetterfrosch.getParams())

#Um zu testen ob die Parameter sich ändern beim overloaden.
#print(wetterfrosch.getParams())
#print(json.dumps(jsonResponse, indent=4))


#Erste Versuche die Json data zu formatieren.
#print("  Coordinates")
#print("_________________________")
#print("  longitude                    :", jsonResponse['coord']['lon'])
#print("  latitude                     :", jsonResponse['coord']['lat'])
#print("///////////////////////////")
#print("  Weatherdetails")
#print("__________________________")