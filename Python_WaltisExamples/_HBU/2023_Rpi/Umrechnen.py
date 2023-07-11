#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Umrechnungen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/Umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 10-Jul-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from E21_lib import *

nachkommastellen = 2

menu_text = '''
Umrechnungen (V5.0)
===================
1: Grad in Bogenmass
2: Bogenmass in Grad

3: Fahrenheit in Celsius
4: Celsius in Fahrenheit

0: Schluss'''


# ==== #
# MAIN #
# ==== #
do_loop = True
while do_loop:
    cls()
    print(menu_text)
    auswahl = input('\n   Wähle:')
    cls()
    if auswahl == '1':
        print('Grad in Bogenmass (rad  = grad*pi/180)')
        grad_value = input_float()
        rad_value = grad_to_rad(grad_value)
        # print('{gVal:0.2f}° --> {rVal:0.2f} rad'.format(rVal=rad_value, gVal=grad_value))
        print(f'{grad_value:0.2f}° --> {rad_value:0.2f} rad')
        halt()
    elif auswahl == '2':
        print('Bogenmass in Grad')
        rad_value = input_float(prompt='Rad:', min_value=0, max_value=2*pi)
        grad_value = rad_to_grad(rad_value)
        print(f'{rad_value:0.2f} rad  --> {grad_value:0.2f}°')

    elif auswahl == '0':
        do_loop = False
    else:
        print('WARNING: Ungültige Auswahl!')

print('Tschüss')
