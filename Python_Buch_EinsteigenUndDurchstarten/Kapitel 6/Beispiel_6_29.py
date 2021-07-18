# Beispiel 6.29
#
# Löschen von Dictionary-Einträgen
#

# Vorrat an Essbarem
vorrat = {"Knoblauch": 2, "Eier": 12, "Brot": 2, "Zwiebeln": 8, "Karotten": 4}
print("Das hast Du noch im Vorrat:", vorrat)

# Element aus Liste entfernen
del vorrat["Eier"]

# Noch ein Element entfernen
nahrungsmittel = "Zwiebeln"
anzahl = vorrat.pop(nahrungsmittel)
print("Es wurde {0}x {1} aus dem Vorrat entnommen".format(anzahl, nahrungsmittel))

# Durch Default-Wert eine mögliche Exception verhindern
nahrungsmittel = "Käse"
anzahl = vorrat.pop(nahrungsmittel, 0)
print("Es wurde {0}x {1} aus dem Vorrat entnommen".format(anzahl, nahrungsmittel))

print("\nAktueller Vorrat:", vorrat)

# Es wird gegessen, was gerade da ist :(
if vorrat:
    was, wieviel = vorrat.popitem()
    print("\nHeute gibt es {0} {1} zum Abendessen. Naja :/ ".format(wieviel, was))

# Dictionary leeren
print("Heimlich alles aufessen!")
vorrat.clear()
print("Aktueller Vorrat:", vorrat)
