# Code von Rea Vogel:
''''
Nun stellen sich mir noch folgende Fragen:
-	Wie kann ich das «None» nach der jeweiligen Ausgabe weg kriegen?
-	Weshalb springt das Programm nach der zweiten Abfrage nicht in die while-Schleife resp. weshalb greift die Funktion «neue_abfrage» nicht?
'''


class car:
    def __init__(self, marke, farbe, leistung, anzahl_tueren):
        self.marke = marke
        self.farbe = farbe
        self.leistung = leistung
        self.anzahl_tueren = anzahl_tueren

    def ausgabe(self):
        print("\nIhr Traumauto:")
        print("\nMarke:", self.marke)
        print("Farbe:", self.farbe)
        print("Leistung:", self.leistung)
        print("Anzahl Türen:", self.anzahl_tueren)

class favorite(car):
    def __init__(self):
        print("\nWie sieht Ihr Traumauto aus? Welche Merkmale hat es?")
        self.marke = input("\nMarke: ")
        self.farbe = input("Farbe: ")
        self.leistung = input("Leistung (in PS): ")
        self.anzahl_tueren = input("Anzahl Türen: ")

def placer():
    print("-"*30)

def abfrage():
    favorite_car = favorite()
    print(placer())
    print(favorite_car.ausgabe())

def neue_abfrage():
    print("\nNeue Autoabfrage?")
    new = input("Ja oder Nein: ")
    while new == "Ja":
        abfrage()
    else:
        print("\nVielen Dank!")

def main():
    abfrage()
    neue_abfrage()

main()


