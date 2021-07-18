# Beispiel 5.19
#
# Binden von Methoden - 3
#


# Klassendefinition (Hund)
class Hund:
    def __init__(self, name):
        self.name = name

    def belle_namen(self):
        print("Wuff:", self.name)

# Die Klasse "Hund" soll erweitert werden. Hier sind unsere neuen Methoden.
def beschreibung():
    print("Ein Hund ist ein vierbeiniges Säugetier.")


def sitz():
    print("Hund macht Sitz")


# Zwei neue Hunde erzeugen
pluto = Hund("Pluto")
rantanplan = Hund("Rantanplan")

# Klasse "Hund" um eine statische Methode erweitern
Hund.beschreibung = staticmethod(beschreibung)
Hund.beschreibung()  # Der direkte Aufruf über den Klassennamen funktioniert...

# ...und auch der über eine Instanz
pluto.beschreibung()

# Nur Rantanplan kann sitzen, nicht alle Hunde. Hier erfolgt keine Bindung!
rantanplan.sitz = sitz
rantanplan.sitz()

# Detaillierte Ausgabe der Objekte, Funktionen und Methoden
print("\n------------------------")
print("Instanz 'pluto':", pluto)
print("Instanz 'rantanplan':", rantanplan)
print("\n------------------------")
print("Lokale Funktion 'beschreibung':", beschreibung)
print("\n------------------------")
print("Funktionen innerhalb der Klasse 'Hund':")
print(Hund.beschreibung)
print("\n------------------------")
print("Achtung, KEINE Bindung:")
print(pluto.beschreibung)
print(rantanplan.beschreibung)
print(rantanplan.sitz)
print("\n------------------------")


# Auch Ersetzen funktioniert!
print("Vor der Ersetzung von 'belle_namen':")
pluto.belle_namen()


def verschweige_namen(self):
    print("Das behalte ich für mich!")


Hund.belle_namen = verschweige_namen

print("Nach der Ersetzung von 'belle_namen':")
pluto.belle_namen()
