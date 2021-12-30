#####################################
# Name: Nico_Andersen_A19_DS.py
#
# Description: Wetterstation Class, which will give detailed weather information for weather in general, sky and temperature
#
# Autor: Nico Andersen
#
# Libraries: Please import: pandas, requests, datetime, json, tkinter
#
# History:
# 17-Nov-2021   Nico Andersen    Start with Code
# 18-Nov-2021   Nico Andersen    Create simple get weather function with specific information
# 19-Nov-2021   Nico Andersen    Remove Code duplicates & create flexible measurement function
# 20-Nov-2021   Nico Andersen    Add Docstring information & continue improving functions
# 21-Nov-2021   Nico Andersen    Add GUI Option to save result, improve weather, sky & temp function, finalize __init__
# 22-Nov-2021   Nico Andersen    Implement Test cases, finalize code and format it | finish
#####################################
# Review-Results:
# Reference-Applikation:
#      + Funktioniert
#      + Resultat kann über GUI (Sava as) gespeichert werden
#      - selber ein Save as... ohne Browse funktion entwickelt
#
# Class Design und Implementation:
#      + Notwendige (__init__, __str__, __eq__) Methoden vorhanden
#      + __init__ klare Signatur mit funktionierenden Default values
#      - __init__ macht keinen Request und somit kann die Gültigkeit des Ortes nicht bei der Instanzierung ueberprüft werden
#      - Alle Methoden sind public (get_API_URL_key_with_Specific_measure, getJsonResponse)
#      - getJsonResponse führt zum Absturz bei falscher Orts eingabe
#      + Weather Info wird in einfaches JSON umgepackt
#      - getJsonResponse sollte private sein und von getWeather() aufgerufen werden
#      + getWeather() als allgemeine Methode (single entry)
#
# Test:
#      + Test sind implementiert
#
# Note: 5.5
#
# Fragen:
#    Was wäre das nächste Refactoring der Klasse?
#    Wo wird der Request zum Web-Service abgesendet?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wie könnte der Design der Klasse in dieser Hinsicht verbessert werden?






# ------------------------------------------------------------------
import pandas as pd
import requests
import datetime
import json
import tkinter as tk
from tkinter import *


class Wetterstation:
    def __init__(
        self,
        appId="fe1104d427d193a68ea0fdf1bae3c0ff",
        serviceURL="api.openweathermap.org/data/2.5/weather?",
        city="Bülach",
        measure="celsius",
    ):
        self.appId = appId
        self.serviceURL = serviceURL
        self.city = city
        self.measure = measure
        self.json_response = str()
        self.timestamp = str()
        self.sky = str()
        self.description = str()
        self.temp = str()
        self.feels_like = str()
        self.temp_min = str()
        self.temp_max = str()
        self.pressure = str()
        self.humidity = str()
        self.request_url_api_key = str()

    def __str__(self):
        """
        Called by the str() built-in function and by the
        See: https://docs.python.org/2/reference/datamodel.html#basic-customization for specific documentation.
        :return:
        returns strings for specific self variables
        """
        return_str = "appId: " + str(self.appId) + "\n"
        return_str += "serviceURL: " + str(self.serviceURL) + "\n"
        return_str += "city: " + str(self.city) + "\n"
        return_str += "measure: " + str(self.measure) + "\n"
        return_str += "json_response: " + str(self.json_response) + "\n"
        return_str += "timestamp: " + str(self.timestamp) + "\n"
        return_str += "sky: " + str(self.timestamp) + "\n"
        return_str += "description: " + str(self.description) + "\n"
        return_str += "temp: " + str(self.temp) + "\n"
        return_str += "feels_like: " + str(self.feels_like) + "\n"
        return_str += "temp_min: " + str(self.temp_min) + "\n"
        return_str += "temp_max: " + str(self.temp_max) + "\n"
        return_str += "pressure: " + str(self.pressure) + "\n"
        return_str += "humidity: " + str(self.humidity) + "\n"
        return_str += "request_url_api_key: " + str(self.request_url_api_key) + "\n"
        return return_str

    def __eq__(self, other):
        """
        compare files, important for functional requirement
        """
        return self == other

    def use_GUI(self, output):
        """
        Interactive tkinter GUI to save results for a preferred path + filename
        :param output:
        The output is the result-dict of the specific chosen weather function (weather, temperature, sky Information)
        :return:
        No returns are given since GUI is interactive and will destroy it by himself
        """

        # create root frame to place button and textfield on it
        root = tk.Tk()
        root.geometry("440x100")
        root.title("GUI to save file")

        label_text = Label(
            root, text="Plese enter a filepath. Example C:/users/filename.txt"
        )
        label_text.grid(column=0, row=0)

        def getTextInput():
            """
            Textfield to enter specific path + filename to save
            """
            result = textfield.get("1.0", tk.END + "-1c")
            print(result)
            with open(result, "w") as f:
                f.write(output)

        def Close():
            """
            Close button, which will destroy the root object (TKinter Frame)
            """
            root.destroy()

        textfield = tk.Text(root, height=10)
        textfield.place(x=3, y=25, height=25, width=400)

        # save Button
        save_button = tk.Button(
            root, height=1, width=10, text="Save", command=getTextInput
        )
        save_button.place(x=3, y=60, height=25, width=50)

        # close Button
        close_button = tk.Button(root, height=1, width=10, text="Close", command=Close)
        close_button.place(x=360, y=60, height=25, width=50)

        root.mainloop()

    def getTimestamp(self):
        """
        This function provides the current date as of *now*. Format: d-m-Y H:M:S
        """
        self.timestamp = datetime.datetime.now().strftime("%d-%m-%Y %H:%M:%S")

    def getJsonResponse(self):
        """
        This functions gets the json request with a variable request URL.
        The script aborts if city input = error code 404
        """
        response = requests.get(self.get_API_URL_Key_with_specific_measure())
        json_response = response.json()
        if json_response["cod"] == "404":
            print("\nYour City input has not been found")
            print("Script aborted!")
            exit()
        self.json_response = json_response
        self.timestamp = datetime.datetime.now().strftime("%d-%m-%Y %H:%M:%S")

    def getWeather(self):
        """
        This functions returns the weather for a specific city.
        Weather information can be found below in print list
        :return:
        No return values are given since we directly print it to the console. Dict will be saved to later process it
        with the GUI if wished
        """

        # fetching data from JSON response and creating dictionary with relevant weather data
        self.weather = {}
        self.weather["Data as of"] = self.timestamp
        self.weather["Sky"] = self.json_response["weather"][0]["main"]
        self.weather["Description"] = self.json_response["weather"][0]["description"]
        self.weather["Temp"] = self.json_response["main"]["temp"]
        self.weather["Feels_Like"] = self.json_response["main"]["feels_like"]
        self.weather["Temp_Min"] = self.json_response["main"]["temp_min"]
        self.weather["Temp_Max"] = self.json_response["main"]["temp_max"]
        self.weather["Pressure"] = self.json_response["main"]["pressure"]
        self.weather["Humidity"] = self.json_response["main"]["humidity"]

        # Format dict result output and print
        weather_output = json.dumps(self.weather, indent=4)
        print(weather_output)

        # GUI to save file for certain path
        gui = input(
            "\nDo you want to call a gui to save output with your prefered save path? [1] yes, [2] No (default):"
        )
        if gui == "1":
            print("'1'; Please add a path + filename.txt to save output")
            Wetterstation().use_GUI(weather_output)
        elif gui == "2":
            pass
        elif gui == "":
            pass

    def get_API_URL_Key_with_specific_measure(self):
        """
        We either choose between Fahrenheit and Celsius.
        This function is variable for the request URL since user needs to specify measurement and city
        :return:
        returns the request URL which will be later used for fetching weather data
        """
        if measure == "1":
            # imperial request URL
            request_url_api_key = (
                self.serviceURL
                + "appid="
                + self.appId
                + "&q="
                + self.city
                + "&units=Imperial"
            )
        elif measure == "2":
            # metric request URL
            request_url_api_key = (
                self.serviceURL
                + "appid="
                + self.appId
                + "&q="
                + self.city
                + "&units=metric"
            )
        else:
            # metric request URL (is default)
            request_url_api_key = (
                self.serviceURL
                + "appid="
                + self.appId
                + "&q="
                + self.city
                + "&units=metric"
            )

        self.request_url_api_key = request_url_api_key
        return self.request_url_api_key

    def getTemperature(self):
        """
        This functions returns the temperature information for a specific city.
        Temperature information can be found below in print list
        :return:
        No return values are given since we directly print it to the console. Dict will be saved to later process it
        with the GUI if wished
        """

        # fetching data from JSON response and creating dictionary with relevant temp data
        self.temp = {}
        self.temp["Data as of"] = self.timestamp
        self.temp["Temp"] = self.json_response["main"]["temp"]
        self.temp["Temp_Min"] = self.json_response["main"]["temp_min"]
        self.temp["Temp_Max"] = self.json_response["main"]["temp_max"]
        self.temp["Humidity"] = self.json_response["main"]["humidity"]

        # Format dict result output and print
        temp_output = json.dumps(self.temp, indent=4)
        print(temp_output)

        # GUI to save file for certain path
        gui = input(
            "\nDo you want to call a gui to save output with your prefered save path? [1] yes, [2] No (default):"
        )
        if gui == "1":
            print("'1'; Please add a path + filename.txt to save output")
            Wetterstation().use_GUI(temp_output)
        elif gui == "2":
            pass
        elif gui == "":
            pass

    def getSkyInformation(self):
        """
        This functions returns the Sky information for a specific city.
        Sky information can be found below in print list
        :return:
        No return values are given since we directly print it to the console. Dict will be saved to later process it
        with the GUI if wished
        """

        # fetching data from JSON response and creating dictionary with relevant sky data
        self.sky = {}
        self.sky["Data as of"] = self.timestamp
        self.sky["Sky"] = self.json_response["weather"][0]["main"]
        self.sky["Description"] = self.json_response["weather"][0]["description"]
        self.sky["Sunrise"] = self.json_response["sys"]["sunrise"]
        self.sky["Sunset"] = self.json_response["sys"]["sunset"]

        # Format dict result output and print
        sky_output = json.dumps(self.sky, indent=4)
        print(sky_output)

        # GUI to save file for certain path
        gui = input(
            "\nDo you want to call a gui to save output with your prefered save path? [1] yes, [2] No (default):"
        )
        if gui == "1":
            print("'1'; Please add a path + filename.txt to save output")
            Wetterstation().use_GUI(sky_output)
        elif gui == "2":
            pass
        elif gui == "":
            pass


if __name__ == "__main__":
    # Main Values (fixed input)
    api_key = "c44ff34bf758cc0ece9594b1006ec83b"
    request_url = "http://api.openweathermap.org/data/2.5/weather?"

    # welcome message
    print("--------------------------------------------")
    print("|  Wetterstation - made by Nico Andersen   |")
    print("--------------------------------------------")

    # define city
    city = input("\nEnter city name: ")
    if city == "":
        city = "Bülach"
        print("No input given, using default city 'Bülach'!")
    else:
        print(
            "Your choosen city is currently beeing checked, please add measurement information to proceeed with request '"
            + city
            + "'"
        )

    # get measurement input, either Celsius or Fahrenheit. This input is relevant for the function get_API_URL_Key_with_specific_measure()
    measure = input("Choose Measure: Fahrenheit [1], Celsius (default) [2]:")
    if measure == "":
        measure = "celsius"
        print("No input given, using default measure 'celsius'!")
    elif measure == "2":
        print("You are currently using the Celsius measurement")
    elif measure == "1":
        print("You are currently using the Fahrenheit measurement")

    meine_wetterstation = Wetterstation(
        appId=api_key, serviceURL=request_url, city=city, measure=measure
    )
    meine_wetterstation.getJsonResponse()

    # ask for desired mode
    mode = input(
        "\nChoose report: Weather [1] (Default),  Temperature [2], Sky Information [3] ? "
    )
    if mode == "1":
        print("Choosing data type '1'")
        meine_wetterstation.getWeather()
    elif mode == "2":
        print("Choosing data type '2'")
        meine_wetterstation.getTemperature()
    elif mode == "3":
        print("Choosing data type '3'")
        meine_wetterstation.getSkyInformation()
    else:
        mode = "1"
        print(
            "Choosing default data type '1', because your input was not correct or empty..."
        )
        meine_wetterstation.getWeather()

    # print end of script message
    print(
        "\nThank you for using my Wetterstation class. I hope you received the needed Information for your favourite place :)"
    )


####################################Test cases & statistics#####################################
# print("\n#################################################")
# print("\nAutomated Test cases for Wetterstation Class\n")
#
# testsPerformed = 0
# testsFailed = 0
#
# # Testcase 1 - Voraussetzung, measure muss beim Durchlauf auf 1 gesetzt werden
# # Die Variable measure soll beim Input von 1 genau diesen Request URL ausgeben. Somit checken wir,
# # ob die korrekten Daten gesourced wurden
# testsPerformed += 1
# expected_result = ("http://api.openweathermap.org/data/2.5/weather?" +
#                                          "appid=" + "c44ff34bf758cc0ece9594b1006ec83b" + "&q="
#                                          + city + "&units=Imperial")
# if measure == "1":
#     param_1 = ("http://api.openweathermap.org/data/2.5/weather?" +
#                                          "appid=" + "c44ff34bf758cc0ece9594b1006ec83b" + "&q="
#                                          + city + "&units=Imperial")
#     if str(param_1) != expected_result:
#         testsFailed += 1
#         print("Error: Testcase ", testsPerformed)
#         print("->Measure(", param_1, ") = ", str(param_1), "    Expected:", expected_result, sep="")
# else:
#     pass
#
#
# # Testcase 2 -> Voraussetzung city muss beim Durchlauf leer gelassen werden
# # Wenn wir die City Variable auf empty str setzen, sollte es immer Bülach als default ausgeben
# testsPerformed += 1
# expected_result = "Bülach"
# param_1 = meine_wetterstation.city
#
# if param_1 != expected_result:
#     testsFailed += 1
#     print("Error: Testcase ", testsPerformed)
#     print("->Standard City(", param_1, ") = ", param_1, "    Expected:", expected_result, sep="")
#
#
# # Testcase 3 - Check ob wir den richtigen service URL sourcen
# testsPerformed += 1
# expected_result = meine_wetterstation.serviceURL
# param_1 = 'http://api.openweathermap.org/data/2.5/weather?'
#
# if str(param_1) != expected_result:
#     testsFailed += 1
#     print("Error: Testcase ", testsPerformed)
#     print("->Service URL(", param_1, ") = ", str(param_1), "    Expected:", expected_result, sep="")
#
# # Testcase 4 - Check ob wir den richtigen API Key nehmen
# testsPerformed += 1
# expected_result = meine_wetterstation.appId
# param_1 = 'c44ff34bf758cc0ece9594b1006ec83b'
#
# if str(param_1) != expected_result:
#     testsFailed += 1
#     print("Error: Testcase ", testsPerformed)
#     print("-> appId(", param_1, ") = ", str(param_1), "    Expected:", expected_result, sep="")
#
#
# print("Test-Statistics Wetterstation: Tests Performed:", testsPerformed, "   Tests Failed:", testsFailed,
#       "    Passed:", round(100 - (100 * testsFailed / testsPerformed), 1), "%", sep="")
#
# print("\nYou have reached the end of testing")
# print("#################################################")
