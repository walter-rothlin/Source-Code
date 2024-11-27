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
# 08-Dec-2023   Walter Rothlin      draw_line() implemented (extends)
# 23-Dec-2023   Walter Rothlin      Test_Framework implemented
# ------------------------------------------------------------------

from sense_hat import SenseHat
from time import sleep

class MySenseHat(SenseHat):
    """
    A subclass from SenseHat where set_pixel has been overwritten and draw_line() added.
    """
    red      = (255,   0,   0)
    green    = (0,   255,   0)
    blue     = (0,     0, 255)
    yellow   = (255, 255,   0)
    mangenta = (255,   0, 255)
    cyan     = (0,   255, 255)
    white    = (255, 255, 255)
    grey     = (100, 100, 100)
    black    = (0,     0,   0)

    # Initializer and setter/Getter and Properties
    # ============================================
    def __init__(self, background_color=cyan, forground_color=red, trace_on=False):
        self.__fg_color = forground_color
        self.__bg_color = background_color
        self.__debug = trace_on
        # print('__init__():', trace_on, self.__debug)
        # super().clear(r=255, g=0, b=255)
        super().__init__()


    def set_debug_mode(self, trace_on=None):
        if trace_on is not None:
            self.__debug = trace_on
            # print(f'set_debug_mode({trace_on}) ==> {self.__debug}')
        # else:
            # self.__debug = False
            # print(f'set_debug_mode({trace_on}) ==> {self.__debug}')

    def get_debug_mode(self):
        return self.__debug

    debug_mode = property(get_debug_mode, set_debug_mode)



    # Business Methods
    # ================
    def set_pixel(self, x, y, r=255, g=0, b=0, pixel_color=None):
        if self.debug_mode:
            print(f'set_pixel(self, x={x}, y={y}, r={r}, g={g}, b={b}, pixel_color={pixel_color})')

        if pixel_color is not None:
            r = int(pixel_color[0])
            g = int(pixel_color[1])
            b = int(pixel_color[2])

        if isinstance(x, int):
            pass
        elif isinstance(x, float):
            x = round(x)
        elif isinstance(x, str):
            try:
                x = round(float(x))
            except ValueError:
                if self.debug_mode:
                    print('ERROR: set_pixel(x=', x, ', y=', y, ') Coordinates can be converted!', sep='')
                x = -1
        else:
            x = -1

        if isinstance(y, int):
            pass
        elif isinstance(y, float):
            y = round(y)
        elif isinstance(y, str):
            try:
                y = round(float(y))
            except ValueError:
                if self.debug_mode:
                    print('ERROR: set_pixel(x=', x, ', y=', y, ') Coordinates can be converted!', sep='')
                y = -1
        else:
            y = -1


        if (0 <= x <= 7) and (0 <= y <= 7):
            if self.debug_mode:
                print(f'set_pixel(self, x={x}, y={y}, r={r}, g={g}, b={b}, pixel_color={pixel_color})')
            super().set_pixel(x, y, r, g, b)
        else:
            if self.debug_mode:
                print('WARNING: set_pixel(x=', x, ', y=', y, ') Coordinates out of range!', sep='')

        if self.debug_mode:
            print()

    def draw_line(self, x1=0, y1=0, x2=7, y2=7, r=255, g=255, b=255, draw_speed=0):
        if draw_speed is not None and draw_speed != '':
            draw_speed = float(draw_speed)
        else:
            draw_speed = 0

        if self.debug_mode:
            print(f'draw_line(self, x1={x1}, y1={y1}, x2={x2}, y2={y2}, r={r}, g={g}, b={b}, draw_speed={draw_speed})')

        if x1 == x2:
            if y1 > y2:
                temp = y1
                y1 = y2
                y2 = temp
            for y in range(round(y1), round(y2+1)):
                self.set_pixel(x1, y, r, g, b)
                sleep(draw_speed)
        else:
            if x1 > x2:
                temp = x1
                x1 = x2
                x2 = temp
                temp = y1
                y1 = y2
                y2 = temp
            a = (y1-y2)/(x1-x2)
            c = y1 - a*x1
            if (a > 1) or (a < -1):
                if y1 > y2:
                    temp = y1
                    y1 = y2
                    y2 = temp
                for y in range(round(y1), round(y2+1)):
                    x = (y - c)/a
                    self.set_pixel(x, y, r, g, b)
                    sleep(draw_speed)
            else:
                for x in range(round(x1), round(x2+1)):
                    y = a*x + c
                    self.set_pixel(x, y, r, g, b)
                    sleep(draw_speed)



if __name__ == '__main__':
    sense = MySenseHat()
    sense.clear()
    sense.set_pixel(0, 0, 255, 0, 0)
    sleep(3)
    sense.clear()

