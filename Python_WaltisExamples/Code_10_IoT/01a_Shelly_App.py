import socket
import json
import requests

"""
http://192.168.1.135/status
http://192.168.1.135/settings
http://192.168.1.135/relay/0?turn=on
http://192.168.1.135/relay/0?turn=off
http://192.168.1.135/relay/0?turn=on&timer=5
"""

class ShellyAPI:
    def __init__(self, ip):
        """
        Instancates a new Shelly device.

        Parameters
        ----------
         ip : string
            the target device IP Address
         Examples
         --------
         >>> ShellyAPI("192.168.1.132")
         """
        self.__ip = ip

    def getDeviceSettings(self):
        """
        Loads all the device settings.

        Parameters
        ----------
         None

         Examples
         --------
         >>> shellyOne.getDeviceSettings()
         """
        return json.loads(requests.request("GET", 'http://' + self.__ip + "/settings").text)

    def turnOn(self, timer=None):
        """
        Turns the shelly ON if the relay is already ON, nothing happens. It returns the response containing the current state of the relay.

        Parameters
        ----------
         timer : int
            allows to set a timer in seconds. The device will revert to the previous state when the timer runs out.

         Examples
         --------
         >>> shellyOne.turnOn()
         """
        if timer == None:
            return json.loads(
                requests.request("GET", 'http://' + self.__ip + "/relay/0?turn=on").text)
        else:
            return json.loads(
                requests.request("GET",
                                 'http://' + self.__ip + "/relay/0?turn=on&timer=" + str(timer)).text)

    def turnOff(self, timer=None):
        """
        Turns the shelly OFF if the relay is already OFF, nothing happens. It returns the response containing the current state of the relay.

        Parameters
        ----------
         timer : int
            allows to set a timer in seconds. The device will revert to the previous state when the timer runs out.

         Examples
         --------
         >>> shellyOne.turnOff()
         """
        if timer == None:
            return json.loads(
                requests.request("GET", 'http://' + self.__ip + "/relay/0?turn=off").text)
        else:
            return json.loads(
                requests.request("GET",
                                 'http://' + self.__ip + "/relay/0?turn=on&timer=" + str(timer)).text)

    def toggle(self, timer=None):
        """
        Toggels the shelly. It returns the response containing the current state of the relay.

        Parameters
        ----------
         timer : int
            allows to set a timer in seconds. The device will revert to the previous state when the timer runs out.

         Examples
         --------
         >>> shellyOne.toggle()
         """
        if timer == None:
            return json.loads(
                requests.request("GET", 'http://' + self.__ip + "/relay/0?turn=toggle").text)
        else:
            return json.loads(
                requests.request("GET",
                                 'http://' + self.__ip + "/relay/0?turn=on&timer=" + str(timer)).text)

    def getCurrentPowerUsage(self):
        """
        Returns the current power usage in Watts. This is not supported on every shelly.

        Parameters
        ----------
         None

         Examples
         --------
         >>> shellyOne.getCurrentPowerUsage()
         """
        return json.loads(
            requests.request("GET",
                             'http://' + self.__ip + "/status").text)['meters'][0]['power']

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


if __name__ == '__main__':
    listOfShellysInNetwork = ShellyAPI.findAllShellysInNetwork(trace=True)
    print(listOfShellysInNetwork)


    shellyOne = ShellyAPI(listOfShellysInNetwork[0]['ip'])
    #shellyOne = ShellyAPI("192.168.1.135")
    settings = shellyOne.getDeviceSettings()
    print(settings)
    shellyOne.turnOn(5)
    print(shellyOne.getCurrentPowerUsage())
