#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : TI22_A_Umrechner.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/BZU/2023/TI22_A_Umrechner.py
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

do_loop = True
while do_loop:
    menu_str = """
      Umrechnungen
      ============
      1: Grad in Bogenmass
      2: Bogenmass in Grad
    
      3: Fahrenheit in Celsius
      4: Celsius in Fahrenheit
    
      0: Schluss
    """

    print('\033[2J')   # cls
    print('\033[H')    # home
    print(menu_str)
    wahl = input('   Wähle:')
    if wahl == '0':
        do_loop = False
    elif wahl == '1':      # rad  = grad*pi/180
        print("Grad in RAD!!!")
        grad_value = float(input('Grad:'))
        rad_value = grad_value*pi/180
        print('Grad:{grad:1.2f}    Rad:{rad:1.4f}'.format(grad=grad_value, rad=rad_value))

    elif wahl == '2':      # grad = rad*180/pi
        print("RAD in Grad!!!")
        rad_value = float(input('Rad:'))
        grad_value = rad_value*180/pi
        print('Rad:{rad:1.2f}    Grad:{grad:1.4f}'.format(grad=grad_value, rad=rad_value))
    elif wahl == '3':
        print("Fahrenheit in Celsius!")
    elif wahl == '4':
        print("Celsius in Fahrenheit!")
    else:
        print('Ungültige Eingabe!!!!')

print("Programm Ende!!!!")
