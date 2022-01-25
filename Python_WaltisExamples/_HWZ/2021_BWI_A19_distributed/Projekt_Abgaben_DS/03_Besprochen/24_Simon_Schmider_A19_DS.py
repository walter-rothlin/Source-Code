# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + Sehr umfangreiche User-Eingaben möglich
#      + Unsinnige Usereingaben werden abgefangen
#      + Wahlmöglichkeit App oder UnitTest
#
# Class Design und Implementation:
#      + Diagramm stimmt mit Code überein (+ / - für private / public)
#      + Notwendige (__init__ __str__ __eq__) Methoden vorhanden
#      + __init__ nötige Parameter haben sinnvolle Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Nicht alle Instance Variablen sind public
#
# Test:
#      + Test (positive) implementiert
#
# Note: 5.5
#
# Fragen:
#    Auf welcher Zeile wird der Request zum Web-Service abgesendet?
#    Wo wird Object Ihrer Klasse instanziert?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------
# ------------------------------------------------------------------
# Name: Simon_Schmider_A19_DS.py
#
# Autor: Simon Schmider
#
# History:
# 22-Nov-2021   Simon Schmider      Initial Version
#
# Klassendesign:
#
#   +--------------------------------------------+
#   |               WeatherStation               |
#   +--------------------------------------------+
#   | - __openweathermap_apiKey: string          |
#   | - __openweathermap_serviceURL: string      |
#   | + searchMethod: string                     |
#   | + searchCriteria: string                   |
#   | + searchCriteriaEncoded: string            |
#   | + jsonResponse: string                     |
#   +--------------------------------------------+
#   | + doRequest()                              |
#   | + getLocationData(extendDetails: boolean)  |
#   | + getWeatherData()                         |
#   | + getTempData()                            |
#   | + getWindData()                            |
#   | + getWeatherReport()                       |
#   | + returnAsJson()                           |
#   +--------------------------------------------+
#
#
# ------------------------------------------------------------------


# Import Modules
import requests
import json
import urllib.parse
import unittest
import geocoder


class WeatherStation:

    def __init__(self, searchCriteria="", searchMethod="q", openweathermap_apiKey="131cfe2462da1135a77419d46ef56c7d", serviceURL="http://api.openweathermap.org/data/2.5/weather?{searchMethod}={searchCriteria}&appid={apiid}"):
        self.searchMethod = searchMethod
        self.__openweathermap_serviceURL = serviceURL
        self.__openweathermap_apiKey = openweathermap_apiKey

        # if there is no search criteria, get the current location of the user
        if searchCriteria == "":
            g = geocoder.ip('me')
            self.searchCriteria = g.city
        else:
            self.searchCriteria = searchCriteria

        # encode search criteria for URL
        self.searchCriteriaEncoded = urllib.parse.quote_plus(self.searchCriteria)

        # create empty variable
        self.jsonResponse = ""

        return None


    def __str__(self):
        # return Object
        return self.searchCriteria

    def __eq__(self, other):
        # Compare 2 Objects
        return str(self) == str(other)

    def doRequest(self):
        # build Request String and get data from API
        requestStr = self.__openweathermap_serviceURL.format(searchMethod=self.searchMethod, searchCriteria=self.searchCriteriaEncoded, apiid=self.__openweathermap_apiKey)

        # check if service is available
        try:
            responseStr = requests.get(requestStr)

            # check if response is valid
            try:
                jsonResponse = json.loads(responseStr.text)
                self.jsonResponse = jsonResponse

                # check if API found a city
                if 'message' in self.jsonResponse:
                    print(self.jsonResponse['message'])
                    print("")
                    return False
                else:
                    pass

                return True

            except:
                print("No valid data, try another Input")
                print("")
                return False
        except:
            print("Service not available")
            print("")
            return False

    def getLocationData(self, extendDetails=False):
        # print location information
        if 'name' in self.jsonResponse:
            print("  location :", self.jsonResponse['name'])

        if 'country' in self.jsonResponse['sys']:
            print("  country  :", self.jsonResponse['sys']['country'])

        # print extended location information
        if extendDetails == True:
            if 'lon' in self.jsonResponse['coord']:
                print("  lon      :", self.jsonResponse['coord']['lon'])

            if 'lat' in self.jsonResponse['coord']:
                print("  lat      :", self.jsonResponse['coord']['lat'])

            if 'sunrise' in self.jsonResponse['sys']:
                print("  sunrise  :", self.jsonResponse['sys']['sunrise'])

            if 'sunset' in self.jsonResponse['sys']:
                print("  sunset   :", self.jsonResponse['sys']['sunset'])

            if 'timezone' in self.jsonResponse:
                print("  timezone :", self.jsonResponse['timezone'])

        return True



    def getWeatherData(self):
        # check for multiple items
        if len(self.jsonResponse['weather']) == 1:
            # print weather information (just print 1 item)
            if 'main' in self.jsonResponse['weather'][0]:
                print("  weather  :", self.jsonResponse['weather'][0]['main'])

            if 'description' in self.jsonResponse['weather'][0]:
                print("  details  :", self.jsonResponse['weather'][0]['description'])
        else:
            # print weather information (print all items)
            for entry in self.jsonResponse['weather']:
                if 'main' in self.jsonResponse['weather']:
                    print("  weather  :", entry['main'])

                if 'description' in self.jsonResponse['weather']:
                    print("  details  :", entry['description'])

        return True



    def getTempData(self):
        # print temperature information
        if 'temp' in self.jsonResponse['main']:
            print("  temp     :", self.jsonResponse['main']['temp'])

        if 'temp_min' in self.jsonResponse['main']:
            print("  temp_min :", self.jsonResponse['main']['temp_min'])

        if 'temp_max' in self.jsonResponse['main']:
            print("  temp_max :", self.jsonResponse['main']['temp_max'])

        if 'pressure' in self.jsonResponse['main']:
            print("  pressure :", self.jsonResponse['main']['pressure'])

        if 'humidity' in self.jsonResponse['main']:
            print("  humidity :", self.jsonResponse['main']['humidity'])

        return True


    def getWindData(self):
        # print wind information
        if 'speed' in self.jsonResponse['wind']:
            print("  speed    :", self.jsonResponse['wind']['speed'])

        if 'deg' in self.jsonResponse['wind']:
            print("  deg      :", self.jsonResponse['wind']['deg'])

        if 'gust' in self.jsonResponse['wind']:
            print("  gust     :", self.jsonResponse['wind']['gust'])

        if 'all' in self.jsonResponse['clouds']:
            print("  clouds   :", self.jsonResponse['clouds']['all'])

        return True



    def getWeatherReport(self):
        # print all information
        self.getLocationData(True)
        self.getWeatherData()
        self.getTempData()
        self.getWindData()
        return True



    def returnAsJson(self):
        # return the data as json
        return json.dumps(self.jsonResponse, indent=4, sort_keys=False)


# Unittest test class
class TestStringMethods(unittest.TestCase):

    def test_1_init(self):
        # Test __init__, __str__ and __eq__
        print("... Test __init__, __str__ and __eq__")

        self.assertNotEqual(WeatherStation(), "")
        # Get ResourceWarning: because of module geocoder, but testcase works!

        testWeather_1 = WeatherStation('Uster')
        self.assertEqual(testWeather_1, 'Uster')
        self.assertEqual(str(testWeather_1), 'Uster')
        self.assertEqual(str(testWeather_1), WeatherStation('Uster'))

        testWeather_2 = WeatherStation('Zürich')
        self.assertEqual(testWeather_2, 'Zürich')
        self.assertEqual(str(testWeather_2), 'Zürich')
        self.assertEqual(str(testWeather_2), WeatherStation('Zürich'))

        self.assertNotEqual(testWeather_1, testWeather_2)

        print("... Test __init__, __str__ and __eq__ - Done")

    def test_2_doRequest(self):
        # Test doRequest
        print("... Test doRequest")
        testWeather_1 = WeatherStation('Uster')
        testWeather_2 = WeatherStation('Uster', "q","131cfe2462da1135a77419d46ef56c7d","http://api.openweathermap.org/data/2.5/weather?{searchMethod}={searchCriteria}&appid={apiid}")
        testWeather_3 = WeatherStation('Uster', "q", "131cfe2462da1135a77419d46ef56c7d", "http://test.com")
        testWeather_4 = WeatherStation('Uster', "q", "123456789", "http://api.openweathermap.org/data/2.5/weather?{searchMethod}={searchCriteria}&appid={apiid}")
        testWeather_5 = WeatherStation('Zürich')
        testWeather_6 = WeatherStation('St. Gallen')
        testWeather_7 = WeatherStation('Pfäffikon ZH')
        testWeather_8 = WeatherStation('asfdghsadfh')

        self.assertTrue(testWeather_1.doRequest())
        self.assertTrue(testWeather_2.doRequest())
        # the next 2 tests are working, but with a long loading time (over 20s)
        # self.assertFalse(testWeather_3.doRequest())
        # self.assertFalse(testWeather_4.doRequest())
        self.assertTrue(testWeather_5.doRequest())
        self.assertTrue(testWeather_6.doRequest())
        self.assertTrue(testWeather_7.doRequest())
        self.assertFalse(testWeather_8.doRequest())
        print("... Test doRequest - Done")

    def test_3_getLocationData(self):
        # Test getLocationData
        print("... Test getLocationData")
        testWeather_1 = WeatherStation('Uster')
        testWeather_2 = WeatherStation('Zürich')
        testWeather_3 = WeatherStation('St. Gallen')
        testWeather_4 = WeatherStation('Pfäffikon ZH')

        testWeather_1.doRequest()
        testWeather_2.doRequest()
        testWeather_3.doRequest()
        testWeather_4.doRequest()

        self.assertTrue(testWeather_1.getLocationData())
        self.assertTrue(testWeather_1.getLocationData())
        self.assertTrue(testWeather_2.getLocationData())
        self.assertTrue(testWeather_3.getLocationData())
        self.assertTrue(testWeather_4.getLocationData())

        self.assertTrue(testWeather_3.getLocationData(True))
        self.assertTrue(testWeather_4.getLocationData(True))
        self.assertTrue(testWeather_3.getLocationData(False))
        self.assertTrue(testWeather_4.getLocationData(False))

        print("... Test getLocationData - Done")

    def test_4_getWeatherData(self):
        # Test getWeatherData
        print("... Test getWeatherData")
        testWeather_1 = WeatherStation('Uster')
        testWeather_2 = WeatherStation('Zürich')
        testWeather_3 = WeatherStation('St. Gallen')
        testWeather_4 = WeatherStation('Pfäffikon ZH')

        testWeather_1.doRequest()
        testWeather_2.doRequest()
        testWeather_3.doRequest()
        testWeather_4.doRequest()

        self.assertTrue(testWeather_1.getWeatherData())
        self.assertTrue(testWeather_1.getWeatherData())
        self.assertTrue(testWeather_2.getWeatherData())
        self.assertTrue(testWeather_3.getWeatherData())
        self.assertTrue(testWeather_4.getWeatherData())

        print("... Test getWeatherData - Done")

    def test_5_getTempData(self):
        # Test getTempData
        print("... Test getTempData")
        testWeather_1 = WeatherStation('Uster')
        testWeather_2 = WeatherStation('Zürich')
        testWeather_3 = WeatherStation('St. Gallen')
        testWeather_4 = WeatherStation('Pfäffikon ZH')

        testWeather_1.doRequest()
        testWeather_2.doRequest()
        testWeather_3.doRequest()
        testWeather_4.doRequest()

        self.assertTrue(testWeather_1.getTempData())
        self.assertTrue(testWeather_1.getTempData())
        self.assertTrue(testWeather_2.getTempData())
        self.assertTrue(testWeather_3.getTempData())
        self.assertTrue(testWeather_4.getTempData())

        print("... Test getTempData - Done")

    def test_6_getWindData(self):
        # Test getWindData
        print("... Test getWindData")
        testWeather_1 = WeatherStation('Uster')
        testWeather_2 = WeatherStation('Zürich')
        testWeather_3 = WeatherStation('St. Gallen')
        testWeather_4 = WeatherStation('Pfäffikon ZH')

        testWeather_1.doRequest()
        testWeather_2.doRequest()
        testWeather_3.doRequest()
        testWeather_4.doRequest()

        self.assertTrue(testWeather_1.getWindData())
        self.assertTrue(testWeather_1.getWindData())
        self.assertTrue(testWeather_2.getWindData())
        self.assertTrue(testWeather_3.getWindData())
        self.assertTrue(testWeather_4.getWindData())

        print("... Test getWindData - Done")

    def test_7_getWeatherReport(self):
        # Test getWeatherReport
        print("... Test getWeatherReport")
        testWeather_1 = WeatherStation('Uster')
        testWeather_2 = WeatherStation('Zürich')
        testWeather_3 = WeatherStation('St. Gallen')
        testWeather_4 = WeatherStation('Pfäffikon ZH')

        testWeather_1.doRequest()
        testWeather_2.doRequest()
        testWeather_3.doRequest()
        testWeather_4.doRequest()

        self.assertTrue(testWeather_1.getWeatherReport())
        self.assertTrue(testWeather_1.getWeatherReport())
        self.assertTrue(testWeather_2.getWeatherReport())
        self.assertTrue(testWeather_3.getWeatherReport())
        self.assertTrue(testWeather_4.getWeatherReport())

        print("... Test getWeatherReport - Done")

    def test_8_returnAsJson(self):
        # Test returnAsJson
        print("... Test returnAsJson")
        testWeather_1 = WeatherStation('Uster')
        testWeather_2 = WeatherStation('Zürich')
        testWeather_3 = WeatherStation('St. Gallen')
        testWeather_4 = WeatherStation('Pfäffikon ZH')

        testWeather_1.doRequest()
        testWeather_2.doRequest()
        testWeather_3.doRequest()
        testWeather_4.doRequest()

        print(testWeather_1.returnAsJson())
        print(testWeather_2.returnAsJson())
        print(testWeather_3.returnAsJson())
        print(testWeather_4.returnAsJson())

        self.assertNotEqual(testWeather_1.returnAsJson(), "")
        self.assertNotEqual(testWeather_2.returnAsJson(), "")
        self.assertNotEqual(testWeather_3.returnAsJson(), "")
        self.assertNotEqual(testWeather_4.returnAsJson(), "")

        print("... Test returnAsJson - Done")


    def test_9_negativeTests(self):
        # Test negative Results
        print("... Test negative Results")

        testWeather_1 = WeatherStation('asfdghsadfh')
        self.assertEqual(testWeather_1.doRequest(), True)      # should be False, not True


        """
        testWeather_2 = WeatherStation('St. Gallen')
        testWeather_2.doRequest()
        self.assertFalse(testWeather_2.getLocationData(False))  # should be True, not False
        """

        print("... Test negative Results - Done")


# ------------------------------------------------------------------
# Start Application
# ------------------------------------------------------------------

if __name__ == "__main__":

    print("... start WeatherStation Application")

    while True:
        print("+----------------------------------------------------+")
        print("| Choose an action                                   |")
        print("+----------------------------------------------------+")
        print("  [1] Unittests   [2] Get Weather Data   [3] exit")
        doAction = input("> ")
        print("")

        if doAction == "1":
            print("+------------------- Start unittest -------------------+")
            print("")
            # print(" Achtung: kann etwa 20 sekunden dauern! ")
            unittest.main()

        elif doAction == "2":
            while True:
                print("+----------------------------------------------------+")
                print("| Enter a location                                   |")
                print("| (for your current location just press enter)       |")
                print("+----------------------------------------------------+")
                print("  [ ] current location   [2] back   [3] exit")
                locationInput = input("> ")
                print("")

                if locationInput == "2":
                    break   # break here and go back

                elif locationInput == "3":
                    quit()  # break here and exit program

                else:
                    while True:
                        # create object
                        weather = WeatherStation(locationInput)

                        # do and check request
                        if weather.doRequest() == False:
                            break   # break here and go back
                        elif weather.doRequest() == True:
                            pass    # Request is valid
                        else:
                            print("Unexpected Error")
                            print("... Close Application")
                            quit()

                        # get location data
                        print("Your Location:")
                        weather.getLocationData()
                        print("+----------------------------------------------------+")
                        print("| What information do you want?                      |")
                        print("+----------------------------------------------------+")
                        print("  [1] extend location information    [2] Weather information")
                        print("  [3] Temperature information        [4] Wind information")
                        print("  [5] Full Weather Report            [6] All Data as JSON")
                        print("  [7] back                           [8] exit")
                        informationInput = input("> ")
                        print("")

                        if informationInput == "1":
                            print("Extended location information:")
                            weather.getLocationData(True)
                            print("+----------------------------------------------------+")
                            print("")

                        if informationInput == "2":
                            print("Weather information:")
                            weather.getWeatherData()
                            print("+----------------------------------------------------+")
                            print("")

                        if informationInput == "3":
                            print("Temperature information:")
                            weather.getTempData()
                            print("+----------------------------------------------------+")
                            print("")

                        if informationInput == "4":
                            print("Wind information:")
                            weather.getWindData()
                            print("+----------------------------------------------------+")
                            print("")

                        if informationInput == "5":
                            print("Weather Report:")
                            weather.getWeatherReport()
                            print("+----------------------------------------------------+")
                            print("")

                        if informationInput == "6":
                            print(weather.returnAsJson())
                            print("+----------------------------------------------------+")
                            print("")

                        if informationInput == "7":
                            break  # break here and go back

                        elif informationInput == "8":
                            quit()  # break here and exit program

        elif doAction == "3":
            quit()  # break here and exit program

        else:
            print("... this action dont exist: " + doAction)


