"""
Hiermit bestätige, dass ich mich mit niemenandem über dieses Testat ausgetauscht habe.

Verwendete Python Version: 3.10.0

Das Klassendiagram ist hier zu finden:
https://lukaspellegrini.com/html/Stations_Design.jpg

Factory Design Pattern Referenz:
https://www.youtube.com/watch?v=s_4ZrtQs8Do&ab_channel=ArjanCodes

"""
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Design stimmt mit Implementation überein
#      -- Funktioniert nicht (Syntax-Error)
#      + User-Eingaben möglich
#      + Falsche Usereingaben werden abgefangen
#      + gut documentiert mit docStrings
#
# Class Design und Implementation:
#      + Notwendige (__init__ __str__ __eq__) Methoden vorhanden
#      - __init__ mit allen relevanten Argument vorhanden
#      + __init__ Argumente haben funktionierende Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - lese-argumente (z.B. pressure) sollten auf None intitialisiert werden (eigentlich gat nicht nötig)
#      - Alle Instance Variablen sind public
#      - Kein Error / exception handling in der Klasse
#      - Sehr complexe Strruktur mit Abstrakten Klassen, Factory,...). Wieso?
#
# Test:
#      + UNit Tests geschrieben
#
# Note: 5.0
#
# Fragen:
#    Auf welcher Zeile wird der Request zum Web-Service abgesendet?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------
import unittest
import requests
import json

from abc import ABC, abstractmethod


#  _______               _
# (_______)          _  (_)
#     _ _____  ___ _| |_ _ ____   ____
#    | | ___ |/___|_   _) |  _ \ / _  |
#    | | ____|___ | | |_| | | | ( (_| |
#    |_|_____|___/   \__)_|_| |_|\___ |
#                               (_____|


class Test_Wetterstation(unittest.TestCase):
	"""Test the first method of the Wetterstation."""

	def setUp(self):
		"""Set up test fixtures for further tests"""

		#Create a Station with factory
		self.weather_station = factory.create_Station()


	def test_get_results(self):
		"""Test the get_results function whether it returns a result"""

		self.weather_station.get_results()
		json_response = self.weather_station.__str__()
		self.assertTrue(json_response)


	def test_set_search_criteria(self):
		"""Test the set_search_criteria function whether it adapts to give a
			criteria
			Here it should check if the manually changed Location has been
			correctly altered."""

		self.assertEqual(self.weather_station.set_search_criteria("Bern"), "Bern")


	@unittest.skip("not yet implemented")
	def test_get_results_with_added_token(self):
		"""Test the get_results function whether it accepts a user api token"""

		#sets the search criteria
		self.weather_station.set_search_criteria("Luzern", "Tomorrow")


		self.self.fail('This should not happen yet')

	@unittest.expectedFailure
	def test_get_results_with_bad_entry(self):
		"""Test the get_results function whether it gives result with an int value"""


		#sets the search criteria, in this case wrongly
		self.weather_station.set_search_criteria(100)

		#get the results
		my_weather_station.get_results()



#  _  _  _                                                     _
# (_)(_)(_)        _     _                     _           _  (_)
#  _  _  _ _____ _| |_ _| |_ _____  ____ ___ _| |_ _____ _| |_ _  ___  ____
# | || || | ___ (_   _|_   _) ___ |/ ___)___|_   _|____ (_   _) |/ _ \|  _ \
# | || || | ____| | |_  | |_| ____| |  |___ | | |_/ ___ | | |_| | |_| | | | |
#  \_____/|_____)  \__)  \__)_____)_|  (___/   \__)_____|  \__)_|\___/|_| |_|
#



class Wetterstation(ABC):
	"""Wetterstation abstrakte Klasse."""

	@abstractmethod
	def __str__(self):
		"""For nice printouts"""

	@abstractmethod
	def __eq__(self):
		"""For comparisons"""


	@abstractmethod
	def get_results(self):
		"""gets the results from the service"""


	@abstractmethod
	def set_search_criteria(self, location):
		"""Sets the search criterias for large or small pool of results."""



class OpenWeather_Station(Wetterstation):
	"""OpenWeather specific station."""

	def __init__(self):
		self.location = "Zurich"
		self.temp = temp = 0
		self.pressure = pressure = 0
		self.humidity = humidity = 0
		self.cloud = cloud = 0
		self.serviceURL = "https://api.openweathermap.org/data/2.5/weather"
		self.appId = "3836093dde650898eb014e6f27304646"
		self.unit = "metric"
		self.lang = "de"
		self.dict = {"temp": 0,
					 "pressure": 0,
					 "humidity": 0,
					 "cloud": "nothing"}
		self.json = 0

	def __str__(self):
		"""For nice printouts"""
		return f'{self.json} at/in {self.location}'


	def __eq__(self, other):
		"""For comparing stations assuming stations with identical location
		are in fact the same Wetterstation."""
		if isinstance(other, OpenWeather_Station):
			if other.location == self.location:
				return True
			return False

	def get_results(self):
		"""gets OpenWeather results."""
		responseStr = requests.get(
			self.serviceURL +
			"?q="+self.location+
			"&units="+self.unit+
			"&lang="+self.lang+
			"&appid=" + self.appId)

		jsonResponse = json.loads(responseStr.text)
		self.dict["temp"] = jsonResponse['main']['temp']
		self.dict["pressure"] = jsonResponse['main']['pressure']
		self.dict["humidity"] = jsonResponse['main']['humidity']
		self.dict["cloud"] = jsonResponse['weather'][0]['description']
		#print(temp, pressure, humidity, cloud)
		self.json = json.dumps(self.dict)
		return self.json


	def set_search_criteria(self, location):
		"""Specifies OpenWeather results"""
		#self.location = input("From which location? eg Zurich, Luzern: ") or "Luzern"
		self.location = location
		return self.location


class Opendata_Swiss_Station(Wetterstation):
	"""opendata.swiss specific station."""

	def __str__(self):
		"""For nice printouts"""

	def get_results(self):
		"""Gets opendata.swiss results."""

	def set_search_criteria(self, location):
		"""Specifies opendata.swiss results."""


#  _______
# (_______)            _
#  _____ _____  ____ _| |_ ___   ____ _   _
# |  ___|____ |/ ___|_   _) _ \ / ___) | | |
# | |   / ___ ( (___  | || |_| | |   | |_| |
# |_|   \_____|\____)  \__)___/|_|    \__  |
#                                    (____/


class Stations_Factory(ABC):
	"""
	A Factory which creates Wetterstationen.
	The Wetterstationen are not maintained by this factory.
	"""

	@abstractmethod
	def create_Station(self) -> Wetterstation:
		"""Returns a new weather_station belonging to this factory."""



class Json_Station_Factory(Stations_Factory):
	"""Factory aimed at providing a good quality export."""

	def create_Station(self) -> Wetterstation:
		return OpenWeather_Station()

class Xml_Station_Factory(Stations_Factory):
	"""Factory aimed at providing a mediocre quality export."""

	def create_Station(self) -> Wetterstation:
		return Opendata_Swiss_Station()



def read_factory() -> Stations_Factory:
	"""Constructs a station factory based on the user's preference."""

	factories = {
		"openweather": Json_Station_Factory(),
		"opendataswiss": Xml_Station_Factory(),
	}
	while True:
		export_format = input("Enter desired output quality (openweather, opendataswiss): ") or "openweather"
		if export_format in factories:
			return factories[export_format]
		print(f"Unknown output quality option: {export_format}.")

#  _______       _
# (_______)     (_)
#  _  _  _ _____ _ ____
# | ||_|| (____ | |  _ \
# | |   | / ___ | | | | |
# |_|   |_\_____|_|_| |_|
#


def main(factory: Stations_Factory) -> None:
	"""Main function."""

	#retreive the exporters
	my_weather_station = factory.create_Station()

	#sets the search criteria
	my_weather_station.set_search_criteria("Luzern")

	#get the results
	my_weather_station.get_results()

	#printout results
	json_response = my_weather_station.__str__()
	print(json_response)




if __name__ == "__main__":

	#create the factory
	factory = read_factory()

	#perform the exporting job
	main(factory)

	unittest.main()
