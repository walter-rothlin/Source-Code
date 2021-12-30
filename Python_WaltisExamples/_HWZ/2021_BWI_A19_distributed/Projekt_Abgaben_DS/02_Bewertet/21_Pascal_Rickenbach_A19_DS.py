# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Design stimmt mit Implementation überein
#      + User-Eingaben möglich
#      - Funktioniert nicht mit sinnlosen Parametern
#
# Class Design und Implementation:
#      + Notwendige (__eq__ __str__ __eq__) Methoden vorhanden
#      - __init__ mit allen relevanten Argument vorhanden
#      + __init__ Argumente haben funktionierende Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - lese-argumente (z.B. pressure) sollten auf None intitialisiert werden (eigentlich gat nicht nötig)
#      - Alle Instance Variablen sind public
#      - Kein Error / exception handling in der Klasse
#
# Test:
#      +/- reusable Tests geschrieben
#
# Note: 4.5
#
# Fragen:
#    Auf welcher Zeile wird der Request zum Web-Service abgesendet?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------
import json
import pandas as pd #pip install pandas
import requests
from requests.models import HTTPError


#Link to Class Diagram
"https://fhhwz-my.sharepoint.com/:i:/g/personal/pascal_rickenbach_student_fh-hwz_ch/Ec7lN9lHfSVGjh3tQAnQPHUBHyNVC_4AhOaxGP55xQ_U0Q?e=vI6gcU"
class WeatherStation:
    def __init__(self, name, appID="14432931c7db8050bbc0f14ad17a2403", unit="metric"):
        self.unit = unit
        self.name = name
        self.appID = appID
        self.json_data = {}
    
    def getAPIData(self):
        self.api_uri = "http://api.openweathermap.org/data/2.5/weather?q={}&appid={}&units={}".format(self.name, self.appID, self.unit)
        self.request_data = requests.get(self.api_uri)
        if self.request_data.status_code != 200:
            raise HTTPError("Couldn't process request.")
        else: 
            json1 = json.loads(self.request_data.text)
            self.json_data.update(json1)
            return(self.json_data)

    def coordinates(self) -> None:
        self.response = (self.json_data["coord"]["lat"], self.json_data["coord"]["lon"])
        return self.response

    def temp(self) -> None:
        self.temperature = self.json_data["main"]["temp"]
        return self.temperature

    def pressure(self) -> None:
        self.psi = self.json_data["main"]["pressure"]
        return self.psi

    def humidity(self) -> None:
        self.hum = self.json_data["main"]["humidity"]
        return self.hum
    
    def wind(self) -> None:
        if self.json_data["wind"]["deg"] >= 315 or self.json_data["wind"]["deg"] <= 45:
            return "North"
        elif self.json_data["wind"]["deg"] >= 46 and self.json_data["wind"]["deg"] <= 135:
            return "East"
        elif self.json_data["wind"]["deg"] <= 225 and self.json_data["wind"]["deg"] >=136:
            return "South"
        else: return "West"

    def __eq__(self, other):
        return self.unit == other.unit

    def __str__(self):
        return f'The Weatherstation is called {self.name} and units are {self.unit}'
        
    def __repr__(self):
        return f'WeatherStation(name={self.name}, unit={self.unit}'
    
#User Input for City
w = WeatherStation(input("insert a name: "))
w.getAPIData()
print("Wind is coming from {}".format(w.wind()))
print("Temperature is {}°".format(w.temp()))
print("Air pressure is {}hPa".format(w.pressure()))
print("humidity is {}%".format(w.humidity()))





"""Testing various cities"""
#w2 = WeatherStation("zürich")
#w3 = WeatherStation("paris")
#print(w.__str__())
#print(w.__repr__())
#print(w)


"""Testing first version without class"""
#test1 = WeatherStation(temp=50)
#print(test1.temp)

#Test function place: default values work, overwrite works, mistake with "self" solved, returns None as well?
#place_test = WeatherStation.place()
#print(place_test)
#
#coords_test = WeatherStation.coords(lon=-89.65498798495, lat=-179.9999999999)
#print(coords_test)

"""test if api request works"""
#https://openweathermap.org/api
#city_input = "london"
#appID = "14432931c7db8050bbc0f14ad17a2403"
#unit = "metric" #choose standard (kelvin), metric or imperial
#api_url = "http://api.openweathermap.org/data/2.5/weather?q={}&appid={}&units={}".format(city_input, appID, unit)
#API returns Error401 as of now -> probably API Key isn't acitvated yet (17.11.2021, 22:00) -> activated at 22:20
#print(api_url)
# Waltis URL worked: api_url = "http://api.openweathermap.org/data/2.5/weather?q=Wangen%20SZ&appid=3836093dde650898eb014e6f27304646"
#request_data = requests.get(api_url)
#print("http Status Code: " + str(request_data.status_code))
#json_response = json.loads(request_data.text)
#print(json_response)

"""Playing with Pandas to figure out Json response"""
#df = pd.json_normalize(json_response)
#df.to_json("response.json")

"""get values from response"""
#temp = json_response["main"]["temp"]
#pressure = json_response["main"]["pressure"]
#humidity = json_response["main"]["humidity"]
#lon = json_response["coord"]["lon"]
#lat = json_response["coord"]["lat"]
#station_name = json_response["name"]
#country = json_response["sys"]["country"]
#place = station_name + ", " + country
#sunrise = json_response["sys"]["sunrise"]
#sunset = json_response["sys"]["sunset"]
#sunrise_in_datetime = datetime.utcfromtimestamp(sunrise).strftime('%H:%M')
##sunset_in_datetime = datetime.utcfromtimestamp(sunset, timezone.utc).strftime('%H:%M')
##daylight = datetime.utcfromtimestamp(sunset - sunrise, timezone.utc).strftime('%Hh %Mm')
##time_in_cet = sunrise.astimezone()

"""test responses"""
#print("Ort: " + place)
#print("Temperatur [°C]: " + str(temp))
#print("Luftdruck [hPa]: " + str(pressure))
#print("Luftfeuchtigkeit [%]: " + str(humidity))
#print("Längegrad: " + str(lon))
#print("Breitegrad: " + str(lat))
#print(sunrise_in_datetime)
##print(sunset_in_datetime)
##print(daylight)