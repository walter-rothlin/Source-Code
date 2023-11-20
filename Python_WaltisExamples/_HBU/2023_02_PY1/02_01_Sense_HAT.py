#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 02_01_Sense_HAT.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_PY1/02_01_Sense_HAT.py
#
# Description: Sense-HAT LED Ops
#
# Autor: Walter Rothlin
#
# History:
# 13-Sep-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from sense_hat import SenseHat
from time import sleep


red      = (255,   0,   0)
green    = (  0, 255,   0)
blue     = (  0,   0, 255)
yellow   = (255, 255,   0)
mangenta = (255,   0, 255)
cyan     = (  0, 255, 255)
white    = (255, 255, 255)
black    = (  0,   0,   0)
grey     = ( 50,  50,  50)

regenbogen=[black, blue, cyan, green, mangenta, yellow, white, grey]


sense = SenseHat()

'''
sense.clear()  # no arguments defaults to off
sleep(1)
sense.set_pixel(0, 0, red)
sleep(1)
sense.set_pixel(0, 7, green)
sleep(1)
sense.set_pixel(7, 7, blue)
sleep(1)
sense.set_pixel(7, 0, yellow)
sleep(1)
sense.set_pixel(1, 0, mangenta)
sense.set_pixel(2, 0, cyan)
sense.set_pixel(3, 0, white)
sleep(1)
sense.set_pixel(3, 0, black)
sleep(1)


sense.clear()
X = red
O = grey

question_mark = [
O, O, O, X, X, O, O, O,
O, O, X, O, O, X, O, O,
O, O, O, O, O, X, O, O,
O, O, O, O, X, O, O, O,
O, O, O, X, O, O, O, O,
O, O, O, X, O, O, O, O,
O, O, O, O, O, O, O, O,
O, O, O, X, O, O, O, O
]

sense.set_pixels(question_mark)
sleep(1)

sense.show_message("One small step for Pi!", text_colour=red, scroll_speed=0.05)
'''

sense.clear()  # no arguments defaults to off
for x in range(8):

    y = x
    farbe=x
    sense.set_pixel(x, 7-y, regenbogen[farbe])
    sleep(0.1)
    

for x in range(0, -8, -2):
    print(x)

sense.set_pixel(0, 8, regenbogen[1])