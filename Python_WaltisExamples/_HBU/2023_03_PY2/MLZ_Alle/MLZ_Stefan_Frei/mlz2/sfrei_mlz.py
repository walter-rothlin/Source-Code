#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: /home/sfrei/Documents/Source/2023_python/mlz2/sfrei_mlz.py
#
# Description: PYT2 MLZ Sensehat controlled by flask application
#
# Autor: Stefan Frei
#
# History:
# 15.01.2024   Stefan Frei      Initialversion
#
# ------------------------------------------------------------------

from flask import Flask, request, session, render_template, Response

import socket
import os
import platform

import json

from Class_Sensehat import MySenseHat

app = Flask(__name__)
sense = MySenseHat()

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/status', methods=['GET'])
def raspi_status():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)

    uname = platform.uname()    
    return {
        'hostname':hostname,
        'ip_address':ip_address,
        'user':os.getlogin(),
        'system':uname.system,
        'machine': uname.machine
    }

@app.route('/getpixels', methods=['GET'])
def sense_getpixels():
    pixels = sense.get_pixels()
    print(pixels)
    return json.dumps(pixels)

#Hier die Methode noch erweitern, dass sie auch URL Parameter annehmen kann und dann kein Formular anzeigt.
@app.route('/setpixel', methods=['GET', 'POST'])
def sense_setpixel():
    if request.method == "POST":
        x_coordinate = request.form.get("xcoord")
        y_coordinate = request.form.get("ycoord")
        pixel_color = request.form.get("color")
        print(f'x: {x_coordinate}, y: {y_coordinate}, color: {pixel_color}')
        sense.set_pixel(x = x_coordinate, y = y_coordinate, pixel_color = pixel_color)
        return {
        'x':x_coordinate,
        'y':y_coordinate,
        'color':pixel_color
        }, 200

    return render_template('setpixel.html')

@app.route('/clearpixels', methods=['GET'])
def sense_clearpixels():
    response = Response(status=200)
    sense.clear()
    return response

#Die show_message Methode müsste man auch noch erweitern mit Farben als Wörtern.
#Was aber noch mehr spass machen würde, wäre ein Color Picker auf dem Form und dann von Hex in RGB konvertieren
@app.route('/message', methods=['GET', 'POST'])
def sense_scrollmessage():
    if request.method == "POST":
        scroll_message = request.form.get("message")
        pixel_color = request.form.get("color")
        print(f'message: {scroll_message}, color: {pixel_color}')
        sense.show_message(text_string = scroll_message)
    return render_template('message.html')

@app.route('/weather', methods=['GET'])
def sense_weather():
    temperature = round(sense.temperature, 2)
    humidity = round(sense.humidity, 2)
    pressure = round(sense.get_pressure(), 2) 
    print(f'temp: {temperature}, hdty: {humidity}, prss: {pressure}')
    return render_template('weather.html', temperature=temperature, humidity=humidity, pressure=pressure)


if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
    