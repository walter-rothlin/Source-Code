#!/usr/bin/python3

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
GPIO.setmode(GPIO.BCM)   #sagt welcer gpio modus gebraucht wird

GPIO.setup(2, GPIO.IN)   #definirt gpio pin 2 als input

GPIO.setup(3, GPIO.OUT)  #definirt gpio pin 3 als output

while True:
    if GPIO.input(2) == 0:
        GPIO.output(3, GPIO.LOW)   #setzt pin 3 auf HIGH also 3.3v
        time.sleep(1)              #wartet 1s
        GPIO.output(3, GPIO.HIGH)  #setzt pin 3 auf LOW also 0v
        time.sleep(1)              #wartet 1s
