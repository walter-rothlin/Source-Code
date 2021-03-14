#!/usr/bin/python3
import math

# Physikalische Umrechnungs-Functionen
# ------------------------------------
def grad2Rad(grad):
    return math.pi*grad/180

def rad2Grad(rad):
    return 180*rad/math.pi

def fahrenheit2Celsius(fahrenheit):
    return (fahrenheit-32)/1.8

def celsius2Fahrenheit(celsius):
    return (celsius*1.8)+32

# Math Functionen
# ---------------
def fakultaet(obergrenze, untergrenze=1):
    # Spezifikation: untergrenze*..*5*6*...*obergrenze
    # Test-Cases
    # ----------
    # fakultaet(10, 1) = 3628800
    # fakultaet(15, 13) = 2730
    # fakultaet(8, 3) = 20160
    # fakultaet(99, 98) = 9702
    # fakultaet(3) = 6
    # fakultaet(5) = 120

    fakultaet = -1
    if (obergrenze > 0):
        fakultaet = 1
        while obergrenze >= untergrenze:
            fakultaet = fakultaet * obergrenze
            obergrenze = obergrenze - 1
    return fakultaet

# File Functionen
# ---------------
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

    # File in eine Liste lesen
    with open(sourceFileFN, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # In Liste Range löschen
    del lines[deleteLineFrom-1:deleteLineTo]

    # Liste in ein File schreiben
    with open(destinationFileFN, "w", encoding="utf-8") as f:
        f.writelines(lines)


def AUTO_TEST_FileFunctions(verbal=False):
    testsPerformed = 0
    testsFailed = 0

    testSuite = "FileFunctions"

    fct = "File_getCountOfLines()"

    case = 1
    testsPerformed += 1
    File_createTestFile("./TestData/Test_1.txt")
    countOfLine = File_getCountOfLines("./TestData/Test_1.txt")
    expectedResult = 20
    if (countOfLine != expectedResult):
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(./TestData/Test_1.txt)", "Result: ", File_getCountOfLines("./TestData/Test_1.txt"), "   Expected:", expectedResult)
        testsFailed += 1

    case = 2
    testsPerformed += 1
    File_createTestFile("./TestData/Test_2.txt", aHeader="Nr |", aContent=" | Content", aFooter="File Ende", startLineNr=5, endLineNr=45)
    countOfLine = File_getCountOfLines("./TestData/Test_2.txt")
    expectedResult = 43
    if (countOfLine != expectedResult):
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(./TestData/Test_2.txt)", "Result: ", File_getCountOfLines("./TestData/Test_2.txt"), "   Expected:", expectedResult)
        testsFailed += 1

    fct = "File_deleteLines()"

    case = 1
    testsPerformed += 1
    testFileName = "./TestData/Test_1a.txt"
    expectedResult = 20
    File_deleteLines("./TestData/Test_1.txt", testFileName, deleteLineFrom=None, deleteLineTo=None, verbal=False)
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    case = 2
    testsPerformed += 1
    testFileName = "./TestData/Test_1b.txt"
    expectedResult = 14
    File_deleteLines("./TestData/Test_1.txt", testFileName, deleteLineFrom=2, deleteLineTo=7)
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    case = 3
    testsPerformed += 1
    testFileName = "./TestData/Test_1c.txt"
    expectedResult = 4
    File_deleteLines("./TestData/Test_1.txt", testFileName, deleteLineFrom=5)
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    case = 4
    testsPerformed += 1
    testFileName = "./TestData/Test_1d.txt"
    expectedResult = 13
    File_deleteLines("./TestData/Test_1.txt", testFileName, deleteLineTo=7)
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1


if __name__ == '__main__':
    # Automated Tests
    # ===============
    testStat = AUTO_TEST_FileFunctions(verbal=True)

    obergrenze = 10
    untergrenze = 1
    print("fakultaet(", obergrenze, ",", untergrenze, ") = 3628800", sep="")

    obergrenze = 15
    untergrenze = 13
    print("fakultaet(", obergrenze, ",", untergrenze, ") = 2730", sep="")

    obergrenze = 8
    untergrenze = 3
    print("fakultaet(", obergrenze, ",", untergrenze, ") = 20160", sep="")

    obergrenze = 99
    untergrenze = 98
    print("fakultaet(", obergrenze, ",", untergrenze, ") = 9702", sep="")
