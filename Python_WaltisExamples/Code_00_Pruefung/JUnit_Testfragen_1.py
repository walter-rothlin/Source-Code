# coding=utf8
# JUnit_Testfragen_1.py

import inspect
import sys

def addElements(summand1, summand2=0, doDebug = False):
    """
        Summiert die beiden Parameter
    """
    debugStr = "--->  addElements({summand1:5.2f},{summand2:5.2f})".format(summand1=summand1, summand2=summand2)
    retVal = summand1 + summand2
    debugStr += " = {retVal:5.2f}\n".format(retVal=retVal)
    if doDebug:
        print(debugStr)
    return retVal


def calc_list(array, doDebug = False):
    """
        Summiere die Elemente mit einem geraden Index (0,2, etc.) und multipliziere die erhalten Summe mit dem Wert des letzten Element.
        Das Ergebnis wird als int zurückgegeben
        Falls eine leere Liste übergeben wird, so wird 0 zurückgegeben ---> siehe auch asserts
    """

    debugStr = "--->  calc_list(" + str(array) + ") = \n"
    retVal = 0
    for i in range(0, len(array)):
        if (i % 2) == 0:
            retVal = retVal + array[i]
            debugStr += "            Index:{index:2d}  Element: {elementVal:5.2f}   Summe:{summe:5.2f}\n".format(index=i, elementVal=array[i], summe=retVal)
    if len(array) >= 1:
        debugStr += "            Letztes: {elementVal:5.2f}\n".format(elementVal=array[-1])
        retVal = retVal * array[-1]
    else:
        retVal = 0
    debugStr += "            Return Value: {summe:5.2f}\n".format(summe=retVal)
    if doDebug:
        print(debugStr)
    return retVal




# UnitTests für Selbstkontrolle (Bricht nach dem 1 Failure ab)
if __name__ == '__main__':
    assert calc_list([0, 1, 2, 3, 4, 5], doDebug = True) == 30, "1: (0+2+4)*5=30"
    assert calc_list([1, 3, 5],          doDebug = True) == 30, "2: (1+5)*5=30"
    assert calc_list([6],                doDebug = True) == 36, "3: (6)*6=36"
    assert calc_list([],                 doDebug = True) == 0,  "4: Eine leere Liste = 0"
    assert addElements(5, 6,             doDebug = True) == 10, "5: 5 + 6 = 11"
    print("All Testcases successfully passed !")