# Beispiel 5.18
#
# Binden von Methoden - 2
#


# Klassendefinition (Hund)
class Hund:
    def __init__(self, name):
        self.name = name


# Die Klasse "Hund" soll erweitert werden. Hier sind unsere neuen Methoden
def stoeckchen_holen(self):
    print("{0} holt das Stöckchen!".format(self.name))


# Zwei neue Hunde erzeugen
pluto = Hund("Pluto")
rantanplan = Hund("Rantanplan")

# Klasse "Hund" erweitern
Hund.stoeckchen_holen = stoeckchen_holen

# Es klappt, Pluto und Rantanplan holen das Stöckchen!
pluto.stoeckchen_holen()
rantanplan.stoeckchen_holen()


# Detaillierte Ausgabe der Objekte, Funktionen und Methoden
print("\n------------------------")
print("Instanz 'pluto':", pluto)
print("Instanz 'rantanplan':", rantanplan)
print("\n------------------------")
print("Lokale Funktion:", stoeckchen_holen)
print("\n------------------------")
print("Funktionen innerhalb der Klasse 'Hund':")
print(Hund.stoeckchen_holen)
print("\n------------------------")
print("Gebundene Methoden:")
print(pluto.stoeckchen_holen)
print(rantanplan.stoeckchen_holen)
