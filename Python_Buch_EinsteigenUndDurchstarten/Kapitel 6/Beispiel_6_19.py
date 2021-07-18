# Beispiel 6.19
#
# Strings verbinden
#

# Vor- und Nachname abfragen
vorname = input("Bitte Vorname eingeben: ")
nachname = input("Bitte Nachname eingeben: ")

# Addition zum vollständigen Namen
name = vorname + " " + nachname

# Eine Begrüßung zusammenbauen
begruessung = "Hallo, " + name + "!"
print(begruessung)

# Die Begrüßung erweitern
while True:
    zusatz = input("Zusatz für Begrüßung eingeben: ")

    if zusatz == "":
        break
    else:
        begruessung += (" " + zusatz)

print(begruessung)

# Einen String multiplizieren
ralph_sagt = "Ente "
ralph_sagt *= 8

print("Ralph sagt:", ralph_sagt)
