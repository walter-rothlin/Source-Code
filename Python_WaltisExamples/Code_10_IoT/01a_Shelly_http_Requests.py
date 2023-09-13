#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01a_Shelly_http_Requests.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_10_IoT/01a_Shelly_http_Requests.py
#
# Description: Beispiel REST Requests for a Blue Shelly 1
#
#
#
#
# Autor: Walter Rothlin
#
# History:
# 30_Jul-2022   Walter Rothlin      Initial Version
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

import requests
import json
defaultIp = '192.168.107.133'    # Testlampe Shelly 1 Blue

def getShellyStatusDetail(respI, what):
    resp = json.loads(respI.text)
    if what == 'ip':
        return resp['wifi_sta']['ip']
    elif what == 'ssid':
        return resp['wifi_sta']['ssid']
    elif what == 'ison':
        return resp['relays'][0]['ison']
    else:
        return "Unknown"


def getShellyStatus(ip=defaultIp):
    shelly1_req_status = 'http://{ip:s}/status'.format(ip=ip)
    print("Checking Shelly status:", shelly1_req_status)
    res = requests.get(shelly1_req_status)
    if res.status_code != 200:
        print("ERROR:", res.status_code)
        return ""
    return res

def setShellyOn(ip = defaultIp, relay = 0):
    shelly1_req_on = 'http://{ip:s}/relay/{relay:d}?turn=on'.format(ip=ip,relay=relay)
    print("Set Shelly on:", shelly1_req_on)
    res = requests.get(shelly1_req_on)
    if res.status_code != 200:
        print("ERROR:", res.status_code)
        return ""
    return getShellyStatusDetail(getShellyStatus(), 'ison')

def setShellyOff(ip = defaultIp, relay = 0):
    shelly1_req_off = 'http://{ip:s}/relay/{relay:d}?turn=off'.format(ip=ip, relay=relay)
    print("Set Shelly off:", shelly1_req_off)
    res = requests.get(shelly1_req_off)
    if res.status_code != 200:
        print("ERROR:", res.status_code)
        return ""
    return getShellyStatusDetail(getShellyStatus(), 'ison')


response = getShellyStatus()
print(getShellyStatusDetail(response, 'ip'))
print(getShellyStatusDetail(response, 'ssid'))
if getShellyStatusDetail(response, 'ison'):
    if setShellyOff():
        print("Lampe is now off (1)!")
    else:
        print("Lampe is now off!!")
else:
    print("Lampe is off! Switching it on...")
    if setShellyOn():
        print("Lampe is now on!!")
    else:
        print("Lampe is now off (4)!")
