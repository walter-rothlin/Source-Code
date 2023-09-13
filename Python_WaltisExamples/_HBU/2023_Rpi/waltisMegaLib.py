#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: waltisMegaLib.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/waltisMegaLib.py
#
# Description: Allgemeine Library
#
# Autor: Walter Rothlin
#
# History:
# 28-Aug-2023   Walter Rothlin      Initial Version
# 04-Sep-2023   Walter Rothlin      Pi von math
#                                   input_float mit min, max und Fehlermeldung als optionale Parameter
#                                   rad2grad mit Titel, outputformat als optionale Parameter
#                                   
# ------------------------------------------------------------------

import math
import re

pi = math.pi
regEx_Float_Or_Int = r'[+-]?\d*\.?\d+'


def input_float(prompt, max_tries=3, min_value=None, max_value=None):
    tries = 0
    error = True
    while error and tries < max_tries:
        value_str = input(prompt)
        if re.fullmatch(regEx_Float_Or_Int, value_str):
            value = float(value_str)
            error = False
            if min_value is not None and value < min_value:
                print('ERROR:', value, ' < ', min_value)
                error = True
            if max_value is not None and value > max_value:
                print('ERROR:', value, ' > ', max_value)
                error = True
        else:
            print('ERROR:', value_str,'is not a float or integer')
            tries += 1
            
    if tries >= max_tries:
        value = -1
    return value
    

def rad2grad(rad_value, trace=True):
    if trace:
        print('Bogenmass in Grad')
    grad_value = rad_value*180/math.pi   # grad = rad*180/pi
    if trace:
        print('{rVal:4.3f}rad ==> {gVal:4.2f}°'.format(rVal=rad_value, gVal=grad_value))
    return grad_value
    

def grad2rad(grad_value, trace=True):
    if trace:
        print('Grad in Bogenmass')
    rad_value = grad_value*math.pi/180   # rad  = grad*pi/180
    if trace:
        print('{gVal:4.2f}° --> {rVal:4.3f}rad'.format(rVal=rad_value, gVal=grad_value))
    return rad_value
