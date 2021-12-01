# ------------------------------------------------------------------
# Name: Erwin_Vogel_A19_DS.py
#
# Description: Weather Klasse
#
# Autor: Erwin Vogel BWI-A19
#
# UML Diagramm:
# https://fhhwz.sharepoint.com/sites/IntroductionintoPython/Freigegebene%20Dokumente/General/Pr%C3%BCfung%20Distributed%20&%20Mobile-Systems/Erwin_Vogel_A19_DS/UML_Erwin_Vogel_A19_DS.pdf
#
# Quellen:
# https://www.python-lernen.de/klassen-methoden-erstellen-und-aufrufen.htm
# https://www.python-forum.de/viewtopic.php?t=31967
#
# ------------------------------------------------------------------
import sys
import requests
import json
import time


# Wetter Klasse
class WetterKlasse(Exception):

    def __init__(self, code, message):
        """
        :param code:    Antwortcode der REST-API
        :param message: Nachricht der REST-API
        """
        self.code = code
        self.message = message

    def __str__(self):
        return "(" + str(self.code) + ") " + self.message

    def __eq__(self, other):
        pass

    # Methode für Rest-API CALL
    def getApiCall():
        openWeatherURL = "https://api.openweathermap.org/data/2.5/weather?"
        responseStr = requests.get(openWeatherURL + "q=" + messCity + "&units=metric&lang=de&appid=" + apiKey)

        # Ausgabe der Antwort - formatiert
        if responseStr.status_code == 200 or responseStr.status_code == 204:
            jsonResponse = json.loads(responseStr.text)

            name = jsonResponse['name']
            temp = jsonResponse['main']['temp']
            description = jsonResponse['weather'][0]['description']
            humidity = jsonResponse['main']['humidity']
            speed = jsonResponse['wind']['speed']
            print("----------------------------------------")
            print("Ortschaft:            " + name)
            print("Temperatur:           " + str(temp) + " °C")
            print("Wetter:               " + description)
            print("Feuchtigkeit:         " + str(humidity) + "%")
            print("Windgeschwindigkeit:  " + str(speed) + " m/s")
            print("----------------------------------------")

        # Ausgabe des Fehlers inkl. Fehlercode von openweather.org
        elif responseStr.status_code == 401 or responseStr.status_code == 404 or responseStr.status_code == 429:
            print()
            print("Fehler, siehe Antwort von REST-API -> " + str(WetterKlasse(responseStr.status_code, responseStr.json()['message'])))
            sys.exit()

        # Ausgabe der Antwort in JSON-String - unformatiert
        else:
            return responseStr.json()
 

# Hauptteil
if __name__ == '__main__':
    # Default-Werte
    defaultapiKey = "a270d7a3a3fa46cb0505638b7b99fe68"
    defaultmessTime = 10
    defaultmessCity = "Nottwil"
    defaultmessAgain = "ja"

    messCity = input("Messort (*" + defaultmessCity + "): ")
    if messCity == "":
        messCity = defaultmessCity
    messCity = str(messCity)

    messTime = input("Abstand Messzeit in Sekunden (*" + str(defaultmessTime) + ") [s]: ")
    if messTime == str(messTime):
        messTime = messTime.replace(str(messTime), str(defaultmessTime))
    if messTime == "":
        messTime = defaultmessTime
    messTime = float(messTime)

    apiKey = input("Own API Key: (*" + defaultapiKey + "): ")
    if apiKey == "":
        apiKey = defaultapiKey
    apiKey = str(apiKey)

    #Verwendung code while-Schlaufe from: https://github.com/walter-rothlin/Source-Code/blob/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_01.py
    makeLoop = True
    while makeLoop:
        responseVisualized = WetterKlasse.getApiCall()
        print(responseVisualized)

        time.sleep(messTime)

        messAgain = input("erneute Messung? (*" + defaultmessAgain + ")/nein: ")
        if messAgain == "":
            messAgain = defaultmessAgain
        messAgain = messAgain
        if messAgain == "nein":
            makeLoop = False

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# Testfall Usereingaben:
#
#   NOK Anzahl: 25x
#   OK Anzahl: 15x
#
#   NOK Fälle:  - Defaultwerte in Methode platziert und nicht im Hauptteil <- dadurch kann Methode nicht allgemein eingesetzt werden
#               - Methode nicht der Klasse zugeordnet <- falsch eingerückt
#               - unformatierter Response von API <- nicht oder nur schwierig lesbar für den User
#               - Fehlererror Codes von API nicht alle aufgeführt <- falscher Ausgang gewählt bei if oder elif
#               - Einbindung der Klasse war noch zu wenig klar <- musste nochmals Dokumentationen lesen und Anwendungsbeispiele dazu durcharbeiten
#               - Defaultwert API Key in Methode und im Hauptteil doppelt aufgeführt <- Test ist nie fehlgeschalgen mit falschem API Key
#               - fehlende Defaultwerte, dadurch sind bei Falscheingaben keine Calls generiert worden
#               - fehlendes Exceptionhandling <- Eingabe von String bei Abstand Messzeit ergab immer einen Abbruch (String wird nun mit Default MessTime ersetzt)
#               - fehlender Ausgang aus der while-Schlaufe <- Abfrage für erneute Messung eingerichtet (kein Exceptionhandling für Falscheingaben erweitert)
#
#   OK Fälle:   - Usereingaben wurden soweit unterstützt, das Defaultwerte angezeigt und verwendet werden
#               - Exceptionhandling wurde abgedeckt, damit falscheingaben zu einem Exit mit entsprechender Fehlermeldung führen
#               - Abfrage in while-Schlaufe funktioniert und gibt dem User die Möglichkeit nochmals eine Kontrollmessung zu machen, sofern er diese allenfalls für
#                 seine Arbeit benötigt. Zum Beispiel für einen Winterdienstmitarbeiter, wlecher die exakten werte oder die Veränderung benötigt um loszufahren.
#               - Fehlerhandling soll dem User visualisiert werden und nicht nur zu einem Abbruch führen.
#               - Ausgang else in Methode geteste, indem ich den Code 200 entfernt habe
#               - Usability mit Fachtester geprüft
#               - OK - Erfolgreicher Test für Produktivsetzung von Businessresponible eingeholt
#
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------
