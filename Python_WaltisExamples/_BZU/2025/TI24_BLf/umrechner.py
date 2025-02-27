#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 13-Feb-2025   Walter Rothlin      Initial Version (Menu-Text)
#
# ------------------------------------------------------------------

menu_text = f'''
  Umrechnungen
  ============
  1: Grad in Bogenmass
  2: Bogenmass in Grad

  3: Fahrenheit in Celsius
  4: Celsius in Fahrenheit

  0: Schluss
'''

pi = 3.1415926

do_loop = True
while do_loop:
    print(menu_text)
    auswahl = input('Wähle:')
    if auswahl == '1':
        print('Grad in Bogenmass')
        grad = float(input('Grad:'))
        rad = grad * pi / 180
        print(f'{grad:0.2f} Grad sind {rad:0.2f} rad')

    elif auswahl == '2':
        print('Bogenmass in Grad')
        rad = float(input('rad:'))
        grad = rad * 180 / pi
        print(f'{rad:0.2f} rad sind {grad:0.2f} Grad')

    elif auswahl == '3':
        print('Fahrenheit in Celsius')
        fahrenheit = float(input('Fahrenheit:'))
        celsius = (fahrenheit - 32) / 1.8
        print(f'{fahrenheit:0.2f} Fahrenheit sind {celsius:0.2f} Celsius')

    elif auswahl == '4':
        print('Celsius in Fahrenheit')
        celsius = float(input('Celsius:'))
        fahrenheit = (celsius * 1.8) + 32
        print(f'{celsius:0.2f} Celsius sind {fahrenheit:0.2f} Fahrenheit')

    elif auswahl == '0':
        do_loop = False
        print('Schluss')
    else:
        print('Unbekannte Auswahl')


