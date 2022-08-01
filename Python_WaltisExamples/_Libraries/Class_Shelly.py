#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Shelly.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Class_Shelly.py
#
# Description: Tobias Class to wrap different Shelly Types
#
# Autor: Walter Rothlin
#
# History:
# 01_Jun-2022   Tobias Rothlin      Initial Version
# 01-Aug-2022   Walter Rothlin      Extended methodes and Shelly_Collection class
# ------------------------------------------------------------------

# Important Links about Shellys
# -----------------------------
'''
https://www.shelly.cloud                      Product infos
https://www.shelly-support.eu                 Support Pages
https://home.shelly.clound                    Web-App gleich wie iPhone App
https://shelly-api-docs.shelly.cloud/         API Documentation
https://shelly-api-docs.shelly.cloud/gen2/ComponentsAndServices/Switch    API Shelly
'''

# Shelly Requests:
# ----------------
'''
# Testlampe Shelly 1 Blue
http://192.168.1.131    in Chrom starten und mit F12 trace des traffics
http://192.168.1.131/status
http://192.168.1.131/settings
http://192.168.1.131/relay/0?turn=on
http://192.168.1.131/relay/0?turn=off
http://192.168.1.131/relay/0?turn=off&timer=3
http://192.168.1.131/settings/relay/0?schedule_rules=1430-0123456-on
http://192.168.1.131/settings/relay/0?schedule_rules=1430-0123456-on%2C1435-0123456-off

# Shelly 1 Rot
http://192.168.1.134
http://192.168.1.134/status
http://192.168.1.134/settings
http://192.168.1.134/relay/0?turn=on
http://192.168.1.134/relay/0?turn=toggle
http://192.168.1.134/relay/0?turn=off

# Shelly 2 Rot
http://192.168.1.135
http://192.168.1.135/status
http://192.168.1.135/settings
http://192.168.1.135/relay/0?turn=on
http://192.168.1.135/relay/0?turn=off

# Shelly 4 Vierfach
http://192.168.1.133
http://192.168.1.133/relay/0?turn=on
http://192.168.1.133/relay/0?turn=off
http://192.168.1.133/rpc/Switch.GetStatus?id=0
'''

import socket
import json
import requests
from enum import Enum
from time import sleep
from waltisLibrary import *


class ShellyTyps(Enum):
    Shelly_1_Blau = 1
    Shelly_1PM_Rot = 2
    ShellyPro_4PM_Tableau = 3


class ShellyAPI:
    doTraceClassVar = True

    def __init__(self, ip, shelly_name=None, shelly_type=ShellyTyps.Shelly_1_Blau):
        """
        Initiates a new Shelly device.

        Parameters
        ----------
         ip : string
            the target device IP Address

         shelly_name: string
         shelly_type: enum

         Examples
         --------
         >>> ShellyAPI("192.168.1.131")
         """
        self.__ip = ip
        self.__shelly_name = shelly_name
        self.__shelly_type = shelly_type
        self.__booked_for = [None]
        self.turnOff()
        if self.__shelly_type in [ShellyTyps.ShellyPro_4PM_Tableau]:
            for i in [1, 2, 3]:
                self.turnOff(switchNo=i)

            for i in [1, 2, 3]:
                self.__booked_for.append(None)


    def __str__(self):
        retStr  = str(self.__ip + ':' + str(0) + ' {sName:25s} {sType:35s} ' + str(self.__booked_for[0])).format(sName=self.__shelly_name, sType=self.__shelly_type)
        if self.__shelly_type in [ShellyTyps.ShellyPro_4PM_Tableau]:
            for i in [1, 2, 3]:
                retStr += '\n' + str(self.__ip + ':' + str(i) + ' {sName:25s} {sType:35s} ' + '  ' + str(self.__booked_for[i])).format(sName=self.__shelly_name, sType=self.__shelly_type)
        return retStr

    def get_ip(self):
        return self.__ip

    def get_shelly_name(self):
        return self.__shelly_name

    def get_shelly_type(self):
        return self.__shelly_type

    def get_booked_for(self, switchNo=0):
        return self.__booked_for[switchNo]

    def set_booked_for(self, switchNo=0, booker=None):
        if self.get_booked_for(switchNo) is not None and booker is not None:
            self.__booked_for[switchNo] = booker

    def cancel_booked_for(self, switchNo=0):
        self.__booked_for[switchNo] = None


    def turnOn(self, switchNo=0, timer=None, doTrace=doTraceClassVar):
        """
        Turns the shelly ON if the relay is already ON, nothing happens. It returns the response containing the current state of the relay.

        Parameters
        ----------
        switchNo : int
            Allows for multi-switch (i.e. ShellyPro_4PM_Tableau) to select switch number
        timer : int
            Allows to set a timer in seconds. The device will revert to the previous state when the timer runs out.

         Examples
         --------
         >>> shellyOne.turnOn()
         """

        requestStr = 'http://' + self.__ip + "/relay/" + str(switchNo) + "?turn=on"
        if timer is not None:
            requestStr += '&timer=' + str(timer)

        if doTrace:
            print(requestStr)

        return json.loads(requests.request("GET", requestStr).text)


    def turnOff(self, switchNo=0, timer=None, doTrace=doTraceClassVar):
        """
        Turns the shelly OFF if the relay is already OFF, nothing happens. It returns the response containing the current state of the relay.

        Parameters
        ----------
        switchNo : int
            Allows for multi-switch (i.e. ShellyPro_4PM_Tableau) to select switch number
        timer : int
            Allows to set a timer in seconds. The device will revert to the previous state when the timer runs out.

         Examples
         --------
         >>> shellyOne.turnOff()
         """

        requestStr = 'http://' + self.__ip + "/relay/" + str(switchNo) + "?turn=off"
        if timer is not None:
            requestStr += '&timer=' + str(timer)

        if doTrace:
            print(requestStr)

        return json.loads(requests.request("GET", requestStr).text)


    def toggle(self, switchNo=0, timer=None, doTrace=doTraceClassVar):
        """
        Toggels the shelly. It returns the response containing the current state of the relay.

        Parameters
        ----------
        switchNo : int
            Allows for multi-switch (i.e. ShellyPro_4PM_Tableau) to select switch number
        timer : int
            Allows to set a timer in seconds. The device will revert to the previous state when the timer runs out.

         Examples
         --------
         >>> shellyOne.toggle()
         """

        requestStr = 'http://' + self.__ip + "/relay/" + str(switchNo) +"?turn=toggle"
        if timer is not None:
            requestStr += '&timer=' + str(timer)

        if doTrace:
            print(requestStr)

        return json.loads(requests.request("GET", requestStr).text)


    def getDeviceSettings(self, doTrace=doTraceClassVar):
        """
        Loads all the device settings.

        Parameters
        ----------
         None

         Examples
         --------
         >>> shellyOne.getDeviceSettings()
         """

        requestStr = 'http://' + self.__ip + '/settings'
        if self.__shelly_type in [ShellyTyps.Shelly_1_Blau, ShellyTyps.Shelly_1PM_Rot]:
            if doTrace:
                print(requestStr)
            return json.loads(requests.request("GET", requestStr).text)
        else:
            return "Not settings aviable for " + str(self.__shelly_type)


    def getCurrentPowerUsage(self, switchNo=0, doTrace=doTraceClassVar):
        """
        Returns the current power usage in Watts. This is not supported on every shelly.

        Parameters
        ----------
         switchNo : int
            Allows for multi-switch (i.e. ShellyPro_4PM_Tableau) to select switch number

         Examples
         --------
         >>> shellyOne.getCurrentPowerUsage()
         """
        if self.__shelly_type in [ShellyTyps.Shelly_1_Blau]:
            powerInWatt = 0
            if doTrace:
                print("-->", powerInWatt)

        if self.__shelly_type in [ShellyTyps.Shelly_1PM_Rot]:
            requestStr = 'http://' + self.__ip + '/status'
            if doTrace:
                print(requestStr)

            jsonResponse = json.loads(requests.request("GET", requestStr).text)
            powerInWatt = jsonResponse['meters'][switchNo]['power']
            if doTrace:
                print("-->", powerInWatt)

        if self.__shelly_type in [ShellyTyps.ShellyPro_4PM_Tableau]:
            requestStr = 'http://' + self.__ip + '/rpc/Switch.GetStatus?id=' + str(switchNo)
            if doTrace:
                print(requestStr)
            jsonResponse = json.loads(requests.request("GET", requestStr).text)

            powerInWatt = powerInWatt = jsonResponse['apower']
            if doTrace:
                print("==>", jsonResponse)
                print("-->", powerInWatt)

        return powerInWatt

    def getEnergyMeterValue(self, switchNo=0, doTrace=doTraceClassVar):
        """
        Returns the actual energy meter level in Watthours (Wh). This is not supported on every shelly.

        Parameters
        ----------
         switchNo : int
            Allows for multi-switch (i.e. ShellyPro_4PM_Tableau) to select switch number

         Examples
         --------
         >>> shellyOne.getEnergyMeterValue()
         """
        energyMeterLevel = -1
        if self.__shelly_type in [ShellyTyps.ShellyPro_4PM_Tableau]:
            requestStr = 'http://' + self.__ip + '/rpc/Switch.GetStatus?id=' + str(switchNo)
            if doTrace:
                print(requestStr)
            jsonResponse = json.loads(requests.request("GET", requestStr).text)

            energyMeterLevel = jsonResponse['aenergy']['total']
            if doTrace:
                print("==>", jsonResponse)
                print("-->", energyMeterLevel)

        return energyMeterLevel

    @staticmethod
    def getAllDevicesInNetwork(endIP=255, baseIp = "192.168.1.", trace=False):
        """
        Finds all devices in a network.

        Parameters
        ----------
         end : int
            defines the upper end of the search

        baseIp : string
            defines the base ip

         Examples
         --------
         >>> shellyOne.getAllDevicesInNetwork()
         """
        deviceList = []
        if baseIp == None:
            baseIp = ".".join(socket.gethostbyname(socket.gethostname()).split(".")[:-1]) + "."
        if trace:
            print("lookup for ", baseIp)
        for i in range(1, endIP + 1):
            try:
                if trace:
                    print("trying ", baseIp + str(i))
                device = socket.gethostbyaddr(baseIp + str(i))
                deviceList.append({
                    'ip': device[2][0],
                    'name': device[0]
                })
                if trace:
                    print(deviceList[-1]['ip'], deviceList[-1]['name'])
            except:
                pass
        return deviceList

    @staticmethod
    def findAllShellysInNetwork(endIP=255, trace=False):
        """
         Finds Shellys in a Network

         Parameters
         ----------
          end : int
             defines the upper end of the search

          Examples
          --------
          >>> shellyOne.findAllShellysInNetwork()
          """
        if trace:
            print("Search shellys....")
        return [device for device in ShellyAPI.getAllDevicesInNetwork(endIP) if device['name'].find('shelly') > -1]


def TEST_Shelly_StaticMethods():
    listOfShellysInNetwork = ShellyAPI.findAllShellysInNetwork(trace=True)
    print(listOfShellysInNetwork)
    shellyOne = ShellyAPI(listOfShellysInNetwork[0]['ip'])


def TEST_Class_Shelly():
    shellyList = [
        {'ip': "192.168.1.131",
         'shelly_name': "Mit Schalter",
         'shelly_type': ShellyTyps.Shelly_1_Blau,
         'obj': None
         },
        {'ip': "192.168.1.134",
         'shelly_name': "Rot 1",
         'shelly_type': ShellyTyps.Shelly_1PM_Rot,
         'obj': None
         },
        {'ip': "192.168.1.135",
         'shelly_name': "Rot 2",
         'shelly_type': ShellyTyps.Shelly_1PM_Rot,
         'obj': None
         },
        {'ip': "192.168.1.133",
         'shelly_name': "Mehrfach-Shelly_1",
         'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
         'obj': None
         },
    ]

    print("instantiates shelly objects....")
    for aShellyConfig in shellyList:
        aShellyConfig['obj'] = ShellyAPI(ip=aShellyConfig['ip'],
                                         shelly_name=aShellyConfig['shelly_name'],
                                         shelly_type=aShellyConfig['shelly_type'])
        print(aShellyConfig['obj'].getDeviceSettings())

    print('start manipulating shelly obejects')
    shellyList[2]['obj'].turnOn()
    shellyList[0]['obj'].turnOn(timer=5)
    shellyList[1]['obj'].turnOn(timer=2)

    sleep(5)
    print(shellyList[0]['obj'].getCurrentPowerUsage())
    print(shellyList[1]['obj'].getCurrentPowerUsage())
    print(shellyList[2]['obj'].getCurrentPowerUsage())

    sleep(5)
    shellyList[2]['obj'].turnOff()

    print("Test Mehrfach Shelly")
    shellyList[3]['obj'].turnOn(switchNo=2)
    shellyList[3]['obj'].turnOn(switchNo=3, timer=5)
    sleep(2)
    print("==>", shellyList[3]['obj'].getCurrentPowerUsage(switchNo=2))
    sleep(5)
    shellyList[3]['obj'].turnOff(switchNo=2, timer=1)
    sleep(5)
    print("==>", shellyList[3]['obj'].getCurrentPowerUsage(switchNo=2))
    sleep(5)
    shellyList[3]['obj'].turnOff(switchNo=2)
    sleep(5)

    ShellyAPI.doTrace = False
    print("Beginn Energy Measure!!!")
    print("==>", shellyList[3]['obj'].getCurrentPowerUsage(switchNo=2, doTrace=False), "W")
    print("==>", shellyList[3]['obj'].getEnergyMeterValue(switchNo=2, doTrace=False), "Wh")

    shellyList[3]['obj'].turnOn(switchNo=2)
    sleep(5)
    print("==>", shellyList[3]['obj'].getCurrentPowerUsage(switchNo=2, doTrace=False), "W")
    print("==>", shellyList[3]['obj'].getEnergyMeterValue(switchNo=2, doTrace=False), "Wh")
    shellyList[3]['obj'].turnOff(switchNo=2)
    print("Done with Energy Measure!!!")


class Shelly_Site:
    def __init__(self, site_name, shellies_on_site_json):
        """
        Initiates a new Shelly site.

        Parameters
        ----------
         shelly_on_site_json : JSON structure of all Shellies in use
                shellyList = [
                    {'ip': "192.168.1.133",
                     'shelly_name': "Mehrfach-Shelly_1",
                     'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
                     'obj': None
                    },
                ]
         """
        self.__site_name = site_name
        self.__shellyList = shellies_on_site_json
        print("instantiates shelly objects....")
        for aShellyConfig in self.__shellyList:
            aShellyConfig['obj'] = ShellyAPI(ip=aShellyConfig['ip'],
                                             shelly_name=aShellyConfig['shelly_name'],
                                             shelly_type=aShellyConfig['shelly_type'])
            print(aShellyConfig['obj'].getDeviceSettings())

    def __str__(self):
        retStr = unterstreichen(self.__site_name) + '\n'
        for aShelly in self.__shellyList:
            retStr += str(aShelly['obj']) + '\n'
        return retStr

    def getShelly_for_name(self, name):
        result_list = []
        for aShelly in self.__shellyList:
            aShelly = aShelly['obj']
            ## print("  1 )" + str(aShelly))
            ## print("  1a)" + aShelly.get_shelly_name())
            if aShelly.get_shelly_name() == name:
                result_list.append(aShelly)

        if len(result_list) > 1:
            return "ERROR (1): " + name + " is not unique"
        else:
            return result_list[0]

    def bookOutlet(self, name, switchNo=0, booker=None):
        if booker is not None:
            print("Book: ", name, ":", str(switchNo) + "    -->" + booker)


if __name__ == '__main__':
    # TEST_Shelly_StaticMethods()
    # TEST_Class_Shelly()

    shellyList = [
        {'ip': "192.168.1.134",
         'shelly_name': "Allgemein 1",
         'shelly_type': ShellyTyps.Shelly_1PM_Rot,
         'obj': None,
         'booked': None
         },
        {'ip': "192.168.1.135",
         'shelly_name': "Allgemein 2",
         'shelly_type': ShellyTyps.Shelly_1PM_Rot,
         'obj': None,
         'booked': None
         },
        {'ip': "192.168.1.133",
         'shelly_name': "Steg:1 Säule:1",
         'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
         'obj': None,
         'booked': None
         },
    ]
    bootsAnlage_flugi = Shelly_Site(site_name="Bootsanlage Flugi", shellies_on_site_json=shellyList)
    print(bootsAnlage_flugi, '\n\n')

    print(unterstreichen("Steg:1 Säule:1"))
    print(bootsAnlage_flugi.getShelly_for_name("Steg:1 Säule:1"), '\n\n')

    print(unterstreichen("Allgemein 1"))
    print(bootsAnlage_flugi.getShelly_for_name("Allgemein 1"), '\n\n')

    bootsAnlage_flugi.bookOutlet(name="Allgemein 1", switchNo=0, booker="Walter Rothlin")
    print(bootsAnlage_flugi.getShelly_for_name("Allgemein 1"), '\n\n')




