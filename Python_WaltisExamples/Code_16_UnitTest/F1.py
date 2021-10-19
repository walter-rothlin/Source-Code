# Definiert ein simples F1 Auto (vor allem abgeleitet vom Auto und der Person)
#
# Author: Mike Keller
#
# History:
# 19.10.2021 Initial Version
# ----------------------------------------------------------------------------------------------------------------------

from Car import *
from Person import *


class F1(Car):       # is a relation
    def __init__(self, heckFluegelType="mittel"):
        self.__heckFluegelType = heckFluegelType
        hamilton = Person("Hamilton", "Lewis")
        super().__init__(marke="Mercedes", farbe="Schwarz", previousOwner=hamilton)

    def setMarke(self, marke):
        self.marke = marke

    @property
    def heckFluegelType(self):
        return self.__heckFluegelType

    @heckFluegelType.setter
    def heckFluegelType(self, newHeckFluegelType):
        self.__heckFluegelType = newHeckFluegelType

    def __str__(self):
        retStr = super().__str__()
        retStr += "HeckFlügel: " + str(self.__heckFluegelType) + "\n"

        return retStr