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
from enum import Enum
from time import sleep
from waltisLibrary import *


class ShellyTyps(Enum):
    Shelly_1_Blau = 1
    Shelly_1PM_Rot = 2
    ShellyPro_4PM_Tableau = 3


class ShellyAPI:
    defaultMeterSetting = 0

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
        self.__booked_for = []
        self.__booked_at = []
        self.__meter_at_booking = []
        self.__list_of_switchs = [0]

        self.__has_watt_meter = False
        self.__has_energy_meter = False

        if self.__shelly_type in [ShellyTyps.ShellyPro_4PM_Tableau]:
            self.__list_of_switchs = [0, 1, 2, 3]
            self.__has_watt_meter = True
            self.__has_energy_meter = True

        if self.__shelly_type in [ShellyTyps.Shelly_1PM_Rot]:
            self.__has_watt_meter = True
            self.__has_energy_meter = False

        for i in self.__list_of_switchs:
            self.turnOff(switchNo=i)

        for i in self.__list_of_switchs:
            self.__booked_for.append(None)
            self.__meter_at_booking.append(ShellyAPI.defaultMeterSetting)
        # print("---->", self.__meter_at_booking)


    def __str__(self):
        retStr = ""
        for sNo in self.__list_of_switchs:
            retStr += self.toPrint(switchNo=sNo)
        return retStr

    def toPrint(self, switchNo=0, sep='\n', end='\n\n'):
        retStr = ""
        if isinstance(switchNo, int):
            switchNo = [switchNo]

        is_first_item = True
        for aNum in switchNo:
            if not is_first_item:
                retStr += sep

            is_first_item = False
            retStr += str(self.__ip + ':' + str(aNum) + ' {sName:25s} {sType:35s} {pBookedFrom:35s}').format(sName=self.__shelly_name, sType=self.__shelly_type, pBookedFrom=str(self.__booked_for[aNum]))
            if self.__has_watt_meter:
                retStr += "   Power:{p:5.2f}W".format(p=self.get_current_power_usage(aNum))
            if self.__has_energy_meter:
                meterValue = self.get_energy_meter_value(aNum)
                retStr += "  Current meter :{p:5.2f}Wh".format(p=meterValue)
                retStr += "  Meter at start:{p:5.2f}Wh".format(p=self.__meter_at_booking[aNum])
                retStr += "  Used:{p:5.2f}Wh".format(p=(meterValue - self.__meter_at_booking[aNum]))

        retStr += end
        return retStr

    def get_ip(self):
        return self.__ip

    def get_shelly_name(self):
        return self.__shelly_name

    def get_switch_list(self):
        return self.__list_of_switchs

    def get_shelly_type(self):
        return self.__shelly_type

    def get_booked_for(self, switchNo=0):
        return self.__booked_for[switchNo]

    def set_booked_for(self, switchNo=0, booker=None):
        if self.get_booked_for(switchNo) is None and booker is not None:
            self.__booked_for[switchNo] = booker
            self.__meter_at_booking[switchNo] = self.get_energy_meter_value(switchNo)
            return True
        else:
            ### self.__booked_for[switchNo] = None
            ### self.__meter_at_booking[switchNo] = 0
            return False

    def cancel_booked_for(self, switchNo=0):
        self.__booked_for[switchNo] = None
        self.__meter_at_booking[switchNo] = (ShellyAPI.defaultMeterSetting)
        self.turnOff(switchNo)

    def set_meter_at_booking(self, switchNo=0, meter_value=0):
        self.__meter_at_booking[switchNo] = meter_value

    def get_meter_at_booking(self, switchNo=0):
        return self.__meter_at_booking[switchNo]

    def turnOn(self, switchNo=0, timer=None, doTrace=True):
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


    def turnOff(self, switchNo=0, timer=None, doTrace=True):
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


    def toggle(self, switchNo=0, timer=None, doTrace=True):
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


    def getDeviceSettings(self, doTrace=False):
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


    def get_current_power_usage(self, switchNo=0, doTrace=False):
        """
        Returns the current power usage in Watts. This is not supported on every shelly.

        Parameters
        ----------
         switchNo : int
            Allows for multi-switch (i.e. ShellyPro_4PM_Tableau) to select switch number

         Examples
         --------
         >>> shellyOne.get_current_power_usage()
         """
        if self.__has_watt_meter:
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
        else:
            powerInWatt = -1
            if doTrace:
                print("-->", powerInWatt)

        return powerInWatt

    def get_energy_meter_value(self, switchNo=0, doTrace=False):
        """
        Returns the actual energy meter level in Watthours (Wh). This is not supported on every shelly.

        Parameters
        ----------
         switchNo : int
            Allows for multi-switch (i.e. ShellyPro_4PM_Tableau) to select switch number

         Examples
         --------
         >>> shellyOne.get_energy_meter_value()
         """
        energyMeterLevel = -1
        if self.__has_energy_meter:
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
    def get_all_devices_in_network(endIP=255, baseIp ="192.168.1.", trace=False):
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
         >>> shellyOne.get_all_devices_in_network()
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
    def find_all_shellys_in_network(endIP=255, trace=False):
        """
         Finds Shellys in a Network

         Parameters
         ----------
          end : int
             defines the upper end of the search

          Examples
          --------
          >>> shellyOne.find_all_shellys_in_network()
          """
        if trace:
            print("Search shellys....")
        return [device for device in ShellyAPI.get_all_devices_in_network(endIP) if device['name'].find('shelly') > -1]


def TEST_Shelly_StaticMethods():
    listOfShellysInNetwork = ShellyAPI.find_all_shellys_in_network(trace=True)
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
                    },
                ]
         """
        self.__site_name = site_name
        self.__shellyList = shellies_on_site_json
        ## print("instantiates shelly objects....")
        for aShellyConfig in self.__shellyList:
            aShellyConfig['obj'] = ShellyAPI(ip=aShellyConfig['ip'],
                                             shelly_name=aShellyConfig['shelly_name'],
                                             shelly_type=aShellyConfig['shelly_type'])
            ## print(aShellyConfig['obj'].getDeviceSettings())

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

    def do_book_outlet(self, name, switchNo=0, booker=None, doTrace=False):
        retVal = False
        if doTrace:
            print("--> Try to book: ", name, ":", str(switchNo) + "    --> " + booker)

        if booker is not None:
            anOutlet = self.getShelly_for_name(name)
            if doTrace:
                print("Status before booking:\n", anOutlet, sep="")

            if anOutlet.set_booked_for(switchNo=switchNo, booker=booker):
                anOutlet.turnOn(switchNo=switchNo)
                if doTrace:
                    print("Status after booking:\n", anOutlet, sep="")
                retVal = True
            else:
                if doTrace:
                    print("Switch has been booked already:\n", anOutlet, sep="")
                retVal = False
        else:
            if doTrace:
                print("Unknow Booker!!!\n")
            retVal = False
        if doTrace:
            print("<-- End to book: ", name, ":", str(switchNo) + "    --> " + booker)
        return retVal

    def get_booked_outlets(self, booker_name=None, cancel_booking=False):
        result_list = []
        for aShelly in self.__shellyList:
            aShelly = aShelly['obj']
            list_of_switches = aShelly.get_switch_list()

            if booker_name is None:
                for i in list_of_switches:
                    if (aShelly.get_booked_for(switchNo=i) is not None):
                        result_list.append((aShelly, i))
                        if cancel_booking:
                            aShelly.cancel_booked_for(switchNo=i)
            else:
                for i in list_of_switches:
                    if (aShelly.get_booked_for(switchNo=i) == booker_name):
                        result_list.append((aShelly, i))
                        if cancel_booking:
                            aShelly.cancel_booked_for(switchNo=i)
        return result_list

    def cancel_booked_outlets(self, booker_name=None):
        return self.get_booked_outlets(booker_name=booker_name, cancel_booking=True)

if __name__ == '__main__':
    # TEST_Shelly_StaticMethods()
    # TEST_Class_Shelly()

    shellyList = [
        # {'ip': "192.168.1.134",
        #  'shelly_name': "Allgemein 1",
        #  'shelly_type': ShellyTyps.Shelly_1PM_Rot,
        #  },
        # {'ip': "192.168.1.135",
        #  'shelly_name': "Allgemein 2",
        #  'shelly_type': ShellyTyps.Shelly_1PM_Rot,
        #  },
        # {'ip': "192.168.1.131",
        #  'shelly_name': "Mit Schalter",
        #  'shelly_type': ShellyTyps.Shelly_1_Blau,
        #  },
        {'ip': "192.168.1.133",
         'shelly_name': "Steg:1 Säule:1",
         'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
         },
        {'ip': "192.168.1.169",
         'shelly_name': "Steg:1 Säule:2",
         'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
         },
        {'ip': "192.168.1.170",
         'shelly_name': "Steg:1 Säule:3",
         'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
         },
        {'ip': "192.168.1.171",
         'shelly_name': "Steg:1 Säule:4",
         'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
         },
    ]
    bootsAnlage_flugi = Shelly_Site(site_name="Bootsanlage Flugi", shellies_on_site_json=shellyList)
    print(bootsAnlage_flugi, '\n\n')

    # ## print(unterstreichen("Steg:1 Säule:1"))
    # ## print(bootsAnlage_flugi.getShelly_for_name("Steg:1 Säule:1"), '\n\n')
    #
    # print(unterstreichen('Steg:1 Säule:1'))
    # print(bootsAnlage_flugi.getShelly_for_name('Steg:1 Säule:1'), '\n\n')
    # bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=0, booker="Walter.Rothlin@bzu.ch")
    # bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=1, booker="Walter@Rothlin.com")
    # bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=2, booker="Walter@Rothlin.com")
    # bootsAnlage_flugi.do_book_outlet(name='Allgemein 1', switchNo=0, booker="landwirtschaft@genossame-wangen.ch")
    # bootsAnlage_flugi.do_book_outlet(name='Mit Schalter', switchNo=0, booker="Remo Collet")
    #
    # print("\n\n", unterstreichen("Booked Outlets for Walter@Rothlin.com"), sep="")
    # for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
    #     print(anOutlet.toPrint(switchNo=switchNo))
    #
    # print("\n\n", unterstreichen("Booked Outlets for Walter.Rothlin@bzu.ch"), sep="")
    # for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter.Rothlin@bzu.ch"):
    #     print(anOutlet.toPrint(switchNo=switchNo))
    #
    # print("\n\n", unterstreichen("Booked Outlets"), sep="")
    # for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets():
    #     print(anOutlet.toPrint(switchNo=switchNo))
    # print('\n\n')
    #
    # sleep(2)
    # print(bootsAnlage_flugi, '\n\n')
    # print("Unbook Remo Collet")
    # bootsAnlage_flugi.cancel_booked_outlets(booker_name="Remo Collet")
    # print(bootsAnlage_flugi, '\n\n')
    #
    #
    # print("Unbook Walter@Rothlin.com")
    # bootsAnlage_flugi.cancel_booked_outlets(booker_name="Walter@Rothlin.com")
    # print(bootsAnlage_flugi, '\n\n')
    #
    # sleep(2)
    # print("Unbook ALL")
    # bootsAnlage_flugi.cancel_booked_outlets()
    # print(bootsAnlage_flugi, '\n\n')
    #
    #
    # sleep(5)
    print("\n\n")
    print(unterstreichen('Calculating energy consumtion'))

    bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=2, booker="Walter@Rothlin.com", doTrace=False)
    for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
        print(anOutlet.toPrint(switchNo=switchNo))

    if bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=2, booker="Walter.Rothlin@bzu.ch", doTrace=False):
        for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter.Rothlin@bzu.ch"):
            print(anOutlet.toPrint(switchNo=switchNo))
    else:
        print('ERROR: Steg:1 Säule:1 already booked!!!!!')

    bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:2', switchNo=2, booker="Walter@Rothlin.com", doTrace=False)
    for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
        print(anOutlet.toPrint(switchNo=switchNo))

    bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:3', switchNo=3, booker="Walter@Rothlin.com", doTrace=False)
    for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
        print(anOutlet.toPrint(switchNo=switchNo))

    bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:4', switchNo=0, booker="Walter@Rothlin.com", doTrace=False)
    for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
        print(anOutlet.toPrint(switchNo=switchNo))

    sleep(2)
    for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
        print(anOutlet.toPrint(switchNo=switchNo))

    sleep(8)
    for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
        print(anOutlet.toPrint(switchNo=switchNo))
    bootsAnlage_flugi.cancel_booked_outlets(booker_name="Walter@Rothlin.com")





