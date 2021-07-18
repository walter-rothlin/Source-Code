# Beispiel 6.11
#
# Tiefes und flaches Kopieren
#
from copy import deepcopy


# Klassendefinition (Auto)
class Auto:
    def __init__(self, farbe):
        self.farbe = farbe


# Ein paar Autos erzeugen und damit eine Liste füllen
auto1 = Auto("Rot")
auto2 = Auto("Grün")

liste = [auto1, auto2]

# Neue Liste erzeugen, eine Kopie der vorherigen Liste?
liste_2 = liste

# Das Auto in der kopierten Liste verändern
liste_2[0].farbe = "Gelb"

# Beweisen, dass nur referenziert wird
print("Nach der Veränderung der flachen Kopie:")
print("auto1: ID:{0} - {1}".format(id(auto1), auto1.farbe))
print("liste[0]: ID:{0} - {1}".format(id(liste[0]), liste[0].farbe))
print("liste_2[0]: ID:{0} - {1}".format(id(liste_2[0]), liste_2[0].farbe))

# Eine tiefe Kopie erzeugen
liste_2 = deepcopy(liste)

# Wie wirkt sich die Veränderung aus?
liste_2[0].farbe = "Schwarz"

# Nur auf liste_2, so wie gewünscht!
print("\nNach der Veränderung der tiefen Kopie:")
print("auto1: ID:{0} - {1}".format(id(auto1), auto1.farbe))
print("liste[0]: ID:{0} - {1}".format(id(liste[0]), liste[0].farbe))
print("liste_2[0]: ID:{0} - {1}".format(id(liste_2[0]), liste_2[0].farbe))
