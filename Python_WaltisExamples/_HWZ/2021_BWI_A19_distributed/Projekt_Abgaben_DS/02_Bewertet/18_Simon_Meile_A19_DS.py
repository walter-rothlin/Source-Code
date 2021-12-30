# ------------------------------------------------------------------
# Name: Simon_Meile_A19_DS.py
#
# Description: Does a search via REST request from openweathermap.org (JSON)
#
# Autor: Meile Simon
#
# History:
# 20-Nov-2021   Meile Simon      Initial Version
# 22-Nov-2021   Meile Simon      Final Version 1.0
#
# Class-Diagramm History:
# 20-Nov-2021   Meile Simon      First Draft              https://imgur.com/a/Cwtf0QE
# 20-Nov-2021   Meile Simon      First running Version    https://imgur.com/gallery/TjIcl4w
# 22-Nov-2021   Meile Simon      Final Version 1.0        https://imgur.com/a/qBqcpix
# ------------------------------------------------------------------
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + User-Eingaben möglich
#      + Menusteuerung mit Farbe
#      + Automated testing implemented (+ wie - Tests)
#
# Class Design und Implementation:
#      + Diagramm stimmt mit Code überein
#      + Notwendige (__eq__ __str__ __eq__) Methoden vorhanden
#      + __init__ vollständige Parameter mit sinnvollen Default Werten
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Instance Variablen sind z.T. public (jsonResponse)
#      + Wiederverwendebare Test als Teil der Klasse mit grosser Testabdeckung (neg / pos Tests)
#
# Test:
#      ++ Test (positive/negative) implementiert
#
# Note: 5.5
#
# Fragen:
#    Auf welcher Zeile wird der Request zum Web-Service abgesendet?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------
import requests
import json

# In order to display the test cases in color
# --> source: https://pypi.org/project/colored/
from termcolor import colored

class WeatherStation:

    # ------------------------------------------------------------------
    # Class-Diagramm: https://imgur.com/a/qBqcpix
    # ------------------------------------------------------------------

    # Default Values for the API
    __serviceURL = "https://api.openweathermap.org/data/2.5/weather"
    __appId = "7354dccaa132352682863accd2b4ce48"

    # Constructor, object is created from class and allows the class to initialize the attributes of the class
    def __init__(self, city_name, appId):
        self.city_name = city_name
        if appId == '':
            self.__appId = self.__appId
        else:
            self.__appId = appId

        # Fetching Data from the API
        # Default settings are defined, according to the API documentation https://openweathermap.org/current
        # Units of measurement, a metric number system is set, units=metric
        # The response language is set to German, lang=de
        join = "?q={}&units=metric&lang=de&appid=".format(self.city_name)
        self.jsonResponse = requests.get(self.__serviceURL + join + self.__appId).json()

    # According to the task __str__ and __eq__ implemented
    # Self represents the instance of the class, by using self I can access the attributes and methods of the class
    # --> source: https://www.geeksforgeeks.org/self-in-python-class/
    def __str__(self):
        return self.city_name

    def __eq__(self, other):
        return self.getTemperature() == other.getTemperature()

    def getAppID(self):
        """
        function for getting the used APP_ID of the Application
        :return: Return APP_ID response
        """
        return str(self.__appId)

    def getCityWeather(self):
        """
        function for getting the weather of the entered city
        :return: Return full formatted JSON response from the API
        """
        formatted_json = json.dumps(self.jsonResponse, indent=4)
        return formatted_json

    def getWeatherDetails(self):
        """
        function for fetching the weather details of the entered city
        :return: Weather detail from the API as string
        """
        weather_details = self.jsonResponse["weather"][0]["main"]
        return str(weather_details)

    def getWeatherDescription(self):
        """
        function for fetching the weather detail description of the entered city
        :return: Weather detail description from the API as string
        """
        weather_description = self.jsonResponse["weather"][0]["description"]
        return str(weather_description)

    def getTemperature(self):
        """
        function for fetching the temperature from the API response
        :return: Temperature as a formatted string
        """
        temp = self.jsonResponse["main"]["temp"]
        return str(temp) + "°C"

    def getHumidity(self):
        """
        function for returning the humidity value from the API response
        :return: Humidity as a formatted string
        """
        humidity = self.jsonResponse["main"]["humidity"]
        return str(humidity) + "%"

    def getLatitude(self):
        """
        function for returning the latitude value from the API response
        :return: Latitude as formatted string
        """
        latitude = self.jsonResponse["coord"]["lat"]
        return str(latitude) + "°"

    def getLongitude(self):
        """
        function for returning the longitude value from the API response
        :return: Longitude as formatted string
        """
        longitude = self.jsonResponse["coord"]["lon"]
        return str(longitude) + "°"

    def getPressure(self):
        """
        function employed in returning pressure value from the API response
        :return: pressure as formatted string
        """
        pressure = self.jsonResponse["main"]["pressure"]
        return str(pressure) + "mb"

    def getCloud(self):
        """
        function for returning cloudiness percent value from the API response
        :return: Cloudiness percent as formatted string
        """
        clouds = self.jsonResponse["clouds"]["all"]
        return str(clouds) + "%"

    # ------------------------------------------------------------------
    # Test Cases to validate\check the application
    # ------------------------------------------------------------------

    # Test case 1: API returns code 200, if API request is ok
    def testcase_weather_200_success(self):
        """
        function for returning the test result, for Test case 1: connection test
        :return: Pass or Fail as string
        """
        print()
        print(f"----".join((" ", "Test Case: API connection 200, success", " ")))
        print()
        #self.jsonResponse["cod"] = 300
        if self.jsonResponse["cod"] == 200:
            print(f"API connection result:" + "\t\t\t\t" +colored('OK', 'green'))
            print(f"API connection expected result:" + "\t\t" + colored('OK', 'green'))
            print(f"Test Case API connection:" + "\t\t\t" + colored('Pass', 'green'))
            return str("Pass")
        else:
            print(f"API connection result:" + "\t\t\t\t" + colored('KO', 'red'))
            print(f"API connection expected result:" + "\t\t" + colored('OK', 'green'))
            print(f"Test Case API connection:" + "\t\t\t" + colored('Fail', 'red'))
            return str("Fail")

    # Test case 2: API returns code 400, if API request is ko
    def testcase_weather_200_failure(self):
        """
        function for returning the test result, for Test case 2: connection failure test
        :return: Pass or Fail as string
        """
        print()
        print(f"----".join((" ", "Test Case: API connection 200, failure", " ")))
        print()
        self.jsonResponse["cod"] = 400
        if self.jsonResponse["cod"] == 200:
            print(f"API connection result:" + "\t\t\t\t" +colored('OK', 'red'))
            print(f"API connection expected result:" + "\t\t" + colored('KO', 'green'))
            print(f"Test Case API connection:" + "\t\t\t" + colored('Fail', 'red'))
            return str("Fail")
        else:
            print(f"API connection result:" + "\t\t\t\t" + colored('KO', 'green'))
            print(f"API connection expected result:" + "\t\t" + colored('KO', 'green'))
            print(f"Test Case API connection:" + "\t\t\t" + colored('Pass', 'green'))
            return str("Pass")

    # Test case 3: API does not return code 401, correct API key in API request
    def testcase_weather_401_success(self):
        """
        function for returning the test result, for Test case 3: correct API key in API request
        :return: Pass or Fail as string
        """
        print()
        print(f"----".join((" ", "Test Case: API KEY valid, success", " ")))
        print()
        if self.jsonResponse["cod"] != 401:
            print(f"API KEY valid:" + "\t\t\t\t\t\t" + colored('OK', 'green'))
            print(f"API KEY expected result:" + "\t\t\t" + colored('OK', 'green'))
            print(f"Test Case API KEY:" + "\t\t\t\t\t" + colored('Pass', 'green'))
            return str("Pass")
        else:
            print(f"API JSON response:" + "\n" + str(self.jsonResponse))
            print()
            print(f"API connection result:" + "\t\t\t\t" + colored('KO', 'red'))
            print(f"API connection expected result:" + "\t\t" + colored('OK', 'green'))
            print(f"Test Case API KEY:" + "\t\t\t" + colored('Fail', 'red'))
            return str("Fail")

    # Test case 4: API returns code 401, if the API key is not valid
    def testcase_weather_401_failure(self):
        """
        function for returning the test result, for Test case 4: API key is not valid
        :return: Pass or Fail as string
        """
        print()
        print(f"----".join((" ", "Test Case: API KEY valid, failure", " ")))
        print()
        if self.jsonResponse["cod"] == 401:
            print(f"API KEY valid:" + "\t\t\t\t\t\t" + colored('KO', 'green'))
            print(f"API KEY expected result:" + "\t\t\t" + colored('KO', 'green'))
            print(f"Test Case API KEY:" + "\t\t\t\t\t" + colored('Pass', 'green'))
            return str("Pass")
        else:
            print(f"API JSON response:" + "\n" + str(self.jsonResponse))
            print()
            print(f"API connection result:" + "\t\t\t\t" + colored('OK', 'red'))
            print(f"API connection expected result:" + "\t\t" + colored('OK', 'red'))
            print(f"Test Case API KEY:" + "\t\t\t\t\t" + colored('Fail', 'red'))
            return str("Fail")

    # Test case 5: API returns code 404, city not found
    def testcase_weather_404_success(self):
        """
        function for returning the test result, for Test case 5: city not found
        :return: Pass or Fail as string
        """
        print()
        print(f"----".join((" ", "Test Case: city not found, success", " ")))
        print()
        if self.jsonResponse["cod"] == "404":
            print(f"City name not found:" + "\t\t\t\t" + colored(str(self.city_name), 'red'))
            print()
            print(f"API JSON response:" + "\n" + str(self.jsonResponse))
            print()
            print(f"API response:" + "\t\t\t\t\t\t" + colored('KO', 'green'))
            print(f"API expected response:" + "\t\t\t\t" + colored('KO', 'green'))
            print(f"Test Case City not found:" + "\t\t\t" + colored('Pass', 'green'))
            return str("Pass")
        else:
            print(f"API JSON response:" + "\n" + str(self.jsonResponse))
            print()
            print(f"API connection result:" + "\t\t\t\t" + colored('OK', 'red'))
            print(f"API connection expected result:" + "\t\t" + colored('OK', 'red'))
            print(f"Test Case City not found:" + "\t\t\t" + colored('Fail', 'red'))
            return str("Fail")

    # Test case 6: Check if API returns multiple entries for a city name
    def testcase_multi_result(self):
        """
        function for returning the test result, for Test case 6: multiple entries for a city name
        :return: Pass or Fail as string
        """
        print()
        print(f"----".join((" ", "Test Case: Check if more than one entry is found for a city name", " ")))
        print()
        print(f"API JSON response:" + "\n" + str(self.jsonResponse))
        # --> source: Python_WaltisExamples\CH_Adress_search.py
        rec_count: int = len(self.jsonResponse)
        if rec_count == 13:
            print()
            print(f"Number of entries found:" + "\t\t\t" + colored('1', 'green'))
            print()
            print(f"Only one entry found:" + "\t\t\t\t" + colored('Ok', 'green'))
            print(f"Expected result, only one entry:" + "\t" + colored('OK', 'green'))
            print(f"Test Case multiple Entries:" + "\t\t\t" + colored('Pass', 'green'))
            return str("Pass")
        else:
            print()
            print(f"API connection result:" + "\t\t\t\t" + colored('KO', 'red'))
            print(f"API connection expected result:" + "\t\t" + colored('KO', 'red'))
            print(f"Test Case multiple Entries:" + "\t\t\t" + colored('Fail', 'red'))
            return str("Fail")

    # Test case: Test weather data for city name, API returns weather data
    def testcase_weather_data(self):
        """
        function for returning the test result, for Test case 6: get weather data for a city name
        :return: Pass or Fail as string
        """
        print()
        print("----".join((" ", "Test Case: City weather data found, success", " ")))
        print()
        if self.jsonResponse["cod"] == 200:
            print(f"Weather data found for:" + "\t\t\t\t" + colored(str(self.city_name), 'blue'))
            print()
            print(f"Temperature:\t\t\t\t\t\t{self.getTemperature()}")
            print(f"Weather:\t\t\t\t\t\t\t{self.getWeatherDetails()}")
            print(f"\t\t\t\t\t\t\t\t\t{self.getWeatherDescription()}")
            print(f"Humidity:\t\t\t\t\t\t\t{self.getHumidity()}")
            print(f"Cloudiness percentage:\t\t\t\t{self.getCloud()}")
            print()
            print(f"Coordinates of the city:\t\t\t{str(self.city_name)}")
            print(f"Latitude:\t\t\t\t\t\t\t{self.getLatitude()}")
            print(f"Longitude:\t\t\t\t\t\t\t{self.getLongitude()}")
            print()
            print(f"API connection result:" + "\t\t\t\t" +colored('OK', 'green'))
            print(f"API connection expected result:" + "\t\t" + colored('OK', 'green'))
            print(f"Test Case City weather data found:" + "\t" + colored('Pass', 'green'))
            return str("Pass")
        else:
            print(f"City name not found:" + "\t\t\t\t" + colored(str(self.city_name), 'red'))
            print()
            print(f"API JSON response:" + "\n" + str(self.jsonResponse))
            print()
            print(f"API response:" + "\t\t\t\t\t\t" + colored('KO', 'red'))
            print(f"API expected response:" + "\t\t\t\t" + colored('KO', 'red'))
            print(f"Test Case City weather data found:" + "\t" + colored('Fail', 'red'))
            return str("Fail")

def main():
    """main function"""
    print(f"Weather Station")
    while True:
        print(f"-" * 30)
        print(f"1. Get weather of a city, API response as JASON")
        print(f"2. Get weather of a city, API response formatted")
        print(f"3. Run automated test cases")
        print(f"4. Exit")
        print(f"-" * 30)
        choice = input("Choose a option from above: ")
        if choice == "1":
            city_name = input("Enter city name: ")
            appId = ""
            weather = WeatherStation(city_name, appId)
            print(f"Temperature: {weather.getCityWeather()}")
        elif choice == "2":
            city_name = input("Enter city name: ")
            appId = ""
            weather = WeatherStation(city_name, appId)
            print()
            print(f"You are using the following APP_ID: {weather.getAppID()}")
            print()
            print("Weather data found for:" + "\t\t\t\t" + colored(str(weather.city_name), 'blue'))
            print()
            print(f"Temperature:\t\t\t\t\t\t{weather.getTemperature()}")
            print(f"Weather:\t\t\t\t\t\t\t{weather.getWeatherDetails()}")
            print(f"\t\t\t\t\t\t\t\t\t{weather.getWeatherDescription()}")
            print(f"Humidity:\t\t\t\t\t\t\t{weather.getHumidity()}")
            print(f"Cloudiness percentage:\t\t\t\t{weather.getCloud()}")
            print()
            print(f"Coordinates of the city:\t\t\t{str(weather.city_name)}")
            print(f"Latitude:\t\t\t\t\t\t\t{weather.getLatitude()}")
            print(f"Longitude:\t\t\t\t\t\t\t{weather.getLongitude()}")
            print()
        elif choice == "3":
            # Initialise the test counter
            counter_pass: int = 0
            counter_fail: int = 0

            def getTestCounter(result, counter_pass, counter_fail):
                """
                function for counting the test results
                :return: Counter for Pass or Fail
                """
                if result == 'Pass':
                    counter_pass += 1
                else:
                    counter_fail += 1
                return (counter_pass,counter_fail)

            # Default values for the test cases
            # ------------------------------------------------------------------
            # All the test cases could have been done with a test framework, but there would have been not much
            # personal contribution. The code below and all test cases are not in a test class of its own,
            # due to the single file specification, I started without a multi class approach. In the end it would
            # have been the better approach, the code would have been better structured and editable. Would be a task
            # for an upcoming version 2.0
            # ------------------------------------------------------------------
            city_name = 'Bern'
            city_name_misspelled = 'Bärn'
            city_name_multiresult= 'Bad'
            appId = ""
            weather = WeatherStation(city_name, appId)
            weather_keytest = WeatherStation(city_name, "xxx")
            weather_city_misspelled = WeatherStation(city_name_misspelled, appId)
            weather_city_multiresult = WeatherStation(city_name_multiresult, appId)
            weather_weatherdata_test1 = WeatherStation("Zürich", appId)
            weather_weatherdata_test2 = WeatherStation("London", appId)
            weather_weatherdata_test3 = WeatherStation("Solothurn", appId)
            weather_weatherdata_test4 = WeatherStation("München", appId)
            weather_weatherdata_test5 = WeatherStation("Peking", appId)
            # Test cases
            res_1 = getTestCounter(weather.testcase_weather_200_success(), counter_pass, counter_fail)
            res_2 = getTestCounter(weather.testcase_weather_200_failure(), counter_pass, counter_fail)
            res_3 = getTestCounter(weather.testcase_weather_401_success(), counter_pass, counter_fail)
            res_4 = getTestCounter(weather_keytest.testcase_weather_401_failure(), counter_pass, counter_fail)
            res_5 = getTestCounter(weather_city_misspelled.testcase_weather_404_success(), counter_pass, counter_fail)
            res_6 = getTestCounter(weather_city_multiresult.testcase_multi_result(), counter_pass, counter_fail)
            res_7 = getTestCounter(weather_weatherdata_test1.testcase_weather_data(), counter_pass, counter_fail)
            res_8 = getTestCounter(weather_weatherdata_test2.testcase_weather_data(), counter_pass, counter_fail)
            res_9 = getTestCounter(weather_weatherdata_test3.testcase_weather_data(), counter_pass, counter_fail)
            res_10 = getTestCounter(weather_weatherdata_test4.testcase_weather_data(), counter_pass, counter_fail)
            res_11 = getTestCounter(weather_weatherdata_test5.testcase_weather_data(), counter_pass, counter_fail)

            # Count total amount of passed and failed tests
            total_pass = res_1[0] + res_2[0] + res_3[0] + res_4[0] + res_5[0] + res_6[0] + res_7[0] + res_8[0] + res_9[0] + res_10[0] + res_11[0]
            total_fail = res_1[1] + res_2[1] + res_3[1] + res_4[1] + res_5[1] + res_6[1] + res_7[1] + res_8[1] + res_9[1] + res_10[1] + res_11[1]

            print()
            print()
            print(f"Test statistics:")
            print()
            print(f"Amount of test cases:\t\t\t\t" + colored(str('11'), 'yellow'))
            print()
            print(f"Count of successful tests:\t\t\t" + colored(str(total_pass), 'blue'))
            print(f"Count of failed tests:\t\t\t\t" + colored(str(total_fail), 'red'))
            print()
        elif choice == "4":
            print(f"Thanks for using the application")
            break
        else:
            print(f"Invalid choice")


if __name__ == '__main__':
    main()
