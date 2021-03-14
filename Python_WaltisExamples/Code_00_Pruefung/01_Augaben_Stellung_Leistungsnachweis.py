#!/usr/bin/python3
import math
import os
import shutil

# ================================================================================================================
# START: Aufgabenstellung
# ================================================================================================================

# Kreieren Sie ein neues Python-File mit dem Namen: 01_IhrVorname_IhrNachname_Leistungsnachweis.py
# Kopieren Sie alle Zeilen in diesem File in dies neu erstellte File und bringen Sie es ohne run-time Fehler zum Laufen.

# Danach machen sie folgende Schritte

# 1) Unten finden Sie Prototypen von Funktionen mit Spezifikation und Testcases.
# 2) Für jede Funktion hat es ebenfalls einen Protoype einer AUTO_TEST_ Funktion, welche im main bereits aufgerufen wird.
# 3) Führen Sie die Tests aus und implementieren (am Besten in dieser Reihenfolge) Sie nun alle Funktionen und
#    kontrollieren immer wieder durch Testen, wie weit Sie sind (Test-Driven Approach)
# 4) Lösen Sie wenn Sie alles gelöst haben die Bonus-Aufgabe



# Summen Reihen-Functionen
# ------------------------
def summeBis_MitFormel(bis):
    # Spezifikation: 1+2+3+4+5+6+...+bis = (bis * (bis+1) /2)   Der Returnparameter ist ein int
    # mit Gausschen Summenformel
    #
    # Test-Cases
    # ----------
    # summeBis_MitFormel(9) = 45
    # summeBis_MitFormel(4) = 10
    # summeBis_MitFormel(20) = 210

    return 4711

def summeBis_MitLoop(bis):
    # Spezifikation: 1+2+3+4+5+6+...+bis Der Returnparameter ist ein int
    # Informatiker Lösung (langsamer in der Ausführung)
    #
    # Test-Cases
    # ----------
    # summeBis_MitLoop(9) = 45
    # summeBis_MitLoop(4) = 10
    # summeBis_MitLoop(20) = 210

    return 4712

def summe(bis, von=None):
    # Spezifikation: von+..+5+6+...+bis
    #
    # Test-Cases
    # ----------
    # summe(9) = 45
    # summe(4) = 10
    # summe(20) = 210
    # summe(100) = 5050
    # summe(9, 4) = 39
    # summe(4, 9) = 39
    # summe(-1, 1) = 0

    return 4713

# String-Operationen
# ------------------
def generateStringRepeats(len, aStr = " "):
    # Spezifikation: Wiederholt den aStr so oft, dass der Return-String len lang ist
    #
    # Test-Cases
    # ----------
    # generateStringRepeats(10, '-')     => '----------'
    # generateStringRepeats(9,  '+-=')   => '+-=+-=+-='
    # generateStringRepeats(3,  'A')     => 'AAA'
    # generateStringRepeats(5, '.-')     => '.-.-.'
    # generateStringRepeats(6)           => '      '

    return "4711"

def unterstreichen(title, aChar="=", end="\n"):
    # Spezifikation: Unterstreich einen String auf dem Bildschirm
    #     Beispiel: print(unterstreichen('Die ist ein Test',"+")
    #               Die ist ein Test
    #               ++++++++++++++++
    #
    # Test-Cases
    # ----------
    # unterstreichen('Hallo')                     => 'Hallo\n====='
    # unterstreichen('Die ist ein Test',"+")      => 'Die ist ein Test\n++++++++++++++++'

    return "Unterstreichen\n=============="


# Testfunktionen für ihre in diesem Test erstellten Funktionen
# ==> Implementieren Sie hier alle vorgegebenen Testfälle
def AUTO_TEST_a_summeBis_MitFormel(verbal=False):
    # In dieser Testfunktion sind schon alle Test-Fälle implementiert. Gehen Sie gleich zur nächsten Funktion
    testsPerformed = 0
    testsFailed = 0
    testSuite = "a_summeBis_MitFormel"

    # Test-Cases
    # ----------
    # summeBis_MitFormel(9) = 45
    # summeBis_MitFormel(4) = 10
    # summeBis_MitFormel(20) = 210
    testsPerformed += 1
    if summeBis_MitFormel(9) != 45:
        print("Failed in ", testSuite, "  Case:", testsPerformed)
        testsFailed += 1

    testsPerformed += 1
    if summeBis_MitFormel(4) != 10:
        print("Failed in ", testSuite, "  Case:", testsPerformed)
        testsFailed += 1

    testsPerformed += 1
    if summeBis_MitFormel(20) != 210:
        print("Failed in ", testSuite, "  Case:", testsPerformed)
        testsFailed += 1

    if verbal:
        print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]

def AUTO_TEST_a_summeBis_MitLoop(verbal=False):
    testsPerformed = 0
    testsFailed = 0
    testSuite = "a_summeBis_MitLoop"

    # Test-Cases
    # ----------
    # summeBis_MitFormel(9) = 45
    # summeBis_MitFormel(4) = 10
    # summeBis_MitFormel(20) = 210
    testsPerformed += 1
    if summeBis_MitFormel(9) != 45:
        print("Failed in ", testSuite, "  Case:", testsPerformed)
        testsFailed += 1

    if verbal:
        print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]

def AUTO_TEST_a_summe(verbal=False):
    testsPerformed = 0
    testsFailed = 0
    testSuite = "a_summe"

    # Test-Cases
    # ----------
    # summe(9) = 45
    # summe(4) = 10
    # summe(20) = 210
    # summe(100) = 5050
    # summe(9, 4) = 39
    # summe(4, 9) = 39
    # summe(-1, 1) = 0
    testsPerformed += 1
    if summe(9) != 45:
        print("Failed in ", testSuite, "  Case:", testsPerformed)
        testsFailed += 1

    if verbal:
        print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]


def AUTO_TEST_a_generateStringRepeats(verbal=False):
    testsPerformed = 0
    testsFailed = 0
    testSuite = "a_generateStringRepeats"

    # Test-Cases
    # ----------
    # generateStringRepeats(10, '-')     => '----------'
    # generateStringRepeats(9,  '+-=')   => '+-=+-=+-='
    # generateStringRepeats(3,  'A')     => 'AAA'
    # generateStringRepeats(5, '.-')     => '.-.-.'
    # generateStringRepeats(6)           => '      '
    testsPerformed += 1
    if generateStringRepeats(10, '-') != '----------':
        print("Failed in ", testSuite, "  Case:", testsPerformed)
        testsFailed += 1

    if verbal:
        print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]

def AUTO_TEST_a_unterstreichen(verbal=False):
    testsPerformed = 0
    testsFailed = 0
    testSuite = "a_unterstreichen"

    # Test-Cases
    # ----------
    # unterstreichen('Hallo')                     => 'Hallo\n====='
    # unterstreichen('Die ist ein Test',"+")      => 'Die ist ein Test\n++++++++++++++++'
    testsPerformed += 1
    if unterstreichen('Hallo') != 'Hallo\n=====':
        print("Failed in ", testSuite, "  Case:", testsPerformed)
        testsFailed += 1

    if verbal:
        print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]

# 1) BONUS-Aufgaben
def isFloatEquals(ist, soll, roundDezimals=3):
    # Test-Cases
    # ----------
    # isFloatEquals(4.5321,4.5329,2)      => True
    # isFloatEquals(4.5321,4.5329,3)      => False
    return True

# ==> Implementieren Sie hier eine AUTO_TEST_a_isFloatEquals Funktion und fügen Sie diese im Main dazu

# 2) BONUS-Aufgabe
def File_addHeader(sourceFileFN, destinationFileFN=None, headerStr= ""):

    if destinationFileFN is None:
        destinationFileFN = sourceFileFN

    # File in eine Liste lesen
    with open(sourceFileFN, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # Liste in ein File schreiben
    aTestFile = open(destinationFileFN, "w")
    aTestFile.writelines(lines)
    aTestFile.close()

# ==> Fixen Sie den Fehler (Eine AUTO_TEST_FileFunctions besteht bereits!)

# ================================================================================================================
# Ende: Aufgabenstellung
# ================================================================================================================

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

    fakultaet = -1
    if (obergrenze > 0):
        fakultaet = 1
        while obergrenze >= untergrenze:
            fakultaet = fakultaet * obergrenze
            obergrenze = obergrenze - 1
    return fakultaet

# File and Directory operations
# =============================
def createDirIfNotExists(dir_path= "./TestData", access_rights=0o755, verbal=False):
    try:
        ## os.mkdir(dir_path, access_rights)
        os.makedirs(dir_path, access_rights)
    except OSError:
        if verbal:
            print("Creation of the directory %s failed" % dir_path)
    else:
        if verbal:
            print("Successfully created the directory %s " % dir_path)

def deleteDir(dir_path= "./TestData", verbal=False):
    try:
        shutil.rmtree(dir_path)  # does it even if it contains files
        ## os.rmdir(dir_path)    # only if the director is empty
    except OSError:
        if verbal:
            print("Deletion of the directory %s failed" % dir_path)
    else:
        if verbal:
            print("Successfully deleted the directory %s " % dir_path)

# File Mainpulation Functionen
# ----------------------------
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

def AUTO_TEST_a_File_addHeader(verbal=False):
    testsPerformed = 0
    testsFailed = 0
    testSuite = "a_File_addHeader"

    testPath="./TestData/AUTO_TEST_a_File_addHeader"
    createDirIfNotExists(dir_path=testPath)

    testsPerformed += 1
    baseTestFile = testPath + "/Test_3.txt"
    testFileName = testPath + "/Test_3a.txt"

    File_createTestFile(baseTestFile)
    expectedResult = 22
    File_addHeader(baseTestFile, testFileName, headerStr="This is \na multiline String")
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":     case:", testsPerformed, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    testsPerformed += 1
    testFileName = testPath + "/Test_2b.txt"
    expectedResult = 21
    File_addHeader(baseTestFile, testFileName, headerStr="This is a singleline String")
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":     case:", testsPerformed, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    deleteDir(testPath)
    if verbal:
        print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]


def AUTO_TEST_FileFunctions(verbal=False):
    testsPerformed = 0
    testsFailed = 0

    testSuite = "AUTO_TEST_FileFunctions"

    testPath = "./TestData/AUTO_TEST_FileFunctions"
    createDirIfNotExists(dir_path=testPath)

    # -------------------------------------------------------------------------------
    fct = "File_getCountOfLines()"
    # -------------------------------------------------------------------------------
    case = 1
    testsPerformed += 1
    testFileName = testPath + "/Test_1.txt"
    File_createTestFile(testPath + "/Test_1.txt")
    countOfLine = File_getCountOfLines(testFileName)
    expectedResult = 20
    if (countOfLine != expectedResult):
        print("Error in testSuite:   ", testSuite, "(1):   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines("./TestData/Test_1.txt"), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    case = 2
    testsPerformed += 1
    testFileName = testPath + "/Test_2.txt"
    File_createTestFile(testFileName, aHeader="Nr |", aContent=" | Content", aFooter="File Ende", startLineNr=5, endLineNr=45)
    countOfLine = File_getCountOfLines(testPath + "/Test_2.txt")
    expectedResult = 43
    if (countOfLine != expectedResult):
        print("Error in testSuite:   ", testSuite, "(2):   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines("./TestData/Test_2.txt"), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1
    # -------------------------------------------------------------------------------
    fct = "File_deleteLines()"
    # -------------------------------------------------------------------------------
    case = 1
    testsPerformed += 1
    testFileName = testPath + "/Test_1a.txt"
    expectedResult = 20
    File_deleteLines(testPath + "/Test_1.txt", testFileName, deleteLineFrom=None, deleteLineTo=None, verbal=False)
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    case = 2
    testsPerformed += 1
    testFileName = testPath + "/Test_1b.txt"
    expectedResult = 14
    File_deleteLines(testPath + "/Test_1.txt", testFileName, deleteLineFrom=2, deleteLineTo=7)
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    case = 3
    testsPerformed += 1
    testFileName = testPath + "/Test_1c.txt"
    expectedResult = 4
    File_deleteLines(testPath + "/Test_1.txt", testFileName, deleteLineFrom=5)
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    case = 4
    testsPerformed += 1
    testFileName = testPath + "/Test_1d.txt"
    expectedResult = 13
    File_deleteLines(testPath + "/Test_1.txt", testFileName, deleteLineTo=7)
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ", File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    # -------------------------------------------------------------------------------
    fct = "File_addHeader()"
    # -------------------------------------------------------------------------------
    case = 1
    testsPerformed += 1
    testFileName = testPath + "/Test_1a.txt"
    expectedResult = 22
    File_addHeader(testFileName, headerStr="Hallo this ist ein \nHeader")
    if File_getCountOfLines(testFileName) != expectedResult:
        print("Error in testSuite:   ", testSuite, ":   ", fct, "    case:", case, sep="")
        print("    Test Failed: File_getCountOfLines(" + testFileName + ")", "Result: ",
              File_getCountOfLines(testFileName), "   Expected:", expectedResult, end="\n\n")
        testsFailed += 1

    #### TEST_getIncludeFileName()
    #### File_readWithInludes("./TestData/Test_1_With_Include_1.txt")
    deleteDir(testPath)
    if verbal:
        print("=>   ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v=testSuite), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsPerformed), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=testsFailed), "    Passed:{v:7.1f}".format(v=round(100-(100 * testsFailed / testsPerformed), 1)), "%", sep="")
    return [testsPerformed, testsFailed]


if __name__ == '__main__':
    # Automated Tests
    # ===============
    auto_test_suiteNameLength = 40
    auto_test_testStatistics_anzStellen = 4
    auto_test_testStatistics_totalLength = 107
    auto_test_fct_prefix = "AUTO_TEST_"
    auto_test_fct_prefix_len = len(auto_test_fct_prefix)

    doVerbal = True
    totalTests = [0, 0]
    testStat = AUTO_TEST_a_summeBis_MitFormel(verbal=doVerbal)
    totalTests[0] += testStat[0]
    totalTests[1] += testStat[1]

    testStat = AUTO_TEST_a_summeBis_MitLoop(verbal=doVerbal)
    totalTests[0] += testStat[0]
    totalTests[1] += testStat[1]

    testStat = AUTO_TEST_a_summe(verbal=doVerbal)
    totalTests[0] += testStat[0]
    totalTests[1] += testStat[1]

    testStat = AUTO_TEST_a_generateStringRepeats(verbal=doVerbal)
    totalTests[0] += testStat[0]
    totalTests[1] += testStat[1]

    testStat = AUTO_TEST_a_unterstreichen(verbal=doVerbal)
    totalTests[0] += testStat[0]
    totalTests[1] += testStat[1]

    testStat = AUTO_TEST_a_File_addHeader(verbal=doVerbal)
    totalTests[0] += testStat[0]
    totalTests[1] += testStat[1]

    deleteDir("./TestData")
    if doVerbal:
        print(generateStringRepeats(auto_test_testStatistics_totalLength, '-'))
        print("===> ", ("{v:"+str(auto_test_suiteNameLength)+"s}").format(v="Total:"), "Tests Performed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=totalTests[0]), "      Tests Failed:", ("{v:"+str(auto_test_testStatistics_anzStellen)+"d}").format(v=totalTests[1]), "    Passed:{v:7.1f}".format(v=round(100-(100 * totalTests[1] / totalTests[0]), 1)), "%", sep="")
        print(generateStringRepeats(auto_test_testStatistics_totalLength, '='))


    print("\n\n")
    ex_TestFaelle = 23
    print("Ihre provisorisches Prüfungsbewertung:")
    print("     Total zu implementierende Testfälle: {p:3d}".format(p=ex_TestFaelle))
    print("     Testfälle implementiert            : {p:3d}".format(p=totalTests[0]))
    print("     Testfälle failed                   : {p:3d}".format(p=totalTests[1]))
    p_testabdeckung = 100*totalTests[0]/ex_TestFaelle
    p_implement = 100 * (totalTests[0] - totalTests[1]) / totalTests[0]
    p_TotalPunkte = p_testabdeckung+p_implement
    print("\n")
    print("     Punkte für Testabdeckung        : {p:6.2f}".format(p=p_testabdeckung))
    print("     Punkte für Implementierung      : {p:6.2f}".format(p=p_implement))
    print("\n")
    print("     Total Punkte         : {p:6.2f}".format(p=p_TotalPunkte))
    print("     Provisorische Note   : {p:5.1f}".format(p=(5/200)*p_TotalPunkte + 1))
    print("                            =======")