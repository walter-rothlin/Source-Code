#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Car.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/School_Examples/Car.py
#
# Description: Beispiel einer Klasse und Sub-Klasse mit Properties,....
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
# 28-Jun-2022   Walter Rothlin      Property (leistung)
# 20-Nov-2023   Walter Rothlin      Extended for HBU_2023
# 20-Nov-2023   Walter Rothlin      Splitted Racecar und Car in two files
# ------------------------------------------------------------------
from Car import *

class Racecar(Car):
    """This class represents a racecar, which is a type of car."""
    def __init__(self, marke="Ferrari", farbe="rot", v=0, maxSpeed=200, gewicht=800):
        """
        Initializes a new Racecar object.

        :param marke: The brand of the racecar.
        :param farbe: The color of the racecar.
        :param v: The speed of the racecar.
        :param maxSpeed: The maximum speed of the racecar.
        :param gewicht: The weight of the racecar.
        """
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

    print(waltisCar.car_color)
    # ! # waltisCar.car_color = 'blue'        # kein Setter für car_color property defined
    # ! # print(waltisCar.__color)      # gibt runtime-fehler
    print(waltisCar._Car__color)        # Don't do it that way!!!!
    waltisCar.Farbe = 'rot'             # Dynamische Attributte

    print(waltisCar.Farbe)
    print("Waltis Car after setSpeed:", waltisCar)
    print('\n')
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

    print("Read Property: ", claudiasCar.engine_power)
    claudiasCar.engine_power = "160.5"
    print("Public Attribute:", claudiasCar.engine_power)

    # Dynamische Attribute
    claudiasCar.aufkleber = "Baby on board!!"
    print(claudiasCar.aufkleber)
    # print(waltisCar.aufkleber) # gibt runtime Fehler

    # Zugriff auf Class-Variables
    print("Car.countOfCars:", Car.max_serien_nummer)
    Car.max_serien_nummer = 1000
    print("Car.countOfCars:", Car.max_serien_nummer)
    print("claudiasCar.countOfCars:", claudiasCar.max_serien_nummer)
    claudiasCar.max_serien_nummer = 555  # Not accessing Class variable, creating a dynamic attribute
    print("Car.countOfCars:", Car.max_serien_nummer)
    print("waltisCar.countOfCars:", waltisCar.max_serien_nummer)
    print("claudiasCar.countOfCars:", claudiasCar.max_serien_nummer)

    print("Statistic: ", Car.get_production_statistics())
    print("Statistic: ", claudiasCar.get_production_statistics())  # not designed for this



