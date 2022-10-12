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
# 12-Oct-2022	Walter Rothlin Kehrwert und automated Testing
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
    def reciprocal(self):   # only Prototype
        tmp = self.__zaehler
        self.__zaehler = self.__nenner
        self.__nenner = self.__zaehler
        return self

if __name__ == '__main__':

    print("1) Test __init__ and __str__")
    print("----------------------------")
    bruch_1 = Fraction()
    print("1.1) bruch_1: [0/1]::", bruch_1)

    bruch_2 = Fraction(5)
    print("1.2) bruch_2: [5/1]::", bruch_2)

    bruch_3 = Fraction(3, 4)
    print("1.3) bruch_3: [3/4]::", bruch_3)

    bruch_4 = Fraction(zaehler=3)
    print("1.4) bruch_4: [3/1]::", bruch_4)

    bruch_5 = Fraction(zaehler=5, nenner=2)
    print("1.5) bruch_5: [5/2]::", bruch_5)

    print("\n")

    print("2) Test Setter / Getter and Properties")
    print("--------------------------------------")
    bruch_1.set_zaehler(1)
    bruch_1.set_nenner(2)
    print("2.1) bruch_1: [1/2]::", bruch_1)

    bruch_1.zaehler = 7
    bruch_1.nenner = 8
    print("2.2) bruch_1: [7/8]::", bruch_1)


    print("3) Test reciprocal methode")
    print("--------------------------")
    print("3.1) bruch_1: [8/7]::", bruch_1.reciprocal())
    print("\n")
