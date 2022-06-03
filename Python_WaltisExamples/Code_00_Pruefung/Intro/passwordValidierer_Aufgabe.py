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
# -----------------------------------------------------------------
def count_figures_in_string(aString):
    count = 0
    for aChar in aString:
        if '0' <= aChar <= '9':
            count = count + 1
    return count

def is_valid_passwort(password, minLength=6):
    if len(password) >= minLength + 1:
        if count_figures_in_string(password) >= 1:
            return True
        else:
            print(password, "has no figures in it!")
            return False
    else:
        print(password, "too short!")
        return False


if __name__ == '__main__':
    print("Passwort prüfen:")

    # Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
    assert count_figures_in_string('muchlonger') == 0
    assert count_figures_in_string('längerse45') == 2
    assert count_figures_in_string('12345666') == 8

    assert is_valid_passwort('muchlonger') is False
    assert is_valid_passwort('12345666') is True
    assert is_valid_passwort('längerse45') is True
    assert is_valid_passwort('kurz') is False
    assert is_valid_passwort('12345') is False
    assert is_valid_passwort('sha5') is False

    assert is_valid_passwort('kurz', 4) is False
    assert is_valid_passwort('kurz', 5) is False
    assert is_valid_passwort('12345', 3) is True
    assert is_valid_passwort('sha5', 2) is True
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")

