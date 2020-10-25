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




test_cases = [
    {
        "id": 1,
        "fct": "calc_list",
        "param": [0, 1, 2, 3, 4, 5],
        "expectedResult": 30,
        "feedback": "(0+2+4)*5=30"
    },
    {
        "id": 2,
        "fct": "calc_list",
        "param": [1, 3, 5],
        "expectedResult": 30,
        "feedback": "(1+5)*5=30"
    },
    {
        "id": 3,
        "fct": "calc_list",
        "param": [1, 3, 5],
        "expectedResult": 29, # 30,
        "feedback": "(1+5)*5=30"
    },
    {
        "id": 4,
        "fct": "calc_list",
        "param": [1, 3, 5],
        "expectedResult": 29, # 30,
        "feedback": "(1+5)*5=30"
    },
    {
        "id": 5,
        "fct": "calc_list",
        "param": [1, 3, 5],
        "expectedResult": 29, # 30,
        "feedback": "(1+5)*5=30"
    }

]

countOfTestCases = 0
countOfFailures = 0
for aTestCase in test_cases:
    countOfTestCases += 1
    print(aTestCase)
    try:
        assert calc_list(aTestCase["param"]) == aTestCase["expectedResult"], aTestCase["feedback"]
    except AssertionError as error:
        print("Testcase failed:")
        countOfFailures += 1

print("countOfTestCases:", countOfTestCases)
print("countOfFailures:", countOfFailures)