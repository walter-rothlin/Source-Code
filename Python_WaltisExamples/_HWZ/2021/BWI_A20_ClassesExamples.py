# Description: Example for Inheritance
#
# Autor: Walter Rothlin
#
# History:
# 12-Oct-2021   Walter Rothlin      Initial Version
# -------------------------------------------------------------------
from waltisLibrary import *
# -------------------------------------------------------------------
class Person:
    personCount = 0    # Class-Variable

    def __init__(self, name="", firstName="", adress="", plz=0, ort=""):
        self.__name = name           # private
        self._firstName = firstName
        self.street = adress         # public
        self.__plz = plz
        self.__ort = ort
        Person.personCount += 1      # Access of Class-Variable

    def __str__(self):
        retStr = self._firstName + " " + self.__name + "\n"
        retStr += self.street + "\n"
        if self.__plz is not None:
            retStr += str(self.__plz) + " "
        retStr += self.__ort
        return retStr

    ''' Setter and getter '''
    def setName(self, newName):
        if len(newName) > 5:
            self.__name = newName
        else:
            self.__name = "ERROR (not valid):" + newName
        return self.__name

    def getName(self):
        return self.__name


    def setFirstName(self, newValue):
        self._firstName = newValue
        return self._firstName

    def getFirstName(self):
        return self._firstName


    def setAdress(self, newValue):
        self.street = newValue
        return self.street

    def getAdress(self):
        return self.street


    def setPLZ(self, newValue):
        self.__plz = newValue
        return self.__plz

    def getPLZ(self):
        return self.__plz


    def setOrt(self, newValue):
        self.__ort = newValue
        return self.__ort

    def getOrt(self):
        return self.__ort


    ''' Other business methods '''
    def movedTo(self, adress="", plz=0, ort=""):
        self.street = adress
        self.__plz = plz
        self.__ort = ort


def TEST_ClassPerson():
    print("\n\n" + unterstreichen("TEST_ClassPerson"))
    claudia = Person("Collet", "Claudia", "Peterliwiese 33", 8855, "Wangen")
    print(claudia)

    # changing/reading state of object
    ''' print(claudia.__name)    # accessing an private instance variable (self.__name) causes an runtime error'''
    print("--> Owners self._firstName (public attribute):", claudia._firstName)
    print("--> Owners self.adress     (public attribute):", claudia.street)
    print("--> Calls setter with not a valid value      :", claudia.setName("Roth"))
    print("--> Calls setter with a valid value          :", claudia.setPLZ(9000))

    claudia.movedTo("Blumenweg 8", 8853, "Lachen")
    claudia.setName("Rothlin")
    print("\n")
    print(claudia)

if __name__ == '__main__' and False:
    TEST_ClassPerson()


# -------------------------------------------------------------------
class Car:
    def __init__(self, marke="Porsche", farbe="grau", leistung=700, anz_tueren=3, car_type="911", bau_jahr=2021, km_stand=10, maxSpeed=300, priviousOwner=None):
        self.__marke = marke
        self.farbe = farbe
        self.leistung = leistung
        self.anz_tueren = anz_tueren
        self.__carType = car_type    # private (only within the class itself)
        self.baujahr = bau_jahr      # public
        self._kmStand = km_stand     # protected
        self.maxSpeed = maxSpeed
        self.__priviousOwner = priviousOwner   # has a relation

    def __str__(self):
        retStr = "Ein Car\n"
        retStr += "    Marke     :" + self.__marke + "   " + self.__carType + "   (" + self.farbe + ")\n"
        retStr += "    Leistung  :" + str(self.leistung) + "\n"
        retStr += "    Anz Türen :" + str(self.anz_tueren) + "\n"
        retStr += "    km-Stand  :" + str(self._kmStand) + "\n"
        retStr += "    maxSpeed  :" + str(self.maxSpeed) + "\n"
        retStr += "    Baujahr   :" + str(self.baujahr) + "\n"
        retStr += "    Privious Owner:\n" + str(self.__priviousOwner) + "\n"
        return retStr

    ''' Setter and getter '''
    def setKmStand(self, neuerKmStand):
        if self._kmStand < neuerKmStand:
            self._kmStand = neuerKmStand
        else:
            print("Illegal Setting!")
        return self._kmStand

    def getKmStand(self):
        return self._kmStand


    def setCarType(self, newType):
        self.__carType = newType
        return self.__carType

    def getCarType(self):
        return self.__carType


    def setFarbe(self, newColor):
        self.farbe = newColor
        return self.farbe

    def getFarbe(self):
        return self.farbe


    def setPrivOwner(self, newValue):
        self.__priviousOwner = newValue
        return self.__priviousOwner

    def getPrivOwner(self):
        return self.__priviousOwner

def TEST_ClassCar():
    print("\n\n" + unterstreichen("TEST_ClassCar"))
    felixMuster = Person("Muster", "Felix", "Testarea 33", 8007, "Testhausen")
    waltisCar = Car()
    print(waltisCar)

    johnsCar = Car(marke="Ferrari", farbe="rot", km_stand=50000, priviousOwner=felixMuster)
    print(johnsCar)

    johnsCar.__carType = "Carrera"
    print("--> Type set (Carrera) as private attribute  :", johnsCar.__carType)       # it is private, only via setter
    print("--> Type read via getter                     :", johnsCar.getCarType())
    print("--> Type set  via setter                     :", johnsCar.setCarType("Carrera Turbo"), "\n")

    johnsCar._kmStand = 50005
    print("--> kmStand read (50005) as protected attribute  :", johnsCar._kmStand)
    print("--> kmStand set                                  :", johnsCar.setKmStand(60000))
    print("--> kmStand set                                  :", johnsCar.setKmStand(30000), "\n")

    johnsCar.farbe = "blau"
    print("--> Type set (blau) as public attribute  :", johnsCar.farbe)
    print("--> Type read via getter                 :", johnsCar.getFarbe())
    print("--> Type set  via setter                 :", johnsCar.setFarbe("Rosa"), "\n")

    print(johnsCar)

if __name__ == '__main__' and False:
    TEST_ClassCar()

# -------------------------------------------------------------------
class F1(Car):   # is a relation
    def __init__(self, heckFluegelType="Mittel", marke="Mercedes", carType="Silberpfeil", baujahr=2019, priviousOwner=None):
        self.__heckfluegeltype = heckFluegelType
        super().__init__(marke=marke, car_type=carType, bau_jahr=baujahr, priviousOwner=priviousOwner)

    def __str__(self):
        retStr = "Ein F1 Car\n"
        retStr += "    Heckflügel :" + self.__heckfluegeltype + "\n"
        retStr += super().__str__()
        return retStr

    ''' Setter and getter '''
    def setHeckfluegeltype(self, newValue):
        self.__heckfluegeltype = newValue
        return self.__heckfluegeltype

    def getHeckfluegeltype(self):
        return self.__heckfluegeltype


    def setCarType(self, carType):
        # self.__carType = carType  # no access to private instance variables in super-class
        super().setCarType(carType) # only via public methods from super class
        return super().getCarType()

    def getCarType(self):
        return super().getCarType()


    def setBaujahr(self, baujahr):
        self.baujahr = baujahr      # access to public instance variables in super-class
        return self.baujahr

    def getBaujahr(self):
        return self.baujahr


    def setDriver(self, newVal):
        newSetVal = super().setPrivOwner(newVal)
        return newSetVal

    def getDriver(self):
        return super().getPrivOwner()


def TEST_ClassF1():
    print("\n\n" + unterstreichen("TEST_ClassF1"))
    driver_1 = Person("Hamilton", "Lewis", "", None, "Stevenage (GB)")
    driver_2 = Person("Bottas", "Valtteri", "", None, "Nastola (Finnland)")
    print("--> Count of People:", Person.personCount)

    hamiltonsCar = F1(priviousOwner=driver_1)
    print(hamiltonsCar)

    print("--> Heckfluegel set (Megagross) via setter  :", hamiltonsCar.setHeckfluegeltype("Megagross"))
    print("--> Type        set (A3)        via setter  :", hamiltonsCar.setCarType("A3"))
    print("--> Baujahr     set (2000)      via setter  :", hamiltonsCar.setBaujahr(2000))
    print("--> Driver      set (Bottas)    via setter  :", hamiltonsCar.setDriver(driver_2))
    print(hamiltonsCar)

if __name__ == '__main__' and True:
    TEST_ClassF1()





