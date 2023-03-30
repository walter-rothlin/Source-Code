#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : TI22_B_Umrechner.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2023/TI22_B_Umrechner.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 23-Mar-2023   Walter Rothlin      Initial Version
# 30-Mar-2023   Walter Rothlin      Added Loop, if and formulas
# ------------------------------------------------------------------
pi = 3.1415926

menu_str = """
  Umrechnungen
  ============
  1: Grad in Bogenmass
  2: Bogenmass in Grad

  3: Fahrenheit in Celsius
  4: Celsius in Fahrenheit

  0: Schluss
"""

do_loop = True
while do_loop:
    print(menu_str)
    wahl = input('Wähle:')
    if wahl == '1':     # rad  = grad*pi/180
        print('Grad to Rad')
        grad_value = float(input('Wieviel Grad:'))
        rad_value = grad_value * pi / 180
        print('Grad:{gr:1.0f}   -->  Rad:{ra:1.4f}'.format(gr=grad_value, ra=rad_value))

    elif wahl == '2':   # grad = rad*180/pi
        print('Rad to Grad')
        rad_value = float(input('Wieviel RAD:'))
        grad_value = rad_value * 180 / pi
        print('Rad:{ra:1.4f}   -->  Grad:{gr:1.0f}'.format(gr=grad_value, ra=rad_value))
    elif wahl == '3':
        print('Celsius to Fahrenheit')
    elif wahl == '4':
        print("Fahrenheit to Celsius")
    elif wahl == '0':
        do_loop = False
        print("Beenden")
    else:
        print('Bitte eine gültige Eingabe machen')

