# Klassendiagramm
# ______________________________________________
# /WeatherService                               /
# /_____________________________________________/
# /baseurl:string                               /
# /appid:string                                 /
# /target:string                                /
# /lon:float                                    /
# /lat:float                                    /
# /_____________________________________________/
# /getweatherdata(timestamp:int): jsonresponse  /
# /assignvalues(jsonresponse:string): void      /
# /getcityname(): cityname                      /
# /getweatherforecast(jsonresponse:string): void/
# /gettimeline(futurejsonresponse:string): void /
# /comparecities(): void                        /
# /testcases(): void                            /
# ______________________________________________/

# Quellen: matplotlib-documentation, Github "WaltisExamples", openweathermap-documentation


import requests
import json
import time
from datetime import datetime
from matplotlib import pyplot as plt


class WeatherStation:
    # Initializer mit den Hauptwerten für das Get-statement, return-elemente ewerden ebenfalls vorbereitet
    def __init__(self, baseurl='https://api.openweathermap.org/data/2.5/', appid='dee54af9b8e2617d9f6220649e6a4f5d',
                 target='weather', lon=8.55, lat=47.3667):
        self.baseurl = baseurl
        self.appid = appid
        self.target = target
        self.lon = lon
        self.lat = lat
        self.temperature = 0
        self.humidity = 0
        self.pressure = 0
        self.uvi = 0
        self.visibility = 0
        self.windspeed = 0
        self.weatherdescription = ''

    # Zentrales Element zum holen von returnwerten
    def getweatherdata(self, timestamp=0):
        filterurlbyparameter = '0'
        # Falls ein User nicht 1 oder 2 eingibt wird er dazu aufgefordert, bis er es tut
        while filterurlbyparameter == '0':
            filterurlbyparameter = input('Wählen sie aus, auf welche Art sie die URL filtern wollen\n'
                                         '[1]Stadtname\n'
                                         '[2]Koordinaten\n')
            if filterurlbyparameter == '1':
                self.target = 'weather'
                cityname = input('Bitte geben sie den Stadtnamen auf Englisch ein\n')
                fullrequest = self.baseurl + self.target + '?q=' + cityname + '&appid=' + self.appid
                cityresponse = requests.get(fullrequest)
                cityjsonresponse = json.loads(cityresponse.text)
                # FallsStadtnamenichtexisitertwirdUserandenStartdeswhile-loopsbefördert
                if '\"cod\":\"404\"' in cityresponse.text:
                    print('Die Stadt mit namen "' + cityname +
                          '" exisitert nicht. Bitte geben sie einen korrekten, englischen Stadtnamen ein.\n')
                    filterurlbyparameter = '0'
                    continue

                # Stadtname wird in lon/lat konvertiert und damit auf die Anfrage an onecall vorbereitet
                self.lon = str(cityjsonresponse['coord']['lon'])
                self.lat = str(cityjsonresponse['coord']['lat'])

            elif filterurlbyparameter == '2':
                # der User kann auch selbstständig die lat/lon-Werte eingeben, solange diese gültig sind
                self.lat = input('Bitte geben sie den Breitengrad an ')
                self.lon = input('Bitte geben sie den Längengrad an ')
            else:
                filterurlbyparameter = '0'
                print('Geben sie bitte eine der gültigen Optionen ein ')

        filterexpression = '?lat=' + self.lat + '&lon=' + self.lon + '&units=metric'

        # Das Ziel wird auf onecall geändert und auf timemachine gestellt, falls historische daten gefordert werden
        self.target = 'onecall'
        if timestamp != 0:
            self.target += '/timemachine'
            filterexpression += '&dt=' + timestamp

        fullrequest = self.baseurl + self.target + filterexpression + '&appid=' + self.appid

        response = requests.get(fullrequest)
        jsonresponse = json.loads(response.text)

        # Falls die selbstständig eingegebenen lat/lon-Werte unzulässig sind, wird die Applikation beendet
        if '\"cod\":\"400\"' in response.text:
            print('Die eingegebenen Koordinaten enthalten einen Fehler.'
                  'Bitte überprüfen sie ihre Eingaben und versuchen es nochmal.\n'
                  'eingegebener Breitengrad: ' + self.lat + '\neingegebenerLängengrad: ' + self.lon + '\n')
            exit(400)

        # korrekte jsons werden an den Werteverteiler weitergegeben
        self.assignvalues(jsonresponse)

        return jsonresponse

    def assignvalues(self, jsonresponse):
        self.temperature = jsonresponse['current']['temp']
        self.humidity = jsonresponse['current']['humidity']
        self.pressure = jsonresponse['current']['pressure']
        self.uvi = jsonresponse['current']['uvi']
        self.visibility = jsonresponse['current']['visibility']
        self.windspeed = jsonresponse['current']['wind_speed']
        self.weatherdescription = jsonresponse['current']['weather'][0]['description']

    # Der Name der den Koordinaten nächstgelegenen Stadt wird per API geholt
    def getcityname(self):
        cityrequest = requests.get('http://api.openweathermap.org/geo/1.0/reverse?lat=' + self.lat + '&lon=' +
                                   self.lon + '&limit=1&appid=' + self.appid)
        cityjsonresponse = json.loads(cityrequest.text)
        if not cityjsonresponse:
            cityname = 'Keine Stadt in der Nähe gefunden'
        else:
            cityname = cityjsonresponse[0]['name']

        return cityname

    # Mittels Loop wird die Wettervorschau der nächsten 5 Tage angezeigt
    def getweatherforecast(self, jsonresponse):
        header = ''
        citytemp = ''
        cityhumid = ''
        citypressure = ''
        cityuvi = ''
        citywindspeed = ''
        cityweatherdescription = ''
        t = 0
        while t < 6:
            header += '|\t\t\t' + datetime.utcfromtimestamp(int(jsonresponse['daily'][t]['dt'])).strftime(
                '%Y-%m-%d') + '\t\t\t\t'
            citytemp += '|\tTemperatur: ' + str(jsonresponse['daily'][t]['temp']['day']) + ' C°\t\t\t\t'
            citypressure += '|\tLuftdruck: ' + str(jsonresponse['daily'][t]['pressure']) + ' hPA\t\t\t\t'
            cityhumid += '|\tLuftfeuchtigkeit: ' + str(jsonresponse['daily'][t]['humidity']) + ' %\t\t\t'
            cityuvi += '|\tUVIndex: ' + str(jsonresponse['daily'][t]['uvi']) + '\t\t\t\t\t'
            cityweatherdescription += '|\tWetter: ' + jsonresponse['daily'][t]['weather'][0]['description'] + '\t\t\t'
            citywindspeed += '|\tWindgeschwindigkeit: ' + str(jsonresponse['daily'][t]['wind_speed']) + ' km/h\t'
            t += 1
        print(header + '\n' + citytemp + '\n' + citypressure + '\n' + cityhumid + '\n' + cityuvi + '\n'
              + cityweatherdescription + '\n' + citywindspeed + '\n')

    # Das Wetter der vergangenen 5 und der nächsten 5 Tage wird dem User in einem Barplot präsentiert
    def gettimeline(self, futurejsonresponse):
        t = 0
        today = round(time.time())
        # 5 days ago = 86400 x 5
        dayoftimeline = today - 432000
        historicaldict = {}
        # Mittels unix-convertierung wird der Loop auf die letzten 5 Tage definiert
        while dayoftimeline <= today:
            pastrequest = requests.get(self.baseurl + 'onecall/timemachine' + '?lat=' + self.lat + '&lon=' + self.lon
                                       + '&dt=' + str(dayoftimeline) + '&units=metric' + '&appid=' + self.appid)
            pastjsonresponse = json.loads(pastrequest.text)
            historicaldict[datetime.utcfromtimestamp(int(pastjsonresponse['current']['dt'])).strftime(
                '%Y-%m-%d')] = pastjsonresponse['current']['temp']

            dayoftimeline += 86400
        # Anschliessend folgen analog zu getweatherforecast die nächsten 5 Tage der Wetterzeitlinie
        while t < 6:
            historicaldict[datetime.utcfromtimestamp(int(futurejsonresponse['daily'][t]['dt'])).strftime(
                '%Y-%m-%d')] = futurejsonresponse['daily'][t]['temp']['day']
            t += 1

        # Abschliessend werden die Werte des Dictionaries in einem Barplot veranschaulicht
        keys = historicaldict.keys()
        values = historicaldict.values()

        plt.bar(keys, values)
        plt.ylabel('Temperatur')
        plt.xlabel('Datum')
        plt.show()

    # Es können beliebig viele Städte miteinander verglichen werden, solange der Benutzer y oder Y auswählt
    def comparecities(self):
        header = ''
        citytemp = ''
        cityhumid = ''
        citypressure = ''
        cityuvi = ''
        cityvisibility = ''
        citywindspeed = ''
        cityweatherdescription = ''
        addcity = True
        # die vielen Tabs dienen der Übersichtlichkeit des Interfaces
        while addcity:
            self.getweatherdata()
            header += '|\t\t\t' + self.getcityname() + '\t\t\t\t\t'
            citytemp += '|\tTemperatur: ' + str(self.temperature) + ' C°\t\t\t\t'
            citypressure += '|\tLuftdruck: ' + str(self.pressure) + ' hPA\t\t\t\t'
            cityhumid += '|\tLuftfeuchtigkeit: ' + str(self.humidity) + ' %\t\t\t'
            cityuvi += '|\tUVIndex: ' + str(self.uvi) + '\t\t\t\t\t'
            cityweatherdescription += '|\tWetter: ' + self.weatherdescription + '\t\t\t'
            cityvisibility += '|\tSichtweite: ' + str(self.visibility) + ' km\t\t\t'
            citywindspeed += '|\tWindgeschwindigkeit: ' + str(self.windspeed) + ' km/h\t'

            print(header + '\n' + citytemp + '\n' + citypressure + '\n' + cityhumid + '\n' + cityuvi + '\n'
                  + cityweatherdescription + '\n' + cityvisibility + '\n' + citywindspeed + '\n')
            addcity = False
            newcity = input('möchten sie eine Weitere Stadt eingeben? Y/N')
            if newcity == 'Y' or newcity == 'y':
                addcity = True

    def testcases(self):
        # Test1: Cityname-überprüfung
        self.lon = '8.04'
        self.lat = '47.39'
        expectedcityname = 'Aarau'
        receivedcityname = self.getcityname()
        if receivedcityname == expectedcityname:
            print('Test 1: Stadtnamentest erfolgreich\n')
        else:
            print('Test 1: Stadtnamentest fehlerhaft\n'
                  'erwarteter Wert = ' + expectedcityname + '\n'
                                                            'erhaltener Wert = ' + receivedcityname + '\n')

        # Test2: check des standard-targets
        expectedtarget = 'weather'
        if self.target == expectedtarget:
            print('Test 2: Zieltest erfolgreich\n')

        else:
            print('Test 2: Zieltest fehlerhaft\n'
                  'erwarteter Wert = ' + expectedtarget + '\n'
                                                          'erhaltener Wert = ' + self.target + '\n')

        # test3: Check, ob temperatur in einer realistischen Reichweite liegt
        fullrequest = 'https://api.openweathermap.org/data/2.5/onecall?lat=47.9974&lon=16.233&units=metric&appid=dee54af9b8e2617d9f6220649e6a4f5d'
        testresponse = requests.get(fullrequest)
        testjsonresponse = json.loads(testresponse.text)
        self.assignvalues(testjsonresponse)
        if 100 <= self.temperature <= -100:
            print('Test 3: Temperaturtest fehlerhaft\n'
                  'Der Wert ' + str(self.temperature) + 'ist unzulässig hoch. Konvertierung fehlgeschlagen\n')
        else:
            print('Test 3: Temperaturtest erfolgreich\n')

    # overload der default totext-funktion
    def __str__(self):
        returnstring = '#####################\n'
        returnstring += 'Eine Wetterstation\n'
        # der Stadtname wird mit der zuständigen Funktion geholt
        returnstring += 'Stadtname: ' + self.getcityname() + '\n'
        returnstring += 'Breitengrad: ' + str(self.lat) + '\n'
        returnstring += 'Längengrad: ' + str(self.lon) + '\n'
        returnstring += 'Temperatur: ' + str(self.temperature) + ' C°\n'
        returnstring += 'Luftdruck: ' + str(self.pressure) + ' hPA\n'
        returnstring += 'Luftfeuchtigkeit: ' + str(self.humidity) + ' %\n'
        returnstring += 'UVIndex: ' + str(self.uvi) + '\n'
        returnstring += 'Wetterbeschreibung: ' + str(self.weatherdescription) + '\n'
        returnstring += 'Sichtweite: ' + str(self.visibility) + ' km\n'
        returnstring += 'Windgeschwindigkeit: ' + str(self.windspeed) + ' km/h\n'

        return returnstring

    # overload der default vergleichs-funktion
    def __eq__(self, otherweatherstation):
        return str(self.lon) + '|' + str(self.lat) == str(otherweatherstation.lon) + '|' + str(otherweatherstation.lat)


# Beginn des Konsolenprogramms

WeatherService = WeatherStation()
# Der Benutzer wird nach einem Input gefragt, welchen Teil des Programms er ausführen möchte
startapplication = input('Guten Tag und willkommen zur Wetterstation. Wählen sie bitte aus, was sie tun möchten.\n'
                         '______________________________________________________________________________________\n'
                         '[1]das jetzige Wetter abrufen\n'
                         '[2]Wettervorschau\n'
                         '[3]Wetter-timeline ansehen\n'
                         '[4]Stadtvergleich\n'
                         '[5]Tests starten\n')

if startapplication == '1':
    WeatherService.getweatherdata()
    print(WeatherService)
elif startapplication == '2':
    weatherdata = WeatherService.getweatherdata()
    WeatherService.getweatherforecast(weatherdata)
elif startapplication == '3':
    weatherdata = WeatherService.getweatherdata()
    WeatherService.gettimeline(weatherdata)
elif startapplication == '4':
    WeatherService.comparecities()
elif startapplication == '5':
    WeatherService.testcases()
else:
    print('Keine der Eingabemöglichkeiten wurde ausgewählt. Die Applikation wurde beendet.')
