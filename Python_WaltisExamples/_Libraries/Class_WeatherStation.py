# ------------------------------------------------------------------
# Name: Class_Wetterstation.py
#
# Description: DAO for Wetter-Daten using openWeather API
# https://openweathermap.org/current
#
# Autor: Walter Rothlin
#
# History:
# 28-Nov-2021   Walter Rothlin      Initial Version ()
# ------------------------------------------------------------------
from waltisLibrary import *
import gzip

class WeatherStation:
    waltisAppID = "144747fd356c86e7926ca91ce78ce170"
    """
    A class to get information about the weather.
    Uses an REST-Webservice i.e. OpenWeather
    API            : https://openweathermap.org/current
    Example Request: https://api.openweathermap.org/data/2.5/weather?q=uster&appid=144747fd356c86e7926ca91ce78ce170&units=metric&lang=de
    Similar Class  : # PyOWM is a client Python wrapper library for OpenWeatherMap (OWM) web APIs https://github.com/csparpa/pyowm
 
    Usage:
    waltisWetterstation = WeatherStation(location=ort, mode=mode, units=units, lang=lang, serviceURL=serviceURL, appId=appId)
    if waltisWetterstation.getStatusMsg() == 'ok':
        weatherData = waltisWetterstation.getCurrentWeather()

    z.B.    Stadtname         : Uster
            Breitengrad (lat): 47.3471
            Längengrad  (lon): 8.7209
    """

    def __init__(self,
                 location="Zurich",
                 mode=None,
                 units='metric',
                 lang='de',
                 serviceURL="https://api.openweathermap.org/data/2.5/weather",
                 appId=waltisAppID):
        self.__location = location.lower()
        self.__mode = mode
        self.__units = units
        self.__lang = lang
        self.__appId = appId
        self.__serviceURL = serviceURL
        self.__params = dict(q=self.__location, appid=self.__appId, mode=self.__mode,
                             units=self.__units, lang=self.__lang)
        self.__statusMsg = 'ok'
        self.__lastRequestTime = ''
        self.__requestURL = ''
        self.__result = {}
        if "errorCode" in self.getCurrentWeather():
            self.__statusMsg = self.getCurrentWeather()['errorMsg']

    def __str__(self):
        strDict = {"Wetterstation" : self.__location}
        strDict.update({"LastRequest" : self.__lastRequestTime})
        strDict.update(self.__params)
        strDict.update({"requestUrl" : self.__requestURL})
        strDict.update({"Results": self.__result})
        strDict.update({"Status": self.__statusMsg})

        return json.dumps(strDict, indent=4)

    def __eq__(self, result):
        return True

    # Business Methods:
    def getStatusMsg(self):
        return self.__statusMsg

    def getLocation(self):
        return self.__location

    def getCurrentWeather(self):
        response = requests.get(url=self.__serviceURL, params=self.__params)
        self.__requestURL = response.url

        if response.status_code == 404:
            return dict(errorCode=response.json()['cod'], errorMsg=response.json()['message'])
        else:
            jsonResponse = response.json()

            dtValue = jsonResponse['dt']    # timestamp der Messung
            # tbc:  dt = str(datetime.fromtimestamp(dtValue).strftime('%d.%m.%Y %H:%M:%S'))
            self.__lastRequestTime = '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())
            self.__result = dict(timeStamp=self.__lastRequestTime,
                          # params=self.__params,
                          # requestUrl=self.__requestURL,

                          # measureTime=str(datetime.fromtimestamp(dtValue).strftime('%d.%m.%Y %H:%M:%S')),
                          measureTime=dtValue,
                          ortsname=jsonResponse['name'],
                          land=jsonResponse['sys']['country'],
                          lon = jsonResponse['coord']['lon'],
                          lat = jsonResponse['coord']['lat'],
                          temp = jsonResponse['main']['temp'],
                          pressure = jsonResponse['main']['pressure'],
                          humidity = jsonResponse['main']['humidity'],
                          cloud=jsonResponse['weather'][0]['description'],
                          icon='http://openweathermap.org/img/w/' + jsonResponse['weather'][0]['icon'] + '.png',
                          windSpeed=jsonResponse['wind']['speed'],
                          windDirection = jsonResponse['wind']['deg']
                          )
            return self.__result

    @staticmethod
    def getAviableCities():
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
    def searchClosestCity(lat=47.3471, lon=8.7209, maxCount = 2, appid=waltisAppID):
        """
        Downloads close cities for given lat/lon   ==> Uster.
        """
        cityResponse = requests.get('http://api.openweathermap.org/geo/1.0/reverse?' +
                                'lat=' + str(lat) + '&' +
                                'lon=' + str(lon) + '&' +
                                'limit=' + str(maxCount) + '&' +
                                'appid=' + appid)
        if cityResponse.status_code != 200:
            cityResponseJson = json.loads(cityResponse.text)
        else:
            cityResponseJson = json.loads(cityResponse.text)
        return cityResponseJson

    @staticmethod
    def validateCity(city=None):
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

    # Static Method a reference implementation
    @staticmethod
    def weatherPolling(ort="Uster",
                       pollingTime=5,
                       mode=None,
                       units='metric',
                       lang='de',
                       serviceURL="https://api.openweathermap.org/data/2.5/weather"):
        if pollingTime is None:
            pollingTime = readFloat("Polling-Time [s]:", min=1, max=3600)

        ortNotCorrect = True
        while ortNotCorrect:
            if ort is None:
                ort = input("Ort  [*Uster]   :")
                if ort == "":
                    ort = 'Uster'

            waltisWetterstation = WeatherStation(location=ort, mode=mode, units=units, lang=lang, serviceURL=serviceURL)

            if waltisWetterstation.getStatusMsg() != 'ok':
                print("User Input incorrect:", waltisWetterstation.getStatusMsg())
                ortNotCorrect = True
            else:
                print(waltisWetterstation)
                print("\n=========================================\n")
                ortNotCorrect = False

        # main Loop
        doLoop = True
        while doLoop:
            weatherData = waltisWetterstation.getCurrentWeather()
            print(json.dumps(weatherData, indent=4))
            print("\n-----------------------------------------\n")
            if waltisWetterstation.getStatusMsg() != 'ok':
                print("App Terminated! Reason:", waltisWetterstation.getStatusMsg())
                doLoop = False
            else:
                time.sleep(pollingTime)


if __name__ == "__main__":
    help(WeatherStation)
    # print("Available cities:\n", WeatherStation.GetCities())
    print("Closest cities:\n", WeatherStation.searchClosestCity())

    WeatherStation.weatherPolling(ort=None, pollingTime=None)
