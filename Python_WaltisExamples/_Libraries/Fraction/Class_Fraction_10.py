#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Fraction.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/__Libraries/Fraction/Class_Fraction_10.py
#
# Description: Implementiert einen Bruch (Farction) and the basics oparators
#
#
# Autor: Walter Rothlin
#
# History:
# 11-Oct-2022	Walter Rothlin Initial Version __int__ __str__ and main
#
# ------------------------------------------------------------------

class Fraction:
    def __init__(self, zaehler=0, nenner=1):
        """
        - Check if nenner is not 0
        - only one sign
        - only Integers no floats nor string,....
        """
        self.__zaehler = zaehler
        self.__nenner = nenner

    def __str__(self):
        return "[" + str(self.__zaehler) + "/" + str(self.__nenner) + "]"



if __name__ == '__main__':
    bruch_1 = Fraction()
    bruch_2 = Fraction(5)
    bruch_3 = Fraction(3/4)
    bruch_4 = Fraction(zaehler=3)
    bruch_5 = Fraction(zaehler=5, nenner=2)

    print("bruch_1:", bruch_1)
    print("bruch_2:", bruch_2)
    print("bruch_3:", bruch_3)
    print("bruch_4:", bruch_4)
    print("bruch_5:", bruch_5)
