# -----------------------------------------------------------------------------------------------
# Name: Ernesto_Escalier_A19_DS.py
#
# Description: Polling REST Service and write values to console.
#
# Author: Ernesto Escalier
#
# History:
# 18-Nov-2021   Ernesto Escalier      Initial WeatherStation
# 21-Nov-2021   Ernesto Escalier      Finalized Class WeatherStation & CLI-Application(Client)
# 23-Nov-2021   Ernesto Escalier      Finalized Documentation
# -----------------------------------------------------------------------------------------------
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      - Keine User-Eingaben möglich
#      - Pressure: 99Humidity: 97 kein Zeilenumbruch
#
# Class Design und Implementation:
#      + Diagramm stimmt mit Code überein
#      + Notwendige (__eq__ __str__) Methoden vorhanden
#      + __init__ klare Signatur mit funktionierenden Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Instance Variablen sind public
#      + docString einheitlich strukturiert für alle public methoden
#
# Test:
#      + Test (positive) implementiert
#
# Note: 5.0
#
# Fragen:
#    Wo und wie wird der Request zum Web-Service abgesendet?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------
import requests
import json
import webbrowser
import time


class WeatherStation:
    """
    A class to get information about the weather.
    She is developed as an REST-Webservice-Class which get access to a weather service which you prefer.

    Attributes
    ----------
    serviceURL : str
        set your webservice
    appId : str
        Your unique API key (you can always find it on your account page under the "API key" tab
    jsonResponse : any
        Optional variable. Has been installed for the later 2.0 version before

    Methods
    -------
    request(self):
        Establishes a connection to the web service.
    temp(self):
        Get temperature from the web service.
    pressure(self):
        Get pressure from the web service.
    humidity(self):
        Get humidity from the web service.
    lon(self):
        Get lon from the web service.
    lat(self):
        Get lat from the web service.
    cloud(self):
        Get cloud from the web service.
    land(self):
        Get land from the web service.
    location(self):
        Get location from the web service.
    wind(self):
        Get wind-speed from the web service.
    """

    def __init__(self, serviceUrlString='https://api.openweathermap.org/data/2.5/weather',
                 appIdString='144747fd356c86e7926ca91ce78ce170', jsonResponse=None):
        """
        Constructs all the necessary attributes for the weatherStation object.

        Parameters
        ----------
            serviceUrlString : str
                set your webservice
            appIdString : str
                Your unique API key (you can always find it on your account page under the "API key" tab
            jsonResponse : any
                Optional variable. Has been installed for the later 2.0 version before
        """
        self.serviceURL = serviceUrlString
        self.appId = appIdString
        self.jsonResponse = jsonResponse

    def __str__(self):
        """
        This method is also used as a debugging tool when the members of a class need to be checked.

        Parameters
        ----------
        self

        Returns
        -------
        Default connections parameters for the request to the webservice as String
        """
        return 'Weather(' + 'serviceURL=' + self.serviceURL \
               + ' ,appId=' + self.appId + ' ,jsonResponse' + str(self.jsonResponse) + ')'

    def __eq__(self, other):
        """
        Compares two objects if they belong to the same class weatherStation

        Parameters
        ----------
        self

        Returns
        -------
        Result-Message a String
        """
        print('=> Compare-Class __eq__ called: %r == %r ?' % (self, other))
        if isinstance(other, WeatherStation):
            return self.appId == other.appId

    def request(self):
        """
        Establishes a connection to the web service.

        Parameters
        ----------
        self

        Returns
        -------
        None
        """
        responseStr = requests.get(self.serviceURL + "?q=Uster&units=metric&lang=de&appid=" + self.appId)
        self.jsonResponse = json.loads(responseStr.text)

    def temp(self):
        """
        Get temperature from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        temperature as float
        """
        return self.jsonResponse['main']['temp']

    def pressure(self):
        """
        Get pressure from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        pressure as int
        """
        return self.jsonResponse['main']['pressure']

    def humidity(self):
        """
        Get humidity from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        humidity as int
        """
        return self.jsonResponse['main']['humidity']

    def lon(self):
        """
        Get lon from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        lon as String
        """
        return self.jsonResponse['coord']['lon']

    def lat(self):
        """
        Get lat from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        lat as String
        """
        return self.jsonResponse['coord']['lat']

    def cloud(self):
        """
        Get cloud from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        cloud as String
        """
        return self.jsonResponse['weather'][0]['description']

    def land(self):
        """
        Get land from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        land as String
        """
        return self.jsonResponse['sys']['country']

    def location(self):
        """
        Get location from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        location as String
        """
        return self.jsonResponse['name']

    def wind(self):
        """
        Get wind-speed from the web service.

        Parameters
        ----------
        self

        Returns
        -------
        wind-speed(km/h) as float
        """
        return self.jsonResponse['wind']['speed']


# Test with Client (CLI-Application)
run = True
print('\n\n### Initialize Test-Client (CLI-Application) ###')
print('=> Create object weatherStation_1')
weatherStation_1 = WeatherStation()
print('=> Create object weatherStation_2')
weatherStation_2 = WeatherStation()
print('=> Create object FutureWarning')
futureWarning = FutureWarning
print('=> Same Class? ' + str(weatherStation_1.__eq__(weatherStation_2)))
print('=> Same Class? ' + str(weatherStation_2.__eq__(futureWarning)))

# Test user interactivity
print('\n\n### Test-Client: Test user interactivity (CLI-Application) ###')

while run:
    print('\n\n=> Will send a new request with Init-Data ' + weatherStation_1.__str__())
    weatherStation_1.request()

    print(
        "\n== Weather Information for location " + weatherStation_1.location() + "(" + weatherStation_1.land() + ") ==")
    print("\nTemperature: " + str(weatherStation_1.temp()) + "\nPressure: " + str(weatherStation_1.pressure())
          + "\bHumidity: " + str(weatherStation_1.humidity()) + "\nlon/lat: " + str(weatherStation_1.lon()) + "/" +
          str(weatherStation_1.lat()) + "\nCloudy: " + str(weatherStation_1.cloud())
          + "\nWind(km/h): " + str(weatherStation_1.wind()))

    close = str(input("\nDo you want close the request? (y/n):"))

    if close == "y":
        run = False
        print("=> Request session closed - Test Client ended here")
    elif close == "n":
        run = True
    else:
        print('=> Input not recognized - request continues')

# The docstrings (Documentation)
run = True
while run:
    showDocs = str(input("\nDo you want see the docstrings? (y/n):"))

    if showDocs == "y":
        print('\n\n### Print the docstrings of the WeatherStation-Class ###')
        help(WeatherStation)
        run = False
    elif showDocs == "n":
        run = False
    else:
        print('=> Input not recognized')

print("\nDon't be scared - a browser window will open in 5s with the class diagram.")
time.sleep(5)
webbrowser.open('https://ibb.co/pzVtsCd')  # Go to https://de.imgbb.com/ (class diagram)

print("\n\n## Finish ##")
