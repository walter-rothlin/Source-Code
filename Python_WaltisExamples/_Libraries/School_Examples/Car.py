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
# 20-Nov-2023   Walter Rothlin      Added Colors as Enums
# ------------------------------------------------------------------
from enum import Enum

class Colors(Enum):
    RED         = 'FF0000'
    GREEN       = '00FF00'
    BLUE        = '0000FF'
    YELLOW      = 'FFFF00'
    BLACK       = '000000'
    WHITE       = 'FFFFFF'


class Car:
    """This class represents a basic car."""

    max_serien_nummer = 1000   # class-variable oder static instance variable: für alle erzeugte Objekte gemeinsam

    def __init__(self, marke="Alfa", farbe=Colors.WHITE, v=0, max_speed=130):
        """
        Initializes a new Car object.

        :param marke: The brand of the car.
        :param farbe: The color of the car.
        :param v: The speed of the car.
        :param max_speed: The maximum speed of the car.
        """
        self.__marke = marke
        self.__color = farbe
        self.__speed = v
        self.__maxSpeed = max_speed
        self.__leistung = 75
        self.__serial_number = Car.max_serien_nummer
        Car.max_serien_nummer += 1

    def __str__(self):
        return f"""
           Marke        :{self.__marke} 
           Farbe        :{str(self.__color.value)}  ({self.__color.name})
           Speed        :{str(self.__speed)}
           MaxSpeed     :{str(self.__maxSpeed)} 
           Leistung     :{str(self.__leistung)} 
           Serien-Nummer:{str(self.__serial_number)} 
           Max_Serien-Nummer:{str(Car.max_serien_nummer)}
        """

    ''' Operator Overloading for == '''
    def __eq__(self, otherObj):
        return self.__marke == otherObj.__marke

    def set_leistung(self, new_leistung, min_P=50, max_P=200, trace=True):
        """
        Sets the power of the car.

        :param new_leistung: The new power value.
        """
        if trace:
            print('Car::set_leistung() has been called!')

        try:
            newLeistung = float(new_leistung)
        except ValueError:
            newLeistung = 0

        if type(newLeistung) == float or type(newLeistung) == int:
            if max_P >= newLeistung >= min_P:
                self.__leistung = newLeistung
            else:
                print(newLeistung, "ist ausserhalb der Toleranz")
        else:
            print("'", newLeistung, "'", " falscher Datentyp für Leistung!", sep="")

    def getLeistung(self):
        """
        Gets the power of the car.

        :return: The power of the car.
        """
        print('get_leistung() has been called!')
        return self.__leistung

    engine_power = property(fget=getLeistung, fset=set_leistung)


    def setColor(self, newColor):
        self.__color = newColor

    def getColor(self):
        return self.__color

    car_color = property(fget=getColor)

    def setSpeed(self, newSpeed):
        if newSpeed > self.__maxSpeed:
            self.__speed = self.__maxSpeed
        else:
            self.__speed = newSpeed

    def getSpeed(self):
        return self.__speed

    def increaseSpeed(self, vDiff):
        self.setSpeed(self.__speed + vDiff)

    @staticmethod
    def get_production_statistics():
        return Car.max_serien_nummer

if __name__ == '__main__':
    waltisCar = Car("BMW")
    print("Waltis Car after init:", waltisCar)
    waltisCar.setSpeed(300)

    print(waltisCar.car_color)
    # ! # waltisCar.car_color = 'blue'        # kein Setter für car_color property defined
    # ! # print(waltisCar.__color)      # gibt runtime-fehler
    print(waltisCar._Car__color)        # Don't do it that way!!!!
    waltisCar.Farbe = Colors.RED             # Dynamische Attributte

    print(waltisCar.Farbe)
    print("Waltis Car after setSpeed:", waltisCar)
    print('\n')
    felixsCar = Car("Fiat", Colors.BLUE)
    print("Felixs Car:", felixsCar)
    felixsCar.increaseSpeed(10)
    felixsCar.increaseSpeed(125)
    print("Felixs Car:", felixsCar)

    print('\n')
    felixsCar = Car(marke='Fiat')
    waltisCar = Car(marke='Fiat')
    ## waltisCar = felixsCar
    if waltisCar == felixsCar:
        print("Felixs Car == Waltis Car")
    else:
        print("Felixs Car != Waltis Car")
    print('\n')


    claudiasCar = Car(farbe=Colors.GREEN)
    print("Claudias Car:", claudiasCar, "\n\n")

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



