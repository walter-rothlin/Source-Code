#!/usr/bin/python
# -*- coding: utf-8 -*-
#############################################################
# Title:    Vincent_Vogt_A19_DS.py                          #
# Author:   Vincent Vogt - BWI-A19                          #
# Purpose:  Leistungsnachweis Distributed & Mobile Systems  #
# Date:     23.11.2021                                      #
# Version:  1.0 Initial Version                 16.11.2021  #
#           1.1 Implemented various functions   18.11.2021  #
#           1.2 Added json.dumps for output     19.11.2021  #
#           1.3 Added docstrings, comments      20.11.2021  #
#           1.4 Added automated testing         21.11.2021  #
#           2.0 Final Release Version           22.11.2021  #
#                                                           #
# UML:      https://bit.ly/3qZ1LBS                          #
# Testing:  https://bit.ly/3nEiGYa (manually)               #
#           From Line 196           (automated)             #
#                                                           #
#############################################################

# import various python modules
import datetime     # used for timestamp
import requests     # used for request
import json         # used for output

class Wetterstation:

    def __init__(self, city, request_url_api_key):
        """main Wetterstation definitions"""
        self.__city = city
        self.__request_url_api_key = request_url_api_key

    def __str__(self):
        """string method, needed as functional requirement"""
        return "Data provided for City: " + self.__city

    def __eq__(self, other):
        """compare files, needed as functional requirement"""
        return self == other

    def checkCityName(self):
        """check if City name given by user is valid / exists"""
        CityExists = self.responseHandling()
        if not CityExists:
            return False
        else:
            return True

    def getTime(self):
        """returns the timestamp"""
        return datetime.datetime.now().strftime("%d-%m-%Y %H:%M:%S")

    def responseHandling(self):
        """handling the request and response"""
        response = requests.get(request_url_api_key)
        json_response = response.json()
        # verify if City name given by user is found by openweather or not
        if json_response["cod"] == "404":
            return False

        return json_response

    def getWeather(self):
        """function to receive the maximum amount of weather data, used for the report Weather (detailed)"""
        json_response = self.responseHandling()

        weather = {}
        weather['Sky'] = json_response['weather'][0]['main']
        weather['Description'] = json_response['weather'][0]['description']
        weather['Temperature'] = json_response['main']['temp']
        weather['Temperature Feels Like'] = json_response['main']['feels_like']
        weather['Temperature Minimum'] = json_response['main']['temp_min']
        weather['Temperature Maximum'] = json_response['main']['temp_max']
        weather['Pressure'] = json_response['main']['pressure']
        weather['Humidity'] = json_response['main']['humidity']
        weather['Visibility'] = json_response['visibility']
        weather['Wind Speed'] = json_response['wind']['speed']
        weather['Wind Direction'] = json_response['wind']['deg']

        print(json.dumps(weather, indent=4, sort_keys=False))
        return json.dumps(weather, indent=4, sort_keys=False)

    def getWeatherLight(self):
        """function to receive a selection of weather data, used for the report Weather (simple)"""
        json_response = self.responseHandling()

        weatherLight = {}
        weatherLight['Sky'] = json_response['weather'][0]['main']
        weatherLight['Temperature'] = json_response['main']['temp']
        weatherLight['Temperature Minimum'] = json_response['main']['temp_min']
        weatherLight['Temperature Maximum'] = json_response['main']['temp_max']
        weatherLight['Humidity'] = json_response['main']['humidity']

        print(json.dumps(weatherLight, indent=4, sort_keys=False))
        return json.dumps(weatherLight, indent=4, sort_keys=False)

    def getTemperature(self):
        """function to receive the temperature data, used for the report Temperature in degree Celsius"""
        json_response = self.responseHandling()

        temperature = {}
        temperature['Temperature'] = json_response['main']['temp']
        temperature['Temperature Minimum'] = json_response['main']['temp_min']
        temperature['Temperature Maximum'] = json_response['main']['temp_max']
        temperature['Temperature Feels Like'] = json_response['main']['feels_like']

        print(json.dumps(temperature, indent=4, sort_keys=False))
        return json.dumps(temperature, indent=4, sort_keys=False)

    def getWind(self):
        """function to receive the wind data, used for the report Wind (speed in m/s and direction)"""
        json_response = self.responseHandling()

        wind = {}
        wind['Sky'] = json_response['weather'][0]['main']
        wind['Description'] = json_response['weather'][0]['description']
        wind['Wind Speed'] = json_response['wind']['speed']
        wind['Wind Direction'] = json_response['wind']['deg']

        print(json.dumps(wind, indent=4, sort_keys=False))
        return json.dumps(wind, indent=4, sort_keys=False)

    def ReadMe(self):
        """function to describe all the provided functions in this application"""
        print("-------------------------------------------------------------------------------------------------------------------------------")
        print("                        ReadMe - Function Descrition for Weatherstation by Vincent Vogt - BWI-A19                              ")
        print("-------------------------------------------------------------------------------------------------------------------------------")
        print("\n The following data is provided from the implemented reports...")
        print("\n [1] - Weather (detailed):")
        print(" Sky, Description, Temperature, Temperature Feels Like, Temperature Minimum, Temperature Maximum, Pressure, Humidity, Visibility, Wind Speed, Wind Direction")
        print("\n [2] - Weather (simple):")
        print(" Sky, Temperature, Temperature Feels Like, Temperature Minimum, Temperature Maximum, Humidity")
        print("\n [3] - Temperature (in degree Celsius):")
        print(" Temperature, Temperature Feels Like, Temperature Minimum, Temperature Maximum")
        print("\n [4] - Wind (speed in m/s and direction):")
        print(" Wind Speed, Wind Direction")


if __name__ == "__main__":

    # Main Values (fixed input)
    api_key = "c44ff34bf758cc0ece9594b1006ec83b"
    request_url = "http://api.openweathermap.org/data/2.5/weather?"
    default_time = datetime.datetime.now().strftime("%d-%m-%Y-%H-%M")

    # welcome message
    print("-------------------------------------------------------------------------------------------------------------------------------")
    print("                                      Weatherstation by Vincent Vogt - BWI-A19                                                 ")
    print("-------------------------------------------------------------------------------------------------------------------------------")

    # define city
    city = input("\nEnter city name: ")
    if city == "":
        city = "Glattpark"
        print("DEFAULT: Using city 'Glattpark', because no input given...")
    else:
        print("Use City '" + city + "'")

    # set request URL
    request_url_api_key = request_url + "appid=" + api_key + "&q=" + city + "&units=metric"

    # Inititialize Class & check if City exists - if not, script execution stopps
    WeatherRequest = Wetterstation(city, request_url_api_key)
    CityCheck = WeatherRequest.checkCityName()
    if not CityCheck:
        print("\nCity not found!")
        print("Script executing aborted!")
        exit()

    # ask for desired report data
    mode = input("\nChoose report: \n [1] Weather (detailed) [Default]  \n [2] Weather (simple) \n [3] Temperature (in degree Celsius) \n [4] Wind (speed in m/s and direction) \n [5] Service Description \n")
    if mode == "1":
        print("Choosing report [1]: Weather (detailed):")
        WeatherRequest.getWeather()
    elif mode == "2":
        print("Choosing report [2]: Weather (simple):")
        WeatherRequest.getWeatherLight()
    elif mode == "3":
        print("Choosing report [3]: Temperature (in degree Celsius):")
        WeatherRequest.getTemperature()
    elif mode == "4":
        print("Choosing report [4]: Wind (speed in m/s and direction):")
        WeatherRequest.getWind()
    elif mode == "5":
        print("Choosing [5]: Service Description / ReadMe:")
        WeatherRequest.ReadMe()
    else:
        mode = "1"
        print("DEFAULT: Choosing report [1]: Weather (detailed), because your input was not correct...:")
        WeatherRequest.getWeather()

    # goodbye message
    print("\nFinished at:", WeatherRequest.getTime())
    print(WeatherRequest)

# The following code below is used for testing purpose >> if Test Statisctis are needed, set TestSwitch = True
TestSwitch = False

# TestCounter
TestsPerformed = 0
TestsFailed = 0

# Testscenario 1
if TestSwitch == False:
    pass
else:
    print("\n")
    print("-------------------------------------------------------------------------------------------------------------------------------")
    print("\nAutomated Testing starting...")

    print("\nTestscenario 1:")
    TestsPerformed += 1
    if not city:
        print("Variable city is empty! Test failed!")
        TestsFailed += 1
    else:
        print("Variable city is NOT empty. Test successful!")

    print("\nTestscenario 2:")
    TestsPerformed += 1
    if not mode:
        print("Variable mode is empty! Test failed!")
        TestsFailed += 1
    else:
        print("Variable city is NOT empty. Test successful!")


    print("\nTest Statistics: \n")
    print("Tests performed:   ", TestsPerformed)
    print("Tests failed:      ", TestsFailed)


    print("\nAutomated Testing finished!\n")
    print("-------------------------------------------------------------------------------------------------------------------------------")