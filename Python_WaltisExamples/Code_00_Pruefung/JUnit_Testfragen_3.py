# coding=utf8
# JUnit_Testfragen_3.py

import inspect
import sys
def calcDiskriminante(a, b, c, doDebug = False):
    """
        Berechnet die Diskriminante einer quadratischen Gleichung y = ax^2 + bx + c
    """
    debugStr = "--->  calcDiskriminante({a:5.2f},{b:5.2f},{c:5.2f})".format(a=a, b=b, c=c)
    retVal = b*b - 4*a*c
    debugStr += " = {retVal:5.2f}\n".format(retVal=retVal)
    if doDebug:
        print(debugStr)
    return retVal

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

    debugStr = "--->  calc_list(" + str(array) + ") = ?\n"
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


test_cases = [
    {
        "executeTest": True,
        "id": 1,
        "fct": "calc_list",
        "param": {
            "array": [0, 1, 2, 3, 4, 5]
        },
        "expectedResult": 30,
        "feedback": "(0+2+4)*5=30"
    },
    {
        "executeTest": False,
        "id": 2,
        "fct": "calc_list",
        "param": {
            "array": [1, 3, 5]
        },
        "expectedResult": 30,
        "feedback": "(1+5)*5=30"
    },
    {
        "executeTest": True,
        "id": 3,
        "fct": "calc_list",
        "param": {
            "array": [6]
        },
        "expectedResult": 36, # 36,
        "feedback": "(6)*6=36"
    },
    {
        "id": 4,
        "executeTest": True,
        "fct": "calc_list",
        "param": {
            "array": []
        },
        "expectedResult": 0,
        "feedback": "Eine leere Liste = 0"
    },
    {
        "executeTest": False,
        "id": 5,
        "fct": "addElements",
        "param": {
            "summand1": 4,
            "summand2": 5
        },
        "expectedResult": 9,
        "feedback": "4 + 5 = 9"
    },
    {
        "executeTest": True,
        "id": 6,
        "fct": "calcDiskriminante",
        "param": {
            "a": 4.0,
            "b": 5.0,
            "c": -4.0
        },
        "expectedResult": 89.0,
        "feedback": "Diskriminante(4x^2 + 5x -4) = 89"
    },

 ]

if __name__ == '__main__':
    countOfDisabledTestCases = 0
    countOfTestCases = 0
    countOfFailures = 0

    for aTestCase in test_cases:
        paramAdded = False
        fctCall = aTestCase['fct'] + "("
        for aParamName in aTestCase["param"]:
            # print(aTestCase["param"][aParamName])
            strList = str(aTestCase["param"][aParamName])
            if paramAdded:
                ## fctCall += ", " + aParamName + " = " + strList
                fctCall += ", "  + strList
            else:
                ## fctCall += aParamName + " = " + strList
                fctCall += strList
            paramAdded = True
        fctCall += ")"
        if not aTestCase["executeTest"]:
            print("--> WARNING: Testcase disabled! id:", aTestCase["id"], "  Fct:", fctCall, sep="")
            countOfDisabledTestCases += 1
        else:
            countOfTestCases += 1
            paramNames = aTestCase["param"].keys()
            paramNamesList = []
            for aParmName in paramNames:
                paramNamesList.append(aParmName)
            countOfFctParam = len(paramNames)
            try:
                testResult = ""
                fctName = aTestCase['fct']
                possibles = globals().copy()
                possibles.update(locals())
                method = possibles.get(fctName)
                if not method:
                    next
                else:
                    if countOfFctParam == 1:
                        testResult = method(aTestCase["param"][paramNamesList[0]])
                    if countOfFctParam == 2:
                        testResult = method(aTestCase["param"][paramNamesList[0]], aTestCase["param"][paramNamesList[1]])
                    if countOfFctParam == 3:
                        testResult = method(aTestCase["param"][paramNamesList[0]], aTestCase["param"][paramNamesList[1]], aTestCase["param"][paramNamesList[2]])
                    expectedResult = aTestCase["expectedResult"]
                    if (type(testResult)  == float):
                        testResult = round(testResult, 2)
                        expectedResult = round(expectedResult, 2)
                        print("Rounded!!!!")
                    print(type(testResult), testResult, expectedResult)
                    assert testResult == expectedResult, aTestCase["feedback"]
            except AssertionError as error:
                print("--> ERROR:   Testcase failed!   id:", aTestCase["id"], "  Fct:", fctCall, " = ?", sep="")
                if countOfFctParam == 1:
                    print("      ==> Result:", method(aTestCase["param"][paramNamesList[0]], doDebug=True), "   Expected:", aTestCase["expectedResult"], "   Feedback:", aTestCase["feedback"])
                if countOfFctParam == 2:
                    print("      ==> Result:", method(aTestCase["param"][paramNamesList[0]], aTestCase["param"][paramNamesList[1]], doDebug=True), "   Expected:", aTestCase["expectedResult"], "   Feedback:", aTestCase["feedback"])
                if countOfFctParam == 3:
                    print("      ==> Result:", method(aTestCase["param"][paramNamesList[0]], aTestCase["param"][paramNamesList[1]], aTestCase["param"][paramNamesList[2]], doDebug=True), "   Expected:", aTestCase["expectedResult"], "   Feedback:", aTestCase["feedback"])
                countOfFailures += 1
                print()

    print()
    print("countOfDisabledTestCases:", countOfDisabledTestCases)
    print("countOfTestCases        :", countOfTestCases)
    print("countOfFailures         :", countOfFailures)
