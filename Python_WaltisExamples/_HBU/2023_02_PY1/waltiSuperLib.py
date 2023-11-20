#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: waltisMegaLib.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_PY1/umrechnen.py
#
# Description: Allgemeine Library
#
# Autor: Walter Rothlin
#
# History:
# 30-Aug-2023   Walter Rothlin      Initial Version
# 06-Sep-2023   Walter Rothlin      input_float mit min, max und Fehlermeldung als optionale Parameter
#                                   rad2grad mit Titel, outputformat als optionale Parameter
#                                   input_float mit exception handling
# ------------------------------------------------------------------
import re
import math 

# Constanten Definitionen
pi=math.pi
regEx_Float_Or_Int = r'[+-]?\d*\.?\d+'



# Input-Functions
# ---------------
def input_float(
           prompt    = 'Grad:', 
           error_msg = 'Bitte Zahl eingeben!',
           min_value=None,
           max_value=None):
           
    error = True
    while error:
        value_str = input(prompt)
        if re.fullmatch(regEx_Float_Or_Int, value_str):
            a_value = float(value_str)
            error = False
            if min_value is not None and a_value < min_value:
                print('ERROR:', a_value, '<', min_value,'!!')
                error = True
            if max_value is not None and a_value > max_value:
                print('ERROR:', a_value, '>', max_value,'!!')
                error = True

        else:
            print(error_msg)
    return a_value

# Physikalische Umrechnungen
# --------------------------
def grad2rad(grad_value):
    return grad_value*pi/180