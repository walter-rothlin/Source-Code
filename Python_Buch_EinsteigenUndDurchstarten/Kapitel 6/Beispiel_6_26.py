# Beispiel 6.26
#
# Ein einfaches Dictionary
#

# Dictionary erzeugen und ausgeben
schmelzpunkte = {"Fluor": -220, "Krypton": -157, "Argon": 64, "Gold": 1064}
print("Schmelzpunkte:", schmelzpunkte)

# Schmelzpunkt von Krypton bestimmen
temperatur = schmelzpunkte["Krypton"]
print("Krypton schmilzt bei {0} Grad Celsius".format(temperatur))

# Schmelzpunkt von Gold bestimmen
temperatur = schmelzpunkte["Gold"]
print("Gold schmilzt bei {0} Grad Celsius".format(temperatur))
