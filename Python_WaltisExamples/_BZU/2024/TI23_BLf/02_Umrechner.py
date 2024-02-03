#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 02_Umrechner.py
#
# Description: Rechnet physikalische Grössen in andere Einheiten um
#
# Autor: Walter Rothlin
#
# History:
# 01-Feb-2024   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
menu_text = '''





  Umrechnungen
  ============
  1: Grad in Bogenmass
  2: Bogenmass in Grad

  3: Fahrenheit in Celsius
  4: Celsius in Fahrenheit

  0: Schluss
'''

do_loop = True
while do_loop:
    print(menu_text)
    antwort = input('Bitte wähle (0..4):')
    if antwort == '1':
        print('Grad in Bogenmass')   # rad  = grad*pi/180
        grad_value = float(input('Grad:'))
        rad_value = grad_value*3.1415926/180
        print(f'{grad_value}° --> {rad_value}rad')
        input('Weiter?')
    elif antwort == '2':
        print('Bogenmass in Grad')

        input('Weiter?')
    elif antwort == '3':
        print('Fahrenheit in Celsius')

        input('Weiter?')
    elif antwort == '4':
        print('Celsius in Fahrenheit')

        input('Weiter?')
    elif antwort == '0':
        print('Schluss')
        do_loop = False
    else:
        print('Ungültige Eingabe! Nochmals versuchen')
print('Ende')


