
import requests
import json

# About Shellys
# -------------
# https://www.shelly-support.eu/



# Shelly Requests:
# ----------------
# http://192.168.1.114    in Chrom starten und mit F12 trace des traffics
# http://192.168.1.114/status
# http://192.168.1.114/relay/0?turn=on
# http://192.168.1.114/relay/0?turn=off
# http://192.168.1.114/settings/relay/0?schedule_rules=1430-0123456-on
# http://192.168.1.114/settings/relay/0?schedule_rules=1430-0123456-on%2C1435-0123456-off

defaultIp = '192.168.1.137'
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


def getShellyStatus(ip = defaultIp):
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
    return getShellyStatusDetail(getShellyStatus(),'ison')

def setShellyOff(ip = defaultIp, relay = 0):
    shelly1_req_off = 'http://{ip:s}/relay/{relay:d}?turn=off'.format(ip=ip,relay=relay)
    print("Set Shelly off:", shelly1_req_off)
    res = requests.get(shelly1_req_off)
    if res.status_code != 200:
        print("ERROR:", res.status_code)
        return ""
    return getShellyStatusDetail(getShellyStatus(),'ison')


response = getShellyStatus()
print(getShellyStatusDetail(response, 'ip'))
print(getShellyStatusDetail(response, 'ssid'))
if getShellyStatusDetail(response, 'ison'):
    if (setShellyOff()):
        print("Lampe is now off!")
    else:
        print("Lampe is now on!")
else:
    print("Lampe is off! Switching it on...")
    if (setShellyOn()):
        print("Lampe is now on!")
    else:
        print("Lampe is now on!")
