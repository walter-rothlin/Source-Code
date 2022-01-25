# ----------------------------------------------------------------------------------------------------------------------
# Name: Testing_File.py
#
# Description: Testing classes from Rea_Vogel_A19_DS (WeatherStation() and OpenWeather())
#
# Autor: Rea Vogel
#
# History:
# 20-Nov-2021   Rea Vogel      write test cases
# 21-Nov-2021   Rea Vogel      describe test cases in docstrings
# ----------------------------------------------------------------------------------------------------------------------

import unittest
import json
from Rea_Vogel_A19_DS import WeatherStation, OpenWeather


class TestWeatherAppClasses(unittest.TestCase):
    def test_1(self):
        """
        Tests if a predefined search criteria can be given and the JSON response results coming back correctly.
        """
        myWS = OpenWeather("Zug")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        print("\n", json.dumps(results, indent=4))

    def test_2(self):
        """
        Tests if method can return city details belonging to the given search criteria.
        """
        myWS = OpenWeather("Wangen%20SZ")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        cityDetails = myWS.getCityDetails(results)
        print("\n", json.dumps(cityDetails, indent=4))

    def test_3(self):
        """
        Tests if method can return coordinate details belonging to the given search criteria.
        """
        myWS = OpenWeather("Bern")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        coord = myWS.getCoordinatesWeatherStation(results)
        print("\n", json.dumps(coord, indent=4))

    def test_4(self):
        """
        Tests if a predefined search criteria can be given as well as a new appId divergent from the default appId
        and the JSON response results coming back correctly.
        """
        myWS = OpenWeather(searchCriteriaEncoded="Berlin", appId="3836093dde650898eb014e6f27304646")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        print("\n", json.dumps(results, indent=4))

    def test_5(self):
        """
        Tests if a predefined search criteria can be directly assigned and the JSON response results
        coming back correctly.
        """
        myWS = OpenWeather(searchCriteriaEncoded="Luzern")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        print("\n", json.dumps(results, indent=4))

    def test_6(self):
        """
        Tests if the city can not be found the programme exits and returns "Restart Programme".
        """
        myWS = OpenWeather(searchCriteriaEncoded="abc")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        print("\n", json.dumps(results, indent=4))

    def test_7(self):
        """
        Tests if a predefined search criteria can be given as well as a URL and the JSON response results
        coming back correctly. AppId remains (given default value).
        """
        myWS = OpenWeather(searchCriteriaEncoded="Zug",
                           serviceURL="http://api.openweathermap.org/data/2.5/weather?q={search:2s}&appid={appId:2s}")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        print("\n", json.dumps(results, indent=4))

    def test_8(self):
        """
        Tests if main class WeatherStation() can be initiated with other weather website API's and return the
        correct results.
        """
        myWS = WeatherStation(searchCriteriaEncoded="Luzern", appId="7fb64197b839f5a23bdfc4053022a0ce",
                              serviceURL="http://api.weatherstack.com/current?access_key={appId:2s}&query={search:2s}")
        # Bitte nicht mehr als 50 Test laufen lassen, da ansonsten Kosten für mich entstehen. Vielen Dank!

        results = myWS.getJSONResponse()
        print("\n", json.dumps(results, indent=4))

    def test_9(self):
        """
        Tests if method can return temperature details belonging to the given search criteria.
        """
        myWS = OpenWeather("Hamburg")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        temperature = myWS.getTemperatureDetails(results, 1)
        print("\n", json.dumps(temperature, indent=4))

    def test_10(self):
        """
        Tests if method can return wind details belonging to the given search criteria.
        """
        myWS = OpenWeather("Tulum")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        wind = myWS.getWindDetails(results, 3)
        print("\n", json.dumps(wind, indent=4))

    def test_11(self):
        """
        Tests if method can return air details belonging to the given search criteria.
        """
        myWS = OpenWeather("Paris")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        air = myWS.getAirDetails(results, "n", "n")
        print("\n", json.dumps(air, indent=4))

    def test_12(self):
        """
        Tests if method "getJSONResponse()" can be addressed directly and returns a correct JSON structure.
        """
        myWS = OpenWeather("Porto")

        results = myWS.getJSONResponse()
        print(results)

    def test_13(self):
        """
        Tests if method can return all weather details belonging to the given search criteria.
        """
        myWS = OpenWeather("Zürich")

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        weather = myWS.getWeatherDetails(results, 1, 2, 3, 4)
        print("\n", json.dumps(weather, indent=4))

    def test_14(self):
        """
        Tests if a predefined search criteria, appId and URL and can be given and the JSON response results coming
        back correctly.
        """
        myWS = WeatherStation()

        results = myWS.setJSONResponse(searchCriteriaEncoded="Chur", appId="5415138bea24623d399d24c0d71290ef",
                                       serviceURL="http://api.openweathermap.org/data/2.5/weather?q={search:2s}&appid={appId:2s}")
        print("\n", json.dumps(results, indent=4))

    def test_15(self):
        """
        Tests if class and method to get the JSON Response works correctly and with input.
        """
        myWS = OpenWeather()

        results = myWS.getResults_OpenWeather(myWS.getJSONResponse())
        print("\n")
        print(json.dumps(results, indent=4))

    def test_16(self):
        """
        Tests if private method "__setInput()" is set up correctly and can not be accessed.
        """
        myWS = OpenWeather()

        entry = myWS.__setInput("Temperatur", "Grad Celius", "Fahrenheit", "Kelvin")
        print(entry)

