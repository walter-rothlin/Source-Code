#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Umrechner_02.py
#
# Description: Rechnet physikalische Grössen in andere Einheiten um
#
# Autor: Walter Rothlin
#
# History:
# 01-Feb-2024   Walter Rothlin      Initial Version
# 08-Feb-2024   Walter Rothlin      Implemented all formulas, Refactoring
# ------------------------------------------------------------------
import math


# ====================
# Variables
# ====================
half_circle = 180
pi = math.pi

menu_text = '''
  Umrechnungen
  ============
  1: Grad in Bogenmass
  2: Bogenmass in Grad

  3: Fahrenheit in Celsius
  4: Celsius in Fahrenheit

  0: Schluss
'''

# ====================
# Functions
# ====================
def read_float(prompt):
    error = True
    while error:
        try:
            input_str = input(prompt)
            input_float = float(input_str)
            error = False
        except ValueError:
            print('Bitte gib einen gültigen Float ein :-) ')
            error = True

    return input_float
def degree_to_radians(grad_v):
    rad_v = grad_v * pi / half_circle
    return rad_v

# ====================
# main
# ====================
if __name__ == '__main__':
    do_loop = True
    while do_loop:
        print(menu_text)
        choice = input('Wähle (0, 1..4):')
        if choice == '1':
            print('Grad in Bogenmass')     # rad  = grad*pi/180
            grad_value = read_float('Grad:')
            rad_value = degree_to_radians(grad_value)
            print(f'{grad_value}°  --> {rad_value:0.3f}rad')
            input('Weiter?')

        elif choice == '2':
            print('Bogenmass in Grad')
            rad_value = read_float('Rad:')  # grad = rad*180/pi
            grad_value = rad_value * half_circle / pi
            print(f'{rad_value} rad --> {grad_value:0.2f}°')
            input('Weiter?')

        elif choice == '3':
            print('Fahrenheit in Celsius')
        elif choice == '4':
            print('Celsius in Fahrenheit')
        elif choice == '0':
            do_loop = False
            print('Schluss')
        else:
            print('Falsche Eingabe')

