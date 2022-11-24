# ------------------------------------------------------------------
# Name  : Lilian_Bühler_BWI_A21.py
# https://openweathermap.org/current
# teile des Codes in der Main Methode sind von Walther Rothlin siehe Source
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_01.py
# ------------------------------------------------------------------
import datetime
import requests
import json
import time
import csv

''' Create reusable logger class and set default values for logging.'''


class Log:

    def __init__(self, timestamp=True,  filepath='G:\\', filename="Lilian_Buehler_BWI_A21.csv", loglevel='Info', lines=15, mode='a', delimiter='|'):
        self.__timestamp = timestamp
        self.__filepath = filepath
        self.__filename = filename
        self.__loglevel = loglevel
        self.__lines = lines
        self.__mode = mode
        self.__delimiter = delimiter

    # timestamp as a part of the class
    @classmethod
    def get_timestamp(self):
        return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())

    # implementation of setter and getter methods
    def set_filepath(self, filepath):
        self.__filepath = filepath

    def get_filepath(self):
        return self.__filepath

    def set_filename(self, filename):
        self.__filename = filename

    def get_filename(self):
        return self.__filename

    def set_delimiter(self, delimiter):
        self.__delimiter = delimiter

    def get_delimiter(self):
        return self.__delimiter

    def set_loglevel(self, loglevel):
        self.__loglevel = loglevel

    def get_loglevel(self):
        return self.__loglevel

    def set_mode(self, mode):
        self.__mode = mode

    def get_mode(self):
        return self.__mode

    # method writes csv file
    def write_file(self, logarray):
        with open(self.__filename, self.__mode, newline='') as file:
            file = csv.writer(file, delimiter=self.get_delimiter())
            file.writerow(logarray)


''' Mainmethod for API request, CLI input and start logging to file via logger class '''

if __name__ == '__main__':

    print("Please enter the required values, for default value (*) press enter:")

    # set values
    serviceURL = "https://api.openweathermap.org/data/2.5/weather"
    pollingTime = float(input("polling-interval in seconds:"))

    place = input("place  [* Uster]   :")
    if place == "":
        place = 'Uster'

    max_counter = int(input("number of requests :"))
    appId = "9ce6bc868b1babd35a4ed4eb32a4d548"

    # define access variable for Log Class
    logger = Log()

    # set filepath
    filepathinput = input("set filepath [* G:\\]   :")
    if filepathinput == "":
        logger.get_filepath()
    else:
        logger.set_filepath(filepathinput)

    # set filename
    filenameinput = input("set filename (.csv) [* Lilian_Buehler_BWI_A21.csv]   :")
    if filenameinput == "":
        logger.get_filename()
    else:
        logger.set_filename(filenameinput)


    # set and change delimiter
    delimiterinput = input("enter delimiter [*|]   :")
    if delimiterinput == "":
        logger.get_delimiter()
    else:
        logger.set_delimiter(delimiterinput)

    # set and change loglevel
    loglevelinput = input("choose loglevel [* Info]   :")
    if loglevelinput == "":
        logger.get_loglevel()
    else:
        logger.set_loglevel(loglevelinput)

    # write header and fieldnames to file
    header =['# <Name>' + logger.get_filepath() + logger.get_filename() + '</Name> <Date>' + str(logger.get_timestamp()) + '</Date>']
    fieldnames = ['timestamp', 'loglevel', 'place', 'country','lon', 'lat', 'temp', 'pressure', 'humidity', 'cloud', 'windSpeed', 'windDirection']

    logger.write_file(header)
    logger.write_file(fieldnames)

    # set request url, start requests and match output to values
    firstTime = True
    counter = 0
    doLoop = True

    while doLoop:
        counter += 1
        requestStr = (f'{serviceURL}?q={place}&units=metric&lang=de&appid={appId}')
        print("Request:\n", requestStr, "\n") if firstTime else False
        responseStr = requests.get(requestStr)
        print("Response:\n", responseStr.text, "\n") if firstTime else False

        jsonResponse = json.loads(responseStr.text)

        place = jsonResponse['name']
        country = jsonResponse['sys']['country']
        temp = jsonResponse['main']['temp']
        pressure = jsonResponse['main']['pressure']
        humidity = jsonResponse['main']['humidity']
        lon = jsonResponse['coord']['lon']
        lat = jsonResponse['coord']['lat']
        cloud = jsonResponse['weather'][0]['description']
        windSpeed = jsonResponse['wind']['speed']
        windDirection = jsonResponse['wind']['deg']

        print(logger.get_timestamp(), ": ", place, "[", country, "]", "(", lon, "/", lat, ")      ", temp, "°C ", pressure, "mBar ", humidity, "% ", cloud, "  Wind:", windSpeed, "m/s ", windDirection, "° ", sep='')

        # create logarray and write to file
        logarray = [str(logger.get_timestamp()), logger.get_loglevel(), place, country, str(lon), str(lat), str(temp), str(pressure), str(humidity), cloud, str(windSpeed), str(windDirection)]

        logger.write_file(logarray)

        # loop only input times of requests
        time.sleep(pollingTime)
        firstTime = False
        if counter >= max_counter:
            doLoop = False
