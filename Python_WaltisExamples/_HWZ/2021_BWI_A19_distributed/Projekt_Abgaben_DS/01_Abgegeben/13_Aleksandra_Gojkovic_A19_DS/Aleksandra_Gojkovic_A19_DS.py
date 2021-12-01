# ---------------------------------------------------------------------------------------------------------------------
# Name: Aleksandra_Gojkovic_A19_DS.py
#
# Description: Weather Station Class using REST request to Open Weather (JSON)
#
# Design for the class can be found in the zip
# The test stats can be found in the zip
#
# Autor: Aleksandra Gojkovic
# Matrikel-Nr: 16-704-660
#
# Hiermit bestätige ich, Aleksandra Gojkovic, dass ich die folgenden Zeilen Code selbständig geschrieben habe und
# Codesnippets, die ich wiederverwendet habe, entsprechend gekennzeichnet habe.
# ---------------------------------------------------------------------------------------------------------------------


import json
import requests
import time

class WeatherStation:

    def __init__(self, city="Zurich", unit="M", appID="8718b8af9ead60839f29c08ca5fc2a57"):
        """The weather information can be displayed in the following units; metric = Celsius, m/s, mm ;
        imperial = Fahrenheit, mph, in ; scientific = Kelvin, m/s, mm
        In order to be able to use this class, an individual API key for OpenWeather has to be used"""
        self.city = city
        self.unit = unit
        self.appID = appID


    def __eq__(self, other):
        if other.city == self.city:
            return True
        return False


    def __str__(self):
        return "You're retrieving weather data for " + self.city + " using " + self.unit + " as your unit."


    def getMeteoData(self):
        """returns a dictionary with all the data that is usually used by weather reports such as Meteo;
         this data includes max, min and current temperature, the wind speed, the state of the sky (cloudy, clear,
         etc.), time of sunrise and sunset"""

        """Exception handling implemented for typos or non-existent cities"""
        try:
            """the following lines are snippets from the exercise done on the 16th of November, adapted for this method"""
            if self.unit == "M" or self.unit == "m":
                serviceURL = "https://api.openweathermap.org/data/2.5/weather?q={city:2s}&units=metric&appid={appID:2s}"
            elif self.unit == "I" or self.unit == "i":
                serviceURL = "https://api.openweathermap.org/data/2.5/weather?q={city:2s}&units=imperial&appid={appID:2s}"
            elif self.unit == "S" or self.unit == "s":
                serviceURL = "https://api.openweathermap.org/data/2.5/weather?q={city:2s}&appid={appID:2s}"
            else:
                return "Please choose between M, I or S."

            requestStr = serviceURL.format(city=self.city, appID=self.appID)
            responseStr = requests.get(requestStr)
            jsonResponse = json.loads(responseStr.text)

            """Check implemented for nonexistent, wrong or invalid appids."""
            if jsonResponse["cod"] == 401:
                return "You've entered an invalid AppID. Please enter valid key."

            weather_dict = {}

            a = int(jsonResponse["main"]["temp"])
            weather_dict["current_temp"] = a
            b = int(jsonResponse["main"]["temp_max"])
            weather_dict["maximum_temp"] = b
            c = int(jsonResponse["main"]["temp_min"])
            weather_dict["minimum_temp"] = c
            d = jsonResponse["weather"][0]["description"]
            weather_dict["sky"] = d
            e = jsonResponse["wind"]["speed"]
            weather_dict["wind"] = e
            f = jsonResponse["sys"]["sunrise"]
            weather_dict["sunrise"] = time.ctime(f)
            g = jsonResponse["sys"]["sunset"]
            weather_dict["sunset"] = time.ctime(g)


            return weather_dict

        except KeyError:
            return "You've entered an invalid input. Please check your spelling."


    def getcurrentTemp(self):
        """returns the current temperature in the unit defined in the constructor"""

        """Exception handling implemented for typos or non-existent cities"""
        try:
            """the following lines are snippets from the exercise done on the 16th of November, adapted for this method"""
            if self.unit == "M" or self.unit == "m":
                serviceURL = "https://api.openweathermap.org/data/2.5/weather?q={city:2s}&units=metric&appid={appID:2s}"
            elif self.unit == "I" or self.unit == "i":
                serviceURL = "https://api.openweathermap.org/data/2.5/weather?q={city:2s}&units=imperial&appid={appID:2s}"
            elif self.unit == "S" or self.unit == "s":
                serviceURL = "https://api.openweathermap.org/data/2.5/weather?q={city:2s}&appid={appID:2s}"
            else:
                return "Please choose between M, I or S."

            requestStr = serviceURL.format(city=self.city, appID=self.appID)
            responseStr = requests.get(requestStr)
            jsonResponse = json.loads(responseStr.text)

            """Check implemented for nonexistent, wrong or invalid appids."""
            if jsonResponse["cod"] == 401:
                return "You've entered an invalid AppID. Please enter valid key."

            temperature = jsonResponse["main"]["temp"]
            current_temp = int(temperature)
            return current_temp

        except KeyError:
            return "You've entered an invalid input. Please check your spelling."


    def getSkyDesc(self):
        """returns the description of current state of the sky (clear, cloudy, ...)"""

        """Exception handling implemented for typos or non-existent cities"""
        try:
            """the following lines are snippets from the exercise done on the 16th of November, adapted for this method"""
            serviceURL = "https://api.openweathermap.org/data/2.5/weather?q={city:2s}&appid={appID:2s}"
            requestStr = serviceURL.format(city=self.city, appID=self.appID)
            responseStr = requests.get(requestStr)
            jsonResponse = json.loads(responseStr.text)

            """Check implemented for nonexistent, wrong or invalid appids."""
            if jsonResponse["cod"] == 401:
                return "You've entered an invalid AppID. Please enter valid key."

            sky_desc = jsonResponse["weather"][0]["description"]
            return sky_desc

        except KeyError:
            return "You've entered an invalid input. Please check your spelling."



"""-----------------------------------------------Testing---------------------------------------------------------"""

"""The following part was used for testing the initialization,the REST Call and the output of getTempinCelsius(), 
method has been changed afterwards"""
#station1 = WeatherStation()
#print(station1.getTempinCelsius(self))

"""The following part was used for testing getTempinCelsius(self, temp_type). The intention behind the method was,
that the user could choose the desired unit for the output. After re-evaluating the idea, the option to choose the
temperature (and other) unit(s) has been implemented in the __init__"""
#station1 = WeatherStation()
#print(station1.getTempinCelsius(self,temp_type))

"""The following part was used to test the __str__ method"""
#station1 = WeatherStation()
#print(station1)

"""The following part was used to test the getcurrentTemp(self). While testing this method for the first time, the
parameter "unit" in the __init__ only referred to the temperature. When going through the Open Weather API Doc I realized 
that the choice of units could be solved much easier."""

city1 = input("Which city would you like to get the weather data from? ") #tested with existent cities, typos and nonexistent cities
unit1 = input("Choose M for metric, I for imperial or S for standard unit: ") #tested with correct and incorrect input
appID1 = input("Please enter your personal AppID: ") #tested with correct/valid AppID and wrong/empty entry

station1 = WeatherStation(city1, unit1, appID1)
print(station1.getMeteoData())


"""The following part served as the final test. It has been written on purpose from a user perspective with the help()
function, interactive parts and functions like print(station1). With the following code several use cases were tested
and allowed to find and correct glitches."""
help(WeatherStation)

station = WeatherStation()
print(station)

city1 = input("Which city would you like to get the weather data from? ")
unit1 = input("Choose M for metric, I for imperial or S for standard unit: ")
appID1 = input("Please enter your personal AppID: ")

station1 = WeatherStation()
print(station1)
print(station1.getSkyDesc())
print(station1.getMeteoData())
print(station1.getcurrentTemp())

city2 = input("Which city would you like to get the weather data from? ")
unit2 = input("Choose M for metric, I for imperial or S for standard unit: ")
appID2 = input("Please enter your personal AppID: ")
station2 = WeatherStation(city2, unit2, appID2)
print(station2)
print(station2.getMeteoData())
print(station2.getcurrentTemp())
print(station2.getSkyDesc())




















