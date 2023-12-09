#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Class_SenseHat.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Class_SenseHat.py
#
# Description: Sub-Class of SenseHat
#
# Autor: Walter Rothlin
#
# History:
# 01-Dec-2023   Walter Rothlin      Initial Version
# 04-Dec-2023   Walter Rothlin      set_pixel overwritten
#
# ------------------------------------------------------------------

from sense_hat import SenseHat
from time import sleep

class MySenseHat(SenseHat):
    red      = (255,   0,   0)
    green    = (0,   255,   0)
    blue     = (0,     0, 255)
    yellow   = (255, 255,   0)
    mangenta = (255,   0, 255)
    cyan     = (0,   255, 255)
    white    = (255, 255, 255)
    grey     = (100, 100, 100)
    black    = (0,     0,   0)

    def __init__(self, background_color=cyan, forground_color=red, debug=False):
        self.__fg_color = forground_color
        self.__bg_color = background_color
        self.__debug = debug
        # super().clear(r=255, g=0, b=255)
        super().__init__()

    def set_pixel(self, x, y, pixel_color=None, r=255, g=0, b=0):
        if self.__debug:
            print('Info: set_pixel(x=', x, ', y=', y, ', pixel_color=', pixel_color, ', r=', r, ' g=', g, ', b=', b, ')', sep='')
        if pixel_color is not None:
            r = int(pixel_color[0])
            g = int(pixel_color[1])
            b = int(pixel_color[2])

        if  (0 <= x <= 7) and (0 <= y <= 7):
            super().set_pixel(x, y, r, g, b)
        else:
            if self.__debug:
                print('WARNING: set_pixel(x=', x, ', y=', y, ') Coordinates out of range!', sep='')


if __name__ == '__main__':
    sense = MySenseHat(debug=True)
    
    sense.clear()
    sense.set_pixel(0, 0, pixel_color=(255, 0, 0))
    sense.set_pixel(0, 8, r=255, g=0,   b=255)
    sense.set_pixel(7, 0, r=255, g=255, b=0)
    
    
