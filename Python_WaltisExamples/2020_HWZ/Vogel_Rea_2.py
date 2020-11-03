# Code von Rea Vogel:
''''
Nun stellen sich mir noch folgende Fragen:
-	Wie kann ich das «None» nach der jeweiligen Ausgabe weg kriegen?
-	Weshalb springt das Programm nach der zweiten Abfrage nicht in die while-Schleife resp. weshalb greift die Funktion «neue_abfrage» nicht?
'''

# Korrekturen von Walti:
'''
Du machst in der Methode ausgabe die print() aller Instance-Variablen. Einen Return Parameter gibst du nicht zurück! Später rufst du in der Methode abfrage print(favorite_car.ausgabe()) auf! Hier ist das print überflüssig, die ausgabe() nichts zurück gibt, hat die print Methode auch None zum Anzeigen.
Du kannst entweder abfrage wie folgt ändern:
def abfrage():
    favorite_car = favorite()
    print(placer())
    favorite_car.ausgabe()

oder was sauberer wäre, die ausgabe wie folgt:
def ausgabe(self):
    retStr = "\nIhr Traumauto:"
    retStr += "\nMarke:" + self.marke + "\n"
    retStr += "Farbe:" +  self.farbe + "\n"
    retStr += "Leistung:" + self.leistung + "\n"
    retStr += "Anzahl Türen:" + self.anzahl_tueren + "\n"
    return retStr

def abfrage():
    favorite_car = favorite()
    print(placer())
    print(favorite_car.ausgabe())

Das gleiche Problem ist bei der placer Methode!

Die Methode ausgabe() würde ich noch in __str__ umbenennen und du könntest direkt print(favorite_car) aufrufen!

Mein Code sieht dann wie folgt aus:
def __str__(self):
    retStr = "\nIhr Traumauto:"
    retStr += "\nMarke:" + self.marke + "\n"
    retStr += "Farbe:" +  self.farbe + "\n"
    retStr += "Leistung:" + self.leistung + "\n"
    retStr += "Anzahl Türen:" + self.anzahl_tueren + "\n"
    return retStr

def placer():
    return "-"*30

def abfrage():
    favorite_car = favorite()
    print(placer())
    print(favorite_car)


-	Weshalb springt das Programm nach der zweiten Abfrage nicht in die while-Schleife resp. weshalb greift die Funktion «neue_abfrage» nicht?
Dieses Problem kann ich mit diesem Code nicht reproduzieren. Es springt in die Schleife.

'''



class car:
    def __init__(self, marke, farbe, leistung, anzahl_tueren):
        self.marke = marke
        self.farbe = farbe
        self.leistung = leistung
        self.anzahl_tueren = anzahl_tueren

    def __str__(self):
        retStr = "\nIhr Traumauto:"
        retStr += "\nMarke:" + self.marke + "\n"
        retStr += "Farbe:" +  self.farbe + "\n"
        retStr += "Leistung:" + self.leistung + "\n"
        retStr += "Anzahl Türen:" + self.anzahl_tueren + "\n"
        return retStr


class favorite(car):
    def __init__(self):
        print("\nWie sieht Ihr Traumauto aus? Welche Merkmale hat es?")
        self.marke = input("\nMarke: ")
        self.farbe = input("Farbe: ")
        self.leistung = input("Leistung (in PS): ")
        self.anzahl_tueren = input("Anzahl Türen: ")

def placer():
    return "-"*30

def abfrage():
    favorite_car = favorite()
    print(placer())
    print(favorite_car)

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


