#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: snake.py
#
# Description: Mit dem Joy-Stick kann ein Punkt auf allen Achsen 
#              bewegt werden.
#
# Autor: Walter Rothlin
#
# History:  
# 17-Apr-2018	Walter Rothlin		Initial Version
# ------------------------------------------------------------------

from sense_hat import *
from time      import sleep
from signal    import pause
from support   import *
import math

x = 3
y = 3
sense = SenseHat()

def clamp(value, min_value = 0, max_value = 7):
    return min(max_value, max(min_value, value))

def pushed_up(event):
    global y
    if event.action != ACTION_RELEASED:
        y = clamp(y - 1)

def pushed_down(event):
    global y
    if event.action != ACTION_RELEASED:
        y = clamp(y + 1)

def pushed_left(event):
    global x
    if event.action != ACTION_RELEASED:
        x = clamp(x - 1)

def pushed_right(event):
    global x
    if event.action != ACTION_RELEASED:
        x = clamp(x + 1)

def refresh():
    sense.clear()
    sense.set_pixel(x, y, 255, 255, 255)

sense.stick.direction_up = pushed_up
sense.stick.direction_down = pushed_down
sense.stick.direction_left = pushed_left
sense.stick.direction_right = pushed_right
sense.stick.direction_any = refresh
refresh()
pause()





	


