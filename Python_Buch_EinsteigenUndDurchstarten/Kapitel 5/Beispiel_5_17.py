# Beispiel 5.17
#
# Binden von Methoden - 1
#


# Klassendefinition (Hund)
class Hund:
    def __init__(self, name):
        self.name = name

    def belle_namen(self):
        print("Wuff:", self.name)


# Hunde erzeugen und bellen lassen
merlin = Hund("Merlin")
merlin.belle_namen()

lucky = Hund("Lucky")
lucky.belle_namen()

# Details anzeigen
print("Details zur Klasse Hund:", Hund)
print("Details zur Instanz 'merlin':", merlin)
print("Details zur Instanz 'lucky':", lucky)
print("'belle_namen' der Klasse 'Hund':", Hund.belle_namen)

# "belle_namen" ist eigentlich auch nur eine Funktion
print("\nDirekter Aufruf:")
Hund.belle_namen(lucky)

# Weitere Details anzeigen
print("\n------------------------")
print("'belle_namen' der Instanz 'merlin':", merlin.belle_namen)
print("'belle_namen' der Instanz 'lucky':", lucky.belle_namen)
