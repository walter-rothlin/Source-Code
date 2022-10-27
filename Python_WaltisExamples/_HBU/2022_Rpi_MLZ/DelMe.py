# ------------------------------------------------------------------
# Name  : WeatherLogger_00.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_00.py
#
# Description: Polling REST Service and write values to console
# https://openweathermap.org/current
#
# Autor: Wilmar Rodriguez
# Modullernzielkontrolle (MLZ)
# History:
# 24-Okt-2022   Wilmar Rodriguez		Initial Version
# 27-Okt-2022	Walter Rothlin			Korrektur
# ------------------------------------------------------------------

import json
import requests
import logging
import csv
import io
import datetime



class CsvFormatter(logging.Formatter):
    
    """
        Class       Openwether        HBU_2022
        
    """


    def __init__(self, country=0, keys=0):
        self.__country = country
        self.__keys = keys

    # get country
    def get_country(self):
        return self.__country

    # set keys
    def set_keys(self, keys):
        self.__keys = keys
        
     # get country
    def get_country(self):
        return self.__keys

    # set country
    def set_country(self, keys):
        self.__country = country
        
    # toString()
    def __str__(self):
        return "(" + str(self.__country) + "/" + str(self.__keys) + ")"
        
    
     
    # overload != (not equal to) operator
    def __ne__(self, CsvFormatter_ov):
        return math.sqrt(self.__country ** 2 + self.__keys ** 2) != math.sqrt(point_ov.__xCoord ** 2 + point_ov.__yCoord ** 2)

 
if __name__ == '__main__':
    ##print("Hallo World Class")
    ## help(CsvFormatter.)
    print(CsvFormatter.__doc__)  ## Classen atribute

logging.basicConfig(level=logging.DEBUG)

logger = logging.getLogger(__name__)
logging.root.handlers[0].setFormatter(CsvFormatter())   
    
# create logger
logger = logging.getLogger('simple_example')
logger.setLevel(logging.DEBUG)

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

# create formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# add formatter to ch
ch.setFormatter(formatter)

# add ch to logger
logger.addHandler(ch)

# 'application' code
logger.debug('debug message')
logger.info('info message')
logger.warning('warn message')
logger.error('error message')
logger.critical('critical message')

url_str = "https://api.openweathermap.org/data/2.5/weather?q=Wangen+SZ&units=metric&lang=de&appid=144747fd356c86e7926ca91ce78ce170"

responseStr = requests.get(url_str)
print(responseStr.text)

print("\n\nParses the response String and converts it to a JSON structutre (Dict-List-Dict...)")
responseStr = responseStr.text
jsonResponse = json.loads(responseStr)

print("Show single fields!")
print("   Ortsname:", jsonResponse['name'])
print("   Land:", jsonResponse['sys']['country'])
print("   Temp:", jsonResponse['main']['temp'])

import requests
from tkinter import *
import math



city_name = "Seattle,US"
api_key = "39c7ccac85aa28f9de1c0cf45e0c0b9b"


def get_weather(api_key, city):
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"

    response = requests.get(url).json()

    temp = response['main']['temp']
    temp = math.floor((temp * 1.8) - 459.67)  # Convert to °F

    feels_like = response['main']['feels_like']
    feels_like = math.floor((feels_like * 1.8) - 459.67)  # Convert to °F

    humidity = response['main']['humidity']
    
    return {
        'temp': temp,
        'feels_like': feels_like,
        'humidity': humidity
    }

weather = get_weather(api_key, city_name)

root = Tk()
root.geometry("300x300")
root.title(f'{city_name[:-3]} Weather')

def display_city_name(city):
    city_label = Label(root, text=f"{city_name[:-3]}")
    city_label.config(font=("Consolas", 28))
    city_label.pack(side='top')

def display_stats(weather):
    temp = Label(root, text=f"Temperature: {weather['temp']} F")
    feels_like = Label(root, text=f"Feels Like: {weather['feels_like']} F")
    humidity = Label(root, text=f"Humidity: {weather['humidity']} %")

    temp.config(font=("Consolas", 22))
    feels_like.config(font=("Consolas", 16))
    humidity.config(font=("Consolas", 16))

    temp.pack(side='top')
    feels_like.pack(side='top')
    humidity.pack(side='top')


display_city_name(city_name)
display_stats(weather)

mainloop()