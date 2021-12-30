# die klasse wetterZentrale ist die eigentliche Klasse, welche der Benutzer verwendet.
# die wetterZentrale ist fähig inputs vom user abzufragen und so dann die wetterSuche zu starten
# die eigentliche Suche nach Wetterdaten geht über die klasse weatherDataProvider(),
# diese ist quasi das Sammelbecken für die API von OpenWeatherMap und bietet auch Möglichkeiten
# um weitere webServices an dieser stelle als Unterklasse zu implementieren.
# via __eq__ können die Unterklassen untereinander Daten abgleichen zB der Parameter "Temperatur"
# ------------------------------------------------------------------
# Review-Results (TBD):
# Reference-Applikation:
#      + Funktioniert
#      - Keine User-Eingaben möglich
#
# Class Design und Implementation:
#      + Diagramm stimmt grösstenteils mit Code überein (+ / - für private / public)
#      + Notwendige (__eq__ __str__ __eq__) Methoden vorhanden
#      - __init__ unnötige parameter und die relevanten haben keine Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Instance Variablen sind public
#      + __str__ mit format-strings implementiert
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
# Im SEP Kurs haben wir kürzlich die Fabrikmethode besprochen, welche anfangs nur schwierig zu verstehen war
# Als Quelle für mein Modell dienen die Slide "Software Engineering Processes" von Stefan Berger
# und folgende zwei Youtube Tutorials:
# 1: https://www.youtube.com/watch?v=0tU4nf54eIw
# 2: https://www.youtube.com/watch?v=TAnG6DN-5QM

# für die Implementation der OpenWeatherMap-API benutze ich den Code, welcher auf der Webseite des Dienstleister
# dokumentiert ist.
# 1: https://openweathermap.org/current
# 2: https://github.com/csparpa/pyowm

class wetterZentrale():
    """ Diese Funktion liefert Wetterinformation zu einem Standort,
        welcher entweder via .start(location) oder per Abfrage im
        CLI übergeben wird
    """

    def __init__(self):
        self.result = ''

    def __str__(self):
        return 'wetterZentrale(searchTerm = ' + self.searchTerm + ')'

    def __eq__(self, other):
        self.searchTerm = other.searchTerm

    def start(self, searchTerm = ''):
        if not searchTerm:
            # client gibt kein argument mit starte mit manueller abfrage
            print("Herzlich willkommen bei der Wetterzentrale")
            self.searchTerm = input("Wohin soll es heute gehen? Bitte gib den Namen einer Ortschaft ein: ")
        else:
            self.searchTerm = searchTerm
        s1 = openweathermap()
        self.result = s1.get_weather(self.searchTerm)
        return self.result
        #return "hello World"

from pyowm import OWM
from pyowm.utils import config
from pyowm.utils import timestamps

class weatherDataProvider():
    """ Eine Klasse als Superklasse dient zum einbringen von einem oder mehreren Unterklassen,
        welche selbstständig und nachträglich implementiert werden können.
    """
    def __init__(self):
        pass

    def __str__(self):
        pass

    def __eq__(self, other):
        self.name = other.name


class openweathermap(weatherDataProvider):
    def __init__(self):
        self.name = "Openweathermap"
        self._owm = OWM('16728799b5e1798c0802df4622854c74')
        self.mgr = self._owm.weather_manager()
        self.searchTerm = ''

    def get_weather(self, searchTerm):
        # Search for current weather in London (Great Britain) and get details
        self.observation = self.mgr.weather_at_place(self.searchTerm)
        self.w = self.observation.weather
        return self.w.detailed_status  # 'clouds'

#Hier könnten weitere Sub Klassen implementiert werden zB "class googleweather(weatherDataProvider):"

# Test
w2 = wetterZentrale()
print(w2.start('Zurich'))
