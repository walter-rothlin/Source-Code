# ------------------------------------------------------------------
# Name: Vanja_Nicolay_A19_DS.py
#
# Description: Weather station that receives data from a REST-Service (JSON)
#
# Author: Vanja Nicolay
#
# History:
# 17-Nov-2021   Vanja Nicolay      Initial V
# 21-Nov-2021   Vanja Nicolay      added function checkFields
# 22-Nov-2021   Vanja Nicolay      improved Code

import requests
import datetime
from colorama import Fore, Style


class WeatherStation:
    # Ctr (Constructor)
    # -----------------
    def __init__(self, appId="24ea18da50a815cb3d57045c7c9d093d",
                 baseUrl="http://api.openweathermap.org/data/2.5/weather?units=metric", location=None,
                 weatherFields=None):
        self.__appId = "appid=" + appId
        self.__baseUrl = baseUrl
        self.__location = "q=" + location
        self.__weatherFields = weatherFields

    # toString()
    # ----------
    def __str__(self):
        retStr = "appId             :" + str(self.__appId) + "\n"
        retStr += "baseUrl           :" + str(self.__baseUrl) + "\n"
        retStr += "location          :" + str(self.__location) + "\n"
        retStr += "weatherFields     :" + str(self.__weatherFields) + "\n"
        return retStr

    # overload == (equal to) operator
    # -------------------------------
    def __eq__(self, anOtherWeatherStation):
        if isinstance(anOtherWeatherStation, WeatherStation):
            return self.__weatherFields == anOtherWeatherStation.__weatherFields

    def getTimeStamp(self):
        """returns timestamp in pre-defined layout"""
        return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    def requestJson(self):
        """fetches data from given url"""
        restUrl = self.__baseUrl + "&" + self.__location + "&" + self.__appId
        response = requests.get(restUrl)
        return response

    def getJsonData(self):
        """aggregation of the fetched data into structured output"""
        #        jsonResponse = json.loads(response.text)
        if not self.__weatherFields:
            self.__weatherFields = self.checkFields()
        data = response.json()
        weatherData = "| "
        for aKey in self.__weatherFields:
            aValue = data['main'][aKey]
            weatherData += aKey + ": " + str(aValue) + " | "
        return weatherData

    def checkFields(self):
        """function to choose from given weather fields for personalized report"""
        dictFields = {1: 'temp', 2: 'pressure', 3: 'humidity', 4: 'temp_min', 5: 'temp_max', 6: 'feels_like'}
        fieldNumber = 0
        weatherFields = []
        while fieldNumber != "":
            for key, value in dictFields.items():
                print(key, value)
            fieldNumber = input("[Press ENTER] done adding fields\nSelect your weather details by choosing a Number: ")
            if fieldNumber == "":
                if not weatherFields:
                    fieldNumber = False
                    print(Fore.RED + "No weather Details were chosen\nPlease choose at least one Number")
                    print(Style.RESET_ALL)
                else:
                    break
            else:
                try:
                    fieldNumber = int(fieldNumber)
                except ValueError:
                    print(Fore.RED + "No number was given")
                    print(Style.RESET_ALL)
                    fieldNumber = False
            if fieldNumber not in dictFields:
                # if fieldNumber < 1 or fieldNumber > 5:
                print(Fore.RED + "Number not listed - proceed with program")
                fieldNumber = False
                print(Style.RESET_ALL)
            if fieldNumber is not False:
                field = dictFields[fieldNumber]
                if field not in weatherFields:
                    weatherFields.append(field)
                    print("Your current selection: ", weatherFields)
                else:
                    print(Fore.RED + "Chosen number is already in selection: ", weatherFields)
                    print(Style.RESET_ALL)
            else:
                print("Number not available")
        return weatherFields


if __name__ == '__main__':

    print(
        Fore.LIGHTBLUE_EX + "---------------------------------\n| Welcome to the WeatherStation "
                            "|\n---------------------------------")
    print(Style.RESET_ALL)
    location = str(input("Please chose a location [Zürich]:"))
    if not location:
        location = "Zürich"
    mode = 0
    while mode < 1 or mode > 2:
        try:
            mode = int(input("[1] Pre defined weather details \n[2] Choose your own weather details \nSelect a mode: "))
            if mode < 1 or mode > 2:
                print(Fore.RED + "No such mode")
                print(Style.RESET_ALL)
        except ValueError:
            print(Fore.RED + "No such mode")
            print(Style.RESET_ALL)
        if not mode:
            print(Fore.LIGHTGREEN_EX + "Mode will be set to [1]")
            mode = int(1)
            print(Style.RESET_ALL)
    if mode == 1:
        weatherFields = ["temp", "pressure", "humidity", "temp_min", "temp_max", "feels_like"]
    elif mode == 2:
        weatherFields = []

    WS = WeatherStation(location=location, weatherFields=weatherFields)
    response = WS.requestJson()
    data = WS.getJsonData()
    print(Fore.GREEN + "Your weather report:\n| {0} |\n{1}".format(location, data))
    execTime = WS.getTimeStamp()
    print(Fore.BLUE + "\nFinished run: ", execTime)

    # Test Section
    # turn testswitch TestAutomat to True for automated testing.
    #TestAutomat = True
    TestAutomat = False
    if TestAutomat is False:
        pass
    elif TestAutomat is True:
        print(Fore.GREEN + "Automated testing started!")

        print(Fore.LIGHTGREEN_EX + "Initialized instance:")
        print(WS)

        countTotal = 0
        countPositive = 0
        countNegative = 0

        try:
            response = WS.requestJson()
            responseCode = response.status_code
        except AttributeError:
            print("given attr wrong")

        print(Style.RESET_ALL)
        print("Verify JSON Response:")
        print("=====================")
        countTotal += 1
        if responseCode != 200:
            print(Fore.RED + "ERROR - JSON Response is not 200")
            print("Response: ", responseCode)
            countNegative += 1
        else:
            print(Fore.GREEN + "OK - ", responseCode)
            countPositive += 1
            print(Style.RESET_ALL)

        if countPositive < countTotal:
            print(Fore.RED + "Testresults:\nTotal tests: {0} out of {1} failed".format(countTotal, countNegative))
        elif countPositive == countTotal:
            print(
                Fore.GREEN + "Testresults:\nTotal tests: {0} out of {1} succeeded".format(countTotal, countPositive))
        print(Style.RESET_ALL)

        try:
            data = WS.getJsonData()
        except ValueError:
            print("something went wrong")

"""
    #Aufgrund von checkFields() wird dieser Test nicht mehr ausgeführt.
        print("Verify Data:")
        print("=====================")
        countTotal += 1
        if not data:
            print(Fore.RED + "ERROR - No data was found. Empty.")
            print(Style.RESET_ALL)
            countNegative += 1
        else:
            print(Fore.GREEN + "OK - ", data)
            print(Style.RESET_ALL)
            countPositive += 1

        if countPositive < countTotal:
            print(Fore.RED + "Testresults:\nTotal tests: {0} out of {1} failed".format(countTotal, countNegative))
        elif countPositive == countTotal:
            print(
                Fore.GREEN + "Testresults:\nTotal tests: {0} out of {1} succeeded".format(countTotal, countPositive))
"""