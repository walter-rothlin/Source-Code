#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Car.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HWZ/BWI_A21/Car.py
#
# Description: Library - Module
#
#
# Autor: Walter Rothlin
#
# History:
# 14-Jun-2022   Walter Rothlin      Initial Version (Class Car and derived class Racecar)
# 28-Jun-2022   Walter Rothlin      Property (leistung),
#                                   Dynamische Attribute (Aufkleber),
#                                   Klassvariablen (Wartungsintervall),
#                                   Statische Methoden (production_statistik)
# ------------------------------------------------------------------
class Car:

    def __init__(self, marke="Alfa", farbe="weiss", v=0, max_speed=130):
        self.__marke = marke
        self.__color = farbe
        self.__speed = v
        self.__maxSpeed = max_speed
        self.__leistung = 75

    def __str__(self):
        return """
           Marke:""" + self.__marke + """
           Farbe:""" + self.__color + """
           Speed:""" + str(self.__speed)

    def set_leistung(self, new_leistung):
        print('set_leistung() has been called!')
        # print("datentype:", str(type(newLeistung)))
        try:
            newLeistung = float(new_leistung)
        except ValueError:
            newLeistung = 0

        if type(newLeistung) == float or type(newLeistung) == int:
            if 200 >= newLeistung >= 50:
                self.__leistung = newLeistung
            else:
                print(newLeistung, "ist ausserhalb der Toleranz")
        else:
            print("'", newLeistung, "'", " falscher Datentyp für Leistung!", sep="")

    def getLeistung(self):
        print('get_leistung() has been called!')
        return self.__leistung

    enginePower = property(fget=getLeistung, fset=set_leistung)

    def setMarke(self, newMarke):
        self.__marke = newMarke

    def getMarke(self):
        return self.__marke

    def setColor(self, newColor):
        self.__color = newColor

    def getColor(self):
        return self.__color

    def setSpeed(self, newSpeed):
        if newSpeed > self.__maxSpeed:
            self.__speed = self.__maxSpeed
        else:
            self.__speed = newSpeed

    def getSpeed(self):
        return self.__speed

    def increaseSpeed(self, vDiff):
        self.setSpeed(self.__speed + vDiff)

class Racecar(Car):
    def __init__(self, marke="Ferrari", farbe="rot", v=0, maxSpeed=200, gewicht=800):
        super().__init__(marke=marke, farbe=farbe, v=v, max_speed=maxSpeed)
        self.__gewicht = gewicht

    def __str__(self):
        return "Racecar::" + "Gewicht:" + str(self.__gewicht) + super().__str__()

    def setSpeed(self, newSpeed):
        super().setSpeed(newSpeed)


if __name__ == '__main__':
    waltisCar = Car("BMW", "weiss")
    print("Waltis Car after init:", waltisCar)
    waltisCar.setSpeed(300)
    print("Waltis Car after setSpeed:", waltisCar)

    felixsCar = Car("Fiat", "blau")
    print("Felixs Car:", felixsCar)
    felixsCar.increaseSpeed(10)
    felixsCar.increaseSpeed(125)
    print("Felixs Car:", felixsCar)

    claudiasCar = Car(farbe="gruen")
    print("Claudias Car:", claudiasCar, "\n\n")


    schumisCar = Racecar(marke="Ferrari", farbe="rot", maxSpeed=340)
    print(schumisCar)
    schumisCar.setSpeed(223)
    print(schumisCar)


    print("\n\n")
    print("Zugriffstests")
    print("=============")
    print("Public Attribute:", claudiasCar.getLeistung())
    claudiasCar.set_leistung(10000)
    print("Public Attribute:", claudiasCar.getLeistung())

    claudiasCar.set_leistung(200)
    print("Public Attribute:", claudiasCar.getLeistung())
    claudiasCar.set_leistung(195.5)
    print("Public Attribute:", claudiasCar.getLeistung())
    claudiasCar.set_leistung("Schnelles Auto")
    print("Public Attribute:", claudiasCar.getLeistung())
    claudiasCar.set_leistung("157")
    print("Public Attribute:", claudiasCar.getLeistung())
    claudiasCar.set_leistung("157.5")
    print("Public Attribute:", claudiasCar.getLeistung())

    print("Read Property: ", claudiasCar.enginePower)
    claudiasCar.enginePower = "160.5"
    print("Public Attribute:", claudiasCar.enginePower)
