#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : MyLibrary.py
#
# Description: Meine persönliche Library
#
# Autor: Walter Rothlin
#
# History:
# 06-Jun-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import math

# ==============
# Constant
# ==============
pi = math.pi
halbbogen = 180
fahr2Grad_a = 1.8
fahr2Grad_c = 32

# ==============
# Functions
# ==============
def halt(promt='Weiter?'):
    input(promt)


def read_number(promt, data_type='Float', min=None, max=None):
    error = True
    while error:
        try:
            in_str = input(promt)
            if data_type == 'Float':
                ret_val = float(in_str)
            elif data_type == 'Int':
                ret_val = int(in_str)
            else:
                print('WARNING: unknown data type')
            error = False

            if min is not None and ret_val < min:
                print(f'WARNING: {ret_val} ist kleiner als {min}')
                error = True

            if max is not None and ret_val > max:
                print(f'WARNING: {ret_val} ist grösser als {max}')
                error = True
        except Exception:
            error = True
            print(f'ERROR: {in_str} ist kein {data_type}!')

    return ret_val


def read_float(promt, min=None):
    return read_number(promt, data_type='Float', min=min)


def read_int(promt, min=None):
    return read_number(promt, data_type='Int', min=min)

def grad_to_rad(g_value):
    rad_value = g_value*pi/halbbogen
    return rad_value

def rad_to_grad(r_value):
    rad_value = r_value*halbbogen/pi
    return rad_value