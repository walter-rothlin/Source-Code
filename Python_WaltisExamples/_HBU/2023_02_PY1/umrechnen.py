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
from waltiSuperLib import *

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

    answer = input('  Wähle:')
    if answer == '1':
        print('Grad in Bogenmass')  # rad  = grad*pi/180
        grad_value = input_float(min_value=0, max_value=360)
        rad_value = grad2rad(grad_value)
        print(rad_value)

    elif answer == '2':
        print('Bogenmass in Grad')   # grad = rad*180/pi
        rad_value = input_float('Rad:', 'ERROR!!!')
        grad_value = rad_value*180/pi
        print(grad_value)

    elif answer == '3':
        print('Fahrenheit in Celsius')
    elif answer == '0':
        print('Tschuess!!!!')
        doLoop = False