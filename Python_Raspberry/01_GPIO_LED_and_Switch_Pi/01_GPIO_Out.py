#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01_GPIO_out.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_Raspberry/01_Gpio_out/01_GPIO_out.py
#
# Description: Manager für Genossame-Daten
#
# Autor: Walter Rothlin
#
# History:
# 01-Jan-2023   Walter Rothlin      Initial Version
# 21-Jun-2023   Walter Rothlin      Added Commen_Defs
#
# ------------------------------------------------------------------

#==================
# Autohr: Dylan Egger
#
# versionen
# 1.0.0  5.12.2023  dylan eggger  initial version
#=========

#inport
import time
import RPi.GPIO as GPIO

#gpio setup
GPIO.setmode(GPIO.BCM) #sagt welcer gpio modus gebraucht wird

GPIO.setup(3, GPIO.OUT) #definirt gpio pin 3 als output

#loop
while True:
    GPIO.output(3, GPIO.HIGH) #setzt pin 3 auf HIGH also 3.3v
    time.sleep(1)            #wartet 1s
    GPIO.output(3, GPIO.LOW) #setzt pin 3 auf LOW also 0v
    time.sleep(1)            #wartet 1s