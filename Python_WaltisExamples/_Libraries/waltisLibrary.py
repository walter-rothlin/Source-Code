#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: waltisLibrary.py
#
# Description: Library - Module (Source in ExamplesPyton/_Libraries/waltisLibrary.py)
#
# Autor: Walter Rothlin
#
# History:  
# 06-Dec-2017   Walter Rothlin      Initial Version (Eigene Funktions von umrechnen.py ausgelagert)
# 28-May-2019   Walter Rothlin      Added Primzahlen functions
# 07-Jun-2019   Walter Rothlin      Merged with littlePythonLib.py
# 09-Apr-2020   Walter Rothlin      Refactoring isPrimezahl()
# 28-Sep-2020   Walter Rothlin      Added equalsWithinTolerance
# 19-Nov-2020   Walter Rothlin      Added calcCircle mit None parameter
# 10-Dec-2020   Walter Rothlin      Added fakultaet
# 21-Jan-2021   Walter Rothlin      Added ASCII Fct
# 17-Feb-2021   Walter Rothlin      File Operationen implementiert
# ------------------------------------------------------------------
import inspect
import math
import os
import sys
import time
import datetime
from pathlib import Path
import re
from time import sleep

# Add dir to PYTHONPATH in a program
# ----------------------------------
# import sys
# sys.path.append('G:\_WaltisDaten\SourceCode\GitHosted\Python_WaltisExamples\_Libraries')
# https://www.datacamp.com/community/tutorials/modules-in-python?utm_source=adwords_ppc&utm_campaignid=898687156&utm_adgroupid=48947256715&utm_device=c&utm_keyword=&utm_matchtype=b&utm_network=g&utm_adpostion=&utm_creative=332602034343&utm_targetid=aud-299261629574:dsa-429603003980&utm_loc_interest_ms=&utm_loc_physical_ms=1030659&gclid=CjwKCAjw8MD7BRArEiwAGZsrBdWiIwMkjQ8l9_Gm52f1FEpiFVHlAgnMVf7UPzAtdNaeC7zq0691oRoC2D4QAvD_BwE#import

# Add dir to PYTHONPATH in PYCHARM
# --------------------------------
# Click an directory in project folders. Than Rigth Click in Project-Explorer  --> Mark Directory as --> Source Root
# https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000782850-How-to-set-up-working-directory-in-PyCharm-and-package-import-

# Constants
# =========
auto_test_suiteNameLength = 40
auto_test_testStatistics_anzStellen = 4
auto_test_testStatistics_totalLength = 107
auto_test_fct_prefix = "AUTO_TEST_"
auto_test_fct_prefix_len = len(auto_test_fct_prefix)

# Library fucntions
# =================
def waltisPythonLib_Version():
    print("waltisLibrary.py: 1.0.0.3")

# Bildschirmsteuerung
# ===================
def VT52_cls():
    print("\033[2J",end="", flush=True)

def VT52_home():
    print("\033[H",end="", flush=True)

def VT52_cls_home():
    VT52_cls()
    VT52_home()

def halt(prompt="Weiter?"):
    ant=input(prompt)

# Pysikalische Umrechnungen
# =========================
def grad2Rad(grad):
    return math.pi*grad/180

def rad2Grad(rad):
    return 180*rad/math.pi

def fahrenheit2Celsius(fahrenheit):
    return (fahrenheit-32)/1.8

def celsius2Fahrenheit(celsius):
    return (celsius*1.8)+32

def AUTO_TEST_pysikalische_umrechnungen_1(verbal=False):
    print(celsius2Fahrenheit(37.8))  # --> 100
    print(celsius2Fahrenheit(0))  # --> 32

    print(fahrenheit2Celsius(100))  # --> 37.8
    print(fahrenheit2Celsius(32))  # --> 0

def AUTO_TEST_pysikalische_umrechnungen_1a(verbal=False):
    print("celsius2Fahrenheit(37.8)) = ", celsius2Fahrenheit(37.8), "   Expected: 100")
    print("celsius2Fahrenheit(0))    = ", celsius2Fahrenheit(0),    "   Expected: 32")

    print("fahrenheit2Celsius(100))  = ", fahrenheit2Celsius(100), "    Expected: 37.8")
    print("fahrenheit2Celsius(32))   = ", fahrenheit2Celsius(32),  "    Expected: 32")


def AUTO_TEST_pysikalische_umrechnungen_2(verbal=False):
    inVal = 37.8
    expected = 100.04
    print(round(celsius2Fahrenheit(inVal), 2) == expected)

    inVal = 0
    expected = 32
    print(round(celsius2Fahrenheit(inVal), 2) == expected)

    inVal = 100
    expected = 37.8
    print(round(fahrenheit2Celsius(inVal), 2) == expected)

    inVal = 32
    expected = 0
    print(round(fahrenheit2Celsius(inVal), 2) == expected)

def AUTO_TEST_pysikalische_umrechnungen_3(verbal=False):
    inVal = 37.8
    expected = 100.05
    if round(celsius2Fahrenheit(inVal), 2) != expected:
        print("ERROR (1):", end="")
        print("celsiusToFahrenheit(", inVal, ") = ", round(celsius2Fahrenheit(inVal), 2), "   Expected:", expected, sep="")

    inVal = 0
    expected = 32.0
    if round(celsius2Fahrenheit(inVal), 2) != expected:
        print("ERROR (2):", end="")
        print("celsiusToFahrenheit(", inVal, ") = ", round(celsius2Fahrenheit(inVal), 2), "   Expected:", expected, sep="")

    inVal = 100
    expected = 37.78
    if round(fahrenheit2Celsius(inVal), 2) != expected:
        print("ERROR (3):", end="")
        print("celsiusToFahrenheit(", inVal, ") = ", round(fahrenheit2Celsius(inVal), 2), "   Expected:", expected, sep="")

    inVal = 32
    expected = 0.1
    if round(fahrenheit2Celsius(inVal), 2) != expected:
        print("ERROR (4):", end="")
        print("celsiusToFahrenheit(", inVal, ") = ", round(fahrenheit2Celsius(inVal), 2), "   Expected:", expected, sep="")

def AUTO_TEST_pysikalische_umrechnungen_4(verbal=False):
    testsPerformed = 0
    testsFailed = 0

    testSuite = "pysikalische_umrechnungen"
    testCases = """
    Nr    |Fct                   |Param1       |Param2       |Param3       |Expected
         1|celsius2Fahrenheit    |37.8         |0            |0            |100.04
         2|celsius2Fahrenheit    |0            |0            |0            |32.0
         3|fahrenheit2Celsius    |100          |0            |0            |37.78
         4|rad2Grad              |0            |0            |0            |0
    """

    listOfTestCases = testCases.split("\n")
    for aTestCase in listOfTestCases[2:-1]:
        testsPerformed += 1
        listOfTestValues = aTestCase.split("|")
        case = listOfTestValues[0].strip()
        fct = listOfTestValues[1].strip()
        param_1 = float(listOfTestValues[2].strip())
        param_2 = float(listOfTestValues[3].strip())
        param_3 = float(listOfTestValues[4].strip())
        expectedResult = float(listOfTestValues[5].strip())
        # print(case, fct, param_1, param_2, param_3, expectedResult)
        if fct == "celsius2Fahrenheit":
            result = round(celsius2Fahrenheit(param_1), 2)
        elif fct == "fahrenheit2Celsius":
            result = round(fahrenheit2Celsius(param_1), 2)
        if result != expectedResult:
            testsFailed += 1
            print("Error in ", fct, "  ->", case, " (", testsPerformed, ")", sep="")
            print("   celsius2Fahrenheit(", param_1,  ") = ", result, "    Expected:", expectedResult, sep="")
            print()
    print("\n")
    print("==> ", testSuite, ": Tests Performed:", testsPerformed, "   Tests Failed:", testsFailed, "    Passed:", round(100-(100 * testsFailed / testsPerformed),1), "%", sep="" )

def AUTO_TEST_pysikalische_umrechnungen_5(verbal=False):
    testsPerformed = 0
    testsFailed = 0

    testSuite = getMyFctName()[auto_test_fct_prefix_len:]
    testCases = """
    Nr    |Fct                   |Param1       |Param2       |Param3       |Expected
         1|celsius2Fahrenheit    |37.8         |0            |0            |100.04
         2|celsius2Fahrenheit    |0            |0            |0            |32.0
         3|fahrenheit2Celsius    |100          |0            |0            |37.78
         4|fahrenheit2Celsius    |32           |0            |0            |0
         5|rad2Grad              |3.141562     |0            |0            |180
         6|grad2Rad              |180          |0            |0            |3.14
    """

    listOfTestCases = testCases.split("\n")
    for aTestCase in listOfTestCases[2:-1]:
        testsPerformed += 1
        listOfTestValues = aTestCase.split("|")
        case = listOfTestValues[0].strip()
        fct = listOfTestValues[1].strip()
        param_1 = float(listOfTestValues[2].strip())

        expectedResult = float(listOfTestValues[5].strip())
        # print(case, fct, param_1, param_2, param_3, expectedResult)
        possibles = globals().copy()
        possibles.update(locals())
        method = possibles.get(fct)
        result = None
        if method:
            result = round(method(param_1), 2)
        else:
            testsFailed += 1
            print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:()  ->", case, " (", testsPerformed, ")   Fct to test not found!!!", sep="")
        if result != expectedResult:
            testsFailed += 1
            print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:()  ->", case, " (", testsPerformed, ")", sep="")
            print("   celsius2Fahrenheit(", param_1,  ") = ", result, "    Expected:", expectedResult, sep="")
            print()
    print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]

def AUTO_TEST_pysikalische_umrechnungen(verbal=False):
    # print(unterstreichen("AUTO_TEST_pysikalische_umrechnungen", "="))
    # print(unterstreichen("AUTO_TEST_pysikalische_umrechnungen_1", "-"))
    # AUTO_TEST_pysikalische_umrechnungen_1(verbal)

    # print()
    # print(unterstreichen("AUTO_TEST_pysikalische_umrechnungen_1a", "-"))
    # AUTO_TEST_pysikalische_umrechnungen_1a(verbal)

    # print()
    # print(unterstreichen("AUTO_TEST_pysikalische_umrechnungen_2", "-"))
    # AUTO_TEST_pysikalische_umrechnungen_2(verbal)

    # print()
    # print(unterstreichen("AUTO_TEST_pysikalische_umrechnungen_3", "-"))
    # AUTO_TEST_pysikalische_umrechnungen_3(verbal)

    # print()
    # print(unterstreichen("AUTO_TEST_pysikalische_umrechnungen_4", "-"))
    # AUTO_TEST_pysikalische_umrechnungen_4(verbal)

    # print()
    # print(unterstreichen("AUTO_TEST_pysikalische_umrechnungen_5", "-"))
    return AUTO_TEST_pysikalische_umrechnungen_5(verbal)

# Fakultät berechnen
# ==================
def fakultaet(obergrenze, untergrenze=1):
    fakultaet = -1
    if (obergrenze > 0):
        fakultaet = 1
        while obergrenze >= untergrenze:
            fakultaet = fakultaet * obergrenze
            obergrenze = obergrenze - 1
    return fakultaet


# Primzahlen Functions
# ====================
def isPrimzahl(aZahl):
    '''
    Returns True/False if a given integer is a prime figure (only dividable by 1 or itself.

            Parameters:
                    aZahl (int): A positive Integer

            Returns:
                    True / False
    '''
    isPrim = False
    if ((aZahl == 1) or (aZahl == 2)):
        isPrim = True
    else:
        isPrim = True
        obergrenze = int(aZahl / 2) + 1
        # print("Obergrenze:",obergrenze)
        for i in range(2,obergrenze + 1):
            # print("    Test: aZahl % i = ",aZahl,"%",i,"=",aZahl % i)
            if ((aZahl % i) == 0):
                isPrim = False
    return isPrim

def getNextPrimzahl(zahl):
    if ((zahl % 2) == 0):   # then Gerade
        aZahl = zahl + 1
    else:
        aZahl = zahl + 2
    # print("getNextPrimzahl::Startwert:",aZahl)
    while (isPrimzahl(aZahl) == False):
        aZahl = aZahl + 2
    return aZahl
  
def getPrevPrimzahl(zahl):
    if ((zahl % 2) == 0):   # then Gerade
        aZahl = zahl - 1
    else:
        aZahl = zahl - 2
    if (aZahl <= 1):
        return 1
    else:
        # print("getPrevPrimzahl::Startwert:",aZahl)
        while (isPrimzahl(aZahl) == False):
            aZahl = aZahl - 2
    return aZahl

def getPrimezahlenListe(start, end, sep = ";"):
    retStr = ""
    for i in range(start,end+1):
        if (isPrimzahl(i)):
            retStr = retStr + sep + str(i)
    retStr = retStr[-(len(retStr) - len(sep)):]
    return retStr

def getPrimfactors(zahl, sep = ";"):
    retStr = ""
    aZahl = abs(zahl)
    aDivisor = 2
    if (zahl == 1):
        retStr = "1"
    else:
        if (zahl == 2):
            retStr = "2"
        else:
            while (isPrimzahl(aZahl) == False):
                if ((aZahl % aDivisor) == 0):
                    if (aZahl > 1):
                        retStr = retStr + sep + str(aDivisor)
                    aZahl = int(aZahl / aDivisor)    # Ganzzahlige division
                else:
                    aDivisor = getNextPrimzahl(aDivisor)
            if (aZahl > 1):
                retStr = retStr + sep + str(aZahl)
            retStr = retStr[-(len(retStr) - len(sep)):]
    return retStr

def getDivisors(zahl, sep = ";"):
    retStr = ""
    aZahl = abs(zahl)
    aDivisor = 2
    while (aDivisor < aZahl):
      if ((aZahl % aDivisor) == 0):
         retStr = retStr + sep + str(aDivisor)
      aDivisor = aDivisor + 1

    retStr = retStr[-(len(retStr) - len(sep)):]
    return retStr

# Test der Functions primezahlen
# ------------------------------
def TEST_Primzahlen():
    for i in range(100):
        if (isPrimzahl(i)):
            print("{z:3d}: Ist eine Primzahl!!!".format(z=i))
        else:
            print("{z:3d}: Primzahlen:{s:30s}      Teiler    :{s1:30s}".format(z=i,s=getPrimfactors(i),s1=getDivisors(i)))

# String Functions
# ================
def addParity(binStr, oddParity=True):
    anzOne = 0
    for aBit in binStr:
        if aBit == "1":
            anzOne += 1
    if anzOne % 2 == 0:
        if oddParity:
            binStr = "1" + binStr
        else:
            binStr = "0" + binStr
    else:
        if oddParity:
            binStr = "0" + binStr
        else:
            binStr = "1" + binStr
    return binStr


def AUTO_TEST_addParity(verbal=False):
    testsPerformed = 0
    testsFailed = 0

    testSuite = getMyFctName()[auto_test_fct_prefix_len:]
    testCases = """
    Nr    |Fct                |Bitmuster    |Odd_Parity   |Param3       |Expected
         1|addParity          |1101110      |True         |0            |01101110
         2|addParity          |0101110      |True         |0            |10101110
         3|addParity          |110          |True         |0            |1110
         4|addParity          |1101110      |False        |0            |11101110
         5|addParity          |0101110      |False        |0            |00101110
         6|addParity          |110          |False        |0            |0110
         7|addParity          |110          |True         |0            |1110
         8|addParity          |111          |True         |0            |0111
    """

    listOfTestCases = testCases.split("\n")
    for aTestCase in listOfTestCases[2:-1]:
        testsPerformed += 1
        listOfTestValues = aTestCase.split("|")
        case = listOfTestValues[0].strip()
        fct = listOfTestValues[1].strip()
        param_1 = listOfTestValues[2].strip()
        param_2 = (listOfTestValues[3].strip() == "True")
        expectedResult = listOfTestValues[5].strip()
        # print(case, fct, param_1, param_2, expectedResult)

        possibles = globals().copy()
        possibles.update(locals())
        method = possibles.get(fct)
        result = None
        if method:
            result = method(param_1, param_2)
        else:
            testsFailed += 1
            print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:()  ->", case, " (", testsPerformed, ")   Fct to test not found!!!", sep="")
        if result != expectedResult:
            testsFailed += 1
            print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:()  ->", case, " (", testsPerformed, ")", sep="")
            print("   ", fct, "(", param_1,  ",", param_2, ") = ", result, "    Expected:", expectedResult, sep="")
            print()
    print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]

def showASCII_Table(firstVal = 33, lastVal = 126, sep = " --> ", end = "\n"):
    print("{z:5s} {sep:1s} {ordDec:3s}     {ordHex:5s} {ordOct:6s} {ordBin:8s}   {odd:8s}   {even:8s}".format(z="ASCII", sep=sep, ordDec="Dez", ordHex="Hex", ordOct="Oct", ordBin="Bin", even="Even", odd="Odd"), sep="")
    for i in range(firstVal, lastVal+1):
        print("{z:5s} {sep:1s} {ordDec:3d}     {ordHex:5s} {ordOct:6s} {ordBin:8s}".format(z=chr(i), sep=sep, ordDec=i, ordHex=hex(i)[2:].upper(), ordOct=oct(i)[2:].upper().rjust(3, "0"), ordBin=bin(i)[2:].upper().rjust(7, "0")), "   ", addParity(bin(i)[2:].upper().rjust(7, "0")), "   ", addParity(bin(i)[2:].upper().rjust(7, "0"), False), sep="")

def left(s, amount):
    return s[:amount]

def right(s, amount):
    return s[-amount:]

def mid(s, offset, amount):
    return s[offset:offset+amount]

def toUpperCase(inString):
    retString = ""
    for aChar in inString:
        if (aChar >= 'a') and (aChar <= 'z'):
            retString = retString + chr(ord(aChar) - (ord('a') - ord('A')))
        else:
            retString = retString + aChar
    return retString

def toLowerCase(inString):
    retString = ""
    for aChar in inString:
        if (aChar >= 'A') and (aChar <= 'Z'):
            retString = retString + chr(ord(aChar) + (ord('a') - ord('A')))
        else:
            retString = retString + aChar
    return retString

def toFirstUpperCase(inString):
    firstPart = inString[:1]
    endPart   = inString[1:]
    return toUpperCase(firstPart) + toLowerCase(endPart)

def generateStringRepeats(len, aChar = " "):
    return (aChar*len)[:len]

def unterstreichen(title, aChar="=", end="\n"):
    return title + end + generateStringRepeats(len(title), aChar)


def TEST_stringFct():
    showASCII_Table()

    eingabeString = input("String:")
    print("toUpperCase(", eingabeString, ")           --> ", toUpperCase(eingabeString), sep="")
    print("toLowerCase(", eingabeString, ")           --> ", toLowerCase(eingabeString), sep="")
    print("toFirstUpperCase(", eingabeString, ")      --> ", toFirstUpperCase(eingabeString), sep="")



def hexStrToURLEncoded(inStr):
    # https://www.quora.com/How-do-I-convert-hex-into-a-string-using-Python
    retStr = ""
    instr = "".join(inStr.split())
    print("instr:", instr)
    listOfDoubleHexStr  = []

    i = 0
    while i < len(instr):
        listOfDoubleHexStr.append(instr[i] + instr[i+1])
        i += 2

    print("listOfDoubleHexStr:", listOfDoubleHexStr)
    for aDHex in listOfDoubleHexStr:
        print(aDHex, ":", end="")
        aChrOrd = ord(bytes.fromhex(aDHex))
        print(aChrOrd, ":", end="")
        partRetStr = ""
        if (aChrOrd > 32) and (aChrOrd < 127):
            partRetStr = bytes.fromhex(aDHex).decode('utf-8')
        else:
            partRetStr = "%" + aDHex + ""
        retStr += partRetStr
        print(partRetStr, ":")
    return retStr

def TEST_hexStrToURLEncoded():
    testStr_0 = "5350430d0a303230300d0a31"
    testStr_1 = """53 50 43 0d   0a 30 32 30 30 0d 0a 31
        0d 0a 43 48 39 33 33 30   30 30 30 30 30 31 39 30"""

    testStr_2 = """
        71 a4 00 e2 53 50 43 0d   0a 30 32 30 30 0d 0a 31
        0d 0a 43 48 39 33 33 30   30 30 30 30 30 31 39 30
        37 36 31 36 34 30 35 0d   0a 4b 0d 0a 4e 6f 76 61
        54 72 65 6e 64 20 53 65   72 76 69 63 65 73 20 47
        6d 62 48 0d 0a 42 61 68   6e 68 6f 66 73 74 72 61
        73 73 65 20 31 38 0d 0a   36 33 34 30 20 42 61 61
        72 0d 0a 0d 0a 0d 0a 43   48 0d 0a 0d 0a 0d 0a 0d
        0a 0d 0a 0d 0a 0d 0a 0d   0a 36 2e 30 35 0d 0a 43
        48 46 0d 0a 4b 0d 0a 57   61 6c 74 65 72 20 52 6f
        74 68 6c 69 6e 0d 0a 50   65 74 65 72 6c 69 77 69
        65 73 65 20 33 33 0d 0a   38 38 35 35 20 57 61 6e
        67 65 6e 0d 0a 0d 0a 0d   0a 43 48 0d 0a 51 52 52
        0d 0a 30 30 30 30 30 30   30 30 30 30 30 30 30 30
        30 34 30 34 34 33 30 33   38 32 39 39 35 0d 0a 0d
        0a 45 50 44 0d 0a 00 ec   11 ec 11 ec 11 ec 11 ec
        11 ec 11 ec 11 ec 11 ec   11 ec 11 ec 11 ec
    """

    testStr_3 = """
            00 01 02 03 04 05 06 07   08 09 0A 0B 0C 0d 0e 0f
            10 11 12 13 14 15 16 17   18 19 1A 1B 1C 1d 1e 1f
            20 21 22 23 24 25 26 27   28 29 2A 2B 2C 2d 2e 2f
            30 31 32 33 34 35 36 37   38 39 3A 3B 3C 3d 3e 3f
            40 41 42 43 44 45 46 47   48 49 4A 4B 4C 4d 4e 4f
            50 51 52 53 54 55 56 57   58 59 5A 5B 5C 5d 5e 5f
            60 61 62 63 64 65 66 67   68 69 6A 6B 6C 6d 6e 6f
            70 71 72 73 74 75 76 77   78 79 7A 7B 7C 7d 7e 7f
            80 81 82 83 84 85 86 87   88 89 8A 8B 8C 8d 8e 8f
            f0 f1 f2 f3 f4 f5 f6 f7   f8 f9 fA fB fC fd fe ff
    """
    print(hexStrToURLEncoded(testStr_3))
# Date and Timestamp
# ==================
def getTimestamp(preStr = "", postStr="", formatString="nice"):
    formatStr = '{:%Y-%m-%d %H:%M:%S}'
    if (formatString == ""):
        formatStr = '{:%Y%m%d%H%M%S}'
    elif (formatString == "nice"):
        formatStr = '{:%Y-%m-%d %H:%M:%S}'
    else:
        formatStr = formatString
    retStr = formatStr.format(datetime.datetime.now())
    # retStr = left(retStr,len(retStr)-2)
    return preStr + retStr + postStr

# True if (old-young > limit)
def checkTimeDifference(oldTimestamp, youngTimestamp, limit, gt=True):
    timeDiff =  youngTimestamp - oldTimestamp
    secStr = str(timeDiff)[:7]
    if (gt):
        return (secStr > limit)
    else:
        return (secStr < limit)

# Math functions
# --------------
def equalsWithinTolerance(ist,soll,abweichungProzent=0.001):
    if (soll==0) and (ist==0):
        return True
    else:
        if (abs(100-(ist*100/soll)) > abweichungProzent):
            return False
        else:
            return True

# Inspection functions
# ====================
def getMyFctName():
    # liste = inspect.stack()[1]
    # for aItem in liste:
    #     print("   --> ", aItem)
    # print(inspect.stack()[1][4])
    return inspect.stack()[1][3]


# REST / JSON functions
# =====================
# https://stackoverflow.com/questions/7320319/xpath-like-query-for-nested-python-dictionaries
def xPath_Get(mydict, path):
     elem = mydict
     try:
         for x in path.strip("/").split("/"):
             try:
                 x = int(x)
                 elem = elem[x]
             except ValueError:
                 elem = elem.get(x)
     except:
         pass
     return elem


def AUTO_TEST_xPath_Get(verbal=False):
    if verbal:
        print("==> ", getMyFctName())

    foo = {
         'spam': 'eggs',
         'morefoo': [{
             'bar': 'soap',
             'morebar': {
                 'bacon': {
                     'bla': '12345'
                 }
             }
         },
             'Walt'
         ]
    }

    testCasesExecuted = 5
    testCasesFailed   = 2
    testCases = """"
    Expected | Param_1                     
    1234     | /morefoo/0/morebar/bacon/bla
    Walti    | /morefoo/1
    """
    param1 = "/morefoo/0/morebar/bacon/bla"
    expextedVal1 = "1234"
    retVal = xPath_Get(foo, param1)
    if ( retVal != expextedVal1):
        print("   ERROR in TEST: xPath_Get(foo, ", param1, ") = ", retVal, "    ==> expected: ", expextedVal1, sep="")

    param1 = "morefoo/1"
    expextedVal1 = "Walti"
    retVal = xPath_Get(foo, param1)
    if ( retVal != expextedVal1):
        print("   ERROR in TEST: xPath_Get(foo, ", param1, ") = ", retVal, "    ==> expected: ", expextedVal1, sep="")

    if verbal:
        print("--> Test Cases Executed: {a:4d}".format(a=testCasesExecuted))
        print("--> Test Cases Failed  : {a:4d}".format(a=testCasesFailed))
    return {"TestName": getMyFctName(), "testCasesExecuted": testCasesExecuted, "testCasesFailed": testCasesFailed}

# File operationen
# ================
#    TBC verallgemeinern start
# Cleanup - Rule N°1 : Verzeichnis wird durchsucht und alle Files mit .csv werden gelöscht
def file_cleanup1():
    logfiles = Path('C:\\Users\charl\PycharmProjects\Python_HWZ\programming_tools\projektarbeit_python')
    for file in logfiles.glob('*.csv'):
        if file.is_file():
            try:
                file.unlink()
                print("Files gelöscht")
            except OSError as error:
                print("File {} konnte nicht gelöscht werden: {}".format(file, error))

# Cleanup - Rule N°2 : Verzeichnis wird durchsucht und alle Files(.csv) älter als 7 Tage werden gelöscht
def File_cleanup2():
    logfiles = Path('C:\\Users\charl\PycharmProjects\Python_HWZ\programming_tools\projektarbeit_python')
    for file in logfiles.glob('*.csv'):
        create_time = os.path.getctime(file)
        if (time.time() - create_time) // (24 * 3600) >= 7:
            os.unlink(file)
            print('{} removed'.format(file))

def File_getAllLogFiles(path):
    files = os.listdir(path)
    files = list(filter(lambda file: file.endswith('.csv'), files))
    return [path + file for file in files]  # append path to the file to delete it later


def File_removeOldLogs(files,maxLogFiles=10):
    while len(files) > maxLogFiles:
        oldestFile = min(files, key=os.path.getctime)
        os.remove(oldestFile)
        files = File_getAllLogFiles(".")

def File_cleanup(filename, directory, path_sign):
    """Cleanup Funktion löscht angegebene Dateien aus angegebenen Verzeichnisse"""
    path_sign = path_sign
    if directory == "":
        directory = os.curdir + path_sign
    if not filename == "":
        filename = str(directory) + path_sign + str(filename)
        if os.path.exists(filename):
            print("Datei {} löschen".format(filename))
            os.remove(filename)
        else:
            print("Die Datei {} existiert nicht".format(filename))
    else:
        for file in os.listdir(directory):
            if file.startswith("logger"):
                os.chdir(directory)
                print("Datei {} löschen".format(file))
                os.remove(file)

#    TBC verallgemeinern start

def File_createTestFile(aFileFN, startLineNr=1, endLineNr=20, aHeader="", aFooter="", aContent=""):
    aTestFile = open(aFileFN, "w")
    if (aHeader != ""):
        aTestFile.write(aHeader + "\n")
    for lNr in range(startLineNr, endLineNr+1):
        aTestFile.write(str(lNr) + aContent + "\n")

    if (aFooter != ""):
        aTestFile.write(aFooter + "\n")
    aTestFile.close()

def File_getCountOfLines(sourceFileFN):
    lines = []
    with open(sourceFileFN, "r", encoding="utf-8") as f:
        lines = f.readlines()
    return len(lines)

def File_deleteLines(sourceFileFN, destinationFileFN=None, deleteLineFrom=None, deleteLineTo=None, verbal=False):
    if destinationFileFN is None:
        destinationFileFN = sourceFileFN

    if (deleteLineFrom is None) and (deleteLineTo is None):
        deleteLineFrom = 1
        deleteLineTo = 0
    elif (deleteLineFrom is not None) and (deleteLineTo is None):
        deleteLineTo = 1000000
    elif (deleteLineFrom is None) and (deleteLineTo is not None):
        deleteLineFrom = 1
    else:
        pass  # NOP

    if verbal:
        print("    Delete from", deleteLineFrom, "to", deleteLineTo, end="")

    # File lesen in eine Liste
    with open(sourceFileFN, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # In Liste Range löschen
    del lines[deleteLineFrom-1:deleteLineTo]

    # Liste in File schreiben
    with open(destinationFileFN, "w", encoding="utf-8") as f:
        f.writelines(lines)


    # with open(destinationFileFN, "w", encoding="utf-8") as f:
    #     i = 1
    #     for line in lines:
    #         if (i < deleteLineFrom) or (i > deleteLineTo):
    #             f.write(line)
    #         i += 1

def getRegExMatches(inString, regEx):
    matches = re.findall(regEx, inString)
    return matches

def getIncludeFileName(aTextLine, includePattern='# include:\S+'):
    aFilename = ""
    listOfMatches = getRegExMatches(aTextLine, includePattern)
    if len(listOfMatches) > 0:
        aFilename = listOfMatches[0][10:]   # hard codiert len('# include:')
    return aFilename


def TEST_getIncludeFileName():
    print(getIncludeFileName("3   # include:Test_1_With_Include_2.txt   kkkkkkkk"))
    print(getIncludeFileName("   4   # include:./hhhh/Test_1_With_Include_22.txt   "))

def File_readWithInludes(sourceFileFN, includePattern='# include:\S+', includeSearchPath = "./", recLevel = 0):
    '''
    returns a list of lines and resolves the includes
    Default include pattern is: <include:filename>
    Don't pass $recLevel. It is used internaly for recursion
    The function doesn't read any other character on the same line as the include command
    '''
    f = open(sourceFileFN, "r")
    fileContent = f.readlines()
    f.close()
    for aLine in fileContent:
        includeFileName = getIncludeFileName(aLine, includePattern)
        if includeFileName != "" and recLevel < 3:
            File_readWithInludes(includeFileName, includePattern, includeSearchPath, recLevel=recLevel+1)
        print(fileContent)

def TEST_FileFunctions():
    # Test-Cases: File_getCountOfLines()
    File_createTestFile("./TestData/Test_1.txt")
    countOfLine = File_getCountOfLines("./TestData/Test_1.txt")
    expectedResult = 20
    if (countOfLine != expectedResult):
        print("Test Failed: File_getCountOfLines(./TestData/Test_1.txt)", "Result: ", File_getCountOfLines("./TestData/Test_1.txt"), "   Expected:", expectedResult)

    File_createTestFile("./TestData/Test_2.txt", aHeader="Nr |", aContent=" | Content", aFooter="File Ende", startLineNr=5, endLineNr=45)
    countOfLine = File_getCountOfLines("./TestData/Test_2.txt")
    expectedResult = 43
    if (countOfLine != expectedResult):
        print("Test Failed: File_getCountOfLines(./TestData/Test_2.txt)", "Result: ", File_getCountOfLines("./TestData/Test_2.txt"), "   Expected:", expectedResult)

    # Test-Cases: File_deleteLines()
    File_deleteLines("./TestData/Test_1.txt", "./TestData/Test_1a.txt", deleteLineFrom=None, deleteLineTo=None, verbal=False)
    File_deleteLines("./TestData/Test_1.txt", "./TestData/Test_1b.txt", deleteLineFrom=2, deleteLineTo=7)
    File_deleteLines("./TestData/Test_1.txt", "./TestData/Test_1c.txt", deleteLineFrom=5)
    File_deleteLines("./TestData/Test_1.txt", "./TestData/Test_1d.txt", deleteLineTo=7)
    print("\n")


    #### TEST_getIncludeFileName()
    #### File_readWithInludes("./TestData/Test_1_With_Include_1.txt")


# Geometrische Formen berechnen
# =============================

#  Kreis
#  -----
def calcCircle_Flaeche(radius=None, durchmesser=None, flaeche=None, umfang=None):
    if radius is not None:
        return radius**2 * math.pi
    elif durchmesser is not None:
        return (durchmesser/2) ** 2 * math.pi
    elif flaeche is not None:
        return flaeche
    elif umfang is not None:
        return ((umfang/math.pi)/2) ** 2 * math.pi
    else:
        return 0

def TEST_calcCircle_Flaeche():
    radius = 10
    print(calcCircle_Flaeche(radius=radius))
    print(calcCircle_Flaeche(durchmesser=2 * radius))
    print(calcCircle_Flaeche(umfang=2 * radius * math.pi))
    print(calcCircle_Flaeche(flaeche=radius**2 * math.pi))

def calcCircle_Umfang(radius=None, durchmesser=None, flaeche=None, umfang=None):
    if radius is not None:
        return radius * 2 * math.pi
    elif durchmesser is not None:
        return durchmesser * math.pi
    elif flaeche is not None:
        return (math.sqrt(flaeche / math.pi)) * 2 * math.pi
    elif umfang is not None:
        return umfang
    else:
        return 0

def TEST_calcCircle_Umfang():
    radius = 10
    print(calcCircle_Umfang(radius=radius))
    print(calcCircle_Umfang(durchmesser=2 * radius))
    print(calcCircle_Umfang(umfang=2 * radius * math.pi))
    print(calcCircle_Umfang(flaeche=radius**2 * math.pi))


def calcCircle_Radius(radius=None, durchmesser=None, flaeche=None, umfang=None):
    if radius is not None:
        return radius
    elif durchmesser is not None:
        return durchmesser/2
    elif flaeche is not None:
        return math.sqrt(flaeche / math.pi)
    elif umfang is not None:
        return (umfang/math.pi)/2
    else:
        return 0

def TEST_calcCircle_Radius():
    radius = 10
    print(calcCircle_Radius(radius=radius))
    print(calcCircle_Radius(durchmesser=2 * radius))
    print(calcCircle_Radius(umfang=2 * radius * math.pi))
    print(calcCircle_Radius(flaeche=radius**2 * math.pi))

def calcCircle_Durchmesser(radius=None, durchmesser=None, flaeche=None, umfang=None):
    if radius is not None:
        return radius * 2
    elif durchmesser is not None:
        return durchmesser
    elif flaeche is not None:
        return math.sqrt(flaeche / math.pi) * 2
    elif umfang is not None:
        return umfang/math.pi
    else:
        return 0

def TEST_calcCircle_Durchmesser():
    radius = 10
    print(calcCircle_Durchmesser(radius=radius))
    print(calcCircle_Durchmesser(durchmesser=2 * radius))
    print(calcCircle_Durchmesser(umfang=2 * radius * math.pi))
    print(calcCircle_Durchmesser(flaeche=radius**2 * math.pi))

def TEST_CircleFct():
    TEST_calcCircle_Flaeche()
    TEST_calcCircle_Umfang()
    TEST_calcCircle_Radius()
    TEST_calcCircle_Durchmesser()


if __name__ == '__main__':
    # AUTO_TEST_xPath_Get(verbal=True)
    # TEST_stringFct()
    TEST_FileFunctions()
    # TEST_hexStrToURLEncoded()

    # Automated Tests
    # ===============
    totalTests = 0
    totalFails = 0
    testStat = AUTO_TEST_pysikalische_umrechnungen(verbal=True)
    totalTests += testStat[0]
    totalFails += testStat[1]

    testStat = AUTO_TEST_addParity(verbal=True)
    totalTests += testStat[0]
    totalFails += testStat[1]
    print(generateStringRepeats(auto_test_testStatistics_totalLength, '-'))
    print("===> ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v="Total:"), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=totalTests), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=totalFails), "    Passed:{v:7.1f}".format(v=round(100-(100 * totalFails / totalTests), 1)), "%", sep="")
    print(generateStringRepeats(auto_test_testStatistics_totalLength, '='))


