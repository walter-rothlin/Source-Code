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

    def __init__(self, ip, shelly_name=None, shelly_type=ShellyTyps.Shelly_1_Blau, doTrace=False):
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
            self.turnOff(switchNo=i, doTrace=doTrace)

        for i in self.__list_of_switchs:
            self.__booked_for.append(None)
            self.__meter_at_booking.append(ShellyAPI.defaultMeterSetting)
        # print("---->", self.__meter_at_booking)


    def __str__(self):
        return self.toPrint(switchNo=self.__list_of_switchs)


    def toPrint(self, switchNo=0, sep='\n', end='\n\n', check_status=True, doTrace=False):
        if doTrace:
            print("INFO: toPrint(" + str(switchNo) + ", len(sep)" + str(len(sep)) + ", len(end)" + str(len(end)) + ")")

        retStr = ""
        if isinstance(switchNo, int):
            switchNo = [switchNo]

        is_first_item = True
        for aNum in switchNo:
            if is_first_item:
                is_first_item = False
            else:
                retStr += sep


            retStr += str(self.__ip + ':' + str(aNum) + ' {sName:25s} {sType:35s} {pBookedFrom:35s}').format(sName=self.__shelly_name, sType=self.__shelly_type, pBookedFrom=str(self.__booked_for[aNum]))
            if check_status:
                isOn = self.is_turned_on(aNum)
                retStr += "   IsOn:{p:5s}".format(p=str(isOn))
            if self.__has_watt_meter:
                retStr += "   Power:{p:5.2f} W".format(p=self.get_current_power_usage(aNum))
            if self.__has_energy_meter:
                meterValue = self.get_energy_meter_value(aNum)
                retStr += "    Current meter :{p:5.2f} Wh".format(p=meterValue)
                retStr += "    Meter at start:{p:5.2f} Wh".format(p=self.__meter_at_booking[aNum])
                retStr += "    Used:{p:5.2f} Wh".format(p=(meterValue - self.__meter_at_booking[aNum]))

        retStr += end
        return retStr

    def get_ip(self, doTrace=False):
        return self.__ip

    def get_shelly_name(self, doTrace=False):
        return self.__shelly_name

    def get_switch_list(self, doTrace=False):
        return self.__list_of_switchs

    def get_shelly_type(self, doTrace=False):
        return self.__shelly_type

    def get_booked_for(self, switchNo=0):
        return self.__booked_for[switchNo]

    def set_booked_for(self, switchNo=0, booker=None, doTrace=False):
        if self.get_booked_for(switchNo) is None and booker is not None:
            self.__booked_for[switchNo] = booker
            self.__meter_at_booking[switchNo] = self.get_energy_meter_value(switchNo)
            return True

        elif self.get_booked_for(switchNo) == booker:
            if doTrace:
                print("WARNING: " + self.__shelly_name + str(switchNo) + ": Already booked by " + booker + "(keep booked!")
            return True
        else:
            ### self.__booked_for[switchNo] = None
            ### self.__meter_at_booking[switchNo] = 0
            return False

    def cancel_booked_for(self, switchNo=0, doTrace = False):
        self.__booked_for[switchNo] = None
        self.__meter_at_booking[switchNo] = (ShellyAPI.defaultMeterSetting)
        self.turnOff(switchNo)

    def set_meter_at_booking(self, switchNo=0, meter_value=0, doTrace = False):
        self.__meter_at_booking[switchNo] = meter_value

    def get_meter_at_booking(self, switchNo=0, doTrace = False):
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

    def is_turned_on(self, switchNo=0, doTrace=False):
        """
        Checks if the shelly is ON.

        Parameters
        ----------
        switchNo : int
            Allows for multi-switch (i.e. ShellyPro_4PM_Tableau) to select switch number

         Examples
         --------
         >>> shellyOne.is_turned_on()
         """

        requestStr = 'http://' + self.__ip + "/rpc/Switch.GetStatus?id=" + str(switchNo)
        if self.__shelly_type in [ShellyTyps.Shelly_1_Blau, ShellyTyps.Shelly_1PM_Rot]:
            return "Not implemented yet for " + str(self.__shelly_type)
        else:
            if doTrace:
                print(requestStr)
            return json.loads(requests.request("GET", requestStr).text)['output']


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
    def get_all_devices_in_network(endIP=255, baseIp ="192.168.1.", doTrace=False):
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
        if doTrace:
            print("lookup for ", baseIp)
        for i in range(1, endIP + 1):
            try:
                if doTrace:
                    print("trying ", baseIp + str(i))
                device = socket.gethostbyaddr(baseIp + str(i))
                deviceList.append({
                    'ip': device[2][0],
                    'name': device[0]
                })
                if doTrace:
                    print(deviceList[-1]['ip'], deviceList[-1]['name'])
            except:
                pass
        return deviceList

    @staticmethod
    def find_all_shellys_in_network(endIP=255, doTrace=False):
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
        if doTrace:
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
    def __init__(self, site_name, shellies_on_site_json, doTrace=False):
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
        if doTrace:
            print("TRACE: Initializing '" + site_name + "'")
            print("    Instantiates shelly objects....")
        for aShellyConfig in self.__shellyList:
            aShellyConfig['obj'] = ShellyAPI(ip=aShellyConfig['ip'],
                                             shelly_name=aShellyConfig['shelly_name'],
                                             shelly_type=aShellyConfig['shelly_type'],
                                             doTrace=doTrace)
            if doTrace:
                print("    ", aShellyConfig['obj'].getDeviceSettings())

        if doTrace:
            print("TRACE: Initializing " + site_name + "completed!!")


    def __str__(self):
        retStr = "\n\n"
        retStr += unterstreichen("Status: '" + self.__site_name + "'") + "\n"
        for aShelly in self.__shellyList:
            retStr += str(aShelly['obj']) + '\n'
        return retStr


    def get_hacked_switches(self, do_switch_off=True, sep="\n", end="\n\n", doTrace=False):
        if doTrace:
            print("INFO: get_hacked_switches(do_switch_off=" + str(do_switch_off) + ")")

        retStr = ""
        for aShelly in self.__shellyList:
            switch_list = aShelly['obj'].get_switch_list()
            ip = aShelly['obj'].get_ip()
            for switch_no in switch_list:
                booked_for = aShelly['obj'].get_booked_for(switch_no)
                is_on = aShelly['obj'].is_turned_on(switch_no)
                if doTrace:
                    print("                       " + str(ip) + ":" + str(switch_no) + "  {s1:30s}".format(s1=str(booked_for)) + "{s1:20s}".format(s1=str(is_on)))
                if booked_for is None and is_on:
                    retStr += "   Found a hacked one: " + str(ip) + ":" + str(switch_no) + "  {s1:30s}".format(s1=str(booked_for)) + "{s1:20s}".format(s1=str(is_on)) + sep
                    if do_switch_off:
                        aShelly['obj'].turnOff(switchNo=switch_no, doTrace=doTrace)
        return retStr + end


    def getShelly_for_name(self, name, doTrace=False):
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


    def do_book_outlet(self, name, switchNo=0, booker=None, only_single_booking=False, auto_cancel_other_bookings=False, doTrace=False):
        retVal = False
        if doTrace:
            print("INFO: do_book_outlet(booker='" + str(name) + "', switchNo=" + str(switchNo) + ", booker='" + str(booker) + "', only_single_booking=" + str(only_single_booking) + ", auto_cancel_other_bookings=" + str(auto_cancel_other_bookings) + ")")



        if booker is not None:
            already_other_bookings = False
            if only_single_booking:
                list_of_already_booked = self.get_booked_outlets(booker_name=booker, cancel_booking=auto_cancel_other_bookings, doTrace=doTrace)
                if len(list_of_already_booked) > 0:
                    if auto_cancel_other_bookings:
                        already_other_bookings = False
                    else:
                        already_other_bookings = True
                    if doTrace:
                        print("TRACE: Already Booked for '" + booker + "':")
                        for (anOutlet, i) in list_of_already_booked:
                            print(anOutlet.toPrint(switchNo=i, sep="", end='\n'))

            if not already_other_bookings:
                anOutlet = self.getShelly_for_name(name)
                if doTrace:
                    print("TRACE: Status before booking:\n", anOutlet, sep="")

                if anOutlet.set_booked_for(switchNo=switchNo, booker=booker):
                    anOutlet.turnOn(switchNo=switchNo)
                    if doTrace:
                        print("TRACE: Status after booking:\n", anOutlet, sep="")
                    retVal = True
                else:
                    if doTrace:
                        print("TRACE: Switch has been booked already:\n", anOutlet, sep="")
                    retVal = False
        else:
            if doTrace:
                print("TRACE: --> Unknown Booker!!!")
            retVal = False
        if doTrace:
            print("INFO END: return ", retVal)
        return retVal


    def get_booked_outlets(self, booker_name=None, cancel_booking=False, doTrace=False):
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

    def cancel_booked_outlets(self, booker_name=None, doTrace=False):
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
    bootsAnlage_flugi = Shelly_Site(site_name="Bootsanlage Flugi", shellies_on_site_json=shellyList, doTrace=True)
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
    print(unterstreichen('Booking Outlets'))
    print()
    print(unterstreichen("Test booking:'Steg:1 Säule:1 Switch=0' booking for 'Walter@Rothlin.com'", "-"))
    bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=0, booker="Walter@Rothlin.com", doTrace=False)
    ## print(bootsAnlage_flugi, '\n\n')

    print()
    print(unterstreichen("Test booking again:'Steg:1 Säule:1 Switch=0' booking for 'Walter@Rothlin.com'", "-"))
    if bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=0, booker="Walter@Rothlin.com", doTrace=False):
        print('Test WARNING: Steg:1 Säule:1 Switch:0     ---> Booked again. (As expected)')
    else:
        print('Test ERROR  : Steg:1 Säule:1 Switch:0     ---> Already booked! (As unexpected)')
    ## print(bootsAnlage_flugi, '\n\n')

    print()
    print(unterstreichen("Test if booking can be overwritten:'Steg:1 Säule:1 Switch=0' booking for 'Walter.Rothlin@bzu.ch'", "-"))
    if bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=0, booker="Walter.Rothlin@bzu.ch", doTrace=False):
        print('Test ERROR  : Steg:1 Säule:1 Switch:0     ---> Booked! (As unexpected)')
    else:
        print('Test WARNING: Steg:1 Säule:1 Switch:0     ---> Already booked. (As expected)')
    ## print(bootsAnlage_flugi, '\n\n')

    print()
    print(unterstreichen("Test if more than one outlet can be booked by one person:'Steg:1 Säule:2 Switch=1' booking for 'Walter@Rothlin.com'", "-"))
    if bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:2', switchNo=1, booker="Walter@Rothlin.com", only_single_booking=True, doTrace=False):
        print("Test ERROR  : Steg:1 Säule:2 Switch:1     ---> 'Walter@Rothlin.com' could book! (As unexpected)")
    else:
        print("Test WARNING: Steg:1 Säule:2 Switch:1     ---> 'Walter@Rothlin.com' could NOT book again. (As expected)")
    print(bootsAnlage_flugi, '\n\n')

    print()
    print(unterstreichen("Test if another outlet can be booked by one person (others are canceled:'Steg:1 Säule:2 Switch=1' booking for 'Walter@Rothlin.com'", "-"))
    if bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:2', switchNo=1, booker="Walter@Rothlin.com", only_single_booking=True, auto_cancel_other_bookings=True, doTrace=False):
        print("Test WARNING: Steg:1 Säule:2 Switch:1     ---> 'Walter@Rothlin.com' could book. All other bookings have been canceled. (As unexpected)")
    else:
        print("Test ERROR  : Steg:1 Säule:2 Switch:1     ---> 'Walter@Rothlin.com' could NOT book again! (As unexpected)")
    print(bootsAnlage_flugi, '\n\n')

    print()
    print(unterstreichen("Test booking:'Steg:1 Säule:4 Switch=3' booking for 'Walter@Rothlin.com'", "-"))
    bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:4', switchNo=3, booker="Walter@Rothlin.com", doTrace=False)
    print(unterstreichen("Test booking:'Steg:1 Säule:1 Switch=2' booking for 'Walter.Rothlin@bzu.ch'", "-"))
    bootsAnlage_flugi.do_book_outlet(name='Steg:1 Säule:1', switchNo=2, booker="Walter.Rothlin@bzu.ch", doTrace=False)


    print("\n\n", unterstreichen("Booked Outlets by Walter@Rothlin.com", "-"), sep="")
    for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
        print(anOutlet.toPrint(switchNo=switchNo, end=""))


    print("\n\n", unterstreichen("Add some hacks", "-"), sep="")
    requestStr = 'http://' + '192.168.1.133' + "/relay/" + "0" + "?turn=on"
    print(requestStr)
    json.loads(requests.request("GET", requestStr).text)

    requestStr = 'http://' + '192.168.1.170' + "/relay/" + "2" + "?turn=on"
    print(requestStr)
    json.loads(requests.request("GET", requestStr).text)



    print(bootsAnlage_flugi, '\n\n')

    print(bootsAnlage_flugi.get_hacked_switches(do_switch_off=True, doTrace=False))

    print(bootsAnlage_flugi, '\n\n')

    # for (anOutlet, switchNo) in bootsAnlage_flugi.get_booked_outlets(booker_name="Walter@Rothlin.com"):
    #     print(anOutlet.toPrint(switchNo=switchNo))
    # bootsAnlage_flugi.cancel_booked_outlets(booker_name="Walter@Rothlin.com")





