
import requests


class Wetterstation:

    def __init__(self, appid, stadt, einheiten, url, api_response=None, temp=None, truebung=None, wind=None):
        self.api_response = api_response
        self.appid = appid
        self.stadt = stadt
        self.einheiten = einheiten
        self.url = url
        self.temp = temp
        self.truebung = truebung
        self.wind = wind

    # Diese "dunder" Methode konvertiert die Rückgabewerte in Strings,
    # damit diese in der Konsole angezeigt werden können
    def __str__(self):
        return f"\nDie Abfrage URL für {self.stadt} ist: " \
               + self.url.format(appid=self.appid, einheiten=self.einheiten, stadt=self.stadt) + \
               f"\nDie aktuelle Temperatur in {self.stadt} beträgt: {self.temp}" + chr(176) + "C" + \
               f"\nDie aktuelle Trübung beträgt: {self.truebung}" + " %" + \
               f"\nDie aktuelle Windgeschwindigkeit beträgt: {self.wind}" + "km/h"

    # Verstehe die __eq__ dunder Methode nicht ganz, habe ich aus dem Internet übernommen
    # Wäre froh wenn du mir das beim Fachgespräch erklären kannst
    def __eq__(self, other):
        if \
                self.api_response == other.api_response and \
                self.appid == other.appid and \
                self.stadt == other.stadt and \
                self.einheiten == other.einheiten and \
                self.url == other.url and \
                self.temp == other.temp and \
                self.truebung == other.truebung and \
                self.wind == other.wind:
            return True
        else:
            return False

    def temperatur_aktuell(self):
        # temperatur_aktuell ruft die "Current Weather Data" API von openweathermap auf
        request_url = self.url
        # die Übergebene Basis-URL wird mit dem API Key, der gewünschten Einheiten und der gewählten Stadt,
        # was zum gewünschten Aufruf führt
        api_request = request_url.format(appid=self.appid, einheiten=self.einheiten, stadt=self.stadt)
        # Die API response in wird einer instanzierten Variable zugewiesen
        self.api_response = requests.get(api_request).json()
        self.temp = self.api_response['main']['temp']
        return self.temp

    def zusaetzliche_angaben(self):
        # zusaetzliche_angaben ruft ebenfalls die "Current Weather Data" API von openweathermap auf
        # die gesamte URL der API Abfrage wird einer instanzierten Variable zugewiesen
        request_url = self.url
        api_request = request_url.format(appid=self.appid, einheiten=self.einheiten, stadt=self.stadt)
        # Der API Request wird einer eigens instanzierten API Response variable zugewiesen
        self.api_response = requests.get(api_request).json()
        self.truebung = self.api_response['clouds']['all']
        self.wind = self.api_response['wind']['speed']
        return self.truebung, self.wind


# # ----------------------------------------------------------------------------------------------------------------
# # Tests
# # ----------------------------------------------------------------------------------------------------------------
def test_mehrere_objekte_instazieren():
    print("-----------------------------------------------------------------------------------------------------------")
    print("Test ob von der Klasse mehrere Objekte in einem Skriptlauf instanziert werden können")
    abfrage4 = Wetterstation(
        appid="42eaa3bc811e19a642f24952c37b080c",
        url="http://api.openweathermap.org/data/2.5/weather?appid={appid:s}&units={einheiten:s}&q={stadt:s}",
        einheiten="metric",
        stadt="New York City")
    abfrage4.temperatur_aktuell()
    abfrage4.zusaetzliche_angaben()
    print(str(abfrage4))

    abfrage5 = Wetterstation(
        appid="42eaa3bc811e19a642f24952c37b080c",
        url="http://api.openweathermap.org/data/2.5/weather?appid={appid:s}&units={einheiten:s}&q={stadt:s}",
        einheiten="metric",
        stadt="Winterthur")
    abfrage5.temperatur_aktuell()
    abfrage5.zusaetzliche_angaben()
    print(str(abfrage5))


def test_temperatur_aktuell():
    print("-----------------------------------------------------------------------------------------------------------")
    print("Test für die temperatur_aktuell() Methode")
    print("\n")
    abfrage2 = Wetterstation(
        stadt="Winterthur", appid="42eaa3bc811e19a642f24952c37b080c", einheiten="metric",
        url="http://api.openweathermap.org/data/2.5/weather?appid={appid:s}&units={einheiten:s}&q={stadt:s}")
    abfrage2.temperatur_aktuell()
    print("Hier ist die aktuelle Temperatur von " + abfrage2.stadt,
          "\nDie akuelle Temperatur beträgt:    " + str(abfrage2.temp) + chr(176))


def test_zusaetzliche_angaben():
    print("-----------------------------------------------------------------------------------------------------------")
    print("Test für die zusaetzliche_angaben() Methode")
    print("\n")
    abfrage3 = Wetterstation(
        appid="42eaa3bc811e19a642f24952c37b080c",
        url="http://api.openweathermap.org/data/2.5/weather?appid={appid:%s}&units={einheiten:%s}&q={stadt:%s}",
        einheiten="metric",
        stadt="Madrid")
    print("Zusätzliche Wetterangaben von: " + abfrage3.stadt,
          "\nDie akuelle Trübung beträgt:               " + str(abfrage3.truebung) + "%",
          "\nDie akuelle Windgeschwindigkeit beträgt:   " + str(abfrage3.wind) + "km/h")


# # ----------------------------------------------------------------------------------------------------------------
# # Main
# # ----------------------------------------------------------------------------------------------------------------

if __name__ == '__main__':
    if True:
        test_temperatur_aktuell()
        test_zusaetzliche_angaben()
        test_mehrere_objekte_instazieren()

#     # Willkommensmitteilung für die Konsole
#     print("---------------------------------------------------------------------------")
#     print("|                        Roberto's Wetterstation                          |")
#     print("---------------------------------------------------------------------------")
#     print("| Hier bekommst du aktuelle Wetterinformationen für die Stadt deiner Wahl |")
#
#     # Aufruf der Klasse und deren Methoden mit print Output für die Konsole
#     abfrage1 = Wetterstation(
#         appid="42eaa3bc811e19a642f24952c37b080c",
#         url="http://api.openweathermap.org/data/2.5/weather?appid={appid:s}&units={einheiten:s}&q={stadt:s}",
#         einheiten="metric",
#         stadt=input("Bitte geben Sie eine Stadt ein: "))
#     abfrage1.temperatur_aktuell()
#     abfrage1.zusaetzliche_angaben()
#     print(abfrage1)

# ----------------------------------------------------------------------------------------------------------------
# Teststatistik
# ----------------------------------------------------------------------------------------------------------------
# test_temperatur_aktuell()
#           Durchgeführt: Ja
#           Test erfolgreich: Ja
# test_zusaetzliche_angaben()
#           Durchgeführt: Ja
#           Test erfolgreich: Nein
# test_mehrere_objekte_instazieren()
#           Durchgeführt: Ja
#           Test erfolgreich: Ja
# ----------------------------------------------------------------------------------------------------------------
#  Totale Anzahl Tests: 3
#  OK : 2
#  NOK : 1
