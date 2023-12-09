#!/usr/bin/python3

#==================
# Autohr: Dylan Egger
#
# versionen
# 1.0.0  5.12.2023  dylan eggger  initial version
#=========

# import
import RPi.GPIO as GPIO

#gpio setup
GPIO.setmode(GPIO.BCM) #sagt welcer gpio modus gebraucht wird

GPIO.setup(2, GPIO.IN) #definirt gpio pin 2 als input

#loop
while True:
    print(GPIO.input(2)) # druckt den aktuellen Wert auf pin 2 ins terminal