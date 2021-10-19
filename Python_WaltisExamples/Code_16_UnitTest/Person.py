# Definiert eine kleine Person, in welcher nur der Vorname und Nachname definiert werden kann
#
# Author: Mike Keller
#
# History:
# 19.10.2021 Initial Version
# ----------------------------------------------------------------------------------------------------------------------

class Person:
    def __init__(self, name, firstName):
        self.__name = name
        self.__firstName = firstName

    @property
    def name(self):
        return self.__name

    @name.setter
    def name(self, neuerName):
        self.__name = neuerName

    @property
    def firstName(self):
        return self.__firstName

    @firstName.setter
    def firstName(self, neuerFirstName):
        self.__firstName = neuerFirstName

    def __str__(self):
        retStr = "Eine Person\n"
        retStr += "Nachname: " + str(self.__name) + "\n"
        retStr += "Vorname: " + str(self.__firstName) + "\n"

        return retStr