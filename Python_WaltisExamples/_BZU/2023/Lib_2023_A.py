# ------------------------------------------------------------------
# Name  : Lib_2023_A.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2023/Lib_2023_A.py
#
# Description: Library für die TI22-BLe/M
#
# Autor: Walter Rothlin
#
# History:
# 20-Apr-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import re

# Constants
pi = 3.1415926
halbbogen = 180
null_celsius = 32
celsius_fahrenheit_factor = 1.8


# regEx
regex_float = r'[+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?'

# Functions
# ==========

# pre check
def read_float_pre_condition(prompt, min_value=None, max_value=None,
               err_too_small    ='ERROR: Wert zu klein!!!!',
               err_too_big      ='ERROR: Wert zu gross!!!!',
               err_not_a_figure ='ERROR: Ungültige Eingabe (Kein Float!!!!)'):
    has_error = True
    while has_error:
        float_str = input(prompt)

        # pre condition check
        if re.fullmatch(regex_float, float_str):
            float_value = float(float_str)
            if min_value is not None and float_value < min_value:
                print(err_too_small)
            elif max_value is not None and float_value > max_value:
                print(err_too_big)
            else:
                has_error = False
        else:
            print(err_not_a_figure)
    return float_value

# exception handling
def read_float(prompt, min_value=None, max_value=None,
               err_too_small    ='ERROR: Wert zu klein!!!!',
               err_too_big      ='ERROR: Wert zu gross!!!!',
               err_not_a_figure ='ERROR: Ungültige Eingabe (Kein Float!!!!)'):
    has_error = True
    while has_error:
        try:
            float_value = float(input(prompt))
            if min_value is not None and float_value < min_value:
                print(err_too_small)
            elif max_value is not None and float_value > max_value:
                print(err_too_big)
            else:
                has_error = False
        except ValueError:
            print(err_not_a_figure)
    return float_value

def grad_in_rad(grad_value):
    return grad_value*pi/halbbogen

def rad_in_grad(rad_value):
    return rad_value*halbbogen/pi

def fahr_in_celsius(fahr_value):
    return (fahr_value - null_celsius) / celsius_fahrenheit_factor

def celsius_in_fahr(celsius_value):
    return (cel_value*celsius_fahrenheit_factor) + null_celsius
