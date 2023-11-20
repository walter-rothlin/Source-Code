#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 02_01_Sense_HAT.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/02_01_Sense_HAT.py
#
# Description: Beispiele mit dem Sense-HAT API
#
# Autor: Walter Rothlin
#
# History:
# 11-Sep-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
from sense_hat import SenseHat
from time import sleep


white = (255,255,255)
red = (255,0,0)
green = (0,255,0)
blue = (0,0,255)
yellow = (255,255,0)
cyan = (0, 255,255)
mangenta = (255,0,255)
black = (0,0,0)
grey = (50, 50, 50)


sense = SenseHat()

sense.clear(grey)
for x in range(9):
    y = x
    print(x, y)
    sense.set_pixel(x, y, red)
    sleep(1)