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
sleep(1)
sense.set_pixel(0, 0, red)
sleep(1)
sense.set_pixel(0, 7, green)
sleep(1)
sense.set_pixel(7, 7, blue)
sleep(1)
sense.set_pixel(7, 0, yellow)
top_left_pixel = sense.get_pixel(0, 0)
print(top_left_pixel)

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
sense.show_message("One small step for Pi!", text_colour=red, back_colour=grey, scroll_speed=0.05)