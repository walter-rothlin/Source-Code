# ------------------------------------------------------------------
# Name: Marko_Kutlesa_A19_DS.py
#
# Author: Marko_Kutlesa
#
# Date: 2021/11/24 Version: 1.0
# Date: 2021/11/26 Version: 1.1
#
#https://stackoverflow.com/questions/16768302/does-python-have-a-tostring-equivalent-and-can-i-convert-a-class-to-string
#https://stackoverflow.com/questions/54557501/what-is-the-correct-syntax-for-eq-other-in-python
#https://github.com/Keith-Howard/Weather-Data/blob/main/main.py
#https://stackoverflow.com/questions/61154233/getting-attribute-error-while-creating-a-class-to-fetch-weather-data-in-python
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      - Keine user-Eingaben möglich
#
# Class Design und Implementation:
#      + Design-Diagramm vorhanden und stimmt mit Implementation überein
#      + Notwendige (__init__ __str__ __eq__) Methoden vorhanden
#      - __init__ nicht alle relevanten Argumente vorhanden
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      + Alle Instance Variablen sind private
#      + Exception Handling für City implementiert
#
# Test:
#      + Tests (positive/negative) implementiert
#
# Note: 5.0
#
# Fragen:
#    Auf welcher Zeile wird der Request zum Web-Service abgesendet?
#    Wann wird __init__ aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
# ------------------------------------------------------------------
#import tkinter as tk
import requests
import time


class Weatherstation:

    __city = False #Defaultwerte
    __condition = False #Defaultwerte
    __temp = False #Defaultwerte
    __min_temp = False #Defaultwerte
    __max_temp = False #Defaultwerte
    __pressure = False #Defaultwerte
    __humidity = False #Defaultwerte
    __wind = False #Defaultwerte
    __sunrise = False #Defaultwerte
    __sunset = False #Defaultwerte


    def __init__(self, app_id="7e258ff877c553ed528e46655eb0d0b2"): #The __init__() constructor function is called when a program creates an instance of the c_ncei_data_service_api class. It takes these input parameters:
        self.__app_id = app_id # Set the base API URL.

    def __str__(self): #The __str__ method is called when the following functions are invoked on the object and return a string:
        return self.toString()

    def __eq__(self, other): #Python automatically calls the __eq__ method of a class when you use the == operator to compare the instances of the class.
        if other.__city == self.__city:  # By default, Python uses the is operator if you don’t provide a specific implementation for the __eq__ method.
            return True
        return False


#Import the requests and JSON modules.
#Initialize the city and API key.
#Update the base URL with the API key and city name.
#Send a get request using the requests. get() method.
#And extract the weather info using the JSON module from the response.

    def getWeather(self, city):
        api = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid="+self.__app_id+"&units=metric"
        self.__city = city
        response = requests.get(api)
        json_data = response.json()

        if response.status_code == 200: # checking the status code of the request
            self.__condition = json_data['weather'][0]['main']   # getting data in the json format
            self.__temp = int(json_data['main']['temp'])         # getting temperature
            self.__min_temp = int(json_data['main']['temp_min']) # getting the Min Temperatur
            self.__max_temp = int(json_data['main']['temp_max']) # getting the Max Temperatur
            self.__pressure = json_data['main']['pressure']      # getting the pressure
            self.__humidity = json_data['main']['humidity']      # getting the humidity
            self.__wind = json_data['wind']['speed']             # getting the wind speed
            self.__sunrise = time.strftime("%I:%M:%S", time.gmtime(json_data['sys']['sunrise'] - 21600)) # getting the Sunrise Time
            self.__sunset = time.strftime("%I:%M:%S", time.gmtime(json_data['sys']['sunset'] - 21600))   # getting the Sunset Time
        else:
            print(f"Error loading Data for City: {self.__city}") #Error Code 404 City Not Found
            exit(1)

#toString() is a method used to create String representation of an object.
#Since every class in Java is a sub-class of Object and Object has toString() method, every class has a default toString() method
#Die toString() Methode analysiert das erste Argument und versucht eine string-Repräsentation im durch radix beschriebenen Zahlensystem zurück zu geben.


    def toString(self):
        str = f"City: {self.__city}\n"
        str += f"App_id: {self.__app_id}\n"
        str += f"Condition: {self.__condition}\n"
        str += f"Temp: {self.__temp} °C\n"
        str += f"Min Temp: {self.__min_temp} °C\n"
        str += f"Max Temp: {self.__max_temp}°C\n"
        str += f"Preasure: {self.__pressure}\n"
        str += f"Humidity: {self.__humidity}\n"
        str += f"Wind: {self.__wind}\n"
        str += f"Sunrise: {self.__sunrise}\n"
        str += f"Sunset: {self.__sunset}\n"
        return str




ws1 = Weatherstation(app_id="7e258ff877c553ed528e46655eb0d0b2")
ws1.getWeather("new york")

ws2 = Weatherstation(app_id="7e258ff877c553ed528e46655eb0d0b2")
ws2.getWeather("Zurich")

ws3 = Weatherstation(app_id="7e258ff877c553ed528e46655eb0d0b2")
ws3.getWeather("Luzern")



print(ws1==ws3)     # Test __eq__ method
print(ws1==ws2)     # Test __eq__ method
print(ws1)          # Test __str___
print(ws1==ws1)     # Test __eq__ method



#canvas = tk.Tk()
#canvas.geometry("600x500")
#canvas.title("Weather App")

#f = ("poppins", 15, "bold")
#t = ("poppins", 35, "bold")

#textfield = tk.Entry(canvas, font = t)
#textfield.pack(pady = 20)
#textfield.focus()
#textfield.bind('<Return>', getWeather)


#label1 = tk.Label(canvas, font = t)
#label1.pack()
#label2 = tk.Label(canvas, font = f)
#label2.pack()



