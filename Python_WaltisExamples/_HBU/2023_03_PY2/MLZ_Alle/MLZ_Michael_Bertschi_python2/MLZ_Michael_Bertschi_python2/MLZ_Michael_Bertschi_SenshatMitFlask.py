#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : MLZ_Michael_Bertschi_Flask_mit_senshat
#
# Description: Flaskapplikaltion mit restendpoints auf senshat
# 
#
# Autor: Michael Bertschi
#
# History:
# 
#
# ------------------------------------------------------------------


from flask import Flask, request, session, redirect, url_for, render_template, jsonify
import socket
import getpass
from MySensHat import MySenseHat


class State():
    def __init__(self):
        self.__req_count = 0

    def inc(self):
        self.__req_count +=1

    def get_reg_count(self):
        return str(self.__req_count)

app = Flask(__name__)

@app.route('/')
def index():
    # Die Startseite zeigt Links zu den REST-Endpoints
    return render_template('index.html')

'''
 Zeigt den Aktuell status in einer Table an 
 es zeigt den hostname, der angemeldete user und die aktuelle ip
'''
@app.route('/status')
def status():
    print("Get all infos")
    hostname = socket.gethostname()
    username = getpass.getuser()
    ip_address = socket.gethostbyname(hostname)

    data= {
        'Hostname': hostname,
        'Username': username,
        'IP Address': ip_address

    }
    return render_template('user_info.html', data=data)

'''
Zeigt die selben informationen wie der status aber als json 
'''
@app.route('/jsonStatus')
def jsonStatus():
    hostname = socket.gethostname()
    username = getpass.getuser()
    ip_address = socket.gethostbyname(hostname)
    print("return status as table")
    return jsonify(hostname=hostname, username=username, ip_address=ip_address)

'''
Zeigt die aktuellen werte von den LEDS an als json nicht formatiert
'''
@app.route('/rgbWerte')
def rgbWerte():
    sense = MySenseHat()
    print('SensHat pixels: { sense.get_pixels()} ')
    return jsonify(pixels=sense.get_pixels())

'''
um einzlne leds mit einem html input field zu setzen
bestehend led werden nicht removed nur überschrieben wenn man 
auf die gleiche posistion ein neues setzt.
'''
@app.route('/rgbWertSetzen', methods=['GET', 'POST'])
def rgbWertSetzern():
    print('setColor')
    if request.method == 'POST':
        data = request.json
        x = data.get('x')
        y = data.get('y')
        r = data.get('r')
        g = data.get('g')
        b = data.get('b')
        if x == None:
            x = 1
        if y == None:
            y = 1
        if r == None:
            r = 10
        if g == None:
            g = 10
        if b == None:
            b = 10
        sense = MySenseHat()
        sense.set_pixel(x=int(x), y=int(y), r=int(r), g= int(g), b=int(b))
        print('SensHat pixels: { sense.get_pixels()}')
        pixels = sense.get_pixels()
        print(pixels)
        return jsonify({"pixels": pixels})
    return render_template('farbeeinegeben.html')

'''
Überschreibt alle led mit einer farbe 
ansonsten wird ein default wert von 10,10,10 gesetzt.
'''
@app.route('/allRGBOverride', methods=['GET', 'POST'])
def allRGBOverride():
    print('setAllColor')
    if request.method == 'POST':
        data = request.json
        r = data.get('r')
        g = data.get('g')
        b = data.get('b')
        if r == None:
            r = 10
        if g == None:
            g = 10
        if b == None:
            b = 10 
        print('endpoint ist called.')
        sense = MySenseHat()
        sense.clear()
        print(f'colors {int(r)}, {int(g)}, {int(b)}')
        color = ( int(r), int(g), int(b))
        sense.clear(color)
        print('set all leds to one color')
        redirect(url_for('rgbWerte'))
        pixels = sense.get_pixels()
        return jsonify({"pixels": pixels})
    return render_template('changeAllColorInput.html')

'''
Schreibt eine nachricht auf den senshat. Farben nicht wählbar 
'''
@app.route('/writeRgbMessage', methods=['GET', 'POST'])
def writeRgbMessage():
    print('set A message')
    if request.method == 'POST':
        data = request.json
        r = data.get('textToDisplay')
        if r == None:
            r = 'DefaultText'
        print('endpoint ist called.')
        sense = MySenseHat()
        sense.clear()
        sense.show_message(r, scroll_speed=0.5,text_colour=[255, 255, 255], back_colour=[0, 0, 0])
        print('set all leds to one color')
    print('show default page ')
    return render_template('writeAText.html')

import json
import requests
import datetime
import time

city_name='Oerlikon'

uel_end_point = "https://api.openweathermap.org/data/2.5/weather"
apiKey = '15f2c45600415846c6648332accaa610'
params_end_point = {
    'q' : city_name, 
    'appid' : apiKey,
    'mode' : '',
    'units': 'metric',
}

'''
Hohlt sich die wetterdaten von openweater von der Region oerlikon. 
Zeigt sie als json an. 
'''
@app.route('/getMeteoInfosByPLZ')
def getWeatherInfo():
    print('endpoint ist called.')
    response = requests.get(uel_end_point, params=params_end_point)
    responseStr = response.text
    jsonResponse = json.loads(responseStr)
    timestamp = datetime.datetime.now()
    print(jsonResponse)
    formatted_time = timestamp.strftime("%Y-%m-%d %H:%M:%S")
    formatted_temp = f"{jsonResponse['main']['temp']}°C"
    formatted_pressure = f"{jsonResponse['main']['pressure']} hPa"
    formatted_humidity = f"{jsonResponse['main']['humidity']}%"
    formatted_description = jsonResponse['weather'][0]['description']
    return jsonify(formatted_time=formatted_time, formatted_temp=formatted_temp, formatted_pressure=formatted_pressure,formatted_humidity=formatted_humidity,formatted_description=formatted_description)

'''
Zeigt imudaten von dem senshat an als json. 
'''
@app.route('/imu')
def get_imu_datas():
    sense = MySenseHat()
    orientierung = sense.get_orientation()
    pitch = orientierung["pitch"]
    roll = orientierung["roll"]
    yaw = orientierung["yaw"]
    print(f'Orientierung pitch:{pitch}, roll:{roll}, yaw{yaw}')
   
    beschleunigung = sense.get_accelerometer_raw()
    x = beschleunigung["x"]
    y = beschleunigung["y"]
    z = beschleunigung["z"]
    print(f'Orientierung x:{x}, y:{y}, z{z}')
    
    gyro = sense.get_gyroscope_raw()
    gyro_x = gyro["x"]
    gyro_y = gyro["y"]
    gyro_z = gyro["z"]
    print(f'Orientierung gyro_x:{gyro_x}, gyro_y:{gyro_y}, gyro_z{gyro_z}')

    return jsonify({
        "orientierung": {"pitch": pitch, "roll": roll, "yaw": yaw},
        "beschleunigung": {"x": x, "y": y, "z": z},
        "gyroskop": {"x": gyro_x, "y": gyro_y, "z": gyro_z}})


if __name__ == '__main__':
    state = State()
    app.run(debug=True, host='127.0.0.1', port=5001)
