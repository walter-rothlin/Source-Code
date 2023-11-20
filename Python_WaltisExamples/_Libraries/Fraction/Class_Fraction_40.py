#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Fraction.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Fraction/Class_Fraction_40.py
#
# Description: Implementiert einen Bruch (Farction) and the basics oparators
#
#
# Autor: Walter Rothlin
#
# History:
# 11-Oct-2022	Walter Rothlin  Initial Version __int__ __str__ and main
# 12-Oct-2022	Walter Rothlin  Kehrwert und automated testing
# 12-Oct-2022	Walter Rothlin  Add to_decimal(), mul(), div(), add(), sub() und automated testing
#                               Mod __str__
# 12-Oct-2022	Walter Rothlin  Implementing business methods
# 12-Oct-2022   Walter Rothlin  Implemented operators * / + and -
# 12-Oct-2022   Walter Rothlin  Simplifying automated testing
#
# ------------------------------------------------------------------
import math
class Fraction:
    """
    Provides basic support for math operations with fractions
    """

    # Standard methods
    def __init__(self, zaehler=0, nenner=1):
        """
        - Check if nenner is not 0
        - only one sign
        - only Integers no floats nor string,....
        """
        self.set_zaehler(zaehler)
        self.set_nenner(nenner)

    def __str__(self):
        """
        - Erzeugt eine String-Representation eines Bruches in der Form [3/4]
        """

        lcm = math.lcm(3, 6, 9)
        gcd = math.gcd(45, 15, 30)
        print('lcm:', lcm)
        print('gcd:', gcd)

        return self.to_string()


    def prettyprint(self):
        """Gibt den Bruch dreizeilig aus, wobei Zähler und Nenner
        zentriert gesetzt sind.
        """
        zaehler_str = str(self.__zaehler)
        nenner_str = str(self.__nenner)
        feldbreite = max(len(zaehler_str), len(nenner_str))
        bruchstrich = "-" * feldbreite
        return f'''
                {zaehler_str.center(feldbreite)}
                {bruchstrich}
                {nenner_str.center(feldbreite)}
                '''
    def to_string(self, sep="/", startChr="[", endChar="]"):
        return startChr + str(self.__zaehler) + sep + str(self.__nenner) + endChar

    # setter / getters and properties
    def set_zaehler(self, zaehler):
        self.__zaehler = zaehler

    def get_zaehler(self):
        return self.__zaehler

    zaehler = property(get_zaehler, set_zaehler)

    def set_nenner(self, nenner):
        self.__nenner = nenner

    def get_nenner(self):
        return self.__nenner

    nenner = property(get_nenner, set_nenner)

    # unary business methods
    def reciprocal(self):
        """
        - setzt self moit dem Kehrwert [1/2] ==> [2/1]
        """
        tmp = self.__zaehler
        self.__zaehler = self.__nenner
        self.__nenner = tmp
        return self

    def to_decimal(self, roundAfter=2):
        return round(self.__zaehler / self.__nenner, roundAfter)

    def shorten(self, divisor=1):
        self.__zaehler = int(self.__zaehler / divisor)
        self.__nenner = int(self.__nenner / divisor)
        return self

    def expand(self, factor=1):
        self.__zaehler = int(self.__zaehler * factor)
        self.__nenner = int(self.__nenner * factor)
        return self

    # binary business methods
    # -----------------------
    def mul(self, factor):
        return Fraction(self.__zaehler * factor.__zaehler, self.__nenner * factor.__nenner)

    # overload * operator
    def __mul__(self, factor):
        return self.mul(factor)



    def div(self, divisor):
        return Fraction(self.__zaehler * divisor.__nenner, self.__nenner * divisor.__zaehler)

    # overload / operator
    def __truediv__(self, divisor):
        return self.div(divisor)



    def add(self, summand):
        self.__zaehler = self.__zaehler * summand.__nenner + summand.__zaehler * self.__nenner
        self.__nenner = self.__nenner * summand.__nenner
        return self

    # overload + operator
    def __add__(self, summand):
        return self.add(summand)



    def sub(self, subtrahend):
        self.__zaehler = self.__zaehler * subtrahend.__nenner - subtrahend.__zaehler * self.__nenner
        self.__nenner = self.__nenner * subtrahend.__nenner
        return self

    # overload - operator
    def __sub__(self, subtrahend):
        return self.sub(subtrahend)




# static test methods
def TEST_SIMPLE_init_str(verbal=False):
    # Test Ctr and toString()
    testsPerformed = 0
    testsFailed = 0
    testCases = """
    Type|Zaehler |Nenner |Expected
    Ctr |1       |2      |[1/2]
    Ctr |3       |4      |[3/4]
    Ctr |6       |7      |[6/7]
    Ctr |1       |4      |[1/4]
    Ctr |2       |7      |[2/7]
    Ctr |55      |72     |[55/72]
    Ctr |-5      |40     |[-5/40]
    Ctr |5       |-40    |[5/-40]
    Ctr |7       |-40    |[5/-40]
    """

    listOfTestCases = testCases.split("\n")
    for aTestCase in listOfTestCases[2:-1]:
        testsPerformed += 1
        listOfTestValues = aTestCase.split("|")
        param_1 = int(listOfTestValues[1].strip())
        param_2 = int(listOfTestValues[2].strip())

        expectedResult = listOfTestValues[3].strip()
        bruch_1 = Fraction(zaehler=param_1, nenner=param_2)
        if str(bruch_1) != expectedResult:
            testsFailed += 1
            print("Error: Testcase ", testsPerformed)
            print("Fraction(", param_1, ",", param_2, ") = ", str(bruch_1), "    Expected:", expectedResult, sep="")
            print()
    print("\n\n")
    print("==> Test-Statistics Class_Bruch: Tests Performed:", testsPerformed, "   Tests Failed:", testsFailed, "    Passed:", round(100-(100 * testsFailed / testsPerformed),1), "%", sep="" )



def TEST_setter_getter_properties(verbal=False):
    error_count = 0
    test_count = 0

    bruch = Fraction()
    bruch.set_zaehler(1)
    bruch.set_nenner(2)
    expected = "[1/2]"
    test_count += 1
    if str(bruch) != expected:
        print("2." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction()
    bruch.zaehler = 7
    bruch.nenner = 8
    expected = "[7/8]"
    test_count += 1
    if str(bruch) != expected:
        print("2." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    if verbal:
        print("2) Test Setter / Getter and Properties")
        print("--------------------------------------")
        print("     Test performed: ", test_count)
        print("     Test failed   : ", error_count)
        print("\n")

def TEST_reciprocal_to_decimal_shorten_expand(verbal=False):
    error_count = 0
    test_count = 0

    # reciprocal
    bruch = Fraction(7, 8)
    bruch.reciprocal()
    expected = "[8/7]"
    test_count += 1
    if str(bruch) != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(3, 4)
    bruch.reciprocal()
    expected = "[4/3]"
    test_count += 1
    if str(bruch) != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1


    # to_decimal
    bruch = Fraction(1, 8)
    actual = bruch.to_decimal(3)
    expected = 0.125
    test_count += 1
    if actual != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + str(expected) + "    Actual:" + str(actual))
        error_count += 1

    bruch = Fraction(1, 3)
    actual = bruch.to_decimal(2)
    expected = 0.33
    test_count += 1
    if actual != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + str(expected) + "    Actual:" + str(actual))
        error_count += 1

    # shorten
    bruch = Fraction(2, 8)
    actual = bruch.shorten(2)
    expected = "[1/4]"
    test_count += 1
    if str(bruch) != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + str(expected) + "    Actual:" + str(actual))
        error_count += 1

    # expand
    bruch = Fraction(2, 8)
    actual = bruch.expand(2)
    expected = "[4/16]"
    test_count += 1
    if str(bruch) != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + str(expected) + "    Actual:" + str(actual))
        error_count += 1


    if verbal:
        print("3) Test methode: reciprocal, to_decimal, shorten,  expand")
        print("--------------------------")
        print("     Test performed: ", test_count)
        print("     Test failed   : ", error_count)
        print("\n")

def TEST_mul_div_add_sub(verbal=False):
    error_count = 0
    test_count = 0

    bruch = Fraction(7, 8)
    bruch_1 = Fraction(7, 8)
    bruch.mul(bruch_1)
    expected = "[49/64]"
    test_count += 1
    if str(bruch) != expected:
        print("4." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(7, 8)
    bruch_1 = Fraction(1, 2)
    bruch.mul(bruch_1)
    expected = "[7/16]"
    test_count += 1
    if str(bruch) != expected:
        print("4." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 4)
    bruch.div(bruch_1)
    expected = "[4/6]"
    test_count += 1
    if str(bruch) != expected:
        print("4." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 4)
    bruch.add(bruch_1)
    expected = "[10/8]"
    test_count += 1
    if str(bruch) != expected:
        print("4." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 8)
    bruch.sub(bruch_1)
    expected = "[2/16]"
    test_count += 1
    if str(bruch) != expected:
        print("4." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    if verbal:
        print("4) Test method: mul, div, add, sub")
        print("--------------------------")
        print("     Test performed: ", test_count)
        print("     Test failed   : ", error_count)
        print("\n")

def TEST_mul_div_add_sub_operators(verbal=False):
    error_count = 0
    test_count = 0

    bruch = Fraction(7, 8)
    bruch_1 = Fraction(7, 8)
    bruch_resultat = bruch * bruch_1
    expected = "[49/64]"
    test_count += 1
    if str(bruch) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1

    bruch = Fraction(7, 8)
    bruch_1 = Fraction(1, 2)
    bruch_resultat = bruch * bruch_1
    expected = "[7/16]"
    test_count += 1
    if str(bruch) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 4)
    bruch_resultat = bruch / bruch_1
    expected = "[4/6]"
    test_count += 1
    if str(bruch) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 4)
    bruch_resultat = bruch + bruch_1
    expected = "[10/8]"
    test_count += 1
    if str(bruch) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 8)
    bruch_resultat = bruch - bruch_1
    expected = "[2/16]"
    test_count += 1
    if str(bruch) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1


    if verbal:
        print("5) Test method: mul, div, add, sub Operators")
        print("--------------------------")
        print("     Test performed: ", test_count)
        print("     Test failed   : ", error_count)
        print("\n")

if __name__ == '__main__':
    TEST_SIMPLE_init_str(verbal=True)
    # TEST_setter_getter_properties(verbal=True)
    # TEST_reciprocal_to_decimal_shorten_expand(verbal=True)
    # TEST_mul_div_add_sub(verbal=True)
    # TEST_mul_div_add_sub_operators(verbal=True)
