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
# 25-Jan-2021	Initial Version (Design) inkl first version of Ctr and testing
#
# ------------------------------------------------------------------
from waltisLibrary import *

class Bruch:
    def __init__(self, zaehler=0, nenner=1):
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

    def toDecimal(self, roundAfter=2):
        return self.__zaehler / self.__nenner


bruch1 = Bruch()
print(bruch1)