# Definiert ein Standardauto mit einen Attriubten
#
# Author: Mike Keller
#
# History:
# 19.10.2021 Initial Version
# ----------------------------------------------------------------------------------------------------------------------

class Car:
    def __init__(self, marke="Ford", farbe="Blau", leistung=560, previousOwner=None, kmStand=10):
        self.marke = marke
        self.farbe = farbe
        self.leistung = leistung
        self.previousOwner = previousOwner
        self.__kmStand = kmStand

    @property
    def kmStand(self):
        return self.__kmStand

    @kmStand.setter
    def kmStand(self, neuKmStand):
        if(self.__kmStand < neuKmStand):
            self.__kmStand = neuKmStand
        else:
            raise ValueError("Eine Tachomanipulation ist nicht zulässig!")

    def __str__(self):
        retStr = "Ein Car\n"
        retStr += "Marke: " + self.marke + "\n"
        retStr += "Farbe: " + self.farbe + "\n"
        retStr += "Leistung: " + str(self.leistung) + "\n"
        retStr += "Kilometerstand: " + str(self.__kmStand) + "\n"
        retStr += "Vorheriger Besitzer: " + str(self.previousOwner) + "\n"     # has a relation
        return retStr