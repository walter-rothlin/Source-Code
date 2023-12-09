#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01_GPIO_Out.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_Raspberry/01_Gpio_out/01_GPIO_Out.py
#
# Description: GPIO simple
#
# GPIO PIN Belegung:     http://www.peterliwiese.ch/img/GPIO_RPi.png
# GPIO Simple Schaltung: http://www.peterliwiese.ch/img/RPi_GPIO_LED_Switch_schema.png
#
# Autor: Walter Rothlin
#
# History:
# 05-Dec-2023   Dylan Egger      Initial Version
# 09-Dec-2023   Walter Rothlin   Integrated in Moodle course
#
# ------------------------------------------------------------------

import time
import RPi.GPIO as GPIO

#gpio setup
GPIO.setmode(GPIO.BCM) # sagt welcher gpio modus gebraucht wird

GPIO.setup(3, GPIO.OUT) # definiert gpio pin 3 als output

#loop
while True:
    GPIO.output(3, GPIO.HIGH) # setzt pin 3 auf HIGH also 3.3v
    time.sleep(1)             # wartet 1s
    GPIO.output(3, GPIO.LOW)  # setzt pin 3 auf LOW also 0v
    time.sleep(1)             # wartet 1s