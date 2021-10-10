# ------------------------------------------------------------------
# Name: pythonBasics_07a_Classes_Objects_Inheritance.py
#
# Description: Example for Inheritance
#
# Autor: Walter Rothlin
#
# History:
# 04-Nov-2020   Walter Rothlin      Initial Version
# 10-Oct-2021   Walter Rothlin      Changed to be complied with PEP-8
# ------------------------------------------------------------------
from waltisLibrary import *

# --------------------------------------------------------------------------------------
class Person:
    personCount = 0    # Class-Variable

    def __init__(self, name="", firstName="", adress="", plz=0, ort=""):
        self.__name = name           # private
        self._firstName = firstName
        self.adress = adress         # public
        self.plz = plz
        self.ort = ort
        Person.personCount += 1


    def __str__(self):
        retStr = self._firstName + " " + self.__name + "\n"
        retStr += self.adress + "\n"
        if self.plz is not None:
            retStr += str(self.plz) + " "
        retStr += self.ort
        return retStr

    def getName(self):
        return self.__name

    def movedTo(self, adress="", plz=0, ort=""):
        self.adress = adress
        self.plz = plz
        self.ort = ort


def TEST_ClassPerson():
    print("\n\n" + unterstreichen("TEST_ClassPerson"))
    claudia = Person("Collet", "Claudia", "Peterliwiese 33", 8855, "Wangen")
    print(claudia)
    ## print(claudia.__name)    # accessing an private instance variable causes an runtime error
    print("--> Owners firstame via _ attribute   :", claudia._firstName)
    print("--> Owners adress via public attribute:", claudia.adress)

    claudia.movedTo("Blumenweg 8", 8853, "Lachen")
    print(claudia)

if __name__ == '__main__':
    TEST_ClassPerson()

# --------------------------------------------------------------------------------------
class Car:
    def __init__(self, marke="Opel", farbe="gelb", leistung=30.5, anzahl_tueren=2, carType="PW", maxSpeed=180, owner=None):
        self.__marke = marke
        self.__farbe = farbe
        self.__leistung = leistung
        self.__anzahl_tueren = anzahl_tueren
        self.__carType = carType
        self.__maxSpeed = maxSpeed
        self.__minSpeed = -3
        self.__owner = owner          # has a relation
        self.__speed = 0


    def __str__(self):
        retStr = underline(self.__carType) + "\n"
        retStr += str(type(self)) + "\n"
        retStr += "Marke        :" + self.__marke + "\n"
        retStr += "Farbe        :" + self.__farbe + "\n"
        retStr += "Leistung     :" + str(self.__leistung) + "\n"
        if self.__anzahl_tueren != 0:
            retStr += "Anzahl Türen :" + str(self.__anzahl_tueren) + "\n"
        if self.__owner is not None:
            retStr += "\nOwner:\n" + str(self.__owner) + "\n"
        return retStr

    def setSpeed(self, currentSpeed):
        if (currentSpeed > self.__maxSpeed):
            self.__speed = self.__maxSpeed
        elif (currentSpeed < self.__minSpeed):
            self.__speed = self.__minSpeed
        else:
            self.__speed = currentSpeed

    def getSpeed(self):
        return self.__speed

    def accelerate(self, acc):
        self.setSpeed(self.__speed + acc)

    def slowDown(self, dec):
        self.setSpeed(self.__speed - dec)

    def setOwner(self, newOwner):
        self.__owner = newOwner

    def getOwner(self):
        return self.__owner

    def getOwnersName(self):
        return self.__owner.getName()

def TEST_ClassCar():
    claudia = Person("Collet", "Claudia", "Peterliwiese 33", 8855, "Wangen")
    claudiasCar = Car()
    print(type(claudiasCar))
    print(claudiasCar)
    claudiasCar.setOwner(claudia)
    print(claudiasCar)
    print("--> Owners Name via getters:", claudiasCar.getOwner().getName())
    print("--> Owners Name via getter :", claudiasCar.getOwnersName())
    print("--> Count of People:", Person.personCount)

if __name__ == '__main__':
    print("\n\n" + unterstreichen("TEST_ClassCar"))
    TEST_ClassCar()

# --------------------------------------------------------------------------------------
class F1(Car):  # Ableiten, Vererben, Inherit, Sub-Class, is a relation
    def __init__(self, marke="Mercedes", farbe="grau", leistung=780, driver=None):
        super().__init__(marke=marke, farbe=farbe, leistung=leistung, anzahl_tueren=0, carType="Formula 1")
        self.driver = driver

    def __str__(self):
        retStr = super().__str__()
        retStr += "Driver:\n" + str(self.driver) + "\n"
        # print("--> Owners Name via attribute:", self.driver.__name)    # private instance variable
        print("--> Owners Name via getter        :", self.driver.getName())
        print("--> Owners firstName via attribute:", self.driver._firstName)
        print("--> Owners ort via attribute      :", self.driver.ort)
        return retStr

def TEST_ClassF1():
    driver = Person("Hamilton", "Lewis", "", None, "Stevenage (GB)")
    print("--> Count of People:", Person.personCount)
    mercedesCar = F1(driver = driver)
    print(type(mercedesCar))
    print(mercedesCar)
    print("Speed: ", mercedesCar.getSpeed())
    mercedesCar.setSpeed(40)
    print("Speed: ", mercedesCar.getSpeed())
    mercedesCar.accelerate(100)
    print("Speed: ", mercedesCar.getSpeed())
    mercedesCar.accelerate(100)
    print("Speed: ", mercedesCar.getSpeed())
    mercedesCar.slowDown(100)
    print("Speed: ", mercedesCar.getSpeed())
    mercedesCar.slowDown(200)
    print("Speed: ", mercedesCar.getSpeed())

if __name__ == '__main__':
    print("\n\n" + unterstreichen("TEST_ClassF1"))
    TEST_ClassF1()

