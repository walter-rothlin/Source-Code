#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : TI22_BLf_Primzahlen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2023/TI22_BLf_Primzahlen.py
#
# Description: Test-Programm für Primzahlen Funktionen
#
# Autor: Walter Rothlin
#
# History:
# 01-Jun-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
# Siehe Flussdiagramm: https://www.technik-unterrichten.de/Robotik/Elemente/Aufgaben/E25.php

def ist_es_eine_primzahl(n):
    if n == 1:
        ret_value = False
    else:
        t = 2
        while True:
            if t < n:
                if n % t == 0:
                    ret_value = False
                    break
                t += 1
            else:
                ret_value = True
                break

    return ret_value


def isPrimezahl(eine_zahl):
    ist_primzahl = False
    if eine_zahl == 1:
        ist_primzahl = False
    elif eine_zahl == 2:
        ist_primzahl = True
    else:
        ist_primzahl = True
        obergrenze = int(eine_zahl/2) + 1
        for i in range(2, obergrenze):
            if eine_zahl % i == 0:
                ist_primzahl = False
                break

    return ist_primzahl

def next_primzahl(eine_zahl):
    eine_zahl += 1
    while isPrimezahl(eine_zahl) is not True:
        eine_zahl += 1
    return eine_zahl

do_loop = False
while do_loop:
    eine_zahl = int(input('Natürliche Zahl:'))
    if eine_zahl <= 1:
        do_loop = False
    else:
        if ist_es_eine_primzahl(eine_zahl):
            print(eine_zahl, 'ist eine Primzahl!!!!!')
        else:
            print(eine_zahl, 'ist keine Primzahl')

do_loop = False
while do_loop:
    eine_zahl = int(input('Natürliche Zahl:'))
    if eine_zahl <= 1:
        do_loop = False
    else:
        if isPrimezahl(eine_zahl):
            print(eine_zahl, 'ist eine Primzahl!!!!!')
        else:
            print(eine_zahl, 'ist keine Primzahl')

do_loop = True
while do_loop:
    eine_zahl = int(input('Natürliche Zahl (next):'))
    if eine_zahl <= 1:
        do_loop = False
    else:
        print(eine_zahl, '-->', next_primzahl(eine_zahl))
