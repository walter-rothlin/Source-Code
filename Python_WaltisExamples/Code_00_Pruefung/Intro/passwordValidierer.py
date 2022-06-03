#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : passwordValidierer.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_00_Pruefung/Intro/passwordValidierer_Aufgabe.py
#
# Description: Checked ob ein Passwort den Regeln entspricht.
#   1) Passwort muss länger als 6 Zeichen lang sein.
#   1a) Passwort muss länger als n Zeichen lang sein (als Argument zu übergeben)
#   2) Passwort muss mindestens eine Ziffer enthalten
#   2a) Passwort muss mindestens n Ziffern enthalten (als Argument zu übergeben)
#
#   Rückgabe: entweder Passwort ist valid: True, Passwort ist ungültig: False
#
# Autor: Walter Rothlin
#
# History:
# 02-Jun-2022   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------


def howManyDigitsAreInString_Classic(aString, trace=False):
    count = 0
    for c in aString:
        if c >= '0' and c <= '9':
            count += 1
    if trace:
        print("howManyDigitsAreInString_Classic:", aString, count)
    return count

def howManyDigitsAreInString_WithComprehension(aString, trace=False):
    count = len([d for d in aString if d >= '0' and d <= '9'])
    if trace:
        print("howManyDigitsAreInString_WithComprehension:", aString, "--> ", count)
    return count

def howManyDigitsAreInString_WithRegEx(aString, trace=False):
    import re

    copmiledRe = re.compile(r'\d')
    count = len(copmiledRe.findall(aString))
    if trace:
        print("howManyDigitsAreInString_WithRegEx:", aString, "--> ", count)
    return count


def howManyDigitsAreInString(aString, trace=False):
    # return howManyDigitsAreInString_Classic(aString, trace=trace)
    # return howManyDigitsAreInString_WithComprehension(aString, trace=trace)
    return howManyDigitsAreInString_WithRegEx(aString, trace=trace)

def is_valid_passwort(password, trace=False):
    retVal = False
    if len(password) > 6:
        if len([d for d in password if '0' <= d <= '9']) >= 1:   # using comprehensions
            retVal = True
        else:
            retVal = False
    else:
        retVal = False
    if trace:
        print(password, len(password), howManyDigitsAreInString(password), "-->", retVal)
    return retVal


if __name__ == '__main__':
    print("Passwort prüfen:")

    # Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
    assert is_valid_passwort('muchlonger') is True
    assert is_valid_passwort('12345666') is True
    assert is_valid_passwort('längerse45') is True
    assert is_valid_passwort('kurz') is False
    assert is_valid_passwort('12345') is False
    assert is_valid_passwort('sha5') is False
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")

