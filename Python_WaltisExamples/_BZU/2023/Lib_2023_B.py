#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Lib_2023_B.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2023/Lib_2023_B.py
#
# Description: Python Library
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

default_err_msg_not_a_float = 'Not a valid float!!'
default_err_msg_too_small   = 'Value too small!'
default_err_msg_too_large   = 'Value too large!'

regEx_Float = r'[+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?'


# Functions
def grad_in_rad(grad_value):
    return grad_value * pi / halbbogen


def rad_in_grad(rad_value):
    return rad_value * halbbogen / pi


def fahr_in_celsius(fahr_value):
    return (fahr_value - null_celsius) / celsius_fahrenheit_factor


def celsius_in_fahr(celsius_value):
    return (celsius_value * celsius_fahrenheit_factor) + null_celsius

def read_float_pre_condition(prompt, min_value=None, max_value=None,
               err_msg_not_a_float  = default_err_msg_not_a_float,
               err_msg_too_small    = default_err_msg_too_small,
               err_msg_too_large    = default_err_msg_too_large):

    has_error = True
    while has_error:
        float_str = input(prompt)
        if re.fullmatch(regEx_Float, float_str):
            float_value = float(float_str)
            if min_value is not None and float_value < min_value:
                print(err_msg_too_small)
            elif max_value is not None and float_value > max_value:
                print(err_msg_too_large)
            else:
                has_error = False
        else:
            print(err_msg_not_a_float)

    return float_value


# exception handling
def read_float(prompt, min_value=None, max_value=None,
               err_msg_not_a_float  = default_err_msg_not_a_float,
               err_msg_too_small    = default_err_msg_too_small,
               err_msg_too_large    = default_err_msg_too_large):

    has_error = True
    while has_error:
        try:
            float_str = input(prompt)
            float_value = float(float_str)
            if min_value is not None and float_value < min_value:
                print(err_msg_too_small)
            elif max_value is not None and float_value > max_value:
                print(err_msg_too_large)
            else:
                has_error = False
        except ValueError:
            print(err_msg_not_a_float)

    return float_value