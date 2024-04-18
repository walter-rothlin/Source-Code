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
    {'nr': '1', 'menu_str': 'Grad --> Bogenmass', 'formel': 'rad  = grad*pi/180'},
    {'nr': '2', 'menu_str': 'Bogenmass --> Grad', 'formel': 'grad = rad*180/pi'},
    {'nr': ' ', 'menu_str': ''},
    {'nr': '3', 'menu_str': 'Fahrenheit in Celsius', 'formel': '32F -> 0°C    100F -> 37.78°C     °C = (°F - 32) / 1.8'},
    {'nr': '4', 'menu_str': 'Celsius in Fahrenheit', 'formel': '32F -> 0°C    100F -> 37.78°C     °F = (°C * 1.8) + 32'},
    {'nr': ' ', 'menu_str': ''},
    {'nr': '5', 'menu_str': 'Fakultät'},
    {'nr': '6', 'menu_str': 'Ist Primzahlen'},
    {'nr': '7', 'menu_str': 'Get Primzahlen'},
    {'nr': '8', 'menu_str': 'Primzahlenzerlegung'},
    {'nr': '9', 'menu_str': 'Teilerliste'},
    {'nr': ' ', 'menu_str': ''},
    {'nr': '0', 'menu_str': 'Schluss'},
]

menu_text = getMenuStrFromList(menu_items, titel="Umrechnungen", unterstreichen="=")

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
        do_loop = True
        while do_loop:
            VT52_cls_home()
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel')+'\n')
            gradValue = readFloat("Grad:")
            print(f"Grad={gradValue:1.2f}  ==> Rad={grad2Rad(gradValue):1.2f}")
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "2":
        do_loop = True
        while do_loop:
            VT52_cls_home()
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel')+'\n')
            radValue = readFloat(prompt="Rad:")
            print("Rad={rad:1.2f}  ==> Grad={grad:1.2f}".format(rad=radValue, grad=rad2Grad(radValue)))
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "3":
        do_loop = True
        while do_loop:
            VT52_cls_home()   # http://www.metric-conversions.org/de/temperatur/fahrenheit-in-celsius.htm
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel')+'\n')
            fahrenheitValue = readFloat(prompt="Fahrenheit:")
            print("Fahrenheit={fahrenheit:1.2f}  ==> Celsius={celsius:1.2f}".format(fahrenheit=fahrenheitValue ,celsius=fahrenheit2Celsius(fahrenheitValue)))
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "4":
        do_loop = True
        while do_loop:
            VT52_cls_home()   # http://www.metric-conversions.org/de/temperatur/celsius-in-fahrenheit.htm
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel')+'\n')
            celsiusValue = readFloat(prompt="Celsius:")
            print("Celsius={celsius:1.2f}  ==> Fahrenheit={fahrenheit:1.2f}".format(celsius=celsiusValue, fahrenheit=celsius2Fahrenheit(celsiusValue)))
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "5":
        do_loop = True
        while do_loop:
            VT52_cls_home()
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel')+'\n')
            upperLimit = readInt(prompt="Obergrenze:", min=3)
            lowerLimit = readInt(prompt="Untergrenze:", min=2)
            if lowerLimit <= 2:
                print(f"{upperLimit:5d}!  = {fakultaet(obergrenze=upperLimit, untergrenze=lowerLimit):7d}")
            else:
                print(f"{upperLimit:0d}! / {lowerLimit-1:0d}! = {fakultaet(obergrenze=upperLimit):0d} / {fakultaet(obergrenze=lowerLimit-1):0d} = {fakultaet(obergrenze=upperLimit, untergrenze=lowerLimit):0d}")
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "6":
        do_loop = True
        while do_loop:
            VT52_cls_home()
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel')+'\n')
            zahl_to_test = readInt(prompt="Ganze Zahl:", min=2)
            if isPrimzahl(zahl_to_test):
                print(f"{zahl_to_test:5d} ist eine Primzahl")
            else:
                print(f"{zahl_to_test:5d} ist keine Primzahl!!!")
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "7":
        do_loop = True
        while do_loop:
            VT52_cls_home()
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel')+'\n')
            lowerLimit = readInt(prompt="Von:", min=0)
            upperLimit = readInt(prompt="Bis:", min=3)
            print(f"Primzahlen von {lowerLimit:0d} bis {upperLimit:0d}: {getPrimezahlenListeAsString(lowerLimit, upperLimit, sep=';')}")
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "8":
        do_loop = True
        while do_loop:
            VT52_cls_home()
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel')+'\n')
            zahl_to_test = readInt(prompt="Ganze Zahl:", min=2)
            print(f"Primzahlen zerlegen von {zahl_to_test:0d}: {getPrimfactorsAsString(zahl_to_test, sep=';')}")
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "9":
        do_loop = True
        while do_loop:
            VT52_cls_home()
            print('\n' + unterstreichen(getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='menu_str'), aChar='-') + '\n Help:', getValueFromDictList(menu_items, key_name='nr', key_value=antwort, value_name='formel') + '\n')
            zahl_to_test = readInt(prompt="Ganze Zahl:", min=2)
            print(f"Teiler von {zahl_to_test:0d}: {getDivisorsAsString(zahl_to_test, sep=';')}")
            do_loop = read_boolean(prompt="Noch einmal [Y/*N]:", true_val_liste=['Y', 'J', 'T'], default_value=False, verbal=False)

    elif antwort == "0":
        doLoop = False

    else:
        print('Falsche Auswahl')

print("Ende....Done")
