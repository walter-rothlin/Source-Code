
#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 01-Feb-2025   Walter Rothlin      Initial Version (Menu-Text)
# 14-Feb-2025   Walter Rothlin      Added Constants and Functions
# ------------------------------------------------------------------

import re

# ----------------------------
# Constants
# ----------------------------
pi = 3.1415926

# ----------------------------
# Variables

menu_text = f'''
Umrechnungen
============
  1: Grad in Bogenmass   rad  = grad*pi/180
  2: Bogenmass in Grad   grad = rad*180/pi

  3: Fahrenheit in Celsius   32F -> 0°C    100F -> 37.778°C     °C = (°F - 32) / 1.8
  4: Celsius in Fahrenheit   32F -> 0°C    100F -> 37.778°C     °F = (°C * 1.8) - 32

  0: Schluss
'''

# ----------------------------
# Functions
# ----------------------------
def grad_in_bogenmass(grad_value):
    return grad_value * pi / 180

def bogenmass_in_grad(rad_value):
    return rad_value * 180 / pi

def fahrenheit_in_celsius(fahrenheit_value):
    return (fahrenheit_value - 32) / 1.8

def celsius_in_fahrenheit(celsius_value):
    return (celsius_value * 1.8) + 32

def read_float(prompt):
    error = True
    while error:
        in_str = input(prompt)
        if re.fullmatch(r"^-?\d+(?:\.\d+)?$", in_str):
            in_value = float(in_str)
            error = False
        else:
            print(f"Error: '{in_str}' is not a valid float")
            error = True
    return in_value

# ----------------------------
# Main:
# ----------------------------
do_loop = True
while do_loop:
    print(menu_text)

    auswahl = input('Wahl:')
    if auswahl == '1':
        print("Grad in Bogenmass")
        grad = read_float("Grad:")
        rad = grad_in_bogenmass(grad)
        print(f"{grad:0.2f} Grad sind {rad:0.2f} rad")

    elif auswahl == '2':
        print("Bogenmass in Grad")
        rad = read_float("rad:")
        grad = bogenmass_in_grad(rad)
        print(f"{rad:0.2f} rad sind {grad:0.2f} Grad")

    elif auswahl == '3':
        print("Fahrenheit in Celsius")
        fahrenheit = read_float("Fahrenheit:")
        celsius = fahrenheit_in_celsius(fahrenheit)
        print(f"{fahrenheit:0.2f} Fahrenheit sind {celsius:0.2f} Celsius")

    elif auswahl == '4':
        print("Celsius in Fahrenheit")
        celsius = read_float("Celsius:")
        fahrenheit = celsius_in_fahrenheit(celsius)
        print(f"{celsius:0.2f} Celsius sind {fahrenheit:0.2f} Fahrenheit")

    elif auswahl == '0':
        print("Schluss")
        do_loop = False
    else:
        print("Falsche Eingabe")
print("Tschüss")



