#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: meteoStation.py
#
# Description: Zeigt Luftdruck, Temperatur und Luftfeuchtigkeit
#              auf dem Pixel-Display an
#
# Autor: Walter Rothlin
#
# History:  
# 10-Apr-2018	Walter Rothlin		Initial Version
# ------------------------------------------------------------------

from sense_hat import SenseHat
from time import sleep
from support import *
import math

sense = SenseHat()

while (True):
	humidity = sense.get_humidity()
	feuchteStr ="Humidity: {feuchte:3.1f}%".format(feuchte=humidity)

	temp = sense.get_temperature()
	tempStr = "Temperature: {temperatur:3.1f}C".format(temperatur=temp)

	pressure = sense.get_pressure()
	pressStr = "Pressure: {druck:3.1f}mBar".format(druck=pressure)

	meteoStr = feuchteStr + "    " + tempStr + "    " + pressStr
	print(meteoStr)
	
	sense.show_message(meteoStr)
	tempStr = "{temperatur:3.0f}C".format(temperatur=temp)
	for y in range(1,5):
		sense.show_message(tempStr,scroll_speed=0.5,back_colour=[125,0,0],text_colour=[0,125,0])
	sleep(1)




	


