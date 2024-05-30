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
def read_number(prompt, data_type='Float', min=None, max=None):
    error = True
    while error:
        try:
            input_str = input(prompt)
            if data_type == 'Float':
                input_number = float(input_str)
            elif data_type == 'Int':
                input_number = int(input_str)
            else:
                print(f'ERROR: Data-Type {data_type} is unknown')
                error = True
            error = False

            if min is not None and input_number < min:
                print(f'WARNING:{input_number} ist kleiner als {min}')
                error = True
            elif max is not None and input_number > max:
                print(f'WARNING:{input_number} ist grösser als {max}')
                error = True
        except ValueError:
            print(f'WARNUNG: Bitte gib einen gültigen {data_type} ein :-) ')
            error = True

    return input_number

def read_float(prompt, min=None, max=None):
    return read_number(prompt, data_type='Float', min=min, max=max)

def read_int(prompt, min=None, max=None):
    return read_number(prompt, data_type='Int', min=min, max=max)

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
        choice = read_int('Wähle (0, 1..4):', min=0, max=4)
        if choice == 1:
            print('Grad in Bogenmass')     # rad  = grad*pi/180
            grad_value = read_float('Grad:')
            rad_value = degree_to_radians(grad_value)
            print(f'{grad_value}°  --> {rad_value:0.3f}rad')
            input('Weiter?')

        elif choice == 2:
            print('Bogenmass in Grad')
            rad_value = read_float('Rad:')  # grad = rad*180/pi
            grad_value = rad_value * half_circle / pi
            print(f'{rad_value} rad --> {grad_value:0.2f}°')
            input('Weiter?')

        elif choice == 3:
            print('Fahrenheit in Celsius')
        elif choice == 4:
            print('Celsius in Fahrenheit')
        elif choice == 0:
            do_loop = False
            print('Schluss')
        else:
            print('Falsche Eingabe')

