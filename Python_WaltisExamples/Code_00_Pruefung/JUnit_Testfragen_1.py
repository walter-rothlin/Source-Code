# coding=utf8
# Programmier - Aufgabe 1

import inspect
import sys


def calc_list(array, doDebug = False):
    """
        Summiere die Elemente mit einem geraden Index (0,2, etc.) und multipliziere die erhalten Summe mit dem Wert des letzten Element.
        Das Ergebnis wird als int zurückgegeben
        Falls eine leere Liste übergeben wird, so wird 0 zurückgegeben ---> siehe auch asserts
    """
    summe = 0
    for i in range(0, len(array)):
        if (i % 2) == 0:
            summe = summe + array[i]
            if doDebug:
                print(i, array[i], summe)
    if len(array) >= 1:
        if doDebug:
            print("Letztes: ", array[-1])
        summe = summe * array[-1]
    else:
        summe = 0
    if doDebug:
        print("summe: ", summe)
    return summe




# Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
if __name__ == '__main__':
    assert calc_list([0, 1, 2, 3, 4, 5]) == 30, "(0+2+4)*5=30"
    assert calc_list([1, 3, 5]) == 30, "(1+5)*5=30"
    assert calc_list([6]) == 36, "(6)*6=36"
    assert calc_list([]) == 0, "Eine leere Liste = 0"
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")