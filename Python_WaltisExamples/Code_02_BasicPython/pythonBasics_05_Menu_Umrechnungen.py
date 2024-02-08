#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_05_Menu_Umrechnungen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_05_Menu_Umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 26-Sep-2017   Walter Rothlin      Initial Version
# 05-Mar-2020   Walter Rothlin      Added Format-String Menu-Point
# 08-Feb-2024   Walter Rothlin      Used Multiline-Format Strings
# ------------------------------------------------------------------

# Konstanten
# ==========
pi = 3.1415926
halbBogen = 180


menu_text = '''
  Umrechnungen
  ============
  1: Grad in Bogenmass
  2: Bogenmass in Grad

  3: Fahrenheit in Celsius
  4: Celsius in Fahrenheit

  0: Schluss
'''

formeln = '''
    rad  = grad*pi/180
    grad = rad*180/pi
    32F -> 0°C    100F -> 37.78°C     °C = (°F - 32) / 1.8
    32F -> 0°C    100F -> 37.78°C     °F = (°C * 1.8) + 32
'''

# =============
# Hauptprogramm
# =============
doLoop = True
while doLoop:
    print(menu_text)

    antwort = input('Bitte wähle (0..4):')
    if antwort == "1":
        gradValue = float(input("Grad:"))
        print(gradValue, "Grad ==> ", gradValue*pi/halbBogen, "Rad")

    elif antwort == "2":
        radValue = float(input("Rad:"))
        print(gradValue, "Rad ==> ", radValue*halbBogen/pi, "Grad")

    elif antwort == "3":
        fahrenheitValue = float(input("Fahrenheit:"))
        print(fahrenheitValue, "Fahrenheit ==> ", (fahrenheitValue - 32) / 1.8, "Celsius")

    elif antwort == "4":
        celsiusValue = float(input("Celsius:"))
        print(celsiusValue, "Celsius ==> ", (celsiusValue*1.8) - 32, "Fahrenheit")

    elif antwort == "9":
        feldLength = int(input("Feld 1 Length:"))
        formatStr = "Art: {0:" + str(feldLength) + "d}, Price: {1:8.2f}"

        strOut_0 = formatStr.format(4523, 59.058)
        strOut_1 = formatStr.format(45, 1259.058)
        strOut_2 = formatStr.format(1241523, 12345679.0)

        print("12345678901234567890123456789012345678901234567890")
        print(strOut_0)
        print(strOut_1)
        print(strOut_2)

    elif antwort == "0":
        doLoop = False
    else:
        print('Ungültige Eingabe')

print("Ende....Done")
