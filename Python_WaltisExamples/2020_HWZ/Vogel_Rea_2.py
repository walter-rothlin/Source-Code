
class car:
    def __init__(self, marke="Opel", farbe="grau", leistung=150.5, anzahl_tueren=2):
        self.marke = marke
        self.farbe = farbe
        self.leistung = leistung
        self.anzahl_tueren = anzahl_tueren

    def __str__(self):
        retStr = "\nIhr Traumauto:"
        retStr += "\nMarke:       " + self.marke + "\n"
        retStr += "Farbe:       " +  self.farbe + "\n"
        retStr += "Leistung:    " + str(self.leistung) + "\n"
        retStr += "Anzahl Türen:" + str(self.anzahl_tueren) + "\n"
        return retStr


def placer(strichArt="-", laenge=30):
    return strichArt * laenge

def printPlacer(strichArt="-", laenge=30):
    print(placer(strichArt, laenge))

def abfrage():
    favorite_car = car()
    print(placer())
    print(placer(laenge=50, strichArt = "="))
    printPlacer(strichArt = "+")
    print(favorite_car)

def neue_abfrage():
    print("\nNeue Autoabfrage?")
    new = input("Ja oder Nein: ")
    while new == "Ja":
        abfrage()
        new = input("Ja oder Nein: ")
    else:
        print("\nVielen Dank!")

def main():
    abfrage()
    neue_abfrage()

main()


