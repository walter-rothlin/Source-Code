from HomeController import HomeController
from machine import Pin, UART, Timer, RTC
from time import sleep
import time
import socket
import network
import json
import urequests

pgm_name = 'SBB-Uhr'
version = 'V5.0.0.1'
wait_for_minuten_schlag = True

ssid = None
ip_adress = None

wifi_connections = [
    {'SSID': 'WalterRothlin_2', 'Password': 'waltiClaudia007'},
    {'SSID': 'Waltis_iPhone', 'Password': 'Walti007'},
]

def is_wifi_connected():
    wlan = network.WLAN(network.STA_IF)
    return wlan.isconnected()
    
def connect_to_wifi(homeController, connections, max_wifi_connect_tries=20, timeout_between_tries=0.5):
    # try to connect to Wi-Fi
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)

    for a_connection in connections:
        ssid = a_connection['SSID']
        wifi_pwd = a_connection['Password']
        
        wlan.connect(ssid, wifi_pwd)
        wifi_connect_tries = 0

        while not wlan.isconnected() and wlan.status() >= 0 and wifi_connect_tries < max_wifi_connect_tries:
            wifi_connect_tries += 1
            status_str = f"{max_wifi_connect_tries - wifi_connect_tries:2d}:{'Connecting to':13s}{ssid:16s}"
            homeController.write_lcd(status_str)
            print(status_str)
            print(f'INFO Try: {wlan.isconnected()} {wlan.status()}')
            sleep(timeout_between_tries)
        
        if wlan.isconnected():
            netConfig = wlan.ifconfig()
            ip_adr = str(netConfig[0])
            homeController.write_lcd(f"{'Connected to':16s}{ssid:16s}")
            print(f"SSID:{ssid:16s}   IP:{ip_adr:16s}")
            return ssid, ip_adr, netConfig

    print("Failed to connect to any network.")
    homeController.write_lcd("Wi-Fi Connection Failed")
    return None, None, None


def fetch_time_with_retries(url, retries=5, delay=2):
    for attempt in range(retries):
        try:
            response = urequests.get(url)
            return response  # If successful, return the response
        except OSError as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            time.sleep(delay)
    raise Exception("Failed to fetch time after multiple attempts.")


def set_rtc_time(rtc):
    if not is_wifi_connected():
        print("WARNING: Not connected to Wi-Fi. Cannot fetch time.")
        return False  # Abort if no Wi-Fi
        
    clock_is_set = True
    try:
        url = "http://worldtimeapi.org/api/timezone/Europe/Zurich"
        r = fetch_time_with_retries(url)
        json_res = json.loads(r.text)
        r.close()
    except (ValueError, OSError) as e:
        print("WARNING: Time not read from REST!!!!")
        json_res = {'datetime': '2023-06-04T14:17:43.914520+02:00'} ## datetime.now().isoformat()}
        clock_is_set = False

    datetime_str = json_res['datetime']
    yyyy = int(datetime_str[:4])
    mm = int(datetime_str[5:7])
    dd = int(datetime_str[8:10])
    hh = int(datetime_str[11:13])
    min = int(datetime_str[14:16])
    sec = int(datetime_str[17:19])
    now_time = (yyyy, mm, dd, None, hh, min, sec, 0)
    rtc.datetime(now_time)
    print("RTC set to:", now_time)
    date_str = f'{dd:02d}.{mm:02d}.{yyyy:4d}'
    time_str = f'{hh:02d}:{min:02d}:{sec:02d}'
    print(f'Now: {date_str} {time_str}')
    
    clock_is_set_text = 'Clock NOT syncronized'
    if clock_is_set:
        clock_is_set_text = 'Clock is syncronized'
    return clock_is_set, clock_is_set_text

def get_string_from_date_time(datetime):
    return f'{datetime[0]:04d}-{datetime[1]:02d}-{datetime[2]:02d}', f'{datetime[4]:02d}:{datetime[5]:02d}:{datetime[6]:02d}'


def initialization():
    homeController = HomeController()
    sleep(1)
    homeController.write_lcd(pgm_name + ' ' + version)
    sleep(2)
    ssid, ip_adress, netConfig = connect_to_wifi(homeController, wifi_connections)
    if not ssid:
        return  # Stop further initialization if Wi-Fi fails
    sleep(2)
    homeController.write_lcd(f'{ssid:16s}{ip_adress:16s}')

    # Initialize RTC in the microcontroller
    rtc = RTC()
    clock_is_set, clock_is_set_text = set_rtc_time(rtc)
    date_str, time_str = get_string_from_date_time(rtc.datetime())
    
    print(f'Date/Time now: {date_str} {time_str} --> {clock_is_set_text}', end='\n\n')
    homeController.write_lcd(f'{date_str:16s}{time_str:16s}')
    
    
    addr = socket.getaddrinfo(netConfig[0], 80)[0][-1]
    server = socket.socket()
    server.bind(addr)
    server.listen(1)
    
    return homeController, rtc, ssid, ip_adress, server



def minuten_takt(event):
    if homeController.get_relais(0):
        homeController.set_relais(0,0)
        homeController.set_relais(1,0)
    else:
        homeController.set_relais(0,1)
        homeController.set_relais(1,1)
        
    # date_str, time_str = get_string_from_date_time(rtc.datetime())    
    # print(get_string_from_date_time(rtc.datetime()))
   
def sekunden_takt(event):
    global wait_for_minuten_schlag
    date_str, time_str = get_string_from_date_time(rtc.datetime())
    homeController.write_lcd(f'{date_str:16s}{time_str:16s}')
    # print(time_str, time_str[-2:])
    if time_str[-2:] == '00':
        wait_for_minuten_schlag = False
        print('Minuten Takt should start!!')
        
    
# =================  
# main
# =================  
homeController, rtc, ssid, ip_adress, server = initialization()

print('Sekunden Takt started!!')
sekunden_clock = Timer()
sekunden_clock.init(period=1000, mode=Timer.PERIODIC, callback=sekunden_takt)

while wait_for_minuten_schlag:
    sleep(0.5)

print('Minuten Takt started!!')
minuten_clock = Timer()
minuten_clock.init(period=60000, mode=Timer.PERIODIC, callback=minuten_takt)

# Auf eingehende Requests hören
while True:
    try:
        conn, addr = server.accept()
        request = str(conn.recv(1024))

        path = request.split("HTTP")[0].split("GET ")[-1].rstrip().lstrip()

        code = 200
        content_type = "application/json"
        
        response = {'ssid': ssid,
                    'ip_adress': ip_adress,
                   }
                   
        if content_type == "application/json":
            response = json.dumps(response)

        conn.send(f'HTTP/1.0 {code} OK\r\nContent-type: {content_type}\r\n\r\n')
        conn.send(response)
        conn.close()
    except OSError as e:
        print(f'ERROR: {e}')
        break
    except (KeyboardInterrupt):
        homeController.write_lcd(f'Closing Server')
        break
        
server.close()
print('Server beendet')