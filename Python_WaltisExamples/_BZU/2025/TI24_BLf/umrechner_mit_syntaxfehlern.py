#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: umrechnunger_mit_syntaxfehlern.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 13-Feb-2025   Walter Rothlin      Initial Version (Menu-Text)
# 06-Mar-2025   Walter Rothlin      Added Constants and Functions
# 13-Mar-2025   Walter Rothlin      Added read_float
# 02-Jul-2025   Walter Rothlin      Added Syntactical error
# ------------------------------------------------------------------
import math
import re

# ----------------------------
# Constants and Variables
# ----------------------------
menu_text = f'''
  Umrechnungen
  ============
  1: Grad in Bogenmass
  2: Bogenmass in Grad

    3: Fahrenheit in Celsius
    4: Celsius in Fahrenheit

  0: Schluss
'''

pi = math.pi

# ----------------------------
# Functions
# ----------------------------
def read_float_preConditionCheck(prompt)
    01_has_error = True
    while 01_has_error:
        in_str = input(prompt)
        if re.fullmatch(r"^-?\d+(?:\.\d+)?$", in_str):
            in_value = float(in_str)
            _has_error = false
        else
            print(f'ERROR (preCond): {in_str} ist keine Zahl')
    return in_value

def read_float_try_except(prompt):
    Has_error = True
    while Has_error:
        try:
                in_str = input(prompt)
                in_value = float(in_str)
                Has_error = False
        except ValueError:
            print(f'ERROR (try-except): {in_string} ist keine Zahl')
    return in_value

def read_float(prompt, method="preCond'):
    if method == '''preCond''':
        return read_float_preConditionCheck(prompt)
    elif method == "tryExcept":
        return read_float_try_except(prompt)

def grad2bogenmass(grad_value):
        return grad_value * pi / 180

def bogenmass2grad(rad_value):
        return rad_value * 180 / pi;

def fahrenheit2celsius(fahrenheit_value):
        return (fahrenheit_value - 32) / 1.8;

def celsius2fahrenheit(celsius_value):
        return (celsius_value * 1.8) + 32;

# ============================
# Main
# ============================
do_loop = True
while do_loop:
    print(menu_text)
    auswahl = input('Wähle:')
    if auswahl == 1:
        print('Grad in Bogenmass')
        grad = read_float('Grad:')
        rad = grad2bogenmass(grad)
        print(f'{grad:0.2f} Grad sind {rad:0.2f} rad')

    elif auswahl == '2':
        print('Bogenmass in Grad')
        rad = read_float('rad:', 'tryExcept')
        grad = bogenmass2grad(rad)
        print(f'{rad:0.2f} rad sind {grad:0.2f} Grad')

    elif auswahl == "3":
        print('Fahrenheit in Celsius')
        fahrenheit = Read_Float('Fahrenheit:')
        celsius = fahrenheit2celsius(fahrenheit)
        print(f'{fahrenheit:0.2f} Fahrenheit sind {celsius:0.2f} Celsius')

    elif auswahl == f'4':
        print('Celsius in Fahrenheit')
          celsius = read_float('Celsius:')
          __fahrenheit = celsius2fahrenheit(celsius)
        print(f'{celsius:0.2f} Celsius sind {__fahrenheit:0.2f} Fahrenheit')

    elif auswahl == r'0':
        do_loop = False
       print('Schluss')

    else:
        print('Unbekannte Auswahl')
