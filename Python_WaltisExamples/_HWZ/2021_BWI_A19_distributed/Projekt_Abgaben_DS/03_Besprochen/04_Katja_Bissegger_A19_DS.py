# ------------------------------------------------------------------
# Name: katja_Bissegger_A19_DS.py
#
# Description:  Leistungsnachweis Distributed & Mobile Systems
#               Does a search via REST request to openweathermap (JSON)
#
# Autor: Katja Bissegger
#
# History:
# 17-Nov-2021   Katja Bissegger     Initial Version
# 19-Nov-2021   Katja Bissegger     Class WeatherStation implemented
# 20-Nov-2021   Katja Bissegger     Dunctions implemented
# 21-Nov-2021   Katja Bissegger     Unittest implemented

# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      -- Die Appliktion verwendet kein Object der Wetterstation-Class, sondern ruft statische Methode get_weather auf
#
# Class Design und Implementation:
#      + Notwendige (__init__, __str__, __eq__) Methoden vorhanden
#      - __init__ keine funktionierenden Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - get_weather ist eine static Methode und verwendet self nicht
#      - get_weather führt zum Absturz bei falscher Orts eingabe
#      + Weather Info wird in einfaches JSON umgepackt
#
# Test:
#      - Tests nur dummy mässig implementiert
#
# Note: 4.0
#
# Fragen:
#    Wo wird die Klasse definiert und wo in der Applikation wird diese instanziert
#    Wo wird der Request zum Web-Service abgesendet?
#    Wie könnte der Design der Klasse in dieser Hinsicht verbessert werden?












# ------------------------------------------------------------------
import requests
import math
import unittest

city_name = input("Enter your city: ")
api_key = "4bda89f60bca14b25567d27fe4928ce3"


# Klassendefinition
class Weatherstation:

    def __init__(self, city, lon, lat, country=None):
        self.city = city
        self.lon = float(lon)
        self.lat = float(lat)
        self.country = country

    def __str__(self):
        description = "{0} is located at {1}, {2}".format(self.city, self.lon, self.lat)

    def __eq__(self, other):
        pass

    def get_weather(api_key, city):
        # Queries the weather API and returns the weather data for a particular city.
        url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&unit=metric&lang=de"

        response = requests.get(url).json()

        main = response["weather"][0]["main"]

        descritipn = response["weather"][0]["description"]

        temp = response["main"]["temp"]
        temp = math.floor(temp - 273.15)  # Convert to Celsius

        humidity = response["main"]["humidity"]

        wind = response["wind"]["speed"]

        return {
            "main": main,
            "description": descritipn,
            "temp": temp,
            "humidity": humidity,
            "wind": wind
        }

    weather = get_weather(api_key, city_name)

    print("Weather for city: ", city_name)
    print("Main conditions:  ", weather["main"])
    print("Description:      ", weather["description"])
    print("Temperature:      ", weather["temp"], "Grad")
    print("Humidity:         ", weather["humidity"], "%")
    print("Wind:             ", weather["wind"], "km/h")


"""Testing"""
"""
class TestWeatherStation(unittest.TestCase):

    def test_city(self):
        # Check if choosen city exists
        pass

    def test_fake_Data(self):
        # Checks if correct data is retrieved
        pass

    def test_request_response(self):
        # Checks if response status is OK
        pass

        
if __name__ == "__main__":
    unittest.main()
"""
