#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Fraction.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Fraction/Class_Fraction_10.py
#
# Description: Implementiert einen Bruch (Farction) and the basics oparators
#
#
# Autor: Walter Rothlin
#
# History:
# 11-Oct-2022	Walter Rothlin Initial Version __int__ __str__ and main
# 12-Oct-2022	Walter Rothlin Kehrwert und automated testing
#
# ------------------------------------------------------------------

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
        self.__zaehler = zaehler
        self.__nenner = nenner

    def __str__(self):
        """
        - Erzeugt eine String-Representation eines Bruches in der Form [3/4]
        """
        return "[" + str(self.__zaehler) + "/" + str(self.__nenner) + "]"

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

    # Business Methods
    def reciprocal(self):
        """
        - setzt self moit dem Kehrwert [1/2] ==> [2/1]
        """
        tmp = self.__zaehler
        self.__zaehler = self.__nenner
        self.__nenner = tmp
        return self


def TEST_init_str(verbal=False):
    error_count = 0
    test_count = 0

    bruch = Fraction()
    expected = "[0/1]"
    test_count += 1
    if str(bruch) != expected:
        print("1." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(5)
    expected = "[5/1]"
    test_count += 1
    if str(bruch) != expected:
        print("1." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(3, 4)
    expected = "[3/4]"
    test_count += 1
    if str(bruch) != expected:
        print("1." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(zaehler=3)
    expected = "[3/1]"
    test_count += 1
    if str(bruch) != expected:
        print("1." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(zaehler=5, nenner=2)
    expected = "[5/2]"
    test_count += 1
    if str(bruch) != expected:
        print("1." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    if verbal:
        print("1) Test __init__ and __str__")
        print("----------------------------")
        print("     Test performed: ", test_count)
        print("     Test failed   : ", error_count)
        print("\n")

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

def TEST_reciprocal(verbal=False):
    error_count = 0
    test_count = 0

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

    if verbal:
        print("3) Test reciprocal methode")
        print("--------------------------")
        print("     Test performed: ", test_count)
        print("     Test failed   : ", error_count)
        print("\n")


if __name__ == '__main__':
    TEST_init_str(verbal=True)
    TEST_setter_getter_properties(verbal=True)
    TEST_reciprocal(verbal=True)

