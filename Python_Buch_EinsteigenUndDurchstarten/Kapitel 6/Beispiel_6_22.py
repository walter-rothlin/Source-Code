# Beispiel 6.22
#
# upper, lower und swapcase
#

# Liste fiktiver CD-Keys für ein noch viel fiktiveres Spiel
cd_keys = ["7B89-FD19-001A-EE89", "8F93-317E-FFA4-364B", "B987-2DED-22CA-9192"]

# So lange abfragen, bis die Keys übereinstimmen
while True:
    eingabe = input("Bitte den CD-Key eingeben: ")
    eingabe = eingabe.upper()  # Alle Buchstaben in Großbuchstaben umwandeln

    print("Ihre Eingabe lautete:", eingabe)

    # Die Eingabe überprüfen
    if eingabe in cd_keys:
        print("Spiel wurde freigeschaltet!")
        break
    else:
        print("Der eingegebene CD-Key ist nicht korrekt. Bitte erneut versuchen!")

# Es ist auch möglich, die Groß- und Kleinschreibung zu vertauschen
name = input("Bitte gib Deinen Namen ein: ")
name = name.swapcase()
print("Groß-/Kleinschreibung vertauscht:", name)
