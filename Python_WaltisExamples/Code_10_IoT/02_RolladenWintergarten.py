
import requests
import json

# About Shellys
# -------------
# https://www.shelly-support.eu/



# Requests:
# ----------------
# http://192.168.1.35/cgi-local/get-sensor-values    in Chrom starten und mit F12 trace des traffics
# http://192.168.1.35/cgi-local/shutters/Up
# http://192.168.1.35/cgi-local/shutters/Down
# http://192.168.1.35/cgi-local/shutters/Stop

defaultIp = '192.168.1.35'
def getSensorValues(respI, what):
    resp = json.loads(respI.text)
    if what == 'Temp':
        return resp['Temp']
    elif what == 'Hum':
        return resp['Hum']
    elif what == 'State':
        return resp['State']
    else:
        return "Unknown"


def getStatus(ip = defaultIp):
    req_status = 'http://{ip:s}/cgi-local/get-sensor-values'.format(ip=ip)
    print("Checking status:", req_status)
    res = requests.get(req_status)
    if res.status_code != 200:
        print("ERROR:", res.status_code)
        return ""
    return res

def setShellyOn(ip = defaultIp, relay = 0):
    shelly1_req_on = 'http://{ip:s}/cgi-local/relay/{relay:d}?turn=on'.format(ip=ip,relay=relay)
    print("Set Shelly on:", shelly1_req_on)
    res = requests.get(shelly1_req_on)
    if res.status_code != 200:
        print("ERROR:", res.status_code)
        return ""
    return ""

def setShellyOff(ip = defaultIp, relay = 0):
    shelly1_req_off = 'http://{ip:s}/cgi-local/relay/{relay:d}?turn=off'.format(ip=ip,relay=relay)
    print("Set Shelly off:", shelly1_req_off)
    res = requests.get(shelly1_req_off)
    if res.status_code != 200:
        print("ERROR:", res.status_code)
        return ""
    return ""


response = getStatus()
print("Temperatur  :",getSensorValues(response,'Temp'))
print("Feuchtigkeit:",getSensorValues(response,'Hum'))

