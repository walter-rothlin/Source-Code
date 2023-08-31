#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: umrechnungen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 28-Aug-2023   Walter Rothlin      Initial Version (Menu-Text)
#
# ------------------------------------------------------------------
from waltisMegaLib import *

# =============
# Hauptprogramm
# =============
doLoop = True
while doLoop:
    print('''
      Umrechnungen
      ============
      1: Grad in Bogenmass
      2: Bogenmass in Grad

      3: Fahrenheit in Celsius
      4: Celsius in Fahrenheit

      0: Schluss
    ''')

    answer = input('\n  Wähle:')

    if answer == '1':
        rad_value = grad2rad(input_float('Grad:'))
        # print(f'{grad_value:4.2f}° --> {rad_value:4.3f}rad')
    elif answer == '2':
        grad_value = rad2grad(input_float(max_tries=5, prompt='Rad:'))
    elif answer == '0':
        doLoop = False
        print('Tschüsss')
print(' und gute Nacht')
