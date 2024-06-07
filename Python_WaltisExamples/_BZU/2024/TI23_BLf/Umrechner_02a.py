#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Umrechner_02a.py
#
# Description: Rechnet physikalische Grössen in andere Einheiten um
#
# Autor: Walter Rothlin
#
# History:
# 01-Feb-2024   Walter Rothlin      Initial Version
# 08-Feb-2024   Walter Rothlin      Implemented all formulas, Refactoring
# ------------------------------------------------------------------
from MyLibrary import *

menu_text = '''





  Umrechnungen
  ============
  1: Grad in Bogenmass
  2: Bogenmass in Grad

  3: Fahrenheit in Celsius
  4: Celsius in Fahrenheit

  0: Schluss
'''


# =================
# main
# =================
if __name__ == '__main__':
    do_loop = True
    while do_loop:
        print(menu_text)
        answer = read_int('Bitte wähle (0..4):', min=0)
        if answer == 1:
            print('Grad in Bogenmass')         # rad  = grad*pi/180
            grad_value = read_float('Grad:')
            rad_value = grad_to_rad(grad_value)

            print(f'{grad_value}° --> {rad_value:0.2f} rad')
            halt('Weiter?')

        elif answer == 2:
            print('Bogenmass in Grad')
            rad_value =read_float('Rad:')   # grad = rad*180/pi
            grad_value = rad_to_grad(rad_value)
            print(f'{rad_value} rad --> {grad_value:0.2f}°')
            halt('Weiter?')

        elif answer == 3:
            print('Fahrenheit in Celsius')
            fahr_value = read_float('Fahrenheit:')   # 32F -> 0°C    100F -> 37.78°C     °C = (°F - 32) / 1.8
            grad_value = (fahr_value - fahr2Grad_c)/fahr2Grad_a
            print(f'{fahr_value}Fahrenheit --> {grad_value:0.2f}°')
            halt('Weiter?')

        elif answer == 4:
            print('Celsius in Fahrenheit')
            grad_value = read_float(')Grad:')
            fahr_value = (grad_value*fahr2Grad_a) + fahr2Grad_c  # 32F -> 0°C    100F -> 37.78°C     °F = (°C * 1.8) + 32
            print(f'{grad_value}° --> {fahr_value:0.2f} Fahrenheit')
            halt('Weiter?')

        elif answer == 0:
            print('Schluss')
            do_loop = False
        else:
            print('Unbekannte Auswahl!')

    print('Ende')


