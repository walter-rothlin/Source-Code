# ------------------------------------------------------------------
# Name: pythonBasics_07a_Classes_Objects_Inheritance.py
#
# Description: Example for Inheritance
#
# Autor: Walter Rothlin
#
# History:
# 04-Nov-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

class car:
    def __init__(self, marke="Opel", farbe="gelb", leistung=30.5, anzahl_tueren=2, carType="PW"):
        self.marke = marke
        self.farbe = farbe
        self.leistung = leistung
        self.anzahl_tueren = anzahl_tueren
        self.carType = carType

    def __str__(self):
        retStr = underline(self.carType) + "\n"
        retStr += str(type(self)) + "\n"
        retStr += "Marke        :" + self.marke + "\n"
        retStr += "Farbe        :" + self.farbe + "\n"
        retStr += "Leistung     :" + str(self.leistung) + "\n"
        if self.anzahl_tueren != 0:
            retStr += "Anzahl Türen :" + str(self.anzahl_tueren) + "\n"
        return retStr


class f1(car):
    def __init__(self, marke="Mercedes", farbe="grau", leistung=780, driver="Lewis Hamilton"):
        super().__init__(marke=marke, farbe=farbe, leistung=leistung, anzahl_tueren=0, carType="Formula 1")
        self.driver = driver

    def __str__(self):
        retStr = super().__str__()
        retStr += "Driver       :" + str(self.driver) + "\n"
        return retStr




def placer(strichArt="-", laenge=30):
    return strichArt * laenge


def underline(titleStr,strichArt="="):
    return titleStr + "\n" + placer(strichArt=strichArt, laenge=len(titleStr))


def abfrage():
    claudiasCar = car()
    print(type(claudiasCar))
    print(claudiasCar)

    mercedesCar = f1()
    print(type(mercedesCar))
    print(mercedesCar)

def neue_abfrage():
    antwort = input("Neue Autoabfrage [Ja, Nein]: ")
    while antwort == "Ja":
        abfrage()
        antwort = input("Neue Autoabfrage [Ja, Nein]: ")
    print("\nVielen Dank!")

if __name__ == '__main__':
    abfrage()
    neue_abfrage()
