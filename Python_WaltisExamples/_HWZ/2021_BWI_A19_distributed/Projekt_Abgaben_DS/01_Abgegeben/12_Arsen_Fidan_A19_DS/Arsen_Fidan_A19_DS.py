# ------------------------------------------------------------------
# Name: Arsen_Fidan_A19_DS.py
#
# Description: Weather Station class for retrieving weather data over external Web Api Service including
# a cli test application for testing and demonstration purposes.
#
# Author: Arsen Fidan
#
# Date: 2021/11/23
#
# Version: 1.0
# Documentation: BWI-A19_LNW_DMS_ArsenFidan.pdf
# ------------------------------------------------------------------

import requests
import json
import gzip
from datetime import datetime


class WeatherStation:

    def __init__(self, accessKey="4e4c04c2b96c9d94c2a5863a7cb41ab8", unit="metric", lang="en"):
        self.accessKey = accessKey
        self.unit = unit
        self.lang = lang

    def __str__(self):
        return f"AccessID is: {self.accessKey} \nLanguage is: {self.lang} \nUnits shown in: {self.unit}"

    def __eq__(self, other):
        if other.accessKey == self.accessKey:
            return True
        return False


    def GetWeather(self, city=None, customfield=None, console: bool = True):
        """
        Only This Method must be used to retrieve Weather Data. Source is OpenWeatherMag.Org
        All Parameter are optional and can be left empty. Handling are inherited in static methods.

        -city(str):     defines City to retrieve weather data for
        -customfield[]: defines set of weather attribute to show
        -console:       defines if output wil be shown on console
        """

        print("\n ")
        print(self)
        city = self.ValidateCity(city)
        url = self.CreateURL(city=city, unit=self.unit, lang=self.lang, accessKey=self.accessKey)
        restData = self.GetRESTData(url)
        fields = self.ChooseFields(customfield)
        getWeather = self.AttributeMapping(rawObj=restData, custom=fields)

        output = getWeather

        if console:
            print("\n")
            for attribute, value in output.items():
                print(f"{attribute}: {value}")
        return output

    # ------------------- Object independent static functions -------------------


    @staticmethod
    def CreateURL(city, unit, lang, accessKey):
        """
        Creates URL customized for API of OpeanWeather. Parameters arguments will be used from object.

        -city:       defines City to retrieve weather data for
        -unit:       defines set of weather attribute to show
        -accessKey:  defines accessKey for API access
        """

        url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&lang={lang}&units={unit}&appid={accessKey}"
        output = url
        return output

    @staticmethod
    def GetRESTData(url):
        """
        Generic Method to use RestApi with GET, retrieve data and return as json.
        """
        restData = requests.get(url)
        jsonData = json.loads(restData.text)
        output = jsonData
        return output

    @staticmethod
    def AttributeMapping(rawObj, custom=None):
        """
        This Method is used to whether use all existing weather attributes of OpenWeather or scale to predefined
        set of attributes provided by output of ChooseFields().
        Input can be empty.
        Raw data must be from OpenWeather.
        """
        weatherObj = {}
        attributes = {
            "Time": WeatherStation.ConvertUnixTime(rawObj["dt"]),
            "City": rawObj["name"],
            "Description": rawObj["weather"][0]["description"],
            "Sky": rawObj["clouds"]["all"],
            "Temp": rawObj["main"]["temp"],
            "TempMax": rawObj["main"]["temp_max"],
            "TempMin": rawObj["main"]["temp_min"],
            "Wind": rawObj["wind"]["speed"],
            "Sunrise": WeatherStation.ConvertUnixTime(rawObj["sys"]["sunrise"]),
            "Sunset": WeatherStation.ConvertUnixTime(rawObj["sys"]["sunset"])
        }
        if custom is not None:
            for attr, value in attributes.items():
                if attr.upper() in custom:
                    weatherObj.update({attr: value})
        elif custom is None:
            weatherObj = attributes

        output = weatherObj
        return output

    @staticmethod
    def ChooseFields(fields: list = None):
        """
        Method is validating specific list of custom fields against available fields. This can be used generic.
        If input is wrong or an item not existing of predefined available fields an error will warn you.
        Input can be case-insensitive.
        Input can be empty.
        -Fields: must be a list
        """
        customFields = []
        availableFields = ["Time", "City", "Description", "Sky", "Temp", "TempMax", "TempMin", "Wind", "Sunrise",
                           "Sunset"]
        for item in range(len(availableFields)):
            availableFields[item] = availableFields[item].upper()

        if fields is not None:
            for attribute in fields:
                if attribute.upper() in availableFields:
                    customFields.append(attribute.upper())
                else:
                    print(f"Attribute {attribute} not existing, please try again. \n")
                    exit()
            print("Attributes are: " + ', '.join(customFields))
        elif fields is None:
            customFields = None
            print("Attributes are: " + ', '.join(availableFields))

        output = customFields
        return output

    @staticmethod
    def GetCities():
        """
        Downloads all available cities for data of OpenWeather and gives output as an array of cities.
        """
        cities = []
        url = "https://bulk.openweathermap.org/sample/city.list.json.gz"
        req = requests.get(url)
        obj = gzip.decompress(req.content)
        jsonData = json.loads(obj)

        for key in jsonData:
            cities.append(key["name"])
        output = cities
        return output

    @staticmethod
    def ValidateCity(city=None):
        """
        Validates inserted city against the downloaded cities from GetCities Method.
        If city is empty an input will ask for feed.
        If city is wrong an output will warn and stop further processing.
        Cities can be used case-insensitive.
        """
        output = None
        cities = WeatherStation.GetCities()

        for item in range(len(cities)):
            cities[item] = cities[item].upper()

        if city is None:
            response = input("Enter city name: ")
            response = response.upper()
            if response not in cities:
                print(f"City NOT found: {response}")
                exit()
            else:
                print(f"City found: {response}.")
                output = response
        else:
            city = city.upper()
            if city not in cities:
                print(f"City NOT found: {city}")
                exit()
            else:
                print(f"City found: {city}")
                output = city

        return output

    @staticmethod
    def ConvertUnixTime(inputTime):
        """
        Simple timestamp converter to create readable time data
        """
        time = datetime.fromtimestamp(inputTime)
        output = str(time)
        return output


# ------------------- Object independent static functions -------------------


# ------------------------- Demo Cli App ---------------------------

"""
See documentation for explanation of instance Demos.
"""
# Demo = WeatherStation(accessKey="3836093dde650898eb014e6f27304646",unit="imperial",lang="de")
Demo = WeatherStation()


"""
See documentation for explanation of Method Demos.
"""
#Demo.GetWeather(customfield=["time", "city", "temp","SunriSe","DESCRIPTION"])
#Demo.GetWeather(city="belgrade", customfield=["time", "city", "temp"])
Demo.GetWeather()
# Demo.GetWeather(city="berliin")
# Demo.GetWeather(city="berlin", customfield=["tiime","city"])

# ------------------------- Demo Cli App ---------------------------
