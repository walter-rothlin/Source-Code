#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: ppythonBasics_05f_Menu_UmrechnungenPrimzahlen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_05f_Menu_UmrechnungenPrimzahlen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 24-Oct-2017   Walter Rothlin      Initial Version
# 11-Apr-2024   Walter Rothlin      Added Fakultät, Primzahlenrechner
#
# ------------------------------------------------------------------
from waltisLibrary import *

menu_items = [
    'Schluss',
    'Grad in Bogenmass',
    'Bogenmass in Grad',
    'Fahrenheit in Celsius',
    'Celsius in Fahrenheit',
    'Fakultät',
    'Primzahlen (tba)'
]

menu_text = f'''
  Umrechnungen
  ============
  1: {menu_items[1]}
  2: {menu_items[2]}

  3: {menu_items[3]}
  4: {menu_items[4]}

  5: {menu_items[5]}
  
  0: {menu_items[0]}
'''

formeln = '''
    rad  = grad*pi/180
    grad = rad*180/pi
    32F -> 0°C    100F -> 37.78°C     °C = (°F - 32) / 1.8
    32F -> 0°C    100F -> 37.78°C     °F = (°C * 1.8) + 32
'''

def menu():
    print(menu_text)
    return input("\n  Wähle:")


# =============
# Hauptprogramm
# =============
doLoop = True
# print(isPrimzahl.__doc__)  # docstring similar to java doc
while doLoop:
    VT52_cls_home()
    antwort = menu()

    if antwort == "1":
        VT52_cls_home()
        print("Grad --> Bogenmass")
        gradValue = readFloat("Grad:")
        print(f"Grad={gradValue:1.2f}  ==> Rad={grad2Rad(gradValue):1.2f}")
        halt()

    elif antwort == "2":
        VT52_cls_home()
        print("Bogenmass --> Grad")
        radValue = readFloat(prompt="Rad:")
        print("Rad={rad:1.2f}  ==> Grad={grad:1.2f}".format(rad=radValue, grad=rad2Grad(radValue)))
        halt()

    elif antwort == "3":
        VT52_cls_home()   # http://www.metric-conversions.org/de/temperatur/fahrenheit-in-celsius.htm
        print("Fahrenheit in Celsius")
        fahrenheitValue = readFloat(prompt="Fahrenheit:")
        print("Fahrenheit={fahrenheit:1.2f}  ==> Celsius={celsius:1.2f}".format(fahrenheit=fahrenheitValue ,celsius=fahrenheit2Celsius(fahrenheitValue)))
        halt()

    elif antwort == "4":
        VT52_cls_home()   # http://www.metric-conversions.org/de/temperatur/celsius-in-fahrenheit.htm
        print("Celsius in Fahrenheit")
        celsiusValue = readFloat(prompt="Celsius:")
        print("Celsius={celsius:1.2f}  ==> Fahrenheit={fahrenheit:1.2f}".format(celsius=celsiusValue, fahrenheit=celsius2Fahrenheit(celsiusValue)))
        halt()

    elif antwort == "5":
        VT52_cls_home()
        print("Berechnet die Fakultät")
        upperLimit = readInt(prompt="Obergrenze:")
        lowerLimit = readInt(prompt="Untergrenze:")
        if lowerLimit <= 2:
            print(f"{upperLimit:5d}!  = {fakultaet(obergrenze=upperLimit, untergrenze=lowerLimit):7d}")
        else:
            print(f"{upperLimit:0d}! / {lowerLimit-1:0d}! = {fakultaet(obergrenze=upperLimit):0d} / {fakultaet(obergrenze=lowerLimit-1):0d} = {fakultaet(obergrenze=upperLimit, untergrenze=lowerLimit):0d}")
        halt()

    elif antwort == "0":
        doLoop = False

    else:
        print('Falsche Auswahl')

print("Ende....Done")
