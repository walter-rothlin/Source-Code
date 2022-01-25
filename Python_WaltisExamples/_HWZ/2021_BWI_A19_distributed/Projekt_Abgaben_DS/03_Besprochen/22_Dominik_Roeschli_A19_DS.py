# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + User-Eingaben möglich
#      + Unsinnige Usereingaben werden abgefangen
#
# Class Design und Implementation:
#      + Diagramm stimmt mit Code überein
#      + Notwendige (__init__ __str__ __eq__) Methoden vorhanden
#      - __init__ unnötige parameter und die relevanten haben keine Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Instance Variablen sind public
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
# ------------------------------------------------------------------
# Name: Dominik_Roeschli_A19_DS.py
#
# Description:
# Creation of a WeatherStation class, which can be used for various web services for weather services.
# For the POC Openweather was implemented and several test cases were written.
#
# Autor: Dominik Roeschli
#
# History:
# 16-Nov-2021   Walter Rothlin          Announcement of the assignment
# 17-Nov-2021   Dominik Roeschli        Understanding the task, design considerations and writing the unit tests
# 18-Nov-2021   Dominik Roeschli        working on the task
# 19-Nov-2021   Dominik Roeschli        working on the task
# 20-Nov-2021   Dominik Roeschli        working on the task
# 21-Nov-2021   Dominik Roeschli        working on the task
# 22-Nov-2021   Dominik Roeschli        working on the task
# 23-Nov-2021   Dominik Roeschli        Completion and submission of the work
#
# Design Documentation (Class-Diagram):
# https://fhhwz.sharepoint.com/:i:/s/IntroductionintoPython/Ef7RY3BrrXFCgGnrRSdSdFMBzv7fQlaVlzBNkEz_i9Uazg?e=jjQlRg
#
# Reading:
# https://openweathermap.org/current
# https://openweathermap.org/current#current_JSON
# https://docs.python.org/3/tutorial/classes.html
# https://realpython.com/python-interface/
# https://docs.python.org/3/tutorial/errors.html
# https://pakstech.com/blog/python-build-urls/
# https://docs.python-requests.org/en/latest/user/quickstart/
# https://www.pythontutorial.net/python-oop/python-__eq__/
# https://docs.python.org/3/library/typing.html
# https://docs.python.org/3/library/unittest.html
# https://docs.python.org/3/library/unittest.mock.html
# https://docs.python.org/3/library/argparse.html
# https://stackoverflow.com/questions/985505/locale-date-formatting-in-python
# https://www.python.org/dev/peps/pep-0257/
# https://www.tutorialsteacher.com/python/public-private-protected-modifiers
# ------------------------------------------------------------------

import sys
import argparse
import babel.dates as babel
import urllib.parse as urlparse
import requests
from datetime import datetime
from requests import HTTPError, Response
from unittest import TestCase
from unittest.mock import MagicMock

# --- cli ---

def cli(arguments):
    """
    Simple command line interface

    :param arguments: command line arguments
    :return: exit code
    """
    parser = argparse.ArgumentParser(description="Fragt die Momentanen Wetterdaten einer " +
                                                 "Ortschaft über die OpenWeather API ab",
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--app-id", type=str, default="7798a0c7cfce3abb7b3329814d5dae23",
                        help="OpenWeather App ID")
    parser.add_argument("question", type=str, help="Name der Ortschaft von der die Momentanen Wetter Daten " +
                                                   "abgefragt werden sollen")

    # if no arguments are supplied
    if not arguments:
        parser.print_help()
        return 1
    args = parser.parse_args(arguments)

    weather_station = OpenWeatherWeatherStation(args.app_id, "metric", "de")
    current_weather = weather_station.get_current_weather(args.question)

    if current_weather:
        print("Die Anfrage \"" + args.question + "\" hat ergeben:\n")
        print("Ortschaft:            " + current_weather.name)
        print("Temperatur:           " + str(current_weather.temperature) + " °C")
        print("Wetter:               " + current_weather.description)
        print("Feuchtigkeit:         " + str(current_weather.humidity) + "%")
        print("Windgeschwindigkeit:  " + str(current_weather.wind_speed) + " m/sek")
        print("Luftdruck:            " + str(current_weather.pressure) + " hPa")
        print("Zuletzt aktualisiert: " + babel.format_datetime(current_weather.timestamp, locale="de_CH"))
    else:
        print("Die Anfrage \"" + args.question + "\" hat nichts ergeben")


# --- WeatherStation interface ---

class WeatherStation:
    """
    Interface to be implemented by different weather sources
    """

    def get_current_weather(self, question: str):
        """
        Get current weather at an specified location

        :param question: Name of the location for requested current weather
        :return: data from API or None if nothing was found for the given question
        :raises WeatherStationException: if something went wrong
        """
        pass


class Weather:
    """
    Executes all actual requests to the OpenWeather API

    Attributes
    ----------
    name : str
        name of the location
    temperature : float
        temperature at the location
    description : str
        description of weather at the location; e.g. clear sky
    humidity : int
        air humidity at the location
    wind_speed : float
        wind speed at the location
    pressure : float
        ait pressure at the location
    timestamp : datetime
        timestamp when data was last updated
    """

    def __init__(self, name: str, temperature: float, description: str, humidity: int, wind_speed: float,
                 pressure: float, timestamp: datetime):
        """
        :param name: name of the location
        :param temperature: temperature at the location
        :param description: description of weather at the location
        :param humidity: air humidity at the location
        :param wind_speed: wind speed at the location
        :param pressure: ait pressure at the location
        :param timestamp: timestamp when data was last updated
        """
        self.name = name
        self.temperature = temperature
        self.description = description
        self.humidity = humidity
        self.wind_speed = wind_speed
        self.pressure = pressure
        self.timestamp = timestamp

    def __str__(self):
        return "Weather(name=" + self.name + ", temperature=" + str(self.temperature) + \
               ", description=" + self.description + ", humidity=" + str(self.humidity) + \
               ", wind_speed=" + str(self.wind_speed) + ", pressure=" + str(self.pressure) + \
               ", timestamp=" + str(self.timestamp) + ")"

    def __eq__(self, other):
        return isinstance(other, Weather) and \
               self.name == other.name and \
               self.temperature == other.temperature and \
               self.description == other.description and \
               self.humidity == other.humidity and \
               self.wind_speed == other.wind_speed and \
               self.pressure == other.pressure and \
               self.timestamp == other.timestamp


class WeatherStationException(Exception):
    """
    Attributes
    ----------
    question : str
        used for call that failed
    message : str
        detailed error message of what went wrong
    """

    def __init__(self, question: str, message: str):
        """
        :param question: question that failed
        :param message: detailed error message
        """
        self.question = question
        self.message = message

    def __str__(self):
        return "Request with question \"" + self.question + "\" failed with message: " + self.message


# --- WeatherStation implementation based on OpenWeather ---

class OpenWeatherWeatherStation(WeatherStation):
    """
    :class:`WeatherStation` implementation based on the OpenWeather API

    Methods
    -------
    get_current_weather(question: str)
    """

    def __init__(self, app_id: str = "7798a0c7cfce3abb7b3329814d5dae23", units: str = "metric", language: str = "de"):
        """
        :class:`WeatherStation` implementation based on the OpenWeather API

        :param app_id: OpenWeather App ID
        :param units: Unit of measurement the API should return
        :param language: Language in which localized fields the API should return
        """
        self._rest_client = OpenWeatherRestClient(app_id, units, language)

    def get_current_weather(self, question: str):
        """
        Get current weather at an specified location

        :param question: Name of the location for requested current weather
        :return: data from API or None if nothing was found for the given question
        :raises WeatherStationException: if something went wrong with the API call
        """
        try:
            request = self._rest_client.request_current_weather(question)
            return Weather(request["name"], request["main"]["temp"], request["weather"][0]["description"],
                           request["main"]["humidity"], request["wind"]["speed"], request["main"]["pressure"],
                           datetime.utcfromtimestamp(request["dt"]))
        except HTTPError as exception:
            if exception.response.status_code == 404:
                return None
            else:
                raise WeatherStationException(question, exception.response.json()['message']) from exception


class OpenWeatherRestClient:
    """
    Executes all actual requests to the OpenWeather API

    Methods
    -------
    request_current_weather(question: str)
        Requests the current weather at an location specified in the question parameter
    """

    _scheme = "https"
    _netloc = "api.openweathermap.org"
    _path = "/data/2.5/weather"

    def __init__(self, app_id: str, units: str, language: str):
        """
        Executes all actual requests to the OpenWeather API

        :param app_id: OpenWeather App ID
        :param units: Unit of measurement the API should return
        :param language: Language in which localized fields the API should return
        """
        self._app_id = app_id
        self._units = units
        self._language = language

    def request_current_weather(self, question: str):
        """
        Requests current weather at an specified location; see # https://openweathermap.org/current for more information

        :param question: Name of the location for requested current weather
        :return: JSON response
        :raises HTTPError: if request is not ok
        """
        query = urlparse.urlencode(dict({"q": question, "units": self._units,
                                         "lang": self._language, "appid": self._app_id}))
        url = urlparse.urlunsplit((self._scheme, self._netloc, self._path, query, ""))
        response = requests.get(url)
        # check if API request was successful; if yes -> return body as json, if not -> use requests module helper
        #   function to raise corresponding HTTPError
        if response.status_code != 200:
            response.raise_for_status()
        else:
            return response.json()


# --- tests ---

class TestWeather(TestCase):

    def test_eq_true(self):
        """equals with two identical Weather objects"""
        this = Weather("Test City", 23.5, "clear sky", 5, 54.5, 2.4, datetime.utcfromtimestamp(1637189339))
        that = Weather("Test City", 23.5, "clear sky", 5, 54.5, 2.4, datetime.utcfromtimestamp(1637189339))
        self.assertEqual(this, that)

    def test_eq_false(self):
        """equals with two different Weather objects"""
        this = Weather("Test City 1", 23.5, "clear sky", 5, 54.5, 2.4, datetime.utcfromtimestamp(1637189339))
        that = Weather("Test City 2", -20, "snowing", 2, 66.6, 1.9, datetime.utcfromtimestamp(1637189425))
        self.assertNotEqual(this, that)

    def test_eq_false_type(self):
        """equals with a Weather object and a non Weather object"""
        this = Weather("Test City 1", 23.5, "clear sky", 5, 54.5, 2.4, datetime.utcfromtimestamp(1637189339))
        that = "Not a Weather object"
        self.assertNotEqual(this, that)

    def test_str(self):
        """str as excepted"""
        this = Weather("Test City", 23.5, "clear sky", 5, 54.5, 2.4, datetime.utcfromtimestamp(1637189339))
        str_out = "Weather(name=Test City, temperature=23.5, description=clear sky, humidity=5, " + \
                  "wind_speed=54.5, pressure=2.4, timestamp=2021-11-17 22:48:59)"
        self.assertEqual(str(this), str_out)


class TestOpenWeatherWeatherStation(TestCase):
    mock_response_json = {
        "coord": {
            "lon": -122.08,
            "lat": 37.39
        },
        "weather": [
            {
                "id": 800,
                "main": "Clear",
                "description": "clear sky",
                "icon": "01d"
            }
        ],
        "base": "stations",
        "main": {
            "temp": 282.55,
            "feels_like": 281.86,
            "temp_min": 280.37,
            "temp_max": 284.26,
            "pressure": 1023,
            "humidity": 100
        },
        "visibility": 16093,
        "wind": {
            "speed": 1.5,
            "deg": 350
        },
        "clouds": {
            "all": 1
        },
        "dt": 1560350645,
        "sys": {
            "type": 1,
            "id": 5122,
            "message": 0.0139,
            "country": "US",
            "sunrise": 1560343627,
            "sunset": 1560396563
        },
        "timezone": -25200,
        "id": 420006353,
        "name": "Mountain View",
        "cod": 200
    }

    def mock_response(self, code: int, message: str):
        """helper method to construct a mock http response from the requests module"""
        mock_response = Response()
        mock_response.status_code = code
        mock_response.json = MagicMock(return_value={"message": message})
        return mock_response

    def test_get_current_weather_200(self):
        """request OK"""
        service = OpenWeatherWeatherStation("valid_app_id")
        service._rest_client.request_current_weather = MagicMock(return_value=self.mock_response_json)
        self.assertEqual(service.get_current_weather("Mountain View").name, "Mountain View")
        service._rest_client.request_current_weather.assert_called_with("Mountain View")

    def test_get_current_weather_404(self):
        """request not found"""
        service = OpenWeatherWeatherStation("valid_app_id")
        service._rest_client.request_current_weather = \
            MagicMock(side_effect=HTTPError(response=self.mock_response(404, "Mocked 404")))
        self.assertIsNone(service.get_current_weather("Gugus"))
        service._rest_client.request_current_weather.assert_called_with("Gugus")

    def test_get_current_weather_401(self):
        """request with invalid app id"""
        service = OpenWeatherWeatherStation("invalid_app_id")
        service._rest_client.request_current_weather = \
            MagicMock(side_effect=HTTPError(response=self.mock_response(401, "Mocked 401")))
        with self.assertRaises(WeatherStationException):
            service.get_current_weather("Mountain View")
        service._rest_client.request_current_weather.assert_called_with("Mountain View")


# --- main ---

if __name__ == '__main__':
    # entry point for cli; shave of first command line argument since it is the program name itself
    sys.exit(cli(sys.argv[1:]))
