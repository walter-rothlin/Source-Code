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
# ------------------------------------------------------------------
from waltisLibrary import *

class Bruch:
    def __init__(self, zaehler=0, nenner=1):
        """
        - Check if nenner is not 0
        - only one sign
        - only Integers no floats nor string,....
        """
        self.__zaehler = zaehler
        self.__nenner = nenner

    def add(self, summand):
        return self

    def sub(self, subtrahend):
        return self

    def mul(self, factor):
        return self

    def div(self, divisor):
        return self

    def shorten(self, divisor=1):
        return self

    def expand(self, factor=1):
        return self

    def reciprocal(self):
        return self

    def toDecimal(self, roundAfter = None):
        """
            Return:    a string representation of a Bruch.

            Parameter: roundAfter defines the rounding

            Example:  print(bruch3.toDecimal())
                      print(bruch3.toDecimal(2))

        """
        if roundAfter is None:
            return self.__zaehler / self.__nenner
        else:
            return round(self.__zaehler / self.__nenner, roundAfter)

    def __str__(self, sep="/", startChr="[", endChar="]"):
        return startChr + str(self.__zaehler) + sep + str(self.__nenner) + endChar


if __name__ == '__main__':
    print(unterstreichen("Test-Cases from Class_Bruch_40"))
    # Test Ctr and toString()
    bruch1 = Bruch()
    print(bruch1)

    bruch2 = Bruch(3, 4)
    print(bruch2.__str__(startChr="(", endChar=")", sep=":"))

    # Test business methods
    print(bruch2.toDecimal())
    bruch3 = Bruch(nenner=3, zaehler=1)
    print(bruch3)
    print(bruch3.toDecimal())
    print(bruch3.toDecimal(2))
