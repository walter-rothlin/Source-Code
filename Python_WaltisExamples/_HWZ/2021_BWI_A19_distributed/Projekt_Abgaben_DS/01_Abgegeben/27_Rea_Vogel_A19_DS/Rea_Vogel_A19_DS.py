# ------------------------------------------------------------------
# Review-Results (TBD):
# Reference-Applikation:
#      + Funktioniert
#      - Keine User-Eingaben möglich
#
# Class Design und Implementation:
#      + Diagramm stimmt grösstenteils mit Code überein (+ / - für private / public)
#      + Notwendige (__eq__ __str__ __eq__) Methoden vorhanden
#      - __init__ unnötige parameter und die relevanten haben keine Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Instance Variablen sind public
#      + __str__ mit format-strings implementiert
#
# Test:
#      + Test (positive) implementiert
#
# Note: 5.0
#
# Fragen:
#    Auf welcher Zeile wird der Request zum Web-Service abgesendet?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
# Name:                             Rea_Vogel_A19_DS.py
#
# Description:                      Does a search via REST request to OpenWeather (JSON)
#
# Autor:                            Rea Vogel
#
# History:
# 17-Nov-2021       Rea Vogel       Initial functional Version
# 18-Nov-2021       Rea Vogel       implementing class, __int__, __str__, __eq__, toString
# 19-Nov-2021       Rea Vogel       implementing Test Application
# 20-Nov-2021       Rea Vogel       insert Unit-Testing
# 21-Nov-2021       Rea Vogel       write comments & docstrings / check Design & Clean Code Rules
# 22-Nov-2021       Rea Vogel       Final Version
#
# ---------------------------------------------------- Dokumentation ---------------------------------------------------
# OpenWeather (Test-URL):           http://api.openweathermap.org/data/2.5/weather?q=Luzern%20CH&appid=5415138bea24623d399d24c0d71290ef
# API Dokumentation:                https://openweathermap.org/current
# Weather Data Description:         https://openweathermap.org/weather-data
# Class Diagram Genmymodel.com:     https://app.genmymodel.com/api/projects/_NjtOoEeNEeyo8oS76GR6Gg/diagrams/_NjtOo0eNEeyo8oS76GR6Gg/svg
# Class Diagram Sharepoint (PDF):   https://fhhwz-my.sharepoint.com/:b:/g/personal/rea_vogel_student_fh-hwz_ch/EeB4kIvFWqtEsWUNTIZJU8UBeJg8OQ7SaIXz1pgp3RpGxQ?e=RYwZCv
# Testing File (unit-tests):        https://fhhwz-my.sharepoint.com/:u:/g/personal/rea_vogel_student_fh-hwz_ch/EWzaC6INbPxNrlq7Dk9WhTIBBcZLjRIh75K9OMSjErFsZA?e=11L4uE
# Projektauftrag:                   https://myhwz.fh-hwz.ch/pluginfile.php/92681/mod_resource/content/4/ProjektAuftrag_Distributed_Systems_2021_11_16.pdf
# ----------------------------------------------------------------------------------------------------------------------

import json
from tabulate import tabulate
from datetime import datetime
from waltisLibrary import *

"""
Erstellung einer Hauptklasse zur allgemeinen Instanzierung einer Wetterstation. Als Haupt-Webservice wird dabei 
OpenWeather verwendet. Dies kann jedoch mit Übergabe neuer Parameter eines anderen Wetter-Webservices überschrieben 
werden. Diese Hauptklasse wird an die Unterklasse "OpenWeather" vererbt. Es können infolge dessen noch weitere
Subklassen für andere Wetter-Webservices erstellt werden, welche die Instanzierung und Methoden der Hauptklasse erben.
"""


# ---------------------------------------- Hauptklasse / erstellt Wetterstation ----------------------------------------
class WeatherStation:
    def __init__(self, searchCriteriaEncoded="", appId="5415138bea24623d399d24c0d71290ef",
                 serviceURL="http://api.openweathermap.org/data/2.5/weather?q={search:2s}&appid={appId:2s}"):

        print("\n")
        print("-----------------------------------------------------------------------")
        print("Neue Abfrage")
        print("-----------------------------------------------------------------------")
        self.__searchCriteriaEncoded = searchCriteriaEncoded
        if searchCriteriaEncoded == "":
            searchCriteriaEncoded = self.__setSearchCriteria()

        else:
            self.__searchCriteriaEncoded = searchCriteriaEncoded

        self.__appId = appId
        self.__serviceURL = serviceURL

        self.__jsonResponse = self.setJSONResponse(searchCriteriaEncoded, appId, serviceURL)

    def __str__(self):
        return "Suchkriterium: {criteria}  |  Key: {appId}  |  URL: {url}".format(criteria=self.__searchCriteriaEncoded,
                                                                                  appId=self.__appId,
                                                                                  url=self.__serviceURL)

    def __eq__(self, other):
        return self.__searchCriteriaEncoded == other.__searchCriteriaEncoded

    def toString(self, desc, part="str", val=0, sign=""):
        retStr = ""
        if part == "title":
            retStr += "{description}".format(description=desc)
        elif part == "int":
            retStr += "{description}: {val:.2f}{sign}".format(description=desc, val=val, sign=sign)
        elif part == "str":
            retStr += "{description}: {val}{sign}".format(description=desc, val=val, sign=sign)
        return retStr

    def getJSONResponse(self):
        return self.__jsonResponse

    @staticmethod
    def setJSONResponse(searchCriteriaEncoded, appId, serviceURL):
        requestStr = serviceURL.format(search=searchCriteriaEncoded, appId=appId)
        # Übergabe des Suchkriteriums sowie der AppId --> definierte Variabel

        responseStr = requests.get(requestStr)
        jsonResponse = json.loads(responseStr.text)

        return jsonResponse

    def __setSearchCriteria(self):
        while True:
            searchCriteria = input("Suchkriterium (Ortschaftsnamen)  : ")
            if len(searchCriteria) == 0:
                print("Keine Eingabe! Erneute Abfrage!\n")
                continue

            searchCriteriaEncoded = searchCriteria.replace(" ", "%20")

            return searchCriteriaEncoded


# ----------------------------------- Unterklasse / Bezieht Daten von WeatherStation -----------------------------------
class OpenWeather(WeatherStation):

    def getResults_OpenWeather(self, jsonResponse):
        """
        Herausziehen sämtlicher Details aus JSON Response und Speicherung in Dictionary. So sind sämtliche Details
        in den Methoden abrufbar. Untengenannte Kommentare zu den einzelnen Details aus der Weather Data Description,
        API-Dokumentation und von Google entnommen.
        """
        details = {}
        details['lon'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['coord', 'lon'])
        details['lat'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['coord', 'lat'])
        details['weatherId'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['weather', 0, 'id'])
        details['weather'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['weather', 0, 'main'])
        # Group of weather parameters (Rain, Snow, Extreme etc.)
        details['weatherDesc'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['weather', 0, 'description'])
        # Weather condition within the group
        details['weatherIcon'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['weather', 0, 'icon'])
        details['base'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['base'])
        details['temp'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['main', 'temp'])
        # conversion rate is 273.15 / Celsius formula: temp - 273.15 / Fahrenheit formula: (temp - 273.15)*(9/5)+32
        details['temp_feelslike'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['main', 'feels_like'])
        # conversion rate is 273.15 / Celsius formula: temp - 273.15 / Fahrenheit formula: (temp - 273.15)*(9/5)+32
        details['temp_min'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['main', 'temp_min'])
        # conversion rate is 273.15 / Celsius formula: temp - 273.15 / Fahrenheit formula: (temp - 273.15)*(9/5)+32
        details['temp_max'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['main', 'temp_max'])
        # conversion rate is 273.15 / Celsius formula: temp - 273.15 / Fahrenheit formula: (temp - 273.15)*(9/5)+32
        details['pressure'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['main', 'pressure'])
        # in Hektopascal ( 1 hPa = 100 Pascal; 1 Pa = 1 Newton)
        details['humidity'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['main', 'humidity'])
        # in %
        details['visibility'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['visibility'])
        # in m (1km = 1000m)
        details['windspeed'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['wind', 'speed'])
        # in m/s (1m/s = 2.237mph)
        details['wind_deg'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['wind', 'deg'])
        # in degrees
        details['wind_gust'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['wind', 'gust'])
        # in m/s
        details['clouds'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['clouds', 'all'])
        # in %
        details['rain_lasthour'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['rain', '1h'])
        # Rain volume for the last 1 hour, in mm
        details['rain_over3h'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['rain', '3h'])
        # Rain volume for the last 3 hours, in mm
        details['snow_lasthour'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['snow', '1h'])
        #  Snow volume for the last 1 hour, in mm
        details['snow_over3h'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['snow', '3h'])
        # Snow volume for the last 3 hours, in mm
        details['dt'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['dt'])
        # unix (Multi-user operating system), UTC (Coordinated Universal Time)
        details['sysType'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['sys', 'type'])
        details['sysId'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['sys', 'id'])
        details['country'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['sys', 'country'])
        details['sunrise'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['sys', 'sunrise'])
        # unix (Multi-user operating system), UTC (Coordinated Universal Time)
        details['sunset'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['sys', 'sunset'])
        # unix (Multi-user operating system), UTC (Coordinated Universal Time)
        details['timezone'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['timezone'])
        # Shift in seconds from UTC (Coordinated Universal Time)
        details['cityId'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['id'])
        details['city'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['name'])
        details['cod'] = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['cod'])

        """
        Überprüfung ob eingegebenes Suchkriterium gefunden wird oder nicht. Wenn nicht, soll das Programm beendet 
        werden. Erweiterungsmöglichkeit, dass Programm wieder an den Anfang zurückspringt und neues Suchkriterium 
        abfragt.
        """
        cod = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['cod'])

        if cod == "404":
            print("\nStadt nicht gefunden")
            print("Abfrage beendet!")
            print("-----------------------------------------------------------------------")
            exit("\nRestart Programme")

        else:
            criteria = self.__getFieldFromJSONWeatherSearch(jsonResponse, ['name'])

            returnJSON = {'criteria': criteria,
                          'results': []}

            returnJSON['results'].append(details)

            return returnJSON

    def getSearchCriteria(self, results):
        city = results['results'][0]['city']
        return city

    def __getFieldFromJSONWeatherSearch(self, search_Entry, dictKey):
        try:
            # Prüfung wie viele Key's übergeben wurden
            if len(dictKey) == 1:
                retVal = search_Entry[dictKey[0]]
            elif len(dictKey) == 2:
                retVal = search_Entry[dictKey[0]][dictKey[1]]
            else:
                retVal = search_Entry[dictKey[0]][dictKey[1]][dictKey[2]]

        # Verhinderung eines Fehlers, falls eingegebener Index  in JSON Response nicht verfügbar sind
        except IndexError:
            retVal = "---"

        # Verhinderung eines Fehlers, falls eingegebener Key  in JSON Response nicht verfügbar ist
        except KeyError:
            retVal = "---"

        return retVal

    def __setInput(self, size, val1, val2, val3):
        """
        Strukturiert Inputabfragen und überprüft Eingabe ob effektiv eine Zahl übergeben wurde. Wenn nicht, breaked das
        Programm und springt aus der while-Schleife (in der Test Applikation zurück ins Menü).
        """
        while True:
            try:
                print(unterstreichen("\n{soughtSize} in {con_val1} [1], {con_val2} [2] oder {con_val3} [3] erhalten?"
                                     .format(soughtSize=size, con_val1=val1, con_val2=val2, con_val3=val3)))
                choice = int(input("Eingabe: "))
                return choice
            except ValueError:
                print("Keine Zahl eingegeben!")
                break

    def getTemperatureDetails(self, results, choice=None):
        while True:
            # Eingabe der gewünschten Grösse für Angabe der Temperatur
            if choice == None:
                choice = self.__setInput("Temperatur", "Grad Celius", "Fahrenheit", "Kelvin")

            temp = results['results'][0]['temp']
            temp_min = results['results'][0]['temp_min']
            temp_max = results['results'][0]['temp_max']
            temp_feelslike = results['results'][0]['temp_feelslike']
            conversion_rate = 273.15

            # Umrechung in Grad Celsius (Metric / Formel gem. Google Converter  https://www.google.com/search?client=firefox-b-d&q=umrechnung+kelvin+in+celsius)
            if choice == 1:
                temp = temp - conversion_rate
                temp_min = temp_min - conversion_rate
                temp_max = temp_max - conversion_rate
                temp_feelslike = temp_feelslike - conversion_rate
                sign = "°C"

            # Umrechung in Fahrenheit (Imperial / Formel gem. Google Converterhttps://www.google.com/search?client=firefox-b-d&q=umrechnung+kelvin+in+fahrenheit)
            elif choice == 2:
                temp = (temp - conversion_rate) * (9 / 5) + 32
                temp_min = (temp_min - conversion_rate) * (9 / 5) + 32
                temp_max = (temp_max - conversion_rate) * (9 / 5) + 32
                temp_feelslike = (temp_feelslike - conversion_rate) * (9 / 5) + 32
                sign = "°F"

            elif choice == 3:
                sign = " Kelvin"

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                break

            print("\n", unterstreichen(self.toString("Temperaturdetails:                       ", "title")))
            print(self.toString("Aktuelle Temperatur              ", "int", temp, sign))
            print(self.toString("Gefühlte Temperatur              ", "int", temp_feelslike, sign))
            print(self.toString("Mindesttemperatur                ", "int", temp_min, sign))
            print(self.toString("Höchsttemperatur                 ", "int", temp_max, sign))

            details = {'temp': temp, 'temp_min': temp_min, 'temp_max': temp_max, 'temp_feelslike': temp_feelslike}
            return details

    def getWindDetails(self, results, choice=None):
        while True:
            windspeed_result = results['results'][0]['windspeed']
            wind_direction = results['results'][0]['wind_deg']
            wind_gust_result = results['results'][0]['wind_gust']

            # Berechnung der Windrichtung (Unterteilung in 8 Himmelsrichtungen --> 360 / 8 = 45° pro Himmelsrichtung)
            if 45 <= wind_direction < 90:
                direction = "NE"

            elif 90 <= wind_direction < 135:
                direction = "E"

            elif 135 <= wind_direction < 180:
                direction = "SE"

            elif 180 <= wind_direction < 225:
                direction = "S"

            elif 225 <= wind_direction < 270:
                direction = "SW"

            elif 270 <= wind_direction < 315:
                direction = "W"

            elif 315 <= wind_direction < 360:
                direction = "NW"

            else:
                direction = "N"

            # Eingabe der gewünschten Grösse für Angabe der Windgeschwindigkeit
            if choice == None:
                choice = self.__setInput("Windgeschwindigkeit", "Knoten", "Meilen pro Stunde", "Meter pro Sekunde")

            # Umrechnung in Knoten (für See- und Luftfahrt)
            if choice == 1:
                knots = 1.944
                windspeed = windspeed_result * knots
                if wind_gust_result == "---":
                    wind_gust = 0
                else:
                    wind_gust = wind_gust_result * knots
                sign = " Knoten"

            # Umrechnung in Meilen pro Stunde (Imperial)
            elif choice == 2:
                miles = 2.237
                windspeed = windspeed_result * miles
                if wind_gust_result == "---":
                    wind_gust = 0
                else:
                    wind_gust = wind_gust_result * miles
                sign = "mph"

            # Umrechnung in Meter pro Sekunde (Metric)
            elif choice == 3:
                windspeed = windspeed_result
                if wind_gust_result == "---":
                    wind_gust = 0
                else:
                    wind_gust = wind_gust_result
                sign = "m/s"

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                break

            print("\n", unterstreichen(self.toString("Winddetails:                             ", "title")))
            print(self.toString("Aktuelle Windgeschwindigkeit     ", "int", windspeed, sign))
            print(self.toString("Windrichtung (in Grad)           ", "int", wind_direction, sign="°"))
            print(self.toString("Windrichtung (Himmelsrichtung)   ", "str", direction))
            print(self.toString("Windböen                         ", "int", wind_gust, sign))

            details = {'windspeed': windspeed, 'wind_deg': wind_direction, 'wind_gust': wind_gust}
            return details

    def getAirDetails(self, results, press_choice=None, sight_choice=None):
        while True:
            pressure_result = results['results'][0]['pressure']
            humidity = results['results'][0]['humidity']
            visibility_result = results['results'][0]['visibility']

            # Eingabe der gewünschten Grösse für Angabe des Luftdrucks
            if press_choice == None:
                press_choice = self.__setInput("Luftdruck", "Hektopascal", "Newton pro Quadratmeter", "Millibar")

            if press_choice == 1:
                pressure = pressure_result
                press_sign = "hPa"

            # Umrechnung des Luftdrucks in Newton pro Quadratmeter
            elif press_choice == 2:
                newton = 100
                pressure = pressure_result * newton
                press_sign = "Newton/Quadratmeter"

            # Umrechnung des Luftdrucks in Millibar
            elif press_choice == 3:
                pressure = pressure_result
                press_sign = "mbar"

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                break

            # Eingabe der gewünschten Grösse für Angabe der Sichtweite
            if sight_choice == None:
                sight_choice = self.__setInput("Sichtweite", "Meilen", "Meter", "Kilometer")

            # Umrechnung der Sichtweite in Meilen
            if sight_choice == 1:
                miles = 1.609
                visibility = visibility_result / miles
                sign = " Meilen"

            elif sight_choice == 2:
                visibility = visibility_result
                sign = "m"

            # Umrechnung der Sichtweite in Kilometer
            elif sight_choice == 3:
                meter = 1000
                visibility = visibility_result / meter
                sign = "km"

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                break

            print("\n", unterstreichen(self.toString("Luftdetails:                             ", "title")))
            print(self.toString("Aktueller Luftdruck              ", "int", pressure, press_sign))
            print(self.toString("Luftfeuchtigkeit                 ", "int", humidity, sign="%"))
            print(self.toString("Sichtweite                       ", "int", visibility, sign))

            details = {'pressure': pressure, 'humidity': humidity, 'visibility': visibility}
            return details

    def getWeatherDetails(self, results, temp_choice=None, wind_choice=None, press_choice=None, sight_choice=None):
        while True:
            # Eingabe der gewünschten Grössen für Angabe der Details
            if temp_choice == None:
                temp_choice = self.__setInput("Temperatur", "Grad Celius", "Fahrenheit", "Kelvin")

            if wind_choice == None:
                wind_choice = self.__setInput("Windgeschwindigkeit", "Knoten", "Meilen pro Stunde", "Meter pro Sekunde")

            if press_choice == None:
                press_choice = self.__setInput("Luftdruck", "Hektopascal", "Newton pro Quadratmeter", "Millibar")

            if sight_choice == None:
                sight_choice = self.__setInput("Sichtweite", "Meilen", "Meter", "Kilometer")

            """
            Herausziehen der gewünschten Details aus den Resultaten. Kann um weitere Details ergänzt werden. Diese 
            müssen jedoch beim print-Statement manuell nachgeführt werden sowie auch das input-Statement falls ein 
            solches benötigt wird. Dabei gilt ebenfalls zu beachten, dass bei einem Input die if/else-Schleife 
            hinzugefügt werden muss mit der entsprechendem "Sign" für die gewünschte Grösse.
            """
            city = results['results'][0]['city']
            country = results['results'][0]['country']
            weather = results['results'][0]['weather']
            weatherDesc = results['results'][0]['weatherDesc']
            clouds = results['results'][0]['clouds']
            timezone_result = results['results'][0]['timezone']
            sunrise_result = int(results['results'][0]['sunrise'])
            sunset_result = int(results['results'][0]['sunset'])
            temp = results['results'][0]['temp']
            temp_min = results['results'][0]['temp_min']
            temp_max = results['results'][0]['temp_max']
            windspeed_result = results['results'][0]['windspeed']
            wind_direction = results['results'][0]['wind_deg']
            wind_gust_result = results['results'][0]['wind_gust']
            temp_feelslike = results['results'][0]['temp_feelslike']
            pressure_result = results['results'][0]['pressure']
            humidity = results['results'][0]['humidity']
            visibility_result = results['results'][0]['visibility']

            """
            Angabe der Zeitzone resp. Abweichung der GMT (Greenwich Mean Time Zone) wenn positiv wird ein + 
            hinzugefügt ansonsten bleibt das Vorzeichen negativ
            """
            if timezone_result <= 0:
                timezone = timezone_result / 3600

            else:
                timezone = "+" + str(timezone_result / 3600)

            """
            Angabe der Zeitzone resp. Abweichung der GMT (Greenwich Mean Time Zone) wenn positiv wird ein + 
            hinzugefügt ansonsten bleibt das Vorzeichen negativ
            """
            sunrise = datetime.datetime.utcfromtimestamp(sunrise_result).strftime('%Y-%m-%d %H:%M:%S')
            # copied from https://stackoverflow.com/questions/3682748/converting-unix-timestamp-string-to-readable-date

            sunset = datetime.datetime.utcfromtimestamp(sunset_result).strftime('%Y-%m-%d %H:%M:%S')
            # copied from https://stackoverflow.com/questions/3682748/converting-unix-timestamp-string-to-readable-date

            conversion_rate = 273.15
            # Umrechung in Grad Celsius (Metric / Formel gem. Google Converter  https://www.google.com/search?client=firefox-b-d&q=umrechnung+kelvin+in+celsius)
            if temp_choice == 1:
                temp = temp - conversion_rate
                temp_min = temp_min - conversion_rate
                temp_max = temp_max - conversion_rate
                temp_feelslike = temp_feelslike - conversion_rate
                temp_sign = "°C"

            # Umrechung in Fahrenheit (Imperial / Formel gem. Google Converterhttps://www.google.com/search?client=firefox-b-d&q=umrechnung+kelvin+in+fahrenheit)
            elif temp_choice == 2:
                temp = (temp - conversion_rate) * (9 / 5) + 32
                temp_min = (temp_min - conversion_rate) * (9 / 5) + 32
                temp_max = (temp_max - conversion_rate) * (9 / 5) + 32
                temp_feelslike = (temp_feelslike - conversion_rate) * (9 / 5) + 32
                temp_sign = "°F"

            elif temp_choice == 3:
                temp_sign = " Kelvin"

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                break

            # Berechnung der Windrichtung (Unterteilung in 8 Himmelsrichtungen --> 360 / 8 = 45° pro Himmelsrichtung)
            if 45 <= wind_direction < 90:
                direction = "NE"

            elif 90 <= wind_direction < 135:
                direction = "E"

            elif 135 <= wind_direction < 180:
                direction = "SE"

            elif 180 <= wind_direction < 225:
                direction = "S"

            elif 225 <= wind_direction < 270:
                direction = "SW"

            elif 270 <= wind_direction < 315:
                direction = "W"

            elif 315 <= wind_direction < 360:
                direction = "NW"

            else:
                direction = "N"

            # Umrechnung in Knoten (für See- und Luftfahrt)
            if wind_choice == 1:
                knots = 1.944
                windspeed = windspeed_result * knots
                if wind_gust_result == "---":
                    wind_gust = 0
                else:
                    wind_gust = wind_gust_result * knots
                wind_sign = " Knoten"

            # Umrechnung in Meilen pro Stunde (Imperial)
            elif wind_choice == 2:
                miles = 2.237
                windspeed = windspeed_result * miles
                if wind_gust_result == "---":
                    wind_gust = 0
                else:
                    wind_gust = wind_gust_result * miles
                wind_sign = "mph"

            # Umrechnung in Meter pro Sekunde (Metric)
            elif wind_choice == 3:
                windspeed = windspeed_result
                if wind_gust_result == "---":
                    wind_gust = 0
                else:
                    wind_gust = wind_gust_result
                wind_sign = "m/s"

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                break

            if press_choice == 1:
                pressure = pressure_result
                press_sign = "hPa"

            # Umrechnung des Luftdrucks in Newton pro Quadratmeter
            elif press_choice == 2:
                newton = 100
                pressure = pressure_result * newton
                press_sign = "Newton/Quadratmeter"

            # Umrechnung des Luftdrucks in Millibar
            elif press_choice == 3:
                pressure = pressure_result
                press_sign = "mbar"

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                break

            # Umrechnung der Sichtweite in Meilen
            if sight_choice == 1:
                miles = 1.609
                visibility = visibility_result / miles
                sign = " Meilen"

            elif sight_choice == 2:
                visibility = visibility_result
                sign = "m"

            # Umrechnung der Sichtweite in Kilometer
            elif sight_choice == 3:
                meter = 1000
                visibility = visibility_result / meter
                sign = "km"

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                break

            print("\n", unterstreichen(self.toString("Wetterdetails:                           ", "title")))
            print(self.toString("Ortschaft                        ", "str", city))
            print(self.toString("Land                             ", "str", country))
            print(self.toString("Aktuelles Wetter                 ", "str", weather))
            print(self.toString("Wetterbeschreibung               ", "str", weatherDesc))
            print(self.toString("Bewölkung                        ", "int", clouds, sign="%"))
            print(self.toString("Zeitzone                         ", "str", timezone))
            print(self.toString("Sonnenaufgang (GMT)              ", "str", sunrise))
            print(self.toString("Sonnenuntergang (GMT)            ", "str", sunset))
            print("\n", unterstreichen(self.toString("Temperaturdetails:                       ", "title")))
            print(self.toString("Aktuelle Temperatur              ", "int", temp, temp_sign))
            print(self.toString("Gefühlte Temperatur              ", "int", temp_feelslike, temp_sign))
            print(self.toString("Mindesttemperatur                ", "int", temp_min, temp_sign))
            print(self.toString("Höchsttemperatur                 ", "int", temp_max, temp_sign))
            print("\n", unterstreichen(self.toString("Winddetails:                             ", "title")))
            print(self.toString("Aktuelle Windgeschwindigkeit     ", "int", windspeed, wind_sign))
            print(self.toString("Windrichtung (in Grad)           ", "int", wind_direction, sign="°"))
            print(self.toString("Windrichtung (Himmelsrichtung)   ", "str", direction))
            print(self.toString("Windböen                         ", "int", wind_gust, wind_sign))
            print("\n", unterstreichen(self.toString("Luftdetails:                             ", "title")))
            print(self.toString("Aktueller Luftdruck              ", "int", pressure, press_sign))
            print(self.toString("Luftfeuchtigkeit                 ", "int", humidity, sign="%"))
            print(self.toString("Sichtweite                       ", "int", visibility, sign))

            details = {'weather': weather, 'weatherDesc': weatherDesc, 'clouds': clouds, 'timezone': timezone,
                       'sunrise': sunrise, 'sunset': sunset, 'temp': temp, 'temp_min': temp_min, 'temp_max': temp_max,
                       'temp_feelslike': temp_feelslike, 'windspeed': windspeed, 'wind_deg': wind_direction,
                       'wind_gust': wind_gust, 'pressure': pressure,
                       'humidity': humidity, 'visibility': visibility, }
            return details

    def getCityDetails(self, results):

        city = results['results'][0]['city']
        country = results['results'][0]['country']
        timezone_result = results['results'][0]['timezone']
        sunrise_result = int(results['results'][0]['sunrise'])
        sunset_result = int(results['results'][0]['sunset'])
        lon = results['results'][0]['lon']
        lat = results['results'][0]['lat']

        """
        Angabe der Zeitzone resp. Abweichung der GMT (Greenwich Mean Time Zone) wenn positiv wird ein + 
        hinzugefügt ansonsten bleibt das Vorzeichen negativ
        """
        if timezone_result <= 0:
            timezone = timezone_result / 3600

        else:
            timezone = "+" + str(timezone_result / 3600)

        sunrise = datetime.datetime.utcfromtimestamp(sunrise_result).strftime('%Y-%m-%d %H:%M:%S')
        # copied from https://stackoverflow.com/questions/3682748/converting-unix-timestamp-string-to-readable-date

        sunset = datetime.datetime.utcfromtimestamp(sunset_result).strftime('%Y-%m-%d %H:%M:%S')
        # copied from https://stackoverflow.com/questions/3682748/converting-unix-timestamp-string-to-readable-date

        print("\n", unterstreichen(self.toString("Stadtdetails:                            ", "title")))
        print(self.toString("Ortschaft                        ", "str", city))
        print(self.toString("Land                             ", "str", country))
        print(self.toString("Zeitzone                         ", "str", timezone))
        print(self.toString("Sonnenaufgang (GMT)              ", "str", sunrise))
        print(self.toString("Sonnenuntergang (GMT)            ", "str", sunset))
        print(self.toString("Längengrad                       ", "str", lon))
        print(self.toString("Breitengrad                      ", "str", lat))

        # Abgefragte Details in Dictionary schreiben zur weiteren Verwendung. Werden bei Abschluss der Abfrage wiedergegeben.
        details = {'city': city, 'country': country, 'timezone': timezone, 'sunrise': sunrise, 'sunset': sunset,
                   'lon': lon, 'lat': lat}
        return details

    def getCoordinatesWeatherStation(self, results):
        # Abfrage der Koordinaten, welche weiterverwendet werden können (bspw. GeoAdmin)
        lon = results['results'][0]['lon']
        lat = results['results'][0]['lat']

        print("\n", unterstreichen(self.toString("Koordinaten:                             ", "title")))
        print(self.toString("Längengrad                       ", "str", lon))
        print(self.toString("Breitengrad                      ", "str", lat))

        details = {'lon': lon, 'lat': lat}
        return details


# ------------------------------- Testfunktion zum Testen aller implementierten Methoden -------------------------------
def test_WeatherStation():
    """
    Testfunktion zum testen der verschiedenen Methoden ob diese die korrekten Details zurückgeben.
    """
    myWS = OpenWeather()

    results = myWS.getResults_OpenWeather(myWS.getJSONResponse())

    returnResults = {'criteria': myWS.getSearchCriteria(results),
                     'results': []}

    print("\n", json.dumps(results, indent=4))

    print("\n")
    temperature = myWS.getTemperatureDetails(results)
    print("\n", json.dumps(temperature, indent=4))
    returnResults['results'].append(temperature)

    wind = myWS.getWindDetails(results)
    print("\n", json.dumps(wind, indent=4))
    returnResults['results'].append(wind)

    air = myWS.getAirDetails(results)
    print("\n", json.dumps(air, indent=4))
    returnResults['results'].append(air)

    weather = myWS.getWeatherDetails(results)
    print("\n", json.dumps(weather, indent=4))
    returnResults['results'].append(weather)

    cityDetails = myWS.getCityDetails(results)
    print("\n", json.dumps(cityDetails, indent=4))
    returnResults['results'].append(cityDetails)

    coord = myWS.getCoordinatesWeatherStation(results)
    print("\n", json.dumps(coord, indent=4))
    returnResults['results'].append(coord)

    print(json.dumps(returnResults, indent=4))


if __name__ == '__main__':
    if False:
        test_WeatherStation()


# ---------------------------------------- Funktionen für Main / Test-Interface ----------------------------------------
def toTable(temp, wind, air, weather, city, coord, result, new, end):
    headers = ["#", "Menü"]
    table = [[1, temp], [2, wind], [3, air], [4, weather], [5, city], [6, coord], [7, result], [8, new], [9, end]]
    retStr = tabulate(table, headers, tablefmt="pretty")
    return retStr


def showMenu():
    """
    Aufruf des Hauptmenüs mit der toTable Funktion. Dabei wird ebenfalls die Eingabe geprüft ob eine Zahl, ein Buchstabe
    oder nichts eingegeben wurde. Zudem wird geprüft ob die eingegebene Zahl zwischen 1 und 9 liegt. Wenn nicht wird
    die Schleife weiter geführt und das Hauptmenü erneut angezeigt.
    """
    while True:
        try:
            table = (toTable("Temperaturdetails", "Winddetails", "Luftdetails", "Alle Wetterdetails",
                             "Ortschaftsdetails", "Koordinaten", "Resultate (JSON Format)", "Neue Abfrage",
                             "Abfrage beenden"))
            print("\n", table)
            menu_choice = int(input("Eingabe: "))
            if 0 < menu_choice <= 9:
                menu = menu_choice
                query = __queryDetails(menu)
                if query == False:
                    return
                else:
                    continue

            else:
                print("Inkorrekte Eingabe! Erneute Abfrage!\n")
                continue

        except ValueError:
            print("Keine Zahl eingegeben!")
            continue


def __queryDetails(menu):
    """
    Private Funktion, welche nur innerhalb der showMenu() Funktion verwendet wird. Es gibt keinen direkten Zugriff
    auf diese Funktion. Zu beachten gilt, das else-Statement bei direkt mitgegebenen Parameter "SearchCriteriaEncoded"
    bei der WeatherStation- oder OpenWeather-Klasse nicht greift resp. dass bei der Auswahl der Nr. 8 danach kein neues
    Suchkriterium eingegeben werden kann.
    """
    while True:
        if menu == 1:
            temperature = myWS.getTemperatureDetails(results)
            returnResults['results'].append(temperature)
            print("\n")
            halt("Zurück zum Menü [Enter]")
            return True

        elif menu == 2:
            wind = myWS.getWindDetails(results)
            returnResults['results'].append(wind)
            print("\n")
            halt("Zurück zum Menü [Enter]")
            return True

        elif menu == 3:
            air = myWS.getAirDetails(results)
            returnResults['results'].append(air)
            print("\n")
            halt("Zurück zum Menü [Enter]")
            return True

        elif menu == 4:
            weather = myWS.getWeatherDetails(results)
            returnResults['results'].append(weather)
            print("\n")
            halt("Zurück zum Menü [Enter]")
            return True

        elif menu == 5:
            cityDetails = myWS.getCityDetails(results)
            returnResults['results'].append(cityDetails)
            print("\n")
            halt("Zurück zum Menü [Enter]")
            return True

        elif menu == 6:
            coord = myWS.getCoordinatesWeatherStation(results)
            returnResults['results'].append(coord)
            print("\n")
            halt("Zurück zum Menü [Enter]")
            return True

        elif menu == 7:
            print(json.dumps(results, indent=4))
            returnResults['results'].append(results)
            print("\n")
            halt("Zurück zum Menü [Enter]")
            return True

        elif menu == 9:
            print(unterstreichen("\nZusammenfassung"))
            print(json.dumps(returnResults, indent=4))
            print("\nAbfrage beendet!")
            print("-----------------------------------------------------------------------")
            exit("\nRestart Programme")

        else:
            print(unterstreichen("\nZusammenfassung"))
            print(json.dumps(returnResults, indent=4))
            return False


# ----------------------------------------------------------------------------------------------------------------------
# Main / Test-Interface
# ----------------------------------------------------------------------------------------------------------------------

"""
Der Anwender kann mithilfe diesem Interface verschiedene Daten aus der Wetterstation abfragen. Die dafür hinterlegte
Klasse greift via REST-Call in diesem Beispiel auf OpenWeather zu. Als erstes kann der Anwender auswählen, was er/sie 
abfragen möchte. Je nach Gebrauch können andere Daten abgefragt werden.
"""

if __name__ == '__main__':
    if True:
        while True:
            myWS = OpenWeather()

            results = myWS.getResults_OpenWeather(myWS.getJSONResponse())

            returnResults = {'criteria': myWS.getSearchCriteria(results),
                             'results': []}

            showMenu()
