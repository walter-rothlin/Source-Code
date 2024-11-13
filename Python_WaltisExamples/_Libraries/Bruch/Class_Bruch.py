#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Bruch.py
#
# Description: Implementiert einen Bruch (Farction) and the basics oparators
#
#
# Autor: Walter Rothlin
#
# History:
# 25-Jan-2021	Initial Version (Design) inkl first version of Ctr
# 25-Jan-2021	Added Testing part (inkl __str__)
# 25-Jan-2021	Added toDecimal()
# 25-Jan-2021	Make Class ready for reference application (re-use) and docstring
# 26-Jan-2021	Introduced automated testing
# 12-Nov-2024	Changes for HFU
# ------------------------------------------------------------------
from waltisLibrary import *



class Bruch:
    def __init__(self, zaehler=0, nenner=1):
        self.__zaehler = zaehler
        self.__nenner = nenner

    def __eq__(self,bruch_2):
        return (self.__zaehler == bruch_2.__zaehler and self.__nenner == bruch_2.__nenner)


    def __str__(self, sep="/", startChr="[", endChar="]"):
        return startChr + str(self.__zaehler) + sep + str(self.__nenner) + endChar

    def add(self, summand):
        return self

    def sub(self, subtrahend):
        return self

    def mul(self, factor):
        """
        Initialisiert Objekt

        :param factor: factor_2

        """
        # new_bruch = Bruch(self.__zaehler * factor.__zaehler, self.__nenner * factor.__nenner)
        # return new_bruch.kuerzen()
        self.__zaehler *= factor.__zaehler
        self.__nenner *= factor.__nenner
        self.kuerzen()
        return self


    def __mul__(self, factor):
        return self.mul(factor)

    def div(self, divisor):
        return self

    def kuerzen(self):
        divisor = gcd(self.__zaehler, self.__nenner)
        self.__zaehler = int(self.__zaehler / divisor)
        self.__nenner = int(self.__nenner / divisor)

    def shorten(self, divisor=1):
        return self

    def expand(self, factor=1):
        return self

    def reciprocal(self):
        return self

    def get_value(self):
        return self.__zaehler / self.__nenner

    value = property(get_value)


    def toDecimal(self, roundAfter = None):
        """
            Return:    a string representation of a Bruch.

            Parameter: roundAfter defines the rounding

            Example:  print(bruch3.toDecimal())
                      print(bruch3.toDecimal(2))

        """
        if roundAfter is None:
            return self.value
        else:
            return round(self.value, roundAfter)




if __name__ == '__main__':
    # print(unterstreichen("Automated Test-Cases from Class_Bruch"))

    bruch_1 = Bruch(1, 2)
    bruch_2 = Bruch(1, 2)
    bruch_3 = Bruch(2, 4)
    if bruch_1 == bruch_2:
        print(f'1 ok ) {bruch_1} == {bruch_2}')
    else:
        print(f'1 nok) {bruch_1} != {bruch_2}')

    if bruch_1 == bruch_3:
        print(f'2 nok) {bruch_1} == {bruch_3}')
    else:
        print(f'2 ok ) {bruch_1} != {bruch_3}')

    bruch_4 = bruch_1.mul(bruch_2)
    if bruch_4 == Bruch(1, 4):
        print(f'3 ok ) {bruch_1}.mul({bruch_2} = {bruch_4})   Expected: [1/4]')
    else:
        print(f'3 nok) {bruch_1}.mul({bruch_2} = {bruch_4})   Expected: [1/4]')

    bruch_4 = bruch_1 * bruch_2
    if bruch_4 == Bruch(1, 4):
        print(f'4 ok ) {bruch_1} * {bruch_2} = {bruch_4})   Expected: [1/4]')
    else:
        print(f'4 nok) {bruch_1} * {bruch_2} = {bruch_4})   Expected: [1/4]')

    print(f'5 ) {bruch_1.value} {bruch_2.value} {bruch_3.value} {bruch_4.value}')

    bruch_3.kuerzen()
    print(f'6 ) {bruch_3} Expected: [1/2]')

    # Test Ctr and toString()
    testsPerformed = 0
    testsFailed = 0
    testCases = """
    Type|Zaehler |Nenner |bStr  |Expected
    Ctr |1       |2      |      |[1/20]
    Ctr |3       |4      |      |[3/40]
    Ctr |6       |7      |      |[3/40]
    Ctr |        |       |      |[3/40]
    """

    listOfTestCases = testCases.split("\n")
    for aTestCase in listOfTestCases[2:-1]:
        testsPerformed += 1
        listOfTestValues = aTestCase.split("|")
        try:
            param_1 = int(listOfTestValues[1].strip())
            param_2 = int(listOfTestValues[2].strip())
        except ValueError as error:
            param_1_ok = False
            param_2_ok = False

        param_3 = listOfTestValues[3].strip()
        if len(param_3) >= 1:
            param_3_ok = True
        # else:
        #     param

        expectedResult = listOfTestValues[4].strip()
        bruch_1 = Bruch(zaehler=param_1, nenner=param_2)
        if str(bruch_1) != expectedResult:
            testsFailed += 1
            print("Error: Testcase ", testsPerformed)
            print("Bruch(", param_1, ",", param_2, ") = ", str(bruch_1), "    Expected:", expectedResult, sep="")
            print()
    print("\n\n")
    print("==> Test-Statistics Class_Bruch: Tests Performed:", testsPerformed, "   Tests Failed:", testsFailed, "    Passed:", round(100 * testsFailed / testsPerformed,1), "%", sep="" )



    # Test business methods
    # bruch3 = Bruch(nenner=3, zaehler=1)
    # print(bruch3)
    # print(bruch3.toDecimal())
    # print(bruch3.toDecimal(2))
