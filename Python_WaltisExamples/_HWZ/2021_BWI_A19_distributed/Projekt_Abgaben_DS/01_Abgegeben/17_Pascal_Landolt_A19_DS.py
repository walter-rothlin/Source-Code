# ------------------------------------------------------------------
# Doc-Title: Pascal_Landolt_A19_DS.py
# Leistungsnachweis Distributed & Mobile Systems
# Description: class, application and tests for retrieving weather data
# Autor: Pascal Landolt
#
# Class Diagram: https://tinyurl.com/24jx2z2b
#
# History:
# 2021-11-16/pl: set up file an description
# 2021-11-17/pl: UML class diagram designed (draft), set up test 1 (dummy), methods __str__ und __eq__ created
# 2021-11-20/pl: built class WeatherStation and Subclass WeatherStation_OWM for open weather map,
# redesign test 1 and set up test 2 and 3 (negative), set up Application (draft), , set up test 1_1
# 2021-11-21/pl: set up test 4, 5 and 6, add temp_unit to 'connection_owm'-method with a default-value,
# add __str__ and __eq__ -methods, class diagram completed, wrote CLI-Test-Application (draft)
# 2021-11-21/pl: Implemented a protected 'readme'-attribut
# 2021-11-23/pl: redesigned CLI-Test-Application
# 2021-11-23/pl: overall-check
# ------------------------------------------------------------------

import unittest
import time


class WeatherStation:

    def __init__(self, service_name=None, place=None):
        self.service_name = service_name
        self.place = place
        self.__readme = "**********\n|Readme: |\n**********\n" \
                        "This is a general weather station class with specific subclasses. Already implemented is a " \
                        "OpenWeaterMap-Service-Subclass named 'WeatherStation_OWM'. " \
                        "\nCheck it out with 'connection_owm'-method.\n" \
                        "Link to the class diagram: https://tinyurl.com/24jx2z2b\n*************"

        if self.service_name is None or self.place is None:  # ask for both to ensure that correct value are given

            # Choose a available weather service
            self.service_name = input("Weather Service (Enter owm): ")
            if self.service_name == "owm":
                pass
            else:
                print("-> Sorry, but for this class is only 'owm' available. We use 'owm' instead. Other services will "
                      "be available soon.")

            # Search for current weather in a certain city
            self.place = input("Place: ")

    def get_readme(self):
        print(self.__readme)

    def __str__(self):
        description = "This is an {1}-object and shows you the weather in {0}.".format(self.place, self.service_name)
        return description

    def __eq__(self, other):
        return self.place == other.place and self.service_name == other.service_name


class WeatherStation_OWM(WeatherStation):
    # WeatherStation_OWM inherates from upper class "WeatherStation"
    def __init__(self, service_name=None, place=None, weather_data=None):
        super().__init__(service_name, place)
        self._weather_data = weather_data

    def connection_owm(self, temp_unit="celsius", api_key=None):  # set celsius as a default-value

        # PyOWM is a client Python wrapper library for OpenWeatherMap (OWM) web APIs https://github.com/csparpa/pyowm
        from pyowm import OWM

        owm = OWM(api_key)
        mgr = owm.weather_manager()

        # get a weather instance from PyOWM
        # exception handling is implemented in PyOWM
        observation = mgr.weather_at_place(self.place)
        w = observation.weather

        # pack data:
        self.weather_data = w.detailed_status, w.wind(), w.humidity, w.temperature(
            temp_unit), w.rain, w.heat_index, w.clouds

        return self.weather_data

    def __eq__(self, other):
        return self.weather_data == other.weather_data


# CLI-Test-Application:

# create a object with weather-data:
print("-----------------------")
print("The OWM-Weather Station")
print("-----------------------")
ws = WeatherStation_OWM("owm", "Basel")
ws.get_readme()
print(ws)
try:
    attribut = int(input("You can choose one of the following weather details:"
                         "\n[00]=all \n[0]=detailed_status \n[1]=wind() \n[2]=humidity "
                         "\n[3]=temperature \n[4]=rain \n[5]=heat_index \n[6]=clouds"))
except ValueError:
    print("ValueError. It runs with attribut '[00]=all' instead")
    attribut = 00

ws = WeatherStation_OWM("owm", "Basel").connection_owm(api_key='873739b404141bce0b5fa793f0f0123c')
if attribut == 00:
    print("All weather data: ", ws)
else:
    print("Specific attribute [", attribut, "]:", ws[attribut])
print("***************************")


class TestOpenweather(unittest.TestCase):

    def test_1(self):  # check service_name

        print("Test 1: check service_name")
        testobject = WeatherStation_OWM("owm", "Zurich")
        result = testobject.service_name
        self.assertEqual(result, "owm")  # Compare the output with an expected result
        print("Test 1 OK")
        print("+++")

    def test_1_1(self):  # check service returns values

        print("Test 1_1: Check service returns values")
        testobject = WeatherStation_OWM("owm", "Basel").connection_owm(api_key='873739b404141bce0b5fa793f0f0123c')

        if testobject != "":
            print(testobject)
            testobject = "ok"
        self.assertEqual(testobject, "ok")
        print("Test 1_1 OK")
        print("+++")

    def test_2(self):  # Check place
        print("Test 2: Check place")
        testobject = WeatherStation_OWM("owm", "Zurich")
        result = testobject.place
        self.assertEqual(result, "Zurich")
        print("Test 2 OK")
        print("+++")

    def test_3(self):  # check false place result

        print("Test 3: Check false place result")
        testobject = WeatherStation_OWM("owm", "Basel")
        result = testobject.place
        self.assertNotEqual(result, "Zurich")
        print("Test 3 OK")
        print("+++")

    def test_4(self):  # check temperature unit handling

        print("Test 4: Check temperature unit handling")
        testobject_fa = WeatherStation_OWM("owm", "Zurich").connection_owm(temp_unit="fahrenheit",
                                                                           api_key='873739b404141bce0b5fa793f0f0123c')
        result_fa = testobject_fa[3]  # get temp-dict (fa)
        testobject_ce = WeatherStation_OWM("owm", "Zurich").connection_owm(temp_unit="celsius",
                                                                           api_key='873739b404141bce0b5fa793f0f0123c')
        result_ce = testobject_ce[3]  # get temp-dict (ce)
        self.assertEqual(round(((result_fa["temp"] - 32) * 5 / 9), 2), result_ce["temp"])
        print("Test 4 OK")
        print("+++")

    def test_5(self):  # check equality of objects in subclass

        print("Test 5: Check equality of objects")
        testobject_a = WeatherStation_OWM("owm", "Zurich").connection_owm(api_key='873739b404141bce0b5fa793f0f0123c')
        result_a = testobject_a
        testobject_b = WeatherStation_OWM("owm", "Zurich").connection_owm(api_key='873739b404141bce0b5fa793f0f0123c')
        result_b = testobject_b
        self.assertEqual(result_a, result_b)
        print("Test 5 OK")
        print("+++")

    def test_6(self):  # check equality of objects in upper-class

        print("Test 6: Check equality of objects")
        testobject_a = WeatherStation("owm", "Zurich")
        result_a = testobject_a
        testobject_b = WeatherStation("owm", "Zurich")
        result_b = testobject_b
        self.assertEqual(result_a, result_b)
        print("Test 6 OK")
        print("+++")


time.sleep(1)  # sleep for 1 second so that the output on the console is equal to the program flow

if __name__ == '__main__':
    unittest.main()
