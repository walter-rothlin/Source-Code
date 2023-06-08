#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : TI22_BMa_BLe_Primzahlen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2023/TI22_BMa_BLe_Primzahlen.py
#
# Description: Test-Programm für Primzahlen Funktionen
#
# Autor: Walter Rothlin
#
# History:
# 01-Jun-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
# Siehe Flussdiagramm: https://www.technik-unterrichten.de/Robotik/Elemente/Aufgaben/E25.php

def istPrimzahl(n):
    if n == 1:
        isPrimzahl = False
    else:
        t = 2
        while True:
            if t >= n:
                isPrimzahl = True
                break
            if n % t == 0:
                isPrimzahl = False
                break
            t += 1
    return isPrimzahl

def isPrimzahl(eineZahl):
    ist_eine_Primzahl = True
    if eineZahl == 1:
        ist_eine_Primzahl = False
    if eineZahl == 2:
        ist_eine_Primzahl = True

    obergrenze = int(eineZahl / 2) + 1
    for i in range(2, obergrenze):
        if eineZahl % i == 0:
            ist_eine_Primzahl = False
            break
    return ist_eine_Primzahl

def nextPrimezahl(eineZahl=2):
    eineZahl += 1
    while isPrimzahl(eineZahl) is False:
        eineZahl += 1
    return eineZahl

def get_prime_zahlen(p_lower, p_upper):
    ret_list = []
    for iiii in range(p_lower, p_upper+1):
        if isPrimzahl(iiii) is True:
            ret_list.append(iiii)
    return ret_list


doLoop = False
while doLoop:
    zahl = int(input('Ganze positive Zahl (is):'))
    if zahl <= 0:
        doLoop = False
    else:
        if isPrimzahl(zahl):
            print(zahl, 'ist eine Primzahl')
        else:
            print(zahl, 'ist keine Primzahl!!!')

doLoop = False
while doLoop:
    zahl = int(input('Ganze positive Zahl (next):'))
    if zahl <= 0:
        doLoop = False
    else:
        print(zahl, '-->', nextPrimezahl(zahl))

print(get_prime_zahlen(4, 20))
