#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : TI22_A_Umrechner.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2023/TI22_A_Umrechner.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 23-Mar-2023   Walter Rothlin      Initial Version
# 30-Mar-2023   Walter Rothlin      Added Loop, if and formulas
# 06-Apr-2023   Walter Rothlin      Functions and Function calls
# ------------------------------------------------------------------
from Lib_2023_B import *

# =============
# Hauptprogramm
# =============
do_loop = True
while do_loop:
    menu_str = """
      Umrechnungen
      ============
      1: Grad in Bogenmass        rad  = grad*pi/180
      2: Bogenmass in Grad        grad = rad*180/pi

      3: Fahrenheit in Celsius    32F -> 0°C    100F -> 37.78°C     °C = (°F - 32) / 1.8
      4: Celsius in Fahrenheit    32F -> 0°C    100F -> 37.78°C     °F = (°C * 1.8) + 32

      0: Schluss
    """

    print('\033[2J')  # cls
    print('\033[H')  # home
    print(menu_str)
    wahl = input('   Wähle:')
    if wahl == '0':
        do_loop = False

    elif wahl == '1':  # rad  = grad*pi/180
        print("Grad in RAD!!!")
        grad_value = read_float('Grad:', min_value=0, max_value=360, err_msg_not_a_float='Kein gültiger Float!')
        rad_value = grad_in_rad(grad_value)
        print('Grad:{grad:1.2f}    Rad:{rad:1.4f}'.format(grad=grad_value, rad=rad_value))

    elif wahl == '2':  # grad = rad*180/pi
        print("RAD in Grad!!!")
        rad_value = read_float('Rad:')
        grad_value = rad_in_grad(rad_value)
        print('Rad:{rad:1.4f}    Grad:{grad:1.2f}'.format(grad=grad_value, rad=rad_value))

    elif wahl == '3':
        print("Fahrenheit in Celsius!")
        fahr_value = read_float('Fahrenheit:')
        cel_value = fahr_in_celsius(fahr_value)
        print('Fahrenheit:{far:1.2f}    Celsius:{cel:1.4f}'.format(far=fahr_value, cel=cel_value))

    elif wahl == '4':
        print("Celsius in Fahrenheit!")
        cel_value = read_float('Celsius:')
        fahr_value = celsius_in_fahr(cel_value)
        print('Celsius:{cel:1.2f}    Fahrenheit:{far:1.4f}'.format(cel=cel_value, far=fahr_value))

    else:
        print('Ungültige Eingabe!!!!')

print("Programm Ende!!!!")
