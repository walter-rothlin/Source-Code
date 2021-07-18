# Beispiel 6.23
#
# Suchen in Strings
#

# Ein Satz, der sich gut zum Durchsuchen eignet
satz = "Fischers Fritz fischt frische Fische Frische Fische fischt Fischers Fritz"

print("Folgender Satz wird durchsucht:")
print(satz + "\n")

# Feststellen, ob ein Teilstring enthalten ist
if "Fisch" in satz:
    print("Der Satz enthält \"Fisch\"")

# Zählen, wie oft ein Teilstring vorkommt
anzahl = satz.count("Fritz")
print("\"Fritz\" kommt {0} mal im Satz vor". format(anzahl))

# Position bestimmen, an der ein Teilstring zum ersten Mal vorkommt
erste =  satz.find("fischt")
print("\"fischt\" kommt an Position {0} zum ersten Mal vor".format(erste))

# Position bestimmen, an der ein Teilstring zum letzten Mal vorkommt
letzte = satz.rfind("fischt")
print("\"fischt\" kommt an Position {0} zum letzten Mal vor".format(letzte))

# Nur Bereiche durchsuchen
print("\nDurchsuchen von Bereichen:")
anzahl = satz.count("Fische", 30)
print("Durchsuchter Bereich:", satz[30:])
print("\"Fische\" kommt {0}-mal ab Index 30 vor". format(anzahl))

anzahl = satz.count("Fische", 30, 51)
print("\nDurchsuchter Bereich:", satz[30:51])
print("\"Fische\" kommt {0}-mal zwischen Index 30 und 51 vor". format(anzahl))
